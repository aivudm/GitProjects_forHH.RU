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
    procedure PrepareServerSetting(const AServerActive: boolean);
  end;

var
  DM: TDataModule1;



implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}
uses unConst, unVariables, unMain, unUtilCommon;

procedure TDataModule1.PrepareServerSetting(const AServerActive: boolean);
begin
 serverUDP.Active := false;
 if not AServerActive then exit;

 serverUDP.DefaultPort:= ServerUDPPort;
 try
  serverUDP.Active := true;
 except
  raise;
 end;
 if serverUDP.Active then
 begin
  formMain.sbMain.Panels[0].Text:= format('Режим: Сервер UDP [Порт: %5d]', [ServerUDPPort]);
 end;
end;


procedure TDataModule1.serverTCPExecute(AContext: TIdContext);
var
  sTmo: string;
begin
 with AContext.Connection do

  disconnect;
end;

procedure TDataModule1.serverUDPUDPRead(AThread: TIdUDPListenerThread;
  const AData: TIdBytes; ABinding: TIdSocketHandle);
var
  streamTmp: TStream;
  sTmp, sTmp1: string;
  iTmp: word;
begin
// sTmp:= StreamToString(TStream(AData));
 sTmp:= BytesToString(AData, IndyTextEncoding_UTF8);
 iTmp:= StrToInt(GetSubStr(sTmp, IndexInString(sDelimiterNumTask, sTmp, 1) + 1, IndexInString(sDelimiterNumTask, sTmp, IndexInString(sDelimiterNumTask, sTmp, 1) + 1) - 1));
 sTmp:= GetSubStr(sTmp, IndexInString(sDelimiterNumTask, sTmp, 2) + 2, - 1);
 if iTmp > formMain.memInfoTread.Lines.Count  then
  formMain.memInfoTread.Lines.Add(sTmp)
 else
  formMain.memInfoTread.Lines[iTmp]:= sTmp;
end;

end.
