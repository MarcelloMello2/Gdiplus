// Marcelo Melo
// 27/03/2024

unit Se7e.Drawing.Gdiplus.Types;

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
   System.Classes,
   Winapi.Windows,
   Winapi.ActiveX,
   Se7e.Drawing.Rectangle,
   Se7e.Windows.Win32.Graphics.GdiplusAPI;

const
   WmfRecordBase = $00010000;
   EmfPlusRecordBase = $00004000;

//---------------------------------------------------------------------------
// Image property types
//---------------------------------------------------------------------------

  PropertyTagTypeByte        = 1;
  PropertyTagTypeASCII       = 2;
  PropertyTagTypeShort       = 3;
  PropertyTagTypeLong        = 4;
  PropertyTagTypeRational    = 5;
  PropertyTagTypeUndefined   = 7;
  PropertyTagTypeSLONG       = 9;
  PropertyTagTypeSRational  = 10;


//---------------------------------------------------------------------------
// Image property ID tags
//---------------------------------------------------------------------------

  PropertyTagExifIFD             = $8769;
  PropertyTagGpsIFD              = $8825;

  PropertyTagNewSubfileType      = $00FE;
  PropertyTagSubfileType         = $00FF;
  PropertyTagImageWidth          = $0100;
  PropertyTagImageHeight         = $0101;
  PropertyTagBitsPerSample       = $0102;
  PropertyTagCompression         = $0103;
  PropertyTagPhotometricInterp   = $0106;
  PropertyTagThreshHolding       = $0107;
  PropertyTagCellWidth           = $0108;
  PropertyTagCellHeight          = $0109;
  PropertyTagFillOrder           = $010A;
  PropertyTagDocumentName        = $010D;
  PropertyTagImageDescription    = $010E;
  PropertyTagEquipMake           = $010F;
  PropertyTagEquipModel          = $0110;
  PropertyTagStripOffsets        = $0111;
  PropertyTagOrientation         = $0112;
  PropertyTagSamplesPerPixel     = $0115;
  PropertyTagRowsPerStrip        = $0116;
  PropertyTagStripBytesCount     = $0117;
  PropertyTagMinSampleValue      = $0118;
  PropertyTagMaxSampleValue      = $0119;
  PropertyTagXResolution         = $011A;   // Image resolution in width direction
  PropertyTagYResolution         = $011B;   // Image resolution in height direction
  PropertyTagPlanarConfig        = $011C;   // Image data arrangement
  PropertyTagPageName            = $011D;
  PropertyTagXPosition           = $011E;
  PropertyTagYPosition           = $011F;
  PropertyTagFreeOffset          = $0120;
  PropertyTagFreeByteCounts      = $0121;
  PropertyTagGrayResponseUnit    = $0122;
  PropertyTagGrayResponseCurve   = $0123;
  PropertyTagT4Option            = $0124;
  PropertyTagT6Option            = $0125;
  PropertyTagResolutionUnit      = $0128;   // Unit of X and Y resolution
  PropertyTagPageNumber          = $0129;
  PropertyTagTransferFuncition   = $012D;
  PropertyTagSoftwareUsed        = $0131;
  PropertyTagDateTime            = $0132;
  PropertyTagArtist              = $013B;
  PropertyTagHostComputer        = $013C;
  PropertyTagPredictor           = $013D;
  PropertyTagWhitePoint          = $013E;
  PropertyTagPrimaryChromaticities = $013F;
  PropertyTagColorMap            = $0140;
  PropertyTagHalftoneHints       = $0141;
  PropertyTagTileWidth           = $0142;
  PropertyTagTileLength          = $0143;
  PropertyTagTileOffset          = $0144;
  PropertyTagTileByteCounts      = $0145;
  PropertyTagInkSet              = $014C;
  PropertyTagInkNames            = $014D;
  PropertyTagNumberOfInks        = $014E;
  PropertyTagDotRange            = $0150;
  PropertyTagTargetPrinter       = $0151;
  PropertyTagExtraSamples        = $0152;
  PropertyTagSampleFormat        = $0153;
  PropertyTagSMinSampleValue     = $0154;
  PropertyTagSMaxSampleValue     = $0155;
  PropertyTagTransferRange       = $0156;

  PropertyTagJPEGProc            = $0200;
  PropertyTagJPEGInterFormat     = $0201;
  PropertyTagJPEGInterLength     = $0202;
  PropertyTagJPEGRestartInterval = $0203;
  PropertyTagJPEGLosslessPredictors  = $0205;
  PropertyTagJPEGPointTransforms     = $0206;
  PropertyTagJPEGQTables         = $0207;
  PropertyTagJPEGDCTables        = $0208;
  PropertyTagJPEGACTables        = $0209;

  PropertyTagYCbCrCoefficients   = $0211;
  PropertyTagYCbCrSubsampling    = $0212;
  PropertyTagYCbCrPositioning    = $0213;
  PropertyTagREFBlackWhite       = $0214;

  PropertyTagICCProfile          = $8773;   // This TAG is defined by ICC
                                            // for embedded ICC in TIFF
  PropertyTagGamma               = $0301;
  PropertyTagICCProfileDescriptor = $0302;
  PropertyTagSRGBRenderingIntent = $0303;

  PropertyTagImageTitle          = $0320;
  PropertyTagCopyright           = $8298;

// Extra TAGs (Like Adobe Image Information tags etc.)

  PropertyTagResolutionXUnit           = $5001;
  PropertyTagResolutionYUnit           = $5002;
  PropertyTagResolutionXLengthUnit     = $5003;
  PropertyTagResolutionYLengthUnit     = $5004;
  PropertyTagPrintFlags                = $5005;
  PropertyTagPrintFlagsVersion         = $5006;
  PropertyTagPrintFlagsCrop            = $5007;
  PropertyTagPrintFlagsBleedWidth      = $5008;
  PropertyTagPrintFlagsBleedWidthScale = $5009;
  PropertyTagHalftoneLPI               = $500A;
  PropertyTagHalftoneLPIUnit           = $500B;
  PropertyTagHalftoneDegree            = $500C;
  PropertyTagHalftoneShape             = $500D;
  PropertyTagHalftoneMisc              = $500E;
  PropertyTagHalftoneScreen            = $500F;
  PropertyTagJPEGQuality               = $5010;
  PropertyTagGridSize                  = $5011;
  PropertyTagThumbnailFormat           = $5012; // 1 = JPEG, 0 = RAW RGB
  PropertyTagThumbnailWidth            = $5013;
  PropertyTagThumbnailHeight           = $5014;
  PropertyTagThumbnailColorDepth       = $5015;
  PropertyTagThumbnailPlanes           = $5016;
  PropertyTagThumbnailRawBytes         = $5017;
  PropertyTagThumbnailSize             = $5018;
  PropertyTagThumbnailCompressedSize   = $5019;
  PropertyTagColorTransferFunction     = $501A;
  PropertyTagThumbnailData             = $501B; // RAW thumbnail bits in
                                                // JPEG format or RGB format
                                                // depends on
                                                // PropertyTagThumbnailFormat

// Thumbnail related TAGs

  PropertyTagThumbnailImageWidth       = $5020;  // Thumbnail width
  PropertyTagThumbnailImageHeight      = $5021;  // Thumbnail height
  PropertyTagThumbnailBitsPerSample    = $5022;  // Number of bits per
                                                 // component
  PropertyTagThumbnailCompression      = $5023;  // Compression Scheme
  PropertyTagThumbnailPhotometricInterp = $5024; // Pixel composition
  PropertyTagThumbnailImageDescription = $5025;  // Image Tile
  PropertyTagThumbnailEquipMake        = $5026;  // Manufacturer of Image
                                                 // Input equipment
  PropertyTagThumbnailEquipModel       = $5027;  // Model of Image input
                                                 // equipment
  PropertyTagThumbnailStripOffsets     = $5028;  // Image data location
  PropertyTagThumbnailOrientation      = $5029;  // Orientation of image
  PropertyTagThumbnailSamplesPerPixel  = $502A;  // Number of components
  PropertyTagThumbnailRowsPerStrip     = $502B;  // Number of rows per strip
  PropertyTagThumbnailStripBytesCount  = $502C;  // Bytes per compressed
                                                 // strip
  PropertyTagThumbnailResolutionX      = $502D;  // Resolution in width
                                                 // direction
  PropertyTagThumbnailResolutionY      = $502E;  // Resolution in height
                                                 // direction
  PropertyTagThumbnailPlanarConfig     = $502F;  // Image data arrangement
  PropertyTagThumbnailResolutionUnit   = $5030;  // Unit of X and Y
                                                 // Resolution
  PropertyTagThumbnailTransferFunction = $5031;  // Transfer function
  PropertyTagThumbnailSoftwareUsed     = $5032;  // Software used
  PropertyTagThumbnailDateTime         = $5033;  // File change date and
                                                 // time
  PropertyTagThumbnailArtist           = $5034;  // Person who created the
                                                 // image
  PropertyTagThumbnailWhitePoint       = $5035;  // White point chromaticity
  PropertyTagThumbnailPrimaryChromaticities = $5036; // Chromaticities of
                                                     // primaries
  PropertyTagThumbnailYCbCrCoefficients = $5037; // Color space transforma-
                                                 // tion coefficients
  PropertyTagThumbnailYCbCrSubsampling = $5038;  // Subsampling ratio of Y
                                                 // to C
  PropertyTagThumbnailYCbCrPositioning = $5039;  // Y and C position
  PropertyTagThumbnailRefBlackWhite    = $503A;  // Pair of black and white
                                                 // reference values
  PropertyTagThumbnailCopyRight        = $503B;  // CopyRight holder

  PropertyTagLuminanceTable            = $5090;
  PropertyTagChrominanceTable          = $5091;

  PropertyTagFrameDelay                = $5100;
  PropertyTagLoopCount                 = $5101;

  PropertyTagGlobalPalette             = $5102;
  PropertyTagIndexBackground           = $5103;
  PropertyTagIndexTransparent          = $5104;

  PropertyTagPixelUnit         = $5110;  // Unit specifier for pixel/unit
  PropertyTagPixelPerUnitX     = $5111;  // Pixels per unit in X
  PropertyTagPixelPerUnitY     = $5112;  // Pixels per unit in Y
  PropertyTagPaletteHistogram  = $5113;  // Palette histogram

// EXIF specific tag

  PropertyTagExifExposureTime  = $829A;
  PropertyTagExifFNumber       = $829D;

  PropertyTagExifExposureProg  = $8822;
  PropertyTagExifSpectralSense = $8824;
  PropertyTagExifISOSpeed      = $8827;
  PropertyTagExifOECF          = $8828;

  PropertyTagExifVer            = $9000;
  PropertyTagExifDTOrig         = $9003; // Date & time of original
  PropertyTagExifDTDigitized    = $9004; // Date & time of digital data generation

  PropertyTagExifCompConfig     = $9101;
  PropertyTagExifCompBPP        = $9102;

  PropertyTagExifShutterSpeed   = $9201;
  PropertyTagExifAperture       = $9202;
  PropertyTagExifBrightness     = $9203;
  PropertyTagExifExposureBias   = $9204;
  PropertyTagExifMaxAperture    = $9205;
  PropertyTagExifSubjectDist    = $9206;
  PropertyTagExifMeteringMode   = $9207;
  PropertyTagExifLightSource    = $9208;
  PropertyTagExifFlash          = $9209;
  PropertyTagExifFocalLength    = $920A;
  PropertyTagExifSubjectArea    = $9214;  // exif 2.2 Subject Area
  PropertyTagExifMakerNote      = $927C;
  PropertyTagExifUserComment    = $9286;
  PropertyTagExifDTSubsec       = $9290;  // Date & Time subseconds
  PropertyTagExifDTOrigSS       = $9291;  // Date & Time original subseconds
  PropertyTagExifDTDigSS        = $9292;  // Date & TIme digitized subseconds

  PropertyTagExifFPXVer         = $A000;
  PropertyTagExifColorSpace     = $A001;
  PropertyTagExifPixXDim        = $A002;
  PropertyTagExifPixYDim        = $A003;
  PropertyTagExifRelatedWav     = $A004;  // related sound file
  PropertyTagExifInterop        = $A005;
  PropertyTagExifFlashEnergy    = $A20B;
  PropertyTagExifSpatialFR      = $A20C;  // Spatial Frequency Response
  PropertyTagExifFocalXRes      = $A20E;  // Focal Plane X Resolution
  PropertyTagExifFocalYRes      = $A20F;  // Focal Plane Y Resolution
  PropertyTagExifFocalResUnit   = $A210;  // Focal Plane Resolution Unit
  PropertyTagExifSubjectLoc     = $A214;
  PropertyTagExifExposureIndex  = $A215;
  PropertyTagExifSensingMethod  = $A217;
  PropertyTagExifFileSource     = $A300;
  PropertyTagExifSceneType      = $A301;
  PropertyTagExifCfaPattern     = $A302;

// New EXIF 2.2 properties

  PropertyTagExifCustomRendered           = $A401;
  PropertyTagExifExposureMode             = $A402;
  PropertyTagExifWhiteBalance             = $A403;
  PropertyTagExifDigitalZoomRatio         = $A404;
  PropertyTagExifFocalLengthIn35mmFilm    = $A405;
  PropertyTagExifSceneCaptureType         = $A406;
  PropertyTagExifGainControl              = $A407;
  PropertyTagExifContrast                 = $A408;
  PropertyTagExifSaturation               = $A409;
  PropertyTagExifSharpness                = $A40A;
  PropertyTagExifDeviceSettingDesc        = $A40B;
  PropertyTagExifSubjectDistanceRange     = $A40C;
  PropertyTagExifUniqueImageID            = $A420;


  PropertyTagGpsVer             = $0000;
  PropertyTagGpsLatitudeRef     = $0001;
  PropertyTagGpsLatitude        = $0002;
  PropertyTagGpsLongitudeRef    = $0003;
  PropertyTagGpsLongitude       = $0004;
  PropertyTagGpsAltitudeRef     = $0005;
  PropertyTagGpsAltitude        = $0006;
  PropertyTagGpsGpsTime         = $0007;
  PropertyTagGpsGpsSatellites   = $0008;
  PropertyTagGpsGpsStatus       = $0009;
  PropertyTagGpsGpsMeasureMode  = $000A ;
  PropertyTagGpsGpsDop          = $000B;  // Measurement precision
  PropertyTagGpsSpeedRef        = $000C;
  PropertyTagGpsSpeed           = $000D;
  PropertyTagGpsTrackRef        = $000E;
  PropertyTagGpsTrack           = $000F;
  PropertyTagGpsImgDirRef       = $0010;
  PropertyTagGpsImgDir          = $0011;
  PropertyTagGpsMapDatum        = $0012;
  PropertyTagGpsDestLatRef      = $0013;
  PropertyTagGpsDestLat         = $0014;
  PropertyTagGpsDestLongRef     = $0015;
  PropertyTagGpsDestLong        = $0016;
  PropertyTagGpsDestBearRef     = $0017;
  PropertyTagGpsDestBear        = $0018;
  PropertyTagGpsDestDistRef     = $0019;
  PropertyTagGpsDestDist        = $001A;
  PropertyTagGpsProcessingMethod = $001B;
  PropertyTagGpsAreaInformation = $001C;
  PropertyTagGpsDate            = $001D;
  PropertyTagGpsDifferential    = $001E;


type

   TDeviceContextHandle = Winapi.Windows.HDC;

//  TGdipPlgPointsF = array [0..2] of TPointF;
//  TGdipPlgPoints = array [0..2] of TPoint;

   { TEventArgs }

   /// <summary>
   /// Representa a classe base das classes que contêm dados de evento e fornece um valor a ser usado para eventos que não incluem dados de evento.
   // </summary>
   TEventArgs = class(TInterfacedObject)
      /// <summary>
      /// Fornece um valor para ser usado com eventos que não têm dados de evento.
      /// </summary>
      public const Empty: TEventArgs = nil;
  end;

   { TGdipEmfPlusFlags }

   /// <summary>
   ///  EMF+ Flags
   /// </summary>
   TGdipEmfPlusFlags = type UInt32;
   TGdipEmfPlusFlagsHelper = record helper for TGdipEmfPlusFlags
      public const Display = $00000001;
      public const NonDualGdi = $00000002;
      function HasFlag(const CheckFlag: TGdipEmfPlusFlags): Boolean;
   end;

   { TGdipEncoderValue }

	/// <summary>
   ///   Usado para especificar o valor do parâmetro passado a um codificador de imagem
   ///   JPEG ou TIFF ao usar os métodos <see cref="M:System.Drawing.Image.Save(System.String,System.Drawing.Imaging.ImageCodecInfo,System.Drawing.Imaging.EncoderParameters)" />
   ///   ou <see cref="M:System.Drawing.Image.SaveAdd(System.Drawing.Imaging.EncoderParameters)" />.
   /// </summary>
   /// <remarks>
   ///   <para>Um determinado codificador suporta determinadas categorias de parâmetros e, para cada uma dessas categorias, esse</para>
   ///   <para>codificador permite determinados valores. Por exemplo, o codificador JPEG oferece suporte à categoria de parâmetro</para>
   ///   <para>EncoderValueQuality e os valores de parâmetro permitidos são números inteiros de 0 a 100. Alguns dos valores de</para>
   ///   <para>parâmetro permitidos são os mesmos em vários codificadores.</para>
   ///   </para>
   /// </remarks>
   TGdipEncoderValue = (

      /// <summary>
      ///   Especifica o espaço de cor CMYK.
      /// </summary>
      ColorTypeCMYK,

      /// <summary>
      ///   Especifica o espaço de cor YCCK.
      /// </summary>
      ColorTypeYCCK,

      /// <summary>
      ///   Especifica o esquema de compactação LZW. Pode ser passado ao codificador de TIFF
      ///   como um parâmetro que pertence à categoria de Compactação.
      /// </summary>
      CompressionLZW,

      /// <summary>
      ///   Especifica o esquema de compactação CCITT3. Pode ser passado ao codificador de
      ///   TIFF como um parâmetro que pertence à categoria de compactação.
      /// </summary>
      CompressionCCITT3,

      /// <summary>
      ///   Especifica o esquema de compactação CCITT4. Pode ser passado ao codificador de
      ///   TIFF como um parâmetro que pertence à categoria de compactação.
      /// </summary>
      CompressionCCITT4,

      /// <summary>
      ///   Especifica o esquema de compactação RLE. Pode ser passado ao codificador de TIFF
      ///   como um parâmetro que pertence à categoria de compactação.
      /// </summary>
      ///
      CompressionRle,

      /// <summary>
      ///   Não especifica nenhuma compactação. Pode ser passado ao codificador de TIFF como
      ///   um parâmetro que pertence à categoria de compactação.
      /// </summary>
      CompressionNone,

      /// <summary>
      ///   Especifica o modo entrelaçado.
      /// </summary>
      ScanMethodInterlaced,

      /// <summary>
      ///   Especifica o modo não entrelaçado.
      /// </summary>
      ScanMethodNonInterlaced,

      /// <summary>
      ///   Para uma imagem GIF, especifica a versão 87.
      /// </summary>
      VersionGif87,

      /// <summary>
      ///   Para imagens GIF, especifica a versão 89a.
      /// </summary>
      VersionGif89,

      /// <summary>
      ///   Especifica o modo progressivo.
      /// </summary>
      ///
      RenderProgressive,
      /// <summary>
      ///   Especifica o modo não progressivo.
      /// </summary>
      RenderNonProgressive,

      /// <summary>
      ///   Especifica que a imagem deve ser girada 90 graus no sentido horário sobre seu
      ///   centro sem perda. Pode ser passado ao codificador de JPEG como um parâmetro
      ///   que pertence à categoria de transformação.
      /// </summary>
      TransformRotate90,

      /// <summary>
      ///   Especifica que a imagem deve ser girada 180 graus sobre seu centro sem perda.
      ///   Pode ser passado ao codificador de JPEG como um parâmetro que pertence à
      ///   categoria de transformação.
      /// </summary>
      TransformRotate180,

      /// <summary>
      ///   Especifica que a imagem deve ser girada 270 graus no sentido horário
      ///   sobre seu centro sem perda. Pode ser passado ao codificador de JPEG
      ///   como um parâmetro que pertence à categoria de transformação.
      /// </summary>
      TransformRotate270,

		/// <summary>
      ///   Especifica que a imagem deve ser invertida horizontalmente (sobre o eixo vertical).
      ///   Pode ser passado ao codificador de JPEG como um parâmetro que pertence à categoria
      ///   de transformação.
      /// </summary>
      TransformFlipHorizontal,

		/// <summary>
      ///   Especifica que a imagem deve ser invertida verticalmente (sobre o eixo horizontal).
      ///   Pode ser passado ao codificador de JPEG como um parâmetro que pertence à categoria
      ///   de transformação.
      /// </summary>
		TransformFlipVertical,

		/// <summary>
      ///   Especifica que a imagem tem mais de um quadro (página). Pode ser passado ao codificador
      ///   de TIFF como um parâmetro que pertence à categoria de sinalizador de salvamento.
      /// </summary>
		MultiFrame,

		/// <summary>
      ///   Especifica o último quadro em uma imagem de vários quadros. Pode ser passado
      ///   ao codificador de TIFF como um parâmetro que pertence à categoria de sinalizador
      ///   de salvamento.
      /// </summary>
		LastFrame,

		/// <summary>
      ///   Especifica que um arquivo ou fluxo de vários quadros deve ser fechado. Pode ser
      ///   passado ao codificador de TIFF como um parâmetro que pertence à categoria de
      ///   sinalizador de salvamento.
      /// </summary>
		Flush,

      /// <summary>
      ///   Para uma imagem GIF, especifica a dimensão de tempo do quadro.
      /// </summary>
      FrameDimensionTime,

      /// <summary>
      ///   Especifica a dimensão de resolução do quadro.
      /// </summary>
      FrameDimensionResolution,

		/// <summary>
      ///   Especifica que um quadro deve ser adicionado à dimensão de página de uma imagem.
      ///   Pode ser passado ao codificador de TIFF como um parâmetro que pertence à categoria
      ///   de sinalizador de salvamento.
      /// </summary>
      FrameDimensionPage,

      ColorTypeGray,
      ColorTypeRGB
   );


   { TGdipApplyGraphicsProperties }

   /// <summary>
   /// Enumeração definindo as diferentes propriedades gráficas para aplicar a um <see cref="HDC"/> quando criado
   /// a partir de um objeto Graphics.
   /// </summary>
   TGdipApplyGraphicsProperties = type UInt32;
   TGdipApplyGraphicsPropertiesHelper = record helper for TGdipApplyGraphicsProperties
      public const None = $0000_0000;

      /// <summary>
      /// Aplicar região de recorte.
      /// </summary>
      public const Clipping = $0000_0001;

      /// <summary>
      /// Aplicar transformação de coordenadas.
      /// </summary>
      public const TranslateTransform = $0000_0002;

      /// <summary>
      /// Aplicar todas as propriedades gráficas suportadas.
      /// </summary>
      public const All = Clipping or TranslateTransform;

      function HasFlag(const CheckFlag: TGdipApplyGraphicsProperties): Boolean;
   end;

   { TGdipCoordinateSpace }

   /// <summary>
   ///   Especifica o sistema a ser usado ao avaliar as coordenadas.
   /// </summary>
   TGdipCoordinateSpace = (

         /// <summary>
         ///   Especifica que as coordenadas estão no contexto de coordenadas de mundo.
         ///   Coordenadas de mundo são usadas em um ambiente não físico, como um ambiente de modelagem.
         /// </summary>
         World = Ord(TGdiPlusAPI.TGdipCoordinateSpaceEnum.World),

		   /// <summary>
         ///   Especifica que as coordenadas estão no contexto de coordenadas de página.
         ///   Suas unidades são definidas pela propriedade <see cref="P:System.Drawing.Graphics.PageUnit" />
         ///   e deve ser um dos elementos da enumeração <see cref="T:System.Drawing.GraphicsUnit" />.
         /// </summary>
         Page = Ord(TGdiPlusAPI.TGdipCoordinateSpaceEnum.Page),

         /// <summary>
         ///   Especifica que as coordenadas estão no contexto de coordenadas de dispositivo.
         ///   Na tela do computador, as coordenadas de dispositivo geralmente são medidas em pixels.
         /// </summary>
         Device = Ord(TGdiPlusAPI.TGdipCoordinateSpaceEnum.Device)
   );

   /// <summary>
   // Per-channel Histogram for 8bpp images.
   /// </summary>
   TGdipHistogramFormat = (
      ARGB,
      PARGB,
      RGB,
      Gray,
      B,
      G,
      R,
      A
   );

   { TGdipPropertyIdList }

   TGdipPropertyIdList = TArray<TPropID>;
   TGdipPropertyIdListExtensions = record helper for TGdipPropertyIdList
      strict private function GetCount(): Integer;
      strict private procedure SetCount(const value: Integer);
      public property Count: Integer read GetCount write SetCount;
   end;

   { TGdipPropertyItem }

   /// <summary>
   ///  Encapsulates a metadata property to be included in an image file.
   /// </summary>
   TGdipPropertyItem = record

      strict private m_Id: Integer;

      /// <summary>
      ///  Represents the ID of the property.
      /// </summary>
      public property Id: Integer read m_Id write m_Id;
      strict private m_Len: Integer;

      /// <summary>
      ///  Represents the length of the property.
      /// </summary>
      public property Length: Integer read m_Len write m_Len;
      strict private m_Type: Int16;

      /// <summary>
      ///  Represents the type of the property.
      /// </summary>
      public property ValueType: Int16 read m_Type write m_Type;
      strict private m_Value: Pointer;

      /// <summary>
      ///  Contains the property value.
      /// </summary>
      public property Value: Pointer read m_Value write m_Value;

      public class function FromNative(const native: TGdiplusAPI.TGdipPropertyItemPtr): TGdipPropertyItem; static;
   end;

   TGdipPropertyItems = TArray<TGdipPropertyItem>;

   { TGdipEmfPlusRecordType }

   /// <summary>
   ///  Especifica os métodos disponíveis para uso com um meta-arquivo para ler e gravar
   ///  comandos gráficos.
   /// </summary>
   TGdipEmfPlusRecordType = (

         WmfRecordBase = $00010000,

         WmfSetBkColor = WmfRecordBase or $201,

         WmfSetBkMode = WmfRecordBase or $102,

         WmfSetMapMode = WmfRecordBase or $103,

         WmfSetROP2 = WmfRecordBase or $104,

         WmfSetRelAbs = WmfRecordBase or $105,

         WmfSetPolyFillMode = WmfRecordBase or $106,

         WmfSetStretchBltMode = WmfRecordBase or $107,

         WmfSetTextCharExtra = WmfRecordBase or $108,

         WmfSetTextColor = WmfRecordBase or $209,

         WmfSetTextJustification = WmfRecordBase or $20A,

         WmfSetWindowOrg = WmfRecordBase or $20B,

         WmfSetWindowExt = WmfRecordBase or $20C,

         WmfSetViewportOrg = WmfRecordBase or $20D,

         WmfSetViewportExt = WmfRecordBase or $20E,

         WmfOffsetWindowOrg = WmfRecordBase or $20F,

         WmfScaleWindowExt = WmfRecordBase or $410,

         WmfOffsetViewportOrg = WmfRecordBase or $211,

         WmfScaleViewportExt = WmfRecordBase or $412,

         WmfLineTo = WmfRecordBase or $213,

         WmfMoveTo = WmfRecordBase or $214,

         WmfExcludeClipRect = WmfRecordBase or $415,

         WmfIntersectClipRect = WmfRecordBase or $416,

         WmfArc = WmfRecordBase or $817,

         WmfEllipse = WmfRecordBase or $418,

         WmfFloodFill = WmfRecordBase or $419,

         WmfPie = WmfRecordBase or $81A,

         WmfRectangle = WmfRecordBase or $41B,

         WmfRoundRect = WmfRecordBase or $61C,

         WmfPatBlt = WmfRecordBase or $61D,

         WmfSaveDC = WmfRecordBase or Int32($01E),

         WmfSetPixel = WmfRecordBase or $41F,

         WmfOffsetCilpRgn = WmfRecordBase or $220,

         WmfTextOut = WmfRecordBase or $521,

         WmfBitBlt = WmfRecordBase or $922,

         WmfStretchBlt = WmfRecordBase or $B23,

         WmfPolygon = WmfRecordBase or $324,

         WmfPolyline = WmfRecordBase or $325,

         WmfEscape = WmfRecordBase or $626,

         WmfRestoreDC = WmfRecordBase or $127,

         WmfFillRegion = WmfRecordBase or $228,

         WmfFrameRegion = WmfRecordBase or $429,

         WmfInvertRegion = WmfRecordBase or $12A,

         WmfPaintRegion = WmfRecordBase or $12B,

         WmfSelectClipRegion = WmfRecordBase or $12C,

         WmfSelectObject = WmfRecordBase or $12D,

         WmfSetTextAlign = WmfRecordBase or $12E,

         WmfChord = WmfRecordBase or $830,

         WmfSetMapperFlags = WmfRecordBase or $231,

         WmfExtTextOut = WmfRecordBase or $A32,

         WmfSetDibToDev = WmfRecordBase or $D33,

         WmfSelectPalette = WmfRecordBase or $234,

         WmfRealizePalette = WmfRecordBase or Int32($035),

         WmfAnimatePalette = WmfRecordBase or $436,

         WmfSetPalEntries = WmfRecordBase or Int32($037),

         WmfPolyPolygon = WmfRecordBase or $538,

         WmfResizePalette = WmfRecordBase or $139,

         WmfDibBitBlt = WmfRecordBase or $940,

         WmfDibStretchBlt = WmfRecordBase or $b41,

         WmfDibCreatePatternBrush = WmfRecordBase or $142,

         WmfStretchDib = WmfRecordBase or $f43,

         WmfExtFloodFill = WmfRecordBase or $548,

         WmfSetLayout = WmfRecordBase or $149,

         WmfDeleteObject = WmfRecordBase or $1f0,

         WmfCreatePalette = WmfRecordBase or Int32($0f7),

         WmfCreatePatternBrush = WmfRecordBase or $1f9,

         WmfCreatePenIndirect = WmfRecordBase or $2fa,

         WmfCreateFontIndirect = WmfRecordBase or $2fb,

         WmfCreateBrushIndirect = WmfRecordBase or $2fc,

         WmfCreateRegion = WmfRecordBase or $6ff,

         // Since we have to enumerate GDI records right along with GDI+ records,
         // we list all the GDI records here so that they can be part of the
         // same enumeration type which is used in the enumeration callback.


         EmfHeader = 1,

         EmfPolyBezier = 2,

         EmfPolygon = 3,

         EmfPolyline = 4,

         EmfPolyBezierTo = 5,

         EmfPolyLineTo = 6,

         EmfPolyPolyline = 7,

         EmfPolyPolygon = 8,

         EmfSetWindowExtEx = 9,

         EmfSetWindowOrgEx = 10,

         EmfSetViewportExtEx = 11,

         EmfSetViewportOrgEx = 12,

         EmfSetBrushOrgEx = 13,

         EmfEof = 14,

         EmfSetPixelV = 15,

         EmfSetMapperFlags = 16,

         EmfSetMapMode = 17,

         EmfSetBkMode = 18,

         EmfSetPolyFillMode = 19,

         EmfSetROP2 = 20,

         EmfSetStretchBltMode = 21,

         EmfSetTextAlign = 22,

         EmfSetColorAdjustment = 23,

         EmfSetTextColor = 24,

         EmfSetBkColor = 25,

         EmfOffsetClipRgn = 26,

         EmfMoveToEx = 27,

         EmfSetMetaRgn = 28,

         EmfExcludeClipRect = 29,

         EmfIntersectClipRect = 30,

         EmfScaleViewportExtEx = 31,

         EmfScaleWindowExtEx = 32,

         EmfSaveDC = 33,

         EmfRestoreDC = 34,

         EmfSetWorldTransform = 35,

         EmfModifyWorldTransform = 36,

         EmfSelectObject = 37,

         EmfCreatePen = 38,

         EmfCreateBrushIndirect = 39,

         EmfDeleteObject = 40,

         EmfAngleArc = 41,

         EmfEllipse = 42,

         EmfRectangle = 43,

         EmfRoundRect = 44,

         EmfRoundArc = 45,

         EmfChord = 46,

         EmfPie = 47,

         EmfSelectPalette = 48,

         EmfCreatePalette = 49,

         EmfSetPaletteEntries = 50,

         EmfResizePalette = 51,

         EmfRealizePalette = 52,

         EmfExtFloodFill = 53,

         EmfLineTo = 54,

         EmfArcTo = 55,

         EmfPolyDraw = 56,

         EmfSetArcDirection = 57,

         EmfSetMiterLimit = 58,

         EmfBeginPath = 59,

         EmfEndPath = 60,

         EmfCloseFigure = 61,

         EmfFillPath = 62,

         EmfStrokeAndFillPath = 63,

         EmfStrokePath = 64,

         EmfFlattenPath = 65,

         EmfWidenPath = 66,

         EmfSelectClipPath = 67,

         EmfAbortPath = 68,

         EmfReserved069 = 69,

         EmfGdiComment = 70,

         EmfFillRgn = 71,

         EmfFrameRgn = 72,

         EmfInvertRgn = 73,

         EmfPaintRgn = 74,

         EmfExtSelectClipRgn = 75,

         EmfBitBlt = 76,

         EmfStretchBlt = 77,

         EmfMaskBlt = 78,

         EmfPlgBlt = 79,

         EmfSetDIBitsToDevice = 80,

         EmfStretchDIBits = 81,

         EmfExtCreateFontIndirect = 82,

         EmfExtTextOutA = 83,

         EmfExtTextOutW = 84,

         EmfPolyBezier16 = 85,

         EmfPolygon16 = 86,

         EmfPolyline16 = 87,

         EmfPolyBezierTo16 = 88,

         EmfPolylineTo16 = 89,

         EmfPolyPolyline16 = 90,

         EmfPolyPolygon16 = 91,

         EmfPolyDraw16 = 92,

         EmfCreateMonoBrush = 93,

         EmfCreateDibPatternBrushPt = 94,

         EmfExtCreatePen = 95,

         EmfPolyTextOutA = 96,

         EmfPolyTextOutW = 97,

         EmfSetIcmMode = 98,

         EmfCreateColorSpace = 99,

         EmfSetColorSpace = 100,

         EmfDeleteColorSpace = 101,

         EmfGlsRecord = 102,

         EmfGlsBoundedRecord = 103,

         EmfPixelFormat = 104,

         EmfDrawEscape = 105,

         EmfExtEscape = 106,

         EmfStartDoc = 107,

         EmfSmallTextOut = 108,

         EmfForceUfiMapping = 109,

         EmfNamedEscpae = 110,

         EmfColorCorrectPalette = 111,

         EmfSetIcmProfileA = 112,

         EmfSetIcmProfileW = 113,

         EmfAlphaBlend = 114,

         EmfSetLayout = 115,

         EmfTransparentBlt = 116,

         EmfReserved117 = 117,

         EmfGradientFill = 118,

         EmfSetLinkedUfis = 119,

         EmfSetTextJustification = 120,

         EmfColorMatchToTargetW = 121,

         EmfCreateColorSpaceW = 122,

         EmfMax = 122,

         EmfMin = 1,

         // That is the END of the GDI EMF records.

         // Now we start the list of EMF+ records.  We leave quite
         // a bit of room here for the addition of any new GDI
         // records that may be added later.


         EmfPlusRecordBase = $00004000,

         Invalid = EmfPlusRecordBase,

         Header,

         EndOfFile,


         Comment,


         GetDC,


         MultiFormatStart,

         MultiFormatSection,

         MultiFormatEnd,

         // For all Persistent Objects

         Object_,
         // Drawing Records

         Clear,

         FillRects,

         DrawRects,

         FillPolygon,

         DrawLines,

         FillEllipse,

         DrawEllipse,

         FillPie,

         DrawPie,

         DrawArc,

         FillRegion,

         FillPath,

         DrawPath,

         FillClosedCurve,

         DrawClosedCurve,

         DrawCurve,

         DrawBeziers,

         DrawImage,

         DrawImagePoints,

         DrawString,

         // Graphics State Records

         SetRenderingOrigin,

         SetAntiAliasMode,

         SetTextRenderingHint,

         SetTextContrast,

         SetInterpolationMode,

         SetPixelOffsetMode,

         SetCompositingMode,

         SetCompositingQuality,

         Save,

         Restore,

         BeginContainer,

         BeginContainerNoParams,

         EndContainer,

         SetWorldTransform,

         ResetWorldTransform,

         MultiplyWorldTransform,

         TranslateWorldTransform,

         ScaleWorldTransform,

         RotateWorldTransform,

         SetPageTransform,

         ResetClip,

         SetClipRect,

         SetClipPath,

         SetClipRegion,

         OffsetClip,


         DrawDriverString,

         Max,

         Total,



         Min = EmfPlusRecordBase + 1
   );

   { TGdipCompositingMode }

	/// <summary>
   ///   Especifica como as cores de origem são combinadas com as cores da tela de fundo.
   /// </summary>
   TGdipCompositingMode = (

      /// <summary>
      ///   Especifica que, quando uma cor é renderizada, ela é mesclada com a cor da tela de fundo.
      ///   A mesclagem é determinada pelo componente alfa da cor que está sendo renderizada.
      /// </summary>
      SourceOver = Ord(TGdiPlusAPI.TGdipCompositingModeEnum.SourceOver),

      /// <summary>
      ///   Especifica que, quando uma cor é renderizada, ela substitui a cor da tela de fundo.
      /// </summary>
      SourceCopy = Ord(TGdiPlusAPI.TGdipCompositingModeEnum.SourceCopy)
   );

   { TGdipQualityMode }

	/// <summary>
   ///   Especifica a qualidade geral ao renderizar objetos GDI+.
   /// </summary>
	TGdipQualityMode = (

		/// <summary>
      ///   Especifica um modo inválido.
      /// </summary>
		Invalid = Ord(TGdiPlusAPI.TGdipQualityModeEnum.Invalid),

		/// <summary>
      ///   Especifica o modo padrão.
      /// </summary>
		Default = Ord(TGdiPlusAPI.TGdipQualityModeEnum.Default),

		/// <summary>
      ///   Especifica a renderização de baixa qualidade e alta velocidade.
      /// </summary>
		Low = Ord(TGdiPlusAPI.TGdipQualityModeEnum.Low),

		/// <summary>
      ///   Especifica renderização de alta qualidade e baixa velocidade.
      /// </summary>
		High = Ord(TGdiPlusAPI.TGdipQualityModeEnum.High)
	);

   { TGdipInterpolationMode }

   /// <summary>
   ///   A enumeração <see cref="T:System.Drawing.Drawing2D.InterpolationMode" />
   ///   especifica o algoritmo que é usado quando as imagens são dimensionadas ou giradas.
   /// </summary>
   TGdipInterpolationMode = (

         /// <summary>
         ///   Equivalente ao elemento <see cref="F:System.Drawing.Drawing2D.QualityMode.Invalid" />
         ///   da enumeração <see cref="T:System.Drawing.Drawing2D.QualityMode" />.
         /// </summary>
         Invalid = Ord(TGdiPlusAPI.TGdipInterpolationModeEnum.Invalid) + 1,

         /// <summary>
         ///   Especifica o modo padrão.
         /// </summary>
         Default = Ord(TGdiPlusAPI.TGdipInterpolationModeEnum.Default) + 1,

         /// <summary>
         ///   Especifica a interpolação de baixa qualidade.
         /// </summary>
         Low = Ord(TGdiPlusAPI.TGdipInterpolationModeEnum.LowQuality) + 1,

         /// <summary>
         ///   Especifica a interpolação de alta qualidade.
         /// </summary>
         High = Ord(TGdiPlusAPI.TGdipInterpolationModeEnum.HighQuality) + 1,

         /// <summary>
         ///   Especifica a interpolação bilinear. Nenhuma pré-filtragem é necessária.
         ///   Esse modo não é adequado para reduzir uma imagem para menos de 50% de seu tamanho original.
         /// </summary>
         Bilinear = Ord(TGdiPlusAPI.TGdipInterpolationModeEnum.Bilinear) + 1,

         /// <summary>
         ///   Especifica a interpolação bicúbica. Nenhuma pré-filtragem é necessária.
         ///   Esse modo não é adequado para reduzir uma imagem para menos de 25% de seu tamanho original.
         /// </summary>
         Bicubic = Ord(TGdiPlusAPI.TGdipInterpolationModeEnum.Bicubic) + 1,

         /// <summary>
         ///   Especifica a interpolação de vizinho mais próximo.
         /// </summary>
         NearestNeighbor = Ord(TGdiPlusAPI.TGdipInterpolationModeEnum.NearestNeighbor) + 1,

         /// <summary>
         ///   Especifica a interpolação bilinear de alta qualidade.
         ///   A pré-filtragem é executada para garantir uma redução de alta qualidade.
         /// </summary>
         HighQualityBilinear = Ord(TGdiPlusAPI.TGdipInterpolationModeEnum.HighQualityBilinear) + 1,

         /// <summary>
         ///   Especifica a interpolação bicúbica de alta qualidade.
         ///   A pré-filtragem é executada para garantir uma redução de alta qualidade.
         ///   Esse modo produz as imagens transformada de mais alta qualidade.
         /// </summary>
         HighQualityBicubic = Ord(TGdiPlusAPI.TGdipInterpolationModeEnum.HighQualityBicubic) + 1
   );

   { TGdipTextRenderingHint }

   /// <summary>
   ///  Especifica a qualidade de renderização do texto.
   /// </summary>
   TGdipTextRenderingHint = (

      /// <summary>
      ///   Cada caractere é desenhado usando seu bitmap de glifo, com a dica de renderização padrão do sistema.
      ///   O texto será desenhado usando as configurações de suavização de fonte selecionadas pelo usuário para o sistema.
      /// </summary>
      SystemDefault = Ord(TGdiPlusAPI.TGdipTextRenderingHintEnum.SystemDefault),

      /// <summary>
      ///   Cada caractere é desenhado usando seu bitmap de glifo.
      ///   As dicas são usadas para melhorar a aparência de caractere nas hastes e curvaturas.
      /// </summary>
      SingleBitPerPixelGridFit = Ord(TGdiPlusAPI.TGdipTextRenderingHintEnum.SingleBitPerPixelGridFit),

      /// <summary>
      ///   Cada caractere é desenhado usando seu bitmap de glifo.
      ///   As dicas não são usadas.
      /// </summary>
      SingleBitPerPixel = Ord(TGdiPlusAPI.TGdipTextRenderingHintEnum.SingleBitPerPixel),

      /// <summary>
      ///   Cada caractere é desenhado usando seu bitmap de glifo com suavização e dicas.
      ///   Qualidade muito melhor devido à suavização, porém com custo de desempenho mais alto.
      /// </summary>
      AntiAliasGridFit = Ord(TGdiPlusAPI.TGdipTextRenderingHintEnum.AntiAliasGridFit),

      /// <summary>
      ///   Cada caractere é desenhado usando seu bitmap de glifo com suavização sem dicas.
      ///   Melhor qualidade devido à suavização.
      ///   Diferenças de largura de hastes podem ser perceptíveis, pois as dicas estão desativadas.
      /// </summary>
      AntiAlias = Ord(TGdiPlusAPI.TGdipTextRenderingHintEnum.AntiAlias),

      /// <summary>
      ///   Cada caractere é desenhado usando seu bitmap ClearType de glifo com dicas.
      ///   A configuração de qualidade mais alta.
      ///   Usado para tirar proveito dos recursos de fonte ClearType.
      /// </summary>
      ClearTypeGridFit = Ord(TGdiPlusAPI.TGdipTextRenderingHintEnum.ClearTypeGridFit)
   );



   { TGdipSmoothingMode }

   /// <summary>
   ///   Especifica se a suavização é aplicada às linhas e às curvas e às bordas das áreas preenchidas.
   /// </summary>
   TGdipSmoothingMode = (

         /// <summary>
         ///   Especifica um modo inválido.
         /// </summary>
         Invalid,

         /// <summary>
         ///   Não especifica uma suavização.
         /// </summary>
         Default,

         /// <summary>
         ///   Não especifica uma suavização.
         /// </summary>
         HighSpeed,

         /// <summary>
         ///   Especifica uma renderização suavizada.
         /// </summary>
         HighQuality,

         /// <summary>
         ///   Não especifica uma suavização.
         /// </summary>
         None,

         /// <summary>
         ///   Especifica uma renderização suavizada.
         /// </summary>
         AntiAlias8x4,
         AntiAlias8x8
   );

   { TGdipSmoothingModeExtensions }

   TGdipSmoothingModeExtensions = record helper for TGdipSmoothingMode
      public function ToNativeEnum(): TGdiplusAPI.TGdipSmoothingModeEnum;
      public function FromNativeEnum(const Value: TGdiplusAPI.TGdipSmoothingModeEnum): TGdipSmoothingMode;
   end;

   { TGdipPixelOffsetMode }

   /// <summary>
   ///   Especifica como os pixels são deslocados durante a renderização.
   /// </summary>
   TGdipPixelOffsetMode = (

         /// <summary>
         ///   Especifica um modo inválido.
         /// </summary>
         Invalid = Ord(TGdiPlusAPI.TGdipPixelOffsetModeEnum.Invalid)+1,

         /// <summary>
         ///   Especifica o modo padrão.
         /// </summary>
         Default = Ord(TGdiPlusAPI.TGdipPixelOffsetModeEnum.Default)+1,

         /// <summary>
         ///   Especifica renderização de alta velocidade e baixa qualidade.
         /// </summary>
         HighSpeed = Ord(TGdiPlusAPI.TGdipPixelOffsetModeEnum.HighSpeed)+1,

         /// <summary>
         ///   Especifica renderização de alta qualidade e baixa velocidade.
         /// </summary>
         HighQuality = Ord(TGdiPlusAPI.TGdipPixelOffsetModeEnum.HighQuality)+1,

         /// <summary>
         ///   Especifica nenhum deslocamento de pixels.
         /// </summary>
         None = Ord(TGdiPlusAPI.TGdipPixelOffsetModeEnum.None)+1,

         // offset by -0.5, -0.5 for fast anti-alias perf
         /// <summary>
         ///   Especifica que os pixels são deslocados em -0,5 unidades,
         ///   tanto horizontal quanto verticalmente,
         ///   para suavização de alta velocidade.
         /// </summary>
         Half = Ord(TGdiPlusAPI.TGdipPixelOffsetModeEnum.Half)+1
   );


   { TGdipCompositingQuality }

   /// <summary>
   ///   Especifica o nível de qualidade a ser usado durante a composição.
   /// </summary>
   TGdipCompositingQuality = (

         /// <summary>
         ///   Qualidade inválida.
         /// </summary>
         Invalid =  Ord(TGdiPlusAPI.TGdipCompositingQualityEnum.Invalid)+1,

         /// <summary>
         ///   Qualidade padrão.
         /// </summary>
         Default = Ord(TGdiPlusAPI.TGdipCompositingQualityEnum.Default)+1,

         /// <summary>
         ///   Alta velocidade, baixa qualidade.
         /// </summary>
         HighSpeed = Ord(TGdiPlusAPI.TGdipCompositingQualityEnum.HighSpeed)+1,

         /// <summary>
         ///   Composição de alta qualidade, baixa velocidade.
         /// </summary>
         HighQuality = Ord(TGdiPlusAPI.TGdipCompositingQualityEnum.HighQuality)+1,

         /// <summary>
         ///   A correção de gama é usada.
         /// </summary>
         GammaCorrected = Ord(TGdiPlusAPI.TGdipCompositingQualityEnum.GammaCorrected)+1,

         /// <summary>
         ///   Suponha valores lineares.
         /// </summary>
         AssumeLinear = Ord(TGdiPlusAPI.TGdipCompositingQualityEnum.AssumeLinear)+1
   );



   { TGdipColorMode }

   /// <summary>
   ///   Especifica dois modos para valores de componente de cor.
   /// </summary>
   TGdipColorMode = (

       /// <summary>
       ///  Os valores inteiros fornecidos são valores de 32 bits.
       /// </summary>
       ARGB32 = 0,

       /// <summary>
       ///  Os valores inteiros fornecidos são valores de 64 bits.
       /// </summary>
       ARGB64 = 1
   );


	/// <summary>
   ///   Especifica os canais individuais no espaço de cores CMYK (ciano, magenta, amarelo, preto).
   ///   Esta enumeração é usada pelos métodos <see cref="Overload:System.Drawing.Imaging.ImageAttributes.SetOutputChannel" />.
   /// </summary>
   TGdipColorChannelFlags = (

       /// <summary>
       ///  O canal da cor ciano.
       /// </summary>
       C = Ord(TGdiplusAPI.TGdipColorChannelFlagsEnum.ColorChannelFlagsC),

       /// <summary>
       ///  O canal da cor magenta.
       /// </summary>
       M = Ord(TGdiplusAPI.TGdipColorChannelFlagsEnum.ColorChannelFlagsM),

       /// <summary>
       ///  O canal da cor amarela.
       /// </summary>
       Y = Ord(TGdiplusAPI.TGdipColorChannelFlagsEnum.ColorChannelFlagsY),

       /// <summary>
       ///  O canal da cor preta.
       /// </summary>
       K = Ord(TGdiplusAPI.TGdipColorChannelFlagsEnum.ColorChannelFlagsK),

       /// <summary>
       ///  O último canal selecionado deve ser usado.
       /// </summary>
       Last = Ord(TGdiplusAPI.TGdipColorChannelFlagsEnum.ColorChannelFlagsLast)
   );

   { TGdipFontStyle }

   /// <summary>
   /// Specifies style information applied to text.
   /// </summary>
   TGdipFontStyle = type UInt32;
   TGdipFontStyleHelper = record helper for TGdipFontStyle
      /// <summary>
      /// Normal text.
      /// </summary>
      public const Regular = 0;
      /// <summary>
      /// Bold text.
      /// </summary>
      public const Bold: UInt32 = 1;
      /// <summary>
      /// Italic text.
      /// </summary>
      public const Italic = 2;
      /// <summary>
      /// Underlined text.
      /// </summary>
      public const Underline = 4;
      /// <summary>
      /// Text with a line through the middle.
      /// </summary>
      public const Strikeout = 8;
   end;


   { TGdipColorChannelFlag }

	/// <summary>
   ///   Especifica os canais individuais no espaço de cores CMYK (ciano, magenta, amarelo, preto).
   ///   Esta enumeração é usada pelos métodos <see cref="Overload:System.Drawing.Imaging.ImageAttributes.SetOutputChannel" />.
   /// </summary>
   TGdipColorChannelFlag = (
         /// <summary>
         /// Especifica o canal de cor Ciano.
         /// </summary>
         ColorChannelC = 0,

         /// <summary>
         /// Especifica o canal de cor Magenta.
         /// </summary>
         ColorChannelM,

         /// <summary>
         /// Especifica o canal de cor Amarelo.
         /// </summary>
         ColorChannelY,

         /// <summary>
         /// Especifica o canal de cor Preto.
         /// </summary>
         ColorChannelK,

         /// <summary>
         /// Este elemento especifica para deixar o canal de cor inalterado do último canal selecionado.
         /// </summary>
         ColorChannelLast
      );


   { TGdipWarpMode }

   /// <summary>
   ///   Especifica o tipo de transformação de distorção aplicada a um método <see cref="Overload:System.Drawing.Drawing2D.GraphicsPath.Warp" />.
   /// </summary>
   TGdipWarpMode = (

         /// <summary>
         ///   Especifica uma distorção de perspectiva.
         /// </summary>
         Perspective = Ord(TGdiplusAPI.TGdipWarpModeEnum.Perspective),

         /// <summary>
         ///   Especifica uma distorção bilinear.
         /// </summary>
         Bilinear = Ord(TGdiplusAPI.TGdipWarpModeEnum.Bilinear)
   );

   { TGdipGenericFontFamilies }

   /// <summary>
   /// Especifica uma <see cref='FontFamily'/> genérica.
   /// </summary>
   TGdipGenericFontFamilies = (

      /// <summary>
      /// Uma <see cref='FontFamily'/> Serif genérica.
      /// </summary>
      Serif,

      /// <summary>
      /// Uma <see cref='FontFamily'/> SansSerif genérica.
      /// </summary>
      SansSerif,

      /// <summary>
      /// Uma <see cref='FontFamily'/> Monospace genérica.
      /// </summary>
      Monospace
   );



   { TGdipFlushIntention }

   /// <summary>
   ///   Especifica se os comandos na pilha de gráficos são encerrados (liberados) imediatamente ou executados assim que possível.
   /// </summary>
   TGdipFlushIntention = (

      /// <summary>
      ///   Especifica que a pilha de todas as operações de gráficos é liberada imediatamente.
      /// </summary>
      Flush = Ord(TGdiplusAPI.TGdipFlushIntentionEnum.Flush),

      /// <summary>
      ///   Especifica que todas as operações de gráficos na pilha são executadas assim que possível. Isso sincroniza o estado dos gráficos.
      /// </summary>
      Sync = Ord(TGdiplusAPI.TGdipFlushIntentionEnum.Sync)
   );

   { TGdipFillMode }

   TGdipFillMode = (
         Alternate = Ord(TGdiplusAPI.TGdipFillModeEnum.Alternate),
         Winding = Ord(TGdiplusAPI.TGdipFillModeEnum.Winding)
   );


   { TGdipCombineMode }

   /// <summary>
   ///   Especifica como as diferentes regiões de recorte podem ser combinadas.
   /// </summary>
   TGdipCombineMode = (
      /// <summary>Uma área de recorte é substituída por outra.</summary>
      Replace = Ord(TGdiplusAPI.TGdipCombineModeEnum.Replace),
      /// <summary>Duas regiões de recorte são combinadas selecionando a interseção entre elas.</summary>
      Intersect = Ord(TGdiplusAPI.TGdipCombineModeEnum.Intersect),
      /// <summary>Duas regiões de recorte são combinadas selecionando a união de ambas.</summary>
      Union = Ord(TGdiplusAPI.TGdipCombineModeEnum.Union),
      /// <summary>Duas regiões de recorte são combinadas selecionando apenas as áreas delimitadas por uma região ou pela outra, mas não ambas.</summary>
      Xor_ = Ord(TGdiplusAPI.TGdipCombineModeEnum.Xor_),
      /// <summary>Especifica que a região existente é substituída pelo resultado da remoção da nova região da região existente. Em outras palavras, a nova região é excluída da região existente.</summary>
      Exclude = Ord(TGdiplusAPI.TGdipCombineModeEnum.Exclude),
      /// <summary>Especifica que a região existente é substituída pelo resultado da remoção da região existente da nova região. Em outras palavras, a região existente é excluída da nova região.</summary>
      Complement = Ord(TGdiplusAPI.TGdipCombineModeEnum.Complement)
   );

	/// <summary>
   /// Especifica a unidade de medida para os dados fornecidos.
   /// </summary>
	TGdipGraphicsUnit = (

		/// <summary>
      /// Especifica a unidade do sistema de coordenadas mundial como a unidade de medida.
      /// </summary>
		World = Ord(TGdiplusAPI.TGdipUnitEnum.World),

		/// <summary>
      /// Especifica a unidade de medida do dispositivo de vídeo. Normalmente são exibidos pixels para vídeos e 1/100 polegadas para impressoras.
      /// </summary>
		Display = Ord(TGdiplusAPI.TGdipUnitEnum.Display),

		/// <summary>
      /// Especifica um pixel de dispositivo como a unidade de medida.
      /// </summary>
		Pixel = Ord(TGdiplusAPI.TGdipUnitEnum.Pixel),

		/// <summary>
      /// Especifica o ponto da impressora (1/72 de polegada) como a unidade de medida.
      /// </summary>
		Point = Ord(TGdiplusAPI.TGdipUnitEnum.Point),

		/// <summary>
      /// Especifica a polegada como a unidade de medida.
      /// </summary>
		Inch = Ord(TGdiplusAPI.TGdipUnitEnum.Inch),

		/// <summary>
      /// Especifica a unidade de documento (1/300 de polegada) como a unidade de medida.
      /// </summary>
		Document = Ord(TGdiplusAPI.TGdipUnitEnum.Document),

		/// <summary>
      /// Especifica o milímetro como a unidade de medida.
      /// </summary>
		Millimeter = Ord(TGdiplusAPI.TGdipUnitEnum.Millimeter)
   );


   { TGdipStringAlignment }

   /// <summary>
   /// Especifica o alinhamento de uma string de texto em relação ao seu retângulo de layout.
   /// </summary>
   TGdipStringAlignment = (
      // esquerda ou topo em português
      /// <summary>
      /// Especifica que o texto seja alinhado próximo ao layout. Em um layout da esquerda para a direita, a posição próxima é à esquerda. Em um
      /// layout da direita para a esquerda, a posição próxima é à direita.
      /// </summary>
      Near = Ord(TGdiplusAPI.TGdipStringAlignmentEnum.Near),

      /// <summary>
      /// Especifica que o texto é alinhado no centro do retângulo de layout.
      /// </summary>
      Center = Ord(TGdiplusAPI.TGdipStringAlignmentEnum.Center),

      // direita ou fundo em português
      /// <summary>
      /// Especifica que o texto é alinhado longe da posição de origem do retângulo de layout. Em um layout da esquerda para a direita,
      /// a posição longe é à direita. Em um layout da direita para a esquerda, a posição longe é à esquerda.
      /// </summary>
      Far = Ord(TGdiplusAPI.TGdipStringAlignmentEnum.Far)
   );

   { TGdipHotkeyPrefix }

   /// <summary>
   ///   Especifica o tipo de exibição para prefixos de tecla de atalho que se relacionam ao texto.
   /// </summary>
   TGdipHotkeyPrefix = (

      /// <summary>
      ///   Nenhum prefixo de tecla de atalho.
      /// </summary>
      None = Ord(TGdiplusAPI.TGdipHotkeyPrefixEnum.None),

      /// <summary>
      ///   Exiba o prefixo de tecla de atalho.
      /// </summary>
      Show = Ord(TGdiplusAPI.TGdipHotkeyPrefixEnum.Show),

      /// <summary>
      ///   Não exiba o prefixo de tecla de atalho.
      /// </summary>
      Hide = Ord(TGdiplusAPI.TGdipHotkeyPrefixEnum.Hide)
   );

   { TGdipStringTrimming }

   /// <summary>
   ///  Especifica como cortar caracteres de uma cadeia de caracteres que não caiba completamente em uma forma de layout.
   /// </summary>
   TGdipStringTrimming = (
      /// <summary>
      ///  Não especifica nenhum corte
      /// </summary>
      None = Ord(TGdiPlusAPI.TGdipStringTrimmingEnum.None),

      /// <summary>
      ///  Especifica que o texto é cortado até o caractere mais próximo.
      /// </summary>
      Character = Ord(TGdiPlusAPI.TGdipStringTrimmingEnum.Character),

      /// <summary>
      ///  Especifica que o texto é cortado até a palavra mais próxima.
      /// </summary>
      Word = Ord(TGdiPlusAPI.TGdipStringTrimmingEnum.Word),

      /// <summary>
      ///  Especifica que o texto é cortado até o caractere mais próximo e um sinal de reticências (...)é inserido no final de uma linha cortada.
      /// </summary>
      EllipsisCharacter = Ord(TGdiPlusAPI.TGdipStringTrimmingEnum.EllipsisCharacter),

      /// <summary>
      ///  Especifica que o texto é cortado até a palavra mais próxima e um sinal de reticências (...) é inserido no final de uma linha cortada.
      /// </summary>
      EllipsisWord = Ord(TGdiPlusAPI.TGdipStringTrimmingEnum.EllipsisWord),

      /// <summary>
      ///  O centro é removido das linhas cortadas e substituído por um sinal de reticências.
      ///  O algoritmo mantém o máximo possível do último segmento delimitado por barra "/" da linha.
      /// </summary>
      EllipsisPath = Ord(TGdiPlusAPI.TGdipStringTrimmingEnum.EllipsisPath)
   );


   { TGdipStringFormatFlags }

   /// <summary>
   ///    Especifica as informações de exibição e layout para strings de texto  (como orientação e recorte) e manipulações
   ///    de exibição (como inserção de reticências, substituição de dígitos e representação de caracteres que não são
   ///    suportados por uma fonte).
   /// </summary>
   /// <remarks>
   ///    <para>O conjunto de vários sinalizadores pode produzir efeitos combinados:</para>
   ///    <para> </para>
   ///    <para>
   ///       <para>    º Quando DirectionVertical e DirectionRightToLeft são definidos, linhas</para>
   ///       <para>      individuais de texto são desenhadas verticalmente. A primeira linha</para>
   ///       <para>      começa na borda direita do retângulo de layout; a segunda linha do</para>
   ///       <para>      texto está à esquerda da primeira linha e assim por diante.</para>
   ///    </para>
   ///    <para> </para>
   ///    <para>
   ///       <para>    º Quando DirectionVertical está definido e DirectionRightToLeft não está</para>
   ///       <para>      definido, linhas individuais de texto são desenhadas verticalmente.</para>
   ///       <para>      A primeira linha começa na borda esquerda do</para>
   ///       <para>      retângulo de layout; a segunda linha do texto está à direita da primeira linha.</para>
   ///    </para>
   ///    <para> </para>
   ///    <para>
   ///       <para>    º Quando DirectionRightToLeft está definido e DirectionVertical não está</para>
   ///       <para>      definido, as linhas individuais de texto são horizontais e a ordem de leitura</para>
   ///       <para>      é da direita para a esquerda. Esta</para>
   ///       <para>      configuração não altera a ordem em que os caracteres são exibidos,</para>
   ///       <para>      ela simplesmente especifica a ordem em que</para>
   ///       <para>      os caracteres podem ser lidos.</para>
   ///    </para>
   ///    <para> </para>
   ///    <para>Os sinalizadores DirectionVertical e DirectionRightToLeft podem afetar o</para>
   ///    <para>alinhamento da string.</para>
   /// </remarks>
   TGdipStringFormatFlags = type UInt32;
   TGdipStringFormatFlagsHelper = record helper for TGdipStringFormatFlags

      /// <summary>
      ///   Especifica que a ordem de leitura é da direita para a esquerda.
      ///   Para texto horizontal, os caracteres são lidos da direita para a esquerda.
      ///   Esse valor é chamado de nível de incorporação base pelo motor bidirecional do Unicode.
      ///   Para texto vertical, as colunas são lidas da direita para a esquerda.
      ///   Por padrão, o texto horizontal ou vertical é lido da esquerda para a direita.
      /// </summary>
      public const DirectionRightToLeft = TGdiPlusAPI.TGdipStringFormatFlagsEnum.DirectionRightToLeft;

      /// <summary>
      ///   Especifica que linhas individuais de texto são desenhadas verticalmente no dispositivo de exibição.
      ///   Por padrão, as linhas de texto são horizontais, cada nova linha abaixo da linha anterior.
      /// </summary>
      public const DirectionVertical = TGdiPlusAPI.TGdipStringFormatFlagsEnum.DirectionVertical;

      /// <summary>
      ///   Especifica que partes de caracteres podem ficar salientes no retângulo de layout da cadeia de caracteres.
      ///   Por padrão, os caracteres são primeiro alinhados dentro dos limites do retângulo e, em seguida, quaisquer
      ///   caracteres que ainda ultrapassem os limites são reposicionados para evitar qualquer saliência e, assim,
      ///   evitar afetar os pixels fora do retângulo de layout. Uma letra F ( f ) minúscula e itálica é um exemplo
      ///   de caractere que pode ter partes salientes. Definir esse sinalizador garante que o caractere se alinhe
      ///   visualmente com as linhas acima e abaixo, mas pode fazer com que partes dos caracteres, que ficam fora
      ///   do retângulo do layout, sejam cortadas ou pintadas.
      ///
      /// ATENÇÃO:
      ///   O equivalente no GDI+ para isto é StringFormatFlags::StringFormatFlagsNoFitBlackBox,
      ///   que é definido como 0x4. Isso foi um erro introduzido desde a primeira versão do
      ///   produto e corrigi-lo neste ponto seria uma mudança que quebraria a compatibilidade.
      ///   <see href="https://docs.microsoft.com/en-us/windows/desktop/api/gdiplusenums/ne-gdiplusenums-stringformatflags"/>
      /// </summary>
      public const FitBlackBox = TGdiPlusAPI.TGdipStringFormatFlagsEnum.NoFitBlackBox;

      /// <summary>
      ///   Especifica que os caracteres de controle de layout Unicode são exibidos com um caractere representativo.
      /// </summary>
      public const DisplayFormatControl = TGdiPlusAPI.TGdipStringFormatFlagsEnum.DisplayFormatControl;

      /// <summary>
      ///   Especifica que uma fonte alternativa é usada para caracteres que não são suportados na fonte
      ///   solicitada. Por padrão, quaisquer caracteres ausentes são exibidos com o caractere "fontes ausentes",
      ///   geralmente um quadrado aberto.
      /// </summary>
      public const NoFontFallback = TGdiPlusAPI.TGdipStringFormatFlagsEnum.NoFontFallback;

      /// <summary>
      ///   Especifica que o espaço no final de cada linha está incluído em uma medida de string. Por padrão, o retângulo de limite retornado pelo
      ///   método TGdipGraphics.MeasureString exclui o espaço no final de cada linha. Defina este sinalizador para incluir esse espaço na medição.
      /// </summary>
      public const MeasureTrailingSpaces = TGdiPlusAPI.TGdipStringFormatFlagsEnum.MeasureTrailingSpaces;

      /// <summary>
      ///   Especifica que a quebra automática de texto para a próxima linha está desabilitada.
      ///   NoWrap está implícito quando um ponto de origem é usado em vez de um retângulo de layout.
      ///   Ao desenhar texto dentro de um retângulo, por padrão, o texto é quebrado no limite da última
      ///   palavra que está dentro do limite do retângulo e quebrado na próxima linha.
      /// </summary>
      public const NoWrap = TGdiPlusAPI.TGdipStringFormatFlagsEnum.NoWrap;

      /// <summary>
      ///   Especifica que apenas linhas inteiras são dispostas no retângulo de layout. Por padrão, o layout continua até o final do texto ou até
      ///   que nenhuma outra linha fique visível como resultado do recorte, o que ocorrer primeiro. As configurações padrão permitem que a
      ///   última linha seja parcialmente obscurecida por um retângulo de layout que não seja um múltiplo inteiro da altura da linha. Para
      ///   garantir que apenas linhas inteiras sejam vistas, defina esse sinalizador e tenha cuidado para fornecer um retângulo de layout pelo
      ///   menos tão alto quanto a altura de uma linha.
      /// </summary>
      public const LineLimit = TGdiPlusAPI.TGdipStringFormatFlagsEnum.LineLimit;

      /// <summary>
      ///   Especifica que os caracteres que se projetam do retângulo de layout e o texto que se estende para fora do retângulo de layout podem
      ///   ser exibidos. Por padrão, todos os caracteres salientes e textos que se estendem para fora do retângulo de layout são cortados.
      ///   Quaisquer espaços à direita (espaços no final de uma linha) que se estendam para fora do retângulo de layout serão cortados.
      ///   Portanto, a configuração deste sinalizador terá efeito em uma medição de string se espaços à direita estiverem sendo incluídos na
      ///   medição. Se o recorte estiver ativado, os espaços finais que se estendem para fora do retângulo de layout não serão incluídos na
      ///   medida. Se o recorte estiver desativado, todos os espaços finais serão incluídos na medida, independentemente de estarem fora do
      ///   retângulo do layout.
      /// </summary>
      public const NoClip = TGdiPlusAPI.TGdipStringFormatFlagsEnum.NoClip;
   end;


   { TGdipStringDigitSubstitute }

	/// <summary>
   ///   A enumeração <see cref="T:Se7e.Drawing.TGdipStringDigitSubstitute" /> especifica como substituir dígitos em uma cadeia de
   ///   caracteres de acordo com a localidade ou o idioma do usuário.
   /// </summary>
   TGdipStringDigitSubstitute = (

		/// <summary>
      ///   Especifica um esquema de substituição definido pelo usuário.
      /// </summary>
      User = Ord(TGdiPlusAPI.TGdipStringDigitSubstituteEnum.User),

      /// <summary>
      ///  Especifica para desabilitar substituições.
      /// </summary>
      None =  Ord(TGdiPlusAPI.TGdipStringDigitSubstituteEnum.None),

      /// <summary>
      ///   Especifica os dígitos de substituição que correspondem ao idioma nacional oficial da localidade do usuário.
      /// </summary>
      National = Ord(TGdiPlusAPI.TGdipStringDigitSubstituteEnum.National),

      /// <summary>
      ///   Especifica os dígitos de substituição que correspondem ao script ou idioma nativo do usuário, que podem
      ///   ser diferentes do idioma nacional oficial da localidade do usuário.
      /// </summary>
      Traditional =  Ord(TGdiPlusAPI.TGdipStringDigitSubstituteEnum.Traditional)
   );

   { TGdipCharacterRange }

   /// <summary>Especifica um intervalo de posições de caractere em uma cadeia de caracteres.</summary>
   TGdipCharacterRange = record

		/// <summary>Obtém ou define a posição na cadeia de caracteres do primeiro caractere deste <see cref="T:System.Drawing.CharacterRange" />.</summary>
		/// <returns>A primeira posição deste <see cref="T:System.Drawing.CharacterRange" />.</returns>
      public First  : Integer;

		/// <summary>Obtém ou define o número de posições neste <see cref="T:System.Drawing.CharacterRange" />.</summary>
		/// <returns>O número de posições neste <see cref="T:System.Drawing.CharacterRange" />.</returns>
      public Length : Integer;
   end;

	/// <summary>Especifica os estilos de extremidade disponíveis com os quais um objeto <see cref="T:System.Drawing.Pen" /> pode terminar uma linha.</summary>
	TGdipLineCap = (
		/// <summary>Especifica uma extremidade de linha reta.</summary>
		Flat = Ord(TGdiPlusAPI.TGdipLineCapEnum.Flat),
		/// <summary>Especifica uma extremidade de linha quadrada.</summary>
		Square = Ord(TGdiPlusAPI.TGdipLineCapEnum.Square),
		/// <summary>Especifica uma extremidade de linha redonda.</summary>
		Round = Ord(TGdiPlusAPI.TGdipLineCapEnum.Round),
		/// <summary>Especifica uma extremidade de linha triangular.</summary>
		Triangle = Ord(TGdiPlusAPI.TGdipLineCapEnum.Triangle),
		/// <summary>Não especifica nenhuma âncora.</summary>
		NoAnchor = Ord(TGdiPlusAPI.TGdipLineCapEnum.NoAnchor),
		/// <summary>Especifica uma extremidade de linha de âncora quadrada.</summary>
		SquareAnchor = Ord(TGdiPlusAPI.TGdipLineCapEnum.SquareAnchor),
		/// <summary>Especifica uma extremidade de âncora redonda.</summary>
		RoundAnchor = Ord(TGdiPlusAPI.TGdipLineCapEnum.RoundAnchor),
		/// <summary>Especifica uma extremidade de âncora em forma de losango.</summary>
		DiamondAnchor = Ord(TGdiPlusAPI.TGdipLineCapEnum.DiamondAnchor),
		/// <summary>Especifica uma extremidade de âncora em forma de seta.</summary>
		ArrowAnchor = Ord(TGdiPlusAPI.TGdipLineCapEnum.ArrowAnchor),
		/// <summary>Especifica uma extremidade de linha personalizada.</summary>
		Custom = Ord(TGdiPlusAPI.TGdipLineCapEnum.Custom),
		/// <summary>Especifica uma máscara usada para verificar se uma extremidade de linha é uma extremidade de âncora.</summary>
		AnchorMask = Ord(TGdiPlusAPI.TGdipLineCapEnum.AnchorMask)
	);


   { TGdipCustomLineCapType }

    (**
     * Various custom line cap types
     *)

   TGdipCustomLineCapType = (
         Default = Ord(TGdiPlusAPI.TGdipCustomLineCapTypeEnum.Default),
         AdjustableArrowCap = Ord(TGdiPlusAPI.TGdipCustomLineCapTypeEnum.Default)
   );

	/// <summary>Especifica o estilo das linhas tracejadas desenhadas com um objeto <see cref="T:System.Drawing.Pen" />.</summary>
	TGdipDashStyle = (
		/// <summary>Especifica uma linha sólida.</summary>
		Solid = Ord(TGdiPlusAPI.TGdipDashStyleEnum.Solid),
		/// <summary>Especifica uma linha composta por traços.</summary>
		Dash = Ord(TGdiPlusAPI.TGdipDashStyleEnum.Dash),
		/// <summary>Especifica uma linha composta por pontos.</summary>
		Dot = Ord(TGdiPlusAPI.TGdipDashStyleEnum.Dot),
		/// <summary>Especifica uma linha composta por um padrão de repetição de traço-ponto.</summary>
		DashDot = Ord(TGdiPlusAPI.TGdipDashStyleEnum.DashDot),
		/// <summary>Especifica uma linha composta por um padrão de repetição de traço-ponto-ponto.</summary>
		DashDotDot = Ord(TGdiPlusAPI.TGdipDashStyleEnum.DashDotDot),
		/// <summary>Especifica um estilo de traço personalizado definido pelo usuário.</summary>
		Custom = Ord(TGdiPlusAPI.TGdipDashStyleEnum.Custom)
   );


	/// <summary>
   ///   Especifica o tipo de preenchimento que um objeto <see cref="T:System.Drawing.Pen" />
   ///   usa para preencher linhas.
   /// </summary>
	TGdipPenType = (

		/// <summary>
      ///   Especifica um preenchimento sólido.
      /// </summary>
		SolidColor = Ord(TGdiPlusAPI.TGdipPenTypeEnum.SolidColor),

		/// <summary>
      ///   Especifica um preenchimento hachurado.
      /// </summary>
		HatchFill = Ord(TGdiPlusAPI.TGdipPenTypeEnum.HatchFill),

		/// <summary>
      ///   Especifica um preenchimento de textura de bitmap.
      /// </summary>
		TextureFill = Ord(TGdiPlusAPI.TGdipPenTypeEnum.TextureFill),

		/// <summary>
      ///   Especifica um preenchimento de gradiente de caminho.
      /// </summary>
		PathGradient = Ord(TGdiPlusAPI.TGdipPenTypeEnum.PathGradient),

		/// <summary>
      ///   Especifica um preenchimento de gradiente linear.
      /// </summary>
		LinearGradient = Ord(TGdiPlusAPI.TGdipPenTypeEnum.LinearGradient)
   );


	/// <summary>
   ///   Especifica o alinhamento de um objeto <see cref="T:System.Drawing.Pen" /> em
   ///   relação à linha teórica de largura zero.
   /// </summary>
	TGdipPenAlignment = (

		/// <summary>
      ///   Especifica que o objeto <see cref="T:System.Drawing.Pen" /> está centralizado sobre a linha teórica.
      /// </summary>
		Center = Ord(TGdiPlusAPI.TGdipPenAlignmentEnum.Center),

		/// <summary>
      ///   Especifica que o <see cref="T:System.Drawing.Pen" /> está posicionado dentro da linha teórica.
      /// </summary>
		Inset = Ord(TGdiPlusAPI.TGdipPenAlignmentEnum.Inset),

		/// <summary>
      ///   Especifica que o <see cref="T:System.Drawing.Pen" /> está posicionado fora da linha teórica.
      /// </summary>
		Outset = 2,

		/// <summary>
      ///   Especifica que o <see cref="T:System.Drawing.Pen" /> está posicionado à esquerda da linha teórica.
      /// </summary>
		Left = 3,

		/// <summary>
      ///   Especifica que o <see cref="T:System.Drawing.Pen" /> está posicionado à direita da linha teórica.
      /// </summary>
		Right = 4
   );


   /// <summary>
   ///   Especifica como unir segmentos de linha ou curva consecutivos em uma figura (subcaminho)
   ///   contida em um objeto <see cref="T:System.Drawing.Drawing2D.GraphicsPath" />.
   /// </summary>
   TGdipLineJoin = (

      /// <summary>
      ///   Especifica uma junção de malhete. Isso produz um canto agudo ou um canto recortado,
      ///   dependendo se o tamanho do malhete excede o limite de malhete.
      /// </summary>
      Miter = Ord(TGdiPlusAPI.TGdipLineJoinEnum.Miter),

      /// <summary>
      ///   Especifica uma junção de bisel. Isso produz um canto diagonal.
      /// </summary>
      Bevel = Ord(TGdiPlusAPI.TGdipLineJoinEnum.Bevel),

      /// <summary>
      ///   Especifica uma junção circular. Isso produz um arco circular e suave entre as linhas.
      /// </summary>
      Round = Ord(TGdiPlusAPI.TGdipLineJoinEnum.Round),

      /// <summary>
      ///   Especifica uma junção de malhete. Isso produz um canto agudo ou um canto de bisel,
      ///   dependendo se o tamanho do malhete excede o limite de malhete.
      /// </summary>
      MiterClipped = Ord(TGdiPlusAPI.TGdipLineJoinEnum.MiterClipped)
   );


   { TGdipLinearGradientMode }

	/// <summary>
   ///   Especifica a direção de um gradiente linear.
   /// </summary>
	TGdipLinearGradientMode = (
		/// <summary>Especifica um gradiente da esquerda para a direita.</summary>
		Horizontal = Ord(TGdiPlusAPI.TGdipLinearGradientModeEnum.Horizontal),
		/// <summary>Especifica um gradiente de cima para baixo.</summary>
		Vertical = Ord(TGdiPlusAPI.TGdipLinearGradientModeEnum.Vertical),
		/// <summary>Especifica um gradiente da esquerda superior para a direita inferior.</summary>
		ForwardDiagonal = Ord(TGdiPlusAPI.TGdipLinearGradientModeEnum.ForwardDiagonal),
		/// <summary>Especifica um gradiente da direita superior para a esquerda inferior.</summary>
		BackwardDiagonal = Ord(TGdiPlusAPI.TGdipLinearGradientModeEnum.BackwardDiagonal)
   );



   { TGdipColorAdjustType }

   /// <summary>
   /// Especifica quais objetos GDI+ usam informações de ajuste de cor.
   /// </summary>
   TGdipColorAdjustType = (
      /// <summary>
      /// Define informações de ajuste de cor que são usadas por todos os objetos GDI+ que não possuem suas próprias informações
      /// de ajuste de cor.
      /// </summary>
      Default = Ord(TGdiPlusAPI.TGdipColorAdjustTypeEnum.Default),

      /// <summary>
      /// Define informações de ajuste de cor para objetos <see cref='Drawing.Bitmap'/>.
      /// </summary>
      Bitmap = Ord(TGdiPlusAPI.TGdipColorAdjustTypeEnum.Bitmap),

      /// <summary>
      /// Define informações de ajuste de cor para objetos <see cref='Drawing.Brush'/>.
      /// </summary>
      Brush = Ord(TGdiPlusAPI.TGdipColorAdjustTypeEnum.Brush),

      /// <summary>
      /// Define informações de ajuste de cor para objetos <see cref='Drawing.Pen'/>.
      /// </summary>
      Pen = Ord(TGdiPlusAPI.TGdipColorAdjustTypeEnum.Pen),

      /// <summary>
      /// Define informações de ajuste de cor para texto.
      /// </summary>
      Text = Ord(TGdiPlusAPI.TGdipColorAdjustTypeEnum.Text),

      /// <summary>
      /// Especifica o número de tipos especificados.
      /// </summary>
      Count = Ord(TGdiPlusAPI.TGdipColorAdjustTypeEnum.Count),

      /// <summary>
      /// Especifica o número de tipos especificados.
      /// </summary>
      Any = Ord(TGdiPlusAPI.TGdipColorAdjustTypeEnum.Any)
   );


   { TGdipColorMatrixFlag }

   /// <summary>
   /// Especifica as opções disponíveis para ajuste de cor. GDI+ pode ajustar apenas dados de cor, apenas dados em escala de cinza, ou ambos.
   /// </summary>
   TGdipColorMatrixFlag = (

      /// <summary>
      /// Tanto cores quanto escalas de cinza são ajustadas.
      /// </summary>
      Default = Ord(TGdiPlusAPI.TGdipColorMatrixFlagEnum.Default),

      /// <summary>
      /// Valores em escala de cinza não são ajustados.
      /// </summary>
      SkipGrays = Ord(TGdiPlusAPI.TGdipColorMatrixFlagEnum.SkipGrays),

      /// <summary>
      /// Apenas valores em escala de cinza são ajustados.
      /// </summary>
      AltGrays = Ord(TGdiPlusAPI.TGdipColorMatrixFlagEnum.AltGray)
   );


	/// <summary>Especifica os diferentes padrões disponíveis para objetos <see cref="T:System.Drawing.Drawing2D.HatchBrush" />.</summary>
	TGdipHatchStyle = (
		/// <summary>Um padrão de linhas horizontais.</summary>
		Horizontal = Ord(TGdiPlusAPI.TGdipHatchStyleEnum.Horizontal),
		/// <summary>Um padrão de linhas verticais.</summary>
		Vertical = Ord(TGdiPlusAPI.TGdipHatchStyleEnum.Vertical),
		/// <summary>Um padrão de linhas em uma diagonal do canto superior esquerdo para o canto inferior direito.</summary>
		ForwardDiagonal = Ord(TGdiPlusAPI.TGdipHatchStyleEnum.ForwardDiagonal),
		/// <summary>Um padrão de linhas em uma diagonal do canto superior direito para o canto inferior esquerdo.</summary>
		BackwardDiagonal = Ord(TGdiPlusAPI.TGdipHatchStyleEnum.BackwardDiagonal),
		/// <summary>Especifica linhas horizontais e verticais que se cruzam.</summary>
		Cross = Ord(TGdiPlusAPI.TGdipHatchStyleEnum.Cross),
		/// <summary>Um padrão de linhas diagonais xadrez.</summary>
		DiagonalCross = Ord(TGdiPlusAPI.TGdipHatchStyleEnum.DiagonalCross),
		/// <summary>Especifica uma hachura de 5 por cento. A proporção da cor de primeiro plano para a cor da tela de fundo é 5:95.</summary>
		Percent05 = Ord(TGdiPlusAPI.TGdipHatchStyleEnum.Percent05),
		/// <summary>Especifica uma hachura de 10 por cento. A proporção da cor de primeiro plano para a cor da tela de fundo é 10:90.</summary>
		Percent10 = Ord(TGdiPlusAPI.TGdipHatchStyleEnum.Percent10),
		/// <summary>Especifica uma hachura de 20 por cento. A proporção da cor de primeiro plano para a cor da tela de fundo é 20:80.</summary>
		Percent20 = Ord(TGdiPlusAPI.TGdipHatchStyleEnum.Percent20),
		/// <summary>Especifica uma hachura de 25 por cento. A proporção da cor de primeiro plano para a cor da tela de fundo é 25:75.</summary>
		Percent25 = Ord(TGdiPlusAPI.TGdipHatchStyleEnum.Percent25),
		/// <summary>Especifica uma hachura de 30 por cento. A proporção da cor de primeiro plano para a cor da tela de fundo é 30:70.</summary>
		Percent30 = Ord(TGdiPlusAPI.TGdipHatchStyleEnum.Percent30),
		/// <summary>Especifica uma hachura de 40 por cento. A proporção da cor de primeiro plano para a cor da tela de fundo é 40:60.</summary>
		Percent40 = Ord(TGdiPlusAPI.TGdipHatchStyleEnum.Percent40),
		/// <summary>Especifica uma hachura de 50 por cento. A proporção da cor de primeiro plano para a cor da tela de fundo é 50:50.</summary>
		Percent50 = Ord(TGdiPlusAPI.TGdipHatchStyleEnum.Percent50),
		/// <summary>Especifica uma hachura de 60 por cento. A proporção da cor de primeiro plano para a cor da tela de fundo é 60:40.</summary>
		Percent60 = Ord(TGdiPlusAPI.TGdipHatchStyleEnum.Percent60),
		/// <summary>Especifica uma hachura de 70 por cento. A proporção da cor de primeiro plano para a cor da tela de fundo é 70:30.</summary>
		Percent70 = Ord(TGdiPlusAPI.TGdipHatchStyleEnum.Percent70),
		/// <summary>Especifica uma hachura de 75 por cento. A proporção da cor de primeiro plano para a cor da tela de fundo é 75:25.</summary>
		Percent75 = Ord(TGdiPlusAPI.TGdipHatchStyleEnum.Percent75),
		/// <summary>Especifica uma hachura de 80 por cento. A proporção da cor de primeiro plano para a cor da tela de fundo é 80:100.</summary>
		Percent80 = Ord(TGdiPlusAPI.TGdipHatchStyleEnum.Percent80),
		/// <summary>Especifica uma hachura de 90 por cento. A proporção da cor de primeiro plano para a cor da tela de fundo é 90:10.</summary>
		Percent90 = Ord(TGdiPlusAPI.TGdipHatchStyleEnum.Percent90),
		/// <summary>Especifica linhas diagonais que se inclinam para a direita dos pontos superiores em direção aos inferiores e com espaçamento 50% mais próximo do que <see cref="F:System.Drawing.Drawing2D.HatchStyle.ForwardDiagonal" />, mas que não são suavizadas.</summary>
		LightDownwardDiagonal = Ord(TGdiPlusAPI.TGdipHatchStyleEnum.LightDownwardDiagonal),
		/// <summary>Especifica linhas diagonais que se inclinam para a esquerda dos pontos superiores em direção aos inferiores e com espaçamento 50% mais próximo do que <see cref="F:System.Drawing.Drawing2D.HatchStyle.BackwardDiagonal" />, mas elas não são suavizadas.</summary>
		LightUpwardDiagonal = Ord(TGdiPlusAPI.TGdipHatchStyleEnum.LightUpwardDiagonal),
		/// <summary>Especifica linhas diagonais que se inclinam para a direita dos pontos superiores em direção aos inferiores, com espaçamento 50% mais próximo do que <see cref="F:System.Drawing.Drawing2D.HatchStyle.ForwardDiagonal" /> e com o dobro da sua largura. Esse padrão de hachura não é suavizado.</summary>
		DarkDownwardDiagonal = Ord(TGdiPlusAPI.TGdipHatchStyleEnum.DarkDownwardDiagonal),
		/// <summary>Especifica linhas diagonais que se inclinam para a esquerda dos pontos superiores em direção aos inferiores, com espaçamento 50% mais próximo do que <see cref="F:System.Drawing.Drawing2D.HatchStyle.BackwardDiagonal" /> e com o dobro da sua largura, mas as linhas não são suavizadas.</summary>
		DarkUpwardDiagonal = Ord(TGdiPlusAPI.TGdipHatchStyleEnum.DarkUpwardDiagonal),
		/// <summary>Especifica linhas diagonais que se inclinam para a direita dos pontos superiores em direção aos inferiores, com o mesmo espaçamento que o estilo de hachura <see cref="F:System.Drawing.Drawing2D.HatchStyle.ForwardDiagonal" /> e com o triplo da sua largura, mas não são suavizadas.</summary>
		WideDownwardDiagonal = Ord(TGdiPlusAPI.TGdipHatchStyleEnum.WideDownwardDiagonal),
		/// <summary>Especifica linhas diagonais que se inclinam para a esquerda dos pontos superiores em direção aos inferiores, com o mesmo espaçamento que o estilo de hachura <see cref="F:System.Drawing.Drawing2D.HatchStyle.BackwardDiagonal" /> e com o triplo da sua largura, mas não são suavizadas.</summary>
		WideUpwardDiagonal = Ord(TGdiPlusAPI.TGdipHatchStyleEnum.WideUpwardDiagonal),
		/// <summary>Especifica as linhas verticais com espaçamento 50 por cento mais próximo do que <see cref="F:System.Drawing.Drawing2D.HatchStyle.Vertical" />.</summary>
		LightVertical = Ord(TGdiPlusAPI.TGdipHatchStyleEnum.LightVertical),
		/// <summary>Especifica as linhas horizontais com espaçamento 50 por cento mais próximo do que <see cref="F:System.Drawing.Drawing2D.HatchStyle.Horizontal" />.</summary>
		LightHorizontal = Ord(TGdiPlusAPI.TGdipHatchStyleEnum.LightHorizontal),
		/// <summary>Especifica linhas verticais com espaçamento 75% mais próximo do que o estilo de hachura <see cref="F:System.Drawing.Drawing2D.HatchStyle.Vertical" /> (ou 25% mais próximo do que <see cref="F:System.Drawing.Drawing2D.HatchStyle.LightVertical" />).</summary>
		NarrowVertical = Ord(TGdiPlusAPI.TGdipHatchStyleEnum.NarrowVertical),
		/// <summary>Especifica linhas horizontais com espaçamento 75% mais próximo do que o estilo de hachura <see cref="F:System.Drawing.Drawing2D.HatchStyle.Horizontal" /> (ou 25% mais próximo do que <see cref="F:System.Drawing.Drawing2D.HatchStyle.LightHorizontal" />).</summary>
		NarrowHorizontal = Ord(TGdiPlusAPI.TGdipHatchStyleEnum.NarrowHorizontal),
		/// <summary>Especifica as linhas verticais com espaçamento 50 por cento mais próximo do que <see cref="F:System.Drawing.Drawing2D.HatchStyle.Vertical" /> e com o dobro da sua largura.</summary>
		DarkVertical = Ord(TGdiPlusAPI.TGdipHatchStyleEnum.DarkVertical),
		/// <summary>Especifica as linhas horizontais com espaçamento 50 por cento mais próximo do que <see cref="F:System.Drawing.Drawing2D.HatchStyle.Horizontal" /> e com o dobro da largura de <see cref="F:System.Drawing.Drawing2D.HatchStyle.Horizontal" />.</summary>
		DarkHorizontal = Ord(TGdiPlusAPI.TGdipHatchStyleEnum.DarkHorizontal),
		/// <summary>Especifica linhas diagonais tracejadas que se inclinam para a direita dos pontos superiores em direção aos inferiores.</summary>
		DashedDownwardDiagonal = Ord(TGdiPlusAPI.TGdipHatchStyleEnum.DashedDownwardDiagonal),
		/// <summary>Especifica linhas diagonais tracejadas que se inclinam para a esquerda dos pontos superiores em direção aos inferiores.</summary>
		DashedUpwardDiagonal = Ord(TGdiPlusAPI.TGdipHatchStyleEnum.DashedUpwardDiagonal),
		/// <summary>Especifica linhas horizontais tracejadas.</summary>
		DashedHorizontal = Ord(TGdiPlusAPI.TGdipHatchStyleEnum.DarkHorizontal),
		/// <summary>Especifica linhas verticais tracejadas.</summary>
		DashedVertical = Ord(TGdiPlusAPI.TGdipHatchStyleEnum.DashedVertical),
		/// <summary>Especifica uma hachura que tem a aparência de confetes.</summary>
		SmallConfetti = Ord(TGdiPlusAPI.TGdipHatchStyleEnum.SmallConfetti),
		/// <summary>Especifica uma hachura com a aparência de confetes e composta por partes maiores do que <see cref="F:System.Drawing.Drawing2D.HatchStyle.SmallConfetti" />.</summary>
		LargeConfetti = Ord(TGdiPlusAPI.TGdipHatchStyleEnum.LargeConfetti),
		/// <summary>Especifica linhas horizontais compostas por zigue-zagues.</summary>
		ZigZag = Ord(TGdiPlusAPI.TGdipHatchStyleEnum.ZigZag),
		/// <summary>Especifica linhas horizontais compostas por sinais de til.</summary>
		Wave = Ord(TGdiPlusAPI.TGdipHatchStyleEnum.Wave),
		/// <summary>Especifica uma hachura com aparência camadas de tijolos que se inclina para esquerda dos pontos superiores em direção aos inferiores.</summary>
		DiagonalBrick = Ord(TGdiPlusAPI.TGdipHatchStyleEnum.DiagonalBrick),
		/// <summary>Especifica uma hachura que tem a aparência de tijolos sobrepostos horizontalmente.</summary>
		HorizontalBrick = Ord(TGdiPlusAPI.TGdipHatchStyleEnum.HorizontalBrick),
		/// <summary>Especifica uma hachura que tem a aparência de um material entrelaçado.</summary>
		Weave = Ord(TGdiPlusAPI.TGdipHatchStyleEnum.Weave),
		/// <summary>Especifica uma hachura que tem a aparência de um material xadrez.</summary>
		Plaid = Ord(TGdiPlusAPI.TGdipHatchStyleEnum.Plaid),
		/// <summary>Especifica uma hachura que tem a aparência de malhas.</summary>
		Divot = Ord(TGdiPlusAPI.TGdipHatchStyleEnum.Divot),
		/// <summary>Especifica linhas horizontais e verticais, cada qual composta por pontos que se cruzam.</summary>
		DottedGrid = Ord(TGdiPlusAPI.TGdipHatchStyleEnum.DottedGrid),
		/// <summary>Especifica linhas diagonais para frente e para trás, cada qual composta por pontos que se cruzam.</summary>
		DottedDiamond = Ord(TGdiPlusAPI.TGdipHatchStyleEnum.DottedDiamond),
		/// <summary>Especifica uma hachura com aparência de camadas de telhas diagonais que se inclinam para a direita dos pontos superiores em direção aos inferiores.</summary>
		Shingle = Ord(TGdiPlusAPI.TGdipHatchStyleEnum.Shingle),
		/// <summary>Especifica uma hachura com a aparência de uma treliça.</summary>
		Trellis = Ord(TGdiPlusAPI.TGdipHatchStyleEnum.Trellis),
		/// <summary>Especifica uma hachura com aparência de esferas dispostas adjacentes umas às outras.</summary>
		Sphere = Ord(TGdiPlusAPI.TGdipHatchStyleEnum.Sphere),
		/// <summary>Especifica linhas horizontais e verticais que se cruzam com espaçamento 50% mais próximo do que o estilo de hachura <see cref="F:System.Drawing.Drawing2D.HatchStyle.Cross" />.</summary>
		SmallGrid = Ord(TGdiPlusAPI.TGdipHatchStyleEnum.SmallGrid),
		/// <summary>Especifica uma hachura com a aparência de quadriculado.</summary>
		SmallCheckerBoard = Ord(TGdiPlusAPI.TGdipHatchStyleEnum.SmallCheckerBoard),
		/// <summary>Especifica uma hachura com aparência de quadriculado, com quadrados com o dobro do tamanho de <see cref="F:System.Drawing.Drawing2D.HatchStyle.SmallCheckerBoard" />.</summary>
		LargeCheckerBoard = Ord(TGdiPlusAPI.TGdipHatchStyleEnum.LargeCheckerBoard),
		/// <summary>Especifica linhas diagonais para frente e para trás que se cruzam, mas não são suavizadas.</summary>
		OutlinedDiamond = Ord(TGdiPlusAPI.TGdipHatchStyleEnum.OutlinedDiamond),
		/// <summary>Especifica uma hachura com a aparência de quadriculado posicionado diagonalmente.</summary>
		SolidDiamond = Ord(TGdiPlusAPI.TGdipHatchStyleEnum.SolidDiamond),
		/// <summary>Especifica o estilo de hachura <see cref="F:System.Drawing.Drawing2D.HatchStyle.Cross" />.</summary>
		LargeGrid = Ord(TGdiPlusAPI.TGdipHatchStyleEnum.Cross),
		/// <summary>Especifica o estilo de hachura <see cref="F:System.Drawing.Drawing2D.HatchStyle.Horizontal" />.</summary>
		Min = Ord(TGdiPlusAPI.TGdipHatchStyleEnum.Horizontal),
		/// <summary>Especifica o estilo de hachura <see cref="F:System.Drawing.Drawing2D.HatchStyle.SolidDiamond" />.</summary>
	        Max = Ord(TGdiPlusAPI.TGdipHatchStyleEnum.Cross)
   );


	/// <summary>
   ///   Especifica o tipo de forma do grafo a ser usada nas duas extremidades de cada traço na linha tracejada.
   /// </summary>
	TGdipDashCap = (

		/// <summary>
      ///   Especifica um limite quadrado que alinha as duas extremidades de cada traço.
      /// </summary>
		Flat = Ord(TGdiPlusAPI.TGdipDashCapEnum.Flat),

		/// <summary>
      ///   Especifica um limite circular que arredonda as duas extremidades de cada traço.
      /// </summary>
		Round = Ord(TGdiPlusAPI.TGdipDashCapEnum.Round),

		/// <summary>
      ///   Especifica um limite triangular que salienta as duas extremidades de cada traço.
      /// </summary>
		Triangle = Ord(TGdiPlusAPI.TGdipDashCapEnum.Triangle)
   );

   { TGdipWrapMode }

	/// <summary>Especifica como uma textura ou gradiente será organizado lado a lado quando for menor que a área sendo preenchida.</summary>
	TGdipWrapMode = (
		/// <summary>Organiza lado a lado o gradiente ou a textura.</summary>
		Tile = Ord(TGdiPlusAPI.TGdipWrapModeEnum.Tile),
		/// <summary>Inverte a textura ou o gradiente horizontalmente e, em seguida, organiza lado a lado a textura ou o gradiente.</summary>
		TileFlipX = Ord(TGdiPlusAPI.TGdipWrapModeEnum.TileFlipX),
		/// <summary>Inverte a textura ou o gradiente verticalmente e, em seguida, organiza lado a lado a textura ou o gradiente.</summary>
		TileFlipY = Ord(TGdiPlusAPI.TGdipWrapModeEnum.TileFlipY),
		/// <summary>Inverte a textura ou o gradiente horizontal e verticalmente e, em seguida, organiza lado a lado a textura ou o gradiente.</summary>
		TileFlipXY = Ord(TGdiPlusAPI.TGdipWrapModeEnum.TileFlipXY),
		/// <summary>A textura ou o gradiente não está organizado lado a lado.</summary>
		Clamp = Ord(TGdiPlusAPI.TGdipWrapModeEnum.Clamp)
	);

   { TGdipPixelFormat }

	/// <summary>Especifica o formato dos dados de cor para cada pixel da imagem.</summary>
	TGdipPixelFormat = (
		/// <summary>Os dados de pixel contêm valores indexados por cores, o que significa que os valores são um índice de cores na tabela de cores do sistema, em vez de valores de cores individuais.</summary>
		Indexed = TGdiPlusAPI.PixelFormatIndexed,
		/// <summary>Os dados de pixel contêm cores GDI.</summary>
		Gdi = Ord(TGdiPlusAPI.PixelFormatGdi),
		/// <summary>Os dados de pixel contêm valores alfa que não são pré-multiplicados.</summary>
		Alpha = Ord(TGdiPlusAPI.PixelFormatAlpha),
		/// <summary>O formato de pixel contém valores alfa pré-multiplicados.</summary>
		PAlpha = Ord(TGdiPlusAPI.PixelFormatPAlpha),
		/// <summary>Reservado.</summary>
		Extended = Ord(TGdiPlusAPI.PixelFormatExtended),
		/// <summary>O formato de pixel padrão de 32 bits por pixel. O formato especifica a intensidade de cor de 24 bits e um canal alfa de 8 bits.</summary>
		Canonical = Ord(TGdiPlusAPI.PixelFormatCanonical),
		/// <summary>O formato de pixel é indefinido.</summary>
		Undefined = Ord(TGdiPlusAPI.PixelFormatUndefined),
		/// <summary>Nenhum formato de pixel foi especificado.</summary>
		DontCare = Ord(TGdiPlusAPI.PixelFormatDontCare),
		/// <summary>Especifica o formato de pixel é 1 bit por pixel e que ele usa cores indexadas. Portanto, a tabela de cores tem duas cores.</summary>
		Format1bppIndexed = Ord(TGdiPlusAPI.PixelFormat1bppIndexed),
		/// <summary>Especifica que o formato é 4 bits por pixel, indexado.</summary>
		Format4bppIndexed = Ord(TGdiPlusAPI.PixelFormat4bppIndexed),
		/// <summary>Especifica que o formato é 8 bits por pixel, indexado. Portanto, a tabela de cores tem 256 cores.</summary>
		Format8bppIndexed = Ord(TGdiPlusAPI.PixelFormat8bppIndexed),
		/// <summary>O formato de pixel é de 16 bits por pixel. As informações de cores especificam 65.536 tons de cinza.</summary>
		Format16bppGrayScale = Ord(TGdiPlusAPI.PixelFormat16bppGrayScale),
		/// <summary>Especifica que o formato é 16 bits por pixel; 5 bits são usados para os componentes vermelho, verde e azul. Os bits restantes não são usados.</summary>
		Format16bppRgb555 = Ord(TGdiPlusAPI.PixelFormat16bppRgb555),
		/// <summary>Especifica que o formato é 16 bits por pixel; 5 bits são usados para o componente vermelho, 6 bits são usados para o componente verde e 5 bits são usados para o componente azul.</summary>
		Format16bppRgb565 = Ord(TGdiPlusAPI.PixelFormat16bppRgb565),
		/// <summary>O formato de pixel é de 16 bits por pixel. As informações de cores especificam 32.768 tons de cores, dos quais 5 bits são vermelhos, 5 bits são verdes, 5 bits são azuis e 1 bit é alfa.</summary>
		Format16bppArgb1555 = Ord(TGdiPlusAPI.PixelFormat16bppArgb1555),
		/// <summary>Especifica que o formato é 24 bits por pixel; 8 bits são usados para os componentes vermelho, verde e azul.</summary>
		Format24bppRgb = Ord(TGdiPlusAPI.PixelFormat24bppRgb),
		/// <summary>Especifica que o formato é 32 bits por pixel; 8 bits são usados para os componentes vermelho, verde e azul. Os 8 bits restantes não são usados.</summary>
		Format32bppRgb = Ord(TGdiPlusAPI.PixelFormat32bppRgb),
		/// <summary>Especifica que o formato é 32 bits por pixel; 8 bits são usados para os componentes alfa, vermelho, verde e azul.</summary>
		Format32bppArgb = Ord(TGdiPlusAPI.PixelFormat32bppArgb),
		/// <summary>Especifica que o formato é 32 bits por pixel; 8 bits são usados para os componentes alfa, vermelho, verde e azul. Os componentes vermelho, verde e azul são pré-multiplicados de acordo com o componente alfa.</summary>
		Format32bppPArgb = Ord(TGdiPlusAPI.PixelFormat32bppPArgb),
		/// <summary>Especifica que o formato é 48 bits por pixel; 16 bits são usados para os componentes vermelho, verde e azul.</summary>
		Format48bppRgb = Ord(TGdiPlusAPI.PixelFormat48bppRgb),
		/// <summary>Especifica que o formato é 64 bits por pixel; 16 bits são usados para os componentes alfa, vermelho, verde e azul.</summary>
		Format64bppArgb = Ord(TGdiPlusAPI.PixelFormat64bppArgb),
		/// <summary>Especifica que o formato é 64 bits por pixel; 16 bits são usados para os componentes alfa, vermelho, verde e azul. Os componentes vermelho, verde e azul são pré-multiplicados de acordo com o componente alfa.</summary>
		Format64bppPArgb = Ord(TGdiPlusAPI.PixelFormat64bppPArgb),
		/// <summary>O valor máximo dessa enumeração.</summary>
		Max =  Ord(TGdiPlusAPI.PixelFormatMax)
   );

   { TGdipPaletteType }

   /// <summary>
   /// Tipos de paleta de cores.
   /// </summary>
   TGdipPaletteType = (

      /// <summary>
      /// Uma paleta personalizada arbitrária especificada pelo chamador.
      /// </summary>
      Custom = Ord(TGdiPlusAPI.TGdipPaletteTypeEnum.Custom),

      /// <summary>
      /// Uma paleta personalizada arbitrária especificada pelo chamador.
      /// </summary>
      Optimal = Ord(TGdiPlusAPI.TGdipPaletteTypeEnum.Optimal),

      /// <summary>
      /// Uma paleta que tem duas cores. Este tipo de paleta é adequado para bitmaps que armazenam 1 bit por pixel.
      /// </summary>
      FixedBW = Ord(TGdiPlusAPI.TGdipPaletteTypeEnum.FixedBW),

      /// <summary>
      /// Uma paleta baseada em duas intensidades cada (desligado ou total) para os canais vermelho, verde e azul. Contém também as
      /// 16 cores da paleta do sistema. Como todas as oito combinações de ligado/desligado de vermelho, verde e azul já estão
      /// na paleta do sistema, esta paleta é a mesma que a paleta do sistema. Este tipo de paleta é adequado
      /// para bitmaps que armazenam 4 bits por pixel.
      /// </summary>
      FixedHalftone8 = Ord(TGdiPlusAPI.TGdipPaletteTypeEnum.FixedHalftone8),

      /// <summary>
      /// Uma paleta baseada em três intensidades cada para os canais vermelho, verde e azul. Contém também as 16 cores da
      /// paleta do sistema. Oito das 16 cores da paleta do sistema estão entre as 27 combinações de três intensidades de vermelho,
      /// verde e azul, então o número total de cores na paleta é 35. Se a paleta também inclui a cor transparente,
      /// o número total de cores é 36.
      /// </summary>
      FixedHalftone27 = Ord(TGdiPlusAPI.TGdipPaletteTypeEnum.FixedHalftone27),

      /// <summary>
      /// Uma paleta baseada em quatro intensidades cada para os canais vermelho, verde e azul. Contém também as 16 cores da
      /// paleta do sistema. Oito das 16 cores da paleta do sistema estão entre as 64 combinações de quatro intensidades de vermelho,
      /// verde e azul, então o número total de cores na paleta é 72. Se a paleta também inclui a cor transparente,
      /// o número total de cores é 73.
      /// </summary>
      FixedHalftone64 = Ord(TGdiPlusAPI.TGdipPaletteTypeEnum.FixedHalftone64),

      /// <summary>
      /// Uma paleta baseada em cinco intensidades cada para os canais vermelho, verde e azul. Contém também as 16 cores da
      /// paleta do sistema. Oito das 16 cores da paleta do sistema estão entre as 125 combinações de cinco intensidades de vermelho,
      /// verde e azul, então o número total de cores na paleta é 133. Se a paleta também inclui a cor transparente,
      /// o número total de cores é 134.
      /// </summary>
      FixedHalftone125 = Ord(TGdiPlusAPI.TGdipPaletteTypeEnum.FixedHalftone125),

      /// <summary>
      /// Uma paleta baseada em seis intensidades cada para os canais vermelho, verde e azul. Contém também as 16 cores da
      /// paleta do sistema. Oito das 16 cores da paleta do sistema estão entre as 216 combinações de seis intensidades de vermelho,
      /// verde e azul, então o número total de cores na paleta é 224. Se a paleta também inclui a cor transparente,
      /// o número total de cores é 225. Esta paleta é às vezes chamada de paleta de meio-tom do Windows ou
      /// paleta da Web.
      /// </summary>
      FixedHalftone216 = Ord(TGdiPlusAPI.TGdipPaletteTypeEnum.FixedHalftone216),

      /// <summary>
      /// Uma paleta baseada em 6 intensidades de vermelho, 7 intensidades de verde e 6 intensidades de azul. A paleta do sistema
      /// não está incluída. O número total de cores é 252. Se a paleta também inclui a cor transparente, o
      /// número total de cores é 253.
      /// </summary>
      FixedHalftone252 = Ord(TGdiPlusAPI.TGdipPaletteTypeEnum.FixedHalftone252),

      /// <summary>
      /// Uma paleta baseada em 8 intensidades de vermelho, 8 intensidades de verde e 4 intensidades de azul. A paleta do sistema
      /// não está incluída. O número total de cores é 256. Se a cor transparente está incluída nesta paleta, ela
      /// deve substituir uma das combinações RGB.
      /// </summary>
      FixedHalftone256 = Ord(TGdiPlusAPI.TGdipPaletteTypeEnum.FixedHalftone256)
   );

   { TGdipCopyPixelOperation }

   /// <summary>
   /// Especifica a operação de Cópia de Pixel (ROP).
   /// </summary>
   TGdipCopyPixelOperation = (
      /// <summary>
      /// Preenche o Retângulo de Destino usando a cor associada com o índice 0 na paleta física.
      /// </summary>
      Blackness = Winapi.Windows.BLACKNESS,

      /// <summary>
      /// Inclui quaisquer janelas que estejam Camadas no Topo.
      /// </summary>
      CaptureBlt = $40000000,

      DestinationInvert = Winapi.Windows.DSTINVERT,

      MergeCopy = Winapi.Windows.MERGECOPY,

      MergePaint = Winapi.Windows.MERGEPAINT,

      NoMirrorBitmap = Int32($80000000),

      NotSourceCopy = Winapi.Windows.NOTSRCCOPY,

      NotSourceErase = Winapi.Windows.NOTSRCERASE,

      PatCopy = Winapi.Windows.PATCOPY,

      PatInvert = Winapi.Windows.PATINVERT,

      PatPaint = Winapi.Windows.PATPAINT,

      SourceAnd = Winapi.Windows.SRCAND,

      SourceCopy = Winapi.Windows.SRCCOPY,

      SourceErase = Winapi.Windows.SRCERASE,

      SourceInvert = Winapi.Windows.SRCINVERT,

      SourcePaint = Winapi.Windows.SRCPAINT,

      Whiteness = Winapi.Windows.WHITENESS
   );

	/// <summary>
   ///   Usado para especificar o tipo de dados do <see cref="T:TGdipEncoderParameter" />
   ///   usado com o método <see cref="Overload:System.Drawing.Image.Save" /> ou <see cref="Overload:System.Drawing.Image.SaveAdd" /> de uma imagem.
   /// </summary>
	TGdipEncoderParameterValueType = (

		/// <summary>
      ///   Especifica que cada valor na matriz é um inteiro sem sinal de 8 bits.
      /// </summary>
		ValueTypeByte = 1,

		/// <summary>
      ///   Especifica que a matriz de valores é uma cadeia de caracteres ASCII terminada em nulo.
      ///   Observe que o membro de dados <see langword="NumberOfValues" /> do objeto <see cref="T:System.Drawing.Imaging.EncoderParameter" />
      ///   indica o comprimento da cadeia de caracteres incluindo o terminador NULL.
      /// </summary>
		ValueTypeAscii = 2,

		/// <summary>
      ///   Especifica que cada valor na matriz é um inteiro sem sinal de 16 bits.
      ///</summary>
		ValueTypeShort = 3,

		/// <summary>
      ///   Especifica que cada valor na matriz é um inteiro sem sinal de 32 bits.
      /// </summary>
		ValueTypeLong = 4,

		/// <summary>
      ///   Especifica que cada valor na matriz é um par de inteiros sem sinal de 32 bits.
      ///   Cada par representa uma fração, o primeiro inteiro sendo o numerador e o segundo inteiro sendo o denominador.
      /// </summary>
		ValueTypeRational = 5,

		/// <summary>
      ///   Especifica que cada valor na matriz é um par de inteiros sem sinal de 32 bits. Cada par representa um intervalo de números.
      ///</summary>
		ValueTypeLongRange = 6,

		/// <summary>
      ///   Especifica que a matriz de valores é uma matriz de bytes que não tem nenhum tipo de dados definido.
      /// </summary>
		ValueTypeUndefined = 7,

		/// <summary>
      ///   Especifica que cada valor na matriz é um conjunto de quatro inteiros sem sinal de 32 bits.
      ///   Os dois primeiros inteiros representam uma fração e os segundos dois inteiros representam uma segunda fração.
      ///   As duas frações representam um intervalo de números racionais.
      ///   A primeira fração é o menor número racional no intervalo e a segunda fração é o maior número racional no intervalo.
      /// </summary>
		ValueTypeRationalRange = 8,

      /// <summary>
      ///   O parâmetro é um ponteiro para um bloco de metadados personalizados.
      /// </summary>
      ValueTypePointer = 9
	);

	/// <summary>Especifica quanto uma imagem é girada e o eixo usado para inverter a imagem.</summary>
	TGdipRotateFlipType = (
		/// <summary>Não especifica nenhuma rotação no sentido horário e nenhuma inversão.</summary>
		RotateNoneFlipNone = Ord(TGdiPlusAPI.TGdipRotateFlipTypeEnum.RotateNoneFlipNone),
		/// <summary>Especifica uma rotação de 90 graus no sentido horário sem inversão.</summary>
		Rotate90FlipNone = Ord(TGdiPlusAPI.TGdipRotateFlipTypeEnum.Rotate90FlipNone),
		/// <summary>Especifica uma rotação de 180 graus no sentido horário sem inversão.</summary>
		Rotate180FlipNone = Ord(TGdiPlusAPI.TGdipRotateFlipTypeEnum.Rotate180FlipNone),
		/// <summary>Especifica uma rotação de 270 graus no sentido horário sem inversão.</summary>
		Rotate270FlipNone = Ord(TGdiPlusAPI.TGdipRotateFlipTypeEnum.Rotate270FlipNone),
		/// <summary>Não especifica nenhuma rotação no sentido horário seguida por uma inversão horizontal.</summary>
		RotateNoneFlipX = Ord(TGdiPlusAPI.TGdipRotateFlipTypeEnum.RotateNoneFlipX),
		/// <summary>Especifica uma rotação de 90 graus no sentido horário seguida por uma inversão horizontal.</summary>
		Rotate90FlipX = Ord(TGdiPlusAPI.TGdipRotateFlipTypeEnum.Rotate90FlipX),
		/// <summary>Especifica uma rotação de 180 graus no sentido horário seguida por uma inversão horizontal.</summary>
		Rotate180FlipX = Ord(TGdiPlusAPI.TGdipRotateFlipTypeEnum.Rotate180FlipX),
		/// <summary>Especifica uma rotação de 270 graus no sentido horário seguida por uma inversão horizontal.</summary>
		Rotate270FlipX = Ord(TGdiPlusAPI.TGdipRotateFlipTypeEnum.Rotate270FlipX),
		/// <summary>Não especifica nenhuma rotação no sentido horário seguida por uma inversão vertical.</summary>
		RotateNoneFlipY = Ord(TGdiPlusAPI.TGdipRotateFlipTypeEnum.Rotate180FlipX),
		/// <summary>Especifica uma rotação de 90 graus no sentido horário seguida por uma inversão vertical.</summary>
		Rotate90FlipY = Ord(TGdiPlusAPI.TGdipRotateFlipTypeEnum.Rotate270FlipX),
		/// <summary>Especifica uma rotação de 180 graus no sentido horário seguida por uma inversão vertical.</summary>
		Rotate180FlipY = Ord(TGdiPlusAPI.TGdipRotateFlipTypeEnum.RotateNoneFlipX),
		/// <summary>Especifica uma rotação de 270 graus no sentido horário seguida por uma inversão vertical.</summary>
		Rotate270FlipY = Ord(TGdiPlusAPI.TGdipRotateFlipTypeEnum.Rotate90FlipX),
		/// <summary>Não especifica nenhuma rotação no sentido horário seguida por uma inversão horizontal e vertical.</summary>
		RotateNoneFlipXY = Ord(TGdiPlusAPI.TGdipRotateFlipTypeEnum.Rotate180FlipNone),
		/// <summary>Especifica uma rotação de 90 graus no sentido horário seguida por uma inversão horizontal e vertical.</summary>
		Rotate90FlipXY = Ord(TGdiPlusAPI.TGdipRotateFlipTypeEnum.Rotate270FlipNone),
		/// <summary>Especifica uma rotação de 180 graus no sentido horário seguida por uma inversão horizontal e vertical.</summary>
		Rotate180FlipXY = Ord(TGdiPlusAPI.TGdipRotateFlipTypeEnum.RotateNoneFlipNone),
		/// <summary>Especifica uma rotação de 270 graus no sentido horário seguida por uma inversão horizontal e vertical.</summary>
		Rotate270FlipXY = Ord(TGdiPlusAPI.TGdipRotateFlipTypeEnum.Rotate90FlipNone)
   );


   { TGdipMetafileType }

   /// <summary>
   /// Especifica o formato de um <see cref='Metafile'/>.
   /// </summary>
   TGdipMetafileType = (

      /// <summary>
      /// Especifica um tipo inválido.
      /// </summary>
      Invalid = Ord(TGdiPlusAPI.TGdipMetafileTypeEnum.Invalid),

      /// <summary>
      /// Especifica um metafile padrão do Windows.
      /// </summary>
      Wmf = Ord(TGdiPlusAPI.TGdipMetafileTypeEnum.Wmf),

      /// <summary>
      /// Especifica um metafile do Windows Placeable.
      /// </summary>
      WmfPlaceable = Ord(TGdiPlusAPI.TGdipMetafileTypeEnum.WmfPlaceable),

      /// <summary>
      /// Especifica um metafile aprimorado do Windows.
      /// </summary>
      Emf = Ord(TGdiPlusAPI.TGdipMetafileTypeEnum.Emf),

      /// <summary>
      /// Especifica um metafile aprimorado do Windows plus.
      /// </summary>
      EmfPlusOnly = Ord(TGdiPlusAPI.TGdipMetafileTypeEnum.EmfPlusOnly),

      /// <summary>
      /// Especifica comandos tanto aprimorados quanto aprimorados plus no mesmo arquivo.
      /// </summary>
      EmfPlusDual = Ord(TGdiPlusAPI.TGdipMetafileTypeEnum.EmfPlusDual)
   );




   { TGdipEmfType }

   /// <summary>
   /// Especifica o tipo de metafile.
   /// </summary>
   TGdipEmfType = (

      /// <summary>
      /// Metafile aprimorado do Windows. Contém comandos GDI. Metafiles deste tipo são referidos como um arquivo EMF.
      /// </summary>
      EmfOnly = Ord(TGdipMetafileType.Emf),

      /// <summary>
      /// Metafile aprimorado do Windows plus. Contém comandos GDI+. Metafiles deste tipo são referidos como um arquivo EMF+.
      /// </summary>
      EmfPlusOnly = Ord(TGdipMetafileType.EmfPlusOnly),

      /// <summary>
      /// Metafile aprimorado do Windows dual. Contém comandos equivalentes GDI e GDI+. Metafiles deste tipo são referidos como um arquivo EMF+.
      /// </summary>
      EmfPlusDual = Ord(TGdipMetafileType.EmfPlusDual)
   );


   { TGdipMetafileFrameUnit }

   /// <summary>
   /// Especifica a unidade de medida para o retângulo usado para dimensionar e posicionar um metafile.
   /// Isso é especificado durante a criação do <see cref='Metafile'/>.
   /// </summary>
   TGdipMetafileFrameUnit = (

      /// <summary>
      /// Especifica um pixel como a unidade de medida.
      /// </summary>
      Pixel = Ord(TGdipGraphicsUnit.Pixel),
      /// <summary>
      /// Especifica um ponto de impressora como a unidade de medida.
      /// </summary>
      Point = Ord(TGdipGraphicsUnit.Point),
      /// <summary>
      /// Especifica uma polegada como a unidade de medida.
      /// </summary>
      Inch = Ord(TGdipGraphicsUnit.Inch),
      /// <summary>
      /// Especifica 1/300 de uma polegada como a unidade de medida.
      /// </summary>
      Document = Ord(TGdipGraphicsUnit.Document),
      /// <summary>
      /// Especifica um milímetro como a unidade de medida.
      /// </summary>
      Millimeter = Ord(TGdipGraphicsUnit.Millimeter),
      /// <summary>
      /// Especifica 0,01 milímetro como a unidade de medida. Fornecido para compatibilidade com GDI.
      /// </summary>
      GdiCompatible
   );

   { TGdipImageLockMode }

	/// <summary>Especifica os sinalizadores passados para o parâmetro de sinalizadores do método <see cref="Overload:System.Drawing.Bitmap.LockBits" />. O método <see cref="Overload:System.Drawing.Bitmap.LockBits" /> bloqueia uma parte de uma imagem para que seja possível ler ou gravar os dados de pixel.</summary>
	TGdipImageLockMode = (

		/// <summary>Especifica que uma parte da imagem está bloqueada para leitura.</summary>
		ReadOnly = Ord(TGdiPlusAPI.TGdipImageLockModeEnum.Read),
		/// <summary>Especifica que uma parte da imagem está bloqueada para gravação.</summary>
		WriteOnly = Ord(TGdiPlusAPI.TGdipImageLockModeEnum.Write),
		/// <summary>Especifica que uma parte da imagem está bloqueada para leitura ou gravação.</summary>
		ReadWrite = Ord(Ord(TGdiPlusAPI.TGdipImageLockModeEnum.Read) or Ord(TGdiPlusAPI.TGdipImageLockModeEnum.Write)),
		/// <summary>Especifica que o buffer usado para ler ou gravar dados de pixel foi alocado pelo usuário. Se esse sinalizador estiver definido, o parâmetro <paramref name="flags" /> do método <see cref="Overload:System.Drawing.Bitmap.LockBits" /> funcionará como um parâmetro de entrada (e possivelmente como um parâmetro de saída). Se esse sinalizador estiver desmarcado, o parâmetro <paramref name="flags" /> funcionará apenas como um parâmetro de saída.</summary>
		UserInputBuffer = Ord(TGdiPlusAPI.TGdipImageLockModeEnum.UserInputBuf)
	);


   { TGdipDitherType }

   /// <summary>
   /// Algoritmo para realizar o pontilhado de imagens com uma paleta de cores reduzida.
   /// </summary>
   TGdipDitherType = (

      /// <summary>
      /// Nenhum pontilhado é realizado. Os pixels no bitmap de origem são mapeados para a cor mais próxima na paleta especificada
      /// pelo parâmetro palette do método <see cref="Bitmap.ConvertFormat(PixelFormat, DitherType, PaletteType, ColorPalette?, float)"/>.
      /// Este algoritmo pode ser usado com qualquer paleta, exceto <see cref="PaletteType.Custom"/>.
      /// </summary>
      None = Ord(TGdiPlusAPI.TGdipDitherTypeEnum.None),

      /// <summary>
      /// Nenhum pontilhado é realizado. Os pixels no bitmap de origem são mapeados para a cor mais próxima na paleta especificada
      /// pelo parâmetro palette do método <see cref="Bitmap.ConvertFormat(PixelFormat, DitherType, PaletteType, ColorPalette?, float)"/>.
      /// Este algoritmo pode ser usado com qualquer paleta.
      /// </summary>
      Solid = Ord(TGdiPlusAPI.TGdipDitherTypeEnum.Solid),

      /// <summary>
      /// Você pode usar este algoritmo para realizar o pontilhado baseado nas cores em uma das paletas fixas padrão. Você
      /// também pode usar este algoritmo para converter um bitmap para um formato de 16 bits por pixel que não tem paleta.
      /// </summary>
      Ordered4x4 = Ord(TGdiPlusAPI.TGdipDitherTypeEnum.Ordered4x4),

      /// <summary>
      /// O pontilhado é realizado usando as cores em uma das paletas fixas padrão.
      /// </summary>
      Ordered8x8 = Ord(TGdiPlusAPI.TGdipDitherTypeEnum.Ordered8x8),

      /// <summary>
      /// O pontilhado é realizado usando as cores em uma das paletas fixas padrão.
      /// </summary>
      Ordered16x16 = Ord(TGdiPlusAPI.TGdipDitherTypeEnum.Ordered16x16),

      /// <summary>
      /// O pontilhado é realizado usando as cores em uma das paletas fixas padrão.
      /// </summary>
      Spiral4x4 = Ord(TGdiPlusAPI.TGdipDitherTypeEnum.Spiral4x4),

      /// <summary>
      /// O pontilhado é realizado usando as cores em uma das paletas fixas padrão.
      /// </summary>
      Spiral8x8 = Ord(TGdiPlusAPI.TGdipDitherTypeEnum.Spiral8x8),

      /// <summary>
      /// O pontilhado é realizado usando as cores em uma das paletas fixas padrão.
      /// </summary>
      DualSpiral4x4 = Ord(TGdiPlusAPI.TGdipDitherTypeEnum.DualSpiral4x4),

      /// <summary>
      /// O pontilhado é realizado usando as cores em uma das paletas fixas padrão.
      /// </summary>
      DualSpiral8x8 = Ord(TGdiPlusAPI.TGdipDitherTypeEnum.DualSpiral8x8),

      /// <summary>
      /// O pontilhado é realizado com base na paleta especificada pelo parâmetro palette do
      /// método <see cref="Bitmap.ConvertFormat(PixelFormat, DitherType, PaletteType, ColorPalette?, float)"/>.
      /// Este algoritmo pode ser usado com qualquer paleta.
      /// </summary>
      ErrorDiffusion = Ord(TGdiPlusAPI.TGdipDitherTypeEnum.ErrorDiffusion)
   );


   TGdipPlayRecordCallback = reference to procedure(recordType: TGdipEmfPlusRecordType; flags: Integer; dataSize: Integer; recordData: Pointer);

   { IDisposable }

   /// <summary>
   /// Fornece um mecanismo para liberar recursos não gerenciados.
   /// </summary>
   IDisposable = interface(IInterface)
      ['{D1CBF7A3-F60B-4467-8C0C-CF0F0D94D6E9}']

      /// <summary>
      /// Executa tarefas definidas pela aplicação associadas a liberar, soltar ou redefinir recursos não gerenciados.
      /// </summary>
      procedure Dispose();
   end;

   { IDeviceContext }

   /// <summary>
   /// Esta interface define métodos para obter um identificador de contexto de dispositivo de exibição/janela (Win32 hdc).
   /// Nota: Os identificadores de contexto de dispositivo de exibição e janela são obtidos e liberados usando BeginPaint/EndPaint e
   /// GetDC/ReleaseDC; esta interface destina-se a ser usada apenas com o último método.
   ///
   /// Aviso aos implementadores: Criar e liberar identificadores de contexto de dispositivo que não sejam de exibição usando esta interface requer
   /// cuidado especial, por exemplo, usar outras funções Win32 como CreateDC ou CreateCompatibleDC exigem
   /// DeleteDC em vez de ReleaseDC para liberar adequadamente o identificador de contexto.
   ///
   /// Veja a classe DeviceContext para uma implementação desta interface, ela usa o método Dispose
   /// para liberar identificadores de contexto de dispositivo que não são de exibição.
   ///
   /// Esta é uma API de baixo nível que se espera ser usada com TextRenderer ou chamadas PInvoke.
   /// </summary>
   IDeviceContext = interface(IDisposable)
      ['{82722D04-0FC4-495D-A751-55932C9A3E72}']
      function GetHdc(): TDeviceContextHandle;

      procedure ReleaseHdc();
   end;


   { IGdipHdcContext }

   IGdipHdcContext = interface(IInterface)
      ['{7C820B81-7297-4014-84F6-56048658866E}']
      function GetHdc(): TDeviceContextHandle;
      procedure ReleaseHdc();
   end;

   /// <summary>
   /// Usado para indicar a propriedade de um ponteiro de recurso nativo.
   /// </summary>
   /// <remarks>
   /// <para>
   /// Este nunca deve ser colocado em uma struct.
   /// </para>
   /// </remarks>
   IPointer<TPointer> = interface(IInterface)
      ['{C054628E-BF70-408D-B682-8615F4D2CF70}']
      function GetPointer(): TPointer;
      property Pointer: TPointer read GetPointer;
   end;

   { TGdiDeviceContextSaveState }

   TGdiDeviceContextSaveState = record
      public HDC: TDeviceContextHandle;
      public SaveState: Int32;
      public constructor Create(const hDC: TDeviceContextHandle; const saveState: Int32);
   end;


   { IGdipGraphicsContextInfo }

   IGdipGraphicsContextInfo = interface(IPointer<TGdiplusAPI.TGdipGraphicsPtr>)
      ['{94A81CF6-7A71-415F-BF69-FDFFD139609B}']
      function GetHdc(const apply: TGdipApplyGraphicsProperties; const alwaysSaveState: Boolean): TGdiDeviceContextSaveState;
   end;

   { IGdipGraphics }

   IGdipGraphics = class(TNoRefCountObject, IGdipGraphicsContextInfo, IGdipHdcContext) // abstract class
      public function GetPointer(): TGdiplusAPI.TGdipGraphicsPtr; virtual; abstract;
      public function GetHdc(const apply: TGdipApplyGraphicsProperties; const alwaysSaveState: Boolean): TGdiDeviceContextSaveState; overload; virtual; abstract;
      public function GetHdc(): TDeviceContextHandle; overload; virtual; abstract;
      public procedure ReleaseHdc(); virtual; abstract;
   end;

   { IGdipGraphicsHdcProvider }

   /// <summary>
   /// Usado para fornecer uma maneira de dar ao <see cref="TGdipDeviceContextHdcScope"/> acesso direto interno aos HDCs.
   /// </summary>
   IGdipGraphicsHdcProvider = interface(IInterface)
      ['{75025CEE-23CB-4A8F-9149-0FBD1CE766FA}']
      function GetIsGraphicsStateClean(): Boolean;

      /// <summary>
      /// Se esta flag for verdadeira, espera-se que o objeto <see cref="GpGraphics"/> obtido por
      /// <see cref="GetGraphics(bool)"/> não tenha um <see cref="GpRegion"/> clip ou GpMatrix
      /// aplicado e, portanto, é seguro ignorar a obtenção deles.
      /// </summary>
      /// <remarks>
      /// <para>
      /// Se um objeto <see cref="GpGraphics"/> não foi criado, por definição, ele estará limpo quando for
      /// criado, então isto retornará verdadeiro.
      /// </para>
      /// </remarks>
      property IsGraphicsStateClean: Boolean read GetIsGraphicsStateClean;


      /// <summary>
      /// Obtém o <see cref="HDC"/>, se o objeto foi criado a partir de um.
      /// </summary>
      function GetHdc(): TDeviceContextHandle;


      /// <summary>
      /// Obtém o objeto <see cref="GpGraphics"/>.
      /// </summary>
      /// <param name="createIfNeeded">
      /// Se verdadeiro, isso passará um objeto <see cref="GpGraphics"/>, criando um novo *se* necessário.
      /// Se falso, passará um objeto <see cref="GpGraphics"/> *se* um existir, caso contrário retorna nulo.
      /// </param>
      /// <remarks>
      /// <para>Não descarte o objeto <see cref="GpGraphics"/> retornado.</para>
      /// </remarks>
      function GetGraphics(const createIfNeeded: Boolean): IGdipGraphics;
   end;

   { TGdipImageCodecFlags }

   /// <summary>
   ///   Fornece os atributos de um codec de imagem.
   /// </summary>
   TGdipImageCodecFlags = type UInt32;
   TGdipImageCodecFlagsHelper = record helper for TGdipImageCodecFlags

         /// <summary>
         /// O codec dá suporte a codificação (salvamento).
         /// </summary>
         public const Encoder = $00000001;

         /// <summary>
         /// O codec dá suporte a decodificação (leitura).
         /// </summary>
         public const Decoder = $00000002;

         /// <summary>
         /// O codec dá suporte a imagens de varredura (bitmaps).
         /// </summary>
         public const SupportBitmap = $00000004;

         /// <summary>
         /// O codec dá suporte a imagens de vetor (metarquivos).
         /// </summary>
         public const SupportVector = $00000008;

         /// <summary>
         /// O codificador requer um fluxo de saída pesquisável.
         /// </summary>
         public const SeekableEncode = $00000010;

         /// <summary>
         /// O decodificador tem comportamento de bloqueio durante o processo de decodificação.
         /// </summary>
         public const BlockingDecode = $00000020;

         /// <summary>
         /// O codec é inserido no GDI+.
         /// </summary>
         public const Builtin = $00010000;

         /// <summary>
         /// Não usado.
         /// </summary>
         public const System = $00020000;

         /// <summary>
         /// Não usado.
         /// </summary>
         public const User = $00040000;

   end;

   { TGdipMatrixOrder }

	/// <summary>Especifica a ordem de operações de transformação de matriz.</summary>
	TGdipMatrixOrder = (
		/// <summary>A nova operação é aplicada antes da operação antiga.</summary>
		Prepend = Ord(TGdiplusAPI.TGdipMatrixOrderEnum.Prepend),
		/// <summary>A nova operação é aplicada após da operação antiga.</summary>
		Append = Ord(TGdiplusAPI.TGdipMatrixOrderEnum.Append)
	);

implementation

{ TGdipEmfPlusFlags }

function TGdipEmfPlusFlagsHelper.HasFlag(const CheckFlag: TGdipEmfPlusFlags): Boolean;
begin
   Result := (Self and CheckFlag) = CheckFlag;
end;

{ TGdipApplyGraphicsPropertiesHelper }

function TGdipApplyGraphicsPropertiesHelper.HasFlag(const CheckFlag: TGdipApplyGraphicsProperties): Boolean;
begin
   Result := (Self and CheckFlag) = CheckFlag;
end;

{ TGdiDeviceContextSaveState }

constructor TGdiDeviceContextSaveState.Create(const hDC: TDeviceContextHandle; const saveState: Int32);
begin
   Self.HDC := hDC;
   Self.SaveState := saveState;
end;

{ TGdipPropertyIdList }
{ TGdipPropertyIdListExtensions }

function TGdipPropertyIdListExtensions.GetCount(): Integer;
begin
   Result := System.length(Self);
end;

procedure TGdipPropertyIdListExtensions.SetCount(const value: Integer);
begin
   System.SetLength(Self, value);
end;

{ TGdipPropertyItem }

class function TGdipPropertyItem.FromNative(const native: TGdiPlusAPI.TGdipPropertyItemPtr): TGdipPropertyItem;
begin
   if (native = nil) then
   begin
      raise EArgumentNilException.Create('native');
   end;

   Result := Default(TGdipPropertyItem);
   Result.Id := Integer(native^.id);
   Result.Length := Integer(native^.length);
   Result.ValueType := Int16(native^.type_);
   Result.Value := native^.value;
end;


{ TGdipSmoothingModeExtensions }

function TGdipSmoothingModeExtensions.ToNativeEnum(): TGdiplusAPI.TGdipSmoothingModeEnum;
begin
   case Self of
      TGdipSmoothingMode.Invalid: Result := TGdiPlusAPI.TGdipSmoothingModeEnum.Invalid;
      TGdipSmoothingMode.Default: Result := TGdiPlusAPI.TGdipSmoothingModeEnum.Default;
      TGdipSmoothingMode.HighSpeed: Result := TGdiPlusAPI.TGdipSmoothingModeEnum.HighSpeed;
      TGdipSmoothingMode.HighQuality: Result := TGdiPlusAPI.TGdipSmoothingModeEnum.HighQuality;
      TGdipSmoothingMode.None: Result := TGdiPlusAPI.TGdipSmoothingModeEnum.None;
      TGdipSmoothingMode.AntiAlias8x4: Result := TGdiPlusAPI.TGdipSmoothingModeEnum.AntiAlias8x4;
      TGdipSmoothingMode.AntiAlias8x8: Result := TGdiPlusAPI.TGdipSmoothingModeEnum.AntiAlias8x8;
   else
      raise EArgumentException.Create('TGdipSmoothingModeExtensions.ToNativeEnum()');
   end;
end;

function TGdipSmoothingModeExtensions.FromNativeEnum(const Value: TGdiplusAPI.TGdipSmoothingModeEnum): TGdipSmoothingMode;
begin
   case Value of
      TGdiplusAPI.TGdipSmoothingModeEnum.Invalid: Result := TGdipSmoothingMode.Invalid;
      TGdiplusAPI.TGdipSmoothingModeEnum.Default: Result := TGdipSmoothingMode.Default;
      TGdiplusAPI.TGdipSmoothingModeEnum.HighSpeed: Result := TGdipSmoothingMode.HighSpeed;
      TGdiplusAPI.TGdipSmoothingModeEnum.HighQuality: Result := TGdipSmoothingMode.HighQuality;
      TGdiplusAPI.TGdipSmoothingModeEnum.None: Result := TGdipSmoothingMode.None;
      TGdiplusAPI.TGdipSmoothingModeEnum.AntiAlias8x4: Result := TGdipSmoothingMode.AntiAlias8x4;
      TGdiplusAPI.TGdipSmoothingModeEnum.AntiAlias8x8: Result := TGdipSmoothingMode.AntiAlias8x8;
   else
      raise EArgumentException.Create('TGdipSmoothingModeExtensions.FromNativeEnum()');
   end;
end;

end.
