library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top is
    port (
        CLK       : in  STD_LOGIC;
        RESET     : in  STD_LOGIC;
        ENTER     : in  STD_LOGIC;
        CODE_IN   : in  STD_LOGIC_VECTOR(15 downto 0);
        GREEN_LED : out STD_LOGIC;
        RED_LED   : out STD_LOGIC;
        ALARM     : out STD_LOGIC
    );
end top;

architecture structural of top is

    component comparator
        port (
            CODE_IN : in  STD_LOGIC_VECTOR(15 downto 0);
            SECRET  : in  STD_LOGIC_VECTOR(15 downto 0);
            MATCH   : out STD_LOGIC
        );
    end component;

    component counter
        port (
            CLK   : in  STD_LOGIC;
            RESET : in  STD_LOGIC;
            INC   : in  STD_LOGIC;
            COUNT : out STD_LOGIC_VECTOR(1 downto 0);
            MAXED : out STD_LOGIC
        );
    end component;

    component timer
        port (
            CLK   : in  STD_LOGIC;
            START : in  STD_LOGIC;
            RESET : in  STD_LOGIC;
            DONE  : out STD_LOGIC
        );
    end component;

    component fsm
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
    end component;

    constant SECRET_CODE : STD_LOGIC_VECTOR(15 downto 0) := x"1234";

    signal match_s      : STD_LOGIC;
    signal maxed_s      : STD_LOGIC;
    signal timer_done_s : STD_LOGIC;
    signal inc_s        : STD_LOGIC;
    signal start_timer_s: STD_LOGIC;
    signal ctr_reset_s  : STD_LOGIC;
    signal count_s      : STD_LOGIC_VECTOR(1 downto 0);

begin
    U_COMP : comparator port map(CODE_IN, SECRET_CODE, match_s);
    U_CTR  : counter    port map(CLK, ctr_reset_s, inc_s, count_s, maxed_s);
    U_TMR  : timer      port map(CLK, start_timer_s, RESET, timer_done_s);
    U_FSM  : fsm        port map(CLK, RESET, ENTER, match_s, maxed_s,
                                 timer_done_s, inc_s, start_timer_s,
                                 GREEN_LED, RED_LED, ALARM, ctr_reset_s);
end structural;
