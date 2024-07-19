library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Data_Memory is
    port (
        address, write_data:    in std_logic_vector(15 downto 0);
        MemWrite, MemRead, CLK: in std_logic;
        read_data:              out std_logic_vector(15 downto 0)
    );
end Data_Memory;

architecture Behavioral of Data_Memory is

    type Memory_Array is array(0 to 15) of std_logic_vector(15 downto 0);

    signal data_mem: Memory_Array := (
        X"1234", X"5678", X"9ABC", X"DEF0", X"1357", X"2468", X"369B", X"ACE1",
        X"FEDC", X"BA98", X"7654", X"3210", X"0FED", X"CBA9", X"8765", X"4321"
    );

begin

    process(address, MemRead)
    begin
        if (MemRead = '1') then
            read_data <= data_mem(to_integer(unsigned(address(3 downto 0))));
        else
            read_data <= (others => '0');
        end if;
    end process;

    process(CLK)
    begin
        if (rising_edge(CLK)) then
            if (MemWrite = '1') then
                data_mem(to_integer(unsigned(address(3 downto 0)))) <= write_data;
            end if;
        end if;
    end process;

end Behavioral;
