library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;

entity memory is port (
    clk25MHz : in STD_LOGIC;
    addra : in STD_LOGIC_VECTOR(3 downto 0);
    dina : in STD_LOGIC_VECTOR(9 downto 0);
    addr_img : in STD_LOGIC_VECTOR(3 downto 0);
    wea : in STD_LOGIC_VECTOR(0 downto 0);
    data_out : out STD_LOGIC_VECTOR(9 downto 0));
end memory;

architecture Behavioral of memory is
  
component blk_mem_gen_0 port(
     clka : in STD_LOGIC;
     wea : in STD_LOGIC_VECTOR(0 downto 0);
     addra : in STD_LOGIC_VECTOR(3 downto 0);
     dina : in STD_LOGIC_VECTOR(9 downto 0);
     clkb : in STD_LOGIC;
     addrb : in STD_LOGIC_VECTOR(3 downto 0);
     doutb : out STD_LOGIC_VECTOR(9 downto 0)); -- afhankelijk van depth
end component;

begin

ram1 : blk_mem_gen_0 port map(
    clka => clk25MHz,
    wea => wea,
    addra => addra,
    dina => dina,
    clkb => clk25MHz,
    addrb => addr_img,
    doutb => data_out);

process(clk25MHz)
begin
end process;
--process(clk25MHz)                 Dit toepassen als block WE niet gebruikt
--begin 
--    if rising_edge(clk25MHz) then
--        if (wea = "0") then
--            dina <= data_in;
--            addra <= addr_spi;
--        end if;
--     end if;
--end process;

end Behavioral;
