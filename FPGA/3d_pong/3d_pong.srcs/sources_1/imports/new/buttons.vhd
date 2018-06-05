library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity buttons is port (
    clk25MHz : in STD_LOGIC;
    vcount : in STD_LOGIC_VECTOR(9 downto 0);
    up, down, left, right, go, forward, backward : in STD_LOGIC;
    wea2 : out STD_LOGIC_VECTOR(0 downto 0);
    addra2 : out STD_LOGIC_VECTOR(3 downto 0);
    dina2 : out STD_LOGIC_VECTOR(9 downto 0));
end buttons;

architecture Behavioral of buttons is

signal score1, score2 : STD_LOGIC_VECTOR(3 downto 0);
signal xball : STD_LOGIC_VECTOR(9 downto 0);-- := std_logic_vector(to_unsigned(146, 10)); -- wanneer het niet werkt proberen om 
signal yball : STD_LOGIC_VECTOR(9 downto 0);-- := std_logic_vector(to_unsigned(62, 10));
signal rball : STD_LOGIC_VECTOR(9 downto 0);-- := std_logic_vector(to_unsigned(10, 10));
signal xb1 : STD_LOGIC_VECTOR(9 downto 0);-- := std_logic_vector(to_unsigned(146, 10));
signal yb1 : STD_LOGIC_VECTOR(9 downto 0);-- := std_logic_vector(to_unsigned(62, 10));
signal xb2 : STD_LOGIC_VECTOR(9 downto 0);-- := std_logic_vector(to_unsigned(146, 10));
signal yb2 : STD_LOGIC_VECTOR(9 downto 0);-- := std_logic_vector(to_unsigned(62, 10));
signal prevxball, prevyball, prevrball, prevxb1, prevyb1, prevxb2, prevyb2 : STD_LOGIC_VECTOR(9 downto 0);
signal upcount, downcount, leftcount, rightcount, forwardcount, backwardcount : INTEGER;
signal gocount : STD_LOGIC_VECTOR(2 downto 0); -- gocount bepaalt of batje 1, batje 2, ball of menu wordt bediend
signal gopressed : STD_LOGIC; 
signal ramcounter : STD_LOGIC_VECTOR(3 downto 0);
signal refresh_counter : STD_LOGIC := '0';
signal tmpwea2 : STD_LOGIC_VECTOR(0 downto 0);

begin

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
        -- down and up verkeerd om 
        -- hoe straal van de ball begrenzen
        -- zorgen dat omtrek van gehele bal binnen de cirkel blijft
        -- punt van batje is linksboven, rekening mee houden?
        if (up = '1') then 
            upcount <= upcount + 1;
        end if;
        if (upcount > 2500000) then
            if (gocount = 0) then
                if (yb1 < 485) then
                yb1 <= yb1 + "1";
                end if;
            elsif (gocount = 1) then 
                if (yb1 < 485) then
                yb2 <= yb2 + "1";
                end if;
            elsif (gocount = 2) then 
                if (yb1 < 485) then
                yball <= yball + "1";
                end if; 
            end if;
            upcount <= 0;
        end if;

        if (down = '1') then 
            downcount <= downcount + 1;
        end if;
        if (downcount > 2500000) then
            if (gocount = 0) then
                if (yb1 > 62) then 
                yb1 <= yb1 - "1"; 
                end if;
            elsif (gocount = 1) then 
                if (yb2 > 62) then 
                yb2 <= yb2 - "1";
                end if;
            elsif (gocount = 2) then 
                if (yball > 62) then
                yball <= yball - "1";
                end if;
            end if; 
            downcount <= 0;
        end if;
 
        if (left = '1') then 
            leftcount <= leftcount + 1;
        end if;
        if (leftcount > 2500000) then
            if (gocount = 0) then
                if (xb1 > 145) then
                xb1 <= xb1 - "1"; 
                end if;
            elsif (gocount = 1) then 
                if (xb2 > 145) then 
                xb2 <= xb2 - "1";
                end if;
            elsif (gocount = 2) then
                if (xball > 145) then  
                xball <= xball - "1";
                end if;
            end if; 
            leftcount <= 0;
        end if;
        
        if (right = '1') then 
            rightcount <= rightcount + 1;
        end if;
        if (rightcount > 2500000) then
            if (gocount = 0) then
                if (xb1 < 780) then
                xb1 <= xb1 + "1"; 
                end if;
            elsif (gocount = 1) then 
                if (xb1 < 780) then
                xb2 <= xb2 + "1";
                end if;
            elsif (gocount = 2) then 
                if (xb1 < 780) then
                xball <= xball + "1";
                end if;
            end if; 
            rightcount <= 0;
        end if;
        
        if (forward = '1' and gocount = 2 ) then
            forwardcount <= forwardcount + 1;
        end if;
        if (forwardcount > 2500000) then
            if (rball > 0) then 
            rball <= rball - "1";
            end if;
            forwardcount <= 0;
        end if;
        
        if (backward = '1' and gocount = 2 ) then
            backwardcount <= backwardcount + 1;
        end if;
        if (backwardcount > 2500000) then
            if (rball < 50) then 
            rball <= rball + "1";
            end if;
            forwardcount <= 0;
        end if;        
    end if;
end process;

--process(clk25Mhz)
--begin
--    if falling_edge(clk25MHz) then  
--        if vcount > 0 then  
--            if ramcounter < 13 and refresh_counter = '0' then
--                ramcounter <= ramcounter + 1;
--            else 
--                ramcounter <= (others => '0');
--                refresh_counter <= '1'; 
--            end if;     
--        elsif vcount = 0 then
--            refresh_counter <= '0';
--        end if;
        
--        if ramcounter = 3 then
--            if (prevxball = not xball) then 
--                dina2 <= xball;  
--                addra2 <= "0010";
--                prevxball <= xball;
--                tmpwea2 <= "0";
--            else 
--                tmpwea2 <= "1";
--            end if;
--        elsif ramcounter = 4 then
--            if (prevyball = not yball) then 
--                dina2 <= yball;  
--                addra2 <= "0011";
--                prevyball <= yball;
--                tmpwea2 <= "0";
--            else 
--                tmpwea2 <= "1";
--            end if;
--        elsif ramcounter = 5 then
--            if (prevrball = not rball) then 
--                dina2 <= rball; 
--                addra2 <= "0100"; 
--                prevrball <= rball;
--                tmpwea2 <= "0";
--            else 
--                tmpwea2 <= "1";
--            end if;
--        elsif ramcounter = 6 then
--            if (prevxb1 = not xb1) then 
--                dina2 <= "0011111010"; --xb1; 250
--                addra2 <= "0101"; 
--                prevxb1 <= xb1;
--                tmpwea2 <= "0";
--            else 
--                tmpwea2 <= "1";
--            end if;  
--        elsif ramcounter = 7 then
--            if (prevyb1 = not yb1) then 
--                dina2 <= "0001100100"; --yb1; 100
--                addra2 <= "0110"; 
--                prevyb1 <= yb1;
--                tmpwea2 <= "0";
--            else 
--                tmpwea2 <= "1";
--                end if;  
--        elsif ramcounter = 8 then
--            if (prevxb2 = not xb2) then 
--                dina2 <= xb2;  
--                addra2 <= "0111";
--                prevxb2 <= xb2;
--                tmpwea2 <= "0";
--            else 
--                tmpwea2 <= "1";
--            end if;
--        elsif ramcounter = 9 then
--            if (prevyb2 = not yb2) then
--                dina2 <= yb2;
--                addra2 <= "1000";
--                prevyb2 <= yb2;
--                tmpwea2 <= "0";
--            else
--                tmpwea2 <= "1";
--            end if;
--        else
--            tmpwea2 <= "1"; -- na adres 7 zit niets dus we kan hier al uit worden gezet
--        end if;
--    end if;
--end process;

end Behavioral;

