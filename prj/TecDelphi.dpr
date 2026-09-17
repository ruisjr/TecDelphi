program TecDelphi;

uses
  Vcl.Forms,
  View.Pedido in '..\src\view\View.Pedido.pas' {frmPedido},
  model.cliente in '..\src\model\model.cliente.pas',
  model.produto in '..\src\model\model.produto.pas',
  model.pedido in '..\src\model\model.pedido.pas',
  repositorio.interfaces in '..\src\repositorio\repositorio.interfaces.pas',
  repositorio.database.firedac in '..\src\repositorio\repositorio.database.firedac.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPedido, frmPedido);
  Application.Run;
end.
