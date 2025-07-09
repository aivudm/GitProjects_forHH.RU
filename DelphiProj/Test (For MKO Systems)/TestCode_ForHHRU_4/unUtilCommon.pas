unit unUtilCommon;

interface
uses Classes;


function GetSubStr(FullString:String;Index:Byte;Count:Integer):String;
function IndexInString(SubStr,FullString:String; MyPosBegin: Word): Word;
function StreamToString(Stream: TStream): String;
function translate_utf8_ansi(const Source: string):string;

implementation

function GetSubStr(FullString:String;Index:Byte;Count:Integer):String;
begin
if Count<>-1 then
   Result:=copy(FullString,Index,Count)
else
   Result:=copy(FullString,Index,(length(FullString)-Index+1));
end; // GetSubStr

function IndexInString(SubStr,FullString:String; MyPosBegin: Word): Word;
var
   MyStr: String;
begin
MyStr:= GetSubStr(FullString,MyPosBegin,-1);
Result:=pos(SubStr, MyStr);

end; // IndexInString(FullString,SubStr:String)

function StreamToString(Stream: TStream): String;
var
  ssTmp: TStringStream;
begin
//    with TStringStream.Create('') do
 ssTMP:= TStringStream.Create('');
    with ssTMP do
    try
        CopyFrom(Stream, Stream.Size - Stream.Position);
        Result := DataString;
    finally
     Free;
    end;
end;

function translate_utf8_ansi(const Source: string):string;
    var
       Iterator, SourceLength, FChar, NChar: Integer;
    begin
       Result := '';
       Iterator := 0;
       SourceLength := Length(Source);
       while Iterator < SourceLength do
       begin
          Inc(Iterator);
          FChar := Ord(Source[Iterator]);
          if FChar >= $80 then
          begin
             Inc(Iterator);
             if Iterator > SourceLength then break;
             FChar := FChar and $3F;
             if (FChar and $20) <> 0 then
             begin
                FChar := FChar and $1F;
                NChar := Ord(Source[Iterator]);
                if (NChar and $C0) <> $80 then break;
                FChar := (FChar shl 6) or (NChar and $3F);
                Inc(Iterator);
                if Iterator > SourceLength then break;
             end;
             NChar := Ord(Source[Iterator]);
             if (NChar and $C0) <> $80 then break;
             Result := Result + WideChar((FChar shl 6) or (NChar and $3F));
          end
          else
             Result := Result + WideChar(FChar);
       end;
    end;

end.
