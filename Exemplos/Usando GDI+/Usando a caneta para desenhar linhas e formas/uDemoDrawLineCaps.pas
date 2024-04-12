unit uDemoDrawLineCaps;

interface

uses
   Se7e.Drawing,
   Se7e.Drawing.Gdiplus.Types,
   uDemo;

type
  TDemoDrawLineCaps = class(TDemo)
  strict protected
    procedure Run; override;
  end;

implementation

{$REGION}
/// Você pode desenhar o início ou o fim de uma linha em uma das várias formas chamadas
/// terminações de linha. O GDI+ do Microsoft Windows suporta várias terminações de linha,
/// como redonda, quadrada, diamante e ponta de flecha.
///
/// Você pode especificar as terminações de linha para o início de uma linha (capa inicial),
/// o fim de uma linha (capa final) ou os traços de uma linha tracejada (capa de traço).
///
/// O exemplo a seguir desenha uma linha com uma ponta de flecha em uma extremidade e uma
/// capa redonda na outra extremidade:

procedure TDemoDrawLineCaps.Run;
var
  Pen: TGdipPen;
begin
  Pen := TGdipPen.Create(TGdipColor.FromArgb(255, 0, 0,255), 8);
  Pen.StartCap := TGdipLineCap.ArrowAnchor;
  Pen.EndCap := TGdipLineCap.RoundAnchor;
  Graphics.DrawLine(Pen, 20, 175, 300, 175);
  Pen.Free();
end;

/// <B>TGdipLineCap.ArrowAnchor</B> e <B>TGdipLineCap.RoundAnchor</B> são elementos da
/// enumeração <A>TGdipLineCap.</A>.
{$ENDREGION}

initialization
  RegisterDemo('Usando a caneta para desenhar linhas e formas\Desenhando uma linha com terminações de linha', TDemoDrawLineCaps);

end.
