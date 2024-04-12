unit uDemoSemitransparentBrushes;

interface

uses
   Se7e.Drawing,
   Se7e.Drawing.Gdiplus.Types,
   uDemo;

type
  TDemoSemitransparentBrushes = class(TDemo)
  strict protected
    procedure Run; override;
  end;

implementation

{ TDemoSemitransparentBrushes }

{$REGION}
/// Ao preencher uma forma, você deve passar um objeto <A>TGdipBrush</A> para um dos
/// preenche métodos da interface <A>TGdipGraphics</A>. O único parâmetro do
/// O construtor <A>TGdipSolidBrush</A> é um registro <A>TGdipColor</A>.
/// Para preencher uma forma opaca, defina o componente alfa da cor como 255. Para
/// preenche uma forma semitransparente, define o componente alfa para qualquer valor de
/// 1 a 254.
///
/// Quando você preenche uma forma semitransparente, a cor da forma é mesclada
/// com as cores do fundo. O componente alfa especifica como o
/// forma e cores de fundo são misturadas; valores alfa próximos a 0 colocam mais peso
/// nas cores de fundo, e valores alfa próximos a 255 colocam mais peso no
/// cor da forma.
///
/// O exemplo a seguir desenha uma imagem e depois preenche três elipses que
/// sobrepõe a imagem. A primeira elipse usa um componente alfa de 255, então
/// é opaco. A segunda e terceira elipses usam um componente alfa de 128, então
/// eles são semitransparentes; você pode ver a imagem de fundo através do
/// elipses. Definir a propriedade <A>TGdipGraphics.CompositingQuality</A> causa
/// a mesclagem da terceira elipse será feita em conjunto com gama
/// correção.

procedure TDemoSemitransparentBrushes.Run;
var
  Image: TGdipImage;
  OpaqueBrush,
  SemiTransBrush: TGdipSolidBrush;
begin
  Image := TGdipImage.FromFile('..\..\imagens\Texture1.png');
  Graphics.DrawImage(Image, 50, 50, Image.Width, Image.Height);
  OpaqueBrush := TGdipSolidBrush.Create(TGdipColor.FromArgb(255, 0, 0, 255));
  SemiTransBrush := TGdipSolidBrush.Create(TGdipColor.FromArgb(128, 0, 0, 255));
  Graphics.FillEllipse(OpaqueBrush, 35, 45, 45, 30);
  Graphics.FillEllipse(SemiTransBrush, 86, 45, 45, 30);
  Graphics.CompositingQuality := TGdipCompositingQuality.GammaCorrected;
  Graphics.FillEllipse(SemiTransBrush, 40, 90, 86, 30);

  SemiTransBrush.Free();
  OpaqueBrush.Free();
  Image.Free();
end;
{$ENDREGION}

initialization
  RegisterDemo('Linhas e preenchimentos com mesclagem alfa\Desenhando com pincéis opacos e semitransparentes', TDemoSemitransparentBrushes);

end.
