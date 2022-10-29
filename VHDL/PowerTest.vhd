--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:11:28 02/07/2022
-- Design Name:   
-- Module Name:   /home/ise/XilinxShared/BlueFPGA/VHDL/PowerTest.vhd
-- Project Name:  BLUE_Implementation
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Power
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
 
ENTITY PowerTest IS
END PowerTest;
 
ARCHITECTURE behavior OF PowerTest IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Power
    PORT(
         i_CLK_100MHz : IN  std_logic;
         i_START : IN  std_logic;
         i_STOP : IN  std_logic;
         i_CLK_7 : IN  std_logic;
         o_RUN : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal i_CLK_100MHz : std_logic := '0';
   signal i_START : std_logic := '0';
   signal i_STOP : std_logic := '0';
   signal i_CLK_7 : std_logic := '0';

 	--Outputs
   signal o_RUN : std_logic;
   -- No clocks detected in port list. Replace i_CLK_100MHz below with 
   -- appropriate port name 
 
   constant i_CLK_100MHz_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Power PORT MAP (
          i_CLK_100MHz => i_CLK_100MHz,
          i_START => i_START,
          i_STOP => i_STOP,
          i_CLK_7 => i_CLK_7,
          o_RUN => o_RUN
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
		i_START <= '0';
		i_STOP <= '0';
		i_CLK_7 <= '0';
		wait for i_CLK_100MHz_period*10;
		i_START <= '1';
		i_STOP <= '0';
		i_CLK_7 <= '1';
		wait for i_CLK_100MHz_period*10;
		i_START <= '0';
		i_STOP <= '0';
		i_CLK_7 <= '0';
		wait for i_CLK_100MHz_period*10;
		i_START <= '0';
		i_STOP <= '1';
		i_CLK_7 <= '0';
		wait for i_CLK_100MHz_period*10;
		i_START <= '0';
		i_STOP <= '0';
		i_CLK_7 <= '0';
		wait for i_CLK_100MHz_period*10;
		i_START <= '1';
		i_STOP <= '1';
		i_CLK_7 <= '1';
		wait for i_CLK_100MHz_period*10;
		i_START <= '1';
		i_STOP <= '0';
		i_CLK_7 <= '0';
      wait;
   end process;

END;
