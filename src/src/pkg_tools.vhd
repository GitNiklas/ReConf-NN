----------------------------------------------------------------------------------------------------
-- Package pkg_tools
-- Enthaelt Typen, Hilfsfunktionen und Konstanten zur Verwendung an mehreren Stellen.
----------------------------------------------------------------------------------------------------
LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.fixed_pkg.ALL;
    
PACKAGE pkg_tools IS
    
----------------------------------------------------------------------------------------------------
--  Generelle Hilfsdefinitionen
----------------------------------------------------------------------------------------------------
    CONSTANT c_base_clk_per     : TIME      := 20 ns; -- Periodendauer des Basistakts (50 MHz)
    CONSTANT c_clk_per          : TIME      := 100 ns; -- Periodendauer des verwendeten PLL-Takts (10 MHz)
    
    ----------------------------------------------------------------------------------------------------
    -- Function bcd_to_7ss
    -- Parameter:
    --    IN:       bcd
    --    RETURN:   7SS-Code: STD_LOGIC_VECTOR(6 DOWNTO 0)
    ----------------------------------------------------------------------------------------------------
    FUNCTION bcd_to_7ss(bcd: STD_LOGIC_VECTOR(3 DOWNTO 0)) RETURN STD_LOGIC_VECTOR;
    
    ----------------------------------------------------------------------------------------------------
    -- Procedure f_reg. Realisiert ein Register.
    -- Parameter:
    --    IN:   s_rst_i:        Asynchroner Reset  
    --    IN:   s_clk_i:        Takt   
    --    IN:   s_syn_rst_i:    Synchroner Reset
    --    IN:   s_dat_i:        Eingangsdaten
    --    OUT:  s_dat_o:        Ausgangsdaten
    ----------------------------------------------------------------------------------------------------
    PROCEDURE f_reg(
        SIGNAL s_rst_i      : IN STD_LOGIC;
        SIGNAL s_clk_i      : IN STD_LOGIC;
        SIGNAL s_syn_rst_i  : IN STD_LOGIC;
        SIGNAL s_dat_i      : IN STD_LOGIC;
        SIGNAL s_dat_o      : OUT STD_LOGIC
    );
    
    FUNCTION to_sl(x: BOOLEAN) RETURN STD_LOGIC;
    FUNCTION to_bool(x: STD_LOGIC) RETURN BOOLEAN;
    
----------------------------------------------------------------------------------------------------
--  Serielle Kommunikation
----------------------------------------------------------------------------------------------------
    SUBTYPE t_byte IS STD_LOGIC_VECTOR(7 DOWNTO 0);
    CONSTANT c_baudrate : POSITIVE  :=  9600;
    
    ----------------------------------------------------------------------------------------------------
    -- Function f_calc_serial_wait. Berechnet aus der Baudrate die Wartezeit zwischen den Datenbits
    -- Parameter:
    --    IN:       baudrate
    --    RETURN:   Zeit zwischen zwei Pegelwechseln der Datenkanaele
    ----------------------------------------------------------------------------------------------------
    FUNCTION f_calc_serial_wait_time(baudrate: POSITIVE) RETURN TIME;
    
----------------------------------------------------------------------------------------------------
--  Textausgabe
----------------------------------------------------------------------------------------------------
    FUNCTION infomsg(x: STRING) RETURN STRING;
    FUNCTION err(x: STRING) RETURN STRING;
    FUNCTION to_hex(x: t_byte) RETURN STRING;
   
----------------------------------------------------------------------------------------------------
--  Typdefinitionen Matrix
----------------------------------------------------------------------------------------------------
    CONSTANT c_max_mat_dim : INTEGER := 64; 
    CONSTANT c_batch_size : INTEGER := c_max_mat_dim;

    SUBTYPE t_mat_elem_slv IS STD_LOGIC_VECTOR(7 DOWNTO 0);
    SUBTYPE t_mat_elem IS sfixed(3 DOWNTO -4);
    TYPE t_mat_word IS ARRAY(31 DOWNTO 0) OF t_mat_elem;
    TYPE t_mat_word_const IS ARRAY(31 DOWNTO 0) OF REAL;
    
    SUBTYPE t_mat_ix_elem IS UNSIGNED(5 DOWNTO 0);
    TYPE t_mat_ix IS RECORD
        row : t_mat_ix_elem;
        col : t_mat_ix_elem;
    END RECORD t_mat_ix;  
    
    TYPE t_mat_size IS RECORD
        max_row : t_mat_ix_elem; -- max_row = height - 1
        max_col : t_mat_ix_elem; -- max_col = width - 1
    END RECORD t_mat_size;  

    ----------------------------------------------------------------------------------------------------
    -- Function set_mat_word. Setzt alle Bits eines Worts auf einen konstanten Std_logic-Wert
    ----------------------------------------------------------------------------------------------------
    FUNCTION set_mat_word(x: STD_LOGIC) RETURN t_mat_word;
    
----------------------------------------------------------------------------------------------------
--  Typdefinitionen Matrixregister
----------------------------------------------------------------------------------------------------          
    CONSTANT c_num_mat_regs : INTEGER := 10; 
    CONSTANT c_max_writable_reg : INTEGER := 4; 
       
    SUBTYPE t_mat_reg_ix IS UNSIGNED(3 DOWNTO 0); -- Da nur 10 Matrixregister, wird nur der Bereich 0 bis 9 genutzt
    
    TYPE t_mat_ix_arr IS ARRAY(c_num_mat_regs-1 DOWNTO 0) OF t_mat_ix; -- Typ fuer die Indizes aller register
    TYPE t_mat_size_arr IS ARRAY(c_num_mat_regs-1 DOWNTO 0) OF t_mat_size; -- Typ fuer die Gröessen aller register
    TYPE t_mat_word_arr IS ARRAY(c_num_mat_regs-1 DOWNTO 0) OF t_mat_word; -- Typ fuer die Datenleitungen aller register
    TYPE t_mat_logic_arr IS ARRAY(c_num_mat_regs-1 DOWNTO 0) OF STD_LOGIC;
    
----------------------------------------------------------------------------------------------------
--  Typdefinitionen OpCores
----------------------------------------------------------------------------------------------------    
    TYPE t_opcode IS (MatMul, MatAdd, VecAdd, MatTrans, ColSum, ScalarMul, ScalarDiv, ScalarMax, ScalarSubIx, NoOp);
    CONSTANT c_num_parallel_op : INTEGER := 2;
    
    TYPE t_opcodes IS ARRAY(c_num_parallel_op-1 DOWNTO 0) OF t_opcode;
    TYPE t_mat_elems IS ARRAY(c_num_parallel_op-1 DOWNTO 0) OF t_mat_elem;
    TYPE t_mat_sizes IS ARRAY(c_num_parallel_op-1 DOWNTO 0) OF  t_mat_size;
    TYPE t_mat_words IS ARRAY(c_num_parallel_op-1 DOWNTO 0) OF t_mat_word;
    TYPE t_op_std_logics IS ARRAY(c_num_parallel_op-1 DOWNTO 0) OF STD_LOGIC;
    TYPE t_mat_ixs IS ARRAY(c_num_parallel_op-1 DOWNTO 0) OF t_mat_ix;
    TYPE t_mat_reg_ixs IS ARRAY(c_num_parallel_op-1 DOWNTO 0) OF t_mat_reg_ix;
    
----------------------------------------------------------------------------------------------------
--  Typdefinitionen CPU-Interpreter
----------------------------------------------------------------------------------------------------     
    TYPE t_cpu_base_instr IS RECORD
        opcode : t_opcode;
        sel_a : t_mat_reg_ix;
        sel_b : t_mat_reg_ix;
        sel_c : t_mat_reg_ix;
        row_by_row : STD_LOGIC;
    END RECORD t_cpu_base_instr;
    
    TYPE t_cpu_instr IS ARRAY(0 TO c_num_parallel_op-1) OF t_cpu_base_instr;
    TYPE t_program IS ARRAY (INTEGER RANGE <>) OF t_cpu_instr;
    
----------------------------------------------------------------------------------------------------
--  Konvertierungsfunktionen
----------------------------------------------------------------------------------------------------
    FUNCTION to_mat_word(x: t_mat_word_const) RETURN t_mat_word;
    
    FUNCTION to_mat_elem(x: REAL) RETURN t_mat_elem;
    FUNCTION to_mat_elem(x: UNRESOLVED_sfixed) RETURN t_mat_elem;
    FUNCTION to_mat_elem(x: STD_LOGIC_VECTOR) RETURN t_mat_elem;
    
    FUNCTION to_mat_ix_el(x: INTEGER) RETURN t_mat_ix_elem;
    FUNCTION to_mat_ix(row: INTEGER; col: INTEGER) RETURN t_mat_ix;
    
    FUNCTION to_mat_size_el(x: INTEGER) RETURN t_mat_ix_elem;
    FUNCTION to_mat_size(max_row: INTEGER; max_col: INTEGER) RETURN t_mat_size;   
    
    FUNCTION to_mat_reg_ix(x: INTEGER) RETURN t_mat_reg_ix; 
    
    FUNCTION mat_elem_to_str(x: t_mat_elem) RETURN STRING;
    FUNCTION mat_size_to_str(x: t_mat_size) RETURN STRING;
    
----------------------------------------------------------------------------------------------------
--  Matrix-Konstanten
----------------------------------------------------------------------------------------------------    
    CONSTANT c_mat_ix_zero : t_mat_ix;
    CONSTANT c_mat_size_zero : t_mat_size;
    CONSTANT c_mat_elem_zero : t_mat_elem;
    CONSTANT c_mat_word_zero : t_mat_word;
    CONSTANT c_noop_instr : t_cpu_base_instr;
    FUNCTION c_mat_ix_dontcare RETURN t_mat_ix;
    FUNCTION c_mat_size_dontcare RETURN t_mat_size;
    FUNCTION c_mat_reg_ix_dontcare RETURN t_mat_reg_ix;
END;


----------------------------------------------------------------------------------------------------
-- Package Body
----------------------------------------------------------------------------------------------------    
PACKAGE BODY pkg_tools IS   
----------------------------------------------------------------------------------------------------
--  Generelle Hilfsdefinitionen
----------------------------------------------------------------------------------------------------
    FUNCTION bcd_to_7ss(bcd: STD_LOGIC_VECTOR(3 DOWNTO 0)) RETURN STD_LOGIC_VECTOR IS
    VARIABLE res : STD_LOGIC_VECTOR(6 DOWNTO 0);
    BEGIN
        -- 7SS Kodierung: 0 = An; 1 = Aus; (Mitte, LinksOben, LinksUnten, Unten, RechtsUnten, RechtsOben, Oben)
        CASE bcd IS
                WHEN x"0"   => res := "1000000"; 
                WHEN x"1"   => res := "1111001";
                WHEN x"2"   => res := "0100100";
                WHEN x"3"   => res := "0110000";
                WHEN x"4"   => res := "0011001";
                WHEN x"5"   => res := "0010010";
                WHEN x"6"   => res := "0000010";
                WHEN x"7"   => res := "1111000";
                WHEN x"8"   => res := "0000000";
                WHEN x"9"   => res := "0010000";
                WHEN x"A"   => res := "0001000";
                WHEN x"B"   => res := "0000011";
                WHEN x"C"   => res := "0000110";
                WHEN x"D"   => res := "0100001";
                WHEN x"E"   => res := "1000110";
                WHEN x"F"   => res := "0001110";
                WHEN OTHERS => res := "0110110";
        END CASE;
        RETURN res;
    END;
    
    PROCEDURE f_reg(
        SIGNAL s_rst_i      : IN STD_LOGIC;
        SIGNAL s_clk_i      : IN STD_LOGIC;
        SIGNAL s_syn_rst_i  : IN STD_LOGIC;
        SIGNAL s_dat_i      : IN STD_LOGIC;
        SIGNAL s_dat_o      : OUT STD_LOGIC
    ) IS
    BEGIN
        IF s_rst_i = '1' THEN
            s_dat_o <= '0';
        ELSIF RISING_EDGE(s_clk_i) THEN
            IF s_syn_rst_i = '1' THEN
                s_dat_o <= '0';
            ELSE
                s_dat_o <= s_dat_i;
            END IF;
        END IF;
    END f_reg;
    
    FUNCTION to_sl(x: BOOLEAN) RETURN STD_LOGIC IS
    BEGIN
        IF x THEN 
            RETURN '1';
        ELSE
            RETURN '0';
        END IF;
    END to_sl;

    FUNCTION to_bool(x: STD_LOGIC) RETURN BOOLEAN IS
    BEGIN
        IF x = '1' THEN 
            RETURN TRUE;
        ELSE
            RETURN FALSE;
        END IF;
    END to_bool;
    
----------------------------------------------------------------------------------------------------
--  Serielle Kommunikation
----------------------------------------------------------------------------------------------------
    FUNCTION f_calc_serial_wait_time(baudrate: POSITIVE) RETURN TIME IS
    BEGIN
        RETURN 1 sec / baudrate; 
    END f_calc_serial_wait_time;
    
----------------------------------------------------------------------------------------------------
--  Textausgabe
----------------------------------------------------------------------------------------------------
    CONSTANT c_err_prefix : STRING :=   "-------------------- ERROR -------------------- ";
    CONSTANT c_info_prefix : STRING :=  "                                                ";
    
    FUNCTION infomsg(x: STRING) RETURN STRING IS
    BEGIN
        RETURN c_info_prefix & x;
    END;
    
    FUNCTION err(x: STRING) RETURN STRING IS
    BEGIN
        RETURN c_err_prefix & x;
    END;
    
    FUNCTION to_hex(x: t_byte) RETURN STRING IS
    VARIABLE tmp : STRING(1 TO 4) := "____";
    BEGIN
    --pragma synthesis_off
        tmp := "0x" & to_hstring(to_ufixed(x, 7, 0))(1 TO 2);
    --pragma synthesis_on
        RETURN tmp;
    END;
    
----------------------------------------------------------------------------------------------------
--  Typdefinitionen Matrix
----------------------------------------------------------------------------------------------------
    FUNCTION set_mat_word(x: STD_LOGIC) RETURN t_mat_word IS
    VARIABLE data : t_mat_elem_slv;
    VARIABLE res : t_mat_word;
    BEGIN
        data := (OTHERS => x);
        FOR i IN t_mat_word'RANGE LOOP
            res(i) := t_mat_elem(data);
        END LOOP;
        RETURN res;
    END;

----------------------------------------------------------------------------------------------------
--  Konvertierungsfunktionen
----------------------------------------------------------------------------------------------------

    FUNCTION to_mat_word(x: t_mat_word_const) RETURN t_mat_word IS
        VARIABLE v_res : t_mat_word;
    BEGIN
        FOR i IN t_mat_word_const'RANGE LOOP 
            v_res(v_res'HIGH - i) := to_mat_elem(x(i));
        END LOOP;
        RETURN v_res;
    END to_mat_word;
    
    
    
    
    FUNCTION to_mat_elem(x: REAL) RETURN t_mat_elem IS
    BEGIN
        RETURN to_sfixed(x, t_mat_elem'HIGH, t_mat_elem'LOW);
    END to_mat_elem;
    
    FUNCTION to_mat_elem(x: UNRESOLVED_sfixed) RETURN t_mat_elem IS
    BEGIN
        RETURN RESIZE(x, t_mat_elem'HIGH, t_mat_elem'LOW);
    END to_mat_elem;
    
    FUNCTION to_mat_elem(x: STD_LOGIC_VECTOR) RETURN t_mat_elem IS
    BEGIN
        RETURN to_sfixed(x, t_mat_elem'HIGH, t_mat_elem'LOW);
    END to_mat_elem;
    
    
    
    FUNCTION to_mat_ix_el(x: INTEGER) RETURN t_mat_ix_elem IS
    BEGIN
        RETURN TO_UNSIGNED(x, t_mat_ix_elem'LENGTH); 
    END to_mat_ix_el;
    
    FUNCTION to_mat_ix(row: INTEGER; col: INTEGER) RETURN t_mat_ix IS
    BEGIN
        RETURN (to_mat_ix_el(row), to_mat_ix_el(col)); 
    END to_mat_ix;
    
    FUNCTION to_mat_size_el(x: INTEGER) RETURN t_mat_ix_elem IS
    BEGIN
        RETURN TO_UNSIGNED(x - 1, t_mat_ix_elem'LENGTH); 
    END to_mat_size_el;
    
    FUNCTION to_mat_size(max_row: INTEGER; max_col: INTEGER) RETURN t_mat_size IS
    BEGIN
        RETURN (to_mat_size_el(max_row), to_mat_size_el(max_col)); 
    END to_mat_size;
  
  
    
    FUNCTION to_mat_reg_ix(x: INTEGER) RETURN t_mat_reg_ix IS
    BEGIN
        IF x < c_num_mat_regs THEN
            RETURN TO_UNSIGNED(x, t_mat_reg_ix'LENGTH);
        ELSE
            RETURN TO_UNSIGNED(0, t_mat_reg_ix'LENGTH);
        END IF;
    END to_mat_reg_ix;
    
 
    
    FUNCTION mat_elem_to_str(x: t_mat_elem) RETURN STRING IS
    VARIABLE str_bits : STRING(1 TO 9) := "????.????";
    BEGIN
    --pragma synthesis_off
        str_bits := to_string(x);
    --pragma synthesis_on
        RETURN str_bits;
    END;
    
    FUNCTION mat_size_to_str(x: t_mat_size) RETURN STRING IS
    BEGIN
        RETURN INTEGER'IMAGE(to_integer(to_ufixed(x.max_row, x.max_row'LENGTH)) + 1) & "x" & INTEGER'IMAGE(to_integer(to_ufixed(x.max_col, x.max_col'LENGTH)) + 1);
    END;
    
----------------------------------------------------------------------------------------------------
--  Matrix-Konstanten
----------------------------------------------------------------------------------------------------    
    CONSTANT in_simulation : BOOLEAN := FALSE
    --pragma synthesis_off
                                        OR TRUE
    --pragma synthesis_on
    ;
    
    CONSTANT c_mat_ix_zero : t_mat_ix := to_mat_ix(0, 0);
    CONSTANT c_mat_size_zero : t_mat_size := to_mat_size(1, 1);
    CONSTANT c_mat_elem_zero : t_mat_elem := to_mat_elem(0.0);
    CONSTANT c_mat_word_zero : t_mat_word := (OTHERS => c_mat_elem_zero);
    CONSTANT c_noop_instr : t_cpu_base_instr := (NoOp, to_mat_reg_ix(0), to_mat_reg_ix(0), to_mat_reg_ix(0), '1');
    
    FUNCTION c_mat_ix_dontcare RETURN t_mat_ix IS
    BEGIN
        IF in_simulation THEN
            RETURN to_mat_ix(0, 0);
        ELSE
            RETURN ((OTHERS => '-'), (OTHERS => '-'));
        END IF;    
    END;
    
    FUNCTION c_mat_size_dontcare RETURN t_mat_size IS
    BEGIN
        IF in_simulation THEN
            RETURN to_mat_size(1, 1);
        ELSE
            RETURN ((OTHERS => '-'), (OTHERS => '-'));
        END IF;    
    END;
    
    FUNCTION c_mat_reg_ix_dontcare RETURN t_mat_reg_ix IS
    BEGIN
        IF in_simulation THEN
            RETURN to_mat_reg_ix(0);
        ELSE
            RETURN (OTHERS => '-');
        END IF;    
    END;
    
END PACKAGE BODY;