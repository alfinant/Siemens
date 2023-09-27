       EXTERN my_onmessage
       
       CODE16
       
       RSEG PATCH_ONMESSAGE:DATA(2)
       DCD  my_onmessage 

       RSEG PATCH_MAINCSMSIZE:DATA(2)
       DCD 0x478
       
       CODE16
       RSEG PATCH_PREDIAL_ENA1:CODE(1)       
       LSL R0,R0, #0x1D
  
       RSEG PATCH_PREDIAL_ENA2:CODE(1)
       NOP
       MOV R0,#1 

       RSEG PATCH_APM_FRDB_GetInfo1:CODE(1)
       B J_GetInfo1

       RSEG J_GetInfo1:CODE(1)
J_GetInfo1

       RSEG PATCH_APM_FRDB_GetInfo2:CODE(1)
       B J_GetInfo2
       
       RSEG J_GetInfo2:CODE(1)
J_GetInfo2      

       RSEG PATCH_APM_FileRef_Run_UNKNOWN:CODE(1)
       B J_UNKNOWN
       
       RSEG J_UNKNOWN:CODE(1)
J_UNKNOWN

       RSEG PATCH_APM_FileRef_Run_SOUND:CODE(1)
       B J_SOUND
       
       RSEG J_SOUND:CODE(1)
J_SOUND     

       RSEG PATCH_APM_FileRef_Run_VIDEOIMAGE:CODE(1)
       MOV R2,#0
       MOV R1,#0
       LDR R0,[R4,#0]
       BL  ExecuteFile

       RSEG ExecuteFile:CODE(1)
ExecuteFile
  END

