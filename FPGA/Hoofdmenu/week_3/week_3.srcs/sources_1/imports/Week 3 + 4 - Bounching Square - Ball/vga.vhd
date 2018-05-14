library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity VGA is port( 	
    clk25MHz : in STD_LOGIC;
    red, green, blue : out  STD_LOGIC_VECTOR (3 downto 0);
    hsync, vsync : out  STD_LOGIC;
    button : in STD_LOGIC);
end VGA;

architecture Behavioral of VGA is

component kleurregeling port( 
    clk25MHz : in STD_LOGIC;
    hcount : in STD_LOGIC_VECTOR (9 downto 0);
    vcount : in STD_LOGIC_VECTOR (9 downto 0);
    red, green, blue : out  STD_LOGIC_VECTOR (3 downto 0);
    button : in STD_LOGIC);
end component;

  signal hcount: STD_LOGIC_VECTOR(9 downto 0);
  signal vcount: STD_LOGIC_VECTOR(9 downto 0);
  signal tmpred, tmpgreen, tmpblue : STD_LOGIC_VECTOR (3 downto 0); 
  --signal tmpx, tmpy : STD_LOGIC_VECTOR (9 downto 0);
  
begin
    
kleurregeling1 : kleurregeling port map( 
    clk25MHz => clk25MHz,
    hcount => hcount,
    vcount => vcount,
    red => tmpred,
    green => tmpgreen, 
    blue => tmpblue,
    button => button);

process (clk25MHz) 
begin
    if rising_edge(clk25MHz) then
	   if (hcount >= 144) and (hcount < 784) and (vcount >= 31) and (vcount < 511) then
        red <= tmpred;
        green <= tmpgreen; 
        blue <= tmpblue;
      else
        red <= "0000";
        green <= "0000";
        blue <= "0000";
      end if;
	 
      if hcount < 97 then
        hsync <= '0';
      else
        hsync <= '1';
      end if;

      if vcount < 3 then
        vsync <= '0';
      else
        vsync <= '1';
      end if;
	 
      hcount <= hcount + 1;
	 
      if hcount = 800 then
        vcount <= vcount + 1;
        hcount <= (others => '0');
      end if;
	 
      if vcount = 521 then		    
        vcount <= (others => '0');
      end if;
	 end if;
end process;

end Behavioral;

