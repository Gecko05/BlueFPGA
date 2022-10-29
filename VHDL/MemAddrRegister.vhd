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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MemAddrRegister is
	port(
		i_Clock : in STD_LOGIC;
		i_Bus : in STD_LOGIC_VECTOR(11 DOWNTO 0);
		i_Load : in STD_LOGIC;
		o_Bus : out STD_LOGIC_VECTOR(11 DOWNTO 0) := STD_LOGIC_VECTOR(to_unsigned(0, 12))
	);
end MemAddrRegister;

architecture rtl of MemAddrRegister is
	signal Data : STD_LOGIC_VECTOR(11 DOWNTO 0) := std_logic_vector(to_unsigned(0, 12));
begin
	MAR : process(i_Clock, i_Load) begin
		if rising_edge(i_Load) then
			Data <= i_Bus;
		else
		end if;
	end process;
	o_Bus <= Data;
end rtl;

