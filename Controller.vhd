library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Controller is
    port (
        opcode:                                         in  std_logic_vector(2 downto 0);
        PC_Sel, WR_Sel, MemWrite, reg_write, mem_read : out std_logic;
        WD_Sel:                                         out std_logic_vector(2 downto 0);
        alu_op:                                         out std_logic_vector(1 downto 0)
    );
end Controller;

architecture Behavior of Controller is

begin
    --                       NEG rA, rB                     SBR rB, Imm                    OR rA, rB, Imm                 RJMP rA, Imm                   LUI rA, Imm                    LDI rA, Imm                    STI rA, Imm
    PC_Sel     <= '0'   when opcode = "000" else '0'   when opcode = "001" else '0'   when opcode = "010" else '1'   when opcode = "011" else '1'   when opcode = "100" else '0'   when opcode = "101" else '0'   when opcode = "110" else '0';
    WR_Sel     <= '0'   when opcode = "000" else '0'   when opcode = "001" else '0'   when opcode = "010" else '0'   when opcode = "011" else '0'   when opcode = "100" else '1'   when opcode = "101" else '0'   when opcode = "110" else '0';
    mem_read   <= '0'   when opcode = "000" else '0'   when opcode = "001" else '0'   when opcode = "010" else '0'   when opcode = "011" else '0'   when opcode = "100" else '1'   when opcode = "101" else '0'   when opcode = "110" else '0';
    MemWrite   <= '0'   when opcode = "000" else '0'   when opcode = "001" else '0'   when opcode = "010" else '0'   when opcode = "011" else '0'   when opcode = "100" else '0'   when opcode = "101" else '1'   when opcode = "110" else '0';
    reg_write  <= '1'   when opcode = "000" else '0'   when opcode = "001" else '1'   when opcode = "010" else '0'   when opcode = "011" else '0'   when opcode = "100" else '1'   when opcode = "101" else '0'   when opcode = "110" else '0';
    alu_op     <= "10"  when opcode = "000" else "10"  when opcode = "001" else "10"  when opcode = "010" else "11"  when opcode = "011" else "00"  when opcode = "100" else "00"  when opcode = "101" else "00"  when opcode = "110" else "00";
    WD_Sel     <= "000" when opcode = "000" else "100" when opcode = "001" else "001" when opcode = "010" else "011" when opcode = "011" else "010" when opcode = "100" else "000" when opcode = "101" else "000" when opcode = "110" else "000";
     
end Behavior;
