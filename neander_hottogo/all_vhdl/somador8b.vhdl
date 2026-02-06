library ieee;
use ieee.std_logic_1164.all;

entity somador8b is
    port(
        x : in std_logic_vector(7 downto 0);
        y : in std_logic_vector(7 downto 0);
        Cin : in std_logic;
        s : out std_logic_vector(7 downto 0);
        Cout : out std_logic
    );
end entity somador8b;

architecture comportamento of somador8b is
    --Componente Somador completo
    component somador1b is
        port (
            x : in std_logic;
            y : in std_logic;
            cin : in std_logic;
            s : out std_logic;
            cout : out std_logic
        );
    end component;

    signal carry : std_logic_vector(7 downto 0);

begin
    --bit menos significativo
    u_somador0: somador1b port map(x => x(0), y => y(0), cin => Cin, s => s(0), cout => carry(0));
    u_somador1: somador1b port map(x => x(1), y => y(1), cin => carry(0), s => s(1), cout => carry(1));
    u_somador2: somador1b port map(x => x(2), y => y(2), cin => carry(1), s => s(2), cout => carry(2));
    u_somador3: somador1b port map(x => x(3), y => y(3), cin => carry(2), s => s(3), cout => carry(3));
    u_somador4: somador1b port map(x => x(4), y => y(4), cin => carry(3), s => s(4), cout => carry(4));
    u_somador5: somador1b port map(x => x(5), y => y(5), cin => carry(4), s => s(5), cout => carry(5));
    u_somador6: somador1b port map(x => x(6), y => y(6), cin => carry(5), s => s(6), cout => carry(6));
    u_somador7: somador1b port map(x => x(7), y => y(7), cin => carry(6), s => s(7), cout => carry(7));

    --resultado do carry out do somador de 8 bits
    Cout <= carry(7); --simulação 02: after 4 ns
end architecture;


    