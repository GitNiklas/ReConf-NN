LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.pkg_tools.ALL;
USE work.fixed_pkg.ALL;
USE std.textio.ALL;
    
PACKAGE pkg_test IS  
    PROCEDURE delete_reg(
        CONSTANT reg: INTEGER;
        
        SIGNAL s_sel_c: OUT t_mat_reg_ixs;
        SIGNAL s_opcode: OUT t_opcodes;
        SIGNAL s_wren: OUT STD_LOGIC;
        SIGNAL s_syn_rst: OUT STD_LOGIC; 
        SIGNAL s_finished: IN t_op_std_logics
    );
    
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
    
    PROCEDURE print_mat_reg(
        CONSTANT reg            : IN INTEGER;
        
        SIGNAL sel_a            : OUT t_mat_reg_ix;      
        SIGNAL read_a           : OUT STD_LOGIC;
        SIGNAL data_a           : IN t_mat_word;
        SIGNAL ix_a             : OUT t_mat_ix;
        SIGNAL size_a           : IN t_mat_size;
        SIGNAL row_by_row_a     : IN STD_LOGIC
    );
    
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
    
    PROCEDURE assert_mat_eq(
        SIGNAL s_a_data_o       : IN t_mat_word;
        SIGNAL s_a_ix_r         : OUT t_mat_ix;
        SIGNAL s_a_size         : IN t_mat_size;
        SIGNAL s_a_row_by_row   : IN STD_LOGIC;
        
        SIGNAL s_c_data_o       : IN t_mat_word;
        SIGNAL s_c_ix_r         : OUT t_mat_ix;
        SIGNAL s_c_size         : IN t_mat_size;
        SIGNAL s_c_row_by_row   : IN STD_LOGIC
    );
    
    PROCEDURE set_mat(
        CONSTANT c_val  : IN t_mat_elem;
        SIGNAL s_wren   : OUT STD_LOGIC;
        SIGNAL s_data_i : OUT t_mat_word;
        SIGNAL s_ix_w   : OUT t_mat_ix
    );
    
END;

PACKAGE BODY pkg_test IS
    
    PROCEDURE ensure(
        x: BOOLEAN;
        msg: STRING
    ) IS
    BEGIN
        IF NOT x THEN
            ASSERT FALSE REPORT err(msg);
            WAIT;
        END IF;
    END ensure;
    
    PROCEDURE delete_reg(
        CONSTANT reg: INTEGER; 
        
        SIGNAL s_sel_c: OUT t_mat_reg_ixs;
        SIGNAL s_opcode: OUT t_opcodes;
        SIGNAL s_wren: OUT STD_LOGIC;
        SIGNAL s_syn_rst: OUT STD_LOGIC; 
        SIGNAL s_finished: IN t_op_std_logics
    ) IS
    BEGIN
        --REPORT infomsg("Loesche Register " & INTEGER'IMAGE(reg));
        s_sel_c(2) <= to_mat_reg_ix(reg); 
        s_opcode(2) <= MatDel;
    
        s_wren  <= '1';
        s_syn_rst <= '1';
        WAIT FOR c_clk_per;
        s_syn_rst <= '0';
        
        WAIT UNTIL s_finished(2) = '1';
        WAIT FOR c_clk_per / 2;
        s_wren  <= '0';
        s_opcode(2) <= NoOp;
    END delete_reg;
    
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
        WAIT FOR c_clk_per;        
        
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
                
                WAIT FOR 2*c_clk_per;
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
        WAIT FOR c_clk_per;        
        
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
                
                WAIT FOR 2*c_clk_per;
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
        WAIT FOR c_clk_per;        
        row_by_row_x := row_by_row_a;
        size_x := size_a;
        
        sel_a <= to_mat_reg_ix(reg_y);
        WAIT FOR c_clk_per;         
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
                WAIT FOR 2*c_clk_per;
                word_x := data_a;
                
                sel_a <= to_mat_reg_ix(reg_y);
                WAIT FOR 2*c_clk_per;
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
                
                WAIT FOR 2*c_clk_per;
                
                val_a := s_a_data_o(v_index_word_a); 
                val_c := s_c_data_o(v_index_word_c);  
                
                ASSERT val_a = val_c
                    REPORT err("Die Matrizen unterscheiden sich an Position y= ") & INTEGER'IMAGE(y) & ", x=" & INTEGER'IMAGE(x) 
                    & ": val_a = " & REAL'IMAGE(to_real(val_a)) & " (" & mat_elem_to_str(val_a) & ")" & "; val_c = " & REAL'IMAGE(to_real(val_c)) & " (" & mat_elem_to_str(val_c) & ")";
            END LOOP;
        END LOOP;
    END assert_mat_eq;

    PROCEDURE set_mat(
        CONSTANT c_val  : in t_mat_elem;
        SIGNAL s_wren   : OUT STD_LOGIC;
        SIGNAL s_data_i : OUT t_mat_word;
        SIGNAL s_ix_w   : OUT t_mat_ix
    ) IS BEGIN  
        s_wren <= '1';
        s_data_i <= (others => c_val  );
        FOR y IN 0 TO c_max_mat_dim - 1 LOOP
            FOR x IN 0 TO c_max_mat_dim - 1 LOOP
                s_ix_w <= to_mat_ix(y, x);
                WAIT FOR c_clk_per;
            END LOOP;
        END LOOP;
        s_wren <= '0';
    END set_mat;

END PACKAGE BODY;