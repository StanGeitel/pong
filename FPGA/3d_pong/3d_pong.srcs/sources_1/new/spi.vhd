library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use ieee.STD_LOGIC_ARITH.ALL;
--use IEEE.NUMERIC_STD.ALL;

entity spi is generic(width : INTEGER := 16); port(
    clk100MHz : in STD_LOGIC;
    edge : in STD_LOGIC;
    dataSPI : in STD_LOGIC;
    new_frame_ready : buffer STD_LOGIC;
    rx_data : out STD_LOGIC_VECTOR(width - 1 downto 0)); -- eventueel een signal maken waarin data eerst wordt gezet en pas zodra een frame compleet is in output zetten
end spi;

architecture Behavioral of spi is

signal bit_number : INTEGER := 0;

begin
-- rekening houden met het feit dat er een aantal klokslagen zitten tussen het moment dat frame compleet is en wordt uitgelezen
process(clk100MHz) 
begin
    if(edge = '1') then
        rx_data(bit_number)  <= dataSPI; -- store data in buffer
        if (bit_number = 15) then 
            new_frame_ready <= '1'; -- set indication of new complete frame
            bit_number <= 0; -- reset bit number
        else
            bit_number <= bit_number + 1; 
        end if;
    end if;
end process;

process(clk100MHz) -- if data is accessed then the frame is not new anymore
begin
    --if(data_accessed = '1') then
    --    new_frame_ready <= '0';
    --end if;
end process;




end Behavioral;
