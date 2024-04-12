unit uDemoCropAndScaleImages;

interface

uses
   Se7e.Drawing,
   Se7e.Drawing.Gdiplus.Types,
   Se7e.Drawing.Rectangle,
   uDemo;

type
  TDemoCropAndScaleImages = class(TDemo)
  strict protected
    procedure Run; override;
  end;

implementation

{$REGION}
/// A interface <A>TGdipGraphics</A> fornece vários métodos <A>DrawImage</A>,
/// alguns dos quais possuem parâmetros retangulares de origem e destino que você pode
/// use para cortar e dimensionar imagens.
///
/// O exemplo a seguir constrói um objeto <A>TGdipImage</A> a partir do arquivo
/// Apple.gif. O código desenha a imagem inteira da maçã em seu tamanho original. O
/// código então chama o método <A>DrawImage</A> de um objeto <A>TGdipGraphics</A> para
///desenha uma parte da imagem da maçã em um retângulo de destino que seja maior
/// do que a imagem original da maçã.
///
/// O método <A>DrawImage</A> determina qual parte da maçã desenhar
/// olhando para o retângulo de origem, que é especificado pelo terceiro, quarto,
/// quinto e sexto argumentos. Neste caso, a maçã é cortada em 75 por cento
/// de sua largura e 75 por cento de sua altura.
///
/// O método <A>DrawImage</A> determina onde desenhar a maçã cortada e
/// qual o tamanho da maçã cortada olhando para o retângulo de destino,
/// que é especificado pelo segundo argumento. Neste caso, o destino
/// o retângulo é 30% mais largo e 30% mais alto que a imagem original.

procedure TDemoCropAndScaleImages.Run;
var
  Image: TGdipImage;
  Width, Height: Integer;
  DestinationRect: TRectangleF;
begin
  Image := TGdipImage.FromFile('..\..\imagens\Apple.gif');
  Width := Image.Width;
  Height := Image.Height;

  // Torna o retângulo de destino 30% mais largo e
  // 30% mais alto que a imagem original.
  //Coloca o canto superior esquerdo do destino
  // retângulo em (150, 20).
  DestinationRect := TRectangleF.Create(150, 20, 1.3 * Width, 1.3 * Height);

  // Desenha a imagem inalterada com o canto superior esquerdo em (0, 0).
  Graphics.DrawImage(Image, 0, 0);

  //Desenha uma parte da imagem. Dimensione essa parte da imagem
  // para que preencha o retângulo de destino.
  Graphics.DrawImage(Image, DestinationRect,
    TRectangleF.Create(0,
                       0,          // canto superior esquerdo do retângulo de origem
                       0.75 * Width,  // largura do retângulo de origem
                       0.75 * Height), // altura do retângulo de origem
    TGdipGraphicsUnit.Pixel);

  Image.Free();
end;
{$ENDREGION}

initialization
  RegisterDemo('Usando imagens, bitmaps e metarquivos\Cortar e dimensionar imagens', TDemoCropAndScaleImages);

end.
