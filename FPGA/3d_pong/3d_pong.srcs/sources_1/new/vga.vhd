----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.04.2018 10:55:53
-- Design Name: 
-- Module Name: vga - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity VGA is
    Port ( 	clk_25MHz : in STD_LOGIC;
			red : out STD_LOGIC_VECTOR(3 downto 0);
			green : out STD_LOGIC_VECTOR(3 downto 0);
			blue : out STD_LOGIC_VECTOR(3 downto 0);
			hsync, vsync : out  STD_LOGIC;
			red_in : in STD_LOGIC_VECTOR(3 downto 0);
			green_in : in STD_LOGIC_VECTOR(3 downto 0);
			blue_in : in STD_LOGIC_VECTOR(3 downto 0);
			hcount_out, vcount_out : out STD_LOGIC_VECTOR(9 downto 0));
end VGA;

architecture Behavioral of VGA is
  signal hcount: STD_LOGIC_VECTOR(9 downto 0);
  signal vcount: STD_LOGIC_VECTOR(9 downto 0);
  
begin
hcount_out <= hcount;
vcount_out <= vcount;
process (clk_25MHz) 
begin
    if rising_edge(clk_25MHz) then
	  if (hcount >= 144) and (hcount < 784) and (vcount >= 31) and (vcount < 511) then
           red <= red_in;
           green <= green_in;
           blue <= blue_in; 
      else 
           red <= "0000";
           green <= "0000";
           blue <= "0000";
      end if;
      if hcount < 97 then
        hsync <= '0';
      else
        hsync <= '1';
      end if;

      if vcount < 3 then
        vsync <= '0';
      else
        vsync <= '1';
      end if;
	 
      hcount <= hcount + 1;
	 
      if hcount = 800 then
        vcount <= vcount + 1;
        hcount <= (others => '0');
      end if;
	 
      if vcount = 521 then		    
        vcount <= (others => '0');
      end if;
	 end if;
end process;


end Behavioral;
