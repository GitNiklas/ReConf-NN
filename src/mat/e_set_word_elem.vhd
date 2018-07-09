LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
USE work.pkg_tools.ALL;
USE work.fixed_pkg.ALL;

ENTITY e_set_word_elem IS       
    PORT (  
        p_rst_i             : IN STD_LOGIC;
        p_clk_i             : IN STD_LOGIC;
        p_syn_rst_i         : IN STD_LOGIC;
        
        p_ix_write_i        : IN t_mat_ix;
        p_word_done_i       : IN STD_LOGIC;
        
        p_elem_i            : IN t_mat_elem;
        p_row_by_row_i      : IN STD_LOGIC;
        p_size_i            : IN t_mat_size;
        
        p_word_o            : OUT t_mat_word;
        p_ix_write_o        : OUT t_mat_ix
    );
END ENTITY e_set_word_elem;

----------------------------------------------------------------------------------------------------
--  Architecture
----------------------------------------------------------------------------------------------------
ARCHITECTURE a_set_word_elem OF e_set_word_elem IS

----------------------------------------------------------------------------------------------------
--  Signale
----------------------------------------------------------------------------------------------------
SIGNAL s_word_o, s_word_reg : t_mat_word;
SIGNAL s_word_ix : t_mat_ix_elem;
SIGNAL s_next_word : STD_LOGIC;
SIGNAL s_word_index, s_c_max_word_index : t_mat_ix_elem;

BEGIN
----------------------------------------------------------------------------------------------------
--  Zuweisungen
----------------------------------------------------------------------------------------------------
p_ix_write_o        <= p_ix_write_i;
p_word_o            <= s_word_o;
s_word_ix           <= p_ix_write_i.col WHEN p_row_by_row_i = '1' ELSE p_ix_write_i.row;

s_word_index        <= p_ix_write_i.col WHEN p_row_by_row_i = '1' ELSE p_ix_write_i.row;
s_c_max_word_index  <= p_size_i.max_col WHEN p_row_by_row_i = '1' ELSE p_size_i.max_row;
s_next_word         <= (to_sl(s_word_index = s_c_max_word_index) OR to_sl(s_word_index = t_mat_word'LENGTH - 1)) AND p_word_done_i;
  
----------------------------------------------------------------------------------------------------
--  Prozesse
----------------------------------------------------------------------------------------------------

proc_reg : PROCESS(p_rst_i, p_clk_i, s_word_o)
BEGIN
    IF p_rst_i = '1' THEN
        s_word_reg <= c_mat_word_zero;
    ELSIF RISING_EDGE(p_clk_i) THEN
        IF p_syn_rst_i = '1' OR s_next_word = '1' THEN
            s_word_reg <= c_mat_word_zero;
        ELSE
            s_word_reg <= s_word_o;
        END IF;
    END IF;
END PROCESS proc_reg;

proc_generate_s_word_o : PROCESS(s_word_ix, s_word_reg, p_elem_i)
BEGIN
    s_word_o <= (s_word_reg(31 DOWNTO 1) & p_elem_i);
    
    FOR i IN 31 DOWNTO 0 LOOP
        IF RESIZE(s_word_ix mod 32, 5) = TO_UNSIGNED( i, 5) THEN
            s_word_o <= (s_word_reg(31 DOWNTO i+1) & p_elem_i & s_word_reg(i-1 DOWNTO 0));
        END IF;
    END LOOP;
END PROCESS proc_generate_s_word_o;

END ARCHITECTURE a_set_word_elem;