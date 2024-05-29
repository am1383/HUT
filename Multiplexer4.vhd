library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Multiplexer4 is 
    generic (n: natural := 1);
    port (
        a, b, c, d: in  std_logic_vector(n-1 downto 0); -- Four data inputs
        sel:        in  std_logic_vector(1 downto 0);    -- 2-bit selection line
        z:          out std_logic_vector(n-1 downto 0)   -- Output
    );
end Multiplexer4;

architecture behavior of Multiplexer is
begin
    process(a, b, c, d, sel)
    begin
        case sel is
            when "00" =>
                z <= a;
            when "01" =>
                z <= b;
            when "10" =>
                z <= c;
            when "11" =>
                z <= d;
            when others =>
                z <= (others => '0'); -- Default case, can be modified as needed
        end case;
    end process;
end behavior;
