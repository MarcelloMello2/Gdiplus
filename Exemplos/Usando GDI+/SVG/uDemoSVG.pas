unit uDemoSVG;

interface

uses
   Se7e.Drawing,
   uDemo;

type
  TDemoSVG = class(TDemo)
  strict protected
    procedure Run; override;
  end;

implementation

{$REGION}
procedure TDemoSVG.Run;
var
  Pen: TGdipPen;
begin
  Pen := TGdipPen.Create(TGdipColor.FromArgb(255, 0, 0, 255));
  Graphics.DrawLine(Pen, 0, 0, 200, 100);
  Pen.Free();
end;
{$ENDREGION}

initialization
  RegisterDemo('SVG\Primeiros testes', TDemoSVG);

end.
