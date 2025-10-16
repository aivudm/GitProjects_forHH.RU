unit GetUnKey;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Menus;

const
     ExtentionTSFFile: string = '.tsf';
//     NameFileTSF_SQLServer700: string = 'dbntsrv.tsf';
//     NameFileTSF_SQLServer751: string = 'dbnt751.tsf';
//     NameFileTSF_CenturaDevelopment151: string = 'ctd151.tsf';
//------ InternalUnCryptTSFKey_1
     PosInternalUnCryptTSFKey_1: dword = $8F9;
     SizeInternalUnCryptTSFKey_1: dword = $0C;
//------ UnCryptTSFKey
     PosUnCryptTSFKey: dword = $8A3;
     SizeUnCryptTSFKey: dword = $0D;
//------ UnCryptTSFKey
     PosTSFRegistrationNumber =  $907;
     SizeTSFRegistrationNumber = $19;

     MaxLengthRegistrationNumber: byte = 16;
     LengthUnCryptTSFKey: byte = 6;
     MaxLengthDOSPath: byte = 255;
     MaxLenTSFField: word = 256;
     BeginFile= 0;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Edit2: TEdit;
    Button1: TButton;
    GroupBox1: TGroupBox;
    CheckBox1: TCheckBox;
    MainMenu1: TMainMenu;
    Try1: TMenuItem;
    Open1: TMenuItem;
    OpenDialog1: TOpenDialog;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure Open1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  NameFileTSF: string = 'dbnt760.tsf';
  Form1: TForm1;
  FlagDigit: boolean = false;
  MyTSFParam, WorkingFileName : string;
   UniversalZero: integer;
//----- TSF Parameters----------------------
   TSFRegistrationNumber: string;
   InternalUnCryptTSFKey_1, UnCryptTSFKey: string;
implementation

//################# Replicate ###########################
function Replicate(Substr: String; Count: Word): String;
var
   i: Word;
begin // Replicate
Result:='';
for i:=1 to Count do
  Result:=Result+Substr;
end; // Replicate

//################ TransAnsiToOem #################
function TransAnsiToOem(NameString:String):String;
var
   PNameString: PChar;
begin
try
   GetMem(PNameString, MaxLenTSFField);
   StrPCopy(PNameString, NameString);
   AnsiToOem(PNameString, PNameString);
   Result:=StrPas(PNameString);
   FreeMem(PNameString, MaxLenTSFField);
except
   FreeMem(PNameString, MaxLenTSFField);
   Application.Terminate;
end;
end; // TransAnsiToOem

//##################### UnCrypter ################################
function  UnCryptConverter(Param1, Param2: char; MyTypeOper: byte): byte;
var
   var1, var2 : dword;
begin
 asm
  mov al, Param1
//  test al, 80h  //  Очень извращенно movsx eax, al
//  jz  @@Get2Param
//  or eax, 0ffffff00h
  and eax, 000000FFh

@@Get2Param:
  mov dl, Param2
//  test dl, 80h  //  Очень извращенно movsx edx, dl
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
  mov Result, al
@@End1:

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
//Result:= TransAnsiToOem(Result);
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
     FILE_SHARE_WRITE, nil, OPEN_EXISTING,
     FILE_SHARE_WRITE,0);

end;                            

//######################### GetUnCryptTSFKey ############
function  GetUnCryptTSFKey(var MyNameFileTSF: string;
//                           var MyTSFParam: string;
                           MyPosInFile, MyTSFParamSize: dword): dword;
var
   MyFileHandle, PositionInFile, ActualReaded: integer;
   Buffer: PChar;
   TSFParamSize: DWord;
begin
TSFParamSize:= MyTSFParamSize+ 1;
Result:= 0;
 try
  GetMem(buffer, TSFParamSize);
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
       mov edi, buffer
       push edi
       push MyFileHandle
       call ReadFile
      end;

      MyTSFParam:= buffer;
      Result:= ActualReaded;
      FreeMem(buffer, TSFParamSize);
     end
    else
     MessageDlg('Не возможно установить позицию '+
                IntToStr(MyPosInFile)+#13#10+' in '+MyNameFileTSF,
                mtError,[mbOK],0);
    CloseHandle(MyFileHandle);
   end
  else
   begin
    MessageDlg('Не удается открыть файл !!!'#13#10
               +MyNameFileTSF+#13#10+
               'Windows Say: Error='+IntToStr(GetLastError)+#13#10+
               '['+SysErrorMessage(GetLastError)+']',
               mtError,[mbOK],0);
   end;
 except
  CloseHandle(MyFileHandle);
  FreeMem(buffer, TSFParamSize);
  MessageDlg('Ошибка ОС '+#13#10+
             'Windows Say: Error='+IntToStr(GetLastError)+#13#10+
             '['+SysErrorMessage(GetLastError)+']',
             mtError,[mbOK],0);
  Application.Terminate;
 end;
end;


//######################### GetDigitUnlockCode ############
function  GetDigitUnlockCode(MyCharParam1, MyCharParam2, MyCharParam3, MyCharParam4, MyCharParam5: char): string;
var
   TekByte: integer;
   MyByteParam1, MyByteParam2, MyByteParam3, MyByteParam4, MyByteParam5: byte;
begin
 MyByteParam1:= StrToInt(MyCharParam1);
 MyByteParam2:= StrToInt(MyCharParam2);
 MyByteParam3:= StrToInt(MyCharParam3);
 MyByteParam4:= StrToInt(MyCharParam4);
 MyByteParam5:= StrToInt(MyCharParam5);

 TekByte:= MyByteParam5+ MyByteParam4;
 if TekByte > 9 then
  begin
   TekByte:= TekByte - $0A;
  end;

 TekByte:= TekByte - MyByteParam3;
 if TekByte < 0 then
  TekByte:= TekByte + $0A;

 TekByte:= TekByte + MyByteParam2;
 if TekByte > 9 then
  TekByte:= TekByte - $0A;

 TekByte:= TekByte - MyByteParam1;
 if TekByte < 0 then
  TekByte:= TekByte + $0A;

Result:= IntToStr(TekByte);

end;

//######################### GetUnlockCode ############
function  GetUnlockCode(MyRegNumber, MyUnlockTSFKey: string): string;
var
   TekChar: Char;
begin
 Result:= '';
 if length(MyUnlockTSFKey) = LengthUnCryptTSFKey then
  begin
//--------- Digit # 1 --
   Result:= Result + GetDigitUnlockCode(MyRegNumber[5], MyRegNumber[16], MyUnlockTSFKey[1],
                                      MyRegNumber[8], MyRegNumber[1]);
//--------- Digit # 2 --
   Result:= Result + GetDigitUnlockCode(MyRegNumber[6], MyRegNumber[15], MyUnlockTSFKey[2],
                                      MyRegNumber[7], MyRegNumber[2]);
//--------- Digit # 3 --
   Result:= Result + GetDigitUnlockCode(MyRegNumber[7], MyRegNumber[14], MyUnlockTSFKey[3],
                                      MyRegNumber[6], MyRegNumber[3]);
//--------- Digit # 4 --
   Result:= Result + GetDigitUnlockCode(MyRegNumber[8], MyRegNumber[13], MyUnlockTSFKey[4],
                                      MyRegNumber[5], MyRegNumber[4]);
//--------- Digit # 5 --
   Result:= Result + GetDigitUnlockCode(MyRegNumber[9], MyRegNumber[12], MyUnlockTSFKey[5],
                                      MyRegNumber[4], MyRegNumber[5]);
//--------- Digit # 6 --
   Result:= Result + GetDigitUnlockCode(MyRegNumber[10], MyRegNumber[11], MyUnlockTSFKey[6],
                                      MyRegNumber[3], MyRegNumber[6]);
//--------- Digit # 7 --
   Result:= Result + GetDigitUnlockCode(MyRegNumber[11], MyRegNumber[10], MyUnlockTSFKey[1],
                                      MyRegNumber[2], MyRegNumber[7]);
//--------- Digit # 8 --
   Result:= Result + GetDigitUnlockCode(MyRegNumber[12], MyRegNumber[9], MyUnlockTSFKey[2],
                                      MyRegNumber[1], MyRegNumber[8]);
//--------- Digit # 9 --
   Result:= Result + GetDigitUnlockCode(MyRegNumber[12], MyRegNumber[16], MyUnlockTSFKey[3],
                                      MyRegNumber[16], MyRegNumber[9]);
//--------- Digit # 10 --
   Result:= Result + GetDigitUnlockCode(MyRegNumber[13], MyRegNumber[15], MyUnlockTSFKey[4],
                                      MyRegNumber[15], MyRegNumber[10]);
//--------- Digit # 11 --
   Result:= Result + GetDigitUnlockCode(MyRegNumber[14], MyRegNumber[14], MyUnlockTSFKey[5],
                                      MyRegNumber[14], MyRegNumber[11]);
//--------- Digit # 12 --
   Result:= Result + GetDigitUnlockCode(MyRegNumber[15], MyRegNumber[13], MyUnlockTSFKey[6],
                                      MyRegNumber[13], MyRegNumber[12]);
//--------- Digit # 13 --
   Result:= Result + GetDigitUnlockCode(MyRegNumber[16], MyRegNumber[12], MyUnlockTSFKey[1],
                                      MyRegNumber[12], MyRegNumber[13]);
//--------- Digit # 14 --
   Result:= Result + GetDigitUnlockCode(MyRegNumber[5], MyRegNumber[11], MyUnlockTSFKey[2],
                                      MyRegNumber[11], MyRegNumber[14]);
//--------- Digit # 15 --
   Result:= Result + GetDigitUnlockCode(MyRegNumber[6], MyRegNumber[10], MyUnlockTSFKey[3],
                                      MyRegNumber[10], MyRegNumber[15]);
//--------- Digit # 16 --
   Result:= Result + GetDigitUnlockCode(MyRegNumber[7], MyRegNumber[9], MyUnlockTSFKey[4],
                                      MyRegNumber[9], MyRegNumber[16]);
 end
else
 MessageDlg('InternalError: Bad length UnCryptTSFKey...',
             mtError,[mbOK],0);

end;

//######################### IsDigit ############
function IsDigit(MyOperand: string):Boolean;
var
   i:byte;
begin
Result:=True;
try
for i:=1 to length(MyOperand) do
if (ord(MyOperand[i])<48) or
   (ord(MyOperand[i])>57) then
 begin
  Result:=False;
  Exit;
 end;
except
 Result:=False;
end;
end; // IsDigit

{$R *.DFM}
procedure TForm1.Button1Click(Sender: TObject);
begin
if Form1.Edit1.Text<>'' then
 begin
  if IsDigit(Form1.Edit1.Text) then
   begin
    if FileExists(WorkingFileName) then
     begin
      if GetUnCryptTSFKey(WorkingFileName, {MyTSFParam,}
                          PosUnCryptTSFKey, SizeUnCryptTSFKey) = SizeUnCryptTSFKey then
       begin
        UnCryptTSFKey:= MyTSFParam;
        UnCryptTSFKey:= UnCrypter(UnCryptTSFKey, InternalUnCryptTSFKey_1,
                                  UniversalZero);
       end
      else
       MessageDlg('DynaSoft error...',
                  mtError,[mbOK],0);
      Form1.Edit2.Text:=GetUnlockCode(Form1.Edit1.Text,
                                      copy(UnCryptTSFKey, 1, LengthUnCryptTSFKey));
     end
    else
       MessageDlg('DynaSoft error...',
                  mtError,[mbOK],0);
   end
  else
   MessageDlg('Не цифровой символ в RegistrationNumber',
              mtError,[mbOK],0);
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
   PathBuffer: PChar;
begin
Form1.Edit1.MaxLength:= MaxLengthRegistrationNumber;
try
 GetMem(PathBuffer, MaxLengthDOSPath);
 GetWindowsDirectory(PathBuffer, MaxLengthDOSPath);
 WorkingFileName:= StrPas(PathBuffer);
 if WorkingFileName[length(WorkingFileName)]<>'\' then
  WorkingFileName:= WorkingFileName+'\';
 WorkingFileName:= WorkingFileName+ NameFileTSF;
    if FileExists(WorkingFileName) then
     begin
      if GetUnCryptTSFKey(WorkingFileName, {MyTSFParam,}
                          PosInternalUnCryptTSFKey_1, SizeInternalUnCryptTSFKey_1) = SizeInternalUnCryptTSFKey_1 then
       begin
        UniversalZero:= $0000;
        InternalUnCryptTSFKey_1:= MyTSFParam;
        InternalUnCryptTSFKey_1:= UnCrypter(InternalUnCryptTSFKey_1, PChar(UniversalZero),
                                            UniversalZero);
       end;
     end
    else
     MessageDlg('DynaSoft error...',
                 mtError,[mbOK],0);
finally
 FreeMem(PathBuffer, MaxLengthDOSPath);
end;
end;

procedure TForm1.Edit1Change(Sender: TObject);
begin
Form1.Edit2.Text:= '';
 if length(Form1.Edit1.Text) = MaxLengthRegistrationNumber then
  begin
   Form1.Button1.Enabled:= true;
   Form1.Button1.SetFocus;
  end
 else
  Form1.Button1.Enabled:= false;
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
if not Form1.CheckBox1.Checked then
 begin
  Form1.Edit1.Text:= '';
 end
else
 begin
  if GetUnCryptTSFKey(WorkingFileName, {MyTSFParam,}
                       PosTSFRegistrationNumber, SizeTSFRegistrationNumber) = SizeTSFRegistrationNumber then
   begin
    TSFRegistrationNumber:= MyTSFParam;
    TSFRegistrationNumber:= UnCrypter(TSFRegistrationNumber, InternalUnCryptTSFKey_1,
                              UniversalZero);
    Form1.Edit1.Text:= TSFRegistrationNumber;
   end
  else
   MessageDlg('DynaSoft error...',
               mtError,[mbOK],0);
 end;
end;

procedure TForm1.Open1Click(Sender: TObject);
begin
 OpenDialog1.InitialDir:='c:\';
 OpenDialog1.FileName:='';
 OpenDialog1.Execute;
 Form1.Update;
if (FileExists(Form1.OpenDialog1.FileName)) and
   (ExtractFileExt(Form1.OpenDialog1.FileName) = ExtentionTSFFile) then
 begin
   NameFileTSF:= OpenDialog1.FileName;
 end
else
 MessageDlg('Sorry, but this exactly not our file of DynaSoft...',
            mtInformation,[mbOK],0);

end;

end.


