unit ITDevConController;

interface

uses
  MVCFramework,
  MVCFramework.Commons,
  System.SysUtils,
  System.JSON;

type
  [MVCPath('/api')]
  TITDevConController = class(TMVCController)
  public
    [MVCPath('/hello')]
    [MVCHTTPMethod([httpGET])]
    procedure Hello;

    [MVCPath('/hello/($name)')]
    [MVCHTTPMethod([httpGET])]
    procedure HelloName(name: string);

    [MVCPath('/users')]
    [MVCHTTPMethod([httpGET])]
    procedure GetUsers;

    [MVCPath('/users/($id)')]
    [MVCHTTPMethod([httpGET])]
    procedure GetUser(id: Integer);

    [MVCPath('/users')]
    [MVCHTTPMethod([httpPOST])]
    procedure CreateUser;

    [MVCPath('/users/($id)')]
    [MVCHTTPMethod([httpPUT])]
    procedure UpdateUser(id: Integer);

    [MVCPath('/users/($id)')]
    [MVCHTTPMethod([httpDELETE])]
    procedure DeleteUser(id: Integer);

    [MVCPath('/time')]
    [MVCHTTPMethod([httpGET])]
    procedure GetTime;
  end;

implementation

procedure TITDevConController.Hello;
begin
  Render(TJSONObject.Create.AddPair('message', 'Hello ITDevCon!'));
end;

procedure TITDevConController.HelloName(name: string);
begin
  Render(TJSONObject.Create.AddPair('message', 'Hello ' + name));
end;

procedure TITDevConController.GetUsers;
var
  Arr: TJSONArray;
begin
  Arr := TJSONArray.Create;
  Arr.Add(TJSONObject.Create.AddPair('id', '1').AddPair('name', 'Alberto'));
  Arr.Add(TJSONObject.Create.AddPair('id', '2').AddPair('name', 'Valentina'));
  Arr.Add(TJSONObject.Create.AddPair('id', '3').AddPair('name', 'Marco'));
  Arr.Add(TJSONObject.Create.AddPair('id', '4').AddPair('name', 'Giulia'));
  Arr.Add(TJSONObject.Create.AddPair('id', '5').AddPair('name', 'Luca'));
  Arr.Add(TJSONObject.Create.AddPair('id', '6').AddPair('name', 'Francesca'));
  Arr.Add(TJSONObject.Create.AddPair('id', '7').AddPair('name', 'Davide'));
  Arr.Add(TJSONObject.Create.AddPair('id', '8').AddPair('name', 'Sara'));
  Arr.Add(TJSONObject.Create.AddPair('id', '9').AddPair('name', 'Andrea'));
  Arr.Add(TJSONObject.Create.AddPair('id', '10').AddPair('name', 'Chiara'));
  Render(Arr);
end;

procedure TITDevConController.GetUser(id: Integer);
begin
  Render(
    TJSONObject.Create
      .AddPair('id', id.ToString)
      .AddPair('name', 'User ' + id.ToString)
  );
end;

procedure TITDevConController.CreateUser;
var
  Body: TJSONObject;
begin
  Body := TJSONObject.ParseJSONValue(Context.Request.Body) as TJSONObject;
  try
    Render(
      201,
      TJSONObject.Create
        .AddPair('status', 'created')
        .AddPair('name', Body.GetValue<string>('name'))
    );
  finally
    Body.Free;
  end;
end;

procedure TITDevConController.UpdateUser(id: Integer);
begin
  Render(
    TJSONObject.Create
      .AddPair('status', 'updated')
      .AddPair('id', id.ToString)
  );
end;

procedure TITDevConController.DeleteUser(id: Integer);
begin
  Render(
    TJSONObject.Create
      .AddPair('status', 'deleted')
      .AddPair('id', id.ToString)
  );
end;

procedure TITDevConController.GetTime;
begin
  Render(TJSONObject.Create.AddPair('now', DateTimeToStr(Now)));
end;

end.
