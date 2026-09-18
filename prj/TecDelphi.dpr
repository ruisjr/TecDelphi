program TecDelphi;

uses
  Vcl.Forms,
  View.Pedido in '..\src\view\View.Pedido.pas' {frmPedido},
  Model.Cliente in '..\src\model\Model.Cliente.pas',
  Model.Produto in '..\src\model\Model.Produto.pas',
  Model.Pedido in '..\src\model\Model.Pedido.pas',
  Repositorio.Interfaces in '..\src\repositorio\Repositorio.Interfaces.pas',
  Core.Database.Criteria in '..\src\repositorio\Core\Database\Core.Database.Criteria.pas',
  Core.Database.DBConnectionFDAdapter in '..\src\repositorio\Core\Database\Core.Database.DBConnectionFDAdapter.pas',
  Core.Database.DBManager in '..\src\repositorio\Core\Database\Core.Database.DBManager.pas',
  Core.Database.DBQueryFDAdapter in '..\src\repositorio\Core\Database\Core.Database.DBQueryFDAdapter.pas',
  Core.Database.DBRtti in '..\src\repositorio\Core\Database\Core.Database.DBRtti.pas',
  Core.Database.DBTypes in '..\src\repositorio\Core\Database\Core.Database.DBTypes.pas',
  Core.Database.Interfaces in '..\src\repositorio\Core\Database\Core.Database.Interfaces.pas',
  Core.Database.RttiHelper in '..\src\repositorio\Core\Database\Core.Database.RttiHelper.pas',
  Core.Database.SQLMaker in '..\src\repositorio\Core\Database\Core.Database.SQLMaker.pas',
  Core.Entidade.CustomAttributes in '..\src\repositorio\Core\Entidades\Core.Entidade.CustomAttributes.pas',
  Core.Entidade.ModelBase in '..\src\repositorio\Core\Entidades\Core.Entidade.ModelBase.pas',
  Core.Environment in '..\src\repositorio\Core\Core.Environment.pas',
  Core.Exceptions in '..\src\repositorio\Core\Core.Exceptions.pas',
  Repositorio.Pedido in '..\src\repositorio\Repositorio.Pedido.pas',
  Servico.Pedido in '..\src\service\Servico.Pedido.pas',
  Servico.Cliente in '..\src\service\Servico.Cliente.pas',
  Servico.Produto in '..\src\service\Servico.Produto.pas',
  Repositorio.Cliente in '..\src\repositorio\Repositorio.Cliente.pas',
  Repositorio.Produto in '..\src\repositorio\Repositorio.Produto.pas',
  Servico.Base in '..\src\service\Servico.Base.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPedido, frmPedido);
  Application.Run;
end.
