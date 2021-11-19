c_source_files := $(shell find src/utilities -name *.c)
c_object_files := $(patsubst src/utilities/%.c, build/utilities/%.o, $(c_source_files))

kernel_source_files := $(shell find src/kernel -name *.c)
kernel_object_files := $(patsubst src/kernel/%.c, build/kernel/%.o, $(kernel_source_files))

asm_source_files := $(shell find src -name *.asm)
asm_object_files := $(patsubst src/%.asm, build/%.o, $(asm_source_files))

object_files := $(c_object_files) $(kernel_object_files) $(asm_object_files)

.PHONY: all build-bin build-iso clean

all: | build-iso

$(c_object_files): build/utilities/%.o : src/utilities/%.c
	mkdir -p $(dir $@)
	gcc -c -I src/includes -ffreestanding $(patsubst build/utilities/%.o, src/utilities/%.c, $@) -o $@

$(kernel_object_files): build/kernel/%.o : src/kernel/%.c
	mkdir -p $(dir $@)
	gcc -c -I src/includes -ffreestanding $(patsubst build/kernel/%.o, src/kernel/%.c, $@) -o $@

$(asm_object_files): build/%.o : src/%.asm
	mkdir -p $(dir $@)
	nasm -f elf64 $(patsubst build/%.o, src/%.asm, $@) -o $@

build-bin: $(object_files)
	mkdir -p dist
	ld -n -o dist/BonelessOS.bin -T src/linker.ld $(object_files)

build-iso: build-bin
	mkdir -p build/boot/grub
	cp dist/BonelessOS.bin build/boot/BonelessOS.bin
	cp src/grub.cfg build/boot/grub/grub.cfg
	grub-mkrescue /usr/lib/grub/i386-pc -o dist/BonelessOS.iso build

clean:
	rm -rf build dist
