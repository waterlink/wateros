all: wateros.iso

multiboot_header.o: multiboot_header.asm
	nasm -f elf64 multiboot_header.asm

boot.o: boot.asm
	nasm -f elf64 boot.asm

kernel.bin: boot.o multiboot_header.o linker.ld
	ld --nmagic --output=kernel.bin --script=linker.ld multiboot_header.o boot.o

isofiles/boot/kernel.bin: kernel.bin
	cp kernel.bin isofiles/boot/

wateros.iso: isofiles/boot/kernel.bin isofiles/boot/grub/grub.cfg
	grub-mkrescue -o wateros.iso isofiles
