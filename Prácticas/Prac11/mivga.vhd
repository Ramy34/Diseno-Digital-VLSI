library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mivga is
	port( clk50MHz : in std_logic;
			red : out std_logic_vector(3 downto 0);
			green : out std_logic_vector(3 downto 0);
			blue : out std_logic_vector(3 downto 0);
			h_sync : out std_logic;
			v_sync : out std_logic;
			dipsw : in std_logic_vector(3 downto 0);
			a,b,c,d,e,f,g : out std_logic);
end entity mivga;

architecture behaivoral of mivga is
	constant cero : std_logic_vector(6 downto 0):="1000000";
	constant uno : std_logic_vector(6 downto 0):="1111001";
	constant dos : std_logic_vector(6 downto 0):="0100100";
	constant tres : std_logic_vector(6 downto 0):="0110000";
	constant cuatro: std_logic_vector(6 downto 0):="0011001";
	constant cinco : std_logic_vector(6 downto 0):="0010010";
	constant seis : std_logic_vector(6 downto 0):="0000010";
	constant siete : std_logic_vector(6 downto 0):="1111000";
	constant ocho : std_logic_vector(6 downto 0):="0000000";
	constant nueve : std_logic_vector(6 downto 0):="0011000";
	constant r1 : std_logic_vector(3 downto 0):=(others => '1');
	constant r0 : std_logic_vector(3 downto 0):=(others => '0');
	constant g1 : std_logic_vector(3 downto 0):=(others => '1');
	constant g0 : std_logic_vector(3 downto 0):=(others => '0');
	constant b1 : std_logic_vector(3 downto 0):=(others => '1');
	constant b0 : std_logic_vector(3 downto 0):=(others => '0');
	signal conectornum : std_logic_vector(6 downto 0);
	signal row : integer;
	signal column : integer;
	signal reloj_pixel : std_logic;
	signal display_ena : std_logic;
	constant h_pulse : integer := 96;
	constant h_bp : integer := 48;
	constant h_pixels : integer := 640;
	constant h_fp : integer := 16;
	constant v_pulse : integer := 2;
	constant v_bp : integer := 33;
	constant v_pixels : integer := 480;
	constant v_fp : integer := 10;
	signal h_period : integer := h_pulse + h_bp + h_pixels + h_fp;
	signal v_period : integer := v_pulse + v_bp + v_pixels + v_fp;
	signal h_count : integer range 0 to h_period -1 := 0;
	signal v_count : integer range 0 to v_period -1 := 0;
	signal clk_out : STD_LOGIC;
	signal temporal: STD_LOGIC;
	signal contador: integer range 0 to 12499999 := 0;
	signal color : integer range 0 to 6 :=0;
	
	signal colorT: std_logic_vector(11 downto 0);
	signal colorx: std_logic_vector(11 downto 0);
	signal colorA : std_logic_vector(11 downto 0);
	signal colorB : std_logic_vector(11 downto 0);
	signal colorC : std_logic_vector(11 downto 0);
	signal ColorD : std_logic_vector(11 downto 0);
	Signal ColorE : std_logic_vector(11 downto 0);
	signal colorF : std_logic_vector(11 downto 0);
	Signal colorG : std_logic_vector(11 downto 0);
	--Colores B G R
	constant azul : std_logic_vector(11 downto 0) := "111100000000";
	constant verde : std_logic_vector(11 downto 0) := "000011110000";
	constant rojo : std_logic_vector(11 downto 0) := "000000001111";
	constant blanco : std_logic_vector(11 downto 0) := "111111111111";
	constant turquesa : std_logic_vector(11 downto 0) := "111111110000";
	constant amarillo : std_logic_vector(11 downto 0) := "000011111111";
	constant morado : std_logic_vector(11 downto 0) := "111100001111";
	constant negro : std_logic_vector(11 downto 0) := "000000000000";
begin

	reloj_pixe: process(clk50MHz) is
	begin
		if(rising_edge(clk50MHz)) then
			reloj_pixel <= NOT(reloj_pixel);
		end if;
	end process reloj_pixe; --25mhz
	
	divisor_frecuencia: process (clk50MHz) begin
		if rising_edge(clk50MHz) then
			if (contador = 12499999) then
				temporal <= NOT(temporal);
				contador <= 0;
			else
				contador <= contador + 1;
			end if;
		end if;
	end process divisor_frecuencia;
	clk_out <= temporal;
	
	
	
	cambiar_color: process(clk_out)
	begin
		if(rising_edge(clk_out)) then
			if(color = 6) then
				color <= 0;
			else
				color <= color + 1;
			end if;
		end if;
	end process cambiar_color;
	
	
	
	contadores: process (reloj_pixel)
	begin
		if(rising_edge(reloj_pixel)) then
			if(h_count <(h_period - 1)) then
				h_count <= h_count + 1;
			else
				h_count <= 0;
				if(v_count < (v_period - 1)) then
					v_count <= v_count + 1;
				else
					v_count <= 0;
				end if;
			end if;
		end if;
	end process contadores;
	
	senial_hsync: process(reloj_pixel)
	begin
		if(rising_edge(reloj_pixel)) then
			if h_count > (h_pixels +h_fp) or h_count > (h_pixels + h_fp + h_pulse) then
				h_sync <= '0';
			else
				h_sync <= '1';
			end if;
		end if;
	end process senial_hsync;
	
	senial_vsync: process(reloj_pixel)
	begin
		if(rising_edge(reloj_pixel)) then
			if v_count > (v_pixels + v_fp) or v_count > (v_pixels + v_fp + v_pulse) then
				v_sync <= '0';
			else
				v_sync <= '1';
			end if;
		end if;
	end process senial_vsync;
	
	coords_pixel: process(reloj_pixel)
	begin
		if(rising_edge(reloj_pixel)) then
			if(h_count < h_pixels) then
				column <= h_count;
			end if;
			if(v_count < v_pixels) then
				row <= v_count;
			end if;
		end if;
	end process coords_pixel;
	
	display_enable: process(reloj_pixel)
	begin
		if(rising_edge(reloj_pixel)) then
			if(h_count < h_pixels and v_count < v_pixels) then
				display_ena <= '1';
			else
				display_ena <= '0';
			end if;
		end if;
	end process display_enable;
	
	with dipsw select conectornum <=
		"1000000" when "0000",
		"1111001" when "0001",
		"0100100" when "0010",
		"0110000" when "0011",
		"0011001" when "0100",
		"0010010" when "0101",
		"0000010" when "0110",
		"1111000" when "0111",
		"0000000" when "1000",
		"0011000" when "1001",
		"1111111" when others;
	
	with color select colorA <=
		azul when 0,
		verde when 1,
		rojo when 2,
		blanco when 3,
		turquesa when 4,
		amarillo when 5,
		morado when 6,
		negro when others;
	
	with color select colorB <=
		morado when 0,
		azul when 1,
		verde when 2,
		rojo when 3,
		blanco when 4,
		turquesa	when 5,
		amarillo when 6,
		negro when others;
		
	with color select colorC <=
		amarillo when 0,
		morado when 1,
		azul when 2,
		verde when 3,
		rojo when 4,
		blanco	when 5,
		turquesa when 6,
		negro when others;
	
	with color select colorD <=
		turquesa when 0,
		amarillo when 1,
		morado when 2,
		azul when 3,
		verde when 4,
		rojo when 5,
		blanco when 6,
		negro when others;
		
	with color select colorE <=
		blanco when 0,
		turquesa when 1,
		amarillo when 2,
		morado when 3,
		azul when 4,
		verde when 5,
		rojo when 6,
		negro when others;
		
	with color select colorF <=
		rojo when 0,
		blanco when 1,
		turquesa when 2,
		amarillo when 3,
		morado when 4,
		azul when 5,
		verde when 6,
		negro when others;
		
	with color select colorG <=
		verde when 0,
		rojo when 1,
		blanco when 2,
		turquesa when 3,
		amarillo when 4,
		morado when 5,
		azul when 6,
		negro when others;
		
	generador_imagen: process(display_ena, row, column,conectornum)
	begin
		if(display_ena = '1') then
			case conectornum is
				when cero =>
						if((row > 200 and row < 210) and (column > 110 and column < 140)) then  --A
						red(3) <= colorA(0);
						red(2) <= colorA(1);
						red(1) <= colorA(2);
						red(0) <= colorA(3);
						green(3) <= colorA(4);
						green(2) <= colorA(5);
						green(1) <= colorA(6);
						green(0) <= colorA(7);
						blue(3) <= colorA(8);
						blue(2) <= colorA(9);
						blue(1) <= colorA(10);
						blue(0) <= colorA(11);
					elsif((row > 210 and row < 240) and (column > 140 and column < 150)) then --B
						red(3) <= colorB(0);
						red(2) <= colorB(1);
						red(1) <= colorB(2);
						red(0) <= colorB(3);
						green(3) <= colorB(4);
						green(2) <= colorB(5);
						green(1) <= colorB(6);
						green(0) <= colorB(7);
						blue(3) <= colorB(8);
						blue(2) <= colorB(9);
						blue(1) <= colorB(10);
						blue(0) <= colorB(11);
					elsif((row > 250 and row < 280) and (column > 140 and column < 150)) then --C
						red(3) <= colorC(0);
						red(2) <= colorC(1);
						red(1) <= colorC(2);
						red(0) <= colorC(3);
						green(3) <= colorC(4);
						green(2) <= colorC(5);
						green(1) <= colorC(6);
						green(0) <= colorC(7);
						blue(3) <= colorC(8);
						blue(2) <= colorC(9);
						blue(1) <= colorC(10);
						blue(0) <= colorC(11);
					elsif((row > 280 and row < 290) and (column > 110 and column < 140)) then --D
						red(3) <= colorD(0);
						red(2) <= colorD(1);
						red(1) <= colorD(2);
						red(0) <= colorD(3);
						green(3) <= colorD(4);
						green(2) <= colorD(5);
						green(1) <= colorD(6);
						green(0) <= colorD(7);
						blue(3) <= colorD(8);
						blue(2) <= colorD(9);
						blue(1) <= colorD(10);
						blue(0) <= colorD(11);
					elsif((row > 250 and row < 280) and (column > 100 and column < 110)) then --E
						red(3) <= colorE(0);
						red(2) <= colorE(1);
						red(1) <= colorE(2);
						red(0) <= colorE(3);
						green(3) <= colorE(4);
						green(2) <= colorE(5);
						green(1) <= colorE(6);
						green(0) <= colorE(7);
						blue(3) <= colorE(8);
						blue(2) <= colorE(9);
						blue(1) <= colorE(10);
						blue(0) <= colorE(11);
					elsif((row > 210 and row < 240) and (column > 100 and column < 110)) then --F
						red(3) <= colorF(0);
						red(2) <= colorF(1);
						red(1) <= colorF(2);
						red(0) <= colorF(3);
						green(3) <= colorF(4);
						green(2) <= colorF(5);
						green(1) <= colorF(6);
						green(0) <= colorF(7);
						blue(3) <= colorF(8);
						blue(2) <= colorF(9);
						blue(1) <= colorF(10);
						blue(0) <= colorF(11);
					else
						red <= (others => '0');
						green <= (others => '0');
						blue <= (others => '0');
					end if;
				when uno =>
					if((row > 210 and row < 240) and (column > 140 and column < 150)) then --B
						red(3) <= colorB(0);
						red(2) <= colorB(1);
						red(1) <= colorB(2);
						red(0) <= colorB(3);
						green(3) <= colorB(4);
						green(2) <= colorB(5);
						green(1) <= colorB(6);
						green(0) <= colorB(7);
						blue(3) <= colorB(8);
						blue(2) <= colorB(9);
						blue(1) <= colorB(10);
						blue(0) <= colorB(11);
					elsif((row > 250 and row < 280) and (column > 140 and column < 150)) then --C
						red(3) <= colorC(0);
						red(2) <= colorC(1);
						red(1) <= colorC(2);
						red(0) <= colorC(3);
						green(3) <= colorC(4);
						green(2) <= colorC(5);
						green(1) <= colorC(6);
						green(0) <= colorC(7);
						blue(3) <= colorC(8);
						blue(2) <= colorC(9);
						blue(1) <= colorC(10);
						blue(0) <= colorC(11);
					else
						red <= (others => '0');
						green <= (others => '0');
						blue <= (others => '0');
					end if;
				when dos =>
					if((row > 200 and row < 210) and (column > 110 and column < 140)) then  --A
						red(3) <= colorA(0);
						red(2) <= colorA(1);
						red(1) <= colorA(2);
						red(0) <= colorA(3);
						green(3) <= colorA(4);
						green(2) <= colorA(5);
						green(1) <= colorA(6);
						green(0) <= colorA(7);
						blue(3) <= colorA(8);
						blue(2) <= colorA(9);
						blue(1) <= colorA(10);
						blue(0) <= colorA(11);
					elsif((row > 210 and row < 240) and (column > 140 and column < 150)) then --B
						red(3) <= colorB(0);
						red(2) <= colorB(1);
						red(1) <= colorB(2);
						red(0) <= colorB(3);
						green(3) <= colorB(4);
						green(2) <= colorB(5);
						green(1) <= colorB(6);
						green(0) <= colorB(7);
						blue(3) <= colorB(8);
						blue(2) <= colorB(9);
						blue(1) <= colorB(10);
						blue(0) <= colorB(11);
					elsif((row > 280 and row < 290) and (column > 110 and column < 140)) then --D
						red(3) <= colorD(0);
						red(2) <= colorD(1);
						red(1) <= colorD(2);
						red(0) <= colorD(3);
						green(3) <= colorD(4);
						green(2) <= colorD(5);
						green(1) <= colorD(6);
						green(0) <= colorD(7);
						blue(3) <= colorD(8);
						blue(2) <= colorD(9);
						blue(1) <= colorD(10);
						blue(0) <= colorD(11);
					elsif((row > 250 and row < 280) and (column > 100 and column < 110)) then --E
						red(3) <= colorE(0);
						red(2) <= colorE(1);
						red(1) <= colorE(2);
						red(0) <= colorE(3);
						green(3) <= colorE(4);
						green(2) <= colorE(5);
						green(1) <= colorE(6);
						green(0) <= colorE(7);
						blue(3) <= colorE(8);
						blue(2) <= colorE(9);
						blue(1) <= colorE(10);
						blue(0) <= colorE(11);
					elsif((row > 240 and row < 250) and (column > 110 and column < 140)) then --G
						red(3) <= colorG(0);
						red(2) <= colorG(1);
						red(1) <= colorG(2);
						red(0) <= colorG(3);
						green(3) <= colorG(4);
						green(2) <= colorG(5);
						green(1) <= colorG(6);
						green(0) <= colorG(7);
						blue(3) <= colorG(8);
						blue(2) <= colorG(9);
						blue(1) <= colorG(10);
						blue(0) <= colorG(11);
					else
						red <= (others => '0');
						green <= (others => '0');
						blue <= (others => '0');
					end if;
				when tres =>
					if((row > 200 and row < 210) and (column > 110 and column < 140)) then  --A
						red(3) <= colorA(0);
						red(2) <= colorA(1);
						red(1) <= colorA(2);
						red(0) <= colorA(3);
						green(3) <= colorA(4);
						green(2) <= colorA(5);
						green(1) <= colorA(6);
						green(0) <= colorA(7);
						blue(3) <= colorA(8);
						blue(2) <= colorA(9);
						blue(1) <= colorA(10);
						blue(0) <= colorA(11);
					elsif((row > 210 and row < 240) and (column > 140 and column < 150)) then --B
						red(3) <= colorB(0);
						red(2) <= colorB(1);
						red(1) <= colorB(2);
						red(0) <= colorB(3);
						green(3) <= colorB(4);
						green(2) <= colorB(5);
						green(1) <= colorB(6);
						green(0) <= colorB(7);
						blue(3) <= colorB(8);
						blue(2) <= colorB(9);
						blue(1) <= colorB(10);
						blue(0) <= colorB(11);
					elsif((row > 250 and row < 280) and (column > 140 and column < 150)) then --C
						red(3) <= colorC(0);
						red(2) <= colorC(1);
						red(1) <= colorC(2);
						red(0) <= colorC(3);
						green(3) <= colorC(4);
						green(2) <= colorC(5);
						green(1) <= colorC(6);
						green(0) <= colorC(7);
						blue(3) <= colorC(8);
						blue(2) <= colorC(9);
						blue(1) <= colorC(10);
						blue(0) <= colorC(11);
					elsif((row > 280 and row < 290) and (column > 110 and column < 140)) then --D
						red(3) <= colorD(0);
						red(2) <= colorD(1);
						red(1) <= colorD(2);
						red(0) <= colorD(3);
						green(3) <= colorD(4);
						green(2) <= colorD(5);
						green(1) <= colorD(6);
						green(0) <= colorD(7);
						blue(3) <= colorD(8);
						blue(2) <= colorD(9);
						blue(1) <= colorD(10);
						blue(0) <= colorD(11);
					elsif((row > 240 and row < 250) and (column > 110 and column < 140)) then --G
						red(3) <= colorG(0);
						red(2) <= colorG(1);
						red(1) <= colorG(2);
						red(0) <= colorG(3);
						green(3) <= colorG(4);
						green(2) <= colorG(5);
						green(1) <= colorG(6);
						green(0) <= colorG(7);
						blue(3) <= colorG(8);
						blue(2) <= colorG(9);
						blue(1) <= colorG(10);
						blue(0) <= colorG(11);
					else
						red <= (others => '0');
						green <= (others => '0');
						blue <= (others => '0');
					end if;
				when cuatro =>
					if((row > 210 and row < 240) and (column > 140 and column < 150)) then --B
						red(3) <= colorB(0);
						red(2) <= colorB(1);
						red(1) <= colorB(2);
						red(0) <= colorB(3);
						green(3) <= colorB(4);
						green(2) <= colorB(5);
						green(1) <= colorB(6);
						green(0) <= colorB(7);
						blue(3) <= colorB(8);
						blue(2) <= colorB(9);
						blue(1) <= colorB(10);
						blue(0) <= colorB(11);
					elsif((row > 250 and row < 280) and (column > 140 and column < 150)) then --C
						red(3) <= colorC(0);
						red(2) <= colorC(1);
						red(1) <= colorC(2);
						red(0) <= colorC(3);
						green(3) <= colorC(4);
						green(2) <= colorC(5);
						green(1) <= colorC(6);
						green(0) <= colorC(7);
						blue(3) <= colorC(8);
						blue(2) <= colorC(9);
						blue(1) <= colorC(10);
						blue(0) <= colorC(11);
					elsif((row > 210 and row < 240) and (column > 100 and column < 110)) then --F
						red(3) <= colorF(0);
						red(2) <= colorF(1);
						red(1) <= colorF(2);
						red(0) <= colorF(3);
						green(3) <= colorF(4);
						green(2) <= colorF(5);
						green(1) <= colorF(6);
						green(0) <= colorF(7);
						blue(3) <= colorF(8);
						blue(2) <= colorF(9);
						blue(1) <= colorF(10);
						blue(0) <= colorF(11);
					elsif((row > 240 and row < 250) and (column > 110 and column < 140)) then --G
						red(3) <= colorG(0);
						red(2) <= colorG(1);
						red(1) <= colorG(2);
						red(0) <= colorG(3);
						green(3) <= colorG(4);
						green(2) <= colorG(5);
						green(1) <= colorG(6);
						green(0) <= colorG(7);
						blue(3) <= colorG(8);
						blue(2) <= colorG(9);
						blue(1) <= colorG(10);
						blue(0) <= colorG(11);
					else
						red <= (others => '0');
						green <= (others => '0');
						blue <= (others => '0');
					end if;
				when cinco =>
					if((row > 200 and row < 210) and (column > 110 and column < 140)) then  --A
						red(3) <= colorA(0);
						red(2) <= colorA(1);
						red(1) <= colorA(2);
						red(0) <= colorA(3);
						green(3) <= colorA(4);
						green(2) <= colorA(5);
						green(1) <= colorA(6);
						green(0) <= colorA(7);
						blue(3) <= colorA(8);
						blue(2) <= colorA(9);
						blue(1) <= colorA(10);
						blue(0) <= colorA(11);
					elsif((row > 250 and row < 280) and (column > 140 and column < 150)) then --C
						red(3) <= colorC(0);
						red(2) <= colorC(1);
						red(1) <= colorC(2);
						red(0) <= colorC(3);
						green(3) <= colorC(4);
						green(2) <= colorC(5);
						green(1) <= colorC(6);
						green(0) <= colorC(7);
						blue(3) <= colorC(8);
						blue(2) <= colorC(9);
						blue(1) <= colorC(10);
						blue(0) <= colorC(11);
					elsif((row > 280 and row < 290) and (column > 110 and column < 140)) then --D
						red(3) <= colorD(0);
						red(2) <= colorD(1);
						red(1) <= colorD(2);
						red(0) <= colorD(3);
						green(3) <= colorD(4);
						green(2) <= colorD(5);
						green(1) <= colorD(6);
						green(0) <= colorD(7);
						blue(3) <= colorD(8);
						blue(2) <= colorD(9);
						blue(1) <= colorD(10);
						blue(0) <= colorD(11);
					elsif((row > 210 and row < 240) and (column > 100 and column < 110)) then --F
						red(3) <= colorF(0);
						red(2) <= colorF(1);
						red(1) <= colorF(2);
						red(0) <= colorF(3);
						green(3) <= colorF(4);
						green(2) <= colorF(5);
						green(1) <= colorF(6);
						green(0) <= colorF(7);
						blue(3) <= colorF(8);
						blue(2) <= colorF(9);
						blue(1) <= colorF(10);
						blue(0) <= colorF(11);
					elsif((row > 240 and row < 250) and (column > 110 and column < 140)) then --G
						red(3) <= colorG(0);
						red(2) <= colorG(1);
						red(1) <= colorG(2);
						red(0) <= colorG(3);
						green(3) <= colorG(4);
						green(2) <= colorG(5);
						green(1) <= colorG(6);
						green(0) <= colorG(7);
						blue(3) <= colorG(8);
						blue(2) <= colorG(9);
						blue(1) <= colorG(10);
						blue(0) <= colorG(11);
					else
						red <= (others => '0');
						green <= (others => '0');
						blue <= (others => '0');
					end if;
				when seis =>
					if((row > 200 and row < 210) and (column > 110 and column < 140)) then  --A
						red(3) <= colorA(0);
						red(2) <= colorA(1);
						red(1) <= colorA(2);
						red(0) <= colorA(3);
						green(3) <= colorA(4);
						green(2) <= colorA(5);
						green(1) <= colorA(6);
						green(0) <= colorA(7);
						blue(3) <= colorA(8);
						blue(2) <= colorA(9);
						blue(1) <= colorA(10);
						blue(0) <= colorA(11);
					elsif((row > 250 and row < 280) and (column > 140 and column < 150)) then --C
						red(3) <= colorC(0);
						red(2) <= colorC(1);
						red(1) <= colorC(2);
						red(0) <= colorC(3);
						green(3) <= colorC(4);
						green(2) <= colorC(5);
						green(1) <= colorC(6);
						green(0) <= colorC(7);
						blue(3) <= colorC(8);
						blue(2) <= colorC(9);
						blue(1) <= colorC(10);
						blue(0) <= colorC(11);
					elsif((row > 280 and row < 290) and (column > 110 and column < 140)) then --D
						red(3) <= colorD(0);
						red(2) <= colorD(1);
						red(1) <= colorD(2);
						red(0) <= colorD(3);
						green(3) <= colorD(4);
						green(2) <= colorD(5);
						green(1) <= colorD(6);
						green(0) <= colorD(7);
						blue(3) <= colorD(8);
						blue(2) <= colorD(9);
						blue(1) <= colorD(10);
						blue(0) <= colorD(11);
					elsif((row > 250 and row < 280) and (column > 100 and column < 110)) then --E
						red(3) <= colorE(0);
						red(2) <= colorE(1);
						red(1) <= colorE(2);
						red(0) <= colorE(3);
						green(3) <= colorE(4);
						green(2) <= colorE(5);
						green(1) <= colorE(6);
						green(0) <= colorE(7);
						blue(3) <= colorE(8);
						blue(2) <= colorE(9);
						blue(1) <= colorE(10);
						blue(0) <= colorE(11);
					elsif((row > 210 and row < 240) and (column > 100 and column < 110)) then --F
						red(3) <= colorF(0);
						red(2) <= colorF(1);
						red(1) <= colorF(2);
						red(0) <= colorF(3);
						green(3) <= colorF(4);
						green(2) <= colorF(5);
						green(1) <= colorF(6);
						green(0) <= colorF(7);
						blue(3) <= colorF(8);
						blue(2) <= colorF(9);
						blue(1) <= colorF(10);
						blue(0) <= colorF(11);
					elsif((row > 240 and row < 250) and (column > 110 and column < 140)) then --G
						red(3) <= colorG(0);
						red(2) <= colorG(1);
						red(1) <= colorG(2);
						red(0) <= colorG(3);
						green(3) <= colorG(4);
						green(2) <= colorG(5);
						green(1) <= colorG(6);
						green(0) <= colorG(7);
						blue(3) <= colorG(8);
						blue(2) <= colorG(9);
						blue(1) <= colorG(10);
						blue(0) <= colorG(11);
					else
						red <= (others => '0');
						green <= (others => '0');
						blue <= (others => '0');
					end if;
				when siete =>
					if((row > 200 and row < 210) and (column > 110 and column < 140)) then  --A
						red(3) <= colorA(0);
						red(2) <= colorA(1);
						red(1) <= colorA(2);
						red(0) <= colorA(3);
						green(3) <= colorA(4);
						green(2) <= colorA(5);
						green(1) <= colorA(6);
						green(0) <= colorA(7);
						blue(3) <= colorA(8);
						blue(2) <= colorA(9);
						blue(1) <= colorA(10);
						blue(0) <= colorA(11);
					elsif((row > 210 and row < 240) and (column > 140 and column < 150)) then --B
						red(3) <= colorB(0);
						red(2) <= colorB(1);
						red(1) <= colorB(2);
						red(0) <= colorB(3);
						green(3) <= colorB(4);
						green(2) <= colorB(5);
						green(1) <= colorB(6);
						green(0) <= colorB(7);
						blue(3) <= colorB(8);
						blue(2) <= colorB(9);
						blue(1) <= colorB(10);
						blue(0) <= colorB(11);
					elsif((row > 250 and row < 280) and (column > 140 and column < 150)) then --C
						red(3) <= colorC(0);
						red(2) <= colorC(1);
						red(1) <= colorC(2);
						red(0) <= colorC(3);
						green(3) <= colorC(4);
						green(2) <= colorC(5);
						green(1) <= colorC(6);
						green(0) <= colorC(7);
						blue(3) <= colorC(8);
						blue(2) <= colorC(9);
						blue(1) <= colorC(10);
						blue(0) <= colorC(11);
					else
						red <= (others => '0');
						green <= (others => '0');
						blue <= (others => '0');
					end if;
				when ocho =>
					if((row > 200 and row < 210) and (column > 110 and column < 140)) then  --A
						red(3) <= colorA(0);
						red(2) <= colorA(1);
						red(1) <= colorA(2);
						red(0) <= colorA(3);
						green(3) <= colorA(4);
						green(2) <= colorA(5);
						green(1) <= colorA(6);
						green(0) <= colorA(7);
						blue(3) <= colorA(8);
						blue(2) <= colorA(9);
						blue(1) <= colorA(10);
						blue(0) <= colorA(11);
					elsif((row > 210 and row < 240) and (column > 140 and column < 150)) then --B
						red(3) <= colorB(0);
						red(2) <= colorB(1);
						red(1) <= colorB(2);
						red(0) <= colorB(3);
						green(3) <= colorB(4);
						green(2) <= colorB(5);
						green(1) <= colorB(6);
						green(0) <= colorB(7);
						blue(3) <= colorB(8);
						blue(2) <= colorB(9);
						blue(1) <= colorB(10);
						blue(0) <= colorB(11);
					elsif((row > 250 and row < 280) and (column > 140 and column < 150)) then --C
						red(3) <= colorC(0);
						red(2) <= colorC(1);
						red(1) <= colorC(2);
						red(0) <= colorC(3);
						green(3) <= colorC(4);
						green(2) <= colorC(5);
						green(1) <= colorC(6);
						green(0) <= colorC(7);
						blue(3) <= colorC(8);
						blue(2) <= colorC(9);
						blue(1) <= colorC(10);
						blue(0) <= colorC(11);
					elsif((row > 280 and row < 290) and (column > 110 and column < 140)) then --D
						red(3) <= colorD(0);
						red(2) <= colorD(1);
						red(1) <= colorD(2);
						red(0) <= colorD(3);
						green(3) <= colorD(4);
						green(2) <= colorD(5);
						green(1) <= colorD(6);
						green(0) <= colorD(7);
						blue(3) <= colorD(8);
						blue(2) <= colorD(9);
						blue(1) <= colorD(10);
						blue(0) <= colorD(11);
					elsif((row > 250 and row < 280) and (column > 100 and column < 110)) then --E
						red(3) <= colorE(0);
						red(2) <= colorE(1);
						red(1) <= colorE(2);
						red(0) <= colorE(3);
						green(3) <= colorE(4);
						green(2) <= colorE(5);
						green(1) <= colorE(6);
						green(0) <= colorE(7);
						blue(3) <= colorE(8);
						blue(2) <= colorE(9);
						blue(1) <= colorE(10);
						blue(0) <= colorE(11);
					elsif((row > 210 and row < 240) and (column > 100 and column < 110)) then --F
						red(3) <= colorF(0);
						red(2) <= colorF(1);
						red(1) <= colorF(2);
						red(0) <= colorF(3);
						green(3) <= colorF(4);
						green(2) <= colorF(5);
						green(1) <= colorF(6);
						green(0) <= colorF(7);
						blue(3) <= colorF(8);
						blue(2) <= colorF(9);
						blue(1) <= colorF(10);
						blue(0) <= colorF(11);
					elsif((row > 240 and row < 250) and (column > 110 and column < 140)) then --G
						red(3) <= colorG(0);
						red(2) <= colorG(1);
						red(1) <= colorG(2);
						red(0) <= colorG(3);
						green(3) <= colorG(4);
						green(2) <= colorG(5);
						green(1) <= colorG(6);
						green(0) <= colorG(7);
						blue(3) <= colorG(8);
						blue(2) <= colorG(9);
						blue(1) <= colorG(10);
						blue(0) <= colorG(11);
					else
						red <= (others => '0');
						green <= (others => '0');
						blue <= (others => '0');
					end if;
				when nueve =>
					if((row > 200 and row < 210) and (column > 110 and column < 140)) then  --A
						red(3) <= colorA(0);
						red(2) <= colorA(1);
						red(1) <= colorA(2);
						red(0) <= colorA(3);
						green(3) <= colorA(4);
						green(2) <= colorA(5);
						green(1) <= colorA(6);
						green(0) <= colorA(7);
						blue(3) <= colorA(8);
						blue(2) <= colorA(9);
						blue(1) <= colorA(10);
						blue(0) <= colorA(11);
					elsif((row > 210 and row < 240) and (column > 140 and column < 150)) then --B
						red(3) <= colorB(0);
						red(2) <= colorB(1);
						red(1) <= colorB(2);
						red(0) <= colorB(3);
						green(3) <= colorB(4);
						green(2) <= colorB(5);
						green(1) <= colorB(6);
						green(0) <= colorB(7);
						blue(3) <= colorB(8);
						blue(2) <= colorB(9);
						blue(1) <= colorB(10);
						blue(0) <= colorB(11);
					elsif((row > 250 and row < 280) and (column > 140 and column < 150)) then --C
						red(3) <= colorC(0);
						red(2) <= colorC(1);
						red(1) <= colorC(2);
						red(0) <= colorC(3);
						green(3) <= colorC(4);
						green(2) <= colorC(5);
						green(1) <= colorC(6);
						green(0) <= colorC(7);
						blue(3) <= colorC(8);
						blue(2) <= colorC(9);
						blue(1) <= colorC(10);
						blue(0) <= colorC(11);
					elsif((row > 210 and row < 240) and (column > 100 and column < 110)) then --F
						red(3) <= colorF(0);
						red(2) <= colorF(1);
						red(1) <= colorF(2);
						red(0) <= colorF(3);
						green(3) <= colorF(4);
						green(2) <= colorF(5);
						green(1) <= colorF(6);
						green(0) <= colorF(7);
						blue(3) <= colorF(8);
						blue(2) <= colorF(9);
						blue(1) <= colorF(10);
						blue(0) <= colorF(11);
					elsif((row > 240 and row < 250) and (column > 110 and column < 140)) then --G
						red(3) <= colorG(0);
						red(2) <= colorG(1);
						red(1) <= colorG(2);
						red(0) <= colorG(3);
						green(3) <= colorG(4);
						green(2) <= colorG(5);
						green(1) <= colorG(6);
						green(0) <= colorG(7);
						blue(3) <= colorG(8);
						blue(2) <= colorG(9);
						blue(1) <= colorG(10);
						blue(0) <= colorG(11);
					else
						red <= (others => '0');
						green <= (others => '0');
						blue <= (others => '0');
					end if;
				when others =>
						red <= (others => '0');
						green <= (others => '0');
						blue <= (others => '0');
			end case;
		end if;
	end process generador_imagen;
	
	display:process(conectornum)
	begin
		a <= conectornum(0);
		b <= conectornum(1);
		c <= conectornum(2);
		d <= conectornum(3);
		e <= conectornum(4);
		f <= conectornum(5);
		g <= conectornum(6);
	end process display;
end architecture behaivoral;