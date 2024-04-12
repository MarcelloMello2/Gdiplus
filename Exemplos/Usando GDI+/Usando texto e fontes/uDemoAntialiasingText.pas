unit uDemoAntialiasingText;

interface

uses
   Types,
   Se7e.Drawing,
   Se7e.Drawing.Gdiplus.Types,
   uDemo;

type
  TDemoAntialiasingText = class(TDemo)
  strict protected
    procedure Run; override;
  end;

implementation

{ TDemoAntialiasingText }

{$REGION}
/// Microsoft Windows GDI+ fornece vários níveis de qualidade para desenho de texto.
/// Normalmente, a renderização de qualidade superior leva mais tempo de processamento do que a renderização de qualidade inferior.
/// renderização de qualidade.
///
/// O nível de qualidade é uma propriedade da classe <A>TGdipGraphics</A>. Para definir o
/// nível de qualidade, defina o método <A>TextRenderingHint</A> de um <A>TGdipGraphics</A>
/// objeto. A propriedade <A>TextRenderingHint</A> recebe um dos elementos
/// da enumeração <A>TTextRenderingHint</A>.
///
/// GDI+ fornece antialiasing tradicional e um novo tipo de antialiasing baseado
/// na tecnologia de exibição Microsoft ClearType disponível apenas no Windows XP e
/// Windows Server 2003 e posterior. A suavização ClearType melhora a legibilidade em
/// monitores LCD coloridos que possuem interface digital, como os monitores em
/// laptops e monitores planos de desktop de alta qualidade. Legibilidade em telas CRT
/// também melhorou um pouco.
///
/// ClearType depende da orientação e ordem das faixas do LCD.
/// Atualmente, ClearType é implementado apenas para listras verticais que são
/// ordenou RGB. Isto pode ser uma preocupação se você estiver usando um tablet PC, onde o
/// a exibição pode ser orientada em qualquer direção ou se você estiver usando uma tela que
/// pode ser alterado de paisagem para retrato.
///
/// O exemplo a seguir desenha texto com duas configurações de qualidade diferentes.

procedure TDemoAntialiasingText.Run;
var
  FontFamily: TGdipFontFamily;
  Font: TGdipFont;
  Brush: TGdipSolidBrush;
  Rect: TRectangle;
begin
  FontFamily := TGdipFontFamily.Create('Times New Roman');
  Font := TGdipFont.Create(FontFamily, 32, TGdipFontStyle.Regular, TGdipGraphicsUnit.Pixel);

  Brush := TGdipSolidBrush.Create(TGdipColor.White);
  Rect := TRectangle.Create(10, 10, 250, 100);
  Graphics.FillRectangle(Brush, Rect);
  Brush.Color := TGdipColor.Blue;

  Graphics.TextRenderingHint := TGdipTextRenderingHint.SingleBitPerPixel;
  Graphics.DrawString('SingleBitPerPixel', Font, Brush, TPointF.Create(10, 10));

  Graphics.TextRenderingHint := TGdipTextRenderingHint.AntiAlias;
  Graphics.DrawString('AntiAlias', Font, Brush, TPointF.Create(10, 60));

  Brush.Free();
  Font.Free();
  FontFamily.Free();
end;
{$ENDREGION}

initialization
  RegisterDemo('Usando texto e fontes\Suavização de bordas com texto', TDemoAntialiasingText);

end.
