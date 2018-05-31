library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;

entity rom is port (
    clk : in STD_LOGIC;
    adres : in STD_LOGIC_VECTOR(9 downto 0);
    data : out STD_LOGIC_VECTOR(7 downto 0));
end rom;

architecture Behavioral of rom is

component blk_mem_gen_0 port( -- always enabled
    clka : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
end component;

begin

rom : blk_mem_gen_0 port map(
    clka => clk,
    addra => adres,
    douta => data); 

end Behavioral;
