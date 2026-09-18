unit Servico.Pedido;

interface

uses
  {Classes de Sistema}
  System.SysUtils
  {Classes de Negócio}
  ,Model.Pedido
  ,Repositorio.Interfaces;

type
  TServico = class
  private
    FRepositorio: IRepositorio;
  public
    constructor Create(ARepositorio: IRepositorio);

    function ProcessarPedido(APedido: TPedido): Boolean;
  end;

implementation

{ TServico }

constructor TServico.Create(ARepositorio: IRepositorio);
begin
  FRepositorio := ARepositorio;
end;

function TServico.ProcessarPedido(APedido: TPedido): Boolean;
begin
  if (APedido.CodigoCliente <= 0) then
    raise Exception.Create('Informe um cliente válido.');

  if (APedido.Itens.Count = 0) then
    raise Exception.Create('O pedido precisa ter pelo menos um item.');

  Result := FRepositorio.Salvar(APedido);
end;

end.
