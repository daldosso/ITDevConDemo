unit ITDevConDemoController;

interface

uses
  MVCFramework,
  MVCFramework.Commons,
  System.JSON;

type
  [MVCPath('/api')]
  TITDevConDemoController = class(TMVCController)
  public

    [MVCPath('/hello')]
    [MVCHTTPMethod([httpGET])]
    procedure Hello;

    [MVCPath('/user')]
    [MVCHTTPMethod([httpGET])]
    procedure GetUser;

    [MVCPath('/user')]
    [MVCHTTPMethod([httpPOST])]
    procedure CreateUser;
  end;

implementation

{ TITDevConDemoController }

procedure TITDevConDemoController.Hello;
begin
  Render('Hello ITDevCon!');
end;

procedure TITDevConDemoController.GetUser;
var
  JSON: TJSONObject;
begin
  JSON := TJSONObject.Create;
  JSON.AddPair('name', 'Alberto');
  JSON.AddPair('event', 'ITDevCon');

  Render(JSON);
end;

procedure TITDevConDemoController.CreateUser;
var
  Body: TJSONObject;
begin
  Body := TJSONObject.ParseJSONValue(Context.Request.Body) as TJSONObject;

  Render(
    TJSONObject.Create
      .AddPair('status', 'created')
      .AddPair('name', Body.GetValue<string>('name'))
  );
end;

end.
