-- Greg Stitt
-- University of Florida

-- The following entity is the top-level entity for lab 2. No changes are
-- required, but you need to map the I/O to the appropriate pins on the
-- board.

-- I/O Explanation (assumes the switches are on side of the
--                  board that is closest to you)
-- switch(9) is the leftmost switch
-- button(1) is the top button
-- led5 is the leftmost 7-segment LED
-- ledx_dp is the decimal point on the 7-segment LED for LED x

library ieee;
use ieee.std_logic_1164.all;

entity top_level is
    port (
        clk : in std_logic;

        switch  : in  std_logic_vector(9 downto 0); --inport, top rst
        button  : in  std_logic_vector(1 downto 0); --inport enables
        led0    : out std_logic_vector(6 downto 0);

        led1    : out std_logic_vector(6 downto 0);

        led2    : out std_logic_vector(6 downto 0);

        led3    : out std_logic_vector(6 downto 0);

        led4    : out std_logic_vector(6 downto 0);

        led5    : out std_logic_vector(6 downto 0)

        );
end top_level;

architecture STR of top_level is

    component decoder7seg
        port (
            input  : in  std_logic_vector(3 downto 0);
            output : out std_logic_vector(6 downto 0));
    end component;

    component mips_processor

        port (
          clk    : in  std_logic;
          rst    : in  std_logic;
          port_rst : in std_logic;


            inport: in std_logic_vector(31 downto 0);
            inport0_en  : in std_logic;
            inport1_en  : in std_logic;
            outport		: out std_logic_vector(31 downto 0));
    end component;

    signal out_proc      : std_logic_vector(31 downto 0);
    signal temp      : std_logic_vector(31 downto 0);
    signal not_0      : std_logic; --for buttons
      signal not_1     : std_logic;

    constant C0 : std_logic_vector(3 downto 0) := "0000";

begin  -- STR

    -- map ALU output to rightmost 7-segment LED
    U_LED0 : decoder7seg port map (
        input  => out_proc(3 downto 0),
        output => led0);

    -- all other LEDs should display 0
    U_LED1 : decoder7seg port map (
        input  => out_proc(7 downto 4),
        output => led1);

    U_LED2 : decoder7seg port map (
        input  => out_proc(11 downto 8),
        output => led2);

    U_LED3 : decoder7seg port map (
        input  => out_proc(15 downto 12),
        output => led3);

    U_LED4 : decoder7seg port map (
        input  => out_proc(19 downto 16),
        output => led4);

    U_LED5 : decoder7seg port map (
        input  => out_proc(23 downto 20),
        output => led5);

temp <= "00000000000000000000000" & switch(8 downto 0);
not_0 <= not(button(0));
not_1 <= not(button(1));

    -- instantiate the ALU
    U_processor : entity work.mips_processor

        port map (

                  clk => clk,
                  rst => switch(9),
                  port_rst => '0',
                  inport => temp,
                  inport0_en => not_0,
                  inport1_en => not_1,
                  outport		=>out_proc);






end STR;
