// Marcelo Melo
// 28/03/2024

unit Se7e.NonNullable;

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

{$REGION 'NonNullable<T>'}

   ENonNullableException = class(Exception);
   ENullReferenceException = class(ENonNullableException);

   /// <summary>
   /// Encapsula uma referência compatível com o parâmetro de tipo. A referência
   /// é garantida como não nula, a menos que o valor tenha sido criado com o
   /// construtor sem parâmetros (por exemplo, como o valor padrão de um campo ou array).
   /// Conversões implícitas estão disponíveis para e do parâmetro de tipo. A
   /// conversão para o tipo não nulo lançará ArgumentNullException
   /// quando apresentado com uma referência nula. A conversão do tipo não nulo
   /// lançará NullReferenceException se contiver uma referência nula.
   /// Este tipo é um tipo de valor (para evitar ocupar espaço extra) e como o CLR
   /// infelizmente não tem conhecimento dele, ele será encaixotado como qualquer outro valor
   /// tipo. As conversões também estão disponíveis através da propriedade Value e do
   /// construtor parametrizado.
   /// </summary>
   /// <typeparam name="T">Tipo de referência não nula para encapsular</typeparam>
   NonNullable<T: class> = record
      strict private m_value: T;
      strict private function GetValue(): T;
      public constructor Create(const AValue: T); overload;
      public class function Create(): NonNullable<T>; overload; static;

      /// <summary>
      /// Recupera o valor encapsulado ou lança uma NullReferenceException se
      /// esta instância foi criada com o construtor sem parâmetros ou por padrão.
      /// </summary>
      public property Value: T read GetValue;

      /// <summary>
      /// Conversão implícita da referência especificada.
      /// </summary>
      public class operator Implicit(const AValue: T): NonNullable<T>;

      /// <summary>
      /// Conversão implícita para o parâmetro de tipo a partir do valor encapsulado.
      /// </summary>
      public class operator Implicit(const AWrapper: NonNullable<T>): T;

      public class operator Initialize({$IFDEF FPC}var{$ELSE}out{$ENDIF} ADest: NonNullable<T>);

      /// <summary>
      /// Operador de igualdade, que realiza uma comparação de identidade nas referências encapsuladas.
      /// Nenhuma exceção é lançada, mesmo se as referências forem nulas.
      /// </summary>
      public class operator Equal(const ALeft, ARight: NonNullable<T>): Boolean;

      /// <summary>
      /// Operador de desigualdade, que realiza uma comparação de identidade nas referências encapsuladas.
      /// Nenhuma exceção é lançada, mesmo se as referências forem nulas.
      /// </summary>
      public class operator NotEqual(const ALeft, ARight: NonNullable<T>): Boolean;

      /// <summary>
      /// Verificação de igualdade segura em termos de tipo (e sem boxing).
      /// </summary>
      public function Equals(const AOther: NonNullable<T>): Boolean; overload;

      /// <summary>
      /// Verificação de igualdade estática segura em termos de tipo (e sem boxing).
      /// </summary>
      public class function Equals(const AFirst: NonNullable<T>; const ASecond: NonNullable<T> ): Boolean; overload; static;

      public class function Equals(const objA, objB: TObject): Boolean; overload; static;

      /// <summary>
      /// Delega para a implementação de ToString da referência encapsulada, ou uma
      /// string vazia se a referência for nula.
      /// </summary>
      public function ToString(): string;
   end;

{$ENDREGION 'NonNullable<T>'}

implementation

{$REGION 'NonNullable<T>'}

{ NonNullable<T> }

constructor NonNullable<T>.Create(const AValue: T);
begin
   if AValue = nil then
      raise EArgumentNilException.Create('AValue');

   m_value := AValue;
end;

class function NonNullable<T>.Create(): NonNullable<T>;
begin
   Result := Default(NonNullable<T>);
end;

function NonNullable<T>.GetValue: T;
begin
   if m_value = nil then
      raise ENullReferenceException.Create('');

   Result := m_value;
end;

class operator NonNullable<T>.Implicit(const AValue: T): NonNullable<T>;
begin
   Result := NonNullable<T>.Create(AValue);
end;

class operator NonNullable<T>.Implicit(const AWrapper: NonNullable<T>): T;
begin
   Result := AWrapper.Value;
end;

class operator NonNullable<T>.Initialize({$IFDEF FPC}var{$ELSE}out{$ENDIF} ADest: NonNullable<T>);
begin
   ADest.m_value := Default(T);
end;

class operator NonNullable<T>.Equal(const ALeft, ARight: NonNullable<T>): Boolean;
begin
   Result := ALeft.m_value = ARight.m_value;
end;

class operator NonNullable<T>.NotEqual(const ALeft, ARight: NonNullable<T>): Boolean;
begin
   Result := not (ALeft = ARight);
end;

function NonNullable<T>.Equals(const AOther: NonNullable<T>): Boolean;
begin
   Result := NonNullable<T>.Equals(self, AOther);
end;

class function NonNullable<T>.Equals(const AFirst: NonNullable<T>; const ASecond: NonNullable<T> ): Boolean;
begin
   Result := NonNullable<T>.Equals(AFirst.m_value, ASecond.m_value);
end;

class function NonNullable<T>.Equals(const objA, objB: TObject): Boolean;
begin
   if (objA = objB) then
      Result := True
   else if (objA = nil) or (objB = nil) then
      Result := False
   else
      Result := objA.Equals(objB);
end;

function NonNullable<T>.ToString(): string;
begin
   if m_value = nil then
      Result := ''
   else
      Result := m_value.ToString();
end;

{$ENDREGION 'NonNullable<T>'}

end.
