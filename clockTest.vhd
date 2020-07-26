--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:22:59 07/26/2020
-- Design Name:   
-- Module Name:   /home/gecko/14.7/ISE_DS/BLUE/clockTest.vhd
-- Project Name:  BLUE
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: clockSystem
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
 
ENTITY clockTest IS
END clockTest;
 
ARCHITECTURE behavior OF clockTest IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT clockSystem
    PORT(
         i_CLK_100MHz : IN  std_logic;
         i_START : IN  std_logic;
         i_STOP : IN  std_logic;
         o_CP : OUT  std_logic_vector(0 to 7)
        );
    END COMPONENT;
    

   --Inputs
   signal i_CLK_100MHz : std_logic := '0';
   signal i_START : std_logic := '0';
   signal i_STOP : std_logic := '0';

 	--Outputs
   signal o_CP : std_logic_vector(0 to 7);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   constant i_CLK_100MHz_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: clockSystem PORT MAP (
          i_CLK_100MHz => i_CLK_100MHz,
          i_START => i_START,
          i_STOP => i_STOP,
          o_CP => o_CP
        );

   -- Clock process definitions
   i_CLK_100MHz_process :process
   begin
		i_CLK_100MHz <= '0';
		wait for i_CLK_100MHz_period/2;
		i_CLK_100MHz <= '1';
		wait for i_CLK_100MHz_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for i_CLK_100MHz_period*10;

      -- insert stimulus here 
		i_START <= '1';
		wait for 100 ns;
		i_START <= '0';
		wait for 100 ns;
      wait;	
   end process;

END;
