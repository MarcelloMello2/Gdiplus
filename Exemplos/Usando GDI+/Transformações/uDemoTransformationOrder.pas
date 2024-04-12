unit uDemoTransformationOrder;

interface

uses
   Types,
   Se7e.Drawing,
   Se7e.Drawing.Gdiplus.Types,
   uDemo;

type
  TDemoTransformationOrder = class(TDemo)
  strict private
    procedure Example1;
    procedure Example2;
    procedure Example3;
  strict protected
    procedure Run; override;
  end;

implementation

{ TDemoTransformationOrder }

{$REGION}
/// Um único objeto <A>TGdipMatrix</A> pode armazenar uma única transformação ou um
/// sequência de transformações. Este último é chamado de composto
/// transformação. A matriz de uma transformação composta é obtida por
/// multiplicando as matrizes das transformações individuais.
///
/// Em uma transformação composta, a ordem das transformações individuais
/// é importante. Por exemplo, se você primeiro girar, depois dimensionar e depois transladar,
/// você obtém um resultado diferente do que se primeiro transladasse, depois girasse e depois
/// escala. No Microsoft Windows GDI+, as transformações compostas são criadas a partir de
/// da esquerda para direita. Se S, R e T são matrizes de escala, rotação e translação
/// respectivamente, então o produto SRT (nessa ordem) é a matriz do
/// transformação composta que primeiro dimensiona, depois gira e depois converte.
/// A matriz produzida pelo produto SRT é diferente da matriz produzida
/// pelo produto TRS.
///
/// Uma razão pela qual a ordem é significativa é que transformações como rotação e
/// o escalonamento é feito em relação à origem do sistema de coordenadas.
/// Dimensionar um objeto centrado na origem produz um resultado diferente
/// do que dimensionar um objeto que foi afastado da origem. De forma similar,
/// girar um objeto que está centrado na origem produz um resultado diferente
/// resultado da rotação de um objeto que foi afastado da origem.
///
/// O exemplo a seguir combina escala, rotação e translação (nesse caso
/// ordem) para formar uma transformação composta. O argumento
/// <A>MatrixOrderAppend</A> passado para o método <A>RotateTransform</A>
/// especifica que a rotação seguirá a escala. Da mesma forma, o argumento
/// <A>MatrixOrderAppend</A> passado para o método <A>TranslateTransform</A>
/// especifica que a translação seguirá a rotação. O resultado é
/// desenhado em vermelho.

procedure TDemoTransformationOrder.Example1;
var
  Rect: TRectangle;
  Pen: TGdipPen;
begin
  Rect := TRectangle.Create(0, 0, 50, 50);
  Pen := TGdipPen.Create(TGdipColor.Red, 6);
  Graphics.ScaleTransform(1.75, 0.5);
  Graphics.RotateTransform(28, TGdipMatrixOrder.Append);
  Graphics.TranslateTransform(150, 150, TGdipMatrixOrder.Append);
  Graphics.DrawRectangle(Pen, Rect);
  Pen.Free();
end;

/// O exemplo a seguir faz as mesmas chamadas de método do exemplo anterior,
/// mas a ordem das chamadas é invertida. A ordem de operações resultante é
/// primeiro traduz, depois gira e depois dimensiona, o que produz um resultado muito diferente
/// resultado da primeira escala, depois girar e depois traduzir. O resultado é desenhado
/// em verde.

procedure TDemoTransformationOrder.Example2;
var
  Rect: TRectangle;
  Pen: TGdipPen;
begin
  Rect := TRectangle.Create(0, 0, 50, 50);
  Pen := TGdipPen.Create(TGdipColor.Lime, 6);
  Graphics.TranslateTransform(150, 150);
  Graphics.RotateTransform(28, TGdipMatrixOrder.Append);
  Graphics.ScaleTransform(1.75, 0.5, TGdipMatrixOrder.Append);
  Graphics.DrawRectangle(Pen, Rect);
  Pen.Free();
end;

/// Uma maneira de reverter a ordem das transformações individuais em um
/// transformação composta é inverter a ordem de uma sequência de método
/// chamadas. Uma segunda maneira de controlar a ordem das operações é alterar o
/// argumento de ordem de matriz. O exemplo a seguir é igual ao anterior
/// exemplo, exceto que MatrixOrderAppend foi alterado para
/// MatrixOrderPrepend. A multiplicação da matriz é feita na ordem SRT,
/// onde S, R e T são as matrizes para dimensionar, girar e transladar,
/// respectivamente. A ordem da transformação composta é primeiro escala, depois
/// gire e depois traduza. O resultado foi desenhado em amarelo.

procedure TDemoTransformationOrder.Example3;
var
  Rect: TRectangle;
  Pen: TGdipPen;
begin
  Rect := TRectangle.Create(0, 0, 50, 50);
  Pen := TGdipPen.Create(TGdipColor.Yellow, 2);
  Graphics.TranslateTransform(150, 150, TGdipMatrixOrder.Prepend);
  Graphics.RotateTransform(28, TGdipMatrixOrder.Prepend);
  Graphics.ScaleTransform(1.75, 0.5, TGdipMatrixOrder.Prepend);
  Graphics.DrawRectangle(Pen, Rect);
  Pen.Free();
end;

/// O resultado do exemplo anterior é o mesmo resultado que obtivemos em
/// o primeiro exemplo desta seção (é por isso que o retângulo amarelo se sobrepõe
/// o retângulo vermelho). Isso ocorre porque invertemos a ordem do método
/// chamadas e a ordem de multiplicação da matriz.
{$ENDREGION}

procedure TDemoTransformationOrder.Run;
begin
  Example1();
  Graphics.ResetTransform();
  Example2();
  Graphics.ResetTransform();
  Example3();
end;

initialization
  RegisterDemo('Transformações\Por que a ordem de transformação é significativa', TDemoTransformationOrder);

end.
