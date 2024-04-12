unit uDemoAvoidAutomaticScaling;

interface

uses
   Se7e.Drawing,
   Se7e.Drawing.Gdiplus.Types,
   uDemo;

type
  TDemoAvoidAutomaticScaling = class(TDemo)
  strict protected
    procedure Run; override;
  end;

implementation

{$REGION}
/// Se você passar apenas o canto superior esquerdo de uma imagem para o <A>DrawImage</A>
/// método, o Microsoft Windows GDI+ pode dimensionar a imagem, o que diminuiria
/// desempenho.
///
/// A seguinte chamada ao método <A>DrawImage</A> especifica um canto superior esquerdo
/// canto de (50, 30) mas não especifica um retângulo de destino:
///
/// <C>Graphics.DrawImage(Imagem, 50, 30); // canto superior esquerdo em (50, 30)</C>
///
/// Embora esta seja a versão mais fácil do método <A>DrawImage</A> em termos
/// do número de argumentos necessários, não é necessariamente o mais
/// eficiente. Se o número de pontos por polegada no dispositivo de exibição atual for
/// diferente do número de pontos por polegada no dispositivo onde a imagem foi
/// criada, o GDI+ dimensiona a imagem para que seu tamanho físico no atual
/// o dispositivo de exibição está o mais próximo possível do seu tamanho físico no dispositivo
/// onde foi criado.
///
/// Se você quiser evitar tal escalonamento, passe a largura e a altura de um
/// retângulo de destino para o método <A>DrawImage</A>. O exemplo a seguir
/// desenha a mesma imagem duas vezes. No primeiro caso, a largura e a altura do
/// retângulo de destino não são especificados e a imagem é automaticamente
/// dimensionado. No segundo caso, a largura e a altura (medidas em pixels) do
/// o retângulo de destino é especificado para ser igual à largura e altura
/// da imagem original.

procedure TDemoAvoidAutomaticScaling.Run;
var
  Image: TGdipImage;
begin
  Image := TGdipImage.FromFile('..\..\imagens\Texture.bmp');
  Graphics.DrawImage(Image, 10, 10);
  Graphics.DrawImage(Image, 120, 10, Image.Width, Image.Height);
  Image.Free();
end;
{$ENDREGION}

initialization
  RegisterDemo('Usando imagens, bitmaps e metarquivos\Melhorando o desempenho evitando o escalonamento automático', TDemoAvoidAutomaticScaling);

end.
