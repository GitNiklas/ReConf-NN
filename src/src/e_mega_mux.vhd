----------------------------------------------------------------------------------------------------
-- Multiplexereinheit zur Zuordnung der Matrizen A, B und C zu den jeweiligen Matrixregistern.
-- Die Datenausgaenge fuer die Matrizen A, b und C sind um 4 Takte gegenueber den Lesepositionen verzoegert
-- 
--  Port:
--      p_rst_i                 : Asynchroner Reset
--      p_clk_i                 : Takt
--      p_syn_rst_i             : Synchroner Reset
--
--      p_sel_a_i               : Auswahl Matrrixregister A
--      p_sel_b_i               : Auswahl Matrrixregister B
--      p_sel_c_i               : Auswahl Matrrixregister C
--      p_opcode_i              : Aktuelle Operation
--        
--      p_reg_mat_size_o        : Groesse Matrixregister, Lesend
--      p_reg_mat_size_i        : Groesse Matrixregister, Schreibend
--      p_reg_ix_read_o         : Leseposition Matrixregister
--      p_reg_ix_write_o        : Schreibposition Matrixregister
--      p_reg_wren_o            : Schreiberlaubnis Matrixregister
--      p_reg_row_by_row_i      : Orientierung Matrixregister, Schreibend
--      p_reg_row_by_row_o      : Orientierung Matrixregister, Lesend
--      p_reg_word_o            : Gelesende Daten
--      p_reg_word_i            : Zu schreibende Daten
--     
--      p_alu_a_data_o          : Gelesene Daten Matrix A
--      p_alu_a_ix_read_i       : Leseposition Matrix A 
--      p_alu_a_size_o          : Groesse von Matrix A 
--      p_alu_a_row_by_row_o    : Orientierung Matrix A
--      p_alu_b_data_o          : Gelesene Daten Matrix B
--      p_alu_b_ix_read_i       : Leseposition Matrix B
--      p_alu_b_size_o          : Groesse von Matrix B 
--      p_alu_b_row_by_row_o    : Orientierung Matrix B
--      p_alu_c_data_i          : Zu schreibende Daten Matrix C
--      p_alu_c_size_i          : Groesse Matrix C
--      p_alu_c_row_by_row_i    : Orientierung Matrix C
--      p_alu_c_ix_write_i      : Schreibposition Matrix C 
--      p_alu_c_wren_i          : Schreiberlaubnis Matrix C
--         
--      p_write_a0_i            : Signalisiert einen externen Schreibvorgang auf Matrix A (OpCore0)
--      p_read_a0_i             : Signalisiert einen externen Lesevorgnag von Matrix A (OpCore0)
--      p_data_a0_i             : Zu Schreibende Daten Matrix A (OpCore0)
--      p_data_a0_o             : Gelesene Daten Matrix A (OpCore0)
--      p_ix_a0_i               : Lese/Schreibindex Matrix A (OpCore0)
--      p_size_a0_i             : Groesse Matrix A (OpCore0), Schreibend
--      p_row_by_row_a0_i       : Orientierung Matrix A (OpCore0), Schreibend
--      p_size_a0_o             : Groesse Matrix A (OpCore0), Lesend 
--      p_row_by_row_a0_o       : Orientierung Matrix A (OpCore0), Lesend
--
--  Autor: Niklas Kuehl
----------------------------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
USE work.fixed_pkg.ALL;
USE work.pkg_tools.ALL;

ENTITY e_mega_mux IS       
    PORT (    
        p_rst_i                 : IN STD_LOGIC;
        p_clk_i                 : IN STD_LOGIC;
        
        p_syn_rst_i             : IN STD_LOGIC;
        
        p_sel_a_i               : IN t_mat_reg_ixs;
        p_sel_b_i               : IN t_mat_reg_ixs;
        p_sel_c_i               : IN t_mat_reg_ixs;
        p_opcode_i              : IN t_opcodes;
        
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

SIGNAL s_a_reg_row_by_row_01, s_a_reg_row_by_row_23, s_a_reg_row_by_row_45, s_a_reg_row_by_row_67, s_a_reg_row_by_row_89, s_a_reg_row_by_row_0123, s_a_reg_row_by_row_4567, s_a_reg_row_by_row_456789 : t_op_std_logics;
SIGNAL s_a_reg_row_by_row_01_r, s_a_reg_row_by_row_23_r, s_a_reg_row_by_row_45_r, s_a_reg_row_by_row_67_r, s_a_reg_row_by_row_89_r, s_a_reg_row_by_row_0123_r, s_a_reg_row_by_row_456789_r : t_op_std_logics;

SIGNAL s_a_reg_word_01, s_a_reg_word_23, s_a_reg_word_45, s_a_reg_word_67, s_a_reg_word_89, s_a_reg_word_0123, s_a_reg_word_4567, s_a_reg_word_456789 : t_mat_words;
SIGNAL s_a_reg_word_01_r, s_a_reg_word_23_r, s_a_reg_word_45_r, s_a_reg_word_67_r, s_a_reg_word_89_r, s_a_reg_word_0123_r, s_a_reg_word_456789_r : t_mat_words;

SIGNAL s_a_reg_size_01, s_a_reg_size_23, s_a_reg_size_45, s_a_reg_size_67, s_a_reg_size_89, s_a_reg_size_0123, s_a_reg_size_4567, s_a_reg_size_456789 : t_mat_sizes;
SIGNAL s_a_reg_size_01_r, s_a_reg_size_23_r, s_a_reg_size_45_r, s_a_reg_size_67_r, s_a_reg_size_89_r, s_a_reg_size_0123_r, s_a_reg_size_456789_r : t_mat_sizes;

SIGNAL s_b_reg_row_by_row_01, s_b_reg_row_by_row_23, s_b_reg_row_by_row_45, s_b_reg_row_by_row_67, s_b_reg_row_by_row_89, s_b_reg_row_by_row_0123, s_b_reg_row_by_row_4567, s_b_reg_row_by_row_456789 : t_op_std_logics;
SIGNAL s_b_reg_row_by_row_01_r, s_b_reg_row_by_row_23_r, s_b_reg_row_by_row_45_r, s_b_reg_row_by_row_67_r, s_b_reg_row_by_row_89_r, s_b_reg_row_by_row_0123_r, s_b_reg_row_by_row_456789_r : t_op_std_logics;

SIGNAL s_b_reg_word_01, s_b_reg_word_23, s_b_reg_word_45, s_b_reg_word_67, s_b_reg_word_89, s_b_reg_word_0123, s_b_reg_word_4567, s_b_reg_word_456789 : t_mat_words;
SIGNAL s_b_reg_word_01_r, s_b_reg_word_23_r, s_b_reg_word_45_r, s_b_reg_word_67_r, s_b_reg_word_89_r, s_b_reg_word_0123_r, s_b_reg_word_456789_r : t_mat_words;

SIGNAL s_b_reg_size_01, s_b_reg_size_23, s_b_reg_size_45, s_b_reg_size_67, s_b_reg_size_89, s_b_reg_size_0123, s_b_reg_size_4567, s_b_reg_size_456789 : t_mat_sizes;
SIGNAL s_b_reg_size_01_r, s_b_reg_size_23_r, s_b_reg_size_45_r, s_b_reg_size_67_r, s_b_reg_size_89_r, s_b_reg_size_0123_r, s_b_reg_size_456789_r : t_mat_sizes;

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
--  Read Ix ALU (A, B) -> Register
----------------------------------------------------------------------------------------------------
proc_mux_read_ix : PROCESS(p_opcode_i, p_read_a0_i, p_ix_a0_i, p_sel_a_i, p_sel_b_i, p_alu_a_ix_read_i, p_alu_b_ix_read_i)
BEGIN
    FOR reg IN c_num_mat_regs-1 DOWNTO 0 LOOP
        p_reg_ix_read_o(reg) <= c_mat_ix_dontcare; 
        
        -- Da Schleife downto, sind die Operanden von OpCore0 am hoechsten priorisiert
        --  => p_sel_b_i von OpCore 1 wird nicht beachtet
        FOR opnum IN c_num_parallel_op-1 DOWNTO 0 LOOP
            IF p_opcode_i(opnum) /= NoOp THEN
                IF p_sel_a_i(opnum) = TO_UNSIGNED(reg, p_sel_a_i(opnum)'LENGTH) THEN
                    p_reg_ix_read_o(reg) <= p_alu_a_ix_read_i(opnum);
                ELSIF p_sel_b_i(opnum) = TO_UNSIGNED(reg, p_sel_b_i(opnum)'LENGTH) THEN
                    p_reg_ix_read_o(reg) <= p_alu_b_ix_read_i(opnum);
                END IF;
            END IF;
        END LOOP;
        
        IF p_read_a0_i = '1' THEN
            p_reg_ix_read_o(reg) <= p_ix_a0_i;
        END IF;
    END LOOP;
END PROCESS proc_mux_read_ix;

----------------------------------------------------------------------------------------------------
--  Mux Register -> ALU (A)
----------------------------------------------------------------------------------------------------

generate_a: 
FOR i IN c_num_parallel_op-1 DOWNTO 0 GENERATE
    s_a_reg_row_by_row_01(i) <= p_reg_row_by_row_i(0) WHEN p_sel_a_i(i) = TO_UNSIGNED(0, 4) ELSE p_reg_row_by_row_i(1);
    s_a_reg_row_by_row_23(i) <= p_reg_row_by_row_i(2) WHEN p_sel_a_i(i) = TO_UNSIGNED(2, 4) ELSE p_reg_row_by_row_i(3);
    s_a_reg_row_by_row_45(i) <= p_reg_row_by_row_i(4) WHEN p_sel_a_i(i) = TO_UNSIGNED(4, 4) ELSE p_reg_row_by_row_i(5);
    s_a_reg_row_by_row_67(i) <= p_reg_row_by_row_i(6) WHEN p_sel_a_i(i) = TO_UNSIGNED(6, 4) ELSE p_reg_row_by_row_i(7);
    s_a_reg_row_by_row_89(i) <= p_reg_row_by_row_i(8) WHEN p_sel_a_i(i) = TO_UNSIGNED(8, 4) ELSE p_reg_row_by_row_i(9);
    s_a_reg_row_by_row_0123(i) <= s_a_reg_row_by_row_01_r(i) WHEN p_sel_a_i(i) < TO_UNSIGNED(2, 4) ELSE s_a_reg_row_by_row_23_r(i);
    s_a_reg_row_by_row_4567(i) <= s_a_reg_row_by_row_45_r(i) WHEN p_sel_a_i(i) < TO_UNSIGNED(6, 4) ELSE s_a_reg_row_by_row_67_r(i);
    s_a_reg_row_by_row_456789(i) <= s_a_reg_row_by_row_4567(i) WHEN p_sel_a_i(i) < TO_UNSIGNED(8, 4) ELSE s_a_reg_row_by_row_89_r(i) ;   
    s_reg_row_by_row_i(i) <=  s_a_reg_row_by_row_0123_r(i) WHEN p_sel_a_i(i) < TO_UNSIGNED(4, 4) ELSE s_a_reg_row_by_row_456789_r(i);
    
    s_a_reg_word_01(i) <= p_reg_word_i(0) WHEN p_sel_a_i(i) = TO_UNSIGNED(0, 4) ELSE p_reg_word_i(1);
    s_a_reg_word_23(i) <= p_reg_word_i(2) WHEN p_sel_a_i(i) = TO_UNSIGNED(2, 4) ELSE p_reg_word_i(3);
    s_a_reg_word_45(i) <= p_reg_word_i(4) WHEN p_sel_a_i(i) = TO_UNSIGNED(4, 4) ELSE p_reg_word_i(5);
    s_a_reg_word_67(i) <= p_reg_word_i(6) WHEN p_sel_a_i(i) = TO_UNSIGNED(6, 4) ELSE p_reg_word_i(7);
    s_a_reg_word_89(i) <= p_reg_word_i(8) WHEN p_sel_a_i(i) = TO_UNSIGNED(8, 4) ELSE p_reg_word_i(9);
    s_a_reg_word_0123(i) <= s_a_reg_word_01_r(i) WHEN p_sel_a_i(i) < TO_UNSIGNED(2, 4) ELSE s_a_reg_word_23_r(i);
    s_a_reg_word_4567(i) <= s_a_reg_word_45_r(i) WHEN p_sel_a_i(i) < TO_UNSIGNED(6, 4) ELSE s_a_reg_word_67_r(i);
    s_a_reg_word_456789(i) <= s_a_reg_word_4567(i) WHEN p_sel_a_i(i) < TO_UNSIGNED(8, 4) ELSE s_a_reg_word_89_r(i) ;   
    s_a_word_i(i) <=  s_a_reg_word_0123_r(i) WHEN p_sel_a_i(i) < TO_UNSIGNED(4, 4) ELSE s_a_reg_word_456789_r(i);
    
    s_a_reg_size_01(i) <= p_reg_mat_size_i(0) WHEN p_sel_a_i(i) = TO_UNSIGNED(0, 4) ELSE p_reg_mat_size_i(1);
    s_a_reg_size_23(i) <= p_reg_mat_size_i(2) WHEN p_sel_a_i(i) = TO_UNSIGNED(2, 4) ELSE p_reg_mat_size_i(3);
    s_a_reg_size_45(i) <= p_reg_mat_size_i(4) WHEN p_sel_a_i(i) = TO_UNSIGNED(4, 4) ELSE p_reg_mat_size_i(5);
    s_a_reg_size_67(i) <= p_reg_mat_size_i(6) WHEN p_sel_a_i(i) = TO_UNSIGNED(6, 4) ELSE p_reg_mat_size_i(7);
    s_a_reg_size_89(i) <= p_reg_mat_size_i(8) WHEN p_sel_a_i(i) = TO_UNSIGNED(8, 4) ELSE p_reg_mat_size_i(9);
    s_a_reg_size_0123(i) <= s_a_reg_size_01_r(i) WHEN p_sel_a_i(i) < TO_UNSIGNED(2, 4) ELSE s_a_reg_size_23_r(i);
    s_a_reg_size_4567(i) <= s_a_reg_size_45_r(i) WHEN p_sel_a_i(i) < TO_UNSIGNED(6, 4) ELSE s_a_reg_size_67_r(i);
    s_a_reg_size_456789(i) <= s_a_reg_size_4567(i) WHEN p_sel_a_i(i) < TO_UNSIGNED(8, 4) ELSE s_a_reg_size_89_r(i) ;   
    s_a_size_i(i) <=  s_a_reg_size_0123_r(i) WHEN p_sel_a_i(i) < TO_UNSIGNED(4, 4) ELSE s_a_reg_size_456789_r(i);
END GENERATE generate_a;


proc_reg_a: PROCESS(p_rst_i, p_clk_i)
BEGIN
    IF p_rst_i = '1' THEN
        s_a_reg_row_by_row_01_r <= (OTHERS => '0');
        s_a_reg_row_by_row_23_r <= (OTHERS => '0');
        s_a_reg_row_by_row_45_r <= (OTHERS => '0');
        s_a_reg_row_by_row_67_r <= (OTHERS => '0');
        s_a_reg_row_by_row_89_r <= (OTHERS => '0');
        s_a_reg_row_by_row_0123_r <= (OTHERS => '0');
        s_a_reg_row_by_row_456789_r <= (OTHERS => '0');
        
        s_a_reg_word_01_r <= (OTHERS => c_mat_word_zero);
        s_a_reg_word_23_r <= (OTHERS => c_mat_word_zero);
        s_a_reg_word_45_r <= (OTHERS => c_mat_word_zero);
        s_a_reg_word_67_r <= (OTHERS => c_mat_word_zero);
        s_a_reg_word_89_r <= (OTHERS => c_mat_word_zero);
        s_a_reg_word_0123_r <= (OTHERS => c_mat_word_zero);
        s_a_reg_word_456789_r <= (OTHERS => c_mat_word_zero);
        
        s_a_reg_size_01_r <= (OTHERS => c_mat_size_zero);
        s_a_reg_size_23_r <= (OTHERS => c_mat_size_zero);
        s_a_reg_size_45_r <= (OTHERS => c_mat_size_zero);
        s_a_reg_size_67_r <= (OTHERS => c_mat_size_zero);
        s_a_reg_size_89_r <= (OTHERS => c_mat_size_zero);
        s_a_reg_size_0123_r <= (OTHERS => c_mat_size_zero);
        s_a_reg_size_456789_r <= (OTHERS => c_mat_size_zero);
    ELSIF RISING_EDGE(p_clk_i) THEN
        IF p_syn_rst_i = '1' THEN
            s_a_reg_row_by_row_01_r <= (OTHERS => '0');
            s_a_reg_row_by_row_23_r <= (OTHERS => '0');
            s_a_reg_row_by_row_45_r <= (OTHERS => '0');
            s_a_reg_row_by_row_67_r <= (OTHERS => '0');
            s_a_reg_row_by_row_89_r <= (OTHERS => '0');
            s_a_reg_row_by_row_0123_r <= (OTHERS => '0');
            s_a_reg_row_by_row_456789_r <= (OTHERS => '0');
            
            s_a_reg_word_01_r <= (OTHERS => c_mat_word_zero);
            s_a_reg_word_23_r <= (OTHERS => c_mat_word_zero);
            s_a_reg_word_45_r <= (OTHERS => c_mat_word_zero);
            s_a_reg_word_67_r <= (OTHERS => c_mat_word_zero);
            s_a_reg_word_89_r <= (OTHERS => c_mat_word_zero);
            s_a_reg_word_0123_r <= (OTHERS => c_mat_word_zero);
            s_a_reg_word_456789_r <= (OTHERS => c_mat_word_zero);
            
            s_a_reg_size_01_r <= (OTHERS => c_mat_size_zero);
            s_a_reg_size_23_r <= (OTHERS => c_mat_size_zero);
            s_a_reg_size_45_r <= (OTHERS => c_mat_size_zero);
            s_a_reg_size_67_r <= (OTHERS => c_mat_size_zero);
            s_a_reg_size_89_r <= (OTHERS => c_mat_size_zero);
            s_a_reg_size_0123_r <= (OTHERS => c_mat_size_zero);
            s_a_reg_size_456789_r <= (OTHERS => c_mat_size_zero);
        ELSE
            s_a_reg_row_by_row_01_r <= s_a_reg_row_by_row_01;
            s_a_reg_row_by_row_23_r <= s_a_reg_row_by_row_23;
            s_a_reg_row_by_row_45_r <= s_a_reg_row_by_row_45;
            s_a_reg_row_by_row_67_r <= s_a_reg_row_by_row_67;
            s_a_reg_row_by_row_89_r <= s_a_reg_row_by_row_89;
            s_a_reg_row_by_row_0123_r <= s_a_reg_row_by_row_0123;
            s_a_reg_row_by_row_456789_r <= s_a_reg_row_by_row_456789;
            
            s_a_reg_word_01_r <= s_a_reg_word_01;
            s_a_reg_word_23_r <= s_a_reg_word_23;
            s_a_reg_word_45_r <= s_a_reg_word_45;
            s_a_reg_word_67_r <= s_a_reg_word_67;
            s_a_reg_word_89_r <= s_a_reg_word_89;
            s_a_reg_word_0123_r <= s_a_reg_word_0123;
            s_a_reg_word_456789_r <= s_a_reg_word_456789;
            
            s_a_reg_size_01_r <= s_a_reg_size_01;
            s_a_reg_size_23_r <= s_a_reg_size_23;
            s_a_reg_size_45_r <= s_a_reg_size_45;
            s_a_reg_size_67_r <= s_a_reg_size_67;
            s_a_reg_size_89_r <= s_a_reg_size_89;
            s_a_reg_size_0123_r <= s_a_reg_size_0123;
            s_a_reg_size_456789_r <= s_a_reg_size_456789;
        END IF;
    END IF;
END PROCESS proc_reg_a;

----------------------------------------------------------------------------------------------------
--  Mux Register -> ALU (B)
----------------------------------------------------------------------------------------------------

generate_b: 
FOR i IN c_num_parallel_op-1 DOWNTO 0 GENERATE
    s_b_reg_row_by_row_01(i) <= p_reg_row_by_row_i(0) WHEN p_sel_b_i(i) = TO_UNSIGNED(0, 4) ELSE p_reg_row_by_row_i(1);
    s_b_reg_row_by_row_23(i) <= p_reg_row_by_row_i(2) WHEN p_sel_b_i(i) = TO_UNSIGNED(2, 4) ELSE p_reg_row_by_row_i(3);
    s_b_reg_row_by_row_45(i) <= p_reg_row_by_row_i(4) WHEN p_sel_b_i(i) = TO_UNSIGNED(4, 4) ELSE p_reg_row_by_row_i(5);
    s_b_reg_row_by_row_67(i) <= p_reg_row_by_row_i(6) WHEN p_sel_b_i(i) = TO_UNSIGNED(6, 4) ELSE p_reg_row_by_row_i(7);
    s_b_reg_row_by_row_89(i) <= p_reg_row_by_row_i(8) WHEN p_sel_b_i(i) = TO_UNSIGNED(8, 4) ELSE p_reg_row_by_row_i(9);
    s_b_reg_row_by_row_0123(i) <= s_b_reg_row_by_row_01_r(i) WHEN p_sel_b_i(i) < TO_UNSIGNED(2, 4) ELSE s_b_reg_row_by_row_23_r(i);
    s_b_reg_row_by_row_4567(i) <= s_b_reg_row_by_row_45_r(i) WHEN p_sel_b_i(i) < TO_UNSIGNED(6, 4) ELSE s_b_reg_row_by_row_67_r(i);
    s_b_reg_row_by_row_456789(i) <= s_b_reg_row_by_row_4567(i) WHEN p_sel_b_i(i) < TO_UNSIGNED(8, 4) ELSE s_b_reg_row_by_row_89_r(i) ;   
    p_alu_b_row_by_row_o(i) <=  s_b_reg_row_by_row_0123_r(i) WHEN p_sel_b_i(i) < TO_UNSIGNED(4, 4) ELSE s_b_reg_row_by_row_456789_r(i);
    
    s_b_reg_word_01(i) <= p_reg_word_i(0) WHEN p_sel_b_i(i) = TO_UNSIGNED(0, 4) ELSE p_reg_word_i(1);
    s_b_reg_word_23(i) <= p_reg_word_i(2) WHEN p_sel_b_i(i) = TO_UNSIGNED(2, 4) ELSE p_reg_word_i(3);
    s_b_reg_word_45(i) <= p_reg_word_i(4) WHEN p_sel_b_i(i) = TO_UNSIGNED(4, 4) ELSE p_reg_word_i(5);
    s_b_reg_word_67(i) <= p_reg_word_i(6) WHEN p_sel_b_i(i) = TO_UNSIGNED(6, 4) ELSE p_reg_word_i(7);
    s_b_reg_word_89(i) <= p_reg_word_i(8) WHEN p_sel_b_i(i) = TO_UNSIGNED(8, 4) ELSE p_reg_word_i(9);
    s_b_reg_word_0123(i) <= s_b_reg_word_01_r(i) WHEN p_sel_b_i(i) < TO_UNSIGNED(2, 4) ELSE s_b_reg_word_23_r(i);
    s_b_reg_word_4567(i) <= s_b_reg_word_45_r(i) WHEN p_sel_b_i(i) < TO_UNSIGNED(6, 4) ELSE s_b_reg_word_67_r(i);
    s_b_reg_word_456789(i) <= s_b_reg_word_4567(i) WHEN p_sel_b_i(i) < TO_UNSIGNED(8, 4) ELSE s_b_reg_word_89_r(i) ;   
    p_alu_b_data_o(i) <=  s_b_reg_word_0123_r(i) WHEN p_sel_b_i(i) < TO_UNSIGNED(4, 4) ELSE s_b_reg_word_456789_r(i);
    
    s_b_reg_size_01(i) <= p_reg_mat_size_i(0) WHEN p_sel_b_i(i) = TO_UNSIGNED(0, 4) ELSE p_reg_mat_size_i(1);
    s_b_reg_size_23(i) <= p_reg_mat_size_i(2) WHEN p_sel_b_i(i) = TO_UNSIGNED(2, 4) ELSE p_reg_mat_size_i(3);
    s_b_reg_size_45(i) <= p_reg_mat_size_i(4) WHEN p_sel_b_i(i) = TO_UNSIGNED(4, 4) ELSE p_reg_mat_size_i(5);
    s_b_reg_size_67(i) <= p_reg_mat_size_i(6) WHEN p_sel_b_i(i) = TO_UNSIGNED(6, 4) ELSE p_reg_mat_size_i(7);
    s_b_reg_size_89(i) <= p_reg_mat_size_i(8) WHEN p_sel_b_i(i) = TO_UNSIGNED(8, 4) ELSE p_reg_mat_size_i(9);
    s_b_reg_size_0123(i) <= s_b_reg_size_01_r(i) WHEN p_sel_b_i(i) < TO_UNSIGNED(2, 4) ELSE s_b_reg_size_23_r(i);
    s_b_reg_size_4567(i) <= s_b_reg_size_45_r(i) WHEN p_sel_b_i(i) < TO_UNSIGNED(6, 4) ELSE s_b_reg_size_67_r(i);
    s_b_reg_size_456789(i) <= s_b_reg_size_4567(i) WHEN p_sel_b_i(i) < TO_UNSIGNED(8, 4) ELSE s_b_reg_size_89_r(i) ;   
    p_alu_b_size_o(i) <=  s_b_reg_size_0123_r(i) WHEN p_sel_b_i(i) < TO_UNSIGNED(4, 4) ELSE s_b_reg_size_456789_r(i);
END GENERATE generate_b;


proc_reg_b: PROCESS(p_rst_i, p_clk_i)
BEGIN
    IF p_rst_i = '1' THEN
        s_b_reg_row_by_row_01_r <= (OTHERS => '0');
        s_b_reg_row_by_row_23_r <= (OTHERS => '0');
        s_b_reg_row_by_row_45_r <= (OTHERS => '0');
        s_b_reg_row_by_row_67_r <= (OTHERS => '0');
        s_b_reg_row_by_row_89_r <= (OTHERS => '0');
        s_b_reg_row_by_row_0123_r <= (OTHERS => '0');
        s_b_reg_row_by_row_456789_r <= (OTHERS => '0');
        
        s_b_reg_word_01_r <= (OTHERS => c_mat_word_zero);
        s_b_reg_word_23_r <= (OTHERS => c_mat_word_zero);
        s_b_reg_word_45_r <= (OTHERS => c_mat_word_zero);
        s_b_reg_word_67_r <= (OTHERS => c_mat_word_zero);
        s_b_reg_word_89_r <= (OTHERS => c_mat_word_zero);
        s_b_reg_word_0123_r <= (OTHERS => c_mat_word_zero);
        s_b_reg_word_456789_r <= (OTHERS => c_mat_word_zero);
        
        s_b_reg_size_01_r <= (OTHERS => c_mat_size_zero);
        s_b_reg_size_23_r <= (OTHERS => c_mat_size_zero);
        s_b_reg_size_45_r <= (OTHERS => c_mat_size_zero);
        s_b_reg_size_67_r <= (OTHERS => c_mat_size_zero);
        s_b_reg_size_89_r <= (OTHERS => c_mat_size_zero);
        s_b_reg_size_0123_r <= (OTHERS => c_mat_size_zero);
        s_b_reg_size_456789_r <= (OTHERS => c_mat_size_zero);
    ELSIF RISING_EDGE(p_clk_i) THEN
        IF p_syn_rst_i = '1' THEN
            s_b_reg_row_by_row_01_r <= (OTHERS => '0');
            s_b_reg_row_by_row_23_r <= (OTHERS => '0');
            s_b_reg_row_by_row_45_r <= (OTHERS => '0');
            s_b_reg_row_by_row_67_r <= (OTHERS => '0');
            s_b_reg_row_by_row_89_r <= (OTHERS => '0');
            s_b_reg_row_by_row_0123_r <= (OTHERS => '0');
            s_b_reg_row_by_row_456789_r <= (OTHERS => '0');
            
            s_b_reg_word_01_r <= (OTHERS => c_mat_word_zero);
            s_b_reg_word_23_r <= (OTHERS => c_mat_word_zero);
            s_b_reg_word_45_r <= (OTHERS => c_mat_word_zero);
            s_b_reg_word_67_r <= (OTHERS => c_mat_word_zero);
            s_b_reg_word_89_r <= (OTHERS => c_mat_word_zero);
            s_b_reg_word_0123_r <= (OTHERS => c_mat_word_zero);
            s_b_reg_word_456789_r <= (OTHERS => c_mat_word_zero);
            
            s_b_reg_size_01_r <= (OTHERS => c_mat_size_zero);
            s_b_reg_size_23_r <= (OTHERS => c_mat_size_zero);
            s_b_reg_size_45_r <= (OTHERS => c_mat_size_zero);
            s_b_reg_size_67_r <= (OTHERS => c_mat_size_zero);
            s_b_reg_size_89_r <= (OTHERS => c_mat_size_zero);
            s_b_reg_size_0123_r <= (OTHERS => c_mat_size_zero);
            s_b_reg_size_456789_r <= (OTHERS => c_mat_size_zero);
        ELSE
            s_b_reg_row_by_row_01_r <= s_b_reg_row_by_row_01;
            s_b_reg_row_by_row_23_r <= s_b_reg_row_by_row_23;
            s_b_reg_row_by_row_45_r <= s_b_reg_row_by_row_45;
            s_b_reg_row_by_row_67_r <= s_b_reg_row_by_row_67;
            s_b_reg_row_by_row_89_r <= s_b_reg_row_by_row_89;
            s_b_reg_row_by_row_0123_r <= s_b_reg_row_by_row_0123;
            s_b_reg_row_by_row_456789_r <= s_b_reg_row_by_row_456789;
            
            s_b_reg_word_01_r <= s_b_reg_word_01;
            s_b_reg_word_23_r <= s_b_reg_word_23;
            s_b_reg_word_45_r <= s_b_reg_word_45;
            s_b_reg_word_67_r <= s_b_reg_word_67;
            s_b_reg_word_89_r <= s_b_reg_word_89;
            s_b_reg_word_0123_r <= s_b_reg_word_0123;
            s_b_reg_word_456789_r <= s_b_reg_word_456789;
            
            s_b_reg_size_01_r <= s_b_reg_size_01;
            s_b_reg_size_23_r <= s_b_reg_size_23;
            s_b_reg_size_45_r <= s_b_reg_size_45;
            s_b_reg_size_67_r <= s_b_reg_size_67;
            s_b_reg_size_89_r <= s_b_reg_size_89;
            s_b_reg_size_0123_r <= s_b_reg_size_0123;
            s_b_reg_size_456789_r <= s_b_reg_size_456789;
        END IF;
    END IF;
END PROCESS proc_reg_b;

----------------------------------------------------------------------------------------------------
--  Write ALU (C) -> Register
----------------------------------------------------------------------------------------------------

proc_mux_write : PROCESS(p_opcode_i, p_sel_c_i, p_alu_c_wren_i, p_alu_c_size_i, p_alu_c_row_by_row_i, p_alu_c_ix_write_i, p_alu_c_data_i, p_sel_a_i, p_write_a0_i, p_size_a0_i, p_row_by_row_a0_i, p_ix_a0_i, p_data_a0_i)
BEGIN    
    FOR reg IN c_num_mat_regs-1 DOWNTO 0 LOOP 
        -- Standardwerte
        s_reg_wren(reg) <= '0';
        p_reg_mat_size_o(reg) <= c_mat_size_dontcare;
        p_reg_row_by_row_o(reg) <= '-';
        p_reg_ix_write_o(reg) <= c_mat_ix_dontcare;
        p_reg_word_o(reg) <= set_mat_word('-');
    
        FOR opnum IN c_num_parallel_op-1 DOWNTO 0 LOOP
            IF p_opcode_i(opnum) /= NoOp THEN
                IF p_sel_c_i(opnum) = TO_UNSIGNED(reg, p_sel_c_i(opnum)'LENGTH) THEN
                    s_reg_wren(reg) <= p_alu_c_wren_i(opnum);
                    p_reg_mat_size_o(reg) <= p_alu_c_size_i(opnum);
                    p_reg_row_by_row_o(reg) <= p_alu_c_row_by_row_i(opnum);
                    p_reg_ix_write_o(reg) <= p_alu_c_ix_write_i(opnum);
                    p_reg_word_o(reg) <= p_alu_c_data_i(opnum);
                END IF;
            END IF;
        END LOOP;
    END LOOP;
     
    IF p_write_a0_i = '1' THEN
        FOR reg IN c_max_writable_reg DOWNTO 0 LOOP 
            IF p_sel_a_i(0) = TO_UNSIGNED(reg, p_sel_a_i(0)'LENGTH) THEN
                s_reg_wren(reg) <= '1';
                p_reg_mat_size_o(reg) <= p_size_a0_i;
                p_reg_row_by_row_o(reg) <= p_row_by_row_a0_i;
                p_reg_ix_write_o(reg) <= p_ix_a0_i;
                p_reg_word_o(reg) <= p_data_a0_i;
            END IF;
        END LOOP;
    END IF;
 
END PROCESS proc_mux_write;

END ARCHITECTURE a_mega_mux;
