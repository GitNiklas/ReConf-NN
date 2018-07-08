LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
USE work.fixed_pkg.ALL;
USE work.pkg_tools.ALL;

ENTITY e_mat_cpu IS       
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
END ENTITY e_mat_cpu;

----------------------------------------------------------------------------------------------------
--  Architecture
----------------------------------------------------------------------------------------------------
ARCHITECTURE a_mat_cpu OF e_mat_cpu IS

----------------------------------------------------------------------------------------------------
--  Komponenten
----------------------------------------------------------------------------------------------------

COMPONENT e_mat_alu
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
END COMPONENT;

COMPONENT e_mat_reg
    PORT (    
        p_clk_i             : IN STD_LOGIC;
        p_rst_i             : IN STD_LOGIC;
        
        p_mat_size_i        : IN t_mat_size; -- wird bei wren='1' aktualisiert
        p_mat_size_o        : OUT t_mat_size;
        
        p_ix_read_i         : IN t_mat_ix;
        p_ix_write_i        : IN t_mat_ix;
        
        p_wren_i            : IN STD_LOGIC;
        
        p_row_by_row_i      : IN STD_LOGIC; -- '1' -> zeilenweise, '0' -> spaltenweise; wird bei wren='1' aktualisiert
        p_row_by_row_o      : OUT STD_LOGIC;
        
        p_word_i            : IN t_mat_word;
        p_word_o            : OUT t_mat_word
    );
END COMPONENT;

COMPONENT e_mega_mux       
    PORT (    
        p_sel_a_i               : IN t_mat_reg_ixs;
        p_sel_b_i               : IN t_mat_reg_ixs;
        p_sel_c_i               : IN t_mat_reg_ixs;
        p_opcode_i              : IN t_opcodes;
        
        p_reg_mat_size_o        : OUT t_mat_size_arr; 
        p_reg_mat_size_i        : IN t_mat_size_arr;        
        p_reg_ix_read_o         : OUT t_mat_ix_arr; 
        p_reg_ix_write_o        : OUT t_mat_ix_arr;     
        p_reg_wren_o            : OUT t_mat_logic_arr; 
        p_reg_row_by_row_i      : IN  t_mat_logic_arr;
        p_reg_row_by_row_o      : OUT t_mat_logic_arr;       
        p_reg_word_o            : OUT t_mat_word_arr; 
        p_reg_word_i            : IN t_mat_word_arr; 
     
        p_alu_a_data_o          : OUT t_mat_words; 
        p_alu_a_ix_read_i       : IN t_mat_ixs; 
        p_alu_a_size_o          : OUT t_mat_sizes;
        p_alu_a_row_by_row_o    : OUT t_op_std_logics;   
        p_alu_b_data_o          : OUT t_mat_words; 
        p_alu_b_ix_read_i       : IN t_mat_ixs; 
        p_alu_b_size_o          : OUT t_mat_sizes; 
        p_alu_b_row_by_row_o    : OUT t_op_std_logics;   
        p_alu_c_data_i          : IN t_mat_words;   
        p_alu_c_size_i          : IN t_mat_sizes; 
        p_alu_c_row_by_row_i    : IN t_op_std_logics;
        p_alu_c_ix_write_i      : IN t_mat_ixs; 
        p_alu_c_wren_i          : IN t_op_std_logics; 
         
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
SIGNAL s_reg_ix_read, s_reg_ix_write : t_mat_ix_arr;
SIGNAL s_reg_wren, s_row_by_row_i, s_row_by_row_o : t_mat_logic_arr;
SIGNAL s_reg_word_o, s_reg_word_i : t_mat_word_arr;
SIGNAL s_reg_size_i, s_reg_size_o : t_mat_size_arr;

SIGNAL s_alu_a_data, s_alu_b_data, s_alu_c_data : t_mat_words;
SIGNAL s_alu_a_size, s_alu_b_size, s_alu_c_size : t_mat_sizes;
SIGNAL s_alu_a_ix, s_alu_b_ix : t_mat_ixs;
SIGNAL s_alu_c_ix_write : t_mat_ixs;
SIGNAL s_alu_c_wren : t_op_std_logics;
SIGNAL s_alu_a_row_by_row, s_alu_b_row_by_row, s_alu_c_row_by_row : t_op_std_logics;

----------------------------------------------------------------------------------------------------
--  Port Maps
----------------------------------------------------------------------------------------------------
BEGIN

generate_regs: 
FOR i IN c_num_mat_regs-1 DOWNTO 0 GENERATE
    mat_reg_i : e_mat_reg PORT MAP(
        p_clk_i         => p_clk_i,  
        p_rst_i         => p_rst_i,    
 
        p_mat_size_i    => s_reg_size_i(i),
        p_mat_size_o    => s_reg_size_o(i),
        
        p_ix_read_i     => s_reg_ix_read(i),
        p_ix_write_i    => s_reg_ix_write(i),
        
        p_wren_i        => s_reg_wren(i),
        
        p_row_by_row_i  => s_row_by_row_i(i),
        p_row_by_row_o  => s_row_by_row_o(i),
        
        p_word_i        => s_reg_word_i(i),
        p_word_o        => s_reg_word_o(i)
        
    );
END GENERATE generate_regs;
        
alu : e_mat_alu
PORT MAP(
    p_rst_i                 => p_rst_i,
    p_clk_i                 => p_clk_i,
        
    p_syn_rst_i             => p_syn_rst_i,
    p_wren_i                => p_wren_i,
    p_finished_o            => p_finished_o,
    
    p_opcode_i              => p_opcode_i,
    p_scalar_i              => p_scalar_i,
    
    p_mat_a_size_i          => s_alu_a_size,
    p_mat_a_ix_o            => s_alu_a_ix,
    p_mat_a_data_i          => s_alu_a_data,
    p_mat_a_row_by_row_i    => s_alu_a_row_by_row,
    
    p_mat_b_size_i          => s_alu_b_size,
    p_mat_b_ix_o            => s_alu_b_ix,
    p_mat_b_data_i          => s_alu_b_data,
    p_mat_b_row_by_row_i    => s_alu_b_row_by_row,

    p_mat_c_ix_o            => s_alu_c_ix_write,
    p_mat_c_data_o          => s_alu_c_data,
    p_mat_c_wren_o          => s_alu_c_wren,
    p_mat_c_row_by_row_i    => p_row_by_row_c_i,
    p_mat_c_size_o          => s_alu_c_size,
    p_mat_c_row_by_row_o    => s_alu_c_row_by_row
);

mega_mux : e_mega_mux
PORT MAP(
    p_sel_a_i               => p_sel_a_i,
    p_sel_b_i               => p_sel_b_i,
    p_sel_c_i               => p_sel_c_i,
    p_opcode_i              => p_opcode_i,
    
    p_reg_mat_size_o        => s_reg_size_i,
    p_reg_mat_size_i        => s_reg_size_o,       
    p_reg_ix_read_o         => s_reg_ix_read,
    p_reg_ix_write_o        => s_reg_ix_write,    
    p_reg_wren_o            => s_reg_wren, 
    p_reg_row_by_row_i      => s_row_by_row_o,
    p_reg_row_by_row_o      => s_row_by_row_i,  
    p_reg_word_o            => s_reg_word_i,
    p_reg_word_i            => s_reg_word_o,
    
    p_alu_a_data_o          => s_alu_a_data,
    p_alu_a_ix_read_i       => s_alu_a_ix,
    p_alu_a_size_o          => s_alu_a_size,
    p_alu_a_row_by_row_o    => s_alu_a_row_by_row,
    p_alu_b_data_o          => s_alu_b_data,
    p_alu_b_ix_read_i       => s_alu_b_ix,
    p_alu_b_size_o          => s_alu_b_size,
    p_alu_b_row_by_row_o    => s_alu_b_row_by_row,
    p_alu_c_data_i          => s_alu_c_data,  
    p_alu_c_size_i          => s_alu_c_size,
    p_alu_c_row_by_row_i    => s_alu_c_row_by_row,
    p_alu_c_ix_write_i      => s_alu_c_ix_write, 
    p_alu_c_wren_i          => s_alu_c_wren, 

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

END ARCHITECTURE a_mat_cpu;