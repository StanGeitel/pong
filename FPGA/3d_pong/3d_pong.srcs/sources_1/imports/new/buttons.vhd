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
    dina2 : out STD_LOGIC_VECTOR(9 downto 0);
    sw : in std_logic_vector (8 downto 0));
end buttons;

architecture Behavioral of buttons is

signal xball : STD_LOGIC_VECTOR(9 downto 0):= std_logic_vector(to_unsigned(170, 10));
signal yball : STD_LOGIC_VECTOR(9 downto 0) := std_logic_vector(to_unsigned(80, 10));
signal rball : STD_LOGIC_VECTOR(9 downto 0) := std_logic_vector(to_unsigned(13, 10));
signal xb1 : STD_LOGIC_VECTOR(9 downto 0) := std_logic_vector(to_unsigned(146, 10));
signal yb1 : STD_LOGIC_VECTOR(9 downto 0) := std_logic_vector(to_unsigned(62, 10));
signal xb2 : STD_LOGIC_VECTOR(9 downto 0) := std_logic_vector(to_unsigned(146, 10));
signal yb2 : STD_LOGIC_VECTOR(9 downto 0) := std_logic_vector(to_unsigned(62, 10));
signal control : STD_LOGIC_VECTOR(9 downto 0) := std_logic_vector(to_unsigned(8, 10)); -- 4 "0000000100" hoofdmenu
signal score :  STD_LOGIC_VECTOR(9 downto 0) := std_logic_vector(to_unsigned(37, 10)); -- 1-5
signal upcount, downcount, leftcount, rightcount, forwardcount, backwardcount, selcount : INTEGER;
signal gocount : STD_LOGIC_VECTOR(1 downto 0); -- gocount bepaalt of batje 1, batje 2, ball of menu wordt bediend
signal gopressed : STD_LOGIC;
signal refresh_counter : STD_LOGIC := '0';
signal tmpwea2 : STD_LOGIC_VECTOR(0 downto 0);

        -- Job: menu bedienen en scrollen tussen opties met FPGA
        -- Remco: full adder toevoegen voor score
        -- Lucah: ball voor schuine lijnen ipv schuine lijnen voor bal
        -- Lucah: transparantie van bal bij goede straal (die diepte voorstelt)

component two_bit_adder
        Port( A0 : in STD_LOGIC;
              A1 : in STD_LOGIC;
              B0 : in STD_LOGIC;
              B1 : in STD_LOGIC;
              C_in : in STD_LOGIC;
              S0 : out STD_LOGIC;
              S1 : out STD_LOGIC;
              C_out : out STD_LOGIC);
        end component;
                    
begin

FBA0: two_bit_adder port map(
      A0 => sw(0), 
      A1 => sw(1), 
      B0 => sw(2), 
      B1 => sw(3), 
      C_in => sw(8), 
      S0 => score(0),
      S1 => score(1),
      C_out => score(2));
      
FBA1: two_bit_adder port map(
        A0 => sw(4), 
        A1 => sw(5), 
        B0 => sw(6), 
        B1 => sw(7), 
        C_in => sw(8), 
        S0 => score(5),
        S1 => score(6),
        C_out => score(7));   
        
process(clk25MHz)
variable tmpcontrol : STD_LOGIC_VECTOR(9 downto 0);
begin
    if rising_edge(clk25MHz) then
        
        if (control(3 downto 2) = "01") then
            tmpcontrol := control;
            if (down = '1') then 
                downcount <= downcount + 1;
            end if;
            if (downcount > 25000000) then
                if (control(1 downto 0) = "00") then
                    tmpcontrol(1 downto 0) := "01";
                elsif (control(1 downto 0) = "01") then
                    tmpcontrol(1 downto 0) := "10";
                elsif (control(1 downto 0) = "10") then
                    tmpcontrol(1 downto 0) := "11";
                elsif (control(1 downto 0) = "11") then
                    tmpcontrol(1 downto 0) := "00";                
                end if;
                downcount <= 0;
            end if;
            control <= tmpcontrol; 
            
--            if (go = '1') then 
--                selcount <= selcount + 1;
--            end if;
--            if (selcount > 25000000) then
--            end if;
        end if; 
        
        if (control(3 downto 2) = "10") then
            tmpcontrol := control;
            if (down = '1') then 
                downcount <= downcount + 1;
            end if;
            if (downcount > 25000000) then
                if (control(1 downto 0) = "00") then
                    tmpcontrol(1 downto 0) := "01";
                elsif (control(1 downto 0) = "01") then
                    tmpcontrol(1 downto 0) := "10";
                elsif (control(1 downto 0) = "10") then
                    tmpcontrol(1 downto 0) := "00";               
                end if;
                downcount <= 0;
            end if;
            control <= tmpcontrol; 
        end if;
                
        if (control(3 downto 2) = "11") then
            tmpcontrol := control;
            if (down = '1') then 
                downcount <= downcount + 1;
            end if;
            if (downcount > 25000000) then
                if (control(1 downto 0) = "00") then
                    tmpcontrol(1 downto 0) := "01";
                elsif (control(1 downto 0) = "01") then
                    tmpcontrol(1 downto 0) := "00";               
                end if;
                downcount <= 0;
            end if;
            control <= tmpcontrol; 
        end if;       
                            
--            if (go = '1' and gopressed = '0') then 
--                gopressed <= '1';
--                if (control(1 downto 0) = "00") then
--                    tmpcontrol(5 downto 2) := "0000";
--                elsif (control(1 downto 0) = "01") then
--                    tmpcontrol(1 downto 0) := "0100";
--                elsif (control(1 downto 0) = "10") then
--                    tmpcontrol(1 downto 0) := "1000"; 
--                elsif (control(1 downto 0) = "11") then
--                    tmpcontrol(1 downto 0) := "0000"; 
--                end if;
--            end if;
--            if (go = '0' and gopressed = '1') then
--                gopressed <= '0';
--            end if;

        if (control(3 downto 2) = "00") then  
        
            if (go = '1' and gopressed = '0') then 
                gopressed <= '1';
                gocount <= gocount + "1";
            end if;
            if (go = '0' and gopressed = '1') then
                gopressed <= '0';
            end if;
            
            if (gocount = 3) then
                tmpcontrol := control;
                tmpcontrol(3 downto 0) := "1100";
                control <= tmpcontrol;         
            end if;               
        
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

