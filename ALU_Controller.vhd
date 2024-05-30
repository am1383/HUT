library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ALU_Controller is
	port (
		ALU_op:           in  std_logic_vector(1 downto 0);
		ALU_control_fuct: out std_logic_vector(3 downto 0)
	);
end ALU_Controller;

architecture behavior of ALU_Controller is

	signal or_op: 		 	   std_logic_vector(3 downto 0):= "0001";
	signal add: 		       std_logic_vector(3 downto 0):= "0010";
	signal subtract_not_equal: std_logic_vector(3 downto 0):= "0011";
	signal subtract: 		   std_logic_vector(3 downto 0):= "0110";

	begin

		ALU_control_fuct <= add when(ALU_op="00") else
							subtract when(ALU_op="01") else
							subtract_not_equal when(ALU_op="11") else
							or_op when(ALU_op="10") else "0000";
end behavior;