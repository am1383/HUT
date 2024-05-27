library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Zero_Extend is
	port (
		x: in  std_logic_vector(7 downto 0);
		y: out std_logic_vector(15 downto 0)
	);
end Zero_Extend;

architecture behavior of Zero_Extend is
	begin
		-- Extend Zero In Output
	    y <= std_logic_vector(resize(unsigned(x), y'length));
end behavior;