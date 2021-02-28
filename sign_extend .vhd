
library ieee;
use ieee.std_logic_1164.all;

entity sign_extend is
  generic (
    width  :     positive := 16);
  port (


    input  : in  std_logic_vector(width-1 downto 0);
    IsSigned  : in  std_logic;
    output : out std_logic_vector(2*width-1 downto 0));
end sign_extend;


architecture BHV of sign_extend is

signal temp : std_logic_vector(2*width-1 downto 0);

begin
    process(input,IsSigned)
          begin

if(IsSigned = '1') then
          if(input(width-1) = '1' ) then
          temp(width-1 downto 0) <=  input;
          temp(2*width-1 downto width) <= (others => '1');
          else
          temp(width-1 downto 0) <=  input;
          temp(2*width-1 downto width) <= (others => '0');
          end if;

else
    temp(width-1 downto 0) <=  input;
    temp(2*width-1 downto width) <= (others => '0');
end if;
    end process;
    output <= temp;
end BHV;
