library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity Two_Complement is
    Port ( 
        input  : in  std_logic_vector (15 downto 0);
        output : out std_logic_vector (15 downto 0)
    );
end Two_Complement;

architecture Behavioral of Two_Complement is
begin
    process(input)
        variable temp: std_logic_vector (15 downto 0);
    begin
        -- Invert the input bits
        temp := NOT input;
        -- Add 1 to the inverted bits
        output <= std_logic_vector(unsigned(temp) + 1);
    end process;
end Behavioral;