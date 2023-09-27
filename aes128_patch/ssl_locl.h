/* ssl/ssl_locl.h */
/* Copyright (C) 1995-1998 Eric Young (eay@cryptsoft.com)
 * All rights reserved.
 *
 * This package is an SSL implementation written
 * by Eric Young (eay@cryptsoft.com).
 * The implementation was written so as to conform with Netscapes SSL.
 * 
 * This library is free for commercial and non-commercial use as long as
 * the following conditions are aheared to.  The following conditions
 * apply to all code found in this distribution, be it the RC4, RSA,
 * lhash, DES, etc., code; not just the SSL code.  The SSL documentation
 * included with this distribution is covered by the same copyright terms
 * except that the holder is Tim Hudson (tjh@cryptsoft.com).
 * 
 * Copyright remains Eric Young's, and as such any Copyright notices in
 * the code are not to be removed.
 * If this package is used in a product, Eric Young should be given attribution
 * as the author of the parts of the library used.
 * This can be in the form of a textual message at program startup or
 * in documentation (online or textual) provided with the package.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. All advertising materials mentioning features or use of this software
 *    must display the following acknowledgement:
 *    "This product includes cryptographic software written by
 *     Eric Young (eay@cryptsoft.com)"
 *    The word 'cryptographic' can be left out if the rouines from the library
 *    being used are not cryptographic related :-).
 * 4. If you include any Windows specific code (or a derivative thereof) from 
 *    the apps directory (application code) you must include an acknowledgement:
 *    "This product includes software written by Tim Hudson (tjh@cryptsoft.com)"
 * 
 * THIS SOFTWARE IS PROVIDED BY ERIC YOUNG ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 * 
 * The licence and distribution terms for any publically available version or
 * derivative of this code cannot be changed.  i.e. this code cannot simply be
 * copied and put under another distribution licence
 * [including the GNU Public Licence.]
 */
/* ====================================================================
 * Copyright (c) 1998-2001 The OpenSSL Project.  All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer. 
 *
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in
 *    the documentation and/or other materials provided with the
 *    distribution.
 *
 * 3. All advertising materials mentioning features or use of this
 *    software must display the following acknowledgment:
 *    "This product includes software developed by the OpenSSL Project
 *    for use in the OpenSSL Toolkit. (http://www.openssl.org/)"
 *
 * 4. The names "OpenSSL Toolkit" and "OpenSSL Project" must not be used to
 *    endorse or promote products derived from this software without
 *    prior written permission. For written permission, please contact
 *    openssl-core@openssl.org.
 *
 * 5. Products derived from this software may not be called "OpenSSL"
 *    nor may "OpenSSL" appear in their names without prior written
 *    permission of the OpenSSL Project.
 *
 * 6. Redistributions of any form whatsoever must retain the following
 *    acknowledgment:
 *    "This product includes software developed by the OpenSSL Project
 *    for use in the OpenSSL Toolkit (http://www.openssl.org/)"
 *
 * THIS SOFTWARE IS PROVIDED BY THE OpenSSL PROJECT ``AS IS'' AND ANY
 * EXPRESSED OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE OpenSSL PROJECT OR
 * ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 * ====================================================================
 *
 * This product includes cryptographic software written by Eric Young
 * (eay@cryptsoft.com).  This product includes software written by Tim
 * Hudson (tjh@cryptsoft.com).
 *
 */

#ifndef HEADER_SSL_LOCL_H
#define HEADER_SSL_LOCL_H


/* LOCAL STUFF */

#define SSL_DECRYPT	0
#define SSL_ENCRYPT	1

#define TWO_BYTE_BIT	0x80
#define SEC_ESC_BIT	0x40
#define TWO_BYTE_MASK	0x7fff
#define THREE_BYTE_MASK	0x3fff

#define INC32(a)	((a)=((a)+1)&0xffffffffL)
#define DEC32(a)	((a)=((a)-1)&0xffffffffL)
#define MAX_MAC_SIZE	20 /* up from 16 for SSLv3 */

/*
 * Define the Bitmasks for SSL_CIPHER.algorithms.
 * This bits are used packed as dense as possible. If new methods/ciphers
 * etc will be added, the bits a likely to change, so this information
 * is for internal library use only, even though SSL_CIPHER.algorithms
 * can be publicly accessed.
 * Use the according functions for cipher management instead.
 *
 * The bit mask handling in the selection and sorting scheme in
 * ssl_create_cipher_list() has only limited capabilities, reflecting
 * that the different entities within are mutually exclusive:
 * ONLY ONE BIT PER MASK CAN BE SET AT A TIME.
 */
#define SSL_MKEY_MASK		0x0000003FL
#define SSL_kRSA		0x00000001L /* RSA key exchange */
#define SSL_kDHr		0x00000002L /* DH cert RSA CA cert */
#define SSL_kDHd		0x00000004L /* DH cert DSA CA cert */
#define SSL_kFZA		0x00000008L
#define SSL_kEDH		0x00000010L /* tmp DH key no DH cert */
#define SSL_kKRB5		0x00000020L /* Kerberos5 key exchange */
#define SSL_EDH			(SSL_kEDH|(SSL_AUTH_MASK^SSL_aNULL))

#define SSL_AUTH_MASK		0x00000FC0L
#define SSL_aRSA		0x00000040L /* Authenticate with RSA */
#define SSL_aDSS 		0x00000080L /* Authenticate with DSS */
#define SSL_DSS 		SSL_aDSS
#define SSL_aFZA 		0x00000100L
#define SSL_aNULL 		0x00000200L /* no Authenticate, ADH */
#define SSL_aDH 		0x00000400L /* no Authenticate, ADH */
#define SSL_aKRB5               0x00000800L /* Authenticate with KRB5 */

#define SSL_NULL		(SSL_eNULL)
#define SSL_ADH			(SSL_kEDH|SSL_aNULL)
#define SSL_RSA			(SSL_kRSA|SSL_aRSA)
#define SSL_DH			(SSL_kDHr|SSL_kDHd|SSL_kEDH)
#define SSL_FZA			(SSL_aFZA|SSL_kFZA|SSL_eFZA)
#define SSL_KRB5                (SSL_kKRB5|SSL_aKRB5)

#define SSL_ENC_MASK		0x0087F000L
#define SSL_DES			0x00001000L
#define SSL_3DES		0x00002000L
#define SSL_RC4			0x00004000L
#define SSL_RC2			0x00008000L
#define SSL_IDEA		0x00010000L
#define SSL_eFZA		0x00020000L
#define SSL_eNULL		0x00040000L
#define SSL_AES			0x00800000L

#define SSL_MAC_MASK		0x00180000L
#define SSL_MD5			0x00080000L
#define SSL_SHA1		0x00100000L
#define SSL_SHA			(SSL_SHA1)

#define SSL_SSL_MASK		0x00600000L
#define SSL_SSLV2		0x00200000L
#define SSL_SSLV3		0x00400000L
#define SSL_TLSV1		SSL_SSLV3	/* for now */

/* we have used 007fffff - 9 bits left to go */

/*
 * Export and cipher strength information. For each cipher we have to decide
 * whether it is exportable or not. This information is likely to change
 * over time, since the export control rules are no static technical issue.
 *
 * Independent of the export flag the cipher strength is sorted into classes.
 * SSL_EXP40 was denoting the 40bit US export limit of past times, which now
 * is at 56bit (SSL_EXP56). If the exportable cipher class is going to change
 * again (eg. to 64bit) the use of "SSL_EXP*" becomes blurred even more,
 * since SSL_EXP64 could be similar to SSL_LOW.
 * For this reason SSL_MICRO and SSL_MINI macros are included to widen the
 * namespace of SSL_LOW-SSL_HIGH to lower values. As development of speed
 * and ciphers goes, another extension to SSL_SUPER and/or SSL_ULTRA would
 * be possible.
 */
#define SSL_EXP_MASK		0x00000003L
#define SSL_NOT_EXP		0x00000001L
#define SSL_EXPORT		0x00000002L

#define SSL_STRONG_MASK		0x000000fcL
#define SSL_STRONG_NONE		0x00000004L
#define SSL_EXP40		0x00000008L
#define SSL_MICRO		(SSL_EXP40)
#define SSL_EXP56		0x00000010L
#define SSL_MINI		(SSL_EXP56)
#define SSL_LOW			0x00000020L
#define SSL_MEDIUM		0x00000040L
#define SSL_HIGH		0x00000080L
#define SSL_FIPS		0x00000100L

/* we have used 000001ff - 23 bits left to go */

/*
 * Macros to check the export status and cipher strength for export ciphers.
 * Even though the macros for EXPORT and EXPORT40/56 have similar names,
 * their meaning is different:
 * *_EXPORT macros check the 'exportable' status.
 * *_EXPORT40/56 macros are used to check whether a certain cipher strength
 *          is given.
 * Since the SSL_IS_EXPORT* and SSL_EXPORT* macros depend on the correct
 * algorithm structure element to be passed (algorithms, algo_strength) and no
 * typechecking can be done as they are all of type unsigned long, their
 * direct usage is discouraged.
 * Use the SSL_C_* macros instead.
 */
#define SSL_IS_EXPORT(a)	((a)&SSL_EXPORT)
#define SSL_IS_EXPORT56(a)	((a)&SSL_EXP56)
#define SSL_IS_EXPORT40(a)	((a)&SSL_EXP40)
#define SSL_C_IS_EXPORT(c)	SSL_IS_EXPORT((c)->algo_strength)
#define SSL_C_IS_EXPORT56(c)	SSL_IS_EXPORT56((c)->algo_strength)
#define SSL_C_IS_EXPORT40(c)	SSL_IS_EXPORT40((c)->algo_strength)

#define SSL_EXPORT_KEYLENGTH(a,s)	(SSL_IS_EXPORT40(s) ? 5 : \
				 ((a)&SSL_ENC_MASK) == SSL_DES ? 8 : 7)
#define SSL_EXPORT_PKEYLENGTH(a) (SSL_IS_EXPORT40(a) ? 512 : 1024)
#define SSL_C_EXPORT_KEYLENGTH(c)	SSL_EXPORT_KEYLENGTH((c)->algorithms, \
				(c)->algo_strength)
#define SSL_C_EXPORT_PKEYLENGTH(c)	SSL_EXPORT_PKEYLENGTH((c)->algo_strength)


#define SSL_ALL			0xffffffffL
#define SSL_ALL_CIPHERS		(SSL_MKEY_MASK|SSL_AUTH_MASK|SSL_ENC_MASK|\
				SSL_MAC_MASK)
#define SSL_ALL_STRENGTHS	(SSL_EXP_MASK|SSL_STRONG_MASK)

/* Mostly for SSLv3 */
#define SSL_PKEY_RSA_ENC	0
#define SSL_PKEY_RSA_SIGN	1
#define SSL_PKEY_DSA_SIGN	2
#define SSL_PKEY_DH_RSA		3
#define SSL_PKEY_DH_DSA		4
#define SSL_PKEY_NUM		5

/* SSL_kRSA <- RSA_ENC | (RSA_TMP & RSA_SIGN) |
 * 	    <- (EXPORT & (RSA_ENC | RSA_TMP) & RSA_SIGN)
 * SSL_kDH  <- DH_ENC & (RSA_ENC | RSA_SIGN | DSA_SIGN)
 * SSL_kEDH <- RSA_ENC | RSA_SIGN | DSA_SIGN
 * SSL_aRSA <- RSA_ENC | RSA_SIGN
 * SSL_aDSS <- DSA_SIGN
 */

/*
#define CERT_INVALID		0
#define CERT_PUBLIC_KEY		1
#define CERT_PRIVATE_KEY	2
*/


#endif
