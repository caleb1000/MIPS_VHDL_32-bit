library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity datapath is
	generic (
		WIDTH : positive := 32);
	port (

		clk: in std_logic;
		rst: in std_logic;
		port_rst : in std_logic;

		inport		: in  std_logic_vector(WIDTH - 1 downto 0);
		inport0_en  	: in  std_logic;
		inport1_en  	: in  std_logic;
		outport		: out  std_logic_vector(WIDTH - 1 downto 0);


	  PC_en 	: in  std_logic;
		IorD        : in  std_logic;
		MemRead  	: in  std_logic;
		MemWrite  	: in  std_logic;
		MemToReg    : in  std_logic;
		IRWrite  	: in  std_logic;
		JumpAndLink : in std_logic;
		IsSigned : in std_logic;
		PCSource : in std_logic_vector(1 downto 0);
		ALUOp : in std_logic_vector(3 downto 0);
		RegWrite  	: in  std_logic;
		ALUSrcA  	: in  std_logic;
		ALUSrcB  	: in  std_logic_vector(1 downto 0);
		RegDst  : in std_logic;
		OPCODE  : out std_logic_vector(5 downto 0);

   ADDRTEST : out std_logic_vector(15 downto 0); --caleb
	 BTEST : out std_logic;

	Branch  : out std_logic







        );


end datapath;

architecture STR of datapath is

--add signals here


signal PC_out : std_logic_vector(31 downto 0);

signal PC_MUX_out : std_logic_vector(31 downto 0);
signal MEM_UNIT_out : std_logic_vector(31 downto 0);
signal IR_out : std_logic_vector(31 downto 0);
signal MDR_out : std_logic_vector(31 downto 0);
signal IR_MUX_out : std_logic_vector(4 downto 0);
signal MDR_MUX_out : std_logic_vector(31 downto 0);
signal ALU_MUX_out : std_logic_vector(31 downto 0);
signal REG_A_IN : std_logic_vector(31 downto 0);
signal REG_B_IN : std_logic_vector(31 downto 0);
signal REG_A_OUT : std_logic_vector(31 downto 0);
signal REG_B_OUT : std_logic_vector(31 downto 0);
signal PC_IN : std_logic_vector(31 downto 0);
signal SIGN_OUT : std_logic_vector(31 downto 0);
signal ZERO_EXTEND_out : std_logic_vector(31 downto 0);
signal SHIFT_1_OUT : std_logic_vector(31 downto 0);
signal SHIFT_2_OUT : std_logic_vector(27 downto 0);
signal REGB_MUX_OUT : std_logic_vector(31 downto 0);
signal REGA_MUX_OUT : std_logic_vector(31 downto 0);
signal OPSelect : std_logic_vector(4 downto 0);
signal ALU_OUT : std_logic_vector(31 downto 0);
signal ALU_OUT_HI : std_logic_vector(31 downto 0);
signal HI_en : std_logic;
signal LO_en : std_logic;
signal OUT_MUX_SEL : std_logic_vector(1 downto 0);

signal ALU_REG_OUT : std_logic_vector(31 downto 0);
signal ALU_REG_LO_OUT : std_logic_vector(31 downto 0);
signal CAT_OUT : std_logic_vector(31 downto 0);

signal ALU_REG_HI_OUT : std_logic_vector(31 downto 0);




begin


PC_COUNTER: entity work.reg
port map(
		clk => clk,
		rst => rst,
		load =>PC_en,
    input => PC_IN,
  output => PC_OUT
);

PC_MUX: entity work.mux2x1
generic map(width => 32)
port map(
in1 => PC_OUT,
in2 => ALU_REG_out,
sel => IorD,
output => PC_MUX_out
);

MEM_UNIT: entity work.memory_unit
port map(
clk => clk,
rst => rst,
port_rst => port_rst,
mem_read => MemRead,
mem_write => MemWrite,
addr => PC_MUX_out,
wr_data => REG_B_out,
rd_data => MEM_UNIT_out,
inport => ZERO_EXTEND_out,
inport0_enable => inport0_en,
inport1_enable => inport1_en,
outport => outport

);

PAD_SWITCHES: entity work.zero_extend
port map(
input => inport(9 downto 0),
output => ZERO_EXTEND_out
);

IR_REG: entity work.reg
port map(
		clk => clk,
		rst => rst,
		load =>IRWrite,
    input => MEM_UNIT_out,
  output => IR_out
);

MEM_DATA_REG: entity work.reg
port map(
		clk => clk,
		rst => rst,
		load =>'1',
    input => MEM_UNIT_out,
  	output => MDR_out
);

IR_MUX: entity work.mux2x1
generic map(width => 5)
port map(
in1 => IR_out(20 downto 16),
in2 => IR_out(15 downto 11),
sel => RegDst,
output => IR_MUX_out
);

MDR_MUX: entity work.mux2x1
generic map(width => 32)
port map(
in1 =>  ALU_MUX_out,
in2 => MDR_out,
sel => MemToReg,
output => MDR_MUX_out
);

REG_UNIT: entity work.reg_file
port map(
 clk => clk,
 rst  => rst,
 rd_addr0 => IR_out(25 downto 21),
 rd_addr1 => IR_out(20 downto 16),
 wr_addr => IR_MUX_out,
 RegWrite => RegWrite,
 JumpAndLink => JumpAndLink,
 wr_data => MDR_MUX_out,
 rd_data0 => REG_A_IN,
 rd_data1 => REG_B_IN
);

REG_A: entity work.reg
port map(
		clk => clk,
		rst => rst,
		load =>'1',
    input => REG_A_IN,
  output => REG_A_OUT
);


REG_B: entity work.reg
port map(
		clk => clk,
		rst => rst,
		load =>'1',
    input => REG_B_IN,
  output => REG_B_OUT
);

SIGN_G: entity work.sign_extend
port map(
input => IR_out(15 downto 0),
IsSigned => IsSigned,
output => SIGN_out
);

SIGN_SHIFT: entity work.Shift_2
port map (
input => SIGN_out,
output => SHIFT_1_OUT
);

REGB_MUX: entity work.mux4_1
generic map(width => 32)
port map(
in1 => REG_B_OUT,
in2 => "00000000000000000000000000000100",
in3 => SIGN_OUT,
in4 => SHIFT_1_OUT,
sel => ALUSrcB,
output => REGB_MUX_OUT
);


REGA_MUX: entity work.mux2x1
generic map(width => 32)
port map(
in1 => PC_OUT ,
in2 => REG_A_OUT,
sel => ALUSrcA,
output => REGA_MUX_OUT
);

ALU_UNIT: entity work.mips_alu
port map(

		input1 => REGA_MUX_OUT,
		input2 => REGB_MUX_OUT,
		ir => IR_out(10 downto 6),
		sel => OPSelect ,
		result => ALU_OUT,
		result_high => ALU_OUT_HI,
		branch_taken => Branch

);

ALU_CONT: entity work.alu_controller
port map(
IR => IR_out(5 downto 0),
OPSelect => OPSelect,
HI_EN => HI_en,
LO_EN => LO_en,
ALU_LO_HI => OUT_MUX_SEL,
ALUOp => ALUOp
);

ALU_OUT_REG: entity work.reg
port map(
		clk => clk,
		rst => rst,
		load =>'1',
    input => ALU_OUT,
  output => ALU_REG_OUT
);

ALU_OUT_HI_REG: entity work.reg
port map(
		clk => clk,
		rst => rst,
		load =>HI_en,
    input => ALU_OUT_HI,
  output => ALU_REG_HI_OUT
);

ALU_OUT_LO_REG: entity work.reg
port map(
		clk => clk,
		rst => rst,
		load =>LO_en,
    input => ALU_OUT,
  output => ALU_REG_LO_OUT
);


ALU_MUX: entity work.mux4_1
generic map(width => 32)
port map(
in1 => ALU_REG_OUT,
in2 => ALU_REG_LO_OUT,
in3 => ALU_REG_HI_OUT,
in4 => ALU_REG_HI_OUT,
sel => OUT_MUX_SEL,
output => ALU_MUX_out
);

TOP_SHIFT: entity work.Shift_2_28
port map (
input => IR_out(25 downto 0),
output => SHIFT_2_OUT
);

CAT: entity work.concat
port map(
input1 => SHIFT_2_OUT ,
input2 => PC_OUT(31 downto 28) ,
output => CAT_OUT
);


LAST_MUX: entity work.mux4_1

port map(
in1 => ALU_OUT,
in2 => ALU_REG_OUT,
in3 => CAT_OUT ,
in4 => CAT_OUT ,
sel => PCSource,
output => PC_IN
);

OPCODE <= IR_out(31 downto 26);
ADDRTEST <= IR_out(15 downto 0);
BTEST <= IR_out(16);
end STR;
