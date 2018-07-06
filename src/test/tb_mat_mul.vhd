----------------------------------------------------------------------------------------------------
--  Testbench fuer e_mat_mul
--  Simulationszeit: 2 ms
--
--  Autor: Niklas Kuehl
--  Datum: 17.05.2018
----------------------------------------------------------------------------------------------------
LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.all;
USE work.pkg_tools.ALL;
USE work.pkg_test.ALL;
USE work.fixed_pkg.ALL;

ENTITY tb_mat_mul IS
END ENTITY tb_mat_mul;

ARCHITECTURE a_tb_mat_mul OF tb_mat_mul IS

COMPONENT e_mat_mul
    PORT (    
        p_rst_i                 : IN STD_LOGIC;
        p_clk_i                 : IN STD_LOGIC;
        
        p_syn_rst_i             : IN STD_LOGIC;
        p_finished_o            : OUT STD_LOGIC;
        
        p_mat_a_size_i          : IN t_mat_size;
        p_mat_a_ix_o            : OUT t_mat_ix;
        p_mat_a_data_i          : IN t_mat_word; -- a has to be line_by_line
        
        p_mat_b_size_i          : IN t_mat_size;
        p_mat_b_ix_o            : OUT t_mat_ix;
        p_mat_b_data_i          : IN t_mat_word; -- b has to be row_by_row

        p_mat_c_ix_o            : OUT t_mat_ix; 
        p_mat_c_data_o          : OUT t_mat_word;
        p_mat_c_row_by_row_i    : IN STD_LOGIC;
        p_mat_c_size_o          : OUT t_mat_size
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

---------------------------------------------
--  Signale
---------------------------------------------

SIGNAL s_clk, s_rst, s_rst_mul : STD_LOGIC;

SIGNAL s_a_data_i, s_a_data_o, s_b_data_i, s_b_data_o, s_c_data_i, s_c_data_o : t_mat_word;
SIGNAL s_a_size_i, s_a_size_o, s_b_size_i, s_b_size_o, s_c_size_i, s_c_size_o: t_mat_size;
SIGNAL s_a_ix_r, s_a_ix_w, s_b_ix_r, s_b_ix_w, s_c_ix_r, s_c_ix_w : t_mat_ix;
SIGNAL s_a_wren, s_b_wren, s_c_wren : STD_LOGIC;
SIGNAL s_mul_finished_t1, s_mul_finished_t2, s_mul_finished_t3 : STD_LOGIC;

SIGNAL s_mul_a_ix_r, s_mul_b_ix_r, s_mul_c_ix_w, s_nomul_a_ix_r, s_nomul_b_ix_r, s_nomul_c_ix_w : t_mat_ix;
SIGNAL s_mul_c_data_i, s_nomul_c_data_i : t_mat_word;
SIGNAL s_mul_c_wren, s_nomul_c_wren, s_enable_mul : STD_LOGIC;
SIGNAL s_a_row_by_row_i, s_c_row_by_row_i, s_c_row_by_row_o, s_a_row_by_row_o, s_b_row_by_row_o : STD_LOGIC;
SIGNAL s_low : STD_LOGIC := '0';

SIGNAL s_dummy_sel : t_mat_reg_ix;
SIGNAL s_dummy_read : STD_LOGIC;

---------------------------------------------
--  Port Maps
---------------------------------------------
BEGIN

dut : e_mat_mul
PORT MAP(
    p_rst_i                 => s_rst,
    p_clk_i                 => s_clk,
        
    p_syn_rst_i             => s_rst_mul,
    p_finished_o            => s_mul_finished_t1,
    
    p_mat_a_size_i          => s_a_size_o,
    p_mat_a_ix_o            => s_mul_a_ix_r,
    p_mat_a_data_i          => s_a_data_o,
    
    p_mat_b_size_i          => s_b_size_o,
    p_mat_b_ix_o            => s_mul_b_ix_r,
    p_mat_b_data_i          => s_b_data_o,

    p_mat_c_ix_o            => s_mul_c_ix_w,
    p_mat_c_data_o          => s_mul_c_data_i,
    p_mat_c_row_by_row_i    => s_c_row_by_row_i,
    p_mat_c_size_o          => s_c_size_i
);

mat_a : e_mat_reg
PORT MAP(
    p_clk_i         => s_clk,
    p_rst_i         => s_rst,
        
    p_mat_size_i    => s_a_size_i,
    p_mat_size_o    => s_a_size_o,
    
    p_ix_read_i     => s_a_ix_r,
    p_ix_write_i    => s_a_ix_w,
    
    p_wren_i        => s_a_wren,
    
    p_row_by_row_i  => s_a_row_by_row_i,
    p_row_by_row_o  => s_a_row_by_row_o,
    
    p_word_i        => s_a_data_i,
    p_word_o        => s_a_data_o
);

mat_b : e_mat_reg
PORT MAP(
    p_clk_i         => s_clk,
    p_rst_i         => s_rst,
        
    p_mat_size_i    => s_b_size_i,
    p_mat_size_o    => s_b_size_o,
    
    p_ix_read_i     => s_b_ix_r,
    p_ix_write_i    => s_b_ix_w,
    
    p_wren_i        => s_b_wren,
    
    p_row_by_row_i  => '0',
    p_row_by_row_o  => s_b_row_by_row_o,
    
    p_word_i        => s_b_data_i,
    p_word_o        => s_b_data_o
);

mat_c : e_mat_reg
PORT MAP(
    p_clk_i         => s_clk,
    p_rst_i         => s_rst,
        
    p_mat_size_i    => s_c_size_i,
    p_mat_size_o    => s_c_size_o,
    
    p_ix_read_i     => s_c_ix_r,
    p_ix_write_i    => s_c_ix_w,
    
    p_wren_i        => s_c_wren,
    
    p_row_by_row_i  => s_c_row_by_row_i,
    p_row_by_row_o  => s_c_row_by_row_o,
    
    p_word_i        => s_c_data_i,
    p_word_o        => s_c_data_o
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

proc_select_signal_src : PROCESS(s_enable_mul, s_mul_a_ix_r, s_mul_b_ix_r, s_mul_c_ix_w, s_mul_c_data_i, s_mul_c_wren, s_nomul_a_ix_r, s_nomul_b_ix_r, s_nomul_c_ix_w, s_nomul_c_data_i, s_nomul_c_wren)
BEGIN
    IF s_enable_mul = '1' THEN
        s_a_ix_r <= s_mul_a_ix_r;
        s_b_ix_r <= s_mul_b_ix_r;
        s_c_ix_w <= s_mul_c_ix_w;
        s_c_data_i <= s_mul_c_data_i;
        s_c_wren <= s_mul_c_wren;
    ELSE
        s_a_ix_r <= s_nomul_a_ix_r;
        s_b_ix_r <= s_nomul_b_ix_r;
        s_c_ix_w <= s_nomul_c_ix_w;
        s_c_data_i <= s_nomul_c_data_i;
        s_c_wren <= s_nomul_c_wren;
    END IF;
END PROCESS proc_select_signal_src;
    
f_reg(s_rst, s_clk, s_low, s_mul_finished_t1, s_mul_finished_t2);
f_reg(s_rst, s_clk, s_low, s_mul_finished_t2, s_mul_finished_t3);
s_mul_c_wren        <= NOT s_mul_finished_t3 AND NOT s_rst_mul;

proc_test_mat_mul : PROCESS


--VARIABLE
--    v_slv : STD_ULOGIC_VECTOR(7 DOWNTO 0);
--VARIABLE
--    v_tst : t_mat_elem;
--VARIABLE
--    v_slv_2 : STD_LOGIC_VECTOR(7 DOWNTO 0);
BEGIN
    REPORT infomsg("Test Start");
    
--    FOR i IN 0 TO 255 LOOP
--        v_slv := STD_ULOGIC_VECTOR(to_unsigned(i, v_slv'length));
--        v_tst := to_sfixed(v_slv, 3, -4);
--        v_slv_2 := to_slv(v_tst);
--        
--        REPORT "HEx:" &  to_hstring(to_signed(i, 32)) & "; Int: " & INTEGER'IMAGE(i) & "; " &
--         "SLV: " & STD_ULOGIC'IMAGE(v_slv(7)) & STD_ULOGIC'IMAGE(v_slv(6)) & STD_ULOGIC'IMAGE(v_slv(5)) & STD_ULOGIC'IMAGE(v_slv(4)) & STD_ULOGIC'IMAGE(v_slv(3)) & STD_ULOGIC'IMAGE(v_slv(2)) & STD_ULOGIC'IMAGE(v_slv(1)) & STD_ULOGIC'IMAGE(v_slv(0)) &
--         "Val: " & REAL'IMAGE(to_real(v_tst)) & " (" & mat_elem_to_str(v_tst) & ")" 
--         & "SLV: " & STD_LOGIC'IMAGE(v_slv_2(7)) & STD_LOGIC'IMAGE(v_slv_2(6)) & STD_LOGIC'IMAGE(v_slv_2(5)) & STD_LOGIC'IMAGE(v_slv_2(4)) & STD_LOGIC'IMAGE(v_slv_2(3)) & STD_LOGIC'IMAGE(v_slv_2(2)) & STD_LOGIC'IMAGE(v_slv_2(1)) & STD_LOGIC'IMAGE(v_slv_2(0));    
--    END LOOP;

----------------------------------------------------------------------------------------------------
--  Init
----------------------------------------------------------------------------------------------------
    REPORT infomsg("Initialisiere Signale");
    s_rst <= '1';
    s_a_data_i <= (others => to_mat_elem(0.0));
    s_nomul_a_ix_r <= to_mat_ix(63, 63);
    s_nomul_b_ix_r <= to_mat_ix(63, 63);
    s_a_ix_w <= c_mat_ix_zero;
    s_a_size_i <= to_mat_size(64, 64);
    s_a_wren <= '1';
    s_a_row_by_row_i <= '1'; -- muss auf 1 sein, sonst funktioniert mat_mul nicht
    
    s_b_data_i <= (others => to_mat_elem(0.0));
    s_b_ix_w <= c_mat_ix_zero;
    s_b_size_i <= to_mat_size(1, 1);
    s_b_wren <= '1';
    
    s_nomul_c_data_i <= (others => to_mat_elem(0.0));
    s_c_ix_r <= to_mat_ix(63, 63);
    s_nomul_c_ix_w <= to_mat_ix(63, 63);
    s_nomul_c_wren <= '1';
    s_c_row_by_row_i <= '1';
    
    s_rst_mul <= '1';
    s_enable_mul <= '0';

    s_dummy_sel <= to_mat_reg_ix(0);
    s_dummy_read <= '0';
    
    WAIT FOR c_clk_per;
    
    s_rst <= '0';  
    WAIT FOR c_clk_per;
    
    FOR y IN 0 TO c_max_mat_dim - 1 LOOP
        FOR x IN 0 TO c_max_mat_dim - 1 LOOP
            s_a_ix_w <= to_mat_ix(y, x);
            s_b_ix_w <= to_mat_ix(y, x);
            s_nomul_c_ix_w <= to_mat_ix(y, x);
            WAIT FOR c_clk_per;
        END LOOP;
    END LOOP;
    
    s_a_wren <= '0';
    s_b_wren <= '0';
    s_nomul_c_wren <= '0';
   
    REPORT infomsg("Initialisierung abgeschlossen");
----------------------------------------------------------------------------------------------------
--  Test 1
----------------------------------------------------------------------------------------------------
    REPORT infomsg(" ----- Test 1: A(2x3) * B(3x3)");

    REPORT infomsg("Initialisiere Matrix A");
    -- {{0.125, 0.25, 0.625}, {-0.25, -0.3125, -0.875}}
    --
    -- 0.125    0.25        0.625       | 0000.0010     0000.0100       0000.1010
    -- -0.25   -0.3125     -0.875       | 1111.1100     1111.1011       1111.0010
    s_a_wren <= '1';
    s_a_size_i <= to_mat_size(2, 3);
    
    s_a_ix_w <= to_mat_ix(0, 0); -- Es koennen die Spalten 0-31 gleichzeitig geschrieben werden
    s_a_data_i <= to_mat_word((0.125, 0.25, 0.625, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                               0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    
    s_a_ix_w <= to_mat_ix(1, 0);
    s_a_data_i <= to_mat_word((-0.25, -0.3125, -0.875, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                               0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;   
    s_a_wren <= '0'; 
    WAIT FOR c_clk_per;
    print_mat_reg(0, s_dummy_sel, s_dummy_read, s_a_data_o, s_nomul_a_ix_r, s_a_size_o, s_a_row_by_row_o);
    
    REPORT infomsg("Initialisiere Matrix B (Spaltenweise)");
    -- {{1, 1, 2.5}, {2, 3, -4}, {1, -2, -3}}
    --
    -- 1   1  2.5       | 0001.0000     0001.0000       0010.1000
    -- 2   3   -4       | 0010.0000     0011.0000       1100.0000
    -- 1  -2   -3       | 0001.0000     1110.0000       1101.0000
    s_b_wren <= '1';
    s_b_size_i <= to_mat_size(3, 3);
    
    s_b_ix_w <= to_mat_ix(0, 0);
    s_b_data_i <= to_mat_word((1.0, 2.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                               0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    
    s_b_ix_w <= to_mat_ix(0, 1);
    s_b_data_i <= to_mat_word((1.0, 3.0, -2.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                               0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    
    s_b_ix_w <= to_mat_ix(0, 2);
    s_b_data_i <= to_mat_word((2.5, -4.0, -3.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                               0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;   
    s_b_wren <= '0';        
    WAIT FOR c_clk_per; 
    print_mat_reg(1, s_dummy_sel, s_dummy_read, s_b_data_o, s_nomul_b_ix_r, s_b_size_o, s_b_row_by_row_o);
    
    REPORT infomsg("Starte Matrix-Multiplikation");  
    s_rst_mul <= '0';
    s_enable_mul <= '1';
    WAIT FOR c_clk_per; 
    
    WAIT UNTIL s_mul_finished_t3 = '1';
    WAIT FOR c_clk_per / 2;
    
    s_rst_mul <= '1';
    s_enable_mul <= '0';
    REPORT infomsg("Matrix-Multiplikation fertig");
   
    REPORT infomsg("Loesche Matrix A");
    delete_mat(s_a_wren, s_a_data_i, s_a_ix_w);
    REPORT infomsg("Initialisiere Matrix A mit Vergleichswerten");
    -- 1.25     -0.375      -2.5625 | 0001.0100     1111.1010    1101.0111
    -- -1.75    0.5625      3.25    | 1110.0100     0000.1001    0011.0100
    s_a_wren <= '1';
    s_a_size_i <= to_mat_size(2, 3);
    
    s_a_ix_w <= to_mat_ix(0, 0);
    s_a_data_i <= to_mat_word((1.25, -0.375, -2.5625, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                               0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    
    s_a_ix_w <= to_mat_ix(1, 0);
    s_a_data_i <= to_mat_word((-1.75, 0.5625, 3.25, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                               0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    
    s_a_wren <= '0';
    
    assert_mat_eq(s_a_data_o, s_nomul_a_ix_r, s_a_size_o, s_a_row_by_row_o, s_c_data_o, s_c_ix_r, s_c_size_o, s_c_row_by_row_o);
    
----------------------------------------------------------------------------------------------------
--  Test 2
----------------------------------------------------------------------------------------------------
    REPORT infomsg(" ----- Test 2: A(2x36) * B(36x3)");
    
    REPORT infomsg("Loesche Matrix A");
    delete_mat(s_a_wren, s_a_data_i, s_a_ix_w);
    REPORT infomsg("Initialisiere Matrix A");
    -- [0.25, 0.25, 1.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 2.0, 0.5, 2.0]
    -- [-0.25, -0.35, -0.875, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.5, 0.5, 0.25]
    s_a_wren <= '1';
    s_a_size_i <= to_mat_size(2, 36);
    
    s_a_ix_w <= to_mat_ix(0, 0); -- Es koennen die Spalten 0-31 gleichzeitig geschrieben werden
    s_a_data_i <= to_mat_word((0.25, 0.25, 1.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                               0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    
    s_a_ix_w<= to_mat_ix(0, 32);
    s_a_data_i <= to_mat_word((1.0, 2.0, 0.5, 2.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                               0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    
    s_a_ix_w <= to_mat_ix(1, 0);
    s_a_data_i <= to_mat_word((-0.25, -0.35, -0.875, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                               0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    
    s_a_ix_w <= to_mat_ix(1, 32);
    s_a_data_i <= to_mat_word((1.0, 1.5, 0.5, 0.25, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                               0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    
    s_a_wren <= '0';
    
    REPORT infomsg("Loesche Matrix B");
    delete_mat(s_b_wren, s_b_data_i, s_b_ix_w);
    REPORT infomsg("Initialisiere Matrix B (Spaltenweise)");
    -- [1, 1, 2.0],[2, 3, -4],[1, -2, -3],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.0, 0.0, 0.0],[0.5, 0.5, 0.5],[0.5, 0.5, 2.0],[0.5, 1.0, 0.5],[0.5, 1.5, 1.0]
    s_b_wren <= '1';
    s_b_size_i <= to_mat_size(36, 3);
    
    s_b_ix_w <= to_mat_ix(0, 0);
    s_b_data_i <= to_mat_word((1.0, 2.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                               0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_b_ix_w <= to_mat_ix(32, 0);
    s_b_data_i <= to_mat_word((0.5, 0.5, 0.5, 0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                               0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    
    s_b_ix_w <= to_mat_ix(0, 1);
    s_b_data_i <= to_mat_word((1.0, 3.0, -2.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                               0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_b_ix_w <= to_mat_ix(32, 1);
    s_b_data_i <= to_mat_word((0.5, 0.5, 1.0, 1.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                               0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    
    s_b_ix_w <= to_mat_ix(0, 2);
    s_b_data_i <= to_mat_word((2.0, -4.0, -3.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                               0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per; 
    s_b_ix_w <= to_mat_ix(32, 2);
    s_b_data_i <= to_mat_word((0.5, 2.0, 0.5, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                               0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per; 
    
    s_b_wren <= '0';
    
    WAIT FOR c_clk_per; 
    
    REPORT infomsg("Loesche Matrix C");
    delete_mat(s_nomul_c_wren, s_nomul_c_data_i, s_nomul_c_ix_w);
    REPORT infomsg("Starte Matrix-Multiplikation");  
        
    s_rst_mul <= '0';
    s_enable_mul <= '1';
    WAIT FOR c_clk_per; 
    
    WAIT UNTIL s_mul_finished_t3 = '1';
    WAIT FOR c_clk_per / 2;
    
    s_rst_mul <= '1';
    s_enable_mul <= '0';
    REPORT infomsg("Matrix-Multiplikation fertig");
        
    REPORT infomsg("Loesche Matrix A");
    delete_mat(s_a_wren, s_a_data_i, s_a_ix_w);
    REPORT infomsg("Initialisiere Matrix A mit Vergleichswerten");
    -- 5.0      3.0     1.75
    -- -0.2     2.575   7.525 -- erzeugt rundungsfehler!
    s_a_wren <= '1';
    s_a_size_i <= to_mat_size(2 ,3);
    
    s_a_ix_w <= to_mat_ix(0, 0);
    s_a_data_i <= to_mat_word((5.0, 3.0, 1.75, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                               0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    
    s_a_ix_w <= to_mat_ix(1, 0);
    s_a_data_i <= to_mat_word((-0.25, 2.5, 7.625, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                               0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    
    s_a_wren <= '0';
    assert_mat_eq(s_a_data_o, s_nomul_a_ix_r, s_a_size_o, s_a_row_by_row_o, s_c_data_o, s_c_ix_r, s_c_size_o, s_c_row_by_row_o);
    
----------------------------------------------------------------------------------------------------
--  Test 3
----------------------------------------------------------------------------------------------------
    REPORT infomsg(" ----- Test 3: A(36x1) * B(1x1) (C Spaltenweise)");

    REPORT infomsg("Loesche Matrix A");
    delete_mat(s_a_wren, s_a_data_i, s_a_ix_w); 
    REPORT infomsg("Initialisiere Matrix A");
    -- [0.25], [0.125], [0.0], [1.0], [0.125], [0.5], [1.0], [2.0], [0.0625], [0.5], [0.125], [1.0], [0.625], [0.875], [2.0], [0.5], [0.5625], [0.3125], [0.25], [0.125], [0.0], [1.0], [0.125], [0.5], [1.0], [2.0], [0.0625], [0.5], [0.125], [1.0], [0.625], [0.875], [2.0], [0.5], [0.5625], [0.3125]
    s_a_wren <= '1';
    s_a_size_i <= to_mat_size(36, 1);
    
    s_a_ix_w <= to_mat_ix(0, 0);
    
    s_a_data_i <= to_mat_word((0.25, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_a_ix_w <= to_mat_ix(1, 0);   
    s_a_data_i <= to_mat_word((0.125, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_a_ix_w <= to_mat_ix(2, 0);  
    s_a_data_i <= to_mat_word((0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_a_ix_w <= to_mat_ix(3, 0);  
    s_a_data_i <= to_mat_word((1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_a_ix_w <= to_mat_ix(4, 0); 
    s_a_data_i <= to_mat_word((0.125, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_a_ix_w <= to_mat_ix(5, 0);  
    s_a_data_i <= to_mat_word((0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_a_ix_w <= to_mat_ix(6, 0);  
    s_a_data_i <= to_mat_word((1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_a_ix_w <= to_mat_ix(7, 0); 
    s_a_data_i <= to_mat_word((2.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_a_ix_w <= to_mat_ix(8, 0);   
    s_a_data_i <= to_mat_word((0.0625, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_a_ix_w <= to_mat_ix(9, 0);   
    s_a_data_i <= to_mat_word((0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_a_ix_w <= to_mat_ix(10, 0);   
    s_a_data_i <= to_mat_word((0.125, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_a_ix_w <= to_mat_ix(11, 0);   
    s_a_data_i <= to_mat_word((1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_a_ix_w <= to_mat_ix(12, 0);   
    s_a_data_i <= to_mat_word((0.625, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_a_ix_w <= to_mat_ix(13, 0);   
    s_a_data_i <= to_mat_word((0.875, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_a_ix_w <= to_mat_ix(14, 0);   
    s_a_data_i <= to_mat_word((2.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_a_ix_w <= to_mat_ix(15, 0);   
    s_a_data_i <= to_mat_word((0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_a_ix_w <= to_mat_ix(16, 0);   
    s_a_data_i <= to_mat_word((0.5625, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_a_ix_w <= to_mat_ix(17, 0);   
    s_a_data_i <= to_mat_word((0.3125, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_a_ix_w <= to_mat_ix(18, 0);   
    s_a_data_i <= to_mat_word((0.25, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_a_ix_w <= to_mat_ix(19, 0);   
    s_a_data_i <= to_mat_word((0.125, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_a_ix_w <= to_mat_ix(20, 0);   
    s_a_data_i <= to_mat_word((0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_a_ix_w <= to_mat_ix(21, 0);   
    s_a_data_i <= to_mat_word((1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_a_ix_w <= to_mat_ix(22, 0);   
    s_a_data_i <= to_mat_word((0.125, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_a_ix_w <= to_mat_ix(23, 0);   
    s_a_data_i <= to_mat_word((0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_a_ix_w <= to_mat_ix(24, 0);   
    s_a_data_i <= to_mat_word((1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_a_ix_w <= to_mat_ix(25, 0);   
    s_a_data_i <= to_mat_word((2.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_a_ix_w <= to_mat_ix(26, 0);   
    s_a_data_i <= to_mat_word((0.0625, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_a_ix_w <= to_mat_ix(27, 0);   
    s_a_data_i <= to_mat_word((0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_a_ix_w <= to_mat_ix(28, 0);   
    s_a_data_i <= to_mat_word((0.125, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_a_ix_w <= to_mat_ix(29, 0);   
    s_a_data_i <= to_mat_word((1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_a_ix_w <= to_mat_ix(30, 0);   
    s_a_data_i <= to_mat_word((0.625, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_a_ix_w <= to_mat_ix(31, 0);   
    s_a_data_i <= to_mat_word((0.875, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_a_ix_w <= to_mat_ix(32, 0);   
    s_a_data_i <= to_mat_word((2.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_a_ix_w <= to_mat_ix(33, 0);   
    s_a_data_i <= to_mat_word((0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_a_ix_w <= to_mat_ix(34, 0);   
    s_a_data_i <= to_mat_word((0.5625, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    s_a_ix_w <= to_mat_ix(35, 0);   
    s_a_data_i <= to_mat_word((0.3125, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;

    s_a_wren <= '0';
    
    REPORT infomsg("Loesche Matrix B");
    delete_mat(s_b_wren, s_b_data_i, s_b_ix_w);
    REPORT infomsg("Initialisiere Matrix B (Spaltenweise)");
    -- [2]
    
    s_b_wren <= '1';
    s_b_size_i <= to_mat_size(1, 1);
    
    s_b_ix_w <= to_mat_ix(0, 0); -- Es koennen die Spalten 0-31 gleichzeitig geschrieben werden 
    s_b_data_i <= to_mat_word((2.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                               0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per; 
    
    s_b_wren <= '0';

    WAIT FOR c_clk_per; 
      
    REPORT infomsg("Loesche Matrix C");
    delete_mat(s_nomul_c_wren, s_nomul_c_data_i, s_nomul_c_ix_w);
    REPORT infomsg("Starte Matrix-Multiplikation");  
    s_rst_mul <= '0';
    s_enable_mul <= '1';
    s_c_row_by_row_i <= '0';
    WAIT FOR c_clk_per; 
    
    WAIT UNTIL s_mul_finished_t3 = '1';
    WAIT FOR c_clk_per / 2;
    
    s_rst_mul <= '1';
    s_enable_mul <= '0';
    REPORT infomsg("Matrix-Multiplikation fertig");
    
    REPORT infomsg("Loesche Matrix A");
    delete_mat(s_a_wren, s_a_data_i, s_a_ix_w);    
    REPORT infomsg("Initialisiere Matrix A mit Vergleichswerten");
    -- [0.5], [0.25], [0.0], [2.0], [0.25], [1.0], [2.0], [4.0], [0.125], [1.0], [0.25], [2.0], [1.25], [1.75], [4.0], [1.0], [1.125], [0.625], [0.5], [0.25], [0.0], [2.0], [0.25], [1.0], [2.0], [4.0], [0.125], [1.0], [0.25], [2.0], [1.25], [1.75], [4.0], [1.0], [1.125], [0.625]
    s_a_wren <= '1';
    s_a_size_i <= to_mat_size(36, 1);
    s_a_row_by_row_i <= '0';
    WAIT FOR c_clk_per;
    
    s_a_ix_w <= to_mat_ix(0, 0);
    s_a_data_i <= to_mat_word(( 0.5, 0.25, 0.0, 2.0, 0.25, 1.0, 2.0, 4.0, 0.125, 1.0, 0.25, 2.0, 1.25, 1.75, 4.0, 1.0, 
                                1.125, 0.625, 0.5, 0.25, 0.0, 2.0, 0.25, 1.0, 2.0, 4.0, 0.125, 1.0, 0.25, 2.0, 1.25, 1.75));
    WAIT FOR c_clk_per;
    
    s_a_ix_w <= to_mat_ix(32, 0);
    s_a_data_i <= to_mat_word((4.0, 1.0, 1.125, 0.625, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                               0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    WAIT FOR c_clk_per;
    
    s_a_wren <= '0';
    assert_mat_eq(s_a_data_o, s_nomul_a_ix_r, s_a_size_o, s_a_row_by_row_o, s_c_data_o, s_c_ix_r, s_c_size_o, s_c_row_by_row_o);
    
    REPORT infomsg("Testende");
    WAIT;
END PROCESS proc_test_mat_mul;

END ARCHITECTURE a_tb_mat_mul;