-- neander módulo ULA (Unidade Lógica e Aritmética) do processador Neander --
library ieee;
use ieee.std_logic_1164.all;

entity modulo_ula is
    port(
        rst : in std_logic;
        clk : in std_logic;
        AC_nrw : in std_logic;
        ula_op : in std_logic_vector(2 downto 0);
        MEM_nrw : in std_logic;
        flags_nz : out std_logic_vector(1 downto 0);
        barramento : inout std_logic_vector(7 downto 0)
    );
end entity modulo_ula;

architecture comportamento of modulo_ula is

    --componente registrador AC (de 8 bits)
    component reg8b is
        port(
            d : in std_logic_vector(7 downto 0);
            clk : in std_logic;
            pr, cl : in std_logic; 
            nrw : in std_logic;
            s : out std_logic_vector(7 downto 0)
        );
    end component;

    --componente de flags N e Z (de 2 bits)
    component reg2b is
        port(
            d : in std_logic_vector(1 downto 0);
            clk : in std_logic;
            pr, cl : in std_logic; 
            nrw : in std_logic;
            s : out std_logic_vector(1 downto 0)
        );
    end component;

    --componente ULA interna
    component ula is
        port(
            x, y : in std_logic_vector(7 downto 0);
            ula_op : in std_logic_vector(2 downto 0);
            flags_nz : out std_logic_vector(1 downto 0);
            s : out std_logic_vector(7 downto 0)
        );
    end component;

    signal s_ac2ula : std_logic_vector(7 downto 0) := (others => 'Z'); -- atribuindo um valor inicial para a ULA não realizar uma operação de nada com nada; entrada x da ULA
    signal s_ula2ac : std_logic_vector(7 downto 0);                     -- resultado da operação da ula que vai (ou não) p/ reg AC
    signal s_ula2flags : std_logic_vector(1 downto 0);              -- resultado da operação da ula que vai (ou não) p/ reg de flags N e Z; saída flags_nz da ULA
    
begin
    u_reg8_ac : reg8b port map(s_ula2ac, clk, '1', rst, AC_nrw, s_ac2ula);
    u_reg2_flags : reg2b port map(s_ula2flags, clk, '1', rst, AC_nrw, flags_nz);
    u_ula_interna : ula port map(s_ac2ula, barramento, ula_op, s_ula2flags, s_ula2ac);

    -- resolve a trap inout do barramento
    -- abaixo temos o fluxo de escrita no barramento (quando a instrução STA é executada)
    barramento <= s_ac2ula when MEM_nrw = '1' else (others => 'Z');
    -- quando STA não está sendo executado (modo de leitura da memória, 
    -- como LDA, ADD, OR, AND e NOT), 
    -- o sinal s_ac2ula que vai para o barramento é 'Z'
    -- (alta impedância), para não ocasionar futuros problemas

end architecture comportamento;