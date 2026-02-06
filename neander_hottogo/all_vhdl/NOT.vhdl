-- instrução NOT do processador Neander --
library ieee;
use ieee.std_logic_1164.all;

entity inst_NOT is
    port(
        ciclo : in std_logic_vector(2 downto 0);    -- b2, b1 e b0
        saida : out std_logic_vector(10 downto 0)   -- sinais de controle de cada instrução
    );
end entity inst_NOT;

architecture neg of inst_NOT is

begin
    saida(10) <= '1';   -- nbarrINC
    saida(9) <= '1';    -- nbarrPC
    saida(8 downto 6) <= "100";     --ula_op
    saida(5) <= not ciclo(2) and not ciclo(1) and ciclo(0);
    saida(4) <= ciclo(2) and ciclo(1) and ciclo(0);
    saida(3) <= '0';
    saida(2) <= not ciclo(2) and not ciclo(1) and not ciclo(0);
    saida(1) <= not ciclo(2) and not ciclo(1) and ciclo(0);
    saida(0) <= not ciclo(2) and ciclo(1) and not ciclo(0);

end architecture neg;
