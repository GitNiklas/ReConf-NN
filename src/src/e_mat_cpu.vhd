----------------------------------------------------------------------------------------------------
-- CPU fuer Matrixoperationen.
-- 
--  Port:
--      p_rst_i                 : Asynchroner Reset
--      p_clk_i                 : Takt
--      p_syn_rst_i             : Synchroner Reset
--      p_wren_i                : Schreiberlaubnis auf Matrix-Register
--
--      p_finished_o            : Signalisiert, dass die aktuelle Operation abgeschlossen ist
--      p_opcode_i              : Aktuelle Operation
--      p_data_i                : Zusaetzlicher Operand (Skalar bei ScalarMul, Index fuer ScalarSubIx)
--      p_data_o                : Zusaetzliches Resultat (Zeile fuer ScalarSubIx)
--
--      p_sel_a_i               : Auswahl Matrrixregister A
--      p_sel_b_i               : Auswahl Matrrixregister B
--      p_sel_c_i               : Auswahl Matrrixregister C
--      p_row_by_row_c_i        : Orientierung Matrix C
--         
--      p_write_a0_i            : Signalisiert einen externen Schreibvorgang auf Matrix A (OpCore0)
--      p_read_a0_i             : Signalisiert einen externen Lesevorgnag von Matrix A (OpCore0)
--      p_data_a0_i             : Zu Schreibende Daten Matrix A (OpCore0)
--      p_data_a0_o             : Gelesene Daten Matrix A (OpCore0)
--      p_ix_a0_i               : Lese/Schreibindex Matrix A (OpCore0)
--      p_size_a0_i             : Groesse Matrix A (OpCore0), Schreibend
--      p_row_by_row_a0_i       : Orientierung Matrix A (OpCore0), Schreibend
--      p_size_a0_o             : Groesse Matrix A (OpCore0), Lesend 
--      p_row_by_row_a0_o       : Orientierung Matrix A (OpCore0), Lesend
--
--  Autor: Niklas Kuehl
----------------------------------------------------------------------------------------------------
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
        p_finished_o            : OUT t_op_std_logics;
        
        p_opcode_i              : IN t_opcodes;
        p_data_i                : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        p_data_o                : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        
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
        
        p_mat_size_i        : IN t_mat_size;
        p_mat_size_o        : OUT t_mat_size;
        
        p_ix_read_i         : IN t_mat_ix;
        p_ix_write_i        : IN t_mat_ix;
        
        p_wren_i            : IN STD_LOGIC;
        
        p_row_by_row_i      : IN STD_LOGIC;
        p_row_by_row_o      : OUT STD_LOGIC;
        
        p_word_i            : IN t_mat_word;
        p_word_o            : OUT t_mat_word
    );
END COMPONENT;

COMPONENT e_mega_mux       
    PORT (   
        p_rst_i                 : IN STD_LOGIC;
        p_clk_i                 : IN STD_LOGIC;
        
        p_syn_rst_i             : IN STD_LOGIC;
        
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

SIGNAL s_opcode_i : t_opcodes;
SIGNAL s_data_i : t_byte;
SIGNAL s_sel_a_i, s_sel_b_i, s_sel_c_i : t_mat_reg_ixs;
SIGNAL s_row_by_row_c_i : t_op_std_logics;
SIGNAL s_write_a0_i, s_read_a0_i, s_row_by_row_a0_i : STD_LOGIC;
SIGNAL s_ix_a0_i : t_mat_ix;
SIGNAL s_size_a0_i : t_mat_size;
SIGNAL s_data_a0_i : t_mat_word;

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
    
    p_opcode_i              => s_opcode_i,
    p_data_i                => s_data_i,
    p_data_o                => p_data_o,
    
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
    p_mat_c_row_by_row_i    => s_row_by_row_c_i,
    p_mat_c_size_o          => s_alu_c_size,
    p_mat_c_row_by_row_o    => s_alu_c_row_by_row
);

mega_mux : e_mega_mux
PORT MAP(
    p_rst_i                 => p_rst_i,
    p_clk_i                 => p_clk_i,
        
    p_syn_rst_i             => p_syn_rst_i,
    
    p_sel_a_i               => s_sel_a_i,
    p_sel_b_i               => s_sel_b_i,
    p_sel_c_i               => s_sel_c_i,
    p_opcode_i              => s_opcode_i,
    
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

    p_write_a0_i            => s_write_a0_i,
    p_read_a0_i             => s_read_a0_i,
    p_data_a0_i             => s_data_a0_i,
    p_data_a0_o             => p_data_a0_o,
    p_ix_a0_i               => s_ix_a0_i,
    p_size_a0_i             => s_size_a0_i,
    p_row_by_row_a0_i       => s_row_by_row_a0_i,
    p_size_a0_o             => p_size_a0_o,
    p_row_by_row_a0_o       => p_row_by_row_a0_o
);

proc_registers : PROCESS(p_rst_i, p_clk_i)
BEGIN
    IF p_rst_i = '1' THEN
        s_opcode_i <= (OTHERS => NoOp);
        s_data_i <= (OTHERS => '0');
        
        s_sel_a_i <= (OTHERS => to_mat_reg_ix(0));
        s_sel_b_i <= (OTHERS => to_mat_reg_ix(0));
        s_sel_c_i <= (OTHERS => to_mat_reg_ix(0));
        s_row_by_row_c_i <= (OTHERS => '0');
        
        s_write_a0_i <= '0';
        s_read_a0_i <= '0';
        s_data_a0_i <= c_mat_word_zero;
        s_ix_a0_i <= c_mat_ix_zero;
        s_size_a0_i <= c_mat_size_zero;
        s_row_by_row_a0_i <= '0';
    ELSIF RISING_EDGE(p_clk_i) THEN
        s_opcode_i <= p_opcode_i;
        s_data_i <= p_data_i;
        
        s_sel_a_i <= p_sel_a_i;
        s_sel_b_i <= p_sel_b_i;
        s_sel_c_i <= p_sel_c_i;
        s_row_by_row_c_i <= p_row_by_row_c_i;
        
        s_write_a0_i <= p_write_a0_i;
        s_read_a0_i <= p_read_a0_i;
        s_data_a0_i <= p_data_a0_i;
        s_ix_a0_i <= p_ix_a0_i;
        s_size_a0_i <= p_size_a0_i;
        s_row_by_row_a0_i <= p_row_by_row_a0_i;
    END IF;
END PROCESS proc_registers;

        
END ARCHITECTURE a_mat_cpu;