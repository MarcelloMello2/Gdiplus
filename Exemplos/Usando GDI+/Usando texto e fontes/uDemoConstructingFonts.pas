unit uDemoConstructingFonts;

interface

uses
   Types,
   Se7e.Drawing,
   Se7e.Drawing.Gdiplus.Types,
   uDemo;

type
  TDemoConstructingFonts = class(TDemo)
  strict protected
    procedure Run; override;
  end;

implementation

{ TDemoConstructingFonts }

{$REGION}
/// O Microsoft Windows GDI+ fornece diversas classes que formam a base para
/// desenhando texto. A interface <A>TGdipGraphics</A> possui vários <A>DrawString</A>
/// métodos que permitem especificar vários recursos de texto, como
/// localização, retângulo delimitador, fonte e formato. Outras interfaces que
/// contribuem para a renderização de texto incluem <A>TGdipFontFamily</A>, <A>TGdipFont</A>,
/// <A>TGdipStringFormat</A>, <A>TGdipInstalledFontCollection</A> e
/// <A>TGdipPrivateFontCollection</A>.
///
/// Microsoft Windows GDI+ agrupa fontes com o mesmo tipo de letra, mas diferentes
/// estilos em famílias de fontes. Por exemplo, a família de fontes Arial contém o
/// seguintes fontes:
///
/// -Arial Regular
/// -Arial Negrito
/// -Arial Itálico
/// -Arial Negrito Itálico
///
/// GDI+ usa quatro estilos para formar famílias: regular, negrito, itálico e negrito
/// itálico. Adjetivos como estreito e arredondado não são considerados estilos;
/// em vez disso, eles fazem parte do nome da família. Por exemplo, Arial Narrow é uma fonte
/// família cujos membros são os seguintes:
///
/// -Arial Estreito Regular
/// -Arial Narrow Bold
/// -Arial Narrow Itálico
/// -Arial Narrow Negrito Itálico
///
/// Antes de poder desenhar texto com GDI+, você precisa construir uma <A>TGdipFontFamily</A>
/// objeto e um objeto <A>TGdipFont</A>. Os objetos <A>TGdipFontFamily</A> especificam
/// o tipo de letra (por exemplo, Arial) e o objeto <A>TGdipFont</A> especifica o
/// tamanho, estilo e unidades.
///
/// O exemplo a seguir constrói uma fonte Arial de estilo regular com um tamanho de
/// 16 pixels:

procedure TDemoConstructingFonts.Run;
var
  FontFamily: TGdipFontFamily;
  Font: TGdipFont;
  Brush: TGdipBrush;
begin
  FontFamily := TGdipFontFamily.Create('Arial');
  Font := TGdipFont.Create(FontFamily, 16, TGdipFontStyle.Regular, TGdipGraphicsUnit.Pixel);
  Brush := TGdipSolidBrush.Create(TGdipColor.Black);
  Graphics.DrawString('A rápida raposa marrom salta sobre o cachorro preguiçoso', Font, Brush, TPointF.Create(0, 0));

  Brush.Free();
  Font.Free();
  FontFamily.Free();
end;

/// No código anterior, o primeiro argumento passado para o <A>TGdipFont</A>
/// construtor é o objeto <A>TGdipFontFamily</A>. O segundo argumento especifica
/// o tamanho da fonte medido em unidades identificadas pelo quarto argumento.
/// O terceiro argumento identifica o estilo.
///
/// UnitPixel é membro da enumeração <A>TUnit</A> e FontStyleRegular
/// um conjunto vazio do tipo <A>TFontStyle</A> enumeração.
{$ENDREGION}

initialization
  RegisterDemo('Usando texto e fontes\Construindo famílias de fontes e fontes', TDemoConstructingFonts);

end.
