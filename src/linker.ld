ENTRY(start)

SECTIONS
{
    /* start everything after 1 MB, by convention */
    . = 1M;

    .boot : /* boot section */
    {
        KEEP(*(.multiboot_header))
    }

    .text : /* code section */
    {
        *(.text)
    }
}