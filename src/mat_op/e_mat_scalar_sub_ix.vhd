LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
USE work.fixed_pkg.ALL;
USE work.pkg_tools.ALL;

ENTITY e_mat_scalar_sub_ix IS
    GENERIC(scalar : t_mat_elem := to_mat_elem(1.0));         
    PORT (    
        p_rst_i                 : IN STD_LOGIC;
        p_clk_i                 : IN STD_LOGIC;
        
        p_syn_rst_i             : IN STD_LOGIC;
        p_finished_o            : OUT STD_LOGIC;
        
        p_ix_i                  : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        
        p_mat_c_size_i          : IN t_mat_size; -- hier ist a IMMER gleich c -> weniger kopieraufwand
        p_mat_c_r_ix_o          : OUT t_mat_ix; -- c muss ausserdem row_by_row = 0 sein
        p_mat_c_data_i          : IN t_mat_word;
        
        p_mat_c_w_ix_o          : OUT t_mat_ix; 
        p_mat_c_data_o          : OUT t_mat_word;
        p_mat_c_size_o          : OUT t_mat_size
    );
END ENTITY e_mat_scalar_sub_ix;

----------------------------------------------------------------------------------------------------
--  Architecture
----------------------------------------------------------------------------------------------------
ARCHITECTURE a_mat_scalar_sub_ix OF e_mat_scalar_sub_ix IS

----------------------------------------------------------------------------------------------------
--  Signale
----------------------------------------------------------------------------------------------------
-- Zustaende
TYPE t_state IS (st_init, st_wait_read, st_write_0, st_write_1, st_finished); 
SIGNAL s_cur_state, s_next_state : t_state;
SIGNAL s_ix : t_mat_ix_elem;

----------------------------------------------------------------------------------------------------
--  Port Maps
----------------------------------------------------------------------------------------------------
BEGIN

----------------------------------------------------------------------------------------------------
--  Zuweisungen
----------------------------------------------------------------------------------------------------
p_mat_c_size_o <= p_mat_c_size_i;
s_ix <= t_mat_ix_elem(p_ix_i(t_mat_ix_elem'HIGH DOWNTO t_mat_ix_elem'LOW));

----------------------------------------------------------------------------------------------------
--  Prozesse
----------------------------------------------------------------------------------------------------

proc_calc : PROCESS(p_mat_c_data_i)
BEGIN
    FOR i IN p_mat_c_data_i'RANGE LOOP
        p_mat_c_data_o(i) <= to_mat_elem(p_mat_c_data_i(i) - scalar);
    END LOOP;
END PROCESS proc_calc;

proc_change_state : PROCESS(p_clk_i, p_rst_i)
BEGIN
    IF p_rst_i = '1' THEN 
        s_cur_state <= st_init;
    ELSIF rising_edge(p_clk_i) THEN
        IF p_syn_rst_i = '1' THEN
            s_cur_state <= st_init;
        ELSE
            s_cur_state <= s_next_state;
        END IF;
    END IF;
END PROCESS proc_change_state;


proc_calc_state : PROCESS(s_cur_state, p_mat_c_size_i, s_ix)
BEGIN
    CASE s_cur_state IS
                  
        WHEN st_init =>         s_next_state <= st_wait_read;

                                p_finished_o     <= '0';
                                p_mat_c_r_ix_o   <= (to_mat_ix_el(0), s_ix);
                                p_mat_c_w_ix_o   <= (to_mat_ix_el(0), s_ix);
    
        WHEN st_wait_read =>    s_next_state <= st_write_0;

                                p_finished_o     <= '0';
                                p_mat_c_r_ix_o   <= (to_mat_ix_el(32), s_ix);
                                p_mat_c_w_ix_o   <= (to_mat_ix_el(0), s_ix);
        
        WHEN st_write_0 =>      IF p_mat_c_size_i.max_col < t_mat_word'LENGTH THEN
                                    s_next_state <= st_finished;
                                ELSE
                                    s_next_state <= st_write_1;
                                END IF;

                                p_finished_o     <= '0';
                                p_mat_c_r_ix_o   <= ((OTHERS => '-'), (OTHERS => '-'));     -- todo: geht das so????
                                p_mat_c_w_ix_o   <= (to_mat_ix_el(0), s_ix);

        WHEN st_write_1 =>      s_next_state <= st_finished;

                                p_finished_o     <= '0';
                                p_mat_c_r_ix_o   <= ((OTHERS => '-'), (OTHERS => '-'));     -- todo: geht das so????
                                p_mat_c_w_ix_o   <= (to_mat_ix_el(32), s_ix);

        WHEN st_finished =>     s_next_state <= s_cur_state;

                                p_finished_o     <= '1';
                                p_mat_c_r_ix_o   <= ((OTHERS => '-'), (OTHERS => '-'));     -- todo: geht das so????
                                p_mat_c_w_ix_o   <= ((OTHERS => '-'), (OTHERS => '-'));     -- todo: geht das so????
        
    END CASE;
END PROCESS proc_calc_state;


END ARCHITECTURE a_mat_scalar_sub_ix;