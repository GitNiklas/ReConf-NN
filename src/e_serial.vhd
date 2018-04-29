----------------------------------------------------------------------------------------------------
-- Modul zur Kommunikation über die serielle Schnittstelle.
-- Die Kommunikation erfolgt mit: 8 Datenbits, 1 Stoppbit, Keine Parität
-- Die Baudrate ist variabel.
--
--  Generics:
--      g_clk_periode   : Periodendauer des Taktes p_clk_i
--      g_baudrate      : Baudrate mit der kommuniziert werden soll
--
--  Port:
--      p_rst_i         : Asynchroner Reset
--      p_clk_i         : Takt
--       
--      p_rx_i          : Empfangskanal RxD
--      p_tx_o          : Sendekanal TxD
--
--      p_data_o        : Gelesene Daten
--      p_new_data_o    : Signalisiert, dass neue Daten vorliegen
--      p_d_data_read_o : Signalisiert, dass die Daten geleseen worden sind
--      p_rx_err_o      : Signalisiert, dass beim Empfangen ein Fehler aufgetreten ist
--    
--      p_data_i        : Zu sendende Daten
--      p_send_i        : Signalisiert, dass die Daten gesendet werden sollen
--      p_busy_send_o   : Signalisiert, dass gerade Daten gesendet werden
--
--  Autor: Niklas Kuehl
--  Datum: 26.04.2018
----------------------------------------------------------------------------------------------------
LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;

----------------------------------------------------------------------------------------------------
--  Entity
----------------------------------------------------------------------------------------------------
ENTITY e_serial IS
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
END ENTITY e_serial;


----------------------------------------------------------------------------------------------------
--  Architecture
----------------------------------------------------------------------------------------------------
ARCHITECTURE a_serial OF e_serial IS

----------------------------------------------------------------------------------------------------
--  Komponenten
----------------------------------------------------------------------------------------------------

COMPONENT e_serial_send
    GENERIC(  
        g_clk_periode           : TIME := 20 ns;
        g_baudrate              : POSITIVE := 115200
    );
    PORT (
        p_rst_i                 : IN STD_LOGIC;
        p_clk_i                 : IN STD_LOGIC;
        
        p_tx_o                  : OUT STD_LOGIC;
        
        p_data_i                : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        p_send_i                : IN STD_LOGIC;
        p_busy_send_o           : OUT STD_LOGIC
    );
END COMPONENT;

COMPONENT e_serial_receive
    GENERIC(  
        g_clk_periode           : TIME := 20 ns;
        g_baudrate              : POSITIVE := 115200
    );
    PORT (
        p_rst_i                 : IN STD_LOGIC;
        p_clk_i                 : IN STD_LOGIC;

        p_rx_i                  : IN STD_LOGIC;
        
        p_new_data_o            : OUT STD_LOGIC;
        p_data_o                : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        p_data_read_i           : IN STD_LOGIC;
        p_rx_err_o              : OUT STD_LOGIC
    );
END COMPONENT;

----------------------------------------------------------------------------------------------------
--  Typen / Signale
----------------------------------------------------------------------------------------------------
    
----------------------------------------------------------------------------------------------------
--  PORT Maps
----------------------------------------------------------------------------------------------------
BEGIN

SENDER : e_serial_send
GENERIC MAP(g_clk_periode, g_baudrate)
PORT MAP(
    p_rst_i         => p_rst_i,
    p_clk_i         => p_clk_i,
    p_tx_o          => p_tx_o,
    
    p_data_i        => p_data_i,
    p_send_i        => p_send_i,
    p_busy_send_o   => p_busy_send_o
);

RECEIVER : e_serial_receive
GENERIC MAP(g_clk_periode, g_baudrate)
PORT MAP(
    p_rst_i         => p_rst_i,
    p_clk_i         => p_clk_i,
    p_rx_i          => p_rx_i,
    
    p_new_data_o    => p_new_data_o,
    p_data_o        => p_data_o,
    p_data_read_i   => p_data_read_i,
    p_rx_err_o      => p_rx_err_o
);

END ARCHITECTURE a_serial;