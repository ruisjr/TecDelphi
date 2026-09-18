unit Servico.Pedido;

interface

uses
  {Classes de Sistema}
   System.SysUtils
  ,System.Generics.Collections
  {Classes de Negócio}
  ,Model.Pedido
  ,Servico.Base
  ,Repositorio.Pedido
  ,Repositorio.Interfaces;

type
  TServicoPedido = class(TServicoBase)
  public
    function ProcessarPedido(APedido: TPedido): Boolean;
    function RemoverPedidoItem(APedido: TPedidoItem): Boolean;

    function RetornarRegistroLista(APedido: TPedido): TObjectList<TPedidoItem>;
  end;

implementation

{ TServicoPedido }

function TServicoPedido.ProcessarPedido(APedido: TPedido): Boolean;
begin
  if (APedido.CodigoCliente <= 0) then
    raise Exception.Create('Informe um cliente válido.');

  if (APedido.Itens.Count = 0) then
    raise Exception.Create('O pedido precisa ter pelo menos um item.');

  Result := Self.Repositorio.Salvar(APedido);
end;

function TServicoPedido.RemoverPedidoItem(APedido: TPedidoItem): Boolean;
begin
  if (APedido.ID > 0) then
  begin
    Result := Self.Repositorio.Remover(APedido);
  end;
end;

function TServicoPedido.RetornarRegistroLista(APedido: TPedido): TObjectList<TPedidoItem>;
begin
  if (APedido.NumeroPedido > 0) then
  begin
    Result := TRepositorioPedido(Self.Repositorio).RetornarRegistroLista(APedido.NumeroPedido);
  end;
end;

end.
