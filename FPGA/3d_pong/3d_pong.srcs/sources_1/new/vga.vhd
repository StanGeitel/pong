library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;
--use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity vga is port( 	
    clkVGA : in STD_LOGIC;
    red_in, green_in, blue_in : in STD_LOGIC_VECTOR(3 downto 0);
    h_count, v_count : out STD_LOGIC_VECTOR(9 downto 0);
    hsync, vsync : out STD_LOGIC;
    red, green, blue : out STD_LOGIC_VECTOR(3 downto 0));
end VGA;

architecture Behavioral of vga is

signal hcount : integer range 0 to 800;
signal vcount : integer range 0 to 521;

begin 

process (clkVGA)
begin
    if rising_edge(clkVGA) then             
        h_count <= std_logic_vector(to_unsigned(hcount, h_count'length));
        v_count <= std_logic_vector(to_unsigned(vcount, v_count'length));
        if (hcount >= 144) and (hcount < 784) and (vcount >= 31) and (vcount < 511) then
            red <= red_in;
            green <= green_in;
            blue <= blue_in;
            --h_count <= std_logic_vector(to_unsigned(hcount, h_count'length));
            --v_count <= std_logic_vector(to_unsigned(vcount, v_count'length));
        else
            red <= "0000";
            green <= "0000";
            blue <= "0000";
        end if;
	   
        if (hcount < 97) then
            hsync <= '0';
        else
            hsync <= '1';
        end if;

        if (vcount < 3) then
            vsync <= '0';
        else
            vsync <= '1';
        end if;
	 
        hcount <= hcount + 1;
	 
        if hcount = 800 then
            vcount <= vcount + 1;
            hcount <= 0;
        end if;
	 
        if vcount = 521 then		    
            vcount <= 0;
        end if;
    end if;
end process;

end Behavioral;

