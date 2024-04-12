unit uDemoListInstalledEncoders;

interface

uses
   Se7e.Drawing,
   Se7e.Drawing.Gdiplus.Types,
   uDemo;

type
  TDemoListInstalledEncoders = class(TDemo)
  strict protected
    procedure Run; override;
  public
    class function Outputs: TDemoOutputs; override;
  end;

implementation

{ TDemoListInstalledEncoders }

class function TDemoListInstalledEncoders.Outputs: TDemoOutputs;
begin
  Result := [doText];
end;

{$REGION}
/// Microsoft Windows GDI+ fornece a classe <A>Image</A> e o <A>Bitmap</A>
/// classe para armazenar imagens na memória e manipular imagens na memória. GDI+
/// grava imagens em arquivos de disco com a ajuda de codificadores de imagens e carrega imagens
/// de arquivos de disco com a ajuda de decodificadores de imagem. Um codificador traduz o
/// dados em um objeto Imagem ou Bitmap em um formato de arquivo de disco designado. A
/// decodificador traduz os dados em um arquivo de disco para o formato exigido pelo
/// Objetos <A>Imagem</A> e <A>Bitmap</A>. GDI+ possui codificadores e decodificadores integrados que oferecem suporte aos seguintes tipos de arquivo:
///
///  -BMP
///  -GIF
///  -JPEG
///  -PNG
///  -TIFF
///
/// GDI+ também possui decodificadores integrados que suportam os seguintes tipos de arquivo:
///
///  -WMF
///  -EMF
///  -ICON
///
/// GDI+ fornece a função de classe <A>TGdipImageCodecInfo.GetImageEncoders</A>
/// para que você possa determinar quais codificadores de imagem estão disponíveis em seu
/// computador. <A>TGdipImageCodecInfo.GetImageEncoders</A> retorna uma matriz de
/// objetos <A>TGdipImageCodecInfo</A>.

procedure TDemoListInstalledEncoders.Run;
var
//  Encoders: TGdipImageCodecInfoArray;
  Encoder: TGdipImageCodecInfo;
begin
  var Encoders := TGdipImageCodecInfo.GetImageEncoders;
  for Encoder in Encoders do
    TextOutput.Add(Encoder.MimeType);
end;

/// A saída acima deve mostrar pelo menos as seguintes entradas:
///
///  image/bmp
///  image/jpeg
///  image/gif
///  image/tiff
///  image/png
{$ENDREGION}

initialization
  RegisterDemo('Usando codificadores e decodificadores de imagens\Listando codificadores instalados', TDemoListInstalledEncoders);

end.
