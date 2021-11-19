# BonelessOS
My first OS! A barebones OS named BonelessOS. Can display any text on the terminal, currently.  

Resources referred:
- [CodePulse](https://www.youtube.com/channel/UCUVahoidFA7F3Asfvamrm7w) YouTube [series](https://www.youtube.com/watch?v=FkrpUaGThTQ)
- https://github.com/cfenollosa/os-tutorial
<br>

## Requirements
Building requires a Linix system with `nasm` and some `grub` tools:  
- Linux: `sudo apt install nasm grub-pc-bin grub-common xorriso`
<br>

The `.iso` can be emulated using `qemu`, for example.  
- Linux: `sudo apt install qemu-system`  
- MacOS: `brew install qemu`  
- Windows: https://www.qemu.org/download/#windows
<br>

## Instructions  
Building requires Linux:
```
make
```
<br>

The `.iso` can be emulated on any OS:
```
qemu-system-x86_64 -cdrom dist/kernel.iso
```
<br>
<br>
  
TODO:
- [x] Write a proper `README.md`
- [x] Implement long mode
- [x] Add C interfacing
