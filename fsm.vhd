library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fsm is
    port (
        CLK         : in  STD_LOGIC;
        RESET       : in  STD_LOGIC;
        ENTER       : in  STD_LOGIC;
        MATCH       : in  STD_LOGIC;
        MAXED       : in  STD_LOGIC;
        TIMER_DONE  : in  STD_LOGIC;
        INC         : out STD_LOGIC;
        START_TIMER : out STD_LOGIC;
        GREEN_LED   : out STD_LOGIC;
        RED_LED     : out STD_LOGIC;
        ALARM       : out STD_LOGIC;
        CTR_RESET   : out STD_LOGIC
    );
end fsm;

architecture behavioral of fsm is
    type state_type is (IDLE, CHECKING, UNLOCKED, WRONG, LOCKED, ALARM_STATE);
    signal state : state_type := IDLE;
begin
    process(CLK, RESET)
    begin
        if RESET = '1' then
            state <= IDLE;
        elsif rising_edge(CLK) then
            case state is
                when IDLE =>
                    if ENTER = '1' then
                        state <= CHECKING;
                    end if;

                when CHECKING =>
                    if MATCH = '1' then
                        state <= UNLOCKED;
                    elsif MAXED = '1' then
                        state <= ALARM_STATE;
                    else
                        state <= WRONG;
                    end if;

                when UNLOCKED =>
                    if RESET = '1' then
                        state <= IDLE;
                    end if;

                when WRONG =>
                    if MAXED = '1' then
                        state <= LOCKED;
                    else
                        state <= IDLE;
                    end if;

                when LOCKED =>
                    if TIMER_DONE = '1' then
                        state <= IDLE;
                    end if;

                when ALARM_STATE =>
                    if RESET = '1' then
                        state <= IDLE;
                    end if;

                when others =>
                    state <= IDLE;
            end case;
        end if;
    end process;

    INC         <= '1' when state = WRONG else '0';
    START_TIMER <= '1' when state = LOCKED else '0';
    GREEN_LED   <= '1' when state = UNLOCKED else '0';
    RED_LED     <= '1' when state = WRONG or state = LOCKED else '0';
    ALARM       <= '1' when state = ALARM_STATE else '0';
    CTR_RESET   <= '1' when state = UNLOCKED else '0';
end behavioral;
