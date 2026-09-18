unit Servico.Cliente;

interface

uses
  {Classes de Sistema}
   System.SysUtils
  {Classes de Negócio}
  ,Model.Cliente
  ,Servico.Base
  ,Repositorio.Interfaces;

type
  TServicoCliente = class(TServicoBase)
  public
    function ProcessarCliente(AModel: TCliente): Boolean;
  end;

implementation

{ TServicoCliente }

function TServicoCliente.ProcessarCliente(AModel: TCliente): Boolean;
begin
  if (AModel.Nome.IsEmpty) then
    raise Exception.Create('Informe o nome do cliente.');

  if (AModel.Cidade.IsEmpty) then
    raise Exception.Create('Informe a cidade do cliente.');

  if (AModel.UF.IsEmpty) then
    raise Exception.Create('Informe a UF do cliente.');

  Result := Self.Repositorio.Salvar(AModel);
end;

end.
