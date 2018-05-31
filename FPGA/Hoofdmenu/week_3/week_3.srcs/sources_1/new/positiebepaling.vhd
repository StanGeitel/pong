--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;

--use IEEE.NUMERIC_STD.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;
--use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

--entity positiebepaling is port( 
--    clk25MHz : in STD_LOGIC;
--    hcount : in STD_LOGIC_VECTOR (9 downto 0);
--    vcount : in STD_LOGIC_VECTOR (9 downto 0);
--    x : out STD_LOGIC_VECTOR (9 downto 0);
--    y : out STD_LOGIC_VECTOR (9 downto 0));
--end positiebepaling;

--architecture Behavioral of positiebepaling is

--signal tmpx : STD_LOGIC_VECTOR (9 downto 0) := std_logic_vector(to_unsigned(400,10));
--signal tmpy : STD_LOGIC_VECTOR (9 downto 0) := std_logic_vector(to_unsigned(250,10));

--begin

--process(clk25MHz)
--    variable dirx : STD_LOGIC := '1';
--    variable diry : STD_LOGIC := '1';
--    variable count : INTEGER := 0;
--begin 
--    if rising_edge(clk25MHz) then
--        count := count + 1;
--        if count = 500000 then -- eerst if vcount = 0 and hcount = 0 then
--            if (tmpx = 144) then 
--                dirx := '1';
                
--            end if;
--            if (tmpx = 774) then
--                dirx := '0';
--            end if;
--            if (tmpy = 31) then
--                diry := '1';
--            end if;
--            if (tmpy = 501) then
--                diry := '0';
--            end if;
        
--            if (dirx = '1') then 
--                tmpx <= tmpx + "1"; -- 1;
--            end if;
--            if (dirx = '0') then 
--                tmpx <= tmpx - "1"; -- 1;
--            end if;
--            if (diry = '1') then
--                tmpy <= tmpy + "1";
--            end if;
--            if (diry = '0') then 
--                tmpy <= tmpy - "1"; 
--            end if;
--            count := 0;
--        end if;
--   end if;
--end process;    

--x <= tmpx;
--y <= tmpy;

--end Behavioral;
