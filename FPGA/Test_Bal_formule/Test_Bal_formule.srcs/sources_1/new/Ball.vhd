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

entity Ball is
  Port (clk_in : in std_logic;
        red : out std_logic_vector (3 downto 0);
        green : out std_logic_vector (3 downto 0);
        blue : out std_logic_vector (3 downto 0);
        hcount : in std_logic_vector (9 downto 0);
        vcount : in std_logic_vector (9 downto 0));
end Ball;
architecture Behavioral of Ball is
    signal xb : integer:= 390;
    signal yb : integer:= 300;
    signal rb : integer:= 15;
    signal xp : integer:= 250; 
    signal yp : integer:= 300;
    signal xp2 : integer:= 450;
    signal yp2 : integer:= 250;
    signal hcount_int : integer range 0 to 1000;
    signal vcount_int : integer range 0 to 1000;
begin

    hcount_int <= to_integer(unsigned(hcount));
    vcount_int <= to_integer(unsigned(vcount)); 

process(clk_in)
begin
if rising_edge(clk_in) then
    if((hcount_int = xp and (vcount_int <= (yp + 100) and vcount_int >= yp)) or (hcount_int = (xp + 150) and (vcount_int <= (yp + 100) and vcount_int >= yp)) or (vcount_int = yp and (hcount_int <= (xp + 150) and hcount_int >= xp)) or (vcount_int = (yp + 100) and (hcount_int <= (xp + 150) and hcount_int >= xp))) then
        red <= "0000";
        green <= "0000";
        blue <= "1000"; 
    elsif((hcount_int > xp and vcount_int > yp) and (hcount_int < (xp + 150) and vcount < (yp + 100))) then
        if((xb-hcount_int)*(xb-hcount_int)+(yb-vcount_int)*(yb-vcount_int) <= rb*rb or (hcount_int-xb)*(hcount_int-xb)+(vcount_int-yb)*(vcount_int-yb) <= rb*rb) then
            red <= "0010";
            green <= "0010";
            blue <= "0000";
        elsif((hcount_int = xp2 and (vcount_int <= (yp2 + 33) and vcount_int >= yp2)) or (hcount_int = (xp2 + 50) and (vcount_int <= (yp2 + 33) and vcount_int >= yp2)) or (vcount_int = yp2 and (hcount_int <= (xp2 + 50) and hcount_int >= xp2)) or (vcount_int = (yp2 + 33) and (hcount_int <= (xp2 + 50) and hcount_int >= xp2))) then
            red <= "0010";
            green <= "0000";
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
    elsif((xb-hcount_int)*(xb-hcount_int)+(yb-vcount_int)*(yb-vcount_int) <= rb*rb or (hcount_int-xb)*(hcount_int-xb)+(vcount_int-yb)*(vcount_int-yb) <= rb*rb) then
        red <= "1000";
        green <= "1000";
        blue <= "0000";
    elsif((hcount_int = xp2 and (vcount_int <= (yp2 + 33) and vcount_int >= yp2)) or (hcount_int = (xp2 + 50) and (vcount_int <= (yp2 + 33) and vcount_int >= yp2)) or (vcount_int = yp2 and (hcount_int <= (xp2 + 50) and hcount_int >= xp2)) or (vcount_int = (yp2 + 33) and (hcount_int <= (xp2 + 50) and hcount_int >= xp2))) then
        red <= "1000";
        green <= "0000";
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
