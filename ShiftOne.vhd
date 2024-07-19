library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ShiftOne is
	port (
		x: in  std_logic_vector(15 downto 0);
		y: out std_logic_vector(15 downto 0)
	);
end entity;

architecture Behavior of ShiftOne is
	signal tempShiftOne: std_logic_vector(15 downto 0);

	begin
	    tempShiftOne <= std_logic_vector(resize(unsigned(x), 16));
	    y            <= std_logic_vector(shift_left(signed(tempShiftOne), 1));
end Behavior;