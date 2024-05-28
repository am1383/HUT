library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity Adder is
	port (
		x,y: in  std_logic_vector(15 downto 0);
		z: 	 out std_logic_vector(15 downto 0)
	);
end entity;

architecture behavior of Adder is
	begin
		z <= x+y;
end behavior;