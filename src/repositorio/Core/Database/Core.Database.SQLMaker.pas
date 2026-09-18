unit Core.Database.SQLMaker;

interface

uses
  {Classes de Sistema}
   System.SysUtils
  {Classes de Negócio}
  ,Core.Database.DBRtti
  ,Core.Database.Criteria
  ,Core.Database.Interfaces;

type
  TSQLMaker<T: class> = class(TInterfacedObject, ISQLMaker<T>)
  strict private
    FSQL: TStringBuilder;
    FSQLCriteria: TStringBuilder;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;

    {class functions}
    class function New: ISQLMaker<T>;

    {functions}
    function Fields(out pFields: String): ISQLMaker<T>;
    function TableName(out pTableName: String): ISQLMaker<T>;
    function Where(pCriterion: TCriterion): ISQLMaker<T>; overload;
    function WhereID(pValue: Integer): ISQLMaker<T>; overload;
    function GetNextID: String;

    function Select: String;
    function Insert: String;
    function Delete: String;
    function Update: String;

    {procedures}
    procedure FreeMemory;
  end;

implementation

{TSQLMaker}

constructor TSQLMaker<T>.Create;
begin
  FSQL := TStringBuilder.Create;
  FSQLCriteria := TStringBuilder.Create;
  inherited Create;
end;

function TSQLMaker<T>.Delete: String;
begin
  FSQL.AppendLine(Format('DELETE FROM %s', [TDBRtti<T>.New.TableName]));
  if (FSQLCriteria.Length > 0) then
    FSQL.Append('WHERE ' + FSQLCriteria.ToString);

  Result := FSQL.ToString;
end;

destructor TSQLMaker<T>.Destroy;
begin
  Self.FreeMemory;
  inherited;
end;

function TSQLMaker<T>.Fields(out pFields: String): ISQLMaker<T>;
begin
  Result := Self;
  pFields := TDBRtti<T>.New.Fields;
end;

procedure TSQLMaker<T>.FreeMemory;
begin
  FSQL.Clear;
  FSQLCriteria.Clear;

  FreeAndNil(FSQL);
  FreeAndNil(FSQLCriteria);
end;

function TSQLMaker<T>.GetNextID: String;
begin
  FSQL.AppendLine(Format('SELECT NEXT VALUE FOR %s FROM RDB$DATABASE', [TDBRtti<T>.New.Sequence]));
  Result := FSQL.ToString;
end;

function TSQLMaker<T>.Insert: String;
begin
  FSQL.AppendLine(Format('INSERT INTO %s', [TDBRtti<T>.New.TableName]));
  FSQL.AppendLine(Format('(%s)', [TDBRtti<T>.New.Fields]));
  FSQL.Append(Format('VALUES(%s)', [TDBRtti<T>.New.Values]));

  Result := FSQL.ToString;
end;

class function TSQLMaker<T>.New: ISQLMaker<T>;
begin
  Result := Self.Create;
end;

function TSQLMaker<T>.Select: String;
var
  LTableName: String;
begin
  FSQL.AppendLine('SELECT ');
  FSQL.AppendLine(TDBRtti<T>.New.Fields);

  LTableName := TDBRtti<T>.New.TableName;
  if not LTableName.IsEmpty then
  begin
    FSQL.AppendLine(' FROM ');
    FSQL.AppendLine(LTableName);
  end;
  if (FSQLCriteria.Length > 0) then
    FSQL.Append('WHERE ' + FSQLCriteria.ToString);

  Result := FSQL.ToString;
end;

function TSQLMaker<T>.TableName(out pTableName: String): ISQLMaker<T>;
begin
  Result := Self;
  pTableName := TDBRtti<T>.New.TableName;
end;

function TSQLMaker<T>.Update: String;
begin
  FSQL.AppendLine(Format('UPDATE %s SET', [TDBRtti<T>.New.TableName]));
  FSQL.AppendLine(Format('%s', [TDBRtti<T>.New.FieldsUpdate]));
  if (FSQLCriteria.Length > 0) then
    FSQL.Append('WHERE ' + FSQLCriteria.ToString);

  Result := FSQL.ToString;
end;

function TSQLMaker<T>.WhereID(pValue: Integer): ISQLMaker<T>;
begin
  Result := Self;
  FSQLCriteria.Append(Format('%s = %d', [TDBRtti<T>.New.WhereID, pValue]));
end;

function TSQLMaker<T>.Where(pCriterion: TCriterion): ISQLMaker<T>;
begin
  Result := Self;
  if pCriterion.Field.IsEmpty then
    Exit;

  if FSQLCriteria.Length > 0 then
    FSQLCriteria.Append(Format('AND %s %s %s', [pCriterion.Field, pCriterion.&Operator, TDBRtti<T>.ParseValueToString(pCriterion.Value)]))
  else
    FSQLCriteria.Append(Format('%s %s %s', [pCriterion.Field, pCriterion.&operator, TDBRtti<T>.ParseValueToString(pCriterion.Value)]))
end;

end.
