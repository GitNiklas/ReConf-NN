----------------------------------------------------------------------------------------------------
--  Doppelsynchronisationsschaltung zum verhindern von Metastabilitaet
--
--  Port:
--    p_rst_i    : Asynchroner Reset
--    p_clk_i    : Takt
--    
--    p_async_i  : Asynchrones Eingangssignal
--    p_sync_o   : Synchronisiertes Ausgangssignal
--
--  Autor: Niklas Kuehl
----------------------------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

----------------------------------------------------------------------------------------------------
--  Entity
----------------------------------------------------------------------------------------------------
ENTITY e_sync IS
    GENERIC(
        g_default_val   : STD_LOGIC  := '1' 
    );
    PORT (
        p_rst_i         : IN STD_LOGIC;
        p_clk_i         : IN STD_LOGIC;

        p_async_i       : IN STD_LOGIC;
        p_sync_o        : OUT STD_LOGIC
    );
END ENTITY e_sync;

----------------------------------------------------------------------------------------------------
--  Architecture
----------------------------------------------------------------------------------------------------
ARCHITECTURE a_sync OF e_sync IS

SIGNAL s_tmp : STD_LOGIC;

BEGIN

proc_sync : PROCESS (p_clk_i, p_rst_i) IS
BEGIN
    IF p_rst_i = '1' THEN
        s_tmp <= g_default_val;
        p_sync_o <= g_default_val;
    ELSIF RISING_EDGE(p_clk_i) THEN
        s_tmp <= p_async_i;
        p_sync_o <= s_tmp;
    END IF;
END PROCESS proc_sync;

END ARCHITECTURE a_sync;
