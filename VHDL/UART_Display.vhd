----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:13:11 12/02/2021 
-- Design Name: 
-- Module Name:    UART_Display - Behavioral 
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

entity UART_Display is
	PORT (
			CLK_100MHz : IN STD_LOGIC;
			DEV_UART_RX : IN STD_LOGIC;
			DEV_UART_TX : OUT STD_LOGIC;
			o_LED : OUT STD_LOGIC_VECTOR(0 TO 2);
			SevenSegment : OUT STD_LOGIC_VECTOR(0 TO 7);
			SevenSegmentEnable : OUT STD_LOGIC_VECTOR(0 TO 2)
			);
	
end UART_Display;

architecture Behavioral of UART_Display is

    COMPONENT UART_RX
    PORT(
		 i_Clk       : in  std_logic;
		 i_RX_Serial : in  std_logic;
		 o_RX_DV     : out std_logic;
		 o_RX_Byte   : out std_logic_vector(7 downto 0)
       );
    END COMPONENT;
	 
	 signal RX_DATA : STD_LOGIC_VECTOR (7 DOWNTO 0) := "00000000";
	 signal RX_DV : STD_LOGIC;
	 
	 COMPONENT segDisp
	 PORT(
	 		i_CLK_100MHz : in STD_LOGIC;
			o_SevenSegment : out STD_LOGIC_VECTOR (0 TO 7);
			o_SevenSegmentEnable : out STD_LOGIC_VECTOR (2 DOWNTO 0);
			signal i_DATA : STD_LOGIC_VECTOR(7 DOWNTO 0)
		   );
	 END COMPONENT;
	 
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
	
	signal TX_DV : STD_LOGIC := '0';
	signal TX_BYTE : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"00";
	signal TX_Active : STD_LOGIC := '0';
	signal TX_Done : STD_LOGIC := '0';
begin
	RX_MODULE: UART_RX PORT MAP (
		 i_RX_Serial => DEV_UART_RX,
		 i_Clk => CLK_100MHz,
		 o_RX_DV => RX_DV,
		 o_RX_Byte => RX_DATA
	);
	  
	DISPLAY_MODULE: segDisp PORT MAP (
		 i_CLK_100MHz => CLK_100MHz,
		 o_SevenSegment => SevenSegment,
		 o_SevenSegmentEnable => SevenSegmentEnable,
		 i_DATA => RX_DATA
	);
	
	TX_MODULE: UART_TX PORT MAP(
		i_Clk => CLK_100MHz,
		i_TX_DV => RX_DV,
		i_TX_Byte => RX_DATA,
		o_TX_Active => TX_Active,
		o_TX_Serial => DEV_UART_TX,
		o_TX_Done => TX_Done
	);
end Behavioral;

