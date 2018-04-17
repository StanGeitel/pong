library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top is
    Port ( clk : in std_logic;
           pwm : out std_logic);
end top;

architecture Behavioral of top is

component blk_mem_gen_0
      PORT ( clka : IN STD_LOGIC;
             addra : IN STD_LOGIC_VECTOR(12 DOWNTO 0);
             douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
end component blk_mem_gen_0;

component music
    Port ( clk : in std_logic;
           data : in std_logic_vector(7 downto 0);
           pwm : out std_logic;
           address : out std_logic_vector(12 downto 0));
end component music;

signal addr : std_logic_vector(12 downto 0);
signal sample : std_logic_vector(7 downto 0);

begin
    rom : blk_mem_gen_0 port map(clka => clk, addra => addr, douta => sample);
    audio : music port map(clk => clk, data => sample, pwm => pwm, address => addr);

end Behavioral;