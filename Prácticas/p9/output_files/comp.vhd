library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity comp is
	port( clk : IN STD_LOGIC;
			estadoDS : IN STD_LOGIC_VECTOR(3 downto 0);
			foquitos : out std_logic_vector(7 downto 0);
			wire_rx : IN STD_LOGIC);
end entity;

architecture Behavioral of comp is
    component RX is
        Port ( CLK : IN STD_LOGIC;
					LEDS : OUT STD_LOGIC_VECTOR(7 downto 0);
					RX_WIRE : IN STD_LOGIC);
    end component;
	 
	 component leds is
		Port( CLK : in std_logic;
				led1 : out  STD_LOGIC;            
				led2 : out  STD_LOGIC;            
				led3 : out  STD_LOGIC;            
				led4 : out  STD_LOGIC;
				led5 : out  STD_LOGIC;
				led6 : out  STD_LOGIC;
				led7 : out  STD_LOGIC;
				led8 : out  STD_LOGIC);
	end component;
	
	component clk2Hz is
        port( clk    : in  STD_LOGIC;
				  reset  : in  STD_LOGIC;
              clk_out: out STD_LOGIC);
    end component;

    component contador_v1 is
        port (clk    : IN  STD_LOGIC;
              cnt_out: OUT STD_LOGIC_VECTOR(3 DOWNTO 0));
    end component;
	
	 signal esDP : STD_LOGIC_VECTOR(7 downto 0);
	 signal ld1 : STD_LOGIC;
	 signal ld2 : STD_LOGIC;
	 signal ld3 : STD_LOGIC;
	 signal ld4 : STD_LOGIC;
	 signal ld5 : STD_LOGIC;
	 signal ld6 : STD_LOGIC;
	 signal ld7 : STD_LOGIC;
	 signal ld8 : STD_LOGIC;
	 signal lpwm1 : STD_LOGIC;
	 signal lpwm2 : STD_LOGIC;
	 signal lpwm3 : STD_LOGIC;
	 signal lpwm4 : STD_LOGIC;
	 signal con : std_logic_vector(3 downto 0);
	 signal clk_tmp: STD_LOGIC := '0';
begin
	R1 : RX port map (clk,esDP,wire_rx);
	L1 : leds port map (clk,ld1,ld2,ld3,ld4,ld5,ld6,ld7,ld8);
	L2 : leds port map (clk,lpwm1,lpwm2,lpwm3,lpwm4);
	clk2Hz_i: clk2Hz PORT MAP(clk, '0', clk_tmp);
   contador_v1_i: contador_v1 PORT MAP(clk_tmp, con);
	
	process(esDP)
	begin
	if(esDP = "00110001") then
		foquitos(0) <= ld1;
		foquitos(1) <= ld2;
		foquitos(2) <= ld3;
		foquitos(3) <= ld4;
		foquitos(4) <= ld5;
		foquitos(5) <= ld6;
		foquitos(6) <= ld7;
		foquitos(7) <= ld8;
	elsif(esDP = "00110010") then
		foquitos(0) <= estadoDS(0); 
		foquitos(1) <= estadoDS(1);
		foquitos(2) <= estadoDS(2);
		foquitos(3) <= estadoDS(3);
		foquitos(4) <= '0';
		foquitos(5) <= '0';
		foquitos(6) <= '0';
		foquitos(7) <= '0';
	elsif(esDP = "00110011") then
		foquitos(0) <= con(0);
		foquitos(1) <= con(1);
		foquitos(2) <= con(2);
		foquitos(3) <= con(3);
		foquitos(4) <= '0';
		foquitos(5) <= '0';
		foquitos(6) <= '0';
		foquitos(7) <= '0';
	elsif(esDP = "00110100") then
		foquitos(0) <= lpwm1;
		foquitos(1) <= lpwm2;
		foquitos(2) <= lpwm3;
		foquitos(3) <= lpwm4;
		foquitos(4) <= '0';
		foquitos(5) <= '0';
		foquitos(6) <= '0';
		foquitos(7) <= '0';	
	end if;
	end process;
end Behavioral;