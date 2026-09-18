unit View.Pedido;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls,
  Data.DB, Vcl.Grids, Vcl.DBGrids, Vcl.Buttons, System.UITypes

  {Classes de Negócio}
  ,Model.Pedido
  ,Model.Cliente
  ,Servico.Cliente, Datasnap.DBClient;

type
  TfrmPedido = class(TForm)
    grpDadosPedido: TGroupBox;
    edtNumeroPedido: TEdit;
    Label1: TLabel;
    edtDataEmissao: TDateTimePicker;
    Label5: TLabel;
    grpDadosCliente: TGroupBox;
    edtNome: TEdit;
    edtCidade: TEdit;
    edtUF: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    pnlGrid: TPanel;
    lblClienteCod: TLabel;
    edtClienteCod: TEdit;
    pnlPedidoBotoes: TPanel;
    grdPedidoItens: TDBGrid;
    Panel1: TPanel;
    Label6: TLabel;
    lblTotal: TLabel;
    sbPesquisaPedido: TSpeedButton;
    sbPesquisaCliente: TSpeedButton;
    Panel2: TPanel;
    btnNovoPedido: TSpeedButton;
    btnFechar: TSpeedButton;
    btnSalvarPedido: TSpeedButton;
    btnNovoProduto: TSpeedButton;
    cdsPedidos: TClientDataSet;
    cdsPedidosid: TIntegerField;
    cdsPedidosNumeroPedido: TStringField;
    cdsPedidosVlrTotal: TCurrencyField;
    DsPedidos: TDataSource;
    cdsPedidosCodigoProduto: TIntegerField;
    cdsPedidosQuantidade: TFloatField;
    cdsPedidosvlr_unitario: TCurrencyField;
    procedure btnFecharClick(Sender: TObject);
    procedure sbPesquisaClienteClick(Sender: TObject);
    procedure edtClienteCodKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnSalvarPedidoClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure grdPedidoItensKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnNovoPedidoClick(Sender: TObject);
    procedure cdsPedidosAfterScroll(DataSet: TDataSet);
  private
    { Private declarations }

    procedure CarregarCliente(ACliente: TCliente);
    procedure LimparCliente;
    procedure LimparPedido;
    procedure RemoverItem;
  public
    { Public declarations }
  end;

var
  frmPedido: TfrmPedido;

implementation

uses
   Repositorio.Pedido
  ,Repositorio.Cliente;

{$R *.dfm}

procedure TfrmPedido.CarregarCliente(ACliente: TCliente);
begin
  LimparCliente;

  edtClienteCod.Text := ACliente.Codigo.ToString;
  edtNome.Text       := ACliente.Nome;
  edtCidade.Text     := ACliente.Cidade;
  edtUF.Text         := ACliente.UF;
end;

procedure TfrmPedido.cdsPedidosAfterScroll(DataSet: TDataSet);
var
  LTotal: Double;
begin
  LTotal := 0;
  cdsPedidos.DisableControls;
  try
    while not cdsPedidos.Eof do
    begin
      LTotal := LTotal + cdsPedidos.FieldByName('vlr_total').AsFloat;
      cdsPedidos.Next;
    end;

    lblTotal.Caption := FormatFloat('R$ ,0.00', LTotal);
  finally
    cdsPedidos.EnableControls;
  end;
end;

procedure TfrmPedido.edtClienteCodKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    sbPesquisaClienteClick(self);
end;

procedure TfrmPedido.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_F4: btnFecharClick(Sender);
    VK_F9: btnNovoPedidoClick(Sender);
    VK_F10: btnSalvarPedidoClick(Sender);
  end;

end;

procedure TfrmPedido.grdPedidoItensKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key = VK_DELETE) and (MessageDlg('Confirma exclusão deste produto?', TMsgDlgType.mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
    RemoverItem;
end;

procedure TfrmPedido.LimparCliente;
begin
  edtClienteCod.Clear;
  edtNome.Clear;
  edtCidade.Clear;
  edtUF.Clear;
end;

procedure TfrmPedido.LimparPedido;
begin
  edtNumeroPedido.Clear;
  edtDataEmissao.DateTime := Now;
end;

procedure TfrmPedido.RemoverItem;
begin
  //
end;

procedure TfrmPedido.sbPesquisaClienteClick(Sender: TObject);
var
  LCliente: TCLiente;
  LServico: TServicoCliente;
begin
  LCliente := TCliente.Create;
  LServico := TServicoCliente.Create(TRepositorioCliente.Create);
  try
    LCliente.Codigo := StrToIntDef(edtNumeroPedido.Text, 0);
    LCliente.Nome   := edtNome.Text;
    LCliente.Cidade := edtCidade.Text;
    LCliente.UF     := edtUf.Text;

    LCliente := LServico.RetornarRegistro(StrToIntDef(edtClienteCod.Text, 0)) as TCliente;

    if (LCliente = nil) or (LCliente.Codigo = 0) then
    begin
      MessageDlg('Cliente não encontrado.', mtInformation, [mbOK], 0);
      Exit;
    end;

    CarregarCliente(LCliente);
  finally
    FreeAndNil(LServico);
    FreeAndNil(LCliente);
  end;
end;

procedure TfrmPedido.btnNovoPedidoClick(Sender: TObject);
begin
  LimparPedido;
end;

procedure TfrmPedido.btnSalvarPedidoClick(Sender: TObject);
var
  LPedido: TPedido;
  LRepositorio: TRepositorioPedido;
begin
  LPedido      := TPedido.Create;
  LRepositorio := TRepositorioPedido.Create;
  try
    LPedido.NumeroPedido := StrToIntDef(edtNumeroPedido.Text, 0);
    LPedido.DataEmissao  := edtDataEmissao.Date;

    LRepositorio.Salvar(LPedido);
  finally
    FreeAndNil(LRepositorio);
    FreeAndNil(LPedido);
  end;
end;

procedure TfrmPedido.btnFecharClick(Sender: TObject);
begin
  if (messageDlg('Tem certeza que deseja sair?', mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
    Application.Terminate;
end;

end.
