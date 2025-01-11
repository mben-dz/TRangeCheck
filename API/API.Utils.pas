unit API.Utils;

interface

uses
  System.SysUtils,
  System.Types,
  System.Generics.Defaults;

type
  TRange<T> = class
  public
    // Check if a value is within the range [aMin, aMax] using a custom comparer
    class function IsIn(const aValue, aMin, aMax: T; const aComparer: IComparer<T>): Boolean; overload; static;

    // Check if a value is within the range [aMin, aMax] using the default comparer
    class function IsIn(const aValue, aMin, aMax: T): Boolean; overload; static;
  end;

implementation

{ TRange<T> }

class function TRange<T>.IsIn(const aValue, aMin, aMax: T; const aComparer: IComparer<T>): Boolean;
begin
  Result := (aComparer.Compare(aValue, aMin) >= 0) and (aComparer.Compare(aValue, aMax) <= 0);
end;

class function TRange<T>.IsIn(const aValue, aMin, aMax: T): Boolean;
begin
  Result := IsIn(aValue, aMin, aMax, TComparer<T>.Default);
end;

end.
