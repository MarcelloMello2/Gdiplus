unit uDemoBmpToPng;

interface

uses
   Se7e.Drawing,
   Se7e.Drawing.Gdiplus.Types,
   uDemo;

type
  TDemoBmpToPng = class(TDemo)
  strict protected
    procedure Run; override;
  public
    class function Outputs: TDemoOutputs; override;
  end;

implementation

uses
  SysUtils;

{ TDemoBmpToPng }

class function TDemoBmpToPng.Outputs: TDemoOutputs;
begin
  Result := [doText, doGraphic];
end;

{$REGION}
/// Para salvar uma imagem em um arquivo de disco, chame o método <A>Save</A> do
/// Interface <A>TGdipImage</A>. O exemplo a seguir carrega uma imagem BMP de um disco
/// arquivo, converte a imagem para o formato PNG e salva a imagem convertida em
/// um novo arquivo de disco. O código usa a propriedade de classe predefinida
/// TGdipImageFormat.Png para salvar uma imagem no formato PNG.

procedure TDemoBmpToPng.Run;
var
  Image: TGdipImage;
begin
  Image := TGdipImage.FromFile('..\..\imagens\Bird.bmp');
  Graphics.DrawImage(Image, 10, 10, Image.Width, Image.Height);
  try
    Image.Save('Bird.png', TGdipImageFormat.Png);
    TextOutput.Add('Bird.png foi salvo com sucesso.');
    Image.Free();

    Image := TGdipImage.FromFile('Bird.png');
    Graphics.DrawImage(Image, 130, 10, Image.Width, Image.Height);
    Image.Free();
  except
    on E: Exception do
      TextOutput.Add('Falha: ' + E.Message);
  end;
end;
{$ENDREGION}

initialization
  RegisterDemo('Usando codificadores e decodificadores de imagens\Convertendo uma imagem BMP em uma imagem PNG', TDemoBmpToPng);

end.
