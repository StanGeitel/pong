library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;

entity rom_Geluid is port (
    clk : in STD_LOGIC;
    adress : in STD_LOGIC_VECTOR(9 downto 0);
    datas : out STD_LOGIC_VECTOR(7 downto 0));
end rom_Geluid;

architecture Behavioral of rom_Geluid is

component blk_mem_gen_1 port( -- always enabled
    clka : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
end component;

begin

rom : blk_mem_gen_1 port map(
    clka => clk,
    addra => adress,
    douta => datas); 

end Behavioral;
