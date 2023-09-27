//==============================================================================================
#pragma inline
void patch_rect(RECT*rc,int x,int y, int x2, int y2)
{
  rc->x=x;
  rc->y=y;
  rc->x2=x2;
  rc->y2=y2;
}

#pragma inline
void patch_header(const HEADER_DESC* head)
{
  ((HEADER_DESC*)head)->rc.x=0;
  ((HEADER_DESC*)head)->rc.y=YDISP;
  ((HEADER_DESC*)head)->rc.x2=ScreenW()-1;
  ((HEADER_DESC*)head)->rc.y2=HeaderH()+YDISP-1;
}
#pragma inline
void patch_input(const INPUTDIA_DESC* inp)
{
  ((INPUTDIA_DESC*)inp)->rc.x=4;
  ((INPUTDIA_DESC*)inp)->rc.y=HeaderH()+2+YDISP;
  ((INPUTDIA_DESC*)inp)->rc.x2=ScreenW()-4;
  ((INPUTDIA_DESC*)inp)->rc.y2=ScreenH()-SoftkeyH()-2;
}

#pragma inline
void patch_header_small(HEADER_DESC* head)
{
  head->rc.x=3;
  head->rc.x2=ScreenW()-6;
#ifndef ELKA
  head->rc.y=YDISP+0x18;
  head->rc.y2=YDISP+0x18+0x13;
#else
  head->rc.y=YDISP+0x23;
  head->rc.y2=YDISP+0x23+0x22;
#endif
}
