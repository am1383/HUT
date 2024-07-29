library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.numeric_std.all;

entity main is
	port (
		CLK : in std_logic
	);
end main;

architecture Behavior of main is

	signal instr_address: 		                         std_logic_vector(15 downto 0); 
	signal next_address:  		                         std_logic_vector(15 downto 0);
	signal instruction:   	                             std_logic_vector(15 downto 0); 
	signal read_data_1, read_data_2, write_data, ZE_Immediate_Y, ZE_Immediate_Z, ZE_Decoder_Result, SE_Immediate, Shifted_Immediate, Shifted_Add, SevenShifted, ZE_NumberOne, SevenShifted2, alu_in_2, ALU_Result, ALU_Result_2, Add1_Result, Add2_Result, Add3_Result, PC_Result, D_Result, TwoComp_Result: std_logic_vector(15 downto 0):= "0000000000000000";
	signal Immediate_Y:                                  std_logic_vector(3 downto 0);
	signal Immediate_Z:				                     std_logic_vector(8 downto 0);
	signal opcode, WD_Sel:       		                 std_logic_vector(2 downto 0);
	signal rA_Y, rB_Y, rA_Z, write_reg:                  std_logic_vector(3 downto 0);
	signal alu_control_fuct:     	                     std_logic_vector(1 downto 0);
	signal WR_Sel, PC_Sel, mem_read, mem_to_reg, MemWrite, reg_write: std_logic:= '0';
	signal alu_op:                                       std_logic_vector(1 downto 0);
	signal NumberOne:                                    std_logic_vector(3 downto 0) := "0001";
	signal Decoder_Result:                               std_logic_vector(3 downto 0) := "0000";

	component PC
		port (
			CLK:			 in  std_logic;
			address_to_load: in  std_logic_vector(15 downto 0);
			current_address: out std_logic_vector(15 downto 0)
		);
	end component;
	component Instruction_Memory
		port (
			read_address: in  std_logic_vector (15 downto 0);
			instruction : out std_logic_vector (15 downto 0)
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
			opcode:                                         in  std_logic_vector(2 downto 0);
			PC_Sel, WR_Sel, MemWrite, reg_write, mem_read:  out std_logic;
			WD_Sel:                                         out std_logic_vector(2 downto 0);
			alu_op:                                         out std_logic_vector(1 downto 0)
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
	component Multiplexer5
		generic (n: natural := 1);
			port (
				a, b, c, d, e : in  std_logic_vector(n-1 downto 0); 
				sel:            in  std_logic_vector(2 downto 0);    
				z:              out std_logic_vector(n-1 downto 0)   
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
		generic (n: natural := 1);
		port (
			in_1, in_2: 	  std_logic_vector(n-1 downto 0);
			alu_control_fuct: in  std_logic_vector(1 downto 0);
			ALU_Result:       out std_logic_vector(n-1 downto 0)
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
		port (
			input:    in  std_logic_vector(3 downto 0);
			output:   out std_logic_vector(15 downto 0);
			subset0:  out std_logic_vector(3 downto 0);
			subset1:  out std_logic_vector(3 downto 0);
			subset2:  out std_logic_vector(3 downto 0);
			subset3:  out std_logic_vector(3 downto 0)
		);
	end component;
	
	begin

	opcode      <= instruction(15 downto 13);
	rA_Y        <= instruction(12 downto 9);
	rB_Y        <= instruction(3 downto 0);
	Immediate_Y <= instruction(7 downto 4);
	rA_Z        <= instruction(3 downto 0);
	Immediate_Z <= instruction(12 downto 4);

	Program_Counter: PC port map (CLK, next_address, instr_address); 

	InstructionMEM: Instruction_Memory port map (instr_address, instruction);

	Control: Controller port map (
		opcode    => opcode,
		PC_Sel    => PC_Sel, 
		WD_Sel    => WD_Sel,
		WR_Sel    => WR_Sel,
		MemWrite  => MemWrite,
		mem_read  => mem_read,
		reg_write => reg_write,
		alu_op    => alu_op 
	);

	SignEx: Sign_Extend generic map(9) port map (Immediate_Z, SE_Immediate);

	ALU_Control: ALU_Controller port map (alu_op, alu_control_fuct);

	ZeroEx1: Zero_Extend generic map(4) port map (Immediate_Y, ZE_Immediate_Y);

	ZeroEx2: Zero_Extend generic map(9) port map (Immediate_Z, ZE_Immediate_Z);

	ALUOne: ALU generic map(16) port map (read_data_1, ZE_Immediate_Y, alu_control_fuct, ALU_Result);

	-- PC-Jump Instruction's
	MUX1: Multiplexer generic map(16) port map (
		x => Add1_Result, 
		y => Shifted_Add, 
		s => PC_Sel,
		z => next_address
	);

	-- Multiplexer Choose Between Write Registers Instruction's
	MUX2: Multiplexer generic map(4) port map (
		x => rA_Y, 
		y => rA_Z, 
		s => WR_Sel,
		z => write_reg
	);

	REG: Register_File port map (
		CLK         => CLK,
		reg_write   => reg_write,
		read_reg_1  => rB_Y,
		read_reg_2  => rA_Y,                     		
		write_reg   => write_reg,
		write_data  => write_data, 
		read_data_1 => read_data_1, 
		read_data_2 => read_data_2
	);

	DEC: Decoder port map (
		input   => rB_Y,
		subset1 => Decoder_Result
	);

	ZeroEx5: Zero_Extend generic map(4) port map (Decoder_Result, ZE_Decoder_Result);

	ZeroEx6: Zero_Extend generic map(4) port map (NumberOne, ZE_NumberOne);

	ALUTwo: ALU generic map(16) port map (ZE_Decoder_Result, ZE_NumberOne, alu_control_fuct, ALU_Result_2);

	ADD1: Adder port map (
		In1        => instr_address,
		In2        => "0000000000000010", -- 2+ Bit Program Counter
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

	-- Multiplexer Choose Between Registers Write Data Instruction's
	MUX3: Multiplexer5 generic map (16) port map (
		a   => TwoComp_Result, 
		b   => ALU_Result,
		c   => SevenShifted,  
		d   => D_Result,
		e   => ALU_Result_2,
		sel => WD_Sel,
		z   => write_data
	);
	
	Memory: Data_Memory port map (
		address    => SevenShifted2,
		write_data => read_data_1,
		MemWrite   => MemWrite,
		MemRead    => mem_read,
		CLK        => CLK,
		read_data  => D_Result
	);
	
end Behavior;