library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity RX is
	port( CLK : IN STD_LOGIC;
			LEDS : OUT STD_LOGIC_VECTOR(7 downto 0);
			RX_WIRE : IN STD_LOGIC);
end entity;

architecture behaivoral of RX is
	signal BUFF : STD_LOGIC_VECTOR(9 downto 0);
	signal FLAG : STD_LOGIC := '0';
	signal PRE : INTEGER range 0 to 5208 :=0;
	signal INDICE : INTEGER range 0 to 9 :=0;
	signal PRE_VAL : INTEGER range 0 to 41600;
	signal BAUD : STD_LOGIC_VECTOR(2 downto 0);
	
begin
	RX_dato : process(CLK)
	begin
	if(CLK'EVENT and CLK = '1') then
		if(FLAG = '0' and RX_WIRE = '0') then
			FLAG <= '1';
			INDICE <= 0;
			PRE <= 0;
		end if;
		if(FLAG = '1') then
			BUFF(INDICE) <= RX_WIRE;
			if(PRE < PRE_VAL) then
				PRE <= PRE + 1;
			else
				PRE <= 0;
			end if;
			if(PRE = PRE_VAL/2) then
				if(INDICE < 9) then
					INDICE <= INDICE + 1;
				else
					if(BUFF(0) = '0' and BUFF(9) = '1') then
						LEDS <= BUFF(8 downto 1);
					else
						LEDS <= "00000000";
					end if;
					FLAG <= '0';
				end if;
			end if;
		end if;
	end if;
	end process RX_dato;
	
	BAUD <= "011";
	with(BAUD) select
		PRE_VAL <=  41600 when "000", -- 1200 bauds
						20800 when "001", -- 2400 bauds
						10400 when "010", -- 4800 bauds
						5200 when "011", -- 9600 bauds
						2600 when "100", -- 19200 bauds
						1300 when "101", -- 38400 bauds
						866 when "110", -- 57600 bauds
						432 when others; --115200 bauds
end architecture behaivoral;