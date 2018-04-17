library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.Numeric_STD.all;

entity VGA is
    Port ( 	clk25 : in STD_LOGIC;
            en : out std_logic;
			x_ball : out integer range 144 to 783;
            y_ball : out integer range 31 to 510;
            h_count : out integer range 0 to 800;
            v_count : out integer range 0 to 521;
			hsync, vsync : out STD_LOGIC);
end VGA;

architecture Behavioral of VGA is

begin

process (clk25)

variable hcount : integer range 0 to 800;
variable vcount : integer range 0 to 521;
variable x : integer range 144 to 783 := 350;
variable y : integer range 31 to 510 := 250;
variable cnt : integer := 0;
variable x_dir : integer := 1;
variable y_dir : integer := 1;

begin
    if rising_edge(clk25) then
        cnt := cnt + 1;
        if cnt = 500000 then
          if x = 144 then
              x_dir := 1;
          elsif (x + 10) = 783 then
              x_dir := -1;
          end if;
          
          if y = 31 then
              y_dir := 1;
          elsif (y + 10) = 510 then
              y_dir := -1;
          end if; 
          x := x + x_dir;
          y := y + y_dir;
          cnt := 0;
        end if;      
--      sync+back porch     pixels-front porch  sync+back porch    lines-front porch
	  if (hcount >= 144) and (hcount < 784) and (vcount >= 31) and (vcount < 511) then
          en <= '1';
          x_ball <= x;
          y_ball <= y;
          h_count <= hcount;
          v_count <= vcount;
	  else
	      en <= '0';
	  end if;
	   
      if (hcount < 97) then
        hsync <= '0';
      else
        hsync <= '1';
      end if;

      if (vcount < 3) then
        vsync <= '0';
      else
        vsync <= '1';
      end if;
	 
      hcount := hcount + 1;
	 
      if hcount = 800 then
        vcount := vcount + 1;
        hcount := 0;
      end if;
	 
      if vcount = 521 then		    
        vcount := 0;
      end if;
    end if;
end process;

end Behavioral;

