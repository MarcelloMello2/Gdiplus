unit uDemoAntialiasing;

interface

uses
   System.Types,
   Se7e.Drawing,
   Se7e.Drawing.Gdiplus.Types,
   uDemo;

type
  TDemoAntialiasing = class(TDemo)
  strict protected
    procedure Run; override;
  end;

implementation

{ TDemoAntialiasing }

{$REGION}
/// GDI+ 1.1 oferece suporte a um modo de suavização adicional chamado
/// <A>SmoothingModeAntiAlias8x8</A>. Este é o antialiasing da mais alta qualidade
/// modo que produz melhor qualidade especialmente para linhas quase horizontais
/// e bordas.

procedure TDemoAntialiasing.Run;
const
  SmoothingModes: array [TGdipSmoothingMode] of String = (
    'SmoothingModeInvalid', 'SmoothingModeDefault', 'SmoothingModeHighSpeed', 'SmoothingModeHighQuality',
    'SmoothingModeNone', 'SmoothingModeAntiAlias8x4', 'SmoothingModeAntiAlias8x8');
var
   SmoothingMode: TGdipSmoothingMode;
   Font: TGdipFont;
   BlackBrush,
   BlueBrush: TGdipBrush;
   Y: Integer;
   Points: TArray<TPoint>;
begin
   Font := TGdipFont.Create('Arial', 18, TGdipFontStyle.Regular, TGdipGraphicsUnit.Pixel);
   BlackBrush := TGdipSolidBrush.Create(TGdipColor.Black);
   BlueBrush := TGdipSolidBrush.Create(TGdipColor.Blue);
   Graphics.Clear(TGdipColor.White);

   Y := 0;
   for SmoothingMode := TGdipSmoothingMode.Default to TGdipSmoothingMode.AntiAlias8x8 do
   begin
      Graphics.SmoothingMode := SmoothingMode;

      Graphics.DrawString(SmoothingModes[SmoothingMode], Font, BlackBrush, TPointF.Create(5, Y + 25));

      Points :=
      [
         TPoint.Create(250, Y),
         TPoint.Create(250, Y + 60),
         TPoint.Create(260, Y + 60)
      ];
      Graphics.FillPolygon(BlueBrush, Points);

      Points :=
      [
         TPoint.Create(270, Y + 40),
         TPoint.Create(360, Y + 40),
         TPoint.Create(360, Y + 35)
      ];
      Graphics.FillPolygon(BlueBrush, Points);

      Graphics.FillEllipse(BlueBrush, 380, Y, 200, 60);
      Inc(Y, 70);
   end;

   BlueBrush.Free();
   BlackBrush.Free();
   Font.Free();
end;

/// Na ilustração acima você pode ver que <A>SmoothingModeAntiAlias8x8</A>
/// produz uma renderização ligeiramente melhor do longo triângulo plano no
/// linha inferior.
{$ENDREGION}

initialization
  RegisterDemo('Melhorias\Opções adicionais de antialiasing', TDemoAntialiasing);

end.
