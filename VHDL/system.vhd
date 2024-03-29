----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:38:57 07/19/2020 
-- Design Name: 
-- Module Name:    system - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: Implementation of the main interface for BLUE
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

entity system is
	Port(
		CLK_100MHz : in STD_LOGIC;
		Switch : in STD_LOGIC_VECTOR(0 TO 1);
		SevenSegment : OUT std_logic_vector(0 to 7);
		SevenSegmentEnable : OUT std_logic_vector(1 downto 0);
		o_LED : out STD_LOGIC_VECTOR(0 TO 7)
	);
end system;

architecture rtl of system is
-- Clock and power component
	COMPONENT clockSystem
	PORT(
		i_CLK_100MHz : IN std_logic;		
		o_CP : OUT std_logic_vector(0 to 7);
		o_CLK : OUT std_logic
		);
	END COMPONENT;
	
	signal r_RUN : STD_LOGIC := '0';
	signal o_CP : STD_LOGIC_VECTOR(0 TO 7);
	signal CPU_CLK : STD_LOGIC;
	
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
	
	signal i_Switch : std_logic_vector(1 downto 0) := STD_LOGIC_VECTOR(to_unsigned(0, 2));
	
-- Instruction Register component
	COMPONENT InstructionRegister
	PORT(
		i_Clock : IN std_logic;
		i_IRBus : IN std_logic_vector(15 DOWNTO 0);
		i_IRTakeIn : IN std_logic;          
		o_IRBus : OUT std_logic_vector(15 DOWNTO 0)
		);
	END COMPONENT;
	
	signal i_IRBus : STD_lOGIC_VECTOR(15 DOWNTO 0) := STD_LOGIC_VECTOR(to_unsigned(0, 16));
	signal i_IRTakeIn : STD_LOGIC := '0';
	signal o_IRBus : STD_LOGIC_VECTOR(15 DOWNTO 0);
	
-- Memory Buffer Register component
	COMPONENT MemBufferRegister
	PORT(
		i_Clock : IN std_logic;
		i_MBRClear : IN std_logic;
		i_MBRBus : IN std_logic_vector(15 DOWNTO 0);
		i_MBRReadBus : IN std_logic_vector(15 DOWNTO 0);
		i_MBRTakeIn : IN std_logic;          
		o_MBRWriteBus : OUT std_logic_vector(15 DOWNTO 0);
		o_MBRBus : OUT std_logic_vector(15 DOWNTO 0);
		o_MBRWEA : OUT std_logic_vector(0 DOWNTO 0)
		);
	END COMPONENT;
	
	signal i_MBRClear : STD_LOGIC := '0';
	signal i_MBRBus : STD_LOGIC_VECTOR(15 DOWNTO 0) := STD_LOGIC_VECTOR(to_unsigned(0, 16));
	signal i_MBRReadBus : STD_LOGIC_VECTOR(15 DOWNTO 0) := STD_LOGIC_VECTOR(to_unsigned(0, 16));
	signal i_MBRTakeIn : STD_LOGIC := '0';
	signal o_MBRWriteBus : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL O_MBRBus : STD_LOGIC_VECTOR(15 DOWNTO 0);
	signal o_MBRWea : STD_LOGIC_VECTOR(0 DOWNTO 0);
	
	-- Memory Address Register component
	COMPONENT MemAddrRegister
	PORT(
		i_Clock : IN std_logic;
		i_MARBus : IN std_logic_vector(11 DOWNTO 0);
		i_MARTakeIn : IN std_logic;          
		o_MARBus : OUT std_logic_vector(11 DOWNTO 0)
		);
	END COMPONENT;
	
	signal i_MARBus : STD_LOGIC_VECTOR(11 DOWNTO 0) := STD_LOGIC_VECTOR(to_unsigned(0, 12));
	signal i_MARTakeIn : STD_LOGIC := '0';
	signal o_MARBus : STD_LOGIC_VECTOR(11 DOWNTO 0);
	
	-- Program Counter Register component
	COMPONENT programCounter
	PORT(
		i_Clock : IN std_logic;
		i_PCBus : IN std_logic_vector(11 DOWNTO 0);
		i_PCInc : IN std_logic;
		i_PCClear : IN std_logic;
		i_PCTakeIn : IN std_logic;          
		o_PCBus : OUT std_logic_vector(11 DOWNTO 0)
		);
	END COMPONENT;
	
	signal i_PCBus : STD_LOGIC_VECTOR(11 DOWNTO 0) := STD_LOGIC_VECTOR(to_unsigned(0, 12));
	signal i_PCInc : STD_LOGIC := '0';
	signal i_PCClear : STD_LOGIC := '0';
	signal i_PCTakeIn : STD_LOGIC := '0';
	signal o_PCBus : STD_LOGIC_VECTOR(11 DOWNTO 0);
	
	-- RAM Block component
	COMPONENT RAMBlock
	PORT (
    clka : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
	END COMPONENT;
	
	signal i_RAMWea : STD_LOGIC_VECTOR(0 DOWNTO 0);
	signal i_RAMAddr : STD_LOGIC_VECTOR(11 DOWNTO 0);
	signal i_RAMDin : STD_LOGIC_VECTOR(15 DOWNTO 0);
	signal o_RAMDout : STD_LOGIC_VECTOR(15 DOWNTO 0);
	
	-- ACC Register component
	COMPONENT AccumulatorRegister
	PORT(
		i_Clock : IN std_logic;
		i_ACCClear : IN std_logic;
		i_ACCBus : IN std_logic_vector(15 downto 0);
		i_ACCTakeIn : IN std_logic;          
		o_ACCBus : OUT std_logic_vector(15 downto 0)
		);
	END COMPONENT;
	
	signal i_ACCClear : STD_LOGIC := '0';
	signal i_ACCBus : STD_LOGIC_VECTOR(15 DOWNTO 0) := STD_LOGIC_VECTOR(to_unsigned(0, 16));
	signal i_ACCTakeIn : STD_LOGIC := '0';
	signal o_ACCBus : STD_LOGIC_VECTOR(15 DOWNTO 0);
	
	-- Z Register component
	
	COMPONENT ZRegister
	PORT(
		i_Clock : IN std_logic;
		i_ZClear : IN std_logic;
		i_ZBus : IN std_logic_vector(15 downto 0);
		i_ZTakeIn : IN std_logic;          
		o_ZBus : OUT std_logic_vector(15 downto 0)
		);
	END COMPONENT;
	
	signal i_ZClear : STD_LOGIC := '0';
	signal i_ZBus : STD_LOGIC_VECTOR(15 DOWNTO 0);
	signal i_ZTakeIn : STD_LOGIC := '0';
	signal o_ZBus : STD_LOGIC_VECTOR(15 DOWNTO 0);
	
	-- ALU component
	COMPONENT ArithmeticLogicUnit
	PORT(
		i_ALU : IN std_logic_vector(15 downto 0);
		i_NUM : IN std_logic_vector(15 downto 0);
		i_OP : IN std_logic_vector(2 downto 0);
		i_CLK : IN std_logic;          
		o_OF : OUT std_logic;
		o_ALU : OUT std_logic_vector(15 downto 0)
		);
	END COMPONENT;
	
	signal i_ALU : STD_LOGIC_VECTOR(15 downto 0) := STD_LOGIC_VECTOR(to_unsigned(0, 16));
	signal i_NUM : STD_LOGIC_VECTOR(15 downto 0) := STD_LOGIC_VECTOR(to_unsigned(0, 16));
	signal i_OP : STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
	signal o_OF : STD_LOGIC := '0';
	signal o_ALU : STD_LOGIC_VECTOR(15 downto 0) := STD_LOGIC_VECTOR(to_unsigned(0, 16));
	
	-- Control Unit signals
	signal Instruction : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
	signal STATE : STD_LOGIC := '0'; -- 0 is Fetch, 1 is Execute
	-- Buttons
	signal w_STOP : STD_LOGIC := '0';
	signal w_START : STD_LOGIC := '1';
	signal r_NEW_CYCLE : STD_LOGIC := '0'; -- Used as a lock to avoid going into CP(7) more than once
begin
	-- Clock and power
	CLK_Sys: clockSystem PORT MAP(
		i_CLK_100MHz => CLK_100MHz,
		o_CP => o_CP,
		o_CLK => CPU_CLK
	);
	o_LED <= o_CP;

	-- Seven Segment Display
	Inst_segDisp: segDisp PORT MAP(
		i_CLK_100MHz => CLK_100MHz,
		o_SevenSegment => SevenSegment,
		o_SevenSegmentEnable => SevenSegmentEnable,
		i_DATA => dispData
	);
	-- Debounce switches
	Debounce_Switch0: Debounce_Switch PORT MAP(
		i_Clk => CLK_100MHz,
		i_Switch => Switch(0),
		o_Switch => i_Switch(0)
	);
	
	Debounce_Switch1: Debounce_Switch PORT MAP(
		i_Clk => CLK_100MHz,
		i_Switch => Switch(1),
		o_Switch => i_Switch(1)
	);
	-- Instruction register
	IR: InstructionRegister PORT MAP(
		i_Clock => CPU_CLK,
		i_IRBus => i_IRBus,
		i_IRTakeIn => i_IRTakeIn,
		o_IRBus => o_IRBus
	);
	-- Memory Address register
	MAR: MemAddrRegister PORT MAP(
		i_Clock => CPU_CLK,
		i_MARBus => i_MARBus,
		i_MARTakeIn => i_MARTakeIn,
		o_MARBus => o_MARBus
	);
	-- Memory Buffer register
	MBR: MemBufferRegister PORT MAP(
		i_Clock => CPU_CLK,
		i_MBRClear => i_MBRClear,
		i_MBRBus => i_MBRBus,
		i_MBRReadBus => i_MBRReadBus,
		i_MBRTakeIn => i_MBRTakeIn,
		o_MBRWriteBus => o_MBRWriteBus,
		o_MBRBus => o_MBRBus,
		o_MBRWEA => o_MBRWea
	);
	-- Program Counter register
	PC: programCounter PORT MAP(
		i_Clock => CPU_CLK,
		i_PCBus => i_PCBus,
		o_PCBus => o_PCBus,
		i_PCInc => i_PCInc,
		i_PCClear => i_PCClear,
		i_PCTakeIn => i_PCTakeIn
	);
	-- RAM Block
	RAM_Blk : RAMBlock
	  PORT MAP (
		 clka => CPU_CLK,
		 wea => i_RAMWea,
		 addra => i_RAMAddr,
		 dina => i_RAMDin,
		 douta => o_RAMDout
	  );
	-- ACC Register
	ACC: AccumulatorRegister PORT MAP(
		i_Clock => CPU_CLK,
		i_ACCClear => i_ACCClear,
		i_ACCBus => i_ACCBus,
		i_ACCTakeIn => i_ACCTakeIn,
		o_ACCBus => o_ACCBus
	);
	-- Z Register
	ZREG: ZRegister PORT MAP(
		i_Clock => CPU_CLK,
		i_ZClear => i_ZClear,
		i_ZBus => i_ZBus,
		i_ZTakeIn => i_ZTakeIn,
		o_ZBus => o_ZBus
	);
	-- ALU
	ALU: ArithmeticLogicUnit PORT MAP(
		i_ALU => i_ALU,
		i_NUM => i_NUM,
		i_OP => i_OP,
		i_CLK => CPU_CLK,
		o_OF => o_OF,
		o_ALU => o_ALU
	);
	-----------------------------------------
	  
	-- General connections between components
	i_RAMWea <= o_MBRWea;
	i_RAMDin <= o_MBRWriteBus;
	i_RAMAddr <= o_MARBus;
	i_MBRReadBus <= o_RAMDout;
	i_IRBus <= o_MBRBus;
	-- ALU connections
	i_ZBus <= o_ACCBus;
	
	--i_PCBus <= o_IRBus(0 TO 11);
	o_LED <= o_CP;
	-- Start and stop buttonns
	w_START <= not(i_Switch(0));
	w_STOP <= not(i_Switch(1));
	dispData <= o_ACCBus(7 downto 0);
	controlLoop : process (CLK_100MHz, o_CP, CPU_CLK, o_IRBus, Instruction, r_NEW_CYCLE, r_RUN, o_ACCBus,
									STATE, o_PCBus, o_MBRBus, o_ZBus, o_ALU, i_Switch) begin
	if rising_edge(CLK_100MHz) then
		if r_RUN = '1' then
			-- Control Unit
			-- Shared Clock routines for all instructions
			-- CLOCK PULSE 1
			if o_CP(0) = '1' then
				i_MARTakeIn <= '0';
				i_PCTakeIn <= '0';
				i_PCClear <= '0';
				r_NEW_CYCLE <= '1';
			-- CLOCK PULSE 2
			elsif o_CP(1) = '1' then
				if STATE = '0' then
				-- Increment Program Counter
					i_PCInc <= '1';
				end if;
			-- CLOCK PULSE 3
			elsif o_CP(2) = '1' then
			-- Fetch Instruction
				i_PCInc <= '0';
				if STATE = '0' then
					i_MBRClear <= '1';
				end if;
			-- CLOCK PULSE 4
			elsif o_CP(3) = '1' then
				if STATE = '0' then
				-- Clear Instruction Register
					i_IRTakeIn <= '1';
					i_MBRClear <= '0';
				end if;
			-- CLOCK PULSE 5
			elsif o_CP(4) = '1' then
				i_IRTakeIn <= '0';
			-- CLOCK PULSE 8
			elsif o_CP(7) = '1' and r_NEW_CYCLE = '1' then
				if STATE = '0' then
					if unsigned(Instruction) >= 5 or unsigned(Instruction) = 0 then
						i_MARBus <= o_PCBus;
						i_MARTakeIn <= '1';
					end if;
				end if;
				i_ACCTakeIn <= '0';
				i_ZTakeIn <= '0';
				r_NEW_CYCLE <= '0';
			else
			end if;
			
			-- This code is a mess, need to refactor with functions or something
			-- Instruction tree
			-- HALT
			if Instruction = "0000" and o_CP(5) = '1' then
				r_RUN <= '0';
			-- JMP
			elsif Instruction = "1010" then 
				if o_CP(5) = '1' then
					i_PCClear <= '1';
				elsif o_CP(6) = '1' then
					i_PCClear <= '0';
					i_PCBus <= o_IRBus(11 DOWNTO 0);
					i_PCTakeIn <= '1';
				else
					i_PCTakeIn <= '0';
					i_PCClear <= '0';
				end if;
			-- ADD, AND, XOR, IOR
			elsif unsigned(Instruction) < 5 and unsigned(Instruction) > 0 then
				if STATE = '0' then
					if o_CP(5) = '1' then
						i_ZClear <= '1';
					elsif o_CP(6) = '1' then
						i_ZClear <= '0';
						i_ZTakeIn <= '1';
					elsif o_CP(7) = '1' then
						STATE <= '1';
						i_ZTakeIn <= '0';
						i_MARBus <= o_IRBus(11 DOWNTO 0);
						i_MARTakeIn <= '1';
					end if;
				else
					if o_CP(2) = '1' then
						i_ACCClear <= '1';
						i_MBRClear <= '1';
					elsif o_CP(3) = '1' then
						i_ACCClear <= '0';
						i_MBRClear <= '0';
					elsif o_CP(5) = '1' then
						i_ALU <= o_MBRBus;
						i_NUM <= o_ZBus;	
						i_OP <= Instruction(2 DOWNTO 0);
					elsif o_CP(6) = '1' then
						i_ACCBus <= o_ALU;
						i_ACCTakeIn <= '1';
					elsif o_CP(7) = '1' then
						STATE <= '0';
						i_MARBus <= o_PCBus;
						i_MARTakeIn <= '1';
					end if;
				end if;
			elsif Instruction = "0101" then
				if STATE = '0' then
					if o_CP(5) = '1' then
						i_ZClear <= '1';
					elsif o_CP(6) = '1' then
						i_ZClear <= '0';
						i_ZTakeIn <= '1';
					elsif o_CP(7) = '1' then
						i_ZTakeIn <= '0';
						STATE <= '1';
					end if;
				elsif STATE = '1' then
					if o_CP(0) = '1' then
						i_ACCClear <= '1';
					elsif o_CP(1) = '1' then
						i_ACCClear <= '0';
						i_ACCBus <= NOT(o_ZBus);
						i_ACCTakeIn <= '1';
					elsif o_CP(2) = '1' then
						i_ACCTakeIn <= '0';
						i_ACCBus <= o_ALU;
					elsif o_CP(7) = '1' then
						STATE <= '0';
						i_MARBus <= o_PCBus;
						i_MARTakeIn <= '1';
					end if;
				end if;
			elsif Instruction = "0110" then
				if STATE = '0' then
					if o_CP(7) = '1' then
						STATE <= '1';
						i_MARBus <= o_IRBus(11 DOWNTO 0);
					end if;
				else
					if o_CP(1) = '1' then
						i_ACCClear <= '1';
					elsif o_CP(2) = '1' then
						i_ACCClear <= '0';
						i_MBRClear <= '1';
					elsif o_CP(3) = '1' then
						i_MBRClear <= '0';
						i_ACCBus <= o_MBRBus;
					elsif o_CP(4) = '1' then
						i_ACCTakeIn <= '1';
					elsif o_CP(5) = '1' then
						i_ACCTakeIn <= '0';
						i_ACCBus <= o_ALU;
					elsif o_CP(7) = '1' then
						STATE <= '0';
						i_MARBus <= o_PCBus;
						i_MARTakeIn <= '1';
					end if;
				end if;
			elsif Instruction = "0111" then
				if STATE = '0' then
					if o_CP(7) = '1' then
						STATE <= '1';
						i_MARBus <= o_IRBus(11 DOWNTO 0);
					end if;
				else
					if o_CP(3) = '1' then
						i_MBRClear <= '1';
					elsif o_CP(4) = '1' then
						i_MBRClear <= '0';
						i_MBRBus <= o_ACCBus;
						i_MBRTakeIn <= '1';
					elsif o_CP(5) = '1' then
						i_MBRTakeIn <= '0';
					elsif o_CP(7) = '1' then
						STATE <= '0';
						i_MARBus <= o_PCBus;
						i_MARTakeIn <= '1';
					end if;
				end if;
			end if;
			-- STOP Button
			if w_START = '0' and w_STOP = '1' then
				r_RUN  <= '0';
			end if;
			
		-- START/RESUME
		elsif r_RUN = '0' then
			if w_START = '1' and w_STOP = '0' and o_CP(7) = '1' then
				r_RUN <= '1';
			end if;
		end if;
	end if;
	end process;
	Instruction <= o_IRBus(15 DOWNTO 12);
end rtl;

