library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;

entity top is port ( 
    clk100MHz : in STD_LOGIC; -- W5
    clkSPI : in STD_LOGIC;
    dataSPI : in STD_LOGIC;
    hsync : out STD_LOGIC;
    vsync : out STD_LOGIC;
    red, green, blue : out STD_LOGIC_VECTOR (3 downto 0));
end top;

architecture Behavioral of top is

component clk port(
    clk100MHz : in STD_LOGIC;
    clkSPI : in STD_LOGIC;
    edge : out STD_LOGIC;
    clkVGA : out STD_LOGIC);
end component;

component spi port(
    clk100MHz : in STD_LOGIC;
    edge : in STD_LOGIC;
    dataSPI : in STD_LOGIC;
    new_frame_ready : buffer STD_LOGIC;
    rx_data : out STD_LOGIC_VECTOR(16 downto 0));
end component;

component vga is port( 	
    clkVGA : in STD_LOGIC;
    red_in, green_in, blue_in : in STD_LOGIC_VECTOR(3 downto 0);
    h_count, v_count : out STD_LOGIC_VECTOR(9 downto 0);
    hsync, vsync : out STD_LOGIC;
    red, green, blue : out STD_LOGIC_VECTOR(3 downto 0));
end component;

component image is port( 
    clk25MHz : in STD_LOGIC;
    h_count, v_count : in STD_LOGIC_VECTOR(9 downto 0);
    red, green, blue : out STD_LOGIC_VECTOR(3 downto 0));
end component;

signal tmpedge : STD_LOGIC;
signal tmpclkVGA : STD_LOGIC;
signal tmpnew_frame_ready : STD_LOGIC;
signal frame : STD_LOGIC_VECTOR(16 downto 0);
signal tmphcount,tmpvcount : STD_LOGIC_VECTOR(9 downto 0);
signal tmpred, tmpblue, tmpgreen : STD_LOGIC_VECTOR(3 downto 0);

begin

clk1 : clk port map(
    clk100MHz => clk100MHz,
    clkSPI => clkSPI,
    edge => tmpedge,
    clkVGA => tmpclkVGA);

spi1 : spi port map(
    clk100MHz => clk100MHz,
    edge => tmpedge,
    dataSPI => dataSPI,
    new_frame_ready => tmpnew_frame_ready,
    rx_data => frame);
    
vga1 : vga port map(
    clkVGA => tmpclkVGA,
    red_in => tmpred,
    green_in => tmpgreen,
    blue_in => tmpblue,
    h_count => tmphcount,
    v_count => tmpvcount,
    hsync => hsync,
    vsync => vsync,
    red => red,
    green => green,
    blue => blue);
    
image1 : image port map(
    clk25MHz => tmpclkVGA,
    h_count => tmphcount,
    v_count => tmpvcount,
    red => tmpred,
    green => tmpgreen, 
    blue => tmpblue);

end Behavioral;
