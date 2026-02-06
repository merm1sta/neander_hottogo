-- conexão dos módulos do processador Neander --
library ieee;
use ieee.std_logic_1164.all;

entity neander is
    port(
        rst, clk : in std_logic
    );
end entity neander;

architecture top of neander is
    -- componente modulo ULA
    component modulo_ula is
        port(
            rst : in std_logic;
            clk : in std_logic;
            AC_nrw : in std_logic;
            ula_op : in std_logic_vector(2 downto 0);
            MEM_nrw : in std_logic;
            flags_nz : out std_logic_vector(1 downto 0);
            barramento : inout std_logic_vector(7 downto 0)         -- dado vindo da memória
        );
    end component modulo_ula;

    -- componente modulo MEM
    component modulo_mem is
        port(
            rst, clk : in std_logic;
            nbarrPC : in std_logic;
            REM_nrw : in std_logic;
            MEM_nrw : in std_logic;
            RDM_nrw : in std_logic;
            end_PC : in std_logic_vector(7 downto 0);
            end_Barr : in std_logic_vector(7 downto 0);
            barramento : inout std_logic_vector(7 downto 0)
        );
    end component modulo_mem;

    component modulo_uc_pc is
        port(
            rst, clk   : in  std_logic;
            PC_nrw     : in  std_logic;
            nbarrINC   : in    std_logic;
            barramento : in  std_logic_vector(7 downto 0);
            endereco   : out std_logic_vector(7 downto 0)
        );
    end component modulo_uc_pc;

    component modulo_UC is
        port(
            rst, clk   : in  std_logic;
            barramento : in  std_logic_vector(7 downto 0);
            RI_nrw     : in  std_logic;
            flags_nz   : in  std_logic_vector(1 downto 0);
            bctrl      : out std_logic_vector(10 downto 0)      -- barramento de controle
        );
    end component modulo_UC;

    -- sinais de controle e barramento
    signal snbarrINC, snbarrPC, sPC_nrw, sREM_nrw, sMEM_nrw, sRDM_nrw, sAC_nrw, sRI_nrw : std_logic;
    signal sula_op : std_logic_vector(2 downto 0);
    signal sflags_nz : std_logic_vector(1 downto 0);
    signal sbarramento : std_logic_vector(7 downto 0);
    signal send_PC : std_logic_vector(7 downto 0);
    signal s_bctrl : std_logic_vector(10 downto 0);

begin
    snbarrINC <= s_bctrl(10);
    snbarrPC <= s_bctrl(9);
    sula_op <= s_bctrl(8 downto 6);
    sPC_nrw <= s_bctrl(5);
    sAC_nrw <= s_bctrl(4);
    sMEM_nrw <= s_bctrl(3);
    sREM_nrw <= s_bctrl(2);
    sRDM_nrw <= s_bctrl(1);
    sRI_nrw <= s_bctrl(0);

    u_ULA : modulo_ula port map(rst, clk, sAC_nrw, sula_op, sMEM_nrw, sflags_nz, sbarramento);
    -- end_Barr não é utilizado, nesse caso, substituiremos no instanciamento pelo sinal de barramento
    u_MEM : modulo_mem port map(rst, clk, snbarrPC, sREM_nrw, sMEM_nrw, sRDM_nrw, send_PC, sbarramento, sbarramento);
    u_PC : modulo_uc_pc port map(rst, clk, sPC_nrw, snbarrINC, sbarramento, send_PC);
    u_UC : modulo_UC port map(rst, clk, sbarramento, sRI_nrw, sflags_nz, s_bctrl);

end architecture top;