AS=asl
P2BIN=p2bin
SRC=patch.a68
BSPLIT=bsplit
MAME=mame
ROMDIR=~/.mame/roms

ASFLAGS=-i . -n -U

.PHONY: prg.orig prg.o

all: puyopuy2

prg.orig: puyopuy2.zip
	@rm -rf data/
	mkdir -p data/
	cp puyopuy2.zip data/ && cd data && unzip puyopuy2.zip && rm puyopuy2.zip
	bsplit c data/epr-17241.ic32 data/epr-17240.ic31 prg.orig

prg.o: prg.orig
	$(AS) $(SRC) $(ASFLAGS) -o prg.o

prg.bin: prg.o
	$(P2BIN) $< prg.bin -r \$$-0xFFFFF
	rm prg.o

puyopuy2: prg.bin
	mkdir -p out
	$(BSPLIT) s prg.bin out/epr-17241.ic32 out/epr-17240.ic31
	cp data/epr-17239.ic4 out/

test: puyopuy2
	mkdir -p puyopuy2
	cp out/* puyopuy2
	$(MAME) -rompath $(shell pwd) -debug puyopuy2

clean:
	@-rm -f prg.bin
	@-rm -f prg.o
