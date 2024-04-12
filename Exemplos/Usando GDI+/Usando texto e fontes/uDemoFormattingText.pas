unit uDemoFormattingText;

interface

uses
   Types,
   Se7e.Drawing,
   Se7e.Drawing.Gdiplus.Types,
   uDemo;

type
  TDemoFormattingText = class(TDemo)
  strict private
    procedure AligningText;
    procedure SettingTabStops;
    procedure DrawingVerticalText;
  strict protected
    procedure Run; override;
  end;

implementation

{ TDemoFormattingText }

{$REGION}
/// Para aplicar formatação especial ao texto, inicialize um <A>TGdipStringFormat</A>
/// objeto e passamos esse objeto para o método <A>DrawString</A> do
/// Interface <A>TGdipGráficos</A>.
///
/// Para desenhar texto formatado em um retângulo, você precisa de <A>TGdipGraphics</A>,
/// <A>TGdipFontFamily</A>, <A>TGdipFont</A>, <A>TGdipRectF</A>, <A>TGdipStringFormat</A> e
/// Objetos <A>TGdipBrush</A>.
///
/// <H>Alinhando texto</H>
/// O exemplo a seguir desenha texto em um retângulo. Cada linha de texto é
/// centralizado (lado a lado), e todo o bloco de texto é centralizado (de cima para
/// inferior) no retângulo.

procedure TDemoFormattingText.AligningText;
var
  FontFamily: TGdipFontFamily;
  Font: TGdipFont;
  Rect: TRectangleF;
  StringFormat: TGdipStringFormat;
  SolidBrush: TGdipBrush;
  Pen: TGdipPen;
begin
  FontFamily := TGdipFontFamily.Create('Arial');
  Font := TGdipFont.Create(FontFamily, 12, TGdipFontStyle.Bold, TGdipGraphicsUnit.Point);
  Rect := TRectangleF.Create(10, 10, 160, 140);
  StringFormat := TGdipStringFormat.Create;
  SolidBrush := TGdipSolidBrush.Create(TGdipColor.FromArgb(255, 0, 0, 255));

  // Centralize cada linha de texto.
  StringFormat.Alignment := TGdipStringAlignment.Center;

  // Centralize o bloco de texto (de cima para baixo) no retângulo.
  StringFormat.LineAlignment := TGdipStringAlignment.Center;

  Graphics.DrawString('Use objetos TGdipStringFormat e TRectangleF para centralizar o texto em um retângulo.',
    Font, SolidBrush, Rect, StringFormat);

  Pen := TGdipPen.Create(TGdipColor.FromArgb(255, 0, 0, 0));
  Graphics.DrawRectangle(Pen, Rect);

  Pen.Free();
  SolidBrush.Free();
  StringFormat.Free();
  Font.Free();
  FontFamily.Free();
end;

/// O código anterior define duas propriedades do objeto <A>TGdipStringFormat</A>:
/// <A>Alignment</A> e <A>LineAlignment</A>. A atribuição para <A>Alinhamento</A>
/// especifica que cada linha de texto é centralizada no retângulo dado pelo
/// terceiro argumento passado para o método <A>DrawString</A>. A atribuição a
/// <A>LineAlignment</A> especifica que o bloco de texto está centralizado (de cima para
/// inferior) no retângulo.
///
/// O valor StringAlignmentCenter é um elemento do <A>TStringAlignment</A>
/// enumeração.
///
/// <H>Configurando paradas de tabulação</H>
/// Você pode definir paradas de tabulação para texto chamando o método <A>SetTabStops</A> de um
/// objeto <A>TGdipStringFormat</A> e depois passar esse <A>TGdipStringFormat</A>
/// objeto para o método <A>DrawString</A> da interface <A>TGdipGraphics</A>.
///
/// O exemplo a seguir define paradas de tabulação em 150, 250 e 350. Em seguida, o código
/// exibe uma lista com guias de nomes e pontuações de testes.

procedure TDemoFormattingText.SettingTabStops;
const
  Tabs: TArray<Single> = [150, 100, 100];
  Str = 'Name'#9'Test 1'#9'Test 2'#9'Test 3'#13#10+
        'Joe'#9'95'#9'88'#9'91'#13#10+
        'Mary'#9'98'#9'84'#9'90'#13#10+
        'Sam'#9'42'#9'76'#9'98'#13#10+
        'Jane'#9'65'#9'73'#9'92';
var
  FontFamily: TGdipFontFamily;
  Font: TGdipFont;
  Rect: TRectangleF;
  StringFormat: TGdipStringFormat;
  SolidBrush: TGdipBrush;
  Pen: TGdipPen;
begin
  FontFamily := TGdipFontFamily.Create('Courier New');
  Font := TGdipFont.Create(FontFamily, 12, TGdipFontStyle.Regular, TGdipGraphicsUnit.Point);
  Rect := TRectangleF.Create(190, 10, 500, 100);
  StringFormat := TGdipStringFormat.Create;
  SolidBrush := TGdipSolidBrush.Create(TGdipColor.FromArgb(255, 0, 0, 255));

  StringFormat.SetTabStops(0, Tabs);

  Graphics.DrawString(Str, Font, SolidBrush, Rect, StringFormat);

  Pen := TGdipPen.Create(TGdipColor.FromArgb(255, 0, 0, 0));
  Graphics.DrawRectangle(Pen, Rect);

  Pen.Free();
  SolidBrush.Free();
  StringFormat.Free();
  Font.Free();
  FontFamily.Free();
end;

/// O código anterior passa três argumentos para o método <A>SetTabStops</A>.
/// O segundo argumento é um array contendo os deslocamentos de tabulação. O primeiro
/// argumento passado para <A>SetTabStops</A> é 0, o que indica que o primeiro
/// o deslocamento no array é medido a partir da posição 0, a borda esquerda do
/// retângulo delimitador.
///
/// <H>Desenhando texto vertical</H>
/// Você pode usar um objeto <A>TGdipStringFormat</A> para especificar que o texto seja desenhado
/// verticalmente em vez de horizontalmente.
///
/// O exemplo a seguir passa o valor [StringFormatFlagsDirectionVertical]
/// para a propriedade <A>FormatFlags</A> de um objeto <A>TGdipStringFormat</A>. Que
/// O objeto <A>TGdipStringFormat</A> é passado para o método <A>IDrawString<A> do
/// Interface <A>TGdipGráficos</A>. O valor StringFormatFlagsDirectionVertical é
/// um elemento da enumeração <A>TStringFormatFlags</A>.

procedure TDemoFormattingText.DrawingVerticalText;
var
  FontFamily: TGdipFontFamily;
  Font: TGdipFont;
  Point: TPointF;
  StringFormat: TGdipStringFormat;
  SolidBrush: TGdipBrush;
begin
  FontFamily := TGdipFontFamily.Create('Lucida Console');
  Font := TGdipFont.Create(FontFamily, 14, TGdipFontStyle.Regular, TGdipGraphicsUnit.Point);
  Point := TPointF.Create(190, 120);
  StringFormat := TGdipStringFormat.Create;
  SolidBrush := TGdipSolidBrush.Create(TGdipColor.FromArgb(255, 0, 0, 255));

  StringFormat.FormatFlags := TGdipStringFormatFlags.DirectionVertical;

  Graphics.DrawString('Texto vertical', Font, SolidBrush, Point, StringFormat);

  SolidBrush.Free();
  StringFormat.Free();
  Font.Free();
  FontFamily.Free();
end;
{$ENDREGION}

procedure TDemoFormattingText.Run;
begin
  AligningText;
  SettingTabStops;
  DrawingVerticalText;
end;

initialization
  RegisterDemo('Usando texto e fontes\Formatando texto', TDemoFormattingText);

end.
