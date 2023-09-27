    RSEG	CODE:CODE

        PUBLIC  menu_onmessage
menu_onmessage
        DCD 0xA02CE617
       
        PUBLIC	_SettingsAE_Read_ws
_SettingsAE_Read_ws
        DCD 0xA028A595

        PUBLIC	_SettingsAE_Update_ws
_SettingsAE_Update_ws
        DCD  0xA028A5D7

        PUBLIC	_SettingsAE_SetFlag
_SettingsAE_SetFlag:
        DCD  0xA028A52F
        
        PUBLIC	_FRDB_GetIndex
_FRDB_GetIndex
        DCD  0xA02C8D31

        PUBLIC _GetExtUidByFileName
_GetExtUidByFileName     
        DCD 0xA04D3E51             
        
        PUBLIC _GetFileNameWithExt
_GetFileNameWithExt 
        DCD  0xA0336F8F

        PUBLIC _GetPatchToFolder
_GetPatchToFolder  
        DCD 0xA0336F55        
       

 
 END