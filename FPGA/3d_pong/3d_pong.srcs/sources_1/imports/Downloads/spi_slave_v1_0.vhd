--------------------------------------------------------------------------------
--
--   FileName:         spi_slave.vhd
--   Dependencies:     none
--   Design Software:  Quartus II 32-bit Version 11.1 Build 173 SJ Full Version
--
--   HDL CODE IS PROVIDED "AS IS."  DIGI-KEY EXPRESSLY DISCLAIMS ANY
--   WARRANTY OF ANY KIND, WHETHER EXPRESS OR IMPLIED, INCLUDING BUT NOT
--   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
--   PARTICULAR PURPOSE, OR NON-INFRINGEMENT. IN NO EVENT SHALL DIGI-KEY
--   BE LIABLE FOR ANY INCIDENTAL, SPECIAL, INDIRECT OR CONSEQUENTIAL
--   DAMAGES, LOST PROFITS OR LOST DATA, HARM TO YOUR EQUIPMENT, COST OF
--   PROCUREMENT OF SUBSTITUTE GOODS, TECHNOLOGY OR SERVICES, ANY CLAIMS
--   BY THIRD PARTIES (INCLUDING BUT NOT LIMITED TO ANY DEFENSE THEREOF),
--   ANY CLAIMS FOR INDEMNITY OR CONTRIBUTION, OR OTHER SIMILAR COSTS.
--
--   Version History
--   Version 1.0 7/5/2012 Scott Larson
--     Initial Public Release
--
--------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY spi_slave IS
  GENERIC(
    cpol    : STD_LOGIC := '0';  --spi clock polarity mode
    cpha    : STD_LOGIC := '1';  --spi clock phase mode
    d_width : INTEGER := 8);     --data width in bits
  PORT(
    sclk         : IN     STD_LOGIC;  --spi clk from master
    mosi         : IN     STD_LOGIC;  --master out, slave in
    rrdy         : BUFFER STD_LOGIC := '0';  --receive ready bit
    roe          : BUFFER STD_LOGIC := '0';  --receive overrun error bit
    rx_data      : OUT    STD_LOGIC_VECTOR(d_width-1 DOWNTO 0) := (OTHERS => '0'));  --receive register output to logic
END spi_slave;

ARCHITECTURE logic OF spi_slave IS
  SIGNAL mode    : STD_LOGIC;  --groups modes by clock polarity relation to data
  SIGNAL clk     : STD_LOGIC;  --clock
  SIGNAL bit_cnt : STD_LOGIC_VECTOR(d_width+8 DOWNTO 0);  --'1' for active transaction bit
  SIGNAL rx_buf  : STD_LOGIC_VECTOR(d_width-1 DOWNTO 0) := (OTHERS => '0');  --receiver buffer
BEGIN
  --adjust clock so writes are on rising edge and reads on falling edge
  mode <= cpol XOR cpha;  --'1' for modes that write on rising edge
  WITH mode SELECT
    clk <= sclk WHEN '1',
           NOT sclk WHEN OTHERS;

  --keep track of miso/mosi bit counts for data alignmnet
  PROCESS(clk)
  BEGIN
      IF(rising_edge(clk)) THEN                                  --new bit on miso/mosi
        bit_cnt <= bit_cnt(d_width+8-1 DOWNTO 0) & '0';          --shift active bit indicator
      END IF;
  END PROCESS;

  PROCESS(clk)
  BEGIN 
    --rrdy register
    IF(bit_cnt(10) = '1' AND falling_edge(clk)) THEN
      rrdy <= mosi;  --new value written over spi bus
    ELSIF(bit_cnt(d_width+8) = '1' AND falling_edge(clk)) THEN
      rrdy <= '1';   --set when new data received
    END IF;
    
    --roe register
    IF(rrdy = '1' AND bit_cnt(d_width+8) = '1' AND falling_edge(clk)) THEN
      roe <= '1';   --set by actual overrun
    ELSIF(bit_cnt(11) = '1' AND falling_edge(clk)) THEN
      roe <= mosi;  --new value written by spi bus
    END IF;
    
    --receive registers
    --write to the receive register from master
    FOR i IN 0 TO d_width-1 LOOP          
      IF(bit_cnt(i+9) = '1' AND falling_edge(clk)) THEN
        rx_buf(d_width-1-i) <= mosi;
      END IF;
    END LOOP;
  
  rx_data <= rx_buf;
    
  END PROCESS;
END logic;
