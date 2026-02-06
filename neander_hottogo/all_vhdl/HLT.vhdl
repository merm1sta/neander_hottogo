-- instrução HLT (Halt) do processador Neander --
library ieee;
use ieee.std_logic_1164.all;

entity HLT is
    port(
        ciclo : in std_logic_vector(2 downto 0);    -- b2, b1 e b0
        saida : out std_logic_vector(10 downto 0)   -- sinais de controle de cada instrução
    );
end entity HLT;

architecture halt of HLT is

begin
    saida(10) <= '0';   -- nbarrINC
    saida(9) <= '0';    -- nbarrPC
    saida(8 downto 6) <= "000";     --ula_op
    saida(5) <= '0';    -- PC_nrw
    saida(4) <= '0';    -- AC_nrw
    saida(3) <= '0';    -- MEM_nrw
    saida(2) <= '0';    -- REM_nrw
    saida(1) <= '0';    -- RDM_nrw
    saida(0) <= '0';    -- RI_nrw

end architecture halt;