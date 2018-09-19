----------------------------------------------------------------------------------------------------
--  Package pkg_test
--  Enthaelt Typen, Hilfsfunktionen und Konstanten zur Verwendung in den Testbenches.
--
--  Autor: Niklas Kuehl
----------------------------------------------------------------------------------------------------
LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;
USE work.pkg_tools.ALL;
USE work.fixed_pkg.ALL;
USE std.textio.ALL;

PACKAGE pkg_test IS    
    
    -- Baudrate zum Testen
    CONSTANT c_test_baudrate : POSITIVE;
    
    ----------------------------------------------------------------------------------------------------
    -- Sendet ein Byte ueber die serielle Schnittstelle
    -- Parameter:
    --    IN:   data:   Zu sendende Daten 
    --    OUT:  s_tx:   Sendekanal  
    ----------------------------------------------------------------------------------------------------
    PROCEDURE serial_send(data : t_byte; SIGNAL s_tx : OUT STD_LOGIC);
    
    ----------------------------------------------------------------------------------------------------
    -- Empfaengt ein Byte ueber die serielle Schnittstelle
    -- Parameter:
    --    OUT:  data:   Empfangene Daten 
    --    IN:  s_rx:    Empfangskanal  
    ----------------------------------------------------------------------------------------------------
    PROCEDURE serial_receive(VARIABLE data : OUT t_byte; SIGNAL s_rx : IN STD_LOGIC);
    
    ----------------------------------------------------------------------------------------------------
    -- Generiert ein zufaelliges Element in einem bestimmten Wertebereich
    -- Parameter:
    --      IN:     min, max:       Wertebereich
    --      INOUT:  seed1, seed2:   Seeds fuer die Zufallszahlengenerierung
    --      OUT:    res:            Zufaelliges Element           
    ----------------------------------------------------------------------------------------------------
    PROCEDURE random_elem(
        min, max : REAL;
        VARIABLE seed1, seed2 : INOUT POSITIVE;
        VARIABLE res : OUT REAL
    ); 
    
    ----------------------------------------------------------------------------------------------------
    -- Aktiviert den Debug-Modus von e_tle_nn, um den Inhalt eines Matrixregisters 
    -- in eine Datei zu schreiben
    -- Parameter:
    --    IN:   filename:       Dateiname
    --    IN:   reg:            Matrixregister
    --    IN:   m:              Groesse der Matrix (Anzahl Zeilen)
    --    IN:   n:              Groesse der Matrix (Anzahl Spalten)
    --    IN:   row_by_row:     Orientierung der Matrix
    --    OUT:  s_tx:           Sendekanal
    --    IN:   s_rx:           Empfangskanal 
    --    OUT:  s_set_dbg:      Leitung zum Aktivieren des Debug-Modus 
    ----------------------------------------------------------------------------------------------------
    PROCEDURE debug_save_mat_reg_to_file(
        CONSTANT filename       : IN STRING;
        CONSTANT reg            : IN INTEGER;
        CONSTANT m              : IN INTEGER;
        CONSTANT n              : IN INTEGER;
        CONSTANT row_by_row     : IN BOOLEAN;
        
        SIGNAL s_tx             : OUT STD_LOGIC;
        SIGNAL s_rx             : IN STD_LOGIC;
        SIGNAL s_set_dbg        : OUT STD_LOGIC
    );
    
    ----------------------------------------------------------------------------------------------------
    -- Empfaengt den Inhalt eines Matrix-Registers von der e_tle_nn und schreibt die Daten in eine Datei
    -- Parameter:
    --    IN:   filename:       Dateiname
    --    IN:   reg:            Matrixregister
    --    IN:   m:              Groesse der Matrix (Anzahl Zeilen)
    --    IN:   n:              Groesse der Matrix (Anzahl Spalten)
    --    IN:   row_by_row:     Orientierung der Matrix
    --    IN:   s_rx:           Empfangskanal 
    ----------------------------------------------------------------------------------------------------
    PROCEDURE receive_mat_save_to_file(
        CONSTANT filename       : IN STRING;
        CONSTANT reg            : IN INTEGER;
        CONSTANT m              : IN INTEGER;
        CONSTANT n              : IN INTEGER;
        CONSTANT row_by_row     : IN BOOLEAN;
        
        SIGNAL s_rx             : IN STD_LOGIC
    );
   
    ----------------------------------------------------------------------------------------------------
    -- Schreibt den Inhalt eines Matrix-Registers in eine Datei
    -- Parameter:
    --    IN:   filename:           Dateiname
    --    IN:   reg:                Matrixregister
    --    OUT:  sel_a               Auswahl Matrixregister     
    --    IN:   read_a:             Signalisiert einen Lesevorgang eines Matrixregisters
    --    OUT:  data_a:             Gelesende Daten
    --    OUT:  ix_a                Leseposition  
    --    IN:   size_a:             Groesse der Matrix
    --    IN:   row_by_row_a:       Orientierung der Matrix
    ----------------------------------------------------------------------------------------------------
    PROCEDURE save_mat_reg_to_file(
        CONSTANT filename       : IN STRING;
        CONSTANT reg            : IN INTEGER;
        
        SIGNAL sel_a            : OUT t_mat_reg_ix;      
        SIGNAL read_a           : OUT STD_LOGIC;
        SIGNAL data_a           : IN t_mat_word;
        SIGNAL ix_a             : OUT t_mat_ix;
        SIGNAL size_a           : IN t_mat_size;
        SIGNAL row_by_row_a     : IN STD_LOGIC
    );
    
    ----------------------------------------------------------------------------------------------------
    -- Gibt den Inhalt eines Matrix-Registers aus
    -- Parameter:
    --  IN:   reg:                Matrixregister
    --  OUT:  sel_a               Auswahl Matrixregister     
    --  IN:   read_a:             Signalisiert einen Lesevorgang eines Matrixregisters
    --  OUT:  data_a:             Gelesende Daten
    --  OUT:  ix_a                Leseposition  
    --  IN:   size_a:             Groesse der Matrix
    --  IN:   row_by_row_a:       Orientierung der Matrix
    ----------------------------------------------------------------------------------------------------
    PROCEDURE print_mat_reg(
        CONSTANT reg            : IN INTEGER;
        
        SIGNAL sel_a            : OUT t_mat_reg_ix;      
        SIGNAL read_a           : OUT STD_LOGIC;
        SIGNAL data_a           : IN t_mat_word;
        SIGNAL ix_a             : OUT t_mat_ix;
        SIGNAL size_a           : IN t_mat_size;
        SIGNAL row_by_row_a     : IN STD_LOGIC
    );
    
    ----------------------------------------------------------------------------------------------------
    -- Testet zwei Matrix-Register auf Gleichheit
    -- Parameter:
    --  IN:   reg_x:              1.  Matrixregister
    --  IN:   reg_y:              2.  Matrixregister  
    --  OUT:  sel_a               Auswahl Matrixregister     
    --  IN:   read_a:             Signalisiert einen Lesevorgang eines Matrixregisters
    --  OUT:  data_a:             Gelesende Daten
    --  OUT:  ix_a                Leseposition  
    --  IN:   size_a:             Groesse der Matrix
    --  IN:   row_by_row_a:       Orientierung der Matrix
    ----------------------------------------------------------------------------------------------------
    PROCEDURE assert_mat_reg_eq(
        CONSTANT reg_x          : IN INTEGER;
        CONSTANT reg_y          : IN INTEGER;
        
        SIGNAL sel_a            : OUT t_mat_reg_ix;      
        SIGNAL read_a           : OUT STD_LOGIC;
        SIGNAL data_a           : IN t_mat_word;
        SIGNAL ix_a             : OUT t_mat_ix;
        SIGNAL size_a           : IN t_mat_size;
        SIGNAL row_by_row_a     : IN STD_LOGIC
    );
    
    ----------------------------------------------------------------------------------------------------
    -- Loescht ein Matrix-Register
    -- Parameter:
    --  IN:     reg:            Matrixregister
    --  OUT:    s_sel:          Auswahl Matrixregister   
    --  OUT:    s_wren          Schreiberlaubnis Matrixregister     
    --  OUT:    s_data_i:       Zu schreibende Daten Matrixregister
    --  OUT:    s_ix_w:         Schreibposition
    --  OUT:    s_row_by_row    Orientierung der Matrix  
    ----------------------------------------------------------------------------------------------------
    PROCEDURE delete_reg(
        CONSTANT reg: INTEGER; 
        
        SIGNAL s_sel    : OUT t_mat_reg_ix;
        SIGNAL s_wren   : OUT STD_LOGIC;
        SIGNAL s_data_i : OUT t_mat_word;
        SIGNAL s_ix_w   : OUT t_mat_ix;
        SIGNAL s_row_by_row : OUT STD_LOGIC
    );
    
    ----------------------------------------------------------------------------------------------------
    -- Initialisiert ein Matrix-Register mit einem konstanten Wert
    -- Parameter:
    --  IN:     reg:            Matrixregister
    --  IN:     c_val:          Konstanter Wert zur Initialisierung
    --  OUT:    s_sel:          Auswahl Matrixregister   
    --  OUT:    s_wren          Schreiberlaubnis Matrixregister     
    --  OUT:    s_data_i:       Zu schreibende Daten Matrixregister
    --  OUT:    s_ix_w:         Schreibposition
    --  OUT:    s_row_by_row    Orientierung der Matrix  
    ----------------------------------------------------------------------------------------------------
    PROCEDURE set_reg(
        CONSTANT reg: INTEGER; 
        CONSTANT c_val  : IN t_mat_elem;
        
        SIGNAL s_sel    : OUT t_mat_reg_ix;
        SIGNAL s_wren   : OUT STD_LOGIC;
        SIGNAL s_data_i : OUT t_mat_word;
        SIGNAL s_ix_w   : OUT t_mat_ix;
        SIGNAL s_row_by_row : OUT STD_LOGIC
    );
END;

PACKAGE BODY pkg_test IS
    
    PROCEDURE ensure(
        x: BOOLEAN;
        msg: STRING
    ) IS
    BEGIN
        ASSERT x REPORT err(msg) SEVERITY FAILURE;
    END ensure;
        
    CONSTANT c_test_baudrate : POSITIVE := 2_500_000;
    CONSTANT c_test_serial_wait : TIME := f_calc_serial_wait_time(c_test_baudrate);
        
    PROCEDURE serial_send(data : t_byte; SIGNAL s_tx : OUT STD_LOGIC) IS 
    BEGIN
        s_tx <= '0';
        WAIT FOR c_test_serial_wait;
        
        FOR i IN 0 TO 7 LOOP
            s_tx <= data(i);
            WAIT FOR c_test_serial_wait;
        END LOOP;
        
        s_tx <= '1';
        WAIT FOR c_test_serial_wait;
        WAIT FOR 4*c_clk_per;
    END serial_send;

    PROCEDURE serial_receive(VARIABLE data : OUT t_byte; SIGNAL s_rx : IN STD_LOGIC) IS 
    VARIABLE    
        res : t_byte;
    BEGIN
        IF s_rx /= '0' THEN
            WAIT UNTIl s_rx = '0';
            WAIT FOR c_clk_per / 2;
        END IF;
        WAIT FOR c_test_serial_wait;
        
        WAIT FOR c_test_serial_wait / 2;   
        FOR i IN 0 TO 7 LOOP
            res(i) := s_rx;
            WAIT FOR c_test_serial_wait;
        END LOOP;
        
        IF s_rx /= '1' THEN
            WAIT UNTIl s_rx = '1';
            WAIT FOR c_clk_per / 2;
        END IF;
        data := res;
    END serial_receive;

    PROCEDURE random_elem(
        min, max : REAL;
        VARIABLE seed1, seed2 : INOUT POSITIVE;
        VARIABLE res : OUT REAL
    ) IS
    VARIABLE rand, val_range : REAL;
    BEGIN
        uniform(seed1, seed2, rand);
        res := rand * (max - min) + min;        
    END random_elem; 
    
 

 
    PROCEDURE debug_save_mat_reg_to_file(
        CONSTANT filename       : IN STRING;
        CONSTANT reg            : IN INTEGER;
        CONSTANT m              : IN INTEGER;
        CONSTANT n              : IN INTEGER;
        CONSTANT row_by_row     : IN BOOLEAN;
        
        SIGNAL s_tx             : OUT STD_LOGIC;
        SIGNAL s_rx             : IN STD_LOGIC;
        SIGNAL s_set_dbg        : OUT STD_LOGIC
    ) IS
    BEGIN
        s_set_dbg <= '1';
        WAIT FOR 2*c_clk_per;
        s_set_dbg <= '0';
        WAIT FOR c_clk_per;
        serial_send("0000" & STD_LOGIC_VECTOR(to_mat_reg_ix(reg)), s_tx);
        
        receive_mat_save_to_file(filename, reg, m, n, row_by_row, s_rx);
    END debug_save_mat_reg_to_file;
    
    PROCEDURE receive_mat_save_to_file(
        CONSTANT filename       : IN STRING;
        CONSTANT reg            : IN INTEGER;
        CONSTANT m              : IN INTEGER;
        CONSTANT n              : IN INTEGER;
        CONSTANT row_by_row     : IN BOOLEAN;
        
        SIGNAL s_rx             : IN STD_LOGIC
    ) IS
        FILE mat_file : TEXT;
        VARIABLE tmp_line : LINE;
        VARIABLE elem : t_byte;
        VARIABLE tmp : INTEGER;
    BEGIN        
        file_open(mat_file, filename, write_mode);
        
        REPORT infomsg("Schreibe Matrix Register " & INTEGER'IMAGE(reg) & " in Datei " & filename); 
        WRITE(tmp_line, "Matrix Register " & INTEGER'IMAGE(reg) & " : size = " &  INTEGER'IMAGE(m) & "x" & INTEGER'IMAGE(n) & "; row_by_row = " & BOOLEAN'IMAGE(row_by_row));
        WRITELINE(mat_file, tmp_line);
        IF NOT row_by_row THEN
            WRITE(tmp_line, "row_by_row = " & BOOLEAN'IMAGE(row_by_row) & "; Matrix ist transponiert!");
            WRITELINE(mat_file, tmp_line);
        END IF;

        tmp := 1;
        FOR i IN 1 TO m LOOP
            FOR j IN 1 TO n LOOP
                serial_receive(elem, s_rx);
                WRITE(tmp_line, to_real(to_mat_elem(elem)), right, 8, 4);
                REPORT infomsg("Byte Nr. " & INTEGER'IMAGE(tmp) & " empfangen: " & to_hex(elem));
                tmp := tmp + 1;
            END LOOP;
            WRITELINE(mat_file, tmp_line);          
        END LOOP;
        file_close(mat_file);
    END receive_mat_save_to_file;
    
    PROCEDURE save_mat_reg_to_file(
        CONSTANT filename       : IN STRING;
        CONSTANT reg            : IN INTEGER;
        
        SIGNAL sel_a            : OUT t_mat_reg_ix;      
        SIGNAL read_a           : OUT STD_LOGIC;
        SIGNAL data_a           : IN t_mat_word;
        SIGNAL ix_a             : OUT t_mat_ix;
        SIGNAL size_a           : IN t_mat_size;
        SIGNAL row_by_row_a     : IN STD_LOGIC
    ) IS
        VARIABLE row_by_row : STD_LOGIC;
        VARIABLE size : t_mat_size;
        VARIABLE data : t_mat_elem;
        VARIABLE index_word : INTEGER;
        FILE mat_file : TEXT;
        VARIABLE tmp_line : LINE;
    BEGIN
        read_a <= '1';         
        sel_a <= to_mat_reg_ix(reg);
        WAIT FOR 3*c_clk_per;        
        
        row_by_row := row_by_row_a;
        size := size_a;
        
        file_open(mat_file, filename, write_mode);
        
        REPORT infomsg("Schreibe Matrix Register " & INTEGER'IMAGE(reg) & " in Datei " & filename); 
        WRITE(tmp_line, "Matrix Register " & INTEGER'IMAGE(reg) & " : size = " &  mat_size_to_str(size) & "; row_by_row = " & STD_LOGIC'IMAGE(row_by_row));
        WRITELINE(mat_file, tmp_line);
               
        FOR y IN 0 TO to_integer(size.max_row) LOOP
            FOR x IN 0 TO to_integer(size.max_col) LOOP
                ix_a <= to_mat_ix(y, x);
                IF row_by_row = '1' THEN
                   index_word := x mod 32;
                ELSE
                   index_word := y mod 32;
                END IF; 
                
                WAIT FOR 5*c_clk_per;
                data := data_a(index_word);
                
                WRITE(tmp_line, to_real(data), right, 8, 4);
            END LOOP;
            WRITELINE(mat_file, tmp_line);
        END LOOP; 
        read_a <= '0';  
        file_close(mat_file);
    END save_mat_reg_to_file;
    
    PROCEDURE print_mat_reg(
        CONSTANT reg            : IN INTEGER;
        
        SIGNAL sel_a            : OUT t_mat_reg_ix;      
        SIGNAL read_a           : OUT STD_LOGIC;
        SIGNAL data_a           : IN t_mat_word;
        SIGNAL ix_a             : OUT t_mat_ix;
        SIGNAL size_a           : IN t_mat_size;
        SIGNAL row_by_row_a     : IN STD_LOGIC
    ) IS
        VARIABLE row_by_row : STD_LOGIC;
        VARIABLE size : t_mat_size;
        VARIABLE data : t_mat_elem;
        VARIABLE index_word : INTEGER;
    BEGIN
        read_a <= '1';         
        sel_a <= to_mat_reg_ix(reg);
        WAIT FOR 3*c_clk_per;        
        
        row_by_row := row_by_row_a;
        size := size_a;
        
        REPORT infomsg("Matrix Register " & INTEGER'IMAGE(reg) & " : size = " &  mat_size_to_str(size) & "; row_by_row = " & STD_LOGIC'IMAGE(row_by_row) & "(Ausgelassene Werte sind 0.0)");
        
        FOR y IN 0 TO to_integer(size.max_row) LOOP
            FOR x IN 0 TO to_integer(size.max_col) LOOP
                ix_a <= to_mat_ix(y, x);
                IF row_by_row = '1' THEN
                   index_word := x mod 32;
                ELSE
                   index_word := y mod 32;
                END IF; 
                
                WAIT FOR 5*c_clk_per;
                data := data_a(index_word);
                
                IF data /= to_mat_elem(0.0) THEN
                    REPORT infomsg("Reg" & INTEGER'IMAGE(reg) & "(" & INTEGER'IMAGE(y) & "," & INTEGER'IMAGE(x) & ") = " & REAL'IMAGE(to_real(data)) & " (" & mat_elem_to_str(data) & ")");
                END IF;
            END LOOP;
        END LOOP; 
        read_a <= '0';  
    END print_mat_reg;
    
    PROCEDURE assert_mat_reg_eq(
        CONSTANT reg_x          : IN INTEGER;
        CONSTANT reg_y          : IN INTEGER;
        
        SIGNAL sel_a            : OUT t_mat_reg_ix;      
        SIGNAL read_a           : OUT STD_LOGIC;
        SIGNAL data_a           : IN t_mat_word;
        SIGNAL ix_a             : OUT t_mat_ix;
        SIGNAL size_a           : IN t_mat_size;
        SIGNAL row_by_row_a     : IN STD_LOGIC
    ) IS
        VARIABLE row_by_row_x, row_by_row_y : STD_LOGIC;
        VARIABLE size_x, size_y : t_mat_size;
        VARIABLE word_x, word_y : t_mat_word;
        VARIABLE data_x, data_y : t_mat_elem;
        VARIABLE col, row : INTEGER;
        VARIABLE err_cnt : INTEGER;
    BEGIN
        REPORT infomsg("Vergleiche Matrix-Register " & INTEGER'IMAGE(reg_x) & " (x) und " & INTEGER'IMAGE(reg_y) & " (y)");
        err_cnt := 0;
        read_a <= '1';  
        
        sel_a <= to_mat_reg_ix(reg_x);
        WAIT FOR 3*c_clk_per;        
        row_by_row_x := row_by_row_a;
        size_x := size_a;
        
        sel_a <= to_mat_reg_ix(reg_y);
        WAIT FOR 3*c_clk_per;         
        row_by_row_y := row_by_row_a;
        size_y := size_a; 
        
        ensure(row_by_row_x = row_by_row_y, "Matrix_Orientierung (Spalten/Zeilenweise) unterschiedlich: row_by_row_x = " & STD_LOGIC'IMAGE(row_by_row_x) & ", row_by_row_y = " & STD_LOGIC'IMAGE(row_by_row_y));
        ensure(size_x = size_y, "Matrixdimensionen unterschiedlich: size_x = " & mat_size_to_str(size_x) & "; size_y = " & mat_size_to_str(size_y));
        
        FOR lines_ix IN 0 TO c_max_mat_dim - 1 LOOP
            FOR word IN 0 TO c_max_mat_dim/t_mat_word'LENGTH - 1 LOOP -- Schleife ueber Woerter
                IF row_by_row_x = '1' THEN
                    ix_a <= to_mat_ix(lines_ix, word * 32);
                ELSE
                    ix_a <= to_mat_ix(word * 32, lines_ix);
                END IF;
                
                sel_a <= to_mat_reg_ix(reg_x);
                WAIT FOR 5*c_clk_per;
                word_x := data_a;
                
                sel_a <= to_mat_reg_ix(reg_y);
                WAIT FOR 5*c_clk_per;
                word_y := data_a;
                
                FOR word_index IN 0 TO t_mat_word'LENGTH-1 LOOP
                    IF row_by_row_x = '1' THEN
                        row := lines_ix;
                        col := word * 32 + word_index;
                    ELSE
                        row := word * 32 + word_index;
                        col := lines_ix;
                    END IF;
                    data_x := word_x(word_index);
                    data_y := word_y(word_index);
                    ensure(data_x = data_y, "Die Matrizen unterscheiden sich an Position row=" & INTEGER'IMAGE(row) & ", col=" & INTEGER'IMAGE(col) & ": data_x = " & REAL'IMAGE(to_real(data_x)) 
                                            & " (" & mat_elem_to_str(data_x) & ")" & "; data_y = " & REAL'IMAGE(to_real(data_y)) & " (" & mat_elem_to_str(data_y) & ")" );
                END LOOP;
            END LOOP;
        END LOOP;
       read_a <= '0';   
    END assert_mat_reg_eq;
    
    PROCEDURE assert_mat_eq(
        SIGNAL s_a_data_o       : IN t_mat_word;
        SIGNAL s_a_ix_r         : OUT t_mat_ix;
        SIGNAL s_a_size         : IN t_mat_size;
        SIGNAL s_a_row_by_row   : IN STD_LOGIC;
        
        SIGNAL s_c_data_o       : IN t_mat_word;
        SIGNAL s_c_ix_r         : OUT t_mat_ix;
        SIGNAL s_c_size         : IN t_mat_size;
        SIGNAL s_c_row_by_row   : IN STD_LOGIC
    ) IS 
        VARIABLE v_index_word_a, v_index_word_c: INTEGER;
        VARIABLE val_a, val_c : t_mat_elem;
    BEGIN
        REPORT infomsg("Ueberpruefe Matrix");
        assert s_a_size = s_c_size REPORT err("Matrixdimensionen unterschiedlich");
        FOR y IN 0 TO c_max_mat_dim - 1 LOOP
            FOR x IN 0 TO c_max_mat_dim - 1 LOOP
                s_a_ix_r <= to_mat_ix(y, x);
                s_c_ix_r <= to_mat_ix(y, x);
                
                IF s_a_row_by_row = '1' THEN
                    v_index_word_a := x mod 32;
                ELSE
                   v_index_word_a := y mod 32;
                END IF; 
                
                IF s_c_row_by_row = '1' THEN
                    v_index_word_c := x mod 32;
                ELSE
                   v_index_word_c := y mod 32;
                END IF; 
                
                WAIT FOR 5*c_clk_per;
                
                val_a := s_a_data_o(v_index_word_a); 
                val_c := s_c_data_o(v_index_word_c);  
                
                ASSERT val_a = val_c
                    REPORT err("Die Matrizen unterscheiden sich an Position y= ") & INTEGER'IMAGE(y) & ", x=" & INTEGER'IMAGE(x) 
                    & ": val_a = " & REAL'IMAGE(to_real(val_a)) & " (" & mat_elem_to_str(val_a) & ")" & "; val_c = " & REAL'IMAGE(to_real(val_c)) & " (" & mat_elem_to_str(val_c) & ")";
            END LOOP;
        END LOOP;
    END assert_mat_eq;
    
    PROCEDURE delete_reg(
        CONSTANT reg: INTEGER; 
        
        SIGNAL s_sel    : OUT t_mat_reg_ix;
        SIGNAL s_wren   : OUT STD_LOGIC;
        SIGNAL s_data_i : OUT t_mat_word;
        SIGNAL s_ix_w   : OUT t_mat_ix;
        SIGNAL s_row_by_row : OUT STD_LOGIC
    ) IS 
    BEGIN  
        set_reg(reg, to_mat_elem(0.0), s_sel, s_wren, s_data_i, s_ix_w, s_row_by_row);
    END delete_reg;
    
    PROCEDURE set_reg(
        CONSTANT reg: INTEGER; 
        CONSTANT c_val  : IN t_mat_elem;
        
        SIGNAL s_sel        : OUT t_mat_reg_ix;
        SIGNAL s_wren       : OUT STD_LOGIC;
        SIGNAL s_data_i     : OUT t_mat_word;
        SIGNAL s_ix_w       : OUT t_mat_ix;
        SIGNAL s_row_by_row : OUT STD_LOGIC
    ) IS 
    BEGIN  
        s_wren <= '1';         
        s_sel <= to_mat_reg_ix(reg);
        s_row_by_row <= '1';
        s_data_i <= (OTHERS => c_val);
        WAIT FOR c_clk_per;        
       
        FOR lines_ix IN 0 TO c_max_mat_dim - 1 LOOP        
            FOR word IN 0 TO c_max_mat_dim/t_mat_word'LENGTH - 1 LOOP -- Schleife ueber Woerter
                s_ix_w <= to_mat_ix(lines_ix, word * 32);         
                WAIT FOR c_clk_per;
            END LOOP;
        END LOOP;
        
        WAIT FOR c_clk_per;
        s_wren <= '0';
    END set_reg;
   
END PACKAGE BODY;