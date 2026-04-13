library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity timer is
    port (
        CLK     : in  STD_LOGIC;
        START   : in  STD_LOGIC;
        RESET   : in  STD_LOGIC;
        DONE    : out STD_LOGIC
    );
end timer;

architecture behavioral of timer is
    signal count_s : UNSIGNED(4 downto 0) := (others => '0');
    signal running : STD_LOGIC := '0';
begin
    process(CLK, RESET)
    begin
        if RESET = '1' then
            count_s <= (others => '0');
            running <= '0';
        elsif rising_edge(CLK) then
            if START = '1' then
                running <= '1';
                count_s <= (others => '0');
            elsif running = '1' then
                if count_s < 30 then
                    count_s <= count_s + 1;
                else
                    running <= '0';
                    count_s <= (others => '0');
                end if;
            end if;
        end if;
    end process;

    DONE <= '1' when running = '0' and count_s = 0 else '0';
end behavioral;
