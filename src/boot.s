.org 0x7c00

.equ KERNEL_OFFSET, 0x1000

.section .text
.globl _start
_start:

    // BIOS sets boot drive in 'dl'; store for later use
    lea BOOT_DRIVE, %dl

    // setup stack
    movw $0x9000, %bp
    movw %bp, %sp

    call load_kernel

    cli
    lgdt gdt_descriptor

    movq %cr0, eax
