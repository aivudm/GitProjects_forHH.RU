unit unDM;

interface

uses
  System.SysUtils, System.Classes, IdCustomTCPServer, IdCustomHTTPServer,
  IdHTTPServer, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdHTTP, IdTCPServer, IdContext, IdUDPBase, IdUDPServer, IdGlobal,
  IdSocketHandle, IdUDPClient;

type
  TDataModule1 = class(TDataModule)
    serverUDP: TIdUDPServer;
    ClientUDP: TIdUDPClient;
    procedure serverTCPExecute(AContext: TIdContext);
    procedure serverUDPUDPRead(AThread: TIdUDPListenerThread;
      const AData: TIdBytes; ABinding: TIdSocketHandle);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure PrepareServerSetting(const inputServerActive: boolean);
  end;

var
  DM: TDataModule1;



implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}
uses unConst, unVariables, unMain, unUtilCommon;

procedure TDataModule1.PrepareServerSetting(const inputServerActive: boolean);
begin
 serverUDP.Active := false;
 if not inputServerActive then exit;

 serverUDP.DefaultPort:= ServerUDPPort;
 try
  serverUDP.Active := true;
 except
  raise;
 end;
 if serverUDP.Active then
 begin
  formMain.sbMain.Panels[0].Text:= format(wsNameExchangeType_ServerUDP, [ServerUDPPort]);
 end;
end;


procedure TDataModule1.serverTCPExecute(AContext: TIdContext);
var
  sTmo: WideString;
begin
 with AContext.Connection do

  disconnect;
end;

procedure TDataModule1.serverUDPUDPRead(AThread: TIdUDPListenerThread;
  const AData: TIdBytes; ABinding: TIdSocketHandle);
var
  streamTmp: TStream;
  tmpString, sTmp1: WideString;
  tmpWord: word;
begin
// sTmp:= StreamToString(TStream(AData));
 tmpString:= BytesToString(AData, IndyTextEncoding_UTF8);
 tmpWord:= StrToInt(GetSubStr(tmpString, IndexInString(sDelimiterNumTask, tmpString, 1) + 1, IndexInString(sDelimiterNumTask, tmpString, IndexInString(sDelimiterNumTask, tmpString, 1) + 1) - 1));
 tmpString:= GetSubStr(tmpString, IndexInString(sDelimiterNumTask, tmpString, 2) + 2, - 1);
 if tmpWord > formMain.memInfoThread.Lines.Count  then
  formMain.memInfoThread.Lines.Add(tmpString)
 else
  formMain.memInfoThread.Lines[tmpWord]:= tmpString;
end;

end.
