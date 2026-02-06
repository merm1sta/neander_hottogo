-- NEANDER TESTBENCH --
-- COMANDOS PARA EXECUTAR (sequencialmente): ghdl --clean | ghdl -a *.vhdl | ghdl -r tb_neander --wave=tb_neander.ghw --stop-time=1000ns | gtkwave -f tb_neander.ghw

library ieee;
use ieee.std_logic_1164.all;

entity tb_neander is
end entity tb_neander;

architecture hottogo of tb_neander is

    -- Definição do período do clock
    constant clock_period : time := 20 ns;

    -- Componente a ser testado (UUT - Unit Under Test)
    component neander is
        port(
            rst : in std_logic;
            clk : in std_logic
        );
    end component neander;

    -- Sinais internos para conectar à UUT 
    signal srst : std_logic := '1';
    signal sclk : std_logic := '0';              

begin
    sclk <= not(sclk) after clock_period / 2;     -- alterna o ciclo entre 0 e 1 a cada 10 ns

    -- Instanciação do Neander
    u_neander : neander port map(srst, sclk);

    tb : process
    begin
        	
        -- Reset inicial do sistema
        srst <= '0';     
        -- garante que o clear chegue em todos os ff e fique estável                                    
        wait for clock_period;	  
        -- libera o sistema para a execução                
        srst <= '1';                                         
        
        -- O Neander executará as instruções presentes na memória (modulo_mem)
        -- O tempo de espera depende do programa carregado na memória

        -- Finaliza a simulação
        wait;

    end process;

end architecture hottogo;