#include "def.h"

        EXTERN my_onmessage
        EXTERN execFile
        EXTERN setFName
        
        CODE16
        
        RSEG PATCH_MENU_ONMESSAGE:DATA(2)
        DCD  my_onmessage
        
        RSEG PATCH_MENU_MAINCSMSIZE:DATA(2)
        DCD  0x470
        
        RSEG PATCH_MENU_PREDIAL_ENA:CODE(1)
        LSL R0,R0,#0x1D
        
        RSEG PATCH_IDLE_START_XTRA_JC:CODE(1)
        BL  execFile
        
        RSEG PATCH_SET_FILE_NAME:CODE(1)
        BL  setFName
   
//==============================================================================

//Только для CX70v56,а может и для остальных SGOLD X65.Убираем отображение лишних софткей табов при нажатии кнопки.Будет как на x75.
#ifdef CX70v56
        RSEG PATCH_IDLE_INPUTDIA_ONKEY:CODE(1)
        NOP
        NOP
        
        RSEG PATCH_IDLE_INPUTDIA_GHOOK:CODE(2)
        LDR R3,_c
        BX R3
        DATA
_c      DCD check_tabs

        RSEG CODE:CODE(2)   
check_tabs:
        CMP R5,#2
        BNE _5
        CMP R0,#1
        BGT _5
_0
        MOV R5, #0
_5
        MOV R1,R5 
        MOV R0,R4
        MOV R2,#1
        LDR R3,a1
        BLX R3
        LDR R3,a2
        BX R3
        DATA
a1      DCD somecode_3  
a2      DCD back_addr
#endif
;===============================================================================
        END
  
