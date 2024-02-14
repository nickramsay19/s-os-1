# os

## Usage
### Requirements
* `mkisofs` - install `cdrkit` on arch linux
* `nasm`

## Global Descriptor Table (GDT)
| Bits | Name        | Description                          |
| ---- | ----------- | ------------------------------------ |
| 1    | Present     | Set to 1 for used segments           |
| 2    | Privelage   | 00 is highest privelage down to 11   |
| 1    | Type        | 1 if segment is code or data segment |
| 4    | Type Flags  | See below                            |
| 4    | Other Flags | See below                            |

### Type Flags
| Flag Position | Name                     | Description                                                     |
| ------------- | ------------------------ | --------------------------------------------------------------- |
| 1xxx          | Executable/Code          | Whether this is a code segment                                  |
| x1xx          | Conforming or Direction  | See below                                                       | 
| xx1x          | Readable or Writable     | See below                                                       | 
| xxx1          | Accessed                 | Set by the CPU when the segment is being used                   |

If the executable flag was set then, the second and third flags are:

| Flag Position | Name        | Description                                                     |
| ------------- | ----------- | --------------------------------------------------------------- |
| x1xx          | Conforming  | Whether this code can be executed from lower privelage segments |
| xx1x          | Readable    | Whether this segment is readable                                |

Otherwise, for data segments, the middle two flags are instead:

| Flag Position | Name        | Description                                                     |
| ------------- | ----------- | --------------------------------------------------------------- |
| x1xx          | Direction   | Whether this code can be executed from lower privelage segments |
| xx1x          | Writeable   | Whether this segment is writeable                               |

### Other Flags
| Flag Position | Name        | Description                                                     |
| ------------- | ----------- | ------------------------------------------- |
| 1xxx          | Granularity | When set, `limit *= 0x1000`                 |
| x1xx          | 32 Bit      | Whether this segment will use 32 bit memory |
| xx1x          | 64 Bit      | Whether this segment will use 64 bit memory |
| xxx1          | AVL         |                                             |
