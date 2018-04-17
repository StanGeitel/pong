library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Seven_segments is
    Port ( clk : in std_logic;
           segments : out std_logic_vector(6 downto 0);
           dp : out std_logic;
           anodes : out std_logic_vector(3 downto 0));
end Seven_segments;

architecture Behavioral of Seven_segments is

signal pos : integer := 0;
type patern is array (0 to 23) of std_logic_vector(6 downto 0);
constant snake : patern := (
    "1111101","1111011","1110111",
    "1111011","1111101","0111111",
    "1111101","1111011","1110111",
    "1111011","1111101","0111111",
    "1011111","1101111","1110111",
    "1101111","1011111","0111111",
    "1011111","1101111","1110111",
    "1101111","1011111","0111111");

begin

process(clk)
variable cnt : integer := 0;
begin
    if rising_edge(clk) then
        cnt := cnt + 1;
        if(cnt = 20000000) then
            pos <= pos + 1;
            if(pos = 23) then
                pos <= 0;
            end if;
            cnt := 0;
        end if;
    end if;
end process;


process(clk)
variable temp : integer := 0;
begin
    if rising_edge(clk) then
        temp := temp + 1;
        if(temp > 50000) and (temp < 100000)then
            anodes <= "1110";
            if((pos >= 9 and pos <= 14)) then
                segments <= snake(pos);
            else
                segments <= "1111111";
            end if;
        elsif(temp > 100000) and (temp < 150000) then
            anodes <= "1101";
            if((pos >= 6 and pos <=8) or (pos >= 15 and pos <= 17)) then
                segments <= snake(pos);
            else
                segments <= "1111111";
            end if;
        elsif(temp > 150000) and (temp < 200000) then
            anodes <= "1011";
            if((pos >= 3 and pos <= 5) or (pos >= 18 and pos <= 20)) then
                segments <= snake(pos);
            else
                segments <= "1111111";
            end if;
        elsif(temp = 200000) or (temp < 50000) then
            anodes <= "0111";
            if((pos <= 2) or (pos >= 21)) then
                segments <= snake(pos);
            else
                segments <= "1111111";
            end if;
        elsif(temp > 200000) then
            temp := 0;
        end if;
        
        dp <= '1';
    end if;    
end process;

end Behavioral;
