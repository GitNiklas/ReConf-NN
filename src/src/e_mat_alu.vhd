LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
USE work.fixed_pkg.ALL;
USE work.pkg_tools.ALL;

-- fehlende OP:
    -- RowSum
-- MatMul: A has to be line_by_line; B has to be row_by_row
-- MatAdd: A and B must have the same orientation
-- Other OPs: Egal

-- Supported Operations:
-- Core0: MatAdd, VecAdd, ScalarDiv, ScalarMax, NoOp
-- Core1: MatTrans, MatDel, NoOp
-- Core2: ScalarMul, NoOp
-- Core4: MatMul
ENTITY e_mat_alu IS       
    PORT (    
        p_rst_i                 : IN STD_LOGIC;
        p_clk_i                 : IN STD_LOGIC;
        
        p_syn_rst_i             : IN STD_LOGIC;
        p_wren_i                : IN STD_LOGIC;
        p_finished_o            : OUT STD_LOGIC;
        
        p_opcode_i              : IN t_opcodes;
        p_scalar_i              : IN t_mat_elem;
        
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

COMPONENT e_mat_scalar_mul    
    PORT (    
        p_rst_i                 : IN STD_LOGIC;
        p_clk_i                 : IN STD_LOGIC;
        
        p_syn_rst_i             : IN STD_LOGIC;
        p_finished_o            : OUT STD_LOGIC;
        
        p_scalar_i              : IN t_mat_elem;
        
        p_mat_a_size_i          : IN t_mat_size;
        p_mat_a_ix_o            : OUT t_mat_ix;
        p_mat_a_data_i          : IN t_mat_word;
        
        p_mat_c_ix_o            : OUT t_mat_ix; 
        p_mat_c_data_o          : OUT t_mat_word;
        p_mat_c_size_o          : OUT t_mat_size
    );
END COMPONENT;

COMPONENT e_mat_scalar_div
    GENERIC(scalar : UNSIGNED(7 DOWNTO 0) := TO_UNSIGNED(c_batch_size, 8));
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
        p_mat_c_size_o          : OUT t_mat_size
    );
END COMPONENT;

----------------------------------------------------------------------------------------------------
--  Signale
----------------------------------------------------------------------------------------------------
SIGNAL s_finished_t1, s_finished_t2, s_finished_t3 : t_op_std_logics;

SIGNAL s_add_a_ix, s_scalar_div_a_ix, s_scalar_max_a_ix : t_mat_ix; 
SIGNAL s_add_c_ix, s_trans_c_ix, s_del_c_ix, s_scalar_div_c_ix, s_scalar_max_c_ix : t_mat_ix;
SIGNAL s_add_c_data, s_trans_c_data, s_del_c_data, s_scalar_div_c_data, s_scalar_max_c_data : t_mat_word;
SIGNAL s_mul_finished, s_add_finished, s_del_finished, s_trans_finished, s_scalar_mul_finished, s_scalar_div_finished, s_scalar_max_finished : STD_LOGIC;
SIGNAL s_add_c_size, s_trans_c_size, s_del_c_size, s_scalar_div_c_size, s_scalar_max_c_size : t_mat_size;

SIGNAL s_vec_add_mode : STD_LOGIC;

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
    
    p_mat_a_size_i          => p_mat_a_size_i(3),
    p_mat_a_ix_o            => p_mat_a_ix_o(3),
    p_mat_a_data_i          => p_mat_a_data_i(3),
    
    p_mat_b_size_i          => p_mat_b_size_i(3),
    p_mat_b_ix_o            => p_mat_b_ix_o(3),
    p_mat_b_data_i          => p_mat_b_data_i(3),

    p_mat_c_ix_o            => p_mat_c_ix_o(3),
    p_mat_c_data_o          => p_mat_c_data_o(3),
    p_mat_c_row_by_row_i    => p_mat_c_row_by_row_i(3),
    p_mat_c_size_o          => p_mat_c_size_o(3)
);

mat_add : e_mat_add
PORT MAP(
    p_rst_i                 => p_rst_i,
    p_clk_i                 => p_clk_i,
        
    p_syn_rst_i             => p_syn_rst_i,
    p_finished_o            => s_add_finished,
    
    p_vec_add_i             => s_vec_add_mode,

    p_mat_a_size_i          => p_mat_a_size_i(0),
    p_mat_a_ix_o            => s_add_a_ix,
    p_mat_a_data_i          => p_mat_a_data_i(0),
    
    p_mat_b_ix_o            => p_mat_b_ix_o(0),
    p_mat_b_data_i          => p_mat_b_data_i(0),

    p_mat_c_ix_o            => s_add_c_ix,
    p_mat_c_data_o          => s_add_c_data,
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
    p_mat_c_size_o          => s_del_c_size
);

mat_trans : e_mat_trans
PORT MAP(
    p_rst_i                 => p_rst_i,
    p_clk_i                 => p_clk_i,
        
    p_syn_rst_i             => p_syn_rst_i,
    p_finished_o            => s_trans_finished,
    
    p_mat_a_size_i          => p_mat_a_size_i(1),
    p_mat_a_ix_o            => p_mat_a_ix_o(1),
    p_mat_a_row_by_row_i    => p_mat_a_row_by_row_i(1),
    p_mat_a_data_i          => p_mat_a_data_i(1),

    p_mat_c_ix_o            => s_trans_c_ix,
    p_mat_c_data_o          => s_trans_c_data,
    p_mat_c_row_by_row_i    => p_mat_a_row_by_row_i(1),
    p_mat_c_size_o          => s_trans_c_size
);

mat_scalar_mul : e_mat_scalar_mul
PORT MAP(
    p_rst_i                 => p_rst_i,
    p_clk_i                 => p_clk_i,
        
    p_syn_rst_i             => p_syn_rst_i,
    p_finished_o            => s_scalar_mul_finished,
    
    p_scalar_i              => p_scalar_i,
    
    p_mat_a_size_i          => p_mat_a_size_i(2),
    p_mat_a_ix_o            => p_mat_a_ix_o(2),
    p_mat_a_data_i          => p_mat_a_data_i(2),
    
    p_mat_c_ix_o            => p_mat_c_ix_o(2),
    p_mat_c_data_o          => p_mat_c_data_o(2),
    p_mat_c_size_o          => p_mat_c_size_o(2)
);

mat_scalar_div : e_mat_scalar_div
PORT MAP(
    p_rst_i                 => p_rst_i,
    p_clk_i                 => p_clk_i,
        
    p_syn_rst_i             => p_syn_rst_i,
    p_finished_o            => s_scalar_div_finished,
    
    p_mat_a_size_i          => p_mat_a_size_i(0),
    p_mat_a_ix_o            => s_scalar_div_a_ix,
    p_mat_a_data_i          => p_mat_a_data_i(0),
    
    p_mat_c_ix_o            => s_scalar_div_c_ix,
    p_mat_c_data_o          => s_scalar_div_c_data,
    p_mat_c_size_o          => s_scalar_div_c_size
);

mat_scalar_max : e_mat_scalar_max
PORT MAP(
    p_rst_i                 => p_rst_i,
    p_clk_i                 => p_clk_i,
        
    p_syn_rst_i             => p_syn_rst_i,
    p_finished_o            => s_scalar_max_finished,
    
    p_mat_a_size_i          => p_mat_a_size_i(0),
    p_mat_a_ix_o            => s_scalar_max_a_ix,
    p_mat_a_data_i          => p_mat_a_data_i(0),
    
    p_mat_c_ix_o            => s_scalar_max_c_ix,
    p_mat_c_data_o          => s_scalar_max_c_data,
    p_mat_c_size_o          => s_scalar_max_c_size
);

----------------------------------------------------------------------------------------------------
--  Zuweisungen
----------------------------------------------------------------------------------------------------

generate_regs: 
FOR i IN c_num_parallel_op-1 DOWNTO 0 GENERATE
    f_reg(p_rst_i, p_clk_i, p_syn_rst_i, s_finished_t1(i), s_finished_t2(i));
    f_reg(p_rst_i, p_clk_i, p_syn_rst_i, s_finished_t2(i), s_finished_t3(i));
    p_mat_c_wren_o(i) <= p_wren_i AND NOT p_syn_rst_i AND NOT s_finished_t3(i);
END GENERATE generate_regs;

p_mat_c_row_by_row_o    <= p_mat_c_row_by_row_i;

s_vec_add_mode <= '1' WHEN p_opcode_i(0) = VecAdd ELSE '0';

-- MatTrans, MatDel
s_finished_t1(1) <= s_del_finished WHEN p_opcode_i(1) = MatDel ELSE 
                    s_trans_finished WHEN p_opcode_i(1) = MatTrans ELSE '1';
                    
p_mat_c_ix_o(1) <= s_del_c_ix WHEN p_opcode_i(1) = MatDel ELSE s_trans_c_ix;
p_mat_c_data_o(1) <= s_del_c_data WHEN p_opcode_i(1) = MatDel ELSE s_trans_c_data;
p_mat_c_size_o(1) <= s_del_c_size WHEN p_opcode_i(1) = MatDel ELSE s_trans_c_size;

-- ScalarMul
s_finished_t1(2) <= s_scalar_mul_finished WHEN p_opcode_i(2) = ScalarMul ELSE '1';

-- MatMul
s_finished_t1(3) <= s_mul_finished WHEN p_opcode_i(2) = MatMul ELSE '1';


----------------------------------------------------------------------------------------------------
--  Prozesse
----------------------------------------------------------------------------------------------------

proc_finished : PROCESS(s_finished_t3)
VARIABLE s_finished_tmp : STD_LOGIC;
BEGIN
    s_finished_tmp := '1';
    FOR i IN c_num_parallel_op-1 DOWNTO 0 LOOP
        s_finished_tmp := s_finished_tmp AND s_finished_t3(i);
    END LOOP;
    p_finished_o <= s_finished_tmp;
END PROCESS proc_finished;

proc_mux_output : PROCESS(
    s_add_finished, s_add_a_ix, s_add_c_ix, s_add_c_data, s_add_c_size,
    s_scalar_div_finished, s_scalar_div_a_ix, s_scalar_div_c_ix, s_scalar_div_c_data, s_scalar_div_c_size,
    s_scalar_max_finished, s_scalar_max_a_ix, s_scalar_max_c_ix, s_scalar_max_c_data, s_scalar_max_c_size,
    p_opcode_i
)
BEGIN
    CASE p_opcode_i(0) IS
        WHEN MatAdd     =>  s_finished_t1(0)    <= s_add_finished;
                            p_mat_a_ix_o(0)     <= s_add_a_ix;
                            p_mat_c_ix_o(0)     <= s_add_c_ix;
                            p_mat_c_data_o(0)   <= s_add_c_data;
                            p_mat_c_size_o(0)   <= s_add_c_size;
                            
        WHEN VecAdd     =>  s_finished_t1(0)    <= s_add_finished;
                            p_mat_a_ix_o(0)     <= s_add_a_ix;
                            p_mat_c_ix_o(0)     <= s_add_c_ix;
                            p_mat_c_data_o(0)   <= s_add_c_data;
                            p_mat_c_size_o(0)   <= s_add_c_size;
                            
        WHEN ScalarDiv  =>  s_finished_t1(0)    <= s_scalar_div_finished;
                            p_mat_a_ix_o(0)     <= s_scalar_div_a_ix;
                            p_mat_c_ix_o(0)     <= s_scalar_div_c_ix;
                            p_mat_c_data_o(0)   <= s_scalar_div_c_data;
                            p_mat_c_size_o(0)   <= s_scalar_div_c_size;
                            
        WHEN ScalarMax  =>  s_finished_t1(0)    <= s_scalar_max_finished;
                            p_mat_a_ix_o(0)     <= s_scalar_max_a_ix;
                            p_mat_c_ix_o(0)     <= s_scalar_max_c_ix;
                            p_mat_c_data_o(0)   <= s_scalar_max_c_data;
                            p_mat_c_size_o(0)   <= s_scalar_max_c_size;
                            
        WHEN OTHERS     =>  s_finished_t1(0)    <= '1';
                            p_mat_a_ix_o(0)     <= s_add_a_ix;
                            p_mat_c_ix_o(0)     <= s_add_c_ix;
                            p_mat_c_data_o(0)   <= s_add_c_data;
                            p_mat_c_size_o(0)   <= s_add_c_size;
    END CASE;
END PROCESS proc_mux_output;

END ARCHITECTURE a_mat_alu;