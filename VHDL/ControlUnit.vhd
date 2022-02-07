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
	
	signal dispData : std_logic_vector(7 downto 0) := STD_LOGIC_VECTOR(to_unsigned(0, 8));
	
	-- Debounce Switch
	COMPONENT Debounce_Switch
	PORT(
		i_Clk : IN std_logic;
		i_Switch : IN std_logic;          
		o_Switch : OUT std_logic
		);
	END COMPONENT;
	
	signal i_Button : STD_LOGIC_VECTOR (1 DOWNTO 0) := STD_LOGIC_VECTOR(to_unsigned(0, 2));
	
	COMPONENT Power
	PORT(
		i_CLK_100MHz : IN std_logic;
		i_START : IN std_logic;
		i_STOP : IN std_logic;
		i_CLK_7 : IN std_logic;
		i_HALT : IN std_logic;          
		o_RUN : OUT std_logic
		);
	END COMPONENT;
	
	signal r_RUN : STD_LOGIC := '0';
	signal r_HALT : STD_LOGIC := '0';
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
	
	Inst_Power: Power PORT MAP(
		i_CLK_100MHz => CLK_100MHz,
		i_START => not(i_Button(0)),
		i_STOP => not (i_Button(1)),
		i_CLK_7 => o_CP(7),
		i_HALT => r_HALT,
		o_RUN => r_RUN
	);
	
	o_LED <= o_CP;
	IO_P6(0) <= CPU_CLK;
	r_HALT <= '0';
	
	CU_loop : process(CLK_100MHz, CPU_CLK, i_Button, dispData, r_RUN, o_CP) begin
		if r_RUN = '1' then
			dispData <= X"FF";
		else
			dispData <= X"00";
		end if;
	end process;
end rtl;

