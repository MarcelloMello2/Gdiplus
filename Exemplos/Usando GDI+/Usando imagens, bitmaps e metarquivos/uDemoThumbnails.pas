unit uDemoThumbnails;

interface

uses
   Se7e.Drawing,
   Se7e.Drawing.Gdiplus.Types,
   uDemo;

type
  TDemoThumbnails = class(TDemo)
  strict protected
    procedure Run; override;
  end;

implementation

{$REGION}
/// Uma imagem em miniatura é uma versão pequena de uma imagem. Você pode criar uma miniatura
/// imagem chamando o método <A>GetThumbnailImage</A> de um <A>TGdipImage</A>
/// objeto.
///
/// O exemplo a seguir constrói um objeto <A>TGdipImage</A> a partir do arquivo
///ImageFile.jpg. A imagem original tem largura de 640 pixels e altura de
/// 480 pixels. O código cria uma imagem em miniatura com largura de 100
/// pixels e uma altura de 100 pixels.

procedure TDemoThumbnails.Run;
var
  Image, Thumbnail: TGdipImage;
begin
  Image := TGdipImage.FromFile('..\..\imagens\ImageFile.jpg');
  Thumbnail := Image.GetThumbnailImage(100, 100, nil, nil);
  Graphics.DrawImage(Thumbnail, 10, 10, Thumbnail.Width, Thumbnail.Height);
  Thumbnail.Free();
  Image.Free();
end;
{$ENDREGION}

initialization
  RegisterDemo('Usando imagens, bitmaps e metarquivos\Criando imagens em miniatura', TDemoThumbnails);

end.
