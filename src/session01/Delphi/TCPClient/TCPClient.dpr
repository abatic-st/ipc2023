program TCPClient;

uses
  Vcl.Forms,
  UClient in 'UClient.pas' {FClient};

{$R *.res}

begin
  Application.Initialize;
  ReportMemoryLeaksOnShutdown:= true;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFClient, FClient);
  Application.Run;
end.
