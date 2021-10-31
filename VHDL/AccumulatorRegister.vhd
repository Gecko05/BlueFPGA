----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:55:10 04/18/2021 
-- Design Name: 
-- Module Name:    AccumulatorRegister - Behavioral 
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

entity AccumulatorRegister is
	port (
			i_Clock : in STD_LOGIC;
			i_ACCClear : in STD_LOGIC;
			i_ACCBus : in STD_LOGIC_VECTOR(15 DOWNTO 0);
			i_ACCTakeIn : in STD_LOGIC;
			o_ACCBus : out STD_LOGIC_VECTOR(15 DOWNTO 0) := STD_LOGIC_VECTOR(to_unsigned(0,16))
		);
end AccumulatorRegister;
	
architecture Behavioral of AccumulatorRegister is
	signal ACCData : STD_LOGIC_VECTOR(15 DOWNTO 0) := STD_LOGIC_VECTOR(to_unsigned(0,16));
begin
	ACCLoop : process(i_Clock, i_ACCClear, i_ACCTakeIn) begin
		if rising_edge(i_Clock) then
			if i_ACCClear = '1' then -- Clear the buffer value
				ACCData <= STD_LOGIC_VECTOR(to_unsigned(0,16));
			elsif i_ACCTakeIn = '1' then -- Take in a value from the bus and write it out to the memory
				ACCData <= i_ACCBus;
			else

			end if;
		end if;
	end process;
	o_ACCBus <= ACCData;
end Behavioral;

