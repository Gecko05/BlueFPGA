----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:05:50 08/23/2020 
-- Design Name: 
-- Module Name:    segDisp - Behavioral 
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

entity segDisp is
	PORT(
		i_CLK_100MHz : in STD_LOGIC;
		o_SevenSegment : out STD_LOGIC_VECTOR (0 TO 7) := "10000000";
		o_SevenSegmentEnable : out STD_LOGIC_VECTOR (1 DOWNTO 0) := "11";
		signal i_DATA : STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
end segDisp;

architecture Behavioral of segDisp is
	signal r_Hex : STD_LOGIC_VECTOR(0 TO 7) := "00110001";
	signal r_Toggle : STD_LOGIC := '0';
	signal r_DNibble : STD_LOGIC_VECTOR (3 DOWNTO 0) := "0000";
	constant CLK_120FPS : natural := 416500;
	signal CLK_CNT : natural range 0 to CLK_120FPS := 0;
begin
	dispLoop : process (i_CLK_100MHz, i_DATA, r_hex, r_DNibble, CLK_CNT) begin
		if rising_edge(i_CLK_100MHz) then
			if CLK_CNT = CLK_120FPS -1 then
				CLK_CNT <= 0;
				if r_Toggle = '0' then
					r_DNibble <= i_DATA(3 DOWNTO 0);
					o_SevenSegmentEnable <= "01";
					r_Toggle <= not(r_Toggle);
				else
					r_DNibble <= i_DATA(7 DOWNTO 4);
					o_SevenSegmentEnable <= "10";
					r_Toggle <= not(r_Toggle);
				end if;
			else
				CLK_CNT <= CLK_CNT + 1;
			end if;
			case r_DNibble is
				when x"0"=>
					r_Hex <= X"3F";
				when x"1" =>
					r_Hex <= X"06";
				when x"2" =>
					r_Hex <= X"5B";
				when x"3" =>
					r_Hex <= X"4F";
				when x"4" =>
					r_Hex <= X"66";
				when x"5" =>
					r_Hex <= X"6D";
				when x"6" =>
					r_Hex <= X"7D";
				when x"7" =>
					r_Hex <= X"07";
				when x"8" =>
					r_Hex <= X"7F";
				when x"9" =>
					r_Hex <= X"6F";
				when x"A" =>
					r_Hex <= X"77";
				when x"B"=>
					r_Hex <= X"7C";
				when x"C" =>
					r_Hex <= X"39";
				when x"D" =>
					r_Hex <= X"5E";
				when x"E"=>
					r_Hex <= X"79";
				when x"F"=>
					r_Hex <= X"71";
				when others =>
					r_Hex <= X"00";
			end case;
			o_SevenSegment <= not(r_Hex);
		end if;
	end process;
end Behavioral;

