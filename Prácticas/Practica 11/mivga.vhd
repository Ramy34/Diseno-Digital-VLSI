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
		
	generador_imagen: process(display_ena, row, column,conectornum)
	begin
		if(display_ena = '1') then
			case conectornum is
				when uno =>
					if((row > 210 and row < 240) and (column > 140 and column < 150)) then --B
						red <= (others => '0');
						green <= (others => '1');
						blue <= (others => '0');
					elsif((row > 250 and row < 280) and (column > 140 and column < 150)) then --C
						red <= (others => '1');
						green <= (others => '0');
						blue <= (others => '0');
					else
						red <= (others => '0');
						green <= (others => '0');
						blue <= (others => '0');
					end if;
				when dos =>
					if((row > 200 and row < 210) and (column > 110 and column < 140)) then  --A
						red <= (others => '0');
						green <= (others => '0');
						blue <= (others => '1');
					elsif((row > 210 and row < 240) and (column > 140 and column < 150)) then --B
						red <= (others => '0');
						green <= (others => '1');
						blue <= (others => '0');
					elsif((row > 280 and row < 290) and (column > 110 and column < 140)) then --D
						red <= (others => '1');
						green <= (others => '1');
						blue <= (others => '1');
					elsif((row > 250 and row < 280) and (column > 100 and column < 110)) then --E
						red <= (others => '0');
						green <= (others => '1');
						blue <= (others => '1');
					elsif((row > 240 and row < 250) and (column > 110 and column < 140)) then --G
						red <= (others => '1');
						green <= (others => '0');
						blue <= (others => '1');
					else
						red <= (others => '0');
						green <= (others => '0');
						blue <= (others => '0');
					end if;
				when nueve =>
					if((row > 200 and row < 210) and (column > 110 and column < 140)) then  --A
						red <= (others => '0');
						green <= (others => '0');
						blue <= (others => '1');
					elsif((row > 210 and row < 240) and (column > 140 and column < 150)) then --B
						red <= (others => '0');
						green <= (others => '1');
						blue <= (others => '0');
					elsif((row > 250 and row < 280) and (column > 140 and column < 150)) then --C
						red <= (others => '1');
						green <= (others => '0');
						blue <= (others => '0');
					elsif((row > 210 and row < 240) and (column > 100 and column < 110)) then --F
						red <= (others => '1');
						green <= (others => '1');
						blue <= (others => '0');
					elsif((row > 240 and row < 250) and (column > 110 and column < 140)) then --G
						red <= (others => '1');
						green <= (others => '0');
						blue <= (others => '1');
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
end architecture behaivoral;