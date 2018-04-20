library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;

entity clk is port (
    clk100MHz : in STD_LOGIC;
    clkSPI : in STD_LOGIC;
    edge : out STD_LOGIC);
end clk;

architecture Behavioral of clk is

signal Q1, Q2, Q3 : STD_LOGIC;
signal clkstate : STD_LOGIC;

begin

process(clk100MHz)
begin
    if rising_edge(clk100MHz) then
        Q1 <= clkSPI;
        Q2 <= Q1;
        Q3 <= Q2; 
        if Q1 = Q2 and Q1 = Q3 and clkstate /= Q1 then -- laatste Q1 kan ook Q2 of Q3 zijn
            if Q1 = '0' then -- neergaande flank
                edge <= '1';
            end if;
                clkstate <= Q1;
        else
                edge <= '0';
        end if;  
    end if;
end process;
    

end Behavioral;
