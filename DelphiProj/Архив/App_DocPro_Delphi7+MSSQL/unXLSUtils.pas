unit unXLSUtils;

interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComObj, StdCtrls, Buttons, Grids, ComCtrls, DBGrids, ADODB, DB;

procedure UploadToXLS(inputQuery: TADOQuery);

implementation
var
    xlsFileName: string = 'e:\111.xls';

procedure UploadToXLS(inputQuery: TADOQuery);
var
XL : variant;
i,c: integer;
    IR1, IR2: Variant;
    Arr: OLEVariant;
begin
if inputQuery.Active=false then exit;
if inputQuery.RecordCount=0 then exit;

XL := CreateOleObject('Excel.Application');
XL.DisplayAlerts := false;
XL.WorkBooks.Add(xlsFileName);
try
XL.WorkBooks[1].WorkSheets[1].Name := 'Listik1';
except
end;

Arr := VarArrayCreate([1, inputQuery.RecordCount+1, 1, inputQuery.FieldCount], varVariant);

for i:=0 to inputQuery.FieldCount-1 do      
  Arr[1, i+1]:=inputQuery.Fields[i].DisplayName;

inputQuery.DisableControls;
try
inputQuery.First;
c:=2;
while not inputQuery.Eof do
begin
for i:=0 to  inputQuery.FieldCount-1 do
   begin
    if inputQuery.Fields[i].DataType=ftString then
    Arr[c,i+1]:=inputQuery.Fields[i].AsString
     else
    Arr[c,i+1]:=inputQuery.Fields[i].value;
   end;
c:=c+1;
inputQuery.Next;
end;
finally
inputQuery.EnableControls;
end;

IR1:=XL.WorkBooks[1].WorkSheets[1].Cells.Item[1,1];//[y,x]
IR2:=XL.WorkBooks[1].WorkSheets[1].Cells.Item[1+inputQuery.RecordCount,inputQuery.FieldCount];// [y,x]

XL.WorkBooks[1].WorkSheets[1].rows['1'].NumberFormat:= '@';
{*
for i:=1 to inputQuery.FieldCount do
begin
XL.WorkBooks[1].WorkSheets[1].cells[1,i].Borders[xlEdgeBottom].Weight := xlMedium;
XL.WorkBooks[1].WorkSheets[1].cells[1,i].Borders[xlEdgeTop].Weight := xlMedium;
XL.WorkBooks[1].WorkSheets[1].cells[1,i].Borders[xlEdgeLeft].Weight := xlMedium;
XL.WorkBooks[1].WorkSheets[1].cells[1,i].Borders[xlEdgeRight].Weight := xlMedium;

end;
*}

//XL.WorkBooks[1].WorkSheets[1].Rows[1].AutoFill[XL.WorkBooks[1].WorkSheets[1].Rows['1:'+IntToStr(1+inputQuery.RecordCount)],xlFillDefault];

XL.WorkBooks[1].WorkSheets[1].Range[IR1, IR2].Value := Arr;
for i:=1 to  inputQuery.FieldCount do
   XL.WorkBooks[1].WorkSheets[1].columns[i].EntireColumn.AutoFit;
  
XL.Visible := true;
XL:=NULL;

end;
end.
