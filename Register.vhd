library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity registers is 
	port (
        CLK:                               in std_logic;
		reg_write:                         in std_logic;
		read_reg_1, read_reg_2, write_reg: in std_logic_vector(4 downto 0);
		write_data:                        in std_logic_vector(15 downto 0);
		read_data_1, read_data_2:          out std_logic_vector(15 downto 0)
	);
end registers;

architecture behavior of registers is

    type mem_array is array(0 to 15) of STD_LOGIC_VECTOR (15 downto 0);
    signal reg_mem: mem_array := (
        "00000000000000000000000000000000", -- $zero
        "00000000000000000000000000000000", -- &1
        "00000000000000000000000000000000", -- &2
        "00000000000000000000000000000000", -- &3
        "00000000000000000000000000000000", -- &4
        "00000000000000000000000000000000", -- &5
        "00000000000000000000000000000000", -- &6
        "00000000000000000000000000000000", -- &7
        "00000000000000000000000000000000", -- &8
        "00000000000000000000000000000000", -- &9
        "00000000000000000000000000000000", -- &10
        "00000000000000000000000000000000", 
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",  
    );

	begin

        read_data_1 <= reg_mem(to_integer(unsigned(read_reg_1)));
        read_data_2 <= reg_mem(to_integer(unsigned(read_reg_2)));

    process(CLK)
        begin
        if (CLK='0' and CLK'event and reg_write='1') then
            -- write to reg. mem. when the reg_write flag is set and on a falling cloCLK
            reg_mem(to_integer(unsigned(write_reg))) <= write_data;
        end if;
    end process;

end behavior;