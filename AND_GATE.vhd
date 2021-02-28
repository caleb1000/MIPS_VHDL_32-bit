
library IEEE;
use IEEE.std_logic_1164.all;



entity AND_GATE is

    port(IN1 : in std_logic;      -- AND gate input
         IN2 : in std_logic;      -- AND gate input
         OUT_AND : out std_logic);    -- AND gate output

end AND_GATE;

-- Architecture definition

architecture A1 of AND_GATE is

 begin

    OUT_AND <= IN1 AND IN2;

end A1;
