unit uDemoCustomDashedLine;

interface

uses
   Se7e.Drawing,
   Se7e.Drawing.Gdiplus.Types,
   uDemo;

type
  TDemoCustomDashedLine = class(TDemo)
  strict protected
    procedure Run; override;
  end;

implementation

{$REGION}
/// O GDI+ do Microsoft Windows fornece vários estilos de traço que estão listados na
/// enumeração <A>TGdipDashStyle</A>. Se esses estilos de traço padrão não atenderem às suas
/// necessidades, você pode criar um padrão de traço personalizado.
///
/// Para desenhar uma linha tracejada personalizada, coloque os comprimentos dos traços e espaços em um
/// array e passe o array para a propriedade <A>DashPattern</A>
/// de um objeto <A>TGdipPen</A>. O exemplo a seguir desenha uma linha tracejada personalizada
/// baseada no array [5, 2, 15, 4]. Se você multiplicar os elementos do array
/// pela largura da caneta de 5, você obtém [25, 10, 75, 20].
/// Os traços exibidos alternam em comprimento entre 25 e 75, e os espaços
/// alternam em comprimento entre 10 e 20.

procedure TDemoCustomDashedLine.Run;
const
  DashValues: TArray<Single> = [5, 2, 15, 4];
var
  BlackPen: TGdipPen;
begin
  BlackPen := TGdipPen.Create(TGdipColor.FromArgb(255, 0, 0, 0), 5);
  BlackPen.DashPattern := DashValues;
  Graphics.DrawLine(BlackPen, TPoint.Create(5, 5), TPoint.Create(405, 5));
  BlackPen.Free();
end;

/// Observe que o último traço deve ser menor que 25 unidades para que a linha
/// possa terminar em (405, 5).
{$ENDREGION}

initialization
  RegisterDemo('Usando a caneta para desenhar linhas e formas\Desenhando uma linha tracejada personalizada', TDemoCustomDashedLine);

end.
