----------------------------------------------------------------------------------------------------
--  Testbench fuer e_mat_cpu 
--  Fuehrt einen Algorithmus aus (entspricht dem Algorithmus aus e_nn_algo)
--  Simulationszeit: 35 ms
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

ENTITY tb_mat_cpu_algo IS
END ENTITY tb_mat_cpu_algo;

ARCHITECTURE a_tb_mat_cpu_algo OF tb_mat_cpu_algo IS

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
--  Signale
---------------------------------------------
TYPE t_data_port_mode IS (DPMScalarSubIx, DPMScalarMul);
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
SIGNAL s_ytrain_data_i, s_ytrain_data_o : t_byte;
SIGNAL s_ytrain_read, s_ytrain_write : STD_LOGIC_VECTOR(5 DOWNTO 0);
SIGNAL s_ytrain_wren : STD_LOGIC;

CONSTANT w1 : t_mat_reg_ix := to_mat_reg_ix(0);
CONSTANT b1 : t_mat_reg_ix := to_mat_reg_ix(1);
CONSTANT w2 : t_mat_reg_ix := to_mat_reg_ix(2);
CONSTANT b2 : t_mat_reg_ix := to_mat_reg_ix(3);

CONSTANT dw1 : t_mat_reg_ix := to_mat_reg_ix(4);
CONSTANT db1 : t_mat_reg_ix := to_mat_reg_ix(5);
CONSTANT dw2 : t_mat_reg_ix := to_mat_reg_ix(6);
CONSTANT db2 : t_mat_reg_ix := to_mat_reg_ix(7);

CONSTANT x_train : t_mat_reg_ix := to_mat_reg_ix(4);
CONSTANT x_train_t : t_mat_reg_ix := to_mat_reg_ix(5);
CONSTANT w2_t : t_mat_reg_ix := to_mat_reg_ix(4);

CONSTANT d : t_mat_reg_ix := to_mat_reg_ix(7);
CONSTANT hl : t_mat_reg_ix := to_mat_reg_ix(7);
CONSTANT hl_ReLu : t_mat_reg_ix := to_mat_reg_ix(7);
CONSTANT d2 : t_mat_reg_ix := to_mat_reg_ix(8);
CONSTANT scores : t_mat_reg_ix := to_mat_reg_ix(8);
CONSTANT dhidden : t_mat_reg_ix := to_mat_reg_ix(6);

CONSTANT scores2 : t_mat_reg_ix := to_mat_reg_ix(9);
CONSTANT w1_reg : t_mat_reg_ix := to_mat_reg_ix(8); 
CONSTANT w2_reg : t_mat_reg_ix := to_mat_reg_ix(8);

CONSTANT dummy : t_mat_reg_ix := to_mat_reg_ix(0);

CONSTANT s_program : t_program(0 TO 18) := (
    ((MatMul, x_train, w1, d, '1'),                 c_noop_instr),
    ((VecAdd, d, b1, hl, '1'),                      c_noop_instr),
    ((MatTrans, x_train, dummy, x_train_t, '1'),    (ScalarMax, hl, dummy, hl_ReLu, '1')),
    ((MatMul, hl_ReLu, w2, d2, '1'),                c_noop_instr),
    ((VecAdd, d2, b2, scores, '1'),                 c_noop_instr), 
    ((MatTrans, w2, dummy, w2_t, '0'),              (ScalarMax, scores, dummy, scores, '1')),
    (c_noop_instr,                                  (ScalarSubIx, scores, dummy, scores, '1')),
    (c_noop_instr,                                  (ScalarDiv, scores, dummy, scores, '1')),
    ((MatMul, scores, w2_t, dhidden, '0'),          c_noop_instr),
    ((MatTrans, scores, dummy, scores2, '0'),       (ScalarMax, dhidden, dummy, dhidden, '0')),    
    ((MatMul, x_train_t, dhidden, dw1, '0'),        (ScalarMul, w1, dummy, w1_reg, '0')),
    ((MatAdd, dw1, w1_reg, dw1, '0'),               (ColSum, dhidden, dummy, db1, '1')),   
    ((MatMul, hl_ReLu, scores2, dw2, '0'),          (ScalarMul, dw1, dummy, dw1, '0')),
    ((MatAdd, w1, dw1, w1, '0'),                    (ScalarMul, w2, dummy, w2_reg, '0')),   
    ((MatAdd, dw2, w2_reg, dw2, '0'),               (ColSum, scores2, dummy, db2, '1')),
    (c_noop_instr,                                  (ScalarMul, dw2, dummy, dw2, '0')),
    ((MatAdd, w2, dw2, w2, '0'),                    (ScalarMul, db2, dummy, db2, '1')),
    ((MatAdd, b2, db2, b2, '1'),                    (ScalarMul, db1, dummy, db1, '1')),
    ((MatAdd, b1, db1, b1, '1'),                    c_noop_instr)
);

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

y_train : e_ram_64_8
PORT MAP(
    clock => s_clk,
    data => s_ytrain_data_i,
    rdaddress => s_ytrain_read,
    wraddress => s_ytrain_write,
    wren => s_ytrain_wren,
    q => s_ytrain_data_o
);

---------------------------------------------
--  Zuweisungen
---------------------------------------------

s_ytrain_read <= s_data_o(5 DOWNTO 0);

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

proc_cpu_data : PROCESS(s_data_port_mode, s_ytrain_data_o, s_mul_scalar)
BEGIN
    IF s_data_port_mode = DPMScalarSubIx THEN
        s_data_i <= s_ytrain_data_o; 
    ELSE
        s_data_i <= s_mul_scalar; -- Scalare Multiplication
    END IF;
END PROCESS proc_cpu_data;

proc_scalar : PROCESS(s_sel_a)
BEGIN
    IF s_sel_a(1) = w1 OR s_sel_a(1) = w2 THEN
        s_mul_scalar <= t_mat_elem_slv(to_mat_elem(0.125)); -- reg
    ELSE
        s_mul_scalar <= t_mat_elem_slv(to_mat_elem(-0.125)); -- -step size
    END IF;
END PROCESS proc_scalar;

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
   
    s_ytrain_data_i <= (OTHERS => '0');
    s_ytrain_write <= (OTHERS => '0');
    s_ytrain_wren <= '0';

    WAIT FOR c_clk_per;
    s_rst <= '0';
   
    REPORT infomsg("Initialisierung abgeschlossen");
    
    init_mat_x_train_rbr(4, s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a(0));
 
    init_mat_b1_rbr(1, s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a(0));
    init_mat_b2_rbr(3, s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a(0));
    init_mat_w1_cbc(0, s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a(0));
    init_mat_w2_cbc(2, s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a(0));
    init_y_train(s_ytrain_data_i, s_ytrain_write, s_ytrain_wren);
    
    save_mat_reg_to_file("IN w1.txt", 0, s_sel_a(0), s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o);
    save_mat_reg_to_file("IN b1.txt", 1, s_sel_a(0), s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o);
    save_mat_reg_to_file("IN w2.txt", 2, s_sel_a(0), s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o);
    save_mat_reg_to_file("IN b2.txt", 3, s_sel_a(0), s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o);
    
    FOR pc IN s_program'RANGE LOOP
        REPORT infomsg("Fuehre Algorithmus-Schritt " & INTEGER'IMAGE(pc) & " aus ...");
        FOR core IN s_program(pc)'RANGE LOOP
            s_opcode(core) <= s_program(pc)(core).opcode;
            s_sel_a(core) <= s_program(pc)(core).sel_a; 
            s_sel_b(core) <= s_program(pc)(core).sel_b; 
            s_sel_c(core) <= s_program(pc)(core).sel_c; 
            s_c_row_by_row(core) <= s_program(pc)(core).row_by_row;
        END LOOP;
        
        IF s_program(pc)(1).opcode = ScalarSubIx THEN
            s_data_port_mode <= DPMScalarSubIx;
        ELSE
            s_data_port_mode <= DPMScalarMul;
        END IF;
        
        s_syn_rst <= '1'; 
        WAIT FOR c_clk_per;  
        s_wren  <= '1';
        s_syn_rst <= '0';  
        
        WAIT UNTIL s_finished = "11";
        WAIT FOR c_clk_per / 2;
        s_wren  <= '0';
        s_opcode <= (NoOp, NoOp);
        
        REPORT infomsg("... fertig");
        IF pc = 0 THEN
            save_mat_reg_to_file("00 d.txt", 7, s_sel_a(0), s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o);
            save_mat_reg_to_file("00 w2.txt", 2, s_sel_a(0), s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o);
            save_mat_reg_to_file("00 w1.txt", 0, s_sel_a(0), s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o);
            save_mat_reg_to_file("00 b1.txt", 1, s_sel_a(0), s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o);
            save_mat_reg_to_file("00 b2.txt", 3, s_sel_a(0), s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o);
        ELSIF pc = 1 THEN
            save_mat_reg_to_file("01 hl.txt", 7, s_sel_a(0), s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o);
        ELSIF pc = 2 THEN
            save_mat_reg_to_file("02 hl_ReLu.txt", 7, s_sel_a(0), s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o);
            save_mat_reg_to_file("02 x_train_trans.txt", 5, s_sel_a(0), s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o);
        ELSIF pc = 3 THEN
            save_mat_reg_to_file("03 d2.txt", 8, s_sel_a(0), s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o);
        ELSIF pc = 4 THEN
            save_mat_reg_to_file("04 scores.txt", 8, s_sel_a(0), s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o);      
        ELSIF pc = 5 THEN
            save_mat_reg_to_file("05 scores.txt", 8, s_sel_a(0), s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o);
            save_mat_reg_to_file("05 w2_t.txt", 4, s_sel_a(0), s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o);
        ELSIF pc = 6 THEN
            save_mat_reg_to_file("06 scores.txt", 8, s_sel_a(0), s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o);
        ELSIF pc = 7 THEN
            save_mat_reg_to_file("07 scores.txt", 8, s_sel_a(0), s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o);
        ELSIF pc = 8 THEN
            save_mat_reg_to_file("08 dhidden.txt", 6, s_sel_a(0), s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o);
        ELSIF pc = 9 THEN
            save_mat_reg_to_file("09 dhidden.txt", 6, s_sel_a(0), s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o);
            save_mat_reg_to_file("09 tmp0.txt", 9, s_sel_a(0), s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o);
        ELSIF pc = 10 THEN
            save_mat_reg_to_file("10 dw1.txt", 4, s_sel_a(0), s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o);
            save_mat_reg_to_file("10 tmp1.txt", 8, s_sel_a(0), s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o);
        ELSIF pc = 11 THEN
            save_mat_reg_to_file("11 db1.txt", 5, s_sel_a(0), s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o);
            save_mat_reg_to_file("11 dw1.txt", 4, s_sel_a(0), s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o);    
        ELSIF pc = 12 THEN
            save_mat_reg_to_file("12 dw2.txt", 6, s_sel_a(0), s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o);
            save_mat_reg_to_file("12 dw1.txt", 4, s_sel_a(0), s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o);    
        ELSIF pc = 13 THEN
            save_mat_reg_to_file("13 w1.txt", 0, s_sel_a(0), s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o);
            save_mat_reg_to_file("13 tmp2.txt", 8, s_sel_a(0), s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o); 
        ELSIF pc = 14 THEN
            save_mat_reg_to_file("14 db2.txt", 7, s_sel_a(0), s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o);  
            save_mat_reg_to_file("14 dw2.txt", 6, s_sel_a(0), s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o);  
        ELSIF pc = 15 THEN
            save_mat_reg_to_file("15 dw2.txt", 6, s_sel_a(0), s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o);  
        ELSIF pc = 16 THEN
            save_mat_reg_to_file("16 w2.txt", 2, s_sel_a(0), s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o);
            save_mat_reg_to_file("16 db2.txt", 7, s_sel_a(0), s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o); 
        ELSIF pc = 17 THEN
            save_mat_reg_to_file("17 b2.txt", 3, s_sel_a(0), s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o);
            save_mat_reg_to_file("17 db1.txt", 5, s_sel_a(0), s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o);
        ELSIF pc = 18 THEN
            save_mat_reg_to_file("18 b1.txt", 1, s_sel_a(0), s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o);
        ELSE
            save_mat_reg_to_file("dummy.txt", 7, s_sel_a(0), s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o);
        END IF;
    
    END LOOP;
    
    
      
    REPORT infomsg("Testende");
    WAIT;
END PROCESS proc_test;

END ARCHITECTURE a_tb_mat_cpu_algo;