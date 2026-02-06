ghdl --clean

ghdl -a *.vhdl

ghdl -r tb_neander --wave=tb_neander.ghw --stop-time=12000ns

#gtkwave -f tb_neander.ghw