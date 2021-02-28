library ieee;
use ieee.std_logic_1164.all;

entity mux4_1 is
  generic (
    width  :     positive := 32);
  port (
    in1    : in  std_logic_vector(width-1 downto 0);
    in2    : in  std_logic_vector(width-1  downto 0);
    in3    : in  std_logic_vector(width-1  downto 0);
    in4    : in  std_logic_vector(width-1  downto 0);
    sel    : in  std_logic_vector (1 downto 0);
    output : out std_logic_vector(width-1  downto 0));
end mux4_1;

architecture BHV of mux4_1 is
begin
  with sel select
    output <=
    in1 when "00",
    in2 when "01",
    in3 when "10",
    in4 when others;
end BHV;
