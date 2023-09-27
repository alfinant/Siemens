            EXTERN ssl_cipher_get_evp
            EXTERN hook_EVP_CipherInit
            EXTERN init_rc2_aes_ciphers
            EXTERN load_aes_idea_cbc_ciphers
            CODE16
            
            ;RSEG    PATCH_NUM_CIPHERS:CODE:ROOT(1)
            ;mov r0,#0x26            	
;-------------------------------------------------------------------------------        
            RSEG    PATCH_SSL_GET_DISABLED:CODE:ROOT(2)
            ldr r0, __mask
            bx lr
            DATA
__mask:     DC32 0xE21E
;-------------------------------------------------------------------------------
            RSEG    PATCH_SSL_CIPHER_GET_EVP:CODE:ROOT(2)
            push {r7, lr}
            ldr r7, __ssl_cipher_get_evp
            blx r7
            pop {r7, pc}
            DATA 
__ssl_cipher_get_evp:
            DC32 ssl_cipher_get_evp
;-------------------------------------------------------------------------------            
            RSEG  PATCH_SSL_LIBRARY_INIT:CODE:ROOT(1)
            bl init_rc2_aes_ciphers
;-------------------------------------------------------------------------------
            RSEG  PATCH_LOAD_CIPHERS:CODE:ROOT(1)
            bl  load_aes_idea_cbc_ciphers
;-------------------------------------------------------------------------------
            RSEG  PATCH_EVP_CIPHERINIT:CODE:ROOT(2)
            ldr r6, __hook_EVP_CipherInit           
            bx r6 
            DATA
__hook_EVP_CipherInit:            
            DC32  hook_EVP_CipherInit
            
            
            END
            
            





