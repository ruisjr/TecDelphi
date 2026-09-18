unit Core.Database.Interfaces;

interface

uses
  {Classes de Sistema}
   Data.DB
  ,Vcl.Forms
  ,System.Rtti
  ,System.Generics.Collections
  {Classes de Negócio}
  ,Core.Database.Criteria
  ,Core.Database.DBTypes;

type
  IDBQuery = interface;

  IDBConnection = interface
    ['{738E4764-41E6-47A3-9CC7-E7D316BDD14C}']
    procedure Connect;
    procedure Disconnect;
    procedure FreeMemory;
    procedure StartTransaction;
    procedure CommitTransaction;
    procedure RollBackTransaction;

    function CreateQuery: IDBQuery;
    function IsConnected: Boolean;
    function InTransaction: Boolean;
  end;

  ICriteria = interface
    ['{008E3EC0-5650-42D8-B223-C2367ED4318A}']
    function Criteria: ICriteria;
    function AddAnd(ACriteria: string): ICriteria;
    function AddOr(ACriteria: string): ICriteria;
    function AddLike(ACriteria: string): ICriteria;
    function AddOrder(ACriteria: string): ICriteria;
    function AddGroup(ACriteria: string): ICriteria;
  end;

  IDBManager<T: class> = interface
    ['{F756E559-5E2E-4653-BE5F-CC158A63A4EC}']
    procedure Insert(pEntity: T);
    procedure Update(pEntity: T);
    procedure Delete(pEntity: T);
    procedure Execute(pSQL: string);

    function GetNextID: Integer;
    function Find: T; overload;
    function Find(Id: Integer): T; overload;
    function FindAll: TObjectList<T>; overload;
    function FindAll(Id: Integer): TObjectList<T>; overload;
    function Fields(AFields: string): IDBManager<T>;
    function Where(pCriteria: TCriterion): IDBManager<T>;
  end;

  IDBRtti<T: class> = interface
    ['{C7B611F6-D3B4-4AE4-80CF-B1BB30B3C976}']
    procedure ParseValuePK(pEntity: T; pID: Integer);

    function Fields: String;
    function FieldsUpdate: String;
    function Values: String;
    function Sequence: String;
    function TableName: String;
    function BindFormToEntity(pForm: TForm): T;
    function DataSetToEntity(pDataSet: TDataSet): T;
    function DataSetToEntityList(pDataSet: TDataSet): TObjectList<T>;
    function DictionaryFields(pEntity: TObject; pModeInsert: Boolean): TDictionary<String, Variant>;
    function DictionaryTypeFields(pEntity: TObject): TDictionary<string, TFieldType>;
  end;

  ISQLMaker<T: class> = interface
    ['{3E278934-A4A1-4945-A12B-62C9DBEB70E2}']
    procedure FreeMemory;

    function Fields(out pFields: String): ISQLMaker<T>;
    function TableName(out pTableName: String): ISQLMaker<T>;
    function Where(pCriterion: TCriterion): ISQLMaker<T>; overload;
    function WhereID(pValue: Integer): ISQLMaker<T>; overload;
    function GetNextID: String;
    function Select: String;
    function Insert: String;
    function Update: String;
    function Delete: String;
  end;

  IDBQuery = interface
    ['{16C23FD0-A2FA-498B-A566-164C7D8F964E}']
    function GetNextID(pSQL: string): Integer;
    function ToDataSet(pSQL: String): TDataSet;

    procedure FreeMemory;
    procedure FillParameter(pEntity: TObject; pModeInsert: Boolean = False);
    procedure ExecSQL(pEntity: TObject; pSQL: String); overload;
    procedure ExecSQL(pSQL: String); overload;
  end;

implementation

end.
