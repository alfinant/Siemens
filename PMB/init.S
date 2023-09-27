#define ASM_FUNC_NAME(_name_) \
	.globl _name_ ; _name_:

/*
 * This code disables the MMU, invalidates the I & D caches,
 * and drains the write buffers
 */	
ASM_FUNC_NAME(freeloader_entry)
	mrs     r1, cpsr		/* R1 = CPSR */
	bic     r1, r1, #0x1F		/* R1 &= ~0x1F (11111) */
	orr     r1, r1, #0xD3		/* R1 |= 0xD3  (11010011) */
	msr     cpsr_cf, r1		/* CPSR = R1 */
	ldr     r0, =0x50078		/* R0 = 0x50078      F    B    7    3 */
	mcr     p15, 0, r0, c1, c0	/* Sets MMU to (0101 0000 0000 0111 1000) */
	mov     r1, #0			/* R1 = 0          3    7    B    F */
	mcr     p15, 0, R1, c7, c5	/* Invalidate I cache */
	mcr     p15, 0, R1, c7, c6	/* Invalidate D cache */
	mcr     p15, 0, R1, c7, c10, 4	/* Drain write buffer */
	mov     r1, #0xF0000000		/* R1 = 0xF0000000 */
	ldr     r0, =0x400700		/* R0 = *0x400700 */
	str     r0, [r1, #0xC0]		/* *(R1 + 0xC0) = R0 */
	ldr     r0, =0x81F84911		/* R0 = *0x81F84911 */
	str     r0, [r1, #0x100]	/* *(R1 + 0x100) = R0 */
	ldr     r0, =0xB0000051		/* R0 = *0xB0000051 */
	str     r0, [r1, #0x88]		/* *(R1 + 0x88) = R0 */
	ldr     r0, =0x402700		/* R0 = *0x402700 */
	str     r0, [r1, #0xC8]		/* *(R1 + 0xC8) = R0 */
	ldr     r0, =0x80904911		/* R0 = *0x80904911 */
	str     r0, [r1, #0x108]	/* *(R1 + 0x108) = R0 */
	bl      peripheral_config	/* Peripheral bus config */
	bl      init_assigned_vars	/* Initialize vars and tables */
	bl	freeloader_main		/* Call the C main */
	
.section .text

ASM_FUNC_NAME(peripheral_config)
        ldr     r1, =0xF6400000
        mov     r0, #0x114
        str     r0, [r1]
        mov     r0, #0x100
        mov     r1, #0xF6000000
        str     r0, [r1]
        add     r1, r1, #0x300000
        str     r0, [r1]
        mov     r1, #0xF4000000
        str     r0, [r1]
        orr     r1, r1, r0, lsl#12
        str     r0, [r1]
        add     r1, r1, #0x3000000
        str     r0, [r1]
        mov     r1, #0xF0000000
        str     r0, [r1]
        add     r1, r1, #0x6200000
        str     r0, [r1]
        sub     r1, r1, #0x1900000
        str     r0, [r1]
        add     r1, r1, r0, lsl#12
        str     r0, [r1]
        add     r1, r1, #0x2C00000
        str     r0, [r1]
        sub     r1, r1, #0x2A00000
        str     r0, [r1]
        sub     r1, r1, #0x900000
        str     r0, [r1]
        add     r1, r1, #0xFD000000
        str     r0, [r1]
        ldr     r2, =0xF1100000
        orr     r1, r0, r0, asr#8
        str     r1, [r2]
        add     r2, r2, #0x3A00000
        str     r0, [r2]
        mov     r0, #0xF1000000
        str     r1, [r0]
        add     r0, r0, #0x800000
        str     r1, [r0]
        mov     r0, #0x208
        sub     r1, r2, #0x700000
        str     r0, [r1]
        orr     r0, r1, r0, lsl#17
        ldr     r1, [r0, #0xA8]
        bic     r1, r1, #0x700000
        str     r1, [r0, #0xA8]
        ldr     r1, [r0, #0xA8]
        bic     r1, r1, #3
        str     r1, [r0, #0xA8]
        ldr     r1, [r0, #0xA8]
        bic     r1, r1, #0x3000000
        str     r1, [r0, #0xA8]
        ldr     r1, [r0, #0xA8]
        bic     r1, r1, #0x30000
        str     r1, [r0, #0xA8]
        ldr     r1, [r0, #0xA0]
        bic     r1, r1, #0x200
        bic     r1, r1, #2
        str     r1, [r0, #0xA0]
        ldr     r1, [r0, #0xA0]
        bic     r1, r1, #0x400
        bic     r1, r1, #4
        str     r1, [r0, #0xA0]
        ldr     r1, [r0, #0xA0]
        bic     r1, r1, #0x800
        bic     r1, r1, #8
        str     r1, [r0, #0xA0]
        ldr     r1, [r0, #0xA0]
        bic     r1, r1, #0x1000
        bic     r1, r1, #0x10
        str     r1, [r0, #0xA0]
        ldr     r1, [r0, #0xA0]
        bic     r1, r1, #0x100
        bic     r1, r1, #1
        str     r1, [r0, #0xA0]
        ldr     r1, [r0, #0xA0]
        bic     r1, r1, #0xF000000
        bic     r1, r1, #0x3F0000
        orr     r1, r1, #0x30000
        str     r1, [r0, #0xA0]
        ldr     r1, [r0, #0xA4]
        bic     r1, r1, #0xFF
        orr     r1, r1, #0xA
        str     r1, [r0, #0xA4]
        ldr     r1, [r0, #0xA4]
        bic     r1, r1, #0xFF00
        orr     r1, r1, #0x800
        str     r1, [r0, #0xA4]
        ldr     r1, [r0, #0xA4]
        bic     r1, r1, #0xFF000000
        orr     r1, r1, #0x11000000
        str     r1, [r0, #0xA4]
        ldr     r1, [r0, #0xA0]
        orr     r1, r1, #0x100
        orr     r1, r1, #1
        str     r1, [r0, #0xA0]
	
1:	
	ldr     r1, [r0, #0xB0]
        tst     r1, #0x2000
        beq     1
	
        ldr     r1, [r0, #0xA0]
        orr     r1, r1, #0x200
        orr     r1, r1, #2
        str     r1, [r0, #0xA0]
        ldr     r1, [r0, #0xA0]
        orr     r1, r1, #0x400
        orr     r1, r1, #4
        str     r1, [r0, #0xA0]
        ldr     r1, [r0, #0xA0]
        orr     r1, r1, #0x1000
        orr     r1, r1, #0x10
        str     r1, [r0, #0xA0]
        ldr     r1, [r0, #0xA8]
        bic     r1, r1, #3
        orr     r1, r1, #2
        str     r1, [r0, #0xA8]
        ldr     r1, [r0, #0xA8]
        bic     r1, r1, #0x30
        orr     r1, r1, #0x10
        str     r1, [r0, #0xA8]
        ldr     r1, [r0, #0xA8]
        bic     r1, r1, #0x3000000
        orr     r1, r1, #0x2000000
        str     r1, [r0, #0xA8]
        ldr     r1, [r0, #0xA8]
        bic     r1, r1, #0x30000000
        orr     r1, r1, #0x10000000
        str     r1, [r0, #0xA8]
        ldr     r1, [r0, #0xA8]
        bic     r1, r1, #0x30000
        str     r1, [r0, #0xA8]
        ldr     r1, [r0, #0xAC]
        bic     r1, r1, #0x300
        orr     r1, r1, #0x100
        str     r1, [r0, #0xAC]
        ldr     r1, [r0, #0xAC]
        bic     r1, r1, #0x70
        orr     r1, r1, #0x20
        str     r1, [r0, #0xAC]
        ldr     r1, =0xF4400044
        ldr     r2, [r1]
        orr     r2, r2, #1
        str     r2, [r1]
        ldr     r1, [r0, #0xA8]
        bic     r1, r1, #0x700000
        orr     r1, r1, #0x400000
        str     r1, [r0, #0xA8]
        ldr     r1, [r0, #0xAC]
        bic     r1, r1, #7
        orr     r1, r1, #3
        str     r1, [r0, #0xAC]
        ldr     r1, [r0, #0xAC]
        bic     r1, r1, #0x30000000
        orr     r1, r1, #0x20000000
        str     r1, [r0, #0xAC]
        ldr     r1, [r0, #0xAC]
        orr     r1, r1, #0x1000000
        str     r1, [r0, #0xAC]
        ldr     r1, [r0, #0xB4]
        bic     r1, r1, #3
        orr     r1, r1, #2
        str     r1, [r0, #0xB4]
        ldr     r1, [r0, #0xB4]
        bic     r1, r1, #1
        str     r1, [r0, #0xB4]
        ldr     r1, [r0, #0xB4]
        bic     r1, r1, #0x300
        orr     r1, r1, #0x200
        str     r1, [r0, #0xB4]
        ldr     r1, [r0, #0xB4]
        bic     r1, r1, #1
        str     r1, [r0, #0xB4]
        ldr     r1, [r0, #0xB4]
        orr     r1, r1, #0x10000
        str     r1, [r0, #0xB4]
        ldr     r1, [r0, #0xB4]
        bic     r1, r1, #1
        orr     r1, r1, #0x300000
        str     r1, [r0, #0xB4]
        bx      lr

ASM_FUNC_NAME(init_assigned_vars)
        mov    	r1, #0
        sub     r0, r1, #0xD800000
        str     r1, [r0, #0x30]
        str     r1, [r0, #0x34]
        str     r1, [r0, #0x38]
        str     r1, [r0, #0x3C]
        mov     r3, #8
        str     r3, [r0, #0x40]
        str     r3, [r0, #0x44]
        mov     r2, #9
        str     r2, [r0, #0x48]
        str     r1, [r0, #0x4C]
        str     r1, [r0, #0x50]
        str     r1, [r0, #0x54]
        str     r1, [r0, #0x58]
        str     r2, [r0, #0x5C]
        str     r1, [r0, #0x60]
        str     r1, [r0, #0x64]
        str     r1, [r0, #0x68]
        str     r1, [r0, #0x6C]
        str     r1, [r0, #0x70]
        str     r1, [r0, #0x74]
        str     r1, [r0, #0x78]
        str     r1, [r0, #0x7C]
        str     r1, [r0, #0x80]
        str     r1, [r0, #0x84]
        str     r1, [r0, #0x88]
        str     r1, [r0, #0x8C]
        str     r1, [r0, #0x90]
        str     r1, [r0, #0x94]
        str     r3, [r0, #0x98]
        str     r3, [r0, #0x9C]
        str     r2, [r0, #0xA0]
        str     r1, [r0, #0xA4]
        str     r1, [r0, #0xA8]
        str     r1, [r0, #0xAC]
        str     r1, [r0, #0xB0]
        str     r2, [r0, #0xB4]
        str     r1, [r0, #0xB8]
        str     r1, [r0, #0xBC]
        mov     r3, #0xD
        str     r3, [r0, #0xC0]
        str     r1, [r0, #0xC4]
        str     r1, [r0, #0310]
        str     r1, [r0, #0xCC]
        str     r1, [r0, #0xD0]
        str     r1, [r0, #0xD4]
        str     r1, [r0, #0xD8]
       	str     r1, [r0, #0xDC]
        str    	r1, [r0, #0xE0]
        str     r1, [r0, #0xE4]
        mov     r3, #5
        str     r3, [r0, #0xE8]
        str     r1, [r0, #0xEC]
        str     r1, [r0, #0xF0]
        str     r1, [r0, #0xF4]
        str     r1, [r0, #0xF8]
        str     r1, [r0, #0xFC]
        str     r1, [r0, #0x100]
        str     r1, [r0, #0x104]
        str     r1, [r0, #0x108]
        str     r1, [r0, #0x10C]
        str     r3, [r0, #0x110]
        mov     r3, #0xC
        str     r3, [r0, #0x114]
        str     r3, [r0, #0x118]
        str     r3, [r0, #0x11C]
        str     r3, [r0, #0x120]
        str     r1, [r0, #0x124]
        str     r1, [r0, #0x128]
        str     r1, [r0, #0x12C]
        str     r1, [r0, #0x130]
        str     r1, [r0, #0x134]
        str     r1, [r0, #0x138]
        str     r1, [r0, #0x13C]
        str     r1, [r0, #0x140]
        str     r1, [r0, #0x144]
        str     r2, [r0, #0x148]
        str     r1, [r0, #0x14C]
        str     r1, [r0, #0x150]
        str     r1, [r0, #0x154]
        str     r1, [r0, #0x158]
        str     r1, [r0, #0x15C]
        str     r1, [r0, #0x160]
        str     r1, [r0, #0x164]
        str     r1, [r0, #0x168]
        str     r1, [r0, #0x16C]
        str     r1, [r0, #0x170]
        str     r1, [r0, #0x174]
        str     r1, [r0, #0x178]
        str     r1, [r0, #0x17C]
        str     r1, [r0, #0x180]
        str     r1, [r0, #0x184]
        str     r1, [r0, #0x188]
        str     r1, [r0, #0x18C]
        str     r1, [r0, #0x190]
        str     r1, [r0, #0x194]
        str     r1, [r0, #0x198]
        str     r1, [r0, #0x19C]
        mov     r2, #4
        str     r2, [r0, #0x1A0]
        str     r1, [r0, #0x1A4]
        str     r1, [r0, #0x1A8]
        str     r1, [r0, #0x1AC]
        str     r1, [r0, #0x1B0]
        str     r1, [r0, #0x1B4]
        str     r1, [r0, #0x1B8]
        str     r1, [r0, #0x1BC]
        str     r1, [r0, #0x1C0]
        str     r1, [r0, #0x1C4]
        str     r1, [r0, #0x1C8]
        str     r1, [r0, #0x1CC]
        str     r1, [r0, #0x1D0]
        str     r1, [r0, #0x1D4]
        str     r1, [r0, #0x1D8]
        str     r1, [r0, #0x1DC]
	mov     r2, #2
	str     r2, [r0, #0x1E0]
	str     r2, [r0, #0x1E4]
	str     r2, [r0, #0x1E8]
	str     r2, [r0, #0x1EC]
	str     r1, [r0, #0x1F0]
	str     r1, [r0, #0x1F4]
	str     r3, [r0, #0x1F8]
	mov     r2, #0xE
	str     r2, [r0, #0x1FC]
	str     r1, [r0, #0x200]
	str     r1, [r0, #0x204]
	str     r1, [r0, #0x208]
	str     r3, [r0, #0x20C]
	str     r3, [r0, #0x210]
	str     r1, [r0, #0x214]
	str     r1, [r0, #0x218]
	str     r1, [r0, #0x21C]
	str     r1, [r0, #0x220]
	str     r1, [r0, #0x224]
	str     r1, [r0, #0x228]
	str     r1, [r0, #0x22C]
	str     r1, [r0, #0x230]
	str     r1, [r0, #0x234]
	str     r1, [r0, #0x238]
	str     r1, [r0, #0x23C]
	str     r1, [r0, #0x240]
	str     r1, [r0, #0x244]
	str     r1, [r0, #0x248]
	str     r1, [r0, #0x24C]
	str     r1, [r0, #0x250]
	str     r1, [r0, #0x254]
	str     r1, [r0, #0x258]
	str     r1, [r0, #0x25C]
	str     r1, [r0, #0x260]
	str     r1, [r0, #0x264]
	str     r1, [r0, #0x268]
	str     r1, [r0, #0x26C]
	str     r1, [r0, #0x270]
	str     r1, [r0, #0x274]
	str     r1, [r0, #0x278]
	str     r1, [r0, #0x27C]
	str     r1, [r0, #0x280]
	str     r1, [r0, #0x284]
	str     r1, [r0, #0x288]
	str     r1, [r0, #0x28C]
	str     r1, [r0, #0x290]
	str     r1, [r0, #0x294]
	str     r1, [r0, #0x298]
	str     r1, [r0, #0x29C]
	str     r1, [r0, #0x2A0]
	str     r1, [r0, #0x2A4]
	str     r1, [r0, #0x2A8]
	bx      lr
