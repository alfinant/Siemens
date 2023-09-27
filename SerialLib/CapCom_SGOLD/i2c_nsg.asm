                 RSEG CODE:CODE	         
                 CODE32                 

      PUBLIC	i2c_write
                 
i2c_write

; int i2c_write(char adr,short reg,char data)

                 STMFD   SP!, {R4-R7,LR}
                 MOV     R6, R0
                 MOV     R5, R2
                 MOV     R4, R1
                 CMP     R0, #0x80
                 MOVCS   R0, #6
                 LDMCSFD SP!, {R4-R7,PC}
; ---------------------------------------------------------------------------
                 MRS     R7, CPSR
                 SWI     4
                 MOV     R0, #0
                 BL      setAccess
                 BL      setConf
                 BL      sub_unk1
                 LDR     R1, =0xF7600000
                 MOV     R0, #3
                 STR     R0, [R1,#0x34]

loc_w1
                 LDR     R0, [R1,#0x80]
                 TST     R0, #1
                 BEQ     loc_w1
                 MOV     R0, R5,LSL#16
                 ORR     R0, R0, R4,LSL#8
                 LDR     R2, =0xF7608000
                 ORR     R0, R0, R6,LSL#1
                 STR     R0, [R2]
                 MOV     R0, #1
                 STR     R0, [R1,#0x8C]

loc_w2 
                 LDR     R0, [R1,#0x80]
                 TST     R0, #0x20
                 BEQ     loc_w2
                 LDR     R0, [R1,#0x74]
                 TST     R0, #0x10
                 BNE     loc_w4
                 LDR     R0, [R1,#0x74]
                 TST     R0, #0x20
                 BEQ     loc_w6
                 LDR     R0, [R1,#0x14]
                 ORR     R0, R0, #2
                 STR     R0, [R1,#0x14]
                 MOV     R0, #0x20
                 STR     R0, [R1,#0x78]
                 STR     R0, [R1,#0x8C]

loc_w3 
                 LDR     R2, [R1,#0x80]
                 TST     R2, #0x20
                 BEQ     loc_w3
                 LDR     R2, [R1,#0x74]
                 TST     R2, #0x10
                 BEQ     loc_w5

loc_w4 
                 MSR     CPSR_c, R7
                 MOV     R0, #4
                 LDMFD   SP!, {R4-R7,PC}
; ---------------------------------------------------------------------------
loc_w5  
                 LDR     R2, [R1,#0x74]
                 TST     R2, #0x20
                 BEQ     loc_w6
                 MOV     R3, #0
                 STR     R0, [R1,#0x78]
                 STR     R0, [R1,#0x8C]
                 BL      sub_unk2
                 MSR     CPSR_c, R7                 
                 MOV     R0, R3
                 LDMFD   SP!, {R4-R7,PC}
; ---------------------------------------------------------------------------
loc_w6
                 MSR     CPSR_c, R7
                 MOV     R0, #0xD
                 LDMFD   SP!, {R4-R7,PC}                
               
; =============== S U B R O U T I N E =======================================
                 
      PUBLIC	 i2c_read                
                 
i2c_read

; int i2c_read(char adr,short reg,char *data)

                 STMFD   SP!, {R4-R7,LR}
                 MOV     R6, R0
                 MOV     R5, R2
                 MOV     R4, R1
                 CMP     R0, #0x80
                 MOVCS   R0, #6
                 LDMCSFD SP!, {R4-R7,PC}
; ---------------------------------------------------------------------------                 
                 MRS     R7, CPSR
                 SWI     4  
                 MOV     R0, #0                 
                 BL      setAccess
                 BL      setConf
                 BL      sub_unk1
                 LDR     R2, =0xF7600000
                 MOV     R0, #2
                 STR     R0, [R2,#0x34]

loc_r1  
                 LDR     R0, [R2,#0x80]
                 TST     R0, #1
                 BEQ     loc_r1
                 MOV     R0, R4,LSL#8
                 LDR     R12, =0xF7608000
                 ORR     R0, R0, R6,LSL#1
                 STR     R0, [R12]
                 MOV     R1, #1
                 STR     R1, [R2,#0x8C]

loc_r2   
                 LDR     R0, [R2,#0x80]
                 TST     R0, #0x20
                 BEQ     loc_r2
                 LDR     LR, [R2,#0x74]
                 MOV     R0, R2
                 TST     LR, #0x10
                 BNE     loc_r7
                 LDR     R2, [R0,#0x74]
                 TST     R2, #0x20
                 BEQ     loc_r9
                 STR     R1, [R0,#0x2C]
                 STR     R1, [R0,#0x34]
                 MOV     R2, #0x20
                 STR     R2, [R0,#0x78]
                 STR     R2, [R0,#0x8C]

loc_r3  
                 LDR     LR, [R0,#0x80]
                 TST     LR, #1
                 BEQ     loc_r3
                 ORR     R3, R1, R6,LSL#1
                 STR     R3, [R12]
                 STR     R1, [R0,#0x8C]
                 MOV     R3, R0

loc_r4  
                 LDR     R0, [R3,#0x80]
                 TST     R0, #1
                 BEQ     loc_r4
                 LDR     R0, =0xF760C000
                 LDR     R0, [R0]
                 STRB    R0, [R5]
                 STR     R1, [R3,#0x8C]

loc_r5     
                 LDR     R0, [R3,#0x80]
                 TST     R0, #0x20
                 BEQ     loc_r5
                 LDR     R0, [R3,#0x74]
                 TST     R0, #0x10
                 BNE     loc_r7
                 LDR     R1, [R3,#0x74]
                 MOV     R0, R3
                 TST     R1, #0x60
                 BEQ     loc_r9
                 LDR     R1, [R0,#0x14]
                 ORR     R1, R1, #2
                 STR     R1, [R0,#0x14]
                 MOV     R1, #0x60
                 STR     R1, [R0,#0x78]
                 STR     R2, [R0,#0x8C]

loc_r6 
                 LDR     R1, [R0,#0x80]
                 TST     R1, #0x20
                 BEQ     loc_r6
                 LDR     R1, [R0,#0x74]
                 TST     R1, #0x10
                 BEQ     loc_r8

loc_r7
                 MSR     CPSR_c, R7 
                 MOV     R0, #4
                 LDMFD   SP!, {R4-R7,PC}
; ---------------------------------------------------------------------------

loc_r8  
                 LDR     R1, [R0,#0x74]
                 TST     R1, #0x20
                 BEQ     loc_r9
                 MOV     R3, #0
                 STR     R2, [R0,#0x78]
                 STR     R2, [R0,#0x8C]
                 BL      sub_unk2
                 MSR     CPSR_c, R7                  
                 MOV     R0, R3
                 LDMFD   SP!, {R4-R7,PC}
; ---------------------------------------------------------------------------

loc_r9
                MSR     CPSR_c, R7 
                MOV     R0, #0xD
                LDMFD   SP!, {R4-R7,PC}

; =============== S U B R O U T I N E =======================================

setConf
                 LDR     R0, =0xF7600000
                 MOV     R1, #0x200
                 STR     R1, [R0]
                 MOV     R1, #0
                 STR     R1, [R0,#0x10]
                 MOV     R1, #0x80000
                 STR     R1, [R0,#0x20]
                 LDR     R1, =0x30022
                 STR     R1, [R0,#0x28]
                 LDR     R1, =0x10040
                 STR     R1, [R0,#0x18]
                 MOV     R1, #1
                 STR     R1, [R0,#0x10]
                 MOV     R1, #0x3F
                 STR     R1, [R0,#0x8C]
                 STR     R1, [R0,#0x78]
                 MOV     R1, #0xF
                 STR     R1, [R0,#0x68]
                 BX      LR
                 
; =============== S U B R O U T I N E =======================================
sub_unk1
                 LDR     R2, =0xF7600000
                 LDR     R0, [R2,#0x84]
                 LDR     R1, =0xFFC0
                 AND     R0, R0, R1
                 STR     R0, [R2,#0x84]
                 BX      LR

; =============== S U B R O U T I N E =======================================
sub_unk2
                 STR     LR, [SP,#-4]!
                 BL      sub_unk1
                 MOV     R1, #0
                 LDR     R0, =0xF7600000
                 STR     R1, [R0,#0x10]
                 MOV     R1, #1
                 STR     R1, [R0]
                 LDR     PC, [SP],#4

; =============== S U B R O U T I N E =======================================

      PUBLIC	 setAccess

setAccess

; void setAccess(r0=0/1)
 
                 STR     LR, [SP,#-4]!
                 MOV     R3, R0
                 BL      disadle_INT                  
                 LDR     R1, =0xF4500000
                 LDR     R2, [R1, #0xB4]
                 BIC     R2, R2, #0x33
                 ADD     R0, R3, #2
                 ORR     R2, R2,R0
                 STR     R2, [R1, #0xB4]                   
                 BL      enable_INT
                 LDR     PC, [SP],#4          
                 
; =============== S U B R O U T I N E ======================================= 
                 
      PUBLIC	 disadle_INT                
     
disadle_INT

; void disadle_INT(void)

                 MRS	R0, CPSR
                 ORR	R1, R0, #0xC0
                 AND	R2, R0, #0x1F
                 CMP	R2, #0x10
                 SWIEQ	4
                 MSR	CPSR_c, R1
                 BX	LR
                 
; =============== S U B R O U T I N E =======================================

      PUBLIC	 enable_INT  
      
enable_INT 

; void enable_INT(void)

                 MRS	R0, CPSR
                 BIC	R1, R0, #0xC0
                 AND	R2, R0, #0x1F
                 CMP	R2, #0x10
                 SWIEQ	4
                 MSR	CPSR_c, R1                
                 BX	LR 

; ---------------------------------------------------------------------------

         END
	