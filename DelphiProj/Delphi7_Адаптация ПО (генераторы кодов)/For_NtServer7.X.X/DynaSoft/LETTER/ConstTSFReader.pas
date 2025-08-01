unit ConstTSFReader;

interface
uses
    windows, forms, sysutils, dialogs;

const
     NameINIFile: String = 'TSFReader.ini';
     DefaultTSFFileName: string = 'DBNT751';
     DefaultExtentionTSFFile: string = '.tsf';
     MaxLengthDOSPath: byte = 255;
     BeginFile= 0;

//------ InternalUnCryptTSFKey
     PosInternalUnCryptTSFKey: dword = 31; // in arrayOffsetTSFParam
//------ UnCryptTSFKey
     PosUnCryptTSFKey: dword = 25; // in arrayOffsetTSFParam
     LengthUnCryptTSFKey: dword = 6;
//--- TSF Internal Structure ----------------
     MaxTSFFieldSize: word = 256;
     TSFParamCount = 40;
     arrayOffsetTSFParam: array [1..TSFParamCount] of dword =
                          ($00, $0C, $11, $57, $70, $89, $BB,
                           $C1, $CE, $DA, $1D9, $2D8, $3D7,
                           $46D, $503, $599, $62F, $6C5, $75B,
                           $7F1, $887, $889, $890, $897, $8A3,
                           $8B0, $8C9, $8D5, $8E1, $8ED, $8F9,
                           $905, $907, $920, $952, $95C, $970,
                           $984, $998, $9AC);

     arraySizeTSFParam: array [1..TSFParamCount] of dword =
                          ($0C, $05, $46, $19, $19, $32, $06,
                           $0D, $0C, $FF, $FF, $FF, $96, $96,
                           $96, $96, $96, $96, $96, $96, $02,
                           $07, $07, $0C, $0D, $19, $0C, $0C,
                           $0C, $0C, $0C, $02, $19, $32, $0A,
                           $14, $14, $14, $14, $14);

     arrayNameTSFParam: array [1..TSFParamCount] of string =
                          ('InternalUnCryptKey#2', '', '', '', '', '', '',
                           '', '', '', '', '', '', '',
                           '', '', '', '', '', '', '',
                           '', '', '', 'UnCryptKey', '', '', '',
                           '', 'InternalUnCryptTSFKey', '', 'RegistrationNumber', 'RegistrationUserName', '', '',
                           '', '', '', '', 'RegistrationUnLockCode');

function  GetVariableFromTSFFile(MyNameFileTSF: string;
                           MyPosInFile, MyTSFParamSize: dword
                           ): dword;
function  UnCrypter(Param1, Param2: string; Param4: dword):string;
function GetInternalUnCryptTSFKey(MyTSFFileName: string): string;
function GetUnCryptTSFKey(MyTSFFileName: string): string;
function CryptToTSFFormat(MyNoCryptValue: string): string;
function SaveFileFromMemory(MyNameFile: String; Buffer:Pointer; MySizeOfFile:LongInt): boolean;

var
   lpTSFParam: Pointer;

implementation

//##################### UnCryptConverter ################################
function  UnCryptConverter(Param1, Param2: char; MyTypeOper: byte): byte;
var
   var1, var2 : dword;
begin
 asm
  mov al, Param1
//  test al, 80h  //  ����� ���������� movsx eax, al
//  jz  @@Get2Param
//  or eax, 0ffffff00h
  and eax, 000000FFh

@@Get2Param:
  mov dl, Param2
//  test dl, 80h  //  ����� ���������� movsx edx, dl
//  jz  @@End1
//  or edx, 0ffffff00h
  and edx, 000000FFh
  mov cl, MyTypeOper
  test cl, cl  // this is "ADD"
  jnz @@ToSub
  lea eax, [edx+eax-20h]
  jmp @@End1
@@ToSub:
  sub eax, edx
  add eax, 20h
@@End1:
  mov Result, al

 end;
{if MyTypeOper = 'add' then
 var1:= var1 + var2;
if MyTypeOper = 'sub' then
 var1:= var1 - var2;
Result:= byte(var1);
}
end;

//##################### UnCrypter ################################
function  UnCrypter(Param1, Param2: string; Param4: dword):string;
var
   i, j: integer;
   TekElemString, TekChar1, TekChar2: char;
   TypeOper: byte;
   TmpByte: byte;
begin
TekChar2:= chr($2A);
Result:= '';
i:= 0;
if Param4 <> 0 then
 begin
  j:= 1;
  TypeOper:= 0; //'add';
    while length(Param1) >= j do
     begin
      TekChar1:= Param1[j];
      if length(Param2)<>0 then
       begin
        if (length(Param2)-1) >= i then
         inc(i)
        else
         i:= 1;
        TekChar2:= Param2[i];
       end;
      TmpByte:= UnCryptConverter(TekChar1, TekChar2, TypeOper);
      TekElemString:= chr(TmpByte);
      Result:= Result + TekElemString;
      inc(j);
     end;
 end
else
 begin
  j:= 1;
  TypeOper:= 1; //'sub';
    while length(Param1) >= j do
     begin
      TekChar1:= Param1[j];
      if length(Param2)<>0 then
       begin
        if (length(Param2)-1) >= i then
         inc(i)
        else
         i:= 1;
        TekChar2:= Param2[i];
       end;
      TmpByte:= UnCryptConverter(TekChar1, TekChar2, TypeOper);
      TekElemString:= chr(TmpByte);
      Result:= Result + TekElemString;
      inc(j);
     end;
 end;
end;


//##################### FileOpenReadWrite ################################
function FileOpenReadWrite(MyFileName: string; Mode: Integer): Integer;
begin
if Mode=fmOpenRead then
  Result := CreateFile(PChar(MyFileName), GENERIC_READ,
     FILE_SHARE_READ, nil, OPEN_EXISTING,
     FILE_SHARE_READ,0);
if Mode=fmOpenWrite then
  Result := CreateFile(PChar(MyFileName), GENERIC_WRITE,
     FILE_SHARE_WRITE, nil, CREATE_ALWAYS,
     FILE_SHARE_WRITE,0);

end;

//######################### GetVariableFromTSFFile ############
function  GetVariableFromTSFFile(MyNameFileTSF: string;
                           MyPosInFile, MyTSFParamSize: dword
                           ): dword;
var
   MyFileHandle, PositionInFile, ActualReaded: integer;
   TSFParamSize: DWord;
begin
Result:= 0;
//FillChar(lpTSFParam, sizeof(lpTSFParam), #0);
 try
  MyFileHandle:= FileOpenReadWrite(MyNameFileTSF, FmOpenRead);
  if MyFileHandle>0 then
   begin
    PositionInFile:=FileSeek(MyFileHandle, MyPosInFile, BeginFile);
    if  PositionInFile = MyPosInFile then
     begin
{      ReadFile(MyFileHandle, buffer, SizeUnCryptTSFKey,
               ActualReaded,
               nil);
}
      asm
       xor eax, eax
       push eax
       lea edi, ActualReaded
       push edi
       push MyTSFParamSize
       mov edi, lpTSFParam
       push edi
       push MyFileHandle
       call ReadFile
      end;

      Result:= ActualReaded;
     end
    else
     MessageDlg('�� �������� ���������� ������� '+
                IntToStr(MyPosInFile)+#13#10+' in '+MyNameFileTSF,
                mtError,[mbOK],0);
    CloseHandle(MyFileHandle);
   end
  else
   begin
    MessageDlg('Windows Say: Error='+IntToStr(GetLastError)+#13#10+
               '['+SysErrorMessage(GetLastError)+']',
               mtError,[mbOK],0);
   end;
 except
  CloseHandle(MyFileHandle);
  MessageDlg('Windows Say: Error='+IntToStr(GetLastError)+#13#10+
             '['+SysErrorMessage(GetLastError)+']',
             mtError,[mbOK],0);
 end;
end;

//################## GetInternalUnCryptTSFKey ###############
function GetInternalUnCryptTSFKey(MyTSFFileName: string): string;
var
   UniversalZero: dword;
begin
try
 GetMem(lpTSFParam, arraySizeTSFParam[PosInternalUnCryptTSFKey] + 1);
 if GetVariableFromTSFFile(MyTSFFileName,
                           arrayOffsetTSFParam[PosInternalUnCryptTSFKey],
                           arraySizeTSFParam[PosInternalUnCryptTSFKey]
                           ) = arraySizeTSFParam[PosInternalUnCryptTSFKey] then
  begin
   UniversalZero:= $0000;
   result:= StrPas(lpTSFParam);
   result:= UnCrypter(result, PChar(UniversalZero),
                      UniversalZero);
  end;
finally
 FreeMem(lpTSFParam);
end;
end;

//################## GetUnCryptTSFKey ###############
function GetUnCryptTSFKey(MyTSFFileName: string): string;
var
   UniversalZero: dword;
   InternalUnCryptTSFKey: string;
begin
try
 InternalUnCryptTSFKey:= GetInternalUnCryptTSFKey(MyTSFFileName);
 GetMem(lpTSFParam, arraySizeTSFParam[PosUnCryptTSFKey] + 1);
 if GetVariableFromTSFFile(MyTSFFileName,
                           arrayOffsetTSFParam[PosUnCryptTSFKey],
                           arraySizeTSFParam[PosUnCryptTSFKey]
                           ) = arraySizeTSFParam[PosUnCryptTSFKey] then
  begin
   UniversalZero:= $0000;
   result:= StrPas(lpTSFParam);
   result:= UnCrypter(result, pchar(InternalUnCryptTSFKey),
                      UniversalZero);
  end;
finally
 FreeMem(lpTSFParam);
end;
end;

function CryptToTSFFormat(MyNoCryptValue: string): string;
var
  UniversalZero: dword;
  UnCryptTSFKey: string;
begin
 UnCryptTSFKey:= '038999';
 UniversalZero:= $0001;
 result:= UnCrypter(MyNoCryptValue, UnCryptTSFKey,
                            UniversalZero);
end;

//###################### SaveFileFromMemory #####################
function SaveFileFromMemory(MyNameFile: String; Buffer:Pointer; MySizeOfFile:LongInt): boolean;
var
   MyFileHandle,ActualeWrite:Integer;
begin // SaveFileFromMemory
result:= true;
try
 MyFileHandle:= FileOpenReadWrite(MyNameFile, FmOpenWrite);
 ActualeWrite:=0;
 if MyFileHandle>0 then  //if4
  begin
   ActualeWrite:=FileWrite(MyFileHandle,Buffer^,
                           MySizeOfFile);
   FileClose(MyFileHandle);
  end
 else      //else4
  begin
   MessageDlg('����: '#13#10
              +MyNameFile+#13#10+
              'Windows Say: Error='+IntToStr(GetLastError)+#13#10+
              '['+SysErrorMessage(GetLastError)+']',
              mtError,[mbOK],0);
   result:= false;
  end;
 if ActualeWrite=-1 then //if5
  begin
   MessageDlg('������ ������ ����� !!!'#13#10
              +MyNameFile+#13#10+
              'Windows Say: Error='+IntToStr(GetLastError)+#13#10+
              '['+SysErrorMessage(GetLastError)+']',
              mtError,[mbOK],0);
   result:= false;
  end
 else
  if MySizeOfFile<>ActualeWrite then //if5
   begin
    MessageDlg('�� ������� ��������� �������� ���� !!!'#13#10
               +MyNameFile+#13#10+
               'Windows Say: Error='+IntToStr(GetLastError)+#13#10+
               '['+SysErrorMessage(GetLastError)+']',
                mtError,[mbOK],0);
    result:= false;
   end;
except
 MessageDlg('������ �� '+#13#10+
            'Windows Say: Error='+IntToStr(GetLastError)+#13#10+
            '['+SysErrorMessage(GetLastError)+']',
            mtError,[mbOK],0);
 result:= false;
end;
end; // SaveFileFromMemory

end.
