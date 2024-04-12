unit uDemoColorMatrixTransform;

interface

uses
   Types,
   Se7e.Drawing,
   Se7e.Drawing.Gdiplus.Types,
   uDemo;

type
  TDemoColorMatrixTransform = class(TDemo)
  strict protected
    procedure Run; override;
  end;

implementation

{ TDemoColorMatrixTransform }

{$REGION}
/// Recolorir é o processo de ajuste das cores da imagem. Alguns exemplos de
/// recolorir é mudar uma cor para outra, ajustando a intensidade de uma cor
/// em relação a outra cor, ajustando o brilho ou contraste de todas
/// cores e conversão de cores em tons de cinza.
///
/// Microsoft Windows GDI+ fornece <A>TGdipImage</A> e <A>TGdipBitmap</A>
/// interface para armazenamento e manipulação de imagens. <A>TGdipImage</A> e
/// Os objetos <A>TGdipBitmap</A> armazenam a cor de cada pixel como um número de 32 bits:
/// 8 bits cada para vermelho, verde, azul e alfa. Cada um dos quatro componentes é
/// um número de 0 a 255, com 0 representando nenhuma intensidade e 255
///representando intensidade total. O componente alfa especifica a transparência
/// da cor: 0 é totalmente transparente e 255 é totalmente opaco.
///
/// Um vetor de cores é uma tupla de 4 na forma (vermelho, verde, azul, alfa). Para
/// exemplo, o vetor de cores (0, 255, 0, 255) representa uma cor opaca que
/// não tem vermelho nem azul, mas tem verde em intensidade total.
///
/// Outra convenção para representar cores usa o número 1 para máximo
/// intensidade e o número 0 para intensidade mínima. Usando essa convenção, o
/// a cor descrita no parágrafo anterior seria representada pelo
/// vetor (0, 1, 0, 1). GDI+ usa a convenção de 1 como intensidade total quando
/// realiza transformações de cores.
///
/// Você pode aplicar transformações lineares (rotação, escala e similares) a
/// vetores coloridos multiplicando por uma matriz 4×4. No entanto, você não pode usar um 4×4
/// matriz para realizar uma tradução (não linear). Se você adicionar um quinto fictício
/// coordenada (por exemplo, o número 1) para cada um dos vetores de cores, você pode
/// usa uma matriz 5×5 para aplicar qualquer combinação de transformações lineares e
/// traduções. Uma transformação que consiste em uma transformação linear
/// seguido por uma tradução é chamado de transformação afim. Uma matriz 5×5
/// que representa uma transformação afim é chamada de matriz homogênea para
/// uma transformação de 4 espaços. O elemento na quinta linha e na quinta coluna de um
/// Matriz homogênea 5×5 deve ser 1, e todas as outras entradas na quinta
/// coluna deve ser 0.
///
/// Por exemplo, suponha que você queira começar com a cor (0,2, 0,0, 0,4, 1,0)
/// e aplique as seguintes transformações:
///
/// -Duplique o componente vermelho
/// -Adicione 0,2 aos componentes vermelho, verde e azul
///
/// A seguinte multiplicação de matrizes realizará o par de transformações
/// na ordem listada.
///
/// | 2,0 0,0 0,0 0,0 0,0 |
/// | 0,0 1,0 0,0 0,0 0,0 |
/// | 0,0 0,0 1,0 0,0 0,0 |
/// | 0,0 0,0 0,0 1,0 0,0 |
/// | 0,2 0,2 0,2 0,0 1,0 |
///
/// Os elementos de uma matriz de cores são indexados (com base em zero) por linha e depois
/// coluna. Por exemplo, a entrada na quinta linha e terceira coluna da matriz
/// M é denotado por M[4,2].
///
/// A matriz identidade 5×5 tem 1s na diagonal e 0s em todos os outros lugares. Se
/// você multiplica um vetor de cores pela matriz identidade, o vetor de cores faz
/// não mudar. Uma maneira conveniente de formar a matriz de uma transformação de cores é
/// para começar com a matriz identidade e fazer uma pequena mudança que produza o
/// transformação desejada.
///
/// Para uma discussão mais detalhada sobre matrizes e transformações, consulte o
/// tópico <A>Sistemas de Coordenadas e Transformações</A> no Platform SDK.
///
/// O exemplo a seguir pega uma imagem que é toda de uma cor
/// (0,2, 0,0, 0,4, 1,0) e aplica a transformação descrita no
/// parágrafos anteriores.

procedure TDemoColorMatrixTransform.Run;
var
  ColorMatrix: TGdipColorMatrix;
  Bitmap: TGdipBitmap;
  BitmapGraphics: TGdipGraphics;
  ImageAttributes: TGdipImageAttributes;
begin
   ColorMatrix := TGdipColorMatrix.Create
   (
      [
         [2.0, 0.0, 0.0, 0.0, 0.0],
         [0.0, 1.0, 0.0, 0.0, 0.0],
         [0.0, 0.0, 1.0, 0.0, 0.0],
         [0.0, 0.0, 0.0, 1.0, 0.0],
         [0.2, 0.2, 0.2, 0.0, 1.0]
      ]
   );

  Bitmap := TGdipBitmap.Create(100, 100);
  BitmapGraphics := TGdipGraphics.FromImage(Bitmap);
  BitmapGraphics.Clear(TGdipColor.FromArgb(255, 51, 0, 102));

  ImageAttributes := TGdipImageAttributes.Create;
  ImageAttributes.SetColorMatrix(ColorMatrix, TGdipColorMatrixFlag.Default, TGdipColorAdjustType.Bitmap);

  Graphics.DrawImage(Bitmap, 10, 10);
  Graphics.DrawImage(Bitmap,
    TRectangle.Create(120, 10, 100, 100), // retângulo de destino
    0, 0, 100, 100,    // retângulo de origem
    TGdipGraphicsUnit.Pixel, ImageAttributes);

  ImageAttributes.Free();
  BitmapGraphics.Free();
  Bitmap.Free();
  ColorMatrix.Free();
end;

/// A ilustração acima mostra a imagem original à esquerda e o
/// imagem transformada à direita.
///
/// O código no exemplo anterior usa as etapas a seguir para executar o
/// recolorir:
/// 1. Inicialize um registro <A>TGdipColorMatrix</A>.
/// 2. Crie um objeto <A>TGdipImageAttributes</A> e passe o <A>TGdipColorMatrix</A>
/// grava no método <A>SetColorMatrix</A> do <A>TGdipImageAttributes</A>
/// objeto.
/// 3. Passe o objeto <A>TGdipImageAttributes</A> para <A>TGdipGraphics.DrawImage</A>
/// método de um objeto <A>TGdipGraphics</A>.
{$ENDREGION}

initialization
  RegisterDemo('Recolorir\Usando uma matriz de cores para transformar uma única cor', TDemoColorMatrixTransform);

end.
