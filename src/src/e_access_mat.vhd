----------------------------------------------------------------------------------------------------
-- Entity zum externen Zugriff auf die Register der Matrix-CPU über eine serielle Schnittstelle.
--
--  Port:
--      p_rst_i                 : Asynchroner Reset
--      p_clk_i                 : Takt
--      p_syn_rst_i             : Synchroner Reset
--      
--      p_write_mat_i           : Signalisiert, dass ein Matrixregister beschrieben werden soll
--      p_write_ytrain_i        : Signalisiert, dass das Array y_train beschrieben werden soll
--      p_read_mat_i            : Signalisiert, dass ein Matrixregister gelesen werden soll
--      p_finished_o            : Signalisiert, dass die kompletten Daten verarbeitet wurden
--      
--      p_new_data_i            : Signalisiert, dass neue Daten vorliegen
--      p_data_read_o           : Signalisiert, dass die Daten geleseen worden sind;
--      p_send_o                : Signalisiert, dass die Daten gesendet werden sollen
--      p_busy_send_i           : Signalisiert, dass gerade Daten gesendet werden
--      p_data_i                : Empfangene Daten
--      p_data_o                : Zu Sendende Daten
--       
--      p_ix_o                  : Lese/Schreibindex Matrixregister
--      p_word_o                : Zu Schreibende Daten Matrixregister
--      p_word_i                : Gelesene Daten Matrixregister
--      p_size_i                : Groesse des Matrixregisters das gelesen/beschrieben wird
--      p_row_by_row_i          : Orientierung des Matrixregisters das gelesen/beschrieben wird
--      p_write_a0_o            : Signalisiert, dass das Matrixregister beschrieben wird
--      p_read_a0_o             : Signalisiert, dass das Matrixregister gelesen wird
--
--      p_ytrain_wren_o         : Schreiberlaubnis y_train
--      p_ytrain_wraddress_o    : Schreibadresse y_train
--      p_ytrain_data_o         : Zu schreibende Daten y_train
----------------------------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
USE work.fixed_pkg.ALL;
USE work.pkg_tools.ALL;

ENTITY e_access_mat IS       
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
END ENTITY e_access_mat;

----------------------------------------------------------------------------------------------------
--  Architecture
----------------------------------------------------------------------------------------------------
ARCHITECTURE a_access_mat OF e_access_mat IS

----------------------------------------------------------------------------------------------------
--  Komponenten
----------------------------------------------------------------------------------------------------

COMPONENT e_mat_ix_gen
    GENERIC (inc_by_wordlen : BOOLEAN := TRUE);
    PORT (    
        p_rst_i                 : IN STD_LOGIC;
        p_clk_i                 : IN STD_LOGIC;
        
        p_syn_rst_i             : IN STD_LOGIC;
        p_finished_o            : OUT STD_LOGIC;
        p_word_done_i           : IN STD_LOGIC;
        
        p_size_i                : IN t_mat_size;
        p_row_by_row_i          : IN STD_LOGIC;
        p_mat_ix_t0_o           : OUT t_mat_ix;
        p_mat_ix_t4_o           : OUT t_mat_ix;
        p_first_elem_t1_o       : OUT STD_LOGIC
    );
END COMPONENT;

COMPONENT e_set_word_elem
    PORT (  
        p_rst_i                 : IN STD_LOGIC;
        p_clk_i                 : IN STD_LOGIC;
        p_syn_rst_i             : IN STD_LOGIC;
        
        p_ix_write_i            : IN t_mat_ix;
        p_word_done_i           : IN STD_LOGIC;
        
        p_elem_i                : IN t_mat_elem;
        p_row_by_row_i          : IN STD_LOGIC;
        p_size_i                : IN t_mat_size;
        
        p_word_o                : OUT t_mat_word;
        p_ix_write_o            : OUT t_mat_ix
    );
END COMPONENT;

----------------------------------------------------------------------------------------------------
--  Signale
----------------------------------------------------------------------------------------------------

SIGNAL s_elem, s_elem_reg : t_mat_elem;
SIGNAL s_ix : t_mat_ix;
SIGNAL s_first_elem, s_inc_ix_write, s_inc_ix_read, s_inc_ix : STD_LOGIC;
SIGNAL s_ena_write : STD_LOGIC;
SIGNAL s_new_data_t1: STD_LOGIC;

SIGNAL s_read_mat_t1, s_read_mat_t2, s_read_mat_t3, s_read_mat_t4, s_read_mat_t5 : STD_LOGIC;
SIGNAL s_word_ix : t_mat_ix_elem;
SIGNAL s_send : STD_LOGIC;
SIGNAL s_finished_t1, s_finished_t2, s_finished_send : STD_LOGIC;
SIGNAL s_send_t1, s_send_t2 : STD_LOGIC;
SIGNAL s_last, s_last_t1 : STD_LOGIC;

----------------------------------------------------------------------------------------------------
--  Port Maps
----------------------------------------------------------------------------------------------------
BEGIN

set_word_elem : e_set_word_elem
PORT MAP(
    p_rst_i             => p_rst_i,
    p_clk_i             => p_clk_i,
    p_syn_rst_i         => p_syn_rst_i,
    
    p_ix_write_i        => s_ix,
    p_word_done_i       => s_ena_write,
    
    p_elem_i            => s_elem_reg,
    p_row_by_row_i      => p_row_by_row_i,
    p_size_i            => p_size_i,
    
    p_word_o            => p_word_o,
    p_ix_write_o        => p_ix_o
);
 
ix_c_gen : e_mat_ix_gen
GENERIC MAP(inc_by_wordlen => FALSE)
PORT MAP(
    p_rst_i             => p_rst_i,
    p_clk_i             => p_clk_i,
    
    p_syn_rst_i         => p_syn_rst_i,
    p_finished_o        => s_finished_t1,
    p_word_done_i       => s_inc_ix,

    p_size_i            => p_size_i,
    p_row_by_row_i      => p_row_by_row_i,
    p_mat_ix_t0_o       => s_ix,
    p_mat_ix_t4_o       => OPEN,
    p_first_elem_t1_o   => OPEN
);


----------------------------------------------------------------------------------------------------
--  Zuweisungen
----------------------------------------------------------------------------------------------------
s_inc_ix <= s_inc_ix_read WHEN p_read_mat_i = '1' ELSE s_inc_ix_write;
p_finished_o <= s_finished_send WHEN p_read_mat_i = '1' ELSE s_finished_t2;

s_ena_write <= p_write_mat_i AND s_new_data_t1;
p_write_a0_o <= s_ena_write;
s_elem <= to_mat_elem(p_data_i);
f_reg(p_rst_i, p_clk_i, p_syn_rst_i, p_new_data_i, s_new_data_t1);
s_inc_ix_write <= p_new_data_i AND NOT s_first_elem;
p_data_read_o <= '1';
f_reg(p_rst_i, p_clk_i, p_syn_rst_i, s_finished_t1, s_finished_t2);
 
p_read_a0_o <= p_read_mat_i;
s_send <= s_read_mat_t5 AND NOT p_busy_send_i;
f_reg(p_rst_i, p_clk_i, p_syn_rst_i, s_send, s_send_t1);
f_reg(p_rst_i, p_clk_i, p_syn_rst_i, s_send_t1, s_send_t2);
f_reg(p_rst_i, p_clk_i, p_syn_rst_i, s_last, s_last_t1);
s_inc_ix_read <= s_send_t1 AND NOT s_send_t2;
p_send_o <= s_send;
s_word_ix <= s_ix.col WHEN p_row_by_row_i = '1' ELSE s_ix.row;
s_finished_send <= s_last_t1 AND NOT p_busy_send_i;

 -- Es dauert 5 Taktperioden, bis die Daten aus dem RAM gelesen wurden
f_reg(p_rst_i, p_clk_i, p_syn_rst_i, p_read_mat_i, s_read_mat_t1);
f_reg(p_rst_i, p_clk_i, p_syn_rst_i, s_read_mat_t1, s_read_mat_t2);
f_reg(p_rst_i, p_clk_i, p_syn_rst_i, s_read_mat_t2, s_read_mat_t3);
f_reg(p_rst_i, p_clk_i, p_syn_rst_i, s_read_mat_t3, s_read_mat_t4);
f_reg(p_rst_i, p_clk_i, p_syn_rst_i, s_read_mat_t4, s_read_mat_t5);

p_ytrain_wren_o <= p_write_ytrain_i AND p_new_data_i;
p_ytrain_data_o <= p_data_i;
p_ytrain_wraddress_o <= STD_LOGIC_VECTOR(s_ix.col);

----------------------------------------------------------------------------------------------------
--  Prozesse
----------------------------------------------------------------------------------------------------

--proc_dbg_msg : PROCESS(p_new_data_i)
--BEGIN
--    IF p_new_data_i = '1' THEN
--        REPORT infomsg("Access Mat: Received Byte: " & to_hex(p_data_i));
--    END IF;
--END PROCESS proc_dbg_msg;

proc_last : PROCESS(p_rst_i, p_clk_i)
BEGIN
    IF p_rst_i = '1' THEN
        s_last <= '0';
    ELSIF RISING_EDGE(p_clk_i) THEN
        IF p_syn_rst_i = '1' THEN
            s_last <= '0';
        ELSIF s_finished_t1 = '1' AND s_send = '1' THEN
            s_last <= '1';
        END IF;
    END IF;
END PROCESS proc_last;

proc_store_elem : PROCESS(p_rst_i, p_clk_i)
BEGIN
    IF p_rst_i = '1' THEN
        s_elem_reg <= to_mat_elem(0.0);
    ELSIF RISING_EDGE(p_clk_i) THEN
        IF p_syn_rst_i = '1' THEN
            s_elem_reg <= to_mat_elem(0.0);
        ELSIF p_new_data_i = '1' THEN
            s_elem_reg <= s_elem;
        END IF;
    END IF;
END PROCESS proc_store_elem;

proc_first : PROCESS(p_rst_i, p_clk_i, p_syn_rst_i, p_new_data_i)
BEGIN
    IF p_rst_i = '1' THEN
       s_first_elem <= '1';
    ELSIF RISING_EDGE(p_clk_i) THEN
        IF p_syn_rst_i = '1' THEN
            s_first_elem <= '1';
        ELSIF p_new_data_i = '1' THEN
            s_first_elem <= '0';
        END IF;
    END IF;
END PROCESS proc_first;

proc_read_word : PROCESS(s_word_ix, p_word_i)
BEGIN
    p_data_o <= (OTHERS => '-');
    
    FOR i IN 31 DOWNTO 0 LOOP
        IF RESIZE(s_word_ix mod 32, 5) = TO_UNSIGNED( i, 5) THEN
            p_data_o <= to_slv(p_word_i(i));
        END IF;
    END LOOP;
END PROCESS proc_read_word;

END ARCHITECTURE a_access_mat;