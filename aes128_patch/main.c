#include <openssl/ssl.h>
#include "ssl_locl.h"
#include "defs.h"

__root const SSL_CIPHER cipher_2F @"PATCH_CIPHER_0x0B"=
{
  1,
  TLS1_TXT_RSA_WITH_AES_128_SHA,
  TLS1_CK_RSA_WITH_AES_128_SHA,
  SSL_kRSA|SSL_aRSA|SSL_AES|SSL_SHA |SSL_TLSV1,
  SSL_HIGH|SSL_FIPS,
  0,
  128,
  128,
  SSL_ALL_CIPHERS,
  SSL_ALL_STRENGTHS,
};

void init_rc2_aes_ciphers(EVP_CIPHER *rc2) @ "SSL_CIPHER_GET_EVP__CODE_AREA"
{
  EVP_add_cipher(rc2);
  
  EVP_CIPHER *c = malloc(sizeof(EVP_CIPHER));
  memcpy(c, EVP_aes_128_cbc(), sizeof(EVP_CIPHER));
  OBJ_NAME_add(SN_aes_128_cbc, 2, (char const*)c);  
  OBJ_NAME_add(LN_aes_128_cbc, 2, (char const*)c); 
}


void hook_EVP_CipherInit(EVP_CIPHER_CTX *ctx, const EVP_CIPHER *data,
	     unsigned char *key, unsigned char *iv, int enc)
{
  if (data->nid == 0x1A3)
    EVP_CipherInit(ctx,data,key,iv,enc);
  else
  {
    if (enc)
      EVP_EncryptInit(ctx,data,key,iv);
    else	
      EVP_DecryptInit(ctx,data,key,iv);
  }
}









