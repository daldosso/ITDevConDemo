program ITDevConDemo;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  MVCFramework.Server,
  MVCFramework.Server.Impl,
  WebModuleUnit in 'WebModuleUnit.pas',
  ITDevConController in 'ITDevConController.pas';

var
  LServerListener: IMVCListener;
begin
  ReportMemoryLeaksOnShutdown := True;
  try
    LServerListener := TMVCListener.Create(
      TMVCListenerProperties.New
        .SetName('Listener1')
        .SetPort(8080)
        .SetMaxConnections(1024)
        .SetWebModuleClass(TWebModule1)
    );
    LServerListener.Start;
    Writeln('Server running on http://localhost:8080');
    Writeln('Press Enter to stop...');
    Readln;
    LServerListener.Stop;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
