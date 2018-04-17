----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.02.2018 16:28:56
-- Design Name: 
-- Module Name: top - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
    Port ( sys_clk : in std_logic;
           rs, gs, bs : in std_logic;
           rb, gb, bb : in std_logic;
           red, green, blue : out std_logic_vector(3 downto 0);
           hsync, vsync : out std_logic);
end top;

architecture Behavioral of top is
component vga_clk is
    port( sys_clk : in std_logic;
          pixel_clk : out std_logic);
end component vga_clk;

component VGA is
    Port ( clk25 : in STD_LOGIC;
           en : out std_logic;
           x_cor, y_cor : out std_logic_vector(9 downto 0);
           h_count, v_count : out std_logic_vector(9 downto 0);
           hsync, vsync : out STD_LOGIC);
end component VGA;

component image is
    Port ( clk25 : in std_logic;
           en : in std_logic;
           rs, gs, bs : in std_logic;
           rb, gb, bb : in std_logic;
           x, y : in std_logic_vector(9 downto 0);
           h_count, v_count : in std_logic_vector(9 downto 0);
           red, green, blue : out  std_logic_vector(3 downto 0));
end component image;

signal en, pixel_clk : std_logic;
signal x, y, hcount, vcount : std_logic_vector(9 downto 0); 

begin
    pll : vga_clk port map(sys_clk => sys_clk, pixel_clk => pixel_clk);
    vga_con : VGA port map(clk25 => pixel_clk, en => en, x_cor => x, y_cor => y, h_count => hcount, v_count => vcount, hsync => hsync, vsync => vsync);
    colors : image port map(clk25 => pixel_clk, en => en, rs => rs, gs => gs, bs => bs, rb => rb, gb => gb, bb => bb, x => x, y => y, h_count => hcount, v_count => vcount, red => red, green => green, blue => blue);
    
    
end Behavioral;
