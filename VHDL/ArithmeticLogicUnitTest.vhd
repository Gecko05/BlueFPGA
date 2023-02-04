--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   20:00:18 02/13/2022
-- Design Name:   
-- Module Name:   /home/ise/XilinxShared/BlueFPGA/VHDL/ArithmeticLogicUnitTest.vhd
-- Project Name:  BLUE
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
USE ieee.numeric_std.ALL;
 
ENTITY ArithmeticLogicUnitTest IS
END ArithmeticLogicUnitTest;
 
ARCHITECTURE behavior OF ArithmeticLogicUnitTest IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ArithmeticLogicUnit
    PORT(
         S : IN  std_logic_vector(3 downto 0);
         A : IN  std_logic_vector(15 downto 0);
         B : IN  std_logic_vector(15 downto 0);
         OVR : OUT  std_logic;
         F : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal S : std_logic_vector(3 downto 0) := (others => '0');
   signal A : std_logic_vector(15 downto 0) := (others => '0');
   signal B : std_logic_vector(15 downto 0) := (others => '0');

 	--Outputs
   signal OVR : std_logic;
   signal F : std_logic_vector(15 downto 0);
	signal clock : std_logic;
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   constant clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ArithmeticLogicUnit PORT MAP (
          S => S,
          A => A,
          B => B,
          OVR => OVR,
          F => F
        );

   -- Clock process definitions
   clock_process :process
   begin
		clock <= '0';
		wait for clock_period/2;
		clock <= '1';
		wait for clock_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clock_period*10;
		
      -- insert stimulus here 
		-- SUM
		S <= "0001";
		A <= STD_LOGIC_VECTOR(to_unsigned(1234, 16));
		B <= STD_LOGIC_VECTOR(to_unsigned(0, 16));
		wait for clock_period*10;
		A <= STD_LOGIC_VECTOR(to_unsigned(100, 16));
		B <= STD_LOGIC_VECTOR(to_unsigned(50, 16));
		wait for clock_period*10;
		A <= STD_LOGIC_VECTOR(to_unsigned(65535, 16));
		B <= STD_LOGIC_VECTOR(to_unsigned(2, 16));
		wait for clock_period*10;
		-- XOR
		S <= "0010";
		A <= STD_LOGIC_VECTOR(to_unsigned(1234, 16));
		B <= STD_LOGIC_VECTOR(to_unsigned(0, 16));
		wait for clock_period*10;
		A <= STD_LOGIC_VECTOR(to_unsigned(65535, 16));
		B <= STD_LOGIC_VECTOR(to_unsigned(2, 16));
		wait for clock_period*10;
		-- AND
		S <= "0011";
		A <= STD_LOGIC_VECTOR(to_unsigned(1234, 16));
		B <= STD_LOGIC_VECTOR(to_unsigned(0, 16));
		wait for clock_period*10;
		-- IOR
		S <= "0100";
		A <= STD_LOGIC_VECTOR(to_unsigned(1234, 16));
		B <= STD_LOGIC_VECTOR(to_unsigned(100, 16));
		wait for clock_period*10;
		-- NOT
		S <= "0101";
		A <= STD_LOGIC_VECTOR(to_unsigned(1234, 16));
		B <= STD_LOGIC_VECTOR(to_unsigned(100, 16));
		wait for clock_period*10;
		-- RAL
		S <= "1101";
		A <= STD_LOGIC_VECTOR(to_unsigned(65500, 16));
		B <= STD_LOGIC_VECTOR(to_unsigned(100, 16));
		wait for clock_period*10;
      wait;
   end process;

END;
