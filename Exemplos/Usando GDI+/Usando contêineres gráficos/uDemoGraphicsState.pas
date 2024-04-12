unit uDemoGraphicsState;

interface

uses
   Types,
   Se7e.Drawing,
   Se7e.Drawing.Gdiplus.Types,
   uDemo;

type
  TDemoGraphicsState = class(TDemo)
  strict private
    procedure Example1;
    procedure Example2;
    procedure Example3;
  strict protected
    procedure Run; override;
  end;

implementation

{ TDemoGraphicsState }

{$REGION}
/// Um objeto <A>TGdipGraphics</A> fornece métodos como <A>DrawLine</A>,
/// <A>DrawImage</A> e <A>DrawString</A> para exibir imagens vetoriais, raster
/// imagens e texto. Um objeto <A>TGdipGraphics</A> também possui diversas propriedades que
/// influenciar a qualidade e orientação dos itens desenhados. Para
/// exemplo, a propriedade do modo de suavização determina se o antialiasing é
/// aplicado a linhas e curvas, e a propriedade de transformação mundial
/// influencia a posição e rotação dos itens que são desenhados.
///
/// Um objeto <A>TGdipGraphics</A> é frequentemente associado a um display específico
/// dispositivo. Quando você usa um objeto <A>TGdipGraphics</A> para desenhar em uma janela, o
/// O objeto <A>TGdipGraphics</A> também está associado a essa janela específica.
///
/// Um objeto <A>TGdipGraphics</A> pode ser considerado um contêiner porque contém
/// um conjunto de propriedades que influenciam o desenho e está vinculado a
/// informações específicas do dispositivo. Você pode criar um contêiner secundário dentro de um
/// objeto <A>TGdipGraphics</A> existente chamando o método <A>BeginContainer</A>
/// desse objeto <A>TGdipGraphics</A>.
///
/// <H>Estado dos gráficos</H>
/// Um objeto <A>TGdipGraphics</A> faz mais do que fornecer métodos de desenho, como
/// <A>DrawLine</A> e <A>DrawRectangle</A>. Um objeto <A>TGdipGraphics</A> também
/// mantém o estado dos gráficos, que pode ser dividido nas seguintes categorias:
///
/// -Um link para um contexto de dispositivo
/// -Configurações de qualidade
/// -Transformações
/// -Uma região de recorte
///
/// <H>Contexto do dispositivo</H>
/// Como programador de aplicativos, você não precisa pensar na interação
/// entre um objeto <A>TGdipGraphics</A> e seu contexto de dispositivo. Esta interação
/// é tratado pelo GDI+ nos bastidores.
///
/// <H>Configurações de qualidade</H>
/// Um objeto <A>TGdipGraphics</A> possui diversas propriedades que influenciam a qualidade
/// dos itens que são desenhados na tela. Você pode visualizar e manipular esses
/// propriedades chamando os métodos get e set. Por exemplo, você pode definir o
/// Propriedade <A>TextRenderingHint</A> para especificar o tipo de antialiasing (se
/// qualquer) aplicado ao texto. Outras propriedades definidas que influenciam a qualidade são
/// <A>SmoothingMode</A>, <A>CompositingMode</A>, <A>CompositingQuality</A> e
/// <A>ModoInterpolação</A>.
///
/// O exemplo a seguir desenha duas elipses, uma com o modo de suavização definido como
/// <A>SmoothingModeAntiAlias</A> e um com o modo de suavização definido como
/// <A>SmoothingModeHighSpeed</A>.

procedure TDemoGraphicsState.Example1;
var
  Pen: TGdipPen;
begin
  Pen := TGdipPen.Create(TGdipColor.Lime, 3);
  Graphics.SmoothingMode := TGdipSmoothingMode.AntiAlias8x4;
  Graphics.DrawEllipse(Pen, 0, 0, 200, 100);
  Graphics.SmoothingMode := TGdipSmoothingMode.HighSpeed;
  Graphics.DrawEllipse(Pen, 0, 150, 200, 100);

  Pen.Free();
end;

/// As reticências verdes na ilustração acima mostram o resultado.
///
/// <H>Transformações</H>
/// Um objeto <A>TGdipGraphics</A> mantém duas transformações (mundo e página)
/// que são aplicados a todos os itens desenhados por esse objeto <A>TGdipGraphics</A>. Qualquer
/// transformação afim pode ser armazenada na transformação mundial. Afim
/// as transformações incluem dimensionamento, rotação, reflexão, inclinação e
/// traduzindo. A transformação da página pode ser usada para dimensionamento e para
/// alterando unidades (por exemplo, pixels para polegadas). Para mais informações sobre
/// transformações, consulte Sistemas de Coordenadas e Transformações no
/// Plataforma SDK.
///
/// O exemplo a seguir define as transformações de mundo e de página de um
/// Objeto <A>TGdipGraphics</A>. A transformação mundial está definida para um ritmo de 30 graus
/// rotação. A transformação da página é definida de forma que as coordenadas passadas para
/// o segundo <A>DrawEllipse</A> será tratado como milímetros em vez de
/// píxeis. O código faz duas chamadas idênticas ao método <A>DrawEllipse</A>.
/// A transformação mundial é aplicada à primeira chamada <A>DrawEllipse</A>,
/// e ambas as transformações (mundo e página) são aplicadas ao segundo
/// Chamada <A>DrawEllipse</A>.

procedure TDemoGraphicsState.Example2;
var
  Pen: TGdipPen;
begin
  Pen := TGdipPen.Create(TGdipColor.Red);

  Graphics.ResetTransform;
  Graphics.RotateTransform(30);             // Transformação de mundial
  Graphics.DrawEllipse(Pen, 30, 0, 50, 25);
  Graphics.PageUnit := TGdipGraphicsUnit.Millimeter;      //Transformação de página
  Graphics.DrawEllipse(Pen, 30, 0, 50, 25);

  Pen.Free();
end;

/// As reticências vermelhas na ilustração acima mostram o resultado. Observe que o
/// A rotação de 30 graus é sobre a origem do sistema de coordenadas (canto superior esquerdo
/// canto da área do cliente), não sobre os centros das elipses. Observe também
/// que a largura da caneta de 1 significa 1 pixel para a primeira elipse e 1 milímetro
/// para a segunda elipse.
///
/// <H>Região de recorte</H>
/// Um objeto <A>TGdipGraphics</A> mantém uma região de recorte que se aplica a todos
/// itens desenhados por esse objeto <A>TGdipGraphics</A>. Você pode definir a região de recorte
/// chamando o método <A>SetClip</A> ou definindo a propriedade <A>Clip</A>.
///
/// O exemplo a seguir cria uma região em formato de mais formando a união de
/// dois retângulos. Essa região é designada como região de recorte de um
/// Objeto <A>TGdipGraphics</A>. Então o código desenha duas linhas que são restritas
/// para o interior da região de recorte.

procedure TDemoGraphicsState.Example3;
var
  Pen: TGdipPen;
  Brush: TGdipBrush;
  Region: TGdipRegion;
begin
  Pen := TGdipPen.Create(TGdipColor.Red, 5);
  Brush := TGdipSolidBrush.Create(TGdipColor.FromArgb(255, 180, 255, 255));

  // Crie uma região em formato de positivo formando a união de dois retângulos.
  Region := TGdipRegion.Create(TRectangle.Create(300, 0, 50, 150));
  Region.Union(TRectangle.Create(250, 50, 150, 50));
  Graphics.FillRegion(Brush, Region);

  //Defina a região de recorte.
  Graphics.Clip := Region;

  // Desenhe duas linhas recortadas.
  Graphics.DrawLine(Pen, 250, 30, 400, 160);
  Graphics.DrawLine(Pen, 290, 20, 440, 150);

  Region.Free();
  Brush.Free();
  Pen.Free();
end;
{$ENDREGION}

procedure TDemoGraphicsState.Run;
begin
  Example1;
  Example2;
  Graphics.PageUnit := TGdipGraphicsUnit.Pixel;
  Graphics.ResetTransform();
  Example3;
end;

initialization
  RegisterDemo('Usando contêineres gráficos\O estado de um objeto gráfico', TDemoGraphicsState);

end.
