----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:11:14 08/23/2020 
-- Design Name: 
-- Module Name:    FullAdder - Behavioral 
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

entity FullAdder is
	PORT (
		i_A : IN STD_LOGIC;
		i_B : IN STD_LOGIC;
		i_C : IN STD_LOGIC;
		o_S : OUT STD_LOGIC;
		o_C : OUT STD_LOGIC
	);
end FullAdder;

architecture Behavioral of FullAdder is
	COMPONENT HalfAdder
		PORT(
			i_A : IN std_logic;
			i_B : IN std_logic;          
			o_C : OUT std_logic;
			o_S : OUT std_logic
			);
	END COMPONENT;
	signal r_C0 : STD_LOGIC;
	signal r_S0 : STD_LOGIC;
	signal r_C1 : STD_LOGIC;
begin
	Inst_HalfAdder0: HalfAdder PORT MAP(
		i_A => i_A,
		i_B => i_B,
		o_C => r_C0,
		o_S => r_S0
	);
	Inst_HalfAdder1: HalfAdder PORT MAP(
		i_A => i_C,
		i_B => r_S0,
		o_C => r_C1,
		o_S => o_S
	);
	o_C <= r_C1 or r_C0;
end Behavioral;

