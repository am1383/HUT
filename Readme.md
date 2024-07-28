---
# HUT: MIPS 16-Bit Single Cycle Processor

![Test](https://s8.uupload.ir/files/mipsd_vhn.jpg)

## Project Overview

**HUT** is a MIPS 16-bit Single Cycle Processor implementation project. This project is designed to simulate a basic MIPS processor that operates in a single clock cycle for each instruction. The project includes a complete system with instruction memory, a program counter, an ALU, and various control units to execute MIPS instructions.

## Features

- **Program Counter (PC)**: Keeps track of the address of the current instruction.
- **Instruction Memory**: Stores the instructions to be executed.
- **Arithmetic Logic Unit (ALU)**: Performs arithmetic and logic operations.
- **Control Unit**: Decodes instructions and generates control signals.
- **Sign and Zero Extension**: Handles immediate values for instructions.
- **Multiplexers**: Select between different data sources and control signals.

## Supported Instructions

The processor supports the following instructions:

1. **LDI (Load Immediate)**: Load an immediate value into a register.
2. **SBR (Subtract)**: Subtracts two values and stores the result.
3. **NEG (Negate)**: Negates a value in a register.
4. **OR (Logical OR)**: Performs a bitwise OR operation between two registers.
5. **RJMP (Relative Jump)**: Jumps to a relative address.
6. **LUI (Load Upper Immediate)**: Loads a 16-bit immediate value into the upper 16 bits of a register.
7. **STI (Store Immediate)**: Stores an immediate value to a specified address.

## Project Structure

- **PC.vhdl**: Implements the Program Counter.
- **Instruction_Memory.vhdl**: Provides instruction memory storage.
- **Controller.vhdl**: Manages control signals based on the opcode.
- **Sign_Extend.vhdl**: Extends the sign of immediate values.
- **Zero_Extend.vhdl**: Extends immediate values with zeroes.
- **ALU_Controller.vhdl**: Controls the ALU operations.
- **ALU.vhdl**: Performs arithmetic and logic operations.
- **Multiplexer.vhdl**: Selects between different inputs.

## How to Use

1. **Set Up the Environment**:

   - Ensure you have a VHDL simulator (e.g., ModelSim, Vivado) installed.
2. **Compile the VHDL Files**:

   - Compile all VHDL source files in your simulator.
3. **Simulate the Design**:

   - Run the simulation to test the processor with various instructions.
   - Ensure all signals and instructions are functioning correctly.
4. **Verify Functionality**:

   - Check if the Program Counter updates correctly with each instruction.
   - Verify that the ALU performs operations as expected.
   - Ensure that instructions are executed and controlled properly.

## Example Testbench

Here's an example of a basic testbench for the processor:

```vhdl
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Testbench is
end Testbench;

architecture Behavioral of Testbench is
    -- Signals for the processor
    signal CLK: std_logic := '0';
    signal RESET: std_logic := '1';
    signal address_to_load: std_logic_vector(15 downto 0);
    signal current_address: std_logic_vector(15 downto 0);
    -- Additional signals...

begin
    -- Instantiate the HUT processor
    UUT: entity work.HUT
        port map (
            CLK => CLK,
            RESET => RESET,
            address_to_load => address_to_load,
            current_address => current_address
        );

    -- Clock generation
    process
    begin
        CLK <= not CLK;
        wait for 10 ns;
    end process;

    -- Test stimulus
    process
    begin
        -- Initialize signals
        RESET <= '1';
        wait for 20 ns;
        RESET <= '0';

        -- Load instruction and test
        address_to_load <= x"0001";  -- Example address
        wait for 20 ns;
        -- Add more test cases...

        wait;
    end process;

end Behavioral;
```

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contact

For questions or feedback, please contact [am205379@gmail.com].
---
Feel free to adjust the details according to your specific implementation and project needs.
