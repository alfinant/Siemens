GET_LOCATION_ADR   EQU 0xA05024E4 ;int GetLocation(WSHDR *dir,char *location)
MLK_GET_BASE_ADR   EQU 0xA069C9DC ;int MLK_GetBase()

LGP_FILE_NOT_FOUND EQU 0x233

        RSEG	CODE:CODE
        
      PUBLIC  SendMSG
SendMSG      
        LDR PC,=0xA0094669

      PUBLIC GetLangMes
GetLangMes
        LDR PC,[PC,#-4]
        DCD 0xA08D5240
        
      PUBLIC NU_Create_Memory_Pool
NU_Create_Memory_Pool
        LDR PC,[PC,#-4]
        DCD 0xA009D150

      PUBLIC NU_Allocate_Memory
NU_Allocate_Memory
        LDR PC,=0xA009D200

        PUBLIC NU_Create_Task
NU_Create_Task
        LDR PC,=0xA009CA14
        
        PUBLIC NU_Resume_Task
NU_Resume_Task
        LDR PC,=0xA009CCA8
        
        PUBLIC NU_Task_Pointers
NU_Task_Pointers
        LDR PC,=0xA00A0B7C
        
        PUBLIC NU_Sleep
NU_Sleep
        LDR PC,=0xA009CD50      
        
        PUBLIC NU_Register_LISR
NU_Register_LISR
        LDR PC,=0xA009C920
        
        PUBLIC NU_HISR_Pointers // 01 70 A0 E1 00 40 90 E5 00 00 54 E3
NU_HISR_Pointers
        LDR PC,=0xA00A0C20     
        
        
        PUBLIC NU_Memory_Pool_Pointers
NU_Memory_Pool_Pointers
        LDR PC,=0xA009D2D8


        PUBLIC NU_Create_Queue
NU_Create_Queue
        LDR PC,=0xA00A06C8

        PUBLIC NU_Send_To_Queue
NU_Send_To_Queue
        LDR PC,=0xA00A0788 

        PUBLIC NU_Receive_From_Queue
NU_Receive_From_Queue
        LDR PC,=0xA00A082C

        PUBLIC NU_Set_Events
NU_Set_Events
        LDR PC,=0xA009D55C

        PUBLIC fb_memory
fb_memory
        LDR PC,=0xA0548D0C 

        PUBLIC SettingsAE_GetEntryList
SettingsAE_GetEntryList
        LDR PC,=0xA06412FD
        
        PUBLIC SettingsAE_RemoveEntry
SettingsAE_RemoveEntry
        DCD 0xA0641419

        PUBLIC	SettingsAE_Read_ws
SettingsAE_Read_ws
        DCD 0xA05ACFEB

        PUBLIC	SettingsAE_Update_ws
SettingsAE_Update_ws
        DCD	0xA05AD02D

        PUBLIC	SettingsAE_SetFlag
SettingsAE_SetFlag:
        DCD	0xA05ACF85
        
        PUBLIC	FRDB_GetIndex
FRDB_GetIndex
        DCD	0xA06354C1

        PUBLIC GetExtUidByFileName
GetExtUidByFileName     
        DCD 0xA05026F8            
        
        PUBLIC GetFileNameWithExt
GetFileNameWithExt 
        DCD  0xA06F3583

        PUBLIC GetPatchToFolder
GetPatchToFolder  
        DCD 0xA06F3549        
       
        PUBLIC fexists
fexists  
        DCD 0xA05D0EAC 

        PUBLIC wstrcmp
wstrcmp
        DCD 0xA04FAC7F
        
        PUBLIC parseInt
parseInt
        DCD 0xA122AA09
;==============================================      
        PUBLIC GetLocation
GetLocation
        LDR PC,[PC,#-4]
        DCD GET_LOCATION_ADR
;============================================== 
        PUBLIC MLK_GetBase
MLK_GetBase
        LDR PC,[PC,#-4]
        DCD MLK_GET_BASE_ADR        
;==============================================  
        PUBLIC flash_erase_byte
flash_erase_byte
        LDR PC,[PC,#-4]
        DCD 0xA8FA9894
        
        PUBLIC Register_Freq
Register_Freq
        LDR PC,[PC,#-4]
        DCD 0xA04D0260
        
        PUBLIC BTSB_Baudrate
BTSB_Baudrate
        LDR PC,[PC,#-4]
        DCD 0xA0526840
;===============================
;unsigned MMU_GetTTBase(void)
          PUBLIC MMU_GetTTBase
MMU_GetTTBase
          ;ro=TTBase 
          MRS R1, CPSR
          SWI 4
          mrc p15,0,r0,c2,c0,0
          MSR CPSR_c, R1
          bx lr
;===============================  
          PUBLIC DSetVol
DSetVol
          PUSH  {R4,LR}
          LDR   R4,=0xF6001042
          MOV	LR, #0x28 
          STRH	LR, [R4]
          
        //  MOV   R0, #0x4000    
        //  MOV   R1, #0x0    
        //  MVN   R1, #0
         // MOV   R2, #0x10
          //MOV   R3, #0x10
          STRH  R0, [R4,#2]          
          STRH  R1, [R4,#4]          
          STRH  R2, [R4,#6]          
          STRH  R3, [R4,#8]
        
          MOV   R4, #0x2
          LDR   R0,=0xF6000000         
          STR	R4, [R0, #0x1C]
          LDR	R0, =0xF4400000 ;SCU
          STR	R4, [R0, #0x30]
          MOV	R1, #0
          STR	R1, [R0, #0x30]
               

 /*         LDR   R4,=0xF600100A   
          MOV	R0, #0xE
          STRH	R0, [R4]
          
          MOV   R4, #0x1
          LDR   R0,=0xF6000000         
          STR	R4, [R0, #0x1C]
*/
          
          POP   {R4,PC}
          

          PUBLIC sleep
          
sleep  

 ;void sleep(int ms)
        
                LDR     R3, =0xF4B00000
                LDR     R1, [R3,#0x10]
                MOV     R2, #0x7D
                MUL     R0, R2, R0
                ADD     R0, R1, R0,LSL#3

loop            LDR     R1, [R3,#0x10]
                CMP     R1, R0
                BCC     loop
                BX      LR
        
          
 END