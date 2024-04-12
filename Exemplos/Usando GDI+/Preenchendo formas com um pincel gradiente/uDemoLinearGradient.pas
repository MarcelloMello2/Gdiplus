unit uDemoLinearGradient;

interface

uses
   Se7e.Drawing,
   Se7e.Drawing.Gdiplus.Types,
   uDemo;

type
  TDemoLinearGradient = class(TDemo)
  strict private
    procedure HorizontalGradient;
    procedure CustomGradient;
    procedure DiagonalGradient;
  strict protected
    procedure Run; override;
  end;

implementation

{ TDemoLinearGradient }

{$REGION}
/// Você pode usar um pincel de gradiente para preencher uma forma com uma mudança gradual
/// cor. Por exemplo, você pode usar um gradiente horizontal para preencher uma forma com
/// cor que muda gradualmente conforme você se move da borda esquerda da forma para
/// a borda direita. Imagine um retângulo com borda esquerda preta
/// (representado pelos componentes vermelho, verde e azul 0, 0, 0) e uma borda direita
/// que é vermelho (representado por 255, 0, 0). Se o retângulo tiver 256 pixels de largura,
/// o componente vermelho de um determinado pixel será maior que o vermelho
/// componente do pixel à sua esquerda. O pixel mais à esquerda em uma linha tem cor
/// componentes (0, 0, 0), o segundo pixel possui (1, 0, 0), o terceiro pixel possui
/// (2, 0, 0) e assim por diante, até chegar ao pixel mais à direita, que tem cor
/// componentes (255, 0, 0). Esses valores de cores interpolados constituem a cor
/// gradiente.
///
/// Um gradiente linear muda de cor conforme você se move horizontalmente, verticalmente ou
/// paralelo a uma linha inclinada especificada. Um gradiente de caminho muda de cor conforme você
/// move-se pelo interior e limite de um caminho. Você pode personalizar o caminho
/// gradientes para obter uma ampla variedade de efeitos.
///
/// GDI+ fornece <A>TGdipLinearGradientBrush</A> e <A>TGdipPathGradientBrush</A>
/// interfaces, ambas herdadas da interface <A>TGdipBrush</A>.
///
/// GDI+ fornece gradientes lineares horizontais, verticais e diagonais. Por
/// padrão, a cor em um gradiente linear muda uniformemente. No entanto, você pode
/// personaliza um gradiente linear para que a cor mude de forma não uniforme
/// moda.
///
/// <H>Gradientes lineares horizontais</H>
/// O exemplo a seguir usa um pincel de gradiente linear horizontal para preencher um
/// linha, uma elipse e um retângulo:

procedure TDemoLinearGradient.HorizontalGradient;
var
  Brush: TGdipLinearGradientBrush;
  Pen: TGdipPen;
begin
  Brush := TGdipLinearGradientBrush.Create(
    TPoint.Create(0, 10), TPoint.Create(200, 10),
    TGdipColor.Red, TGdipColor.Blue);
  Pen := TGdipPen.Create(Brush);

  Graphics.DrawLine(Pen, 0, 10, 200, 10);
  Graphics.FillEllipse(Brush, 0, 30, 200, 100);
  Graphics.FillRectangle(Brush, 0, 155, 500, 30);

  Pen.Free();
  Brush.Free();
end;

/// O construtor <A>TGdipLinearGradientBrush</A> recebe quatro argumentos: dois
/// pontos e duas cores. O primeiro ponto (0, 10) está associado ao primeiro
/// cor (vermelho), e o segundo ponto (200, 10) está associado ao segundo
/// cor azul). Como seria de esperar, a linha traçada de (0, 10) a (200, 10)
/// muda gradualmente de vermelho para azul.
///
/// Os 10 nos pontos (50, 10) e (200, 10) não são importantes. O que é
/// importante é que os dois pontos tenham a mesma segunda coordenada — a linha
/// conectá-los é horizontal. A elipse e o retângulo também mudam
/// gradualmente de vermelho para azul conforme a coordenada horizontal vai de 0 a 200.
///
/// A ilustração superior esquerda acima mostra a linha, a elipse e o
/// retângulo. Observe que o gradiente de cor se repete como a horizontal
/// a coordenada aumenta além de 200.
///
/// <H>Personalizando gradientes lineares</H>
/// No exemplo anterior, os componentes de cor mudam linearmente conforme você se move
/// de uma coordenada horizontal de 0 para uma coordenada horizontal de 200. Para
/// exemplo, um ponto cuja primeira coordenada está a meio caminho entre 0 e 200 irá
/// tem um componente azul que está no meio do caminho entre 0 e 255.
///
/// GDI+ permite ajustar a forma como uma cor varia de uma borda de um gradiente
/// para o outro. Suponha que você queira criar um pincel gradiente que mude de
/// preto para vermelho de acordo com a tabela a seguir.
///
/// Coordenada horizontal: 0, componentes RGB (0, 0, 0)
/// Coordenada horizontal: 40, componentes RGB (128, 0, 0)
/// Coordenada horizontal: 200, componentes RGB (255, 0, 0)
///
/// Observe que o componente vermelho está na metade da intensidade quando a horizontal
/// a coordenada está a apenas 20% do caminho de 0 a 200.
///
/// O exemplo a seguir define a propriedade <A>Blend</A> de um
/// Objeto <A>TGdipLinearGradientBrush</A> para associar três intensidades relativas
/// com três posições relativas. Como na tabela anterior, um parente
/// intensidade de 0,5 está associada a uma posição relativa de 0,2. O código
/// preenche uma elipse e um retângulo com o pincel gradiente.

procedure TDemoLinearGradient.CustomGradient;
const
  RelativeIntensities: array [0..2] of Single = (0.0, 0.5, 1.0);
  RelativePositions  : array [0..2] of Single = (0.0, 0.2, 1.0);
var
  Blend: TGdipBlend;
  Brush: TGdipLinearGradientBrush;
begin
  Brush := TGdipLinearGradientBrush.Create(
    TPoint.Create(0, 10), TPoint.Create(200, 10),
    TGdipColor.Red, TGdipColor.Blue);

  Blend := TGdipBlend.Create(RelativeIntensities, RelativePositions);
  Brush.Blend := Blend;

  Graphics.FillEllipse(Brush, 0, 230, 200, 100);
  Graphics.FillRectangle(Brush, 0, 355, 500, 30);

  Blend.Free();
  Brush.Free();
end;

/// A segunda ilustração acima mostra a elipse e o retângulo resultantes.
///
/// <H>Gradientes lineares diagonais</H>
/// Os gradientes nos exemplos anteriores foram horizontais; isto é, o
/// a cor muda gradualmente conforme você se move ao longo de qualquer linha horizontal. Você também pode
/// definir gradientes verticais e gradientes diagonais. O código a seguir passa
/// os pontos (0, 400) e (200, 500) para um <A>TGdipLinearGradientBrush</A>
/// construtor. A cor azul está associada a (0, 400), e a cor verde
/// está associado a (200, 500). Uma linha (com largura de caneta 10) e uma elipse são
/// preenchido com o pincel de gradiente linear.

procedure TDemoLinearGradient.DiagonalGradient;
var
  Brush: TGdipLinearGradientBrush;
  Pen: TGdipPen;
begin
  Brush := TGdipLinearGradientBrush.Create(
    TPoint.Create(0, 400), TPoint.Create(200, 500),
    TGdipColor.Blue, TGdipColor.Lime);
  Pen := TGdipPen.Create(Brush, 10);

  Graphics.DrawLine(Pen, 0, 400, 400, 600);
  Graphics.FillEllipse(Brush, 10, 500, 200, 100);

  Pen.Free();
  Brush.Free();
end;

/// A última ilustração acima mostra a linha e a elipse. Observe que o
/// a cor na elipse muda gradualmente à medida que você se move ao longo de qualquer linha que esteja
/// paralelo à linha que passa por (0, 400) e (200, 500).
{$ENDREGION}

procedure TDemoLinearGradient.Run;
begin
  HorizontalGradient;
  CustomGradient;
  DiagonalGradient;
end;

initialization
  RegisterDemo('Preenchendo formas com um pincel gradiente\Criando um gradiente linear', TDemoLinearGradient);

end.
