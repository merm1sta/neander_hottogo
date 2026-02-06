library ieee;
use ieee.std_logic_1164.all;

entity ffjkd is
    port(
        d : in std_logic;
        clock : in std_logic;
        pr, cl : in std_logic;
        q, nq : out std_logic
    );
end ffjkd;

architecture ffd of ffjkd is
    -- signal s_snj , s_snk : std_logic;
    -- signal s_sns , s_snr : std_logic;
    -- signal s_sns2, s_snr2 : std_logic;
    -- signal s_eloS, s_eloR : std_logic;
    signal s_eloQ : std_logic := '0';
    signal s_elonQ : std_logic := '1';
    -- signal s_nClock : std_logic;

begin
    process(clock, pr, cl)
    begin
        if (cl = '0') then
            s_eloQ <= '0';
            s_elonQ <= '1';
        elsif (pr = '0') then
            s_eloQ <= '1';
            s_elonQ <= '0';
        elsif rising_edge(clock) then
            s_eloQ <= d;
            s_elonQ <= not d;
        end if;
    end process;

    q <= s_eloQ;
    nq <= s_elonQ;

end architecture ffd;
