library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity Data_Memory is
	port (
		address, write_data:   in  std_logic_vector (15 downto 0);
		WD-D, MemRead, CLK:    in  std_logic;
		read_data:             out std_logic_vector (15 downto 0)
	);
end Data_Memory;

architecture behavioral of Data_Memory is	  

type Memory_Array is array(0 to 15) of std_logic_vector (15 downto 0);

signal data_mem: Memory_Array := (
    X"00000000", -- initialize data Data_Memory
    X"00000000", -- &1
    X"00000000", -- &2
    X"00000000", -- &3
    X"00000000", -- &4
    X"00000000", -- &5
    X"00000000", -- &6
    X"00000000", -- &7
    X"00000000", -- &8
    X"00000000", -- &9
    X"00000000", -- &10 
    X"00000000", -- &11
    X"00000000", -- &12
    X"00000000", -- &13
    X"00000000", -- &14
    X"00000000", -- &15
    );

begin

read_data <= data_mem(conv_integer(address(6 downto 2))) when MemRead = '1' else X"00000000";

mem_process: process(address, write_data, CLK)
begin
	if (CLK = '0' and CLK'event) then
		if (MemWrite = '1') then
			data_mem(conv_integer(address(6 downto 2))) <= write_data;
		end if;
	end if;
end process mem_process;

end behavioral;