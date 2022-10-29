--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:10:06 02/19/2022
-- Design Name:   
-- Module Name:   /home/ise/XilinxShared/BlueFPGA/VHDL/GenericRegTest.vhd
-- Project Name:  BLUE
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: GenericReg
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
 
ENTITY GenericRegTest IS
END GenericRegTest;
 
ARCHITECTURE behavior OF GenericRegTest IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT GenericReg
    PORT(
         Clock : IN  std_logic;
         Clear : IN  std_logic;
         Load : IN  std_logic;
         D : IN  std_logic_vector(15 downto 0);
         Q : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal Clock : std_logic := '0';
   signal Clear : std_logic := '0';
   signal Load : std_logic := '0';
   signal D : std_logic_vector(15 downto 0) := (others => '0');

 	--Outputs
   signal Q : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant Clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: GenericReg PORT MAP (
          Clock => Clock,
          Clear => Clear,
          Load => Load,
          D => D,
          Q => Q
        );

   -- Clock process definitions
   Clock_process :process
   begin
		Clock <= '0';
		wait for Clock_period/2;
		Clock <= '1';
		wait for Clock_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for Clock_period*10;

      -- insert stimulus here 
		D <= STD_LOGIC_VECTOR(to_unsigned(6, 16));
		wait for Clock_period*10;
		Load <= '1';
		wait for Clock_period*10;
		D <= STD_LOGIC_VECTOR(to_unsigned(10, 16));
		wait for Clock_period*10;
		Clear <= '1';
		wait for Clock_period*10;
      wait;
   end process;

END;
