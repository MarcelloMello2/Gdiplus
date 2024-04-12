// Marcelo Melo
// 06/04/2024

unit Se7e.Drawing.Rectangle;

{$SCOPEDENUMS ON}
{$ZEROBASEDSTRINGS ON}
{$ALIGN 8}
{$MINENUMSIZE 4}

{$IFDEF FPC}
  {$MODE DELPHI}
{$ENDIF}

interface

uses
   System.SysUtils,
   System.Types,
   System.Math,
   Se7e.Numerics;

type

{$REGION 'TRectangleF'}

   { TRectangleF }

   /// <summary>
   /// Armazena a localização e o tamanho de uma região retangular.
   /// </summary>
   TRectangleF = record

      /// <summary>
      /// Inicializa uma nova instância da classe <see cref='TRectangleF'/>.
      /// </summary>
      public class var Empty: TRectangleF;

      strict private m_x: Single;
      strict private m_y: Single;
      strict private m_width: Single;
      strict private m_height: Single;
      strict private function GetLocation(): TPointF;
      strict private procedure SetLocation(const Value: TPointF);

      /// <summary>
      /// Obtém ou define as coordenadas do canto superior esquerdo da região retangular representada por este
      /// <see cref='TRectangleF'/>.
      /// </summary>
      public property Location: TPointF read GetLocation write SetLocation;
      strict private function GetSize(): TSizeF;
      strict private procedure SetSize(const Value: TSizeF);

      /// <summary>
      /// Obtém ou define o tamanho deste <see cref='TRectangleF'/>.
      /// </summary>
      public property TSize: TSizeF read GetSize write SetSize;
      strict private function GetX(): Single;
      strict private procedure SetX(const Value: Single);


      /// <summary>
      /// Obtém ou define a coordenada x do canto superior esquerdo da região retangular definida por este
      /// <see cref='TRectangleF'/>.
      /// </summary>
      public property X: Single read GetX write SetX;
      strict private function GetY(): Single;
      strict private procedure SetY(const Value: Single);


      /// <summary>
      /// Obtém ou define a coordenada y do canto superior esquerdo da região retangular definida por este
      /// <see cref='TRectangleF'/>.
      /// </summary>
      public property Y: Single read GetY write SetY;
      strict private function GetWidth(): Single;
      strict private procedure SetWidth(const Value: Single);


      /// <summary>
      /// Obtém ou define a largura da região retangular definida por este <see cref='TRectangleF'/>.
      /// </summary>
      public property Width: Single read GetWidth write SetWidth;
      strict private function GetHeight(): Single;
      strict private procedure SetHeight(const Value: Single);


      /// <summary>
      /// Obtém ou define a altura da região retangular definida por este <see cref='TRectangleF'/>.
      /// </summary>
      public property Height: Single read GetHeight write SetHeight;
      strict private function GetLeft(): Single;


      /// <summary>
      /// Obtém a coordenada x do canto superior esquerdo da região retangular definida por este
      /// <see cref='TRectangleF'/> .
      /// </summary>
      public property Left: Single read GetLeft;
      strict private function GetTop(): Single;


      /// <summary>
      /// Obtém a coordenada y do canto superior esquerdo da região retangular definida por este
      /// <see cref='TRectangleF'/>.
      /// </summary>
      public property Top: Single read GetTop;
      strict private function GetRight(): Single;


      /// <summary>
      /// Obtém a coordenada x do canto inferior direito da região retangular definida por este
      /// <see cref='TRectangleF'/>.
      /// </summary>
      public property Right: Single read GetRight;
      strict private function GetBottom(): Single;


      /// <summary>
      /// Obtém a coordenada y do canto inferior direito da região retangular definida por este
      /// <see cref='TRectangleF'/>.
      /// </summary>
      public property Bottom: Single read GetBottom;
      strict private function GetIsEmpty(): Boolean;


      /// <summary>
      /// Testa se este <see cref='TRectangleF'/> possui uma <see cref='Width'/> ou uma <see cref='Height'/> igual a 0.
      /// </summary>
      public property IsEmpty: Boolean read GetIsEmpty;


      /// <summary>
      /// Inicializa uma nova instância da classe <see cref='TRectangleF'/> com a localização
      /// e tamanho especificados.
      /// </summary>
      public constructor Create(const x: Single; const y: Single; const width: Single; const height: Single); overload;


      /// <summary>
      /// Inicializa uma nova instância da classe <see cref='TRectangleF'/> com a localização
      /// e tamanho especificados.
      /// </summary>
      public constructor Create(const location: TPointF; const size: TSizeF); overload;


      /// <summary>
      /// Inicializa uma nova instância da estrutura <see cref='TRectangleF'/> a partir do especificado
      /// <see cref="Vector4"/>.
      /// </summary>
      public constructor Create(const vector: TVector4); overload;


      /// <summary>
      /// Cria um novo <see cref="Vector4"/> a partir deste <see cref="TRectangleF"/>.
      /// </summary>
      public function ToVector4(): TVector4;


      /// <summary>
      /// Cria um novo <see cref='TRectangleF'/> com a localização e tamanho especificados.
      /// </summary>
      public class function FromLTRB(const left: Single; const top: Single; const right: Single; const bottom: Single): TRectangleF; static;


      /// <summary>
      /// Testa se <paramref name="other"/> é um <see cref='TRectangleF'/> com a mesma localização e
      /// tamanho deste <see cref='TRectangleF'/>.
      /// </summary>
      public function Equals(const other: TRectangleF): Boolean; overload;


      /// <summary>
      /// Determina se o ponto especificado está contido dentro da região retangular definida por este
      /// <see cref='TRectangle'/> .
      /// </summary>
      public function Contains(const x: Single; const y: Single): Boolean; overload;


      /// <summary>
      /// Determina se o ponto especificado está contido dentro da região retangular definida por este
      /// <see cref='TRectangle'/> .
      /// </summary>
      public function Contains(const pt: TPointF): Boolean; overload;


      /// <summary>
      /// Determina se a região retangular representada por <paramref name="rect"/> está inteiramente contida dentro
      /// da região retangular representada por este <see cref='TRectangle'/> .
      /// </summary>
      public function Contains(const rect: TRectangleF): Boolean; overload;


      /// <summary>
      /// Infla este <see cref='TRectangle'/> pela quantidade especificada.
      /// </summary>
      public procedure Inflate(const x: Single; const y: Single); overload;


      /// <summary>
      /// Infla este <see cref='TRectangle'/> pela quantidade especificada.
      /// </summary>
      public procedure Inflate(const size: TSizeF); overload;


      /// <summary>
      /// Cria um <see cref='TRectangle'/> que é inflado pela quantidade especificada.
      /// </summary>
      public class function Inflate(const rect: TRectangleF; const x: Single; const y: Single): TRectangleF; overload; static;


      /// <summary>
      /// Cria um TRectangle que representa a interseção entre este TRectangle e rect.
      /// </summary>
      public procedure Intersect(const rect: TRectangleF); overload;


      /// <summary>
      /// Cria um retângulo que representa a interseção entre a e b. Se não houver interseção, um
      /// retângulo vazio é retornado.
      /// </summary>
      public class function Intersect(const a: TRectangleF; const b: TRectangleF): TRectangleF; overload; static;


      /// <summary>
      /// Determina se este retângulo intersecta com rect.
      /// </summary>
      public function IntersectsWith(const rect: TRectangleF): Boolean;


      /// <summary>
      /// Cria um retângulo que representa a união entre a e b.
      /// </summary>
      public class function Union(const a: TRectangleF; const b: TRectangleF): TRectangleF; static;


      /// <summary>
      /// Ajusta a localização deste retângulo pela quantidade especificada.
      /// </summary>
      public procedure Offset(const pos: TPointF); overload;


      /// <summary>
      /// Ajusta a localização deste retângulo pela quantidade especificada.
      /// </summary>
      public procedure Offset(const x: Single; const y: Single); overload;


      /// <summary>
      /// Converte a <see cref='Location'/> e <see cref='TSize'/>
      /// deste <see cref='TRectangleF'/> em uma string legível por humanos.
      /// </summary>
      public function ToString(): string;


      /// <summary>
      /// Testa se dois objetos <see cref='TRectangleF'/> têm localização e tamanho iguais.
      /// </summary>
      class operator Equal(const left: TRectangleF; const right: TRectangleF): Boolean; static;


      /// <summary>
      /// Testa se dois objetos <see cref='TRectangleF'/> diferem em localização ou tamanho.
      /// </summary>
      class operator NotEqual(const left: TRectangleF; const right: TRectangleF): Boolean; static;


      /// <summary>
      /// Converte o especificado <see cref="TRectangleF"/> em um <see cref="Vector4"/>.
      /// </summary>
      class operator explicit(const rectangle: TRectangleF): TVector4;


      /// <summary>
      /// Converte o especificado <see cref="Vector2"/> em um <see cref="TRectangleF"/>.
      /// </summary>
      class operator explicit(const vector: TVector4): TRectangleF;
   end;
   PRectangleF = ^TRectangleF;

{$ENDREGION 'TRectangleF'}

{$REGION 'TRectangle'}

   { TRectangle }

   /// <summary>
   /// Armazena a localização e o tamanho de uma região retangular.
   /// </summary>
   TRectangle = record(*IEquatable<TRectangle>*)
       public class var Empty: TRectangle;

      strict private m_x: Integer;
      strict private m_y: Integer;
      strict private m_width: Integer;
      strict private m_height: Integer;
      strict private function GetLocation(): TPoint;
      strict private procedure SetLocation(const Value: TPoint);

      /// <summary>
      /// Obtém ou define as coordenadas do canto superior esquerdo da região retangular representada por este
      /// <see cref='TRectangle'/>.
      /// </summary>
      public property Location: TPoint read GetLocation write SetLocation;

      strict private function GetSize(): TSize;
      strict private procedure SetSize(const Value: TSize);

      /// <summary>
      /// Obtém ou define o tamanho deste <see cref='TRectangle'/>.
      /// </summary>
      public property Size: TSize read GetSize write SetSize;

      strict private function GetX(): Integer;
      strict private procedure SetX(const Value: Integer);

      /// <summary>
      /// Obtém ou define a coordenada x do canto superior esquerdo da região retangular definida por este
      /// <see cref='TRectangle'/>.
      /// </summary>
      public property X: Integer read GetX write SetX;

      strict private function GetY(): Integer;
      strict private procedure SetY(const Value: Integer);

      /// <summary>
      /// Obtém ou define a coordenada y do canto superior esquerdo da região retangular definida por este
      /// <see cref='TRectangle'/>.
      /// </summary>
      public property Y: Integer read GetY write SetY;
      strict private function GetWidth(): Integer;

      strict private procedure SetWidth(const Value: Integer);

      /// <summary>
      /// Obtém ou define a largura da região retangular definida por este <see cref='TRectangle'/>.
      /// </summary>
      public property Width: Integer read GetWidth write SetWidth;
      strict private function GetHeight(): Integer;
      strict private procedure SetHeight(const Value: Integer);


      /// <summary>
      /// Obtém ou define a largura da região retangular definida por este <see cref='TRectangle'/>.
      /// </summary>
      public property Height: Integer read GetHeight write SetHeight;

      strict private function GetLeft(): Integer;

      /// <summary>
      /// Obtém a coordenada x do canto superior esquerdo da região retangular definida por este
      /// <see cref='TRectangle'/> .
      /// </summary>
      public property Left: Integer read GetLeft;

      strict private function GetTop(): Integer;

      /// <summary>
      /// Obtém a coordenada y do canto superior esquerdo da região retangular definida por este
      /// <see cref='TRectangle'/>.
      /// </summary>
      public property Top: Integer read GetTop;

      strict private function GetRight(): Integer;

      /// <summary>
      /// Obtém a coordenada x do canto inferior direito da região retangular definida por este
      /// <see cref='TRectangle'/>.
      /// </summary>
      public property Right: Integer read GetRight;

      strict private function GetBottom(): Integer;

      /// <summary>
      /// Obtém a coordenada y do canto inferior direito da região retangular definida por este
      /// <see cref='TRectangle'/>.
      /// </summary>
      public property Bottom: Integer read GetBottom;

      strict private function GetIsEmpty(): Boolean;

      /// <summary>
      /// Testa se este <see cref='TRectangle'/> tem uma <see cref='Width'/>
      /// ou uma <see cref='Height'/> de 0.
      /// </summary>
      public property IsEmpty: Boolean read GetIsEmpty;

      /// <summary>
      /// Inicializa uma nova instância da classe <see cref='TRectangle'/> com a localização
      /// e tamanho especificados.
      /// </summary>
      public constructor Create(const x: Integer; const y: Integer; const width: Integer; const height: Integer); overload;

      /// <summary>
      /// Inicializa uma nova instância da classe TRectangle com a localização e tamanho especificados.
      /// </summary>
      public constructor Create(const location: TPoint; const size: TSize); overload;

      /// <summary>
      /// Cria um novo <see cref='TRectangle'/> com a localização e tamanho especificados.
      /// </summary>
      public class function FromLTRB(const left: Integer; const top: Integer; const right: Integer; const bottom: Integer): TRectangle; static;

      /// <summary>
      /// Testa se <paramref name="other"/> é um <see cref='TRectangle'/> com a mesma localização
      /// e tamanho deste TRectangle.
      /// </summary>
      public function Equals(const other: TRectangle): Boolean; overload;

      /// <summary>
      /// Converte um TRectangleF em um TRectangle executando uma operação de arredondamento para cima em todas as coordenadas.
      /// </summary>
      public class function Ceiling(const value: TRectangleF): TRectangle; static;

      /// <summary>
      /// Converte um TRectangleF em um TRectangle realizando uma operação de truncamento em todas as coordenadas.
      /// </summary>
      public class function Truncate(const value: TRectangleF): TRectangle; static;


      /// <summary>
      /// Converte um TRectangleF em um TRectangle realizando uma operação de arredondamento em todas as coordenadas.
      /// </summary>
      public class function Round(const value: TRectangleF): TRectangle; static;


      /// <summary>
      /// Determina se o ponto especificado está contido dentro da região retangular definida por este
      /// <see cref='TRectangle'/> .
      /// </summary>
      public function Contains(const x: Integer; const y: Integer): Boolean; overload;


      /// <summary>
      /// Determina se o ponto especificado está contido dentro da região retangular definida por este
      /// <see cref='TRectangle'/> .
      /// </summary>
      public function Contains(const pt: TPoint): Boolean; overload;


      /// <summary>
      /// Determina se a região retangular representada por <paramref name="rect"/> está inteiramente contida dentro da
      /// região retangular representada por este <see cref='TRectangle'/> .
      /// </summary>
      public function Contains(const rect: TRectangle): Boolean; overload;

      /// <summary>
      /// Infla este <see cref='TRectangle'/> pela quantidade especificada.
      /// </summary>
      public procedure Inflate(const width: Integer; const height: Integer); overload;


      /// <summary>
      /// Infla este <see cref='TRectangle'/> pela quantidade especificada.
      /// </summary>
      public procedure Inflate(const size: TSize); overload;


      /// <summary>
      /// Cria um <see cref='TRectangle'/> que é inflado pela quantidade especificada.
      /// </summary>
      public class function Inflate(const rect: TRectangle; const x: Integer; const y: Integer): TRectangle; overload; static;


      /// <summary>
      /// Cria um TRectangle que representa a interseção entre este TRectangle e rect.
      /// </summary>
      public procedure Intersect(const rect: TRectangle); overload;


      /// <summary>
      /// Cria um retângulo que representa a interseção entre a e b. Se não houver interseção, um
      /// retângulo vazio é retornado.
      /// </summary>
      public class function Intersect(const a: TRectangle; const b: TRectangle): TRectangle; overload; static;


      /// <summary>
      /// Determina se este retângulo intersecta com rect.
      /// </summary>
      public function IntersectsWith(const rect: TRectangle): Boolean;


      /// <summary>
      /// Cria um retângulo que representa a união entre a e b.
      /// </summary>
      public class function Union(const a: TRectangle; const b: TRectangle): TRectangle; static;


      /// <summary>
      /// Ajusta a localização deste retângulo pela quantidade especificada.
      /// </summary>
      public procedure Offset(const pos: TPoint); overload;


      /// <summary>
      /// Ajusta a localização deste retângulo pela quantidade especificada.
      /// </summary>
      public procedure Offset(const x: Integer; const y: Integer); overload;


      /// <summary>
      /// Converte os atributos deste <see cref='TRectangle'/> para uma string de fácil leitura.
      /// </summary>
      public function ToString(): string;


      /// <summary>
      /// Testa se dois objetos <see cref='TRectangle'/> têm localização e tamanho iguais.
      /// </summary>
      class operator Equal(const left: TRectangle; const right: TRectangle): Boolean; static;


      /// <summary>
      /// Testa se dois objetos <see cref='TRectangle'/> diferem em localização ou tamanho.
      /// </summary>
      class operator NotEqual(const left: TRectangle; const right: TRectangle): Boolean; static;
   end;
   PRectangle = ^TRectangle;

{$ENDREGION 'TRectangle'}

{$REGION 'TRectangleFExtensions'}

   { TRectangleFExtensions }

   TRectangleFExtensions = record helper for TRectangleF
      /// <summary>
      /// Converte o especificado <see cref='TRectangle'/> em um
      /// <see cref='TRectangleF'/>.
      /// </summary>
      class operator implicit(const r: TRectangle): TRectangleF;
   end;

{$ENDREGION 'TRectangleFExtensions'}

{$REGION 'System.Types.TRectExtensions'}

   { TRectExtensions }

   TRectExtensions = record helper for System.Types.TRect

      /// <summary>
      /// Converte o especificado <see cref='System.Types.TRect'/> em um
      /// <see cref='Se7e.Drawing.Rectangle.TRectangle'/>.
      /// </summary>
      class operator implicit(const value: System.Types.TRect): Se7e.Drawing.Rectangle.TRectangle;

      /// <summary>
      /// Converte o especificado <see cref='System.Types.TRect'/> em um
      /// <see cref='Se7e.Drawing.Rectangle.TRectangleF'/>.
      /// </summary>
      class operator implicit(const value: System.Types.TRect): Se7e.Drawing.Rectangle.TRectangleF;

      /// <summary>
      /// Converte o especificado <see cref='Se7e.Drawing.Rectangle.TRectangle'/> em um
      /// <see cref='System.Types.TRect'/>.
      /// </summary>
      class operator implicit(const value: Se7e.Drawing.Rectangle.TRectangle): System.Types.TRect;
   end;

{$ENDREGION 'System.Types.TRectExtensions'}

{$REGION 'System.Types.TRectFExtensions'}

   { TRectFExtensions }

   TRectFExtensions = record helper for System.Types.TRectF

      /// <summary>
      /// Converte o especificado <see cref='System.Types.TRectF'/> em um
      /// <see cref='Se7e.Drawing.Rectangle.TRectangleF'/>.
      /// </summary>
      class operator implicit(const value: System.Types.TRectF): Se7e.Drawing.Rectangle.TRectangleF;

{
      /// <summary>
      /// Converte o especificado <see cref='System.Types.TRectF'/> em um
      /// <see cref='TRectangle'/>.
      /// </summary>
      class operator implicit(const value: System.Types.TRectF): Se7e.Drawing.Rectangle.TRectangle;
}

      /// <summary>
      /// Converte o especificado <see cref='Se7e.Drawing.Rectangle.TRectangleF'/> em um
      /// <see cref='System.Types.TRectF'/>.
      /// </summary>
      class operator implicit(const value: Se7e.Drawing.Rectangle.TRectangleF): System.Types.TRectF;
   end;

{$ENDREGION 'System.Types.TRectFExtensions'}

implementation

{$REGION 'TRectangleF'}

{ TRectangleF }

function TRectangleF.GetLocation(): TPointF;
begin
   Result := TPointF.Create(X, Y);
end;

procedure TRectangleF.SetLocation(const Value: TPointF);
begin
   X := value.X;
   Y := value.Y;
end;

function TRectangleF.GetSize(): TSizeF;
begin
   Result := TSizeF.Create(Width, Height);
end;

procedure TRectangleF.SetSize(const Value: TSizeF);
begin
   Width := value.Width;
   Height := value.Height;
end;

function TRectangleF.GetX(): Single;
begin
   Result := m_x;
end;

procedure TRectangleF.SetX(const Value: Single);
begin
   m_x := value;
end;

function TRectangleF.GetY(): Single;
begin
   Result := m_y;
end;

procedure TRectangleF.SetY(const Value: Single);
begin
   m_y := value;
end;

function TRectangleF.GetWidth(): Single;
begin
   Result := m_width;
end;

procedure TRectangleF.SetWidth(const Value: Single);
begin
   m_width := value;
end;

function TRectangleF.GetHeight(): Single;
begin
   Result := m_height;
end;

procedure TRectangleF.SetHeight(const Value: Single);
begin
   m_height := value;
end;

function TRectangleF.GetLeft(): Single;
begin
   Result := Self.X;
end;

function TRectangleF.GetTop(): Single;
begin
   Result := Self.Y;
end;

function TRectangleF.GetRight(): Single;
begin
   Result := Self.X + Self.Width;
end;

function TRectangleF.GetBottom(): Single;
begin
   Result := Self.Y + Self.Height;
end;

function TRectangleF.GetIsEmpty(): Boolean;
begin
   Result := (Self.Width <= 0) or (Self.Height <= 0);
end;

constructor TRectangleF.Create(const x: Single; const y: Single; const width: Single; const height: Single);
begin
   m_x := x;
   m_y := y;
   m_width := width;
   m_height := height;
end;

constructor TRectangleF.Create(const location: TPointF; const size: TSizeF);
begin
   m_x := location.X;
   m_y := location.Y;
   m_width := size.Width;
   m_height := size.Height;
end;

constructor TRectangleF.Create(const vector: TVector4);
begin
   m_x := vector.X;
   m_y := vector.Y;
   m_width := vector.Z;
   m_height := vector.W;
end;

function TRectangleF.ToVector4(): TVector4;
begin
   Result := TVector4.Create(m_x, m_y, m_width, m_height)
end;

class function TRectangleF.FromLTRB(const left: Single; const top: Single; const right: Single; const bottom: Single): TRectangleF;
begin
   Result := TRectangleF.Create(left, top, right - left, bottom - top)
end;

function TRectangleF.Equals(const other: TRectangleF): Boolean;
begin
   Result := Self = other
end;

function TRectangleF.Contains(const x: Single; const y: Single): Boolean;
begin
   Result := (Self.X <= x) and (x < Self.X + Self.Width) and (Self.Y <= y) and (y < Self.Y + Self.Height);
end;

function TRectangleF.Contains(const pt: TPointF): Boolean;
begin
   Result := Contains(pt.X, pt.Y)
end;

function TRectangleF.Contains(const rect: TRectangleF): Boolean;
begin
   Result := (Self.X <= rect.X) and (rect.X + rect.Width <= Self.X + Self.Width) and (Self.Y <= rect.Y) and (rect.Y + rect.Height <= Self.Y + Self.Height);
end;

procedure TRectangleF.Inflate(const x: Single; const y: Single);
begin
   Self.X := Self.X - x;
   Self.Y := Self.Y - y;
   Self.Width := Self.Width + 2 * x;
   Self.Height := Self.Height + 2 * y;
end;

procedure TRectangleF.Inflate(const size: TSizeF);
begin
   Inflate(size.Width, size.Height)
end;

class function TRectangleF.Inflate(const rect: TRectangleF; const x: Single; const y: Single): TRectangleF;
begin
   var r: TRectangleF := rect;
   r.Inflate(x, y);

   Exit(r);
end;

procedure TRectangleF.Intersect(const rect: TRectangleF);
begin
   var _result: TRectangleF := Intersect(rect, Self);

   X := _result.X;
   Y := _result.Y;
   Width := _result.Width;
   Height := _result.Height;
end;

class function TRectangleF.Intersect(const a: TRectangleF; const b: TRectangleF): TRectangleF;
begin
   var x1: Single := System.Math.Max(a.X, b.X);
   var x2: Single := System.Math.Min(a.X + a.Width, b.X + b.Width);
   var y1: Single := System.Math.Max(a.Y, b.Y);
   var y2: Single := System.Math.Min(a.Y + a.Height, b.Y + b.Height);

   if (x2 >= x1) and (y2 >= y1) then
   begin
      Exit(TRectangleF.Create(x1, y1, x2 - x1, y2 - y1));
   end;

   Exit(Empty);
end;

function TRectangleF.IntersectsWith(const rect: TRectangleF): Boolean;
begin
   Result := (rect.X < X + Width) and (X < rect.X + rect.Width) and (rect.Y < Y + Height) and (Y < rect.Y + rect.Height);
end;

class function TRectangleF.Union(const a: TRectangleF; const b: TRectangleF): TRectangleF;
begin
   var x1: Single := System.Math.Min(a.X, b.X);
   var x2: Single := System.Math.Max(a.X + a.Width, b.X + b.Width);
   var y1: Single := System.Math.Min(a.Y, b.Y);
   var y2: Single := System.Math.Max(a.Y + a.Height, b.Y + b.Height);

   Exit(TRectangleF.Create(x1, y1, x2 - x1, y2 - y1));
end;

procedure TRectangleF.Offset(const pos: TPointF);
begin
   Offset(pos.X, pos.Y)
end;

procedure TRectangleF.Offset(const x: Single; const y: Single);
begin
   Self.X := Self.X + x;
   Self.Y := Self.Y + y;
end;

function TRectangleF.ToString(): string;
begin
   Result := '{X=' + X.ToString() + ',Y=' + Y.ToString() + ',Width=' + Width.ToString() + ',Height=' + Height.ToString() + '}'
end;

class operator TRectangleF.Equal(const left: TRectangleF; const right: TRectangleF): Boolean;
begin
   Result := (left.X = right.X) and (left.Y = right.Y) and (left.Width = right.Width) and (left.Height = right.Height);
end;

class operator TRectangleF.NotEqual(const left: TRectangleF; const right: TRectangleF): Boolean;
begin
   Result := not (left = right);
end;

class operator TRectangleF.explicit(const rectangle: TRectangleF): TVector4;
begin
   Result := rectangle.ToVector4();
end;

class operator TRectangleF.explicit(const vector: TVector4): TRectangleF;
begin
   Result := TRectangleF.Create(vector);
end;

{$ENDREGION 'TRectangleF'}

{$REGION 'TRectangle'}

{ TRectangle }

function TRectangle.GetLocation(): TPoint;
begin
   Result := TPoint.Create(X, Y);
end;

procedure TRectangle.SetLocation(const Value: TPoint);
begin
   X := value.X;
   Y := value.Y;
end;

function TRectangle.GetSize(): TSize;
begin
   Result := TSize.Create(Self.Width, Self.Height);
end;

procedure TRectangle.SetSize(const Value: TSize);
begin
   Width := value.Width;
   Height := value.Height;
end;

function TRectangle.GetX(): Integer;
begin
   Result := m_x;
end;

procedure TRectangle.SetX(const Value: Integer);
begin
   m_x := value;
end;

function TRectangle.GetY(): Integer;
begin
   Result := m_y;
end;

procedure TRectangle.SetY(const Value: Integer);
begin
   m_y := value;
end;

function TRectangle.GetWidth(): Integer;
begin
   Result := m_width;
end;

procedure TRectangle.SetWidth(const Value: Integer);
begin
   m_width := value;
end;

function TRectangle.GetHeight(): Integer;
begin
   Result := m_height;
end;

procedure TRectangle.SetHeight(const Value: Integer);
begin
   m_height := value;
end;

function TRectangle.GetLeft(): Integer;
begin
   Result := X;
end;

function TRectangle.GetTop(): Integer;
begin
   Result := Y;
end;

function TRectangle.GetRight(): Integer;
begin
   Result := X + Width;
end;

function TRectangle.GetBottom(): Integer;
begin
   Result := Y + Height;
end;

function TRectangle.GetIsEmpty(): Boolean;
begin
   Result := (m_height = 0) and (m_width = 0) and (m_x = 0) and (m_y = 0);
end;

constructor TRectangle.Create(const x: Integer; const y: Integer; const width: Integer; const height: Integer);
begin
   m_x := x;
   m_y := y;
   m_width := width;
   m_height := height;
end;

constructor TRectangle.Create(const location: TPoint; const size: TSize);
begin
   m_x := location.X;
   m_y := location.Y;
   m_width := size.Width;
   m_height := size.Height;
end;

class function TRectangle.FromLTRB(const left: Integer; const top: Integer; const right: Integer; const bottom: Integer): TRectangle;
begin
   Result := TRectangle.Create(left, top, right - left, bottom - top);
end;

function TRectangle.Equals(const other: TRectangle): Boolean;
begin
   Result := Self = other
end;

class function TRectangle.Ceiling(const value: TRectangleF): TRectangle;
begin
   Result := TRectangle.Create(
                    Integer(System.Math.Ceil(value.X)),
                    Integer(System.Math.Ceil(value.Y)),
                    Integer(System.Math.Ceil(value.Width)),
                    Integer(System.Math.Ceil(value.Height)));
end;


class function TRectangle.Truncate(const value: TRectangleF): TRectangle;
begin
   Result := TRectangle.Create(
                    Integer(System.Trunc(value.X)),
                    Integer(System.Trunc(value.Y)),
                    Integer(System.Trunc(value.Width)),
                    Integer(System.Trunc(value.Height)));
end;


class function TRectangle.Round(const value: TRectangleF): TRectangle;
begin
   Result := TRectangle.Create(
                    Integer(System.Round(value.X)),
                    Integer(System.Round(value.Y)),
                    Integer(System.Round(value.Width)),
                    Integer(System.Round(value.Height)));
end;

function TRectangle.Contains(const x: Integer; const y: Integer): Boolean;
begin
   Result := (Self.X <= x) and (x < Self.X + Self.Width) and (Self.Y <= y) and (y < Self.Y + Self.Height);
end;

function TRectangle.Contains(const pt: TPoint): Boolean;
begin
   Result := Contains(pt.X, pt.Y)
end;

function TRectangle.Contains(const rect: TRectangle): Boolean;
begin
   Result := (X <= rect.X) and (rect.X + rect.Width <= X + Width) and (Y <= rect.Y) and (rect.Y + rect.Height <= Y + Height);
end;

procedure TRectangle.Inflate(const width: Integer; const height: Integer);
begin
   Self.X := Self.X - width;
   Self.Y := Self.Y - height;

   Self.Width := Self.Width + 2 * width;
   Self.Height := Self.Height + 2 * height;
end;


procedure TRectangle.Inflate(const size: TSize);
begin
   Inflate(size.Width, size.Height)
end;

class function TRectangle.Inflate(const rect: TRectangle; const x: Integer; const y: Integer): TRectangle;
begin
   var r: TRectangle := rect;
   r.Inflate(x, y);

   Exit(r);
end;

procedure TRectangle.Intersect(const rect: TRectangle);
begin
   var _result: TRectangle := Intersect(rect, Self);

   X := _result.X;
   Y := _result.Y;
   Width := _result.Width;
   Height := _result.Height;
end;

class function TRectangle.Intersect(const a: TRectangle; const b: TRectangle): TRectangle;
begin
   var x1: Integer := System.Math.Max(a.X, b.X);
   var x2: Integer := System.Math.Min(a.X + a.Width, b.X + b.Width);
   var y1: Integer := System.Math.Max(a.Y, b.Y);
   var y2: Integer := System.Math.Min(a.Y + a.Height, b.Y + b.Height);

   if (x2 >= x1) and (y2 >= y1) then
   begin

      Exit(TRectangle.Create(x1, y1, x2 - x1, y2 - y1));
   end;

   Exit(Empty);
end;

function TRectangle.IntersectsWith(const rect: TRectangle): Boolean;
begin
   Result := (rect.X < X + Width) and (X < rect.X + rect.Width) and (rect.Y < Y + Height) and (Y < rect.Y + rect.Height);
end;

class function TRectangle.Union(const a: TRectangle; const b: TRectangle): TRectangle;
begin
   var x1: Integer := System.Math.Min(a.X, b.X);
   var x2: Integer := System.Math.Max(a.X + a.Width, b.X + b.Width);
   var y1: Integer := System.Math.Min(a.Y, b.Y);
   var y2: Integer := System.Math.Max(a.Y + a.Height, b.Y + b.Height);

   Exit(TRectangle.Create(x1, y1, x2 - x1, y2 - y1));
end;

procedure TRectangle.Offset(const pos: TPoint);
begin
   Offset(pos.X, pos.Y)
end;

procedure TRectangle.Offset(const x: Integer; const y: Integer);
begin
   Self.X := Self.X + x;
   Self.Y := Self.Y + y;
end;


function TRectangle.ToString(): string;
begin
   Result := '{X=' + X.ToString() + ',Y=' + Y.ToString() + ',Width=' + Width.ToString() + ',Height=' + Height.ToString() + '}'
end;

class operator TRectangle.Equal(const left: TRectangle; const right: TRectangle): Boolean;
begin
   Result := (left.X = right.X) and (left.Y = right.Y) and (left.Width = right.Width) and (left.Height = right.Height);
end;

class operator TRectangle.NotEqual(const left: TRectangle; const right: TRectangle): Boolean;
begin
   Result := not (left = right);
end;

{$ENDREGION 'TRectangle'}

{$REGION 'TRectangleFExtensions'}

{ TRectangleFExtensions }

class operator TRectangleFExtensions.implicit(const r: TRectangle): TRectangleF;
begin
   Result := TRectangleF.Create(r.X, r.Y, r.Width, r.Height);
end;

{$ENDREGION 'TRectangleFExtensions'}

{$REGION 'System.Types.TRectExtensions'}

{ TRectExtensions }

class operator TRectExtensions.implicit(const value: System.Types.TRect): Se7e.Drawing.Rectangle.TRectangle;
begin
   Result := Se7e.Drawing.Rectangle.TRectangle.Create(value.left, value.top, value.Width, value.Height);
end;

class operator TRectExtensions.implicit(const value: System.Types.TRect): Se7e.Drawing.Rectangle.TRectangleF;
begin
   Result := Se7e.Drawing.Rectangle.TRectangleF.Create(value.left, value.top, value.Width, value.Height);
end;

class operator TRectExtensions.implicit(const value: Se7e.Drawing.Rectangle.TRectangle): System.Types.TRect;
begin
   Result := System.Types.TRect.Create(value);
end;

{$ENDREGION 'System.Types.TRectExtensions'}

{$REGION 'System.Types.TRectFExtensions'}

{ TRectFExtensions }

class operator TRectFExtensions.implicit(const value: System.Types.TRectF): Se7e.Drawing.Rectangle.TRectangleF;
begin
   Result := Se7e.Drawing.Rectangle.TRectangleF.Create(value.left, value.top, value.Width, value.Height);
end;

class operator TRectFExtensions.implicit(const value: Se7e.Drawing.Rectangle.TRectangleF): System.Types.TRectF;
begin
   Result := System.Types.TRectF.Create(value);
end;

{$ENDREGION 'System.Types.TRectFExtensions'}

end.

