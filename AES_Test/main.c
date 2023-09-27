#include <siemens/swilib.h>
#include <openssl/aes.h>

#define RAND_pseudo_bytes   (*(int(*)(unsigned char *buf, int num))0xA0F42863)

unsigned char secret[AES_BLOCK_SIZE] = "Allsiemens.com";

void __aes_cbc_encrypt_test()
{
  AES_KEY enc_key;
  AES_KEY dec_key;
  unsigned char in[320];
  unsigned char enc[320];
  unsigned char out[320];
  unsigned char init_vector[AES_BLOCK_SIZE];
  unsigned char iv_enc[AES_BLOCK_SIZE];
  unsigned char iv_dec[AES_BLOCK_SIZE];
  
  RAND_pseudo_bytes(init_vector, AES_BLOCK_SIZE);
  memcpy(iv_enc, init_vector, AES_BLOCK_SIZE);
  memcpy(iv_dec, init_vector, AES_BLOCK_SIZE);
  
  sprintf(in, "Отлично! Данные расшифрованы:)");
  int len = strlen(in);
  
  zeromem(enc, 320);
  zeromem(out, 320);
  AES_set_encrypt_key(secret, 128, &enc_key);
  AES_set_decrypt_key(secret, 128, &dec_key);
  
  AES_cbc_encrypt(in, enc, len, &enc_key, iv_enc, AES_ENCRYPT);
  AES_cbc_encrypt(enc, out, len, &dec_key, iv_dec, AES_DECRYPT);
}

int do_cipher(EVP_CIPHER_CTX *ctx, unsigned char *out, const unsigned char *in, size_t inl)
{
  return 0;
}

void __evp_test()
{
  EVP_CIPHER *cipher = NULL;
  EVP_CIPHER_CTX ctx;
  
  EVP_CipherInit(&ctx, EVP_aes_256_cbc(), &key, const unsigned char *iv, int enc);
  int blocksize = EVP_CIPHER_CTX_block_size(&ctx);
  cipher_buf = (unsigned char *)malloc(BUFSIZE + blocksize);
  EVP_Cipher(&ctx, NULL, NULL, 5);
  
  
}

int main(char *exename, char *fname)
{
  __aes_cbc_encrypt_test();
  
  return 0;
}


