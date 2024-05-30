library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Controller is
	port (
		opcode:                                       in  std_logic_vector(2 downto 0);
		PC-Sel, WR-Sel, WD-D, alu_src, reg_write:     out std_logic;
		alu_op, WD-Sel:                               out std_logic_vector(1 downto 0)
	);
end Controller;

architecture behavior of Controller is

	begin
	--				           NEG rA, rB 				     SBR rB, Imm			    OR rA, rB, Imm                            bne                            jump                           lw                               sw
		PC-Sel    <= 	'0'  when opcode="000"  else '-'  when opcode="001"  else '0'  when opcode="010"  else '0'  when opcode="000101"  else '0'  when opcode="000010"  else '0'  when opcode="100011"  else '0'  when opcode="101011"  else '0';
		WR-Sel    <=    '0'  when opcode="000"  else '-'  when opcode="001"  else '0'  when opcode="010"  else '0'  when opcode="000101"  else '1'  when opcode="000010"  else '0'  when opcode="100011"  else '0'  when opcode="101011"  else '0';
		WD-D      <= 	'0'  when opcode="000"  else '-'  when opcode="001"  else '0'  when opcode="010"  else '0'  when opcode="000101"  else '0'  when opcode="000010"  else '0'  when opcode="100011"  else '1'  when opcode="101011"  else '0';
		reg_write <= 	'1'  when opcode="000"  else '-'  when opcode="001"  else '1'  when opcode="010"  else '0'  when opcode="000101"  else '0'  when opcode="000010"  else '1'  when opcode="100011"  else '0'  when opcode="101011"  else '0';
		alu_op    <= 	"10" when opcode="000"  else "--" when opcode="001"  else "10" when opcode="010"  else "11" when opcode="000101"  else "00" when opcode="000010"  else "00" when opcode="100011"  else "00" when opcode="101011"  else "00";
		WD-Sel    <=	"00" when opcode="000"  else "--" when opcode="001"  else "01" when opcode="010"  else "11" when opcode="000101"  else "00" when opcode="000010"  else "00" when opcode="100011"  else "00" when opcode="101011"  else "00";
		
end behavior;