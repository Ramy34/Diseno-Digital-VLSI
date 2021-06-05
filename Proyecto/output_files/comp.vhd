library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity comp is
	port( clk : IN STD_LOGIC;
			fu : out std_logic;
			fd : out std_logic;
			fl : out std_logic;
			fr : out std_logic;
			fstop: out std_logic;
			led : out std_logic_vector (4 downto 0);
			wire_rx : IN STD_LOGIC);
end entity;

architecture Behavioral of comp is
	signal LEDS : STD_LOGIC_VECTOR(7 downto 0);
	signal clk_tmp: STD_LOGIC := '0';
    
	 component RX is
        Port ( CLK : IN STD_LOGIC;
					LEDS : OUT STD_LOGIC_VECTOR(7 downto 0);
					RX_WIRE : IN STD_LOGIC);
    end component;
	
	component clk2Hz is
        port( clk    : in  STD_LOGIC;
				  reset  : in  STD_LOGIC;
              clk_out: out STD_LOGIC);
    end component;
	 
	 
begin
	R1 : RX port map (clk,LEDS,wire_rx);
	clk2Hz_i: clk2Hz PORT MAP(clk, '0', clk_tmp);
	
	process(clk_tmp)
	begin
	if(rising_edge(clk_tmp))then
		case(LEDS) is
		when "01000001" => --A
			fl <= '1';
			fr <= '0';
			fstop <= '0';
			led <= "01000";
		when "01010011" => --S
			fu <= '0';
			fd <= '1';
			fl <= '0';
			fr <= '0';
			fstop <= '0';
			led <= "00010";
		when "01000100" => --D
			fl <= '0';
			fr <= '1';
			fstop <= '0';
			led <= "00100";
		when "01010111" => --W
			fu <= '1';
			fd <= '0';
			fl <= '0';
			fr <= '0';
			fstop <= '0';
			led <= "10000";
		when "01000110" => --F
			fu <= '0';
			fd <= '0';
			fl <= '0';
			fr <= '0';
			fstop <= '1';
			led <= "00001";
		when others =>
			fu <= '0';
			fd <= '0';
			fl <= '0';
			fr <= '0';
			fstop <= '0';
			led <= "11111";
		end case;
	end if;
	end process;
	
end Behavioral;