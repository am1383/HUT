library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ShiftSeven is
	port (
		x: in  std_logic_vector(8 downto 0);
		y: out std_logic_vector(15 downto 0)
	);
end entity;

architecture Behavior of ShiftSeven is
	signal tempShiftSeven: std_logic_vector(15 downto 0);

	begin
	    tempShiftSeven <= std_logic_vector(resize(unsigned(x), 16));
	    y              <= std_logic_vector(shift_left(signed(tempShiftSeven), 7));
end Behavior;