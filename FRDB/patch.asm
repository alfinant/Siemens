       CODE16
       EXTERN my_onmessage
       EXTERN openItem
       
       RSEG PATCH_ONMESSAGE:DATA(2)
       DCD  my_onmessage 

       RSEG PATCH_MAINCSMSIZE:DATA(2)
       DCD 0xF8  

       RSEG PATCH_START:CODE(1)
       MOV R0,R4
       BLX start
       
       RSEG PATCH_START_JUMP:CODE(2)
       CODE32
start 
       LDR R12,data 
       BX R12
data DCD openItem
       
       CODE16
       RSEG PATCH_PREDIAL_ENA1:CODE(1)       
       LSL R0,R0, #0x1D
  
       RSEG PATCH_PREDIAL_ENA2:CODE(1)
       NOP
       MOV R0,#1 

       RSEG PATCH_APM_FRDB_GetInfo1:CODE(1)
       B GetInfo1_JUMP

       RSEG GetInfo1_JUMP:CODE(1)
GetInfo1_JUMP

       RSEG PATCH_APM_FRDB_GetInfo2:CODE(1)
       B GetInfo2_JUMP
       
       RSEG GetInfo2_JUMP:CODE(1)
GetInfo2_JUMP      

       RSEG PATCH_APM_FileRef_Run_UNKNOWN:CODE(1)
       B UNKNOWN_JUMP
       
       RSEG UNKNOWN_JUMP:CODE(1)
UNKNOWN_JUMP

       RSEG PATCH_APM_FileRef_Run_SOUND:CODE(1)
       B SOUND_JUMP
       
       RSEG SOUND_JUMP:CODE(1)
SOUND_JUMP     

       RSEG PATCH_APM_FileRef_Run_VIDEOIMAGE:CODE(1)
       MOV R2,#0
       MOV R1,#0
       LDR R0,[R4,#0]
       SWI 0x94 //ExecuteFile
       NOP
  END

