library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Sign_Extend is
	generic (n: natural := 1);
	port (
		SE_Input:  in  std_logic_vector(n-1 downto 0);
		SE_Output: out std_logic_vector(15 downto 0)
	);
end Sign_Extend;

architecture behavior of Sign_Extend is
	begin
	    SE_Output <= std_logic_vector(resize(signed(SE_Input), SE_Output'length));
end behavior;