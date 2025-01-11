# TRange<T>   

Delphi **TRange<T>** Checker (clean design, easy to extend comparers)  
 ----  
 **Output Result:** 
 ![](https://github.com/mben-dz/TRangeCheck/blob/main/OutputResults.jpg)  
 ---  
# TRange<T> for Delphi

A simple, generic, and extensible range checker for Delphi, supporting numeric, date, and other types. This class allows you to check whether a given value lies within a specified range, with support for both inclusive and exclusive ranges.

## Features

- **Generic class** supporting multiple types (`Integer`, `Double`, `TDateTime`, etc.).
- Configurable for **inclusive** or **exclusive** ranges.
- Easy to extend for custom types or comparison logic.
- Clean and readable API.

## Installation

Clone or download the `API.Utils.pas` file and add it to your Delphi project.

```bash
git clone https://github.com/mben-dz/TRangeCheck.git
```

## Usage Example

Here’s how to use `TRange<T>` to check values in different types of ranges:

### TRange<T> Static Class

```pascal
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
```
to put this  Super class in test i build a new console project:  
this unit here act as my objects:  
```pascal
unit API.Objects.Comparer;

interface
uses
  System.Types,
  System.Generics.Defaults;

type
  ICustomRecord = interface; // Forward
  ICustomRecordUpdate = interface
    function Edit(const aName: string; const aValue: Integer): ICustomRecord;
  end;
  ICustomRecord = interface
    function GetName: string;
    function GetValue: Integer;
    function GetCustomRecordUpdate: ICustomRecordUpdate;

    property Name: string read GetName;
    property Value: Integer read GetValue;

    property New: ICustomRecordUpdate read GetCustomRecordUpdate;
  end;

  IProduct = interface; // Forward
  IProductUpdate = interface
    function Edit(const aID: Integer; const aPrice: Currency): IProduct;
  end;
  IProduct = interface
    function GetID: Integer;
    function GetPrice: Currency;
    function GetIProductUpdate: IProductUpdate;

    property ID: Integer read GetID;
    property Price: Currency read GetPrice;

    property New: IProductUpdate read GetIProductUpdate;
  end;

  IClient = interface; // Forward
  IClientUpdate = interface
    function Edit(const aName: string; const aAge: Integer): IClient;
  end;
  IClient = interface
    function GetName: string;
    function GetAge: Integer;
    function GetIClientUpdate: IClientUpdate;

    property Name: string read GetName;
    property Age: Integer read GetAge;

    property New: IClientUpdate read GetIClientUpdate;
  end;

// Compare Custom Records <Helper function>
function CompareCustomRecord(const R1, R2: ICustomRecord): Integer;

// Compare Products by thier Prices <Helper function>
function CompareProductByPrice(const P1, P2: IProduct): Integer;

// Compare Clients by thier Ages <Helper function>
function CompareClientByAge(const C1, C2: IClient): Integer;

// points comparison <Helper functions>
function ComparePoints(const P1, P2: TPoint): Integer; overload;
function ComparePoints(const P1, P2: TPointF): Integer; overload;

// Returns a custom comparer for TPoint
function PointComparer: IComparer<TPoint>;

function GetTCustomRecord(const aName: string; aValue: Integer): ICustomRecord;
function GetTProduct(aID: Integer; aPrice: Currency): IProduct;
function GetTClient(const aName: string; aAge: Integer): IClient;

implementation
uses
  System.Math;

type
  TCustomRecord = class(TInterfacedObject, ICustomRecord, ICustomRecordUpdate)
  strict private
    fName: string;
    fValue: Integer;
    function GetName: string;
    function GetValue: Integer;
    function GetCustomRecordupdate: ICustomRecordUpdate;
    function Edit(const aName: string; const aValue: Integer): ICustomRecord;
  public
    constructor Create(const aName: string; aValue: Integer);
  end;

  TProduct = class(TInterfacedObject, IProduct, IProductUpdate)
  private
    fID: Integer;
    fPrice: Currency;
    function GetID: Integer;
    function GetPrice: Currency;
    function GetIProductUpdate: IProductUpdate;
    function Edit(const aID: Integer; const aPrice: Currency): IProduct;
  public
    constructor Create(aID: Integer; aPrice: Currency);
  end;

  TClient = class(TInterfacedObject, IClient, IClientUpdate)
  private
    fName: string;
    fAge: Integer;
    function GetName: string;
    function GetAge: Integer;
    function GetIClientUpdate: IClientUpdate;
    function Edit(const aName: string; const aAge: Integer): IClient;
  public
    constructor Create(const aName: string; aAge: Integer);
  end;

function GetTCustomRecord(const aName: string; aValue: Integer): ICustomRecord;
begin
  Result := TCustomRecord.Create(aName, aValue);
end;

function GetTProduct(aID: Integer; aPrice: Currency): IProduct;
begin
  Result := TProduct.Create(aID, aPrice);
end;

function GetTClient(const aName: string; aAge: Integer): IClient;
begin
  Result := TClient.Create(aName, aAge);
end;

{$REGION '  Points Comparer & Helper Functions .. '}
function ComparePoints(const P1, P2: TPoint): Integer;
begin
  if P1.X < P2.X then
    Exit(-1)
  else if P1.X > P2.X then
    Exit(1);

  if P1.Y < P2.Y then
    Exit(-1)
  else if P1.Y > P2.Y then
    Exit(1);

  Result := 0; // Points are equal
end;

function ComparePoints(const P1, P2: TPointF): Integer;
begin
  if P1.X <> P2.X then
    Result := Sign(P1.X - P2.X)
  else
    Result := Sign(P1.Y - P2.Y);
end;

function PointComparer: IComparer<TPoint>;
begin
  Result := TComparer<TPoint>.Construct(
    function(const P1, P2: TPoint): Integer
    begin
      Result := ComparePoints(P1, P2);
    end
  );
end;
{$ENDREGION}

{ Helper CustomRecord function }

function CompareCustomRecord(const R1, R2: ICustomRecord): Integer;
begin
  Result := R1.Value - R2.Value;
end;

{ Helper ProductByPrice function }

function CompareProductByPrice(const P1, P2: IProduct): Integer;
begin
  if P1.Price < P2.Price then
    Result := -1
  else if P1.Price > P2.Price then
    Result := 1
  else
    Result := 0;
end;

{ Helper ClientByAge function }

function CompareClientByAge(const C1, C2: IClient): Integer;
begin
  Result := C1.Age - C2.Age;
end;

{ TCustomRecord }

{$REGION '  TCustomRecord .. '}
constructor TCustomRecord.Create(const aName: string; aValue: Integer);
begin
  fName  := aName;
  fValue := aValue;
end;

function TCustomRecord.GetName: string;
begin
  Result := fName;
end;

function TCustomRecord.GetValue: Integer;
begin
  Result := fValue;
end;

function TCustomRecord.GetCustomRecordupdate: ICustomRecordUpdate;
begin
  Result := Self as ICustomRecordUpdate;
end;

function TCustomRecord.Edit(const aName: string;
  const aValue: Integer): ICustomRecord;
begin
  fName  := aName;
  fValue := aValue;
end;
{$ENDREGION}

{ TProduct }

{$REGION '  TProduct .. '}
constructor TProduct.Create(aID: Integer; aPrice: Currency);
begin
  fID    := aID;
  fPrice := aPrice;
end;

function TProduct.GetID: Integer;
begin
  Result := fID;
end;

function TProduct.GetPrice: Currency;
begin
  Result := fPrice;
end;

function TProduct.GetIProductUpdate: IProductUpdate;
begin
  Result := Self as IProductUpdate;
end;

function TProduct.Edit(const aID: Integer; const aPrice: Currency): IProduct;
begin
  fID    := aID;
  fPrice := aPrice;
end;
{$ENDREGION}

{ TClient }

{$REGION '  TClient .. '}
constructor TClient.Create(const aName: string; aAge: Integer);
begin
  fName := aName;
  fAge  := aAge;
end;

function TClient.GetName: string;
begin
  Result := fName;
end;

function TClient.GetAge: Integer;
begin
  Result := fAge;
end;

function TClient.GetIClientUpdate: IClientUpdate;
begin
  Result := Self as IClientUpdate;
end;

function TClient.Edit(const aName: string; const aAge: Integer): IClient;
begin
  fName := aName;
  fAge  := aAge;
end;
{$ENDREGION}

end.
```
## Extensibility

You can easily extend `TRange<T>` to support:
1. **String ranges** using `AnsiCompareStr` or `AnsiCompareText`.
2. **Custom comparators** by adding a comparator function to the class.

This allows you to handle complex types or special ordering logic.  

No licence Here.. 

 
