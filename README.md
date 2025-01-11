# TRangeChecker (TRange<T>)  

Delphi TRange Checker (clean design, easy to extend comparers)  
 ----  
 **Output Result:** 
 ![](https://github.com/mben-dz/TRangeCheck/blob/main/OutputResults.jpg)  
 ---  
# TRangeChecker for Delphi

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

### All Test Code in my console App "RangChecker.dpr"

```pascal
program RangChecker;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  System.Types,
  DateUtils,
  System.Generics.Defaults,
  API.Utils in 'API\API.Utils.pas',
  API.Objects.Comparer in 'API\API.Objects.Comparer.pas';

var
  gPoint1, gPoint2, gPoint3: TPoint;

  gRec1, gRec2, gRec3: ICustomRecord;
  gRecordComparer: IComparer<ICustomRecord>;

  gProduct1, gProduct2, gProduct3: IProduct;
  gProductComparer: IComparer<IProduct>;

  gClient1, gClient2, gClient3: IClient;
  gClientComparer: IComparer<IClient>;

  gEndDateStr: string;
begin
  gPoint1 := TPoint.Create(1, 2);
  gPoint2 := TPoint.Create(0, 0);
  gPoint3 := TPoint.Create(3, 4);

  gRec1 := GetTCustomRecord('Low', 10);
  gRec2 := GetTCustomRecord('Mid', 20);
  gRec3 := GetTCustomRecord('High', 30);
  gRecordComparer := TComparer<ICustomRecord>.Construct(CompareCustomRecord);

  gProduct1 := GetTProduct(1, 10.0);
  gProduct2 := GetTProduct(2, 20.0);
  gProduct3 := GetTProduct(3, 30.0);
  gProductComparer := TComparer<IProduct>.Construct(CompareProductByPrice);

  gClient1 := GetTClient('Alice', 25);
  gClient2 := GetTClient('Bob', 30);
  gClient3 := GetTClient('Charlie', 35);
  gClientComparer := TComparer<IClient>.Construct(CompareClientByAge);

  with FormatSettings do begin
    ShortDateFormat := 'DD MMMM YYYY';
    CurrencyString := 'DA';
    DecimalSeparator := ',';
    ThousandSeparator := '.';
  end;
  gEndDateStr := DateToStr(Today +10, FormatSettings);

  try
    Writeln('-----------------<< Integer Tests >>--------------------------------');
  {$REGION '  Integer Tests .. '}
    if TRange<Integer>.IsIn(5, 1, 10) then
      Writeln('5 is within the range [1, 10]')
    else
      Writeln('5 is outside the range [1, 10]');

    if TRange<Integer>.IsIn(5, 6, 10) then
      Writeln('5 is within the range [6, 10]')
    else
      Writeln('5 is outside the range [6, 10]');
  {$ENDREGION}

    Writeln('-----------------<< Int64 Tests >>--------------------------------');
  {$REGION '  Int64 Tests .. '}
    if TRange<Int64>.IsIn(5_000_000_000_000_000_001, 5_000_000_000_000_000_000, 5_000_000_000_000_000_010) then
      Writeln('5_000_000_000_000_000_001 is within the range [5_000_000_000_000_000_000, 5_000_000_000_000_000_010]')
    else
      Writeln('5 is outside the range [5_000_000_000_000_000_000, 5_000_000_000_000_000_010]');

    if TRange<Int64>.IsIn(5_000_000_000_000_000_000, 5_000_000_000_000_000_001, 5_000_000_000_000_000_010) then
      Writeln('5_000_000_000_000_000_000 is within the range [5_000_000_000_000_000_001, 5_000_000_000_000_000_010]')
    else
      Writeln('5_000_000_000_000_000_000 is outside the range [5_000_000_000_000_000_001, 5_000_000_000_000_000_010]');
  {$ENDREGION}

    Writeln('-----------------<< Float Tests >>----------------------------------');
  {$REGION '  Float Tests .. '}
    if TRange<Double>.IsIn(7.5, 5.0, 10.0) then
      Writeln('7.5 is within the range [5.0, 10.0]')
    else
      Writeln('7.5 is outside the range [5.0, 10.0]');

    if TRange<Double>.IsIn(7.5, 7.6, 10.0) then
      Writeln('7.5 is within the range [7.6, 10.0]')
    else
      Writeln('7.5 is outside the range [7.6, 10.0]');
  {$ENDREGION}

    Writeln('-----------------<< DateTime Tests >>------------------------------');
  {$REGION '  DateTime Tests .. '}
    if TRange<TDateTime>.IsIn(Today, Today, Today +10) then
      Writeln('Today is within ['+Today.ToString+'] and ['+gEndDateStr+']')
    else
      Writeln('Today is outside ['+Today.ToString+'] and ['+gEndDateStr+']');

    if TRange<TDateTime>.IsIn(Yesterday, Today, Today +10) then
      Writeln('Yesterday is within ['+Today.ToString+'] and ['+gEndDateStr+']')
    else
      Writeln('Yesterday is outside ['+Today.ToString+'] and ['+gEndDateStr+']');
  {$ENDREGION}

    Writeln('-----------------<< String Tests >>--------------------------------');
  {$REGION '  String Tests .. '}
    if TRange<string>.IsIn('hello', 'alpha', 'zulu') then
      Writeln('"hello" is within the range [alpha, zulu]')
    else
      Writeln('"hello" is outside the range [alpha, zulu]');

    if TRange<string>.IsIn('zulu', 'alpha', 'omega') then
      Writeln('"zulu" is within the range [alpha, omega]')
    else
      Writeln('"zulu" is outside the range [alpha, omega]');
  {$ENDREGION}

    Writeln('-----------------<< TPoint Tests >>-----------------------------');
  {$REGION '  TPoint Tests .. '}
    if TRange<TPoint>.IsIn(gPoint1, gPoint2, gPoint3, PointComparer) then
      Writeln('Point(1, 2) is within the range [Point(0, 0), Point(3, 4)]')
    else
      Writeln('Point(1, 2) is outside the range [Point(0, 0), Point(3, 4)]');

    if TRange<TPoint>.IsIn(Point(5, 5), Point(0, 0), Point(3, 4), PointComparer) then
      Writeln('Point(5, 5) is within the range [Point(0, 0), Point(3, 4)]')
    else
      Writeln('Point(5, 5) is outside the range [Point(0, 0), Point(3, 4)]');
  {$ENDREGION}

    Writeln('-----------------<< TCustomRecord Tests >>-----------------------------');
  {$REGION '  TCustomRecord Tests .. '}
    if TRange<ICustomRecord>.IsIn(gRec2, gRec1, gRec3, gRecordComparer) then
      Writeln('Record is within the range')
    else
      Writeln('Record is outside the range');

    gRec2.New.Edit('Mid', 40);
    if TRange<ICustomRecord>.IsIn(gRec2, gRec1, gRec3, gRecordComparer) then
      Writeln('Record is within the range')
    else
      Writeln('Record is outside the range');
  {$ENDREGION}

    Writeln('-----------------<< TProduct Tests >>-----------------------------');
  {$REGION '  TProduct Tests .. '}
    if TRange<IProduct>.IsIn(gProduct2, gProduct1, gProduct3, gProductComparer) then
      Writeln('Product price is within the range')
    else
      Writeln('Product price is outside the range');

    gProduct2.New.Edit(2, 40);
    if TRange<IProduct>.IsIn(gProduct2, gProduct1, gProduct3, gProductComparer) then
      Writeln('Product price is within the range')
    else
      Writeln('Product price is outside the range');
  {$ENDREGION}

    Writeln('-----------------<< TClient Tests >>-----------------------------');
  {$REGION '  TClient Tests .. '}
    if TRange<IClient>.IsIn(gClient2, gClient1, gClient3, gClientComparer) then
      Writeln('Client age is within the range')
    else
      Writeln('Client age is outside the range');

    gClient2.New.Edit('Bob', 40);
    if TRange<IClient>.IsIn(gClient2, gClient1, gClient3, gClientComparer) then
      Writeln('Client age is within the range')
    else
      Writeln('Client age is outside the range');
  {$ENDREGION}

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

  Readln;
end.
```

## Extensibility

You can easily extend `TRange<T>` to support:
1. **String ranges** using `AnsiCompareStr` or `AnsiCompareText`.
2. **Custom comparators** by adding a comparator function to the class.

This allows you to handle complex types or special ordering logic.  

No licence Here.. 

 
