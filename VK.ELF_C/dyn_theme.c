#include <siemens\swilib.h>

extern const int CFG_ENA_THEME;

static IMGHDR *my_statusbar_st=NULL; 
static IMGHDR *my_headline_st=NULL;
static IMGHDR *my_body_st=NULL;
static IMGHDR *my_bottom_st=NULL;
static IMGHDR *my_popup_feedback=NULL;
static IMGHDR *my_sel_2line=NULL;
static IMGHDR *my_sel_1line=NULL;

static IMGHDR  statusbar_st;
static IMGHDR  headline_st;
static IMGHDR  body_st;
static IMGHDR  bottom_st;
static IMGHDR  popup_feedback;
static IMGHDR  sel_2line;
static IMGHDR  sel_1line;

//text color
static int color_my_header=NULL;
static int color_my_feedback=NULL;
static int color_my_softkey=NULL;
static int color_my_edit_hdr=NULL;
static int color_my_edit=NULL;
static int color_my_menu_sel=NULL;
static int color_my_menu=NULL;

static int color_header;
static int color_feedback;
static int color_softkey;
static int color_edit_hdr;
static int color_edit;
static int color_menu_sel;
static int color_menu;

extern const char APP_DIR[];

void LoadDynTheme()
{
  char path[128];
  
  if (CFG_ENA_THEME == 0)
    return;  

#ifdef ELKA
  if(!my_statusbar_st)
  {
    memcpy(&statusbar_st, GetIMGHDRFromThemeCache(STATUSBAR_STANDART), sizeof(IMGHDR));
    snprintf(path, 127, "%stheme\\statusbar_standart.png", APP_DIR);
    my_statusbar_st=CreateIMGHDRFromPngFile(path, 2);
  }
#endif 

#ifdef NEWSGOLD    
  if(!my_headline_st)
  {
    memcpy(&headline_st, GetIMGHDRFromThemeCache(HEADLINE_STANDART), sizeof(IMGHDR));
    snprintf(path, 127, "%stheme\\headline_standart.png", APP_DIR);
    my_headline_st=CreateIMGHDRFromPngFile(path, 2);
  }
  
  if(!my_body_st)
  {
    memcpy(&body_st, GetIMGHDRFromThemeCache(BODY_STANDART), sizeof(IMGHDR));
    snprintf(path, 127, "%stheme\\body_standart.png", APP_DIR);
    my_body_st=CreateIMGHDRFromPngFile(path, 2);
  }
  
  if(!my_bottom_st)
  {
    memcpy(&bottom_st, GetIMGHDRFromThemeCache(BOTTOM_STANDART), sizeof(IMGHDR));
    snprintf(path, 127, "%stheme\\bottom_standart.png", APP_DIR);
    my_bottom_st=CreateIMGHDRFromPngFile(path, 2);
  }
  
  if(!my_popup_feedback)
  {
    memcpy(&popup_feedback, GetIMGHDRFromThemeCache(POPUP_FEEDBACK), sizeof(IMGHDR));
    snprintf(path, 127, "%stheme\\popup_feedback.png", APP_DIR);
    my_popup_feedback=CreateIMGHDRFromPngFile(path, 2);
  }

  if(!my_sel_2line)
  {
    memcpy(&sel_2line, GetIMGHDRFromThemeCache(SELECTION_2_LINE), sizeof(IMGHDR));
    snprintf(path, 127, "%stheme\\sel_2line.png", APP_DIR);
    my_sel_2line=CreateIMGHDRFromPngFile(path, 2);
  }

  if(!my_sel_1line)
  {
    memcpy(&sel_1line, GetIMGHDRFromThemeCache(SELECTION_1_LINE), sizeof(IMGHDR));
    snprintf(path, 127, "%stheme\\sel_1line.png", APP_DIR);
    my_sel_1line=CreateIMGHDRFromPngFile(path, 2);
  }
#endif
  
  if(!color_my_edit_hdr)
  {
    color_my_edit_hdr=0x64808080;//серый
    memcpy(&color_edit_hdr, GetPaletteAdrByColorIndex(155), 4);
  }
  
  if(!color_my_edit)
  {
    color_my_edit=0x64000000;//черный
    memcpy(&color_edit, GetPaletteAdrByColorIndex(156), 4);
  }
  
  if(!color_my_feedback)
  {
    color_my_feedback=0x64000000;//черный
    memcpy(&color_feedback, GetPaletteAdrByColorIndex(129), 4);
  }
  
  if(!color_my_header)
  {
    color_my_header=0x64FFFFFF;//белый
    memcpy(&color_header, GetPaletteAdrByColorIndex(102), 4);
  }
  
  if(!color_my_softkey)
  {
    color_my_softkey=0x64FFFFFF;//белый
    memcpy(&color_softkey, GetPaletteAdrByColorIndex(105), 4);
  }

  if(!color_my_menu)
  {
    color_my_menu=0x64A6805D;//вк-синий
    memcpy(&color_menu, GetPaletteAdrByColorIndex(119), 4);
  }
  
  if(!color_my_menu_sel)
  {
    color_my_menu_sel=0x64A6805D;//вк-синий
    memcpy(&color_menu_sel, GetPaletteAdrByColorIndex(115), 4);
  }

  
}

void EnableDynTheme()
{
  if (CFG_ENA_THEME == 0)
    return;
  
#ifdef ELKA  
  if(my_statusbar_st)
    memcpy(GetIMGHDRFromThemeCache(STATUSBAR_STANDART), my_statusbar_st, sizeof(IMGHDR));
#endif
#ifdef NEWSGOLD    
  if(my_headline_st)
    memcpy(GetIMGHDRFromThemeCache(HEADLINE_STANDART), my_headline_st, sizeof(IMGHDR));
  if(my_body_st)
    memcpy(GetIMGHDRFromThemeCache(BODY_STANDART), my_body_st, sizeof(IMGHDR));
  if(my_bottom_st)
    memcpy(GetIMGHDRFromThemeCache(BOTTOM_STANDART), my_bottom_st, sizeof(IMGHDR));
  if(my_popup_feedback)
    memcpy(GetIMGHDRFromThemeCache(POPUP_FEEDBACK), my_popup_feedback, sizeof(IMGHDR));
  if(my_sel_2line)
    memcpy(GetIMGHDRFromThemeCache(SELECTION_2_LINE), my_sel_2line, sizeof(IMGHDR));
  if(my_sel_1line)
    memcpy(GetIMGHDRFromThemeCache(SELECTION_1_LINE), my_sel_1line, sizeof(IMGHDR));
#endif
  
  if(color_my_edit_hdr)
    memcpy(GetPaletteAdrByColorIndex(155), &color_my_edit_hdr, 4);
  
  if(color_my_edit)
    memcpy(GetPaletteAdrByColorIndex(156), &color_my_edit, 4);
  
  if(color_my_feedback)
    memcpy(GetPaletteAdrByColorIndex(129), &color_my_feedback, 4);
  
  if(color_my_header)
    memcpy(GetPaletteAdrByColorIndex(102), &color_my_header, 4);

  if(color_my_softkey)
    memcpy(GetPaletteAdrByColorIndex(105), &color_my_softkey, 4);
  
  if(color_my_menu)
    memcpy(GetPaletteAdrByColorIndex(119), &color_my_menu, 4);
  
  if(color_my_menu_sel)
    memcpy(GetPaletteAdrByColorIndex(115), &color_my_menu_sel, 4);  
  
}

void DisableDynTheme()
{
  if (CFG_ENA_THEME == 0)
    return;
    
#ifdef ELKA  
  if(my_statusbar_st)
    memcpy(GetIMGHDRFromThemeCache(STATUSBAR_STANDART), &statusbar_st, sizeof(IMGHDR));
#endif
#ifdef NEWSGOLD    
  if(my_headline_st)
    memcpy(GetIMGHDRFromThemeCache(HEADLINE_STANDART), &headline_st, sizeof(IMGHDR));
  if(my_body_st)
    memcpy(GetIMGHDRFromThemeCache(BODY_STANDART), &body_st, sizeof(IMGHDR));
  if(my_bottom_st)
    memcpy(GetIMGHDRFromThemeCache(BOTTOM_STANDART), &bottom_st, sizeof(IMGHDR));
  if(my_popup_feedback)
    memcpy(GetIMGHDRFromThemeCache(POPUP_FEEDBACK), &popup_feedback, sizeof(IMGHDR));
  if(my_sel_2line)
    memcpy(GetIMGHDRFromThemeCache(SELECTION_2_LINE), &sel_2line, sizeof(IMGHDR));
  if(my_sel_1line)
    memcpy(GetIMGHDRFromThemeCache(SELECTION_1_LINE), &sel_1line, sizeof(IMGHDR)); 
#endif
  
  if(color_my_edit_hdr)
    memcpy(GetPaletteAdrByColorIndex(155), &color_edit_hdr, 4);  
  
  if(color_my_edit)
    memcpy(GetPaletteAdrByColorIndex(156), &color_edit, 4);
  
  if(color_my_feedback)
    memcpy(GetPaletteAdrByColorIndex(129), &color_feedback, 4);

  if(color_my_header)
    memcpy(GetPaletteAdrByColorIndex(102), &color_header, 4);
  
  if(color_my_softkey)
    memcpy(GetPaletteAdrByColorIndex(105), &color_softkey, 4);
  
  if(color_my_menu)
    memcpy(GetPaletteAdrByColorIndex(119), &color_menu, 4); 
  
  if(color_my_menu_sel)
    memcpy(GetPaletteAdrByColorIndex(115), &color_menu_sel, 4); 
}

void FreeDynTheme()
{
  if (CFG_ENA_THEME == 0)
    return;
  
#ifdef ELKA  
  if(my_statusbar_st)
  {
    mfree(my_statusbar_st->bitmap);
    mfree(my_statusbar_st);
    my_statusbar_st=NULL;
  }
#endif
#ifdef NEWSGOLD    
  if(my_headline_st)
  {
    mfree(my_headline_st->bitmap);
    mfree(my_headline_st);
    my_headline_st=NULL;
  }
  
  if(my_body_st)
  {
    mfree(my_body_st->bitmap);
    mfree(my_body_st);
    my_body_st=NULL;
  }
  
  if(my_bottom_st)
  {
    mfree(my_bottom_st->bitmap);
    mfree(my_bottom_st);
    my_bottom_st=NULL;
  }
  
  if(my_popup_feedback)
  {
    mfree(my_popup_feedback->bitmap);
    mfree(my_popup_feedback);
    my_popup_feedback=NULL;
  }
  
  if(my_sel_2line)
  {
    mfree(my_sel_2line->bitmap);
    mfree(my_sel_2line);
    my_sel_2line=NULL;
  }
  
  if(my_sel_1line)
  {
    mfree(my_sel_1line->bitmap);
    mfree(my_sel_1line);
    my_sel_1line=NULL;
  }
#endif
  
  color_my_edit_hdr=NULL;
  color_my_edit=NULL;
  color_my_feedback=NULL;
  color_my_header=NULL;
  color_my_softkey=NULL;
  color_my_menu=NULL;
  color_my_menu_sel=NULL;
}
