unit uDemoNestedContainers;

interface

uses
   Types,
   Se7e.Drawing,
   Se7e.Drawing.Gdiplus.Types,
   uDemo;

type
  TDemoNestedContainers = class(TDemo)
  strict private
    procedure Example1;
    procedure Example2;
    procedure Example3;
  strict protected
    procedure Run; override;
  end;

implementation

{ TDemoNestedContainers }

{$REGION}
/// O Microsoft Windows GDI+ fornece contêineres que você pode usar para temporariamente
/// substitui ou aumenta parte do estado em um objeto <A>TGdipGraphics</A>. Você
/// cria um contêiner chamando o método <A>BeginContainer</A> de um
/// Objeto <A>TGdipGraphics</A>. Você pode chamar <A>BeginContainer</A> repetidamente para
/// forma contêineres aninhados.
///
/// <H>Transformações em contêineres aninhados</H>
/// O exemplo a seguir cria um objeto <A>TGdipGraphics</A> e um contêiner
/// dentro desse objeto <A>TGdipGraphics</A>. A transformação mundial do
/// O objeto <A>TGdipGraphics</A> é uma translação de 100 unidades na direção x e 80
/// unidades na direção y. A transformação mundial do contêiner é uma
/// rotação de 30 graus. O código faz a chamada
///
/// <C>DrawRectangle(Caneta, -60, -30, 120, 60)</C>
///
/// duas vezes. A primeira chamada para <A>DrawRectangle</A> está dentro do contêiner; que
/// é que a chamada está entre as chamadas para <A>BeginContainer</A> e
/// <A>EndContainer</A>. A segunda chamada para <A>DrawRectangle</A> é após o
/// chamada para <A>EndContainer</A>.

procedure TDemoNestedContainers.Example1;
var
   Pen: TGdipPen;
   Container: TGdipGraphicsContainer;
begin
   Pen := TGdipPen.Create(TGdipColor.Red);
   Graphics.TranslateTransform(100, 80);

   Container := Graphics.BeginContainer();
   Graphics.RotateTransform(30);
   Graphics.DrawRectangle(Pen, -60, -30, 120, 60);
   Graphics.EndContainer(Container);

   Graphics.DrawRectangle(Pen, -60, -30, 120, 60);

   Pen.Free();
end;

/// No código anterior, o retângulo desenhado de dentro do contêiner é
/// transformado primeiro pela transformação mundial do contêiner (rotação)
/// e depois pela transformação mundial do objeto <A>TGdipGraphics</A>
/// (tradução). O retângulo desenhado de fora do contêiner é transformado
/// somente pela transformação mundial do objeto <A>TGdipGraphics</A>
/// (tradução). A ilustração superior esquerda acima mostra os dois retângulos.
///
/// <H>Recorte em contêineres aninhados</H>
/// O exemplo a seguir ilustra como os contêineres aninhados lidam com o recorte
/// regiões. O código cria um contêiner dentro de um objeto <A>TGdipGraphics</A>. O
/// região de recorte do objeto <A>TGdipGraphics</A> é um retângulo, e o
/// a região de recorte do contêiner é uma elipse. O código faz duas chamadas para
/// o método <A>DrawLine</A>. A primeira chamada para <A>DrawLine</A> está dentro do
/// container, e a segunda chamada para <A>DrawLine</A> está fora do container
/// (após a chamada para <A>EndContainer</A>). A primeira linha é cortada pelo
/// interseção das duas regiões de recorte. A segunda linha é cortada apenas por
/// a região de recorte retangular do objeto <A>TGdipGraphics</A>.

procedure TDemoNestedContainers.Example2;
var
   Container: TGdipGraphicsContainer;
   RedPen, BluePen: TGdipPen;
   AquaBrush, GreenBrush: TGdipBrush;
   Path: TGdipGraphicsPath;
   Region: TGdipRegion;
begin
   RedPen := TGdipPen.Create(TGdipColor.Red, 2);
   BluePen := TGdipPen.Create(TGdipColor.Blue, 2);
   AquaBrush := TGdipSolidBrush.Create(TGdipColor.FromArgb(255, 180, 255, 255));
   GreenBrush := TGdipSolidBrush.Create(TGdipColor.FromArgb(255, 150, 250, 130));

   Graphics.SetClip(TRectangle.Create(250, 65, 150, 120));
   Graphics.FillRectangle(AquaBrush, 250, 65, 150, 120);

   Container := Graphics.BeginContainer;

   // Crie um caminho que consista em uma única elipse.
   Path := TGdipGraphicsPath.Create;
   Path.AddEllipse(275, 50, 100, 150);

   // Construa uma região com base no caminho.
   Region := TGdipRegion.Create(Path);
   Graphics.FillRegion(GreenBrush, Region);

   Graphics.Clip := Region;
   Graphics.DrawLine(RedPen, 250, 0, 550, 300);
   Graphics.EndContainer(Container);

   Graphics.DrawLine(BluePen, 270, 0, 570, 300);

   Region.Free();
   Path.Free();
   GreenBrush.Free();
   AquaBrush.Free();
   BluePen.Free();
   RedPen.Free();
end;

/// Como mostram as ilustrações acima, as transformações e regiões de recorte são
/// cumulativo em contêineres aninhados. Se você definir as transformações mundiais do
/// container e o objeto <A>TGdipGraphics</A>, ambas as transformações serão aplicadas
/// para itens extraídos de dentro do contêiner. A transformação do
/// o contêiner será aplicado primeiro, e a transformação do
/// O objeto <A>TGdipGraphics</A> será aplicado em segundo lugar. Se você definir o recorte
/// regiões do container e do objeto <A>TGdipGraphics</A>, itens extraídos de
/// dentro do contêiner será cortado pela interseção dos dois recortes
/// regiões.
///
/// <H>Configurações de qualidade em contêineres aninhados</H>
/// Configurações de qualidade (<A>SmoothingMode</A>, <A>TextRenderingHint</A> e o
/// like) em contêineres aninhados não são cumulativos; em vez disso, as configurações de qualidade
/// do contêiner substitui temporariamente as configurações de qualidade de um
/// Objeto <A>TGdipGraphics</A>. Quando você cria um novo contêiner, a qualidade
/// as configurações desse contêiner são definidas com valores padrão. Por exemplo, suponha
/// você tem um objeto <A>TGdipGraphics</A> com um modo de suavização de
/// <A>SmoothingModeAntiAlias</A>. Ao criar um contêiner, a suavização
/// modo dentro do contêiner é o modo de suavização padrão. Você é livre para definir
/// o modo de suavização do contêiner e quaisquer itens extraídos de dentro do
/// o container será desenhado de acordo com o modo que você definiu. Itens sorteados após o
/// chamada para <A>EndContainer</A> será desenhada de acordo com o modo de suavização
/// (SmoothingModeAntiAlias) que estava em vigor antes da chamada para
/// <A>BeginContainer</A>.
///
/// <H>Várias camadas de contêineres aninhados</H>
/// Você não está limitado a um contêiner em um objeto <A>TGdipGraphics</A>. Você pode
/// cria uma sequência de contêineres, cada um aninhado no anterior, e você pode
/// especifica a transformação mundial, região de recorte e configurações de qualidade de
/// cada um desses contêineres aninhados. Se você chamar um método de desenho de dentro
/// o contêiner mais interno, as transformações serão aplicadas em ordem,
/// começando com o contêiner mais interno e terminando com o mais externo
///contêiner. Os itens retirados de dentro do contêiner mais interno serão cortados
/// pela interseção de todas as regiões de recorte.
///
/// O exemplo a seguir define a dica de renderização de texto do <A>TGdipGraphics</A>
/// objeto para <A>TextRenderingHintAntiAlias</A>. O código cria dois
/// containers, um aninhado dentro do outro. A dica de renderização de texto do
/// o contêiner externo é definido como <A>TextRenderingHintSingleBitPerPixel</A> e o
/// a dica de renderização de texto do contêiner interno é definida como
/// <A>TextRenderingHintAntiAlias</A>. O código desenha três strings: uma de
/// do contêiner interno, um do contêiner externo e um do contêiner externo
/// objeto <A>TGdipGraphics</A> em si.

procedure TDemoNestedContainers.Example3;
var
   InnerContainer,
   OuterContainer: TGdipGraphicsContainer;
   Brush: TGdipBrush;
   Family: TGdipFontFamily;
   Font: TGdipFont;
begin
   Brush := TGdipSolidBrush.Create(TGdipColor.Blue);
   Family := TGdipFontFamily.Create('Times New Roman');
   Font := TGdipFont.Create(Family, 36, TGdipFontStyle.Regular, TGdipGraphicsUnit.Pixel);

   Graphics.TextRenderingHint := TGdipTextRenderingHint.AntiAlias;

   OuterContainer := Graphics.BeginContainer();
         Graphics.TextRenderingHint := TGdipTextRenderingHint.SingleBitPerPixel;

         InnerContainer := Graphics.BeginContainer();
               Graphics.TextRenderingHint := TGdipTextRenderingHint.AntiAlias;
               Graphics.DrawString('Contêiner Interno', Font, Brush, TPointF.Create(20, 210));
         Graphics.EndContainer(InnerContainer);

         Graphics.DrawString('Contêiner Externo', Font, Brush, TPointF.Create(20, 250));
   Graphics.EndContainer(OuterContainer);

   Graphics.DrawString('Objeto gráfico', Font, Brush, TPointF.Create(20, 290));


   Font.Free();
   Family.Free();
   Brush.Free();
end;

/// A última ilustração acima das três strings. As cordas extraídas do
/// contêiner interno e o objeto <A>TGdipGraphics</A> são suavizados por
/// antialiasing. O barbante retirado do recipiente externo não é alisado por
/// antialiasing por causa do <A>TextRenderingHintSingleBitPerPixel</A>
/// contexto.
{$ENDREGION}

procedure TDemoNestedContainers.Run;
begin
  Example1();
  Graphics.ResetTransform();
  Example2();
  Graphics.ResetClip();
  Example3();
end;

initialization
  RegisterDemo('Usando contêineres gráficos\Contêineres gráficos aninhados', TDemoNestedContainers);

end.
