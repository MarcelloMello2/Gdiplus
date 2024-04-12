unit uDemoFontMetrics;

interface

uses
   Se7e.Drawing,
   Se7e.Drawing.Gdiplus.Types,
   uDemo;

type
  TDemoFontMetrics = class(TDemo)
  strict protected
    procedure Run; override;
  public
    class function Outputs: TDemoOutputs; override;
  end;

implementation

uses
  SysUtils;

{ TDemoFontMetrics }

class function TDemoFontMetrics.Outputs: TDemoOutputs;
begin
  Result := [doText];
end;

{$REGION}
/// A interface <A>TGdipFontFamily</A> fornece os seguintes métodos que
/// recupera diversas métricas para uma determinada combinação de família/estilo:
///
/// -<A>GetEmHeight</A>(FontStyle)
/// -<A>GetCellAscent</A>(FontStyle)
/// -<A>GetCellDescent</A>(FontStyle)
/// -<A>GetLineSpacing</A>(FontStyle)
///
/// Os números retornados por esses métodos estão em unidades de design de fonte, portanto são
/// independente do tamanho e das unidades de um objeto <A>TGdipFont</A> específico.
///
/// O exemplo a seguir exibe as métricas para o estilo regular do
/// Família de fontes Arial.

procedure TDemoFontMetrics.Run;
var
  FontFamily: TGdipFontFamily;
  Font: TGdipFont;
  Ascent, Descent, LineSpacing: Integer;
  AscentPixel, DescentPixel, LineSpacingPixel: Single;
begin
  FontFamily := TGdipFontFamily.Create('Arial');
  Font := TGdipFont.Create(FontFamily, 16, TGdipFontStyle.Regular, TGdipGraphicsUnit.Pixel);

  TextOutput.Add(Format('Font.Size returns %g.', [Font.Size]));
  TextOutput.Add(Format('FontFamily.GetEmHeight retorna %d.',
    [FontFamily.GetEmHeight(TGdipFontStyle.Regular)]));

  Ascent := FontFamily.GetCellAscent(TGdipFontStyle.Regular);
  AscentPixel := Font.Size * Ascent / FontFamily.GetEmHeight(TGdipFontStyle.Regular);
  TextOutput.Add(Format('A ascensão é de %d unidades de design, %g pixels.',
    [Ascent, AscentPixel]));

  Descent := FontFamily.GetCellDescent(TGdipFontStyle.Regular);
  DescentPixel := Font.Size * Descent / FontFamily.GetEmHeight(TGdipFontStyle.Regular);
  TextOutput.Add(Format('O afundamento é de %d unidades de design, %g pixels.',
    [Descent, DescentPixel]));

  LineSpacing := FontFamily.GetLineSpacing(TGdipFontStyle.Regular);
  LineSpacingPixel := Font.Size * LineSpacing / FontFamily.GetEmHeight(TGdipFontStyle.Regular);
  TextOutput.Add(Format('O espaçamento entre linhas é de %d unidades de design, %g pixels.',
    [LineSpacing, LineSpacingPixel]));


  Font.Free();
  FontFamily.Free();
end;

/// Observe as duas primeiras linhas da saída acima. O objeto <A>TGdipFont</A> retorna um
/// tamanho 16, e o objeto <A>TGdipFontFamily</A> retorna uma altura em de 2.048.
/// Esses dois números (16 e 2.048) são a chave para a conversão entre fontes
/// projeta unidades e as unidades (neste caso pixels) do objeto <A>TGdipFont</A>.
{$ENDREGION}

initialization
  RegisterDemo('Usando texto e fontes\Obtendo métricas de fonte', TDemoFontMetrics);

end.
