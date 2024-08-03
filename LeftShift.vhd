library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity LeftShift is
    port(
        inputL  : in std_logic_vector (3 downto 0);
        outputL : out std_logic_vector (15 downto 0)
    );
end LeftShift;

architecture Behavior of LeftShift is
    constant a : std_logic_vector(15 downto 0) := x"0001";
begin
    process(inputL)
        variable a_unsigned     : unsigned(15 downto 0);
        variable shift_amount   : unsigned(3 downto 0);
        variable shifted_result : unsigned(15 downto 0);
    begin
        a_unsigned     := unsigned(a);
        shift_amount   := unsigned(inputL);
        shifted_result := a_unsigned sll to_integer(shift_amount);
        outputL        <= std_logic_vector(shifted_result);
    end process;
end Behavior;
