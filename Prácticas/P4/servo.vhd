library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity servo is
	Port (
			reloj : in STD_LOGIC;
            Pini : in STD_LOGIC;
            Pfin : in STD_LOGIC;
            Inc : in STD_LOGIC;
            Dec : in STD_LOGIC;
            --control : out STD_LOGIC;
			ancho : out STD_LOGIC_VECTOR (7 downto 0));
end servo;

architecture Behavorial of servo is
begin
	process (reloj, Pini, Pfin, Inc, Dec)
    begin
        if reloj='1' and reloj'event then
            if cuenta>0 then
                cuenta := cuenta -1;
            else
                if Pini='1' then
                    valor := X"0D";
                elsif Pfin='1' then
                    valor := X"18";
                elsif Inc='1' and valor<X"18" then
                    valor := valor + 1;
                elsif Dec='1' and valor>X"0D" then
                    valor := valor - 1;
                end if;
                cuenta := 1023;
                ancho <= valor;
            end if;
        end if;
    end process;
end Behavorial;
