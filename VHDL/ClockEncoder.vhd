----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:25:21 02/19/2022 
-- Design Name: 
-- Module Name:    ClockEncoder - Behavioral 
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

entity ClockEncoder is
	PORT(
		E : IN std_logic; -- enable
		A : OUT std_logic_vector(3 DOWNTO 0);
		Y : IN std_logic_vector(7 DOWNTO 0)
	);
end ClockEncoder;

architecture Behavioral of ClockEncoder is
begin
	PROCESS (E, A)
	BEGIN
		IF (E = '0') THEN -- disabled
			A <= (OTHERS => '0'); -- 16-bit vector of 0
		ELSE
			CASE Y IS -- enabled
				WHEN "00000001" => A <= "000";
				WHEN "00000010" => A <= "001";
				WHEN "00000100" => A <= "010";
				WHEN "00001000" => A <= "011";
				WHEN "00010000" => A <= "100";
				WHEN "00100000" => A <= "101";
				WHEN "01000000" => A <= "110";
				WHEN "10000000" => A <= "111";
				WHEN OTHERS => NULL;
			END CASE;
		END IF;
	END PROCESS;
end Behavioral;

