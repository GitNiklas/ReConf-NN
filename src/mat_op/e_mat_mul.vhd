LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
USE work.fixed_pkg.ALL;
USE work.pkg_tools.ALL;

ENTITY e_mat_mul IS       
    PORT (    
        p_rst_i                 : IN STD_LOGIC;
        p_clk_i                 : IN STD_LOGIC;
        
        p_syn_rst_i             : IN STD_LOGIC;
        p_finished_o            : OUT STD_LOGIC;
        
        p_mat_a_size_i          : IN t_mat_size;
        p_mat_a_ix_o            : OUT t_mat_ix;
        p_mat_a_data_i          : IN t_mat_word; -- a has to be line_by_line
        
        p_mat_b_size_i          : IN t_mat_size;
        p_mat_b_ix_o            : OUT t_mat_ix;
        p_mat_b_data_i          : IN t_mat_word; -- b has to be row_by_row

        p_mat_c_ix_o            : OUT t_mat_ix; 
        p_mat_c_data_o          : OUT t_mat_word;
        p_mat_c_row_by_row_i    : IN STD_LOGIC;
        p_mat_c_size_o          : OUT t_mat_size
    );
END ENTITY e_mat_mul;

----------------------------------------------------------------------------------------------------
--  Architecture
----------------------------------------------------------------------------------------------------
ARCHITECTURE a_mat_mul OF e_mat_mul IS

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

COMPONENT e_mat_mul_mul
    PORT (    
        p_mat_a_data_i      : IN t_mat_word;
        p_mat_b_data_i      : IN t_mat_word;
        p_last_result_i     : IN t_mat_elem;
        
        p_result_o          : OUT t_mat_elem
    );
END COMPONENT;

COMPONENT e_mat_mul_reg
    PORT (    
        p_rst_i                 : IN STD_LOGIC;
        p_clk_i                 : IN STD_LOGIC;
        p_syn_rst_i             : IN STD_LOGIC;
        
        p_last_result_i         : IN t_mat_elem;
        p_col_a_row_b_i         : IN t_mat_ix_elem;
        p_last_col_a_row_b_i    : IN STD_LOGIC;
        
        p_last_result_o         : OUT t_mat_elem;
        p_col_a_row_b_o         : OUT t_mat_ix_elem;
        p_last_col_a_row_b_o    : OUT STD_LOGIC
    );
END COMPONENT;

----------------------------------------------------------------------------------------------------
--  Signale
----------------------------------------------------------------------------------------------------
-- t0: Adressen fuer A/B setzen [Werte um 0 Takte verzoegert]
-- t1: Warten [Werte um 1 Takte verzoegert]
-- t2: Daten aus A/B liegen vor; Ergebnis berechnen, in C speichern [Werte um 2 Takte verzoegert]
-- t3: Ergebnis aus t2 + Neues Ergebnis wird berechnet [Werte um 3 Takte verzoegert]
SIGNAL s_result_t2, s_last_result_t2, s_last_result_t3: t_mat_elem;
SIGNAL s_ix_c_t0, s_ix_c_t2 : t_mat_ix;
SIGNAL s_col_a_row_b_t0, s_col_a_row_b_t1: t_mat_ix_elem;
SIGNAL s_first_elem_t1, s_finished_t1, s_finished_t2 : STD_LOGIC;
SIGNAL s_last_col_a_row_b_t1, s_last_col_a_row_b_t2 : STD_LOGIC;
SIGNAL s_c_size : t_mat_size;

----------------------------------------------------------------------------------------------------
--  Port Maps
----------------------------------------------------------------------------------------------------
BEGIN

set_word_elem : e_set_word_elem
PORT MAP(
    p_rst_i             => p_rst_i,
    p_clk_i             => p_clk_i,
    p_syn_rst_i         => p_syn_rst_i,
    
    p_ix_write_i        => s_ix_c_t2,
    p_word_done_i       => s_last_col_a_row_b_t2,
    
    p_elem_i            => s_result_t2,
    p_row_by_row_i      => p_mat_c_row_by_row_i,
    p_size_i            => s_c_size,
    
    p_word_o            => p_mat_c_data_o,
    p_ix_write_o        => p_mat_c_ix_o
);
 
ix_c_gen : e_mat_ix_gen
GENERIC MAP(inc_by_wordlen => FALSE)
PORT MAP(
    p_rst_i             => p_rst_i,
    p_clk_i             => p_clk_i,
    
    p_syn_rst_i         => p_syn_rst_i,
    p_finished_o        => s_finished_t1,
    p_word_done_i       => s_last_col_a_row_b_t1,

    p_size_i            => s_c_size,
    p_row_by_row_i      => p_mat_c_row_by_row_i,
    p_mat_ix_t0_o       => s_ix_c_t0,
    p_mat_ix_t2_o       => s_ix_c_t2,
    p_first_elem_t1_o   => s_first_elem_t1
);

mul : e_mat_mul_mul
PORT MAP(
    p_mat_a_data_i      => p_mat_a_data_i,
    p_mat_b_data_i      => p_mat_b_data_i,
    p_last_result_i     => s_last_result_t3,
        
    p_result_o          => s_result_t2
);
       
reg : e_mat_mul_reg
PORT MAP(
    p_rst_i                 => p_rst_i,
    p_clk_i                 => p_clk_i,
    p_syn_rst_i             => p_syn_rst_i,
    
    p_last_result_i         => s_last_result_t2,
    p_col_a_row_b_i         => s_col_a_row_b_t0,
    p_last_col_a_row_b_i    => s_last_col_a_row_b_t1,
    
    p_last_result_o         => s_last_result_t3,
    p_col_a_row_b_o         => s_col_a_row_b_t1,
    p_last_col_a_row_b_o    => s_last_col_a_row_b_t2
);


----------------------------------------------------------------------------------------------------
--  Zuweisungen
----------------------------------------------------------------------------------------------------
p_mat_a_ix_o            <= (s_ix_c_t0.row, s_col_a_row_b_t0);
p_mat_b_ix_o            <= (s_col_a_row_b_t0, s_ix_c_t0.col);
s_last_col_a_row_b_t1   <= to_sl((p_mat_a_size_i.max_col < t_mat_word'LENGTH) OR (s_col_a_row_b_t1 = t_mat_word'LENGTH)) OR s_finished_t2;
s_last_result_t2        <= s_result_t2 WHEN s_last_col_a_row_b_t2 = '0' ELSE to_mat_elem(0.0);

s_c_size                <= (p_mat_a_size_i.max_row, p_mat_b_size_i.max_col);
p_mat_c_size_o          <= s_c_size;
p_finished_o            <= s_finished_t1;

s_col_a_row_b_t0        <=  to_mat_ix_el(0) WHEN to_bool(s_first_elem_t1 OR s_last_col_a_row_b_t1) ELSE
                            s_col_a_row_b_t1 + t_mat_word'LENGTH;
                            

f_reg(p_rst_i, p_clk_i, p_syn_rst_i, s_finished_t1, s_finished_t2);
                            
END ARCHITECTURE a_mat_mul;

----------------------------------------------------------------------------------------------------
--  e_mat_mul_mul
----------------------------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
USE work.fixed_pkg.ALL;
USE work.pkg_tools.ALL;

ENTITY e_mat_mul_mul IS       
    PORT (    
        p_mat_a_data_i      : IN t_mat_word;
        p_mat_b_data_i      : IN t_mat_word;
        p_last_result_i     : IN t_mat_elem;
        
        p_result_o          : OUT t_mat_elem
    );
END ENTITY e_mat_mul_mul;
ARCHITECTURE  a_mat_mul_mul OF e_mat_mul_mul IS
BEGIN

proc_mul : PROCESS(p_mat_a_data_i, p_mat_b_data_i, p_last_result_i)
VARIABLE 
    v_tmp : t_mat_elem;
BEGIN
    v_tmp := to_mat_elem(0.0);
    FOR i IN p_mat_a_data_i'RANGE LOOP
        v_tmp := to_mat_elem(to_mat_elem(p_mat_a_data_i(i) * p_mat_b_data_i(i)) + v_tmp);
    END LOOP;
    p_result_o <= to_mat_elem(p_last_result_i + v_tmp);

END PROCESS proc_mul;

END ARCHITECTURE a_mat_mul_mul;

----------------------------------------------------------------------------------------------------
--  e_mat_mul_reg
----------------------------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
USE work.fixed_pkg.ALL;
USE work.pkg_tools.ALL;

ENTITY e_mat_mul_reg IS       
    PORT (    
        p_rst_i                 : IN STD_LOGIC;
        p_clk_i                 : IN STD_LOGIC;
        p_syn_rst_i             : IN STD_LOGIC;
        
        p_last_result_i         : IN t_mat_elem;
        p_col_a_row_b_i         : IN t_mat_ix_elem;
        p_last_col_a_row_b_i    : IN STD_LOGIC;
        
        p_last_result_o         : OUT t_mat_elem;
        p_col_a_row_b_o         : OUT t_mat_ix_elem;
        p_last_col_a_row_b_o    : OUT STD_LOGIC
    );
END ENTITY e_mat_mul_reg;
ARCHITECTURE  a_mat_mul_reg OF e_mat_mul_reg IS
BEGIN

proc_registers : PROCESS(p_rst_i, p_clk_i, p_syn_rst_i, p_last_result_i, p_col_a_row_b_i, p_last_col_a_row_b_i)
BEGIN
    IF p_rst_i = '1' THEN
        p_last_result_o <= to_mat_elem(0.0);
        p_col_a_row_b_o <= to_mat_ix_el(0);
        p_last_col_a_row_b_o <= '0';
    ELSIF RISING_EDGE(p_clk_i) THEN
        IF p_syn_rst_i = '1' THEN
            p_last_result_o <= to_mat_elem(0.0);
            p_col_a_row_b_o <= to_mat_ix_el(0);
            p_last_col_a_row_b_o <= '0';
        ELSE
            p_last_result_o <= p_last_result_i;
            p_col_a_row_b_o <= p_col_a_row_b_i;
            p_last_col_a_row_b_o <= p_last_col_a_row_b_i;
        END IF;
    END IF;
END PROCESS proc_registers;

END ARCHITECTURE a_mat_mul_reg;