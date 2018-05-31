library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;

entity top is port (
    clk100MHz : in STD_LOGIC; -- W5
    PWM : out STD_LOGIC); -- A14 / JB1
end top;

architecture Behavioral of top is

component clk port(
    clk100MHz : in STD_LOGIC;
    clkPWM : out STD_LOGIC);
end component;

component rom port(
    clk : in STD_LOGIC;
    adres : in STD_LOGIC_VECTOR(9 downto 0);
    data : out STD_LOGIC_VECTOR(7 downto 0));
end component;

component demodulatie port(
    clk : in STD_LOGIC;
    data : in STD_LOGIC_VECTOR(7 downto 0);
    adres : out STD_LOGIC_VECTOR(9 downto 0);
    pwm : out STD_LOGIC);
end component;

signal tmpclkPWM : STD_LOGIC;
signal tmpadres : STD_LOGIC_VECTOR(9 downto 0);
signal tmpdata : STD_LOGIC_VECTOR(7 downto 0);

begin

clk1 : clk port map(
    clk100MHz => clk100MHz,
    clkPWM => tmpclkPWM);
    
rom1 : rom port map(
    clk => tmpclkPWM,
    adres => tmpadres,
    data => tmpdata);
    
demodulatie1 : demodulatie port map(
    clk => tmpclkPWM,
    data => tmpdata,
    adres => tmpadres,
    PWM => PWM);

end Behavioral;
