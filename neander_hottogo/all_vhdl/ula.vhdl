-- componente Unidade Lógica e Aritmética do processador Neander --
library ieee;
use ieee.std_logic_1164.all;

entity ula is 
    port(
        x, y : in std_logic_vector(7 downto 0);             -- x: é o que está no registrador AC; y: é o que vem da memória
        ula_op : in std_logic_vector(2 downto 0);           -- determina a operação a ser efetuada pela ula
        flags_nz : out std_logic_vector(1 downto 0);        -- determina se é negativo ou zero
        s : out std_logic_vector(7 downto 0)                -- saída
    );
end entity ula;

architecture comportamento of ula is

    --componente somador de 8 bits
    component somador8b is
        port(
            x : in std_logic_vector(7 downto 0);            
            y : in std_logic_vector(7 downto 0);           
            Cin : in std_logic;
            s : out std_logic_vector(7 downto 0);
            Cout : out std_logic
        );
    end component;

    signal s_not, s_and, s_or, s_add, s_lda, s_resultado : std_logic_vector(7 downto 0);
    signal s_cout : std_logic;

    begin

        -- LOAD 
        -- no NEANDER é AC <= MEM[endereço]
        s_lda <= y;

        -- ADD
        -- no NEANDER é AC <= AC + MEM[endereço]
        -- s_add vai ter o resultado da soma de x e y
        -- sem carry-in
        u_somador8b: somador8b port map(x, y, '0', s_add, s_cout);

        -- OR (bit a bit) 
        -- no NEANDER é AC <= AC or MEM[endereço]
        s_or(0) <= x(0) or y(0);
        s_or(1) <= x(1) or y(1);
        s_or(2) <= x(2) or y(2);
        s_or(3) <= x(3) or y(3);
        s_or(4) <= x(4) or y(4);
        s_or(5) <= x(5) or y(5);
        s_or(6) <= x(6) or y(6);
        s_or(7) <= x(7) or y(7);

        -- AND (bit a bit)
        -- no NEANDER é AC <= AC and MEM[endereço]
        s_and(0) <= x(0) and y(0);
        s_and(1) <= x(1) and y(1);
        s_and(2) <= x(2) and y(2);
        s_and(3) <= x(3) and y(3);
        s_and(4) <= x(4) and y(4);
        s_and(5) <= x(5) and y(5);
        s_and(6) <= x(6) and y(6);
        s_and(7) <= x(7) and y(7);

        -- NOT
        -- no NEANDER é AC <= not AC
        s_not <= not x;

        --MULTIPLEXADOR DE SAÍDA DA ULA (MUX 5X8)
        s_resultado <= s_lda when ula_op = "000" else
                        s_add when ula_op = "001" else
                        s_or when ula_op = "010" else
                        s_and when ula_op = "011" else
                        s_not when ula_op = "100" else
                        (others => 'Z');

        -- SAÍDA FINAL
        s <= s_resultado;

        --DETECTOR DE FLAGS N E Z
        -- flag N é de número negativo (bit mais significativo = 1)
        flags_nz(1) <= s_resultado(7); --conferindo o valor do bit 7 (mais significativo), se for 1, flag NEGATIVE é setada

        -- flag Z é zero (todos os bits = 0)
        -- utilizando uma porta NOR gigantesca
        flags_nz(0) <= not (s_resultado(7) or s_resultado(6) or s_resultado(5) or s_resultado(4) or   
                             s_resultado(3) or s_resultado(2) or s_resultado(1) or s_resultado(0));

end architecture comportamento;