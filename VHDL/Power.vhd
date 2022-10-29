----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:04:37 02/07/2022 
-- Design Name: 
-- Module Name:    Power - Behavioral 
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

entity Power is
	PORT(
		i_CLK_100MHz : in STD_LOGIC;
		i_START : in STD_LOGIC;
		i_STOP : in STD_LOGIC;
		i_HALT : in STD_LOGIC;
		o_RUN : out STD_LOGIC
	);
end Power;
architecture Behavioral of Power is
	signal r_RUN : STD_LOGIC := '0';
begin
	POWER_LOOP : process(i_CLK_100MHz, i_START, i_STOP) begin
		if rising_edge(i_CLK_100MHz) then
			if i_START = '1' and i_STOP = '0' and r_RUN = '0' and i_HALT = '0' then
				r_RUN <= '1';
			elsif i_START = '0' and i_STOP = '1' and r_RUN = '1' then
				r_RUN <= '0';
			elsif i_HALT = '1' and i_START = '0' and r_RUN = '1' then
				r_RUN <= '0';
			else
			end if;
		end if;
	end process;
	o_RUN <= r_RUN;
end Behavioral;

