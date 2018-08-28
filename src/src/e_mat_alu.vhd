LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
USE work.fixed_pkg.ALL;
USE work.pkg_tools.ALL;
    
-- MatMul: A has to be line_by_line; B has to be row_by_row
-- MatAdd: A and B must have the same orientation
-- Other OPs: Egal
-- OpCores:
--   OpCore0: MatMul, MatAdd, VecAdd, NoOp
--   OpCore1: ScalarMul, ScalarDiv, ScalarMax, ScalarSubIx, NoOp
--   OpCore2: MatTrans, MatFlip, MatDel, ColSum, NoOp -- evtl ein 2. MatAdd
ENTITY e_mat_alu IS       
    PORT (    
        p_rst_i                 : IN STD_LOGIC;
        p_clk_i                 : IN STD_LOGIC;
        
        p_syn_rst_i             : IN STD_LOGIC;
        p_wren_i                : IN STD_LOGIC;
        p_finished_o            : OUT t_op_std_logics;
        
        p_opcode_i              : IN t_opcodes;
        p_data_i                : IN t_byte; -- scalar fuer scalarmul, ix fuer scalarsubix
        p_data_o                : OUT t_byte; -- ix fuer array bei scalarsubix
        
        p_mat_a_size_i          : IN t_mat_sizes;
        p_mat_a_ix_o            : OUT t_mat_ixs;
        p_mat_a_data_i          : IN t_mat_words;
        p_mat_a_row_by_row_i    : IN t_op_std_logics;
        
        p_mat_b_size_i          : IN t_mat_sizes;
        p_mat_b_ix_o            : OUT t_mat_ixs;
        p_mat_b_data_i          : IN t_mat_words;
        p_mat_b_row_by_row_i    : IN t_op_std_logics;

        p_mat_c_ix_o            : OUT t_mat_ixs; 
        p_mat_c_data_o          : OUT t_mat_words;
        p_mat_c_wren_o          : OUT t_op_std_logics;
        p_mat_c_row_by_row_i    : IN t_op_std_logics;
        p_mat_c_size_o          : OUT t_mat_sizes;
        p_mat_c_row_by_row_o    : OUT t_op_std_logics
    );
END ENTITY e_mat_alu;

----------------------------------------------------------------------------------------------------
--  Architecture
----------------------------------------------------------------------------------------------------
ARCHITECTURE a_mat_alu OF e_mat_alu IS

----------------------------------------------------------------------------------------------------
--  Komponenten
----------------------------------------------------------------------------------------------------

COMPONENT e_mat_mul
    PORT (    
        p_rst_i                 : IN STD_LOGIC;
        p_clk_i                 : IN STD_LOGIC;
        
        p_syn_rst_i             : IN STD_LOGIC;
        p_finished_o            : OUT STD_LOGIC;
        
        p_mat_a_size_i          : IN t_mat_size;
        p_mat_a_ix_o            : OUT t_mat_ix;
        p_mat_a_data_i          : IN t_mat_word; -- a has to be line_by_line
        
        p_mat_b_size_i          : IN t_mat_size;
        p_mat_b_ix_o            : OUT t_mat_ix;
        p_mat_b_data_i          : IN t_mat_word; -- b has to be row_by_row

        p_mat_c_ix_o            : OUT t_mat_ix; 
        p_mat_c_data_o          : OUT t_mat_word;
        p_mat_c_row_by_row_i    : IN STD_LOGIC;
        p_mat_c_size_o          : OUT t_mat_size
    );
END COMPONENT;

COMPONENT e_mat_add
    PORT (    
        p_rst_i                 : IN STD_LOGIC;
        p_clk_i                 : IN STD_LOGIC;
        
        p_syn_rst_i             : IN STD_LOGIC;
        p_finished_o            : OUT STD_LOGIC;
        p_vec_add_i             : IN STD_LOGIC;
        
        p_mat_a_size_i          : IN t_mat_size;
        p_mat_a_ix_o            : OUT t_mat_ix;
        p_mat_a_data_i          : IN t_mat_word;
        
        p_mat_b_ix_o            : OUT t_mat_ix;
        p_mat_b_data_i          : IN t_mat_word;

        p_mat_c_ix_o            : OUT t_mat_ix; 
        p_mat_c_data_o          : OUT t_mat_word;
        p_mat_c_row_by_row_i    : IN STD_LOGIC;
        p_mat_c_size_o          : OUT t_mat_size
    );
END COMPONENT;

COMPONENT e_mat_del       
    PORT (    
        p_rst_i                 : IN STD_LOGIC;
        p_clk_i                 : IN STD_LOGIC;
        
        p_syn_rst_i             : IN STD_LOGIC;
        p_finished_o            : OUT STD_LOGIC;
        
        p_mat_c_ix_o            : OUT t_mat_ix; 
        p_mat_c_data_o          : OUT t_mat_word;
        p_mat_c_row_by_row_i    : IN STD_LOGIC;
        p_mat_c_size_o          : OUT t_mat_size
    );
END COMPONENT;

COMPONENT e_mat_trans     
    PORT (    
        p_rst_i                 : IN STD_LOGIC;
        p_clk_i                 : IN STD_LOGIC;
        
        p_syn_rst_i             : IN STD_LOGIC;
        p_finished_o            : OUT STD_LOGIC;
        
        p_mat_a_size_i          : IN t_mat_size;
        p_mat_a_ix_o            : OUT t_mat_ix;
        p_mat_a_row_by_row_i    : IN STD_LOGIC;
        p_mat_a_data_i          : IN t_mat_word;
        
        p_mat_c_ix_o            : OUT t_mat_ix; 
        p_mat_c_data_o          : OUT t_mat_word;
        p_mat_c_row_by_row_i    : IN STD_LOGIC;
        p_mat_c_size_o          : OUT t_mat_size
    );
END COMPONENT;

COMPONENT e_mat_col_sum
    PORT (    
        p_rst_i                 : IN STD_LOGIC;
        p_clk_i                 : IN STD_LOGIC;
        
        p_syn_rst_i             : IN STD_LOGIC;
        p_finished_o            : OUT STD_LOGIC;
        
        p_mat_a_size_i          : IN t_mat_size;
        p_mat_a_ix_o            : OUT t_mat_ix;
        p_mat_a_row_by_row_i    : IN STD_LOGIC;
        p_mat_a_data_i          : IN t_mat_word;
        
        p_mat_c_ix_o            : OUT t_mat_ix; 
        p_mat_c_data_o          : OUT t_mat_word;
        p_mat_c_row_by_row_i    : IN STD_LOGIC;
        p_mat_c_size_o          : OUT t_mat_size
    );
END COMPONENT;

COMPONENT e_mat_scalar_mul
    PORT (    
        p_rst_i                 : IN STD_LOGIC;
        p_clk_i                 : IN STD_LOGIC;
        
        p_syn_rst_i             : IN STD_LOGIC;
        p_finished_o            : OUT STD_LOGIC;
        
        p_scalar_i              : IN t_byte;
        
        p_mat_a_size_i          : IN t_mat_size;
        p_mat_a_ix_o            : OUT t_mat_ix;
        p_mat_a_data_i          : IN t_mat_word;
        
        p_mat_c_ix_o            : OUT t_mat_ix; 
        p_mat_c_data_o          : OUT t_mat_word;
        p_mat_c_row_by_row_i    : IN STD_LOGIC;
        p_mat_c_size_o          : OUT t_mat_size
    );
END COMPONENT;

COMPONENT e_mat_scalar_div
    PORT (    
        p_rst_i                 : IN STD_LOGIC;
        p_clk_i                 : IN STD_LOGIC;
        
        p_syn_rst_i             : IN STD_LOGIC;
        p_finished_o            : OUT STD_LOGIC;
        
        p_mat_a_size_i          : IN t_mat_size;
        p_mat_a_ix_o            : OUT t_mat_ix;
        p_mat_a_data_i          : IN t_mat_word;
        
        p_mat_c_ix_o            : OUT t_mat_ix; 
        p_mat_c_data_o          : OUT t_mat_word;
        p_mat_c_row_by_row_i    : IN STD_LOGIC;
        p_mat_c_size_o          : OUT t_mat_size
    );
END COMPONENT;

COMPONENT e_mat_scalar_max
    GENERIC(scalar : t_mat_elem := to_mat_elem(0.0));   
    PORT (    
        p_rst_i                 : IN STD_LOGIC;
        p_clk_i                 : IN STD_LOGIC;
        
        p_syn_rst_i             : IN STD_LOGIC;
        p_finished_o            : OUT STD_LOGIC;
            
        p_mat_a_size_i          : IN t_mat_size;
        p_mat_a_ix_o            : OUT t_mat_ix;
        p_mat_a_data_i          : IN t_mat_word;
        
        p_mat_c_ix_o            : OUT t_mat_ix; 
        p_mat_c_data_o          : OUT t_mat_word;
        p_mat_c_row_by_row_i    : IN STD_LOGIC;
        p_mat_c_size_o          : OUT t_mat_size
    );
END COMPONENT;

COMPONENT e_mat_scalar_sub_ix
    GENERIC(scalar : t_mat_elem := to_mat_elem(1.0));
    PORT (    
        p_rst_i                 : IN STD_LOGIC;
        p_clk_i                 : IN STD_LOGIC;
        
        p_syn_rst_i             : IN STD_LOGIC;
        p_finished_o            : OUT STD_LOGIC;
        
        p_ix_i                  : IN t_byte;
        p_ix_o                  : OUT t_byte; -- Index fuer ix-array
        
        p_mat_c_size_i          : IN t_mat_size;
        p_mat_c_r_ix_o          : OUT t_mat_ix;
        p_mat_c_data_i          : IN t_mat_word;
        
        p_mat_c_w_ix_o          : OUT t_mat_ix; 
        p_mat_c_data_o          : OUT t_mat_word;
        p_mat_c_size_o          : OUT t_mat_size
    );
END COMPONENT;

----------------------------------------------------------------------------------------------------
--  Signale
----------------------------------------------------------------------------------------------------
CONSTANT opcore_mul : INTEGER := 0;
CONSTANT opcore_add : INTEGER := 0;
CONSTANT opcore_del : INTEGER := 2;
CONSTANT opcore_trans : INTEGER := 2;
CONSTANT opcore_col_sum : INTEGER := 2;
CONSTANT opcore_scalar_mul : INTEGER := 1;
CONSTANT opcore_scalar_div : INTEGER := 1;
CONSTANT opcore_scalar_max : INTEGER := 1;
CONSTANT opcore_scalar_sub_ix : INTEGER := 1;

SIGNAL s_finished_t1, s_finished_t2, s_finished_t3 : t_op_std_logics;

SIGNAL s_mul_a_ix, s_add_a_ix, s_trans_a_ix, s_col_sum_a_ix, s_scalar_mul_a_ix, s_scalar_div_a_ix, s_scalar_max_a_ix, s_scalar_sub_ix_a_ix : t_mat_ix; 
SIGNAL s_mul_b_ix, s_add_b_ix : t_mat_ix;  
SIGNAL s_mul_c_ix, s_add_c_ix, s_del_c_ix, s_trans_c_ix, s_col_sum_c_ix, s_scalar_mul_c_ix, s_scalar_div_c_ix, s_scalar_max_c_ix, s_scalar_sub_ix_c_ix : t_mat_ix;
SIGNAL s_mul_c_data, s_add_c_data, s_del_c_data, s_trans_c_data, s_col_sum_c_data, s_scalar_mul_c_data, s_scalar_div_c_data, s_scalar_max_c_data, s_scalar_sub_ix_c_data : t_mat_word;
SIGNAL s_mul_finished, s_add_finished, s_del_finished, s_trans_finished, s_col_sum_finished, s_scalar_mul_finished, s_scalar_div_finished, s_scalar_max_finished, s_scalar_sub_ix_finished : STD_LOGIC;
SIGNAL s_mul_c_size, s_add_c_size, s_del_c_size, s_trans_c_size, s_col_sum_c_size, s_scalar_mul_c_size, s_scalar_div_c_size, s_scalar_max_c_size, s_scalar_sub_ix_c_size : t_mat_size;

SIGNAL s_vec_add : STD_LOGIC;

----------------------------------------------------------------------------------------------------
--  Port Maps
----------------------------------------------------------------------------------------------------
BEGIN

mat_mul : e_mat_mul
PORT MAP(
    p_rst_i                 => p_rst_i,
    p_clk_i                 => p_clk_i,
        
    p_syn_rst_i             => p_syn_rst_i,
    p_finished_o            => s_mul_finished,
    
    p_mat_a_size_i          => p_mat_a_size_i(opcore_mul),
    p_mat_a_ix_o            => s_mul_a_ix,
    p_mat_a_data_i          => p_mat_a_data_i(opcore_mul),
    
    p_mat_b_size_i          => p_mat_b_size_i(opcore_mul),
    p_mat_b_ix_o            => s_mul_b_ix,
    p_mat_b_data_i          => p_mat_b_data_i(opcore_mul),

    p_mat_c_ix_o            => s_mul_c_ix,
    p_mat_c_data_o          => s_mul_c_data,
    p_mat_c_row_by_row_i    => p_mat_c_row_by_row_i(opcore_mul),
    p_mat_c_size_o          => s_mul_c_size
);

mat_add : e_mat_add
PORT MAP(
    p_rst_i                 => p_rst_i,
    p_clk_i                 => p_clk_i,
        
    p_syn_rst_i             => p_syn_rst_i,
    p_finished_o            => s_add_finished,
    p_vec_add_i             => s_vec_add,

    p_mat_a_size_i          => p_mat_a_size_i(opcore_add),
    p_mat_a_ix_o            => s_add_a_ix,
    p_mat_a_data_i          => p_mat_a_data_i(opcore_add),
    
    p_mat_b_ix_o            => s_add_b_ix,
    p_mat_b_data_i          => p_mat_b_data_i(opcore_add),

    p_mat_c_ix_o            => s_add_c_ix,
    p_mat_c_data_o          => s_add_c_data,
    p_mat_c_row_by_row_i    => p_mat_c_row_by_row_i(opcore_add),
    p_mat_c_size_o          => s_add_c_size
);

mat_del : e_mat_del
PORT MAP(
    p_rst_i                 => p_rst_i,
    p_clk_i                 => p_clk_i,
        
    p_syn_rst_i             => p_syn_rst_i,
    p_finished_o            => s_del_finished,
    
    p_mat_c_ix_o            => s_del_c_ix,
    p_mat_c_data_o          => s_del_c_data,
    p_mat_c_row_by_row_i    => p_mat_c_row_by_row_i(opcore_del),
    p_mat_c_size_o          => s_del_c_size
);

mat_trans : e_mat_trans
PORT MAP(
    p_rst_i                 => p_rst_i,
    p_clk_i                 => p_clk_i,
        
    p_syn_rst_i             => p_syn_rst_i,
    p_finished_o            => s_trans_finished,
    
    p_mat_a_size_i          => p_mat_a_size_i(opcore_trans),
    p_mat_a_ix_o            => s_trans_a_ix,
    p_mat_a_row_by_row_i    => p_mat_a_row_by_row_i(opcore_trans),
    p_mat_a_data_i          => p_mat_a_data_i(opcore_trans),

    p_mat_c_ix_o            => s_trans_c_ix,
    p_mat_c_data_o          => s_trans_c_data,
    p_mat_c_row_by_row_i    => p_mat_c_row_by_row_i(opcore_trans),
    p_mat_c_size_o          => s_trans_c_size
);

mat_col_sum : e_mat_col_sum
PORT MAP(
    p_rst_i                 => p_rst_i,
    p_clk_i                 => p_clk_i,
        
    p_syn_rst_i             => p_syn_rst_i,
    p_finished_o            => s_col_sum_finished,
    
    p_mat_a_size_i          => p_mat_a_size_i(opcore_col_sum),
    p_mat_a_ix_o            => s_col_sum_a_ix,
    p_mat_a_row_by_row_i    => p_mat_a_row_by_row_i(opcore_col_sum),
    p_mat_a_data_i          => p_mat_a_data_i(opcore_col_sum),

    p_mat_c_ix_o            => s_col_sum_c_ix,
    p_mat_c_data_o          => s_col_sum_c_data,
    p_mat_c_row_by_row_i    => p_mat_c_row_by_row_i(opcore_col_sum),
    p_mat_c_size_o          => s_col_sum_c_size
);

mat_scalar_mul : e_mat_scalar_mul
PORT MAP(
    p_rst_i                 => p_rst_i,
    p_clk_i                 => p_clk_i,
        
    p_syn_rst_i             => p_syn_rst_i,
    p_finished_o            => s_scalar_mul_finished,
    
    p_scalar_i              => p_data_i,
    
    p_mat_a_size_i          => p_mat_a_size_i(opcore_scalar_mul),
    p_mat_a_ix_o            => s_scalar_mul_a_ix,
    p_mat_a_data_i          => p_mat_a_data_i(opcore_scalar_mul),
    
    p_mat_c_ix_o            => s_scalar_mul_c_ix,
    p_mat_c_data_o          => s_scalar_mul_c_data,
    p_mat_c_row_by_row_i    => p_mat_c_row_by_row_i(opcore_scalar_mul),
    p_mat_c_size_o          => s_scalar_mul_c_size
);

mat_scalar_div : e_mat_scalar_div
PORT MAP(
    p_rst_i                 => p_rst_i,
    p_clk_i                 => p_clk_i,
        
    p_syn_rst_i             => p_syn_rst_i,
    p_finished_o            => s_scalar_div_finished,
    
    p_mat_a_size_i          => p_mat_a_size_i(opcore_scalar_div),
    p_mat_a_ix_o            => s_scalar_div_a_ix,
    p_mat_a_data_i          => p_mat_a_data_i(opcore_scalar_div),
    
    p_mat_c_ix_o            => s_scalar_div_c_ix,
    p_mat_c_data_o          => s_scalar_div_c_data,
    p_mat_c_row_by_row_i    => p_mat_c_row_by_row_i(opcore_scalar_div),
    p_mat_c_size_o          => s_scalar_div_c_size
);

mat_scalar_max : e_mat_scalar_max
PORT MAP(
    p_rst_i                 => p_rst_i,
    p_clk_i                 => p_clk_i,
        
    p_syn_rst_i             => p_syn_rst_i,
    p_finished_o            => s_scalar_max_finished,
    
    p_mat_a_size_i          => p_mat_a_size_i(opcore_scalar_max),
    p_mat_a_ix_o            => s_scalar_max_a_ix,
    p_mat_a_data_i          => p_mat_a_data_i(opcore_scalar_max),
    
    p_mat_c_ix_o            => s_scalar_max_c_ix,
    p_mat_c_data_o          => s_scalar_max_c_data,
    p_mat_c_row_by_row_i    => p_mat_c_row_by_row_i(opcore_scalar_max),
    p_mat_c_size_o          => s_scalar_max_c_size
);

mat_scalar_sub_ix : e_mat_scalar_sub_ix
PORT MAP(
    p_rst_i                 => p_rst_i,
    p_clk_i                 => p_clk_i,
        
    p_syn_rst_i             => p_syn_rst_i,
    p_finished_o            => s_scalar_sub_ix_finished,
    
    p_ix_i                  => p_data_i,
    p_ix_o                  => p_data_o,
        
    p_mat_c_size_i          => p_mat_a_size_i(opcore_scalar_sub_ix),
    p_mat_c_r_ix_o          => s_scalar_sub_ix_a_ix,
    p_mat_c_data_i          => p_mat_a_data_i(opcore_scalar_sub_ix),
        
    p_mat_c_w_ix_o          => s_scalar_sub_ix_c_ix,
    p_mat_c_data_o          => s_scalar_sub_ix_c_data,
    p_mat_c_size_o          => s_scalar_sub_ix_c_size
);

----------------------------------------------------------------------------------------------------
--  Zuweisungen
----------------------------------------------------------------------------------------------------

generate_regs: 
FOR i IN c_num_parallel_op-1 DOWNTO 0 GENERATE
    f_reg(p_rst_i, p_clk_i, p_syn_rst_i, s_finished_t1(i), s_finished_t2(i));
    f_reg(p_rst_i, p_clk_i, p_syn_rst_i, s_finished_t2(i), s_finished_t3(i));
    p_mat_c_wren_o(i) <= p_wren_i AND NOT p_syn_rst_i AND NOT s_finished_t3(i);
    p_finished_o(i) <= s_finished_t3(i);
END GENERATE generate_regs;

p_mat_c_row_by_row_o    <= p_mat_c_row_by_row_i;

----------------------------------------------------------------------------------------------------
--  Prozesse
----------------------------------------------------------------------------------------------------

proc_opcore0 : PROCESS(p_opcode_i,
    s_mul_finished, s_mul_a_ix, s_mul_b_ix, s_mul_c_ix, s_mul_c_data, s_mul_c_size,
    s_add_finished, s_add_a_ix, s_add_b_ix, s_add_c_ix, s_add_c_data, s_add_c_size)
BEGIN
    CASE p_opcode_i(0) IS
        WHEN MatMul     =>  s_finished_t1(0)    <= s_mul_finished;
                            p_mat_a_ix_o(0)     <= s_mul_a_ix;
                            p_mat_b_ix_o(0)     <= s_mul_b_ix;
                            p_mat_c_ix_o(0)     <= s_mul_c_ix;
                            p_mat_c_data_o(0)   <= s_mul_c_data;
                            p_mat_c_size_o(0)   <= s_mul_c_size;
                            s_vec_add           <= '-';
                            
        WHEN MatAdd     =>  s_finished_t1(0)    <= s_add_finished;
                            p_mat_a_ix_o(0)     <= s_add_a_ix;
                            p_mat_b_ix_o(0)     <= s_add_b_ix;
                            p_mat_c_ix_o(0)     <= s_add_c_ix;
                            p_mat_c_data_o(0)   <= s_add_c_data;
                            p_mat_c_size_o(0)   <= s_add_c_size;
                            s_vec_add           <= '0';
                            
        WHEN VecAdd     =>  s_finished_t1(0)    <= s_add_finished;
                            p_mat_a_ix_o(0)     <= s_add_a_ix;
                            p_mat_b_ix_o(0)     <= s_add_b_ix;
                            p_mat_c_ix_o(0)     <= s_add_c_ix;
                            p_mat_c_data_o(0)   <= s_add_c_data;
                            p_mat_c_size_o(0)   <= s_add_c_size;
                            s_vec_add           <= '1';
                            
        WHEN OTHERS     =>  s_finished_t1(0)    <= '1';
                            p_mat_a_ix_o(0)     <= ((OTHERS => '-'), (OTHERS => '-'));
                            p_mat_b_ix_o(0)     <= ((OTHERS => '-'), (OTHERS => '-'));
                            p_mat_c_ix_o(0)     <= ((OTHERS => '-'), (OTHERS => '-'));
                            p_mat_c_data_o(0)   <= set_mat_word('-');
                            p_mat_c_size_o(0)   <= ((OTHERS => '-'), (OTHERS => '-'));
                            s_vec_add           <= '-';
                            IF p_opcode_i(0) /= NoOp THEN REPORT err("Nicht unterstuetze Operation auf Opcore 0"); END IF;
    END CASE;
END PROCESS proc_opcore0;

proc_opcore1 : PROCESS(p_opcode_i,
    s_scalar_mul_finished, s_scalar_mul_a_ix, s_scalar_mul_c_ix, s_scalar_mul_c_data, s_scalar_mul_c_size,
    s_scalar_div_finished, s_scalar_div_a_ix, s_scalar_div_c_ix, s_scalar_div_c_data, s_scalar_div_c_size,
    s_scalar_max_finished, s_scalar_max_a_ix, s_scalar_max_c_ix, s_scalar_max_c_data, s_scalar_max_c_size,
    s_scalar_sub_ix_finished, s_scalar_sub_ix_a_ix, s_scalar_sub_ix_c_ix, s_scalar_sub_ix_c_data, s_scalar_sub_ix_c_size)
BEGIN
    p_mat_b_ix_o(1)     <= c_mat_ix_zero;
    CASE p_opcode_i(1) IS
        WHEN ScalarMul  =>  s_finished_t1(1)    <= s_scalar_mul_finished;
                            p_mat_a_ix_o(1)     <= s_scalar_mul_a_ix;
                            p_mat_c_ix_o(1)     <= s_scalar_mul_c_ix;
                            p_mat_c_data_o(1)   <= s_scalar_mul_c_data;
                            p_mat_c_size_o(1)   <= s_scalar_mul_c_size;
 
        WHEN ScalarDiv  =>  s_finished_t1(1)    <= s_scalar_div_finished;
                            p_mat_a_ix_o(1)     <= s_scalar_div_a_ix;
                            p_mat_c_ix_o(1)     <= s_scalar_div_c_ix;
                            p_mat_c_data_o(1)   <= s_scalar_div_c_data;
                            p_mat_c_size_o(1)   <= s_scalar_div_c_size;
                            
        WHEN ScalarMax  =>  s_finished_t1(1)    <= s_scalar_max_finished;
                            p_mat_a_ix_o(1)     <= s_scalar_max_a_ix;   
                            p_mat_c_ix_o(1)     <= s_scalar_max_c_ix;
                            p_mat_c_data_o(1)   <= s_scalar_max_c_data;
                            p_mat_c_size_o(1)   <= s_scalar_max_c_size;
                            
        WHEN ScalarSubIx => s_finished_t1(1)    <= s_scalar_sub_ix_finished;
                            p_mat_a_ix_o(1)     <= s_scalar_sub_ix_a_ix;   
                            p_mat_c_ix_o(1)     <= s_scalar_sub_ix_c_ix;
                            p_mat_c_data_o(1)   <= s_scalar_sub_ix_c_data;
                            p_mat_c_size_o(1)   <= s_scalar_sub_ix_c_size;
                            
        WHEN OTHERS     =>  s_finished_t1(1)    <= '1';
                            p_mat_a_ix_o(1)     <= ((OTHERS => '-'), (OTHERS => '-'));
                            p_mat_c_ix_o(1)     <= ((OTHERS => '-'), (OTHERS => '-'));
                            p_mat_c_data_o(1)   <= set_mat_word('-');
                            p_mat_c_size_o(1)   <= ((OTHERS => '-'), (OTHERS => '-'));
                            IF p_opcode_i(1) /= NoOp THEN REPORT err("Nicht unterstuetze Operation auf Opcore 1"); END IF;
    END CASE;
END PROCESS proc_opcore1;

proc_opcore2 : PROCESS(p_opcode_i,
    s_del_finished, s_del_c_ix, s_del_c_data, s_del_c_size,
    s_trans_finished, s_trans_a_ix, s_trans_c_ix, s_trans_c_data, s_trans_c_size,
    s_col_sum_finished, s_col_sum_a_ix, s_col_sum_c_ix, s_col_sum_c_data, s_col_sum_c_size)
BEGIN
    p_mat_b_ix_o(2)     <= c_mat_ix_zero;
    CASE p_opcode_i(2) IS
        WHEN MatTrans   =>  s_finished_t1(2)    <= s_trans_finished;
                            p_mat_a_ix_o(2)     <= s_trans_a_ix;
                            p_mat_c_ix_o(2)     <= s_trans_c_ix;
                            p_mat_c_data_o(2)   <= s_trans_c_data;
                            p_mat_c_size_o(2)   <= s_trans_c_size;
                            
        WHEN MatDel     =>  s_finished_t1(2)    <= s_del_finished;
                            p_mat_a_ix_o(2)     <= s_trans_a_ix; -- Ein beliebiger Wert (Don't care erzeugt Fehler in Modelsim)
                            p_mat_c_ix_o(2)     <= s_del_c_ix;
                            p_mat_c_data_o(2)   <= s_del_c_data;
                            p_mat_c_size_o(2)   <= s_del_c_size;
                            
        WHEN ColSum     =>  s_finished_t1(2)    <= s_col_sum_finished;
                            p_mat_a_ix_o(2)     <= s_col_sum_a_ix;
                            p_mat_c_ix_o(2)     <= s_col_sum_c_ix;
                            p_mat_c_data_o(2)   <= s_col_sum_c_data;
                            p_mat_c_size_o(2)   <= s_col_sum_c_size;
                            
        WHEN OTHERS     =>  s_finished_t1(2)    <= '1';
                            p_mat_a_ix_o(2)     <= ((OTHERS => '-'), (OTHERS => '-'));
                            p_mat_c_ix_o(2)     <= ((OTHERS => '-'), (OTHERS => '-'));
                            p_mat_c_data_o(2)   <= set_mat_word('-');
                            p_mat_c_size_o(2)   <= ((OTHERS => '-'), (OTHERS => '-'));
                            IF p_opcode_i(2) /= NoOp THEN REPORT err("Nicht unterstuetze Operation auf Opcore 2"); END IF;
    END CASE;
END PROCESS proc_opcore2;

END ARCHITECTURE a_mat_alu;