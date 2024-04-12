// Marcelo Melo
// 12/04/2024
//
// https://learn.microsoft.com/pt-br/windows/win32/gdiplus/-gdiplus-determining-the-parameters-supported-by-an-encoder-use

unit uDemoEncoderParameters;

interface

uses
   Se7e.Drawing,
   Se7e.Windows.Win32.Graphics.GdiplusAPI,
   Se7e.Drawing.Gdiplus.Types,
   uDemo;

type
  TDemoEncoderParameters = class(TDemo)
  strict private
    function GetJpegParameters: TGdipEncoderParameters;
    procedure ShowSecondJpegParameter(const Params: TGdipEncoderParameters);
    procedure ShowJpegQualityParameter(const Params: TGdipEncoderParameters);
  strict protected
    procedure Run; override;
  public
    class function Outputs: TDemoOutputs; override;
  end;

implementation

uses
  SysUtils;

{ TDemoEncoderParameters }

{$REGION}
/// A interface <A>TGdipImage</A> fornece o <A>GetEncoderParameterList</A>
/// método para que você possa determinar os parâmetros que são suportados por um
/// determinado codificador de imagem. O método <A>GetEncoderParameterList</A> retorna um
/// array de registros <A>TEncoderParameter</A>.
///
/// O exemplo a seguir obtém a lista de parâmetros para o codificador JPEG.
/// Utiliza a propriedade de classe TGdipImageFormat.Jpeg para obter o ClsId do
/// Codificador JPEG.

function TDemoEncoderParameters.GetJpegParameters: TGdipEncoderParameters;
var
  Bitmap: TGdipBitmap;
begin
  // Cria a interface TGdipBitmap (herdada de TGdipImage) para que possamos chamar
  //GetEncoderParameterList.
  Bitmap := TGdipBitmap.Create(1, 1);

  // Obtenha a lista de parâmetros do codificador JPEG.
  Result := Bitmap.GetEncoderParameterList(TGdipImageFormat.Jpeg.CodecId);

  TextOutput.Add(Format('Existem %d registros TEncoderParameter na matriz.',
    [Result.Count]));

  Bitmap.Free();
end;

/// Cada um dos registros <A>TEncoderParameter</A> no array tem o seguinte
/// quatro membros de dados públicos:
///
/// -Guid (TGUID): GUID do parâmetro
/// -NumberOfValues (LongWord): Número dos valores dos parâmetros
/// -ValueType (TGdipEncoderParameterValueType): Tipo de valor, como ValueTypeLONG etc.
/// -Value (Pointer): Um ponteiro para os valores dos parâmetros
///
/// O exemplo a seguir é uma continuação do exemplo anterior. O código
/// olha para o segundo registro <A>TEncoderParameter</A> no array retornado por
/// <A>GetEncoderParameterList</A>.

procedure TDemoEncoderParameters.ShowSecondJpegParameter(const Params: TGdipEncoderParameters);
var
  Param: TGdiplusAPI.TGdipNativeEncoderParameterPtr;
begin
  Assert(Params.Count >= 2);
  Param := Params[1];
  TextOutput.Add('Parameter[1]');
  TextOutput.Add(Format('  O GUID é %s.', [GUIDToString(Param.Guid)]));
  TextOutput.Add(Format('  O tipo de valor é %d.', [Ord(Param.ValueType)]));
  TextOutput.Add(Format('  O número de valores é %d.', [Param.NumberOfValues]));
end;

/// O código anterior deve gerar o seguinte:
///
/// Parâmetro[1]
/// O GUID é {1D5BE4B5-FA4A-452D-9CDD-5DB35105E7EB}.
/// O tipo de valor é 6.
/// O número de valores é 1.
///
/// Você pode procurar o GUID em GdiPlus.pas e descobrir que a categoria de
/// este registro <A>TEncoderParameter</A> é EncoderQuality. Você pode usar isso
/// categoria (EncoderQuality) do parâmetro para definir o nível de compactação de um
/// imagem JPEG.
///
/// A enumeração <A>TGdipEncoderParameterValueType</A> indica que o tipo de dados 6
/// é EncoderParameterValueTypeLongRange. Um longo alcance é um par de LongInt
/// valores.
///
/// O número de valores é um, então sabemos que o membro Value do
/// O registro <A>TEncoderParameter</A> é um ponteiro para um array que possui um
/// elemento. Esse elemento é um par de valores LongWord.
///
/// O exemplo a seguir é uma continuação dos dois exemplos anteriores. O
/// código define um tipo de dados chamado PLongRange (ponteiro para um longo intervalo). A
/// variável do tipo PLongRange é usada para extrair o mínimo e o máximo
/// valores que podem ser passados como configuração de qualidade para o codificador JPEG.

procedure TDemoEncoderParameters.ShowJpegQualityParameter(const Params: TGdipEncoderParameters);
type
  TLongRange = record
    Min: LongInt;
    Max: LongInt;
  end;
  PLongRange = ^TLongRange;
var
  Param: TGdiplusAPI.TGdipNativeEncoderParameterPtr;
  LongRange: PLongRange;
begin
  Assert(Params.Count >= 2);
  Param := Params[1];
  LongRange := Param.Value;
  TextOutput.Add(Format('  O valor mínimo de qualidade possível é %d.', [LongRange.Min]));
  TextOutput.Add(Format('  O valor de qualidade máximo possível é %d.', [LongRange.Max]));
end;

/// O código anterior deve produzir a seguinte saída:
///
/// O valor mínimo de qualidade possível é 0.
/// O valor máximo de qualidade possível é 100.
///
/// No exemplo anterior, o valor retornado em <A>TEncoderParameter</A>
/// registro é um par de valores LongInt que indicam o mínimo e o máximo
/// valores possíveis para o parâmetro de qualidade. Em alguns casos, os valores
/// retornados em um registro <A>TEncoderParameter</A> são membros do
/// enumeração <A>TEncoderValue</A>. Os exemplos a seguir discutem o
/// Enumeração <A>TEncoderValue</A> e métodos para listar possíveis parâmetros
/// valores com mais detalhes:
///
/// -<A>Usando a enumeração TEncoderValue</A>
/// -<A>Listando parâmetros e valores para todos os codificadores</A>
{$ENDREGION}

class function TDemoEncoderParameters.Outputs: TDemoOutputs;
begin
  Result := [doText];
end;

procedure TDemoEncoderParameters.Run;
var
  Params: TGdipEncoderParameters;
begin
  Params := GetJpegParameters();
  TextOutput.Add('');
  ShowSecondJpegParameter(Params);
  TextOutput.Add('');
  ShowJpegQualityParameter(Params);

  Params.Free();
end;

initialization
  RegisterDemo('Usando codificadores e decodificadores de imagens\Parâmetros do codificador\Determinando os parâmetros suportados por um codificador', TDemoEncoderParameters);

end.
