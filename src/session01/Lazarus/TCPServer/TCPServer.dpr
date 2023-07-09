program TCPServer;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
 Forms, Interfaces,
 UServer in 'UServer.pas' {FServer};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFServer, FServer);
  Application.Run;
end.
