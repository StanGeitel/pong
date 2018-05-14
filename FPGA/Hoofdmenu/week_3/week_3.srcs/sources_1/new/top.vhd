library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--use IEEE.STD_LOGIC_UNSIGNED.ALL;
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is port( 
    clk100MHz : in STD_LOGIC;
    red, green, blue : out STD_LOGIC_VECTOR (3 downto 0);
    hsync, vsync : out  STD_LOGIC;
    button : in STD_LOGIC);
end top;

architecture Behavioral of top is

component clk_wiz_0 port( 
    clk_in1 : in STD_LOGIC;
    clk_out1 : out STD_LOGIC);
end component;
                           
component vga port( 
    clk25MHz : in STD_LOGIC;
    red, green, blue : out  STD_LOGIC_VECTOR (3 downto 0);
    hsync, vsync : out  STD_LOGIC;
    button : in STD_LOGIC);
end component;

signal tmpclk25MHz : STD_LOGIC;
signal count : STD_LOGIC_VECTOR (16 downto 0);

begin

clk1 : clk_wiz_0 port map( 
    clk_in1 => clk100MHz,
    clk_out1 => tmpclk25MHz);

vga1 : vga port map(
    clk25MHz => tmpclk25MHz,
    red => red, 
    green => green, 
    blue=> blue,
    hsync => hsync,
    vsync => vsync,
    button => button); 
    
end Behavioral;
