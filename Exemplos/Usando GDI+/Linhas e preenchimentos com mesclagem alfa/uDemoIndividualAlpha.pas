unit uDemoIndividualAlpha;

interface

uses
   Se7e.Drawing,
   Se7e.Drawing.Gdiplus.Types,
   uDemo;

type
  TDemoIndividualAlpha = class(TDemo)
  strict protected
    procedure Run; override;
  end;

implementation

{ TDemoIndividualAlpha }

{$REGION}
/// O exemplo anterior <A>Usando uma matriz de cores para definir valores alfa em imagens</A>
/// mostra um método não destrutivo para alterar os valores alfa de uma imagem. O
/// exemplo nesse tópico renderiza uma imagem de forma semitransparente, mas os dados de pixel
/// no bitmap não é alterado. Os valores alfa são alterados apenas durante
/// Renderização.
///
/// O exemplo a seguir mostra como alterar os valores alfa de indivíduos
/// píxeis. O código no exemplo na verdade altera as informações alfa em um
/// Objeto <A>TGdipBitmap</A>. A abordagem é muito mais lenta do que usar uma matriz de cores
/// e um objeto <A>TGdipImageAttributes</A>, mas dá a você controle sobre o
/// pixels individuais no bitmap.

procedure TDemoIndividualAlpha.Run;
var
  Bitmap: TGdipBitmap;
  Width, Height, Row, Column: Integer;
  Color: TGdipColor;
  Pen: TGdipPen;
begin
  Bitmap := TGdipBitmap.Create('..\..\imagens\Texture1.png');
  Width := Bitmap.Width;
  Height := Bitmap.Height;
  for Row := 0 to Height - 1 do
  begin
    for Column := 0 to Width - 1 do
    begin
      Color := Bitmap.Pixels[Column, Row];
      Bitmap.Pixels[Column, Row] := TGdipColor.FromArgb((255 * Column) div Width, Color.R, Color.G, Color.B);
    end;
  end;
  Pen := TGdipPen.Create(TGdipColor.FromArgb(255, 0, 0, 0), 25);
  Graphics.DrawLine(Pen, TPoint.Create(10, 35), TPoint.Create(200, 35));
  Graphics.DrawImage(Bitmap, 30, 0, Bitmap.Width, Bitmap.Height);

  Pen.Free();
  Bitmap.Free();
end;

/// O exemplo de código anterior usa loops aninhados para alterar o valor alfa de
/// cada pixel no bitmap. Para cada pixel, a propriedade <A>TGdipBitmap.Pixels</A>
/// retorna a cor existente, <A>TGdipColor.SetAlpha</A> altera o valor alfa
/// da cor, e a cor modificada é armazenada no bitmap novamente. O
/// o valor alfa é definido com base na coluna do bitmap. Na primeira coluna,
/// alfa é definido como 0. Na última coluna, alfa é definido como 255. Portanto, o resultado
/// a imagem passa de totalmente transparente (na borda esquerda) para totalmente opaca (na borda
/// borda direita).
///
/// A propriedade <A>TGdipBitmap.Pixels</A> fornece controle do pixel individual
/// valores. No entanto, usar <A>TGdipBitmap.Pixels</A> não é tão rápido quanto usar
/// a interface <A>TGdipImageAttributes</A> e o registro <A>TGdipColorMatrix</A>.
{$ENDREGION}

initialization
  RegisterDemo('Linhas e preenchimentos com mesclagem alfa\Configurando os valores alfa de pixels individuais', TDemoIndividualAlpha);

end.
