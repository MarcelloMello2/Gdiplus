unit uDemoLoadDisplayMetafile;

interface

uses
   Se7e.Drawing,
   Se7e.Drawing.Gdiplus.Types,
   uDemo;

type
  TDemoLoadDisplayMetafile = class(TDemo)
  strict protected
    procedure Run; override;
  end;

implementation

{$REGION}
/// A interface <A>TGdipImage</A> fornece métodos básicos para carregar e
/// exibindo imagens raster e imagens vetoriais. A interface <A>TGdipMetafile</A>,
/// que herda da classe <A>TGdipImage</A>, fornece informações mais especializadas
/// métodos para gravar, exibir e examinar imagens vetoriais.
///
/// Para exibir uma imagem vetorial (metarquivo) na tela, você precisa de um
/// Objeto <A>TGdipImage</A> e um objeto <A>TGdipGraphics</A>. Passe o nome de um arquivo
/// (ou um ponteiro para um fluxo) para um construtor <A>TGdipImage</A>. Depois que você tiver
/// criou um objeto <A>TGdipImage</A>, passe esse objeto <A>TGdipImage</A> para o
/// Método <A>DrawImage</A> de um objeto <A>TGdipGraphics</A>.
///
/// O exemplo a seguir cria um objeto <A>TGdipImage</A> a partir de um EMF (aprimorado
/// metafile) e desenha a imagem com seu canto superior esquerdo em
/// (60, 10):

procedure TDemoLoadDisplayMetafile.Run;
var
  Image: TGdipImage;
begin
  Image := TGdipImage.FromFile('..\..\imagens\SampleMetafile.emf');
  Graphics.DrawImage(Image, 60, 10);
  Image.Free();
end;
{$ENDREGION}

initialization
  RegisterDemo('Usando imagens, bitmaps e metarquivos\Carregando e exibindo metarquivos', TDemoLoadDisplayMetafile);

end.
