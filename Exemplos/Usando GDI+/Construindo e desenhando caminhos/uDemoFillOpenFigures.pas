unit uDemoFillOpenFigures;

interface

uses
   Types,
   Se7e.Drawing,
   Se7e.Drawing.Gdiplus.Types,
   uDemo;

type
  TDemoFillOpenFigures = class(TDemo)
  strict protected
    procedure Run; override;
  end;

implementation

{ TDemoFillOpenFigures }

{$REGION}
/// Você pode preencher um caminho passando um objeto <A>TGdipGraphicsPath</A> para o
/// Método <A>TGdipGraphics.FillPath</A>. O método <A>FillPath</A> preenche o caminho
/// de acordo com o modo de preenchimento (alternativo ou sinuoso) atualmente definido para o
/// caminho. Se o caminho tiver alguma figura aberta, o caminho é preenchido como se essas
/// os números foram fechados. GDI+ fecha uma figura desenhando uma linha reta de
/// seu ponto final para seu ponto inicial.
///
/// O exemplo a seguir cria um caminho que possui uma figura aberta (um arco) e
/// uma figura fechada (uma elipse). O método <A>TGdipGraphics.FillPath</A> preenche
/// o caminho de acordo com o modo de preenchimento padrão, que é
/// <A>FillModeAlternate</A>.

procedure TDemoFillOpenFigures.Run;
var
  Path: TGdipGraphicsPath;
  Pen: TGdipPen;
  Brush: TGdipBrush;
begin
  Path := TGdipGraphicsPath.Create();

  // Adicione uma figura aberta.
  Path.AddArc(0, 0, 150, 120, 30, 120);

  // Adicione uma figura intrinsecamente fechada.
  Path.AddEllipse(50, 50, 50, 100);

  Pen := TGdipPen.Create(TGdipColor.FromArgb(128, 0, 0, 255), 5);
  Brush := TGdipSolidBrush.Create(TGdipColor.Red);

  Graphics.FillPath(Brush, Path);
  Graphics.DrawPath(Pen, Path);

  Brush.Free();
  Pen.Free();
  Path.Free();
end;

/// A ilustração acima da saída do código anterior. Observe que o caminho é
/// preenchido (de acordo com <A>FillModeAlternate</A>) como se a figura aberta fosse
/// fechado por uma linha reta do ponto final ao ponto inicial.
{$ENDREGION}

initialization
  RegisterDemo('Construindo e desenhando caminhos\Preenchendo figuras abertas', TDemoFillOpenFigures);

end.
