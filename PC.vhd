library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity PC is
	port(
		CLK:             in  std_logic;
		address_to_load: in  std_logic_vector(15 downto 0);
		current_address: out std_logic_vector(15 downto 0)
	);
end PC;

architecture Behavior of PC is

	signal address: std_logic_vector(15 downto 0):= "0000000000000000";

	begin

        process(CLK)
            begin
                current_address <= address;
                if (CLK='0' and CLK'event) then
                    address <= address_to_load;
                end if;
        end process;

end Behavior;