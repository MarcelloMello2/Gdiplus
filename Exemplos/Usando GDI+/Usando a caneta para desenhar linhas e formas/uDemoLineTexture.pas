unit uDemoLineTexture;

interface

uses
   Se7e.Drawing,
   Se7e.Drawing.Gdiplus.Types,
   uDemo;

type
  TDemoLineTexture = class(TDemo)
  strict protected
    procedure Run; override;
  end;

implementation

{$REGION}
/// Em vez de desenhar uma linha ou curva com uma cor sólida, você pode desenhar com uma
/// textura. Para desenhar linhas e curvas com uma textura, crie um objeto
/// <A>TGdipTextureBrush</A>, e passe esse objeto <A>TGdipTextureBrush</A> para um
/// construtor <A>TGdipPen</A>. A imagem associada com o pincel de textura é usada
/// para ladrilhar o plano (invisivelmente), e quando a caneta desenha uma linha ou curva,
/// o traço da caneta revela certos pixels da textura ladrilhada.
///
/// O exemplo a seguir cria um objeto <A>TGdipImage</A> a partir do arquivo
/// Texture1.jpg. Essa imagem é usada para construir um objeto <A>TGdipTextureBrush</A>,
/// e o objeto <A>TGdipTextureBrush</A> é usado para construir um objeto <A>TGdipPen</A>.
/// A chamada para <A>TGdipGraphics.DrawImage</A> desenha a imagem com seu canto superior esquerdo
/// em (0, 0). A chamada para <A>Graphics.DrawEllipse</A> usa o objeto <A>TGdipPen</A>
/// para desenhar uma elipse texturizada.

procedure TDemoLineTexture.Run;
var
  Image: TGdipImage;
  Brush: TGdipTextureBrush;
  TexturedPen: TGdipPen;
begin
  Image := TGdipImage.FromFile('..\..\imagens\Texture1.jpg');
  Brush := TGdipTextureBrush.Create(Image);
  TexturedPen := TGdipPen.Create(Brush, 30);

  Graphics.DrawImage(Image, 0, 0, Image.Width, Image.Height);
  Graphics.DrawEllipse(TexturedPen, 100, 20, 200, 100);

  TexturedPen.Free();
  Brush.Free();
  Image.Free();
end;
{$ENDREGION}

initialization
  RegisterDemo('Usando a caneta para desenhar linhas e formas\Desenhando uma linha com textura', TDemoLineTexture);

end.
