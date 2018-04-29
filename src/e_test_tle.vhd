LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;
use work.pkg_tools.c_baudrate;

----------------------------------------------------------------------------------------------------
--  Entity
----------------------------------------------------------------------------------------------------
ENTITY e_test_tle IS
    GENERIC(
        g_clk_periode       : TIME      := 20 ns
    );
    PORT(
        p_rst_i             : IN STD_LOGIC;
        p_clk_i             : IN STD_LOGIC;
        
        p_rx_i              : IN STD_LOGIC;
        p_tx_o              : OUT STD_LOGIC;
        
        p_rx_err_o          : OUT STD_LOGIC;
        
        p_busy_send_o       : OUT STD_LOGIC
    );
END ENTITY e_test_tle;


----------------------------------------------------------------------------------------------------
--  Architecture
----------------------------------------------------------------------------------------------------
ARCHITECTURE a_test_tle OF e_test_tle IS

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
        p_data_o            : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        p_data_read_i       : IN STD_LOGIC;
        p_rx_err_o          : OUT STD_LOGIC;
    
        p_data_i            : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        p_send_i            : IN STD_LOGIC;
        p_busy_send_o       : OUT STD_LOGIC
    );
END COMPONENT;

----------------------------------------------------------------------------------------------------
--  Typen / Signale
----------------------------------------------------------------------------------------------------

-- Zustaende
TYPE state IS (st_init, st_start_send, st_busy_send); 
SIGNAL s_cur_state, s_next_state : state;

SIGNAL s_data : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL s_new_data, s_data_read, s_send, s_busy_send : STD_LOGIC;

----------------------------------------------------------------------------------------------------
--  Port Maps
----------------------------------------------------------------------------------------------------
BEGIN

serial : e_serial
GENERIC MAP(g_clk_periode, c_baudrate)
PORT MAP(
    p_rst_i         => p_rst_i,
    p_clk_i         => p_clk_i,
    
    p_rx_i          => p_rx_i,
    p_tx_o          => p_tx_o,
    
    p_new_data_o    => s_new_data,
    p_data_o        => s_data,
    p_data_read_i   => s_data_read,
    p_rx_err_o      => p_rx_err_o,
    
    p_data_i        => s_data,
    p_send_i        => s_send,
    p_busy_send_o   => s_busy_send
);

----------------------------------------------------------------------------------------------------
--  Zuweisungen
----------------------------------------------------------------------------------------------------

p_busy_send_o <= s_busy_send;
 
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
  
  
proc_calc_next_state : PROCESS(s_cur_state, s_new_data, s_busy_send)
BEGIN
    CASE s_cur_state IS
                  
        WHEN st_init =>         IF s_new_data = '1' THEN 
                                    s_next_state <= st_start_send;
                                ELSE 
                                    s_next_state <= s_cur_state;
                                END IF;
    
        WHEN st_start_send =>   s_next_state <= st_busy_send;
                          
        WHEN st_busy_send =>    IF s_busy_send = '0' THEN
                                    s_next_state <= st_init;
                                ELSE
                                    s_next_state <= s_cur_state;
                                END IF;

    END CASE;
END PROCESS proc_calc_next_state;

proc_calc_output : PROCESS(s_cur_state)
BEGIN
    CASE s_cur_state is
                          
        WHEN st_init =>         s_data_read     <= '0';
                                s_send          <= '0';
                  
        WHEN st_start_send =>   s_data_read     <= '0';
                                s_send          <= '1';
                          
        WHEN st_busy_send =>    s_data_read     <= '1';
                                s_send          <= '0';


    END CASE;
END PROCESS proc_calc_output;

END ARCHITECTURE a_test_tle;