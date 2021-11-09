asm_source_files := $(shell find src -name *.asm)
asm_object_files := $(patsubst src/%.asm, build/%.o, $(asm_source_files))

.PHONY: all build-bin build-iso clean

all: | build-iso

$(asm_object_files): build/%.o : src/%.asm
	mkdir -p $(dir $@) && \
	nasm -f elf64 $(patsubst build/%.o, src/%.asm, $@) -o $@

build-bin: $(asm_object_files)
	mkdir -p dist && \
	ld -n -o dist/kernel.bin -T src/linker.ld $(asm_object_files)

build-iso: build-bin
	mkdir -p build/boot/grub && \
	cp dist/kernel.bin build/boot/kernel.bin && \
	cp src/grub.cfg build/boot/grub/grub.cfg && \
	grub-mkrescue /usr/lib/grub/i386-pc -o dist/kernel.iso build

clean:
	rm -rf build dist
