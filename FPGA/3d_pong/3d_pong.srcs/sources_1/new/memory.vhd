library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;

entity memory is port (
    clk100MHz : in STD_LOGIC;
    address : in STD_LOGIC_VECTOR(3 downto 0);
    data_in : in STD_LOGIC_VECTOR(9 downto 0);
    data_out : out STD_LOGIC_VECTOR(9 downto 0));
end memory;

architecture Behavioral of memory is
  
component blk_mem_gen_0 port(
    clka : in STD_LOGIC_VECTOR;
    wea : in STD_LOGIC;
    addra : in STD_LOGIC_VECTOR(3 downto 0); -- afhankelijk van depth
    dina : in STD_LOGIC_VECTOR(9 downto 0);
    douta : out STD_LOGIC_VECTOR(9 downto 0)); -- afhankelijk van depth
end component;

signal write_enable : STD_LOGIC;

begin

ram1 : blk_mem_gen_0 port map(
    clka => clk100MHz,
    wea => write_enable,
    addra => address,
    dina => data_in,
    douta => data_out);

end Behavioral;
