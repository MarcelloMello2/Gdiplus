unit uDemoDrawLinesAndRectangles;

interface

uses
   Se7e.Drawing,
   Se7e.Drawing.Gdiplus.Types,
   uDemo;

type
  TDemoDrawLineAndRectangles = class(TDemo)
  strict private
    procedure DrawLine;
    procedure DrawRectangle;
  strict protected
    procedure Run; override;
  end;

implementation

{$REGION}
/// A interface <A>TGdipGraphics</A> fornece uma variedade de métodos de desenho
/// incluindo os mostrados na lista a seguir:
///
///  -<A>TGdipGraphics.DrawLine</A>
///  -<A>TGdipGraphics.DrawRectangle</A>
///  -<A>TGdipGraphics.DrawEllipse</A>
///  -<A>TGdipGraphics.DrawArc</A>
///  -<A>TGdipGraphics.DrawPath</A>
///  -<A>TGdipGraphics.DrawCurve</A>
///  -<A>TGdipGraphics.DrawBezier</A>
///
/// Um dos argumentos que você passa para tal método de desenho é um
/// <A>Objeto TGdipPen</A>.
///
/// Para desenhar linhas e retângulos, você precisa de um objeto <A>TGdipGraphics</A> e um
/// <A>Objeto TGdipPen</A>. O objeto <A>TGdipGraphics</A> fornece o <A>DrawLine</A>
/// e o objeto <A>TGdipPen</A> armazena recursos da linha, como
/// cor e largura.
///
/// O exemplo a seguir desenha uma linha de (20, 10) a (300, 100).

procedure TDemoDrawLineAndRectangles.DrawLine;
var
  Pen: TGdipPen;
begin
  Pen := TGdipPen.Create(TGdipColor.FromArgb(255, 0, 0, 0));
  Graphics.DrawLine(Pen, 20, 10, 300, 100);
  Pen.Free();
end;

/// A primeira instrução de código usa o construtor <A>de classe TGdipPen</A> para criar
/// uma caneta preta. O único argumento passado para o construtor <A>TGdipPen</A> é um
/// <A>Registro TGdipColor</A>. Os valores usados para construir o objeto <A>TGdipColor</A>
/// — (255, 0, 0, 0) — correspondem aos componentes alfa, vermelho, verde e azul
/// da cor. Esses valores definem uma caneta preta opaca.
///
/// O exemplo a seguir desenha um retângulo com seu canto superior esquerdo em
///  (10, 10). O retângulo tem uma largura de 100 e uma altura de 50. O segundo
/// argumento passado para o construtor <A>TGdipPen</A> indica que a largura da caneta
/// é de 5 pixels.

procedure TDemoDrawLineAndRectangles.DrawRectangle;
var
  BlackPen: TGdipPen;
begin
  BlackPen := TGdipPen.Create(TGdipColor.FromArgb(255, 0, 0, 0), 5);
  Graphics.DrawRectangle(BlackPen, 10, 10, 100, 50);
  BlackPen.Free();
end;

/// Quando o retângulo é desenhado, a caneta é centralizada no retângulo
/// fronteira. Como a largura da caneta é 5, os lados do retângulo são desenhados
/// 5 pixels de largura, de modo que 1 pixel é desenhado no próprio limite, 2 pixels
/// são desenhados por dentro, e 2 pixels são desenhados por fora. Para mais informações
/// detalhes sobre o alinhamento da caneta, veja a próxima demonstração <I>Definindo a largura da caneta e
/// Alinhamento</I>.
{$ENDREGION}

procedure TDemoDrawLineAndRectangles.Run;
begin
  DrawLine;
  DrawRectangle;
end;

initialization
  RegisterDemo('Usando a caneta para desenhar linhas e formas\Usando a caneta para desenhar linhas e retângulos', TDemoDrawLineAndRectangles);

end.
