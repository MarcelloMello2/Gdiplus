unit uDemoFillSolidColor;

interface

uses
   Se7e.Drawing,
   Se7e.Drawing.Gdiplus.Types,
   uDemo;

type
  TDemoFillSolidColor = class(TDemo)
  strict protected
    procedure Run; override;
  end;

implementation

{$REGION}
/// Um objeto GDI+Brush do Microsoft Windows é usado para preencher o interior de uma
/// forma fechada. O GDI+ define vários estilos de preenchimento: cor sólida, padrão de hachura,
/// textura de imagem e gradiente de cor.
///
/// Para preencher uma forma com uma cor sólida, crie um objeto <A>TGdipSolidBrush</A>, e
/// então use esse objeto <A>TGdipSolidBrush</A> como argumento em um dos métodos de preenchimento
/// da interface <A>TGdipGraphics</A>. O exemplo a seguir mostra como
/// preencher uma elipse com a cor vermelha:

procedure TDemoFillSolidColor.Run;
var
  SolidBrush: TGdipSolidBrush;
begin
  SolidBrush := TGdipSolidBrush.Create(TGdipColor.FromArgb(255, 255, 0, 0));
  Graphics.FillEllipse(SolidBrush, 0, 0, 100, 60);
  SolidBrush.Free();
end;

/// No exemplo anterior, o construtor <A>TGdipSolidBrush</A> recebe uma referência
/// de registro <A>TGdipColor</A> como seu único argumento. Os valores usados pelo
/// construtor <A>TGdipColor</A> representam os componentes alfa, vermelho, verde e azul
/// da cor. Cada um desses valores deve estar na faixa de 0 a 255. O primeiro 255 indica que a cor é totalmente opaca, e o segundo
/// 255 indica que o componente vermelho está com intensidade total. Os dois zeros
/// indicam que os componentes verde e azul têm uma intensidade de 0.
///
/// Os quatro números (0, 0, 100, 60) passados para o método <A>FillEllipse</A>
/// especificam a localização e o tamanho do retângulo delimitador para a elipse. O
/// retângulo tem um canto superior esquerdo de (0, 0), uma largura de 100 e uma altura
/// de 60.
{$ENDREGION}

initialization
  RegisterDemo('Usando o pincel para preencher formas\Preenchendo uma forma com uma cor sólida', TDemoFillSolidColor);

end.
