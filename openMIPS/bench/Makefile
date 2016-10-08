
ifndef CROSS_COMPILE
CROSS_COMPILE = mips-sde-elf-
endif

export CROSS_COMPILE

CC = $(CROSS_COMPILE)as
LD = $(CROSS_COMPILE)ld
OBJCOPY = $(CROSS_COMPILE)objcopy
OBJDUMP = $(CROSS_COMPILE)objdump

OBJECTS = inst_rom.o

all: inst_rom.data

%.o: %.S
	$(CC) -mips32 $< -o $@

inst_rom.data: inst_rom.bin bin2mem
	./bin2mem $<

inst_rom.bin: inst_rom.om
	$(OBJCOPY) -O binary $< $@

inst_rom.om: ram.ld $(OBJECTS)
	$(LD) -T ram.ld $(OBJECTS) -o $@

bin2mem: bin2mem.c
	cc -o bin2mem -Wall bin2mem.c

clean:
	rm -f *.o *.om *.bin *.data

