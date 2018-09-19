----------------------------------------------------------------------------------------------------
--  Testbench fuer tb_access_mat
--  Simulationszeit: 100 us
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

ENTITY tb_access_mat IS
END ENTITY tb_access_mat;

ARCHITECTURE a_tb_access_mat OF tb_access_mat IS

COMPONENT e_nn_algo
    PORT (    
        p_rst_i                 : IN STD_LOGIC;
        p_clk_i                 : IN STD_LOGIC;
        p_syn_rst_i             : IN STD_LOGIC;
        
        p_exec_algo_i          : IN STD_LOGIC;   
        p_do_train_i            : IN STD_LOGIC;
        p_finished_o            : OUT STD_LOGIC;
        
        p_ytrain_data_i         : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
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

COMPONENT e_access_mat       
    PORT (    
        p_rst_i                 : IN STD_LOGIC;
        p_clk_i                 : IN STD_LOGIC;
        p_syn_rst_i             : IN STD_LOGIC;
        
        p_write_mat_i           : IN STD_LOGIC;
        p_write_ytrain_i        : IN STD_LOGIC;
        p_read_mat_i            : IN STD_LOGIC;
        p_finished_o            : OUT STD_LOGIC;
        
        p_new_data_i            : IN STD_LOGIC;
        p_data_read_o           : OUT STD_LOGIC;
        p_send_o                : OUT STD_LOGIC;
        p_busy_send_i           : IN STD_LOGIC;
        p_data_i                : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
        p_data_o                : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
       
        p_ix_o                  : OUT t_mat_ix;
        p_word_o                : OUT t_mat_word;
        p_word_i                : IN t_mat_word;
        p_size_i                : IN t_mat_size;
        p_row_by_row_i          : IN STD_LOGIC;
        p_write_a0_o            : OUT STD_LOGIC;
        p_read_a0_o             : OUT STD_LOGIC;

        p_ytrain_wren_o         : OUT STD_LOGIC;
        p_ytrain_wraddress_o    : OUT STD_LOGIC_VECTOR (5 DOWNTO 0);
        p_ytrain_data_o         : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
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
SIGNAL s_algo_finished, s_access_mat_finished, s_do_train, s_exec_algo : STD_LOGIC;

SIGNAL s_sel_a0 : t_mat_reg_ix;
SIGNAL s_write_a0, s_read_a0 : STD_LOGIC;
SIGNAL s_data_a0_i, s_data_a0_o : t_mat_word;
SIGNAL s_ix_a0 : t_mat_ix;
SIGNAL s_size_a0_i, s_size_a0_o : t_mat_size;
SIGNAL s_row_by_row_a0_i, s_row_by_row_a0_o : STD_LOGIC;

SIGNAL s_ytrain_data_i, s_ytrain_data_o : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL s_ytrain_read, s_ytrain_write : STD_LOGIC_VECTOR(5 DOWNTO 0);
SIGNAL s_ytrain_wren : STD_LOGIC;

SIGNAL s_write_mat, s_write_ytrain, s_read_mat : STD_LOGIC;
SIGNAL s_new_data, s_data_read, s_send, s_busy_send : STD_LOGIC;
SIGNAL byte_i, byte_o : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL s_access_ix, s_read_ix : t_mat_ix;
SIGNAL s_read_mat_proc : STD_LOGIC;

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
    p_finished_o            => s_algo_finished,
  
    p_ytrain_data_i         => s_ytrain_data_o,
    p_ytrain_ix_o           => OPEN,

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

access_mat : e_access_mat
PORT MAP(
    p_rst_i                 => s_rst,
    p_clk_i                 => s_clk, 
    p_syn_rst_i             => s_syn_rst,
    
    p_write_mat_i           => s_write_mat,
    p_write_ytrain_i        => s_write_ytrain,
    p_read_mat_i            => s_read_mat,
    p_finished_o            => s_access_mat_finished,
    
    p_new_data_i            => s_new_data,
    p_data_read_o           => s_data_read,
    p_send_o                => s_send,
    p_busy_send_i           => s_busy_send,
    p_data_i                => byte_i,
    p_data_o                => byte_o,
   
    p_ix_o                  => s_access_ix,
    p_word_o                => s_data_a0_i,
    p_word_i                => s_data_a0_o,
    p_size_i                => s_size_a0_i,
    p_row_by_row_i          => s_row_by_row_a0_i,
    p_write_a0_o            => s_write_a0,
    p_read_a0_o             => s_read_a0,

    p_ytrain_wren_o         => s_ytrain_wren,
    p_ytrain_wraddress_o    => s_ytrain_write,
    p_ytrain_data_o         => s_ytrain_data_i
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
s_ix_a0 <= s_access_ix WHEN s_read_mat_proc = '0' ELSE s_read_ix;

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
    s_rst <= '1'; 
    s_syn_rst <= '1';
    s_do_train <= '1';
    s_exec_algo <= '0';
    
    s_write_mat <= '0';
    s_read_mat <= '0';
    s_write_ytrain <= '0';
    s_ytrain_read <= (OTHERS => '0');
    
    s_sel_a0 <= to_mat_reg_ix(0);
    s_read_ix <= to_mat_ix(0, 0);
    s_size_a0_i <= to_mat_size(7, 7);
    s_row_by_row_a0_i <= '1';
   
    s_new_data <= '0';
    s_busy_send <= '0';
    
    byte_i <= (OTHERS => '0');
    s_read_mat_proc <= '0';

    WAIT FOR c_clk_per;
    s_rst <= '0';
    REPORT infomsg("Initialisierung abgeschlossen");   
    
    REPORT infomsg("Testfall: Matrix schreiben");  
    s_sel_a0 <= to_mat_reg_ix(0);
    s_size_a0_i <= to_mat_size(4, 4);
    s_write_mat <= '1';
    s_syn_rst <= '0';
    FOR i IN 1 TO 4*4 LOOP       
        WAIT FOR 5*c_clk_per;
        REPORT infomsg("Sende Byte " & INTEGER'IMAGE(i));
        byte_i <= STD_LOGIC_VECTOR(TO_UNSIGNED(i, 8));
        s_new_data <= '1';
        WAIT FOR c_clk_per;
        s_new_data <= '0';
        byte_i <= "00000000";
    END LOOP;
    IF s_access_mat_finished /= '1' THEN
        WAIT UNTIL s_access_mat_finished = '1';
        WAIT FOR c_clk_per / 2;
    END IF;
    s_syn_rst <= '1';
    s_write_mat <= '0';
    WAIT FOR 5*c_clk_per;
    
    REPORT infomsg("Testfall: Matrix lesen");  
    s_syn_rst <= '0';
    s_read_mat <= '1';
    
    FOR i IN 1 TO 4*4 LOOP
        REPORT infomsg("Warte auf s_send");       
        WAIT UNTIL s_send = '1';
        WAIT FOR c_clk_per/2;
        ASSERT byte_o = STD_LOGIC_VECTOR(TO_UNSIGNED(i, 8)) REPORT err("Byte " & INTEGER'IMAGE(i) & " ist = " & to_hex(byte_o) & ", sollte aber sein: " & to_hex(STD_LOGIC_VECTOR(TO_UNSIGNED(i, 8))));
        WAIT FOR c_clk_per;
        s_busy_send <= '1';
        WAIT FOR 10* c_clk_per;
        s_busy_send <= '0';
    END LOOP;
    s_read_mat <= '0';
    s_syn_rst <= '1';
    WAIT FOR 5*c_clk_per;
    WAIT FOR c_clk_per/2;
    
    REPORT infomsg("Testfall: y_train schreiben"); 
    s_syn_rst <= '0';
    s_size_a0_i <= to_mat_size(1, 64);
    s_row_by_row_a0_i <= '1';
    s_write_ytrain <= '1';
    s_syn_rst <= '0';
    FOR i IN 0 TO 63 LOOP
        WAIT FOR 5*c_clk_per;
        byte_i <= STD_LOGIC_VECTOR(TO_UNSIGNED(i * 2, 8));
        REPORT "Schreibe Byte " & INTEGER'IMAGE(i) & " in y_train";
        s_new_data <= '1';
        WAIT FOR c_clk_per;
        s_new_data <= '0';
        byte_i <= "00000000";
    END LOOP;
    IF s_access_mat_finished /= '1' THEN
        WAIT UNTIL s_access_mat_finished = '1';
        WAIT FOR c_clk_per / 2;
    END IF;
    s_write_ytrain <= '0';
    
    REPORT infomsg("Testfall: y_train lesen"); 
    FOR i IN 0 TO 63 LOOP
        s_ytrain_read <= STD_LOGIC_VECTOR(TO_UNSIGNED(i, 6));
        WAIT FOR 2*c_clk_per;
        ASSERT s_ytrain_data_o = STD_LOGIC_VECTOR(TO_UNSIGNED(i * 2, 8)) REPORT err("y_train an Position " & INTEGER'IMAGE(i) & " ist = " & to_hex(s_ytrain_data_o) & ", sollte aber sein: " & to_hex(STD_LOGIC_VECTOR(TO_UNSIGNED(i * 2, 8))));
    END LOOP;
    
    s_read_mat_proc <= '1';  
    save_mat_reg_to_file("access.txt", 0, s_sel_a0, s_read_mat, s_data_a0_o, s_read_ix, s_size_a0_o, s_row_by_row_a0_o);
    
    REPORT infomsg("Testende");
    WAIT;
END PROCESS proc_test;

END ARCHITECTURE a_tb_access_mat;