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

architecture behavioral of Data_Memory is

    type Memory_Array is array(0 to 15) of std_logic_vector(15 downto 0);

    signal data_mem: Memory_Array := (
        X"0000",
        X"0000",
        X"0000", 
        X"0100", 
        X"0000", 
        X"0000",
        X"0000", 
        X"0000", 
        X"0000", 
        X"0000", 
        X"0000",  
        X"0000", 
        X"0000", 
        X"0000", 
        X"0000", 
        X"0000"  
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

end behavioral;
