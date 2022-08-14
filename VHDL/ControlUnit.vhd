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
		CLK_100MHz : in std_logic;
		Switch : in std_logic_vector(0 TO 1);
		o_LED : out std_logic_vector(0 TO 7);
		SevenSegment : out std_logic_vector(0 TO 7);
		SevenSegmentEnable : out std_logic_vector(0 TO 1);
		IO_P6 : inout std_logic_vector(0 TO 0)
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
	
	signal o_CP : std_logic_vector(0 TO 7) := std_logic_vector(to_unsigned(0,8));
	signal CPU_CLK : std_logic := '0';
	
	-- Seven Segment Display
	COMPONENT segDisp
	PORT(
		i_CLK_100MHz : IN std_logic;
		i_DATA : IN std_logic_vector(7 downto 0);          
		o_SevenSegment : OUT std_logic_vector(0 to 7);
		o_SevenSegmentEnable : OUT std_logic_vector(1 downto 0)
		);
	END COMPONENT;
	
	signal dispData : std_logic_vector(7 downto 0) := std_logic_vector(to_unsigned(0, 8));
	
	-- Debounce Switch
	COMPONENT Debounce_Switch
	PORT(
		i_Clk : IN std_logic;
		i_Switch : IN std_logic;          
		o_Switch : OUT std_logic
		);
	END COMPONENT;
	
	signal i_Button : std_logic_vector (1 DOWNTO 0) := std_logic_vector(to_unsigned(0, 2));
	signal o_Switch : std_logic_vector (1 DOWNTO 0) := std_logic_vector(to_unsigned(0, 2));
	
	-- Power Management
	COMPONENT Power
	PORT(
		i_CLK_100MHz : IN std_logic;
		i_START : IN std_logic;
		i_STOP : IN std_logic;
		i_HALT : IN std_logic;          
		o_RUN : OUT std_logic
		);
	END COMPONENT;
	
	signal r_RUN : std_logic := '0';
	signal r_HALT : std_logic := '0';
	
	-- Memory Address Register
	COMPONENT MemAddrRegister
	PORT(
		i_Clock : IN std_logic;
		i_Bus : IN std_logic_vector(11 downto 0);
		i_Load : IN std_logic;          
		o_Bus : OUT std_logic_vector(11 downto 0)
		);
	END COMPONENT;
	
	signal MAR_Input : std_logic_vector(11 downto 0) := std_logic_vector(to_unsigned(0, 12));
	signal MAR_Load : std_logic := '0';
	signal MAR_Output : std_logic_vector(11 downto 0) := std_logic_vector(to_unsigned(0, 12));
	
	-- Memory Buffer Register
	COMPONENT MemBufferRegister
	PORT(
		i_Clock : IN std_logic;
		i_Clear : IN std_logic;
		i_Bus : IN std_logic_vector(15 downto 0);
		i_ReadBus : IN std_logic_vector(15 downto 0);
		i_Load : IN std_logic;          
		o_WriteBus : OUT std_logic_vector(15 downto 0);
		o_Bus : OUT std_logic_vector(15 downto 0);
		o_WEA : OUT std_logic_vector(0 to 0)
		);
	END COMPONENT;
	
	signal MBR_Clear : std_logic := '0';
	signal MBR_Load : std_logic := '0';
	signal MBR_Input : std_logic_vector(15 downto 0) := std_logic_vector(to_unsigned(0, 16));
	signal MBR_ReadBus : std_logic_vector(15 downto 0) := std_logic_vector(to_unsigned(0, 16));
	signal MBR_WriteBus : std_logic_vector(15 downto 0) := std_logic_vector(to_unsigned(0, 16));
	signal MBR_Output : std_logic_vector(15 downto 0) := std_logic_vector(to_unsigned(0, 16));
	signal MBR_WEA : std_logic_vector(0 to 0) := std_logic_vector(to_unsigned(0, 1));
	
	-- RAM Block
	COMPONENT RAM_Block
	  PORT (
		 clka : IN STD_LOGIC;
		 wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
		 addra : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
		 dina : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 douta : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	  );
	END COMPONENT;
	
	-- Program Counter
	COMPONENT programCounter
	PORT(
		i_Clock : IN std_logic;
		i_PCBus : IN std_logic_vector(11 downto 0);
		i_PCInc : IN std_logic;
		i_PCClear : IN std_logic;
		i_PCLoad : IN std_logic;          
		o_PCBus : OUT std_logic_vector(11 downto 0)
		);
	END COMPONENT;
	
	signal PC_Input : STD_LOGIC_VECTOR(11 DOWNTO 0) := STD_LOGIC_VECTOR(to_unsigned(0, 12));
	signal PC_Inc : STD_LOGIC := '0';
	signal PC_Clear : STD_LOGIC := '0';
	signal PC_Load : STD_LOGIC := '0';
	signal PC_Output : STD_LOGIC_VECTOR(11 DOWNTO 0) := STD_LOGIC_VECTOR(to_unsigned(0, 12));
	
	-- Instruction Register
	COMPONENT GenericReg
	PORT(
		Clock : IN std_logic;
		Clear : IN std_logic;
		Load : IN std_logic;
		D : IN std_logic_vector(15 downto 0);          
		Q : OUT std_logic_vector(15 downto 0)
		);
	END COMPONENT;
	
	signal IR_Input : STD_LOGIC_VECTOR(15 DOWNTO 0) := STD_LOGIC_VECTOR(to_unsigned(0, 16));
	signal IR_Clear : STD_LOGIC := '0';
	signal IR_Output : STD_LOGIC_VECTOR(15 DOWNTO 0) := STD_LOGIC_VECTOR(to_unsigned(0, 16));
	signal IR_Load : STD_LOGIC := '0';
	-- State
	signal STATE : STD_LOGIC := '0'; -- Two States, 0 Fetch, 1 Execute
	signal Instruction : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
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
		o_Switch => o_Switch(0)
	);
	
	Inst_Debounce_Switch1: Debounce_Switch PORT MAP(
		i_Clk => CLK_100MHz,
		i_Switch => Switch(1),
		o_Switch => o_Switch(1)
	);
	
	Inst_Power: Power PORT MAP(
		i_CLK_100MHz => CLK_100MHz,
		i_START => i_Button(0),
		i_STOP => i_Button(1),
		i_HALT => r_HALT,
		o_RUN => r_RUN
	);
	
	-- Memory Address Register
	Inst_MemAddrRegister: MemAddrRegister PORT MAP(
		i_Clock => CLK_100MHz,
		i_Bus => MAR_Input,
		i_Load => MAR_Load,
		o_Bus => MAR_Output
	);
	
	-- Memory Buffer Register
	Inst_MemBufferRegister: MemBufferRegister PORT MAP(
		i_Clock => CLK_100MHz,
		i_Clear => MBR_Clear,
		i_Bus => MBR_Input,
		i_ReadBus => MBR_ReadBus,
		i_Load => MBR_Load,
		o_WriteBus => MBR_WriteBus,
		o_Bus => MBR_Output,
		o_WEA => MBR_WEA
	);
	
	-- Instruction Register
	Inst_GenericReg: GenericReg PORT MAP(
		Clock => CLK_100MHz,
		Clear => IR_Clear,
		Load => IR_Load,
		D => IR_Input,
		Q => IR_Output
	);
	
	-- RAM Block
	RAM : RAM_Block PORT MAP (
		 clka => CLK_100MHz,
		 wea => MBR_WEA,
		 addra => MAR_Output,
		 dina => MBR_WriteBus,
		 douta => MBR_ReadBus
	);
	
	-- Program Counter
	Inst_programCounter: programCounter PORT MAP(
		i_Clock => CLK_100MHz,
		i_PCBus => PC_Input,
		o_PCBus => PC_Output,
		i_PCInc => PC_Inc,
		i_PCClear => PC_Clear,
		i_PCLoad => PC_Load
	);
	
	-- Board	
	o_LED <= o_CP;
	IO_P6(0) <= CPU_CLK;
	i_Button <= NOT(o_Switch);
	
	r_HALT <= '0';
	-- Permanent connections
	IR_Input <= MBR_Output;
	
	-- This will change
	MAR_Input <= PC_Output;
	--dispData <= PC_Output(7 DOWNTO 0);
	PC_Inc <= o_CP(1) AND r_RUN AND NOT(STATE);
	MBR_Clear <= o_CP(2) AND r_RUN AND NOT(STATE);
	IR_LOAD <= o_CP(3) AND r_RUN AND NOT(STATE);
	
	CU_loop : process(CPU_CLK, i_Button, dispData, r_RUN, o_CP, IR_Output, STATE, Instruction) begin
	
		if Instruction = "1111" then
			if o_CP(7) = '1' then
				MAR_Load <= '1';
			else
				MAR_Load <= '0';
			end if;
		end if;
		
		-- JMP
		if Instruction = "1010" then
			if o_CP(5) = '1' then
				PC_Clear <= '1' AND r_RUN;
			elsif o_CP(6) = '1' then
				PC_Clear <= '0' AND r_RUN;
				PC_Input <= IR_Output(11 DOWNTO 0);
				PC_Load <= '1' AND r_RUN;
			else
				PC_Load <= '0';
			end if;
		end if;
		
		dispData <= PC_Output(7 DOWNTO 0);
		Instruction <= IR_Output(15 DOWNTO 12);
	end process;
end rtl;

