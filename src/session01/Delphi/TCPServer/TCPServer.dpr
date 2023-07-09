program TCPServer;

uses
  Vcl.Forms,
  UServer in 'UServer.pas' {FServer};

{$R *.res}

begin
  Application.Initialize;
  ReportMemoryLeaksOnShutdown:= true;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFServer, FServer);
  Application.Run;
end.
