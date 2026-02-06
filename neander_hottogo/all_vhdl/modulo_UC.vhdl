-- neander módulo principal Unidade de Controle --
library IEEE;
use IEEE.std_logic_1164.all;

entity modulo_UC is
	port(
        rst, clk   : in  std_logic;
        barramento : in  std_logic_vector(7 downto 0);
        RI_nrw : in std_logic;
        flags_nz   : in  std_logic_vector(1 downto 0);
	    bctrl      : out std_logic_vector(10 downto 0)
	);
end entity modulo_UC;

architecture docontrolstuff of modulo_UC is
    -- componente reg AC e RI (registrador de 8 bits)
    component reg8b is
        port(
            d : in std_logic_vector(7 downto 0);
            clk : in std_logic;
            pr, cl : in std_logic; 
            nrw : in std_logic;
            s : out std_logic_vector(7 downto 0)
        );
    end component;
    
    -- componente Contador 0-7
    component moduloContador is
	port(
        rst, clk : in  std_logic;
	    counter  : out std_logic_vector(2 downto 0)
	);
end component;

    -- componentes UC-interno
    component LDA is
        port(
            ciclo : in std_logic_vector(2 downto 0);
            saida : out std_logic_vector(10 downto 0)
        );
    end component;

    component HLT is
        port(
            ciclo : in std_logic_vector(2 downto 0);
            saida : out std_logic_vector(10 downto 0)
        );
    end component;

    component NOP is
        port(
            ciclo : in std_logic_vector(2 downto 0);
            saida : out std_logic_vector(10 downto 0)
        );
    end component;

    component STA is
        port(
            ciclo : in std_logic_vector(2 downto 0);
            saida : out std_logic_vector(10 downto 0)
        );
    end component;

    component ADD is
        port(
            ciclo : in std_logic_vector(2 downto 0);
            saida : out std_logic_vector(10 downto 0)
        );
    end component;

    component inst_OR is
        port(
            ciclo : in std_logic_vector(2 downto 0);
            saida : out std_logic_vector(10 downto 0)
        );
    end component;

    component inst_AND is
        port(
            ciclo : in std_logic_vector(2 downto 0);
            saida : out std_logic_vector(10 downto 0)
        );
    end component;

    component inst_NOT is
        port(
            ciclo : in std_logic_vector(2 downto 0);
            saida : out std_logic_vector(10 downto 0)
        );
    end component;

    component JMP is
        port(
            ciclo : in std_logic_vector(2 downto 0);
            saida : out std_logic_vector(10 downto 0)
        );
    end component;

    component NZ_FALSE is
        port(
            ciclo : in std_logic_vector(2 downto 0);
            saida : out std_logic_vector(10 downto 0)
        );
    end component;

    -- 3 bits de contador
    signal s_ciclo : std_logic_vector(2 downto 0) := (others => 'Z');       -- saida do contador

    signal s_ri2dec : std_logic_vector(7 downto 0) := (others => 'Z');      -- saída do reg de instrução p/ decode

    -- nop, sta, lda, add, or, and, not, jmp, jn, jz, hlt
    signal s_dec2uc : std_logic_vector(10 downto 0) := (others => 'Z');

    signal s_bctrl  : std_logic_vector(10 downto 0) := (others => 'Z');     -- saída final do módulo UC (barramento de controle)

    signal sLDA, sHLT, sNOP, sSTA, sADD, sOR, sAND, sNOT, sJMP, sJN, sJZ, sNZF : std_logic_vector(10 downto 0);

    -- observacao: sinais para facilitar a leitura do codigo em waveform (gtkwave)
    signal instrucaoAtiva : string(1 to 3);         -- indica qual instrução está em execução
    signal operacaoULA    : string(1 to 3);         -- indica qual operação a ULA está realizando
    signal FLAGS          : string(1 to 2);         -- indica o estado dos flags N e Z

begin
    -- registrador RI
    u_regInstrucao : reg8b port map (barramento, clk, '1', rst, RI_nrw, s_ri2dec);

    -- componente DECODE
    -- decodificador 4 para 11
    s_dec2uc <= "10000000000" when s_ri2dec(7 downto 4) = "0000" else   -- Instrução: NOP
                "01000000000" when s_ri2dec(7 downto 4) = "0001" else   -- Instrução: STA
                "00100000000" when s_ri2dec(7 downto 4) = "0010" else   -- Instrução: LDA
                "00010000000" when s_ri2dec(7 downto 4) = "0011" else   -- Instrução: ADD
                "00001000000" when s_ri2dec(7 downto 4) = "0100" else   -- Instrução: OR
                "00000100000" when s_ri2dec(7 downto 4) = "0101" else   -- Instrução: AND
                "00000010000" when s_ri2dec(7 downto 4) = "0110" else   -- Instrução: NOT
                "00000001000" when s_ri2dec(7 downto 4) = "1000" else   -- Instrução: JMP
                "00000000100" when s_ri2dec(7 downto 4) = "1001" else   -- Instrução: JN
                "00000000010" when s_ri2dec(7 downto 4) = "1010" else   -- Instrução: JZ
                "00000000001" when s_ri2dec(7 downto 4) = "1111" else   -- Instrução: HLT
                "ZZZZZZZZZZZ"; -- indicação de problema
                
    -- contador
    u_contador : moduloContador port map (rst, clk, s_ciclo);

    -- Unidade de Controle
    -- MUX 11x11 específico para cada instrução
    -- controle do barramento
    s_bctrl <= sNOP when s_dec2uc(10 downto 0) = "10000000000" else
               sSTA when s_dec2uc(10 downto 0) = "01000000000" else
               sLDA when s_dec2uc(10 downto 0) = "00100000000" else
               sADD when s_dec2uc(10 downto 0) = "00010000000" else
               sOR when s_dec2uc(10 downto 0) = "00001000000" else
               sAND when s_dec2uc(10 downto 0) = "00000100000" else
               sNOT when s_dec2uc(10 downto 0) = "00000010000" else
               sJMP when s_dec2uc(10 downto 0) = "00000001000" else
               sJN when (s_dec2uc = "00000000100" and flags_nz(1) = '1') else
               sNZF when (s_dec2uc = "00000000100" and flags_nz(1) = '0') else      -- caso a condição não seja satisfeita, N = 0
               sJZ when (s_dec2uc = "00000000010" and flags_nz(0) = '1') else
               sNZF when (s_dec2uc = "00000000010" and flags_nz(0) = '0')else       -- caso a condição não seja satisfeita, Z = 0
               sHLT when s_dec2uc(10 downto 0) = "00000000001" else
               "ZZZZZZZZZZZ";  -- indicação de problema

    -- instanciar cada instrução    
    u_nop : NOP port map (s_ciclo, sNOP); 
    u_store : STA port map (s_ciclo, sSTA);
    u_load : LDA port map (s_ciclo, sLDA);
    u_add : ADD port map (s_ciclo, sADD);
    u_ou : inst_OR port map (s_ciclo, sOR);
    u_and : inst_AND port map (s_ciclo, sAND);
    u_not : inst_NOT port map (s_ciclo, sNOT);
    u_jump : JMP port map (s_ciclo, sJMP);
    u_nz_false : NZ_FALSE port map (s_ciclo, sNZF);         -- caso a condição não seja satisfeita
    u_negative : JMP port map (s_ciclo, sJN);               -- caso a condição seja satisfeita, é o mesmo processo da instrução JMP
    u_zero : JMP port map (s_ciclo, sJZ);                   -- caso a condição seja satisfeita, é o mesmo processo da instrução JMP
    u_halt : HLT port map (s_ciclo, sHLT);

    -- SAÍDA FINAL
    bctrl <= s_bctrl;           -- saída do módulo UC é a saída do mux especial 11x11

    -- OBSERVAÇÃO: OS PROCESS A SEGUIR SERVEM PARA FACILITAR O ENTENDIMENTO DAS INSTRUÇÕES EM EXECUÇÃO, 
    -- OPERAÇÕES REALIZADAS PELA ULA E AS FLAGS QUE ESTÃO SENDO SINALIZADAS.
    -- DESSA FORMA, É POSSÍVEL INTERPRETAR AS SAÍDAS DO GTKWAVE DE UMA FORMA MAIS SIMPLES
    -- SEM NECESSIDADE DE FICAR DECODIFICANDO OS NÚMEROS BINÁRIOS
    
    -- identificar a instrução ativa
    instrucaoAtiva <= "NOP" when s_dec2uc = "10000000000" else
                      "STA" when s_dec2uc = "01000000000" else
                      "LDA" when s_dec2uc = "00100000000" else
                      "ADD" when s_dec2uc = "00010000000" else
                      "OR " when s_dec2uc = "00001000000" else
                      "AND" when s_dec2uc = "00000100000" else
                      "NOT" when s_dec2uc = "00000010000" else
                      "JMP" when s_dec2uc = "00000001000" else
                      "JN " when s_dec2uc = "00000000100" else
                      "JZ " when s_dec2uc = "00000000010" else
                      "HLT" when s_dec2uc = "00000000001" else 
                      "***";

    -- mesmo esquema para operacaoULA
    operacaoULA <= "LDA" when s_bctrl(8 downto 6) = "000" else
                   "ADD" when s_bctrl(8 downto 6) = "001" else
                   "OR " when s_bctrl(8 downto 6) = "010" else
                   "AND" when s_bctrl(8 downto 6) = "011" else
                   "NOT" when s_bctrl(8 downto 6) = "100" else
                   "OFF";

    -- mesmo esquema para a flag nz
    FLAGS <= "--" when flags_nz = "00" else         -- nenhuma flag ativada
             "Z " when flags_nz = "01" else         -- flag ZERO ativada
             "N " when flags_nz = "10" else         -- flag NEGATIVE ativada
             "NZ" when flags_nz = "11" else         -- ambas as flags ativadas
             "??";                                  -- indicação de problema

end architecture docontrolstuff;