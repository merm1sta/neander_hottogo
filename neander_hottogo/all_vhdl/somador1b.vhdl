library ieee;
use ieee.std_logic_1164.all;

entity somador1b is
    port (
        x : in std_logic;
        y : in std_logic;
        cin : in std_logic;
        s : out std_logic;
        cout : out std_logic
    );
end entity somador1b;

architecture adicao of somador1b is
    begin
        --exp booleana da saída
        s <= (x xor y) xor cin; --simulação 02: after 4 ns
        --exp booleana do carry out
        cout <= (x and y) or (cin and x) or (cin and y); --simulação 02: after 2*4 ns
end adicao;