--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:08:46 07/19/2020
-- Design Name:   
-- Module Name:   /home/gecko/14.7/ISE_DS/BLUE/systemTest.vhd
-- Project Name:  BLUE
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: system
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
 
ENTITY systemTest IS
END systemTest;
 
ARCHITECTURE behavior OF systemTest IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT system
    PORT(
         CLK_100MHz : IN  std_logic;
         i_PB : IN  std_logic_vector(0 to 1);
         o_LED : OUT  std_logic_vector(0 to 7)
        );
    END COMPONENT;
    

   --Inputs
   signal CLK_100MHz : std_logic := '0';
   signal i_PB : std_logic_vector(0 to 1) := (others => '0');

 	--Outputs
   signal o_LED : std_logic_vector(0 to 7);

   -- Clock period definitions
   constant CLK_100MHz_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: system PORT MAP (
          CLK_100MHz => CLK_100MHz,
          i_PB => i_PB,
          o_LED => o_LED
        );

   -- Clock process definitions
   CLK_100MHz_process :process
   begin
		CLK_100MHz <= '0';
		wait for CLK_100MHz_period/2;
		CLK_100MHz <= '1';
		wait for CLK_100MHz_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for CLK_100MHz_period*10;

      -- insert stimulus here 
		-- Due to pullup, signals are inverted
		-- Turn on
		i_PB(0) <= '0';
		i_PB(1) <= '1';
		wait for 400 ns;
		-- Turn off
		i_PB(0) <= '1';
		i_PB(1) <= '0';
		wait for 400 ns;
		-- Both high
		i_PB(0) <= '0';
		i_PB(1) <= '0';
		wait for 400 ns;
		-- Both low
		i_PB(0) <= '1';
		i_PB(1) <= '1';
		wait for 400 ns;
      wait;
   end process;

END;
