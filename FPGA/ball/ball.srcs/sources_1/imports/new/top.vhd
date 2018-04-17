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
           red, green, blue : out std_logic_vector(3 downto 0);
           hsync, vsync : out std_logic);
end top;

architecture Behavioral of top is

component clk_wiz_0 
    port( clk_in1 : in std_logic;
          clk_out1 : out std_logic);
end component clk_wiz_0;

component VGA is
    Port ( clk25 : in STD_LOGIC;
           en : out std_logic;
           x_ball : out integer range 144 to 783;
           y_ball : out integer range 31 to 510;
           h_count : out integer range 0 to 800;
           v_count : out integer range 0 to 521;
           hsync, vsync : out STD_LOGIC);
end component VGA;

component image is
    Port ( clk25 : in std_logic;
           en : in std_logic;
           x_ball : in integer range 144 to 783;
           y_ball : in integer range 31 to 510;
           h_count : in integer range 0 to 800;
           v_count : in integer range 0 to 521;
           red, green, blue : out  std_logic_vector(3 downto 0));
end component image;

signal en, pixel_clk : std_logic;
signal x_ball : integer range 144 to 783;
signal y_ball : integer range 31 to 510;
signal h_count : integer range 0 to 800;
signal v_count : integer range 0 to 521; 

begin
    pll : clk_wiz_0 port map(clk_in1 => sys_clk, clk_out1 => pixel_clk);
    vga_con : VGA port map(clk25 => pixel_clk, en => en, x_ball => x_ball, y_ball => y_ball, h_count => h_count, v_count => v_count, hsync => hsync, vsync => vsync);
    ball : image port map(clk25 => pixel_clk, en => en, x_ball => x_ball, y_ball => y_ball, h_count => h_count, v_count => v_count, red => red, green => green, blue => blue);
    
end Behavioral;
