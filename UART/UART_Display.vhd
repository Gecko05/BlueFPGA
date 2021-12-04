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
			o_LED : OUT STD_LOGIC_VECTOR(0 TO 2);
			SevenSegment : OUT STD_LOGIC_VECTOR(0 TO 7);
			SevenSegmentEnable : OUT STD_LOGIC_VECTOR(0 TO 2)
			);
	
end UART_Display;

architecture Behavioral of UART_Display is

    COMPONENT UART_RX
    PORT(
         i_RX : in  STD_LOGIC;
         i_CLK_100MHz : in  STD_LOGIC;
			o_LEDs : out STD_LOGIC_VECTOR (0 TO 2);
			o_RXDATA : out STD_LOGIC_VECTOR (7 DOWNTO 0)
        );
    END COMPONENT;
	 
	 signal RX_DATA : STD_LOGIC_VECTOR (7 DOWNTO 0) := "00000000";
	 
	 COMPONENT segDisp
	 PORT(
	 		i_CLK_100MHz : in STD_LOGIC;
			o_SevenSegment : out STD_LOGIC_VECTOR (0 TO 7);
			o_SevenSegmentEnable : out STD_LOGIC_VECTOR (2 DOWNTO 0);
			signal i_DATA : STD_LOGIC_VECTOR(7 DOWNTO 0)
		   );
	 END COMPONENT;
begin
	RX_MODULE: UART_RX PORT MAP (
		 i_RX => DEV_UART_RX,
		 i_CLK_100MHz => CLK_100MHz,
		 o_LEDs => o_LED,
		 o_RXDATA => RX_DATA
	);
	  
	DISPLAY_MODULE: segDisp PORT MAP (
		 i_CLK_100MHz => CLK_100MHz,
		 o_SevenSegment => SevenSegment,
		 o_SevenSegmentEnable => SevenSegmentEnable,
		 i_DATA => RX_DATA
	);

end Behavioral;

