library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decoder7seg is

                port (
                      input : in std_logic_vector(3 downto 0);
                      output : out std_logic_vector(6 downto 0));
                end decoder7seg;

                architecture DECODER of decoder7seg is
                signal temp : std_logic_vector(6 downto 0);

                begin  -- DECODER

                process(input)



                    begin --begin the process
                    --temp will hold the value for the output
                    if (input = "0000") then
                        temp <= "0000001";

                    elsif (input = "0001") then
                        temp <= "1001111";

                    elsif (input = "0010") then
                        temp <= "0010010";

                    elsif (input = "0011") then
                        temp <= "0000110";

                    elsif (input = "0100") then
                        temp <= "1001100";

                    elsif (input = "0101") then
                        temp <= "0100100";

                    elsif (input = "0110") then
                        temp <= "0100000";

                    elsif (input = "0111") then
                        temp <= "0001111";

                    elsif (input = "1000") then
                        temp <= "0000000";

                    elsif (input = "1001") then
                        temp <= "0001100";

                    elsif (input = "1010") then
                        temp <= "0001000";

                    elsif (input = "1011") then
                        temp <= "1100000";

                    elsif (input = "1100") then
                        temp <= "0110001";

                    elsif (input = "1101") then
                        temp <= "1000010";

                    elsif (input = "1110") then
                        temp <= "0110000";

                    else 
                        temp <= "0111000";

                    end if;

                 

                    end process;
		    output <= temp;
                    --send the temp to output
                  end DECODER;

