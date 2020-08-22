----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:31:33 08/15/2020 
-- Design Name: 
-- Module Name:    System - Behavioral 
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

entity System is
	PORT (
		i_PB : in STD_LOGIC_VECTOR (0 TO 0);
		CLK_100MHz : in STD_LOGIC;
		SevenSegment : out STD_LOGIC_VECTOR (0 TO 7);
		SevenSegmentEnable : out STD_LOGIC_VECTOR (2 DOWNTO 0);
		o_LED : out STD_LOGIC_VECTOR (0 TO 3);
		i_UART_RX : in STD_LOGIC
	);
end System;

architecture Behavioral of System is
	constant CLK_19200 : natural := 100000000;--5208;
	signal CLK_CNT : natural range 0 to CLK_19200;
	--signal DATA : natural range 0 to 15;
	signal CLK_PULSE : STD_LOGIC := '0';
	signal i_PB0 : STD_LOGIC;
	signal r_Hex : STD_LOGIC_VECTOR(0 TO 7);
	signal r_RXDATA : STD_LOGIC_VECTOR(7 DOWNTO 0);
	
	COMPONENT UART_RX
	PORT(
		i_RX : IN std_logic;
		i_CLK100MHz : IN std_logic;          
		o_LEDs : OUT STD_LOGIC_VECTOR (0 TO 3);
		o_RXDATA : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;
begin
	Inst_UART_RX: UART_RX PORT MAP(
		i_RX => i_UART_RX,
		i_CLK100MHz => CLK_100MHz,
		o_LEDs => o_LED,
		o_RXDATA => r_RXDATA
	);

	SevenSegmentEnable <= "110";
	i_PB0 <= not(i_PB(0)); -- Invert for pullup
	clockLoop : process (CLK_100MHz, r_Hex, r_RXDATA) begin
		if rising_edge(CLK_100MHz) then
--			if CLK_CNT >= CLK_19200 - 1 then
--				CLK_CNT <= 0;
--				CLK_PULSE <= not(CLK_PULSE);
				--DATA <= to_integer(r_RXDATA);
--				if DATA <= 15 then
--					DATA <= DATA + 1;
--				else
--					DATA <= 0;
--				end if;
				case r_RXDATA is
					when x"00"=>
						r_Hex <= X"3F";
					when x"01" =>
						r_Hex <= X"06";
					when x"02" =>
						r_Hex <= X"5B";
					when x"03" =>
						r_Hex <= X"4F";
					when x"04" =>
						r_Hex <= X"66";
					when x"05" =>
						r_Hex <= X"6D";
					when x"06" =>
						r_Hex <= X"7D";
					when x"07" =>
						r_Hex <= X"07";
					when x"08" =>
						r_Hex <= X"7F";
					when x"09" =>
						r_Hex <= X"6F";
					when x"0A" =>
						r_Hex <= X"77";
					when x"0B"=>
						r_Hex <= X"7C";
					when x"0C" =>
						r_Hex <= X"39";
					when x"0D" =>
						r_Hex <= X"5E";
					when x"0E"=>
						r_Hex <= X"79";
					when x"0F"=>
						r_Hex <= x"71";
					when others =>
						r_Hex <= x"00";
				end case;
--			else
--				CLK_CNT <= CLK_CNT + 1;
--			end if;
		end if;
	end process;
	
	SevenSegment <= not(r_Hex);
end Behavioral;

