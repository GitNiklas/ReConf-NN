----------------------------------------------------------------------------------------------------
--  Testbench fuer e_mat_reg
--  Simulationszeit: 1 ms
--
--  Autor: Niklas Kuehl
----------------------------------------------------------------------------------------------------
LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.all;
USE work.pkg_tools.ALL;
USE work.pkg_test.ALL;
USE work.fixed_pkg.ALL;

ENTITY tb_mat_reg IS
END ENTITY tb_mat_reg;

ARCHITECTURE a_tb_mat_reg OF tb_mat_reg IS

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


---------------------------------------------
--  Signale
---------------------------------------------

SIGNAL s_clk, s_rst, s_wren, s_row_by_row, s_row_by_row_o : STD_LOGIC;

SIGNAL s_data_i, s_data_o : t_mat_word;
SIGNAL s_size_i, s_size_o : t_mat_size;
SIGNAL s_ix_r, s_ix_w : t_mat_ix;

---------------------------------------------
--  Port Maps
---------------------------------------------
BEGIN

dut : e_mat_reg
PORT MAP(
    p_clk_i         => s_clk,
    p_rst_i         => s_rst,
        
    p_mat_size_i    => s_size_i,
    p_mat_size_o    => s_size_o,
        
    p_ix_read_i     => s_ix_r,
    p_ix_write_i    => s_ix_w,
    
    p_wren_i        => s_wren,
    
    p_row_by_row_i  => s_row_by_row,
    p_row_by_row_o  => s_row_by_row_o,
    
    p_word_i        => s_data_i,
    p_word_o        => s_data_o
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

proc_test_mat_reg : PROCESS
BEGIN
    REPORT "Test Start";

----------------------------------------------------------------------------------------------------
--  Init
----------------------------------------------------------------------------------------------------
    REPORT infomsg("Initialisiere Signale");
    s_rst <= '1';
    s_data_i <= (others => to_mat_elem(15.9325));
    s_ix_r <= to_mat_ix(4, 4);
    s_ix_w <= c_mat_ix_zero;
    
    s_size_i <= to_mat_size(1, 1);
    
    s_wren <= '1';
    s_row_by_row <= '1';
    
    WAIT FOR c_clk_per;
    s_rst <= '0';
    ASSERT s_size_o = to_mat_size(1, 1) REPORT err("Gespeicherte Matrix-Groesse falsch");
    
    FOR y IN 0 TO c_max_mat_dim - 1 LOOP
        FOR x IN 0 TO c_max_mat_dim - 1 LOOP
            s_ix_w <= to_mat_ix(y, x);
            WAIT FOR c_clk_per;
        END LOOP;
    END LOOP;
    
    WAIT FOR c_clk_per;
    s_wren <= '0';
  
    REPORT infomsg("Initialisierung abgeschlossen");
    
    REPORT infomsg("Beschreibe Matrix zeilenweise");
    -- 1   2   3
    -- 4   5   6
    s_wren <= '1';
    s_size_i <= to_mat_size(2, 3);
    
    s_ix_w <= to_mat_ix(0, 0); -- Es koennen die Spalten 0-31 gleichzeitig geschrieben werden
    s_data_i <= to_mat_word((1.0, 2.0, 3.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                               0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    
    s_ix_w <= to_mat_ix(1, 0);
    s_data_i <= to_mat_word((4.0, 5.0, 6.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                               0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    
    ASSERT s_row_by_row_o = '1' REPORT err("Zeilen/Spalten falsch gespeichert (row_by_row falsch)");
    ASSERT s_size_o = to_mat_size(2, 3) REPORT err("Gespeicherte Matrix-Groesse falsch");
    s_wren <= '0';
    
    REPORT infomsg("Lese Matrix zeilenweise");
    
    s_ix_r <= to_mat_ix(0, 0);
    WAIT FOR 2*c_clk_per;
    REPORT infomsg("Lese Zeile 0 der Matrix");
    ASSERT s_data_o = to_mat_word((1.0, 2.0, 3.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                                    0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0))
        REPORT err("0. Zeile der Matrix fehlerhaft");
    
    s_ix_r <= to_mat_ix(1, 0);
    WAIT FOR 2*c_clk_per;
    REPORT infomsg("Lese Zeile 1 der Matrix");
    ASSERT s_data_o = to_mat_word((4.0, 5.0, 6.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                                    0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0))
        REPORT err("1. Zeile der Matrix fehlerhaft");
    
    REPORT infomsg("Beschreibe Matrix spaltenweise");
    -- 1   2   3
    -- 4   5   6
    s_wren <= '1';
    s_row_by_row <= '0';
    s_size_i <= to_mat_size(2, 3);
    WAIT FOR c_clk_per;
    
    s_ix_w <= to_mat_ix(0, 10); -- Es koennen die Zeilen 0-31 gleichzeitig geschrieben werden
    s_data_i <= to_mat_word((1.0, 4.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                               0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    
    s_ix_w <= to_mat_ix(0, 11);
    s_data_i <= to_mat_word((2.0, 5.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                               0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    
    s_ix_w <= to_mat_ix(0, 12);
    s_data_i <= to_mat_word((3.0, 6.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                               0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    
    ASSERT s_row_by_row_o = '0' REPORT err("Zeilen/Spalten falsch gespeichert (row_by_row falsch)");
    ASSERT s_size_o = to_mat_size(2, 3) REPORT err("Gespeicherte Matrix-Groesse falsch");
    s_wren <= '0';
    
    REPORT infomsg("Lese Matrix spaltenweise");
    
    s_ix_r <= to_mat_ix(0, 10);
    WAIT FOR 2*c_clk_per;
    REPORT infomsg("Lese Spalte 10 der Matrix");
    ASSERT s_data_o = to_mat_word((1.0, 4.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                               0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0))
        REPORT ERR("0. Spalte der Matrix fehlerhaft");
    
    s_ix_r <= to_mat_ix(0, 11);
    WAIT FOR 2*c_clk_per;
    REPORT infomsg("Lese Spalte 11 der Matrix");
    ASSERT s_data_o = to_mat_word((2.0, 5.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                               0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0))
        REPORT err("1. Spalte der Matrix fehlerhaft");
     
    s_ix_r <= to_mat_ix(0, 12);
    WAIT FOR 2*c_clk_per;
    REPORT infomsg("Lese Spalte 12 der Matrix");
    ASSERT s_data_o = to_mat_word((3.0, 6.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                               0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0))
        REPORT err("2. Spalte der Matrix fehlerhaft");
        
    REPORT infomsg("Testende");
    WAIT;
END PROCESS proc_test_mat_reg;

END ARCHITECTURE a_tb_mat_reg;