----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:08:19 08/23/2020 
-- Design Name: 
-- Module Name:    HalfAdder - Behavioral 
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

entity HalfAdder is
	PORT(
		i_A : in STD_LOGIC;
		i_B : in STD_LOGIC;
		o_C : out STD_LOGIC;
		o_S : out STD_LOGIC
	);
end HalfAdder;

architecture Behavioral of HalfAdder is
begin
	o_C <= i_A and i_B;
	o_S <= i_A xor i_B;

end Behavioral;

