--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:08:12 08/16/2020
-- Design Name:   
-- Module Name:   /home/gecko/Blue/ArithmeticLogicUnitTest.vhd
-- Project Name:  Blue
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ArithmeticLogicUnit
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY ArithmeticLogicUnitTest IS
END ArithmeticLogicUnitTest;
 
ARCHITECTURE behavior OF ArithmeticLogicUnitTest IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ArithmeticLogicUnit
    PORT(
         i_ACC : IN  std_logic_vector(15 downto 0);
         i_NUM : IN  std_logic_vector(15 downto 0);
         i_OP : IN  std_logic_vector(2 downto 0);
         i_CLK : IN  std_logic;
         o_ACC : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal i_ACC : std_logic_vector(15 downto 0) := (others => '0');
   signal i_NUM : std_logic_vector(15 downto 0) := (others => '0');
   signal i_OP : std_logic_vector(2 downto 0) := (others => '0');
   signal i_CLK : std_logic := '0';

 	--Outputs
   signal o_ACC : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant i_CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ArithmeticLogicUnit PORT MAP (
          i_ACC => i_ACC,
          i_NUM => i_NUM,
          i_OP => i_OP,
          i_CLK => i_CLK,
          o_ACC => o_ACC
        );

   -- Clock process definitions
   i_CLK_process :process
   begin
		i_CLK <= '0';
		wait for i_CLK_period/2;
		i_CLK <= '1';
		wait for i_CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for i_CLK_period*10;

      -- insert stimulus here 
		i_ACC <= "0000000000001010";
		i_NUM <= "1000000000000010";
		--        000|000|000|000|
		i_OP <= "001";
      wait;
   end process;

END;
