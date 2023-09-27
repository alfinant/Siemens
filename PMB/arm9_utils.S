#define ASM_FUNC_NAME(_name_) \
	.globl _name_ ; _name_: 

.section .text

/* Returns whether D cache is enabled */
ASM_FUNC_NAME(dcache_enabled)
        mrc p15, 0, r0, c1, c0, 0
        bx  lr

/* Enable the D cache */
ASM_FUNC_NAME(dcache_enable)
        mrc p15, 0, r1, c1, c0, 0
        orr r1, r1, #0x000C
        mcr p15, 0, r1, c1, c0, 0
        bx lr

/* Disable the D cache */
ASM_FUNC_NAME(dcache_disable)
        mrc p15, 0, r1, c1, c0, 0
        bic r1, r1, #0x000C
        mcr p15, 0, r1, c1, c0, 0
        mov r1,#0
        mcr p15, 0, r1, c7, c6, 0
        bx lr

/* Makes sure memory and cache are in sync */
ASM_FUNC_NAME(dcache_sync_clean)
        mov  r0, #0
        mcr  p15, 0, r0, c7, c10, 0
1:	mrc  p15, 0, r0, c15, c4, 0
        ands r0, r0, #0x80000000
        bne  1b
        mov  r0,#0
        mcr  p15, 0, r0, c7, c6, 0
        mcr  p15, 0, r0, c7, c10, 4
        bx   lr

/* Flushes the entire D cache and both TLBs */
ASM_FUNC_NAME(dcache_invalidate_all)
        mrc p15, 0, r0, c0, c0, 1
	mov r0, #0
        mcr p15, 0, r0, c7, c6, 0
	mcr p15, 0, r0, c8, c7, 0	/* Flush I+D TLBs */
        bx  lr

/* Enables the I cache */
ASM_FUNC_NAME(icache_enable)
        mrc p15, 0, r1, c1, c0, 0
        orr r1, r1, #0x1000
        mcr p15, 0, r1, c1, c0, 0
        bx lr

/* Disable the I cache */
ASM_FUNC_NAME(icache_disable)
        mrc p15, 0, r1, c1, c0, 0
        bic r1, r1, #0x1000
        mcr p15, 0, r1, c1, c0, 0
        mov r1, #0
        mcr p15, 0, r1, c7, c5, 0
        nop
        nop
        nop
        nop
        nop
        nop
        bx lr

/* Is the I cache enabled */
ASM_FUNC_NAME(icache_enabled)
        mrc p15, 0, r0, c1, c0, 0
        bx lr

/* Invalidates the entire I cache */
ASM_FUNC_NAME(icache_invalidate_all)
        mov r1, #0
        mcr p15, 0, r1, c7, c5, 0
        mcr p15, 0, r1, c8, c5, 0	/* Flush ITLB */
        nop
        nop
        nop
        nop
        nop
        nop
        bx lr

/* Wait for interrupt in low power mode */
ASM_FUNC_NAME(arm9_wait_for_interrupt)
	mov r0, #0
	mcr p15, 0, r0, c7, c0, 4
	bx  lr

/* Put the ARM9 core into doze mode */
ASM_FUNC_NAME(arm9_doze_mode)
	ldr r0, =0xA001B000
	ldr r1, =0xFFFFFFFE
	ldr r2, [r0, #0x0]
	and r1, r1, r2
	str r1, [r0, #0x0]
	mcr p15, 0, r0, c7, c0, 4
	bx  lr

/*
 * Puts the ARM9 into halt mode
 * Only an interrupt brings it back out
 * Don't use this (in the baseband) if you don't know what you're doing
 */
ASM_FUNC_NAME(arm9_stop_mode)
	ldr r0, =0xA001B000
	ldr r1, =0xFFFFFFFC
	ldr r2, [r0, #0x0]
	and r1, r1, r2
	str r1, [r0, #0x0]
	mcr p15, 0, r0, c7, c0, 4
	bx lr

/* Fastbus mode */
ASM_FUNC_NAME(arm9_set_fastbus_mode)
	mrc p15, 0, r0, c1, c0, 0
	and r0, r0, #0x3FFFFFFF
	mcr p15, 0, r0, c1, c0, 0
	bx  lr

/* Sync clock mode */
ASM_FUNC_NAME(arm9_set_sync_mode)
	mrc p15, 0, r0, c1, c0, 0
	and r0, r0, #0x7FFFFFFF
	orr r0, r0, #0x40000000
	mcr p15, 0, r0, c1, c0, 0
	bx lr

/* Async clock mode */
ASM_FUNC_NAME(arm9_set_async_mode)
	mrc p15, 0, r0, c1, c0, 0
	orr r0, r0, #0xC0000000
	mcr p15, 0, r0, c1, c0, 0
	bx lr

/* Returns the current core clock mode */
ASM_FUNC_NAME(arm9_get_clock_mode)
        mrc p15, 0, r0, c1, c0, 0
	mov r0, r0, lsr #30
	bx lr
