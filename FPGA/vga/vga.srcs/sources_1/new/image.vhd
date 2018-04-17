----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.02.2018 12:26:39
-- Design Name: 
-- Module Name: image - Behavioral
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
use IEEE.Numeric_STD.all;

entity image is
    Port ( clk25 : in std_logic;
           en : in std_logic;
           rs, gs, bs : in std_logic;
           rb, gb, bb : in std_logic;
           x, y : in std_logic_vector(9 downto 0);
           h_count, v_count : in std_logic_vector(9 downto 0);
           red, green, blue : out  std_logic_vector(3 downto 0));
end image;

architecture Behavioral of image is

begin

process(clk25)
begin 
    if rising_edge(clk25) then
        if en = '1' then
            if (h_count >= x) and (h_count < x+10) and (v_count >= y) and (v_count < y+10) then 
               if rs = '1' then
                    red <= std_logic_vector(to_unsigned(255, red'length));
               else
                    red <= std_logic_vector(to_unsigned(0, red'length));
               end if;
               if gs = '1' then
                    green <= std_logic_vector(to_unsigned(255, green'length));
               else
                    green <= std_logic_vector(to_unsigned(0, green'length));
               end if;
               if bs = '1' then
                    blue <= std_logic_vector(to_unsigned(255, blue'length));
               else
                    blue <= std_logic_vector(to_unsigned(0, blue'length));
               end if;
            else
               if rb = '1' then
                     red <= std_logic_vector(to_unsigned(255, red'length));
                else
                     red <= std_logic_vector(to_unsigned(0, red'length));
                end if;
                if gb = '1' then
                     green <= std_logic_vector(to_unsigned(255, green'length));
                else
                     green <= std_logic_vector(to_unsigned(0, green'length));
                end if;
                if bb = '1' then
                     blue <= std_logic_vector(to_unsigned(255, blue'length));
                else
                     blue <= std_logic_vector(to_unsigned(0, blue'length));
                end if;
            end if;
        else
            red <= std_logic_vector(to_unsigned(0, red'length));
            green <= std_logic_vector(to_unsigned(0, green'length));
            blue <= std_logic_vector(to_unsigned(0, blue'length));
        end if;
    end if;
end process;
end Behavioral;
