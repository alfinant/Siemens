; SSC for sgold2
; PHILIPS_TOSHIBA_JBT6K71

#define      SSC0        0xF0000000
#define      CAMIF       0xF7000000
#define      DIF         0xF7100000

                 RSEG CODE:CODE	         
                 CODE32                 

      PUBLIC	SSC2_Write16
                 
SSC2_Write16

; int SSC2_Write16(short reg,short data)
                
                 STMFD  SP!, {R4-R6,LR}
                 MOV    R4, R0
                 MOV    R5, R1
                 MRS    R6, CPSR
                 SWI    4
                 MOV    R0, #0
                 BL     set_access  ;clkSetLevel for DIF
                 BL     initDIF     ;wakeup
                 MOV    R0, R0,LSR#8
                 BL     sel_reg 
                 AND    R0, R4, #0xFF
                 BL     sel_reg
                 MOV    R0, R5,LSR#8                
                 BL     write_data
                 AND    R0, R5, #0xFF 
                 BL     write_data
                 MSR    CPSR_c, R6
                 LDMFD  SP!, {R4-R6,LR}

; =============== S U B R O U T I N E =======================================

sel_reg          MOV	R2, #0
                 SUB	R0, R0, #0xEF00000 ;F1100000
                 STR	R2, [R1,#0x10]
                 LDR	R2, [R1,#0x28]
                 ORR	R2, R2, #1
                 STR	R2, [R1,#0x28]
                 MOV	R2, #1
                 STR	R2, [R1,#0x10]
                 ADD	R2, R1, #0x8000
                 STR	R0, [R2]
loc_A06089FC     LDR	R0, [R1,#0x38]
                 TST	R0, #1
                 BNE	loc_A06089FC
                 MOV	R0, #0
                 BX	LR
                
; =============== S U B R O U T I N E =======================================

write_data
                 MOV	R2, #0                
                 SUB	R1, R2, #0x8F00000
                 STR	R2, [R1,#0x10]
                 LDR	R2, [R1,#0x28]
                 ORR	R2, R2, #1
                 STR	R2, [R1,#0x28]
                 MOV	R2, #1
                 STR	R2, [R1,#0x10]
                 ADD	R2, R1, #0x8000
                 STR	R0, [R2]         ;SSC1_TB
loc_A0606ED8
                 LDR	R0, [R1,#0x38] 
                 TST	R0, #1
                 BNE	loc_A0606ED8
                 MOV	R0, #0
                 BX	LR
               
; =============== S U B R O U T I N E =======================================

read_data
                 MOV	R2, #0
                 SUB	R1, R2, #0x8F00000
                 STR	R2, [R1,#0x10]
                 MOV	R2, #3
                 STR	R2, [R1,#0x34]
                 MOV	R2, #1
                 STR	R2, [R1,#0x10]                 
l_A0608A2C:
                 LDR	R2, [R1,#0x38]
                 TST	R2, #1
                 BNE	l_A0608A2C
                 LDR	R1, =0xF710C000  ;SSC1_TB
                 LDR	R1, [R1]
                 STR	R1, [R0]
                 MOV	R0, #0
                 BX	LR
                 
; =============== S U B R O U T I N E =======================================

      PUBLIC	 ssc_read                
                 
ssc_read

; int ssc_read(char adr,char reg,char *data)



; =============== S U B R O U T I N E =======================================

       PUBLIC    initDIF

initDIF
                 LDR    R1, =0xF7100000
                 MOV	R0, #0x100
                 STR	R0, [R1]
                 LDR	R0, [R1,#0x10]
                 ORR	R0, R0, #1
                 STR	R0, [R1,#0x10]
                 BX     LR  
                 
; =============== S U B R O U T I N E =======================================

      PUBLIC	 set_access

set_access

; int set_access(r0=0/1)
 
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
                 
; =============== S U B R O U T I N E =======================================  

      PUBLIC	 BFC_L2_SwitchOffDisplay

BFC_L2_SwitchOffDisplay

                LDR PC, =0xA05161B0
; ---------------------------------------------------------------------------
      PUBLIC	 LCD_SwitchOff

LCD_SwitchOff

                LDR PC, =0xA076AF74
; --------------------------------------------------------------------------- 
      PUBLIC	 BFC_L2_RestoreDisplay
      
BFC_L2_RestoreDisplay  

                LDR PC, =0xA0516250
; --------------------------------------------------------------------------- 
      PUBLIC	 BFC_L2_ForceDisplayUpdate
      
BFC_L2_ForceDisplayUpdate

                LDR PC, =0xA05161FC   
; --------------------------------------------------------------------------- 

      PUBLIC	BFC_L2_Display_0xC
      
BFC_L2_Display_0xC

               LDR PC, =0xA0515FEC
; --------------------------------------------------------------------------- 
         END
	