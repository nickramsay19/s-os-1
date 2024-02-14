[bits 16]
[org 0x7c00]

; where to load the kernel to
KERNEL_OFFSET equ 0x1000

; BIOS sets boot drive in 'dl'; store for later use
mov [BOOT_DRIVE], dl

; setup stack
mov bp, 0x9000
mov sp, bp

; load kernel
mov bx, KERNEL_OFFSET ; bx -> destination
mov dh, 2             ; dh -> num sectors
mov dl, [BOOT_DRIVE]  ; dl -> disk
call disk_load

;call switch_to_32bit
; switch to 32 bit
cli                     ; 1. disable interrupts
lgdt [gdt_descriptor]   ; 2. load GDT descriptor
mov eax, cr0
or eax, 0x1             ; 3. enable protected mode
mov cr0, eax
;jmp CODE_SEG:init_32bit ; 4. far jump

; init 32 bit
mov ax, DATA_SEG        ; 5. update segment registers
mov ds, ax
mov ss, ax
mov es, ax
mov fs, ax
mov gs, ax

mov ebp, 0x90000        ; 6. setup stack
mov esp, ebp

; begin 32 bit
call KERNEL_OFFSET ; give control to the kernel
jmp $ ; loop in case kernel returns

%include "disk.s"
%include "gdt.s"

; boot drive variable
BOOT_DRIVE db 0

; padding
times 510 - ($-$$) db 0

; magic number
dw 0xaa55
