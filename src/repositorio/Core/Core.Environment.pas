unit Core.Environment;

interface

uses
  {Classes de sistema}
   System.Classes
  ,System.SysUtils
  {Classes de negócio}
  ,Core.DataBase.Interfaces;


type
  TEnvironment = class
  strict private
    FConnection: IDBConnection;
  private
    function GetConnection: IDBConnection;
  public
    {Construtores e destrutores}
    constructor Create; reintroduce;
    destructor Destroy; override;

    property Connection: IDBConnection read GetConnection;
  end;

  {Função global para utilizar como singleton o objeto Environment}
  function Env: TEnvironment;

var
  gEnv: TEnvironment;

implementation

uses
  Core.DataBase.DBConnectionFDAdapter;

{ TEnvironment }

constructor TEnvironment.Create;
begin
  inherited Create;
end;

destructor TEnvironment.Destroy;
begin
  inherited;
end;

function TEnvironment.GetConnection: IDBConnection;
begin
  if not Assigned(FConnection) then
    FConnection := TDBConnectionFireDac.Create;
  Result := FConnection;
end;

function Env: TEnvironment;
begin
  if not Assigned(gEnv) then
    gEnv := TEnvironment.Create;

  Result := gEnv;
end;

initialization
  gEnv := Env;

finalization
  FreeAndNil(gEnv);

end.
