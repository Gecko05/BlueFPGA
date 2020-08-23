--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:36:28 08/23/2020
-- Design Name:   
-- Module Name:   /home/gecko/Blue/RippleCarryAdderTest.vhd
-- Project Name:  Blue
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: RippleCarryAdder
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
 
ENTITY RippleCarryAdderTest IS
END RippleCarryAdderTest;
 
ARCHITECTURE behavior OF RippleCarryAdderTest IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT RippleCarryAdder
    PORT(
         i_add1 : IN  std_logic_vector(1 downto 0);
         i_add2 : IN  std_logic_vector(1 downto 0);
         o_res : OUT  std_logic_vector(2 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal i_add1 : std_logic_vector(1 downto 0) := (others => '0');
   signal i_add2 : std_logic_vector(1 downto 0) := (others => '0');

 	--Outputs
   signal o_res : std_logic_vector(2 downto 0);
   -- No clocks detected in port list. Replace CLK below with 
   -- appropriate port name 
	signal CLK : STD_LOGIC;
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: RippleCarryAdder PORT MAP (
          i_add1 => i_add1,
          i_add2 => i_add2,
          o_res => o_res
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
		i_add1 <= "00";
		i_add2 <= "01";
		wait for 10 ns;
		i_add1 <= "10";
		i_add2 <= "01";
		wait for 10 ns;
		i_add1 <= "11";
		i_add2 <= "01";
		wait for 10 ns;
		i_add1 <= "10";
		i_add2 <= "11";
		wait for 10 ns;
		i_add1 <= "11";
		i_add2 <= "11";
		wait for 10 ns;
		i_add1 <= "01";
		i_add2 <= "11";
		wait for 10 ns;
      -- insert stimulus here 
      wait;
   end process;

END;
