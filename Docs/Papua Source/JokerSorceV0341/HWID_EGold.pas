//Business application is forbidden.
//Punishment - unavoidable crack and propagation on everything inet.
unit HWID_EGOLD;

interface

uses
  Windows;

const

HW_IDNONE= 0;
HW_IDMAX = 5555;
HW_IDMIN = 1;

HW_E10                          =   2;
HW_S6CLASSIC                    =   3;
HW_PCN6CLASSIC                  =   4;
HW_S7                           =   5;
HW_PCN7                         =   6;
HW_PCS7                         =   7;
HW_PCS1900                      =   8;
HW_S7_ACTIVE                    =   9;
HW_SL10                         =  10;
HW_S10_RELAUNCH_1               =  11;
HW_S10_RELAUNCH_2_TCXO          =  12;
HW_S10_RELAUNCH_2_VCXO          =  13;
HW_S10_ACTIVE_RELAUNCH          =  14;
HW_S10_RELAUNCH_2_VCXO_SONY     =  15;
HW_C1X_FAMILY                   =  16;
HW_C10                          =  17;
HW_C11                          =  18;
HW_C12                          =  19;
HW_SL10_RELAUNCH                =  20;
HW_C25                          =  21;
HW_S25                          =  22;
HW_C25_B3                       =  23;
HW_C25_V4                       =  24;
HW_P35                          =  25; // P35 Family identifier
HW_P35_A                        =  26;
HW_P35_BC16                     =  27;
HW_P35_BC32                     =  28;
HW_C25_V4_NEU                   =  29;
HW_B35N                         =  30;
HW_U35                          =  31;
//Munich =  32 ..  63
HW_C25V4_NEU_NEU                =  32;
HW_I37                          =  33;
HW_K45_FLIPPER                  =  34;
HW_K45_FLIPPER_TAIWAN           =  35;
HW_L55_FUGU55                   =  36; // SL55
HW_L55_FUGU56                   =  37;
HW_L55_LION55                   =  38;
HW_L55_LION55_LITE              =  39; // A60
HW_L55_LION55_JAVA              =  40; // C60
HW_L55_YAZOO                    =  41;
HW_L55_LION56_JAVA              =  42;
// KLF =  64 .. 127
//  64 reserved
HW_K45                    =  65;
HW_K45_EAGLE              =  66;
HW_K45_EAGLE_BRIGHT       =  67;
HW_K45_EAGLE_SMARTI       =  68;
HW_K45_PANTHER            =  69;
HW_K45_PANTHER_BRIGHT     =  70;
HW_K45_PANTHER_SMARTI     =  71;
HW_K45_EAGLE_TAI          =  72;
HW_K45_EAGLE_TAI_BRIGHT   =  73;
HW_K45_EAGLE_TAI_SMARTI   =  74;
HW_K45_PANTHER_TAI        =  75;
HW_K45_PANTHER_TAI_BRIGHT =  76;
HW_K45_PANTHER_TAI_SMARTI =  77;
HW_K45_URB                =  78;
HW_K45_URB_TAI            =  79;
HW_K45_SHARK              =  80;
HW_K45_SHARK_TAI          =  81;
HW_L55_MARLIN             =  82;
HW_L55_MARLIN80           =  83;
HW_L55_MARLIN96           =  84; // S55
HW_K45_REFRESH            =  85;
HW_L55_BARRACUDA          =  86; // M55
HW_L56_BARRACUDA          =  87;
// Ulm = 128..191
HW_K45_MANTA              = 128; // M50
HW_M46                    = 129;
HW_L55_TUNA               = 130; // C55
HW_A50_STINGRAY           = 131;
HW_L55_MAGURO             = 132; // MC60
// Aalborg = 192..223
HW_L56_TUNA               = 192;
HW_L56_MARLIN             = 193;
HW_L55_K1                 = 194;
HW_L55_K1A                = 195;
HW_L55_PIRANHA            = 196; // A55 A57
// 224..255
HW_L52_FOX                = 226; // A52
HW_L55_LEOPARD            = 228; // CF62
// BLN =256..319
// 256 reserved
HW_TC35                   = 257;
HW_AGATHA                 = 258;
HW_AGATHA_AC35            = 259;
HW_BERTHA_MC45            = 260;
HW_BERTHA_MC388           = 261;
HW_CELINE_AC45            = 262;
HW_CELINE_AC43            = 263;
HW_DAPHNE_TC35I           = 264;
HW_ELISE                  = 265; //  MC53
HW_GINA_TC45              = 266; //  MC35i
HW_HELENA                 = 267; //  TC45
HW_BERTHA_MC46            = 268; // Bertha with 850MHz
HW_BERTHA_MC368_MC389     = 269;
// BERTHA_MC399            = 270 reserved
HW_OLIVIA                 = 271;
HW_STELLA                = 272;
HW_TINA                  = 273;
HW_UTE                   = 274;
HW_MAJA_MC55             = 275;
HW_MAJA_MC56             = 276;
// R65 = 320..383
HW_R65_ULYSSES               = 320; // CX65
HW_R65_ULYSSES_X_CITE        = 321; // M65
HW_R65_ULYSSES_REFRESH       = 322; // CX70
HW_R65_PENELOPE              = 323; // S65
HW_R65_IRIS                  = 324; // SL65
HW_R65_IRIS_REFRESH          = 325; //
HW_R65_IRIS_LITE             = 326; //
HW_R65_HERA                  = 327; // C65
HW_R65_HERA_LITE             = 328; //
HW_R65_NEO                   = 329; // SK65
HW_R65_ULYSSES_NAFTA         = 330; //
HW_R65_ULYSSES_X_CITE_NAFTA  = 331; //
HW_R65_ULYSSES_REFRESH_NAFTA = 332; //
HW_R65_PENELOPE_NAFTA        = 333; // S66??
HW_R65_IRIS_NAFTA            = 334; //
HW_R65_IRIS_REFRESH_NAFTA    = 335; //
HW_R65_IRIS_LITE_NAFTA       = 336; //
HW_R65_HERA_NAFTA            = 337; //
HW_R65_HERA_LITE_NAFTA       = 338; //
HW_R65_NEO_NAFTA             = 339; //
HW_C75                       = 341;
HW_S75                       = 400;
HW_SL75                      = 401; //???????
HW_R65_ULYSSES_BOOTCORE      = 555; // 4096
{
HW_R65_SISKIN                =?;
HW_R65_ARIES                 =?;
HW_R65_BAYA                  =?;
HW_R65_PLOVER                =?;
HW_R65_MACAW                 =?;
HW_R65_CONDOR                =?;
HW_R65_CORMO                 =?;
HW_X75_MINOS                 =?;
HW_X75_HYDRA                 =?;
HW_X75_HYDRA_NEW             =?;
HW_X75_POLARIS               =?;
HW_X75_BRAMBLING             =?;
HW_X75_SWAN                  =?;
HW_X75_SWIFT                 =?;
HW_X75_IBIS                  =?;
HW_X75_HUMMINGBIRD           =?;
HW_X75_PLOVER                =?;
}
HW_CX75_CEBIT = 5000;
HW_M75_CEBIT = 5001;
HW_CF75 = 5003;
{
A1M0,C1F0,M130,S120,
S7F,S7C,S75,S66,S6C,S6V,S65,
SK6C,SK6R,SK65,SL7F,SL7C,SL75,SL6C,SL6V,SL65,SP65,
M75,ME75,M6C,M6V,M65,
CX75,CX7D,CX7C,CX7I,CX70,
CF76,CF75,C72V,C72,C7I,C7C,C7V,C75,C66,C6C,C6V,C65,CX66,CX6C,CX6V,CX65
[22.09.2005 13:47:18] >> вот все что нашел:
M75=5001
M75C=5001
CX75=5000
CX7A=5000
CF75=5003

CX6C=320
CX6V=320
CX65=320
M6C=321
M6V=321
M65=321
CX7C=322
CX7I=322
CX7V=322
CX70=322
S6C=323
S6V=323
S65=323
SL6C=324
SL65=324

C65=327

SK6C=329
SK6R=329
SK65=329

S66=333
C66=337
SP65=340
C75=341

CX75=5000
CX7A=5000
M75=5001
M75C=5001
CF75=5003

}
 HW_A50=34;
 HW_A51=227;
 HW_A52=226;
 HW_A55=196;
 HW_A56=192;
 HW_A57=196;
 HW_A60=39;
 HW_A62=231;
 HW_A65=230;
 HW_A70=241;
 HW_AX72=249;
 HW_A75=237;
 HW_AX75=243;
 HW_C55=130;
 HW_C56=192;
 HW_C60=40;
 HW_CF62=228;
 HW_C110=239;
 HW_M50=128;
 HW_MT50=128;
 HW_M55=86;
 HW_MC60=132;
 HW_S55=84;
 HW_S56=193;
 HW_SL55=36;
 HW_SX1=194;

function StrToHwID(buf : pointer): integer;
function HwIDToStr(xHwID : integer): string;

implementation

type
rHWName = packed record
   s   : pchar;
   id  : integer;
end;

var
TabHWName : array[0..26] of rHWName = (
 (s:'A50';id:131),
 (s:'A51';id:227),
 (s:'A52';id:226),
 (s:'A55';id:196),
 (s:'A56';id:192),
 (s:'A57';id:196),
 (s:'A60';id:39),
 (s:'A62';id:231),
 (s:'A65';id:230),
 (s:'A70';id:241),
 (s:'AX72';id:249),
 (s:'A75';id:237),
 (s:'AX75';id:243),
 (s:'C55';id:130),
 (s:'C56';id:192),
 (s:'C60';id:40),
 (s:'CF62';id:228),
 (s:'C110';id:239),
 (s:'M50';id:128),
 (s:'MT50';id:128),
 (s:'M55';id:86),
 (s:'MC60';id:132),
 (s:'S55';id:84),
 (s:'S56';id:193),
 (s:'SL55';id:36),
 (s:'SX1';id:194),
 (s:'Unknown';id:0)
);
function StrToHwID(buf : pointer): integer;
var
i : integer;
x : dword;
begin
  result:=HW_IDNONE;
  x:=dword(buf^);
  i:=0;
  while TabHWName[i].id<>0 do begin
   if x=dword((@TabHWName[i].s[0])^) then begin
    result:=TabHWName[i].id;
    break;
   end;
   inc(i);
  end;
end;

function HwIDToStr(xHwID : integer): string;
var
i : integer;
begin
  i:=0;
  while (TabHWName[i].id<>xHwID) and (TabHWName[i].id<>0) do inc(i);
  result:=TabHWName[i].s;
end;


end.

