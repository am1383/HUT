library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Instruction_Memory is
    port (
        read_address:       in  std_logic_vector(15 downto 0);
        instruction:        out std_logic_vector(15 downto 0)
    );
end Instruction_Memory;

architecture Behavioral of Instruction_Memory is

    type mem_array is array(0 to 15) of std_logic_vector(15 downto 0);

    signal data_mem: mem_array := (
        "0000000000000110", 
        "0010000000010101",
        "0100001011100110",
        "1000000000010001", 
        "1010000000010101", 
        "1100000000000110", 
        "0110000000010001", 
        "0000000000001000", 
        "0000000000001001", 
        "0000000000001010", 
        "0000000000001011",
        "0000000000001100", 
        "0000000000001101", 
        "0000000000001110",
        "0000000000001111",
        "0000000000000000"  
    );

begin

    instruction <= data_mem(to_integer(unsigned(read_address(15 downto 1))));

end Behavioral;