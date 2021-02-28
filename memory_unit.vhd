
library ieee;
use ieee.std_logic_1164.all;

entity memory_unit is
  generic (
    width  :     positive := 32);
  port (
    clk    : in  std_logic;
    rst    : in  std_logic;
    port_rst : in std_logic :=  '0';
    mem_read : in std_logic :=  '0'; --not needed
    mem_write : in std_logic :=  '0'; --wren
    addr  : in std_logic_vector(width-1 downto 0) := (others => '0');
    wr_data : in std_logic_vector(width-1 downto 0):= (others => '0');
    rd_data : out std_logic_vector(width-1 downto 0):= (others => '0'); --output of ram
    inport  : in  std_logic_vector(width-1 downto 0):= (others => '0'); --switch data
    inport0_enable : in std_logic :=  '0'; --will be buttons
    inport1_enable : in std_logic :=  '0';
    outport : out std_logic_vector(width-1 downto 0):= (others => '0')); --to I/O outputs

end memory_unit;


architecture BHV of memory_unit is
signal inport0_out :std_logic_vector(31 downto 0);
signal inport1_out :std_logic_vector(31 downto 0) ;
signal ram_out :std_logic_vector(31 downto 0) ;

signal outport_enable :std_logic;
signal mux_sel: std_logic_vector (1 downto 0);
signal wren : std_logic ;

begin

process(addr,mem_write,inport0_enable,inport1_enable)
--does this need to be clocked?
begin


outport_enable <= '0';
mux_sel <= "10";
wren <= '0';



if(addr = "00000000000000001111111111111100") then
  --fffc outport or inport 1

    if(mem_write = '1') then
        outport_enable <= '1';
        wren <= '0';
        --outport
    else
        --output the inport1
        mux_sel <= "01";
        wren <= '0';
      end if;

--if write to mem is true and we are at the outport address
--enable the outport and disable writing to ram_out


elsif ( addr = "00000000000000001111111111111000") then
    --fff8 inport0
          mux_sel <= "00";
          wren <= '0';
else

  mux_sel <= "10"; --select the ram output

    if(mem_write = '1') then
            wren <= '1';
      else
            wren <= '0';
      end if;

end if;

end process;

mux_4: entity work.mux4_1
port map(
    in1 => inport0_out,
    in2 => inport1_out,
    in3 => ram_out,
    in4 => ram_out,
  sel => mux_sel,
  output => rd_data
);



inport_0: entity work.reg
port map(
clk => clk ,
rst=> port_rst ,
load=> inport0_enable ,
input=> inport,
output=> inport0_out
);

inport_1: entity work.reg
port map(
clk => clk ,
rst=> port_rst ,
load=> inport1_enable ,
input=> inport,
output=> inport1_out
);


outport_1: entity work.reg
port map(
clk => clk ,
rst=>  rst ,
load=> outport_enable,
input=> wr_data,
output=> outport
);

	RAM_ENT : entity work.ram
		port map(
			clock => clk,
			q => ram_out,
			address => addr(9 downto 2),
			data => wr_data,
			wren => wren);





end BHV;
