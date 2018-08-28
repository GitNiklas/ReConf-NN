----------------------------------------------------------------------------------------------------
--  Testbench fuer e_timer
--  Simulationszeit: 300 us
--
--  Autor: Niklas Kuehl
--  Datum: 27.04.2018
----------------------------------------------------------------------------------------------------
LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;
USE work.pkg_tools.ALL;

ENTITY tb_timer IS
END ENTITY tb_timer;

ARCHITECTURE a_tb_timer OF tb_timer IS

COMPONENT e_timer
    GENERIC( 
        g_clk_period        : TIME;
        g_t0                : TIME;
        g_t1                : TIME;
        g_t2                : TIME
    );         
    PORT (    
        p_rst_i             : IN STD_LOGIC;
        p_clk_i             : IN STD_LOGIC;        
        p_start_i           : IN STD_LOGIC;
        
        p_t0_finished_o     : OUT STD_LOGIC;
        p_t1_finished_o     : OUT STD_LOGIC;
        p_t2_finished_o     : OUT STD_LOGIC
    );
END COMPONENT;

SIGNAL s_clk, s_rst, s_start : STD_LOGIC;
SIGNAL s_t0_finish, s_t1_finish, s_t2_finish : STD_LOGIC;

BEGIN

dut : e_timer
GENERIC MAP(
    g_clk_period        => c_clk_per,
    g_t0                => 50 us,
    g_t1                => 100 us,
    g_t2                => 160 us
)
PORT MAP(
    p_rst_i             => s_rst,
    p_clk_i             => s_clk,
    p_start_i           => s_start,
    p_t0_finished_o     => s_t0_finish,
    p_t1_finished_o     => s_t1_finish,
    p_t2_finished_o     => s_t2_finish
);

proc_clk_gen : PROCESS
BEGIN
    s_clk <= '0';
    WAIT FOR c_clk_per / 2;
    s_clk <= '1';
    WAIT FOR c_clk_per / 2;
END PROCESS proc_clk_gen;

proc_test_count : PROCESS
BEGIN
    WAIT FOR c_clk_per;
    s_rst <= '1';
    s_start <= '0';  
    WAIT FOR c_clk_per;
    s_rst <= '0';
    WAIT FOR c_clk_per;

    REPORT "Normales Zaehlen Testen";
    s_start <= '1';
    WAIT FOR c_clk_per;
    s_start <= '0';
    WAIT FOR 45 us;
    ASSERT( s_t0_finish = '0');
    ASSERT( s_t1_finish = '0');
    ASSERT( s_t2_finish = '0');
    WAIT FOR 6 us;
    ASSERT( s_t0_finish = '1');
    ASSERT( s_t1_finish = '0');
    ASSERT( s_t2_finish = '0');
    WAIT FOR 50 us;
    ASSERT( s_t0_finish = '1');
    ASSERT( s_t1_finish = '1');
    ASSERT( s_t2_finish = '0');  
    WAIT FOR 60 us;
    ASSERT( s_t0_finish = '1');
    ASSERT( s_t1_finish = '1');
    ASSERT( s_t2_finish = '1');
    REPORT "Timer erfolgreich bis 160 us gezaehlt";
    
    
  
    REPORT "Reset Testen";
    s_start <= '1';
    WAIT FOR c_clk_per;
    s_start <= '0';
    WAIT FOR 45 us;
    ASSERT( s_t0_finish = '0');
    ASSERT( s_t1_finish = '0');
    ASSERT( s_t2_finish = '0');
    s_rst <= '1';
    REPORT "Reset erfolgt";
    WAIT FOR c_clk_per;
    s_rst <= '0';
    WAIT FOR 45 us;
    ASSERT( s_t0_finish = '0');
    ASSERT( s_t1_finish = '0');
    ASSERT( s_t2_finish = '0');
    REPORT "Timer nicht abgelaufen - OK";
  
    REPORT "Testende";
    WAIT;
END PROCESS proc_test_count;

END ARCHITECTURE a_tb_timer;