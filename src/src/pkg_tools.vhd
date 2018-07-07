----------------------------------------------------------------------------------------------------
--  Package pkg_tools
--  Enthaelt Typen, Hilfsfunktionen und Konstanten zur Verwendung an mehreren Stellen.
--
--  Autor: Niklas Kuehl
--  Datum: 26.04.2018
----------------------------------------------------------------------------------------------------
LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.fixed_pkg.ALL;
    
PACKAGE pkg_tools IS
    
----------------------------------------------------------------------------------------------------
--  General
----------------------------------------------------------------------------------------------------
    CONSTANT c_clk_per          : TIME      := 20 ns; -- Periodendauer des Takts des Cyclone II Boards
    
----------------------------------------------------------------------------------------------------
--  Matrix Typen
----------------------------------------------------------------------------------------------------
    CONSTANT c_max_mat_dim : INTEGER := 64; 
    CONSTANT c_batch_size : INTEGER := c_max_mat_dim;
    CONSTANT c_num_mat_regs : INTEGER := 10; 
    CONSTANT c_num_parallel_op : INTEGER := 2; -- Anzahl parallel ausfuehrbarer Matrix-Operationen
    
    SUBTYPE t_mat_reg_ix IS UNSIGNED(3 DOWNTO 0); -- Range 0 to 11 used
        
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
        max_row : t_mat_ix_elem; -- = height - 1
        max_col : t_mat_ix_elem; -- = width - 1
    END RECORD t_mat_size;  
    
    TYPE t_mat_ix_arr IS ARRAY(c_num_mat_regs-1 DOWNTO 0) OF t_mat_ix; -- Typ fuer die Indizes aller register
    TYPE t_mat_size_arr IS ARRAY(c_num_mat_regs-1 DOWNTO 0) OF t_mat_size; -- Typ fuer die Gröessen aller register
    TYPE t_mat_word_arr IS ARRAY(c_num_mat_regs-1 DOWNTO 0) OF t_mat_word; -- Typ fuer die Datenleitungen aller register
    TYPE t_mat_logic_arr IS ARRAY(c_num_mat_regs-1 DOWNTO 0) OF STD_LOGIC;

    TYPE t_opcode IS (MatDel, MatMul, MatAdd, MatTrans, ScalarAdd, ScalarMul, ScalarDiv, ScalarMax, NoOp);
    
    -- Typen fuer alle Parallel ausgefuehrten Operationen
    TYPE t_opcodes IS ARRAY(c_num_parallel_op-1 DOWNTO 0) OF t_opcode;
    TYPE t_mat_elems IS ARRAY(c_num_parallel_op-1 DOWNTO 0) OF t_mat_elem;
    TYPE t_mat_sizes IS ARRAY(c_num_parallel_op-1 DOWNTO 0) OF t_mat_size;
    TYPE t_mat_words IS ARRAY(c_num_parallel_op-1 DOWNTO 0) OF t_mat_word;
    TYPE t_op_std_logics IS ARRAY(c_num_parallel_op-1 DOWNTO 0) OF STD_LOGIC;
    TYPE t_mat_ixs IS ARRAY(c_num_parallel_op-1 DOWNTO 0) OF t_mat_ix;
    TYPE t_mat_reg_ixs IS ARRAY(c_num_parallel_op-1 DOWNTO 0) OF t_mat_reg_ix;
    
    FUNCTION to_sl(x: BOOLEAN) RETURN STD_LOGIC;
    FUNCTION to_mat_word(x: t_mat_word_const) RETURN t_mat_word; 
    FUNCTION to_mat_elem(x: REAL) RETURN t_mat_elem;
    FUNCTION to_mat_elem(x: UNRESOLVED_sfixed) RETURN t_mat_elem;
    FUNCTION to_mat_ix_el(x: INTEGER) RETURN t_mat_ix_elem;
    FUNCTION to_mat_ix(row: INTEGER; col: INTEGER) RETURN t_mat_ix;
    FUNCTION to_mat_size_el(x: INTEGER) RETURN t_mat_ix_elem;
    FUNCTION to_mat_size(max_row: INTEGER; max_col: INTEGER) RETURN t_mat_size;
    FUNCTION to_mat_reg_ix(x: INTEGER) RETURN t_mat_reg_ix;
    FUNCTION mat_elem_to_str(x: t_mat_elem) RETURN STRING;
    FUNCTION mat_size_to_str(x: t_mat_size) RETURN STRING;
    
    PROCEDURE f_reg(
        SIGNAL s_rst_i      : IN STD_LOGIC;
        SIGNAL s_clk_i      : IN STD_LOGIC;
        SIGNAL s_syn_rst_i  : IN STD_LOGIC;
        SIGNAL s_dat_i      : IN STD_LOGIC;
        SIGNAL s_dat_o      : OUT STD_LOGIC
    );
    
----------------------------------------------------------------------------------------------------
--  Matrix Konstanten
----------------------------------------------------------------------------------------------------    
    CONSTANT c_mat_ix_zero : t_mat_ix;
    CONSTANT c_mat_size_zero : t_mat_size;
    CONSTANT c_mat_elem_zero : t_mat_elem;
    CONSTANT c_mat_word_zero : t_mat_word;
    
----------------------------------------------------------------------------------------------------
--  Serial
----------------------------------------------------------------------------------------------------
    SUBTYPE t_byte IS STD_LOGIC_VECTOR(7 DOWNTO 0);
    CONSTANT c_baudrate : POSITIVE  := 115200;
    
    ----------------------------------------------------------------------------------------------------
    -- Function f_calc_serial_wait
    -- Parameter:
    --    IN:       baudrate
    --    RETURN:   Zeit zwischen zwei Pegelwechseln der Datenkanaele
    ----------------------------------------------------------------------------------------------------
    FUNCTION f_calc_serial_wait_time(baudrate: POSITIVE) RETURN TIME;

END;

PACKAGE BODY pkg_tools IS

    FUNCTION to_sl(x: BOOLEAN) RETURN STD_LOGIC IS
    BEGIN
        IF x THEN 
            RETURN '1';
        ELSE
            RETURN '0';
        END IF;
    END to_sl;
    
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
   
    FUNCTION f_calc_serial_wait_time(baudrate: POSITIVE) RETURN TIME IS
    BEGIN
        RETURN 1 sec / baudrate; 
    END f_calc_serial_wait_time;
    
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
    
    
    CONSTANT c_mat_ix_zero : t_mat_ix := to_mat_ix(0, 0);
    CONSTANT c_mat_size_zero : t_mat_size := to_mat_size(1, 1);
    CONSTANT c_mat_elem_zero : t_mat_elem := to_mat_elem(0.0);
    CONSTANT c_mat_word_zero : t_mat_word := (OTHERS => c_mat_elem_zero);
END PACKAGE BODY;