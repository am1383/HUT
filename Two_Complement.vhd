library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Two_Complement is
    Port ( 
        InputTwo  : in  std_logic_vector (15 downto 0);
        OutputTwo : out std_logic_vector (15 downto 0)
    );
end Two_Complement;

architecture Behavioral of Two_Complement is
begin
    process(InputTwo)
        variable temp: std_logic_vector (15 downto 0);
    begin
        temp := NOT InputTwo;
        OutputTwo <= std_logic_vector(unsigned(temp) + 1);
    end process;
end Behavioral;