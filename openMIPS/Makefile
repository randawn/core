
EXE       =vcs
VCS_OPT   =+v2k -debug -sverilog -full64 +lint=all,noVCDE
NOVAS_PLI =-P /home/ran/EDA/synopsys/verdi/share/PLI/VCS/LINUX64/novas.tab /home/ran/EDA/synopsys/verdi/share/PLI/VCS/LINUX64/pli.a
FILE      =-f f.lst

all: bench comp run

bench:
	cd bench; make

comp:
	${EXE} ${VCS_OPT} ${NOVAS_PLI} ${FILE}

run:
	./simv


clean:
	rm ./simv ./simv.daidir/ csrc/ dump.fsdb novas_dump.log ucli.key verdiLog/ novas.rc novas.conf -rf
