----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.02.2018 13:24:20
-- Design Name: 
-- Module Name: vga_clk - Behavioral
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

entity vga_clk is
    Port ( sys_clk : in STD_LOGIC;
           pixel_clk : out STD_LOGIC);
end vga_clk;

architecture Behavioral of vga_clk is

component clk_wiz_0 
    port( clk_in1 : in std_logic;
          clk_out1 : out std_logic);
end component clk_wiz_0;

begin
    clk : clk_wiz_0 port map(clk_in1 => sys_clk, clk_out1 => pixel_clk);

end Behavioral;
