unit Servico.Pedido;

interface

uses
  {Classes de Sistema}
  System.SysUtils
  {Classes de Negócio}
  ,Model.Pedido
  ,Servico.Base
  ,Repositorio.Interfaces;

type
  TServicoPedido = class(TServicoBase)
  public
    function ProcessarPedido(APedido: TPedido): Boolean;
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

end.
