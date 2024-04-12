unit uDemoBezierSplines;

interface

uses
   Types,
   Se7e.Drawing,
   Se7e.Drawing.Gdiplus.Types,
   uDemo;

type
  TDemoBezierSplines = class(TDemo)
  strict private
    procedure DrawBezier1;
    procedure DrawBezier2;
  strict protected
    procedure Run; override;
  end;

implementation

uses
  SysUtils;

{ TDemoBezierSplines }

{$REGION}
/// Um spline de Bézier é definido por quatro pontos: um ponto inicial, dois pontos de controle
/// pontos e um ponto final. O exemplo a seguir desenha um spline de Bézier com
/// ponto inicial (10, 100) e ponto final (200, 100). Os pontos de controle são (100,
/// 10) e (150, 150):

procedure TDemoBezierSplines.DrawBezier1;
var
  P1, C1, C2, P2: TPointF;
  Pen: TGdipPen;
  Font: TGdipFont;
  Brush: TGdipBrush;
begin
  P1 := TPointF.Create(10, 100); // ponto de partida
  C1 := TPointF.Create(100, 10); // primeiro ponto de controle
  C2 := TPointF.Create(150, 150); // segundo ponto de controle
  P2 := TPointF.Create(200, 100); // ponto final
  Pen := TGdipPen.Create(TGdipColor.Blue);
  Graphics.DrawBezier(Pen, P1, C1, C2, P2);

  Pen.Color := TGdipColor.Red;
  Graphics.DrawPolygon(Pen, [P1, C1, P2, C2]);

  Font := TGdipFont.Create('Tahoma', 8);
  Brush := TGdipSolidBrush.Create(TGdipColor.Black);
  Graphics.DrawString('P1', Font, Brush, P1);
  Graphics.DrawString('C1', Font, Brush, C1);
  Graphics.DrawString('C2', Font, Brush, C2);
  Graphics.DrawString('P2', Font, Brush, P2);

  Brush.Free();
  Font.Free();
  Pen.Free();
end;

/// A ilustração acima à esquerda mostra o spline de Bézier resultante junto com
/// seu ponto inicial, pontos de controle e ponto final. A ilustração também mostra
/// o casco convexo do spline, que é um polígono formado pela conexão dos quatro
/// aponta com linhas retas.
///
/// Você pode usar o método <A>DrawBeziers</A> da interface <A>TGdipGraphics</A>
/// para desenhar uma sequência de splines de Bézier conectadas. O exemplo a seguir desenha
/// uma curva que consiste em duas splines de Bézier conectadas. O ponto final do
/// o primeiro spline de Bézier é o ponto inicial do segundo spline de Bézier.

procedure TDemoBezierSplines.DrawBezier2;
var
  Points: TArray<TPointF>;
  Pen: TGdipPen;
  Font: TGdipFont;
  RedBrush, BlackBrush: TGdipBrush;
  I: Integer;
  P: TPointF;
begin
   Points :=
   [
     TPointF.Create(235, 100),  // ponto inicial do primeiro spline
     TPointF.Create(300, 10),   // primeiro ponto de controle do primeiro spline
     TPointF.Create(305, 50),   // segundo ponto de controle do primeiro spline
     TPointF.Create(325, 150),  // ponto final do primeiro spline e ponto inicial do segundo spline
     TPointF.Create(340, 80),   // primeiro ponto de controle do segundo spline
     TPointF.Create(400, 200),  // segundo ponto de controle do segundo spline
     TPointF.Create(425, 80)    // ponto final do segundo spline
   ];

  Pen := TGdipPen.Create(TGdipColor.Blue);
  Graphics.DrawBeziers(Pen, Points);

  Font := TGdipFont.Create('Tahoma', 8);
  RedBrush := TGdipSolidBrush.Create(TGdipColor.Red);
  BlackBrush := TGdipSolidBrush.Create(TGdipColor.Black);
  for I := 0 to Length(Points) - 1 do
  begin
    P := Points[I];
    Graphics.FillRectangle(RedBrush, P.X - 2, P.Y - 2, 5, 5);
    Graphics.DrawString(Format('P[%d]', [I]), Font, BlackBrush, P);
  end;

  BlackBrush.Free();
  RedBrush.Free();
  Font.Free();
  Pen.Free();
end;
{$ENDREGION}

procedure TDemoBezierSplines.Run;
begin
  DrawBezier1;
  DrawBezier2;
end;

initialization
  RegisterDemo('Construindo e desenhando curvas\Desenhando splines de Bézier', TDemoBezierSplines);

end.
