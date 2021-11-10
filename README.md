# BonelessOS
My first OS! A barebones OS name BonelessOS, simply displays "OK" over the BIOS splash screen currently.  

Resources referred:
- [CodePulse](https://www.youtube.com/channel/UCUVahoidFA7F3Asfvamrm7w) YouTube [series](https://www.youtube.com/watch?v=FkrpUaGThTQ)
- https://github.com/cfenollosa/os-tutorial
<br>

## Requirements
- Building requires a linux system with `nasm` and `xorriso`.
- Run `make` or `make all`.
- `dist/kernel.iso` can now be emulated using `qemu`, for example.
<br>

## Instructions  
`sudo apt-get install nasm xorriso qemu-system`  
`make`  
`qemu-system-x86_64 -cdrom dist/kernel.iso`  
<br>
<br>
  
TODO:
- [x] Write a proper `README.md`
- [ ] Implement proper kernel
