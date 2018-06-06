----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.02.2018 16:06:35
-- Design Name: 
-- Module Name: four_bit_adder - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity two_bit_adder is
    Port ( A0 : in STD_LOGIC;
           A1 : in STD_LOGIC;
           B0 : in STD_LOGIC;
           B1 : in STD_LOGIC;
           C_in : in STD_LOGIC;
           S0 : out STD_LOGIC;
           S1 : out STD_LOGIC;
           C_out : out STD_LOGIC);
end two_bit_adder;

architecture Behavioral of two_bit_adder is

 component adder
    Port( A : in STD_LOGIC;
          B : in STD_LOGIC;
          S : out STD_LOGIC;
          C_in : in STD_LOGIC;
          C_out : out STD_LOGIC);
 end component;

signal C1 : STD_LOGIC;

begin

FBA0: adder PORT MAP(
		A => A0, 
		B => B0, 
		S => S0, 
		C_in => C_in, 
		C_out => C1);
		
FBA1: adder PORT MAP(        
        A => A1, 
		B => B1, 
		S => S1, 
		C_in => C1, 
		C_out => C_out);
		


end Behavioral;
