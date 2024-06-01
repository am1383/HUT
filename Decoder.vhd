library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Decoder is
    Port ( 
        Input  : in  std_logic_vector(3 downto 0);
        Output : out std_logic_vector(15 downto 0)
    );
end Decoder;

architecture Behavioral of Decoder is
begin
    process(Input)
    begin

            Output <= (others => '0'); -- Initialize all outputs to '0'
            Output(to_integer(unsigned(Input))) <= '1'; -- Set the corresponding output bit
    end process;
end Behavioral;
