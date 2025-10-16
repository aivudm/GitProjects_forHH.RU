unit unAdminUtil;

interface
uses Forms, Controls, Windows, ComCtrls, SysUtils, ADOdb, DB,
     DBCtrlsEh, Variants, DateUtils, Classes,
     StdCtrls, ExtCtrls, ToolWin, Messages, CheckLst,
     DBGrids, DBTables, Grids, ShellApi, Dialogs;


function SaveText_SP_IntoFile(inputQuery: TADOQuery): boolean;
function SaveText_F_IntoFile(inputQuery: TADOQuery): boolean;
function UploadSPToServer(): boolean; stdcall;
function UploadFnToServer(): boolean; stdcall;

implementation
uses unConstant, unVariable, unDM, unUtilCommon, unUtilFiles, unDBUtil, unMain;

function SaveText_SP_IntoFile(inputQuery: TADOQuery): boolean;
var
  i: integer;
  CurrentidSP: integer;
  tmpString: string;
begin
result:= false;
try
  Rewrite(SP_Text);
  with InputQuery do
  begin
   Close();
   Open();
   First;
   i:= RecordCount;
//   showmessage(inttostr(i));
   i:= 0;
   CurrentidSP:= Fields[0].AsInteger; //Заведомо несуществующий номер

//--- Это нужно только для визуального контроля на этапе отработки
//--- В работе алгоритма не учавствует!
   writeln(SP_Text, MarkerBeginStorageProcedureInFile_AsNote + '  ' + IntToStr(Fields[0].AsInteger));
//--------------------------------------------------------------------------------------------
   while not EOF do
   begin
    if CurrentidSP = Fields[0].AsInteger then
     write(SP_Text, Fields[2].AsString)
    else
     begin
      writeln(SP_Text);
      writeln(SP_Text, MarkerEndStorageProcedureInFile + IntToStr(CurrentidSP));
      inc(i);
      CurrentidSP:= Fields[0].AsInteger;
//--- Это нужно только для визуального контроля на этапе отработки
//--- В работе алгоритма не учавствует!
      writeln(SP_Text, MarkerBeginStorageProcedureInFile_AsNote + '  ' + IntToStr(Fields[0].AsInteger));
//--------------------------------------------------------------------------------------------
      writeln(SP_Text, Fields[2].AsString);
      CurrentidSP:= Fields[0].AsInteger;
     end;
    next;
   end;
  writeln(SP_Text);
  writeln(SP_Text, MarkerEndStorageProcedureInFile + IntToStr(CurrentidSP));
  Close();
  end;
 CloseFile(SP_Text);
 ShowMessage('Выгружено из сервера: ' + Inttostr(i) + ' SPs');
except
 result:= false;
 CloseFile(SP_Text);
 if dmDB.dbConnection.Errors.Count > 0 then
  for i:= 0 to dmDB.dbConnection.Errors.Count-1 do
   WriteDBErrorToLog('', dmDB.dbConnection.Errors[i].Description, dmDB.dbConnection.Errors[i].Source, '', 'RefreshOrdersTreeView', '');
end;
end;

function SaveText_F_IntoFile(inputQuery: TADOQuery): boolean;
var
  i: integer;
  CurrentidSP: integer;
  tmpString: string;
begin
result:= false;
try
  Rewrite(F_Text);
  with InputQuery do
  begin
   Close();
   Open();
   First;
   i:= RecordCount;
//   showmessage(inttostr(i));
   i:= 0;
   CurrentidSP:= Fields[0].AsInteger; //Заведомо несуществующий номер

//--- Это нужно только для визуального контроля на этапе отработки
//--- В работе алгоритма не учавствует!
   writeln(F_Text, MarkerBeginFunctionInFile_AsNote + '  ' + IntToStr(Fields[0].AsInteger));
//--------------------------------------------------------------------------------------------
   while not EOF do
   begin
    if CurrentidSP = Fields[0].AsInteger then
     write(F_Text, Fields[2].AsString)
    else
     begin
      writeln(F_Text);
      writeln(F_Text, MarkerEndFunctionInFile + IntToStr(CurrentidSP));
      inc(i);
      CurrentidSP:= Fields[0].AsInteger;
//--- Это нужно только для визуального контроля на этапе отработки
//--- В работе алгоритма не учавствует!
//      writeln(F_Text, MarkerBeginFunctionInFile_AsNote + '  ' + IntToStr(Fields[0].AsInteger));
//--------------------------------------------------------------------------------------------
      writeln(F_Text, Fields[2].AsString);
      CurrentidSP:= Fields[0].AsInteger;
     end;
    next;
   end;
  writeln(F_Text);
  writeln(F_Text, MarkerEndFunctionInFile + IntToStr(CurrentidSP));
  Close();
  end;
 CloseFile(F_Text);
 ShowMessage('Выгружено из сервера: ' + Inttostr(i) + ' FNs');
except
 result:= false;
 CloseFile(F_Text);
 if dmDB.dbConnection.Errors.Count > 0 then
  for i:= 0 to dmDB.dbConnection.Errors.Count-1 do
   WriteDBErrorToLog('', dmDB.dbConnection.Errors[i].Description, dmDB.dbConnection.Errors[i].Source, '', 'RefreshOrdersTreeView', '');
end;
end;

function UploadSPToServer(): boolean;
var
// tmpString: AnsiString;
// pSPText: PChar;
 i, iAmount, iBufferSize, iCurrentSPSize: longint;
 pBuffer, pSPText: Pointer;
 iBeginPosInBuffer, iEndPosInBuffer: longint;
 tmpStr: string;
 SQLServerError: TSQLServerError;
begin
try
 iBufferSize:= MyGetFileSize(CurrentFileName_SP_Text);
 GetMem(pBuffer, MyGetFileSize(CurrentFileName_SP_Text));
 GetMem(pSPText, MyGetFileSize(CurrentFileName_SP_Text));

 if not OpenFileToMemory(CurrentFileName_SP_Text, pBuffer, MyGetFileSize(CurrentFileName_SP_Text)) then
 begin
  Result:= false;
  WriteDataToLog('OpenFileToMemory() отработал с ошибками - файл ' + CurrentFileName_SP_Text, 'UploadSPToServer()', 'unUtilCommon');
  exit;
 end;
 try
  i:= 0;
  iEndPosInBuffer:= 1;
  iAmount:= GetAmountMarker(pBuffer, iBufferSize, 0, PChar(MarkerBeginStorageProcedureInFile), Length(MarkerBeginStorageProcedureInFile));
 repeat
  iEndPosInBuffer:= iEndPosInBuffer - 1;
  iBeginPosInBuffer:= GetPosForMarker(pBuffer, iBufferSize, iEndPosInBuffer, PChar(MarkerBeginStorageProcedureInFile), Length(MarkerBeginStorageProcedureInFile));
  iEndPosInBuffer:= GetPosForMarker(pBuffer, iBufferSize, iBeginPosInBuffer, PChar(MarkerEndStorageProcedureInFile), Length(MarkerEndStorageProcedureInFile));

  if (iEndPosInBuffer <> -1) and (iBeginPosInBuffer <> -1) then
  begin
   iCurrentSPSize:= iEndPosInBuffer - iBeginPosInBuffer;

   FillBuffer(pSPText, iBufferSize, 0);
   CopyMemory(pSPText, GetPointerWithOffset(pBuffer, iBeginPosInBuffer), iCurrentSPSize);
//  ShowMessage(pSPText);
   tmpStr:= GetSP_FnNameFromText(pSPText, iCurrentSPSize, 0, PChar(MarkerBeginStorageProcedureInFile), length(MarkerBeginStorageProcedureInFile));

{
   if tmpStr = 'sp_GetSpravObjectItemsById_Manufacturing' then
   begin
    ShowMessage('Работаем с ' + tmpStr);
   end;
}
   if IsSP_FnExists(GetSP_FnNameFromText(pSPText, iCurrentSPSize, 0, PChar(MarkerBeginStorageProcedureInFile), length(MarkerBeginStorageProcedureInFile))) then
   begin
    ReplacePartOfBuffer(pSPText, iCurrentSPSize, 0, 'CREATE ', 'ALTER  ');
    WriteDataToLog('Alter ' + tmpStr, 'UploadSPToServer()', 'unUtilCommon');
   end
   else
    WriteDataToLog('Create ' + tmpStr, 'UploadSPToServer()', 'unUtilCommon');

//---- Для тестирования --------------------------------------------------------
//   SaveFileFromMemory(CurrentFileName_SP_Text + '1', pSPText, iCurrentSPSize);
//------------------------------------------------------------------------------

   SQLServerError:= PutSP_FnToServer(PChar(pSPText));
   if SQLServerError <> 0 then
    WriteDataToLog('Ошибка при обновлении/создании SP: ' + IntToStr(SQLServerError), 'UploadSPToServer()', 'unUtilCommon');
   i:= i + 1;

   formMain.StatusBar1.Panels[1].Text:= 'выгружено/всего: SP - ' + IntToStr(i) + '/' + IntToStr(iAmount);
   Application.ProcessMessages;
  end;

 until (iEndPosInBuffer = -1) or (iBeginPosInBuffer = -1);
 finally
  FreeMem(pBuffer, SizeOf(pBuffer));
  FreeMem(pSPText, SizeOf(pBuffer));
  result:= true;
end;
except
 Result:= false;
 if Assigned(pBuffer) then FreeMem(pBuffer, SizeOf(pBuffer));
 if Assigned(pSPText) then FreeMem(pSPText, SizeOf(pBuffer));
end;

end;

function UploadFnToServer(): boolean;
var
 tmpStr: AnsiString;
// pSPText: PChar;
 i, iAmount, iBufferSize, iCurrentSPSize: longint;
 pBuffer, pSPText: Pointer;
 iBeginPosInBuffer, iEndPosInBuffer: longint;
 SQLServerError: TSQLServerError;
 StatusBarText: string;
begin
try
 iBufferSize:= MyGetFileSize(CurrentFileName_F_Text);
 GetMem(pBuffer, MyGetFileSize(CurrentFileName_F_Text));
 GetMem(pSPText, MyGetFileSize(CurrentFileName_SP_Text));

 if not OpenFileToMemory(CurrentFileName_F_Text, pBuffer, MyGetFileSize(CurrentFileName_F_Text)) then
 begin
  Result:= false;
  WriteDataToLog('OpenFileToMemory() отработал с ошибками - файл ' + CurrentFileName_SP_Text, 'UploadFnToServer()', 'unUtilCommon');
  exit;
 end;
 try
  i:= 0;
  StatusBarText:= formMain.StatusBar1.Panels[1].Text;
  iEndPosInBuffer:= 1;
  iAmount:= GetAmountMarker(pBuffer, iBufferSize, 0, PChar(MarkerBeginFunctionInFile), Length(MarkerBeginFunctionInFile));
 repeat
  iEndPosInBuffer:= iEndPosInBuffer - 1;
  iBeginPosInBuffer:= GetPosForMarker(pBuffer, iBufferSize, iEndPosInBuffer, PChar(MarkerBeginFunctionInFile), Length(MarkerBeginFunctionInFile));
  iEndPosInBuffer:= GetPosForMarker(pBuffer, iBufferSize, iBeginPosInBuffer, PChar(MarkerEndFunctionInFile), Length(MarkerEndFunctionInFile));

  if (iEndPosInBuffer <> -1) and (iBeginPosInBuffer <> -1) then
  begin
   iCurrentSPSize:= iEndPosInBuffer - iBeginPosInBuffer;

   FillBuffer(pSPText, iBufferSize, 0);
   CopyMemory(pSPText, GetPointerWithOffset(pBuffer, iBeginPosInBuffer), iCurrentSPSize);
//  ShowMessage(pSPText);

   tmpStr:= GetSP_FnNameFromText(pSPText, iCurrentSPSize, 0, PChar(MarkerBeginStorageProcedureInFile), length(MarkerBeginStorageProcedureInFile));

   if IsSP_FnExists(GetSP_FnNameFromText(pSPText, iCurrentSPSize, 0, PChar(MarkerBeginFunctionInFile), length(MarkerBeginFunctionInFile))) then
   begin
    ReplacePartOfBuffer(pSPText, iCurrentSPSize, 0, 'CREATE ', 'ALTER  ');
    WriteDataToLog('Alter ' + tmpStr, 'UploadFnToServer()', 'unUtilCommon');
   end
   else
    WriteDataToLog('Create ' + tmpStr, 'UploadFnToServer()', 'unUtilCommon');

   SQLServerError:= PutSP_FnToServer(PChar(pSPText));
   if SQLServerError <> 0 then
    WriteDataToLog('Ошибка при обновлении/создании Fn: ' + IntToStr(SQLServerError), 'UploadFnToServer()', 'unUtilCommon');
   i:= i + 1;

   formMain.StatusBar1.Panels[1].Text:= StatusBarText + ';  Fn - ' + IntToStr(i) + '/' + IntToStr(iAmount);
   Application.ProcessMessages;
  end;

 until (iEndPosInBuffer = -1) or (iBeginPosInBuffer = -1);
 finally
  FreeMem(pBuffer, SizeOf(pBuffer));
  FreeMem(pSPText, SizeOf(pBuffer));
  result:= true;
end;
except
 Result:= false;
 if Assigned(pBuffer) then FreeMem(pBuffer, SizeOf(pBuffer));
 if Assigned(pSPText) then FreeMem(pSPText, SizeOf(pBuffer));
end;

end;

procedure GetCatalogDBMSSQL(inputAppHandle: hWnd);
var
  tmpStr: string;
begin
   // Получить имя источника данных (DataSource Name) с помощью стандартной
   // диалоговой панели Microsoft
   tmpStr:= PromptDataSource(inputAppHandle, '');
   // Если пользователь выбрал источник данных
   If tmpStr <> '' Then
      begin
   // просмотреть метаданные
//       BrowseData(tmpStr);
      end;
end;

end.
 