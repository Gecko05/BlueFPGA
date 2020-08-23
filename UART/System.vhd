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
--		i_PB : in STD_LOGIC_VECTOR (0 TO 0);
		CLK_100MHz : in STD_LOGIC;
		SevenSegment : out STD_LOGIC_VECTOR (0 TO 7);
		SevenSegmentEnable : out STD_LOGIC_VECTOR (2 DOWNTO 0);
		o_LED : out STD_LOGIC_VECTOR (0 TO 2);
		i_UART_RX : in STD_LOGIC
	);
end System;

architecture Behavioral of System is
	constant CLK_19200 : natural := 416500;--5208;
	signal CLK_CNT : natural range 0 to CLK_19200;
	signal CLK_PULSE : STD_LOGIC := '0';
	signal r_RXDATA : STD_LOGIC_VECTOR(7 DOWNTO 0);
	
	COMPONENT UART_RX
	PORT(
		i_RX : IN std_logic;
		i_CLK100MHz : IN std_logic;          
		o_LEDs : OUT STD_LOGIC_VECTOR (0 TO 2);
		o_RXDATA : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;
	
	COMPONENT segDisp
	PORT(
		i_CLK : IN std_logic;
		i_DATA : IN std_logic_vector(7 downto 0);          
		o_SevenSegment : OUT std_logic_vector(0 to 7);
		o_SevenSegmentEnable : OUT std_logic_vector(2 downto 0)
		);
	END COMPONENT;
begin
	Inst_UART_RX: UART_RX PORT MAP(
		i_RX => i_UART_RX,
		i_CLK100MHz => CLK_100MHz,
		o_LEDs => o_LED,
		o_RXDATA => r_RXDATA
	);
	Inst_segDisp: segDisp PORT MAP(
		i_CLK => CLK_PULSE,
		o_SevenSegment => SevenSegment,
		o_SevenSegmentEnable => SevenSegmentEnable,
		i_DATA => r_RXDATA
	);
	clkLoop : process (CLK_100MHz, CLK_CNT, CLK_PULSE) begin
		if rising_edge(CLK_100MHz) then
			if CLK_CNT >= CLK_19200 - 1 then
				CLK_CNT <= 0;
				CLK_PULSE <= not(CLK_PULSE);
			else
				CLK_CNT <= CLK_CNT + 1;
			end if;
		end if;
	end process;
end Behavioral;

