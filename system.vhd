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
		i_START : IN std_logic;
		i_STOP : IN std_logic;      
		i_HALT : IN std_logic;
		o_CP : OUT std_logic_vector(0 to 7);
		o_CLK : OUT std_logic
		);
	END COMPONENT;
	
	signal START : STD_LOGIC := '0';
	signal STOP : STD_LOGIC := '0';
	signal HALT : STD_LOGIC := '0';
	signal PB0 : STD_LOGIC;
	signal PB1 : STD_LOGIC;
	signal o_CP : STD_LOGIC_VECTOR(0 TO 7);
	signal CPU_CLK : STD_LOGIC;
	
-- Instruction Register component
	COMPONENT InstructionRegister
	PORT(
		i_Clock : IN std_logic;
		i_IRBus : IN std_logic_vector(0 to 15);
		i_IRTakeIn : IN std_logic;          
		o_IRBus : OUT std_logic_vector(0 to 15)
		);
	END COMPONENT;
	
	signal i_IRBus : STD_lOGIC_VECTOR(0 TO 15);
	signal i_IRTakeIn : STD_LOGIC;
	signal o_IRBus : STD_LOGIC_VECTOR(0 TO 15);
	
-- Memory Buffer Register component
	COMPONENT MemBufferRegister
	PORT(
		i_Clock : IN std_logic;
		i_MBRClear : IN std_logic;
		i_MBRBus : IN std_logic_vector(0 to 15);
		i_MBRReadBus : IN std_logic_vector(0 to 15);
		i_MBRTakeIn : IN std_logic;          
		o_MBRWriteBus : OUT std_logic_vector(0 to 15);
		o_MBRBus : OUT std_logic_vector(0 to 15);
		o_MBRWEA : OUT std_logic_vector(0 to 0)
		);
	END COMPONENT;
	
	signal i_MBRClear : STD_LOGIC;
	signal i_MBRBus : STD_LOGIC_VECTOR(0 TO 15);
	signal i_MBRReadBus : STD_LOGIC_VECTOR(0 TO 15);
	signal i_MBRTakeIn : STD_LOGIC;
	signal o_MBRWriteBus : STD_LOGIC_VECTOR(0 TO 15);
	SIGNAL O_MBRBus : STD_LOGIC_VECTOR(0 TO 15);
	signal o_MBRWea : STD_LOGIC_VECTOR(0 TO 0);
	
	-- Memory Address Register component
	COMPONENT MemAddrRegister
	PORT(
		i_Clock : IN std_logic;
		i_MARBus : IN std_logic_vector(0 to 11);
		i_MARTakeIn : IN std_logic;          
		o_MARBus : OUT std_logic_vector(0 to 11)
		);
	END COMPONENT;
	
	signal i_MARBus : STD_LOGIC_VECTOR(0 TO 11);
	signal i_MARTakeIn : STD_LOGIC;
	signal o_MARBus : STD_LOGIC_VECTOR(0 TO 11);
	
	-- Program Counter Register component
	COMPONENT programCounter
	PORT(
		i_Clock : IN std_logic;
		i_PCBus : IN std_logic_vector(0 to 11);
		i_PCInc : IN std_logic;
		i_PCClear : IN std_logic;
		i_PCTakeIn : IN std_logic;          
		o_PCBus : OUT std_logic_vector(0 to 11)
		);
	END COMPONENT;
	
	signal i_PCBus : STD_LOGIC_VECTOR(0 TO 11);
	signal i_PCInc : STD_LOGIC;
	signal i_PCClear : STD_LOGIC;
	signal i_PCTakeIn : STD_LOGIC;
	signal o_PCBus : STD_LOGIC_VECTOR(0 TO 11);
	
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
	
	-- Control Unit signals
	signal Instruction : STD_LOGIC_VECTOR(0 TO 3) := "1111";
begin
-- Clock and power
	CLK_Sys: clockSystem PORT MAP(
		i_CLK_100MHz => CLK_100MHz,
		i_START => START,
		i_STOP => STOP,
		i_HALT => HALT,
		o_CP => o_CP,
		o_CLK => CPU_CLK
	);
	PB0 <= not(i_PB(0));
	PB1 <= not(i_PB(1));
	START <= PB0;
	STOP <= PB1;
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
-- General connections between components
	i_RAMWea <= o_MBRWea;
	i_RAMDin <= o_MBRWriteBus;
	i_RAMAddr <= o_MARBus;
	i_MBRReadBus <= o_RAMDout;
	i_IRBus <= o_MBRBus;
	i_MARBus <= o_PCBus;
	o_LED <= o_CP;
	
	controlLoop : process (o_CP, CPU_CLK, o_IRBus, Instruction) begin
		if o_CP(0) = '1' then
			i_MARTakeIn <= '0';
		elsif o_CP(1) = '1' then
		-- Increment Program Counter
			i_PCInc <= '1';
		elsif o_CP(2) = '1' then
		-- Fetch Instruction
			i_PCInc <= '0';
			i_MBRClear <= '1';
		elsif o_CP(3) = '1' then
		-- Clear Instruction Register
			i_MBRClear <= '0';
			i_IRTakeIn <= '1';
		elsif o_CP(4) = '1' then
			i_IRTakeIn <= '0';
		elsif o_CP(5) = '1' then
			
		elsif o_CP(6) = '1' then

		elsif o_CP(7) = '1' then
			i_MARTakeIn <= '1';
		else
		end if;
		
		-- Instruction tree
		Instruction <= o_IRBus(0 TO 3);
		if Instruction = "0000" then
			HALT <= '0';
		elsif Instruction = "0001" then
			-- Do nothing
		end if;
	end process;
end rtl;

