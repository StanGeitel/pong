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

signal xball : STD_LOGIC_VECTOR(9 downto 0):= std_logic_vector(to_unsigned(170, 10));
signal yball : STD_LOGIC_VECTOR(9 downto 0) := std_logic_vector(to_unsigned(80, 10));
signal rball : STD_LOGIC_VECTOR(9 downto 0) := std_logic_vector(to_unsigned(13, 10));
signal xb1 : STD_LOGIC_VECTOR(9 downto 0) := std_logic_vector(to_unsigned(146, 10));
signal yb1 : STD_LOGIC_VECTOR(9 downto 0) := std_logic_vector(to_unsigned(62, 10));
signal xb2 : STD_LOGIC_VECTOR(9 downto 0) := std_logic_vector(to_unsigned(146, 10));
signal yb2 : STD_LOGIC_VECTOR(9 downto 0) := std_logic_vector(to_unsigned(62, 10));
signal control : STD_LOGIC_VECTOR(9 downto 0) := std_logic_vector(to_unsigned(4, 10)); -- 4 "0000000100" hoofdmenu
signal score :  STD_LOGIC_VECTOR(9 downto 0) := std_logic_vector(to_unsigned(37, 10)); -- 1-5
signal upcount, downcount, leftcount, rightcount, forwardcount, backwardcount : INTEGER;
signal gocount : STD_LOGIC_VECTOR(1 downto 0); -- gocount bepaalt of batje 1, batje 2, ball of menu wordt bediend
signal gopressed, uppressed, downpressed : STD_LOGIC; -- uppressed en downpressed toegevoegd
signal refresh_counter, tmpfirst : STD_LOGIC := '0'; -- tmpfirst toegevoegd
signal tmpwea2 : STD_LOGIC_VECTOR(0 downto 0);

        -- menu bedienen en scrollen tussen opties met FPGA
        -- Remco: full adder toevoegen voor score
        -- Lucah: ball voor schuine lijnen ipv schuine lijnen voor bal
        -- Lucah: transparantie van bal bij goede straal (die diepte voorstelt)
        -- Bij samenvoegen op letten dat andere entity nog extra in- en outputs heeft voor de tweede ram
        
begin
process(clk25MHz)
variable tmpcontrol : STD_LOGIC_VECTOR(9 downto 0);
begin
    if rising_edge(clk25MHz) then
        
        if (control(3 downto 2) = "01") then
            tmpcontrol := control and "1111111100";
            if (down = '1' and downpressed = '0') then
                downpressed <= '1';
                if (control(1 downto 0) = "00") then
                    tmpcontrol(1 downto 0) := "01";
                elsif (control(1 downto 0) = "01") then
                    tmpcontrol(1 downto 0) := "10";
                elsif (control(1 downto 0) = "10") then
                        tmpcontrol(1 downto 0) := "11";
                elsif (control(1 downto 0) = "11") then
                            tmpcontrol(1 downto 0) := "00";                
                end if;
            end if;
            if (down = '0' and downpressed = '1') then
                downpressed <= '0';
            end if; 
            
            if (go = '1' and gopressed = '0') then 
                gopressed <= '1';
                if (control(1 downto 0) = "00") then
                    tmpcontrol(5 downto 2) := "0000";
                elsif (control(1 downto 0) = "01") then
                    tmpcontrol(1 downto 0) := "0100";
                elsif (control(1 downto 0) = "10") then
                    tmpcontrol(1 downto 0) := "1000"; 
                elsif (control(1 downto 0) = "11") then
                    tmpcontrol(1 downto 0) := "0000"; 
                end if;
            end if;
            if (go = '0' and gopressed = '1') then
                gopressed <= '0';
            end if;
            
            control <= tmpcontrol; 
        end if; 

        if (control(3 downto 2) = "00") then  
        
            if (go = '1' and gopressed = '0') then 
                gopressed <= '1';
                gocount <= gocount + "1";
            end if;
            if (go = '0' and gopressed = '1') then
                gopressed <= '0';
            end if;
            
        if (gocount = 3) then
            if (tmpfirst = '0') then
                tmpcontrol := (control and "1111110000") or "0000001100"; -- eerst twee losse regels
                tmpfirst <= '1';
            end if;
            if (down = '1' and downpressed = '0') then
                downpressed <= '1';
                tmpcontrol := control and "1111111101"; -- tweede select in menu (uitbreiden naar door blijven scrollen!)
            end if;
            if (down = '0' and downpressed = '1') then
                downpressed <= '0';
            end if;
            
            if (tmpfirst = '1' and go = '1' and gopressed = '0') then -- als het goed is gaat gocount automatisch verder vanwege andere if statement hierboven
--                gopressed <= '1'; -- eventueel weghalen
                tmpfirst <= '0';
                if (control(1 downto 0) = "00") then
                    tmpcontrol := control and "1111110000";  
                elsif (control(1 downto 0) = "01") then
                    tmpcontrol := control and "1111110100";
                end if;
            end if;
--            if (go = '0' and gopressed = '1') then -- evt weghalen
--                gopressed <= '0';  -- eventueel weghalen vanwege andere if statement
--            end if;                   
            control <= tmpcontrol;         
        end if;
        -- TOT HIER
        
        if (down = '1') then 
            downcount <= downcount + 1;
        end if;
        if (downcount > 250000) then
            if (gocount = 0) then
                if (yb1 < 385) then
                    yb1 <= yb1 + "1";
                end if;
            elsif (gocount = 1) then 
                if (yb2 < 385) then
                    yb2 <= yb2 + "1";
                end if;
            elsif (gocount = 2) then 
                if ( (yball + rball) < 485) then
                    yball <= yball + "1";
                end if; 
            end if;
            downcount <= 0;
        end if;

        if (up = '1') then 
            upcount <= upcount + 1;
        end if;
        if (upcount > 250000) then
            if (gocount = 0) then
                if (yb1 > 62) then 
                    yb1 <= yb1 - "1"; 
                end if;
            elsif (gocount = 1) then 
                if (yb2 > 62) then 
                    yb2 <= yb2 - "1";
                end if;
            elsif (gocount = 2) then 
                if ( (yball - rball) > 62) then
                    yball <= yball - "1";
                end if;
            end if; 
            upcount <= 0;
        end if;
 
        if (left = '1') then 
            leftcount <= leftcount + 1;
        end if;
        if (leftcount > 250000) then
            if (gocount = 0) then
                if (xb1 > 145) then
                    xb1 <= xb1 - "1"; 
                end if;
            elsif (gocount = 1) then 
                if (xb2 > 145) then 
                    xb2 <= xb2 - "1";
                end if;
            elsif (gocount = 2) then
                if ( (xball - rball) > 145) then
                    xball <= xball - "1";
                end if;
            end if; 
            leftcount <= 0;
        end if;
        
        if (right = '1') then 
            rightcount <= rightcount + 1;
        end if;
        if (rightcount > 250000) then
            if (gocount = 0) then
                if (xb1 < 630) then
                    xb1 <= xb1 + "1"; 
                end if;
            elsif (gocount = 1) then 
                if (xb2 < 630) then
                    xb2 <= xb2 + "1";
                end if;
            elsif (gocount = 2) then 
                if ( (xball + rball) < 780) then
                    xball <= xball + "1";
                end if;
            end if; 
            rightcount <= 0;
        end if;
        
        if (forward = '1' and gocount = 2 ) then
            forwardcount <= forwardcount + 1;
        end if;
        if (forwardcount > 1000000) then
            if (rball > 12) then 
                rball <= rball - "1";
            end if;
            forwardcount <= 0;
        end if;
        
        if (backward = '1' and gocount = 2 ) then
            backwardcount <= backwardcount + 1;
        end if;
        if (backwardcount > 1000000) then
            if (rball < 50) then 
                rball <= rball + "1";
            end if;
            backwardcount <= 0;
        end if; 
        
        end if;       
    end if;
end process;

process(clk25Mhz)
variable ramcounter : INTEGER := 0;
begin
wea2 <= tmpwea2;
    if falling_edge(clk25MHz) then  
        if vcount > 0 then  
            if ramcounter < 9 and refresh_counter = '0' then
                ramcounter := ramcounter + 1;
            else 
                ramcounter := 0;
                refresh_counter <= '1'; 
                tmpwea2 <= "0";
            end if;     
        elsif vcount = 0 then
            refresh_counter <= '0';
        end if;
        
        -- NIEUW TOEGEVOEGD
        if ramcounter = 1 then
            dina2 <= control;  
            addra2 <= "0000";
            tmpwea2 <= "1";
        end if;
        if ramcounter = 2 then
            dina2 <= score; 
            addra2 <= "0001";
            tmpwea2 <= "1";
        end if;
        -- TOT HIER
        
        if ramcounter = 3 then
                dina2 <= xball;  
                addra2 <= "0010";
                tmpwea2 <= "1";
        end if;
        if ramcounter = 4 then
                dina2 <= yball;  
                addra2 <= "0011";
                tmpwea2 <= "1";
        end if;
        if ramcounter = 5 then
                dina2 <= rball; 
                addra2 <= "0100"; 
                tmpwea2 <= "1";
        end if;
        if ramcounter = 6 then
                dina2 <= xb1;
                addra2 <= "0101"; 
                tmpwea2 <= "1";
        end if;
        if ramcounter = 7 then 
                dina2 <= yb1; 
                addra2 <= "0110"; 
                tmpwea2 <= "1";
        end if;
        if ramcounter = 8 then
                dina2 <= xb2;  
                addra2 <= "0111";
                tmpwea2 <= "1";
        end if;
        if ramcounter = 9 then
                dina2 <= yb2;
                addra2 <= "1000";
                tmpwea2 <= "1";
        end if;
    end if;
end process;

end Behavioral;

