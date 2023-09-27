STARTUP(freeloader.o)
ENTRY(freeloader_entry)

MEMORY
{
    ram : ORIGIN = 0x20000, LENGTH = 0x100000
}

SECTIONS
{
    .debug_aranges 0 : { *(.debug_aranges) } 
    .debug_pubnames 0 : { *(.debug_pubnames) } 
    .debug_info 0 : { *(.debug_info) } 
    .debug_abbrev 0 : { *(.debug_abbrev) } 
    .debug_line 0 : { *(.debug_line) } 
    .debug_frame 0 : { *(.debug_frame) } 
    .debug_str 0 : { *(.debug_str) } 
    .debug_loc 0 : { *(.debug_loc) } 
    .debug_macinfo 0 : { *(.debug_macinfo) } 
    .note.arm.ident 0 : { KEEP (*(.note.arm.ident)) }

    .rom_vectors 0x20000 : { 
    		 __rom_vectors_vma = ABSOLUTE(.);
		 . = .; 
		 KEEP (*(.vectors)) } > ram
     __rom_vectors_lma = LOADADDR(.rom_vectors);

    .freeloader_entry 0x21020 : { init.o . = .; KEEP (*(.freeloader_entry)) } > ram

    .rel.text : { *(.rel.text) *(.rel.text.*) *(.rel.gnu.linkonce.t*) } > ram
    .rela.text : { *(.rela.text) *(.rela.text.*) *(.rela.gnu.linkonce.t*) } > ram
    .rel.data : { *(.rel.data) *(.rel.data.*) *(.rel.gnu.linkonce.d*) } > ram
    .rela.data : { *(.rela.data) *(.rela.data.*) *(.rela.gnu.linkonce.d*) } > ram
    .rel.rodata : { *(.rel.rodata) *(.rel.rodata.*) *(.rel.gnu.linkonce.r*) } > ram
    .rela.rodata : { *(.rela.rodata) *(.rela.rodata.*) *(.rela.gnu.linkonce.r*) } > ram
    .rel.got : { *(.rel.got) } > ram .rela.got : { *(.rela.got) } > ram
    .rel.ctors : { *(.rel.ctors) } > ram .rela.ctors : { *(.rela.ctors) } > ram
    .rel.dtors : { *(.rel.dtors) } > ram .rela.dtors : { *(.rela.dtors) } > ram
    .rel.init : { *(.rel.init) } > ram .rela.init : { *(.rela.init) } > ram
    .rel.fini : { *(.rel.fini) } > ram .rela.fini : { *(.rela.fini) } > ram
    .rel.bss : { *(.rel.bss) } > ram .rela.bss : { *(.rela.bss) } > ram
    .rel.plt : { *(.rel.plt) } > ram .rela.plt : { *(.rela.plt) } > ram
    .rel.dyn : { *(.rel.dyn) } > ram
   
    .text ALIGN (0x4) : {
		 _stext = ABSOLUTE(.); 
		PROVIDE (__stext = ABSOLUTE(.)); 
		*(.text*) *(.gnu.warning) *(.gnu.linkonce.t.*) *(.init) *(.glue_7) *(.glue_7t) 
		} > ram

     _etext = .; PROVIDE (__etext = .);

    .fini ALIGN (0x4) : { . = .; *(.fini) } > ram
    .rodata ALIGN (0x4) : { . = .; *(.rodata*) *(.gnu.linkonce.r.*) } > ram
    .rodata1 ALIGN (0x4) : { . = .; *(.rodata1) } > ram

    .got ALIGN (0x4) : { . = .; *(.got.plt) *(.got) _GOT1_START_ = ABSOLUTE (.); *(.got1) _GOT1_END_ = ABSOLUTE (.); _GOT2_START_ = ABSOLUTE (.); *(.got2) _GOT2_END_ = ABSOLUTE (.); } > ram

    .fixup ALIGN (0x4) : { . = .; *(.fixup) } > ram

    .gcc_except_table ALIGN (0x4) : { . = .; KEEP(*(.gcc_except_table)) *(.gcc_except_table.*) } > ram

    .eh_frame ALIGN (0x04) : { . = .; __EH_FRAME_BEGIN__ = .; KEEP(*(.eh_frame)) __FRAME_END__ = .; . = . + 8; } > ram = 0

    .data ALIGN (0x4) : {
     __ram_data_start = ABSOLUTE (.); 
     *(.data*) *(.data1) *(.gnu.linkonce.d.*) . = ALIGN (4); 
     KEEP(*( SORT (.ecos.table.*)));
      . = ALIGN (4); 
      __CTOR_LIST__ = ABSOLUTE (.); 
      KEEP (*(SORT (.ctors*))) __CTOR_END__ = ABSOLUTE (.); 
      __DTOR_LIST__ = ABSOLUTE (.); 
      KEEP (*(SORT (.dtors*))) __DTOR_END__ = ABSOLUTE (.); 
      *(.dynamic) *(.sdata*) *(.gnu.linkonce.s.*) . = ALIGN (4);
       *(.2ram.*) } > ram __rom_data_start = LOADADDR (.data);
        __ram_data_end = .; 
	PROVIDE (__ram_data_end = .); 
	_edata = .; 
	PROVIDE (edata = .); 
	PROVIDE (__rom_data_end = LOADADDR (.data) + SIZEOF(.data));

	.bss ALIGN (0x4) : { 
	__bss_start = ABSOLUTE (.); 
	*(.scommon) *(.dynsbss) *(.sbss*) *(.gnu.linkonce.sb.*) *(.dynbss) *(.bss*) *(.gnu.linkonce.b.*) *(COMMON) __bss_end = ABSOLUTE (.); } > ram

    __heap1 = ALIGN (0x8);

    . = ALIGN(4); _end = .; PROVIDE (end = .);
}
