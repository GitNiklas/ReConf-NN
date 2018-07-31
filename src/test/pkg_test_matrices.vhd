LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.pkg_tools.ALL;
USE work.pkg_test.ALL;
USE work.fixed_pkg.ALL;
    
PACKAGE pkg_test_matrices IS  

PROCEDURE init_mat_2x3_rbr(                     reg : INTEGER; SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word; SIGNAL s_sel_a : OUT t_mat_reg_ixs; SIGNAL s_sel_c : OUT t_mat_reg_ixs; SIGNAL s_opcode : OUT t_opcodes; SIGNAL s_wren : OUT STD_LOGIC; SIGNAL s_syn_rst : OUT STD_LOGIC; SIGNAL s_finished : IN t_op_std_logics);
PROCEDURE init_mat_3x3_cbc(                     reg : INTEGER; SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word; SIGNAL s_sel_a : OUT t_mat_reg_ixs; SIGNAL s_sel_c : OUT t_mat_reg_ixs; SIGNAL s_opcode : OUT t_opcodes; SIGNAL s_wren : OUT STD_LOGIC; SIGNAL s_syn_rst : OUT STD_LOGIC; SIGNAL s_finished : IN t_op_std_logics);
PROCEDURE init_mat_result_2x3_mul_3x3_rbr(      reg : INTEGER; SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word; SIGNAL s_sel_a : OUT t_mat_reg_ixs; SIGNAL s_sel_c : OUT t_mat_reg_ixs; SIGNAL s_opcode : OUT t_opcodes; SIGNAL s_wren : OUT STD_LOGIC; SIGNAL s_syn_rst : OUT STD_LOGIC; SIGNAL s_finished : IN t_op_std_logics);
PROCEDURE init_mat_2x36_rbr(                    reg : INTEGER; SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word; SIGNAL s_sel_a : OUT t_mat_reg_ixs; SIGNAL s_sel_c : OUT t_mat_reg_ixs; SIGNAL s_opcode : OUT t_opcodes; SIGNAL s_wren : OUT STD_LOGIC; SIGNAL s_syn_rst : OUT STD_LOGIC; SIGNAL s_finished : IN t_op_std_logics);
PROCEDURE init_mat_36x3_cbc(                    reg : INTEGER; SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word; SIGNAL s_sel_a : OUT t_mat_reg_ixs; SIGNAL s_sel_c : OUT t_mat_reg_ixs; SIGNAL s_opcode : OUT t_opcodes; SIGNAL s_wren : OUT STD_LOGIC; SIGNAL s_syn_rst : OUT STD_LOGIC; SIGNAL s_finished : IN t_op_std_logics);
PROCEDURE init_mat_result_2x36_mul_36x3_rbr(    reg : INTEGER; SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word; SIGNAL s_sel_a : OUT t_mat_reg_ixs; SIGNAL s_sel_c : OUT t_mat_reg_ixs; SIGNAL s_opcode : OUT t_opcodes; SIGNAL s_wren : OUT STD_LOGIC; SIGNAL s_syn_rst : OUT STD_LOGIC; SIGNAL s_finished : IN t_op_std_logics);
PROCEDURE init_mat_36x1_rbr(                    reg : INTEGER; SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word; SIGNAL s_sel_a : OUT t_mat_reg_ixs; SIGNAL s_sel_c : OUT t_mat_reg_ixs; SIGNAL s_opcode : OUT t_opcodes; SIGNAL s_wren : OUT STD_LOGIC; SIGNAL s_syn_rst : OUT STD_LOGIC; SIGNAL s_finished : IN t_op_std_logics);
PROCEDURE init_mat_1x2_cbc(                     reg : INTEGER; SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word; SIGNAL s_sel_a : OUT t_mat_reg_ixs; SIGNAL s_sel_c : OUT t_mat_reg_ixs; SIGNAL s_opcode : OUT t_opcodes; SIGNAL s_wren : OUT STD_LOGIC; SIGNAL s_syn_rst : OUT STD_LOGIC; SIGNAL s_finished : IN t_op_std_logics);
PROCEDURE init_mat_result_36x1_mul_1x2_cbc(     reg : INTEGER; SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word; SIGNAL s_sel_a : OUT t_mat_reg_ixs; SIGNAL s_sel_c : OUT t_mat_reg_ixs; SIGNAL s_opcode : OUT t_opcodes; SIGNAL s_wren : OUT STD_LOGIC; SIGNAL s_syn_rst : OUT STD_LOGIC; SIGNAL s_finished : IN t_op_std_logics);
PROCEDURE init_mat_a0_64x64_rbr(                reg : INTEGER; SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word; SIGNAL s_sel_a : OUT t_mat_reg_ixs; SIGNAL s_sel_c : OUT t_mat_reg_ixs; SIGNAL s_opcode : OUT t_opcodes; SIGNAL s_wren : OUT STD_LOGIC; SIGNAL s_syn_rst : OUT STD_LOGIC; SIGNAL s_finished : IN t_op_std_logics);
PROCEDURE init_mat_a1_64x64_cbc(                reg : INTEGER; SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word; SIGNAL s_sel_a : OUT t_mat_reg_ixs; SIGNAL s_sel_c : OUT t_mat_reg_ixs; SIGNAL s_opcode : OUT t_opcodes; SIGNAL s_wren : OUT STD_LOGIC; SIGNAL s_syn_rst : OUT STD_LOGIC; SIGNAL s_finished : IN t_op_std_logics);
PROCEDURE init_mat_result_a0_add_a0(            reg : INTEGER; SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word; SIGNAL s_sel_a : OUT t_mat_reg_ixs; SIGNAL s_sel_c : OUT t_mat_reg_ixs; SIGNAL s_opcode : OUT t_opcodes; SIGNAL s_wren : OUT STD_LOGIC; SIGNAL s_syn_rst : OUT STD_LOGIC; SIGNAL s_finished : IN t_op_std_logics);
PROCEDURE init_mat_result_a1_add_a1(            reg : INTEGER; SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word; SIGNAL s_sel_a : OUT t_mat_reg_ixs; SIGNAL s_sel_c : OUT t_mat_reg_ixs; SIGNAL s_opcode : OUT t_opcodes; SIGNAL s_wren : OUT STD_LOGIC; SIGNAL s_syn_rst : OUT STD_LOGIC; SIGNAL s_finished : IN t_op_std_logics);
PROCEDURE init_mat_result_a0_trans(             reg : INTEGER; SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word; SIGNAL s_sel_a : OUT t_mat_reg_ixs; SIGNAL s_sel_c : OUT t_mat_reg_ixs; SIGNAL s_opcode : OUT t_opcodes; SIGNAL s_wren : OUT STD_LOGIC; SIGNAL s_syn_rst : OUT STD_LOGIC; SIGNAL s_finished : IN t_op_std_logics);
PROCEDURE init_mat_result_a1_trans(             reg : INTEGER; SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word; SIGNAL s_sel_a : OUT t_mat_reg_ixs; SIGNAL s_sel_c : OUT t_mat_reg_ixs; SIGNAL s_opcode : OUT t_opcodes; SIGNAL s_wren : OUT STD_LOGIC; SIGNAL s_syn_rst : OUT STD_LOGIC; SIGNAL s_finished : IN t_op_std_logics);
PROCEDURE init_mat_result_a0_scalar_max(        reg : INTEGER; SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word; SIGNAL s_sel_a : OUT t_mat_reg_ixs; SIGNAL s_sel_c : OUT t_mat_reg_ixs; SIGNAL s_opcode : OUT t_opcodes; SIGNAL s_wren : OUT STD_LOGIC; SIGNAL s_syn_rst : OUT STD_LOGIC; SIGNAL s_finished : IN t_op_std_logics);
PROCEDURE init_mat_a2_64x64_rbr(                reg : INTEGER; SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word; SIGNAL s_sel_a : OUT t_mat_reg_ixs; SIGNAL s_sel_c : OUT t_mat_reg_ixs; SIGNAL s_opcode : OUT t_opcodes; SIGNAL s_wren : OUT STD_LOGIC; SIGNAL s_syn_rst : OUT STD_LOGIC; SIGNAL s_finished : IN t_op_std_logics);
PROCEDURE init_mat_result_a2_scalar_div(        reg : INTEGER; SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word; SIGNAL s_sel_a : OUT t_mat_reg_ixs; SIGNAL s_sel_c : OUT t_mat_reg_ixs; SIGNAL s_opcode : OUT t_opcodes; SIGNAL s_wren : OUT STD_LOGIC; SIGNAL s_syn_rst : OUT STD_LOGIC; SIGNAL s_finished : IN t_op_std_logics);
PROCEDURE init_mat_a3_1x64_rbr(                 reg : INTEGER; SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word; SIGNAL s_sel_a : OUT t_mat_reg_ixs; SIGNAL s_sel_c : OUT t_mat_reg_ixs; SIGNAL s_opcode : OUT t_opcodes; SIGNAL s_wren : OUT STD_LOGIC; SIGNAL s_syn_rst : OUT STD_LOGIC; SIGNAL s_finished : IN t_op_std_logics);
PROCEDURE init_mat_result_a0_vec_add_a3(        reg : INTEGER; SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word; SIGNAL s_sel_a : OUT t_mat_reg_ixs; SIGNAL s_sel_c : OUT t_mat_reg_ixs; SIGNAL s_opcode : OUT t_opcodes; SIGNAL s_wren : OUT STD_LOGIC; SIGNAL s_syn_rst : OUT STD_LOGIC; SIGNAL s_finished : IN t_op_std_logics);
PROCEDURE init_mat_result_a1_col_sum_rbr(       reg : INTEGER; SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word; SIGNAL s_sel_a : OUT t_mat_reg_ixs; SIGNAL s_sel_c : OUT t_mat_reg_ixs; SIGNAL s_opcode : OUT t_opcodes; SIGNAL s_wren : OUT STD_LOGIC; SIGNAL s_syn_rst : OUT STD_LOGIC; SIGNAL s_finished : IN t_op_std_logics);
PROCEDURE init_mat_result_a1_col_sum_cbc(       reg : INTEGER; SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word; SIGNAL s_sel_a : OUT t_mat_reg_ixs; SIGNAL s_sel_c : OUT t_mat_reg_ixs; SIGNAL s_opcode : OUT t_opcodes; SIGNAL s_wren : OUT STD_LOGIC; SIGNAL s_syn_rst : OUT STD_LOGIC; SIGNAL s_finished : IN t_op_std_logics);
PROCEDURE init_mat_result_a0_flip(              reg : INTEGER; SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word; SIGNAL s_sel_a : OUT t_mat_reg_ixs; SIGNAL s_sel_c : OUT t_mat_reg_ixs; SIGNAL s_opcode : OUT t_opcodes; SIGNAL s_wren : OUT STD_LOGIC; SIGNAL s_syn_rst : OUT STD_LOGIC; SIGNAL s_finished : IN t_op_std_logics);
PROCEDURE init_mat_result_a1_scalar_sub_ix_1(   reg : INTEGER; SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word; SIGNAL s_sel_a : OUT t_mat_reg_ixs; SIGNAL s_sel_c : OUT t_mat_reg_ixs; SIGNAL s_opcode : OUT t_opcodes; SIGNAL s_wren : OUT STD_LOGIC; SIGNAL s_syn_rst : OUT STD_LOGIC; SIGNAL s_finished : IN t_op_std_logics);

END;


PACKAGE BODY pkg_test_matrices IS

TYPE t_mat_word_const_arr IS ARRAY(NATURAL RANGE <>) OF t_mat_word_const;

PROCEDURE init_reg(
    data : t_mat_word_const_arr;
    row_by_row : STD_LOGIC;
    mat_size : t_mat_size;
    reg : INTEGER; 
    mat_add_descr : STRING;
 
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word;
    SIGNAL s_sel_a : OUT t_mat_reg_ixs; SIGNAL s_sel_c : OUT t_mat_reg_ixs; SIGNAL s_opcode : OUT t_opcodes; SIGNAL s_wren : OUT STD_LOGIC; SIGNAL s_syn_rst : OUT STD_LOGIC; SIGNAL s_finished : IN t_op_std_logics
) IS
VARIABLE row_by_row_text : STRING(1 TO 14);
BEGIN
    delete_reg(reg, s_sel_c, s_opcode, s_wren, s_syn_rst, s_finished);
    IF row_by_row = '1' THEN row_by_row_text := "[Zeilenweise] "; ELSE row_by_row_text := "[Spaltenweise]"; END IF;
    REPORT infomsg("Register " & INTEGER'IMAGE(reg) & " = " & mat_size_to_str(mat_size) & " Matrix " & row_by_row_text & " " & mat_add_descr);
    s_sel_a(0) <= to_mat_reg_ix(reg); 
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

PROCEDURE init_mat_2x3_rbr(
    reg : INTEGER; 
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word;
    SIGNAL s_sel_a : OUT t_mat_reg_ixs; SIGNAL s_sel_c : OUT t_mat_reg_ixs; SIGNAL s_opcode : OUT t_opcodes; SIGNAL s_wren : OUT STD_LOGIC; SIGNAL s_syn_rst : OUT STD_LOGIC; SIGNAL s_finished : IN t_op_std_logics
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
    
    init_reg(data, '1', to_mat_size(2, 3), reg, "", s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a, s_sel_c, s_opcode, s_wren, s_syn_rst, s_finished);
END init_mat_2x3_rbr;

PROCEDURE init_mat_3x3_cbc(
    reg : INTEGER; 
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word;
    SIGNAL s_sel_a : OUT t_mat_reg_ixs; SIGNAL s_sel_c : OUT t_mat_reg_ixs; SIGNAL s_opcode : OUT t_opcodes; SIGNAL s_wren : OUT STD_LOGIC; SIGNAL s_syn_rst : OUT STD_LOGIC; SIGNAL s_finished : IN t_op_std_logics
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
    
    init_reg(data, '0', to_mat_size(3, 3), reg, "", s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a, s_sel_c, s_opcode, s_wren, s_syn_rst, s_finished);
END init_mat_3x3_cbc;

PROCEDURE init_mat_result_2x3_mul_3x3_rbr(
    reg : INTEGER; 
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word;
    SIGNAL s_sel_a : OUT t_mat_reg_ixs; SIGNAL s_sel_c : OUT t_mat_reg_ixs; SIGNAL s_opcode : OUT t_opcodes; SIGNAL s_wren : OUT STD_LOGIC; SIGNAL s_syn_rst : OUT STD_LOGIC; SIGNAL s_finished : IN t_op_std_logics
) IS
VARIABLE data: t_mat_word_const_arr(0 TO 1);
BEGIN
    data := (
        (1.25, -0.375, -2.5625,         0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0),
        (-1.75, 0.5625, 3.25,           0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
    );
    
    init_reg(data, '1', to_mat_size(2, 3), reg, "Ergebnis 2x3 * 3x3", s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a, s_sel_c, s_opcode, s_wren, s_syn_rst, s_finished);
END init_mat_result_2x3_mul_3x3_rbr;

PROCEDURE init_mat_2x36_rbr(
    reg : INTEGER; 
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word;
    SIGNAL s_sel_a : OUT t_mat_reg_ixs; SIGNAL s_sel_c : OUT t_mat_reg_ixs; SIGNAL s_opcode : OUT t_opcodes; SIGNAL s_wren : OUT STD_LOGIC; SIGNAL s_syn_rst : OUT STD_LOGIC; SIGNAL s_finished : IN t_op_std_logics
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
    
    init_reg(data, '1', to_mat_size(2, 36), reg, "", s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a, s_sel_c, s_opcode, s_wren, s_syn_rst, s_finished);
END init_mat_2x36_rbr;

PROCEDURE init_mat_36x3_cbc(
    reg : INTEGER; 
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word;
    SIGNAL s_sel_a : OUT t_mat_reg_ixs; SIGNAL s_sel_c : OUT t_mat_reg_ixs; SIGNAL s_opcode : OUT t_opcodes; SIGNAL s_wren : OUT STD_LOGIC; SIGNAL s_syn_rst : OUT STD_LOGIC; SIGNAL s_finished : IN t_op_std_logics
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
    
    init_reg(data, '0', to_mat_size(36, 3), reg, "", s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a, s_sel_c, s_opcode, s_wren, s_syn_rst, s_finished);
END init_mat_36x3_cbc;

PROCEDURE init_mat_result_2x36_mul_36x3_rbr(
    reg : INTEGER; 
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word;
    SIGNAL s_sel_a : OUT t_mat_reg_ixs; SIGNAL s_sel_c : OUT t_mat_reg_ixs; SIGNAL s_opcode : OUT t_opcodes; SIGNAL s_wren : OUT STD_LOGIC; SIGNAL s_syn_rst : OUT STD_LOGIC; SIGNAL s_finished : IN t_op_std_logics
) IS
VARIABLE data: t_mat_word_const_arr(0 TO 1);
BEGIN
    -- 5.0      3.0     1.75
    -- -0.2     2.575   7.525 -- erzeugt rundungsfehler!
    data := (
        (5.0, 3.0, 1.75,            0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0),
        (-0.25, 2.5, 7.625,         0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
    );
    
    init_reg(data, '1', to_mat_size(2, 3), reg, "Ergebnis 2x36 * 36x3", s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a, s_sel_c, s_opcode, s_wren, s_syn_rst, s_finished);
END init_mat_result_2x36_mul_36x3_rbr;

PROCEDURE init_mat_36x1_rbr(
    reg : INTEGER; 
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word;
    SIGNAL s_sel_a : OUT t_mat_reg_ixs; SIGNAL s_sel_c : OUT t_mat_reg_ixs; SIGNAL s_opcode : OUT t_opcodes; SIGNAL s_wren : OUT STD_LOGIC; SIGNAL s_syn_rst : OUT STD_LOGIC; SIGNAL s_finished : IN t_op_std_logics
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
    
    init_reg(data, '1', to_mat_size(36, 1), reg, "", s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a, s_sel_c, s_opcode, s_wren, s_syn_rst, s_finished);
END init_mat_36x1_rbr;

PROCEDURE init_mat_1x2_cbc(
    reg : INTEGER; 
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word;
    SIGNAL s_sel_a : OUT t_mat_reg_ixs; SIGNAL s_sel_c : OUT t_mat_reg_ixs; SIGNAL s_opcode : OUT t_opcodes; SIGNAL s_wren : OUT STD_LOGIC; SIGNAL s_syn_rst : OUT STD_LOGIC; SIGNAL s_finished : IN t_op_std_logics
) IS
VARIABLE data: t_mat_word_const_arr(0 TO 1);
BEGIN
    -- [2, 1]
    data := (
        (2.0,               0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0),
        (1.0,               0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
    );
    
    init_reg(data, '0', to_mat_size(1, 2), reg, "", s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a, s_sel_c, s_opcode, s_wren, s_syn_rst, s_finished);
END init_mat_1x2_cbc;

PROCEDURE init_mat_result_36x1_mul_1x2_cbc(
    reg : INTEGER; 
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word;
    SIGNAL s_sel_a : OUT t_mat_reg_ixs; SIGNAL s_sel_c : OUT t_mat_reg_ixs; SIGNAL s_opcode : OUT t_opcodes; SIGNAL s_wren : OUT STD_LOGIC; SIGNAL s_syn_rst : OUT STD_LOGIC; SIGNAL s_finished : IN t_op_std_logics
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
    
    init_reg(data, '0', to_mat_size(36, 2), reg, "Ergebnis 36x1 * 1x2", s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a, s_sel_c, s_opcode, s_wren, s_syn_rst, s_finished);
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
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word;
    SIGNAL s_sel_a : OUT t_mat_reg_ixs; SIGNAL s_sel_c : OUT t_mat_reg_ixs; SIGNAL s_opcode : OUT t_opcodes; SIGNAL s_wren : OUT STD_LOGIC; SIGNAL s_syn_rst : OUT STD_LOGIC; SIGNAL s_finished : IN t_op_std_logics
) IS
BEGIN   
    init_reg(data_a0_a1, '1', to_mat_size(64, 64), reg, "a0", s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a, s_sel_c, s_opcode, s_wren, s_syn_rst, s_finished);
END init_mat_a0_64x64_rbr;

PROCEDURE init_mat_a1_64x64_cbc(
    reg : INTEGER; 
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word;
    SIGNAL s_sel_a : OUT t_mat_reg_ixs; SIGNAL s_sel_c : OUT t_mat_reg_ixs; SIGNAL s_opcode : OUT t_opcodes; SIGNAL s_wren : OUT STD_LOGIC; SIGNAL s_syn_rst : OUT STD_LOGIC; SIGNAL s_finished : IN t_op_std_logics
) IS
BEGIN
    init_reg(data_a0_a1, '0', to_mat_size(64, 64), reg, "a1", s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a, s_sel_c, s_opcode, s_wren, s_syn_rst, s_finished);
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
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word;
    SIGNAL s_sel_a : OUT t_mat_reg_ixs; SIGNAL s_sel_c : OUT t_mat_reg_ixs; SIGNAL s_opcode : OUT t_opcodes; SIGNAL s_wren : OUT STD_LOGIC; SIGNAL s_syn_rst : OUT STD_LOGIC; SIGNAL s_finished : IN t_op_std_logics
) IS
BEGIN
    init_reg(data_a0_a1_mul_2, '1', to_mat_size(64, 64), reg, "2 * a0", s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a, s_sel_c, s_opcode, s_wren, s_syn_rst, s_finished);
END init_mat_result_a0_add_a0;

PROCEDURE init_mat_result_a1_add_a1(
    reg : INTEGER; 
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word;
    SIGNAL s_sel_a : OUT t_mat_reg_ixs; SIGNAL s_sel_c : OUT t_mat_reg_ixs; SIGNAL s_opcode : OUT t_opcodes; SIGNAL s_wren : OUT STD_LOGIC; SIGNAL s_syn_rst : OUT STD_LOGIC; SIGNAL s_finished : IN t_op_std_logics
) IS
BEGIN
    init_reg(data_a0_a1_mul_2, '0', to_mat_size(64, 64), reg, "2 * a1", s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a, s_sel_c, s_opcode, s_wren, s_syn_rst, s_finished);
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
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word;
    SIGNAL s_sel_a : OUT t_mat_reg_ixs; SIGNAL s_sel_c : OUT t_mat_reg_ixs; SIGNAL s_opcode : OUT t_opcodes; SIGNAL s_wren : OUT STD_LOGIC; SIGNAL s_syn_rst : OUT STD_LOGIC; SIGNAL s_finished : IN t_op_std_logics
) IS
BEGIN 
    init_reg(data_a0_a1_trans, '1', to_mat_size(64, 64), reg, "trans(a0)", s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a, s_sel_c, s_opcode, s_wren, s_syn_rst, s_finished);
END init_mat_result_a0_trans;

PROCEDURE init_mat_result_a1_trans(
    reg : INTEGER; 
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word;
    SIGNAL s_sel_a : OUT t_mat_reg_ixs; SIGNAL s_sel_c : OUT t_mat_reg_ixs; SIGNAL s_opcode : OUT t_opcodes; SIGNAL s_wren : OUT STD_LOGIC; SIGNAL s_syn_rst : OUT STD_LOGIC; SIGNAL s_finished : IN t_op_std_logics
) IS
BEGIN
    init_reg(data_a0_a1_trans, '0', to_mat_size(64, 64), reg, "trans(a1)", s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a, s_sel_c, s_opcode, s_wren, s_syn_rst, s_finished);    
END init_mat_result_a1_trans;


PROCEDURE init_mat_result_a0_scalar_max(
    reg : INTEGER; 
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word;
    SIGNAL s_sel_a : OUT t_mat_reg_ixs; SIGNAL s_sel_c : OUT t_mat_reg_ixs; SIGNAL s_opcode : OUT t_opcodes; SIGNAL s_wren : OUT STD_LOGIC; SIGNAL s_syn_rst : OUT STD_LOGIC; SIGNAL s_finished : IN t_op_std_logics
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
    init_reg(data, '1', to_mat_size(64, 64), reg, "max(a0, 0)", s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a, s_sel_c, s_opcode, s_wren, s_syn_rst, s_finished);
END init_mat_result_a0_scalar_max;
    
PROCEDURE init_mat_a2_64x64_rbr(
    reg : INTEGER; 
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word;
    SIGNAL s_sel_a : OUT t_mat_reg_ixs; SIGNAL s_sel_c : OUT t_mat_reg_ixs; SIGNAL s_opcode : OUT t_opcodes; SIGNAL s_wren : OUT STD_LOGIC; SIGNAL s_syn_rst : OUT STD_LOGIC; SIGNAL s_finished : IN t_op_std_logics
) IS
VARIABLE data : t_mat_word_const_arr(0 To 127);
BEGIN
    FOR i IN data'RANGE LOOP
        data(i) := (OTHERS => 0.0);
    END LOOP;
    data(0) := (1.0, -4.0,           0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
    data(1) :=                      (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,          2.25, -3.9375);
    data(2) := (0.25, -8.0,          0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
    data(3) :=                      (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,          3.9375, 0.0);
    
    data(124) := (1.125, 0.625,     0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
    data(125) :=                    (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,          1.75, 7.9375);
    data(126) := (2.0, 6.0,         0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
    data(127) :=                    (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,          -8.0, 0.0);
    init_reg(data, '1', to_mat_size(64, 64), reg, "a2", s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a, s_sel_c, s_opcode, s_wren, s_syn_rst, s_finished);
END init_mat_a2_64x64_rbr;

PROCEDURE init_mat_result_a2_scalar_div(
    reg : INTEGER; 
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word;
    SIGNAL s_sel_a : OUT t_mat_reg_ixs; SIGNAL s_sel_c : OUT t_mat_reg_ixs; SIGNAL s_opcode : OUT t_opcodes; SIGNAL s_wren : OUT STD_LOGIC; SIGNAL s_syn_rst : OUT STD_LOGIC; SIGNAL s_finished : IN t_op_std_logics
) IS
VARIABLE data : t_mat_word_const_arr(0 To 127);
BEGIN
    FOR i IN data'RANGE LOOP
        data(i) := (OTHERS => 0.0);
    END LOOP;
    data(0) := (0.0, -0.0625,       0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
    data(1) :=                      (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,          0.0, -0.0625);
    data(2) := (0.0, -0.125,        0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
    data(3) :=                      (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,          0.0, 0.0);
    
    data(124) := (0.0, 0.0,         0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
    data(125) :=                    (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,          0.0, 0.0625);
    data(126) := (0.0, 0.0625,      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
    data(127) :=                    (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,          -0.125, 0.0);
    init_reg(data, '1', to_mat_size(64, 64), reg, "a2 / 64", s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a, s_sel_c, s_opcode, s_wren, s_syn_rst, s_finished);
END init_mat_result_a2_scalar_div;
    
PROCEDURE init_mat_a3_1x64_rbr(
    reg : INTEGER; 
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word;
    SIGNAL s_sel_a : OUT t_mat_reg_ixs; SIGNAL s_sel_c : OUT t_mat_reg_ixs; SIGNAL s_opcode : OUT t_opcodes; SIGNAL s_wren : OUT STD_LOGIC; SIGNAL s_syn_rst : OUT STD_LOGIC; SIGNAL s_finished : IN t_op_std_logics
) IS
VARIABLE data: t_mat_word_const_arr(0 TO 1);
BEGIN
    data := (
        (2.0, 0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0),
                    (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0625, -1.25)
    );
    init_reg(data, '1', to_mat_size(1, 64), reg, "Vector", s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a, s_sel_c, s_opcode, s_wren, s_syn_rst, s_finished);
END init_mat_a3_1x64_rbr;

PROCEDURE init_mat_result_a0_vec_add_a3(
    reg : INTEGER; 
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word;
    SIGNAL s_sel_a : OUT t_mat_reg_ixs; SIGNAL s_sel_c : OUT t_mat_reg_ixs; SIGNAL s_opcode : OUT t_opcodes; SIGNAL s_wren : OUT STD_LOGIC; SIGNAL s_syn_rst : OUT STD_LOGIC; SIGNAL s_finished : IN t_op_std_logics
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
    init_reg(data, '1', to_mat_size(64, 64), reg, "VecAdd(a0, a2)", s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a, s_sel_c, s_opcode, s_wren, s_syn_rst, s_finished);
END init_mat_result_a0_vec_add_a3;

PROCEDURE init_mat_result_a1_col_sum_rbr(
    reg : INTEGER; 
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word;
    SIGNAL s_sel_a : OUT t_mat_reg_ixs; SIGNAL s_sel_c : OUT t_mat_reg_ixs; SIGNAL s_opcode : OUT t_opcodes; SIGNAL s_wren : OUT STD_LOGIC; SIGNAL s_syn_rst : OUT STD_LOGIC; SIGNAL s_finished : IN t_op_std_logics
) IS
VARIABLE data : t_mat_word_const_arr(0 TO 1);
BEGIN
    data := (
        (2.25, 1.125, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0),
                    (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 4.0, 4.5)
    );
    init_reg(data, '1', to_mat_size(1, 64), reg, "ColSum(a0) Row-by-Row", s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a, s_sel_c, s_opcode, s_wren, s_syn_rst, s_finished);
END init_mat_result_a1_col_sum_rbr;

PROCEDURE init_mat_result_a1_col_sum_cbc(
    reg : INTEGER; 
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word;
    SIGNAL s_sel_a : OUT t_mat_reg_ixs; SIGNAL s_sel_c : OUT t_mat_reg_ixs; SIGNAL s_opcode : OUT t_opcodes; SIGNAL s_wren : OUT STD_LOGIC; SIGNAL s_syn_rst : OUT STD_LOGIC; SIGNAL s_finished : IN t_op_std_logics
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

    init_reg(data, '0', to_mat_size(1, 64), reg, "ColSum(a0) Col-by-Col", s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a, s_sel_c, s_opcode, s_wren, s_syn_rst, s_finished);
END init_mat_result_a1_col_sum_cbc;

PROCEDURE init_mat_result_a0_flip(
    reg : INTEGER; 
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word;
    SIGNAL s_sel_a : OUT t_mat_reg_ixs; SIGNAL s_sel_c : OUT t_mat_reg_ixs; SIGNAL s_opcode : OUT t_opcodes; SIGNAL s_wren : OUT STD_LOGIC; SIGNAL s_syn_rst : OUT STD_LOGIC; SIGNAL s_finished : IN t_op_std_logics
) IS
BEGIN 
    init_reg(data_a0_a1_trans, '0', to_mat_size(64, 64), reg, "flip(a0)", s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a, s_sel_c, s_opcode, s_wren, s_syn_rst, s_finished);
END init_mat_result_a0_flip;

PROCEDURE init_mat_result_a1_scalar_sub_ix_1(
    reg : INTEGER; 
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word;
    SIGNAL s_sel_a : OUT t_mat_reg_ixs; SIGNAL s_sel_c : OUT t_mat_reg_ixs; SIGNAL s_opcode : OUT t_opcodes; SIGNAL s_wren : OUT STD_LOGIC; SIGNAL s_syn_rst : OUT STD_LOGIC; SIGNAL s_finished : IN t_op_std_logics
) IS
VARIABLE data : t_mat_word_const_arr(0 TO 127);
BEGIN
    FOR i IN data'RANGE LOOP
        IF i mod 2 = 0 THEN
            data(i) := (0.0, -1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
        ELSE
            data(i) := (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
        END IF;
    END LOOP;
    data(0) := (1.0, -1.25,         0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
    data(1) :=                      (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,          2.25, -0.75);
    data(2) := (0.25, -1.5,         0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
    data(3) :=                      (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,          1.5, -0.125);
    
    data(124) := (1.125, -0.375,     0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
    data(125) :=                    (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,          1.75, 0.5);
    data(126) := (2.0, 0.0,         0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
    data(127) :=                    (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,          2.25, -0.75);

    init_reg(data, '0', to_mat_size(64, 64), reg, "ScalarSubIx(a1, 1)", s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a, s_sel_c, s_opcode, s_wren, s_syn_rst, s_finished);
END init_mat_result_a1_scalar_sub_ix_1;

END PACKAGE BODY;