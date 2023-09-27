	RSEG	CODE:CODE
	PUBLIC	icc_tx
	CODE32
icc_tx

        ldr r5,=0xF7600000
        
        mov r0,#0x400
        str r0,[r5]
        
        mov r0,#0
        str r0,[r5,#0x10]
 
;       mov r1,#0x080000 ; Rx
        mov r1,#0x280000 ; Tx
        str r1,[r5,#0x20]
        
        ldr r1,=0x30022
        str r1,[r5,#0x28]
        
        ldr r1,=0x4003D
        str r1,[r5,#0x18]
        
        mov r1,#1
        str r1,[r5,#0x10]
        
        mov r0,#0x3F
        str r0,[r5,#0x8C]
        
        mov r0,#0x7F
        str r0,[r5,#0x78]
        
        mov r0,#0xF
        str r0, [r5,#0x68]
; -----------------------------        
        mov r0,#0x3F
        str r0,[r5,#0x84]                
;--------------------------------------------
        mov r0,#0x3
        str r0, [r5,#0x34] ; גûחûגאוע i2c_isr_1 , vector=0x9B
;---------------------------------------------
        ldr r0,=0x00401362 
        ldr r6,=0xF7608000
        ;str r0, [r6] ; גûחûגאוע i2c_isr_2 , vector=0x9E
; ---------------------------------------------
        mov r0,#1
        str r0,[r5,#0x8C]
        bx lr
; -----------------------------------------
DisableINT
;disable IRQ and FIQ interrupts
        mrs r0, CPSR
        orr r0, r0, #0xc0
        msr CPSR_c, r0
;--------------------------------------------
EnableINT
;enable IRQ and FIQ interrupts
        mrs r0, CPSR
        bic r0, r0, #0xc0
        msr CPSR_c, r0
;---------------------------------------------
cpu_user_mode
        mrs r0, CPSR
        bic r0, r0, #0x1F
        orr r0, r0, #0x10
        msr CPSR_cxsf, r0       
        bx lr
; ----------------------------------------------     
	END
	