----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.03.2018 11:45:02
-- Design Name: 
-- Module Name: music - Behavioral
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
USE ieee.numeric_std.ALL;

entity music is
    Port ( clk : in std_logic;
           data : in std_logic_vector(7 downto 0);
           pwm : out std_logic;
           address : out std_logic_vector(12 downto 0));
end music;

architecture Behavioral of music is

begin
process(clk)
variable clk_cnt : integer range 0 to 12500 := 0;
variable pwm_cnt : integer range 0 to 255 := 0;
variable add : integer range 0 to 6669 := 0;
begin
    if rising_edge(clk) then
        if(clk_cnt < 12500) then
            clk_cnt := clk_cnt + 1;
        else
            if(add < 6669) then
                add := add + 1;
            else
                add := 0;
            end if;
            clk_cnt := 0;
        end if;
        
        if(pwm_cnt < 255) then
            pwm_cnt := pwm_cnt + 1;
        else
            pwm_cnt := 0;
        end if;
        
        if(pwm_cnt <= to_integer(unsigned(data))) then
            pwm <= '1';
        else
            pwm <= '0';
        end if;

        address <= std_logic_vector(to_unsigned(add, address'length));   
    end if;
end process;
end Behavioral;















