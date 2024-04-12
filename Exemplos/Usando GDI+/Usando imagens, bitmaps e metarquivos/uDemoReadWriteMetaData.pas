unit uDemoReadWriteMetaData;

interface

uses
   Se7e.Drawing,
   Se7e.Drawing.Gdiplus.Types,
   uDemo;

type
  TDemoReadWriteMetaData = class(TDemo)
  strict private
    procedure ReadMetaDataCount;
    procedure ReadMetaData;
    procedure WriteMetaData;
  strict protected
    procedure Run; override;
  public
    class function Outputs: TDemoOutputs; override;
  end;

implementation

uses
  SysUtils;

{ TDemoReadWriteMetaData }

class function TDemoReadWriteMetaData.Outputs: TDemoOutputs;
begin
  Result := [doText];
end;

{$REGION}
/// Alguns arquivos de imagem contêm metadados que você pode ler para determinar recursos de
/// a imagem. Por exemplo, uma fotografia digital pode conter metadados que você
/// pode ler para determinar a marca e o modelo da câmera usada para capturar o
/// imagem. Com o Microsoft Windows GDI+, você pode ler metadados existentes e
/// também pode gravar novos metadados em arquivos de imagem.
///
/// GDI+ fornece uma maneira uniforme de armazenar e recuperar metadados de imagens
/// arquivos em vários formatos. No GDI+, um pedaço de metadados é chamado de propriedade
/// item. Você pode armazenar e recuperar metadados chamando o método
/// Métodos <A>SetPropertyItem</A> e <A>GetPropertyItem</A> de
/// a interface <A>TGdipImage</A>, e você não precisa se preocupar com o
/// detalhes de como um formato de arquivo específico armazena esses metadados.
///
/// GDI+ atualmente oferece suporte a metadados para arquivos TIFF, JPEG, Exif e PNG
/// formatos. O formato Exif, que especifica como armazenar imagens capturadas por
/// câmeras fotográficas digitais, são construídas sobre os formatos TIFF e JPEG. Exif
/// usa o formato TIFF para dados de pixel não compactados e o formato JPEG para
/// dados de pixel compactados.
///
/// GDI+ define um conjunto de tags de propriedade que identificam itens de propriedade. Certo
/// tags são de uso geral; isto é, eles são suportados por todos os arquivos
/// formatos mencionados no parágrafo anterior. Outras tags são para fins especiais
/// e aplicam-se apenas a determinados formatos. Se você tentar salvar um item de propriedade em um
/// arquivo que não oferece suporte a esse item de propriedade, o GDI+ ignora a solicitação.
/// Mais especificamente, o método <A>TGdipImage.SetPropertyItem</A> gera um
/// Exceção PropertyNotSupported.
///
/// Você pode determinar os itens de propriedade que são armazenados em um arquivo de imagem
/// acessando a propriedade <A>TGdipImage.PropertyIdList</A>. Se você tentar recuperar
/// um item de propriedade que não está no arquivo, o GDI+ ignora a solicitação. Mais
/// especificamente, o método <A>TGdipImage.GetPropertyItem</A> gera um
/// Exceção PropertyNotFound.
///
/// <H>Lendo metadados de um arquivo</H>
/// A rotina a seguir usa a propriedade <A>PropertyIdList</A> de um
/// Objeto <A>TGdipImage</A> para determinar quantas partes de metadados estão no
/// arquivo FakePhoto.jpg.

procedure TDemoReadWriteMetaData.ReadMetaDataCount;
var
  Bitmap: TGdipBitmap;
begin
  TextOutput.Add('TDemoReadWriteMetaData.ReadMetaDataCount');
  Bitmap := TGdipBitmap.Create('..\..\imagens\FakePhoto.jpg');
  TextOutput.Add(Format('Existem %d pedaços de metadados no arquivo.',
    [Bitmap.PropertyIdList.Count]));
  TextOutput.Add('');
  Bitmap.Free();
end;

/// O código anterior, junto com um arquivo específico, FakePhoto.jpg, produzido
/// a saída que você pode ver na área de saída acima.
///
/// GDI+ armazena uma parte individual de metadados em um <A>TGdipPropertyItem</A>
/// objeto. Você pode acessar a propriedade <A>PropertyItems</A> do <A>TGdipImage</A>
/// classe para recuperar todos os metadados de um arquivo. Os <A>PropertyItems</A>
/// propriedade retorna um array de objetos <A>TGdipPropertyItem</A>.
///
/// Um objeto <A>TGdipPropertyItem</A> possui os seguintes quatro membros públicos:
///
/// -Id: Uma tag que identifica o item de metadados. Exemplos de valores que podem
/// ser atribuído ao Id são PropertyTagImageTitle, PropertyTagEquipMake,
/// PropertyTagExifExposureTime e similares.
/// -Length: O comprimento, em bytes, do array de valores apontado pelo
/// Membro de dados de valor. Observe que se o membro de dados do tipo estiver definido como
/// PropertyTagTypeASCII, então o membro de dados de comprimento é o comprimento de um
/// string de caracteres terminada em nulo, incluindo o terminador NULL.
/// -ValueType: O tipo de dados dos valores no array apontado pelo
/// Membro de dados de valor. Alguns exemplos de tipos são PropertyTagTypeByte e
/// PropertyTagTypeASCII.
/// -Value: um ponteiro para uma matriz de valores.
///
/// O exemplo a seguir lê e exibe as partes dos metadados no arquivo
/// FakePhoto.jpg.

procedure TDemoReadWriteMetaData.ReadMetaData;
const
  PropertyTypes: array [1..10] of String = ('PropertyTagTypeByte',
    'PropertyTagTypeASCII', 'PropertyTagTypeShort', 'PropertyTagTypeLong',
    'PropertyTagTypeRational', '', 'PropertyTagTypeUndefined', '',
    'PropertyTagTypeSLONG', 'PropertyTagTypeSRational');
var
  Bitmap: TGdipBitmap;
  Props: TGdipPropertyItems;
  Prop: TGdipPropertyItem;
  I: Integer;
begin
  TextOutput.Add('TDemoReadWriteMetaData.ReadMetaData');
  Bitmap := TGdipBitmap.Create('..\..\imagens\FakePhoto.jpg');
  Props := Bitmap.PropertyItems;
  I := 0;
  for Prop in Props do
  begin
    TextOutput.Add(Format('Property Item %d',[I]));
    TextOutput.Add(Format('  Id: $%x',[Prop.Id]));
    if (Prop.ValueType >= Low(PropertyTypes)) and (Prop.ValueType <= High(PropertyTypes)) then
      TextOutput.Add(Format('  ValueType: %s',[PropertyTypes[Prop.ValueType]]))
    else
      TextOutput.Add(Format('  ValueType: %d',[Prop.ValueType]));
    if (Prop.ValueType = PropertyTagTypeASCII) then
      TextOutput.Add(Format('  Value: %s',[PAnsiChar(Prop.Value)]));
    TextOutput.Add(Format('  Length: %d',[Prop.Length]));
    TextOutput.Add('');
    Inc(I);
  end;

  Bitmap.Free();
end;

/// A saída do código anterior mostra um número de identificação hexadecimal para cada
/// item de propriedade. Você pode procurar esses números de identificação nas constantes PropertyTagXXX
/// na unidade GdiPlus e descubra que eles representam a seguinte propriedade
/// Tag.
/// -$0320: PropertyTagImageTitle
/// -$5090: PropertyTagLuminanceTable
/// -$5091: PropertyTagChrominanceTable
///
/// O primeiro item de propriedade (índice 0) na lista tem <B>Id</B>
/// PropertyTagImageType e <B>ValueType</B> PropertyTagTypeASCII.
/// O exemplo acima exibe o valor desse item de propriedade (a string
/// 'Fotografia Falsa').
///
/// <H>Escrever metadados em um arquivo</H>
/// Para escrever um item de metadados em um objeto <A>TGdipImage</A>, inicialize um
/// objeto <A>TGdipPropertyItem</A> e depois passa esse objeto <A>TGdipPropertyItem</A>
/// para o método <A>SetPropertyItem</A> do objeto <A>Image</A>.
///
/// O exemplo a seguir grava um item (o título da imagem) de metadados em um
/// objeto <A>TGdipImage</A> e então salva a imagem no arquivo do disco
///FakePhoto2.jpg.

procedure TDemoReadWriteMetaData.WriteMetaData;
var
  Bitmap: TGdipBitmap;
  Prop: TGdipPropertyItem;
  Title: AnsiString;
begin
  TextOutput.Add('TDemoReadWriteMetaData.WriteMetaData');
  Bitmap := TGdipBitmap.Create('..\..\imagens\FakePhoto.jpg');
  Title := 'Título modificado para fotografia falsa';
  Prop := Default(TGdipPropertyItem);
  Prop.Id := PropertyTagImageTitle;
  Prop.ValueType := PropertyTagTypeASCII;
  Prop.Length := Length(Title) + 1; // comprimento da string incluindo terminador NULL
  Prop.Value := PAnsiChar(Title);
  Bitmap.SetPropertyItem(Prop);
  Bitmap.Save('FakePhoto2.jpg', TGdipImageFormat.Jpeg);
  Bitmap.Free();

  // Ler metadados
  Bitmap := TGdipBitmap.Create('FakePhoto2.jpg');
  Prop := Bitmap.GetPropertyItem(PropertyTagImageTitle);
  if (Prop.ValueType = PropertyTagTypeASCII) then
    TextOutput.Add('Título: ' + PAnsiChar(Prop.Value));

  Bitmap.Free();
end;
{$ENDREGION}

procedure TDemoReadWriteMetaData.Run;
begin
  ReadMetaDataCount;
  ReadMetaData;
  WriteMetaData;
end;

initialization
  RegisterDemo('Usando imagens, bitmaps e metarquivos\Lendo e escrevendo metadados', TDemoReadWriteMetaData);

end.
