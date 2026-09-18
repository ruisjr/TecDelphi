unit Repositorio.Cliente;

interface

uses
  {Classes de Sistema}
  System.SysUtils
  {Classes de Negócio}
  ,Model.Cliente
  ,Core.Environment
  ,Core.Database.DBManager
  ,Core.Database.Interfaces
  ,Repositorio.Interfaces;

type
  TRepositorioCliente = class(TInterfacedObject, IRepositorio)
  private

  public
    function Salvar(AModel: TObject): Boolean;
    function Remover(AModel: TObject): Boolean; overload;
    function Remover(AID: Integer): Boolean; overload;
    function RetornarRegistro(ACod: Integer): TObject;
  end;

implementation

{ TRepositorioCliente }

function TRepositorioCliente.Remover(AModel: TObject): Boolean;
var
  LManager: IDBManager<TCliente>;
begin
  Result := False;
  LManager := TDBManager<TCliente>.Create(Env.Connection);
  try
    LManager.Delete(TCliente(AModel));
    Result := True;
  finally
    LManager := Nil;
  end;
end;

function TRepositorioCliente.Remover(AID: Integer): Boolean;
begin

end;

function TRepositorioCliente.RetornarRegistro(ACod: Integer): TObject;
var
  LManager: IDBManager<TCliente>;
begin
  LManager := TDBManager<TCliente>.Create(Env.Connection);
  try
    Result := LManager.Find(ACod);
  finally
    LManager := Nil;
  end;
end;

function TRepositorioCliente.Salvar(AModel: TObject): Boolean;
var
  LManager: IDBManager<TCliente>;
begin
  Env.Connection.StartTransaction;
  try
    LManager := TDBManager<TCliente>.Create(Env.Connection);
    try
      if (TCliente(AModel).Codigo > 0) then
        LManager.Update(TCliente(AModel))
      else
        LManager.Insert(TCliente(AModel));
    finally
      LManager := Nil;
    end;

    Env.Connection.CommitTransaction;
  except
    on E: Exception do
    begin
      Env.Connection.RollBackTransaction;
      raise Exception.Create('Não foi possível salvar o Cliente.');
    end;
  end;

  Result := True;
end;

end.

