unit View.Pedido;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls,
  Data.DB, Vcl.Grids, Vcl.DBGrids, Vcl.Buttons, System.UITypes, Datasnap.DBClient

  {Classes de Negócio}
  ,Model.Pedido
  ,Model.Cliente
  ,Model.Produto
  ,Servico.Pedido
  ,Servico.Cliente
  ,Servico.Produto;

type
  TfrmPedido = class(TForm)
    grbDadosPedido: TGroupBox;
    edtNumeroPedido: TEdit;
    Label1: TLabel;
    edtDataEmissao: TDateTimePicker;
    Label5: TLabel;
    grbDadosCliente: TGroupBox;
    edtNome: TEdit;
    edtCidade: TEdit;
    edtUF: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    lblClienteCod: TLabel;
    edtClienteCod: TEdit;
    sbPesquisaPedido: TSpeedButton;
    sbPesquisaCliente: TSpeedButton;
    Panel2: TPanel;
    btnNovoPedido: TSpeedButton;
    btnFechar: TSpeedButton;
    btnSalvarPedido: TSpeedButton;
    cdsProdutos: TClientDataSet;
    cdsProdutosid: TIntegerField;
    cdsProdutosNumeroPedido: TStringField;
    cdsProdutosVlrTotal: TCurrencyField;
    DsProdutos: TDataSource;
    cdsProdutosCodigoProduto: TIntegerField;
    cdsProdutosQuantidade: TFloatField;
    cdsProdutosvlr_unitario: TCurrencyField;
    gpbItens: TGroupBox;
    pnlGrid: TPanel;
    pnlPedidoBotoes: TPanel;
    btnNovoProduto: TSpeedButton;
    Label7: TLabel;
    Label8: TLabel;
    edtProdutoCodigo: TEdit;
    edtProdutoNome: TEdit;
    grdPedidoItens: TDBGrid;
    Panel1: TPanel;
    Label6: TLabel;
    lblTotal: TLabel;
    sbPesquisaProduto: TSpeedButton;
    cdsProdutosDescricao: TStringField;
    procedure btnFecharClick(Sender: TObject);
    procedure sbPesquisaClienteClick(Sender: TObject);
    procedure edtClienteCodKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnSalvarPedidoClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure grdPedidoItensKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnNovoPedidoClick(Sender: TObject);
    procedure sbPesquisaProdutoClick(Sender: TObject);
    procedure edtProdutoCodigoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure sbPesquisaPedidoClick(Sender: TObject);
    procedure btnNovoProdutoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cdsProdutosCalcFields(DataSet: TDataSet);
    procedure cdsProdutosAfterOpen(DataSet: TDataSet);
    procedure cdsProdutosAfterPost(DataSet: TDataSet);
    procedure cdsProdutosAfterDelete(DataSet: TDataSet);
    procedure cdsProdutosAfterEdit(DataSet: TDataSet);
    procedure FormDestroy(Sender: TObject);
    procedure edtNumeroPedidoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    FPedido: TPedido;
    FCliente: TCliente;
    FProduto: TProduto;

    procedure CarregarPedido(APedido: TPedido);
    procedure CarregarCliente(ACliente: TCliente);
    procedure CarregarProduto(AProduto: TProduto);

    procedure IncluirProduto(AProduto: TProduto);
    procedure ProcessarItensSalvar(APedido: TPedido);
    procedure AtualizarTotal;

    procedure LimparCliente;
    procedure LimparPedido;
    procedure LimparProduto;
    procedure RemoverItem;

    function RetornarProdutoPorID(ACod: Integer): TProduto;
  public
    { Public declarations }
  end;

var
  frmPedido: TfrmPedido;

implementation

uses
   Repositorio.Pedido
  ,Repositorio.Cliente
  ,Repositorio.Produto;

{$R *.dfm}

procedure TfrmPedido.CarregarCliente(ACliente: TCliente);
begin
  LimparCliente;

  edtClienteCod.Text := ACliente.Codigo.ToString;
  edtNome.Text       := ACliente.Nome;
  edtCidade.Text     := ACliente.Cidade;
  edtUF.Text         := ACliente.UF;
end;

procedure TfrmPedido.CarregarPedido(APedido: TPedido);
var
  ix: Integer;
  LProduto: TProduto;
begin
  edtDataEmissao.Date := APedido.DataEmissao;
  for ix := 0 to APedido.Itens.Count -1 do
  begin
    try
      LProduto := RetornarProdutoPorID(APedido.itens[ix].CodigoProduto);
      try
        cdsProdutos.Append;
        cdsProdutos.FieldByName('numero_Pedido').AsInteger  := APedido.itens[ix].ID;
        cdsProdutos.FieldByName('numero_Pedido').AsInteger  := APedido.itens[ix].NumeroPedido;
        cdsProdutos.FieldByName('codigo_produto').AsInteger := APedido.itens[ix].CodigoProduto;
        cdsProdutos.FieldByName('descricao').AsString       := LProduto.Descricao;
        cdsProdutos.FieldByName('quantidade').AsFloat       := APedido.itens[ix].Quantidade;
        cdsProdutos.FieldByName('vlr_unitario').AsFloat     := APedido.itens[ix].VlrUnitario;
        cdsProdutos.FieldByName('vlr_total').AsFloat        := APedido.itens[ix].VlrTotal;
        cdsProdutos.Post;
      finally
        FreeAndNil(FProduto);
      end;
    finally
      LimparProduto;
    end;
  end;
end;

procedure TfrmPedido.CarregarProduto(AProduto: TProduto);
begin
  edtProdutoNome.Text := FProduto.Descricao;
end;

procedure TfrmPedido.cdsProdutosAfterDelete(DataSet: TDataSet);
begin
  AtualizarTotal;
end;

procedure TfrmPedido.cdsProdutosAfterEdit(DataSet: TDataSet);
begin
  AtualizarTotal;
end;

procedure TfrmPedido.cdsProdutosAfterOpen(DataSet: TDataSet);
begin
  AtualizarTotal;
end;

procedure TfrmPedido.cdsProdutosAfterPost(DataSet: TDataSet);
begin
  AtualizarTotal;
end;

procedure TfrmPedido.cdsProdutosCalcFields(DataSet: TDataSet);
begin
  DataSet.FieldByName('vlr_total').AsFloat := DataSet.FieldByName('quantidade').AsFloat * DataSet.FieldByName('vlr_unitario').AsFloat;
end;

procedure TfrmPedido.edtClienteCodKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    sbPesquisaClienteClick(self);
end;

procedure TfrmPedido.edtNumeroPedidoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    sbPesquisaPedidoClick(Sender);
end;

procedure TfrmPedido.edtProdutoCodigoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_RETURN) then
    sbPesquisaProdutoClick(Sender);
end;

procedure TfrmPedido.FormCreate(Sender: TObject);
begin
  cdsProdutos.CreateDataSet;
  FPedido  := TPedido.Create;
end;

procedure TfrmPedido.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FPedido);
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

procedure TfrmPedido.IncluirProduto(AProduto: TProduto);
begin
  try
    cdsProdutos.Append;
    cdsProdutos.FieldByName('numero_Pedido').AsInteger  := StrToIntDef(edtNumeroPedido.Text, 0);
    cdsProdutos.FieldByName('codigo_produto').AsInteger := AProduto.Codigo;
    cdsProdutos.FieldByName('descricao').AsString       := AProduto.Descricao;
    cdsProdutos.FieldByName('quantidade').AsInteger     := 1;
    cdsProdutos.FieldByName('vlr_unitario').AsFloat     := AProduto.PrecoVenda;
    cdsProdutos.FieldByName('vlr_total').AsFloat        := AProduto.PrecoVenda;
    cdsProdutos.Post;
  finally
    LimparProduto;
    FreeAndNil(FProduto);
  end;
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
  FreeAndNil(FPedido);
  FreeAndNil(FCliente);

  edtNumeroPedido.Clear;
  edtDataEmissao.DateTime := Now;
  cdsProdutos.EmptyDataSet;
  lblTotal.Caption := 'R$ 0,00';
end;

procedure TfrmPedido.LimparProduto;
begin
  edtProdutoCodigo.Clear;
  edtProdutoNome.Clear;
end;

procedure TfrmPedido.ProcessarItensSalvar(APedido: TPedido);
var
  LPedidoItem: TPedidoItem;
begin
  cdsProdutos.DisableControls;
  try
    cdsProdutos.First;
    while not cdsProdutos.Eof do
    begin
      LPedidoItem := TPedidoItem.Create;
      LPedidoItem.CodigoProduto := cdsProdutos.FieldByName('codigo_produto').AsInteger;
      LPedidoItem.Quantidade    := cdsProdutos.FieldByName('quantidade').AsInteger;
      LPedidoItem.VlrUnitario   := cdsProdutos.FieldByName('vlr_unitario').AsInteger;
      LPedidoItem.VlrTotal      := cdsProdutos.FieldByName('vlr_total').AsInteger;
      APedido.Itens.Add(LPedidoItem);
      cdsProdutos.Next;
    end;
  finally
    cdsProdutos.EnableControls;
  end;
end;

procedure TfrmPedido.RemoverItem;
begin
  //
end;

function TfrmPedido.RetornarProdutoPorID(ACod: Integer): TProduto;
var
  LServico: TServicoProduto;
begin
  LServico := TServicoProduto.Create(TRepositorioProduto.Create);
  try
    Result := LServico.RetornarRegistro(ACod) as TProduto;

    if (Result = nil) or (Result.Codigo = 0) then
    begin
      Exit;
    end;
  finally
    FreeAndNil(LServico);
  end;
end;

procedure TfrmPedido.sbPesquisaClienteClick(Sender: TObject);
var
  LServico: TServicoCliente;
begin
  FCliente := TCliente.Create;
  LServico := TServicoCliente.Create(TRepositorioCliente.Create);
  try
    FCliente := LServico.RetornarRegistro(StrToIntDef(edtClienteCod.Text, 0)) as TCliente;

    if (FCliente = nil) or (FCliente.Codigo = 0) then
    begin
      MessageDlg('Cliente não encontrado.', mtInformation, [mbOK], 0);
      Exit;
    end;

    CarregarCliente(FCliente);
  finally
    FreeAndNil(LServico);
  end;
end;

procedure TfrmPedido.sbPesquisaPedidoClick(Sender: TObject);
var
  LServico: TServicoPedido;
  LServicoCliente: TServicoCliente;
begin
  FPedido := TPedido.Create;
  LServico := TServicoPedido.Create(TRepositorioPedido.Create);
  LServicoCliente := TServicoCliente.Create(TRepositorioCliente.Create);
  try
    FPedido := TServicoPedido(LServico).RetornarRegistro(StrToIntDef(edtNumeroPedido.Text, 0)) as TPedido;
    FPedido.Itens := LServico.RetornarRegistroLista(FPedido);

    if (FPedido = nil) or (FPedido.NumeroPedido = 0) then
    begin
      MessageDlg('Pedido não encontrado.', mtInformation, [mbOK], 0);
      Exit;
    end;

    CarregarCliente(LServicoCliente.RetornarRegistro(FPedido.CodigoCliente) as TCliente);
    CarregarPedido(FPedido);
  finally
    FreeAndNil(LServico);
  end;
end;

procedure TfrmPedido.sbPesquisaProdutoClick(Sender: TObject);
var
  LServico: TServicoProduto;
begin
  FProduto := TProduto.Create;
  LServico := TServicoProduto.Create(TRepositorioProduto.Create);
  try
    FProduto := LServico.RetornarRegistro(StrToIntDef(edtProdutoCodigo.Text, 0)) as TProduto;

    if (FProduto = nil) or (FProduto.Codigo = 0) then
    begin
      FProduto := Nil;
      MessageDlg('Produto não encontrado.', mtInformation, [mbOK], 0);
      Exit;
    end;

    CarregarProduto(FProduto);
  finally
    FreeAndNil(LServico);
  end;
end;

procedure TfrmPedido.btnNovoPedidoClick(Sender: TObject);
begin
  if (FCliente <> nil) or (not cdsProdutos.IsEmpty) then
  begin
    if messageDlg('Você possui um pedido em andamento, deseja continuar?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then
      Exit;
  end;

  LimparPedido;
  LimparCliente;
  LimparProduto;
end;

procedure TfrmPedido.btnNovoProdutoClick(Sender: TObject);
begin
  try
    IncluirProduto(FProduto);
  finally
    FreeAndNil(FProduto);
    LimparProduto;
  end;
end;

procedure TfrmPedido.btnSalvarPedidoClick(Sender: TObject);
var
  LServico: TServicoPedido;
begin
  LServico := TServicoPedido.Create(TRepositorioPedido.Create);
  try
    FPedido.NumeroPedido  := StrToIntDef(edtNumeroPedido.Text, 0);
    FPedido.DataEmissao   := edtDataEmissao.Date;
    FPedido.CodigoCliente := StrToIntDef(edtClienteCod.Text, 0);

    ProcessarItensSalvar(FPedido);

    LServico.ProcessarPedido(FPedido);

    edtNumeroPedido.Text := FPedido.NumeroPedido.ToString;
  finally
    FreeAndNil(LServico);
  end;
end;

procedure TfrmPedido.AtualizarTotal;
var
  LTotal: Double;
  Bookmark: TBookmark;
begin
  LTotal := 0;
  if not cdsProdutos.IsEmpty then
  begin
    cdsProdutos.DisableControls;
    Bookmark := cdsProdutos.GetBookmark;
    try
      cdsProdutos.First;
      while not cdsProdutos.Eof do
      begin
        LTotal := LTotal + cdsProdutos.FieldByName('vlr_total').AsFloat;
        cdsProdutos.Next;
      end;
    finally
      if cdsProdutos.BookmarkValid(Bookmark) then
        cdsProdutos.GotoBookmark(Bookmark);

      cdsProdutos.FreeBookmark(Bookmark);
      cdsProdutos.EnableControls;
    end;
  end;

  lblTotal.Caption := FormatFloat('R$ ,0.00', LTotal);
end;

procedure TfrmPedido.btnFecharClick(Sender: TObject);
begin
  if (messageDlg('Tem certeza que deseja sair?', mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
    Application.Terminate;
end;

end.
