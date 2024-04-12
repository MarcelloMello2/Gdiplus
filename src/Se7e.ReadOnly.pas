// Marcelo Melo
// 28/03/2024

unit Se7e.ReadOnly;

{$SCOPEDENUMS ON}
{$ZEROBASEDSTRINGS ON}
{$POINTERMATH ON}
{$ALIGN 8}
{$MINENUMSIZE 4}


{$IFDEF FPC}
    {$MODE DELPHI}
{$ENDIF}

//{$MODESWITCH ALLOWINLINE}
//{$MODESWITCH AUTODEREF}

interface

uses
   SysUtils,
   Variants,
   Classes,
   Generics.Defaults,
   Rtti,
   TypInfo;

type

{$REGION 'ReadOnly<T>'}

   EReadOnlyException = class(Exception);

   { ReadOnly<T> }

   ReadOnly<T> = record
      strict private m_hasValue: Boolean;
      strict private m_value: T;

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

      public function Equals(const AValue: ReadOnly<T>): Boolean; overload;
      public function Equals(const AValue: T): Boolean; overload;

      public class operator Implicit(const AValue: ReadOnly<T>): T; overload;
      public class operator Implicit(const AValue: Pointer): ReadOnly<T>;
      public class operator Implicit(const AValue: T): ReadOnly<T>;

      public class operator Explicit(const AValue: ReadOnly<T>): T;
      public class operator Explicit(const AValue: T): ReadOnly<T>;

      public class operator Equal(const ALeft: ReadOnly<T>; const ARight: ReadOnly<T>): Boolean; overload;
      public class operator Equal(const ALeft: ReadOnly<T>; const ARight: T): Boolean; overload;
      public class operator Equal(const ALeft: T; const ARight: ReadOnly<T>): Boolean; overload;

      public class operator NotEqual(const ALeft: ReadOnly<T>; const ARight: ReadOnly<T>): Boolean; overload;
      public class operator NotEqual(const ALeft: ReadOnly<T>; const ARight: T): Boolean; overload;
      public class operator NotEqual(const ALeft: T; const ARight: ReadOnly<T>): Boolean; overload;

      public class operator GreaterThan(const ALeft: ReadOnly<T>; const ARight: T): Boolean; overload;
      public class operator LessThan(const ALeft: ReadOnly<T>; const ARight: T): Boolean; overload;

      public class operator Initialize({$IFDEF FPC}var{$ELSE}out{$ENDIF} ADest: ReadOnly<T>);
{$IFDEF FPC}
      public class operator Copy(constref ASrc: ReadOnly<T>; var ADest: ReadOnly<T>);
{$ELSE}
      public class operator Assign(var ADest: ReadOnly<T>; const [ref] ASrc: ReadOnly<T>);
{$ENDIF}

  end;

{$ENDREGION 'ReadOnly<T>'}

implementation

{$REGION 'ReadOnly<T>'}

{ ReadOnly<T> }

procedure ReadOnly<T>.Clear();
begin
   m_value    := Default(T);
   m_hasValue := False;
end;

function ReadOnly<T>.GetValueType(): PTypeInfo;
begin
   Result := TypeInfo(T);
end;

function ReadOnly<T>.GetValueTypeName(): string;
begin
   Result := string(GetValueType^.Name);
end;

function ReadOnly<T>.GetValue(): T;
begin
   Result := m_value;
end;

//procedure ReadOnly<T>.SetValue(const AValue: T);
//begin
//   m_value    := AValue;
//   m_hasValue := True;
//end;

function ReadOnly<T>.GetHasValue(): Boolean;
begin
   Result := m_hasValue;
end;

constructor ReadOnly<T>.Create(const AValue: T);
begin
   m_value    := AValue;
   m_hasValue := True;
end;

function ReadOnly<T>.ToString(): string;
begin
   Result := TValue.From<T>(m_value).ToString();
end;

function ReadOnly<T>.Equals(const AValue: ReadOnly<T>): Boolean;
begin
   Result := TEqualityComparer<T>.Default.Equals(Self.m_value, AValue.m_value)
end;

function ReadOnly<T>.Equals(const AValue: T): Boolean;
begin
   Result := TEqualityComparer<T>.Default.Equals(Self.m_value, AValue)
end;

class operator ReadOnly<T>.Implicit(const AValue: ReadOnly<T>): T;
begin
   Result := AValue.m_value;
end;

class operator ReadOnly<T>.Implicit(const AValue: Pointer): ReadOnly<T>;
begin
   if AValue = nil then
      Result.Clear()
   else
      Result := ReadOnly<T>.Create(T(AValue^));
end;

class operator ReadOnly<T>.Implicit(const AValue: T): ReadOnly<T>;
begin
   Result := ReadOnly<T>.Create(AValue);
end;

class operator ReadOnly<T>.Explicit(const AValue: ReadOnly<T>): T;
begin
   Result := AValue.m_value;
end;

class operator ReadOnly<T>.Explicit(const AValue: T): ReadOnly<T>;
begin
   Result := ReadOnly<T>.Create(AValue);
end;

class operator ReadOnly<T>.Equal(const ALeft: ReadOnly<T>; const ARight: ReadOnly<T>): Boolean;
begin
   raise ENotImplemented.Create('ainda não fiz isso aqui');
//   Result := ALeft.Equals(ARight);
end;

class operator ReadOnly<T>.Equal(const ALeft: ReadOnly<T>; const ARight: T): Boolean;
begin
   Result := ALeft.Equals(ARight);
end;

class operator ReadOnly<T>.Equal(const ALeft: T; const ARight: ReadOnly<T>): Boolean;
begin
   Result := ARight.Equals(ALeft);
end;

class operator ReadOnly<T>.NotEqual(const ALeft: ReadOnly<T>; const ARight: ReadOnly<T>): Boolean;
begin
   raise ENotImplemented.Create('ainda não fiz isso aqui');
//   Result := not ALeft.Equals(ARight);
end;

class operator ReadOnly<T>.NotEqual(const ALeft: ReadOnly<T>; const ARight: T): Boolean;
begin
   Result := not ALeft.Equals(ARight);
end;

class operator ReadOnly<T>.NotEqual(const ALeft: T; const ARight: ReadOnly<T>): Boolean;
begin
   Result := not ARight.Equals(ALeft);
end;

class operator ReadOnly<T>.GreaterThan(const ALeft: ReadOnly<T>; const ARight: T): Boolean;
begin
   Result := ALeft.HasValue and (TComparer<T>.Default.Compare(ALeft.m_value, ARight) > 0);
end;

class operator ReadOnly<T>.LessThan(const ALeft: ReadOnly<T>; const ARight: T): Boolean;
begin
   Result := ALeft.HasValue and (TComparer<T>.Default.Compare(ALeft.m_value, ARight) < 0);
end;

class operator ReadOnly<T>.Initialize({$IFDEF FPC}var{$ELSE}out{$ENDIF} ADest: ReadOnly<T>);
begin
   ADest.m_hasValue := False;
   ADest.m_value := Default(T);
end;

{$IFDEF FPC}
class operator ReadOnly<T>.Copy(constref ASrc: ReadOnly<T>; var ADest: ReadOnly<T>);
{$ELSE}
class operator ReadOnly<T>.Assign(var ADest: ReadOnly<T>; const [ref] ASrc: ReadOnly<T>);
{$ENDIF}
begin
   if ADest.HasValue then
      raise EReadOnlyException.Create('Não é permitido atribuir o valor, a variável é somente leitura e já foi atribuído o valor. (' +  ADest.GetValueTypeName() + ' = ' + ADest.ToString() + ')');// at ReturnAddress;

   ADest.m_hasValue := ASrc.HasValue;
   ADest.m_value := ASrc.Value;
end;


{$ENDREGION 'ReadOnly<T>'}

end.
