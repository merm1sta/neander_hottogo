-- neander secundario UC - CONTADOR 0-7 =======================================
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity moduloContador is
	port(
        rst, clk : in  std_logic;
	    counter  : out std_logic_vector(2 downto 0)
	);
end entity moduloContador;

architecture docountstuff of moduloContador is

    signal c  : std_logic_vector(2 downto 0) := (others => '0');
    signal um : std_logic_vector(2 downto 0) := "001";

begin

    process (rst, clk)
    begin

        if rst = '0' and rst'event then
            c <= "000";
        else
            if rst = '1' and clk = '0' and clk'event then
                if c = "111" then 
                    c <= "000";
                else
                    c <= std_logic_vector(unsigned(c) + unsigned(um));
                end if;
            end if;
        end if;
    end process;

    counter <= c;

end architecture docountstuff;
