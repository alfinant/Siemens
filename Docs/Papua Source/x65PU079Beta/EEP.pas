//Использование в коммерческих целях запрещено.
//Наказание - неминуемый кряк и распространение по всему инет.
//Business application is forbidden.
//Punishment - unavoidable crack and propagation on everything inet.
unit EEP;
interface

uses Windows,SysUtils,BFC;

const
MAX_INDEX_EEPTAB = 511;
MAX_INDEX_SEGEEP = 2000;
MAX_SIZE_EEPBLK = 20000;

type
rEEPfileHeader = packed record
 eels : dword;
 eefs : dword;
end;

rEEPblkHeader = packed record
 num    : dword;
 len    : dword;
 ver    : dword;
end;

rTab_EEP_Blocks = packed record
   num  : dword;
   len  : dword;
   ver  : dword;
   addr : dword;
   buf  : Pbyte;
end;

//Teefulltab = array[0..MAX_INDEX_EEFULL] of T_tab_EEP_Blocks;

rT_SegEEP_TAB = packed record case byte of
 0:(    wr_flg       : DWORD; //$FFFFFF00 or $FFFFFFC0 or $FFFFFFFF
        blk_num      : DWORD; // 5000+epnum
        blk_size     : DWORD; // size
        addr_off     : DWORD; );
 1:( b : array[0..15] of Byte );
end;


var
EepBuf : array[0..$1FFFF] of byte;
idx_eepbuf : integer;
EepTab : array [0..MAX_INDEX_EEPTAB] of rTab_EEP_Blocks;
idx_eeptab : integer;
next_seg_eeful : integer;

sEep_Err : string;

procedure ClearEEPBufAndTab;
function AddSegBlkEEP(base: dword; var bufb: array of byte; ErrStop : boolean): boolean;
function SaveAllEEP(eepfilename : string; HW : word): boolean;
function GetIndexEepTab( num : dword ; var idx : dword): boolean;
function OpenEEPfile(eepfilename : string; var HW : word ): boolean;
function AddBFCEEPBlk(num:dword; flgFind:boolean): boolean;

implementation


procedure ClearEEPBufAndTab;
begin
        sEep_Err:='';
        next_seg_eeful:=0;
        idx_eepbuf:=0;
        idx_eeptab:=0;
        FillChar(EepTab,sizeof(EepTab),$00);
end;

function AddSegBlkEEP(base: dword; var bufb: array of byte; ErrStop : boolean): boolean;
var
buf_TBL : rT_SegEEP_TAB;
i : integer;
numbase : dword;
//bufd : PDword;
//bufb : array of byte;
begin
        result:=False;
        numbase:=0;
//        bufd:=@bufb;
        if (Dword(Pointer(@bufb[0])^)=$55464545)and(Dword(Pointer(@bufb[4])^)=$00004C4C)
        or (Dword(Pointer(@bufb[0])^)=$494C4545)and(Dword(Pointer(@bufb[4])^)=$00004554)
        then begin
         if (Dword(Pointer(@bufb[0])^)=$55464545) then begin
          if next_seg_eeful>1 then begin
           sEep_Err:='Ошибка: неверный вызов AddSegBlkEEP!';
           exit;
          end;
          inc(next_seg_eeful);
          numbase:=5000;
         end else next_seg_eeful:=0;
         i:=1; // d:=0;
         while(i<MAX_INDEX_SEGEEP) do begin
           move(bufb[$20000-(i shl 4)],buf_TBL,sizeof(buf_TBL));
//           Move(@bufb[$20000-(i shl 4)],buf_TBL,Sizeof(buf_TBL));
           if buf_TBL.wr_flg=$FFFFFFFF then begin
            result:=True;
            exit;
           end
           else begin
            if (buf_TBL.wr_flg=$FFFFFFC0) then begin
             if idx_eeptab>MAX_INDEX_EEPTAB then begin
              sEep_Err:='Ошибка: Переполнение буфера таблицы EEP блоков!';
              exit;
             end;
             if (buf_TBL.blk_size > MAX_SIZE_EEPBLK+1)
             or (buf_TBL.blk_size = 0)
             or (buf_TBL.addr_off > $1FF00)
             or (buf_TBL.blk_num > 10000) then begin
              sEep_Err:='Ошибка: Некорректный блок EEP'+IntToStr(buf_TBL.blk_num+numbase)+'!';
              if ErrStop then exit;
             end
             else begin
              EepTab[idx_eeptab].num:=buf_TBL.blk_num+numbase;
              EepTab[idx_eeptab].len:=buf_TBL.blk_size-1;
              EepTab[idx_eeptab].addr:=base+buf_TBL.addr_off;
              if (idx_eepbuf+integer(EepTab[idx_eeptab].len) >= sizeof(Eepbuf)) then begin
               sEep_Err:='Ошибка: Переполнение буфера сохранения EEP блоков!';
               exit;
              end;
              if numbase<>0 then begin
               EepTab[idx_eeptab].ver:=bufb[buf_TBL.addr_off];
               if EepTab[idx_eeptab].len<>0 then
                Move(bufb[buf_TBL.addr_off+1],EepBuf[idx_eepbuf],EepTab[idx_eeptab].len);
              end
              else begin
               EepTab[idx_eeptab].ver:=bufb[buf_TBL.addr_off+buf_TBL.blk_size-1];
               if EepTab[idx_eeptab].len<>0 then
                Move(bufb[buf_TBL.addr_off],EepBuf[idx_eepbuf],EepTab[idx_eeptab].len);
              end;
              EepTab[idx_eeptab].buf:=@EepBuf[idx_eepbuf];
              idx_eepbuf:=idx_eepbuf+integer(EepTab[idx_eeptab].len);
              inc(idx_eeptab);
             end; //
            end             // if buf_TBL.wr_flg=$FFFFFFC0
            else begin // delete block
//             AddLinesLog('DEL'+IntToStr(buf_TBL.blk_num+5000)+', size: '+IntToStr(buf_TBL.blk_size-1));
//             inc(d);
            end;
           end; // if else buf_TBL.wr_flg=$FFFFFFFF
           inc(i);
         end; // while
         if numbase<>0 then sEep_Err:='Ошибка: Переполненный сегмент EEFULL!'
         else sEep_Err:='Ошибка: Переполненный сегмент EELITE!';
        end
        else begin
         sEep_Err:='Ошибка: Нет идентификатора сегмента EEFULL или EELITE!';
        end;
end;

function SaveAllEEP(eepfilename : string; HW : word ): boolean;
var
EEPfileHeader : rEEPfileHeader;
hblkFile : dword;
i : integer;
begin
        result:=False;
        if idx_eeptab=0 then begin
         sEep_Err:='Нету сохраненных EEP блоков!';
         exit;
        end;
        EEPfileHeader.eels:=0;
        EEPfileHeader.eefs:=0;
        for i:=0 to idx_eeptab-1 do begin
          if EepTab[i].num<5000 then inc(EEPfileHeader.eels)
          else if EepTab[i].num>0 then inc(EEPfileHeader.eefs)
          else begin
           sEep_Err:='Нарушена таблица EEP блоков!';
           exit;
          end;
        end;
        hblkFile := FileCreate(eepfilename);
        if hblkFile = INVALID_HANDLE_VALUE then begin
         sEep_Err:='Не создать файл '+eepfilename+'!';
         exit;
        end;
        if NOT FileWrite(hblkFile,EEPfileHeader,SizeOf(EEPfileHeader)) = SizeOf(EEPfileHeader) then begin
         FileClose(hblkFile);
         sEep_Err:='Ошибка записи в файл '+eepfilename+'!';
         exit;
        end; // if NOT FileWrite
        for i:=0 to idx_eeptab-1 do begin
         if EepTab[i].buf<>nil then begin
          if NOT FileWrite(hblkFile,EepTab[i].num,12) = 12 then begin
           FileClose(hblkFile);
           sEep_Err:='Ошибка записи в файл '+eepfilename+'!';
           exit;
          end; // if NOT FileWrite
          if EepTab[i].len<>0 then begin
           if NOT FileWrite(hblkFile,EepTab[i].buf^,EepTab[i].len) = integer(EepTab[i].len) then begin
            FileClose(hblkFile);
            sEep_Err:='Ошибка записи в файл '+eepfilename+'!';
            exit;
           end; // if NOT FileWrite
          end;
         end;
        end;
        if NOT FileWrite(hblkFile,HW,2) = 2 then begin
         FileClose(hblkFile);
         sEep_Err:='Ошибка записи в файл '+eepfilename+'!';
         exit;
        end; // if NOT FileWrite
        FileClose(hblkFile);
//        sEep_Err:='Ошибка записи в файл'+eepfilename+'!';
        result:=True;
end;

function GetIndexEepTab( num : dword ; var idx : dword): boolean;
var
i : integer;
begin
    i:=0;
    while (i<idx_eeptab) do begin
     if EepTab[i].num=num then begin
      idx:=i;
      result:=True;
      exit;
     end;
     inc(i);
    end;
    idx:=0;
    result:=False;
end;

function OpenEEPfile(eepfilename : string; var HW : word ): boolean;
var
EEPfileHeader : rEEPfileHeader;
EEPblkHeader : rEEPblkHeader;
hblkFile : dword;
x : integer;
begin
        result:=False;
        hblkFile := FileOpen(eepfilename,fmOpenRead or fmShareCompat);
        if hblkFile = INVALID_HANDLE_VALUE then begin
         sEep_Err:='Не открыть файл '+eepfilename+'!';
         exit;
        end;
        if (FileRead(hblkFile, EEPfileHeader, sizeof(EEPfileHeader))<>sizeof(EEPfileHeader)) then begin
         sEep_Err:='Ошибка чтения файла '+eepfilename+'!';
         FileClose(hblkFile);
         exit;
        end;
        x:=EEPfileHeader.eels+EEPfileHeader.eefs;
        if (x>MAX_INDEX_EEPTAB)
        or (x=0) then begin
         sEep_Err:='Ошибка формата файла '+eepfilename+'!';
         FileClose(hblkFile);
         exit;
        end;
        ClearEEPBufAndTab;
        while(x<>0) do begin
         if (FileRead(hblkFile, EEPblkHeader, sizeof(EEPblkHeader))<>sizeof(EEPblkHeader)) then begin
          sEep_Err:='Ошибка чтения файла '+eepfilename+'!';
          FileClose(hblkFile);
          exit;
         end;
         if (EEPblkHeader.len <= MAX_SIZE_EEPBLK) then begin
          if (idx_eepbuf+integer(EEPblkHeader.len) >= sizeof(Eepbuf))
          then begin
           sEep_Err:='Ошибка: Переполнение буфера сохранения EEP блоков!';
           FileClose(hblkFile);
           exit;
          end;
          if (FileRead(hblkFile,EepBuf[idx_eepbuf],EEPblkHeader.len)<>integer(EEPblkHeader.len))
          then begin
           sEep_Err:='Ошибка чтения файла '+eepfilename+'!';
           FileClose(hblkFile);
           exit;
          end;
          EepTab[idx_eeptab].num:=EEPblkHeader.num;
          EepTab[idx_eeptab].len:=EEPblkHeader.len;
          EepTab[idx_eeptab].ver:=EEPblkHeader.ver;
          EepTab[idx_eeptab].buf:=@EepBuf[idx_eepbuf];
          idx_eepbuf:=idx_eepbuf+integer(EEPblkHeader.len);
          inc(idx_eeptab);
          dec(x);
         end;
        end;
        if (FileRead(hblkFile, HW, 2)<>2) then begin
         sEep_Err:='Ошибка чтения HWID из файла '+eepfilename+'!';
        end
        else result:=True;
        FileClose(hblkFile);
end;


function AddBFCEEPBlk(num:dword; flgFind:boolean): boolean;
const
DEFRAG_BLK_SIZE = $3EE;
var
len : dword;
ver : byte;
begin
        result:=False;
        if idx_eeptab>MAX_INDEX_EEPTAB then begin
         sEep_Err:='Ошибка: Переполнение буфера таблицы EEP блоков!';
         exit;
        end;
        if Not BFC_EE_Get_Block_Info(num,len,ver) then begin
         if BFC_Error=ERR_EEP_NONE then begin
          if flgFind then result:=True
          else sEep_Err:='Нет или неоткрыт блок '+IntToStr(num)+'!';
          exit;
         end
         else if Not BFC_EE_Get_Block_Info(num,len,ver) then begin
          if BFC_Error=ERR_EEP_NONE then begin
           if flgFind then result:=True
           else sEep_Err:='Нет или неоткрыт блок '+IntToStr(num)+'!';
           exit;
          end
          else begin
           sEep_Err:='Ошибка чтения инфо по блоку '+IntToStr(num)+'!';
           exit;
          end;
         end;
        end;
        if (len > MAX_SIZE_EEPBLK) then begin
         sEep_Err:='Ошибка: Некорректный блок EEP'+IntToStr(num)+'!';
         exit;
        end
        else begin
         if (idx_eepbuf+integer(len) >= sizeof(Eepbuf)) then begin
           sEep_Err:='Ошибка: Переполнение буфера сохранения EEP блоков!';
           exit;
         end;
         if len<>0 then begin
          if Not BFC_EE_Read_Block(num,0,len,EepBuf[idx_eepbuf]) then begin
           if Not BFC_EE_Read_Block(num,0,len,EepBuf[idx_eepbuf]) then begin
            if Not BFC_EE_Read_Block(num,0,len,EepBuf[idx_eepbuf]) then begin
             sEep_Err:='Ошибка чтения блока '+IntToStr(num)+'!';
             exit;
            end;
           end;
          end;
          EepTab[idx_eeptab].num:=num;
          EepTab[idx_eeptab].len:=len;
          EepTab[idx_eeptab].ver:=ver;
          EepTab[idx_eeptab].addr:=0;
          EepTab[idx_eeptab].buf:=@EepBuf[idx_eepbuf];
          idx_eepbuf:=idx_eepbuf+integer(len);
          inc(idx_eeptab);
          result:=True;
         end; // if xlen<>0
        end; // if (xlen > MAX_SIZE_EEPBLK)
end;

end.
