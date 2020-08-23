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
		i_CLK : in STD_LOGIC;
		o_SevenSegment : out STD_LOGIC_VECTOR (0 TO 7);
		o_SevenSegmentEnable : out STD_LOGIC_VECTOR (2 DOWNTO 0);
		signal i_DATA : STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
end segDisp;

architecture Behavioral of segDisp is
	signal r_Hex : STD_LOGIC_VECTOR(0 TO 7);
begin
	o_SevenSegmentEnable <= "110";
	dispLoop : process (i_CLK, i_DATA, r_hex) begin
		if rising_edge(i_CLK) then
			case i_DATA is
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
		end if;
		o_SevenSegment <= not(r_Hex);
	end process;
end Behavioral;

