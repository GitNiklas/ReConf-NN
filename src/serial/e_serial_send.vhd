----------------------------------------------------------------------------------------------------
-- Modul zum Senden von Daten ueber die serielle Schnittstelle.
-- Die Kommunikation erfolgt mit: 8 Datenbits, 1 Stoppbit, Keine Paritaet
-- Die Baudrate ist variabel.
--
--  Generics:
--      g_clk_period    : Periodendauer des Taktes p_clk_i
--      g_baudrate      : Baudrate mit der kommuniziert werden soll
--
--  Port:
--      p_rst_i         : Asynchroner Reset
--      p_clk_i         : Takt
--       
--      p_tx_o          : Sendekanal TxD
--    
--      p_data_i        : Zu sendende Daten
--      p_send_i        : Signalisiert, dass die Daten gesendet werden sollen
--      p_busy_send_o   : Signalisiert, dass gerade Daten gesendet werden
----------------------------------------------------------------------------------------------------
LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;
USE work.pkg_tools.ALL;

----------------------------------------------------------------------------------------------------
--  Entity
----------------------------------------------------------------------------------------------------
ENTITY e_serial_send IS
    GENERIC(
        g_clk_period        : TIME      := 20 ns;
        g_baudrate          : POSITIVE  := 115200 
    );
    PORT(
        p_rst_i             : IN STD_LOGIC;
        p_clk_i             : IN STD_LOGIC;

        p_tx_o              : OUT STD_LOGIC;
    
        p_data_i            : IN t_byte;
        p_send_i            : IN STD_LOGIC;
        p_busy_send_o       : OUT STD_LOGIC
    );
END ENTITY e_serial_send;


----------------------------------------------------------------------------------------------------
--  Architecture
----------------------------------------------------------------------------------------------------
ARCHITECTURE a_serial_send OF e_serial_send IS

----------------------------------------------------------------------------------------------------
--  Komponenten
----------------------------------------------------------------------------------------------------

COMPONENT e_timer
    GENERIC(  
        g_clk_period            : TIME := 20 ns;
        g_t0                    : TIME := 50 us;
        g_t1                    : TIME := 100 us;
        g_t2                    : TIME := 200 us
    );
    PORT (
        p_rst_i                 : IN STD_LOGIC;
        p_clk_i                 : IN STD_LOGIC;
        P_start_i               : IN STD_LOGIC;
        
        p_t0_finished_o         : OUT STD_LOGIC;
        p_t1_finished_o         : OUT STD_LOGIC;
        p_t2_finished_o         : OUT STD_LOGIC
    );
END COMPONENT;

COMPONENT e_shift_reg
    GENERIC(n : POSITIVE := 16);
    PORT (
        p_rst_i                 : IN STD_LOGIC;
        p_clk_i                 : IN STD_LOGIC;

        p_data_i                : IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
        p_data_o                : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0); 

        p_data_shift_i          : IN STD_LOGIC;
        p_data_shift_o          : OUT STD_LOGIC;
        
        p_load_data_i           : IN STD_LOGIC;
        p_shift_data_i          : IN STD_LOGIC
    );
END COMPONENT;

----------------------------------------------------------------------------------------------------
--  Typen / Signale
----------------------------------------------------------------------------------------------------

CONSTANT frame_len          : POSITIVE  := 11; -- 1 zusatzliches Bit, damit tx zwischen Sendevorgaengen durchgehend high ist
CONSTANT timer_wait_time    : TIME      := f_calc_serial_wait_time(g_baudrate) - 2 * g_clk_period; -- Zustandswechsel benoetigen 2 Taktperioden

-- Zustaende
TYPE t_state IS (st_init, st_send, st_shift); 
SIGNAL s_cur_state, s_next_state : t_state;

SIGNAL s_ena_shift, s_load_data, s_reg_shift_o: STD_LOGIC;
SIGNAL s_reg_data_o, s_reg_data_i : STD_LOGIC_VECTOR(frame_len-1 DOWNTO 0);

SIGNAL s_start_timer, s_timer_finished : STD_LOGIC;

----------------------------------------------------------------------------------------------------
--  Port Maps
----------------------------------------------------------------------------------------------------
BEGIN

timer : e_timer
GENERIC MAP(
    g_clk_period        => g_clk_period,
    g_t0                => timer_wait_time,
    g_t1                => timer_wait_time,
    g_t2                => timer_wait_time
)
PORT MAP(
    p_rst_i             => p_rst_i,
    p_clk_i             => p_clk_i,
    P_start_i           => s_start_timer,
    p_t0_finished_o     => OPEN,
    p_t1_finished_o     => OPEN,
    p_t2_finished_o     => s_timer_finished
);

shift_reg : e_shift_reg
GENERIC MAP(n => frame_len)
PORT MAP(
    p_rst_i             => p_rst_i,
    p_clk_i             => p_clk_i,
                
    p_data_i            => s_reg_data_i,
    p_data_o            => s_reg_data_o,

    p_data_shift_i      => '0',
    p_data_shift_o      => s_reg_shift_o,
    
    p_load_data_i       => s_load_data,
    p_shift_data_i      => s_ena_shift
);

----------------------------------------------------------------------------------------------------
--  Zuweisungen
----------------------------------------------------------------------------------------------------

s_reg_data_i <= "11" & p_data_i & '0';

----------------------------------------------------------------------------------------------------
--  Zustandsautomat
----------------------------------------------------------------------------------------------------

proc_change_state : PROCESS(p_clk_i, p_rst_i)
BEGIN
    IF p_rst_i = '1' THEN 
        s_cur_state <= st_init;
    ELSIF rising_edge(p_clk_i) THEN
        s_cur_state <= s_next_state;
    END IF;
END PROCESS proc_change_state;
  
  
proc_calc_next_state : PROCESS(s_cur_state, p_send_i, s_reg_data_o, s_timer_finished)
BEGIN
    CASE s_cur_state IS
                  
        WHEN st_init =>     IF p_send_i = '1' THEN 
                                s_next_state <= st_send;
                            ELSE 
                                s_next_state <= s_cur_state;
                            END IF;
    
        WHEN st_send =>     IF s_reg_data_o = b"00_0000_0000_1" THEN 
                                s_next_state <= st_init;
                            ELSIF s_timer_finished = '1' THEN
                                s_next_state <= st_shift;
                            ELSE 
                                s_next_state <= s_cur_state;
                            END IF;   
                          
        WHEN st_shift =>    s_next_state <= st_send;   

    END CASE;
END PROCESS proc_calc_next_state;

proc_calc_output : PROCESS(s_cur_state, s_reg_shift_o)
BEGIN
    CASE s_cur_state is
                          
        WHEN st_init =>     p_busy_send_o   <= '0';
                            p_tx_o          <= '1';
                            s_start_timer   <= '1';
                            s_load_data     <= '1';
                            s_ena_shift     <= '0';
                  
        WHEN st_send =>     p_busy_send_o   <= '1';
                            p_tx_o          <= s_reg_shift_o;
                            s_start_timer   <= '0';
                            s_load_data     <= '0';
                            s_ena_shift     <= '0';
                          
        WHEN st_shift =>    p_busy_send_o   <= '1';
                            p_tx_o          <= s_reg_shift_o;
                            s_start_timer   <= '1';
                            s_load_data     <= '0';
                            s_ena_shift     <= '1';

    END CASE;
END PROCESS proc_calc_output;

END ARCHITECTURE a_serial_send;