library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;
--use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity image is port( 
    clk100MHz : in STD_LOGIC;
    enableVGA : in STD_LOGIC;
    h_count, v_count : in STD_LOGIC_VECTOR(9 downto 0);
    red, green, blue : out STD_LOGIC_VECTOR(3 downto 0));
end image;

architecture Behavioral of image is

signal defaultColor : STD_LOGIC_VECTOR(3 downto 0) := "0000";

begin 

process(clk100MHz)
begin
    if rising_edge(clk100MHz) then
        if enableVGA = '1' then
            red <= "1111";
            green <= defaultColor;
            blue <= defaultColor;
        else
            red <= defaultColor;
            green <= defaultColor;
            blue <= defaultColor;
        end if;
    end if;
end process;

end Behavioral;