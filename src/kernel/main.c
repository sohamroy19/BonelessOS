#include "print.h"

void kernel_main() {
    print_clrscr();
    print_set_color(PRINT_COLOR_LIGHT_GREEN, PRINT_COLOR_BLACK);

    print_str("Hello! This is a fully functional kernel.\n");
}
