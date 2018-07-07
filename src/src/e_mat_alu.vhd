LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
USE work.fixed_pkg.ALL;
USE work.pkg_tools.ALL;
    
-- MatMul: A has to be line_by_line; B has to be row_by_row
-- MatAdd: A and B must have the same orientation
-- Other OPs: Egal
ENTITY e_mat_alu IS       
    PORT (    
        p_rst_i                 : IN STD_LOGIC;
        p_clk_i                 : IN STD_LOGIC;
        
        p_syn_rst_i             : IN STD_LOGIC;
        p_wren_i                : IN STD_LOGIC;
        p_finished_o            : OUT STD_LOGIC;
        
        p_opcode_i              : IN t_opcodes;
        p_scalar_i              : IN t_mat_elems;
        
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

COMPONENT e_mat_scalar_add       
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

SIGNAL s_mul_a_ix, s_add_a_ix, s_trans_a_ix, s_scalar_add_a_ix, s_scalar_mul_a_ix, s_scalar_div_a_ix, s_scalar_max_a_ix : t_mat_ix; 
SIGNAL s_mul_b_ix, s_add_b_ix : t_mat_ix;  
SIGNAL s_mul_c_ix, s_add_c_ix, s_del_c_ix, s_trans_c_ix, s_scalar_add_c_ix, s_scalar_mul_c_ix, s_scalar_div_c_ix, s_scalar_max_c_ix : t_mat_ix;
SIGNAL s_mul_c_data, s_add_c_data, s_del_c_data, s_trans_c_data, s_scalar_add_c_data, s_scalar_mul_c_data, s_scalar_div_c_data, s_scalar_max_c_data : t_mat_word;
SIGNAL s_mul_finished, s_add_finished, s_del_finished, s_trans_finished, s_scalar_add_finished, s_scalar_mul_finished, s_scalar_div_finished, s_scalar_max_finished : STD_LOGIC;
SIGNAL s_mul_c_size, s_add_c_size, s_del_c_size, s_trans_c_size, s_scalar_add_c_size, s_scalar_mul_c_size, s_scalar_div_c_size, s_scalar_max_c_size : t_mat_size;

SIGNAL s_mul_mat_a_size, s_add_mat_a_size, s_trans_mat_a_size, s_scalar_add_mat_a_size, s_scalar_mul_mat_a_size, s_scalar_div_mat_a_size, s_scalar_max_mat_a_size : t_mat_size;
SIGNAL s_trans_mat_a_row_by_row : STD_LOGIC;
SIGNAL s_mul_mat_a_data, s_add_mat_a_data, s_trans_mat_a_data, s_scalar_add_mat_a_data, s_scalar_mul_mat_a_data, s_scalar_div_mat_a_data, s_scalar_max_mat_a_data : t_mat_word;
SIGNAL s_mul_mat_b_size : t_mat_size;
SIGNAL s_mul_mat_b_data, s_add_mat_b_data : t_mat_word;
SIGNAL s_mul_mat_c_row_by_row, s_trans_mat_c_row_by_row : STD_LOGIC;
SIGNAL s_add_scalar, s_mul_scalar : t_mat_elem;

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
    
    p_mat_a_size_i          => s_mul_mat_a_size,
    p_mat_a_ix_o            => s_mul_a_ix,
    p_mat_a_data_i          => s_mul_mat_a_data,
    
    p_mat_b_size_i          => s_mul_mat_b_size,
    p_mat_b_ix_o            => s_mul_b_ix,
    p_mat_b_data_i          => s_mul_mat_b_data,

    p_mat_c_ix_o            => s_mul_c_ix,
    p_mat_c_data_o          => s_mul_c_data,
    p_mat_c_row_by_row_i    => s_mul_mat_c_row_by_row,
    p_mat_c_size_o          => s_mul_c_size
);

mat_add : e_mat_add
PORT MAP(
    p_rst_i                 => p_rst_i,
    p_clk_i                 => p_clk_i,
        
    p_syn_rst_i             => p_syn_rst_i,
    p_finished_o            => s_add_finished,

    p_mat_a_size_i          => s_add_mat_a_size,
    p_mat_a_ix_o            => s_add_a_ix,
    p_mat_a_data_i          => s_add_mat_a_data,
    
    p_mat_b_ix_o            => s_add_b_ix,
    p_mat_b_data_i          => s_add_mat_b_data,

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
    
    p_mat_a_size_i          => s_trans_mat_a_size,
    p_mat_a_ix_o            => s_trans_a_ix,
    p_mat_a_row_by_row_i    => s_trans_mat_a_row_by_row,
    p_mat_a_data_i          => s_trans_mat_a_data,

    p_mat_c_ix_o            => s_trans_c_ix,
    p_mat_c_data_o          => s_trans_c_data,
    p_mat_c_row_by_row_i    => s_trans_mat_c_row_by_row,
    p_mat_c_size_o          => s_trans_c_size
);

mat_scalar_add : e_mat_scalar_add
PORT MAP(
    p_rst_i                 => p_rst_i,
    p_clk_i                 => p_clk_i,
        
    p_syn_rst_i             => p_syn_rst_i,
    p_finished_o            => s_scalar_add_finished,
    
    p_scalar_i              => s_add_scalar,
    
    p_mat_a_size_i          => s_scalar_add_mat_a_size,
    p_mat_a_ix_o            => s_scalar_add_a_ix,
    p_mat_a_data_i          => s_scalar_add_mat_a_data,
    
    p_mat_c_ix_o            => s_scalar_add_c_ix,
    p_mat_c_data_o          => s_scalar_add_c_data,
    p_mat_c_size_o          => s_scalar_add_c_size
);

mat_scalar_mul : e_mat_scalar_mul
PORT MAP(
    p_rst_i                 => p_rst_i,
    p_clk_i                 => p_clk_i,
        
    p_syn_rst_i             => p_syn_rst_i,
    p_finished_o            => s_scalar_mul_finished,
    
    p_scalar_i              => s_mul_scalar,
    
    p_mat_a_size_i          => s_scalar_mul_mat_a_size,
    p_mat_a_ix_o            => s_scalar_mul_a_ix,
    p_mat_a_data_i          => s_scalar_mul_mat_a_data,
    
    p_mat_c_ix_o            => s_scalar_mul_c_ix,
    p_mat_c_data_o          => s_scalar_mul_c_data,
    p_mat_c_size_o          => s_scalar_mul_c_size
);

mat_scalar_div : e_mat_scalar_div
PORT MAP(
    p_rst_i                 => p_rst_i,
    p_clk_i                 => p_clk_i,
        
    p_syn_rst_i             => p_syn_rst_i,
    p_finished_o            => s_scalar_div_finished,
    
    p_mat_a_size_i          => s_scalar_div_mat_a_size,
    p_mat_a_ix_o            => s_scalar_div_a_ix,
    p_mat_a_data_i          => s_scalar_div_mat_a_data,
    
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
    
    p_mat_a_size_i          => s_scalar_max_mat_a_size,
    p_mat_a_ix_o            => s_scalar_max_a_ix,
    p_mat_a_data_i          => s_scalar_max_mat_a_data,
    
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

proc_mux_input : PROCESS(p_opcode_i, p_mat_a_size_i, p_mat_a_row_by_row_i, p_mat_a_data_i, p_mat_b_size_i, p_mat_b_data_i, p_mat_c_row_by_row_i, p_scalar_i)
BEGIN
    -- Standardwerte
    s_mul_mat_a_size <= p_mat_a_size_i(0);
    s_add_mat_a_size <= p_mat_a_size_i(0);
    s_trans_mat_a_size <= p_mat_a_size_i(0);
    s_scalar_add_mat_a_size <= p_mat_a_size_i(0);
    s_scalar_mul_mat_a_size <= p_mat_a_size_i(0);
    s_scalar_div_mat_a_size <= p_mat_a_size_i(0);
    s_scalar_max_mat_a_size <= p_mat_a_size_i(0);
    
    s_trans_mat_a_row_by_row <= p_mat_c_row_by_row_i(0);
    
    s_mul_mat_a_data <= p_mat_a_data_i(0);
    s_add_mat_a_data <= p_mat_a_data_i(0);
    s_trans_mat_a_data <= p_mat_a_data_i(0);
    s_scalar_add_mat_a_data <= p_mat_a_data_i(0);
    s_scalar_mul_mat_a_data <= p_mat_a_data_i(0);
    s_scalar_div_mat_a_data <= p_mat_a_data_i(0);
    s_scalar_max_mat_a_data <= p_mat_a_data_i(0);
    
    s_mul_mat_b_size <= p_mat_a_size_i(0);
    
    s_mul_mat_b_data <= p_mat_a_data_i(0);
    s_add_mat_b_data <= p_mat_a_data_i(0);
    
    s_mul_mat_c_row_by_row <= p_mat_c_row_by_row_i(0);
    s_trans_mat_c_row_by_row <= p_mat_c_row_by_row_i(0);
    
    s_add_scalar <= p_scalar_i(0);
    s_mul_scalar <= p_scalar_i(0);
    
    FOR i IN c_num_parallel_op-1 DOWNTO 0 LOOP
        CASE p_opcode_i(i) IS
            WHEN MatMul     =>  s_mul_mat_a_size            <= p_mat_a_size_i(i);
                                s_mul_mat_a_data            <= p_mat_a_data_i(i);
                                s_mul_mat_b_size            <= p_mat_b_size_i(i);
                                s_mul_mat_b_data            <= p_mat_b_data_i(i);
                                s_mul_mat_c_row_by_row      <= p_mat_c_row_by_row_i(i);
                                
            WHEN MatAdd     =>  s_add_mat_a_size            <= p_mat_a_size_i(i);
                                s_add_mat_a_data            <= p_mat_a_data_i(i);
                                s_add_mat_b_data            <= p_mat_b_data_i(i);
                                   
            WHEN MatTrans   =>  s_trans_mat_a_size          <= p_mat_a_size_i(i);
                                s_trans_mat_a_row_by_row    <= p_mat_a_row_by_row_i(i);
                                s_trans_mat_a_data         <= p_mat_a_data_i(i);
                                s_trans_mat_c_row_by_row    <= p_mat_c_row_by_row_i(i);
                                
            WHEN ScalarAdd  =>  s_scalar_add_mat_a_size     <= p_mat_a_size_i(i);
                                s_scalar_add_mat_a_data     <= p_mat_a_data_i(i);
                                s_add_scalar                <= p_scalar_i(i);
                                
            WHEN ScalarMul  =>  s_scalar_mul_mat_a_size     <= p_mat_a_size_i(i);
                                s_scalar_mul_mat_a_data     <= p_mat_a_data_i(i);
                                s_mul_scalar                <= p_scalar_i(i);
     
            WHEN ScalarDiv  =>  s_scalar_div_mat_a_size     <= p_mat_a_size_i(i);
                                s_scalar_div_mat_a_data     <= p_mat_a_data_i(i);
                                
            WHEN ScalarMax  =>  s_scalar_max_mat_a_size     <= p_mat_a_size_i(i);
                                s_scalar_max_mat_a_data     <= p_mat_a_data_i(i);    
                                
            WHEN OTHERS     =>  NULL;  
        END CASE;
    END LOOP;
END PROCESS proc_mux_input;

proc_mux_output : PROCESS(
    s_mul_finished, s_mul_a_ix, s_mul_b_ix, s_mul_c_ix, s_mul_c_data, s_mul_c_size,
    s_add_finished, s_add_a_ix, s_add_b_ix, s_add_c_ix, s_add_c_data, s_add_c_size,
    s_del_finished, s_del_c_ix, s_del_c_data, s_del_c_size,
    s_trans_finished, s_trans_a_ix, s_trans_c_ix, s_trans_c_data, s_trans_c_size,
    s_scalar_add_finished, s_scalar_add_a_ix, s_scalar_add_c_ix, s_scalar_add_c_data, s_scalar_add_c_size,
    s_scalar_mul_finished, s_scalar_mul_a_ix, s_scalar_mul_c_ix, s_scalar_mul_c_data, s_scalar_mul_c_size,
    s_scalar_div_finished, s_scalar_div_a_ix, s_scalar_div_c_ix, s_scalar_div_c_data, s_scalar_div_c_size,
    s_scalar_max_finished, s_scalar_max_a_ix, s_scalar_max_c_ix, s_scalar_max_c_data, s_scalar_max_c_size,
    p_opcode_i
)
BEGIN
    FOR i IN c_num_parallel_op-1 DOWNTO 0 LOOP
        CASE p_opcode_i(i) IS
            WHEN MatMul     =>  s_finished_t1(i)    <= s_mul_finished;
                                p_mat_a_ix_o(i)     <= s_mul_a_ix;
                                p_mat_b_ix_o(i)     <= s_mul_b_ix;
                                p_mat_c_ix_o(i)     <= s_mul_c_ix;
                                p_mat_c_data_o(i)   <= s_mul_c_data;
                                p_mat_c_size_o(i)   <= s_mul_c_size;
                                
            WHEN MatAdd     =>  s_finished_t1(i)    <= s_add_finished;
                                p_mat_a_ix_o(i)     <= s_add_a_ix;
                                p_mat_b_ix_o(i)     <= s_add_b_ix;
                                p_mat_c_ix_o(i)     <= s_add_c_ix;
                                p_mat_c_data_o(i)   <= s_add_c_data;
                                p_mat_c_size_o(i)   <= s_add_c_size;
                                
            WHEN MatDel     =>  s_finished_t1(i)    <= s_del_finished;
                                p_mat_a_ix_o(i)     <= c_mat_ix_zero;
                                p_mat_b_ix_o(i)     <= c_mat_ix_zero;
                                p_mat_c_ix_o(i)     <= s_del_c_ix;
                                p_mat_c_data_o(i)   <= s_del_c_data;
                                p_mat_c_size_o(i)   <= s_del_c_size;
                                
            WHEN MatTrans   =>  s_finished_t1(i)    <= s_trans_finished;
                                p_mat_a_ix_o(i)     <= s_trans_a_ix;
                                p_mat_b_ix_o(i)     <= c_mat_ix_zero;
                                p_mat_c_ix_o(i)     <= s_trans_c_ix;
                                p_mat_c_data_o(i)   <= s_trans_c_data;
                                p_mat_c_size_o(i)   <= s_trans_c_size;
                                
            WHEN ScalarAdd  =>  s_finished_t1(i)    <= s_scalar_add_finished;
                                p_mat_a_ix_o(i)     <= s_scalar_add_a_ix;
                                p_mat_b_ix_o(i)     <= c_mat_ix_zero;
                                p_mat_c_ix_o(i)     <= s_scalar_add_c_ix;
                                p_mat_c_data_o(i)   <= s_scalar_add_c_data;
                                p_mat_c_size_o(i)   <= s_scalar_add_c_size;
                               
            WHEN ScalarMul  =>  s_finished_t1(i)    <= s_scalar_mul_finished;
                                p_mat_a_ix_o(i)     <= s_scalar_mul_a_ix;
                                p_mat_b_ix_o(i)     <= c_mat_ix_zero;
                                p_mat_c_ix_o(i)     <= s_scalar_mul_c_ix;
                                p_mat_c_data_o(i)   <= s_scalar_mul_c_data;
                                p_mat_c_size_o(i)   <= s_scalar_mul_c_size;
     
            WHEN ScalarDiv  =>  s_finished_t1(i)    <= s_scalar_div_finished;
                                p_mat_a_ix_o(i)     <= s_scalar_div_a_ix;
                                p_mat_b_ix_o(i)     <= c_mat_ix_zero;
                                p_mat_c_ix_o(i)     <= s_scalar_div_c_ix;
                                p_mat_c_data_o(i)   <= s_scalar_div_c_data;
                                p_mat_c_size_o(i)   <= s_scalar_div_c_size;
                                
            WHEN ScalarMax  =>  s_finished_t1(i)    <= s_scalar_max_finished;
                                p_mat_a_ix_o(i)     <= s_scalar_max_a_ix;
                                p_mat_b_ix_o(i)     <= c_mat_ix_zero;
                                p_mat_c_ix_o(i)     <= s_scalar_max_c_ix;
                                p_mat_c_data_o(i)   <= s_scalar_max_c_data;
                                p_mat_c_size_o(i)   <= s_scalar_max_c_size;
                                
            WHEN NoOp     =>    s_finished_t1(i)    <= '1';
                                p_mat_a_ix_o(i)     <= s_add_a_ix;
                                p_mat_b_ix_o(i)     <= s_add_b_ix;
                                p_mat_c_ix_o(i)     <= s_add_c_ix;
                                p_mat_c_data_o(i)   <= s_add_c_data;
                                p_mat_c_size_o(i)   <= s_add_c_size;
        END CASE;
    END LOOP;
END PROCESS proc_mux_output;

END ARCHITECTURE a_mat_alu;