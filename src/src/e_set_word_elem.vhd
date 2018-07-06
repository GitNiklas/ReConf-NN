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

-- todo evtl mit generate
proc_generate_s_word_o : PROCESS(s_word_ix, s_word_reg, p_elem_i)
BEGIN
    CASE RESIZE(s_word_ix mod 32, 5) IS
        WHEN TO_UNSIGNED( 0, 5)     =>  s_word_o <= (s_word_reg(31 DOWNTO 1) & p_elem_i);
        WHEN TO_UNSIGNED( 1, 5)     =>  s_word_o <= (s_word_reg(31 DOWNTO 2) & p_elem_i & s_word_reg(0));
        WHEN TO_UNSIGNED( 2, 5)     =>  s_word_o <= (s_word_reg(31 DOWNTO 3) & p_elem_i & s_word_reg(1 DOWNTO 0));
        WHEN TO_UNSIGNED( 3, 5)     =>  s_word_o <= (s_word_reg(31 DOWNTO 4) & p_elem_i & s_word_reg(2 DOWNTO 0));
        WHEN TO_UNSIGNED( 4, 5)     =>  s_word_o <= (s_word_reg(31 DOWNTO 5) & p_elem_i & s_word_reg(3 DOWNTO 0));
        WHEN TO_UNSIGNED( 5, 5)     =>  s_word_o <= (s_word_reg(31 DOWNTO 6) & p_elem_i & s_word_reg(4 DOWNTO 0));
        WHEN TO_UNSIGNED( 6, 5)     =>  s_word_o <= (s_word_reg(31 DOWNTO 7) & p_elem_i & s_word_reg(5 DOWNTO 0));
        WHEN TO_UNSIGNED( 7, 5)     =>  s_word_o <= (s_word_reg(31 DOWNTO 8) & p_elem_i & s_word_reg(6 DOWNTO 0));
        WHEN TO_UNSIGNED( 8, 5)     =>  s_word_o <= (s_word_reg(31 DOWNTO 9) & p_elem_i & s_word_reg(7 DOWNTO 0));
        WHEN TO_UNSIGNED( 9, 5)     =>  s_word_o <= (s_word_reg(31 DOWNTO 10) & p_elem_i & s_word_reg(8 DOWNTO 0));
        WHEN TO_UNSIGNED(10, 5)     =>  s_word_o <= (s_word_reg(31 DOWNTO 11) & p_elem_i & s_word_reg(9 DOWNTO 0));
        WHEN TO_UNSIGNED(11, 5)     =>  s_word_o <= (s_word_reg(31 DOWNTO 12) & p_elem_i & s_word_reg(10 DOWNTO 0));
        WHEN TO_UNSIGNED(12, 5)     =>  s_word_o <= (s_word_reg(31 DOWNTO 13) & p_elem_i & s_word_reg(11 DOWNTO 0));
        WHEN TO_UNSIGNED(13, 5)     =>  s_word_o <= (s_word_reg(31 DOWNTO 14) & p_elem_i & s_word_reg(12 DOWNTO 0));
        WHEN TO_UNSIGNED(14, 5)     =>  s_word_o <= (s_word_reg(31 DOWNTO 15) & p_elem_i & s_word_reg(13 DOWNTO 0));
        WHEN TO_UNSIGNED(15, 5)     =>  s_word_o <= (s_word_reg(31 DOWNTO 16) & p_elem_i & s_word_reg(14 DOWNTO 0));
        WHEN TO_UNSIGNED(16, 5)     =>  s_word_o <= (s_word_reg(31 DOWNTO 17) & p_elem_i & s_word_reg(15 DOWNTO 0));
        WHEN TO_UNSIGNED(17, 5)     =>  s_word_o <= (s_word_reg(31 DOWNTO 18) & p_elem_i & s_word_reg(16 DOWNTO 0));
        WHEN TO_UNSIGNED(18, 5)     =>  s_word_o <= (s_word_reg(31 DOWNTO 19) & p_elem_i & s_word_reg(17 DOWNTO 0));
        WHEN TO_UNSIGNED(19, 5)     =>  s_word_o <= (s_word_reg(31 DOWNTO 20) & p_elem_i & s_word_reg(18 DOWNTO 0));
        WHEN TO_UNSIGNED(20, 5)     =>  s_word_o <= (s_word_reg(31 DOWNTO 21) & p_elem_i & s_word_reg(19 DOWNTO 0));
        WHEN TO_UNSIGNED(21, 5)     =>  s_word_o <= (s_word_reg(31 DOWNTO 22) & p_elem_i & s_word_reg(20 DOWNTO 0));
        WHEN TO_UNSIGNED(22, 5)     =>  s_word_o <= (s_word_reg(31 DOWNTO 23) & p_elem_i & s_word_reg(21 DOWNTO 0));
        WHEN TO_UNSIGNED(23, 5)     =>  s_word_o <= (s_word_reg(31 DOWNTO 24) & p_elem_i & s_word_reg(22 DOWNTO 0));
        WHEN TO_UNSIGNED(24, 5)     =>  s_word_o <= (s_word_reg(31 DOWNTO 25) & p_elem_i & s_word_reg(23 DOWNTO 0));
        WHEN TO_UNSIGNED(25, 5)     =>  s_word_o <= (s_word_reg(31 DOWNTO 26) & p_elem_i & s_word_reg(24 DOWNTO 0));
        WHEN TO_UNSIGNED(26, 5)     =>  s_word_o <= (s_word_reg(31 DOWNTO 27) & p_elem_i & s_word_reg(25 DOWNTO 0));
        WHEN TO_UNSIGNED(27, 5)     =>  s_word_o <= (s_word_reg(31 DOWNTO 28) & p_elem_i & s_word_reg(26 DOWNTO 0));
        WHEN TO_UNSIGNED(28, 5)     =>  s_word_o <= (s_word_reg(31 DOWNTO 29) & p_elem_i & s_word_reg(27 DOWNTO 0));
        WHEN TO_UNSIGNED(29, 5)     =>  s_word_o <= (s_word_reg(31 DOWNTO 30) & p_elem_i & s_word_reg(28 DOWNTO 0));
        WHEN TO_UNSIGNED(30, 5)     =>  s_word_o <= (s_word_reg(31 DOWNTO 31) & p_elem_i & s_word_reg(29 DOWNTO 0));
        WHEN TO_UNSIGNED(31, 5)     =>  s_word_o <= (p_elem_i & s_word_reg(30 DOWNTO 0));
        WHEN OTHERS                 =>  s_word_o <=  s_word_reg; -- noetig fuer modelsim
    END CASE;
END PROCESS proc_generate_s_word_o;

END ARCHITECTURE a_set_word_elem;