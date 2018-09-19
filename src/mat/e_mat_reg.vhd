----------------------------------------------------------------------------------------------------
-- Matrix-Register zur Speicherung einer Matrix im RAM.
--
-- Maximale Groesse: 64x64; Ein Matrixelement ist 8 Byte lang
-- Die Matrix wird in Woertern organisiert, jedes Wort enthaelt 32 Matrix-Elemente. 
-- Die Wörter koennen entweder zeilen- oder spaltenweise gespeichert werden.
-- Die Indizes sind element-basiert, es wird jeweils das Wort geschrieben/ausgelesen, in dem das durch den Index
-- gewaehlte Element liegt.
--
--  Port:
--      p_rst_i         : Asynchroner Reset
--      p_clk_i         : Takt
--
--      p_mat_size_i    : Setzt die Matrix-Groesse, wenn p_wren_i = 1 
--      p_mat_size_o    : Aktuelle Matrix-Groesse
--
--      p_ix_read_i     : Leseposition. Es dauert 2 Takte, bis das entsprechende Wort an p_word_o anliegt
--      p_ix_write_i    : Schreibposition
--
--      p_wren_i        : Aktiviert Schreiben der Matrixdaten
--
--      p_row_by_row_i  : Setzt die Matrix-Orientierung, wenn p_wren_i = 1 
--      p_row_by_row_o  : Aktuelle Matrix-Orientierung (1 -> zeilenweise, 0 -> spaltenweise)
--
--      p_word_i        : Zu schreibendes Matrix-Wort
--      p_word_o        : Gelesenes Matrix-Wort
--
--  Autor: Niklas Kuehl
----------------------------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
USE work.fixed_pkg.ALL;
USE work.pkg_tools.ALL;

ENTITY e_mat_reg IS       
    PORT (    
        p_clk_i             : IN STD_LOGIC;
        p_rst_i             : IN STD_LOGIC;
        
        p_mat_size_i        : IN t_mat_size;
        p_mat_size_o        : OUT t_mat_size;
        
        p_ix_read_i         : IN t_mat_ix;
        p_ix_write_i        : IN t_mat_ix;
        
        p_wren_i            : IN STD_LOGIC;
        
        p_row_by_row_i      : IN STD_LOGIC;
        p_row_by_row_o      : OUT STD_LOGIC;
        
        p_word_i            : IN t_mat_word;
        p_word_o            : OUT t_mat_word
    );
END ENTITY e_mat_reg;

----------------------------------------------------------------------------------------------------
--  Architecture
----------------------------------------------------------------------------------------------------
ARCHITECTURE a_mat_reg OF e_mat_reg IS

----------------------------------------------------------------------------------------------------
--  Komponenten
----------------------------------------------------------------------------------------------------

COMPONENT e_ram
    PORT (
        clock       : IN STD_LOGIC  := '1';
        data        : IN STD_LOGIC_VECTOR (255 DOWNTO 0);
        rdaddress   : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
        wraddress   : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
        wren        : IN STD_LOGIC  := '0';
        q           : OUT STD_LOGIC_VECTOR (255 DOWNTO 0)
    );
END COMPONENT;

----------------------------------------------------------------------------------------------------
--  Signale
----------------------------------------------------------------------------------------------------
SIGNAL s_ix_read, s_ix_write : t_mat_ix;
SIGNAL s_ram_data_o, s_ram_data_i : STD_LOGIC_VECTOR (255 DOWNTO 0);
SIGNAL s_ram_addr_read, s_ram_addr_write : STD_LOGIC_VECTOR (6 DOWNTO 0);
SIGNAL s_mix_row_col : STD_LOGIC;
SIGNAL s_row_by_row : STD_LOGIC;

----------------------------------------------------------------------------------------------------
--  Port Maps
----------------------------------------------------------------------------------------------------
BEGIN

ram : e_ram
PORT MAP(
    clock       => p_clk_i,
    data        => s_ram_data_i,
    rdaddress   => s_ram_addr_read,
    wraddress   => s_ram_addr_write,
    wren        => p_wren_i,
    q           => s_ram_data_o
);

----------------------------------------------------------------------------------------------------
--  Zuweisungen
----------------------------------------------------------------------------------------------------

s_ram_addr_read <= STD_LOGIC_VECTOR(s_ix_read.row & s_ix_read.col(s_ix_read.col'HIGH));
s_ram_addr_write <= STD_LOGIC_VECTOR(s_ix_write.row & s_ix_write.col(s_ix_write.col'HIGH));
p_row_by_row_o <= s_row_by_row;
s_mix_row_col <= s_row_by_row WHEN p_wren_i = '0' ELSE p_row_by_row_i;

----------------------------------------------------------------------------------------------------
--  Prozesse
----------------------------------------------------------------------------------------------------

proc_save_row_by_row : PROCESS(p_clk_i, p_rst_i)
BEGIN
    IF p_rst_i = '1' THEN
        s_row_by_row <= '0';
    ELSIF RISING_EDGE(p_clk_i) THEN
        IF p_wren_i = '1' THEN
            s_row_by_row <= p_row_by_row_i;
        END IF;
    END IF;
END PROCESS proc_save_row_by_row;


proc_save_size : PROCESS(p_clk_i, p_rst_i)
BEGIN
    IF p_rst_i = '1' THEN
        p_mat_size_o <= c_mat_size_zero;
    ELSIF RISING_EDGE(p_clk_i) THEN
        IF p_wren_i = '1' THEN
            p_mat_size_o <= p_mat_size_i;
        END IF;
    END IF;
END PROCESS proc_save_size;

proc_typecast : PROCESS(s_ram_data_o, p_word_i)
    VARIABLE v_ub : INTEGER;
    VARIABLE v_lb : INTEGER;
BEGIN
    FOR i IN p_word_i'RANGE LOOP  
        v_ub := 8 * i + 7;
        v_lb := 8 * i;
        p_word_o(i) <= t_mat_elem( s_ram_data_o(v_ub DOWNTO v_lb));
        s_ram_data_i(v_ub DOWNTO v_lb) <= t_mat_elem_slv(p_word_i(i));
    END LOOP;
END PROCESS proc_typecast;

proc_mix_row_col : PROCESS(s_mix_row_col, p_ix_read_i, p_ix_write_i)
BEGIN
    IF s_mix_row_col = '1' THEN
        s_ix_read.row <= p_ix_read_i.row;
        s_ix_read.col <= p_ix_read_i.col;
        s_ix_write.row <= p_ix_write_i.row;
        s_ix_write.col <= p_ix_write_i.col;
    ELSE
        s_ix_read.row <= p_ix_read_i.col;
        s_ix_read.col <= p_ix_read_i.row;
        s_ix_write.row <= p_ix_write_i.col;
        s_ix_write.col <= p_ix_write_i.row;
    END IF;
END PROCESS proc_mix_row_col;

END ARCHITECTURE a_mat_reg;