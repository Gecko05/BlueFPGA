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
		i_PB : in STD_LOGIC_VECTOR(0 TO 1);
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
	
	signal i_ACCClear : STD_LOGIC;
	signal i_ACCBus : STD_LOGIC_VECTOR(15 DOWNTO 0) := STD_LOGIC_VECTOR(to_unsigned(0, 16));
	signal i_ACCTakeIn : STD_LOGIC;
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
		i_ACC : IN std_logic_vector(15 downto 0);
		i_NUM : IN std_logic_vector(15 downto 0);
		i_OP : IN std_logic_vector(2 downto 0);
		i_CLK : IN std_logic;          
		o_OF : OUT std_logic;
		o_ACC : OUT std_logic_vector(15 downto 0)
		);
	END COMPONENT;
	
	signal i_ACC : STD_LOGIC_VECTOR(15 downto 0) := STD_LOGIC_VECTOR(to_unsigned(0, 16));
	signal i_NUM : STD_LOGIC_VECTOR(15 downto 0) := STD_LOGIC_VECTOR(to_unsigned(0, 16));
	signal i_OP : STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
	signal o_OF : STD_LOGIC := '0';
	signal o_ACC : STD_LOGIC_VECTOR(15 downto 0) := STD_LOGIC_VECTOR(to_unsigned(0, 16));
	
	-- Control Unit signals
	signal Instruction : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
	signal STATE : STD_LOGIC := '0'; -- 0 is Fetch, 1 is Execute
	-- Buttons
	signal w_START : STD_LOGIC;
	signal w_STOP : STD_LOGIC;
	signal r_NEW_CYCLE : STD_LOGIC; -- Used as a lock to avoid going into CP(7) more than once
begin
	-- Clock and power
	CLK_Sys: clockSystem PORT MAP(
		i_CLK_100MHz => CLK_100MHz,
		o_CP => o_CP,
		o_CLK => CPU_CLK
	);
	o_LED <= o_CP;

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
		i_ACC => i_ACC,
		i_NUM => i_NUM,
		i_OP => i_OP,
		i_CLK => CPU_CLK,
		o_OF => o_OF,
		o_ACC => o_ACC
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
	w_START <= not(i_PB(0));
	w_STOP <= not(i_PB(1));
	
	controlLoop : process (o_CP, CPU_CLK, o_IRBus, Instruction, w_START, w_STOP, r_NEW_CYCLE) begin
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
				i_MBRClear <= '1';
				if STATE = '1' then
					i_ACCClear <= '1';
				end if;
			-- CLOCK PULSE 4
			elsif o_CP(3) = '1' then
				if STATE = '0' then
				-- Clear Instruction Register
					i_IRTakeIn <= '1';
				end if;
				i_MBRClear <= '0';
				i_ACCClear <= '0';
			-- CLOCK PULSE 5
			elsif o_CP(4) = '1' then
				i_IRTakeIn <= '0';
			-- CLOCK PULSE 6
			elsif o_CP(5) = '1' then
				if STATE = '0' and unsigned(Instruction) < 5 and unsigned(Instruction) > 0 then
					i_ZClear <= '1';
				elsif STATE = '1' and unsigned(Instruction) < 5 and unsigned(Instruction) > 0 then
					i_ACC <= o_MBRBus;
					i_NUM <= o_ZBus;
					i_OP <= "001";
				end if;
			-- CLOCK PULSE 7
			elsif o_CP(6) = '1' then
				if STATE = '0' and unsigned(Instruction) < 5 and unsigned(Instruction) > 0 then
					i_ZClear <= '0';
					i_ZTakeIn <= '1';
				elsif STATE = '1' and unsigned(Instruction) < 5 and unsigned(Instruction) > 0 then
					i_ACCBus <= o_ACC;
					i_ACCTakeIn <= '1';
				end if;
			-- CLOCK PULSE 8
			elsif o_CP(7) = '1' and r_NEW_CYCLE = '1' then
				if STATE = '0' then
					if unsigned(Instruction) < 5 and unsigned(Instruction) > 0 then
						STATE <= '1';
						i_MARBus <= o_IRBus(11 DOWNTO 0);
						i_MARTakeIn <= '1';
					else
						i_MARBus <= o_PCBus;
						i_MARTakeIn <= '1';
					end if;
				elsif STATE = '1' then
					if unsigned(Instruction) < 5 and unsigned(Instruction) > 0 then
						STATE <= '0';
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
			end if;
			
			-- STOP Button
			if w_STOP = '1' then
				r_RUN  <= '0';
			end if;
			
		-- START/RESUME
		elsif r_RUN = '0' then
			if w_START = '1' and o_CP(7) = '1' then
				r_RUN <= '1';
				--i_PCClear <= '1'; --Enable this to start PC from zero
			end if;
		end if;
	end process;
	Instruction <= o_IRBus(15 DOWNTO 12);
end rtl;

