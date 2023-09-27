#ifndef ADRLIB_H
#define ADRLIB_H

#ifdef S75v52
#define fgets   (*(int(*)(int FileHandler, void *cBuffer))0xA09CAD25)

#define mfree_adr  (*(void(*)(void *))0xA0094948)

#define Malloc  (*(void*(*)(unsigned int size))0xA0D74961)
#define Free    (*(void(*)(void *))0xA0D74965)

#define ERR_get_error       (*(unsigned long(*)(void))0xA0E8E7C9)
#define ERR_put_error       (*(void(*)(int lib, int func, int reason, const char *file, int line))0xA0E8E737)
#define ERR_peek_error      (*(unsigned long(*)())0xA0E8E7DB) //was declared in err.h
#define ERR_add_error_data  (*(void(*)(int num, ...))0xA0E8E861) //was declared in err.h

#define MD5_Init   (*(void(*)(MD5_CTX *c))0xA0F41E4D)
#define MD5_Update (*(void(*)(MD5_CTX *c, const void *data, unsigned long len))0xA0F41ABD)
#define MD5_Final  (*(void(*)(unsigned char *md, MD5_CTX *c))0xA0F41D55)

#define RSA_verify (*(int(*)(int dtype, unsigned char *m, unsigned int m_len,\
                            unsigned char *sigbuf, unsigned int siglen, RSA *rsa))0xA0E917A7)

#define RSA_sign   (*(int(*)(int type, unsigned char *m, unsigned int m_len,\
                            unsigned char *sigret, unsigned int *siglen, RSA *rsa))0xA0E916A3)

#define i2d_X509_SIG (*(int(*)(X509_SIG *a, unsigned char **pp))0xA0E882D7)//crypto/asn1/
#define d2i_X509_SIG (*(X509_SIG*(*)(X509_SIG **a, unsigned char **pp, long length))0xA0E88389)
#define X509_SIG_free (*(void(*)(X509_SIG *a))0xA0E88333)//crypto/asn1/x_sig.c
//#define i2t_ASN1_OBJECT (*(int(*)(char *buf, int buf_len, ASN1_OBJECT *a))0xA0E86171)

#define StoreErrInfoAndAbort  (*(void (*)(int code,const char *module_name,int type,int unk3))0xA01CEE50)
#define StoreErrString  (*(void (*)(const char *))0xA01CED1C)
#define OBJ_obj2nid     (*(int (*)(ASN1_OBJECT *a))0xA0E8FA71)
#define OBJ_sn2nid      (*(int (*)(const char *s))0xA0E8FB03)
#define OBJ_nid2obj     (*(ASN1_OBJECT *(*)(int n))0xA0E8F915)
#define OBJ_obj2txt     (*(int(*)(char *buf, int buf_len, ASN1_OBJECT *a, int no_name))0xA0E8FBD3)

#define EVP_get_cipherbyname (*(const EVP_CIPHER * (*)(const char *name))0xA0E8F33B)
#define EVP_EncryptInit  (*(void(*)(EVP_CIPHER_CTX *ctx,const EVP_CIPHER *cipher,unsigned char *key,unsigned char *iv))0xA0E8EC11)
#define EVP_DecryptInit  (*(void(*)(EVP_CIPHER_CTX *ctx,const EVP_CIPHER *cipher,unsigned char *key,unsigned char *iv))0xA0E8ECEF)
#define EVP_DecryptUpdate (*(void(*)(EVP_CIPHER_CTX *ctx, unsigned char *out, int *outl,unsigned char *in, int inl))0xA0E8ECFD)
#define EVP_DecryptFinal  (*(int(*)(EVP_CIPHER_CTX *ctx, unsigned char *out, int *outl))0xA0E8EE0F)
#define EVP_CipherUpdate  (*(void(*)(EVP_CIPHER_CTX *ctx, unsigned char *out, int *outl,\
	     unsigned char *in, int inl))0xA0E8EDEF)
#define EVP_CipherFinal  (*(int(*)(EVP_CIPHER_CTX *ctx, unsigned char *out, int *outl))0xA0E8EED7)
#define d2i_RSAPrivateKey (*(RSA*(*)(RSA **a, unsigned char **pp, long length))0xA0E87197)
#endif

#endif//ADRLIB_H
