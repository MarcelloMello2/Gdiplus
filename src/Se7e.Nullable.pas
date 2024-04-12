// Marcelo Melo
// 28/03/2024

unit Se7e.Nullable;

{$SCOPEDENUMS ON}
{$ZEROBASEDSTRINGS ON}
{$POINTERMATH ON}
{$ALIGN 8}
{$MINENUMSIZE 4}

{$IFDEF FPC}
  {$MODE DELPHI}
{$ENDIF}


interface

uses
   SysUtils,
   Variants,
   Classes,
   Generics.Defaults,
   Rtti,
   TypInfo;

type

{$REGION 'Nullable<T>'}

   ENullableException = class(Exception);

   { Nullable<T> }

   Nullable<T: record> = record
      strict private m_value: T;
      strict private m_hasValue: Boolean;
      strict private procedure Clear();
      strict private function GetValueType(): PTypeInfo;
      strict private function GetValueTypeName(): string;
      strict private function GetValue(): T;
//      strict private procedure SetValue(const AValue: T);
      strict private function GetHasValue(): Boolean;

      public constructor Create(const AValue: T); overload;

      public property HasValue: Boolean read GetHasValue;
      public property Value: T read GetValue;

      public function ToString(): string;

      public function Equals(const AValue: Nullable<T>): Boolean; overload;
      public function Equals(const AValue: T): Boolean; overload;
      public function GetValueOrDefault(): T; overload;
      public function GetValueOrDefault(const ADefaultValue: T): T; overload;

      public class operator Implicit(const AValue: Nullable<T>): T;
      public class operator Implicit(const AValue: Pointer): Nullable<T>;
      public class operator Implicit(const AValue: T): Nullable<T>;
      public class operator Implicit(const AValue: TValue): Nullable<T>;

      public class operator Explicit(const AValue: Nullable<T>): T;
      public class operator Explicit(const AValue: Pointer): Nullable<T>;
      public class operator Explicit(const AValue: T): Nullable<T>;
      public class operator Explicit(const AValue: TValue): Nullable<T>;

      public class operator Equal(const ALeft: Nullable<T>; const ARight: Nullable<T>): Boolean; overload;
      public class operator Equal(const ALeft: Nullable<T>; const ARight: T): Boolean; overload;
      public class operator Equal(const ALeft: T; const ARight: Nullable<T>): Boolean; overload;

      public class operator NotEqual(const ALeft: Nullable<T>; const ARight: Nullable<T>): Boolean; overload;
      public class operator NotEqual(const ALeft: Nullable<T>; const ARight: T): Boolean; overload;
      public class operator NotEqual(const ALeft: T; const ARight: Nullable<T>): Boolean; overload;

      public class operator GreaterThan(const ALeft: Nullable<T>; const ARight: T): Boolean; overload;
      public class operator LessThan(const ALeft: Nullable<T>; const ARight: T): Boolean; overload;

      public class operator Initialize({$IFDEF FPC}var{$ELSE}out{$ENDIF} ADest: Nullable<T>);
{$IFDEF FPC}
      class operator Copy(constref ASrc: Nullable<T>; var ADest: Nullable<T>);
{$ELSE}
      public class operator Assign(var ADest: Nullable<T>; const [ref] ASrc: Nullable<T>);
{$ENDIF}


//      public class operator Negative(a: Nullable<T>) : Nullable<T>;
//      public class operator Positive(a: Nullable<T>): Nullable<T>;
//      public class operator Inc(a: Nullable<T>) : Nullable<T>;
//      public class operator Dec(a: Nullable<T>): Nullable<T>
//      public class operator LogicalNot(a: Nullable<T>): Nullable<T>;
//      public class operator Trunc(a: Nullable<T>): Nullable<T>;
//      public class operator Round(a: Nullable<T>): Nullable<T>;
//      public class operator In(a: Nullable<T>; b: Nullable<T>) : Boolean;
//      public class operator Equal(a: Nullable<T>; b: Nullable<T>) : Boolean;
//      public class operator NotEqual(a: Nullable<T>; b: Nullable<T>): Boolean;
//      public class operator GreaterThan(a: Nullable<T>; b: Nullable<T>) Boolean;
//      public class operator GreaterThanOrEqual(a: Nullable<T>; b: Nullable<T>): Boolean;
//      public class operator LessThan(a: Nullable<T>; b: Nullable<T>): Boolean;
//      public class operator LessThanOrEqual(a: Nullable<T>; b: Nullable<T>): Boolean;
//      public class operator Assign(var Dest: Nullable<T>; const [ref] Src: Nullable<T>);
//      public class operator Add(a: Nullable<T>; b: Nullable<T>): Nullable<T>;
//      public class operator Subtract(a: Nullable<T>; b: Nullable<T>) : Nullable<T>;
//      public class operator Multiply(a: Nullable<T>; b: Nullable<T>) : Nullable<T>;
//      public class operator Divide(a: Nullable<T>; b: Nullable<T>) : Nullable<T>;
//      public class operator IntDivide(a: Nullable<T>; b: Nullable<T>): Nullable<T>;
//      public class operator Modulus(a: Nullable<T>; b: Nullable<T>): Nullable<T>;
//      public class operator LeftShift(a: Nullable<T>; b: Nullable<T>): Nullable<T>;
//      public class operator RightShift(a: Nullable<T>; b: Nullable<T>): Nullable<T>;
//      public class operator LogicalAnd(a: Nullable<T>; b: Nullable<T>): Nullable<T>;
//      public class operator LogicalOr(a: Nullable<T>; b: Nullable<T>): Nullable<T>;
//      public class operator LogicalXor(a: Nullable<T>; b: Nullable<T>): Nullable<T>;
//      public class operator BitwiseAnd(a: Nullable<T>; b: Nullable<T>): Nullable<T>;
//      public class operator BitwiseOr(a: Nullable<T>; b: Nullable<T>): Nullable<T>;
//      public class operator BitwiseXor(a: Nullable<T>; b: Nullable<T>): Nullable<T>;
   end;

{$ENDREGION 'Nullable<T>'}

implementation

{$REGION 'Nullable<T>'}

{ Nullable<T> }

procedure Nullable<T>.Clear();
begin
   m_value    := Default(T);
   m_hasValue := False;
end;

function Nullable<T>.GetValueType(): PTypeInfo;
begin
   Result := TypeInfo(T);
end;

function Nullable<T>.GetValueTypeName(): string;
begin
   Result := String(GetValueType^.Name);
end;

function Nullable<T>.GetValue(): T;
begin
   if not HasValue then
      raise ENullableException.Create('Tipo Nullable deve ter um valor. (' + GetValueTypeName() + ')');// at ReturnAddress;

   Result := m_value;
end;

//procedure Nullable<T>.SetValue(const AValue: T);
//begin
//   m_value    := AValue;
//   m_hasValue := True;
//end;

function Nullable<T>.GetHasValue(): Boolean;
begin
   Result := m_hasValue;
end;

constructor Nullable<T>.Create(const AValue: T);
begin
   m_value    := AValue;
   m_hasValue := True;
end;

function Nullable<T>.ToString(): string;
begin
   Result := TValue.From<T>(Value).ToString();
end;

function Nullable<T>.Equals(const AValue: Nullable<T>): Boolean;
begin
   if HasValue and AValue.HasValue then
      Result := TEqualityComparer<T>.Default.Equals(Self.Value, AValue.Value)
   else
      Result := HasValue = AValue.HasValue;
end;

function Nullable<T>.Equals(const AValue: T): Boolean;
var
   EqualityComparer: IEqualityComparer<T>;
begin
   EqualityComparer := TEqualityComparer<T>.Default;
   Result := (HasValue) and EqualityComparer.Equals(Self.Value, AValue)
end;

function Nullable<T>.GetValueOrDefault: T;
begin
   Result := GetValueOrDefault(Default(T));
end;

function Nullable<T>.GetValueOrDefault(const ADefaultValue: T): T;
begin
   if HasValue then
      Result := m_value
   else
      Result := ADefaultValue;
end;

class operator Nullable<T>.Implicit(const AValue: Nullable<T>): T;
begin
   Result := AValue.Value;
end;

class operator Nullable<T>.Implicit(const AValue: Pointer): Nullable<T>;
begin
   if AValue = nil then
      Result.Clear()
   else
      Result := Nullable<T>.Create(T(AValue^));
end;

class operator Nullable<T>.Implicit(const AValue: T): Nullable<T>;
begin
   Result := Nullable<T>.Create(AValue);
end;

class operator Nullable<T>.Implicit(const AValue: TValue): Nullable<T>;
begin
   Result := Nullable<T>.Create(AValue.AsType<T>);
end;

class operator Nullable<T>.Explicit(const AValue: Nullable<T>): T;
begin
   Result := AValue.Value;
end;

class operator Nullable<T>.Explicit(const AValue: Pointer): Nullable<T>;
begin
   if AValue = nil then
      Result.Clear()
   else
      Result := Nullable<T>.Create(T(AValue^));
end;

class operator Nullable<T>.Explicit(const AValue: T): Nullable<T>;
begin
   Result := Nullable<T>.Create(AValue);
end;

class operator Nullable<T>.Explicit(const AValue: TValue): Nullable<T>;
begin
   Result := Nullable<T>.Create(AValue.AsType<T>);
end;

class operator Nullable<T>.Equal(const ALeft: Nullable<T>; const ARight: Nullable<T>): Boolean;
begin
   Result := ALeft.Equals(ARight);
end;

class operator Nullable<T>.Equal(const ALeft: Nullable<T>; const ARight: T): Boolean;
begin
   Result := ALeft.Equals(ARight);
end;

class operator Nullable<T>.Equal(const ALeft: T; const ARight: Nullable<T>): Boolean;
begin
   Result := ARight.Equals(ALeft);
end;

class operator Nullable<T>.NotEqual(const ALeft: Nullable<T>; const ARight: Nullable<T>): Boolean;
begin
   Result := not ALeft.Equals(ARight);
end;

class operator Nullable<T>.NotEqual(const ALeft: Nullable<T>; const ARight: T): Boolean;
begin
   Result := not ALeft.Equals(ARight);
end;

class operator Nullable<T>.NotEqual(const ALeft: T; const ARight: Nullable<T>): Boolean;
begin
   Result := not ARight.Equals(ALeft);
end;

class operator Nullable<T>.GreaterThan(const ALeft: Nullable<T>; const ARight: T): Boolean;
begin
   Result := ALeft.HasValue and (TComparer<T>.Default.Compare(ALeft.Value, ARight) > 0);
end;

class operator Nullable<T>.LessThan(const ALeft: Nullable<T>; const ARight: T): Boolean;
begin
   Result := ALeft.HasValue and (TComparer<T>.Default.Compare(ALeft.Value, ARight) < 0);
end;

class operator Nullable<T>.Initialize({$IFDEF FPC}var{$ELSE}out{$ENDIF} ADest: Nullable<T>);
begin
   ADest.m_hasValue := False;
   ADest.m_value := Default(T);
end;

{$IFDEF FPC}
class operator Nullable<T>.Copy(constref ASrc: Nullable<T>; var ADest: Nullable<T>);
{$ELSE}
class operator Nullable<T>.Assign(var ADest: Nullable<T>; const [ref] ASrc: Nullable<T>);
{$ENDIF}
begin
   ADest.m_hasValue := ASrc.HasValue;
   ADest.m_value := ASrc.Value;
end;

{$ENDREGION 'Nullable<T>'}

end.
