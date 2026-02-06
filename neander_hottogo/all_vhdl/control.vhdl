library ieee;
use ieee.std_logic_1164.all;

entity control is
    port(
        q    : in  std_logic_vector(2 downto 0);
        j, k : out std_logic_vector(2 downto 0)
    );
end entity control;

architecture funcional of control is
begin
    -- Lógica para contador síncrono de 3 bits:
    -- Bit 0 (LSB): Sempre inverte (J=1, K=1)
    j(0) <= '1';
    k(0) <= '1';

    -- Bit 1: Inverte quando Q0 é 1
    j(1) <= q(0);
    k(1) <= q(0);

    -- Bit 2 (MSB): Inverte quando Q0 e Q1 são 1
    j(2) <= q(0) and q(1);
    k(2) <= q(0) and q(1);
end architecture;