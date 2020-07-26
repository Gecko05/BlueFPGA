----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 		 Jaime Centeno
-- 
-- Create Date:    15:51:04 07/18/2020 
-- Design Name:    BLUE
-- Module Name:    clockSystem - rtl 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: There is a latch warning because the frequency counter is too low
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity clockSystem is
	Port (
		i_CLK_100MHz : in STD_LOGIC;
		i_START : in STD_LOGIC;
		i_STOP : in STD_LOGIC;
		o_CP : out STD_LOGIC_VECTOR(0 TO 7);
		o_CLK : out STD_LOGIC
	);
end clockSystem;

architecture rtl of clockSystem is
-- Minor cycle freq is 50Mhz, Major cycle is 50/8MHz
	constant CLK_50MHz : natural := 2;
	signal CLK_CNT : natural range 0 to CLK_50MHz;
	signal CLK_PULSE : STD_LOGIC := '0';
	signal CLK_PULSE_CNT : natural range 0 to 7;
	constant CLK_OUTPUTS : natural := 8;
-- Power state flip flop
	signal RUN : STD_LOGIC := '0';
begin
-- Main loop for generating the clock pulse signal
	o_CLK <= CLK_PULSE;
	clockLoop : process (i_CLK_100MHz, RUN, i_START, i_STOP) begin
		if rising_edge(i_CLK_100MHz) then
			if RUN = '1' then
				if CLK_CNT >= CLK_50MHz - 1 then
					CLK_PULSE <= not CLK_PULSE;
					CLK_CNT <= 0;
					-- Set and clear the individual outputs
					o_CP <= "00000000";
					o_CP(CLK_PULSE_CNT) <= '1';
					if CLK_PULSE_CNT >= CLK_OUTPUTS-1 then
						CLK_PULSE_CNT <= 0;
					else
						CLK_PULSE_CNT <= CLK_PULSE_CNT + 1;
					end if;
				else
					CLK_CNT <= CLK_CNT + 1;
				end if;
				if i_STOP = '1' then
					RUN <= '0';
					o_CP <= "00000000";
					CLK_CNT <= 0;
					CLK_PULSE_CNT <= 0;
				end if;
			else
				if i_START = '1' then
					RUN <= '1';
				end if;
			end if;
		end if;
	end process;
end rtl;