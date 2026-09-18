unit Servico.Base;

interface

uses
  Repositorio.Interfaces;

Type
  TServicoBase = class
  private
    FRepositorio: IRepositorio;
  public
    constructor Create(ARepositorio: IRepositorio);

    function RetornarRegistro(ACod: Integer): TObject; virtual;

    property Repositorio: IRepositorio read FRepositorio;
  end;

implementation

{ TServicoBase }

constructor TServicoBase.Create(ARepositorio: IRepositorio);
begin
  FRepositorio := ARepositorio;
end;

function TServicoBase.RetornarRegistro(ACod: Integer): TObject;
begin
  Result := Nil;
  If (ACod > 0) then
    Result := FRepositorio.RetornarRegistro(ACod);
end;

end.
