----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.03.2018 00:26:25
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
    Port ( clk : in std_logic;
           segments : out std_logic_vector(6 downto 0);
           dp : out std_logic;
           anodes : out std_logic_vector(3 downto 0));
end top;

architecture Behavioral of top is
component Seven_segments
    Port ( clk : in std_logic;
           segments : out std_logic_vector(6 downto 0);
           dp : out std_logic;
           anodes : out std_logic_vector(3 downto 0));
end component Seven_segments;

begin

snake_led : Seven_segments port map(clk => clk, segments => segments, dp => dp, anodes => anodes);

end Behavioral;
