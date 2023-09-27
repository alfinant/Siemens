#include <openssl/ssl.h>
#include <openssl/err.h>
#include "defs.h"
#include "evp_locl.h"


void EVP_CIPHER_CTX_init(EVP_CIPHER_CTX *ctx)
	{
	ClearMemory(ctx, sizeof(EVP_CIPHER_CTX)); //memset(ctx,0,sizeof(EVP_CIPHER_CTX));
	/* ctx->cipher=NULL; */
	}

int EVP_CipherInit_ex(EVP_CIPHER_CTX *ctx, const EVP_CIPHER *cipher, ENGINE *impl,
	     const unsigned char *key, const unsigned char *iv, int enc)
	{
	if (enc == -1)
		enc = ctx->encrypt;
	else
		{
		if (enc)
			enc = 1;
		ctx->encrypt = enc;
		}

	if (cipher)
		{
		/* Ensure a context left lying around from last time is cleared
		 * (the previous check attempted to avoid this if the same
		 * ENGINE and EVP_CIPHER could be used). */
		EVP_CIPHER_CTX_cleanup(ctx);

		/* Restore encrypt field: it is zeroed by cleanup */
		ctx->encrypt = enc;

		ctx->cipher=cipher;
		if (ctx->cipher->ctx_size)
			{
			ctx->cipher_data=/*OPENSSL_*/malloc(ctx->cipher->ctx_size);
			if (!ctx->cipher_data)
				{
				//EVPerr(EVP_F_EVP_CIPHERINIT, ERR_R_MALLOC_FAILURE);
				return 0;
				}
			}
		else
			{
			ctx->cipher_data = NULL;
			}
		ctx->key_len = cipher->key_len;
		ctx->flags = 0;
		if(ctx->cipher->flags & EVP_CIPH_CTRL_INIT)
			{
			if(!EVP_CIPHER_CTX_ctrl(ctx, EVP_CTRL_INIT, 0, NULL))
				{
				//EVPerr(EVP_F_EVP_CIPHERINIT, EVP_R_INITIALIZATION_ERROR);
				return 0;
				}
			}
		}
	else if(!ctx->cipher)
		{
		//EVPerr(EVP_F_EVP_CIPHERINIT, EVP_R_NO_CIPHER_SET);
		return 0;
		}

	/* we assume block size is a power of 2 in *cryptUpdate */
	__OPENSSL_assert(ctx->cipher->block_size == 1
	    || ctx->cipher->block_size == 8
	    || ctx->cipher->block_size == 16);

	if(!(EVP_CIPHER_CTX_flags(ctx) & EVP_CIPH_CUSTOM_IV)) {
		switch(EVP_CIPHER_CTX_mode(ctx)) {

			case EVP_CIPH_STREAM_CIPHER:
			case EVP_CIPH_ECB_MODE:
			break;

			case EVP_CIPH_CFB_MODE:
			case EVP_CIPH_OFB_MODE:

			ctx->num = 0;

			case EVP_CIPH_CBC_MODE:

			__OPENSSL_assert(EVP_CIPHER_CTX_iv_length(ctx) <= sizeof ctx->iv);
			if(iv) memcpy(ctx->oiv, iv, EVP_CIPHER_CTX_iv_length(ctx));
			memcpy(ctx->iv, ctx->oiv, EVP_CIPHER_CTX_iv_length(ctx));
			break;

			default:
			return 0;
		}
	}



	if(key || (ctx->cipher->flags & EVP_CIPH_ALWAYS_CALL_INIT)) {
		if(!ctx->cipher->init(ctx,key,iv,enc)) return 0;
	}
	ctx->buf_len=0;
	ctx->final_used=0;
	ctx->block_mask=ctx->cipher->block_size-1;
	return 1;
	}

int EVP_CipherInit(EVP_CIPHER_CTX *ctx, const EVP_CIPHER *cipher,
	     const unsigned char *key, const unsigned char *iv, int enc)
	{
	if (cipher)
		EVP_CIPHER_CTX_init(ctx);
	return EVP_CipherInit_ex(ctx,cipher,NULL,key,iv,enc);
	}

int EVP_CIPHER_CTX_ctrl(EVP_CIPHER_CTX *ctx, int type, int arg, void *ptr)
{
	int ret;
	if(!ctx->cipher) {
		//EVPerr(EVP_F_EVP_CIPHER_CTX_CTRL, EVP_R_NO_CIPHER_SET);
		return 0;
	}

	if(!ctx->cipher->ctrl) {
		//EVPerr(EVP_F_EVP_CIPHER_CTX_CTRL, EVP_R_CTRL_NOT_IMPLEMENTED);
		return 0;
	}

	ret = ctx->cipher->ctrl(ctx, type, arg, ptr);
	if(ret == -1) {
		//EVPerr(EVP_F_EVP_CIPHER_CTX_CTRL, EVP_R_CTRL_OPERATION_NOT_IMPLEMENTED);
		return 0;
	}
	return ret;
}

int EVP_CIPHER_CTX_cleanup(EVP_CIPHER_CTX *c)
	{
	if (c->cipher != NULL)
		{
		if(c->cipher->cleanup && !c->cipher->cleanup(c))
			return 0;
		/* Cleanse cipher context data */
		if (c->cipher_data)
			/*OPENSSL_cleanse*/ClearMemory(c->cipher_data, c->cipher->ctx_size);
		}
	if (c->cipher_data)
		/*OPENSSL_free*/mfree(c->cipher_data);
	ClearMemory(c, sizeof(EVP_CIPHER_CTX)); //memset(c,0,sizeof(EVP_CIPHER_CTX));
	return 1;
	}


