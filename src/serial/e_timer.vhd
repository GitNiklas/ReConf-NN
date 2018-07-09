----------------------------------------------------------------------------------------------------
--  Timer. Zaehlt bestimmte Zeitspannen, und signalisiert, wenn diese abgelaufen sind
--
--  Generics:
--      g_clk_periode   : Periodendauer des Taktes p_clk_i
--      g_t0           : 1. Zeit, bis zu der gezaehlt werden soll
--      g_t1           : 2. Zeit, bis zu der gezaehlt werden soll
--      g_t2           : 3. Zeit, bis zu der gezaehlt werden soll. Muss groesser sein als g_t0 & g_t1 
--
--  Port:
--      p_rst_i         : Asynchroner Reset
--      p_clk_i         : Takt
--      p_start_i       : Zaehler Starten/Zuruecksetzen;
--        
--      p_t0_finished_o : '1' wenn g_t0 abgelaufen
--      p_t1_finished_o : '1' wenn g_t1 abgelaufen
--      p_t2_finished_o : '1' wenn g_t2 abgelaufen
--
--  Autor: Niklas Kuehl
--  Datum: 27.04.2018
----------------------------------------------------------------------------------------------------
LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;

----------------------------------------------------------------------------------------------------
--  Entity
----------------------------------------------------------------------------------------------------
ENTITY e_timer IS
    GENERIC( 
        g_clk_periode       : TIME := 20 ns;
        g_t0                : TIME := 1 us;
        g_t1                : TIME := 10 us;
        g_t2                : TIME := 20 us
    );         
    PORT (    
        p_rst_i             : IN STD_LOGIC;
        p_clk_i             : IN STD_LOGIC;        
        p_start_i           : IN STD_LOGIC;
        
        p_t0_finished_o     : OUT STD_LOGIC;
        p_t1_finished_o     : OUT STD_LOGIC;
        p_t2_finished_o     : OUT STD_LOGIC
    );
END ENTITY e_timer;


----------------------------------------------------------------------------------------------------
--  Architecture
----------------------------------------------------------------------------------------------------
ARCHITECTURE a_timer OF e_timer IS
 
SIGNAL s_clk_steps : INTEGER RANGE 0 TO g_t2/g_clk_periode;

BEGIN

p_t0_finished_o <= '1' WHEN s_clk_steps >= g_t0/g_clk_periode ELSE '0';
p_t1_finished_o <= '1' WHEN s_clk_steps >= g_t1/g_clk_periode ELSE '0';
p_t2_finished_o <= '1' WHEN s_clk_steps >= g_t2/g_clk_periode ELSE '0';


proc_count : PROCESS(p_clk_i, p_rst_i, p_start_i, s_clk_steps)
BEGIN
    IF p_rst_i = '1' THEN 
        s_clk_steps <= 0;
    ELSIF rising_edge(p_clk_i) THEN
        IF p_start_i = '1' THEN
            s_clk_steps <= 0;
        ELSE    
            IF s_clk_steps /= g_t2/g_clk_periode THEN
                s_clk_steps <= s_clk_steps + 1;
            END IF;
        END IF;
    END IF;
END PROCESS proc_count;
  
END ARCHITECTURE a_timer;
