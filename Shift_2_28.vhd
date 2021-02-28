
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity Shift_2_28 is

  port (
    input    : in  std_logic_vector(25 downto 0);
    output : out std_logic_vector(27 downto 0));
end Shift_2_28;

architecture BHV of Shift_2_28 is

begin

output(27 downto 0) <= std_logic_vector(shift_left(resize(unsigned(input), 28),2));

end BHV;
