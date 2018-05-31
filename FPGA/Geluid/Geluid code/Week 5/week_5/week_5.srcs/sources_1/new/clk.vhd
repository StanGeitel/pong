library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;

entity clk is port (
    clk100MHz : in STD_LOGIC;
    clkPWM : out STD_LOGIC);
end clk;

architecture Behavioral of clk is

component clk_wiz_0 port(
    clk_in1 : in STD_LOGIC;
    clk_out1 : out STD_LOGIC);
end component;

begin

clk1 : clk_wiz_0 port map(
    clk_in1 => clk100MHz,
    clk_out1 => clkPWM);

end Behavioral;
