unit uDemoShearingColors;

interface

uses
   Types,
   Se7e.Drawing,
   Se7e.Drawing.Gdiplus.Types,
   uDemo;

type
  TDemoShearingColors = class(TDemo)
  strict protected
    procedure Run; override;
  end;

implementation

{ TDemoShearingColors }

{$REGION}
/// O cisalhamento aumenta ou diminui um componente de cor em uma quantidade proporcional
/// para outro componente de cor. Por exemplo, considere a transformação onde
/// o componente vermelho é aumentado pela metade do valor do componente azul.
/// Sob tal transformação, a cor (0,2, 0,5, 1) se tornaria
/// (0,7, 0,5, 1). O novo componente vermelho é 0,2 + (1/2)(1) = 0,7.
///
/// O exemplo a seguir constrói um objeto <A>TGdipImage</A> a partir do arquivo
/// ColorBars4.bmp. Em seguida, o código aplica a transformação de cisalhamento descrita
/// no parágrafo anterior para cada pixel da imagem.

procedure TDemoShearingColors.Run;
var
  ColorMatrix: TGdipColorMatrix;
  Image: TGdipImage;
  ImageAttributes: TGdipImageAttributes;
  Width, Height: Integer;
begin
  ColorMatrix := TGdipColorMatrix.Create
  (
    [
      [1.0, 0.0, 0.0, 0.0, 0.0],
      [0.0, 1.0, 0.0, 0.0, 0.0],
      [0.5, 0.0, 1.0, 0.0, 0.0],
      [0.0, 0.0, 0.0, 1.0, 0.0],
      [0.0, 0.0, 0.0, 0.0, 1.0]
    ]
  );

  Image := TGdipImage.FromFile('..\..\imagens\ColorBars4.bmp');
  ImageAttributes := TGdipImageAttributes.Create;
  Width := Image.Width;
  Height := Image.Height;

  ImageAttributes.SetColorMatrix(ColorMatrix, TGdipColorMatrixFlag.Default, TGdipColorAdjustType.Bitmap);
  Graphics.DrawImage(Image, 10, 10, Width, Height);
  Graphics.DrawImage(Image,
    TRectangle.Create(150, 10, Width, Height), // retângulo de destino
    0, 0, Width, Height,    // retângulo de origem
    TGdipGraphicsUnit.Pixel, ImageAttributes);

  ColorMatrix.Free();
  ImageAttributes.Free();
  Image.Free();
end;

/// A ilustração acima mostra a imagem original à esquerda e o
/// imagem transformada à direita.
///
/// A tabela a seguir mostra os vetores de cores para as quatro barras antes e
/// após a transformação de cisalhamento.
///
/// <B>Original</B><T><T><B>Cortado</B>
/// (0, 0, 1, 1)<T><T>(0,5, 0, 1, 1)
/// (0,5, 1, 0,5, 1)<T><T>(0,75, 1, 0,5, 1)
/// (1, 1, 0, 1)<T><T>(1, 1, 0, 1)
/// (0,4, 0,4, 0,4, 1)<T><T>(0,6, 0,4, 0,4, 1)
{$ENDREGION}

initialization
  RegisterDemo('Recolorir\Corte de cores', TDemoShearingColors);

end.
