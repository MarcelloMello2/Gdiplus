unit uDemoSemitransparentLines;

interface

uses
   Se7e.Drawing,
   Se7e.Drawing.Gdiplus.Types,
   uDemo;

type
  TDemoSemitransparentLines = class(TDemo)
  strict protected
    procedure Run; override;
  end;

implementation

{ TDemoSemitransparentLines }

{$REGION}
/// No Microsoft Windows GDI+, uma cor é um valor de 32 bits com 8 bits cada para
/// alfa, vermelho, verde e azul. O valor alfa indica a transparência do
/// a cor — até que ponto a cor é mesclada com o fundo
/// cor. Os valores alfa variam de 0 a 255, onde 0 representa um valor totalmente
/// cor transparente e 255 representa uma cor totalmente opaca.
///
/// A combinação alfa é uma combinação pixel por pixel da cor de origem e de fundo
/// dados. Cada um dos três componentes (vermelho, verde, azul) de uma determinada fonte
/// a cor é mesclada com o componente correspondente da cor de fundo
/// de acordo com a seguinte fórmula:
///
/// DisplayColor = SourceColor × Alpha / 255 + BackgroundColor × (255 – Alpha) / 255
///
/// Por exemplo, suponha que o componente vermelho da cor de origem seja 150 e o
/// o componente vermelho da cor de fundo é 100. Se o valor alfa for 200, o
/// o componente vermelho da cor resultante é calculado da seguinte forma:
///
/// 150 × 200/255 + 100 × (255 – 200)/255 = 139
///
/// Ao desenhar uma linha, você deve passar um objeto <A>TGdipPen</A> para o
/// Método <A>DrawLine</A> da classe <A>TGdipGraphics</A>. Um dos
/// os parâmetros do construtor <A>TGdipPen</A> são um registro <A>TGdipColor</A>. Para
/// desenhe uma linha opaca, defina o componente alfa da cor para 255. Para desenhar uma
/// linha semitransparente, define o componente alfa para qualquer valor de 1 a
/// 254.
///
/// Quando você desenha uma linha semitransparente sobre um fundo, a cor do
/// a linha é mesclada com as cores do fundo. O componente alfa
/// especifica como as cores da linha e do fundo são misturadas; valores alfa próximos de 0
/// coloque mais peso nas cores de fundo e valores alfa próximos a 255 casas
/// mais peso na cor da linha.
///
/// O exemplo a seguir desenha uma imagem e depois desenha três linhas que usam o
/// imagem como plano de fundo. A primeira linha usa um componente alfa de 255, então
/// é opaco. A segunda e terceira linhas usam um componente alfa de 128, então elas
/// são semitransparentes; você pode ver a imagem de fundo através das linhas.
/// Definir a propriedade <A>CompositingQuality</A> faz com que a mesclagem do
/// terceira linha a ser feita em conjunto com a correção gama.

procedure TDemoSemitransparentLines.Run;
var
  Image: TGdipImage;
  OpaquePen,
  SemiTransPen: TGdipPen;
begin
  Image := TGdipImage.FromFile('..\..\imagens\Texture1.jpg');
  Graphics.DrawImage(Image, 10, 5, Image.Width, Image.Height);
  OpaquePen := TGdipPen.Create(TGdipColor.FromArgb(255, 0, 0, 255), 15);
  SemiTransPen := TGdipPen.Create(TGdipColor.FromArgb(128, 0, 0, 255), 15);
  Graphics.DrawLine(OpaquePen, 0, 20, 100, 20);
  Graphics.DrawLine(SemiTransPen, 0, 40, 100, 40);
  Graphics.CompositingQuality := TGdipCompositingQuality.GammaCorrected;
  Graphics.DrawLine(SemiTransPen, 0, 60, 100, 60);

  SemiTransPen.Free();
  OpaquePen.Free();
  Image.Free();
end;
{$ENDREGION}

initialization
  RegisterDemo('Linhas e preenchimentos com mesclagem alfa\Desenhando linhas opacas e semitransparentes', TDemoSemitransparentLines);

end.
