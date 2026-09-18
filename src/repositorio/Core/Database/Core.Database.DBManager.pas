unit Core.Database.DBManager;

interface

uses
  {Classes de Sistema}
   System.Rtti
  ,System.Classes
  ,System.SysUtils
  ,System.Generics.Collections
  {Classes de Negócio}
  ,Core.Database.DBRtti
  ,Core.Database.DBTypes
  ,Core.Database.Criteria
  ,Core.Database.SQLMaker
  ,Core.Database.Interfaces
  ,Core.Database.DBQueryFDAdapter
  ,Core.Entidade.CustomAttributes;

type
  TDBManager<T: class> = class(TInterfacedObject, IDBManager<T>)
  strict private
    FFields: String;
    FCriterion: TCriterion;
    FDBConnection: IDBConnection;
  public
    constructor Create(ADBConnection: IDBConnection); reintroduce;
    destructor Destroy; override;

    {procedures}
    procedure Insert(pEntity: T);
    procedure Update(pEntity: T);
    procedure Delete(pEntity: T);
    procedure Execute(pSQL: string);

    {functions}
    function Fields(AFields: string): IDBManager<T>;
    function Where(pCriteria: TCriterion): IDBManager<T>;

    function GetNextID: Integer;
    function Find(Id: Integer): T; overload;
    function Find: T; overload;
    function FindAll: TObjectList<T>;
  end;

implementation

uses
  {Classes de Sistema}
   Data.DB
  {Classes de Negócio}
  ,Model.Pedido;

{ TDBManager }

constructor TDBManager<T>.Create(ADBConnection: IDBConnection);
begin
  FDBConnection := ADBConnection;
  FDBConnection.Connect;
  inherited Create;
end;

procedure TDBManager<T>.Delete(pEntity: T);
var
  LQuery: IDBQuery;
begin
  LQuery := FDBConnection.CreateQuery;
  try
    LQuery.ExecSQL(pEntity, TSQLMaker<T>.New.Where(FCriterion).Delete)
  finally
    LQuery.FreeMemory;
  end;
end;

destructor TDBManager<T>.Destroy;
begin
  inherited;
end;

procedure TDBManager<T>.Execute(pSQL: string);
var
  LQuery: IDBQuery;
begin
  LQuery := FDBConnection.CreateQuery;
  try
    LQuery.ExecSQL(pSQL);
  finally
    LQuery.FreeMemory;
  end;
end;

function TDBManager<T>.Fields(AFields: string): IDBManager<T>;
begin
  FFields := AFields;
end;

function TDBManager<T>.Find(Id: Integer): T;
var
  LQuery: IDBQuery;
  LDataSet: TDataSet;
begin
  LQuery := FDBConnection.CreateQuery;
  try
    LDataSet := LQuery.ToDataSet(TSQLMaker<T>.New.WhereID(Id).Select);
    Result := TDBRtti<T>.New.DataSetToEntity(LDataSet);
  finally
    LQuery.FreeMemory;
  end;
end;

function TDBManager<T>.Find: T;
var
  LQuery: IDBQuery;
  LDataSet: TDataSet;
begin
  LQuery := FDBConnection.CreateQuery;
  try
    LDataSet := LQuery.ToDataSet(TSQLMaker<T>.New.Where(FCriterion).Select);
    Result := TDBRtti<T>.New.DataSetToEntity(LDataSet);
  finally
    LQuery.FreeMemory;
  end;
end;

function TDBManager<T>.FindAll: TObjectList<T>;
var
  LQuery: IDBQuery;
  LDataSet: TDataSet;
begin
  LQuery := FDBConnection.CreateQuery;
  try
    LDataSet := LQuery.ToDataSet(TSQLMaker<T>.New.Where(FCriterion).Select);
    Result := TDBRtti<T>.New.DataSetToEntityList(LDataSet);
  finally
    LQuery.FreeMemory;
  end;
end;

function TDBManager<T>.GetNextID: Integer;
var
  LQuery: IDBQuery;
begin
  LQuery := FDBConnection.CreateQuery;
  try
    Result := LQuery.GetNextID(TSQLMaker<T>.New.GetNextID)
  finally
    LQuery.FreeMemory;
  end;
end;

procedure TDBManager<T>.Insert(pEntity: T);
var
  LQuery: IDBQuery;
begin
  LQuery := FDBConnection.CreateQuery;
  try
    TDBRtti<T>.New.ParseValuePK(pEntity, Self.GetNextID);
    LQuery.ExecSQL(pEntity, TSQLMaker<T>.New.Insert)
  finally
    LQuery.FreeMemory;
  end;
end;

procedure TDBManager<T>.Update(pEntity: T);
var
  LQuery: IDBQuery;
begin
  LQuery := FDBConnection.CreateQuery;
  try
    LQuery.ExecSQL(pEntity, TSQLMaker<T>.New.Where(FCriterion).Update);
  finally
    LQuery.FreeMemory;
  end;
end;

function TDBManager<T>.Where(pCriteria: TCriterion): IDBManager<T>;
begin
  Result := Self;
  FCriterion := pCriteria;
end;

end.
