library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity counter is
    port (
        CLK     : in  STD_LOGIC;
        RESET   : in  STD_LOGIC;
        INC     : in  STD_LOGIC;
        COUNT   : out STD_LOGIC_VECTOR(1 downto 0);
        MAXED   : out STD_LOGIC
    );
end counter;

architecture behavioral of counter is
    signal count_s : UNSIGNED(1 downto 0) := "00";
begin
    process(CLK, RESET)
    begin
        if RESET = '1' then
            count_s <= "00";
        elsif rising_edge(CLK) then
            if INC = '1' and count_s < 3 then
                count_s <= count_s + 1;
            end if;
        end if;
    end process;

    COUNT <= STD_LOGIC_VECTOR(count_s);
    MAXED <= '1' when count_s >= 3 else '0';
end behavioral;
