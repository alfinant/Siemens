#ifndef COOKIE_H
# define COOKIE_H

void *Cookies_Get();
char* Cookies_GetByHost(char *host);
void Cookies_Load();
void Cookies_Save();
void Cookies_Free();
void Cookies_Add(char *cookie, char *domain);
void Cookies_SaveAndFree();

#endif
