library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Servomotor is
    Port (  clk : in STD_LOGIC;
            Pini: in STD_LOGIC;
            Pfin : in STD_LOGIC;
            Inc : in STD_LOGIC;
            Dec : in STD_LOGIC;
            control : out STD_LOGIC;
				control2 : out STD_LOGIC);
end Servomotor;

architecture Behavioral of Servomotor is
    component divisor is
        Port (  clk : in std_logic;
                div_clk : out std_logic);
    end component;

    component PWM is
        Port (  Reloj : in STD_LOGIC;
                D : in STD_LOGIC_VECTOR (7 downto 0);
                S : out STD_LOGIC);
    end component;
	 
	 component servo is
			Port (
				reloj : in STD_LOGIC;
            Pini : in STD_LOGIC;
            Pfin : in STD_LOGIC;
            Inc : in STD_LOGIC;
            Dec : in STD_LOGIC;
				ancho : out STD_LOGIC_VECTOR (7 downto 0));
	 end component;
	 
    signal reloj : STD_LOGIC;
	 signal ancho1 : STD_LOGIC_VECTOR (7 downto 0) := X"0F";
	 signal ancho2 : STD_LOGIC_VECTOR (7 downto 0) := X"0F";
begin
    U1: divisor port map (clk, reloj);
    U2: PWM port map (reloj, ancho1, control);
	 U3: PWM port map (reloj, ancho2, control2);
	 U4: servo port map (reloj, Pini, Pfin, Inc, Dec, ancho1);
	 U5: servo port map (reloj, Pini, Pfin, Inc, Dec, ancho2);

 
end Behavioral;
