library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Register_File is 
    port (
        CLK:          in  std_logic;
        reg_write:    in  std_logic;
        read_reg_1, 
        read_reg_2, 
        write_reg:    in  std_logic_vector(3 downto 0);
        write_data:   in  std_logic_vector(15 downto 0);
        read_data_1, 
        read_data_2:  out std_logic_vector(15 downto 0)
    );
end entity Register_File;

architecture Behavior of Register_File is

    type mem_array is array(0 to 15) of std_logic_vector(15 downto 0);

    signal reg_mem: mem_array := (
        "0000000000000000",
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

    read_data_1 <= reg_mem(to_integer(unsigned(read_reg_1)));
    read_data_2 <= reg_mem(to_integer(unsigned(read_reg_2)));

    process(CLK)
    begin
        if (rising_edge(CLK)) then
            if (reg_write = '1') then
                reg_mem(to_integer(unsigned(write_reg))) <= write_data;
            end if;
        end if;
    end process;
end Behavior;
