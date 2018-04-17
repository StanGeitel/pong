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
--use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.Numeric_STD.all;

entity image is
    Port ( clk25 : in std_logic;
           en : in std_logic;
           x_ball : in integer range 144 to 783;
           y_ball : in integer range 31 to 510;
           h_count : in integer range 0 to 800;
           v_count : in integer range 0 to 521;
           red, green, blue : out  std_logic_vector(3 downto 0));
end image;

architecture Behavioral of image is

constant size : integer := 10;
constant color_black : std_logic_vector(11 downto 0) := "000000000000";
constant color_red : std_logic_vector(11 downto 0) := "111100000000";
constant color_green : std_logic_vector(11 downto 0) := "000011110000";
constant color_blue : std_logic_vector(11 downto 0) := "000000001111";
constant color_yellow : std_logic_vector(11 downto 0) := "111111110000";
constant color_white : std_logic_vector(11 downto 0) := "111111111111";

constant color_back : std_logic_vector(11 downto 0) := color_white;
constant color_ball : std_logic_vector(11 downto 0) := color_red;

type matrix is array (0 to 9, 0 to 9) of std_logic_vector(11 downto 0);
constant ball : matrix := (
(color_back, color_back, color_back, color_ball, color_ball, color_ball, color_ball, color_back, color_back, color_back),
(color_back, color_ball, color_ball, color_ball, color_ball, color_ball, color_ball, color_ball, color_ball, color_back),
(color_back, color_ball, color_black, color_black, color_ball, color_black, color_black, color_ball, color_ball, color_back),
(color_ball, color_ball, color_ball, color_ball, color_ball, color_ball, color_ball, color_ball, color_ball, color_ball),
(color_ball, color_ball, color_ball, color_ball, color_ball, color_ball, color_ball, color_ball, color_ball, color_ball),
(color_ball, color_ball, color_ball, color_ball, color_ball, color_ball, color_ball, color_ball, color_ball, color_ball),
(color_ball, color_ball, color_ball, color_ball, color_ball, color_ball, color_ball, color_ball, color_ball, color_ball),
(color_back, color_ball, color_black, color_black, color_black, color_black, color_black, color_ball, color_ball, color_back),
(color_back, color_ball, color_black, color_ball, color_ball, color_ball, color_black, color_ball, color_ball, color_back),
(color_back, color_back, color_back, color_ball, color_ball, color_ball, color_ball, color_back, color_back, color_back));

begin
process(clk25)
variable i,j : integer range 0 to 9;
begin 
    if rising_edge(clk25) then
        if en = '1' then
            if (h_count >= x_ball) and (h_count <= (x_ball+(size-1))) and (v_count >= y_ball) and (v_count <= (y_ball+(size-1))) then
                i := (h_count - x_ball);
                j := (v_count - y_ball);
                red <= ball(j,i)(11 downto 8);
                green <= ball(j,i)(7 downto 4);
                blue <= ball(j,i)(3 downto 0);
            else
                red <= color_back(11 downto 8);
                green <= color_back(7 downto 4);
                blue <= color_back(3 downto 0);
            end if;
        else
            red <= "0000";
            green <= "0000";
            blue <= "0000";
        end if;
    end if;
end process;
end Behavioral;
