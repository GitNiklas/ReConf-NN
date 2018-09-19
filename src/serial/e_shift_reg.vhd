----------------------------------------------------------------------------------------------------
--  Schieberegister, das zusaetzlich parallel geladen und gelesen werden kann.
--
--  Generics:
--      n               : Breite des Datenwortes (Anzahl der FFs)
--
--  Port:
--      p_rst_i         : Asynchroner Reset
--      p_clk_i         : Takt
--        
--      p_data_i        : Dateneingang zum parallelen Laden
--      p_data_o        : Datenausgang zum parallelen Lesen 
--
--      p_data_shift_i  : Dateneingang zum Shiften
--      p_data_shift_o  : Datenausgang zum Shiften. Entspricht dem 0. Bit des Registers
--    
--      p_load_data_i   : Bei '1' werden die Daten, die an p_data_i anliegen, gespeichert
--      p_shift_data_i  : Bei '1' wird das aktuelle Datum um 1 nach rechts verschoben.
--                        Nachgeschoben wird mit p_data_shift_i    
--
--  Autor: Niklas Kuehl
----------------------------------------------------------------------------------------------------
LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;

----------------------------------------------------------------------------------------------------
--  Entity
----------------------------------------------------------------------------------------------------
ENTITY e_shift_reg IS
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
END ENTITY e_shift_reg;

ARCHITECTURE a_shift_reg OF e_shift_reg IS

SIGNAL s_register : STD_LOGIC_VECTOR(n-1 DOWNTO 0);
BEGIN

p_data_o <= s_register;
p_data_shift_o <= s_register(0);

proc_shift_reg : PROCESS(p_clk_i, p_rst_i)
BEGIN
    IF p_rst_i = '1' THEN 
        FOR i IN s_register'RANGE LOOP
            s_register(i) <= '0';
        END LOOP;
    ELSIF rising_edge(p_clk_i) THEN
        IF p_load_data_i = '1' THEN
            s_register <= p_data_i;
        END IF;
        IF p_shift_data_i = '1' THEN
            s_register <= p_data_shift_i & s_register(n-1 DOWNTO 1);
        END IF;
    END IF;
END PROCESS proc_shift_reg;

END ARCHITECTURE a_shift_reg;

