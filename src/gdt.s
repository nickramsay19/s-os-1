; ==== Global Descriptor Table (GDT) ====
[bits 16]
gdt_start:
; == DESCRIPTOR ENTRIES ==
; | Bits | Name        | Description                          |
; | ---- | ----------- | ------------------------------------ |
; | 1    | Present     | Set to 1 for used segments           |
; | 2    | Privelage   | 00 is highest privelage down to 11   |
; | 1    | Type        | 1 if segment is code or data segment |
; | 4    | Type Flags  | See below                            |
; | 4    | Other Flags | See below                            |

; == TYPE FLAGS ==
; | Flag Position | Name                     | Description                                                     |
; | ------------- | ------------------------ | --------------------------------------------------------------- |
; | 1xxx          | Executable/Code          | Whether this is a code segment                                  |
; | x1xx          | Conforming or Direction  | See below                                                       | 
; | xx1x          | Readable or Writable     | See below                                                       | 
; | xxx1          | Accessed                 | Set by the CPU when the segment is being used                   |
; == OTHER FLAGS ==
; | Flag Position | Name        | Description                                                     |
; | ------------- | ----------- | ------------------------------------------- |
; | 1xxx          | Granularity | When set, `limit *= 0x1000`                 |
; | x1xx          | 32 Bit      | Whether this segment will use 32 bit memory |
; | xx1x          | 64 Bit      | Whether this segment will use 64 bit memory |
; | xxx1          | AVL         |                                             |
    gdt_null:                   ; a null descriptor must be present, it will never be read
        dd 0x0
        dd 0x0

; == CODE SEGMENT TYPE FLAGS ==
; | Flag Position | Name        | Description                                                     |
; | ------------- | ----------- | --------------------------------------------------------------- |
; | x1xx          | Conforming  | Whether this code can be executed from lower privelage segments |
; | xx1x          | Readable    | Whether this segment is readable                                |

    gdt_code:                   ; code segment descriptor entry  
        dw 0xffff               ; limit (first two bytes)
        dw 0x0                  ; base (first two bytes)
        db 0x0                  ; base (third byte)
        db 10011010b            ; present(0b1), privelage(0b00), type(0b1), type flags
                                ; type flags: code(1), conforming(0), readable(1), accessed(0)
        db 11001111b            ; other flags: granularity(1), 32 bit(1), 64 bit(0), avl(0) 
                                ; last 4 bits of segment length
        db 0x0                  ; last 8 bits of the base

; == DATA SEGMENT TYPE FLAGS ==
; | Flag Position | Name        | Description                                                     |
; | ------------- | ----------- | --------------------------------------------------------------- |
; | x1xx          | Direction   | Whether this code can be executed from lower privelage segments |
; | xx1x          | Writeable   | Whether this segment is writeable                               |
    gdt_data:                   ; data segment descriptor entry
        dw 0xffff
        dw 0x0
        db 0x0
        db 10010010b            ; present(1b), privelage(00b), type(1b), type flags
        db 11001111b
        db 0x0

gdt_end:

[bits 16]
gdt_descriptor:                 ; size and position of gdt
    dw gdt_end - gdt_start - 1  ; size (16 bit)
    dd gdt_start                ; address (32 bit)

; determine the relative positions of the code and data descriptor positions
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start
