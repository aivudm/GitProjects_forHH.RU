unit unErrorException;

interface
uses
  Windows, SysUtils, Classes, ActiveX, ComObj, VarUtils;

type
  TDebugName = String[99];


  ECheckedInterfacedObjectError = class(Exception);
    ECheckedInterfacedObjectDeleteError = class(ECheckedInterfacedObjectError);
    ECheckedInterfacedObjectDoubleFreeError = class(ECheckedInterfacedObjectError);
    ECheckedInterfacedObjectUseDeletedError = class(ECheckedInterfacedObjectError);

const
  CUSTOMER_BIT         = 1 shl 29;
  EAbortRaisedHRESULT  = HRESULT(E_ABORT or CUSTOMER_BIT);

type
  TInitFunc = procedure(const AOptions: IUnknown);
  TDoneFunc = procedure;
  TInitDoneFunc = record
    Init: TInitFunc;
    Done: TDoneFunc;
  end;

type
  TAbsJump = packed record
    MovOpCode: Byte; // B8 - MOV EAX, xyz
    Ref: Pointer;
    JMP: Word;       // FF20 - JMP [EAX]
    Addr: Pointer;
  end;

const
  JumpToMemSz = SizeOf(TAbsJump);

type
  JmpInstruction =
  packed record
    opCode:   Byte;
    distance: Longint;
  end;

  PExcDescEntry = ^TExcDescEntry;
  TExcDescEntry = record
    vTable:  Pointer;
    handler: Pointer;
  end;

  PExcDesc = ^TExcDesc;
  TExcDesc = packed record
    jmp: JmpInstruction;
    case Integer of
    0:      (instructions: array [0..0] of Byte);
    1{...}: (cnt: Integer; excTab: array [0..0{cnt-1}] of TExcDescEntry);
  end;

  PExcFrame = ^TExcFrame;
  TExcFrame = record
    next: PExcFrame;
    desc: PExcDesc;
    hEBP: Pointer;
    case Integer of
    0:  ( );
    1:  ( ConstructedObject: Pointer );
    2:  ( SelfOfMethod: Pointer );
  end;





function HandleSafeCallException(ExceptObj: TObject; ErrorAddr: Pointer): HRESULT;
procedure RaiseSafeCallException(ErrorCode: HResult; ErrorAddr: Pointer);
procedure FixSafeCallExceptions;


const
  // LoadLibraryEx:
  DONT_RESOLVE_DLL_REFERENCES         = $00000001;
  LOAD_LIBRARY_AS_DATAFILE            = $00000002;
  LOAD_WITH_ALTERED_SEARCH_PATH       = $00000008;
  LOAD_IGNORE_CODE_AUTHZ_LEVEL        = $00000010;
  LOAD_LIBRARY_AS_IMAGE_RESOURCE      = $00000020;
  LOAD_LIBRARY_AS_DATAFILE_EXCLUSIVE  = $00000040;
  LOAD_LIBRARY_SEARCH_DLL_LOAD_DIR    = $00000100;
  LOAD_LIBRARY_SEARCH_APPLICATION_DIR = $00000200;
  LOAD_LIBRARY_SEARCH_USER_DIRS       = $00000400;
  LOAD_LIBRARY_SEARCH_SYSTEM32        = $00000800;
  LOAD_LIBRARY_SEARCH_DEFAULT_DIRS    = $00001000;

  // SetSearchPathMode:
  BASE_SEARCH_PATH_ENABLE_SAFE_SEARCHMODE  = $00000001;
  BASE_SEARCH_PATH_PERMANENT               = $00008000;
  BASE_SEARCH_PATH_DISABLE_SAFE_SEARCHMODE = $00010000;

  // SetDefaultDllDirectories:
  // LOAD_LIBRARY_SEARCH_APPLICATION_DIR = $00000200;
  // LOAD_LIBRARY_SEARCH_USER_DIRS       = $00000400;
  // LOAD_LIBRARY_SEARCH_SYSTEM32        = $00000800;
  // LOAD_LIBRARY_SEARCH_DEFAULT_DIRS    = $00001000;

  // Идентификатор нашей системы передачи исключений
  SampleDllIID: TGUID  = '{AA76E538-EF3C-4F35-9914-B4801B211A6D}';

  // Коды ошибок (возвращаются HResultCode)
  // Их можно использовать если:
  // 1. 29-й Customer бит должен быть установлен
  // 2. Тип HRESULT должен быть FACILITY_ITF
  // 3. GUID ошибки равен SampleDllIID
  E_C_AbstractError               = $35A1;
  E_C_ArgumentException           = $80ED;
  E_C_ArgumentNilException        = $E0A0;
  E_C_ArgumentOutOfRangeException = $CEB5;
  E_C_BitsError                   = $93DD;
  E_C_ClassNotFound               = $CBA2;
  E_C_CodesetConversion           = $10C6;
  E_C_ComponentError              = $CD10;
  E_C_ConvertError                = $599A;
  E_C_DirectoryNotFoundException  = $D378;
  E_C_External                    = $2DF0;
  E_C_ExternalException           = $EE3F;
  E_C_FCreateError                = $8DEB;
  E_C_FileNotFoundException       = $CE9F;
  E_C_FilerError                  = $6677;
  E_C_FileStreamError             = $B0C7;
  E_C_FOpenError                  = $5C5D;
  E_C_HeapException               = $273E;
  E_C_InOutError                  = $EB24;
  E_C_IntError                    = $053E;
  E_C_IntfCastError               = $328D;
  E_C_InvalidCast                 = $C871;
  E_C_InvalidContainer            = $952F;
  E_C_InvalidImage                = $3CE9;
  E_C_InvalidInsert               = $EE6B;
  E_C_InvalidOperation            = $B715;
  E_C_InvalidOpException          = $8C3C;
  E_C_InvalidPointer              = $4F8B;
  E_C_ListError                   = $72A5;
  E_C_MathError                   = $023B;
  E_C_MethodNotFound              = $47F5;
  E_C_Monitor                     = $6295;
  E_C_MonitorLockException        = $482F;
  E_C_NoConstructException        = $233E;
  E_C_NoMonitorSupportException   = $5E14;
  E_C_OutOfResources              = $B2C5;
  E_C_PackageError                = $5447;
  E_C_ParserError                 = $CF64;
  E_C_PathTooLongException        = $2CC9;
  E_C_ProgrammerNotFound          = $F8CA;
  E_C_PropReadOnly                = $B6EA;
  E_C_PropWriteOnly               = $4783;
  E_C_Quit                        = $D7F4;
  E_C_RangeError                  = $E1B0;
  E_C_ReadError                   = $46AD;
  E_C_ResNotFound                 = $AF4A;
  E_C_StreamError                 = $49E3;
  E_C_StringListError             = $C014;
  E_C_VariantError                = $E2A8;
  E_C_WriteError                  = $EECE;


implementation
uses unVariables;

function SetErrorInfo(const ErrorCode: HRESULT; const ErrorIID: TGUID;
  const Source, Description, HelpFileName: WideString;
  const HelpContext: Integer): HRESULT;
var
  CreateError: ICreateErrorInfo;
  ErrorInfo: IErrorInfo;
begin
  Result := E_UNEXPECTED;
  if Succeeded(CreateErrorInfo(CreateError)) then
  begin
    CreateError.SetGUID(ErrorIID);
    if Source <> '' then
      CreateError.SetSource(PWideChar(Source));
    if HelpFileName <> '' then
      CreateError.SetHelpFile(PWideChar(HelpFileName));
    if Description <> '' then
      CreateError.SetDescription(PWideChar(Description));
    if HelpContext <> 0 then
      CreateError.SetHelpContext(HelpContext);
    if ErrorCode <> 0 then
      Result := ErrorCode;
    if CreateError.QueryInterface(IErrorInfo, ErrorInfo) = S_OK then
      ActiveX.SetErrorInfo(0, ErrorInfo);
  end;
end;

function GetErrorInfo(out ErrorIID: TGUID; out Source, Description, HelpFileName: WideString; out HelpContext: Longint): Boolean;
var
  ErrorInfo: IErrorInfo;
begin
  if ActiveX.GetErrorInfo(0, ErrorInfo) = S_OK then
  begin
    ErrorInfo.GetGUID(ErrorIID);
    ErrorInfo.GetSource(Source);
    ErrorInfo.GetDescription(Description);
    ErrorInfo.GetHelpFile(HelpFileName);
    ErrorInfo.GetHelpContext(HelpContext);
    Result := (Description <> '') or (Source <> '') or (not CompareMem(@ErrorIID, @GUID_NULL, SizeOf(ErrorIID)));
  end
  else
  begin
    FillChar(ErrorIID, SizeOf(ErrorIID), 0);
    Source := '';
    Description := '';
    HelpFileName := '';
    HelpContext := 0;
    Result := False;
  end;
end;

function SDBMHash(const AData: Pointer; const ADataSize: Cardinal): Cardinal; overload;
var
  P: PByte;
  X: Integer;
begin
  Result := 0;

  P := AData;
  if (P = nil) or (ADataSize = 0) then
    Exit;

  {$R-}
  for X := ADataSize - 1 downto 0 do
  begin
    Result := P^ + (Result shl 6) + (Result shl 16) - Result;
    Inc(P);
  end;
  {$R+}
end;

function SDBMHash(const AData: RawByteString): Cardinal; overload;
begin
  Result := SDBMHash(Pointer(AData), Length(AData));
end;

function Hash(const AData: WideString): Word;
var
  Code: Cardinal;
begin
  Code := SDBMHash(UTF8Encode(AData));
  Result := Word(Code);
end;

const
  cDelphiException = $0EEDFADE;

function Exception2HRESULT(const E: TObject): HRESULT;

  function NTSTATUSFromException(const E: EExternal): DWORD;
  begin
    if E.InheritsFrom(EDivByZero) then
      Result := STATUS_INTEGER_DIVIDE_BY_ZERO
    else
    if E.InheritsFrom(ERangeError) then
      Result := STATUS_ARRAY_BOUNDS_EXCEEDED
    else
    if E.InheritsFrom(EIntOverflow) then
      Result := STATUS_INTEGER_OVERFLOW
    else
    if E.InheritsFrom(EInvalidOp) then
      Result := STATUS_FLOAT_INVALID_OPERATION
    else
    if E.InheritsFrom(EZeroDivide) then
      Result := STATUS_FLOAT_DIVIDE_BY_ZERO
    else
    if E.InheritsFrom(EOverflow) then
      Result := STATUS_FLOAT_OVERFLOW
    else
    if E.InheritsFrom(EUnderflow) then
      Result := STATUS_FLOAT_UNDERFLOW
    else
    if E.InheritsFrom(EAccessViolation) then
      Result := STATUS_ACCESS_VIOLATION
    else
    if E.InheritsFrom(EPrivilege) then
      Result := STATUS_PRIVILEGED_INSTRUCTION
    else
    if E.InheritsFrom(EControlC) then
      Result := STATUS_CONTROL_C_EXIT
    else
    {$WARNINGS OFF}
    if E.InheritsFrom(EStackOverflow) then
    {$WARNINGS ON}
      Result := STATUS_STACK_OVERFLOW
    else
      Result := STATUS_NONCONTINUABLE_EXCEPTION;
  end;

begin
  if E = nil then
    Result := E_UNEXPECTED
  else
  if not E.InheritsFrom(Exception) then
    Result := E_UNEXPECTED
  else
  if E.ClassType = Exception then
    Result := E_FAIL
  else
  if E.InheritsFrom(ESafecallException) then
    Result := E_FAIL
  else
  if E.InheritsFrom(EAssertionFailed) then
    Result := E_UNEXPECTED
  else
  if E.InheritsFrom(EAbort) then
    Result := EAbortRaisedHRESULT
  else
  if E.InheritsFrom(EOutOfMemory) then
    Result := E_OUTOFMEMORY
  else
  if E.InheritsFrom(ENotImplemented) then
    Result := E_NOTIMPL
  else
  if E.InheritsFrom(ENotSupportedException) then
    Result := E_NOINTERFACE
  else
  if E.InheritsFrom(EOleSysError) then
    Result := EOleSysError(E).ErrorCode
  else
  if E.InheritsFrom(ESafeArrayError) then
    Result := ESafeArrayError(E).ErrorCode
  else
  if E.InheritsFrom(EOSError) then
    Result := HResultFromWin32(EOSError(E).ErrorCode)
  else
  if E.InheritsFrom(EExternal) then
    if Failed(HRESULT(EExternal(E).ExceptionRecord.ExceptionCode)) then
      Result := HResultFromNT(Integer(EExternal(E).ExceptionRecord.ExceptionCode))
    else
      Result := HResultFromNT(Integer(NTSTATUSFromException(EExternal(E))))
  else
    Result := MakeResult(SEVERITY_ERROR, FACILITY_ITF, Hash(E.ClassName)) or CUSTOMER_BIT;
end;

function HRESULT2Exception(const E: HRESULT; var ErrorAddr: Pointer): Exception;

  // Немного изменённая копия кода из SysUtils
  // К сожалению, он не публичный, поэтому копируем
  // Устанавливает соответствие между
  // системными кодами NTStatus и классами исключений
  function MapNTStatus(const ANTStatus: DWORD): ExceptClass;
  begin
    case ANTStatus of
      STATUS_INTEGER_DIVIDE_BY_ZERO:
        Result := EDivByZero;
      STATUS_ARRAY_BOUNDS_EXCEEDED:
        Result := ERangeError;
      STATUS_INTEGER_OVERFLOW:
        Result := EIntOverflow;
      STATUS_FLOAT_INEXACT_RESULT,
      STATUS_FLOAT_INVALID_OPERATION,
      STATUS_FLOAT_STACK_CHECK:
        Result := EInvalidOp;
      STATUS_FLOAT_DIVIDE_BY_ZERO:
        Result := EZeroDivide;
      STATUS_FLOAT_OVERFLOW:
        Result := EOverflow;
      STATUS_FLOAT_UNDERFLOW,
      STATUS_FLOAT_DENORMAL_OPERAND:
        Result := EUnderflow;
      STATUS_ACCESS_VIOLATION:
        Result := EAccessViolation;
      STATUS_PRIVILEGED_INSTRUCTION:
        Result := EPrivilege;
      STATUS_CONTROL_C_EXIT:
        Result := EControlC;
      STATUS_STACK_OVERFLOW:
      {$WARNINGS OFF}
        Result := EStackOverflow;
      {$WARNINGS ON}
      else
        Result := EExternal;
    end;
  end;

  function MapException(const ACode: DWORD): ExceptClass;
  begin
    case ACode of
      E_C_AbstractError:               Result := EAbstractError;
      E_C_ArgumentException:           Result := EArgumentException;
      E_C_ArgumentNilException:        Result := EArgumentNilException;
      E_C_ArgumentOutOfRangeException: Result := EArgumentOutOfRangeException;
      E_C_BitsError:                   Result := EBitsError;
      E_C_ClassNotFound:               Result := EClassNotFound;
//      E_C_CodesetConversion:           Result := ECodesetConversion;
      E_C_ComponentError:              Result := EComponentError;
      E_C_ConvertError:                Result := EConvertError;
      E_C_DirectoryNotFoundException:  Result := EDirectoryNotFoundException;
      E_C_External:                    Result := EExternal;
      E_C_ExternalException:           Result := EExternalException;
      E_C_FCreateError:                Result := EFCreateError;
      E_C_FileNotFoundException:       Result := EFileNotFoundException;
      E_C_FilerError:                  Result := EFilerError;
      E_C_FileStreamError:             Result := EFileStreamError;
      E_C_FOpenError:                  Result := EFOpenError;
      E_C_HeapException:               Result := EHeapException;
      E_C_InOutError:                  Result := EInOutError;
      E_C_IntError:                    Result := EIntError;
      E_C_IntfCastError:               Result := EIntfCastError;
      E_C_InvalidCast:                 Result := EInvalidCast;
      E_C_InvalidContainer:            Result := EInvalidContainer;
      E_C_InvalidImage:                Result := EInvalidImage;
      E_C_InvalidInsert:               Result := EInvalidInsert;
      E_C_InvalidOperation:            Result := EInvalidOperation;
      E_C_InvalidOpException:          Result := EInvalidOpException;
      E_C_InvalidPointer:              Result := EInvalidPointer;
      E_C_ListError:                   Result := EListError;
      E_C_MathError:                   Result := EMathError;
      E_C_MethodNotFound:              Result := EMethodNotFound;
      E_C_Monitor:                     Result := EMonitor;
      E_C_MonitorLockException:        Result := EMonitorLockException;
      E_C_NoConstructException:        Result := ENoConstructException;
      E_C_NoMonitorSupportException:   Result := ENoMonitorSupportException;
      E_C_OutOfResources:              Result := EOutOfResources;
      E_C_PackageError:                Result := EPackageError;
      E_C_ParserError:                 Result := EParserError;
      E_C_PathTooLongException:        Result := EPathTooLongException;
      E_C_ProgrammerNotFound:          Result := EProgrammerNotFound;
      E_C_PropReadOnly:                Result := EPropReadOnly;
      E_C_PropWriteOnly:               Result := EPropWriteOnly;
//      E_C_Quit:                        Result := EQuit;
      E_C_RangeError:                  Result := ERangeError;
      E_C_ReadError:                   Result := EReadError;
      E_C_ResNotFound:                 Result := EResNotFound;
      E_C_StreamError:                 Result := EStreamError;
      E_C_StringListError:             Result := EStringListError;
      E_C_VariantError:                Result := EVariantError;
      E_C_WriteError:                  Result := EWriteError;
    else
      Result := Exception;
    end;
  end;

var
  NTStatus: DWORD;
  ErrorIID: TGUID;
  Source: WideString;
  Description: WideString;
  HelpFileName: WideString;
  HelpContext: Integer;
begin
  if GetErrorInfo(ErrorIID, Source, Description, HelpFileName, HelpContext) then
  begin
    if Pointer(StrToInt64Def(Source, 0)) <> nil then
      ErrorAddr := Pointer(StrToInt64(Source));
  end
  else
    Description := SysErrorMessage(DWORD(E));

  if (E = E_FAIL) or (E = E_UNEXPECTED) then
    Result := Exception.Create(Description)
  else
  if E = EAbortRaisedHRESULT then
    Result := EAbort.Create(Description)
  else
  if E = E_OUTOFMEMORY then
  begin
    OutOfMemoryError;
    Result := nil;
  end
  else
  if E = E_NOTIMPL then
    Result := ENotImplemented.Create(Description)
  else
  if E = E_NOINTERFACE then
    Result := ENotSupportedException.Create(Description)
  else
  if HResultFacility(E) = FACILITY_WIN32 then
  begin
    Result := EOSError.Create(Description);
    EOSError(Result).ErrorCode := HResultCode(E);
  end
  else
  if E and FACILITY_NT_BIT <> 0 then
  begin
    // Получаем класс исключения по коду
    NTStatus := Cardinal(E) and (not FACILITY_NT_BIT);
    Result := MapNTStatus(NTStatus).Create(Description);

    // На всякий случай делаем заглушку для ExceptionRecord
    ReallocMem(Pointer(Result), Result.InstanceSize + SizeOf(TExceptionRecord));
    EExternal(Result).ExceptionRecord := Pointer(NativeUInt(Result) + Cardinal(Result.InstanceSize));
    FillChar(EExternal(Result).ExceptionRecord^, SizeOf(TExceptionRecord), 0);

    EExternal(Result).ExceptionRecord.ExceptionCode := cDelphiException;
    EExternal(Result).ExceptionRecord.ExceptionAddress := ErrorAddr;
  end
  else
  if (E and CUSTOMER_BIT <> 0) and
     (HResultFacility(E) = FACILITY_ITF) and
     CompareMem(@SampleDllIID, @ErrorIID, SizeOf(ErrorIID)) then
    Result := MapException(HResultCode(E)).Create(Description)
  else
    Result := EOleException.Create(Description, E, Source, HelpFileName, HelpContext);
end;

{ TBaseObject }

resourcestring
  rsInvalidDelete  = 'Попытка удалить объект %s при активной интерфейсной ссылке; счётчик ссылок: %d';
  rsDoubleFree     = 'Попытка повторно удалить уже удалённый объект %s';
  rsUseDeleted     = 'Попытка использовать уже удалённый объект %s';


function HandleSafeCallException(ExceptObj: TObject; ErrorAddr: Pointer): HRESULT;
var
  ErrorMessage: WideString;
  HelpFileName: WideString;
  HelpContext: Integer;
begin
  if ExceptObj is Exception then
    ErrorMessage := Exception(ExceptObj).Message
  else
    ErrorMessage := SysErrorMessage(DWORD(E_FAIL));
  if ExceptObj is EOleException then
  begin
    HelpFileName := EOleException(ExceptObj).HelpFile;
    HelpContext := EOleException(ExceptObj).HelpContext;
  end
  else
  begin
    HelpFileName := '';
    if ExceptObj is Exception then
      HelpContext := Exception(ExceptObj).HelpContext
    else
      HelpContext := 0;
  end;

  Result := SetErrorInfo(Exception2HRESULT(ExceptObj), SampleDllIID,
    '$' + IntToHex(NativeUInt(ErrorAddr), SizeOf(ErrorAddr) * 2), ErrorMessage,
    HelpFileName, HelpContext);
end;

procedure RaiseSafeCallException(ErrorCode: HResult; ErrorAddr: Pointer);
var
  E: Exception;
begin
  E := HRESULT2Exception(ErrorCode, ErrorAddr);
  raise E at ErrorAddr;
end;

//_______________________________________________________________

type
  PExceptionRecord = ^TExceptionRecord;
  TExceptionRecord = record
    ExceptionCode: Cardinal;
    ExceptionFlags: Cardinal;
    ExceptionRecord: PExceptionRecord;
    ExceptionAddress: Pointer;
    NumberParameters: Cardinal;
    case {IsOsException:} Boolean of
      True:  (ExceptionInformation : array [0..14] of NativeUInt);
      False: (ExceptAddr: Pointer; ExceptObject: Pointer);
  end;
  TExceptClsProc = function(P: PExceptionRecord): Pointer{ExceptClass};
  TExceptObjProc = function(P: PExceptionRecord): Pointer{Exception};
  TRaiseExceptObjProc = procedure(P: PExceptionRecord);

const
  cNonContinuable     = 1;
  cUnwinding          = 2;
  cUnwindingForExit   = 4;
  cUnwindInProgress   = cUnwinding or cUnwindingForExit;
  EXCEPTION_CONTINUE_SEARCH    = 0;


procedure _FpuInit;
asm
        FNINIT
        FWAIT
{$IFDEF PIC}
        CALL    GetGOT
        MOV     EAX,[EAX].OFFSET Default8087CW
        FLDCW   [EAX]
{$ELSE}
        FLDCW   Default8087CW
{$ENDIF}
end;

function Fix(excPtr: PExceptionRecord; errPtr: PExcFrame): PExceptionRecord;

  procedure Init;

    procedure FPUInit; assembler;
    asm
      CLD
      FNINIT
      FWAIT
    end;

  begin
    FPUInit;
    Set8087CW(Default8087CW);
  end;

var
  Rslt: TExceptionRecord;
  ExObj: TObject;
begin
  Result := excPtr;
  if (excPtr.ExceptionFlags = cUnwindInProgress) or
     (excPtr.ExceptionCode = cDelphiException) or
     (ExceptObjProc = nil) then
    Exit;

  Init;

  ExObj := TExceptObjProc(ExceptObjProc)(excPtr);

  FillChar(Rslt, SizeOf(Rslt), 0);
  Rslt.ExceptionCode := cDelphiException;
  Rslt.ExceptionFlags := cNonContinuable;
  Rslt.NumberParameters := 7;
  Rslt.ExceptAddr := excPtr^.ExceptionAddress;
  Rslt.ExceptObject := ExObj;

  Move(Rslt, excPtr^, SizeOf(Rslt));
  Result := excPtr;
end;

procedure FixedHandleAutoException; assembler;
asm
  MOV   EAX,[ESP+4]
  MOV   EDX,[ESP+8]
  CALL  FIX

        { ->    [ESP+ 4] excPtr: PExceptionRecord       }
        {       [ESP+ 8] errPtr: PExcFrame              }
        {       [ESP+12] ctxPtr: Pointer                }
        {       [ESP+16] dspPtr: Pointer                }
        { <-    EAX return value - always one           }

        MOV     EAX,[ESP+4]
        TEST    [EAX].TExceptionRecord.ExceptionFlags,cUnwindInProgress
        JNE     @@exit

        CMP     [EAX].TExceptionRecord.ExceptionCode,cDelphiException
        CLD
        CALL    _FpuInit
        JE      @@DelphiException
        CMP     BYTE PTR JITEnable,0
        JBE     @@DelphiException
        CMP     BYTE PTR DebugHook,0
        JA      @@DelphiException

@@DoUnhandled:
        LEA     EAX,[ESP+4]
        PUSH    EAX
        CALL    UnhandledExceptionFilter
        CMP     EAX,EXCEPTION_CONTINUE_SEARCH
        JE      @@exit
        MOV     EAX,[ESP+4]
        JMP     @@GoUnwind

@@DelphiException:
        CMP     BYTE PTR JITEnable,1
        JBE     @@GoUnwind
        CMP     BYTE PTR DebugHook,0
        JA      @@GoUnwind
        JMP     @@DoUnhandled

@@GoUnwind:
        OR      [EAX].TExceptionRecord.ExceptionFlags,cUnwinding

        PUSH    ESI
        PUSH    EDI
        PUSH    EBP

        MOV     EDX,[ESP+8+3*4]

        PUSH    0
        PUSH    EAX
        PUSH    offset @@returnAddress
        PUSH    EDX
        CALL    RtlUnwindProc

@@returnAddress:
        POP     EBP
        POP     EDI
        POP     ESI
        MOV     EAX,[ESP+4]
        MOV     EBX,8000FFFFH
        CMP     [EAX].TExceptionRecord.ExceptionCode,cDelphiException
        JNE     @@done

        MOV     EDX,[EAX].TExceptionRecord.ExceptObject
        MOV     ECX,[EAX].TExceptionRecord.ExceptAddr
        MOV     EAX,[ESP+8]
        MOV     EAX,[EAX].TExcFrame.SelfOfMethod
        TEST    EAX,EAX
        JZ      @@freeException
        MOV     EBX,[EAX]
        CALL    DWORD PTR [EBX] + VMTOFFSET TObject.SafeCallException
        MOV     EBX,EAX
@@freeException:
        MOV     EAX,[ESP+4]
        MOV     EAX,[EAX].TExceptionRecord.ExceptObject
        CALL    TObject.Free
@@done:
        XOR     EAX,EAX
        MOV     ESP,[ESP+8]
        POP     ECX
        MOV     FS:[EAX],ECX
        POP     EDX
        POP     EBP
        LEA     EDX,[EDX].TExcDesc.instructions
        POP     ECX
        JMP     EDX
@@exit:
        MOV     EAX,1
end;

procedure JumpToMem(const AAddr, AJump: Pointer);
var
  JumpOpCode: TAbsJump;
begin
  JumpOpCode.MovOpCode := $B8; // MOV EAX, xyz
  JumpOpCode.Ref := Pointer(NativeUInt(AAddr) + Cardinal(SizeOf(JumpOpCode.MovOpCode) + SizeOf(JumpOpCode.Ref) + SizeOf(JumpOpCode.JMP)));
  JumpOpCode.JMP := $20FF; // FF20 - JMP [EAX]
  JumpOpCode.Addr := AJump;
  Move(JumpOpCode, AAddr^, SizeOf(JumpOpCode));
end;

function GetHandleAutoExceptionPointer: Pointer; assembler;
asm
  LEA EAX, System.@HandleAutoException
end;

procedure FixSafeCallExceptions;
var
  P: Pointer;
  OldProtectionCode: DWORD;
begin
  P := GetHandleAutoExceptionPointer;
  if VirtualProtect(P, JumpToMemSz, PAGE_EXECUTE_READWRITE, @OldProtectionCode) then
  try
    JumpToMem(P, @FixedHandleAutoException);
  finally
    VirtualProtect(P, JumpToMemSz, OldProtectionCode, @OldProtectionCode);
  end;
  FlushInstructionCache(GetCurrentProcess, P, JumpToMemSz);
end;


initialization
  SafeCallErrorProc := RaiseSafeCallException;
end.

