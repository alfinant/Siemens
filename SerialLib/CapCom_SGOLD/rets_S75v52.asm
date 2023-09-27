        RSEG	CODE:CODE

        PUBLIC  menu_onmessage
menu_onmessage
        DCD 0xA02CE88F
       
        PUBLIC	SettingsAE_Read_ws
SettingsAE_Read_ws
        DCD 0xA028A779

        PUBLIC	SettingsAE_Update_ws
SettingsAE_Update_ws
        DCD	0xA028A7BB

        PUBLIC	SettingsAE_SetFlag
SettingsAE_SetFlag:
        DCD	0xA028A713
        
        PUBLIC	FRDB_GetIndex
FRDB_GetIndex
        DCD	0xA02C8FA9

        PUBLIC GetExtUidByFileName //pattern_NSG=09,B0,F0,BD,F8,B5,04,1C,00,20,+5
GetExtUidByFileName     
        DCD 0xA04D445D         
        
        PUBLIC GetFileNameWithExt
GetFileNameWithExt 
        DCD  0xA03373BB

        PUBLIC GetPatchToFolder
GetPatchToFolder  
        DCD 0xA0337381      
       
        PUBLIC fexists
fexists  
        DCD 0xA04D6401
 
 END