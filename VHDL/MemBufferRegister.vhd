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
		i_Clear : in STD_LOGIC;
		i_Bus : in STD_LOGIC_VECTOR(15 DOWNTO 0);
		i_ReadBus : in STD_LOGIC_VECTOR(15 DOWNTO 0);
		i_Load : in STD_LOGIC;
		o_WriteBus : out STD_LOGIC_VECTOR(15 DOWNTO 0) := STD_LOGIC_VECTOR(to_unsigned(0,16));
		o_Bus : out STD_LOGIC_VECTOR(15 DOWNTO 0) := STD_LOGIC_VECTOR(to_unsigned(0,16));
		o_WEA : out STD_LOGIC_VECTOR(0 DOWNTO 0) := STD_LOGIC_VECTOR(to_unsigned(0,1))
	);
end MemBufferRegister;

architecture Behavioral of MemBufferRegister is	
	signal Data : STD_LOGIC_VECTOR(15 DOWNTO 0) := STD_LOGIC_VECTOR(to_unsigned(0,16));
begin
	MBR : process(i_Clock, i_Clear, i_Load) begin
		if rising_edge(i_Clock) then
			if i_Clear = '1' then -- Clear the buffer value
				Data <= i_ReadBus;
			elsif i_Load = '1' then -- Take in a value from the bus and write it out to the memory
				Data <= i_Bus;
				o_WEA <= "1";
				o_WriteBus <= i_Bus;
			else
				o_WEA <= "0";
			end if;
		end if;
	end process;
	o_Bus <= Data;
end Behavioral;

