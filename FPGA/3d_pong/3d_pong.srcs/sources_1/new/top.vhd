library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;

entity top is port ( 
    clk100MHz : in STD_LOGIC; -- W5
    clkSPI : in STD_LOGIC;
    dataSPI : STD_LOGIC);
end top;

architecture Behavioral of top is

component clk port(
    clk100MHz : in STD_LOGIC;
    clkSPI : in STD_LOGIC;
    edge : out STD_LOGIC);
end component;

component spi port(
    clk100MHz : in STD_LOGIC;
    edge : out STD_LOGIC;
    dataSPI : in STD_LOGIC;
    new_frame_ready : buffer STD_LOGIC;
    rx_data : out STD_LOGIC_VECTOR(16 downto 0)); -- 16 hier gevuld maar is een generic
end component;

signal tmpedge : STD_LOGIC;

begin

clk1 : clk port map(
    clk100MHz => clk100MHz,
    clkSPI => clkSPI,
    edge => tmpedge);
 
end Behavioral;
