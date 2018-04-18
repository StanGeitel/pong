library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;

entity clk is port (
    clk100MHz : in STD_LOGIC;
    clkPS2 : in STD_LOGIC;
    enable : out STD_LOGIC);
end clk;

architecture Behavioral of clk is

signal Q1, Q2, Q3 : STD_LOGIC;
signal clkstate : STD_LOGIC;

begin

process(clk100MHz)
begin
    if rising_edge(clk100MHz) then
        Q1 <= clkPS2;
        Q2 <= Q1;
        Q3 <= Q2; 
        if Q1 = Q2 and Q1 = Q3 and clkstate /= Q1 then -- laatste Q1 kan ook Q2 of Q3 zijn
            if Q1 = '1' then -- opgaande flank
                enable <= '1';
            end if;
                clkstate <= Q1;
        else
                enable <= '0';
        end if;  
    end if;
end process;
    

end Behavioral;
