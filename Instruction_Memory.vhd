library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use STD.textio.all; -- Reading File Library

entity Instruction_Memory is
	port (
		read_address: in std_logic_vector (15 downto 0);
		instruction, last_instr_address: out std_logic_vector (15 downto 0)
	);
end Instruction_Memory;

architecture behavior of Instruction_Memory is	  

    -- 128 byte instruction memory (32 rows * 4 bytes/row)
    type mem_array is array(0 to 15) of std_logic_vector (15 downto 0);
    signal data_mem: mem_array := (
        "0000000000000000", -- Initialize Data
        "0000000000000000", -- &1
        "0000000000000000",
        "0000000000000000",
        "0000000000000000",
        "0000000000000000",
        "0000000000000000",
        "0000000000000000",
        "0000000000000000",
        "0000000000000000", 
        "0000000000000000", -- &10 
        "0000000000000000", 
        "0000000000000000",
        "0000000000000000",
        "0000000000000000",
        "0000000000000000",
    );

    begin

    -- The process for reading the instructions into memory
    process 
        file file_pointer     : text;
        variable line_content : string(1 to 16);
        variable line_num     : line;
        variable i:  integer  := 0;
        variable j : integer  := 0;
        variable char : character :='0'; 
    
        begin
        -- Open instructions.txt and only read from it
        file_open(file_pointer, "MIPS.txt", READ_MODE);
        -- Read until the end of the file is reached  
        while not endfile(file_pointer) loop
            readline(file_pointer,line_num); -- Read a line from the file
            READ(line_num,line_content); -- Turn the string into a line (looks wierd right? Thanks Obama)
            -- Convert each character in the string to a bit and save into memory
            for j in 1 to 16 loop        
                char := line_content(j);
                if(char = '0') then
                    data_mem(i)(16-j) <= '0';
                else
                    data_mem(i)(16-j) <= '1';
                end if; 
            end loop;
            i := i + 1;
        end loop;
        if (i > 0) then
            last_instr_address <= std_logic_vector(to_unsigned((i-1)*4, last_instr_address'length));
        else
            last_instr_address <= "0000000000000000";
        end if;
        file_close(file_pointer); -- Close the file 
        wait; 
    end process;

    -- Since the registers are in multiples of 4 bytes, we can ignore the last two bits
    instruction <= data_mem(to_integer(unsigned(read_address(15 downto 2))));

end behavior;