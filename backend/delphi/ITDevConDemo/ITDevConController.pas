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

    [MVCPath('/auth/token')]
    [MVCHTTPMethod([httpPOST])]
    procedure GetToken;

    [MVCPath('/users-auth/($id)')]
    [MVCHTTPMethod([httpGET])]
    procedure GetUserAuthenticated(id: Integer);

    // --- Strava-like API ---

    // Supports: ?type=run|ride & min_distance=1000 & page=1
    [MVCPath('/activities')]
    [MVCHTTPMethod([httpGET])]
    procedure GetActivities;

    [MVCPath('/activities/($id)')]
    [MVCHTTPMethod([httpGET])]
    procedure GetActivity(id: Integer);

    // Supports: ?period=last_month|year & unit=km|miles
    [MVCPath('/stats')]
    [MVCHTTPMethod([httpGET])]
    procedure GetAthleteStats;

    // To show Postman's Header management
    [MVCPath('/activities/export')]
    [MVCHTTPMethod([httpGET])]
    procedure ExportActivities;

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

procedure TITDevConController.GetToken;
var
  Token: string;
begin
  Token := TGUID.NewGuid.ToString.Replace('{', '').Replace('}', '').Replace('-', '');

  Render(
    TJSONObject.Create
      .AddPair('access_token', Token)
      .AddPair('token_type', 'Bearer')
      .AddPair('expires_in', '3600')
  );
end;

procedure TITDevConController.GetUserAuthenticated(id: Integer);
var
  AuthHeader: string;
begin
  AuthHeader := Context.Request.Headers['Authorization'];

  if not AuthHeader.StartsWith('Bearer ') then
  begin
    Render(401, 'Missing token');
    Exit;
  end;

  (*
  if AuthHeader <> 'Bearer mock-token-123456' then
  begin
    Render(401, 'Invalid token');
    Exit;
  end;
  *)
  Render(
    TJSONObject.Create
      .AddPair('id', id.ToString)
      .AddPair('name', 'User ' + id.ToString)
      .AddPair('auth', 'ok')
  );
end;

procedure TITDevConController.GetActivities;
var
  LType, LMinDist: string;
  LPage: Integer;
  LArr: TJSONArray;
  LObj: TJSONObject;
begin
  // Postman Demo: Show how to read Query Parameters
  LType := Context.Request.QueryStringParam('type');
  LMinDist := Context.Request.QueryStringParam('min_dist');

  // Handling empty page param to avoid conversion errors
  if not TryStrToInt(Context.Request.QueryStringParam('page'), LPage) then
    LPage := 1;

  LArr := TJSONArray.Create;

  // Mocking filtered results
  if (LType = '') or (LType.ToLower = 'run') then
  begin
    LObj := TJSONObject.Create;
    LObj.AddPair('id', '201');
    LObj.AddPair('type', 'Run');
    LObj.AddPair('distance', TJSONNumber.Create(8500));
    // Use TJSONTrue.Create or TJSONFalse.Create
    LObj.AddPair('is_commute', TJSONFalse.Create);
    LArr.Add(LObj);
  end;

  if (LType = '') or (LType.ToLower = 'ride') then
  begin
    LObj := TJSONObject.Create;
    LObj.AddPair('id', '202');
    LObj.AddPair('type', 'Ride');
    LObj.AddPair('distance', TJSONNumber.Create(25000));
    LObj.AddPair('is_commute', TJSONTrue.Create);
    LArr.Add(LObj);
  end;

  // Final Response Object
  Render(TJSONObject.Create
    .AddPair('page', TJSONNumber.Create(LPage))
    .AddPair('items_per_page', TJSONNumber.Create(10))
    .AddPair('filters_applied', LType)
    .AddPair('data', LArr)
  );
end;

procedure TITDevConController.GetActivity(id: Integer);
var
  LActivity: TJSONObject;
  LLatlng: TJSONArray;
begin
  // Postman Demo: Show a detailed object with nested structures
  LActivity := TJSONObject.Create;

  // Basic properties
  LActivity.AddPair('id', TJSONNumber.Create(id));
  LActivity.AddPair('external_id', 'ext_' + id.ToString);
  LActivity.AddPair('name', 'Morning Run in Borgomanero');
  LActivity.AddPair('moving_time', TJSONNumber.Create(3600)); // seconds
  LActivity.AddPair('elapsed_time', TJSONNumber.Create(3820));
  LActivity.AddPair('total_elevation_gain', TJSONNumber.Create(150.5));

  // Nested Object: Map data
  // Useful for Postman: pm.expect(jsonData.map.resource_state).to.eql(3);
  LActivity.AddPair('map', TJSONObject.Create
    .AddPair('id', 'm' + id.ToString)
    .AddPair('polyline', 'a~lEig_xP...')
    .AddPair('resource_state', TJSONNumber.Create(3))
  );

  // Nested Array: Start and End coordinates
  // Useful for Postman: pm.expect(jsonData.start_latlng).to.be.an('array');
  LLatlng := TJSONArray.Create;
  LLatlng.Add(45.6987); // Latitude
  LLatlng.Add(8.4632);  // Longitude
  LActivity.AddPair('start_latlng', LLatlng);

  // Status flags
  LActivity.AddPair('trainer', TJSONFalse.Create);
  LActivity.AddPair('commute', TJSONFalse.Create);
  LActivity.AddPair('manual', TJSONFalse.Create);
  LActivity.AddPair('private', TJSONTrue.Create);

  Render(LActivity);
end;

procedure TITDevConController.GetAthleteStats;
var
  LUnit: string;
  LDistance: Double;
begin
  // Postman Demo: Dynamic units based on Query Params
  LUnit := Context.Request.QueryStringParam('unit'); // ?unit=miles
  LDistance := 1250.5;

  if LUnit.ToLower = 'miles' then
    LDistance := LDistance * 0.621371;

  Render(TJSONObject.Create
    .AddPair('athlete', 'Delphi Developer')
    .AddPair('total_distance', TJSONNumber.Create(LDistance))
    .AddPair('unit', LUnit)
    .AddPair('note', 'Change unit param to miles or km to see the conversion')
  );
end;

procedure TITDevConController.ExportActivities;
var
  LFormat: string;
begin
  // Postman Demo: Show how to use Custom Headers
  // User must send 'X-Export-Format: gpx' or 'json'
  LFormat := Context.Request.Headers['X-Export-Format'];

  if LFormat = '' then
    LFormat := 'json'; // Default

  Render(TJSONObject.Create
    .AddPair('export_id', TGUID.NewGuid.ToString)
    .AddPair('format_requested', LFormat)
    .AddPair('status', 'Ready for download')
    .AddPair('download_url', '/api/download/123')
  );
end;

end.
