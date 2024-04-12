unit uDemoWorldTransformations;

interface

uses
   Types,
   Se7e.Drawing,
   Se7e.Drawing.Gdiplus.Types,
   uDemo;

type
  TDemoWorldTransformations = class(TDemo)
  strict private
    procedure Example1;
    procedure Example2;
    procedure Example3;
    procedure Example4;
  strict protected
    procedure Run; override;
  end;

implementation

{ TDemoWorldTransformations }

{$REGION}
/// As transformações afins incluem rotação, dimensionamento, reflexão, cisalhamento e
/// traduzindo. No Microsoft Windows GDI+, a interface <A>TGdipMatrix</A>
/// fornece a base para realizar transformações afins em vetores
/// desenhos, imagens e texto.
///
/// A transformação mundial é uma propriedade da interface <A>TGdipGraphics</A>.
/// Os números que especificam a transformação mundial são armazenados em um
/// Objeto <A>TGdipMatrix</A>, que representa uma matriz 3×3. O <A>TGdipMatrix</A> e
/// As interfaces <A>TGdipGraphics</A> possuem vários métodos para definir os números em
/// a matriz de transformação mundial. Os exemplos nesta seção manipulam
/// retângulos porque retângulos são fáceis de desenhar e é fácil ver o
/// efeitos de transformações em retângulos.
///
/// Começamos criando um retângulo de 50 por 50 e localizando-o na origem
/// (0, 0). A origem está no canto superior esquerdo da área do cliente. O
/// o retângulo é desenhado em vermelho.

procedure TDemoWorldTransformations.Example1;
var
  Rect: TRectangle;
  Pen: TGdipPen;
begin
  Rect := TRectangle.Create(0, 0, 50, 50);
  Pen := TGdipPen.Create(TGdipColor.Red, 2);
  Graphics.DrawRectangle(Pen, Rect);
  Pen.Free();
end;

/// O código a seguir aplica uma transformação de escala que expande o
/// retângulo por um fator de 1,75 na direção x e reduz o retângulo
/// por um fator de 0,5 na direção y. O resultado está desenhado em verde.

procedure TDemoWorldTransformations.Example2;
var
  Rect: TRectangle;
  Pen: TGdipPen;
begin
  Rect := TRectangle.Create(0, 0, 50, 50);
  Pen := TGdipPen.Create(TGdipColor.LimeGreen, 2);
  Graphics.ScaleTransform(1.75, 0.5);
  Graphics.DrawRectangle(Pen, Rect);
  Pen.Free();
end;

/// O resultado é um retângulo que é mais longo na direção x e mais curto na
/// a direção y que a original.
///
/// Para girar o retângulo em vez de escalá-lo, use o código a seguir.
/// O resultado é desenhado em azul.

procedure TDemoWorldTransformations.Example3;
var
  Rect: TRectangle;
  Pen: TGdipPen;
begin
  Rect := TRectangle.Create(0, 0, 50, 50);
  Pen := TGdipPen.Create(TGdipColor.Blue, 2);
  Graphics.RotateTransform(28);
  Graphics.DrawRectangle(Pen, Rect);
  Pen.Free();
end;

/// Para traduzir o retângulo, use o seguinte código (desenhado em roxo)

procedure TDemoWorldTransformations.Example4;
var
  Rect: TRectangle;
  Pen: TGdipPen;
begin
  Rect := TRectangle.Create(0, 0, 50, 50);
  Pen := TGdipPen.Create(TGdipColor.Fuchsia, 2);
  Graphics.TranslateTransform(150, 150);
  Graphics.DrawRectangle(Pen, Rect);
  Pen.Free();
end;
{$ENDREGION}

procedure TDemoWorldTransformations.Run;
begin
  Example1();
  Example2();
  Graphics.ResetTransform();
  Example3();
  Graphics.ResetTransform();
  Example4();
end;

initialization
  RegisterDemo('Transformações\Usando a transformação mundial', TDemoWorldTransformations);

end.
