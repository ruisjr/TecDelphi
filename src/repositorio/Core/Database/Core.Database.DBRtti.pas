unit Core.Database.DBRtti;

interface

uses
  {Classes de Sistema}
   Data.DB
  ,Vcl.Forms
  ,Vcl.StdCtrls
  ,System.JSON
  ,System.Rtti
  ,System.Classes
  ,System.TypInfo
  ,System.Variants
  ,System.SysUtils
  ,System.Generics.Collections
  {Classes de Negócio}
  ,Core.Exceptions
  ,Core.Database.RttiHelper
  ,Core.Database.Interfaces
  ,Core.Entidade.CustomAttributes;

type
  TDBRtti<T: class> = class(TInterfacedObject, IDBRtti<T>)
  strict private
    {functions}
    function _FloatFormat(pValue: String): Currency;
    function _ValueIsNil(const pValue: TValue): Boolean;
    function _CreateObjectByName: T;
    function _GetValueProperty(pEntity: T; pProperty: TRttiProperty; pField: TField): TValue;
    function _GetComponentToValue(pComponent: TComponent): TValue;
    function _GetRttiProperty(pEntity: T; pPropertyName: String): TRttiProperty;
    function _GetRttiPropertyValue(pEntity: T; pPropertyName: String): Variant;

    {procedures}
    procedure _BindValueToProperty(pEntity: T; pProperty: TRttiProperty; pValue : TValue);
    procedure _BindValueToComponent(pComponent: TComponent; pValue: Variant);
  public
    constructor Create; reintroduce;

    {class functions}
    class function New: TDBRtti<T>;
    class function ParseValueToString(const pValue: TValue): string;

    {procedures}
    procedure ParseValuePK(pEntity: T; pID: Integer);
    procedure BindEntityToForm(pForm: TForm; pEntity: T);

    {functions}
    function Fields: String;
    function Values: String;
    function WhereID: String;
    function Sequence: String;
    function TableName: String;
    function FieldsUpdate: String;

    function BindFormToEntity(pForm: TForm): T;
    function DataSetToEntity(pDataSet: TDataSet): T;
    function DataSetToEntityList(pDataSet: TDataSet): TObjectList<T>;
    function DictionaryFields(pEntity: TObject; pModeInsert: Boolean): TDictionary<String, Variant>;
    function DictionaryTypeFields(pEntity: TObject): TDictionary<string, TFieldType>;
  end;

implementation

uses
  Core.Environment;

{ TDBRtti }

procedure TDBRtti<T>.BindEntityToForm(pForm: TForm; pEntity: T);
var
  LTypRtti: TRttiType;
  LPrpRtti: TRttiField;
  LCtxRtti: TRttiContext;
begin
  LCtxRtti := TRttiContext.Create;
  try
    LTypRtti := LCtxRtti.GetType(pForm.ClassInfo);
    for LPrpRtti in LTypRtti.GetFields do
    begin
      if LPrpRtti.Has<Bind> then
        _BindValueToComponent(pForm.FindComponent(LPrpRtti.Name), _GetRttiPropertyValue(pEntity, LPrpRtti.GetAttribute<Bind>.Field));
    end;
  finally
    LCtxRtti.Free;
  end;
end;

function TDBRtti<T>.BindFormToEntity(pForm: TForm): T;
var
  LTypRtti: TRttiType;
  LPrpRtti: TRttiField;
  LCtxRtti: TRttiContext;
begin
  Result := Self._CreateObjectByName;

  LCtxRtti := TRttiContext.Create;
  try
    LTypRtti := LCtxRtti.GetType(pForm.ClassInfo);
    for LPrpRtti in LTypRtti.GetFields do
    begin
      if LPrpRtti.Has<Bind> then
      begin
        _BindValueToProperty(Result, _GetRttiProperty(Result, LPrpRtti.GetAttribute<Bind>.Field), _GetComponentToValue(pForm.FindComponent(LPrpRtti.Name)));
      end;
    end;
  finally
    LCtxRtti.Free;
  end;
end;

constructor TDBRtti<T>.Create;
begin
  inherited Create;
end;

function TDBRtti<T>.DataSetToEntity(pDataSet: TDataSet): T;
var
  LValue: TValue;
  LField : TField;
  LCtxRtti: TRttiContext;
  LTypRtti: TRttiType;
  LprpRtti: TRttiProperty;
begin
  Result := _CreateObjectByName;

  pDataSet.First;
  while not pDataSet.Eof do
  begin
    LCtxRtti := TRttiContext.Create;
    try
      for LField in pDataSet.Fields do
      begin
        LTypRtti := LCtxRtti.GetType(TypeInfo(T));
        for LprpRtti in LTypRtti.GetProperties do
        begin
          if LPrpRtti.Has<DBField> then
          begin
            LValue := Self._GetValueProperty(TObject(TypeInfo(T)), LPrpRtti, LField);
            if LValue.IsEmpty then
              Continue;

            LPrpRtti.SetValue(Pointer(Result), LValue);
          end;
        end;
      end;
    finally
      LCtxRtti.Free;
    end;
    pDataSet.Next;
  end;
  pDataSet.First;
end;

function TDBRtti<T>.DataSetToEntityList(pDataSet: TDataSet): TObjectList<T>;
var
  LValue: TValue;
  LField: TField;
  LCtxRtti: TRttiContext;
  LPrpRtti: TRttiProperty;
begin
  Result := TObjectList<T>.Create;

  while not pDataSet.Eof do
  begin
    Result.Add(_CreateObjectByName);
    LCtxRtti := TRttiContext.Create;
    try
      for LField in pDataSet.Fields do
      begin
        for LPrpRtti in LCtxRtti.GetType(TypeInfo(T)).GetProperties do
        begin
          if LowerCase(LPrpRtti.GetAttribute<DBField>.Name) = LowerCase(LField.FieldName) then
          begin
            if LPrpRtti.Has<DBField> then
            begin
              LValue := Self._GetValueProperty(TObject(TypeInfo(T)), LPrpRtti, LField);
              if LValue.IsEmpty then
                Continue;

              LPrpRtti.SetValue(Pointer(Result[Pred(Result.Count)]), LValue);
            end;
          end;
        end;
      end;
    finally
      LCtxRtti.Free;
    end;
    pDataSet.Next;
  end;
  pDataSet.Close;
end;

function TDBRtti<T>.DictionaryFields(pEntity: TObject; pModeInsert: Boolean): TDictionary<String, Variant>;
var
  LTypRtti: TRttiType;
  LCtxRtti: TRttiContext;
  LPrpRtti: TRttiProperty;
begin
  Result := TDictionary<String, Variant>.Create;
  LCtxRtti := TRttiContext.Create;
  try
    LTypRtti := LCtxRtti.GetType(pEntity.ClassInfo);
    for LPrpRtti in LTypRtti.GetProperties do
    begin
      case LPrpRtti.PropertyType.TypeKind of
        tkInteger, tkInt64:
        begin
          if LPrpRtti.IsPrimaryKey or LPrpRtti.IsForeignKey then
          begin
            if LPrpRtti.IsSequence and
               pModeInsert         and
              (LPrpRtti.GetValue(Pointer(pEntity)).AsVariant <> null) then
              continue
            else
              Result.Add(LPrpRtti.FieldName, LPrpRtti.GetValue(Pointer(pEntity)).AsInteger);
          end
          else
            Result.Add(LPrpRtti.FieldName, LPrpRtti.GetValue(Pointer(pEntity)).AsInteger);
          end;
        tkFloat:
        begin
          if (LPrpRtti.GetValue(Pointer(pEntity)).TypeInfo = TypeInfo(TDateTime)) or
             (LPrpRtti.GetValue(Pointer(pEntity)).TypeInfo = TypeInfo(TDate)) or
             (LPrpRtti.GetValue(Pointer(pEntity)).TypeInfo = TypeInfo(TTime)) then
          begin
            if LPrpRtti.GetValue(pEntity.ClassInfo).AsExtended = 0 then
                Result.Add(LPrpRtti.FieldName, Null)
            else
            begin
              if LPrpRtti.GetValue(pEntity.ClassInfo).TypeInfo = TypeInfo(TDate) then
                Result.Add(LPrpRtti.FieldName, StrToDate(LPrpRtti.GetValue(Pointer(pEntity)).ToString))
              else if LPrpRtti.GetValue(pEntity.ClassInfo).TypeInfo = TypeInfo(TTime) then
                Result.Add(LPrpRtti.FieldName, StrToTime(LPrpRtti.GetValue(Pointer(pEntity)).ToString))
              else
                Result.Add(LPrpRtti.FieldName, DateTimeToStr(LPrpRtti.GetValue(Pointer(pEntity)).AsExtended));
            end;
          end
          else
              Result.Add(LPrpRtti.FieldName, _FloatFormat(LPrpRtti.GetValue(Pointer(pEntity)).ToString));
        end;
        tkWChar,
        tkLString,
        tkWString,
        tkUString,
        tkString:
          Result.Add(LPrpRtti.FieldName, LPrpRtti.GetValue(Pointer(pEntity)).AsString);
        tkVariant:
          Result.Add(LPrpRtti.FieldName, LPrpRtti.GetValue(Pointer(pEntity)).AsVariant);
        tkClass: ;
        tkEnumeration:
        begin
          if (LPrpRtti.GetValue(Pointer(pEntity)).TypeInfo.Name = 'Boolean') then
            Result.Add(LPrpRtti.fieldname, LPrpRtti.GetValue(Pointer(pEntity)).AsBoolean)
        end;
      else
        Result.Add(LPrpRtti.FieldName, LPrpRtti.GetValue(Pointer(pEntity)).AsString);
      end;
    end;
  finally
    LCtxRtti.Free;
  end;
end;

function TDBRtti<T>.DictionaryTypeFields(pEntity: TObject): TDictionary<string, TFieldType>;
var
  FCtxRtti: TRttiContext;
  FTypRtti: TRttiType;
  FPrpRtti: TRttiProperty;
begin
  Result := TDictionary<string, TFieldType>.Create;
  FCtxRtti := TRttiContext.Create;
  try
    FTypRtti := FCtxRtti.GetType(pEntity.ClassInfo);
    for FPrpRtti in FTypRtti.GetProperties do
    begin
      if Self._ValueIsNil(FPrpRtti.GetValue(Pointer(pEntity))) then
        Continue;

      case FPrpRtti.PropertyType.TypeKind of
        tkInteger, tkInt64:
          Result.Add(FPrpRtti.FieldName, TFieldType.ftInteger);
        tkFloat:
        begin
          if FPrpRtti.GetValue(Pointer(pEntity)).TypeInfo = TypeInfo(TDateTime) then
            Result.Add(FPrpRtti.FieldName, TFieldType.ftDateTime)
          else if FPrpRtti.GetValue(Pointer(pEntity)).TypeInfo = TypeInfo(TDate) then
            Result.Add(FPrpRtti.FieldName, TFieldType.ftDate)
          else if FPrpRtti.GetValue(Pointer(pEntity)).TypeInfo = TypeInfo(TTime) then
            Result.Add(FPrpRtti.FieldName, TFieldType.ftTime)
          else
            Result.Add(FPrpRtti.FieldName, TFieldType.ftFloat)
        end;
        tkWChar,
        tkLString,
        tkWString,
        tkUString:
          Result.Add(FPrpRtti.FieldName, TFieldType.ftString);
        tkEnumeration:
          if (FPrpRtti.GetValue(Pointer(pEntity)).TypeInfo = TypeInfo(Boolean)) then
            Result.Add(FPrpRtti.FieldName, TFieldType.ftBoolean);
        tkClass:
        begin
          if (FPrpRtti.PropertyType.Handle = TypeInfo(TJSONArray)) or (FPrpRtti.PropertyType.Handle = TypeInfo(TJSONObject)) then
            Result.Add(FPrpRtti.FieldName, TFieldType.ftOraClob)
          else if (FPrpRtti.PropertyType.Handle = TypeInfo(TMemoryStream)) then
            Result.Add(FPrpRtti.FieldName, TFieldType.ftBlob)
        end;
      end;
    end;
  finally
    FCtxRtti.Free;
  end;
end;

function TDBRtti<T>.Fields: String;
var
  LFields: TStringList;
  LCtxRtti: TRttiContext;
  LTypRtti: TRttiType;
  LPrpRtti: TRttiProperty;
begin
  LCtxRtti := TRttiContext.Create;
  try
    LFields := TStringList.Create;
    try
      LFields.Delimiter := ',';
      LFields.StrictDelimiter := True;

      LTypRtti := LCtxRtti.GetType(TObject(TypeInfo(T)));
      for LPrpRtti in LTypRtti.GetProperties do
      begin
        if LPrpRtti.Has<DBField> then
          LFields.Add(LPrpRtti.GetAttribute<DBField>.Name);
      end;
      Result := LFields.DelimitedText;
    finally
      FreeAndNil(LFields);
    end;
  finally
    LCtxRtti.Free;
  end;
end;

function TDBRtti<T>.FieldsUpdate: String;
var
  LFields: TStringList;
  LTypRtti: TRttiType;
  LCtxRtti: TRttiContext;
  LPrpRtti: TRttiProperty;
begin
  LCtxRtti := TRttiContext.Create;
  try
    LFields := TStringList.Create;
    try
      LFields.Delimiter := ',';
      LFields.StrictDelimiter := True;

      LTypRtti := LCtxRtti.GetType(T.ClassInfo);
      for LPrpRtti in LTypRtti.GetProperties do
      begin
        if (LPrpRtti.Has<DBField>) then
          LFields.Add(Format('%s = :%s', [LPrpRtti.FieldName, LPrpRtti.FieldName]));
      end;
      Result := LFields.DelimitedText;
    finally
      FreeAndNil(LFields);
    end;
  finally
    LCtxRtti.Free;
  end;
end;

class function TDBRtti<T>.New: TDBRtti<T>;
begin
  Result := Self.Create;
end;

procedure TDBRtti<T>.ParseValuePK(pEntity: T; pID: Integer);
var
  LTypRtti: TRttiType;
  LPrpRtti: TRttiProperty;
  LCtxRtti: TRttiContext;
begin
  LCtxRtti := TRttiContext.Create;
  try
    LTypRtti := LCtxRtti.GetType(pEntity.Classtype);
    for LPrpRtti in LTypRtti.GetProperties do
    begin
      if LPrpRtti.IsPrimaryKey then
      begin
        case LPrpRtti.PropertyType.TypeKind of
         tkInteger, tkInt64:
           LPrpRtti.SetValue(Pointer(pEntity), pID);
        end;
      end;
    end;
  finally
    LCtxRtti.Free;
  end;
end;

class function TDBRtti<T>.ParseValueToString(const pValue: TValue): string;
begin
  case pValue.Kind of
    tkUnknown: ;
    tkInteger:
      Result := pValue.ToString;
    tkChar: ;
    tkEnumeration: ;
    tkFloat:
    begin
      if (pValue.TypeInfo    = TypeInfo(TDate))
         or (pValue.TypeInfo = TypeInfo(TTime))
         or (pValue.TypeInfo = TypeInfo(TDateTime)) then
      begin
        Result := pValue.ToString;
      end
      else
        pValue.ToString;
    end;
    tkSet: ;
    tkClass: ;
    tkMethod: ;
    tkString, tkWChar, tkLString, tkWString, tkVariant, tkUString:
      Result := pValue.AsString;
    tkArray: ;
    tkRecord: ;
    tkInterface: ;
    tkInt64:
      Result := IntToStr(pValue.Cast<Int64>.AsInt64);
    tkDynArray: ;
    tkClassRef: ;
    tkPointer: ;
    tkProcedure: ;
  else
    Result := VarToStr(pValue.AsVariant);
  end;
end;

function TDBRtti<T>.Sequence: String;
var
  LTypRtti: TRttiType;
  LPrpRtti: TRttiProperty;
  LCtxRtti: TRttiContext;
  LAtributo: TCustomAttribute;
begin
  LCtxRtti := TRttiContext.Create;
  try
    LTypRtti := LCtxRtti.GetType(TypeInfo(T));
    for LPrpRtti in LTypRtti.GetProperties do
    begin
      for LAtributo in LPrpRtti.GetAttributes do
      begin
        if LAtributo is Seq then
          Exit(QuotedStr(LPrpRtti.Sequence));
      end;
    end;
  finally
    LCtxRtti.Free;
  end;
end;

function TDBRtti<T>.TableName: String;
var
  LTypRtti: TRttiType;
  LCtxRtti: TRttiContext;
begin
  Result := EmptyStr;
  LCtxRtti := TRttiContext.Create;
  try
    LTypRtti := LCtxRtti.GetType(TypeInfo(T));
    if LTypRtti.Has<Table> then
      Result := LTypRtti.GetAttribute<Table>.Name;
  finally
    LCtxRtti.Free;
  end;
end;

function TDBRtti<T>.Values: String;
var
  LSQL: TStringBuilder;
  LCtxRtti: TRttiContext;
  LTypRtti: TRttiType;
  LPrpRtti: TRttiProperty;
begin
  LCtxRtti := TRttiContext.Create;
  try
    LSQL := TStringBuilder.Create;
    try
      LTypRtti := LCtxRtti.GetType(T.Classinfo);
      for LPrpRtti in LTypRtti.GetProperties do
      begin
        if LPrpRtti.IsIgnore then
          Continue;

        if LPrpRtti.IsSequence then
        begin
          LSQL.Append(Format('nextval(%s) ', [QuotedStr(LPrpRtti.Sequence)]));
          Continue;
        end;

        if (LSQL.Length > 0) then
          LSQL.Append(Format(',:%s', [LPrpRtti.FieldName]))
        else
          LSQL.Append(Format(':%s', [LPrpRtti.FieldName]))
      end;

      Result := LSQL.ToString;
    finally
      LSQL.clear;
      FreeAndNil(LSQL);
    end;
  finally
    LCtxRtti.Free;
  end;
end;

function TDBRtti<T>.WhereID: String;
var
  LTypRtti: TRttiType;
  LPrpRtti: TRttiProperty;
  LCtxRtti: TRttiContext;
  LAtributo: TCustomAttribute;
begin
  LCtxRtti := TRttiContext.Create;
  try
    LTypRtti := LCtxRtti.GetType(TypeInfo(T));
    for LPrpRtti in LTypRtti.GetProperties do
    begin
      for LAtributo in LPrpRtti.GetAttributes do
      begin
        if LAtributo is PK then
          Exit(LPrpRtti.FieldName);
      end;
    end;
  finally
    LCtxRtti.Free;
  end;
end;

procedure TDBRtti<T>._BindValueToComponent(pComponent: TComponent; pValue: Variant);
begin
  if VarIsNull(pValue) then
      exit;

  if pComponent is TEdit then
      (pComponent as TEdit).Text := pValue;
  if pComponent is TLabel then
      (pComponent as TLabel).Caption := pValue;
end;

procedure TDBRtti<T>._BindValueToProperty(pEntity: T; pProperty: TRttiProperty; pValue: TValue);
begin
  if not Assigned(pProperty) then
    Exit;

  case pProperty.PropertyType.TypeKind of
    tkUnknown: ;
    tkInteger:
      pProperty.SetValue(Pointer(pEntity), StrToInt(pValue.ToString));
    tkChar: ;
    tkEnumeration: ;
    tkFloat:
    begin
      if (pValue.TypeInfo    = TypeInfo(TDate))
         or (pValue.TypeInfo = TypeInfo(TTime))
         or (pValue.TypeInfo = TypeInfo(TDateTime)) then
      begin
        pProperty.SetValue(Pointer(pEntity), StrToDateTime(pValue.ToString))
      end
      else
        pProperty.SetValue(Pointer(pEntity), StrToFloat(pValue.ToString));
    end;
    tkSet: ;
    tkClass: ;
    tkMethod: ;
    tkString, tkWChar, tkLString, tkWString, tkVariant, tkUString:
      pProperty.SetValue(Pointer(pEntity), pValue);
    tkArray: ;
    tkRecord: ;
    tkInterface: ;
    tkInt64:
      pProperty.SetValue(Pointer(pEntity), pValue.Cast<Int64>);
    tkDynArray: ;
    tkClassRef: ;
    tkPointer: ;
    tkProcedure: ;
  else
    pProperty.SetValue(Pointer(pEntity), pValue);
  end;
end;

function TDBRtti<T>._CreateObjectByName: T;
var
  LType: TRttiInstanceType;
  LContext: TRttiContext;
  LMethod: TRttiMethod;
begin
  LContext := TRttiContext.Create;
  try
    LType := LContext.GetType(TypeInfo(T)) as TRttiInstanceType;
    LMethod := LType.GetMethod('Create');

    if Assigned(LMethod) then
      Result := LMethod.Invoke(LType.MetaclassType, []).AsObject as T
    else
      raise Exception.Create('Construtor "Create" sem parâmetros não encontrado para ' + LType.Name);
  finally
    LContext.Free;
  end;
end;

function TDBRtti<T>._FloatFormat(pValue: String): Currency;
begin
  while Pos('.', pValue) > 0 do
    delete(pValue,Pos('.', pValue), 1);

  Result := StrToCurr(pValue);
end;

function TDBRtti<T>._GetComponentToValue(pComponent: TComponent): TValue;
begin
  if pComponent is TEdit then
    Result := TValue.FromVariant((pComponent as TEdit).Text);

  if pComponent is TLabel then
    Result := TValue.FromVariant((pComponent as TLabel).Caption);
end;

function TDBRtti<T>._GetRttiProperty(pEntity: T; pPropertyName: String): TRttiProperty;
var
  LTypRttiEntity: TRttiType;
  LCtxRttiEntity: TRttiContext;
begin
  LCtxRttiEntity := TRttiContext.Create;
  try
    LTypRttiEntity := LCtxRttiEntity.GetType(pEntity.ClassInfo);
    Result := LTypRttiEntity.GetProperty(pPropertyName);

    if not Assigned(Result) then
      Result := LTypRttiEntity.GetPropertyFromAttribute<DBField>(pPropertyName);

    {if not Assigned(Result) then
      raise EDBRttiError.Create('Property ' + pPropertyName + ' not found!');}
  finally
    LCtxRttiEntity.Free;
  end;
end;

function TDBRtti<T>._GetRttiPropertyValue(pEntity: T; pPropertyName: String): Variant;
var
  LProRtti: TRttiProperty;
begin
  LProRtti := _GetRttiProperty(pEntity, pPropertyName);
  if not Assigned(LProRtti) then
  begin
    Result := Null;
    Exit;
  end;

  Result := LProRtti.GetValue(Pointer(pEntity)).AsVariant;
end;

function TDBRtti<T>._GetValueProperty(pEntity: T; pProperty: TRttiProperty; pField: TField): TValue;
begin
  Result := nil;
  if pField.FieldName = 'data' then
    Result := nil;
  try
    if LowerCase(pProperty.GetAttribute<DBField>.Name) = LowerCase(pField.FieldName) then
    begin
      pField.DisplayLabel := pProperty.DisplayName;
      case pProperty.PropertyType.TypeKind of
        tkUnknown, tkString, tkWChar, tkLString, tkWString, tkUString:
          Result := pField.AsString;
        tkInteger, tkInt64:
          Result := pField.AsInteger;
        tkChar: ;
        tkEnumeration:
        begin
          if (pProperty.GetValue(Pointer(pEntity)).TypeInfo = TypeInfo(Boolean)) then
            Result := pField.AsBoolean
          else
            Result := pField.AsString;
        end;
        tkFloat:
        begin
          if ((pProperty.GetValue(Pointer(pEntity)).TypeInfo = TypeInfo(TDate)) or
              (pProperty.GetValue(Pointer(pEntity)).TypeInfo = TypeInfo(TDateTime))) then
            Result := pField.AsDateTime
          else
            Result := pField.AsFloat;
        end;
        tkSet: ;
        tkClass: ;
        tkMethod: ;
        tkVariant: ;
        tkArray: ;
        tkRecord: ;
        tkInterface: ;
        tkDynArray: ;
        tkClassRef: ;
        tkPointer: ;
        tkProcedure: ;
      end;
    end;
  except
    on e: exception do
      raise Exception.Create('Não foi posível obter o valor da propriedade no método _GetValueProperty.');
  end;
end;

function TDBRtti<T>._ValueIsNil(const pValue: TValue): Boolean;
begin
  Result := False;
  case pValue.Kind of
    tkString, tkChar, tkWChar,
    tkLString, tkWString, tkUString:
      Result := Pointer(pValue.AsString) = nil;
    tkInteger, tkInt64:
      Result := Pointer(pValue.AsInteger) = nil;
    tkFloat:
    begin
      if pValue.TypeInfo = TypeInfo(TDateTime) then
        Result := Pointer(Trunc(pValue.asExtended)) = nil;
    end;
    tkClass:
      Result := Pointer(pValue.AsObject) = nil
  else
    Result := True;
  end;
end;

end.
