library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Instruction_Memory is
    port (
        read_address:       in  std_logic_vector(15 downto 0);
        instruction:        out std_logic_vector(15 downto 0);
        last_instr_address: out std_logic_vector(15 downto 0)
    );
end Instruction_Memory;

architecture Behavioral of Instruction_Memory is

    type mem_array is array(0 to 15) of std_logic_vector(15 downto 0);

    signal data_mem: mem_array := (
        "0100001000100000", 
        "0000000000000001",
        "0000000000000010",
        "0000000000000011", 
        "0000000000000100", 
        "0000000000000101", 
        "0000000000000110", 
        "0000000000000111", 
        "0000000000001000", 
        "0000000000001001", 
        "0000000000001010", 
        "0000000000001011",
        "0000000000001100", 
        "0000000000001101", 
        "0000000000001110",
        "0000000000001111"  
    );

begin

     last_instr_address <= std_logic_vector(to_unsigned((data_mem'length - 1) * 2, last_instr_address'length));
     instruction <= data_mem(to_integer(unsigned(read_address(15 downto 1))));

end Behavioral;