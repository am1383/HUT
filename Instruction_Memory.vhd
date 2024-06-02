library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.textio.all;

entity Instruction_Memory is
    port (
        read_address:      in  std_logic_vector(15 downto 0);
        instruction:       out std_logic_vector(15 downto 0);
        last_instr_address: out std_logic_vector(15 downto 0)
    );
end Instruction_Memory;

architecture Behavioral of Instruction_Memory is

    type mem_array is array(0 to 15) of std_logic_vector(15 downto 0);

    signal data_mem: mem_array := (
        "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", 
        "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", 
        "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", 
        "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000"
    );

begin

    process
        file file_pointer: text;
        variable line_content: line;
        variable line_str: string(1 to 16);
        variable instr_content: std_logic_vector(15 downto 0);
        variable i: integer := 0;
        variable j: integer;
    begin
        file_open(file_pointer, "MIPS.txt", read_mode);

        while not endfile(file_pointer) loop
            readline(file_pointer, line_content);
            line_str := line_content.all;  -- Convert line to string
            for j in 1 to 16 loop
                if line_str(j) = '0' then
                    instr_content(16-j) := '0';
                else
                    instr_content(16-j) := '1';
                end if;
            end loop;
            data_mem(i) <= instr_content;
            i := i + 1;
        end loop;

        file_close(file_pointer);

        if (i > 0) then
            last_instr_address <= std_logic_vector(to_unsigned((i-1)*2, last_instr_address'length));
        else
            last_instr_address <= (others => '0');
        end if;

        wait; 
    end process;

    instruction <= data_mem(to_integer(unsigned(read_address(15 downto 1))));

end Behavioral;
