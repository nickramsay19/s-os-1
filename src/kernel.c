#include "memory.h"
#include "video.h"
#include "int.h"

#define VIDEO_ADDRESS 0xb8000
#define MAX_ROWS 25
#define MAX_COLS 80
#define WHITE_ON_BLACK 0x0f

void set_char_at_video_memory(int8_t character, uint32_t offset) {
    uint8_t *v_mem = (uint8_t*) COLOR_VIDEO_HEAD;
    v_mem[offset] = character;
    v_mem[offset + 1] = WHITE_ON_BLACK;
}

uint32_t get_row_from_offset(uint32_t offset) {
    return offset / (2 * MAX_COLS);
}

uint32_t get_offset(uint32_t col, uint32_t row) {
    return 2 * (row * MAX_COLS + col);
}

uint32_t move_offset_to_new_line(uint32_t offset) {
    return get_offset(0, get_row_from_offset(offset) + 1);
}

/*void print_string(char *string) {
    uint32_t offset = get_cursor();
    uint32_t i = 0;
    while (string[i] != 0) {
        if (string[i] == '\n') {
            offset = move_offset_to_new_line(offset);
        } else {
            set_char_at_video_memory(string[i], offset);
            offset += 2;
        }
        ++i;
    }
    set_cursor(offset);
}*/


void memory_copy(char *source, char *dest, int nbytes) {
    int i;
    for (i = 0; i < nbytes; i++) {
        *(dest + i) = *(source + i);
    }
}


int scroll_ln(int offset) {
    memory_copy(
            (char *) (get_offset(0, 1) + VIDEO_ADDRESS),
            (char *) (get_offset(0, 0) + VIDEO_ADDRESS),
            MAX_COLS * (MAX_ROWS - 1) * 2
    );

    int col;
    for (col = 0; col < MAX_COLS; col++) {
        set_char_at_video_memory(' ', get_offset(col, MAX_ROWS - 1));
    }

    return offset - 2 * MAX_COLS;
}

void print_string(char* string) {
    int offset = get_cursor();
    int i = 0;
    while (string[i] != 0) {
        if (offset >= MAX_ROWS * MAX_COLS * 2) {
            offset = scroll_ln(offset);
        }
        if (string[i] == '\n') {
            offset = move_offset_to_new_line(offset);
        } else {
            set_char_at_video_memory(string[i], offset);
            offset += 2;
        }
        i++;
    }
    set_cursor(offset);
}

void clear_screen() {
    uint32_t i;
    for (i = 0; i < MAX_COLS * MAX_ROWS; ++i) {
        set_char_at_video_memory(' ', i * 2);
    }
    set_cursor(get_offset(0, 0));
}

void main() {

    clear_screen();
    print_string("Hello World!\n");

    char* const video_head = COLOR_VIDEO_HEAD;
    char* const video_tail = COLOR_VIDEO_HEAD + COLOR_VIDEO_SIZE;

    char* const mono_video_head = MONOCHROME_VIDEO_HEAD;
    char* const mono_video_tail = MONOCHROME_VIDEO_HEAD + MONOCHROME_VIDEO_SIZE;

    char* p;
    for (p = video_head; p < video_tail; ++p) {
        *p = (((uint32_t) p) % 26) + 'a'; 
    }

    for (p = video_head; p < 100; ++p) {
        *p = (((uint32_t) p) % 26) + 'a'; 
    }

    return;
}
