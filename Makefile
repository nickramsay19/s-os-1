CC := gcc
CFLAGS := -ansi -m32 -ffreestanding -fno-pic
#AS := nasm
AS := as
ASFLAGS := 
LD := ld
LDFLAGS :=

all: dist/image.iso

dist/image.iso: dist/image.img
	@mkdir -p dist
	mkisofs -V 'someOS' -input-charset iso8859-1 -o $@ -b image.img -hide image.img dist/

dist/image.img: bin/image.bin
	@mkdir -p dist
	dd if='/dev/zero' of=$@ bs=1024 count=1440
	dd if=$^ of=$@ seek=0 count=1 conv=notrunc
	#qemu-img dd -f FMT -O qcow2 if=$^ of=$@
	#qemu-img dd -O qcow2 if=$^ of=$@

bin/image.bin: bin/boot.bin bin/kernel.bin
	cat $^ > $@

bin/boot.bin: src/boot.s
	@mkdir -p bin
	#$(AS) $(ASFLAGS) -f bin -I 'src/' -o $@ $^
	$(AS) $(ASFLAGS) -I 'src/' -o $@ $^
	#as -o $@ -c $^

bin/kernel.bin: build/kernel_entry.o build/kernel.o
	@mkdir -p bin
	$(LD) -m elf_i386 -o $@ -Ttext 0x1000 $^ --oformat binary

build/kernel_entry.o: src/kernel_entry.s
	@mkdir -p build
	#$(AS) $(ASFLAGS) $< -f elf -o $@
	$(AS) $(ASFLAGS) $< -o $@

build/kernel.o: src/kernel.c
	@mkdir -p build
	$(CC) $(CFLAGS) -c $< -o $@

.PHONY: run
run: bin/image.bin
	qemu-system-x86_64 -fda $^

.PHONY: clean
clean:
	#rm -f build/main.bin
	#rm -fd build
	#rm -f dist/main.iso
	#rm -f dist/main.img
	#rm -fd dist
	rm -rf dist bin build
