

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity  mips_processor_tb is
end  mips_processor_tb;

architecture final of mips_processor_tb is

      signal    port_rst : std_logic := '0';
      signal    rst : std_logic := '0';
      signal    clk : std_logic := '0';
      signal    inport  : std_logic_vector(31 downto 0);
      signal    inport0_en  : std_logic;
      signal    inport1_en  : std_logic;
      signal    outport		: std_logic_vector(31 downto 0) := (others => '0');
begin

MIP_FINAL: entity work.mips_processor
port map(
    clk   => clk,
    rst    => rst,
    port_rst => port_rst,

      inport => inport,
      inport0_en  => inport0_en,
      inport1_en  => inport1_en,
      outport		=> outport
);


clk <= not clk after 5 ns;


process
begin

    rst <= '1';
    inport <= X"00000006";
    port_rst <= '0';
    inport0_en  <= '1';
    inport1_en  <= '0';
    wait for 15 ns;



      port_rst <= '0';
      rst <= '0';

            port_rst <= '0';

            inport <= X"00000006";
            inport0_en  <= '0';
            inport1_en  <= '1';
wait for 15 ns;



rst <= '1';


  wait for 10 ns;




  rst <= '0';

  wait for 10000 ns;



  rst <= '0';
        inport <= X"00000009";
        inport0_en  <= '0';
        inport1_en  <= '1';

  wait for 10000 ns;



  rst <= '0';
        inport <= X"00000055";
        inport0_en  <= '0';
        inport1_en  <= '1';

  wait for 10000 ns;



  rst <= '0';
        inport <= X"00000068";
        inport0_en  <= '0';
        inport1_en  <= '1';
  wait for 10000 ns;



  rst <= '0';
        inport <= X"00000002";
        inport0_en  <= '0';
        inport1_en  <= '1';

  wait for 10000 ns;



  rst <= '0';
        inport <= X"00000022";
        inport0_en  <= '0';
        inport1_en  <= '1';

wait for 10000 ns;
    inport1_en  <= '0';

wait;
end process;

end final;
