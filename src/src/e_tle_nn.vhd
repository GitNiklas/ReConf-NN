----------------------------------------------------------------------------------------------------
--  Entity zur Realisierung eines Neuronalen Netzes.
--  
--  Debug-Modus:    Erlaubt es, ein beliebiges Matrix-Register auszulesen. Dazu muss nach dem Versetzen
--                  in den Debug-Modus die Nummer des Registers ueber die serielle Schnittstelle gesendet werden            
--
--  Generics:
--      g_clk_period    : Periodendauer des verwendeten Takts 
--      g_baudrate      : Baudrate zur Kommunikation über die serielle Schnittstelle
--
--  Port:
--      p_rst_i         : Asynchroner Reset
--      p_clk_i         : Takt
--
--      p_set_debug_i   : Setzt das System in den Debug-Modus
--
--      p_rx_i          : Serielle Schnittstelle
--      p_tx_o          : Serielle Schnittstelle
--        
--      p_prot_err_o    : Zeigt einen Fehler beim Kommunikationsprotokoll an
--      p_ser_err_o     : Zeigt einen Fehler in der seriellen Kommunikation an
--
--      p_state_7ss0_o  : Zur Ausgabe des internen Zustandes auf 7-Segment-Anzeige
----------------------------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
USE work.fixed_pkg.ALL;
USE work.pkg_tools.ALL;

ENTITY e_tle_nn IS      
    GENERIC(
        g_clk_period        : TIME      := c_base_clk_per;
        g_baudrate          : POSITIVE  := c_baudrate 
    ); 
    PORT (    
        p_rst_i             : IN STD_LOGIC;
        p_clk_i             : IN STD_LOGIC;
        p_set_debug_i       : IN STD_LOGIC;
        
        p_rx_i              : IN STD_LOGIC;
        p_tx_o              : OUT STD_LOGIC;
        
        p_prot_err_o        : OUT STD_LOGIC;
        p_ser_err_o         : OUT STD_LOGIC;
        
        p_state_7ss0_o      : OUT STD_LOGIC_VECTOR(6 DOWNTO 0) := "1111111"
    );
END ENTITY e_tle_nn;

----------------------------------------------------------------------------------------------------
--  Architecture
----------------------------------------------------------------------------------------------------
ARCHITECTURE a_tle_nn OF e_tle_nn IS

----------------------------------------------------------------------------------------------------
--  Komponenten
----------------------------------------------------------------------------------------------------

COMPONENT e_nn_algo
    PORT (    
        p_rst_i                 : IN STD_LOGIC;
        p_clk_i                 : IN STD_LOGIC;
        p_syn_rst_i             : IN STD_LOGIC;
        
        p_exec_algo_i           : IN STD_LOGIC;
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

COMPONENT e_serial
    GENERIC(
        g_clk_period            : TIME      := 20 ns;
        g_baudrate              : POSITIVE  := 9600 
    );
    PORT(
        p_rst_i                 : IN STD_LOGIC;
        p_clk_i                 : IN STD_LOGIC;

        p_rx_i                  : IN STD_LOGIC;
        p_tx_o                  : OUT STD_LOGIC;

        p_new_data_o            : OUT STD_LOGIC;
        p_data_o                : OUT t_byte;
        p_data_read_i           : IN STD_LOGIC;
        p_rx_err_o              : OUT STD_LOGIC;
    
        p_data_i                : IN t_byte;
        p_send_i                : IN STD_LOGIC;
        p_busy_send_o           : OUT STD_LOGIC
    );
END COMPONENT;

COMPONENT e_access_mat IS       
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
        p_data_i                : IN t_byte;
        p_data_o                : OUT t_byte;
       
        p_ix_o                  : OUT t_mat_ix;
        p_word_o                : OUT t_mat_word;
        p_word_i                : IN t_mat_word;
        p_size_i                : IN t_mat_size;
        p_row_by_row_i          : IN STD_LOGIC;
        p_write_a0_o            : OUT STD_LOGIC;
        p_read_a0_o             : OUT STD_LOGIC;

        p_ytrain_wren_o         : OUT STD_LOGIC;
        p_ytrain_wraddress_o    : OUT STD_LOGIC_VECTOR (5 DOWNTO 0);
        p_ytrain_data_o         : OUT t_byte
    );
END COMPONENT;

COMPONENT e_sync
    GENERIC(
        g_default_val     : STD_LOGIC  := '1' 
    );
    PORT (
        p_rst_i                     : IN STD_LOGIC;
        p_clk_i                     : IN STD_LOGIC;
            
        p_async_i                   : IN STD_LOGIC;
        p_sync_o                    : OUT STD_LOGIC
    );
END COMPONENT;

COMPONENT clock_pll IS
	PORT
	(
		areset		: IN STD_LOGIC  := '0';
		inclk0		: IN STD_LOGIC  := '0';
		c0		: OUT STD_LOGIC ;
		locked		: OUT STD_LOGIC 
	);
END COMPONENT;

----------------------------------------------------------------------------------------------------
--  Signale
----------------------------------------------------------------------------------------------------
CONSTANT w1 : t_mat_reg_ix := to_mat_reg_ix(0);
CONSTANT b1 : t_mat_reg_ix := to_mat_reg_ix(1);
CONSTANT w2 : t_mat_reg_ix := to_mat_reg_ix(2);
CONSTANT b2 : t_mat_reg_ix := to_mat_reg_ix(3);
CONSTANT x_train : t_mat_reg_ix := to_mat_reg_ix(4);
CONSTANT scores : t_mat_reg_ix := to_mat_reg_ix(8);
SIGNAL s_mat_reg, s_dbg_mat_reg : t_mat_reg_ix;
SIGNAL s_set_dbg_mat_reg : STD_LOGIC;

SIGNAL s_clk_1, s_pll_locked : STD_LOGIC;

SIGNAL s_rx_synced : STD_LOGIC;
SIGNAL s_set_debug_synced : STD_LOGIC := '0';

SIGNAL s_rst_algo, s_do_train, s_algo_finished : STD_LOGIC;

SIGNAL s_mat_size : t_mat_size;
SIGNAL s_row_by_row, s_read_a0, s_write_a0 : STD_LOGIC;
SIGNAL s_mat_word_i, s_mat_word_o : t_mat_word;
SIGNAL s_mat_ix: t_mat_ix;

SIGNAL s_rst_access, s_access_finished : STD_LOGIC;
SIGNAL s_write_mat, s_read_mat, s_write_ytrain : STD_LOGIC;
SIGNAL s_send_mat, s_new_mat_data : STD_LOGIC;
SIGNAL s_mat_data_i, s_mat_data_o : t_byte;

SIGNAL s_serial_data_o, s_serial_data_i : t_byte;
SIGNAL s_new_serial_data, s_serial_busy_send, s_send_serial : STD_LOGIC;

SIGNAL s_ytrain_wren : STD_LOGIC;
SIGNAL s_ytrain_data_i, s_ytrain_data_o : t_byte;
SIGNAL s_ytrain_read_addr, s_ytrain_write_addr : STD_LOGIC_VECTOR(5 DOWNTO 0);

-- Zustaende
TYPE t_state IS (st_init, st_init_b1, st_rst_access, st_init_b2, st_send_init_done, st_wait_w1, st_write_w1, st_wait_w2, st_write_w2,
st_sel_mode, st_write_x_train, st_wait_y_train, st_write_y_train, st_do_train, st_send_calc_done,
st_write_x_test, st_do_test, st_read_scores,
st_debug, st_debug_read_mat,
st_err); 

SIGNAL s_exec_algo : STD_LOGIC;

SIGNAL s_cur_state, s_next_state : t_state;
SIGNAL s_gnd : STD_LOGIC := '0';

CONSTANT c_fpga_init_done   : STD_LOGIC_VECTOR := x"F0";
CONSTANT c_fpga_calc_done   : STD_LOGIC_VECTOR := x"F1";
CONSTANT c_write_w1         : STD_LOGIC_VECTOR := x"E0";
CONSTANT c_write_w2         : STD_LOGIC_VECTOR := x"E1";
CONSTANT c_do_train         : STD_LOGIC_VECTOR := x"E2";
CONSTANT c_write_y_train    : STD_LOGIC_VECTOR := x"E3";
CONSTANT c_do_test          : STD_LOGIC_VECTOR := x"A1";

----------------------------------------------------------------------------------------------------
--  Port Maps
----------------------------------------------------------------------------------------------------
BEGIN

nn_algo : e_nn_algo
PORT MAP(
    p_rst_i                 => p_rst_i,
    p_clk_i                 => s_clk_1,    
    p_syn_rst_i             => s_rst_algo,
    
    p_exec_algo_i           => s_exec_algo,
    p_do_train_i            => s_do_train,
    p_finished_o            => s_algo_finished,
  
    p_ytrain_data_i         => s_ytrain_data_o,
    p_ytrain_ix_o           => s_ytrain_read_addr,

    p_sel_a_0_i             => s_mat_reg,
    p_write_a0_i            => s_write_a0,
    p_read_a0_i             => s_read_a0,
    p_data_a0_i             => s_mat_word_i,
    p_data_a0_o             => s_mat_word_o,
    p_ix_a0_i               => s_mat_ix,
    p_size_a0_i             => s_mat_size,
    p_row_by_row_a0_i       => s_row_by_row,
    p_size_a0_o             => OPEN, 
    p_row_by_row_a0_o       => OPEN
); 

y_train_ram : e_ram_64_8
PORT MAP(
    clock                   => s_clk_1,
    data                    => s_ytrain_data_i,
    rdaddress               => s_ytrain_read_addr,
    wraddress               => s_ytrain_write_addr,
    wren                    => s_ytrain_wren,
    q                       => s_ytrain_data_o
);

serial : e_serial
GENERIC MAP(
    g_clk_period            => c_clk_per,
    g_baudrate              => g_baudrate
)
PORT MAP(
    p_rst_i                 => p_rst_i,
    p_clk_i                 => s_clk_1,

    p_rx_i                  => s_rx_synced,
    p_tx_o                  => p_tx_o,

    p_new_data_o            => s_new_serial_data,
    p_data_o                => s_serial_data_o,
    p_data_read_i           => '1', -- Daten werden immer im gleichen Takt verarbeitet
    p_rx_err_o              => p_ser_err_o,

    p_data_i                => s_serial_data_i,
    p_send_i                => s_send_serial,
    p_busy_send_o           => s_serial_busy_send
);

access_mat : e_access_mat
PORT MAP(     
    p_rst_i                 => p_rst_i,
    p_clk_i                 => s_clk_1,
    p_syn_rst_i             => s_rst_access,
    
    p_write_mat_i           => s_write_mat,
    p_write_ytrain_i        => s_write_ytrain,
    p_read_mat_i            => s_read_mat,
    p_finished_o            => s_access_finished,
    
    p_new_data_i            => s_new_mat_data,
    p_data_read_o           => OPEN, -- Daten werden immer im gleichen Takt verarbeitet
    p_send_o                => s_send_mat,
    p_busy_send_i           => s_serial_busy_send,
    p_data_i                => s_mat_data_i,
    p_data_o                => s_mat_data_o,
   
    p_ix_o                  => s_mat_ix,
    p_word_o                => s_mat_word_i,
    p_word_i                => s_mat_word_o,
    p_size_i                => s_mat_size,
    p_row_by_row_i          => s_row_by_row,
    p_write_a0_o            => s_write_a0,
    p_read_a0_o             => s_read_a0,

    p_ytrain_wren_o         => s_ytrain_wren,
    p_ytrain_wraddress_o    => s_ytrain_write_addr,
    p_ytrain_data_o         => s_ytrain_data_i
);

sync_rx : e_sync
PORT MAP(
    p_rst_i                 => p_rst_i,
    p_clk_i                 => s_clk_1,      
    p_async_i               => p_rx_i,
    p_sync_o                => s_rx_synced
);

sync_dbg : e_sync
GENERIC MAP(
    g_default_val           => '0'
)
PORT MAP(
    p_rst_i                 => p_rst_i,
    p_clk_i                 => s_clk_1,      
    p_async_i               => p_set_debug_i,
    p_sync_o                => s_set_debug_synced
);

clock_pll_0 : clock_pll
PORT MAP(
    areset          => p_rst_i,
    inclk0          => p_clk_i,      
    c0              => s_clk_1,
    locked          => s_pll_locked
);

----------------------------------------------------------------------------------------------------
--  Prozesse
----------------------------------------------------------------------------------------------------

proc_sel_mat : PROCESS(s_write_ytrain, s_mat_reg)
BEGIN
    IF s_write_ytrain = '0' THEN
        IF s_mat_reg = x_train THEN
            s_row_by_row <= '1';
            s_mat_size <= to_mat_size(64, 64);
        ELSIF s_mat_reg = w1 THEN
            s_row_by_row <= '0';
            s_mat_size <= to_mat_size(64, 64);
        ELSIF s_mat_reg = b1 THEN
            s_row_by_row <= '1';
            s_mat_size <= to_mat_size(1, 64);
        ELSIF s_mat_reg = w2 THEN
            s_row_by_row <= '0';
            s_mat_size <= to_mat_size(64, 10);
        ELSIF s_mat_reg = b2 THEN
            s_row_by_row <= '1';
            s_mat_size <= to_mat_size(1, 10); 
        ELSIF s_mat_reg = scores THEN
            s_row_by_row <= '1';
            s_mat_size <= to_mat_size(64, 10); 
        ELSE
            s_row_by_row <= '1';
            s_mat_size <= to_mat_size(64, 64); -- Maximale Groesse zum Auslesen der Matrizen im Debug-Modus
        END IF;
    ELSE
        s_row_by_row <= '1';
        s_mat_size <= to_mat_size(1, 64);
    END IF;
END PROCESS proc_sel_mat;

proc_store_debug_mat : PROCESS(p_rst_i, s_clk_1)
BEGIN
    IF p_rst_i = '1' THEN
        s_dbg_mat_reg <= w1;
    ELSIF RISING_EDGE(s_clk_1) THEN
        IF s_set_dbg_mat_reg = '1' THEN
            s_dbg_mat_reg <= s_mat_reg;
        END IF;
    END IF;
END PROCESS proc_store_debug_mat;


----------------------------------------------------------------------------------------------------
--  Zustandsautomat
----------------------------------------------------------------------------------------------------

proc_change_state : PROCESS(s_clk_1, p_rst_i)
BEGIN
    IF p_rst_i = '1' THEN 
        s_cur_state <= st_init;
    ELSIF rising_edge(s_clk_1) THEN
        IF s_set_debug_synced = '0' THEN
            s_cur_state <= s_next_state;
        ELSE
            s_cur_state <= st_debug;
        END IF;
    END IF;
END PROCESS proc_change_state;
  
proc_calc_next_state : PROCESS(s_cur_state, s_access_finished, s_new_serial_data, s_serial_data_o, s_algo_finished, s_pll_locked)
BEGIN
    CASE s_cur_state IS
                     
        WHEN st_init =>             IF s_pll_locked = '1' THEN 
                                        s_next_state <= st_init_b1;
                                    ELSE
                                        s_next_state <= s_cur_state;
                                    END IF; 
        
        WHEN st_init_b1 =>          IF s_access_finished = '1' THEN
                                        s_next_state <= st_rst_access;
                                    ELSE 
                                        s_next_state <= s_cur_state;
                                    END IF;
                                
        WHEN st_rst_access =>       s_next_state <= st_init_b2;
                                
        WHEN st_init_b2 =>          IF s_access_finished = '1' THEN
                                        s_next_state <= st_send_init_done;
                                    ELSE 
                                        s_next_state <= s_cur_state;
                                    END IF;
                                
        WHEN st_send_init_done =>   s_next_state <= st_wait_w1; 
     
        WHEN st_wait_w1 =>          IF s_new_serial_data = '1' THEN
                                        IF s_serial_data_o = c_write_w1 THEN
                                            s_next_state <= st_write_w1;
                                        ELSE
                                            REPORT infomsg("Received Byte:" & to_hex(s_serial_data_o));
                                            s_next_state <= st_err;
                                        END IF;
                                    ELSE 
                                        s_next_state <= s_cur_state;
                                    END IF;
                                    
        WHEN st_write_w1 =>         IF s_access_finished = '1' THEN
                                        s_next_state <= st_wait_w2;
                                    ELSE 
                                        s_next_state <= s_cur_state;
                                    END IF;  
                                    
        WHEN st_wait_w2 =>          IF s_new_serial_data = '1' THEN
                                        IF s_serial_data_o = c_write_w2 THEN
                                            s_next_state <= st_write_w2;
                                        ELSE
                                            s_next_state <= st_err;
                                        END IF;
                                    ELSE 
                                        s_next_state <= s_cur_state;
                                    END IF;
                                    
        WHEN st_write_w2 =>         IF s_access_finished = '1' THEN
                                        s_next_state <= st_sel_mode;
                                    ELSE 
                                        s_next_state <= s_cur_state;
                                    END IF; 
        
        WHEN st_sel_mode =>         IF s_new_serial_data = '1' THEN
                                        IF s_serial_data_o = c_do_train THEN
                                            s_next_state <= st_write_x_train;
                                        ELSIF s_serial_data_o = c_do_test THEN
                                            s_next_state <= st_write_x_test;
                                        ELSE
                                            s_next_state <= st_err;
                                        END IF;
                                    ELSE 
                                        s_next_state <= s_cur_state;
                                    END IF;
                                    
        WHEN st_write_x_train =>    IF s_access_finished = '1' THEN
                                        s_next_state <= st_wait_y_train;
                                    ELSE 
                                        s_next_state <= s_cur_state;
                                    END IF;
           
        WHEN st_wait_y_train =>     IF s_new_serial_data = '1' THEN
                                        IF s_serial_data_o = c_write_y_train THEN
                                            s_next_state <= st_write_y_train;
                                        ELSE
                                            s_next_state <= st_err;
                                        END IF;
                                    ELSE 
                                        s_next_state <= s_cur_state;
                                    END IF;
                                    
        WHEN st_write_y_train =>    IF s_access_finished = '1' THEN
                                        s_next_state <= st_do_train;
                                    ELSE 
                                        s_next_state <= s_cur_state;
                                    END IF;
                                    
        WHEN st_do_train =>         IF s_algo_finished = '1' THEN
                                        s_next_state <= st_send_calc_done;
                                    ELSE
                                        s_next_state <= s_cur_state;
                                    END IF;
        
        WHEN st_send_calc_done =>   s_next_state <= st_sel_mode; 
        
        WHEN st_write_x_test =>     IF s_access_finished = '1' THEN
                                        s_next_state <= st_do_test;
                                    ELSE 
                                        s_next_state <= s_cur_state;
                                    END IF;
                                    
                                    
        WHEN st_do_test =>          IF s_algo_finished = '1' THEN
                                        s_next_state <= st_read_scores;
                                    ELSE
                                        s_next_state <= s_cur_state;
                                    END IF;
                                    
        WHEN st_read_scores =>      IF s_access_finished = '1' THEN
                                        s_next_state <= st_sel_mode;
                                    ELSE
                                        s_next_state <= s_cur_state;
                                    END IF; 
                                    
        WHEN st_err =>              s_next_state <= s_cur_state;     
  
        WHEN st_debug =>            IF s_new_serial_data = '1' THEN
                                        s_next_state <= st_debug_read_mat;
                                    ELSE 
                                        s_next_state <= s_cur_state;
                                    END IF; 
                                    
        WHEN st_debug_read_mat =>   IF s_access_finished = '1' THEN
                                        s_next_state <= st_debug;
                                    ELSE
                                        s_next_state <= s_cur_state;
                                    END IF; 
        
    END CASE;
END PROCESS proc_calc_next_state;

proc_calc_output : PROCESS(s_cur_state, s_new_serial_data, s_serial_data_o, s_dbg_mat_reg, s_mat_data_o, s_send_mat)
BEGIN
    -- Standardwerte
    s_rst_algo          <= '1';
    s_rst_access        <= '1';
    s_write_mat         <= '0';
    s_new_mat_data      <= '0';
    s_read_mat          <= '0';
    s_write_ytrain      <= '0';
    s_mat_data_i        <= (OTHERS => '-');  
    p_prot_err_o        <= '0';
    s_do_train          <= '0';
    s_mat_reg           <= b1;
    s_serial_data_i     <= (OTHERS => '-');
    s_send_serial       <= '0';
    s_set_dbg_mat_reg   <= '0';
    s_exec_algo         <= '0';
    
    CASE s_cur_state is
        
        WHEN st_init            =>  p_state_7ss0_o      <= bcd_to_7ss(x"0");
        
        WHEN st_init_b1         =>  s_mat_reg           <= b1;
                                    s_rst_access        <= '0';
                                    s_write_mat         <= '1';
                                    s_new_mat_data      <= '1';
                                    s_mat_data_i        <= to_slv(to_mat_elem(0.0));
                                    p_state_7ss0_o      <= bcd_to_7ss(x"0");
        
        WHEN st_rst_access      =>  p_state_7ss0_o      <= bcd_to_7ss(x"0");
        
        WHEN st_init_b2         =>  s_mat_reg           <= b2;
                                    s_rst_access        <= '0';
                                    s_write_mat         <= '1';
                                    s_new_mat_data      <= '1';
                                    s_mat_data_i        <= to_slv(to_mat_elem(0.0));
                                    p_state_7ss0_o      <= bcd_to_7ss(x"0");
           
        WHEN st_send_init_done  =>  s_send_serial       <= '1';
                                    s_serial_data_i     <= c_fpga_init_done;
                                    p_state_7ss0_o      <= bcd_to_7ss(x"0");
        
        WHEN st_wait_w1         =>  p_state_7ss0_o      <= bcd_to_7ss(x"1");
        
        WHEN st_write_w1        =>  s_mat_reg           <= w1;
                                    s_rst_access        <= '0';
                                    s_write_mat         <= '1';
                                    s_new_mat_data      <= s_new_serial_data;
                                    s_mat_data_i        <= s_serial_data_o;
                                    p_state_7ss0_o      <= bcd_to_7ss(x"2");
                                    
        WHEN st_wait_w2         =>  p_state_7ss0_o      <= bcd_to_7ss(x"3");
        
        WHEN st_write_w2        =>  s_mat_reg           <= w2;
                                    s_rst_access        <= '0';
                                    s_write_mat         <= '1';
                                    s_new_mat_data      <= s_new_serial_data;
                                    s_mat_data_i        <= s_serial_data_o;
                                    p_state_7ss0_o      <= bcd_to_7ss(x"4");
        
        WHEN st_sel_mode =>         p_state_7ss0_o      <= bcd_to_7ss(x"5");
        
        WHEN st_write_x_train =>    s_mat_reg           <= x_train;
                                    s_rst_access        <= '0';
                                    s_write_mat         <= '1';
                                    s_new_mat_data      <= s_new_serial_data;
                                    s_mat_data_i        <= s_serial_data_o;
                                    p_state_7ss0_o      <= bcd_to_7ss(x"6");
                                    
        WHEN st_wait_y_train =>     p_state_7ss0_o      <= bcd_to_7ss(x"7");
        
        WHEN st_write_y_train =>    s_rst_access        <= '0';
                                    s_write_ytrain      <= '1';
                                    s_new_mat_data      <= s_new_serial_data;
                                    s_mat_data_i        <= s_serial_data_o;
                                    p_state_7ss0_o      <= bcd_to_7ss(x"8");
                                    
        WHEN st_do_train =>         s_rst_algo          <= '0';
                                    s_do_train          <= '1';
                                    s_exec_algo         <= '1';
                                    p_state_7ss0_o      <= bcd_to_7ss(x"9");
        
        WHEN st_send_calc_done  =>  s_send_serial       <= '1';
                                    s_serial_data_i     <= c_fpga_calc_done;
                                    p_state_7ss0_o      <= bcd_to_7ss(x"0");
                                    
        WHEN st_write_x_test =>     s_mat_reg           <= x_train;
                                    s_rst_access        <= '0';
                                    s_write_mat         <= '1';
                                    s_new_mat_data      <= s_new_serial_data;
                                    s_mat_data_i        <= s_serial_data_o;
                                    p_state_7ss0_o      <= bcd_to_7ss(x"A");
         
        WHEN st_do_test =>          s_rst_algo          <= '0';
                                    s_exec_algo         <= '1';
                                    p_state_7ss0_o      <= bcd_to_7ss(x"B");
        
        WHEN st_read_scores  =>     s_mat_reg           <= scores;
                                    s_rst_algo          <= '0';
                                    s_rst_access        <= '0';
                                    s_read_mat          <= '1';
                                    s_serial_data_i     <= s_mat_data_o;
                                    s_send_serial       <= s_send_mat;
                                    p_state_7ss0_o      <= bcd_to_7ss(x"C");
        
        WHEN st_err             =>  p_prot_err_o        <= '1';
                                    p_state_7ss0_o      <= bcd_to_7ss(x"F");
        
        WHEN st_debug           =>  s_set_dbg_mat_reg   <= '1';
                                    s_mat_reg           <= UNSIGNED(s_serial_data_o(t_mat_reg_ix'RANGE));
                                    p_state_7ss0_o      <= bcd_to_7ss(x"D");
                                   
        WHEN st_debug_read_mat  =>  s_mat_reg           <= s_dbg_mat_reg;
                                    s_rst_algo          <= '0';
                                    s_rst_access        <= '0';
                                    s_read_mat          <= '1';
                                    s_serial_data_i     <= s_mat_data_o;
                                    s_send_serial       <= s_send_mat;
                                    p_state_7ss0_o      <= bcd_to_7ss(x"E");
        
    END CASE;
END PROCESS proc_calc_output;

END ARCHITECTURE a_tle_nn;