----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.04.2018 11:29:21
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
  Port (clk_in : in STD_LOGIC;
        red : out STD_LOGIC_VECTOR(3 downto 0);
        green : out STD_LOGIC_VECTOR(3 downto 0);
        blue : out STD_LOGIC_VECTOR(3 downto 0);
        hsync, vsync : out STD_LOGIC);
end top;

architecture Behavioral of top is
  component clk_wiz_0
port(clk_out1 : out std_logic;
   clk_in1 : in std_logic);
end component;
   signal clk_out: std_logic;
   
component vga
   port(clk_in : in STD_LOGIC;
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

component ball 
    port(clk_in : in STD_LOGIC;
         red : out STD_LOGIC_VECTOR(3 downto 0);
         green : out STD_LOGIC_VECTOR(3 downto 0);
         blue : out STD_LOGIC_VECTOR(3 downto 0);
         hcount : in std_logic_vector (9 downto 0);
         vcount : in std_logic_vector (9 downto 0));
    end component;
    
signal red_out : STD_LOGIC_VECTOR(3 downto 0);
signal green_out : STD_LOGIC_VECTOR(3 downto 0);
signal blue_out : STD_LOGIC_VECTOR(3 downto 0);

begin
A1: clk_wiz_0 port map( 
    clk_out, clk_in);

A2: vga port map(
    clk_out,
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
    
A3: ball port map(
    clk_out,
    red_out,
    green_out,
    blue_out,
    hcount_out,
    vcount_out);
end Behavioral;
