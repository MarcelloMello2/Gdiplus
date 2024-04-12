unit uDemoInterpolationMode;

interface

uses
   Se7e.Drawing,
   Se7e.Drawing.Gdiplus.Types,
   uDemo;

type
  TDemoInterpolationMode = class(TDemo)
  strict protected
    procedure Run; override;
  end;

implementation

{$REGION}
/// O modo de interpolação de um objeto <A>TGdipGraphics</A> influencia a forma como
/// Microsoft Windows GDI+ dimensiona (alonga e encolhe) imagens. O
/// A enumeração <A>TGdipInterpolationMode</A> define vários modos de interpolação,
/// alguns dos quais são mostrados na lista a seguir:
///
/// - TGdipInterpolationMode.NearestNeighbor
/// - TGdipInterpolationMode.Bilinear
/// - TGdipInterpolationMode.HighQualityBilinear
/// - TGdipInterpolationMode.Bicubic
/// - TGdipInterpolationMode.HighQualityBicubic
///
/// Para esticar uma imagem, cada pixel da imagem original deve ser mapeado para um
/// grupo de pixels na imagem maior. Para reduzir uma imagem, grupos de pixels em
/// a imagem original deve ser mapeada para pixels únicos na imagem menor. O
/// a eficácia dos algoritmos que realizam esses mapeamentos determina a
/// qualidade de uma imagem dimensionada. Algoritmos que produzem escalas de maior qualidade
/// imagens tendem a exigir mais tempo de processamento. Na lista anterior,
/// <B>TGdipInterpolationMode.NearestNeighbor</B> é o modo de qualidade mais baixa e
/// <B>TGdipInterpolationMode.HighQualityBicubic</B> é o modo de mais alta qualidade.
///
/// Para definir o modo de interpolação, passe um dos membros do
/// enumeração <A>TGdipInterpolationMode</A> para <A>InterpolationMode</A>
/// propriedade de um objeto <A>TGdipGraphics</A>.
///
/// O exemplo a seguir desenha uma imagem e depois a reduz com três
/// diferentes modos de interpolação:

procedure TDemoInterpolationMode.Run;
var
  Image: TGdipImage;
  Width, Height: Integer;
begin
  Image := TGdipImage.FromFile('..\..\imagens\GrapeBunch.bmp');
  Width := Image.Width;
  Height := Image.Height;

  // Desenhe a imagem sem encolher ou esticar.
  Graphics.DrawImage(Image,
    TRectangle.Create(10, 10, Width, Height), // retângulo de destino
    0, 0,      // canto superior esquerdo do retângulo de origem
    Width,     // largura do retângulo de origem
    Height,    // altura do retângulo de origem
    TGdipGraphicsUnit.Pixel);

  // Reduza a imagem usando interpolação de baixa qualidade.
  Graphics.InterpolationMode := TGdipInterpolationMode.NearestNeighbor;
  Graphics.DrawImage(Image,
    TRectangleF.Create(10, 250, 0.6 * Width, 0.6 * Height), // retângulo de destino
    TRectangleF.Create(0, 0,      // canto superior esquerdo do retângulo de origem
                       Width,     // largura do retângulo de origem
                       Height),   // altura do retângulo de origem
    TGdipGraphicsUnit.Pixel);

  // Reduza a imagem usando interpolação de qualidade média.
  Graphics.InterpolationMode := TGdipInterpolationMode.HighQualityBilinear;
  Graphics.DrawImage(Image,
    TRectangleF.Create(150, 250, 0.6 * Width, 0.6 * Height), // retângulo de destino
    TRectangleF.Create(0, 0,      // canto superior esquerdo do retângulo de origem
                       Width,     // largura do retângulo de origem
                       Height),   // altura do retângulo de origem
    TGdipGraphicsUnit.Pixel);

  // Reduza a imagem usando interpolação de alta qualidade.
  Graphics.InterpolationMode := TGdipInterpolationMode.HighQualityBicubic;
  Graphics.DrawImage(Image,
    TRectangleF.Create(290, 250, 0.6 * Width, 0.6 * Height), // retângulo de destino
    TRectangleF.Create(0, 0,      // canto superior esquerdo do retângulo de origem
                       Width,     // largura do retângulo de origem
                       Height),   // altura do retângulo de origem
    TGdipGraphicsUnit.Pixel);

  Image.Free();
end;
{$ENDREGION}

initialization
  RegisterDemo('Usando imagens, bitmaps e metarquivos\Usando o modo de interpolação para controlar a qualidade da imagem durante o dimensionamento', TDemoInterpolationMode);

end.
