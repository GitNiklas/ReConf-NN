----------------------------------------------------------------------------------------------------
--  Testbench fuer e_mat_cpu
--  Simulationszeit: ??
--
--  Autor: Niklas Kuehl
--  Datum: 29.06.2018
----------------------------------------------------------------------------------------------------
LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.all;
USE work.pkg_tools.ALL;
USE work.pkg_test.ALL;
USE work.fixed_pkg.ALL;

ENTITY tb_mat_cpu_mul IS
END ENTITY tb_mat_cpu_mul;

ARCHITECTURE a_tb_mat_cpu_mul OF tb_mat_cpu_mul IS

COMPONENT e_mat_cpu
    PORT (    
        p_rst_i                 : IN STD_LOGIC;
        p_clk_i                 : IN STD_LOGIC;
        p_syn_rst_i             : IN STD_LOGIC;
        p_wren_i                : IN STD_LOGIC;
        
        p_finished_o            : OUT STD_LOGIC;
        p_opcode_i              : IN t_opcodes;
        p_scalar_i              : IN t_mat_elem;

        p_sel_a_i               : IN t_mat_reg_ixs;
        p_sel_b_i               : IN t_mat_reg_ixs;
        p_sel_c_i               : IN t_mat_reg_ixs;
        p_row_by_row_c_i        : IN t_op_std_logics; -- Bestimmt, ob die Matrix C Zeilen- oder Spaltenweise gespeichert wird
        
        p_write_a0_i            : IN STD_LOGIC; -- signalisiert, dass Elemente in Matrix A(0) geschrieben werden soll
        p_read_a0_i             : IN STD_LOGIC;
        p_data_a0_i             : IN t_mat_word;
        p_data_a0_o             : OUT t_mat_word;
        p_ix_a0_i               : IN t_mat_ix;
        p_size_a0_i             : IN t_mat_size;
        p_row_by_row_a0_i       : IN STD_LOGIC;
        p_size_a0_o             : OUT t_mat_size;
        p_row_by_row_a0_o       : OUT STD_LOGIC
    );
END COMPONENT;

---------------------------------------------
--  Prozeduren
---------------------------------------------

PROCEDURE init_mat_2x3_rbr(reg: INTEGER; opcore: INTEGER; SIGNAL s_write_a0: OUT STD_LOGIC; SIGNAL s_size_a0_i: OUT t_mat_size; SIGNAL s_row_by_row_a0_i: OUT STD_LOGIC;SIGNAL s_ix_a0: OUT t_mat_ix;SIGNAL s_data_a0_i: OUT t_mat_word; SIGNAL s_sel_a: OUT t_mat_reg_ixs; SIGNAL s_sel_c: OUT t_mat_reg_ixs; SIGNAL s_opcode: OUT t_opcodes; SIGNAL s_wren: OUT STD_LOGIC; SIGNAL s_syn_rst: OUT STD_LOGIC; SIGNAL s_finished: IN STD_LOGIC) IS
BEGIN
    delete_reg(reg, opcore, s_sel_c, s_opcode, s_wren, s_syn_rst, s_finished);
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

PROCEDURE init_mat_3x3_cbc(reg: INTEGER; opcore: INTEGER; SIGNAL s_write_a0: OUT STD_LOGIC; SIGNAL s_size_a0_i: OUT t_mat_size; SIGNAL s_row_by_row_a0_i: OUT STD_LOGIC;SIGNAL s_ix_a0: OUT t_mat_ix;SIGNAL s_data_a0_i: OUT t_mat_word; SIGNAL s_sel_a: OUT t_mat_reg_ixs; SIGNAL s_sel_c: OUT t_mat_reg_ixs; SIGNAL s_opcode: OUT t_opcodes; SIGNAL s_wren: OUT STD_LOGIC; SIGNAL s_syn_rst: OUT STD_LOGIC; SIGNAL s_finished: IN STD_LOGIC) IS
BEGIN
    delete_reg(reg, opcore, s_sel_c, s_opcode, s_wren, s_syn_rst, s_finished);
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

PROCEDURE init_mat_result_2x3_3x3_rbr(reg: INTEGER; opcore: INTEGER; SIGNAL s_write_a0: OUT STD_LOGIC; SIGNAL s_size_a0_i: OUT t_mat_size; SIGNAL s_row_by_row_a0_i: OUT STD_LOGIC;SIGNAL s_ix_a0: OUT t_mat_ix;SIGNAL s_data_a0_i: OUT t_mat_word; SIGNAL s_sel_a: OUT t_mat_reg_ixs; SIGNAL s_sel_c: OUT t_mat_reg_ixs; SIGNAL s_opcode: OUT t_opcodes; SIGNAL s_wren: OUT STD_LOGIC; SIGNAL s_syn_rst: OUT STD_LOGIC; SIGNAL s_finished: IN STD_LOGIC) IS
BEGIN
    delete_reg(reg, opcore, s_sel_c, s_opcode, s_wren, s_syn_rst, s_finished);
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
END init_mat_result_2x3_3x3_rbr;

PROCEDURE init_mat_2x36_rbr(reg: INTEGER; opcore: INTEGER; SIGNAL s_write_a0: OUT STD_LOGIC; SIGNAL s_size_a0_i: OUT t_mat_size; SIGNAL s_row_by_row_a0_i: OUT STD_LOGIC;SIGNAL s_ix_a0: OUT t_mat_ix;SIGNAL s_data_a0_i: OUT t_mat_word; SIGNAL s_sel_a: OUT t_mat_reg_ixs; SIGNAL s_sel_c: OUT t_mat_reg_ixs; SIGNAL s_opcode: OUT t_opcodes; SIGNAL s_wren: OUT STD_LOGIC; SIGNAL s_syn_rst: OUT STD_LOGIC; SIGNAL s_finished: IN STD_LOGIC) IS
BEGIN
    delete_reg(reg, opcore, s_sel_c, s_opcode, s_wren, s_syn_rst, s_finished);
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

PROCEDURE init_mat_36x3_cbc(reg: INTEGER; opcore: INTEGER; SIGNAL s_write_a0: OUT STD_LOGIC; SIGNAL s_size_a0_i: OUT t_mat_size; SIGNAL s_row_by_row_a0_i: OUT STD_LOGIC;SIGNAL s_ix_a0: OUT t_mat_ix;SIGNAL s_data_a0_i: OUT t_mat_word; SIGNAL s_sel_a: OUT t_mat_reg_ixs; SIGNAL s_sel_c: OUT t_mat_reg_ixs; SIGNAL s_opcode: OUT t_opcodes; SIGNAL s_wren: OUT STD_LOGIC; SIGNAL s_syn_rst: OUT STD_LOGIC; SIGNAL s_finished: IN STD_LOGIC) IS
BEGIN
    delete_reg(reg, opcore, s_sel_c, s_opcode, s_wren, s_syn_rst, s_finished);
    REPORT infomsg("Register " & INTEGER'IMAGE(reg) & " = 36x3 Matrix [Spaltenweise]");
    -- [1, 1, 2.0],[2, 3, -4],[1, -2, -3],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.5, 0.5, 0.5],[0.5, 0.5, 2.0],[0.5, 1.0, 0.5],[0.5, 1.5, 1.0]
    s_sel_a(0) <= to_mat_reg_ix(reg); 
    s_write_a0 <= '1';
    s_size_a0_i <= to_mat_size(36, 3);
    s_row_by_row_a0_i <= '0';

    s_ix_a0 <= to_mat_ix(0, 0);
    s_data_a0_i <= to_mat_word((1.0, 2.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                               0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_ix_a0 <= to_mat_ix(32, 0);
    s_data_a0_i <= to_mat_word((0.5, 0.5, 0.5, 0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                               0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    
    s_ix_a0 <= to_mat_ix(0, 1);
    s_data_a0_i <= to_mat_word((1.0, 3.0, -2.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                               0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_ix_a0 <= to_mat_ix(32, 1);
    s_data_a0_i <= to_mat_word((0.5, 0.5, 1.0, 1.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                               0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
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

PROCEDURE init_mat_result_2x36_36x3_rbr(reg: INTEGER; opcore: INTEGER; SIGNAL s_write_a0: OUT STD_LOGIC; SIGNAL s_size_a0_i: OUT t_mat_size; SIGNAL s_row_by_row_a0_i: OUT STD_LOGIC;SIGNAL s_ix_a0: OUT t_mat_ix;SIGNAL s_data_a0_i: OUT t_mat_word; SIGNAL s_sel_a: OUT t_mat_reg_ixs; SIGNAL s_sel_c: OUT t_mat_reg_ixs; SIGNAL s_opcode: OUT t_opcodes; SIGNAL s_wren: OUT STD_LOGIC; SIGNAL s_syn_rst: OUT STD_LOGIC; SIGNAL s_finished: IN STD_LOGIC) IS
BEGIN
    delete_reg(reg, opcore, s_sel_c, s_opcode, s_wren, s_syn_rst, s_finished);
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
END init_mat_result_2x36_36x3_rbr;

PROCEDURE init_mat_36x1_rbr(reg: INTEGER; opcore: INTEGER; SIGNAL s_write_a0: OUT STD_LOGIC; SIGNAL s_size_a0_i: OUT t_mat_size; SIGNAL s_row_by_row_a0_i: OUT STD_LOGIC;SIGNAL s_ix_a0: OUT t_mat_ix;SIGNAL s_data_a0_i: OUT t_mat_word; SIGNAL s_sel_a: OUT t_mat_reg_ixs; SIGNAL s_sel_c: OUT t_mat_reg_ixs; SIGNAL s_opcode: OUT t_opcodes; SIGNAL s_wren: OUT STD_LOGIC; SIGNAL s_syn_rst: OUT STD_LOGIC; SIGNAL s_finished: IN STD_LOGIC) IS
BEGIN
    delete_reg(reg, opcore, s_sel_c, s_opcode, s_wren, s_syn_rst, s_finished);
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

PROCEDURE init_mat_1x2_cbc(reg: INTEGER; opcore: INTEGER; SIGNAL s_write_a0: OUT STD_LOGIC; SIGNAL s_size_a0_i: OUT t_mat_size; SIGNAL s_row_by_row_a0_i: OUT STD_LOGIC;SIGNAL s_ix_a0: OUT t_mat_ix;SIGNAL s_data_a0_i: OUT t_mat_word; SIGNAL s_sel_a: OUT t_mat_reg_ixs; SIGNAL s_sel_c: OUT t_mat_reg_ixs; SIGNAL s_opcode: OUT t_opcodes; SIGNAL s_wren: OUT STD_LOGIC; SIGNAL s_syn_rst: OUT STD_LOGIC; SIGNAL s_finished: IN STD_LOGIC) IS
BEGIN
    delete_reg(reg, opcore, s_sel_c, s_opcode, s_wren, s_syn_rst, s_finished);
    REPORT infomsg("Register " & INTEGER'IMAGE(reg) & " = 1x2 Matrix [Spaltenweise]");
    -- [2, 1]
    s_sel_a(0) <= to_mat_reg_ix(reg); 
    s_write_a0 <= '1';
    s_size_a0_i <= to_mat_size(1, 2);
    s_row_by_row_a0_i <= '0';

    s_ix_a0 <= to_mat_ix(0, 0);
    s_data_a0_i <= to_mat_word((2.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                               0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    
    s_ix_a0 <= to_mat_ix(0, 1);
    s_data_a0_i <= to_mat_word((1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                               0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_write_a0 <= '0';
    REPORT infomsg("Register " & INTEGER'IMAGE(reg) & " fertig initialisiert");
END init_mat_1x2_cbc;

PROCEDURE init_mat_result_36x1_1x2_cbc(reg: INTEGER; opcore: INTEGER; SIGNAL s_write_a0: OUT STD_LOGIC; SIGNAL s_size_a0_i: OUT t_mat_size; SIGNAL s_row_by_row_a0_i: OUT STD_LOGIC;SIGNAL s_ix_a0: OUT t_mat_ix;SIGNAL s_data_a0_i: OUT t_mat_word; SIGNAL s_sel_a: OUT t_mat_reg_ixs; SIGNAL s_sel_c: OUT t_mat_reg_ixs; SIGNAL s_opcode: OUT t_opcodes; SIGNAL s_wren: OUT STD_LOGIC; SIGNAL s_syn_rst: OUT STD_LOGIC; SIGNAL s_finished: IN STD_LOGIC) IS
BEGIN
    delete_reg(reg, opcore, s_sel_c, s_opcode, s_wren, s_syn_rst, s_finished);
    REPORT infomsg("Register " & INTEGER'IMAGE(reg) & " = 36x2 (Ergebnis 36x1 * 1x2) [Spaltenweise]");
    -- [0.5], [0.25], [0.0], [2.0], [0.25], [1.0], [2.0], [4.0], [0.125], [1.0], [0.25], [2.0], [1.25], [1.75], [4.0], [1.0], [1.125], [0.625], [0.5], [0.25], [0.0], [2.0], [0.25], [1.0], [2.0], [4.0], [0.125], [1.0], [0.25], [2.0], [1.25], [1.75], [4.0], [1.0], [1.125], [0.625]
    -- [0.25], [0.125], [0.0], [1.0], [0.125], [0.5], [1.0], [2.0], [0.0625], [0.5], [0.125], [1.0], [0.625], [0.875], [2.0], [0.5], [0.5625], [0.3125], [0.25], [0.125], [0.0], [1.0], [0.125], [0.5], [1.0], [2.0], [0.0625], [0.5], [0.125], [1.0], [0.625], [0.875], [2.0], [0.5], [0.5625], [0.3125]
    s_sel_a(0) <= to_mat_reg_ix(reg); 
    s_write_a0 <= '1';
    s_size_a0_i <= to_mat_size(36, 2);
    s_row_by_row_a0_i <= '0';
    
    s_ix_a0 <= to_mat_ix(0, 0);
    s_data_a0_i <= to_mat_word(( 0.5, 0.25, 0.0, 2.0, 0.25, 1.0, 2.0, 4.0, 0.125, 1.0, 0.25, 2.0, 1.25, 1.75, 4.0, 1.0, 
                                1.125, 0.625, 0.5, 0.25, 0.0, 2.0, 0.25, 1.0, 2.0, 4.0, 0.125, 1.0, 0.25, 2.0, 1.25, 1.75));
    WAIT FOR c_clk_per;
    
    s_ix_a0 <= to_mat_ix(32, 0);
    s_data_a0_i <= to_mat_word((4.0, 1.0, 1.125, 0.625, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                               0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    
    s_ix_a0 <= to_mat_ix(0, 1);
    s_data_a0_i <= to_mat_word(( 0.25, 0.125, 0.0, 1.0, 0.125, 0.5, 1.0, 2.0, 0.0625, 0.5, 0.125, 1.0, 0.625, 0.875, 2.0, 0.5, 
                                0.5625, 0.3125, 0.25, 0.125, 0.0, 1.0, 0.125, 0.5, 1.0, 2.0, 0.0625, 0.5, 0.125, 1.0, 0.625, 0.875));
    WAIT FOR c_clk_per;
    
    s_ix_a0 <= to_mat_ix(32, 1);
    s_data_a0_i <= to_mat_word((2.0, 0.5, 0.5625, 0.3125, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                               0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_write_a0 <= '0';
    REPORT infomsg("Register " & INTEGER'IMAGE(reg) & " fertig initialisiert");
END init_mat_result_36x1_1x2_cbc;

PROCEDURE exec_mul(wait_finish: BOOLEAN; opcore: INTEGER; reg_a: INTEGER; reg_b: INTEGER; reg_c: INTEGER; row_by_row: STD_LOGIC;SIGNAL s_sel_a: OUT t_mat_reg_ixs;SIGNAL s_sel_b: OUT t_mat_reg_ixs;SIGNAL s_sel_c: OUT t_mat_reg_ixs;SIGNAL s_opcode: OUT t_opcodes;SIGNAL s_c_row_by_row: OUT t_op_std_logics;SIGNAL s_wren: OUT STD_LOGIC;SIGNAL s_syn_rst: OUT STD_LOGIC; SIGNAL s_finished: IN STD_LOGIC) IS
BEGIN
    REPORT infomsg("Starte Matrix-Multiplikation: Reg" & INTEGER'IMAGE(reg_c) & " = Reg" & INTEGER'IMAGE(reg_a) & " * Reg" & INTEGER'IMAGE(reg_b));
    s_sel_a(opcore) <= to_mat_reg_ix(reg_a); 
    s_sel_b(opcore) <= to_mat_reg_ix(reg_b); 
    s_sel_c(opcore) <= to_mat_reg_ix(reg_c); 
    s_opcode(opcore) <= MatMul;
    s_c_row_by_row(opcore) <= row_by_row;
    
    IF wait_finish THEN
        s_wren  <= '1';
        s_syn_rst <= '1';
        WAIT FOR c_clk_per;
        s_syn_rst <= '0';
        
        WAIT UNTIL s_finished = '1';
        WAIT FOR c_clk_per / 2;
        s_wren  <= '0';
        s_opcode(opcore) <= NoOp;
        REPORT infomsg("Matrix-Multiplikation fertig");
    ELSE
        REPORT infomsg(" ----- Fuehre Operation parallel aus. Nach Abschluss OpCode auf NoOp setzen!");
    END IF;
END exec_mul;

PROCEDURE test_mul(opcore: INTEGER; SIGNAL s_write_a0: OUT STD_LOGIC; SIGNAL s_read_a0: OUT STD_LOGIC; SIGNAL s_size_a0_i: OUT t_mat_size; SIGNAL s_size_a0_o: IN t_mat_size; SIGNAL s_row_by_row_a0_i: OUT STD_LOGIC; SIGNAL s_row_by_row_a0_o: IN STD_LOGIC; SIGNAL s_ix_a0: OUT t_mat_ix; SIGNAL s_data_a0_i: OUT t_mat_word; SIGNAL s_data_a0_o: IN t_mat_word; SIGNAL s_sel_a: OUT t_mat_reg_ixs; SIGNAL s_sel_b: OUT t_mat_reg_ixs; SIGNAL s_sel_c: OUT t_mat_reg_ixs; SIGNAL s_opcode: OUT t_opcodes; SIGNAL s_c_row_by_row: OUT t_op_std_logics; SIGNAL s_wren: OUT STD_LOGIC; SIGNAL s_syn_rst: OUT STD_LOGIC; SIGNAL s_finished: IN STD_LOGIC) IS
BEGIN
    REPORT infomsg("Test: Matrix-Multiplikation");

    REPORT infomsg("Test 1: Reg0(2x3) * Reg1(3x3)");
    init_mat_2x3_rbr(0, 0, s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a, s_sel_c, s_opcode, s_wren, s_syn_rst, s_finished);
    init_mat_3x3_cbc(1, 0, s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a, s_sel_c, s_opcode, s_wren, s_syn_rst, s_finished);
    exec_mul(TRUE, 1, 0, 1, 2, '1', s_sel_a, s_sel_b, s_sel_c, s_opcode, s_c_row_by_row, s_wren, s_syn_rst, s_finished);
    init_mat_result_2x3_3x3_rbr(3, 0, s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a, s_sel_c, s_opcode, s_wren, s_syn_rst, s_finished);
--    print_mat_reg(0, s_sel_a(0), s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o);
--    print_mat_reg(1, s_sel_a(0), s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o);
--    print_mat_reg(2, s_sel_a(0), s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o);
--    print_mat_reg(3, s_sel_a(0), s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o);
    assert_mat_reg_eq(2, 3, s_sel_a(0), s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o);

    REPORT infomsg("Test 2: Reg0(2x36) * Reg1(36x3)");
    init_mat_2x36_rbr(0, 0, s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a, s_sel_c, s_opcode, s_wren, s_syn_rst, s_finished);
    init_mat_36x3_cbc(1, 0, s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a, s_sel_c, s_opcode, s_wren, s_syn_rst, s_finished);
    exec_mul(TRUE, 1, 0, 1, 2, '1', s_sel_a, s_sel_b, s_sel_c, s_opcode, s_c_row_by_row, s_wren, s_syn_rst, s_finished);
    init_mat_result_2x36_36x3_rbr(3, 0, s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a, s_sel_c, s_opcode, s_wren, s_syn_rst, s_finished);
    assert_mat_reg_eq(2, 3, s_sel_a(0), s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o);

    REPORT infomsg("Test 3: A(36x1) * B(1x2) (C Spaltenweise)");
    init_mat_36x1_rbr(0, 0, s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a, s_sel_c, s_opcode, s_wren, s_syn_rst, s_finished);
    init_mat_1x2_cbc(1, 0, s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a, s_sel_c, s_opcode, s_wren, s_syn_rst, s_finished);
    exec_mul(TRUE, 1, 0, 1, 2, '0', s_sel_a, s_sel_b, s_sel_c, s_opcode, s_c_row_by_row, s_wren, s_syn_rst, s_finished);
    init_mat_result_36x1_1x2_cbc(3, 0, s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a, s_sel_c, s_opcode, s_wren, s_syn_rst, s_finished);
    assert_mat_reg_eq(2, 3, s_sel_a(0), s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o);

    REPORT infomsg("Test: Matrix-Multiplikation BEENDET");
END test_mul;

PROCEDURE test_del(opcore: INTEGER; SIGNAL s_write_a0: OUT STD_LOGIC; SIGNAL s_read_a0: OUT STD_LOGIC; SIGNAL s_size_a0_i: OUT t_mat_size; SIGNAL s_size_a0_o: IN t_mat_size; SIGNAL s_row_by_row_a0_i: OUT STD_LOGIC; SIGNAL s_row_by_row_a0_o: IN STD_LOGIC; SIGNAL s_ix_a0: OUT t_mat_ix; SIGNAL s_data_a0_i: OUT t_mat_word; SIGNAL s_data_a0_o: IN t_mat_word; SIGNAL s_sel_a: OUT t_mat_reg_ixs; SIGNAL s_sel_b: OUT t_mat_reg_ixs; SIGNAL s_sel_c: OUT t_mat_reg_ixs; SIGNAL s_opcode: OUT t_opcodes; SIGNAL s_c_row_by_row: OUT t_op_std_logics; SIGNAL s_wren: OUT STD_LOGIC; SIGNAL s_syn_rst: OUT STD_LOGIC; SIGNAL s_finished: IN STD_LOGIC) IS
BEGIN
    REPORT infomsg("Test: Matrix Löschen");
    s_sel_a(0) <= to_mat_reg_ix(0); 
    
    set_mat(to_mat_elem(1.0), s_write_a0, s_data_a0_i, s_ix_a0);
    delete_reg(0, 0, s_sel_c, s_opcode, s_wren, s_syn_rst, s_finished);
    
    s_write_a0 <= '1';
    s_size_a0_i <= to_mat_size(64, 64);
    s_data_a0_i <= to_mat_word((0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_write_a0 <= '0';

    s_sel_a(0) <= to_mat_reg_ix(1); 
    set_mat(to_mat_elem(0.0), s_write_a0, s_data_a0_i, s_ix_a0);
    s_write_a0 <= '1';
    s_size_a0_i <= to_mat_size(64, 64);
    WAIT FOR c_clk_per;
    s_write_a0 <= '0';
    
    assert_mat_reg_eq(0, 1, s_sel_a(0), s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o);
    
    REPORT infomsg("Test: Matrix Löschen BEENDET");
END test_del;

---------------------------------------------
--  Signale
---------------------------------------------
SIGNAL s_clk, s_rst, s_syn_rst, s_wren : STD_LOGIC;
SIGNAL s_finished : STD_LOGIC;
SIGNAL s_c_row_by_row : t_op_std_logics;
SIGNAL s_opcode : t_opcodes;
SIGNAL s_scalar : t_mat_elem;

SIGNAL s_sel_a, s_sel_b, s_sel_c : t_mat_reg_ixs;

SIGNAL s_write_a0, s_read_a0 : STD_LOGIC;
SIGNAL s_data_a0_i, s_data_a0_o : t_mat_word;
SIGNAL s_ix_a0 : t_mat_ix;
SIGNAL s_size_a0_i, s_size_a0_o : t_mat_size;
SIGNAL s_row_by_row_a0_i, s_row_by_row_a0_o : STD_LOGIC;

---------------------------------------------
--  Port Maps
---------------------------------------------
BEGIN

dut : e_mat_cpu
PORT MAP(
    p_rst_i                 => s_rst,
    p_clk_i                 => s_clk,   
    p_wren_i                => s_wren,  
    p_syn_rst_i             => s_syn_rst,
    
    p_finished_o            => s_finished, 
    p_opcode_i              => s_opcode,
    p_scalar_i              => s_scalar,

    p_sel_a_i               => s_sel_a,
    p_sel_b_i               => s_sel_b,
    p_sel_c_i               => s_sel_c,
    p_row_by_row_c_i        => s_c_row_by_row,
    
    p_write_a0_i            => s_write_a0,
    p_read_a0_i             => s_read_a0,
    p_data_a0_i             => s_data_a0_i,
    p_data_a0_o             => s_data_a0_o,
    p_ix_a0_i               => s_ix_a0,
    p_size_a0_i             => s_size_a0_i,
    p_row_by_row_a0_i       => s_row_by_row_a0_i,
    p_size_a0_o             => s_size_a0_o,
    p_row_by_row_a0_o       => s_row_by_row_a0_o
);

---------------------------------------------
--  Prozesse
---------------------------------------------

proc_clk_gen : PROCESS
BEGIN
    s_clk <= '0';
    WAIT FOR c_clk_per / 2;
    s_clk <= '1';
    WAIT FOR c_clk_per / 2;
END PROCESS proc_clk_gen;

proc_test : PROCESS
VARIABLE opcore : INTEGER := 1;
BEGIN
    REPORT infomsg("Test Start");
----------------------------------------------------------------------------------------------------
--  Init
----------------------------------------------------------------------------------------------------
    REPORT infomsg("Initialisiere Signale");
    s_rst <= '1'; 
    s_syn_rst <= '0';
    s_wren <= '0';
    
    FOR i IN c_num_parallel_op-1 DOWNTO 0 LOOP
        s_opcode(i) <= NoOp;
        s_sel_a(i) <= to_mat_reg_ix(0);
        s_sel_b(i) <= to_mat_reg_ix(0);
        s_sel_c(i) <= to_mat_reg_ix(0);
        s_c_row_by_row(i) <= '1';
    END LOOP;
    s_scalar <= to_mat_elem(0.0);
    
    s_write_a0 <= '0';
    s_read_a0 <= '0';
    s_data_a0_i <= c_mat_word_zero;
    s_ix_a0 <= to_mat_ix(0, 0);
    s_size_a0_i <= to_mat_size(7, 7);
    s_row_by_row_a0_i <= '1';
   
    WAIT FOR c_clk_per;
    s_rst <= '0';
   
    REPORT infomsg("Initialisierung abgeschlossen");

    test_del(1, s_write_a0, s_read_a0, s_size_a0_i, s_size_a0_o, s_row_by_row_a0_i, s_row_by_row_a0_o, s_ix_a0, s_data_a0_i, s_data_a0_o, s_sel_a, s_sel_b, s_sel_c, s_opcode, s_c_row_by_row, s_wren, s_syn_rst, s_finished);
    test_mul(1, s_write_a0, s_read_a0, s_size_a0_i, s_size_a0_o, s_row_by_row_a0_i, s_row_by_row_a0_o, s_ix_a0, s_data_a0_i, s_data_a0_o, s_sel_a, s_sel_b, s_sel_c, s_opcode, s_c_row_by_row, s_wren, s_syn_rst, s_finished);
    
    REPORT infomsg("Testende");
    WAIT;
END PROCESS proc_test;

END ARCHITECTURE a_tb_mat_cpu_mul;