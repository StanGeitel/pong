library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.Numeric_STD.all;

entity VGA is
    Port ( 	clk25 : in STD_LOGIC;
            en : out std_logic;
			x_cor, y_cor : out std_logic_vector(9 downto 0);
			h_count, v_count : out std_logic_vector(9 downto 0);
			hsync, vsync : out STD_LOGIC);
end VGA;

architecture Behavioral of VGA is

signal hcount : integer range 0 to 800;
signal vcount : integer range 0 to 521;
signal x : integer range 144 to 783 := 144;
signal y : integer range 31 to 510 := 31;
signal cnt : integer := 0;
signal x_dir : integer := 1;
signal y_dir : integer := 1;

begin

process (clk25)

begin
    if rising_edge(clk25) then
       cnt <= cnt + 1;
        if cnt = 500000 then
          if x = 144 then
              x_dir <= 1;
          elsif (x + 10) = 783 then
              x_dir <= -1;
          end if;
          
          if y = 31 then
              y_dir <= 1;
          elsif (y + 10) = 510 then
              y_dir <= -1;
          end if; 
          
          x <= x + x_dir;
          y <= y + y_dir;
          cnt <= 0;
        end if;      
--      sync+back porch     pixels-front porch  sync+back porch    lines-front porch
	  if (hcount >= 144) and (hcount < 784) and (vcount >= 31) and (vcount < 511) then
          en <= '1';
          x_cor <= std_logic_vector(to_unsigned(x, x_cor'length));
          y_cor <= std_logic_vector(to_unsigned(y, y_cor'length));
          h_count <= std_logic_vector(to_unsigned(hcount, h_count'length));
          v_count <= std_logic_vector(to_unsigned(vcount, v_count'length));
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
	 
      hcount <= hcount + 1;
	 
      if hcount = 800 then
        vcount <= vcount + 1;
        hcount <= 0;
      end if;
	 
      if vcount = 521 then		    
        vcount <= 0;
      end if;
    end if;
end process;

end Behavioral;

