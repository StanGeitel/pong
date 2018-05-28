library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

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
    clk25MHz : in STD_LOGIC;
    edge : in STD_LOGIC;
    dataSPI : in STD_LOGIC;
    wea : out STD_LOGIC_VECTOR(0 downto 0);
    addra : out STD_LOGIC_VECTOR(3 downto 0);
    dina : out STD_LOGIC_VECTOR(9 downto 0));
end component;

component vga port(
    clk25MHz : in STD_LOGIC;
    red, green, blue : out STD_LOGIC_VECTOR(3 downto 0);
    hsync, vsync : out  STD_LOGIC;
    red_in, green_in, blue_in : in STD_LOGIC_VECTOR(3 downto 0);
    hcount_out, vcount_out : out STD_LOGIC_VECTOR(9 downto 0));
end component;

component image port(
    clk25MHz : in STD_LOGIC;
    data_ram : in STD_LOGIC_VECTOR(9 downto 0);
    addr_ram : out STD_LOGIC_VECTOR(3 downto 0);
    hcount, vcount : in STD_LOGIC_VECTOR (9 downto 0);
    red, green, blue : out STD_LOGIC_VECTOR(3 downto 0));
end component;

component memory port (
    clk25MHz : in STD_LOGIC;
    addra, addra2 : in STD_LOGIC_VECTOR(3 downto 0);
    dina, dina2 : in STD_LOGIC_VECTOR(9 downto 0);
    addr_img : in STD_LOGIC_VECTOR(3 downto 0);
    wea, wea2 : in STD_LOGIC_VECTOR(0 downto 0);
    data_out, data_out2 : out STD_LOGIC_VECTOR(9 downto 0));
end component;

signal hcount_out, vcount_out: STD_LOGIC_VECTOR(9 downto 0);
signal tmpedge : STD_LOGIC;
signal tmpclkVGA : STD_LOGIC;
signal tmphcount,tmpvcount : STD_LOGIC_VECTOR(9 downto 0);
signal tmpred, tmpblue, tmpgreen : STD_LOGIC_VECTOR(3 downto 0);
signal tmpaddra, tmpaddra2, tmpaddr_img : STD_LOGIC_VECTOR(3 downto 0);
signal tmpdina, tmpdina2, tmpdata_out, tmpdata_out2 : STD_LOGIC_VECTOR(9 downto 0);
signal tmpwea, tmpwea2 : STD_LOGIC_VECTOR(0 downto 0);

begin

clk1 : clk port map(
    clk100MHz => clk100MHz,
    clkSPI => clkSPI,
    edge => tmpedge,
    clkVGA => tmpclkVGA);

spi1 : spi port map(
    clk25MHz => tmpclkVGA,
    edge => tmpedge,
    dataSPI => dataSPI,
    wea => tmpwea,
    addra => tmpaddra,
    dina => tmpdina);
    
vga1 : vga port map(
    clk25MHz => tmpclkVGA,
    red_in => tmpred,
    green_in => tmpgreen, 
    blue_in => tmpblue,
    hsync => hsync,
    vsync => vsync,
    red => red,
    green => green,
    blue => blue,
    hcount_out => hcount_out,
    vcount_out => vcount_out);
    
image1 : image port map(    
    clk25MHz => tmpclkVGA,
    data_ram => tmpdata_out,
    addr_ram => tmpaddr_img,
    hcount => hcount_out,
    vcount => vcount_out,
    red => tmpred,
    green => tmpgreen,
    blue => tmpblue);

memory1 : memory port map(    
    clk25MHz => tmpclkVGA,
    addra => tmpaddra, 
    addra2 => tmpaddra2,
    dina2 => tmpdina2,
    dina => tmpdina,
    addr_img => tmpaddr_img,
    wea => tmpwea,
    wea2 => tmpwea2,
    data_out2 => tmpdata_out2,
    data_out => tmpdata_out);
    
end Behavioral;
