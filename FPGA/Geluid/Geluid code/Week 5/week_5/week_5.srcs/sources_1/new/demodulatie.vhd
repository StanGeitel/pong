library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity demodulatie is port (
    clk : in STD_LOGIC;
    data : in STD_LOGIC_VECTOR(7 downto 0);
    adres : out STD_LOGIC_VECTOR(9 downto 0);
    PWM : out STD_LOGIC);
end demodulatie;

architecture Behavioral of demodulatie is

signal counter : STD_LOGIC_VECTOR(7 downto 0) := "00000000";
signal times : STD_LOGIC_VECTOR(2 downto 0) := "000";
signal tmpadres : STD_LOGIC_VECTOR(9 downto 0) := "0000000000";

begin

process(clk)
begin
    if rising_edge(clk) then
        counter <= counter + 1;      
        if counter < data then -- < of <= ?
                PWM <= '1';
            else    
                PWM <= '0';
        end if;
        if counter = 255 then
            if times = 4 then
                    tmpadres <= tmpadres + 1;
                    times <= "000";
                else    
                    times <= times + 1;       
            end if;     
            if tmpadres = 980 then -- begint telkens opnieuw met ceo-file -- length is 6668 dus elementen 0 t/m 6667
                tmpadres <= "0000000000";
            end if;       
        end if;
    end if;   
end process;

adres <= tmpadres;

end Behavioral;
