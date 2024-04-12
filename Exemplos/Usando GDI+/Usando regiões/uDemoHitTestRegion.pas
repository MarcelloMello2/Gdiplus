unit uDemoHitTestRegion;

interface

uses
   Types,
   Se7e.Drawing,
   Se7e.Drawing.Gdiplus.Types,
   uDemo;

type
  TDemoHitTestRegion = class(TDemo)
  strict protected
    procedure Run; override;
  end;

implementation

{ TDemoHitTestRegion }

{$REGION}
/// A interface Microsoft Windows GDI+ <A>TGdipRegion</A> permite definir um
/// forma personalizada. A forma pode ser composta de linhas, polígonos e curvas.
///
/// Dois usos comuns para regiões são testes de acesso e recorte. O teste de acerto é
/// determinar se o mouse foi clicado em determinada região da tela.
/// Clipping restringe o desenho a uma determinada região.
///
/// O objetivo do teste de acerto é determinar se o cursor está sobre um
/// determinado objeto, como um ícone ou um botão. O exemplo a seguir cria um
/// região em forma de plus formando a união de duas regiões retangulares. Presumir
/// que o parâmetro <I>MousePoint</I> contém a localização do mais recente
/// clique. O código verifica se <I>MousePoint</I> está no
/// região em forma de plus. Se <I>MousePoint</I> estiver na região (um hit), o
/// a região é preenchida com um pincel vermelho opaco. Caso contrário, a região é preenchida
/// com um pincel vermelho semitransparente.

procedure TDemoHitTestRegion.Run;

  procedure HitTest(const RegionOffset, MousePoint: TPoint);
  var
    Brush: TGdipSolidBrush;
    Region1,
    Region2: TGdipRegion;
  begin
    Brush := TGdipSolidBrush.Create(TGdipColor.FromArgb(0));
    // Crie uma região em forma de sinal de adição formando a união da Região1 e da Região2.
    Region1 := TGdipRegion.Create(TRectangle.Create(RegionOffset.X + 50, RegionOffset.Y, 50, 150));
    Region2 := TGdipRegion.Create(TRectangle.Create(RegionOffset.X, RegionOffset.Y + 50, 150, 50));
    // A união substitui a Região1.
    Region1.Union(Region2);

    if (Region1.IsVisible(MousePoint, Graphics)) then
      Brush.Color := TGdipColor.FromArgb(255, 255, 0, 0)
    else
      Brush.Color := TGdipColor.FromArgb(64, 255, 0, 0);
    Graphics.FillRegion(Brush, Region1);

    // Desenhe MousePoint para referência
    Brush.Color := TGdipColor.Blue;
    Graphics.FillRectangle(Brush, MousePoint.X - 2, MousePoint.Y - 2, 5, 5);

    Region2.Free();
    Region1.Free();
    Brush.Free();
  end;

begin
  HitTest(TPoint.Create(0, 0), TPoint.Create(60, 10));
  HitTest(TPoint.Create(200, 0), TPoint.Create(220, 20));
end;
{$ENDREGION}

initialization
  RegisterDemo('Usando regiões\Teste de sucesso com uma região', TDemoHitTestRegion);

end.
