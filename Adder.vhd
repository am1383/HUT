library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity Adder is
	port (
		In1, In2:   in  std_logic_vector(15 downto 0);
		Add_Output: out std_logic_vector(15 downto 0)
	);
end entity;

architecture Behavior of Adder is
	begin
		Add_Output <= In1 + In2;
end Behavior;