library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Decoder is
    port (
        input:    in  std_logic_vector(3 downto 0);
        output:   out std_logic_vector(15 downto 0);
        subset0:  out std_logic_vector(3 downto 0);
        subset1:  out std_logic_vector(3 downto 0);
        subset2:  out std_logic_vector(3 downto 0);
        subset3:  out std_logic_vector(3 downto 0)
    );
end Decoder;

architecture Behavioral of Decoder is
begin
    process(input)
    begin
            output <= (others => '0');
            output(to_integer(unsigned(input))) <= '1';
            
        -- Assign subsets
        subset0 <= output(3 downto 0);
        subset1 <= output(7 downto 4);
        subset2 <= output(11 downto 8);
        subset3 <= output(15 downto 12);
    end process;
end Behavioral;
