library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Multiplexer5 is 
    generic (n: natural := 1);
    port (
        a, b, c, d, e : in  std_logic_vector(n-1 downto 0);  -- Four data inputs
        sel:            in  std_logic_vector(2 downto 0);    -- 3-bit selection line
        z:              out std_logic_vector(n-1 downto 0)   -- Output
    );
end Multiplexer5;

architecture Behavior of Multiplexer5 is
begin
    process(a, b, c, d, e, sel)
    begin
        case sel is
            when "000" =>
                z <= a;
            when "001" =>
                z <= b;
            when "010" =>
                z <= c;
            when "011" =>
                z <= d;
            when "100" =>
                z <= e;
            when others =>
                z <= (others => '0');
        end case;
    end process;
end Behavior;
