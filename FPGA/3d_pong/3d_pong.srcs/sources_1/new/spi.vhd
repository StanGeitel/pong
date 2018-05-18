library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use ieee.STD_LOGIC_ARITH.ALL;
--use IEEE.NUMERIC_STD.ALL;

entity spi is port(
    clk25MHz : in STD_LOGIC;
    edge : in STD_LOGIC;
    dataSPI : in STD_LOGIC;
    wea : out STD_LOGIC_VECTOR(0 downto 0);
    addra : out STD_LOGIC_VECTOR(3 downto 0);
    dina : out STD_LOGIC_VECTOR(9 downto 0));
end spi;

architecture Behavioral of spi is

signal bit_number : INTEGER := 0;
signal new_frame_ready : STD_LOGIC;
signal frame : STD_LOGIC_VECTOR(15 downto 0);
signal tmpwea : STD_LOGIC_VECTOR(0 downto 0) := "1";

begin

wea <= tmpwea;
-- rekening houden met het feit dat er een aantal klokslagen zitten tussen het moment dat frame compleet is en wordt uitgelezen
process(clk25MHz) -- ook op 25MHz, kan dat? 
begin
    if (edge = '1') then
        frame(bit_number)  <= dataSPI; -- store data in buffer
        if (bit_number = 15) then 
            new_frame_ready <= '1';-- set indication of new complete frame
            bit_number <= 0; -- reset bit number
        else
            bit_number <= bit_number + 1; 
        end if;
    end if;
    
    if (new_frame_ready = '1' and falling_edge(clk25MHz)) then
        addra <= frame(13 downto 10); -- afhankelijk van wat gestuurd wordt
        dina <= frame(9 downto 0); -- afhankelijk van wat gestuurd wordt
        tmpwea <= "0";
        new_frame_ready <= '0';
    end if;
    
    if (tmpwea = "0" and falling_edge(clk25MHz)) then
        tmpwea <= "1";
    end if;
    
end process;

end Behavioral;
