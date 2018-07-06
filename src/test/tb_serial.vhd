----------------------------------------------------------------------------------------------------
--  Testbench fuer e_serial
--  Simulationszeit: 800 us
--
--  Autor: Niklas Kuehl
--  Datum: 27.04.2018
----------------------------------------------------------------------------------------------------
LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;
USE work.pkg_tools.ALL;

ENTITY tb_serial IS
END ENTITY tb_serial;

ARCHITECTURE a_tb_serial OF tb_serial IS

CONSTANT c_baudrate : POSITIVE := 115200;
CONSTANT c_serial_wait_time : TIME := f_calc_serial_wait_time(c_baudrate);

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

---------------------------------------------
--  Prozeduren/Funktionen
---------------------------------------------

----------------------------------------------------------------------------------------------------
--  Procedure test_send
----------------------------------------------------------------------------------------------------
PROCEDURE test_send(
    SIGNAL s_data_i         : OUT t_byte;
    SIGNAL s_send           : OUT STD_LOGIC; 
    SIGNAL s_busy_send      : IN STD_LOGIC;
    SIGNAL s_tx             : IN STD_LOGIC;
    constant c_data_to_send : IN t_byte
    ) IS 
BEGIN
    REPORT "Test: Sende Datenwort";
  
    ASSERT s_busy_send = '0' REPORT "s_busy_send sollte 0 sein";
    ASSERT s_tx = '1' REPORT "s_tx sollte 1 sein (Ruhezustand)";
    
    WAIT FOR c_clk_per;
    s_data_i <= c_data_to_send(7 DOWNTO 0);
    WAIT FOR c_clk_per;
    s_send <= '1';
    WAIT FOR c_clk_per;
    s_send <= '0';
    WAIT FOR c_clk_per;
  
    ASSERT s_busy_send = '1' REPORT "s_busy_send sollte 1 sein";
  
    WAIT FOR c_serial_wait_time / 2;
    ASSERT s_busy_send = '1' REPORT "s_busy_send sollte 1 sein";
    ASSERT s_tx = '0' REPORT "s_tx sollte 0 sein (Startbit)";
  
    FOR i IN 0 TO 7 LOOP
        WAIT FOR c_serial_wait_time;
        ASSERT s_busy_send = '1' REPORT "S_BUSY_SEND sollte 1 sein";
        ASSERT s_tx = c_data_to_send(i) 
        REPORT "Fehler beim Senden des " & INTEGER'IMAGE(i)
        & ". Bits: Tx sollte " & STD_LOGIC'IMAGE(c_data_to_send(i)) & " sein, ist aber " 
        & STD_LOGIC'IMAGE(s_tx);
    END LOOP;
  
    WAIT FOR c_serial_wait_time;
    ASSERT s_busy_send = '1' REPORT "S_BUSY_SEND sollte 1 sein";
    ASSERT s_tx = '1' REPORT "s_tx sollte 1 sein (Stoppbit)";
  
    WAIT FOR c_serial_wait_time;
    ASSERT s_busy_send = '0' REPORT "s_busy_send sollte 0 sein";
    ASSERT s_tx = '1' REPORT "s_tx sollte 1 sein (Ruhezustand)";
  
    REPORT "Testende: Sende Datenwort";
END test_send;


----------------------------------------------------------------------------------------------------
--  Procedure test_receive
----------------------------------------------------------------------------------------------------
PROCEDURE test_receive(
    SIGNAL s_rst            : OUT STD_LOGIC;
    SIGNAL s_data_o         : IN t_byte;
    SIGNAL s_new_data       : IN STD_LOGIC; 
    SIGNAL s_data_read      : OUT STD_LOGIC; 
    SIGNAL s_rx_err         : IN STD_LOGIC;
    SIGNAL s_rx             : OUT STD_LOGIC;
    constant c_data_to_rec  : IN t_byte;
    constant c_test_err     : IN BOOLEAN
    ) IS 
BEGIN
    REPORT "Test: Empfange Datenwort";
    
    IF c_test_err THEN
        REPORT "Teste Fehlerhafte Uebertragung";
    END IF;
    
    ASSERT s_new_data = '0' REPORT "s_new_data sollte 0 sein";
    ASSERT s_rx_err = '0' REPORT "s_rx_err sollte 0 sein";
    
    REPORT "Sende Startbit";
    s_rx <= '0';
    WAIT FOR c_serial_wait_time;
    
    FOR i IN 0 TO 7 LOOP
        REPORT "Sende Datenbit " & INTEGER'IMAGE(i);
        s_rx <= c_data_to_rec(i);
        WAIT FOR c_serial_wait_time;
    END LOOP;
    
    IF NOT c_test_err THEN
        REPORT "Sende Stoppbit";
        s_rx <= '1';
    ELSE
        REPORT "Sende KEIN Stoppbit";
        s_rx <= '0';
    END IF; 
    WAIT FOR c_serial_wait_time;
    
    IF NOT c_test_err THEN
        ASSERT s_new_data = '1' REPORT "s_new_data sollte 1 sein";
        ASSERT s_data_o = c_data_to_rec REPORT "Fehler beim Empfangen: Daten fehlerhaft";
        s_data_read <= '1';
    ELSE
        ASSERT s_rx_err = '1' REPORT "s_rx_err sollte 1 sein";
        s_rst <= '1';
    END IF;
  
    WAIT FOR c_clk_per;
    s_data_read <= '0';
  
    REPORT "Testende: Empfange Datenwort";
END test_receive;

---------------------------------------------
--  Signale
---------------------------------------------

SIGNAL s_clk, s_rst, s_rx, s_tx : STD_LOGIC;
SIGNAL s_new_data, s_data_read, s_rx_err: STD_LOGIC;
SIGNAL s_data_o: t_byte;
SIGNAL s_send, s_busy_send: STD_LOGIC;
SIGNAL s_data_i: t_byte;

---------------------------------------------
--  Port Maps
---------------------------------------------

BEGIN

dut : e_serial
GENERIC MAP(
    g_clk_periode       => c_clk_per,
    g_baudrate          => c_baudrate
)
PORT MAP(
    p_rst_i             => s_rst,
    p_clk_i             => s_clk,

    p_rx_i              => s_rx,
    p_tx_o              => s_tx,

    p_new_data_o        => s_new_data,
    p_data_o            => s_data_o,
    p_data_read_i       => s_data_read, 
    p_rx_err_o          => s_rx_err,

    p_data_i            => s_data_i,
    p_send_i            => s_send,
    p_busy_send_o       => s_busy_send
);

---------------------------------------------
--  Prozesse
---------------------------------------------

proc_clk_gen : PROCESS
BEGIN
    s_clk <= '0';
    WAIT FOR c_clk_per / 2;
    s_clk <= '1';
    WAIT FOR c_clk_per / 2;
END PROCESS proc_clk_gen;

proc_test_serial : PROCESS
BEGIN
    REPORT "Test Start";
    REPORT "Baudrate: " & INTEGER'IMAGE(c_baudrate);
    REPORT "Serial Wait Time: " & TIME'IMAGE(c_serial_wait_time);
      
    s_rx <= '1';
    s_data_read <= '0';
    
    WAIT FOR c_clk_per;
    s_rst <= '1';
    WAIT FOR c_clk_per;
    s_rst <= '0';
    WAIT FOR c_clk_per;

    REPORT "Test Senden";
    test_send(s_data_i, s_send, s_busy_send, s_tx, b"0100_1110");  
    test_send(s_data_i, s_send, s_busy_send, s_tx, b"0000_0000");  
    test_send(s_data_i, s_send, s_busy_send, s_tx, b"1111_1111");  
    test_send(s_data_i, s_send, s_busy_send, s_tx, b"1010_1010"); 
    
    REPORT "Test Empfangen";
    test_receive(s_rst, s_data_o, s_new_data, s_data_read, s_rx_err, s_rx, b"0100_1110", FALSE);
    test_receive(s_rst, s_data_o, s_new_data, s_data_read, s_rx_err, s_rx, b"0000_0000", FALSE);
    test_receive(s_rst, s_data_o, s_new_data, s_data_read, s_rx_err, s_rx, b"1111_1111", FALSE);
    test_receive(s_rst, s_data_o, s_new_data, s_data_read, s_rx_err, s_rx, b"0100_1110", TRUE);
  
    REPORT "Testende";
    WAIT;
END PROCESS proc_test_serial;

END ARCHITECTURE a_tb_serial;