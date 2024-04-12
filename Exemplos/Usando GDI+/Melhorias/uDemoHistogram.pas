unit uDemoHistogram;

interface

uses
   Se7e.Drawing,
   Se7e.Drawing.Gdiplus.Types,
   uDemo;

type
  TDemoHistogram = class(TDemo)
  strict protected
    procedure Run; override;
  end;

implementation

uses
  Math;

{ TDemoHistogram }

{$REGION}
/// No GDI+ 1.1, a interface <A>TGdipBitmap</A> possui um método extra chamado
/// <A>ObterHistograma</A>. Este método retorna um histograma com as estatísticas
/// das cores usadas no bitmap.
///
/// O método aceita um único parâmetro com o tipo de histograma que você deseja.
/// Você pode solicitar um histograma para um único canal (por exemplo
/// <A>HistogramFormatB</A>) ou para vários canais (por exemplo
/// <A>HistogramFormatRGB</A>).
///
/// O exemplo abaixo solicita o histograma dos canais RGB de um bitmap
/// e desenha o histograma próximo ao bitmap.
///
/// A propriedade <A>TGdipHistogram.ChannelCount</A> retorna o número de canais
/// no histograma. Para histogramas de canal único este valor é 1; para RGB
/// histogramas esse valor é 3; e para histogramas ARGB/PARGB esse valor é 4.
///
/// A propriedade <A>TGdipHistogram.EntryCount</A> retorna o número de entradas em
/// o histograma de cada canal. Para bitmaps de 8 bits por canal, esse valor
/// geralmente é 256.
///
/// Finalmente, a propriedade <A>Values</A> (que é a propriedade padrão do array
/// para <A>TGdipHistogram</A>) retorna os valores do histograma para o canal fornecido
/// e índice de entrada. Este valor é o número de vezes que um pixel com o dado
/// a intensidade aparece no bitmap. Por exemplo, quando <B>TGdipHistogram[2,30]</B>
/// retorna 1000, isso significa que há 1000 pixels no bitmap que possuem
/// uma intensidade Azul (canal 2) de 30.
///
/// O exemplo abaixo encontra o valor máximo no histograma e usa isso
/// avalia a escala de todos os valores para que o histograma possa ser desenhado com o mesmo
/// altura como o bitmap.

procedure TDemoHistogram.Run;
var
  Bitmap: TGdipBitmap;
  Histogram: TGdipBitmapHistogram;
  I, J, X, Y, MaxVal: Integer;
  Scale: Double;
  Pen: TGdipPen;
begin
  Bitmap := TGdipBitmap.Create('..\..\imagens\ImageFileSmall.jpg');
  Graphics.DrawImage(Bitmap, 10, 10, Bitmap.Width, Bitmap.Height);

  // Recuperar histograma RGB de bitmap
  Histogram := Bitmap.GetHistogram(TGdipHistogramFormat.RGB);

  // Determine the maximum value in the histogram
  MaxVal := 0;
  for J := 0 to Histogram.ChannelCount - 1 do
    for I := 0 to Histogram.EntryCount - 1 do
      MaxVal := Max(MaxVal, Histogram[J, I]);

  // Dimensione o valor máximo para que seja exibido como a altura do bitmap
  Scale := Bitmap.Height / MaxVal;

  // Desenhe o histograma próximo ao bitmap
  Pen := TGdipPen.Create(TGdipColor.FromArgb(0));
  X := 10 + Bitmap.Width + 10;
  Y := 10 + Bitmap.Height;
  for I := 0 to Histogram.ChannelCount - 1 do
  begin
    if (I = 0) then
      Pen.Color := TGdipColor.FromArgb(128, 255, 0, 0)
    else if (I = 1) then
      Pen.Color := TGdipColor.FromArgb(128, 0, 255, 0)
    else
      Pen.Color := TGdipColor.FromArgb(128, 0, 0, 255);

    for J := 0 to Histogram.EntryCount - 1 do
      Graphics.DrawLine(Pen, X + J, Y, X + J, Y - Scale * Histogram[I, J]);
  end;

  Pen.Free();
  Histogram.Free();
  Bitmap.Free();
end;

/// A ilustração acima mostra que o bitmap contém muitos vermelhos em alta
/// intensidades. Esta é principalmente a cor da casca das maçãs e peras no
/// bitmap. Em intensidades mais baixas, os azuis dominam ligeiramente, pois estas cores
/// aparecem nas uvas e folhas mais escuras.
{$ENDREGION}

initialization
  RegisterDemo('Melhorias\Obtendo o histograma de um bitmap', TDemoHistogram);

end.
