unit model.pedido;

interface

uses
  {Classes de Sistema}
   System.Generics.Collections
  ,System.SysUtils
  {Classes de Negócio}
  ,Core.Entidade.ModelBase
  ,Core.Entidade.CustomAttributes;

type
  TPedidoItem = class;

  [Table('pedido')]
  TPedido = class
  strict private
    FNumeroPedido: Integer;
    FDataEmissao: TDate;
    FCodigoCliente: Integer;
    FTotalPedido: Double;
    FItens: TObjectList<TPedidoItem>;
  public
    constructor Create;
    destructor Destroy; override;

    //Propriedades
    [DBField('numero_pedido'), PK, Seq('seq_pedido_numero_pedido')]
    property NumeroPedido:  Integer                  read FNumeroPedido  write FNumeroPedido;
    [DBField('data_emissao'), NotNull]
    property DataEmissao:   TDate                    read FDataEmissao   write FDataEmissao;
    [DBField('codigo_cliente'), NotNull]
    property CodigoCliente: Integer                  read FCodigoCliente write FCodigoCliente;
    [DBField('valor_total'), NotNull]
    property ValorTotal:    Double                   read FTotalPedido   write FTotalPedido;
    property Itens:         TObjectList<TPedidoItem> read FItens         write FItens;
  end;

  [Table('pedido_item')]
  TPedidoItem = class
  strict private
    FID: Integer;
    FNumeroPedido: Integer;
    FCodigoProduto: Integer;
    FQuantidade: Double;
    FVlrUnitario: Double;
    FVlrTotal: Double;
  public
    [DBField('id'), PK, Seq('seq_pedido_item_id')]
    property ID:            Integer read FID            write FID;
    [DBField('numero_pedido'), NotNull]
    property NumeroPedido:  Integer read FNumeroPedido  write FNumeroPedido;
    [DBField('codigo_produto'), NotNull]
    property CodigoProduto: Integer read FCodigoProduto write FCodigoProduto;
    [DBField('quantidade'), NotNull]
    property Quantidade:    Double  read FQuantidade    write FQuantidade;
    [DBField('vlr_unitario'), NotNull]
    property VlrUnitario:   Double  read FVlrUnitario   write FVlrUnitario;
    [DBField('vlr_total'), NotNull]
    property VlrTotal:      Double  read FVlrTotal      write FVlrTotal;
  end;

implementation


{ TPedido }

constructor TPedido.Create;
begin
  FItens := TObjectList<TPedidoItem>.Create(True);
  FDataEmissao := Now;
end;

destructor TPedido.Destroy;
begin
  FreeAndNil(FItens);
  inherited;
end;

end.
