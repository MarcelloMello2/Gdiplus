// Marcelo Melo
// 06/04/2024

unit Se7e.Drawing;

{$SCOPEDENUMS ON}
{$ZEROBASEDSTRINGS ON}

{$IFDEF FPC}
  {$MODE DELPHI}
{$ENDIF}

interface

uses
  System.Types,
  Se7e.Drawing.Gdiplus.Graphics,
  Se7e.Drawing.Gdiplus.Types,
  Se7e.Drawing.Gdiplus.Utils,
  Se7e.Drawing.Gdiplus.Colors,
  Se7e.Drawing.Rectangle;

type


   // GDI+ types alias
   TGdipPen = Se7e.Drawing.Gdiplus.Graphics.TGdipPen;
   TGdipColor = Se7e.Drawing.Gdiplus.Colors.TGdipColor;
   TGdipSolidBrush = Se7e.Drawing.Gdiplus.Graphics.TGdipSolidBrush;
   TGdipFontFamily = Se7e.Drawing.Gdiplus.Graphics.TGdipFontFamily;
   TGdipFont = Se7e.Drawing.Gdiplus.Graphics.TGdipFont;
   TGdipGraphicsPath = Se7e.Drawing.Gdiplus.Graphics.TGdipGraphicsPath;
   TGdipImage = Se7e.Drawing.Gdiplus.Graphics.TGdipImage;
   TGdipTextureBrush = Se7e.Drawing.Gdiplus.Graphics.TGdipTextureBrush;
   TGdipHatchBrush = Se7e.Drawing.Gdiplus.Graphics.TGdipHatchBrush;
   TGdipMatrix = Se7e.Drawing.Gdiplus.Graphics.TGdipMatrix;
   TGdipBitmap = Se7e.Drawing.Gdiplus.Graphics.TGdipBitmap;
   TGdipCachedBitmap = Se7e.Drawing.Gdiplus.Graphics.TGdipCachedBitmap;
   TGdipImageFormat = Se7e.Drawing.Gdiplus.Graphics.TGdipImageFormat;
   TGdipMetafile = Se7e.Drawing.Gdiplus.Graphics.TGdipMetafile;
   TGdipGraphics = Se7e.Drawing.Gdiplus.Graphics.TGdipGraphics;
   TGdipEncoderParameters = Se7e.Drawing.Gdiplus.Graphics.TGdipEncoderParameters;
   TGdipEncoderParameter = Se7e.Drawing.Gdiplus.Graphics.TGdipEncoderParameter;
   TGdipFrameDimension = Se7e.Drawing.Gdiplus.Graphics.TGdipFrameDimension;
   TGdipEncoder = Se7e.Drawing.Gdiplus.Graphics.TGdipEncoder;
   TGdipImageCodecInfo = Se7e.Drawing.Gdiplus.Graphics.TGdipImageCodecInfo;
   TGdipColorMatrix = Se7e.Drawing.Gdiplus.Graphics.TGdipColorMatrix;
   TGdipImageAttributes = Se7e.Drawing.Gdiplus.Graphics.TGdipImageAttributes;
   TGdipColorMatrixFlag = Se7e.Drawing.Gdiplus.Types.TGdipColorMatrixFlag;
   TGdipBrush = Se7e.Drawing.Gdiplus.Graphics.TGdipBrush;
   TGdipStringFormat = Se7e.Drawing.Gdiplus.Graphics.TGdipStringFormat;
   TGdipFontCollection = Se7e.Drawing.Gdiplus.Graphics.TGdipFontCollection;
   TGdipInstalledFontCollection = Se7e.Drawing.Gdiplus.Graphics.TGdipInstalledFontCollection;
   TGdipLinearGradientBrush = Se7e.Drawing.Gdiplus.Graphics.TGdipLinearGradientBrush;
   TGdipBlend = Se7e.Drawing.Gdiplus.Graphics.TGdipBlend;
   TGdipPathGradientBrush = Se7e.Drawing.Gdiplus.Graphics.TGdipPathGradientBrush;
   TGdipColorBlend = Se7e.Drawing.Gdiplus.Graphics.TGdipColorBlend;
   TGdipRegion = Se7e.Drawing.Gdiplus.Graphics.TGdipRegion;
   TGdipGraphicsContainer = Se7e.Drawing.Gdiplus.Graphics.TGdipGraphicsContainer;
   TGdipColorMap = Se7e.Drawing.Gdiplus.Graphics.TGdipColorMap;
   TGdipColorPalette = Se7e.Drawing.Gdiplus.Graphics.TGdipColorPalette;
   TGdipBitmapHistogram = Se7e.Drawing.Gdiplus.Graphics.TGdipBitmapHistogram;

   TRectangle = Se7e.Drawing.Rectangle.TRectangle;
   TRectangleF = Se7e.Drawing.Rectangle.TRectangleF;


   // System types alias
   TPointF = System.Types.TPointF;
   TPoint = System.Types.TPoint;


implementation

end.
