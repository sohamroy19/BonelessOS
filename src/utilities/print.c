#include "print.h"

#define TOTAL_ROWS 25
#define TOTAL_COLS 80

size_t cursor_row = 0, cursor_col = 0; // initialise cursor position

/* a colored character type */
typedef struct colored_char {
    uint8_t character;
    uint8_t color;
} colored_char;

colored_char *buffer = (colored_char *)0xb8000;             // start of video memory
uint8_t color = PRINT_COLOR_BLACK << 4 | PRINT_COLOR_WHITE; // default colors

/* clear a whole row */
void clear_row(size_t row) {
    colored_char space = {' ', color};

    for (size_t col = 0; col < TOTAL_COLS; ++col) {
        buffer[row * TOTAL_COLS + col] = space;
    }
}

/* clear the whole screen */
void print_clrscr() {
    for (size_t i_row = 0; i_row < TOTAL_ROWS; ++i_row) {
        clear_row(i_row);
    }
}

/* print a newline character */
void print_newline() {
    cursor_col = 0;

    if (cursor_row < TOTAL_ROWS - 1) {
        ++cursor_row; // simply move to the next row, if possible
        return;
    }

    // shift screen up by a line, if cursor is at last row
    for (size_t row = 0; row < TOTAL_ROWS - 1; ++row) {
        for (size_t col = 0; col < TOTAL_COLS; ++col) {
            buffer[row * TOTAL_COLS + col] = buffer[(row + 1) * TOTAL_COLS + col];
        }
    }

    clear_row(TOTAL_ROWS - 1); // clear last row
}

/* print a character */
void print_char(char c) {
    if (c == '\n') {
        print_newline();
        return;
    }

    if (cursor_col > TOTAL_COLS) {
        print_newline(); // move to next row if cursor is at last column
    }

    buffer[cursor_row * TOTAL_COLS + cursor_col] = (colored_char){(uint8_t)c, color};
    ++cursor_col;
}

/* print a string */
void print_str(char *str) {
    while (*str) {
        print_char(*str);
        ++str;
    }
}

/* set the color */
void print_set_color(uint8_t fg_color, uint8_t bg_color) {
    color = bg_color << 4 | fg_color;
}
