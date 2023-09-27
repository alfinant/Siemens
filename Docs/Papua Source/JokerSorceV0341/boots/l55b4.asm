; =========================================================================
;      MAIN BOOT.  PV` PapuaSoft & PapuaHard 2005
; =========================================================================
; ---------------------------------------------------------------------------

$SET (WriteBuffered=1)

$SET (AX75=1)
$SET (A75=0)
$SET (A70=0)
$SET (A65=0)
$SET (A60=0)
$SET (S55=0)
$SET (M55=0)
$SET (C55=0)
$SET (A55=0) ;=C55!!!
$SET (A50=0)

$SET (ENABLE_INT3=0)

$Mod167
$IF NOT TINY
$SEGMENTED
$ENDIF

$INCLUDE (reg167n.a66)

word_3F00 EQU 03F00H
word_3F02 EQU 03F02H
word_3F04 EQU 03F04H
word_3F08 EQU 03F08H
word_3F0A EQU 03F0AH
word_3F0C EQU 03F0CH
word_3F0E EQU 03F0EH
word_3F10 EQU 03F10H

T3INT  EQU 08CH
;word_8000 EQU 0
;word_8004 EQU 4

$IF AX75
;AX75 FlashID: 0001/227E-2221-2201
;Size: 16Mb, WriteBuffer: 32 bytes
;Region(1): Blocks 128, Size 128Kb
;RAM Size: 256Kb
DEFFlashSize  EQU 1000H     ; 16Mb
DEFCFISegs  EQU 01H
DEFCFISegN1 EQU 007FH   ; CFISegN1+1
DEFCFISegS1 EQU 0200H   ; CFISegS1*256 128Kb
$ENDIF

$IF A75
DEFFlashSize  EQU 0800H     ; 8Mb
DEFCFISegs  EQU 01H
DEFCFISegN1 EQU 003FH   ; CFISegN1+1
DEFCFISegS1 EQU 0200H   ; CFISegS1*256 128Kb
$ENDIF

$IF A70
;A70  FlashID: 0001/227E-220C-2201
;Size: 8Mb, WriteBuffer: 32 bytes
;Region(1): Blocks 128, Size 64Kb
DEFFlashSize  EQU 0800H  ; 8Mb
DEFCFISegs  EQU 01H
DEFCFISegN1 EQU 007FH  ; CFISegN1+1
DEFCFISegS1 EQU 0100H  ; CFISegS1*256 64Kb
$ENDIF

$IF A60
;SIEMENS A62 lg98 Sw02
;FlashID: 0001/227E-220C-2201
;Flash Size: 8Mb, WriteBuffer: 32 bytes
;Region(1): Blocks 128, Size 64Kb
;RAM Size: 512Kb
;Start EEPROM segments at addres 0xFC0000
;SIEMENS A60 lg91 Sw23
;FlashID: 0001/227E-220C-2201
;Flash Size: 8Mb, WriteBuffer: 32 bytes
;Region(1): Blocks 128, Size 64Kb
;RAM Size: 512Kb
DEFFlashSize  EQU 0800H   ; 8Mb
DEFCFISegs  EQU 01H
DEFCFISegN1 EQU 003FH   ; CFISegN1+1
DEFCFISegS1 EQU 0100H   ; CFISegS1*256 64Kb
$ENDIF

$IF A65
;SIEMENS A65 lg91 Sw15
;FlashID: 0001/227E-2212-2200
;Flash Size: 16Mb, WriteBuffer: 32 bytes
;Region(1): Blocks 256, Size 64Kb
;RAM Size: 512Kb
;Start EEPROM segments at addres 0x7C0000
DEFFlashSize  EQU 1000H   ; 16Mb
DEFCFISegs  EQU 01H
DEFCFISegN1 EQU 007FH   ; CFISegN1+1
DEFCFISegS1 EQU 0100H   ; CFISegS1*256 256Kb
$ENDIF

$IF C60
;SIEMENS C60 lg95
;FlashID: 0001/227E-2212-2200
;Size: 16Mb, WriteBuffer: 32 bytes
;Region(1): Blocks 256, Size 64Kb
DEFFlashSize  EQU 1000H   ; 16Mb
DEFCFISegs  EQU 01H
DEFCFISegN1 EQU 00FFH   ; CFISegN1+1
DEFCFISegS1 EQU 0100H   ; CFISegS1*256 64Kb
$ENDIF

$IF S55
;S55  FlashID: 0020/8810 (0020/88BA)
;Size: 12Mb, WriteBuffer: 8 bytes
;Region(1): Blocks 63, Size 64Kb
;Region(2): Blocks 8, Size 8Kb
;Region(3): Blocks 127, Size 64Kb
;Region(4): Blocks 8, Size 8Kb
;RAM Size: 1024Kb
;---
;SL55 FlashID: 0089/8854 (0089/0016)
;Flash Size: 12Mb, WriteBuffer: 32 bytes
;Region(1): Blocks 32, Size 128Kb
;Region(2): Blocks 127, Size 64Kb
;Region(3): Blocks 8, Size 8Kb
DEFFlashSize  EQU 0C00H     ; 12Mb
DEFCFISegs  EQU 04H
DEFCFISegN1 EQU 003EH   ; CFISegN1+1 63
DEFCFISegS1 EQU 0100H   ; CFISegS1*256 64Kb
DEFCFISegN2 EQU 0007H   ; CFISegN2+1 8
DEFCFISegS2 EQU 0020H   ; CFISegS2*256 8Kb
DEFCFISegN3 EQU 007EH   ; CFISegN3+1 127
DEFCFISegS3 EQU 0100H   ; CFISegS3*256 64Kb
DEFCFISegN4 EQU 0007H   ; CFISegN4+1 8
DEFCFISegS4 EQU 0020H   ; CFISegS4*256 8Kb
$ENDIF

$IF M55
;SIEMENS M55 lg2 Sw10
;FlashID: 0001/227E-2212-2200
;Flash Size: 16Mb, WriteBuffer: 32 bytes
;Region(1): Blocks 256, Size 64Kb
;RAM Size: 512Kb
;Start EEPROM segments at addres 0xFC0000
DEFFlashSize  EQU 01000H     ; 16Mb
DEFCFISegs  EQU 01H
DEFCFISegN1 EQU 007FH   ; CFISegN1+1
DEFCFISegS1 EQU 0100H   ; CFISegS1*256 128Kb
$ENDIF

$IF C55
;C55 lg91
;FlashID: 0089/0017
;Size: 8Mb, WriteBuffer: 32 bytes
;Region(1): Blocks 64, Size 128Kb
DEFFlashSize  EQU 0800H     ; 8Mb
DEFCFISegs  EQU 01H
DEFCFISegN1 EQU 003FH   ; CFISegN1+1
DEFCFISegS1 EQU 0200H   ; CFISegS1*256 128Kb
$ENDIF

$IF A55
;A55 FlashID: 0089/0017
;Size: 8Mb, WriteBuffer: 32 bytes
;Region(1): Blocks 64, Size 128Kb
;RAM Size: 512Kb
DEFFlashSize  EQU 0800H     ; 8Mb
DEFCFISegs  EQU 01H
DEFCFISegN1 EQU 003FH   ; CFISegN1+1
DEFCFISegS1 EQU 0200H   ; CFISegS1*256 128Kb
$ENDIF

$IF A50
;SIEMENS A50
;FlashID: 0020/88BA
;Flash Size: 4Mb, WriteBuffer: 32 bytes
;Start EEPROM segments at addres 0xBF0000
DEFFlashSize  EQU 0400H     ; 4Mb
DEFCFISegs  EQU 01H
DEFCFISegN1 EQU 001FH   ; CFISegN1+1
DEFCFISegS1 EQU 0200H   ; CFISegS1*256 128Kb
$ENDIF


Boot4          Section Code    Word  At  200h

a7xboot4     Proc    near

                mov     DPP0, #0  ; assume dpp0: 0 (page 0x0)
                mov     DPP3, #3  ; assume dpp1: 3 (page 0xC000)
;                bclr    ROMEN
;                               diswdt
;                mov     DPP0, #0  ; assume dpp0: 0 (page 0x0)
;                               mov             CP, #0FC00h
;                mov     DPP0, #0  ; assume dpp0: 0 (page 0x0)
;                mov     DPP1, #3  ; assume dpp1: 3 (page 0xC000)
;                mov     DPP2, #80h ; assume dpp2: 80h (page 0x200000)
;                einit
$IF ENABLE_INT3
                mov     r1, #T3INT
                mov     r2, #0FAh
                mov     r3, #Int_T3
                mov     [r1+#0], r2
                mov     [r1+#2], r3
                bset    IEN
$ENDIF
$IF M55
                mov     P8, #0FFFFh
                mov     DP8, #0FFFFh
$ENDIF
$IF A70 or A75 or AX75
                mov     word_FF38, #10h
$IF A75 or AX75
                mov     CCM4, #20h
$ENDIF
$IF A70
                mov     CCM4, #14h
$ENDIF
$ENDIF
                call    Read_FlashID_FSN
                mov     r4, #5650h ;'PV'
                call    Send_r4
                mov     r3, FlashSize
                mov     DPP1, #0E8h  ;0E8h<<14=0x3A0000
                jb      r3.12, loc_a16m
                mov     DPP1, #2E8h  ;2E8h<<14=0xBA0000
loc_a16m:
                call    FindEELITE_
SendOkAndNextCmd:
                mov     r4, #4B4Fh ;'OK'
SendR4AndNextCmd:
                call    Send_r4
Next_cmd:
                call    Rx_rl3
                cmp     rl3, #52h ; 'R' ReadData
                jmp     cc_Z, Cmd_R
                cmp     rl3, #46h ; 'F' FlashWriteSeg
                jmp     cc_Z, Cmd_F
                cmp     rl3, #49h ; 'I' FlashInfo
                jmp     cc_Z, Cmd_I
                cmp     rl3, #54h ; 'T' Terminate
                jmp     cc_Z, Cmd_T
                cmp     rl3, #4Ah ; 'J' Joke
                jmp     cc_Z, Cmd_J
                cmp     rl3, #42h ; 'B' Baud
                jmp     cc_Z, Cmd_B
                cmp     rl3, #58h ; 'X' Test
                jmp     cc_Z, Cmd_X
                cmp     rl3, #47h ; 'G' Go
                jmp     cc_Z, Cmd_G
                mov     r4, #4355h ;#aUnknownCommand
                cmp     rl3, #41h ; 'A'
                jmp     cc_NZ, SendR4AndNextCmd
                mov     rl3, #52h ;'R'
SendRl3AndNextCmd:
                call    Tx_rl3
                jmp     Next_cmd
; --------------- S U B R O U T I N E ---------------------------------------
Cmd_G:
                call    Rx_r6r7
                calls   0,#GoSub
                jmp     SendR4AndNextCmd
GoSub:
                push    r6
                push    r7
                rets
; --------------- S U B R O U T I N E ---------------------------------------
Cmd_T:
                mov     r4, #4B4Fh ;'OK'
                call    Send_r4
                srst
Tx_rl2:
                mov     rl3, rl2
                jmp     Tx_rl3
; --------------- S U B R O U T I N E ---------------------------------------
Cmd_B:
                call    Rx_r1_r7
                extr    #2
$IF AX75 or A75 or A70
                mov     PP0, r1
                mov     PP1, r7
$ELSE
                mov     S0BG, r1
                mov     word_FEB6, r7
$ENDIF
                call    Rx_rl3
                call    Tx_rl3
                jmp     SendOkAndNextCmd
; --------------- S U B R O U T I N E ---------------------------------------
EntryNotFound:
                mov     r4, #4645h  ; "Entry not Found"
                jmp     SendR4AndNextCmd
; --------------- S U B R O U T I N E ---------------------------------------
Rx_r1_r7:
                call    Rx_rl3
                mov     r1, r3
                call    Rx_rl3
                mov     rh1, rl3
                call    Rx_rl3
                mov     r7, r3
                call    Rx_rl3
                mov     rh7, rl3
                ret
Cmd_J:
                call    Rx_r1_r7
                call    FindEEPblk ; Use: r0, r2. r1 - num, r7 - len. r4:r5 = addr
                jmp     cc_Z, EntryNotFound  ;Z=1 "Entry not Found"
                mov     rl3, #4Eh       ; 'N'
                call    Tx_rl3
                mov     rl3, rh0        ; EEP ver
                call    Tx_rl3
                xor     r6, r6
                jmp     SendRamBuf      ; r4:r5=addr, r6:r7=size
; --------------- S U B R O U T I N E ---------------------------------------
Cmd_I:
                xor     r4, r4
                mov     r5, #SegEELITE
                xor     r6, r6
                mov     r7, #40h
                jmp     SendRamBuf     ; r4:r5=addr, r6:r7=size
; --------------- S U B R O U T I N E ---------------------------------------
Cmd_X:
                call    Rx_r4r5_r6r7
                call    Setr1r5 ; r4:r5 -> r1:r5
                mov     DPP1, r1
                add     r5, #4000h
                xor     r4, r4  ; CRC=0
loc_wrx1:
                mov     r0, r6
                or      r0, r7
                jmp     cc_Z, SendR4AndNextCmd ; SendCRC r4
                call    Rx_rl3
                mov     [r5], rl3
                mov     rl3, [r5+]
                xor     rl4, rl3
                add     rh4, rl3
                sub     r7, #1
                subc    r6, #0
                jnb     r5.14, loc_wrx1
                add     DPP1, #1
                mov     r5, #4000h
                jmp     loc_wrx1
; ---------------------------------------------------------------------------
Send_R4:
                mov     rl3, rl4
                call    Tx_rl3
                mov     rl3, rh4
$IF A70 or A75 or AX75
Tx_rl3:
                bclr    S0EIR
                extr    #1
                movbz   PP3, rl3
loc_9C4:
                jnb     S0EIR, loc_9C4
                ret

Rx_rl3:
                jnb     SSCTIR, Rx_rl3
                bclr    SSCTIR
                extr    #1
                movbz   r3, byte_F040
                ret
$IF ENABLE_INT3
Int_T3:
                bmovn   T2CON.9, T2CON.9
                extr    #1
                mov     word_F0C8, #632Ch
                reti
$ENDIF
$ELSE
Tx_rl3:
                bclr    S0TIR
                movbz   S0TBUF, rl3
loc_866:
                jnb     S0TIR, loc_866
                ret
Rx_rl3:
                jnb     S0RIR, Rx_rl3
                bclr    S0RIR
                movbz   r3, S0RBUF
                ret
$IF ENABLE_INT3
Int_T3:
                bmovn   P4.1, P4.1
$IF A50
                mov     T3, #0C62h
$ELSE
                mov     T3, #632Ch
                bmovn   P4.2, P4.2
$ENDIF
                reti
$ENDIF
$ENDIF
; ---------------------------------------------------------------------------
Rx_r4r5_r6r7:
                xor     r4, r4
                call    Rx_rl3
                mov     rl4, rl3
                call    Rx_rl3
                mov     rh5, rl3
                call    Rx_rl3
                mov     rl5, rl3
Rx_r6r7:
                xor     r6, r6
                call    Rx_rl3
                mov     rl6, rl3
                call    Rx_rl3
                mov     rh7, rl3
                call    Rx_rl3
                mov     rl7, rl3
                                ret
; --------------- S U B R O U T I N E ---------------------------------------
FindEELITE:
                mov     DPP1, SegEELITE ; assume dpp1: 1E8h (page 0x7A0000);r0
FindEELITE_:
find_next_ees:
                mov     r5, #4010h
find_next_eel:
                mov     r3, [r5+#0]
                cmp     r3, #0FEFEh
                jmp     cc_NZ, noeel
                mov     r3, [r5+#2]
                cmp     r3, #04545h
                jmp     cc_NZ, noeel
                mov     r3, [r5+#4]
$IF A50
                cmp     r3, #05546h
                jmp     cc_NZ, noeel
                mov     r3, [r5+#6]
                cmp     r3, #04C4Ch
$ELSE
                cmp     r3, #0494Ch
                jmp     cc_NZ, noeel
                mov     r3, [r5+#6]
                cmp     r3, #04554h
$ENDIF
                jmp     cc_Z, find_eeilte_ok
noeel:
                add     r5, #70h
                jb      r5.7, find_next_eel
                add     DPP1, #1
                mov     r3, DPP1
                and     r3, #03FFh      ;03FFh<<14=0xFFC000
                jmp     cc_NZ, find_next_ees
find_eeilte_ok:
                mov     r3, #SegEELITE
                mov     [r3], DPP1
                or      r3, r3
                ret                    ;NZ -> Ok, Z=1  -> "Entry not Found"
; ---------------------------------------------------------------------------
; r1 - num
; r7 - len
; Out:
; NZ -> Ok, r4:r5 addr, rh0 = ver
; Z=1  -> "Entry not Found"
FindEEPblk:
;                mov     r3, SegEELITE
                call    FindEELITE
;                mov     DPP1, r3 ; assume dpp1: 1E8h (page 0x7A0000);r0
;                or      r3, r3
                jmp     cc_Z, loc_noeel
                mov     r5, #5000h
find_next_addr:
                mov     r0, [r5]          ; ID + EEP ver
                cmp     rl0, #0FCh
                jmp     cc_NZ, noblkeep
                mov     r3, [r5+#02h]       ; EEP len
                cmp     r3, r7
                jmp     cc_NZ, noblkeep
                mov     r3, [r5+#08h]       ; EEP number
                cmp     r3, r1
                jmp     cc_NZ, noblkeep
                mov     r3, [r5+#0Ah]      ; ID 00FCh
                cmp     r3, #0FC00h
                jmp     cc_NZ, noblkeep
                mov     r4, [r5+#06h]       ; seg
                mov     r5, [r5+#04h]       ; off
                and     r4, #000FFh
                ret                    ;NZ -> Ok, Z=1  -> "Entry not Found"
noblkeep:
                add     r5, #4
                cmp     r5, #07FF5h    ;8000h-12=07FF4h
                jmp     cc_C, find_next_addr
                add     DPP1, #1
                mov     r5, #4000h
loc_tstad1:
                mov     r3, DPP1
                and     r3, #003Fh     ;3Fh<<14=0xFC000+0x4000=0x100000>>14=0x40
                jmp     cc_NZ, find_next_addr
yesblkeep:
                or      r3, r3         ;NZ(Z=0) -> Ok
loc_noeel:
                ret                    ;Z=1 -> "Entry not Found"
; --------------- S U B R O U T I N E ---------------------------------------
Cmd_F:
                call    Rx_rl3
                mov     rh1, rl3
                call    Rx_rl3
                mov     rl1, rl3
                call    Test_FlashPar
                jmp     cc_Z, SendRl3AndNextCmd
                call    ClearFlashSeg
                call    Tx_rl2
                call    RxBlkToBufRam
                call    ClearFlashSegTest
                mov     r3, r7
                call    Tx_rl3
                mov     rl3, rh7
                call    Tx_rl3
                call    WriteFlashBlk
                call    SetBaseSegFlash
                call    SecSiFlashExit          ; call    FlashExit
                call    Calk_CRC
                jmp     SendR4AndNextCmd        ; Next_cmd
; --------------- S U B R O U T I N E ---------------------------------------
SetBaseSegFlash:
                mov     r5, r1       ;0FA0h
                shr     r5, #2       ;0FA0h>>2=0x3E8
                mov     DPP1, r5     ;0x3E8<<14=0xFA0000
                mov     r5, r1       ;0FA0h
                shl     r5, #0Ch     ;0FA0h<<12=0x0000
                and     r5, #03FFFh   ;0x4000&0x7FFF=0x4000
                add     r5, #04000h
                ret
; --------------- S U B R O U T I N E ---------------------------------------
Test_FlashPar:
                mov     r0, r1
                sub     r2, r2
                mov     r3, #FlashSize  ;=800h =400h
                mov     r8, #1000h
                sub     r8, [r3]      ;1000h-0800h=0800h 1000h-0400h=0C00h
;$IF A70 or A75 or AX75
                cmp     r8, #0801h
                jmp     cc_C, loc_above8meg
                mov     r8, #0800h
loc_above8meg:
;$ENDIF
                sub     r0, r8        ;0FA0h-0800h=07A0h 0BA0h-0800h=03A0h
                jmp     cc_C, calk_reg_err
                mov     r3, #CFISegs
                movb    rl5, [r3+] ;CFISegs
calk_reg_x1:
                mov     r8, [r3+]  ;CFISegN1 3Fh
                add     r8, #1     ;40h
                mov     r2, [r3+]  ;CFISegS1 =200h
                shr     r2, #4     ;200h>>4=20h
calk_reg_x2:
                sub     r0, r2     ; 7A0h/20h=0x3D
                jmp     cc_C, calk_reg_ok
                sub     r8, #1
                jmp     cc_NZ, calk_reg_x2
                sub     rl5, #1
                jmp     cc_NZ, calk_reg_x1
calk_reg_err:
                mov     r3, #0ffh
                sub     r2, r2
                ret
calk_reg_ok:
                mov     r3, r2
$IF AX75
                mov     CCM4, #20h
                cmp     r1, #200h
                jmp     cc_NC, calk_reg_end
                mov     CCM4, #0
                add     r1, #800h
$ENDIF
;$IF A75
;                mov     CCM4, #20h
;                cmp     r1, #200h
;                jmp     cc_NC, calk_reg_end
;                mov     CCM4, #0
;                add     r1, #800h
;$ENDIF
$IF A65
                mov     P8, #0
                mov     DP8, #1801h
                cmp     r1, #200h
                jmp     cc_NC, calk_reg_end
                mov     P8, #0
                mov     DP8, #0
                add     r1, #800h
$ENDIF
$IF M55
                cmp     r1, #200h
                jmp     cc_NC, loc_m55sf1
                extr    #2
                mov     word_F134, #9002h
                mov     word_F136, #2
                mov     P8, #1000h
                mov     DP8, #1800h
                add     r1, #800h
                jmp     calk_reg_end
loc_m55sf1:
                extr    #3
                mov     word_F134, #9802h
                mov     word_F136, #802h
                mov     word_F13E, #66h
                mov     P8, #0FFFFh
                mov     DP8, #0FFFFh
$ENDIF
calk_reg_end:
                cmp     r2, #0
                ret
; --------------- S U B R O U T I N E ---------------------------------------
; r2 - кол-во байт по 4 кило
RxBlkToBufRam:
                call    SetBaseSegFlash
                push    r2
                mov     DPP1, #8h
                xor     r7, r7
loc_rxb1:
                mov     r10, #01000h
loc_rxb2:
                call    Rx_rl3
                mov     [r5], rl3
                mov     rl3, [r5+]
                xor     rl7, rl3
                add     rh7, rl3
                sub     r10, #1
                jmp     cc_NZ, loc_rxb2
                cmp     r5, #8000h
                jmp     cc_C, loc_rxb3
                add     DPP1, #1
                mov     r5, #04000h
loc_rxb3:
                sub     r2, #1
                jmp     cc_NZ, loc_rxb1
                pop     r2
                ret
; --------------- S U B R O U T I N E ---------------------------------------
Calk_CRC:
                call    SetBaseSegFlash
                mov     r4, #0
                mov     r3, #0
loc_clkcrc1:
                mov     r7, #1000h
loc_clkcrc2:
                mov     r0, [r5+]
                mov     r1, [r5+]
                add     r3, r0
                addc    r4, r1
                sub     r7, #4h
                jmp     cc_NZ, loc_clkcrc2
                jnb     r5.15, loc_clkcrc3
                add     DPP1, #1
                mov     r5, #4000h
loc_clkcrc3:
                sub     r2, #1
                jmp     cc_NZ, loc_clkcrc1
Send_r1_r0:
                call    Tx_rl3
                mov     rl3, rh3
;                call    Tx_rl3
;                mov     rl3, rh0
;                call    Tx_rl3
;                mov     rl3, rl0
                jmp     Tx_rl3
; --------------- S U B R O U T I N E ---------------------------------------
WriteFlashBlk:
                call    SetBaseSegFlash
                push    r2
                mov     DPP2, #8h        ; assume dpp2: 8 (page 0x20000)
                mov     r8, r5
                xor     r8, #0C000h
loc_wrblk1:
                call    WriteFlashByte   ;r8 - buf ram, r5 - off flash
                jnb     r5.15, loc_wrblk3
                add     DPP1, #1
                mov     r5, #04000h
                add     DPP2, #1
                mov     r8, #08000h
loc_wrblk3:
                sub     r2, #1
                jmp     cc_NZ, loc_wrblk1
                pop     r2
                ret
; --------------- S U B R O U T I N E ---------------------------------------
; r4:r5 -> r1:r5
Setr1r5:
                mov     r1, r5
                mov     r3, r4
                shl     r3, #2
                shr     r1, #14
                add     r1, r3
                and     r5, #3FFFh
                ret
; --------------- S U B R O U T I N E ---------------------------------------
Cmd_R:
                call    Rx_r4r5_r6r7
$IF AX75
                mov     CCM4, #20h
                cmp     r4, #20h
                jmp     cc_NC, SendRamBuf
                mov     CCM4, #0
                add     r4, #80h
$ENDIF
$IF A65
                cmp     r4, #20h
                jmp     cc_C, loc_A65_low
                mov     P8, #0
                mov     DP8, #1801h
                jmp     SendRamBuf
loc_A65_low:
                mov     P8, #0
                mov     DP8, #0
                add     r4, #80h
$ENDIF
$IF M55
                cmp     r4, #20h
                jmp     cc_C, loc_M55_low
                extr    #3
                mov     word_F134, #09802h
                mov     word_F136, #00802h
                mov     word_F13E, #00066h
                mov     P8, #0FFFFh
                mov     DP8, #0FFFFh
                jmp     SendRamBuf
loc_M55_low:
                extr    #2
                mov     word_F134, #09002h
                mov     word_F136, #00002h
                mov     P8, #1000h
                mov     DP8, #1800h
                add     r4, #80h
$ENDIF
; --------------- S U B R O U T I N E ---------------------------------------
; r4:r5=addr, r6:r7=size
SendRamBuf:
                call    Setr1r5 ; r4:r5 -> r1:r5
                xor     r4, r4  ; CRC=0
loc_rdx2:
                mov     r0, r6
                or      r0, r7
                jmp     cc_Z, SendR4AndNextCmd ; SendCRC r4
                extp    r1, #1
                mov     rl3, [r5+]
                call    Tx_rl3
                xor     rl4, rl3
                add     rh4, rl3
                sub     r7, #1
                subc    r6, #0
                jnb     r5.14, loc_rdx2
                mov     r5, #0
                add     r1, #1
                jmp     loc_rdx2
; --------------- S U B R O U T I N E ---------------------------------------
Send_str_r4:
                mov     rl3, [r4+]
                cmp     rl3, #0
                jmp     cc_Z, locret_9F6
                call    Tx_rl3
                jmp     Send_str_r4
locret_9F6:
                ret
; --------------- S U B R O U T I N E ---------------------------------------
;r8 - buf ram, r5 - off flash
WriteFlashByte:
                mov     r7, #1000h
                mov     r0, r14
$IF WriteBuffered
                cmp     rl0, #2Ch
                jmp     cc_Z, WrIntel
;$IF S55
                cmp     r0, #5489h ;FlashID: 0089/8854 (0089/0016)
                jmp     cc_Z, WrIntel
;$ENDIF
$ENDIF
                cmp     rl0, #01h
$IF WriteBuffered
                jmp     cc_NZ, WrIntelBuffered
$ELSE
                jmp     cc_NZ, WrIntel
$ENDIF
WriteAmd:
                mov     r0, #0A020h
                call    FlashCmd
loc_wramd1:
                mov     [r5], rh0

                mov     r4, [r8+]
                mov     [r5], r4
loc_tst_wr1:
                mov     r3, [r5]
                cmp     r3, r4
                jmp     cc_NZ, loc_tst_wr1
                add     r5, #2
                sub     r7, #2
                jmp     cc_NZ, loc_wramd1
                ret
; ---------------------------------------------------------------------------
$IF WriteBuffered
WrIntelBuffered:
;                extp    #0, #1
                movbz    r3, CFIBuf
                cmp     rl3, #05h
                jmp     cc_C, WrIntel
                mov     rl0, #0E8h    ;Buffered Program
                mov     [r5], rl0
;                mov     rh3,#0
                sub     r3, #1
loc_wrb1:
                nop
                nop
                mov     rl0, [r5]
                jnb     r0.7, loc_wrb1
                mov     r6, r5
                mov     [r5], rl3   ; word count - 1
loc_wrb2:
                mov     r4, [r8+]
                mov     [r5], r4
                sub     r7, #2
                add     r5, #2
                sub     r3, #1
;                cmp     rl3, #0FFh
;                jmp     cc_NZ, loc_wrb2
                jnb     r3.15, loc_wrb2
                mov     r0, #0D0h       ;Program/Erase Resume
                mov     [r6], rl0
                nop
                mov     r0, #070h      ;Read Status Register
                mov     [r6], rl0
loc_wrb3:
                mov     rl0, [r6]
                jnb     r0.7, loc_wrb3
;                mov     [r6], rh0       ;FF Read Array
                cmp     r7, #0h
                jmp     cc_NZ, WrIntelBuffered
                ret
$ENDIF
; ---------------------------------------------------------------------------
WrIntel:
                mov     r3, #040h   ;40 or 10 Word Program
                mov     r4, [r8+]
                mov     [r5], rl3
                nop
                nop
                mov     [r5], r4
                call    IntelWaitClr
                add     r5, #2
                sub     r7, #2
                jmp     cc_NZ, WrIntel
                ret
; --------------- S U B R O U T I N E ---------------------------------------
ClearFlashSeg:
                call    SetBaseSegFlash
                mov     r0, r14
                cmp     rl0, #01h
                jmp     cc_NZ, IntelClrSeg
AmdClrSeg:
                mov     r0, #03080h ; 80 Sector Erase
                call    FlashCmd
                mov     04AAAh, rl3 ; 800AAAh=AAh
                mov     04555h, rh3 ; 800555h=55h
                mov     [r5], rh0   ; 30 Sector Erase
                ret
ClearFlashSegTest:
                call    SetBaseSegFlash
                mov     r0, r14
                cmp     rl0, #01h
                jmp     cc_NZ, IntelClrSegTest
AmdClrSegTest:
                mov     r3,#7
loc_A32:
                mov     r0, [r5]
                add     r0, #1
                jmp     cc_NZ, AmdClrSegTest
                sub     r3, #1
                jmp     cc_NZ, loc_A32
AmdUnlockExit:
                mov     rl0, #090h
                mov     [r5], rl0
                mov     rl0, #000h
                mov     [r5], rl0
                ret
; ---------------------------------------------------------------------------
IntelClrSeg:
                mov     rl3, #060h
                mov     [r5], rl3   ;60 Unlock Block
                mov     rl3, #0D0h
                mov     [r5], rl3   ;D0 Unlock Block
                call    IntelWaitClr
                mov     rl3, #020h
                mov     [r5], rl3   ;20 Block Erase
                mov     rl3, #0D0h
                mov     [r5], rl3   ;D0 Block Erase
                ret
; ---------------
IntelClrSegTest:
                mov     rl3, #070h
                mov     [r5], rl3   ;70 Read Status Register
IntelWaitClr:
                nop
                nop
                mov     rl3, [r5]
                jnb     r3.7, IntelWaitClr
                mov     rl3, #050h
                mov     [r5], rl3   ;50 Crear
                mov     rl3, #0FFh
                mov     [r5], rl3   ;FF
                ret
; --------------- S U B R O U T I N E ---------------------------------------
SecSiFlashExit:
                mov     r0, r14
                cmp     rl0, #01h
                jmp     cc_NZ, IntelReset
                mov     rl0, #090h
                call    FlashCmd    ; 800AAAh=90h
                mov     rl0, #000h
                mov     04000h, rl0 ; 800AAAh=00h
                ret
; --------------- S U B R O U T I N E ---------------------------------------
FlashCmd:
                mov     r3, #055AAh
                mov     04AAAh, rl3 ; 800AAAh=AAh
                mov     04555h, rh3 ; 800555h=55h
FlashCmdL:
                mov     04AAAh, rl0 ; 800AAAh=rl0
                ret
; --------------- S U B R O U T I N E ---------------------------------------

Read_FlashID_FSN:
;                mov     DPP0, #0h    ; assume dpp0: 0 (page 0x0)
                mov     r2, #4000h
                mov     r10, #FlashID ;+#4=#FSN
$IF S55
;                push    BUSCON1
;                push    ADDRSEL1
;                mov     ADDRSEL1, #400Ah
;                mov     BUSCON1, #15AFh
                mov     DPP1, #100h  ; assume dpp1: 100h (page 0x400000)
                mov     r0, #90h
                call    FlashCmd
                mov     r0, [r2+#0]  ; 00 20
                mov     r5, [r2+#2]  ; 88 BA
                mov     [r10+#4], r0 ;FlashID+#4
                mov     [r10+#6], r5 ;FlashID+#6
                call    FlashExit_
;                pop     ADDRSEL1
;                pop     BUSCON1
;FlashID: 0089/8854 (0089/0016)
;Flash Size: 12Mb, WriteBuffer: 32 bytes
;Region(1): Blocks 32, Size 128Kb
;Region(2): Blocks 127, Size 64Kb
;Region(3): Blocks 8, Size 8Kb
$ENDIF
                mov     DPP1, #200h  ; assume dpp1: 200h (page 0x800000)
                mov     r0, #90h
                call    FlashCmd     ; 800AAAh=90h
                mov     r4, [r2+#0]  ; 00 89 ; 00 20 FlashID: 0020/8810 (0020/88BA)
                mov     r5, [r2+#2]  ; 00 17 ; 88 10
                mov     [r10+#0], r4 ;FlashID+#0
                mov     [r10+#2], r5 ;FlashID+#2
                mov     rl1, rl4  ; 89 ; 2C
                mov     rh1, rl5  ; 17 ; 17
                mov     r14, r1   ; 1789h ; 1020h ; 7E01h ; 5489h
                mov     r2, #4102h ; addr FSN Intel
                mov     r6, #410Ah ; addr BCDIMEI Intel
                cmp     rl1, #01h ; AMD?
                jmp     cc_NZ,IntelFSN  ; Intel
AmdID2:
                mov     r2, #4000h  ; addr FSN AMD
                mov     r3, [r2+#1Ch]
                mov     [r10+#4], r3 ;FlashID+#4
                mov     r3, [r2+#1Eh]
                mov     [r10+#6], r3 ;FlashID+#6
;                mov     rl0, #0F0h
                call    AmdReset    ; 800000h=F0h
                mov     r6, #4010h  ; addr BCDIMEI AMD
                mov     rl0, #088h
                call    FlashCmd    ; 800AAAh=88h
IntelFSN:
                xor     r4, [r2+]
                xor     r5, [r2+]
                rol     r5, #4
                ror     r4, #5
                xor     r4, [r2+]
                xor     r5, [r2+]
                rol     r5, #2
                ror     r4, #3
                mov     [r10+#8], r4    ;FSN
                mov     [r10+#10], r5   ;FSN+#2
                mov     rh0,#4
                mov     r10, #BCDIMEI
                mov     r2, r6
forSaveIMEI:
                mov     r3, [r2+]
                mov     [r10], r3
                add     r10,#2
                sub     rh0,#1
                jmp     cc_NZ, forSaveIMEI
                call    SecSiFlashExit
$IF S55
                mov     r2, #FlashID
                mov     r1, [r2+]
                mov     r3, [r2+]
                xor     r1, [r2+]
                xor     r3, [r2+]
                or      r1, r3
                jmp     cc_Z, ReadCFI
;                mov     ADDRSEL1, #400Ah
;                mov     BUSCON1, #15AFh
;;                mov     BUSCON4, #43Eh
                mov     DPP1, #100h  ; assume dpp1: 200h (page 0x800000)
                call    ReadCFI
                mov     DPP1, #200h  ; assume dpp1: 100h (page 0x400000)
                cmp     rl1, #0
                jmp     cc_NZ, ReadCFI
                mov     r6, r10
                call    ReadCFI_
                jmp     cc_NZ, rd_cfi_end
                mov     r1, [r10]
                add     r3, r1
                mov     [r10], r3  ;FlashSize
                mov     rl2, #58h  ;2Ch<<1=58h
                mov     r1, [r2+]  ;+2ChWord: Number of erase block regions
                cmp     rl1, #0
                jmp     cc_Z, rd_cfi_end
                mov     r10, #CFISegs
                mov     rl3, [r10]
                add     r3, r1
                mov     [r10], rl3 ;CFISegs
                mov     r10, r6
                jmp     forSaveCFIsegs
$ENDIF
; --------------- S U B R O U T I N E ---------------------------------------
ReadCFI:
                call    ReadCFI_
                jmp     cc_NZ, rd_cfi_end
                mov     [r10], r3  ;FlashSizeFlash
                add     r10, #2
                add     r2, #4     ;+29hWord
                mov     r3, [r2+]  ;+2AhWord:03h "n" such that maximum number of bytes in write buffer = 2^n
                sub     rl3, #1
                mov     r1, #1
                shl     r1, r3
                mov     [r10], rl1 ;CFIBuf
                add     r2, #2     ;+2BhWord
                add     r10, #1
                mov     r1, [r2+]  ;+2ChWord: Number of erase block regions
                mov     [r10], rl1 ;CFISegs
                add     r10, #1
                cmp     rl1, #0
                jmp     cc_Z, rd_cfi_end
forSaveCFIsegs:
                shl     r1, #2
forSaveCFI:
                mov     r3, [r2+]
                mov     [r10], rl3
                add     r10, #1
                sub     rl1, #1
                jmp     cc_NZ, forSaveCFI
FlashExit:
rd_cfi_end:
                mov     r0, r14
FlashExit_:
                cmp     rl0, #01h
                jmp     cc_Z, AmdReset
IntelReset:
                mov     rl0, #0FFh
                jmp     FlashCmdEnd
AmdReset:
                mov     rl0, #0F0h
FlashCmdEnd:
                mov     04000h, rl0 ; 800000h=rl0
                ret
; --------------- S U B R O U T I N E ---------------------------------------
ReadCFI_:
                mov     r2, #40AAh
                mov     rl0, #98h
                mov     [r2], rl0
                mov     r2, #4020h ;+10hWord
                mov     r1, r2     ;Flag error
                mov     r3, [r2+]
                cmp     rl3, #051h ;'Q'
                jmp     cc_NZ, rd_cfi_err
                mov     r3, [r2+]
                cmp     rl3, #052h ;'R'
                jmp     cc_NZ, rd_cfi_err
                mov     r3, [r2+]
                cmp     rl3, #059h ;'Y'
                jmp     cc_NZ, rd_cfi_err
                mov     rl2, #4Eh  ;4Eh>>1=27h
                mov     r10, #FlashSize
                mov     r1, [r2+]  ;+27hWord:17h "n" such that device size = 2^n in number of bytes
                sub     r1, #12
                mov     r3, #1
                shl     r3, r1
                sub     r1, r1
rd_cfi_err:
                ret

a7xboot4        endp
; --------------- D A T A ---------------------------------------
SegEELITE:      dw    0 ; DPPEEPS
;RamSize:        dw    0 ;
FlashID:        dw    0 ;
                dw    0 ;
                dw    0 ;
                dw    0 ;
FSN:            dw    03412h ;
                dw    07856h ;
BCDIMEI:        dw    04321h ;
                dw    08765h ;
                dw    02109h;
                dw    0FF43h;
FlashSize:        dw    DEFFlashSize; 2^FlashSize Flash
;CFIBus:         db    1; 1=16bit
CFIBuf:         db    0; 2^CFIBuf
CFISegs:        db    DEFCFISegs
CFISegN1:       dw    DEFCFISegN1 ; CFISegN1+1
CFISegS1:       dw    DEFCFISegS1 ; CFISegS1*256
$IF S55
CFISegN2:       dw    DEFCFISegN2 ; CFISegN1+1
CFISegS2:       dw    DEFCFISegS2 ; CFISegS1*256
CFISegN3:       dw    DEFCFISegN3 ; CFISegN1+1
CFISegS3:       dw    DEFCFISegS3 ; CFISegS1*256
CFISegN4:       dw    DEFCFISegN4 ; CFISegN1+1
CFISegS4:       dw    DEFCFISegS4 ; CFISegS1*256
$ENDIF

Boot4           EndS

END
