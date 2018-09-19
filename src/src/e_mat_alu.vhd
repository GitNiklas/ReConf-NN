----------------------------------------------------------------------------------------------------
-- ALU fuer Matrix-Operationen. Die Operationen werden auf 2 'OpCores' verteilt, die parallel rechnen koennen.
-- Somit ist die parallele Ausfuerhrung von bis zu 2 Operationen moeglich.
-- Unterstuetze Operationen:
--     OpCore0: MatMul, MatAdd, VecAdd, MatTrans, MatFlip, NoOp
--     OpCore1: ScalarMul, ScalarDiv, ScalarMax, ScalarSubIx, ColSum, NoOp
--
--  Port:
--      p_rst_i                 : Asynchroner Reset
--      p_clk_i                 : Takt
--      p_syn_rst_i             : Synchroner Reset
--
--      p_wren_i                : Aktiviert das Schreiben der Matrixregister
--      p_finished_o            : Signalisiert, dass die jeweilige Operation abgeschlossen ist
--
--      p_opcode_i              : Auszufuehrende Operation 
--      p_data_i                : Zusaetzlicher Operand (Skalar bei ScalarMul, Index fuer ScalarSubIx)
--      p_data_o                : Zusaetzliches Resultat (Zeile fuer ScalarSubIx)
--        
--      p_mat_a_size_i          : Groesse von Matrix A   
--      p_mat_a_ix_o            : Leseposition Matrix A 
--      p_mat_a_row_by_row_i    : Orientierung Matrix A
--      p_mat_a_data_i          : Gelesende Daten Matrix A 
--        
--      p_mat_b_size_i          : Groesse von Matrix B   
--      p_mat_b_ix_o            : Leseposition Matrix B 
--      p_mat_b_row_by_row_i    : Orientierung Matrix B
--      p_mat_b_data_i          : Gelesende Daten Matrix B 
--
--      p_mat_c_ix_o            : Schreibposition Matrix C 
--      p_mat_c_data_o          : Zu schreibende Daten Matrix C
--      p_mat_c_wren_o          : Schreiberlaubnis Matrix C
--      p_mat_c_row_by_row_i    : Orientierung Matrix C
--      p_mat_c_size_o          : Groesse Matrix C
--      p_mat_c_row_by_row_o    : Orientierung Matrix C
--
--  Autor: Niklas Kuehl
----------------------------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
USE work.fixed_pkg.ALL;
USE work.pkg_tools.ALL;

ENTITY e_mat_alu IS       
    PORT (    
        p_rst_i                 : IN STD_LOGIC;
        p_clk_i                 : IN STD_LOGIC;
        
        p_syn_rst_i             : IN STD_LOGIC;
        p_wren_i                : IN STD_LOGIC;
        p_finished_o            : OUT t_op_std_logics;
        
        p_opcode_i              : IN t_opcodes;
        p_data_i                : IN t_byte;
        p_data_o                : OUT t_byte;
        
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
        p_mat_a_data_i          : IN t_mat_word; 
        
        p_mat_b_size_i          : IN t_mat_size;
        p_mat_b_ix_o            : OUT t_mat_ix;
        p_mat_b_data_i          : IN t_mat_word;

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
        p_ix_o                  : OUT t_byte;
        
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
CONSTANT opcore_trans : INTEGER := 0;
CONSTANT opcore_col_sum : INTEGER := 1;
CONSTANT opcore_scalar_mul : INTEGER := 1;
CONSTANT opcore_scalar_div : INTEGER := 1;
CONSTANT opcore_scalar_max : INTEGER := 1;
CONSTANT opcore_scalar_sub_ix : INTEGER := 1;

SIGNAL s_finished_t1, s_finished_t2, s_finished_t3, s_finished_t4, s_finished_t5 : t_op_std_logics;

SIGNAL s_mul_a_ix, s_add_a_ix, s_trans_a_ix, s_col_sum_a_ix, s_scalar_mul_a_ix, s_scalar_div_a_ix, s_scalar_max_a_ix, s_scalar_sub_ix_a_ix : t_mat_ix; 
SIGNAL s_mul_b_ix, s_add_b_ix : t_mat_ix;  
SIGNAL s_mul_c_ix, s_add_c_ix, s_trans_c_ix, s_col_sum_c_ix, s_scalar_mul_c_ix, s_scalar_div_c_ix, s_scalar_max_c_ix, s_scalar_sub_ix_c_ix : t_mat_ix;
SIGNAL s_mul_c_data, s_add_c_data, s_trans_c_data, s_col_sum_c_data, s_scalar_mul_c_data, s_scalar_div_c_data, s_scalar_max_c_data, s_scalar_sub_ix_c_data : t_mat_word;
SIGNAL s_mul_finished, s_add_finished, s_trans_finished, s_col_sum_finished, s_scalar_mul_finished, s_scalar_div_finished, s_scalar_max_finished, s_scalar_sub_ix_finished : STD_LOGIC;
SIGNAL s_mul_c_size, s_add_c_size, s_trans_c_size, s_col_sum_c_size, s_scalar_mul_c_size, s_scalar_div_c_size, s_scalar_max_c_size, s_scalar_sub_ix_c_size : t_mat_size;

SIGNAL s_vec_add : STD_LOGIC;

SIGNAL s_wren_t1, s_wren_t2, s_wren_t3 : STD_LOGIC;
SIGNAL s_wren_tmp : t_op_std_logics;

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

f_reg(p_rst_i, p_clk_i, p_syn_rst_i, p_wren_i, s_wren_t1);
f_reg(p_rst_i, p_clk_i, p_syn_rst_i, s_wren_t1, s_wren_t2);
f_reg(p_rst_i, p_clk_i, p_syn_rst_i, s_wren_t2, s_wren_t3);

generate_regs: 
FOR i IN c_num_parallel_op-1 DOWNTO 0 GENERATE
    f_reg(p_rst_i, p_clk_i, p_syn_rst_i, s_finished_t1(i), s_finished_t2(i));
    f_reg(p_rst_i, p_clk_i, p_syn_rst_i, s_finished_t2(i), s_finished_t3(i));
    f_reg(p_rst_i, p_clk_i, p_syn_rst_i, s_finished_t3(i), s_finished_t4(i));
    f_reg(p_rst_i, p_clk_i, p_syn_rst_i, s_finished_t4(i), s_finished_t5(i));
    p_mat_c_wren_o(i) <= s_wren_t3 AND NOT p_syn_rst_i AND NOT s_finished_t5(i);
    p_finished_o(i) <= s_finished_t5(i);
END GENERATE generate_regs;

p_mat_c_row_by_row_o    <= p_mat_c_row_by_row_i;

----------------------------------------------------------------------------------------------------
--  Prozesse
----------------------------------------------------------------------------------------------------

proc_opcore0 : PROCESS(p_opcode_i, p_syn_rst_i,
    s_mul_finished, s_mul_a_ix, s_mul_b_ix, s_mul_c_ix, s_mul_c_data, s_mul_c_size,
    s_add_finished, s_add_a_ix, s_add_b_ix, s_add_c_ix, s_add_c_data, s_add_c_size,
    s_trans_finished, s_trans_a_ix, s_trans_c_ix, s_trans_c_data, s_trans_c_size)
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
                            
        WHEN MatTrans   =>  s_finished_t1(0)    <= s_trans_finished;
                            p_mat_a_ix_o(0)     <= s_trans_a_ix;
                            p_mat_b_ix_o(0)     <= c_mat_ix_dontcare;
                            p_mat_c_ix_o(0)     <= s_trans_c_ix;
                            p_mat_c_data_o(0)   <= s_trans_c_data;
                            p_mat_c_size_o(0)   <= s_trans_c_size;
                            s_vec_add           <= '-';
                            
        WHEN OTHERS     =>  s_finished_t1(0)    <= NOT p_syn_rst_i;
                            p_mat_a_ix_o(0)     <= c_mat_ix_dontcare;
                            p_mat_b_ix_o(0)     <= c_mat_ix_dontcare;
                            p_mat_c_ix_o(0)     <= c_mat_ix_dontcare;
                            p_mat_c_data_o(0)   <= set_mat_word('-');
                            p_mat_c_size_o(0)   <= c_mat_size_dontcare;
                            s_vec_add           <= '-';
                            IF p_opcode_i(0) /= NoOp THEN REPORT err("Nicht unterstuetze Operation auf Opcore 0"); END IF;
    END CASE;
END PROCESS proc_opcore0;

proc_opcore1 : PROCESS(p_opcode_i, p_syn_rst_i,
    s_scalar_mul_finished, s_scalar_mul_a_ix, s_scalar_mul_c_ix, s_scalar_mul_c_data, s_scalar_mul_c_size,
    s_scalar_div_finished, s_scalar_div_a_ix, s_scalar_div_c_ix, s_scalar_div_c_data, s_scalar_div_c_size,
    s_scalar_max_finished, s_scalar_max_a_ix, s_scalar_max_c_ix, s_scalar_max_c_data, s_scalar_max_c_size,
    s_scalar_sub_ix_finished, s_scalar_sub_ix_a_ix, s_scalar_sub_ix_c_ix, s_scalar_sub_ix_c_data, s_scalar_sub_ix_c_size,
    s_col_sum_finished, s_col_sum_a_ix, s_col_sum_c_ix, s_col_sum_c_data, s_col_sum_c_size)
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
                            
        WHEN ColSum     =>  s_finished_t1(1)    <= s_col_sum_finished;
                            p_mat_a_ix_o(1)     <= s_col_sum_a_ix;
                            p_mat_c_ix_o(1)     <= s_col_sum_c_ix;
                            p_mat_c_data_o(1)   <= s_col_sum_c_data;
                            p_mat_c_size_o(1)   <= s_col_sum_c_size;
                            
        WHEN OTHERS     =>  s_finished_t1(1)    <= NOT p_syn_rst_i;
                            p_mat_a_ix_o(1)     <= c_mat_ix_dontcare;
                            p_mat_c_ix_o(1)     <= c_mat_ix_dontcare;
                            p_mat_c_data_o(1)   <= set_mat_word('-');
                            p_mat_c_size_o(1)   <= c_mat_size_dontcare;
                            IF p_opcode_i(1) /= NoOp THEN REPORT err("Nicht unterstuetze Operation auf Opcore 1"); END IF;
    END CASE;
END PROCESS proc_opcore1;

END ARCHITECTURE a_mat_alu;