----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:19:26 02/13/2022 
-- Design Name: 
-- Module Name:    ArithmeticLogicUnit - Behavioral 
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
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ArithmeticLogicUnit is
	PORT(
		S : in STD_LOGIC_VECTOR (2 DOWNTO 0);
		A, B : in STD_LOGIC_VECTOR(15 DOWNTO 0);
		OVR : out STD_LOGIC;
		F : out STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
end ArithmeticLogicUnit;
	
architecture Behavioral of ArithmeticLogicUnit is
	signal R : STD_LOGIC_VECTOR(15 DOWNTO 0) := STD_LOGIC_VECTOR(to_unsigned(0, 16));
begin
	F <= R;
	process (A, B, S, R)
	begin
		case S is 
		when "001" => -- ADD
			R <= A + B;
			OVR <= (A(15) AND B(15) AND (NOT(R(15)))) OR ((NOT(A(15))) AND (NOT(B(15))) AND R(15));
		when "010" => -- XOR
			R <= A XOR B;
			OVR <= '0';
		when "011" => -- AND
			R <= A AND B;
			OVR <= '0';
		when "100" => -- IOR
			R <= A OR B;
			OVR <= '0';
		when "101" => -- NOT
			R <= NOT(A);
			OVR <= '0';
		when others => -- RAL
			R <= A(14 DOWNTO 0) & A(15);
			OVR <= '0';
		end case;
	end process;
end Behavioral;

