LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
USE work.fixed_pkg.ALL;
USE work.pkg_tools.ALL;

ENTITY e_mat_col_sum IS       
    PORT (    
        p_rst_i                 : IN STD_LOGIC;
        p_clk_i                 : IN STD_LOGIC;
        
        p_syn_rst_i             : IN STD_LOGIC;
        p_finished_o            : OUT STD_LOGIC;
        
        p_mat_a_size_i          : IN t_mat_size;
        p_mat_a_ix_o            : OUT t_mat_ix;
        p_mat_a_row_by_row_i    : IN STD_LOGIC; -- muss 0 sein
        p_mat_a_data_i          : IN t_mat_word;
        
        p_mat_c_ix_o            : OUT t_mat_ix; 
        p_mat_c_data_o          : OUT t_mat_word;
        p_mat_c_row_by_row_i    : IN STD_LOGIC; -- muss 1 sein
        p_mat_c_size_o          : OUT t_mat_size
    );
END ENTITY e_mat_col_sum;

----------------------------------------------------------------------------------------------------
--  Architecture
----------------------------------------------------------------------------------------------------
ARCHITECTURE a_mat_col_sum OF e_mat_col_sum IS

----------------------------------------------------------------------------------------------------
--  Komponenten
----------------------------------------------------------------------------------------------------

COMPONENT e_set_word_elem
    PORT (  
        p_rst_i                 : IN STD_LOGIC;
        p_clk_i                 : IN STD_LOGIC;
        p_syn_rst_i             : IN STD_LOGIC;
        
        p_ix_write_i            : IN t_mat_ix;
        p_word_done_i           : IN STD_LOGIC;
        
        p_elem_i                : IN t_mat_elem;
        p_row_by_row_i          : IN STD_LOGIC;
        p_size_i                : IN t_mat_size;
        
        p_word_o                : OUT t_mat_word;
        p_ix_write_o            : OUT t_mat_ix
    );
END COMPONENT;

COMPONENT e_mat_ix_gen
    GENERIC (inc_by_wordlen : BOOLEAN := TRUE);
    PORT (    
        p_rst_i                 : IN STD_LOGIC;
        p_clk_i                 : IN STD_LOGIC;
        
        p_syn_rst_i             : IN STD_LOGIC;
        p_finished_o            : OUT STD_LOGIC;
        p_word_done_i           : IN STD_LOGIC;
        
        p_size_i                : IN t_mat_size;
        p_row_by_row_i          : IN STD_LOGIC;
        p_mat_ix_t0_o           : OUT t_mat_ix;
        p_mat_ix_t2_o           : OUT t_mat_ix;
        p_first_elem_t1_o       : OUT STD_LOGIC
    );
END COMPONENT;

----------------------------------------------------------------------------------------------------
--  Signale
----------------------------------------------------------------------------------------------------
SIGNAL s_c_size : t_mat_size;
SIGNAL s_a_ix_t2, s_c_ix_t2 : t_mat_ix; 
SIGNAL s_result_t2, s_last_result_t2, s_last_result_t3 : t_mat_elem;
SIGNAL s_first_elem_t1, s_first_elem_t2, s_word_done : STD_LOGIC;

----------------------------------------------------------------------------------------------------
--  Port Maps
----------------------------------------------------------------------------------------------------
BEGIN

set_word_elem : e_set_word_elem
PORT MAP(
    p_rst_i             => p_rst_i,
    p_clk_i             => p_clk_i,
    p_syn_rst_i         => p_syn_rst_i,
    
    p_ix_write_i        => s_c_ix_t2,
    p_word_done_i       => s_word_done,
    
    p_elem_i            => s_result_t2,
    p_row_by_row_i      => p_mat_c_row_by_row_i,
    p_size_i            => s_c_size,
    
    p_word_o            => p_mat_c_data_o,
    p_ix_write_o        => p_mat_c_ix_o
);
 
ix_c_gen : e_mat_ix_gen
GENERIC MAP(inc_by_wordlen => TRUE)
PORT MAP(
    p_rst_i             => p_rst_i,
    p_clk_i             => p_clk_i,
    
    p_syn_rst_i         => p_syn_rst_i,
    p_finished_o        => p_finished_o,
    p_word_done_i       => '1',

    p_size_i            => p_mat_a_size_i,
    p_row_by_row_i      => p_mat_a_row_by_row_i,
    p_mat_ix_t0_o       => p_mat_a_ix_o,
    p_mat_ix_t2_o       => s_a_ix_t2,
    p_first_elem_t1_o   =>s_first_elem_t1
);

----------------------------------------------------------------------------------------------------
--  Zuweisungen
----------------------------------------------------------------------------------------------------

s_c_size <= (to_mat_size_el(1), p_mat_a_size_i.max_col);
s_c_ix_t2 <= (to_mat_ix_el(0), s_a_ix_t2.col);
p_mat_c_size_o <= s_c_size;
s_word_done <= to_sl(s_a_ix_t2.row /= to_mat_ix_el(0));
s_last_result_t2 <= to_mat_elem(0.0) WHEN to_bool(s_word_done OR s_first_elem_t2)
                    ELSE s_result_t2;

f_reg(p_rst_i, p_clk_i, p_syn_rst_i, s_first_elem_t1, s_first_elem_t2);
----------------------------------------------------------------------------------------------------
--  Prozesse
----------------------------------------------------------------------------------------------------

proc_sum : PROCESS(p_mat_a_data_i, s_last_result_t3)
VARIABLE 
    v_tmp : t_mat_elem;
BEGIN
    v_tmp := to_mat_elem(0.0);
    FOR i IN p_mat_a_data_i'RANGE LOOP
        v_tmp := to_mat_elem(p_mat_a_data_i(i) + v_tmp);
    END LOOP;
    s_result_t2 <= to_mat_elem(s_last_result_t3 + v_tmp);
END PROCESS proc_sum;

proc_registers : PROCESS(p_rst_i, p_clk_i, p_syn_rst_i, s_last_result_t2)
BEGIN
    IF p_rst_i = '1' THEN
        s_last_result_t3 <= to_mat_elem(0.0);
    ELSIF RISING_EDGE(p_clk_i) THEN
        IF p_syn_rst_i = '1' THEN
            s_last_result_t3 <= to_mat_elem(0.0);
        ELSE
            s_last_result_t3 <= s_last_result_t2;
        END IF;
    END IF;
END PROCESS proc_registers;

END ARCHITECTURE a_mat_col_sum;