library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Multiplexer3 is
    generic (n: natural:= 1);
    Port ( 
		sel: in  std_logic_vector (1 downto 0);
        d0 : in  std_logic_vector (n-1 downto 0);
        d1 : in  std_logic_vector (n-1 downto 0);
        d2 : in  std_logic_vector (n-1 downto 0);
        y  : out std_logic_vector (n-1 downto 0)
	);
end Multiplexer3;

architecture Behavioral of Multiplexer3 is
begin
    process(sel, d0, d1, d2)
    begin
        case sel is
            when "00" =>
                y <= d0;
            when "01" =>
                y <= d1;
            when "10" =>
                y <= d2;
            when others =>
                y <= d1;
        end case;
    end process;
end Behavioral;
