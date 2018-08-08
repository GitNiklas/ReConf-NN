----------------------------------------------------------------------------------------------------
--  Testbench fuer e_mat_cpu 
--      Fuehrt den NN-Algo aus
--  Simulationszeit: ??
--
--  Autor: Niklas Kuehl
--  Datum: 06.08.2018
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
        p_data_i                : IN STD_LOGIC_VECTOR(7 DOWNTO 0);

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
--  Signale
---------------------------------------------
SIGNAL s_clk, s_rst, s_syn_rst, s_wren : STD_LOGIC;
SIGNAL s_finished : t_op_std_logics;
SIGNAL s_c_row_by_row : t_op_std_logics;
SIGNAL s_opcode : t_opcodes;
SIGNAL s_data : STD_LOGIC_VECTOR(7 DOWNTO 0);

SIGNAL s_sel_a, s_sel_b, s_sel_c : t_mat_reg_ixs;

SIGNAL s_write_a0, s_read_a0 : STD_LOGIC;
SIGNAL s_data_a0_i, s_data_a0_o : t_mat_word;
SIGNAL s_ix_a0 : t_mat_ix;
SIGNAL s_size_a0_i, s_size_a0_o : t_mat_size;
SIGNAL s_row_by_row_a0_i, s_row_by_row_a0_o : STD_LOGIC;

CONSTANT w1 : t_mat_reg_ix := to_mat_reg_ix(0);
CONSTANT b1 : t_mat_reg_ix := to_mat_reg_ix(1);
CONSTANT w2 : t_mat_reg_ix := to_mat_reg_ix(2);
CONSTANT b2 : t_mat_reg_ix := to_mat_reg_ix(3);

CONSTANT dw1 : t_mat_reg_ix := to_mat_reg_ix(4);
CONSTANT db1 : t_mat_reg_ix := to_mat_reg_ix(5);
CONSTANT dw2 : t_mat_reg_ix := to_mat_reg_ix(6);
CONSTANT db2 : t_mat_reg_ix := to_mat_reg_ix(7);

CONSTANT d2 : t_mat_reg_ix := to_mat_reg_ix(7);
CONSTANT scores : t_mat_reg_ix := to_mat_reg_ix(7);
CONSTANT d : t_mat_reg_ix := to_mat_reg_ix(9);
CONSTANT hl : t_mat_reg_ix := to_mat_reg_ix(9);
CONSTANT hl_ReLu : t_mat_reg_ix := to_mat_reg_ix(9);
CONSTANT x_train : t_mat_reg_ix := to_mat_reg_ix(5);
CONSTANT x_train_t : t_mat_reg_ix := to_mat_reg_ix(6);
CONSTANT w2_t : t_mat_reg_ix := to_mat_reg_ix(8);

CONSTANT dummy : t_mat_reg_ix := to_mat_reg_ix(0);

SIGNAL s_program : t_program(0 TO 5) := (
    ((MatMul, x_train, w1, d, '1'), c_noop_instr, c_noop_instr),
    ((MatAdd, b1, d, hl, '1'), c_noop_instr, (MatTrans, x_train, dummy, x_train_t, '1')),
    (c_noop_instr, (ScalarMax, hl, dummy, hl_ReLu, '1'), c_noop_instr),
    ((MatMul, hl_ReLu, w2, d2, '0'), c_noop_instr, c_noop_instr),
    ((MatAdd, b2, d2, scores, '1'), c_noop_instr, (MatTrans, w2, dummy, w2_t, '1')), 
    (c_noop_instr, (ScalarMax, scores, dummy, scores, '1'), c_noop_instr)
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
    p_data_i                => s_data,

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
    s_data <= (OTHERS => '0');
    
    s_write_a0 <= '0';
    s_read_a0 <= '0';
    s_data_a0_i <= c_mat_word_zero;
    s_ix_a0 <= to_mat_ix(0, 0);
    s_size_a0_i <= to_mat_size(7, 7);
    s_row_by_row_a0_i <= '1';
   
    WAIT FOR c_clk_per;
    s_rst <= '0';
   
    REPORT infomsg("Initialisierung abgeschlossen");
    init_mat_a0_64x64_rbr(0, s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a, s_sel_c, s_opcode, s_wren, s_syn_rst, s_finished);
    init_mat_a0_64x64_rbr(1, s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a, s_sel_c, s_opcode, s_wren, s_syn_rst, s_finished);
    init_mat_a0_64x64_rbr(2, s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a, s_sel_c, s_opcode, s_wren, s_syn_rst, s_finished);
    init_mat_a0_64x64_rbr(3, s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a, s_sel_c, s_opcode, s_wren, s_syn_rst, s_finished);
    init_mat_a0_64x64_rbr(4, s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a, s_sel_c, s_opcode, s_wren, s_syn_rst, s_finished);
    
    FOR pc IN s_program'RANGE LOOP
        FOR core IN s_program(pc)'RANGE LOOP
            s_opcode(core) <= s_program(pc)(core).opcode;
            s_sel_a(core) <= s_program(pc)(core).sel_a; 
            s_sel_b(core) <= s_program(pc)(core).sel_b; 
            s_sel_c(core) <= s_program(pc)(core).sel_c; 
            s_c_row_by_row(core) <= s_program(pc)(core).row_by_row;
        END LOOP;
        
        s_wren  <= '1';
        s_syn_rst <= '1';
        WAIT FOR c_clk_per;
        s_syn_rst <= '0';
        
        WAIT UNTIL s_finished = "111";
        WAIT FOR c_clk_per / 2;
        s_wren  <= '0';
        s_opcode <= (NoOp, NoOp, NoOp);
        REPORT infomsg("Operation abgeschlossen");
    END LOOP;

      
    REPORT infomsg("Testende");
    WAIT;
END PROCESS proc_test;

END ARCHITECTURE a_tb_mat_cpu_algo;