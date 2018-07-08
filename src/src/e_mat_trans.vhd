LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
USE work.fixed_pkg.ALL;
USE work.pkg_tools.ALL;

ENTITY e_mat_trans IS       
    PORT (    
        p_rst_i                 : IN STD_LOGIC;
        p_clk_i                 : IN STD_LOGIC;
        
        p_syn_rst_i             : IN STD_LOGIC;
        p_finished_o            : OUT STD_LOGIC;
        
        p_mat_a_size_i          : IN t_mat_size;
        p_mat_a_ix_o            : OUT t_mat_ix;
        p_mat_a_row_by_row_i    : IN STD_LOGIC;
        p_mat_a_data_i          : IN t_mat_word;
        
        p_mat_c_ix_o            : OUT t_mat_ix; 
        p_mat_c_data_o          : OUT t_mat_word;
        p_mat_c_row_by_row_i    : IN STD_LOGIC;
        p_mat_c_size_o          : OUT t_mat_size
    );
END ENTITY e_mat_trans;

----------------------------------------------------------------------------------------------------
--  Architecture
----------------------------------------------------------------------------------------------------
ARCHITECTURE a_mat_trans OF e_mat_trans IS

----------------------------------------------------------------------------------------------------
--  Komponenten
----------------------------------------------------------------------------------------------------

COMPONENT e_set_word_elem    
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
SIGNAL s_mat_a_ix_t0, s_mat_a_ix_t2, s_mat_c_ix_t2 : t_mat_ix;
SIGNAL s_c_size : t_mat_size;
SIGNAL s_c_elem : t_mat_elem;
SIGNAL s_word_ix : t_mat_ix_elem;

----------------------------------------------------------------------------------------------------
--  Port Maps
----------------------------------------------------------------------------------------------------
BEGIN

set_word_elem : e_set_word_elem
PORT MAP(
    p_rst_i             => p_rst_i,
    p_clk_i             => p_clk_i,
    p_syn_rst_i         => p_syn_rst_i,
    
    p_ix_write_i        => s_mat_c_ix_t2,
    p_word_done_i       => '1',
    
    p_elem_i            => s_c_elem,
    p_row_by_row_i      => p_mat_c_row_by_row_i,
    p_size_i            => s_c_size,
    
    p_word_o            => p_mat_c_data_o,
    p_ix_write_o        => p_mat_c_ix_o
);

mat_ix_gen : e_mat_ix_gen
GENERIC MAP(inc_by_wordlen => FALSE)
PORT MAP(
    p_rst_i             => p_rst_i,
    p_clk_i             => p_clk_i,
    
    p_syn_rst_i         => p_syn_rst_i,
    p_finished_o        => p_finished_o,
    p_word_done_i       => '1',
        
    p_size_i            => p_mat_a_size_i,
    p_row_by_row_i      => p_mat_c_row_by_row_i,
    p_mat_ix_t0_o       => s_mat_a_ix_t0,
    p_mat_ix_t2_o       => s_mat_a_ix_t2,
    p_first_elem_t1_o   => OPEN
);

----------------------------------------------------------------------------------------------------
--  Zuweisungen
----------------------------------------------------------------------------------------------------

s_c_size        <= (p_mat_a_size_i.max_col, p_mat_a_size_i.max_row);
p_mat_c_size_o  <= s_c_size;
s_mat_c_ix_t2   <= (s_mat_a_ix_t2.col, s_mat_a_ix_t2.row);
p_mat_a_ix_o    <= s_mat_a_ix_t0;

s_word_ix       <= s_mat_a_ix_t0.col WHEN p_mat_a_row_by_row_i = '1' ELSE s_mat_a_ix_t0.row;
s_c_elem        <= p_mat_a_data_i(to_integer(s_word_ix mod 32));

END ARCHITECTURE a_mat_trans;