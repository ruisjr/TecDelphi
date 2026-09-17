unit model.pedido;

interface

uses
  System.Generics.Collections, System.SysUtils;

type
  TPedidoItem = class;

  TPedido = class
  strict private
    FNumeroPedido: Integer;
    FDataEmissao: TDate;
    FCodigoCliente: Integer;
    FItens: TObjectList<TPedidoItem>;

    function TotalPedido: Double;
  public
    constructor Create;
    destructor Destroy; override;

    //Propriedades
    property NumeroPedido:  Integer                  read FNumeroPedido  write FNumeroPedido;
    property DataEmissao:   TDate                    read FDataEmissao   write FDataEmissao;
    property CodigoCliente: Integer                  read FCodigoCliente write FCodigoCliente;
    property Itens:         TObjectList<TPedidoItem> read FItens         write FItens;
    property ValorTotal:    Double                   read TotalPedido;
  end;

  TPedidoItem = class
  strict private
    FID: Integer;
    FNumeroPedido: Integer;
    FCodigoProduto: Integer;
    FQuantidade: Double;
    FVlrUnitario: Double;
    FVlrTotal: Double;
  public
    property ID:            Integer read FID            write FID;
    property NumeroPedido:  Integer read FNumeroPedido  write FNumeroPedido;
    property CodigoProduto: Integer read FCodigoProduto write FCodigoProduto;
    property Quantidade:    Double  read FQuantidade    write FQuantidade;
    property VlrUnitario:   Double  read FVlrUnitario   write FVlrUnitario;
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

function TPedido.TotalPedido: Double;
var
  Item: TPedidoItem;
begin
  Result := 0;
  for Item in FItens do
    Result := Result + Item.VlrTotal;
end;

end.
