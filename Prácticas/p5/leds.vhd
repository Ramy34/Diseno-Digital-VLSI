library IEEE; 
use IEEE.STD_LOGIC_1164.ALL; 
use IEEE.STD_LOGIC_ARITH.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL; 
 
entity Leds is     
	Port ( clk : in  STD_LOGIC;            
		   led1 : out  STD_LOGIC;            
		   led2 : out  STD_LOGIC;            
		   led3 : out  STD_LOGIC;            
		   led4 : out  STD_LOGIC;
			led5 : out  STD_LOGIC;
			led6 : out  STD_LOGIC;
			led7 : out  STD_LOGIC;
			led8 : out  STD_LOGIC); 
end Leds; 
 
architecture Behavioral of Leds is  
	component divisor is   
		Generic ( N : integer := 24);   
		Port ( clk : in std_logic;     
		       div_clk : out std_logic);  
	end component;  
	component PWM is   
		Port ( Reloj : in  STD_LOGIC;     
			   D : in  STD_LOGIC_VECTOR (7 downto 0);     
			   S : out  STD_LOGIC);  
	end component;  
	signal relojPWM : STD_LOGIC;  
	signal relojCiclo : STD_LOGIC;  
	signal a1 : STD_LOGIC_VECTOR (7 downto 0) := X"08";  
	signal a2 : STD_LOGIC_VECTOR (7 downto 0) := X"20";  
	signal a3 : STD_LOGIC_VECTOR (7 downto 0) := X"60";  
	signal a4 : STD_LOGIC_VECTOR (7 downto 0) := X"ff";
	signal a5 : STD_LOGIC_VECTOR (7 downto 0) := X"00";
	signal a6 : STD_LOGIC_VECTOR (7 downto 0) := X"00";
	signal a7 : STD_LOGIC_VECTOR (7 downto 0) := X"00";
	signal a8 : STD_LOGIC_VECTOR (7 downto 0) := X"00";
	signal vuelta : integer range 0 to 255 := 0;
begin  
	R1: divisor generic map (10) port map (clk, relojPWM);
	R2: divisor generic map (23) port map (clk, relojCiclo);  
	P1: PWM port map (relojPWM, a1, led1);  
	P2: PWM port map (relojPWM, a2, led2);  
	P3: PWM port map (relojPWM, a3, led3);  
	P4: PWM port map (relojPWM, a4, led4); 
	P5: PWM port map (relojPWM, a5, led5); 
	P6: PWM port map (relojPWM, a6, led6); 
	P7: PWM port map (relojPWM, a7, led7); 
	P8: PWM port map (relojPWM, a8, led8); 

	process (relojCiclo,vuelta)    
		variable Cuenta : integer range 0 to 255 := 0;
	begin  
		if relojCiclo='1' and relojCiclo'event then
			if vuelta < 4 then
				a1 <= a8;    
				a2 <= a1;    
				a3 <= a2;    
				a4 <= a3;
				a5 <= a4;
				a6 <= a5;
				a7 <= a6;
				a8 <= a7;
				vuelta <= vuelta + 1;
			else
			   a1 <= a2;
			   a2 <= a3;
			   a3 <= a4;
			   a4 <= a5;
				a5 <= a6;
				a6 <= a7;
				a7 <= a8;
				a8 <= a1;
				vuelta <= vuelta + 1;
				if vuelta > 6  then
					vuelta <= 0;
				end if;
			end if;
		end if;  
	end process; 
end Behavioral;