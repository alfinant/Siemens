//Использование в коммерческих целях запрещено.
//Наказание - неминуемый кряк и распространение по всему инет.
//Business application is forbidden.
//Punishment - unavoidable crack and propagation on everything inet.
unit Crc16;

interface
uses Windows,SysUtils;

//function UpdateCRC16(ch : BYTE; crc : WORD ) : WORD;
function CalcBlkCRC16(buf:pointer ; size: integer ) : WORD;

implementation

{
function UpdateCRC16(ch : BYTE; crc : WORD ) : WORD;
begin
    crc := crc xor ch;
    crc := Swap(crc);
    crc := crc xor ((crc and $ff00) shl 4);
    crc := crc xor (crc shr 12);
    crc := crc xor ((crc and $ff00) shr 5);
    result:=crc;
end;
}

function CalcBlkCRC16( buf: pointer ; size: integer ) : WORD;
begin
        result:=$FFFF;
        while size > 0 do begin
          result := result xor BYTE(buf^);
          result := Swap(result);
          result := result xor ((result and $ff00) shl 4);
          result := result xor (result shr 12);
          result := result xor ((result and $ff00) shr 5);
          Dec(size);
          Inc(DWORD(buf));
        end;
end;

end.
