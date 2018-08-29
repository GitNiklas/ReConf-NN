----------------------------------------------------------------------------------------------------
--  Testbench fuer e_tle_nn
--  Simulationszeit: ?? ms
--
--  Autor: Niklas Kuehl
--  Datum: 27.08.2018
----------------------------------------------------------------------------------------------------
LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.all;
USE work.pkg_tools.ALL;
USE work.pkg_test.ALL;
USE work.fixed_pkg.ALL;
USE work.pkg_test_matrices.ALL;

ENTITY tb_tle IS
END ENTITY tb_tle;

ARCHITECTURE a_tb_tle OF tb_tle IS

COMPONENT e_tle_nn
    GENERIC(
        g_clk_period        : TIME      := c_clk_per;
        g_baudrate          : POSITIVE  := c_baudrate 
    ); 
    PORT (    
        p_rst_i             : IN STD_LOGIC;
        p_clk_i             : IN STD_LOGIC;
        p_set_debug_i       : IN STD_LOGIC;
        
        p_rx_i              : IN STD_LOGIC;
        p_tx_o              : OUT STD_LOGIC;
        
        p_err_o             : OUT STD_LOGIC;
        p_init_o            : OUT STD_LOGIC;
        p_wait_data_o       : OUT STD_LOGIC;
        p_rw_mat_o          : OUT STD_LOGIC;
        p_run_algo          : OUT STD_LOGIC;
        p_train_o           : OUT STD_LOGIC;
        p_test_o            : OUT STD_LOGIC
    );
END COMPONENT;

---------------------------------------------
--  Signale
---------------------------------------------

SIGNAL s_clk, s_rst : STD_LOGIC;
SIGNAL s_rx, s_tx : STD_LOGIC;
SIGNAL s_wait_data, s_set_debug, s_run_algo : STD_LOGIC;

---------------------------------------------
--  Port Maps
---------------------------------------------
BEGIN

dut : e_tle_nn
GENERIC MAP(
    g_clk_period            => c_clk_per,
    g_baudrate              => c_test_baudrate
)
PORT MAP(
    p_rst_i                 => s_rst,
    p_clk_i                 => s_clk,
    p_set_debug_i           => s_set_debug,   
    
    p_rx_i                  => s_tx,
    p_tx_o                  => s_rx,
    
    p_err_o                 => OPEN,
    p_init_o                => OPEN,
    p_wait_data_o           => s_wait_data,
    p_rw_mat_o              => OPEN,
    p_run_algo              => s_run_algo,
    p_train_o               => OPEN,
    p_test_o                => OPEN
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

proc_test : PROCESS
VARIABLE    v_byte : t_byte;
VARIABLE    tmp : REAL;
VARIABLE    seed1 : POSITIVE := 4;
VARIABLE    seed2 : POSITIVE := 88;
BEGIN
    REPORT infomsg("Test Start");
    REPORT infomsg("Initialisiere Signale");
           
    s_rst <= '1';
    s_set_debug <= '0';
    s_tx <= '1';
    WAIT FOR 2*c_clk_per;
    s_rst <= '0';
        
    REPORT infomsg("Initialisierung abgeschlossen");

    REPORT infomsg("Empfange Byte");
    serial_receive(v_byte, s_rx);
        
    REPORT infomsg("Warte auf s_wait_data");
    IF s_wait_data /= '1' THEN 
        WAIT UNTIL s_wait_data = '1'; 
    END IF;   
    REPORT infomsg("FPGA Init abgeschlossen");
    
    serial_send(x"E0", s_tx);  
    REPORT infomsg("Initialisiere w1...");
    
    FOR i IN 1 TO 4096 LOOP
        --REPORT infomsg("Sende Byte " & INTEGER'IMAGE(i));
        random_elem(-1.0, 1.0, seed1, seed2, tmp);
        serial_send(to_slv(to_mat_elem(tmp)), s_tx);
    END LOOP;
    REPORT infomsg("w1 initialisiert");
      
    serial_send(x"E1", s_tx);  
    REPORT infomsg("Initialisiere w2...");
    FOR i IN 1 TO 640 LOOP
        random_elem(-1.0, 1.0, seed1, seed2, tmp);
        serial_send(to_slv(to_mat_elem(tmp)), s_tx);
    END LOOP;
    REPORT infomsg("w2 initialisiert");
    
    REPORT infomsg("Starte Trainingsphase - Initialisiere x_train...");
    serial_send(x"E2", s_tx); 
    FOR i IN x_train'RANGE LOOP
        serial_send(to_slv(to_mat_elem(x_train(i))), s_tx);
    END LOOP;
    REPORT infomsg("x_train initialisiert");
    
    REPORT infomsg("Initialisiere y_train...");
    serial_send(x"E3", s_tx); 
    FOR i IN y_train'RANGE LOOP
        serial_send(STD_LOGIC_VECTOR(TO_UNSIGNED(y_train(i), 8)), s_tx);
    END LOOP;
    REPORT infomsg("y_train initialisiert");
    
    REPORT infomsg("Fuehre Algorithmus aus ..."); 
    
    WAIT FOR 4*c_clk_per;
    WAIT UNTIL s_run_algo = '0';
    WAIT FOR c_clk_per / 2;
    REPORT infomsg("Trainingsphase beendet");
      
--    debug_save_mat_reg_to_file("tb_tle/07 scores.txt", 8, 64, 10, TRUE, s_tx, s_rx, s_set_debug);
--    debug_save_mat_reg_to_file("tb_tle/10 tmp1.txt", 9, 64, 10, FALSE, s_tx, s_rx, s_set_debug);
--    debug_save_mat_reg_to_file("tb_tle/12 dw1.txt", 4, 64, 64, FALSE, s_tx, s_rx, s_set_debug);
--    debug_save_mat_reg_to_file("tb_tle/13 w1.txt", 0, 64, 64, FALSE, s_tx, s_rx, s_set_debug);
--    debug_save_mat_reg_to_file("tb_tle/13 tmp2.txt", 10, 64, 10, FALSE, s_tx, s_rx, s_set_debug); 
--    debug_save_mat_reg_to_file("tb_tle/14 db1.txt", 5, 1, 64, TRUE, s_tx, s_rx, s_set_debug); 
--    debug_save_mat_reg_to_file("tb_tle/15 b1.txt", 1, 1, 64, TRUE, s_tx, s_rx, s_set_debug);
--    debug_save_mat_reg_to_file("tb_tle/15 dw2.txt", 6, 64, 10, FALSE, s_tx, s_rx, s_set_debug);
--    debug_save_mat_reg_to_file("tb_tle/16 w2.txt", 2, 64, 10, FALSE, s_tx, s_rx, s_set_debug);
--    debug_save_mat_reg_to_file("tb_tle/16 db2.txt", 7, 1, 10, TRUE, s_tx, s_rx, s_set_debug);
--    debug_save_mat_reg_to_file("tb_tle/17 b2.txt", 3, 1, 10, TRUE, s_tx, s_rx, s_set_debug);
    
    REPORT infomsg("Starte Testphase - Initialisiere x_test...");
    serial_send(x"A1", s_tx); 
    FOR i IN x_train'RANGE LOOP
        serial_send(to_slv(to_mat_elem(x_train(i))), s_tx);
    END LOOP;
    REPORT infomsg("x_test initialisiert");  
    
    REPORT infomsg("Fuehre Algorithmus aus ...");
    
    receive_mat_save_to_file("res_scores.txt", 8, 64, 10, TRUE, s_rx);
    
    REPORT infomsg("Testende");
    WAIT;
END PROCESS proc_test;

END ARCHITECTURE a_tb_tle;