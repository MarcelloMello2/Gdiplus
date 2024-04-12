unit uDemoFillImageTexture;

interface

uses
   Se7e.Drawing,
   Se7e.Drawing.Gdiplus.Types,
   uDemo;

type
  TDemoFillImageTexture = class(TDemo)
  strict protected
    procedure Run; override;
  end;

implementation

{$REGION}
/// Você pode preencher uma forma fechada com uma textura usando a interface <A>TGdipImage</A>
/// e a interface <A>TGdipTextureBrush</A>.
///
/// O exemplo a seguir preenche uma elipse com uma imagem. O código constrói um
/// objeto <A>TGdipImage</A>, e então passa esse objeto <A>TGdipImage</A> como um
/// argumento para um construtor <A>TGdipTextureBrush</A>. A terceira declaração de código
/// escala a imagem, e a quarta declaração preenche a elipse com
/// cópias repetidas da imagem escalada:

procedure TDemoFillImageTexture.Run;
var
  Image: TGdipImage;
  Brush: TGdipTextureBrush;
  Matrix: TGdipMatrix;
begin
  Image := TGdipImage.FromFile('..\..\imagens\ImageFile.jpg');
  Matrix := TGdipMatrix.Create(75 / 640, 0, 0, 75/480, 0, 0);
  Brush := TGdipTextureBrush.Create(Image);

  Brush.Transform := Matrix;
  Graphics.FillEllipse(Brush, TRectangle.Create(0, 50, 150, 250));

  Brush.Free();
  Matrix.Free();
  Image.Free();
end;

/// No exemplo de código anterior, a propriedade <A>Transform</A> define a
/// transformação que é aplicada à imagem antes de ela ser desenhada. Suponha que
/// a imagem original tenha uma largura de 640 pixels e uma altura de 480 pixels. A
/// transformação reduz a imagem para 75×75, ajustando os valores de escala horizontal e
/// vertical.
///
/// <B>Nota</B> No exemplo anterior, o tamanho da imagem é de 75×75, e o
/// tamanho da elipse é de 150×250. Como a imagem é menor do que a elipse que
/// está preenchendo, a elipse é preenchida com a imagem em mosaico. Preencher em mosaico significa que a imagem
/// é repetida horizontal e verticalmente até que o limite da forma seja
/// alcançado. Para mais informações sobre preenchimento em mosaico, veja a próxima demonstração
/// <I>Preenchendo uma Forma com uma Imagem em Mosaico</I>.
{$ENDREGION}

initialization
  RegisterDemo('Usando o pincel para preencher formas\Preenchendo uma forma com uma textura de imagem', TDemoFillImageTexture);

end.
