-- TestBench Template 

  LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;

  ENTITY testbench IS
  END testbench;

  ARCHITECTURE behavior OF testbench IS 

  -- Component Declaration
          COMPONENT segDisp
          PORT(
					i_CLK_100MHz : in STD_LOGIC;
					o_SevenSegment : out STD_LOGIC_VECTOR (0 TO 7);
					o_SevenSegmentEnable : out STD_LOGIC_VECTOR (2 DOWNTO 0);
					signal i_DATA : STD_LOGIC_VECTOR(7 DOWNTO 0)
           );
          END COMPONENT;
	
			 SIGNAL CLK100MHz : std_logic := '0';
			 SIGNAL SevenSegment : STD_LOGIC_VECTOR (0 TO 7);
          SIGNAL SevenSegmentEnable :  STD_LOGIC_VECTOR (2 DOWNTO 0);
          SIGNAL DATA :  std_logic_vector(7 downto 0);
			
			 constant CLK100MHz_period : time := 10 ns;

  BEGIN

  -- Component Instantiation
          Display: segDisp PORT MAP(
                  i_CLK_100MHz => CLK100MHz,
						o_SevenSegmentEnable => SevenSegmentEnable,
						i_DATA => DATA,
                  o_SevenSegment => SevenSegment
          );
	
			 CLK100MHz_process :process
			 begin
				CLK100MHz <= '0';
				wait for CLK100MHz_period/2;
				CLK100MHz <= '1';
				wait for CLK100MHz_period/2;
			 end process;

  --  Test Bench Statements
     tb : PROCESS
     BEGIN

        wait for 100 ns; -- wait until global set/reset completes

        -- Add user defined stimulus here
		  DATA <= "00000000";
		  wait for 10 ms;
		  DATA <= "00000001";
		  wait for 10 ms;
		  DATA <= "00000010";
		  wait for 10 ms;
		  DATA <= "00000011";
		  wait for 10 ms;
		  DATA <= "00000100";
		  wait for 10 ms;
        wait; -- will wait forever
     END PROCESS tb;
  --  End Test Bench 

  END;
