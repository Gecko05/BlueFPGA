----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:48:59 08/16/2020 
-- Design Name: 
-- Module Name:    ArithmeticLogicUnit - Behavioral 
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

entity ArithmeticLogicUnit is
	PORT(
		i_ACC : in STD_LOGIC_VECTOR(15 DOWNTO 0);
		i_NUM : in STD_LOGIC_VECTOR(15 DOWNTO 0);
		i_OP : in STD_LOGIC_VECTOR(2 DOWNTO 0);
		i_CLK : in STD_LOGIC;
		o_OF : out STD_LOGIC;
		o_ACC : out STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
end ArithmeticLogicUnit;

-- Not sure if I should implement the individual bits instead and then
-- merge them into the ALU. The clock process is what makes me doubt.
architecture rtl of ArithmeticLogicUnit is
	signal ADD_RES : STD_LOGIC_VECTOR(16 DOWNTO 0) := "00000000000000000";
	signal RES : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
	signal OVERFLOW : STD_LOGIC := '0';
	
	-- This component will perform the adding arithmetic
	COMPONENT RippleCarryAdder
    PORT(
         i_add1 : IN  std_logic_vector(15 downto 0);
         i_add2 : IN  std_logic_vector(15 downto 0);
         o_res : OUT  std_logic_vector(16 downto 0)
        );
    END COMPONENT;
begin
		-- Instantiate the Ripple Carry Adder
   Adder: RippleCarryAdder PORT MAP (
          i_add1 => i_ACC,
          i_add2 => i_NUM,
          o_res => ADD_RES
        );

	ALUloop : process(i_CLK) begin
		if rising_edge(i_CLK) then
			if i_OP = "000" then -- HALT Instruction from Control Unit
				
			elsif i_OP = "001" then -- ADD Instruction from CU
				RES <= ADD_RES(15 DOWNTO 0);
				OVERFLOW <= (i_ACC(15) AND i_NUM(15) AND (NOT(ADD_RES(15)))) OR ((NOT(i_ACC(15))) AND (NOT(i_NUM(15))) AND ADD_RES(15));
			elsif i_OP = "010" then
				RES <= i_ACC xor i_NUM;
			elsif i_OP = "011" then
				RES <= i_ACC and i_NUM;
			elsif i_OP = "100" then
				RES <= i_ACC or i_NUM;
			else
			end if;
		end if;
	end process;
	o_ACC <= RES;
	o_OF <= OVERFLOW;
end rtl;

