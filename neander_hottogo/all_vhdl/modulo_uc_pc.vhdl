-- neander módulo secundario UC-PC (conexão entre Unidade de Controle e Program Counter) --
library IEEE;
use IEEE.std_logic_1164.all;

entity modulo_uc_pc is
    port(
        rst, clk   : in  std_logic;
        PC_nrw     : in  std_logic;                         -- se estiver em '0', nbarrINC não importa, pois não carrega PC
        nbarrINC   : in    std_logic;                       -- seleciona se haverá incremento ou salto
        barramento : in  std_logic_vector(7 downto 0);
        endereco   : out std_logic_vector(7 downto 0)
    );
end entity modulo_uc_pc;
-- se nbarrINC = '0' e PC_nrw = '1', PC_nrw recebe o que vem do barramento (salto)
-- se nbarrINC = '1' e PC_nrw = '1', PC_nrw será incrementado

architecture dopointstuff of modulo_uc_pc is

    -- componente regPC
    component reg8b is
        port(
            d : in std_logic_vector(7 downto 0);
            clk : in std_logic;
            pr, cl : in std_logic; 
            nrw : in std_logic;
            s : out std_logic_vector(7 downto 0)
        );
    end component;

    -- somador
    component somador8b is
        port(
            x : in std_logic_vector(7 downto 0);
            y : in std_logic_vector(7 downto 0);
            Cin : in std_logic;
            s : out std_logic_vector(7 downto 0);
            Cout : out std_logic
        );
    end component;    

    signal s_pcAtual, s_mux2pc : std_logic_vector(7 downto 0) := (others => 'Z');
    signal sadd, x, y   : std_logic_vector(7 downto 0) := (others => 'Z');
    signal s_um : std_logic_vector(7 downto 0) := "00000001";
    signal saddc : std_logic;           -- carry out só tem 1 bit

begin

    -- registrador PC
    u_pc : reg8b port map (s_mux2pc, clk, '1', rst, PC_nrw, s_pcAtual);
    
    -- incrementador do PC
    x <= s_um;              -- somando um ao Program Counter (é o incremento)
    y <= s_pcAtual;     

    -- ADDER
    u_somador : somador8b port map (x, y, '0', sadd, saddc);

    -- mux2x8
    -- seleciona se é dado do barramento que entra ou se irá incrementar o Program Counter (PC + 1)
    s_mux2pc <= barramento when nbarrINC = '0' else sadd;       

    -- conecta o sinal interno à saída da entidade
    endereco <= s_pcAtual;

end architecture dopointstuff;
