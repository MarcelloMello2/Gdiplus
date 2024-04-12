unit uDemoRotatingColors;

interface

uses
   Types,
   Se7e.Drawing,
   Se7e.Drawing.Gdiplus.Types,
   uDemo;

type
  TDemoRotatingColors = class(TDemo)
  strict protected
    procedure Run; override;
  end;

implementation

{ TDemoRotatingColors }

{$REGION}
/// A rotação em um espaço de cores quadridimensional é difícil de visualizar. Pudermos
/// facilita a visualização da rotação concordando em manter uma das cores
/// componentes corrigidos. Suponha que concordamos em manter o componente alfa fixo em 1
/// (totalmente opaco). Então podemos visualizar um espaço de cores tridimensional com
/// eixos vermelho, verde e azul conforme mostrado na ilustração a seguir.
///
/// <I>Veja o tópico do Platform SDK "Rotating Colors" para ver a ilustração</I>
///
/// Uma cor pode ser considerada como um ponto no espaço 3-D. Por exemplo, o ponto
/// (1, 0, 0) no espaço representa a cor vermelha, e o ponto (0, 1, 0) no
/// espaço representa a cor verde.
///
/// A ilustração a seguir mostra o que significa girar a cor (1, 0, 0)
/// através de um ângulo de 60 graus no plano Vermelho-Verde. Rotação em um plano
/// paralelo ao plano Vermelho-Verde pode ser pensado como uma rotação em torno do azul
/// eixo.
///
/// <I>Veja o tópico do Platform SDK "Rotating Colors" para ver a ilustração</I>
///
/// A ilustração a seguir mostra como inicializar uma matriz de cores para executar
/// rotações sobre cada um dos três eixos de coordenadas (vermelho, verde, azul).
///
/// <I>Veja o tópico do Platform SDK "Rotating Colors" para ver a ilustração</I>
///
/// O exemplo a seguir pega uma imagem que é toda de uma cor (1, 0, 0.6) e
/// aplica uma rotação de 60 graus em torno do eixo azul. O ângulo da rotação
/// é varrido em um plano paralelo ao plano Vermelho-Verde.

procedure TDemoRotatingColors.Run;
const
  Degrees = 60;
  Radians = Degrees * Pi / 180;
var
  Bitmap: TGdipBitmap;
  BitmapGraphics: TGdipGraphics;
  ImageAttributes: TGdipImageAttributes;
  ColorMatrix: TGdipColorMatrix;
begin
  Bitmap := TGdipBitmap.Create(100, 100);
  BitmapGraphics := TGdipGraphics.FromImage(Bitmap);
  BitmapGraphics.Clear(TGdipColor.FromArgb(255, 204, 0, 153));
  ImageAttributes := TGdipImageAttributes.Create;

  ColorMatrix := TGdipColorMatrix.Create();
  ColorMatrix[0,0] := Cos(Radians);
  ColorMatrix[1,0] := -Sin(Radians);
  ColorMatrix[0,1] := Sin(Radians);
  ColorMatrix[1,1] := Cos(Radians);

  ImageAttributes.SetColorMatrix(ColorMatrix, TGdipColorMatrixFlag.Default, TGdipColorAdjustType.Bitmap);
  Graphics.DrawImage(Bitmap, 10, 10, 100, 100);
  Graphics.DrawImage(Bitmap,
    TRectangle.Create(150, 10, 100, 100), // retângulo de destino
    0, 0, 100, 100,    // retângulo de origem
    TGdipGraphicsUnit.Pixel, ImageAttributes);

  ColorMatrix.Free();
  ImageAttributes.Free();
  BitmapGraphics.Free();
  Bitmap.Free();
end;

/// A ilustração acima mostra a imagem original à esquerda e o
/// imagem transformada à direita.
///
/// A rotação de cores realizada no exemplo de código anterior pode ser visualizada
/// do seguinte modo.
///
/// <I>Veja o tópico do Platform SDK "Rotating Colors" para ver a ilustração</I>
{$ENDREGION}

initialization
  RegisterDemo('Recolorir\Rotação de cores', TDemoRotatingColors);

end.
