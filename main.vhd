library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.ALL;

entity main is
	port(
		CLK: in std_logic
	);
end main;

architecture behavior of main is

	signal instr_address: 		       std_logic_vector(15 downto 0); -- Address To Run
	signal next_address:  		       std_logic_vector(15 downto 0); -- Next Address For PC
	signal instruction:   	           std_logic_vector(15 downto 0); -- Current Addresss Instruction
	signal read_data_1, read_data_2, write_data, Z.E_Immediate-Y, Z.E_Immediate-Z, S.E-Immediate, Shifted_Immediate, Shifted_Add, SevenShifted, SevenShifted2, alu_in_2, ALU_Result, last_instr_address, Add1_Result, Add2_Result, Add3_Result, PC_Result, D_Result, TwoComp_Result: std_logic_vector(15 downto 0):= "00000000000000000000000000000000";
	signal Immediate-Y:                std_logic_vector(3 downto 0);
	signal Immediate-Z:				   std_logic_vector(8 downto 0);
	signal opcode:       		 	   std_logic_vector(2 downto 0);
	signal rA-Y, rB-Y, rA-Z, write_reg:std_logic_vector(3 downto 0);
	signal alu_control_fuct:     	   std_logic_vector(3 downto 0);
	signal WR-Sel, PC-Sel, mem_read, mem_to_reg, WD-D, alu_src, reg_write, alu_zero: std_logic:= '0';
	signal alu_op, WD-Sel:             std_logic_vector(1 downto 0);

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
	component Register
		port (
			CLK:       						   in  std_logic;
			reg_write: 						   in  std_logic;
			read_reg_1, read_reg_2, write_reg: in  std_logic_vector(4 downto 0);
			write_data:                        in  std_logic_vector(15 downto 0);
			read_data_1, read_data_2:          out std_logic_vector(15 downto 0)
		);
	end component;
	component Controller
		port (
			opcode: 																    in  std_logic_vector(2 downto 0);
			reg_dest,jump, branch, mem_read, mem_to_reg, WD-D, alu_src, reg_write: out std_logic;
			alu_op:																	    out std_logic_vector(1 downto 0)
		);
	end component;
	component Mulitplexer
		generic (n: natural:= 1);
			port (
				x,y: in  std_logic_vector(n-1 downto 0);
				s:   in  std_logic;
				z:   out std_logic_vector(n-1 downto 0)
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
			input  : in  std_logic_vector (15 downto 0);
			output : out std_logic_vector (15 downto 0)
		);
	end component;
	component ALU_Controller
		port (
			funct:            in  std_logic_vector(5 downto 0);
			alu_op:           in  std_logic_vector(1 downto 0);
			alu_control_fuct: out std_logic_vector(3 downto 0)
		);
	end component;
	component Sign_Extend
		generic (n: natural := 1);
		port (
			SE_Input:  in  std_logic_vector(15 downto 0);
			SE_Output: out std_logic_vector(15 downto 0)
		);
	end component;
    component Zero_Extend
		generic (n: natural := 1);
        port (
            ZF_Input:  in  std_logic_vector(7 downto 0);
            ZF_Output: out std_logic_vector(15 downto 0)
        );
    end component;
	component ALU
		port (
			in_1, in_2: std_logic_vector(15 downto 0);
			alu_control_fuct: in  std_logic_vector(3 downto 0);
			zero:			  out std_logic;
			ALU_Result:       out std_logic_vector(15 downto 0)
		);
	end component;
	component ShiftOne
		generic (n1: natural:= 16; n2: natural:= 16; k: natural:= 2);
		port (
			x: in  std_logic_vector(n1-1 downto 0);
			y: out std_logic_vector(n2-1 downto 0)
		);
	end component;
	component ShiftSeven 
		generic (n1: natural:= 16; n2: natural:= 16; k: natural:=7);
		port(
			x: in  std_logic_vector(n1-1 downto 0);
			y: out std_logic_vector(n2-1 downto 0)
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
			address, write_data:   in  std_logic_vector (15 downto 0);
			MemWrite, MemRead,CLK: in  std_logic;
			read_data: 			   out std_logic_vector (15 downto 0)
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
	rA-Y        <= instruction(12 downto 9);
	rB-Y        <= instruction(3 downto 0);l
	Immediate-Y <= instruction(7 downto 4);
	rA-Z        <= instruction(3 downto 0);
	Immediate-Z <= instruction(12 downto 4);

	Program_Counter: PC port map (en, next_address, instr_address); 

	Instruction_Memory: Instruction_Memory port map (instr_address, instruction, last_instr_address);

	Sign_Extend: Sign_Extend generic map(9) port map (Immediate-Z, S.E-Immediate);

	Controller: Controller port map (
		opcode => opcode,
		PC-Sel => PC-Sel, 
		jump => jump,
		branch => branch, 
		mem_read => mem_read, 
		mem_to_reg => mem_to_reg,
		WD-D => WD-D,
		alu_src => alu_src,
		reg_write => reg_write,
		alu_op => alu_op 
	);

	ALU_Controller: ALU_Controller port map (funct, alu_op, alu_control_fuct);

	Zero_Extend: Zero_Extend generic map(4) port map (Immediate-Y, Z.E_Immediate-Y);

	Zero_Extend: Zero_Extend generic map(9) port map (Immediate-Z, Z.E_Immediate-Z);

	ALU: ALU port map (read_data_1, Z.E_Immediate, alu_control_fuct, alu_zero, ALU_Result);

	Register: Register port map (
		CLK         => en,
		reg_write   => reg_write,
		read_reg_1  => rB-Y,
		read_reg_2  => rA-Z,
		write_reg   => write_reg, 
		write_data  => write_data, 
		read_data_1 => read_data_1, 
		read_data_2 => read_data_2
	);
	
	Memory: Instruction_Memory port map (
		address    => SevenShifted2,
		write_data => read_data_1,
		WD-D       => WD-D,
		MemRead    => mem_read,
		CLK        => en,
		read_data  => D_Result
	);

	ADD1: Adder port map (
		In1        => instr_address,
		In2        => "0000000000000010",
		Add_Output => Add1_Result
	);

	ADD2: Adder port map (
		In1 => read_data_2,
		In2 => instr_address,
		Add_Output => Add2_Result
	);

	ADD3: Adder port map (
		In1        => Add2_Result,
		In2        => S.E_Immediate,
		Add_Output => Add3_Result
	);

	ShiftOne: ShiftOne port map (
		x => Add3_Result,
		y => Shifted_Add	
	);

	ShiftOne2: ShiftOne port map (
		x => Z.E_Immediate_Z;
		y => SevenShifted2
	);

	ShiftSeven: ShiftSeven port map (
		x => Immediate-Z,
		y => SevenShifted
	);

	TwoComp: Two_Complement port map (
		input  => read_data_2,
		output => TwoComp_Result
	);
	-- Multiplexer Choose Between PC-Jump Instruction's
	MUX1PCSEL: Multiplexer generic map(16) port map (
		x => Add1_Result, 
		y => Shifted_Add, 
		s => PC-Sel,
		z => next_address
	);
    -- Multiplexer Choose Between Write Register Instruction's
	MUX2WRSel: Multiplexer generic map(16) port map (
		x => rA-Y, 
		y => rA-Z, 
		s => WR-Sel,
		z => write_reg
	);
	-- Multiplexer Choose Between Register Write Data Instruction's
	MUX3WDSel: Multiplexer4 generic map (16) port map (
		a   => TwoComp_Result, 
		b   => ALU_Result,
		c   => SevenShifted,  
		d   => D_Result,
		sel => WD-Sel,
		z   => write_data
	);

end behavior;