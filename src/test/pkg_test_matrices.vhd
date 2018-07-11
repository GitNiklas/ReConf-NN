LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.pkg_tools.ALL;
USE work.pkg_test.ALL;
USE work.fixed_pkg.ALL;
    
PACKAGE pkg_test_matrices IS  

PROCEDURE init_mat_2x3_rbr(
    reg : INTEGER; 
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word;
    SIGNAL s_sel_a : OUT t_mat_reg_ixs; SIGNAL s_sel_c : OUT t_mat_reg_ixs; SIGNAL s_opcode : OUT t_opcodes; SIGNAL s_wren : OUT STD_LOGIC; SIGNAL s_syn_rst : OUT STD_LOGIC; SIGNAL s_finished : IN STD_LOGIC
);

PROCEDURE init_mat_3x3_cbc(
    reg : INTEGER; 
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word;
    SIGNAL s_sel_a : OUT t_mat_reg_ixs; SIGNAL s_sel_c : OUT t_mat_reg_ixs; SIGNAL s_opcode : OUT t_opcodes; SIGNAL s_wren : OUT STD_LOGIC; SIGNAL s_syn_rst : OUT STD_LOGIC; SIGNAL s_finished : IN STD_LOGIC
);

PROCEDURE init_mat_result_2x3_mul_3x3_rbr(
    reg : INTEGER; 
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word;
    SIGNAL s_sel_a : OUT t_mat_reg_ixs; SIGNAL s_sel_c : OUT t_mat_reg_ixs; SIGNAL s_opcode : OUT t_opcodes; SIGNAL s_wren : OUT STD_LOGIC; SIGNAL s_syn_rst : OUT STD_LOGIC; SIGNAL s_finished : IN STD_LOGIC
);

PROCEDURE init_mat_2x36_rbr(
    reg : INTEGER;
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word;
    SIGNAL s_sel_a : OUT t_mat_reg_ixs; SIGNAL s_sel_c : OUT t_mat_reg_ixs; SIGNAL s_opcode : OUT t_opcodes; SIGNAL s_wren : OUT STD_LOGIC; SIGNAL s_syn_rst : OUT STD_LOGIC; SIGNAL s_finished : IN STD_LOGIC
);

PROCEDURE init_mat_36x3_cbc(
    reg : INTEGER; 
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word;
    SIGNAL s_sel_a : OUT t_mat_reg_ixs; SIGNAL s_sel_c : OUT t_mat_reg_ixs; SIGNAL s_opcode : OUT t_opcodes; SIGNAL s_wren : OUT STD_LOGIC; SIGNAL s_syn_rst : OUT STD_LOGIC; SIGNAL s_finished : IN STD_LOGIC
);

PROCEDURE init_mat_result_2x36_mul_36x3_rbr(
    reg : INTEGER; 
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word;
    SIGNAL s_sel_a : OUT t_mat_reg_ixs; SIGNAL s_sel_c : OUT t_mat_reg_ixs; SIGNAL s_opcode : OUT t_opcodes; SIGNAL s_wren : OUT STD_LOGIC; SIGNAL s_syn_rst : OUT STD_LOGIC; SIGNAL s_finished : IN STD_LOGIC
);

PROCEDURE init_mat_36x1_rbr(
    reg : INTEGER; 
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word;
    SIGNAL s_sel_a : OUT t_mat_reg_ixs; SIGNAL s_sel_c : OUT t_mat_reg_ixs; SIGNAL s_opcode : OUT t_opcodes; SIGNAL s_wren : OUT STD_LOGIC; SIGNAL s_syn_rst : OUT STD_LOGIC; SIGNAL s_finished : IN STD_LOGIC
);

PROCEDURE init_mat_1x2_cbc(
    reg : INTEGER; 
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word;
    SIGNAL s_sel_a : OUT t_mat_reg_ixs; SIGNAL s_sel_c : OUT t_mat_reg_ixs; SIGNAL s_opcode : OUT t_opcodes; SIGNAL s_wren : OUT STD_LOGIC; SIGNAL s_syn_rst : OUT STD_LOGIC; SIGNAL s_finished : IN STD_LOGIC
);

PROCEDURE init_mat_result_36x1_mul_1x2_cbc(
    reg : INTEGER; 
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word;
    SIGNAL s_sel_a : OUT t_mat_reg_ixs; SIGNAL s_sel_c : OUT t_mat_reg_ixs; SIGNAL s_opcode : OUT t_opcodes; SIGNAL s_wren : OUT STD_LOGIC; SIGNAL s_syn_rst : OUT STD_LOGIC; SIGNAL s_finished : IN STD_LOGIC
);

PROCEDURE init_mat_a0_64x64_rbr(
    reg : INTEGER; 
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word;
    SIGNAL s_sel_a : OUT t_mat_reg_ixs; SIGNAL s_sel_c : OUT t_mat_reg_ixs; SIGNAL s_opcode : OUT t_opcodes; SIGNAL s_wren : OUT STD_LOGIC; SIGNAL s_syn_rst : OUT STD_LOGIC; SIGNAL s_finished : IN STD_LOGIC
);

PROCEDURE init_mat_a1_64x64_cbc(
    reg : INTEGER; 
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word;
    SIGNAL s_sel_a : OUT t_mat_reg_ixs; SIGNAL s_sel_c : OUT t_mat_reg_ixs; SIGNAL s_opcode : OUT t_opcodes; SIGNAL s_wren : OUT STD_LOGIC; SIGNAL s_syn_rst : OUT STD_LOGIC; SIGNAL s_finished : IN STD_LOGIC
);

PROCEDURE init_mat_result_a0_add_a0(
    reg : INTEGER; 
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word;
    SIGNAL s_sel_a : OUT t_mat_reg_ixs; SIGNAL s_sel_c : OUT t_mat_reg_ixs; SIGNAL s_opcode : OUT t_opcodes; SIGNAL s_wren : OUT STD_LOGIC; SIGNAL s_syn_rst : OUT STD_LOGIC; SIGNAL s_finished : IN STD_LOGIC
);

PROCEDURE init_mat_result_a1_add_a1(
    reg : INTEGER; 
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word;
    SIGNAL s_sel_a : OUT t_mat_reg_ixs; SIGNAL s_sel_c : OUT t_mat_reg_ixs; SIGNAL s_opcode : OUT t_opcodes; SIGNAL s_wren : OUT STD_LOGIC; SIGNAL s_syn_rst : OUT STD_LOGIC; SIGNAL s_finished : IN STD_LOGIC
);

PROCEDURE init_mat_result_a0_trans(
    reg : INTEGER; 
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word;
    SIGNAL s_sel_a : OUT t_mat_reg_ixs; SIGNAL s_sel_c : OUT t_mat_reg_ixs; SIGNAL s_opcode : OUT t_opcodes; SIGNAL s_wren : OUT STD_LOGIC; SIGNAL s_syn_rst : OUT STD_LOGIC; SIGNAL s_finished : IN STD_LOGIC
);

PROCEDURE init_mat_result_a1_trans(
    reg : INTEGER;  
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word;
    SIGNAL s_sel_a : OUT t_mat_reg_ixs; SIGNAL s_sel_c : OUT t_mat_reg_ixs; SIGNAL s_opcode : OUT t_opcodes; SIGNAL s_wren : OUT STD_LOGIC; SIGNAL s_syn_rst : OUT STD_LOGIC; SIGNAL s_finished : IN STD_LOGIC
);

PROCEDURE init_mat_result_a0_scalar_max(
    reg : INTEGER; 
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word;
    SIGNAL s_sel_a : OUT t_mat_reg_ixs; SIGNAL s_sel_c : OUT t_mat_reg_ixs; SIGNAL s_opcode : OUT t_opcodes; SIGNAL s_wren : OUT STD_LOGIC; SIGNAL s_syn_rst : OUT STD_LOGIC; SIGNAL s_finished : IN STD_LOGIC
);

END;

PACKAGE BODY pkg_test_matrices IS

PROCEDURE init_mat_2x3_rbr(
    reg : INTEGER; 
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word;
    SIGNAL s_sel_a : OUT t_mat_reg_ixs; SIGNAL s_sel_c : OUT t_mat_reg_ixs; SIGNAL s_opcode : OUT t_opcodes; SIGNAL s_wren : OUT STD_LOGIC; SIGNAL s_syn_rst : OUT STD_LOGIC; SIGNAL s_finished : IN STD_LOGIC
) IS
BEGIN
    delete_reg(reg, s_sel_c, s_opcode, s_wren, s_syn_rst, s_finished);
    REPORT infomsg("Register " & INTEGER'IMAGE(reg) & " = 2x3 Matrix [Zeilenweise]");
    -- {{0.125, 0.25, 0.625}, {-0.25, -0.3125, -0.875}}
    --
    -- 0.125    0.25        0.625       | 0000.0010     0000.0100       0000.1010
    -- -0.25   -0.3125     -0.875       | 1111.1100     1111.1011       1111.0010
    s_sel_a(0) <= to_mat_reg_ix(reg); 
    s_write_a0 <= '1';
    s_size_a0_i <= to_mat_size(2, 3);
    s_row_by_row_a0_i <= '1';
    
    s_ix_a0 <= to_mat_ix(0, 0); -- Es koennen die Spalten 0-31 gleichzeitig geschrieben werden
    s_data_a0_i <= to_mat_word((0.125, 0.25, 0.625, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    
    s_ix_a0 <= to_mat_ix(1, 0);
    s_data_a0_i <= to_mat_word((-0.25, -0.3125, -0.875, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_write_a0 <= '0';
    WAIT FOR c_clk_per;
    REPORT infomsg("Register " & INTEGER'IMAGE(reg) & " fertig initialisiert");
END init_mat_2x3_rbr;

PROCEDURE init_mat_3x3_cbc(
    reg : INTEGER; 
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word;
    SIGNAL s_sel_a : OUT t_mat_reg_ixs; SIGNAL s_sel_c : OUT t_mat_reg_ixs; SIGNAL s_opcode : OUT t_opcodes; SIGNAL s_wren : OUT STD_LOGIC; SIGNAL s_syn_rst : OUT STD_LOGIC; SIGNAL s_finished : IN STD_LOGIC
) IS
BEGIN
    delete_reg(reg, s_sel_c, s_opcode, s_wren, s_syn_rst, s_finished);
    REPORT infomsg("Register " & INTEGER'IMAGE(reg) & " = 3x3 Matrix [Spaltenweise]");
    -- {{1, 1, 2.5}, {2, 3, -4}, {1, -2, -3}}
    --
    -- 1   1  2.5       | 0001.0000     0001.0000       0010.1000
    -- 2   3   -4       | 0010.0000     0011.0000       1100.0000
    -- 1  -2   -3       | 0001.0000     1110.0000       1101.0000
    s_sel_a(0) <= to_mat_reg_ix(reg); 
    s_write_a0 <= '1';
    s_size_a0_i <= to_mat_size(3, 3);
    s_row_by_row_a0_i <= '0';

    s_ix_a0 <= to_mat_ix(0, 0);
    s_data_a0_i <= to_mat_word((1.0, 2.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;

    s_ix_a0 <= to_mat_ix(0, 1);
    s_data_a0_i <= to_mat_word((1.0, 3.0, -2.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;

    s_ix_a0 <= to_mat_ix(0, 2);
    s_data_a0_i <= to_mat_word((2.5, -4.0, -3.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;  
    s_write_a0 <= '0';
    REPORT infomsg("Register " & INTEGER'IMAGE(reg) & " fertig initialisiert");
END init_mat_3x3_cbc;

PROCEDURE init_mat_result_2x3_mul_3x3_rbr(
    reg : INTEGER; 
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word;
    SIGNAL s_sel_a : OUT t_mat_reg_ixs; SIGNAL s_sel_c : OUT t_mat_reg_ixs; SIGNAL s_opcode : OUT t_opcodes; SIGNAL s_wren : OUT STD_LOGIC; SIGNAL s_syn_rst : OUT STD_LOGIC; SIGNAL s_finished : IN STD_LOGIC
) IS
BEGIN
    delete_reg(reg, s_sel_c, s_opcode, s_wren, s_syn_rst, s_finished);
    REPORT infomsg("Register " & INTEGER'IMAGE(reg) & " = 2x3 (Ergebnis 2x3 * 3x3) [Zeilenweise]");
    s_sel_a(0) <= to_mat_reg_ix(reg); 
    s_write_a0 <= '1';
    s_size_a0_i <= to_mat_size(2, 3);
    s_row_by_row_a0_i <= '1';
    
    s_ix_a0 <= to_mat_ix(0, 0);
    s_data_a0_i <= to_mat_word((1.25, -0.375, -2.5625, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;

    s_ix_a0 <= to_mat_ix(1, 0);
    s_data_a0_i <= to_mat_word((-1.75, 0.5625, 3.25, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_write_a0 <= '0';
    REPORT infomsg("Register " & INTEGER'IMAGE(reg) & " fertig initialisiert");
END init_mat_result_2x3_mul_3x3_rbr;

PROCEDURE init_mat_2x36_rbr(
    reg : INTEGER; 
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word;
    SIGNAL s_sel_a : OUT t_mat_reg_ixs; SIGNAL s_sel_c : OUT t_mat_reg_ixs; SIGNAL s_opcode : OUT t_opcodes; SIGNAL s_wren : OUT STD_LOGIC; SIGNAL s_syn_rst : OUT STD_LOGIC; SIGNAL s_finished : IN STD_LOGIC
) IS
BEGIN
    delete_reg(reg, s_sel_c, s_opcode, s_wren, s_syn_rst, s_finished);
    REPORT infomsg("Register " & INTEGER'IMAGE(reg) & " = 2x36 Matrix [Zeilenweise]");
    -- [0.25, 0.25, 1.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 2.0, 0.5, 2.0]
    -- [-0.25, -0.35, -0.875, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.5, 0.5, 0.25]    
    s_sel_a(0) <= to_mat_reg_ix(reg); 
    s_write_a0 <= '1';
    s_size_a0_i <= to_mat_size(2, 36);
    s_row_by_row_a0_i <= '1';
    
    s_ix_a0 <= to_mat_ix(0, 0); -- Es koennen die Spalten 0-31 gleichzeitig geschrieben werden
    s_data_a0_i <= to_mat_word((0.25, 0.25, 1.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    
    s_ix_a0 <= to_mat_ix(0, 32);
    s_data_a0_i <= to_mat_word((1.0, 2.0, 0.5, 2.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    
    s_ix_a0 <= to_mat_ix(1, 0);
    s_data_a0_i <= to_mat_word((-0.25, -0.35, -0.875, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    
    s_ix_a0 <= to_mat_ix(1, 32);
    s_data_a0_i <= to_mat_word((1.0, 1.5, 0.5, 0.25, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_write_a0 <= '0';
    REPORT infomsg("Register " & INTEGER'IMAGE(reg) & " fertig initialisiert");
END init_mat_2x36_rbr;

PROCEDURE init_mat_36x3_cbc(
    reg : INTEGER; 
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word;
    SIGNAL s_sel_a : OUT t_mat_reg_ixs; SIGNAL s_sel_c : OUT t_mat_reg_ixs; SIGNAL s_opcode : OUT t_opcodes; SIGNAL s_wren : OUT STD_LOGIC; SIGNAL s_syn_rst : OUT STD_LOGIC; SIGNAL s_finished : IN STD_LOGIC
) IS
BEGIN
    delete_reg(reg, s_sel_c, s_opcode, s_wren, s_syn_rst, s_finished);
    REPORT infomsg("Register " & INTEGER'IMAGE(reg) & " = 36x3 Matrix [Spaltenweise]");
    -- [1, 1, 2.0],[2, 3, -4],[1, -2, -3],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.5, 0.5, 0.5],[0.5, 0.5, 2.0],[0.5, 1.0, 0.5],[0.5, 1.5, 1.0]
    s_sel_a(0) <= to_mat_reg_ix(reg); 
    s_write_a0 <= '1';
    s_size_a0_i <= to_mat_size(36, 3);
    s_row_by_row_a0_i <= '0';

    s_ix_a0 <= to_mat_ix(0, 0);
    s_data_a0_i <= to_mat_word((1.0, 2.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    
    s_ix_a0 <= to_mat_ix(32, 0);
    s_data_a0_i <= to_mat_word((0.5, 0.5, 0.5, 0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    
    s_ix_a0 <= to_mat_ix(0, 1);
    s_data_a0_i <= to_mat_word((1.0, 3.0, -2.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_ix_a0 <= to_mat_ix(32, 1);
    s_data_a0_i <= to_mat_word((0.5, 0.5, 1.0, 1.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    
    s_ix_a0 <= to_mat_ix(0, 2);
    s_data_a0_i <= to_mat_word((2.0, -4.0, -3.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                               0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per; 
    s_ix_a0 <= to_mat_ix(32, 2);
    s_data_a0_i <= to_mat_word((0.5, 2.0, 0.5, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                               0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per; 
    s_write_a0 <= '0';
    REPORT infomsg("Register " & INTEGER'IMAGE(reg) & " fertig initialisiert");
END init_mat_36x3_cbc;

PROCEDURE init_mat_result_2x36_mul_36x3_rbr(
    reg : INTEGER; 
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word;
    SIGNAL s_sel_a : OUT t_mat_reg_ixs; SIGNAL s_sel_c : OUT t_mat_reg_ixs; SIGNAL s_opcode : OUT t_opcodes; SIGNAL s_wren : OUT STD_LOGIC; SIGNAL s_syn_rst : OUT STD_LOGIC; SIGNAL s_finished : IN STD_LOGIC
) IS
BEGIN
    delete_reg(reg, s_sel_c, s_opcode, s_wren, s_syn_rst, s_finished);
    REPORT infomsg("Register " & INTEGER'IMAGE(reg) & " = 2x3 (Ergebnis 2x36 * 36x3) [Zeilenweise]");
    -- 5.0      3.0     1.75
    -- -0.2     2.575   7.525 -- erzeugt rundungsfehler!
    s_sel_a(0) <= to_mat_reg_ix(reg); 
    s_write_a0 <= '1';
    s_size_a0_i <= to_mat_size(2, 3);
    s_row_by_row_a0_i <= '1';
    
    s_ix_a0 <= to_mat_ix(0, 0);
    s_data_a0_i <= to_mat_word((5.0, 3.0, 1.75, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                               0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    
    s_ix_a0 <= to_mat_ix(1, 0);
    s_data_a0_i <= to_mat_word((-0.25, 2.5, 7.625, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                               0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_write_a0 <= '0';
    REPORT infomsg("Register " & INTEGER'IMAGE(reg) & " fertig initialisiert");
END init_mat_result_2x36_mul_36x3_rbr;

PROCEDURE init_mat_36x1_rbr(
    reg : INTEGER; 
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word;
    SIGNAL s_sel_a : OUT t_mat_reg_ixs; SIGNAL s_sel_c : OUT t_mat_reg_ixs; SIGNAL s_opcode : OUT t_opcodes; SIGNAL s_wren : OUT STD_LOGIC; SIGNAL s_syn_rst : OUT STD_LOGIC; SIGNAL s_finished : IN STD_LOGIC
) IS
BEGIN
    delete_reg(reg, s_sel_c, s_opcode, s_wren, s_syn_rst, s_finished);
    REPORT infomsg("Register " & INTEGER'IMAGE(reg) & " = 36x1 Matrix [Zeilenweise]");
   -- [0.25], [0.125], [0.0], [1.0], [0.125], [0.5], [1.0], [2.0], [0.0625], [0.5], [0.125], [1.0], [0.625], [0.875], [2.0], [0.5], [0.5625], [0.3125], [0.25], [0.125], [0.0], [1.0], [0.125], [0.5], [1.0], [2.0], [0.0625], [0.5], [0.125], [1.0], [0.625], [0.875], [2.0], [0.5], [0.5625], [0.3125]  
    s_sel_a(0) <= to_mat_reg_ix(reg); 
    s_write_a0 <= '1';
    s_size_a0_i <= to_mat_size(36, 1);
    s_row_by_row_a0_i <= '1';
    
    s_ix_a0 <= to_mat_ix(0, 0);
    s_data_a0_i <= to_mat_word((0.25, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_ix_a0 <= to_mat_ix(1, 0);   
    s_data_a0_i <= to_mat_word((0.125, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_ix_a0 <= to_mat_ix(2, 0);  
    s_data_a0_i <= to_mat_word((0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_ix_a0 <= to_mat_ix(3, 0);  
    s_data_a0_i <= to_mat_word((1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_ix_a0 <= to_mat_ix(4, 0); 
    s_data_a0_i <= to_mat_word((0.125, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_ix_a0 <= to_mat_ix(5, 0);  
    s_data_a0_i <= to_mat_word((0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_ix_a0 <= to_mat_ix(6, 0);  
    s_data_a0_i <= to_mat_word((1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_ix_a0 <= to_mat_ix(7, 0); 
    s_data_a0_i <= to_mat_word((2.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_ix_a0 <= to_mat_ix(8, 0);   
    s_data_a0_i <= to_mat_word((0.0625, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_ix_a0 <= to_mat_ix(9, 0);   
    s_data_a0_i <= to_mat_word((0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_ix_a0 <= to_mat_ix(10, 0);   
    s_data_a0_i <= to_mat_word((0.125, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_ix_a0 <= to_mat_ix(11, 0);   
    s_data_a0_i <= to_mat_word((1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_ix_a0 <= to_mat_ix(12, 0);   
    s_data_a0_i <= to_mat_word((0.625, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_ix_a0 <= to_mat_ix(13, 0);   
    s_data_a0_i <= to_mat_word((0.875, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_ix_a0 <= to_mat_ix(14, 0);   
    s_data_a0_i <= to_mat_word((2.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_ix_a0 <= to_mat_ix(15, 0);   
    s_data_a0_i <= to_mat_word((0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_ix_a0 <= to_mat_ix(16, 0);   
    s_data_a0_i <= to_mat_word((0.5625, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_ix_a0 <= to_mat_ix(17, 0);   
    s_data_a0_i <= to_mat_word((0.3125, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_ix_a0 <= to_mat_ix(18, 0);   
    s_data_a0_i <= to_mat_word((0.25, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_ix_a0 <= to_mat_ix(19, 0);   
    s_data_a0_i <= to_mat_word((0.125, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_ix_a0 <= to_mat_ix(20, 0);   
    s_data_a0_i <= to_mat_word((0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_ix_a0 <= to_mat_ix(21, 0);   
    s_data_a0_i <= to_mat_word((1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_ix_a0 <= to_mat_ix(22, 0);   
    s_data_a0_i <= to_mat_word((0.125, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_ix_a0 <= to_mat_ix(23, 0);   
    s_data_a0_i <= to_mat_word((0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_ix_a0 <= to_mat_ix(24, 0);   
    s_data_a0_i <= to_mat_word((1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_ix_a0 <= to_mat_ix(25, 0);   
    s_data_a0_i <= to_mat_word((2.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_ix_a0 <= to_mat_ix(26, 0);   
    s_data_a0_i <= to_mat_word((0.0625, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_ix_a0 <= to_mat_ix(27, 0);   
    s_data_a0_i <= to_mat_word((0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_ix_a0 <= to_mat_ix(28, 0);   
    s_data_a0_i <= to_mat_word((0.125, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_ix_a0 <= to_mat_ix(29, 0);   
    s_data_a0_i <= to_mat_word((1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_ix_a0 <= to_mat_ix(30, 0);   
    s_data_a0_i <= to_mat_word((0.625, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_ix_a0 <= to_mat_ix(31, 0);   
    s_data_a0_i <= to_mat_word((0.875, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_ix_a0 <= to_mat_ix(32, 0);   
    s_data_a0_i <= to_mat_word((2.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_ix_a0 <= to_mat_ix(33, 0);   
    s_data_a0_i <= to_mat_word((0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_ix_a0 <= to_mat_ix(34, 0);   
    s_data_a0_i <= to_mat_word((0.5625, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_ix_a0 <= to_mat_ix(35, 0);   
    s_data_a0_i <= to_mat_word((0.3125, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_write_a0 <= '0';
    REPORT infomsg("Register " & INTEGER'IMAGE(reg) & " fertig initialisiert");
END init_mat_36x1_rbr;

PROCEDURE init_mat_1x2_cbc(
    reg : INTEGER; 
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word;
    SIGNAL s_sel_a : OUT t_mat_reg_ixs; SIGNAL s_sel_c : OUT t_mat_reg_ixs; SIGNAL s_opcode : OUT t_opcodes; SIGNAL s_wren : OUT STD_LOGIC; SIGNAL s_syn_rst : OUT STD_LOGIC; SIGNAL s_finished : IN STD_LOGIC
) IS
BEGIN
    delete_reg(reg, s_sel_c, s_opcode, s_wren, s_syn_rst, s_finished);
    REPORT infomsg("Register " & INTEGER'IMAGE(reg) & " = 1x2 Matrix [Spaltenweise]");
    -- [2, 1]
    s_sel_a(0) <= to_mat_reg_ix(reg); 
    s_write_a0 <= '1';
    s_size_a0_i <= to_mat_size(1, 2);
    s_row_by_row_a0_i <= '0';

    s_ix_a0 <= to_mat_ix(0, 0);
    s_data_a0_i <= to_mat_word((2.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    
    s_ix_a0 <= to_mat_ix(0, 1);
    s_data_a0_i <= to_mat_word((1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_write_a0 <= '0';
    REPORT infomsg("Register " & INTEGER'IMAGE(reg) & " fertig initialisiert");
END init_mat_1x2_cbc;

PROCEDURE init_mat_result_36x1_mul_1x2_cbc(
    reg : INTEGER; 
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word;
    SIGNAL s_sel_a : OUT t_mat_reg_ixs; SIGNAL s_sel_c : OUT t_mat_reg_ixs; SIGNAL s_opcode : OUT t_opcodes; SIGNAL s_wren : OUT STD_LOGIC; SIGNAL s_syn_rst : OUT STD_LOGIC; SIGNAL s_finished : IN STD_LOGIC
) IS
BEGIN
    delete_reg(reg, s_sel_c, s_opcode, s_wren, s_syn_rst, s_finished);
    REPORT infomsg("Register " & INTEGER'IMAGE(reg) & " = 36x2 (Ergebnis 36x1 * 1x2) [Spaltenweise]");
    -- [0.5], [0.25], [0.0], [2.0], [0.25], [1.0], [2.0], [4.0], [0.125], [1.0], [0.25], [2.0], [1.25], [1.75], [4.0], [1.0], [1.125], [0.625], [0.5], [0.25], [0.0], [2.0], [0.25], [1.0], [2.0], [4.0], [0.125], [1.0], [0.25], [2.0], [1.25], [1.75], [4.0], [1.0], [1.125], [0.625]
    -- [0.25], [0.125], [0.0], [1.0], [0.125], [0.5], [1.0], [2.0], [0.0625], [0.5], [0.125], [1.0], [0.625], [0.875], [2.0], [0.5], [0.5625], [0.3125], [0.25], [0.125], [0.0], [1.0], [0.125], [0.5], [1.0], [2.0], [0.0625], [0.5], [0.125], [1.0], [0.625], [0.875], [2.0], [0.5], [0.5625], [0.3125]
    s_sel_a(0) <= to_mat_reg_ix(reg); 
    s_write_a0 <= '1';
    s_size_a0_i <= to_mat_size(36, 2);
    s_row_by_row_a0_i <= '0';
    
    s_ix_a0 <= to_mat_ix(0, 0);
    s_data_a0_i <= to_mat_word(( 0.5, 0.25, 0.0, 2.0, 0.25, 1.0, 2.0, 4.0, 0.125, 1.0, 0.25, 2.0, 1.25, 1.75, 4.0, 1.0,  1.125, 0.625, 0.5, 0.25, 0.0, 2.0, 0.25, 1.0, 2.0, 4.0, 0.125, 1.0, 0.25, 2.0, 1.25, 1.75));
    WAIT FOR c_clk_per;
    
    s_ix_a0 <= to_mat_ix(32, 0);
    s_data_a0_i <= to_mat_word((4.0, 1.0, 1.125, 0.625, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    
    s_ix_a0 <= to_mat_ix(0, 1);
    s_data_a0_i <= to_mat_word(( 0.25, 0.125, 0.0, 1.0, 0.125, 0.5, 1.0, 2.0, 0.0625, 0.5, 0.125, 1.0, 0.625, 0.875, 2.0, 0.5,  0.5625, 0.3125, 0.25, 0.125, 0.0, 1.0, 0.125, 0.5, 1.0, 2.0, 0.0625, 0.5, 0.125, 1.0, 0.625, 0.875));
    WAIT FOR c_clk_per;
    
    s_ix_a0 <= to_mat_ix(32, 1);
    s_data_a0_i <= to_mat_word((2.0, 0.5, 0.5625, 0.3125, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_write_a0 <= '0';
    REPORT infomsg("Register " & INTEGER'IMAGE(reg) & " fertig initialisiert");
END init_mat_result_36x1_mul_1x2_cbc;

PROCEDURE init_mat_a0_64x64_rbr(
    reg : INTEGER; 
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word;
    SIGNAL s_sel_a : OUT t_mat_reg_ixs; SIGNAL s_sel_c : OUT t_mat_reg_ixs; SIGNAL s_opcode : OUT t_opcodes; SIGNAL s_wren : OUT STD_LOGIC; SIGNAL s_syn_rst : OUT STD_LOGIC; SIGNAL s_finished : IN STD_LOGIC
) IS
BEGIN
    delete_reg(reg, s_sel_c, s_opcode, s_wren, s_syn_rst, s_finished);
    REPORT infomsg("Register " & INTEGER'IMAGE(reg) & " = 64x64 Matrix [Zeilenweise]");
    -- [1.0, -0.25, ..., 2.25, -0.75]
    -- [0.25, -0.5, ..., 1.5, -0.125]
    -- ...
    -- [1.125, 0.625, ..., 1.75, 0.5]
    -- [2.0, 1.0, ..., 2.25, -0.75]
    s_sel_a(0) <= to_mat_reg_ix(reg); 
    s_write_a0 <= '1';
    s_size_a0_i <= to_mat_size(64, 64);
    s_row_by_row_a0_i <= '1';

    s_ix_a0 <= to_mat_ix(0, 0);
    s_data_a0_i <= to_mat_word((1.0, -0.25, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    
    s_ix_a0 <= to_mat_ix(0, 32);
    s_data_a0_i <= to_mat_word((0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.25, -0.75));
    WAIT FOR c_clk_per;
    
    s_ix_a0 <= to_mat_ix(1, 0);
    s_data_a0_i <= to_mat_word((0.25, -0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    
    s_ix_a0 <= to_mat_ix(1, 32);
    s_data_a0_i <= to_mat_word((0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, -0.125));
    WAIT FOR c_clk_per;
    
    FOR i in 2 TO 61 LOOP
        s_ix_a0 <= to_mat_ix(i, 0);
        s_data_a0_i <= to_mat_word((0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
        WAIT FOR c_clk_per;
    
        s_ix_a0 <= to_mat_ix(i, 32);
        s_data_a0_i <= to_mat_word((0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
        WAIT FOR c_clk_per;
    END LOOP;
    
    s_ix_a0 <= to_mat_ix(62, 0);
    s_data_a0_i <= to_mat_word((1.125, 0.625, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    
    s_ix_a0 <= to_mat_ix(62, 32);
    s_data_a0_i <= to_mat_word((0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.75, 0.5));
    WAIT FOR c_clk_per;
    
    s_ix_a0 <= to_mat_ix(63, 0);
    s_data_a0_i <= to_mat_word((2.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    
    s_ix_a0 <= to_mat_ix(63, 32);
    s_data_a0_i <= to_mat_word((0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.25, -0.75));
    WAIT FOR c_clk_per;
    s_write_a0 <= '0';
    REPORT infomsg("Register " & INTEGER'IMAGE(reg) & " fertig initialisiert");
END init_mat_a0_64x64_rbr;

PROCEDURE init_mat_a1_64x64_cbc(
    reg : INTEGER; 
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word;
    SIGNAL s_sel_a : OUT t_mat_reg_ixs; SIGNAL s_sel_c : OUT t_mat_reg_ixs; SIGNAL s_opcode : OUT t_opcodes; SIGNAL s_wren : OUT STD_LOGIC; SIGNAL s_syn_rst : OUT STD_LOGIC; SIGNAL s_finished : IN STD_LOGIC
) IS
BEGIN
    delete_reg(reg, s_sel_c, s_opcode, s_wren, s_syn_rst, s_finished);
    REPORT infomsg("Register " & INTEGER'IMAGE(reg) & " = 64x64 Matrix [Spaltenweise]");
    -- [1.0, 0.25, ..., 1.125, 2.0]
    -- [-0.25, -0.5, ..., 0.625, 1.0]
    -- ...
    -- [2.25, 1.5, ..., 1.75, 2.25]
    -- [-0.75, -0.125, ..., 0.5, -0.75] 
    s_sel_a(0) <= to_mat_reg_ix(reg); 
    s_write_a0 <= '1';
    s_size_a0_i <= to_mat_size(64, 64);
    s_row_by_row_a0_i <= '0';

    s_ix_a0 <= to_mat_ix(0, 0);
    s_data_a0_i <= to_mat_word((1.0, -0.25, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    
    s_ix_a0 <= to_mat_ix(32, 0);
    s_data_a0_i <= to_mat_word((0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.25, -0.75));
    WAIT FOR c_clk_per;
    
    s_ix_a0 <= to_mat_ix(0, 1);
    s_data_a0_i <= to_mat_word((0.25, -0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    
    s_ix_a0 <= to_mat_ix(32, 1);
    s_data_a0_i <= to_mat_word((0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, -0.125));
    WAIT FOR c_clk_per;
    
    FOR i in 2 TO 61 LOOP
        s_ix_a0 <= to_mat_ix(0, i);
        s_data_a0_i <= to_mat_word((0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
        WAIT FOR c_clk_per;
    
        s_ix_a0 <= to_mat_ix(32, i);
        s_data_a0_i <= to_mat_word((0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
        WAIT FOR c_clk_per;
    END LOOP;
    
    s_ix_a0 <= to_mat_ix(0, 62);
    s_data_a0_i <= to_mat_word((1.125, 0.625, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    
    s_ix_a0 <= to_mat_ix(32, 62);
    s_data_a0_i <= to_mat_word((0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.75, 0.5));
    WAIT FOR c_clk_per;
    
    s_ix_a0 <= to_mat_ix(0, 63);
    s_data_a0_i <= to_mat_word((2.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    
    s_ix_a0 <= to_mat_ix(32, 63);
    s_data_a0_i <= to_mat_word((0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.25, -0.75));
    WAIT FOR c_clk_per;
    s_write_a0 <= '0';
    REPORT infomsg("Register " & INTEGER'IMAGE(reg) & " fertig initialisiert");
END init_mat_a1_64x64_cbc;

PROCEDURE init_mat_result_a0_add_a0(
    reg : INTEGER; 
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word;
    SIGNAL s_sel_a : OUT t_mat_reg_ixs; SIGNAL s_sel_c : OUT t_mat_reg_ixs; SIGNAL s_opcode : OUT t_opcodes; SIGNAL s_wren : OUT STD_LOGIC; SIGNAL s_syn_rst : OUT STD_LOGIC; SIGNAL s_finished : IN STD_LOGIC
) IS
BEGIN
    delete_reg(reg, s_sel_c, s_opcode, s_wren, s_syn_rst, s_finished);
    REPORT infomsg("Register " & INTEGER'IMAGE(reg) & " = 64x64 (Ergebnis a0 + a0) [Zeilenweise]");
    s_sel_a(0) <= to_mat_reg_ix(reg); 
    s_write_a0 <= '1';
    s_size_a0_i <= to_mat_size(64, 64);
    s_row_by_row_a0_i <= '1';

    s_ix_a0 <= to_mat_ix(0, 0);
    s_data_a0_i <= to_mat_word((2.0, -0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    
    s_ix_a0 <= to_mat_ix(0, 32);
    s_data_a0_i <= to_mat_word((0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 4.5, -1.5));
    WAIT FOR c_clk_per;
    
    s_ix_a0 <= to_mat_ix(1, 0);
    s_data_a0_i <= to_mat_word((0.5, -1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    
    s_ix_a0 <= to_mat_ix(1, 32);
    s_data_a0_i <= to_mat_word((0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 3.0, -0.25));
    WAIT FOR c_clk_per;
    
    FOR i in 2 TO 61 LOOP
        s_ix_a0 <= to_mat_ix(i, 0);
        s_data_a0_i <= to_mat_word((0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
        WAIT FOR c_clk_per;
    
        s_ix_a0 <= to_mat_ix(i, 32);
        s_data_a0_i <= to_mat_word((0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
        WAIT FOR c_clk_per;
    END LOOP;
    
    s_ix_a0 <= to_mat_ix(62, 0);
    s_data_a0_i <= to_mat_word((2.25, 1.25, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    
    s_ix_a0 <= to_mat_ix(62, 32);
    s_data_a0_i <= to_mat_word((0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 3.5, 1.0));
    WAIT FOR c_clk_per;
    
    s_ix_a0 <= to_mat_ix(63, 0);
    s_data_a0_i <= to_mat_word((4.0, 2.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    
    s_ix_a0 <= to_mat_ix(63, 32);
    s_data_a0_i <= to_mat_word((0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 4.5, -1.5));
    WAIT FOR c_clk_per;
    s_write_a0 <= '0';
    REPORT infomsg("Register " & INTEGER'IMAGE(reg) & " fertig initialisiert");
END init_mat_result_a0_add_a0;

PROCEDURE init_mat_result_a1_add_a1(
    reg : INTEGER; 
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word;
    SIGNAL s_sel_a : OUT t_mat_reg_ixs; SIGNAL s_sel_c : OUT t_mat_reg_ixs; SIGNAL s_opcode : OUT t_opcodes; SIGNAL s_wren : OUT STD_LOGIC; SIGNAL s_syn_rst : OUT STD_LOGIC; SIGNAL s_finished : IN STD_LOGIC
) IS
BEGIN
    delete_reg(reg, s_sel_c, s_opcode, s_wren, s_syn_rst, s_finished);
    REPORT infomsg("Register " & INTEGER'IMAGE(reg) & " = 64x64 (Ergebnis a1 + a1) [Spaltenweise]");
    s_sel_a(0) <= to_mat_reg_ix(reg); 
    s_write_a0 <= '1';
    s_size_a0_i <= to_mat_size(64, 64);
    s_row_by_row_a0_i <= '0';

    s_ix_a0 <= to_mat_ix(0, 0);
    s_data_a0_i <= to_mat_word((2.0, -0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    
    s_ix_a0 <= to_mat_ix(32, 0);
    s_data_a0_i <= to_mat_word((0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 4.5, -1.5));
    WAIT FOR c_clk_per;
    
    s_ix_a0 <= to_mat_ix(0, 1);
    s_data_a0_i <= to_mat_word((0.5, -1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    
    s_ix_a0 <= to_mat_ix(32, 1);
    s_data_a0_i <= to_mat_word((0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 3.0, -0.25));
    WAIT FOR c_clk_per;
    
    FOR i in 2 TO 61 LOOP
        s_ix_a0 <= to_mat_ix(0, i);
        s_data_a0_i <= to_mat_word((0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
        WAIT FOR c_clk_per;
    
        s_ix_a0 <= to_mat_ix(32, i);
        s_data_a0_i <= to_mat_word((0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
        WAIT FOR c_clk_per;
    END LOOP;
    
    s_ix_a0 <= to_mat_ix(0, 62);
    s_data_a0_i <= to_mat_word((2.25, 1.25, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    
    s_ix_a0 <= to_mat_ix(32, 62);
    s_data_a0_i <= to_mat_word((0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 3.5, 1.0));
    WAIT FOR c_clk_per;
    
    s_ix_a0 <= to_mat_ix(0, 63);
    s_data_a0_i <= to_mat_word((4.0, 2.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    
    s_ix_a0 <= to_mat_ix(32, 63);
    s_data_a0_i <= to_mat_word((0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 4.5, -1.5));
    WAIT FOR c_clk_per;
    s_write_a0 <= '0';
    REPORT infomsg("Register " & INTEGER'IMAGE(reg) & " fertig initialisiert");
END init_mat_result_a1_add_a1;

PROCEDURE init_mat_result_a0_trans(
    reg : INTEGER; 
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word;
    SIGNAL s_sel_a : OUT t_mat_reg_ixs; SIGNAL s_sel_c : OUT t_mat_reg_ixs; SIGNAL s_opcode : OUT t_opcodes; SIGNAL s_wren : OUT STD_LOGIC; SIGNAL s_syn_rst : OUT STD_LOGIC; SIGNAL s_finished : IN STD_LOGIC
) IS
BEGIN   
    delete_reg(reg, s_sel_c, s_opcode, s_wren, s_syn_rst, s_finished);
    REPORT infomsg("Register " & INTEGER'IMAGE(reg) & " = 64x64 (Ergebnis trans(a0)) [Zeilenweise]");
    -- [1.0, 0.25, ..., 1.125, 2.0]
    -- [-0.25, -0.5, ..., 0.625, 1.0]
    -- ...
    -- [2.25, 1.5, ..., 1.75, 2.25]
    -- [-0.75, -0.125, ..., 0.5, -0.75] 
    s_sel_a(0) <= to_mat_reg_ix(reg); 
    s_write_a0 <= '1';
    s_size_a0_i <= to_mat_size(64, 64);
    s_row_by_row_a0_i <= '1';

    s_ix_a0 <= to_mat_ix(0, 0);
    s_data_a0_i <= to_mat_word((1.0, 0.25, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    
    s_ix_a0 <= to_mat_ix(0, 32);
    s_data_a0_i <= to_mat_word((0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.125, 2.0));
    WAIT FOR c_clk_per;
    
    s_ix_a0 <= to_mat_ix(1, 0);
    s_data_a0_i <= to_mat_word((-0.25, -0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    
    s_ix_a0 <= to_mat_ix(1, 32);
    s_data_a0_i <= to_mat_word((0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.625, 1.0));
    WAIT FOR c_clk_per;
    
    FOR i in 2 TO 61 LOOP
        s_ix_a0 <= to_mat_ix(i, 0);
        s_data_a0_i <= to_mat_word((0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
        WAIT FOR c_clk_per;
    
        s_ix_a0 <= to_mat_ix(i, 32);
        s_data_a0_i <= to_mat_word((0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
        WAIT FOR c_clk_per;
    END LOOP;
    
    s_ix_a0 <= to_mat_ix(62, 0);
    s_data_a0_i <= to_mat_word((2.25, 1.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    
    s_ix_a0 <= to_mat_ix(62, 32);
    s_data_a0_i <= to_mat_word((0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.75, 2.25));
    WAIT FOR c_clk_per;
    
    s_ix_a0 <= to_mat_ix(63, 0);
    s_data_a0_i <= to_mat_word((-0.75, -0.125, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    
    s_ix_a0 <= to_mat_ix(63, 32);
    s_data_a0_i <= to_mat_word((0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, -0.75));
    WAIT FOR c_clk_per;
    s_write_a0 <= '0';
    REPORT infomsg("Register " & INTEGER'IMAGE(reg) & " fertig initialisiert");
END init_mat_result_a0_trans;

PROCEDURE init_mat_result_a1_trans(
    reg : INTEGER; 
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word;
    SIGNAL s_sel_a : OUT t_mat_reg_ixs; SIGNAL s_sel_c : OUT t_mat_reg_ixs; SIGNAL s_opcode : OUT t_opcodes; SIGNAL s_wren : OUT STD_LOGIC; SIGNAL s_syn_rst : OUT STD_LOGIC; SIGNAL s_finished : IN STD_LOGIC
) IS
BEGIN
    delete_reg(reg, s_sel_c, s_opcode, s_wren, s_syn_rst, s_finished);
    REPORT infomsg("Register " & INTEGER'IMAGE(reg) & " = 64x64 (Ergebnis trans(a1)) [Spaltenweise]");
    -- [1.0, -0.25, ..., 2.25, -0.75]
    -- [0.25, -0.5, ..., 1.5, -0.125]
    -- ...
    -- [1.125, 0.625, ..., 1.75, 0.5]
    -- [2.0, 1.0, ..., 2.25, -0.75]
    s_sel_a(0) <= to_mat_reg_ix(reg); 
    s_write_a0 <= '1';
    s_size_a0_i <= to_mat_size(64, 64);
    s_row_by_row_a0_i <= '0';

    s_ix_a0 <= to_mat_ix(0, 0);
    s_data_a0_i <= to_mat_word((1.0, 0.25, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    
    s_ix_a0 <= to_mat_ix(32, 0);
    s_data_a0_i <= to_mat_word((0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.125, 2.0));
    WAIT FOR c_clk_per;
    
    s_ix_a0 <= to_mat_ix(0, 1);
    s_data_a0_i <= to_mat_word((-0.25, -0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    
    s_ix_a0 <= to_mat_ix(32, 1);
    s_data_a0_i <= to_mat_word((0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.625, 1.0));
    WAIT FOR c_clk_per;
    
    FOR i in 2 TO 61 LOOP
        s_ix_a0 <= to_mat_ix(0, i);
        s_data_a0_i <= to_mat_word((0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
        WAIT FOR c_clk_per;
    
        s_ix_a0 <= to_mat_ix(32, i);
        s_data_a0_i <= to_mat_word((0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
        WAIT FOR c_clk_per;
    END LOOP;
    
    s_ix_a0 <= to_mat_ix(0, 62);
    s_data_a0_i <= to_mat_word((2.25, 1.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    
    s_ix_a0 <= to_mat_ix(32, 62);
    s_data_a0_i <= to_mat_word((0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.75, 2.25));
    WAIT FOR c_clk_per;
    
    s_ix_a0 <= to_mat_ix(0, 63);
    s_data_a0_i <= to_mat_word((-0.75, -0.125, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    
    s_ix_a0 <= to_mat_ix(32, 63);
    s_data_a0_i <= to_mat_word((0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, -0.75));
    WAIT FOR c_clk_per;
    s_write_a0 <= '0';
    REPORT infomsg("Register " & INTEGER'IMAGE(reg) & " fertig initialisiert");
END init_mat_result_a1_trans;


PROCEDURE init_mat_result_a0_scalar_max(
    reg : INTEGER; 
    SIGNAL s_write_a0 : OUT STD_LOGIC; SIGNAL s_size_a0_i : OUT t_mat_size; SIGNAL s_row_by_row_a0_i : OUT STD_LOGIC; SIGNAL s_ix_a0 : OUT t_mat_ix; SIGNAL s_data_a0_i : OUT t_mat_word;
    SIGNAL s_sel_a : OUT t_mat_reg_ixs; SIGNAL s_sel_c : OUT t_mat_reg_ixs; SIGNAL s_opcode : OUT t_opcodes; SIGNAL s_wren : OUT STD_LOGIC; SIGNAL s_syn_rst : OUT STD_LOGIC; SIGNAL s_finished : IN STD_LOGIC
) IS
BEGIN
    delete_reg(reg, s_sel_c, s_opcode, s_wren, s_syn_rst, s_finished);
    REPORT infomsg("Register " & INTEGER'IMAGE(reg) & " = 64x64 (Ergebnis scalar_max(a0)) [Zeilenweise]");
    s_sel_a(0) <= to_mat_reg_ix(reg); 
    s_write_a0 <= '1';
    s_size_a0_i <= to_mat_size(64, 64);
    s_row_by_row_a0_i <= '1';

    s_ix_a0 <= to_mat_ix(0, 0);
    s_data_a0_i <= to_mat_word((1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    
    s_ix_a0 <= to_mat_ix(0, 32);
    s_data_a0_i <= to_mat_word((0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.25, 0.0));
    WAIT FOR c_clk_per;
    
    s_ix_a0 <= to_mat_ix(1, 0);
    s_data_a0_i <= to_mat_word((0.25, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    
    s_ix_a0 <= to_mat_ix(1, 32);
    s_data_a0_i <= to_mat_word((0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 0.0));
    WAIT FOR c_clk_per;
    
    FOR i in 2 TO 61 LOOP
        s_ix_a0 <= to_mat_ix(i, 0);
        s_data_a0_i <= to_mat_word((0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
        WAIT FOR c_clk_per;
    
        s_ix_a0 <= to_mat_ix(i, 32);
        s_data_a0_i <= to_mat_word((0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
        WAIT FOR c_clk_per;
    END LOOP;
    
    s_ix_a0 <= to_mat_ix(62, 0);
    s_data_a0_i <= to_mat_word((1.125, 0.625, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    
    s_ix_a0 <= to_mat_ix(62, 32);
    s_data_a0_i <= to_mat_word((0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.75, 0.5));
    WAIT FOR c_clk_per;
    
    s_ix_a0 <= to_mat_ix(63, 0);
    s_data_a0_i <= to_mat_word((2.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    
    s_ix_a0 <= to_mat_ix(63, 32);
    s_data_a0_i <= to_mat_word((0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.25, 0.0));
    WAIT FOR c_clk_per;
    s_write_a0 <= '0';
    REPORT infomsg("Register " & INTEGER'IMAGE(reg) & " fertig initialisiert");
END init_mat_result_a0_scalar_max;
    
END PACKAGE BODY;