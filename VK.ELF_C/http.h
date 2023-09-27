#define POST 0
#define GET  1

extern char HTTP_URL[];

extern int HTTP_VER_MAJOR;
extern int HTTP_VER_MINOR;
extern int HTTP_STATUS;
extern int HTTP_CONTENT_LENGTH;
extern int HTTP_CONNECTION;
extern int HTTP_HEADER_LENGTH;
extern char HTTP_CONTENT_TYPE[];
extern char HTTP_LOCATION[];

int ParseHeader();
void HttpSendReqPost(const char *url, const char *postdata);
void HttpSendReq(const char *url, int flag);

