----------------------------------------------------------------------------------------------------
--  Testbench fuer e_shift_reg
--  Simulationszeit: 5 us
--
--  Autor: Niklas Kuehl
----------------------------------------------------------------------------------------------------
LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;
USE work.pkg_tools.ALL;

ENTITY tb_shift_reg IS
END ENTITY tb_shift_reg;

ARCHITECTURE a_tb_shift_reg OF tb_shift_reg IS

CONSTANT testdata : STD_LOGIC_VECTOR(7 DOWNTO 0) := "11001100";

COMPONENT e_shift_reg
    GENERIC (n : POSITIVE := 16);
    PORT (
        p_rst_i         : in STD_LOGIC;
        p_clk_i         : in STD_LOGIC;
    
        p_data_i        : in STD_LOGIC_VECTOR(N-1 DOWNTO 0);
        p_data_o        : out STD_LOGIC_VECTOR(N-1 DOWNTO 0); 

        p_data_shift_i  : in STD_LOGIC;
        p_data_shift_o  : out STD_LOGIC;
    
        p_load_data_i   : in STD_LOGIC;
        p_shift_data_i  : in STD_LOGIC
    );
END COMPONENT;

SIGNAL s_clk, s_rst, s_shift_i, s_shift_o, s_load, s_shift : STD_LOGIC;
SIGNAL s_data_i, s_data_o : STD_LOGIC_VECTOR(7 DOWNTO 0);

BEGIN

dut : e_shift_reg
GENERIC MAP(n => 8)
PORT MAP(
    p_rst_i             => s_rst,
    p_clk_i             => s_clk,
    p_data_i            => s_data_i,
    p_data_o            => s_data_o,      
    p_data_shift_i      => s_shift_i,
    p_data_shift_o      => s_shift_o,
    p_load_data_i       => s_load,
    p_shift_data_i      => s_shift
);

proc_clk_gen : PROCESS
BEGIN
    s_clk <= '0';
    WAIT FOR c_clk_per / 2;
    s_clk <= '1';
    WAIT FOR c_clk_per / 2;
END PROCESS proc_clk_gen;

proc_test_shift_reg : PROCESS
VARIABLE v_testdata : STD_LOGIC_VECTOR(7 DOWNTO 0);
BEGIN
    REPORT "Initialisierung";
    WAIT FOR C_CLK_PER;
    s_rst <= '1';
    s_load <= '0';
    s_shift <= '0';
    s_shift_i <= '0';
    s_data_i <= "00000000";
    WAIT FOR c_clk_per;
    s_rst <= '0';
    WAIT FOR c_clk_per;

    REPORT "Testdatum laden";
    s_data_i <= testdata;
    s_load <= '1';
    WAIT FOR c_clk_per;
    s_load <= '0';
    
    v_testdata := testdata;
    REPORT "Rechtsshift testen";
    FOR i IN 0 TO 7 LOOP
        ASSERT(s_shift_o = s_data_i(i)) REPORT "s_shift_o vor Rechtshift " & INTEGER'IMAGE(i) & " fehlerhaft";
        s_shift_i <= '0';
        s_shift <= '1';
        WAIT FOR c_clk_per;

        s_shift <= '0';
        v_testdata := '0' & v_testdata(7 DOWNTO 1);
        ASSERT(s_data_o = v_testdata) REPORT "s_data_o nach Rechtshift " & INTEGER'IMAGE(i) & " fehlerhaft";

        WAIT FOR 4*c_clk_per;
    END LOOP;

    REPORT "Testende";
    WAIT;
END PROCESS proc_test_shift_reg;

END ARCHITECTURE a_tb_shift_reg;