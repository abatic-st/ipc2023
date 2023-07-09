program TCPClient;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
  Forms, Interfaces,
  UClient in 'UClient.pas' {FClient};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFClient, FClient);
  Application.Run;
end.
