library ieee;
  use ieee.std_logic_1164.all;

  --MUX

entity reg1b is
  port (
    d      : in  std_logic;
    clk  : in  std_logic;
    pr, cl : in  std_logic;
    nrw    : in  std_logic;
    s      : out std_logic
  );
end entity;

--Módulo

architecture reg1bit of reg1b is
  component ffjkd is
    port (
      d      : in  std_logic;
      clock  : in  std_logic;
      pr, cl : in  std_logic;
      q, nq  : out std_logic
    );
  end component;

  signal datain, dataout : std_logic;

begin
  s <= dataout;

  datain <= dataout when nrw = '0' else d;

  -- instância do reg
  u_reg: ffjkd port map (datain, clk, pr, cl, dataout);

end architecture;
