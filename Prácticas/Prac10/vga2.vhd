library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vga is
	port(	clk50MHz : in std_logic;
			red : out std_logic_vector(3 downto 0);
			green : out std_logic_vector(3 downto 0);
			blue : out std_logic_vector(3 downto 0);
			h_sync : out std_logic;
			v_sync : out std_logic);
end entity vga;

architecture behaivoral of vga is
	signal reloj_pixel : std_logic;
	signal display_ena : std_logic;
	signal column : integer;
	signal row : integer;
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
begin
	reloj_pixe: process(clk50MHz) is
	begin
		if(rising_edge(clk50MHz)) then
			reloj_pixel <= NOT(reloj_pixel);
		end if;
	end process reloj_pixe; --25mhz
	
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
	
	generador_imagen: process(display_ena, row, column)
	begin
			if(row > 300 and row < 350) and (column > 400 and column < 450)) then
				red <= (others => '1');
				green <= (others => '0');
				blue <= (others => '0');
			elsif ((row > 300 and row < 350) and (column > 450 and column < 500)) then
				red <= (others => '0');
				green <= (others => '1');
				blue <= (others => '0');
			elsif ((row > 300 and row < 350) and (column > 550 and column < 600)) then
				red <= (others => '0');
				green <= (others => '0');
				blue <= (others => '1');
			else
				red <= (others => '0');
				green <= (others => '0');
				blue <= (others => '0');
			end if;
		else
			red <= (others => '0');
			green <= (others => '0');
			blue <= (others => '0');
		end if;
	end process generador_imagen;
	
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
end architecture behaivoral;