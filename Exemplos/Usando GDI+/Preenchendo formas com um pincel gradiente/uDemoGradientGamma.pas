unit uDemoGradientGamma;

interface

uses
   Se7e.Drawing,
   Se7e.Drawing.Gdiplus.Types,
   uDemo;

type
  TDemoGradientGamma = class(TDemo)
  strict private
    procedure Example1;
    procedure Example2;
  strict protected
    procedure Run; override;
  end;

implementation

{ TDemoGradientGamma }

{$REGION}
/// Você pode ativar a correção gama para um pincel de gradiente definindo o
/// Propriedade <A>GammaCorrection</A> de at brush como True. Você pode desativar gama
/// correção definindo a propriedade <A>GammaCorrection</A> como False. Gama
/// a correção está desabilitada por padrão.
///
/// O exemplo a seguir cria um pincel de gradiente linear e usa esse pincel para
/// preenche dois retângulos. O primeiro retângulo é preenchido sem correção gama
/// e o segundo retângulo é preenchido com correção gama.

procedure TDemoGradientGamma.Example1;
var
   Brush: TGdipLinearGradientBrush;
begin
   Brush := TGdipLinearGradientBrush.Create(TPoint.Create(0, 10),
                                            TPoint.Create(200, 10),
                                            TGdipColor.Red, TGdipColor.Blue);
   Graphics.FillRectangle(Brush, 0, 0, 200, 50);
   Brush.GammaCorrection := True;
   Graphics.FillRectangle(Brush, 0, 60, 200, 50);

   Brush.Free();
end;

/// A ilustração acima mostra os dois retângulos preenchidos. O retângulo superior,
/// que não possui correção gama, aparece escuro no meio. O fundo
/// o retângulo, que possui correção gama, parece ter intensidade mais uniforme.
///
/// O exemplo a seguir cria um pincel de gradiente de caminho baseado em um formato de estrela
/// caminho. O código usa o pincel gradiente de caminho com a correção gama desativada
/// (o padrão) para preencher o caminho. Então o código define o
/// propriedade <A>GammaCorrection</A> como True para ativar a correção gama para o
/// pincel gradiente de caminho. A chamada para conjuntos <A>TGdipGraphics.TranslateTransform</A>
/// a transformação mundial de um objeto <A>TGdipGraphics</A> para que o subseqüente
/// chamada para <A>FillPath</A> preenche uma estrela que fica à direita da primeira
/// estrela.

procedure TDemoGradientGamma.Example2;
var
   Points: TArray<TPoint>;
   Path: TGdipGraphicsPath;
   Brush: TGdipPathGradientBrush;
   Colors: TArray<TGdipColor>;
begin
   Points :=
   [
      TPoint.Create(75, 120),  TPoint.Create(100, 170),
      TPoint.Create(150, 170), TPoint.Create(112, 195),
      TPoint.Create(150, 270), TPoint.Create(75,  220),
      TPoint.Create(0,   270), TPoint.Create(37,  195),
      TPoint.Create(0,   170), TPoint.Create(50,  170)
   ];

   Path := TGdipGraphicsPath.Create();
   Path.AddLines(Points);

   Brush := TGdipPathGradientBrush.Create(Path);
   Brush.CenterColor := TGdipColor.Red;

   Colors :=
   [
      TGdipColor.FromArgb(255,   0,   0,   0),
      TGdipColor.FromArgb(255,   0, 255,   0),
      TGdipColor.FromArgb(255,   0,   0, 255),
      TGdipColor.FromArgb(255, 255, 255, 255),
      TGdipColor.FromArgb(255,   0,   0,   0),
      TGdipColor.FromArgb(255,   0, 255,   0),
      TGdipColor.FromArgb(255,   0,   0, 255),
      TGdipColor.FromArgb(255, 255, 255, 255),
      TGdipColor.FromArgb(255,   0,   0,   0),
      TGdipColor.FromArgb(255,   0, 255,   0)
   ];
   Brush.SurroundColors := Colors;

   Graphics.FillPath(Brush, Path);
   Brush.GammaCorrection := True;
   Graphics.TranslateTransform(200, 0);
   Graphics.FillPath(Brush, Path);

   Brush.Free();
   Path.Free();
end;

/// A ilustração acima mostra a saída do código anterior. A estrela ligada
/// a direita tem correção gama. Observe que a estrela à esquerda, que faz
/// não possui correção gama, possui áreas que parecem escuras.
{$ENDREGION}

procedure TDemoGradientGamma.Run;
begin
  Example1;
  Example2;
end;

initialization
  RegisterDemo('Preenchendo formas com um pincel gradiente\Aplicando correção gama a um gradiente', TDemoGradientGamma);

end.
