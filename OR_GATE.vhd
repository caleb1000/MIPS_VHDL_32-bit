
library IEEE;
use IEEE.std_logic_1164.all;



entity OR_GATE is

    port(IN1 : in std_logic;      -- OR gate input
         IN2 : in std_logic;      -- OR gate input
         OUT_OR : out std_logic);    -- OR gate output

end OR_GATE;

-- Architecture definition

architecture O1 of OR_GATE is

 begin

    OUT_OR <= IN1 OR IN2;

end O1;
