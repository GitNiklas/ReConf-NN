LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.pkg_tools.ALL;
USE work.pkg_test.ALL;
USE work.fixed_pkg.ALL;
    
PACKAGE pkg_test_matrices IS  

PROCEDURE init_mat_2x3_rbr(                     reg : INTEGER; SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word; SIGNAL s_sel_a0 : OUT t_mat_reg_ix);
PROCEDURE init_mat_3x3_cbc(                     reg : INTEGER; SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word; SIGNAL s_sel_a0 : OUT t_mat_reg_ix);
PROCEDURE init_mat_result_2x3_mul_3x3_rbr(      reg : INTEGER; SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word; SIGNAL s_sel_a0 : OUT t_mat_reg_ix);
PROCEDURE init_mat_2x36_rbr(                    reg : INTEGER; SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word; SIGNAL s_sel_a0 : OUT t_mat_reg_ix);
PROCEDURE init_mat_36x3_cbc(                    reg : INTEGER; SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word; SIGNAL s_sel_a0 : OUT t_mat_reg_ix);
PROCEDURE init_mat_result_2x36_mul_36x3_rbr(    reg : INTEGER; SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word; SIGNAL s_sel_a0 : OUT t_mat_reg_ix);
PROCEDURE init_mat_36x1_rbr(                    reg : INTEGER; SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word; SIGNAL s_sel_a0 : OUT t_mat_reg_ix);
PROCEDURE init_mat_1x2_cbc(                     reg : INTEGER; SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word; SIGNAL s_sel_a0 : OUT t_mat_reg_ix);
PROCEDURE init_mat_result_36x1_mul_1x2_cbc(     reg : INTEGER; SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word; SIGNAL s_sel_a0 : OUT t_mat_reg_ix);
PROCEDURE init_mat_a0_64x64_rbr(                reg : INTEGER; SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word; SIGNAL s_sel_a0 : OUT t_mat_reg_ix);
PROCEDURE init_mat_a1_64x64_cbc(                reg : INTEGER; SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word; SIGNAL s_sel_a0 : OUT t_mat_reg_ix);
PROCEDURE init_mat_result_a0_add_a0(            reg : INTEGER; SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word; SIGNAL s_sel_a0 : OUT t_mat_reg_ix);
PROCEDURE init_mat_result_a1_add_a1(            reg : INTEGER; SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word; SIGNAL s_sel_a0 : OUT t_mat_reg_ix);
PROCEDURE init_mat_result_a0_trans(             reg : INTEGER; SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word; SIGNAL s_sel_a0 : OUT t_mat_reg_ix);
PROCEDURE init_mat_result_a1_trans(             reg : INTEGER; SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word; SIGNAL s_sel_a0 : OUT t_mat_reg_ix);
PROCEDURE init_mat_result_a0_scalar_max(        reg : INTEGER; SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word; SIGNAL s_sel_a0 : OUT t_mat_reg_ix);
PROCEDURE init_mat_a2_64x64_rbr(                reg : INTEGER; SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word; SIGNAL s_sel_a0 : OUT t_mat_reg_ix);
PROCEDURE init_mat_result_a2_scalar_div(        reg : INTEGER; SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word; SIGNAL s_sel_a0 : OUT t_mat_reg_ix);
PROCEDURE init_mat_a3_1x64_rbr(                 reg : INTEGER; SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word; SIGNAL s_sel_a0 : OUT t_mat_reg_ix);
PROCEDURE init_mat_result_a0_vec_add_a3(        reg : INTEGER; SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word; SIGNAL s_sel_a0 : OUT t_mat_reg_ix);
PROCEDURE init_mat_result_a1_col_sum_rbr(       reg : INTEGER; SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word; SIGNAL s_sel_a0 : OUT t_mat_reg_ix);
PROCEDURE init_mat_result_a1_col_sum_cbc(       reg : INTEGER; SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word; SIGNAL s_sel_a0 : OUT t_mat_reg_ix);
PROCEDURE init_mat_result_a0_flip(              reg : INTEGER; SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word; SIGNAL s_sel_a0 : OUT t_mat_reg_ix);
PROCEDURE init_mat_result_a0_scalar_sub_ix(     reg : INTEGER; SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word; SIGNAL s_sel_a0 : OUT t_mat_reg_ix);

PROCEDURE init_ix_array_scalar_sub_ix(SIGNAL s_ram_data : OUT STD_LOGIC_VECTOR (7 DOWNTO 0); SIGNAL s_ram_wraddress : OUT STD_LOGIC_VECTOR (5 DOWNTO 0); SIGNAL s_ram_wren : OUT STD_LOGIC);

PROCEDURE init_mat_b1_rbr(      reg : INTEGER; SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word; SIGNAL s_sel_a0 : OUT t_mat_reg_ix);
PROCEDURE init_mat_b2_rbr(      reg : INTEGER; SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word; SIGNAL s_sel_a0 : OUT t_mat_reg_ix);
PROCEDURE init_mat_w1_cbc(      reg : INTEGER; SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word; SIGNAL s_sel_a0 : OUT t_mat_reg_ix);
PROCEDURE init_mat_w2_cbc(      reg : INTEGER; SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word; SIGNAL s_sel_a0 : OUT t_mat_reg_ix);
PROCEDURE init_y_train(         SIGNAL s_ram_data : OUT STD_LOGIC_VECTOR (7 DOWNTO 0); SIGNAL s_ram_wraddress : OUT STD_LOGIC_VECTOR (5 DOWNTO 0); SIGNAL s_ram_wren : OUT STD_LOGIC);
PROCEDURE init_mat_x_train_rbr( reg : INTEGER; SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word; SIGNAL s_sel_a0 : OUT t_mat_reg_ix);

END;


PACKAGE BODY pkg_test_matrices IS

TYPE t_mat_word_const_arr IS ARRAY(NATURAL RANGE <>) OF t_mat_word_const;
TYPE t_ix_arr_const IS ARRAY(NATURAL RANGE <>) OF NATURAL;

CONSTANT c_rv_0 : REAL := 1.0;
CONSTANT c_rv_1 : REAL := 0.5;
CONSTANT c_rv_2 : REAL := -0.5;
CONSTANT c_rv_3 : REAL := -1.0;

PROCEDURE init_reg(
    data : t_mat_word_const_arr;
    row_by_row : STD_LOGIC;
    mat_size : t_mat_size;
    reg : INTEGER; 
    mat_add_descr : STRING;
 
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word; SIGNAL s_sel_a0 : OUT t_mat_reg_ix
) IS
VARIABLE row_by_row_text : STRING(1 TO 14);
BEGIN
    delete_reg(reg, s_sel_a0, s_write_a0, s_data_a0_i, s_ix_a0, s_row_by_row_a0_i);
    IF row_by_row = '1' THEN row_by_row_text := "[Zeilenweise] "; ELSE row_by_row_text := "[Spaltenweise]"; END IF;
    REPORT infomsg("Register " & INTEGER'IMAGE(reg) & " = " & mat_size_to_str(mat_size) & " Matrix " & row_by_row_text & " " & mat_add_descr);
    s_sel_a0 <= to_mat_reg_ix(reg); 
    s_write_a0 <= '1';
    s_size_a0_i <= mat_size;
    s_row_by_row_a0_i <= row_by_row;
    
    FOR i IN data'RANGE LOOP
        IF row_by_row = '1' THEN
            IF mat_size.max_col < t_mat_word'LENGTH THEN
                s_ix_a0 <= to_mat_ix(i, 0); -- Es koennen die Spalten 0-31 gleichzeitig geschrieben werden
            ELSE
                s_ix_a0 <= to_mat_ix(i / 2, (i mod 2) * t_mat_word'LENGTH); 
            END IF;
        ELSE
            IF mat_size.max_row < t_mat_word'LENGTH THEN
                s_ix_a0 <= to_mat_ix(0, i); -- Es koennen die Zeilen 0-31 gleichzeitig geschrieben werden
            ELSE
                s_ix_a0 <= to_mat_ix((i mod 2) * t_mat_word'LENGTH, i / 2); 
            END IF;
        END IF;
        
        s_data_a0_i <= to_mat_word(data(i));
        WAIT FOR c_clk_per;
    END LOOP;
    
    s_write_a0 <= '0';
    WAIT FOR c_clk_per;
    --REPORT infomsg("Register " & INTEGER'IMAGE(reg) & " fertig initialisiert");
END init_reg;

PROCEDURE init_ix_arr(
    data : t_ix_arr_const;
    SIGNAL s_ram_data : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    SIGNAL s_ram_wraddress : OUT STD_LOGIC_VECTOR (5 DOWNTO 0);
    SIGNAL s_ram_wren : OUT STD_LOGIC
) IS
BEGIN
    REPORT infomsg("Initialisere Index-Array fuer ScalarSubIx");
    s_ram_wren <= '1';   
    FOR i IN data'RANGE LOOP
        s_ram_data <= "00" & STD_LOGIC_VECTOR(to_mat_ix_el(data(i)));
        s_ram_wraddress <= STD_LOGIC_VECTOR(TO_UNSIGNED(i, s_ram_wraddress'LENGTH));
        WAIT FOR c_clk_per;
    END LOOP;
    s_ram_wren <= '0';
END init_ix_arr;

PROCEDURE init_mat_2x3_rbr(
    reg : INTEGER; 
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word; SIGNAL s_sel_a0 : OUT t_mat_reg_ix
) IS
VARIABLE data: t_mat_word_const_arr(0 TO 1);
BEGIN
    -- {{0.125, 0.25, 0.625}, {-0.25, -0.3125, -0.875}}
    --
    -- 0.125    0.25        0.625       | 0000.0010     0000.0100       0000.1010
    -- -0.25   -0.3125     -0.875       | 1111.1100     1111.1011       1111.0010
    data := (
        (0.125, 0.25, 0.625,                0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0),
        (-0.25, -0.3125, -0.875,            0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
    );
    
    init_reg(data, '1', to_mat_size(2, 3), reg, "", s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a0);
END init_mat_2x3_rbr;

PROCEDURE init_mat_3x3_cbc(
    reg : INTEGER; 
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word; SIGNAL s_sel_a0 : OUT t_mat_reg_ix
) IS
VARIABLE data: t_mat_word_const_arr(0 TO 2);
BEGIN
    -- {{1, 1, 2.5}, {2, 3, -4}, {1, -2, -3}}
    --
    -- 1   1  2.5       | 0001.0000     0001.0000       0010.1000
    -- 2   3   -4       | 0010.0000     0011.0000       1100.0000
    -- 1  -2   -3       | 0001.0000     1110.0000       1101.0000
    data := (
        (1.0, 2.0, 1.0,                 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0),
        (1.0, 3.0, -2.0,                0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0),
        (2.5, -4.0, -3.0,               0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
    );
    
    init_reg(data, '0', to_mat_size(3, 3), reg, "", s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a0);
END init_mat_3x3_cbc;

PROCEDURE init_mat_result_2x3_mul_3x3_rbr(
    reg : INTEGER; 
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word; SIGNAL s_sel_a0 : OUT t_mat_reg_ix
) IS
VARIABLE data: t_mat_word_const_arr(0 TO 1);
BEGIN
    data := (
        (1.25, -0.375, -2.5625,         0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0),
        (-1.75, 0.5625, 3.25,           0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
    );
    
    init_reg(data, '1', to_mat_size(2, 3), reg, "Ergebnis 2x3 * 3x3", s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a0);
END init_mat_result_2x3_mul_3x3_rbr;

PROCEDURE init_mat_2x36_rbr(
    reg : INTEGER; 
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word; SIGNAL s_sel_a0 : OUT t_mat_reg_ix
) IS
VARIABLE data: t_mat_word_const_arr(0 TO 3);
BEGIN
    -- [0.25, 0.25, 1.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 2.0, 0.5, 2.0]
    -- [-0.25, -0.35, -0.875, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.5, 0.5, 0.25]   
    data := (
        (0.25, 0.25, 1.5,                                   0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0),
                                (1.0, 2.0, 0.5, 2.0,        0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0),
        (-0.25, -0.35, -0.875,                              0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0),
                                (1.0, 1.5, 0.5, 0.25,       0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
    );
    
    init_reg(data, '1', to_mat_size(2, 36), reg, "", s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a0);
END init_mat_2x36_rbr;

PROCEDURE init_mat_36x3_cbc(
    reg : INTEGER; 
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word; SIGNAL s_sel_a0 : OUT t_mat_reg_ix
) IS
VARIABLE data: t_mat_word_const_arr(0 TO 5);
BEGIN
    -- [1, 1, 2.0],[2, 3, -4],[1, -2, -3],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.5, 0.5, 0.5],[0.5, 0.5, 2.0],[0.5, 1.0, 0.5],[0.5, 1.5, 1.0]
    data := (
        (1.0, 2.0, 1.0,                                 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0),
                            (0.5, 0.5, 0.5, 0.5,        0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0),
        (1.0, 3.0, -2.0,                                0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0),
                            (0.5, 0.5, 1.0, 1.5,        0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0),
        (2.0, -4.0, -3.0,                               0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0),
                            (0.5, 2.0, 0.5, 1.0,        0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
    );
    
    init_reg(data, '0', to_mat_size(36, 3), reg, "", s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a0);
END init_mat_36x3_cbc;

PROCEDURE init_mat_result_2x36_mul_36x3_rbr(
    reg : INTEGER; 
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word; SIGNAL s_sel_a0 : OUT t_mat_reg_ix
) IS
VARIABLE data: t_mat_word_const_arr(0 TO 1);
BEGIN
    -- 5.0      3.0     1.75
    -- -0.2     2.575   7.525 -- erzeugt rundungsfehler!
    data := (
        (5.0, 3.0, 1.75,            0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0),
        (-0.25, 2.5, 7.625,         0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
    );
    
    init_reg(data, '1', to_mat_size(2, 3), reg, "Ergebnis 2x36 * 36x3", s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a0);
END init_mat_result_2x36_mul_36x3_rbr;

PROCEDURE init_mat_36x1_rbr(
    reg : INTEGER; 
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word; SIGNAL s_sel_a0 : OUT t_mat_reg_ix
) IS
VARIABLE data: t_mat_word_const_arr(0 TO 35);
BEGIN
    -- [0.25], [0.125], [0.0], [1.0], [0.125], [0.5], [1.0], [2.0], [0.0625], [0.5], [0.125], [1.0], [0.625], [0.875], [2.0], [0.5], [0.5625], [0.3125], [0.25], [0.125], [0.0], [1.0], [0.125], [0.5], [1.0], [2.0], [0.0625], [0.5], [0.125], [1.0], [0.625], [0.875], [2.0], [0.5], [0.5625], [0.3125]  
    data := (
        (0.25,                  0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0),
        (0.125,                 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0),
        (0.0,                   0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0),
        (1.0,                   0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0),
        (0.125,                 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0),
        (0.5,                   0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0),
        (1.0,                   0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0),
        (2.0,                   0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0),
        (0.0625,                0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0),
        (0.5,                   0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0),
        (0.125,                 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0),
        (1.0,                   0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0),
        (0.625,                 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0),
        (0.875,                 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0),
        (2.0,                   0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0),
        (0.5,                   0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0),
        (0.5625,                0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0),
        (0.3125,                0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0),
        (0.25,                  0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0),
        (0.125,                 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0),
        (0.0,                   0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0),
        (1.0,                   0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0),
        (0.125,                 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0),
        (0.5,                   0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0),
        (1.0,                   0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0),
        (2.0,                   0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0),
        (0.0625,                0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0),
        (0.5,                   0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0),
        (0.125,                 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0),
        (1.0,                   0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0),
        (0.625,                 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0),
        (0.875,                 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0),
        (2.0,                   0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0),
        (0.5,                   0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0),
        (0.5625,                0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0),
        (0.3125,                0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
    );
    
    init_reg(data, '1', to_mat_size(36, 1), reg, "", s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a0);
END init_mat_36x1_rbr;

PROCEDURE init_mat_1x2_cbc(
    reg : INTEGER; 
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word; SIGNAL s_sel_a0 : OUT t_mat_reg_ix
) IS
VARIABLE data: t_mat_word_const_arr(0 TO 1);
BEGIN
    -- [2, 1]
    data := (
        (2.0,               0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0),
        (1.0,               0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
    );
    
    init_reg(data, '0', to_mat_size(1, 2), reg, "", s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a0);
END init_mat_1x2_cbc;

PROCEDURE init_mat_result_36x1_mul_1x2_cbc(
    reg : INTEGER; 
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word; SIGNAL s_sel_a0 : OUT t_mat_reg_ix
) IS
VARIABLE data: t_mat_word_const_arr(0 TO 3);
BEGIN
    -- [2, 1]
    data := (
        (0.5, 0.25, 0.0, 2.0, 0.25, 1.0, 2.0, 4.0, 0.125, 1.0, 0.25, 2.0, 1.25, 1.75, 4.0, 1.0,  1.125, 0.625, 0.5, 0.25, 0.0, 2.0, 0.25, 1.0, 2.0, 4.0, 0.125, 1.0, 0.25, 2.0, 1.25, 1.75),
                    (4.0, 1.0, 1.125, 0.625, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0),
        (0.25, 0.125, 0.0, 1.0, 0.125, 0.5, 1.0, 2.0, 0.0625, 0.5, 0.125, 1.0, 0.625, 0.875, 2.0, 0.5,  0.5625, 0.3125, 0.25, 0.125, 0.0, 1.0, 0.125, 0.5, 1.0, 2.0, 0.0625, 0.5, 0.125, 1.0, 0.625, 0.875),
                    (2.0, 0.5, 0.5625, 0.3125, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
    );
    
    init_reg(data, '0', to_mat_size(36, 2), reg, "Ergebnis 36x1 * 1x2", s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a0);
END init_mat_result_36x1_mul_1x2_cbc;

FUNCTION data_a0_a1 RETURN t_mat_word_const_arr IS
VARIABLE data : t_mat_word_const_arr(0 To 127);
BEGIN
    -- [1.0, -0.25, ..., 2.25, -0.75]
    -- [0.25, -0.5, ..., 1.5, -0.125]
    -- ...
    -- [1.125, 0.625, ..., 1.75, 0.5]
    -- [2.0, 1.0, ..., 2.25, -0.75]
    FOR i IN data'RANGE LOOP
        data(i) := (OTHERS => 0.0);
    END LOOP;
    data(0) := (1.0, -0.25,         0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
    data(1) :=                      (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,          2.25, -0.75);
    data(2) := (0.25, -0.5,         0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
    data(3) :=                      (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,          1.5, -0.125);
    
    data(124) := (1.125, 0.625,     0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
    data(125) :=                    (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,          1.75, 0.5);
    data(126) := (2.0, 1.0,         0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
    data(127) :=                    (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,          2.25, -0.75);
    RETURN data;
END;

PROCEDURE init_mat_a0_64x64_rbr(
    reg : INTEGER; 
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word; SIGNAL s_sel_a0 : OUT t_mat_reg_ix
) IS
BEGIN   
    init_reg(data_a0_a1, '1', to_mat_size(64, 64), reg, "a0", s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a0);
END init_mat_a0_64x64_rbr;

PROCEDURE init_mat_a1_64x64_cbc(
    reg : INTEGER; 
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word; SIGNAL s_sel_a0 : OUT t_mat_reg_ix
) IS
BEGIN
    init_reg(data_a0_a1, '0', to_mat_size(64, 64), reg, "a1", s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a0);
END init_mat_a1_64x64_cbc;

FUNCTION data_a0_a1_mul_2 RETURN t_mat_word_const_arr IS
VARIABLE data : t_mat_word_const_arr(0 To 127);
BEGIN
    FOR i IN data'RANGE LOOP
        data(i) := (OTHERS => 0.0);
    END LOOP;
    data(0) := (2.0, -0.5,          0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
    data(1) :=                      (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,          4.5, -1.5);
    data(2) := (0.5, -1.0,         0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
    data(3) :=                      (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,          3.0, -0.25);
    
    data(124) := (2.25, 1.25,     0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
    data(125) :=                    (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,          3.5, 1.0);
    data(126) := (4.0, 2.0,         0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
    data(127) :=                    (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,          4.5, -1.5);
    RETURN data;
END;

PROCEDURE init_mat_result_a0_add_a0(
    reg : INTEGER; 
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word; SIGNAL s_sel_a0 : OUT t_mat_reg_ix
) IS
BEGIN
    init_reg(data_a0_a1_mul_2, '1', to_mat_size(64, 64), reg, "2 * a0", s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a0);
END init_mat_result_a0_add_a0;

PROCEDURE init_mat_result_a1_add_a1(
    reg : INTEGER; 
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word; SIGNAL s_sel_a0 : OUT t_mat_reg_ix
) IS
BEGIN
    init_reg(data_a0_a1_mul_2, '0', to_mat_size(64, 64), reg, "2 * a1", s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a0);
END init_mat_result_a1_add_a1;

FUNCTION data_a0_a1_trans RETURN t_mat_word_const_arr IS
VARIABLE data : t_mat_word_const_arr(0 To 127);
BEGIN
    -- [1.0, 0.25, ..., 1.125, 2.0]
    -- [-0.25, -0.5, ..., 0.625, 1.0]
    -- ...
    -- [2.25, 1.5, ..., 1.75, 2.25]
    -- [-0.75, -0.125, ..., 0.5, -0.75] 
    FOR i IN data'RANGE LOOP
        data(i) := (OTHERS => 0.0);
    END LOOP;
    data(0) := (1.0, 0.25,          0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
    data(1) :=                      (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,          1.125, 2.0);
    data(2) := (-0.25, -0.5,        0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
    data(3) :=                      (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,          0.625, 1.0);
    
    data(124) := (2.25, 1.5,        0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
    data(125) :=                    (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,          1.75, 2.25);
    data(126) := (-0.75, -0.125,         0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
    data(127) :=                    (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,          0.5, -0.75);
    RETURN data;
END;

PROCEDURE init_mat_result_a0_trans(
    reg : INTEGER; 
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word; SIGNAL s_sel_a0 : OUT t_mat_reg_ix
) IS
BEGIN 
    init_reg(data_a0_a1_trans, '1', to_mat_size(64, 64), reg, "trans(a0)", s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a0);
END init_mat_result_a0_trans;

PROCEDURE init_mat_result_a1_trans(
    reg : INTEGER; 
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word; SIGNAL s_sel_a0 : OUT t_mat_reg_ix
) IS
BEGIN
    init_reg(data_a0_a1_trans, '0', to_mat_size(64, 64), reg, "trans(a1)", s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a0);    
END init_mat_result_a1_trans;


PROCEDURE init_mat_result_a0_scalar_max(
    reg : INTEGER; 
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word; SIGNAL s_sel_a0 : OUT t_mat_reg_ix
) IS
VARIABLE data : t_mat_word_const_arr(0 To 127);
BEGIN
    FOR i IN data'RANGE LOOP
        data(i) := (OTHERS => 0.0);
    END LOOP;
    data(0) := (1.0, 0.0,           0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
    data(1) :=                      (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,          2.25, 0.0);
    data(2) := (0.25, 0.0,          0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
    data(3) :=                      (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,          1.5, 0.0);
    
    data(124) := (1.125, 0.625,     0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
    data(125) :=                    (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,          1.75, 0.5);
    data(126) := (2.0, 1.0,         0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
    data(127) :=                    (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,          2.25, 0.0);
    init_reg(data, '1', to_mat_size(64, 64), reg, "max(a0, 0)", s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a0);
END init_mat_result_a0_scalar_max;
    
PROCEDURE init_mat_a2_64x64_rbr(
    reg : INTEGER; 
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word; SIGNAL s_sel_a0 : OUT t_mat_reg_ix
) IS
VARIABLE data : t_mat_word_const_arr(0 To 127);
BEGIN
    FOR i IN data'RANGE LOOP
        data(i) := (OTHERS => 0.0);
    END LOOP;
    data(0) := (1.0, -4.0,           0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
    data(1) :=                      (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,          2.25, -3.9375);
    data(2) := (0.25, -8.0,          0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
    data(3) :=                      (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,          3.9375, -1.0);
    
    data(124) := (1.125, -0.625,    0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
    data(125) :=                    (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,          1.75, 7.9375);
    data(126) := (2.0, 6.0,         0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
    data(127) :=                    (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,          -8.0, 0.0);
    init_reg(data, '1', to_mat_size(64, 64), reg, "a2", s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a0);
END init_mat_a2_64x64_rbr;

PROCEDURE init_mat_result_a2_scalar_div(
    reg : INTEGER; 
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word; SIGNAL s_sel_a0 : OUT t_mat_reg_ix
) IS
VARIABLE data : t_mat_word_const_arr(0 To 127);
BEGIN
    FOR i IN data'RANGE LOOP
        data(i) := (OTHERS => 0.0625);
    END LOOP;
    data(0) := (0.0625, -0.0625,     0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625);
    data(1) :=                      (0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625,          0.0625, -0.0625);
    data(2) := (0.0625, -0.125,      0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625);
    data(3) :=                      (0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625,          0.0625, -0.0625);
    
    data(124) := (0.0625, -0.0625,     0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625);
    data(125) :=                      (0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625,          0.0625, 0.125);
    data(126) := (0.0625, 0.125,      0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625);
    data(127) :=                      (0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625,          -0.125, 0.0625);
    init_reg(data, '1', to_mat_size(64, 64), reg, "a2 / 64", s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a0);
END init_mat_result_a2_scalar_div;
    
PROCEDURE init_mat_a3_1x64_rbr(
    reg : INTEGER; 
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word; SIGNAL s_sel_a0 : OUT t_mat_reg_ix
) IS
VARIABLE data: t_mat_word_const_arr(0 TO 1);
BEGIN
    data := (
        (2.0, 0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0),
                    (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0625, -1.25)
    );
    init_reg(data, '1', to_mat_size(1, 64), reg, "Vector", s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a0);
END init_mat_a3_1x64_rbr;

PROCEDURE init_mat_result_a0_vec_add_a3(
    reg : INTEGER; 
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word; SIGNAL s_sel_a0 : OUT t_mat_reg_ix
) IS
VARIABLE data : t_mat_word_const_arr(0 TO 127);
BEGIN
    FOR i IN data'RANGE LOOP
        IF i mod 2 = 0 THEN
            data(i) := (2.0, 0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
        ELSE
            data(i) := (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0625, -1.25);
        END IF;
    END LOOP;
    data(0) := (3.0, 0.25,         0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
    data(1) :=                      (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,          2.3125, -2.0);
    data(2) := (2.25, 0.0,         0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
    data(3) :=                      (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,          1.5625, -1.375);
    
    data(124) := (3.125, 1.125,     0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
    data(125) :=                    (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,          1.8125, -0.75);
    data(126) := (4.0, 1.5,         0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
    data(127) :=                    (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,          2.3125, -2.0);
    init_reg(data, '1', to_mat_size(64, 64), reg, "VecAdd(a0, a2)", s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a0);
END init_mat_result_a0_vec_add_a3;

PROCEDURE init_mat_result_a1_col_sum_rbr(
    reg : INTEGER; 
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word; SIGNAL s_sel_a0 : OUT t_mat_reg_ix
) IS
VARIABLE data : t_mat_word_const_arr(0 TO 1);
BEGIN
    data := (
        (2.25, 1.125, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0),
                    (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 4.0, 4.5)
    );
    init_reg(data, '1', to_mat_size(1, 64), reg, "ColSum(a0) Row-by-Row", s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a0);
END init_mat_result_a1_col_sum_rbr;

PROCEDURE init_mat_result_a1_col_sum_cbc(
    reg : INTEGER; 
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word; SIGNAL s_sel_a0 : OUT t_mat_reg_ix
) IS
VARIABLE data : t_mat_word_const_arr(0 TO 63);
BEGIN
    FOR i IN data'RANGE LOOP
        data(i) := (OTHERS => 0.0);
    END LOOP;
    data(0) := (2.25, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
    data(1) := (1.125, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);

    data(62) := (4.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
    data(63) := (4.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);

    init_reg(data, '0', to_mat_size(1, 64), reg, "ColSum(a0) Col-by-Col", s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a0);
END init_mat_result_a1_col_sum_cbc;

PROCEDURE init_mat_result_a0_flip(
    reg : INTEGER; 
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word; SIGNAL s_sel_a0 : OUT t_mat_reg_ix
) IS
BEGIN 
    init_reg(data_a0_a1_trans, '0', to_mat_size(64, 64), reg, "flip(a0)", s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a0);
END init_mat_result_a0_flip;

PROCEDURE init_mat_result_a0_scalar_sub_ix(
    reg : INTEGER; 
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word; SIGNAL s_sel_a0 : OUT t_mat_reg_ix
) IS
VARIABLE data : t_mat_word_const_arr(0 TO 127);
BEGIN
    FOR i IN data'RANGE LOOP
        IF i mod 2 = 0 THEN
            data(i) := (0.0, 0.0, -1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0); -- dec in col 2
        ELSE
            data(i) := (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
        END IF;
    END LOOP;
    data(0) := (0.0, -0.25,         0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);  -- dec in col 0
    data(1) :=                      (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,          2.25, -0.75);
    data(2) := (0.25, -1.5,         0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0); -- dec in col 1
    data(3) :=                      (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,          1.5, -0.125);
    
    data(124) := (1.125, 0.625,     0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, -1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0); -- dec in col 9
    data(125) :=                    (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,          1.75, 0.5);
    data(126) := (1.0, 1.0,         0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0); -- dec in col 0
    data(127) :=                    (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,          2.25, -0.75);

    init_reg(data, '1', to_mat_size(64, 64), reg, "ScalarSubIx(a0)", s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a0);
END init_mat_result_a0_scalar_sub_ix;

PROCEDURE init_ix_array_scalar_sub_ix(
    SIGNAL s_ram_data : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    SIGNAL s_ram_wraddress : OUT STD_LOGIC_VECTOR (5 DOWNTO 0);
    SIGNAL s_ram_wren : OUT STD_LOGIC
) IS
VARIABLE data : t_ix_arr_const(0 TO 63);
BEGIN
    FOR i IN data'RANGE LOOP
        data(i) := 2;
    END LOOP;
    data(0) := 0;
    data(1) := 1;
    data(62) := 9;
    data(63) := 0;
    
    init_ix_arr(data, s_ram_data, s_ram_wraddress, s_ram_wren);
END init_ix_array_scalar_sub_ix;

PROCEDURE init_mat_b1_rbr(
    reg : INTEGER; 
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word; SIGNAL s_sel_a0 : OUT t_mat_reg_ix
) IS
VARIABLE data : t_mat_word_const_arr(0 TO 1);
BEGIN
    FOR i IN data'RANGE LOOP
        data(i) := (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
    END LOOP;

    init_reg(data, '1', to_mat_size(1, 64), reg, "b1", s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a0);
END init_mat_b1_rbr;
    
PROCEDURE init_mat_b2_rbr(
    reg : INTEGER; 
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word; SIGNAL s_sel_a0 : OUT t_mat_reg_ix
) IS
VARIABLE data : t_mat_word_const_arr(0 TO 0);
BEGIN
    data(0) := (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);

    init_reg(data, '1', to_mat_size(1, 10), reg, "b2", s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a0);

END init_mat_b2_rbr;

PROCEDURE init_mat_w1_cbc(
    reg : INTEGER; 
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word; SIGNAL s_sel_a0 : OUT t_mat_reg_ix
) IS
VARIABLE data : t_mat_word_const_arr(0 TO 127);
VARIABLE i : INTEGER := 0;
BEGIN
    WHILE (i <= data'HIGH) LOOP
        data(i) := (c_rv_0, c_rv_1, c_rv_2, c_rv_3, c_rv_0, c_rv_1, c_rv_2, c_rv_3, c_rv_0, c_rv_1, c_rv_2, c_rv_3, c_rv_0, c_rv_1, c_rv_2, c_rv_3, c_rv_0, c_rv_1, c_rv_2, c_rv_3, c_rv_0, c_rv_1, c_rv_2, c_rv_3, c_rv_0, c_rv_1, c_rv_2, c_rv_3, c_rv_0, c_rv_1, c_rv_2, c_rv_3);
        data(i+1) := (c_rv_1, c_rv_2, c_rv_3, c_rv_0, c_rv_1, c_rv_2, c_rv_3, c_rv_0, c_rv_1, c_rv_2, c_rv_3, c_rv_0, c_rv_1, c_rv_2, c_rv_3, c_rv_0, c_rv_1, c_rv_2, c_rv_3, c_rv_0, c_rv_1, c_rv_2, c_rv_3, c_rv_0, c_rv_1, c_rv_2, c_rv_3, c_rv_0, c_rv_1, c_rv_2, c_rv_3, c_rv_0);
        data(i+2) := (c_rv_2, c_rv_3, c_rv_0, c_rv_1, c_rv_2, c_rv_3, c_rv_0, c_rv_1, c_rv_2, c_rv_3, c_rv_0, c_rv_1, c_rv_2, c_rv_3, c_rv_0, c_rv_1, c_rv_2, c_rv_3, c_rv_0, c_rv_1, c_rv_2, c_rv_3, c_rv_0, c_rv_1, c_rv_2, c_rv_3, c_rv_0, c_rv_1, c_rv_2, c_rv_3, c_rv_0, c_rv_1);
        data(i+3) := (c_rv_3, c_rv_0, c_rv_1, c_rv_2, c_rv_3, c_rv_0, c_rv_1, c_rv_2, c_rv_3, c_rv_0, c_rv_1, c_rv_2, c_rv_3, c_rv_0, c_rv_1, c_rv_2, c_rv_3, c_rv_0, c_rv_1, c_rv_2, c_rv_3, c_rv_0, c_rv_1, c_rv_2, c_rv_3, c_rv_0, c_rv_1, c_rv_2, c_rv_3, c_rv_0, c_rv_1, c_rv_2);
        i := i +4;
    END LOOP;
    
    init_reg(data, '0', to_mat_size(64, 64), reg, "w1", s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a0);
END init_mat_w1_cbc;

PROCEDURE init_mat_w2_cbc(
    reg : INTEGER; 
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word; SIGNAL s_sel_a0 : OUT t_mat_reg_ix
) IS
VARIABLE data : t_mat_word_const_arr(0 TO 63);
VARIABLE i : INTEGER := 0;
BEGIN
    WHILE (i <= data'HIGH) LOOP
        data(i) := (c_rv_0, c_rv_1, c_rv_2, c_rv_3, c_rv_0, c_rv_1, c_rv_2, c_rv_3, c_rv_0, c_rv_1, c_rv_2, c_rv_3, c_rv_0, c_rv_1, c_rv_2, c_rv_3, c_rv_0, c_rv_1, c_rv_2, c_rv_3, c_rv_0, c_rv_1, c_rv_2, c_rv_3, c_rv_0, c_rv_1, c_rv_2, c_rv_3, c_rv_0, c_rv_1, c_rv_2, c_rv_3);
        data(i+1) := (c_rv_1, c_rv_2, c_rv_3, c_rv_0, c_rv_1, c_rv_2, c_rv_3, c_rv_0, c_rv_1, c_rv_2, c_rv_3, c_rv_0, c_rv_1, c_rv_2, c_rv_3, c_rv_0, c_rv_1, c_rv_2, c_rv_3, c_rv_0, c_rv_1, c_rv_2, c_rv_3, c_rv_0, c_rv_1, c_rv_2, c_rv_3, c_rv_0, c_rv_1, c_rv_2, c_rv_3, c_rv_0);
        data(i+2) := (c_rv_2, c_rv_3, c_rv_0, c_rv_1, c_rv_2, c_rv_3, c_rv_0, c_rv_1, c_rv_2, c_rv_3, c_rv_0, c_rv_1, c_rv_2, c_rv_3, c_rv_0, c_rv_1, c_rv_2, c_rv_3, c_rv_0, c_rv_1, c_rv_2, c_rv_3, c_rv_0, c_rv_1, c_rv_2, c_rv_3, c_rv_0, c_rv_1, c_rv_2, c_rv_3, c_rv_0, c_rv_1);
        data(i+3) := (c_rv_3, c_rv_0, c_rv_1, c_rv_2, c_rv_3, c_rv_0, c_rv_1, c_rv_2, c_rv_3, c_rv_0, c_rv_1, c_rv_2, c_rv_3, c_rv_0, c_rv_1, c_rv_2, c_rv_3, c_rv_0, c_rv_1, c_rv_2, c_rv_3, c_rv_0, c_rv_1, c_rv_2, c_rv_3, c_rv_0, c_rv_1, c_rv_2, c_rv_3, c_rv_0, c_rv_1, c_rv_2);
        i := i +4;
    END LOOP;
    
    init_reg(data, '0', to_mat_size(64, 10), reg, "w2", s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a0);
END init_mat_w2_cbc;

PROCEDURE init_y_train(
    SIGNAL s_ram_data : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    SIGNAL s_ram_wraddress : OUT STD_LOGIC_VECTOR (5 DOWNTO 0);
    SIGNAL s_ram_wren : OUT STD_LOGIC
) IS
VARIABLE data : t_ix_arr_const(0 TO 63);
BEGIN
    data := (0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 9, 5, 5, 6, 5, 0, 9, 8, 9, 8, 4, 1, 7, 7, 3, 5, 1, 0, 0, 2, 2, 7, 8, 2, 0, 1, 2, 6, 3, 3, 7, 3, 3);

    init_ix_arr(data, s_ram_data, s_ram_wraddress, s_ram_wren);
END init_y_train;

PROCEDURE init_mat_x_train_rbr(
    reg : INTEGER; 
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word; SIGNAL s_sel_a0 : OUT t_mat_reg_ix
) IS
VARIABLE data : t_mat_word_const_arr(0 TO 127);
BEGIN
    data(0) := (0.0, 0.0, 2.0, 6.0, 4.0, 0.0, 0.0, 0.0, 0.0, 0.0, 6.0, 7.0, 4.0, 7.0, 2.0, 0.0, 0.0, 1.0, 7.0, 1.0, 0.0, 5.0, 4.0, 0.0, 0.0, 2.0, 5.0, 0.0, 0.0, 4.0, 4.0, 0.0);
    data(1) :=          (0.0, 2.0, 4.0, 0.0, 0.0, 4.0, 4.0, 0.0, 0.0, 2.0, 5.0, 0.0, 0.0, 5.0, 3.0, 0.0, 0.0, 1.0, 6.0, 2.0, 4.0, 5.0, 0.0, 0.0, 0.0, 0.0, 3.0, 6.0, 4.0, 0.0, 0.0, 0.0);
    data(2) := (0.0, 0.0, 0.0, 5.0, 6.0, 2.0, 0.0, 0.0, 0.0, 0.0, 0.0, 5.0, 7.0, 4.0, 0.0, 0.0, 0.0, 0.0, 1.0, 7.0, 7.0, 3.0, 0.0, 0.0, 0.0, 3.0, 7.0, 7.0, 7.0, 1.0, 0.0, 0.0);
    data(3) :=          (0.0, 0.0, 0.0, 7.0, 7.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 7.0, 7.0, 3.0, 0.0, 0.0, 0.0, 0.0, 0.0, 7.0, 7.0, 3.0, 0.0, 0.0, 0.0, 0.0, 0.0, 5.0, 7.0, 4.0, 0.0, 0.0);
    data(4) := (0.0, 0.0, 0.0, 2.0, 7.0, 5.0, 0.0, 0.0, 0.0, 0.0, 1.0, 7.0, 7.0, 6.0, 0.0, 0.0, 0.0, 0.0, 4.0, 6.0, 4.0, 7.0, 0.0, 0.0, 0.0, 0.0, 0.0, 3.0, 7.0, 5.0, 0.0, 0.0);
    data(5) :=          (0.0, 0.0, 4.0, 6.0, 7.0, 0.0, 0.0, 0.0, 0.0, 4.0, 7.0, 7.0, 2.0, 0.0, 0.0, 0.0, 0.0, 1.0, 6.0, 7.0, 7.0, 5.0, 2.0, 0.0, 0.0, 0.0, 0.0, 1.0, 5.0, 7.0, 4.0, 0.0);
    data(6) := (0.0, 0.0, 3.0, 7.0, 6.0, 0.0, 0.0, 0.0, 0.0, 4.0, 6.0, 3.0, 7.0, 2.0, 0.0, 0.0, 0.0, 1.0, 0.0, 6.0, 6.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 7.0, 5.0, 0.0, 0.0, 0.0);
    data(7) :=          (0.0, 0.0, 0.0, 0.0, 5.0, 5.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 4.0, 4.0, 0.0, 0.0, 0.0, 4.0, 2.0, 2.0, 6.0, 4.0, 0.0, 0.0, 0.0, 3.0, 6.0, 6.0, 4.0, 0.0, 0.0);
    data(8) := (0.0, 0.0, 0.0, 0.0, 5.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 3.0, 4.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 6.0, 3.0, 1.0, 1.0, 0.0, 0.0, 0.0, 3.0, 7.0, 0.0, 4.0, 4.0, 0.0);
    data(9) :=          (0.0, 2.0, 7.0, 4.0, 0.0, 7.0, 3.0, 0.0, 0.0, 2.0, 7.0, 7.0, 6.0, 7.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 7.0, 4.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 7.0, 2.0, 0.0, 0.0);
    data(10) := (0.0, 0.0, 5.0, 4.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 6.0, 7.0, 7.0, 6.0, 0.0, 0.0, 0.0, 0.0, 6.0, 7.0, 7.0, 4.0, 0.0, 0.0, 0.0, 0.0, 5.0, 7.0, 7.0, 3.0, 0.0, 0.0);
    data(11) :=         (0.0, 0.0, 0.0, 2.0, 3.0, 7.0, 3.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 7.0, 4.0, 0.0, 0.0, 0.0, 2.0, 2.0, 5.0, 7.0, 2.0, 0.0, 0.0, 0.0, 4.0, 7.0, 7.0, 4.0, 0.0, 0.0);
    data(12) := (0.0, 0.0, 0.0, 5.0, 6.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 7.0, 4.0, 0.0, 0.0, 0.0, 0.0, 0.0, 6.0, 7.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 6.0, 6.0, 0.0, 0.0, 0.0, 0.0);
    data(13) :=         (0.0, 0.0, 7.0, 5.0, 3.0, 1.0, 0.0, 0.0, 0.0, 0.0, 6.0, 7.0, 6.0, 7.0, 1.0, 0.0, 0.0, 0.0, 3.0, 7.0, 5.0, 7.0, 4.0, 0.0, 0.0, 0.0, 0.0, 4.0, 7.0, 5.0, 1.0, 0.0);
    data(14) := (0.0, 0.0, 3.0, 4.0, 6.0, 7.0, 7.0, 0.0, 0.0, 0.0, 3.0, 3.0, 2.0, 5.0, 5.0, 0.0, 0.0, 0.0, 0.0, 0.0, 4.0, 6.0, 0.0, 0.0, 0.0, 2.0, 4.0, 4.0, 7.0, 7.0, 3.0, 0.0);
    data(15) :=         (0.0, 1.0, 5.0, 7.0, 7.0, 2.0, 0.0, 0.0, 0.0, 0.0, 0.0, 7.0, 2.0, 0.0, 0.0, 0.0, 0.0, 0.0, 4.0, 7.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 6.0, 2.0, 0.0, 0.0, 0.0, 0.0);
    data(16) := (0.0, 0.0, 4.0, 6.0, 4.0, 0.0, 0.0, 0.0, 0.0, 0.0, 5.0, 6.0, 6.0, 5.0, 0.0, 0.0, 0.0, 0.0, 4.0, 4.0, 0.0, 7.0, 2.0, 0.0, 0.0, 0.0, 1.0, 7.0, 5.0, 6.0, 1.0, 0.0);
    data(17) :=         (0.0, 0.0, 2.0, 7.0, 7.0, 1.0, 0.0, 0.0, 0.0, 1.0, 7.0, 4.0, 4.0, 6.0, 1.0, 0.0, 0.0, 0.0, 7.0, 0.0, 1.0, 7.0, 4.0, 0.0, 0.0, 0.0, 5.0, 7.0, 7.0, 5.0, 0.0, 0.0);
    data(18) := (0.0, 0.0, 5.0, 5.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 7.0, 7.0, 7.0, 6.0, 0.0, 0.0, 0.0, 1.0, 7.0, 5.0, 4.0, 6.0, 0.0, 0.0, 0.0, 0.0, 7.0, 0.0, 5.0, 7.0, 0.0, 0.0);
    data(19) :=         (0.0, 0.0, 6.0, 7.0, 4.0, 7.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 4.0, 5.0, 0.0, 0.0, 0.0, 0.0, 0.0, 4.0, 7.0, 2.0, 0.0, 0.0, 0.0, 4.0, 5.0, 6.0, 1.0, 0.0, 0.0);
    data(20) := (0.0, 0.0, 0.0, 4.0, 7.0, 5.0, 0.0, 0.0, 0.0, 0.0, 5.0, 7.0, 4.0, 6.0, 3.0, 0.0, 0.0, 1.0, 7.0, 4.0, 0.0, 4.0, 4.0, 0.0, 0.0, 0.0, 7.0, 2.0, 0.0, 4.0, 4.0, 0.0);
    data(21) :=         (0.0, 2.0, 7.0, 2.0, 0.0, 4.0, 4.0, 0.0, 0.0, 0.0, 7.0, 2.0, 0.0, 5.0, 1.0, 0.0, 0.0, 0.0, 5.0, 5.0, 4.0, 4.0, 0.0, 0.0, 0.0, 0.0, 0.0, 4.0, 6.0, 1.0, 0.0, 0.0);
    data(22) := (0.0, 0.0, 0.0, 0.0, 6.0, 6.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 7.0, 7.0, 1.0, 0.0, 0.0, 0.0, 0.0, 6.0, 7.0, 5.0, 0.0, 0.0, 0.0, 0.0, 4.0, 7.0, 7.0, 5.0, 0.0, 0.0);
    data(23) :=         (0.0, 1.0, 5.0, 6.0, 7.0, 4.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 7.0, 7.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 7.0, 6.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 6.0, 7.0, 0.0, 0.0);
    data(24) := (0.0, 0.0, 2.0, 5.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 7.0, 6.0, 3.0, 0.0, 0.0, 0.0, 0.0, 0.0, 6.0, 0.0, 5.0, 0.0, 0.0, 0.0, 0.0, 1.0, 4.0, 0.0, 6.0, 0.0, 0.0, 0.0);
    data(25) :=         (0.0, 0.0, 1.0, 0.0, 7.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 3.0, 7.0, 0.0, 0.0, 0.0, 0.0, 0.0, 4.0, 7.0, 7.0, 4.0, 4.0, 1.0, 0.0, 0.0, 1.0, 5.0, 4.0, 6.0, 5.0, 2.0);
    data(26) := (0.0, 1.0, 4.0, 7.0, 6.0, 4.0, 1.0, 0.0, 0.0, 2.0, 6.0, 4.0, 4.0, 7.0, 4.0, 0.0, 0.0, 0.0, 0.0, 3.0, 6.0, 7.0, 1.0, 0.0, 0.0, 0.0, 0.0, 5.0, 6.0, 1.0, 0.0, 0.0);
    data(27) :=         (0.0, 0.0, 0.0, 1.0, 7.0, 5.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 7.0, 2.0, 0.0, 0.0, 0.0, 2.0, 3.0, 6.0, 7.0, 3.0, 0.0, 0.0, 1.0, 5.0, 5.0, 6.0, 5.0, 0.0, 0.0);
    data(28) := (0.0, 0.0, 0.0, 4.0, 7.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 6.0, 6.0, 0.0, 0.0, 0.0, 0.0, 0.0, 4.0, 7.0, 1.0, 7.0, 5.0, 0.0, 0.0, 3.0, 7.0, 3.0, 0.0, 7.0, 4.0, 0.0);
    data(29) :=         (0.0, 4.0, 7.0, 6.0, 6.0, 7.0, 2.0, 0.0, 0.0, 0.0, 4.0, 7.0, 7.0, 6.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 7.0, 4.0, 0.0, 0.0, 0.0, 0.0, 0.0, 4.0, 7.0, 2.0, 0.0, 0.0);
    data(30) := (0.0, 2.0, 5.0, 6.0, 7.0, 7.0, 1.0, 0.0, 0.0, 5.0, 7.0, 7.0, 4.0, 2.0, 0.0, 0.0, 0.0, 4.0, 6.0, 5.0, 0.0, 0.0, 0.0, 0.0, 0.0, 4.0, 7.0, 7.0, 6.0, 0.0, 0.0, 0.0);
    data(31) :=         (0.0, 0.0, 3.0, 3.0, 7.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 7.0, 1.0, 0.0, 0.0, 0.0, 0.0, 2.0, 7.0, 6.0, 0.0, 0.0, 0.0, 0.0, 2.0, 7.0, 7.0, 1.0, 0.0, 0.0, 0.0);
    data(32) := (0.0, 0.0, 0.0, 4.0, 7.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 5.0, 6.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 7.0, 3.0, 0.0, 0.0, 0.0, 0.0, 0.0, 3.0, 7.0, 1.0, 0.0, 0.0, 0.0);
    data(33) :=         (0.0, 0.0, 3.0, 7.0, 7.0, 6.0, 2.0, 0.0, 0.0, 0.0, 7.0, 7.0, 4.0, 4.0, 6.0, 0.0, 0.0, 0.0, 1.0, 6.0, 4.0, 1.0, 7.0, 1.0, 0.0, 0.0, 0.0, 3.0, 7.0, 7.0, 5.0, 0.0);
    data(34) := (0.0, 0.0, 0.0, 4.0, 7.0, 4.0, 0.0, 0.0, 0.0, 1.0, 6.0, 7.0, 6.0, 6.0, 0.0, 0.0, 0.0, 2.0, 4.0, 0.0, 4.0, 5.0, 0.0, 0.0, 0.0, 0.0, 1.0, 2.0, 7.0, 4.0, 1.0, 0.0);
    data(35) :=         (0.0, 0.0, 7.0, 7.0, 7.0, 7.0, 5.0, 0.0, 0.0, 0.0, 4.0, 5.0, 6.0, 4.0, 1.0, 0.0, 0.0, 0.0, 0.0, 4.0, 6.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 5.0, 4.0, 0.0, 0.0, 0.0);
    data(36) := (0.0, 0.0, 4.0, 3.0, 6.0, 4.0, 0.0, 0.0, 0.0, 0.0, 4.0, 4.0, 5.0, 7.0, 1.0, 0.0, 0.0, 0.0, 2.0, 5.0, 4.0, 5.0, 0.0, 0.0, 0.0, 0.0, 0.0, 7.0, 4.0, 0.0, 0.0, 0.0);
    data(37) :=         (0.0, 0.0, 5.0, 6.0, 2.0, 0.0, 0.0, 0.0, 0.0, 0.0, 5.0, 0.0, 5.0, 0.0, 0.0, 0.0, 0.0, 0.0, 4.0, 1.0, 6.0, 0.0, 0.0, 0.0, 0.0, 0.0, 5.0, 6.0, 2.0, 0.0, 0.0, 0.0);
    data(38) := (0.0, 0.0, 3.0, 6.0, 2.0, 0.0, 0.0, 0.0, 0.0, 0.0, 5.0, 7.0, 4.0, 0.0, 0.0, 0.0, 0.0, 0.0, 4.0, 6.0, 7.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 5.0, 5.0, 5.0, 0.0, 0.0);
    data(39) :=         (0.0, 0.0, 0.0, 0.0, 0.0, 5.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 5.0, 0.0, 0.0, 0.0, 0.0, 2.0, 2.0, 3.0, 7.0, 1.0, 0.0, 0.0, 3.0, 7.0, 7.0, 6.0, 5.0, 0.0);
    data(40) := (0.0, 0.0, 1.0, 6.0, 5.0, 3.0, 0.0, 0.0, 0.0, 0.0, 5.0, 7.0, 7.0, 7.0, 1.0, 0.0, 0.0, 2.0, 7.0, 4.0, 0.0, 6.0, 1.0, 0.0, 0.0, 2.0, 7.0, 0.0, 0.0, 7.0, 1.0, 0.0);
    data(41) :=         (0.0, 0.0, 7.0, 0.0, 0.0, 5.0, 4.0, 0.0, 0.0, 0.0, 7.0, 4.0, 0.0, 6.0, 3.0, 0.0, 0.0, 0.0, 4.0, 6.0, 4.0, 6.0, 0.0, 0.0, 0.0, 0.0, 1.0, 5.0, 6.0, 2.0, 0.0, 0.0);
    data(42) := (0.0, 0.0, 0.0, 1.0, 7.0, 7.0, 1.0, 0.0, 0.0, 0.0, 0.0, 2.0, 7.0, 7.0, 1.0, 0.0, 0.0, 0.0, 2.0, 5.0, 7.0, 5.0, 0.0, 0.0, 0.0, 3.0, 7.0, 7.0, 7.0, 5.0, 0.0, 0.0);
    data(43) :=         (0.0, 0.0, 1.0, 4.0, 7.0, 6.0, 0.0, 0.0, 0.0, 0.0, 0.0, 4.0, 7.0, 5.0, 0.0, 0.0, 0.0, 0.0, 0.0, 3.0, 7.0, 7.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 5.0, 7.0, 2.0, 0.0);
    data(44) := (0.0, 0.0, 4.0, 7.0, 2.0, 0.0, 0.0, 0.0, 0.0, 0.0, 6.0, 5.0, 7.0, 0.0, 0.0, 0.0, 0.0, 0.0, 4.0, 0.0, 6.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 7.0, 0.0, 0.0, 0.0);
    data(45) :=         (0.0, 0.0, 0.0, 4.0, 5.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 7.0, 2.0, 0.0, 0.0, 0.0, 0.0, 0.0, 6.0, 7.0, 4.0, 4.0, 1.0, 0.0, 0.0, 0.0, 3.0, 5.0, 5.0, 5.0, 6.0, 0.0);
    data(46) := (0.0, 0.0, 4.0, 5.0, 7.0, 6.0, 2.0, 0.0, 0.0, 1.0, 5.0, 4.0, 4.0, 5.0, 5.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 6.0, 3.0, 0.0, 0.0, 0.0, 0.0, 1.0, 7.0, 5.0, 0.0, 0.0);
    data(47) :=         (0.0, 0.0, 0.0, 0.0, 6.0, 2.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 4.0, 6.0, 0.0, 0.0, 0.0, 0.0, 3.0, 4.0, 6.0, 7.0, 0.0, 0.0, 0.0, 0.0, 6.0, 7.0, 5.0, 1.0, 0.0, 0.0);
    data(48) := (0.0, 0.0, 0.0, 0.0, 5.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 3.0, 6.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 7.0, 3.0, 4.0, 0.0, 0.0, 0.0, 0.0, 6.0, 4.0, 0.0, 7.0, 3.0, 0.0);
    data(49) :=         (0.0, 3.0, 7.0, 4.0, 5.0, 7.0, 0.0, 0.0, 0.0, 0.0, 2.0, 4.0, 6.0, 7.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 3.0, 7.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 5.0, 4.0, 0.0, 0.0);
    data(50) := (0.0, 0.0, 5.0, 4.0, 4.0, 3.0, 0.0, 0.0, 0.0, 1.0, 7.0, 7.0, 5.0, 3.0, 0.0, 0.0, 0.0, 1.0, 6.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 6.0, 2.0, 0.0, 0.0, 0.0, 0.0);
    data(51) :=         (0.0, 1.0, 7.0, 7.0, 4.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 7.0, 1.0, 0.0, 0.0, 0.0, 0.0, 2.0, 4.0, 7.0, 2.0, 0.0, 0.0, 0.0, 0.0, 5.0, 6.0, 4.0, 0.0, 0.0, 0.0);
    data(52) := (0.0, 0.0, 0.0, 6.0, 6.0, 1.0, 0.0, 0.0, 0.0, 0.0, 4.0, 7.0, 6.0, 1.0, 0.0, 0.0, 0.0, 1.0, 7.0, 7.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 7.0, 5.0, 0.0, 0.0, 0.0, 0.0);
    data(53) :=         (0.0, 2.0, 7.0, 6.0, 2.0, 0.0, 0.0, 0.0, 0.0, 1.0, 7.0, 7.0, 7.0, 7.0, 3.0, 0.0, 0.0, 0.0, 6.0, 7.0, 7.0, 7.0, 5.0, 0.0, 0.0, 0.0, 1.0, 5.0, 7.0, 6.0, 3.0, 0.0);
    data(54) := (0.0, 0.0, 0.0, 4.0, 6.0, 6.0, 1.0, 0.0, 0.0, 0.0, 0.0, 3.0, 4.0, 7.0, 5.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 6.0, 4.0, 0.0, 0.0, 1.0, 4.0, 5.0, 5.0, 7.0, 4.0, 0.0);
    data(55) :=         (0.0, 4.0, 7.0, 7.0, 7.0, 7.0, 3.0, 0.0, 0.0, 0.0, 0.0, 0.0, 5.0, 7.0, 0.0, 0.0, 0.0, 0.0, 0.0, 4.0, 7.0, 3.0, 0.0, 0.0, 0.0, 0.0, 0.0, 5.0, 6.0, 0.0, 0.0, 0.0);
    data(56) := (0.0, 0.0, 4.0, 5.0, 2.0, 0.0, 0.0, 0.0, 0.0, 0.0, 4.0, 7.0, 6.0, 6.0, 0.0, 0.0, 0.0, 0.0, 4.0, 5.0, 0.0, 6.0, 2.0, 0.0, 0.0, 0.0, 0.0, 6.0, 7.0, 6.0, 0.0, 0.0);
    data(57) :=         (0.0, 0.0, 5.0, 7.0, 7.0, 0.0, 0.0, 0.0, 0.0, 0.0, 7.0, 1.0, 4.0, 4.0, 0.0, 0.0, 0.0, 0.0, 6.0, 3.0, 7.0, 4.0, 0.0, 0.0, 0.0, 0.0, 4.0, 6.0, 3.0, 0.0, 0.0, 0.0);
    data(58) := (0.0, 0.0, 4.0, 6.0, 3.0, 0.0, 0.0, 0.0, 0.0, 0.0, 5.0, 7.0, 7.0, 1.0, 0.0, 0.0, 0.0, 0.0, 5.0, 6.0, 7.0, 3.0, 0.0, 0.0, 0.0, 0.0, 3.0, 7.0, 7.0, 6.0, 0.0, 0.0);
    data(59) :=         (0.0, 0.0, 0.0, 0.0, 1.0, 7.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 4.0, 4.0, 0.0, 0.0, 0.0, 1.0, 3.0, 5.0, 6.0, 7.0, 1.0, 0.0, 0.0, 3.0, 5.0, 5.0, 5.0, 5.0, 0.0);
    data(60) := (0.0, 0.0, 4.0, 6.0, 5.0, 1.0, 0.0, 0.0, 0.0, 2.0, 7.0, 6.0, 3.0, 6.0, 0.0, 0.0, 0.0, 2.0, 7.0, 1.0, 0.0, 5.0, 3.0, 0.0, 0.0, 4.0, 7.0, 0.0, 0.0, 4.0, 2.0, 0.0);
    data(61) :=         (0.0, 4.0, 7.0, 0.0, 0.0, 6.0, 2.0, 0.0, 0.0, 4.0, 7.0, 0.0, 0.0, 7.0, 0.0, 0.0, 0.0, 2.0, 7.0, 0.0, 5.0, 7.0, 0.0, 0.0, 0.0, 0.0, 5.0, 7.0, 5.0, 1.0, 0.0, 0.0);
    data(62) := (0.0, 0.0, 1.0, 6.0, 4.0, 0.0, 0.0, 0.0, 0.0, 0.0, 3.0, 7.0, 7.0, 3.0, 0.0, 0.0, 0.0, 0.0, 2.0, 7.0, 6.0, 5.0, 0.0, 0.0, 0.0, 0.0, 0.0, 3.0, 7.0, 7.0, 0.0, 0.0);
    data(63) :=         (0.0, 0.0, 0.0, 0.0, 0.0, 6.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 3.0, 5.0, 0.0, 0.0, 0.0, 0.0, 1.0, 2.0, 2.0, 7.0, 1.0, 0.0, 0.0, 1.0, 7.0, 6.0, 6.0, 6.0, 1.0);
    data(64) := (0.0, 1.0, 6.0, 7.0, 7.0, 7.0, 5.0, 0.0, 0.0, 2.0, 7.0, 4.0, 2.0, 2.0, 0.0, 0.0, 0.0, 3.0, 7.0, 3.0, 1.0, 0.0, 0.0, 0.0, 0.0, 4.0, 7.0, 7.0, 7.0, 3.0, 0.0, 0.0);
    data(65) :=         (0.0, 1.0, 4.0, 2.0, 5.0, 7.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 5.0, 7.0, 0.0, 0.0, 0.0, 0.0, 2.0, 6.0, 7.0, 3.0, 0.0, 0.0, 0.0, 1.0, 7.0, 7.0, 4.0, 0.0, 0.0, 0.0);
    data(66) := (0.0, 3.0, 6.0, 2.0, 4.0, 4.0, 0.0, 0.0, 0.0, 4.0, 7.0, 7.0, 7.0, 7.0, 3.0, 0.0, 0.0, 3.0, 7.0, 4.0, 3.0, 2.0, 0.0, 0.0, 0.0, 3.0, 7.0, 7.0, 7.0, 2.0, 0.0, 0.0);
    data(67) :=         (0.0, 0.0, 2.0, 2.0, 7.0, 5.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 7.0, 4.0, 0.0, 0.0, 0.0, 0.0, 4.0, 6.0, 7.0, 1.0, 0.0, 0.0, 0.0, 2.0, 7.0, 7.0, 1.0, 0.0, 0.0, 0.0);
    data(68) := (0.0, 0.0, 0.0, 2.0, 6.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 6.0, 5.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 7.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 3.0, 7.0, 2.0, 0.0, 0.0, 0.0);
    data(69) :=         (0.0, 0.0, 7.0, 7.0, 7.0, 5.0, 0.0, 0.0, 0.0, 1.0, 6.0, 6.0, 0.0, 5.0, 4.0, 0.0, 0.0, 0.0, 2.0, 7.0, 3.0, 6.0, 4.0, 0.0, 0.0, 0.0, 0.0, 2.0, 7.0, 7.0, 1.0, 0.0);
    data(70) := (0.0, 1.0, 7.0, 4.0, 4.0, 3.0, 0.0, 0.0, 0.0, 2.0, 7.0, 7.0, 7.0, 6.0, 1.0, 0.0, 0.0, 1.0, 7.0, 4.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 7.0, 7.0, 7.0, 1.0, 0.0, 0.0);
    data(71) :=         (0.0, 0.0, 3.0, 3.0, 5.0, 4.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 6.0, 4.0, 0.0, 0.0, 0.0, 0.0, 2.0, 6.0, 7.0, 1.0, 0.0, 0.0, 0.0, 0.0, 7.0, 6.0, 0.0, 0.0, 0.0, 0.0);
    data(72) := (0.0, 0.0, 3.0, 6.0, 4.0, 1.0, 0.0, 0.0, 0.0, 0.0, 7.0, 7.0, 6.0, 7.0, 1.0, 0.0, 0.0, 1.0, 7.0, 4.0, 0.0, 6.0, 4.0, 0.0, 0.0, 0.0, 7.0, 2.0, 0.0, 5.0, 2.0, 0.0);
    data(73) :=         (0.0, 0.0, 7.0, 1.0, 0.0, 6.0, 3.0, 0.0, 0.0, 0.0, 7.0, 2.0, 3.0, 6.0, 0.0, 0.0, 0.0, 0.0, 7.0, 5.0, 6.0, 4.0, 0.0, 0.0, 0.0, 0.0, 3.0, 7.0, 5.0, 0.0, 0.0, 0.0);
    data(74) := (0.0, 0.0, 6.0, 4.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 7.0, 6.0, 3.0, 0.0, 0.0, 0.0, 0.0, 2.0, 7.0, 4.0, 6.0, 0.0, 0.0, 0.0, 0.0, 1.0, 6.0, 7.0, 7.0, 3.0, 0.0, 0.0);
    data(75) :=         (0.0, 0.0, 0.0, 2.0, 4.0, 6.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 6.0, 3.0, 0.0, 0.0, 0.0, 2.0, 4.0, 2.0, 4.0, 6.0, 0.0, 0.0, 0.0, 6.0, 6.0, 7.0, 7.0, 6.0, 0.0);
    data(76) := (0.0, 0.0, 3.0, 3.0, 6.0, 7.0, 2.0, 0.0, 0.0, 0.0, 6.0, 6.0, 3.0, 5.0, 3.0, 0.0, 0.0, 0.0, 4.0, 2.0, 4.0, 5.0, 0.0, 0.0, 0.0, 0.0, 4.0, 7.0, 4.0, 0.0, 0.0, 0.0);
    data(77) :=         (0.0, 1.0, 6.0, 7.0, 0.0, 0.0, 0.0, 0.0, 0.0, 4.0, 4.0, 5.0, 2.0, 0.0, 0.0, 0.0, 0.0, 2.0, 4.0, 4.0, 4.0, 0.0, 0.0, 0.0, 0.0, 0.0, 5.0, 7.0, 3.0, 0.0, 0.0, 0.0);
    data(78) := (0.0, 0.0, 4.0, 7.0, 6.0, 3.0, 0.0, 0.0, 0.0, 3.0, 6.0, 2.0, 4.0, 5.0, 0.0, 0.0, 0.0, 3.0, 7.0, 4.0, 7.0, 5.0, 0.0, 0.0, 0.0, 0.0, 4.0, 5.0, 3.0, 6.0, 0.0, 0.0);
    data(79) :=         (0.0, 0.0, 0.0, 0.0, 0.0, 7.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 5.0, 3.0, 0.0, 0.0, 1.0, 6.0, 4.0, 2.0, 6.0, 2.0, 0.0, 0.0, 0.0, 4.0, 6.0, 6.0, 4.0, 0.0, 0.0);
    data(80) := (0.0, 0.0, 5.0, 4.0, 5.0, 2.0, 0.0, 0.0, 0.0, 0.0, 5.0, 6.0, 4.0, 7.0, 0.0, 0.0, 0.0, 0.0, 3.0, 6.0, 5.0, 7.0, 0.0, 0.0, 0.0, 0.0, 0.0, 7.0, 6.0, 2.0, 0.0, 0.0);
    data(81) :=         (0.0, 0.0, 4.0, 7.0, 6.0, 0.0, 0.0, 0.0, 0.0, 0.0, 6.0, 3.0, 5.0, 3.0, 0.0, 0.0, 0.0, 2.0, 6.0, 2.0, 5.0, 6.0, 0.0, 0.0, 0.0, 0.0, 5.0, 6.0, 5.0, 2.0, 0.0, 0.0);
    data(82) := (0.0, 0.0, 0.0, 4.0, 7.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 7.0, 5.0, 0.0, 0.0, 0.0, 0.0, 0.0, 7.0, 6.0, 1.0, 5.0, 1.0, 0.0, 0.0, 2.0, 7.0, 4.0, 2.0, 7.0, 4.0, 0.0);
    data(83) :=         (0.0, 4.0, 7.0, 5.0, 6.0, 7.0, 1.0, 0.0, 0.0, 0.0, 4.0, 7.0, 7.0, 6.0, 0.0, 0.0, 0.0, 0.0, 0.0, 4.0, 7.0, 3.0, 0.0, 0.0, 0.0, 0.0, 0.0, 4.0, 7.0, 1.0, 0.0, 0.0);
    data(84) := (0.0, 0.0, 0.0, 0.0, 5.0, 2.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 7.0, 5.0, 0.0, 0.0, 0.0, 0.0, 0.0, 5.0, 7.0, 5.0, 0.0, 0.0, 0.0, 1.0, 5.0, 7.0, 7.0, 4.0, 0.0, 0.0);
    data(85) :=         (0.0, 3.0, 5.0, 2.0, 7.0, 3.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 7.0, 4.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 7.0, 5.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 7.0, 4.0, 0.0, 0.0);
    data(86) := (0.0, 0.0, 0.0, 4.0, 7.0, 5.0, 0.0, 0.0, 0.0, 0.0, 2.0, 3.0, 3.0, 6.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 6.0, 1.0, 0.0, 0.0, 2.0, 4.0, 4.0, 4.0, 6.0, 0.0, 0.0);
    data(87) :=         (0.0, 2.0, 7.0, 7.0, 7.0, 7.0, 3.0, 0.0, 0.0, 0.0, 0.0, 0.0, 6.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 4.0, 5.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 5.0, 3.0, 0.0, 0.0, 0.0);
    data(88) := (0.0, 0.0, 4.0, 7.0, 7.0, 7.0, 2.0, 0.0, 0.0, 0.0, 6.0, 4.0, 4.0, 7.0, 4.0, 0.0, 0.0, 0.0, 0.0, 0.0, 3.0, 7.0, 1.0, 0.0, 0.0, 1.0, 4.0, 5.0, 7.0, 7.0, 5.0, 0.0);
    data(89) :=         (0.0, 4.0, 7.0, 7.0, 7.0, 5.0, 1.0, 0.0, 0.0, 0.0, 1.0, 7.0, 3.0, 0.0, 0.0, 0.0, 0.0, 0.0, 4.0, 7.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 6.0, 4.0, 0.0, 0.0, 0.0, 0.0);
    data(90) := (0.0, 0.0, 4.0, 7.0, 6.0, 3.0, 0.0, 0.0, 0.0, 0.0, 3.0, 2.0, 7.0, 7.0, 0.0, 0.0, 0.0, 0.0, 0.0, 4.0, 7.0, 2.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 6.0, 1.0, 0.0, 0.0);
    data(91) :=         (0.0, 0.0, 0.0, 0.0, 4.0, 7.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 5.0, 5.0, 0.0, 0.0, 0.0, 2.0, 4.0, 5.0, 7.0, 5.0, 0.0, 0.0, 0.0, 5.0, 6.0, 5.0, 4.0, 0.0, 0.0);
    data(92) := (0.0, 0.0, 7.0, 2.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 7.0, 7.0, 7.0, 6.0, 1.0, 0.0, 0.0, 3.0, 7.0, 5.0, 4.0, 4.0, 1.0, 0.0, 0.0, 2.0, 7.0, 5.0, 2.0, 0.0, 0.0, 0.0);
    data(93) :=         (0.0, 0.0, 5.0, 6.0, 6.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 7.0, 3.0, 0.0, 0.0, 0.0, 0.0, 3.0, 7.0, 7.0, 2.0, 0.0, 0.0, 0.0, 0.0, 6.0, 6.0, 2.0, 0.0, 0.0, 0.0);
    data(94) := (0.0, 0.0, 0.0, 0.0, 5.0, 4.0, 0.0, 0.0, 0.0, 0.0, 0.0, 3.0, 7.0, 6.0, 0.0, 0.0, 0.0, 0.0, 2.0, 6.0, 7.0, 4.0, 0.0, 0.0, 0.0, 4.0, 7.0, 5.0, 7.0, 4.0, 0.0, 0.0);
    data(95) :=         (0.0, 0.0, 0.0, 1.0, 7.0, 3.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 7.0, 4.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 7.0, 4.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 6.0, 3.0, 0.0, 0.0);
    data(96) := (0.0, 0.0, 1.0, 7.0, 6.0, 1.0, 0.0, 0.0, 0.0, 0.0, 4.0, 7.0, 5.0, 7.0, 0.0, 0.0, 0.0, 1.0, 7.0, 3.0, 0.0, 4.0, 0.0, 0.0, 0.0, 2.0, 7.0, 4.0, 0.0, 1.0, 4.0, 0.0);
    data(97) :=         (0.0, 4.0, 6.0, 1.0, 0.0, 2.0, 4.0, 0.0, 0.0, 1.0, 7.0, 0.0, 0.0, 1.0, 3.0, 0.0, 0.0, 0.0, 6.0, 5.0, 3.0, 6.0, 2.0, 0.0, 0.0, 0.0, 2.0, 5.0, 7.0, 3.0, 0.0, 0.0);
    data(98) := (0.0, 0.0, 0.0, 7.0, 6.0, 0.0, 0.0, 0.0, 0.0, 0.0, 3.0, 7.0, 6.0, 4.0, 0.0, 0.0, 0.0, 4.0, 5.0, 4.0, 1.0, 6.0, 1.0, 0.0, 0.0, 3.0, 4.0, 0.0, 0.0, 3.0, 3.0, 0.0);
    data(99) :=         (0.0, 2.0, 4.0, 0.0, 0.0, 1.0, 4.0, 0.0, 0.0, 0.0, 7.0, 1.0, 0.0, 4.0, 5.0, 0.0, 0.0, 0.0, 4.0, 7.0, 6.0, 7.0, 3.0, 0.0, 0.0, 0.0, 0.0, 6.0, 6.0, 4.0, 0.0, 0.0);
    data(100) := (0.0, 0.0, 0.0, 2.0, 6.0, 5.0, 1.0, 0.0, 0.0, 0.0, 3.0, 7.0, 4.0, 6.0, 2.0, 0.0, 0.0, 0.0, 3.0, 1.0, 1.0, 6.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 6.0, 2.0, 0.0, 0.0);
    data(101) :=        (0.0, 0.0, 0.0, 5.0, 4.0, 0.0, 0.0, 0.0, 0.0, 4.0, 7.0, 6.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 6.0, 7.0, 5.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 3.0, 5.0, 6.0, 1.0, 0.0);
    data(102) := (0.0, 0.0, 0.0, 1.0, 7.0, 4.0, 0.0, 0.0, 0.0, 0.0, 0.0, 5.0, 4.0, 7.0, 2.0, 0.0, 0.0, 0.0, 0.0, 5.0, 0.0, 7.0, 3.0, 0.0, 0.0, 0.0, 0.0, 1.0, 2.0, 7.0, 2.0, 0.0);
    data(103) :=        (0.0, 0.0, 0.0, 3.0, 7.0, 3.0, 0.0, 0.0, 0.0, 2.0, 7.0, 7.0, 4.0, 0.0, 0.0, 0.0, 0.0, 0.0, 6.0, 7.0, 7.0, 4.0, 1.0, 0.0, 0.0, 0.0, 0.0, 2.0, 4.0, 6.0, 3.0, 0.0);
    data(104) := (0.0, 0.0, 1.0, 5.0, 7.0, 7.0, 3.0, 0.0, 0.0, 0.0, 4.0, 5.0, 3.0, 7.0, 5.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 6.0, 4.0, 0.0, 0.0, 2.0, 5.0, 4.0, 4.0, 7.0, 1.0, 0.0);
    data(105) :=        (0.0, 4.0, 7.0, 7.0, 7.0, 7.0, 4.0, 0.0, 0.0, 0.0, 2.0, 4.0, 7.0, 3.0, 0.0, 0.0, 0.0, 0.0, 0.0, 5.0, 6.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 7.0, 2.0, 0.0, 0.0, 0.0);
    data(106) := (0.0, 0.0, 2.0, 4.0, 7.0, 2.0, 0.0, 0.0, 0.0, 0.0, 4.0, 7.0, 4.0, 5.0, 0.0, 0.0, 0.0, 0.0, 2.0, 4.0, 0.0, 6.0, 1.0, 0.0, 0.0, 0.0, 0.0, 6.0, 2.0, 7.0, 1.0, 0.0);
    data(107) :=        (0.0, 0.0, 0.0, 4.0, 7.0, 4.0, 0.0, 0.0, 0.0, 0.0, 4.0, 7.0, 6.0, 2.0, 0.0, 0.0, 0.0, 0.0, 7.0, 2.0, 6.0, 2.0, 0.0, 0.0, 0.0, 0.0, 3.0, 7.0, 5.0, 0.0, 0.0, 0.0);
    data(108) := (0.0, 0.0, 0.0, 0.0, 6.0, 6.0, 1.0, 0.0, 0.0, 0.0, 0.0, 4.0, 5.0, 6.0, 4.0, 0.0, 0.0, 0.0, 0.0, 3.0, 0.0, 6.0, 4.0, 0.0, 0.0, 0.0, 0.0, 0.0, 3.0, 7.0, 0.0, 0.0);
    data(109) :=        (0.0, 2.0, 4.0, 5.0, 7.0, 2.0, 0.0, 0.0, 0.0, 3.0, 7.0, 7.0, 3.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 5.0, 5.0, 2.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 6.0, 7.0, 2.0, 0.0);
    data(110) := (0.0, 0.0, 1.0, 6.0, 7.0, 2.0, 0.0, 0.0, 0.0, 0.0, 4.0, 7.0, 7.0, 7.0, 0.0, 0.0, 0.0, 1.0, 7.0, 4.0, 4.0, 7.0, 2.0, 0.0, 0.0, 2.0, 7.0, 0.0, 0.0, 6.0, 3.0, 0.0);
    data(111) :=        (0.0, 2.0, 7.0, 3.0, 0.0, 5.0, 3.0, 0.0, 0.0, 0.0, 7.0, 6.0, 2.0, 6.0, 3.0, 0.0, 0.0, 0.0, 5.0, 7.0, 7.0, 7.0, 0.0, 0.0, 0.0, 0.0, 1.0, 5.0, 6.0, 2.0, 0.0, 0.0);
    data(112) := (0.0, 0.0, 0.0, 0.0, 5.0, 6.0, 0.0, 0.0, 0.0, 0.0, 0.0, 4.0, 7.0, 7.0, 1.0, 0.0, 0.0, 0.0, 4.0, 7.0, 7.0, 5.0, 0.0, 0.0, 0.0, 2.0, 7.0, 7.0, 7.0, 6.0, 0.0, 0.0);
    data(113) :=        (0.0, 2.0, 3.0, 2.0, 7.0, 3.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 7.0, 4.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 7.0, 4.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 5.0, 5.0, 0.0, 0.0);
    data(114) := (0.0, 0.0, 0.0, 0.0, 4.0, 5.0, 0.0, 0.0, 0.0, 0.0, 0.0, 6.0, 7.0, 7.0, 0.0, 0.0, 0.0, 0.0, 0.0, 5.0, 3.0, 6.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 6.0, 3.0, 0.0, 0.0);
    data(115) :=        (0.0, 0.0, 2.0, 5.0, 5.0, 0.0, 0.0, 0.0, 0.0, 3.0, 7.0, 7.0, 3.0, 0.0, 0.0, 0.0, 0.0, 2.0, 4.0, 6.0, 7.0, 5.0, 2.0, 0.0, 0.0, 0.0, 0.0, 0.0, 4.0, 6.0, 1.0, 0.0);
    data(116) := (0.0, 0.0, 0.0, 4.0, 6.0, 0.0, 0.0, 0.0, 0.0, 0.0, 5.0, 5.0, 3.0, 0.0, 0.0, 0.0, 0.0, 1.0, 7.0, 5.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 7.0, 5.0, 0.0, 0.0, 0.0, 0.0);
    data(117) :=        (0.0, 2.0, 7.0, 7.0, 4.0, 2.0, 0.0, 0.0, 0.0, 2.0, 7.0, 7.0, 6.0, 7.0, 3.0, 0.0, 0.0, 0.0, 3.0, 7.0, 3.0, 6.0, 6.0, 0.0, 0.0, 0.0, 0.0, 3.0, 7.0, 7.0, 2.0, 0.0);
    data(118) := (0.0, 0.0, 4.0, 7.0, 5.0, 0.0, 0.0, 0.0, 0.0, 1.0, 4.0, 4.0, 5.0, 5.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 6.0, 7.0, 0.0, 0.0, 0.0, 0.0, 0.0, 5.0, 7.0, 1.0, 0.0, 0.0);
    data(119) :=        (0.0, 0.0, 0.0, 2.0, 7.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 5.0, 4.0, 0.0, 0.0, 0.0, 0.0, 1.0, 2.0, 4.0, 7.0, 0.0, 0.0, 0.0, 0.0, 6.0, 7.0, 7.0, 4.0, 0.0, 0.0);
    data(120) := (0.0, 0.0, 4.0, 7.0, 6.0, 2.0, 0.0, 0.0, 0.0, 0.0, 2.0, 3.0, 6.0, 7.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 7.0, 4.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 7.0, 3.0, 0.0, 0.0);
    data(121) :=        (0.0, 0.0, 0.0, 0.0, 4.0, 5.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 7.0, 2.0, 0.0, 0.0, 0.0, 4.0, 2.0, 3.0, 7.0, 3.0, 0.0, 0.0, 0.0, 6.0, 5.0, 7.0, 5.0, 1.0, 0.0);
    data(122) := (0.0, 0.0, 3.0, 6.0, 7.0, 3.0, 0.0, 0.0, 0.0, 1.0, 7.0, 6.0, 7.0, 7.0, 0.0, 0.0, 0.0, 0.0, 2.0, 0.0, 4.0, 7.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 4.0, 7.0, 1.0, 0.0);
    data(123) :=        (0.0, 1.0, 7.0, 7.0, 7.0, 7.0, 4.0, 0.0, 0.0, 2.0, 6.0, 6.0, 7.0, 5.0, 1.0, 0.0, 0.0, 0.0, 0.0, 5.0, 7.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 7.0, 3.0, 0.0, 0.0, 0.0);
    data(124) := (0.0, 0.0, 6.0, 7.0, 6.0, 3.0, 0.0, 0.0, 0.0, 0.0, 3.0, 4.0, 7.0, 7.0, 1.0, 0.0, 0.0, 0.0, 0.0, 2.0, 7.0, 7.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 7.0, 4.0, 0.0, 0.0);
    data(125) :=        (0.0, 0.0, 0.0, 0.0, 5.0, 6.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 7.0, 3.0, 0.0, 0.0, 0.0, 2.0, 4.0, 6.0, 7.0, 3.0, 0.0, 0.0, 0.0, 6.0, 7.0, 7.0, 4.0, 0.0, 0.0);
    data(126) := (0.0, 1.0, 7.0, 7.0, 6.0, 3.0, 0.0, 0.0, 0.0, 0.0, 4.0, 4.0, 7.0, 7.0, 2.0, 0.0, 0.0, 0.0, 0.0, 3.0, 7.0, 5.0, 0.0, 0.0, 0.0, 0.0, 0.0, 4.0, 7.0, 1.0, 0.0, 0.0);
    data(127) :=        (0.0, 0.0, 0.0, 1.0, 7.0, 3.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 4.0, 7.0, 0.0, 0.0, 0.0, 0.0, 4.0, 4.0, 7.0, 7.0, 1.0, 0.0, 0.0, 1.0, 6.0, 7.0, 5.0, 2.0, 0.0, 0.0);

    init_reg(data, '1', to_mat_size(64, 64), reg, "x_train", s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a0);
END init_mat_x_train_rbr;

END PACKAGE BODY;