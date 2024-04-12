// Marcelo Melo
// 23/03/2024

unit Se7e.Drawing.Gdiplus.Utils;

{$SCOPEDENUMS ON}
{$ZEROBASEDSTRINGS ON}
{$ALIGN 8}
{$MINENUMSIZE 4}

{$IFDEF CPUX64}
   {$DEFINE PUREPASCAL}
{$ENDIF}

{$IFDEF FPC}
  {$MODE DELPHI}
{$ENDIF}

interface

uses
   Windows,
   ActiveX,
   SysUtils,
   Math,
   StrUtils,
   Classes,
   TypInfo,
   Types;

type

//   TRectangle = Types.TRect;
//   TRectangleF = Types.TRectF;
   PInt16 = ^System.Int16;
   PInt32 = ^System.Int32;
   EArgumentNullException = SysUtils.EArgumentNilException;
   EInvalidOperationException = SysUtils.EInvalidOpException;
   TComManagedStream = Classes.TStreamAdapter;

{$IFDEF FPC}
   TGuidHelper = record helper for TGuid
     class function Empty: TGuid; static;
     class function Create(const Data; BigEndian: Boolean = False): TGuid; overload; static;
     class function Create(const Data: array of Byte; AStartIndex: Cardinal; BigEndian: Boolean = False): TGuid; overload; static;
     function IsEmpty: Boolean;
     function ToString: string;
   end;
{$ENDIF}

   { TArrayOfCharHelper }

   TArrayOfCharHelper = record helper for TArray<Char>
      strict private function GetLength(): Integer;
      strict private function GetIsEmpty(): Boolean;
      public property Length: Integer read GetLength;
      public property IsEmpty: Boolean read GetIsEmpty;
   end;

   { EInvalidEnumArgumentException }

   /// <summary>
   /// A exceção que é lançada ao usar argumentos inválidos que são enumeradores.
   /// </summary>
   EInvalidEnumArgumentException = class(EArgumentException)

		/// <summary>Inicializa uma nova instância da classe <see cref="T:System.ComponentModel.InvalidEnumArgumentException" /> com uma mensagem gerada com base no argumento, no valor inválido e em uma classe de enumeração.</summary>
		/// <param name="argumentName">O nome do argumento que causou a exceção.</param>
		/// <param name="invalidValue">O valor do argumento que falhou.</param>
		/// <param name="enumClass">Um <see cref="T:System.Type" /> que representa a classe de enumeração com os valores válidos.</param>
      public constructor Create(const argumentName: string; const invalidValue: Integer; const typeInfo: PTypeInfo);
   end;

   { TExceptionHelper }

   TExceptionHelper = class helper for SysUtils.Exception
      public constructor Create(); overload;
   end;

//   { TRectangleHelper }
//
//   TRectangleHelper = record helper for TRectangle
//   private
//      function GetX: Integer;
//      function GetY: Integer;
//      procedure SetX(const Value: Integer);
//      procedure SetY(const Value: Integer);
//   public
//      class function FromLTRB(const left, top, right, bottom: Integer): TRect; static;
//      property X: Integer read GetX write SetX;
//      property Y: Integer read GetY write SetY;
//
//      /// <summary>Initializes a new instance of the <see cref="T:System.WinDraw.Rectangle" /> class with the specified location and size.</summary>
//      /// <param name="location">A <see cref="T:System.WinDraw.Point" /> that represents the upper-left corner of the rectangular region. </param>
//      /// <param name="size">A <see cref="T:System.WinDraw.Size" /> that represents the width and height of the rectangular region. </param>
//      constructor Create(const location: TPoint; const size: TSize); overload;
//
//      constructor Create(const size: TSize); overload;
//
//      /// <summary>
//      /// Creates a <see cref='System.Drawing.Rectangle'/> that is inflated by the specified amount.
//      /// </summary>
//      public class function Inflate(const rect: TRect; const x: Integer; const y: Integer): TRect; overload; static;
//
//      /// <summary>
//      /// Inflates this <see cref='System.Drawing.Rectangle'/> by the specified amount.
//      /// </summary>
//      public procedure Inflate(width: Integer; height: Integer); overload;
//      public function ToString(): string;
//   end;
//
//   { TRectangleFHelper }
//
//   TRectangleFHelper = record helper for TRectangleF
//   private
//      function GetX: Single;
//      function GetY: Single;
//      procedure SetX(const Value: Single);
//      procedure SetY(const Value: Single);
//   public
//      class function FromLTRB(const left, top, right, bottom: Single): TRectangleF; static;
//      property X: Single read GetX write SetX;
//      property Y: Single read GetY write SetY;
//
//      /// <summary>Initializes a new instance of the <see cref="T:System.WinDraw.RectangleF" /> class with the specified location and size.</summary>
//      /// <param name="location">A <see cref="T:System.WinDraw.PointF" /> that represents the upper-left corner of the rectangular region. </param>
//      /// <param name="size">A <see cref="T:System.WinDraw.SizeF" /> that represents the width and height of the rectangular region. </param>
//      constructor Create(const location: TPointF; const size: TSizeF); overload;
//
//      constructor Create(const size: TSizeF); overload;
//
//      /// <summary>
//      /// Creates a <see cref='System.Drawing.RectangleF'/> that is inflated by the specified amount.
//      /// </summary>
//      public class function Inflate(const rect: TRectangleF; const x: Single; const y: Single): TRectangleF; overload; static;
//
//      /// <summary>
//      /// Inflates this <see cref='System.Drawing.RectangleF'/> by the specified amount.
//      /// </summary>
//      public procedure Inflate(width: Single; height: Single); overload;
//
//      public function ToString(): string;
//   end;
//
   { TSizeHelper }

   TSizeHelper = record helper for TSize
      public class function Empty: TSize; static;
      public function IsEmpty: Boolean;

      /// <summary>
      /// Initializes a new instance of the <see cref='TSize'/> class from the specified dimensions.
      /// </summary>
      public class function Create(): TSize; overload; static;


      /// <summary>
      /// Initializes a new instance of the <see cref='TSize'/> class from the specified dimensions.
      /// </summary>
      public constructor Create(const width: Integer; const height: Integer); overload;

      /// <summary>
      /// Initializes a new instance of the <see cref='TSize'/> class from the specified dimensions.
      /// </summary>
      public constructor Create(const width: Single; const height: Integer); overload;

      /// <summary>
      /// Initializes a new instance of the <see cref='TSize'/> class from the specified dimensions.
      /// </summary>
      public constructor Create(const width: Integer; const height: Single); overload;

      /// <summary>
      /// Initializes a new instance of the <see cref='TSize'/> class from the specified dimensions.
      /// </summary>
      public constructor Create(const width: Single; const height: Single); overload;

  end;

   { TSizeFHelper }

   TSizeFHelper = record helper for TSizeF
      public class function Empty(): TSizeF; static;
      public function IsEmpty(): Boolean;
   end;


  { TPointHelper }

  TPointHelper = record helper for TPoint
    public class function Create( XY : Integer ) : TPoint; overload; static; inline;
    public class function Empty: TPoint; static;
    public function IsEmpty: Boolean;
  end;

  { TPointFHelper }

  TPointFHelper = record helper for TPointF
    public class function Empty: TPointF; static;
    public function IsEmpty: Boolean;
  end;


   { TStreamHelper }

   TStreamHelper = class helper for TStream
      strict private function GetLength(): NativeInt;

//      // Nenhuma verificação de argumento é feita aqui. Depende de quem liga.
//      private function ReadAtLeastCore(var buffer: TArray<byte>; const minimumBytes: Integer; const throwOnEndOfStream: Boolean): Integer;

      /// <summary>
      /// Obtenha um wrapper <see cref="IStream"/> em torno do <paramref name="stream"/> fornecido.
      /// </summary>
      public function ToIStream(const makeSeekable: Boolean = false): IStream;

		/// <summary>Quando substituído em uma classe derivada, obtém o tamanho em bytes do fluxo.</summary>
		/// <returns>Um valor longo que representa o tamanho do fluxo em bytes.</returns>
		/// <exception cref="T:System.NotSupportedException">Uma classe derivada de <see langword="Stream" /> não dá suporte à busca.</exception>
		/// <exception cref="T:System.ObjectDisposedException">Foram chamados métodos depois que o fluxo foi fechado.</exception>
		public property Length: NativeInt read GetLength;

      /// <summary>
      /// Lê bytes do stream atual e avança a posição dentro do stream até que <paramref name="buffer"/> seja preenchido.
      /// </summary>
      /// <param name="buffer">Uma região de memória. Quando este método retorna, o conteúdo desta região é substituído pelos bytes lidos do fluxo atual.</param>
      /// <exception cref="EndOfStreamException">
      /// O final do stream é alcançado antes de preencher o <paramref name="buffer"/>.
      /// </exception>
      /// <remarks>
      /// Quando <paramref name="buffer"/> estiver vazio, esta operação de leitura será concluída sem esperar pelos dados disponíveis no stream.
      /// </remarks>
      public procedure ReadExactly(var buffer: TArray<byte>); overload;

      /// <summary>
      /// Lê <paramref name="count"/> número de bytes do fluxo atual e avança a posição dentro do fluxo.
      /// </summary>
      /// <param name="buffer">
      /// Uma matriz de bytes. Quando este método retorna, o buffer contém a matriz de bytes especificada com os valores
      /// entre <paramref name="offset"/> e (<paramref name="offset"/> + <paramref name="count"/> - 1) substituído
      /// pelos bytes lidos do fluxo atual.
      /// </param>
      /// <param name="offset">O deslocamento de bytes em <paramref name="buffer"/> no qual começar a armazenar os dados lidos do fluxo atual.</param>
      /// <param name="count">O número de bytes a serem lidos do fluxo atual.</param>
      /// <exception cref="ArgumentNullException"><paramref name="buffer"/> é <see langword="null"/>.</exception>
      /// <exception cref="ArgumentOutOfRangeException">
      /// <paramref name="offset"/> está fora dos limites de <paramref name="buffer"/>.
      /// -ou-
      /// <paramref name="count"/> é negativo.
      /// -ou-
      /// O intervalo especificado pela combinação de <paramref name="offset"/> e <paramref name="count"/> excede o
      /// comprimento de <paramref name="buffer"/>.
      /// </exception>
      /// <exception cref="EndOfStreamException">
      /// O final do fluxo é alcançado antes da leitura do <paramref name="count"/> número de bytes.
      /// </exception>
      /// <remarks>
      /// Quando <paramref name="count"/> for 0 (zero), esta operação de leitura será concluída sem esperar pelos dados disponíveis no stream.
      /// </remarks>
      public procedure ReadExactly(var buffer: TArray<byte>; const offset: Integer; const count: Integer); overload;
   end;

   { TLogFontWHelper }

   TLogFontWHelper = record helper for TLogFontW
      strict private function GetIsGdiVerticalFont(): Boolean;
      public property IsGdiVerticalFont: Boolean read GetIsGdiVerticalFont;
   end;

   { TMarshalHelper }

   TMarshalHelper = class helper for TMarshal
      private class function GetSystemMaxDBCSCharSize(): Integer; overload; static;

      //
      // Resumo:
      //     Aloca memória de memória não gerenciada do processo usando o ponteiro para o
      //     número de bytes especificado.
      //
      // Parâmetros:
      //   cb:
      //     O número necessário de bytes na memória.
      //
      // Devoluções:
      //     Um ponteiro para a memória recém-alocada. Essa memória deve ser liberada usando
      //     o método System.Runtime.InteropServices.Marshal.FreeHGlobal(System.IntPtr).
      //
      // Exceções:
      //   T:System.OutOfMemoryException:
      //     Não há memória suficiente para atender à solicitação.
      public class function AllocHGlobal(const cb: NativeInt): Pointer; overload; static;

      //
      // Resumo:
      //     Libera memória anteriormente alocada da memória não gerenciada do processo.
      //
      // Parâmetros:
      //   hglobal:
      //     O identificador retornado pela chamada original correspondente para System.Runtime.InteropServices.Marshal.AllocHGlobal(System.IntPtr).
      public class procedure FreeHGlobal(const hglobal: Pointer); static;

      //
      // Resumo:
      //     Copia o conteúdo de um System.String gerenciado para a memória não gerenciada,
      //     convertendo em formato ANSI durante a cópia.
      //
      // Parâmetros:
      //   s:
      //     Uma cadeia de caracteres gerenciada a ser copiada.
      //
      // Devoluções:
      //     O endereço, na memória não gerenciada, para o qual s foi copiado ou 0 se s for
      //     null.
      //
      // Exceções:
      //   T:System.OutOfMemoryException:
      //     Memória insuficiente.
      //
      //   T:System.ArgumentOutOfRangeException:
      //     O parâmetro s excede o tamanho máximo permitido pelo sistema operacional.
      public class function StringToHGlobalAnsi(const s: string): Pointer; static;

      //
      // Resumo:
      //     Representa o tamanho máximo de um tamanho DBCS (conjunto de caracteres de byte
      //     duplo), em bytes, para o sistema operacional atual. Este campo é somente leitura.
      public class property SystemMaxDBCSCharSize: Integer read GetSystemMaxDBCSCharSize;

      //
      // Resumo:
      //     Copia os dados de uma matriz de inteiro sem sinal unidimensional de 8 bits para
      //     um ponteiro de memória não gerenciado.
      //
      // Parâmetros:
      //   source:
      //     A matriz unidimensional a ser copiada.
      //
      //   startIndex:
      //     O índice baseado em zero na matriz de origem em que a cópia deve iniciar.
      //
      //   destination:
      //     O ponteiro de memória para o qual copiar.
      //
      //   length:
      //     O número de elementos da matriz a copiar.
      //
      // Exceções:
      //   T:System.ArgumentOutOfRangeException:
      //     startIndex e length não são válidos.
      //
      //   T:System.ArgumentNullException:
      //     source, startIndex, destination ou length é null.
      public class procedure Copy(const source: TArray<Byte>; const startIndex: NativeInt; const destination: Pointer; const length: Integer); overload; static;

      //
      // Resumo:
      //     Copia os dados de uma matriz de inteiro com sinal unidimensional de 16 bits para
      //     um ponteiro de memória não gerenciada.
      //
      // Parâmetros:
      //   source:
      //     A matriz unidimensional a ser copiada.
      //
      //   startIndex:
      //     O índice baseado em zero na matriz de origem em que a cópia deve iniciar.
      //
      //   destination:
      //     O ponteiro de memória para o qual copiar.
      //
      //   length:
      //     O número de elementos da matriz a copiar.
      //
      // Exceções:
      //   T:System.ArgumentOutOfRangeException:
      //     startIndex e length não são válidos.
      //
      //   T:System.ArgumentNullException:
      //     source, startIndex, destination ou length é null.
      public class procedure Copy(const source: TArray<Int16>; const startIndex: NativeInt; const destination: Pointer; const length: Integer); overload; static;

      //
      // Resumo:
      //     Lê um único byte da memória não gerenciada.
      //
      // Parâmetros:
      //   ptr:
      //     O endereço na memória não gerenciada do qual ler.
      //
      // Devoluções:
      //     O byte lido da memória não gerenciada.
      //
      // Exceções:
      //   T:System.AccessViolationException:
      //     ptr não é um formato reconhecido. ou - ptr é null. ou - ptr é inválido.
      public class function ReadByte(const ptr: Pointer): Byte; overload; static;

      //
      // Resumo:
      //     Lê um único byte em um determinado deslocamento (ou índice) de memória não gerenciada.
      //
      //
      // Parâmetros:
      //   ptr:
      //     O endereço básico na memória não gerenciada no qual a leitura será realizada.
      //
      //
      //   ofs:
      //     Um deslocamento de byte adicional, adicionado ao parâmetro ptr antes de ler.
      //
      //
      // Devoluções:
      //     O byte lido da memória não gerenciada em um determinado deslocamento.
      //
      // Exceções:
      //   T:System.AccessViolationException:
      //     O endereço básico (ptr) e o deslocamento de byte (ofs) produz um endereço nulo
      //     ou inválido.
      public class function ReadByte(const ptr: Pointer; const ofs: NativeInt): Byte; overload; static;

      //
      // Resumo:
      //     Lê um inteiro com sinal de 32 bits da memória não gerenciada.
      //
      // Parâmetros:
      //   ptr:
      //     O endereço na memória não gerenciada do qual ler.
      //
      // Devoluções:
      //     O inteiro com sinal de 32 bits da memória não gerenciada.
      //
      // Exceções:
      //   T:System.AccessViolationException:
      //     ptr não é um formato reconhecido. ou - ptr é null. ou - ptr é inválido.
      public class function ReadInt32(const ptr: Pointer): Int32; overload; static;

      //
      // Resumo:
      //     Lê um inteiro com sinal de 32 bits em um deslocamento fornecido na memória não
      //     gerenciada.
      //
      // Parâmetros:
      //   ptr:
      //     O endereço básico na memória não gerenciada no qual a leitura será realizada.
      //
      //
      //   ofs:
      //     Um deslocamento de byte adicional, adicionado ao parâmetro ptr antes de ler.
      //
      //
      // Devoluções:
      //     O inteiro com sinal de 32 bits da memória não gerenciada.
      //
      // Exceções:
      //   T:System.AccessViolationException:
      //     O endereço básico (ptr) e o deslocamento de byte (ofs) produz um endereço nulo
      //     ou inválido.
      public class function ReadInt32(const ptr: Pointer; const ofs: NativeInt): Int32; overload; static;

      //
      // Resumo:
      //     Grava um valor de byte único na memória não gerenciada.
      //
      // Parâmetros:
      //   ptr:
      //     O endereço a ser gravado na memória não gerenciada.
      //
      //   val:
      //     O valor a ser gravado.
      //
      // Exceções:
      //   T:System.AccessViolationException:
      //     ptr não é um formato reconhecido. ou - ptr é null. ou - ptr é inválido.
      public class procedure WriteByte(const ptr: Pointer; const val: byte); overload; static;

      //
      // Resumo:
      //     Grava um valor de byte único na memória não gerenciada em um deslocamento especificado.
      //
      //
      // Parâmetros:
      //   ptr:
      //     O endereço básico na memória não gerenciada no qual gravar.
      //
      //   ofs:
      //     Um deslocamento de byte adicional, que é adicionado para o parâmetro ptr antes
      //     de gravar.
      //
      //   val:
      //     O valor a ser gravado.
      //
      // Exceções:
      //   T:System.AccessViolationException:
      //     O endereço básico (ptr) e o deslocamento de byte (ofs) produz um endereço nulo
      //     ou inválido.
      public class procedure WriteByte(const ptr: Pointer; const ofs: NativeInt; const val: Byte); overload; static;

      //
      // Resumo:
      //     Grava um valor inteiro com sinal de 32 bits na memória não gerenciada em um deslocamento
      //     especificado.
      //
      // Parâmetros:
      //   ptr:
      //     O endereço básico na memória não gerenciada no qual gravar.
      //
      //   ofs:
      //     Um deslocamento de byte adicional, que é adicionado para o parâmetro ptr antes
      //     de gravar.
      //
      //   val:
      //     O valor a ser gravado.
      //
      // Exceções:
      //   T:System.AccessViolationException:
      //     O endereço básico (ptr) e o deslocamento de byte (ofs) produz um endereço nulo
      //     ou inválido.
      public class procedure WriteInt32(ptr: Pointer; ofs: NativeInt; val: Integer); overload; static;
   end;

// { TVector2 }
//
//   TVector2 = record
//   public
//      X: Single;
//      Y: Single;
//
//      constructor Create(AX, AY: Single);
//
//      // Métodos de instância
//      function Add(const B: TVector2): TVector2;
//      function Subtract(const B: TVector2): TVector2;
//      function Multiply(Scalar: Single): TVector2;
//      function Magnitude: Single;
//      function Normalize: TVector2;
//
//      // Operadores sobrecarregados
//      class operator Add(const A, B: TVector2): TVector2;
//      class operator Subtract(const A, B: TVector2): TVector2;
//      class operator Multiply(const A: TVector2; Scalar: Single): TVector2;
//      class operator Multiply(Scalar: Single; const A: TVector2): TVector2;
//
//      // Métodos estáticos utilitários
//      class function Distance(const A, B: TVector2): Single; static;
//      class function Dot(const A, B: TVector2): Single; static;
//   end;

   { TLogicalUtils }

   TLogicalUtils = class
      public class function HasFlag(const Flags: Int8; const CheckFlag: Int8): Boolean; overload;
      public class function HasFlag(const Flags: UInt8; const CheckFlag: UInt8): Boolean; overload;
      public class function HasFlag(const Flags: Int16; const CheckFlag: Int16): Boolean; overload;
      public class function HasFlag(const Flags: UInt16; const CheckFlag: UInt16): Boolean; overload;
      public class function HasFlag(const Flags: Int32; const CheckFlag: Int32): Boolean; overload;
      public class function HasFlag(const Flags: UInt32; const CheckFlag: UInt32): Boolean; overload;
      public class function HasFlag(const Flags: Int64; const CheckFlag: Int64): Boolean; overload;
      public class function HasFlag(const Flags: UInt64; const CheckFlag: UInt64): Boolean; overload;
      public class function HasFlag<T>(const Flags: T; const CheckFlag: T): Boolean; overload;
      public class function IfElse<T>(AValue: Boolean; const ATrue: T; const AFalse: T): T; overload;
      public class function IfElse(const AValue: Boolean; const ATrue: Pointer; const AFalse: Pointer): Pointer; overload;
      public class function IfElse(const AValue: Boolean; const ATrue: TObject; const AFalse: TObject): TObject; overload;
      public class function IfElse(const AValue: Boolean; const ATrue: TObject; const AFalse: Pointer): Pointer; overload;
   end;

function checked(const value: Int32): Int32; overload;
function unchecked(const value: Int32): Int32; overload;
function checked(const value: Int64): Int64; overload;
function unchecked(const value: Int64): Int64; overload;

/// <summary>
///   Aloca um 'pequeno' bloco de memória na pilha.
/// </summary>
function StackAlloc(Size: Integer): Pointer; register;

//function IfThen(AValue: Boolean; const ATrue: Pointer; AFalse: Pointer = nil): Pointer; overload;

implementation

{ TLogicalUtils }

class function TLogicalUtils.HasFlag(const Flags: Int8; const CheckFlag: Int8): Boolean;
begin
     Result:= (Flags and CheckFlag) = CheckFlag;
end;

class function TLogicalUtils.HasFlag(const Flags: UInt8; const CheckFlag: UInt8): Boolean;
begin
     Result:= (Flags and CheckFlag) = CheckFlag;
end;

class function TLogicalUtils.HasFlag(const Flags: Int16; const CheckFlag: Int16): Boolean;
begin
     Result:= (Flags and CheckFlag) = CheckFlag;
end;

class function TLogicalUtils.HasFlag(const Flags: UInt16; const CheckFlag: UInt16): Boolean;
begin
     Result:= (Flags and CheckFlag) = CheckFlag;
end;

class function TLogicalUtils.HasFlag(const Flags: Int32; const CheckFlag: Int32): Boolean;
begin
     Result:= (Flags and CheckFlag) = CheckFlag;
end;

class function TLogicalUtils.HasFlag(const Flags: UInt32; const CheckFlag: UInt32): Boolean;
begin
     Result:= (Flags and CheckFlag) = CheckFlag;
end;

class function TLogicalUtils.HasFlag(const Flags: Int64; const CheckFlag: Int64): Boolean;
begin
     Result:= (Flags and CheckFlag) = CheckFlag;
end;

class function TLogicalUtils.HasFlag(const Flags: UInt64; const CheckFlag: UInt64): Boolean;
begin
     Result:= (Flags and CheckFlag) = CheckFlag;
end;

class function TLogicalUtils.HasFlag<T>(const Flags: T; const CheckFlag: T): Boolean;
begin
   case SizeOf(T) of
      1: Result:= TLogicalUtils.HasFlag(PByte(@Flags)^, PByte(@CheckFlag)^);
      2: Result:= TLogicalUtils.HasFlag(PWord(@Flags)^, PWord(@CheckFlag)^);
      4: Result:= TLogicalUtils.HasFlag(PInteger(@Flags)^, PInteger(@CheckFlag)^);
      8: Result:= TLogicalUtils.HasFlag(PInt64(@Flags)^, PInt64(@CheckFlag)^);
   else
      Result := False;
   end;
end;

class function TLogicalUtils.IfElse<T>(AValue: Boolean; const ATrue: T; const AFalse: T): T;
begin
   if AValue then
      Result := ATrue
   else
      Result := AFalse;
end;

class function TLogicalUtils.IfElse(const AValue: Boolean; const ATrue: Pointer; const AFalse: Pointer): Pointer;
begin
   if AValue then
      Result := ATrue
   else
      Result := AFalse;
end;

class function TLogicalUtils.IfElse(const AValue: Boolean; const ATrue: TObject; const AFalse: TObject): TObject;
begin
   if AValue then
      Result := ATrue
   else
      Result := AFalse;
end;

class function TLogicalUtils.IfElse(const AValue: Boolean; const ATrue: TObject; const AFalse: Pointer): Pointer;
begin
   if AValue then
      Result := ATrue
   else
      Result := AFalse;
end;

function checked(const value: Int32): Int32;
begin
   Result := value;
end;

function unchecked(const value: Int32): Int32;
begin
   Result := value;
end;

function checked(const value: Int64): Int64;
begin
   Result := value;
end;

function unchecked(const value: Int64): Int64;
begin
   Result := value;
end;

{
  O StackAlloc aloca um bloco 'pequeno' de memória da pilha ao
  decrementar o SP. Isso proporciona a velocidade de alocação de uma variável local,
  mas a flexibilidade de tamanho em tempo de execução da memória alocada no heap.
 }

{$IFDEF PUREPASCAL}
function StackAlloc(Size: Integer): Pointer;
begin
  GetMem(Result, Size);
end;
{$ELSE !PUREPASCAL}
function StackAlloc(Size: Integer): Pointer; register; {$IFDEF FPC} assembler; nostackframe; {$ENDIF}
asm
{$IFDEF CPUX86}
        POP       ECX          // endereço de retorno
        MOV       EDX, ESP
        ADD       EAX, 3
        AND       EAX, not 3   // arredondar para cima para manter o ESP alinhado com dword
        CMP       EAX, 4092
        JLE       @@2
@@1:
        SUB       ESP, 4092
        PUSH      EAX          // make sure we touch guard page, to grow stack
        SUB       EAX, 4096
        JNS       @@1
        ADD       EAX, 4096
@@2:
        SUB       ESP, EAX
        MOV       EAX, ESP     // function result = low memory address of block
        PUSH      EDX          // save original SP, for cleanup
        MOV       EDX, ESP
        SUB       EDX, 4
        PUSH      EDX          // save current SP, for sanity check  (sp = [sp])
        PUSH      ECX          // return to caller
{$ELSE}
        {$IFNDEF FPC}
        .NOFRAME
        {$ENDIF}
        POP       R8           // return address
        MOV       RDX, RSP     // original SP
        ADD       ECX, 15
        AND       ECX, NOT 15  // round up to keep SP dqword aligned
        CMP       ECX, 4088
        JLE       @@2
@@1:
        SUB       RSP, 4088
        PUSH      RCX          // make sure we touch guard page, to grow stack
        SUB       ECX, 4096
        JNS       @@1
        ADD       ECX, 4096
@@2:
        SUB       RSP, RCX
        MOV       RAX, RSP     // function result = low memory address of block
        PUSH      RDX          // save original SP, for cleanup
        MOV       RDX, RSP
        SUB       RDX, 8
        PUSH      RDX          // save current SP, for sanity check  (sp = [sp])
        PUSH      R8           // return to caller
//{$ELSE}
//  ERROR - NOT IMPLEMENTED FOR THIS CPU
{$ENDIF}
end;
{$ENDIF PUREPASCAL}

//{ TRectangleHelper }
//
//constructor TRectangleHelper.Create(const location: TPoint; const size: TSize);
//begin
//	Self.X := location.X;
//	Self.Y := location.Y;
//	Self.Width := size.Width;
//	Self.height := size.Height;
//end;
//
//procedure TRectangleHelper.Inflate(width: Integer; height: Integer);
//begin
//   X := X - width;
//   Y := Y - height;
//
//   Width := Width + (2 * width);
//   Height := Height + (2 * height);
//end;
//
//function TRectangleHelper.ToString(): string;
//begin
//   Result := '{X=' + X.ToString() + ',Y=' + Y.ToString() + ',Width=' + Width.ToString() + ',Height=' + Height.ToString() + '}';
//end;
//
//class function TRectangleHelper.Inflate(const rect: TRectangle; const x: Integer; const y: Integer): TRectangle;
//begin
//   var r: TRectangle := rect;
//   r.Inflate(x, y);
//   Result := r;
//end;
//
//
//constructor TRectangleHelper.Create(const size: TSize);
//begin
//	Left := 0;
//	Top := 0;
//	Right := size.Width;
//	Bottom := size.Height;
//end;
//
//class function TRectangleHelper.FromLTRB(const left, top, right, bottom: Integer): TRectangle;
//begin
//  Result := TRectangle.Create(left, top, right - left, bottom - top);
//end;
//
//function TRectangleHelper.GetX: Integer;
//begin
//  Result := Left;
//end;
//
//function TRectangleHelper.GetY: Integer;
//begin
//  Result := Top;
//end;
//
//procedure TRectangleHelper.SetX(const Value: Integer);
//begin
//  Left := Value;
//end;
//
//procedure TRectangleHelper.SetY(const Value: Integer);
//begin
//  Top := Value;
//end;
//
//{ TRectangleFHelper }
//
//constructor TRectangleFHelper.Create(const location: TPointF; const size: TSizeF);
//begin
//	Self.X := location.X;
//	Self.Y := location.Y;
//	Self.Width := size.Width;
//	Self.height := size.Height;
//end;
//
//procedure TRectangleFHelper.Inflate(width: Single; height: Single);
//begin
//   X := X - width;
//   Y := Y - height;
//
//   Width := Width + (2 * width);
//   Height := Height + (2 * height);
//end;
//
//function TRectangleFHelper.ToString(): string;
//begin
//   Result := '{X=' + X.ToString() + ',Y=' + Y.ToString() + ',Width=' + Width.ToString() + ',Height=' + Height.ToString() + '}';
//end;
//
//class function TRectangleFHelper.Inflate(const rect: TRectangleF; const x: Single; const y: Single): TRectangleF;
//begin
//   var r: TRectangleF := rect;
//   r.Inflate(x, y);
//   Result := r;
//end;
//
//constructor TRectangleFHelper.Create(const size: TSizeF);
//begin
//	Left := 0;
//	Top := 0;
//	Right := size.Width;
//	Bottom := size.Height;
//end;
//
//class function TRectangleFHelper.FromLTRB(const left, top, right, bottom: Single): TRectangleF;
//begin
//  Result := TRectangleF.Create(left, top, right - left, bottom - top);
//end;
//
//function TRectangleFHelper.GetX: Single;
//begin
//  Result := Left;
//end;
//
//function TRectangleFHelper.GetY: Single;
//begin
//  Result := Top;
//end;
//
//procedure TRectangleFHelper.SetX(const Value: Single);
//begin
//  Left := Value;
//end;
//
//procedure TRectangleFHelper.SetY(const Value: Single);
//begin
//  Top := Value;
//end;

const
  EmptyPoint: TPoint = (x: 0; y: 0);
  EmptySize: TSize = (cx: 0; cy: 0);
  EmptySizeF: TSizeF = (cx: 0.0; cy: 0.0);
  EmptyPointF: TSizeF = (cx: 0.0; cy: 0.0);

{ TPointHelper }

class function TPointHelper.Create( XY : Integer ) : TPoint;
begin
  Result.X := XY;
  Result.Y := XY;
end;

class function TPointHelper.Empty: TPoint;
begin
  Result := EmptyPoint;
end;

function TPointHelper.IsEmpty: Boolean;
begin
  Result := (x = 0) and (y = 0);
end;

{ TPointFHelper }

class function TPointFHelper.Empty: TPointF;
begin
  Result := EmptyPointF;
end;

function TPointFHelper.IsEmpty: Boolean;
begin
  Result := (x = 0) and (y = 0);
end;

{ TSizeHelper }

class function TSizeHelper.Empty: TSize;
begin
  Result := EmptySize;
end;

function TSizeHelper.IsEmpty: Boolean;
begin
  Result := (cx = 0) and (cy = 0);
end;

class function TSizeHelper.Create(): TSize;
begin
   Result := TSize.Create(0, 0);
end;

constructor TSizeHelper.Create(const width: Integer; const height: Integer);
begin
  Self.cx := width;
  Self.cy := height;
end;

constructor TSizeHelper.Create(const width: Single; const height: Integer);
begin
  Self.cx := Integer(Trunc(width));
  Self.cy := height;
end;

constructor TSizeHelper.Create(const width: Integer; const height: Single);
begin
  Self.cx := width;
  Self.cy := Integer(Trunc(height));
end;

constructor TSizeHelper.Create(const width: Single; const height: Single);
begin
  Self.cx := Integer(Trunc(width));
  Self.cy := Integer(Trunc(height));
end;

{ TSizeFHelper }

class function TSizeFHelper.Empty(): TSizeF;
begin
  Result := EmptySizeF;
end;

function TSizeFHelper.IsEmpty(): Boolean;
begin
  Result := (cx = 0) and (cy = 0);
end;


{ TStreamHelper }

//function TStreamHelper.ReadAtLeastCore(var buffer: TArray<byte>; const minimumBytes: Integer; const throwOnEndOfStream: Boolean): Integer;
//begin
//  raise ENotImplemented.Create('Error Message');
//end;

procedure TStreamHelper.ReadExactly(var buffer: TArray<byte>);
begin
  raise ENotImplemented.Create('Error Message');
end;

procedure TStreamHelper.ReadExactly(var buffer: TArray<byte>; const offset, count: Integer);
begin
  raise ENotImplemented.Create('Error Message');
end;

function TStreamHelper.ToIStream(const makeSeekable: Boolean = false): IStream;
begin
   if Self = nil then
      raise EArgumentNullException.Create('stream');

   Result := TComManagedStream.Create(Self) as IStream;
end;

function TStreamHelper.GetLength(): NativeInt;
begin
   Result := Self.Size;
end;


{ TLogFontWHelper }

function TLogFontWHelper.GetIsGdiVerticalFont(): Boolean;
begin
   Result := Self.lfFaceName[0] = '@';
end;


{ TMarshalHelper }

class function TMarshalHelper.GetSystemMaxDBCSCharSize(): Integer;
begin
   Result := SizeOf(Char);
end;

class function TMarshalHelper.AllocHGlobal(const cb: NativeInt): Pointer;
begin
   Result := TMarshal.AllocMem(cb).ToPointer();
end;

class procedure TMarshalHelper.FreeHGlobal(const hglobal: Pointer);
begin
   System.FreeMem(hglobal);
end;

class function TMarshalHelper.StringToHGlobalAnsi(const s: string): Pointer;
begin
   Result := TMarshal.AllocStringAsAnsi(s).ToPointer();
end;

class procedure TMarshalHelper.Copy(const source: TArray<Byte>; const startIndex: NativeInt; const destination: Pointer; const length: Integer);
begin
   var PtrWrapper: TPtrWrapper := TPtrWrapper.Create(destination);
   TMarshal.Copy(source, startIndex, PtrWrapper, length);
end;

class procedure TMarshalHelper.Copy(const source: TArray<Int16>; const startIndex: NativeInt; const destination: Pointer; const length: Integer);
begin
   var PtrWrapper: TPtrWrapper := TPtrWrapper.Create(destination);
   TMarshal.Copy(source, startIndex, PtrWrapper, length);
end;

class function TMarshalHelper.ReadByte(const ptr: Pointer): Byte;
begin
   var PtrWrapper: TPtrWrapper := TPtrWrapper.Create(ptr);
   Result := TMarshal.ReadByte(PtrWrapper);
end;

class function TMarshalHelper.ReadByte(const ptr: Pointer; const ofs: NativeInt): Byte;
begin
   var PtrWrapper: TPtrWrapper := TPtrWrapper.Create(ptr);
   Result := TMarshal.ReadByte(PtrWrapper, ofs);
end;

class function TMarshalHelper.ReadInt32(const ptr: Pointer): Int32;
begin
   var PtrWrapper: TPtrWrapper := TPtrWrapper.Create(ptr);
   Result := TMarshal.ReadInt32(PtrWrapper);
end;

class function TMarshalHelper.ReadInt32(const ptr: Pointer; const ofs: NativeInt): Int32;
begin
   var PtrWrapper: TPtrWrapper := TPtrWrapper.Create(ptr);
   Result := TMarshal.ReadInt32(PtrWrapper, ofs);
end;

class procedure TMarshalHelper.WriteByte(const ptr: Pointer; const val: byte);
begin
   var PtrWrapper: TPtrWrapper := TPtrWrapper.Create(ptr);
   TMarshal.WriteByte(PtrWrapper, val);
end;

class procedure TMarshalHelper.WriteByte(const ptr: Pointer; const ofs: NativeInt; const val: Byte);
begin
   var PtrWrapper: TPtrWrapper := TPtrWrapper.Create(ptr);
   TMarshal.WriteByte(PtrWrapper, ofs, val);
end;

class procedure TMarshalHelper.WriteInt32(ptr: Pointer; ofs: NativeInt; val: Integer);
begin
   var PtrWrapper: TPtrWrapper := TPtrWrapper.Create(ptr);
   TMarshal.WriteInt32(PtrWrapper, ofs, val);
end;

{ EInvalidEnumArgumentException }

constructor EInvalidEnumArgumentException.Create(const argumentName: string; const invalidValue: Integer; const typeInfo: PTypeInfo);
begin
   inherited CreateFmt('O valor do argumento "%s" (%s) é inválido para o tipo Enum "%s".', [argumentName, GetEnumName(typeInfo, invalidValue), typeInfo^.Name]);
end;

 { TExceptionHelper }

 constructor TExceptionHelper.Create();
 begin
    inherited Create('');
 end;

// { TVector2 }
//
//constructor TVector2.Create(AX, AY: Single);
//begin
//  X := AX;
//  Y := AY;
//end;
//
//function TVector2.Add(const B: TVector2): TVector2;
//begin
//  Result := TVector2.Create(X + B.X, Y + B.Y);
//end;
//
//function TVector2.Subtract(const B: TVector2): TVector2;
//begin
//   Result := TVector2.Create(X - B.X, Y - B.Y);
//end;
//
//function TVector2.Multiply(Scalar: Single): TVector2;
//begin
//   Result := TVector2.Create(X * Scalar, Y * Scalar);
//end;
//
//function TVector2.Magnitude: Single;
//begin
//   Result := Sqrt(X * X + Y * Y);
//end;
//
//function TVector2.Normalize: TVector2;
//var
//   Mag: Single;
//begin
//   Mag := Magnitude;
//   if Mag > 0 then
//      Result := TVector2.Create(X / Mag, Y / Mag)
//   else
//      Result := TVector2.Create(0, 0);
//end;
//
//class operator TVector2.Add(const A, B: TVector2): TVector2;
//begin
//   Result := A.Add(B);
//end;
//
//class operator TVector2.Subtract(const A, B: TVector2): TVector2;
//begin
//   Result := A.Subtract(B);
//end;
//
//class operator TVector2.Multiply(const A: TVector2; Scalar: Single): TVector2;
//begin
//   Result := A.Multiply(Scalar);
//end;
//
//class operator TVector2.Multiply(Scalar: Single; const A: TVector2): TVector2;
//begin
//   Result := A.Multiply(Scalar);
//end;
//
//class function TVector2.Distance(const A, B: TVector2): Single;
//begin
//   Result := (B - A).Magnitude;
//end;
//
//class function TVector2.Dot(const A, B: TVector2): Single;
//begin
//   Result := A.X * B.X + A.Y * B.Y;
//end;

{$IFDEF FPC}

{ TGuidHelper }

class function TGuidHelper.Create(const Data; BigEndian: Boolean): TGuid;
begin
  Result := PGuid(@Data)^;
  if BigEndian then
  begin
    Result.D1 := (Swap(Word(Result.D1)) shl 16) or Swap(Word(Result.D1 shr 16));
    Result.D2 := Swap(Result.D2);
    Result.D3 := Swap(Result.D3);
  end;
end;

class function TGuidHelper.Create(const Data: array of Byte; AStartIndex: Cardinal; BigEndian: Boolean): TGuid;
begin
  if Length(Data) < Integer(16 + AStartIndex) then
    Result := TGuid.Empty
  else
    Result := TGuid.Create(Data[AStartIndex], BigEndian);
end;

class function TGuidHelper.Empty: TGuid;
begin
  FillChar(Result, Sizeof(Result), 0);
end;

function TGuidHelper.IsEmpty: Boolean;
{$IFDEF CPU64BITS}
var
  a: PInt64Array;
begin
  a := PInt64Array(@Self);
  Result := (a^[0] = 0) and (a^[1] = 0);
end;
{$ELSE !CPU64BITS}
var
  a: PIntegerArray;
begin
  a := PIntegerArray(@Self);
  Result := (a^[0] = 0) and (a^[1] = 0) and (a^[2] = 0) and (a^[3] = 0);
end;
{$ENDIF !CPU64BITS}

function TGuidHelper.ToString: string;
begin
  Result := GuidToString(Self);
end;
{$ENDIF}

{ TArrayOfCharHelper }

function TArrayOfCharHelper.GetLength(): Integer;
begin
   Result := System.Length(Self);
end;

function TArrayOfCharHelper.GetIsEmpty(): Boolean;
begin
   Result := System.Length(Self) = 0;
end;


end.
