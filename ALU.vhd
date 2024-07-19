library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity ALU is 
	generic (n: natural := 1);
	port (
		in_1, in_2:           std_logic_vector(n-1 downto 0);
		ALU_control_fuct: in  std_logic_vector(1  downto 0);
		ALU_result:       out std_logic_vector(n-1 downto 0)
	);
end ALU;

architecture behavior of ALU is

	signal add:      std_logic_vector(1 downto 0):= "01";
	signal subtract: std_logic_vector(1 downto 0):= "10";
	signal or_op:    std_logic_vector(1 downto 0):= "11";

	begin

		ALU_result <= in_1  +  in_2  when(ALU_control_fuct=add)      else
					  in_1  -  in_2  when(ALU_control_fuct=subtract) else
				      in_1  or in_2  when(ALU_control_fuct=or_op);

end behavior;