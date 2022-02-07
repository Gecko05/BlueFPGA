----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:06:42 02/05/2022 
-- Design Name: 
-- Module Name:    ControlUnit - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ControlUnit is
	Port(
		CLK_100MHz : in STD_LOGIC;
		Switch : in STD_LOGIC_VECTOR(0 TO 1);
		o_LED : out STD_LOGIC_VECTOR(0 TO 7);
		SevenSegment : out STD_LOGIC_VECTOR(0 TO 7);
		SevenSegmentEnable : out STD_LOGIC_VECTOR(0 TO 1);
		IO_P6 : inout STD_LOGIC_VECTOR(0 TO 0)
	);
end ControlUnit;

architecture rtl of ControlUnit is
-- Clock and power component
	COMPONENT clockSystem
	PORT(
		i_CLK_100MHz : IN std_logic;		
		o_CP : OUT std_logic_vector(0 to 7);
		o_CLK : OUT std_logic
		);
	END COMPONENT;
	
	signal r_RUN : STD_LOGIC := '0';
	signal o_CP : STD_LOGIC_VECTOR(0 TO 7) := STD_LOGIC_VECTOR(to_unsigned(0,8));
	signal CPU_CLK : STD_LOGIC := '0';
	
	-- Seven Segment Display
	COMPONENT segDisp
	PORT(
		i_CLK_100MHz : IN std_logic;
		i_DATA : IN std_logic_vector(7 downto 0);          
		o_SevenSegment : OUT std_logic_vector(0 to 7);
		o_SevenSegmentEnable : OUT std_logic_vector(1 downto 0)
		);
	END COMPONENT;
	
	-- Debounce Switch
	COMPONENT Debounce_Switch
	PORT(
		i_Clk : IN std_logic;
		i_Switch : IN std_logic;          
		o_Switch : OUT std_logic
		);
	END COMPONENT;
	
	signal i_Button : STD_LOGIC_VECTOR (1 DOWNTO 0);
	
	signal dispData : std_logic_vector(7 downto 0) := STD_LOGIC_VECTOR(to_unsigned(0, 8));
	
	-- Power Management
	signal w_START : STD_LOGIC := '0';
	signal w_STOP : STD_LOGIC := '1';
begin
	-- Clock and power
	CLK_Sys: clockSystem PORT MAP(
		i_CLK_100MHz => CLK_100MHz,
		o_CP => o_CP,
		o_CLK => CPU_CLK
	);
	
	-- Seven Segment Display
	Inst_segDisp: segDisp PORT MAP(
		i_CLK_100MHz => CLK_100MHz,
		o_SevenSegment => SevenSegment,
		o_SevenSegmentEnable => SevenSegmentEnable,
		i_DATA => dispData
	);
	
	-- Debounce Switches
	Inst_Debounce_Switch0: Debounce_Switch PORT MAP(
		i_Clk => CLK_100MHz,
		i_Switch => Switch(0),
		o_Switch => i_Button(0)
	);
	
	Inst_Debounce_Switch1: Debounce_Switch PORT MAP(
		i_Clk => CLK_100MHz,
		i_Switch => Switch(1),
		o_Switch => i_Button(1)
	);
	
	o_LED <= o_CP;
	IO_P6(0) <= CPU_CLK;
	w_START <= not(i_Button(0));
	w_STOP <= not(i_Button(1));
	
	CU_loop : process(CPU_CLK, i_Button, dispData, w_STOP, w_START, r_RUN, o_CP) begin
		if rising_edge(CLK_100MHz) then
			if r_RUN = '1' then
				-- Do RUN stuff
				dispData <= X"FF";
				if w_START = '0' and w_STOP = '1' then
					r_RUN <= '0';
				end if;
			else
				dispData <= X"00";
				if w_START = '1' and w_STOP = '0' and o_CP(7) = '1'  then
					r_RUN <= '1';
				end if;
			end if;
		end if;
	end process;
end rtl;

