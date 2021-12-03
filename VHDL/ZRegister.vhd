----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:33:16 11/27/2021 
-- Design Name: 
-- Module Name:    ZRegister - Behavioral 
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

entity ZRegister is
	port(
		i_Clock : IN std_logic;
		i_ZClear : IN std_logic;
		i_ZBus : IN std_logic_vector(15 downto 0);
		i_ZTakeIn : IN std_logic;          
		o_ZBus : OUT std_logic_vector(15 downto 0)
		);
end ZRegister;

architecture Behavioral of ZRegister is
	signal ZVal : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
begin
	ZLoop : process (i_ZClear, i_ZTakeIn, i_ZBus, i_Clock) begin
		if rising_edge(i_ZClear) then
			 ZVal <= STD_LOGIC_VECTOR(to_unsigned(0,16));
		elsif rising_edge(i_ZTakeIn) then
			ZVal <= i_ZBus;	
		else
			-- Do nothing
		end if;
	end process;
	o_ZBus <= ZVal;
end Behavioral;

