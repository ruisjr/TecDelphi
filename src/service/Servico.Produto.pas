unit Servico.Produto;

interface

uses
  {Classes de Sistema}
  System.SysUtils
  {Classes de Negócio}
  ,Model.Produto
  ,Servico.Base
  ,Repositorio.Interfaces;

type
  TServicoProduto = class(TServicoBase)
  public
    function ProcessarProduto(AModel: TProduto): Boolean;
  end;

implementation

{ TServicoProduto }


function TServicoProduto.ProcessarProduto(AModel: TProduto): Boolean;
begin
  if (AModel.Descricao.IsEmpty) then
    raise Exception.Create('Informe a descrição do produto.');

  if (AModel.PrecoVenda <= 0) then
    raise Exception.Create('Informe o preço de venda do produto.');

  Result := Self.Repositorio.Salvar(AModel);
end;

end.
