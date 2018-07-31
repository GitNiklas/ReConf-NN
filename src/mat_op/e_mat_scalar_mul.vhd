LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
USE work.fixed_pkg.ALL;
USE work.pkg_tools.ALL;

ENTITY e_mat_scalar_mul IS       
    PORT (    
        p_rst_i                 : IN STD_LOGIC;
        p_clk_i                 : IN STD_LOGIC;
        
        p_syn_rst_i             : IN STD_LOGIC;
        p_finished_o            : OUT STD_LOGIC;
        
        p_scalar_i              : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        
        p_mat_a_size_i          : IN t_mat_size;
        p_mat_a_ix_o            : OUT t_mat_ix;
        p_mat_a_data_i          : IN t_mat_word;
        
        p_mat_c_ix_o            : OUT t_mat_ix; 
        p_mat_c_data_o          : OUT t_mat_word;
        p_mat_c_row_by_row_i    : IN STD_LOGIC;
        p_mat_c_size_o          : OUT t_mat_size
    );
END ENTITY e_mat_scalar_mul;

----------------------------------------------------------------------------------------------------
--  Architecture
----------------------------------------------------------------------------------------------------
ARCHITECTURE a_mat_scalar_mul OF e_mat_scalar_mul IS

----------------------------------------------------------------------------------------------------
--  Komponenten
----------------------------------------------------------------------------------------------------

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
SIGNAL s_mat_ab_ix : t_mat_ix;
SIGNAL s_scalar : t_mat_elem;

----------------------------------------------------------------------------------------------------
--  Port Maps
----------------------------------------------------------------------------------------------------
BEGIN

mat_ix_gen : e_mat_ix_gen
PORT MAP(
    p_rst_i             => p_rst_i,
    p_clk_i             => p_clk_i,
    
    p_syn_rst_i         => p_syn_rst_i,
    p_finished_o        => p_finished_o,
    p_word_done_i       => '1',

    p_size_i            => p_mat_a_size_i,
    p_row_by_row_i      => p_mat_c_row_by_row_i,
    p_mat_ix_t0_o       => s_mat_ab_ix,
    p_mat_ix_t2_o       => p_mat_c_ix_o,
    p_first_elem_t1_o   => OPEN
);

----------------------------------------------------------------------------------------------------
--  Zuweisungen
----------------------------------------------------------------------------------------------------
p_mat_a_ix_o <= s_mat_ab_ix;
p_mat_c_size_o <= p_mat_a_size_i;
s_scalar <= to_mat_elem(p_scalar_i);

----------------------------------------------------------------------------------------------------
--  Prozesse
----------------------------------------------------------------------------------------------------

proc_calc : PROCESS(p_mat_a_data_i, s_scalar)
BEGIN
    FOR i IN p_mat_a_data_i'RANGE LOOP
        p_mat_c_data_o(i) <= to_mat_elem(p_mat_a_data_i(i) * s_scalar);
    END LOOP;
END PROCESS proc_calc;

END ARCHITECTURE a_mat_scalar_mul;