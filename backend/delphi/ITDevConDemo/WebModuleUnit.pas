unit WebModuleUnit;

interface

uses
  System.SysUtils, System.Classes,
  Web.HTTPApp,
  MVCFramework,
  MVCFramework.Commons;

type
  TWebModule1 = class(TWebModule)
    procedure WebModuleCreate(Sender: TObject);
    procedure WebModuleDestroy(Sender: TObject);
  private
    FMVC: TMVCEngine;
  end;

var
  WebModuleClass: TComponentClass = TWebModule1;

implementation

{$R *.dfm}

uses
  ITDevConController;

procedure TWebModule1.WebModuleCreate(Sender: TObject);
begin
  FMVC := TMVCEngine.Create(Self,
    procedure(Config: TMVCConfig)
    begin
      Config['document_root'] := 'www';
    end);
  FMVC.AddController(TITDevConController);
end;

procedure TWebModule1.WebModuleDestroy(Sender: TObject);
begin
  FMVC.Free;
end;

end.