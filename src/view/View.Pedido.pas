unit View.Pedido;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls,
  Data.DB, Vcl.Grids, Vcl.DBGrids;

type
  TfrmPedido = class(TForm)
    grpDadosPedido: TGroupBox;
    edtCodigo: TEdit;
    Label1: TLabel;
    DateTimePicker1: TDateTimePicker;
    Label5: TLabel;
    grpDadosCliente: TGroupBox;
    edtNome: TEdit;
    edtCidade: TEdit;
    edtUF: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Panel1: TPanel;
    lblClienteCod: TLabel;
    edtClienteCod: TEdit;
    pnlPedidoBotoes: TPanel;
    grdPedidoItens: TDBGrid;
    Button1: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPedido: TfrmPedido;

implementation

{$R *.dfm}

end.
