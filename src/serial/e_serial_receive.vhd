----------------------------------------------------------------------------------------------------
-- Modul zur Empfangen von Daten ueber die serielle Schnittstelle.
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
--      p_rx_i          : Empfangskanal RxD
--
--      p_data_o        : Gelesene Daten
--      p_new_data_o    : Signalisiert, dass neue Daten vorliegen
--      p_d_data_read_o : Signalisiert, dass die Daten geleseen worden sind
--      p_rx_err_o      : Signalisiert, dass beim Empfangen ein Fehler aufgetreten ist
--
--  Autor: Niklas Kuehl
--  Datum: 26.04.2018
----------------------------------------------------------------------------------------------------
LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;
USE work.pkg_tools.ALL;

----------------------------------------------------------------------------------------------------
--  Entity
----------------------------------------------------------------------------------------------------
ENTITY e_serial_receive IS
    GENERIC(
        g_clk_period        : TIME      := 20 ns;
        g_baudrate          : POSITIVE  := 115200 
    );
    PORT(
        p_rst_i             : IN STD_LOGIC;
        p_clk_i             : IN STD_LOGIC;

        p_rx_i              : IN STD_LOGIC;

        p_new_data_o        : OUT STD_LOGIC;
        p_data_o            : OUT t_byte;
        p_data_read_i       : IN STD_LOGIC;
        p_rx_err_o          : OUT STD_LOGIC
    );
END ENTITY e_serial_receive;


----------------------------------------------------------------------------------------------------
--  Architecture
----------------------------------------------------------------------------------------------------
ARCHITECTURE a_serial_receive OF e_serial_receive IS

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

CONSTANT frame_len          : POSITIVE  := 10;
CONSTANT timer_wait_time    : TIME      := f_calc_serial_wait_time(g_baudrate) - 2 * g_clk_period; --Zustandswechsel benoetigen 2 Taktperioden

-- Zustaende
TYPE t_state IS (st_init, st_rec, st_wait, st_new_data, st_err); 
SIGNAL s_cur_state, s_next_state : t_state;

SIGNAL s_ena_shift, s_load_data, s_reg_shift_o: STD_LOGIC;
SIGNAL s_reg_data_o : STD_LOGIC_VECTOR(frame_len-1 DOWNTO 0);

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
                
    p_data_i            => b"1_1111_1111_1",
    p_data_o            => s_reg_data_o,

    p_data_shift_i      => p_rx_i,
    p_data_shift_o      => s_reg_shift_o,
    
    p_load_data_i       => s_load_data,
    p_shift_data_i      => s_ena_shift
);

----------------------------------------------------------------------------------------------------
--  Zuweisungen
----------------------------------------------------------------------------------------------------

p_data_o <= s_reg_data_o(8 DOWNTO 1);

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
  
  
proc_calc_next_state : PROCESS(s_cur_state, p_rx_i, s_reg_shift_o, s_timer_finished, s_reg_data_o, p_data_read_i)
BEGIN
    CASE s_cur_state IS
                  
        WHEN st_init =>     IF p_rx_i = '0' THEN 
                                s_next_state <= st_rec;
                            ELSE 
                                s_next_state <= s_cur_state;
                            END IF;
    
        WHEN st_rec =>      s_next_state <= st_wait;
        
        WHEN st_wait =>     IF s_reg_shift_o /= '0' THEN
                                IF s_timer_finished = '1' THEN
                                    s_next_state <= st_rec;
                                ELSE
                                    s_next_state <= s_cur_state;
                                END IF;
                            ELSE
                                IF s_reg_data_o(s_reg_data_o'HIGH(1)) = '1' THEN
                                    s_next_state <= st_new_data;
                                ELSE
                                    s_next_state <= st_err;
                                END IF;                   
                            END IF;
                               
        WHEN st_new_data => IF p_data_read_i = '1' THEN 
                                s_next_state <= st_init;
                            ELSE 
                                s_next_state <= s_cur_state;
                            END IF;
                            
        WHEN st_err =>      s_next_state <= s_cur_state;  
        
    END CASE;
END PROCESS proc_calc_next_state;

proc_calc_output : PROCESS(s_cur_state)
BEGIN
    CASE s_cur_state is
                          
        WHEN st_init =>     p_new_data_o    <= '0';
                            p_rx_err_o      <= '0';
                            s_start_timer   <= '1';
                            s_load_data     <= '1';
                            s_ena_shift     <= '0';
                  
        WHEN st_rec =>      p_new_data_o    <= '0';
                            p_rx_err_o      <= '0';
                            s_start_timer   <= '1';
                            s_load_data     <= '0';
                            s_ena_shift     <= '1';
                            
        WHEN st_wait =>     p_new_data_o    <= '0';
                            p_rx_err_o      <= '0';
                            s_start_timer   <= '0';
                            s_load_data     <= '0';
                            s_ena_shift     <= '0';
                            
        WHEN st_new_data => p_new_data_o    <= '1';
                            p_rx_err_o      <= '0';
                            s_start_timer   <= '0';
                            s_load_data     <= '0';
                            s_ena_shift     <= '0';
                            
        WHEN st_err =>      p_new_data_o    <= '0';
                            p_rx_err_o      <= '1';
                            s_start_timer   <= '0';
                            s_load_data     <= '0';
                            s_ena_shift     <= '0';
    END CASE;
END PROCESS proc_calc_output;

END ARCHITECTURE a_serial_receive;