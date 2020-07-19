----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:49:34 07/19/2020 
-- Design Name: 
-- Module Name:    uart - Behavioral 
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

entity uart is
	generic ( 
		g_CLKS_PER_BIT : integer := 87
	);
	Port (
		i_RX : in STD_LOGIC;
		o_TX : out STD_LOGIC;
		i_CLK10MHz : in STD_LOGIC
	);
end uart;

architecture rtl of uart is
	signal CLK_CNT : natural range 0 to CLK_50MHz;
	signal CLK_PULSE : STD_LOGIC := '0';
begin

	clock_loop : process (i_CLK10MHz) begin
		if rising_edge(i_CLK10MHz) then
			
		end if;
	end process;

end rtl;

