--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:06:46 07/25/2020
-- Design Name:   
-- Module Name:   /home/gecko/14.7/ISE_DS/BLUE/ProgramCounterTest.vhd
-- Project Name:  BLUE
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: programCounter
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
 
ENTITY ProgramCounterTest IS
END ProgramCounterTest;
 
ARCHITECTURE behavior OF ProgramCounterTest IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT programCounter
    PORT(
			i_Clock : IN std_logic;
         i_PCBus : IN  std_logic_vector(0 to 11);
         o_PCBus : OUT  std_logic_vector(0 to 11);
         i_PCInc : IN  std_logic;
         i_PCClear : IN  std_logic;
         i_PCLoad : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal i_PCBus : std_logic_vector(0 to 11) := (others => '0');
   signal i_PCInc : std_logic := '0';
   signal i_PCClear : std_logic := '0';
   signal i_PCLoad : std_logic := '0';
	signal myClock : std_logic;

 	--Outputs
   signal o_PCBus : std_logic_vector(0 to 11);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   constant myClock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: programCounter PORT MAP (
			 i_Clock => myClock,
          i_PCBus => i_PCBus,
          o_PCBus => o_PCBus,
          i_PCInc => i_PCInc,
          i_PCClear => i_PCClear,
          i_PCLoad => i_PCLoad
        );

   -- Clock process definitions
   myClock_process :process
   begin
		myClock <= '0';
		wait for myClock_period/2;
		myClock <= '1';
		wait for myClock_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
      -- insert stimulus here 
		wait for 5 ns;
		i_PCBus <= O"0001";
		i_PCLoad <= '1';
		wait for 20 ns;
		i_PCLoad <= '0';
		wait for 20 ns;
		i_PCInc <= '1';
		wait for 10 ns;
		i_PCInc <= '0';
		wait for 10 ns;
		i_PCClear <= '1';
		wait for 10 ns;
		i_PCClear <= '0';
		wait for 10 ns;
		i_PCClear <= '1';
		i_PCLoad <= '1';
		i_PCInc <= '1';
		wait for 10 ns;
      wait;
   end process;

END;
