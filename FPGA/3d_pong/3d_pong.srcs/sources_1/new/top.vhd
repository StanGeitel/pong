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

component vga
   port(clk_25MHz : in STD_LOGIC;
       red : out STD_LOGIC_VECTOR(3 downto 0);
       green : out STD_LOGIC_VECTOR(3 downto 0);
       blue : out STD_LOGIC_VECTOR(3 downto 0);
       hsync, vsync : out  STD_LOGIC;
       red_in : in STD_LOGIC_VECTOR(3 downto 0);
       green_in : in STD_LOGIC_VECTOR(3 downto 0);
       blue_in : in STD_LOGIC_VECTOR(3 downto 0);
       hcount_out : out STD_LOGIC_VECTOR(9 downto 0);
       vcount_out : out STD_LOGIC_VECTOR(9 downto 0));
       end component;
       
signal hcount_out, vcount_out: std_logic_vector(9 downto 0);

component image 
    port(clk_25MHz : in STD_LOGIC;
         red : out STD_LOGIC_VECTOR(3 downto 0);
         green : out STD_LOGIC_VECTOR(3 downto 0);
         blue : out STD_LOGIC_VECTOR(3 downto 0);
         hcount : in std_logic_vector (9 downto 0);
         vcount : in std_logic_vector (9 downto 0));
    end component;
    
signal red_out : STD_LOGIC_VECTOR(3 downto 0);
signal green_out : STD_LOGIC_VECTOR(3 downto 0);
signal blue_out : STD_LOGIC_VECTOR(3 downto 0);

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
    tmpclkVGA,
    red,
    green,
    blue,
    hsync,
    vsync,
    red_out,
    green_out,
    blue_out,
    hcount_out,
    vcount_out);
    
image1 : image port map(
    tmpclkVGA,
    red_out,
    green_out,
    blue_out,
    hcount_out,
    vcount_out);

end Behavioral;
