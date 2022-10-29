----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:32:17 02/19/2022 
-- Design Name: 
-- Module Name:    DemuxNOP - Behavioral 
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

entity DemuxNOP is
	PORT(
		
	);
end DemuxNOP;

ARCHITECTURE Behavioral OF Decoder IS
BEGIN
	PROCESS (E, A)
	BEGIN
		IF (E = '0') THEN -- disabled
			Y <= (OTHERS => '0'); -- 8-bit vector of 0
		ELSE
			CASE A IS -- enabled
				WHEN "000" => Y <= "00000001";
				WHEN "001" => Y <= "00000010";
				WHEN "010" => Y <= "00000100";
				WHEN "011" => Y <= "00001000";
				WHEN "100" => Y <= "00010000";
				WHEN "101" => Y <= "00100000";
				WHEN "110" => Y <= "01000000";
				WHEN "111" => Y <= "10000000";
				WHEN OTHERS => NULL;
			END CASE;
		END IF;
	END PROCESS;
END Behavioral;