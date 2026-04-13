library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity testbench is
end testbench;

architecture behavioral of testbench is

    component top
        port (
            CLK       : in  STD_LOGIC;
            RESET     : in  STD_LOGIC;
            ENTER     : in  STD_LOGIC;
            CODE_IN   : in  STD_LOGIC_VECTOR(15 downto 0);
            GREEN_LED : out STD_LOGIC;
            RED_LED   : out STD_LOGIC;
            ALARM     : out STD_LOGIC
        );
    end component;

    signal CLK       : STD_LOGIC := '0';
    signal RESET     : STD_LOGIC := '0';
    signal ENTER     : STD_LOGIC := '0';
    signal CODE_IN   : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal GREEN_LED : STD_LOGIC;
    signal RED_LED   : STD_LOGIC;
    signal ALARM     : STD_LOGIC;

begin
    UUT : top port map(CLK, RESET, ENTER, CODE_IN, GREEN_LED, RED_LED, ALARM);

    CLK <= not CLK after 5 ns;

    process
    begin
        RESET <= '1'; wait for 20 ns;
        RESET <= '0'; wait for 20 ns;

        -- Test 1: WRONG code
        CODE_IN <= x"0000"; ENTER <= '1'; wait for 10 ns;
        ENTER <= '0'; wait for 30 ns;

        -- Test 2: WRONG code again
        CODE_IN <= x"9999"; ENTER <= '1'; wait for 10 ns;
        ENTER <= '0'; wait for 30 ns;

        -- Test 3: WRONG code again ? LOCKED
        CODE_IN <= x"ABCD"; ENTER <= '1'; wait for 10 ns;
        ENTER <= '0'; wait for 30 ns;

        -- Wait for lockdown timer
        wait for 400 ns;

        -- Test 4: CORRECT code ? GREEN LED
        CODE_IN <= x"1234"; ENTER <= '1'; wait for 10 ns;
        ENTER <= '0'; wait for 30 ns;

        -- Reset system
        RESET <= '1'; wait for 20 ns;
        RESET <= '0'; wait for 20 ns;

        -- Test 5: Correct code immediately
        CODE_IN <= x"1234"; ENTER <= '1'; wait for 10 ns;
        ENTER <= '0'; wait for 30 ns;

        wait;
    end process;
end behavioral;
