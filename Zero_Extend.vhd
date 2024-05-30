library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Zero_Extend is
	generic (n: natural := 1);
	port (
		ZF_Input:  in  std_logic_vector(n-1 downto 0);
		ZF_Output: out std_logic_vector(15 downto 0)
	);
end Zero_Extend;

architecture behavior of Zero_Extend is
	begin
	    ZF_Output <= std_logic_vector(resize(unsigned(ZF_Input), ZF_Output'length));
end behavior;