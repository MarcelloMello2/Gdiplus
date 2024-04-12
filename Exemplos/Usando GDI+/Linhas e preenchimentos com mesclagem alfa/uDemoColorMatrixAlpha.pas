unit uDemoColorMatrixAlpha;

interface

uses
   Se7e.Drawing,
   Se7e.Drawing.Gdiplus.Types,
   uDemo;

type
  TDemoColorMatrixAlpha = class(TDemo)
  strict private
    procedure DrawRegular;
    procedure DrawAlpha;
  strict protected
    procedure Run; override;
  end;

implementation

{ TDemoColorMatrixAlpha }

{$REGION}
/// A interface <A>TGdipBitmap</A> (que herda do <A>TGdipImage</A>
/// interface) e a interface <A>TGdipImageAttributes</A> fornecem funcionalidade
/// para obter e definir valores de pixel. Você pode usar o <A>TGdipImageAttributes</A>
/// interface para modificar os valores alfa de uma imagem inteira, ou você pode chamar
/// o método <A>TGdipBitmap.SetPixel</A> para modificar valores de pixels individuais. Para
/// mais informações sobre como definir valores de pixel individuais, veja o próximo exemplo
/// <A>Definindo os valores alfa de pixels individuais</A>.
///
/// O exemplo a seguir desenha uma linha preta larga e depois exibe uma linha opaca
/// imagem que cobre parte dessa linha.

procedure TDemoColorMatrixAlpha.DrawRegular;
var
  Bitmap: TGdipBitmap;
  Pen: TGdipPen;
begin
  Bitmap := TGdipBitmap.Create('..\..\imagens\Texture1.jpg');
  Pen := TGdipPen.Create(TGdipColor.FromArgb(255, 0, 0, 0), 25);
  Graphics.DrawLine(Pen, TPoint.Create(10, 35), TPoint.Create(200, 35));
  Graphics.DrawImage(Bitmap, 30, 0, Bitmap.Width, Bitmap.Height);
  Pen.Free();
  Bitmap.Free();
end;

/// A ilustração superior acima mostra a imagem resultante, que é desenhada em
/// (30, 0). Observe que a larga linha preta não aparece na imagem.
///
/// A interface <A>TGdipImageAttributes</A> tem muitas propriedades que você pode usar
/// para modificar imagens durante a renderização. No exemplo a seguir, um
/// O objeto <A>TGdipImageAttributes</A> é usado para definir todos os valores alfa para 80
/// por cento do que eram. Isso é feito inicializando uma matriz de cores e
/// definindo o valor da escala alfa na matriz para 0,8. A matriz de cores é
/// passado para o método <A>TGdipImageAttributes.SetColorMatrix</A> e o
/// O objeto <A>TGdipImageAttributes</A> é passado para o método <A>DrawImage</A> de um
/// Objeto <A>TGdipGráficos</A>.

procedure TDemoColorMatrixAlpha.DrawAlpha;
var
  ColorMatrix: TGdipColorMatrix;
  Bitmap: TGdipBitmap;
  Pen: TGdipPen;
  Attr: TGdipImageAttributes;
  Width, Height: Integer;
begin
   ColorMatrix := TGdipColorMatrix.Create
   (
      [
         [1.0, 0.0, 0.0, 0.0, 0.0],
         [0.0, 1.0, 0.0, 0.0, 0.0],
         [0.0, 0.0, 1.0, 0.0, 0.0],
         [0.0, 0.0, 0.0, 0.8, 0.0],
         [0.0, 0.0, 0.0, 0.0, 1.0]
      ]
   );

  Bitmap := TGdipBitmap.Create('..\..\imagens\Texture1.jpg');
  Pen := TGdipPen.Create(TGdipColor.FromArgb(255, 0, 0, 0), 25);
  Attr := TGdipImageAttributes.Create;
  Attr.SetColorMatrix(ColorMatrix, TGdipColorMatrixFlag.Default, TGdipColorAdjustType.Bitmap);
  Graphics.DrawLine(Pen, TPoint.Create(10, 135), TPoint.Create(200, 135));
  Width := Bitmap.Width;
  Height := Bitmap.Height;
  Graphics.DrawImage(Bitmap,
    TRectangle.Create(30, 100, Width, Height), // Retângulo de destino
    0, 0, Width, Height,                  // Retângulo de origem
    TGdipGraphicsUnit.Pixel, Attr);

  Attr.Free();
  Pen.Free();
  Bitmap.Free();
  ColorMatrix.Free();
end;
{$ENDREGION}

procedure TDemoColorMatrixAlpha.Run;
begin
  DrawRegular;
  DrawAlpha;
end;

initialization
  RegisterDemo('Linhas e preenchimentos com mesclagem alfa\Usando uma matriz de cores para definir valores alfa em imagens', TDemoColorMatrixAlpha);

end.
