----------------------------------------------------------------------------------------------------
--  Testbench fuer e_nn_algo
--  Simulationszeit: 11 ms
--
--  Autor: Niklas Kuehl
----------------------------------------------------------------------------------------------------
LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.all;
USE work.pkg_tools.ALL;
USE work.pkg_test.ALL;
USE work.fixed_pkg.ALL;
USE work.pkg_test_matrices.ALL;

ENTITY tb_nn_algo IS
END ENTITY tb_nn_algo;

ARCHITECTURE a_tb_nn_algo OF tb_nn_algo IS

COMPONENT e_nn_algo
    PORT (    
        p_rst_i                 : IN STD_LOGIC;
        p_clk_i                 : IN STD_LOGIC;
        p_syn_rst_i             : IN STD_LOGIC;
        
        p_exec_algo_i          : IN STD_LOGIC;
        p_do_train_i            : IN STD_LOGIC;
        p_finished_o            : OUT STD_LOGIC;
        
        p_ytrain_data_i         : IN t_byte;
        p_ytrain_ix_o           : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
        
        p_sel_a_0_i             : IN t_mat_reg_ix;
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

COMPONENT e_ram_64_8
	PORT (
		clock : IN STD_LOGIC  := '1';
		data : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		rdaddress : IN STD_LOGIC_VECTOR (5 DOWNTO 0);
		wraddress : IN STD_LOGIC_VECTOR (5 DOWNTO 0);
		wren : IN STD_LOGIC  := '0';
		q : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
END COMPONENT;

---------------------------------------------
--  Signale
---------------------------------------------
SIGNAL s_clk, s_rst, s_syn_rst : STD_LOGIC;
SIGNAL s_finished, s_do_train : STD_LOGIC;

SIGNAL s_sel_a0 : t_mat_reg_ix;
SIGNAL s_write_a0, s_read_a0 : STD_LOGIC;
SIGNAL s_data_a0_i, s_data_a0_o : t_mat_word;
SIGNAL s_ix_a0 : t_mat_ix;
SIGNAL s_size_a0_i, s_size_a0_o : t_mat_size;
SIGNAL s_row_by_row_a0_i, s_row_by_row_a0_o : STD_LOGIC;

SIGNAL s_ytrain_data_i, s_ytrain_data_o : t_byte;
SIGNAL s_ytrain_read, s_ytrain_write : STD_LOGIC_VECTOR(5 DOWNTO 0);
SIGNAL s_ytrain_wren : STD_LOGIC;

SIGNAL s_exec_algo : STD_LOGIC;

---------------------------------------------
--  Port Maps
---------------------------------------------
BEGIN

dut : e_nn_algo
PORT MAP(
    p_rst_i                 => s_rst,
    p_clk_i                 => s_clk,    
    p_syn_rst_i             => s_syn_rst,
    
    p_exec_algo_i           => s_exec_algo,
    p_do_train_i            => s_do_train,
    p_finished_o            => s_finished,
  
    p_ytrain_data_i         => s_ytrain_data_o,
    p_ytrain_ix_o           => s_ytrain_read,

    p_sel_a_0_i             => s_sel_a0,
    p_write_a0_i            => s_write_a0,
    p_read_a0_i             => s_read_a0,
    p_data_a0_i             => s_data_a0_i,
    p_data_a0_o             => s_data_a0_o,
    p_ix_a0_i               => s_ix_a0,
    p_size_a0_i             => s_size_a0_i,
    p_row_by_row_a0_i       => s_row_by_row_a0_i,
    p_size_a0_o             => s_size_a0_o,
    p_row_by_row_a0_o       => s_row_by_row_a0_o
);

y_train : e_ram_64_8
PORT MAP(
    clock => s_clk,
    data => s_ytrain_data_i,
    rdaddress => s_ytrain_read,
    wraddress => s_ytrain_write,
    wren => s_ytrain_wren,
    q => s_ytrain_data_o
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
BEGIN
    REPORT infomsg("Test Start");
    REPORT infomsg("Initialisiere Signale");
    s_rst <= '1'; 
    s_syn_rst <= '0';
    s_do_train <= '1';
    s_exec_algo <= '0';
    
    s_sel_a0 <= to_mat_reg_ix(0);
    s_write_a0 <= '0';
    s_read_a0 <= '0';
    s_data_a0_i <= c_mat_word_zero;
    s_ix_a0 <= to_mat_ix(0, 0);
    s_size_a0_i <= to_mat_size(7, 7);
    s_row_by_row_a0_i <= '1';
   
    s_ytrain_data_i <= (OTHERS => '0');
    s_ytrain_write <= (OTHERS => '0');
    s_ytrain_wren <= '0';

    WAIT FOR c_clk_per;
    s_rst <= '0';
    REPORT infomsg("Initialisierung abgeschlossen");   
    init_mat_x_train_rbr(4, s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a0);
    
    init_mat_b1_rbr(1, s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a0);
    init_mat_b2_rbr(3, s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a0);
    init_mat_w1_cbc(0, s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a0);
    init_mat_w2_cbc(2, s_write_a0, s_size_a0_i, s_row_by_row_a0_i, s_ix_a0, s_data_a0_i, s_sel_a0);
    init_y_train(s_ytrain_data_i, s_ytrain_write, s_ytrain_wren);
   
    save_mat_reg_to_file("IN w1.txt", 0, s_sel_a0, s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o);
    save_mat_reg_to_file("IN b1.txt", 1, s_sel_a0, s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o);
    save_mat_reg_to_file("IN w2.txt", 2, s_sel_a0, s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o);
    save_mat_reg_to_file("IN b2.txt", 3, s_sel_a0, s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o);

    s_syn_rst <= '1';
    WAIT FOR c_clk_per;
    s_syn_rst <= '0';
    s_exec_algo <= '1';
    WAIT FOR c_clk_per;
    REPORT infomsg("Fuehre Algorithmus aus...");  
    WAIT UNTIL s_finished = '1';
    WAIT FOR c_clk_per / 2;
    REPORT infomsg("Algorithmus beendet");
    s_exec_algo <= '0';
    
    save_mat_reg_to_file("09 tmp0.txt", 9, s_sel_a0, s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o);
    save_mat_reg_to_file("12 dw1.txt", 4, s_sel_a0, s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o);  
    save_mat_reg_to_file("13 w1.txt", 0, s_sel_a0, s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o);
    save_mat_reg_to_file("13 tmp2.txt", 8, s_sel_a0, s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o); 
    save_mat_reg_to_file("15 dw2.txt", 6, s_sel_a0, s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o);  
    save_mat_reg_to_file("16 w2.txt", 2, s_sel_a0, s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o);
    save_mat_reg_to_file("16 db2.txt", 7, s_sel_a0, s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o); 
    save_mat_reg_to_file("17 b2.txt", 3, s_sel_a0, s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o);
    save_mat_reg_to_file("17 db1.txt", 5, s_sel_a0, s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o);
    save_mat_reg_to_file("18 b1.txt", 1, s_sel_a0, s_read_a0, s_data_a0_o, s_ix_a0, s_size_a0_o, s_row_by_row_a0_o);
    
    REPORT infomsg("Testende");
    WAIT;
END PROCESS proc_test;

END ARCHITECTURE a_tb_nn_algo;