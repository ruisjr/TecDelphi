unit Core.Database.DBConnectionFDAdapter;

interface

uses
{Classes de sistema}
   Data.DB
  ,Vcl.Forms
  ,FireDAC.DatS
  ,FireDAC.DApt
  ,FireDAC.Phys
  ,System.IniFiles
  ,System.SyncObjs
  ,System.SysUtils
  ,FireDAC.UI.Intf
  ,FireDAC.Phys.FB
  ,FireDAC.Stan.Def
  ,FireDAC.DApt.Intf
  ,FireDAC.Stan.Intf
  ,FireDAC.Phys.Intf
  ,FireDAC.Stan.Pool
  ,FireDAC.VCLUI.Wait
  ,FireDAC.Stan.Param
  ,FireDAC.Stan.Async
  ,FireDAC.Stan.Error
  ,FireDAC.Phys.FBDef
  ,FireDAC.Phys.IBBase
  ,FireDAC.Stan.Option
  ,Firedac.Comp.Client
  ,FireDAC.Comp.DataSet
  {Classes de Negócio}
  ,Core.DataBase.Interfaces
  ,Core.DataBase.DBQueryFDAdapter;

type
  TDBConnectionFireDac = class(TInterfacedObject, IDBConnection)
  strict private
    FLink: TFDPhysFBDriverLink;
    FConnection: TFDConnection;

    procedure LoadConfig;
  public
    {Construtores e Destrutores}
    constructor Create;
    destructor Destroy; override;

    {Class Functions}
    procedure FreeMemory;
  protected
    {Functions}
    function CreateQuery: IDBQuery;
    function IsConnected: Boolean;
    function InTransaction: Boolean;

    {Procedures}
    procedure Connect;
    procedure Disconnect;
    procedure StartTransaction;
    procedure CommitTransaction;
    procedure RollBackTransaction;
  end;

implementation

const
  cAppName = 'TecDelphi';

var
  FRepositorioFireDac: TDBConnectionFireDac;


{ TDBConnectionAdapter }

procedure TDBConnectionFireDac.CommitTransaction;
begin
  FConnection.Commit;
end;

procedure TDBConnectionFireDac.Connect;
begin
  try
    FConnection.Connected := True;
  except
    on E: Exception do
    begin
      raise Exception.Create('A conexaõ com o banco de dados não pode ser aberta.'+#13#10 + E.Message);
    end;
  end;
end;

constructor TDBConnectionFireDac.Create;
begin
  LoadConfig;
end;

function TDBConnectionFireDac.CreateQuery: IDBQuery;
begin
  Result := TDBQueryPGAdapter.Create(Self.FConnection);
end;

destructor TDBConnectionFireDac.Destroy;
begin
  Self.FreeMemory;
  inherited;
end;

procedure TDBConnectionFireDac.Disconnect;
begin
  if (FConnection.Connected) then
  begin
    try
      FConnection.Connected := False;
    except
      on E : Exception do
      begin
        raise Exception.Create('A conexão com o banco de dados não pode ser finalizada.' + #13#10 + E.Message);
      end;
    end;
  end;
end;

procedure TDBConnectionFireDac.FreeMemory;
begin
  FreeAndNil(FLink);
  FreeAndNil(FConnection);
end;

function TDBConnectionFireDac.InTransaction: Boolean;
begin
  Result := FConnection.InTransaction;
end;

function TDBConnectionFireDac.IsConnected: Boolean;
begin
  Result := FConnection.Connected;
end;

procedure TDBConnectionFireDac.LoadConfig;
var
  LPath: String;
  LArqIni: TIniFile;
begin
  try
    LPath := IncludeTrailingPathDelimiter('C:\'+cAppName+'\bin')+'FDConnectionDefs.ini';
    LArqIni := TIniFile.Create(LPath);
    try
      FLink := TFDPhysFBDriverLink.Create(nil);
      FLink.Release;
      FLink.VendorLib := LArqIni.ReadString(cAppName, 'VendorLib', '');

      FConnection := TFDConnection.Create(nil);

      FConnection.ConnectionName  := cAppName;
      FConnection.LoginPrompt     := False;
      FConnection.Name            := 'Conn' + cAppName;

      FConnection.DriverName      := LArqIni.ReadString(cAppName, 'DriverID', '');
      FConnection.Params.Database := LArqIni.ReadString(cAppName, 'Database', '');

      with (TFDPhysFBConnectionDefParams(FConnection.Params)) do
      begin
        Port            := LArqIni.ReadInteger(cAppName, 'Port', 0);
        Server          := LArqIni.ReadString(cAppName,  'Server', 'localhost');
        DriverID        := LArqIni.ReadString(cAppName,  'DriverID', '');
        Database        := LArqIni.ReadString(cAppName,  'Database', '');
        Password        := LArqIni.ReadString(cAppName,  'Password',  '');
        UserName        := LArqIni.ReadString(cAppName,  'User_Name', '');
      end;

      FConnection.Params.Add('CharacterSet=' + LArqIni.ReadString(cAppName, 'CharacterSet', 'UTF8'));
      FConnection.Params.Add('Protocol=' + LArqIni.ReadString(cAppName, 'Protocol', 'TCPIP'));

      Self.Connect;
    finally
      FreeAndNil(LArqIni);
    end;
  except
    on E: Exception do
    begin
      raise Exception.Create('As configurações do banco de dados não foram carregadas.' + #13#10 + E.Message);
    end;
  end;
end;

procedure TDBConnectionFireDac.RollBackTransaction;
begin
  FConnection.Rollback;
end;

procedure TDBConnectionFireDac.StartTransaction;
begin
  FConnection.StartTransaction;
end;

end.
