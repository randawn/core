MEMORY { ram : ORIGIN = 0x00000000, LENGTH = 0x00001000 }
ENTRY(_start)

SECTIONS
{
  .text     : { *(.text) } > ram
  .data     : { *(.data) } > ram
  .bss      : { *(.bss) } > ram
}

