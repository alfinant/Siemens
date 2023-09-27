1. Client Hello (0x01) SSL3_ST_CW_CLNT_HELLO
2. Server Hello (0x02) SSL3_ST_CR_SRVR_HELLO
3. Certificate  (0x0B) SSL3_ST_CR_CERT
4. Server Key Exchange (0x0C) SSL3_ST_CR_KEY_EXCH (опционально)
5. //CertificateRequest SSL3_ST_CR_CERT_REQ
6. //SSL3_ST_CW_CERT
7. Server Hello Done (0x0E) SSL3_ST_CR_SRVR_DONE
8. Client Key Exchange (0x10)
9. //SSL3_ST_CW_CERT_VRFY_A
10. Change Cipher Spec (0x14) SSL3_ST_CW_CHANGE_A 