LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
USE work.fixed_pkg.ALL;
USE work.pkg_tools.ALL;

ENTITY e_mega_mux IS       
    PORT (    
        p_sel_a_i               : IN t_mat_reg_ixs;
        p_sel_b_i               : IN t_mat_reg_ixs;
        p_sel_c_i               : IN t_mat_reg_ixs;
        
        p_reg_mat_size_o        : OUT t_mat_size_arr;
        p_reg_mat_size_i        : IN t_mat_size_arr;
        p_reg_ix_read_o         : OUT t_mat_ix_arr;
        p_reg_ix_write_o        : OUT t_mat_ix_arr;
        p_reg_wren_o            : OUT t_mat_logic_arr;
        p_reg_row_by_row_i      : IN  t_mat_logic_arr;
        p_reg_row_by_row_o      : OUT t_mat_logic_arr;
        p_reg_word_o            : OUT t_mat_word_arr;
        p_reg_word_i            : IN t_mat_word_arr;
     
        p_alu_a_data_o          : OUT t_mat_words; 
        p_alu_a_ix_read_i       : IN t_mat_ixs; 
        p_alu_a_size_o          : OUT t_mat_sizes;
        p_alu_a_row_by_row_o    : OUT t_op_std_logics;
        p_alu_b_data_o          : OUT t_mat_words;
        p_alu_b_ix_read_i       : IN t_mat_ixs;
        p_alu_b_size_o          : OUT t_mat_sizes;
        p_alu_b_row_by_row_o    : OUT t_op_std_logics;
        p_alu_c_data_i          : IN t_mat_words;
        p_alu_c_size_i          : IN t_mat_sizes;
        p_alu_c_row_by_row_i    : IN t_op_std_logics;
        p_alu_c_ix_write_i      : IN t_mat_ixs;
        p_alu_c_wren_i          : IN t_op_std_logics;
         
        p_write_a0_i            : IN STD_LOGIC;
        p_read_a0_i             : IN STD_LOGIC;
        p_data_a0_i             : IN t_mat_word;
        p_data_a0_o             : OUT t_mat_word; 
        p_ix_a0_i               : IN t_mat_ix;
        p_size_a0_i             : IN t_mat_size;
        p_row_by_row_a0_i       : IN STD_LOGIC;
        p_size_a0_o             : OUT t_mat_size; 
        p_row_by_row_a0_o       : OUT STD_LOGIC 
    );
END ENTITY e_mega_mux;

----------------------------------------------------------------------------------------------------
--  Architecture
----------------------------------------------------------------------------------------------------
ARCHITECTURE  a_mega_mux OF e_mega_mux IS

----------------------------------------------------------------------------------------------------
--  Signale
----------------------------------------------------------------------------------------------------
SIGNAL s_a_word_i : t_mat_words;
SIGNAL s_a_size_i : t_mat_sizes;
SIGNAL s_reg_row_by_row_i : t_op_std_logics;
SIGNAL s_reg_wren : t_mat_logic_arr; 
SIGNAL s_wren : STD_LOGIC;
SIGNAL s_wren_sel : UNSIGNED(3 DOWNTO 0);

----------------------------------------------------------------------------------------------------
--  Zuweisungen
----------------------------------------------------------------------------------------------------
BEGIN
p_alu_a_data_o <= s_a_word_i;
p_data_a0_o <= s_a_word_i(0);
p_alu_a_size_o <= s_a_size_i;
p_size_a0_o <= s_a_size_i(0);
p_reg_wren_o <= s_reg_wren;
p_row_by_row_a0_o <= s_reg_row_by_row_i(0);
p_alu_a_row_by_row_o <= s_reg_row_by_row_i;

----------------------------------------------------------------------------------------------------
--  Prozesse
----------------------------------------------------------------------------------------------------

proc_mux_read_ix : PROCESS(p_read_a0_i, p_ix_a0_i, p_sel_a_i, p_sel_b_i, p_alu_a_ix_read_i, p_alu_b_ix_read_i)
BEGIN
    FOR reg IN c_num_mat_regs-1 DOWNTO 0 LOOP
        p_reg_ix_read_o(reg) <= p_ix_a0_i; -- Standardwert
        
        FOR opnum IN c_num_parallel_op-1 DOWNTO 0 LOOP
            IF p_sel_a_i(opnum) = TO_UNSIGNED(reg, p_sel_a_i(opnum)'LENGTH) THEN
                p_reg_ix_read_o(reg) <= p_alu_a_ix_read_i(opnum);
            ELSIF p_sel_b_i(opnum) = TO_UNSIGNED(reg, p_sel_b_i(opnum)'LENGTH) THEN
                p_reg_ix_read_o(reg) <= p_alu_b_ix_read_i(opnum);
            END IF;
        END LOOP;
        
        IF p_read_a0_i = '1' THEN
            p_reg_ix_read_o(reg) <= p_ix_a0_i;
        END IF;
    END LOOP;
END PROCESS proc_mux_read_ix;

proc_mux_a : PROCESS(p_sel_a_i, p_reg_word_i, p_reg_mat_size_i, p_reg_row_by_row_i)
BEGIN
    FOR i IN c_num_parallel_op-1 DOWNTO 0 LOOP
        CASE p_sel_a_i(i) IS
            WHEN TO_UNSIGNED( 0, 4)  => s_a_word_i(i)           <= p_reg_word_i(0); 
                                        s_a_size_i(i)           <= p_reg_mat_size_i(0);
                                        s_reg_row_by_row_i(i)   <= p_reg_row_by_row_i(0);
            WHEN TO_UNSIGNED( 1, 4)  => s_a_word_i(i)           <= p_reg_word_i(1); 
                                        s_a_size_i(i)           <= p_reg_mat_size_i(1);
                                        s_reg_row_by_row_i(i)   <= p_reg_row_by_row_i(1);
            WHEN TO_UNSIGNED( 2, 4)  => s_a_word_i(i)           <= p_reg_word_i(2); 
                                        s_a_size_i(i)           <= p_reg_mat_size_i(2);
                                        s_reg_row_by_row_i(i)   <= p_reg_row_by_row_i(2);
            WHEN TO_UNSIGNED( 3, 4)  => s_a_word_i(i)           <= p_reg_word_i(3); 
                                        s_a_size_i(i)           <= p_reg_mat_size_i(3);
                                        s_reg_row_by_row_i(i)   <= p_reg_row_by_row_i(3);
            WHEN TO_UNSIGNED( 4, 4)  => s_a_word_i(i)           <= p_reg_word_i(4); 
                                        s_a_size_i(i)           <= p_reg_mat_size_i(4);
                                        s_reg_row_by_row_i(i)   <= p_reg_row_by_row_i(4);
            WHEN TO_UNSIGNED( 5, 4)  => s_a_word_i(i)           <= p_reg_word_i(5); 
                                        s_a_size_i(i)           <= p_reg_mat_size_i(5);
                                        s_reg_row_by_row_i(i)   <= p_reg_row_by_row_i(5);
            WHEN TO_UNSIGNED( 6, 4)  => s_a_word_i(i)           <= p_reg_word_i(6); 
                                        s_a_size_i(i)           <= p_reg_mat_size_i(6);
                                        s_reg_row_by_row_i(i)   <= p_reg_row_by_row_i(6);
            WHEN TO_UNSIGNED( 7, 4)  => s_a_word_i(i)           <= p_reg_word_i(7); 
                                        s_a_size_i(i)           <= p_reg_mat_size_i(7);
                                        s_reg_row_by_row_i(i)   <= p_reg_row_by_row_i(7);
            WHEN TO_UNSIGNED( 8, 4)  => s_a_word_i(i)           <= p_reg_word_i(8); 
                                        s_a_size_i(i)           <= p_reg_mat_size_i(8);
                                        s_reg_row_by_row_i(i)   <= p_reg_row_by_row_i(8);
            WHEN TO_UNSIGNED( 9, 4)  => s_a_word_i(i)           <= p_reg_word_i(9); 
                                        s_a_size_i(i)           <= p_reg_mat_size_i(9);
                                        s_reg_row_by_row_i(i)   <= p_reg_row_by_row_i(9);
            WHEN TO_UNSIGNED(10, 4)  => s_a_word_i(i)           <= p_reg_word_i(10); 
                                        s_a_size_i(i)           <= p_reg_mat_size_i(10);
                                        s_reg_row_by_row_i(i)   <= p_reg_row_by_row_i(10);
            WHEN TO_UNSIGNED(11, 4)  => s_a_word_i(i)           <= p_reg_word_i(11); 
                                        s_a_size_i(i)           <= p_reg_mat_size_i(11);
                                        s_reg_row_by_row_i(i)   <= p_reg_row_by_row_i(11);
            WHEN OTHERS             =>  s_a_word_i(i)           <= p_reg_word_i(0);  
                                        s_a_size_i(i)           <= p_reg_mat_size_i(0);
                                        s_reg_row_by_row_i(i)   <= p_reg_row_by_row_i(0);
        END CASE;
    END LOOP;
END PROCESS proc_mux_a;

proc_mux_b : PROCESS(p_sel_b_i, p_reg_word_i, p_reg_mat_size_i, p_reg_row_by_row_i)
BEGIN
    FOR i IN c_num_parallel_op-1 DOWNTO 0 LOOP
        CASE p_sel_b_i(i) IS
            WHEN TO_UNSIGNED( 0, 4)  => p_alu_b_data_o(i)       <= p_reg_word_i(0); 
                                        p_alu_b_size_o(i)       <= p_reg_mat_size_i(0);
                                        p_alu_b_row_by_row_o(i) <= p_reg_row_by_row_i(0);
            WHEN TO_UNSIGNED( 1, 4)  => p_alu_b_data_o(i)       <= p_reg_word_i(1); 
                                        p_alu_b_size_o(i)       <= p_reg_mat_size_i(1);
                                        p_alu_b_row_by_row_o(i) <= p_reg_row_by_row_i(1);
            WHEN TO_UNSIGNED( 2, 4)  => p_alu_b_data_o(i)       <= p_reg_word_i(2); 
                                        p_alu_b_size_o(i)       <= p_reg_mat_size_i(2);
                                        p_alu_b_row_by_row_o(i) <= p_reg_row_by_row_i(2);
            WHEN TO_UNSIGNED( 3, 4)  => p_alu_b_data_o(i)       <= p_reg_word_i(3); 
                                        p_alu_b_size_o(i)       <= p_reg_mat_size_i(3);
                                        p_alu_b_row_by_row_o(i) <= p_reg_row_by_row_i(3);
            WHEN TO_UNSIGNED( 4, 4)  => p_alu_b_data_o(i)       <= p_reg_word_i(4); 
                                        p_alu_b_size_o(i)       <= p_reg_mat_size_i(4);
                                        p_alu_b_row_by_row_o(i) <= p_reg_row_by_row_i(4);
            WHEN TO_UNSIGNED( 5, 4)  => p_alu_b_data_o(i)       <= p_reg_word_i(5); 
                                        p_alu_b_size_o(i)       <= p_reg_mat_size_i(5);
                                        p_alu_b_row_by_row_o(i) <= p_reg_row_by_row_i(5);
            WHEN TO_UNSIGNED( 6, 4)  => p_alu_b_data_o(i)       <= p_reg_word_i(6); 
                                        p_alu_b_size_o(i)       <= p_reg_mat_size_i(6);
                                        p_alu_b_row_by_row_o(i) <= p_reg_row_by_row_i(6);
            WHEN TO_UNSIGNED( 7, 4)  => p_alu_b_data_o(i)       <= p_reg_word_i(7); 
                                        p_alu_b_size_o(i)       <= p_reg_mat_size_i(7);
                                        p_alu_b_row_by_row_o(i) <= p_reg_row_by_row_i(7);
            WHEN TO_UNSIGNED( 8, 4)  => p_alu_b_data_o(i)       <= p_reg_word_i(8); 
                                        p_alu_b_size_o(i)       <= p_reg_mat_size_i(8);
                                        p_alu_b_row_by_row_o(i) <= p_reg_row_by_row_i(8);
            WHEN TO_UNSIGNED( 9, 4)  => p_alu_b_data_o(i)       <= p_reg_word_i(9); 
                                        p_alu_b_size_o(i)       <= p_reg_mat_size_i(9);
                                        p_alu_b_row_by_row_o(i) <= p_reg_row_by_row_i(9);
            WHEN TO_UNSIGNED(10, 4)  => p_alu_b_data_o(i)       <= p_reg_word_i(10); 
                                        p_alu_b_size_o(i)       <= p_reg_mat_size_i(10);
                                        p_alu_b_row_by_row_o(i) <= p_reg_row_by_row_i(10);
            WHEN TO_UNSIGNED(11, 4)  => p_alu_b_data_o(i)       <= p_reg_word_i(11); 
                                        p_alu_b_size_o(i)       <= p_reg_mat_size_i(11);
                                        p_alu_b_row_by_row_o(i) <= p_reg_row_by_row_i(11);
            WHEN OTHERS             =>  p_alu_b_data_o(i)       <= p_reg_word_i(0);  
                                        p_alu_b_size_o(i)       <= p_reg_mat_size_i(0);
                                        p_alu_b_row_by_row_o(i) <= p_reg_row_by_row_i(0);
        END CASE;
    END LOOP;
END PROCESS proc_mux_b;

proc_mux_write : PROCESS(p_sel_c_i, p_alu_c_wren_i, p_alu_c_size_i, p_alu_c_row_by_row_i, p_alu_c_ix_write_i, p_alu_c_data_i, p_sel_a_i, p_write_a0_i, p_size_a0_i, p_row_by_row_a0_i, p_ix_a0_i, p_data_a0_i)
BEGIN    
    FOR reg IN c_num_mat_regs-1 DOWNTO 0 LOOP 
        -- Standardwerte
            s_reg_wren(reg) <= '0';
            p_reg_mat_size_o(reg) <= p_size_a0_i;
            p_reg_row_by_row_o(reg) <= p_row_by_row_a0_i;
            p_reg_ix_write_o(reg) <= p_ix_a0_i;
            p_reg_word_o(reg) <= p_data_a0_i;
    
        FOR opnum IN c_num_parallel_op-1 DOWNTO 0 LOOP
            IF p_sel_c_i(opnum) = TO_UNSIGNED(reg, p_sel_a_i(opnum)'LENGTH) THEN
                s_reg_wren(reg) <= p_alu_c_wren_i(opnum);
                p_reg_mat_size_o(reg) <= p_alu_c_size_i(opnum);
                p_reg_row_by_row_o(reg) <= p_alu_c_row_by_row_i(opnum);
                p_reg_ix_write_o(reg) <= p_alu_c_ix_write_i(opnum);
                p_reg_word_o(reg) <= p_alu_c_data_i(opnum);
            END IF;
        END LOOP;
        
        IF p_write_a0_i = '1' AND p_sel_a_i(0) = to_mat_reg_ix(reg) THEN
            s_reg_wren(reg) <= '1';
            p_reg_mat_size_o(reg) <= p_size_a0_i;
            p_reg_row_by_row_o(reg) <= p_row_by_row_a0_i;
            p_reg_ix_write_o(reg) <= p_ix_a0_i;
            p_reg_word_o(reg) <= p_data_a0_i;
        END IF;
    END LOOP;
END PROCESS proc_mux_write;

END ARCHITECTURE a_mega_mux;
