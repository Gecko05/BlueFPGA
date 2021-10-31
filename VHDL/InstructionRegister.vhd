----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:18:11 07/25/2020 
-- Design Name: 
-- Module Name:    InstructionRegister - Behavioral 
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

entity InstructionRegister is
	port(
		i_Clock : in STD_LOGIC;
		i_IRBus : in STD_LOGIC_VECTOR(15 DOWNTO 0);
		i_IRTakeIn : in STD_LOGIC;
		o_IRBus : out STD_LOGIC_VECTOR(15 DOWNTO 0) := STD_LOGIC_VECTOR(to_unsigned(0, 16))
	);
end InstructionRegister;

architecture rtl of InstructionRegister is
	signal IRData : STD_LOGIC_VECTOR(15 DOWNTO 0) := STD_LOGIC_VECTOR(to_unsigned(0, 16));
begin
	IRLoop : process(i_Clock, i_IRTakeIn) begin
		if rising_edge(i_IRTakeIn) then
			IRData <= i_IRBus;
		else
		end if;
	end process;
	o_IRBus <= IRData;
end rtl;

