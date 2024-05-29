library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;

entity Decoder is
    Port ( 
        input  : in  std_logic_vector(3 downto 0);
        enable : in  std_logic;
        output : out std_logic_vector(15 downto 0)
    );
end Decoder;

architecture Behavioral of Decoder is
begin
    process(input, enable)
    begin
        if (enable = '1') then
            output <= (others => '0'); -- Initialize all outputs to '0'
            output(to_integer(unsigned(input))) <= '1'; -- Set the corresponding output bit
        else
            output <= (others => '0'); -- Disable the output when enable is '0'
        end if;
    end process;
end Behavioral;
