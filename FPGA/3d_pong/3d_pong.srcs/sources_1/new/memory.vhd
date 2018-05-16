library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;

entity memory is port (
    clk25MHz : in STD_LOGIC;
    addr_spi : in STD_LOGIC_VECTOR(3 downto 0);
    data_in : in STD_LOGIC_VECTOR(9 downto 0);
    addr_img : in STD_LOGIC_VECTOR(3 downto 0);
    WE : in STD_LOGIC_VECTOR(0 downto 0);
    data_out : out STD_LOGIC_VECTOR(9 downto 0));
end memory;

architecture Behavioral of memory is
  
component blk_mem_gen_0 port(
     clka : IN STD_LOGIC;
     wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
     addra : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
     dina : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
     clkb : IN STD_LOGIC;
     addrb : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
     doutb : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)); -- afhankelijk van depth
    
end component;

begin

ram1 : blk_mem_gen_0 port map(
    clka => clk25MHz,
    wea => WE,
    addra => addr_spi,
    dina => data_in,
    clkb => clk25MHz,
    addrb => addr_img,
    doutb => data_out);

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
