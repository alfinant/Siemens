#ifdef CX75v25
#define PhyWAS_ExtPower_Process_Entry   0xA0A911B4
#define ProcSendMSG     0xA0204F40
#define Hisr_PhyWAS_ExtPower 0xA0A909CC
#endif
  
     RSEG PATCH_Hisr_PhyWAS_ExtPower_Entry:DATA(2) ;PATCH_PhyWAS_ExtPower_Process_Entry:DATA(2)
     DCD  My_PhyWAS_ExtPower_Process_Entry
  
     CODE32

     RSEG CODE:CODE(2)
My_PhyWAS_ExtPower_Process_Entry   
     PUSH {R0,R4,LR}
     LDR R3, _e
     BLX R3
     POP {R0}
;     LDR R0, [R0,#0]
;     LDRH R0, [R0,#0xC]
;     CMP R0,#8
;    BNE _exit     
     LDR R0, =0x3F00
     MOV R1, #0xB
     BLX R4    
     LDR R0, =0x3F00
     MOV R1, #0xA
     BLX R4
     LDR R0, =0x6B03
     MOV R1, #0x15
     BLX R4
     LDR R0, =0x6B03
     MOV R1, #0x10
     BLX R4    
_exit
     POP {R4,PC}
     DATA
_e   DCD Hisr_PhyWAS_ExtPower ;PhyWAS_ExtPower_Process_Entry
_f   DCD ProcSendMSG



;===============================================================================

  END
  
