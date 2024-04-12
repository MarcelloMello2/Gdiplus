unit uDemoPathGradient;

interface

uses
   Types,
   Se7e.Drawing,
   Se7e.Drawing.Gdiplus.Types,
   uDemo;

type
  TDemoPathGradient = class(TDemo)
  strict private
    procedure Example1;
    procedure Example2;
    procedure Example3;
    procedure Example4;
    procedure Example5;
    procedure Example6;
    procedure Example7;
  strict protected
    procedure Run; override;
  end;

implementation

{ TDemoPathGradient }

{$REGION}
/// A interface <A>TGdipPathGradientBrush</A> permite que você personalize a maneira como você
/// preenche uma forma com cores que mudam gradualmente. Um <A>TGdipPathGradientBrush</A>
/// objeto tem um caminho limite e um ponto central. Você pode especificar uma cor para
/// o ponto central e outra cor para o limite. Você também pode especificar
/// cores separadas para cada um dos vários pontos ao longo do limite.
///
/// Nota No GDI+, um caminho é uma sequência de linhas e curvas mantidas por um
/// Objeto <A>TGdipGraphicsPath</A>. Para obter mais informações sobre caminhos GDI+, consulte
/// os exemplos em <A>Construindo e desenhando caminhos</A>.
///
/// O exemplo a seguir preenche uma elipse com um pincel de gradiente de caminho. O
/// a cor central é definida como azul e a cor do limite é definida como aqua.

procedure TDemoPathGradient.Example1;
var
  Path: TGdipGraphicsPath;
  Brush: TGdipPathGradientBrush;
  SurroundColors: TArray<TGdipColor>;
begin
  Path := TGdipGraphicsPath.Create;
  Path.AddEllipse(0, 0, 140, 70);
  Brush := TGdipPathGradientBrush.Create(Path);
  Brush.CenterColor := TGdipColor.FromArgb(255, 0, 0, 255);
  SurroundColors := [TGdipColor.FromArgb(255, 0, 255, 255)];
  Brush.SurroundColors := SurroundColors;
  Graphics.FillEllipse(Brush, 0, 0, 140, 70);

  Brush.Free();
  Path.Free();
end;

/// A ilustração superior esquerda acima mostra a elipse preenchida.
///
/// Por padrão, um pincel de gradiente de caminho não se estende além do limite do
/// o caminho. Se você usar o pincel de gradiente de caminho para preencher uma forma que se estende
/// além do limite do caminho, a área da tela fora do caminho
/// não será preenchido. A próxima ilustração acima mostra o que acontece se você
/// altere a chamada <A>FillEllipse</A> no código anterior para o seguinte:

procedure TDemoPathGradient.Example2;
var
  Path: TGdipGraphicsPath;
  Brush: TGdipPathGradientBrush;
  SurroundColors: TArray<TGdipColor>;
begin
  Path := TGdipGraphicsPath.Create;
  Path.AddEllipse(150, 0, 140, 70);
  Brush := TGdipPathGradientBrush.Create(Path);
  Brush.CenterColor := TGdipColor.FromArgb(255, 0, 0, 255);
  SurroundColors := [TGdipColor.FromArgb(255, 0, 255, 255)];
  Brush.SurroundColors := SurroundColors;
  Graphics.FillRectangle(Brush, 150, 10, 200, 40);

  Brush.Free();
  Path.Free();
end;

/// <H>Especificando pontos na fronteira</H>
/// O exemplo a seguir constrói um pincel gradiente de caminho a partir de um pincel em forma de estrela
/// caminho. O código define a propriedade <A>CenterColor</A> como a cor no
/// centróide da estrela para vermelho. Em seguida, o código chama <A>SetSurroundColors</A>
/// método para especificar várias cores (armazenadas no array de cores) no
/// pontos individuais na matriz de pontos. A instrução de código final preenche o
/// caminho em forma de estrela com o pincel gradiente de caminho.

procedure TDemoPathGradient.Example3;
var
  Points: TArray<TPoint>;
  Path: TGdipGraphicsPath;
  Brush: TGdipPathGradientBrush;
  SurroundColors: TArray<TGdipColor>;
begin
  Points :=
  [
    TPoint.Create(375, 0), TPoint.Create(400, 50),
    TPoint.Create(450, 50), TPoint.Create(412, 75),
    TPoint.Create(450, 150), TPoint.Create(375, 100),
    TPoint.Create(300, 150), TPoint.Create(337, 75),
    TPoint.Create(300, 50), TPoint.Create(350, 50)
  ];

  Path := TGdipGraphicsPath.Create;
  Path.AddLines(Points);
  Brush := TGdipPathGradientBrush.Create(Path);
  Brush.CenterColor := TGdipColor.FromArgb(255, 255, 0, 0);

  SetLength(SurroundColors, 10);
  SurroundColors[0] := TGdipColor.FromArgb(255,   0,   0,   0);
  SurroundColors[1] := TGdipColor.FromArgb(255,   0, 255,   0);
  SurroundColors[2] := TGdipColor.FromArgb(255,   0,   0, 255);
  SurroundColors[3] := TGdipColor.FromArgb(255, 255, 255, 255);
  SurroundColors[4] := TGdipColor.FromArgb(255,   0,   0,   0);
  SurroundColors[5] := TGdipColor.FromArgb(255,   0, 255,   0);
  SurroundColors[6] := TGdipColor.FromArgb(255,   0,   0, 255);
  SurroundColors[7] := TGdipColor.FromArgb(255, 255, 255, 255);
  SurroundColors[8] := TGdipColor.FromArgb(255,   0,   0,   0);
  SurroundColors[9] := TGdipColor.FromArgb(255,   0, 255,   0);
  Brush.SurroundColors := SurroundColors;
  Graphics.FillPath(Brush, Path);

  Brush.Free();
  Path.Free();
end;

/// A terceira ilustração acima mostra a estrela preenchida.
///
/// O exemplo a seguir constrói um pincel de gradiente de caminho baseado em uma matriz de
/// pontos. Uma cor é atribuída a cada um dos cinco pontos da matriz. Se você
/// se conectasse os cinco pontos por linhas retas, você obteria um
/// polígono de cinco lados. Uma cor também é atribuída ao centro (centróide) de
/// aquele polígono — neste exemplo, o centro está definido como branco. O código final
/// a instrução no exemplo preenche um retângulo com o pincel de gradiente de caminho.
///
/// A cor usada para preencher o retângulo é branca no centro e muda
/// gradualmente conforme você se afasta do centro em direção aos pontos no array.
/// Por exemplo, conforme você se move do centro para o canto superior esquerdo, a cor
/// muda gradualmente de branco para vermelho, e conforme você se move do centro para o
/// canto superior direito, a cor muda gradualmente de branco para verde.

procedure TDemoPathGradient.Example4;
var
  Points: TArray<TPointF>;
  Brush: TGdipPathGradientBrush;
  Pen: TGdipPen;
  SurroundColors: TArray<TGdipColor>;
begin
   Points :=
   [
      TPointF.Create(460, 0),
      TPointF.Create(620, 0),
      TPointF.Create(620, 200),
      TPointF.Create(540, 150),
      TPointF.Create(460, 200)
   ];

   Brush := TGdipPathGradientBrush.Create(Points);
   Brush.CenterColor := TGdipColor.White;

   SurroundColors :=
   [
      TGdipColor.FromArgb(255, 255,   0,   0),
      TGdipColor.FromArgb(255,   0, 255,   0),
      TGdipColor.FromArgb(255,   0, 255,   0),
      TGdipColor.FromArgb(255,   0,   0, 255),
      TGdipColor.FromArgb(255, 255,   0,   0)
   ];
   Brush.SurroundColors := SurroundColors;
   Graphics.FillRectangle(Brush, 460, 0, 180, 220);

   Pen := TGdipPen.Create(TGdipColor.Blue);
   Graphics.DrawRectangle(Pen, 460, 0, 180, 220);

   Pen.Free();
   Brush.Free();
end;

/// Observe que não há objeto <A>TGdipGraphicsPath</A> no código anterior. O
/// determinado construtor <A>TGdipPathGradientBrush</A> no exemplo recebe um
/// matriz de pontos, mas não requer um objeto <A>TGdipGraphicsPath</A>. Também,
/// observe que o pincel gradiente de caminho é usado para preencher um retângulo, não um caminho.
/// O retângulo é maior que o caminho usado para definir o pincel, então alguns dos
/// o retângulo não é pintado pelo pincel. A quarta ilustração acima mostra
/// o retângulo (linha azul) e a parte do retângulo pintada pelo
/// pincel gradiente de caminho.
///
/// <H>Personalizando um gradiente de caminho</H>
/// Uma maneira de personalizar um pincel de gradiente de caminho é definir suas escalas de foco. O
/// escalas de foco especificam um caminho interno que fica dentro do caminho principal. O
/// a cor central é exibida em todos os lugares dentro desse caminho interno, e não apenas
/// no ponto central. Para definir as escalas de foco de um pincel de gradiente de caminho, chame
/// o método <A>SetFocusScales</A>.
///
/// O exemplo a seguir cria um pincel de gradiente de caminho baseado em uma forma elíptica
/// caminho. O código define a cor do limite como azul, define a cor central como
/// aqua e, em seguida, usa o pincel gradiente de caminho para preencher o caminho elíptico.
///
/// Em seguida, o código define as escalas de foco do pincel gradiente do caminho. O foco x
/// a escala está definida como 0,3 e a escala de foco y está definida como 0,8. O código chama o
/// Método <A>TranslateTransform</A> de um objeto <A>TGdipGraphics</A> para que o
/// chamada subsequente para <A>FillPath</A> preenche uma elipse que fica à direita
/// da primeira elipse.
///
/// Para ver o efeito das escalas de foco, imagine uma pequena elipse que compartilha
/// seu centro com a elipse principal. A pequena elipse (interna) é a principal
/// elipse dimensionada (em torno de seu centro) horizontalmente por um fator de 0,3 e
/// verticalmente por um fator de 0,8. À medida que você se move do limite do exterior
/// elipse até o limite da elipse interna, a cor muda gradualmente
/// do azul para o aqua. À medida que você se move do limite da elipse interna para o
/// centro compartilhado, a cor permanece água.

procedure TDemoPathGradient.Example5;
var
  Path: TGdipGraphicsPath;
  Brush: TGdipPathGradientBrush;
  SurroundColors: TArray<TGdipColor>;
begin
  Path := TGdipGraphicsPath.Create;
  Path.AddEllipse(0, 230, 200, 100);
  Brush := TGdipPathGradientBrush.Create(Path);
  Brush.GammaCorrection := True;

  SurroundColors := [TGdipColor.FromArgb(255, 0, 0, 255)];
  Brush.SurroundColors := SurroundColors;
  Brush.CenterColor := TGdipColor.FromArgb(255, 0, 255, 255);
  Graphics.FillPath(Brush, Path);

  Brush.FocusScales := TPointF.Create(0.3, 0.8);
  Graphics.TranslateTransform(220, 0);
  Graphics.FillPath(Brush, Path);
  Graphics.ResetTransform;

  Brush.Free();
  Path.Free();
end;

/// A quinta ilustração acima (a primeira na 2ª linha) mostra a saída de
/// o código anterior. A elipse à esquerda é água apenas no centro
/// apontar. A elipse à direita é água em todos os lugares dentro do caminho interno.
///
/// Outra maneira de personalizar um pincel de gradiente de caminho é especificar um array de
/// cores predefinidas e uma matriz de posições de interpolação.
///
/// O exemplo a seguir cria um pincel gradiente de caminho baseado em um triângulo. O
/// código define a propriedade <A>TGdipPathGradientBrush.InterpolationColors</A> do
/// pincel gradiente de caminho para especificar uma matriz de cores de interpolação (verde escuro,
/// aqua, blue) e uma matriz de posições de interpolação (0, 0,25, 1). Como você
/// move-se do limite do triângulo para o ponto central, a cor
/// muda gradualmente de verde escuro para água e depois de água para azul. O
/// a mudança de verde escuro para água acontece a 25% da distância de
/// verde escuro para azul.

procedure TDemoPathGradient.Example6;
var
  Points: TArray<TPoint>;
  InterPositions: TArray<Single>;
  Brush: TGdipPathGradientBrush;
  PresetColors: TArray<TGdipColor>;
  Blend: TGdipColorBlend;
begin
   Points :=
   [
      TPoint.Create(540, 230),
      TPoint.Create(640, 430),
      TPoint.Create(440, 430)
   ];

   InterPositions :=
   [
      0.00,  // O verde escuro está no limite do triângulo.
      0.25,  // Aqua está a 25% do caminho entre o limite e o ponto central
      1.00   // O azul está no ponto central.
   ];

   Brush := TGdipPathGradientBrush.Create(Points);
   PresetColors  :=
   [
      TGdipColor.Green,
      TGdipColor.Aqua,
      TGdipColor.Blue
   ];

   Blend := TGdipColorBlend.Create(PresetColors, InterPositions);
   Brush.InterpolationColors := Blend;
   Graphics.FillRectangle(Brush, 440, 230, 200, 200);

  Blend.Free();
  Brush.Free();
end;

/// O triângulo na ilustração acima mostra a saída do anterior
/// código.
///
/// <H>Definindo o ponto central</H>
/// Por padrão, o ponto central de um pincel de gradiente de caminho está no centróide de
/// o caminho usado para construir o pincel. Você pode alterar a localização do
/// ponto central definindo a propriedade <A>TGdipPathGradientBrush.CenterPoint</A>
/// da interface <A>TGdipPathGradientBrush</A>.
///
/// O exemplo a seguir cria um pincel gradiente de caminho baseado em uma elipse. O
/// o centro da elipse está em (70, 385), mas o ponto central do caminho
/// pincel gradiente está definido como (120, 390).

procedure TDemoPathGradient.Example7;
var
  Path: TGdipGraphicsPath;
  Brush: TGdipPathGradientBrush;
  SurroundColors: TArray<TGdipColor>;
begin
  Path := TGdipGraphicsPath.Create;
  Path.AddEllipse(0, 350, 140, 70);
  Brush := TGdipPathGradientBrush.Create(Path);
  Brush.CenterPoint := TPointF.Create(120, 390);
  SurroundColors := [TGdipColor.Aqua];
  Brush.SurroundColors := SurroundColors;
  Brush.CenterColor := TGdipColor.Blue;
  Graphics.FillEllipse(Brush, 0, 350, 140, 70);

  Brush.CenterPoint := TPointF.Create(145, 385);
  SurroundColors := [TGdipColor.Yellow];
  Brush.SurroundColors := SurroundColors;
  Brush.CenterColor := TGdipColor.Red;
  Graphics.TranslateTransform(150, 0);
  Graphics.FillEllipse(Brush, 0, 350, 140, 70);

  Brush.Free();
  Path.Free();
end;

/// A próxima ilustração acima mostra a elipse preenchida e o ponto central de
/// o pincel gradiente do caminho.
///
/// Você pode definir o ponto central de um pincel de gradiente de caminho para um local fora
/// o caminho que foi usado para construir o pincel, como você pode ver no final
/// ilustração acima.
{$ENDREGION}

procedure TDemoPathGradient.Run;
begin
  Example1;
  Example2;
  Example3;
  Example4;
  Example5;
  Example6;
  Example7;
end;

initialization
  RegisterDemo('Preenchendo formas com um pincel gradiente\Criando um gradiente de caminho', TDemoPathGradient);

end.
