----------------------------------------------------------------------------------------------------
--  Package pkg_tools
--  Enthaelt Hilfsfunktionen und Konstanten zur Verwendung an mehreren Stellen.
--
--  Autor: Niklas Kuehl
--  Datum: 26.04.2018
----------------------------------------------------------------------------------------------------
LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;
    
PACKAGE pkg_tools IS

    -- Periodendauer des Takts des Cyclone II Boards
    CONSTANT c_clk_per        : TIME;
  
    CONSTANT c_baudrate       : POSITIVE;

    ----------------------------------------------------------------------------------------------------
    -- Function f_calc_serial_wait
    -- Parameter:
    --    IN:       baudrate
    --    RETURN:   Zeit zwischen zwei Pegelwechseln der Datenkanaele
    ----------------------------------------------------------------------------------------------------
    FUNCTION f_calc_serial_wait_time(baudrate : POSITIVE) RETURN TIME;

END;

PACKAGE BODY pkg_tools IS

    CONSTANT c_clk_per        : TIME      := 20 ns;  
  
    CONSTANT c_baudrate       : POSITIVE  := 115200;

    FUNCTION f_calc_serial_wait_time(baudrate : POSITIVE) RETURN TIME IS
    BEGIN
        RETURN 1 sec / baudrate; --104 us; -- todo: aus baudrate berechnen
    END f_calc_serial_wait_time;
    
END PACKAGE BODY;