library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ShiftOne is
	generic (n1: natural:= 16; n2: natural:= 16; k: natural:= 1);
	port (
		x: in  std_logic_vector(n1-1 downto 0);
		y: out std_logic_vector(n2-1 downto 0)
	);
end entity;

architecture behavior of ShiftOne is
	signal temp: std_logic_vector(n2-1 downto 0);

	begin
	    temp <= std_logic_vector(resize(unsigned(x), n2));
	    y <= std_logic_vector(shift_left(signed(temp), k));
end behavior;