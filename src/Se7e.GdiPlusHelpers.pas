unit Se7e.GdiPlusHelpers;

interface

uses
  Windows,
  Graphics,
  Controls,
  Se7e.Drawing.Gdiplus.Graphics;

type
  TGPCanvasHelper = class helper for TCanvas
  public
    function ToGPGraphics: TGdipGraphics;
  end;

type
  TGPGraphicControlHelper = class helper for TGraphicControl
  public
    function ToGPGraphics: TGdipGraphics;
  end;

type
  TGPCustomControlHelper = class helper for TCustomControl
  public
    function ToGPGraphics: TGdipGraphics;
  end;

type
  TGPBitmapHelper = class helper for Graphics.TBitmap
  public
    function ToGPBitmap: TGdipBitmap;
    procedure FromGPBitmap(const GPBitmap: TGdipBitmap);
  end;

implementation

{ TGPCanvasHelper }

function TGPCanvasHelper.ToGPGraphics: TGdipGraphics;
begin
  Result := TGdipGraphics.FromHdc(Handle);
end;

{ TGPGraphicControlHelper }

function TGPGraphicControlHelper.ToGPGraphics: TGdipGraphics;
begin
  Result := TGdipGraphics.FromHdc(Canvas.Handle);
end;

{ TGPCustomControlHelper }

function TGPCustomControlHelper.ToGPGraphics: TGdipGraphics;
begin
  Result := TGdipGraphics.FromHdc(Canvas.Handle);
end;

{ TGPBitmapHelper }

procedure TGPBitmapHelper.FromGPBitmap(const GPBitmap: TGdipBitmap);
begin
  Handle := GPBitmap.GetHbitmap();
end;

function TGPBitmapHelper.ToGPBitmap: TGdipBitmap;
begin
  if (PixelFormat in [pf1Bit, pf4Bit, pf8Bit]) then
    Result := TGdipBitmap.Create(Handle, Palette)
  else
    Result := TGdipBitmap.Create(Handle, 0);
end;

end.
