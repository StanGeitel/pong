----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.04.2018 10:06:19
-- Design Name: 
-- Module Name: Ball - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity image is
  Port (clk_25MHz : in std_logic;
        red : out std_logic_vector (3 downto 0);
        green : out std_logic_vector (3 downto 0);
        blue : out std_logic_vector (3 downto 0);
        addr_ram : out std_logic_vector (3 downto 0);
        hcount : in std_logic_vector (9 downto 0);
        vcount : in std_logic_vector (9 downto 0);
        data_ram : in std_logic_vector (9 downto 0));
end image;
architecture Behavioral of image is
--    signal xb : integer:= 390;
--    signal yb : integer:= 300;
--    signal rb : integer:= 15;
--    signal xp : integer:= 250; 
--    signal yp : integer:= 300;
--    signal xp2 : integer:= 450;
--    signal yp2 : integer:= 250;
    signal hcount_int : integer range 0 to 1000;
    signal vcount_int : integer range 0 to 1000;
    signal RamCounter : std_logic_vector (3 downto 0);
    signal refresh_counter : std_logic;
    signal spelmod, moeil, menu, menusel : std_logic_vector (1 downto 0);
    signal score1, score2 : std_logic_vector (3 downto 0);
    signal xball, yball, rball, xb1, yb1, xb2, yb2, xb3, yb3, xb4, yb4 : integer range 0 to 1023;
    
begin
    
    hcount_int <= to_integer(unsigned(hcount));
    vcount_int <= to_integer(unsigned(vcount)); 

process(clk_25Mhz)
begin
if falling_edge(clk_25MHz) then  
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
            xb2 <= to_integer(unsigned(data_ram));
        elsif Ramcounter = 9 then
            yb2 <= to_integer(unsigned(data_ram));
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
    
if rising_edge(clk_25MHz) then    
    if((hcount_int = xb1 and (vcount_int <= (yb1 + 100) and vcount_int >= yb1)) or (hcount_int = (xb1 + 150) and (vcount_int <= (yb1 + 100) and vcount_int >= yb1)) or (vcount_int = yb1 and (hcount_int <= (xb1 + 150) and hcount_int >= xb1)) or (vcount_int = (yb1 + 100) and (hcount_int <= (xb1 + 150) and hcount_int >= xb1))) then
        red <= "0000";
        green <= "0000";
        blue <= "1000"; 
    elsif((hcount_int > xb1 and vcount_int > yb1) and (hcount_int < (xb1 + 150) and vcount < (yb1 + 100))) then
        if((xball-hcount_int)*(xball-hcount_int)+(yball-vcount_int)*(yball-vcount_int) <= rball*rball or (hcount_int-xball)*(hcount_int-xball)+(vcount_int-yball)*(vcount_int-yball) <= rball*rball) then
            red <= "0010";
            green <= "0010";
            blue <= "0000";
        elsif((hcount_int = xb2 and (vcount_int <= (yb2 + 33) and vcount_int >= yb2)) or (hcount_int = (xb2 + 50) and (vcount_int <= (yb2 + 33) and vcount_int >= yb2)) or (vcount_int = yb2 and (hcount_int <= (xb2 + 50) and hcount_int >= xb2)) or (vcount_int = (yb2 + 33) and (hcount_int <= (xb2 + 50) and hcount_int >= xb2))) then
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
                
                 
        elsif((hcount_int = 224 and (vcount_int <= 435 and vcount_int >= 113)) or (hcount_int = 702 and (vcount_int <= 435 and vcount_int >= 113)) or (vcount_int = 113 and (hcount_int <= 702 and hcount_int >= 224)) or (vcount_int = 435 and (hcount_int <= 702 and hcount_int >= 224))) then
            red <= "0000";
            green <= "0010";
            blue <= "0000";
        elsif((hcount_int = 303 and (vcount_int <= 382 and vcount_int >= 166)) or (hcount_int = 623 and (vcount_int <= 382 and vcount_int >= 166)) or (vcount_int = 166 and (hcount_int <= 623 and hcount_int >= 303)) or (vcount_int = 382 and (hcount_int <= 623 and hcount_int >= 303))) then
            red <= "0000";
            green <= "0010";
            blue <= "0000";
        elsif((hcount_int = 382 and (vcount_int <= 329 and vcount_int >= 219)) or (hcount_int = 544 and (vcount_int <= 329 and vcount_int >= 219)) or (vcount_int = 219 and (hcount_int <= 544 and hcount_int >= 382)) or (vcount_int = 329 and (hcount_int <= 544 and hcount_int >= 382))) then
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
    elsif((hcount_int = xb2 and (vcount_int <= (yb2 + 33) and vcount_int >= yb2)) or (hcount_int = (xb2 + 50) and (vcount_int <= (yb2 + 33) and vcount_int >= yb2)) or (vcount_int = yb2 and (hcount_int <= (xb2 + 50) and hcount_int >= xb2)) or (vcount_int = (yb2 + 33) and (hcount_int <= (xb2 + 50) and hcount_int >= xb2))) then
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
    elsif((hcount_int = 224 and (vcount_int <= 435 and vcount_int >= 113)) or (hcount_int = 702 and (vcount_int <= 435 and vcount_int >= 113)) or (vcount_int = 113 and (hcount_int <= 702 and hcount_int >= 224)) or (vcount_int = 435 and (hcount_int <= 702 and hcount_int >= 224))) then
        red <= "0000";
        green <= "1000";
        blue <= "0000";
    elsif((hcount_int = 303 and (vcount_int <= 382 and vcount_int >= 166)) or (hcount_int = 623 and (vcount_int <= 382 and vcount_int >= 166)) or (vcount_int = 166 and (hcount_int <= 623 and hcount_int >= 303)) or (vcount_int = 382 and (hcount_int <= 623 and hcount_int >= 303))) then
        red <= "0000";
        green <= "1000";
        blue <= "0000";
    elsif((hcount_int = 382 and (vcount_int <= 329 and vcount_int >= 219)) or (hcount_int = 544 and (vcount_int <= 329 and vcount_int >= 219)) or (vcount_int = 219 and (hcount_int <= 544 and hcount_int >= 382)) or (vcount_int = 329 and (hcount_int <= 544 and hcount_int >= 382))) then
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
