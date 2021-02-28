
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity mips_processor is


  port (
    clk    : in  std_logic;
    rst    : in  std_logic;
    port_rst : in std_logic;


      inport: in std_logic_vector(31 downto 0);
      inport0_en  : in std_logic;
      inport1_en  : in std_logic;
      outport		: out std_logic_vector(31 downto 0));

end mips_processor;


architecture BHV of mips_processor is
--add signals here
--pc enable is a mix of pcwrite and pcwritecond
--add and/or signals

signal AND_Branch_PC : std_logic;
signal OR_Branch_PC : std_logic;
--signal OR_IN1 : std_logic; --and_branch_pc
signal OR_IN2 : std_logic; --pcwrite
signal AND_IN1 : std_logic; --branch
signal AND_IN2 : std_logic; --pcwritecond
signal OPCODE_wire : std_logic_vector(5 downto 0);
signal IorD_wire : std_logic;
signal MemRead_wire : std_logic;
signal MemWrite_wire : std_logic;
signal MemToReg_wire : std_logic;
signal IRWrite_wire : std_logic;
signal JumpAndLink_wire : std_logic;
signal IsSigned_wire : std_logic;
signal PCSource_wire : std_logic_vector(1 downto 0);
signal ALUSrcB_wire : std_logic_vector(1 downto 0);
signal ALUOp_wire : std_logic_vector(3 downto 0);
signal ALUSrcA_wire : std_logic;
signal RegWrite_wire : std_logic;
signal RegDst_wire : std_logic;
signal BTEST_wire : std_logic;
signal ADDRTEST_wire : std_logic_vector(15 downto 0);
begin

cpu_con: entity work.cpu_controller
port map(
        clk => clk,
        rst => rst,
        OPCODE =>  OPCODE_wire,
        PCWriteCond => AND_IN2,
        PCWrite => OR_IN2,
        IorD => IorD_wire,
        MemRead => MemRead_wire,
        MemWrite => MemWrite_wire,
        MemToReg =>  MemToReg_wire,
        IRWrite => IRWrite_wire,
        JumpAndLink => JumpAndLink_wire,
        IsSigned => IsSigned_wire,
        PCSource => PCSource_wire,
        ALUSrcB => ALUSrcB_wire,
        ALUOp => ALUOp_wire,
        ALUSrcA => ALUSrcA_wire,
        RegWrite => RegWrite_wire,
        ADDRTEST => ADDRTEST_wire,
          BTEST => BTEST_wire,
        RegDst => RegDst_wire
);

data_path: entity work.datapath
port map(
	clk => clk,
  rst => rst,
  port_rst => port_rst,

  inport => inport,
  inport0_en => inport0_en,
  inport1_en => inport1_en,
  outport => outport,


  PC_en => OR_Branch_PC,
  IorD => IorD_wire,
  MemRead => MemRead_wire,
  MemWrite => MemWrite_wire,
  MemToReg =>  MemToReg_wire,
  IRWrite => IRWrite_wire,
  JumpAndLink => JumpAndLink_wire,
  IsSigned => IsSigned_wire,
  PCSource => PCSource_wire,
  ALUOp  => ALUOp_wire,
  RegWrite => RegWrite_wire,
  ALUSrcA  => ALUSrcA_wire,
  ALUSrcB  => ALUSrcB_wire,
  RegDst  => RegDst_wire,
  OPCODE => OPCODE_wire,
  ADDRTEST => ADDRTEST_wire,
  BTEST => BTEST_wire,
Branch  => AND_IN1
);


AND_G: entity work.AND_GATE
port map(
IN1 => AND_IN1,
IN2 => AND_IN2,
OUT_AND => AND_Branch_PC
);

OR_G: entity work.OR_GATE
port map(
IN1 => AND_Branch_PC,
IN2 => OR_IN2,
OUT_OR => OR_Branch_PC
);
end BHV;
