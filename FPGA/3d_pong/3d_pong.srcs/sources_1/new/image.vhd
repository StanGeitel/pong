library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity image is port(
    clk25MHz : in STD_LOGIC;
    hcount, vcount : in STD_LOGIC_VECTOR(9 downto 0);
    data_ram : in STD_LOGIC_VECTOR(9 downto 0);
    addr_ram : out STD_LOGIC_VECTOR(3 downto 0);
    red, green, blue : out STD_LOGIC_VECTOR(3 downto 0));
end image;

architecture Behavioral of image is
    signal hcount_int : integer range 0 to 1000;
    signal vcount_int : integer range 0 to 1000;
    signal RamCounter : STD_LOGIC_VECTOR(3 downto 0);
    signal refresh_counter : STD_LOGIC;
    signal spelmod, moeil, menu, menusel : STD_LOGIC_VECTOR(1 downto 0);
    signal score1, score2 : STD_LOGIC_VECTOR(3 downto 0);
    signal xball, yball, rball, xb1, yb1, xb2, yb2, xb3, yb3, xb4, yb4, xb2raw, yb2raw : integer range 0 to 1023;
    
begin
    
    hcount_int <= to_integer(unsigned(hcount));
    vcount_int <= to_integer(unsigned(vcount)); 
    xb2raw <= 480;
    yb2raw <= 186;
    xb1 <= 480;
    yb1 <= 186;

process(clk25Mhz)
begin
    if falling_edge(clk25MHz) then  
        if vcount_int > 511 then
            if RamCounter < 13 and refresh_counter = '0' then
                addr_ram <= RamCounter;
                RamCounter <= RamCounter + 1;
            else 
                Ramcounter <= (others => '0');
                refresh_counter <= '1';    
            end if;
            
            if Ramcounter = 1 then
                menusel <= data_ram (1 downto 0);
                menu <= data_ram (3 downto 2);
                moeil <= data_ram (5 downto 4);
                spelmod <= data_ram (7 downto 6);          
            elsif Ramcounter = 2 then
                score2 <= data_ram (3 downto 0);
                score1 <= data_ram (7 downto 4);
            elsif Ramcounter = 3 then 
                xball <= to_integer(unsigned(data_ram));
            elsif Ramcounter = 4 then
                yball <= to_integer(unsigned(data_ram));
            elsif Ramcounter = 5 then
                rball <= to_integer(unsigned(data_ram));
            elsif Ramcounter = 6 then
                xb1 <= to_integer(unsigned(data_ram));
            elsif Ramcounter = 7 then
                yb1 <= to_integer(unsigned(data_ram));
            elsif Ramcounter = 8 then
                xb2raw <= to_integer(unsigned(data_ram));
            elsif Ramcounter = 9 then
                yb2raw <= to_integer(unsigned(data_ram));
            elsif Ramcounter = 10 then
                xb3 <= to_integer(unsigned(data_ram));
            elsif Ramcounter = 11 then
                yb3 <= to_integer(unsigned(data_ram));
            elsif Ramcounter = 12 then
                xb4 <= to_integer(unsigned(data_ram));
            elsif Ramcounter = 13 then
                yb4 <= to_integer(unsigned(data_ram));
            end if;
        elsif vcount_int = 0 then
            refresh_counter <= '0';
        end if;
    end if;
    
    if rising_edge(clk25MHz) then   
        xb2 <= (xb2raw-145)/4+385;
        yb2 <= (yb2raw-62)/4+222; 
        if((hcount_int = xb1 and (vcount_int <= (yb1 + 100) and vcount_int >= yb1)) or (hcount_int = (xb1 + 150) and (vcount_int <= (yb1 + 100) and vcount_int >= yb1)) or (vcount_int = yb1 and (hcount_int <= (xb1 + 150) and hcount_int >= xb1)) or (vcount_int = (yb1 + 100) and (hcount_int <= (xb1 + 150) and hcount_int >= xb1))) then
            red <= "0000";
            green <= "0000";
            blue <= "1000"; 
        elsif((hcount_int > xb1 and vcount_int > yb1) and (hcount_int < (xb1 + 150) and vcount < (yb1 + 100))) then
            if((xball-hcount_int)*(xball-hcount_int)+(yball-vcount_int)*(yball-vcount_int) <= rball*rball or (hcount_int-xball)*(hcount_int-xball)+(vcount_int-yball)*(vcount_int-yball) <= rball*rball) then
                red <= "0010";
                green <= "0010";
                blue <= "0000";
            elsif((hcount_int = xb2 and (vcount_int <= (yb2 + 25) and vcount_int >= yb2)) or (hcount_int = (xb2 + 38) and (vcount_int <= (yb2 + 25) and vcount_int >= yb2)) or (vcount_int = yb2 and (hcount_int <= (xb2 + 38) and hcount_int >= xb2)) or (vcount_int = (yb2 + 25) and (hcount_int <= (xb2 + 38) and hcount_int >= xb2))) then
                red <= "0010";
                green <= "0000";
                blue <= "0000";
          
            --Schuine lijnen  
            elsif ( abs((3 * (vcount_int - 62)) - (2 *( hcount_int - 145))) < 3 ) and ( (hcount < 383 or hcount > 543) and ( vcount < 220 or vcount > 328) and hcount > 145 and hcount < 781 and vcount > 62 and vcount < 486) then
                red <= "0000";
                green <= "0010"; 
                blue <= "0000";
            elsif ( abs((3 * (vcount_int - 62 )) + (2 *( hcount_int - 145)) - 3*425 ) < 3 ) and ( (hcount < 383 or hcount > 543) and ( vcount < 220 or vcount > 328) and hcount > 145 and hcount < 781 and vcount > 62 and vcount < 486) then
                red <= "0000";
                green <= "0010"; 
                blue <= "0000";
                
            elsif((hcount_int = 145 and (vcount_int <= 486 and vcount_int >= 62)) or (hcount_int = 781 and (vcount_int <= 486 and vcount_int >= 62)) or (vcount_int = 62 and (hcount_int <= 781 and hcount_int >= 145)) or (vcount_int = 486 and (hcount_int <= 781 and hcount_int >= 145))) then
                red <= "0000";
                green <= "0010";
                blue <= "0000";
            elsif((hcount_int = 230 and (vcount_int <= 430 and vcount_int >= 119)) or (hcount_int = 696 and (vcount_int <= 430 and vcount_int >= 119)) or (vcount_int = 119 and (hcount_int <= 696 and hcount_int >= 230)) or (vcount_int = 430 and (hcount_int <= 696 and hcount_int >= 230))) then
                red <= "0000";
                green <= "0010";
                blue <= "0000";
            elsif((hcount_int = 293 and (vcount_int <= 388 and vcount_int >= 161)) or (hcount_int = 633 and (vcount_int <= 388 and vcount_int >= 161)) or (vcount_int = 161 and (hcount_int <= 634 and hcount_int >= 293)) or (vcount_int = 388 and (hcount_int <= 634 and hcount_int >= 293))) then
                red <= "0000";
                green <= "0010";
                blue <= "0000";
            elsif((hcount_int = 328 and (vcount_int <= 364 and vcount_int >= 186)) or (hcount_int = 598 and (vcount_int <= 364 and vcount_int >= 186)) or (vcount_int = 186 and (hcount_int <= 598 and hcount_int >= 328)) or (vcount_int = 364 and (hcount_int <= 598 and hcount_int >= 328))) then
                red <= "0000";
                green <= "0010";
                blue <= "0000";
            elsif((hcount_int = 360 and (vcount_int <= 343 and vcount_int >= 206)) or (hcount_int = 566 and (vcount_int <= 343 and vcount_int >= 206)) or (vcount_int = 343 and (hcount_int <= 566 and hcount_int >= 360)) or (vcount_int = 206 and (hcount_int <= 566 and hcount_int >= 360))) then
                red <= "0000";
                green <= "0010";
                blue <= "0000";
            elsif((hcount_int = 384 and (vcount_int <= 327 and vcount_int >= 221)) or (hcount_int = 543 and (vcount_int <= 327 and vcount_int >= 221)) or (vcount_int = 221 and (hcount_int <= 543 and hcount_int >= 384)) or (vcount_int = 327 and (hcount_int <= 543 and hcount_int >= 384))) then
                red <= "0000";
                green <= "0010";
                blue <= "0000";
            else
                red <= "0000";
                green <= "0000";
                blue <= "0000";
            end if;       
        elsif((xball-hcount_int)*(xball-hcount_int)+(yball-vcount_int)*(yball-vcount_int) <= rball*rball or (hcount_int-xball)*(hcount_int-xball)+(vcount_int-yball)*(vcount_int-yball) <= rball*rball) then
            red <= "1000";
            green <= "1000";
            blue <= "0000";
        elsif((hcount_int = xb2 and (vcount_int <= (yb2 + 25) and vcount_int >= yb2)) or (hcount_int = (xb2 + 38) and (vcount_int <= (yb2 + 25) and vcount_int >= yb2)) or (vcount_int = yb2 and (hcount_int <= (xb2 + 38) and hcount_int >= xb2)) or (vcount_int = (yb2 + 25) and (hcount_int <= (xb2 + 38) and hcount_int >= xb2))) then
            red <= "1000";
            green <= "0000";
            blue <= "0000"; 
        
        --Schuine lijnen  
        elsif ( abs((3 * (vcount_int - 62)) - (2 *( hcount_int - 145))) < 3 ) and ( (hcount < 383 or hcount > 543) and ( vcount < 220 or vcount > 328) and hcount > 145 and hcount < 781 and vcount > 62 and vcount < 486) then
            red <= "0000";
            green <= "1000"; 
            blue <= "0000";
        elsif ( abs((3 * (vcount_int - 62 )) + (2 *( hcount_int - 145)) - 3*425 ) < 3 ) and ( (hcount < 383 or hcount > 543) and ( vcount < 220 or vcount > 328) and hcount > 145 and hcount < 781 and vcount > 62 and vcount < 486) then
            red <= "0000";
            green <= "1000"; 
            blue <= "0000";
                       
        elsif((hcount_int = 145 and (vcount_int <= 486 and vcount_int >= 62)) or (hcount_int = 781 and (vcount_int <= 486 and vcount_int >= 62)) or (vcount_int = 62 and (hcount_int <= 781 and hcount_int >= 145)) or (vcount_int = 486 and (hcount_int <= 781 and hcount_int >= 145))) then
            red <= "0000";
            green <= "1000";
            blue <= "0000";
        elsif((hcount_int = 230 and (vcount_int <= 430 and vcount_int >= 119)) or (hcount_int = 696 and (vcount_int <= 430 and vcount_int >= 119)) or (vcount_int = 119 and (hcount_int <= 696 and hcount_int >= 230)) or (vcount_int = 430 and (hcount_int <= 696 and hcount_int >= 230))) then
            red <= "0000";
            green <= "1000";
            blue <= "0000";
        elsif((hcount_int = 293 and (vcount_int <= 388 and vcount_int >= 161)) or (hcount_int = 633 and (vcount_int <= 388 and vcount_int >= 161)) or (vcount_int = 161 and (hcount_int <= 634 and hcount_int >= 293)) or (vcount_int = 388 and (hcount_int <= 634 and hcount_int >= 293))) then
            red <= "0000";
            green <= "1000";
            blue <= "0000";
        elsif((hcount_int = 328 and (vcount_int <= 364 and vcount_int >= 186)) or (hcount_int = 598 and (vcount_int <= 364 and vcount_int >= 186)) or (vcount_int = 186 and (hcount_int <= 598 and hcount_int >= 328)) or (vcount_int = 364 and (hcount_int <= 598 and hcount_int >= 328))) then
            red <= "0000";
            green <= "1000";
            blue <= "0000";
        elsif((hcount_int = 360 and (vcount_int <= 343 and vcount_int >= 206)) or (hcount_int = 566 and (vcount_int <= 343 and vcount_int >= 206)) or (vcount_int = 343 and (hcount_int <= 566 and hcount_int >= 360)) or (vcount_int = 206 and (hcount_int <= 566 and hcount_int >= 360))) then
            red <= "0000";
            green <= "1000";
            blue <= "0000";
        elsif((hcount_int = 384 and (vcount_int <= 327 and vcount_int >= 221)) or (hcount_int = 543 and (vcount_int <= 327 and vcount_int >= 221)) or (vcount_int = 221 and (hcount_int <= 543 and hcount_int >= 384)) or (vcount_int = 327 and (hcount_int <= 543 and hcount_int >= 384))) then
            red <= "0000";
            green <= "1000";
            blue <= "0000";
        elsif (hcount_int >= 144) and (hcount_int < 784) and (vcount_int >= 31) and (vcount_int < 511) then
            red <= "0000";
            green <= "0000";
            blue <= "0000";
        end if;
    end if;
end process;

end Behavioral;
