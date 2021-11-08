asm_source_files := $(shell find src -name *.asm)
asm_object_files := $(patsubst src/%.asm, build/%.o, $(asm_source_files))

.PHONY: all
all: | build-iso

$(asm_object_files): build/%.o : src/%.asm
	mkdir -p $(dir $@) && \
	nasm -f elf64 $(patsubst build/%.o, src/%.asm, $@) -o $@

.PHONY: build-bin
build-bin: $(asm_object_files)
	mkdir -p dist && \
	ld -n -o dist/kernel.bin -T src/linker.ld $(asm_object_files)

.PHONY: build-iso
build-iso: build-bin
	mkdir -p build/boot/grub && \
	cp dist/kernel.bin build/boot/kernel.bin && \
	cp src/grub.cfg build/boot/grub/grub.cfg && \
	grub-mkrescue /usr/lib/grub/i386-pc -o dist/kernel.iso build

.PHONY: clean
clean:
	rm -rf build dist