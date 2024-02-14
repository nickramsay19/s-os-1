;;; gdt_start and gdt_end labels are used to compute size

; null segment descriptor
gdt_start:
    dq 0x0

; code segment descriptor
gdt_code:
    dw 0xffff    ; segment length, bits 0-15
    dw 0x0       ; segment base, bits 0-15
    db 0x0       ; segment base, bits 16-23
    db 10011010b ; flags (8 bits)
    db 11001111b ; flags (4 bits) + segment length, bits 16-19
    db 0x0       ; segment base, bits 24-31

; data segment descriptor
gdt_data:
    dw 0xffff    ; segment length, bits 0-15
    dw 0x0       ; segment base, bits 0-15
    db 0x0       ; segment base, bits 16-23
    db 10010010b ; flags (8 bits)
    db 11001111b ; flags (4 bits) + segment length, bits 16-19
    db 0x0       ; segment base, bits 24-31

gdt_end:

; GDT descriptor
gdt_descriptor:
    dw gdt_end - gdt_start - 1 ; size (16 bit)
    dd gdt_start ; address (32 bit)

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

; ======= MY VERSION =======
;; determine the relative positions of the code and data descriptor positions
;code_seg equ gdt_code - gdt_start
;data_seg equ gdt_data - gdt_start
;
;; ...
;
;; Global Descriptor Table (GDT)
;; must be at the end of real mode code
;[bits 16]
;gdt_start:                  ; define each memory segment descriptor
;    gdt_null:               ; a null descriptor must be present, it will never be read
;        dd 0x0
;        dd 0x0
;
;    ;gdt_code:                       
;    ;    dw 0xffff           ; limit (first two bytes)
;    ;    dw 0x0              ; base (first two bytes)
;    ;    db 0x0              ; base (third byte)
;    ;    db 0b1001           ; present(0b1), privelage(0b00), type(0b1)
;    ;    db 0b1010          ; type flags: code(1), conforming(0), readable(1), accessed(0)
;    ;    db 0b1100          ; other flags: granularity(1), 32 bit(1), 64 bit(0), avl(0)
;    ;    db 0x0              ; last 8 bits of the base
;
;    gdt_code:                       
;        dw 0xffff                   ; limit
;        dw 0x0                      ; present, privelage, type
;        db 0x0
;        db 0b10011010
;        db 0b11001111
;        db 0x0
;
;    gdt_data:
;        dw 0xffff
;        dw 0x0
;        db 0x0
;        db 0b10010010
;        db 0b11001111
;        db 0x0
;
;gdt_end:
;
;; size and position of gdt
;[bits 16]
;gdt_descriptor:
;    dw gdt_end - gdt_start - 1
;    dd gdt_start
; ====================
