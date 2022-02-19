----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:09:18 02/19/2022 
-- Design Name: 
-- Module Name:    GenericReg - Behavioral 
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

entity GenericReg is GENERIC (size: INTEGER := 15);
	PORT (
		Clock, Clear, Load: IN std_logic;
		D: IN std_logic_vector(size DOWNTO 0);
		Q: OUT std_logic_vector(size DOWNTO 0));
end GenericReg;

architecture Behavioral of GenericReg is
	
begin
	process (Clock, Clear)
	begin
		if Clear = '1' then
			Q <= (OTHERS => '0');
		elsif Clock'EVENT AND Clock = '1' then
			if Load = '1' then
				Q <= D;
			end if;
		end if;
	end process;
end Behavioral;

