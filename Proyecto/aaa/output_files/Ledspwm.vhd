library IEEE; 
use IEEE.STD_LOGIC_1164.ALL; 
use IEEE.STD_LOGIC_ARITH.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL; 
 
entity Ledspwm is
     Port ( clk : in  STD_LOGIC;
	  led1 : out  STD_LOGIC;
	  led2 : out  STD_LOGIC;
	  led3 : out  STD_LOGIC;
	  led4 : out  STD_LOGIC);
end Ledspwm; 
 
architecture Behavioral of Ledspwm is
  component divisor is
	Generic ( N : integer := 24);
	Port ( reloj : in std_logic;
		div_clk : out std_logic);
  end component;  
  
  component PWM is
	Port ( Reloj : in  STD_LOGIC;
			D : in  STD_LOGIC_VECTOR (7 downto 0);
			S : out  STD_LOGIC);
			end component;
  
  signal relojPWM :STD_LOGIC;
  signal relojCiclo : STD_LOGIC;
  signal a1 : STD_LOGIC_VECTOR (7 downto 0) := X"08";
  signal a2 : STD_LOGIC_VECTOR (7 downto 0) := X"20";
  signal a3 : STD_LOGIC_VECTOR (7 downto 0) := X"60";
  signal a4 : STD_LOGIC_VECTOR (7 downto 0) := X"F8";
  begin
  
	R1: divisor generic map (10) port map (clk, relojPWM);
	R2: divisor generic map (23) port map (clk, relojCiclo);
	P1: PWM port map (relojPWM, a1, led1);
	P2: PWM port map (relojPWM, a2, led2);
	P3: PWM port map (relojPWM, a3, led3);
	P4: PWM port map (relojPWM, a4, led4); 
 
	process (relojCiclo)
	variable Cuenta : integer range 0 to 255 := 0;
	begin
		if relojCiclo='1' and relojCiclo'event then
			a1 <= a4;
			a2 <= a1;
			a3 <= a2;
			a4 <= a3;
		end if;
	end process;
end Behavioral;