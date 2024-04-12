unit uDemoPixelFormatConversion;

interface

uses
   Se7e.Drawing,
   Se7e.Drawing.Gdiplus.Types,
   uDemo;

type
  TDemoPixelFormatConversion = class(TDemo)
  strict protected
    procedure Run; override;
  end;

implementation

{ TDemoPixelFormatConversion }

{$REGION}
/// GDI+ 1.1 fornece o método <A>TGdipBitmap.ConvertFormat</A> para converter um
/// bitmap para um formato de pixel diferente. Por exemplo, você pode converter um bitmap
/// de uma imagem True Color (24 bits por pixel) para uma imagem indexada (4 ou 8
/// bits por pixel) com uma paleta de cores.
///
/// Ao criar uma versão indexada de bitmap, geralmente você deseja criar um
/// paleta de cores ideal que representa as cores no bitmap como precisas
/// que possível. Você pode criar essa paleta chamando a classe static
/// Método <A>TGdipBitmap.InitializePalette</A>. Você especifica quantas cores deseja
/// deseja na paleta, como a paleta deve ser gerada (use
/// <A>PaletteTypeOptimal</A> para uma paleta ideal) e o bitmap da paleta
/// deve ser criado para. O método retorna um objeto <A>TGdipColorPalette</A>.
///
/// Você passa o <A>TGdipColorPalette</A> para o método <A>TGdipBitmap.ConvertFormat</A>
/// junto com algumas outras configurações, como o formato de pixel solicitado e o
/// tipo de pontilhamento que deve ser usado.
///
/// O exemplo abaixo carrega um bitmap de um arquivo e cria 3 cores reduzidas
/// versões dele. As duas primeiras versões de cores reduzidas resultam em 16 cores
/// bitmap. A primeira versão usa pontilhamento sólido (<A>DitherTypeSolid</A>) e
/// a segunda versão usa pontilhamento de difusão (<A>DitherTypeErrorDiffusion</A>)
/// Como você pode ver nos resultados acima, o pontilhamento por difusão geralmente leva a
/// os melhores resultados.
/// A versão final é uma conversão de 256 cores (8 bits por pixel) que usa
/// dithering de difusão também. Você pode ver que este bitmap corresponde mais de perto
/// o original.

procedure TDemoPixelFormatConversion.Run;
var
  Bitmap: TGdipBitmap;
  Palette: TGdipColorPalette;
begin
  Bitmap := TGdipBitmap.Create('..\..\imagens\ImageFileSmall.jpg');
  Graphics.DrawImage(Bitmap, 0, 0, Bitmap.Width, Bitmap.Height);

  // Converter para um bitmap de 16 cores (4 bits por pixel) usando pontilhamento sólido
  Palette := TGdipColorPalette.CreateOptimalPalette(16, False, 16, Bitmap);
  Bitmap.ConvertFormat(TGdipPixelFormat.FOrmat4bppIndexed, TGdipDitherType.Solid, TGdipPaletteType.Optimal, Palette, 0);
  Graphics.DrawImage(Bitmap, 330, 0, Bitmap.Width, Bitmap.Height);
  Palette.Free();
  Bitmap.Free();

  // Converter para um bitmap de 16 cores (4 bits por pixel) usando pontilhamento de difusão
  Bitmap := TGdipBitmap.Create('..\..\imagens\ImageFileSmall.jpg');
  Palette := TGdipColorPalette.CreateOptimalPalette(16, False, 16, Bitmap);
  Bitmap.ConvertFormat(TGdipPixelFormat.Format4bppIndexed, TGdipDitherType.ErrorDiffusion, TGdipPaletteType.Optimal, Palette, 0);
  Graphics.DrawImage(Bitmap, 0, 210, Bitmap.Width, Bitmap.Height);
  Palette.Free();
  Bitmap.Free();

  // Converter para um bitmap de 256 cores (8 bits por pixel) usando pontilhamento por difusão
  Bitmap := TGdipBitmap.Create('..\..\imagens\ImageFileSmall.jpg');
  Palette := TGdipColorPalette.CreateOptimalPalette(256, False, 256, Bitmap);
  Bitmap.ConvertFormat(TGdipPixelFormat.Format8bppIndexed, TGdipDitherType.ErrorDiffusion, TGdipPaletteType.Optimal, Palette, 0);
  Graphics.DrawImage(Bitmap, 330, 210, Bitmap.Width, Bitmap.Height);
  Palette.Free();
  Bitmap.Free();
end;
{$ENDREGION}

initialization
  RegisterDemo('Melhorias\Converter formato de pixel para bitmaps', TDemoPixelFormatConversion);

end.
