-- instrução JMP (Jump) do processador Neander --
library ieee;
use ieee.std_logic_1164.all;

entity JMP is
    port(
        ciclo : in std_logic_vector(2 downto 0);  -- b2, b1 e b0
        saida : out std_logic_vector(10 downto 0)   -- sinais de controle de cada instrução
    );
end entity JMP;

architecture jump of JMP is

begin
    saida(10) <= not ciclo(2) or ciclo(1) or not ciclo(0); -- nbarrINC
    saida(9) <= '1'; -- nbarrPC
    saida(8 downto 6) <= "000";                            -- ula_op
    saida(5) <= not ciclo(1) and ciclo(0); -- PC_nrw
    saida(4) <= '0'; -- AC_nrw
    saida(3) <= '0'; -- MEM_nrw
    saida(2) <= not ciclo(2) and (ciclo(1) xnor ciclo(0)); -- REM_nrw
    saida(1) <= not ciclo(1) and (ciclo(2) xor ciclo(0)); -- RDM_nrw
    saida(0) <= not ciclo(2) and ciclo(1) and not ciclo(0); -- RI_nrw

end architecture jump;
