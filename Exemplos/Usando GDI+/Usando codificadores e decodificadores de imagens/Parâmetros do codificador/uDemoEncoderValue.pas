// Marcelo Melo
// 12/04/2024
//
// https://learn.microsoft.com/pt-br/windows/win32/gdiplus/-gdiplus-using-the-encodervalue-enumeration-use

unit uDemoEncoderValue;

interface

uses
   Se7e.Drawing,
   Se7e.Windows.Win32.Graphics.GdiplusAPI,
   Se7e.Drawing.Gdiplus.Types,
   uDemo;

type
  TDemoEncoderValue = class(TDemo)
  strict private
    function GetJpegParameters: TGdipEncoderParameters;
    procedure ShowTransformationParameter(const Params: TGdipEncoderParameters);
  strict protected
    procedure Run; override;
  public
    class function Outputs: TDemoOutputs; override;
  end;

implementation

uses
  SysUtils;

{ TDemoEncoderValue }

{$REGION}
/// Um determinado codificador suporta certas categorias de parâmetros e para cada uma delas
/// categorias, esse codificador permite determinados valores. Por exemplo, o JPEG
/// o codificador suporta a categoria do parâmetro EncoderValueQuality e o
/// os valores permitidos dos parâmetros são números inteiros de 0 a 100. Alguns dos
/// os valores de parâmetros permitidos são os mesmos em vários codificadores. Esses
/// os valores padrão são definidos na enumeração <A>TEncoderValue</A>:
///
///  <C>type</C>
///  <C>  TEncoderValue = (</C>
///  <C>    EncoderValueColorTypeCMYK,            // 0</C>
///  <C>    EncoderValueColorTypeYCCK,            // 1</C>
///  <C>    EncoderValueCompressionLZW,           // 2</C>
///  <C>    EncoderValueCompressionCCITT3,        // 3</C>
///  <C>    EncoderValueCompressionCCITT4,        // 4</C>
///  <C>    EncoderValueCompressionRle,           // 5</C>
///  <C>    EncoderValueCompressionNone,          // 6</C>
///  <C>    EncoderValueScanMethodInterlaced,     // 7</C>
///  <C>    EncoderValueScanMethodNonInterlaced,  // 8</C>
///  <C>    EncoderValueVersionGif87,             // 9</C>
///  <C>    EncoderValueVersionGif89,             // 10</C>
///  <C>    EncoderValueRenderProgressive,        // 11</C>
///  <C>    EncoderValueRenderNonProgressive,     // 12</C>
///  <C>    EncoderValueTransformRotate90,        // 13</C>
///  <C>    EncoderValueTransformRotate180,       // 14</C>
///  <C>    EncoderValueTransformRotate270,       // 15</C>
///  <C>    EncoderValueTransformFlipHorizontal,  // 16</C>
///  <C>    EncoderValueTransformFlipVertical,    // 17</C>
///  <C>    EncoderValueMultiFrame,               // 18</C>
///  <C>    EncoderValueLastFrame,                // 19</C>
///  <C>    EncoderValueFlush,                    // 20</C>
///  <C>    EncoderValueFrameDimensionTime,       // 21</C>
///  <C>    EncoderValueFrameDimensionResolution, // 22</C>
///  <C>    EncoderValueFrameDimensionPage);      // 23</C>
///
/// Uma das categorias de parâmetros suportadas pelo codificador JPEG é a
/// Categoria EncoderTransformation. Examinando o <A>TEncoderValue</A>
/// enumeração, você pode especular (e você estaria correto) que o
/// A categoria EncoderTransformation permite os cinco valores a seguir:
///
///  <C>EncoderValueTransformRotate90,        // 13</C>
///  <C>EncoderValueTransformRotate180,       // 14</C>
///  <C>EncoderValueTransformRotate270,       // 15</C>
///  <C>EncoderValueTransformFlipHorizontal,  // 16</C>
///  <C>EncoderValueTransformFlipVertical,    // 17</C>
///
/// O exemplo a seguir verifica se o codificador JPEG suporta o
/// Categoria do parâmetro EncoderTransformation e que há cinco permitidos
/// valores para tal parâmetro.

function TDemoEncoderValue.GetJpegParameters: TGdipEncoderParameters;
var
  Bitmap: TGdipBitmap;
  Param: TGdiplusAPI.TGdipNativeEncoderParameterPtr;
begin
  // Cria a interface TGdipBitmap (herdada de TGdipImage) para que possamos chamar
  //GetEncoderParameterList.
  Bitmap := TGdipBitmap.Create(1, 1);

  // Obtenha a lista de parâmetros do codificador JPEG.
  Result := Bitmap.GetEncoderParameterList(TGdipImageFormat.Jpeg.CodecId);

  TextOutput.Add(Format('Existem %d registros TEncoderParameter na matriz.',
    [Result.Count]));
  Param := Result[0];
  TextOutput.Add('Parameter[0]');
  TextOutput.Add(Format('  O GUID é %s.', [GUIDToString(Param.Guid)]));
  TextOutput.Add(Format('  O tipo de valor é %d.', [Ord(Param.ValueType)]));
  TextOutput.Add(Format('  O número de valores é %d.', [Param.NumberOfValues]));

  Bitmap.Free();
end;

/// O código anterior deve gerar o seguinte:
///
/// Existem 4 registros TEncoderParameter no array.
/// Parâmetro[0]
/// O GUID é {8D0EB2D1-A58E-4EA8-AA14-108074B7B6F9}.
/// O tipo de valor é 4.
/// O número de valores é 5.
///
/// Você pode procurar o GUID em GdiPlus.pas e descobrir que a categoria de
/// este registro <A>TEncoderParameter</A> é EncoderTransformation. O
/// A enumeração <A>TGdipEncoderParameterValueType</A> indica que o tipo de dados 4 é
/// EncoderParameterValueTypeLong (inteiro não assinado de 32 bits). O número de
/// valores são cinco, então sabemos que o membro Value do
/// O registro <A>TEncoderParameter</A> é um ponteiro para um array de cinco LongWord
/// valores.
///
/// O código a seguir é uma continuação do exemplo anterior. O código
/// lista os valores permitidos para um parâmetro <A>TEncoderTransformation</A>:

procedure TDemoEncoderValue.ShowTransformationParameter(
  const Params: TGdipEncoderParameters);
var
  Param: TGdiplusAPI.TGdipNativeEncoderParameterPtr;
  {$POINTERMATH ON} //Permitir acesso a Valores como um array
  Values: PLongWord;
  J, NumValues: Integer;
  S: String;
begin
  Assert(Params.Count > 0);
  Param := Params[0];
  Values := Param.Value;
  NumValues := Param.NumberOfValues;
  S := '  Os valores permitidos são';
  for J := 0 to NumValues - 1 do
    S := S + '  ' + IntToStr(Values[J]);
  TextOutput.Add(S);
end;

/// O código anterior produz a seguinte saída:
///
/// Os valores permitidos são 13 14 15 16 17
///
/// Os valores permitidos (13, 14, 15, 16 e 17) correspondem ao seguinte
/// membros da enumeração <A>TEncoderValue</A>:
///
///  <C>EncoderValueTransformRotate90,        // 13</C>
///  <C>EncoderValueTransformRotate180,       // 14</C>
///  <C>EncoderValueTransformRotate270,       // 15</C>
///  <C>EncoderValueTransformFlipHorizontal,  // 16</C>
///  <C>EncoderValueTransformFlipVertical,    // 17</C>
{$ENDREGION}

class function TDemoEncoderValue.Outputs: TDemoOutputs;
begin
  Result := [doText];
end;

procedure TDemoEncoderValue.Run;
var
  Params: TGdipEncoderParameters;
begin
  Params := GetJpegParameters;
  TextOutput.Add('');
  ShowTransformationParameter(Params);
  Params.Free();
end;

initialization
  RegisterDemo('Usando codificadores e decodificadores de imagens\Parâmetros do codificador\Usando a enumeração TEncoderValue', TDemoEncoderValue);

end.
