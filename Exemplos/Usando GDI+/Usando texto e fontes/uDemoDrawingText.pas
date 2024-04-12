unit uDemoDrawingText;

interface

uses
   Types,
   Se7e.Drawing,
   Se7e.Drawing.Gdiplus.Types,
   uDemo;

type
  TDemoDrawingText = class(TDemo)
  strict private
    procedure DrawAtLocation;
    procedure DrawInRectangle;
  strict protected
    procedure Run; override;
  end;

implementation

{ TDemoDrawingText }

{$REGION}
/// Você pode usar o método <A>DrawString</A> da classe <A>TGdipGraphics</A> para
/// desenha texto em um local especificado ou dentro de um retângulo especificado.
///
/// <H>Desenhando texto em um local específico</H>
/// Para desenhar texto em um local específico, você precisa de <A>TGdipGraphics</A>,
/// Objetos <A>TGdipFontFamily</A>, <A>TGdipFont</A>, <A>TGdipPointF</A> e <A>TGdipBrush</A>.
///
/// O exemplo a seguir desenha a string "Hello" no local (30, 10). O
/// a família da fonte é Times New Roman. A fonte, que é um membro individual do
/// a família da fonte é Times New Roman, tamanho 24 pixels, estilo regular.

procedure TDemoDrawingText.DrawAtLocation;
var
  FontFamily: TGdipFontFamily;
  Font: TGdipFont;
  Point: TPointF;
  SolidBrush: TGdipBrush;
begin
  FontFamily := TGdipFontFamily.Create('Times New Roman');
  Font := TGdipFont.Create(FontFamily, 24, TGdipFontStyle.Regular, TGdipGraphicsUnit.Pixel);
  Point := TPointF.Create(30, 10);
  SolidBrush := TGdipSolidBrush.Create(TGdipColor.FromArgb(255, 0, 0, 255));
  Graphics.DrawString('Olá', Font, SolidBrush, Point);

  SolidBrush.Free();
  Font.Free();
  FontFamily.Free();
end;

/// No exemplo anterior, o construtor <A>TGdipFontFamily</A> recebe um
/// string que identifica a família da fonte. O objeto <A>TGdipFontFamily</A> é
/// passado como primeiro argumento para o construtor <A>TGdipFont</A>. O segundo
/// argumento passado para o construtor <A>TGdipFont</A> especifica o tamanho do
/// fonte medida em unidades dadas pelo quarto argumento. O terceiro argumento
/// especifica o estilo (regular, negrito, itálico e assim por diante) da fonte.
///
/// O método <A>DrawString</A> recebe quatro argumentos. O primeiro argumento é
/// a string a ser desenhada. O segundo argumento é o objeto <A>TGdipFont</A> que
/// foi construído anteriormente. O terceiro argumento é um registro <A>TGdipPointF</A>
/// que contém as coordenadas do canto superior esquerdo da string. O
/// o quarto argumento é um objeto <A>TGdipBrush</A> que será usado para preencher o
/// caracteres da string.
///
/// <H>Desenhando texto em um retângulo</H>
/// Um dos métodos <A>DrawString</A> da interface <A>TGdipGraphics</A> tem um
/// Parâmetro <A>TGdipRectF</A>. Chamando esse método <A>DrawString</A>, você pode
/// desenha texto que envolve um retângulo especificado. Para desenhar texto em um retângulo,
/// você precisa de <A>TGdipGraphics</A>, <A>TGdipFontFamily</A>, <A>TGdipFont</A>, <A>TGdipRectF</A>
/// e objetos <A>TGdipBrush</A>.
///
/// O exemplo a seguir cria um retângulo com canto superior esquerdo (30, 50),
/// largura 100 e altura 122. Então o código desenha uma string dentro dessa
/// retângulo. A corda é restrita ao retângulo e enrolada de tal forma
/// que palavras individuais não sejam quebradas.

procedure TDemoDrawingText.DrawInRectangle;
var
  FontFamily: TGdipFontFamily;
  Font: TGdipFont;
  Rect: TRectangleF;
  SolidBrush: TGdipBrush;
  Pen: TGdipPen;
begin
  FontFamily := TGdipFontFamily.Create('Arial');
  Font := TGdipFont.Create(FontFamily, 12, TGdipFontStyle.Bold, TGdipGraphicsUnit.Point);
  Rect := TRectangleF.Create(30, 50, 120, 122);
  SolidBrush := TGdipSolidBrush.Create(TGdipColor.FromArgb(255, 0, 0, 255));
  Graphics.DrawString('Desenhe o texto em um retângulo passando um TRectangleF para o método DrawString', Font, SolidBrush, Rect);

  Pen := TGdipPen.Create(TGdipColor.FromArgb(255, 0, 0, 0));
  Graphics.DrawRectangle(Pen, Rect);

  Pen.Free();
  SolidBrush.Free();
  Font.Free();
  FontFamily.Free();
end;

/// No exemplo anterior, o terceiro argumento passado para <A>DrawString</A>
/// método é um registro <A>TGdipRectF</A> que especifica o retângulo delimitador para
/// o texto. O quarto parâmetro é do tipo <A>TGdipStringFormat</A> — o
/// o argumento é nulo porque nenhuma formatação especial de string é necessária.
{$ENDREGION}

procedure TDemoDrawingText.Run;
begin
  DrawAtLocation;
  DrawInRectangle;
end;

initialization
  RegisterDemo('Usando texto e fontes\Desenhando texto', TDemoDrawingText);

end.
