

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity cpu_controller is

  port (

        --alu_sel is handled in alu controller

        clk : in std_logic;
        rst : in std_logic;
        OPCODE : in  std_logic_vector(5 downto 0);
        PCWriteCond : out std_logic;
        PCWrite : out std_logic;
        IorD : out std_logic;
        MemRead: out std_logic;
        MemWrite : out std_logic;
        MemToReg : out std_logic;
        IRWrite : out std_logic;
        JumpAndLink : out std_logic;
        IsSigned : out std_logic;
        PCSource : out std_logic_vector(1 downto 0);
        ALUSrcB : out std_logic_vector(1 downto 0);
        ALUOp : out std_logic_vector(3 downto 0); --to alu
        ALUSrcA : out std_logic;
        RegWrite : out std_logic;

        BTEST : in std_logic;

        ADDRTEST : in std_logic_vector(15 downto 0); --caleb




        RegDst : out std_logic
      );

end cpu_controller;

architecture BHV of cpu_controller is

--change to a 2 process version
type STATE_TYPE is (Start,IFetch2, IFetch,ID, LD_ST, LD, LD_2, LD_3,  ST, ST_2, ADDI, SUBI, ANDI, ORI, XORI, SLTI, SLTUI, I_WB, R_EX, R_WB, HALT, J, J2,BEQ_2, BEQ, BNEQ, BNEQ_2, BZ, BZ_2);
--need to add branch and Jump

signal state, next_state : STATE_TYPE;

begin

process(clk, rst)
begin
    if (rst = '1') then
      state <= Start;
    elsif (rising_edge(clk)) then
        state <= next_state;
    end if;
end process;
-- IFetch, ID, LD_ST, LD, LD_2, LD_3, ST, ST_2, ADDI, SUBI, ANDI, ORI, XORI, SLTI, SLTUI, I_WB, R_EX, R_WB, HALT
process(state, OPCODE, ADDRTEST, BTEST)
begin

next_state <= state;
	PCWrite  	   <= '0';
  PCWriteCond 	<= '0';
  IorD  			<= '0';
  MemRead  		<= '0';
  MemWrite  		<= '0';
  MemToReg  		<= '0';
  IRWrite  		<= '0';
  IsSigned  		<= '0';
  PCSource  		<= "00";
  ALUOp  	      <= "0000";
  ALUSrcA  		<= '0';
  ALUSrcB      	<= "00";
  RegWrite  		<= '0';
  RegDst  			<= '0';
  JumpAndLink   <= '0';

      case state is


          when Start =>

          next_state <= IFetch;

          when IFetch =>

                  ALUSrcA <= '0';
          				MemRead <= '1';
          				IRWrite <= '1';
                  ALUSrcA <= '0';
          				ALUSrcB <= "01"; --4
          				PCWrite <= '1';
                  ALUOp  	<= "1111"; --tell alu to add these together pc+4
          				next_state <= ID;



        when ID =>

        ALUSrcB <= "11";

				if(opcode = "111111") then
					next_state <= HALT;

				elsif(opcode = "100011" or opcode = "101011") then
          -- if load or store go to load store
					next_state <= LD_ST;

				elsif(opcode = "001001") then
					next_state <= ADDI;

				elsif(opcode = "010000") then
					next_state <= SUBI;

				elsif(opcode = "001100") then
					next_state <= ANDI;

				elsif(opcode = "001101") then
					next_state <= ORI;

				elsif(opcode = "001110") then
					next_state <= XORI;

				elsif(opcode = "001010") then
					next_state <= SLTI;

				elsif(opcode = "001011") then
					next_state <= SLTUI;

        	elsif(opcode = "000100") then
  					next_state <= BEQ;

      	elsif(opcode = "000101") then
          	next_state <= BNEQ;

        elsif((opcode = "000110") or (opcode = "000111") or (opcode = "000001")) then
              	next_state <= BZ;

				elsif(opcode = "000000") then
          -- if (ADDRTEST(5 downto 0) = "001000")
          --go to generic R type
					next_state <= R_EX;

        	elsif(opcode = "000010") then
            --go to generic J type
  					next_state <= J;

         	elsif(opcode = "000011") then
          --jump and JumpAndLink
              JumpAndLink <= '1';
              RegWrite <= '1';

                --go to generic J type
        					next_state <= J;

          else
          --removes latches
          next_state <= Start;

				end if;


when J =>

  PCSource <= "10";
  PCWrite <= '1';

next_state <= J2;

when J2 =>

  IorD <= '0';

next_state <= IFetch;

when LD_ST =>

      ALUSrcA <= '1';
      ALUSrcB <= "10";
      IsSigned <= '0';
      ALUOp  	 <= "1111";
      if(OPCODE = "100011") then

        next_state <= LD;
      else
        next_state <= ST;
      end if;

when ST =>

  MemWrite <= '1';

  IorD <= '1';

  next_state <= ST_2;


when ST_2 =>

next_state <= IFetch;

when LD =>
			MemRead <= '1';
      IorD <= '1'; --retrieve data from the address + offset
      if(ADDRTEST = X"FFFC") then
        next_state <= LD_3;
      elsif(ADDRTEST = X"FFF8") then
          next_state <= LD_3;
      else
      next_state <= LD_2;
      end if;

          when LD_2 =>
          MemRead <= '1';--changeeeeeed
          IorD <= '1'; --changed
          MemToReg <= '1';--turned from a 1
          RegWrite <= '0';
          RegDst <= '0';
          next_state <= LD_3;

          when LD_3 =>
            MemToReg <= '1';--turned from a 1
            RegWrite <= '1';
            RegDst <= '0';
            next_state <= IFetch;

when HALT =>
    next_state <= HALT;


when BZ =>
--the first input needs to be
ALUSrcA <= '0';
ALUSrcB <= "11";
ALUOp <= "1111"; --add command, next cycle the add will be read to read

next_state <= BZ_2;

when BZ_2 =>

ALUSrcA <= '1';
ALUSrcB <= "00";
PCSource <= "01";
PCWriteCond <= '1';

if (opcode = "000110") then
      -- BLTEQZ
      ALUOp <= "0100";
elsif (opcode = "000111") then
      --BGTZ
      ALUOp <= "0101";
else

    if(BTEST = '1') then
        --branch greater than equal to zero
          ALUOp <= "1000";
      else
        --branch less than zero
            ALUOp <= "0111";
              end if;

end if;

next_state <= J2;

when BNEQ =>

ALUSrcA <= '0';
ALUSrcB <= "11";
ALUOp <= "1111"; --add command, next cycle the add will be read to read

next_state <= BNEQ_2;

when BNEQ_2 =>
ALUSrcA <= '1';
ALUSrcB <= "00";
ALUOp <= "0011";-- bneq
PCSource <= "01";
PCWriteCond <= '1';

next_state <= J2;






when BEQ =>

ALUSrcA <= '0';
ALUSrcB <= "11";
ALUOp <= "1111"; --add command, next cycle the add will be read to read

next_state <= BEQ_2;

when BEQ_2 =>
ALUSrcA <= '1';
ALUSrcB <= "00";
ALUOp <= "0001";-- beq
PCSource <= "01";
PCWriteCond <= '1';

next_state <= J2;

when ADDI =>

  ALUSrcA <= '1';
  ALUSrcB <= "10";
  ALUOp <= "1001";

  next_state <= I_WB;

when SUBI =>

  ALUSrcA <= '1';
  ALUSrcB <= "10";
  ALUOp <= "0010";

  next_state <= I_WB;

when ANDI =>

  ALUSrcA <= '1';
  ALUSrcB <= "10";
  ALUOp <= "1100";

  next_state <= I_WB;

when ORI =>

  ALUSrcA <= '1';
  ALUSrcB <= "10";
  ALUOp <= "1101";

  next_state <= I_WB;

when XORI =>

  ALUSrcA <= '1';
  ALUSrcB <= "10";
  ALUOp <= "0110";

  next_state <= I_WB;

when SLTI =>
  IsSigned <= '1';
  ALUSrcA <= '1';
  ALUSrcB <= "10";
  ALUOp <= "1010";

  next_state <= I_WB;

	when SLTUI =>
    IsSigned <= '0';
    ALUSrcA <= '1';
    ALUSrcB <= "10";
    ALUOp <= "1011";

    next_state <= I_WB;

when R_EX =>

  ALUSrcA <= '1';
  ALUOp <= "0000";

  if (ADDRTEST(5 downto 0) = "001000") then
          --jmp R
          PCWrite <= '1';
          next_state <= J2;
      else
          next_state <= R_WB;
      end if;




when I_WB =>

    RegWrite <= '1';
    ALUOp <= "0000";
    next_state <= IFetch;

when R_WB =>

  if(ADDRTEST(5 downto 0 ) = "010010") then
    ALUOp <= "0000";

--mflo
  elsif (ADDRTEST(5 downto 0 ) = "010000") then
    ALUOp <= "0000";
--mfhi

else
  ALUOp <= "1110";
end if;




  RegDst <= '1';

  if(ADDRTEST(5 downto 0 ) = "011000") then
  RegWrite <= '0';
  --we are mult
  elsif( ADDRTEST(5 downto 0 ) = "011001") then
  --we are multU
  RegWrite <= '0';
  else
  RegWrite <= '1';
  --turn on enables
  end if;


  next_state <= IFetch;

when others => null;
end case;

end process;

end BHV;
