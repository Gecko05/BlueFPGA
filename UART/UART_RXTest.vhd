--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:02:40 08/22/2020
-- Design Name:   
-- Module Name:   /home/gecko/UART/UART_RXTest.vhd
-- Project Name:  UART
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: UART_RX
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
 
ENTITY UART_RXTest IS
END UART_RXTest;
 
ARCHITECTURE behavior OF UART_RXTest IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT UART_RX
    PORT(
         i_RX : IN  std_logic;
         i_CLK100MHz : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal i_RX : std_logic := '1';
   signal i_CLK100MHz : std_logic := '0';
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   constant i_CLK100MHz_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: UART_RX PORT MAP (
          i_RX => i_RX,
          i_CLK100MHz => i_CLK100MHz
        );

   -- Clock process definitions
   i_CLK100MHz_process :process
   begin
		i_CLK100MHz <= '0';
		wait for i_CLK100MHz_period/2;
		i_CLK100MHz <= '1';
		wait for i_CLK100MHz_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for i_CLK100MHz_period*10;

      -- insert stimulus here 
		wait for 52083 ns;
		i_RX <= '0';
		wait for 52083 ns; -- 7
		i_RX <= '1';
		wait for 52083 ns; -- 6
		i_RX <= '1';
		wait for 52083 ns; -- 5
		i_RX <= '0';
		wait for 52083 ns; -- 4
		i_RX <= '0';
		wait for 52083 ns; -- 3
		i_RX <= '1';
		wait for 52083 ns; -- 2
		i_RX <= '0';
		wait for 52083 ns; -- 1
		i_RX <= '1';
		wait for 52083 ns; -- 0
		i_RX <= '0';
		wait for 52083 ns; -- STOP
		i_RX <= '1';
      wait;
   end process;

END;
