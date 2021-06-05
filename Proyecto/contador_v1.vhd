library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity contador_v1 is
    PORT (
        clk    : IN  STD_LOGIC;
        cnt_out: OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
end contador_v1;

architecture Behavioral of contador_v1 is
    -- Señal temporal para el contador.
    signal cnt_tmp: STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
begin
    proceso_contador: process (clk) begin
        if rising_edge(clk) then
			if (cnt_tmp < "1001") then
            cnt_tmp <= cnt_tmp + 1;
			else
				cnt_tmp <= "0000";
			end if;
		end if;
    end process;

    cnt_out <= cnt_tmp;
end Behavioral;
