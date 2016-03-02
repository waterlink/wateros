.PHONY: clean

all: wateros.iso

multiboot_header.o: multiboot_header.asm
	nasm -f elf64 multiboot_header.asm

boot.o: boot.asm
	nasm -f elf64 boot.asm

kernel.bin: boot.o multiboot_header.o linker.ld
	ld --nmagic --output=kernel.bin --script=linker.ld multiboot_header.o boot.o

isofiles/boot/grub/grub.cfg: grub.cfg
	mkdir -p isofiles/boot/grub/
	cp grub.cfg isofiles/boot/grub/

isofiles/boot/kernel.bin: kernel.bin
	mkdir -p isofiles/boot
	cp kernel.bin isofiles/boot/

wateros.iso: isofiles/boot/kernel.bin isofiles/boot/grub/grub.cfg
	grub-mkrescue -o wateros.iso isofiles

clean:
	rm *.o *.bin *.iso
	rm -r isofiles

run: wateros.iso
	qemu-system-x86_64 -cdrom wateros.iso
