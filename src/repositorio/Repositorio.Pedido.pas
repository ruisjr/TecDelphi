unit Repositorio.Pedido;

interface

uses
  {Classes de Sistema}
  System.SysUtils
  {Classes de Negócio}
  ,Model.Pedido
  ,Core.Environment
  ,Core.Database.DBManager
  ,Core.Database.Interfaces
  ,Repositorio.Interfaces;

type
  TRepositorioPedido = class(TInterfacedObject, IRepositorio)
  private

  public
    function Salvar(AModel: TObject): Boolean;
    function Carregar: TPedido;
  end;

implementation

{ TRepositorioPedido<T> }

function TRepositorioPedido.Carregar: TPedido;
var
  LManager: IDBManager<TPedido>;
begin
  LManager := TDBManager<TPedido>.Create(Env.Connection);
  try
    Result := LManager.Find;
  finally
    LManager := Nil;
  end;
end;

function TRepositorioPedido.Salvar(AModel: TObject): Boolean;
var
  LManager: IDBManager<TPedido>;
begin
  Env.Connection.StartTransaction;
  try
    LManager := TDBManager<TPedido>.Create(Env.Connection);
    try
      if (TPedido(AModel).NumeroPedido > 0) then
        LManager.Update(TPedido(AModel))
      else
        LManager.Insert(TPedido(AModel));
    finally
      LManager := Nil;
    end;

    Env.Connection.CommitTransaction;
  except
    on E: Exception do
    begin
      Env.Connection.RollBackTransaction;
      raise Exception.Create('Ocorreu erro ao lançar pedido.');
    end;
  end;

  Result := True;
end;

end.
