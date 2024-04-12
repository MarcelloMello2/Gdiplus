// Marcelo Melo
// 17/03/2024

unit Se7e.Windows.Win32.Graphics.GdiplusAPI;

{$SCOPEDENUMS ON}
{$ZEROBASEDSTRINGS ON}
{$ALIGN 8}
{$MINENUMSIZE 4}

{$IFDEF FPC}
{$MODE DELPHI}
{$ENDIF}


interface

uses
   System.SysUtils,
   System.Math,
   System.StrUtils,
   System.Classes,
   Winapi.ActiveX,
   Winapi.Windows,
   System.Types,
   Se7e.Drawing.Rectangle;

type

  PUInt16 = ^UInt16;

   { TGdiplusAPI }

   /// <content>
	/// Contains extern methods from "gdiplus.dll".
	/// </content>
   TGdiplusAPI = record (*static*)
	   public const PixelFormatIndexed    = $00010000;  // Indexes into a palette
	   public const PixelFormatGDI        = $00020000; // Is a GDI-supported format
	   public const PixelFormatAlpha      = $00040000; // Has an alpha component
	   public const PixelFormatPAlpha     = $00080000; // Pre-multiplied alpha
	   public const PixelFormatExtended   = $00100000; // Extended color 16 bits/channel
	   public const PixelFormatCanonical  = $00200000;

	   public const PixelFormatUndefined  = 0;
	   public const PixelFormatDontCare   = 0;

	   public const PixelFormat1bppIndexed    = (1 or ( 1 shl 8) or PixelFormatIndexed or PixelFormatGDI);
	   public const PixelFormat4bppIndexed    = (2 or ( 4 shl 8) or PixelFormatIndexed or PixelFormatGDI);
	   public const PixelFormat8bppIndexed    = (3 or ( 8 shl 8) or PixelFormatIndexed or PixelFormatGDI);
	   public const PixelFormat16bppGrayScale = (4 or (16 shl 8) or PixelFormatExtended);
	   public const PixelFormat16bppRGB555    = (5 or (16 shl 8) or PixelFormatGDI);
	   public const PixelFormat16bppRGB565    = (6 or (16 shl 8) or PixelFormatGDI);
	   public const PixelFormat16bppARGB1555  = (7 or (16 shl 8) or PixelFormatAlpha or PixelFormatGDI);
	   public const PixelFormat24bppRGB       = (8 or (24 shl 8) or PixelFormatGDI);
	   public const PixelFormat32bppRGB       = (9 or (32 shl 8) or PixelFormatGDI);
	   public const PixelFormat32bppARGB      = (10 or (32 shl 8) or PixelFormatAlpha or PixelFormatGDI or PixelFormatCanonical);
	   public const PixelFormat32bppPARGB     = (11 or (32 shl 8) or PixelFormatAlpha or PixelFormatPAlpha or PixelFormatGDI);
	   public const PixelFormat48bppRGB       = (12 or (48 shl 8) or PixelFormatExtended);
	   public const PixelFormat64bppARGB      = (13 or (64 shl 8) or PixelFormatAlpha  or PixelFormatCanonical or PixelFormatExtended);
	   public const PixelFormat64bppPARGB     = (14 or (64 shl 8) or PixelFormatAlpha  or PixelFormatPAlpha or PixelFormatExtended);
	   public const PixelFormat32bppCMYK      = (15 or (32 shl 8));
	   public const PixelFormatMax            = 16;


      strict private class constructor CreateClass;
      strict private class destructor DestroyClass;
      strict private class function GetFunctionAddress(const ProcName: string): Pointer; static;

      public type

            TGdipPathPtr = type Pointer;
            TGdipFontFamilyPtr = type Pointer;
            TGdipStringFormatPtr = type Pointer;
            TGdipBitmapDataPtr = ^TGdipNativeBitmapData;
            TGdipGraphicsPtr = type Pointer;
            TGdipBitmapPtr = type Pointer;
            TGdipEffectPtr = type Pointer;
            TGdipColorPalettePtr = ^TGdipNativeColorPalette;
            TGdipBrushPtr = type Pointer;
            TGdipCustomLineCapPtr = type Pointer;
            TGdipFontPtr = type Pointer;
            TGdipImagePtr = type Pointer;
            TGdipImageAttributesPtr = type Pointer;
            TGdipMatrixPtr = type Pointer;
            TGdipPenPtr = type Pointer;
            TGdipRegionPtr = type Pointer;
            TGdipAdjustableArrowCapPtr = type Pointer;
            TGdipCachedBitmapPtr = type Pointer;
            TGdipFontCollectionPtr = type Pointer;
            TGdipHatchPtr = type Pointer;
            TGdipLineGradientPtr = type Pointer;
            TGdipMetafilePtr = type Pointer;
            TGdipWmfPlaceableFileHeaderPtr = ^TGdipNativeWmfPlaceableFileHeader;
            TGdipPathGradientPtr = type Pointer;
            TGdipPathIteratorPtr = type Pointer;
            TGdipSolidFillPtr = type Pointer;
            TGdipTexturePtr = type Pointer;
            TGdipPropertyItemPtr = ^TGdipNativePropertyItem;
            TGdipEncoderParametersPtr = ^TGdipNativeEncoderParameters;
            TGdipImageCodecInfoPtr = ^TGdipNativeImageCodecInfo;
            TGdipMetafileHeaderPtr = ^TGdipNativeMetafileHeader;
            TGdipPathDataPtr = ^TGdipNativePathData;
            TGdipColorMatrixPtr = type Pointer;
            TGdipColorMapPtr = ^TGdipNativeColorMap;
            TGdipCharacterRangePtr = type Pointer;
            TGdipEncoderParameterPtr = ^TGdipNativeEncoderParameter;

            { TGdipNativeColorMap }

            TGdipNativeColorMap = record
                OldColor: UInt32;
                NewColor: UInt32;
            end;


            { TGdipPixelFormatEnum }

            TGdipPixelFormatEnum = type UInt32;
            TGdipPixelFormatEnumHelper = record helper for TGdipPixelFormatEnum
                 public const Indexed     = PixelFormatIndexed;
                 public const GDI         = PixelFormatGDI;
                 public const Alpha       = PixelFormatAlpha;
                 public const PAlpha      = PixelFormatPAlpha;
                 public const Extended    = PixelFormatExtended;
                 public const Canonical   = PixelFormatCanonical;

                 public const Undefined      = PixelFormatUndefined;
                 public const DontCare       = PixelFormatDontCare;

                 public const Format1bppIndexed    = PixelFormat1bppIndexed;
                 public const Format4bppIndexed    = PixelFormat4bppIndexed;
                 public const Format8bppIndexed    = PixelFormat8bppIndexed;
                 public const Format16bppGrayScale = PixelFormat16bppGrayScale;
                 public const Format16bppRGB555    = PixelFormat16bppRGB555;
                 public const Format16bppRGB565    = PixelFormat16bppRGB565;
                 public const Format16bppARGB1555  = PixelFormat16bppARGB1555;
                 public const Format24bppRGB       = PixelFormat24bppRGB;
                 public const Format32bppRGB       = PixelFormat32bppRGB;
                 public const Format32bppARGB      = PixelFormat32bppARGB;
                 public const Format32bppPARGB     = PixelFormat32bppPARGB;
                 public const Format48bppRGB       = PixelFormat48bppRGB;
                 public const Format64bppARGB      = PixelFormat64bppARGB;
                 public const Format64bppPARGB     = PixelFormat64bppPARGB;
	              public const Format32bppCMYK      = PixelFormat32bppCMYK;
                 public const Max                  = PixelFormatMax;
            end;

  TGdipPaletteFlagEnum = (
    PaletteFlagsHasAlpha    = 0,
    PaletteFlagsGrayScale   = 1,
    PaletteFlagsHalftone    = 2,
    PaletteFlagsReserved    = 31);
  TGdipPaletteFlags = set of TGdipPaletteFlagEnum;

            { TGdipNativeColorPalette }

            TGdipNativeColorPalette = record
               Flags  : TGdipPaletteFlags;                 // Palette flags
               Count  : UINT;                 // Number of color entries
               Entries: array[0..0] of UINT32; // Palette color entries
            end;


            { TGdipNativeBitmapData }

            TGdipNativeBitmapData = packed record
               Width       : UINT;
               Height      : UINT;
               Stride      : Integer;
               PixelFormat : TGdipPixelFormatEnum;
               Scan0       : Pointer;
               Reserved    : UINT_PTR;
            end;


            { TGdipEnhMetaHeader3 }

            TGdipEnhMetaHeader3 = record
                iType: DWORD;               // Record type EMR_HEADER
                nSize: DWORD;               // Record size in bytes.  This may be greater
                                            // than the sizeof(ENHMETAHEADER).
                rclBounds: Winapi.Windows.TRect;   // Inclusive-inclusive bounds in device units
                rclFrame: Winapi.Windows.TRect;    // Inclusive-inclusive Picture Frame .01mm unit
                dSignature: DWORD;          // Signature.  Must be ENHMETA_SIGNATURE.
                nVersion: DWORD;            // Version number
                nBytes: DWORD;              // Size of the metafile in bytes
                nRecords: DWORD;            // Number of records in the metafile
                nHandles: WORD;             // Number of handles in the handle table
                                            // Handle index zero is reserved.
                sReserved: WORD;            // Reserved.  Must be zero.
                nDescription: DWORD;        // Number of chars in the unicode desc string
                                            // This is 0 if there is no description string
                offDescription: DWORD;      // Offset to the metafile description record.
                                            // This is 0 if there is no description string
                nPalEntries: DWORD;         // Number of entries in the metafile palette.
                szlDevice: Winapi.Windows.TSize;   // Size of the reference device in pels
                szlMillimeters: Winapi.Windows.TSize; // Size of the reference device in millimeters
             end;

            { TGdipNativeWmfRect16 }

            TGdipNativeWmfRect16 = packed record
                Left: Int16;
                Top: Int16;
                Right: Int16;
                Bottom: Int16;
            end;

            { TGdipNativeWmfPlaceableFileHeader }

            TGdipNativeWmfPlaceableFileHeader = packed record
                Key: UInt32;                 // GDIP_WMF_PLACEABLEKEY
                Hmf: Int16;                  // Metafile HANDLE number (always 0)
                BoundingBox: TGdipNativeWmfRect16;    // Coordinates in metafile units
                Inch: Int16;                 // Number of metafile units per inch
                Reserved: UInt32;            // Reserved (always 0)
                Checksum: Int16;             // Checksum value for previous 10 WORDs
            end;

            { TGdipMetafileTypeEnum }

            TGdipMetafileTypeEnum = (
               Invalid = 0,      // Invalid metafile
               Wmf = 1,          // Standard WMF
               WmfPlaceable = 2, // Placeable WMF
               Emf = 3,          // EMF (not EMF+)
               EmfPlusOnly = 4,  // EMF+ without dual, down-level records
               EmfPlusDual = 5   // EMF+ with dual, down-level records
            );

            { TGdipNativeMetafileHeader }

            TGdipNativeMetafileHeader = record
                Type_: TGdipMetafileTypeEnum;
                Size: UInt32;    // Size of the metafile (in bytes)
                Version: UInt32; // EMF+, EMF, or WMF version
                EmfPlusFlags: UInt32;
                DpiX: Single;
                DpiY: Single;
                X: Int32;        // Bounds in device units
                Y: Int32;
                Width: Int32;
                Height: Int32;
                Header: record case Integer of
                                   0: (WmfHeader: Winapi.Windows.TMetaHeader);
                                   1: (EmfHeader: TGdipEnhMetaHeader3);
                                end;
                EmfPlusHeaderSize: Integer; // size of the EMF+ header in file
                LogicalDpiX: Integer;       // Logical Dpi of reference Hdc
                LogicalDpiY: Integer;       // usually valid only for EMF+
            end;

            { TGdipNativeEncoderParameterValueType }

            TGdipNativeEncoderParameterValueType = (
               ValueTypeByte           = 1,    // 8-bit unsigned int
               ValueTypeASCII          = 2,    // 8-bit byte containing one 7-bit ASCII
                                                       // code. NULL terminated.
               ValueTypeShort          = 3,    // 16-bit unsigned int
               ValueTypeLong           = 4,    // 32-bit unsigned int
               ValueTypeRational       = 5,    // Two Longs. The first Long is the
                                                       // numerator, the second Long expresses the
                                                       // denomintor.
               ValueTypeLongRange      = 6,    // Two longs which specify a range of
                                                       // integer values. The first Long specifies
                                                       // the lower end and the second one
                                                       // specifies the higher end. All values
                                                       // are inclusive at both ends
               ValueTypeUndefined      = 7,    // 8-bit byte that can take any value
                                                       // depending on field definition
               ValueTypeRationalRange  = 8,    // Two Rationals. The first Rational
                                                       // specifies the lower end and the second
                                                       // specifies the higher end. All values
                                                       // are inclusive at both ends
               ValueTypePointer        = 9     // a pointer to a parameter defined data.
            );


            { TGdipNativeEncoderParameterStructure }

            TGdipNativeEncoderParameterPtr = ^TGdipNativeEncoderParameter;
            TGdipNativeEncoderParameter = record
               Guid           : TGUID;                                  // GUID of the parameter
               NumberOfValues : ULONG;                                  // Number of the parameter values
               ValueType      : TGdipNativeEncoderParameterValueType;   // Value type, like ValueTypeLONG  etc.
               Value          : Pointer;                                // A pointer to the parameter values
            end;

            { TGdipNativeEncoderParametersStructure }

            TGdipNativeEncoderParameters = record
               Count     : Cardinal;               // Number of parameters in this structure
               Parameter : array[0..0] of TGdipNativeEncoderParameter;  // Parameter values
            end;


            { TGdipPropertyItemNativeStructure }

            TGdipNativePropertyItem = record // NOT PACKED !!
               id       : PROPID;  // ID of this property
               length   : ULONG;   // Length of the property value, in bytes
               type_    : WORD;    // Type of the value, as one of TAG_TYPE_XXX
               value    : Pointer; // property value
            end;

            { TGdipImageCodecFlag }

            // Information flags about image codecs
            TGdipImageCodecFlag = (
               ImageCodecFlagsEncoder            = 0,
               ImageCodecFlagsDecoder            = 1,
               ImageCodecFlagsSupportBitmap      = 2,
               ImageCodecFlagsSupportVector      = 3,
               ImageCodecFlagsSeekableEncode     = 4,
               ImageCodecFlagsBlockingDecode     = 5,

               ImageCodecFlagsBuiltin            = 16,
               ImageCodecFlagsSystem             = 17,
               ImageCodecFlagsUser               = 18);
            TGdipImageCodecFlags = set of TGdipImageCodecFlag;


            { TGdipNativeImageCodecInfo }

            TGdipNativeImageCodecInfo = record // NOT PACKED !!
               Clsid             : TGUID;   // Codec identifier.
               FormatID          : TGUID;   // File format identifier. GUIDs that identify various file formats (ImageFormatBMP, ImageFormatEMF, and the like) are defined in Gdiplusimaging.h.
               CodecName         : PWideChar;  // Pointer to a null-terminated string that contains the codec name.
               DllName           : PWideChar;  // Pointer to a null-terminated string that contains the path name of the DLL in which the codec resides. If the codec is not in a DLL, this pointer is NULL.
               FormatDescription : PWideChar;  // Pointer to a null-terminated string that contains the name of the file format used by the codec.
               FilenameExtension : PWideChar;  // Pointer to a null-terminated string that contains all file-name extensions associated with the codec. The extensions are separated by semicolons.
               MimeType          : PWideChar;  // Pointer to a null-terminated string that contains the mime type of the codec.
               Flags             : TGdipImageCodecFlags;   // Combination of flags from the ImageCodecFlags enumeration.
               Version           : DWORD;   // Integer that indicates the version of the codec.
               SigCount          : DWORD;   // Integer that indicates the number of signatures used by the file format associated with the codec.
               SigSize           : DWORD;   // Integer that indicates the number of bytes in each signature.
               SigPattern        : PBYTE;   // Pointer to an array of bytes that contains the pattern for each signature.
               SigMask           : PBYTE;   // Pointer to an array of bytes that contains the mask for each signature.
            end;

            { TGpPathData }

            TGdipNativePathData = packed record
               public Count: Integer;
               public Points: PPointF;
               public Types: PByte;
            end;


            { TGdipStatusEnum }

            TGdipStatusEnum = type UInt32;

            { TGdipStatusEnumHelper }

            TGdipStatusEnumHelper = record helper for TGdipStatusEnum
               const Ok = TGdipStatusEnum(0);
               const GenericError = TGdipStatusEnum(1);
               const InvalidParameter = TGdipStatusEnum(2);
               const OutOfMemory = TGdipStatusEnum(3);
               const ObjectBusy = TGdipStatusEnum(4);
               const InsufficientBuffer = TGdipStatusEnum(5);
               const NotImplemented = TGdipStatusEnum(6);
               const Win32Error = TGdipStatusEnum(7);
               const WrongState = TGdipStatusEnum(8);
               const Aborted = TGdipStatusEnum(9);
               const FileNotFound = TGdipStatusEnum(10);
               const ValueOverflow = TGdipStatusEnum(11);
               const AccessDenied = TGdipStatusEnum(12);
               const UnknownImageFormat = TGdipStatusEnum(13);
               const FontFamilyNotFound = TGdipStatusEnum(14);
               const FontStyleNotFound = TGdipStatusEnum(15);
               const NotTrueTypeFont = TGdipStatusEnum(16);
               const UnsupportedGdiplusVersion = TGdipStatusEnum(17);
               const GdiplusNotInitialized = TGdipStatusEnum(18);
               const PropertyNotFound = TGdipStatusEnum(19);
               const PropertyNotSupported = TGdipStatusEnum(20);
               const ProfileNotFound = TGdipStatusEnum(21);

               public procedure ThrowIfFailed();
               public procedure RaiseIfFailed();
               public function GetException(): Exception;
               public function ToString(): string;
               public function ToMessageString(): string;
            end;


            { TGdipUnitEnum }

            TGdipUnitEnum = (
               World = 0,      // 0 -- World coordinate (non-physical unit)
               Display = 1,    // 1 -- Variable -- for PageTransform only
               Pixel = 2,      // 2 -- Each unit is one device pixel.
               Point = 3,      // 3 -- Each unit is a printer's point, or 1/72 inch.
               Inch = 4,       // 4 -- Each unit is 1 inch.
               Document = 5,   // 5 -- Each unit is 1/300 inch.
               Millimeter = 6  // 6 -- Each unit is 1 millimeter.
            );



            { TGdipDitherTypeEnum }

            TGdipDitherTypeEnum = (
               None = 0,
               Solid = 1,
               Ordered4x4 = 2,
               Ordered8x8 = 3,
               Ordered16x16 = 4,
               Spiral4x4 = 5,
               Spiral8x8 = 6,
               DualSpiral4x4 = 7,
               DualSpiral8x8 = 8,
               ErrorDiffusion = 9,
               Max = 10
            );

            { TGdipStringFormatFlagsEnum }


            //---------------------------------------------------------------------------
            // String format flags
            //
            //  DirectionRightToLeft          - For horizontal text, the reading order is
            //                                  right to left. This value is called
            //                                  the base embedding level by the Unicode
            //                                  bidirectional engine.
            //                                  For vertical text, columns are read from
            //                                  right to left.
            //                                  By default, horizontal or vertical text is
            //                                  read from left to right.
            //
            //  DirectionVertical             - Individual lines of text are vertical. In
            //                                  each line, characters progress from top to
            //                                  bottom.
            //                                  By default, lines of text are horizontal,
            //                                  each new line below the previous line.
            //
            //  NoFitBlackBox                 - Allows parts of glyphs to overhang the
            //                                  bounding rectangle.
            //                                  By default glyphs are first aligned
            //                                  inside the margines, then any glyphs which
            //                                  still overhang the bounding box are
            //                                  repositioned to avoid any overhang.
            //                                  For example when an italic
            //                                  lower case letter f in a font such as
            //                                  Garamond is aligned at the far left of a
            //                                  rectangle, the lower part of the f will
            //                                  reach slightly further left than the left
            //                                  edge of the rectangle. Setting this flag
            //                                  will ensure the character aligns visually
            //                                  with the lines above and below, but may
            //                                  cause some pixels outside the formatting
            //                                  rectangle to be clipped or painted.
            //
            //  DisplayFormatControl          - Causes control characters such as the
            //                                  left-to-right mark to be shown in the
            //                                  output with a representative glyph.
            //
            //  NoFontFallback                - Disables fallback to alternate fonts for
            //                                  characters not supported in the requested
            //                                  font. Any missing characters will be
            //                                  be displayed with the fonts missing glyph,
            //                                  usually an open square.
            //
            //  NoWrap                        - Disables wrapping of text between lines
            //                                  when formatting within a rectangle.
            //                                  NoWrap is implied when a point is passed
            //                                  instead of a rectangle, or when the
            //                                  specified rectangle has a zero line length.
            //
            //  NoClip                        - By default text is clipped to the
            //                                  formatting rectangle. Setting NoClip
            //                                  allows overhanging pixels to affect the
            //                                  device outside the formatting rectangle.
            //                                  Pixels at the end of the line may be
            //                                  affected if the glyphs overhang their
            //                                  cells, and either the NoFitBlackBox flag
            //                                  has been set, or the glyph extends to far
            //                                  to be fitted.
            //                                  Pixels above/before the first line or
            //                                  below/after the last line may be affected
            //                                  if the glyphs extend beyond their cell
            //                                  ascent / descent. This can occur rarely
            //                                  with unusual diacritic mark combinations.

            //---------------------------------------------------------------------------

            TGdipStringFormatFlagsEnum = type UInt32;
            TGdipStringFormatFlagsEnumHelper = record helper for TGdipStringFormatFlagsEnum
               public const DirectionRightToLeft        = UInt32($00000001);
               public const DirectionVertical           = UInt32($00000002);
               public const NoFitBlackBox               = UInt32($00000004);
               public const DisplayFormatControl        = UInt32($00000020);
               public const NoFontFallback              = UInt32($00000400);
               public const MeasureTrailingSpaces       = UInt32($00000800);
               public const NoWrap                      = UInt32($00001000);
               public const LineLimit                   = UInt32($00002000);

               public const NoClip                      = UInt32($00004000);
               public const BypassGDI                   = UInt32($80000000);
            end;

            { TGdipHistogramFormatEnum }

            //----------------------------------------------------------------------------
            // Per-channel Histogram for 8bpp images.
            //----------------------------------------------------------------------------
            TGdipHistogramFormatEnum =
            (
               ARGB,
               PARGB,
               RGB,
               Gray,
               B,
               G,
               R,
               A
            );

            { TGdipPaletteTypeEnum }

            TGdipPaletteTypeEnum = (
               Custom = 0,
               Optimal = 1,
               FixedBW = 2,
               FixedHalftone8 = 3,
               FixedHalftone27 = 4,
               FixedHalftone64 = 5,
               FixedHalftone125 = 6,
               FixedHalftone216 = 7,
               FixedHalftone252 = 8,
               FixedHalftone256 = 9
            );

            { TGdipCombineModeEnum }

            TGdipCombineModeEnum = (
               Replace = 0,
               Intersect = 1,
               Union = 2,
               Xor_ = 3,
               Exclude = 4,
               Complement = 5
            );

            { TGdipLineCapEnum }

            TGdipLineCapEnum = (
               Flat = 0,
               Square = 1,
               Round = 2,
               Triangle = 3,
               NoAnchor = 16,
               SquareAnchor = 17,
               RoundAnchor = 18,
               DiamondAnchor = 19,
               ArrowAnchor = 20,
               Custom = 255,
               AnchorMask = 240
            );

            TGdipImageLockModeEnum = (
               Read = UInt32($0001),
               Write = UInt32($0002),
               UserInputBuf = UInt32($0004)
            );



            { TGdipHatchStyleEnum }

            TGdipHatchStyleEnum = (
               Horizontal = 0,
               Vertical = 1,
               ForwardDiagonal = 2,
               BackwardDiagonal = 3,
               Cross = 4,
               DiagonalCross = 5,
               Percent05 = 6,
               Percent10 = 7,
               Percent20 = 8,
               Percent25 = 9,
               Percent30 = 10,
               Percent40 = 11,
               Percent50 = 12,
               Percent60 = 13,
               Percent70 = 14,
               Percent75 = 15,
               Percent80 = 16,
               Percent90 = 17,
               LightDownwardDiagonal = 18,
               LightUpwardDiagonal = 19,
               DarkDownwardDiagonal = 20,
               DarkUpwardDiagonal = 21,
               WideDownwardDiagonal = 22,
               WideUpwardDiagonal = 23,
               LightVertical = 24,
               LightHorizontal = 25,
               NarrowVertical = 26,
               NarrowHorizontal = 27,
               DarkVertical = 28,
               DarkHorizontal = 29,
               DashedDownwardDiagonal = 30,
               DashedUpwardDiagonal = 31,
               DashedHorizontal = 32,
               DashedVertical = 33,
               SmallConfetti = 34,
               LargeConfetti = 35,
               ZigZag = 36,
               Wave = 37,
               DiagonalBrick = 38,
               HorizontalBrick = 39,
               Weave = 40,
               Plaid = 41,
               Divot = 42,
               DottedGrid = 43,
               DottedDiamond = 44,
               Shingle = 45,
               Trellis = 46,
               Sphere = 47,
               SmallGrid = 48,
               SmallCheckerBoard = 49,
               LargeCheckerBoard = 50,
               OutlinedDiamond = 51,
               SolidDiamond = 52,
               Total = 53,
               LargeGrid = 4,
               Min = 0,
               Max = 52
            );

            { TGdipWrapModeEnum }

            TGdipWrapModeEnum = (
               Tile = 0,
               TileFlipX = 1,
               TileFlipY = 2,
               TileFlipXY = 3,
               Clamp = 4
            );

            { TGdipLinearGradientModeEnum }

            TGdipLinearGradientModeEnum = (
               Horizontal = 0,
               Vertical = 1,
               ForwardDiagonal = 2,
               BackwardDiagonal = 3
            );

            { TGdipFillModeEnum }

            TGdipFillModeEnum = (
               Alternate = 0,
               Winding = 1
            );

            { TGdipFlushIntentionEnum }

            TGdipFlushIntentionEnum = (
               Flush = 0,
               Sync = 1
            );

            { TGdipCompositingModeEnum }

            TGdipCompositingModeEnum = (
               SourceOver = 0,
               SourceCopy = 1
            );

            { TGdipQualityModeEnum }

            TGdipQualityModeEnum = (
               Invalid   = -1,
               Default   = 0,
               Low       = 1, // Best performance
               High      = 2  // Best rendering quality
            );


            { TGdipCompositingQualityEnum }

            TGdipCompositingQualityEnum = (
               Invalid = Ord(TGdipQualityModeEnum.Invalid),
               Default = Ord(TGdipQualityModeEnum.Default),
               HighSpeed = Ord(TGdipQualityModeEnum.Low),
               HighQuality = Ord(TGdipQualityModeEnum.High),
               GammaCorrected,
               AssumeLinear
            );

            { TGdipLineJoinEnum }

            TGdipLineJoinEnum = (
               Miter = 0,
               Bevel = 1,
               Round = 2,
               MiterClipped = 3
            );

            { TGdipCustomLineCapTypeEnum }

            TGdipCustomLineCapTypeEnum = (
               Default = 0,
               AdjustableArrow = 1
            );

            { TGdipColorAdjustTypeEnum }

            TGdipColorAdjustTypeEnum = (
               Default = 0,
               Bitmap = 1,
               Brush = 2,
               Pen = 3,
               Text = 4,
               Count = 5,
               Any = 6
            );

            { TGdipImageTypeEnum }

            TGdipImageTypeEnum = (
               Unknown = 0,
               Bitmap = 1,
               Metafile = 2
            );


            { TGdipInterpolationModeEnum }

            TGdipInterpolationModeEnum = (
               Invalid = -1,
               Default = 0,
               LowQuality = 1,
               HighQuality = 2,
               Bilinear = 3,
               Bicubic = 4,
               NearestNeighbor = 5,
               HighQualityBilinear = 6,
               HighQualityBicubic = 7
            );

            { TGdipDashCapEnum }

            TGdipDashCapEnum = (
               Flat = 0,
               Round = 2,
               Triangle = 3
            );

            { TGdipDashStyleEnum }

            TGdipDashStyleEnum = (
               Solid = 0,
               Dash = 1,
               Dot = 2,
               DashDot = 3,
               DashDotDot = 4,
               Custom = 5
            );

            { TGdipPenTypeEnum }

            TGdipPenTypeEnum = (
               SolidColor = 0,
               HatchFill = 1,
               TextureFill = 2,
               PathGradient = 3,
               LinearGradient = 4,
               Unknown = -1
            );

            { TGdipPenAlignmentEnum }

            TGdipPenAlignmentEnum = (
               Center = 0,
               Inset = 1
            );

            { TGdipPixelOffsetModeEnum }

            TGdipPixelOffsetModeEnum = (
               Invalid = -1,
               Default = 0,
               HighSpeed = 1,
               HighQuality = 2,
               None = 3,
               Half = 4
            );

            { TGdipSmoothingModeEnum }

            TGdipSmoothingModeEnum = (
               Invalid = -1,
               Default = 0,
               HighSpeed = 1,
               HighQuality = 2,
               None = 3,
               AntiAlias8x4 = 4,
               AntiAlias8x8 = 5
            );

            { TGdipStringAlignmentEnum }

            TGdipStringAlignmentEnum = (
               Near = 0,
               Center = 1,
               Far = 2
            );

            { TGdipHotkeyPrefixEnum }

            TGdipHotkeyPrefixEnum = (
               None = 0,
               Show = 1,
               Hide = 2
            );



            { TGdipStringDigitSubstituteEnum }

            PGdipStringDigitSubstituteEnum = ^TGdipStringDigitSubstituteEnum;
            TGdipStringDigitSubstituteEnum = (
               User = 0,
               None = 1,
               National = 2,
               Traditional = 3
            );

            { TGdipStringTrimmingEnum }

            TGdipStringTrimmingEnum = (
               None = 0,
               Character = 1,
               Word = 2,
               EllipsisCharacter = 3,
               EllipsisWord = 4,
               EllipsisPath = 5
            );

            { TGdipTextRenderingHintEnum }

            TGdipTextRenderingHintEnum = (
               SystemDefault = 0,
               SingleBitPerPixelGridFit = 1,
               SingleBitPerPixel = 2,
               AntiAliasGridFit = 3,
               AntiAlias = 4,
               ClearTypeGridFit = 5
            );

            { TGdipRotateFlipTypeEnum }

            TGdipRotateFlipTypeEnum = (
               RotateNoneFlipNone = 0,
               Rotate90FlipNone = 1,
               Rotate180FlipNone = 2,
               Rotate270FlipNone = 3,
               RotateNoneFlipX = 4,
               Rotate90FlipX = 5,
               Rotate180FlipX = 6,
               Rotate270FlipX = 7,
               RotateNoneFlipY = 6,
               Rotate90FlipY = 7,
               Rotate180FlipY = 4,
               Rotate270FlipY = 5,
               RotateNoneFlipXY = 2,
               Rotate90FlipXY = 3,
               Rotate180FlipXY = 0,
               Rotate270FlipXY = 1
            );

            { TGdiplusDebugEventLevel }

            TGdiplusDebugEventLevel = (
               Fatal,
               Warning
            );


            TGdiplusImageAbort = function(CallbackData: Pointer): BOOL; stdcall;
            TGdiplusDrawImageAbort = TGdiplusImageAbort;
            TGdiplusGetThumbnailImageAbort = TGdiplusImageAbort;


            // Callback function that GDI+ can call, on debug builds, for assertions
            // and warnings.

            TGdiplusDebugEventProc = procedure(level: TGdiplusDebugEventLevel; message: PAnsiChar); stdcall;

            // Notification functions which the user must call appropriately if
            // "SuppressBackgroundThread" (below) is set.

            TGdiplusNotificationHookProc = function(out token: NativeUInt): TGdipStatusEnum; stdcall;
            TGdiplusNotificationUnhookProc = procedure(token: NativeUInt); stdcall;

            { TGdiplusStartupParamsFlags }

            TGdiplusStartupParamsFlags = type Int32;
            TGdiplusStartupParamsFlagsHelper = record helper for TGdiplusStartupParamsFlags
                const Default: Int32    = Int32($00000000);
                const NoSetRound: Int32 = Int32($00000001);
                const SetPSValue: Int32 = Int32($00000002);
                const Reserved0: Int32  = Int32($00000004);
                const TransparencyMask: Int32 = Int32($FF000000);
            end;

            { TGdiplusVersionEnum }

            TGdiplusVersionEnum = (
               V1 = 1,
               V2 = 2,
               V3 = 3 // Habilita codecs de imagem Heif e Avif. Ao contrário de outras funcionalidades do Gdiplus,
                      // esses dois codecs exigem que o COM seja inicializado.
            );


            // Input structure for GdiplusStartup()

            { TGdiplusStartupInput }

            PGdiplusStartupInput = ^TGdiplusStartupInput;
            TGdiplusStartupInput = record
               GdiplusVersion: TGdiplusVersionEnum;         // Must be 1  (or 2 for the Ex version)
               DebugEventCallback: TGdiplusDebugEventProc;  // Ignored on free builds
               SuppressBackgroundThread: LongBool;          // FALSE unless you're prepared to call
                                                            // the hook/unhook functions properly
               SuppressExternalCodecs: LongBool;            // FALSE unless you want GDI+ only to use
            end;                                            // its internal image codecs.

            { TGdiplusStartupInputEx }

            TGdiplusStartupInputEx = record
               Base: TGdiplusStartupInput;   // Do we not set the FPU rounding mode
               StartupParameters: TGdiplusStartupParamsFlags;
               class function GetDefault(): TGdiplusStartupInputEx; static;
            end;


            // Output structure for GdiplusStartup()

            { TGdiplusStartupOutput }

            TGdiplusStartupOutput = record
               // The following 2 fields are NULL if SuppressBackgroundThread is FALSE.
               // Otherwise, they are functions which must be called appropriately to
               // replace the background thread.
               //
               // These should be called on the application's main message loop - i.e.
               // a message loop which is active for the lifetime of GDI+.
               // "NotificationHook" should be called before starting the loop,
               // and "NotificationUnhook" should be called after the loop ends.

               NotificationHook: TGdiplusNotificationHookProc;
               NotificationUnhook: TGdiplusNotificationUnhookProc;
            end;

            { TGdipMatrixOrderEnum }

            TGdipMatrixOrderEnum = (
               Prepend = 0,
               Append = 1
            );

            TGdipEmfPlusRecordTypeEnum = (
               SetBkColor = 66049,
               SetBkMode = 65794,
               SetMapMode = 65795,
               SetROP2 = 65796,
               SetRelAbs = 65797,
               SetPolyFillMode = 65798,
               SetStretchBltMode = 65799,
               SetTextCharExtra = 65800,
               SetTextColor = 66057,
               SetTextJustification = 66058,
               SetWindowOrg = 66059,
               SetWindowExt = 66060,
               SetViewportOrg = 66061,
               SetViewportExt = 66062,
               OffsetWindowOrg = 66063,
               ScaleWindowExt = 66576,
               OffsetViewportOrg = 66065,
               ScaleViewportExt = 66578,
               LineTo = 66067,
               MoveTo = 66068,
               ExcludeClipRect = 66581,
               IntersectClipRect = 66582,
               Arc = 67607,
               Ellipse = 66584,
               FloodFill = 66585,
               Pie = 67610,
               Rectangle = 66587,
               RoundRect = 67100,
               PatBlt = 67101,
               SaveDC = 65566,
               SetPixel = 66591,
               OffsetClipRgn = 66080,
               TextOut = 66849,
               BitBlt = 67874,
               StretchBlt = 68387,
               Polygon = 66340,
               Polyline = 66341,
               Escape = 67110,
               RestoreDC = 65831,
               FillRegion = 66088,
               FrameRegion = 66601,
               InvertRegion = 65834,
               PaintRegion = 65835,
               SelectClipRegion = 65836,
               SelectObject = 65837,
               SetTextAlign = 65838,
               DrawText = 67119,
               Chord = 67632,
               SetMapperFlags = 66097,
               ExtTextOut = 68146,
               SetDIBToDev = 68915,
               SelectPalette = 66100,
               RealizePalette = 65589,
               AnimatePalette = 66614,
               SetPalEntries = 65591,
               PolyPolygon = 66872,
               ResizePalette = 65849,
               DIBBitBlt = 67904,
               DIBStretchBlt = 68417,
               DIBCreatePatternBrush = 65858,
               StretchDIB = 69443,
               ExtFloodFill = 66888,
               SetLayout = 65865,
               ResetDC = 65868,
               StartDoc = 65869,
               StartPage = 65615,
               EndPage = 65616,
               AbortDoc = 65618,
               EndDoc = 65630,
               DeleteObject = 66032,
               CreatePalette = 65783,
               CreateBrush = 65784,
               CreatePatternBrush = 66041,
               CreatePenIndirect = 66298,
               CreateFontIndirect = 66299,
               CreateBrushIndirect = 66300,
               CreateBitmapIndirect = 66301,
               CreateBitmap = 67326,
               CreateRegion = 67327,
               EmfRecordTypeHeader = 1,
               EmfRecordTypePolyBezier = 2,
               EmfRecordTypePolygon = 3,
               EmfRecordTypePolyline = 4,
               EmfRecordTypePolyBezierTo = 5,
               EmfRecordTypePolyLineTo = 6,
               EmfRecordTypePolyPolyline = 7,
               EmfRecordTypePolyPolygon = 8,
               EmfRecordTypeSetWindowExtEx = 9,
               EmfRecordTypeSetWindowOrgEx = 10,
               EmfRecordTypeSetViewportExtEx = 11,
               EmfRecordTypeSetViewportOrgEx = 12,
               EmfRecordTypeSetBrushOrgEx = 13,
               EmfRecordTypeEOF = 14,
               EmfRecordTypeSetPixelV = 15,
               EmfRecordTypeSetMapperFlags = 16,
               EmfRecordTypeSetMapMode = 17,
               EmfRecordTypeSetBkMode = 18,
               EmfRecordTypeSetPolyFillMode = 19,
               EmfRecordTypeSetROP2 = 20,
               EmfRecordTypeSetStretchBltMode = 21,
               EmfRecordTypeSetTextAlign = 22,
               EmfRecordTypeSetColorAdjustment = 23,
               EmfRecordTypeSetTextColor = 24,
               EmfRecordTypeSetBkColor = 25,
               EmfRecordTypeOffsetClipRgn = 26,
               EmfRecordTypeMoveToEx = 27,
               EmfRecordTypeSetMetaRgn = 28,
               EmfRecordTypeExcludeClipRect = 29,
               EmfRecordTypeIntersectClipRect = 30,
               EmfRecordTypeScaleViewportExtEx = 31,
               EmfRecordTypeScaleWindowExtEx = 32,
               EmfRecordTypeSaveDC = 33,
               EmfRecordTypeRestoreDC = 34,
               EmfRecordTypeSetWorldTransform = 35,
               EmfRecordTypeModifyWorldTransform = 36,
               EmfRecordTypeSelectObject = 37,
               EmfRecordTypeCreatePen = 38,
               EmfRecordTypeCreateBrushIndirect = 39,
               EmfRecordTypeDeleteObject = 40,
               EmfRecordTypeAngleArc = 41,
               EmfRecordTypeEllipse = 42,
               EmfRecordTypeRectangle = 43,
               EmfRecordTypeRoundRect = 44,
               EmfRecordTypeArc = 45,
               EmfRecordTypeChord = 46,
               EmfRecordTypePie = 47,
               EmfRecordTypeSelectPalette = 48,
               EmfRecordTypeCreatePalette = 49,
               EmfRecordTypeSetPaletteEntries = 50,
               EmfRecordTypeResizePalette = 51,
               EmfRecordTypeRealizePalette = 52,
               EmfRecordTypeExtFloodFill = 53,
               EmfRecordTypeLineTo = 54,
               EmfRecordTypeArcTo = 55,
               EmfRecordTypePolyDraw = 56,
               EmfRecordTypeSetArcDirection = 57,
               EmfRecordTypeSetMiterLimit = 58,
               EmfRecordTypeBeginPath = 59,
               EmfRecordTypeEndPath = 60,
               EmfRecordTypeCloseFigure = 61,
               EmfRecordTypeFillPath = 62,
               EmfRecordTypeStrokeAndFillPath = 63,
               EmfRecordTypeStrokePath = 64,
               EmfRecordTypeFlattenPath = 65,
               EmfRecordTypeWidenPath = 66,
               EmfRecordTypeSelectClipPath = 67,
               EmfRecordTypeAbortPath = 68,
               EmfRecordTypeReserved_069 = 69,
               EmfRecordTypeGdiComment = 70,
               EmfRecordTypeFillRgn = 71,
               EmfRecordTypeFrameRgn = 72,
               EmfRecordTypeInvertRgn = 73,
               EmfRecordTypePaintRgn = 74,
               EmfRecordTypeExtSelectClipRgn = 75,
               EmfRecordTypeBitBlt = 76,
               EmfRecordTypeStretchBlt = 77,
               EmfRecordTypeMaskBlt = 78,
               EmfRecordTypePlgBlt = 79,
               EmfRecordTypeSetDIBitsToDevice = 80,
               EmfRecordTypeStretchDIBits = 81,
               EmfRecordTypeExtCreateFontIndirect = 82,
               EmfRecordTypeExtTextOutA = 83,
               EmfRecordTypeExtTextOutW = 84,
               EmfRecordTypePolyBezier16 = 85,
               EmfRecordTypePolygon16 = 86,
               EmfRecordTypePolyline16 = 87,
               EmfRecordTypePolyBezierTo16 = 88,
               EmfRecordTypePolylineTo16 = 89,
               EmfRecordTypePolyPolyline16 = 90,
               EmfRecordTypePolyPolygon16 = 91,
               EmfRecordTypePolyDraw16 = 92,
               EmfRecordTypeCreateMonoBrush = 93,
               EmfRecordTypeCreateDIBPatternBrushPt = 94,
               EmfRecordTypeExtCreatePen = 95,
               EmfRecordTypePolyTextOutA = 96,
               EmfRecordTypePolyTextOutW = 97,
               EmfRecordTypeSetICMMode = 98,
               EmfRecordTypeCreateColorSpace = 99,
               EmfRecordTypeSetColorSpace = 100,
               EmfRecordTypeDeleteColorSpace = 101,
               EmfRecordTypeGLSRecord = 102,
               EmfRecordTypeGLSBoundedRecord = 103,
               EmfRecordTypePixelFormat = 104,
               EmfRecordTypeDrawEscape = 105,
               EmfRecordTypeExtEscape = 106,
               EmfRecordTypeStartDoc = 107,
               EmfRecordTypeSmallTextOut = 108,
               EmfRecordTypeForceUFIMapping = 109,
               EmfRecordTypeNamedEscape = 110,
               EmfRecordTypeColorCorrectPalette = 111,
               EmfRecordTypeSetICMProfileA = 112,
               EmfRecordTypeSetICMProfileW = 113,
               EmfRecordTypeAlphaBlend = 114,
               EmfRecordTypeSetLayout = 115,
               EmfRecordTypeTransparentBlt = 116,
               EmfRecordTypeReserved_117 = 117,
               EmfRecordTypeGradientFill = 118,
               EmfRecordTypeSetLinkedUFIs = 119,
               EmfRecordTypeSetTextJustification = 120,
               EmfRecordTypeColorMatchToTargetW = 121,
               EmfRecordTypeCreateColorSpaceW = 122,
               EmfRecordTypeMax = 122,
               EmfRecordTypeMin = 1,
               EmfPlusRecordTypeInvalid = 16384,
               EmfPlusRecordTypeHeader = 16385,
               EmfPlusRecordTypeEndOfFile = 16386,
               EmfPlusRecordTypeComment = 16387,
               EmfPlusRecordTypeGetDC = 16388,
               EmfPlusRecordTypeMultiFormatStart = 16389,
               EmfPlusRecordTypeMultiFormatSection = 16390,
               EmfPlusRecordTypeMultiFormatEnd = 16391,
               EmfPlusRecordTypeObject = 16392,
               EmfPlusRecordTypeClear = 16393,
               EmfPlusRecordTypeFillRects = 16394,
               EmfPlusRecordTypeDrawRects = 16395,
               EmfPlusRecordTypeFillPolygon = 16396,
               EmfPlusRecordTypeDrawLines = 16397,
               EmfPlusRecordTypeFillEllipse = 16398,
               EmfPlusRecordTypeDrawEllipse = 16399,
               EmfPlusRecordTypeFillPie = 16400,
               EmfPlusRecordTypeDrawPie = 16401,
               EmfPlusRecordTypeDrawArc = 16402,
               EmfPlusRecordTypeFillRegion = 16403,
               EmfPlusRecordTypeFillPath = 16404,
               EmfPlusRecordTypeDrawPath = 16405,
               EmfPlusRecordTypeFillClosedCurve = 16406,
               EmfPlusRecordTypeDrawClosedCurve = 16407,
               EmfPlusRecordTypeDrawCurve = 16408,
               EmfPlusRecordTypeDrawBeziers = 16409,
               EmfPlusRecordTypeDrawImage = 16410,
               EmfPlusRecordTypeDrawImagePoints = 16411,
               EmfPlusRecordTypeDrawString = 16412,
               EmfPlusRecordTypeSetRenderingOrigin = 16413,
               EmfPlusRecordTypeSetAntiAliasMode = 16414,
               EmfPlusRecordTypeSetTextRenderingHint = 16415,
               EmfPlusRecordTypeSetTextContrast = 16416,
               EmfPlusRecordTypeSetInterpolationMode = 16417,
               EmfPlusRecordTypeSetPixelOffsetMode = 16418,
               EmfPlusRecordTypeSetCompositingMode = 16419,
               EmfPlusRecordTypeSetCompositingQuality = 16420,
               EmfPlusRecordTypeSave = 16421,
               EmfPlusRecordTypeRestore = 16422,
               EmfPlusRecordTypeBeginContainer = 16423,
               EmfPlusRecordTypeBeginContainerNoParams = 16424,
               EmfPlusRecordTypeEndContainer = 16425,
               EmfPlusRecordTypeSetWorldTransform = 16426,
               EmfPlusRecordTypeResetWorldTransform = 16427,
               EmfPlusRecordTypeMultiplyWorldTransform = 16428,
               EmfPlusRecordTypeTranslateWorldTransform = 16429,
               EmfPlusRecordTypeScaleWorldTransform = 16430,
               EmfPlusRecordTypeRotateWorldTransform = 16431,
               EmfPlusRecordTypeSetPageTransform = 16432,
               EmfPlusRecordTypeResetClip = 16433,
               EmfPlusRecordTypeSetClipRect = 16434,
               EmfPlusRecordTypeSetClipPath = 16435,
               EmfPlusRecordTypeSetClipRegion = 16436,
               EmfPlusRecordTypeOffsetClip = 16437,
               EmfPlusRecordTypeDrawDriverString = 16438,
               EmfPlusRecordTypeStrokeFillPath = 16439,
               EmfPlusRecordTypeSerializableObject = 16440,
               EmfPlusRecordTypeSetTSGraphics = 16441,
               EmfPlusRecordTypeSetTSClip = 16442,
               EmfPlusRecordTotal = 16443,
               EmfPlusRecordTypeMax = 16442,
               EmfPlusRecordTypeMin = 16385
            );

            { TGdipEmfTypeEnum }

            TGdipEmfTypeEnum = (
               EmfOnly = Ord(TGdipMetafileTypeEnum.Emf),                 // no EMF+, only EMF
               EmfPlusOnly = Ord(TGdipMetafileTypeEnum.EmfPlusOnly),     // no EMF, only EMF+
               EmfPlusDual = Ord(TGdipMetafileTypeEnum.EmfPlusDual)     // both EMF+ and EMF
            );


            { TGdipMetafileFrameUnitEnum }

            TGdipMetafileFrameUnitEnum = (
               Pixel = Ord(TGdipUnitEnum.Pixel),
               Point = Ord(TGdipUnitEnum.Point),
               Inch = Ord(TGdipUnitEnum.Inch),
               Document = Ord(TGdipUnitEnum.Document),
               Millimeter = Ord(TGdipUnitEnum.Millimeter),
               Gdi
            );

            { TGdipColorMatrixFlagEnum }

            TGdipColorMatrixFlagEnum = (
               Default = 0,
               SkipGrays = 1,
               AltGray = 2
            );


            { TGdipColorChannelFlagsEnum }

            TGdipColorChannelFlagsEnum = (
               ColorChannelFlagsC = 0,
               ColorChannelFlagsM = 1,
               ColorChannelFlagsY = 2,
               ColorChannelFlagsK = 3,
               ColorChannelFlagsLast = 4
            );

            { TGdipCoordinateSpaceEnum }

            TGdipCoordinateSpaceEnum = (
               World = 0,
               Page = 1,
               Device = 2
            );

            { TGdipWarpModeEnum }

            TGdipWarpModeEnum = (
               Perspective = 0,
               Bilinear = 1
            );

            { ImageFormat GUIDs }

      public const ImageFormatUndefinedGuid: TGUID = '{B96B3CA9-0728-11D3-9D7B-0000F81EF32E}';
      public const ImageFormatMemoryBMP: TGUID = '{B96B3CAA-0728-11D3-9D7B-0000F81EF32E}';
      public const ImageFormatBMP: TGUID = '{B96B3CAB-0728-11D3-9D7B-0000F81EF32E}';
      public const ImageFormatEMF: TGUID = '{B96B3CAC-0728-11D3-9D7B-0000F81EF32E}';
      public const ImageFormatWMF: TGUID = '{B96B3CAD-0728-11D3-9D7B-0000F81EF32E}';
      public const ImageFormatJPEG: TGUID = '{B96B3CAE-0728-11D3-9D7B-0000F81EF32E}';
      public const ImageFormatPNG: TGUID = '{B96B3CAF-0728-11D3-9D7B-0000F81EF32E}';
      public const ImageFormatGIF: TGUID = '{B96B3CB0-0728-11D3-9D7B-0000F81EF32E}';
      public const ImageFormatTIFF: TGUID = '{B96B3CB1-0728-11D3-9D7B-0000F81EF32E}';
      public const ImageFormatEXIF: TGUID = '{B96B3CB2-0728-11D3-9D7B-0000F81EF32E}';
      public const ImageFormatIcon: TGUID = '{B96B3CB5-0728-11D3-9D7B-0000F81EF32E}';
      public const ImageFormatHEIF: TGUID = '{B96B3CB6-0728-11D3-9D7B-0000F81EF32E}';
      public const ImageFormatWEBP: TGUID = '{B96B3CB7-0728-11D3-9D7B-0000F81EF32E}';

      public class var GdipAddPathArc: function( path: TGdipPathPtr; x: Single; y: Single; width: Single; height: Single; startAngle: Single; sweepAngle: Single): TGdipStatusEnum; stdcall;
      public class var GdipAddPathBezier: function( path: TGdipPathPtr; x1: Single; y1: Single; x2: Single; y2: Single; x3: Single; y3: Single; x4: Single; y4: Single): TGdipStatusEnum; stdcall;
      public class var GdipAddPathBeziers: function( path: TGdipPathPtr; points: PPointF; count: Integer): TGdipStatusEnum; stdcall;
      public class var GdipAddPathBeziersI: function( path: TGdipPathPtr; points: PPoint; count: Integer): TGdipStatusEnum; stdcall;
      public class var GdipAddPathClosedCurve2: function( path: TGdipPathPtr; points: PPointF; count: Integer; tension: Single): TGdipStatusEnum; stdcall;
      public class var GdipAddPathClosedCurve2I: function( path: TGdipPathPtr; points: PPoint; count: Integer; tension: Single): TGdipStatusEnum; stdcall;
      public class var GdipAddPathCurve2: function( path: TGdipPathPtr; points: PPointF; count: Integer; tension: Single): TGdipStatusEnum; stdcall;
      public class var GdipAddPathCurve2I: function( path: TGdipPathPtr; points: PPoint; count: Integer; tension: Single): TGdipStatusEnum; stdcall;
      public class var GdipAddPathCurve3: function( path: TGdipPathPtr; points: PPointF; count: Integer; offset: Integer; numberOfSegments: Integer; tension: Single): TGdipStatusEnum; stdcall;
      public class var GdipAddPathCurve3I: function( path: TGdipPathPtr; points: PPoint; count: Integer; offset: Integer; numberOfSegments: Integer; tension: Single): TGdipStatusEnum; stdcall;
      public class var GdipAddPathEllipse: function( path: TGdipPathPtr; x: Single; y: Single; width: Single; height: Single): TGdipStatusEnum; stdcall;
      public class var GdipAddPathLine: function( path: TGdipPathPtr; x1: Single; y1: Single; x2: Single; y2: Single): TGdipStatusEnum; stdcall;
      public class var GdipAddPathLine2: function( path: TGdipPathPtr; points: PPointF; count: Integer): TGdipStatusEnum; stdcall;
      public class var GdipAddPathLine2I: function( path: TGdipPathPtr; points: PPoint; count: Integer): TGdipStatusEnum; stdcall;
      public class var GdipAddPathPath: function( path: TGdipPathPtr; addingPath: TGdipPathPtr; connect: LongBool): TGdipStatusEnum; stdcall;
      public class var GdipAddPathPie: function( path: TGdipPathPtr; x: Single; y: Single; width: Single; height: Single; startAngle: Single; sweepAngle: Single): TGdipStatusEnum; stdcall;
      public class var GdipAddPathPolygon: function( path: TGdipPathPtr; points: PPointF; count: Integer): TGdipStatusEnum; stdcall;
      public class var GdipAddPathPolygonI: function( path: TGdipPathPtr; points: PPoint; count: Integer): TGdipStatusEnum; stdcall;
      public class var GdipAddPathRectangle: function( path: TGdipPathPtr; x: Single; y: Single; width: Single; height: Single): TGdipStatusEnum; stdcall;
      public class var GdipAddPathRectangles: function( path: TGdipPathPtr; rects: PRectangleF; count: Integer): TGdipStatusEnum; stdcall;
      public class var GdipAddPathRectanglesI: function( path: TGdipPathPtr; rects: PRectangle; count: Integer): TGdipStatusEnum; stdcall;
      public class var GdipAddPathString: function( path: TGdipPathPtr; &string: PWideChar; length: Integer; family: TGdipFontFamilyPtr; style: Integer; emSize: Single; layoutRect: PRectangleF; format: TGdipStringFormatPtr): TGdipStatusEnum; stdcall;
      public class var GdipBeginContainer: function( graphics: TGdipGraphicsPtr; dstrect: PRectangleF; srcrect: PRectangleF; &unit: TGdipUnitEnum; state: PUInt32): TGdipStatusEnum; stdcall;
      public class var GdipBeginContainer2: function( graphics: TGdipGraphicsPtr; out state: UInt32): TGdipStatusEnum; stdcall;
      public class var GdipBitmapApplyEffect: function( bitmap: TGdipBitmapPtr; effect: TGdipEffectPtr; roi: PRectangle; useAuxData: LongBool; auxData: PPointer; auxDataSize: PInteger): TGdipStatusEnum; stdcall;

      public class var GdipBitmapGetHistogramSize: function(const Format: TGdipHistogramFormatEnum; out NumberOfEntries: Cardinal): TGdipStatusEnum; stdcall;
      public class var GdipBitmapGetHistogram: function(Bitmap: TGdipBitmapPtr; const Format: TGdipHistogramFormatEnum; const NumberOfEntries: Cardinal; Channel0: PCardinal; Channel1: PCardinal; Channel2: PCardinal; Channel3: PCardinal): TGdipStatusEnum; stdcall;


      public class var GdipBitmapConvertFormat: function( pInputBitmap: TGdipBitmapPtr; format: Integer; dithertype: TGdipDitherTypeEnum; palettetype: TGdipPaletteTypeEnum; palette: TGdipColorPalettePtr; alphaThresholdPercent: Single): TGdipStatusEnum; stdcall;
      public class var GdipBitmapGetPixel: function( bitmap: TGdipBitmapPtr; x: Integer; y: Integer; out color: UInt32): TGdipStatusEnum; stdcall;
      public class var GdipBitmapSetPixel: function( bitmap: TGdipBitmapPtr; x: Integer; y: Integer; color: UInt32): TGdipStatusEnum; stdcall;
      public class var GdipBitmapSetResolution: function( bitmap: TGdipBitmapPtr; xdpi: Single; ydpi: Single): TGdipStatusEnum; stdcall;
      public class var GdipClearPathMarkers: function( path: TGdipPathPtr): TGdipStatusEnum; stdcall;
      public class var GdipCloneBitmapArea: function( x: Single; y: Single; width: Single; height: Single; format: Integer; srcBitmap: TGdipBitmapPtr; out dstBitmap: TGdipBitmapPtr): TGdipStatusEnum; stdcall;
      public class var GdipCloneBitmapAreaI: function( x: Integer; y: Integer; width: Integer; height: Integer; format: Integer; srcBitmap: TGdipBitmapPtr; out dstBitmap: TGdipBitmapPtr): TGdipStatusEnum; stdcall;
      public class var GdipCloneBrush: function( brush: TGdipBrushPtr; out cloneBrush: TGdipBrushPtr): TGdipStatusEnum; stdcall;
      public class var GdipCloneCustomLineCap: function( customCap: TGdipCustomLineCapPtr; out clonedCap: TGdipCustomLineCapPtr): TGdipStatusEnum; stdcall;
      public class var GdipCloneFont: function( font: TGdipFontPtr; out cloneFont: TGdipFontPtr): TGdipStatusEnum; stdcall;
      public class var GdipCloneFontFamily: function( fontFamily: TGdipFontFamilyPtr; out clonedFontFamily: TGdipFontFamilyPtr): TGdipStatusEnum; stdcall;
      public class var GdipCloneImage: function( image: TGdipImagePtr; out cloneImage: TGdipImagePtr): TGdipStatusEnum; stdcall;
      public class var GdipCloneImageAttributes: function( imageattr: TGdipImageAttributesPtr; out cloneImageattr: TGdipImageAttributesPtr): TGdipStatusEnum; stdcall;
      public class var GdipCloneMatrix: function(matrix: TGdipMatrixPtr; out cloneMatrix: TGdipMatrixPtr): TGdipStatusEnum; stdcall;
      public class var GdipClonePath: function( path: TGdipPathPtr; out clonePath: TGdipPathPtr): TGdipStatusEnum; stdcall;
      public class var GdipClonePen: function( pen: TGdipPenPtr; out clonepen: TGdipPenPtr): TGdipStatusEnum; stdcall;
      public class var GdipCloneRegion: function( region: TGdipRegionPtr; out cloneRegion: TGdipRegionPtr): TGdipStatusEnum; stdcall;
      public class var GdipCloneStringFormat: function( format: TGdipStringFormatPtr; out newFormat: TGdipStringFormatPtr): TGdipStatusEnum; stdcall;
      public class var GdipClosePathFigure: function( path: TGdipPathPtr): TGdipStatusEnum; stdcall;
      public class var GdipClosePathFigures: function( path: TGdipPathPtr): TGdipStatusEnum; stdcall;
      public class var GdipCombineRegionPath: function( region: TGdipRegionPtr; path: TGdipPathPtr; combineMode: TGdipCombineModeEnum): TGdipStatusEnum; stdcall;
      public class var GdipCombineRegionRect: function( region: TGdipRegionPtr; rect: PRectangleF; combineMode: TGdipCombineModeEnum): TGdipStatusEnum; stdcall;
      public class var GdipCombineRegionRegion: function( region: TGdipRegionPtr; region2: TGdipRegionPtr; combineMode: TGdipCombineModeEnum): TGdipStatusEnum; stdcall;
      public class var GdipComment: function( graphics: TGdipGraphicsPtr; sizeData: UInt32; data: PByte): TGdipStatusEnum; stdcall;
      public class var GdipCreateAdjustableArrowCap: function( height: Single; width: Single; isFilled: LongBool; out cap: TGdipAdjustableArrowCapPtr): TGdipStatusEnum; stdcall;
      public class var GdipCreateBitmapFromFile: function( filename: PWideChar; out bitmap: TGdipBitmapPtr): TGdipStatusEnum; stdcall;
      public class var GdipCreateBitmapFromFileICM: function( filename: PWideChar; out bitmap: TGdipBitmapPtr): TGdipStatusEnum; stdcall;
      public class var GdipCreateBitmapFromGraphics: function( width: Integer; height: Integer; target: TGdipGraphicsPtr; out bitmap: TGdipBitmapPtr): TGdipStatusEnum; stdcall;
      public class var GdipCreateBitmapFromHBITMAP: function( hbm: HBITMAP; hpal: HPALETTE; out bitmap: TGdipBitmapPtr): TGdipStatusEnum; stdcall;
      public class var GdipCreateBitmapFromHICON: function( hicon: HICON; out bitmap: TGdipBitmapPtr): TGdipStatusEnum; stdcall;
      public class var GdipCreateBitmapFromResource: function( hInstance: HINST; lpBitmapName: PWideChar; out bitmap: TGdipBitmapPtr): TGdipStatusEnum; stdcall;
      public class var GdipCreateBitmapFromScan0: function( width: Integer; height: Integer; stride: Integer; format: Integer; scan0: PByte; out bitmap: TGdipBitmapPtr): TGdipStatusEnum; stdcall;
      public class var GdipCreateBitmapFromStream: function( stream: IStream; out bitmap: TGdipBitmapPtr): TGdipStatusEnum; stdcall;
      public class var GdipCreateBitmapFromStreamICM: function( stream: IStream; out bitmap: TGdipBitmapPtr): TGdipStatusEnum; stdcall;
      public class var GdipCreateCachedBitmap: function( bitmap: TGdipBitmapPtr; graphics: TGdipGraphicsPtr; out cachedBitmap: TGdipCachedBitmapPtr): TGdipStatusEnum; stdcall;
      public class var GdipCreateCustomLineCap: function( fillPath: TGdipPathPtr; strokePath: TGdipPathPtr; baseCap: TGdipLineCapEnum; baseInset: Single; out customCap: TGdipCustomLineCapPtr): TGdipStatusEnum; stdcall;
      public class var GdipCreateEffect: function( guid: TGuid; out effect: TGdipEffectPtr): TGdipStatusEnum; stdcall;
      public class var GdipCreateFont: function(const fontFamily: TGdipFontFamilyPtr; emSize: Single; style: Integer; &unit: TGdipUnitEnum; out font: TGdipFontPtr): TGdipStatusEnum; stdcall;
      public class var GdipCreateFontFamilyFromName: function(const name: PWideChar; fontCollection: TGdipFontCollectionPtr; out fontFamily: TGdipFontFamilyPtr): TGdipStatusEnum; stdcall;
      public class var GdipCreateFontFromDC: function( hdc: HDC; out font: TGdipFontPtr): TGdipStatusEnum; stdcall;
      public class var GdipCreateFontFromLogfontW: function( hdc: HDC; logfont: PLogFontW; out font: TGdipFontPtr): TGdipStatusEnum; stdcall;
      public class var GdipCreateFromHDC: function( hdc: HDC; out graphics: TGdipGraphicsPtr): TGdipStatusEnum; stdcall;
      public class var GdipCreateFromHDC2: function( hdc: HDC; hDevice: THandle; out graphics: TGdipGraphicsPtr): TGdipStatusEnum; stdcall;
      public class var GdipCreateFromHWND: function( hwnd: THandle; out graphics: TGdipGraphicsPtr): TGdipStatusEnum; stdcall;
      public class var GdipDeleteGraphics: function( graphics: TGdipGraphicsPtr): TGdipStatusEnum; stdcall;
      public class var GdipBitmapLockBits: function(bitmap: TGdipBitmapPtr; rect: PRectangle; flags: TGdipImageLockModeEnum; format: TGdipPixelFormatEnum; lockedBitmapData: TGdipBitmapDataPtr): TGdipStatusEnum; stdcall;
      public class var GdipBitmapUnlockBits: function(bitmap: TGdipBitmapPtr; lockedBitmapData: TGdipBitmapDataPtr): TGdipStatusEnum; stdcall;
      public class var GdipSaveImageToStream: function(image: TGdipImagePtr; stream: IStream; var clsidEncoder: TGuid; encoderParams: TGdipEncoderParametersPtr): TGdipStatusEnum; stdcall;
      public class var GdipGetImagePixelFormat: function(image: TGdipImagePtr; out format: Int32): TGdipStatusEnum; stdcall;
      public class var GdipCreateHalftonePalette: function(): HPALETTE; stdcall;
      public class var GdipCreateHatchBrush: function( hatchstyle: TGdipHatchStyleEnum; forecol: UInt32; backcol: UInt32; out brush: TGdipHatchPtr): TGdipStatusEnum; stdcall;
      public class var GdipCreateHBITMAPFromBitmap: function( bitmap: TGdipBitmapPtr; out hbmReturn: HBITMAP; background: UInt32): TGdipStatusEnum; stdcall;
      public class var GdipCreateHICONFromBitmap: function( bitmap: TGdipBitmapPtr; out hbmReturn: HICON): TGdipStatusEnum; stdcall;
      public class var GdipCreateImageAttributes: function( out imageattr: TGdipImageAttributesPtr): TGdipStatusEnum; stdcall;
      public class var GdipCreateLineBrush: function( point1: PPointF; point2: PPointF; color1: UInt32; color2: UInt32; wrapMode: TGdipWrapModeEnum; out lineGradient: TGdipLineGradientPtr): TGdipStatusEnum; stdcall;
      public class var GdipCreateLineBrushFromRect: function( rect: PRectangleF; color1: UInt32; color2: UInt32; mode: TGdipLinearGradientModeEnum; wrapMode: TGdipWrapModeEnum; out lineGradient: TGdipLineGradientPtr): TGdipStatusEnum; stdcall;
      public class var GdipCreateLineBrushFromRectWithAngle: function( rect: PRectangleF; color1: UInt32; color2: UInt32; angle: Single; isAngleScalable: LongBool; wrapMode: TGdipWrapModeEnum; out lineGradient: TGdipLineGradientPtr): TGdipStatusEnum; stdcall;
      public class var GdipCreateMatrix: function(out matrix: TGdipMatrixPtr): TGdipStatusEnum; stdcall;
      public class var GdipCreateMatrix2: function( m11: Single; m12: Single; m21: Single; m22: Single; dx: Single; dy: Single; out matrix: TGdipMatrixPtr): TGdipStatusEnum; stdcall;
      public class var GdipCreateMatrix3: function(rect: PRectangleF; dstplg: PPointF; out matrix: TGdipMatrixPtr): TGdipStatusEnum; stdcall;
      public class var GdipCreateMatrix3I: function( rect: PRectangle; dstplg: PPoint; out matrix: TGdipMatrixPtr): TGdipStatusEnum; stdcall;
      public class var GdipCreateMetafileFromEmf: function( hEmf: HENHMETAFILE; deleteEmf: LongBool; out metafile: TGdipMetafilePtr): TGdipStatusEnum; stdcall;
      public class var GdipCreateMetafileFromFile: function( &file: PWideChar; out metafile: TGdipMetafilePtr): TGdipStatusEnum; stdcall;
      public class var GdipCreateMetafileFromStream: function( stream: IStream; out metafile: TGdipMetafilePtr): TGdipStatusEnum; stdcall;
      public class var GdipCreateMetafileFromWmf: function( hWmf: HMETAFILE; deleteWmf: LongBool; wmfPlaceableFileHeader: TGdipWmfPlaceableFileHeaderPtr; out metafile: TGdipMetafilePtr): TGdipStatusEnum; stdcall;
      public class var GdipCreatePath: function( brushMode: TGdipFillModeEnum; out path: TGdipPathPtr): TGdipStatusEnum; stdcall;
      public class var GdipCreatePath2: function( param0: PPointF; param1: PByte; param2: Integer; param3: TGdipFillModeEnum; out path: TGdipPathPtr): TGdipStatusEnum; stdcall;
      public class var GdipCreatePath2I: function( param0: PPoint; param1: PByte; param2: Integer; param3: TGdipFillModeEnum; out path: TGdipPathPtr): TGdipStatusEnum; stdcall;
      public class var GdipCreatePathGradient: function( points: PPointF; count: Integer; wrapMode: TGdipWrapModeEnum; out polyGradient: TGdipPathGradientPtr): TGdipStatusEnum; stdcall;
      public class var GdipCreatePathGradientFromPath: function( path: TGdipPathPtr; out polyGradient: TGdipPathGradientPtr): TGdipStatusEnum; stdcall;
      public class var GdipCreatePathGradientI: function( points: PPoint; count: Integer; wrapMode: TGdipWrapModeEnum; out polyGradient: TGdipPathGradientPtr): TGdipStatusEnum; stdcall;
      public class var GdipCreatePathIter: function( iterator: TGdipPathIteratorPtr; path: TGdipPathPtr): TGdipStatusEnum; stdcall;
      public class var GdipCreatePen1: function( color: UInt32; width: Single; &unit: TGdipUnitEnum; out pen: TGdipPenPtr): TGdipStatusEnum; stdcall;
      public class var GdipCreatePen2: function( brush: TGdipBrushPtr; width: Single; &unit: TGdipUnitEnum; out pen: TGdipPenPtr): TGdipStatusEnum; stdcall;
      public class var GdipCreateRegion: function(out region: TGdipRegionPtr): TGdipStatusEnum; stdcall;
      public class var GdipCreateRegionHrgn: function( hRgn: HRGN;out region: TGdipRegionPtr): TGdipStatusEnum; stdcall;
      public class var GdipGetRegionHRgn: function(region: TGdipRegionPtr; graphics: TGdipGraphicsPtr; out hrgn: HRGN): TGdipStatusEnum; stdcall;
      public class var GdipCreateRegionPath: function( path: TGdipPathPtr;out region: TGdipRegionPtr): TGdipStatusEnum; stdcall;
      public class var GdipCreateRegionRect: function( var rect: TRectangleF;out region: TGdipRegionPtr): TGdipStatusEnum; stdcall;
      public class var GdipCreateRegionRgnData: function( regionData: PByte; size: Integer;out region: TGdipRegionPtr): TGdipStatusEnum; stdcall;
      public class var GdipCreateSolidFill: function( color: UInt32; out brush: TGdipSolidFillPtr): TGdipStatusEnum; stdcall;
      public class var GdipCreateStringFormat: function( formatAttributes: Integer; language: UInt16; out format: TGdipStringFormatPtr): TGdipStatusEnum; stdcall;
      public class var GdipCreateTexture: function( image: TGdipImagePtr; wrapmode: TGdipWrapModeEnum; out texture: TGdipTexturePtr): TGdipStatusEnum; stdcall;
      public class var GdipCreateTexture2: function( image: TGdipImagePtr; wrapmode: TGdipWrapModeEnum; x: Single; y: Single; width: Single; height: Single; out texture: TGdipTexturePtr): TGdipStatusEnum; stdcall;
      public class var GdipCreateTextureIA: function( image: TGdipImagePtr; imageAttributes: TGdipImageAttributesPtr; x: Single; y: Single; width: Single; height: Single; out texture: TGdipTexturePtr): TGdipStatusEnum; stdcall;
      public class var GdipDeleteBrush: function( brush: TGdipBrushPtr): TGdipStatusEnum; stdcall;
      public class var GdipDeleteCachedBitmap: function( cachedBitmap: TGdipCachedBitmapPtr): TGdipStatusEnum; stdcall;
      public class var GdipDeleteCustomLineCap: function( customCap: TGdipCustomLineCapPtr): TGdipStatusEnum; stdcall;
      public class var GdipDeleteEffect: function( effect: TGdipEffectPtr): TGdipStatusEnum; stdcall;
      public class var GdipDeleteFont: function( font: TGdipFontPtr): TGdipStatusEnum; stdcall;
      public class var GdipDeleteFontFamily: function( fontFamily: TGdipFontFamilyPtr): TGdipStatusEnum; stdcall;
      public class var GdipDeleteMatrix: function( matrix: TGdipMatrixPtr): TGdipStatusEnum; stdcall;
      public class var GdipDeletePath: function( path: TGdipPathPtr): TGdipStatusEnum; stdcall;
      public class var GdipDeletePathIter: function( iterator: TGdipPathIteratorPtr): TGdipStatusEnum; stdcall;
      public class var GdipDeletePen: function( pen: TGdipPenPtr): TGdipStatusEnum; stdcall;
      public class var GdipDeletePrivateFontCollection: function(out fontCollection: TGdipFontCollectionPtr): TGdipStatusEnum; stdcall;
      public class var GdipDeleteRegion: function( region: TGdipRegionPtr): TGdipStatusEnum; stdcall;
      public class var GdipDeleteStringFormat: function( format: TGdipStringFormatPtr): TGdipStatusEnum; stdcall;
      public class var GdipDisposeImage: function( image: TGdipImagePtr): TGdipStatusEnum; stdcall;
      public class var GdipDisposeImageAttributes: function( imageattr: TGdipImageAttributesPtr): TGdipStatusEnum; stdcall;
      public class var GdipDrawArc: function( graphics: TGdipGraphicsPtr; pen: TGdipPenPtr; x: Single; y: Single; width: Single; height: Single; startAngle: Single; sweepAngle: Single): TGdipStatusEnum; stdcall;
      public class var GdipDrawBezier: function( graphics: TGdipGraphicsPtr; pen: TGdipPenPtr; x1: Single; y1: Single; x2: Single; y2: Single; x3: Single; y3: Single; x4: Single; y4: Single): TGdipStatusEnum; stdcall;
      public class var GdipDrawBeziers: function( graphics: TGdipGraphicsPtr; pen: TGdipPenPtr; points: PPointF; count: Integer): TGdipStatusEnum; stdcall;
      public class var GdipDrawBeziersI: function( graphics: TGdipGraphicsPtr; pen: TGdipPenPtr; points: PPoint; count: Integer): TGdipStatusEnum; stdcall;
      public class var GdipDrawCachedBitmap: function( graphics: TGdipGraphicsPtr; cachedBitmap: TGdipCachedBitmapPtr; x: Integer; y: Integer): TGdipStatusEnum; stdcall;
      public class var GdipDrawClosedCurve: function( graphics: TGdipGraphicsPtr; pen: TGdipPenPtr; points: PPointF; count: Integer): TGdipStatusEnum; stdcall;
      public class var GdipDrawClosedCurve2: function( graphics: TGdipGraphicsPtr; pen: TGdipPenPtr; points: PPointF; count: Integer; tension: Single): TGdipStatusEnum; stdcall;
      public class var GdipDrawClosedCurve2I: function( graphics: TGdipGraphicsPtr; pen: TGdipPenPtr; points: PPoint; count: Integer; tension: Single): TGdipStatusEnum; stdcall;
      public class var GdipDrawClosedCurveI: function( graphics: TGdipGraphicsPtr; pen: TGdipPenPtr; points: PPoint; count: Integer): TGdipStatusEnum; stdcall;
      public class var GdipDrawCurve: function( graphics: TGdipGraphicsPtr; pen: TGdipPenPtr; points: PPointF; count: Integer): TGdipStatusEnum; stdcall;
      public class var GdipDrawCurve2: function( graphics: TGdipGraphicsPtr; pen: TGdipPenPtr; points: PPointF; count: Integer; tension: Single): TGdipStatusEnum; stdcall;
      public class var GdipDrawCurve2I: function( graphics: TGdipGraphicsPtr; pen: TGdipPenPtr; points: PPoint; count: Integer; tension: Single): TGdipStatusEnum; stdcall;
      public class var GdipDrawCurve3: function( graphics: TGdipGraphicsPtr; pen: TGdipPenPtr; points: PPointF; count: Integer; offset: Integer; numberOfSegments: Integer; tension: Single): TGdipStatusEnum; stdcall;
      public class var GdipDrawCurve3I: function( graphics: TGdipGraphicsPtr; pen: TGdipPenPtr; points: PPoint; count: Integer; offset: Integer; numberOfSegments: Integer; tension: Single): TGdipStatusEnum; stdcall;
      public class var GdipDrawCurveI: function( graphics: TGdipGraphicsPtr; pen: TGdipPenPtr; points: PPoint; count: Integer): TGdipStatusEnum; stdcall;
      public class var GdipDrawEllipse: function( graphics: TGdipGraphicsPtr; pen: TGdipPenPtr; x: Single; y: Single; width: Single; height: Single): TGdipStatusEnum; stdcall;
      public class var GdipDrawImage: function( graphics: TGdipGraphicsPtr; image: TGdipImagePtr; x: Single; y: Single): TGdipStatusEnum; stdcall;
      public class var GdipDrawImageFX: function( graphics: TGdipGraphicsPtr; image: TGdipImagePtr; source: PRectangleF; xForm: TGdipMatrixPtr; effect: TGdipEffectPtr; imageAttributes: TGdipImageAttributesPtr; srcUnit: TGdipUnitEnum): TGdipStatusEnum; stdcall;
      public class var GdipDrawImagePointRect: function( graphics: TGdipGraphicsPtr; image: TGdipImagePtr; x: Single; y: Single; srcx: Single; srcy: Single; srcwidth: Single; srcheight: Single; srcUnit: TGdipUnitEnum): TGdipStatusEnum; stdcall;
      public class var GdipDrawImagePoints: function( graphics: TGdipGraphicsPtr; image: TGdipImagePtr; dstpoints: PPointF; count: Integer): TGdipStatusEnum; stdcall;
      public class var GdipDrawImagePointsI: function( graphics: TGdipGraphicsPtr; image: TGdipImagePtr; dstpoints: PPoint; count: Integer): TGdipStatusEnum; stdcall;
      public class var GdipDrawImagePointsRect: function( graphics: TGdipGraphicsPtr; image: TGdipImagePtr; points: PPointF; count: Integer; srcx: Single; srcy: Single; srcwidth: Single; srcheight: Single; srcUnit: TGdipUnitEnum; imageAttributes: TGdipImageAttributesPtr; callback: NativeInt; callbackData: Pointer): TGdipStatusEnum; stdcall;
      public class var GdipDrawImagePointsRectI: function( graphics: TGdipGraphicsPtr; image: TGdipImagePtr; points: PPoint; count: Integer; srcx: Integer; srcy: Integer; srcwidth: Integer; srcheight: Integer; srcUnit: TGdipUnitEnum; imageAttributes: TGdipImageAttributesPtr; callback: NativeInt; callbackData: Pointer): TGdipStatusEnum; stdcall;
      public class var GdipDrawImageRect: function( graphics: TGdipGraphicsPtr; image: TGdipImagePtr; x: Single; y: Single; width: Single; height: Single): TGdipStatusEnum; stdcall;
      public class var GdipDrawImageRectRect: function( graphics: TGdipGraphicsPtr; image: TGdipImagePtr; dstx: Single; dsty: Single; dstwidth: Single; dstheight: Single; srcx: Single; srcy: Single; srcwidth: Single; srcheight: Single; srcUnit: TGdipUnitEnum; const imageAttributes: TGdipImageAttributesPtr; callback: TGdiplusDrawImageAbort; callbackData: Pointer): TGdipStatusEnum; stdcall;
      public class var GdipDrawLine: function( graphics: TGdipGraphicsPtr; pen: TGdipPenPtr; x1: Single; y1: Single; x2: Single; y2: Single): TGdipStatusEnum; stdcall;
      public class var GdipDrawLines: function( graphics: TGdipGraphicsPtr; pen: TGdipPenPtr; points: PPointF; count: Integer): TGdipStatusEnum; stdcall;
      public class var GdipDrawLinesI: function( graphics: TGdipGraphicsPtr; pen: TGdipPenPtr; points: PPoint; count: Integer): TGdipStatusEnum; stdcall;
      public class var GdipDrawPath: function( graphics: TGdipGraphicsPtr; pen: TGdipPenPtr; path: TGdipPathPtr): TGdipStatusEnum; stdcall;
      public class var GdipDrawPie: function( graphics: TGdipGraphicsPtr; pen: TGdipPenPtr; x: Single; y: Single; width: Single; height: Single; startAngle: Single; sweepAngle: Single): TGdipStatusEnum; stdcall;
      public class var GdipDrawPolygon: function( graphics: TGdipGraphicsPtr; pen: TGdipPenPtr; points: PPointF; count: Integer): TGdipStatusEnum; stdcall;
      public class var GdipDrawPolygonI: function( graphics: TGdipGraphicsPtr; pen: TGdipPenPtr; points: PPoint; count: Integer): TGdipStatusEnum; stdcall;
      public class var GdipDrawRectangle: function( graphics: TGdipGraphicsPtr; pen: TGdipPenPtr; x: Single; y: Single; width: Single; height: Single): TGdipStatusEnum; stdcall;
      public class var GdipDrawRectangles: function( graphics: TGdipGraphicsPtr; pen: TGdipPenPtr; rects: PRectangleF; count: Integer): TGdipStatusEnum; stdcall;
      public class var GdipDrawRectanglesI: function( graphics: TGdipGraphicsPtr; pen: TGdipPenPtr; rects: PRectangle; count: Integer): TGdipStatusEnum; stdcall;
      public class var GdipDrawString: function(const graphics: TGdipGraphicsPtr; const string_: PWideChar; const length: Integer; const font: TGdipFontPtr; layoutRect: PRectangleF; const stringFormat: TGdipStringFormatPtr; const brush: TGdipBrushPtr): TGdipStatusEnum; stdcall;
      public class var GdipEndContainer: function( graphics: TGdipGraphicsPtr; state: UInt32): TGdipStatusEnum; stdcall;
      public class var GdipEnumerateMetafileDestPoint: function( graphics: TGdipGraphicsPtr; metafile: TGdipMetafilePtr; destPoint: PPointF; callback: NativeInt; callbackData: Pointer; imageAttributes: TGdipImageAttributesPtr): TGdipStatusEnum; stdcall;
      public class var GdipEnumerateMetafileDestPoints: function( graphics: TGdipGraphicsPtr; metafile: TGdipMetafilePtr; destPoints: PPointF; count: Integer; callback: NativeInt; callbackData: Pointer; imageAttributes: TGdipImageAttributesPtr): TGdipStatusEnum; stdcall;
      public class var GdipEnumerateMetafileDestPointsI: function( graphics: TGdipGraphicsPtr; metafile: TGdipMetafilePtr; destPoints: PPoint; count: Integer; callback: NativeInt; callbackData: Pointer; imageAttributes: TGdipImageAttributesPtr): TGdipStatusEnum; stdcall;
      public class var GdipEnumerateMetafileDestRect: function( graphics: TGdipGraphicsPtr; metafile: TGdipMetafilePtr; destRect: PRectangleF; callback: NativeInt; callbackData: Pointer; imageAttributes: TGdipImageAttributesPtr): TGdipStatusEnum; stdcall;
      public class var GdipEnumerateMetafileSrcRectDestPoint: function( graphics: TGdipGraphicsPtr; metafile: TGdipMetafilePtr; destPoint: PPointF; srcRect: PRectangleF; srcUnit: TGdipUnitEnum; callback: NativeInt; callbackData: Pointer; imageAttributes: TGdipImageAttributesPtr): TGdipStatusEnum; stdcall;
      public class var GdipEnumerateMetafileSrcRectDestPoints: function( graphics: TGdipGraphicsPtr; metafile: TGdipMetafilePtr; destPoints: PPointF; count: Integer; srcRect: PRectangleF; srcUnit: TGdipUnitEnum; callback: NativeInt; callbackData: Pointer; imageAttributes: TGdipImageAttributesPtr): TGdipStatusEnum; stdcall;
      public class var GdipEnumerateMetafileSrcRectDestPointsI: function( graphics: TGdipGraphicsPtr; metafile: TGdipMetafilePtr; destPoints: PPoint; count: Integer; srcRect: PRectangle; srcUnit: TGdipUnitEnum; callback: NativeInt; callbackData: Pointer; imageAttributes: TGdipImageAttributesPtr): TGdipStatusEnum; stdcall;
      public class var GdipEnumerateMetafileSrcRectDestRect: function( graphics: TGdipGraphicsPtr; metafile: TGdipMetafilePtr; destRect: PRectangleF; srcRect: PRectangleF; srcUnit: TGdipUnitEnum; callback: NativeInt; callbackData: Pointer; imageAttributes: TGdipImageAttributesPtr): TGdipStatusEnum; stdcall;
      public class var GdipFillClosedCurve: function( graphics: TGdipGraphicsPtr; brush: TGdipBrushPtr; points: PPointF; count: Integer): TGdipStatusEnum; stdcall;
      public class var GdipFillClosedCurve2: function( graphics: TGdipGraphicsPtr; brush: TGdipBrushPtr; points: PPointF; count: Integer; tension: Single; fillMode: TGdipFillModeEnum): TGdipStatusEnum; stdcall;
      public class var GdipFillClosedCurve2I: function( graphics: TGdipGraphicsPtr; brush: TGdipBrushPtr; points: PPoint; count: Integer; tension: Single; fillMode: TGdipFillModeEnum): TGdipStatusEnum; stdcall;
      public class var GdipFillClosedCurveI: function( graphics: TGdipGraphicsPtr; brush: TGdipBrushPtr; points: PPoint; count: Integer): TGdipStatusEnum; stdcall;
      public class var GdipFillEllipse: function( graphics: TGdipGraphicsPtr; brush: TGdipBrushPtr; x: Single; y: Single; width: Single; height: Single): TGdipStatusEnum; stdcall;
      public class var GdipFillPath: function( graphics: TGdipGraphicsPtr; brush: TGdipBrushPtr; path: TGdipPathPtr): TGdipStatusEnum; stdcall;
      public class var GdipFillPie: function( graphics: TGdipGraphicsPtr; brush: TGdipBrushPtr; x: Single; y: Single; width: Single; height: Single; startAngle: Single; sweepAngle: Single): TGdipStatusEnum; stdcall;
      public class var GdipFillPolygon: function( graphics: TGdipGraphicsPtr; brush: TGdipBrushPtr; points: PPointF; count: Integer; fillMode: TGdipFillModeEnum): TGdipStatusEnum; stdcall;
      public class var GdipFillPolygonI: function( graphics: TGdipGraphicsPtr; brush: TGdipBrushPtr; points: PPoint; count: Integer; fillMode: TGdipFillModeEnum): TGdipStatusEnum; stdcall;
      public class var GdipFillRectangle: function( graphics: TGdipGraphicsPtr; brush: TGdipBrushPtr; x: Single; y: Single; width: Single; height: Single): TGdipStatusEnum; stdcall;
      public class var GdipFillRectangles: function( graphics: TGdipGraphicsPtr; brush: TGdipBrushPtr; rects: PRectangleF; count: Integer): TGdipStatusEnum; stdcall;
      public class var GdipFillRectanglesI: function( graphics: TGdipGraphicsPtr; brush: TGdipBrushPtr; rects: PRectangle; count: Integer): TGdipStatusEnum; stdcall;
      public class var GdipFillRegion: function( graphics: TGdipGraphicsPtr; brush: TGdipBrushPtr; region: TGdipRegionPtr): TGdipStatusEnum; stdcall;
      public class var GdipFlattenPath: function( path: TGdipPathPtr; matrix: TGdipMatrixPtr; flatness: Single): TGdipStatusEnum; stdcall;
      public class var GdipFlush: function( graphics: TGdipGraphicsPtr; intention: TGdipFlushIntentionEnum): TGdipStatusEnum; stdcall;
      public class var GdipGetAdjustableArrowCapFillState: function( cap: TGdipAdjustableArrowCapPtr; out fillState: LongBool): TGdipStatusEnum; stdcall;
      public class var GdipGetAdjustableArrowCapHeight: function( cap: TGdipAdjustableArrowCapPtr; out height: Single): TGdipStatusEnum; stdcall;
      public class var GdipGetAdjustableArrowCapMiddleInset: function( cap: TGdipAdjustableArrowCapPtr; out middleInset: Single): TGdipStatusEnum; stdcall;
      public class var GdipGetAdjustableArrowCapWidth: function( cap: TGdipAdjustableArrowCapPtr; out width: Single): TGdipStatusEnum; stdcall;
      public class var GdipGetAllPropertyItems: function( image: TGdipImagePtr; totalBufferSize: UInt32; numProperties: UInt32; allItems: TGdipPropertyItemPtr): TGdipStatusEnum; stdcall;
      public class var GdipGetCellAscent: function( family: TGdipFontFamilyPtr; style: Integer; out CellAscent: UInt16): TGdipStatusEnum; stdcall;
      public class var GdipGetCellDescent: function( family: TGdipFontFamilyPtr; style: Integer; out CellDescent: UInt16): TGdipStatusEnum; stdcall;
      public class var GdipGetClip: function( graphics: TGdipGraphicsPtr; region: TGdipRegionPtr): TGdipStatusEnum; stdcall;
      public class var GdipGetClipBounds: function( graphics: TGdipGraphicsPtr; var rect: TRectangleF): TGdipStatusEnum; stdcall;
      public class var GdipGetCompositingMode: function( graphics: TGdipGraphicsPtr; out compositingMode: TGdipCompositingModeEnum): TGdipStatusEnum; stdcall;
      public class var GdipGetCompositingQuality: function( graphics: TGdipGraphicsPtr; out compositingQuality: TGdipCompositingQualityEnum): TGdipStatusEnum; stdcall;
      public class var GdipGetCustomLineCapBaseCap: function( customCap: TGdipCustomLineCapPtr; out baseCap: TGdipLineCapEnum): TGdipStatusEnum; stdcall;
      public class var GdipGetCustomLineCapBaseInset: function( customCap: TGdipCustomLineCapPtr; out inset: Single): TGdipStatusEnum; stdcall;
      public class var GdipGetCustomLineCapStrokeCaps: function( customCap: TGdipCustomLineCapPtr; out startCap: TGdipLineCapEnum; out endCap: TGdipLineCapEnum): TGdipStatusEnum; stdcall;
      public class var GdipGetCustomLineCapStrokeJoin: function( customCap: TGdipCustomLineCapPtr; out lineJoin: TGdipLineJoinEnum): TGdipStatusEnum; stdcall;
      public class var GdipGetCustomLineCapType: function( customCap: TGdipCustomLineCapPtr; out capType: TGdipCustomLineCapTypeEnum): TGdipStatusEnum; stdcall;
      public class var GdipGetCustomLineCapWidthScale: function( customCap: TGdipCustomLineCapPtr; out widthScale: Single): TGdipStatusEnum; stdcall;
      public class var GdipGetDC: function( graphics: TGdipGraphicsPtr; out hdc: HDC): TGdipStatusEnum; stdcall;
      public class var GdipGetDpiX: function( graphics: TGdipGraphicsPtr; out dpi: Single): TGdipStatusEnum; stdcall;
      public class var GdipGetDpiY: function( graphics: TGdipGraphicsPtr; out dpi: Single): TGdipStatusEnum; stdcall;
      public class var GdipGetEmHeight: function( family: TGdipFontFamilyPtr; style: Integer; out EmHeight: UInt16): TGdipStatusEnum; stdcall;
      public class var GdipGetEncoderParameterList: function( image: TGdipImagePtr; clsidEncoder: PGuid; size: UInt32; buffer: TGdipEncoderParametersPtr): TGdipStatusEnum; stdcall;
      public class var GdipGetEncoderParameterListSize: function( image: TGdipImagePtr; clsidEncoder: PGuid; out size: UInt32): TGdipStatusEnum; stdcall;
      public class var GdipGetFamily: function( font: TGdipFontPtr; out family: TGdipFontFamilyPtr): TGdipStatusEnum; stdcall;
      public class var GdipGetFamilyName: function(const family: TGdipFontFamilyPtr; name: PWideChar; language: LangID): TGdipStatusEnum; stdcall;
      public class var GdipGetFontCollectionFamilyCount: function( fontCollection: TGdipFontCollectionPtr; out numFound: Integer): TGdipStatusEnum; stdcall;
      public class var GdipGetFontCollectionFamilyList: function(fontCollection: TGdipFontCollectionPtr; numSought: Integer; gpfamilies: TGdipFontFamilyPtr; out numFound: Integer): TGdipStatusEnum; stdcall;
      public class var GdipGetFontHeight: function( font: TGdipFontPtr; graphics: TGdipGraphicsPtr; height: PSingle): TGdipStatusEnum; stdcall;
      public class var GdipGetFontHeightGivenDPI: function( font: TGdipFontPtr; dpi: Single; height: PSingle): TGdipStatusEnum; stdcall;
      public class var GdipGetFontSize: function( font: TGdipFontPtr; out size: Single): TGdipStatusEnum; stdcall;
      public class var GdipGetFontStyle: function( font: TGdipFontPtr; out style: Integer): TGdipStatusEnum; stdcall;
      public class var GdipGetFontUnit: function( font: TGdipFontPtr; out &unit: TGdipUnitEnum): TGdipStatusEnum; stdcall;
      public class var GdipGetGenericFontFamilyMonospace: function(out nativeFamily: TGdipFontFamilyPtr): TGdipStatusEnum; stdcall;
      public class var GdipGetGenericFontFamilySansSerif: function(out nativeFamily: TGdipFontFamilyPtr): TGdipStatusEnum; stdcall;
      public class var GdipGetGenericFontFamilySerif: function( out nativeFamily: TGdipFontFamilyPtr): TGdipStatusEnum; stdcall;
      public class var GdipGetHatchBackgroundColor: function( brush: TGdipHatchPtr; backcol: PUInt32): TGdipStatusEnum; stdcall;
      public class var GdipGetHatchForegroundColor: function( brush: TGdipHatchPtr; forecol: PUInt32): TGdipStatusEnum; stdcall;
      public class var GdipGetHatchStyle: function( brush: TGdipHatchPtr; out hatchstyle: TGdipHatchStyleEnum): TGdipStatusEnum; stdcall;
      public class var GdipGetHemfFromMetafile: function( metafile: TGdipMetafilePtr; out hEmf: HENHMETAFILE): TGdipStatusEnum; stdcall;
      public class var GdipGetImageAttributesAdjustedPalette: function( imageAttr: TGdipImageAttributesPtr; colorPalette: TGdipColorPalettePtr; colorAdjustType: TGdipColorAdjustTypeEnum): TGdipStatusEnum; stdcall;
      public class var GdipGetImageDecoders: function(numDecoders: UInt32; size: UInt32; decoders: TGdipImageCodecInfoPtr): TGdipStatusEnum; stdcall;
      public class var GdipGetImageDecodersSize: function(out numDecoders: UInt32; out size: UInt32): TGdipStatusEnum; stdcall;
      public class var GdipGetImageEncoders: function(const numDecoders: UInt32; const size: UInt32; decoders: TGdipImageCodecInfoPtr): TGdipStatusEnum; stdcall;
      public class var GdipGetImageEncodersSize: function(out numEncoders: UInt32; out size: UInt32): TGdipStatusEnum; stdcall;
      public class var GdipGetImageDimension: function( image: TGdipImagePtr; width: PSingle; height: PSingle): TGdipStatusEnum; stdcall;
      public class var GdipGetImageFlags: function( image: TGdipImagePtr; flags: PUInt32): TGdipStatusEnum; stdcall;
      public class var GdipGetImageGraphicsContext: function( image: TGdipImagePtr; out graphics: TGdipGraphicsPtr): TGdipStatusEnum; stdcall;
      public class var GdipGetImageHeight: function( image: TGdipImagePtr; height: PUInt32): TGdipStatusEnum; stdcall;
      public class var GdipGetImageHorizontalResolution: function( image: TGdipImagePtr; resolution: PSingle): TGdipStatusEnum; stdcall;
      public class var GdipGetImagePalette: function( image: TGdipImagePtr; palette: TGdipColorPalettePtr; size: Integer): TGdipStatusEnum; stdcall;
      public class var GdipGetImagePaletteSize: function( image: TGdipImagePtr; out size: Integer): TGdipStatusEnum; stdcall;
      public class var GdipGetImageRawFormat: function( image: TGdipImagePtr; format: PGuid): TGdipStatusEnum; stdcall;
      public class var GdipGetImageThumbnail: function( image: TGdipImagePtr; thumbWidth: UInt32; thumbHeight: UInt32; out thumbImage: TGdipImagePtr; callback: NativeInt; callbackData: Pointer): TGdipStatusEnum; stdcall;
      public class var GdipGetImageType: function( image: TGdipImagePtr; out &type: TGdipImageTypeEnum): TGdipStatusEnum; stdcall;
      public class var GdipGetImageVerticalResolution: function( image: TGdipImagePtr; resolution: PSingle): TGdipStatusEnum; stdcall;
      public class var GdipGetImageWidth: function( image: TGdipImagePtr; width: PUInt32): TGdipStatusEnum; stdcall;
      public class var GdipGetInterpolationMode: function( graphics: TGdipGraphicsPtr; out interpolationMode: TGdipInterpolationModeEnum): TGdipStatusEnum; stdcall;
      public class var GdipGetLineBlend: function( brush: TGdipLineGradientPtr; blend: PSingle; positions: PSingle; count: Integer): TGdipStatusEnum; stdcall;
      public class var GdipGetLineBlendCount: function( brush: TGdipLineGradientPtr; out count: Integer): TGdipStatusEnum; stdcall;
      public class var GdipGetLineColors: function( brush: TGdipLineGradientPtr; colors: PUInt32): TGdipStatusEnum; stdcall;
      public class var GdipGetLineGammaCorrection: function( brush: TGdipLineGradientPtr; out useGammaCorrection: LongBool): TGdipStatusEnum; stdcall;
      public class var GdipGetLinePresetBlend: function( brush: TGdipLineGradientPtr; blend: PUInt32; positions: PSingle; count: Integer): TGdipStatusEnum; stdcall;
      public class var GdipGetLinePresetBlendCount: function( brush: TGdipLineGradientPtr; out count: Integer): TGdipStatusEnum; stdcall;
      public class var GdipGetLineRect: function( brush: TGdipLineGradientPtr; out rect: TRectangleF): TGdipStatusEnum; stdcall;
      public class var GdipGetLineSpacing: function( family: TGdipFontFamilyPtr; style: Integer; out LineSpacing: UInt16): TGdipStatusEnum; stdcall;
      public class var GdipGetLineTransform: function( brush: TGdipLineGradientPtr; matrix: TGdipMatrixPtr): TGdipStatusEnum; stdcall;
      public class var GdipGetLineWrapMode: function( brush: TGdipLineGradientPtr; out wrapmode: TGdipWrapModeEnum): TGdipStatusEnum; stdcall;
      public class var GdipGetLogFontW: function( font: TGdipFontPtr; graphics: TGdipGraphicsPtr; out logfontW: TLogFontW): TGdipStatusEnum; stdcall;
      public class var GdipGetMatrixElements: function( matrix: TGdipMatrixPtr; matrixOut: PSingle): TGdipStatusEnum; stdcall;
      public class var GdipGetMetafileHeaderFromEmf: function( hEmf: HENHMETAFILE; header: TGdipMetafileHeaderPtr): TGdipStatusEnum; stdcall;
      public class var GdipGetMetafileHeaderFromFile: function( filename: PWideChar; header: TGdipMetafileHeaderPtr): TGdipStatusEnum; stdcall;
      public class var GdipGetMetafileHeaderFromMetafile: function( metafile: TGdipMetafilePtr; header: TGdipMetafileHeaderPtr): TGdipStatusEnum; stdcall;
      public class var GdipGetMetafileHeaderFromStream: function( stream: IStream; header: TGdipMetafileHeaderPtr): TGdipStatusEnum; stdcall;
      public class var GdipGetMetafileHeaderFromWmf: function( hWmf: HMETAFILE; wmfPlaceableFileHeader: TGdipWmfPlaceableFileHeaderPtr; header: TGdipMetafileHeaderPtr): TGdipStatusEnum; stdcall;
      public class var GdipGetNearestColor: function( graphics: TGdipGraphicsPtr; argb: PUInt32): TGdipStatusEnum; stdcall;
      public class var GdipGetPageScale: function( graphics: TGdipGraphicsPtr; out scale: Single): TGdipStatusEnum; stdcall;
      public class var GdipGetPageUnit: function( graphics: TGdipGraphicsPtr; out &unit: TGdipUnitEnum): TGdipStatusEnum; stdcall;
      public class var GdipGetPathData: function( path: TGdipPathPtr; pathData: TGdipPathDataPtr): TGdipStatusEnum; stdcall;
      public class var GdipGetPathFillMode: function( path: TGdipPathPtr; out fillmode: TGdipFillModeEnum): TGdipStatusEnum; stdcall;
      public class var GdipGetPathGradientBlend: function( brush: TGdipPathGradientPtr; blend: PSingle; positions: PSingle; count: Integer): TGdipStatusEnum; stdcall;
      public class var GdipGetPathGradientBlendCount: function( brush: TGdipPathGradientPtr; out count: Integer): TGdipStatusEnum; stdcall;
      public class var GdipGetPathGradientCenterColor: function( brush: TGdipPathGradientPtr; colors: PUInt32): TGdipStatusEnum; stdcall;
      public class var GdipGetPathGradientCenterPoint: function( brush: TGdipPathGradientPtr; out points: TPointF): TGdipStatusEnum; stdcall;
      public class var GdipGetPathGradientFocusScales: function( brush: TGdipPathGradientPtr; out xScale: Single; out yScale: Single): TGdipStatusEnum; stdcall;
      public class var GdipGetPathGradientPresetBlend: function( brush: TGdipPathGradientPtr; blend: PUInt32; positions: PSingle; count: Integer): TGdipStatusEnum; stdcall;
      public class var GdipGetPathGradientPresetBlendCount: function( brush: TGdipPathGradientPtr; out count: Integer): TGdipStatusEnum; stdcall;
      public class var GdipGetPathGradientRect: function( brush: TGdipPathGradientPtr; out rect: TRectangleF): TGdipStatusEnum; stdcall;
      public class var GdipGetPathGradientSurroundColorCount: function( brush: TGdipPathGradientPtr; out count: Integer): TGdipStatusEnum; stdcall;
      public class var GdipGetPathGradientSurroundColorsWithCount: function( brush: TGdipPathGradientPtr; color: PUInt32; out count: Integer): TGdipStatusEnum; stdcall;
      public class var GdipGetPathGradientTransform: function( brush: TGdipPathGradientPtr; matrix: TGdipMatrixPtr): TGdipStatusEnum; stdcall;
      public class var GdipGetPathGradientWrapMode: function( brush: TGdipPathGradientPtr; out wrapmode: TGdipWrapModeEnum): TGdipStatusEnum; stdcall;


      public class var GdipGetPathGradientGammaCorrection: function(Brush: TGdipPathGradientPtr; out UseGammaCorrection: LongBool): TGdipStatusEnum; stdcall;
      public class var GdipSetPathGradientGammaCorrection: function(Brush: TGdipPathGradientPtr; UseGammaCorrection: LongBool): TGdipStatusEnum; stdcall;


      public class var GdipGetPathLastPoint: function( path: TGdipPathPtr; out lastPoint: TPointF): TGdipStatusEnum; stdcall;
      public class var GdipGetPathPoints: function( param0: TGdipPathPtr; points: PPointF; count: Integer): TGdipStatusEnum; stdcall;
      public class var GdipGetPathTypes: function( path: TGdipPathPtr; types: PByte; count: Integer): TGdipStatusEnum; stdcall;
      public class var GdipGetPathWorldBounds: function( path: TGdipPathPtr; var bounds: TRectangleF; matrix: TGdipMatrixPtr; pen: TGdipPenPtr): TGdipStatusEnum; stdcall;
      public class var GdipGetPenBrushFill: function( pen: TGdipPenPtr; out brush: TGdipBrushPtr): TGdipStatusEnum; stdcall;
      public class var GdipGetPenColor: function( pen: TGdipPenPtr; argb: PUInt32): TGdipStatusEnum; stdcall;
      public class var GdipGetPenCompoundArray: function( pen: TGdipPenPtr; dash: PSingle; count: Integer): TGdipStatusEnum; stdcall;
      public class var GdipGetPenCompoundCount: function( pen: TGdipPenPtr; out count: Integer): TGdipStatusEnum; stdcall;
      public class var GdipGetPenCustomEndCap: function( pen: TGdipPenPtr; out customCap: TGdipCustomLineCapPtr): TGdipStatusEnum; stdcall;
      public class var GdipGetPenCustomStartCap: function( pen: TGdipPenPtr; out customCap: TGdipCustomLineCapPtr): TGdipStatusEnum; stdcall;
      public class var GdipGetPenDashArray: function( pen: TGdipPenPtr; dash: PSingle; count: Integer): TGdipStatusEnum; stdcall;
      public class var GdipGetPenDashCap197819: function( pen: TGdipPenPtr; out dashCap: TGdipDashCapEnum): TGdipStatusEnum; stdcall;
      public class var GdipGetPenDashCount: function( pen: TGdipPenPtr; out count: Integer): TGdipStatusEnum; stdcall;
      public class var GdipGetPenDashOffset: function( pen: TGdipPenPtr; out offset: Single): TGdipStatusEnum; stdcall;
      public class var GdipGetPenDashStyle: function( pen: TGdipPenPtr; out dashstyle: TGdipDashStyleEnum): TGdipStatusEnum; stdcall;
      public class var GdipGetPenEndCap: function( pen: TGdipPenPtr; out endCap: TGdipLineCapEnum): TGdipStatusEnum; stdcall;
      public class var GdipGetPenFillType: function( pen: TGdipPenPtr; out &type: TGdipPenTypeEnum): TGdipStatusEnum; stdcall;
      public class var GdipGetPenLineJoin: function( pen: TGdipPenPtr; out lineJoin: TGdipLineJoinEnum): TGdipStatusEnum; stdcall;
      public class var GdipGetPenMiterLimit: function( pen: TGdipPenPtr; out miterLimit: Single): TGdipStatusEnum; stdcall;
      public class var GdipGetPenMode: function( pen: TGdipPenPtr; out penMode: TGdipPenAlignmentEnum): TGdipStatusEnum; stdcall;
      public class var GdipGetPenStartCap: function( pen: TGdipPenPtr; out startCap: TGdipLineCapEnum): TGdipStatusEnum; stdcall;
      public class var GdipGetPenTransform: function( pen: TGdipPenPtr; matrix: TGdipMatrixPtr): TGdipStatusEnum; stdcall;
      public class var GdipGetPenWidth: function( pen: TGdipPenPtr; out width: Single): TGdipStatusEnum; stdcall;
      public class var GdipGetPixelOffsetMode: function( graphics: TGdipGraphicsPtr; out pixelOffsetMode: TGdipPixelOffsetModeEnum): TGdipStatusEnum; stdcall;
      public class var GdipGetPointCount: function( path: TGdipPathPtr; out count: Integer): TGdipStatusEnum; stdcall;
      public class var GdipGetPropertyCount: function( image: TGdipImagePtr; out numOfProperty: UInt32): TGdipStatusEnum; stdcall;
      public class var GdipGetPropertyIdList: function( image: TGdipImagePtr; numOfProperty: UInt32; list: PUInt32): TGdipStatusEnum; stdcall;
      public class var GdipGetPropertyItem: function( image: TGdipImagePtr; propId: UInt32; propSize: UInt32; buffer: TGdipPropertyItemPtr): TGdipStatusEnum; stdcall;
      public class var GdipGetPropertyItemSize: function( image: TGdipImagePtr; propId: UInt32; size: PUInt32): TGdipStatusEnum; stdcall;
      public class var GdipGetPropertySize: function( image: TGdipImagePtr; out totalBufferSize: UInt32; out numProperties: UInt32): TGdipStatusEnum; stdcall;
      public class var GdipGetRegionBounds: function( region: TGdipRegionPtr; graphics: TGdipGraphicsPtr; var rect: TRectangleF): TGdipStatusEnum; stdcall;
      public class var GdipGetRegionData: function( region: TGdipRegionPtr; buffer: PByte; bufferSize: UInt32; out sizeFilled: UInt32): TGdipStatusEnum; stdcall;
      public class var GdipGetRegionDataSize: function( region: TGdipRegionPtr; out bufferSize: UInt32): TGdipStatusEnum; stdcall;
      public class var GdipGetRegionScans: function( region: TGdipRegionPtr; rects: PRectangleF; var count: UInt32; matrix: TGdipMatrixPtr): TGdipStatusEnum; stdcall;
      public class var GdipGetRegionScansCount: function( region: TGdipRegionPtr; var count: UInt32; matrix: TGdipMatrixPtr): TGdipStatusEnum; stdcall;
      public class var GdipGetRenderingOrigin: function( graphics: TGdipGraphicsPtr; out x: Integer; out y: Integer): TGdipStatusEnum; stdcall;
      public class var GdipGetSmoothingMode: function( graphics: TGdipGraphicsPtr; out smoothingMode: TGdipSmoothingModeEnum): TGdipStatusEnum; stdcall;
      public class var GdipGetSolidFillColor: function( brush: TGdipSolidFillPtr; color: PUInt32): TGdipStatusEnum; stdcall;
      public class var GdipGetStringFormatAlign: function( format: TGdipStringFormatPtr; out align: TGdipStringAlignmentEnum): TGdipStatusEnum; stdcall;
      public class var GdipGetStringFormatDigitSubstitution: function( format: TGdipStringFormatPtr; language: PUInt16; substitute: PGdipStringDigitSubstituteEnum): TGdipStatusEnum; stdcall;
      public class var GdipGetStringFormatFlags: function( format: TGdipStringFormatPtr; out flags: TGdipStringFormatFlagsEnum): TGdipStatusEnum; stdcall;
      public class var GdipGetStringFormatHotkeyPrefix: function( format: TGdipStringFormatPtr; out hotkeyPrefix: TGdipHotkeyPrefixEnum): TGdipStatusEnum; stdcall;
      public class var GdipGetStringFormatLineAlign: function( format: TGdipStringFormatPtr; out align: TGdipStringAlignmentEnum): TGdipStatusEnum; stdcall;
      public class var GdipGetStringFormatMeasurableCharacterRangeCount: function( format: TGdipStringFormatPtr; out count: Integer): TGdipStatusEnum; stdcall;
      public class var GdipGetStringFormatTabStopCount: function( format: TGdipStringFormatPtr; out count: Integer): TGdipStatusEnum; stdcall;
      public class var GdipGetStringFormatTabStops: function( format: TGdipStringFormatPtr; count: Integer; out firstTabOffset: Single; out tabStops: PSingle): TGdipStatusEnum; stdcall;
      public class var GdipGetStringFormatTrimming: function( format: TGdipStringFormatPtr; out trimming: TGdipStringTrimmingEnum): TGdipStatusEnum; stdcall;
      public class var GdipGetTextContrast: function( graphics: TGdipGraphicsPtr; out contrast: UInt32): TGdipStatusEnum; stdcall;
      public class var GdipGetTextRenderingHint: function( graphics: TGdipGraphicsPtr; out mode: TGdipTextRenderingHintEnum): TGdipStatusEnum; stdcall;
      public class var GdipGetTextureImage: function( brush: TGdipTexturePtr; out image: TGdipImagePtr): TGdipStatusEnum; stdcall;
      public class var GdipGetTextureTransform: function( brush: TGdipTexturePtr; matrix: TGdipMatrixPtr): TGdipStatusEnum; stdcall;
      public class var GdipGetTextureWrapMode: function( brush: TGdipTexturePtr; out wrapmode: TGdipWrapModeEnum): TGdipStatusEnum; stdcall;
      public class var GdipGetVisibleClipBounds: function( graphics: TGdipGraphicsPtr; out rect: TRectangleF): TGdipStatusEnum; stdcall;
      public class var GdipGetWorldTransform: function( graphics: TGdipGraphicsPtr; matrix: TGdipMatrixPtr): TGdipStatusEnum; stdcall;
      public class var GdipGraphicsClear: function( graphics: TGdipGraphicsPtr; color: UInt32): TGdipStatusEnum; stdcall;
      public class var GdipImageForceValidation: function( image: TGdipImagePtr): TGdipStatusEnum; stdcall;
      public class var GdipImageGetFrameCount: function( image: TGdipImagePtr; dimensionID: PGuid; out count: UInt32): TGdipStatusEnum; stdcall;
      public class var GdipImageGetFrameDimensionsCount: function( image: TGdipImagePtr; out count: UInt32): TGdipStatusEnum; stdcall;
      public class var GdipImageGetFrameDimensionsList: function( image: TGdipImagePtr; dimensionIDs: PGuid; count: UInt32): TGdipStatusEnum; stdcall;
      public class var GdipImageRotateFlip: function( image: TGdipImagePtr; rfType: TGdipRotateFlipTypeEnum): TGdipStatusEnum; stdcall;
      public class var GdipImageSelectActiveFrame: function( image: TGdipImagePtr; dimensionID: PGuid; frameIndex: UInt32): TGdipStatusEnum; stdcall;
      public class var GdipInitializePalette: function( palette: TGdipColorPalettePtr; palettetype: TGdipPaletteTypeEnum; optimalColors: Integer; useTransparentColor: LongBool; bitmap: TGdipBitmapPtr): TGdipStatusEnum; stdcall;
      public class var GdipInvertMatrix: function( matrix: TGdipMatrixPtr): TGdipStatusEnum; stdcall;
      public class var GdipIsClipEmpty: function( graphics: TGdipGraphicsPtr; out _result: LongBool): TGdipStatusEnum; stdcall;
      public class var GdipIsEmptyRegion: function( region: TGdipRegionPtr; graphics: TGdipGraphicsPtr; out _result: LongBool): TGdipStatusEnum; stdcall;
      public class var GdipIsInfiniteRegion: function( region: TGdipRegionPtr; graphics: TGdipGraphicsPtr; out isInfinite: LongBool): TGdipStatusEnum; stdcall;
      public class var GdipIsEqualRegion: function( region: TGdipRegionPtr; region2: TGdipRegionPtr; graphics: TGdipGraphicsPtr; out _result: LongBool): TGdipStatusEnum; stdcall;
      public class var GdipIsMatrixEqual: function( matrix: TGdipMatrixPtr; matrix2: TGdipMatrixPtr; out _result: LongBool): TGdipStatusEnum; stdcall;
      public class var GdipIsMatrixIdentity: function( matrix: TGdipMatrixPtr; out _result: LongBool): TGdipStatusEnum; stdcall;
      public class var GdipIsMatrixInvertible: function( matrix: TGdipMatrixPtr; out _result: LongBool): TGdipStatusEnum; stdcall;
      public class var GdipIsOutlineVisiblePathPoint: function( path: TGdipPathPtr; x: Single; y: Single; pen: TGdipPenPtr; graphics: TGdipGraphicsPtr; out _result: LongBool): TGdipStatusEnum; stdcall;
      public class var GdipIsStyleAvailable: function( family: TGdipFontFamilyPtr; style: Integer; out IsStyleAvailable: LongBool): TGdipStatusEnum; stdcall;
      public class var GdipIsVisibleClipEmpty: function( graphics: TGdipGraphicsPtr; out _result: LongBool): TGdipStatusEnum; stdcall;
      public class var GdipIsVisiblePathPoint: function( path: TGdipPathPtr; x: Single; y: Single; graphics: TGdipGraphicsPtr; out _result: LongBool): TGdipStatusEnum; stdcall;
      public class var GdipIsVisiblePoint: function( graphics: TGdipGraphicsPtr; x: Single; y: Single; out _result: LongBool): TGdipStatusEnum; stdcall;
      public class var GdipIsVisibleRect: function( graphics: TGdipGraphicsPtr; x: Single; y: Single; width: Single; height: Single; out _result: LongBool): TGdipStatusEnum; stdcall;
      public class var GdipIsVisibleRegionPoint: function( region: TGdipRegionPtr; x: Single; y: Single; graphics: TGdipGraphicsPtr; out _result: LongBool): TGdipStatusEnum; stdcall;
      public class var GdipIsVisibleRegionRect: function( region: TGdipRegionPtr; x: Single; y: Single; width: Single; height: Single; graphics: TGdipGraphicsPtr; out _result: LongBool): TGdipStatusEnum; stdcall;
      public class var GdipLoadImageFromFile: function( filename: PWideChar; out image: TGdipImagePtr): TGdipStatusEnum; stdcall;
      public class var GdipLoadImageFromFileICM: function( filename: PWideChar; out image: TGdipImagePtr): TGdipStatusEnum; stdcall;
      public class var GdipLoadImageFromStream: function( stream: IStream; out image: TGdipImagePtr): TGdipStatusEnum; stdcall;
      public class var GdipLoadImageFromStreamICM: function( stream: IStream; out image: TGdipImagePtr): TGdipStatusEnum; stdcall;
      public class var GdipGetImageBounds: function(image: TGdipImagePtr; out srcRect: TRectangleF; out srcUnit: TGdipUnitEnum): TGdipStatusEnum; stdcall;

      /// <summary>
      /// GDI+ initialization. Must not be called from DllMain - can cause deadlock.
      ///
      /// Must be called before GDI+ API's or constructors are used.
      ///
      /// token  - may not be NULL - accepts a token to be passed in the corresponding
      ///          GdiplusShutdown call.
      /// input  - may not be NULL
      /// output - may be NULL only if input->SuppressBackgroundThread is FALSE.
      /// </summary>
      public class var GdiplusStartup: function(out token: NativeUInt; input: PGdiplusStartupInput; out output: TGdiplusStartupOutput): TGdipStatusEnum; stdcall;

      //// <summary>
      /// GDI+ termination. Must be called before GDI+ is unloaded.
      /// Must not be called from DllMain - can cause deadlock.
      ///
      /// GDI+ API's may not be called after GdiplusShutdown. Pay careful attention
      /// to GDI+ object destructors.
      /// </summary>
      public class var GdiplusShutdown: procedure(token: NativeUInt); stdcall;

      public class var GdipMeasureCharacterRanges: function( graphics: TGdipGraphicsPtr; &string: PWideChar; length: Integer; font: TGdipFontPtr; layoutRect: PRectangleF; stringFormat: TGdipStringFormatPtr; regionCount: Integer; out regions: TGdipRegionPtr): TGdipStatusEnum; stdcall;
      public class var GdipMeasureString: function( graphics: TGdipGraphicsPtr; &string: PWideChar; length: Integer; font: TGdipFontPtr; layoutRect: PRectangleF; stringFormat: TGdipStringFormatPtr; boundingBox: PRectangleF; codepointsFitted: PInteger; linesFilled: PInteger): TGdipStatusEnum; stdcall;
      public class var GdipMultiplyLineTransform: function( brush: TGdipLineGradientPtr; matrix: TGdipMatrixPtr; order: TGdipMatrixOrderEnum): TGdipStatusEnum; stdcall;
      public class var GdipMultiplyMatrix: function( matrix: TGdipMatrixPtr; matrix2: TGdipMatrixPtr; order: TGdipMatrixOrderEnum): TGdipStatusEnum; stdcall;
      public class var GdipMultiplyPathGradientTransform: function( brush: TGdipPathGradientPtr; matrix: TGdipMatrixPtr; order: TGdipMatrixOrderEnum): TGdipStatusEnum; stdcall;
      public class var GdipMultiplyPenTransform: function( pen: TGdipPenPtr; matrix: TGdipMatrixPtr; order: TGdipMatrixOrderEnum): TGdipStatusEnum; stdcall;
      public class var GdipMultiplyTextureTransform: function( brush: TGdipTexturePtr; matrix: TGdipMatrixPtr; order: TGdipMatrixOrderEnum): TGdipStatusEnum; stdcall;
      public class var GdipMultiplyWorldTransform: function( graphics: TGdipGraphicsPtr; matrix: TGdipMatrixPtr; order: TGdipMatrixOrderEnum): TGdipStatusEnum; stdcall;
      public class var GdipNewInstalledFontCollection: function(out fontCollection: TGdipFontCollectionPtr): TGdipStatusEnum; stdcall;
      public class var GdipNewPrivateFontCollection: function(out fontCollection: TGdipFontCollectionPtr): TGdipStatusEnum; stdcall;
      public class var GdipPathIterCopyData: function( iterator: TGdipPathIteratorPtr; resultCount: PInteger; points: PPointF; types: PByte; startIndex: Integer; endIndex: Integer): TGdipStatusEnum; stdcall;
      public class var GdipPathIterEnumerate: function( iterator: TGdipPathIteratorPtr; resultCount: PInteger; points: PPointF; types: PByte; count: Integer): TGdipStatusEnum; stdcall;
      public class var GdipPathIterGetCount: function( iterator: TGdipPathIteratorPtr; count: PInteger): TGdipStatusEnum; stdcall;
      public class var GdipPathIterGetSubpathCount: function( iterator: TGdipPathIteratorPtr; count: PInteger): TGdipStatusEnum; stdcall;
      public class var GdipPathIterHasCurve: function( iterator: TGdipPathIteratorPtr; hasCurve: PLongBool): TGdipStatusEnum; stdcall;
      public class var GdipPathIterIsValid: function( iterator: TGdipPathIteratorPtr; valid: PLongBool): TGdipStatusEnum; stdcall;
      public class var GdipPathIterNextMarker: function( iterator: TGdipPathIteratorPtr; resultCount: PInteger; startIndex: PInteger; endIndex: PInteger): TGdipStatusEnum; stdcall;
      public class var GdipPathIterNextMarkerPath: function( iterator: TGdipPathIteratorPtr; resultCount: PInteger; path: TGdipPathPtr): TGdipStatusEnum; stdcall;
      public class var GdipPathIterNextPathType: function( iterator: TGdipPathIteratorPtr; resultCount: PInteger; pathType: PByte; startIndex: PInteger; endIndex: PInteger): TGdipStatusEnum; stdcall;
      public class var GdipPathIterNextSubpath: function( iterator: TGdipPathIteratorPtr; resultCount: PInteger; startIndex: PInteger; endIndex: PInteger; isClosed: PLongBool): TGdipStatusEnum; stdcall;
      public class var GdipPathIterNextSubpathPath: function( iterator: TGdipPathIteratorPtr; resultCount: PInteger; path: TGdipPathPtr; isClosed: PLongBool): TGdipStatusEnum; stdcall;
      public class var GdipPathIterRewind: function( iterator: TGdipPathIteratorPtr): TGdipStatusEnum; stdcall;
      public class var GdipPlayMetafileRecord: function( metafile: TGdipMetafilePtr; recordType: TGdipEmfPlusRecordTypeEnum; flags: UInt32; dataSize: UInt32; data: PByte): TGdipStatusEnum; stdcall;
      public class var GdipPrivateAddFontFile: function( fontCollection: TGdipFontCollectionPtr; filename: PWideChar): TGdipStatusEnum; stdcall;
      public class var GdipPrivateAddMemoryFont: function( fontCollection: TGdipFontCollectionPtr; memory: Pointer; length: Integer): TGdipStatusEnum; stdcall;
      public class var GdipRecordMetafile: function( referenceHdc: HDC; &type: TGdipEmfTypeEnum; frameRect: PRectangleF; frameUnit: TGdipMetafileFrameUnitEnum; description: PWideChar; out metafile: TGdipMetafilePtr): TGdipStatusEnum; stdcall;
      public class var GdipRecordMetafileFileName: function( fileName: PWideChar; referenceHdc: HDC; &type: TGdipEmfTypeEnum; frameRect: PRectangleF; frameUnit: TGdipMetafileFrameUnitEnum; description: PWideChar; out metafile: TGdipMetafilePtr): TGdipStatusEnum; stdcall;
      public class var GdipRecordMetafileStream: function( stream: IStream; referenceHdc: HDC; &type: TGdipEmfTypeEnum; frameRect: PRectangleF; frameUnit: TGdipMetafileFrameUnitEnum; description: PWideChar; out metafile: TGdipMetafilePtr): TGdipStatusEnum; stdcall;
      public class var GdipReleaseDC: function( graphics: TGdipGraphicsPtr; hdc: HDC): TGdipStatusEnum; stdcall;
      public class var GdipRemovePropertyItem: function( image: TGdipImagePtr; propId: UInt32): TGdipStatusEnum; stdcall;
      public class var GdipResetClip: function( graphics: TGdipGraphicsPtr): TGdipStatusEnum; stdcall;
      public class var GdipResetLineTransform: function( brush: TGdipLineGradientPtr): TGdipStatusEnum; stdcall;
      public class var GdipResetPath: function( path: TGdipPathPtr): TGdipStatusEnum; stdcall;
      public class var GdipResetPathGradientTransform: function( brush: TGdipPathGradientPtr): TGdipStatusEnum; stdcall;
      public class var GdipResetPenTransform: function( pen: TGdipPenPtr): TGdipStatusEnum; stdcall;
      public class var GdipResetTextureTransform: function( brush: TGdipTexturePtr): TGdipStatusEnum; stdcall;
      public class var GdipResetWorldTransform: function( graphics: TGdipGraphicsPtr): TGdipStatusEnum; stdcall;
      public class var GdipRestoreGraphics: function( graphics: TGdipGraphicsPtr; state: UInt32): TGdipStatusEnum; stdcall;
      public class var GdipReversePath: function( path: TGdipPathPtr): TGdipStatusEnum; stdcall;
      public class var GdipRotateLineTransform: function( brush: TGdipLineGradientPtr; angle: Single; order: TGdipMatrixOrderEnum): TGdipStatusEnum; stdcall;
      public class var GdipRotateMatrix: function(matrix: TGdipMatrixPtr; angle: Single; order: TGdipMatrixOrderEnum): TGdipStatusEnum; stdcall;
      public class var GdipRotatePathGradientTransform: function( brush: TGdipPathGradientPtr; angle: Single; order: TGdipMatrixOrderEnum): TGdipStatusEnum; stdcall;
      public class var GdipRotatePenTransform: function( pen: TGdipPenPtr; angle: Single; order: TGdipMatrixOrderEnum): TGdipStatusEnum; stdcall;
      public class var GdipRotateTextureTransform: function( brush: TGdipTexturePtr; angle: Single; order: TGdipMatrixOrderEnum): TGdipStatusEnum; stdcall;
      public class var GdipRotateWorldTransform: function( graphics: TGdipGraphicsPtr; angle: Single; order: TGdipMatrixOrderEnum): TGdipStatusEnum; stdcall;
      public class var GdipSaveAdd: function(image: TGdipImagePtr; encoderParams: TGdipEncoderParametersPtr): TGdipStatusEnum; stdcall;
      public class var GdipSaveAddImage: function( image: TGdipImagePtr; newImage: TGdipImagePtr; encoderParams: TGdipEncoderParametersPtr): TGdipStatusEnum; stdcall;
      public class var GdipSaveGraphics: function( graphics: TGdipGraphicsPtr; out state: UInt32): TGdipStatusEnum; stdcall;
      public class var GdipSaveImageToFile: function( image: TGdipImagePtr; filename: PWideChar; clsidEncoder: PGuid; encoderParams: TGdipEncoderParametersPtr): TGdipStatusEnum; stdcall;
      public class var GdipScaleLineTransform: function( brush: TGdipLineGradientPtr; sx: Single; sy: Single; order: TGdipMatrixOrderEnum): TGdipStatusEnum; stdcall;
      public class var GdipScaleMatrix: function( matrix: TGdipMatrixPtr; scaleX: Single; scaleY: Single; order: TGdipMatrixOrderEnum): TGdipStatusEnum; stdcall;
      public class var GdipScalePathGradientTransform: function( brush: TGdipPathGradientPtr; sx: Single; sy: Single; order: TGdipMatrixOrderEnum): TGdipStatusEnum; stdcall;
      public class var GdipScalePenTransform: function( pen: TGdipPenPtr; sx: Single; sy: Single; order: TGdipMatrixOrderEnum): TGdipStatusEnum; stdcall;
      public class var GdipScaleTextureTransform: function( brush: TGdipTexturePtr; sx: Single; sy: Single; order: TGdipMatrixOrderEnum): TGdipStatusEnum; stdcall;
      public class var GdipScaleWorldTransform: function( graphics: TGdipGraphicsPtr; sx: Single; sy: Single; order: TGdipMatrixOrderEnum): TGdipStatusEnum; stdcall;
      public class var GdipSetAdjustableArrowCapFillState: function( cap: TGdipAdjustableArrowCapPtr; fillState: LongBool): TGdipStatusEnum; stdcall;
      public class var GdipSetAdjustableArrowCapHeight: function( cap: TGdipAdjustableArrowCapPtr; height: Single): TGdipStatusEnum; stdcall;
      public class var GdipSetAdjustableArrowCapMiddleInset: function( cap: TGdipAdjustableArrowCapPtr; middleInset: Single): TGdipStatusEnum; stdcall;
      public class var GdipSetAdjustableArrowCapWidth: function( cap: TGdipAdjustableArrowCapPtr; width: Single): TGdipStatusEnum; stdcall;
      public class var GdipSetClipGraphics: function( graphics: TGdipGraphicsPtr; srcgraphics: TGdipGraphicsPtr; combineMode: TGdipCombineModeEnum): TGdipStatusEnum; stdcall;
      public class var GdipSetClipPath: function( graphics: TGdipGraphicsPtr; path: TGdipPathPtr; combineMode: TGdipCombineModeEnum): TGdipStatusEnum; stdcall;
      public class var GdipSetClipRect: function( graphics: TGdipGraphicsPtr; x: Single; y: Single; width: Single; height: Single; combineMode: TGdipCombineModeEnum): TGdipStatusEnum; stdcall;
      public class var GdipSetClipRegion: function( graphics: TGdipGraphicsPtr; region: TGdipRegionPtr; combineMode: TGdipCombineModeEnum): TGdipStatusEnum; stdcall;
      public class var GdipSetCompositingMode: function( graphics: TGdipGraphicsPtr; compositingMode: TGdipCompositingModeEnum): TGdipStatusEnum; stdcall;
      public class var GdipSetCompositingQuality: function( graphics: TGdipGraphicsPtr; compositingQuality: TGdipCompositingQualityEnum): TGdipStatusEnum; stdcall;
      public class var GdipSetCustomLineCapBaseCap: function( customCap: TGdipCustomLineCapPtr; baseCap: TGdipLineCapEnum): TGdipStatusEnum; stdcall;
      public class var GdipSetCustomLineCapBaseInset: function( customCap: TGdipCustomLineCapPtr; inset: Single): TGdipStatusEnum; stdcall;
      public class var GdipSetCustomLineCapStrokeCaps: function( customCap: TGdipCustomLineCapPtr; startCap: TGdipLineCapEnum; endCap: TGdipLineCapEnum): TGdipStatusEnum; stdcall;
      public class var GdipSetCustomLineCapStrokeJoin: function( customCap: TGdipCustomLineCapPtr; lineJoin: TGdipLineJoinEnum): TGdipStatusEnum; stdcall;
      public class var GdipSetCustomLineCapWidthScale: function( customCap: TGdipCustomLineCapPtr; widthScale: Single): TGdipStatusEnum; stdcall;
      public class var GdipSetEffectParameters: function( effect: TGdipEffectPtr; params: Pointer; size: UInt32): TGdipStatusEnum; stdcall;
      public class var GdipSetEmpty: function( region: TGdipRegionPtr): TGdipStatusEnum; stdcall;
      public class var GdipSetImageAttributesColorKeys: function( imageattr: TGdipImageAttributesPtr; &type: TGdipColorAdjustTypeEnum; enableFlag: LongBool; colorLow: UInt32; colorHigh: UInt32): TGdipStatusEnum; stdcall;
      public class var GdipSetImageAttributesColorMatrix: function( imageattr: TGdipImageAttributesPtr; &type: TGdipColorAdjustTypeEnum; enableFlag: LongBool; colorMatrix: TGdipColorMatrixPtr; grayMatrix: TGdipColorMatrixPtr; flags: TGdipColorMatrixFlagEnum): TGdipStatusEnum; stdcall;
      public class var GdipSetImageAttributesGamma: function( imageattr: TGdipImageAttributesPtr; &type: TGdipColorAdjustTypeEnum; enableFlag: LongBool; gamma: Single): TGdipStatusEnum; stdcall;
      public class var GdipSetImageAttributesNoOp: function( imageattr: TGdipImageAttributesPtr; &type: TGdipColorAdjustTypeEnum; enableFlag: LongBool): TGdipStatusEnum; stdcall;
      public class var GdipSetImageAttributesOutputChannel: function( imageattr: TGdipImageAttributesPtr; &type: TGdipColorAdjustTypeEnum; enableFlag: LongBool; channelFlags: TGdipColorChannelFlagsEnum): TGdipStatusEnum; stdcall;
      public class var GdipSetImageAttributesOutputChannelColorProfile: function( imageattr: TGdipImageAttributesPtr; &type: TGdipColorAdjustTypeEnum; enableFlag: LongBool; colorProfileFilename: PWideChar): TGdipStatusEnum; stdcall;
      public class var GdipSetImageAttributesRemapTable: function( imageattr: TGdipImageAttributesPtr; &type: TGdipColorAdjustTypeEnum; enableFlag: LongBool; mapSize: UInt32; const map: TGdipColorMapPtr): TGdipStatusEnum; stdcall;
      public class var GdipSetImageAttributesThreshold: function( imageattr: TGdipImageAttributesPtr; &type: TGdipColorAdjustTypeEnum; enableFlag: LongBool; threshold: Single): TGdipStatusEnum; stdcall;
      public class var GdipSetImageAttributesWrapMode: function( imageAttr: TGdipImageAttributesPtr; wrap: TGdipWrapModeEnum; argb: UInt32; clamp: LongBool): TGdipStatusEnum; stdcall;
      public class var GdipSetImagePalette: function( image: TGdipImagePtr; palette: TGdipColorPalettePtr): TGdipStatusEnum; stdcall;
      public class var GdipSetInfinite: function( region: TGdipRegionPtr): TGdipStatusEnum; stdcall;
      public class var GdipSetInterpolationMode: function( graphics: TGdipGraphicsPtr; interpolationMode: TGdipInterpolationModeEnum): TGdipStatusEnum; stdcall;
      public class var GdipSetLineBlend: function( brush: TGdipLineGradientPtr; blend: PSingle; positions: PSingle; count: Integer): TGdipStatusEnum; stdcall;
      public class var GdipSetLineColors: function( brush: TGdipLineGradientPtr; color1: UInt32; color2: UInt32): TGdipStatusEnum; stdcall;
      public class var GdipSetLineGammaCorrection: function( brush: TGdipLineGradientPtr; useGammaCorrection: LongBool): TGdipStatusEnum; stdcall;
      public class var GdipSetLineLinearBlend: function( brush: TGdipLineGradientPtr; focus: Single; scale: Single): TGdipStatusEnum; stdcall;
      public class var GdipSetLinePresetBlend: function( brush: TGdipLineGradientPtr; blend: PUInt32; positions: PSingle; count: Integer): TGdipStatusEnum; stdcall;
      public class var GdipSetLineSigmaBlend: function( brush: TGdipLineGradientPtr; focus: Single; scale: Single): TGdipStatusEnum; stdcall;
      public class var GdipSetLineTransform: function( brush: TGdipLineGradientPtr; matrix: TGdipMatrixPtr): TGdipStatusEnum; stdcall;
      public class var GdipSetLineWrapMode: function( brush: TGdipLineGradientPtr; wrapmode: TGdipWrapModeEnum): TGdipStatusEnum; stdcall;
      public class var GdipSetMatrixElements: function( matrix: TGdipMatrixPtr; m11: Single; m12: Single; m21: Single; m22: Single; dx: Single; dy: Single): TGdipStatusEnum; stdcall;
      public class var GdipSetPageScale: function( graphics: TGdipGraphicsPtr; scale: Single): TGdipStatusEnum; stdcall;
      public class var GdipSetPageUnit: function( graphics: TGdipGraphicsPtr; &unit: TGdipUnitEnum): TGdipStatusEnum; stdcall;
      public class var GdipSetPathFillMode: function( path: TGdipPathPtr; fillmode: TGdipFillModeEnum): TGdipStatusEnum; stdcall;
      public class var GdipSetPathGradientBlend: function( brush: TGdipPathGradientPtr; blend: PSingle; positions: PSingle; count: Integer): TGdipStatusEnum; stdcall;
      public class var GdipSetPathGradientCenterColor: function( brush: TGdipPathGradientPtr; colors: UInt32): TGdipStatusEnum; stdcall;
      public class var GdipSetPathGradientCenterPoint: function( brush: TGdipPathGradientPtr; points: PPointF): TGdipStatusEnum; stdcall;
      public class var GdipSetPathGradientFocusScales: function( brush: TGdipPathGradientPtr; xScale: Single; yScale: Single): TGdipStatusEnum; stdcall;
      public class var GdipSetPathGradientLinearBlend: function( brush: TGdipPathGradientPtr; focus: Single; scale: Single): TGdipStatusEnum; stdcall;
      public class var GdipSetPathGradientPresetBlend: function( brush: TGdipPathGradientPtr; blend: PUInt32; positions: PSingle; count: Integer): TGdipStatusEnum; stdcall;
      public class var GdipSetPathGradientSigmaBlend: function( brush: TGdipPathGradientPtr; focus: Single; scale: Single): TGdipStatusEnum; stdcall;
      public class var GdipSetPathGradientSurroundColorsWithCount: function( brush: TGdipPathGradientPtr; color: PUInt32; var count: Integer): TGdipStatusEnum; stdcall;
      public class var GdipSetPathGradientTransform: function( brush: TGdipPathGradientPtr; matrix: TGdipMatrixPtr): TGdipStatusEnum; stdcall;
      public class var GdipSetPathGradientWrapMode: function( brush: TGdipPathGradientPtr; wrapmode: TGdipWrapModeEnum): TGdipStatusEnum; stdcall;
      public class var GdipSetPathMarker: function( path: TGdipPathPtr): TGdipStatusEnum; stdcall;
      public class var GdipSetPenBrushFill: function( pen: TGdipPenPtr; brush: TGdipBrushPtr): TGdipStatusEnum; stdcall;
      public class var GdipSetPenColor: function( pen: TGdipPenPtr; argb: UInt32): TGdipStatusEnum; stdcall;
      public class var GdipSetPenCompoundArray: function( pen: TGdipPenPtr; dash: PSingle; count: Integer): TGdipStatusEnum; stdcall;
      public class var GdipSetPenCustomEndCap: function( pen: TGdipPenPtr; customCap: TGdipCustomLineCapPtr): TGdipStatusEnum; stdcall;
      public class var GdipSetPenCustomStartCap: function( pen: TGdipPenPtr; customCap: TGdipCustomLineCapPtr): TGdipStatusEnum; stdcall;
      public class var GdipSetPenDashArray: function( pen: TGdipPenPtr; dash: PSingle; count: Integer): TGdipStatusEnum; stdcall;
      public class var GdipSetPenDashCap197819: function( pen: TGdipPenPtr; dashCap: TGdipDashCapEnum): TGdipStatusEnum; stdcall;
      public class var GdipSetPenDashOffset: function( pen: TGdipPenPtr; offset: Single): TGdipStatusEnum; stdcall;
      public class var GdipSetPenDashStyle: function( pen: TGdipPenPtr; dashstyle: TGdipDashStyleEnum): TGdipStatusEnum; stdcall;
      public class var GdipSetPenEndCap: function( pen: TGdipPenPtr; endCap: TGdipLineCapEnum): TGdipStatusEnum; stdcall;
      public class var GdipSetPenLineCap197819: function( pen: TGdipPenPtr; startCap: TGdipLineCapEnum; endCap: TGdipLineCapEnum; dashCap: TGdipDashCapEnum): TGdipStatusEnum; stdcall;
      public class var GdipSetPenLineJoin: function( pen: TGdipPenPtr; lineJoin: TGdipLineJoinEnum): TGdipStatusEnum; stdcall;
      public class var GdipSetPenMiterLimit: function( pen: TGdipPenPtr; miterLimit: Single): TGdipStatusEnum; stdcall;
      public class var GdipSetPenMode: function( pen: TGdipPenPtr; penMode: TGdipPenAlignmentEnum): TGdipStatusEnum; stdcall;
      public class var GdipSetPenStartCap: function( pen: TGdipPenPtr; startCap: TGdipLineCapEnum): TGdipStatusEnum; stdcall;
      public class var GdipSetPenTransform: function( pen: TGdipPenPtr; matrix: TGdipMatrixPtr): TGdipStatusEnum; stdcall;
      public class var GdipSetPenWidth: function( pen: TGdipPenPtr; width: Single): TGdipStatusEnum; stdcall;
      public class var GdipSetPixelOffsetMode: function( graphics: TGdipGraphicsPtr; pixelOffsetMode: TGdipPixelOffsetModeEnum): TGdipStatusEnum; stdcall;
      public class var GdipSetPropertyItem: function( image: TGdipImagePtr; item: TGdipPropertyItemPtr): TGdipStatusEnum; stdcall;
      public class var GdipSetRenderingOrigin: function( graphics: TGdipGraphicsPtr; x: Integer; y: Integer): TGdipStatusEnum; stdcall;
      public class var GdipSetSmoothingMode: function( graphics: TGdipGraphicsPtr; smoothingMode: TGdipSmoothingModeEnum): TGdipStatusEnum; stdcall;
      public class var GdipSetSolidFillColor: function( brush: TGdipSolidFillPtr; const color: UInt32): TGdipStatusEnum; stdcall;
      public class var GdipSetStringFormatAlign: function( format: TGdipStringFormatPtr; align: TGdipStringAlignmentEnum): TGdipStatusEnum; stdcall;
      public class var GdipSetStringFormatDigitSubstitution: function( format: TGdipStringFormatPtr; language: UInt16; substitute: TGdipStringDigitSubstituteEnum): TGdipStatusEnum; stdcall;
      public class var GdipSetStringFormatFlags: function( format: TGdipStringFormatPtr; flags: Integer): TGdipStatusEnum; stdcall;
      public class var GdipSetStringFormatHotkeyPrefix: function( format: TGdipStringFormatPtr; hotkeyPrefix: TGdipHotkeyPrefixEnum): TGdipStatusEnum; stdcall;
      public class var GdipSetStringFormatLineAlign: function( format: TGdipStringFormatPtr; align: TGdipStringAlignmentEnum): TGdipStatusEnum; stdcall;
      public class var GdipSetStringFormatMeasurableCharacterRanges: function( format: TGdipStringFormatPtr; rangeCount: Integer; ranges: TGdipCharacterRangePtr): TGdipStatusEnum; stdcall;
      public class var GdipSetStringFormatTabStops: function( format: TGdipStringFormatPtr; firstTabOffset: Single; count: Integer; tabStops: PSingle): TGdipStatusEnum; stdcall;
      public class var GdipSetStringFormatTrimming: function( format: TGdipStringFormatPtr; trimming: TGdipStringTrimmingEnum): TGdipStatusEnum; stdcall;
      public class var GdipSetTextContrast: function( graphics: TGdipGraphicsPtr; contrast: UInt32): TGdipStatusEnum; stdcall;
      public class var GdipSetTextRenderingHint: function( graphics: TGdipGraphicsPtr; mode: TGdipTextRenderingHintEnum): TGdipStatusEnum; stdcall;
      public class var GdipSetTextureTransform: function( brush: TGdipTexturePtr; matrix: TGdipMatrixPtr): TGdipStatusEnum; stdcall;
      public class var GdipSetTextureWrapMode: function( brush: TGdipTexturePtr; wrapmode: TGdipWrapModeEnum): TGdipStatusEnum; stdcall;
      public class var GdipSetWorldTransform: function( graphics: TGdipGraphicsPtr; matrix: TGdipMatrixPtr): TGdipStatusEnum; stdcall;
      public class var GdipShearMatrix: function( matrix: TGdipMatrixPtr; shearX: Single; shearY: Single; order: TGdipMatrixOrderEnum): TGdipStatusEnum; stdcall;
      public class var GdipStartPathFigure: function( path: TGdipPathPtr): TGdipStatusEnum; stdcall;
      public class var GdipStringFormatGetGenericDefault: function( out format: TGdipStringFormatPtr): TGdipStatusEnum; stdcall;
      public class var GdipStringFormatGetGenericTypographic: function( out format: TGdipStringFormatPtr): TGdipStatusEnum; stdcall;
      public class var GdipTransformMatrixPoints: function( matrix: TGdipMatrixPtr; pts: PPointF; count: Integer): TGdipStatusEnum; stdcall;
      public class var GdipTransformMatrixPointsI: function( matrix: TGdipMatrixPtr; pts: PPoint; count: Integer): TGdipStatusEnum; stdcall;
      public class var GdipTransformPath: function( path: TGdipPathPtr; matrix: TGdipMatrixPtr): TGdipStatusEnum; stdcall;
      public class var GdipTransformPoints: function( graphics: TGdipGraphicsPtr; destSpace: TGdipCoordinateSpaceEnum; srcSpace: TGdipCoordinateSpaceEnum; points: PPointF; count: Integer): TGdipStatusEnum; stdcall;
      public class var GdipTransformPointsI: function( graphics: TGdipGraphicsPtr; destSpace: TGdipCoordinateSpaceEnum; srcSpace: TGdipCoordinateSpaceEnum; points: PPoint; count: Integer): TGdipStatusEnum; stdcall;
      public class var GdipTransformRegion: function( region: TGdipRegionPtr; matrix: TGdipMatrixPtr): TGdipStatusEnum; stdcall;
      public class var GdipTranslateClip: function( graphics: TGdipGraphicsPtr; dx: Single; dy: Single): TGdipStatusEnum; stdcall;
      public class var GdipTranslateLineTransform: function( brush: TGdipLineGradientPtr; dx: Single; dy: Single; order: TGdipMatrixOrderEnum): TGdipStatusEnum; stdcall;
      public class var GdipTranslateMatrix: function( matrix: TGdipMatrixPtr; offsetX: Single; offsetY: Single; order: TGdipMatrixOrderEnum): TGdipStatusEnum; stdcall;
      public class var GdipTranslatePathGradientTransform: function( brush: TGdipPathGradientPtr; dx: Single; dy: Single; order: TGdipMatrixOrderEnum): TGdipStatusEnum; stdcall;
      public class var GdipTranslatePenTransform: function( pen: TGdipPenPtr; dx: Single; dy: Single; order: TGdipMatrixOrderEnum): TGdipStatusEnum; stdcall;
      public class var GdipTranslateRegion: function( region: TGdipRegionPtr; dx: Single; dy: Single): TGdipStatusEnum; stdcall;
      public class var GdipTranslateTextureTransform: function( brush: TGdipTexturePtr; dx: Single; dy: Single; order: TGdipMatrixOrderEnum): TGdipStatusEnum; stdcall;
      public class var GdipTranslateWorldTransform: function( graphics: TGdipGraphicsPtr; dx: Single; dy: Single; order: TGdipMatrixOrderEnum): TGdipStatusEnum; stdcall;
      public class var GdipVectorTransformMatrixPoints: function( matrix: TGdipMatrixPtr; pts: PPointF; count: Integer): TGdipStatusEnum; stdcall;
      public class var GdipVectorTransformMatrixPointsI: function( matrix: TGdipMatrixPtr; pts: PPoint; count: Integer): TGdipStatusEnum; stdcall;
      public class var GdipWarpPath: function( path: TGdipPathPtr; matrix: TGdipMatrixPtr; points: PPointF; count: Integer; srcx: Single; srcy: Single; srcwidth: Single; srcheight: Single; warpMode: TGdipWarpModeEnum; flatness: Single): TGdipStatusEnum; stdcall;
      public class var GdipWidenPath: function( nativePath: TGdipPathPtr; pen: TGdipPenPtr; matrix: TGdipMatrixPtr; flatness: Single): TGdipStatusEnum; stdcall;
   end;

implementation

const
  REAL_MAX       = MaxSingle;
  REAL_MIN       = MinSingle;
  REAL_TOLERANCE = (MinSingle * 100);
  REAL_EPSILON   = 1.192092896e-07; // FLT_EPSILON

var
   HGdiplusModule: HMODULE = 0;

resourcestring
    SGdiplusGenericError = 'Ocorreu um erro genérico no GDI+.';
    SGdiplusInvalidParameter = 'Parâmetro inválido.';
    SGdiplusOutOfMemory = 'Sem memória.';
    SGdiplusObjectBusy = 'Objeto está atualmente em uso em outro lugar.';
    SGdiplusInsufficientBuffer = 'Buffer é muito pequeno (erro interno do GDI+).';
    SGdiplusNotImplemented = 'Não implementado.';
    SGdiplusWrongState = 'A região do bitmap já está bloqueada.';
    SGdiplusAborted = 'A função foi encerrada.';
    SGdiplusFileNotFound = 'Arquivo não encontrado.';
    SGdiplusOverflow = 'Erro de estouro.';
    SGdiplusAccessDenied = 'Acesso ao arquivo negado.';
    SGdiplusUnknownImageFormat = 'O formato da imagem é desconhecido.';
    SGdiplusPropertyNotFoundError = 'Propriedade não encontrada.';
    SGdiplusPropertyNotSupportedError = 'Propriedade não suportada.';
    SGdiplusFontFamilyNotFound = 'A fonte "%s" não foi encontrada.';
    SGdiplusFontStyleNotFound = 'A fonte "%s" não suporta o estilo "%s".';
    SGdiplusNotTrueTypeFont_NoName = 'Apenas fontes TrueType são suportadas. Esta não é uma fonte TrueType.';
    SGdiplusUnsupportedGdiplusVersion = 'A versão atual do GDI+ não suporta este recurso.';
    SGdiplusNotInitialized = 'GDI+ não foi inicializado corretamente (erro interno do GDI+).';
    SGdiplusUnknown = 'Ocorreu um erro desconhecido de GDI+. "%d"';

{ TGdiplusAPI }

class destructor TGdiplusAPI.DestroyClass;
begin
   if HGdiplusModule <> 0 then
      Exit();

   if not FreeLibrary(HGdiplusModule) then
      raise EFileNotFoundException.Create('Falha ao descarregar o modulo/dll "gdiplus.dll".');

   HGdiplusModule := 0;
end;

class constructor TGdiplusAPI.CreateClass;
begin
   if HGdiplusModule <> 0 then
      Exit();

   HGdiplusModule := Winapi.Windows.LoadLibrary('gdiplus.dll');

   if HGdiplusModule = 0 then
      raise EFileNotFoundException.Create('Falha ao inicializar o modulo/dll "gdiplus.dll".');

   TGdiplusAPI.GdipAddPathArc := TGdiplusAPI.GetFunctionAddress('GdipAddPathArc');
   TGdiplusAPI.GdipAddPathBezier := TGdiplusAPI.GetFunctionAddress('GdipAddPathBezier');
   TGdiplusAPI.GdipAddPathBeziers := TGdiplusAPI.GetFunctionAddress('GdipAddPathBeziers');
   TGdiplusAPI.GdipAddPathBeziersI := TGdiplusAPI.GetFunctionAddress('GdipAddPathBeziersI');
   TGdiplusAPI.GdipAddPathClosedCurve2 := TGdiplusAPI.GetFunctionAddress('GdipAddPathClosedCurve2');
   TGdiplusAPI.GdipAddPathClosedCurve2I := TGdiplusAPI.GetFunctionAddress('GdipAddPathClosedCurve2I');
   TGdiplusAPI.GdipAddPathCurve2 := TGdiplusAPI.GetFunctionAddress('GdipAddPathCurve2');
   TGdiplusAPI.GdipAddPathCurve2I := TGdiplusAPI.GetFunctionAddress('GdipAddPathCurve2I');
   TGdiplusAPI.GdipAddPathCurve3 := TGdiplusAPI.GetFunctionAddress('GdipAddPathCurve3');
   TGdiplusAPI.GdipAddPathCurve3I := TGdiplusAPI.GetFunctionAddress('GdipAddPathCurve3I');
   TGdiplusAPI.GdipAddPathEllipse := TGdiplusAPI.GetFunctionAddress('GdipAddPathEllipse');
   TGdiplusAPI.GdipAddPathLine := TGdiplusAPI.GetFunctionAddress('GdipAddPathLine');
   TGdiplusAPI.GdipAddPathLine2 := TGdiplusAPI.GetFunctionAddress('GdipAddPathLine2');
   TGdiplusAPI.GdipAddPathLine2I := TGdiplusAPI.GetFunctionAddress('GdipAddPathLine2I');
   TGdiplusAPI.GdipAddPathPath := TGdiplusAPI.GetFunctionAddress('GdipAddPathPath');
   TGdiplusAPI.GdipAddPathPie := TGdiplusAPI.GetFunctionAddress('GdipAddPathPie');
   TGdiplusAPI.GdipAddPathPolygon := TGdiplusAPI.GetFunctionAddress('GdipAddPathPolygon');
   TGdiplusAPI.GdipAddPathPolygonI := TGdiplusAPI.GetFunctionAddress('GdipAddPathPolygonI');
   TGdiplusAPI.GdipAddPathRectangle := TGdiplusAPI.GetFunctionAddress('GdipAddPathRectangle');
   TGdiplusAPI.GdipAddPathRectangles := TGdiplusAPI.GetFunctionAddress('GdipAddPathRectangles');
   TGdiplusAPI.GdipAddPathRectanglesI := TGdiplusAPI.GetFunctionAddress('GdipAddPathRectanglesI');
   TGdiplusAPI.GdipAddPathString := TGdiplusAPI.GetFunctionAddress('GdipAddPathString');
   TGdiplusAPI.GdipBeginContainer := TGdiplusAPI.GetFunctionAddress('GdipBeginContainer');
   TGdiplusAPI.GdipBeginContainer2 := TGdiplusAPI.GetFunctionAddress('GdipBeginContainer2');
   TGdiplusAPI.GdipBitmapApplyEffect := TGdiplusAPI.GetFunctionAddress('GdipBitmapApplyEffect');
   TGdiplusAPI.GdipBitmapGetHistogramSize := TGdiplusAPI.GetFunctionAddress('GdipBitmapGetHistogramSize');
   TGdiplusAPI.GdipBitmapGetHistogram := TGdiplusAPI.GetFunctionAddress('GdipBitmapGetHistogram');
   TGdiplusAPI.GdipBitmapConvertFormat := TGdiplusAPI.GetFunctionAddress('GdipBitmapConvertFormat');
   TGdiplusAPI.GdipBitmapGetPixel := TGdiplusAPI.GetFunctionAddress('GdipBitmapGetPixel');
   TGdiplusAPI.GdipBitmapSetPixel := TGdiplusAPI.GetFunctionAddress('GdipBitmapSetPixel');
   TGdiplusAPI.GdipBitmapSetResolution := TGdiplusAPI.GetFunctionAddress('GdipBitmapSetResolution');
   TGdiplusAPI.GdipClearPathMarkers := TGdiplusAPI.GetFunctionAddress('GdipClearPathMarkers');
   TGdiplusAPI.GdipCloneBitmapArea := TGdiplusAPI.GetFunctionAddress('GdipCloneBitmapArea');
   TGdiplusAPI.GdipCloneBitmapAreaI := TGdiplusAPI.GetFunctionAddress('GdipCloneBitmapAreaI');
   TGdiplusAPI.GdipCloneBrush := TGdiplusAPI.GetFunctionAddress('GdipCloneBrush');
   TGdiplusAPI.GdipCloneCustomLineCap := TGdiplusAPI.GetFunctionAddress('GdipCloneCustomLineCap');
   TGdiplusAPI.GdipCloneFont := TGdiplusAPI.GetFunctionAddress('GdipCloneFont');
   TGdiplusAPI.GdipCloneFontFamily := TGdiplusAPI.GetFunctionAddress('GdipCloneFontFamily');
   TGdiplusAPI.GdipCloneImage := TGdiplusAPI.GetFunctionAddress('GdipCloneImage');
   TGdiplusAPI.GdipCloneImageAttributes := TGdiplusAPI.GetFunctionAddress('GdipCloneImageAttributes');
   TGdiplusAPI.GdipCloneMatrix := TGdiplusAPI.GetFunctionAddress('GdipCloneMatrix');
   TGdiplusAPI.GdipClonePath := TGdiplusAPI.GetFunctionAddress('GdipClonePath');
   TGdiplusAPI.GdipClonePen := TGdiplusAPI.GetFunctionAddress('GdipClonePen');
   TGdiplusAPI.GdipCloneRegion := TGdiplusAPI.GetFunctionAddress('GdipCloneRegion');
   TGdiplusAPI.GdipCloneStringFormat := TGdiplusAPI.GetFunctionAddress('GdipCloneStringFormat');
   TGdiplusAPI.GdipClosePathFigure := TGdiplusAPI.GetFunctionAddress('GdipClosePathFigure');
   TGdiplusAPI.GdipClosePathFigures := TGdiplusAPI.GetFunctionAddress('GdipClosePathFigures');
   TGdiplusAPI.GdipCombineRegionPath := TGdiplusAPI.GetFunctionAddress('GdipCombineRegionPath');
   TGdiplusAPI.GdipCombineRegionRect := TGdiplusAPI.GetFunctionAddress('GdipCombineRegionRect');
   TGdiplusAPI.GdipCombineRegionRegion := TGdiplusAPI.GetFunctionAddress('GdipCombineRegionRegion');
   TGdiplusAPI.GdipComment := TGdiplusAPI.GetFunctionAddress('GdipComment');
   TGdiplusAPI.GdipCreateAdjustableArrowCap := TGdiplusAPI.GetFunctionAddress('GdipCreateAdjustableArrowCap');
   TGdiplusAPI.GdipCreateBitmapFromFile := TGdiplusAPI.GetFunctionAddress('GdipCreateBitmapFromFile');
   TGdiplusAPI.GdipCreateBitmapFromFileICM := TGdiplusAPI.GetFunctionAddress('GdipCreateBitmapFromFileICM');
   TGdiplusAPI.GdipCreateBitmapFromGraphics := TGdiplusAPI.GetFunctionAddress('GdipCreateBitmapFromGraphics');
   TGdiplusAPI.GdipCreateBitmapFromHBITMAP := TGdiplusAPI.GetFunctionAddress('GdipCreateBitmapFromHBITMAP');
   TGdiplusAPI.GdipCreateBitmapFromHICON := TGdiplusAPI.GetFunctionAddress('GdipCreateBitmapFromHICON');
   TGdiplusAPI.GdipCreateBitmapFromResource := TGdiplusAPI.GetFunctionAddress('GdipCreateBitmapFromResource');
   TGdiplusAPI.GdipCreateBitmapFromScan0 := TGdiplusAPI.GetFunctionAddress('GdipCreateBitmapFromScan0');
   TGdiplusAPI.GdipCreateBitmapFromStream := TGdiplusAPI.GetFunctionAddress('GdipCreateBitmapFromStream');
   TGdiplusAPI.GdipCreateBitmapFromStreamICM := TGdiplusAPI.GetFunctionAddress('GdipCreateBitmapFromStreamICM');
   TGdiplusAPI.GdipCreateCachedBitmap := TGdiplusAPI.GetFunctionAddress('GdipCreateCachedBitmap');
   TGdiplusAPI.GdipCreateCustomLineCap := TGdiplusAPI.GetFunctionAddress('GdipCreateCustomLineCap');
   TGdiplusAPI.GdipCreateEffect := TGdiplusAPI.GetFunctionAddress('GdipCreateEffect');
   TGdiplusAPI.GdipCreateFont := TGdiplusAPI.GetFunctionAddress('GdipCreateFont');
   TGdiplusAPI.GdipCreateFontFamilyFromName := TGdiplusAPI.GetFunctionAddress('GdipCreateFontFamilyFromName');
   TGdiplusAPI.GdipCreateFontFromDC := TGdiplusAPI.GetFunctionAddress('GdipCreateFontFromDC');
   TGdiplusAPI.GdipCreateFontFromLogfontW := TGdiplusAPI.GetFunctionAddress('GdipCreateFontFromLogfontW');
   TGdiplusAPI.GdipCreateFromHDC := TGdiplusAPI.GetFunctionAddress('GdipCreateFromHDC');
   TGdiplusAPI.GdipCreateFromHDC2 := TGdiplusAPI.GetFunctionAddress('GdipCreateFromHDC2');
   TGdiplusAPI.GdipCreateFromHWND := TGdiplusAPI.GetFunctionAddress('GdipCreateFromHWND');
   TGdiplusAPI.GdipDeleteGraphics := TGdiplusAPI.GetFunctionAddress('GdipDeleteGraphics');
   TGdiplusAPI.GdipBitmapLockBits := TGdiplusAPI.GetFunctionAddress('GdipBitmapLockBits');
   TGdiplusAPI.GdipGetImagePixelFormat := TGdiplusAPI.GetFunctionAddress('GdipGetImagePixelFormat');
   TGdiplusAPI.GdipBitmapUnlockBits := TGdiplusAPI.GetFunctionAddress('GdipBitmapUnlockBits');
   TGdiplusAPI.GdipSaveImageToStream := TGdiplusAPI.GetFunctionAddress('GdipSaveImageToStream');
   TGdiplusAPI.GdipCreateHalftonePalette := TGdiplusAPI.GetFunctionAddress('GdipCreateHalftonePalette');
   TGdiplusAPI.GdipCreateHatchBrush := TGdiplusAPI.GetFunctionAddress('GdipCreateHatchBrush');
   TGdiplusAPI.GdipCreateHBITMAPFromBitmap := TGdiplusAPI.GetFunctionAddress('GdipCreateHBITMAPFromBitmap');
   TGdiplusAPI.GdipCreateHICONFromBitmap := TGdiplusAPI.GetFunctionAddress('GdipCreateHICONFromBitmap');
   TGdiplusAPI.GdipCreateImageAttributes := TGdiplusAPI.GetFunctionAddress('GdipCreateImageAttributes');
   TGdiplusAPI.GdipCreateLineBrush := TGdiplusAPI.GetFunctionAddress('GdipCreateLineBrush');
   TGdiplusAPI.GdipCreateLineBrushFromRect := TGdiplusAPI.GetFunctionAddress('GdipCreateLineBrushFromRect');
   TGdiplusAPI.GdipCreateLineBrushFromRectWithAngle := TGdiplusAPI.GetFunctionAddress('GdipCreateLineBrushFromRectWithAngle');
   TGdiplusAPI.GdipCreateMatrix := TGdiplusAPI.GetFunctionAddress('GdipCreateMatrix');
   TGdiplusAPI.GdipCreateMatrix2 := TGdiplusAPI.GetFunctionAddress('GdipCreateMatrix2');
   TGdiplusAPI.GdipCreateMatrix3 := TGdiplusAPI.GetFunctionAddress('GdipCreateMatrix3');
   TGdiplusAPI.GdipCreateMatrix3I := TGdiplusAPI.GetFunctionAddress('GdipCreateMatrix3I');
   TGdiplusAPI.GdipCreateMetafileFromEmf := TGdiplusAPI.GetFunctionAddress('GdipCreateMetafileFromEmf');
   TGdiplusAPI.GdipCreateMetafileFromFile := TGdiplusAPI.GetFunctionAddress('GdipCreateMetafileFromFile');
   TGdiplusAPI.GdipCreateMetafileFromStream := TGdiplusAPI.GetFunctionAddress('GdipCreateMetafileFromStream');
   TGdiplusAPI.GdipCreateMetafileFromWmf := TGdiplusAPI.GetFunctionAddress('GdipCreateMetafileFromWmf');
   TGdiplusAPI.GdipCreatePath := TGdiplusAPI.GetFunctionAddress('GdipCreatePath');
   TGdiplusAPI.GdipCreatePath2 := TGdiplusAPI.GetFunctionAddress('GdipCreatePath2');
   TGdiplusAPI.GdipCreatePath2I := TGdiplusAPI.GetFunctionAddress('GdipCreatePath2I');
   TGdiplusAPI.GdipCreatePathGradient := TGdiplusAPI.GetFunctionAddress('GdipCreatePathGradient');
   TGdiplusAPI.GdipCreatePathGradientFromPath := TGdiplusAPI.GetFunctionAddress('GdipCreatePathGradientFromPath');
   TGdiplusAPI.GdipCreatePathGradientI := TGdiplusAPI.GetFunctionAddress('GdipCreatePathGradientI');
   TGdiplusAPI.GdipCreatePathIter := TGdiplusAPI.GetFunctionAddress('GdipCreatePathIter');
   TGdiplusAPI.GdipCreatePen1 := TGdiplusAPI.GetFunctionAddress('GdipCreatePen1');
   TGdiplusAPI.GdipCreatePen2 := TGdiplusAPI.GetFunctionAddress('GdipCreatePen2');
   TGdiplusAPI.GdipCreateRegion := TGdiplusAPI.GetFunctionAddress('GdipCreateRegion');
   TGdiplusAPI.GdipCreateRegionHrgn := TGdiplusAPI.GetFunctionAddress('GdipCreateRegionHrgn');
   TGdiplusAPI.GdipGetRegionHRgn := TGdiplusAPI.GetFunctionAddress('GdipGetRegionHRgn');
   TGdiplusAPI.GdipCreateRegionPath := TGdiplusAPI.GetFunctionAddress('GdipCreateRegionPath');
   TGdiplusAPI.GdipCreateRegionRect := TGdiplusAPI.GetFunctionAddress('GdipCreateRegionRect');
   TGdiplusAPI.GdipCreateRegionRgnData := TGdiplusAPI.GetFunctionAddress('GdipCreateRegionRgnData');
   TGdiplusAPI.GdipCreateSolidFill := TGdiplusAPI.GetFunctionAddress('GdipCreateSolidFill');
   TGdiplusAPI.GdipCreateStringFormat := TGdiplusAPI.GetFunctionAddress('GdipCreateStringFormat');
   TGdiplusAPI.GdipCreateTexture := TGdiplusAPI.GetFunctionAddress('GdipCreateTexture');
   TGdiplusAPI.GdipCreateTexture2 := TGdiplusAPI.GetFunctionAddress('GdipCreateTexture2');
   TGdiplusAPI.GdipCreateTextureIA := TGdiplusAPI.GetFunctionAddress('GdipCreateTextureIA');
   TGdiplusAPI.GdipDeleteBrush := TGdiplusAPI.GetFunctionAddress('GdipDeleteBrush');
   TGdiplusAPI.GdipDeleteCachedBitmap := TGdiplusAPI.GetFunctionAddress('GdipDeleteCachedBitmap');
   TGdiplusAPI.GdipDeleteCustomLineCap := TGdiplusAPI.GetFunctionAddress('GdipDeleteCustomLineCap');
   TGdiplusAPI.GdipDeleteEffect := TGdiplusAPI.GetFunctionAddress('GdipDeleteEffect');
   TGdiplusAPI.GdipDeleteFont := TGdiplusAPI.GetFunctionAddress('GdipDeleteFont');
   TGdiplusAPI.GdipDeleteFontFamily := TGdiplusAPI.GetFunctionAddress('GdipDeleteFontFamily');
   TGdiplusAPI.GdipDeleteMatrix := TGdiplusAPI.GetFunctionAddress('GdipDeleteMatrix');
   TGdiplusAPI.GdipDeletePath := TGdiplusAPI.GetFunctionAddress('GdipDeletePath');
   TGdiplusAPI.GdipDeletePathIter := TGdiplusAPI.GetFunctionAddress('GdipDeletePathIter');
   TGdiplusAPI.GdipDeletePen := TGdiplusAPI.GetFunctionAddress('GdipDeletePen');
   TGdiplusAPI.GdipDeletePrivateFontCollection := TGdiplusAPI.GetFunctionAddress('GdipDeletePrivateFontCollection');
   TGdiplusAPI.GdipDeleteRegion := TGdiplusAPI.GetFunctionAddress('GdipDeleteRegion');
   TGdiplusAPI.GdipDeleteStringFormat := TGdiplusAPI.GetFunctionAddress('GdipDeleteStringFormat');
   TGdiplusAPI.GdipDisposeImage := TGdiplusAPI.GetFunctionAddress('GdipDisposeImage');
   TGdiplusAPI.GdipDisposeImageAttributes := TGdiplusAPI.GetFunctionAddress('GdipDisposeImageAttributes');
   TGdiplusAPI.GdipDrawArc := TGdiplusAPI.GetFunctionAddress('GdipDrawArc');
   TGdiplusAPI.GdipDrawBezier := TGdiplusAPI.GetFunctionAddress('GdipDrawBezier');
   TGdiplusAPI.GdipDrawBeziers := TGdiplusAPI.GetFunctionAddress('GdipDrawBeziers');
   TGdiplusAPI.GdipDrawBeziersI := TGdiplusAPI.GetFunctionAddress('GdipDrawBeziersI');
   TGdiplusAPI.GdipDrawCachedBitmap := TGdiplusAPI.GetFunctionAddress('GdipDrawCachedBitmap');
   TGdiplusAPI.GdipDrawClosedCurve := TGdiplusAPI.GetFunctionAddress('GdipDrawClosedCurve');
   TGdiplusAPI.GdipDrawClosedCurve2 := TGdiplusAPI.GetFunctionAddress('GdipDrawClosedCurve2');
   TGdiplusAPI.GdipDrawClosedCurve2I := TGdiplusAPI.GetFunctionAddress('GdipDrawClosedCurve2I');
   TGdiplusAPI.GdipDrawClosedCurveI := TGdiplusAPI.GetFunctionAddress('GdipDrawClosedCurveI');
   TGdiplusAPI.GdipDrawCurve := TGdiplusAPI.GetFunctionAddress('GdipDrawCurve');
   TGdiplusAPI.GdipDrawCurve2 := TGdiplusAPI.GetFunctionAddress('GdipDrawCurve2');
   TGdiplusAPI.GdipDrawCurve2I := TGdiplusAPI.GetFunctionAddress('GdipDrawCurve2I');
   TGdiplusAPI.GdipDrawCurve3 := TGdiplusAPI.GetFunctionAddress('GdipDrawCurve3');
   TGdiplusAPI.GdipDrawCurve3I := TGdiplusAPI.GetFunctionAddress('GdipDrawCurve3I');
   TGdiplusAPI.GdipDrawCurveI := TGdiplusAPI.GetFunctionAddress('GdipDrawCurveI');
   TGdiplusAPI.GdipDrawEllipse := TGdiplusAPI.GetFunctionAddress('GdipDrawEllipse');
   TGdiplusAPI.GdipDrawImage := TGdiplusAPI.GetFunctionAddress('GdipDrawImage');
   TGdiplusAPI.GdipDrawImageFX := TGdiplusAPI.GetFunctionAddress('GdipDrawImageFX');
   TGdiplusAPI.GdipDrawImagePointRect := TGdiplusAPI.GetFunctionAddress('GdipDrawImagePointRect');
   TGdiplusAPI.GdipDrawImagePoints := TGdiplusAPI.GetFunctionAddress('GdipDrawImagePoints');
   TGdiplusAPI.GdipDrawImagePointsI := TGdiplusAPI.GetFunctionAddress('GdipDrawImagePointsI');
   TGdiplusAPI.GdipDrawImagePointsRect := TGdiplusAPI.GetFunctionAddress('GdipDrawImagePointsRect');
   TGdiplusAPI.GdipDrawImagePointsRectI := TGdiplusAPI.GetFunctionAddress('GdipDrawImagePointsRectI');
   TGdiplusAPI.GdipDrawImageRect := TGdiplusAPI.GetFunctionAddress('GdipDrawImageRect');
   TGdiplusAPI.GdipDrawImageRectRect := TGdiplusAPI.GetFunctionAddress('GdipDrawImageRectRect');
   TGdiplusAPI.GdipDrawLine := TGdiplusAPI.GetFunctionAddress('GdipDrawLine');
   TGdiplusAPI.GdipDrawLines := TGdiplusAPI.GetFunctionAddress('GdipDrawLines');
   TGdiplusAPI.GdipDrawLinesI := TGdiplusAPI.GetFunctionAddress('GdipDrawLinesI');
   TGdiplusAPI.GdipDrawPath := TGdiplusAPI.GetFunctionAddress('GdipDrawPath');
   TGdiplusAPI.GdipDrawPie := TGdiplusAPI.GetFunctionAddress('GdipDrawPie');
   TGdiplusAPI.GdipDrawPolygon := TGdiplusAPI.GetFunctionAddress('GdipDrawPolygon');
   TGdiplusAPI.GdipDrawPolygonI := TGdiplusAPI.GetFunctionAddress('GdipDrawPolygonI');
   TGdiplusAPI.GdipDrawRectangle := TGdiplusAPI.GetFunctionAddress('GdipDrawRectangle');
   TGdiplusAPI.GdipDrawRectangles := TGdiplusAPI.GetFunctionAddress('GdipDrawRectangles');
   TGdiplusAPI.GdipDrawRectanglesI := TGdiplusAPI.GetFunctionAddress('GdipDrawRectanglesI');
   TGdiplusAPI.GdipDrawString := TGdiplusAPI.GetFunctionAddress('GdipDrawString');
   TGdiplusAPI.GdipEndContainer := TGdiplusAPI.GetFunctionAddress('GdipEndContainer');
   TGdiplusAPI.GdipEnumerateMetafileDestPoint := TGdiplusAPI.GetFunctionAddress('GdipEnumerateMetafileDestPoint');
   TGdiplusAPI.GdipEnumerateMetafileDestPoints := TGdiplusAPI.GetFunctionAddress('GdipEnumerateMetafileDestPoints');
   TGdiplusAPI.GdipEnumerateMetafileDestPointsI := TGdiplusAPI.GetFunctionAddress('GdipEnumerateMetafileDestPointsI');
   TGdiplusAPI.GdipEnumerateMetafileDestRect := TGdiplusAPI.GetFunctionAddress('GdipEnumerateMetafileDestRect');
   TGdiplusAPI.GdipEnumerateMetafileSrcRectDestPoint := TGdiplusAPI.GetFunctionAddress('GdipEnumerateMetafileSrcRectDestPoint');
   TGdiplusAPI.GdipEnumerateMetafileSrcRectDestPoints := TGdiplusAPI.GetFunctionAddress('GdipEnumerateMetafileSrcRectDestPoints');
   TGdiplusAPI.GdipEnumerateMetafileSrcRectDestPointsI := TGdiplusAPI.GetFunctionAddress('GdipEnumerateMetafileSrcRectDestPointsI');
   TGdiplusAPI.GdipEnumerateMetafileSrcRectDestRect := TGdiplusAPI.GetFunctionAddress('GdipEnumerateMetafileSrcRectDestRect');
   TGdiplusAPI.GdipFillClosedCurve := TGdiplusAPI.GetFunctionAddress('GdipFillClosedCurve');
   TGdiplusAPI.GdipFillClosedCurve2 := TGdiplusAPI.GetFunctionAddress('GdipFillClosedCurve2');
   TGdiplusAPI.GdipFillClosedCurve2I := TGdiplusAPI.GetFunctionAddress('GdipFillClosedCurve2I');
   TGdiplusAPI.GdipFillClosedCurveI := TGdiplusAPI.GetFunctionAddress('GdipFillClosedCurveI');
   TGdiplusAPI.GdipFillEllipse := TGdiplusAPI.GetFunctionAddress('GdipFillEllipse');
   TGdiplusAPI.GdipFillPath := TGdiplusAPI.GetFunctionAddress('GdipFillPath');
   TGdiplusAPI.GdipFillPie := TGdiplusAPI.GetFunctionAddress('GdipFillPie');
   TGdiplusAPI.GdipFillPolygon := TGdiplusAPI.GetFunctionAddress('GdipFillPolygon');
   TGdiplusAPI.GdipFillPolygonI := TGdiplusAPI.GetFunctionAddress('GdipFillPolygonI');
   TGdiplusAPI.GdipFillRectangle := TGdiplusAPI.GetFunctionAddress('GdipFillRectangle');
   TGdiplusAPI.GdipFillRectangles := TGdiplusAPI.GetFunctionAddress('GdipFillRectangles');
   TGdiplusAPI.GdipFillRectanglesI := TGdiplusAPI.GetFunctionAddress('GdipFillRectanglesI');
   TGdiplusAPI.GdipFillRegion := TGdiplusAPI.GetFunctionAddress('GdipFillRegion');
   TGdiplusAPI.GdipFlattenPath := TGdiplusAPI.GetFunctionAddress('GdipFlattenPath');
   TGdiplusAPI.GdipFlush := TGdiplusAPI.GetFunctionAddress('GdipFlush');
   TGdiplusAPI.GdipGetAdjustableArrowCapFillState := TGdiplusAPI.GetFunctionAddress('GdipGetAdjustableArrowCapFillState');
   TGdiplusAPI.GdipGetAdjustableArrowCapHeight := TGdiplusAPI.GetFunctionAddress('GdipGetAdjustableArrowCapHeight');
   TGdiplusAPI.GdipGetAdjustableArrowCapMiddleInset := TGdiplusAPI.GetFunctionAddress('GdipGetAdjustableArrowCapMiddleInset');
   TGdiplusAPI.GdipGetAdjustableArrowCapWidth := TGdiplusAPI.GetFunctionAddress('GdipGetAdjustableArrowCapWidth');
   TGdiplusAPI.GdipGetAllPropertyItems := TGdiplusAPI.GetFunctionAddress('GdipGetAllPropertyItems');
   TGdiplusAPI.GdipGetCellAscent := TGdiplusAPI.GetFunctionAddress('GdipGetCellAscent');
   TGdiplusAPI.GdipGetCellDescent := TGdiplusAPI.GetFunctionAddress('GdipGetCellDescent');
   TGdiplusAPI.GdipGetClip := TGdiplusAPI.GetFunctionAddress('GdipGetClip');
   TGdiplusAPI.GdipGetClipBounds := TGdiplusAPI.GetFunctionAddress('GdipGetClipBounds');
   TGdiplusAPI.GdipGetCompositingMode := TGdiplusAPI.GetFunctionAddress('GdipGetCompositingMode');
   TGdiplusAPI.GdipGetCompositingQuality := TGdiplusAPI.GetFunctionAddress('GdipGetCompositingQuality');
   TGdiplusAPI.GdipGetCustomLineCapBaseCap := TGdiplusAPI.GetFunctionAddress('GdipGetCustomLineCapBaseCap');
   TGdiplusAPI.GdipGetCustomLineCapBaseInset := TGdiplusAPI.GetFunctionAddress('GdipGetCustomLineCapBaseInset');
   TGdiplusAPI.GdipGetCustomLineCapStrokeCaps := TGdiplusAPI.GetFunctionAddress('GdipGetCustomLineCapStrokeCaps');
   TGdiplusAPI.GdipGetCustomLineCapStrokeJoin := TGdiplusAPI.GetFunctionAddress('GdipGetCustomLineCapStrokeJoin');
   TGdiplusAPI.GdipGetCustomLineCapType := TGdiplusAPI.GetFunctionAddress('GdipGetCustomLineCapType');
   TGdiplusAPI.GdipGetCustomLineCapWidthScale := TGdiplusAPI.GetFunctionAddress('GdipGetCustomLineCapWidthScale');
   TGdiplusAPI.GdipGetDC := TGdiplusAPI.GetFunctionAddress('GdipGetDC');
   TGdiplusAPI.GdipGetDpiX := TGdiplusAPI.GetFunctionAddress('GdipGetDpiX');
   TGdiplusAPI.GdipGetDpiY := TGdiplusAPI.GetFunctionAddress('GdipGetDpiY');
   TGdiplusAPI.GdipGetEmHeight := TGdiplusAPI.GetFunctionAddress('GdipGetEmHeight');
   TGdiplusAPI.GdipGetEncoderParameterList := TGdiplusAPI.GetFunctionAddress('GdipGetEncoderParameterList');
   TGdiplusAPI.GdipGetEncoderParameterListSize := TGdiplusAPI.GetFunctionAddress('GdipGetEncoderParameterListSize');
   TGdiplusAPI.GdipGetFamily := TGdiplusAPI.GetFunctionAddress('GdipGetFamily');
   TGdiplusAPI.GdipGetFamilyName := TGdiplusAPI.GetFunctionAddress('GdipGetFamilyName');
   TGdiplusAPI.GdipGetFontCollectionFamilyCount := TGdiplusAPI.GetFunctionAddress('GdipGetFontCollectionFamilyCount');
   TGdiplusAPI.GdipGetFontCollectionFamilyList := TGdiplusAPI.GetFunctionAddress('GdipGetFontCollectionFamilyList');
   TGdiplusAPI.GdipGetFontHeight := TGdiplusAPI.GetFunctionAddress('GdipGetFontHeight');
   TGdiplusAPI.GdipGetFontHeightGivenDPI := TGdiplusAPI.GetFunctionAddress('GdipGetFontHeightGivenDPI');
   TGdiplusAPI.GdipGetFontSize := TGdiplusAPI.GetFunctionAddress('GdipGetFontSize');
   TGdiplusAPI.GdipGetFontStyle := TGdiplusAPI.GetFunctionAddress('GdipGetFontStyle');
   TGdiplusAPI.GdipGetFontUnit := TGdiplusAPI.GetFunctionAddress('GdipGetFontUnit');
   TGdiplusAPI.GdipGetGenericFontFamilyMonospace := TGdiplusAPI.GetFunctionAddress('GdipGetGenericFontFamilyMonospace');
   TGdiplusAPI.GdipGetGenericFontFamilySansSerif := TGdiplusAPI.GetFunctionAddress('GdipGetGenericFontFamilySansSerif');
   TGdiplusAPI.GdipGetGenericFontFamilySerif := TGdiplusAPI.GetFunctionAddress('GdipGetGenericFontFamilySerif');
   TGdiplusAPI.GdipGetHatchBackgroundColor := TGdiplusAPI.GetFunctionAddress('GdipGetHatchBackgroundColor');
   TGdiplusAPI.GdipGetHatchForegroundColor := TGdiplusAPI.GetFunctionAddress('GdipGetHatchForegroundColor');
   TGdiplusAPI.GdipGetHatchStyle := TGdiplusAPI.GetFunctionAddress('GdipGetHatchStyle');
   TGdiplusAPI.GdipGetHemfFromMetafile := TGdiplusAPI.GetFunctionAddress('GdipGetHemfFromMetafile');
   TGdiplusAPI.GdipGetImageAttributesAdjustedPalette := TGdiplusAPI.GetFunctionAddress('GdipGetImageAttributesAdjustedPalette');
   TGdiplusAPI.GdipGetImageDecoders := TGdiplusAPI.GetFunctionAddress('GdipGetImageDecoders');
   TGdiplusAPI.GdipGetImageDecodersSize := TGdiplusAPI.GetFunctionAddress('GdipGetImageDecodersSize');
   TGdiplusAPI.GdipGetImageEncoders := TGdiplusAPI.GetFunctionAddress('GdipGetImageEncoders');
   TGdiplusAPI.GdipGetImageEncodersSize := TGdiplusAPI.GetFunctionAddress('GdipGetImageEncodersSize');
   TGdiplusAPI.GdipGetImageDimension := TGdiplusAPI.GetFunctionAddress('GdipGetImageDimension');
   TGdiplusAPI.GdipGetImageFlags := TGdiplusAPI.GetFunctionAddress('GdipGetImageFlags');
   TGdiplusAPI.GdipGetImageGraphicsContext := TGdiplusAPI.GetFunctionAddress('GdipGetImageGraphicsContext');
   TGdiplusAPI.GdipGetImageHeight := TGdiplusAPI.GetFunctionAddress('GdipGetImageHeight');
   TGdiplusAPI.GdipGetImageHorizontalResolution := TGdiplusAPI.GetFunctionAddress('GdipGetImageHorizontalResolution');
   TGdiplusAPI.GdipGetImagePalette := TGdiplusAPI.GetFunctionAddress('GdipGetImagePalette');
   TGdiplusAPI.GdipGetImagePaletteSize := TGdiplusAPI.GetFunctionAddress('GdipGetImagePaletteSize');
   TGdiplusAPI.GdipGetImageRawFormat := TGdiplusAPI.GetFunctionAddress('GdipGetImageRawFormat');
   TGdiplusAPI.GdipGetImageThumbnail := TGdiplusAPI.GetFunctionAddress('GdipGetImageThumbnail');
   TGdiplusAPI.GdipGetImageType := TGdiplusAPI.GetFunctionAddress('GdipGetImageType');
   TGdiplusAPI.GdipGetImageVerticalResolution := TGdiplusAPI.GetFunctionAddress('GdipGetImageVerticalResolution');
   TGdiplusAPI.GdipGetImageWidth := TGdiplusAPI.GetFunctionAddress('GdipGetImageWidth');
   TGdiplusAPI.GdipGetInterpolationMode := TGdiplusAPI.GetFunctionAddress('GdipGetInterpolationMode');
   TGdiplusAPI.GdipGetLineBlend := TGdiplusAPI.GetFunctionAddress('GdipGetLineBlend');
   TGdiplusAPI.GdipGetLineBlendCount := TGdiplusAPI.GetFunctionAddress('GdipGetLineBlendCount');
   TGdiplusAPI.GdipGetLineColors := TGdiplusAPI.GetFunctionAddress('GdipGetLineColors');
   TGdiplusAPI.GdipGetLineGammaCorrection := TGdiplusAPI.GetFunctionAddress('GdipGetLineGammaCorrection');
   TGdiplusAPI.GdipGetLinePresetBlend := TGdiplusAPI.GetFunctionAddress('GdipGetLinePresetBlend');
   TGdiplusAPI.GdipGetLinePresetBlendCount := TGdiplusAPI.GetFunctionAddress('GdipGetLinePresetBlendCount');
   TGdiplusAPI.GdipGetLineRect := TGdiplusAPI.GetFunctionAddress('GdipGetLineRect');
   TGdiplusAPI.GdipGetLineSpacing := TGdiplusAPI.GetFunctionAddress('GdipGetLineSpacing');
   TGdiplusAPI.GdipGetLineTransform := TGdiplusAPI.GetFunctionAddress('GdipGetLineTransform');
   TGdiplusAPI.GdipGetLineWrapMode := TGdiplusAPI.GetFunctionAddress('GdipGetLineWrapMode');
   TGdiplusAPI.GdipGetLogFontW := TGdiplusAPI.GetFunctionAddress('GdipGetLogFontW');
   TGdiplusAPI.GdipGetMatrixElements := TGdiplusAPI.GetFunctionAddress('GdipGetMatrixElements');
   TGdiplusAPI.GdipGetMetafileHeaderFromEmf := TGdiplusAPI.GetFunctionAddress('GdipGetMetafileHeaderFromEmf');
   TGdiplusAPI.GdipGetMetafileHeaderFromFile := TGdiplusAPI.GetFunctionAddress('GdipGetMetafileHeaderFromFile');
   TGdiplusAPI.GdipGetMetafileHeaderFromMetafile := TGdiplusAPI.GetFunctionAddress('GdipGetMetafileHeaderFromMetafile');
   TGdiplusAPI.GdipGetMetafileHeaderFromStream := TGdiplusAPI.GetFunctionAddress('GdipGetMetafileHeaderFromStream');
   TGdiplusAPI.GdipGetMetafileHeaderFromWmf := TGdiplusAPI.GetFunctionAddress('GdipGetMetafileHeaderFromWmf');
   TGdiplusAPI.GdipGetNearestColor := TGdiplusAPI.GetFunctionAddress('GdipGetNearestColor');
   TGdiplusAPI.GdipGetPageScale := TGdiplusAPI.GetFunctionAddress('GdipGetPageScale');
   TGdiplusAPI.GdipGetPageUnit := TGdiplusAPI.GetFunctionAddress('GdipGetPageUnit');
   TGdiplusAPI.GdipGetPathData := TGdiplusAPI.GetFunctionAddress('GdipGetPathData');
   TGdiplusAPI.GdipGetPathFillMode := TGdiplusAPI.GetFunctionAddress('GdipGetPathFillMode');
   TGdiplusAPI.GdipGetPathGradientBlend := TGdiplusAPI.GetFunctionAddress('GdipGetPathGradientBlend');
   TGdiplusAPI.GdipGetPathGradientBlendCount := TGdiplusAPI.GetFunctionAddress('GdipGetPathGradientBlendCount');
   TGdiplusAPI.GdipGetPathGradientCenterColor := TGdiplusAPI.GetFunctionAddress('GdipGetPathGradientCenterColor');
   TGdiplusAPI.GdipGetPathGradientCenterPoint := TGdiplusAPI.GetFunctionAddress('GdipGetPathGradientCenterPoint');
   TGdiplusAPI.GdipGetPathGradientFocusScales := TGdiplusAPI.GetFunctionAddress('GdipGetPathGradientFocusScales');
   TGdiplusAPI.GdipGetPathGradientPresetBlend := TGdiplusAPI.GetFunctionAddress('GdipGetPathGradientPresetBlend');
   TGdiplusAPI.GdipGetPathGradientPresetBlendCount := TGdiplusAPI.GetFunctionAddress('GdipGetPathGradientPresetBlendCount');
   TGdiplusAPI.GdipGetPathGradientRect := TGdiplusAPI.GetFunctionAddress('GdipGetPathGradientRect');
   TGdiplusAPI.GdipGetPathGradientSurroundColorCount := TGdiplusAPI.GetFunctionAddress('GdipGetPathGradientSurroundColorCount');
   TGdiplusAPI.GdipGetPathGradientSurroundColorsWithCount := TGdiplusAPI.GetFunctionAddress('GdipGetPathGradientSurroundColorsWithCount');
   TGdiplusAPI.GdipGetPathGradientTransform := TGdiplusAPI.GetFunctionAddress('GdipGetPathGradientTransform');
   TGdiplusAPI.GdipGetPathGradientWrapMode := TGdiplusAPI.GetFunctionAddress('GdipGetPathGradientWrapMode');

   TGdiplusAPI.GdipGetPathGradientGammaCorrection := TGdiplusAPI.GetFunctionAddress('GdipGetPathGradientGammaCorrection');
   TGdiplusAPI.GdipSetPathGradientGammaCorrection := TGdiplusAPI.GetFunctionAddress('GdipSetPathGradientGammaCorrection');


   TGdiplusAPI.GdipGetPathLastPoint := TGdiplusAPI.GetFunctionAddress('GdipGetPathLastPoint');
   TGdiplusAPI.GdipGetPathPoints := TGdiplusAPI.GetFunctionAddress('GdipGetPathPoints');
   TGdiplusAPI.GdipGetPathTypes := TGdiplusAPI.GetFunctionAddress('GdipGetPathTypes');
   TGdiplusAPI.GdipGetPathWorldBounds := TGdiplusAPI.GetFunctionAddress('GdipGetPathWorldBounds');
   TGdiplusAPI.GdipGetPenBrushFill := TGdiplusAPI.GetFunctionAddress('GdipGetPenBrushFill');
   TGdiplusAPI.GdipGetPenColor := TGdiplusAPI.GetFunctionAddress('GdipGetPenColor');
   TGdiplusAPI.GdipGetPenCompoundArray := TGdiplusAPI.GetFunctionAddress('GdipGetPenCompoundArray');
   TGdiplusAPI.GdipGetPenCompoundCount := TGdiplusAPI.GetFunctionAddress('GdipGetPenCompoundCount');
   TGdiplusAPI.GdipGetPenCustomEndCap := TGdiplusAPI.GetFunctionAddress('GdipGetPenCustomEndCap');
   TGdiplusAPI.GdipGetPenCustomStartCap := TGdiplusAPI.GetFunctionAddress('GdipGetPenCustomStartCap');
   TGdiplusAPI.GdipGetPenDashArray := TGdiplusAPI.GetFunctionAddress('GdipGetPenDashArray');
   TGdiplusAPI.GdipGetPenDashCap197819 := TGdiplusAPI.GetFunctionAddress('GdipGetPenDashCap197819');
   TGdiplusAPI.GdipGetPenDashCount := TGdiplusAPI.GetFunctionAddress('GdipGetPenDashCount');
   TGdiplusAPI.GdipGetPenDashOffset := TGdiplusAPI.GetFunctionAddress('GdipGetPenDashOffset');
   TGdiplusAPI.GdipGetPenDashStyle := TGdiplusAPI.GetFunctionAddress('GdipGetPenDashStyle');
   TGdiplusAPI.GdipGetPenEndCap := TGdiplusAPI.GetFunctionAddress('GdipGetPenEndCap');
   TGdiplusAPI.GdipGetPenFillType := TGdiplusAPI.GetFunctionAddress('GdipGetPenFillType');
   TGdiplusAPI.GdipGetPenLineJoin := TGdiplusAPI.GetFunctionAddress('GdipGetPenLineJoin');
   TGdiplusAPI.GdipGetPenMiterLimit := TGdiplusAPI.GetFunctionAddress('GdipGetPenMiterLimit');
   TGdiplusAPI.GdipGetPenMode := TGdiplusAPI.GetFunctionAddress('GdipGetPenMode');
   TGdiplusAPI.GdipGetPenStartCap := TGdiplusAPI.GetFunctionAddress('GdipGetPenStartCap');
   TGdiplusAPI.GdipGetPenTransform := TGdiplusAPI.GetFunctionAddress('GdipGetPenTransform');
   TGdiplusAPI.GdipGetPenWidth := TGdiplusAPI.GetFunctionAddress('GdipGetPenWidth');
   TGdiplusAPI.GdipGetPixelOffsetMode := TGdiplusAPI.GetFunctionAddress('GdipGetPixelOffsetMode');
   TGdiplusAPI.GdipGetPointCount := TGdiplusAPI.GetFunctionAddress('GdipGetPointCount');
   TGdiplusAPI.GdipGetPropertyCount := TGdiplusAPI.GetFunctionAddress('GdipGetPropertyCount');
   TGdiplusAPI.GdipGetPropertyIdList := TGdiplusAPI.GetFunctionAddress('GdipGetPropertyIdList');
   TGdiplusAPI.GdipGetPropertyItem := TGdiplusAPI.GetFunctionAddress('GdipGetPropertyItem');
   TGdiplusAPI.GdipGetPropertyItemSize := TGdiplusAPI.GetFunctionAddress('GdipGetPropertyItemSize');
   TGdiplusAPI.GdipGetPropertySize := TGdiplusAPI.GetFunctionAddress('GdipGetPropertySize');
   TGdiplusAPI.GdipGetRegionBounds := TGdiplusAPI.GetFunctionAddress('GdipGetRegionBounds');
   TGdiplusAPI.GdipGetRegionData := TGdiplusAPI.GetFunctionAddress('GdipGetRegionData');
   TGdiplusAPI.GdipGetRegionDataSize := TGdiplusAPI.GetFunctionAddress('GdipGetRegionDataSize');
   TGdiplusAPI.GdipGetRegionScans := TGdiplusAPI.GetFunctionAddress('GdipGetRegionScans');
   TGdiplusAPI.GdipGetRegionScansCount := TGdiplusAPI.GetFunctionAddress('GdipGetRegionScansCount');
   TGdiplusAPI.GdipGetRenderingOrigin := TGdiplusAPI.GetFunctionAddress('GdipGetRenderingOrigin');
   TGdiplusAPI.GdipGetSmoothingMode := TGdiplusAPI.GetFunctionAddress('GdipGetSmoothingMode');
   TGdiplusAPI.GdipGetSolidFillColor := TGdiplusAPI.GetFunctionAddress('GdipGetSolidFillColor');
   TGdiplusAPI.GdipGetStringFormatAlign := TGdiplusAPI.GetFunctionAddress('GdipGetStringFormatAlign');
   TGdiplusAPI.GdipGetStringFormatDigitSubstitution := TGdiplusAPI.GetFunctionAddress('GdipGetStringFormatDigitSubstitution');
   TGdiplusAPI.GdipGetStringFormatFlags := TGdiplusAPI.GetFunctionAddress('GdipGetStringFormatFlags');
   TGdiplusAPI.GdipGetStringFormatHotkeyPrefix := TGdiplusAPI.GetFunctionAddress('GdipGetStringFormatHotkeyPrefix');
   TGdiplusAPI.GdipGetStringFormatLineAlign := TGdiplusAPI.GetFunctionAddress('GdipGetStringFormatLineAlign');
   TGdiplusAPI.GdipGetStringFormatMeasurableCharacterRangeCount := TGdiplusAPI.GetFunctionAddress('GdipGetStringFormatMeasurableCharacterRangeCount');
   TGdiplusAPI.GdipGetStringFormatTabStopCount := TGdiplusAPI.GetFunctionAddress('GdipGetStringFormatTabStopCount');
   TGdiplusAPI.GdipGetStringFormatTabStops := TGdiplusAPI.GetFunctionAddress('GdipGetStringFormatTabStops');
   TGdiplusAPI.GdipGetStringFormatTrimming := TGdiplusAPI.GetFunctionAddress('GdipGetStringFormatTrimming');
   TGdiplusAPI.GdipGetTextContrast := TGdiplusAPI.GetFunctionAddress('GdipGetTextContrast');
   TGdiplusAPI.GdipGetTextRenderingHint := TGdiplusAPI.GetFunctionAddress('GdipGetTextRenderingHint');
   TGdiplusAPI.GdipGetTextureImage := TGdiplusAPI.GetFunctionAddress('GdipGetTextureImage');
   TGdiplusAPI.GdipGetTextureTransform := TGdiplusAPI.GetFunctionAddress('GdipGetTextureTransform');
   TGdiplusAPI.GdipGetTextureWrapMode := TGdiplusAPI.GetFunctionAddress('GdipGetTextureWrapMode');
   TGdiplusAPI.GdipGetVisibleClipBounds := TGdiplusAPI.GetFunctionAddress('GdipGetVisibleClipBounds');
   TGdiplusAPI.GdipGetWorldTransform := TGdiplusAPI.GetFunctionAddress('GdipGetWorldTransform');
   TGdiplusAPI.GdipGraphicsClear := TGdiplusAPI.GetFunctionAddress('GdipGraphicsClear');
   TGdiplusAPI.GdipImageForceValidation := TGdiplusAPI.GetFunctionAddress('GdipImageForceValidation');
   TGdiplusAPI.GdipImageGetFrameCount := TGdiplusAPI.GetFunctionAddress('GdipImageGetFrameCount');
   TGdiplusAPI.GdipImageGetFrameDimensionsCount := TGdiplusAPI.GetFunctionAddress('GdipImageGetFrameDimensionsCount');
   TGdiplusAPI.GdipImageGetFrameDimensionsList := TGdiplusAPI.GetFunctionAddress('GdipImageGetFrameDimensionsList');
   TGdiplusAPI.GdipImageRotateFlip := TGdiplusAPI.GetFunctionAddress('GdipImageRotateFlip');
   TGdiplusAPI.GdipImageSelectActiveFrame := TGdiplusAPI.GetFunctionAddress('GdipImageSelectActiveFrame');
   TGdiplusAPI.GdipInitializePalette := TGdiplusAPI.GetFunctionAddress('GdipInitializePalette');
   TGdiplusAPI.GdipInvertMatrix := TGdiplusAPI.GetFunctionAddress('GdipInvertMatrix');
   TGdiplusAPI.GdipIsClipEmpty := TGdiplusAPI.GetFunctionAddress('GdipIsClipEmpty');
   TGdiplusAPI.GdipIsEmptyRegion := TGdiplusAPI.GetFunctionAddress('GdipIsEmptyRegion');
   TGdiplusAPI.GdipIsInfiniteRegion := TGdiplusAPI.GetFunctionAddress('GdipIsInfiniteRegion');
   TGdiplusAPI.GdipIsEqualRegion := TGdiplusAPI.GetFunctionAddress('GdipIsEqualRegion');
   TGdiplusAPI.GdipIsMatrixEqual := TGdiplusAPI.GetFunctionAddress('GdipIsMatrixEqual');
   TGdiplusAPI.GdipIsMatrixIdentity := TGdiplusAPI.GetFunctionAddress('GdipIsMatrixIdentity');
   TGdiplusAPI.GdipIsMatrixInvertible := TGdiplusAPI.GetFunctionAddress('GdipIsMatrixInvertible');
   TGdiplusAPI.GdipIsOutlineVisiblePathPoint := TGdiplusAPI.GetFunctionAddress('GdipIsOutlineVisiblePathPoint');
   TGdiplusAPI.GdipIsStyleAvailable := TGdiplusAPI.GetFunctionAddress('GdipIsStyleAvailable');
   TGdiplusAPI.GdipIsVisibleClipEmpty := TGdiplusAPI.GetFunctionAddress('GdipIsVisibleClipEmpty');
   TGdiplusAPI.GdipIsVisiblePathPoint := TGdiplusAPI.GetFunctionAddress('GdipIsVisiblePathPoint');
   TGdiplusAPI.GdipIsVisiblePoint := TGdiplusAPI.GetFunctionAddress('GdipIsVisiblePoint');
   TGdiplusAPI.GdipIsVisibleRect := TGdiplusAPI.GetFunctionAddress('GdipIsVisibleRect');
   TGdiplusAPI.GdipIsVisibleRegionPoint := TGdiplusAPI.GetFunctionAddress('GdipIsVisibleRegionPoint');
   TGdiplusAPI.GdipIsVisibleRegionRect := TGdiplusAPI.GetFunctionAddress('GdipIsVisibleRegionRect');
   TGdiplusAPI.GdipLoadImageFromFile := TGdiplusAPI.GetFunctionAddress('GdipLoadImageFromFile');
   TGdiplusAPI.GdipLoadImageFromFileICM := TGdiplusAPI.GetFunctionAddress('GdipLoadImageFromFileICM');
   TGdiplusAPI.GdipLoadImageFromStream := TGdiplusAPI.GetFunctionAddress('GdipLoadImageFromStream');
   TGdiplusAPI.GdipLoadImageFromStreamICM := TGdiplusAPI.GetFunctionAddress('GdipLoadImageFromStreamICM');
   TGdiplusAPI.GdipGetImageBounds := TGdiplusAPI.GetFunctionAddress('GdipGetImageBounds');
   TGdiplusAPI.GdiplusStartup := TGdiplusAPI.GetFunctionAddress('GdiplusStartup');
   TGdiplusAPI.GdiplusShutdown := TGdiplusAPI.GetFunctionAddress('GdiplusShutdown');
   TGdiplusAPI.GdipMeasureCharacterRanges := TGdiplusAPI.GetFunctionAddress('GdipMeasureCharacterRanges');
   TGdiplusAPI.GdipMeasureString := TGdiplusAPI.GetFunctionAddress('GdipMeasureString');
   TGdiplusAPI.GdipMultiplyLineTransform := TGdiplusAPI.GetFunctionAddress('GdipMultiplyLineTransform');
   TGdiplusAPI.GdipMultiplyMatrix := TGdiplusAPI.GetFunctionAddress('GdipMultiplyMatrix');
   TGdiplusAPI.GdipMultiplyPathGradientTransform := TGdiplusAPI.GetFunctionAddress('GdipMultiplyPathGradientTransform');
   TGdiplusAPI.GdipMultiplyPenTransform := TGdiplusAPI.GetFunctionAddress('GdipMultiplyPenTransform');
   TGdiplusAPI.GdipMultiplyTextureTransform := TGdiplusAPI.GetFunctionAddress('GdipMultiplyTextureTransform');
   TGdiplusAPI.GdipMultiplyWorldTransform := TGdiplusAPI.GetFunctionAddress('GdipMultiplyWorldTransform');
   TGdiplusAPI.GdipNewInstalledFontCollection := TGdiplusAPI.GetFunctionAddress('GdipNewInstalledFontCollection');
   TGdiplusAPI.GdipNewPrivateFontCollection := TGdiplusAPI.GetFunctionAddress('GdipNewPrivateFontCollection');
   TGdiplusAPI.GdipPathIterCopyData := TGdiplusAPI.GetFunctionAddress('GdipPathIterCopyData');
   TGdiplusAPI.GdipPathIterEnumerate := TGdiplusAPI.GetFunctionAddress('GdipPathIterEnumerate');
   TGdiplusAPI.GdipPathIterGetCount := TGdiplusAPI.GetFunctionAddress('GdipPathIterGetCount');
   TGdiplusAPI.GdipPathIterGetSubpathCount := TGdiplusAPI.GetFunctionAddress('GdipPathIterGetSubpathCount');
   TGdiplusAPI.GdipPathIterHasCurve := TGdiplusAPI.GetFunctionAddress('GdipPathIterHasCurve');
   TGdiplusAPI.GdipPathIterIsValid := TGdiplusAPI.GetFunctionAddress('GdipPathIterIsValid');
   TGdiplusAPI.GdipPathIterNextMarker := TGdiplusAPI.GetFunctionAddress('GdipPathIterNextMarker');
   TGdiplusAPI.GdipPathIterNextMarkerPath := TGdiplusAPI.GetFunctionAddress('GdipPathIterNextMarkerPath');
   TGdiplusAPI.GdipPathIterNextPathType := TGdiplusAPI.GetFunctionAddress('GdipPathIterNextPathType');
   TGdiplusAPI.GdipPathIterNextSubpath := TGdiplusAPI.GetFunctionAddress('GdipPathIterNextSubpath');
   TGdiplusAPI.GdipPathIterNextSubpathPath := TGdiplusAPI.GetFunctionAddress('GdipPathIterNextSubpathPath');
   TGdiplusAPI.GdipPathIterRewind := TGdiplusAPI.GetFunctionAddress('GdipPathIterRewind');
   TGdiplusAPI.GdipPlayMetafileRecord := TGdiplusAPI.GetFunctionAddress('GdipPlayMetafileRecord');
   TGdiplusAPI.GdipPrivateAddFontFile := TGdiplusAPI.GetFunctionAddress('GdipPrivateAddFontFile');
   TGdiplusAPI.GdipPrivateAddMemoryFont := TGdiplusAPI.GetFunctionAddress('GdipPrivateAddMemoryFont');
   TGdiplusAPI.GdipRecordMetafile := TGdiplusAPI.GetFunctionAddress('GdipRecordMetafile');
   TGdiplusAPI.GdipRecordMetafileFileName := TGdiplusAPI.GetFunctionAddress('GdipRecordMetafileFileName');
   TGdiplusAPI.GdipRecordMetafileStream := TGdiplusAPI.GetFunctionAddress('GdipRecordMetafileStream');
   TGdiplusAPI.GdipReleaseDC := TGdiplusAPI.GetFunctionAddress('GdipReleaseDC');
   TGdiplusAPI.GdipRemovePropertyItem := TGdiplusAPI.GetFunctionAddress('GdipRemovePropertyItem');
   TGdiplusAPI.GdipResetClip := TGdiplusAPI.GetFunctionAddress('GdipResetClip');
   TGdiplusAPI.GdipResetLineTransform := TGdiplusAPI.GetFunctionAddress('GdipResetLineTransform');
   TGdiplusAPI.GdipResetPath := TGdiplusAPI.GetFunctionAddress('GdipResetPath');
   TGdiplusAPI.GdipResetPathGradientTransform := TGdiplusAPI.GetFunctionAddress('GdipResetPathGradientTransform');
   TGdiplusAPI.GdipResetPenTransform := TGdiplusAPI.GetFunctionAddress('GdipResetPenTransform');
   TGdiplusAPI.GdipResetTextureTransform := TGdiplusAPI.GetFunctionAddress('GdipResetTextureTransform');
   TGdiplusAPI.GdipResetWorldTransform := TGdiplusAPI.GetFunctionAddress('GdipResetWorldTransform');
   TGdiplusAPI.GdipRestoreGraphics := TGdiplusAPI.GetFunctionAddress('GdipRestoreGraphics');
   TGdiplusAPI.GdipReversePath := TGdiplusAPI.GetFunctionAddress('GdipReversePath');
   TGdiplusAPI.GdipRotateLineTransform := TGdiplusAPI.GetFunctionAddress('GdipRotateLineTransform');
   TGdiplusAPI.GdipRotateMatrix := TGdiplusAPI.GetFunctionAddress('GdipRotateMatrix');
   TGdiplusAPI.GdipRotatePathGradientTransform := TGdiplusAPI.GetFunctionAddress('GdipRotatePathGradientTransform');
   TGdiplusAPI.GdipRotatePenTransform := TGdiplusAPI.GetFunctionAddress('GdipRotatePenTransform');
   TGdiplusAPI.GdipRotateTextureTransform := TGdiplusAPI.GetFunctionAddress('GdipRotateTextureTransform');
   TGdiplusAPI.GdipRotateWorldTransform := TGdiplusAPI.GetFunctionAddress('GdipRotateWorldTransform');
   TGdiplusAPI.GdipSaveAdd := TGdiplusAPI.GetFunctionAddress('GdipSaveAdd');
   TGdiplusAPI.GdipSaveAddImage := TGdiplusAPI.GetFunctionAddress('GdipSaveAddImage');
   TGdiplusAPI.GdipSaveGraphics := TGdiplusAPI.GetFunctionAddress('GdipSaveGraphics');
   TGdiplusAPI.GdipSaveImageToFile := TGdiplusAPI.GetFunctionAddress('GdipSaveImageToFile');
   TGdiplusAPI.GdipScaleLineTransform := TGdiplusAPI.GetFunctionAddress('GdipScaleLineTransform');
   TGdiplusAPI.GdipScaleMatrix := TGdiplusAPI.GetFunctionAddress('GdipScaleMatrix');
   TGdiplusAPI.GdipScalePathGradientTransform := TGdiplusAPI.GetFunctionAddress('GdipScalePathGradientTransform');
   TGdiplusAPI.GdipScalePenTransform := TGdiplusAPI.GetFunctionAddress('GdipScalePenTransform');
   TGdiplusAPI.GdipScaleTextureTransform := TGdiplusAPI.GetFunctionAddress('GdipScaleTextureTransform');
   TGdiplusAPI.GdipScaleWorldTransform := TGdiplusAPI.GetFunctionAddress('GdipScaleWorldTransform');
   TGdiplusAPI.GdipSetAdjustableArrowCapFillState := TGdiplusAPI.GetFunctionAddress('GdipSetAdjustableArrowCapFillState');
   TGdiplusAPI.GdipSetAdjustableArrowCapHeight := TGdiplusAPI.GetFunctionAddress('GdipSetAdjustableArrowCapHeight');
   TGdiplusAPI.GdipSetAdjustableArrowCapMiddleInset := TGdiplusAPI.GetFunctionAddress('GdipSetAdjustableArrowCapMiddleInset');
   TGdiplusAPI.GdipSetAdjustableArrowCapWidth := TGdiplusAPI.GetFunctionAddress('GdipSetAdjustableArrowCapWidth');
   TGdiplusAPI.GdipSetClipGraphics := TGdiplusAPI.GetFunctionAddress('GdipSetClipGraphics');
   TGdiplusAPI.GdipSetClipPath := TGdiplusAPI.GetFunctionAddress('GdipSetClipPath');
   TGdiplusAPI.GdipSetClipRect := TGdiplusAPI.GetFunctionAddress('GdipSetClipRect');
   TGdiplusAPI.GdipSetClipRegion := TGdiplusAPI.GetFunctionAddress('GdipSetClipRegion');
   TGdiplusAPI.GdipSetCompositingMode := TGdiplusAPI.GetFunctionAddress('GdipSetCompositingMode');
   TGdiplusAPI.GdipSetCompositingQuality := TGdiplusAPI.GetFunctionAddress('GdipSetCompositingQuality');
   TGdiplusAPI.GdipSetCustomLineCapBaseCap := TGdiplusAPI.GetFunctionAddress('GdipSetCustomLineCapBaseCap');
   TGdiplusAPI.GdipSetCustomLineCapBaseInset := TGdiplusAPI.GetFunctionAddress('GdipSetCustomLineCapBaseInset');
   TGdiplusAPI.GdipSetCustomLineCapStrokeCaps := TGdiplusAPI.GetFunctionAddress('GdipSetCustomLineCapStrokeCaps');
   TGdiplusAPI.GdipSetCustomLineCapStrokeJoin := TGdiplusAPI.GetFunctionAddress('GdipSetCustomLineCapStrokeJoin');
   TGdiplusAPI.GdipSetCustomLineCapWidthScale := TGdiplusAPI.GetFunctionAddress('GdipSetCustomLineCapWidthScale');
   TGdiplusAPI.GdipSetEffectParameters := TGdiplusAPI.GetFunctionAddress('GdipSetEffectParameters');
   TGdiplusAPI.GdipSetEmpty := TGdiplusAPI.GetFunctionAddress('GdipSetEmpty');
   TGdiplusAPI.GdipSetImageAttributesColorKeys := TGdiplusAPI.GetFunctionAddress('GdipSetImageAttributesColorKeys');
   TGdiplusAPI.GdipSetImageAttributesColorMatrix := TGdiplusAPI.GetFunctionAddress('GdipSetImageAttributesColorMatrix');
   TGdiplusAPI.GdipSetImageAttributesGamma := TGdiplusAPI.GetFunctionAddress('GdipSetImageAttributesGamma');
   TGdiplusAPI.GdipSetImageAttributesNoOp := TGdiplusAPI.GetFunctionAddress('GdipSetImageAttributesNoOp');
   TGdiplusAPI.GdipSetImageAttributesOutputChannel := TGdiplusAPI.GetFunctionAddress('GdipSetImageAttributesOutputChannel');
   TGdiplusAPI.GdipSetImageAttributesOutputChannelColorProfile := TGdiplusAPI.GetFunctionAddress('GdipSetImageAttributesOutputChannelColorProfile');
   TGdiplusAPI.GdipSetImageAttributesRemapTable := TGdiplusAPI.GetFunctionAddress('GdipSetImageAttributesRemapTable');
   TGdiplusAPI.GdipSetImageAttributesThreshold := TGdiplusAPI.GetFunctionAddress('GdipSetImageAttributesThreshold');
   TGdiplusAPI.GdipSetImageAttributesWrapMode := TGdiplusAPI.GetFunctionAddress('GdipSetImageAttributesWrapMode');
   TGdiplusAPI.GdipSetImagePalette := TGdiplusAPI.GetFunctionAddress('GdipSetImagePalette');
   TGdiplusAPI.GdipSetInfinite := TGdiplusAPI.GetFunctionAddress('GdipSetInfinite');
   TGdiplusAPI.GdipSetInterpolationMode := TGdiplusAPI.GetFunctionAddress('GdipSetInterpolationMode');
   TGdiplusAPI.GdipSetLineBlend := TGdiplusAPI.GetFunctionAddress('GdipSetLineBlend');
   TGdiplusAPI.GdipSetLineColors := TGdiplusAPI.GetFunctionAddress('GdipSetLineColors');
   TGdiplusAPI.GdipSetLineGammaCorrection := TGdiplusAPI.GetFunctionAddress('GdipSetLineGammaCorrection');
   TGdiplusAPI.GdipSetLineLinearBlend := TGdiplusAPI.GetFunctionAddress('GdipSetLineLinearBlend');
   TGdiplusAPI.GdipSetLinePresetBlend := TGdiplusAPI.GetFunctionAddress('GdipSetLinePresetBlend');
   TGdiplusAPI.GdipSetLineSigmaBlend := TGdiplusAPI.GetFunctionAddress('GdipSetLineSigmaBlend');
   TGdiplusAPI.GdipSetLineTransform := TGdiplusAPI.GetFunctionAddress('GdipSetLineTransform');
   TGdiplusAPI.GdipSetLineWrapMode := TGdiplusAPI.GetFunctionAddress('GdipSetLineWrapMode');
   TGdiplusAPI.GdipSetMatrixElements := TGdiplusAPI.GetFunctionAddress('GdipSetMatrixElements');
   TGdiplusAPI.GdipSetPageScale := TGdiplusAPI.GetFunctionAddress('GdipSetPageScale');
   TGdiplusAPI.GdipSetPageUnit := TGdiplusAPI.GetFunctionAddress('GdipSetPageUnit');
   TGdiplusAPI.GdipSetPathFillMode := TGdiplusAPI.GetFunctionAddress('GdipSetPathFillMode');
   TGdiplusAPI.GdipSetPathGradientBlend := TGdiplusAPI.GetFunctionAddress('GdipSetPathGradientBlend');
   TGdiplusAPI.GdipSetPathGradientCenterColor := TGdiplusAPI.GetFunctionAddress('GdipSetPathGradientCenterColor');
   TGdiplusAPI.GdipSetPathGradientCenterPoint := TGdiplusAPI.GetFunctionAddress('GdipSetPathGradientCenterPoint');
   TGdiplusAPI.GdipSetPathGradientFocusScales := TGdiplusAPI.GetFunctionAddress('GdipSetPathGradientFocusScales');
   TGdiplusAPI.GdipSetPathGradientLinearBlend := TGdiplusAPI.GetFunctionAddress('GdipSetPathGradientLinearBlend');
   TGdiplusAPI.GdipSetPathGradientPresetBlend := TGdiplusAPI.GetFunctionAddress('GdipSetPathGradientPresetBlend');
   TGdiplusAPI.GdipSetPathGradientSigmaBlend := TGdiplusAPI.GetFunctionAddress('GdipSetPathGradientSigmaBlend');
   TGdiplusAPI.GdipSetPathGradientSurroundColorsWithCount := TGdiplusAPI.GetFunctionAddress('GdipSetPathGradientSurroundColorsWithCount');
   TGdiplusAPI.GdipSetPathGradientTransform := TGdiplusAPI.GetFunctionAddress('GdipSetPathGradientTransform');
   TGdiplusAPI.GdipSetPathGradientWrapMode := TGdiplusAPI.GetFunctionAddress('GdipSetPathGradientWrapMode');
   TGdiplusAPI.GdipSetPathMarker := TGdiplusAPI.GetFunctionAddress('GdipSetPathMarker');
   TGdiplusAPI.GdipSetPenBrushFill := TGdiplusAPI.GetFunctionAddress('GdipSetPenBrushFill');
   TGdiplusAPI.GdipSetPenColor := TGdiplusAPI.GetFunctionAddress('GdipSetPenColor');
   TGdiplusAPI.GdipSetPenCompoundArray := TGdiplusAPI.GetFunctionAddress('GdipSetPenCompoundArray');
   TGdiplusAPI.GdipSetPenCustomEndCap := TGdiplusAPI.GetFunctionAddress('GdipSetPenCustomEndCap');
   TGdiplusAPI.GdipSetPenCustomStartCap := TGdiplusAPI.GetFunctionAddress('GdipSetPenCustomStartCap');
   TGdiplusAPI.GdipSetPenDashArray := TGdiplusAPI.GetFunctionAddress('GdipSetPenDashArray');
   TGdiplusAPI.GdipSetPenDashCap197819 := TGdiplusAPI.GetFunctionAddress('GdipSetPenDashCap197819');
   TGdiplusAPI.GdipSetPenDashOffset := TGdiplusAPI.GetFunctionAddress('GdipSetPenDashOffset');
   TGdiplusAPI.GdipSetPenDashStyle := TGdiplusAPI.GetFunctionAddress('GdipSetPenDashStyle');
   TGdiplusAPI.GdipSetPenEndCap := TGdiplusAPI.GetFunctionAddress('GdipSetPenEndCap');
   TGdiplusAPI.GdipSetPenLineCap197819 := TGdiplusAPI.GetFunctionAddress('GdipSetPenLineCap197819');
   TGdiplusAPI.GdipSetPenLineJoin := TGdiplusAPI.GetFunctionAddress('GdipSetPenLineJoin');
   TGdiplusAPI.GdipSetPenMiterLimit := TGdiplusAPI.GetFunctionAddress('GdipSetPenMiterLimit');
   TGdiplusAPI.GdipSetPenMode := TGdiplusAPI.GetFunctionAddress('GdipSetPenMode');
   TGdiplusAPI.GdipSetPenStartCap := TGdiplusAPI.GetFunctionAddress('GdipSetPenStartCap');
   TGdiplusAPI.GdipSetPenTransform := TGdiplusAPI.GetFunctionAddress('GdipSetPenTransform');
   TGdiplusAPI.GdipSetPenWidth := TGdiplusAPI.GetFunctionAddress('GdipSetPenWidth');
   TGdiplusAPI.GdipSetPixelOffsetMode := TGdiplusAPI.GetFunctionAddress('GdipSetPixelOffsetMode');
   TGdiplusAPI.GdipSetPropertyItem := TGdiplusAPI.GetFunctionAddress('GdipSetPropertyItem');
   TGdiplusAPI.GdipSetRenderingOrigin := TGdiplusAPI.GetFunctionAddress('GdipSetRenderingOrigin');
   TGdiplusAPI.GdipSetSmoothingMode := TGdiplusAPI.GetFunctionAddress('GdipSetSmoothingMode');
   TGdiplusAPI.GdipSetSolidFillColor := TGdiplusAPI.GetFunctionAddress('GdipSetSolidFillColor');
   TGdiplusAPI.GdipSetStringFormatAlign := TGdiplusAPI.GetFunctionAddress('GdipSetStringFormatAlign');
   TGdiplusAPI.GdipSetStringFormatDigitSubstitution := TGdiplusAPI.GetFunctionAddress('GdipSetStringFormatDigitSubstitution');
   TGdiplusAPI.GdipSetStringFormatFlags := TGdiplusAPI.GetFunctionAddress('GdipSetStringFormatFlags');
   TGdiplusAPI.GdipSetStringFormatHotkeyPrefix := TGdiplusAPI.GetFunctionAddress('GdipSetStringFormatHotkeyPrefix');
   TGdiplusAPI.GdipSetStringFormatLineAlign := TGdiplusAPI.GetFunctionAddress('GdipSetStringFormatLineAlign');
   TGdiplusAPI.GdipSetStringFormatMeasurableCharacterRanges := TGdiplusAPI.GetFunctionAddress('GdipSetStringFormatMeasurableCharacterRanges');
   TGdiplusAPI.GdipSetStringFormatTabStops := TGdiplusAPI.GetFunctionAddress('GdipSetStringFormatTabStops');
   TGdiplusAPI.GdipSetStringFormatTrimming := TGdiplusAPI.GetFunctionAddress('GdipSetStringFormatTrimming');
   TGdiplusAPI.GdipSetTextContrast := TGdiplusAPI.GetFunctionAddress('GdipSetTextContrast');
   TGdiplusAPI.GdipSetTextRenderingHint := TGdiplusAPI.GetFunctionAddress('GdipSetTextRenderingHint');
   TGdiplusAPI.GdipSetTextureTransform := TGdiplusAPI.GetFunctionAddress('GdipSetTextureTransform');
   TGdiplusAPI.GdipSetTextureWrapMode := TGdiplusAPI.GetFunctionAddress('GdipSetTextureWrapMode');
   TGdiplusAPI.GdipSetWorldTransform := TGdiplusAPI.GetFunctionAddress('GdipSetWorldTransform');
   TGdiplusAPI.GdipShearMatrix := TGdiplusAPI.GetFunctionAddress('GdipShearMatrix');
   TGdiplusAPI.GdipStartPathFigure := TGdiplusAPI.GetFunctionAddress('GdipStartPathFigure');
   TGdiplusAPI.GdipStringFormatGetGenericDefault := TGdiplusAPI.GetFunctionAddress('GdipStringFormatGetGenericDefault');
   TGdiplusAPI.GdipStringFormatGetGenericTypographic := TGdiplusAPI.GetFunctionAddress('GdipStringFormatGetGenericTypographic');
   TGdiplusAPI.GdipTransformMatrixPoints := TGdiplusAPI.GetFunctionAddress('GdipTransformMatrixPoints');
   TGdiplusAPI.GdipTransformMatrixPointsI := TGdiplusAPI.GetFunctionAddress('GdipTransformMatrixPointsI');
   TGdiplusAPI.GdipTransformPath := TGdiplusAPI.GetFunctionAddress('GdipTransformPath');
   TGdiplusAPI.GdipTransformPoints := TGdiplusAPI.GetFunctionAddress('GdipTransformPoints');
   TGdiplusAPI.GdipTransformPointsI := TGdiplusAPI.GetFunctionAddress('GdipTransformPointsI');
   TGdiplusAPI.GdipTransformRegion := TGdiplusAPI.GetFunctionAddress('GdipTransformRegion');
   TGdiplusAPI.GdipTranslateClip := TGdiplusAPI.GetFunctionAddress('GdipTranslateClip');
   TGdiplusAPI.GdipTranslateLineTransform := TGdiplusAPI.GetFunctionAddress('GdipTranslateLineTransform');
   TGdiplusAPI.GdipTranslateMatrix := TGdiplusAPI.GetFunctionAddress('GdipTranslateMatrix');
   TGdiplusAPI.GdipTranslatePathGradientTransform := TGdiplusAPI.GetFunctionAddress('GdipTranslatePathGradientTransform');
   TGdiplusAPI.GdipTranslatePenTransform := TGdiplusAPI.GetFunctionAddress('GdipTranslatePenTransform');
   TGdiplusAPI.GdipTranslateRegion := TGdiplusAPI.GetFunctionAddress('GdipTranslateRegion');
   TGdiplusAPI.GdipTranslateTextureTransform := TGdiplusAPI.GetFunctionAddress('GdipTranslateTextureTransform');
   TGdiplusAPI.GdipTranslateWorldTransform := TGdiplusAPI.GetFunctionAddress('GdipTranslateWorldTransform');
   TGdiplusAPI.GdipVectorTransformMatrixPoints := TGdiplusAPI.GetFunctionAddress('GdipVectorTransformMatrixPoints');
   TGdiplusAPI.GdipVectorTransformMatrixPointsI := TGdiplusAPI.GetFunctionAddress('GdipVectorTransformMatrixPointsI');
   TGdiplusAPI.GdipWarpPath := TGdiplusAPI.GetFunctionAddress('GdipWarpPath');
   TGdiplusAPI.GdipWidenPath := TGdiplusAPI.GetFunctionAddress('GdipWidenPath');
end;

class function TGdiplusAPI.GetFunctionAddress(const ProcName: string): Pointer;
begin
   Result := Winapi.Windows.GetProcAddress(HGdiplusModule, PWideChar(ProcName));

   if @Result = nil then
      raise EMethodNotFound.Create('[gdiplus.dll] Não foi possível encontrar o procedimento especificado: "' + ProcName + '".');
end;

{  TGdiplusAPI.TGdiplusStartupInputEx }

class function TGdiplusAPI.TGdiplusStartupInputEx.GetDefault(): TGdiplusStartupInputEx;
begin
   Result := Default(TGdiplusStartupInputEx);

   // No Windows 7, a história do GDI+ 1.1 é diferente, pois existem diferentes binários por versão do GDI+.
   var isWindows7: Boolean := (TOSVersion.Platform = TOSVersion.TPlatform.pfWindows) and (TOSVersion.Major = 6) and (TOSVersion.Minor = 1);

   if isWindows7 then
      result.Base.GdiplusVersion := TGdiplusVersionEnum.V1
   else
   begin
      CoInitialize(nil);
      result.Base.GdiplusVersion := TGdiplusVersionEnum.V3
   end;

   result.Base.SuppressBackgroundThread := False;
   result.Base.SuppressExternalCodecs := False;
   result.StartupParameters := TGdiplusStartupParamsFlags.Default;
end;

{ TGdiplusAPI.TGdipStatusEnumHelper }

procedure TGdiplusAPI.TGdipStatusEnumHelper.ThrowIfFailed();
begin
   if (Self <> TGdipStatusEnum.Ok) then
   begin
      raise Self.GetException();
   end;
end;

procedure TGdiplusAPI.TGdipStatusEnumHelper.RaiseIfFailed();
begin
   ThrowIfFailed();
end;

function TGdiplusAPI.TGdipStatusEnumHelper.GetException(): Exception;
begin
  Assert(Self <> TGdipStatusEnum.Ok, 'Lançando uma exceção para um código de retorno ''Ok''');

  case (Self) of
      TGdipStatusEnum.GenericError:
          Result := EExternalException.Create(ToMessageString()); //'SR.GdiplusGenericError, (int)HRESULT.E_FAIL');
      TGdipStatusEnum.InvalidParameter:
          Result := EArgumentException.Create(ToMessageString()); //('SR.GdiplusInvalidParameter');
      TGdipStatusEnum.OutOfMemory:
          Result := EOutOfMemory.Create(ToMessageString()); //('SR.GdiplusOutOfMemory');
      TGdipStatusEnum.ObjectBusy:
          Result := EInvalidOperation.Create(ToMessageString()); //('SR.GdiplusObjectBusy');
      TGdipStatusEnum.InsufficientBuffer:
          Result := EOutOfMemory.Create(ToMessageString()); //('SR.GdiplusInsufficientBuffer');
      TGdipStatusEnum.NotImplemented:
          Result := ENotImplemented.Create(ToMessageString()); //('SR.GdiplusNotImplemented');
      TGdipStatusEnum.Win32Error:
          Result := EExternalException.Create(ToMessageString()); //('SR.GdiplusGenericError, (int)HRESULT.E_FAIL');
      TGdipStatusEnum.WrongState:
          Result := EInvalidOperation.Create(ToMessageString()); //('SR.GdiplusWrongState');
      TGdipStatusEnum.Aborted:
          Result := EExternalException.Create(ToMessageString()); //('SR.GdiplusAborted, (int)HRESULT.E_ABORT');
      TGdipStatusEnum.FileNotFound:
          Result := EFileNotFoundException.Create(ToMessageString()); //('SR.GdiplusFileNotFound');
      TGdipStatusEnum.ValueOverflow:
          Result := EOverflow.Create(ToMessageString()); //('SR.GdiplusOverflow');
      TGdipStatusEnum.AccessDenied:
          Result := EExternalException.Create(ToMessageString()); //('SR.GdiplusAccessDenied, (int)HRESULT.E_ACCESSDENIED');
      TGdipStatusEnum.UnknownImageFormat:
          Result := EArgumentException.Create(ToMessageString()); //('SR.GdiplusUnknownImageFormat');
      TGdipStatusEnum.PropertyNotFound:
          Result := EArgumentException.Create(ToMessageString()); //('SR.GdiplusPropertyNotFoundError');
      TGdipStatusEnum.PropertyNotSupported:
          Result := EArgumentException.Create(ToMessageString()); //('SR.GdiplusPropertyNotSupportedError');

      TGdipStatusEnum.FontFamilyNotFound:
      begin
          Assert(False, 'Deveríamos usar letras especiais FontFamilyNotFound para que possamos fornecer o nome da fonte');
          Result := EArgumentException.CreateFmt(ToMessageString(), ['?']); //('string.Format(SR.GdiplusFontFamilyNotFound, "?")');
      end;

      TGdipStatusEnum.FontStyleNotFound:
      begin
          Assert(False, 'Devemos usar letras especiais FontStyleNotFound para que possamos fornecer o nome da fonte');
          Result := EArgumentException.CreateFmt(ToMessageString(), ['?', '?']); //('string.Format(SR.GdiplusFontStyleNotFound, "?", "?")');
      end;

      TGdipStatusEnum.NotTrueTypeFont:
      begin
          Assert(False, 'Devemos usar NotTrueTypeFont com maiúsculas e minúsculas especiais para que possamos fornecer o nome da fonte');
          Result := EArgumentException.Create(ToMessageString()); //('SR.GdiplusNotTrueTypeFont_NoName');
      end;

      TGdipStatusEnum.UnsupportedGdiplusVersion:
          Result := EExternalException.Create(ToMessageString()); //('SR.GdiplusUnsupportedGdiplusVersion, (int)HRESULT.E_FAIL');

      TGdipStatusEnum.GdiplusNotInitialized:
          Result := EExternalException.Create(ToMessageString()); //('SR.GdiplusNotInitialized, (int)HRESULT.E_FAIL');
   else
      Result := EExternalException.CreateFmt(ToMessageString(), [Self]); //('$"{SR.GdiplusUnknown} [{status}]", (int)HRESULT.E_UNEXPECTED');
   end;

end;

function TGdiplusAPI.TGdipStatusEnumHelper.ToString(): string;
begin
  case (Self) of
      TGdipStatusEnum.GenericError:
          Result := SGdiplusGenericError;
      TGdipStatusEnum.InvalidParameter:
          Result := SGdiplusInvalidParameter;
      TGdipStatusEnum.OutOfMemory:
          Result := SGdiplusOutOfMemory;
      TGdipStatusEnum.ObjectBusy:
          Result := SGdiplusObjectBusy;
      TGdipStatusEnum.InsufficientBuffer:
          Result := SGdiplusInsufficientBuffer;
      TGdipStatusEnum.NotImplemented:
          Result := SGdiplusNotImplemented;
      TGdipStatusEnum.Win32Error:
          Result := SGdiplusGenericError;
      TGdipStatusEnum.WrongState:
          Result := SGdiplusWrongState;
      TGdipStatusEnum.Aborted:
          Result := SGdiplusAborted;
      TGdipStatusEnum.FileNotFound:
          Result := SGdiplusFileNotFound;
      TGdipStatusEnum.ValueOverflow:
          Result := SGdiplusOverflow;
      TGdipStatusEnum.AccessDenied:
          Result := SGdiplusAccessDenied;
      TGdipStatusEnum.UnknownImageFormat:
          Result := SGdiplusUnknownImageFormat;
      TGdipStatusEnum.PropertyNotFound:
          Result := SGdiplusPropertyNotFoundError;
      TGdipStatusEnum.PropertyNotSupported:
          Result := SGdiplusPropertyNotSupportedError;
      TGdipStatusEnum.FontFamilyNotFound:
          Result := SGdiplusFontFamilyNotFound;
      TGdipStatusEnum.FontStyleNotFound:
          Result := SGdiplusFontStyleNotFound;
      TGdipStatusEnum.NotTrueTypeFont:
          Result := SGdiplusNotTrueTypeFont_NoName;
      TGdipStatusEnum.UnsupportedGdiplusVersion:
          Result := SGdiplusUnsupportedGdiplusVersion;
      TGdipStatusEnum.GdiplusNotInitialized:
          Result := SGdiplusNotInitialized;
   else
      Result := Format(SGdiplusUnknown, [Self]);
   end;
end;

function TGdiplusAPI.TGdipStatusEnumHelper.ToMessageString(): string;
begin
   Result := IntToStr(Self) + '-' + ToString();
end;

end.
