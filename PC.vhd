
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity pc is
	port(
		CLK:             in  std_logic;
		address_to_load: in  std_logic_vector(15 downto 0);
		current_address: out std_logic_vector(15 downto 0)
	);
end pc;

architecture behavior of pc is

	signal address: std_logic_vector(15 downto 0):= "0000000000000000";

	begin

        process(CLK)
            begin
            current_address <= address;
            if (CLK='0' and CLK'event) then
                address <= address_to_load;
            end if;
        end process;

end behavior;