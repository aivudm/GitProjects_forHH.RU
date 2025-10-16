unit FillMemoryZero;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

type
  TForm2 = class(TForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation
//##################### FillMemoryZero ################################
function FillMemoryZero(var MyPointer: pointer; MyMemorySize: dword):boolean; assembler;
begin
asm
 push eax
 push ebx
 push ecx
 push esi
 push edi

 xor eax, eax
 mov esi, 4
 mov ecx, MyMemorySize
 mov ebx, ecx
 and ebx, 00000003h
 shr ecx, 2
 mov edi, MyPointer
 test ecx, ecx
 jz @@FillRest

@@BeginFill:
 mov dword ptr [edi], eax
 add edi, esi
 dec ecx
 jnz @@BeginFill

@@FillRest:
 cmp ebx, eax
 jz @@ExitFromFillMemoryZero

@@BeginFillRest:
 mov byte ptr [edi], al
 inc edi
 dec ebx
 jnz @@BeginFillRest

@@ExitFromFillMemoryZero:

 pop esi
 pop edi
 pop ecx
 pop ebx
 pop eax
end;
end;

{$R *.DFM}

end.
 