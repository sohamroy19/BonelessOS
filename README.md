# BonelessOS
My first OS! A barebones OS name BonelessOS, simply displays "OK" over the BIOS splash screen currently.

## Requirements
- Building requires a linux system with `nasm`.
- Run `make` or `make all`.
- `dist/kernel.iso` can now be emulated using `qemu`, for example.

## Instructions  
`sudo apt-get install nasm qemu-system`  
`make`  
`qemu-system-x86_64 -cdrom dist/kernel.iso`  
<br>
  
TODO:
- [x] Write a proper `README.md`
- [ ] Implement proper kernel
