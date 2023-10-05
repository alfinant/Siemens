void __OpenSSLDie(const char *function,int line);
#define __OPENSSL_assert(e)	(void)((e) ? 0 : (__OpenSSLDie(__FUNCTION__, __LINE__),1))

//EVP_DecryptInit - Ошибка адреса!!! На работу патча не влияла, но если бы шифрование было не aes-128,то был бы краш.
//Добавил паттерны(для NEWSGOLD)

#ifdef S75v52
#define malloc (*(void*(*)(unsigned int size))0xA0094B5C)
#define memcpy (*(void*(*)(void *, const void *, size_t))0xA0FC4A10)
#define mfree (*(void(*)(void *))0xA0094948)
#define ClearMemory (*(void(*)(void *dest,int n))0xA0FC49B4)
#define snprintf (*(int(*)(char *buf, int len, const char *str, ...))0xA0FC3731)
#define EVP_add_cipher (*(int(*)(const EVP_CIPHER *c))0xA0E8F2B9) //10 B5 04 1C 00 68 ?? ?? ?? ?? 22 1C 02 21 ?? ?? ?? ?? 00 28 00 D1 10 BD 20 68 +1
#define EVP_CIPHER_get_asn1_iv (*(int(*)(EVP_CIPHER_CTX *c, ASN1_TYPE *type))0xA0E8F143) //F8 B5 06 1C 08 1C 00 24 00 29 ?? ?? 31 68 CD 68 31 +1
#define EVP_CIPHER_set_asn1_iv (*(int(*)(EVP_CIPHER_CTX *c, ASN1_TYPE *type))0xA0E8F215) //0B 1C 00 21 00 2B 80 B5 ?? ?? 01 68 CA 68 01 1C +1
#define EVP_get_cipherbyname  (*(EVP_CIPHER*(*)(const char *name))0xA0E8F33B) //70 BD 80 B5 02 21 ?? ?? ?? ?? 80 BD 80 B5 01 21 ?? ?? ?? ?? 80 BD 80 B5 02 20 +3
#define OBJ_NAME_add  (*(int(*)(const char *name, int type, const char *data)) 0xA0E8F769) //F7 B5 ?? ?? 17 1C 30 68 0C 1C 00 28 ?? ?? ?? ?? ?? ?? 00 28 +1
#define EVP_EncryptInit  (*(void(*)(EVP_CIPHER_CTX *ctx,const EVP_CIPHER *cipher,unsigned char *key,unsigned char *iv))0xA0E8EC11) //70 B5 04 1C 08 1C 11 1C 1A 1C 00 28 ?? ?? 20 60 20 68 01 25 2B 1C 06 69 20 1C B0 47 +1
#define EVP_DecryptInit  (*(void(*)(EVP_CIPHER_CTX *ctx,const EVP_CIPHER *cipher,unsigned char *key,unsigned char *iv))0xA0E8EBEF) //70 B5 04 1C 08 1C 11 1C 1A 1C 00 28 ?? ?? 20 60 20 68 00 25 2B 1C 06 69 20 1C B0 47 +1
#define ssl_cipher_methods ((const EVP_CIPHER**)0xA8E8FC28) //*(53 53 4C 5F 46 5F 53 53 4C 33 5F 47 45 54 5F 53 45 52 56 45 52 5F 44 4F 4E 45 00 00 6B 65 79 20 65 78 70 61 6E 73 69 6F 6E 00 00 00 5E 02 00 00 +0x30) 
#define ssl_digest_methods ((const EVP_MD**)0xA8E8FAC4) //*(53 53 4C 5F 46 5F 53 53 4C 33 5F 47 45 54 5F 53 45 52 56 45 52 5F 44 4F 4E 45 00 00 6B 65 79 20 65 78 70 61 6E 73 69 6F 6E 00 00 00 5E 02 00 00 +0x34) 
#define ssl_comp_methods ((STACK_OF(SSL_COMP)*)0xA8E8FABC) //+ *(?? ?? A8 61 00 28 05 D1 1C 4B 1D 4A 44 A1 50 33 A3 E0 B9 E0 98 E0 00 00 +0x18) + 0x1C
#define sk_find  (*(int(*)(STACK *st, char *data))0xA0F88D95) //01 20 2F B0 F0 BD FF 23 ?? ?? 16 33 +21
#define sk_value (*(char*(*)(STACK *st, int i))0xA0F88D8D) //01 20 2F B0 F0 BD FF 23 ?? ?? 16 33 +19
#define EVP_enc_null (*(const EVP_CIPHER*(*)(void))0xA0E8F60F) //10 B5 ?? ?? 28 22 20 1C ?? ?? ?? ?? ?? ?? 20 1C 10 BD 83 21 +1
#define StoreErrInfoAndAbort  (*(void (*)(int code,const char *module_name,int type,int unk3))0xA01CEE50) //?? 40 2D E9 ?? ?? ?? ?? 00 C0 94 E5 00 00 5C E3 ?? ?? ?? ?? 00 20 CC E5 01 20 A0 E1 
#define StoreErrString_10  (*(void (*)(const char *))0xA01CED1C) //00 00 A0 E3 04 00 C6 E7 70 80 BD E8 0A 10 A0 E3 ?? ?? ?? ?? 08 40 2D E9 D4 10 A0 E3 + 0xC
#endif

#ifdef EL71v45
#define malloc (*(void*(*)(unsigned int size))0xA0092F51)
#define memcpy (*(void*(*)(void *, const void *, size_t))0xA0FBC448)
#define mfree (*(void(*)(void *))0xA0092F93)
#define ClearMemory (*(void(*)(void *dest,int n))0xA0FBC3EC)
#define snprintf (*(int(*)(char *buf, int len, const char *str, ...))0xA0FBB151)
#define EVP_add_cipher (*(int(*)(const EVP_CIPHER *c))0xA0E80289)
#define EVP_CIPHER_get_asn1_iv (*(int(*)(EVP_CIPHER_CTX *c, ASN1_TYPE *type))0xA0E80113)
#define EVP_CIPHER_set_asn1_iv (*(int(*)(EVP_CIPHER_CTX *c, ASN1_TYPE *type))0xA0E801E5)
#define EVP_get_cipherbyname  (*(EVP_CIPHER*(*)(const char *name))0xA0E8030B)
#define OBJ_NAME_add  (*(int(*)(const char *name, int type, const char *data)) 0xA0E80739)
#define EVP_EncryptInit  (*(void(*)(EVP_CIPHER_CTX *ctx,const EVP_CIPHER *cipher,unsigned char *key,unsigned char *iv))0xA0E7FBE1)
#define EVP_DecryptInit  (*(void(*)(EVP_CIPHER_CTX *ctx,const EVP_CIPHER *cipher,unsigned char *key,unsigned char *iv))0xA0E7FBBF)
#define ssl_cipher_methods ((const EVP_CIPHER**)0xA8F56CC4)
#define ssl_digest_methods ((const EVP_MD**)0xA8F56B60)
#define ssl_comp_methods ((STACK_OF(SSL_COMP)*)0xA8F56B58)
#define sk_find  (*(int(*)(STACK *st, char *data))0xA0F806B5)
#define sk_value (*(char*(*)(STACK *st, int i))0xA0F807AD) 
#define EVP_enc_null (*(const EVP_CIPHER*(*)(void))0xA0E805DF)
#define StoreErrInfoAndAbort  (*(void (*)(int code,const char *module_name,int type,int unk3))0xA04D319C)
#define StoreErrString_10 (*(void (*)(const char *))0xA04D3068)
#endif

