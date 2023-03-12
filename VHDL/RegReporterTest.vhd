--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:19:10 03/12/2023
-- Design Name:   
-- Module Name:   /home/ise/Xilinx/Blue/RegReporterTest.vhd
-- Project Name:  Blue
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: RegReporter
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
 
ENTITY RegReporterTest IS
END RegReporterTest;
 
ARCHITECTURE behavior OF RegReporterTest IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT RegReporter
    PORT(
         i_CLK : IN  std_logic;
         o_TX : OUT  std_logic;
         i_ACC : IN  std_logic_vector(15 downto 0);
         i_Z : IN  std_logic_vector(15 downto 0);
         i_IR : IN  std_logic_vector(15 downto 0);
         i_PC : IN  std_logic_vector(11 downto 0);
         i_MAR : IN  std_logic_vector(11 downto 0);
         i_MBR : IN  std_logic_vector(15 downto 0);
         i_EN : IN  std_logic;
         o_DONE : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal i_CLK : std_logic := '0';
   signal i_ACC : std_logic_vector(15 downto 0) := (others => '0');
   signal i_Z : std_logic_vector(15 downto 0) := (others => '0');
   signal i_IR : std_logic_vector(15 downto 0) := (others => '0');
   signal i_PC : std_logic_vector(11 downto 0) := (others => '0');
   signal i_MAR : std_logic_vector(11 downto 0) := (others => '0');
   signal i_MBR : std_logic_vector(15 downto 0) := (others => '0');
   signal i_EN : std_logic := '0';

 	--Outputs
   signal o_TX : std_logic;
   signal o_DONE : std_logic;

   -- Clock period definitions
   constant i_CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: RegReporter PORT MAP (
          i_CLK => i_CLK,
          o_TX => o_TX,
          i_ACC => i_ACC,
          i_Z => i_Z,
          i_IR => i_IR,
          i_PC => i_PC,
          i_MAR => i_MAR,
          i_MBR => i_MBR,
          i_EN => i_EN,
          o_DONE => o_DONE
        );

   -- Clock process definitions
   i_CLK_process :process
   begin
		i_CLK <= '0';
		wait for i_CLK_period/2;
		i_CLK <= '1';
		wait for i_CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for i_CLK_period*10;

      -- insert stimulus here 
		wait for i_CLK_period*100;
		i_ACC <= X"A400";
		i_EN <= '1';
		wait for i_CLK_period*100;
		i_EN <= '0';
      wait;
   end process;

END;
