// Marcelo Melo
// 26/11/2023

unit Se7e.Span;

{$SCOPEDENUMS ON}
{$ZEROBASEDSTRINGS ON}
{$ALIGN 8}
{$MINENUMSIZE 4}
{$POINTERMATH ON}

{$IFDEF FPC}
  {$MODE DELPHI}
{$ENDIF}


interface

uses
  SysUtils,
  Math,
  StrUtils,
  Classes;

type

{$REGION 'TReadOnlySpan<T>'}

   { TReadOnlySpan<T> }

   /// <summary>
   /// ReadOnlySpan representa uma região contígua de memória arbitrária. Ao contrário dos arrays, ele pode apontar para
   /// ou memória nativa, ou para memória alocada na pilha. É seguro para tipo e memória.
   /// </summary>
   TReadOnlySpan<T> = record
      private type PReference = ^T;

      /// <summary>
      /// Um byref ou um ptr nativo.
      /// </summary>
      private m_reference: PReference;

      /// <summary>
      /// O número de elementos que este ReadOnlySpan contém.
      /// </summary>
      private m_length: Integer;

      /// <summary>
      /// Cria um novo intervalo somente leitura em todo o array de destino.
      /// </summary>
      /// <param name="array">A matriz de destino.</param>
      /// <remarks>Retorna o padrão quando <paramref name="array"/> é nulo.</remarks>
      public constructor Create({$IFDEF FPC}constref{$ELSE}const [ref]{$ENDIF} array_: TArray<T>); overload;

      /// <summary>
      /// Cria um novo intervalo somente leitura sobre a parte do array de destino que começa
      /// no índice 'start' e termina no índice 'end' (exclusivo).
      /// </summary>
      /// <param name="array">O array de destino.</param>
      /// <param name="start">O índice a partir do qual começar o intervalo somente leitura.</param>
      /// <param name="length">O número de itens no intervalo somente leitura.</param>
      /// <remarks>Retorna o valor padrão quando <paramref name="array"/> é nulo.</remarks>
      /// <exception cref="ArgumentOutOfRangeException">
      /// Lançada quando o índice especificado <paramref name="start"/> ou o índice final não está no intervalo (<0 ou >Length).
      /// </exception>
      public constructor Create({$IFDEF FPC}constref{$ELSE}const [ref]{$ENDIF} array_: TArray<T>; const start: Integer; const length: Integer); overload;

      /// <summary>
      /// Cria um novo intervalo somente leitura sobre o buffer não gerenciado de destino. Isso
      /// é bastante perigoso, pois estamos criando tipos T arbitrariamente
      /// a partir de um bloco de memória de tipo void*. E o comprimento não é verificado.
      /// Mas se essa criação estiver correta, então todos os usos subsequentes também estarão corretos.
      /// </summary>
      /// <param name="pointer">Um ponteiro não gerenciado para a memória.</param>
      /// <param name="length">O número de elementos <typeparamref name="T"/> contidos na memória.</param>
      /// <exception cref="ArgumentException">
      ///   Lançada quando <typeparamref name="T"/> é um tipo de referência ou contém ponteiros e, portanto, não pode ser armazenado em memória não gerenciada.
      /// </exception>
      /// <exception cref="ArgumentOutOfRangeException">
      ///   Lançada quando o <paramref name="length"/> especificado é negativo.
      /// </exception>
      public constructor Create({$IFDEF FPC}constref{$ELSE}const [ref]{$ENDIF} pointer_: Pointer; const length: Integer); overload;

      /// <summary>
      /// Cria um novo <see cref="ReadOnlySpan{T}"/> de comprimento 1 em torno da referência especificada.
      /// </summary>
      /// <param name="reference">Uma referência aos dados.</param>
      public constructor Create({$IFDEF FPC}constref{$ELSE}const [ref]{$ENDIF} reference: T); overload;

//      /// <summary>
//      /// Construtor apenas para uso interno. Não é seguro expor publicamente e é exposto via MemoryMarshal.CreateReadOnlySpan.
//      /// </summary>
//      private constructor Create({$IFDEF FPC}constref{$ELSE}const [ref]{$ENDIF} reference: T; const length: Integer); overload;

      /// <summary>
      /// Retorna o elemento especificado do intervalo somente leitura.
      /// </summary>
      /// <param name="index"></param>
      /// <returns></returns>
      /// <exception cref="IndexOutOfRangeException">
      /// Lançada quando o índice é menor que 0 ou maior ou igual ao comprimento.
      /// </exception>
      private function GetItem(const index: Integer): T; inline;

      /// <summary>
      /// Retorna o elemento especificado do intervalo somente leitura.
      /// </summary>
      /// <param name="index"></param>
      /// <returns></returns>
      /// <exception cref="IndexOutOfRangeException">
      /// Lançada quando o índice é menor que 0 ou maior ou igual ao comprimento.
      /// </exception>
      public property Items[const index: Integer]: T read GetItem; default;

      /// <summary>
      /// O número de itens no intervalo somente leitura.
      /// </summary>
      public property Length: Integer read m_length;

      strict private function GetIsEmpty(): Boolean;

      /// <summary>
      /// Obtém um valor indicando se este <see cref="ReadOnlySpan{T}"/> está vazio.
      /// </summary>
      /// <value><see langword="true"/> se este intervalo estiver vazio; caso contrário, <see langword="false"/>.</value>
      public property IsEmpty: Boolean read GetIsEmpty;

      /// <summary>
      /// Retorna falso se a esquerda e a direita apontarem para a mesma memória e tiverem o mesmo comprimento. Observe que
      /// isso *não* verifica se o *conteúdo* é igual.
      /// </summary>
      class operator NotEqual(const left: TReadOnlySpan<T>; const right: TReadOnlySpan<T>): Boolean;

      /// <summary>
      /// Define uma conversão implícita de um array para um <see cref="ReadOnlySpan{T}"/>.
      /// </summary>
      class operator implicit(const array_: TArray<T>): TReadOnlySpan<T>;

      strict private class function GetEmpty(): TReadOnlySpan<T>; static;

      /// <summary>
      /// Retorna um intervalo somente leitura de comprimento 0 cuja base é o ponteiro nulo.
      /// </summary>
      public class property Empty: TReadOnlySpan<T> read GetEmpty;

      /// <summary>
      /// Converte uma leitura somente de um intervalo de <typeparamref name="TDerived"/> para um intervalo somente leitura de <typeparamref name="T"/>.
      /// </summary>
      /// <typeparam name="TDerived">O tipo de elemento do intervalo somente leitura de origem, que deve ser derivado de <typeparamref name="T"/>.</typeparam>
      /// <param name="items">O intervalo somente leitura de origem. Nenhuma cópia é feita.</param>
      /// <returns>Um intervalo somente leitura com elementos convertidos para o novo tipo.</returns>
      /// <remarks>Este método usa uma conversão covariante, produzindo um intervalo somente leitura que compartilha a mesma memória que a origem. As relações expressas nas restrições de tipo garantem que a conversão seja uma operação segura.</remarks>
//      public class function CastUp<TDerived>(const items: TReadOnlySpan<TDerived>): TReadOnlySpan<T>; static;

      /// <summary>
      /// Retorna uma referência ao 0º elemento do Span. Se o Span estiver vazio, retorna uma referência nula.
      /// Pode ser usado para fixação e é necessário para dar suporte ao uso de span dentro de uma instrução fixa.
      /// </summary>
      public function GetPinnableReference(): PReference;

      /// <summary>
      /// Retorna uma referência ao 0º elemento do Span. Se o Span estiver vazio, retorna uma referência ao local onde o 0º elemento
      /// teria sido armazenado. Tal referência pode ou não ser nula. Ele pode ser usado para fixação, mas nunca deve ser desreferenciado.
      /// </summary>
      public function GetReference(): PReference;

      /// <summary>
      /// Retorna verdadeiro se a esquerda e a direita apontarem para a mesma memória e tiverem o mesmo comprimento. Observe que
      /// isso *não* verifica se o *conteúdo* é igual.
      /// </summary>
      class operator Equal(const left: TReadOnlySpan<T>; const right: TReadOnlySpan<T>): Boolean;

      /// <summary>
      /// Para <see cref="ReadOnlySpan{Char}"/>, retorna uma nova instância de string que representa os caracteres apontados pelo intervalo.
      /// Caso contrário, retorna uma <see cref="string"/> com o nome do tipo e o número de elementos.
      /// </summary>
      public function ToString(): string;

      /// <summary>
      /// Forma uma fatia a partir do intervalo somente leitura fornecido, começando em 'start'.
      /// </summary>
      /// <param name="start">O índice a partir do qual começar esta fatia.</param>
      /// <exception cref="ArgumentOutOfRangeException">
      /// Lançada quando o índice especificado <paramref name="start"/> não está no intervalo (<0 ou >Length).
      /// </exception>
      public function Slice(const start: Integer): TReadOnlySpan<T>; overload; inline;

      /// <summary>
      /// Forma uma fatia a partir do intervalo somente leitura fornecido, começando em 'start', com o comprimento dado.
      /// </summary>
      /// <param name="start">O índice a partir do qual começar esta fatia.</param>
      /// <param name="length">O comprimento desejado para a fatia (exclusivo).</param>
      /// <exception cref="ArgumentOutOfRangeException">
      /// Lançada quando o índice especificado <paramref name="start"/> ou o índice final não está no intervalo (<0 ou >Length).
      /// </exception>
      public function Slice(const start: Integer; const length: Integer): TReadOnlySpan<T>; overload; inline;

      /// <summary>
      /// Copia o conteúdo deste intervalo somente leitura para um novo array. Isso aloca na heap,
      /// portanto, geralmente deve ser evitado, mas às vezes é necessário para conectar APIs escritas em termos de arrays.
      /// </summary>
      public function ToArray(): TArray<T>;


      /// <summary>
      /// Procura pelo valor especificado e retorna o índice de sua primeira ocorrência. Se não encontrado, retorna -1. Os valores são comparados usando IEquatable{T}.Equals(T).
      /// </summary>
      /// <param name="span">O intervalo a ser pesquisado.</param>
      /// <param name="value">O valor a ser procurado.</param>
      public function IndexOf(const value: T): Integer;

      /// <summary>
      /// Determina se a sequência especificada aparece no início do intervalo.
      /// </summary>
      public function StartsWith(const value: TReadOnlySpan<T>): Boolean; inline;

      /// <summary>
      /// Procura pelo primeiro índice de qualquer valor diferente do <paramref name="value"/> especificado.
      /// </summary>
      /// <typeparam name="T">O tipo do intervalo e dos valores.</typeparam>
      /// <param name="span">O intervalo a ser pesquisado.</param>
      /// <param name="value">Um valor a ser evitado.</param>
      /// <returns>
      /// O índice no intervalo da primeira ocorrência de qualquer valor diferente de <paramref name="value"/>.
      /// Se todos os valores forem <paramref name="value"/>, retorna -1.
      /// </returns>
      public function IndexOfAnyExcept(const value: T): Integer; inline;

         {$REGION 'TEnumerator'}

         { TEnumerator }

         public type

               /// <summary>
               ///   Enumera os elementos de um <see cref="ReadOnlySpan{T}"/>.
               /// </summary>
               TEnumerator = record
                  /// <summary>
                  ///   O intervalo sendo enumerado.
                  /// </summary>
                  strict private _span: Pointer;

                  /// <summary>
                  ///   O próximo índice a ser gerado.
                  /// </summary>
                  strict private _index: Integer;

                  strict private function GetCurrent(): T; inline;


                  /// <summary>
                  ///   Obtém o elemento na posição atual do enumerador.
                  /// </summary>
                  public property Current: T read GetCurrent;


                  /// <summary>Inicializa o enumerador.</summary>
                  /// <param name="span">O intervalo a ser enumerado.</param>
                  public constructor Create(const span: TReadOnlySpan<T>);


                  /// <summary>
                  ///   Avança o enumerador para o próximo elemento do intervalo.
                  /// </summary>
                  public function MoveNext(): Boolean; inline;
               end;

            {$ENDREGION 'TEnumerator'}

      /// <summary>
      ///   Obtém um enumerador para este intervalo.
      /// </summary>
      public function GetEnumerator(): TEnumerator;
  end;

{$ENDREGION 'TReadOnlySpan<T>'}

{$REGION 'TSpan<T>'}

   { TSpan<T> }

   /// <summary>
   /// Span represents a contiguous region of arbitrary memory. Unlike arrays, it can point to either managed
   /// or native memory, or to memory allocated on the stack. It is type-safe and memory-safe.
   /// </summary>
   TSpan<T> = record  (*readonly ref*)
      private type PReference = ^T;

      /// <summary>A byref or a native ptr.</summary>
      private m_reference: PReference;

      /// <summary>The number of elements this Span contains.</summary>
      private m_length: Integer;

      /// <summary>
      /// The number of items in the span.
      /// </summary>
      public property Length: Integer read m_length;

      /// <summary>
      /// Retorna uma referência ao 0º elemento do Span. Se o Span estiver vazio, retorna uma referência nula.
      /// Pode ser usado para fixação e é necessário para dar suporte ao uso de span dentro de uma instrução fixa.
      /// </summary>
      public function GetPinnableReference(): PReference;

      /// <summary>
      /// Retorna uma referência ao 0º elemento do Span. Se o Span estiver vazio, retorna uma referência ao local onde o 0º elemento
      /// teria sido armazenado. Tal referência pode ou não ser nula. Ele pode ser usado para fixação, mas nunca deve ser desreferenciado.
      /// </summary>
      public function GetReference(): PReference;
   end;

{$ENDREGION 'TSpan<T>'}

{$REGION 'TOldSpan<T>'}

//  { TOldSpan<T> }
//
//  /// <summary>
//  /// Span represents a contiguous region of arbitrary memory. Unlike arrays, it can point to either managed
//  /// or native memory, or to memory allocated on the stack. It is type- and memory-safe.
//  /// </summary>
//  TOldSpan<T> = packed record
//      private type PReference = ^T;
//
//      /// <summary>
//      ///  A byref or a native ptr.
//      /// </summary>
//      private m_reference: PReference;
//
//      /// <summary>
//      ///  The number of elements this Span contains.
//      /// </summary>
//      private m_length: Integer;
//      private function GetItem(const index: Integer): T; inline;
//      private procedure SetItem(const index: Integer; AValue: T); inline;
//
//      // Constructor for internal use only. It is not safe to expose publicly.
//      private constructor Create({$IFDEF FPC}constref{$ELSE}const [ref]{$ENDIF} AValue: PReference; AStart, ALength: Integer); overload;
//
//      /// <summary>
//      /// Creates a new span over the entirety of the target array.
//      /// </summary>
//      /// <param name="array">The target array.</param>
//      /// <remarks>Returns default when <paramref name="array"/> is null.</remarks>
//      /// <exception cref="ArrayTypeMismatchException">Thrown when <paramref name="array"/> is covariant and array's type is not exactly T[].</exception>
//      public constructor Create({$IFDEF FPC}constref{$ELSE}const [ref]{$ENDIF} &array: TArray<T>); overload;
//
//      /// <summary>
//      /// Creates a new span over the target unmanaged buffer.  Clearly this
//      /// is quite dangerous, because we are creating arbitrarily typed T's
//      /// out of a void*-typed block of memory.  And the length is not checked.
//      /// But if this creation is correct, then all subsequent uses are correct.
//      /// </summary>
//      /// <param name="pointer">An unmanaged pointer to memory.</param>
//      /// <param name="length">The number of <typeparamref name="T"/> elements the memory contains.</param>
//      /// <exception cref="ArgumentException">
//      /// Thrown when <typeparamref name="T"/> is reference type or contains pointers and hence cannot be stored in unmanaged memory.
//      /// </exception>
//      /// <exception cref="ArgumentOutOfRangeException">
//      /// Thrown when the specified <paramref name="length"/> is negative.
//      /// </exception>
//     public constructor Create({$IFDEF FPC}constref{$ELSE}const [ref]{$ENDIF} pointer: Pointer; length: Integer); overload;
//
//     public constructor Create({$IFDEF FPC}constref{$ELSE}const [ref]{$ENDIF} &array: TArray<T>; start: Integer); overload;
//
//      /// <summary>
//      /// Creates a new span over the portion of the target array beginning
//      /// at 'start' index and ending at 'end' index (exclusive).
//      /// </summary>
//      /// <param name="array">The target array.</param>
//      /// <param name="start">The index at which to begin the span.</param>
//      /// <param name="length">The number of items in the span.</param>
//      /// <remarks>Returns default when <paramref name="array"/> is null.</remarks>
//      /// <exception cref="ArrayTypeMismatchException">Thrown when <paramref name="array"/> is covariant and array's type is not exactly T[].</exception>
//      /// <exception cref="ArgumentOutOfRangeException">
//      /// Thrown when the specified <paramref name="start"/> or end index is not in the range (&lt;0 or &gt;Length).
//      /// </exception>
//      public constructor Create({$IFDEF FPC}constref{$ELSE}const [ref]{$ENDIF} &array: TArray<T>; start, length: Integer); overload;
//
//      /// <summary>Creates a new <see cref="TSpan{T}"/> of length 1 around the specified reference.</summary>
//      /// <param name="reference">A reference to data.</param>
//      public constructor Create({$IFDEF FPC}constref{$ELSE}const [ref]{$ENDIF} reference: T); overload;
//
//
//      /// <summary>
//      /// Gets a value indicating whether this <see cref="TSpan{T}"/> is empty.
//      /// </summary>
//      /// <value><see langword="true"/> if this span is empty; otherwise, <see langword="false"/>.</value>
//      public function IsEmpty(): Boolean; inline;
//
//      /// <summary>
//      /// The number of items in the span.
//      /// </summary>
//      public property Length: Integer read m_length;
//
//      /// <summary>
//      /// Determines whether two sequences are equal by comparing the elements using IEquatable{T}.Equals(T).
//      /// </summary>
//      public function SequenceEqual<T2>(const other: TReadOnlySpan<T2>): Boolean; overload; inline;
//
//      /// <summary>
//      /// Forms a slice out of the given span, beginning at 'start'.
//      /// </summary>
//      /// <param name="start">The index at which to begin this slice.</param>
//      /// <exception cref="ArgumentOutOfRangeException">
//      /// Thrown when the specified <paramref name="start"/> index is not in range (&lt;0 or &gt;Length).
//      /// </exception>
//      public function Slice([ref] const start: Integer): TOldSpan<T>; overload; inline;
//
//
//      /// <summary>
//      /// Forms a slice out of the given span, beginning at 'start', of given length
//      /// </summary>
//      /// <param name="start">The index at which to begin this slice.</param>
//      /// <param name="length">The desired length for the slice (exclusive).</param>
//      /// <exception cref="ArgumentOutOfRangeException">
//      /// Thrown when the specified <paramref name="start"/> or end index is not in range (&lt;0 or &gt;Length).
//      /// </exception>
//      public function Slice(const start: Integer; const length: Integer): TOldSpan<T>; overload; inline;
//
//      /// <summary>
//      /// Returns a reference to specified element of the Span.
//      /// </summary>
//      /// <param name="index"></param>
//      /// <returns></returns>
//      /// <exception cref="IndexOutOfRangeException">
//      /// Thrown when index less than 0 or index greater than or equal to Length
//      /// </exception>
//      public property Items[const AIndex: Integer]: T read GetItem write SetItem; default;
//
//      strict private class function GetEmpty(): TOldSpan<T>; static;
//
//      /// <summary>
//      /// Returns an empty <see cref="TSpan{T}"/>
//      /// </summary>
//      public class property Empty: TOldSpan<T> read GetEmpty;
//
//      /// <summary>
//      /// For <see cref="TSpan{Char}"/>, returns a new instance of string that represents the characters pointed to by the span.
//      /// Otherwise, returns a <see cref="string"/> with the name of the type and the number of elements.
//      /// </summary>
//      public function ToString(): string;
//
//
//      /// <summary>
//      /// Clears the contents of this span.
//      /// </summary>
//      //public procedure Clear(); inline;
//
//      /// <summary>
//      /// Defines an implicit conversion of an array to a <see cref="TSpan{T}"/>
//      /// </summary>
//      class operator Implicit({$IFDEF FPC}constref{$ELSE}const [ref]{$ENDIF} AValue: TArray<T>): TOldSpan<T>; inline; static;
//
//      /// <summary>
//      /// Defines an implicit conversion of a <see cref="TSpan{T}"/> to a <see cref="ReadOnlySpan{T}"/>
//      /// </summary>
//      class operator Implicit({$IFDEF FPC}constref{$ELSE}const [ref]{$ENDIF} span: TOldSpan<T> ): TReadOnlySpan<T>; inline; static;
//
//      /// <summary>
//      /// Returns false if left and right point at the same memory and have the same length.  Note that
//      /// this does *not* check to see if the *contents* are equal.
//      /// </summary>
//      class operator NotEqual({$IFDEF FPC}constref{$ELSE}const [ref]{$ENDIF} left: TOldSpan<T>; {$IFDEF FPC}constref{$ELSE}const [ref]{$ENDIF} right: TOldSpan<T>): Boolean; inline; static;
//
//      /// <summary>
//      /// Returns true if left and right point at the same memory and have the same length.  Note that
//      /// this does *not* check to see if the *contents* are equal.
//      /// </summary>
//      class operator Equal({$IFDEF FPC}constref{$ELSE}const [ref]{$ENDIF} left: TOldSpan<T>; {$IFDEF FPC}constref{$ELSE}const [ref]{$ENDIF} right: TOldSpan<T>): Boolean; inline; static;
//
//      class operator Implicit(const AValue: string): TOldSpan<T>; inline; static;
//      class operator Implicit({$IFDEF FPC}constref{$ELSE}const [ref]{$ENDIF} AValue: TOldSpan<T>): string; inline; static;
//      class operator Explicit({$IFDEF FPC}constref{$ELSE}const [ref]{$ENDIF} AValue: TOldSpan<T>): TArray<T>; inline; static;
//
//      /// <summary>
//      /// Searches for the specified value and returns the index of its first occurrence. If not found, returns -1. Values are compared using IEquatable{T}.Equals(T).
//      /// </summary>
//      /// <param name="span">The span to search.</param>
//      /// <param name="value">The value to search for.</param>
//      public function IndexOf(const value: T): Integer; overload; inline;
//
//      /// <summary>
//      /// Copies the contents of this span into destination span. If the source
//      /// and destinations overlap, this method behaves as if the original values in
//      /// a temporary location before the destination is overwritten.
//      /// </summary>
//      /// <param name="destination">The span to copy items into.</param>
//      /// <returns>If the destination span is shorter than the source span, this method
//      /// return false and no data is written to the destination.</returns>
//      public function TryCopyTo(const destination: TOldSpan<T>): Boolean;
//
//      /// <summary>
//      /// Copies the contents of this span into destination span. If the source
//      /// and destinations overlap, this method behaves as if the original values in
//      /// a temporary location before the destination is overwritten.
//      /// </summary>
//      /// <param name="destination">The span to copy items into.</param>
//      /// <exception cref="ArgumentException">
//      /// Thrown when the destination Span is shorter than the source Span.
//      /// </exception>
//      public procedure CopyTo(const destination: TOldSpan<T>); inline;
//  end;

{$ENDREGION 'TOldSpan<T>'}

{$REGION 'TSpanReader'}

   { TSpanReader<T> }

   /// <summary>
   /// Leitor rápido baseado em pilha de <see cref="ReadOnlySpan{T}"/>.
   /// </summary>
   /// <remarks>
   /// <para>
   /// Deve-se ter cuidado ao ler valores de struct que dependem de um estado de campo específico para que os membros
   /// funcionem corretamente. Por exemplo, <see cref="DateTime"/> possui um conjunto muito específico de valores válidos
   /// para seu campo <see langword="ulong"/> compactado.
   /// </para>
   /// <para>
   /// Inspirado pelos padrões de <see cref="SequenceReader{T}"/>.
   /// </para>
   /// </remarks>
   TSpanReader<T> = record
      strict private m_unread: TReadOnlySpan<T>;
      strict private m_span: TReadOnlySpan<T>;
      public property Span: TReadOnlySpan<T> read m_span;
      strict private function GetPosition(): Integer;
      strict private procedure SetPosition(const Value: Integer);

      public constructor Create(span: TReadOnlySpan<T>);

      public property Position: Integer read GetPosition write SetPosition;

      /// <summary>
      /// Tenta ler tudo até o <paramref name="delimiter"/> fornecido. Avança o leitor além do
      /// <paramref name="delimiter"/> se encontrado.
      /// </summary>
      /// <inheritdoc cref="TryReadTo(T, bool, out ReadOnlySpan{T})"/>
      public function TryReadTo(const delimiter: T; out span: TReadOnlySpan<T>): Boolean; overload;

      /// <summary>
      /// Tenta ler tudo até o <paramref name="delimiter"/>.
      /// </summary>
      /// <param name="span">Os dados lidos, se houver.</param>
      /// <param name="delimiter">O delimitador a ser procurado.</param>
      /// <param name="advancePastDelimiter"><see langword="true"/> para avançar além do <paramref name="delimiter"/> se encontrado.</param>
      /// <returns><see langword="true"/> se o <paramref name="delimiter"/> foi encontrado.</returns>
      public function TryReadTo(const delimiter: T; const advancePastDelimiter: Boolean; out span: TReadOnlySpan<T>): Boolean; overload;

      /// <summary>
      /// Tenta ler o próximo valor.
      /// </summary>
      public function TryRead(out value: T): Boolean; overload;

      /// <summary>
      /// Tenta ler uma sequência do <paramref name="count"/> especificado.
      /// </summary>
      public function TryRead(const count: Integer; out span: TReadOnlySpan<T>): Boolean; overload;

      /// <summary>
      /// Tenta ler um valor do tipo especificado. O tamanho do valor deve ser divisível igualmente pelo tamanho de
      /// <typeparamref name="T"/>.
      /// </summary>
      /// <remarks>
      /// <para>
      /// Isso é apenas uma cópia direta de bits. Se <typeparamref name="TValue"/> tem métodos que dependem de
      /// restrições específicas de valor de campo, isso pode ser inseguro.
      /// </para>
      /// <para>
      /// O compilador muitas vezes otimiza a cópia da estrutura se você apenas ler do valor.
      /// </para>
      /// </remarks>
//      public function TryRead<TValue>(out value: TValue): Boolean; overload;

      /// <summary>
      /// Tenta ler uma sequência de valores do tipo especificado. O tamanho do valor deve ser divisível igualmente pelo tamanho de
      /// <typeparamref name="T"/>.
      /// </summary>
      /// <remarks>
      /// <para>
      /// Isso efetivamente faz um <see cref="MemoryMarshal.Cast{TFrom, TTo}(ReadOnlySpan{TFrom})"/> e as mesmas
      /// ressalvas sobre segurança se aplicam.
      /// </para>
      /// </remarks>
//      public function TryRead<TValue>(const count: Integer; out value: TReadOnlySpan<TValue>): Boolean; overload;

//      /// <summary>
//      /// Verifica se os valores <paramref name="next"/> seguintes são consecutivos.
//      /// </summary>
//      /// <param name="next">A sequência para comparar os próximos itens.</param>
//      public function IsNext(const next: TReadOnlySpan<T>): Boolean;

      /// <summary>
      /// Avança o leitor se os valores <paramref name="next"/> seguintes forem consecutivos.
      /// </summary>
      /// <param name="next">A sequência para comparar os próximos itens.</param>
      /// <returns><see langword="true"/> se os valores foram encontrados e o leitor avançou.</returns>
      public function TryAdvancePast(const next: TReadOnlySpan<T>): Boolean;

      /// <summary>
      /// Avança o leitor para além de instâncias consecutivas do valor <paramref name="value"/> dado.
      /// </summary>
      /// <returns>Quantas posições o leitor avançou</returns>
      public function AdvancePast(const value: T): Integer;

      /// <summary>
      /// Avança o leitor pelo número <paramref name="count"/> dado.
      /// </summary>
      public procedure Advance(const count: Integer); inline;

      /// <summary>
      /// Retrocede o leitor pelo número <paramref name="count"/> dado.
      /// </summary>
      public procedure Rewind(const count: Integer);

      /// <summary>
      /// Reseta o leitor para o início da sequência.
      /// </summary>
      public procedure Reset();

      /// <summary>
      /// Avança o leitor sem verificar os limites.
      /// </summary>
      /// <param name="count"></param>
      strict private procedure UnsafeAdvance(const count: Integer); inline;

      /// <summary>
      /// Faz um slice sem verificar os limites.
      /// </summary>
      strict private class procedure UncheckedSliceTo(var span: TReadOnlySpan<T>; const length: Integer); static; inline;

      /// <summary>
      /// Faz um slice sem verificar os limites.
      /// </summary>
      strict private class procedure UncheckedSlice(var span: TReadOnlySpan<T>; const start: Integer; const length: Integer); static; inline;
   end;

{$ENDREGION 'TSpanReader'}

implementation

uses
   RTLConsts,
//   Winapi.Windows,
   TypInfo;

{$REGION 'TReadOnlySpan<T>'}

{ TReadOnySpan<T> }

constructor TReadOnlySpan<T>.Create({$IFDEF FPC}constref{$ELSE}const [ref]{$ENDIF} array_: TArray<T>);
begin
    if (array_ = nil) then
    begin
      Self := Default(TReadOnlySpan<T>);
      Exit(); // returns default
    end;

    m_reference := @array_[0];
    m_length := System.Length(array_);
end;

constructor TReadOnlySpan<T>.Create({$IFDEF FPC}constref{$ELSE}const [ref]{$ENDIF} array_: TArray<T>; const start: Integer; const length: Integer);
begin
  m_reference := @array_[start];
  m_length := length;
end;

constructor TReadOnlySpan<T>.Create({$IFDEF FPC}constref{$ELSE}const [ref]{$ENDIF} pointer_: Pointer; const length: Integer);
begin
  m_reference := pointer_;
  m_length := length;
end;

constructor TReadOnlySpan<T>.Create({$IFDEF FPC}constref{$ELSE}const [ref]{$ENDIF} reference: T);
begin
  m_reference := @reference;
  m_length := 1;
end;

//constructor TReadOnlySpan<T>.Create({$IFDEF FPC}constref{$ELSE}const [ref]{$ENDIF} reference: T; const length: Integer);
//begin
//   Assert(length >= 0);
//   m_reference := @reference;
//   m_length := length;
//end;

function TReadOnlySpan<T>.GetIsEmpty(): Boolean;
begin
  Result := m_length = 0;
end;

class operator TReadOnlySpan<T>.NotEqual(const left: TReadOnlySpan<T>; const right: TReadOnlySpan<T>): Boolean;
begin
   Result := not (left = right);
end;

class operator TReadOnlySpan<T>.implicit(const array_: TArray<T>): TReadOnlySpan<T>;
begin
   Result := TReadOnlySpan<T>.Create(array_);
end;

class function TReadOnlySpan<T>.GetEmpty(): TReadOnlySpan<T>;
begin
   Result := default(TReadOnlySpan<T>);
end;

//class function TReadOnlySpan<T>.CastUp<TDerived>(const items: TReadOnlySpan<TDerived>): TReadOnlySpan<T>;
//begin
//   Result := TReadOnlySpan<T>.Create(items.m_reference, items.Length);
//end;

function TReadOnlySpan<T>.GetPinnableReference(): PReference;
begin
   // Certifique-se de que o código nativo tenha apenas um único desvio para frente que seja predicted-not-taken.
   var ret: PReference := nil;
   if (m_length <> 0) then
      ret := m_reference;

   Exit(ret);
end;

function TReadOnlySpan<T>.GetReference(): PReference;
begin
   Result := m_reference;
end;

class operator TReadOnlySpan<T>.Equal(const left: TReadOnlySpan<T>; const right: TReadOnlySpan<T>): Boolean;
begin
   Result := (left.m_length = right.m_length) and (left.m_reference = right.m_reference);
end;

function TReadOnlySpan<T>.ToString(): string;
begin
   if (TypeInfo(T) = TypeInfo(Char)) then
   begin
//TODO:      Exit(string.Create(TReadOnlySpan<Char>.Create(m_reference, m_length));
   end;

//   Exit('Se7e.ReadOnlySpan<' + GetTypeName(TypeInfo(T)) + '>[' + m_length.ToString() + ']');
end;

function TReadOnlySpan<T>.Slice(const start: Integer): TReadOnlySpan<T>;
begin
   if (UInt32(start) > UInt32(m_length)) then
      raise EArgumentOutOfRangeException.Create('');

  Result := TReadOnlySpan<T>.Create(PReference(PByte(m_reference) + sizeof(T) * start (* force zero-extension *)), m_length - start);
end;

function TReadOnlySpan<T>.Slice(const start: Integer; const length: Integer): TReadOnlySpan<T>;
begin
{$IFDEF CPUX64}
   // See comment in Span<T>.Slice for how this works.
   if (UInt64(UInt32(start)) + UInt64(UInt32(length)) > UInt64(UInt32(m_length)))then
      raise EArgumentOutOfRangeException.Create('');
{$ELSE}
   if (UInt32(start) > UInt32(m_length)) or (UInt32(length) > UInt32(m_length - start)) then
      raise EArgumentOutOfRangeException.Create('');
{$ENDIF}

   Result := TReadOnlySpan<T>.Create(PReference(PByte(m_reference) + sizeof(T) * start (* force zero-extension *)), length);
end;

function TReadOnlySpan<T>.ToArray(): TArray<T>;
begin
   if (m_length = 0) then
      Exit(Default(TArray<T>));

   var destination: TArray<T>;
   SetLength(destination, m_length);
   Move(m_reference, destination[0], UInt32(m_length));

   Exit(destination);
end;

function TReadOnlySpan<T>.GetItem(const index: Integer): T;
begin
   if (UInt32(index) >= UInt32(m_length)) then
      raise ERangeError.Create(SIndexOutOfRange);

  Result := PReference(PByte(m_reference) + sizeof(T) * index)^;
end;

function TReadOnlySpan<T>.IndexOf(const value: T): Integer;
begin
   raise ENotImplemented.Create('Error Message');
end;

function TReadOnlySpan<T>.StartsWith(const value: TReadOnlySpan<T>): Boolean;
begin
   raise ENotImplemented.Create('Error Message');
end;

function TReadOnlySpan<T>.IndexOfAnyExcept(const value: T): Integer;
begin
   raise ENotImplemented.Create('Error Message');
end;

function TReadOnlySpan<T>.GetEnumerator(): TEnumerator;
begin
   Result := TEnumerator.Create(Self)
end;


{$ENDREGION 'TReadOnlySpan<T>'}

{$REGION 'TSpan<T>'}

function TSpan<T>.GetPinnableReference(): PReference;
begin
   // Certifique-se de que o código nativo tenha apenas um único desvio para frente que seja predicted-not-taken.
   var ret: PReference := nil;
   if (m_length <> 0) then
      ret := m_reference;

   Exit(ret);
end;

function TSpan<T>.GetReference(): PReference;
begin
   Result := m_reference;
end;

{$ENDREGION 'TSpan<T>'}


{$REGION 'TEnumerator'}

{ TEnumerator }

function TReadOnlySpan<T>.TEnumerator.GetCurrent(): T;
begin
   Result := TReadOnlySpan<T>(_span^)[_index];
end;

constructor TReadOnlySpan<T>.TEnumerator.Create(const span: TReadOnlySpan<T>);
begin
   _span := @span;
   _index := -1;
end;

function TReadOnlySpan<T>.TEnumerator.MoveNext(): Boolean;
var
   NextIndex: Integer;
begin
   NextIndex := _index + 1;
   if NextIndex < (TReadOnlySpan<T>(_span^).Length) then
   begin
      _index := NextIndex;

      Exit(true);
   end;

   Exit(false);
end;

{$ENDREGION 'TEnumerator'}

{$REGION 'TOldSpan<T>'}

//{ TOldSpan<T> }
//
//constructor TOldSpan<T>.Create({$IFDEF FPC}constref{$ELSE}const [ref]{$ENDIF} &array: TArray<T>);
//begin
//    if (&array = nil) then
//    begin
//        m_reference := nil;
//        m_length := 0;
//        Exit(); // returns default
//    end;
//
//    if (not PTypeInfo(TypeInfo(T)).IsValueType and (PDynArrayTypeInfo(&array) <> TypeInfo(TArray<T>))) then
//      TThrowHelper.ThrowArrayTypeMismatchException();
//
//  m_reference := @&array[0];
//  m_length := System.Length(&array);
//end;
//
//constructor TOldSpan<T>.Create({$IFDEF FPC}constref{$ELSE}const [ref]{$ENDIF} reference: T);
//begin
//    Assert(length >= 0);
//
//    m_reference := @reference;
//    m_length := length;
//end;
//
//constructor TOldSpan<T>.Create({$IFDEF FPC}constref{$ELSE}const [ref]{$ENDIF} &array: TArray<T>; start, length: Integer);
//begin
//    if (&array = nil) then
//    begin
//        if (start <> 0) or (length <> 0) then
//            TThrowHelper.ThrowArgumentOutOfRangeException();
//
//        Self := Default(TOldSpan<T>);
//        Exit(); // returns default
//    end;
//
//    if (not PTypeInfo(TypeInfo(T)).IsValueType and (PDynArrayTypeInfo(&array) <> TypeInfo(TArray<T>))) then
//      TThrowHelper.ThrowArrayTypeMismatchException();
//
//{$IFDEF CPU64BITS}
//            // See comment in Span<T>.Slice for how this works.
//    if (UInt64(uint(start)) + UInt64(uint(length))) > UInt64(uint(System.Length(&array))) then
//                TThrowHelper.ThrowArgumentOutOfRangeException();
//{$ELSE}
//    if (NativeUInt(start) > NativeUInt(System.Length(&array))) or (NativeUInt(length) > NativeUInt(System.Length(&array) - start)) then
//        TThrowHelper.ThrowArgumentOutOfRangeException();
//{$ENDIF}
//
//    m_reference := @&array[start]; // TUnsafe.Add(TMemoryMarshal.GetArrayDataReference(&array), NativeUInt(NativeUInt(start)) (* force zero-extension *));
//    m_length := length;
//end;
//
//constructor TOldSpan<T>.Create({$IFDEF FPC}constref{$ELSE}const [ref]{$ENDIF} pointer: Pointer; length: Integer);
//begin
//    if (length < 0) then
//        TThrowHelper.ThrowArgumentOutOfRangeException();
//
//    m_reference := pointer;
//    m_length := length;
//end;
//
//constructor TOldSpan<T>.Create({$IFDEF FPC}constref{$ELSE}const [ref]{$ENDIF} &array: TArray<T>; start: Integer);
//begin
////    if (length < 0) then
////        TThrowHelper.ThrowArgumentOutOfRangeException();
//
//
//  Create(&array, start, System.length(&array) - start);
//
////    m_reference := @&array[0];
////    m_length := length;
//end;
//
//constructor TOldSpan<T>.Create({$IFDEF FPC}constref{$ELSE}const [ref]{$ENDIF} AValue: PReference; AStart, ALength: Integer);
//begin
//  m_reference := PReference(PByte(AValue) + sizeof(T) * AStart);
//  m_length := ALength;
//end;
//
//
//function TOldSpan<T>.IsEmpty: Boolean;
//begin
//  Result := m_length = 0;
//end;
//
//class operator TOldSpan<T>.NotEqual({$IFDEF FPC}constref{$ELSE}const [ref]{$ENDIF} left: TOldSpan<T>; {$IFDEF FPC}constref{$ELSE}const [ref]{$ENDIF} right: TOldSpan<T>): Boolean;
//begin
//  Result := not (left = right);
//end;
//
//function TOldSpan<T>.Slice(const start: Integer; const length: Integer): TOldSpan<T>;
//begin
//{$IF CPU64BITS}
//    // Since start and length are both 32-bit, their sum can be computed across a 64-bit domain
//    // without loss of fidelity. The cast to uint before the cast to ulong ensures that the
//    // extension from 32- to 64-bit is zero-extending rather than sign-extending. The end result
//    // of this is that if either input is negative or if the input sum overflows past Int32.MaxValue,
//    // that information is captured correctly in the comparison against the backing m_length field.
//    // We don't use this same mechanism in a 32-bit process due to the overhead of 64-bit arithmetic.
//    if ((ulong)(uint)start + (ulong)(uint)length > (ulong)(uint)m_length)
//        ThrowHelper.ThrowArgumentOutOfRangeException();
//{$ELSE}
//    if (uint(start) > uint(m_length)) or (uint(length) > uint(m_length - start)) then
//        TThrowHelper.ThrowArgumentOutOfRangeException();
//{$ENDIF}
//
//    Result := TOldSpan<T>.Create(m_reference, nint(uint(start)) {* force zero-extension *}, length);
//
//end;
//
//function TOldSpan<T>.Slice([ref] const start: Integer): TOldSpan<T>;
//begin
//    if uint(start) > uint(m_length) then
//        TThrowHelper.ThrowArgumentOutOfRangeException();
//
//    Result := TOldSpan<T>.Create(m_reference, start, m_length - start);
//end;
//
//function TOldSpan<T>.ToString(): string;
//begin
//    if (TypeInfo(T) = TypeInfo(char)) then
//    begin
////        Exit(string.Create(TReadOnlySpan<Char>.Create(m_reference, m_length));
//    end;
//
//    Exit('System.Span<' + GetTypeName(TypeInfo(T)) + '>[' + m_length.ToString() + ']');
//end;
//
//class function TOldSpan<T>.GetEmpty(): TOldSpan<T>;
//begin
//   Result := default(TOldSpan<T>);
//end;
//
//class operator TOldSpan<T>.Implicit({$IFDEF FPC}constref{$ELSE}const [ref]{$ENDIF} AValue: TArray<T>): TOldSpan<T>;
//begin
//  Result := TOldSpan<T>.Create(AValue);
//end;
//
//class operator TOldSpan<T>.Implicit({$IFDEF FPC}constref{$ELSE}const [ref]{$ENDIF} span: TOldSpan<T> ): TReadOnlySpan<T>;
//begin
//  Result := TReadOnlySpan<T>.Create(span.m_reference, span.m_length);
//end;
//
//class operator TOldSpan<T>.Implicit(const AValue: string): TOldSpan<T>;
//begin
//  raise Exception.Create('Error Message');
//end;
//
//class operator TOldSpan<T>.Equal({$IFDEF FPC}constref{$ELSE}const [ref]{$ENDIF} left: TOldSpan<T>; {$IFDEF FPC}constref{$ELSE}const [ref]{$ENDIF} right: TOldSpan<T>): Boolean;
//begin
//    Result := (left.m_length = right.m_length) and (left.m_reference = right.m_reference);
//end;
//
//class operator TOldSpan<T>.Explicit({$IFDEF FPC}constref{$ELSE}const [ref]{$ENDIF} AValue: TOldSpan<T>): TArray<T>;
//begin
//  raise Exception.Create('Error Message');
//end;
//
//class operator TOldSpan<T>.Implicit({$IFDEF FPC}constref{$ELSE}const [ref]{$ENDIF} AValue: TOldSpan<T>): string;
//begin
//  SetLength(Result, AValue.Length);
//  for var I: Integer := 0 to AValue.Length - 1 do
//    Result[I] := Char((@AValue.GetItem(I))^);
//end;
//
//function TOldSpan<T>.GetItem(const index: Integer): T;
//begin
//    if uint(index) >= uint(m_length) then
//        TThrowHelper.ThrowIndexOutOfRangeException();
//
//  Result := PReference(PByte(m_reference) + sizeof(T) * index)^;
//end;
//
//function TOldSpan<T>.SequenceEqual<T2>(const other: TReadOnlySpan<T2>): Boolean;
//begin
//    var length: Integer := Self.Length;
//    var otherLength: Integer := other.Length;
//
////    if (RuntimeHelpers.IsBitwiseEquatable<T>()) then
////    begin
////        return length == otherLength &&
////        SpanHelpers.SequenceEqual(
////            ref Unsafe.As<T, byte>(ref MemoryMarshal.GetReference(span)),
////            ref Unsafe.As<T, byte>(ref MemoryMarshal.GetReference(other)),
////            ((uint)otherLength) * (nuint)sizeof(T));  // If this multiplication overflows, the Span we got overflows the entire address range. There's no happy outcome for this api in such a case so we choose not to take the overhead of checking.
////    end;
//
////    Result := (length = otherLength) and TSpanHelpers.SequenceEqual<T>(PByte(Self.m_reference), PByte(other.m_reference), length);
//    Result := (length = otherLength);
//    if Result then
//    begin
//        for var index := 0 to length - 1 do
//        begin
//          var Item1: PByte := PByte(PByte(Self.m_reference) + sizeof(T) * index);
//          var Item2: PByte := PByte(@other.GetItem(index));
//          if Item1^ <> Item2^ then
//          begin
//              Exit(False);
//          end;
//        end;
//    end;
//
//end;
//
////function TOldSpan<T>.SequenceEqual<T>([ref] const other: TArray<T>): Boolean;
////begin
////  raise ENotSupportedException.Create('Error Message');
////end;
//
//procedure TOldSpan<T>.SetItem(const index: Integer; AValue: T);
//begin
//   PReference(PByte(m_reference) + sizeof(T) * index)^ := AValue;
//end;
//
//function TOldSpan<T>.IndexOf(const value: T): Integer;
//var
//  Index: Integer;
//  EqualityComparer: IEqualityComparer<T>;
//begin
//   Result := -1;
//   EqualityComparer :=  TEqualityComparer<T>.Default;
//
//   for Index := 0 to Length - 1 do
//   begin
//      if EqualityComparer.Equals(value, GetItem(Index)) then
//      begin
//        Exit(Index);
//      end;
//   end;
//end;
//
//function TOldSpan<T>.TryCopyTo(const destination: TOldSpan<T>): Boolean;
//begin
//   var retVal: Boolean := false;
//
//   if (UInt32(m_length) <= UInt32(destination.Length)) then
//   begin
//      Move(m_reference^, destination.m_reference^, m_length * SizeOf(T));
//      retVal := true;
//   end;
//
//   Result := retVal;
//end;
//
//procedure TOldSpan<T>.CopyTo(const destination: TOldSpan<T>);
//begin
//   if (UInt32(m_length) <= UInt32(destination.Length)) then
//   begin
//      Move(m_reference^, destination.m_reference^, m_length * SizeOf(T));
//   end
//   else
//   begin
//      TThrowHelper.ThrowArgumentException_DestinationTooShort();
//   end;
//
//end;

{$ENDREGION 'TOldSpan<T>'}

{$REGION 'TSpanReader'}

{ TSpanReader<T> }

constructor TSpanReader<T>.Create(span: TReadOnlySpan<T>);
begin
   m_span := span;
   m_unread := span;
end;


function TSpanReader<T>.GetPosition(): Integer;
begin
   Result := Span.Length - m_unread.Length;
end;

procedure TSpanReader<T>.SetPosition(const Value: Integer);
begin
   m_unread := Span.Slice(value);
end;

function TSpanReader<T>.TryReadTo(const delimiter: T; out span: TReadOnlySpan<T>): Boolean;
begin
   Result := TryReadTo(delimiter,  True , span)
end;

function TSpanReader<T>.TryReadTo(const delimiter: T; const advancePastDelimiter: Boolean; out span: TReadOnlySpan<T>): Boolean;
begin
   var found: Boolean := false;
   var index: Integer := m_unread.IndexOf(delimiter);
   span := default(TReadOnlySpan<T>);

   if (index <> -1) then
   begin
      found := true;
      if (index > 0) then
      begin
         span := m_unread;
         UncheckedSliceTo(span, index);
         if (advancePastDelimiter) then
         begin
            index := index + 1;

         end;
         UnsafeAdvance(index);
      end;
   end;

   Exit(found);
end;

function TSpanReader<T>.TryRead(out value: T): Boolean;
begin
   var success: Boolean;

   if (m_unread.IsEmpty) then
   begin
      value := Default(T);
      success := false;
   end
   else
   begin
      success := true;
      value := m_unread[0];
      UnsafeAdvance(1);
   end;

   Exit(success);
end;

function TSpanReader<T>.TryRead(const count: Integer; out span: TReadOnlySpan<T>): Boolean;
begin
   var success: Boolean;

   if (count > m_unread.Length) then
   begin
      span := Default(TReadOnlySpan<T>);
      success := false;
   end
   else
   begin
      success := true;
      span := m_unread.Slice(0, count);
      UnsafeAdvance(count);
   end;

   Exit(success);
end;

//function TSpanReader<T>.TryRead<TValue>(out value: TValue): Boolean;
//type
//   PValue = ^TValue;
//begin
//   if (SizeOf(TValue) < SizeOf(T)) or (SizeOf(TValue) mod SizeOf(T) <> 0) then
//   begin
//      raise EArgumentException.Create('O tamanho de ' + GetTypeName(TypeInfo(TValue)) + ' deve ser divisível igualmente pelo tamanho de ' + GetTypeName(TypeInfo(T)) + '.');
//   end;
//
//   var success: Boolean;
//
//   if (SizeOf(TValue) > m_unread.Length * SizeOf(T)) then
//   begin
//      value := Default(TValue);
//      success := False;
//   end
//   else
//   begin
//      success := True;
//      value := PValue(m_unread.m_reference)^;
//      UnsafeAdvance(SizeOf(TValue) div SizeOf(T));
//   end;
//
//   Exit(success);
//end;

//function TSpanReader<T>.TryRead<TValue>(const count: Integer; out value: TReadOnlySpan<TValue>): Boolean;
//begin
//   if (SizeOf(TValue) < SizeOf(T)) or (SizeOf(TValue) mod SizeOf(T) <> 0) then
//   begin
//      raise EArgumentException.Create('O tamanho de ' + GetTypeName(TypeInfo(TValue)) + ' deve ser divisível igualmente pelo tamanho de ' + GetTypeName(TypeInfo(T)) + '.');
//   end;
//
//   var success: Boolean;
//
//   if (SizeOf(TValue) * count > m_unread.Length * SizeOf(T)) then
//   begin
//      value := Default(TReadOnlySpan<TValue>);
//      success := false;
//   end
//   else
//   begin
//      success := true;
//      value := TReadOnlySpan<TValue>.Create(m_unread.m_reference, count);
//      UnsafeAdvance((SizeOf(TValue) div SizeOf(T)) * count);
//   end;
//
//   Exit(success);
//end;

//function TSpanReader<T>.IsNext(const next: TReadOnlySpan<T>): Boolean;
//begin
//   Result := m_unread.StartsWith(next)
//end;

function TSpanReader<T>.TryAdvancePast(const next: TReadOnlySpan<T>): Boolean;
var
   success: Boolean;
begin
   if (m_unread.StartsWith(next)) then
   begin
      UnsafeAdvance(next.Length);
      success := true;
   end
   else
   begin
      success := false;
   end;

   Exit(success);
end;

function TSpanReader<T>.AdvancePast(const value: T): Integer;
var
   count: Integer;
begin

   var index: Integer := m_unread.IndexOfAnyExcept(value);
   if (index = -1) then
   begin
      // Everything left is the value
      count := m_unread.Length;
      m_unread := Default(TReadOnlySpan<T>);
   end
   else if (index <> 0) then
   begin
      count := index;
      UnsafeAdvance(index);
   end;

   Exit(count);
end;

procedure TSpanReader<T>.Advance(const count: Integer);
begin
   m_unread := m_unread.Slice(count);
end;

procedure TSpanReader<T>.Rewind(const count: Integer);
begin
   m_unread := Span.Slice(Span.Length - m_unread.Length - count);
end;

procedure TSpanReader<T>.Reset();
begin
   m_unread := Span;
end;

procedure TSpanReader<T>.UnsafeAdvance(const count: Integer);
begin
   Assert(UInt32(count) <= UInt32(m_unread.Length));
   UncheckedSlice(m_unread, count, m_unread.Length - count);
end;

class procedure TSpanReader<T>.UncheckedSliceTo(var span: TReadOnlySpan<T>; const length: Integer);
begin
   Assert(UInt32(length) <= UInt32(span.Length));
   span := TReadOnlySpan<T>.Create(span.m_reference, length);
end;

class procedure TSpanReader<T>.UncheckedSlice(var span: TReadOnlySpan<T>; const start: Integer; const length: Integer);
begin
   raise ENotImplemented.Create('ainda não fiz isso');
   Assert((UInt32(start) <= UInt32(span.Length)) and (UInt32(length) <= UInt32((span.Length - start))));
//   span := TReadOnlySpan<T>.Create(span.m_reference + start, length);
end;

{$ENDREGION 'TSpanReader'}

end.
