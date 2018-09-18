----------------------------------------------------------------------------------------------------
-- Entity zum generieren der Matrix-Indizes und zum Durchlaufen einer Matrix.
--
--  Generics:
--      inc_by_wordlen      : Gibt an ob die Indizes wortweise weitergeschaltet werden sollen (True; Verarbeitung von 1 Matrixwort in 1 Takt)
--                            oder ob dies elementweise geschehen soll (False; 1 Element pro Takt)
--
--  Port:
--      p_rst_i             : Asynchroner Reset
--      p_clk_i             : Takt
--      p_syn_rst_i         : Synchroner Reset
--
--      p_finished_o        : Gibt an, dass der Index auf der letzen Position steht
--      p_word_done_i       : Gibt an, dass die Verabeitung des aktuellen Worts/Elements abgeschlossen ist und
--                            das naechste Weort gelesen werden kann
--        
--      p_size_i            : Groesse der Matrix
--      p_row_by_row_i      : Orientierung der Matrix
--      p_mat_ix_t0_o       : Leseposition
--      p_mat_ix_t4_o       : Schreibposition (= Leseposition um 4 Takte verzoegert)
--      p_first_elem_t1_o   : Gibt an, dass aktuell das erste Matrix-Element gelesen wird
----------------------------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
USE work.fixed_pkg.ALL;
USE work.pkg_tools.ALL;

ENTITY e_mat_ix_gen IS
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
END ENTITY e_mat_ix_gen;

----------------------------------------------------------------------------------------------------
--  Architecture
----------------------------------------------------------------------------------------------------
ARCHITECTURE a_mat_ix_gen OF e_mat_ix_gen IS

----------------------------------------------------------------------------------------------------
--  Signale
----------------------------------------------------------------------------------------------------
SIGNAL s_ix_t0, s_ix_t1, s_ix_t2, s_ix_t3, s_ix_t4 : t_mat_ix;
SIGNAL s_first_elem, s_last_col_t1, s_last_row_t1 : STD_LOGIC;
SIGNAL c_inc_ix : INTEGER; 
SIGNAL s_syn_rst_t1, s_syn_rst_t2, s_syn_rst_t3 : STD_LOGIC;
SIGNAL s_low : STD_LOGIC := '0';

----------------------------------------------------------------------------------------------------
--  Zuweisungen
----------------------------------------------------------------------------------------------------
BEGIN

p_mat_ix_t0_o       <= s_ix_t0;
p_mat_ix_t4_o       <= s_ix_t4;

p_finished_o        <= s_last_col_t1 AND s_last_row_t1 AND NOT s_first_elem AND NOT s_syn_rst_t2 AND NOT s_syn_rst_t3;
p_first_elem_t1_o   <= s_first_elem;

c_inc_ix <= t_mat_word'LENGTH WHEN inc_by_wordlen ELSE 1;

f_reg(p_rst_i, p_clk_i, s_low, p_syn_rst_i, s_syn_rst_t1);
f_reg(p_rst_i, p_clk_i, s_low, s_syn_rst_t1, s_syn_rst_t2);
f_reg(p_rst_i, p_clk_i, s_low, s_syn_rst_t2, s_syn_rst_t3);

----------------------------------------------------------------------------------------------------
--  Prozesse
----------------------------------------------------------------------------------------------------

proc_last_rowcol : PROCESS(p_row_by_row_i, p_size_i, s_ix_t1) -- p_size und row by row kommen 2 TAKTE verzögert
BEGIN
    IF p_row_by_row_i = '1' THEN
        IF inc_by_wordlen THEN    
            s_last_col_t1 <= to_sl((p_size_i.max_col < t_mat_word'LENGTH) OR (s_ix_t1.col = t_mat_word'LENGTH));
        ELSE
            s_last_col_t1 <= to_sl(s_ix_t1.col = p_size_i.max_col);
        END IF;          
        s_last_row_t1 <= to_sl(s_ix_t1.row = p_size_i.max_row);
    ELSE
        s_last_col_t1 <= to_sl(s_ix_t1.col = p_size_i.max_col);
        IF inc_by_wordlen THEN    
            s_last_row_t1 <= to_sl((p_size_i.max_row < t_mat_word'LENGTH) OR (s_ix_t1.row = t_mat_word'LENGTH));
        ELSE
            s_last_row_t1 <= to_sl(s_ix_t1.row = p_size_i.max_row);
        END IF;          
    END IF;
END PROCESS proc_last_rowcol;

proc_registers : PROCESS(p_rst_i, p_clk_i)
BEGIN
    IF p_rst_i = '1' THEN
        s_ix_t1 <= c_mat_ix_zero;
        s_ix_t2 <= c_mat_ix_zero;
        s_ix_t3 <= c_mat_ix_zero;
        s_ix_t4 <= c_mat_ix_zero;
        s_first_elem <= '1';
    ELSIF RISING_EDGE(p_clk_i) THEN
        IF p_syn_rst_i = '1' THEN
            s_ix_t1 <= c_mat_ix_zero;
            s_ix_t2 <= c_mat_ix_zero;
            s_ix_t3 <= c_mat_ix_zero;
            s_ix_t4 <= c_mat_ix_zero;
            s_first_elem <= '1';
        ELSE
            s_ix_t1 <= s_ix_t0;
            s_ix_t2 <= s_ix_t1;
            s_ix_t3 <= s_ix_t2;
            s_ix_t4 <= s_ix_t3;
            s_first_elem <= '0';
        END IF;
    END IF;
END PROCESS proc_registers;

proc_calc_ix : PROCESS(p_word_done_i, s_first_elem, s_last_col_t1, s_last_row_t1, s_ix_t1, c_inc_ix, p_row_by_row_i)
BEGIN
        IF s_first_elem = '1' THEN -- wait for 1. elem to be processed
            s_ix_t0             <= c_mat_ix_zero;
        ELSE
            IF p_word_done_i = '0' THEN -- wait for current word to be finished
                s_ix_t0             <= s_ix_t1; 
            ELSE
                IF p_row_by_row_i = '1' THEN
                    IF s_last_col_t1 = '0' THEN
                        s_ix_t0.col         <= s_ix_t1.col + c_inc_ix; 
                        s_ix_t0.row         <= s_ix_t1.row; 
                    ELSIF s_last_row_t1 = '0' THEN
                        s_ix_t0.col         <= to_mat_ix_el(0); 
                        s_ix_t0.row         <= s_ix_t1.row + 1; 
                    ELSE
                        s_ix_t0             <= s_ix_t1; 
                    END IF; 
                ELSE --swap row/col indizes
                    IF s_last_row_t1 = '0' THEN
                        s_ix_t0.col         <= s_ix_t1.col; 
                        s_ix_t0.row         <= s_ix_t1.row + c_inc_ix; 
                    ELSIF s_last_col_t1 = '0' THEN
                        s_ix_t0.col         <= s_ix_t1.col + 1;
                        s_ix_t0.row         <= to_mat_ix_el(0); 
                    ELSE
                        s_ix_t0             <= s_ix_t1; 
                    END IF; 
                END IF;
            END IF;
        END IF;
END PROCESS proc_calc_ix;

END ARCHITECTURE a_mat_ix_gen;
