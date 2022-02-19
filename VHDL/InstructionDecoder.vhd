----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:56:07 02/19/2022 
-- Design Name: 
-- Module Name:    InstructionDecoder - Behavioral 
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

entity InstructionDecoder is
end InstructionDecoder;

architecture Behavioral of InstructionDecoder is
	PORT(
		E: IN std_logic; -- enable
		A: IN std_logic_vector(3 DOWNTO 0); -- 4 bit instruction
		Y: OUT std_logic_vector(15 DOWNTO 0)); -- data bus output
	);
begin
	PROCESS (E, A)
	BEGIN
		IF (E = '0') THEN -- disabled
			Y <= (OTHERS => '0'); -- 16-bit vector of 0
		ELSE
			CASE A IS -- enabled
				WHEN "0000" => Y <= "0000000000000001";
				WHEN "0001" => Y <= "0000000000000010";
				WHEN "0010" => Y <= "0000000000000100";
				WHEN "0011" => Y <= "0000000000001000";
				WHEN "0100" => Y <= "0000000000010000";
				WHEN "0101" => Y <= "0000000000100000";
				WHEN "0110" => Y <= "0000000001000000";
				WHEN "0111" => Y <= "0000000010000000";
				WHEN "1000" => Y <= "0000000100000000";
				WHEN "1001" => Y <= "0000001000000000";
				WHEN "1010" => Y <= "0000010000000000";
				WHEN "1011" => Y <= "0000100000000000";
				WHEN "1100" => Y <= "0001000000000000";
				WHEN "1101" => Y <= "0010000000000000";
				WHEN "1110" => Y <= "0100000000000000";
				WHEN "1111" => Y <= "1000000000000000";
				WHEN OTHERS => NULL;
			END CASE;
		END IF;
	END PROCESS;
end Behavioral;

