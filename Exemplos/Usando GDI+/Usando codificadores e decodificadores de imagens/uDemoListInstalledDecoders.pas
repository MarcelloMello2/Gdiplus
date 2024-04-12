unit uDemoListInstalledDecoders;

interface

uses
   Se7e.Drawing,
   Se7e.Drawing.Gdiplus.Types,
   uDemo;

type
  TDemoListInstalledDecoders = class(TDemo)
  strict protected
    procedure Run; override;
  public
    class function Outputs: TDemoOutputs; override;
  end;

implementation

{ TDemoListInstalledDecoders }

class function TDemoListInstalledDecoders.Outputs: TDemoOutputs;
begin
  Result := [doText];
end;

{$REGION}
/// Microsoft Windows GDI+ fornece o <A>TGdipImageCodecInfo.GetImageDecoders</A>
/// função de classe para que você possa determinar quais decodificadores de imagem estão disponíveis
/// no seu computador. <A>TGdipImageCodecInfo.GetImageDecoders</A> retorna uma matriz
/// de objetos <A>TGdipImageCodecInfo</A>.

procedure TDemoListInstalledDecoders.Run;
var
//  Decoders: TGdipImageCodecInfoArray;
  Decoder: TGdipImageCodecInfo;
begin
  var Decoders := TGdipImageCodecInfo.GetImageDecoders;
  for Decoder in Decoders do
    TextOutput.Add(Decoder.MimeType);
end;

/// A saída acima deve mostrar pelo menos as seguintes entradas:
///
///  image/bmp
///  image/jpeg
///  image/gif
///  image/x-emf
///  image/x-wmf
///  image/tiff
///  image/png
///  image/x-icon
{$ENDREGION}

initialization
  RegisterDemo('Usando codificadores e decodificadores de imagens\Listando decodificadores instalados', TDemoListInstalledDecoders);

end.
