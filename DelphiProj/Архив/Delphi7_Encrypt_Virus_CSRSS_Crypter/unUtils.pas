unit unUtils;
interface
uses  Dialogs, Sysutils,
      unVariables, unConstant;

procedure EncryptByteArray(var inputArray: PChar; inputArraySize: integer; inputKey: string);
procedure ConvertByteToUnicode(inputArray: PChar; inputArraySize: integer; var outputArray: TArrayBytes1);
//procedure CopyArrayByteToMemPtr(var inputArray: TArrayBytes1; inputArraySize: integer; var outputArray: Pointer);


var
  workingFileName: string;

implementation

procedure ConvertByteToUnicode(inputArray: PChar; inputArraySize: integer; var outputArray: TArrayBytes1);
begin
   asm
    push ebp
    push esp
    push ebx
    push esi
    push edi
    push es

    mov  esi, inputArray
    mov  edi, outputArray
    mov  ecx, inputArraySize

    xor ah, ah
@@BeginCycle:
    mov al, byte ptr [esi]
    mov word ptr [edi], ax
    inc esi
    inc edi
    inc edi
    dec ecx
    jnz @@BeginCycle

    pop es
    pop edi
    pop esi
    pop ebx
    pop esp
    pop ebp
    end;
end;

procedure EncryptByteArray(var inputArray: PChar; inputArraySize: integer; inputKey: string);
var
//    inputKey_W: WideString;
		arg_A6_0, num, tmpCardinal: cardinal;
    tmpLongInt: longint;
    num2, iCount, tmpInt1, tmpInt2: integer;
    label BeginCycle;
begin
// inputKey_W:= inputKey;

// ConvertByteToUnicode(inputArray, inputArraySize, ArrayByteUnicode);
 for iCount:= 0 to iBufferSize - 1 do
  ArrayByteUnicode[iCount]:= Byte(inputArray[iCount]);

 ConvertByteToUnicode(pchar(inputKey), length(inputKey), KeyUnicode);
 iCount:= 0;
 while true do
 begin
	arg_A6_0:= 2749045930;

  while true do
  begin
 BeginCycle:
  iCount:= iCount + 1;
  num:= arg_A6_0 xor 4033311641;
  case num mod 7 of
   0:
     begin
      if num2 < 0 then
      begin
       for iCount:= 0 to iBufferSize - 1 do
        inputArray[iCount]:= Char(ArrayByteUnicode[iCount]);
       exit;
      end;
     end;
   1:
     begin
      tmpLongInt:= (num * 3699986634);
      tmpCardinal:= tmpLongInt and $FFFFFFFF;
      arg_A6_0:= tmpCardinal xor 901457853;
     end;
   2:
		 begin
			num2:= iBufferSize;
      tmpLongInt:= (num * 230630442);
      tmpCardinal:= tmpLongInt and $FFFFFFFF;
      arg_A6_0:= tmpCardinal xor 538201483;
		 end;
   3:
		 begin
			num2:= num2 -1;
      tmpLongInt:= (num * 396011803);
      tmpCardinal:= tmpLongInt and $FFFFFFFF;
      arg_A6_0:= tmpCardinal xor 574663539;
     end;
   4:
		 goto BeginCycle;
   5:
		 begin
			ArrayByteUnicode[num2 mod iFileSize]:= Byte((((ArrayByteUnicode[num2 mod inputArraySize] xor KeyUnicode[num2 mod (iKeyLength*2)]) - ArrayByteUnicode[(num2 + 1) mod inputArraySize]) + 256) mod 256);
//      showmessage(IntToStr(num2 mod inputArraySize) + ' = ' + Inttostr(ArrayByteUnicode[num2 mod inputArraySize]));

  		arg_A6_0:= 3995546779;
     end;
   6:
		 begin
      if num2 < 0 then arg_A6_0:= 3834063671
                  else arg_A6_0:= 2995669812;
     end;
  end {case .. of};

  end {while}
 end;  {while}
end;

procedure CopyArrayByteToMemPtr(var inputArray: TArrayBytes1; inputArraySize: integer; var outputArray: Pointer);
begin
   asm
    push ebp
    push esp
    push ebx
    push esi
    push edi
    push es

    lea  esi, inputArray
    mov  edi, outputArray
    mov  ecx, inputArraySize
    cld
    push ds
    pop  es
    rep movsb

    cld
    pop es
    pop edi
    pop esi
    pop ebx
    pop esp
    pop ebp
    end;
end;

end.
