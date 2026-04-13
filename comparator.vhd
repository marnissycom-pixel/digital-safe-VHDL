library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity comparator is
    port (
        CODE_IN  : in  STD_LOGIC_VECTOR(15 downto 0);
        SECRET   : in  STD_LOGIC_VECTOR(15 downto 0);
        MATCH    : out STD_LOGIC
    );
end comparator;

architecture behavioral of comparator is
begin
    MATCH <= '1' when CODE_IN = SECRET else '0';
end behavioral;
