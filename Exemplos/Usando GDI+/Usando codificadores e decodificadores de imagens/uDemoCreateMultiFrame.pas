unit uDemoCreateMultiFrame;

interface

uses
   Se7e.Drawing,
   Se7e.Drawing.Gdiplus.Types,
   uDemo;

type
  TDemoCreateMultiFrame = class(TDemo)
  strict protected
    procedure Run; override;
  public
    class function Outputs: TDemoOutputs; override;
  end;

implementation

{ TDemoCreateMultiFrame }

class function TDemoCreateMultiFrame.Outputs: TDemoOutputs;
begin
  Result := [doGraphic, doText];
end;

{$REGION}
/// Com certos formatos de arquivo, você pode salvar múltiplas imagens (quadros) em um único
/// arquivo. Por exemplo, você pode salvar diversas páginas em um único arquivo TIFF. Salvar
/// na primeira página, chame o método <A>Save</A> da interface <A>TGdipImage<A>.
/// Para salvar páginas subsequentes, chame o método <A>SaveAdd</A> do
/// Interface <A>TGdipImage</A>.
///
/// O exemplo a seguir cria um arquivo TIFF com quatro páginas. As imagens que
/// tornam as páginas do arquivo TIFF provenientes de quatro arquivos de disco. O código primeiro
/// constrói quatro objetos <A>TGdipImage</A>: Multi, Page2, Page3 e Page4. No
/// primeiro, Multi contém apenas a imagem de Shapes.bmp, mas eventualmente
/// contém todas as quatro imagens. À medida que as páginas individuais são adicionadas ao multi
/// objeto <A>TGdipImage</A>, eles também são adicionados ao arquivo de disco MultiFrame.tif.
///
/// Observe que o código chama <A>Save</A> (não <A>SaveAdd</A>) para salvar o primeiro
/// página. O primeiro argumento passado para o método <A>Save</A> é o nome do
/// arquivo em disco que eventualmente conterá vários quadros. O segundo argumento
/// passado para o método <A>Save</A> especifica o codificador que será usado para
/// converte os dados no objeto multi <A>TGdipImage</A> para o formato (neste
/// case TIFF) exigido pelo arquivo do disco. Esse mesmo codificador é usado
/// automaticamente por todas as chamadas subseqüentes ao método <A>SaveAdd</A> do
/// objeto múltiplo <A>TGdipImage<A>.
///
/// O terceiro argumento passado para o método <A>Save</A> é um
/// objeto <A>TGdipEncoderParameters</A>. O objeto <A>TGdipEncoderParameters<A> tem
/// um único parâmetro do tipo EncoderSaveFlag. O valor do parâmetro
/// é EncoderValueMultiFrame.
///
/// O código salva a segunda, terceira e quarta páginas chamando o método
/// Método <A>SaveAdd</A> do objeto multi <A>TGdipImage<A>. O primeiro argumento
/// passado para o método <A>SaveAdd<A/> é um objeto <A>TGdipImage</A>. A imagem em
/// esse objeto <A>TGdipImage</A> é adicionado ao objeto multi <A>TGdipImage</A> e é
/// também adicionado ao arquivo de disco MultiFrame.tif. O segundo argumento passado para
/// o método <A>SaveAdd</A> é o mesmo objeto <A>TGdipEncoderParameters</A> que
/// foi usado pelo método <A>Save</A>. A diferença é que o valor do
/// parâmetro agora é EncoderValueFrameDimensionPage.

procedure TDemoCreateMultiFrame.Run;
var
  Params: TGdipEncoderParameters;
  Multi, Page2, Page3, Page4: TGdipImage;
  X, I, PageCount: Integer;
begin
  Params := TGdipEncoderParameters.Create();
  Multi := TGdipImage.FromFile('..\..\imagens\Shapes.bmp');
  Page2 := TGdipImage.FromFile('..\..\imagens\Cereal.gif');
  Page3 := TGdipImage.FromFile('..\..\imagens\Iron.jpg');
  Page4 := TGdipImage.FromFile('..\..\imagens\House.png');

  // Salve a primeira página (quadro).
  Params.Add(TGdipEncoder.SaveFlag.Guid, TGdipEncoderValue.MultiFrame);
  Multi.Save('MultiFrame.tif', TGdipImageFormat.Tiff, Params);
  TextOutput.Add('Página 1 salva com sucesso');

  // Salve a segunda página (quadro).
  Params.Clear();
  Params.Add(TGdipEncoder.SaveFlag.Guid, TGdipEncoderValue.FrameDimensionPage);
  Multi.SaveAdd(Page2, Params);
  TextOutput.Add('Página 2 salva com sucesso');

  // Salve a terceira página (quadro).
  Multi.SaveAdd(Page3, Params);
  TextOutput.Add('Página 3 salva com sucesso');

  // Salve a quarta página (quadro).
  Multi.SaveAdd(Page4, Params);
  TextOutput.Add('Página 4 salva com sucesso');

  // Feche o arquivo multiframe.
  Params.Clear();
  Params.Add(TGdipEncoder.SaveFlag.Guid, TGdipEncoderValue.Flush);
  Multi.SaveAdd(Params);
  TextOutput.Add('Arquivo fechado com sucesso');
  Multi.Free();

  // Recarregue o arquivo TIFF
  Multi := TGdipImage.FromFile('MultiFrame.tif');
  PageCount := Multi.GetFrameCount(TGdipFrameDimension.Page);
  X := 0;
  for I := 0 to PageCount - 1 do
  begin
    Multi.SelectActiveFrame(TGdipFrameDimension.Page, I);
    Graphics.DrawImage(Multi, X, 0, Multi.Width, Multi.Height);
    Inc(X, Multi.Width + 10);
  end;

  Page4.Free();
  Page3.Free();
  Page2.Free();
  Multi.Free();
  Params.Free();
end;

/// A última seção do código recupera os quadros individuais de um
/// arquivo TIFF de vários quadros. Quando o arquivo TIFF foi criado, o indivíduo
/// frames foram adicionados à dimensão Page. O código exibe cada um dos quatro
/// Páginas.
///
/// O código constrói um objeto <A>TGdipImage</A> a partir do TIFF de vários quadros
/// arquivo. Para recuperar os quadros individuais (páginas), o código chama o método
/// Método <A>SelectActiveFrame</A> desse objeto </A>TGdipImage</A>. O primeiro
/// argumento passado para o método <A>SelectActiveFrame</A> é um GUID que
/// especifica a dimensão na qual os quadros foram adicionados anteriormente ao
/// arquivo TIFF de vários quadros. O GUID FrameDimensionPage é usado aqui. Outro
/// GUIDs que você pode usar são FrameDimensionTime e FrameDimensionResolution. O
/// segundo argumento passado para o método <A>SelectActiveFrame</A> é o
/// índice baseado em zero da página desejada.
{$ENDREGION}

initialization
  RegisterDemo('Usando codificadores e decodificadores de imagens\Criando e salvando uma imagem de vários quadros', TDemoCreateMultiFrame);

end.
