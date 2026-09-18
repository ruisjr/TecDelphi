unit Core.Exceptions;

interface

uses
  System.SysUtils;

type
  ESQLMakerError = class(Exception);
  EDataBaseError = class(Exception);
  EDBRttiError   = class(Exception);

implementation

end.
