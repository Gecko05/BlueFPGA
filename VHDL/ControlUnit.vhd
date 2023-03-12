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
		Switch : in std_logic_vector(0 TO 0);
		UART_RX : out std_logic;
		o_LED : out std_logic_vector(0 TO 0);
		SevenSegment : out std_logic_vector(0 TO 7);
		SevenSegmentEnable : out std_logic_vector(0 TO 1)
	);
end ControlUnit;

architecture rtl of ControlUnit is

-- Clock and power component
	COMPONENT clockSystem
	PORT(
		i_CLK_100MHz : IN std_logic;		
		o_CLK : OUT std_logic
		);
	END COMPONENT;
	
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
	
	signal i_Button : std_logic_vector (0 DOWNTO 0) := std_logic_vector(to_unsigned(0, 1));
	signal o_Switch : std_logic_vector (0 DOWNTO 0) := std_logic_vector(to_unsigned(0, 1));
	
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
	
-- ALU
	COMPONENT ArithmeticLogicUnit
	PORT(
		S : IN std_logic_vector(3 downto 0);
		A : IN std_logic_vector(15 downto 0);
		B : IN std_logic_vector(15 downto 0);          
		OVR : OUT std_logic;
		F : OUT std_logic_vector(15 downto 0)
		);
	END COMPONENT;
	
	signal ALU_OP : STD_LOGIC_VECTOR(3 DOWNTO 0) := STD_LOGIC_VECTOR(to_unsigned(1, 4));
	signal ALU_InputA : STD_LOGIC_VECTOR(15 DOWNTO 0) := STD_LOGIC_VECTOR(to_unsigned(0, 16));
	signal ALU_InputB :STD_LOGIC_VECTOR(15 DOWNTO 0) := STD_LOGIC_VECTOR(to_unsigned(0, 16));
	signal ALU_Overflow : STD_LOGIC := '0';
	signal ALU_Output : STD_LOGIC_VECTOR(15 DOWNTO 0) := STD_LOGIC_VECTOR(to_unsigned(0, 16));

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
	signal IR_Clear : STD_LOGIC := '1';
	signal IR_Output : STD_LOGIC_VECTOR(15 DOWNTO 0) := STD_LOGIC_VECTOR(to_unsigned(0, 16));
	signal IR_Load : STD_LOGIC := '0';
	
	signal ACC_Input : STD_LOGIC_VECTOR(15 DOWNTO 0) := STD_LOGIC_VECTOR(to_unsigned(0, 16));
	signal ACC_Clear : STD_LOGIC := '1';
	signal ACC_Output : STD_LOGIC_VECTOR(15 DOWNTO 0) := STD_LOGIC_VECTOR(to_unsigned(0, 16));
	signal ACC_Load : STD_LOGIC := '0';
	
	signal Z_Input : STD_LOGIC_VECTOR(15 DOWNTO 0) := STD_LOGIC_VECTOR(to_unsigned(0, 16));
	signal Z_Clear : STD_LOGIC := '1';
	signal Z_Output : STD_LOGIC_VECTOR(15 DOWNTO 0) := STD_LOGIC_VECTOR(to_unsigned(0, 16));
	signal Z_Load : STD_LOGIC := '0';
	
-- Debugging
	COMPONENT RegReporter
	PORT(
		i_CLK : IN std_logic;
		i_ACC : IN std_logic_vector(15 downto 0);
		i_EN : IN std_logic;          
		o_TX : OUT std_logic;
		o_DONE : OUT std_logic
		);
	END COMPONENT;
	
	signal o_RR_EN : std_logic := '0';
	signal i_RR_Done : std_logic := '0';
	
-- State
	signal STATE : STD_LOGIC := '0'; -- Two States, 0 Fetch, 1 Execute
	signal Instruction : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
	type FSM is (FETCH_1, FETCH_2, FETCH_3, FETCH_4, FETCH_5, FETCH_6, FETCH_7, FETCH_8, 
					 NOP_8,
					 HLT_1, HLT_7,
					 JMP_6, JMP_7, JMP_8,
					 JMA_6, JMA_7, JMA_8,
					 -- Double Cycle Instructions
					 ADD_6, ADD_7, ADD_8, ADD_9, ADD_10, ADD_11, ADD_12, ADD_13, ADD_14, ADD_15, ADD_16
					 );
	signal next_state: FSM := FETCH_2;
	signal current_state: FSM := FETCH_1;
begin
-- Clock
	CLK_Sys: clockSystem PORT MAP(
		i_CLK_100MHz => CLK_100MHz,
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
--	Inst_Debounce_Switch1: Debounce_Switch PORT MAP(
--		i_Clk => CLK_100MHz,
--		i_Switch => Switch(1),
--		o_Switch => o_Switch(1)
--	);
	
-- Memory Address Register
	Inst_MemAddrRegister: MemAddrRegister PORT MAP(
		i_Clock => CPU_CLK,
		i_Bus => MAR_Input,
		i_Load => MAR_Load,
		o_Bus => MAR_Output
	);
	
-- Memory Buffer Register
	Inst_MemBufferRegister: MemBufferRegister PORT MAP(
		i_Clock => CPU_CLK,
		i_Clear => MBR_Clear,
		i_Bus => MBR_Input,
		i_ReadBus => MBR_ReadBus,
		i_Load => MBR_Load,
		o_WriteBus => MBR_WriteBus,
		o_Bus => MBR_Output,
		o_WEA => MBR_WEA
	);
	
-- Arithmetic Logic Unit
	Inst_ArithmeticLogicUnit: ArithmeticLogicUnit PORT MAP(
		S => ALU_OP,
		A => ALU_InputA,
		B => ALU_InputB,
		OVR => ALU_Overflow,
		F => ALU_Output
	);
	
-- Instruction Register
	Inst_GenericReg: GenericReg PORT MAP(
		Clock => CPU_CLK,
		Clear => IR_Clear,
		Load => IR_Load,
		D => IR_Input,
		Q => IR_Output
	);
	
-- Accumulator Register
	Acc_GenericReg: GenericReg PORT MAP(
		Clock => CPU_CLK,
		Clear => ACC_Clear,
		Load => ACC_Load,
		D => ACC_Input,
		Q => ACC_Output
	);
	
-- Z Register
	Z_GenericReg: GenericReg PORT MAP(
		Clock => CPU_CLK,
		Clear => Z_Clear,
		Load => Z_Load,
		D => Z_Input,
		Q => Z_Output
	);
	
-- RAM Block
	RAM : RAM_Block PORT MAP (
		 clka => CPU_CLK,
		 wea => MBR_WEA,
		 addra => MAR_Output,
		 dina => MBR_WriteBus,
		 douta => MBR_ReadBus
	);
	
-- Program Counter
	Inst_programCounter: programCounter PORT MAP(
		i_Clock => CPU_CLK,
		i_PCBus => PC_Input,
		o_PCBus => PC_Output,
		i_PCInc => PC_Inc,
		i_PCClear => PC_Clear,
		i_PCLoad => PC_Load
	);

-- Debugging
	Inst_RegReporter: RegReporter PORT MAP(
		i_CLK => CLK_100MHz,
		o_TX => UART_RX,
		i_ACC => ACC_Output,
		i_EN => o_RR_EN,
		o_DONE => i_RR_Done
	);
	
-- Board	
	o_LED(0) <= CPU_CLK;
	i_Button <= NOT(o_Switch);
	
-- Permanent connections
	IR_Input <= MBR_Output;
	
-- This will change
	--MAR_Input <= PC_Output;
	--ALU_OP <= "001";

	ALU_InputA <= ACC_Output;
	ALU_InputB <= Z_Output;
	
-- Initialization
	MBR_Input <= std_logic_vector(to_unsigned(0, 16));

	process (CPU_CLK, next_state) begin
		if rising_edge(CPU_CLK) then
			current_state <= next_state;
		end if;
	end process;
	
	CU_loop : process(CPU_CLK, dispData, IR_Output, Instruction, PC_Output, ACC_Output, i_Button, MBR_Output, ALU_Output, ALU_Overflow, current_state, i_RR_Done) begin
		PC_Load <= '0';
		PC_Clear <= '0';
		MAR_Load <= '0';
		MBR_Load <= '0';
		PC_Inc <= '0';
		MBR_Clear <= '0';
		IR_Clear <= '0';
		IR_Load <= '0';
		ACC_Clear <= '0';
		ACC_Load <= '0';
		Z_Clear <= '0';
		Z_Load <= '0';
		o_RR_EN <= '0';
		ACC_Input <= MBR_Output;
		MAR_Input <= PC_Output;
		PC_Input <= std_logic_vector(to_unsigned(0, 12));
		case current_state is
----  FETCH  -------------------------
			when FETCH_1 =>
				o_RR_EN <= '1';
				--if i_Button(1) = '1' then
					--next_state <= HLT_1;
				--else
				if i_RR_Done = '1' then
					next_state <= FETCH_2;
				end if;
					--Z_Clear <= '1';
					--ACC_Clear <= '1';
				--end if;
			when FETCH_2 =>
				PC_Inc <= '1';
				next_state <= FETCH_3;
			when FETCH_3 =>
				MBR_Clear <= '1';
				IR_Clear <= '1';
				next_state <= FETCH_4;
			when FETCH_4 =>
				IR_Load <= '1';
				next_state <= FETCH_5;
			when FETCH_5 =>
				if Instruction = "1010" then
					next_state <= JMP_6;
				elsif Instruction = "1001" then
					next_state <= JMA_6;
				elsif Instruction = "0001" then
					next_state <= ADD_6;
				else
					next_state <= FETCH_6;
				end if;
			when FETCH_6 =>
				if Instruction = "0000" then
					next_state <= HLT_7;
				else
					next_state <= FETCH_7;
				end if;
			when FETCH_7 =>
				if Instruction = "1111" then
					next_state <= NOP_8;
				else
					next_state <= FETCH_8;
				end if;
			when FETCH_8 =>
				next_state <= FETCH_1;
----  NOP  ---------------------------
			when NOP_8 =>
				MAR_Load <= '1';
				next_state <= FETCH_1;
----  HLT  ---------------------------
			when HLT_1 =>
				if i_Button(0) = '1' then
					next_state <= FETCH_1;
				else
					next_state <= HLT_1;
				end if;
			when HLT_7 =>
				MAR_Load <= '1';
				next_state <= HLT_1;
----  JMP  ---------------------------
			when JMP_6 =>
				PC_Clear <= '1';
				next_state <= JMP_7;
			when JMP_7 =>
				PC_Input <= IR_Output(11 DOWNTO 0);
				PC_Load <= '1';
				next_state <= JMP_8;
			when JMP_8 =>
				MAR_Load <= '1';
				next_state <= FETCH_1;
----  JMA  ---------------------------
			when JMA_6 =>
				if ACC_Output(14) = '1' then
					PC_Clear <= '1';
				end if;
				next_state <= JMA_7;
			when JMA_7 =>
				if ACC_Output(14) = '1' then
					PC_Input <= IR_Output(11 DOWNTO 0);
					PC_Load <= '1';
				end if;				
				next_state <= JMA_8;
			when JMA_8 =>
				MAR_Load <= '1';
				next_state <= FETCH_1;
----  ADD  --------------------------
			when ADD_6 =>
				Z_Clear <= '1';
				next_state <= ADD_7;
			when ADD_7 =>
				Z_Input <= ACC_Output;
				Z_Load <= '1';
				next_state <= ADD_8;
			when ADD_8 =>
				MAR_Input <= IR_Output(11 DOWNTO 0);
				MAR_Load <= '1';
				next_state <= ADD_9;
			when ADD_9 =>
				next_state <= ADD_10;
			when ADD_10 =>
				MBR_Clear <= '1';
				next_state <= ADD_11;
			when ADD_11 =>
				next_state <= ADD_12;
			when ADD_12 =>
				ACC_Input <= MBR_Output;
				ACC_Load <= '1';
				next_state <= ADD_13;
			when ADD_13 =>
				next_state <= ADD_14;
			when ADD_14 =>
				ALU_OP <= IR_Output(15 DOWNTO 12);
				next_state <= ADD_15;
			when ADD_15 =>
				ACC_Input <= ALU_Output;
				ACC_Load <= '1';
				if ALU_Overflow = '1' then
					next_state <= HLT_7;
				else
					next_state <= ADD_16;
				end if;
			when ADD_16 =>
				MAR_Load <= '1';
				next_state <= FETCH_1;
-------------------------------------
			when others =>
				next_state <= FETCH_1;
		end case;
		
		dispData <= PC_Output(7 DOWNTO 0);
		Instruction <= IR_Output(15 DOWNTO 12);
	end process;
end rtl;

