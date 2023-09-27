#ifndef _NEW_FUNCTIONS_
#define _NEW_FUNCTIONS_

#ifdef E71//v45
static void **RAM_SSL_args_ptr=(void**)0xA8F5558C; 
#define SSLv3_client_method (*(SSL_METHOD*(*)(void)) 0xA0F77249)
#define TLSv1_client_method (*(SSL_METHOD*(*)(void)) 0xA0F7729F)
#define SSL_CTX_new         (*(SSL_CTX* (*)(SSL_METHOD *meth)) 0xA0F788DB)
#define ssl_ctx_ctrl        (*(long(*)(SSL_CTX *ctx,int cmd,long larg,void *parg)) 0xA0F74DAF)
#define SSL_new             (*(SSL* (*)(SSL_CTX *ctx)) 0xA0F77EA7)
#define SSL_set_fd          (*(int(*)(SSL *s, int fd)) 0xA0F780C7)
#define SSL_CTX_set_verify  (*(void(*)(SSL_CTX *ctx, int mode, int (*verify_callback)(int, X509_STORE_CTX *))) 0xA0F78B57)
#define SSL_connect         (*(int(*)(SSL *ssl)) 0xA0F7826B)
#define SSL_shutdown        (*(int(*)(SSL *ssl)) 0xA0F78285)
#define SSL_write           (*(int(*)(SSL *ssl,const void *buf,int num)) 0xA0F73B61)
#define SSL_read            (*(int(*)(SSL *ssl,void *buf,int num)) 0xA0F73BFF)
//#define SSL_clear           (*(void(*)(SSL *ssl)) 0xA0F76B55)
#define SSL_free            (*(void(*)(SSL *ssl)) 0xA0F77FAD)
#define SSL_CTX_free        (*(void(*)(SSL_CTX *ctx)) 0xA0F77CD7)
//int SSL_CTX_add_session(SSL_CTX *ctx, SSL_SESSION *c);
#define SSL_CTX_add_session (*(int(*)(SSL_CTX *ctx, SSL_SESSION *c)) 0xA0F74E4B)
#define SSL_Session_free    (*(void(*)(SSL_SESSION* sess)) 0xA0F72BA3)
#define SSL_set_session     (*(int(*)(SSL *ssl, SSL_SESSION *session)) 0xA0F78CCB)
//#define call_recv_tolisten  (*(int(*)(int sock, char *buf, int size, int zero, int unk1, int unk2)) 0xA0A59EED)
//#define ShowAnimMSG         (*(int(*)(int flag, WSHDR *fname, WSHDR *msg, void *desc)) 0xA094F029)
//#define ShowAnimMSG1        (*(int(*)(int flag, int lgpid, void *desc, int zero, int duration)) 0xA094EE2F)
//#define AnimWidgetProc3     (*(void(*)(void*)) 0xA0A25F53)
#define Obs_SetInputMemory  (*(int(*)(HObj obj, int unk, char* buf, int len)) 0xA0CCCCE8)
//int gethostbyname(char *name, HOSTENT **, int *ping, int unk, int unk2);
//#define gethostbyname       (*(int(*)(const char *name, HOSTENT **, int *dnr_id, int unk_1)) 0xA0A5CA35)
#endif

#ifdef EL71//v45
static void **SSL_RAM_ptr=(void**)0xA8F54DAC;
#define SSLv3_client_method (*(SSL_METHOD*(*)(void)) 0xA0F839EF)
#define TLSv1_client_method (*(SSL_METHOD*(*)(void)) 0xA0F83A43)
#define SSL_CTX_new         (*(SSL_CTX* (*)(SSL_METHOD *meth)) 0xA0F8507F)
#define ssl_ctx_ctrl        (*(long(*)(SSL_CTX *ctx,int cmd,long larg,void *parg)) 0xA0F81553)
#define SSL_new             (*(SSL* (*)(SSL_CTX *ctx)) 0xA0F8464B)
#define SSL_set_fd          (*(int(*)(SSL *s, int fd)) 0xA0F8486B)
#define SSL_CTX_set_verify  (*(void(*)(SSL_CTX *ctx, int mode, int (*verify_callback)(int, X509_STORE_CTX *))) 0xA0F852FB)
#define SSL_connect         (*(int(*)(SSL *ssl)) 0xA0F84A0F)
#define SSL_shutdown        (*(int(*)(SSL *ssl)) 0xA0F84A29)
#define SSL_write           (*(int(*)(SSL *ssl,const void *buf,int num)) 0xA0F80305)
#define SSL_read            (*(int(*)(SSL *ssl,void *buf,int num)) 0xA0F803A3)
#define SSL_peek            (*(int(*)(SSL *ssl,void *buf,int num)) 0xA0F80429)
//#define SSL_pending         (*(int(*)(SSL *ssl)) 0xA0F7E8CB)
//#define SSL_clear           (*(void(*)(SSL *ssl)) 0xA0F8)
#define SSL_free            (*(void(*)(SSL *ssl)) 0xA0F84751)
#define SSL_CTX_free        (*(void(*)(SSL_CTX *ctx)) 0xA0F8447B)
//int SSL_CTX_add_session(SSL_CTX *ctx, SSL_SESSION *c);
//#define SSL_CTX_add_session (*(int(*)(SSL_CTX *ctx, SSL_SESSION *c)) 0xA0F8)
#define SSL_Session_free    (*(void(*)(SSL_SESSION* sess)) 0xA0F7F347)
#define SSL_set_session     (*(int(*)(SSL *ssl, SSL_SESSION *session)) 0xA0F8546F)

#define SetMLMenuItemIconIMGHDR (*(void(*)(void* gui, void* item, IMGHDR*img)) 0xA095E27F)
#define DrawIMGHDR              (*(void(*)(int x, int y, IMGHDR* img)) 0xA0A16843)

#define GetItemTextPtr       (*(void*(*)(void* data)) 0xA0A35BB5)
//#define SetItemTextLength    (*(void(*)(void* data, int len)) 0xA09F33D7)
#define TVIEW_GetTextHeight  (*(int(*)(void* data, WSHDR* ws, RECT* rc, int len)) 0xA07003C5)
#define TVIEW_GetTextOffset  (*(int(*)(void* data)) 0xA0947CD9)
#define Get_Obj1_WH          (*(void(*)(DRWOBJ *drwobj, int* w, int* h)) 0xA08DC2A9)
#define SetDrawingCanvas     (*(void(*)(int x, int y, int x2, int y2)) 0xA0A17181)

#define Obs_SetInputMemory  (*(int(*)(HObj obj, int unk, char* buf, int len)) 0xA0CD948C)
#define Obs_SetCSM          (*(int(*)(HObj obj, void* data)) 0xA0CC4574)

//#define crc32               (*(int(*)(char* buf, int len, int crc )) 0xA0A83055)

#define StoreErrString      (*(void(*)(const char *)) 0xA04D3068)
#define StoreErrInfoAndAbort (*(void(*)(int code,const char *module_name,int type,int unk3)) 0xA04D319C)
#endif

#ifdef S75v523
static void **SSL_RAM_ptr=(void**)0xA8E8DD24;
#define TLSv1_client_method (*(SSL_METHOD*(*)(void)) 0xA0F8C023)
#define SSL_CTX_new         (*(SSL_CTX* (*)(SSL_METHOD *meth)) 0xA0F8D65F)
#define ssl_ctx_ctrl        (*(long(*)(SSL_CTX *ctx,int cmd,long larg,void *parg)) 0xA0F89B33)
#define SSL_new             (*(SSL* (*)(SSL_CTX *ctx)) 0xA0F8CC2B)
#define SSL_set_fd          (*(int(*)(SSL *s, int fd)) 0xA0F8CE4B)
#define SSL_connect         (*(int(*)(SSL *ssl)) 0xA0F8CFEF)
#define SSL_shutdown        (*(int(*)(SSL *ssl)) 0xA0F8D009)
#define SSL_write           (*(int(*)(SSL *ssl,const void *buf,int num)) 0xA0F888E5)
#define SSL_read            (*(int(*)(SSL *ssl,void *buf,int num)) 0xA0F88983)
#define SSL_free            (*(void(*)(SSL *ssl)) 0xA0F8CD31)
#define SSL_CTX_free        (*(void(*)(SSL_CTX *ctx)) 0xA0F8CA5B)
#define SSL_Session_free    (*(void(*)(SSL_SESSION* sess)) 0xA0F87927)
#define SSL_set_session     (*(int(*)(SSL *ssl, SSL_SESSION *session)) 0xA0F8DA4F)

#define SetMLMenuItemIconIMGHDR (*(void(*)(void *gui, void *item, IMGHDR *img)) 0xA097D73F)
//#define SetMLMenuItemText2      (*(void(*)(void *gui, void *item, WSHDR *ws1, WSHDR *ws2, int unk_flag, int n)) 0xA09807BB)
#define DrawIMGHDR           (*(void(*)(int x, int y, IMGHDR* img)) 0xA0A02BDB)
#define RefreshMenuItem      (*(void(*)(void *gui, int item)) 0xA097CDEB)

#define GetItemTextPtr       (*(void*(*)(void* data)) 0xA0A21ACF)
#define SetItemTextLength    (*(void(*)(void* data, int len)) 0xA09DEB7F)
#define Get_Obj1_WH          (*(void(*)(DRWOBJ *drwobj, int* w, int* h)) 0xA0903CFD)
#define SetDrawingCanvas     (*(void(*)(int x, int y, int x2, int y2)) 0xA0A0351D)

#define Obs_SetInputMemory  (*(int(*)(HObj obj, int unk, char* buf, int len)) 0xA0D049C8)
#define Obs_SetCSM          (*(int(*)(HObj obj, CSM_RAM  *csm)) 0xA0CF8DA0)
//#define OverlayAddInfo      (*(void(*)(WSHDR * )) 0xA0903BE5)
#endif

#endif //_NEW_FUNCTIONS_
