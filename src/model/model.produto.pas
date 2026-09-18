unit model.produto;

interface

uses
   Core.Entidade.ModelBase
  ,Core.Entidade.CustomAttributes;

type
  [Table('produto')]
  TProduto = class(TBaseModel)
  private
    FCodigo: Integer;
    FDescricao: String;
    FPrecoVenda: Extended;
  public
    [DBField('codigo'), PK, Seq('seq_produto_codigo')]
    property Codigo:     Integer  read FCodigo     write FCodigo;
    [DBField('descricao'), NotNull]
    property Descricao:  String   read FDescricao  write FDescricao;
    [DBField('preco_venda'), NotNull]
    property PrecoVenda: Extended read FPrecoVenda write FPrecoVenda;
  end;

implementation

end.
