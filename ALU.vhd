library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity ALU is 
	port (
		in_1, in_2:       std_logic_vector(15 downto 0);
		ALU_control_fuct: in  std_logic_vector(3 downto 0);
		zero:             out std_logic;
		ALU_result:       out std_logic_vector(15 downto 0)
	);
end ALU;

architecture behavior of ALU is
	signal and_op:             std_logic_vector(3 downto 0):= "0000";
	signal or_op:			   std_logic_vector(3 downto 0):= "0001";
	signal add:    			   std_logic_vector(3 downto 0):= "0010";
	signal subtract_not_equal: std_logic_vector(3 downto 0):= "0011";
	signal subtract:           std_logic_vector(3 downto 0):= "0110";
	signal set_on_less_than:   std_logic_vector(3 downto 0):= "0111";

	begin

	ALU_result <=	in_1 + in_2 when(ALU_control_fuct=add) else
					in_1 - in_2 when(ALU_control_fuct=subtract or ALU_control_fuct=subtract_not_equal) else
					in_1 and in_2 when(ALU_control_fuct=and_op) else
					in_1 or in_2 when(ALU_control_fuct=or_op) else
					"0000000000000001" when(ALU_control_fuct=set_on_less_than and in_1 < in_2) else
					"0000000000000000" when(ALU_control_fuct=set_on_less_than);

	zero <=	'1' when(in_1/=in_2 and ALU_control_fuct=subtract_not_equal) else 
			'0' when(in_1=in_2 and ALU_control_fuct=subtract_not_equal) else 
			'1' when(in_1=in_2) else 
			'0';

end behavior;