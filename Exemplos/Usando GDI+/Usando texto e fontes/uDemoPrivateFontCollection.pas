unit uDemoPrivateFontCollection;

interface

uses
   Windows,
   SysUtils,
   Se7e.Drawing,
   Se7e.Drawing.Gdiplus.Types,
   uDemo;

type
  TDemoPrivateFontCollection = class(TDemo)
  strict protected
    procedure Run; override;
  end;

implementation

{ TDemoPrivateFontCollection }

{$REGION}
/// A interface <A>TGdipPrivateFontCollection</A> herda do
/// <A>IFontCollection</A> interface base abstrata. Você pode usar um
/// Objeto <A>TGdipPrivateFontCollection</A> para manter um conjunto de fontes especificamente
/// para sua aplicação. Uma coleção de fontes privadas pode incluir sistema instalado
/// fontes, bem como fontes que não foram instaladas no computador. Adicionar
/// um arquivo de fonte para uma coleção de fontes privada, chame o método <A>AddFontFile</A>
/// de um objeto <A>TGdipPrivateFontCollection</A>.
///
/// A propriedade <A>Families</A> de um objeto <A>TGdipPrivateFontCollection</A>
/// retorna um array de objetos <A>TGdipFontFamily</A>.
///
/// O número de famílias de fontes em uma coleção de fontes privada não é necessariamente
/// igual ao número de arquivos de fontes que foram adicionados à coleção.
/// Por exemplo, suponha que você adicione os arquivos ArialBd.tff, Times.tff e
/// TimesBd.tff para uma coleção. Haverá três arquivos, mas apenas duas famílias
/// na coleção porque Times.tff e TimesBd.tff pertencem à mesma
/// família.
///
/// O exemplo a seguir adiciona os três arquivos de fonte a seguir a um objeto PrivateFontCollection:
///
/// -<WinDir>\Fonts\Arial.tff (Arial, regular)
/// -<WinDir>\Fonts\CourBI.tff (Courier New, negrito itálico)
/// -<WinDir>\Fonts\TimesBd.tff (Times New Roman, negrito)
///
/// Para cada objeto <A>TGdipFontFamily</A> na coleção, o código chama o
/// Método <A>IsStyleAvailable</A> para determinar se vários estilos (regular,
/// negrito, itálico, negrito itálico, sublinhado e riscado) estão disponíveis. O
/// argumento passado para o método <A>IsStyleAvailable</A> são membros do
/// enumeração <A>TFontStyle</A>.
///
/// Se uma determinada combinação de família/estilo estiver disponível, um objeto <A>TGdipFont</A> é
/// construído usando essa família e estilo. O primeiro argumento passado para o
/// O construtor <A>TGdipFont</A> é o nome da família da fonte (não uma <A>TGdipFontFamily</A>
/// objeto como é o caso de outras variações do construtor <A>TGdipFont</A>),
/// e o argumento final é o objeto <A>TGdipPrivateFontCollection</A>. Depois
/// o objeto <A>TGdipFont</A> é construído, ele é passado para o <A>DrawString</A>
/// método da classe <A>TGdipGraphics</A> para exibir o nome da família junto com
/// o nome do estilo.

procedure TDemoPrivateFontCollection.Run;
var
  WinDir: array [0..MAX_PATH] of Char;
  FontDir, FamilyName: String;
  Collection: TGdipPrivateFontCollection;
  Family: TGdipFontFamily;
  Font: TGdipFont;
  Point: TGdipPointF;
  Brush: TGdipBrush;
begin
  GetWindowsDirectory(WinDir, MAX_PATH);
  FontDir := IncludeTrailingPathDelimiter(WinDir) + 'Fonts' + PathDelim;
  Collection := TGdipPrivateFontCollection.Create;
  Collection.AddFontFile(FontDir + 'Arial.ttf');
  Collection.AddFontFile(FontDir + 'CourBI.ttf');
  Collection.AddFontFile(FontDir + 'TimesBd.ttf');
  Point.Initialize(10, 0);
  Brush := TGdipSolidBrush.Create(TGdipColor.Black);

  for Family in Collection.Families do
  begin
    FamilyName := Family.FamilyName;

    // O estilo regular está disponível?
    if (Family.IsStyleAvailable(FontStyleRegular)) then
    begin
      Font := TGdipFont.Create(FamilyName, 16, FontStyleRegular, UnitPixel, Collection);
      Graphics.DrawString(FamilyName + ' Regular', Font, Point, Brush);
      Point.Y := Point.Y + Font.GetHeight(0);
    end;

    // O estilo negrito está disponível?
    if (Family.IsStyleAvailable([FontStyleBold])) then
    begin
      Font := TGdipFont.Create(FamilyName, 16, [FontStyleBold], UnitPixel, Collection);
      Graphics.DrawString(FamilyName + ' Bold', Font, Point, Brush);
      Point.Y := Point.Y + Font.GetHeight(0);
    end;

    // O estilo itálico está disponível?
    if (Family.IsStyleAvailable([FontStyleItalic])) then
    begin
      Font := TGdipFont.Create(FamilyName, 16, [FontStyleItalic], UnitPixel, Collection);
      Graphics.DrawString(FamilyName + ' Italic', Font, Point, Brush);
      Point.Y := Point.Y + Font.GetHeight(0);
    end;

    // O estilo negrito e itálico está disponível?
    if (Family.IsStyleAvailable([FontStyleBold, FontStyleItalic])) then
    begin
      Font := TGdipFont.Create(FamilyName, 16, [FontStyleBold, FontStyleItalic], UnitPixel, Collection);
      Graphics.DrawString(FamilyName + ' Bold Italic', Font, Point, Brush);
      Point.Y := Point.Y + Font.GetHeight(0);
    end;

    // O estilo de sublinhado está disponível?
    if (Family.IsStyleAvailable([FontStyleUnderline])) then
    begin
      Font := TGdipFont.Create(FamilyName, 16, [FontStyleUnderline], UnitPixel, Collection);
      Graphics.DrawString(FamilyName + ' Underline', Font, Point, Brush);
      Point.Y := Point.Y + Font.GetHeight(0);
    end;

    // O estilo riscado está disponível?
    if (Family.IsStyleAvailable([FontStyleStrikeout])) then
    begin
      Font := TGdipFont.Create(FamilyName, 16, [FontStyleStrikeout], UnitPixel, Collection);
      Graphics.DrawString(FamilyName + ' Strkeout', Font, Point, Brush);
      Point.Y := Point.Y + Font.GetHeight(0);
    end;

    // Separe as famílias com espaços em branco.
    Point.Y := Point.Y + 10;
  end;
end;

/// Arial.tff (que foi adicionado à coleção de fontes privadas no anterior
/// exemplo de código) é o arquivo de fonte para o estilo regular Arial. Observe, no entanto,
/// que a saída do programa mostra vários estilos disponíveis além do normal
/// para a família de fontes Arial. Isso ocorre porque o Microsoft Windows GDI+ pode
/// simula os estilos negrito, itálico e negrito itálico do estilo regular.
/// GDI+ também pode produzir sublinhados e riscados do estilo regular.
///
/// Da mesma forma, GDI+ pode simular o estilo negrito itálico a partir do negrito
/// estilo ou o estilo itálico. A saída do programa mostra que o negrito itálico
/// o estilo está disponível para a família Times, embora TimesBd.tff (Times New
/// Roman, negrito) é o único arquivo Times na coleção.
{$ENDREGION}

initialization
  RegisterDemo('Usando texto e fontes\Criando uma coleção de fontes privada', TDemoPrivateFontCollection);

end.
