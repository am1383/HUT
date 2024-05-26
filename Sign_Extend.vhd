library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Sign_Extend is
	port (
		x: in std_logic_vector(7 downto 0);
		y: out std_logic_vector(15 downto 0)
	);
end Sign_Extend;

architecture behavior of sign_extend is
	begin
	    y <= std_logic_vector(resize(signed(x), y'length));
end behavior;