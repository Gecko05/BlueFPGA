----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:38:57 07/19/2020 
-- Design Name: 
-- Module Name:    system - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: Implementation of the main interface for BLUE
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

entity system is
	Port(
		CLK_100MHz : in STD_LOGIC;
		i_PB : in STD_LOGIC_VECTOR(0 TO 1);
		o_LED : out STD_LOGIC_VECTOR(0 TO 7)
	);
end system;

architecture rtl of system is
    
	COMPONENT clockSystem
	PORT(
		i_CLK_100MHz : IN std_logic;
		i_START : IN std_logic;
		i_STOP : IN std_logic;          
		o_CP : OUT std_logic_vector(0 to 7)
		);
	END COMPONENT;
	
	signal PB0 : STD_LOGIC;
	signal PB1 : STD_LOGIC;
begin

	Inst_clockSystem: clockSystem PORT MAP(
		i_CLK_100MHz => CLK_100MHz,
		i_START => PB0,
		i_STOP => PB1,
		o_CP => o_LED
	);
	
	PB0 <= not(i_PB(0));
	PB1 <= not(i_PB(1));

end rtl;

