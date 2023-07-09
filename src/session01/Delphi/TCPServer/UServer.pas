unit UServer;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  IdContext,
  IdComponent,
  Vcl.StdCtrls,
  IdBaseComponent,
  IdCustomTCPServer,
  IdThreadSafe,
  IdTCPConnection,
  // IdYarn,
  IdTCPServer,
  Vcl.ExtCtrls,
  idGlobal;

type
  TFServer = class(TForm)
    lbTitle: TLabel;
    btnStartServer: TButton;
    btn_stop: TButton;
    btn_clear: TButton;
    clients_connected: TLabel;
    lbClientsConnected: TLabel;
    Panel1: TPanel;
    messagesLog: TMemo;
    IdTCPServer: TIdTCPServer;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnStartServerClick(Sender: TObject);
    procedure btn_stopClick(Sender: TObject);
    procedure btn_clearClick(Sender: TObject);
    procedure IdTCPServerConnect(AContext: TIdContext);
    procedure IdTCPServerDisconnect(AContext: TIdContext);
    procedure IdTCPServerExecute(AContext: TIdContext);
    procedure IdTCPServerStatus(ASender: TObject; const AStatus: TIdStatus;
      const AStatusText: string);
    procedure ShowNumberOfClients(p_disconnected: Boolean = False);
    procedure BroadcastMessage(p_message: string);
    procedure Display(p_sender, p_message: string);
    function GetNow(): String;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const
  GUEST_CLIENT_PORT = 20010;

var
  FServer: TFServer;



implementation

{$R *.dfm}

procedure TFServer.FormCreate(Sender: TObject);
begin
  IdTCPServer.Active := False;
  IdTCPServer.MaxConnections := 20;
  IdTCPServer.OnConnect := IdTCPServerConnect;
  IdTCPServer.OnDisconnect := IdTCPServerDisconnect;
  IdTCPServer.OnExecute := IdTCPServerExecute;
  IdTCPServer.OnStatus := IdTCPServerStatus;

end;

procedure TFServer.FormShow(Sender: TObject);
begin
  messagesLog.Lines.Clear;
  clients_connected.Caption := inttostr(0);
  btnStartServer.enabled := True;
  btn_stop.enabled := False;
end;

procedure TFServer.btnStartServerClick(Sender: TObject);
begin
  IdTCPServer.Bindings.Clear;
  IdTCPServer.Bindings.Add.Port := GUEST_CLIENT_PORT;
  IdTCPServer.Active := True;
  btnStartServer.enabled := False;
  btn_stop.enabled := True;
  Display('SERVER', 'STARTED!');
end;

procedure TFServer.btn_stopClick(Sender: TObject);
begin
  BroadcastMessage('Goodbye Client ');
  IdTCPServer.Active := False;
  btn_stop.enabled := False;
  btnStartServer.enabled := True;
  Display('SERVER', 'STOPPED!');
end;

procedure TFServer.btn_clearClick(Sender: TObject);
begin
  messagesLog.Lines.Clear;
end;

procedure TFServer.IdTCPServerConnect(AContext: TIdContext);
var
  ip: string;
  Port: Integer;
  peerIP: string;
  peerPort: Integer;
  //nClients: Integer;
  msgToClient: string;
  typeClient: string;
begin
  ip := AContext.Binding.ip;
  Port := AContext.Binding.Port;
  peerIP := AContext.Binding.peerIP;
  peerPort := AContext.Binding.peerPort;
  Display('SERVER', 'Client Connected!');
  Display('SERVER', 'Port=' + inttostr(Port) + ' ' + '(PeerIP=' + peerIP + ' - '
    + 'PeerPort=' + inttostr(peerPort) + ')');
  ShowNumberOfClients();
  case Port of
    GUEST_CLIENT_PORT:
      begin
        typeClient := 'GUEST';
      end;
  end;
  msgToClient := 'Welcome ' + typeClient + ' ' + 'Client :)';
  AContext.Connection.IOHandler.WriteLn(msgToClient);
end;

procedure TFServer.IdTCPServerDisconnect(AContext: TIdContext);
var
  ip: string;
  //Port: Integer;
  peerIP: string;
  peerPort: Integer;
  //nClients: Integer;
begin
  ip := AContext.Binding.ip;
  //Port := AContext.Binding.Port;
  peerIP := AContext.Binding.peerIP;
  peerPort := AContext.Binding.peerPort;
  Display('SERVER', 'Client Disconnected! Peer=' + peerIP + ':' +
    inttostr(peerPort));
  ShowNumberOfClients(True);
end;

procedure TFServer.IdTCPServerExecute(AContext: TIdContext);
var
  //Port: Integer;
  peerPort: Integer;
  peerIP: string;
  msgFromClient: string;
  //msgToClient: string;
  encoding: IIdTextEncoding;
begin
  encoding := IndyTextEncoding_UTF8;
  msgFromClient := AContext.Connection.IOHandler.ReadLn(encoding);
  peerIP := AContext.Binding.peerIP;
  peerPort := AContext.Binding.peerPort;
  Display('CLIENT', '(Peer=' + peerIP + ':' + inttostr(peerPort) + ') ' +
    msgFromClient);
  AContext.Connection.IOHandler.WriteLn('... message sent from server :)');
end;

procedure TFServer.IdTCPServerStatus(ASender: TObject; const AStatus: TIdStatus;
  const AStatusText: string);
begin
  Display('SERVER', AStatusText);
end;

function TFServer.GetNow(): String;
begin
  Result := FormatDateTime('yyyy-mm-dd hh:nn:ss', Now) + ': ';
end;

procedure TFServer.BroadcastMessage(p_message: string);
var
  tmpList: TList;
  contexClient: TIdContext;
  //nClients: Integer;
  //i: Integer;
begin
  tmpList := IdTCPServer.Contexts.LockList;
  try
    var i := 0;
    while (i < tmpList.Count) do
    begin
      contexClient := tmpList[i];
      contexClient.Connection.IOHandler.WriteLn(p_message);
      inc(i);
    end;
  finally
    IdTCPServer.Contexts.UnlockList;
  end;
end;

procedure TFServer.Display(p_sender: String; p_message: string);
begin
  TThread.Queue(nil,
    procedure
    begin
      messagesLog.Lines.Add('[' + p_sender + '] - ' + GetNow() + ': ' +
        p_message);
    end);
end;

procedure TFServer.ShowNumberOfClients(p_disconnected: Boolean = False);
var
  nClients: Integer;
begin
  try
    nClients := IdTCPServer.Contexts.LockList.Count;
  finally
    IdTCPServer.Contexts.UnlockList;
  end;
  if p_disconnected then
    dec(nClients);
  TThread.Queue(nil,
    procedure
    begin
      clients_connected.Caption := inttostr(nClients);
    end);
end;

end.
