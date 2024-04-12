unit uDemoClipRegion;

interface

uses
   Types,
   Se7e.Drawing,
   Se7e.Drawing.Gdiplus.Types,
   uDemo;

type
  TDemoClipRegion = class(TDemo)
  strict protected
    procedure Run; override;
  end;

implementation

{ TDemoClipRegion }

{$REGION}
/// Uma das propriedades da interface <A>TGdipGraphics</A> é o recorte
/// região. Todo desenho feito por um determinado objeto <A>TGdipGraphics</A> é restrito a
/// a região de recorte desse objeto <A>TGdipGraphics</A>. Você pode definir o
/// recorte a região chamando o método <A>SetClip</A> ou definindo o
/// Propriedade <A>Clip</A>.
///
/// O exemplo a seguir constrói um caminho que consiste em um único polígono.
/// Então o código constrói uma região baseada nesse caminho. A região é
/// atribuído à propriedade <A>Clip</A> do objeto <A>TGdipGraphics</A>, e
/// então duas strings são desenhadas.

procedure TDemoClipRegion.Run;
var
  Path: TGdipGraphicsPath;
  Region: TGdipRegion;
  Pen: TGdipPen;
  Font: TGdipFont;
  Brush: TGdipBrush;
begin
   var PolyPoints: TArray<TPoint> :=
   [
      TPoint.Create(10, 10),
      TPoint.Create(150, 10),
      TPoint.Create(100, 75),
      TPoint.Create(100, 150)
   ];

  Path := TGdipGraphicsPath.Create;
  Path.AddPolygon(PolyPoints);
  Region := TGdipRegion.Create(Path);
  Pen := TGdipPen.Create(TGdipColor.Black);
  Graphics.DrawPath(Pen, Path);

  Graphics.Clip := Region;
  Font := TGdipFont.Create('Arial', 36, TGdipFontStyle.Bold, TGdipGraphicsUnit.Pixel);
  Brush := TGdipSolidBrush.Create(TGdipColor.Red);
  Graphics.DrawString('Uma região de recorte', Font, Brush, TPointF.Create(15, 25));
  Graphics.DrawString('Uma região de recorte', Font, Brush, TPointF.Create(15, 68));

  Brush.Free();
  Font.Free();
  Pen.Free();
  Region.Free();
  Path.Free();
end;

/// A ilustração acima mostra as strings cortadas.
{$ENDREGION}

initialization
  RegisterDemo('Usando regiões\Recortando com uma região', TDemoClipRegion);

end.
