library IEEE;
use IEEE.STD_LOGIC_1164.ALL; 
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Prac5 is
Generic ( N : integer := 24); 
Port	( reloj : in std_logic;
div_clk : out std_logic);
end Prac5;

architecture arqPrac5 of Prac5 is 
begin
	process (reloj)
	variable cuenta: std_logic_vector (27 downto 0) := X"0000000"; begin
	if rising_edge (reloj) then 
		cuenta := cuenta + 1;
	end if;
	div_clk <= cuenta (N); 
	end process;
end arqPrac5;
