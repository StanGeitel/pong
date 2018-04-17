library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Seven_segments is
    Port ( clk : in std_logic;
           data : in std_logic_vector(15 downto 0);
           segments : out std_logic_vector(6 downto 0);
           dp : out std_logic;
           anodes : out std_logic_vector(3 downto 0));
end Seven_segments;

architecture Behavioral of Seven_segments is

begin
process(clk)
variable temp : integer := 0;
variable bcd : std_logic_vector(3 downto 0);
begin
    if rising_edge(clk) then
        temp := temp + 1;
        if(temp > 50000) and (temp < 100000)then
            anodes <= "1110";
            bcd := data(3 downto 0);
        elsif(temp > 100000) and (temp < 150000) then
            anodes <= "1101";
            bcd := data(7 downto 4);
        elsif(temp > 150000) and (temp < 200000) then
            anodes <= "1011";
            bcd := data(11 downto 8);
        elsif(temp = 200000) or (temp < 50000) then
            anodes <= "0111";
            bcd := data(15 downto 12);
        elsif(temp > 200000) then
            temp := 0;
        end if;
        
        case bcd is --              abcdefg
        when "0000" => segments <= "0000001"; -- "0"
        when "0001" => segments <= "1001111"; -- "1"
        when "0010" => segments <= "0010010"; -- "2"
        when "0011" => segments <= "0000110"; -- "3"
        when "0100" => segments <= "1001100"; -- "4"
        when "0101" => segments <= "0100100"; -- "5"
        when "0110" => segments <= "0100000"; -- "6"
        when "0111" => segments <= "0001111"; -- "7"
        when "1000" => segments <= "0000000"; -- "8"
        when "1001" => segments <= "0000100"; -- "9"
        when others => segments <= "1111111"; -- " "
        end case;
        
        dp <= '1';
    end if;    
end process;

end Behavioral;
