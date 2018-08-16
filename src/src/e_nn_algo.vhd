LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
USE work.fixed_pkg.ALL;
USE work.pkg_tools.ALL;

ENTITY e_nn_algo IS       
    PORT (    
        p_rst_i                 : IN STD_LOGIC;
        p_clk_i                 : IN STD_LOGIC;
        p_syn_rst_i             : IN STD_LOGIC;
        
        p_do_train_i            : IN STD_LOGIC; -- 1 -> Training (kompletter Algo); 0-> Test
        p_finished_o            : OUT STD_LOGIC;
        
        p_ytrain_data_i         : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        p_ytrain_ix_o           : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
        
        p_sel_a_0_i             : IN t_mat_reg_ix;
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
END ENTITY e_nn_algo;

----------------------------------------------------------------------------------------------------
--  Architecture
----------------------------------------------------------------------------------------------------
ARCHITECTURE a_nn_algo OF e_nn_algo IS

----------------------------------------------------------------------------------------------------
--  Komponenten
----------------------------------------------------------------------------------------------------

COMPONENT e_mat_cpu
    PORT (    
        p_rst_i                 : IN STD_LOGIC;
        p_clk_i                 : IN STD_LOGIC;
        p_syn_rst_i             : IN STD_LOGIC;
        p_wren_i                : IN STD_LOGIC;
        
        p_finished_o            : OUT t_op_std_logics;
        p_opcode_i              : IN t_opcodes;
        p_data_i                : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        p_data_o                : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        
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

----------------------------------------------------------------------------------------------------
--  Signale
----------------------------------------------------------------------------------------------------
SIGNAL s_wren, s_step_finished, s_rst_cpu, s_rst_cpu_1 : STD_LOGIC;
SIGNAL s_finished, s_row_by_row_c : t_op_std_logics;
SIGNAL s_opcode : t_opcodes;
SIGNAL s_sel_a, s_sel_b, s_sel_c, s_sel_a_1 : t_mat_reg_ixs;
SIGNAL s_data_i, s_data_o : STD_LOGIC_VECTOR(7 DOWNTO 0);

SIGNAL s_mul_scalar : t_mat_elem;
SIGNAL s_last_algo_step : INTEGER;

----------------------------------------------------------------------------------------------------
--  Der Algorithmus
----------------------------------------------------------------------------------------------------
CONSTANT w1 : t_mat_reg_ix := to_mat_reg_ix(0);
CONSTANT b1 : t_mat_reg_ix := to_mat_reg_ix(1);
CONSTANT w2 : t_mat_reg_ix := to_mat_reg_ix(2);
CONSTANT b2 : t_mat_reg_ix := to_mat_reg_ix(3);

CONSTANT dw1 : t_mat_reg_ix := to_mat_reg_ix(4);
CONSTANT db1 : t_mat_reg_ix := to_mat_reg_ix(5);
CONSTANT dw2 : t_mat_reg_ix := to_mat_reg_ix(6);
CONSTANT db2 : t_mat_reg_ix := to_mat_reg_ix(7);

CONSTANT x_train : t_mat_reg_ix := to_mat_reg_ix(6);
CONSTANT x_train_t : t_mat_reg_ix := to_mat_reg_ix(5);
CONSTANT w2_t : t_mat_reg_ix := to_mat_reg_ix(4);

CONSTANT d : t_mat_reg_ix := to_mat_reg_ix(7);
CONSTANT hl : t_mat_reg_ix := to_mat_reg_ix(7);
CONSTANT hl_ReLu : t_mat_reg_ix := to_mat_reg_ix(7);
CONSTANT d2 : t_mat_reg_ix := to_mat_reg_ix(8);
CONSTANT scores : t_mat_reg_ix := to_mat_reg_ix(8);
CONSTANT dhidden : t_mat_reg_ix := to_mat_reg_ix(6);

CONSTANT tmp0 : t_mat_reg_ix := to_mat_reg_ix(10);
CONSTANT tmp1 : t_mat_reg_ix := to_mat_reg_ix(9); 
CONSTANT tmp2 : t_mat_reg_ix := to_mat_reg_ix(10);

CONSTANT dummy : t_mat_reg_ix := to_mat_reg_ix(0);

CONSTANT s_program : t_program(0 TO 17) := (
    ((MatMul, x_train, w1, d, '1'),             c_noop_instr,                               c_noop_instr),
    ((VecAdd, d, b1, hl, '1'),                  c_noop_instr,                               (MatTrans, x_train, dummy, x_train_t, '1')),
    (c_noop_instr,                              (ScalarMax, hl, dummy, hl_ReLu, '1'),       c_noop_instr),
    ((MatMul, hl_ReLu, w2, d2, '1'),            c_noop_instr,                               c_noop_instr),
    ((VecAdd, d2, b2, scores, '1'),             c_noop_instr,                               (MatTrans, w2, dummy, w2_t, '0')), 
    (c_noop_instr,                              (ScalarMax, scores, dummy, scores, '1'),    c_noop_instr),
    (c_noop_instr,                              (ScalarSubIx, scores, dummy, scores, '1'),  c_noop_instr),
    (c_noop_instr,                              (ScalarDiv, scores, dummy, scores, '1'),    c_noop_instr),
    ((MatMul, scores, w2_t, dhidden, '0'),      c_noop_instr,                               c_noop_instr),
    (c_noop_instr,                              (ScalarMax, dhidden, dummy, dhidden, '0'),  c_noop_instr),
    ((MatMul, x_train_t, dhidden, dw1, '0'),    (ScalarMul, w1, dummy, tmp0, '0'),          (MatTrans, scores, dummy, tmp1, '0')),
    ((MatAdd, dw1, tmp0, dw1, '0'),             c_noop_instr,                               (ColSum, dhidden, dummy, db1, '1')),
    ((MatMul, hl_ReLu, tmp1, dw2, '0'),         (ScalarMul, dw1, dummy, dw1, '0'),          c_noop_instr),
    ((MatAdd, w1, dw1, w1, '0'),                (ScalarMul, w2, dummy, tmp2, '0'),          (ColSum, tmp1, dummy, db2, '1')),
    ((MatAdd, dw2, tmp2, dw2, '0'),             (ScalarMul, db1, dummy, db1, '1'),          c_noop_instr),
    ((MatAdd, b1, db1, b1, '1'),                (ScalarMul, dw2, dummy, dw2, '0'),          c_noop_instr),
    ((MatAdd, w2, dw2, w2, '0'),                (ScalarMul, db2, dummy, db2, '1'),          c_noop_instr),
    ((MatAdd, b2, db2, b2, '1'),                c_noop_instr,                               c_noop_instr)
);

CONSTANT test_algo_steps : INTEGER := 4;
CONSTANT train_algo_steps : INTEGER := 17;

CONSTANT c_scalar_opcore : INTEGER := 1;

CONSTANT c_scalar_mul_reg : t_mat_elem := to_mat_elem(0.125);
CONSTANT c_scalar_mul_stepsize : t_mat_elem := to_mat_elem(-0.125);

----------------------------------------------------------------------------------------------------
--  Port Maps
----------------------------------------------------------------------------------------------------
BEGIN

cpu : e_mat_cpu
PORT MAP(
    p_rst_i                 => p_rst_i,
    p_clk_i                 => p_clk_i,      
    p_syn_rst_i             => s_rst_cpu_1,
    p_wren_i                => s_wren,
    
    p_finished_o            => s_finished,
    p_opcode_i              => s_opcode,
    p_data_i                => s_data_i,
    p_data_o                => s_data_o,
    
    p_sel_a_i               => s_sel_a_1,
    p_sel_b_i               => s_sel_b,
    p_sel_c_i               => s_sel_c,
    p_row_by_row_c_i        => s_row_by_row_c,
    
    p_write_a0_i            => p_write_a0_i,
    p_read_a0_i             => p_read_a0_i,
    p_data_a0_i             => p_data_a0_i,
    p_data_a0_o             => p_data_a0_o,
    p_ix_a0_i               => p_ix_a0_i,
    p_size_a0_i             => p_size_a0_i,
    p_row_by_row_a0_i       => p_row_by_row_a0_i,
    p_size_a0_o             => p_size_a0_o,
    p_row_by_row_a0_o       => p_row_by_row_a0_o
);

----------------------------------------------------------------------------------------------------
--  Zuweisungen
----------------------------------------------------------------------------------------------------

s_rst_cpu_1 <= p_syn_rst_i OR s_rst_cpu;
s_sel_a_1 <= (p_sel_a_0_i, (OTHERS => '0'), (OTHERS => '0')) WHEN (p_write_a0_i OR p_read_a0_i) = '1' ELSE s_sel_a;

s_last_algo_step <= train_algo_steps WHEN p_do_train_i = '1' ELSE test_algo_steps;
s_step_finished <= s_finished(0) XNOR s_finished(1) XNOR s_finished(2);
p_ytrain_ix_o <= s_data_o(5 DOWNTO 0);
s_data_i <= p_ytrain_data_i WHEN s_opcode(c_scalar_opcore) = ScalarSubIx ELSE t_mat_elem_slv(s_mul_scalar); -- Bestimmt, welcher zusaetzliche Operand (p_data_i) verwendet wird

----------------------------------------------------------------------------------------------------
--  Prozesse
----------------------------------------------------------------------------------------------------

-- Bestimmt den Operanden der Skalaren Multiplikation
proc_scalar : PROCESS(s_sel_a)
BEGIN
    IF s_sel_a(c_scalar_opcore) = w1 OR s_sel_a(c_scalar_opcore) = w2 THEN
        s_mul_scalar <= c_scalar_mul_reg;
    ELSE
        s_mul_scalar <= c_scalar_mul_stepsize;
    END IF;
END PROCESS proc_scalar;


proc_prog_interpreter : PROCESS(p_rst_i, p_clk_i, p_syn_rst_i, s_last_algo_step)
VARIABLE pc : INTEGER := 0;
BEGIN    
    IF p_rst_i = '1' THEN      
        pc := 0; 
        s_wren  <= '0';
        s_opcode <= (NoOp, NoOp, NoOp);
        s_sel_a <= (OTHERS => (OTHERS => '-'));
        s_sel_b <= (OTHERS => (OTHERS => '-'));
        s_sel_c <= (OTHERS => (OTHERS => '-'));
        s_row_by_row_c <= (OTHERS => '-');              
        p_finished_o <= '0'; 
        s_rst_cpu <= '1';
    ELSIF RISING_EDGE(p_clk_i) THEN
    
        -- Default values
        s_wren  <= '0';
        s_opcode <= (NoOp, NoOp, NoOp);
        s_sel_a <= (OTHERS => (OTHERS => '-'));
        s_sel_b <= (OTHERS => (OTHERS => '-'));
        s_sel_c <= (OTHERS => (OTHERS => '-'));
        s_row_by_row_c <= (OTHERS => '-');              
        p_finished_o <= '0'; 
        s_rst_cpu <= '1';
    
        IF p_syn_rst_i = '1' THEN
            pc := 0;
        ELSIF pc <= s_last_algo_step THEN 
            IF s_step_finished = '0' THEN
                s_wren  <= '1';
                FOR core IN s_program(pc)'RANGE LOOP
                    s_opcode(core) <= s_program(pc)(core).opcode;
                    s_sel_a(core) <= s_program(pc)(core).sel_a; 
                    s_sel_b(core) <= s_program(pc)(core).sel_b; 
                    s_sel_c(core) <= s_program(pc)(core).sel_c; 
                    s_row_by_row_c(core) <= s_program(pc)(core).row_by_row;
                END LOOP;
                s_rst_cpu <= '0';
                pc := pc;
            ELSE
                pc := pc + 1;
            END IF;
        ELSE
            pc := pc;
            p_finished_o <= '1';          
        END IF;
    END IF;
END PROCESS proc_prog_interpreter;


END ARCHITECTURE a_nn_algo;