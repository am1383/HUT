library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ALU_Controller is
	port (
		ALU_op:           in  std_logic_vector(1 downto 0);
		ALU_control_fuct: out std_logic_vector(1 downto 0)
	);
end ALU_Controller;

architecture behavior of ALU_Controller is

	signal add: 		       std_logic_vector(1 downto 0):= "01";
	signal subtract: 		   std_logic_vector(1 downto 0):= "10";
	signal or_op: 		 	   std_logic_vector(1 downto 0):= "11";

	begin

		ALU_control_fuct <= add when(ALU_op="00") else
							subtract when(ALU_op="01") else
							or_op when(ALU_op="10");
end behavior;