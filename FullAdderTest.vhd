--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:20:47 08/23/2020
-- Design Name:   
-- Module Name:   /home/gecko/Blue/FullAdderTest.vhd
-- Project Name:  Blue
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: FullAdder
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
 
ENTITY FullAdderTest IS
END FullAdderTest;
 
ARCHITECTURE behavior OF FullAdderTest IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT FullAdder
    PORT(
         i_A : IN  std_logic;
         i_B : IN  std_logic;
         i_C : IN  std_logic;
         o_S : OUT  std_logic;
         o_C : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal i_A : std_logic := '0';
   signal i_B : std_logic := '0';
   signal i_C : std_logic := '0';

 	--Outputs
   signal o_S : std_logic;
   signal o_C : std_logic;
   -- No clocks detected in port list. Replace CLK below with 
   -- appropriate port name 
	signal CLK : std_logic;
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: FullAdder PORT MAP (
          i_A => i_A,
          i_B => i_B,
          i_C => i_C,
          o_S => o_S,
          o_C => o_C
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for CLK_period*10;

      -- insert stimulus here 
		i_A <= '0';
		i_B <= '0';
		i_C <= '0';
		wait for 100 ns;
		i_A <= '1';
		i_B <= '0';
		i_C <= '0';
		wait for 100 ns;
		i_A <= '0';
		i_B <= '1';
		i_C <= '0';
		wait for 100 ns;
		i_A <= '1';
		i_B <= '1';
		i_C <= '0';
		wait for 100 ns;
		i_A <= '0';
		i_B <= '0';
		i_C <= '1';
		wait for 100 ns;
		i_A <= '1';
		i_B <= '0';
		i_C <= '1';
		wait for 100 ns;
		i_A <= '0';
		i_B <= '1';
		i_C <= '1';
		wait for 100 ns;
		i_A <= '1';
		i_B <= '1';
		i_C <= '1';
		wait for 100 ns;
      wait;
   end process;

END;
