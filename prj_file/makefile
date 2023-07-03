SHELL = /bin/bash -O extglob

all: compile sim verdi

compile:
	vcs -R -full64 -fsdb +define+FSDB +incdir+../source . -sverilog ../sim/CPU_top_tb.v  -l run.log -debug_all

sim: 
	./simv 

#sim: ./simv -gui

verdi:
	verdi ../sim/CPU_top_tb.v ../source/*.v -ssf CPU_top_tb.fsdb

clean:
	rm -rf !(makefile|signal.rc)


