ENTRY(start)

SECTIONS
{
    /* Leave 1 MB space for disk partition info, by convention */
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
