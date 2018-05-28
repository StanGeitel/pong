library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity buttons is port (
    clk25MHz : in STD_LOGIC;
    hcount, vcount : in STD_LOGIC_VECTOR(9 downto 0);
    up, down, left, right, go, forward, backward : STD_LOGIC);
end buttons;

architecture Behavioral of buttons is

signal hcount_int : integer range 0 to 1000;
signal vcount_int : integer range 0 to 1000;
signal score1, score2 : STD_LOGIC_VECTOR(3 downto 0);
signal xball, yball, rball, xb1, yb1, xb2, yb2 : STD_LOGIC_VECTOR(9 downto 0);
signal upcount, downcount, leftcount, rightcount, forwardcount, backwardcount : INTEGER;
signal gocount : STD_LOGIC_VECTOR(2 downto 0); -- gocount bepaalt of batje 1, batje 2, ball of menu wordt bediend
signal gopressed : STD_LOGIC; 

begin

hcount_int <= to_integer(unsigned(hcount));
vcount_int <= to_integer(unsigned(vcount));

process(clk25MHz)
begin
    if rising_edge(clk25MHz) then
    
        if (go = '1' and gopressed = '0') then 
            gopressed <= '1';
            gocount <= gocount + "1";
        end if;
        if (go = '0' and gopressed = '1') then
            gopressed <= '0';
        end if;
        
        -- 10 pixels per seconde verschuiven, 1 pixel per 0.1 seconde. Op 25MHz zijn dan 2.500.000 stappen
        
        if (up = '1') then 
            upcount <= upcount + 1;
        end if;
        if (upcount > 2500000) then
            if (gocount = 0) then
                yb1 <= yb1 + "1";
            elsif (gocount = 1) then 
                yb2 <= yb2 + "1";
            elsif (gocount = 2) then 
                yball <= yball + "1";
            end if;
            upcount <= 0;
        end if;

        if (down = '1') then 
            downcount <= downcount + 1;
        end if;
        if (downcount > 2500000) then
            if (gocount = 0) then
                yb1 <= yb1 - "1";  -- PROBLEMEN MET 0 - 1. WAT GEBEURT ER DAN?
            elsif (gocount = 1) then 
                yb2 <= yb2 - "1";
            elsif (gocount = 2) then 
                yball <= yball - "1";
            end if; 
            downcount <= 0;
        end if;
 
        if (left = '1') then 
            leftcount <= leftcount + 1;
        end if;
        if (leftcount > 2500000) then
            if (gocount = 0) then
                xb1 <= xb1 - "1";  -- PROBLEMEN MET 00000 - 1. WAT GEBEURT ER DAN?
            elsif (gocount = 1) then 
                xb2 <= xb2 - "1";
            elsif (gocount = 2) then 
                xball <= xball - "1";
            end if; 
            leftcount <= 0;
        end if;
        
        if (right = '1') then 
            rightcount <= rightcount + 1;
        end if;
        if (rightcount > 2500000) then
            if (gocount = 0) then
                xb1 <= xb1 + "1";  -- PROBLEMEN MET 00000 - 1. WAT GEBEURT ER DAN?
            elsif (gocount = 1) then 
                xb2 <= xb2 + "1";
            elsif (gocount = 2) then 
                xball <= xball + "1";
            end if; 
            rightcount <= 0;
        end if;
        
        if (forward = '1' and gocount = 2 ) then
            forwardcount <= forwardcount + 1;
        end if;
        if (forwardcount > 2500000) then
            rball <= rball - "1";
            forwardcount <= 0;
        end if;
        
        if (backward = '1' and gocount = 2 ) then
            backwardcount <= backwardcount + 1;
        end if;
        if (backwardcount > 2500000) then
            rball <= rball + "1";
            forwardcount <= 0;
        end if;
            
               
    end if;
end process;

end Behavioral;

