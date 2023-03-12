----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:50:03 03/12/2023 
-- Design Name: 
-- Module Name:    RegReporter - Behavioral 
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity RegReporter is
	PORT(
		i_CLK : IN std_logic; --100 MHz
		o_TX : OUT std_logic;
		i_ACC : IN std_logic_vector(15 DOWNTO 0);
		i_EN : IN std_logic;
		o_DONE : OUT std_logic
	);
end RegReporter;

architecture Behavioral of RegReporter is

	COMPONENT UART_TX
	PORT(
		i_Clk : IN std_logic;
		i_TX_DV : IN std_logic;
		i_TX_Byte : IN std_logic_vector(7 downto 0);          
		o_TX_Active : OUT std_logic;
		o_TX_Serial : OUT std_logic;
		o_TX_Done : OUT std_logic
		);
	END COMPONENT;
	
	signal o_TX_DV : std_logic := '0';
	signal o_TX_Byte : std_logic_vector (7 downto 0);
	signal i_TX_Active : std_logic := '0';
	signal i_TX_Done : std_logic := '0';
	
	signal Send : std_logic := '0';
	signal r_Done : std_logic := '0';
	
	type FSM is (IDLE,
					 SEND_ACC_0,
					 SEND_ACC_1
					 );
	signal next_state: FSM := IDLE;
	signal current_state: FSM := IDLE;
begin
	Inst_UART_TX: UART_TX PORT MAP(
		i_Clk => i_CLK,
		i_TX_DV => o_TX_DV,
		i_TX_Byte => o_TX_Byte,
		o_TX_Active => i_TX_Active,
		o_TX_Serial => o_TX,
		o_TX_Done => i_TX_Done
	);

	process (i_CLK, next_state) begin
		if rising_edge(i_CLK) then
			if i_TX_Active = '0' and o_TX_DV = '0' then
				current_state <= next_state;
			end if;
		end if;
	end process;

	Send_loop : process(i_CLK, i_EN, current_state, i_ACC, i_TX_Done) begin
		o_DONE <= '0';
		case current_state is 
			when IDLE =>
				if rising_edge(i_EN) then
					next_state <= SEND_ACC_0;
				end if;
			when SEND_ACC_0 =>
				o_TX_Byte <= i_ACC(15 DOWNTO 8);
				o_TX_DV <= '1';
				if i_TX_Done = '1' then
					o_TX_DV <= '0';
					next_state <= SEND_ACC_1;
				end if;
			when SEND_ACC_1 =>
				o_TX_Byte <= i_ACC(7 DOWNTO 0);
				o_TX_DV <= '1';
				if i_TX_Done = '1' then
					next_state <= IDLE;
					o_TX_DV <= '0';
					o_DONE <= '1';
				end if;
			when others =>
				next_state <= IDLE;
		end case;
	end process;

end Behavioral;

