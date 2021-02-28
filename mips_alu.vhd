library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity mips_alu is
	generic (
		WIDTH : positive := 32
	);

	port(
		input1 : in std_logic_vector(WIDTH-1 downto 0);
		input2 : in std_logic_vector(WIDTH-1 downto 0);
		ir: in std_logic_vector( 4 downto 0); -- this is the shift amount
		sel : in std_logic_vector(4 downto 0); --15 different functions decoded by alu controller
		result : out std_logic_vector (WIDTH-1 downto 0); --lower 32 bits
		result_high : out std_logic_vector (WIDTH-1 downto 0); --upper 32 bits
		branch_taken : out std_logic
	);

end mips_alu;

architecture ALU of mips_alu is

constant ADDU : std_logic_vector (4 downto 0) := "00000";
constant SUBU : std_logic_vector (4 downto 0) := "00001";
constant MULT : std_logic_vector (4 downto 0) := "00010";
constant MULTU : std_logic_vector (4 downto 0) := "00011";
constant S_AND : std_logic_vector (4 downto 0) := "00100";
constant S_OR : std_logic_vector (4 downto 0) := "00101";
constant S_XOR : std_logic_vector (4 downto 0) := "00110";
constant S_SRL : std_logic_vector (4 downto 0) := "00111";
constant S_SLL : std_logic_vector (4 downto 0) := "01000";
constant S_SRA : std_logic_vector (4 downto 0) := "01001";
constant SLT : std_logic_vector (4 downto 0) := "01010";
constant SLTU : std_logic_vector (4 downto 0) := "01011";
--constant MFHI : std_logic_vector (3 downto 0) := "1100";
--constant MFLO : std_logic_vector (3 downto 0) := "1101";
--constant JMP : std_logic_vector (3 downto 0) := "1110";
constant BEQ : std_logic_vector (4 downto 0) := "01111"; --branch equal
constant BNEQ : std_logic_vector (4 downto 0) := "10000"; --branch not equal
constant BLTEQZ : std_logic_vector (4 downto 0) := "10001"; --branch less or equal to 0
constant BGTZ : std_logic_vector (4 downto 0) := "10010";--branch greater than 0
constant BLTZ : std_logic_vector (4 downto 0) := "10011";--branch less than zero
constant BGTEQZ : std_logic_vector (4 downto 0) := "10100";--branch greater or equal to 0


-- ADD, SUB, MUL, ANDD, ORR, XOR, NOR , NOT1, S1L1, S1R2, SWAP2,REV2,EVENODD,COM2,ZERO1,ZERO2

begin -- ALU

	process(input1, input2, sel, ir)
		variable temp : unsigned(width-1 downto 0) := (others => '0'); --32 bits
		variable temp_mul : unsigned(2*width-1 downto 0) := (others => '0'); --64 bits




		begin
		--logical moves in zeros
		--arithmetic moves in signs

		--if not defined set values to zero

		result_high <= (others => '0');
		result <= (others => '0');
		temp := (others => '0');
		branch_taken <= '0';
		temp_mul := (others => '0');

		case sel is
			when ADDU =>

				temp:= unsigned(input1) + unsigned(input2);

				branch_taken <= '0';


				when SUBU =>

				temp:= unsigned(input1) - unsigned(input2);


				when MULT =>

				temp_mul:= unsigned(signed(input1) * signed(input2));
				temp := temp_mul(WIDTH-1 downto 0);
				result_high <= std_logic_vector(temp_mul(2*WIDTH-1 downto WIDTH));
				branch_taken <= '0';

				when MULTU =>

				temp_mul:= unsigned(input1) * unsigned(input2);
				temp := temp_mul(WIDTH-1 downto 0);
				result_high <= std_logic_vector(temp_mul(2*WIDTH-1 downto WIDTH));

				branch_taken <= '0';

				when S_AND =>
				temp := unsigned(input1 AND input2);

				branch_taken <= '0';

				when S_OR =>
				temp := unsigned(input1 OR input2);

				branch_taken <= '0';

				when S_XOR =>
				temp := unsigned(input1 XOR input2);

				branch_taken <= '0';


				when S_SRL =>

				branch_taken <= '0';

			temp := shift_right(unsigned(input2),to_integer(unsigned(ir)));

				when S_SLL =>

				branch_taken <= '0';
			temp := shift_left(unsigned(input2),to_integer(unsigned(ir)));

				when S_SRA =>

				branch_taken <= '0';
			 temp := unsigned(shift_right(signed(input2),to_integer(unsigned(IR))));

				result_high <= (others => '0');

				when SLT =>

						branch_taken <= '0';
				  if(signed(input1) < signed(input2)) then
		          temp := to_unsigned(1, WIDTH);


						end if;

				when SLTU =>
						branch_taken <= '0';
				  if(unsigned(input1) < unsigned(input2)) then
	          temp := to_unsigned(1, WIDTH);
						end if;

			when BEQ =>
			        if(input1 = input2) then
						branch_taken <= '1';
						else
						branch_taken <= '0';
						end if;

			when BNEQ =>
						if(input1 = input2) then
						branch_taken <= '0';
						else
						branch_taken <= '1';
						end if;

			when BLTEQZ =>
					 if(signed(input1) <= 0) then
					 branch_taken <= '1';
					 else
					branch_taken <= '0';
				 end if;


			when BGTZ =>
			      if(signed(input1) > 0) then
					branch_taken <= '1';
					else
					branch_taken <= '0';
					end if;

			when BLTZ =>
			  if(signed(input1) < 0) then
					branch_taken <= '1';
					else
					branch_taken <= '0';
					end if;

			when BGTEQZ =>
			  if(signed(input1) >= 0) then
					branch_taken <= '1';
					else
					branch_taken <= '0';
					end if;

			--	when MFHI =>

			--	when MFLO =>

		   -- when JMP =>


			when others => temp := to_unsigned(0, WIDTH);
			end case;

			result <= std_logic_vector(temp);

		end process;


	end ALU;
