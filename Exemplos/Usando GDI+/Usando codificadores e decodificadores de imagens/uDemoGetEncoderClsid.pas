unit uDemoGetEncoderClsid;

interface

uses
   Se7e.Drawing,
   Se7e.Drawing.Gdiplus.Types,
   uDemo;

type
  TDemoGetEncoderClsid = class(TDemo)
  strict private
    function GetEncoderClsid(const MimeType: String; out ClsId: TGUID): Integer;
    procedure GetPngClsId;
    procedure GetJpegClsId;
  strict protected
    procedure Run; override;
  public
    class function Outputs: TDemoOutputs; override;
  end;

implementation

uses
  SysUtils;

{ TDemoGetEncoderClsid }

{$REGION}
/// A função GetEncoderClsid no exemplo a seguir recebe o tipo MIME
/// de um codificador e retorna o identificador de classe (CLSID) desse codificador. O
/// Os tipos MIME dos codificadores integrados ao Microsoft Windows GDI+ são os seguintes:
///
/// -imagem/bmp
/// -imagem/jpeg
/// -imagem/gif
/// -imagem/tiff
/// -imagem/png
///
/// A função chama <A>TGdipImageCodecInfo.GetImageEncoders</A> para obter um array
/// de objetos <A>TGdipImageCodecInfo</A>. Se um dos <A>TGdipImageCodecInfo</A>
/// objetos nesse array representam o codificador solicitado, a função retorna
/// o índice do objeto <A>TGdipImageCodecInfo</A> e copia o CLSID no
/// Parâmetro ClsId. Se a função falhar, ela retornará –1.

function TDemoGetEncoderClsid.GetEncoderClsid(const MimeType: String; out ClsId: TGUID): Integer;
var
  Encoders: TArray<TGdipImageCodecInfo>;
begin
  Encoders := TGdipImageCodecInfo.GetImageEncoders;
  for Result := 0 to Length(Encoders) - 1 do
    if SameText(Encoders[Result].MimeType, MimeType) then
    begin
      ClsId := Encoders[Result].ClsId;
      Exit;
    end;
  Result := -1;
end;

/// O exemplo a seguir chama a função GetEncoderClsid para determinar o
/// CLSID do codificador PNG:

procedure TDemoGetEncoderClsid.GetPngClsId;
var
  Index: Integer;
  ClsId: TGUID;
begin
  Index := GetEncoderClsid('image/png', ClsId);
  if (Index < 0) then
    TextOutput.Add('O codificador PNG não está instalado.')
  else
  begin
    TextOutput.Add('Um objeto TGdipImageCodecInfo que representa o codificador PNG');
    TextOutput.Add(Format('foi encontrado na posição %d na matriz.', [Index]));
    TextOutput.Add(Format('O CLSID do codificador PNG é %s.', [GUIDToString(ClsId)]));
  end;
end;

/// Quando você precisar de informações sobre um dos codificadores ou decodificadores integrados,
/// existe uma maneira mais fácil que não requer uma função como GetEncoderClsId.
/// A classe <A>TGdipImageFormat</A> possui algumas propriedades de classe chamadas <A>Bmp</A>,
/// <A>Jpeg</A>, <A>Gif</A>, <A>Tiff</A> e <A>Png</A> que retornam um
/// Objeto <A>IImageFormat</A> que contém uma propriedade CodecId.

procedure TDemoGetEncoderClsid.GetJpegClsId;
begin
  TextOutput.Add(Format('O CLSID do codificador JPEG é %s.',
    [GUIDToString(TGdipImageFormat.Jpeg.Guid)]));
end;
{$ENDREGION}

class function TDemoGetEncoderClsid.Outputs: TDemoOutputs;
begin
  Result := [doText];
end;

procedure TDemoGetEncoderClsid.Run;
var
  ClsId: TGUID;
begin
  GetEncoderClsid('image/bmp', ClsId);
  GetPngClsid;
  TextOutput.Add('');
  GetJpegClsId;
end;

initialization
  RegisterDemo('Usando codificadores e decodificadores de imagens\Recuperando o identificador de classe para um codificador', TDemoGetEncoderClsid);

end.
