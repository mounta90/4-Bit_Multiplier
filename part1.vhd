LIBRARY ieee;
USE ieee.std_logic_1164.all;


ENTITY part1 IS 
   PORT ( SW: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			 p: buffer STD_LOGIC_VECTOR(7 DOWNTO 0);	--had to change to buffer to remove error
          HEX5,HEX4,HEX2,HEX0: OUT STD_LOGIC_VECTOR(0 TO 6));  
END part1;


ARCHITECTURE Structure OF part1 IS

	--initial carry in bit that has a value of zero
		signal ZEROcarryIN: std_logic;
		
	--first row carry out vector from the first row of full adders
		signal carryOUT_row1: std_logic_vector(3 downto 0);
		
	--second row carry out vector from the second row of full adders
		signal carryOUT_row2: std_logic_vector(3 downto 0);
	
	--third row carry out vector from the third row of full adders
		signal carryOUT_row3: std_logic_vector(3 downto 0);
		
	--fourth full adder 'a' signal = 0
		signal fa4_a: std_logic;
	
	--p0 has no signals, just output
	
	--p1 signals
		signal a1b0, a0b1: std_logic;
	
	--p2 signals
		signal a2b0, a1b1, fa_OF_a2b0_a1b1, a0b2: std_logic;
		
	--p3 signals
		signal a3b0, a2b1, fa_OF_a3b0_a2b1, a1b2, fa_OF_a1b2_fa_OF_a3b0_a2b1, a0b3: std_logic;
		
	--p4 signals
		signal a3b1, fa_OF_a3b1_0, a2b2, fa_OF_a2b2_fa_OF_a3b1_0, a1b3: std_logic;
		
	--p5 signals
		signal a3b2, fa_OF_a3b2_c0fa_a3b1_0, a2b3: std_logic;
		
	--p6 signals
		signal a3b3: std_logic;
		
	--p7 has no signals, just output
	
	component fa is
		port(
				a, b, ci: in std_logic;
				s, co: out std_logic);
	end component;
	
	
	component hex7seg is
   port ( hex     : in  std_logic_vector(3 downto 0);
          display : out STD_LOGIC_VECTOR(0 to 6));
	end component;

	
BEGIN

	ZEROcarryIN <= '0';
	fa4_a <= '0';
	a1b0 <= SW(5) and SW(0);
	a0b1 <= SW(4) and SW(1);
	a2b0 <= SW(6) and SW(0);
	a1b1 <= SW(5) and SW(1);
	a0b2 <= SW(4) and SW(2);
	a3b0 <= SW(7) and SW(0);
	a2b1 <= SW(6) and SW(1);
	a1b2 <= SW(5) and SW(2);
	a0b3 <= SW(4) and SW(3);
	a3b1 <= SW(7) and SW(1);
	a2b2 <= SW(6) and SW(2);
	a1b3 <= SW(5) and SW(3);
	a3b2 <= SW(7) and SW(2);
	a2b3 <= SW(6) and SW(3);
	a3b3 <= SW(7) and SW(3);
	
	p(0) <= SW(4) and SW(0);
	
	
	--full adder sequencing from left to right, and top to bottom, from the diagram
	
	fa1: fa port map(a1b0, a0b1, ZEROcarryIN, p(1), carryOUT_row1(0));	
	fa2: fa port map(a2b0, a1b1, carryOUT_row1(0), fa_OF_a2b0_a1b1, carryOUT_row1(1));
	fa3: fa port map(a3b0, a2b1, carryOUT_row1(1), fa_OF_a3b0_a2b1, carryOUT_row1(2));
	fa4: fa port map(fa4_a, a3b1, carryOUT_row1(2), fa_OF_a3b1_0, carryOUT_row1(3));
	fa5: fa port map(fa_OF_a2b0_a1b1, a0b2, ZEROcarryIN, p(2), carryOUT_row2(0));	
	fa6: fa port map(fa_OF_a3b0_a2b1, a1b2, carryOUT_row2(0), fa_OF_a1b2_fa_OF_a3b0_a2b1, carryOUT_row2(1));
	fa7: fa port map(fa_OF_a3b1_0, a2b2, carryOUT_row2(1), fa_OF_a2b2_fa_OF_a3b1_0, carryOUT_row2(2));
	fa8: fa port map(carryOUT_row1(3), a3b2, carryOUT_row2(2), fa_OF_a3b2_c0fa_a3b1_0, carryOUT_row2(3));
	fa9: fa port map(fa_OF_a1b2_fa_OF_a3b0_a2b1, a0b3, ZEROcarryIN, p(3), carryOUT_row3(0));	
	fa10: fa port map(fa_OF_a2b2_fa_OF_a3b1_0, a1b3, carryOUT_row3(0), p(4), carryOUT_row3(1));	
	fa11: fa port map(fa_OF_a3b2_c0fa_a3b1_0, a2b3, carryOUT_row3(1), p(5), carryOUT_row3(2));	
	fa12: fa port map(carryOUT_row2(3), a3b3, carryOUT_row3(2), p(6), p(7));

	
	--displaying the numbers on the hex displays	
		
	digitA: hex7seg port map(SW(7 downto 4), HEX2);
	digitB: hex7seg port map(SW(3 downto 0), HEX0);
	digitP_3downto0_hexadecimal: hex7seg port map(p(3 downto 0), HEX4);
	digitP_7downto4_hexadecimal: hex7seg port map(p(7 downto 4), HEX5);
	
   
END Structure;






library ieee;
USE ieee.std_logic_1164.all;


ENTITY fa IS									--Full Adder Module
   PORT ( a, b, ci : IN  STD_LOGIC;
          s, co    : OUT STD_LOGIC);
END fa;



ARCHITECTURE Structure OF fa IS
   
	SIGNAL a_xor_b : STD_LOGIC;

BEGIN

   a_xor_b <= a XOR b;
   s <= a_xor_b XOR ci;
   co <= (NOT(a_xor_b) AND b) OR (a_xor_b AND ci);
	
END Structure;






LIBRARY ieee;								--hex display module
USE ieee.std_logic_1164.all;

ENTITY hex7seg IS
   PORT ( hex     : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
          display : OUT STD_LOGIC_VECTOR(0 TO 6));
END hex7seg;

ARCHITECTURE Behavior OF hex7seg IS
BEGIN
   --
   --       0  
   --      ---  
   --     |   |
   --    5|   |1
   --     | 6 |
   --      ---  
   --     |   |
   --    4|   |2
   --     |   |
   --      ---  
   --       3  
   --
   PROCESS (hex)
   BEGIN
      CASE hex IS
         WHEN "0000" => display <= "0000001";
         WHEN "0001" => display <= "1001111";
         WHEN "0010" => display <= "0010010";
         WHEN "0011" => display <= "0000110";
         WHEN "0100" => display <= "1001100";
         WHEN "0101" => display <= "0100100";
         WHEN "0110" => display <= "0100000";
         WHEN "0111" => display <= "0001111";
         WHEN "1000" => display <= "0000000";
         WHEN "1001" => display <= "0000100";
         WHEN "1010" => display <= "0001000";
         WHEN "1011" => display <= "1100000";
         WHEN "1100" => display <= "0110001";
         WHEN "1101" => display <= "1000010";
         WHEN "1110" => display <= "0110000";
         WHEN OTHERS => display <= "0111000";
      END CASE;
   END PROCESS;
END Behavior;
