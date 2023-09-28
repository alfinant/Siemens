AREA   STARTUPCODE, CODE
code32

	ldr r0, =0x12345678
	ldr r1, =0x89abcdef
	ldr r1, =0xA8000000
      str r0, [r1, #0x00]
	bx lr

END

