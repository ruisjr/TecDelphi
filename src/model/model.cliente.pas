unit model.cliente;

interface

uses
   Core.Entidade.ModelBase
  ,Core.Entidade.CustomAttributes;

type
  [Table('cliente')]
  TCliente = class(TBaseModel)
    private
      FCodigo: Integer;
      FNome: String;
      FCidade: String;
      FUF: String;
    public
      [DBField('codigo'), PK, Seq('seq_cliente_codigo')]
      property Codigo: Integer read FCodigo write FCodigo;
      [DBField('nome'), NotNull]
      property Nome:   String  read FNome   write FNome;
      [DBField('cidade'), NotNull]
      property Cidade: String  read FCidade write FCidade;
      [DBField('uf'), NotNull]
      property UF:     String  read FUF     write FUF;
  end;

implementation

end.
