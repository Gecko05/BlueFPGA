----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:27:43 08/23/2020 
-- Design Name: 
-- Module Name:    RippleCarryAdder - Behavioral 
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

entity RippleCarryAdder is
	generic (
		g_WIDTH : natural := 2
		);
	port (
		i_add1 : in STD_LOGIC_VECTOR(g_WIDTH-1 DOWNTO 0);
		i_add2 : in STD_LOGIC_VECTOR(g_WIDTH-1 DOWNTO 0);
		o_res : out STD_LOGIC_VECTOR(g_WIDTH DOWNTO 0)
	);
end RippleCarryAdder;

architecture Behavioral of RippleCarryAdder is
	COMPONENT FullAdder
	PORT(
		i_A : IN std_logic;
		i_B : IN std_logic;
		i_C : IN std_logic;          
		o_S : OUT std_logic;
		o_C : OUT std_logic
		);
	END COMPONENT;
	
	signal w_Carry : STD_LOGIC_VECTOR(g_WIDTH DOWNTO 0);
	signal w_Sum : STD_lOGIC_VECTOR(g_WIDTH-1 DOWNTO 0);
begin
	w_Carry(0) <= '0';
	
	SET_WIDTH : for ii in 0 to g_WIDTH-1 generate
	Inst_FullAdder: FullAdder PORT MAP(
		i_A => i_add1(ii),
		i_B => i_add2(ii),
		i_C => w_Carry(ii),
		o_S => w_Sum(ii),
		o_C => w_Carry(ii+1)
	);
	end generate SET_WIDTH;
	
	o_res <= w_Carry(g_WIDTH) & w_Sum;
end Behavioral;

