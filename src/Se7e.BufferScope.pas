// Marcelo Melo
// 01/04/2024

unit Se7e.BufferScope;

{$REGION 'Compiler Directives'}

{$SCOPEDENUMS ON}
{$ZEROBASEDSTRINGS ON}
{$ALIGN 8}
{$MINENUMSIZE 4}

{$ENDREGION 'Compiler Directives'}

interface

uses
   System.SysUtils,
   System.Classes,
   Se7e.Span,
   Se7e.Nullable;

type

{$REGION 'TBufferScope'}

   { TBufferScope<T> }

   /// <summary>
   ///  Allows renting a buffer from <see cref="ArrayPool{T}"/> with a using statement. Can be used directly as if it
   ///  were a <see cref="Span{T}"/>.
   /// </summary>
   /// <remarks>
   ///  <para>
   ///   Buffers are not cleared and as such their initial contents will be random.
   ///  </para>
   /// </remarks>
   TBufferScope<T: record> = record
      strict private type PReference = ^T;
      strict private _array: TArray<T>;
      strict private _span: TSpan<T>;
      strict private function GetLength(): Integer;

      public property Length: Integer read GetLength;

      public constructor Create(const minimumLength: Integer); overload;

      /// <summary>
      ///  Create the <see cref="BufferScope{T}"/> with an initial buffer. Useful for creating with an initial stack
      ///  allocated buffer.
      /// </summary>
      public constructor Create(const initialBuffer: TSpan<T>); overload;

      /// <summary>
      ///  Create the <see cref="BufferScope{T}"/> with an initial buffer. Useful for creating with an initial stack
      ///  allocated buffer.
      /// </summary>
      /// <remarks>
      ///  <para>
      ///   <example>
      ///    <para>Creating with a stack allocated buffer:</para>
      ///    <code>using BufferScope&lt;char> buffer = new(stackalloc char[64]);</code>
      ///   </example>
      ///  </para>
      ///  <para>
      ///   Stack allocated buffers should be kept small to avoid overflowing the stack.
      ///  </para>
      /// </remarks>
      /// <param name="minimumLength">
      ///  The required minimum length. If the <paramref name="initialBuffer"/> is not large enough, this will rent from
      ///  the shared <see cref="ArrayPool{T}"/>.
      /// </param>
      public constructor Create(const initialBuffer: TSpan<T>; const minimumLength: Integer); overload;

      /// <summary>
      ///  Ensure that the buffer has enough space for <paramref name="capacity"/> number of elements.
      /// </summary>
      /// <remarks>
      ///  <para>
      ///   Consider if creating new <see cref="BufferScope{T}"/> instances is possible and cleaner than using
      ///   this method.
      ///  </para>
      /// </remarks>
      /// <param name="copy">True to copy the existing elements when new space is allocated.</param>
      public procedure EnsureCapacity(const capacity: Integer; const copy: Boolean = false);

      public function Slice(const start: Integer; const length: Integer): TSpan<T>;

      public function GetPinnableReference(): PReference;

      public function AsSpan(): TSpan<T>;

      public procedure Dispose();

      public function ToString(): string;

      strict private function GetItem(const i: Integer): PReference;

      public property Items[const i: Integer]: PReference read GetItem;

//      public readonly Span<T> this[Range range] => _span[range];

      public class operator implicit(const scope: TBufferScope<T>): TSpan<T>;

      public class operator implicit(const scope: TBufferScope<T>): TReadOnlySpan<T>;
   end;

{$ENDREGION 'TBufferScope'}

implementation

{$REGION 'TBufferScope'}

{ TBufferScope<T> }

function TBufferScope<T>.GetLength(): Integer;
begin
   Result := _span.Length;
end;

constructor TBufferScope<T>.Create(const minimumLength: Integer);
begin
   _array := TArrayPool<T>.Shared.Rent(minimumLength);
   _span := _array;
end;

constructor TBufferScope<T>.Create(const initialBuffer: TSpan<T>);
begin
   _array := nil;
   _span := initialBuffer;
end;

constructor TBufferScope<T>.Create(const initialBuffer: TSpan<T>; const minimumLength: Integer);
begin
   if (initialBuffer.Length >= minimumLength) then
   begin
      _array := nil;
      _span := initialBuffer;
   end
   else
   begin
      _array := ArrayPool<T>.Shared.Rent(minimumLength);
      _span := _array;
   end;
end;

procedure TBufferScope<T>.EnsureCapacity(const capacity: Integer; const copy: Boolean = false);
begin
   if (_span.Length >= capacity) then
   begin

      Exit();
   end;

   var newArray: TArray<T> := ArrayPool<T>.Shared.Rent(capacity);
   if (copy) then
   begin
      _span.CopyTo(newArray);
   end;

   if (_array <> nil) then
   begin
      ArrayPool<T>.Shared.Return(_array);
   end;

   _array := newArray;
   _span := _array;
end;

function TBufferScope<T>.Slice(const start: Integer; const length: Integer): TSpan<T>;
begin
   Result := _span.Slice(start, length)
end;

function TBufferScope<T>.GetPinnableReference(): P;
begin
   Result :=
     //
     // não implementado pelo ObjectPascalCodeGenerator: RefExpression
     // Node.Kind: RefExpression
     // Type: RefExpressionSyntax
     // Arquivo: T:\Data7AdvDsv\source\Apoio\DotNetCore\9-preview2\System.Private.Windows.Core\src\System\BufferScope.cs
     // Posição: [3307..3344)
     // Linha: 110
     //
     // ----------- começa aqui o que não é suportado ------------
   ref MemoryMarshal.GetReference(_span)
     // ----------- TERMINA AQUI O QUE É SEM SUPORTE - 22-03-2024-01 ------------
     //

end;

function TBufferScope<T>.AsSpan(): TSpan<T>;
begin
   Result := _span
end;

procedure TBufferScope<T>.Dispose();
begin
   if (_array <> nil) then
   begin
      ArrayPool<T>.Shared.Return(_array);
   end;

   _array := default;
end;

function TBufferScope<T>.ToString(): string;
begin
   Result := _span.ToString()
end;

  //
  // (indexerDeclarationSyntax.ExpressionBody is ArrowExpressionClauseSyntax)
  //
  // não implementado pelo ObjectPascalCodeGenerator: => ref _span[i]
  // Kind: IndexerDeclaration
  // Type: IndexerDeclarationSyntax
  // Arquivo: T:\Data7AdvDsv\source\Apoio\DotNetCore\9-preview2\System.Private.Windows.Core\src\System\BufferScope.cs
  // Posição: [3054..3101)
  // Linha: 104
  //
  // ----------- começa aqui o que não é suportado ------------

    public ref T this[int i] => ref _span[i];

  // ----------- TERMINA AQUI O QUE É SEM SUPORTE - 3 ------------
  //

  //
  // (indexerDeclarationSyntax.ExpressionBody is ArrowExpressionClauseSyntax)
  //
  // não implementado pelo ObjectPascalCodeGenerator: => _span[range]
  // Kind: IndexerDeclaration
  // Type: IndexerDeclarationSyntax
  // Arquivo: T:\Data7AdvDsv\source\Apoio\DotNetCore\9-preview2\System.Private.Windows.Core\src\System\BufferScope.cs
  // Posição: [3101..3165)
  // Linha: 106
  //
  // ----------- começa aqui o que não é suportado ------------

    public readonly Span<T> this[Range range] => _span[range];

  // ----------- TERMINA AQUI O QUE É SEM SUPORTE - 3 ------------
  //

class operator TBufferScope<T>.implicit(const scope: TBufferScope<T>): TSpan<T>;
begin
   Result := scope._span;
end;

class operator TBufferScope<T>.implicit(const scope: TBufferScope<T>): TReadOnlySpan<T>;
begin
   Result := scope._span;
end;

{$ENDREGION 'TBufferScope'}

end.
