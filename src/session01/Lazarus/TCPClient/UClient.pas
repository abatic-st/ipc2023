unit UClient;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  IdBaseComponent,
  IdComponent,
  IdTCPConnection,
  IdTCPClient,
  IdThreadComponent,
  IdGlobal;

type
  TFClient = class(TForm)
    lbHeader: TLabel;
    lbMsgSend: TLabel;
    messageToSend: TMemo;
    memoLog: TMemo;
    btnConnection: TButton;
    btnDisconnect: TButton;
    btnSender: TButton;
    IdTCPClient: TIdTCPClient;
    IdThreadComponent: TIdThreadComponent;
    procedure FormShow(Sender: TObject);
    procedure btnConnectionClick(Sender: TObject);
    procedure btnDisconnectClick(Sender: TObject);
    procedure btnSenderClick(Sender: TObject);
    procedure IdTCPClientConnected(Sender: TObject);
    procedure IdTCPClientDisconnected(Sender: TObject);
    procedure IdThreadComponentRun(Sender: TIdThreadComponent);
    procedure Display(p_sender: String; p_message: string);
    function GetNow(): String;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FClient: TFClient;
implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

procedure TFClient.FormShow(Sender: TObject);
begin
  messageToSend.Clear;
  messageToSend.Enabled := False;
  memoLog.Clear;
  btnConnection.Enabled := True;
  btnDisconnect.Enabled := False;
  btnSender.Enabled := False;
end;

procedure TFClient.btnConnectionClick(Sender: TObject);
begin
  btnConnection.Enabled := False;
  try
    IdTCPClient.Connect;
  except
    on E: Exception do
    begin
      Display('CLIENT', 'CONNECTION ERROR! ' + E.Message);
      btnConnection.Enabled := True;
    end;
  end;
end;

procedure TFClient.btnDisconnectClick(Sender: TObject);
begin
  if IdTCPClient.Connected then
  begin
    IdTCPClient.Disconnect;
    btnConnection.Enabled := True;
    btnDisconnect.Enabled := False;
    btnSender.Enabled := False;
    messageToSend.Enabled := False;
  end;
end;
procedure TFClient.IdTCPClientConnected(Sender: TObject);
begin
  Display('CLIENT', 'CONNECTED!');
  IdThreadComponent.Active := True;
  btnConnection.Enabled := False;
  btnDisconnect.Enabled := True;
  btnSender.Enabled := True;
  messageToSend.Enabled := True;
end;

procedure TFClient.IdTCPClientDisconnected(Sender: TObject);
begin
  Display('CLIENT', 'DISCONNECTED!');
end;

procedure TFClient.btnSenderClick(Sender: TObject);
var
  s: String;
  encoding: IIdTextEncoding;
begin
  encoding := IndyTextEncoding_UTF8;
  s := messageToSend.Text;
  IdTCPClient.IOHandler.WriteLn(s, encoding);
end;

procedure TFClient.IdThreadComponentRun(Sender: TIdThreadComponent);
var
  msgFromServer: string;
begin
  msgFromServer := IdTCPClient.IOHandler.ReadLn();
  if msgFromServer = 'Bye Client' then
  begin
    IdTCPClient.Disconnect;
    btnConnection.Enabled := True;
    btnDisconnect.Enabled := False;
    btnSender.Enabled := False;
    messageToSend.Enabled := False;
  end;

  Display('SERVER', msgFromServer);
end;

procedure TFClient.Display(p_sender: String; p_message: string);
begin
  memoLog.Lines.Add('[' + p_sender + '] - ' + GetNow() + ': ' +  p_message);

end;

function TFClient.GetNow(): String;
begin
  Result := FormatDateTime('yyyy-mm-dd hh:nn:ss', Now) + ': ';
end;

procedure TFClient.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if IdThreadComponent.Active then
  begin
    IdThreadComponent.Active := False;
  end;
end;

end.
