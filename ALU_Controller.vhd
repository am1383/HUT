library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ALU_Controller is
	port (
		funct:            in  std_logic_vector(5 downto 0);
		ALU_op:           in  std_logic_vector(1 downto 0);
		ALU_control_fuct: out std_logic_vector(3 downto 0)
	);
end ALU_Controller;

architecture behavior of ALU_Controller is
	signal and_op: std_logic_vector(3 downto 0):= "0000";
	signal or_op: std_logic_vector(3 downto 0):= "0001";
	signal add: std_logic_vector(3 downto 0):= "0010";
	signal subtract_not_equal: std_logic_vector(3 downto 0):= "0011";
	signal subtract: std_logic_vector(3 downto 0):= "0110";
	signal set_on_less_than: std_logic_vector(3 downto 0):= "0111";

	begin

	ALU_control_fuct <= add when(ALU_op="00" or (ALU_op="10" and funct="100000")) else
						subtract when(ALU_op="01" or (ALU_op="10" and funct="100010")) else
						subtract_not_equal when(ALU_op="11") else
						and_op when(ALU_op="10" and funct="100100") else
						or_op when(ALU_op="10" and funct="100101") else
						set_on_less_than when(ALU_op="10" and funct="101010") else
						"0000";
end behavior;