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
	signal colorr : std_logic_vector(3 downto 0):= "0000";
	signal colorg : std_logic_vector(3 downto 0):= "0000";
	signal colorb : std_logic_vector(3 downto 0):= "0000";
	signal color : integer range 0 to 8 :=0;
	signal clk_out : STD_LOGIC;
	signal temporal: STD_LOGIC;
	signal contador: integer range 0 to 999999 := 0;
	signal lim_ver_men : integer;
	signal lim_ver_may : integer;
	signal lim_hor_men : integer := 0;
	signal lim_hor_may : integer := 50;
	
begin
	reloj_pixe: process(clk50MHz) is
	begin
		if(rising_edge(clk50MHz)) then
			reloj_pixel <= NOT(reloj_pixel);
		end if;
	end process reloj_pixe; --25mhz
	
	divisor_frecuencia: process (clk50MHz) begin
		if rising_edge(clk50MHz) then
			if (contador = 999999) then
				temporal <= NOT(temporal);
				contador <= 0;
			else
				contador <= contador + 1;
			end if;
		end if;
	end process divisor_frecuencia;
	clk_out <= temporal;
	
	movimiento_horizontal: process(clk_out)
	begin
		if(rising_edge(clk_out))then
			lim_hor_may <= lim_hor_may + 1;
			lim_hor_men <= lim_hor_men + 1;
			if(lim_hor_may = 640) then
				lim_hor_may <= 0;
			end if;
			if (lim_hor_men = 480)then
				lim_hor_men <= 0;
			end if;
		end if;
	end process movimiento_horizontal;
	
	movimiento_vertical: process(clk_out)
	begin
		if(rising_edge(clk_out))then
			lim_ver_may <= lim_ver_may + 1;
			lim_ver_men <= lim_ver_men + 1;
			if(lim_ver_may = 480) then
				lim_ver_may <= 0;
			end if;
			if (lim_ver_men = 680)then
				lim_ver_men <= 0;
			end if;
		end if;
	end process movimiento_vertical;
	
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
		if(display_ena = '1') then
			if(row >= 100 and row <= 150) and (column >= 200 and column <= 250) then --Ojo derecho
				red <= colorr;
				green <= colorg;
				blue <= colorb;
			elsif(row >= 50 and row <= 100) and (column >= 350 and column <= 450) then --Ceja izquierda
				red <= colorr;
				green <= colorg;
				blue <= colorb;
			elsif(row >= 220 and row <= 270) and (column >= 300 and column <= 350) then --Nariz
				red <= colorr;
				green <= colorg;
				blue <= colorb;
			elsif((row >= 350 and row <= 400) and (column >= 250 and column <= 300)) then --Boca parte baja extremo derecho
				red <= colorr;
				green <= colorg;
				blue <= colorb;
			elsif((row >= 350 and row <= 400) and (column >= 300 and column <= 350)) then --Boca parte baja enmedio
				red <= colorr;
				green <= colorg;
				blue <= colorb;
			elsif((row >= 350 and row <= 400) and (column >= 350 and column <= 400)) then --Boca parte baja extremo izquierdo
				red <= colorr;
				green <= colorg;
				blue <= colorb;
			elsif((row >= 300 and row <= 350) and (column >= 400 and column <= 450)) then --Boca parte alta extremo izquierdo
				red <= colorr;
				green <= colorg;
				blue <= colorb;
			elsif((row >= 300 and row <= 350) and (column >= 200 and column <= 250)) then --Boca parte alta extremo derecho
				red <= colorr;
				green <= colorg;
				blue <= colorb;
			elsif((row >= 450 and row <= 500) and (column >= 150 and column <= 200)) then --Arcoiris color rojo
				red <= "1111";
				green <= "0000";
				blue <= "0000";
			elsif((row >= 450 and row <= 500) and (column >= 200 and column <= 250)) then --Arcoiris color naranja
				red <= "1111";
				green <= "1000";
				blue <= "0000";
			elsif((row >= 450 and row <= 500) and (column >= 250 and column <= 300)) then --Arcoiris color amarillo
				red <= "1111";
				green <= "1111";
				blue <= "0000";
			elsif((row >= 450 and row <= 500) and (column >= 300 and column <= 350)) then --Arcoiris color verde
				red <= "0000";
				green <= "1111";
				blue <= "0000";
			elsif((row >= 450 and row <= 500) and (column >= 350 and column <= 400)) then --Arcoiris color turquesa
				red <= "0000";
				green <= "1111";
				blue <= "1000";
			elsif((row >= 450 and row <= 500) and (column >= 400 and column <= 450)) then --Arcoiris color azul
				red <= "0000";
				green <= "0000";
				blue <= "1111";
			elsif((row >= 450 and row <= 500) and (column >= 450 and column <= 500)) then --Arcoiris color violeta
				red <= "1000";
				green <= "0000";
				blue <= "1111";
			elsif((row >= 400 and row <= 450) and (column >= lim_hor_men and column <= lim_hor_may)) then -- Cuadrito en movimiento
				red <= colorr;
				green <= colorg;
				blue <= colorb;
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
	
	cambiar_color: process(clk_out)
	begin
		if(rising_edge(clk_out)) then
			if (color = 9) then
				color <= 0;
			else
				color <= color + 1;
			end if;
		end if;
	end process cambiar_color;
	
	with (color) select
		colorr <= "0000" when 0, --negro
					 "1111" when 1, --rojo					 
					 "1111" when 2, --naranja					 
					 "1111" when 3, --amarillo
					 "0000" when 4, --verde
					 "0000" when 5, --turquesa
					 "0000" when 6, --azul
					 "1000" when 7, --violeta
					 "1111" when 8; --blanco
		with (color) select
		colorg <= "0000" when 0, --negro
					 "0000" when 1, --rojo
					 "1000" when 2, --naranja
					 "1111" when 3, --amarillo
					 "1111" when 4, --verde
					 "1111" when 5, --turquesa
					 "0000" when 6, --azul
					 "0000" when 7, --violeta
					 "1111" when 8; --blanco					 
			with (color) select
		colorb <= "0000" when 0, --negro 
					 "0000" when 1, --rojo
					 "0000" when 2, --naranja
					 "0000" when 3, --amarillo
					 "0000" when 4, --verde
					 "1000" when 5, --turquesa
					 "1111" when 6, --azul
					 "1111" when 7, --violeta
					 "1111" when 8; --blanco
end architecture behaivoral;