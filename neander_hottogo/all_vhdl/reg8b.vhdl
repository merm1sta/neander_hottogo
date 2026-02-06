library ieee;
  use ieee.std_logic_1164.all;

entity reg8b is
  port (
    d      : in  std_logic_vector(7 downto 0);
    clk  : in  std_logic;
    pr, cl : in  std_logic;
    nrw    : in  std_logic;
    s      : out std_logic_vector(7 downto 0)
  );
end entity;

architecture reg8bits of reg8b is
  component reg1b is
    port (
      d      : in  std_logic;
      clk  : in  std_logic;
      pr, cl : in  std_logic;
      nrw    : in  std_logic;
      s      : out std_logic
    );
  end component;

begin
  -- instâncias de regCarga1bit (8 vezes)
  u_reg0: reg1b port map (d(0), clk, pr, cl, nrw, s(0));
  u_reg1: reg1b port map (d(1), clk, pr, cl, nrw, s(1));
  u_reg2: reg1b port map (d(2), clk, pr, cl, nrw, s(2));
  u_reg3: reg1b port map (d(3), clk, pr, cl, nrw, s(3));
  u_reg4: reg1b port map (d(4), clk, pr, cl, nrw, s(4));
  u_reg5: reg1b port map (d(5), clk, pr, cl, nrw, s(5));
  u_reg6: reg1b port map (d(6), clk, pr, cl, nrw, s(6));
  u_reg7: reg1b port map (d(7), clk, pr, cl, nrw, s(7));
  -- como alternativa e sugestão, é possível trocar as 8 linhas anteriores
  -- por um generate do VHDL!
end architecture;