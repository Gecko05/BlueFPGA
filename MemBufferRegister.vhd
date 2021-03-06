----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:45:04 07/25/2020 
-- Design Name: 
-- Module Name:    MemBufferRegister - Behavioral 
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

entity MemBufferRegister is
	port (
		i_Clock : in STD_LOGIC;
		i_MBRClear : in STD_LOGIC;
		i_MBRBus : in STD_LOGIC_VECTOR(15 DOWNTO 0);
		i_MBRReadBus : in STD_LOGIC_VECTOR(15 DOWNTO 0);
		i_MBRTakeIn : in STD_LOGIC;
		o_MBRWriteBus : out STD_LOGIC_VECTOR(15 DOWNTO 0) := STD_LOGIC_VECTOR(to_unsigned(0,16));
		o_MBRBus : out STD_LOGIC_VECTOR(15 DOWNTO 0) := STD_LOGIC_VECTOR(to_unsigned(0,16));
		o_MBRWEA : out STD_LOGIC_VECTOR(0 DOWNTO 0) := STD_LOGIC_VECTOR(to_unsigned(0,1))
	);
end MemBufferRegister;

architecture Behavioral of MemBufferRegister is	
	signal MBRData : STD_LOGIC_VECTOR(15 DOWNTO 0) := STD_LOGIC_VECTOR(to_unsigned(0,16));
begin
	MBRLoop : process(i_Clock, i_MBRClear, i_MBRTakeIn) begin
		if rising_edge(i_Clock) then
			if i_MBRClear = '1' then -- Clear the buffer value
				MBRData <= i_MBRReadBus;
			elsif i_MBRTakeIn = '1' then -- Take in a value from the bus and write it out to the memory
				MBRData <= i_MBRBus;
				o_MBRWEA <= "1";
				o_MBRWriteBus <= MBRData;
			else
				o_MBRWEA <= "0";
			end if;
		end if;
	end process;
	o_MBRBus <= MBRData;
end Behavioral;

