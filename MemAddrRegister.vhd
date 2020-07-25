----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:28:33 07/25/2020 
-- Design Name: 
-- Module Name:    MemAddrRegister - Behavioral 
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

entity MemAddrRegister is
	port(
		i_Clock : in STD_LOGIC;
		i_MARBus : in STD_LOGIC_VECTOR(0 TO 11);
		i_MARTakeIn : in STD_LOGIC;
		o_MARBus : out STD_LOGIC_VECTOR(0 TO 11)
	);
end MemAddrRegister;

architecture rtl of MemAddrRegister is
	signal IRData : STD_LOGIC_VECTOR(0 TO 11);
begin
	IRLoop : process(i_Clock) begin
		if rising_edge(i_MARTakeIn) then
			MARData <= i_MARBus;
		else
		end if;
	end process;
	o_MARBus <= MARData;
end rtl;

