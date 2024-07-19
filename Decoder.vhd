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
    signal internal_output: std_logic_vector(15 downto 0);
begin
    process(input)
    begin
        internal_output <= (others => '0');
        internal_output(to_integer(unsigned(input))) <= '1';
    end process;

    -- Assign internal signals to outputs
    output  <= internal_output;
    subset0 <= internal_output(3 downto 0);
    subset1 <= internal_output(7 downto 4);
    subset2 <= internal_output(11 downto 8);
    subset3 <= internal_output(15 downto 12);
    
end Behavioral;
