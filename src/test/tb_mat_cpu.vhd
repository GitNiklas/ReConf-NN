----------------------------------------------------------------------------------------------------
--  Testbench fuer e_mat_cpu
--  Enthaelt Testfaelle fuer alle Matrixoperationen
--  Simulationszeit: 6 ms
--
--  Autor: Niklas Kuehl
----------------------------------------------------------------------------------------------------
LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.all;
USE work.pkg_tools.ALL;
USE work.pkg_test.ALL;
USE work.fixed_pkg.ALL;
USE work.pkg_test_matrices.ALL;

ENTITY tb_mat_cpu IS
END ENTITY tb_mat_cpu;

ARCHITECTURE a_tb_mat_cpu OF tb_mat_cpu IS

COMPONENT e_mat_cpu
    PORT (    
        p_rst_i                 : IN STD_LOGIC;
        p_clk_i                 : IN STD_LOGIC;
        p_syn_rst_i             : IN STD_LOGIC;
        p_wren_i                : IN STD_LOGIC;
        
        p_finished_o            : OUT t_op_std_logics;
        p_opcode_i              : IN t_opcodes;
        p_data_i                : IN t_byte;
        p_data_o                : OUT t_byte;

        p_sel_a_i               : IN t_mat_reg_ixs;
        p_sel_b_i               : IN t_mat_reg_ixs;
        p_sel_c_i               : IN t_mat_reg_ixs;
        p_row_by_row_c_i        : IN t_op_std_logics;
        
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
END COMPONENT;

COMPONENT e_ram_64_8
	PORT (
		clock : IN STD_LOGIC  := '1';
		data : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		rdaddress : IN STD_LOGIC_VECTOR (5 DOWNTO 0);
		wraddress : IN STD_LOGIC_VECTOR (5 DOWNTO 0);
		wren : IN STD_LOGIC  := '0';
		q : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
END COMPONENT;

---------------------------------------------
--  Typen, Konstanten
---------------------------------------------

CONSTANT test_prefix : STRING := " ---------- ";

TYPE t_data_port_mode IS (DPMScalarSubIx, DPMScalarMul);

---------------------------------------------
--  Prozeduren
---------------------------------------------

PROCEDURE wait_all_finished(SIGNAL s_opcode: OUT t_opcodes; SIGNAL s_wren: OUT STD_LOGIC; SIGNAL s_syn_rst: OUT STD_LOGIC; SIGNAL s_finished: IN t_op_std_logics) IS
BEGIN
    s_wren  <= '1';
    s_syn_rst <= '1';
    WAIT FOR c_clk_per;
    s_syn_rst <= '0';
 
    FOR i IN s_finished'RANGE LOOP
        REPORT infomsg(" Warte auf OpCore " & INTEGER'IMAGE(i));
        IF s_finished(i) /= '1' THEN
            WAIT UNTIL s_finished(i) = '1';
            WAIT FOR c_clk_per/2;
        END IF;
        s_opcode(i) <= NoOp;
    END LOOP;
    
    WAIT FOR c_clk_per / 2;
    s_wren  <= '0';
END wait_all_finished;

PROCEDURE exec_op(op: t_opcode; wait_finish: BOOLEAN; opcore: INTEGER; reg_a: INTEGER; reg_b: INTEGER; reg_c: INTEGER; row_by_row: STD_LOGIC; SIGNAL s_sel_a: OUT t_mat_reg_ixs; SIGNAL s_sel_b: OUT t_mat_reg_ixs; SIGNAL s_sel_c: OUT t_mat_reg_ixs; SIGNAL s_opcode: OUT t_opcodes;SIGNAL s_c_row_by_row: OUT t_op_std_logics;SIGNAL s_wren: OUT STD_LOGIC;SIGNAL s_syn_rst: OUT STD_LOGIC; SIGNAL s_finished: IN t_op_std_logics) IS
BEGIN
    s_sel_a(opcore) <= to_mat_reg_ix(reg_a); 
    s_sel_b(opcore) <= to_mat_reg_ix(reg_b); 
    s_sel_c(opcore) <= to_mat_reg_ix(reg_c); 
    s_opcode(opcore) <= op;
    s_c_row_by_row(opcore) <= row_by_row;
    
    IF wait_finish THEN
        s_wren  <= '1';
        s_syn_rst <= '1';
        WAIT FOR c_clk_per;
        s_syn_rst <= '0';
        
        WAIT UNTIL s_finished(opcore) = '1';
        WAIT FOR c_clk_per / 2;
        s_wren  <= '0';
        s_opcode(opcore) <= NoOp;
        REPORT infomsg("Operation abgeschlossen");
    ELSE
        REPORT infomsg("Fuehre Operation parallel aus");
    END IF;
END exec_op;

PROCEDURE exec_mul(wait_finish: BOOLEAN; reg_a: INTEGER; reg_b: INTEGER; reg_c: INTEGER; row_by_row: STD_LOGIC;SIGNAL s_sel_a: OUT t_mat_reg_ixs; SIGNAL s_sel_b: OUT t_mat_reg_ixs; SIGNAL s_sel_c: OUT t_mat_reg_ixs; SIGNAL s_opcode: OUT t_opcodes; SIGNAL s_c_row_by_row: OUT t_op_std_logics; SIGNAL s_wren: OUT STD_LOGIC; SIGNAL s_syn_rst: OUT STD_LOGIC; SIGNAL s_finished: IN t_op_std_logics) IS
BEGIN
    REPORT infomsg("Starte Matrix-Multiplikation: Reg" & INTEGER'IMAGE(reg_c) & " = Reg" & INTEGER'IMAGE(reg_a) & " * Reg" & INTEGER'IMAGE(reg_b));
    exec_op(MatMul, wait_finish, 0, reg_a, reg_b, reg_c, row_by_row, s_sel_a, s_sel_b, s_sel_c, s_opcode, s_c_row_by_row, s_wren, s_syn_rst, s_finished);
END exec_mul;

PROCEDURE exec_add(wait_finish: BOOLEAN; reg_a: INTEGER; reg_b: INTEGER; reg_c: INTEGER; row_by_row: STD_LOGIC;SIGNAL s_sel_a: OUT t_mat_reg_ixs; SIGNAL s_sel_b: OUT t_mat_reg_ixs; SIGNAL s_sel_c: OUT t_mat_reg_ixs; SIGNAL s_opcode: OUT t_opcodes; SIGNAL s_c_row_by_row: OUT t_op_std_logics; SIGNAL s_wren: OUT STD_LOGIC; SIGNAL s_syn_rst: OUT STD_LOGIC; SIGNAL s_finished: IN t_op_std_logics) IS
BEGIN
    REPORT infomsg("Starte Matrix-Addition: Reg" & INTEGER'IMAGE(reg_c) & " = Reg" & INTEGER'IMAGE(reg_a) & " + Reg" & INTEGER'IMAGE(reg_b));
    exec_op(MatAdd, wait_finish, 0, reg_a, reg_b, reg_c, row_by_row, s_sel_a, s_sel_b, s_sel_c, s_opcode, s_c_row_by_row, s_wren, s_syn_rst, s_finished);
END exec_add;

PROCEDURE exec_trans(wait_finish: BOOLEAN; reg_a: INTEGER; reg_b: INTEGER; reg_c: INTEGER; row_by_row: STD_LOGIC;SIGNAL s_sel_a: OUT t_mat_reg_ixs; SIGNAL s_sel_b: OUT t_mat_reg_ixs; SIGNAL s_sel_c: OUT t_mat_reg_ixs; SIGNAL s_opcode: OUT t_opcodes; SIGNAL s_c_row_by_row: OUT t_op_std_logics; SIGNAL s_wren: OUT STD_LOGIC; SIGNAL s_syn_rst: OUT STD_LOGIC; SIGNAL s_finished: IN t_op_std_logics) IS
BEGIN
    REPORT infomsg("Starte Matrix-Transponierung: Reg" & INTEGER'IMAGE(reg_c) & " = Trans(Reg" & INTEGER'IMAGE(reg_a) & ")");
    exec_op(MatTrans, wait_finish, 0, reg_a, reg_b, reg_c, row_by_row, s_sel_a, s_sel_b, s_sel_c, s_opcode, s_c_row_by_row, s_wren, s_syn_rst, s_finished);
END exec_trans;

PROCEDURE exec_scalar_mul(scalar: REAL; wait_finish: BOOLEAN; reg_a: INTEGER; reg_b: INTEGER; reg_c: INTEGER; row_by_row: STD_LOGIC; SIGNAL s_scalar: OUT t_mat_elem_slv; SIGNAL s_sel_a: OUT t_mat_reg_ixs; SIGNAL s_sel_b: OUT t_mat_reg_ixs; SIGNAL s_sel_c: OUT t_mat_reg_ixs; SIGNAL s_opcode: OUT t_opcodes; SIGNAL s_c_row_by_row: OUT t_op_std_logics; SIGNAL s_wren: OUT STD_LOGIC; SIGNAL s_syn_rst: OUT STD_LOGIC; SIGNAL s_finished: IN t_op_std_logics) IS
BEGIN
    REPORT infomsg("Starte Skalare Multiplikation: Reg" & INTEGER'IMAGE(reg_c) & " = Reg" & INTEGER'IMAGE(reg_a) & " * " & REAL'IMAGE(scalar));
    s_scalar <= to_slv(to_mat_elem(scalar));
    exec_op(ScalarMul, wait_finish, 1, reg_a, reg_b, reg_c, row_by_row, s_sel_a, s_sel_b, s_sel_c, s_opcode, s_c_row_by_row, s_wren, s_syn_rst, s_finished);
END exec_scalar_mul;

PROCEDURE exec_scalar_div(wait_finish: BOOLEAN; reg_a: INTEGER; reg_b: INTEGER; reg_c: INTEGER; row_by_row: STD_LOGIC;SIGNAL s_sel_a: OUT t_mat_reg_ixs; SIGNAL s_sel_b: OUT t_mat_reg_ixs; SIGNAL s_sel_c: OUT t_mat_reg_ixs; SIGNAL s_opcode: OUT t_opcodes; SIGNAL s_c_row_by_row: OUT t_op_std_logics; SIGNAL s_wren: OUT STD_LOGIC; SIGNAL s_syn_rst: OUT STD_LOGIC; SIGNAL s_finished: IN t_op_std_logics) IS
BEGIN
    REPORT infomsg("Starte Skalare Division: Reg" & INTEGER'IMAGE(reg_c) & " = Reg" & INTEGER'IMAGE(reg_a) & " / 64");
    exec_op(ScalarDiv, wait_finish, 1, reg_a, reg_b, reg_c, row_by_row, s_sel_a, s_sel_b, s_sel_c, s_opcode, s_c_row_by_row, s_wren, s_syn_rst, s_finished);
END exec_scalar_div;

PROCEDURE exec_scalar_max(wait_finish: BOOLEAN; reg_a: INTEGER; reg_b: INTEGER; reg_c: INTEGER; row_by_row: STD_LOGIC;SIGNAL s_sel_a: OUT t_mat_reg_ixs; SIGNAL s_sel_b: OUT t_mat_reg_ixs; SIGNAL s_sel_c: OUT t_mat_reg_ixs; SIGNAL s_opcode: OUT t_opcodes; SIGNAL s_c_row_by_row: OUT t_op_std_logics; SIGNAL s_wren: OUT STD_LOGIC; SIGNAL s_syn_rst: OUT STD_LOGIC; SIGNAL s_finished: IN t_op_std_logics) IS
BEGIN
    REPORT infomsg("Starte Skalares Maximum: Reg" & INTEGER'IMAGE(reg_c) & " = Max(Reg" & INTEGER'IMAGE(reg_a) & " ,0.0)");
    exec_op(ScalarMax, wait_finish, 1, reg_a, reg_b, reg_c, row_by_row, s_sel_a, s_sel_b, s_sel_c, s_opcode, s_c_row_by_row, s_wren, s_syn_rst, s_finished);
END exec_scalar_max;

PROCEDURE exec_vec_add(wait_finish: BOOLEAN; reg_a: INTEGER; reg_b: INTEGER; reg_c: INTEGER; row_by_row: STD_LOGIC;SIGNAL s_sel_a: OUT t_mat_reg_ixs; SIGNAL s_sel_b: OUT t_mat_reg_ixs; SIGNAL s_sel_c: OUT t_mat_reg_ixs; SIGNAL s_opcode: OUT t_opcodes; SIGNAL s_c_row_by_row: OUT t_op_std_logics; SIGNAL s_wren: OUT STD_LOGIC; SIGNAL s_syn_rst: OUT STD_LOGIC; SIGNAL s_finished: IN t_op_std_logics) IS
BEGIN
    REPORT infomsg("Starte Matrix-Vector-Addition: Reg" & INTEGER'IMAGE(reg_c) & " = Reg" & INTEGER'IMAGE(reg_a) & " + Reg" & INTEGER'IMAGE(reg_b));
    exec_op(VecAdd, wait_finish, 0, reg_a, reg_b, reg_c, row_by_row, s_sel_a, s_sel_b, s_sel_c, s_opcode, s_c_row_by_row, s_wren, s_syn_rst, s_finished);
END exec_vec_add;

PROCEDURE exec_col_sum(wait_finish: BOOLEAN; reg_a: INTEGER; reg_b: INTEGER; reg_c: INTEGER; row_by_row: STD_LOGIC;SIGNAL s_sel_a: OUT t_mat_reg_ixs; SIGNAL s_sel_b: OUT t_mat_reg_ixs; SIGNAL s_sel_c: OUT t_mat_reg_ixs; SIGNAL s_opcode: OUT t_opcodes; SIGNAL s_c_row_by_row: OUT t_op_std_logics; SIGNAL s_wren: OUT STD_LOGIC; SIGNAL s_syn_rst: OUT STD_LOGIC; SIGNAL s_finished: IN t_op_std_logics) IS
BEGIN
    REPORT infomsg("Starte Matrix-ColSum: Reg" & INTEGER'IMAGE(reg_c) & " = ColSum(Reg" & INTEGER'IMAGE(reg_a) & ")");
    exec_op(ColSum, wait_finish, 1, reg_a, reg_b, reg_c, row_by_row, s_sel_a, s_sel_b, s_sel_c, s_opcode, s_c_row_by_row, s_wren, s_syn_rst, s_finished);
END exec_col_sum;

PROCEDURE exec_scalar_sub_ix(wait_finish: BOOLEAN; reg_a: INTEGER; reg_b: INTEGER; reg_c: INTEGER; row_by_row: STD_LOGIC; SIGNAL s_sel_a: OUT t_mat_reg_ixs; SIGNAL s_sel_b: OUT t_mat_reg_ixs; SIGNAL s_sel_c: OUT t_mat_reg_ixs; SIGNAL s_opcode: OUT t_opcodes; SIGNAL s_c_row_by_row: OUT t_op_std_logics; SIGNAL s_wren: OUT STD_LOGIC; SIGNAL s_syn_rst: OUT STD_LOGIC; SIGNAL s_finished: IN t_op_std_logics) IS
BEGIN
    REPORT infomsg("Starte Skalare Subtraktion");
    exec_op(ScalarSubIx, wait_finish, 1, reg_a, reg_b, reg_c, row_by_row, s_sel_a, s_sel_b, s_sel_c, s_opcode, s_c_row_by_row, s_wren, s_syn_rst, s_finished);
END exec_scalar_sub_ix;

PROCEDURE test_mul(SIGNAL s_write_a0: OUT STD_LOGIC; SIGNAL s_read_a0: OUT STD_LOGIC; SIGNAL s_size_a0_i: OUT t_mat_size; SIGNAL s_size_a0_o: IN t_mat_size; SIGNAL s_row_by_row_a0_i: OUT STD_LOGIC; SIGNAL s_row_by_row_a0_o: IN STD_LOGIC; SIGNAL s_ix_a0: OUT t_mat_ix; SIGNAL s_data_a0_i: OUT t_mat_word; SIGNAL s_data_a0_o: IN t_mat_word; SIGNAL s_sel_a: OUT t_mat_reg_ixs; SIGNAL s_sel_b: OUT t_mat_reg_ixs; SIGNAL s_sel_c: OUT t_mat_reg_ixs; SIGNAL s_opcode: OUT t_opcodes; SIGNAL s_c_row_by_row: OUT t_op_std_logics; SIGNAL s_wren: OUT STD_LOGIC; SIGNAL s_syn_rst: OUT STD_LOGIC; SIGNAL s_finished: IN t_op_std_logics) IS
BEGIN
    REPORT infomsg("Test: Matrix-Multiplikation");

    REPORT infomsg(test_prefix & "Test 1: Reg0(2x3) * Reg1(3x3)");
    init_mat_2x3_rbr(0, s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a(0));
    init_mat_3x3_cbc(1, s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a(0));
    exec_mul(TRUE, 0, 1, 2, '1', s_sel_a, s_sel_b, s_sel_c, s_opcode, s_c_row_by_row, s_wren, s_syn_rst, s_finished);

    init_mat_result_2x3_mul_3x3_rbr(3, s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a(0));
--    print_mat_reg(0, s_sel_a(0), s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o);
--    print_mat_reg(1, s_sel_a(0), s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o);
--    print_mat_reg(2, s_sel_a(0), s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o);
--    print_mat_reg(3, s_sel_a(0), s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o);
    assert_mat_reg_eq(2, 3, s_sel_a(0), s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o);
    
    REPORT infomsg(test_prefix & "Test 2: Reg0(2x36) * Reg1(36x3)");
    init_mat_2x36_rbr(0, s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a(0));
    init_mat_36x3_cbc(1, s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a(0));
    exec_mul(TRUE, 0, 1, 2, '1', s_sel_a, s_sel_b, s_sel_c, s_opcode, s_c_row_by_row, s_wren, s_syn_rst, s_finished);
    init_mat_result_2x36_mul_36x3_rbr(3, s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a(0));
    assert_mat_reg_eq(2, 3, s_sel_a(0), s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o);
  
    REPORT infomsg(test_prefix & "Test 3: A(36x1) * B(1x2) (C Spaltenweise)");
    init_mat_36x1_rbr(0, s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a(0));
    init_mat_1x2_cbc(1, s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a(0));
    exec_mul(TRUE, 0, 1, 2, '0', s_sel_a, s_sel_b, s_sel_c, s_opcode, s_c_row_by_row, s_wren, s_syn_rst, s_finished);
    init_mat_result_36x1_mul_1x2_cbc(3, s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a(0));
    assert_mat_reg_eq(2, 3, s_sel_a(0), s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o);

    REPORT infomsg("Test: Matrix-Multiplikation BEENDET");
END test_mul;

PROCEDURE test_add(SIGNAL s_write_a0: OUT STD_LOGIC; SIGNAL s_read_a0: OUT STD_LOGIC; SIGNAL s_size_a0_i: OUT t_mat_size; SIGNAL s_size_a0_o: IN t_mat_size; SIGNAL s_row_by_row_a0_i: OUT STD_LOGIC; SIGNAL s_row_by_row_a0_o: IN STD_LOGIC; SIGNAL s_ix_a0: OUT t_mat_ix; SIGNAL s_data_a0_i: OUT t_mat_word; SIGNAL s_data_a0_o: IN t_mat_word; SIGNAL s_sel_a: OUT t_mat_reg_ixs; SIGNAL s_sel_b: OUT t_mat_reg_ixs; SIGNAL s_sel_c: OUT t_mat_reg_ixs; SIGNAL s_opcode: OUT t_opcodes; SIGNAL s_c_row_by_row: OUT t_op_std_logics; SIGNAL s_wren: OUT STD_LOGIC; SIGNAL s_syn_rst: OUT STD_LOGIC; SIGNAL s_finished: IN t_op_std_logics) IS
BEGIN
    REPORT infomsg("Test: Matrix-Addition");
    
    REPORT infomsg(test_prefix & "Test 1: Zeilenweise Addition: a0 + a0");
    init_mat_a0_64x64_rbr(0, s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a(0));
    init_mat_a0_64x64_rbr(1, s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a(0));
    exec_add(TRUE, 0, 1, 2, '1', s_sel_a, s_sel_b, s_sel_c, s_opcode, s_c_row_by_row, s_wren, s_syn_rst, s_finished);
    init_mat_result_a0_add_a0(3, s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a(0));
    assert_mat_reg_eq(2, 3, s_sel_a(0), s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o);

    REPORT infomsg(test_prefix & "Test 2: Destruktive Addition: a0 + a0");
    init_mat_a0_64x64_rbr(0, s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a(0));
    init_mat_a0_64x64_rbr(1, s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a(0));
    exec_add(TRUE, 0, 1, 0, '1', s_sel_a, s_sel_b, s_sel_c, s_opcode, s_c_row_by_row, s_wren, s_syn_rst, s_finished);
    init_mat_result_a0_add_a0(3, s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a(0));
    assert_mat_reg_eq(0, 3, s_sel_a(0), s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o);

    REPORT infomsg(test_prefix & "Test 3: Spaltenweise Addition: a1 + a1");
    init_mat_a1_64x64_cbc(0, s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a(0));
    init_mat_a1_64x64_cbc(1, s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a(0));
    exec_add(TRUE, 0, 1, 2, '0', s_sel_a, s_sel_b, s_sel_c, s_opcode, s_c_row_by_row, s_wren, s_syn_rst, s_finished);
    init_mat_result_a1_add_a1(3, s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a(0));
    assert_mat_reg_eq(2, 3, s_sel_a(0), s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o);
    
    REPORT infomsg("Test: Matrix-Addition BEENDET");
END test_add;

PROCEDURE test_trans(SIGNAL s_write_a0: OUT STD_LOGIC; SIGNAL s_read_a0: OUT STD_LOGIC; SIGNAL s_size_a0_i: OUT t_mat_size; SIGNAL s_size_a0_o: IN t_mat_size; SIGNAL s_row_by_row_a0_i: OUT STD_LOGIC; SIGNAL s_row_by_row_a0_o: IN STD_LOGIC; SIGNAL s_ix_a0: OUT t_mat_ix; SIGNAL s_data_a0_i: OUT t_mat_word; SIGNAL s_data_a0_o: IN t_mat_word; SIGNAL s_sel_a: OUT t_mat_reg_ixs; SIGNAL s_sel_b: OUT t_mat_reg_ixs; SIGNAL s_sel_c: OUT t_mat_reg_ixs; SIGNAL s_opcode: OUT t_opcodes; SIGNAL s_c_row_by_row: OUT t_op_std_logics; SIGNAL s_wren: OUT STD_LOGIC; SIGNAL s_syn_rst: OUT STD_LOGIC; SIGNAL s_finished: IN t_op_std_logics) IS
BEGIN
    REPORT infomsg("Test: Matrix-Transponierung");
    
    REPORT infomsg(test_prefix & "Test 1: Transponierung Zeilenweise: trans(a0)");
    init_mat_a0_64x64_rbr(0, s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a(0));
    exec_trans(TRUE, 0, 1, 2, '1', s_sel_a, s_sel_b, s_sel_c, s_opcode, s_c_row_by_row, s_wren, s_syn_rst, s_finished);
    init_mat_result_a0_trans(3, s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a(0));
    assert_mat_reg_eq(2, 3, s_sel_a(0), s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o);
    
    REPORT infomsg(test_prefix & "Test 2: Transponierung Spaltenweise: trans(a1)");
    init_mat_a1_64x64_cbc(0, s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a(0));
    exec_trans(TRUE, 0, 1, 2, '0', s_sel_a, s_sel_b, s_sel_c, s_opcode, s_c_row_by_row, s_wren, s_syn_rst, s_finished);
    init_mat_result_a1_trans(3, s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a(0));
    assert_mat_reg_eq(2, 3, s_sel_a(0), s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o);
    
    REPORT infomsg("Test: Matrix-Transponierung BEENDET");
END test_trans;

PROCEDURE test_flip(SIGNAL s_write_a0: OUT STD_LOGIC; SIGNAL s_read_a0: OUT STD_LOGIC; SIGNAL s_size_a0_i: OUT t_mat_size; SIGNAL s_size_a0_o: IN t_mat_size; SIGNAL s_row_by_row_a0_i: OUT STD_LOGIC; SIGNAL s_row_by_row_a0_o: IN STD_LOGIC; SIGNAL s_ix_a0: OUT t_mat_ix; SIGNAL s_data_a0_i: OUT t_mat_word; SIGNAL s_data_a0_o: IN t_mat_word; SIGNAL s_sel_a: OUT t_mat_reg_ixs; SIGNAL s_sel_b: OUT t_mat_reg_ixs; SIGNAL s_sel_c: OUT t_mat_reg_ixs; SIGNAL s_opcode: OUT t_opcodes; SIGNAL s_c_row_by_row: OUT t_op_std_logics; SIGNAL s_wren: OUT STD_LOGIC; SIGNAL s_syn_rst: OUT STD_LOGIC; SIGNAL s_finished: IN t_op_std_logics) IS
BEGIN
    REPORT infomsg("Test: Matrix-Orientierung aendern");
    
    REPORT infomsg(test_prefix & "Test 1: Zeilenweise -> Spaltenweise: flip(a0)");
    init_mat_a0_64x64_rbr(0, s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a(0));
    exec_trans(TRUE, 0, 1, 2, '0', s_sel_a, s_sel_b, s_sel_c, s_opcode, s_c_row_by_row, s_wren, s_syn_rst, s_finished);
    init_mat_result_a1_trans(3, s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a(0));
    assert_mat_reg_eq(2, 3, s_sel_a(0), s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o);
    
    REPORT infomsg(test_prefix & "Test 2: Spaltenweise -> Zeilenweise: flip(a1)");
    init_mat_a1_64x64_cbc(0, s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a(0));
    exec_trans(TRUE, 0, 1, 2, '1', s_sel_a, s_sel_b, s_sel_c, s_opcode, s_c_row_by_row, s_wren, s_syn_rst, s_finished);
    init_mat_result_a0_trans(3, s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a(0));
    assert_mat_reg_eq(2, 3, s_sel_a(0), s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o);
    
    REPORT infomsg("Test: Matrix-Orientierung aendern BEENDET");
END test_flip;
    
PROCEDURE test_scalar_mul(SIGNAL s_data_port_mode : OUT t_data_port_mode; SIGNAL s_scalar : OUT t_mat_elem_slv; SIGNAL s_write_a0: OUT STD_LOGIC; SIGNAL s_read_a0: OUT STD_LOGIC; SIGNAL s_size_a0_i: OUT t_mat_size; SIGNAL s_size_a0_o: IN t_mat_size; SIGNAL s_row_by_row_a0_i: OUT STD_LOGIC; SIGNAL s_row_by_row_a0_o: IN STD_LOGIC; SIGNAL s_ix_a0: OUT t_mat_ix; SIGNAL s_data_a0_i: OUT t_mat_word; SIGNAL s_data_a0_o: IN t_mat_word; SIGNAL s_sel_a: OUT t_mat_reg_ixs; SIGNAL s_sel_b: OUT t_mat_reg_ixs; SIGNAL s_sel_c: OUT t_mat_reg_ixs; SIGNAL s_opcode: OUT t_opcodes; SIGNAL s_c_row_by_row: OUT t_op_std_logics; SIGNAL s_wren: OUT STD_LOGIC; SIGNAL s_syn_rst: OUT STD_LOGIC; SIGNAL s_finished: IN t_op_std_logics) IS
BEGIN
    REPORT infomsg("Test: Skalare Multiplikation");
    s_data_port_mode <= DPMScalarMul;
    
    REPORT infomsg(test_prefix & "Test 1: a0 * 2");
    init_mat_a0_64x64_rbr(0, s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a(0));
    exec_scalar_mul(2.0, TRUE, 0, 1, 2, '1', s_scalar, s_sel_a, s_sel_b, s_sel_c, s_opcode, s_c_row_by_row, s_wren, s_syn_rst, s_finished);
    init_mat_result_a0_add_a0(3, s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a(0));
    assert_mat_reg_eq(2, 3, s_sel_a(0), s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o); 
   
    REPORT infomsg(test_prefix & "Test 2: Destruktive Variante: a0 * 2");
    init_mat_a0_64x64_rbr(0, s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a(0));
    exec_scalar_mul(2.0, TRUE, 0, 1, 0, '1', s_scalar, s_sel_a, s_sel_b, s_sel_c, s_opcode, s_c_row_by_row, s_wren, s_syn_rst, s_finished);
    init_mat_result_a0_add_a0(2, s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a(0)); 
    assert_mat_reg_eq(0, 2, s_sel_a(0), s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o);   

    REPORT infomsg("Test: Skalare Multiplikation BEENDET");
END test_scalar_mul;

PROCEDURE test_scalar_div(SIGNAL s_write_a0: OUT STD_LOGIC; SIGNAL s_read_a0: OUT STD_LOGIC; SIGNAL s_size_a0_i: OUT t_mat_size; SIGNAL s_size_a0_o: IN t_mat_size; SIGNAL s_row_by_row_a0_i: OUT STD_LOGIC; SIGNAL s_row_by_row_a0_o: IN STD_LOGIC; SIGNAL s_ix_a0: OUT t_mat_ix; SIGNAL s_data_a0_i: OUT t_mat_word; SIGNAL s_data_a0_o: IN t_mat_word; SIGNAL s_sel_a: OUT t_mat_reg_ixs; SIGNAL s_sel_b: OUT t_mat_reg_ixs; SIGNAL s_sel_c: OUT t_mat_reg_ixs; SIGNAL s_opcode: OUT t_opcodes; SIGNAL s_c_row_by_row: OUT t_op_std_logics; SIGNAL s_wren: OUT STD_LOGIC; SIGNAL s_syn_rst: OUT STD_LOGIC; SIGNAL s_finished: IN t_op_std_logics) IS
BEGIN
    REPORT infomsg("Test: Skalare Division");
    
    REPORT infomsg(test_prefix & "Test 1: a0 / 64");
    init_mat_a2_64x64_rbr(0, s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a(0));
    exec_scalar_div(TRUE, 0, 1, 2, '1', s_sel_a, s_sel_b, s_sel_c, s_opcode, s_c_row_by_row, s_wren, s_syn_rst, s_finished);
    init_mat_result_a2_scalar_div(3, s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a(0));
    assert_mat_reg_eq(2, 3, s_sel_a(0), s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o);  
    
    REPORT infomsg("Test: Skalare Division BEENDET");
END test_scalar_div;

PROCEDURE test_scalar_max(SIGNAL s_write_a0: OUT STD_LOGIC; SIGNAL s_read_a0: OUT STD_LOGIC; SIGNAL s_size_a0_i: OUT t_mat_size; SIGNAL s_size_a0_o: IN t_mat_size; SIGNAL s_row_by_row_a0_i: OUT STD_LOGIC; SIGNAL s_row_by_row_a0_o: IN STD_LOGIC; SIGNAL s_ix_a0: OUT t_mat_ix; SIGNAL s_data_a0_i: OUT t_mat_word; SIGNAL s_data_a0_o: IN t_mat_word; SIGNAL s_sel_a: OUT t_mat_reg_ixs; SIGNAL s_sel_b: OUT t_mat_reg_ixs; SIGNAL s_sel_c: OUT t_mat_reg_ixs; SIGNAL s_opcode: OUT t_opcodes; SIGNAL s_c_row_by_row: OUT t_op_std_logics; SIGNAL s_wren: OUT STD_LOGIC; SIGNAL s_syn_rst: OUT STD_LOGIC; SIGNAL s_finished: IN t_op_std_logics) IS
BEGIN
    REPORT infomsg("Test: Skalares Maximum");
    
    REPORT infomsg(test_prefix & "Test 1: a0 * 2");
    init_mat_a0_64x64_rbr(0, s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a(0));
    exec_scalar_max(TRUE, 0, 1, 2, '1', s_sel_a, s_sel_b, s_sel_c, s_opcode, s_c_row_by_row, s_wren, s_syn_rst, s_finished);
    init_mat_result_a0_scalar_max(3, s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a(0));
    assert_mat_reg_eq(2, 3, s_sel_a(0), s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o);  
    
    REPORT infomsg("Test: Skalares Maximum BEENDET");
END test_scalar_max;


PROCEDURE test_vec_add(SIGNAL s_write_a0: OUT STD_LOGIC; SIGNAL s_read_a0: OUT STD_LOGIC; SIGNAL s_size_a0_i: OUT t_mat_size; SIGNAL s_size_a0_o: IN t_mat_size; SIGNAL s_row_by_row_a0_i: OUT STD_LOGIC; SIGNAL s_row_by_row_a0_o: IN STD_LOGIC; SIGNAL s_ix_a0: OUT t_mat_ix; SIGNAL s_data_a0_i: OUT t_mat_word; SIGNAL s_data_a0_o: IN t_mat_word; SIGNAL s_sel_a: OUT t_mat_reg_ixs; SIGNAL s_sel_b: OUT t_mat_reg_ixs; SIGNAL s_sel_c: OUT t_mat_reg_ixs; SIGNAL s_opcode: OUT t_opcodes; SIGNAL s_c_row_by_row: OUT t_op_std_logics; SIGNAL s_wren: OUT STD_LOGIC; SIGNAL s_syn_rst: OUT STD_LOGIC; SIGNAL s_finished: IN t_op_std_logics) IS
BEGIN
    REPORT infomsg("Test: Matrix-Vector-Addition");
    
    REPORT infomsg(test_prefix & "Test 1: Vector Addition: a0 + a3");
    init_mat_a0_64x64_rbr(0, s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a(0));
    init_mat_a3_1x64_rbr(1, s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a(0));
    exec_vec_add(TRUE, 0, 1, 2, '1', s_sel_a, s_sel_b, s_sel_c, s_opcode, s_c_row_by_row, s_wren, s_syn_rst, s_finished);
    init_mat_result_a0_vec_add_a3(3, s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a(0));
    assert_mat_reg_eq(2, 3, s_sel_a(0), s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o);

    REPORT infomsg(test_prefix & "Test 2: Destruktive Addition: a0 + a3");
    init_mat_a0_64x64_rbr(0, s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a(0));
    init_mat_a3_1x64_rbr(1, s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a(0));
    exec_vec_add(TRUE, 0, 1, 0, '1', s_sel_a, s_sel_b, s_sel_c, s_opcode, s_c_row_by_row, s_wren, s_syn_rst, s_finished);
    init_mat_result_a0_vec_add_a3(3, s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a(0));
    assert_mat_reg_eq(0, 3, s_sel_a(0), s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o);
       
    REPORT infomsg("Test: Matrix-Vector-Addition BEENDET");
END test_vec_add;

PROCEDURE test_col_sum(SIGNAL s_write_a0: OUT STD_LOGIC; SIGNAL s_read_a0: OUT STD_LOGIC; SIGNAL s_size_a0_i: OUT t_mat_size; SIGNAL s_size_a0_o: IN t_mat_size; SIGNAL s_row_by_row_a0_i: OUT STD_LOGIC; SIGNAL s_row_by_row_a0_o: IN STD_LOGIC; SIGNAL s_ix_a0: OUT t_mat_ix; SIGNAL s_data_a0_i: OUT t_mat_word; SIGNAL s_data_a0_o: IN t_mat_word; SIGNAL s_sel_a: OUT t_mat_reg_ixs; SIGNAL s_sel_b: OUT t_mat_reg_ixs; SIGNAL s_sel_c: OUT t_mat_reg_ixs; SIGNAL s_opcode: OUT t_opcodes; SIGNAL s_c_row_by_row: OUT t_op_std_logics; SIGNAL s_wren: OUT STD_LOGIC; SIGNAL s_syn_rst: OUT STD_LOGIC; SIGNAL s_finished: IN t_op_std_logics) IS
BEGIN
    REPORT infomsg("Test: ColSum");
    
    REPORT infomsg(test_prefix & "Test 1: ColSum(a1) Row-by-Row");
    init_mat_a1_64x64_cbc(0, s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a(0));
    delete_reg(2, s_sel_a(0), s_write_a0, s_data_a0_i, s_ix_a0, s_row_by_row_a0_i);
    exec_col_sum(TRUE, 0, 1, 2, '1', s_sel_a, s_sel_b, s_sel_c, s_opcode, s_c_row_by_row, s_wren, s_syn_rst, s_finished);
    init_mat_result_a1_col_sum_rbr(3, s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a(0));

    assert_mat_reg_eq(2, 3, s_sel_a(0), s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o);

    REPORT infomsg(test_prefix & "Test 2: ColSum(a1) Col-by-Col");
    init_mat_a1_64x64_cbc(0, s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a(0));
    delete_reg(2, s_sel_a(0), s_write_a0, s_data_a0_i, s_ix_a0, s_row_by_row_a0_i);
    exec_col_sum(TRUE, 0, 1, 2, '0', s_sel_a, s_sel_b, s_sel_c, s_opcode, s_c_row_by_row, s_wren, s_syn_rst, s_finished);
    init_mat_result_a1_col_sum_cbc(3, s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a(0));
    assert_mat_reg_eq(2, 3, s_sel_a(0), s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o);

    REPORT infomsg("Test: ColSum BEENDET");
END test_col_sum;

PROCEDURE test_scalar_sub_ix(SIGNAL s_data_port_mode : OUT t_data_port_mode; SIGNAL s_ix_arr_data_i : OUT STD_LOGIC_VECTOR (7 DOWNTO 0); SIGNAL s_ix_addr_write : OUT STD_LOGIC_VECTOR (5 DOWNTO 0); SIGNAL s_ix_arr_wren : OUT STD_LOGIC; SIGNAL s_write_a0: OUT STD_LOGIC; SIGNAL s_read_a0: OUT STD_LOGIC; SIGNAL s_size_a0_i: OUT t_mat_size; SIGNAL s_size_a0_o: IN t_mat_size; SIGNAL s_row_by_row_a0_i: OUT STD_LOGIC; SIGNAL s_row_by_row_a0_o: IN STD_LOGIC; SIGNAL s_ix_a0: OUT t_mat_ix; SIGNAL s_data_a0_i: OUT t_mat_word; SIGNAL s_data_a0_o: IN t_mat_word; SIGNAL s_sel_a: OUT t_mat_reg_ixs; SIGNAL s_sel_b: OUT t_mat_reg_ixs; SIGNAL s_sel_c: OUT t_mat_reg_ixs; SIGNAL s_opcode: OUT t_opcodes; SIGNAL s_c_row_by_row: OUT t_op_std_logics; SIGNAL s_wren: OUT STD_LOGIC; SIGNAL s_syn_rst: OUT STD_LOGIC; SIGNAL s_finished: IN t_op_std_logics) IS
BEGIN
    REPORT infomsg("Test: ScalarSubIx");
    
    REPORT infomsg(test_prefix & "Test 1: ScalarSubIx(a1)");  
    s_data_port_mode <= DPMScalarSubIx;
    init_ix_array_scalar_sub_ix(s_ix_arr_data_i, s_ix_addr_write, s_ix_arr_wren);
    
    init_mat_a0_64x64_rbr(0, s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a(0));
    exec_scalar_sub_ix(TRUE, 0, 1, 0, '1', s_sel_a, s_sel_b, s_sel_c, s_opcode, s_c_row_by_row, s_wren, s_syn_rst, s_finished);
    init_mat_result_a0_scalar_sub_ix(3, s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a(0));
    assert_mat_reg_eq(0, 3, s_sel_a(0), s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o);

    REPORT infomsg("Test: ScalarSubIx BEENDET");
END test_scalar_sub_ix;

PROCEDURE test_parallel(SIGNAL s_data_port_mode : OUT t_data_port_mode; SIGNAL s_scalar : OUT t_mat_elem_slv; SIGNAL s_write_a0: OUT STD_LOGIC; SIGNAL s_read_a0: OUT STD_LOGIC; SIGNAL s_size_a0_i: OUT t_mat_size; SIGNAL s_size_a0_o: IN t_mat_size; SIGNAL s_row_by_row_a0_i: OUT STD_LOGIC; SIGNAL s_row_by_row_a0_o: IN STD_LOGIC; SIGNAL s_ix_a0: OUT t_mat_ix; SIGNAL s_data_a0_i: OUT t_mat_word; SIGNAL s_data_a0_o: IN t_mat_word; SIGNAL s_sel_a: OUT t_mat_reg_ixs; SIGNAL s_sel_b: OUT t_mat_reg_ixs; SIGNAL s_sel_c: OUT t_mat_reg_ixs; SIGNAL s_opcode: OUT t_opcodes; SIGNAL s_c_row_by_row: OUT t_op_std_logics; SIGNAL s_wren: OUT STD_LOGIC; SIGNAL s_syn_rst: OUT STD_LOGIC; SIGNAL s_finished: IN t_op_std_logics) IS
BEGIN
    REPORT infomsg("Test: Parallele Operations-Ausfuerhrung");
    s_data_port_mode <= DPMScalarMul;
    
    REPORT infomsg(test_prefix & "Test 1: Mul/ScalarMul/Trans");
    
    -- MatMul Operanden
    init_mat_36x1_rbr(0, s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a(0));
    init_mat_1x2_cbc(1, s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a(0));
    delete_reg(2, s_sel_a(0), s_write_a0, s_data_a0_i, s_ix_a0, s_row_by_row_a0_i);
    -- ScalarMul Operand
    init_mat_a0_64x64_rbr(2, s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a(0));

    -- Ausfuehren der Operationen
    exec_mul(FALSE, 0, 1, 5, '0', s_sel_a, s_sel_b, s_sel_c, s_opcode, s_c_row_by_row, s_wren, s_syn_rst, s_finished);
    exec_scalar_mul(2.0, FALSE, 2, 0, 2, '1', s_scalar, s_sel_a, s_sel_b, s_sel_c, s_opcode, s_c_row_by_row, s_wren, s_syn_rst, s_finished);
    
    wait_all_finished(s_opcode, s_wren, s_syn_rst, s_finished);
    
    REPORT infomsg(test_prefix & "Teste Ergebnis MatMul");
    init_mat_result_36x1_mul_1x2_cbc(3, s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a(0));
    assert_mat_reg_eq(5, 3, s_sel_a(0), s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o);
    REPORT infomsg(test_prefix & "Teste Ergebnis ScalarMul");
    init_mat_result_a0_add_a0(4, s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a(0));
    assert_mat_reg_eq(2, 4, s_sel_a(0), s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o);   
    
    REPORT infomsg("Test: Matrix-Parallele Operations-Ausfuehrung BEENDET");
END test_parallel;

---------------------------------------------
--  Signale
---------------------------------------------
SIGNAL s_data_port_mode : t_data_port_mode;

SIGNAL s_clk, s_rst, s_syn_rst, s_wren : STD_LOGIC;
SIGNAL s_finished : t_op_std_logics;
SIGNAL s_c_row_by_row : t_op_std_logics;
SIGNAL s_opcode : t_opcodes;
SIGNAL s_data_i, s_data_o : t_byte;

SIGNAL s_sel_a, s_sel_b, s_sel_c : t_mat_reg_ixs;

SIGNAL s_write_a0, s_read_a0 : STD_LOGIC;
SIGNAL s_data_a0_i, s_data_a0_o : t_mat_word;
SIGNAL s_ix_a0 : t_mat_ix;
SIGNAL s_size_a0_i, s_size_a0_o : t_mat_size;
SIGNAL s_row_by_row_a0_i, s_row_by_row_a0_o : STD_LOGIC;

SIGNAL s_mul_scalar : t_mat_elem_slv;
SIGNAL s_ix_arr_data_i, s_ix_arr_data_o : t_byte;
SIGNAL s_ix_addr_read, s_ix_addr_write : STD_LOGIC_VECTOR (5 DOWNTO 0);
SIGNAL s_ix_arr_wren : STD_LOGIC;


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
    p_data_i                => s_data_i,
    p_data_o                => s_data_o,

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

ix_array : e_ram_64_8
PORT MAP(
    clock => s_clk,
    data => s_ix_arr_data_i,
    rdaddress => s_ix_addr_read,
    wraddress => s_ix_addr_write,
    wren => s_ix_arr_wren,
    q => s_ix_arr_data_o
);

---------------------------------------------
--  Zuweisungen
---------------------------------------------
s_data_i <= s_ix_arr_data_o WHEN s_data_port_mode = DPMScalarSubIx ELSE s_mul_scalar;
s_ix_addr_read <= s_data_o(5 DOWNTO 0);

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
    
    s_write_a0 <= '0';
    s_read_a0 <= '0';
    s_data_a0_i <= c_mat_word_zero;
    s_ix_a0 <= to_mat_ix(0, 0);
    s_size_a0_i <= to_mat_size(7, 7);
    s_row_by_row_a0_i <= '1';
    s_data_port_mode <= DPMScalarMul;
    s_mul_scalar <= (OTHERS => '0');
    
    -- Ix Array
    s_ix_arr_data_i <= (OTHERS => '0');
    s_ix_addr_write <= (OTHERS => '0');
    s_ix_arr_wren <= '0';
   
    WAIT FOR c_clk_per;
    s_rst <= '0';
   
    REPORT infomsg("Initialisierung abgeschlossen");
    
    test_mul(s_write_a0, s_read_a0, s_size_a0_i, s_size_a0_o, s_row_by_row_a0_i, s_row_by_row_a0_o, s_ix_a0, s_data_a0_i, s_data_a0_o, s_sel_a, s_sel_b, s_sel_c, s_opcode, s_c_row_by_row, s_wren, s_syn_rst, s_finished);
    test_add(s_write_a0, s_read_a0, s_size_a0_i, s_size_a0_o, s_row_by_row_a0_i, s_row_by_row_a0_o, s_ix_a0, s_data_a0_i, s_data_a0_o, s_sel_a, s_sel_b, s_sel_c, s_opcode, s_c_row_by_row, s_wren, s_syn_rst, s_finished);
    test_trans(s_write_a0, s_read_a0, s_size_a0_i, s_size_a0_o, s_row_by_row_a0_i, s_row_by_row_a0_o, s_ix_a0, s_data_a0_i, s_data_a0_o, s_sel_a, s_sel_b, s_sel_c, s_opcode, s_c_row_by_row, s_wren, s_syn_rst, s_finished); 
    test_flip(s_write_a0, s_read_a0, s_size_a0_i, s_size_a0_o, s_row_by_row_a0_i, s_row_by_row_a0_o, s_ix_a0, s_data_a0_i, s_data_a0_o, s_sel_a, s_sel_b, s_sel_c, s_opcode, s_c_row_by_row, s_wren, s_syn_rst, s_finished); 
    test_scalar_mul(s_data_port_mode, s_mul_scalar, s_write_a0, s_read_a0, s_size_a0_i, s_size_a0_o, s_row_by_row_a0_i, s_row_by_row_a0_o, s_ix_a0, s_data_a0_i, s_data_a0_o, s_sel_a, s_sel_b, s_sel_c, s_opcode, s_c_row_by_row, s_wren, s_syn_rst, s_finished);
    test_scalar_div(s_write_a0, s_read_a0, s_size_a0_i, s_size_a0_o, s_row_by_row_a0_i, s_row_by_row_a0_o, s_ix_a0, s_data_a0_i, s_data_a0_o, s_sel_a, s_sel_b, s_sel_c, s_opcode, s_c_row_by_row, s_wren, s_syn_rst, s_finished);
    test_scalar_max(s_write_a0, s_read_a0, s_size_a0_i, s_size_a0_o, s_row_by_row_a0_i, s_row_by_row_a0_o, s_ix_a0, s_data_a0_i, s_data_a0_o, s_sel_a, s_sel_b, s_sel_c, s_opcode, s_c_row_by_row, s_wren, s_syn_rst, s_finished);
    test_vec_add(s_write_a0, s_read_a0, s_size_a0_i, s_size_a0_o, s_row_by_row_a0_i, s_row_by_row_a0_o, s_ix_a0, s_data_a0_i, s_data_a0_o, s_sel_a, s_sel_b, s_sel_c, s_opcode, s_c_row_by_row, s_wren, s_syn_rst, s_finished);
    test_col_sum(s_write_a0, s_read_a0, s_size_a0_i, s_size_a0_o, s_row_by_row_a0_i, s_row_by_row_a0_o, s_ix_a0, s_data_a0_i, s_data_a0_o, s_sel_a, s_sel_b, s_sel_c, s_opcode, s_c_row_by_row, s_wren, s_syn_rst, s_finished);
 
    test_scalar_sub_ix(s_data_port_mode, s_ix_arr_data_i, s_ix_addr_write, s_ix_arr_wren, s_write_a0, s_read_a0, s_size_a0_i, s_size_a0_o, s_row_by_row_a0_i, s_row_by_row_a0_o, s_ix_a0, s_data_a0_i, s_data_a0_o, s_sel_a, s_sel_b, s_sel_c, s_opcode, s_c_row_by_row, s_wren, s_syn_rst, s_finished);
    
    test_parallel(s_data_port_mode, s_mul_scalar, s_write_a0, s_read_a0, s_size_a0_i, s_size_a0_o, s_row_by_row_a0_i, s_row_by_row_a0_o, s_ix_a0, s_data_a0_i, s_data_a0_o, s_sel_a, s_sel_b, s_sel_c, s_opcode, s_c_row_by_row, s_wren, s_syn_rst, s_finished);
    
    REPORT infomsg("Testende");
    WAIT;
END PROCESS proc_test;

END ARCHITECTURE a_tb_mat_cpu;