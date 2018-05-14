library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;
--use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity image is port( 
    clk25MHz : in STD_LOGIC; -- Stond eerst op 100MHz. Vragen aan Jasper, zou dat werken? In principe is het namelijk asynchroon
    h_count, v_count : in STD_LOGIC_VECTOR(9 downto 0);
    red, green, blue : out STD_LOGIC_VECTOR(3 downto 0));
end image;

architecture Behavioral of image is

signal defaultColor : STD_LOGIC_VECTOR(3 downto 0) := "0000";

begin 

process(clk25MHz)
begin
    if rising_edge(clk25MHz) then
    end if;
end process;

end Behavioral;