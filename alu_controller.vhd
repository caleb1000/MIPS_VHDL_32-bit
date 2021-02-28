
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity alu_controller is
  generic (
    width  :     positive := 32);
  port (

ALUOp : in std_logic_vector (3 downto 0); --input of cpu_controller
IR : in std_logic_vector(5 downto 0); --function

HI_EN : out std_logic;
LO_EN : out std_logic;
ALU_LO_HI : out std_logic_vector(1 downto 0);
OPSelect : out std_logic_vector( 4 downto 0)); -- selects alu funciton

end alu_controller;


architecture BHV of alu_controller is


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


begin

process(ALUOp, IR)
variable ALU_MUX_TEMP_SEL : std_logic_vector(1 downto 0);
begin

--set init values for outputs
OPSelect <= "00000"; --ADD
HI_EN <='0';
LO_EN <='0';
ALU_MUX_TEMP_SEL := "00"; --holds temp for the alu select value

case ALUOp is

when "0000" => -- R_type instructions
    if(IR = "100001") then
        OPSelect <= ADDU;

  elsif(IR = "100011") then
        OPSelect <= SUBU;

  elsif(IR = "011000") then
        OPSelect <= MULT;
        HI_EN <= '1';
        LO_EN <= '1'; --might be the issue here

  elsif(IR = "011001") then
        OPSelect <= MULTU;
        HI_EN <= '1';
        LO_EN <= '1';

  elsif(IR = "100100") then
        OPSelect <= S_AND;

  elsif(IR = "100101") then
        OPSelect <= S_OR;

  elsif(IR = "100110") then
      OPSelect <= S_XOR;

  elsif(IR = "000010") then
      OPSelect <= S_SRL;

  elsif(IR = "000000") then
     OPSelect <= S_SLL;

  elsif(IR = "000011") then
     OPSelect <= S_SRA;

  elsif(IR = "101010") then
     OPSelect <= SLT;

  elsif(IR = "101011") then
    OPSelect <= SLTU;

  elsif(IR = "010000") then
          ALU_MUX_TEMP_SEL := "10"; -- move from high reg

  elsif(IR = "010010") then
          ALU_MUX_TEMP_SEL := "01"; -- move from low reg

  elsif(IR = "001000") then
--jumpR
   OPSelect <= ADDU;


end if; --for R R_type


when "1001" => --ADDI
    OPSelect <= ADDU;

when "0010" => --SUBI
    OPSelect <= SUBU;

when "1100" => -- ANDI
   OPSelect <= S_AND;

when "1101" => --ORI
    OPSelect <= S_OR;

when "0110" => --XORI
    OPSelect <= S_XOR;

when "1010" => --SLT
    OPSelect <= SLT;

when "1011" =>
    OPSelect <= SLTU;

when "0011" =>
    OPSelect <= BNEQ;

when "0001" =>
    OPSelect <= BEQ;

when "1111" =>
    --use for IFetch, and branches
    OPSelect <= ADDU;

when "1110" =>
    --use to keep enables low
    HI_EN <= '0';
    LO_EN <= '0';
    OPSelect <= MULTU;

--added below

when "0100" =>
    OPSelect <= BLTEQZ;

when "0101" =>
    OPSelect <= BGTZ;

when "0111" =>
    OPSelect <= BLTZ;

when "1000" =>
    OPSelect <= BGTEQZ;


--added above

when others => null;


end case;

ALU_LO_HI <= ALU_MUX_TEMP_SEL;
end process;


--add functionality later
end BHV;
