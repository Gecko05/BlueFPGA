--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:40:33 07/25/2020
-- Design Name:   
-- Module Name:   /home/gecko/14.7/ISE_DS/BLUE/MemBufferRegisterTest.vhd
-- Project Name:  BLUE
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: MemBufferRegister
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
 
ENTITY MemBufferRegisterTest IS
END MemBufferRegisterTest;
 
ARCHITECTURE behavior OF MemBufferRegisterTest IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT MemBufferRegister
    PORT(
         i_Clock : IN  std_logic;
         i_MBRClear : IN  std_logic;
         i_MBRBus : IN  std_logic_vector(0 to 15);
         i_MBRReadBus : IN  std_logic_vector(0 to 15);
         i_MBRTakeIn : IN  std_logic;
         o_MBRWriteBus : OUT  std_logic_vector(0 to 15);
         o_MBRBus : OUT  std_logic_vector(0 to 15);
         o_MBRWEA : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal i_Clock : std_logic := '0';
   signal i_MBRClear : std_logic := '0';
   signal i_MBRBus : std_logic_vector(0 to 15) := (others => '0');
   signal i_MBRReadBus : std_logic_vector(0 to 15) := (others => '0');
   signal i_MBRTakeIn : std_logic := '0';

 	--Outputs
   signal o_MBRWriteBus : std_logic_vector(0 to 15);
   signal o_MBRBus : std_logic_vector(0 to 15);
   signal o_MBRWEA : std_logic;

   -- Clock period definitions
   constant i_Clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: MemBufferRegister PORT MAP (
          i_Clock => i_Clock,
          i_MBRClear => i_MBRClear,
          i_MBRBus => i_MBRBus,
          i_MBRReadBus => i_MBRReadBus,
          i_MBRTakeIn => i_MBRTakeIn,
          o_MBRWriteBus => o_MBRWriteBus,
          o_MBRBus => o_MBRBus,
          o_MBRWEA => o_MBRWEA
        );

   -- Clock process definitions
   i_Clock_process :process
   begin
		i_Clock <= '0';
		wait for i_Clock_period/2;
		i_Clock <= '1';
		wait for i_Clock_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for i_Clock_period*10;

      -- insert stimulus here 
		i_MBRBus <= X"2301";
		wait for 10 ns;
		i_MBRTakeIn <= '1';
		wait for 10 ns;
		i_MBRTakeIn <= '0';
		wait for 10 ns;
		i_MBRClear <= '1';
		wait for 10 ns;
		i_MBRClear <= '0';
		wait for 10 ns;
      wait;
   end process;

END;
