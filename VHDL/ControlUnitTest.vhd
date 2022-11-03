--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:08:58 02/06/2022
-- Design Name:   
-- Module Name:   /home/ise/XilinxShared/BlueFPGA/VHDL/ControlUnitTest.vhd
-- Project Name:  Blue
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ControlUnit
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
 
ENTITY ControlUnitTest IS
END ControlUnitTest;
 
ARCHITECTURE behavior OF ControlUnitTest IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ControlUnit
    PORT(
         CLK_100MHz : IN  std_logic;
--         Switch : IN  std_logic_vector(0 to 1);
         o_LED : OUT  std_logic_vector(0 to 7);
         SevenSegment : OUT  std_logic_vector(0 to 7);
         SevenSegmentEnable : OUT  std_logic_vector(0 to 1)
--         IO_P6 : INOUT  std_logic_vector(0 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal CLK_100MHz : std_logic := '0';
--   signal Switch : std_logic_vector(0 to 1) := (others => '0');

	--BiDirs
--   signal IO_P6 : std_logic_vector(0 downto 0);

 	--Outputs
   signal o_LED : std_logic_vector(0 to 7);
   signal SevenSegment : std_logic_vector(0 to 7);
   signal SevenSegmentEnable : std_logic_vector(0 to 1);

   -- Clock period definitions
   constant CLK_100MHz_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ControlUnit PORT MAP (
          CLK_100MHz => CLK_100MHz,
--          Switch => Switch,
          o_LED => o_LED,
          SevenSegment => SevenSegment,
          SevenSegmentEnable => SevenSegmentEnable
--          IO_P6 => IO_P6
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
		--Switch(0) <= '1';
		--Switch(1) <= '1';
		wait for CLK_100MHz_period*10;
		--Switch(0) <= '0';
		--Switch(1) <= '0';
		wait for CLK_100MHz_period*10;
		--Switch(0) <= '1';
		--Switch(1) <= '0';
		wait for CLK_100MHz_period*10;
		--Switch(0) <= '0';
		--Switch(1) <= '1';
		wait for CLK_100MHz_period*10;
      wait;
   end process;

END;
