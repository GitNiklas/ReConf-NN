----------------------------------------------------------------------------------------------------
-- Matrixoperation: Matrix-Addition
--
-- Normaler Modus:
-- Operand A:   MxN, beliebige Orientierung
-- Operand B:   Gleiche Groesse und Orientierung wie A          
-- Resultat C:  Gleiche Groesse und Orientierung wie A
--
-- Vektor-Addition: Spezialfall der Addition, bei der die 0. Zeile von Matrix B zu jeder Zeile von Matrix A addiert wird
-- Operand A:   MxN, zeilenweise
-- Operand B:   OxN, zeilenweise          
-- Resultat C:  MxN, zeilenweise
--
-- Destruktiver Modus: Ja (Normale und Vektor-Addition)
-- Geschwindigkeit: 1 Takt pro Matrix-Wort
--
--  Port:
--      p_rst_i                 : Asynchroner Reset
--      p_clk_i                 : Takt
--      p_syn_rst_i             : Synchroner Reset
--
--      p_finished_o            : Signalisiert, dass die Operation abgeschlossen ist
--      p_vec_add_i             : Signalisiert, ob eine Vektor-Addition ausgefuehrt werden soll
--        
--      p_mat_a_size_i          : Groesse von Matrix A, B und C   
--      p_mat_a_ix_o            : Leseposition Matrix A 
--      p_mat_a_data_i          : Gelesende Daten Matrix A 
--   
--      p_mat_b_ix_o            : Leseposition Matrix B 
--      p_mat_b_data_i          : Gelesende Daten Matrix B 
--  
--      p_mat_c_ix_o            : Schreibposition Matrix C 
--      p_mat_c_data_o          : Zu schreibende Daten Matrix C
--      p_mat_c_row_by_row_i    : Orientierung Matrix A, B und C
--      p_mat_c_size_o          : Groesse Matrix C
----------------------------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
USE work.fixed_pkg.ALL;
USE work.pkg_tools.ALL;

ENTITY e_mat_add IS       
    PORT (    
        p_rst_i                 : IN STD_LOGIC;
        p_clk_i                 : IN STD_LOGIC;
        
        p_syn_rst_i             : IN STD_LOGIC;
        p_finished_o            : OUT STD_LOGIC;
        p_vec_add_i             : IN STD_LOGIC;
        
        p_mat_a_size_i          : IN t_mat_size;
        p_mat_a_ix_o            : OUT t_mat_ix;
        p_mat_a_data_i          : IN t_mat_word;
        
        p_mat_b_ix_o            : OUT t_mat_ix;
        p_mat_b_data_i          : IN t_mat_word;

        p_mat_c_ix_o            : OUT t_mat_ix; 
        p_mat_c_data_o          : OUT t_mat_word;
        p_mat_c_row_by_row_i    : IN STD_LOGIC;
        p_mat_c_size_o          : OUT t_mat_size
    );
END ENTITY e_mat_add;

----------------------------------------------------------------------------------------------------
--  Architecture
----------------------------------------------------------------------------------------------------
ARCHITECTURE a_mat_add OF e_mat_add IS

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
        p_mat_ix_t4_o           : OUT t_mat_ix;
        p_first_elem_t1_o       : OUT STD_LOGIC
    );
END COMPONENT;

----------------------------------------------------------------------------------------------------
--  Signale
----------------------------------------------------------------------------------------------------
SIGNAL s_mat_ab_ix : t_mat_ix;

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
    p_mat_ix_t4_o       => p_mat_c_ix_o,
    p_first_elem_t1_o   => OPEN
);

----------------------------------------------------------------------------------------------------
--  Zuweisungen
----------------------------------------------------------------------------------------------------
p_mat_a_ix_o <= s_mat_ab_ix;
p_mat_b_ix_o <= s_mat_ab_ix WHEN p_vec_add_i = '0' 
                ELSE (to_mat_ix_el(0), s_mat_ab_ix.col);
p_mat_c_size_o <= p_mat_a_size_i;

----------------------------------------------------------------------------------------------------
--  Prozesse
----------------------------------------------------------------------------------------------------

proc_add : PROCESS(p_mat_a_data_i, p_mat_b_data_i)
BEGIN
    FOR i IN p_mat_a_data_i'RANGE LOOP
        p_mat_c_data_o(i) <= to_mat_elem(p_mat_a_data_i(i) + p_mat_b_data_i(i));
    END LOOP;
END PROCESS proc_add;

END ARCHITECTURE a_mat_add;