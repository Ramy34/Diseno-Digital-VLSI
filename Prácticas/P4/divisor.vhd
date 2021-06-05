library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Divisor is
    Port (  clk : in std_logic;
            div_clk : out std_logic);
end Divisor;

architecture Behavioral of Divisor is
begin
    process (clk)
        constant N : integer := 11;
        variable cuenta: std_logic_vector (27 downto 0) := X"0000000";
    begin
        if rising_edge (clk) then
            cuenta := cuenta + 1;
        end if;
        div_clk <= cuenta (N);
    end process;
end Behavioral;

-- Periodo de la señal de salida en funcion del valor N para clk=50 MHz:
-- 27 ~ 5.37s, 26 ~ 2.68s, 25 ~ 1.34s, 24 ~ 671ms, 23 ~ 336 ms
-- 22 ~ 168 ms, 21 ~ 83.9 ms, 20 ~ 41.9 ms, 19 ~ 21 ms, 18 ~ 10.5 ms
-- 17 ~ 5.24 ms, 16 ~ 2.62 ms, 15 ~ 1.31 ms, 14 ~ 655 us, 13 ~ 328 us
-- 12 ~ 164 us, 11 ~ 81.9 us, 10 ~ 41 us, 9 ~ 20.5 us, 8 ~ 10.2 us
