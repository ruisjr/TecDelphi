unit Repositorio.Pedido;

interface

uses
  {Classes de Sistema}
   System.SysUtils
  ,System.Generics.Collections
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
    function Remover(AModel: TObject): Boolean;
    function RemoverPedidoItem(AModel: TObject): boolean;
    function RetornarRegistro(ACod: Integer): TObject;
    function RetornarRegistroLista(ACod: Integer): TObjectList<TPedidoItem>;
  end;

implementation

uses
  Core.Database.Criteria;

function TRepositorioPedido.Remover(AModel: TObject): Boolean;
var
  LManager: IDBManager<TPedido>;
begin
  Result := False;
  LManager := TDBManager<TPedido>.Create(Env.Connection);
  try
    LManager.Delete(TPedido(AModel));
    Result := True;
  finally
    LManager := Nil;
  end;
end;

function TRepositorioPedido.RemoverPedidoItem(AModel: TObject): boolean;
var
  LManager: IDBManager<TPedidoItem>;
begin
  Result := False;
  LManager := TDBManager<TPedidoItem>.Create(Env.Connection);
  try
    LManager.Delete(TPedidoItem(AModel));
    Result := True;
  finally
    LManager := Nil;
  end;
end;

{ TRepositorioPedido<T> }

function TRepositorioPedido.RetornarRegistro(ACod: Integer): TObject;
var
  LManager: IDBManager<TPedido>;
begin
  LManager := TDBManager<TPedido>.Create(Env.Connection);
  try
    Result := LManager.Find(ACod);
  finally
    LManager := Nil;
  end;
end;

function TRepositorioPedido.RetornarRegistroLista(ACod: Integer): TObjectList<TPedidoItem>;
var
  LManager: IDBManager<TPedidoItem>;
begin
  LManager := TDBManager<TPedidoItem>.Create(Env.Connection);
  try
    Result := LManager.Where(TCriteria.Equal('numero_pedido', ACod)).FindAll;
  finally
    LManager := Nil;
  end;
end;

function TRepositorioPedido.Salvar(AModel: TObject): Boolean;
var
  ix: Integer;
  LPedido: TPedido;
  LPedidoItem: TPedidoItem;
  LManagerPed: IDBManager<TPedido>;
  LManagerItem: IDBManager<TPedidoItem>;
begin
  Env.Connection.StartTransaction;
  try
    LManagerPed  := TDBManager<TPedido>.Create(Env.Connection);
    LManagerItem := TDBManager<TPedidoItem>.Create(Env.Connection);
    try
      LPedido := TPedido(AModel);

      if (LPedido.NumeroPedido > 0) then
        LManagerPEd.Update(LPedido)
      else
        LManagerPed.Insert(LPedido);

      for ix := 0 to LPedido.Itens.Count -1 do
      begin
        LPedidoItem := LPedido.Itens[ix];

        LPedidoItem.NumeroPedido := LPedido.NumeroPedido;
        if (LPedidoItem.ID > 0) then
          LManagerItem.Update(LPedidoItem)
        else
          LManagerItem.Insert(LPedidoItem);
      end;
    finally
      LManagerPed  := Nil;
      LManagerItem := nil;
    end;

    Env.Connection.CommitTransaction;
  except
    on E: Exception do
    begin
      Env.Connection.RollBackTransaction;
      raise Exception.Create('Não foi possível salvar o Pedido.');
    end;
  end;

  Result := True;
end;

end.
