.PHONY: clean

default: run

build/:
	mkdir -p build

build/isofiles/boot/:
	mkdir -p build/isofiles/boot

build/isofiles/boot/grub/:
	mkdir -p build/isofiles/boot/grub

build/multiboot_header.o: multiboot_header.asm build/
	nasm -f elf64 multiboot_header.asm -o build/multiboot_header.o

build/boot.o: boot.asm build/
	nasm -f elf64 boot.asm -o build/boot.o

build/kernel.bin: build/boot.o build/multiboot_header.o linker.ld build/
	ld --nmagic --output=build/kernel.bin --script=linker.ld build/multiboot_header.o build/boot.o

build/isofiles/boot/grub/grub.cfg: grub.cfg build/isofiles/boot/grub/
	cp grub.cfg build/isofiles/boot/grub/

build/isofiles/boot/kernel.bin: build/kernel.bin build/isofiles/boot/
	cp build/kernel.bin build/isofiles/boot/

build/wateros.iso: build/isofiles/boot/kernel.bin build/isofiles/boot/grub/grub.cfg
	grub-mkrescue -o build/wateros.iso build/isofiles

clean:
	rm -r build

run: build/wateros.iso
	qemu-system-x86_64 -cdrom build/wateros.iso
