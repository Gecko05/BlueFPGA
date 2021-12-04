----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:30:57 08/15/2020 
-- Design Name: 
-- Module Name:    UART_RX - Behavioral 
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity UART_RX is
    Port ( i_RX : in  STD_LOGIC;
           i_CLK_100MHz : in  STD_LOGIC;
			  o_LEDs : out STD_LOGIC_VECTOR (0 TO 2);
			  o_RXDATA : out STD_LOGIC_VECTOR (7 DOWNTO 0));
end UART_RX;

architecture Behavioral of UART_RX is
	signal r_DATA : STD_LOGIC_VECTOR (7 DOWNTO 0) := "00000000";
	signal r_STATE : natural range 0 to 4 := 0;
	signal r_BIT : natural range 0 to 7 := 7;
	constant CLK_19200 : natural := 5208;
	signal CLK_CNT : natural range 0 to CLK_19200;
	signal CLK_PULSE : STD_lOGIC := '0';
	signal LEDS : STD_LOGIC_VECTOR (0 TO 2) := "000";
begin
	receiveLoop : process (i_RX, i_CLK_100MHz, r_DATA) begin
		if rising_edge(i_CLK_100MHz) then
			if CLK_CNT = CLK_19200 - 1 then
				CLK_CNT <= 0;
				CLK_PULSE <= not(CLK_PULSE);
			else 
				CLK_CNT <= CLK_CNT + 1;
			end if;
			-- State machine for RX
			if r_STATE = 0 then -- IDLE
				LEDS(0) <= '1';
				if i_RX <= '0' then
					r_STATE <= 1;
					CLK_CNT <= 0;
					CLK_PULSE <= not(CLK_PULSE);
				end if;
			elsif r_STATE = 1 and CLK_CNT = ((CLK_19200 - 1)/2) then -- CHECK MIDDLE
				if i_RX <= '0' then -- FOUND MIDDLE 
					CLK_CNT <= 0;
					LEDS(0) <= '0';
					LEDS(1) <= '1';
					CLK_PULSE <= not(CLK_PULSE);
					r_STATE <= 2;
					r_BIT <= 0;
				end if;
			elsif r_STATE = 2 and CLK_CNT = CLK_19200 - 2 then -- GATHER DATA
				if r_BIT = 7 then
					r_DATA(r_BIT) <= i_RX;
					LEDS(2) <= '0';
					r_STATE <= 3; -- Look for stop bit
				elsif r_BIT < 7 then
					LEDS(1) <= '0';
					LEDS(2) <= '1';
					r_DATA(r_BIT) <= i_RX;
					r_BIT <= r_BIT + 1;
				else
					r_STATE <= 0;
				end if;
			elsif r_STATE = 3 and CLK_CNT = CLK_19200 -2 then -- Wait before retuning to IDLE
				r_STATE <= 0; -- Return to IDLE
			end if;
			o_RXDATA <= r_DATA;
			o_LEDs <= LEDS;
		end if;
	end process;

end Behavioral;

