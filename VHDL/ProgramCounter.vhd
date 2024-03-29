----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:23:20 07/19/2020 
-- Design Name: 
-- Module Name:    programCounter - Behavioral 
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
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity programCounter is
	port (
		i_Clock : in STD_lOGIC;
		i_PCBus : in STD_LOGIC_VECTOR(11 DOWNTO 0);
		o_PCBus : out STD_LOGIC_VECTOR(11 DOWNTO 0) := STD_LOGIC_VECTOR(to_unsigned(0,12));
		i_PCInc : in STD_lOGIC;
		i_PCClear : in STD_LOGIC;
		i_PCLoad : in STD_LOGIC-- signal to take a value from bus?
	);
end programCounter;

architecture rtl of programCounter is
	signal PCVal : STD_LOGIC_VECTOR(11 DOWNTO 0) := "000000000000";
	signal PCCounter : natural range 0 to 4095 := 0;
begin
	PCLoop : process (i_PCClear, i_PCLoad, i_PCInc, i_PCBus, i_Clock, PCCounter) begin
		if rising_edge(i_Clock) then
			if i_PCClear = '1' then
				PCCounter <= 0;
			elsif i_PCLoad = '1' then
				PCCounter <= to_integer(unsigned(i_PCBus));
			elsif i_PCInc = '1' then
				PCCounter <= PCCounter + 1;
			end if;
		end if;
		PCVal <= std_logic_vector(to_unsigned(PCCounter, 12));
	end process;
	o_PCBus <= PCVal;
end rtl;