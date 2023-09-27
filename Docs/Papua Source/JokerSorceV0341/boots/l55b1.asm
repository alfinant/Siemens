; ---------------------------------------------------------------------------
; START BOOT.  PV` PapuaSoft & PapuaHard 2005
; A55=C55=S55...
; A57=SX1...
; A60=A65=CF62=MC60=C60....
; A70=A75=AX75...
; ---------------------------------------------------------------------------
$Mod167

$IF NOT TINY
$SEGMENTED
$ENDIF

$SET (AX75=0)
$SET (A75=0)
$SET (A70=0)
$SET (A65=0)
$SET (A60=0)
$SET (S55=0) ;+
$SET (M55=0)
$SET (C55=1) ;=A55!
$SET (A57=0) ;=SX1!
$SET (A50=0) ;+
; Swup
$SET (XA55=0) ;+
$SET (XA57=0)  ; not use
$SET (XM55=0)  ;=A60  not use
$SET (XA60=0) ;+
$SET (XA70=0) ;+



$INCLUDE (reg167n.a66)

T3INT  EQU 08CH
ODP2   DEFR 0F1C2h
ODP3   DEFR 0F1C6h
word_F014 DEFR 0F014h
word_F114 DEFR 0F114h
;word_F132 DEFR 0F132h
;word_F134 DEFR 0F134h
;word_F136 DEFR 0F136h
;word_F13E DEFR 0F13Eh
word_F1BE DEFR 0F1BEh
;byte_F040 EQU 0F040h
;word_F0C8 EQU 0F0C8h

Boot1          Section Code    Word  At  0FA00h

l55boot1     Proc    near

                diswdt
                mov     DPP0, #0  ; assume dpp0: 0 (page 0x0)
;                mov     DPP1, #3  ; assume dpp1: 3 (page 0xC000)
;                mov     DPP2, #80h ; assume dpp2: 80h (page 0x200000)
                mov     DPP3, #3 ; assume dpp1: 3 (page 0xC000)
                mov     SP, #0FA00h
                mov     STKUN, #0FA00h
                mov     STKOV, #0F60Ch
                mov     CP, #0FB00h
$IF A50
                mov     SYSCON, #3406h ;1446h=0001 0100 0100 0110 C55=1406h
$ELSE
                mov     SYSCON, #3046h ;1446h=0001 0100 0100 0110 C55=1406h
$ENDIF
$IF A50
                mov     BUSCON0, #5AFh
                mov     ADDRSEL1, #7 ;#806h
                mov     BUSCON1, #4AFh
                mov     ADDRSEL2, #0
                mov     BUSCON2, #0
;                mov     ADDRSEL3, #0
                mov     BUSCON3, #0
;                mov     ADDRSEL4, #0
                mov     BUSCON4, #0
                extr    #3
                mov     word_f134, #8800h
                mov     word_f136, #800h
                mov     word_f13E, #6
                mov     P8, #0
                mov     DP8, #800h
$ENDIF
$IF MT50
                mov     ADDRSEL1, #807h
                mov     ADDRSEL2, #0A009h
                mov     BUSCON1, #5AFh
                mov     BUSCON2, #5AFh
                extr    #3
                mov     word_f134, #0DF65h
                mov     word_f136, #804h
                mov     word_f13E, #6
                mov     P8, #0D092h
                mov     DP8, #0DC6Ah
$ENDIF
$IF A70 or A75 or AX75 or XA70
                mov     BUSCON0, #5ADh
                mov     BUSCON1, #5ADh
                mov     ADDRSEL1, #7
                mov     BUSCON2, #0
                mov     BUSCON3, #0
                mov     BUSCON4, #0
                extr    #4
                mov     ODP3, #10h
                mov     ODP2, #10h
                mov     word_F1BE, #10h
                mov     word_F13E, #66h
$IF AX75 or A70
                mov     word_FF38, #10h
$ENDIF
                mov     CCM4, #20h ;A75=#0,A70=#14h ;swup boot1     mov     CCM4, #0CD00h
$ENDIF ; A70 or A75 or AX75 or XA70
; A55 A57 C55 M55 S55 SX1...
$IF XA55
                mov     BUSCON0, #4BDh ;10010111101b
                mov     BUSCON1, #4BDh
                mov     BUSCON2, #4BDh ;5ADh=v032
                mov     BUSCON3, #0
                mov     BUSCON4, #0
                mov     ADDRSEL2, #7
                extr    #3
                mov     word_F134, #9802h
                mov     word_F136, #802h
                mov     word_F13E, #66h
$ENDIF
$IF XA57 or SX1
                mov     BUSCON0, #5ADh
                mov     BUSCON1, #5ADh
                mov     BUSCON2, #5ADh
                mov     ADDRSEL2, #7
                extr    #3
                mov     word_F134, #9802h
                mov     word_F136, #802h
                mov     word_F13E, #66h
$ENDIF
$IF XA60 or A65 or CF62 or MC60 or C60
                mov     BUSCON0, #5ADh ;5AEh=0101 1010 1110
                mov     ADDRSEL1, #7
                mov     BUSCON1, #5ADh ;4BDh=0100 1011 1101
                mov     BUSCON2, #0
                mov     BUSCON3, #0
                extr    #3
                mov     word_F134, #9802h
                mov     word_F136, #802h
                mov     word_F13E, #66h
                mov     r2, #5AA5h
                mov     200h, r2
                mov     210h, DPP0
                xor     r2, 200h
                jmp     cc_Z, loc_bus1
                mov     BUSCON1, #0
                mov     ADDRSEL2, #7
                mov     BUSCON2, #5ADh; #4BDh
loc_bus1:
                mov     P8, #0
                mov     DP8, #1801h
$ENDIF
$IF C55
                mov     BUSCON0, #4BDh
                mov     ADDRSEL1, #400Ah
                mov     BUSCON1, #4BDh
                mov     ADDRSEL2, #7
                mov     BUSCON2, #4BDh
;                mov     ADDRSEL3, #0
                mov     BUSCON3, #0
                mov     BUSCON4, #0
;                mov     ADDRSEL4, #2000h
                extr    #3
                mov     word_F134, #9002h
                mov     word_F136, #2
                mov     word_F13E, #66h
                mov     P8, #6000h
                mov     DP8, #67C0h
$ENDIF
$IF A60
                mov     BUSCON0, #5ADh
                mov     ADDRSEL1, #07h
                mov     BUSCON1, #5AEh
                mov     BUSCON2, #0
                mov     BUSCON3, #0
                mov     BUSCON4, #0
                extr    #3
                mov     word_F134, #8006h
                mov     word_F136, #06h
                mov     word_F13E, #66h
                mov     P8, #0
                mov     DP8, #7FC1h
                mov     SYSCON, #9446h
$ENDIF
$IF XM55 or M55
                mov     BUSCON0, #5AEh
                mov     ADDRSEL1, #7
                mov     BUSCON1, #4BDh
                mov     BUSCON2, #0
                mov     BUSCON3, #0
                mov     ADDRSEL4, #2000h
                mov     BUSCON4, #52Ch
                extr    #3
                mov     word_F134, #9802h
                mov     word_F136, #802h
                mov     word_F13E, #66h
                mov     r2, #5AA5h
                mov     200h, r2
                mov     210h, DPP0
                xor     r2, 200h
                jmp     cc_Z, loc_bus1
                mov     BUSCON1, #0
                mov     ADDRSEL2, #7
                mov     BUSCON2, #4BDh
loc_bus1:
                mov     P8, r0 ; #0
                mov     DP8, #1801h
$ENDIF
$IF S55 or SL55
                mov     BUSCON0, #5AEh
                mov     ADDRSEL1, #400Ah
                mov     BUSCON1, #15AFh
                mov     ADDRSEL2, #9
                mov     BUSCON2, #5AEh
                mov     BUSCON3, #0
                mov     ADDRSEL4, #2000h
                mov     BUSCON4, #43Eh
                extr    #3
                mov     word_F134, #0D806h
                mov     word_F136, #0806h
                mov     word_F13E, #66h
;               extr    #2
;               mov     word_F014, #0EF0h
;               mov     word_F114, #4AFh
                mov     P6, #124h
                mov     DP6, #71D1h
                mov     P8, #7000h
                mov     DP8, #800h
$ENDIF

; --------------- Timer Init ---------------------------------------

                mov     r1, #T3INT
                mov     r2, #0FAh   ; jmp
                mov     r3, #Int_T3
                mov     [r1], r2
                mov     [r1+#2], r3
                einit

$IF A70 or A75 or AX75 or XA70
                mov     T2CON, #700h
                extr    #1
                mov     word_F0C8, #632Ch ;4844h
                mov     SSCCON, #0C7h
$ELSE
                bset    P4.1
                bset    DP4.1
$IF A50
                mov     T3, #0C62h
$ELSE
                mov     T3, #3188h
$ENDIF
                mov     T3CON, #0C7h
$ENDIF
                mov     T3IC, #10h
                bfldh   PSW, #0F8h, #0
                bset    T3IE
                bset    IEN
;                bclr    ROMEN

; --------------- LOAD NEXT BOOT ---------------------------------------

                movb    rl3, #055h
                callr   Tx_rl3
                callr   Rx_rl3
                movb    rl2, rl3
                callr   Rx_rl3
                movb    rh2, rl3
                mov     r4, #200h
                mov     r5, #0
loc_ldb2:
                callr   Rx_rl3
                xorb    rl3, #5Ah
                movb    [r4], rl3
                xorb    rl5, #5Ah
                movb    rl3, [r4]
                xor     rl5, rl3
                add     r4, #1
                sub     r2, #1
                jmpr    cc_NZ, loc_ldb2
                callr   Rx_rl3
                cmpb    rl5, rl3
                jmpr    cc_NZ, loc_ldbe
                jmps    0, #200h
loc_ldbe:
                movb    rl3, #5Ah ; 'Z'
                callr   Tx_rl3
                srst
$IF A70 or A75 or AX75 or XA70
;------------------------------------------ Int_T3
Int_T3:
                bmovn   T2CON.9, T2CON.9
                extr    #1
                mov     word_F0C8, #632Ch
                reti
;------------------------------------------ Tx_rl3
Tx_rl3:
                bclr    S0EIR
                extr    #1
                movbz   PP3, rl3
Tx_wait:
                jnb     S0EIR, Tx_wait
                ret
;------------------------------------------ Rx_rl3
Rx_rl3:
                jnb     SSCTIR, Rx_rl3
                bclr    SSCTIR
                extr    #1
                movbz   r3, byte_F040
                ret
;------------------------------------------
$ELSE
;------------------------------------------ Int_T3
Int_T3:
                bmovn   P4.1, P4.1
$IF A50
                mov     T3, #0C62h
$ELSE
                mov     T3, #632Ch
                bmovn   P4.2, P4.2
$ENDIF
                reti
;------------------------------------------ Tx_rl3
Tx_rl3:
                bclr    S0TIR
                movbz   S0TBUF, rl3
Tx_wait:
                jnb     S0TIR, Tx_wait
                ret
;------------------------------------------ Rx_rl3
Rx_rl3:
                jnb     S0RIR, Rx_rl3
                bclr    S0RIR
                movbz   r3, S0RBUF
                ret
;------------------------------------------
$ENDIF

l55boot1        endp

Boot1           EndS

END