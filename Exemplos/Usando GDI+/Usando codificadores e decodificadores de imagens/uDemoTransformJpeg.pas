unit uDemoTransformJpeg;

interface

uses
   Se7e.Drawing,
   Se7e.Drawing.Gdiplus.Types,
   uDemo;

type
  TDemoTransformJpeg = class(TDemo)
  strict protected
    procedure Run; override;
  public
    class function Outputs: TDemoOutputs; override;
  end;

implementation

uses
  SysUtils;

{ TDemoTransformJpeg }

class function TDemoTransformJpeg.Outputs: TDemoOutputs;
begin
  Result := [doGraphic, doText];
end;

{$REGION}
/// Quando você compacta uma imagem JPEG, algumas informações da imagem são
/// perdido. Se você abrir um arquivo JPEG, altere a imagem e salve-a em outro JPEG
/// arquivo, a qualidade diminuirá. Se você repetir esse processo muitas vezes, você
/// veremos uma degradação substancial na qualidade da imagem.
///
/// Porque JPEG é um dos formatos de imagem mais populares na Web, e
/// como as pessoas geralmente gostam de modificar imagens JPEG, o GDI+ fornece o seguinte
/// transformações que podem ser realizadas em imagens JPEG sem perda de
/// Informação:
///
/// -Gira 90 graus
/// -Gira 180 graus
/// -Gira 270 graus
///  -Virar horizontalmente
/// -Virar verticalmente
///
/// Você pode aplicar uma das transformações mostradas na lista anterior quando
/// você chama o método <A>Save</A> de um objeto <A>TGdipImage</A>. Se o seguinte
/// as condições são atendidas, então a transformação prosseguirá sem perda de
/// Informação:
///
/// -O arquivo usado para construir o objeto <A>TGdipImage</A> é um arquivo JPEG.
/// -A largura e a altura da imagem são múltiplos de 16.
///
/// Se a largura e a altura da imagem não forem múltiplos de 16, o GDI+ irá
/// faça o possível para preservar a qualidade da imagem ao aplicar uma das rotações
/// ou invertendo as transformações mostradas na lista anterior.
///
/// Para transformar uma imagem JPEG, inicialize um objeto <A>TGdipEncoderParameters</A>
/// e passe esse objeto para o método <A>Save</A> do <A>TGdipImage</A>
///interface. Adicione um único parâmetro ao <A>TGdipEncoderParameters</A> do tipo
/// EncoderTransformation e com um valor que contém um dos seguintes
/// elementos da enumeração <A>TEncoderValue</A>:
///
/// -EncoderValueTransformRotate90,
/// -EncoderValueTransformRotate180,
/// -EncoderValueTransformRotate270,
/// -EncoderValueTransformFlipHorizontal,
/// -EncoderValueTransformFlipVertical
///
/// O exemplo a seguir cria um objeto <A>TGdipImage</A> a partir de um arquivo JPEG e
/// então salva a imagem em um novo arquivo. Durante o processo de salvamento, a imagem é
/// girado 90 graus. Se a largura e a altura da imagem forem múltiplas
/// de 16, o processo de girar e salvar a imagem não causa perda de
/// Informação.

procedure TDemoTransformJpeg.Run;
var
  Image: TGdipImage;
  Width, Height: Integer;
  Params: TGdipEncoderParameters;
begin
  Image := TGdipImage.FromFile('..\..\imagens\ImageFile.jpg');
  Graphics.DrawImage(Image, 0, 0, Image.Width div 2, Image.Height div 2);
  Width := Image.Width;
  Height := Image.Height;

  TextOutput.Add(Format('A largura da imagem é %d,', [Width]));
  if ((Width mod 16) = 0) then
    TextOutput.Add('que é um múltiplo de 16.')
  else
    TextOutput.Add('que não é um múltiplo de 16.');

  TextOutput.Add(Format('A altura da imagem é %d,', [Height]));
  if ((Height mod 16) = 0) then
    TextOutput.Add('que é um múltiplo de 16.')
  else
    TextOutput.Add('que não é um múltiplo de 16.');

  Params := TGdipEncoderParameters.Create;
  Params.Add(TGdipEncoder.Transformation.Guid, TGdipEncoderValue.TransformRotate90);
  Image.Save('ImageFileR90.jpg', TGdipImageFormat.Jpeg, Params);
  Params.Free();
  Image.Free();

  // Recarregar imagem girada
  Image := TGdipImage.FromFile('ImageFileR90.jpg');
  Graphics.DrawImage(Image, 330, 0, Image.Width div 2, Image.Height div 2);
  Image.Free();
end;
{$ENDREGION}

initialization
  RegisterDemo('Usando codificadores e decodificadores de imagens\Transformando uma imagem JPEG sem perda de informações', TDemoTransformJpeg);

end.
