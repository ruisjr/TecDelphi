unit Repositorio.Interfaces;

interface

uses
  System.Generics.Collections;

type
  IRepositorio = interface
    ['{5DAFC80E-5979-47F5-B520-AA61F3C7F43C}']
    function Salvar(AModel: TObject): Boolean;
    function Remover(AModel: TObject): Boolean;
    function RetornarRegistro(ACod: Integer): TObject;
  end;

implementation

end.
