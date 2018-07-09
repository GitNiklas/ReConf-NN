LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
USE work.fixed_pkg.ALL;
USE work.pkg_tools.ALL;

ENTITY e_tle_nn IS       
    PORT (    
        p_rst_i         : IN STD_LOGIC;
        p_clk_i         : IN STD_LOGIC;
        
        p_rx_i          : IN STD_LOGIC;
        p_tx_o          : OUT STD_LOGIC
    );
END ENTITY e_tle_nn;

----------------------------------------------------------------------------------------------------
--  Architecture
----------------------------------------------------------------------------------------------------
ARCHITECTURE a_tle_nn OF e_tle_nn IS

----------------------------------------------------------------------------------------------------
--  Komponenten
----------------------------------------------------------------------------------------------------

COMPONENT e_serial       
    GENERIC(
        g_clk_periode       : TIME      := 20 ns;
        g_baudrate          : POSITIVE  := 115200 
    );
    PORT(
        p_rst_i             : IN STD_LOGIC;
        p_clk_i             : IN STD_LOGIC;

        p_rx_i              : IN STD_LOGIC;
        p_tx_o              : OUT STD_LOGIC;

        p_new_data_o        : OUT STD_LOGIC;
        p_data_o            : OUT t_byte;
        p_data_read_i       : IN STD_LOGIC;
        p_rx_err_o          : OUT STD_LOGIC;
    
        p_data_i            : IN t_byte;
        p_send_i            : IN STD_LOGIC;
        p_busy_send_o       : OUT STD_LOGIC
    );
END COMPONENT;

COMPONENT e_mat_cpu       
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
CONSTANT c_start_sym  : t_byte := x"AB";

-- Zustaende
TYPE t_state IS (st_init, st_rec_image0); 
SIGNAL s_cur_state, s_next_state : t_state;

SIGNAL s_op_finished, s_cpu_rst, s_cpu_wren : STD_LOGIC;
SIGNAL s_opcode :  t_opcodes;
SIGNAL s_scalar : t_mat_elem;
SIGNAL s_sel_a, s_sel_b, s_sel_c : t_mat_reg_ixs;
SIGNAL s_row_by_row_c : t_op_std_logics;

SIGNAL s_write_a0_i, s_read_a0_i, s_row_by_row_a0_i : STD_LOGIC;
SIGNAL s_data_a0_i, s_data_a0_o : t_mat_word;
SIGNAL s_ix_a0_i : t_mat_ix;
SIGNAL s_size_a0_i : t_mat_size;

SIGNAL s_new_data, s_serial_data_read : STD_LOGIC;
SIGNAL s_serial_data_o : t_byte;

----------------------------------------------------------------------------------------------------
--  Port Maps
----------------------------------------------------------------------------------------------------
BEGIN

serial : e_serial
PORT MAP(
    p_rst_i         => p_rst_i,
    p_clk_i         => p_clk_i,
        
    p_rx_i          => p_rx_i,
    p_tx_o          => p_tx_o,

    p_new_data_o    => s_new_data,
    p_data_o        => s_serial_data_o,
    p_data_read_i   => s_serial_data_read,
    p_rx_err_o      => OPEN,

    p_data_i        => (OTHERS => '0'),
    p_send_i        => '0',
    p_busy_send_o   => OPEN
);

cpu : e_mat_cpu
PORT MAP(
    p_rst_i                 => p_rst_i,
    p_clk_i                 => p_clk_i,
    
    p_syn_rst_i             => s_cpu_rst,
    p_wren_i                => s_cpu_wren,
        
    p_finished_o            => s_op_finished,
    p_opcode_i              => s_opcode,
    p_scalar_i              => s_scalar,

    p_sel_a_i               => s_sel_a,
    p_sel_b_i               => s_sel_b,
    p_sel_c_i               => s_sel_c,
    p_row_by_row_c_i        => s_row_by_row_c,
    
    p_write_a0_i            => s_write_a0_i,
    p_read_a0_i             => s_read_a0_i,
    p_data_a0_i             => s_data_a0_i,
    p_data_a0_o             => s_data_a0_o,
    p_ix_a0_i               => s_ix_a0_i,
    p_size_a0_i             => s_size_a0_i,
    p_row_by_row_a0_i       => s_row_by_row_a0_i,
    p_size_a0_o             => OPEN,
    p_row_by_row_a0_o       => OPEN
);

----------------------------------------------------------------------------------------------------
--  Zustandsautomat
----------------------------------------------------------------------------------------------------
proc_change_state : PROCESS(p_clk_i, p_rst_i)
BEGIN
    IF p_rst_i = '1' THEN 
        s_cur_state <= st_init;
    ELSIF rising_edge(p_clk_i) THEN
        s_cur_state <= s_next_state;
    END IF;
END PROCESS proc_change_state;
  
  
--proc_calc_next_state : PROCESS(s_cur_state)
--BEGIN
--    CASE s_cur_state IS
--                  
--        WHEN st_init =>     IF s_new_data = '1' AND  s_serial_data_o = c_start_sym THEN 
--                                s_next_state <= st_rec_image0;
--                            ELSE 
--                                s_next_state <= s_cur_state;
--                            END IF;
--                            
--        WHEN          
--        
--        
--    
--    END CASE;
--END PROCESS proc_calc_next_state;

--proc_calc_output : PROCESS(s_cur_state)
--BEGIN
--    CASE s_cur_state is
--                          
--        WHEN st_init =>     s_serial_data_read  <= '0';
--                  
--
--    END CASE;
--END PROCESS proc_calc_output;

END ARCHITECTURE a_tle_nn;