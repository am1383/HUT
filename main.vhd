library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity main is
	port(
		CLK: in std_logic
	);
end main;

architecture behavior of main is

	signal instr_address: 		        std_logic_vector(15 downto 0); -- Address To Run
	signal next_address:  		        std_logic_vector(15 downto 0); -- Next Address For PC
	signal instruction:   	            std_logic_vector(15 downto 0); -- Current Addresss Instruction
	signal read_data_1, read_data_2, write_data, ZE_Immediate_Y, ZE_Immediate_Z, SE_Immediate, Shifted_Immediate, Shifted_Add, SevenShifted, SevenShifted2, alu_in_2, ALU_Result, last_instr_address, Add1_Result, Add2_Result, Add3_Result, PC_Result, D_Result, TwoComp_Result: std_logic_vector(15 downto 0):= "0000000000000000";
	signal Immediate_Y:                 std_logic_vector(3 downto 0);
	signal Immediate_Z:				    std_logic_vector(8 downto 0);
	signal opcode:       		 	    std_logic_vector(2 downto 0);
	signal rA_Y, rB_Y, rA_Z, write_reg: std_logic_vector(3 downto 0);
	signal alu_control_fuct:     	    std_logic_vector(1 downto 0);
	signal WR_Sel, PC_Sel, mem_read, mem_to_reg, MemWrite, reg_write: std_logic:= '0';
	signal alu_op, WD_Sel:              std_logic_vector(1 downto 0);

	 -- Check To Instruction Is Loaded
	type state is (loading, running, done);
	signal s: state:= loading;

	-- Enable Signal
	signal en: std_logic:= '0';

	component PC
		port (
			CLK:			 in  std_logic;
			address_to_load: in  std_logic_vector(15 downto 0);
			current_address: out std_logic_vector(15 downto 0)
		);
	end component;
	component Instruction_Memory
		port (
			read_address:                    in  std_logic_vector (15 downto 0);
			instruction, last_instr_address: out std_logic_vector (15 downto 0)
		);
	end component;
	component Register_File
		port (
			CLK:       						   in  std_logic;
			reg_write: 						   in  std_logic;
			read_reg_1, read_reg_2, write_reg: in  std_logic_vector(3 downto 0);
			write_data:                        in  std_logic_vector(15 downto 0);
			read_data_1, read_data_2:          out std_logic_vector(15 downto 0)
		);
	end component;
	component Controller
		port (
			opcode:                              in  std_logic_vector(2 downto 0);
			PC_Sel, WR_Sel, MemWrite, reg_write: out std_logic;
			alu_op, WD_Sel:                      out std_logic_vector(1 downto 0)
		);
	end component;
	component Multiplexer
		generic (n: natural:= 1);
			port (
				x, y: in  std_logic_vector(n-1 downto 0);
				s:    in  std_logic;
				z:    out std_logic_vector(n-1 downto 0)
			);
	end component;
	component Multiplexer4
		generic (n: natural := 1);
			port (
				a, b, c, d: in  std_logic_vector(n-1 downto 0); -- Four data inputs
				sel:        in  std_logic_vector(1 downto 0);    -- 2-bit selection line
				z:          out std_logic_vector(n-1 downto 0)   -- Output
			);
		end component;
	component Two_Complement
		Port ( 
			InputTwo:  in  std_logic_vector (15 downto 0);
			OutputTwo: out std_logic_vector (15 downto 0)
		);
	end component;
	component ALU_Controller
		port (
			alu_op:           in  std_logic_vector(1 downto 0);
			alu_control_fuct: out std_logic_vector(1 downto 0)
		);
	end component;
	component Sign_Extend
		generic (n: natural := 1);
		port (
			SE_Input:  in  std_logic_vector(n-1 downto 0);
			SE_Output: out std_logic_vector(15 downto 0)
		);
	end component;
    component Zero_Extend
		generic (n: natural := 1);
        port (
            ZF_Input:  in  std_logic_vector(n-1 downto 0);
            ZF_Output: out std_logic_vector(15 downto 0)
        );
    end component;
	component ALU
		port (
			in_1, in_2: 	  std_logic_vector(15 downto 0);
			alu_control_fuct: in  std_logic_vector(1 downto 0);
			ALU_Result:       out std_logic_vector(15 downto 0)
		);
	end component;
	component ShiftOne
		port (
			x: in  std_logic_vector(15 downto 0);
			y: out std_logic_vector(15 downto 0)
		);
	end component;
	component ShiftSeven 
		port(
			x: in  std_logic_vector(8 downto 0);
			y: out std_logic_vector(15 downto 0)
		);
		end component;
	component Adder
		port (
			In1, In2:   in  std_logic_vector(15 downto 0);
			Add_Output: out std_logic_vector(15 downto 0)
		);		
	end component;
	component Data_Memory is
		port (
			address, write_data: 	in std_logic_vector(15 downto 0);
			MemWrite, MemRead, CLK: in std_logic;
			read_data: 				out std_logic_vector(15 downto 0)
		);
	end component;
	component Decoder is
		Port ( 
			input  : in  std_logic_vector (3 downto 0);
			enable : in  std_logic;
			output : out std_logic_vector (15 downto 0)
		);
	end component;

	begin

	process(CLK)
		begin
			case s is
				when running =>
					en <= CLK;
				when others =>
					en <= '0';
			end case;

			if (CLK='1' and CLK'event) then
				case s is
					when loading =>
						s <= running; -- give 1 cycle to load the instructions into memory
					when running =>
						if (instr_address > last_instr_address) then
							s <= done; -- stop moving the pc after it has passed the last instruction
							en <= '0';
						end if;
					when others =>
						null;
				end case;
			end if;
	end process;

	opcode      <= instruction(15 downto 13);
	rA_Y        <= instruction(12 downto 9);
	rB_Y        <= instruction(3 downto 0);
	Immediate_Y <= instruction(7 downto 4);
	rA_Z        <= instruction(3 downto 0);
	Immediate_Z <= instruction(12 downto 4);

	Program_Counter: PC port map (en, next_address, instr_address); 

	InstructionMEM: Instruction_Memory port map (instr_address, instruction, last_instr_address);

	Control: Controller port map (
		opcode => opcode,
		PC_Sel => PC_Sel, 
		WR_Sel => WR_Sel,
		MemWrite => MemWrite,
		reg_write => reg_write,
		alu_op => alu_op 
	);

	SignEx: Sign_Extend generic map(9) port map (Immediate_Z, SE_Immediate);

	ALU_Control: ALU_Controller port map (alu_op, alu_control_fuct);

	ZeroEx1: Zero_Extend generic map(4) port map (Immediate_Y, ZE_Immediate_Y);

	ZeroEx2: Zero_Extend generic map(9) port map (Immediate_Z, ZE_Immediate_Z);

	ALUOne: ALU port map (read_data_1, ZE_Immediate_Y, alu_control_fuct, ALU_Result);
	-- Multiplexer Choose Between PC-Jump Instruction's
	MUX1: Multiplexer generic map(16) port map (
		x => Add1_Result, 
		y => Shifted_Add, 
		s => PC_Sel,
		z => next_address
	);

	REG: Register_File port map (
		CLK         => en,
		reg_write   => reg_write,
		read_reg_1  => rB_Y,
		read_reg_2  => rA_Y,                     		
		write_reg   => write_reg, 
		write_data  => write_data, 
		read_data_1 => read_data_1, 
		read_data_2 => read_data_2
	);

	ADD1: Adder port map (
		In1        => instr_address,
		In2        => "0000000000000010",
		Add_Output => Add1_Result
	);

	ADD2: Adder port map (
		In1        => read_data_1,
		In2        => instr_address,
		Add_Output => Add2_Result
	);

	ADD3: Adder port map (
		In1        => Add2_Result,
		In2        => SE_Immediate,
		Add_Output => Add3_Result
	);

	Shift1: ShiftOne port map (
		x => Add3_Result,
		y => Shifted_Add	
	);

	Shift2: ShiftOne port map (
		x => ZE_Immediate_Z,
		y => SevenShifted2
	);

	Shift3: ShiftSeven port map (
		x => Immediate_Z,
		y => SevenShifted
	);

	TwoComp: Two_Complement port map (
		InputTwo  => read_data_2,
		OutputTwo => TwoComp_Result
	);
    -- Multiplexer Choose Between Write Registers Instruction's
	MUX2: Multiplexer generic map(4) port map (
		x => rA_Y, 
		y => rA_Z, 
		s => WR_Sel,
		z => write_reg
	);
	-- Multiplexer Choose Between Registers Write Data Instruction's
	MUX3: Multiplexer4 generic map (16) port map (
		a   => TwoComp_Result, 
		b   => ALU_Result,
		c   => SevenShifted,  
		d   => D_Result,
		sel => WD_Sel,
		z   => write_data
	);
	
	Memory: Data_Memory port map (
		address    => SevenShifted2,
		write_data => read_data_1,
		MemWrite   => MemWrite,
		MemRead    => mem_read,
		CLK        => en,
		read_data  => D_Result
	);
	
end behavior;