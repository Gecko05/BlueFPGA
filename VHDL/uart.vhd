----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:32:40 08/01/2020 
-- Design Name: 
-- Module Name:    system - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity system is
	port(
		CLK_100MHz : in STD_LOGIC;
		UART_TX : out STD_LOGIC;
		UART_RX : in STD_LOGIC;
		SevenSegment : out STD_LOGIC_VECTOR(0 TO 7);
		SevenSegmentEnable : out STD_LOGIC_VECTOR(0 TO 2);
		o_LED1 : OUT STD_LOGIC;
		o_LED2 : OUT STD_LOGIC;
		o_LED3 : OUT STD_LOGIC;
		o_LED4 : OUT STD_LOGIC
	);
end system;

architecture rtl of system is
	constant CLK_19200 : natural := 5208;
	signal CLK_CNT : natural range 0 to CLK_19200;
	signal UART_STATE : natural range 0 to 3 := 0;
	signal RX_BUFFER : STD_LOGIC_VECTOR (0 TO 7) := STD_LOGIC_VECTOR(to_unsigned(0, 8));
	signal RX_DATA : STD_LOGIC_VECTOR (0 TO 7) := STD_LOGIC_VECTOR(to_unsigned(5, 8));
	signal CLK_PULSE : STD_LOGIC := '0';
	signal INDX : natural range 0 to 7 := 0;
	signal binary_n : STD_LOGIC_VECTOR(0 to 3);
	signal UART_RX_IN : STD_LOGIC;
	signal LED_STATE : STD_LOGIC := '1';
	signal LED2_STATE : STD_LOGIC := '0';
	signal LED3_STATE : STD_LOGIC := '0';
	signal LED4_STATE : STD_LOGIC := '0';
	signal TX_SAMPLE_DATA : STD_LOGIC_VECTOR(0 TO 9);
	signal INDX_TX : natural range 0 to 9 := 0;
begin
	UART_RX_IN <= UART_RX;
	clock_loop : process (CLK_100MHz,CLK_CNT, UART_STATE, UART_RX_IN, RX_DATA, binary_n, LED_STATE, LED2_STATE, LED3_STATE) begin
		o_LED1 <= LED_STATE;
		o_LED2 <= LED2_STATE;
		o_LED3 <= LED3_STATE;
		o_LED4 <= LED4_STATE;
		if rising_edge(CLK_100MHz) then
			if CLK_CNT >= CLK_19200 - 1 or CLK_CNT < 0 then
				CLK_CNT <= 0;
				CLK_PULSE <= not(CLK_PULSE);
				LED4_STATE <= CLK_PULSE;
-----------------------------------------------------------------------
				if UART_STATE = 1 then -- Check to start receiving
					if UART_RX_IN = '0' then
						UART_STATE <= 2;
						INDX <= 0;
					else
						UART_STATE <= 0;
					end if;
				elsif UART_STATE = 2 and INDX < 8 then -- Gather data
					RX_BUFFER(INDX) <= UART_RX_IN;
					LED_STATE <= not(LED_STATE);
					INDX <= INDX + 1;
				elsif UART_STATE = 2 and INDX >= 8 then -- Stop receiving
					if UART_RX_IN = '1' then -- Successful transmission
						RX_DATA <= RX_BUFFER;
						UART_STATE <= 0;
					else
						UART_STATE <= 0;
					end if;
				else
					UART_STATE <= 0;
				end if;
			elsif UART_STATE = 0 then -- IDLE
				LED2_STATE <= not(LED2_STATE);
				if UART_RX_IN = '0' then
					UART_STATE <= 1; -- Receive
					--CLK_CNT <= 2604; -- Start sampling with offset
				end if;
			else
				LED3_STATE <= not(LED3_STATE);
				CLK_CNT <= CLK_CNT + 1;
			end if;
		end if;
-----------------------------------------------------------------------
		SevenSegmentEnable <= "001";
		binary_n <= RX_DATA(4 TO 7);
		if binary_n = "0000" then
			SevenSegment <= not(X"3F");
		elsif binary_n = "0001" then
			SevenSegment <= not(X"06");
		elsif binary_n = "0010" then
			SevenSegment <= not(X"5B");
		elsif binary_n = "0011" then
			SevenSegment <= not(X"4F");
		elsif binary_n = "0100" then
			SevenSegment <= not(X"66");
		elsif binary_n = "0101" then
			SevenSegment <= not(X"6D");
		elsif binary_n = "0110" then
			SevenSegment <= not(X"7D");
		elsif binary_n = "0111" then
			SevenSegment <= not(X"07");
		elsif binary_n = "1000" then
			SevenSegment <= not(X"7F");
		elsif binary_n = "1001" then
			SevenSegment <= not(X"6F");
		elsif binary_n = "1010" then
			SevenSegment <= not(X"77");
		elsif binary_n = "1011" then
			SevenSegment <= not(X"7C");
		elsif binary_n = "1100" then
			SevenSegment <= not(X"39");
		elsif binary_n = "1101" then
			SevenSegment <= not(X"5E");
		elsif binary_n = "1110" then
			SevenSegment <= not(X"79");
		elsif binary_n = "1111" then
			SevenSegment <= not(X"71");
		else
			SevenSegment <= not(X"00");
		end if;
---------------------------------------------------------------------
	end process;
	UART_TX <= '1';
end rtl;

