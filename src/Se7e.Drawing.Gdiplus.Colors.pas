// Marcelo Melo
// 23/03/2024

unit Se7e.Drawing.Gdiplus.Colors;

{$REGION 'Compiler Directives'}

{$SCOPEDENUMS ON}
{$ZEROBASEDSTRINGS ON}
{$ALIGN 8}
{$MINENUMSIZE 4}

{$IFDEF MSWINDOWS}
   {$DEFINE FEATURE_WINDOWS_SYSTEM_COLORS}
{$ENDIF MSWINDOWS}

{$ENDREGION 'Compiler Directives'}

{$IFDEF FPC}
  {$MODE DELPHI}
{$ENDIF}

interface

{$REGION 'Uses declarations'}

uses
   SysUtils,
   Classes,
   Character,
   Generics.Collections,
   Windows,
   Se7e.Span;

{$ENDREGION 'Uses declarations'}

type

{$REGION 'Type redefinitions'}

//  ARGB = UInt32;
//  ARGB64 = UInt64;
//  PARGB = ^ARGB;
//  PARGB64 = ^ARGB64;

{$ENDREGION 'Type redefinitions'}

{$REGION 'TGdipKnownColor'}

   TGdipKnownColor = (
      // This enum is order dependent!!!
      //
      // The value of these known colors are indexes into a color array.
      // Do not modify this enum without updating TGdipKnownColorTable.

      InvalidNotKnownColor = 0,

      // "System" colors, Part 1
      ActiveBorder = 1,
      ActiveCaption,
      ActiveCaptionText,
      AppWorkspace,
      Control,
      ControlDark,
      ControlDarkDark,
      ControlLight,
      ControlLightLight,
      ControlText,
      Desktop,
      GrayText,
      Highlight,
      HighlightText,
      HotTrack,
      InactiveBorder,
      InactiveCaption,
      InactiveCaptionText,
      Info,
      InfoText,
      Menu,
      MenuText,
      ScrollBar,
      Window,
      WindowFrame,
      WindowText,

      // "Web" Colors, Part 1
      Transparent,
      AliceBlue,
      AntiqueWhite,
      Aqua,
      Aquamarine,
      Azure,
      Beige,
      Bisque,
      Black,
      BlanchedAlmond,
      Blue,
      BlueViolet,
      Brown,
      BurlyWood,
      CadetBlue,
      Chartreuse,
      Chocolate,
      Coral,
      CornflowerBlue,
      Cornsilk,
      Crimson,
      Cyan,
      DarkBlue,
      DarkCyan,
      DarkGoldenrod,
      DarkGray,
      DarkGreen,
      DarkKhaki,
      DarkMagenta,
      DarkOliveGreen,
      DarkOrange,
      DarkOrchid,
      DarkRed,
      DarkSalmon,
      DarkSeaGreen,
      DarkSlateBlue,
      DarkSlateGray,
      DarkTurquoise,
      DarkViolet,
      DeepPink,
      DeepSkyBlue,
      DimGray,
      DodgerBlue,
      Firebrick,
      FloralWhite,
      ForestGreen,
      Fuchsia,
      Gainsboro,
      GhostWhite,
      Gold,
      Goldenrod,
      Gray,
      Green,
      GreenYellow,
      Honeydew,
      HotPink,
      IndianRed,
      Indigo,
      Ivory,
      Khaki,
      Lavender,
      LavenderBlush,
      LawnGreen,
      LemonChiffon,
      LightBlue,
      LightCoral,
      LightCyan,
      LightGoldenrodYellow,
      LightGray,
      LightGreen,
      LightPink,
      LightSalmon,
      LightSeaGreen,
      LightSkyBlue,
      LightSlateGray,
      LightSteelBlue,
      LightYellow,
      Lime,
      LimeGreen,
      Linen,
      Magenta,
      Maroon,
      MediumAquamarine,
      MediumBlue,
      MediumOrchid,
      MediumPurple,
      MediumSeaGreen,
      MediumSlateBlue,
      MediumSpringGreen,
      MediumTurquoise,
      MediumVioletRed,
      MidnightBlue,
      MintCream,
      MistyRose,
      Moccasin,
      NavajoWhite,
      Navy,
      OldLace,
      Olive,
      OliveDrab,
      Orange,
      OrangeRed,
      Orchid,
      PaleGoldenrod,
      PaleGreen,
      PaleTurquoise,
      PaleVioletRed,
      PapayaWhip,
      PeachPuff,
      Peru,
      Pink,
      Plum,
      PowderBlue,
      Purple,
      Red,
      RosyBrown,
      RoyalBlue,
      SaddleBrown,
      Salmon,
      SandyBrown,
      SeaGreen,
      SeaShell,
      Sienna,
      Silver,
      SkyBlue,
      SlateBlue,
      SlateGray,
      Snow,
      SpringGreen,
      SteelBlue,
      Tan,
      Teal,
      Thistle,
      Tomato,
      Turquoise,
      Violet,
      Wheat,
      White,
      WhiteSmoke,
      Yellow,
      YellowGreen,

      // "System" colors, Part 2
      ButtonFace,
      ButtonHighlight,
      ButtonShadow,
      GradientActiveCaption,
      GradientInactiveCaption,
      MenuBar,
      MenuHighlight,

      // "Web" colors, Part 2
      /// <summary>
      /// A system defined color representing the ARGB value <c>#663399</c>.
      /// </summary>
      RebeccaPurple
   );

{$ENDREGION 'TGdipKnownColor'}

{$REGION 'TGdipKnownColorHelper'}

   { TGdipKnownColorHelper }

   TGdipKnownColorHelper = record helper for TGdipKnownColor
      public function ToString(): string;
   end;

{$ENDREGION 'TGdipKnownColorHelper'}

{$REGION 'TGdipColor'}

  TGdipColor = record
     strict private type

         { TGdipColorState }

         TGdipColorState = type Int16;

        // NOTE : The "zero" pattern (all members being 0) must represent
        //      : "not set". This allows "TGdipColor c;" to be correct.
         TGdipColorStateHelper = record helper for TGdipColorState
            const StateKnownColorValid   = Int16($0001);
            const StateARGBValueValid    = Int16($0002);
            const StateValueMask         = Int16(StateARGBValueValid);
            const StateNameValid         = Int16($0008);
            const NotDefinedValue: Int64 = 0;
         end;

      // Standard 32bit sRGB (ARGB)
      strict private m_value: Int64;

      // State flags.
      strict private m_state: TGdipColorState;

      // Ignored, unless "m_state" says it is valid
      strict private m_knownColor: Int16;

      // User supplied m_name of color. Will not be filled in if
      // we map to a "knowncolor"
      strict private m_name: string;

      strict private class constructor CreateClass();

      strict private function GetA: Byte;
//      strict private procedure SetAlpha(const Value: Byte);
      strict private function GetR: Byte;
//      strict private procedure SetRed(const Value: Byte);
      strict private function GetG: Byte;
//      strict private procedure SetGreen(const Value: Byte);
      strict private function GetB: Byte;
//      strict private procedure SetBlue(const Value: Byte);
//      strict private function GetColorRef: TColorRef;
      strict private function GetValue(): Int64;
      strict private property Value: Int64 read GetValue;
//      strict private class function GetEmpty(): TGdipColor; static;
      strict private function GetIsSystemColor(): Boolean;
      strict private function GetIsKnownColor(): Boolean;
      strict private class function FromArgb(const argb: UInt32): TGdipColor; overload; static;

      strict private class procedure CheckByte(const value: Integer; const name: string); static;

      strict private constructor Create(const value: Int64; const state: TGdipColorState; const name: string; const knownColor: TGdipKnownColor); overload;
      strict private constructor Create(const knownColor: TGdipKnownColor); overload;
      strict private function GetIsEmpty(): Boolean;
      strict private function GetIsNamedColor(): Boolean;
      strict private function GetName(): string;

      // Shift count and bit mask for A, R, G, B components
      private const ARGBAlphaShift = 24;
      private const ARGBRedShift   = 16;
      private const ARGBGreenShift = 8;
      private const ARGBBlueShift  = 0;

      private const ARGBAlphaMask  = $FF000000;
      private const ARGBRedMask    = $00FF0000;
      private const ARGBGreenMask  = $0000FF00;
      private const ARGBBlueMask   = $000000FF;

      public class var Empty: TGdipColor;

      // -------------------------------------------------------------------
      //  static list of "web" colors...
      //
      public class var Transparent: TGdipColor;  //  = TGdipColor(TGdipKnownColor.Transparent);
      public class var AliceBlue: TGdipColor;  //  = TGdipColor(TGdipKnownColor.AliceBlue);
      public class var AntiqueWhite: TGdipColor;  //  = TGdipColor(TGdipKnownColor.AntiqueWhite);
      public class var Aqua: TGdipColor;  //  = TGdipColor(TGdipKnownColor.Aqua);
      public class var Aquamarine: TGdipColor;  //  = TGdipColor(TGdipKnownColor.Aquamarine);
      public class var Azure: TGdipColor;  //  = TGdipColor(TGdipKnownColor.Azure);
      public class var Beige: TGdipColor;  //  = TGdipColor(TGdipKnownColor.Beige);
      public class var Bisque: TGdipColor;  //  = TGdipColor(TGdipKnownColor.Bisque);
      public class var Black: TGdipColor;  //  = TGdipColor(TGdipKnownColor.Black);
      public class var BlanchedAlmond: TGdipColor;  //  = TGdipColor(TGdipKnownColor.BlanchedAlmond);
      public class var Blue: TGdipColor;  //  = TGdipColor(TGdipKnownColor.Blue);
      public class var BlueViolet: TGdipColor;  //  = TGdipColor(TGdipKnownColor.BlueViolet);
      public class var Brown: TGdipColor;  //  = TGdipColor(TGdipKnownColor.Brown);
      public class var BurlyWood: TGdipColor;  //  = TGdipColor(TGdipKnownColor.BurlyWood);
      public class var CadetBlue: TGdipColor;  //  = TGdipColor(TGdipKnownColor.CadetBlue);
      public class var Chartreuse: TGdipColor;  //  = TGdipColor(TGdipKnownColor.Chartreuse);
      public class var Chocolate: TGdipColor;  //  = TGdipColor(TGdipKnownColor.Chocolate);
      public class var Coral: TGdipColor;  //  = TGdipColor(TGdipKnownColor.Coral);
      public class var CornflowerBlue: TGdipColor;  //  = TGdipColor(TGdipKnownColor.CornflowerBlue);
      public class var Cornsilk: TGdipColor;  //  = TGdipColor(TGdipKnownColor.Cornsilk);
      public class var Crimson: TGdipColor;  //  = TGdipColor(TGdipKnownColor.Crimson);
      public class var Cyan: TGdipColor;  //  = TGdipColor(TGdipKnownColor.Cyan);
      public class var DarkBlue: TGdipColor;  //  = TGdipColor(TGdipKnownColor.DarkBlue);
      public class var DarkCyan: TGdipColor;  //  = TGdipColor(TGdipKnownColor.DarkCyan);
      public class var DarkGoldenrod: TGdipColor;  //  = TGdipColor(TGdipKnownColor.DarkGoldenrod);
      public class var DarkGray: TGdipColor;  //  = TGdipColor(TGdipKnownColor.DarkGray);
      public class var DarkGreen: TGdipColor;  //  = TGdipColor(TGdipKnownColor.DarkGreen);
      public class var DarkKhaki: TGdipColor;  //  = TGdipColor(TGdipKnownColor.DarkKhaki);
      public class var DarkMagenta: TGdipColor;  //  = TGdipColor(TGdipKnownColor.DarkMagenta);
      public class var DarkOliveGreen: TGdipColor;  //  = TGdipColor(TGdipKnownColor.DarkOliveGreen);
      public class var DarkOrange: TGdipColor;  //  = TGdipColor(TGdipKnownColor.DarkOrange);
      public class var DarkOrchid: TGdipColor;  //  = TGdipColor(TGdipKnownColor.DarkOrchid);
      public class var DarkRed: TGdipColor;  //  = TGdipColor(TGdipKnownColor.DarkRed);
      public class var DarkSalmon: TGdipColor;  //  = TGdipColor(TGdipKnownColor.DarkSalmon);
      public class var DarkSeaGreen: TGdipColor;  //  = TGdipColor(TGdipKnownColor.DarkSeaGreen);
      public class var DarkSlateBlue: TGdipColor;  //  = TGdipColor(TGdipKnownColor.DarkSlateBlue);
      public class var DarkSlateGray: TGdipColor;  //  = TGdipColor(TGdipKnownColor.DarkSlateGray);
      public class var DarkTurquoise: TGdipColor;  //  = TGdipColor(TGdipKnownColor.DarkTurquoise);
      public class var DarkViolet: TGdipColor;  //  = TGdipColor(TGdipKnownColor.DarkViolet);
      public class var DeepPink: TGdipColor;  //  = TGdipColor(TGdipKnownColor.DeepPink);
      public class var DeepSkyBlue: TGdipColor;  //  = TGdipColor(TGdipKnownColor.DeepSkyBlue);
      public class var DimGray: TGdipColor;  //  = TGdipColor(TGdipKnownColor.DimGray);
      public class var DodgerBlue: TGdipColor;  //  = TGdipColor(TGdipKnownColor.DodgerBlue);
      public class var Firebrick: TGdipColor;  //  = TGdipColor(TGdipKnownColor.Firebrick);
      public class var FloralWhite: TGdipColor;  //  = TGdipColor(TGdipKnownColor.FloralWhite);
      public class var ForestGreen: TGdipColor;  //  = TGdipColor(TGdipKnownColor.ForestGreen);
      public class var Fuchsia: TGdipColor;  //  = TGdipColor(TGdipKnownColor.Fuchsia);
      public class var Gainsboro: TGdipColor;  //  = TGdipColor(TGdipKnownColor.Gainsboro);
      public class var GhostWhite: TGdipColor;  //  = TGdipColor(TGdipKnownColor.GhostWhite);
      public class var Gold: TGdipColor;  //  = TGdipColor(TGdipKnownColor.Gold);
      public class var Goldenrod: TGdipColor;  //  = TGdipColor(TGdipKnownColor.Goldenrod);
      public class var Gray: TGdipColor;  //  = TGdipColor(TGdipKnownColor.Gray);
      public class var Green: TGdipColor;  //  = TGdipColor(TGdipKnownColor.Green);
      public class var GreenYellow: TGdipColor;  //  = TGdipColor(TGdipKnownColor.GreenYellow);
      public class var Honeydew: TGdipColor;  //  = TGdipColor(TGdipKnownColor.Honeydew);
      public class var HotPink: TGdipColor;  //  = TGdipColor(TGdipKnownColor.HotPink);
      public class var IndianRed: TGdipColor;  //  = TGdipColor(TGdipKnownColor.IndianRed);
      public class var Indigo: TGdipColor;  //  = TGdipColor(TGdipKnownColor.Indigo);
      public class var Ivory: TGdipColor;  //  = TGdipColor(TGdipKnownColor.Ivory);
      public class var Khaki: TGdipColor;  //  = TGdipColor(TGdipKnownColor.Khaki);
      public class var Lavender: TGdipColor;  //  = TGdipColor(TGdipKnownColor.Lavender);
      public class var LavenderBlush: TGdipColor;  //  = TGdipColor(TGdipKnownColor.LavenderBlush);
      public class var LawnGreen: TGdipColor;  //  = TGdipColor(TGdipKnownColor.LawnGreen);
      public class var LemonChiffon: TGdipColor;  //  = TGdipColor(TGdipKnownColor.LemonChiffon);
      public class var LightBlue: TGdipColor;  //  = TGdipColor(TGdipKnownColor.LightBlue);
      public class var LightCoral: TGdipColor;  //  = TGdipColor(TGdipKnownColor.LightCoral);
      public class var LightCyan: TGdipColor;  //  = TGdipColor(TGdipKnownColor.LightCyan);
      public class var LightGoldenrodYellow: TGdipColor;  //  = TGdipColor(TGdipKnownColor.LightGoldenrodYellow);
      public class var LightGreen: TGdipColor;  //  = TGdipColor(TGdipKnownColor.LightGreen);
      public class var LightGray: TGdipColor;  //  = TGdipColor(TGdipKnownColor.LightGray);
      public class var LightPink: TGdipColor;  //  = TGdipColor(TGdipKnownColor.LightPink);
      public class var LightSalmon: TGdipColor;  //  = TGdipColor(TGdipKnownColor.LightSalmon);
      public class var LightSeaGreen: TGdipColor;  //  = TGdipColor(TGdipKnownColor.LightSeaGreen);
      public class var LightSkyBlue: TGdipColor;  //  = TGdipColor(TGdipKnownColor.LightSkyBlue);
      public class var LightSlateGray: TGdipColor;  //  = TGdipColor(TGdipKnownColor.LightSlateGray);
      public class var LightSteelBlue: TGdipColor;  //  = TGdipColor(TGdipKnownColor.LightSteelBlue);
      public class var LightYellow: TGdipColor;  //  = TGdipColor(TGdipKnownColor.LightYellow);
      public class var Lime: TGdipColor;  //  = TGdipColor(TGdipKnownColor.Lime);
      public class var LimeGreen: TGdipColor;  //  = TGdipColor(TGdipKnownColor.LimeGreen);
      public class var Linen: TGdipColor;  //  = TGdipColor(TGdipKnownColor.Linen);
      public class var Magenta: TGdipColor;  //  = TGdipColor(TGdipKnownColor.Magenta);
      public class var Maroon: TGdipColor;  //  = TGdipColor(TGdipKnownColor.Maroon);
      public class var MediumAquamarine: TGdipColor;  //  = TGdipColor(TGdipKnownColor.MediumAquamarine);
      public class var MediumBlue: TGdipColor;  //  = TGdipColor(TGdipKnownColor.MediumBlue);
      public class var MediumOrchid: TGdipColor;  //  = TGdipColor(TGdipKnownColor.MediumOrchid);
      public class var MediumPurple: TGdipColor;  //  = TGdipColor(TGdipKnownColor.MediumPurple);
      public class var MediumSeaGreen: TGdipColor;  //  = TGdipColor(TGdipKnownColor.MediumSeaGreen);
      public class var MediumSlateBlue: TGdipColor;  //  = TGdipColor(TGdipKnownColor.MediumSlateBlue);
      public class var MediumSpringGreen: TGdipColor;  //  = TGdipColor(TGdipKnownColor.MediumSpringGreen);
      public class var MediumTurquoise: TGdipColor;  //  = TGdipColor(TGdipKnownColor.MediumTurquoise);
      public class var MediumVioletRed: TGdipColor;  //  = TGdipColor(TGdipKnownColor.MediumVioletRed);
      public class var MidnightBlue: TGdipColor;  //  = TGdipColor(TGdipKnownColor.MidnightBlue);
      public class var MintCream: TGdipColor;  //  = TGdipColor(TGdipKnownColor.MintCream);
      public class var MistyRose: TGdipColor;  //  = TGdipColor(TGdipKnownColor.MistyRose);
      public class var Moccasin: TGdipColor;  //  = TGdipColor(TGdipKnownColor.Moccasin);
      public class var NavajoWhite: TGdipColor;  //  = TGdipColor(TGdipKnownColor.NavajoWhite);
      public class var Navy: TGdipColor;  //  = TGdipColor(TGdipKnownColor.Navy);
      public class var OldLace: TGdipColor;  //  = TGdipColor(TGdipKnownColor.OldLace);
      public class var Olive: TGdipColor;  //  = TGdipColor(TGdipKnownColor.Olive);
      public class var OliveDrab: TGdipColor;  //  = TGdipColor(TGdipKnownColor.OliveDrab);
      public class var Orange: TGdipColor;  //  = TGdipColor(TGdipKnownColor.Orange);
      public class var OrangeRed: TGdipColor;  //  = TGdipColor(TGdipKnownColor.OrangeRed);
      public class var Orchid: TGdipColor;  //  = TGdipColor(TGdipKnownColor.Orchid);
      public class var PaleGoldenrod: TGdipColor;  //  = TGdipColor(TGdipKnownColor.PaleGoldenrod);
      public class var PaleGreen: TGdipColor;  //  = TGdipColor(TGdipKnownColor.PaleGreen);
      public class var PaleTurquoise: TGdipColor;  //  = TGdipColor(TGdipKnownColor.PaleTurquoise);
      public class var PaleVioletRed: TGdipColor;  //  = TGdipColor(TGdipKnownColor.PaleVioletRed);
      public class var PapayaWhip: TGdipColor;  //  = TGdipColor(TGdipKnownColor.PapayaWhip);
      public class var PeachPuff: TGdipColor;  //  = TGdipColor(TGdipKnownColor.PeachPuff);
      public class var Peru: TGdipColor;  //  = TGdipColor(TGdipKnownColor.Peru);
      public class var Pink: TGdipColor;  //  = TGdipColor(TGdipKnownColor.Pink);
      public class var Plum: TGdipColor;  //  = TGdipColor(TGdipKnownColor.Plum);
      public class var PowderBlue: TGdipColor;  //  = TGdipColor(TGdipKnownColor.PowderBlue);
      public class var Purple: TGdipColor;  //  = TGdipColor(TGdipKnownColor.Purple);

      /// <summary>
      /// Gets a system-defined color that has an ARGB value of <c>#663399</c>.
      /// </summary>
      /// <value>A system-defined color.</value>
      public class var RebeccaPurple: TGdipColor;  //  = TGdipColor(TGdipKnownColor.RebeccaPurple);
      public class var Red: TGdipColor;  //  = TGdipColor(TGdipKnownColor.Red);
      public class var RosyBrown: TGdipColor;  //  = TGdipColor(TGdipKnownColor.RosyBrown);
      public class var RoyalBlue: TGdipColor;  //  = TGdipColor(TGdipKnownColor.RoyalBlue);
      public class var SaddleBrown: TGdipColor;  //  = TGdipColor(TGdipKnownColor.SaddleBrown);
      public class var Salmon: TGdipColor;  //  = TGdipColor(TGdipKnownColor.Salmon);
      public class var SandyBrown: TGdipColor;  //  = TGdipColor(TGdipKnownColor.SandyBrown);
      public class var SeaGreen: TGdipColor;  //  = TGdipColor(TGdipKnownColor.SeaGreen);
      public class var SeaShell: TGdipColor;  //  = TGdipColor(TGdipKnownColor.SeaShell);
      public class var Sienna: TGdipColor;  //  = TGdipColor(TGdipKnownColor.Sienna);
      public class var Silver: TGdipColor;  //  = TGdipColor(TGdipKnownColor.Silver);
      public class var SkyBlue: TGdipColor;  //  = TGdipColor(TGdipKnownColor.SkyBlue);
      public class var SlateBlue: TGdipColor;  //  = TGdipColor(TGdipKnownColor.SlateBlue);
      public class var SlateGray: TGdipColor;  //  = TGdipColor(TGdipKnownColor.SlateGray);
      public class var Snow: TGdipColor;  //  = TGdipColor(TGdipKnownColor.Snow);
      public class var SpringGreen: TGdipColor;  //  = TGdipColor(TGdipKnownColor.SpringGreen);
      public class var SteelBlue: TGdipColor;  //  = TGdipColor(TGdipKnownColor.SteelBlue);
      public class var Tan: TGdipColor;  //  = TGdipColor(TGdipKnownColor.Tan);
      public class var Teal: TGdipColor;  //  = TGdipColor(TGdipKnownColor.Teal);
      public class var Thistle: TGdipColor;  //  = TGdipColor(TGdipKnownColor.Thistle);
      public class var Tomato: TGdipColor;  //  = TGdipColor(TGdipKnownColor.Tomato);
      public class var Turquoise: TGdipColor;  //  = TGdipColor(TGdipKnownColor.Turquoise);
      public class var Violet: TGdipColor;  //  = TGdipColor(TGdipKnownColor.Violet);
      public class var Wheat: TGdipColor;  //  = TGdipColor(TGdipKnownColor.Wheat);
      public class var White: TGdipColor;  //  = TGdipColor(TGdipKnownColor.White);
      public class var WhiteSmoke: TGdipColor;  //  = TGdipColor(TGdipKnownColor.WhiteSmoke);
      public class var Yellow: TGdipColor;  //  = TGdipColor(TGdipKnownColor.Yellow);
      public class var YellowGreen: TGdipColor;  //  = TGdipColor(TGdipKnownColor.YellowGreen);
      //
      //  end "web" colors
      // -------------------------------------------------------------------

      public function ToString(): string;

      public class operator Equal(const left: TGdipColor; const right: TGdipColor): Boolean;
      public class operator NotEqual(const left: TGdipColor; const right: TGdipColor): Boolean;
      public function Equals(const other: TGdipColor): Boolean;

      public class function FromArgb(const argb: Integer): TGdipColor; overload; static;
      public class function FromArgb(const alpha: Integer; const red: Integer; const green: Integer; const blue: Integer): TGdipColor; overload; static;
      public class function FromArgb(const alpha: Integer; const baseColor: TGdipColor): TGdipColor; overload; static;
      public class function FromArgb(const red: Integer; const green: Integer; const blue: Integer): TGdipColor; overload; static;
      public class function FromName(const name: string): TGdipColor; static;
      public class function FromKnownColor(const color: TGdipKnownColor): TGdipColor; static;
      public class function IsKnownColorSystem(const knownColor: TGdipKnownColor): Boolean; static;

//      public property Alpha: Byte read GetAlpha write SetAlpha;
      public property A: Byte read GetA;
      public property R: Byte read GetR;
      public property G: Byte read GetG;
      public property B: Byte read GetB;
//    property ColorRef: TColorRef read GetColorRef write SetColorRef;
      public property IsSystemColor: Boolean read GetIsSystemColor;
      public property IsKnownColor: Boolean read GetIsKnownColor;

      public property IsEmpty: Boolean read GetIsEmpty;
      public property IsNamedColor: Boolean read GetIsNamedColor;
      public property Name: string read GetName;

      public function ToArgb(): Integer;
      public function ToKnownColor(): TGdipKnownColor;
  end;

{$ENDREGION 'TGdipColor'}

{$REGION 'TARGB'}

   { TARGB }

   TARGB = packed record
      class operator implicit(const color: TGdipColor): TARGB;
      class operator implicit(const color: UInt32): TARGB;
      class operator implicit(const argb: TARGB): TGdipColor;
      class operator implicit(const argb: TARGB): UInt32;
      case UInt32 of
         0: (B: Byte;
             G: Byte;
             R: Byte;
             A: Byte;);
         1: (Value: UInt32;);
   end;

{$ENDREGION 'TARGB'}

{$REGION 'TGdipColorTranslator'}

   { TGdipColorTranslator }

   /// <summary>
   /// Translates colors to and from GDI+ <see cref='TGdipColor'/> objects.
   /// </summary>
   TGdipColorTranslator = class sealed (* static *)

      // COLORREF is 0x00BBGGRR

      protected const COLORREF_RedShift: Integer = 0;

      protected const COLORREF_GreenShift: Integer = 8;

      protected const COLORREF_BlueShift: Integer = 16;


      strict private const OleSystemColorFlag: Integer = Int32($80000000);


      strict private class var s_htmlSysColorTable: TDictionary<string, TGdipColor>;
      strict private class constructor CreateClass();
      strict private class destructor DestroyClass();
      public procedure AfterConstruction; override;
      public procedure BeforeDestruction; override;



      protected class function COLORREFToARGB(const value: UInt32): UInt32; static;

      /// <summary>
      /// Translates the specified <see cref='TGdipColor'/> to a Win32 color.
      /// </summary>
      public class function ToWin32(const c: TGdipColor): Integer; static;

      /// <summary>
      /// Translates the specified <see cref='TGdipColor'/> to an Ole color.
      /// </summary>
      public class function ToOle(const c: TGdipColor): Integer; static;

      /// <summary>
      /// Translates an Ole color value to a GDI+ <see cref='TGdipColor'/>.
      /// </summary>
      public class function FromOle(const oleColor: Integer): TGdipColor; static;

      /// <summary>
      /// Translates an Win32 color value to a GDI+ <see cref='TGdipColor'/>.
      /// </summary>
      public class function FromWin32(const win32Color: Integer): TGdipColor; static;

      /// <summary>
      /// Translates an Html color representation to a GDI+ <see cref='TGdipColor'/>.
      /// </summary>
      public class function FromHtml(const htmlColor: string): TGdipColor; static;

      /// <summary>
      /// Translates the specified <see cref='TGdipColor'/> to an Html string color representation.
      /// </summary>
      public class function ToHtml(const c: TGdipColor): string; static;


      strict private class procedure InitializeHtmlSysColorTable(); static;
   end;

{$ENDREGION 'TGdipColorTranslator'}

{$REGION 'TWin32SystemColors'}

   { TWin32SystemColors }

   TWin32SystemColors = (
      ActiveBorder = $0A,
      ActiveCaption = $02,
      ActiveCaptionText = $09,
      AppWorkspace = $0C,
      ButtonFace = $0F,
      ButtonHighlight = $14,
      ButtonShadow = $10,
      Control = $0F,
      ControlDark = $10,
      ControlDarkDark = $15,
      ControlLight = $16,
      ControlLightLight = $14,
      ControlText = $12,
      Desktop = $01,
      GradientActiveCaption = $1B,
      GradientInactiveCaption = $1C,
      GrayText = $11,
      Highlight = $0D,
      HighlightText = $0E,
      HotTrack = $1A,
      InactiveBorder = $0B,
      InactiveCaption = $03,
      InactiveCaptionText = $13,
      Info = $18,
      InfoText = $17,
      Menu = $04,
      MenuBar = $1E,
      MenuHighlight = $1D,
      MenuText = $07,
      ScrollBar = $00,
      Window = $05,
      WindowFrame = $06,
      WindowText = $08
   );

{$ENDREGION 'TWin32SystemColors'}

{$REGION 'TGdipKnownColorTable'}

   { TGdipKnownColorTable }

   TGdipKnownColorTable = class sealed (* static *)
      public const KnownColorKindSystem = Byte(0);
      public const KnownColorKindWeb = Byte(1);
      public const KnownColorKindUnknown = Byte(2);
      strict private class constructor CreateClass();
      strict private class destructor DestroyClass();
      public procedure AfterConstruction; override;
      public procedure BeforeDestruction; override;

      // All known color values (in order of definition in the TGdipKnownColor enum).
      public const ColorValueTable: array of UInt32 =
        [
            // "not a known color"
            0,
            // "System" colors, Part 1
{$IFDEF FEATURE_WINDOWS_SYSTEM_COLORS}
            Byte(TWin32SystemColors.ActiveBorder),
            Byte(TWin32SystemColors.ActiveCaption),
            Byte(TWin32SystemColors.ActiveCaptionText),
            Byte(TWin32SystemColors.AppWorkspace),
            Byte(TWin32SystemColors.Control),
            Byte(TWin32SystemColors.ControlDark),
            Byte(TWin32SystemColors.ControlDarkDark),
            Byte(TWin32SystemColors.ControlLight),
            Byte(TWin32SystemColors.ControlLightLight),
            Byte(TWin32SystemColors.ControlText),
            Byte(TWin32SystemColors.Desktop),
            Byte(TWin32SystemColors.GrayText),
            Byte(TWin32SystemColors.Highlight),
            Byte(TWin32SystemColors.HighlightText),
            Byte(TWin32SystemColors.HotTrack),
            Byte(TWin32SystemColors.InactiveBorder),
            Byte(TWin32SystemColors.InactiveCaption),
            Byte(TWin32SystemColors.InactiveCaptionText),
            Byte(TWin32SystemColors.Info),
            Byte(TWin32SystemColors.InfoText),
            Byte(TWin32SystemColors.Menu),
            Byte(TWin32SystemColors.MenuText),
            Byte(TWin32SystemColors.ScrollBar),
            Byte(TWin32SystemColors.Window),
            Byte(TWin32SystemColors.WindowFrame),
            Byte(TWin32SystemColors.WindowText),
{$ELSE FEATURE_WINDOWS_SYSTEM_COLORS}
            // Hard-coded constants, based on default Windows settings.
            0xFFD4D0C8,     // ActiveBorder
            0xFF0054E3,     // ActiveCaption
            0xFFFFFFFF,     // ActiveCaptionText
            0xFF808080,     // AppWorkspace
            0xFFECE9D8,     // Control
            0xFFACA899,     // ControlDark
            0xFF716F64,     // ControlDarkDark
            0xFFF1EFE2,     // ControlLight
            0xFFFFFFFF,     // ControlLightLight
            0xFF000000,     // ControlText
            0xFF004E98,     // Desktop
            0xFFACA899,     // GrayText
            0xFF316AC5,     // Highlight
            0xFFFFFFFF,     // HighlightText
            0xFF000080,     // HotTrack
            0xFFD4D0C8,     // InactiveBorder
            0xFF7A96DF,     // InactiveCaption
            0xFFD8E4F8,     // InactiveCaptionText
            0xFFFFFFE1,     // Info
            0xFF000000,     // InfoText
            0xFFFFFFFF,     // Menu
            0xFF000000,     // MenuText
            0xFFD4D0C8,     // ScrollBar
            0xFFFFFFFF,     // Window
            0xFF000000,     // WindowFrame
            0xFF000000,     // WindowText
{$ENDIF FEATURE_WINDOWS_SYSTEM_COLORS}
            // "Web" Colors, Part 1
            $00FFFFFF,     // Transparent
            $FFF0F8FF,     // AliceBlue
            $FFFAEBD7,     // AntiqueWhite
            $FF00FFFF,     // Aqua
            $FF7FFFD4,     // Aquamarine
            $FFF0FFFF,     // Azure
            $FFF5F5DC,     // Beige
            $FFFFE4C4,     // Bisque
            $FF000000,     // Black
            $FFFFEBCD,     // BlanchedAlmond
            $FF0000FF,     // Blue
            $FF8A2BE2,     // BlueViolet
            $FFA52A2A,     // Brown
            $FFDEB887,     // BurlyWood
            $FF5F9EA0,     // CadetBlue
            $FF7FFF00,     // Chartreuse
            $FFD2691E,     // Chocolate
            $FFFF7F50,     // Coral
            $FF6495ED,     // CornflowerBlue
            $FFFFF8DC,     // Cornsilk
            $FFDC143C,     // Crimson
            $FF00FFFF,     // Cyan
            $FF00008B,     // DarkBlue
            $FF008B8B,     // DarkCyan
            $FFB8860B,     // DarkGoldenrod
            $FFA9A9A9,     // DarkGray
            $FF006400,     // DarkGreen
            $FFBDB76B,     // DarkKhaki
            $FF8B008B,     // DarkMagenta
            $FF556B2F,     // DarkOliveGreen
            $FFFF8C00,     // DarkOrange
            $FF9932CC,     // DarkOrchid
            $FF8B0000,     // DarkRed
            $FFE9967A,     // DarkSalmon
            $FF8FBC8F,     // DarkSeaGreen
            $FF483D8B,     // DarkSlateBlue
            $FF2F4F4F,     // DarkSlateGray
            $FF00CED1,     // DarkTurquoise
            $FF9400D3,     // DarkViolet
            $FFFF1493,     // DeepPink
            $FF00BFFF,     // DeepSkyBlue
            $FF696969,     // DimGray
            $FF1E90FF,     // DodgerBlue
            $FFB22222,     // Firebrick
            $FFFFFAF0,     // FloralWhite
            $FF228B22,     // ForestGreen
            $FFFF00FF,     // Fuchsia
            $FFDCDCDC,     // Gainsboro
            $FFF8F8FF,     // GhostWhite
            $FFFFD700,     // Gold
            $FFDAA520,     // Goldenrod
            $FF808080,     // Gray
            $FF008000,     // Green
            $FFADFF2F,     // GreenYellow
            $FFF0FFF0,     // Honeydew
            $FFFF69B4,     // HotPink
            $FFCD5C5C,     // IndianRed
            $FF4B0082,     // Indigo
            $FFFFFFF0,     // Ivory
            $FFF0E68C,     // Khaki
            $FFE6E6FA,     // Lavender
            $FFFFF0F5,     // LavenderBlush
            $FF7CFC00,     // LawnGreen
            $FFFFFACD,     // LemonChiffon
            $FFADD8E6,     // LightBlue
            $FFF08080,     // LightCoral
            $FFE0FFFF,     // LightCyan
            $FFFAFAD2,     // LightGoldenrodYellow
            $FFD3D3D3,     // LightGray
            $FF90EE90,     // LightGreen
            $FFFFB6C1,     // LightPink
            $FFFFA07A,     // LightSalmon
            $FF20B2AA,     // LightSeaGreen
            $FF87CEFA,     // LightSkyBlue
            $FF778899,     // LightSlateGray
            $FFB0C4DE,     // LightSteelBlue
            $FFFFFFE0,     // LightYellow
            $FF00FF00,     // Lime
            $FF32CD32,     // LimeGreen
            $FFFAF0E6,     // Linen
            $FFFF00FF,     // Magenta
            $FF800000,     // Maroon
            $FF66CDAA,     // MediumAquamarine
            $FF0000CD,     // MediumBlue
            $FFBA55D3,     // MediumOrchid
            $FF9370DB,     // MediumPurple
            $FF3CB371,     // MediumSeaGreen
            $FF7B68EE,     // MediumSlateBlue
            $FF00FA9A,     // MediumSpringGreen
            $FF48D1CC,     // MediumTurquoise
            $FFC71585,     // MediumVioletRed
            $FF191970,     // MidnightBlue
            $FFF5FFFA,     // MintCream
            $FFFFE4E1,     // MistyRose
            $FFFFE4B5,     // Moccasin
            $FFFFDEAD,     // NavajoWhite
            $FF000080,     // Navy
            $FFFDF5E6,     // OldLace
            $FF808000,     // Olive
            $FF6B8E23,     // OliveDrab
            $FFFFA500,     // Orange
            $FFFF4500,     // OrangeRed
            $FFDA70D6,     // Orchid
            $FFEEE8AA,     // PaleGoldenrod
            $FF98FB98,     // PaleGreen
            $FFAFEEEE,     // PaleTurquoise
            $FFDB7093,     // PaleVioletRed
            $FFFFEFD5,     // PapayaWhip
            $FFFFDAB9,     // PeachPuff
            $FFCD853F,     // Peru
            $FFFFC0CB,     // Pink
            $FFDDA0DD,     // Plum
            $FFB0E0E6,     // PowderBlue
            $FF800080,     // Purple
            $FFFF0000,     // Red
            $FFBC8F8F,     // RosyBrown
            $FF4169E1,     // RoyalBlue
            $FF8B4513,     // SaddleBrown
            $FFFA8072,     // Salmon
            $FFF4A460,     // SandyBrown
            $FF2E8B57,     // SeaGreen
            $FFFFF5EE,     // SeaShell
            $FFA0522D,     // Sienna
            $FFC0C0C0,     // Silver
            $FF87CEEB,     // SkyBlue
            $FF6A5ACD,     // SlateBlue
            $FF708090,     // SlateGray
            $FFFFFAFA,     // Snow
            $FF00FF7F,     // SpringGreen
            $FF4682B4,     // SteelBlue
            $FFD2B48C,     // Tan
            $FF008080,     // Teal
            $FFD8BFD8,     // Thistle
            $FFFF6347,     // Tomato
            $FF40E0D0,     // Turquoise
            $FFEE82EE,     // Violet
            $FFF5DEB3,     // Wheat
            $FFFFFFFF,     // White
            $FFF5F5F5,     // WhiteSmoke
            $FFFFFF00,     // Yellow
            $FF9ACD32,     // YellowGreen
{$IFDEF FEATURE_WINDOWS_SYSTEM_COLORS}
            // "System" colors, Part 2
            Byte(TWin32SystemColors.ButtonFace),
            Byte(TWin32SystemColors.ButtonHighlight),
            Byte(TWin32SystemColors.ButtonShadow),
            Byte(TWin32SystemColors.GradientActiveCaption),
            Byte(TWin32SystemColors.GradientInactiveCaption),
            Byte(TWin32SystemColors.MenuBar),
            Byte(TWin32SystemColors.MenuHighlight),
{$ELSE FEATURE_WINDOWS_SYSTEM_COLORS}
            0xFFF0F0F0,     // ButtonFace
            $FFFFFFFF,     // ButtonHighlight
            $FFA0A0A0,     // ButtonShadow
            $FFB9D1EA,     // GradientActiveCaption
            $FFD7E4F2,     // GradientInactiveCaption
            $FFF0F0F0,     // MenuBar
            $FF3399FF,     // MenuHighlight
{$ENDIF FEATURE_WINDOWS_SYSTEM_COLORS}
            // "Web" colors, Part 2
            $FF663399      // RebeccaPurple
        ];

      // All known color kinds (in order of definition in the TGdipKnownColor enum).
      public const ColorKindTable: array of Byte =
        [
            // "not a known color"
            KnownColorKindUnknown,
            // "System" colors, Part 1
{$IFDEF FEATURE_WINDOWS_SYSTEM_COLORS}
            KnownColorKindSystem,       // ActiveBorder
            KnownColorKindSystem,       // ActiveCaption
            KnownColorKindSystem,       // ActiveCaptionText
            KnownColorKindSystem,       // AppWorkspace
            KnownColorKindSystem,       // Control
            KnownColorKindSystem,       // ControlDark
            KnownColorKindSystem,       // ControlDarkDark
            KnownColorKindSystem,       // ControlLight
            KnownColorKindSystem,       // ControlLightLight
            KnownColorKindSystem,       // ControlText
            KnownColorKindSystem,       // Desktop
            KnownColorKindSystem,       // GrayText
            KnownColorKindSystem,       // Highlight
            KnownColorKindSystem,       // HighlightText
            KnownColorKindSystem,       // HotTrack
            KnownColorKindSystem,       // InactiveBorder
            KnownColorKindSystem,       // InactiveCaption
            KnownColorKindSystem,       // InactiveCaptionText
            KnownColorKindSystem,       // Info
            KnownColorKindSystem,       // InfoText
            KnownColorKindSystem,       // Menu
            KnownColorKindSystem,       // MenuText
            KnownColorKindSystem,       // ScrollBar
            KnownColorKindSystem,       // Window
            KnownColorKindSystem,       // WindowFrame
            KnownColorKindSystem,       // WindowText
{$ELSE FEATURE_WINDOWS_SYSTEM_COLORS}
            // Hard-coded constants, based on default Windows settings.
            KnownColorKindSystem,       // ActiveBorder
            KnownColorKindSystem,       // ActiveCaption
            KnownColorKindSystem,       // ActiveCaptionText
            KnownColorKindSystem,       // AppWorkspace
            KnownColorKindSystem,       // Control
            KnownColorKindSystem,       // ControlDark
            KnownColorKindSystem,       // ControlDarkDark
            KnownColorKindSystem,       // ControlLight
            KnownColorKindSystem,       // ControlLightLight
            KnownColorKindSystem,       // ControlText
            KnownColorKindSystem,       // Desktop
            KnownColorKindSystem,       // GrayText
            KnownColorKindSystem,       // Highlight
            KnownColorKindSystem,       // HighlightText
            KnownColorKindSystem,       // HotTrack
            KnownColorKindSystem,       // InactiveBorder
            KnownColorKindSystem,       // InactiveCaption
            KnownColorKindSystem,       // InactiveCaptionText
            KnownColorKindSystem,       // Info
            KnownColorKindSystem,       // InfoText
            KnownColorKindSystem,       // Menu
            KnownColorKindSystem,       // MenuText
            KnownColorKindSystem,       // ScrollBar
            KnownColorKindSystem,       // Window
            KnownColorKindSystem,       // WindowFrame
            KnownColorKindSystem,       // WindowText
{$ENDIF FEATURE_WINDOWS_SYSTEM_COLORS}
            // "Web" Colors, Part 1
            KnownColorKindWeb,      // Transparent
            KnownColorKindWeb,      // AliceBlue
            KnownColorKindWeb,      // AntiqueWhite
            KnownColorKindWeb,      // Aqua
            KnownColorKindWeb,      // Aquamarine
            KnownColorKindWeb,      // Azure
            KnownColorKindWeb,      // Beige
            KnownColorKindWeb,      // Bisque
            KnownColorKindWeb,      // Black
            KnownColorKindWeb,      // BlanchedAlmond
            KnownColorKindWeb,      // Blue
            KnownColorKindWeb,      // BlueViolet
            KnownColorKindWeb,      // Brown
            KnownColorKindWeb,      // BurlyWood
            KnownColorKindWeb,      // CadetBlue
            KnownColorKindWeb,      // Chartreuse
            KnownColorKindWeb,      // Chocolate
            KnownColorKindWeb,      // Coral
            KnownColorKindWeb,      // CornflowerBlue
            KnownColorKindWeb,      // Cornsilk
            KnownColorKindWeb,      // Crimson
            KnownColorKindWeb,      // Cyan
            KnownColorKindWeb,      // DarkBlue
            KnownColorKindWeb,      // DarkCyan
            KnownColorKindWeb,      // DarkGoldenrod
            KnownColorKindWeb,      // DarkGray
            KnownColorKindWeb,      // DarkGreen
            KnownColorKindWeb,      // DarkKhaki
            KnownColorKindWeb,      // DarkMagenta
            KnownColorKindWeb,      // DarkOliveGreen
            KnownColorKindWeb,      // DarkOrange
            KnownColorKindWeb,      // DarkOrchid
            KnownColorKindWeb,      // DarkRed
            KnownColorKindWeb,      // DarkSalmon
            KnownColorKindWeb,      // DarkSeaGreen
            KnownColorKindWeb,      // DarkSlateBlue
            KnownColorKindWeb,      // DarkSlateGray
            KnownColorKindWeb,      // DarkTurquoise
            KnownColorKindWeb,      // DarkViolet
            KnownColorKindWeb,      // DeepPink
            KnownColorKindWeb,      // DeepSkyBlue
            KnownColorKindWeb,      // DimGray
            KnownColorKindWeb,      // DodgerBlue
            KnownColorKindWeb,      // Firebrick
            KnownColorKindWeb,      // FloralWhite
            KnownColorKindWeb,      // ForestGreen
            KnownColorKindWeb,      // Fuchsia
            KnownColorKindWeb,      // Gainsboro
            KnownColorKindWeb,      // GhostWhite
            KnownColorKindWeb,      // Gold
            KnownColorKindWeb,      // Goldenrod
            KnownColorKindWeb,      // Gray
            KnownColorKindWeb,      // Green
            KnownColorKindWeb,      // GreenYellow
            KnownColorKindWeb,      // Honeydew
            KnownColorKindWeb,      // HotPink
            KnownColorKindWeb,      // IndianRed
            KnownColorKindWeb,      // Indigo
            KnownColorKindWeb,      // Ivory
            KnownColorKindWeb,      // Khaki
            KnownColorKindWeb,      // Lavender
            KnownColorKindWeb,      // LavenderBlush
            KnownColorKindWeb,      // LawnGreen
            KnownColorKindWeb,      // LemonChiffon
            KnownColorKindWeb,      // LightBlue
            KnownColorKindWeb,      // LightCoral
            KnownColorKindWeb,      // LightCyan
            KnownColorKindWeb,      // LightGoldenrodYellow
            KnownColorKindWeb,      // LightGray
            KnownColorKindWeb,      // LightGreen
            KnownColorKindWeb,      // LightPink
            KnownColorKindWeb,      // LightSalmon
            KnownColorKindWeb,      // LightSeaGreen
            KnownColorKindWeb,      // LightSkyBlue
            KnownColorKindWeb,      // LightSlateGray
            KnownColorKindWeb,      // LightSteelBlue
            KnownColorKindWeb,      // LightYellow
            KnownColorKindWeb,      // Lime
            KnownColorKindWeb,      // LimeGreen
            KnownColorKindWeb,      // Linen
            KnownColorKindWeb,      // Magenta
            KnownColorKindWeb,      // Maroon
            KnownColorKindWeb,      // MediumAquamarine
            KnownColorKindWeb,      // MediumBlue
            KnownColorKindWeb,      // MediumOrchid
            KnownColorKindWeb,      // MediumPurple
            KnownColorKindWeb,      // MediumSeaGreen
            KnownColorKindWeb,      // MediumSlateBlue
            KnownColorKindWeb,      // MediumSpringGreen
            KnownColorKindWeb,      // MediumTurquoise
            KnownColorKindWeb,      // MediumVioletRed
            KnownColorKindWeb,      // MidnightBlue
            KnownColorKindWeb,      // MintCream
            KnownColorKindWeb,      // MistyRose
            KnownColorKindWeb,      // Moccasin
            KnownColorKindWeb,      // NavajoWhite
            KnownColorKindWeb,      // Navy
            KnownColorKindWeb,      // OldLace
            KnownColorKindWeb,      // Olive
            KnownColorKindWeb,      // OliveDrab
            KnownColorKindWeb,      // Orange
            KnownColorKindWeb,      // OrangeRed
            KnownColorKindWeb,      // Orchid
            KnownColorKindWeb,      // PaleGoldenrod
            KnownColorKindWeb,      // PaleGreen
            KnownColorKindWeb,      // PaleTurquoise
            KnownColorKindWeb,      // PaleVioletRed
            KnownColorKindWeb,      // PapayaWhip
            KnownColorKindWeb,      // PeachPuff
            KnownColorKindWeb,      // Peru
            KnownColorKindWeb,      // Pink
            KnownColorKindWeb,      // Plum
            KnownColorKindWeb,      // PowderBlue
            KnownColorKindWeb,      // Purple
            KnownColorKindWeb,      // Red
            KnownColorKindWeb,      // RosyBrown
            KnownColorKindWeb,      // RoyalBlue
            KnownColorKindWeb,      // SaddleBrown
            KnownColorKindWeb,      // Salmon
            KnownColorKindWeb,      // SandyBrown
            KnownColorKindWeb,      // SeaGreen
            KnownColorKindWeb,      // SeaShell
            KnownColorKindWeb,      // Sienna
            KnownColorKindWeb,      // Silver
            KnownColorKindWeb,      // SkyBlue
            KnownColorKindWeb,      // SlateBlue
            KnownColorKindWeb,      // SlateGray
            KnownColorKindWeb,      // Snow
            KnownColorKindWeb,      // SpringGreen
            KnownColorKindWeb,      // SteelBlue
            KnownColorKindWeb,      // Tan
            KnownColorKindWeb,      // Teal
            KnownColorKindWeb,      // Thistle
            KnownColorKindWeb,      // Tomato
            KnownColorKindWeb,      // Turquoise
            KnownColorKindWeb,      // Violet
            KnownColorKindWeb,      // Wheat
            KnownColorKindWeb,      // White
            KnownColorKindWeb,      // WhiteSmoke
            KnownColorKindWeb,      // Yellow
            KnownColorKindWeb,      // YellowGreen
{$IFDEF FEATURE_WINDOWS_SYSTEM_COLORS}
            // "System" colors, Part 2
            KnownColorKindSystem,       // ButtonFace
            KnownColorKindSystem,       // ButtonHighlight
            KnownColorKindSystem,       // ButtonShadow
            KnownColorKindSystem,       // GradientActiveCaption
            KnownColorKindSystem,       // GradientInactiveCaption
            KnownColorKindSystem,       // MenuBar
            KnownColorKindSystem,       // MenuHighlight
{$ELSE FEATURE_WINDOWS_SYSTEM_COLORS}
            KnownColorKindSystem,       // ButtonFace
            KnownColorKindSystem,       // ButtonHighlight
            KnownColorKindSystem,       // ButtonShadow
            KnownColorKindSystem,       // GradientActiveCaption
            KnownColorKindSystem,       // GradientInactiveCaption
            KnownColorKindSystem,       // MenuBar
            KnownColorKindSystem,       // MenuHighlight
{$ENDIF FEATURE_WINDOWS_SYSTEM_COLORS}
            // "Web" colors, Part 2
            KnownColorKindWeb      // RebeccaPurple
        ];


      protected class function ArgbToKnownColor(const argb: UInt32): TGdipColor; static;


      public class function KnownColorToArgb(const color: TGdipKnownColor): UInt32; static;

      // #if FEATURE_WINDOWS_SYSTEM_COLORS -> IfDirectiveTrivia

      public class function GetSystemColorArgb(const color: TGdipKnownColor): UInt32; static;
   end;

{$ENDREGION 'TGdipKnownColorTable'}

{$REGION 'TGdipSystemColors'}

   { TGdipSystemColors }

   TGdipSystemColors = class sealed (* static *)
      strict private class constructor CreateClass();
      public class var ActiveBorder: TGdipColor;  //  = TGdipColor(TGdipColor.FromKnownColor(TGdipKnownColor.ActiveBorder);
      public class var ActiveCaption: TGdipColor;  //  = TGdipColor(TGdipColor.FromKnownColor(TGdipKnownColor.ActiveCaption);
      public class var ActiveCaptionText: TGdipColor;  //  = TGdipColor(TGdipColor.FromKnownColor(TGdipKnownColor.ActiveCaptionText);
      public class var AppWorkspace: TGdipColor;  //  = TGdipColor(TGdipColor.FromKnownColor(TGdipKnownColor.AppWorkspace);

      public class var ButtonFace: TGdipColor;  //  = TGdipColor(TGdipColor.FromKnownColor(TGdipKnownColor.ButtonFace);
      public class var ButtonHighlight: TGdipColor;  //  = TGdipColor(TGdipColor.FromKnownColor(TGdipKnownColor.ButtonHighlight);
      public class var ButtonShadow: TGdipColor;  //  = TGdipColor(TGdipColor.FromKnownColor(TGdipKnownColor.ButtonShadow);

      public class var Control: TGdipColor;  //  = TGdipColor(TGdipColor.FromKnownColor(TGdipKnownColor.Control);
      public class var ControlDark: TGdipColor;  //  = TGdipColor(TGdipColor.FromKnownColor(TGdipKnownColor.ControlDark);
      public class var ControlDarkDark: TGdipColor;  //  = TGdipColor(TGdipColor.FromKnownColor(TGdipKnownColor.ControlDarkDark);
      public class var ControlLight: TGdipColor;  //  = TGdipColor(TGdipColor.FromKnownColor(TGdipKnownColor.ControlLight);
      public class var ControlLightLight: TGdipColor;  //  = TGdipColor(TGdipColor.FromKnownColor(TGdipKnownColor.ControlLightLight);
      public class var ControlText: TGdipColor;  //  = TGdipColor(TGdipColor.FromKnownColor(TGdipKnownColor.ControlText);

      public class var Desktop: TGdipColor;  //  = TGdipColor(TGdipColor.FromKnownColor(TGdipKnownColor.Desktop);

      public class var GradientActiveCaption: TGdipColor;  //  = TGdipColor(TGdipColor.FromKnownColor(TGdipKnownColor.GradientActiveCaption);
      public class var GradientInactiveCaption: TGdipColor;  //  = TGdipColor(TGdipColor.FromKnownColor(TGdipKnownColor.GradientInactiveCaption);
      public class var GrayText: TGdipColor;  //  = TGdipColor(TGdipColor.FromKnownColor(TGdipKnownColor.GrayText);

      public class var Highlight: TGdipColor;  //  = TGdipColor(TGdipColor.FromKnownColor(TGdipKnownColor.Highlight);
      public class var HighlightText: TGdipColor;  //  = TGdipColor(TGdipColor.FromKnownColor(TGdipKnownColor.HighlightText);
      public class var HotTrack: TGdipColor;  //  = TGdipColor(TGdipColor.FromKnownColor(TGdipKnownColor.HotTrack);

      public class var InactiveBorder: TGdipColor;  //  = TGdipColor(TGdipColor.FromKnownColor(TGdipKnownColor.InactiveBorder);
      public class var InactiveCaption: TGdipColor;  //  = TGdipColor(TGdipColor.FromKnownColor(TGdipKnownColor.InactiveCaption);
      public class var InactiveCaptionText: TGdipColor;  //  = TGdipColor(TGdipColor.FromKnownColor(TGdipKnownColor.InactiveCaptionText);
      public class var Info: TGdipColor;  //  = TGdipColor(TGdipColor.FromKnownColor(TGdipKnownColor.Info);
      public class var InfoText: TGdipColor;  //  = TGdipColor(TGdipColor.FromKnownColor(TGdipKnownColor.InfoText);

      public class var Menu: TGdipColor;  //  = TGdipColor(TGdipColor.FromKnownColor(TGdipKnownColor.Menu);
      public class var MenuBar: TGdipColor;  //  = TGdipColor(TGdipColor.FromKnownColor(TGdipKnownColor.MenuBar);
      public class var MenuHighlight: TGdipColor;  //  = TGdipColor(TGdipColor.FromKnownColor(TGdipKnownColor.MenuHighlight);
      public class var MenuText: TGdipColor;  //  = TGdipColor(TGdipColor.FromKnownColor(TGdipKnownColor.MenuText);

      public class var ScrollBar: TGdipColor;  //  = TGdipColor(TGdipColor.FromKnownColor(TGdipKnownColor.ScrollBar);

      public class var Window: TGdipColor;  //  = TGdipColor(TGdipColor.FromKnownColor(TGdipKnownColor.Window);
      public class var WindowFrame: TGdipColor;  //  = TGdipColor(TGdipColor.FromKnownColor(TGdipKnownColor.WindowFrame);
      public class var WindowText: TGdipColor;  //  = TGdipColor(TGdipColor.FromKnownColor(TGdipKnownColor.WindowText);
   end;

{$ENDREGION 'TGdipSystemColors'}


{$REGION 'TArgbHelper'}

   { TArgbHelper }

   TArgbHelper = record helper for TARGB
      public constructor Create(const a: Byte; const r: Byte; const g: Byte; const b: Byte); overload;
      public constructor Create(const value: UInt32); overload;
      public class function ToColorArray(const argbColors: TReadOnlySpan<TARGB>): TArray<TGdipColor>; overload; static;
      public class function ToColorArray(const argbColors: TReadOnlySpan<UInt32>): TArray<TGdipColor>; overload; static;

   end;

{$ENDREGION 'TArgbHelper'}

implementation

{$REGION 'Uses declarations'}

uses
   TypInfo,
   Se7e.Drawing.Gdiplus.Utils;

{$ENDREGION 'Uses declarations'}

type

{$REGION 'TGdipKnownColorNames'}

   { TGdipKnownColorNames }

   TGdipKnownColorNames = class sealed (* static *)

      //  Names of all colors (in order of definition in the TGdipKnownColor enum).
      strict private const s_colorNameTable: array of string =
      [
            // 'System' colors, Part 1
            'ActiveBorder',
            'ActiveCaption',
            'ActiveCaptionText',
            'AppWorkspace',
            'Control',
            'ControlDark',
            'ControlDarkDark',
            'ControlLight',
            'ControlLightLight',
            'ControlText',
            'Desktop',
            'GrayText',
            'Highlight',
            'HighlightText',
            'HotTrack',
            'InactiveBorder',
            'InactiveCaption',
            'InactiveCaptionText',
            'Info',
            'InfoText',
            'Menu',
            'MenuText',
            'ScrollBar',
            'Window',
            'WindowFrame',
            'WindowText',

            // 'Web' Colors, Part 1
            'Transparent',
            'AliceBlue',
            'AntiqueWhite',
            'Aqua',
            'Aquamarine',
            'Azure',
            'Beige',
            'Bisque',
            'Black',
            'BlanchedAlmond',
            'Blue',
            'BlueViolet',
            'Brown',
            'BurlyWood',
            'CadetBlue',
            'Chartreuse',
            'Chocolate',
            'Coral',
            'CornflowerBlue',
            'Cornsilk',
            'Crimson',
            'Cyan',
            'DarkBlue',
            'DarkCyan',
            'DarkGoldenrod',
            'DarkGray',
            'DarkGreen',
            'DarkKhaki',
            'DarkMagenta',
            'DarkOliveGreen',
            'DarkOrange',
            'DarkOrchid',
            'DarkRed',
            'DarkSalmon',
            'DarkSeaGreen',
            'DarkSlateBlue',
            'DarkSlateGray',
            'DarkTurquoise',
            'DarkViolet',
            'DeepPink',
            'DeepSkyBlue',
            'DimGray',
            'DodgerBlue',
            'Firebrick',
            'FloralWhite',
            'ForestGreen',
            'Fuchsia',
            'Gainsboro',
            'GhostWhite',
            'Gold',
            'Goldenrod',
            'Gray',
            'Green',
            'GreenYellow',
            'Honeydew',
            'HotPink',
            'IndianRed',
            'Indigo',
            'Ivory',
            'Khaki',
            'Lavender',
            'LavenderBlush',
            'LawnGreen',
            'LemonChiffon',
            'LightBlue',
            'LightCoral',
            'LightCyan',
            'LightGoldenrodYellow',
            'LightGray',
            'LightGreen',
            'LightPink',
            'LightSalmon',
            'LightSeaGreen',
            'LightSkyBlue',
            'LightSlateGray',
            'LightSteelBlue',
            'LightYellow',
            'Lime',
            'LimeGreen',
            'Linen',
            'Magenta',
            'Maroon',
            'MediumAquamarine',
            'MediumBlue',
            'MediumOrchid',
            'MediumPurple',
            'MediumSeaGreen',
            'MediumSlateBlue',
            'MediumSpringGreen',
            'MediumTurquoise',
            'MediumVioletRed',
            'MidnightBlue',
            'MintCream',
            'MistyRose',
            'Moccasin',
            'NavajoWhite',
            'Navy',
            'OldLace',
            'Olive',
            'OliveDrab',
            'Orange',
            'OrangeRed',
            'Orchid',
            'PaleGoldenrod',
            'PaleGreen',
            'PaleTurquoise',
            'PaleVioletRed',
            'PapayaWhip',
            'PeachPuff',
            'Peru',
            'Pink',
            'Plum',
            'PowderBlue',
            'Purple',
            'Red',
            'RosyBrown',
            'RoyalBlue',
            'SaddleBrown',
            'Salmon',
            'SandyBrown',
            'SeaGreen',
            'SeaShell',
            'Sienna',
            'Silver',
            'SkyBlue',
            'SlateBlue',
            'SlateGray',
            'Snow',
            'SpringGreen',
            'SteelBlue',
            'Tan',
            'Teal',
            'Thistle',
            'Tomato',
            'Turquoise',
            'Violet',
            'Wheat',
            'White',
            'WhiteSmoke',
            'Yellow',
            'YellowGreen',

            // 'System' colors, Part 2
            'ButtonFace',
            'ButtonHighlight',
            'ButtonShadow',
            'GradientActiveCaption',
            'GradientInactiveCaption',
            'MenuBar',
            'MenuHighlight',

            // 'Web' colors, Part 2
            'RebeccaPurple'
      ];


      public class function KnownColorToName(const color: TGdipKnownColor): string; static;
   end;

{ TGdipKnownColorNames }

class function TGdipKnownColorNames.KnownColorToName(const color: TGdipKnownColor): string;
begin
   Assert((Ord(color) > 0) and (color <= TGdipKnownColor.RebeccaPurple));

   Result := s_colorNameTable[unchecked(Int32(color)) - 1];
end;


{$ENDREGION 'TGdipKnownColorNames'}

{$REGION 'TGdipColorTable'}

type

   { TGdipColorTable }

   TGdipColorTable = class sealed (* static *)
      strict private class var s_colorConstants: TDictionary<string, TGdipColor>;
      strict private class constructor CreateClass();
      strict private class destructor DestroyClass();
//      strict private class procedure CreateColors();
//      strict private class function GetColors(): TDictionary<string, TGPColor>; static;
      protected class property Colors: TDictionary<string, TGdipColor> read s_colorConstants;
//      strict private class procedure FillWithProperties(const dictionary: TDictionary<string, TGPColor>; const typeWithColors: TRttiType); static;
      protected class function TryGetNamedColor(const name: string; out _result: TGdipColor): Boolean; static;
      protected class function IsKnownNamedColor(const name: string): Boolean; static;
   end;

{ TGdipColorTable }

class constructor TGdipColorTable.CreateClass();
begin
   s_colorConstants := TDictionary<string, TGdipColor>.Create();
   s_colorConstants.Add('Transparent', TGdipColor.Transparent);
   s_colorConstants.Add('AliceBlue', TGdipColor.AliceBlue);
   s_colorConstants.Add('AntiqueWhite', TGdipColor.AntiqueWhite);
   s_colorConstants.Add('Aqua', TGdipColor.Aqua);
   s_colorConstants.Add('Aquamarine', TGdipColor.Aquamarine);
   s_colorConstants.Add('Azure', TGdipColor.Azure);
   s_colorConstants.Add('Beige', TGdipColor.Beige);
   s_colorConstants.Add('Bisque', TGdipColor.Bisque);
   s_colorConstants.Add('Black', TGdipColor.Black);
   s_colorConstants.Add('BlanchedAlmond', TGdipColor.BlanchedAlmond);
   s_colorConstants.Add('Blue', TGdipColor.Blue);
   s_colorConstants.Add('BlueViolet', TGdipColor.BlueViolet);
   s_colorConstants.Add('Brown', TGdipColor.Brown);
   s_colorConstants.Add('BurlyWood', TGdipColor.BurlyWood);
   s_colorConstants.Add('CadetBlue', TGdipColor.CadetBlue);
   s_colorConstants.Add('Chartreuse', TGdipColor.Chartreuse);
   s_colorConstants.Add('Chocolate', TGdipColor.Chocolate);
   s_colorConstants.Add('Coral', TGdipColor.Coral);
   s_colorConstants.Add('CornflowerBlue', TGdipColor.CornflowerBlue);
   s_colorConstants.Add('Cornsilk', TGdipColor.Cornsilk);
   s_colorConstants.Add('Crimson', TGdipColor.Crimson);
   s_colorConstants.Add('Cyan', TGdipColor.Cyan);
   s_colorConstants.Add('DarkBlue', TGdipColor.DarkBlue);
   s_colorConstants.Add('DarkCyan', TGdipColor.DarkCyan);
   s_colorConstants.Add('DarkGoldenrod', TGdipColor.DarkGoldenrod);
   s_colorConstants.Add('DarkGray', TGdipColor.DarkGray);
   s_colorConstants.Add('DarkGreen', TGdipColor.DarkGreen);
   s_colorConstants.Add('DarkKhaki', TGdipColor.DarkKhaki);
   s_colorConstants.Add('DarkMagenta', TGdipColor.DarkMagenta);
   s_colorConstants.Add('DarkOliveGreen', TGdipColor.DarkOliveGreen);
   s_colorConstants.Add('DarkOrange', TGdipColor.DarkOrange);
   s_colorConstants.Add('DarkOrchid', TGdipColor.DarkOrchid);
   s_colorConstants.Add('DarkRed', TGdipColor.DarkRed);
   s_colorConstants.Add('DarkSalmon', TGdipColor.DarkSalmon);
   s_colorConstants.Add('DarkSeaGreen', TGdipColor.DarkSeaGreen);
   s_colorConstants.Add('DarkSlateBlue', TGdipColor.DarkSlateBlue);
   s_colorConstants.Add('DarkSlateGray', TGdipColor.DarkSlateGray);
   s_colorConstants.Add('DarkTurquoise', TGdipColor.DarkTurquoise);
   s_colorConstants.Add('DarkViolet', TGdipColor.DarkViolet);
   s_colorConstants.Add('DeepPink', TGdipColor.DeepPink);
   s_colorConstants.Add('DeepSkyBlue', TGdipColor.DeepSkyBlue);
   s_colorConstants.Add('DimGray', TGdipColor.DimGray);
   s_colorConstants.Add('DodgerBlue', TGdipColor.DodgerBlue);
   s_colorConstants.Add('Firebrick', TGdipColor.Firebrick);
   s_colorConstants.Add('FloralWhite', TGdipColor.FloralWhite);
   s_colorConstants.Add('ForestGreen', TGdipColor.ForestGreen);
   s_colorConstants.Add('Fuchsia', TGdipColor.Fuchsia);
   s_colorConstants.Add('Gainsboro', TGdipColor.Gainsboro);
   s_colorConstants.Add('GhostWhite', TGdipColor.GhostWhite);
   s_colorConstants.Add('Gold', TGdipColor.Gold);
   s_colorConstants.Add('Goldenrod', TGdipColor.Goldenrod);
   s_colorConstants.Add('Gray', TGdipColor.Gray);
   s_colorConstants.Add('Green', TGdipColor.Green);
   s_colorConstants.Add('GreenYellow', TGdipColor.GreenYellow);
   s_colorConstants.Add('Honeydew', TGdipColor.Honeydew);
   s_colorConstants.Add('HotPink', TGdipColor.HotPink);
   s_colorConstants.Add('IndianRed', TGdipColor.IndianRed);
   s_colorConstants.Add('Indigo', TGdipColor.Indigo);
   s_colorConstants.Add('Ivory', TGdipColor.Ivory);
   s_colorConstants.Add('Khaki', TGdipColor.Khaki);
   s_colorConstants.Add('Lavender', TGdipColor.Lavender);
   s_colorConstants.Add('LavenderBlush', TGdipColor.LavenderBlush);
   s_colorConstants.Add('LawnGreen', TGdipColor.LawnGreen);
   s_colorConstants.Add('LemonChiffon', TGdipColor.LemonChiffon);
   s_colorConstants.Add('LightBlue', TGdipColor.LightBlue);
   s_colorConstants.Add('LightCoral', TGdipColor.LightCoral);
   s_colorConstants.Add('LightCyan', TGdipColor.LightCyan);
   s_colorConstants.Add('LightGoldenrodYellow', TGdipColor.LightGoldenrodYellow);
   s_colorConstants.Add('LightGreen', TGdipColor.LightGreen);
   s_colorConstants.Add('LightGray', TGdipColor.LightGray);
   s_colorConstants.Add('LightPink', TGdipColor.LightPink);
   s_colorConstants.Add('LightSalmon', TGdipColor.LightSalmon);
   s_colorConstants.Add('LightSeaGreen', TGdipColor.LightSeaGreen);
   s_colorConstants.Add('LightSkyBlue', TGdipColor.LightSkyBlue);
   s_colorConstants.Add('LightSlateGray', TGdipColor.LightSlateGray);
   s_colorConstants.Add('LightSteelBlue', TGdipColor.LightSteelBlue);
   s_colorConstants.Add('LightYellow', TGdipColor.LightYellow);
   s_colorConstants.Add('Lime', TGdipColor.Lime);
   s_colorConstants.Add('LimeGreen', TGdipColor.LimeGreen);
   s_colorConstants.Add('Linen', TGdipColor.Linen);
   s_colorConstants.Add('Magenta', TGdipColor.Magenta);
   s_colorConstants.Add('Maroon', TGdipColor.Maroon);
   s_colorConstants.Add('MediumAquamarine', TGdipColor.MediumAquamarine);
   s_colorConstants.Add('MediumBlue', TGdipColor.MediumBlue);
   s_colorConstants.Add('MediumOrchid', TGdipColor.MediumOrchid);
   s_colorConstants.Add('MediumPurple', TGdipColor.MediumPurple);
   s_colorConstants.Add('MediumSeaGreen', TGdipColor.MediumSeaGreen);
   s_colorConstants.Add('MediumSlateBlue', TGdipColor.MediumSlateBlue);
   s_colorConstants.Add('MediumSpringGreen', TGdipColor.MediumSpringGreen);
   s_colorConstants.Add('MediumTurquoise', TGdipColor.MediumTurquoise);
   s_colorConstants.Add('MediumVioletRed', TGdipColor.MediumVioletRed);
   s_colorConstants.Add('MidnightBlue', TGdipColor.MidnightBlue);
   s_colorConstants.Add('MintCream', TGdipColor.MintCream);
   s_colorConstants.Add('MistyRose', TGdipColor.MistyRose);
   s_colorConstants.Add('Moccasin', TGdipColor.Moccasin);
   s_colorConstants.Add('NavajoWhite', TGdipColor.NavajoWhite);
   s_colorConstants.Add('Navy', TGdipColor.Navy);
   s_colorConstants.Add('OldLace', TGdipColor.OldLace);
   s_colorConstants.Add('Olive', TGdipColor.Olive);
   s_colorConstants.Add('OliveDrab', TGdipColor.OliveDrab);
   s_colorConstants.Add('Orange', TGdipColor.Orange);
   s_colorConstants.Add('OrangeRed', TGdipColor.OrangeRed);
   s_colorConstants.Add('Orchid', TGdipColor.Orchid);
   s_colorConstants.Add('PaleGoldenrod', TGdipColor.PaleGoldenrod);
   s_colorConstants.Add('PaleGreen', TGdipColor.PaleGreen);
   s_colorConstants.Add('PaleTurquoise', TGdipColor.PaleTurquoise);
   s_colorConstants.Add('PaleVioletRed', TGdipColor.PaleVioletRed);
   s_colorConstants.Add('PapayaWhip', TGdipColor.PapayaWhip);
   s_colorConstants.Add('PeachPuff', TGdipColor.PeachPuff);
   s_colorConstants.Add('Peru', TGdipColor.Peru);
   s_colorConstants.Add('Pink', TGdipColor.Pink);
   s_colorConstants.Add('Plum', TGdipColor.Plum);
   s_colorConstants.Add('PowderBlue', TGdipColor.PowderBlue);
   s_colorConstants.Add('Purple', TGdipColor.Purple);
   s_colorConstants.Add('RebeccaPurple', TGdipColor.RebeccaPurple);
   s_colorConstants.Add('Red', TGdipColor.Red);
   s_colorConstants.Add('RosyBrown', TGdipColor.RosyBrown);
   s_colorConstants.Add('RoyalBlue', TGdipColor.RoyalBlue);
   s_colorConstants.Add('SaddleBrown', TGdipColor.SaddleBrown);
   s_colorConstants.Add('Salmon', TGdipColor.Salmon);
   s_colorConstants.Add('SandyBrown', TGdipColor.SandyBrown);
   s_colorConstants.Add('SeaGreen', TGdipColor.SeaGreen);
   s_colorConstants.Add('SeaShell', TGdipColor.SeaShell);
   s_colorConstants.Add('Sienna', TGdipColor.Sienna);
   s_colorConstants.Add('Silver', TGdipColor.Silver);
   s_colorConstants.Add('SkyBlue', TGdipColor.SkyBlue);
   s_colorConstants.Add('SlateBlue', TGdipColor.SlateBlue);
   s_colorConstants.Add('SlateGray', TGdipColor.SlateGray);
   s_colorConstants.Add('Snow', TGdipColor.Snow);
   s_colorConstants.Add('SpringGreen', TGdipColor.SpringGreen);
   s_colorConstants.Add('SteelBlue', TGdipColor.SteelBlue);
   s_colorConstants.Add('Tan', TGdipColor.Tan);
   s_colorConstants.Add('Teal', TGdipColor.Teal);
   s_colorConstants.Add('Thistle', TGdipColor.Thistle);
   s_colorConstants.Add('Tomato', TGdipColor.Tomato);
   s_colorConstants.Add('Turquoise', TGdipColor.Turquoise);
   s_colorConstants.Add('Violet', TGdipColor.Violet);
   s_colorConstants.Add('Wheat', TGdipColor.Wheat);
   s_colorConstants.Add('White', TGdipColor.White);
   s_colorConstants.Add('WhiteSmoke', TGdipColor.WhiteSmoke);
   s_colorConstants.Add('Yellow', TGdipColor.Yellow);
   s_colorConstants.Add('YellowGreen', TGdipColor.YellowGreen);

   s_colorConstants.Add('ActiveBorder', TGdipSystemColors.ActiveBorder);
   s_colorConstants.Add('ActiveCaption', TGdipSystemColors.ActiveCaption);
   s_colorConstants.Add('ActiveCaptionText', TGdipSystemColors.ActiveCaptionText);
   s_colorConstants.Add('AppWorkspace', TGdipSystemColors.AppWorkspace);
   s_colorConstants.Add('ButtonFace', TGdipSystemColors.ButtonFace);
   s_colorConstants.Add('ButtonHighlight', TGdipSystemColors.ButtonHighlight);
   s_colorConstants.Add('ButtonShadow', TGdipSystemColors.ButtonShadow);
   s_colorConstants.Add('Control', TGdipSystemColors.Control);
   s_colorConstants.Add('ControlDark', TGdipSystemColors.ControlDark);
   s_colorConstants.Add('ControlDarkDark', TGdipSystemColors.ControlDarkDark);
   s_colorConstants.Add('ControlLight', TGdipSystemColors.ControlLight);
   s_colorConstants.Add('ControlLightLight', TGdipSystemColors.ControlLightLight);
   s_colorConstants.Add('ControlText', TGdipSystemColors.ControlText);
   s_colorConstants.Add('Desktop', TGdipSystemColors.Desktop);
   s_colorConstants.Add('GradientActiveCaption', TGdipSystemColors.GradientActiveCaption);
   s_colorConstants.Add('GradientInactiveCaption', TGdipSystemColors.GradientInactiveCaption);
   s_colorConstants.Add('GrayText', TGdipSystemColors.GrayText);
   s_colorConstants.Add('Highlight', TGdipSystemColors.Highlight);
   s_colorConstants.Add('HighlightText', TGdipSystemColors.HighlightText);
   s_colorConstants.Add('HotTrack', TGdipSystemColors.HotTrack);
   s_colorConstants.Add('InactiveBorder', TGdipSystemColors.InactiveBorder);
   s_colorConstants.Add('InactiveCaption', TGdipSystemColors.InactiveCaption);
   s_colorConstants.Add('InactiveCaptionText', TGdipSystemColors.InactiveCaptionText);
   s_colorConstants.Add('Info', TGdipSystemColors.Info);
   s_colorConstants.Add('InfoText', TGdipSystemColors.InfoText);
   s_colorConstants.Add('Menu', TGdipSystemColors.Menu);
   s_colorConstants.Add('MenuBar', TGdipSystemColors.MenuBar);
   s_colorConstants.Add('MenuHighlight', TGdipSystemColors.MenuHighlight);
   s_colorConstants.Add('MenuText', TGdipSystemColors.MenuText);
   s_colorConstants.Add('ScrollBar', TGdipSystemColors.ScrollBar);
   s_colorConstants.Add('Window', TGdipSystemColors.Window);
   s_colorConstants.Add('WindowFrame', TGdipSystemColors.WindowFrame);
   s_colorConstants.Add('WindowText', TGdipSystemColors.WindowText);
end;

class destructor TGdipColorTable.DestroyClass();
begin
   FreeAndNil(s_colorConstants);
end;


class function TGdipColorTable.TryGetNamedColor(const name: string; out _result: TGdipColor): Boolean;
begin
   Result := Colors.TryGetValue(name, _result);
end;

class function TGdipColorTable.IsKnownNamedColor(const name: string): Boolean;
begin
   var _: TGdipColor;
   Result := Colors.TryGetValue(name, _);
end;

{$ENDREGION 'TGdipColorTable'}

{$REGION 'TGdipColorConverterCommon'}

type

   { TGdipColorConverterCommon }

   // Minimal color conversion functionality, without a dependency on TypeConverter itself.
   TGdipColorConverterCommon = class sealed (* static *)
      public class function ConvertFromString(const strValue: string; const culture: TFormatSettings): TGdipColor; static;
//      strict private class function PossibleKnownColor(const color: TGdipColor): TGdipColor; static;
//      strict private class function IntFromString(const text: string; const culture: TFormatSettings): Integer; static;
   end;

{ TGdipColorConverterCommon }

class function TGdipColorConverterCommon.ConvertFromString(const strValue: string; const culture: TFormatSettings): TGdipColor;
begin
   raise ENotImplemented.Create('Ainda não fiz isso! TODO:');
////   Assert(culture <> nil);
//
//   var text: string := strValue.Trim();
//   if (text.Length = 0) then
//   begin
//         Exit(TGPColor.Empty);
//   end;
//
//      var c: TGPColor;
//      // First, check to see if this is a standard name.
//      //
//      if (TColorTable.TryGetNamedColor(text, c)) then
//      begin
//            Exit(c);
//      end;
//
//
//   var sep: Char := culture.ListSeparator;
//
//   // If the value is a 6 digit hex number only, then
//   // we want to treat the Alpha as 255, not 0
//   //
//   if (not text.Contains(sep)) then
//   begin
//         // text can be '' (empty quoted string)
//         if (text.Length >= 2) and ((text[0] = '''') or (text[0] = '"')) and (text[0] = text[text.Length - 1]) then
//         begin
//               // In quotes means a named value
//               var colorName: string := text.Substring(1, text.Length - 2);
//               Exit(TGPColor.FromName(colorName));
//         end
//         else
//         begin
//
//            if ((text.Length = 7) and (text[0] = '#')) or ((text.Length = 8) and ((text.StartsWith('0x')) or (text.StartsWith('0X')))) or ((text.Length = 8) and ((text.StartsWith('&h')) or (text.StartsWith('&H')))) then
//            begin
//                  // Note: int.Parse will raise exception if value cannot be converted.
//                  Exit( PossibleKnownColor(TGPColor.FromArgb(Integer($FF000000 or UInt32(IntFromString(text, culture))))));
//            end;
//         end;
//   end;
//
////            // We support 1, 3, or 4 arguments:
////            // 1 -- full ARGB encoded
////            // 3 -- RGB
////            // 4 -- ARGB
////            ReadOnlySpan<char> textSpan = text;
////            Span<Range> tokens = stackalloc Range[5];
////            return textSpan.Split(tokens, sep) switch
////            {
////                1 => PossibleKnownColor(TGPColor.FromArgb(IntFromString(textSpan[tokens[0]], culture))),
////                3 => PossibleKnownColor(TGPColor.FromArgb(IntFromString(textSpan[tokens[0]], culture), IntFromString(textSpan[tokens[1]], culture), IntFromString(textSpan[tokens[2]], culture))),
////                4 => PossibleKnownColor(TGPColor.FromArgb(IntFromString(textSpan[tokens[0]], culture), IntFromString(textSpan[tokens[1]], culture), IntFromString(textSpan[tokens[2]], culture), IntFromString(textSpan[tokens[3]], culture))),
////                _ => throw new ArgumentException(SR.Format(SR.InvalidColor, text)),
////            };
end;

//class function TGdipColorConverterCommon.PossibleKnownColor(const color: TGdipColor): TGdipColor;
//begin
//   // Now check to see if this color matches one of our known colors.
//   // If it does, then substitute it. We can only do this for "Colors"
//   // because system colors morph with user settings.
//   //
//   var targetARGB: Int32 := color.ToArgb();
//
//   for var c: TGdipColor in TGdipColorTable.Colors.Values do
//   begin
//      if (c.ToArgb() = targetARGB) then
//      begin
//         Exit(c);
//      end;
//   end;
//
//   Exit(color);
//end;

//class function TGdipColorConverterCommon.IntFromString(const text: string; const culture: TFormatSettings): Integer;
//begin
//   raise ENotImplemented.Create('Ainda não fiz isso! TODO:');
//
////   text := text.Trim();
////
////
////
////   try
////
////
////         if (text[0] = '#'') then
////         begin
////
////
////
////               Exit(Convert.ToInt32(text.Slice(1).ToString(), 16));
////         end
////         else
////         begin
////
////            if (text.StartsWith('0x', StringComparison.OrdinalIgnoreCase)) or (text.StartsWith('&h', StringComparison.OrdinalIgnoreCase)) then
////            begin
////
////
////
////                  Exit(Convert.ToInt32(text.Slice(2).ToString(), 16));
////            end
////            else
////            begin
////
////
////                  Debug.Assert( <> );
////
////
////                  var formatInfo := TNumberFormatInfo(culture.GetFormat(TypeInfo(TNumberFormatInfo)));
////
////
////                  Exit(int.Parse(text, formatInfo));
////            end;
////         end;
////   except on (Exception e) do
////
////         raise EArgumentException.Create(SR.Format(SR.ConvertInvalidPrimitive, text.ToString(), nameof(Int32)), e);
////   end;
//
//end;
{$ENDREGION 'TGdipColorConverterCommon'}

{$REGION 'TGdipKnownColorTable'}

{ TGdipKnownColorTable }

class constructor TGdipKnownColorTable.CreateClass();
begin
end;

class destructor TGdipKnownColorTable.DestroyClass();
begin
end;

procedure TGdipKnownColorTable.AfterConstruction;
begin
   inherited;
end;

procedure TGdipKnownColorTable.BeforeDestruction;
begin
   inherited;
end;

class function TGdipKnownColorTable.ArgbToKnownColor(const argb: UInt32): TGdipColor;
begin
   Assert((argb and TGdipColor.ARGBAlphaMask) = TGdipColor.ARGBAlphaMask);
   Assert(Length(ColorValueTable) = Length(ColorKindTable));

   for var index: Integer := 1 to Length(ColorValueTable) - 1 do
   begin
      if (ColorKindTable[index] = KnownColorKindWeb) and (ColorValueTable[index] = argb) then
      begin
         Exit(TGdipColor.FromKnownColor(TGdipKnownColor(index)));
      end;
   end;

   // Not a known color
   Exit(TGdipColor.FromArgb(Integer(argb)));
end;

class function TGdipKnownColorTable.KnownColorToArgb(const color: TGdipKnownColor): UInt32;
begin
   Assert((Ord(color) > 0) and (color <= TGdipKnownColor.RebeccaPurple));

   if ColorKindTable[Int32(color)] = KnownColorKindSystem then
      Result := GetSystemColorArgb(color)
   else
      Result := ColorValueTable[Int32(color)];
end;

class function TGdipKnownColorTable.GetSystemColorArgb(const color: TGdipKnownColor): UInt32;
begin
   Assert(TGdipColor.IsKnownColorSystem(color));

   Result := TGdipColorTranslator.COLORREFToARGB(Windows.GetSysColor(Byte(ColorValueTable[int32(color)])));
end;

{$ENDREGION 'TGdipKnownColorTable'}

{$REGION 'TGdipColorTranslator'}

{ TGdipColorTranslator }

class constructor TGdipColorTranslator.CreateClass();
begin
end;

class destructor TGdipColorTranslator.DestroyClass();
begin
end;

procedure TGdipColorTranslator.AfterConstruction;
begin
   inherited;
end;

procedure TGdipColorTranslator.BeforeDestruction;
begin
   inherited;
end;

class function TGdipColorTranslator.COLORREFToARGB(const value: UInt32): UInt32;
begin
   Result := (value shr COLORREF_RedShift and $FF) shl TGdipColor.ARGBRedShift or (value shr COLORREF_GreenShift and $FF) shl TGdipColor.ARGBGreenShift or (value shr COLORREF_BlueShift and $FF) shl TGdipColor.ARGBBlueShift or TGdipColor.ARGBAlphaMask;
end;

class function TGdipColorTranslator.ToWin32(const c: TGdipColor): Integer;
begin


   Exit(c.R shl COLORREF_RedShift or c.G shl COLORREF_GreenShift or c.B shl COLORREF_BlueShift);
end;

class function TGdipColorTranslator.ToOle(const c: TGdipColor): Integer;
begin
   // IMPORTANT: This signature is invoked directly by the runtime marshaler and cannot change without
   // also updating the runtime.

   // This method converts TGdipColor to an OLE_COLOR.
   // https://docs.microsoft.com/openspecs/office_file_formats/ms-oforms/4b8f4be0-3fff-4e42-9fc1-b9fd00251e8e



   if (c.IsKnownColor) and (c.IsSystemColor) then
   begin

         // Unfortunately TGdipKnownColor didn't keep the same ordering as the various GetSysColor()
         // COLOR_ * values, otherwise this could be greatly simplified.



         case (c.ToKnownColor()) of
            TGdipKnownColor.ActiveBorder:
            begin
               Exit(unchecked(Int32($8000000A)));
            end;
            TGdipKnownColor.ActiveCaption:
            begin
               Exit(unchecked(Int32($80000002)));
            end;
            TGdipKnownColor.ActiveCaptionText:
            begin
               Exit(unchecked(Int32($80000009)));
            end;
            TGdipKnownColor.AppWorkspace:
            begin
               Exit(unchecked(Int32($8000000C)));
            end;
            TGdipKnownColor.ButtonFace:
            begin
               Exit(unchecked(Int32($8000000F)));
            end;
            TGdipKnownColor.ButtonHighlight:
            begin
               Exit(unchecked(Int32($80000014)));
            end;
            TGdipKnownColor.ButtonShadow:
            begin
               Exit(unchecked(Int32($80000010)));
            end;
            TGdipKnownColor.Control:
            begin
               Exit(unchecked(Int32($8000000F)));
            end;
            TGdipKnownColor.ControlDark:
            begin
               Exit(unchecked(Int32($80000010)));
            end;
            TGdipKnownColor.ControlDarkDark:
            begin
               Exit(unchecked(Int32($80000015)));
            end;
            TGdipKnownColor.ControlLight:
            begin
               Exit(unchecked(Int32($80000016)));
            end;
            TGdipKnownColor.ControlLightLight:
            begin
               Exit(unchecked(Int32($80000014)));
            end;
            TGdipKnownColor.ControlText:
            begin
               Exit(unchecked(Int32($80000012)));
            end;
            TGdipKnownColor.Desktop:
            begin
               Exit(unchecked(Int32($80000001)));
            end;
            TGdipKnownColor.GradientActiveCaption:
            begin
               Exit(unchecked(Int32($8000001B)));
            end;
            TGdipKnownColor.GradientInactiveCaption:
            begin
               Exit(unchecked(Int32($8000001C)));
            end;
            TGdipKnownColor.GrayText:
            begin
               Exit(unchecked(Int32($80000011)));
            end;
            TGdipKnownColor.Highlight:
            begin
               Exit(unchecked(Int32($8000000D)));
            end;
            TGdipKnownColor.HighlightText:
            begin
               Exit(unchecked(Int32($8000000E)));
            end;
            TGdipKnownColor.HotTrack:
            begin
               Exit(unchecked(Int32($8000001A)));
            end;
            TGdipKnownColor.InactiveBorder:
            begin
               Exit(unchecked(Int32($8000000B)));
            end;
            TGdipKnownColor.InactiveCaption:
            begin
               Exit(unchecked(Int32($80000003)));
            end;
            TGdipKnownColor.InactiveCaptionText:
            begin
               Exit(unchecked(Int32($80000013)));
            end;
            TGdipKnownColor.Info:
            begin
               Exit(unchecked(Int32($80000018)));
            end;
            TGdipKnownColor.InfoText:
            begin
               Exit(unchecked(Int32($80000017)));
            end;
            TGdipKnownColor.Menu:
            begin
               Exit(unchecked(Int32($80000004)));
            end;
            TGdipKnownColor.MenuBar:
            begin
               Exit(unchecked(Int32($8000001E)));
            end;
            TGdipKnownColor.MenuHighlight:
            begin
               Exit(unchecked(Int32($8000001D)));
            end;
            TGdipKnownColor.MenuText:
            begin
               Exit(unchecked(Int32($80000007)));
            end;
            TGdipKnownColor.ScrollBar:
            begin
               Exit(unchecked(Int32($80000000)));
            end;
            TGdipKnownColor.Window:
            begin
               Exit(unchecked(Int32($80000005)));
            end;
            TGdipKnownColor.WindowFrame:
            begin
               Exit(unchecked(Int32($80000006)));
            end;
            TGdipKnownColor.WindowText:
            begin
               Exit(unchecked(Int32($80000008)));
            end;
         end;end;



   Exit(ToWin32(c));
end;

class function TGdipColorTranslator.FromOle(const oleColor: Integer): TGdipColor;
begin
   // IMPORTANT: This signature is invoked directly by the runtime marshaler and cannot change without
   // also updating the runtime.

   if ((oleColor and OleSystemColorFlag) <> 0) then
   begin
      case (oleColor) of
         Int32($8000000A):
         begin
            Exit(TGdipColor.FromKnownColor(TGdipKnownColor.ActiveBorder));
         end;
         Int32($80000002):
         begin
            Exit(TGdipColor.FromKnownColor(TGdipKnownColor.ActiveCaption));
         end;
         Int32($80000009):
         begin
            Exit(TGdipColor.FromKnownColor(TGdipKnownColor.ActiveCaptionText));
         end;
         Int32($8000000C):
         begin
            Exit(TGdipColor.FromKnownColor(TGdipKnownColor.AppWorkspace));
         end;
         Int32($8000000F):
         begin
            Exit(TGdipColor.FromKnownColor(TGdipKnownColor.Control));
         end;
         Int32($80000010):
         begin
            Exit(TGdipColor.FromKnownColor(TGdipKnownColor.ControlDark));
         end;
         Int32($80000015):
         begin
            Exit(TGdipColor.FromKnownColor(TGdipKnownColor.ControlDarkDark));
         end;
         Int32($80000016):
         begin
            Exit(TGdipColor.FromKnownColor(TGdipKnownColor.ControlLight));
         end;
         Int32($80000014):
         begin
            Exit(TGdipColor.FromKnownColor(TGdipKnownColor.ControlLightLight));
         end;
         Int32($80000012):
         begin
            Exit(TGdipColor.FromKnownColor(TGdipKnownColor.ControlText));
         end;
         Int32($80000001):
         begin
            Exit(TGdipColor.FromKnownColor(TGdipKnownColor.Desktop));
         end;
         Int32($8000001B):
         begin
            Exit(TGdipColor.FromKnownColor(TGdipKnownColor.GradientActiveCaption));
         end;
         Int32($8000001C):
         begin
            Exit(TGdipColor.FromKnownColor(TGdipKnownColor.GradientInactiveCaption));
         end;
         Int32($80000011):
         begin
            Exit(TGdipColor.FromKnownColor(TGdipKnownColor.GrayText));
         end;
         Int32($8000000D):
         begin
            Exit(TGdipColor.FromKnownColor(TGdipKnownColor.Highlight));
         end;
         Int32($8000000E):
         begin
            Exit(TGdipColor.FromKnownColor(TGdipKnownColor.HighlightText));
         end;
         Int32($8000001A):
         begin
            Exit(TGdipColor.FromKnownColor(TGdipKnownColor.HotTrack));
         end;
         Int32($8000000B):
         begin
            Exit(TGdipColor.FromKnownColor(TGdipKnownColor.InactiveBorder));
         end;
         Int32($80000003):
         begin
            Exit(TGdipColor.FromKnownColor(TGdipKnownColor.InactiveCaption));
         end;
         Int32($80000013):
         begin
            Exit(TGdipColor.FromKnownColor(TGdipKnownColor.InactiveCaptionText));
         end;
         Int32($80000018):
         begin
            Exit(TGdipColor.FromKnownColor(TGdipKnownColor.Info));
         end;
         Int32($80000017):
         begin
            Exit(TGdipColor.FromKnownColor(TGdipKnownColor.InfoText));
         end;
         Int32($80000004):
         begin
            Exit(TGdipColor.FromKnownColor(TGdipKnownColor.Menu));
         end;
         Int32($8000001E):
         begin
            Exit(TGdipColor.FromKnownColor(TGdipKnownColor.MenuBar));
         end;
         Int32($8000001D):
         begin
            Exit(TGdipColor.FromKnownColor(TGdipKnownColor.MenuHighlight));
         end;
         Int32($80000007):
         begin
            Exit(TGdipColor.FromKnownColor(TGdipKnownColor.MenuText));
         end;
         Int32($80000000):
         begin
            Exit(TGdipColor.FromKnownColor(TGdipKnownColor.ScrollBar));
         end;
         Int32($80000005):
         begin
            Exit(TGdipColor.FromKnownColor(TGdipKnownColor.Window));
         end;
         Int32($80000006):
         begin
            Exit(TGdipColor.FromKnownColor(TGdipKnownColor.WindowFrame));
         end;
         Int32($80000008):
         begin
            Exit(TGdipColor.FromKnownColor(TGdipKnownColor.WindowText));
         end;
      end;
   end;

   // When we don't find a system color, we treat the color as a COLORREF
   Exit(TGdipKnownColorTable.ArgbToKnownColor(COLORREFToARGB(UInt32(oleColor))));
end;

class function TGdipColorTranslator.FromWin32(const win32Color: Integer): TGdipColor;
begin
   Exit(FromOle(win32Color));
end;

class function TGdipColorTranslator.FromHtml(const htmlColor: string): TGdipColor;
begin
   var c: TGdipColor := TGdipColor.Empty;

   // empty color
   if (string.IsNullOrWhiteSpace(htmlColor)) or (htmlColor.Length = 0) then
   begin
      Exit(c);
   end;

   // #RRGGBB or #RGB
   if (htmlColor[0] = '#') and ((htmlColor.Length = 7) or (htmlColor.Length = 4)) then
   begin
      if (htmlColor.Length = 7) then
      begin
         c := TGdipColor.FromArgb(StrToInt('$' + htmlColor.Substring(1, 2)), StrToInt('$' + htmlColor.Substring(3, 2)), StrToInt('$' + htmlColor.Substring(5, 2)));
      end
      else
      begin
         var r: string := htmlColor[1];
         var g: string := htmlColor[2];
         var b: string := htmlColor[3];
         c := TGdipColor.FromArgb(StrToInt('$' + r + r), StrToInt('$' + g + g), StrToInt('$' + b + b));
      end;
   end;

   // special case. Html requires LightGrey, but .NET uses LightGray
   if (c.IsEmpty) and (string.Equals(htmlColor, 'LightGrey')) then
   begin
      c := TGdipColor.LightGray;
   end;

   // System color
   if (c.IsEmpty) then
   begin
      if (s_htmlSysColorTable = nil) then
      begin
         InitializeHtmlSysColorTable();
      end;

         s_htmlSysColorTable.TryGetValue(htmlColor.ToLowerInvariant(), c);
   end;

   // resort to type converter which will handle named colors
   if (c.IsEmpty) then
   begin
      try
         c := TGdipColorConverterCommon.ConvertFromString(htmlColor, FormatSettings);
      except on ex: Exception  do
         raise EArgumentException.Create(ex.Message + ' (htmlColor)');
      end;
   end;

   Exit(c);
end;

class function TGdipColorTranslator.ToHtml(const c: TGdipColor): string;
begin
   var colorString: string := string.Empty;

   if (c.IsEmpty) then
   begin
      Exit(colorString);
   end;

   if (c.IsSystemColor) then
   begin
      case (c.ToKnownColor()) of
         TGdipKnownColor.ActiveBorder:
         begin
            colorString := 'activeborder';
         end;
         TGdipKnownColor.GradientActiveCaption:
         begin
            colorString := 'activecaption';
         end;
         TGdipKnownColor.ActiveCaption:
         begin
            colorString := 'activecaption';
         end;
         TGdipKnownColor.AppWorkspace:
         begin
            colorString := 'appworkspace';
         end;
         TGdipKnownColor.Desktop:
         begin
            colorString := 'background';
         end;
         TGdipKnownColor.Control:
         begin
            colorString := 'buttonface';
         end;
         TGdipKnownColor.ControlLight:
         begin
            colorString := 'buttonface';
         end;
         TGdipKnownColor.ControlDark:
         begin
            colorString := 'buttonshadow';
         end;
         TGdipKnownColor.ControlText:
         begin
            colorString := 'buttontext';
         end;
         TGdipKnownColor.ActiveCaptionText:
         begin
            colorString := 'captiontext';
         end;
         TGdipKnownColor.GrayText:
         begin
            colorString := 'graytext';
         end;
         TGdipKnownColor.HotTrack:
         begin
            colorString := 'highlight';
         end;
         TGdipKnownColor.Highlight:
         begin
            colorString := 'highlight';
         end;
         TGdipKnownColor.MenuHighlight:
         begin
            colorString := 'highlighttext';
         end;
         TGdipKnownColor.HighlightText:
         begin
            colorString := 'highlighttext';
         end;
         TGdipKnownColor.InactiveBorder:
         begin
            colorString := 'inactiveborder';
         end;
         TGdipKnownColor.GradientInactiveCaption:
         begin
            colorString := 'inactivecaption';
         end;
         TGdipKnownColor.InactiveCaption:
         begin
            colorString := 'inactivecaption';
         end;
         TGdipKnownColor.InactiveCaptionText:
         begin
            colorString := 'inactivecaptiontext';
         end;
         TGdipKnownColor.Info:
         begin
            colorString := 'infobackground';
         end;
         TGdipKnownColor.InfoText:
         begin
            colorString := 'infotext';
         end;
         TGdipKnownColor.MenuBar:
         begin
            colorString := 'menu';
         end;
         TGdipKnownColor.Menu:
         begin
            colorString := 'menu';
         end;
         TGdipKnownColor.MenuText:
         begin
            colorString := 'menutext';
         end;
         TGdipKnownColor.ScrollBar:
         begin
            colorString := 'scrollbar';
         end;
         TGdipKnownColor.ControlDarkDark:
         begin
            colorString := 'threeddarkshadow';
         end;
         TGdipKnownColor.ControlLightLight:
         begin
            colorString := 'buttonhighlight';
         end;
         TGdipKnownColor.Window:
         begin
            colorString := 'window';
         end;
         TGdipKnownColor.WindowFrame:
         begin
            colorString := 'windowframe';
         end;
         TGdipKnownColor.WindowText:
         begin
            colorString := 'windowtext';
         end;
      end;
   end
   else
   begin
      if (c.IsNamedColor) then
      begin
         if (c = TGdipColor.LightGray) then
         begin
            // special case due to mismatch between Html and enum spelling
            colorString := 'LightGrey';
         end
         else
         begin
            colorString := c.Name;
         end;
      end
      else
      begin
         colorString := '#' + IntToHex(c.R) + IntToHex(c.G) + IntToHex(c.B);
      end;
   end;

   Exit(colorString);
end;

class procedure TGdipColorTranslator.InitializeHtmlSysColorTable();
begin
   s_htmlSysColorTable := TDictionary<string, TGdipColor>.Create(27);
end;

{$ENDREGION 'TGdipColorTranslator'}

{$REGION 'TGdipColor'}

{ TGdipColor }

class constructor TGdipColor.CreateClass();
begin
   Empty := TGdipColor.Create(0, TGdipColorState.NotDefinedValue, string.Empty, TGdipKnownColor.InvalidNotKnownColor);

   // -------------------------------------------------------------------
   //  static list of "web" colors...
   //
   Transparent := TGdipColor.Create(TGdipKnownColor.Transparent);
   AliceBlue := TGdipColor.Create(TGdipKnownColor.AliceBlue);
   AntiqueWhite := TGdipColor.Create(TGdipKnownColor.AntiqueWhite);
   Aqua := TGdipColor.Create(TGdipKnownColor.Aqua);
   Aquamarine := TGdipColor.Create(TGdipKnownColor.Aquamarine);
   Azure := TGdipColor.Create(TGdipKnownColor.Azure);
   Beige := TGdipColor.Create(TGdipKnownColor.Beige);
   Bisque := TGdipColor.Create(TGdipKnownColor.Bisque);
   Black := TGdipColor.Create(TGdipKnownColor.Black);
   BlanchedAlmond := TGdipColor.Create(TGdipKnownColor.BlanchedAlmond);
   Blue := TGdipColor.Create(TGdipKnownColor.Blue);
   BlueViolet := TGdipColor.Create(TGdipKnownColor.BlueViolet);
   Brown := TGdipColor.Create(TGdipKnownColor.Brown);
   BurlyWood := TGdipColor.Create(TGdipKnownColor.BurlyWood);
   CadetBlue := TGdipColor.Create(TGdipKnownColor.CadetBlue);
   Chartreuse := TGdipColor.Create(TGdipKnownColor.Chartreuse);
   Chocolate := TGdipColor.Create(TGdipKnownColor.Chocolate);
   Coral := TGdipColor.Create(TGdipKnownColor.Coral);
   CornflowerBlue := TGdipColor.Create(TGdipKnownColor.CornflowerBlue);
   Cornsilk := TGdipColor.Create(TGdipKnownColor.Cornsilk);
   Crimson := TGdipColor.Create(TGdipKnownColor.Crimson);
   Cyan := TGdipColor.Create(TGdipKnownColor.Cyan);
   DarkBlue := TGdipColor.Create(TGdipKnownColor.DarkBlue);
   DarkCyan := TGdipColor.Create(TGdipKnownColor.DarkCyan);
   DarkGoldenrod := TGdipColor.Create(TGdipKnownColor.DarkGoldenrod);
   DarkGray := TGdipColor.Create(TGdipKnownColor.DarkGray);
   DarkGreen := TGdipColor.Create(TGdipKnownColor.DarkGreen);
   DarkKhaki := TGdipColor.Create(TGdipKnownColor.DarkKhaki);
   DarkMagenta := TGdipColor.Create(TGdipKnownColor.DarkMagenta);
   DarkOliveGreen := TGdipColor.Create(TGdipKnownColor.DarkOliveGreen);
   DarkOrange := TGdipColor.Create(TGdipKnownColor.DarkOrange);
   DarkOrchid := TGdipColor.Create(TGdipKnownColor.DarkOrchid);
   DarkRed := TGdipColor.Create(TGdipKnownColor.DarkRed);
   DarkSalmon := TGdipColor.Create(TGdipKnownColor.DarkSalmon);
   DarkSeaGreen := TGdipColor.Create(TGdipKnownColor.DarkSeaGreen);
   DarkSlateBlue := TGdipColor.Create(TGdipKnownColor.DarkSlateBlue);
   DarkSlateGray := TGdipColor.Create(TGdipKnownColor.DarkSlateGray);
   DarkTurquoise := TGdipColor.Create(TGdipKnownColor.DarkTurquoise);
   DarkViolet := TGdipColor.Create(TGdipKnownColor.DarkViolet);
   DeepPink := TGdipColor.Create(TGdipKnownColor.DeepPink);
   DeepSkyBlue := TGdipColor.Create(TGdipKnownColor.DeepSkyBlue);
   DimGray := TGdipColor.Create(TGdipKnownColor.DimGray);
   DodgerBlue := TGdipColor.Create(TGdipKnownColor.DodgerBlue);
   Firebrick := TGdipColor.Create(TGdipKnownColor.Firebrick);
   FloralWhite := TGdipColor.Create(TGdipKnownColor.FloralWhite);
   ForestGreen := TGdipColor.Create(TGdipKnownColor.ForestGreen);
   Fuchsia := TGdipColor.Create(TGdipKnownColor.Fuchsia);
   Gainsboro := TGdipColor.Create(TGdipKnownColor.Gainsboro);
   GhostWhite := TGdipColor.Create(TGdipKnownColor.GhostWhite);
   Gold := TGdipColor.Create(TGdipKnownColor.Gold);
   Goldenrod := TGdipColor.Create(TGdipKnownColor.Goldenrod);
   Gray := TGdipColor.Create(TGdipKnownColor.Gray);
   Green := TGdipColor.Create(TGdipKnownColor.Green);
   GreenYellow := TGdipColor.Create(TGdipKnownColor.GreenYellow);
   Honeydew := TGdipColor.Create(TGdipKnownColor.Honeydew);
   HotPink := TGdipColor.Create(TGdipKnownColor.HotPink);
   IndianRed := TGdipColor.Create(TGdipKnownColor.IndianRed);
   Indigo := TGdipColor.Create(TGdipKnownColor.Indigo);
   Ivory := TGdipColor.Create(TGdipKnownColor.Ivory);
   Khaki := TGdipColor.Create(TGdipKnownColor.Khaki);
   Lavender := TGdipColor.Create(TGdipKnownColor.Lavender);
   LavenderBlush := TGdipColor.Create(TGdipKnownColor.LavenderBlush);
   LawnGreen := TGdipColor.Create(TGdipKnownColor.LawnGreen);
   LemonChiffon := TGdipColor.Create(TGdipKnownColor.LemonChiffon);
   LightBlue := TGdipColor.Create(TGdipKnownColor.LightBlue);
   LightCoral := TGdipColor.Create(TGdipKnownColor.LightCoral);
   LightCyan := TGdipColor.Create(TGdipKnownColor.LightCyan);
   LightGoldenrodYellow := TGdipColor.Create(TGdipKnownColor.LightGoldenrodYellow);
   LightGreen := TGdipColor.Create(TGdipKnownColor.LightGreen);
   LightGray := TGdipColor.Create(TGdipKnownColor.LightGray);
   LightPink := TGdipColor.Create(TGdipKnownColor.LightPink);
   LightSalmon := TGdipColor.Create(TGdipKnownColor.LightSalmon);
   LightSeaGreen := TGdipColor.Create(TGdipKnownColor.LightSeaGreen);
   LightSkyBlue := TGdipColor.Create(TGdipKnownColor.LightSkyBlue);
   LightSlateGray := TGdipColor.Create(TGdipKnownColor.LightSlateGray);
   LightSteelBlue := TGdipColor.Create(TGdipKnownColor.LightSteelBlue);
   LightYellow := TGdipColor.Create(TGdipKnownColor.LightYellow);
   Lime := TGdipColor.Create(TGdipKnownColor.Lime);
   LimeGreen := TGdipColor.Create(TGdipKnownColor.LimeGreen);
   Linen := TGdipColor.Create(TGdipKnownColor.Linen);
   Magenta := TGdipColor.Create(TGdipKnownColor.Magenta);
   Maroon := TGdipColor.Create(TGdipKnownColor.Maroon);
   MediumAquamarine := TGdipColor.Create(TGdipKnownColor.MediumAquamarine);
   MediumBlue := TGdipColor.Create(TGdipKnownColor.MediumBlue);
   MediumOrchid := TGdipColor.Create(TGdipKnownColor.MediumOrchid);
   MediumPurple := TGdipColor.Create(TGdipKnownColor.MediumPurple);
   MediumSeaGreen := TGdipColor.Create(TGdipKnownColor.MediumSeaGreen);
   MediumSlateBlue := TGdipColor.Create(TGdipKnownColor.MediumSlateBlue);
   MediumSpringGreen := TGdipColor.Create(TGdipKnownColor.MediumSpringGreen);
   MediumTurquoise := TGdipColor.Create(TGdipKnownColor.MediumTurquoise);
   MediumVioletRed := TGdipColor.Create(TGdipKnownColor.MediumVioletRed);
   MidnightBlue := TGdipColor.Create(TGdipKnownColor.MidnightBlue);
   MintCream := TGdipColor.Create(TGdipKnownColor.MintCream);
   MistyRose := TGdipColor.Create(TGdipKnownColor.MistyRose);
   Moccasin := TGdipColor.Create(TGdipKnownColor.Moccasin);
   NavajoWhite := TGdipColor.Create(TGdipKnownColor.NavajoWhite);
   Navy := TGdipColor.Create(TGdipKnownColor.Navy);
   OldLace := TGdipColor.Create(TGdipKnownColor.OldLace);
   Olive := TGdipColor.Create(TGdipKnownColor.Olive);
   OliveDrab := TGdipColor.Create(TGdipKnownColor.OliveDrab);
   Orange := TGdipColor.Create(TGdipKnownColor.Orange);
   OrangeRed := TGdipColor.Create(TGdipKnownColor.OrangeRed);
   Orchid := TGdipColor.Create(TGdipKnownColor.Orchid);
   PaleGoldenrod := TGdipColor.Create(TGdipKnownColor.PaleGoldenrod);
   PaleGreen := TGdipColor.Create(TGdipKnownColor.PaleGreen);
   PaleTurquoise := TGdipColor.Create(TGdipKnownColor.PaleTurquoise);
   PaleVioletRed := TGdipColor.Create(TGdipKnownColor.PaleVioletRed);
   PapayaWhip := TGdipColor.Create(TGdipKnownColor.PapayaWhip);
   PeachPuff := TGdipColor.Create(TGdipKnownColor.PeachPuff);
   Peru := TGdipColor.Create(TGdipKnownColor.Peru);
   Pink := TGdipColor.Create(TGdipKnownColor.Pink);
   Plum := TGdipColor.Create(TGdipKnownColor.Plum);
   PowderBlue := TGdipColor.Create(TGdipKnownColor.PowderBlue);
   Purple := TGdipColor.Create(TGdipKnownColor.Purple);

   /// <summary>
   /// Gets a system-defined color that has an ARGB value of <c>#663399</c>.
   /// </summary>
   /// <value>A system-defined color.</value>
   RebeccaPurple := TGdipColor.Create(TGdipKnownColor.RebeccaPurple);
   Red := TGdipColor.Create(TGdipKnownColor.Red);
   RosyBrown := TGdipColor.Create(TGdipKnownColor.RosyBrown);
   RoyalBlue := TGdipColor.Create(TGdipKnownColor.RoyalBlue);
   SaddleBrown := TGdipColor.Create(TGdipKnownColor.SaddleBrown);
   Salmon := TGdipColor.Create(TGdipKnownColor.Salmon);
   SandyBrown := TGdipColor.Create(TGdipKnownColor.SandyBrown);
   SeaGreen := TGdipColor.Create(TGdipKnownColor.SeaGreen);
   SeaShell := TGdipColor.Create(TGdipKnownColor.SeaShell);
   Sienna := TGdipColor.Create(TGdipKnownColor.Sienna);
   Silver := TGdipColor.Create(TGdipKnownColor.Silver);
   SkyBlue := TGdipColor.Create(TGdipKnownColor.SkyBlue);
   SlateBlue := TGdipColor.Create(TGdipKnownColor.SlateBlue);
   SlateGray := TGdipColor.Create(TGdipKnownColor.SlateGray);
   Snow := TGdipColor.Create(TGdipKnownColor.Snow);
   SpringGreen := TGdipColor.Create(TGdipKnownColor.SpringGreen);
   SteelBlue := TGdipColor.Create(TGdipKnownColor.SteelBlue);
   Tan := TGdipColor.Create(TGdipKnownColor.Tan);
   Teal := TGdipColor.Create(TGdipKnownColor.Teal);
   Thistle := TGdipColor.Create(TGdipKnownColor.Thistle);
   Tomato := TGdipColor.Create(TGdipKnownColor.Tomato);
   Turquoise := TGdipColor.Create(TGdipKnownColor.Turquoise);
   Violet := TGdipColor.Create(TGdipKnownColor.Violet);
   Wheat := TGdipColor.Create(TGdipKnownColor.Wheat);
   White := TGdipColor.Create(TGdipKnownColor.White);
   WhiteSmoke := TGdipColor.Create(TGdipKnownColor.WhiteSmoke);
   Yellow := TGdipColor.Create(TGdipKnownColor.Yellow);
   YellowGreen := TGdipColor.Create(TGdipKnownColor.YellowGreen);
end;


constructor TGdipColor.Create(const value: Int64; const state: TGdipColorState; const name: string; const knownColor: TGdipKnownColor);
begin
   Self.m_value := value;
   Self.m_state := state;
   Self.m_name := name;
   Self.m_knownColor := Int16(knownColor);
end;

constructor TGdipColor.Create(const knownColor: TGdipKnownColor);
begin
   m_value := 0;
   m_state := TGdipColorState.StateKnownColorValid;
   m_name := string.Empty;
   m_knownColor := unchecked(Int16(knownColor));
end;

function TGdipColor.GetIsEmpty(): Boolean;
begin
   Result := m_state = TGdipColorState.NotDefinedValue;
end;

function TGdipColor.GetName(): string;
begin
   if (m_state and TGdipColorState.StateNameValid) <> 0 then
   begin
      Assert(not string.IsNullOrWhiteSpace(m_name));
      Exit(m_name);
   end;

   if (IsKnownColor) then
   begin
         var tablename: string := TGdipKnownColorNames.KnownColorToName(TGdipKnownColor(m_knownColor));
         Assert(not string.IsNullOrWhiteSpace(tablename), 'Could not find known color ' + TGdipKnownColor(m_knownColor).ToString() + ' in the TGdipKnownColorTable');

         Exit(tablename);
   end;

   // if we reached here, just encode the value
   //
   Result := '$' + m_value.ToHexString();
end;

function TGdipColor.GetIsNamedColor(): Boolean;
begin
   Result := ((m_state and TGdipColorState.StateNameValid) <> 0) or (IsKnownColor);
end;

class function TGdipColor.FromArgb(const argb: UInt32): TGdipColor;
begin
   Result := TGdipColor.Create(argb, TGdipColorState.StateARGBValueValid,  string.Empty, TGdipKnownColor(0));
end;

class procedure TGdipColor.CheckByte(const value: Integer; const name: string);

      procedure ThrowOutOfByteRange(const v: Integer; const n: string);
      begin
         EArgumentException.Create(Format('Valor de ''%d'' não é válido para ''%s''. ''%s'' deve ser maior ou igual a ''%d'' e menor ou igual a ''%d''.', [v, n, n, byte.MinValue, byte.MaxValue]));
      end;

begin
   if UInt32(value) > byte.MaxValue then
      ThrowOutOfByteRange(value, name);
end;

class function TGdipColor.FromArgb(const argb: Integer): TGdipColor;
begin
   Result := FromArgb(UInt32(argb));
end;

class function TGdipColor.FromArgb(const alpha: Integer; const red: Integer; const green: Integer; const blue: Integer): TGdipColor;
begin
   CheckByte(alpha, 'alpha');
   CheckByte(red, 'red');
   CheckByte(green, 'green');
   CheckByte(blue, 'blue');
   Exit(FromArgb(UInt32(alpha) shl ARGBAlphaShift or UInt32(red) shl ARGBRedShift or UInt32(green) shl ARGBGreenShift or UInt32(blue) shl ARGBBlueShift));
end;

class function TGdipColor.FromArgb(const alpha: Integer; const baseColor: TGdipColor): TGdipColor;
begin
   CheckByte(alpha, 'alpha');
   Exit(FromArgb(UInt32(UInt32(alpha) shl ARGBAlphaShift or UInt32(baseColor.Value) and not ARGBAlphaMask)));
end;

class function TGdipColor.FromName(const name: string): TGdipColor;
var
   color: TGdipColor;
begin
   // try to get a known color first
   if (TGdipColorTable.TryGetNamedColor(name, color)) then
   begin
      Result := color;
   end
   else
   begin
      // otherwise treat it as a named color
      Result := TGdipColor.Create(TGdipColorState.NotDefinedValue, TGdipColorState.StateNameValid, name, TGdipKnownColor.InvalidNotKnownColor);
   end;
end;

class function TGdipColor.FromArgb(const red: Integer; const green: Integer; const blue: Integer): TGdipColor;
begin
   Result := FromArgb(byte.MaxValue, red, green, blue);
end;

//class function TGdipColor.CreateFromColorRef(const ColorRef: TColorRef): TGdipColor;
//begin
//  Result.SetColorRef(ColorRef);
//end;

//constructor TGdipColor.Create(const R, G, B: Byte);
//begin
//  Result.m_value := MakeARGB(255, R, G, B);
//end;
//
//class function TGdipColor.Create(const A, R, G, B: Byte): TGdipColor;
//begin
//  Result.m_value := MakeARGB(A, R, G, B);
//end;

function TGdipColor.GetA: Byte;
begin
  Result := Byte(Value shr ARGBAlphaShift);
end;

function TGdipColor.GetB: Byte;
begin
  Result := Byte(Value shr ARGBBlueShift);
end;

//function TGdipColor.GetColorRef: TColorRef;
//begin
//  Result := GetRed or (GetGreen shl 8) or (GetBlue shl 16);
//end;

function TGdipColor.GetG: Byte;
begin
  Result := Byte(Value shr ARGBGreenShift);
end;

function TGdipColor.GetR: Byte;
begin
  Result := Byte(Value shr ARGBRedShift);
end;

//procedure TGdipColor.Initialize(const R, G, B: Byte);
//begin
//  m_value := MakeARGB(255, R, G, B);
//end;

function TGdipColor.ToArgb(): Int32;
begin
   Result := Int32(Value);
end;

function TGdipColor.ToKnownColor(): TGdipKnownColor;
begin
   Result := TGdipKnownColor(m_knownColor);
end;

class function TGdipColor.IsKnownColorSystem(const knownColor: TGdipKnownColor): Boolean;
begin
   Result := TGdipKnownColorTable.ColorKindTable[int32(knownColor)] = TGdipKnownColorTable.KnownColorKindSystem;
end;

class function TGdipColor.FromKnownColor(const color: TGdipKnownColor): TGdipColor;
begin
   if (Ord(color) <= 0) or (color > TGdipKnownColor.RebeccaPurple) then
      Result := FromName(color.ToString())
   else
      Result := TGdipColor.Create(color);
end;

function TGdipColor.GetValue(): Int64;
begin
   if (m_state and TGdipColorState.StateValueMask) <> 0 then
      Exit(m_value);

   // This is the only place we have system colors m_value exposed
   if (IsKnownColor) then
      Exit(TGdipKnownColorTable.KnownColorToArgb(TGdipKnownColor(m_knownColor)));

   Result := TGdipColorState.NotDefinedValue;
end;

function TGdipColor.GetIsKnownColor(): Boolean;
begin
   Result := (m_state and TGdipColorState.StateKnownColorValid) <> 0;
end;

function TGdipColor.GetIsSystemColor(): Boolean;
begin
   Result := IsKnownColor and (((TGdipKnownColor(m_knownColor)) <= TGdipKnownColor.WindowText) or ((TGdipKnownColor(m_knownColor)) > TGdipKnownColor.YellowGreen));
end;

function TGdipColor.ToString(): string;
begin
   if IsNamedColor then
      Result := Format('%s [%s]', [PTypeInfo(TypeInfo(TGdipColor))^.Name, Name])
   else if (m_state and TGdipColorState.StateValueMask) <> 0 then
      Result := Format('%s [A=%d, R=%d, G=%d, B=%d]', [PTypeInfo(TypeInfo(TGdipColor))^.Name, A, R, G, B])
   else
      Result := Format('%s [Empty]', [PTypeInfo(TypeInfo(TGdipColor))^.Name]);
end;

class operator TGdipColor.Equal(const left: TGdipColor; const right: TGdipColor): Boolean;
begin
   Result := (left.m_value = right.m_value) and (left.m_state = right.m_state) and (left.m_knownColor = right.m_knownColor) and (left.m_name = right.m_name);
end;

class operator TGdipColor.NotEqual(const left: TGdipColor; const right: TGdipColor): Boolean;
begin
   Result := not (left = right);
end;

function TGdipColor.Equals(const other: TGdipColor): Boolean;
begin
   Result := Self = other;
end;

//procedure TGdipColor.SetAlpha(const Value: Byte);
//begin
//  m_value := (m_value and (not ARGBAlphaMask)) or (Value shl ARGBAlphaShift);
//end;
//
//procedure TGdipColor.SetBlue(const Value: Byte);
//begin
//  m_value := (m_value and (not ARGBBlueMask)) or (Value shl ARGBBlueShift);
//end;
//
//procedure TGdipColor.SetGreen(const Value: Byte);
//begin
//  m_value := (m_value and (not ARGBGreenMask)) or (Value shl ARGBGreenShift);
//end;
//
//procedure TGdipColor.SetRed(const Value: Byte);
//begin
//  m_value := (m_value and (not ARGBRedMask)) or (Value shl ARGBRedShift);
//end;

//class function TGdipColor.GetEmpty(): TGdipColor;
//begin
//   Result := Default(TGdipColor);
//   Result.m_state := TGdipColorState.NotDefinedValue;
//end;

{$ENDREGION 'TGdipColor'}

{$REGION 'TGdipKnownColorHelper'}

function TGdipKnownColorHelper.ToString(): string;
begin
   Result := GetEnumName(TypeInfo(TGdipKnownColor), Ord(Self));
end;

{$ENDREGION 'TGdipKnownColorHelper'}

{$REGION 'TGdipSystemColors'}

{ TGdipSystemColors }

class constructor TGdipSystemColors.CreateClass();
begin
   ActiveBorder := TGdipColor.FromKnownColor(TGdipKnownColor.ActiveBorder);
   ActiveCaption := TGdipColor.FromKnownColor(TGdipKnownColor.ActiveCaption);
   ActiveCaptionText := TGdipColor.FromKnownColor(TGdipKnownColor.ActiveCaptionText);
   AppWorkspace := TGdipColor.FromKnownColor(TGdipKnownColor.AppWorkspace);

   ButtonFace := TGdipColor.FromKnownColor(TGdipKnownColor.ButtonFace);
   ButtonHighlight := TGdipColor.FromKnownColor(TGdipKnownColor.ButtonHighlight);
   ButtonShadow := TGdipColor.FromKnownColor(TGdipKnownColor.ButtonShadow);

   Control := TGdipColor.FromKnownColor(TGdipKnownColor.Control);
   ControlDark := TGdipColor.FromKnownColor(TGdipKnownColor.ControlDark);
   ControlDarkDark := TGdipColor.FromKnownColor(TGdipKnownColor.ControlDarkDark);
   ControlLight := TGdipColor.FromKnownColor(TGdipKnownColor.ControlLight);
   ControlLightLight := TGdipColor.FromKnownColor(TGdipKnownColor.ControlLightLight);
   ControlText := TGdipColor.FromKnownColor(TGdipKnownColor.ControlText);

   Desktop := TGdipColor.FromKnownColor(TGdipKnownColor.Desktop);

   GradientActiveCaption := TGdipColor.FromKnownColor(TGdipKnownColor.GradientActiveCaption);
   GradientInactiveCaption := TGdipColor.FromKnownColor(TGdipKnownColor.GradientInactiveCaption);
   GrayText := TGdipColor.FromKnownColor(TGdipKnownColor.GrayText);

   Highlight := TGdipColor.FromKnownColor(TGdipKnownColor.Highlight);
   HighlightText := TGdipColor.FromKnownColor(TGdipKnownColor.HighlightText);
   HotTrack := TGdipColor.FromKnownColor(TGdipKnownColor.HotTrack);

   InactiveBorder := TGdipColor.FromKnownColor(TGdipKnownColor.InactiveBorder);
   InactiveCaption := TGdipColor.FromKnownColor(TGdipKnownColor.InactiveCaption);
   InactiveCaptionText := TGdipColor.FromKnownColor(TGdipKnownColor.InactiveCaptionText);
   Info := TGdipColor.FromKnownColor(TGdipKnownColor.Info);
   InfoText := TGdipColor.FromKnownColor(TGdipKnownColor.InfoText);

   Menu := TGdipColor.FromKnownColor(TGdipKnownColor.Menu);
   MenuBar := TGdipColor.FromKnownColor(TGdipKnownColor.MenuBar);
   MenuHighlight := TGdipColor.FromKnownColor(TGdipKnownColor.MenuHighlight);
   MenuText := TGdipColor.FromKnownColor(TGdipKnownColor.MenuText);

   ScrollBar := TGdipColor.FromKnownColor(TGdipKnownColor.ScrollBar);

   Window := TGdipColor.FromKnownColor(TGdipKnownColor.Window);
   WindowFrame := TGdipColor.FromKnownColor(TGdipKnownColor.WindowFrame);
   WindowText := TGdipColor.FromKnownColor(TGdipKnownColor.WindowText);
end;

{$ENDREGION 'TGdipSystemColors'}

{$REGION 'TArgbHelper'}

{ TArgbHelper }

constructor TArgbHelper.Create(const a: Byte; const r: Byte; const g: Byte; const b: Byte);
begin
   //Debug.Assert(BitConverter.IsLittleEndian);
//   Unsafe.SkipInit(Self);
   Self.A := a;
   Self.R := r;
   Self.G := g;
   Self.B := b;
end;

constructor TArgbHelper.Create(const value: UInt32);
begin
//   Debug.Assert(BitConverter.IsLittleEndian);
//   Unsafe.SkipInit(Self);
   Self.Value := value;
end;

class function TArgbHelper.ToColorArray(const argbColors: TReadOnlySpan<TARGB>): TArray<TGdipColor>;
begin
   var colors: TArray<TGdipColor>;
   SetLength(colors, argbColors.Length);

   for var i: Integer := 0 to argbColors.Length - 1 do
   begin
      colors[i] := argbColors[i];
   end;

   Exit(colors);
end;

class function TArgbHelper.ToColorArray(const argbColors: TReadOnlySpan<UInt32>): TArray<TGdipColor>;
begin
   Result := ToColorArray(TReadOnlySpan<TARGB>.Create(argbColors.GetPinnableReference, argbColors.Length));
end;

class operator TArgb.implicit(const color: TGdipColor): TARGB;
begin
   Result := TARGB.Create(UInt32(color.ToArgb()));
end;

class operator TArgb.implicit(const color: UInt32): TARGB;
begin
   Result := TARGB.Create(color);
end;

class operator TArgb.implicit(const argb: TARGB): TGdipColor;
begin
   Result := TGdipColor.FromArgb(Integer(argb.Value));
end;

class operator TArgb.implicit(const argb: TARGB): UInt32;
begin
   Result := argb.Value;
end;

{$ENDREGION 'TArgbHelper'}


end.
