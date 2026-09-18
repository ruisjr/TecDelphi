unit Repositorio.Produto;

interface

uses
  {Classes de Sistema}
  System.SysUtils
  {Classes de Negócio}
  ,Model.Produto
  ,Core.Environment
  ,Core.Database.DBManager
  ,Core.Database.Interfaces
  ,Repositorio.Interfaces;

type
  TRepositorioProduto = class(TInterfacedObject, IRepositorio)
  private

  public
    function Salvar(AModel: TObject): Boolean;
    function Remover(AModel: TObject): Boolean; overload;
    function Remover(AID: Integer): Boolean; overload;
    function RetornarRegistro(ACod: Integer): TObject;
  end;

implementation

{ TRepositorioProduto }

function TRepositorioProduto.Remover(AModel: TObject): Boolean;
var
  LManager: IDBManager<TProduto>;
begin
  Result := False;
  LManager := TDBManager<TProduto>.Create(Env.Connection);
  try
    LManager.Delete(TProduto(AModel));
    Result := True;
  finally
    LManager := Nil;
  end;
end;

function TRepositorioProduto.Remover(AID: Integer): Boolean;
begin

end;

function TRepositorioProduto.RetornarRegistro(ACod: Integer): TObject;
var
  LManager: IDBManager<TProduto>;
begin
  LManager := TDBManager<TProduto>.Create(Env.Connection);
  try
    Result := LManager.Find(ACod);
  finally
    LManager := Nil;
  end;
end;

function TRepositorioProduto.Salvar(AModel: TObject): Boolean;
var
  LManager: IDBManager<TProduto>;
begin
  Env.Connection.StartTransaction;
  try
    LManager := TDBManager<TProduto>.Create(Env.Connection);
    try
      if (TProduto(AModel).Codigo > 0) then
        LManager.Update(TProduto(AModel))
      else
        LManager.Insert(TProduto(AModel));
    finally
      LManager := Nil;
    end;

    Env.Connection.CommitTransaction;
  except
    on E: Exception do
    begin
      Env.Connection.RollBackTransaction;
      raise Exception.Create('Ocorreu erro salvar o Produto.');
    end;
  end;

  Result := True;
end;

end.
