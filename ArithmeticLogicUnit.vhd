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
		o_ACC : out STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
end ArithmeticLogicUnit;

architecture rtl of ArithmeticLogicUnit is
	signal D0 : integer range -32768 to 32768 := 0;
	signal D1 : integer range -32768 to 32768 := 0;
	signal DR : integer range -65536 to 65536 := 0;
begin
	ALUloop : process(i_CLK) begin
		if rising_edge(i_CLK) then
			if i_OP = "000" then
				
			elsif i_OP = "001" then -- ADD
				D0 <= to_integer(unsigned(i_ACC(14 DOWNTO 0)));
				D1 <= to_integer(unsigned(i_NUM(14 DOWNTO 0)));
				if (i_ACC(15) = '1') then
					D0 <= D0 * (-1);
				end if;
				if (i_NUM(15) = '1') then
					D1 <= D1 * (-1);
				end if;
				DR <= D0 + D1;
				o_ACC(14 DOWNTO 0) <= STD_LOGIC_VECTOR(to_unsigned(DR, 15));
				if DR < 0 then
					o_ACC(15) <= '1';
				else 
					o_ACC(15) <= '0';
				end if;
			else
			end if;
		end if;
	end process;
end rtl;

