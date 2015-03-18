.SILENT:

all: fdisk clean

fdisk:
	as loader.s -o loader.o
	ld -o loader.bin -Ttext 0x0 -e main loader.o --oformat binary
	dd if=loader.bin of=livefdisk.img
	as main.s -o main.o
	ld -o main.bin -Ttext 0x0 -e main main.o --oformat binary
	dd if=main.bin bs=512 seek=1 of=livefdisk.img

clean:
	rm -r main.o main.bin loader.o loader.bin
