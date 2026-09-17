unit model.produto;

interface

type
  TProduto = class
  private
    FCodigo: Integer;
    FDescricao: String;
    FPrecoVenda: Extended;
  public
    property Codigo:     Integer  read FCodigo     write FCodigo;
    property Descricao:  String   read FDescricao  write FDescricao;
    property PrecoVenda: Extended read FPrecoVenda write FPrecoVenda;
  end;

implementation

end.
