// Marcelo Melo
// 17/03/2024

unit Se7e.Drawing.Gdiplus.Graphics;

{$SCOPEDENUMS ON}
{$ZEROBASEDSTRINGS ON}
{$POINTERMATH ON}
{$ALIGN 8}
{$MINENUMSIZE 4}

{$IFDEF DEBUG}
   {.$DEFINE FINALIZATION_WATCH}
{$ENDIF DEBUG}

{$IFDEF MSWINDOWS}
   {$DEFINE FEATURE_WINDOWS_SYSTEM_COLORS}
{$ENDIF MSWINDOWS}

{$IFDEF FPC}
   {$MODE DELPHI}
{$ENDIF}

interface

uses
   System.SysUtils,
   System.Math,
   System.Classes,
   Winapi.ActiveX,
   Winapi.Windows,
   System.Types,
   System.IOUtils,
   System.Rtti,
   Se7e.Span,
   Se7e.Windows.Win32.PInvokeCore,
   Se7e.Windows.Win32.Graphics.GdiplusAPI,
   Se7e.Drawing.Gdiplus.Colors,
   Se7e.Drawing.Gdiplus.Utils,
   Se7e.Windows.Win32.Graphics.Gdi,
   Se7e.Drawing.Gdiplus.Types,
   Se7e.Numerics,
   Se7e.Drawing.Rectangle;

type

   TGdipGraphicsContext = class;
   TGdipRegion = class;
   TGdipGraphicsPath = class;
   TGdipRegionData = class;
   TGdipStringFormat = class;
   TGdipFontFamily = class;
   TGdipGraphics = class;
   TGdipFontCollection = class;
   TGdipPathData = class;
   TGdipPen = class;
   TGdipImage = class;
   TGdipBitmap = class;
   TGdipMetafile = class;
   TGdipEffect = class;


   { TGdipCustomLineCap }


	/// <summary>Encapsula uma terminação de linha personalizada definida pelo usuário.</summary>
   TGdipCustomLineCap = class
      protected _nativeCap: TGdiplusAPI.TGdipCustomLineCapPtr;


      strict private _disposed: Boolean;

      strict private function GetStrokeJoin(): TGdipLineJoin;
      strict private procedure SetStrokeJoin(const Value: TGdipLineJoin);

		/// <summary>Obtém ou define a enumeração <see cref="T:System.Drawing.Drawing2D.LineJoin" /> que determina como as linhas que compõem esse objeto <see cref="T:System.Drawing.Drawing2D.CustomLineCap" /> são unidas.</summary>
		/// <returns>O <see cref="T:System.Drawing.Drawing2D.LineJoin" /> enumeração isso <see cref="T:System.Drawing.Drawing2D.CustomLineCap" /> usa o objeto para linhas de associação.</returns>
      public property StrokeJoin: TGdipLineJoin read GetStrokeJoin write SetStrokeJoin;

      strict private function GetBaseCap(): TGdipLineCap;
      strict private procedure SetBaseCap(const Value: TGdipLineCap);

		/// <summary>Obtém ou define a enumeração <see cref="T:System.Drawing.Drawing2D.LineCap" /> em que esse <see cref="T:System.Drawing.Drawing2D.CustomLineCap" /> se baseia.</summary>
		/// <returns>O <see cref="T:System.Drawing.Drawing2D.LineCap" /> enumeração na qual o <see cref="T:System.Drawing.Drawing2D.CustomLineCap" /> baseia-se.</returns>
      public property BaseCap: TGdipLineCap read GetBaseCap write SetBaseCap;
      strict private function GetBaseInset(): Single;
      strict private procedure SetBaseInset(const Value: Single);

		/// <summary>Obtém ou define a distância entre o limite e a linha.</summary>
		/// <returns>A distância entre o início da extremidade e o final da linha.</returns>
      public property BaseInset: Single read GetBaseInset write SetBaseInset;

      strict private function GetWidthScale(): Single;
      strict private procedure SetWidthScale(const Value: Single);

		/// <summary>Permite que um <see cref="T:System.Drawing.Drawing2D.CustomLineCap" /> tente liberar recursos e executar outras operações de limpeza antes que <see cref="T:System.Drawing.Drawing2D.CustomLineCap" /> seja recuperado pela coleta de lixo.</summary>
      public destructor Destroy(); override;

		/// <summary>Obtém ou define a quantidade pela qual escalar esse objeto de classe <see cref="T:System.Drawing.Drawing2D.CustomLineCap" /> em relação à largura do objeto <see cref="T:System.Drawing.Pen" />.</summary>
		/// <returns>A quantidade pela qual dimensionar o limite.</returns>
      public property WidthScale: Single read GetWidthScale write SetWidthScale;

		/// <summary>Inicializa uma nova instância da classe <see cref="T:System.Drawing.Drawing2D.CustomLineCap" /> com o estrutura de tópicos e o preenchimento personalizados.</summary>
		/// <param name="fillPath">Um objeto <see cref="T:System.Drawing.Drawing2D.GraphicsPath" /> que define o preenchimento de limite personalizado.</param>
		/// <param name="strokePath">Um objeto <see cref="T:System.Drawing.Drawing2D.GraphicsPath" /> que define a estrutura de tópicos do limite personalizado.</param>
      public constructor Create(const fillPath: TGdipGraphicsPath; const strokePath: TGdipGraphicsPath); overload;


		/// <summary>Inicializa uma nova instância da classe <see cref="T:System.Drawing.Drawing2D.CustomLineCap" /> da enumeração <see cref="T:System.Drawing.Drawing2D.LineCap" /> existente especificada com a estrutura de tópicos e o preenchimento especificados.</summary>
		/// <param name="fillPath">Um objeto <see cref="T:System.Drawing.Drawing2D.GraphicsPath" /> que define o preenchimento de limite personalizado.</param>
		/// <param name="strokePath">Um objeto <see cref="T:System.Drawing.Drawing2D.GraphicsPath" /> que define a estrutura de tópicos do limite personalizado.</param>
		/// <param name="baseCap">O limite de linha do qual criar o limite personalizado.</param>
      public constructor Create(const fillPath: TGdipGraphicsPath; const strokePath: TGdipGraphicsPath; const baseCap: TGdipLineCap); overload;


		/// <summary>Inicializa uma nova instância da classe <see cref="T:System.Drawing.Drawing2D.CustomLineCap" /> da enumeração <see cref="T:System.Drawing.Drawing2D.LineCap" /> existente especificada com a estrutura de tópicos, o preenchimento e a inserção.</summary>
		/// <param name="fillPath">Um objeto <see cref="T:System.Drawing.Drawing2D.GraphicsPath" /> que define o preenchimento de limite personalizado.</param>
		/// <param name="strokePath">Um objeto <see cref="T:System.Drawing.Drawing2D.GraphicsPath" /> que define a estrutura de tópicos do limite personalizado.</param>
		/// <param name="baseCap">O limite de linha do qual criar o limite personalizado.</param>
		/// <param name="baseInset">A distância entre o limite e a linha.</param>
      public constructor Create(const fillPath: TGdipGraphicsPath; const strokePath: TGdipGraphicsPath; const baseCap: TGdipLineCap; const baseInset: Single); overload;


      protected constructor Create(const lineCap: TGdiplusAPI.TGdipCustomLineCapPtr); overload;


      protected class function CreateCustomLineCapObject(const cap: TGdiplusAPI.TGdipCustomLineCapPtr): TGdipCustomLineCap; static;


      protected procedure SetNativeLineCap(const handle: TGdiplusAPI.TGdipCustomLineCapPtr);


		/// <summary>Libera todos os recursos usados por esse objeto <see cref="T:System.Drawing.Drawing2D.CustomLineCap" />.</summary>
      public procedure Dispose(); overload;


		/// <summary>Libera os recursos não gerenciados usados pelo <see cref="T:System.Drawing.Drawing2D.CustomLineCap" /> e opcionalmente libera os recursos gerenciados.</summary>
		/// <param name="disposing">
		///   <see langword="true" /> para liberar recursos gerenciados e não gerenciados; <see langword="false" /> para liberar apenas recursos não gerenciados.</param>
      strict protected procedure Dispose(const disposing: Boolean); overload; virtual;


		/// <summary>Cria uma cópia exata deste <see cref="T:System.Drawing.Drawing2D.CustomLineCap" />.</summary>
		/// <returns>O <see cref="T:System.Drawing.Drawing2D.CustomLineCap" /> que esse método cria, convertido como um objeto.</returns>
      public function Clone(): TObject;


      protected function CoreClone(): TObject; virtual;


		/// <summary>Define os limites usados para iniciar e encerrar as linhas que compõem esse limite personalizado.</summary>
		/// <param name="startCap">A enumeração <see cref="T:System.Drawing.Drawing2D.LineCap" /> usada no início de uma linha nesse limite.</param>
		/// <param name="endCap">A enumeração <see cref="T:System.Drawing.Drawing2D.LineCap" /> usada no final de uma linha nesse limite.</param>
      public procedure SetStrokeCaps(const startCap: TGdipLineCap; const endCap: TGdipLineCap);


		/// <summary>Obtém os limites usados para iniciar e encerrar as linhas que compõem esse limite personalizado.</summary>
		/// <param name="startCap">A enumeração <see cref="T:System.Drawing.Drawing2D.LineCap" /> usada no início de uma linha nesse limite.</param>
		/// <param name="endCap">A enumeração <see cref="T:System.Drawing.Drawing2D.LineCap" /> usada no final de uma linha nesse limite.</param>
      public procedure GetStrokeCaps(out startCap: TGdipLineCap; out endCap: TGdipLineCap);
   end;

   { TGdipAdjustableArrowCap }

	/// <summary>Representa uma terminação de linha em forma de seta ajustável. Essa classe não pode ser herdada.</summary>
   TGdipAdjustableArrowCap = class sealed(TGdipCustomLineCap) (* partial *)

      strict private function GetNativeArrowCap(): TGdiplusAPI.TGdipAdjustableArrowCapPtr;


      strict private property NativeArrowCap: TGdiplusAPI.TGdipAdjustableArrowCapPtr read GetNativeArrowCap;

      strict private function GetHeight(): Single;
      strict private procedure SetHeight(const Value: Single);

		/// <summary>Obtém ou define a altura da extremidade da seta.</summary>
		/// <returns>A altura da extremidade da seta.</returns>
      public property Height: Single read GetHeight write SetHeight;

      strict private function GetWidth(): Single;
      strict private procedure SetWidth(const Value: Single);

		/// <summary>Obtém ou define a largura da extremidade da seta.</summary>
		/// <returns>A largura, em unidades da extremidade da seta.</returns>
      public property Width: Single read GetWidth write SetWidth;

      strict private function GetMiddleInset(): Single;
      strict private procedure SetMiddleInset(const Value: Single);

		/// <summary>Obtém ou define o número de unidades entre o contorno da extremidade da seta e o preenchimento.</summary>
		/// <returns>O número de unidades entre o contorno da extremidade da seta e o preenchimento da extremidade da seta.</returns>
      public property MiddleInset: Single read GetMiddleInset write SetMiddleInset;

      strict private function GetFilled(): Boolean;
      strict private procedure SetFilled(const Value: Boolean);


		/// <summary>Obtém ou define se a extremidade da seta é preenchida.</summary>
		/// <returns>Esta propriedade é <see langword="true" /> se a extremidade da seta é preenchida; caso contrário, <see langword="false" />.</returns>
      public property Filled: Boolean read GetFilled write SetFilled;

      protected constructor Create(const nativeCap: TGdiplusAPI.TGdipCustomLineCapPtr); overload;


		/// <summary>Inicializa uma nova instância da classe <see cref="T:System.Drawing.Drawing2D.AdjustableArrowCap" /> com a largura e a altura especificadas. Os arremates de extremidade de setas criadas com esse construtor sempre são preenchidos.</summary>
		/// <param name="width">A largura da seta.</param>
		/// <param name="height">A altura da seta.</param>
      public constructor Create(const width: Single; const height: Single); overload;


		/// <summary>Inicializa uma nova instância da classe <see cref="T:System.Drawing.Drawing2D.AdjustableArrowCap" /> com a largura, a altura e a propriedade de preenchimento especificadas. O preenchimento ou não do arremate de extremidade de seta depende do argumento passado para o parâmetro <paramref name="isFilled" />.</summary>
		/// <param name="width">A largura da seta.</param>
		/// <param name="height">A altura da seta.</param>
		/// <param name="isFilled">
		///   <see langword="true" /> para preencher o arremate de extremidade da seta; caso contrário, <see langword="false" />.</param>
      public constructor Create(const width: Single; const height: Single; const isFilled: Boolean); overload;
   end;


   { TGdipBrush }

	/// <summary>Define os objetos usados para preencher os interiores de formas gráficas como retângulos, elipses, pizzas, polígonos e caminhos.</summary>
   TGdipBrush = class abstract

      strict private _nativeBrush: TGdiplusAPI.TGdipBrushPtr;

      strict private function GetNativeBrush(): TGdiplusAPI.TGdipBrushPtr;

      protected property NativeBrush: TGdiplusAPI.TGdipBrushPtr read GetNativeBrush;

		/// <summary>Quando substituído em uma classe derivada, cria uma cópia exata deste <see cref="T:System.Drawing.Brush" />.</summary>
		/// <returns>O novo <see cref="T:System.Drawing.Brush" /> criado por esse método.</returns>
      public function Clone(): TObject; virtual; abstract;

		/// <summary>Em uma classe derivada, define uma referência para um objeto de pincel GDI+.</summary>
		/// <param name="brush">Um ponteiro para o objeto de pincel GDI+.</param>
      protected procedure SetNativeBrush(const brush: Pointer);

      protected procedure SetNativeBrushInternal(const brush: TGdiplusAPI.TGdipBrushPtr);

		/// <summary>Libera todos os recursos usados por esse objeto <see cref="T:System.Drawing.Brush" />.</summary>
      public procedure Dispose(); overload;

		/// <summary>Permite que um objeto tente liberar recursos e executar outras operações de limpeza antes de ser recuperado pela coleta de lixo.</summary>
      public destructor Destroy(); override;

		/// <summary>Libera os recursos não gerenciados usados pelo <see cref="T:System.Drawing.Brush" /> e opcionalmente libera os recursos gerenciados.</summary>
		/// <param name="disposing">
		///   <see langword="true" /> para liberar recursos gerenciados e não gerenciados; <see langword="false" /> para liberar apenas recursos não gerenciados.</param>
      strict protected procedure Dispose(const disposing: Boolean); overload; virtual;
   end;


{$REGION 'TGdipMatrix'}

   { TGdipMatrix }

	/// <summary>Encapsula uma matriz afim 3 por 3 que representa uma transformação geométrica. Essa classe não pode ser herdada.</summary>
   TGdipMatrix = class sealed

      strict private class constructor Create();
      public procedure AfterConstruction; override;
      public procedure BeforeDestruction; override;

      strict private m_NativeMatrix: TGdiplusAPI.TGdipMatrixPtr;

      public property NativeMatrix: TGdiplusAPI.TGdipMatrixPtr read m_NativeMatrix write m_NativeMatrix;
      strict private function GetElements(): TArray<Single>; overload;

      /// <summary>Obtém uma matriz de valores de ponto flutuante que representa os elementos deste <see cref="T:System.Drawing.Drawing2D.Matrix" />.</summary>
      /// <returns>Uma matriz de valores de ponto flutuante que representa os elementos deste <see cref="T:System.Drawing.Drawing2D.Matrix" />.</returns>
      public property Elements: TArray<Single> read GetElements;
      strict private function GetMatrixElements(): TMatrix3x2;
      strict private procedure SetMatrixElements(const Value: TMatrix3x2);

      /// <summary>
      ///  Gets/sets the elements for the matrix.
      /// </summary>
      public property MatrixElements: TMatrix3x2 read GetMatrixElements write SetMatrixElements;
      strict private function GetOffsetX(): Single;


      /// <summary>Obtém o valor de translação de x (o valor de dx ou o elemento na terceira linha e na primeira coluna) deste <see cref="T:System.Drawing.Drawing2D.Matrix" />.</summary>
      /// <returns>O valor de translação de x isso <see cref="T:System.Drawing.Drawing2D.Matrix" />.</returns>
      public property OffsetX: Single read GetOffsetX;
      strict private function GetOffsetY(): Single;


      /// <summary>Obtém o valor de translação de y (o valor de dy ou o elemento na terceira linha e na segunda coluna) deste <see cref="T:System.Drawing.Drawing2D.Matrix" />.</summary>
      /// <returns>O valor de translação de y deste <see cref="T:System.Drawing.Drawing2D.Matrix" />.</returns>
      public property OffsetY: Single read GetOffsetY;
      strict private function GetOffset(): TPointF;


      public property Offset: TPointF read GetOffset;
      strict private function GetIsInvertible(): Boolean;


      /// <summary>Obtém um valor que indica se este <see cref="T:System.Drawing.Drawing2D.Matrix" /> pode ser invertido.</summary>
      /// <returns>Esta propriedade é <see langword="true" /> se esse <see cref="T:System.Drawing.Drawing2D.Matrix" /> pode ser invertida; caso contrário, <see langword="false" />.</returns>
      public property IsInvertible: Boolean read GetIsInvertible;
      strict private function GetIsIdentity(): Boolean;


      /// <summary>Obtém um valor que indica se este <see cref="T:System.Drawing.Drawing2D.Matrix" /> é a matriz de identidade.</summary>
      /// <returns>Esta propriedade é <see langword="true" /> se esse <see cref="T:System.Drawing.Drawing2D.Matrix" /> é identidade; caso contrário, <see langword="false" />.</returns>
      public property IsIdentity: Boolean read GetIsIdentity;


      /// <summary>Inicializa uma nova instância da classe <see cref="T:System.Drawing.Drawing2D.Matrix" /> como a matriz de identidade.</summary>
      public constructor Create(); overload;

      /// <summary>Permite que um objeto tente liberar recursos e executar outras operações de limpeza antes de ser recuperado pela coleta de lixo.</summary>
      public destructor Destroy(); override;



      /// <summary>Inicializa uma nova instância da classe <see cref="T:System.Drawing.Drawing2D.Matrix" /> com os elementos especificados.</summary>
      /// <param name="m11">O valor na primeira linha e na primeira coluna do novo <see cref="T:System.Drawing.Drawing2D.Matrix" />.</param>
      /// <param name="m12">O valor na primeira linha e na segunda coluna do novo <see cref="T:System.Drawing.Drawing2D.Matrix" />.</param>
      /// <param name="m21">O valor na segunda linha e na primeira coluna do novo <see cref="T:System.Drawing.Drawing2D.Matrix" />.</param>
      /// <param name="m22">O valor na segunda linha e na segunda coluna do novo <see cref="T:System.Drawing.Drawing2D.Matrix" />.</param>
      /// <param name="dx">O valor na terceira linha e na primeira coluna do novo <see cref="T:System.Drawing.Drawing2D.Matrix" />.</param>
      /// <param name="dy">O valor na terceira linha e na segunda coluna do novo <see cref="T:System.Drawing.Drawing2D.Matrix" />.</param>
      public constructor Create(const m11: Single; const m12: Single; const m21: Single; const m22: Single; const dx: Single; const dy: Single); overload;

      /// <summary>
      ///  Construct a <see cref="TGdipMatrix"/> utilizing the given <paramref name="matrix"/>.
      /// </summary>
      /// <param name="matrix">TGdipMatrix data to construct from.</param>
      public constructor Create(const matrix: TMatrix3x2); overload;


      strict private constructor Create(const nativeMatrix: TGdiplusAPI.TGdipMatrixPtr); overload;


      /// <summary>Inicializa uma nova instância da classe <see cref="T:System.Drawing.Drawing2D.Matrix" /> para a transformação geométrica definida pelo retângulo e matriz de pontos especificados.</summary>
      /// <param name="rect">Uma estrutura <see cref="T:System.Drawing.RectangleF" /> que representa o retângulo a ser transformado.</param>
      /// <param name="plgpts">Uma matriz de três <see cref="T:System.Drawing.PointF" /> estruturas que representa os pontos de um paralelogramo, do qual os cantos superior esquerdo, superior direito e inferior esquerdo do retângulo serão transformados. O canto inferior direito do paralelogramo é indicado pelos três primeiros cantos.</param>
      public constructor Create(const rect: TRectangleF; const plgpts: TArray<TPointF>); overload;


      /// <summary>Inicializa uma nova instância da classe <see cref="T:System.Drawing.Drawing2D.Matrix" /> para a transformação geométrica definida pelo retângulo e matriz de pontos especificados.</summary>
      /// <param name="rect">Uma estrutura <see cref="T:System.Drawing.Rectangle" /> que representa o retângulo a ser transformado.</param>
      /// <param name="plgpts">Uma matriz de três <see cref="T:System.Drawing.Point" /> estruturas que representa os pontos de um paralelogramo, do qual os cantos superior esquerdo, superior direito e inferior esquerdo do retângulo serão transformados. O canto inferior direito do paralelogramo é indicado pelos três primeiros cantos.</param>
      public constructor Create(const rect: TRectangle; const plgpts: TArray<TPoint>); overload;

      public class function CreateNativeHandle(const matrix: TMatrix3x2): TGdiPlusAPI.TGdipMatrixPtr; static;

      /// <summary>Libera todos os recursos usados por este <see cref="T:System.Drawing.Drawing2D.Matrix" />.</summary>
      public procedure Dispose();


      strict private procedure DisposeInternal();


      /// <summary>Cria uma cópia exata deste <see cref="T:System.Drawing.Drawing2D.Matrix" />.</summary>
      /// <returns>O <see cref="T:System.Drawing.Drawing2D.Matrix" /> criado por esse método.</returns>
      public function Clone(): TGdipMatrix;


      protected procedure GetElements(var elements: TArray<Single>); overload;


      /// <summary>Redefine este <see cref="T:System.Drawing.Drawing2D.Matrix" /> para ter os elementos da matriz de identidade.</summary>
      public procedure Reset();


      /// <summary>Multiplica esse <see cref="T:System.Drawing.Drawing2D.Matrix" /> pela matriz especificada no parâmetro <paramref name="matrix" />, acrescentando o <see cref="T:System.Drawing.Drawing2D.Matrix" /> especificado.</summary>
      /// <param name="matrix">O <see cref="T:System.Drawing.Drawing2D.Matrix" /> pelo qual este <see cref="T:System.Drawing.Drawing2D.Matrix" /> deve ser multiplicado.</param>
      public procedure Multiply(const matrix: TGdipMatrix); overload;


      /// <summary>Multiplica este <see cref="T:System.Drawing.Drawing2D.Matrix" /> pela matriz especificada no parâmetro <paramref name="matrix" /> e na ordem especificada no parâmetro <paramref name="order" />.</summary>
      /// <param name="matrix">O <see cref="T:System.Drawing.Drawing2D.Matrix" /> pelo qual este <see cref="T:System.Drawing.Drawing2D.Matrix" /> deve ser multiplicado.</param>
      /// <param name="order">O <see cref="T:System.Drawing.Drawing2D.MatrixOrder" /> que representa a ordem da multiplicação.</param>
      public procedure Multiply(const matrix: TGdipMatrix; const order: TGdipMatrixOrder); overload;


      /// <summary>Aplica-se do vetor de conversão especificado (<paramref name="offsetX" /> e <paramref name="offsetY" />) a este <see cref="T:System.Drawing.Drawing2D.Matrix" /> acrescentando o vetor de conversão.</summary>
      /// <param name="offsetX">O valor de x pelo qual converter esse <see cref="T:System.Drawing.Drawing2D.Matrix" />.</param>
      /// <param name="offsetY">O valor de y pelo qual converter esse <see cref="T:System.Drawing.Drawing2D.Matrix" />.</param>
      public procedure Translate(const offsetX: Single; const offsetY: Single); overload;


      /// <summary>Aplica-se o vetor de conversão especificada a este <see cref="T:System.Drawing.Drawing2D.Matrix" /> na ordem especificada.</summary>
      /// <param name="offsetX">O valor de x pelo qual converter esse <see cref="T:System.Drawing.Drawing2D.Matrix" />.</param>
      /// <param name="offsetY">O valor de y pelo qual converter esse <see cref="T:System.Drawing.Drawing2D.Matrix" />.</param>
      /// <param name="order">Um <see cref="T:System.Drawing.Drawing2D.MatrixOrder" /> que especifica a ordem (suceder ou preceder) em que a translação é aplicada a este <see cref="T:System.Drawing.Drawing2D.Matrix" />.</param>
      public procedure Translate(const offsetX: Single; const offsetY: Single; const order: TGdipMatrixOrder); overload;


      /// <summary>Aplica o vetor de escala especificado a este <see cref="T:System.Drawing.Drawing2D.Matrix" /> acrescentando o vetor de escala.</summary>
      /// <param name="scaleX">O valor segundo o qual este <see cref="T:System.Drawing.Drawing2D.Matrix" /> deve ser dimensionado na direção do eixo x.</param>
      /// <param name="scaleY">O valor segundo o qual este <see cref="T:System.Drawing.Drawing2D.Matrix" /> deve ser dimensionado na direção do eixo y.</param>
      public procedure Scale(const scaleX: Single; const scaleY: Single); overload;

      /// <summary>Aplica o vetor de escala especificado (<paramref name="scaleX" /> e <paramref name="scaleY" />) a esta <see cref="T:System.Drawing.Drawing2D.Matrix" /> usando a ordem especificada.</summary>
      /// <param name="scaleX">O valor segundo o qual este <see cref="T:System.Drawing.Drawing2D.Matrix" /> deve ser dimensionado na direção do eixo x.</param>
      /// <param name="scaleY">O valor segundo o qual este <see cref="T:System.Drawing.Drawing2D.Matrix" /> deve ser dimensionado na direção do eixo y.</param>
      /// <param name="order">Um <see cref="T:System.Drawing.Drawing2D.MatrixOrder" /> que especifica a ordem (suceder ou preceder) em que o vetor de escala é aplicado a este <see cref="T:System.Drawing.Drawing2D.Matrix" />.</param>

      public procedure Scale(const scaleX: Single; const scaleY: Single; const order: TGdipMatrixOrder); overload;


      /// <summary>Preceda a isso <see cref="T:System.Drawing.Drawing2D.Matrix" /> uma rotação no sentido horário ao redor da origem e pelo ângulo especificado.</summary>
      /// <param name="angle">O ângulo de rotação, em graus.</param>
      public procedure Rotate(const angle: Single); overload;


      /// <summary>Aplica uma rotação no sentido horário de um valor especificado no parâmetro <paramref name="angle" />, em torno da origem (coordenadas x e y zero) para esse <see cref="T:System.Drawing.Drawing2D.Matrix" />.</summary>
      /// <param name="angle">O ângulo (extensão) de rotação, em graus.</param>
      /// <param name="order">Um <see cref="T:System.Drawing.Drawing2D.MatrixOrder" /> que especifica a ordem (suceder ou preceder) em que a rotação é aplicada a este <see cref="T:System.Drawing.Drawing2D.Matrix" />.</param>
      public procedure Rotate(const angle: Single; const order: TGdipMatrixOrder); overload;


      /// <summary>Aplica uma rotação horária a esta <see cref="T:System.Drawing.Drawing2D.Matrix" /> em torno do ponto especificado no parâmetro <paramref name="point" /> e pela precedência da rotação.</summary>
      /// <param name="angle">O ângulo (extensão) de rotação, em graus.</param>
      /// <param name="point">Um <see cref="T:System.Drawing.PointF" /> que representa o centro da rotação.</param>
      public procedure RotateAt(const angle: Single; const point: TPointF); overload;

      /// <summary>Aplica uma rotação horária em torno do ponto especificado para este <see cref="T:System.Drawing.Drawing2D.Matrix" /> na ordem especificada.</summary>
      /// <param name="angle">O ângulo de rotação, em graus.</param>
      /// <param name="point">Um <see cref="T:System.Drawing.PointF" /> que representa o centro da rotação.</param>
      /// <param name="order">Um <see cref="T:System.Drawing.Drawing2D.MatrixOrder" /> que especifica a ordem (suceder ou preceder) em que a rotação é aplicada.</param>
      public procedure RotateAt(const angle: Single; const point: TPointF; const order: TGdipMatrixOrder); overload;


      /// <summary>Aplica o vetor de distorção especificado a este <see cref="T:System.Drawing.Drawing2D.Matrix" /> acrescentando a transformação de distorção.</summary>
      /// <param name="shearX">O fator de distorção horizontal.</param>
      /// <param name="shearY">O fator de distorção vertical.</param>
      public procedure Shear(const shearX: Single; const shearY: Single); overload;


      /// <summary>Aplica o vetor de distorção especificado a este <see cref="T:System.Drawing.Drawing2D.Matrix" /> na ordem especificada.</summary>
      /// <param name="shearX">O fator de distorção horizontal.</param>
      /// <param name="shearY">O fator de distorção vertical.</param>
      /// <param name="order">Um <see cref="T:System.Drawing.Drawing2D.MatrixOrder" /> que especifica a ordem (acrescentar no começo ou no fim) em que a distorção é aplicada.</param>
      public procedure Shear(const shearX: Single; const shearY: Single; const order: TGdipMatrixOrder); overload;


      /// <summary>Inverte esse <see cref="T:System.Drawing.Drawing2D.Matrix" />, se ele for invertível.</summary>
      public procedure Invert();


      /// <summary>Aplica a transformação geométrica representada por este <see cref="T:System.Drawing.Drawing2D.Matrix" /> a uma matriz especificada de pontos.</summary>
      /// <param name="pts">Uma matriz de estruturas <see cref="T:System.Drawing.Point" /> que representa os pontos a serem transformados.</param>
      public procedure TransformPoints(const pts: TArray<TPointF>); overload;


      /// <summary>Multiplica cada vetor em uma matriz pela matriz. Os elementos de translação da matriz (terceira linha) são ignorados.</summary>
      /// <param name="pts">Uma matriz de estruturas <see cref="T:System.Drawing.Point" /> que representa os pontos a serem transformados.</param>
      public procedure TransformPoints(const pts: TArray<TPoint>); overload;


      /// <summary>Multiplica cada vetor em uma matriz pela matriz. Os elementos de translação da matriz (terceira linha) são ignorados.</summary>
      /// <param name="pts">Uma matriz de estruturas <see cref="T:System.Drawing.Point" /> que representa os pontos a serem transformados.</param>
      public procedure TransformVectors(const pts: TArray<TPointF>); overload;


      /// <summary>Multiplica cada vetor em uma matriz pela matriz. Os elementos de translação da matriz (terceira linha) são ignorados.</summary>
      /// <param name="pts">Uma matriz de estruturas <see cref="T:System.Drawing.Point" /> que representa os pontos a serem transformados.</param>
      public procedure VectorTransformPoints(const pts: TArray<TPoint>);


      /// <summary>Aplica somente os componentes de escala e rotação deste <see cref="T:System.Drawing.Drawing2D.Matrix" /> à matriz especificada de pontos.</summary>
      /// <param name="pts">Uma matriz de estruturas <see cref="T:System.Drawing.Point" /> que representa os pontos a serem transformados.</param>
      public procedure TransformVectors(const pts: TArray<TPoint>); overload;


      /// <summary>Testa se o objeto especificado é um <see cref="T:System.Drawing.Drawing2D.Matrix" /> e é idêntico a este <see cref="T:System.Drawing.Drawing2D.Matrix" />.</summary>
      /// <param name="obj">O objeto a ser testado.</param>
      /// <returns>Este método retornará <see langword="true" /> se <paramref name="obj" /> o <see cref="T:System.Drawing.Drawing2D.Matrix" /> especificado for idênticos a este <see cref="T:System.Drawing.Drawing2D.Matrix" />; caso contrário, <see langword="false" />.</returns>
      public function Equals(obj: TObject): Boolean; override;
   end;

{$ENDREGION 'TGdipMatrix'}




   { TGdipPen }

   /// <summary>
   ///  Defines an object used to draw lines and curves.
   /// </summary>
   TGdipPen = class sealed

      // Handle to native GDI+ pen object.
      strict private _nativePen: TGdiplusAPI.TGdipPenPtr;

      // GDI+ doesn't understand system colors, so we need to cache the value here.
      strict private _color: TGdipColor;
      strict private _immutable: Boolean;

      // Tracks whether the dash style has been changed to something else than Solid during the lifetime of this object.
      strict private _dashStyleWasOrIsNotSolid: Boolean;
      strict private class constructor Create();
      public procedure AfterConstruction; override;
      public procedure BeforeDestruction; override;

      strict private function GetNativePen(): TGdiplusAPI.TGdipPenPtr;

      protected property NativePen: TGdiplusAPI.TGdipPenPtr read GetNativePen;
      strict private function GetWidth(): Single;
      strict private procedure SetWidth(const Value: Single);

      /// <summary>
      ///  Gets or sets the width of this <see cref='TGdipPen'/>.
      /// </summary>
      public property Width: Single read GetWidth write SetWidth;
      strict private function GetStartCap(): TGdipLineCap;
      strict private procedure SetStartCap(const Value: TGdipLineCap);

      /// <summary>
      ///  Gets or sets the cap style used at the beginning of lines drawn with this <see cref='TGdipPen'/>.
      /// </summary>
      public property StartCap: TGdipLineCap read GetStartCap write SetStartCap;
      strict private function GetEndCap(): TGdipLineCap;
      strict private procedure SetEndCap(const Value: TGdipLineCap);

      /// <summary>
      ///  Gets or sets the cap style used at the end of lines drawn with this <see cref='TGdipPen'/>.
      /// </summary>
      public property EndCap: TGdipLineCap read GetEndCap write SetEndCap;
      strict private function GetCustomStartCap(): TGdipCustomLineCap;
      strict private procedure SetCustomStartCap(const Value: TGdipCustomLineCap);

      /// <summary>
      ///  Gets or sets a custom cap style to use at the beginning of lines drawn with this <see cref='TGdipPen'/>.
      /// </summary>
      public property CustomStartCap: TGdipCustomLineCap read GetCustomStartCap write SetCustomStartCap;
      strict private function GetCustomEndCap(): TGdipCustomLineCap;
      strict private procedure SetCustomEndCap(const Value: TGdipCustomLineCap);

      /// <summary>
      ///  Gets or sets a custom cap style to use at the end of lines drawn with this <see cref='TGdipPen'/>.
      /// </summary>
      public property CustomEndCap: TGdipCustomLineCap read GetCustomEndCap write SetCustomEndCap;

      strict private function GetDashCap(): TGdipDashCap;
      strict private procedure SetDashCap(const Value: TGdipDashCap);

      /// <summary>
      ///  Gets or sets the cap style used at the beginning or end of dashed lines drawn with this <see cref='TGdipPen'/>.
      /// </summary>
      public property DashCap: TGdipDashCap read GetDashCap write SetDashCap;

      strict private function GetLineJoin(): TGdipLineJoin;
      strict private procedure SetLineJoin(const Value: TGdipLineJoin);

      /// <summary>
      ///  Gets or sets the join style for the ends of two overlapping lines drawn with this <see cref='TGdipPen'/>.
      /// </summary>
      public property LineJoin: TGdipLineJoin read GetLineJoin write SetLineJoin;
      strict private function GetMiterLimit(): Single;
      strict private procedure SetMiterLimit(const Value: Single);

      /// <summary>
      ///  Gets or sets the limit of the thickness of the join on a mitered corner.
      /// </summary>
      public property MiterLimit: Single read GetMiterLimit write SetMiterLimit;
      strict private function GetAlignment(): TGdipPenAlignment;
      strict private procedure SetAlignment(const Value: TGdipPenAlignment);

      /// <summary>
      ///  Gets or sets the alignment for objects drawn with this <see cref='TGdipPen'/>.
      /// </summary>
      public property Alignment: TGdipPenAlignment read GetAlignment write SetAlignment;
      strict private function GetTransform(): TGdipMatrix;
      strict private procedure SetTransform(const Value: TGdipMatrix);

      /// <summary>
      ///  Gets or sets the geometrical transform for objects drawn with this <see cref='TGdipPen'/>.
      /// </summary>
      public property Transform: TGdipMatrix read GetTransform write SetTransform;
      strict private function GetPenType(): TGdipPenType;

      /// <summary>
      ///  Gets the style of lines drawn with this <see cref='TGdipPen'/>.
      /// </summary>
      public property PenType: TGdipPenType read GetPenType;
      strict private function GetColor(): TGdipColor;
      strict private procedure SetColor(const Value: TGdipColor);

      /// <summary>
      ///  Gets or sets the color of this <see cref='TGdipPen'/>.
      /// </summary>
      public property Color: TGdipColor read GetColor write SetColor;
      strict private function GetBrush(): TGdipBrush;
      strict private procedure SetBrush(const Value: TGdipBrush);

      /// <summary>
      ///  Gets or sets the <see cref='Drawing.Brush'/> that determines attributes of this <see cref='TGdipPen'/>.
      /// </summary>
      public property Brush: TGdipBrush read GetBrush write SetBrush;
      strict private function GetDashStyle(): TGdipDashStyle;
      strict private procedure SetDashStyle(const Value: TGdipDashStyle);

      /// <summary>
      ///  Gets or sets the style used for dashed lines drawn with this <see cref='TGdipPen'/>.
      /// </summary>
      public property DashStyle: TGdipDashStyle read GetDashStyle write SetDashStyle;
      strict private function GetDashOffset(): Single;
      strict private procedure SetDashOffset(const Value: Single);

      /// <summary>
      ///  Gets or sets the distance from the start of a line to the beginning of a dash pattern.
      /// </summary>
      public property DashOffset: Single read GetDashOffset write SetDashOffset;
      strict private function GetDashPattern(): TArray<Single>;
      strict private procedure SetDashPattern(const Value: TArray<Single>);

      /// <summary>
      ///  Gets or sets an array of custom dashes and spaces. The dashes are made up of line segments.
      /// </summary>
      public property DashPattern: TArray<Single> read GetDashPattern write SetDashPattern;
      strict private function GetCompoundArray(): TArray<Single>;
      strict private procedure SetCompoundArray(const Value: TArray<Single>);

      /// <summary>
      ///  Gets or sets an array of custom dashes and spaces. The dashes are made up of line segments.
      /// </summary>
      public property CompoundArray: TArray<Single> read GetCompoundArray write SetCompoundArray;

      /// <summary>
      ///  Creates a TGdipPen from a native GDI+ object.
      /// </summary>
      strict private constructor Create(const nativePen: TGdiplusAPI.TGdipPenPtr); overload;


      protected constructor Create(const color: TGdipColor; const immutable: Boolean); overload;

      /// <summary>
      ///  Initializes a new instance of the TGdipPen class with the specified <see cref='Color'/>.
      /// </summary>
      public constructor Create(const color: TGdipColor); overload;

      /// <summary>
      ///  Initializes a new instance of the <see cref='TGdipPen'/> class with the specified
      ///  <see cref='Color'/> and <see cref='Width'/>.
      /// </summary>
      public constructor Create(const color: TGdipColor; const width: Single); overload;

      /// <summary>
      ///  Initializes a new instance of the TGdipPen class with the specified <see cref='Brush'/>.
      /// </summary>
      public constructor Create(const brush: TGdipBrush); overload;

      /// <summary>
      ///  Initializes a new instance of the <see cref='TGdipPen'/> class with the specified <see cref='Drawing.Brush'/> and width.
      /// </summary>
      public constructor Create(const brush: TGdipBrush; const width: Single); overload;


      protected procedure SetNativePen(const nativePen: TGdiplusAPI.TGdipPenPtr);

      /// <summary>
      ///  Creates an exact copy of this <see cref='TGdipPen'/>.
      /// </summary>
      public function Clone(): TObject;

      /// <summary>
      ///  Cleans up Windows resources for this <see cref='TGdipPen'/>.
      /// </summary>
      public procedure Dispose(); overload;


      /// <summary>
      ///  Cleans up Windows resources for this <see cref='Pen'/>.
      /// </summary>
      public destructor Destroy(); override;

      strict private procedure Dispose(const disposing: Boolean); overload;

      /// <summary>
      ///  Sets the values that determine the style of cap used to end lines drawn by this <see cref='TGdipPen'/>.
      /// </summary>
      public procedure SetLineCap(const startCap: TGdipLineCap; const endCap: TGdipLineCap; const dashCap: TGdipDashCap);

      /// <summary>
      ///  Resets the geometric transform for this <see cref='TGdipPen'/> to identity.
      /// </summary>
      public procedure ResetTransform();

      /// <summary>
      ///  Multiplies the transform matrix for this <see cref='TGdipPen'/> by the specified <see cref='Matrix'/>.
      /// </summary>
      public procedure MultiplyTransform(const matrix: TGdipMatrix); overload;

      /// <summary>
      ///  Multiplies the transform matrix for this <see cref='TGdipPen'/> by the specified <see cref='Matrix'/> in the specified order.
      /// </summary>
      public procedure MultiplyTransform(const matrix: TGdipMatrix; const order: TGdipMatrixOrder); overload;

      /// <summary>
      ///  Translates the local geometrical transform by the specified dimensions. This method prepends the translation
      ///  to the transform.
      /// </summary>
      public procedure TranslateTransform(const dx: Single; const dy: Single); overload;

      /// <summary>
      ///  Translates the local geometrical transform by the specified dimensions in the specified order.
      /// </summary>
      public procedure TranslateTransform(const dx: Single; const dy: Single; const order: TGdipMatrixOrder); overload;

      /// <summary>
      ///  Scales the local geometric transform by the specified amounts. This method prepends the scaling matrix to the transform.
      /// </summary>
      public procedure ScaleTransform(const sx: Single; const sy: Single); overload;

      /// <summary>
      ///  Scales the local geometric transform by the specified amounts in the specified order.
      /// </summary>
      public procedure ScaleTransform(const sx: Single; const sy: Single; const order: TGdipMatrixOrder); overload;

      /// <summary>
      ///  Rotates the local geometric transform by the specified amount. This method prepends the rotation to the transform.
      /// </summary>
      public procedure RotateTransform(const angle: Single); overload;

      /// <summary>
      ///  Rotates the local geometric transform by the specified amount in the specified order.
      /// </summary>
      public procedure RotateTransform(const angle: Single; const order: TGdipMatrixOrder); overload;


      strict private procedure InternalSetColor(const value: TGdipColor);


      strict private function GetNativeBrush(): TGdiplusAPI.TGdipBrushPtr;

      /// <summary>
      ///  This method is called after the user sets the pen's dash style to custom. Here, we make sure that there
      ///  is a default value set for the custom pattern.
      /// </summary>
      strict private procedure EnsureValidDashPattern();


      public procedure OnSystemColorChanged();
   end;

   { TGdipSolidBrush }


   TGdipSolidBrush = class sealed(TGdipBrush)//, ISystemColorTracker)

      // GDI+ doesn't understand system colors, so we need to cache the value here.

      strict private _color: TGdipColor;

      strict private _immutable: Boolean;

      strict private function GetColor(): TGdipColor;
      strict private procedure SetColor(const Value: TGdipColor);


      public property Color: TGdipColor read GetColor write SetColor;


      public constructor Create(const color: TGdipColor); overload;


      protected constructor Create(const color: TGdipColor; const immutable: Boolean); overload;


      protected constructor Create(const nativeBrush: TGdiplusAPI.TGdipSolidFillPtr); overload;


      public function Clone(): TObject; override;


      strict protected procedure Dispose(const disposing: Boolean); override;

      // Sets the color even if the brush is considered immutable.

      strict private procedure InternalSetColor(const value: TGdipColor);


      public procedure OnSystemColorChanged();
   end;

{$REGION 'TGdipColorMatrix'}

   { TGdipColorMatrix }

	/// <summary>
   /// Define uma matriz 5 x 5 que contém as coordenadas homogêneas para o espaço RGBA. Vários métodos
   /// da classe System.Drawing.Imaging.ImageAttributes ajustam as cores da imagem usando
   /// uma matriz de cores. Essa classe não pode ser herdada.
	/// </summary>
   TGdipColorMatrix = packed class
      strict private _matrix00: Single;
      strict private _matrix01: Single;
      strict private _matrix02: Single;
      strict private _matrix03: Single;
      strict private _matrix04: Single;
      strict private _matrix10: Single;
      strict private _matrix11: Single;
      strict private _matrix12: Single;
      strict private _matrix13: Single;
      strict private _matrix14: Single;
      strict private _matrix20: Single;
      strict private _matrix21: Single;
      strict private _matrix22: Single;
      strict private _matrix23: Single;
      strict private _matrix24: Single;
      strict private _matrix30: Single;
      strict private _matrix31: Single;
      strict private _matrix32: Single;
      strict private _matrix33: Single;
      strict private _matrix34: Single;
      strict private _matrix40: Single;
      strict private _matrix41: Single;
      strict private _matrix42: Single;
      strict private _matrix43: Single;
      strict private _matrix44: Single;

		/// <summary>
      /// Inicializa uma nova instância da classe <see cref="T:System.Drawing.Imaging.ColorMatrix" />.
      /// </summary>
      public constructor Create(); overload;

		/// <summary>
      /// Inicializa uma nova instância da classe <see cref="T:System.Drawing.Imaging.ColorMatrix" /> usando
      /// os elementos na matriz <paramref name="newColorMatrix" /> especificada.
      /// </summary>
		/// <param name="newColorMatrix">Os valores dos elementos para o novo <see cref="T:System.Drawing.Imaging.ColorMatrix" />.</param>
      public constructor Create(const newColorMatrix: TArray<TArray<Single>>); overload;

      strict private function GetMatrix00(): Single;
      strict private procedure SetMatrix00(const Value: Single);

		/// <summary>Obtém ou define o elemento na linha 0 (zero) e na coluna 0 deste <see cref="T:System.Drawing.Imaging.ColorMatrix" />.</summary>
		/// <returns>O elemento na coluna 0 linha e 0 <see cref="T:System.Drawing.Imaging.ColorMatrix" /> .</returns>
      public property Matrix00: Single read GetMatrix00 write SetMatrix00;
      strict private function GetMatrix01(): Single;
      strict private procedure SetMatrix01(const Value: Single);

      /// <summary>
      ///  Represents the element at the 0th row and 1st column of this <see cref='TGdipColorMatrix'/>.
      /// </summary>
      public property Matrix01: Single read GetMatrix01 write SetMatrix01;
      strict private function GetMatrix02(): Single;
      strict private procedure SetMatrix02(const Value: Single);

      /// <summary>
      ///  Represents the element at the 0th row and 2nd column of this <see cref='TGdipColorMatrix'/>.
      /// </summary>
      public property Matrix02: Single read GetMatrix02 write SetMatrix02;
      strict private function GetMatrix03(): Single;
      strict private procedure SetMatrix03(const Value: Single);

      /// <summary>
      ///  Represents the element at the 0th row and 3rd column of this <see cref='TGdipColorMatrix'/>.
      /// </summary>
      public property Matrix03: Single read GetMatrix03 write SetMatrix03;
      strict private function GetMatrix04(): Single;
      strict private procedure SetMatrix04(const Value: Single);

      /// <summary>
      ///  Represents the element at the 0th row and 4th column of this <see cref='TGdipColorMatrix'/>.
      /// </summary>
      public property Matrix04: Single read GetMatrix04 write SetMatrix04;
      strict private function GetMatrix10(): Single;
      strict private procedure SetMatrix10(const Value: Single);

      /// <summary>
      ///  Represents the element at the 1st row and 0th column of this <see cref='TGdipColorMatrix'/>.
      /// </summary>
      public property Matrix10: Single read GetMatrix10 write SetMatrix10;
      strict private function GetMatrix11(): Single;
      strict private procedure SetMatrix11(const Value: Single);

      /// <summary>
      ///   Represents the element at the 1st row and 1st column of this <see cref='TGdipColorMatrix'/>.
      /// </summary>
      public property Matrix11: Single read GetMatrix11 write SetMatrix11;
      strict private function GetMatrix12(): Single;
      strict private procedure SetMatrix12(const Value: Single);

      /// <summary>
      ///  Represents the element at the 1st row and 2nd column of this <see cref='TGdipColorMatrix'/>.
      /// </summary>
      public property Matrix12: Single read GetMatrix12 write SetMatrix12;
      strict private function GetMatrix13(): Single;
      strict private procedure SetMatrix13(const Value: Single);

      /// <summary>
      ///  Represents the element at the 1st row and 3rd column of this <see cref='TGdipColorMatrix'/>.
      /// </summary>
      public property Matrix13: Single read GetMatrix13 write SetMatrix13;
      strict private function GetMatrix14(): Single;
      strict private procedure SetMatrix14(const Value: Single);

      /// <summary>
      ///  Represents the element at the 1st row and 4th column of this <see cref='TGdipColorMatrix'/>.
      /// </summary>
      public property Matrix14: Single read GetMatrix14 write SetMatrix14;
      strict private function GetMatrix20(): Single;
      strict private procedure SetMatrix20(const Value: Single);

      /// <summary>
      ///  Represents the element at the 2nd row and 0th column of this <see cref='TGdipColorMatrix'/>.
      /// </summary>
      public property Matrix20: Single read GetMatrix20 write SetMatrix20;
      strict private function GetMatrix21(): Single;
      strict private procedure SetMatrix21(const Value: Single);

      /// <summary>
      ///  Represents the element at the 2nd row and 1st column of this <see cref='TGdipColorMatrix'/>.
      /// </summary>
      public property Matrix21: Single read GetMatrix21 write SetMatrix21;
      strict private function GetMatrix22(): Single;
      strict private procedure SetMatrix22(const Value: Single);

      /// <summary>
      ///  Represents the element at the 2nd row and 2nd column of this <see cref='TGdipColorMatrix'/>.
      /// </summary>
      public property Matrix22: Single read GetMatrix22 write SetMatrix22;
      strict private function GetMatrix23(): Single;
      strict private procedure SetMatrix23(const Value: Single);

      /// <summary>
      ///  Represents the element at the 2nd row and 3rd column of this <see cref='TGdipColorMatrix'/>.
      /// </summary>
      public property Matrix23: Single read GetMatrix23 write SetMatrix23;
      strict private function GetMatrix24(): Single;
      strict private procedure SetMatrix24(const Value: Single);

      /// <summary>
      ///  Represents the element at the 2nd row and 4th column of this <see cref='TGdipColorMatrix'/>.
      /// </summary>
      public property Matrix24: Single read GetMatrix24 write SetMatrix24;
      strict private function GetMatrix30(): Single;
      strict private procedure SetMatrix30(const Value: Single);

      /// <summary>
      ///  Represents the element at the 3rd row and 0th column of this <see cref='TGdipColorMatrix'/>.
      /// </summary>
      public property Matrix30: Single read GetMatrix30 write SetMatrix30;
      strict private function GetMatrix31(): Single;
      strict private procedure SetMatrix31(const Value: Single);

      /// <summary>
      ///  Represents the element at the 3rd row and 1st column of this <see cref='TGdipColorMatrix'/>.
      /// </summary>
      public property Matrix31: Single read GetMatrix31 write SetMatrix31;
      strict private function GetMatrix32(): Single;
      strict private procedure SetMatrix32(const Value: Single);

      /// <summary>
      ///  Represents the element at the 3rd row and 2nd column of this <see cref='TGdipColorMatrix'/>.
      /// </summary>
      public property Matrix32: Single read GetMatrix32 write SetMatrix32;
      strict private function GetMatrix33(): Single;
      strict private procedure SetMatrix33(const Value: Single);

      /// <summary>
      ///  Represents the element at the 3rd row and 3rd column of this <see cref='TGdipColorMatrix'/>.
      /// </summary>
      public property Matrix33: Single read GetMatrix33 write SetMatrix33;
      strict private function GetMatrix34(): Single;
      strict private procedure SetMatrix34(const Value: Single);

      /// <summary>
      ///  Represents the element at the 3rd row and 4th column of this <see cref='TGdipColorMatrix'/>.
      /// </summary>
      public property Matrix34: Single read GetMatrix34 write SetMatrix34;
      strict private function GetMatrix40(): Single;
      strict private procedure SetMatrix40(const Value: Single);

      /// <summary>
      ///  Represents the element at the 4th row and 0th column of this <see cref='TGdipColorMatrix'/>.
      /// </summary>
      public property Matrix40: Single read GetMatrix40 write SetMatrix40;
      strict private function GetMatrix41(): Single;
      strict private procedure SetMatrix41(const Value: Single);

      /// <summary>
      ///  Represents the element at the 4th row and 1st column of this <see cref='TGdipColorMatrix'/>.
      /// </summary>
      public property Matrix41: Single read GetMatrix41 write SetMatrix41;
      strict private function GetMatrix42(): Single;
      strict private procedure SetMatrix42(const Value: Single);

      /// <summary>
      ///  Represents the element at the 4th row and 2nd column of this <see cref='TGdipColorMatrix'/>.
      /// </summary>
      public property Matrix42: Single read GetMatrix42 write SetMatrix42;
      strict private function GetMatrix43(): Single;
      strict private procedure SetMatrix43(const Value: Single);

      /// <summary>
      ///  Represents the element at the 4th row and 3rd column of this <see cref='TGdipColorMatrix'/>.
      /// </summary>
      public property Matrix43: Single read GetMatrix43 write SetMatrix43;
      strict private function GetMatrix44(): Single;
      strict private procedure SetMatrix44(const Value: Single);

      /// <summary>
      ///  Represents the element at the 4th row and 4th column of this <see cref='TGdipColorMatrix'/>.
      /// </summary>
      public property Matrix44: Single read GetMatrix44 write SetMatrix44;

      //      /// <summary>
      //    ///  Initializes a new instance of the <see cref='TGdipColorMatrix'/> class.
      //    /// </summary>
      //TODO      public constructor Create(); overload;


      private function GetPinnableReference(): PSingle;
      strict private function GetItem(const row: Integer; const column: Integer): Single;
      strict private procedure SetItem(const row: Integer; const column: Integer; const Value: Single);

      /// <summary>
      ///  Gets or sets the value of the specified element of this <see cref='TGdipColorMatrix'/>.
      /// </summary>
      public property Items[const row: Integer; const column: Integer]: Single read GetItem write SetItem; default;
   end;

{$ENDREGION 'TGdipColorMatrix'}


   { TGdipColorMap }

   /// <summary>
   ///  Defines a map for converting colors.
   /// </summary>
   TGdipColorMap = record
      strict private m_OldColor: TGdipColor;
      strict private m_NewColor: TGdipColor;

      /// <summary>
      ///  Specifies the existing <see cref='Color'/> to be converted.
      /// </summary>
      public property OldColor: TGdipColor read m_OldColor write m_OldColor;

      /// <summary>
      ///  Specifies the new <see cref='Color'/> to which to convert.
      /// </summary>
      public property NewColor: TGdipColor read m_NewColor write m_NewColor;
   end;


   { TGdipColorPalette }

   /// <summary>
   ///  Defines an array of colors that make up a color palette.
   /// </summary>
   TGdipColorPalette = class sealed
      strict private _flags: Integer;

      strict private _entries: TArray<TGdipColor>;
      strict private function GetFlags(): Integer;

      /// <summary>
      ///  Specifies how to interpret the color information in the array of colors.
      /// </summary>
      public property Flags: Integer read GetFlags;
      strict private function GetEntries(): TArray<TGdipColor>;

      /// <summary>
      ///  Specifies an array of <see cref='Color'/> objects.
      /// </summary>
      public property Entries: TArray<TGdipColor> read GetEntries;

      // XmlSerializer requires a public constructor with no parameters.

//      strict private constructor Create(); overload;
      public destructor Destroy(); override;

//      strict private constructor Create(count: Integer); overload;


      strict private constructor Create(const flags: Integer; const entries: TArray<TGdipColor>); overload;

//      // #if NET9_0_OR_GREATER -> IfDirectiveTrivia
//      /// <summary>
//      ///  Create a custom color palette.
//      /// </summary>
//      /// <param name="entries">Color entries for the palette.</param>
//      public constructor Create(const entries: TArray<TGdipColor>); overload;
//
//      /// <summary>
//      ///  Create a standard color palette.
//      /// </summary>
//      public constructor Create(const paletteType: TGdipPaletteType); overload;
//

      /// <summary>
      ///  Create an optimal color palette based on the colors in a given bitmap.
      /// </summary>
      public class function CreateOptimalPalette(const colorCount: Integer; const useTransparentColor: Boolean; const bitmap: TGdipBitmap): TGdipColorPalette; overload; static;

      /// <summary>
      ///  Create an optimal color palette based on the colors in a given bitmap.
      /// </summary>
      public class function CreateOptimalPalette(const colorCount: Integer; const useTransparentColor: Boolean; const OptimalColors: Integer; const bitmap: TGdipBitmap): TGdipColorPalette; overload; static;

      // Memory layout is:
      //    UINT Flags
      //    UINT Count
      //    ARGB Entries[size]

//      /// <summary>
//      ///  Converts a native <see cref="TGdiPlusAPI.TGdipColorPalette"/> buffer.
//      /// </summary>
      protected class function ConvertFromBuffer(buffer: TGdiPlusAPI.TGdipColorPalettePtr): TGdipColorPalette; static;


      protected function ConvertToBuffer(): Pointer;

      /// <summary>
      ///  Initializes a standard, optimal, or custom color palette.
      /// </summary>
      /// <param name="paletteType">The palette type.</param>
      /// <param name="colorCount">
      ///  The number of colors you want to have in an optimal palette based on a the specified bitmap.
      /// </param>
      /// <param name="useTransparentColor"><see langword="true"/> to include the transparent color in the palette.</param>
      public class function InitializePalette(const paletteType: TGdipPaletteType; const colorCount: Integer; const useTransparentColor: Boolean; bitmap: TGdipBitmap): TGdipColorPalette; overload; static;

      /// <summary>
      ///  Initializes a standard, optimal, or custom color palette.
      /// </summary>
      /// <param name="paletteType">The palette type.</param>
      /// <param name="colorCount">
      ///  The number of colors you want to have in an optimal palette based on a the specified bitmap.
      /// </param>
      /// <param name="useTransparentColor"><see langword="true"/> to include the transparent color in the palette.</param>
      public class function InitializePalette(const paletteType: TGdipPaletteType; const colorCount: Integer; const useTransparentColor: Boolean; const OptimalColors: Integer; bitmap: TGdipBitmap): TGdipColorPalette; overload; static;
   end;


   { TGdipImageAttributes }

   // sdkinc\GDIplusImageAttributes.h

   // There are 5 possible sets of color adjustments:
   //          ColorAdjustDefault,
   //          ColorAdjustBitmap,
   //          ColorAdjustBrush,
   //          ColorAdjustPen,
   //          ColorAdjustText,

   // Bitmaps, Brushes, Pens, and Text will all use any color adjustments
   // that have been set into the default ImageAttributes until their own
   // color adjustments have been set.  So as soon as any "Set" method is
   // called for Bitmaps, Brushes, Pens, or Text, then they start from
   // scratch with only the color adjustments that have been set for them.
   // Calling Reset removes any individual color adjustments for a type
   // and makes it revert back to using all the default color adjustments
   // (if any).  The SetToIdentity method is a way to force a type to
   // have no color adjustments at all, regardless of what previous adjustments
   // have been set for the defaults or for that type.

   /// <summary>
   ///  Contains information about how image colors are manipulated during rendering.
   /// </summary>
   TGdipImageAttributes = class sealed

      strict private type

            { TStackBuffer }

            TStackBuffer = record
               public _element0: TARGB;
               public _element1: TARGB;
            end;

      strict private const ColorMapStackSpace: Integer = 32;

{$IFDEF FINALIZATION_WATCH}
      strict private m_allocationSite: string;
{$ENDIF FINALIZATION_WATCH}


      private _nativeImageAttributes: TGdiplusAPI.TGdipImageAttributesPtr;


      /// <summary>
      ///  Initializes a new instance of the <see cref='ImageAttributes'/> class.
      /// </summary>
      public constructor Create(); overload;


      protected constructor Create(const newNativeImageAttributes: TGdiplusAPI.TGdipImageAttributesPtr); overload;

      /// <summary>
      ///  Cleans up Windows resources for this <see cref='ImageAttributes'/>.
      /// </summary>
      public destructor Destroy(); override;


      protected procedure SetNativeImageAttributes(const handle: TGdiplusAPI.TGdipImageAttributesPtr);

      /// <summary>
      ///  Cleans up Windows resources for this <see cref='ImageAttributes'/>.
      /// </summary>
      public procedure Dispose(); overload;


      strict private procedure Dispose(const disposing: Boolean); overload;

      /// <summary>
      ///  Creates an exact copy of this <see cref='ImageAttributes'/>.
      /// </summary>
      public function Clone(): TGdipImageAttributes;

      /// <summary>
      ///  Sets the 5 X 5 color adjust matrix to the specified <see cref='Matrix'/>.
      /// </summary>
      public procedure SetColorMatrix(const newColorMatrix: TGdipColorMatrix); overload;

      /// <summary>
      ///  Sets the 5 X 5 color adjust matrix to the specified 'Matrix' with the specified 'ColorMatrixFlags'.
      /// </summary>
      public procedure SetColorMatrix(const newColorMatrix: TGdipColorMatrix; const flags: TGdipColorMatrixFlag); overload;

      /// <summary>
      ///  Sets the 5 X 5 color adjust matrix to the specified 'Matrix' with the  specified 'ColorMatrixFlags'.
      /// </summary>
      public procedure SetColorMatrix(const newColorMatrix: TGdipColorMatrix; const mode: TGdipColorMatrixFlag; const &type: TGdipColorAdjustType); overload;

      /// <summary>
      ///  Clears the color adjust matrix to all zeroes.
      /// </summary>
      public procedure ClearColorMatrix(); overload;

      /// <summary>
      ///  Clears the color adjust matrix.
      /// </summary>
      public procedure ClearColorMatrix(const &type: TGdipColorAdjustType); overload;

      /// <summary>
      ///  Sets a color adjust matrix for image colors and a separate gray scale adjust matrix for gray scale values.
      /// </summary>
      public procedure SetColorMatrices(const newColorMatrix: TGdipColorMatrix; const grayMatrix: TGdipColorMatrix); overload;


      public procedure SetColorMatrices(const newColorMatrix: TGdipColorMatrix; const grayMatrix: TGdipColorMatrix; const flags: TGdipColorMatrixFlag); overload;


      public procedure SetColorMatrices(const newColorMatrix: TGdipColorMatrix; const grayMatrix: TGdipColorMatrix; const mode: TGdipColorMatrixFlag; const &type: TGdipColorAdjustType); overload;


      public procedure SetThreshold(const threshold: Single); overload;


      public procedure SetThreshold(const threshold: Single; const &type: TGdipColorAdjustType); overload;


      public procedure ClearThreshold(); overload;


      public procedure ClearThreshold(const &type: TGdipColorAdjustType); overload;


      strict private procedure SetThreshold(const threshold: Single; const &type: TGdipColorAdjustType; const enableFlag: Boolean); overload;


      public procedure SetGamma(const gamma: Single); overload;


      public procedure SetGamma(const gamma: Single; const &type: TGdipColorAdjustType); overload;


      public procedure ClearGamma(); overload;


      public procedure ClearGamma(const &type: TGdipColorAdjustType); overload;


      strict private procedure SetGamma(const gamma: Single; const &type: TGdipColorAdjustType; const enableFlag: Boolean); overload;


      public procedure SetNoOp(); overload;


      public procedure SetNoOp(const &type: TGdipColorAdjustType); overload;


      public procedure ClearNoOp(); overload;


      public procedure ClearNoOp(const &type: TGdipColorAdjustType); overload;


      strict private procedure SetNoOp(const &type: TGdipColorAdjustType; const enableFlag: Boolean); overload;


      public procedure SetColorKey(const colorLow: TGdipColor; const colorHigh: TGdipColor); overload;


      public procedure SetColorKey(const colorLow: TGdipColor; const colorHigh: TGdipColor; const &type: TGdipColorAdjustType); overload;


      public procedure ClearColorKey(); overload;


      public procedure ClearColorKey(const &type: TGdipColorAdjustType); overload;


      strict private procedure SetColorKey(const colorLow: TGdipColor; const colorHigh: TGdipColor; const &type: TGdipColorAdjustType; const enableFlag: Boolean); overload;


      public procedure SetOutputChannel(const flags: TGdipColorChannelFlag); overload;


      public procedure SetOutputChannel(const flags: TGdipColorChannelFlag; const &type: TGdipColorAdjustType); overload;


      public procedure ClearOutputChannel(); overload;


      public procedure ClearOutputChannel(const &type: TGdipColorAdjustType); overload;


      strict private procedure SetOutputChannel(const &type: TGdipColorAdjustType; const flags: TGdipColorChannelFlag; const enableFlag: Boolean); overload;


      public procedure SetOutputChannelColorProfile(const colorProfileFilename: string); overload;


      public procedure SetOutputChannelColorProfile(const colorProfileFilename: string; const &type: TGdipColorAdjustType); overload;


      public procedure ClearOutputChannelColorProfile(); overload;


      public procedure ClearOutputChannelColorProfile(const &type: TGdipColorAdjustType); overload;

      /// <inheritdoc cref="SetRemapTable(ColorMap[], ColorAdjustType)"/>
      public procedure SetRemapTable(const map: TArray<TGdipColorMap>); overload;

      /// <summary>
      ///  Sets the default color-remap table.
      /// </summary>
      /// <inheritdoc cref="SetRemapTable(ColorAdjustType, ReadOnlySpan{ColorMap})"/>

      // #if NET9_0_OR_GREATER -> IfDirectiveTrivia

      public procedure SetRemapTable(const map: TArray<TGdipColorMap>; const adjustType: TGdipColorAdjustType); overload;

//      // #if NET9_0_OR_GREATER -> IfDirectiveTrivia
//      /// <inheritdoc cref="SetRemapTable(ColorMap[], ColorAdjustType)"/>
//      public procedure SetRemapTable(const map: TReadOnlySpan<TGdipColorMap>); overload;
//
//      /// <inheritdoc cref="SetRemapTable(ColorMap[], ColorAdjustType)"/>
//      public procedure SetRemapTable(const map: TReadOnlySpan<T(Color OldColor, Color NewColor)>); overload;
//      // #endif -> EndIfDirectiveTrivia

      /// <summary>
      ///  Sets the color-remap table for a specified category.
      /// </summary>
      /// <param name="type">
      ///  An element of <see cref="ColorAdjustType"/> that specifies the category for which the color-remap table is set.
      /// </param>
      /// <param name="map">
      ///  A series of color pairs mapping an existing color to a new color.
      /// </param>

      // #if NET9_0_OR_GREATER -> IfDirectiveTrivia
//
//      public procedure SetRemapTable(const &type: TGdipColorAdjustType; const map: TReadOnlySpan<TGdipColorMap>); overload;
//
//      // #if NET9_0_OR_GREATER -> IfDirectiveTrivia
//      /// <inheritdoc cref="SetRemapTable(ColorAdjustType, ReadOnlySpan{ColorMap})"/>
//      public procedure SetRemapTable(const &type: TGdipColorAdjustType; const map: TReadOnlySpan<T(Color OldColor, Color NewColor)>); overload;
//
//
      public procedure ClearRemapTable(); overload;


      public procedure ClearRemapTable(const &type: TGdipColorAdjustType); overload;


//      public procedure SetBrushRemapTable(const map: TArray<TGdipColorMap>); overload;
//
//      // #if NET9_0_OR_GREATER -> IfDirectiveTrivia
//
//      public procedure SetBrushRemapTable(const map: TReadOnlySpan<TGdipColorMap>); overload;
//
//
//      public procedure SetBrushRemapTable(const map: TReadOnlySpan<T(Color OldColor, Color NewColor)>); overload;
//      // #endif -> EndIfDirectiveTrivia


      public procedure ClearBrushRemapTable();


      public procedure SetWrapMode(const mode: TGdipWrapMode); overload;


      public procedure SetWrapMode(const mode: TGdipWrapMode; const color: TGdipColor); overload;


      public procedure SetWrapMode(const mode: TGdipWrapMode; const color: TGdipColor; const clamp: Boolean); overload;


//      public procedure GetAdjustedPalette(const palette: TGdipColorPalette; const &type: TGdipColorAdjustType);
   end;

   { TGdipImageAttributesExtensions }

   TGdipImageAttributesExtensions = class helper for TGdipImageAttributes
      public function Pointer(): TGdiplusAPI.TGdipImageAttributesPtr;
   end;


   { TGdipTextureBrush }

   TGdipTextureBrush = class sealed(TGdipBrush)

      strict private class constructor Create();
      public procedure AfterConstruction; override;
      public procedure BeforeDestruction; override;

      strict private function GetTransform(): TGdipMatrix;
      strict private procedure SetTransform(const Value: TGdipMatrix);


      public property Transform: TGdipMatrix read GetTransform write SetTransform;
      strict private function GetWrapMode(): TGdipWrapMode;
      strict private procedure SetWrapMode(const Value: TGdipWrapMode);


      public property WrapMode: TGdipWrapMode read GetWrapMode write SetWrapMode;
      strict private function GetImage(): TGdipImage;


      public property Image: TGdipImage read GetImage;
      // When creating a texture brush from a metafile image, the dstRect
      // is used to specify the size that the metafile image should be
      // rendered at in the device units of the destination graphics.
      // It is NOT used to crop the metafile image, so only the width
      // and height values matter for metafiles.


      public constructor Create(const bitmap: TGdipImage); overload;


      public constructor Create(const image: TGdipImage; const wrapMode: TGdipWrapMode); overload;


      public constructor Create(const image: TGdipImage; const wrapMode: TGdipWrapMode; const dstRect: TRectangleF); overload;


      public constructor Create(const image: TGdipImage; const wrapMode: TGdipWrapMode; const dstRect: TRectangle); overload;


      public constructor Create(const image: TGdipImage; const dstRect: TRectangleF); overload;


      public constructor Create(const image: TGdipImage; const dstRect: TRectangleF; const imageAttr: TGdipImageAttributes); overload;


      public constructor Create(const image: TGdipImage; const dstRect: TRectangle); overload;


      public constructor Create(const image: TGdipImage; const dstRect: TRectangle; const imageAttr: TGdipImageAttributes); overload;


      protected constructor Create(const nativeBrush: TGdiplusAPI.TGdipTexturePtr); overload;


      public function Clone(): TObject; override;


      public procedure ResetTransform();


      public procedure MultiplyTransform(const matrix: TGdipMatrix); overload;


      public procedure MultiplyTransform(const matrix: TGdipMatrix; const order: TGdipMatrixOrder); overload;


      public procedure TranslateTransform(const dx: Single; const dy: Single); overload;


      public procedure TranslateTransform(const dx: Single; const dy: Single; const order: TGdipMatrixOrder); overload;


      public procedure ScaleTransform(const sx: Single; const sy: Single); overload;


      public procedure ScaleTransform(const sx: Single; const sy: Single; const order: TGdipMatrixOrder); overload;


      public procedure RotateTransform(const angle: Single); overload;


      public procedure RotateTransform(const angle: Single; const order: TGdipMatrixOrder); overload;
   end;

   { TGdipHatchBrush }

   TGdipHatchBrush = class sealed(TGdipBrush)

      strict private function GetHatchStyle(): TGdipHatchStyle;


      public property HatchStyle: TGdipHatchStyle read GetHatchStyle;
      strict private function GetForegroundColor(): TGdipColor;


      public property ForegroundColor: TGdipColor read GetForegroundColor;
      strict private function GetBackgroundColor(): TGdipColor;


      public property BackgroundColor: TGdipColor read GetBackgroundColor;

      public constructor Create(const hatchstyle: TGdipHatchStyle; const foreColor: TGdipColor); overload;


      public constructor Create(const hatchstyle: TGdipHatchStyle; const foreColor: TGdipColor; const backColor: TGdipColor); overload;


      protected constructor Create(const nativeBrush: TGdiplusAPI.TGdipHatchPtr); overload;


      public function Clone(): TObject; override;
   end;


   { TGdipPathData }

   /// <summary>Contém os dados de gráficos que compõem um objeto <see cref="T:System.Drawing.Drawing2D.GraphicsPath" />. Essa classe não pode ser herdada.</summary>
   TGdipPathData = class sealed
      private m_Points: TArray<TPointF>;
      private m_Types: TArray<Byte>;

		/// <summary>Obtém ou define uma matriz de estruturas <see cref="T:System.Drawing.PointF" /> que representa os pontos pelos quais o caminho é construído.</summary>
		/// <returns>Uma matriz de <see cref="T:System.Drawing.PointF" /> objetos que representa os pontos por meio do qual o caminho é construído.</returns>
      public property Points: TArray<TPointF> read m_Points write m_Points;

		/// <summary>Obtém ou define os tipos dos pontos correspondentes no caminho.</summary>
		/// <returns>Uma matriz de bytes que especifica os tipos dos pontos correspondentes no caminho.</returns>
      public property Types: TArray<Byte> read m_Types write m_Types;
   end;

   { TGdipFontCollection }

   /// <summary>
   ///  When inherited, enumerates the FontFamily objects in a collection of fonts.
   /// </summary>
   TGdipFontCollection = class abstract
      protected _nativeFontCollection: TGdiplusAPI.TGdipFontCollectionPtr;

      strict private function GetFamilies(): TArray<TGdipFontFamily>;

      /// <summary>
      ///  Gets the array of <see cref='FontFamily'/> objects associated with this <see cref='TGdipFontCollection'/>.
      /// </summary>
      public property Families: TArray<TGdipFontFamily> read GetFamilies;


      strict protected constructor Create(); virtual;
      public destructor Destroy(); override;

      /// <summary>
      ///  Disposes of this <see cref='TGdipFontCollection'/>
      /// </summary>
      public procedure Dispose(); overload;


      strict protected procedure Dispose(const disposing: Boolean); overload; virtual; abstract;
   end;


   { TGdipFontFamily }

   /// <summary>
   ///  Abstracts a group of type faces having a similar basic design but having certain variation in styles.
   /// </summary>
   TGdipFontFamily = class sealed
      strict private const NeutralLanguage: Integer = 0;

      strict private _nativeFamily: TGdiplusAPI.TGdipFontFamilyPtr;

      strict private _createDefaultOnFail: Boolean;
      strict private class constructor Create();
      public procedure AfterConstruction; override;
      public procedure BeforeDestruction; override;

      strict private function GetNativeFamily(): TGdiplusAPI.TGdipFontFamilyPtr;


      protected property NativeFamily: TGdiplusAPI.TGdipFontFamilyPtr read GetNativeFamily;
      strict private class function GetCurrentLanguage(): Integer; static;


      strict private class property CurrentLanguage: Integer read GetCurrentLanguage;
      strict private function GetName(): string; overload;

      /// <summary>
      ///  Gets the name of this <see cref='TGdipFontFamily'/>.
      /// </summary>
      public property Name: string read GetName;

      /// <summary>
      ///  Gets the name of this <see cref='TGdipFontFamily'/>.
      /// </summary>
      public property FamilyName: string read GetName;

      strict private class function GetFamilies(): TArray<TGdipFontFamily>; overload; static;

      /// <summary>
      ///  Returns an array that contains all of the <see cref='TGdipFontFamily'/> objects associated with the current
      ///  graphics context.
      /// </summary>
      public class property Families: TArray<TGdipFontFamily> read GetFamilies;
      strict private class function GetGenericSansSerif(): TGdipFontFamily; static;

      /// <summary>
      ///  Gets a generic SansSerif <see cref='TGdipFontFamily'/>.
      /// </summary>
      public class property GenericSansSerif: TGdipFontFamily read GetGenericSansSerif;
      strict private class function GetGenericSerif(): TGdipFontFamily; static;

      /// <summary>
      ///  Gets a generic Serif <see cref='TGdipFontFamily'/>.
      /// </summary>
      public class property GenericSerif: TGdipFontFamily read GetGenericSerif;
      strict private class function GetGenericMonospace(): TGdipFontFamily; static;

      /// <summary>
      ///  Gets a generic monospace <see cref='TGdipFontFamily'/>.
      /// </summary>
      public class property GenericMonospace: TGdipFontFamily read GetGenericMonospace;


      protected constructor Create(const family: TGdiplusAPI.TGdipFontFamilyPtr); overload;

      /// <summary>
      ///  Initializes a new instance of the <see cref='TGdipFontFamily'/> class with the specified name.
      /// </summary>
      /// <param name="createDefaultOnFail">
      ///  Determines how errors are handled when creating a font based on a font family that does not exist on the end
      ///  user's system at run time. If this parameter is true, then a fall-back font will always be used instead.
      ///  If this parameter is false, an exception will be thrown.
      /// </param>
      protected constructor Create(const name: string; const createDefaultOnFail: Boolean); overload;

      /// <summary>
      ///  Initializes a new instance of the <see cref='TGdipFontFamily'/> class with the specified name.
      /// </summary>
      public constructor Create(const name: string); overload;

      /// <summary>
      ///  Initializes a new instance of the <see cref='TGdipFontFamily'/> class in the specified
      ///  <see cref='FontCollection'/> and with the specified name.
      /// </summary>
      public constructor Create(const name: string; const fontCollection: TGdipFontCollection); overload;

      /// <summary>
      ///  Initializes a new instance of the <see cref='TGdipFontFamily'/> class from the specified generic font family.
      /// </summary>
      public constructor Create(const genericFamily: TGdipGenericFontFamilies); overload;

      public destructor Destroy(); override;

      strict private procedure SetNativeFamily(const family: TGdiplusAPI.TGdipFontFamilyPtr);

      // Creates the native font family object.
      // Note: GDI+ creates singleton font family objects (from the corresponding font file) and reference count them.

      strict private procedure CreateFontFamily(const name: string; const fontCollection: TGdipFontCollection);

      /// <summary>
      /// Converts this <see cref='TGdipFontFamily'/> to a human-readable string.
      /// </summary>
      public function ToString(): string; override;


      public function Equals(obj: TObject): Boolean; override;

      /// <summary>
      ///  Disposes of this <see cref='TGdipFontFamily'/>.
      /// </summary>
      public procedure Dispose(); overload;


      strict private procedure Dispose(const disposing: Boolean); overload;

      /// <summary>
      ///  Returns the name of this <see cref='TGdipFontFamily'/> in the specified language.
      /// </summary>
      public function GetName(const language: LangID = 0): string; overload;


      strict private class function GetGdipGenericSansSerif(): TGdiplusAPI.TGdipFontFamilyPtr; static;

      /// <summary>
      ///  Returns an array that contains all of the <see cref='TGdipFontFamily'/> objects associated with the specified
      ///  graphics context.
      /// </summary>
      public class function GetFamilies(const graphics: TGdipGraphics): TArray<TGdipFontFamily>; overload; static; //      [Obsolete("TGdipFontFamily.GetFamilies has been deprecated. Use Families instead.")]

      /// <summary>
      ///  Indicates whether the specified <see cref='FontStyle'/> is available.
      /// </summary>
      public function IsStyleAvailable(const style: TGdipFontStyle): Boolean;

      /// <summary>
      ///  Essa função retorna o tamanho do quadrado Em para o estilo especificado em unidades de design de fonte.
      /// </summary>
      public function GetEmHeight(const style: TGdipFontStyle): Integer;

      /// <summary>
      ///  Essa função retorna a métrica de ascensão para o Windows.
      /// </summary>
      public function GetCellAscent(const style: TGdipFontStyle): Integer;

      /// <summary>
      ///  Essa função retorna a métrica de descenso para o Windows.
      /// </summary>
      public function GetCellDescent(const style: TGdipFontStyle): Integer;

      /// <summary>
      ///  Essa função retorna a distância entre duas linhas consecutivas de texto para esta TGdipFontFamily com o estilo de fonte especificado.
      /// </summary>
      public function GetLineSpacing(const style: TGdipFontStyle): Integer;
   end;


   { TGdipInstalledFontCollection }

   /// <summary>
   ///  Representa as fontes instaladas no sistema.
   /// </summary>
   TGdipInstalledFontCollection = class sealed(TGdipFontCollection)

      /// <summary>
      ///  Inicializa uma nova instância da classe <see cref='TGdipInstalledFontCollection'/>.
      /// </summary>
      public constructor Create(); override;

      strict protected procedure Dispose(const disposing: Boolean); override;
   end;


{$REGION 'TGdipStringFormat'}

   { TGdipStringFormat }

   /// <summary>
   ///  Encapsulates text layout information (such as alignment and linespacing), display manipulations (such as
   ///  ellipsis insertion and national digit substitution) and OpenType features.
   /// </summary>
   TGdipStringFormat = class sealed

      protected _nativeFormat: TGdiplusAPI.TGdipStringFormatPtr;
      strict private function GetFormatFlags(): TGdipStringFormatFlags;
      strict private procedure SetFormatFlags(const Value: TGdipStringFormatFlags);

      /// <summary>
      ///  Gets or sets a <see cref='StringFormatFlags'/> that contains formatting information.
      /// </summary>
      public property FormatFlags: TGdipStringFormatFlags read GetFormatFlags write SetFormatFlags;
      strict private function GetAlignment(): TGdipStringAlignment;
      strict private procedure SetAlignment(const Value: TGdipStringAlignment);

      /// <summary>
      ///  Specifies text alignment information.
      /// </summary>
      public property Alignment: TGdipStringAlignment read GetAlignment write SetAlignment;
      strict private function GetLineAlignment(): TGdipStringAlignment;
      strict private procedure SetLineAlignment(const Value: TGdipStringAlignment);

      /// <summary>
      ///  Gets or sets the line alignment.
      /// </summary>
      public property LineAlignment: TGdipStringAlignment read GetLineAlignment write SetLineAlignment;
      strict private function GetHotkeyPrefix(): TGdipHotkeyPrefix;
      strict private procedure SetHotkeyPrefix(const Value: TGdipHotkeyPrefix);

      /// <summary>
      ///  Gets or sets the <see cref='HotkeyPrefix'/> for this <see cref='TGdipStringFormat'/> .
      /// </summary>
      public property HotkeyPrefix: TGdipHotkeyPrefix read GetHotkeyPrefix write SetHotkeyPrefix;
      strict private function GetTrimming(): TGdipStringTrimming;
      strict private procedure SetTrimming(const Value: TGdipStringTrimming);

      // String trimming. How to handle more text than can be displayed
      // in the limits available.

      /// <summary>
      ///  Gets or sets the <see cref='StringTrimming'/> for this <see cref='TGdipStringFormat'/>.
      /// </summary>
      public property Trimming: TGdipStringTrimming read GetTrimming write SetTrimming;
      strict private class function GetGenericDefault(): TGdipStringFormat; static;

      /// <summary>
      ///  Gets a generic default <see cref='TGdipStringFormat'/>.
      /// </summary>
      /// <devdoc>
      ///  Remarks from MSDN: A generic, default TGdipStringFormat object has the following characteristics:
      ///
      ///     - No string format flags are set.
      ///     - Character alignment and line alignment are set to StringAlignmentNear.
      ///     - Language ID is set to neutral language, which means that the current language associated with the calling thread is used.
      ///     - String digit substitution is set to StringDigitSubstituteUser.
      ///     - Hot key prefix is set to HotkeyPrefixNone.
      ///     - Number of tab stops is set to zero.
      ///     - String trimming is set to StringTrimmingCharacter.
      /// </devdoc>
      public class property GenericDefault: TGdipStringFormat read GetGenericDefault;
      strict private class function GetGenericTypographic(): TGdipStringFormat; static;

      /// <summary>
      ///  Gets a generic typographic <see cref='TGdipStringFormat'/>.
      /// </summary>
      /// <devdoc>
      ///  Remarks from MSDN: A generic, typographic TGdipStringFormat object has the following characteristics:
      ///
      ///     - String format flags StringFormatFlagsLineLimit, StringFormatFlagsNoClip, and StringFormatFlagsNoFitBlackBox are set.
      ///     - Character alignment and line alignment are set to StringAlignmentNear.
      ///     - Language ID is set to neutral language, which means that the current language associated with the calling thread is used.
      ///     - String digit substitution is set to StringDigitSubstituteUser.
      ///     - Hot key prefix is set to HotkeyPrefixNone.
      ///     - Number of tab stops is set to zero.
      ///     - String trimming is set to StringTrimmingNone.
      /// </devdoc>
      public class property GenericTypographic: TGdipStringFormat read GetGenericTypographic;
      strict private function GetDigitSubstitutionMethod(): TGdipStringDigitSubstitute;

      /// <summary>
      ///  Gets the <see cref='StringDigitSubstitute'/> for this <see cref='TGdipStringFormat'/>.
      /// </summary>
      public property DigitSubstitutionMethod: TGdipStringDigitSubstitute read GetDigitSubstitutionMethod;
      strict private function GetDigitSubstitutionLanguage(): Integer;

      /// <summary>
      ///  Gets the language of <see cref='StringDigitSubstitute'/> for this <see cref='TGdipStringFormat'/>.
      /// </summary>
      public property DigitSubstitutionLanguage: Integer read GetDigitSubstitutionLanguage;


      strict private constructor Create(const format: TGdiplusAPI.TGdipStringFormatPtr); overload;

      /// <summary>
      ///  Initializes a new instance of the <see cref='TGdipStringFormat'/> class.
      /// </summary>
      public constructor Create(); overload;

      /// <summary>
      ///  Initializes a new instance of the <see cref='TGdipStringFormat'/> class with the specified <see cref='StringFormatFlags'/>.
      /// </summary>
      public constructor Create(const options: TGdipStringFormatFlags); overload;

      /// <summary>
      ///  Initializes a new instance of the <see cref='TGdipStringFormat'/> class with the specified
      ///  <see cref='StringFormatFlags'/> and language.
      /// </summary>
      public constructor Create(const options: TGdipStringFormatFlags; const language: Integer); overload;

      /// <summary>
      ///  Initializes a new instance of the <see cref='TGdipStringFormat'/> class from the specified
      ///  existing <see cref='TGdipStringFormat'/>.
      /// </summary>
      public constructor Create(const format: TGdipStringFormat); overload;
      public destructor Destroy(); override;

      /// <summary>
      ///  Cleans up Windows resources for this <see cref='TGdipStringFormat'/>.
      /// </summary>
      public procedure Dispose(); overload;


      strict private procedure Dispose(const disposing: Boolean); overload;

      /// <summary>
      ///  Creates an exact copy of this <see cref='TGdipStringFormat'/>.
      /// </summary>
      public function Clone(): TObject;

      /// <summary>
      ///  Sets the measure of characters to the specified range.
      /// </summary>
      public procedure SetMeasurableCharacterRanges(const ranges: TArray<TGdipCharacterRange>);

      /// <summary>
      ///  Sets tab stops for this <see cref='TGdipStringFormat'/>.
      /// </summary>
      public procedure SetTabStops(const firstTabOffset: Single; const tabStops: TArray<Single>);

      /// <summary>
      ///  Gets the tab stops for this <see cref='TGdipStringFormat'/>.
      /// </summary>
      public function GetTabStops(out firstTabOffset: Single): TArray<Single>;


      public procedure SetDigitSubstitution(const language: Integer; const substitute: TGdipStringDigitSubstitute);


      protected function GetMeasurableCharacterRangeCount(): Integer;

      /// <summary>
      ///  Converts this <see cref='TGdipStringFormat'/> to a human-readable string.
      /// </summary>
      public function ToString(): string; override;
   end;

   { TGdipStringFormatExtensions }

   TGdipStringFormatExtensions = class helper for TGdipStringFormat
      public function Pointer(): TGdiplusAPI.TGdipStringFormatPtr;
   end;

{$ENDREGION 'TGdipStringFormat'}


{$REGION 'TGdipFont'}

   { TGdipFont }

   /// <summary>
   /// Defines a particular format for text, including font face, size, and style attributes.
   /// </summary>
   TGdipFont = class sealed//(TMarshalByRefObject, ICloneable, IDisposable, ISerializable)


      strict private _nativeFont: TGdiplusapi.TGdipFontPtr;

      strict private _fontSize: Single;

      strict private _fontStyle: TGdipFontStyle;

      strict private _fontFamily: TGdipFontFamily;

      strict private _fontUnit: TGdipGraphicsUnit;

      strict private _gdiCharSet: Byte;

      strict private _gdiVerticalFont: Boolean;

      strict private _systemFontName: string;

      strict private _originalFontName: string;
      public procedure AfterConstruction; override;

      strict private function GetSize(): Single;

      // Return value is in Unit (the unit the font was created in)
      /// <summary>
    /// Gets the size of this <see cref='Font'/>.
    /// </summary>
      public property Size: Single read GetSize;
      strict private function GetStyle(): TGdipFontStyle;

      /// <summary>
    /// Gets style information for this <see cref='Font'/>.
    /// </summary>
      public property Style: TGdipFontStyle read GetStyle;
      strict private function GetBold(): Boolean;

      /// <summary>
    /// Gets a value indicating whether this <see cref='Font'/> is bold.
    /// </summary>
      public property Bold: Boolean read GetBold;
      strict private function GetItalic(): Boolean;

      /// <summary>
    /// Gets a value indicating whether this <see cref='Font'/> is Italic.
    /// </summary>
      public property Italic: Boolean read GetItalic;
      strict private function GetStrikeout(): Boolean;

      /// <summary>
    /// Gets a value indicating whether this <see cref='Font'/> is strikeout (has a line through it).
    /// </summary>
      public property Strikeout: Boolean read GetStrikeout;
      strict private function GetUnderline(): Boolean;

      /// <summary>
    /// Gets a value indicating whether this <see cref='Font'/> is underlined.
    /// </summary>
      public property Underline: Boolean read GetUnderline;
      strict private function GetFontFamily(): TGdipFontFamily;

      /// <summary>
    /// Gets the <see cref='Drawing.FontFamily'/> of this <see cref='Font'/>.
    /// </summary>
      public property FontFamily: TGdipFontFamily read GetFontFamily;
      strict private function GetName(): string;

      /// <summary>
    /// Gets the face name of this <see cref='Font'/> .
    /// </summary>
      public property Name: string read GetName;
      strict private function GetUnit(): TGdipGraphicsUnit;

      /// <summary>
    /// Gets the unit of measure for this <see cref='Font'/>.
    /// </summary>
      public property Unit_: TGdipGraphicsUnit read GetUnit;
      strict private function GetGdiCharSet(): Byte;

      /// <summary>
    /// Returns the GDI char set for this instance of a font. This will only
    /// be valid if this font was created from a classic GDI font definition,
    /// like a LOGFONT or HFONT, or it was passed into the constructor.
    ///
    /// This is here for compatibility with native Win32 intrinsic controls
    /// on non-Unicode platforms.
    /// </summary>
      public property GdiCharSet: Byte read GetGdiCharSet;
      strict private function GetGdiVerticalFont(): Boolean;

      /// <summary>
    /// Determines if this font was created to represent a GDI vertical font. This will only be valid if this font
    /// was created from a classic GDIfont definition, like a LOGFONT or HFONT, or it was passed into the constructor.
    ///
    /// This is here for compatibility with native Win32 intrinsic controls on non-Unicode platforms.
    /// </summary>
      public property GdiVerticalFont: Boolean read GetGdiVerticalFont;
      strict private function GetOriginalFontName(): string;

      /// <summary>
    /// This property is required by the framework and not intended to be used directly.
    /// </summary>
      public property OriginalFontName: string read GetOriginalFontName;
      strict private function GetSystemFontName(): string;

      /// <summary>
    /// Gets the name of this <see cref='Font'/>.
    /// </summary>
      public property SystemFontName: string read GetSystemFontName;
      strict private function GetIsSystemFont(): Boolean;

      /// <summary>
    /// Returns true if this <see cref='Font'/> is a SystemFont.
    /// </summary>
      public property IsSystemFont: Boolean read GetIsSystemFont;
      strict private function GetFontHeight(): Integer;

      /// <summary>
    /// Gets the height of this <see cref='Font'/>.
    /// </summary>
      public property Height: Integer read GetFontHeight;
      strict private function GetNativeFont(): TGdiplusapi.TGdipFontPtr;

      /// <summary>
    ///  Get native GDI+ object pointer. This property triggers the creation of the GDI+ native object if not initialized yet.
    /// </summary>
      protected property NativeFont: TGdiplusapi.TGdipFontPtr read GetNativeFont;
      strict private function GetSizeInPoints(): Single;

      /// <summary>
    /// Gets the size, in points, of this <see cref='Font'/>.
    /// </summary>
      public property SizeInPoints: Single read GetSizeInPoints;


//      strict private constructor Create(const info: TSerializationInfo; const context: TStreamingContext); overload;

      /// <summary>
    /// Initializes a new instance of the <see cref='Font'/> class from the specified existing <see cref='Font'/>
    /// and <see cref='FontStyle'/>.
    /// </summary>
      public constructor Create(const prototype: TGdipFont; const newStyle: TGdipFontStyle); overload;

      /// <summary>
    /// Initializes a new instance of the <see cref='Font'/> class with the specified attributes.
    /// </summary>
      public constructor Create(const family: TGdipFontFamily; const emSize: Single; const style: TGdipFontStyle; const unit_: TGdipGraphicsUnit); overload;

      /// <summary>
    /// Initializes a new instance of the <see cref='Font'/> class with the specified attributes.
    /// </summary>
      public constructor Create(const family: TGdipFontFamily; const emSize: Single; const style: TGdipFontStyle; const unit_: TGdipGraphicsUnit; const gdiCharSet: Byte); overload;

      /// <summary>
    /// Initializes a new instance of the <see cref='Font'/> class with the specified attributes.
    /// </summary>
      public constructor Create(const family: TGdipFontFamily; const emSize: Single; const style: TGdipFontStyle; const unit_: TGdipGraphicsUnit; const gdiCharSet: Byte; const gdiVerticalFont: Boolean); overload;

      /// <summary>
    /// Initializes a new instance of the <see cref='Font'/> class with the specified attributes.
    /// </summary>
      public constructor Create(const familyName: string; const emSize: Single; const style: TGdipFontStyle; const unit_: TGdipGraphicsUnit; const gdiCharSet: Byte); overload;

      /// <summary>
    /// Initializes a new instance of the <see cref='Font'/> class with the specified attributes.
    /// </summary>
      public constructor Create(const familyName: string; const emSize: Single; const style: TGdipFontStyle; const unit_: TGdipGraphicsUnit; const gdiCharSet: Byte; const gdiVerticalFont: Boolean); overload;

      /// <summary>
    /// Initializes a new instance of the <see cref='Font'/> class with the specified attributes.
    /// </summary>
      public constructor Create(const family: TGdipFontFamily; const emSize: Single; const style: TGdipFontStyle); overload;

      /// <summary>
    /// Initializes a new instance of the <see cref='Font'/> class with the specified attributes.
    /// </summary>
      public constructor Create(const family: TGdipFontFamily; const emSize: Single; const unit_: TGdipGraphicsUnit); overload;

      /// <summary>
    /// Initializes a new instance of the <see cref='Font'/> class with the specified attributes.
    /// </summary>
      public constructor Create(const family: TGdipFontFamily; const emSize: Single); overload;

      /// <summary>
    /// Initializes a new instance of the <see cref='Font'/> class with the specified attributes.
    /// </summary>
      public constructor Create(const familyName: string; const emSize: Single; const style: TGdipFontStyle; const unit_: TGdipGraphicsUnit); overload;

      /// <summary>
    /// Initializes a new instance of the <see cref='Font'/> class with the specified attributes.
    /// </summary>
      public constructor Create(const familyName: string; const emSize: Single; const style: TGdipFontStyle); overload;

      /// <summary>
    /// Initializes a new instance of the <see cref='Font'/> class with the specified attributes.
    /// </summary>
      public constructor Create(const familyName: string; const emSize: Single; const unit_: TGdipGraphicsUnit); overload;

      /// <summary>
    /// Initializes a new instance of the <see cref='Font'/> class with the specified attributes.
    /// </summary>
      public constructor Create(const familyName: string; const emSize: Single); overload;

      /// <summary>
    /// Constructor to initialize fields from an existing native GDI+ object reference. Used by ToLogFont.
    /// </summary>
      strict private constructor Create(const nativeFont: TGdiplusapi.TGdipFontPtr; const gdiCharSet: Byte; const gdiVerticalFont: Boolean); overload;

      /// <summary>
    /// Cleans up Windows resources for this <see cref='Font'/>.
    /// </summary>
      public destructor Destroy(); override;


//      public procedure GetObjectData(const si: TSerializationInfo; const context: TStreamingContext);


      strict private class function IsVerticalName(const familyName: string): Boolean; static;

      /// <summary>
    /// Cleans up Windows resources for this <see cref='Font'/>.
    /// </summary>
      public procedure Dispose(); overload;


      strict private procedure Dispose(const disposing: Boolean); overload;

      /// <summary>
    ///  Returns the height of this Font in the specified graphics context.
    /// </summary>
      public function GetHeight(const graphics: TGdipGraphics): Single; overload;


      public function GetHeight(const dpi: Single): Single; overload;

      /// <summary>
    /// Returns a value indicating whether the specified object is a <see cref='Font'/> equivalent to this
    /// <see cref='Font'/>.
    /// </summary>
      public function Equals(obj: TObject): Boolean; override;

      /// <summary>
    /// Returns a human-readable string representation of this <see cref='Font'/>.
    /// </summary>
      public function ToString(): string; override;

      // This is used by SystemFonts when constructing a system Font objects.

      protected procedure SetSystemFontName(const systemFontName: string);


//      public procedure ToLogFont(const logFont: TObject; const graphics: TGdipGraphics); overload;

      // #if NET8_0_OR_GREATER -> IfDirectiveTrivia

      public procedure ToLogFont(out logFont: TLogFontW; const graphics: TGdipGraphics); overload;

      /// <summary>
    ///  Creates the GDI+ native font object.
    /// </summary>
      strict private procedure CreateNativeFont();

      /// <summary>
    /// Initializes this object's fields.
    /// </summary>
      strict private procedure Initialize(const familyName: string; const emSize: Single; const style: TGdipFontStyle; const unit_: TGdipGraphicsUnit; const gdiCharSet: Byte; const gdiVerticalFont: Boolean); overload;

      /// <summary>
    /// Initializes this object's fields.
    /// </summary>
      strict private procedure Initialize(const family: TGdipFontFamily; const emSize: Single; const style: TGdipFontStyle; const unit_: TGdipGraphicsUnit; const gdiCharSet: Byte; const gdiVerticalFont: Boolean); overload;

      /// <summary>
    /// Creates a <see cref='Font'/> from the specified Windows handle.
    /// </summary>
      public class function FromHfont(const hfont: HFONT): TGdipFont; static;

      /// <summary>
    /// Creates a <see cref="Font"/> from the given LOGFONT using the screen device context.
    /// </summary>
    /// <param name="lf">A boxed LOGFONT.</param>
    /// <returns>The newly created <see cref="Font"/>.</returns>
//      public class function FromLogFont(const lf: TObject): TGdipFont; overload; static;

      // #if NET8_0_OR_GREATER -> IfDirectiveTrivia

      public class function FromLogFont(const logFont: TLogFontW): TGdipFont; overload; static;

      // #if NET8_0_OR_GREATER -> IfDirectiveTrivia

      public class function FromLogFont(const logFont: TLogFontW; const hdc: TDeviceContextHandle): TGdipFont; overload; static;

      /// <summary>
    ///  Creates a <see cref="Font"/> from the given LOGFONT using the given device context.
    /// </summary>
    /// <param name="lf">A boxed LOGFONT.</param>
    /// <param name="hdc">Handle to a device context (HDC).</param>
    /// <returns>The newly created <see cref="Font"/>.</returns>
//      public class function FromLogFont(const lf: TObject; const hdc: TDeviceContextHandle): TGdipFont; overload; static;

      /// <summary>
    /// Creates a <see cref="Font"/> from the specified handle to a device context (HDC).
    /// </summary>
    /// <returns>The newly created <see cref="Font"/>.</returns>
      public class function FromHdc(const hdc: TDeviceContextHandle): TGdipFont; static;

      /// <summary>
    ///  Creates an exact copy of this <see cref='Font'/>.
    /// </summary>
      public function Clone(): TObject;


      strict private procedure SetFontFamily(const family: TGdipFontFamily);


      strict private class function StripVerticalName(const familyName: string): string; static;


//      public procedure ToLogFont(const logFont: TObject); overload;

      // #if NET8_0_OR_GREATER -> IfDirectiveTrivia

      public procedure ToLogFont(out logFont: TLogFontW); overload;
      // #endif -> EndIfDirectiveTrivia

      /// <summary>
    ///  Returns a handle to this <see cref='Font'/>.
    /// </summary>
      public function ToHfont(): HFONT;

      public function GetHeight(): Single; overload;
   end;

{$ENDREGION 'TGdipFont'}


   { TGdipBitmapData }

   /// <summary>
   ///  Specifies the attributes of a bitmap image.
   /// </summary>
   TGdipBitmapData = packed class


      strict private _width: Integer;

      strict private _height: Integer;

      strict private _stride: Integer;

      strict private _pixelFormat: TGdipPixelFormat;

      strict private _scan0: Pointer;

      strict private _reserved: Integer;
      strict private class constructor CreateClass();
      strict private class destructor DestroyClass();

      strict private function GetWidth(): Integer;
      strict private procedure SetWidth(const Value: Integer);

      /// <summary>
    ///  Specifies the pixel width of the <see cref='Bitmap'/>.
    /// </summary>
      public property Width: Integer read GetWidth write SetWidth;
      strict private function GetHeight(): Integer;
      strict private procedure SetHeight(const Value: Integer);

      /// <summary>
    ///  Specifies the pixel height of the <see cref='Bitmap'/>.
    /// </summary>
      public property Height: Integer read GetHeight write SetHeight;
      strict private function GetStride(): Integer;
      strict private procedure SetStride(const Value: Integer);

      /// <summary>
    ///  Specifies the stride width of the <see cref='Bitmap'/>.
    /// </summary>
      public property Stride: Integer read GetStride write SetStride;
      strict private function GetPixelFormat(): TGdipPixelFormat;
      strict private procedure SetPixelFormat(const Value: TGdipPixelFormat);

      /// <summary>
    ///  Specifies the format of the pixel information in this <see cref='Bitmap'/>.
    /// </summary>
      public property PixelFormat: TGdipPixelFormat read GetPixelFormat write SetPixelFormat;
      strict private function GetScan0(): Pointer;
      strict private procedure SetScan0(const Value: Pointer);

      /// <summary>
    ///  Specifies the address of the pixel data.
    /// </summary>
      public property Scan0: Pointer read GetScan0 write SetScan0;
      strict private function GetReserved(): Integer;
      strict private procedure SetReserved(const Value: Integer);

      /// <summary>
    ///  Reserved. Do not use.
    /// </summary>
      public property Reserved: Integer read GetReserved write SetReserved;


      private function GetPinnableReference(): PInteger;
   end;


{$REGION 'TGdipIcon'}

   { TGdipIcon }

   TGdipIcon = class sealed//(TMarshalByRefObject, ICloneable, IDisposable, ISerializable, IHandle<HICON>) (* partial *)

      strict protected type

      {$REGION 'TOle'}

            { TOle }

            TOle = class sealed (* static *)
               public const PICTYPE_ICON: Integer = 3;
            end;

      {$ENDREGION 'TOle'}

      {$IFDEF FINALIZATION_WATCH}
      strict private m_allocationSite: string;
      {$ENDIF FINALIZATION_WATCH}


//      strict private class var s_bitDepth: Int32;

      // A assinatura PNG é especificada em http://www.w3.org/TR/PNG/#5PNG-file-signature
      strict private const PNGSignature1: Integer = 137 + (Ord('P') shl 8) + (Ord('N') shl 16) + (Ord('G') shl 24);
      strict private const PNGSignature2: Integer = 13 + (10 shl 8) + (26 shl 16) + (10 shl 24);

      // Icon data
      strict private _iconData: TArray<Byte>;
      strict private _bestImageOffset: UInt32;
      strict private _bestBitDepth: UInt32;
      strict private _bestBytesInRes: UInt32;
      strict private _isBestImagePng: Boolean;
      strict private m_iconSize: TSize;
      strict private _handle: HICON;
      strict private _ownHandle: Boolean;

      public procedure AfterConstruction; override;
      public procedure BeforeDestruction; override;

      strict private function GetHandle(): HICON;
      public property Handle: HICON read GetHandle;

      strict private function GetHeight(): Integer;
      public property Height: Integer read GetHeight;

      strict private function GetSize(): TSize;
      public property Size: TSize read GetSize;

      strict private function GetWidth(): Integer;
      public property Width: Integer read GetWidth;

      protected constructor Create(const handle: HICON); overload;
      protected constructor Create(const handle: HICON; const takeOwnership: Boolean); overload;
      public constructor Create(const fileName: string); overload;
      public constructor Create(const fileName: string; const size: TSize); overload;
      public constructor Create(const fileName: string; const width: Integer; const height: Integer); overload;
      public constructor Create(const original: TGdipIcon; const size: TSize); overload;
      public constructor Create(const original: TGdipIcon; const width: Integer; const height: Integer); overload;
      public constructor Create(const stream: TStream); overload;
      public constructor Create(const stream: TStream; const size: TSize); overload;
      public constructor Create(const stream: TStream; const width: Integer; const height: Integer); overload;

      public destructor Destroy(); override;

      public class function ExtractAssociatedIcon(filePath: string): TGdipIcon; overload; static;
      strict private class function ExtractAssociatedIcon(filePath: string; const index: Integer): TGdipIcon; overload; static;

      public function Clone(): TObject;

      /// <summary>
      /// Chamado quando este objeto está prestes a destruir seu identificador Win32. Você
      /// pode sobrescrever isso se houver algo especial que você precisa fazer para
      /// destruir o identificador. Isso será chamado mesmo se o identificador não for
      /// propriedade deste objeto, o que é útil se você quiser criar uma
      /// classe derivada que tenha suas próprias semânticas de criação/destruição.
      ///
      /// A implementação padrão chamará a chamada Win32 apropriada
      /// para destruir o identificador se este objeto atualmente possuir o
      /// identificador. Não fará nada se o objeto atualmente não
      /// possuir o identificador.
      /// </summary>
      protected procedure DestroyHandle();
      public procedure Dispose(); overload;
      strict private procedure Dispose(const disposing: Boolean); overload;

      /// <summary>
      /// Desenha esta imagem em um objeto gráfico. O comando de desenho origina-se no objeto gráfico,
      /// mas um objeto gráfico geralmente não tem ideia de como renderizar uma determinada imagem. Então,
      /// ele passa a chamada para a imagem real. Esta versão recorta a imagem para as dimensões dadas
      /// e permite ao usuário especificar um retângulo dentro da imagem para desenhar.
      /// </summary>
      strict private procedure DrawIcon(const hdc: TDeviceContextHandle; const imageRect: TRectangle; const targetRect: TRectangle; const stretch: Boolean);


      protected procedure Draw(const graphics: TGdipGraphics; const x: Integer; const y: Integer); overload;

      /// <summary>
      /// Desenha esta imagem em um objeto gráfico. O comando de desenho origina-se no objeto gráfico,
      /// mas geralmente um objeto gráfico não sabe como renderizar uma imagem específica. Então,
      /// ele transfere a chamada para a imagem real. Esta versão estica a imagem para as dimensões dadas
      /// e permite ao usuário especificar um retângulo dentro da imagem para desenhar.
      /// </summary>
      protected procedure Draw(const graphics: TGdipGraphics; const targetRect: TRectangle); overload;

      /// <summary>
      /// Desenha esta imagem em um objeto gráfico. O comando de desenho origina-se no objeto gráfico,
      /// mas geralmente um objeto gráfico não sabe como renderizar uma imagem específica. Então,
      /// ele transfere a chamada para a imagem real. Esta versão estica a imagem para as dimensões dadas
      /// e permite ao usuário especificar um retângulo dentro da imagem para desenhar.
      /// </summary>
      protected procedure DrawUnstretched(const graphics: TGdipGraphics; const targetRect: TRectangle);


      public class function FromHandle(const handle: HICON): TGdipIcon; static;

      /// <summary>
      /// Inicializa este objeto Image. Isso é idêntico a chamar o construtor da imagem
      /// com uma imagem, mas isso permite inicialização fora do construtor,
      /// o que pode ser necessário em algumas instâncias.
      /// </summary>
      strict private procedure Initialize(width: Integer; height: Integer);


      strict private procedure CopyBitmapData(const sourceData: TGdipBitmapData; const targetData: TGdipBitmapData);


      strict private class function BitmapHasAlpha(const bmpData: TGdipBitmapData): Boolean; static;


      public function ToBitmap(): TGdipBitmap;


      strict private function BmpFrame(): TGdipBitmap;


      strict private function PngFrame(): TGdipBitmap;


      strict private function HasPngSignature(): Boolean;


      public function ToString(): string; override;

      // #if NET8_0_OR_GREATER -> IfDirectiveTrivia
      /// <summary>
      ///  Extrai um ícone especificado do <paramref name="filePath"/> fornecido.
      /// </summary>
      /// <remarks>
      ///  <para>
      ///   Diferentemente dos <see cref="Icon(string)">construtores que recebem um caminho</see>, este método e o
      ///   <see cref="ExtractAssociatedIcon(string)"/> métodos não retêm todos os dados do recurso ou modificam os
      ///   dados originais (fora do redimensionamento, se necessário). Como tal, o <see cref="Icon"/> usa apenas tanto
      ///   memória quanto necessário para o tamanho solicitado (principalmente memória nativa).
      ///  </para>
      ///  <para>
      ///   Sem os dados da fonte original, os <see cref="Icon(Icon, Size)">construtores de cópia</see> têm que reamostrar
      ///   o bitmap do ícone atual para mudar os tamanhos. Para melhor qualidade de imagem, se diferentes tamanhos para um <see cref="Icon"/>
      ///   são desejados, você deve criar instâncias separadas com este método e evitar os construtores de cópia.
      ///  </para>
      /// </remarks>
      /// <param name="filePath">Caminho para um arquivo de ícone ou PE (.dll, .exe).</param>
      /// <param name="id">
      ///  Números positivos referem-se a um índice de ícone no arquivo fornecido. Números negativos referem-se a um identificador de recurso nativo específico
      ///  em um arquivo PE (.dll, .exe).
      /// </param>
      /// <param name="size">
      ///  O tamanho desejado. Se o tamanho especificado não existir, um tamanho existente será reamostrado para fornecer o
      ///  tamanho solicitado.
      /// </param>
      /// <returns>
      ///  Um <see cref="Icon"/>, ou <see langword="null"/> se um ícone não puder ser encontrado com o <paramref name="id"/> especificado.
      /// </returns>
      /// <exception cref="ArgumentOutOfRangeException">
      ///  <paramref name="size"/> é negativo ou maior que <see cref="ushort.MaxValue"/>.
      /// </exception>
      /// <exception cref="IOException">
      ///  O <paramref name="filePath"/> fornecido não pôde ser acessado.
      /// </exception>
      /// <exception cref="ArgumentNullException">
      ///  <paramref name="filePath"/> é nulo.
      /// </exception>
      public class function ExtractIcon(const filePath: string; const id: Integer; const size: Integer): TGdipIcon; overload; static;

      /// <param name="smallIcon">
      ///  Se <see langword="true"/>, obtém o <see cref="Icon"/> no tamanho atual do sistema para ícones pequenos. Se
      ///  <see langword="false"/>, obtém o <see cref="Icon"/> no tamanho atual do sistema para ícones grandes. O padrão é
      ///  <see langword="false"/>.
      /// </param>
      /// <inheritdoc cref="ExtractIcon(string, int, int)" />
      public class function ExtractIcon(const filePath: string; const id: Integer; const smallIcon: Boolean = false): TGdipIcon; overload; static;


      strict private class function ExtractIcon(const filePath: string; const id: Integer; const size: Integer; const smallIcon: Boolean = false): TGdipIcon; overload; static;
   end;

{$ENDREGION 'TGdipIcon'}

{$REGION 'TGdipGraphicsState'}

   { TGdipGraphicsState }

   /// <summary>
   ///   Representa o estado de um objeto <see cref="T:System.Drawing.Graphics" />.
   ///   É retornado por uma chamada para os métodos <see cref="M:System.Drawing.Graphics.Save" />.
   /// </summary>
   TGdipGraphicsState = type UInt32;

{$ENDREGION 'TGdipGraphicsState'}

{$REGION 'TGdipGraphicsContainer'}

   { TGdipGraphicsContainer }

	/// <summary>
   ///   Representa os dados internos de um contêiner de gráfico.
   ///   É usada ao salvar o estado de um objeto <see cref="T:System.Drawing.Graphics" />
   ///   usando os métodos <see cref="M:System.Drawing.Graphics.BeginContainer" />
   ///   e <see cref="M:System.Drawing.Graphics.EndContainer(System.Drawing.Drawing2D.GraphicsContainer)" />.
   /// </summary>
   TGdipGraphicsContainer = type UInt32;

{$ENDREGION 'TGdipGraphicsContainer'}

{$REGION 'TGdipCachedBitmap'}

   { TGdipCachedBitmap }

   /// <summary>
   ///  A device dependent copy of a <see cref="TGdipBitmap"/> matching a specified <see cref="TGdipGraphics"/> object's current
   ///  device (display) settings. Avoids reformatting step when rendering, which can significantly improve performance.
   /// </summary>
   /// <remarks>
   ///  <para>
   ///   <see cref="TGdipCachedBitmap"/> matches the current bit depth of the <see cref="TGdipGraphics"/>'s device. If the device bit
   ///   depth changes, the <see cref="TGdipCachedBitmap"/> will no longer be usable and a new instance will need to be created
   ///   that matches. If the <see cref="TGdipCachedBitmap"/> was created against <see cref="TGdipPixelFormat.Format32bppRgb"/> it
   ///   will always work.
   ///  </para>
   ///  <para>
   ///   <see cref="TGdipCachedBitmap"/> will not work with any transformations other than translation.
   ///  </para>
   ///  <para>
   ///   <see cref="TGdipCachedBitmap"/> cannot be used to draw to a printer or metafile.
   ///  </para>
   /// </remarks>
   TGdipCachedBitmap = class sealed(TInterfacedObject, IDisposable)
      strict private _handle: NativeInt;
      strict private function GetHandle(): NativeInt;
      protected property Handle: NativeInt read GetHandle;


      /// <summary>
      ///  Create a device dependent copy of the given <paramref name="bitmap"/> for the device settings of the given
      ///  <paramref name="graphics"/>
      /// </summary>
      /// <param name="bitmap">The <see cref="TGdipBitmap"/> to convert.</param>
      /// <param name="graphics">The <see cref="TGdipGraphics"/> object to use to format the cached copy of the <paramref name="bitmap"/>.</param>
      /// <exception cref="ArgumentNullException"><paramref name="bitmap"/> or <paramref name="graphics"/> is <see langword="null"/>.</exception>
      public constructor Create(const bitmap: TGdipBitmap; const graphics: TGdipGraphics);

      public destructor Destroy(); override;

      strict private procedure Dispose(const disposing: Boolean); overload;

      public procedure Dispose(); overload;
   end;

{$ENDREGION 'TGdipCachedBitmap'}

  TGdipImageAbort = function(CallbackData: Pointer): BOOL; stdcall;
  TGdipDrawImageAbort = TGdipImageAbort;
  TGdipGetThumbnailImageAbort = TGdipImageAbort;


{$REGION 'TGdipGraphics'}

   { TGdipGraphics }

   /// <summary>
   ///  Encapsulates a GDI+ drawing surface.
   /// </summary>
   TGdipGraphics = class sealed(IGdipGraphics, IDisposable, IDeviceContext, IGdipGraphicsContextInfo, IGdipHdcContext, IPointer<TGdiplusAPI.TGdipGraphicsPtr>, IInterface) (* partial *)
      /// <summary>
      /// Callback for EnumerateMetafile methods.
      /// This method can then call TGdipMetafile.PlayRecord to play the record that was just enumerated.
      /// </summary>
      /// <param name="recordType">if >= MinRecordType, it's an EMF+ record</param>
      /// <param name="flags">always 0 for EMF records</param>
      /// <param name="dataSize">size of the data, or 0 if no data</param>
      /// <param name="data">pointer to the data, or NULL if no data (UINT32 aligned)</param>
      /// <param name="callbackData">pointer to callbackData, if any</param>
      /// <returns>False to abort enumerating, true to continue.</returns>
      public type TGdipEnumerateMetafileProc = reference to function(const recordType: TGdipEmfPlusRecordType; const flags: Integer; const dataSize: Integer; const data: Pointer; const callbackData: TGdipPlayRecordCallback): Boolean;

{$IFDEF FINALIZATION_WATCH}
      public class var GraphicsFinalization: TTraceSwitch;
      strict private m_allocationSite: string; // Nome do campo não foi iniciado com "_" ou "m_", verifique se não esta duplicado com nome de propriedade pelo motivo que pascal não diferencia maiúsculas e minúsculas!
      protected class function GetAllocationStack(): string; static;
{$ENDIF}


      /// <summary>
      ///  The context state previous to the current TGdipGraphics context (the head of the stack).
      ///  We don't keep a TGdipGraphicsContext for the current context since it is available at any time from GDI+ and
      ///  we don't want to keep track of changes in it.
      /// </summary>
      strict private _previousContext: TGdipGraphicsContext;

      strict private class var s_syncObject: TObject;

//      // Object reference used for printing; it could point to a PrintPreviewGraphics to obtain the VisibleClipBounds, or
//      // a DeviceContext holding a printer DC.
//      strict private _printingHelper: TObject;

      // GDI+'s preferred HPALETTE.
      strict private class var s_halftonePalette: HPALETTE;

      // pointer back to the TGdipImage backing a specific graphic object
      strict private _backingImage: TGdipImage;


      /// <summary>
      ///  Handle to native DC - obtained from the GDI+ graphics object. We need to cache it to implement
      ///  IDeviceContext interface.
      /// </summary>
      strict private _nativeHdc: HDC;
      strict private class constructor CreateClass();
      strict private class destructor DestroyClass();
      public procedure AfterConstruction; override;

      strict private m_NativeGraphics: TGdiplusAPI.TGdipGraphicsPtr;


      /// <summary>
      ///  Handle to native GDI+ graphics object. This object is created on demand.
      /// </summary>
      protected property NativeGraphics: TGdiplusAPI.TGdipGraphicsPtr read m_NativeGraphics write m_NativeGraphics;
      public function GetPointer(): TGdiplusAPI.TGdipGraphicsPtr; override;

      public property Pointer: TGdiplusAPI.TGdipGraphicsPtr read GetPointer;
      strict private function GetClipRegion(): TGdipRegion;
      strict private procedure SetClipRegion(const Value: TGdipRegion);

      public property Clip: TGdipRegion read GetClipRegion write SetClipRegion;
      strict private function GetClipBounds(): TRectangleF;

      public property ClipBounds: TRectangleF read GetClipBounds;
      strict private function GetCompositingMode(): TGdipCompositingMode;
      strict private procedure SetCompositingMode(const Value: TGdipCompositingMode);


      /// <summary>
      /// Gets or sets the <see cref='TGdipCompositingMode'/> associated with this <see cref='TGdipGraphics'/>.
      /// </summary>
      public property CompositingMode: TGdipCompositingMode read GetCompositingMode write SetCompositingMode;
      strict private function GetCompositingQuality(): TGdipCompositingQuality;
      strict private procedure SetCompositingQuality(const Value: TGdipCompositingQuality);

      public property CompositingQuality: TGdipCompositingQuality read GetCompositingQuality write SetCompositingQuality;
      strict private function GetDpiX(): Single;

      public property DpiX: Single read GetDpiX;
      strict private function GetDpiY(): Single;

      public property DpiY: Single read GetDpiY;
      strict private function GetInterpolationMode(): TGdipInterpolationMode;
      strict private procedure SetInterpolationMode(const Value: TGdipInterpolationMode);


      /// <summary>
      /// Gets or sets the interpolation mode associated with this TGdipGraphics.
      /// </summary>
      public property InterpolationMode: TGdipInterpolationMode read GetInterpolationMode write SetInterpolationMode;
      strict private function GetIsClipEmpty(): Boolean;

      public property IsClipEmpty: Boolean read GetIsClipEmpty;
      strict private function GetIsVisibleClipEmpty(): Boolean;

      public property IsVisibleClipEmpty: Boolean read GetIsVisibleClipEmpty;
      strict private function GetPageScale(): Single;
      strict private procedure SetPageScale(const Value: Single);

      public property PageScale: Single read GetPageScale write SetPageScale;
      strict private function GetPageUnit(): TGdipGraphicsUnit;
      strict private procedure SetPageUnit(const Value: TGdipGraphicsUnit);

      public property PageUnit: TGdipGraphicsUnit read GetPageUnit write SetPageUnit;
      strict private function GetPixelOffsetMode(): TGdipPixelOffsetMode;
      strict private procedure SetPixelOffsetMode(const Value: TGdipPixelOffsetMode);

      public property PixelOffsetMode: TGdipPixelOffsetMode read GetPixelOffsetMode write SetPixelOffsetMode;
      strict private function GetRenderingOrigin(): TPoint;
      strict private procedure SetRenderingOrigin(const Value: TPoint);

      public property RenderingOrigin: TPoint read GetRenderingOrigin write SetRenderingOrigin;
      strict private function GetSmoothingMode(): TGdipSmoothingMode;
      strict private procedure SetSmoothingMode(const Value: TGdipSmoothingMode);

      public property SmoothingMode: TGdipSmoothingMode read GetSmoothingMode write SetSmoothingMode;
      strict private function GetTextContrast(): Integer;
      strict private procedure SetTextContrast(const Value: Integer);

      public property TextContrast: Integer read GetTextContrast write SetTextContrast;
      strict private function GetTextRenderingHint(): TGdipTextRenderingHint;
      strict private procedure SetTextRenderingHint(const Value: TGdipTextRenderingHint);


      /// <summary>
      ///  Gets or sets the rendering mode for text associated with this <see cref='TGdipGraphics'/>.
      /// </summary>
      public property TextRenderingHint: TGdipTextRenderingHint read GetTextRenderingHint write SetTextRenderingHint;
      strict private function GetTransform(): TGdipMatrix;
      strict private procedure SetTransform(const Value: TGdipMatrix);


      /// <summary>
      ///  Gets or sets the world transform for this <see cref='TGdipGraphics'/>.
      /// </summary>
      public property Transform: TGdipMatrix read GetTransform write SetTransform;
      strict private function GetTransformElements(): TMatrix3x2;
      strict private procedure SetTransformElements(const Value: TMatrix3x2);


      /// <summary>
      ///  Gets or sets the world transform elements for this <see cref="TGdipGraphics"/>.
      /// </summary>
      /// <remarks>
      ///  <para>
      ///   This is a more performant alternative to <see cref="Transform"/> that does not need disposal.
      ///  </para>
      /// </remarks>
      public property TransformElements: TMatrix3x2 read GetTransformElements write SetTransformElements;
//      strict private function GetPrintingHelper(): TObject;
//      strict private procedure SetPrintingHelper(const Value: TObject);


//      /// <summary>
//      ///  Represents an object used in connection with the printing API, it is used to hold a reference to a
//      ///  PrintPreviewGraphics (fake graphics) or a printer DeviceContext (and maybe more in the future).
//      /// </summary>
//      protected property PrintingHelper: TObject read GetPrintingHelper write SetPrintingHelper;
      strict private function GetVisibleClipBounds(): TRectangleF;

      public property VisibleClipBounds: TRectangleF read GetVisibleClipBounds;


      /// <summary>
      ///  Constructor to initialize this object from a native GDI+ TGdipGraphics pointer.
      /// </summary>
      strict private constructor Create(const gdipNativeGraphics: TGdiplusAPI.TGdipGraphicsPtr);

      public destructor Destroy(); override;

      /// <summary>
      ///  Creates a new instance of the <see cref='TGdipGraphics'/> class from the specified handle to a device context.
      /// </summary>
      public class function FromHdc(const hdc: HDC): TGdipGraphics; overload; static;

      public class function FromHdcInternal(const hdc: HDC): TGdipGraphics; static;


      /// <summary>
      ///  Creates a new instance of the TGdipGraphics class from the specified handle to a device context and handle to a device.
      /// </summary>
      public class function FromHdc(const hdc: HDC; const hdevice: THandle): TGdipGraphics; overload; static;


      /// <summary>
      ///  Creates a new instance of the <see cref='TGdipGraphics'/> class from a window handle.
      /// </summary>
      public class function FromHwnd(const hwnd: THandle): TGdipGraphics; static;

      public class function FromHwndInternal(const hwnd: THandle): TGdipGraphics; static;


      /// <summary>
      ///  Creates an instance of the <see cref='TGdipGraphics'/> class from an existing <see cref='TGdipImage'/>.
      /// </summary>
      public class function FromImage(const image: TGdipImage): TGdipGraphics; static;

      public procedure ReleaseHdcInternal(const hdc: HDC);


      /// <summary>
      ///  Deletes this <see cref='TGdipGraphics'/>, and frees the memory allocated for it.
      /// </summary>
      public procedure Dispose(); overload;

      strict private procedure Dispose(const disposing: Boolean); overload;

      public function GetHdc(): HDC; overload; override;

      public procedure ReleaseHdc(); overload; override;
      public procedure ReleaseHdc(const hdc: HDC); reintroduce; overload;


      /// <summary>
      ///  Forces immediate execution of all operations currently on the stack.
      /// </summary>
      public procedure Flush(); overload;


      /// <summary>
      ///  Forces execution of all operations currently on the stack.
      /// </summary>
      public procedure Flush(const intention: TGdipFlushIntention); overload;

      public procedure SetClip(const g: TGdipGraphics); overload;

      public procedure SetClip(const g: TGdipGraphics; const combineMode: TGdipCombineMode); overload;

      public procedure SetClip(const rect: TRectangle); overload;

      public procedure SetClip(const rect: TRectangle; const combineMode: TGdipCombineMode); overload;

      public procedure SetClip(const rect: TRectangleF); overload;

      public procedure SetClip(const rect: TRectangleF; const combineMode: TGdipCombineMode); overload;

      public procedure SetClip(const path: TGdipGraphicsPath); overload;

      public procedure SetClip(const path: TGdipGraphicsPath; const combineMode: TGdipCombineMode); overload;

      public procedure SetClip(const region: TGdipRegion; const combineMode: TGdipCombineMode); overload;

      public procedure IntersectClip(const rect: TRectangle); overload;

      public procedure IntersectClip(const rect: TRectangleF); overload;

      public procedure IntersectClip(const region: TGdipRegion); overload;

      public procedure ExcludeClip(const rect: TRectangle); overload;

      public procedure ExcludeClip(const region: TGdipRegion); overload;

      public procedure ResetClip();

      public procedure TranslateClip(const dx: Single; const dy: Single); overload;

      public procedure TranslateClip(const dx: Integer; const dy: Integer); overload;

      public function IsVisible(const x: Integer; const y: Integer): Boolean; overload;

      public function IsVisible(const point: TPoint): Boolean; overload;

      public function IsVisible(const x: Single; const y: Single): Boolean; overload;

      public function IsVisible(const point: TPointF): Boolean; overload;

      public function IsVisible(const x: Integer; const y: Integer; const width: Integer; const height: Integer): Boolean; overload;

      public function IsVisible(const rect: TRectangle): Boolean; overload;

      public function IsVisible(const x: Single; const y: Single; const width: Single; const height: Single): Boolean; overload;

      public function IsVisible(const rect: TRectangleF): Boolean; overload;


      /// <summary>
      ///  Resets the world transform to identity.
      /// </summary>
      public procedure ResetTransform();


      /// <summary>
      ///  Multiplies the <see cref='TGdipMatrix'/> that represents the world transform and <paramref name="matrix"/>.
      /// </summary>
      public procedure MultiplyTransform(const matrix: TGdipMatrix); overload;


      /// <summary>
      ///  Multiplies the <see cref='TGdipMatrix'/> that represents the world transform and <paramref name="matrix"/>.
      /// </summary>
      public procedure MultiplyTransform(const matrix: TGdipMatrix; const order: TGdipMatrixOrder); overload;

      public procedure TranslateTransform(const dx: Single; const dy: Single); overload;

      public procedure TranslateTransform(const dx: Single; const dy: Single; const order: TGdipMatrixOrder); overload;

      public procedure ScaleTransform(const sx: Single; const sy: Single); overload;

      public procedure ScaleTransform(const sx: Single; const sy: Single; const order: TGdipMatrixOrder); overload;

      public procedure RotateTransform(const angle: Single); overload;

      public procedure RotateTransform(const angle: Single; const order: TGdipMatrixOrder); overload;


      /// <summary>
      ///  Draws an arc from the specified ellipse.
      /// </summary>
      public procedure DrawArc(const pen: TGdipPen; const x: Single; const y: Single; const width: Single; const height: Single; const startAngle: Single; const sweepAngle: Single); overload;


      /// <summary>
      ///  Draws an arc from the specified ellipse.
      /// </summary>
      public procedure DrawArc(const pen: TGdipPen; const rect: TRectangleF; const startAngle: Single; const sweepAngle: Single); overload;


      /// <summary>
      /// Draws an arc from the specified ellipse.
      /// </summary>
      public procedure DrawArc(const pen: TGdipPen; const x: Integer; const y: Integer; const width: Integer; const height: Integer; const startAngle: Integer; const sweepAngle: Integer); overload;



      /// <summary>
      ///  Draws an arc from the specified ellipse.
      /// </summary>
      public procedure DrawArc(const pen: TGdipPen; const rect: TRectangle; const startAngle: Single; const sweepAngle: Single); overload;


      /// <summary>
      ///  Draws a cubic Bezier curve defined by four ordered pairs that represent points.
      /// </summary>
      public procedure DrawBezier(const pen: TGdipPen; const x1: Single; const y1: Single; const x2: Single; const y2: Single; const x3: Single; const y3: Single; const x4: Single; const y4: Single); overload;


      /// <summary>
      ///  Draws a cubic Bezier curve defined by four points.
      /// </summary>
      public procedure DrawBezier(const pen: TGdipPen; const pt1: TPointF; const pt2: TPointF; const pt3: TPointF; const pt4: TPointF); overload;


      /// <summary>
      ///  Draws a cubic Bezier curve defined by four points.
      /// </summary>
      public procedure DrawBezier(const pen: TGdipPen; const pt1: TPoint; const pt2: TPoint; const pt3: TPoint; const pt4: TPoint); overload;


      /// <summary>
      ///  Draws the outline of a rectangle specified by <paramref name="rect"/>.
      /// </summary>
      /// <param name="pen">A TGdipPen that determines the color, width, and style of the rectangle.</param>
      /// <param name="rect">A TRectangle structure that represents the rectangle to draw.</param>
      public procedure DrawRectangle(const pen: TGdipPen; const rect: TRectangleF); overload;


      /// <summary>
      ///  Draws the outline of a rectangle specified by <paramref name="rect"/>.
      /// </summary>
      public procedure DrawRectangle(const pen: TGdipPen; const rect: TRectangle); overload;

      /// <inheritdoc cref="DrawRoundedRectangle(TGdipPen, TRectangleF, TSizeF)"/>
      public procedure DrawRoundedRectangle(const pen: TGdipPen; const rect: TRectangle; const radius: TSize); overload;


      /// <summary>
      ///  Draws the outline of the specified rounded rectangle.
      /// </summary>
      /// <param name="pen">The <see cref="TGdipPen"/> to draw the outline with.</param>
      /// <inheritdoc cref="FillRoundedRectangle(TGdipBrush, TRectangleF, TSizeF)"/>
      public procedure DrawRoundedRectangle(const pen: TGdipPen; const rect: TRectangleF; const radius: TSizeF); overload;


      /// <summary>
      ///  Draws the outline of the specified rectangle.
      /// </summary>
      public procedure DrawRectangle(const pen: TGdipPen; const x: Single; const y: Single; const width: Single; const height: Single); overload;


      /// <summary>
      ///  Draws the outline of the specified rectangle.
      /// </summary>
      public procedure DrawRectangle(const pen: TGdipPen; const x: Integer; const y: Integer; const width: Integer; const height: Integer); overload;



      /// <inheritdoc cref="DrawRectangles(TGdipPen, TRectangle[])"/>
      public procedure DrawRectangles(const pen: TGdipPen; const rects: TArray<TRectangleF>); overload;


      /// <inheritdoc cref="DrawRectangles(TGdipPen, TRectangle[])"/>
      public procedure DrawRectangles(const pen: TGdipPen; const rects: TReadOnlySpan<TRectangleF>); overload;


      /// <summary>
      ///  Draws the outlines of a series of rectangles.
      /// </summary>
      /// <param name="pen"><see cref="TGdipPen"/> that determines the color, width, and style of the outlines of the rectangles.</param>
      /// <param name="rects">An array of <see cref="TRectangle"/> structures that represents the rectangles to draw.</param>
      public procedure DrawRectangles(const pen: TGdipPen; const rects: TArray<TRectangle>); overload;


      /// <inheritdoc cref="DrawRectangles(TGdipPen, TRectangle[])"/>
      public procedure DrawRectangles(const pen: TGdipPen; const rects: TReadOnlySpan<TRectangle>); overload;


      /// <summary>
      ///  Draws the outline of an ellipse defined by a bounding rectangle.
      /// </summary>
      public procedure DrawEllipse(const pen: TGdipPen; const rect: TRectangleF); overload;


      /// <summary>
      ///  Draws the outline of an ellipse defined by a bounding rectangle.
      /// </summary>
      public procedure DrawEllipse(const pen: TGdipPen; const x: Single; const y: Single; const width: Single; const height: Single); overload;


      /// <summary>
      ///  Draws the outline of an ellipse specified by a bounding rectangle.
      /// </summary>
      public procedure DrawEllipse(const pen: TGdipPen; const rect: TRectangle); overload;


      /// <summary>
      ///  Draws the outline of an ellipse defined by a bounding rectangle.
      /// </summary>
      public procedure DrawEllipse(const pen: TGdipPen; const x: Integer; const y: Integer; const width: Integer; const height: Integer); overload;


      /// <summary>
      ///  Draws the outline of a pie section defined by an ellipse and two radial lines.
      /// </summary>
      public procedure DrawPie(const pen: TGdipPen; const rect: TRectangleF; const startAngle: Single; const sweepAngle: Single); overload;


      /// <summary>
      ///  Draws the outline of a pie section defined by an ellipse and two radial lines.
      /// </summary>
      public procedure DrawPie(const pen: TGdipPen; const x: Single; const y: Single; const width: Single; const height: Single; const startAngle: Single; const sweepAngle: Single); overload;


      /// <summary>
      ///  Draws the outline of a pie section defined by an ellipse and two radial lines.
      /// </summary>
      public procedure DrawPie(const pen: TGdipPen; const rect: TRectangle; const startAngle: Single; const sweepAngle: Single); overload;


      /// <summary>
      ///  Draws the outline of a pie section defined by an ellipse and two radial lines.
      /// </summary>
      public procedure DrawPie(const pen: TGdipPen; const x: Integer; const y: Integer; const width: Integer; const height: Integer; const startAngle: Integer; const sweepAngle: Integer); overload;


      /// <inheritdoc cref="DrawPolygon(TGdipPen, TPoint[])"/>
      public procedure DrawPolygon(const pen: TGdipPen; const points: TArray<TPointF>); overload;


      /// <inheritdoc cref="DrawPolygon(TGdipPen, TPoint[])"/>
      public procedure DrawPolygon(const pen: TGdipPen; const points: TReadOnlySpan<TPointF>); overload;


      /// <summary>
      ///  Draws the outline of a polygon defined by an array of points.
      /// </summary>
      /// <param name="pen">The <see cref="TGdipPen"/> to draw the outline with.</param>
      /// <param name="points">An array of <see cref="TPoint"/> structures that represent the vertices of the polygon.</param>
      public procedure DrawPolygon(const pen: TGdipPen; const points: TArray<TPoint>); overload;


      /// <inheritdoc cref="DrawPolygon(TGdipPen, TPoint[])"/>
      public procedure DrawPolygon(const pen: TGdipPen; const points: TReadOnlySpan<TPoint>); overload;


      /// <summary>
      ///  Draws the lines and curves defined by a <see cref='TGdipGraphicsPath'/>.
      /// </summary>
      public procedure DrawPath(const pen: TGdipPen; const path: TGdipGraphicsPath);


      /// <inheritdoc cref="DrawCurve(TGdipPen, TPoint[], int, int, float)"/>
      public procedure DrawCurve(const pen: TGdipPen; const points: TArray<TPointF>); overload;


      /// <inheritdoc cref="DrawCurve(TGdipPen, TPoint[], int, int, float)"/>
      public procedure DrawCurve(const pen: TGdipPen; const points: TReadOnlySpan<TPointF>); overload;


      /// <inheritdoc cref="DrawCurve(TGdipPen, TPoint[], int, int, float)"/>
      public procedure DrawCurve(const pen: TGdipPen; const points: TArray<TPointF>; const tension: Single); overload;


      /// <inheritdoc cref="DrawCurve(TGdipPen, TPoint[], int, int, float)"/>
      public procedure DrawCurve(const pen: TGdipPen; const points: TReadOnlySpan<TPointF>; const tension: Single); overload;


      /// <inheritdoc cref="DrawCurve(TGdipPen, TPoint[], int, int, float)"/>
      public procedure DrawCurve(const pen: TGdipPen; const points: TArray<TPointF>; const offset: Integer; const numberOfSegments: Integer); overload;

      /// <inheritdoc cref="DrawCurve(TGdipPen, TPoint[], int, int, float)"/>
      public procedure DrawCurve(const pen: TGdipPen; const points: TReadOnlySpan<TPointF>; const offset: Integer; const numberOfSegments: Integer); overload;


      /// <inheritdoc cref="DrawCurve(TGdipPen, TPoint[], int, int, float)"/>
      public procedure DrawCurve(const pen: TGdipPen; const points: TArray<TPointF>; const offset: Integer; const numberOfSegments: Integer; const tension: Single); overload;


      /// <inheritdoc cref="DrawCurve(TGdipPen, TPoint[], int, int, float)"/>
      public procedure DrawCurve(const pen: TGdipPen; const points: TReadOnlySpan<TPointF>; const offset: Integer; const numberOfSegments: Integer; const tension: Single); overload;


      /// <inheritdoc cref="DrawCurve(TGdipPen, TPoint[], int, int, float)"/>
      public procedure DrawCurve(const pen: TGdipPen; const points: TArray<TPoint>); overload;


      /// <inheritdoc cref="DrawCurve(TGdipPen, TPoint[], int, int, float)"/>
      public procedure DrawCurve(const pen: TGdipPen; const points: TReadOnlySpan<TPoint>); overload;


      /// <inheritdoc cref="DrawCurve(TGdipPen, TPoint[], int, int, float)"/>
      public procedure DrawCurve(const pen: TGdipPen; const points: TArray<TPoint>; const tension: Single); overload;


      /// <inheritdoc cref="DrawCurve(TGdipPen, TPoint[], int, int, float)"/>
      public procedure DrawCurve(const pen: TGdipPen; const points: TReadOnlySpan<TPoint>; const tension: Single); overload;


      /// <summary>
      ///  Draws a curve defined by an array of points.
      /// </summary>
      /// <param name="pen">The <see cref="TGdipPen"/> to draw the curve with.</param>
      /// <param name="points">An array of points that define the curve.</param>
      /// <param name="offset">The index of the first point in the array to draw.</param>
      /// <param name="numberOfSegments">The number of segments to draw.</param>
      /// <param name="tension">A value greater than, or equal to zero that specifies the tension of the curve.</param>
      public procedure DrawCurve(const pen: TGdipPen; const points: TArray<TPoint>; const offset: Integer; const numberOfSegments: Integer; const tension: Single); overload;


      /// <inheritdoc cref="DrawCurve(TGdipPen, TPoint[], int, int, float)"/>
      public procedure DrawCurve(const pen: TGdipPen; const points: TReadOnlySpan<TPoint>; const offset: Integer; const numberOfSegments: Integer; const tension: Single); overload;


      /// <inheritdoc cref="DrawClosedCurve(TGdipPen, TPointF[], float, TGdipFillMode)"/>
      public procedure DrawClosedCurve(const pen: TGdipPen; const points: TArray<TPointF>); overload;


      /// <inheritdoc cref="DrawClosedCurve(TGdipPen, TPointF[], float, TGdipFillMode)"/>
      public procedure DrawClosedCurve(const pen: TGdipPen; const points: TReadOnlySpan<TPointF>); overload;


      /// <summary>
      ///  Draws a closed curve defined by an array of points.
      /// </summary>
      /// <param name="pen">The <see cref="TGdipPen"/> to draw the closed curve with.</param>
      /// <param name="points">An array of points that define the closed curve.</param>
      /// <param name="tension">A value greater than, or equal to zero that specifies the tension of the curve.</param>
      /// <param name="fillmode">A <see cref="TGdipFillMode"/> enumeration that specifies the fill mode of the curve.</param>
      public procedure DrawClosedCurve(const pen: TGdipPen; const points: TArray<TPointF>; const tension: Single; const fillmode: TGdipFillMode); overload;


      /// <inheritdoc cref="DrawClosedCurve(TGdipPen, TPointF[], float, TGdipFillMode)"/>
      public procedure DrawClosedCurve(const pen: TGdipPen; const points: TReadOnlySpan<TPointF>; const tension: Single; const fillmode: TGdipFillMode); overload;


      /// <inheritdoc cref="DrawClosedCurve(TGdipPen, TPointF[], float, TGdipFillMode)"/>
      public procedure DrawClosedCurve(const pen: TGdipPen; const points: TArray<TPoint>); overload;

      /// <inheritdoc cref="DrawClosedCurve(TGdipPen, TPointF[], float, TGdipFillMode)"/>
      public procedure DrawClosedCurve(const pen: TGdipPen; const points: TReadOnlySpan<TPoint>); overload;

      /// <inheritdoc cref="DrawClosedCurve(TGdipPen, TPointF[], float, TGdipFillMode)"/>
      public procedure DrawClosedCurve(const pen: TGdipPen; const points: TArray<TPoint>; const tension: Single; const fillmode: TGdipFillMode); overload;

      /// <inheritdoc cref="DrawClosedCurve(TGdipPen, TPointF[], float, TGdipFillMode)"/>
      public procedure DrawClosedCurve(const pen: TGdipPen; const points: TReadOnlySpan<TPoint>; const tension: Single; const fillmode: TGdipFillMode); overload;

      /// <summary>
      ///  Fills the entire drawing surface with the specified color.
      /// </summary>
      public procedure Clear(const color: TGdipColor);

      /// <inheritdoc cref="FillRoundedRectangle(TGdipBrush, TRectangleF, TSizeF)"/>/>
      public procedure FillRoundedRectangle(const brush: TGdipBrush; const rect: TRectangle; const radius: TSize); overload;


      /// <summary>
      ///  Fills the interior of a rounded rectangle with a <see cref='TGdipBrush'/>.
      /// </summary>
      /// <param name="brush">The <see cref="TGdipBrush"/> to fill the rounded rectangle with.</param>
      /// <param name="rect">The bounds of the rounded rectangle.</param>
      /// <param name="radius">The radius width and height used to round the corners of the rectangle.</param>
      public procedure FillRoundedRectangle(const brush: TGdipBrush; const rect: TRectangleF; const radius: TSizeF); overload;


      /// <summary>
      ///  Fills the interior of a rectangle with a <see cref='TGdipBrush'/>.
      /// </summary>
      public procedure FillRectangle(const brush: TGdipBrush; const rect: TRectangleF); overload;


      /// <summary>
      ///  Fills the interior of a rectangle with a <see cref='TGdipBrush'/>.
      /// </summary>
      public procedure FillRectangle(const brush: TGdipBrush; const x: Single; const y: Single; const width: Single; const height: Single); overload;


      /// <summary>
      ///  Fills the interior of a rectangle with a <see cref='TGdipBrush'/>.
      /// </summary>
      public procedure FillRectangle(const brush: TGdipBrush; const rect: TRectangle); overload;


      /// <summary>
      ///  Fills the interior of a rectangle with a <see cref='TGdipBrush'/>.
      /// </summary>
      public procedure FillRectangle(const brush: TGdipBrush; const x: Integer; const y: Integer; const width: Integer; const height: Integer); overload;


      /// <summary>
      ///  Fills the interiors of a series of rectangles with a <see cref='TGdipBrush'/>.
      /// </summary>
      /// <param name="brush">The <see cref="TGdipBrush"/> to fill the rectangles with.</param>
      /// <param name="rects">An array of rectangles to fill.</param>
      public procedure FillRectangles(const brush: TGdipBrush; const rects: TArray<TRectangleF>); overload;


      /// <inheritdoc cref="FillRectangles(TGdipBrush, TRectangleF[])"/>
      public procedure FillRectangles(const brush: TGdipBrush; const rects: TReadOnlySpan<TRectangleF>); overload;


      /// <inheritdoc cref="FillRectangles(TGdipBrush, TRectangleF[])"/>
      public procedure FillRectangles(const brush: TGdipBrush; const rects: TArray<TRectangle>); overload;


      /// <inheritdoc cref="FillRectangles(TGdipBrush, TRectangleF[])"/>
      public procedure FillRectangles(const brush: TGdipBrush; const rects: TReadOnlySpan<TRectangle>); overload;


      /// <inheritdoc cref="FillPolygon(TGdipBrush, TPoint[], TGdipFillMode)"/>
      public procedure FillPolygon(const brush: TGdipBrush; const points: TArray<TPointF>); overload;

      /// <inheritdoc cref="FillPolygon(TGdipBrush, TPoint[], TGdipFillMode)"/>
      public procedure FillPolygon(const brush: TGdipBrush; const points: TReadOnlySpan<TPointF>); overload;

      /// <inheritdoc cref="FillPolygon(TGdipBrush, TPoint[], TGdipFillMode)"/>
      public procedure FillPolygon(const brush: TGdipBrush; const points: TArray<TPointF>; const fillMode: TGdipFillMode); overload;


      /// <inheritdoc cref="FillPolygon(TGdipBrush, TPoint[], TGdipFillMode)"/>
      public procedure FillPolygon(const brush: TGdipBrush; const points: TReadOnlySpan<TPointF>; const fillMode: TGdipFillMode); overload;


      /// <inheritdoc cref="FillPolygon(TGdipBrush, TPoint[], TGdipFillMode)"/>
      public procedure FillPolygon(const brush: TGdipBrush; const points: TArray<TPoint>); overload;

      /// <inheritdoc cref="FillPolygon(TGdipBrush, TPoint[], TGdipFillMode)"/>
      public procedure FillPolygon(const brush: TGdipBrush; const points: TReadOnlySpan<TPoint>); overload;


      /// <summary>
      ///  Fills the interior of a polygon defined by an array of points.
      /// </summary>
      /// <param name="brush">The <see cref="TGdipBrush"/> to fill the polygon with.</param>
      /// <param name="points">An array points that represent the vertices of the polygon.</param>
      /// <param name="fillMode">A <see cref="TGdipFillMode"/> enumeration that specifies the fill mode of the polygon.</param>
      public procedure FillPolygon(const brush: TGdipBrush; const points: TArray<TPoint>; const fillMode: TGdipFillMode); overload;


      /// <inheritdoc cref="FillPolygon(TGdipBrush, TPoint[], TGdipFillMode)"/>
      public procedure FillPolygon(const brush: TGdipBrush; const points: TReadOnlySpan<TPoint>; const fillMode: TGdipFillMode); overload;


      /// <summary>
      ///  Fills the interior of an ellipse defined by a bounding rectangle.
      /// </summary>
      public procedure FillEllipse(const brush: TGdipBrush; const rect: TRectangleF); overload;


      /// <summary>
      ///  Fills the interior of an ellipse defined by a bounding rectangle.
      /// </summary>
      public procedure FillEllipse(const brush: TGdipBrush; const x: Single; const y: Single; const width: Single; const height: Single); overload;


      /// <summary>
      ///  Fills the interior of an ellipse defined by a bounding rectangle.
      /// </summary>
      public procedure FillEllipse(const brush: TGdipBrush; const rect: TRectangle); overload;


      /// <summary>
      ///  Fills the interior of an ellipse defined by a bounding rectangle.
      /// </summary>
      public procedure FillEllipse(const brush: TGdipBrush; const x: Integer; const y: Integer; const width: Integer; const height: Integer); overload;


      /// <summary>
      ///  Fills the interior of a pie section defined by an ellipse and two radial lines.
      /// </summary>
      public procedure FillPie(const brush: TGdipBrush; const rect: TRectangle; const startAngle: Single; const sweepAngle: Single); overload;


      /// <summary>
      ///  Fills the interior of a pie section defined by an ellipse and two radial lines.
      /// </summary>
      /// <param name="brush">A TGdipBrush that determines the characteristics of the fill.</param>
      /// <param name="rect">A TRectangle structure that represents the bounding rectangle that defines the ellipse from which the pie section comes.</param>
      /// <param name="startAngle">Angle in degrees measured clockwise from the x-axis to the first side of the pie section.</param>
      /// <param name="sweepAngle">Angle in degrees measured clockwise from the <paramref name="startAngle"/> parameter to the second side of the pie section.</param>
      public procedure FillPie(const brush: TGdipBrush; const rect: TRectangleF; const startAngle: Single; const sweepAngle: Single); overload;


      /// <summary>
      ///  Fills the interior of a pie section defined by an ellipse and two radial lines.
      /// </summary>
      public procedure FillPie(const brush: TGdipBrush; const x: Single; const y: Single; const width: Single; const height: Single; const startAngle: Single; const sweepAngle: Single); overload;


      /// <summary>
      ///  Fills the interior of a pie section defined by an ellipse and two radial lines.
      /// </summary>
      public procedure FillPie(const brush: TGdipBrush; const x: Integer; const y: Integer; const width: Integer; const height: Integer; const startAngle: Integer; const sweepAngle: Integer); overload;



      /// <inheritdoc cref="FillClosedCurve(TGdipBrush, TPointF[], TGdipFillMode, float)"/>
      public procedure FillClosedCurve(const brush: TGdipBrush; const points: TArray<TPointF>); overload;


      /// <inheritdoc cref="FillClosedCurve(TGdipBrush, TPointF[], TGdipFillMode, float)"/>
      public procedure FillClosedCurve(const brush: TGdipBrush; const points: TReadOnlySpan<TPointF>); overload;


      /// <inheritdoc cref="FillClosedCurve(TGdipBrush, TPointF[], TGdipFillMode, float)"/>
      public procedure FillClosedCurve(const brush: TGdipBrush; const points: TArray<TPointF>; const fillmode: TGdipFillMode); overload;

      /// <inheritdoc cref="FillClosedCurve(TGdipBrush, TPointF[], TGdipFillMode, float)"/>
      public procedure FillClosedCurve(const brush: TGdipBrush; const points: TReadOnlySpan<TPointF>; const fillmode: TGdipFillMode); overload;

      /// <summary>
      ///  Fills the interior of a closed curve defined by an array of points.
      /// </summary>
      /// <param name="brush">The <see cref="TGdipBrush"/> to fill the closed curve with.</param>
      /// <param name="points">An array of points that make up the closed curve.</param>
      /// <param name="fillmode">A <see cref="TGdipFillMode"/> enumeration that specifies the fill mode of the closed curve.</param>
      /// <param name="tension">A value greater than, or equal to zero that specifies the tension of the curve.</param>
      public procedure FillClosedCurve(const brush: TGdipBrush; const points: TArray<TPointF>; const fillmode: TGdipFillMode; const tension: Single); overload;


      /// <inheritdoc cref="FillClosedCurve(TGdipBrush, TPointF[], TGdipFillMode, float)"/>
      public procedure FillClosedCurve(const brush: TGdipBrush; const points: TReadOnlySpan<TPointF>; const fillmode: TGdipFillMode; const tension: Single); overload;


      /// <inheritdoc cref="FillClosedCurve(TGdipBrush, TPointF[], TGdipFillMode, float)"/>
      public procedure FillClosedCurve(const brush: TGdipBrush; const points: TArray<TPoint>); overload;


      /// <inheritdoc cref="FillClosedCurve(TGdipBrush, TPointF[], TGdipFillMode, float)"/>
      public procedure FillClosedCurve(const brush: TGdipBrush; const points: TReadOnlySpan<TPoint>); overload;


      /// <inheritdoc cref="FillClosedCurve(TGdipBrush, TPointF[], TGdipFillMode, float)"/>
      public procedure FillClosedCurve(const brush: TGdipBrush; const points: TArray<TPoint>; const fillmode: TGdipFillMode); overload;

      /// <inheritdoc cref="FillClosedCurve(TGdipBrush, TPointF[], TGdipFillMode, float)"/>
      public procedure FillClosedCurve(const brush: TGdipBrush; const points: TReadOnlySpan<TPoint>; const fillmode: TGdipFillMode); overload;

      /// <inheritdoc cref="FillClosedCurve(TGdipBrush, TPointF[], TGdipFillMode, float)"/>
      public procedure FillClosedCurve(const brush: TGdipBrush; const points: TArray<TPoint>; const fillmode: TGdipFillMode; const tension: Single); overload;


      /// <inheritdoc cref="FillClosedCurve(TGdipBrush, TPointF[], TGdipFillMode, float)"/>
      public procedure FillClosedCurve(const brush: TGdipBrush; const points: TReadOnlySpan<TPoint>; const fillmode: TGdipFillMode; const tension: Single); overload;


      /// <summary>
      ///  Draws the specified text at the specified location with the specified <see cref="TGdipBrush"/> and
      ///  <see cref="TGdipFont"/> objects.
      /// </summary>
      /// <param name="s">The text to draw.</param>
      /// <param name="font"><see cref="TGdipFont"/> that defines the text format.</param>
      /// <param name="brush"><see cref="TGdipBrush"/> that determines the color and texture of the drawn text.</param>
      /// <param name="x">The x-coordinate of the upper-left corner of the drawn text.</param>
      /// <param name="y">The y-coordinate of the upper-left corner of the drawn text.</param>
      /// <exception cref="ArgumentNullException">
      ///  <paramref name="brush"/> is <see langword="null"/>. -or- <paramref name="font"/> is <see langword="null"/>.
      /// </exception>
      public procedure DrawString(const s: string; const font: TGdipFont; const brush: TGdipBrush; const x: Single; const y: Single); overload;

      /// <inheritdoc cref="DrawString(string?, TGdipFont, TGdipBrush, float, float)"/>
//      public procedure DrawString(const s: string; const font: TGdipFont; const brush: TGdipBrush; const x: Single; const y: Single); overload;


      /// <summary>
      ///  Draws the specified text at the specified location with the specified <see cref="TGdipBrush"/> and
      ///  <see cref="TGdipFont"/> objects.
      /// </summary>
      /// <param name="s">The text to draw.</param>
      /// <param name="font"><see cref="TGdipFont"/> that defines the text format.</param>
      /// <param name="brush"><see cref="TGdipBrush"/> that determines the color and texture of the drawn text.</param>
      /// <param name="point"><see cref="TPointF"/>structure that specifies the upper-left corner of the drawn text.</param>
      /// <exception cref="ArgumentNullException">
      ///  <paramref name="brush"/> is <see langword="null"/>. -or- <paramref name="font"/> is <see langword="null"/>.
      /// </exception>
      public procedure DrawString(const s: string; const font: TGdipFont; const brush: TGdipBrush; const point: TPointF); overload;

//      /// <inheritdoc cref="DrawString(string?, TGdipFont, TGdipBrush, TPointF)"/>
//      public procedure DrawString(const s: string; const font: TGdipFont; const brush: TGdipBrush; const point: TPointF); overload;


      /// <summary>
      ///  Draws the specified text at the specified location with the specified <see cref="TGdipBrush"/> and
      ///  <see cref="TGdipFont"/> objects using the formatting attributes of the specified <see cref="TGdipStringFormat"/>.
      /// </summary>
      /// <param name="s">The text to draw.</param>
      /// <param name="font"><see cref="TGdipFont"/> that defines the text format.</param>
      /// <param name="brush"><see cref="TGdipBrush"/> that determines the color and texture of the drawn text.</param>
      /// <param name="x">The x-coordinate of the upper-left corner of the drawn text.</param>
      /// <param name="y">The y-coordinate of the upper-left corner of the drawn text.</param>
      /// <param name="format">
      ///  <see cref="TGdipStringFormat"/> that specifies formatting attributes, such as line spacing and alignment,
      ///  that are applied to the drawn text.
      /// </param>
      /// <exception cref="ArgumentNullException">
      ///  <paramref name="brush"/> is <see langword="null"/>. -or- <paramref name="font"/> is <see langword="null"/>.
      /// </exception>
      public procedure DrawString(const s: string; const font: TGdipFont; const brush: TGdipBrush; const x: Single; const y: Single; const format: TGdipStringFormat); overload;

      /// <inheritdoc cref="DrawString(string?, TGdipFont, TGdipBrush, float, float, TGdipStringFormat?)"/>
//      public procedure DrawString(const [ref] s: TArray<Char>; const font: TGdipFont; const brush: TGdipBrush; const x: Single; const y: Single; const format: TGdipStringFormat); overload;

      /// <summary>
      ///  Draws the specified text at the specified location with the specified <see cref="TGdipBrush"/> and
      ///  <see cref="TGdipFont"/> objects using the formatting attributes of the specified <see cref="TGdipStringFormat"/>.
      /// </summary>
      /// <param name="s">The text to draw.</param>
      /// <param name="font"><see cref="TGdipFont"/> that defines the text format.</param>
      /// <param name="brush"><see cref="TGdipBrush"/> that determines the color and texture of the drawn text.</param>
      /// <param name="point"><see cref="TPointF"/>structure that specifies the upper-left corner of the drawn text.</param>
      /// <param name="format">
      ///  <see cref="TGdipStringFormat"/> that specifies formatting attributes, such as line spacing and alignment,
      ///  that are applied to the drawn text.
      /// </param>
      /// <exception cref="ArgumentNullException">
      ///  <paramref name="brush"/> is <see langword="null"/>. -or- <paramref name="font"/> is <see langword="null"/>.
      /// </exception>
      public procedure DrawString(const s: string; const font: TGdipFont; const brush: TGdipBrush; const point: TPointF; const format: TGdipStringFormat); overload;

      /// <inheritdoc cref="DrawString(string?, TGdipFont, TGdipBrush, TPointF, TGdipStringFormat?)"/>
//      public procedure DrawString(const [ref] s: TArray<Char>; const font: TGdipFont; const brush: TGdipBrush; const point: TPointF; const format: TGdipStringFormat); overload;


      /// <summary>
      ///  Draws the specified text in the specified rectangle with the specified <see cref="TGdipBrush"/> and
      ///  <see cref="TGdipFont"/> objects.
      /// </summary>
      /// <param name="s">The text to draw.</param>
      /// <param name="font"><see cref="TGdipFont"/> that defines the text format.</param>
      /// <param name="brush"><see cref="TGdipBrush"/> that determines the color and texture of the drawn text.</param>
      /// <param name="layoutRectangle"><see cref="TRectangleF"/>structure that specifies the location of the drawn text.</param>
      /// <exception cref="ArgumentNullException">
      ///  <paramref name="brush"/> is <see langword="null"/>. -or- <paramref name="font"/> is <see langword="null"/>.
      /// </exception>
      /// <remarks>
      ///  <para>
      ///   The text represented by the <paramref name="s"/> parameter is drawn inside the rectangle represented by
      ///   the <paramref name="layoutRectangle"/> parameter. If the text does not fit inside the rectangle, it is
      ///   truncated at the nearest word. To further manipulate how the string is drawn inside the rectangle use the
      ///   <see cref="DrawString(string?, TGdipFont, TGdipBrush, TRectangleF, TGdipStringFormat?)"/> overload that takes
      ///   a <see cref="TGdipStringFormat"/>.
      ///  </para>
      /// </remarks>
      public procedure DrawString(const s: string; const font: TGdipFont; const brush: TGdipBrush; const layoutRectangle: TRectangleF); overload;

      /// <remarks>
      ///  <para>
      ///   The text represented by the <paramref name="s"/> parameter is drawn inside the rectangle represented by
      ///   the <paramref name="layoutRectangle"/> parameter. If the text does not fit inside the rectangle, it is
      ///   truncated at the nearest word. To further manipulate how the string is drawn inside the rectangle use the
      ///   <see cref="DrawString(ReadOnlySpan{char}, TGdipFont, TGdipBrush, TRectangleF, TGdipStringFormat?)"/> overload that takes
      ///   a <see cref="TGdipStringFormat"/>.
      ///  </para>
      /// </remarks>
      /// <inheritdoc cref="DrawString(string?, TGdipFont, TGdipBrush, TRectangleF)"/>
//      public procedure DrawString(const [ref] s: TArray<Char>; const font: TGdipFont; const brush: TGdipBrush; const layoutRectangle: TRectangleF); overload;


      /// <summary>
      ///  Draws the specified text in the specified rectangle with the specified <see cref="TGdipBrush"/> and
      ///  <see cref="TGdipFont"/> objects using the formatting attributes of the specified <see cref="TGdipStringFormat"/>.
      /// </summary>
      /// <param name="s">The text to draw.</param>
      /// <param name="font"><see cref="TGdipFont"/> that defines the text format.</param>
      /// <param name="brush"><see cref="TGdipBrush"/> that determines the color and texture of the drawn text.</param>
      /// <param name="layoutRectangle"><see cref="TRectangleF"/>structure that specifies the location of the drawn text.</param>
      /// <param name="format">
      ///  <see cref="TGdipStringFormat"/> that specifies formatting attributes, such as line spacing and alignment,
      ///  that are applied to the drawn text.
      /// </param>
      /// <exception cref="ArgumentNullException">
      ///  <paramref name="brush"/> is <see langword="null"/>. -or- <paramref name="font"/> is <see langword="null"/>.
      /// </exception>
      /// <remarks>
      ///  <para>
      ///   The text represented by the <paramref name="s"/> parameter is drawn inside the rectangle represented by
      ///   the <paramref name="layoutRectangle"/> parameter. If the text does not fit inside the rectangle, it is
      ///   truncated at the nearest word, unless otherwise specified with the <paramref name="format"/> parameter.
      ///  </para>
      /// </remarks>
      public procedure DrawString(const s: string; const font: TGdipFont; const brush: TGdipBrush; const layoutRectangle: TRectangleF; const format: TGdipStringFormat); overload;

  //    /// <inheritdoc cref="DrawString(string?, TGdipFont, TGdipBrush, TRectangleF, TGdipStringFormat?)"/>
//      public procedure DrawString(const s: string; const font: TGdipFont; const brush: TGdipBrush; const layoutRectangle: TRectangleF; const format: TGdipStringFormat); overload;

      strict private procedure DrawStringInternal(const s: string; const font: TGdipFont; const brush: TGdipBrush; const layoutRectangle: TRectangleF; const format: TGdipStringFormat);


      /// <param name="charactersFitted">Number of characters in the text.</param>
      /// <param name="linesFilled">Number of lines in the text.</param>
      /// <inheritdoc cref="MeasureString(string?, TGdipFont, TSizeF, TGdipStringFormat?)"/>
      public function MeasureString(const text: string; const font: TGdipFont; const layoutArea: TSizeF; const stringFormat: TGdipStringFormat; out charactersFitted: Integer; out linesFilled: Integer): TSizeF; overload;

      /// <inheritdoc cref="MeasureString(string?, TGdipFont, TSizeF, TGdipStringFormat?, out int, out int)"/>
      public function MeasureString(const text: TReadOnlySpan<Char>; const font: TGdipFont; const layoutArea: TSizeF; const stringFormat: TGdipStringFormat; out charactersFitted: Integer; out linesFilled: Integer): TSizeF; overload;

      public function MeasureStringInternal(const text: TReadOnlySpan<Char>; const font: TGdipFont; const layoutArea: TRectangleF; const stringFormat: TGdipStringFormat; out charactersFitted: Integer; out linesFilled: Integer): TSizeF;


      /// <param name="origin"><see cref="TPointF"/> structure that represents the upper-left corner of the text.</param>
      /// <inheritdoc cref="MeasureString(string?, TGdipFont, TSizeF, TGdipStringFormat?)"/>
      public function MeasureString(const text: string; const font: TGdipFont; const origin: TPointF; const stringFormat: TGdipStringFormat): TSizeF; overload;


      /// <inheritdoc cref="MeasureString(string?, TGdipFont, TPointF, TGdipStringFormat?)"/>
      public function MeasureString(const text: TReadOnlySpan<Char>; const font: TGdipFont; const origin: TPointF; const stringFormat: TGdipStringFormat): TSizeF; overload;


      /// <inheritdoc cref="MeasureString(string?, TGdipFont, TSizeF, TGdipStringFormat?)"/>
      public function MeasureString(const text: string; const font: TGdipFont; const layoutArea: TSizeF): TSizeF; overload;

      /// <inheritdoc cref="MeasureString(string?, TGdipFont, TSizeF)"/>
      public function MeasureString(const text: TReadOnlySpan<Char>; const font: TGdipFont; const layoutArea: TSizeF): TSizeF; overload;


      /// <param name="stringFormat"><see cref="TGdipStringFormat"/> that represents formatting information, such as line spacing, for the text.</param>
      /// <param name="layoutArea"><see cref="TSizeF"/> structure that specifies the maximum layout area for the text.</param>
      /// <inheritdoc cref="MeasureString(string?, TGdipFont, int, TGdipStringFormat?)"/>
      public function MeasureString(const text: string; const font: TGdipFont; const layoutArea: TSizeF; const stringFormat: TGdipStringFormat): TSizeF; overload;

      /// <inheritdoc cref="MeasureString(string?, TGdipFont, TSizeF, TGdipStringFormat?)"/>
      public function MeasureString(const text: TReadOnlySpan<Char>; const font: TGdipFont; const layoutArea: TSizeF; const stringFormat: TGdipStringFormat): TSizeF; overload;


      /// <summary>
      ///  Measures the specified text when drawn with the specified <see cref="TGdipFont"/>.
      /// </summary>
      /// <param name="text">Text to measure.</param>
      /// <param name="font"><see cref="TGdipFont"/> that defines the text format.</param>
      /// <returns>
      ///  This method returns a <see cref="TSizeF"/> structure that represents the size, in the units specified by the
      ///  <see cref="PageUnit"/> property, of the text specified by the <paramref name="text"/> parameter as drawn
      ///  with the <paramref name="font"/> parameter.
      /// </returns>
      /// <remarks>
      ///  <para>
      ///   The <see cref="MeasureString(string?, TGdipFont)"/> method is designed for use with individual strings and
      ///   includes a small amount of extra space before and after the string to allow for overhanging glyphs. Also,
      ///   the <see cref="DrawString(string?, TGdipFont, TGdipBrush, TPointF)"/> method adjusts glyph points to optimize display
      ///   quality and might display a string narrower than reported by <see cref="MeasureString(string?, TGdipFont)"/>.
      ///   To obtain metrics suitable for adjacent strings in layout (for example, when implementing formatted text),
      ///   use the <see cref="MeasureCharacterRanges(string?, TGdipFont, TRectangleF, TGdipStringFormat?)"/> method or one of
      ///   the <see cref="MeasureString(string?, TGdipFont, int, TGdipStringFormat?)"/> methods that takes a TGdipStringFormat, and
      ///   pass <see cref="TGdipStringFormat.GenericTypographic"/>. Also, ensure the <see cref="TGdipTextRenderingHint"/> for
      ///   the <see cref="TGdipGraphics"/> is <see cref="TGdipTextRenderingHint.AntiAlias"/>.
      ///  </para>
      /// </remarks>
      /// <exception cref="ArgumentNullException"><paramref name="font"/> is null.</exception>
      public function MeasureString(const text: string; const font: TGdipFont): TSizeF; overload;

      /// <inheritdoc cref="MeasureString(string?, TGdipFont)"/>
      public function MeasureString(const text: TReadOnlySpan<Char>; const font: TGdipFont): TSizeF; overload;


      /// <param name="width">Maximum width of the string in pixels.</param>
      /// <inheritdoc cref="MeasureString(string?, TGdipFont)"/>
      public function MeasureString(const text: string; const font: TGdipFont; const width: Integer): TSizeF; overload;

      /// <inheritdoc cref="MeasureString(string?, TGdipFont, int)"/>
      public function MeasureString(const text: TReadOnlySpan<Char>; const font: TGdipFont; const width: Integer): TSizeF; overload;

      /// <param name="format"><see cref="TGdipStringFormat"/> that represents formatting information, such as line spacing, for the text.</param>
      /// <inheritdoc cref="MeasureString(string?, TGdipFont, int)"/>
      public function MeasureString(const text: string; const font: TGdipFont; const width: Integer; const format: TGdipStringFormat): TSizeF; overload;

      /// <inheritdoc cref="MeasureString(string?, TGdipFont, int, TGdipStringFormat?)"/>
      public function MeasureString(const text: TReadOnlySpan<Char>; const font: TGdipFont; const width: Integer; const format: TGdipStringFormat): TSizeF; overload;

      /// <summary>
      ///  Gets an array of <see cref="TGdipRegion"/> objects, each of which bounds a range of character positions within
      ///  the specified text.
      /// </summary>
      /// <param name="text">Text to measure.</param>
      /// <param name="font"><see cref="TGdipFont"/> that defines the text format.</param>
      /// <param name="layoutRect"><see cref="TRectangleF"/> structure that specifies the layout rectangle for the text.</param>
      /// <param name="stringFormat"><see cref="TGdipStringFormat"/> that represents formatting information, such as line spacing, for the text.</param>
      /// <returns>
      ///  This method returns an array of <see cref="TGdipRegion"/> objects, each of which bounds a range of character
      ///  positions within the specified text.
      /// </returns>
      /// <remarks>
      ///  <para>
      ///   The regions returned by this method are resolution-dependent, so there might be a slight loss of accuracy
      ///   if text is recorded in a metafile at one resolution and later played back at a different resolution.
      ///  </para>
      /// </remarks>
      /// <exception cref="ArgumentNullException"><paramref name="font"/> is <see langword="null"/>.</exception>
      public function MeasureCharacterRanges(const text: string; const font: TGdipFont; const layoutRect: TRectangleF; const stringFormat: TGdipStringFormat): TArray<TGdipRegion>; overload;

      /// <inheritdoc cref="MeasureCharacterRanges(string?, TGdipFont, TRectangleF, TGdipStringFormat?)"/>
      public function MeasureCharacterRanges(const text: TReadOnlySpan<Char>; const font: TGdipFont; const layoutRect: TRectangleF; const stringFormat: TGdipStringFormat): TArray<TGdipRegion>; overload;

      strict private function MeasureCharacterRangesInternal(const text: TReadOnlySpan<Char>; const font: TGdipFont; const layoutRect: TRectangleF; const stringFormat: TGdipStringFormat): TArray<TGdipRegion>;


      /// <summary>
      ///  Draws the specified image at the specified location.
      /// </summary>
      public procedure DrawImage(const image: TGdipImage; const point: TPointF); overload;

      public procedure DrawImage(const image: TGdipImage; const x: Single; const y: Single); overload;

      public procedure DrawImage(const image: TGdipImage; const rect: TRectangleF); overload;

      public procedure DrawImage(const image: TGdipImage; const x: Single; const y: Single; const width: Single; const height: Single); overload;

      public procedure DrawImage(const image: TGdipImage; const point: TPoint); overload;

      public procedure DrawImage(const image: TGdipImage; const x: Integer; const y: Integer); overload;

      public procedure DrawImage(const image: TGdipImage; const rect: TRectangle); overload;

      public procedure DrawImage(const image: TGdipImage; const x: Integer; const y: Integer; const width: Integer; const height: Integer); overload;

      public procedure DrawImageUnscaled(const image: TGdipImage; const point: TPoint); overload;

      public procedure DrawImageUnscaled(const image: TGdipImage; const x: Integer; const y: Integer); overload;

      public procedure DrawImageUnscaled(const image: TGdipImage; const rect: TRectangle); overload;

      public procedure DrawImageUnscaled(const image: TGdipImage; const x: Integer; const y: Integer; const width: Integer; const height: Integer); overload;

      public procedure DrawImageUnscaledAndClipped(const image: TGdipImage; const rect: TRectangle);

      public procedure DrawImage(const image: TGdipImage; const destPoints: TArray<TPointF>); overload;

      public procedure DrawImage(const image: TGdipImage; const destPoints: TArray<TPoint>); overload;

      public procedure DrawImage(const image: TGdipImage; const x: Single; const y: Single; const srcRect: TRectangleF; const srcUnit: TGdipGraphicsUnit); overload;

      public procedure DrawImage(const image: TGdipImage; const x: Integer; const y: Integer; const srcRect: TRectangle; const srcUnit: TGdipGraphicsUnit); overload;


      public procedure DrawImage(const image: TGdipImage; const destRect: TRectangleF; const srcRect: TRectangleF; const srcUnit: TGdipGraphicsUnit); overload;

      public procedure DrawImage(const image: TGdipImage; const destRect: TRectangle; const srcRect: TRectangle; const srcUnit: TGdipGraphicsUnit); overload;


      public procedure DrawImage(const image: TGdipImage; const destPoints: TArray<TPointF>; const srcRect: TRectangleF; const srcUnit: TGdipGraphicsUnit); overload;

      public procedure DrawImage(const image: TGdipImage; const destPoints: TArray<TPointF>; const srcRect: TRectangleF; const srcUnit: TGdipGraphicsUnit; const imageAttr: TGdipImageAttributes); overload;

      public procedure DrawImage(const image: TGdipImage; const destPoints: TArray<TPointF>; const srcRect: TRectangleF; const srcUnit: TGdipGraphicsUnit; const imageAttr: TGdipImageAttributes; callback: TGdipDrawImageAbort); overload;

      public procedure DrawImage(const image: TGdipImage; const destPoints: TArray<TPointF>; const srcRect: TRectangleF; const srcUnit: TGdipGraphicsUnit; const imageAttr: TGdipImageAttributes; callback: TGdipDrawImageAbort; callbackData: Integer); overload;

      public procedure DrawImage(const image: TGdipImage; const destPoints: TArray<TPoint>; const srcRect: TRectangle; const srcUnit: TGdipGraphicsUnit); overload;

      public procedure DrawImage(const image: TGdipImage; const destPoints: TArray<TPoint>; const srcRect: TRectangle; const srcUnit: TGdipGraphicsUnit; const imageAttr: TGdipImageAttributes); overload;

      public procedure DrawImage(const image: TGdipImage; const destPoints: TArray<TPoint>; const srcRect: TRectangle; const srcUnit: TGdipGraphicsUnit; const imageAttr: TGdipImageAttributes; callback: TGdipDrawImageAbort); overload;

      public procedure DrawImage(const image: TGdipImage; const destPoints: TArray<TPoint>; const srcRect: TRectangle; const srcUnit: TGdipGraphicsUnit; const imageAttr: TGdipImageAttributes; callback: TGdipDrawImageAbort; callbackData: Integer); overload;

      public procedure DrawImage(const image: TGdipImage; const destRect: TRectangle; const srcX: Single; const srcY: Single; const srcWidth: Single; const srcHeight: Single; const srcUnit: TGdipGraphicsUnit); overload;

      public procedure DrawImage(const image: TGdipImage; const destRect: TRectangle; const srcX: Single; const srcY: Single; const srcWidth: Single; const srcHeight: Single; const srcUnit: TGdipGraphicsUnit; const imageAttrs: TGdipImageAttributes); overload;

      public procedure DrawImage(const image: TGdipImage; const destRect: TRectangle; const srcX: Single; const srcY: Single; const srcWidth: Single; const srcHeight: Single; const srcUnit: TGdipGraphicsUnit; const imageAttrs: TGdipImageAttributes; const callback: TGdipDrawImageAbort); overload;

      public procedure DrawImage(const image: TGdipImage; const destRect: TRectangle; const srcX: Single; const srcY: Single; const srcWidth: Single; const srcHeight: Single; const srcUnit: TGdipGraphicsUnit; const imageAttrs: TGdipImageAttributes; const callback: TGdipDrawImageAbort; const callbackData: Pointer); overload;

      public procedure DrawImage(const image: TGdipImage; const destRect: TRectangle; const srcX: Integer; const srcY: Integer; const srcWidth: Integer; const srcHeight: Integer; const srcUnit: TGdipGraphicsUnit); overload;

      public procedure DrawImage(const image: TGdipImage; const destRect: TRectangle; const srcX: Integer; const srcY: Integer; const srcWidth: Integer; const srcHeight: Integer; const srcUnit: TGdipGraphicsUnit; const imageAttr: TGdipImageAttributes); overload;

      public procedure DrawImage(const image: TGdipImage; const destRect: TRectangle; const srcX: Integer; const srcY: Integer; const srcWidth: Integer; const srcHeight: Integer; const srcUnit: TGdipGraphicsUnit; const imageAttr: TGdipImageAttributes; callback: TGdipDrawImageAbort); overload;

      public procedure DrawImage(const image: TGdipImage; const destRect: TRectangle; const srcX: Integer; const srcY: Integer; const srcWidth: Integer; const srcHeight: Integer; const srcUnit: TGdipGraphicsUnit; const imageAttrs: TGdipImageAttributes; callback: TGdipDrawImageAbort; callbackData: Pointer); overload;


      /// <summary>
      ///  Draws a line connecting the two specified points.
      /// </summary>
      public procedure DrawLine(const pen: TGdipPen; const pt1: TPointF; const pt2: TPointF); overload;


      /// <inheritdoc cref="DrawLines(TGdipPen, TPoint[])"/>
      public procedure DrawLines(const pen: TGdipPen; const points: TArray<TPointF>); overload;


      /// <inheritdoc cref="DrawLines(TGdipPen, TPoint[])"/>
      public procedure DrawLines(const pen: TGdipPen; const points: TReadOnlySpan<TPointF>); overload;


      /// <summary>
      ///  Draws a line connecting the two specified points.
      /// </summary>
      public procedure DrawLine(const pen: TGdipPen; const x1: Integer; const y1: Integer; const x2: Integer; const y2: Integer); overload;


      /// <summary>
      ///  Draws a line connecting the two specified points.
      /// </summary>
      public procedure DrawLine(const pen: TGdipPen; const pt1: TPoint; const pt2: TPoint); overload;


      /// <summary>
      ///  Draws a series of line segments that connect an array of points.
      /// </summary>
      /// <param name="pen">The <see cref="TGdipPen"/> that determines the color, width, and style of the line segments.</param>
      /// <param name="points">An array of points to connect.</param>
      public procedure DrawLines(const pen: TGdipPen; const points: TArray<TPoint>); overload;


      /// <inheritdoc cref="DrawLines(TGdipPen, TPoint[])"/>
      public procedure DrawLines(const pen: TGdipPen; const points: TReadOnlySpan<TPoint>); overload;


      /// <summary>
      ///  CopyPixels will perform a gdi "bitblt" operation to the source from the destination with the given size.
      /// </summary>
      public procedure CopyFromScreen(const upperLeftSource: TPoint; const upperLeftDestination: TPoint; const blockRegionSize: TSize); overload;


      /// <summary>
      ///  CopyPixels will perform a gdi "bitblt" operation to the source from the destination with the given size.
      /// </summary>
      public procedure CopyFromScreen(const sourceX: Integer; const sourceY: Integer; const destinationX: Integer; const destinationY: Integer; const blockRegionSize: TSize); overload;


      /// <summary>
      ///  CopyPixels will perform a gdi "bitblt" operation to the source from the destination with the given size
      ///  and specified raster operation.
      /// </summary>
      public procedure CopyFromScreen(const upperLeftSource: TPoint; const upperLeftDestination: TPoint; const blockRegionSize: TSize; const copyPixelOperation: TGdipCopyPixelOperation); overload;

      public procedure EnumerateMetafile(const metafile: TGdipMetafile; const destPoint: TPointF; const callback: TGdipEnumerateMetafileProc); overload;

      public procedure EnumerateMetafile(const metafile: TGdipMetafile; const destPoint: TPointF; const callback: TGdipEnumerateMetafileProc; const callbackData: Pointer); overload;

      public procedure EnumerateMetafile(const metafile: TGdipMetafile; const destPoint: TPoint; const callback: TGdipEnumerateMetafileProc); overload;

      public procedure EnumerateMetafile(const metafile: TGdipMetafile; const destPoint: TPoint; const callback: TGdipEnumerateMetafileProc; const callbackData: Pointer); overload;

      public procedure EnumerateMetafile(const metafile: TGdipMetafile; const destRect: TRectangleF; const callback: TGdipEnumerateMetafileProc); overload;

      public procedure EnumerateMetafile(const metafile: TGdipMetafile; const destRect: TRectangleF; const callback: TGdipEnumerateMetafileProc; const callbackData: Pointer); overload;

      public procedure EnumerateMetafile(const metafile: TGdipMetafile; const destRect: TRectangle; const callback: TGdipEnumerateMetafileProc); overload;

      public procedure EnumerateMetafile(const metafile: TGdipMetafile; const destRect: TRectangle; const callback: TGdipEnumerateMetafileProc; const callbackData: Pointer); overload;

      public procedure EnumerateMetafile(const metafile: TGdipMetafile; const destPoints: TArray<TPointF>; const callback: TGdipEnumerateMetafileProc); overload;

      public procedure EnumerateMetafile(const metafile: TGdipMetafile; const destPoints: TArray<TPointF>; const callback: TGdipEnumerateMetafileProc; const callbackData: Pointer); overload;

      public procedure EnumerateMetafile(const metafile: TGdipMetafile; const destPoints: TArray<TPoint>; const callback: TGdipEnumerateMetafileProc); overload;

      public procedure EnumerateMetafile(const metafile: TGdipMetafile; const destPoints: TArray<TPoint>; const callback: TGdipEnumerateMetafileProc; const callbackData: Pointer); overload;

      public procedure EnumerateMetafile(const metafile: TGdipMetafile; const destPoint: TPointF; const srcRect: TRectangleF; const srcUnit: TGdipGraphicsUnit; const callback: TGdipEnumerateMetafileProc); overload;

      public procedure EnumerateMetafile(const metafile: TGdipMetafile; const destPoint: TPointF; const srcRect: TRectangleF; const srcUnit: TGdipGraphicsUnit; const callback: TGdipEnumerateMetafileProc; const callbackData: Pointer); overload;

      public procedure EnumerateMetafile(const metafile: TGdipMetafile; const destPoint: TPoint; const srcRect: TRectangle; const srcUnit: TGdipGraphicsUnit; const callback: TGdipEnumerateMetafileProc); overload;

      public procedure EnumerateMetafile(const metafile: TGdipMetafile; const destPoint: TPoint; const srcRect: TRectangle; const srcUnit: TGdipGraphicsUnit; const callback: TGdipEnumerateMetafileProc; const callbackData: Pointer); overload;

      public procedure EnumerateMetafile(const metafile: TGdipMetafile; const destRect: TRectangleF; const srcRect: TRectangleF; const srcUnit: TGdipGraphicsUnit; const callback: TGdipEnumerateMetafileProc); overload;

      public procedure EnumerateMetafile(const metafile: TGdipMetafile; const destRect: TRectangleF; const srcRect: TRectangleF; const srcUnit: TGdipGraphicsUnit; const callback: TGdipEnumerateMetafileProc; const callbackData: Pointer); overload;

      public procedure EnumerateMetafile(const metafile: TGdipMetafile; const destRect: TRectangle; const srcRect: TRectangle; const srcUnit: TGdipGraphicsUnit; const callback: TGdipEnumerateMetafileProc); overload;

      public procedure EnumerateMetafile(const metafile: TGdipMetafile; const destRect: TRectangle; const srcRect: TRectangle; const srcUnit: TGdipGraphicsUnit; const callback: TGdipEnumerateMetafileProc; const callbackData: Pointer); overload;

      public procedure EnumerateMetafile(const metafile: TGdipMetafile; const destPoints: TArray<TPointF>; const srcRect: TRectangleF; const srcUnit: TGdipGraphicsUnit; const callback: TGdipEnumerateMetafileProc); overload;

      public procedure EnumerateMetafile(const metafile: TGdipMetafile; const destPoints: TArray<TPointF>; const srcRect: TRectangleF; const srcUnit: TGdipGraphicsUnit; const callback: TGdipEnumerateMetafileProc; const callbackData: Pointer); overload;

      public procedure EnumerateMetafile(const metafile: TGdipMetafile; const destPoints: TArray<TPoint>; const srcRect: TRectangle; const srcUnit: TGdipGraphicsUnit; const callback: TGdipEnumerateMetafileProc); overload;

      public procedure EnumerateMetafile(const metafile: TGdipMetafile; const destPoints: TArray<TPoint>; const srcRect: TRectangle; const srcUnit: TGdipGraphicsUnit; const callback: TGdipEnumerateMetafileProc; const callbackData: Pointer); overload;

      public procedure TransformPoints(const destSpace: TGdipCoordinateSpace; const srcSpace: TGdipCoordinateSpace; const pts: TArray<TPointF>); overload;

      public procedure TransformPoints(const destSpace: TGdipCoordinateSpace; const srcSpace: TGdipCoordinateSpace; const pts: TArray<TPoint>); overload;


      /// <summary>
      ///  GDI+ will return a 'generic error' when we attempt to draw an Emf
      ///  image with width/height == 1. Here, we will hack around this by
      ///  resetting the TGdipStatusEnum. Note that we don't do simple arg checking
      ///  for height  width == 1 here because transforms can be applied to
      ///  the TGdipGraphics object making it difficult to identify this scenario.
      /// </summary>
      strict private class procedure IgnoreMetafileErrors(const image: TGdipImage; var errorStatus: TGdiplusAPI.TGdipStatusEnum); static;


      /// <summary>
      ///  Creates a TGdipRegion class only if the native region is not infinite.
      /// </summary>
      protected function GetRegionIfNotInfinite(): TGdipRegion;


      /// <summary>
      ///  CopyPixels will perform a gdi "bitblt" operation to the source from the destination with the given size
      ///  and specified raster operation.
      /// </summary>
      public procedure CopyFromScreen(const sourceX: Integer; const sourceY: Integer; const destinationX: Integer; const destinationY: Integer; const blockRegionSize: TSize; const copyPixelOperation: TGdipCopyPixelOperation); overload;

      public function GetNearestColor(const color: TGdipColor): TGdipColor;


      /// <summary>
      ///  Draws a line connecting the two specified points.
      /// </summary>
      public procedure DrawLine(const pen: TGdipPen; const x1: Single; const y1: Single; const x2: Single; const y2: Single); overload;


      /// <inheritdoc cref="DrawBeziers(TGdipPen, TPoint[])"/>
      public procedure DrawBeziers(const pen: TGdipPen; const points: TArray<TPointF>); overload;

      /// <inheritdoc cref="DrawBeziers(TGdipPen, TPoint[])"/>
      public procedure DrawBeziers(const pen: TGdipPen; const points: TReadOnlySpan<TPointF>); overload;


      /// <summary>
      ///  Draws a series of cubic Bézier curves from an array of points.
      /// </summary>
      /// <param name="pen">The <paramref name="pen"/> to draw the Bézier with.</param>
      /// <param name="points">
      ///  Points that represent the points that determine the curve. The number of points in the array
      ///  should be a multiple of 3 plus 1, such as 4, 7, or 10.
      /// </param>
      public procedure DrawBeziers(const pen: TGdipPen; const points: TArray<TPoint>); overload;


      /// <inheritdoc cref="DrawBeziers(TGdipPen, TPoint[])"/>
      public procedure DrawBeziers(const pen: TGdipPen; const points: TReadOnlySpan<TPoint>); overload;


      /// <summary>
      ///  Fills the interior of a path.
      /// </summary>
      public procedure FillPath(const brush: TGdipBrush; const path: TGdipGraphicsPath);


      /// <summary>
      ///  Fills the interior of a <see cref='TGdipRegion'/>.
      /// </summary>
      public procedure FillRegion(const brush: TGdipBrush; const region: TGdipRegion);

      public procedure DrawIcon(const icon: TGdipIcon; const x: Integer; const y: Integer); overload;


      /// <summary>
      ///  Draws this image to a graphics object. The drawing command originates on the graphics
      ///  object, but a graphics object generally has no idea how to render a given image. So,
      ///  it passes the call to the actual image. This version crops the image to the given
      ///  dimensions and allows the user to specify a rectangle within the image to draw.
      /// </summary>
      public procedure DrawIcon(const icon: TGdipIcon; const targetRect: TRectangle); overload;


      /// <summary>
      ///  Draws this image to a graphics object. The drawing command originates on the graphics
      ///  object, but a graphics object generally has no idea how to render a given image. So,
      ///  it passes the call to the actual image. This version stretches the image to the given
      ///  dimensions and allows the user to specify a rectangle within the image to draw.
      /// </summary>
      public procedure DrawIconUnstretched(const icon: TGdipIcon; const targetRect: TRectangle);

      public procedure EnumerateMetafile(const metafile: TGdipMetafile; const destPoint: TPointF; const callback: TGdipEnumerateMetafileProc; const callbackData: Pointer; const imageAttr: TGdipImageAttributes); overload;

      public procedure EnumerateMetafile(const metafile: TGdipMetafile; const destPoint: TPoint; const callback: TGdipEnumerateMetafileProc; const callbackData: Pointer; const imageAttr: TGdipImageAttributes); overload;


      public procedure EnumerateMetafile(const metafile: TGdipMetafile; const destRect: TRectangleF; const callback: TGdipEnumerateMetafileProc; const callbackData: Pointer; const imageAttr: TGdipImageAttributes); overload;

      public procedure EnumerateMetafile(const metafile: TGdipMetafile; const destRect: TRectangle; const callback: TGdipEnumerateMetafileProc; const callbackData: Pointer; const imageAttr: TGdipImageAttributes); overload;

      public procedure EnumerateMetafile(const metafile: TGdipMetafile; const destPoints: TArray<TPointF>; const callback: TGdipEnumerateMetafileProc; const callbackData: Pointer; const imageAttr: TGdipImageAttributes); overload;

      public procedure EnumerateMetafile(const metafile: TGdipMetafile; const destPoints: TArray<TPoint>; const callback: TGdipEnumerateMetafileProc; const callbackData: Pointer; const imageAttr: TGdipImageAttributes); overload;

      public procedure EnumerateMetafile(const metafile: TGdipMetafile; const destPoint: TPointF; const srcRect: TRectangleF; const unit_: TGdipGraphicsUnit; const callback: TGdipEnumerateMetafileProc; const callbackData: Pointer; const imageAttr: TGdipImageAttributes); overload;

      public procedure EnumerateMetafile(const metafile: TGdipMetafile; const destPoint: TPoint; const srcRect: TRectangle; const unit_: TGdipGraphicsUnit; const callback: TGdipEnumerateMetafileProc; const callbackData: Pointer; const imageAttr: TGdipImageAttributes); overload;

      public procedure EnumerateMetafile(const metafile: TGdipMetafile; const destRect: TRectangleF; const srcRect: TRectangleF; const unit_: TGdipGraphicsUnit; const callback: TGdipEnumerateMetafileProc; const callbackData: Pointer; const imageAttr: TGdipImageAttributes); overload;

      public procedure EnumerateMetafile(const metafile: TGdipMetafile; const destRect: TRectangle; const srcRect: TRectangle; const unit_: TGdipGraphicsUnit; const callback: TGdipEnumerateMetafileProc; const callbackData: Pointer; const imageAttr: TGdipImageAttributes); overload;

      public procedure EnumerateMetafile(const metafile: TGdipMetafile; const destPoints: TArray<TPointF>; const srcRect: TRectangleF; const unit_: TGdipGraphicsUnit; const callback: TGdipEnumerateMetafileProc; const callbackData: Pointer; const imageAttr: TGdipImageAttributes); overload;

      public procedure EnumerateMetafile(const metafile: TGdipMetafile; const destPoints: TArray<TPoint>; const srcRect: TRectangle; const unit_: TGdipGraphicsUnit; const callback: TGdipEnumerateMetafileProc; const callbackData: Pointer; const imageAttr: TGdipImageAttributes); overload;

      /// <summary>
      /// Combina o contexto atual de TGdipGraphics com todos os contextos anteriores.
      /// Quando BeginContainer() é chamado, uma cópia do contexto atual é empurrada para a pilha de contexto do GDI+, ela mantém o controle do
      /// recorte absoluto e transforma mas reseta as propriedades públicas para que pareça um novo contexto.
      /// Quando Save() é chamado, uma cópia do contexto atual também é empurrada na pilha do GDI+ mas as propriedades de recorte e transformação
      /// públicas não são resetadas (cumulativas). Contextos Save consecutivos são ignorados com a exceção do topo, que contém
      /// todas as informações anteriores.
      /// O valor de retorno é um array de objetos onde o primeiro elemento contém a região de recorte cumulativa e o segundo a matriz de transformação
      /// de translação cumulativa.
      /// AVISO: Este método é apenas para suporte interno do FX.
      /// </summary>
      public function GetContextInfo(): TArray<TObject>; overload;

      strict private procedure GetContextInfo(out cumulativeTransform: TMatrix3x2; const calculateClip: Boolean; out cumulativeClip: TGdipRegion); overload;

      public function GetHdc(const apply: TGdipApplyGraphicsProperties; const alwaysSaveState: Boolean): TGdiDeviceContextSaveState; overload; override;

      /// <summary>
      ///  Gets the cumulative offset.
      /// </summary>
      /// <param name="offset">The cumulative offset.</param>
      public procedure GetContextInfo(out offset: TPointF); overload;


      /// <summary>
      ///  Gets the cumulative offset and clip region.
      /// </summary>
      /// <param name="offset">The cumulative offset.</param>
      /// <param name="clip">The cumulative clip region or null if the clip region is infinite.</param>
      public procedure GetContextInfo(out offset: TPointF; out clip: TGdipRegion); overload;


      /// <summary>
      ///  Saves the current context into the context stack.
      /// </summary>
      strict private procedure PushContext(context: TGdipGraphicsContext);


      /// <summary>
      ///  Pops all contexts from the specified one included. The specified context is becoming the current context.
      /// </summary>
      strict private procedure PopContext(const currentContextState: UInt32);

      public function Save(): TGdipGraphicsState;

      public procedure Restore(const gstate: TGdipGraphicsState);

      public function BeginContainer(const dstrect: TRectangleF; const srcrect: TRectangleF; const unit_: TGdipGraphicsUnit): TGdipGraphicsContainer; overload;

      public function BeginContainer(): TGdipGraphicsContainer; overload;

      public procedure EndContainer(container: TGdipGraphicsContainer);

      public function BeginContainer(const dstrect: TRectangle; const srcrect: TRectangle; const unit_: TGdipGraphicsUnit): TGdipGraphicsContainer; overload;


      public procedure AddMetafileComment(const data: TArray<Byte>);

      public class function GetHalftonePalette(): HPALETTE; static;

      // This is called from AppDomain.ProcessExit and AppDomain.DomainUnload.
//      strict private class procedure OnDomainUnload(const sender: TObject; const e: TEventArgs); static;


      /// <summary>
      ///  GDI+ will return a 'generic error' with specific win32 last error codes when
      ///  a terminal server session has been closed, minimized, etc... We don't want
      ///  to throw when this happens, so we'll guard against this by looking at the
      ///  'last win32 error code' and checking to see if it is either 1) access denied
      ///  or 2) proc not found and then ignore it.
      ///
      ///  The problem is that when you lock the machine, the secure desktop is enabled and
      ///  rendering fails which is expected (since the app doesn't have permission to draw
      ///  on the secure desktop). Not sure if there's anything you can do, short of catching
      ///  the desktop switch message and absorbing all the exceptions that get thrown while
      ///  it's the secure desktop.
      /// </summary>
      strict private procedure CheckErrorStatus(const status: TGdiplusAPI.TGdipStatusEnum);

      /// <summary>
      ///  Draws the given <paramref name="cachedBitmap"/>.
      /// </summary>
      /// <param name="cachedBitmap">The <see cref="TGdipCachedBitmap"/> that contains the image to be drawn.</param>
      /// <param name="x">The x-coordinate of the upper-left corner of the drawn image.</param>
      /// <param name="y">The y-coordinate of the upper-left corner of the drawn image.</param>
      /// <exception cref="ArgumentNullException">
      ///  <para><paramref name="cachedBitmap"/> is <see langword="null"/>.</para>
      /// </exception>
      /// <exception cref="InvalidOperationException">
      ///  <para>
      ///   The <paramref name="cachedBitmap"/> is not compatible with the <see cref="TGdipGraphics"/> device state.
      ///  </para>
      ///  <para>
      ///  - or -
      ///  </para>
      ///  <para>
      ///   The <see cref="TGdipGraphics"/> object has a transform applied other than a translation.
      ///  </para>
      /// </exception>
      public procedure DrawCachedBitmap(const cachedBitmap: TGdipCachedBitmap; const x: Integer; const y: Integer);

      /// <inheritdoc cref="DrawImage(TGdipImage, TGdipEffect, TRectangleF, TGdipMatrix?, TGdipGraphicsUnit, TGdipImageAttributes?)"/>
      public procedure DrawImage(const image: TGdipImage; const effect: TGdipEffect); overload;


      /// <summary>
      ///  Draws a portion of an image after applying a specified effect.
      /// </summary>
      /// <param name="image"><see cref="TGdipImage"/> to be drawn.</param>
      /// <param name="effect">The effect to be applied when drawing.</param>
      /// <param name="srcRect">The portion of the image to be drawn. <see cref="TRectangleF.Empty"/> draws the full image.</param>
      /// <param name="transform">The transform to apply to the <paramref name="srcRect"/> to determine the destination.</param>
      /// <param name="srcUnit">Unit of measure of the <paramref name="srcRect"/>.</param>
      /// <param name="imageAttr">Additional adjustments to be applied, if any.</param>
      public procedure DrawImage(const image: TGdipImage; const effect: TGdipEffect; const srcRect: TRectangleF; const transform: TGdipMatrix = default(TGdipMatrix); const srcUnit: TGdipGraphicsUnit = TGdipGraphicsUnit.Pixel; const imageAttr: TGdipImageAttributes = default(TGdipImageAttributes)); overload;

      strict private procedure CheckStatus(const status: TGdiplusAPI.TGdipStatusEnum);
   end;

{$ENDREGION 'TGdipGraphics'}


   { TGdipGraphicsPath }

   TGdipGraphicsPath = class sealed
      protected _nativePath: TGdiplusAPI.TGdipPathPtr;
      strict private const Flatness: Single = Single(Single(2.0) / Single(3.0));

      protected function Pointer(): TGdiplusAPI.TGdipPathPtr;

      strict private function GetFillMode(): TGdipFillMode;
      strict private procedure SetFillMode(const Value: TGdipFillMode);


      public property FillMode: TGdipFillMode read GetFillMode write SetFillMode;
      strict private function GetPathData(): TGdipPathData;


      public property PathData: TGdipPathData read GetPathData;
      strict private function GetPointCount(): Integer;


      public property PointCount: Integer read GetPointCount;
      strict private function GetPathTypes(): TArray<Byte>; overload;


      public property PathTypes: TArray<Byte> read GetPathTypes;
      strict private function GetPathPoints(): TArray<TPointF>; overload;


      public property PathPoints: TArray<TPointF> read GetPathPoints;

      /// <inheritdoc cref="TGdipGraphicsPath(Point[], byte[], FillMode)"/>
      public constructor Create(); overload;

      /// <inheritdoc cref="TGdipGraphicsPath(Point[], byte[], FillMode)"/>
      public constructor Create(const fillMode: TGdipFillMode); overload;

      /// <inheritdoc cref="TGdipGraphicsPath(Point[], byte[], FillMode)"/>
      public constructor Create(const pts: TArray<TPointF>; const types: TArray<Byte>); overload;

      /// <inheritdoc cref="TGdipGraphicsPath(Point[], byte[], FillMode)"/>
      public constructor Create(const pts: TArray<TPointF>; const types: TArray<Byte>; const fillMode: TGdipFillMode); overload;

      /// <inheritdoc cref="TGdipGraphicsPath(Point[], byte[], FillMode)"/>// #if NET9_0_OR_GREATER -> IfDirectiveTrivia

//      public constructor Create(const pts: TReadOnlySpan<TPointF>; const types: TReadOnlySpan<Byte>; const fillMode: TGdipFillMode = TGdipFillMode.Alternate); overload;

      /// <inheritdoc cref="TGdipGraphicsPath(Point[], byte[], FillMode)"/>
      public constructor Create(const pts: TArray<TPoint>; const types: TArray<Byte>); overload;

      /// <summary>
      ///  Initializes a new instance of the <see cref='TGdipGraphicsPath'/> class.
      /// </summary>
      /// <param name="pts">Array of points that define the path.</param>
      /// <param name="types">Array of <see cref="PathPointType"/> values that specify the type of <paramref name="pts"/></param>
      /// <param name="fillMode">
      ///  A <see cref="Drawing2D.FillMode"/> enumeration that specifies how the interiors of shapes in this <see cref="TGdipGraphicsPath"/>
      /// </param>
      public constructor Create(const pts: TArray<TPoint>; const types: TArray<Byte>; const fillMode: TGdipFillMode); overload;

      /// <inheritdoc cref="TGdipGraphicsPath(Point[], byte[], FillMode)"/>// #if NET9_0_OR_GREATER -> IfDirectiveTrivia

//      public constructor Create(const pts: TReadOnlySpan<TPoint>; const types: TReadOnlySpan<Byte>; const fillMode: TGdipFillMode = TGdipFillMode.Alternate); overload;


      strict private constructor Create(const nativePath: TGdiplusAPI.TGdipPathPtr); overload;
      public destructor Destroy(); override;


      public function Clone(): TObject;


      public procedure Dispose(); overload;


      strict private procedure Dispose(const disposing: Boolean); overload;


      public procedure Reset();


      public procedure StartFigure();


      public procedure CloseFigure();


      public procedure CloseAllFigures();


      public procedure SetMarkers();


      public procedure ClearMarkers();


      public procedure Reverse();


      public function GetLastPoint(): TPointF;


      public function IsVisible(const x: Single; const y: Single): Boolean; overload;


      public function IsVisible(const point: TPointF): Boolean; overload;


      public function IsVisible(const x: Single; const y: Single; const graphics: TGdipGraphics): Boolean; overload;


      public function IsVisible(const pt: TPointF; const graphics: TGdipGraphics): Boolean; overload;


      public function IsVisible(const x: Integer; const y: Integer): Boolean; overload;


      public function IsVisible(const point: TPoint): Boolean; overload;


      public function IsVisible(const x: Integer; const y: Integer; const graphics: TGdipGraphics): Boolean; overload;


      public function IsVisible(const pt: TPoint; const graphics: TGdipGraphics): Boolean; overload;


      public function IsOutlineVisible(const x: Single; const y: Single; const pen: TGdipPen): Boolean; overload;


      public function IsOutlineVisible(const point: TPointF; const pen: TGdipPen): Boolean; overload;


      public function IsOutlineVisible(const x: Single; const y: Single; const pen: TGdipPen; const graphics: TGdipGraphics): Boolean; overload;


      public function IsOutlineVisible(const pt: TPointF; const pen: TGdipPen; const graphics: TGdipGraphics): Boolean; overload;


      public function IsOutlineVisible(const x: Integer; const y: Integer; const pen: TGdipPen): Boolean; overload;


      public function IsOutlineVisible(const point: TPoint; const pen: TGdipPen): Boolean; overload;


      public function IsOutlineVisible(const x: Integer; const y: Integer; const pen: TGdipPen; const graphics: TGdipGraphics): Boolean; overload;


      public function IsOutlineVisible(const pt: TPoint; const pen: TGdipPen; const graphics: TGdipGraphics): Boolean; overload;


      public procedure AddLine(const pt1: TPointF; const pt2: TPointF); overload;


      public procedure AddLine(const x1: Single; const y1: Single; const x2: Single; const y2: Single); overload;

      /// <summary>
      ///  Appends a series of connected line segments to the end of this <see cref="TGdipGraphicsPath"/>.
      /// </summary>
      /// <param name="points">An array of points that define the line segments to add.</param>
      /// <exception cref="ArgumentException"></exception>
      /// <remarks>
      ///  <para>
      ///   If there are previous lines or curves in the figure, a line is added to connect the endpoint
      ///   of the previous segment the starting point of the line. The <paramref name="points"/> parameter
      ///   specifies an array of endpoints. The first two specify the first line. Each additional point
      ///   specifies the endpoint of a line segment whose starting point is the endpoint of the previous line.
      ///  </para>
      /// </remarks>
      public procedure AddLines({$IFDEF FPC}constref{$ELSE}const [ref]{$ENDIF} points: TArray<TPointF>); overload;

      /// <inheritdoc cref="AddLines(PointF[])"/>// #if NET9_0_OR_GREATER -> IfDirectiveTrivia

//      public procedure AddLines(const points: TReadOnlySpan<TPointF>); overload;


      public procedure AddLine(const pt1: TPoint; const pt2: TPoint); overload;


      public procedure AddLine(const x1: Integer; const y1: Integer; const x2: Integer; const y2: Integer); overload;

      /// <inheritdoc cref="AddLines(PointF[])"/>
      public procedure AddLines({$IFDEF FPC}constref{$ELSE}const [ref]{$ENDIF} points: TArray<TPoint>); overload;

      /// <inheritdoc cref="AddLines(PointF[])"/>// #if NET9_0_OR_GREATER -> IfDirectiveTrivia

//      public procedure AddLines(const points: TReadOnlySpan<TPoint>); overload;


      public procedure AddArc(const rect: TRectangleF; const startAngle: Single; const sweepAngle: Single); overload;


      public procedure AddArc(const x: Single; const y: Single; const width: Single; const height: Single; const startAngle: Single; const sweepAngle: Single); overload;


      public procedure AddArc(const rect: TRectangle; const startAngle: Single; const sweepAngle: Single); overload;


      public procedure AddArc(const x: Integer; const y: Integer; const width: Integer; const height: Integer; const startAngle: Single; const sweepAngle: Single); overload;


      public procedure AddBezier(const pt1: TPointF; const pt2: TPointF; const pt3: TPointF; const pt4: TPointF); overload;


      public procedure AddBezier(const x1: Single; const y1: Single; const x2: Single; const y2: Single; const x3: Single; const y3: Single; const x4: Single; const y4: Single); overload;

      /// <summary>
      ///  Adds a sequence of connected cubic Bézier curves to the current figure.
      /// </summary>
      /// <param name="points">An array of points that define the curves.</param>
      public procedure AddBeziers({$IFDEF FPC}constref{$ELSE}const [ref]{$ENDIF} points: TArray<TPointF>); overload;

      /// <inheritdoc cref="AddBeziers(PointF[])"/>// #if NET9_0_OR_GREATER -> IfDirectiveTrivia

//      public procedure AddBeziers(const points: TReadOnlySpan<TPointF>); overload;


      public procedure AddBezier(const pt1: TPoint; const pt2: TPoint; const pt3: TPoint; const pt4: TPoint); overload;


      public procedure AddBezier(const x1: Integer; const y1: Integer; const x2: Integer; const y2: Integer; const x3: Integer; const y3: Integer; const x4: Integer; const y4: Integer); overload;

      /// <inheritdoc cref="AddBeziers(PointF[])"/>
      public procedure AddBeziers({$IFDEF FPC}constref{$ELSE}const [ref]{$ENDIF} points: TArray<TPoint>); overload;

      /// <inheritdoc cref="AddBeziers(PointF[])"/>// #if NET9_0_OR_GREATER -> IfDirectiveTrivia

//      public procedure AddBeziers(const points: TReadOnlySpan<TPoint>); overload;

      /// <inheritdoc cref="AddCurve(PointF[], int, int, float)"/>
      public procedure AddCurve({$IFDEF FPC}constref{$ELSE}const [ref]{$ENDIF} points: TArray<TPointF>); overload;

      /// <inheritdoc cref="AddCurve(PointF[], int, int, float)"/>
      public procedure AddCurve({$IFDEF FPC}constref{$ELSE}const [ref]{$ENDIF} points: TArray<TPointF>; const tension: Single); overload;

      /// <summary>
      ///  Adds a spline curve to the current figure. A cardinal spline curve is used because the
      ///  curve travels through each of the points in the array.
      /// </summary>
      /// <param name="points">An array points that define the curve.</param>
      /// <param name="offset">The index of the first point in the array to use.</param>
      /// <param name="numberOfSegments">
      ///  The number of segments to use when creating the curve. A segment can be thought of as
      ///  a line connecting two points.
      /// </param>
      /// <param name="tension">
      ///  A value that specifies the amount that the curve bends between control points.
      ///  Values greater than 1 produce unpredictable results.
      /// </param>
      public procedure AddCurve({$IFDEF FPC}constref{$ELSE}const [ref]{$ENDIF} points: TArray<TPointF>; const offset: Integer; const numberOfSegments: Integer; const tension: Single); overload;

      // #if NET9_0_OR_GREATER -> IfDirectiveTrivia
      /// <inheritdoc cref="AddCurve(PointF[], int, int, float)"/>
//      public procedure AddCurve(const points: TReadOnlySpan<TPointF>); overload;
      // #endif -> EndIfDirectiveTrivia

      /// <inheritdoc cref="AddCurve(PointF[], int, int, float)"/>// #if NET9_0_OR_GREATER -> IfDirectiveTrivia

//      public procedure AddCurve(const points: TReadOnlySpan<TPointF>; const tension: Single); overload;

      /// <inheritdoc cref="AddCurve(PointF[], int, int, float)"/>
      public procedure AddCurve({$IFDEF FPC}constref{$ELSE}const [ref]{$ENDIF} points: TArray<TPoint>); overload;

      /// <inheritdoc cref="AddCurve(PointF[], int, int, float)"/>
      public procedure AddCurve({$IFDEF FPC}constref{$ELSE}const [ref]{$ENDIF} points: TArray<TPoint>; const tension: Single); overload;

      /// <inheritdoc cref="AddCurve(PointF[], int, int, float)"/>
      public procedure AddCurve({$IFDEF FPC}constref{$ELSE}const [ref]{$ENDIF} points: TArray<TPoint>; const offset: Integer; const numberOfSegments: Integer; const tension: Single); overload;

      // #if NET9_0_OR_GREATER -> IfDirectiveTrivia
      /// <inheritdoc cref="AddCurve(PointF[], int, int, float)"/>
//      public procedure AddCurve(const points: TReadOnlySpan<TPoint>); overload;
      // #endif -> EndIfDirectiveTrivia

      /// <inheritdoc cref="AddCurve(PointF[], int, int, float)"/>// #if NET9_0_OR_GREATER -> IfDirectiveTrivia

//      public procedure AddCurve(const points: TReadOnlySpan<TPoint>; const tension: Single); overload;

      /// <inheritdoc cref="AddClosedCurve(Point[], float)"/>
      public procedure AddClosedCurve({$IFDEF FPC}constref{$ELSE}const [ref]{$ENDIF} points: TArray<TPointF>); overload;

      /// <inheritdoc cref="AddClosedCurve(Point[], float)"/>
      public procedure AddClosedCurve({$IFDEF FPC}constref{$ELSE}const [ref]{$ENDIF} points: TArray<TPointF>; const tension: Single); overload;

      // #if NET9_0_OR_GREATER -> IfDirectiveTrivia
      /// <inheritdoc cref="AddClosedCurve(Point[], float)"/>
//      public procedure AddClosedCurve(const points: TReadOnlySpan<TPointF>); overload;
      // #endif -> EndIfDirectiveTrivia

      /// <inheritdoc cref="AddClosedCurve(Point[], float)"/>// #if NET9_0_OR_GREATER -> IfDirectiveTrivia

//      public procedure AddClosedCurve(const points: TReadOnlySpan<TPointF>; const tension: Single); overload;

      /// <inheritdoc cref="AddClosedCurve(Point[], float)"/>
      public procedure AddClosedCurve({$IFDEF FPC}constref{$ELSE}const [ref]{$ENDIF} points: TArray<TPoint>); overload;

      /// <summary>
      ///  Adds a closed spline curve to the current figure. A cardinal spline curve is used because the
      ///  curve travels through each of the points in the array.
      /// </summary>
      /// <inheritdoc cref="AddCurve(PointF[], int, int, float)"/>
      public procedure AddClosedCurve({$IFDEF FPC}constref{$ELSE}const [ref]{$ENDIF} points: TArray<TPoint>; const tension: Single); overload;

      // #if NET9_0_OR_GREATER -> IfDirectiveTrivia
      /// <inheritdoc cref="AddClosedCurve(Point[], float)"/>
//      public procedure AddClosedCurve(const points: TReadOnlySpan<TPoint>); overload;
      // #endif -> EndIfDirectiveTrivia

      /// <inheritdoc cref="AddClosedCurve(Point[], float)"/>// #if NET9_0_OR_GREATER -> IfDirectiveTrivia

//      public procedure AddClosedCurve(const points: TReadOnlySpan<TPoint>; const tension: Single); overload;


      public procedure AddRectangle(const rect: TRectangleF); overload;

      /// <summary>
      ///  Adds a series of rectangles to this path.
      /// </summary>
      /// <param name="rects">Array of rectangles to add.</param>
      public procedure AddRectangles({$IFDEF FPC}constref{$ELSE}const [ref]{$ENDIF} rects: TArray<TRectangleF>); overload;

      /// <inheritdoc cref="AddRectangles(RectangleF[])"/>// #if NET9_0_OR_GREATER -> IfDirectiveTrivia

//      public procedure AddRectangles(const rects: TReadOnlySpan<TRectangleF>); overload;


      public procedure AddRectangle(const rect: TRectangle); overload;

      /// <inheritdoc cref="AddRectangles(RectangleF[])"/>
      public procedure AddRectangles({$IFDEF FPC}constref{$ELSE}const [ref]{$ENDIF} rects: TArray<TRectangle>); overload;

      /// <inheritdoc cref="AddRectangles(RectangleF[])"/>// #if NET9_0_OR_GREATER -> IfDirectiveTrivia

//      public procedure AddRectangles(const rects: TReadOnlySpan<TRectangle>); overload;

      // #if NET9_0_OR_GREATER -> IfDirectiveTrivia
      /// <inheritdoc cref="AddRoundedRectangle(RectangleF, SizeF)"/>
      public procedure AddRoundedRectangle(const rect: TRectangle; const radius: TSize); overload;

      /// <summary>
      ///  Adds a rounded rectangle to this path.
      /// </summary>
      /// <param name="rect">The bounds of the rectangle to add.</param>
      /// <param name="radius">The radius width and height used to round the corners of the rectangle.</param>
      public procedure AddRoundedRectangle(const rect: TRectangleF; const radius: TSizeF); overload;
      // #endif -> EndIfDirectiveTrivia


      public procedure AddEllipse(const rect: TRectangleF); overload;


      public procedure AddEllipse(const x: Single; const y: Single; const width: Single; const height: Single); overload;


      public procedure AddEllipse(const rect: TRectangle); overload;


      public procedure AddEllipse(const x: Integer; const y: Integer; const width: Integer; const height: Integer); overload;


      public procedure AddPie(const rect: TRectangle; const startAngle: Single; const sweepAngle: Single); overload;


      public procedure AddPie(const x: Single; const y: Single; const width: Single; const height: Single; const startAngle: Single; const sweepAngle: Single); overload;


      public procedure AddPie(const x: Integer; const y: Integer; const width: Integer; const height: Integer; const startAngle: Single; const sweepAngle: Single); overload;

      /// <inheritdoc cref="AddPolygon(Point[])"/>
      public procedure AddPolygon({$IFDEF FPC}constref{$ELSE}const [ref]{$ENDIF} points: TArray<TPointF>); overload;

      /// <inheritdoc cref="AddPolygon(Point[])"/>// #if NET9_0_OR_GREATER -> IfDirectiveTrivia

//      public procedure AddPolygon(const points: TReadOnlySpan<TPointF>); overload;

      /// <summary>
      ///  Adds a polygon to this path.
      /// </summary>
      /// <param name="points">The points that define the polygon.</param>
      public procedure AddPolygon({$IFDEF FPC}constref{$ELSE}const [ref]{$ENDIF} points: TArray<TPoint>); overload;

      /// <inheritdoc cref="AddPolygon(Point[])"/>// #if NET9_0_OR_GREATER -> IfDirectiveTrivia

//      public procedure AddPolygon(const points: TReadOnlySpan<TPoint>); overload;


      public procedure AddPath(const addingPath: TGdipGraphicsPath; const connect: Boolean);


      public procedure AddString(const s: string; const family: TGdipFontFamily; const style: Integer; const emSize: Single; const origin: TPointF; const format: TGdipStringFormat); overload;


      public procedure AddString(const s: string; const family: TGdipFontFamily; const style: Integer; const emSize: Single; const origin: TPoint; const format: TGdipStringFormat); overload;


      public procedure AddString(const s: string; const family: TGdipFontFamily; const style: Integer; const emSize: Single; const layoutRect: TRectangleF; const format: TGdipStringFormat); overload;


      public procedure AddString(const s: string; const family: TGdipFontFamily; const style: Integer; const emSize: Single; const layoutRect: TRectangle; const format: TGdipStringFormat); overload;


      public procedure Transform(const matrix: TGdipMatrix);


      public function GetBounds(): TRectangleF; overload;


      public function GetBounds(const matrix: TGdipMatrix): TRectangleF; overload;


      public function GetBounds(const matrix: TGdipMatrix; const pen: TGdipPen): TRectangleF; overload;


      public procedure Flatten(); overload;


      public procedure Flatten(const matrix: TGdipMatrix); overload;


      public procedure Flatten(const matrix: TGdipMatrix; const flatness: Single); overload;


      public procedure Widen(const pen: TGdipPen); overload;


      public procedure Widen(const pen: TGdipPen; const matrix: TGdipMatrix); overload;


      public procedure Widen(const pen: TGdipPen; const matrix: TGdipMatrix; const flatness: Single); overload;

      /// <inheritdoc cref="Warp(ReadOnlySpan{PointF}, RectangleF, Matrix?, WarpMode, float)"/>
//      public procedure Warp({$IFDEF FPC}constref{$ELSE}const [ref]{$ENDIF} destPoints: TArray<TPointF>; const srcRect: TRectangleF); overload;

      /// <inheritdoc cref="Warp(ReadOnlySpan{PointF}, RectangleF, Matrix?, WarpMode, float)"/>
      public procedure Warp({$IFDEF FPC}constref{$ELSE}const [ref]{$ENDIF} destPoints: TArray<TPointF>; const srcRect: TRectangleF; const matrix: TGdipMatrix); overload;

      /// <inheritdoc cref="Warp(ReadOnlySpan{PointF}, RectangleF, Matrix?, WarpMode, float)"/>
//      public procedure Warp({$IFDEF FPC}constref{$ELSE}const [ref]{$ENDIF} destPoints: TArray<TPointF>; const srcRect: TRectangleF; const matrix: TGdipMatrix; const warpMode: TGdipWarpMode); overload;

      /// <inheritdoc cref="Warp(ReadOnlySpan{PointF}, RectangleF, Matrix?, WarpMode, float)"/>
//      public procedure Warp(const destPoints: TArray<TPointF>; const srcRect: TRectangleF; const matrix: TGdipMatrix; const warpMode: TGdipWarpMode; const flatness: Single); overload;

      /// <summary>
      ///  Applies a warp transform, defined by a rectangle and a parallelogram, to this <see cref="TGdipGraphicsPath"/>.
      /// </summary>
      /// <param name="destPoints">
      ///  An array of points that define a parallelogram to which the rectangle defined by <paramref name="srcRect"/>
      ///  is transformed. The array can contain either three or four elements. If the array contains three elements,
      ///  the lower-right corner of the parallelogram is implied by the first three points.
      /// </param>
      /// <param name="srcRect">
      ///  A rectangle that represents the rectangle that is transformed to the parallelogram defined by
      ///  <paramref name="destPoints"/>.
      /// </param>
      /// <param name="matrix">A matrix that specifies a geometric transform to apply to the path.</param>
      /// <param name="warpMode">Specifies whether this warp operation uses perspective or bilinear mode.</param>
      /// <param name="flatness">
      ///  A value from 0 through 1 that specifies how flat the resulting path is. For more information, see the
      ///  <see cref="Flatten(Matrix?, float)"/> methods.
      /// </param>// #if NET9_0_OR_GREATER -> IfDirectiveTrivia

      public procedure Warp({$IFDEF FPC}constref{$ELSE}const [ref]{$ENDIF} destPoints: TArray<TPointF>; const srcRect: TRectangleF; const matrix: TGdipMatrix = nil; const warpMode: TGdipWarpMode = TGdipWarpMode.Perspective; const flatness: Single = Single(0.25)); overload;

      /// <summary>
      ///  Gets the <see cref="PathPointType"/> types for the points in the path.
      /// </summary>
      /// <param name="destination">
      ///  Span to copy the types into. This should be at least as long as the <see cref="PointCount"/>.
      /// </param>
      /// <returns>
      ///  The count of types copied into the <paramref name="destination"/>.
      /// </returns>// #if NET9_0_OR_GREATER -> IfDirectiveTrivia

      public function GetPathTypes(var destination: TArray<Byte>): Integer; overload;

      /// <summary>
      ///  Gets the points in the path.
      /// </summary>
      /// <param name="destination">
      ///  Span to copy the points into. This should be at least as long as the <see cref="PointCount"/>.
      /// </param>
      /// <returns>
      ///  The count of points copied into the <paramref name="destination"/>.
      /// </returns>// #if NET9_0_OR_GREATER -> IfDirectiveTrivia

      public function GetPathPoints(var destination: TArray<TPointF>): Integer; overload;
   end;


   { TGdipRegionData }


   TGdipRegionData = class sealed
      strict private m_Data: TArray<Byte>;
      public property Data: TArray<Byte> read m_Data write m_Data;
      protected constructor Create(const data: TArray<Byte>);
   end;

   { TGdipRegion }

   /// <summary>Descreve o interior de uma forma de gráfico composta por retângulos e caminhos. Essa classe não pode ser herdada.</summary>
   TGdipRegion = class sealed(TNoRefCountObject, IDisposable, IPointer<TGdiplusAPI.TGdipRegionPtr>)

      // handle to native region object
      strict private m_nativeRegion: TGdiplusAPI.TGdipRegionPtr;

      /// <summary>
      /// handle to native region object
      /// </summary>
      protected property NativeRegion: TGdiplusAPI.TGdipRegionPtr read m_NativeRegion write m_NativeRegion;
      strict private function GetPointer(): TGdiplusAPI.TGdipRegionPtr;


      public property Pointer: TGdiplusAPI.TGdipRegionPtr read GetPointer;


      public constructor Create(); overload;


      public constructor Create(const rect: TRectangleF); overload;


      public constructor Create(const rect: TRectangle); overload;


      public constructor Create(const path: TGdipGraphicsPath); overload;


      public constructor Create(const rgnData: TGdipRegionData); overload;


      protected constructor Create(const nativeRegion: TGdiplusAPI.TGdipRegionPtr); overload;
      public destructor Destroy(); override;


      public class function FromHrgn(const hrgn: HRGN): TGdipRegion; static;


      strict private procedure SetNativeRegion(const ANativeRegion: TGdiplusAPI.TGdipRegionPtr);


      public function Clone(): TGdipRegion;


      public procedure ReleaseHrgn(const regionHandle: HRGN);


      public procedure Dispose(); overload;


      strict private procedure Dispose(const disposing: Boolean); overload;


      public procedure MakeInfinite();


      public procedure MakeEmpty();


      public procedure Intersect(const rect: TRectangleF); overload;


      public procedure Intersect(const rect: TRectangle); overload;


      public procedure Intersect(const path: TGdipGraphicsPath); overload;


      public procedure Intersect(const region: TGdipRegion); overload;


      public procedure Union(const rect: TRectangleF); overload;


      public procedure Union(const rect: TRectangle); overload;


      public procedure Union(const path: TGdipGraphicsPath); overload;


      public procedure Union(const region: TGdipRegion); overload;


      public procedure Xor_(const rect: TRectangleF); overload;


      public procedure Xor_(const rect: TRectangle); overload;


      public procedure Xor_(const path: TGdipGraphicsPath); overload;


      public procedure Xor_(const region: TGdipRegion); overload;


      public procedure Exclude(const rect: TRectangleF); overload;


      public procedure Exclude(const rect: TRectangle); overload;


      public procedure Exclude(const path: TGdipGraphicsPath); overload;


      public procedure Exclude(const region: TGdipRegion); overload;


      public procedure Complement(const rect: TRectangleF); overload;


      public procedure Complement(const rect: TRectangle); overload;


      public procedure Complement(const path: TGdipGraphicsPath); overload;


      public procedure Complement(const region: TGdipRegion); overload;


      public procedure Translate(const dx: Single; const dy: Single); overload;


      public procedure Translate(const dx: Integer; const dy: Integer); overload;


      public procedure Transform(const matrix: TGdipMatrix);


      public function GetBounds(const g: TGdipGraphics): TRectangleF;


      public function GetHrgn(const g: TGdipGraphics): HRGN;


      public function IsEmpty(const g: TGdipGraphics): Boolean;


      public function IsInfinite(const g: TGdipGraphics): Boolean;


      public function Equals(const region: TGdipRegion; const g: TGdipGraphics): Boolean; reintroduce; overload;


      public function GetRegionData(): TGdipRegionData;


      public function IsVisible(const x: Single; const y: Single): Boolean; overload;


      public function IsVisible(const point: TPointF): Boolean; overload;


      public function IsVisible(const x: Single; const y: Single; const g: TGdipGraphics): Boolean; overload;


      public function IsVisible(const point: TPointF; const g: TGdipGraphics): Boolean; overload;


      public function IsVisible(const x: Single; const y: Single; const width: Single; const height: Single): Boolean; overload;


      public function IsVisible(const rect: TRectangleF): Boolean; overload;


      public function IsVisible(const x: Single; const y: Single; const width: Single; const height: Single; const g: TGdipGraphics): Boolean; overload;


      public function IsVisible(const rect: TRectangleF; const g: TGdipGraphics): Boolean; overload;


      public function IsVisible(const x: Integer; const y: Integer; const g: TGdipGraphics): Boolean; overload;


      public function IsVisible(const point: TPoint): Boolean; overload;


      public function IsVisible(const point: TPoint; const g: TGdipGraphics): Boolean; overload;


      public function IsVisible(const x: Integer; const y: Integer; const width: Integer; const height: Integer): Boolean; overload;


      public function IsVisible(const rect: TRectangle): Boolean; overload;


      public function IsVisible(const x: Integer; const y: Integer; const width: Integer; const height: Integer; const g: TGdipGraphics): Boolean; overload;


      public function IsVisible(const rect: TRectangle; const g: TGdipGraphics): Boolean; overload;


      public function GetRegionScans(const matrix: TGdipMatrix): TArray<TRectangleF>;


      strict private procedure CheckStatus(const status: TGdiplusAPI.TGdipStatusEnum);
   end;

   { TGdipGraphicsContext }

   /// <summary>
   /// Contains information about the context of a Graphics object.
   /// </summary>
   TGdipGraphicsContext = class sealed

      strict private m_state: UInt32;

      /// <summary>
      /// The state id representing the TGdipGraphicsContext.
      /// </summary>
      public property State: UInt32 read m_State write m_State;
      strict private m_transformOffset: TVector2;

      /// <summary>
      /// The translate transform in the TGdipGraphicsContext.
      /// </summary>
      public property TransformOffset: TVector2 read m_transformOffset write m_transformOffset;
      strict private m_clipRegion: TGdipRegion;

      /// <summary>
      /// The clipping region the TGdipGraphicsContext.
      /// </summary>
      public property Clip: TGdipRegion read m_clipRegion write m_clipRegion;
      strict private m_next: TGdipGraphicsContext;

      /// <summary>
      /// The next TGdipGraphicsContext object in the stack.
      /// </summary>
      public property Next: TGdipGraphicsContext read m_Next write m_Next;
      strict private m_previous: TGdipGraphicsContext;

      /// <summary>
      /// The previous TGdipGraphicsContext object in the stack.
      /// </summary>
      public property Previous: TGdipGraphicsContext read m_Previous write m_Previous;
      strict private m_isCumulative: Boolean;

      /// <summary>
      /// Flag that determines whether the context was created for a Graphics.Save() operation.
      /// This kind of contexts are cumulative across subsequent Save() calls so the top context
      /// info is cumulative.  This is not the same for contexts created for a Graphics.BeginContainer()
      /// operation, in this case the new context information is reset.  See Graphics.BeginContainer()
      /// and Graphics.Save() for more information.
      /// </summary>
      public property IsCumulative: Boolean read m_IsCumulative write m_IsCumulative;

      public constructor Create(const g: TGdipGraphics);

      public destructor Destroy(); override;

      /// <summary>
      /// Disposes this and all contexts up the stack.
      /// </summary>
      public procedure Dispose();
   end;



   { TGdipImageFormat }

   /// <summary>
   ///  Specifies the format of the image.
   /// </summary>
   TGdipImageFormat = class sealed
      // Format IDs
      // private static TGdipImageFormat undefined = new TGdipImageFormat(new Guid("{b96b3ca9-0728-11d3-9d7b-0000f81ef32e}"));
      strict private class var s_memoryBMP: TGdipImageFormat;
      strict private class var s_bmp: TGdipImageFormat;
      strict private class var s_emf: TGdipImageFormat;
      strict private class var s_wmf: TGdipImageFormat;
      strict private class var s_jpeg: TGdipImageFormat;
      strict private class var s_png: TGdipImageFormat;
      strict private class var s_gif: TGdipImageFormat;
      strict private class var s_tiff: TGdipImageFormat;
      strict private class var s_exif: TGdipImageFormat;
      strict private class var s_icon: TGdipImageFormat;
      strict private class var s_heif: TGdipImageFormat;
      strict private class var s_webp: TGdipImageFormat;

      strict private _guid: TGuid;
      strict private _codecId: TGuid;
      strict private class constructor CreateClass();
      strict private class destructor DestroyClass();

      strict private function GetGuid(): TGuid;

      /// <summary>
      ///  Specifies a global unique identifier (GUID) that represents this <see cref='TGdipImageFormat'/>.
      /// </summary>
      public property Guid: TGuid read GetGuid;

      public property CodecId: TGUID read _codecId;

      strict private class function GetMemoryBmp(): TGdipImageFormat; static;


      /// <summary>
      ///  Specifies a memory bitmap image format.
      /// </summary>
      public class property MemoryBmp: TGdipImageFormat read GetMemoryBmp;
      strict private class function GetBmp(): TGdipImageFormat; static;

      /// <summary>
      ///  Specifies the bitmap image format.
      /// </summary>
      public class property Bmp: TGdipImageFormat read GetBmp;
      strict private class function GetEmf(): TGdipImageFormat; static;

      /// <summary>
      ///  Specifies the enhanced Windows metafile image format.
      /// </summary>
      public class property Emf: TGdipImageFormat read GetEmf;
      strict private class function GetWmf(): TGdipImageFormat; static;

      /// <summary>
      ///  Specifies the Windows metafile image format.
      /// </summary>
      public class property Wmf: TGdipImageFormat read GetWmf;
      strict private class function GetGif(): TGdipImageFormat; static;

      /// <summary>
      ///  Specifies the GIF image format.
      /// </summary>
      public class property Gif: TGdipImageFormat read GetGif;
      strict private class function GetJpeg(): TGdipImageFormat; static;

      /// <summary>
      ///  Specifies the JPEG image format.
      /// </summary>
      public class property Jpeg: TGdipImageFormat read GetJpeg;
      strict private class function GetPng(): TGdipImageFormat; static;

      /// <summary>
      ///  Specifies the W3C PNG image format.
      /// </summary>
      public class property Png: TGdipImageFormat read GetPng;
      strict private class function GetTiff(): TGdipImageFormat; static;

      /// <summary>
      ///  Specifies the Tag Image File Format (TIFF) image format.
      /// </summary>
      public class property Tiff: TGdipImageFormat read GetTiff;
      strict private class function GetExif(): TGdipImageFormat; static;

      /// <summary>
      ///  Specifies the Exchangeable Image Format (EXIF).
      /// </summary>
      public class property Exif: TGdipImageFormat read GetExif;
      strict private class function GetIcon(): TGdipImageFormat; static;

      /// <summary>
      ///  Specifies the Windows icon image format.
      /// </summary>
      public class property Icon: TGdipImageFormat read GetIcon;
      strict private class function GetHeif(): TGdipImageFormat; static;

      /// <summary>
      ///  Specifies the High Efficiency Image Format (HEIF).
      /// </summary>
      /// <remarks>
      ///  <para>This format is supported since Windows 10 1809.</para>
      /// </remarks>
      public class property Heif: TGdipImageFormat read GetHeif;
      strict private class function GetWebp(): TGdipImageFormat; static;

      /// <summary>
      ///  Specifies the WebP image format.
      /// </summary>
      /// <remarks>
      ///  <para>This format is supported since Windows 10 1809.</para>
      /// </remarks>
      public class property Webp: TGdipImageFormat read GetWebp;
      strict private function GetEncoder(): TGuid; overload;

      /// <summary>
      ///  The encoder that supports this format, if any.
      /// </summary>
      protected property Encoder: TGuid read GetEncoder;

      /// <summary>
      ///  Initializes a new instance of the <see cref='TGdipImageFormat'/> class with the specified GUID.
      /// </summary>
      public constructor Create(const guid: TGuid); overload;

      public constructor Create(const guid, codecId: TGUID); overload;

      /// <summary>
      ///  Returns a value indicating whether the specified object is an <see cref='TGdipImageFormat'/> equivalent to this
      ///  <see cref='TGdipImageFormat'/>.
      /// </summary>
      public function Equals(o: TObject): Boolean; override;

      /// <summary>
      ///  Converts this <see cref='TGdipImageFormat'/> to a human-readable string.
      /// </summary>
      public function ToString(): string; override;
   end;

   { TGdipImageCodecInfo }

   // sdkinc\imaging.h
   TGdipImageCodecInfo = record

      strict private m_Clsid: TGuid;
      public property Clsid: TGuid read m_Clsid write m_Clsid;

      strict private m_FormatID: TGuid;
      public property FormatID: TGuid read m_FormatID write m_FormatID;

      strict private m_CodecName: string;
      public property CodecName: string read m_CodecName write m_CodecName;

      strict private m_DllName: string;
      public property DllName: string read m_DllName write m_DllName;

      strict private m_FormatDescription: string;
      public property FormatDescription: string read m_FormatDescription write m_FormatDescription;

      strict private m_FilenameExtension: string;
      public property FilenameExtension: string read m_FilenameExtension write m_FilenameExtension;

      strict private m_MimeType: string;
      public property MimeType: string read m_MimeType write m_MimeType;

      strict private m_Flags: TGdipImageCodecFlags;
      public property Flags: TGdipImageCodecFlags read m_Flags write m_Flags;

      strict private m_Version: Integer;
      public property Version: Integer read m_Version write m_Version;

      strict private m_SignaturePatterns: TArray<TArray<Byte>>;
      public property SignaturePatterns: TArray<TArray<Byte>> read m_SignaturePatterns write m_SignaturePatterns;

      strict private m_SignatureMasks: TArray<TArray<Byte>>;
      public property SignatureMasks: TArray<TArray<Byte>> read m_SignatureMasks write m_SignatureMasks;

      // Encoder/Decoder selection APIs
      public class function GetImageDecoders(): TArray<TGdipImageCodecInfo>; static;
      public class function GetImageEncoders(): TArray<TGdipImageCodecInfo>; static;

      strict private class function FromNative(const codecsInfos: TGdiplusAPI.TGdipImageCodecInfoPtr; const numCodecs: UInt32): TArray<TGdipImageCodecInfo>; static;

      public class function FromFormat(const format: TGdipImageFormat): TGdipImageCodecInfo; overload; static;
   end;



   { TGdipEncoder }

   TGdipEncoder = class sealed
      public class var Compression: TGdipEncoder;
      public class var ColorDepth: TGdipEncoder;
      public class var ScanMethod: TGdipEncoder;
      public class var Version: TGdipEncoder;
      public class var RenderMethod: TGdipEncoder;
      public class var Quality: TGdipEncoder;
      public class var Transformation: TGdipEncoder;
      public class var LuminanceTable: TGdipEncoder;
      public class var ChrominanceTable: TGdipEncoder;
      public class var SaveFlag: TGdipEncoder;

      /// <summary>
      /// An <see cref="TGdipEncoder" /> object that is initialized with the globally unique identifier for the color space category.
      /// </summary>
      public class var ColorSpace: TGdipEncoder;

      /// <summary>
      /// An <see cref="TGdipEncoder" /> object that is initialized with the globally unique identifier for the image items category.
      /// </summary>
      public class var ImageItems: TGdipEncoder;

      /// <summary>
      /// An <see cref="TGdipEncoder" /> object that is initialized with the globally unique identifier for the save as CMYK category.
      /// </summary>
      public class var SaveAsCmyk: TGdipEncoder;

      strict private class constructor CreateClass();
      strict private class destructor DestroyClass();

      strict private m_Guid: TGuid;
      public property Guid: TGuid read m_Guid;

      public constructor Create(const guid: TGuid);
   end;


   { TGdipEncoderParameter }

   TGdipEncoderParameter = class//(TInterfacedObject, IDisposable)
      strict private _parameterGuid: TGuid;
      strict private _numberOfValues: Integer;
      strict private _parameterValueType: TGdipEncoderParameterValueType;
      strict private _parameterValue: Pointer;

      strict private class function Add(a: Pointer; b: Integer): Pointer; overload; static;
//      strict private class function Add(a: Integer; b: Pointer): Pointer; overload; static;

      strict private function GetEncoder(): TGdipEncoder;
      strict private procedure SetEncoder(const Value: TGdipEncoder);

      /// <summary>
      ///  Gets/Sets the Encoder for the TGdipEncoderParameter.
      /// </summary>
      public property Encoder: TGdipEncoder read GetEncoder write SetEncoder;
      strict private function GetValueType(): TGdipEncoderParameterValueType;

      /// <summary>
      ///  Gets the EncoderParameterValueType object from the TGdipEncoderParameter.
      /// </summary>
      public property ValueType: TGdipEncoderParameterValueType read GetValueType;

      public property Guid: TGuid read _parameterGuid;
      public property Value: Pointer read _parameterValue;

      strict private function GetNumberOfValues(): Integer;

      /// <summary>
      ///  Gets the NumberOfValues from the TGdipEncoderParameter.
      /// </summary>
      public property NumberOfValues: Integer read GetNumberOfValues;
      public constructor Create(const encoder: TGdipEncoder; const value: Byte); overload;
      public constructor Create(const encoder: TGdipEncoder; const value: Byte; const undefined: Boolean); overload;
      public constructor Create(const encoder: TGdipEncoder; const value: Int16); overload;
      public constructor Create(const encoder: TGdipEncoder; const value: Int64); overload;
      public constructor Create(const encoder: TGdipEncoder; const numerator: Integer; const denominator: Integer); overload;
      public constructor Create(const encoder: TGdipEncoder; const rangebegin: Int64; const rangeend: Int64); overload;
      public constructor Create(const encoder: TGdipEncoder; const numerator1: Integer; const demoninator1: Integer; const numerator2: Integer; const demoninator2: Integer); overload;
      public constructor Create(const encoder: TGdipEncoder; const value: string); overload;
      public constructor Create(const encoder: TGdipEncoder; const value: TArray<Byte>); overload;
      public constructor Create(const encoder: TGdipEncoder; const value: TArray<Byte>; const undefined: Boolean); overload;
      public constructor Create(const encoder: TGdipEncoder; const value: TArray<Int16>); overload;
      public constructor Create(const encoder: TGdipEncoder; const value: TArray<Int64>); overload;
      public constructor Create(const encoder: TGdipEncoder; const numerator: TArray<Integer>; const denominator: TArray<Integer>); overload;
      public constructor Create(const encoder: TGdipEncoder; const rangebegin: TArray<Int64>; const rangeend: TArray<Int64>); overload;
      public constructor Create(const encoder: TGdipEncoder; const numerator1: TArray<Integer>; const denominator1: TArray<Integer>; const numerator2: TArray<Integer>; const denominator2: TArray<Integer>); overload;

      //      [Obsolete("This constructor has been deprecated. Use TGdipEncoderParameter(Encoder encoder, int numberValues, EncoderParameterValueType type, IntPtr value) instead.")]
      public constructor Create(const encoder: TGuid; const NumberOfValues: Integer; const Type_: Integer; const Value: Integer); overload;

      public constructor Create(const encoder: TGuid; const numberValues: Integer; const valueType: TGdipEncoderParameterValueType; const value: Pointer); overload;

      public destructor Destroy(); override;

//      private function ToNative(): TGdiPlusAPI.TGdipNativeEncoderParameter;
      public procedure Dispose(); overload;
      strict private procedure Dispose(const disposing: Boolean); overload;
   end;


   { TGdipEncoderParameters }

   TGdipEncoderParameters = class sealed//(TInterfacedObject, IDisposable)
      strict private m_params: array of TGdiplusAPI.TGdipNativeEncoderParameter;
      strict private m_paramCount: Integer;
      strict private m_values: Pointer;
      strict private m_valueSize: Integer;
      strict private m_valueAllocated: Integer;
      strict private m_nativeParams: TGdiplusAPI.TGdipEncoderParametersPtr;
      strict private m_modified: Boolean;
      strict private function GetNativeParams: TGdiplusAPI.TGdipEncoderParametersPtr;
      strict private function GetCount: Integer;
      strict private function GetParam(const Index: Integer): TGdiplusAPI.TGdipNativeEncoderParameterPtr;
      private constructor Create(const Params: TGdiplusAPI.TGdipEncoderParametersPtr); overload;
      public procedure Clear;
      public procedure Add(const ParamType: TGUID; const Value: TGdipEncoderValue); overload;
      public procedure Add(const ParamType: TGUID; const Value: array of TGdipEncoderValue); overload;
      public procedure Add(const ParamType: TGUID; var Value: Byte); overload;
      public procedure Add(const ParamType: TGUID; const Value: array of Byte); overload;
      public procedure Add(const ParamType: TGUID; var Value: Int16); overload;
      public procedure Add(const ParamType: TGUID; const Value: array of Int16); overload;
      public procedure Add(const ParamType: TGUID; var Value: Int32); overload;
      public procedure Add(const ParamType: TGUID; const Value: array of Int32); overload;
      public procedure Add(const ParamType: TGUID; var Value: Int64); overload;
      public procedure Add(const ParamType: TGUID; const Value: array of Int64); overload;
      public procedure Add(const ParamType: TGUID; const Value: String); overload;
      public procedure Add(const ParamType: TGUID; const Value: Byte; const Undefined: Boolean); overload;
      public procedure Add(const ParamType: TGUID; const Value: array of Byte; const Undefined: Boolean); overload;
      public procedure Add(const ParamType: TGUID; var Numerator, Denominator: Int32); overload;
      public procedure Add(const ParamType: TGUID; const Numerators, Denominators: array of Int32); overload;
      public procedure Add(const ParamType: TGUID; var RangeBegin, RangeEnd: Int64); overload;
      public procedure Add(const ParamType: TGUID; const RangesBegin, RangesEnd: array of Int64); overload;
      public procedure Add(const ParamType: TGUID; const NumberOfValues: Integer; const ValueType: TGdipEncoderParameterValueType; const Value: Pointer); overload;
      public procedure Add(const ParamType: TGUID; const Numerator1, Denominator1, Numerator2, Denominator2: Int32); overload;
      public procedure Add(const ParamType: TGUID; const Numerator1, Denominator1, Numerator2, Denominator2: array of Int32); overload;

      public constructor Create; overload;
      public destructor Destroy; override;

      public property Count: Integer read GetCount;
      public property Param[const Index: Integer]: TGdiplusAPI.TGdipNativeEncoderParameterPtr read GetParam; default;
      public property NativeParams: TGdiplusAPI.TGdipEncoderParametersPtr read GetNativeParams;
   end;

   { TGdipFrameDimension }




   TGdipFrameDimension = class sealed

      // Frame dimension GUIDs, from sdkinc\imgguids.h

      strict private class var s_time: TGdipFrameDimension;

      strict private class var s_resolution: TGdipFrameDimension;

      strict private class var s_page: TGdipFrameDimension;


      strict private _guid: TGuid;
      strict private class constructor CreateClass();
      strict private class destructor DestroyClass();
      public procedure AfterConstruction; override;
      public procedure BeforeDestruction; override;

      strict private function GetGuid(): TGuid;

      /// <summary>
    /// Specifies a global unique identifier (GUID) that represents this <see cref='TGdipFrameDimension'/>.
    /// </summary>
      public property Guid: TGuid read GetGuid;
      strict private class function GetTime(): TGdipFrameDimension; static;

      /// <summary>
    /// The time dimension.
    /// </summary>
      public class property Time: TGdipFrameDimension read GetTime;
      strict private class function GetResolution(): TGdipFrameDimension; static;

      /// <summary>
    /// The resolution dimension.
    /// </summary>
      public class property Resolution: TGdipFrameDimension read GetResolution;
      strict private class function GetPage(): TGdipFrameDimension; static;

      /// <summary>
    /// The page dimension.
    /// </summary>
      public class property Page: TGdipFrameDimension read GetPage;

      /// <summary>
    /// Initializes a new instance of the <see cref='TGdipFrameDimension'/> class with the specified GUID.
    /// </summary>
      public constructor Create(const guid: TGuid);

      /// <summary>
    /// Returns a value indicating whether the specified object is an <see cref='TGdipFrameDimension'/> equivalent to
    /// this <see cref='TGdipFrameDimension'/>.
    /// </summary>
      public function Equals(o: TObject): Boolean; override;

      /// <summary>
    /// Converts this <see cref='TGdipFrameDimension'/> to a human-readable string.
    /// </summary>
      public function ToString(): string; override;
   end;

   { IGdipImage }

   IGdipImage = interface(IPointer<TGdiplusAPI.TGdipImagePtr>)
      ['{A31D2AAE-F18D-43B2-8140-6DDFE2A37B2C}']
   end;

   { TGdipImage }

   /// <summary>
   ///  An abstract base class that provides functionality for 'Bitmap', 'Icon', 'Cursor', and 'Metafile' descended classes.
   /// </summary>
   TGdipImage = class abstract(TNoRefCountObject, IGdipImage, IDisposable, IPointer<TGdiplusAPI.TGdipImagePtr>) //(TMarshalByRefObject, IImage, IDisposable, ICloneable, ISerializable)

      /// <summary>
      /// The signature of this delegate is incorrect. The signature of the corresponding
      /// native callback function is:
      /// extern "C" {
      ///     typedef BOOL (CALLBACK * ImageAbort)(VOID *);
      ///     typedef ImageAbort DrawImageAbort;
      ///     typedef ImageAbort GetThumbnailImageAbort;
      /// }
      /// However, as this delegate is not used in both GDI 1.0 and 1.1, we choose not
      /// to modify it, in order to preserve compatibility.
      /// </summary>
      public type TGetThumbnailImageAbort = reference to function(): Boolean;

      private _nativeImage: TGdiplusAPI.TGdipImagePtr;
      private _ImageFormat: TGdipImageFormat;


      strict private _userData: TObject;

      // Used to work around lack of animated gif encoder.
      strict private _animatedGifRawData: TArray<Byte>;

      public function GetPointer(): TGdiplusAPI.TGdipImagePtr; virtual;
      public property Pointer: TGdiplusAPI.TGdipImagePtr read GetPointer;


      //      public property Data: TArray<Byte> read _animatedGifRawData;
      strict private function GetTag(): TObject;
      strict private procedure SetTag(const Value: TObject);


      public property Tag: TObject read GetTag write SetTag;
      strict private function GetPhysicalDimension(): TSizeF;

      /// <summary>
      ///  Gets the width and height of this <see cref='TGdipImage'/>.
      /// </summary>
      public property PhysicalDimension: TSizeF read GetPhysicalDimension;
      strict private function GetSize(): TSize;

      /// <summary>
      ///  Gets the width and height of this <see cref='TGdipImage'/>.
      /// </summary>
      public property Size: TSize read GetSize;
      strict private function GetWidth(): Integer;

      /// <summary>
      ///  Gets the width of this <see cref='TGdipImage'/>.
      /// </summary>
      public property Width: Integer read GetWidth;
      strict private function GetHeight(): Integer;

      /// <summary>
      ///  Gets the height of this <see cref='TGdipImage'/>.
      /// </summary>
      public property Height: Integer read GetHeight;
      strict private function GetHorizontalResolution(): Single;

      /// <summary>
      ///  Gets the horizontal resolution, in pixels-per-inch, of this <see cref='TGdipImage'/>.
      /// </summary>
      public property HorizontalResolution: Single read GetHorizontalResolution;
      strict private function GetVerticalResolution(): Single;

      /// <summary>
      ///  Gets the vertical resolution, in pixels-per-inch, of this <see cref='TGdipImage'/>.
      /// </summary>
      public property VerticalResolution: Single read GetVerticalResolution;
      strict private function GetFlags(): Integer;

      /// <summary>
      ///  Gets attribute flags for this <see cref='TGdipImage'/>.
      /// </summary>
      public property Flags: Integer read GetFlags;
      strict private function GetRawFormat(): TGdipImageFormat;

      /// <summary>
      ///  Gets the format of this <see cref='TGdipImage'/>.
      /// </summary>
      public property RawFormat: TGdipImageFormat read GetRawFormat;
      strict private function GetPixelFormat(): TGdipPixelFormat;

      /// <summary>
      ///  Gets the pixel format for this <see cref='TGdipImage'/>.
      /// </summary>
      public property PixelFormat: TGdipPixelFormat read GetPixelFormat;

      strict private function GetPropertyIdList(): TGdipPropertyIdList;

      /// <summary>
      ///  Gets an array of the property IDs stored in this <see cref='TGdipImage'/>.
      /// </summary>
      public property PropertyIdList: TGdipPropertyIdList read GetPropertyIdList;

      strict private function GetPropertyItems(): TArray<TGdipPropertyItem>;

      /// <summary>
      ///  Gets an array of <see cref='Imaging.TGdipPropertyItem'/> objects that describe this <see cref='TGdipImage'/>.
      /// </summary>
      public property PropertyItems: TArray<TGdipPropertyItem> read GetPropertyItems;
      strict private function GetPalette(): TGdipColorPalette;
      strict private procedure SetPalette(const Value: TGdipColorPalette);

      /// <summary>
      ///  Gets or sets the color palette used for this <see cref='TGdipImage'/>.
      /// </summary>
      public property Palette: TGdipColorPalette read GetPalette write SetPalette;
      strict private function GetFrameDimensionsList(): TArray<TGuid>;

      // Multi-frame support

      /// <summary>
      ///  Gets an array of GUIDs that represent the dimensions of frames within this <see cref='TGdipImage'/>.
      /// </summary>
      public property FrameDimensionsList: TArray<TGuid> read GetFrameDimensionsList;


      strict protected constructor Create(); overload;
      public destructor Destroy(); override;


      // #pragma warning disable CA2229 // Implement serialization constructors

      //      strict protected constructor Create(const info: TSerializationInfo; const context: TStreamingContext); overload;


      protected constructor Create(const nativeImage: TGdiplusAPI.TGdipImagePtr); overload;


      //      public procedure GetObjectData(const si: TSerializationInfo; const context: TStreamingContext);

      /// <summary>
      ///  Creates an <see cref='TGdipImage'/> from the specified file.
      /// </summary>
      public class function FromFile(const filename: string): TGdipImage; overload; static;

      public class function FromFile(filename: string; const useEmbeddedColorManagement: Boolean): TGdipImage; overload; static;

      /// <summary>
      ///  Creates an <see cref='TGdipImage'/> from the specified data stream.
      /// </summary>
      public class function FromStream(const stream: TStream): TGdipImage; overload; static;
      public class function FromStream(const stream: TStream; const useEmbeddedColorManagement: Boolean): TGdipImage; overload; static;
      public class function FromStream(const stream: TStream; const useEmbeddedColorManagement: Boolean; const validateImageData: Boolean): TGdipImage; overload; static;

      // Used for serialization
//      strict private function InitializeFromStream(const stream: TStream): TGdiplusAPI.TGdipImagePtr;
      strict private class function LoadGdipImageFromStream(const stream: TStream; const useEmbeddedColorManagement: Boolean): TGdiPlusAPI.TGdipImagePtr; overload; static;
      strict private class function LoadGdipImageFromStream(const stream: IStream; const useEmbeddedColorManagement: Boolean): TGdiPlusAPI.TGdipImagePtr; overload; static;

      /// <summary>
      ///  Cleans up Windows resources for this <see cref='TGdipImage'/>.
      /// </summary>
      public procedure Dispose(); overload;

      /// <summary>
      ///  Creates an exact copy of this <see cref='TGdipImage'/>.
      /// </summary>
      public function Clone(): TObject;
      strict protected procedure Dispose(const disposing: Boolean); overload; virtual;

      /// <summary>
      ///  Saves this <see cref='TGdipImage'/> to the specified file.
      /// </summary>
      public procedure Save(const filename: string); overload;

      /// <summary>
      ///  Saves this <see cref='TGdipImage'/> to the specified file in the specified format.
      /// </summary>
      public procedure Save(const filename: string; const format: TGdipImageFormat); overload;
      public procedure Save(const filename: string; const format: TGdipImageFormat; const encoderParams: TGdipEncoderParameters); overload;

      /// <summary>
      ///  Saves this <see cref='TGdipImage'/> to the specified file in the specified format and with the specified encoder parameters.
      /// </summary>
      public procedure Save(const filename: string; const encoder: TGdipImageCodecInfo; const encoderParams: TGdipEncoderParameters); overload;
      strict private procedure Save(const filename: string; const encoder: TGuid; const encoderParams: TGdipEncoderParameters); overload;

      /// <summary>
      ///  Saves this <see cref='TGdipImage'/> to the specified stream in the specified format.
      /// </summary>
      public procedure Save(const stream: TStream; const format: TGdipImageFormat); overload;

      /// <summary>
      ///  Saves this <see cref='TGdipImage'/> to the specified stream in the specified format.
      /// </summary>
      public procedure Save(const stream: TStream; const encoder: TGdipImageCodecInfo; const encoderParams: TGdipEncoderParameters); overload;
      protected procedure Save(const stream: TStream; encoder: TGuid; const format: TGuid; const encoderParameters: TGdiPlusAPI.TGdipEncoderParametersPtr); overload;
      protected procedure Save(const stream: TMemoryStream); overload;

      /// <summary>
      ///  Adds an <see cref='Imagin.TGdipEncoderParameters'/> to this <see cref='TGdipImage'/>.
      /// </summary>
      public procedure SaveAdd(const encoderParams: TGdipEncoderParameters); overload;

      /// <summary>
      ///  Adds an <see cref='TGdipEncoderParameters'/> to the specified <see cref='TGdipImage'/>.
      /// </summary>
      public procedure SaveAdd(const image: TGdipImage; const encoderParams: TGdipEncoderParameters); overload;
      strict private class procedure ThrowIfDirectoryDoesntExist(const filename: string); static;

      /// <summary>
      ///  Gets a bounding rectangle in the specified units for this <see cref='TGdipImage'/>.
      /// </summary>
      public function GetBounds(var pageUnit: TGdipGraphicsUnit): TRectangleF;
      strict protected function GetImageBounds(): TRectangleF; overload;

      // Thumbnail support

      /// <summary>
      ///  Returns the thumbnail for this <see cref='TGdipImage'/>.
      /// </summary>
      public function GetThumbnailImage(const thumbWidth: Integer; const thumbHeight: Integer; const callback: TGetThumbnailImageAbort; const callbackData: Pointer): TGdipImage;
      protected class procedure ValidateImage(const image: TGdiplusAPI.TGdipImagePtr); static;

      /// <summary>
      ///  Returns the number of frames of the given dimension.
      /// </summary>
      public function GetFrameCount(const dimension: TGdipFrameDimension): Integer;

      /// <summary>
      ///  Obtém o item de propriedade especificado deste <see cref='TGdipImage'/>.
      /// </summary>
      public function GetPropertyItem(const propid: Integer): TGdipPropertyItem;

      /// <summary>
      ///  Seleciona o quadro especificado pela dimensão e índice dados.
      /// </summary>
      public function SelectActiveFrame(const dimension: TGdipFrameDimension; const frameIndex: Integer): Integer;

      /// <summary>
      ///  Define o item de propriedade especificado com o valor especificado.
      /// </summary>
      public procedure SetPropertyItem(const propitem: TGdipPropertyItem);
      public procedure RotateFlip(const rotateFlipType: TGdipRotateFlipType);

      /// <summary>
      ///  Remove o item de propriedade especificado deste <see cref='TGdipImage'/>.
      /// </summary>
      public procedure RemovePropertyItem(const propid: Integer);

      /// <summary>
      ///  Retorna informações sobre os codecs usados para este <see cref='TGdipImage'/>.
      /// </summary>
      public function GetEncoderParameterList(const encoder: TGuid): TGdipEncoderParameters;

      /// <summary>
      ///  Creates a <see cref='Bitmap'/> from a Windows handle.
      /// </summary>
      public class function FromHbitmap(const hbitmap: HBITMAP): TGdipBitmap; overload; static;

      /// <summary>
      ///  Cria um <see cref='Bitmap'/> do identificador do Windows especificado com a paleta de cores especificada.
      /// </summary>
      public class function FromHbitmap(const hbitmap: HBITMAP; const hpalette: HPALETTE): TGdipBitmap; overload; static;

      /// <summary>
      ///  Retorna um valor indicando se o formato de pixel é estendido.
      /// </summary>
      public class function IsExtendedPixelFormat(const pixfmt: TGdipPixelFormat): Boolean; static;

      /// <summary>
      ///  Retorna um valor indicando se o formato de pixel é canônico.
      /// </summary>
      public class function IsCanonicalPixelFormat(const pixfmt: TGdipPixelFormat): Boolean; static;
      protected procedure SetNativeImage(const handle: TGdiplusAPI.TGdipImagePtr);

      /// <summary>
      ///  Retorna o tamanho do formato de pixel especificado.
      /// </summary>
      public class function GetPixelFormatSize(const pixfmt: TGdipPixelFormat): Integer; static;

      /// <summary>
      ///  Retorna um valor indicando se o formato de pixel contém informações de alfa.
      /// </summary>
      public class function IsAlphaPixelFormat(const pixfmt: TGdipPixelFormat): Boolean; static;
      protected class function CreateImageObject(const nativeImage: TGdiplusAPI.TGdipImagePtr): TGdipImage; static;

      /// <summary>
      /// Se a imagem for um GIF animado, carrega os dados brutos para a imagem no campo _rawData para que possamos
      /// contornar a falta de um codificador de GIF animado.
      /// </summary>
      protected class procedure GetAnimatedGifRawData(const image: TGdipImage; const filename: string; dataStream: TStream); static;

      // #if FINALIZATION_WATCH -> IfDirectiveTrivia
      // private string allocationSite = Graphics.GetAllocationStack(); -> DisabledTextTrivia
      // #endif -> EndIfDirectiveTrivia
   end;

   { TGdipImageExtensions }

   TGdipImageExtensions = class helper for TGdipImage
      public function Pointer(): TGdiplusAPI.TGdipImagePtr;
   end;


   { TGdipWmfPlaceableFileHeader }

   /// <summary>
   ///  Defines an Placeable Metafile.
   /// </summary>
   TGdipWmfPlaceableFileHeader = packed class sealed
      protected _header: TGdiPlusAPI.TGdipWmfPlaceableFileHeaderPtr;
      strict private class constructor CreateClass();
      strict private class destructor DestroyClass();
      public procedure AfterConstruction; override;
      public procedure BeforeDestruction; override;

      strict private function GetKey(): Integer;
      strict private procedure SetKey(const Value: Integer);

      /// <summary>
      ///  Indicates the presence of a placeable metafile header.
      /// </summary>
      public property Key: Integer read GetKey write SetKey;
      strict private function GetHmf(): Int16;
      strict private procedure SetHmf(const Value: Int16);

      /// <summary>
      ///  Stores the handle of the metafile in memory.
      /// </summary>
      public property Hmf: Int16 read GetHmf write SetHmf;
      strict private function GetBboxLeft(): Int16;
      strict private procedure SetBboxLeft(const Value: Int16);

      /// <summary>
      ///  The x-coordinate of the upper-left corner of the bounding rectangle of the metafile image on the output device.
      /// </summary>
      public property BboxLeft: Int16 read GetBboxLeft write SetBboxLeft;
      strict private function GetBboxTop(): Int16;
      strict private procedure SetBboxTop(const Value: Int16);

      /// <summary>
      ///  The y-coordinate of the upper-left corner of the bounding rectangle of the metafile image on the output device.
      /// </summary>
      public property BboxTop: Int16 read GetBboxTop write SetBboxTop;
      strict private function GetBboxRight(): Int16;
      strict private procedure SetBboxRight(const Value: Int16);

      /// <summary>
      ///  The x-coordinate of the lower-right corner of the bounding rectangle of the metafile image on the output device.
      /// </summary>
      public property BboxRight: Int16 read GetBboxRight write SetBboxRight;
      strict private function GetBboxBottom(): Int16;
      strict private procedure SetBboxBottom(const Value: Int16);

      /// <summary>
      ///  The y-coordinate of the lower-right corner of the bounding rectangle of the metafile image on the output device.
      /// </summary>
      public property BboxBottom: Int16 read GetBboxBottom write SetBboxBottom;
      strict private function GetInch(): Int16;
      strict private procedure SetInch(const Value: Int16);

      /// <summary>
      ///  Indicates the number of twips per inch.
      /// </summary>
      public property Inch: Int16 read GetInch write SetInch;
      strict private function GetReserved(): Integer;
      strict private procedure SetReserved(const Value: Integer);

      /// <summary>
      ///  Reserved. Do not use.
      /// </summary>
      public property Reserved: Integer read GetReserved write SetReserved;
      strict private function GetChecksum(): Int16;
      strict private procedure SetChecksum(const Value: Int16);

      /// <summary>
      ///  Indicates the checksum value for the previous ten WORDs in the header.
      /// </summary>
      public property Checksum: Int16 read GetChecksum write SetChecksum;


      public constructor Create();
   end;


   { TGdipMetaHeader }

   TGdipMetaHeader = packed class sealed

      // The ENHMETAHEADER structure is defined natively as a union with WmfHeader.
      // Extreme care should be taken if changing the layout of the corresponding managed
      // structures to minimize the risk of buffer overruns.  The affected managed classes
      // are the following: ENHMETAHEADER, MetaHeader, MetafileHeaderWmf, MetafileHeaderEmf.

      protected _data: TMetaHeader;
      strict private class constructor CreateClass();
      strict private class destructor DestroyClass();
      public procedure AfterConstruction; override;
      public procedure BeforeDestruction; override;

      strict private function GetType(): Int16;
      strict private procedure SetType(const Value: Int16);

      /// <summary>
    ///  Represents the type of the associated <see cref='Metafile'/>.
    /// </summary>
      public property Type_: Int16 read GetType write SetType;
      strict private function GetHeaderSize(): Int16;
      strict private procedure SetHeaderSize(const Value: Int16);

      /// <summary>
    ///  Represents the size, in bytes, of the header file.
    /// </summary>
      public property HeaderSize: Int16 read GetHeaderSize write SetHeaderSize;
      strict private function GetVersion(): Int16;
      strict private procedure SetVersion(const Value: Int16);

      /// <summary>
    ///  Represents the version number of the header format.
    /// </summary>
      public property Version: Int16 read GetVersion write SetVersion;
      strict private function GetSize(): Integer;
      strict private procedure SetSize(const Value: Integer);

      /// <summary>
    ///  Represents the size, in bytes, of the associated <see cref='Metafile'/>.
    /// </summary>
      public property Size: Integer read GetSize write SetSize;
      strict private function GetNoObjects(): Int16;
      strict private procedure SetNoObjects(const Value: Int16);


      public property NoObjects: Int16 read GetNoObjects write SetNoObjects;
      strict private function GetMaxRecord(): Integer;
      strict private procedure SetMaxRecord(const Value: Integer);


      public property MaxRecord: Integer read GetMaxRecord write SetMaxRecord;
      strict private function GetNoParameters(): Int16;
      strict private procedure SetNoParameters(const Value: Int16);


      public property NoParameters: Int16 read GetNoParameters write SetNoParameters;


      public constructor Create(); overload;


      protected constructor Create(const header: TMetaHeader); overload;
   end;


   { TGdipMetafileHeader }

   /// <summary>
///  Contains attributes of an associated <see cref='Metafile'/>.
/// </summary>
   TGdipMetafileHeader = packed class sealed


      protected _header: TGdiPlusAPI.TGdipNativeMetafileHeader;
      strict private class constructor CreateClass();
      strict private class destructor DestroyClass();
      public procedure AfterConstruction; override;
      public procedure BeforeDestruction; override;

      strict private function GetType(): TGdipMetafileType;

      /// <summary>
    ///  Gets the type of the associated <see cref='Metafile'/>.
    /// </summary>
      public property Type_: TGdipMetafileType read GetType;
      strict private function GetMetafileSize(): Integer;

      /// <summary>
    ///  Gets the size, in bytes, of the associated <see cref='Metafile'/>.
    /// </summary>
      public property MetafileSize: Integer read GetMetafileSize;
      strict private function GetVersion(): Integer;

      /// <summary>
    ///  Gets the version number of the associated <see cref='Metafile'/>.
    /// </summary>
      public property Version: Integer read GetVersion;
      strict private function GetDpiX(): Single;

      /// <summary>
    ///  Gets the horizontal resolution, in dots-per-inch, of the associated <see cref='Metafile'/>.
    /// </summary>
      public property DpiX: Single read GetDpiX;
      strict private function GetDpiY(): Single;

      /// <summary>
    ///  Gets the vertical resolution, in dots-per-inch, of the associated <see cref='Metafile'/>.
    /// </summary>
      public property DpiY: Single read GetDpiY;
      strict private function GetBounds(): TRectangle;

      /// <summary>
    ///  Gets a <see cref='Rectangle'/> that bounds the associated <see cref='Metafile'/>.
    /// </summary>
      public property Bounds: TRectangle read GetBounds;
      strict private function GetWmfHeader(): TGdipMetaHeader;

      /// <summary>
    ///  Gets the WMF header file for the associated <see cref='Metafile'/>.
    /// </summary>
      public property WmfHeader: TGdipMetaHeader read GetWmfHeader;
      strict private function GetEmfPlusHeaderSize(): Integer;

      /// <summary>
    ///  Gets the size, in bytes, of the enhanced metafile plus header file.
    /// </summary>
      public property EmfPlusHeaderSize: Integer read GetEmfPlusHeaderSize;
      strict private function GetLogicalDpiX(): Integer;

      /// <summary>
    ///  Gets the logical horizontal resolution, in dots-per-inch, of the associated <see cref='Metafile'/>.
    /// </summary>
      public property LogicalDpiX: Integer read GetLogicalDpiX;
      strict private function GetLogicalDpiY(): Integer;

      /// <summary>
    ///  Gets the logical vertical resolution, in dots-per-inch, of the associated <see cref='Metafile'/>.
    /// </summary>
      public property LogicalDpiY: Integer read GetLogicalDpiY;


      protected constructor Create();

      /// <summary>
    ///  Returns a value indicating whether the associated <see cref='Metafile'/> is in the Windows metafile format.
    /// </summary>
      public function IsWmf(): Boolean;

      /// <summary>
    ///  Returns a value indicating whether the associated <see cref='Metafile'/> is in the Windows Placeable metafile format.
    /// </summary>
      public function IsWmfPlaceable(): Boolean;

      /// <summary>
    ///  Returns a value indicating whether the associated <see cref='Metafile'/> is in the Windows enhanced metafile format.
    /// </summary>
      public function IsEmf(): Boolean;

      /// <summary>
    ///  Returns a value indicating whether the associated <see cref='Metafile'/> is in the Windows enhanced
    ///  metafile format or the Windows enhanced metafile plus.
    /// </summary>
      public function IsEmfOrEmfPlus(): Boolean;

      /// <summary>
    ///  Returns a value indicating whether the associated <see cref='Metafile'/> is in the Windows enhanced
    ///  metafile plus format.
    /// </summary>
      public function IsEmfPlus(): Boolean;

      /// <summary>
    ///  Returns a value indicating whether the associated <see cref='Metafile'/> is in the Dual enhanced metafile
    ///  format. This format supports both the enhanced and the enhanced plus format.
    /// </summary>
      public function IsEmfPlusDual(): Boolean;

      /// <summary>
    ///  Returns a value indicating whether the associated <see cref='Metafile'/> supports only the Windows
    ///  enhanced metafile plus format.
    /// </summary>
      public function IsEmfPlusOnly(): Boolean;

      /// <summary>
    ///  Returns a value indicating whether the associated <see cref='Metafile'/> is device-dependent.
    /// </summary>
      public function IsDisplay(): Boolean;
   end;



   { TGdipMetafile }

   /// <summary>
   ///  Defines a graphic metafile. A metafile contains records that describe a sequence of graphics operations that
   ///  can be recorded and played back.
   /// </summary>
   TGdipMetafile = class sealed(TGdipImage)

      // GDI+ doesn't handle filenames over MAX_PATH very well

      strict private const MaxPath: Integer = 260;
      strict private class constructor CreateClass();
      strict private class destructor DestroyClass();
      public procedure AfterConstruction; override;
      public procedure BeforeDestruction; override;


      /// <summary>
    ///  Initializes a new instance of the <see cref='Metafile'/> class from the specified handle and
    ///  <see cref='WmfPlaceableFileHeader'/>.
    /// </summary>
      public constructor Create(const hmetafile: HMETAFILE; const wmfHeader: TGdipWmfPlaceableFileHeader; const deleteWmf: Boolean); overload;

      /// <summary>
    ///  Initializes a new instance of the <see cref='Metafile'/> class from the specified handle and
    ///  <see cref='WmfPlaceableFileHeader'/>.
    /// </summary>
      public constructor Create(const henhmetafile: HENHMETAFILE; const deleteEmf: Boolean); overload;

      /// <summary>
    ///  Initializes a new instance of the <see cref='Metafile'/> class from the specified filename.
    /// </summary>
      public constructor Create(const filename: string); overload;

      /// <summary>
    ///  Initializes a new instance of the <see cref='Metafile'/> class from the specified device context, bounded
    ///  by the specified rectangle.
    /// </summary>
      public constructor Create(const referenceHdc: TDeviceContextHandle; const frameRect: TRectangle); overload;

      /// <summary>
    ///  Initializes a new instance of the <see cref='Metafile'/> class from the specified handle to a device context.
    /// </summary>
      public constructor Create(const referenceHdc: TDeviceContextHandle; const emfType: TGdipEmfType); overload;

      /// <summary>
    ///  Initializes a new instance of the <see cref='Metafile'/> class from the specified device context, bounded
    ///  by the specified rectangle.
    /// </summary>
      public constructor Create(const referenceHdc: TDeviceContextHandle; const frameRect: TRectangleF); overload;

      /// <summary>
    ///  Initializes a new instance of the <see cref='Metafile'/> class from the specified device context, bounded
    ///  by the specified rectangle.
    /// </summary>
      public constructor Create(const referenceHdc: TDeviceContextHandle; const frameRect: TRectangleF; const frameUnit: TGdipMetafileFrameUnit); overload;

      /// <summary>
    ///  Initializes a new instance of the <see cref='Metafile'/> class from the specified device context, bounded
    ///  by the specified rectangle.
    /// </summary>
      public constructor Create(const referenceHdc: TDeviceContextHandle; const frameRect: TRectangleF; const frameUnit: TGdipMetafileFrameUnit; const type_: TGdipEmfType); overload;

      /// <summary>
    ///  Initializes a new instance of the <see cref='Metafile'/> class from the specified device context, bounded
    ///  by the specified rectangle.
    /// </summary>
      public constructor Create(const referenceHdc: TDeviceContextHandle; const frameRect: TRectangleF; const frameUnit: TGdipMetafileFrameUnit; const type_: TGdipEmfType; const description: string); overload;

      /// <summary>
    ///  Initializes a new instance of the <see cref='Metafile'/> class from the specified device context, bounded
    ///  by the specified rectangle.
    /// </summary>
      public constructor Create(const referenceHdc: TDeviceContextHandle; const frameRect: TRectangle; const frameUnit: TGdipMetafileFrameUnit); overload;

      /// <summary>
    ///  Initializes a new instance of the <see cref='Metafile'/> class from the specified device context, bounded
    ///  by the specified rectangle.
    /// </summary>
      public constructor Create(const referenceHdc: TDeviceContextHandle; const frameRect: TRectangle; const frameUnit: TGdipMetafileFrameUnit; const type_: TGdipEmfType); overload;

      /// <summary>
    ///  Initializes a new instance of the <see cref='Metafile'/> class with the specified filename.
    /// </summary>
      public constructor Create(const fileName: string; const referenceHdc: TDeviceContextHandle); overload;

      /// <summary>
    ///  Initializes a new instance of the <see cref='Metafile'/> class with the specified filename.
    /// </summary>
      public constructor Create(const fileName: string; const referenceHdc: TDeviceContextHandle; const type_: TGdipEmfType); overload;

      /// <summary>
    ///  Initializes a new instance of the <see cref='Metafile'/> class with the specified filename.
    /// </summary>
      public constructor Create(const fileName: string; const referenceHdc: TDeviceContextHandle; const frameRect: TRectangleF); overload;

      /// <summary>
    ///  Initializes a new instance of the <see cref='Metafile'/> class with the specified filename.
    /// </summary>
      public constructor Create(const fileName: string; const referenceHdc: TDeviceContextHandle; const frameRect: TRectangleF; const frameUnit: TGdipMetafileFrameUnit); overload;

      /// <summary>
    ///  Initializes a new instance of the <see cref='Metafile'/> class with the specified filename.
    /// </summary>
      public constructor Create(const fileName: string; const referenceHdc: TDeviceContextHandle; const frameRect: TRectangleF; const frameUnit: TGdipMetafileFrameUnit; const type_: TGdipEmfType); overload;

      /// <summary>
    ///  Initializes a new instance of the <see cref='Metafile'/> class with the specified filename.
    /// </summary>
      public constructor Create(const fileName: string; const referenceHdc: TDeviceContextHandle; const frameRect: TRectangleF; const frameUnit: TGdipMetafileFrameUnit; const desc: string); overload;

      /// <summary>
    ///  Initializes a new instance of the <see cref='Metafile'/> class with the specified filename.
    /// </summary>
      public constructor Create(const fileName: string; const referenceHdc: TDeviceContextHandle; const frameRect: TRectangleF; const frameUnit: TGdipMetafileFrameUnit; const type_: TGdipEmfType; const description: string); overload;

      /// <summary>
    ///  Initializes a new instance of the <see cref='Metafile'/> class with the specified filename.
    /// </summary>
      public constructor Create(const fileName: string; const referenceHdc: TDeviceContextHandle; const frameRect: TRectangle); overload;

      /// <summary>
    ///  Initializes a new instance of the <see cref='Metafile'/> class with the specified filename.
    /// </summary>
      public constructor Create(const fileName: string; const referenceHdc: TDeviceContextHandle; const frameRect: TRectangle; const frameUnit: TGdipMetafileFrameUnit); overload;

      /// <summary>
    ///  Initializes a new instance of the <see cref='Metafile'/> class with the specified filename.
    /// </summary>
      public constructor Create(const fileName: string; const referenceHdc: TDeviceContextHandle; const frameRect: TRectangle; const frameUnit: TGdipMetafileFrameUnit; const type_: TGdipEmfType); overload;

      /// <summary>
    ///  Initializes a new instance of the <see cref='Metafile'/> class with the specified filename.
    /// </summary>
      public constructor Create(const fileName: string; const referenceHdc: TDeviceContextHandle; const frameRect: TRectangle; const frameUnit: TGdipMetafileFrameUnit; const description: string); overload;

      /// <summary>
    ///  Initializes a new instance of the <see cref='Metafile'/> class from the specified data stream.
    /// </summary>
      public constructor Create(const stream: TStream; const referenceHdc: TDeviceContextHandle); overload;

      /// <summary>
    ///  Initializes a new instance of the <see cref='Metafile'/> class from the specified data stream.
    /// </summary>
      public constructor Create(const stream: TStream; const referenceHdc: TDeviceContextHandle; const type_: TGdipEmfType); overload;

      /// <summary>
    ///  Initializes a new instance of the <see cref='Metafile'/> class from the specified data stream.
    /// </summary>
      public constructor Create(const stream: TStream; const referenceHdc: TDeviceContextHandle; const frameRect: TRectangleF); overload;

      /// <summary>
    ///  Initializes a new instance of the <see cref='Metafile'/> class with the specified filename.
    /// </summary>
      public constructor Create(const stream: TStream; const referenceHdc: TDeviceContextHandle; const frameRect: TRectangleF; const frameUnit: TGdipMetafileFrameUnit); overload;

      /// <summary>
    ///  Initializes a new instance of the <see cref='Metafile'/> class with the specified filename.
    /// </summary>
      public constructor Create(const stream: TStream; const referenceHdc: TDeviceContextHandle; const frameRect: TRectangleF; const frameUnit: TGdipMetafileFrameUnit; const type_: TGdipEmfType); overload;

      /// <summary>
    ///  Initializes a new instance of the <see cref='Metafile'/> class from the specified data stream.
    /// </summary>
      public constructor Create(const stream: TStream; const referenceHdc: TDeviceContextHandle; const frameRect: TRectangle); overload;

      /// <summary>
    ///  Initializes a new instance of the <see cref='Metafile'/> class with the specified filename.
    /// </summary>
      public constructor Create(const stream: TStream; const referenceHdc: TDeviceContextHandle; const frameRect: TRectangle; const frameUnit: TGdipMetafileFrameUnit); overload;

      /// <summary>
    ///  Initializes a new instance of the <see cref='Metafile'/> class with the specified filename.
    /// </summary>
      public constructor Create(const stream: TStream; const referenceHdc: TDeviceContextHandle; const frameRect: TRectangle; const frameUnit: TGdipMetafileFrameUnit; const type_: TGdipEmfType); overload;

      /// <summary>
    ///  Initializes a new instance of the <see cref='Metafile'/> class from the specified handle and
    ///  <see cref='WmfPlaceableFileHeader'/>.
    /// </summary>
      public constructor Create(const hmetafile: HMETAFILE; const wmfHeader: TGdipWmfPlaceableFileHeader); overload;

      /// <summary>
    ///  Initializes a new instance of the <see cref='Metafile'/> class from the specified stream.
    /// </summary>
      public constructor Create(const stream: TStream); overload;

      /// <summary>
    ///  Initializes a new instance of the <see cref='Metafile'/> class from the specified handle to a device context.
    /// </summary>
      public constructor Create(const referenceHdc: TDeviceContextHandle; const emfType: TGdipEmfType; const description: string); overload;

      /// <summary>
    ///  Initializes a new instance of the <see cref='Metafile'/> class from the specified device context, bounded
    ///  by the specified rectangle.
    /// </summary>
      public constructor Create(const referenceHdc: TDeviceContextHandle; const frameRect: TRectangle; const frameUnit: TGdipMetafileFrameUnit; const type_: TGdipEmfType; const desc: string); overload;

      /// <summary>
    ///  Initializes a new instance of the <see cref='Metafile'/> class with the specified filename.
    /// </summary>
      public constructor Create(const fileName: string; const referenceHdc: TDeviceContextHandle; const type_: TGdipEmfType; const description: string); overload;

      /// <summary>
    /// Initializes a new instance of the <see cref='Metafile'/> class with the specified filename.
    /// </summary>
      public constructor Create(const fileName: string; const referenceHdc: TDeviceContextHandle; const frameRect: TRectangle; const frameUnit: TGdipMetafileFrameUnit; const type_: TGdipEmfType; const description: string); overload;

      /// <summary>
    ///  Initializes a new instance of the <see cref='Metafile'/> class from the specified data stream.
    /// </summary>
      public constructor Create(const stream: TStream; const referenceHdc: TDeviceContextHandle; const type_: TGdipEmfType; const description: string); overload;

      /// <summary>
    ///  Initializes a new instance of the <see cref='Metafile'/> class with the specified filename.
    /// </summary>
      public constructor Create(const stream: TStream; const referenceHdc: TDeviceContextHandle; const frameRect: TRectangleF; const frameUnit: TGdipMetafileFrameUnit; const type_: TGdipEmfType; const description: string); overload;

      /// <summary>
    ///  Initializes a new instance of the <see cref='Metafile'/> class with the specified filename.
    /// </summary>
      public constructor Create(const stream: TStream; const referenceHdc: TDeviceContextHandle; const frameRect: TRectangle; const frameUnit: TGdipMetafileFrameUnit; const type_: TGdipEmfType; const description: string); overload;

      /// <summary>
    ///  Initializes a new instance of the <see cref="Metafile"/> class from a native metafile handle.
    /// </summary>
      protected constructor Create(const ptr: Pointer); overload;

      /// <summary>
    ///  Plays an EMF+ file.
    /// </summary>
      public procedure PlayRecord(const recordType: TGdipEmfPlusRecordType; const flags: Integer; const dataSize: Integer; const data: TArray<Byte>);

      /// <summary>
    ///  Returns the <see cref='MetafileHeader'/> associated with the specified <see cref='Metafile'/>.
    /// </summary>
      public class function GetMetafileHeader(const hmetafile: HMETAFILE; const wmfHeader: TGdipWmfPlaceableFileHeader): TGdipMetafileHeader; overload; static;

      /// <summary>
    ///  Returns the <see cref='MetafileHeader'/> associated with the specified <see cref='Metafile'/>.
    /// </summary>
      public class function GetMetafileHeader(const henhmetafile: HENHMETAFILE): TGdipMetafileHeader; overload; static;

      /// <summary>
    ///  Returns the <see cref='MetafileHeader'/> associated with the specified <see cref='Metafile'/>.
    /// </summary>
      public class function GetMetafileHeader(const fileName: string): TGdipMetafileHeader; overload; static;

      /// <summary>
    ///  Returns the <see cref='MetafileHeader'/> associated with the specified <see cref='Metafile'/>.
    /// </summary>
      public class function GetMetafileHeader(const stream: TStream): TGdipMetafileHeader; overload; static;

      /// <summary>
    ///  Returns the <see cref='MetafileHeader'/> associated with this <see cref='Metafile'/>.
    /// </summary>
      public function GetMetafileHeader(): TGdipMetafileHeader; overload;

      /// <summary>
    ///  Returns a Windows handle to an enhanced <see cref='Metafile'/>.
    /// </summary>
      public function GetHenhmetafile(): HENHMETAFILE;
   end;





   { TGdipEffect }


   /// <summary>
///  Base class for all effects.
/// </summary>
   TGdipEffect = class abstract//(TInterfacedObject, IDisposable)
      strict private _nativeEffect: TGdiplusAPI.TGdipEffectPtr;
      strict private function GetNativeEffect(): TGdiplusAPI.TGdipEffectPtr;
      protected property NativeEffect: TGdiplusAPI.TGdipEffectPtr read GetNativeEffect;
      strict protected constructor Create(const guid: TGuid);
      public destructor Destroy(); override;
      public procedure Dispose(); overload;
      strict protected procedure SetParameters<T>(var parameters: T);
      public procedure Dispose(const disposing: Boolean); overload; virtual;
   end;



{$REGION 'TGdipBitmapHistogram'}

  { TGdipBitmapHistogram }

  TGdipBitmapHistogram = class sealed
     strict private m_channelCount: Integer;
     strict private m_entryCount: Integer;
     strict private m_channels: array[0..3] of PCardinal;
     strict private function GetChannelCount: Integer;
     strict private function GetEntryCount: Integer;
     strict private function GetValue(const ChannelIndex, EntryIndex: Integer): Cardinal;
     strict private function GetChannel0(const Index: Integer): Cardinal;
     strict private function GetChannel1(const Index: Integer): Cardinal;
     strict private function GetChannel2(const Index: Integer): Cardinal;
     strict private function GetChannel3(const Index: Integer): Cardinal;
     strict private function GetValuePtr(const ChannelIndex: Integer): PCardinal;
     strict private function GetChannel0Ptr: PCardinal;
     strict private function GetChannel1Ptr: PCardinal;
     strict private function GetChannel2Ptr: PCardinal;
     strict private function GetChannel3Ptr: PCardinal;
     private constructor Create(const AChannelCount, AEntryCount: Integer; const AChannel0, AChannel1, AChannel2, AChannel3: PCardinal);
     public destructor Destroy; override;
     public property ChannelCount: Integer read GetChannelCount;
     public property EntryCount: Integer read GetEntryCount;
     public property Values[const ChannelIndex, EntryIndex: Integer]: Cardinal read GetValue; default;
     public property Channel0[const Index: Integer]: Cardinal read GetChannel0;
     public property Channel1[const Index: Integer]: Cardinal read GetChannel1;
     public property Channel2[const Index: Integer]: Cardinal read GetChannel2;
     public property Channel3[const Index: Integer]: Cardinal read GetChannel3;
     public property ValuePtr[const ChannelIndex: Integer]: PCardinal read GetValuePtr;
     public property Channel0Ptr: PCardinal read GetChannel0Ptr;
     public property Channel1Ptr: PCardinal read GetChannel1Ptr;
     public property Channel2Ptr: PCardinal read GetChannel2Ptr;
     public property Channel3Ptr: PCardinal read GetChannel3Ptr;
  end;

{$ENDREGION 'TGdipBitmapHistogram'}



{$REGION 'TGdipBitmap'}

   { TGdipBitmap }

   TGdipBitmap = class sealed(TGdipImage)
      strict private class var s_defaultTransparentColor: TGdipColor;

      strict private class constructor CreateClass();

      public function GetPointer(): TGdiplusAPI.TGdipBitmapPtr; reintroduce;


//      public property Pointer: TGdiplusAPI.TGdipBitmapPtr read GetPointer;


      protected constructor Create(const ptr: TGdiplusAPI.TGdipBitmapPtr); overload;


      public constructor Create(const filename: string); overload;


      public constructor Create(filename: string; const useIcm: Boolean); overload;


      public constructor Create(const stream: TStream); overload;


      public constructor Create(const stream: TStream; const useIcm: Boolean); overload;


      public constructor Create(const type_: TRttiType; const resource: string); overload;


      public constructor Create(const width: Integer; const height: Integer); overload;


      public constructor Create(const width: Integer; const height: Integer; const g: TGdipGraphics); overload;


      public constructor Create(const width: Integer; const height: Integer; const stride: Integer; const format: TGdipPixelFormat; const scan0: Pointer); overload;


      public constructor Create(const width: Integer; const height: Integer; const format: TGdipPixelFormat); overload;


      public constructor Create(const original: TGdipImage); overload;


      public constructor Create(const original: TGdipImage; const newSize: TSize); overload;


      public constructor Create(const original: TGdipImage; const width: Integer; const height: Integer); overload;


//      strict private constructor Create(const info: TSerializationInfo; const context: TStreamingContext); overload;


      strict private class function GetResourceStream(const type_: TRttiType; const resource: string): TStream; static;


      public class function FromHicon(const hicon: HICON): TGdipBitmap; static;


      public class function FromResource(const hinstance: HINST; const bitmapName: string): TGdipBitmap; static;


      public function GetHbitmap(): HBITMAP; overload;


      public function GetHbitmap(const background: TGdipColor): HBITMAP; overload;


      public function GetHicon(): HICON;


      public function Clone(const rect: TRectangleF; const format: TGdipPixelFormat): TGdipBitmap; overload;


      public procedure MakeTransparent(); overload;


      public procedure MakeTransparent(const transparentColor: TGdipColor); overload;


      public function LockBits(const rect: TRectangle; const flags: TGdipImageLockMode; const format: TGdipPixelFormat): TGdipBitmapData; overload;


      public function LockBits(const rect: TRectangle; const flags: TGdipImageLockMode; const format: TGdipPixelFormat; const bitmapData: TGdipBitmapData): TGdipBitmapData; overload;

      public procedure LockBits(const rect: TRectangle; const flags: TGdiPlusAPI.TGdipImageLockModeEnum; const format: TGdiPlusAPI.TGdipPixelFormatEnum; data: TGdiplusAPI.TGdipBitmapDataPtr); overload;

      public procedure UnlockBits(const bitmapdata: TGdipBitmapData); overload;

      public procedure UnlockBits(data: TGdiplusAPI.TGdipBitmapDataPtr); overload;

      public function GetPixel(const x: Integer; const y: Integer): TGdipColor;


      public procedure SetPixel(const x: Integer; const y: Integer; const color: TGdipColor);
      public property Pixels[const X, Y: Integer]: TGdipColor read GetPixel write SetPixel;


      public procedure SetResolution(const xDpi: Single; const yDpi: Single);


      public function Clone(const rect: TRectangle; const format: TGdipPixelFormat): TGdipBitmap; overload;

      // #if NET9_0_OR_GREATER -> IfDirectiveTrivia
      /// <summary>
    ///  Alters the bitmap by applying the given <paramref name="effect"/>.
    /// </summary>
    /// <param name="effect">The effect to apply.</param>
    /// <param name="area">The area to apply to, or <see cref="Rectangle.Empty"/> for the entire image.</param>
      public procedure ApplyEffect(const effect: TGdipEffect; const area: TRectangle);

      /// <summary>
    ///  Converts the bitmap to the specified <paramref name="format"/> using the given <paramref name="ditherType"/>.
    ///  The original pixel data is replaced with the new format.
    /// </summary>
    /// <param name="format">
    ///  <para>
    ///   The new pixel format. <see cref="PixelFormat.Format16bppGrayScale"/> is not supported.
    ///  </para>
    /// </param>
    /// <param name="ditherType">
    ///  <para>
    ///   The dithering algorithm. Pass <see cref="DitherType.None"/> when the conversion does not reduce the bit depth
    ///   of the pixel data.
    ///  </para>
    ///  <para>
    ///   This must be <see cref="DitherType.Solid"/> or <see cref="DitherType.ErrorDiffusion"/> if the <paramref name="paletteType"/>
    ///   is <see cref="PaletteType.Custom"/> or <see cref="PaletteType.FixedBW"/>.
    ///  </para>
    /// </param>
    /// <param name="paletteType">
    ///  <para>
    ///   The palette type to use when the pixel format is indexed. Ignored for non-indexed pixel formats.
    ///  </para>
    /// </param>
    /// <param name="palette">
    ///  <para>
    ///   Pointer to a <see cref="ColorPalette"/> that specifies the palette whose indexes are stored in the pixel data
    ///   of the converted bitmap. This must be specified for indexed pixel formats.
    ///  </para>
    ///  <para>
    ///   This palette (called the actual palette) does not have to have the type specified by
    ///   the <paramref name="paletteType"/> parameter. The <paramref name="paletteType"/> parameter specifies a standard
    ///   palette that can be used by any of the ordered or spiral dithering algorithms. If the actual palette has a type
    ///   other than that specified by the <paramref name="paletteType"/> parameter, then
    ///   <see cref="ConvertFormat(PixelFormat, DitherType, PaletteType, ColorPalette?, float)"/> performs a nearest-color
    ///   conversion from the standard palette to the actual palette.
    ///  </para>
    /// </param>
    /// <param name="alphaThresholdPercent">
    ///  <para>
    ///   Real number in the range 0 through 100 that specifies which pixels in the source bitmap will map to the
    ///   transparent color in the converted bitmap.
    ///  </para>
    ///  <para>
    ///   A value of 0 specifies that none of the source pixels map to the transparent color. A value of 100
    ///   specifies that any pixel that is not fully opaque will map to the transparent color. A value of t specifies
    ///   that any source pixel less than t percent of fully opaque will map to the transparent color. Note that for
    ///   the alpha threshold to be effective, the palette must have a transparent color. If the palette does not have
    ///   a transparent color, pixels with alpha values below the threshold will map to color that most closely
    ///   matches (0, 0, 0, 0), usually black.
    ///  </para>
    /// </param>
    /// <remarks>
    ///  <para>
    ///   <paramref name="paletteType"/> and <paramref name="palette"/> really only have relevance with indexed pixel
    ///   formats. You can pass a <see cref="ColorPalette"/> for non-indexed pixel formats, but it has no impact on the
    ///   transformation and will effective just call <see cref="Image.Palette"/> to set the palette when the conversion
    ///   is complete.
    ///  </para>
    /// </remarks>
      public procedure ConvertFormat(const format: TGdipPixelFormat; const ditherType: TGdipDitherType; const paletteType: TGdipPaletteType = TGdipPaletteType.Custom; const palette: TGdipColorPalette = nil; const alphaThresholdPercent: Single = Single(0.0)); overload;

      /// <summary>
      ///  Converts the bitmap to the specified <paramref name="format"/>.
      ///  The original pixel data is replaced with the new format.
      /// </summary>
      /// <param name="format">
      ///  <para>
      ///   The new pixel format. <see cref="PixelFormat.Format16bppGrayScale"/> is not supported.
      ///  </para>
      /// </param>
      public procedure ConvertFormat(const format: TGdipPixelFormat); overload;

      public function GetHistogram(const Format: TGdipHistogramFormat): TGdipBitmapHistogram;
   end;

{$ENDREGION 'TGdipBitmap'}


   { TGdipBlend }

   TGdipBlend = class sealed

      strict private m_factors: TArray<Single>;

      public property Factors: TArray<Single> read m_factors write m_factors;
      strict private m_positions: TArray<Single>;

      public property Positions: TArray<Single> read m_positions write m_positions;

      public constructor Create(); overload;
      public constructor Create(const count: Integer); overload;
      public constructor Create(const factors, positions: array of Single); overload;
   end;

   { TGdipColorBlend }

   TGdipColorBlend = class sealed
      strict private m_colors: TArray<TGdipColor>;
      public property Colors: TArray<TGdipColor> read m_colors write m_colors;

      strict private m_positions: TArray<Single>;
      public property Positions: TArray<Single> read m_positions write m_positions;

      public constructor Create(); overload;
      public constructor Create(const count: Integer); overload;
      public constructor Create(const colors: TArray<TGdipColor>; const positions: TArray<Single>); overload;
   end;


   { TGdipPathGradientBrush }

   TGdipPathGradientBrush = class sealed(TGdipBrush)
      strict private function GetNativePathGradient(): TGdiplusAPI.TGdipPathGradientPtr;


      protected property NativePathGradient: TGdiplusAPI.TGdipPathGradientPtr read GetNativePathGradient;
      strict private function GetCenterColor(): TGdipColor;
      strict private procedure SetCenterColor(const Value: TGdipColor);


      public property CenterColor: TGdipColor read GetCenterColor write SetCenterColor;
      strict private function GetSurroundColors(): TArray<TGdipColor>;
      strict private procedure SetSurroundColors(const colors: TArray<TGdipColor>);


      public property SurroundColors: TArray<TGdipColor> read GetSurroundColors write SetSurroundColors;
      strict private function GetCenterPoint(): TPointF;
      strict private procedure SetCenterPoint(const Value: TPointF);


      public property CenterPoint: TPointF read GetCenterPoint write SetCenterPoint;
      strict private function GetRectangle(): TRectangleF;


      public property Rectangle: TRectangleF read GetRectangle;
      strict private function GetBlend(): TGdipBlend;
      strict private procedure SetBlend(const Value: TGdipBlend);


      public property Blend: TGdipBlend read GetBlend write SetBlend;
      strict private function GetInterpolationColors(): TGdipColorBlend;
      strict private procedure SetInterpolationColors(const Value: TGdipColorBlend);


      public property InterpolationColors: TGdipColorBlend read GetInterpolationColors write SetInterpolationColors;
      strict private function GetTransform(): TGdipMatrix;
      strict private procedure SetTransform(const Value: TGdipMatrix);


      public property Transform: TGdipMatrix read GetTransform write SetTransform;
      strict private function GetFocusScales(): TPointF;
      strict private procedure SetFocusScales(const Value: TPointF);

      strict private function GetGammaCorrection(): Boolean;
      strict private procedure SetGammaCorrection(const Value: Boolean);
      public property GammaCorrection: Boolean read GetGammaCorrection write SetGammaCorrection;

      public property FocusScales: TPointF read GetFocusScales write SetFocusScales;
      strict private function GetWrapMode(): TGdipWrapMode;
      strict private procedure SetWrapMode(const Value: TGdipWrapMode);


      public property WrapMode: TGdipWrapMode read GetWrapMode write SetWrapMode;

      public constructor Create(const points: TArray<TPointF>); overload;


      public constructor Create(const points: TArray<TPointF>; const wrapMode: TGdipWrapMode); overload;


      public constructor Create(const points: TArray<TPoint>); overload;


      public constructor Create(const points: TArray<TPoint>; const wrapMode: TGdipWrapMode); overload;


      public constructor Create(const path: TGdipGraphicsPath); overload;


      protected constructor Create(const nativeBrush: TGdiplusAPI.TGdipPathGradientPtr); overload;


      public function Clone(): TObject; override;


      public procedure SetSigmaBellShape(const focus: Single); overload;


      public procedure SetSigmaBellShape(const focus: Single; const scale: Single); overload;


      public procedure SetBlendTriangularShape(const focus: Single); overload;


      public procedure SetBlendTriangularShape(const focus: Single; const scale: Single); overload;


      public procedure ResetTransform();


      public procedure MultiplyTransform(const matrix: TGdipMatrix); overload;


      public procedure MultiplyTransform(const matrix: TGdipMatrix; const order: TGdipMatrixOrder); overload;


      public procedure TranslateTransform(const dx: Single; const dy: Single); overload;


      public procedure TranslateTransform(const dx: Single; const dy: Single; const order: TGdipMatrixOrder); overload;


      public procedure ScaleTransform(const sx: Single; const sy: Single); overload;


      public procedure ScaleTransform(const sx: Single; const sy: Single; const order: TGdipMatrixOrder); overload;


      public procedure RotateTransform(const angle: Single); overload;


      public procedure RotateTransform(const angle: Single; const order: TGdipMatrixOrder); overload;
   end;

{$REGION 'TGdipLinearGradientBrush'}

   { TGdipLinearGradientBrush }


   TGdipLinearGradientBrush = class sealed(TGdipBrush)
      strict private _interpolationColorsWasSet: Boolean;
      strict private function GetNativeLineGradient(): TGdiplusAPI.TGdipLineGradientPtr;


      protected property NativeLineGradient: TGdiplusAPI.TGdipLineGradientPtr read GetNativeLineGradient;
      strict private function GetLinearColors(): TArray<TGdipColor>;
      strict private procedure SetLinearColors(const Value: TArray<TGdipColor>);


      public property LinearColors: TArray<TGdipColor> read GetLinearColors write SetLinearColors;
      strict private function GetRectangle(): TRectangleF;


      public property Rectangle: TRectangleF read GetRectangle;
      strict private function GetGammaCorrection(): Boolean;
      strict private procedure SetGammaCorrection(const Value: Boolean);


      public property GammaCorrection: Boolean read GetGammaCorrection write SetGammaCorrection;
      strict private function GetBlend(): TGdipBlend;
      strict private procedure SetBlend(const Value: TGdipBlend);


      public property Blend: TGdipBlend read GetBlend write SetBlend;
      strict private function GetInterpolationColors(): TGdipColorBlend;
      strict private procedure SetInterpolationColors(const Value: TGdipColorBlend);


      public property InterpolationColors: TGdipColorBlend read GetInterpolationColors write SetInterpolationColors;
      strict private function GetWrapMode(): TGdipWrapMode;
      strict private procedure SetWrapMode(const Value: TGdipWrapMode);


      public property WrapMode: TGdipWrapMode read GetWrapMode write SetWrapMode;
      strict private function GetTransform(): TGdipMatrix;
      strict private procedure SetTransform(const Value: TGdipMatrix);


      public property Transform: TGdipMatrix read GetTransform write SetTransform;


      public constructor Create(const point1: TPointF; const point2: TPointF; const color1: TGdipColor; const color2: TGdipColor); overload;


      public constructor Create(const point1: TPoint; const point2: TPoint; const color1: TGdipColor; const color2: TGdipColor); overload;


      public constructor Create(const rect: TRectangleF; const color1: TGdipColor; const color2: TGdipColor; const linearGradientMode: TGdipLinearGradientMode); overload;


      public constructor Create(const rect: TRectangle; const color1: TGdipColor; const color2: TGdipColor; const linearGradientMode: TGdipLinearGradientMode); overload;


      public constructor Create(const rect: TRectangleF; const color1: TGdipColor; const color2: TGdipColor; const angle: Single); overload;


      public constructor Create(const rect: TRectangleF; const color1: TGdipColor; const color2: TGdipColor; const angle: Single; const isAngleScaleable: Boolean); overload;


      public constructor Create(const rect: TRectangle; const color1: TGdipColor; const color2: TGdipColor; const angle: Single); overload;


      public constructor Create(const rect: TRectangle; const color1: TGdipColor; const color2: TGdipColor; const angle: Single; const isAngleScaleable: Boolean); overload;


      protected constructor Create(const nativeBrush: TGdiplusAPI.TGdipLineGradientPtr); overload;


      public function Clone(): TObject; override;


      public procedure SetSigmaBellShape(const focus: Single); overload;


      public procedure SetSigmaBellShape(const focus: Single; const scale: Single); overload;


      public procedure SetBlendTriangularShape(const focus: Single); overload;


      public procedure SetBlendTriangularShape(const focus: Single; const scale: Single); overload;


      public procedure ResetTransform();


      public procedure MultiplyTransform(const matrix: TGdipMatrix); overload;


      public procedure MultiplyTransform(const matrix: TGdipMatrix; const order: TGdipMatrixOrder); overload;


      public procedure TranslateTransform(const dx: Single; const dy: Single); overload;


      public procedure TranslateTransform(const dx: Single; const dy: Single; const order: TGdipMatrixOrder); overload;


      public procedure ScaleTransform(const sx: Single; const sy: Single); overload;


      public procedure ScaleTransform(const sx: Single; const sy: Single; const order: TGdipMatrixOrder); overload;


      public procedure RotateTransform(const angle: Single); overload;


      public procedure RotateTransform(const angle: Single; const order: TGdipMatrixOrder); overload;
   end;

{$ENDREGION 'TGdipLinearGradientBrush'}

{$REGION 'TGdipImageCodecInfoHelper'}

   { TGdipImageCodecInfoHelperItem }

   TGdipImageCodecInfoHelperItem = record
      public Format: TGUID;
      public Encoder: TGUID;
   end;

   { TGdipImageCodecInfoHelper }

   TGdipImageCodecInfoHelper = class sealed (* static *)

      // Getting the entire array of ImageCodecInfo objects is expensive and not necessary when all we need are the
      // encoder CLSIDs. There are only 5 encoders: PNG, JPEG, GIF, BMP, and TIFF. We'll just build the small cache
      // here to avoid all of the overhead. (We could probably just hard-code the values, but on the very small chance
      // that the list of encoders changes, we'll keep it dynamic.)
      strict private class var s_encoders: TArray<TGdipImageCodecInfoHelperItem>;

      strict private class function GetEncoders(): TArray<TGdipImageCodecInfoHelperItem>; static;


      strict private class property Encoders: TArray<TGdipImageCodecInfoHelperItem> read GetEncoders;

      /// <summary>
    ///  Get the encoder guid for the given image format guid.
    /// </summary>
      protected class function GetEncoderClsid(const format: TGUID): TGUID; static;
   end;

{$ENDREGION 'TGdipImageCodecInfoHelper'}

implementation

uses
   Se7e.Drawing.Gdiplus;

{$REGION 'TGdipPathGradientBrush'}

{ TGdipPathGradientBrush }

function TGdipPathGradientBrush.GetNativePathGradient(): TGdiplusAPI.TGdipPathGradientPtr;
begin
   Result := TGdiplusAPI.TGdipPathGradientPtr(NativeBrush);
end;

function TGdipPathGradientBrush.GetCenterColor(): TGdipColor;
begin
   var argb: TARGB;
   TGdiplusAPI.GdipGetPathGradientCenterColor(NativePathGradient, @argb).ThrowIfFailed();

   Exit(argb);
end;

procedure TGdipPathGradientBrush.SetCenterColor(const Value: TGdipColor);
begin
   TGdiplusAPI.GdipSetPathGradientCenterColor(NativePathGradient, value.ToArgb).ThrowIfFailed();
end;

function TGdipPathGradientBrush.GetSurroundColors(): TArray<TGdipColor>;
begin
   var count: integer;

   TGdiplusAPI.GdipGetPathGradientSurroundColorCount(Self.NativeBrush, count).ThrowIfFailed();

   var argbs: TArray<UInt32>;
   SetLength(argbs, count);

   TGdiplusAPI.GdipGetPathGradientSurroundColorsWithCount(Self.NativeBrush, @argbs[0], count).ThrowIfFailed();

   var colors: TArray<TGdipColor>;
   SetLength(colors, count);

   for var i: Integer := 0 to count - 1 do
       colors[i] := TGdipColor.FromArgb(argbs[i]);

   Result := colors;
end;

procedure TGdipPathGradientBrush.SetSurroundColors(const colors: TArray<TGdipColor>);
begin
   var count: integer;

   TGdiplusAPI.GdipGetPathGradientSurroundColorCount(Self.NativeBrush, count).ThrowIfFailed();

   if ((Length(colors) > count) or (count <= 0)) then
       raise TGdip.StatusException(TGdiplusAPI.TGdipStatusEnum.InvalidParameter);

   count := Length(colors);
   var argbs: TArray<UInt32>;
   SetLength(argbs, count);

   for var i: Integer := 0 to Length(colors) - 1 do
       argbs[i] := colors[i].ToArgb();

   TGdiplusAPI.GdipSetPathGradientSurroundColorsWithCount(Self.NativeBrush, @argbs[0], count).ThrowIfFailed();
end;

function TGdipPathGradientBrush.GetCenterPoint(): TPointF;
begin
   var point: TPointF;
   TGdiplusAPI.GdipGetPathGradientCenterPoint(NativePathGradient, point).ThrowIfFailed();

   Exit(point);
end;

procedure TGdipPathGradientBrush.SetCenterPoint(const Value: TPointF);
begin
   TGdiplusAPI.GdipSetPathGradientCenterPoint(NativePathGradient, @value).ThrowIfFailed();
end;

function TGdipPathGradientBrush.GetRectangle(): TRectangleF;
begin
   var rect: TRectangleF;
   TGdiplusAPI.GdipGetPathGradientRect(NativePathGradient, rect).ThrowIfFailed();
   Exit(rect);
end;

function TGdipPathGradientBrush.GetBlend(): TGdipBlend;
begin
   // Figure out the size of blend factor array
   var count: Integer;
   TGdiplusAPI.GdipGetPathGradientBlendCount(NativePathGradient, count).ThrowIfFailed();

   var factors: TArray<Single>;
   SetLength(factors, count);
   var positions: TArray<Single>;
   SetLength(positions, count);

   var f: PSingle := @factors[0];
   var p: PSingle := @positions[0];
   begin
      TGdiplusAPI.GdipGetPathGradientBlend(NativePathGradient, f, p, count).ThrowIfFailed();
   end;

   // Return the result in a managed array
   var blend: TGdipBlend := TGdipBlend.Create(Length(factors));
   blend.Factors := factors;
   blend.Positions := positions;

   Exit(blend);
end;

procedure TGdipPathGradientBrush.SetBlend(const Value: TGdipBlend);
begin
   if value = nil then
      raise EArgumentNullException.Create('value');
   if value.Factors = nil then
      raise EArgumentNullException.Create('value.Factors');

   if (value.Positions = nil) or (Length(value.Positions) <> Length(value.Factors)) then
      raise EArgumentException.Create('SR.Format(SR.InvalidArgumentValue, ''value.Positions'', value.Positions), nameof(value)');

   var count: Integer := Length(value.Factors);
   var f: PSingle := @value.Factors[0];
   var p: PSingle := @value.Positions[0];
   begin
      // Set blend factors
      // Set blend factors
      TGdiplusAPI.GdipSetPathGradientBlend(NativePathGradient, f, p, count).ThrowIfFailed();
   end;
end;

function TGdipPathGradientBrush.GetInterpolationColors(): TGdipColorBlend;
begin
   var blend: TGdipColorBlend;

   // Figure out the size of blend factor array
   var retval: Integer := 0;
   TGdiplusAPI.GdipGetPathGradientPresetBlendCount(Self.NativeBrush, retval).ThrowIfFailed();

   // If retVal is 0, then there is nothing to marshal.
   // In this case, we'll return an empty ColorBlend...
   //
   if (retval = 0) then
       Exit(TGdipColorBlend.Create());

   var count: Integer := retval;

   var colors: TArray<UInt32>;
   SetLength(colors, count);

   var positions: TArray<Single>;
   SetLength(positions, count);

   // Retrieve horizontal blend factors
   TGdiplusAPI.GdipGetPathGradientPresetBlend(Self.NativeBrush, @colors[0], @positions[0], count).ThrowIfFailed();

   blend := TGdipColorBlend.Create(count);

   var blendColors := blend.Colors;
   SetLength(blendColors, count);

    for var i: Integer := 0 to count - 1 do
        blendColors[i] := TGdipColor.FromArgb(colors[i]);

   blend.Colors := blendColors;
   Result := blend;
end;

procedure TGdipPathGradientBrush.SetInterpolationColors(const Value: TGdipColorBlend);
begin
   if value = nil then
      raise EArgumentNullException.Create('value');
   var count: Integer := Length(value.Colors);

   if (value.Positions = nil) or (Length(value.Colors) <> Length(value.Positions)) then
      raise EArgumentException.Create('SR.Format(SR.InvalidArgumentValue, ''value.Positions'', value.Positions), nameof(value)');

   var positions: TArray<Single> := value.Positions;
   var argbColors: TArray<UInt32>;
   SetLength(argbColors, count);

    for var i: Integer := 0 to count - 1 do
        argbColors[i] := Value.Colors[i].ToArgb();

   var p: PSingle := @positions[0];
   var a: PUInt32 := @argbColors[0];
   begin
      // Set blend factors
      // Set blend factors
      TGdiplusAPI.GdipSetPathGradientPresetBlend(NativePathGradient, a, p, count).ThrowIfFailed();
   end;
end;

function TGdipPathGradientBrush.GetTransform(): TGdipMatrix;
begin
   var matrix: TGdipMatrix := TGdipMatrix.Create();
   TGdiplusAPI.GdipGetPathGradientTransform(NativePathGradient, matrix.NativeMatrix).ThrowIfFailed();

   Exit(matrix);
end;

procedure TGdipPathGradientBrush.SetTransform(const Value: TGdipMatrix);
begin
   if value = nil then
      raise EArgumentNullException.Create('value');

   TGdiplusAPI.GdipSetPathGradientTransform(NativePathGradient, value.NativeMatrix).ThrowIfFailed();
end;

function TGdipPathGradientBrush.GetFocusScales(): TPointF;
begin
   var scaleX: Single;
   var scaleY: Single;
   TGdiplusAPI.GdipGetPathGradientFocusScales(NativePathGradient, scaleX, scaleY).ThrowIfFailed();

   Exit(TPointF.Create(scaleX, scaleY));
end;

procedure TGdipPathGradientBrush.SetFocusScales(const Value: TPointF);
begin
   TGdiplusAPI.GdipSetPathGradientFocusScales(NativePathGradient, value.X, value.Y).ThrowIfFailed();
end;

function TGdipPathGradientBrush.GetWrapMode(): TGdipWrapMode;
begin
   var mode: TGdiplusAPI.TGdipWrapModeEnum;
   TGdiplusAPI.GdipGetPathGradientWrapMode(NativePathGradient, mode).ThrowIfFailed();

   Exit(TGdipWrapMode(mode));
end;

function TGdipPathGradientBrush.GetGammaCorrection(): Boolean;
var
  B: LongBool;
begin
   TGdiplusAPI.GdipGetPathGradientGammaCorrection(NativePathGradient, B).ThrowIfFailed();
   Result := B = True;
end;

procedure TGdipPathGradientBrush.SetGammaCorrection(const Value: Boolean);
begin
   TGdiplusAPI.GdipSetPathGradientGammaCorrection(NativePathGradient, Value).ThrowIfFailed();
end;

procedure TGdipPathGradientBrush.SetWrapMode(const Value: TGdipWrapMode);
begin
   if (Value < TGdipWrapMode.Tile) or (Value > TGdipWrapMode.Clamp) then
      raise EInvalidEnumArgumentException.Create('value', Integer(value), TypeInfo(TGdipWrapMode));

   TGdiplusAPI.GdipSetPathGradientWrapMode(NativePathGradient, TGdiPlusAPI.TGdipWrapModeEnum(value)).ThrowIfFailed();
end;

constructor TGdipPathGradientBrush.Create(const points: TArray<TPointF>);
begin
   Create(points, TGdipWrapMode.Clamp);
end;

constructor TGdipPathGradientBrush.Create(const points: TArray<TPointF>; const wrapMode: TGdipWrapMode);
begin
   if points = nil then
      raise EArgumentNullException.Create('points');

   if (wrapMode < TGdipWrapMode.Tile) or (wrapMode > TGdipWrapMode.Clamp) then
      raise EInvalidEnumArgumentException.Create('wrapMode', Integer(wrapMode), TypeInfo(TGdipWrapMode));

   if (Length(points) < 2) then
      raise EArgumentException.Create('points');

   var p: PPointF := @points[0];
   begin
      var nativeBrush: TGdiplusAPI.TGdipPathGradientPtr;
      TGdiplusAPI.GdipCreatePathGradient(p, Length(points), TGdiPlusAPI.TGdipWrapModeEnum(wrapMode), nativeBrush).ThrowIfFailed();
      SetNativeBrushInternal(TGdiplusAPI.TGdipBrushPtr(nativeBrush));
   end;
end;

constructor TGdipPathGradientBrush.Create(const points: TArray<TPoint>);
begin
   Create(points, TGdipWrapMode.Clamp);
end;

constructor TGdipPathGradientBrush.Create(const points: TArray<TPoint>; const wrapMode: TGdipWrapMode);
begin
   if points = nil then
      raise EArgumentNullException.Create('points');

   if (wrapMode < TGdipWrapMode.Tile) or (wrapMode > TGdipWrapMode.Clamp) then
      raise EInvalidEnumArgumentException.Create('wrapMode', Integer(wrapMode), TypeInfo(TGdipWrapMode));

   if (Length(points) < 2) then
      raise EArgumentException.Create('points');

   var p: PPoint := @points[0];
   begin
      var nativeBrush: TGdiplusAPI.TGdipPathGradientPtr;
      TGdiplusAPI.GdipCreatePathGradientI(p, Length(points), TGdiplusAPI.TGdipWrapModeEnum(wrapMode), nativeBrush).ThrowIfFailed();
      SetNativeBrushInternal(TGdiplusAPI.TGdipBrushPtr(nativeBrush));
   end;
end;

constructor TGdipPathGradientBrush.Create(const path: TGdipGraphicsPath);
begin
   if path = nil then
      raise EArgumentNullException.Create('path');

   var nativeBrush: TGdiplusAPI.TGdipPathGradientPtr;
   TGdiplusAPI.GdipCreatePathGradientFromPath(path._nativePath, nativeBrush).ThrowIfFailed();
   SetNativeBrushInternal(TGdiplusAPI.TGdipBrushPtr(nativeBrush));
end;

constructor TGdipPathGradientBrush.Create(const nativeBrush: TGdiplusAPI.TGdipPathGradientPtr);
begin
   Assert(nativeBrush <> nil, 'Initializing native brush with null.');
   SetNativeBrushInternal(TGdiplusAPI.TGdipBrushPtr(nativeBrush));
end;

function TGdipPathGradientBrush.Clone(): TObject;
begin
   var clonedBrush: TGdiplusAPI.TGdipBrushPtr;
   TGdiplusAPI.GdipCloneBrush(NativeBrush, clonedBrush).ThrowIfFailed();

   Exit(TGdipPathGradientBrush.Create(TGdiplusAPI.TGdipPathGradientPtr(clonedBrush)));
end;

procedure TGdipPathGradientBrush.SetSigmaBellShape(const focus: Single);
begin
   SetSigmaBellShape(focus, Single(1.0))
end;

procedure TGdipPathGradientBrush.SetSigmaBellShape(const focus: Single; const scale: Single);
begin
   TGdiplusAPI.GdipSetPathGradientSigmaBlend(NativePathGradient, focus, scale).ThrowIfFailed();
end;

procedure TGdipPathGradientBrush.SetBlendTriangularShape(const focus: Single);
begin
   SetBlendTriangularShape(focus, Single(1.0))
end;

procedure TGdipPathGradientBrush.SetBlendTriangularShape(const focus: Single; const scale: Single);
begin
   TGdiplusAPI.GdipSetPathGradientLinearBlend(NativePathGradient, focus, scale).ThrowIfFailed();
end;

procedure TGdipPathGradientBrush.ResetTransform();
begin
   TGdiplusAPI.GdipResetPathGradientTransform(NativePathGradient).ThrowIfFailed();
end;

procedure TGdipPathGradientBrush.MultiplyTransform(const matrix: TGdipMatrix);
begin
   MultiplyTransform(matrix, TGdipMatrixOrder.Prepend)
end;

procedure TGdipPathGradientBrush.MultiplyTransform(const matrix: TGdipMatrix; const order: TGdipMatrixOrder);
begin
   if matrix = nil then
      raise EArgumentNullException.Create('matrix');

   TGdiplusAPI.GdipMultiplyPathGradientTransform(NativePathGradient, matrix.NativeMatrix, TGdiplusAPI.TGdipMatrixOrderEnum(order)).ThrowIfFailed();
end;

procedure TGdipPathGradientBrush.TranslateTransform(const dx: Single; const dy: Single);
begin
   TranslateTransform(dx, dy, TGdipMatrixOrder.Prepend)
end;

procedure TGdipPathGradientBrush.TranslateTransform(const dx: Single; const dy: Single; const order: TGdipMatrixOrder);
begin
   TGdiplusAPI.GdipTranslatePathGradientTransform(NativePathGradient, dx, dy, TGdiPlusAPI.TGdipMatrixOrderEnum(order)).ThrowIfFailed();
end;

procedure TGdipPathGradientBrush.ScaleTransform(const sx: Single; const sy: Single);
begin
   ScaleTransform(sx, sy, TGdipMatrixOrder.Prepend)
end;

procedure TGdipPathGradientBrush.ScaleTransform(const sx: Single; const sy: Single; const order: TGdipMatrixOrder);
begin
   TGdiplusAPI.GdipScalePathGradientTransform(NativePathGradient, sx, sy, TGdiplusAPI.TGdipMatrixOrderEnum(order)).ThrowIfFailed();
end;

procedure TGdipPathGradientBrush.RotateTransform(const angle: Single);
begin
   RotateTransform(angle, TGdipMatrixOrder.Prepend)
end;

procedure TGdipPathGradientBrush.RotateTransform(const angle: Single; const order: TGdipMatrixOrder);
begin
   TGdiplusAPI.GdipRotatePathGradientTransform(NativePathGradient, angle, TGdiplusAPI.TGdipMatrixOrderEnum(order)).ThrowIfFailed();
end;

{$ENDREGION 'TGdipPathGradientBrush'}

{$REGION 'TGdipColorBlend'}

{ TGdipColorBlend }

constructor TGdipColorBlend.Create();
begin
   SetLength(m_colors, 1);
   SetLength(m_positions, 1);
end;

constructor TGdipColorBlend.Create(const count: Integer);
begin
   SetLength(m_colors, count);
   SetLength(m_positions, count);
end;

constructor TGdipColorBlend.Create(const colors: TArray<TGdipColor>; const positions: TArray<Single>);
begin
   m_colors := colors;
   m_positions := positions;
end;


{$ENDREGION 'TGdipColorBlend'}

{$REGION 'TGdipBlend'}

{ TGdipBlend }

constructor TGdipBlend.Create();
begin
   System.SetLength(m_factors, 1);
   System.SetLength(m_positions, 1);
end;

constructor TGdipBlend.Create(const count: Integer);
begin
   System.SetLength(m_factors, count);
   System.SetLength(m_positions, count);
end;

constructor TGdipBlend.Create(const factors, positions: array of Single);
begin
   System.SetLength(m_factors, System.Length(factors));
   for var i := Low(factors) to High(factors) do
      m_factors[i] := factors[i];

   System.SetLength(m_positions, System.Length(positions));
   for var i := Low(positions) to High(positions) do
      m_positions[i] := positions[i];
end;

{$ENDREGION 'TGdipBlend'}

{$REGION 'TGdipGraphicsContext'}

{ TGdipGraphicsContext }

constructor TGdipGraphicsContext.Create(const g: TGdipGraphics);
begin
   TransformOffset := g.TransformElements.Translation;
   Clip := g.GetRegionIfNotInfinite();
end;

destructor TGdipGraphicsContext.Destroy();
begin
   Dispose();
   inherited Destroy();
end;

procedure TGdipGraphicsContext.Dispose();
begin
   // Dispose all contexts up the stack since they are relative to this one and its state will be invalid.
   if Assigned(m_Next) then
   begin
    //  m_Next.Dispose();
   end;

   m_Next := nil;

   if Assigned(m_clipRegion) then
   begin
      m_clipRegion.Free();
   end;

   m_clipRegion := nil;

end;

{$ENDREGION 'TGdipGraphicsContext'}

{$REGION 'TGdipGraphics'}

{ TGdipGraphics }

class constructor TGdipGraphics.CreateClass();
begin
{$IFDEF FINALIZATION_WATCH}
   GraphicsFinalization := TTraceSwitch.Create('GraphicsFinalization', 'Tracks the creation and destruction of finalization');
{$ENDIF FINALIZATION_WATCH}
   s_syncObject := TObject.Create();
end;

class destructor TGdipGraphics.DestroyClass();
begin
{$IFDEF FINALIZATION_WATCH}
   FreeAndNil(GraphicsFinalization);
{$ENDIF FINALIZATION_WATCH}
   FreeAndNil(s_syncObject);
end;

procedure TGdipGraphics.AfterConstruction;
begin
   inherited;
{$IFDEF FINALIZATION_WATCH}
   m_allocationSite := TGdipGraphics.GetAllocationStack();
{$ENDIF FINALIZATION_WATCH}
end;

function TGdipGraphics.GetPointer(): TGdiplusAPI.TGdipGraphicsPtr;
begin
   Result := NativeGraphics;
end;

function TGdipGraphics.GetClipRegion(): TGdipRegion;
begin
   var regionPtr: TGdiplusAPI.TGdipRegionPtr := nil;
   CheckStatus(TGdiplusAPI.GdipGetClip(NativeGraphics, regionPtr));

   Result := TGdipRegion.Create(regionPtr);
end;

procedure TGdipGraphics.SetClipRegion(const Value: TGdipRegion);
begin
   SetClip(value, TGdipCombineMode.Replace)
end;

function TGdipGraphics.GetClipBounds(): TRectangleF;
begin
   var rect: TRectangleF;
   CheckStatus(TGdiplusAPI.GdipGetClipBounds(NativeGraphics, rect));

   Exit(rect);
end;

function TGdipGraphics.GetCompositingMode(): TGdipCompositingMode;
begin
   var mode: TGdiplusAPI.TGdipCompositingModeEnum;
   CheckStatus(TGdiplusAPI.GdipGetCompositingMode(NativeGraphics, mode));

   Result := TGdipCompositingMode(mode);
end;

procedure TGdipGraphics.SetCompositingMode(const Value: TGdipCompositingMode);
begin
   if (value < TGdipCompositingMode.SourceOver) or (Value > TGdipCompositingMode.SourceCopy) then
      raise EInvalidEnumArgumentException.Create('value', Integer(value), TypeInfo(TGdipCompositingMode));

   CheckStatus(TGdiPlusAPI.GdipSetCompositingMode(NativeGraphics, TGdiPlusAPI.TGdipCompositingModeEnum(value)));
end;

function TGdipGraphics.GetCompositingQuality(): TGdipCompositingQuality;
begin
   var quality: TGdiPlusAPI.TGdipCompositingQualityEnum;
   CheckStatus(TGdiPlusAPI.GdipGetCompositingQuality(NativeGraphics, quality));

   Exit(TGdipCompositingQuality(Ord(quality)+1));
end;

procedure TGdipGraphics.SetCompositingQuality(const Value: TGdipCompositingQuality);
begin
   if (Value < TGdipCompositingQuality.Invalid) or (Value > TGdipCompositingQuality.AssumeLinear) then
      raise EInvalidEnumArgumentException.Create('value', Integer(value), TypeInfo(TGdipCompositingQuality));

   CheckStatus(TGdiPlusAPI.GdipSetCompositingQuality(NativeGraphics, TGdiPlusAPI.TGdipCompositingQualityEnum(Ord(value)-1)));
end;

function TGdipGraphics.GetDpiX(): Single;
begin
   var dpi: Single;
   CheckStatus(TGdiPlusAPI.GdipGetDpiX(NativeGraphics, dpi));

   Exit(dpi);
end;

function TGdipGraphics.GetDpiY(): Single;
begin
   var dpi: Single;
   CheckStatus(TGdiPlusAPI.GdipGetDpiY(NativeGraphics, dpi));

   Exit(dpi);
end;

function TGdipGraphics.GetInterpolationMode(): TGdipInterpolationMode;
begin
   var mode: TGdiPlusAPI.TGdipInterpolationModeEnum;
   CheckStatus(TGdiPlusAPI.GdipGetInterpolationMode(NativeGraphics, mode));

   Exit(TGdipInterpolationMode(Ord(mode) + 1));
end;

procedure TGdipGraphics.SetInterpolationMode(const Value: TGdipInterpolationMode);
begin
   if (Value < TGdipInterpolationMode.Invalid) or (Value > TGdipInterpolationMode.HighQualityBicubic) then
      raise EInvalidEnumArgumentException.Create('value', Integer(value), TypeInfo(TGdipInterpolationMode));
   CheckStatus(TGdiPlusAPI.GdipSetInterpolationMode(NativeGraphics, TGdiPlusAPI.TGdipInterpolationModeEnum(Ord(value)-1)));
end;

function TGdipGraphics.GetIsClipEmpty(): Boolean;
begin
   var isEmpty: LongBool;
   CheckStatus(TGdiPlusAPI.GdipIsClipEmpty(NativeGraphics, isEmpty));

   Exit(isEmpty);
end;

function TGdipGraphics.GetIsVisibleClipEmpty(): Boolean;
begin
   var isEmpty: LongBool;
   CheckStatus(TGdiPlusAPI.GdipIsVisibleClipEmpty(NativeGraphics, isEmpty));

   Exit(isEmpty);
end;

function TGdipGraphics.GetPageScale(): Single;
begin
   var scale: Single;
   CheckStatus(TGdiPlusAPI.GdipGetPageScale(NativeGraphics, scale));

   Exit(scale);
end;

procedure TGdipGraphics.SetPageScale(const Value: Single);
begin
   CheckStatus(TGdiPlusAPI.GdipSetPageScale(NativeGraphics, value))
end;

function TGdipGraphics.GetPageUnit(): TGdipGraphicsUnit;
begin
   var unit_: TGdiPlusAPI.TGdipUnitEnum;
   CheckStatus(TGdiPlusAPI.GdipGetPageUnit(NativeGraphics, unit_));

   Exit(TGdipGraphicsUnit(unit_));
end;

procedure TGdipGraphics.SetPageUnit(const Value: TGdipGraphicsUnit);
begin
   if (Value < TGdipGraphicsUnit.World) or (Value > TGdipGraphicsUnit.Millimeter) then
      raise EInvalidEnumArgumentException.Create('value', Integer(value), TypeInfo(TGdipGraphicsUnit));

   CheckStatus(TGdiPlusAPI.GdipSetPageUnit(NativeGraphics, TGdiPlusAPI.TGdipUnitEnum(value)));
end;

function TGdipGraphics.GetPixelOffsetMode(): TGdipPixelOffsetMode;
begin
   var mode: TGdiPlusAPI.TGdipPixelOffsetModeEnum;
   CheckStatus(TGdiPlusAPI.GdipGetPixelOffsetMode(NativeGraphics, mode));

   Exit(TGdipPixelOffsetMode(Ord(mode) + 1));
end;

procedure TGdipGraphics.SetPixelOffsetMode(const Value: TGdipPixelOffsetMode);
begin
   if (Value < TGdipPixelOffsetMode.Invalid) or (Value > TGdipPixelOffsetMode.Half) then
      raise EInvalidEnumArgumentException.Create('value', Integer(value), TypeInfo(TGdipPixelOffsetMode));

   CheckStatus(TGdiPlusAPI.GdipSetPixelOffsetMode(NativeGraphics, TGdiPlusAPI.TGdipPixelOffsetModeEnum(Ord(value) - 1)));
end;

function TGdipGraphics.GetRenderingOrigin(): TPoint;
begin
   var x: Integer;
   var y: Integer;
   CheckStatus(TGdiPlusAPI.GdipGetRenderingOrigin(NativeGraphics, x, y));

   Exit(TPoint.Create(x, y));
end;

procedure TGdipGraphics.SetRenderingOrigin(const Value: TPoint);
begin
   CheckStatus(TGdiPlusAPI.GdipSetRenderingOrigin(NativeGraphics, value.X, value.Y))end;

function TGdipGraphics.GetSmoothingMode(): TGdipSmoothingMode;
begin
   var mode: TGdiPlusAPI.TGdipSmoothingModeEnum;
   CheckStatus(TGdiPlusAPI.GdipGetSmoothingMode(NativeGraphics, mode));

   Exit(TGdipSmoothingMode(Ord(mode) + 1));
end;

procedure TGdipGraphics.SetSmoothingMode(const Value: TGdipSmoothingMode);
begin
   if (Value < TGdipSmoothingMode.Invalid) or (Value > TGdipSmoothingMode.AntiAlias8x8) then
      raise EInvalidEnumArgumentException.Create('value', Integer(value), TypeInfo(TGdipSmoothingMode));

   CheckStatus(TGdiPlusAPI.GdipSetSmoothingMode(NativeGraphics, value.ToNativeEnum()));
end;

function TGdipGraphics.GetTextContrast(): Integer;
begin
   var textContrast: UInt32;
   CheckStatus(TGdiPlusAPI.GdipGetTextContrast(NativeGraphics, textContrast));

   Exit(Integer(textContrast));
end;

procedure TGdipGraphics.SetTextContrast(const Value: Integer);
begin
   CheckStatus(TGdiPlusAPI.GdipSetTextContrast(NativeGraphics, UInt32(value)))end;

function TGdipGraphics.GetTextRenderingHint(): TGdipTextRenderingHint;
begin
   var hint: TGdiPlusAPI.TGdipTextRenderingHintEnum;
   CheckStatus(TGdiPlusAPI.GdipGetTextRenderingHint(NativeGraphics, hint));

   Exit(TGdipTextRenderingHint(hint));
end;

procedure TGdipGraphics.SetTextRenderingHint(const Value: TGdipTextRenderingHint);
begin
   if (Value < TGdipTextRenderingHint.SystemDefault) or (Value > TGdipTextRenderingHint.ClearTypeGridFit) then
      raise EInvalidEnumArgumentException.Create('value', Integer(value), TypeInfo(TGdipTextRenderingHint));

   CheckStatus(TGdiPlusAPI.GdipSetTextRenderingHint(NativeGraphics, TGdiPlusAPI.TGdipTextRenderingHintEnum(value)));
end;

function TGdipGraphics.GetTransform(): TGdipMatrix;
begin
   var matrix: TGdipMatrix := TGdipMatrix.Create();
   CheckStatus(TGdiPlusAPI.GdipGetWorldTransform(NativeGraphics, matrix.NativeMatrix));

   Exit(matrix);
end;

procedure TGdipGraphics.SetTransform(const Value: TGdipMatrix);
begin
   CheckStatus(TGdiPlusAPI.GdipSetWorldTransform(NativeGraphics, value.NativeMatrix));
end;

function TGdipGraphics.GetTransformElements(): TMatrix3x2;
begin
   var nativeMatrix: TGdiPlusAPI.TGdipMatrixPtr;
   CheckStatus(TGdiPlusAPI.GdipCreateMatrix(nativeMatrix));

   try
      CheckStatus(TGdiPlusAPI.GdipGetWorldTransform(NativeGraphics, nativeMatrix));

      var matrix: TMatrix3x2 := Default(TMatrix3x2);
      CheckStatus(TGdiPlusAPI.GdipGetMatrixElements(nativeMatrix, PSingle(@matrix)));

      Exit(matrix);
   finally
      if (nativeMatrix <> nil) then
      begin
         TGdiPlusAPI.GdipDeleteMatrix(nativeMatrix);
      end;
   end;

end;

procedure TGdipGraphics.SetTransformElements(const Value: TMatrix3x2);
begin
   var nativeMatrix: TGdiPlusAPI.TGdipMatrixPtr := TGdipMatrix.CreateNativeHandle(value);

   try
      CheckStatus(TGdiPlusAPI.GdipSetWorldTransform(NativeGraphics, nativeMatrix));
   finally
      if (nativeMatrix <> nil) then
      begin
         TGdiPlusAPI.GdipDeleteMatrix(nativeMatrix);
      end;
   end;
end;

//function TGdipGraphics.GetPrintingHelper(): TObject;
//begin
//   Result := _printingHelper;
//end;
//
//procedure TGdipGraphics.SetPrintingHelper(const Value: TObject);
//begin
//   Assert(_printingHelper = nil, 'WARNING: Overwriting the printing helper reference!');
//   _printingHelper := value;
//end;

function TGdipGraphics.GetVisibleClipBounds(): TRectangleF;
begin
//   if (PrintingHelper is TGdipPrintPreviewGraphics { var ppGraphics: TGdipPrintPreviewGraphics := PrintingHelper as TGdipPrintPreviewGraphics; } ) then
//      Exit(ppGraphics.VisibleClipBounds);

   var rect: TRectangleF;
   CheckStatus(TGdiPlusAPI.GdipGetVisibleClipBounds(NativeGraphics, rect));

   Exit(rect);
end;

constructor TGdipGraphics.Create(const gdipNativeGraphics: TGdiplusAPI.TGdipGraphicsPtr);
begin
   if (gdipNativeGraphics = nil) then
      raise EArgumentNullException.Create('gdipNativeGraphics');

   NativeGraphics := gdipNativeGraphics;
end;

destructor TGdipGraphics.Destroy();
begin
   Dispose(True);
   inherited Destroy();
end;

{$IFDEF FINALIZATION_WATCH}
class function TGdipGraphics.GetAllocationStack(): string;
begin
   if (GraphicsFinalization.TraceVerbose) then
   begin
      Exit(Environment.StackTrace);
   end
   else
   begin
      Exit('Enabled 'GraphicsFinalization' switch to see stack of allocation');
   end;
end;
{$ENDIF FINALIZATION_WATCH}

class function TGdipGraphics.FromHdc(const hdc: HDC): TGdipGraphics;
begin
   if (hdc = 0) then
      raise EArgumentNullException.Create('hdc');

   Exit(FromHdcInternal(hdc));
end;

class function TGdipGraphics.FromHdcInternal(const hdc: HDC): TGdipGraphics;
begin
   var nativeGraphics: TGdiplusAPI.TGdipGraphicsPtr;
   TGdip.CheckStatus(TGdiplusAPI.GdipCreateFromHDC(hdc, nativeGraphics));

   Exit(TGdipGraphics.Create(nativeGraphics));
end;

class function TGdipGraphics.FromHdc(const hdc: hdc; const hdevice: THandle): TGdipGraphics;
begin
   var nativeGraphics: TGdiplusAPI.TGdipGraphicsPtr;
   TGdip.CheckStatus(TGdiplusAPI.GdipCreateFromHDC2(hdc, hdevice, nativeGraphics));

   Exit(TGdipGraphics.Create(nativeGraphics));
end;

class function TGdipGraphics.FromHwnd(const hwnd: THandle): TGdipGraphics;
begin
   Result := FromHwndInternal(hwnd)
end;

class function TGdipGraphics.FromHwndInternal(const hwnd: THandle): TGdipGraphics;
begin
   var nativeGraphics: TGdiplusAPI.TGdipGraphicsPtr;
   TGdip.CheckStatus(TGdiplusAPI.GdipCreateFromHWND(hwnd, nativeGraphics));

   Exit(TGdipGraphics.Create(nativeGraphics));
end;

class function TGdipGraphics.FromImage(const image: TGdipImage): TGdipGraphics;
begin
   if image = nil then
      raise EArgumentNullException.Create('image');

   if (Ord(image.PixelFormat) and Ord(TGdipPixelFormat.Indexed) <> 0) then
      raise EArgumentException.Create('SR.GdiplusCannotCreateGraphicsFromIndexedPixelFormat, nameof(image)');

   var nativeGraphics: TGdiplusAPI.TGdipGraphicsPtr;
   TGdip.CheckStatus(TGdiplusAPI.GdipGetImageGraphicsContext(image.Pointer, nativeGraphics));

   Exit(TGdipGraphics.Create(nativeGraphics));
end;

procedure TGdipGraphics.ReleaseHdcInternal(const hdc: HDC);
begin
   CheckStatus(IfThen(not TGdip.Initialized, TGdiplusAPI.TGdipStatusEnum.Ok, TGdiplusAPI.GdipReleaseDC(NativeGraphics, hdc)));
   _nativeHdc := 0;
end;

procedure TGdipGraphics.Dispose();
begin
   Dispose(True);
end;

procedure TGdipGraphics.Dispose(const disposing: Boolean);
begin
{$IFDEF FINALIZATION_WATCH}
   Debug.WriteLineIf(not disposing) and (NativeGraphics <> nil, '            System.Drawing.TGdipGraphics: ***************************************************
            System.Drawing.TGdipGraphics: Object Disposed through finalization:
            ' + allocationSite.ToString() + '');
{$ENDIF}

   while (_previousContext <> nil) do
   begin
      begin
         // Dispose entire stack.
         var context: TGdipGraphicsContext := _previousContext.Previous;
         _previousContext.Dispose();
         _previousContext := context;
      end;

   end;

   if (NativeGraphics <> nil) then
   begin

      try
         try
            if (_nativeHdc <> 0) then // avoid a handle leak.
            begin
               ReleaseHdc();
            end;

//               if (PrintingHelper is THdcHandle { var printerDC: THdcHandle := PrintingHelper as THdcHandle; } ) then
//               begin
//                  printerDC.Dispose();
//                  _printingHelper := nil;
//               end;

{$IFDEF DEBUG}
            var status: TGdiplusAPI.TGdipStatusEnum := IfThen(not TGdip.Initialized, TGdiplusAPI.TGdipStatusEnum.Ok,
{$ENDIF}
            TGdiplusAPI.GdipDeleteGraphics(NativeGraphics)

{$IFDEF DEBUG}
            );
            Assert(status = TGdiplusAPI.TGdipStatusEnum.Ok, 'GDI+ returned an error status: ' + status.ToString() + '');
{$ELSE DEBUG}
         ;
{$ENDIF}
         except on ex: Exception do  // when (!ClientUtils.IsSecurityOrCriticalException(ex))
         end;
      finally
         NativeGraphics := nil;
      end;

   end;
end;

function TGdipGraphics.GetHdc(): HDC;
begin
   var hdc: HDC;
   CheckStatus(TGdiplusAPI.GdipGetDC(NativeGraphics, hdc));

   // Need to cache the hdc to be able to release with a call to IDeviceContext.ReleaseHdc().
   _nativeHdc := hdc;

   Exit(_nativeHdc);
end;

procedure TGdipGraphics.ReleaseHdc(const hdc: HDC);
begin
   ReleaseHdcInternal(hdc)
end;

procedure TGdipGraphics.ReleaseHdc();
begin
   ReleaseHdcInternal(_nativeHdc)
end;

procedure TGdipGraphics.Flush();
begin
   Flush(TGdipFlushIntention.Flush);
end;

procedure TGdipGraphics.Flush(const intention: TGdipFlushIntention);
begin
   CheckStatus(TGdiplusAPI.GdipFlush(NativeGraphics, TGdiplusAPI.TGdipFlushIntentionEnum(intention)))
end;

procedure TGdipGraphics.SetClip(const g: TGdipGraphics);
begin
   SetClip(g, TGdipCombineMode.Replace)
end;

procedure TGdipGraphics.SetClip(const g: TGdipGraphics; const combineMode: TGdipCombineMode);
begin
   if g = nil then
      raise EArgumentNullException.Create('g');

   CheckStatus(TGdiplusAPI.GdipSetClipGraphics(NativeGraphics, g.NativeGraphics, TGdiplusAPI.TGdipCombineModeEnum(combineMode)));
end;

procedure TGdipGraphics.SetClip(const rect: TRectangle);
begin
   SetClip(rect, TGdipCombineMode.Replace)
end;

procedure TGdipGraphics.SetClip(const rect: TRectangle; const combineMode: TGdipCombineMode);
begin
   SetClip(TRectangleF(rect), combineMode)
end;

procedure TGdipGraphics.SetClip(const rect: TRectangleF);
begin
   SetClip(rect, TGdipCombineMode.Replace)
end;

procedure TGdipGraphics.SetClip(const rect: TRectangleF; const combineMode: TGdipCombineMode);
begin
   CheckStatus(TGdiplusAPI.GdipSetClipRect(NativeGraphics, rect.X, rect.Y, rect.Width, rect.Height, TGdiplusAPI.TGdipCombineModeEnum(combineMode)))
end;

procedure TGdipGraphics.SetClip(const path: TGdipGraphicsPath);
begin
   SetClip(path, TGdipCombineMode.Replace)
end;

procedure TGdipGraphics.SetClip(const path: TGdipGraphicsPath; const combineMode: TGdipCombineMode);
begin
   if path = nil then
      raise EArgumentNullException.Create('path');

   CheckStatus(TGdiplusAPI.GdipSetClipPath(NativeGraphics, path._nativePath, TGdiplusAPI.TGdipCombineModeEnum(combineMode)));
end;

procedure TGdipGraphics.SetClip(const region: TGdipRegion; const combineMode: TGdipCombineMode);
begin
   if region = nil then
      raise EArgumentNullException.Create('region');

   CheckStatus(TGdiplusAPI.GdipSetClipRegion(NativeGraphics, region.NativeRegion, TGdiplusAPI.TGdipCombineModeEnum(combineMode)));
end;

procedure TGdipGraphics.IntersectClip(const rect: TRectangle);
begin
   IntersectClip(TRectangleF(rect))
end;

procedure TGdipGraphics.IntersectClip(const rect: TRectangleF);
begin
   CheckStatus(TGdiplusAPI.GdipSetClipRect(NativeGraphics, rect.X, rect.Y, rect.Width, rect.Height, TGdiplusAPI.TGdipCombineModeEnum.Intersect))
end;

procedure TGdipGraphics.IntersectClip(const region: TGdipRegion);
begin
   if region = nil then
      raise EArgumentNullException.Create('region');

   CheckStatus(TGdiplusAPI.GdipSetClipRegion(NativeGraphics, region.NativeRegion, TGdiplusAPI.TGdipCombineModeEnum.Intersect));
end;

procedure TGdipGraphics.ExcludeClip(const rect: TRectangle);
begin
   CheckStatus(TGdiplusAPI.GdipSetClipRect(NativeGraphics, rect.X, rect.Y, rect.Width, rect.Height, TGdiplusAPI.TGdipCombineModeEnum.Exclude))
end;

procedure TGdipGraphics.ExcludeClip(const region: TGdipRegion);
begin
   if region = nil then
      raise EArgumentNullException.Create('region');

   CheckStatus(TGdiplusAPI.GdipSetClipRegion(NativeGraphics, region.NativeRegion, TGdiplusAPI.TGdipCombineModeEnum.Exclude));
end;

procedure TGdipGraphics.ResetClip();
begin
   CheckStatus(TGdiplusAPI.GdipResetClip(NativeGraphics))
end;

procedure TGdipGraphics.TranslateClip(const dx: Single; const dy: Single);
begin
   CheckStatus(TGdiplusAPI.GdipTranslateClip(NativeGraphics, dx, dy))
end;

procedure TGdipGraphics.TranslateClip(const dx: Integer; const dy: Integer);
begin
   CheckStatus(TGdiplusAPI.GdipTranslateClip(NativeGraphics, dx, dy))
end;

function TGdipGraphics.IsVisible(const x: Integer; const y: Integer): Boolean;
begin
   Result := IsVisible(TPoint.Create(x, y))
end;

function TGdipGraphics.IsVisible(const point: TPoint): Boolean;
begin
   Result := IsVisible(point.X, point.Y)
end;

function TGdipGraphics.IsVisible(const x: Single; const y: Single): Boolean;
begin
   var isVisible: LongBool;
   CheckStatus(TGdiplusAPI.GdipIsVisiblePoint(NativeGraphics, x, y, isVisible));

   Exit(isVisible);
end;

function TGdipGraphics.IsVisible(const point: TPointF): Boolean;
begin
   Result := IsVisible(point.X, point.Y)
end;

function TGdipGraphics.IsVisible(const x: Integer; const y: Integer; const width: Integer; const height: Integer): Boolean;
begin
   Result := IsVisible(Single(x), y, width, height)
end;

function TGdipGraphics.IsVisible(const rect: TRectangle): Boolean;
begin
   Result := IsVisible(Single(rect.X), rect.Y, rect.Width, rect.Height)
end;

function TGdipGraphics.IsVisible(const x: Single; const y: Single; const width: Single; const height: Single): Boolean;
begin
   var isVisible: LongBool;
   CheckStatus(TGdiplusAPI.GdipIsVisibleRect(NativeGraphics, x, y, width, height, isVisible));

   Exit(isVisible);
end;

function TGdipGraphics.IsVisible(const rect: TRectangleF): Boolean;
begin
   Result := IsVisible(rect.X, rect.Y, rect.Width, rect.Height)
end;

procedure TGdipGraphics.ResetTransform();
begin
   CheckStatus(TGdiplusAPI.GdipResetWorldTransform(NativeGraphics))
end;

procedure TGdipGraphics.MultiplyTransform(const matrix: TGdipMatrix);
begin
   MultiplyTransform(matrix, TGdipMatrixOrder.Prepend)
end;

procedure TGdipGraphics.MultiplyTransform(const matrix: TGdipMatrix; const order: TGdipMatrixOrder);
begin
   if matrix = nil then
      raise EArgumentNullException.Create('matrix');

   CheckStatus(TGdiplusAPI.GdipMultiplyWorldTransform(NativeGraphics, matrix.NativeMatrix, TGdiplusAPI.TGdipMatrixOrderEnum(order)));
end;

procedure TGdipGraphics.TranslateTransform(const dx: Single; const dy: Single);
begin
   TranslateTransform(dx, dy, TGdipMatrixOrder.Prepend)
end;

procedure TGdipGraphics.TranslateTransform(const dx: Single; const dy: Single; const order: TGdipMatrixOrder);
begin
   CheckStatus(TGdiplusAPI.GdipTranslateWorldTransform(NativeGraphics, dx, dy, TGdiplusAPI.TGdipMatrixOrderEnum(order)))
end;

procedure TGdipGraphics.ScaleTransform(const sx: Single; const sy: Single);
begin
   ScaleTransform(sx, sy, TGdipMatrixOrder.Prepend)
end;

procedure TGdipGraphics.ScaleTransform(const sx: Single; const sy: Single; const order: TGdipMatrixOrder);
begin
   CheckStatus(TGdiplusAPI.GdipScaleWorldTransform(NativeGraphics, sx, sy, TGdiplusAPI.TGdipMatrixOrderEnum(order)))
end;

procedure TGdipGraphics.RotateTransform(const angle: Single);
begin
   RotateTransform(angle, TGdipMatrixOrder.Prepend)
end;

procedure TGdipGraphics.RotateTransform(const angle: Single; const order: TGdipMatrixOrder);
begin
   CheckStatus(TGdiplusAPI.GdipRotateWorldTransform(NativeGraphics, angle, TGdiplusAPI.TGdipMatrixOrderEnum(order)))
end;

procedure TGdipGraphics.DrawArc(const pen: TGdipPen; const x: Single; const y: Single; const width: Single; const height: Single; const startAngle: Single; const sweepAngle: Single);
begin
   if pen = nil then
      raise EArgumentNullException.Create('pen');

   CheckErrorStatus(TGdiplusAPI.GdipDrawArc(NativeGraphics, pen.NativePen, x, y, width, height, startAngle, sweepAngle));
end;

procedure TGdipGraphics.DrawArc(const pen: TGdipPen; const rect: TRectangleF; const startAngle: Single; const sweepAngle: Single);
begin
   DrawArc(pen, rect.X, rect.Y, rect.Width, rect.Height, startAngle, sweepAngle)
end;

procedure TGdipGraphics.DrawArc(const pen: TGdipPen; const x: Integer; const y: Integer; const width: Integer; const height: Integer; const startAngle: Integer; const sweepAngle: Integer);

begin
   DrawArc(pen, Single(x), y, width, height, startAngle, sweepAngle)
end;

procedure TGdipGraphics.DrawArc(const pen: TGdipPen; const rect: TRectangle; const startAngle: Single; const sweepAngle: Single);
begin
   DrawArc(pen, rect.X, rect.Y, rect.Width, rect.Height, startAngle, sweepAngle)
end;

procedure TGdipGraphics.DrawBezier(const pen: TGdipPen; const x1: Single; const y1: Single; const x2: Single; const y2: Single; const x3: Single; const y3: Single; const x4: Single; const y4: Single);
begin
   if pen = nil then
      raise EArgumentNullException.Create('pen');

   CheckErrorStatus(TGdiplusAPI.GdipDrawBezier(NativeGraphics, pen.NativePen, x1, y1, x2, y2, x3, y3, x4, y4));
end;

procedure TGdipGraphics.DrawBezier(const pen: TGdipPen; const pt1: TPointF; const pt2: TPointF; const pt3: TPointF; const pt4: TPointF);
begin
   DrawBezier(pen, pt1.X, pt1.Y, pt2.X, pt2.Y, pt3.X, pt3.Y, pt4.X, pt4.Y)
end;

procedure TGdipGraphics.DrawBezier(const pen: TGdipPen; const pt1: TPoint; const pt2: TPoint; const pt3: TPoint; const pt4: TPoint);
begin
   DrawBezier(pen, pt1.X, pt1.Y, pt2.X, pt2.Y, pt3.X, pt3.Y, pt4.X, pt4.Y)
end;

procedure TGdipGraphics.DrawRectangle(const pen: TGdipPen; const rect: TRectangleF);
begin
   DrawRectangle(pen, rect.X, rect.Y, rect.Width, rect.Height)
end;

procedure TGdipGraphics.DrawRectangle(const pen: TGdipPen; const rect: TRectangle);
begin
   DrawRectangle(pen, rect.X, rect.Y, rect.Width, rect.Height)
end;

procedure TGdipGraphics.DrawRoundedRectangle(const pen: TGdipPen; const rect: TRectangle; const radius: TSize);
begin
   DrawRoundedRectangle(pen, TRectangleF(rect), radius)
end;

procedure TGdipGraphics.DrawRoundedRectangle(const pen: TGdipPen; const rect: TRectangleF; const radius: TSizeF);
begin
   var path: TGdipGraphicsPath := TGdipGraphicsPath.Create();
   path.AddRoundedRectangle(rect, radius);
   DrawPath(pen, path);
end;

procedure TGdipGraphics.DrawRectangle(const pen: TGdipPen; const x: Single; const y: Single; const width: Single; const height: Single);
begin
   if pen = nil then
      raise EArgumentNullException.Create('pen');

   CheckErrorStatus(TGdiplusAPI.GdipDrawRectangle(NativeGraphics, pen.NativePen, x, y, width, height));
end;

procedure TGdipGraphics.DrawRectangle(const pen: TGdipPen; const x: Integer; const y: Integer; const width: Integer; const height: Integer);
begin
   DrawRectangle(pen, Single(x), y, width, height)
end;

procedure TGdipGraphics.DrawRectangles(const pen: TGdipPen; const rects: TArray<TRectangleF>);
begin
   if rects = nil then
      raise EArgumentNullException.Create('rects');

   DrawRectangles(pen, TReadOnlySpan<TRectangleF>(rects));
end;

procedure TGdipGraphics.DrawRectangles(const pen: TGdipPen; const rects: TReadOnlySpan<TRectangleF>);
begin
   if pen = nil then
      raise EArgumentNullException.Create('pen');

   CheckErrorStatus(TGdiplusAPI.GdipDrawRectangles(NativeGraphics, pen.NativePen, PRectangleF(rects.GetReference), rects.Length));
end;

procedure TGdipGraphics.DrawRectangles(const pen: TGdipPen; const rects: TArray<TRectangle>);
begin
   if rects = nil then
      raise EArgumentNullException.Create('rects');

   DrawRectangles(pen, TReadOnlySpan<TRectangle>(rects))
end;

procedure TGdipGraphics.DrawRectangles(const pen: TGdipPen; const rects: TReadOnlySpan<TRectangle>);
begin
   if pen = nil then
      raise EArgumentNullException.Create('pen');

   CheckErrorStatus(TGdiplusAPI.GdipDrawRectanglesI(NativeGraphics, pen.NativePen, PRectangle(rects.GetReference), rects.Length));
end;

procedure TGdipGraphics.DrawEllipse(const pen: TGdipPen; const rect: TRectangleF);
begin
   DrawEllipse(pen, rect.X, rect.Y, rect.Width, rect.Height)
end;

procedure TGdipGraphics.DrawEllipse(const pen: TGdipPen; const x: Single; const y: Single; const width: Single; const height: Single);
begin
   if pen = nil then
      raise EArgumentNullException.Create('pen');

   CheckErrorStatus(TGdiplusAPI.GdipDrawEllipse(NativeGraphics, pen.NativePen, x, y, width, height));
end;

procedure TGdipGraphics.DrawEllipse(const pen: TGdipPen; const rect: TRectangle);
begin
   DrawEllipse(pen, Single(rect.X), rect.Y, rect.Width, rect.Height)
end;

procedure TGdipGraphics.DrawEllipse(const pen: TGdipPen; const x: Integer; const y: Integer; const width: Integer; const height: Integer);
begin
   DrawEllipse(pen, Single(x), y, width, height)
end;

procedure TGdipGraphics.DrawPie(const pen: TGdipPen; const rect: TRectangleF; const startAngle: Single; const sweepAngle: Single);
begin
   DrawPie(pen, rect.X, rect.Y, rect.Width, rect.Height, startAngle, sweepAngle)
end;

procedure TGdipGraphics.DrawPie(const pen: TGdipPen; const x: Single; const y: Single; const width: Single; const height: Single; const startAngle: Single; const sweepAngle: Single);
begin
   if pen = nil then
      raise EArgumentNullException.Create('pen');

   CheckErrorStatus(TGdiplusAPI.GdipDrawPie(NativeGraphics, pen.NativePen, x, y, width, height, startAngle, sweepAngle));
end;

procedure TGdipGraphics.DrawPie(const pen: TGdipPen; const rect: TRectangle; const startAngle: Single; const sweepAngle: Single);
begin
   DrawPie(pen, rect.X, rect.Y, rect.Width, rect.Height, startAngle, sweepAngle)
end;

procedure TGdipGraphics.DrawPie(const pen: TGdipPen; const x: Integer; const y: Integer; const width: Integer; const height: Integer; const startAngle: Integer; const sweepAngle: Integer);
begin
   DrawPie(pen, Single(x), y, width, height, startAngle, sweepAngle)
end;

procedure TGdipGraphics.DrawPolygon(const pen: TGdipPen; const points: TArray<TPointF>);
begin
   if points = nil then
      raise EArgumentNullException.Create('points');

   DrawPolygon(pen, TReadOnlySpan<TPointF>(points));
end;

procedure TGdipGraphics.DrawPolygon(const pen: TGdipPen; const points: TReadOnlySpan<TPointF>);
begin
   if pen = nil then
      raise EArgumentNullException.Create('pen');

   CheckErrorStatus(TGdiplusAPI.GdipDrawPolygon(NativeGraphics, pen.NativePen, PPointF(points.GetReference), points.Length));
end;

procedure TGdipGraphics.DrawPolygon(const pen: TGdipPen; const points: TArray<TPoint>);
begin
   if points = nil then
      raise EArgumentNullException.Create('points');

   DrawPolygon(pen, TReadOnlySpan<TPoint>(points));
end;

procedure TGdipGraphics.DrawPolygon(const pen: TGdipPen; const points: TReadOnlySpan<TPoint>);
begin
   if pen = nil then
      raise EArgumentNullException.Create('pen');

   CheckErrorStatus(TGdiplusAPI.GdipDrawPolygonI(NativeGraphics, pen.NativePen, PPoint(points.GetPinnableReference), points.Length));
end;

procedure TGdipGraphics.DrawPath(const pen: TGdipPen; const path: TGdipGraphicsPath);
begin
   if pen = nil then
      raise EArgumentNullException.Create('pen');
   if path = nil then
      raise EArgumentNullException.Create('path');

   CheckErrorStatus(TGdiplusAPI.GdipDrawPath(NativeGraphics, pen.NativePen, path._nativePath));
end;

procedure TGdipGraphics.DrawCurve(const pen: TGdipPen; const points: TArray<TPointF>);
begin
   if points = nil then
      raise EArgumentNullException.Create('points');

   DrawCurve(pen, TReadOnlySpan<TPointF>(points))
end;

procedure TGdipGraphics.DrawCurve(const pen: TGdipPen; const points: TReadOnlySpan<TPointF>);
begin
   if pen = nil then
      raise EArgumentNullException.Create('pen');

   CheckErrorStatus(TGdiplusAPI.GdipDrawCurve(NativeGraphics, pen.NativePen, PPointF(points.GetPinnableReference), points.Length));
end;

procedure TGdipGraphics.DrawCurve(const pen: TGdipPen; const points: TArray<TPointF>; const tension: Single);
begin
   if points = nil then
      raise EArgumentNullException.Create('points');

   DrawCurve(pen, TReadOnlySpan<TPointF>(points), tension)
end;

procedure TGdipGraphics.DrawCurve(const pen: TGdipPen; const points: TReadOnlySpan<TPointF>; const tension: Single);
begin
   if pen = nil then
      raise EArgumentNullException.Create('pen');

   CheckErrorStatus(TGdiplusAPI.GdipDrawCurve2(NativeGraphics, pen.NativePen, PPointF(points.GetPinnableReference), points.Length, tension));
end;

procedure TGdipGraphics.DrawCurve(const pen: TGdipPen; const points: TArray<TPointF>; const offset: Integer; const numberOfSegments: Integer);
begin
   DrawCurve(pen, points, offset, numberOfSegments, Single(0.5))
end;

procedure TGdipGraphics.DrawCurve(const pen: TGdipPen; const points: TReadOnlySpan<TPointF>; const offset: Integer; const numberOfSegments: Integer);
begin
   DrawCurve(pen, points, offset, numberOfSegments, Single(0.5))
end;

procedure TGdipGraphics.DrawCurve(const pen: TGdipPen; const points: TArray<TPointF>; const offset: Integer; const numberOfSegments: Integer; const tension: Single);
begin
   if points = nil then
      raise EArgumentNullException.Create('points');

   DrawCurve(pen, TReadOnlySpan<TPointF>(points), offset, numberOfSegments, tension)
end;

procedure TGdipGraphics.DrawCurve(const pen: TGdipPen; const points: TReadOnlySpan<TPointF>; const offset: Integer; const numberOfSegments: Integer; const tension: Single);
begin
   if pen = nil then
      raise EArgumentNullException.Create('pen');

   CheckErrorStatus(TGdiplusAPI.GdipDrawCurve3(NativeGraphics, pen.NativePen, PPointF(points.GetPinnableReference), points.Length, offset, numberOfSegments, tension));
end;

procedure TGdipGraphics.DrawCurve(const pen: TGdipPen; const points: TArray<TPoint>);
begin
   if points = nil then
      raise EArgumentNullException.Create('points');

   DrawCurve(pen, TReadOnlySpan<TPoint>(points));
end;

procedure TGdipGraphics.DrawCurve(const pen: TGdipPen; const points: TReadOnlySpan<TPoint>);
begin
   if pen = nil then
      raise EArgumentNullException.Create('pen');

   CheckErrorStatus(TGdiplusAPI.GdipDrawCurveI(NativeGraphics, pen.NativePen, PPoint(points.GetPinnableReference), points.Length));
end;

procedure TGdipGraphics.DrawCurve(const pen: TGdipPen; const points: TArray<TPoint>; const tension: Single);
begin
   if points = nil then
      raise EArgumentNullException.Create('points');

   DrawCurve(pen, TReadOnlySpan<TPoint>(points), tension)
end;

procedure TGdipGraphics.DrawCurve(const pen: TGdipPen; const points: TReadOnlySpan<TPoint>; const tension: Single);
begin
   if pen = nil then
      raise EArgumentNullException.Create('pen');

   CheckErrorStatus(TGdiplusAPI.GdipDrawCurve2I(NativeGraphics, pen.NativePen, PPoint(points.GetPinnableReference), points.Length, tension));
end;

procedure TGdipGraphics.DrawCurve(const pen: TGdipPen; const points: TArray<TPoint>; const offset: Integer; const numberOfSegments: Integer; const tension: Single);
begin
   if points = nil then
      raise EArgumentNullException.Create('points');

   DrawCurve(pen, TReadOnlySpan<TPoint>(points), offset, numberOfSegments, tension)
end;

procedure TGdipGraphics.DrawCurve(const pen: TGdipPen; const points: TReadOnlySpan<TPoint>; const offset: Integer; const numberOfSegments: Integer; const tension: Single);
begin
   if pen = nil then
      raise EArgumentNullException.Create('pen');

   CheckErrorStatus(TGdiplusAPI.GdipDrawCurve3I(NativeGraphics, pen.NativePen, PPoint(points.GetPinnableReference), points.Length, offset, numberOfSegments, tension));
end;

procedure TGdipGraphics.DrawClosedCurve(const pen: TGdipPen; const points: TArray<TPointF>);
begin
   if points = nil then
      raise EArgumentNullException.Create('points');

   DrawClosedCurve(pen, TReadOnlySpan<TPointF>(points));
end;

procedure TGdipGraphics.DrawClosedCurve(const pen: TGdipPen; const points: TReadOnlySpan<TPointF>);
begin
   if pen = nil then
      raise EArgumentNullException.Create('pen');

   CheckErrorStatus(TGdiplusAPI.GdipDrawClosedCurve(NativeGraphics, pen.NativePen, PPointF(points.GetPinnableReference), points.Length));
end;

procedure TGdipGraphics.DrawClosedCurve(const pen: TGdipPen; const points: TArray<TPointF>; const tension: Single; const fillmode: TGdipFillMode);
begin
   if points = nil then
      raise EArgumentNullException.Create('points');

   DrawClosedCurve(pen, TReadOnlySpan<TPointF>(points), tension, fillmode)
end;

procedure TGdipGraphics.DrawClosedCurve(const pen: TGdipPen; const points: TReadOnlySpan<TPointF>; const tension: Single; const fillmode: TGdipFillMode);
begin
   if pen = nil then
      raise EArgumentNullException.Create('pen');

   CheckErrorStatus(TGdiplusAPI.GdipDrawClosedCurve2(NativeGraphics, pen.NativePen, PPointF(points.GetPinnableReference), points.Length, tension));
end;

procedure TGdipGraphics.DrawClosedCurve(const pen: TGdipPen; const points: TArray<TPoint>);
begin
   if points = nil then
      raise EArgumentNullException.Create('points');

   DrawClosedCurve(pen, TReadOnlySpan<TPoint>(points));
end;

procedure TGdipGraphics.DrawClosedCurve(const pen: TGdipPen; const points: TReadOnlySpan<TPoint>);
begin
   if pen = nil then
      raise EArgumentNullException.Create('pen');

   CheckErrorStatus(TGdiplusAPI.GdipDrawClosedCurveI(NativeGraphics, pen.NativePen, PPoint(points.GetPinnableReference), points.Length));
end;

procedure TGdipGraphics.DrawClosedCurve(const pen: TGdipPen; const points: TArray<TPoint>; const tension: Single; const fillmode: TGdipFillMode);
begin
   if points = nil then
      raise EArgumentNullException.Create('points');

   DrawClosedCurve(pen, TReadOnlySpan<TPoint>(points), tension, fillmode)
end;

procedure TGdipGraphics.DrawClosedCurve(const pen: TGdipPen; const points: TReadOnlySpan<TPoint>; const tension: Single; const fillmode: TGdipFillMode);
begin
   if pen = nil then
      raise EArgumentNullException.Create('pen');

   CheckErrorStatus(TGdiplusAPI.GdipDrawClosedCurve2I(NativeGraphics, pen.NativePen, PPoint(points.GetPinnableReference), points.Length, tension));
end;

procedure TGdipGraphics.Clear(const color: TGdipColor);
begin
   CheckStatus(TGdiplusAPI.GdipGraphicsClear(NativeGraphics, UInt32(color.ToArgb())))
end;

procedure TGdipGraphics.FillRoundedRectangle(const brush: TGdipBrush; const rect: TRectangle; const radius: TSize);
begin
   FillRoundedRectangle(brush, TRectangleF(rect), radius);
end;

procedure TGdipGraphics.FillRoundedRectangle(const brush: TGdipBrush; const rect: TRectangleF; const radius: TSizeF);
begin
   var path: TGdipGraphicsPath := TGdipGraphicsPath.Create();
   path.AddRoundedRectangle(rect, radius);
   FillPath(brush, path);
end;

procedure TGdipGraphics.FillRectangle(const brush: TGdipBrush; const rect: TRectangleF);
begin
   FillRectangle(brush, rect.X, rect.Y, rect.Width, rect.Height)
end;

procedure TGdipGraphics.FillRectangle(const brush: TGdipBrush; const x: Single; const y: Single; const width: Single; const height: Single);
begin
   if brush = nil then
      raise EArgumentNullException.Create('brush');

   CheckErrorStatus(TGdiplusAPI.GdipFillRectangle(NativeGraphics, brush.NativeBrush, x, y, width, height));
end;

procedure TGdipGraphics.FillRectangle(const brush: TGdipBrush; const rect: TRectangle);
begin
   FillRectangle(brush, Single(rect.X), rect.Y, rect.Width, rect.Height);
end;

procedure TGdipGraphics.FillRectangle(const brush: TGdipBrush; const x: Integer; const y: Integer; const width: Integer; const height: Integer);
begin
   FillRectangle(brush, Single(x), y, width, height)
end;

procedure TGdipGraphics.FillRectangles(const brush: TGdipBrush; const rects: TArray<TRectangleF>);
begin
   if rects = nil then
      raise EArgumentNullException.Create('rects');

   FillRectangles(brush, TReadOnlySpan<TRectangleF>(rects));
end;

procedure TGdipGraphics.FillRectangles(const brush: TGdipBrush; const rects: TReadOnlySpan<TRectangleF>);
begin
   if brush = nil then
      raise EArgumentNullException.Create('brush');

   CheckErrorStatus(TGdiplusAPI.GdipFillRectangles(NativeGraphics, brush.NativeBrush, PRectangleF(rects.GetPinnableReference), rects.Length));
end;

procedure TGdipGraphics.FillRectangles(const brush: TGdipBrush; const rects: TArray<TRectangle>);
begin
   if rects = nil then
      raise EArgumentNullException.Create('rects');

   FillRectangles(brush, TReadOnlySpan<TRectangle>(rects));
end;

procedure TGdipGraphics.FillRectangles(const brush: TGdipBrush; const rects: TReadOnlySpan<TRectangle>);
begin
   if brush = nil then
      raise EArgumentNullException.Create('brush');

   CheckErrorStatus(TGdiplusAPI.GdipFillRectanglesI(NativeGraphics, brush.NativeBrush, PRectangle(rects.GetPinnableReference), rects.Length));
end;

procedure TGdipGraphics.FillPolygon(const brush: TGdipBrush; const points: TArray<TPointF>);
begin
   FillPolygon(brush, points, TGdipFillMode.Alternate)
end;

procedure TGdipGraphics.FillPolygon(const brush: TGdipBrush; const points: TReadOnlySpan<TPointF>);
begin
   FillPolygon(brush, points, TGdipFillMode.Alternate)
end;

procedure TGdipGraphics.FillPolygon(const brush: TGdipBrush; const points: TArray<TPointF>; const fillMode: TGdipFillMode);
begin
   if points = nil then
      raise EArgumentNullException.Create('points');

   FillPolygon(brush, TReadOnlySpan<TPointF>(points), fillMode)
end;

procedure TGdipGraphics.FillPolygon(const brush: TGdipBrush; const points: TReadOnlySpan<TPointF>; const fillMode: TGdipFillMode);
begin
   if brush = nil then
      raise EArgumentNullException.Create('brush');

   CheckErrorStatus(TGdiplusAPI.GdipFillPolygon(NativeGraphics, brush.NativeBrush, PPointF(points.GetPinnableReference), points.Length, TGdiPlusAPI.TGdipFillModeEnum(fillMode)));
end;

procedure TGdipGraphics.FillPolygon(const brush: TGdipBrush; const points: TArray<TPoint>);
begin
   if points = nil then
      raise EArgumentNullException.Create('points');

   FillPolygon(brush, points, TGdipFillMode.Alternate)
end;

procedure TGdipGraphics.FillPolygon(const brush: TGdipBrush; const points: TReadOnlySpan<TPoint>);
begin
   FillPolygon(brush, points, TGdipFillMode.Alternate)
end;

procedure TGdipGraphics.FillPolygon(const brush: TGdipBrush; const points: TArray<TPoint>; const fillMode: TGdipFillMode);
begin
   if points = nil then
      raise EArgumentNullException.Create('points');

   FillPolygon(brush, TReadOnlySpan<TPoint>(points), fillMode)
end;

procedure TGdipGraphics.FillPolygon(const brush: TGdipBrush; const points: TReadOnlySpan<TPoint>; const fillMode: TGdipFillMode);
begin
   if brush = nil then
      raise EArgumentNullException.Create('brush');

   CheckErrorStatus(TGdiplusAPI.GdipFillPolygonI(NativeGraphics, brush.NativeBrush, PPoint(points.GetPinnableReference), points.Length, TGdiPlusAPI.TGdipFillModeEnum(fillMode)));
end;

procedure TGdipGraphics.FillEllipse(const brush: TGdipBrush; const rect: TRectangleF);
begin
   FillEllipse(brush, rect.X, rect.Y, rect.Width, rect.Height)
end;

procedure TGdipGraphics.FillEllipse(const brush: TGdipBrush; const x: Single; const y: Single; const width: Single; const height: Single);
begin
   if brush = nil then
      raise EArgumentNullException.Create('brush');

   CheckErrorStatus(TGdiplusAPI.GdipFillEllipse(NativeGraphics, brush.NativeBrush, x, y, width, height));
end;

procedure TGdipGraphics.FillEllipse(const brush: TGdipBrush; const rect: TRectangle);
begin
   FillEllipse(brush, Single(rect.X), rect.Y, rect.Width, rect.Height)
end;

procedure TGdipGraphics.FillEllipse(const brush: TGdipBrush; const x: Integer; const y: Integer; const width: Integer; const height: Integer);
begin
   FillEllipse(brush, Single(x), y, width, height)
end;

procedure TGdipGraphics.FillPie(const brush: TGdipBrush; const rect: TRectangle; const startAngle: Single; const sweepAngle: Single);
begin
   FillPie(brush, rect.X, rect.Y, rect.Width, rect.Height, startAngle, sweepAngle)
end;

procedure TGdipGraphics.FillPie(const brush: TGdipBrush; const rect: TRectangleF; const startAngle: Single; const sweepAngle: Single);
begin
   FillPie(brush, rect.X, rect.Y, rect.Width, rect.Height, startAngle, sweepAngle)
end;

procedure TGdipGraphics.FillPie(const brush: TGdipBrush; const x: Single; const y: Single; const width: Single; const height: Single; const startAngle: Single; const sweepAngle: Single);
begin
   if brush = nil then
      raise EArgumentNullException.Create('brush');

   CheckErrorStatus(TGdiplusAPI.GdipFillPie(NativeGraphics, brush.NativeBrush, x, y, width, height, startAngle, sweepAngle));
end;

procedure TGdipGraphics.FillPie(const brush: TGdipBrush; const x: Integer; const y: Integer; const width: Integer; const height: Integer; const startAngle: Integer; const sweepAngle: Integer);
begin
   FillPie(brush, Single(x), y, width, height, startAngle, sweepAngle)
end;

procedure TGdipGraphics.FillClosedCurve(const brush: TGdipBrush; const points: TArray<TPointF>);
begin
   if points = nil then
      raise EArgumentNullException.Create('points');

   FillClosedCurve(brush, TReadOnlySpan<TPointF>(points));
end;

procedure TGdipGraphics.FillClosedCurve(const brush: TGdipBrush; const points: TReadOnlySpan<TPointF>);
begin
   if brush = nil then
      raise EArgumentNullException.Create('brush');

   CheckErrorStatus(TGdiplusAPI.GdipFillClosedCurve(NativeGraphics, brush.NativeBrush, PPointF(points.GetPinnableReference), points.Length));
end;

procedure TGdipGraphics.FillClosedCurve(const brush: TGdipBrush; const points: TArray<TPointF>; const fillmode: TGdipFillMode);
begin
   FillClosedCurve(brush, points, fillmode, Single(0.5))
end;

procedure TGdipGraphics.FillClosedCurve(const brush: TGdipBrush; const points: TReadOnlySpan<TPointF>; const fillmode: TGdipFillMode);
begin
   FillClosedCurve(brush, points, fillmode, Single(0.5))
end;

procedure TGdipGraphics.FillClosedCurve(const brush: TGdipBrush; const points: TArray<TPointF>; const fillmode: TGdipFillMode; const tension: Single);
begin
   if points = nil then
      raise EArgumentNullException.Create('points');

   FillClosedCurve(brush, TReadOnlySpan<TPointF>(points), fillmode, tension)
end;

procedure TGdipGraphics.FillClosedCurve(const brush: TGdipBrush; const points: TReadOnlySpan<TPointF>; const fillmode: TGdipFillMode; const tension: Single);
begin
   if brush = nil then
      raise EArgumentNullException.Create('brush');

   CheckErrorStatus(TGdiplusAPI.GdipFillClosedCurve2(NativeGraphics, brush.NativeBrush, PPointF(points.GetPinnableReference), points.Length, tension, TGdiPlusAPI.TGdipFillModeEnum(fillmode)));
end;

procedure TGdipGraphics.FillClosedCurve(const brush: TGdipBrush; const points: TArray<TPoint>);
begin
   if points = nil then
      raise EArgumentNullException.Create('points');

   FillClosedCurve(brush, TReadOnlySpan<TPoint>(points));
end;

procedure TGdipGraphics.FillClosedCurve(const brush: TGdipBrush; const points: TReadOnlySpan<TPoint>);
begin
   if brush = nil then
      raise EArgumentNullException.Create('brush');

   CheckErrorStatus(TGdiplusAPI.GdipFillClosedCurveI(NativeGraphics, brush.NativeBrush, PPoint(points.GetPinnableReference), points.Length));
end;

procedure TGdipGraphics.FillClosedCurve(const brush: TGdipBrush; const points: TArray<TPoint>; const fillmode: TGdipFillMode);
begin
   FillClosedCurve(brush, points, fillmode, Single(0.5))
end;

procedure TGdipGraphics.FillClosedCurve(const brush: TGdipBrush; const points: TReadOnlySpan<TPoint>; const fillmode: TGdipFillMode);
begin
   FillClosedCurve(brush, points, fillmode, Single(0.5))
end;

procedure TGdipGraphics.FillClosedCurve(const brush: TGdipBrush; const points: TArray<TPoint>; const fillmode: TGdipFillMode; const tension: Single);
begin
   if points = nil then
      raise EArgumentNullException.Create('points');

   FillClosedCurve(brush, TReadOnlySpan<TPoint>(points), fillmode, tension)
end;

procedure TGdipGraphics.FillClosedCurve(const brush: TGdipBrush; const points: TReadOnlySpan<TPoint>; const fillmode: TGdipFillMode; const tension: Single);
begin
   if brush = nil then
      raise EArgumentNullException.Create('brush');

   CheckErrorStatus(TGdiplusAPI.GdipFillClosedCurve2I(NativeGraphics, brush.NativeBrush, PPoint(points.GetPinnableReference), points.Length, tension, TGdiPlusAPI.TGdipFillModeEnum(fillmode)));
end;

procedure TGdipGraphics.DrawString(const s: string; const font: TGdipFont; const brush: TGdipBrush; const x: Single; const y: Single);
begin
   DrawStringInternal(s, font, brush, TRectangleF.Create(x, y, 0, 0),  nil )
end;

//procedure TGdipGraphics.DrawString(const s: string; const font: TGdipFont; const brush: TGdipBrush; const x: Single; const y: Single);
//begin
//   DrawStringInternal(s, font, brush, TRectangleF.Create(x, y, 0, 0),  nil )
//end;

procedure TGdipGraphics.DrawString(const s: string; const font: TGdipFont; const brush: TGdipBrush; const point: TPointF);
begin
   DrawStringInternal(s, font, brush, TRectangleF.Create(point.X, point.Y, 0, 0),  nil )
end;

//procedure TGdipGraphics.DrawString(const [ref] s: TArray<Char>; const font: TGdipFont; const brush: TGdipBrush; const point: TPointF);
//begin
//   DrawStringInternal(s, font, brush, TRectangleF.Create(point.X, point.Y, 0, 0),  nil )
//end;

procedure TGdipGraphics.DrawString(const s: string; const font: TGdipFont; const brush: TGdipBrush; const x: Single; const y: Single; const format: TGdipStringFormat);
begin
   DrawStringInternal(s, font, brush, TRectangleF.Create(x, y, 0, 0), format)
end;

//procedure TGdipGraphics.DrawString(const [ref] s: TArray<Char>; const font: TGdipFont; const brush: TGdipBrush; const x: Single; const y: Single; const format: TGdipStringFormat);
//begin
//   DrawStringInternal(s, font, brush, TRectangleF.Create(x, y, 0, 0), format)
//end;

procedure TGdipGraphics.DrawString(const s: string; const font: TGdipFont; const brush: TGdipBrush; const point: TPointF; const format: TGdipStringFormat);
begin
   DrawString(s, font, brush, TRectangleF.Create(point.X, point.Y, 0, 0), format)
end;

//procedure TGdipGraphics.DrawString(const [ref] s: TArray<Char>; const font: TGdipFont; const brush: TGdipBrush; const point: TPointF; const format: TGdipStringFormat);
//begin
//   DrawString(s, font, brush, TRectangleF.Create(point.X, point.Y, 0, 0), format)
//end;

procedure TGdipGraphics.DrawString(const s: string; const font: TGdipFont; const brush: TGdipBrush; const layoutRectangle: TRectangleF);
begin
   DrawStringInternal(s, font, brush, layoutRectangle,  nil )
end;

//procedure TGdipGraphics.DrawString(const s: string; const font: TGdipFont; const brush: TGdipBrush; const layoutRectangle: TRectangleF);
//begin
//   DrawStringInternal(s, font, brush, layoutRectangle,  nil )
//end;

procedure TGdipGraphics.DrawString(const s: string; const font: TGdipFont; const brush: TGdipBrush; const layoutRectangle: TRectangleF; const format: TGdipStringFormat);
begin
   DrawStringInternal(s, font, brush, layoutRectangle, format)
end;

//procedure TGdipGraphics.DrawString(const [ref] s: TArray<Char>; const font: TGdipFont; const brush: TGdipBrush; const layoutRectangle: TRectangleF; const format: TGdipStringFormat);
//begin
//   DrawStringInternal(s, font, brush, layoutRectangle, format)
//end;
//
procedure TGdipGraphics.DrawStringInternal(const s: string; const font: TGdipFont; const brush: TGdipBrush; const layoutRectangle: TRectangleF; const format: TGdipStringFormat);
begin
   if s.IsEmpty then
      raise EArgumentNullException.Create('s');
   if brush = nil then
      raise EArgumentNullException.Create('brush');
   if brush.NativeBrush = nil then
      raise EArgumentNullException.Create('brush.NativeBrush');
   if font = nil then
      raise EArgumentNullException.Create('font');
   if font.NativeFont = nil then
      raise EArgumentNullException.Create('font.NativeFont');


   if (s.IsEmpty) then
   begin
      Exit();
   end;

   if font = nil then
      raise EArgumentNullException.Create('font');

  var FontString := Font.ToString();

  OutputDebugString(PChar(FontString));

   CheckErrorStatus(TGdiplusAPI.GdipDrawString(NativeGraphics, @s[0], -1, font.NativeFont, @layoutRectangle, format.Pointer(), brush.NativeBrush));
end;

function TGdipGraphics.MeasureString(const text: string; const font: TGdipFont; const layoutArea: TSizeF; const stringFormat: TGdipStringFormat; out charactersFitted: Integer; out linesFilled: Integer): TSizeF;
begin
   Result := MeasureStringInternal(text.ToCharArray(), font, TRectangleF.Create(default(TSizeF), layoutArea), stringFormat, charactersFitted, linesFilled);
end;

function TGdipGraphics.MeasureString(const text: TReadOnlySpan<Char>; const font: TGdipFont; const layoutArea: TSizeF; const stringFormat: TGdipStringFormat; out charactersFitted: Integer; out linesFilled: Integer): TSizeF;
begin
   Result := MeasureStringInternal(text, font, TRectangleF.Create(default(TSizeF), layoutArea), stringFormat, charactersFitted, linesFilled);
end;

function TGdipGraphics.MeasureStringInternal(const text: TReadOnlySpan<Char>; const font: TGdipFont; const layoutArea: TRectangleF; const stringFormat: TGdipStringFormat; out charactersFitted: Integer; out linesFilled: Integer): TSizeF;
begin
   if (text.IsEmpty) then
   begin
      charactersFitted := 0;
      linesFilled := 0;

      Exit(TSizeF.Empty);
   end;

   if font = nil then
      raise EArgumentNullException.Create('font');

   var boundingBox: TRectangleF := Default(TRectangleF);
   var c: PWideChar := PWideChar(UnicodeString(text.GetPinnableReference));
   var fitted: PInteger := @charactersFitted;
   var filled: PInteger := @linesFilled;
   begin
      CheckStatus(TGdiplusAPI.GdipMeasureString(NativeGraphics, c, text.Length, font.NativeFont, @layoutArea, stringFormat._nativeFormat, @boundingBox, fitted, filled));
   end;

   Exit(TSizeF.Create(boundingBox.Width, boundingBox.Height));
end;

function TGdipGraphics.MeasureString(const text: string; const font: TGdipFont; const origin: TPointF; const stringFormat: TGdipStringFormat): TSizeF;
begin
   var charactersFitted: Integer;
   var linesFilled: Integer;

   Result := MeasureStringInternal(text.ToCharArray(), font, TRectangleF.Create(origin, default(TPointF)), stringFormat, charactersFitted, linesFilled);
end;

function TGdipGraphics.MeasureString(const text: TReadOnlySpan<Char>; const font: TGdipFont; const origin: TPointF; const stringFormat: TGdipStringFormat): TSizeF;
begin
   var charactersFitted: Integer;
   var linesFilled: Integer;

   Result := MeasureStringInternal(text, font,  TRectangleF.Create(origin, default(TPointF)), stringFormat, charactersFitted, linesFilled);
end;

function TGdipGraphics.MeasureString(const text: string; const font: TGdipFont; const layoutArea: TSizeF): TSizeF;
begin
   Result := MeasureString(text, font, layoutArea,  nil )
end;

function TGdipGraphics.MeasureString(const text: TReadOnlySpan<Char>; const font: TGdipFont; const layoutArea: TSizeF): TSizeF;
begin
   Result := MeasureString(text, font, layoutArea,  nil )
end;

function TGdipGraphics.MeasureString(const text: string; const font: TGdipFont; const layoutArea: TSizeF; const stringFormat: TGdipStringFormat): TSizeF;
begin
   var charactersFitted: Integer;
   var linesFilled: Integer;

   Result := MeasureStringInternal(text.ToCharArray(), font, TRectangleF.Create(default(TSizeF), layoutArea), stringFormat, charactersFitted, linesFilled);
end;

function TGdipGraphics.MeasureString(const text: TReadOnlySpan<Char>; const font: TGdipFont; const layoutArea: TSizeF; const stringFormat: TGdipStringFormat): TSizeF;
begin
   var charactersFitted: Integer;
   var linesFilled: Integer;

   Result := MeasureStringInternal(text, font, TRectangleF.Create(default(TSizeF), layoutArea), stringFormat, charactersFitted, linesFilled);
end;

function TGdipGraphics.MeasureString(const text: string; const font: TGdipFont): TSizeF;
begin
   Result := MeasureString(text, font, TSizeF.Create(0, 0))
end;

function TGdipGraphics.MeasureString(const text: TReadOnlySpan<Char>; const font: TGdipFont): TSizeF;
begin
   Result := MeasureString(text, font, TSizeF.Create(0, 0))
end;

function TGdipGraphics.MeasureString(const text: string; const font: TGdipFont; const width: Integer): TSizeF;
begin
   Result := MeasureString(text, font, TSizeF.Create(width, 999999))
end;

function TGdipGraphics.MeasureString(const text: TReadOnlySpan<Char>; const font: TGdipFont; const width: Integer): TSizeF;
begin
   Result := MeasureString(text, font, TSizeF.Create(width, 999999))
end;

function TGdipGraphics.MeasureString(const text: string; const font: TGdipFont; const width: Integer; const format: TGdipStringFormat): TSizeF;
begin
   Result := MeasureString(text, font, TSizeF.Create(width, 999999), format)
end;

function TGdipGraphics.MeasureString(const text: TReadOnlySpan<Char>; const font: TGdipFont; const width: Integer; const format: TGdipStringFormat): TSizeF;
begin
   Result := MeasureString(text, font, TSizeF.Create(width, 999999), format)
end;

function TGdipGraphics.MeasureCharacterRanges(const text: string; const font: TGdipFont; const layoutRect: TRectangleF; const stringFormat: TGdipStringFormat): TArray<TGdipRegion>;
begin
   Result := MeasureCharacterRangesInternal(text.ToCharArray(), font, layoutRect, stringFormat)
end;

function TGdipGraphics.MeasureCharacterRanges(const text: TReadOnlySpan<Char>; const font: TGdipFont; const layoutRect: TRectangleF; const stringFormat: TGdipStringFormat): TArray<TGdipRegion>;
begin
   Result := MeasureCharacterRangesInternal(text, font, layoutRect, stringFormat)
end;

function TGdipGraphics.MeasureCharacterRangesInternal(const text: TReadOnlySpan<Char>; const font: TGdipFont; const layoutRect: TRectangleF; const stringFormat: TGdipStringFormat): TArray<TGdipRegion>;
begin
   if (text.IsEmpty) then
      Exit(nil);

   if font = nil then
      raise EArgumentNullException.Create('font');

   var count: Integer;
   CheckStatus(TGdiplusAPI.GdipGetStringFormatMeasurableCharacterRangeCount(stringFormat._nativeFormat, count));

   if (count = 0) then
   begin
      Exit(nil);
   end;

   var gpRegions: TArray<TGdiplusAPI.TGdipRegionPtr>;
   SetLength(gpRegions, count);
   var regions: TArray<TGdipRegion>;
   SetLength(regions, count);


   for var f: Integer := 0 to count - 1 do
   begin
      begin
         regions[f] := TGdipRegion.Create();
         gpRegions[f] := regions[f].NativeRegion;
      end;
   end;

   var c: PWideChar := PWideChar(UnicodeString(text.GetPinnableReference));
   var r: TGdiplusAPI.TGdipRegionPtr := @gpRegions[0];
   CheckStatus(TGdiplusAPI.GdipMeasureCharacterRanges(NativeGraphics, c, text.Length, font.NativeFont, @layoutRect, stringFormat._nativeFormat, count, r));

   Exit(regions);
end;

procedure TGdipGraphics.DrawImage(const image: TGdipImage; const point: TPointF);
begin
   DrawImage(image, point.X, point.Y)
end;

procedure TGdipGraphics.DrawImage(const image: TGdipImage; const x: Single; const y: Single);
begin
   if image = nil then
      raise EArgumentNullException.Create('image');

   var status: TGdiplusAPI.TGdipStatusEnum := TGdiplusAPI.GdipDrawImage(NativeGraphics, image.Pointer, x, y);
   IgnoreMetafileErrors(image, status);
   CheckErrorStatus(status);
end;

procedure TGdipGraphics.DrawImage(const image: TGdipImage; const rect: TRectangleF);
begin
   DrawImage(image, rect.X, rect.Y, rect.Width, rect.Height)
end;

procedure TGdipGraphics.DrawImage(const image: TGdipImage; const x: Single; const y: Single; const width: Single; const height: Single);
begin
   if image = nil then
      raise EArgumentNullException.Create('image');

   var status: TGdiplusAPI.TGdipStatusEnum := TGdiplusAPI.GdipDrawImageRect(NativeGraphics, image.Pointer, x, y, width, height);
   IgnoreMetafileErrors(image, status);
   CheckErrorStatus(status);
end;

procedure TGdipGraphics.DrawImage(const image: TGdipImage; const point: TPoint);
begin
   DrawImage(image, Single(point.X), point.Y)
end;

procedure TGdipGraphics.DrawImage(const image: TGdipImage; const x: Integer; const y: Integer);
begin
   DrawImage(image, Single(x), y)
end;

procedure TGdipGraphics.DrawImage(const image: TGdipImage; const rect: TRectangle);
begin
   DrawImage(image, Single(rect.X), rect.Y, rect.Width, rect.Height)
end;

procedure TGdipGraphics.DrawImage(const image: TGdipImage; const x: Integer; const y: Integer; const width: Integer; const height: Integer);
begin
   DrawImage(image, Single(x), y, width, height)
end;

procedure TGdipGraphics.DrawImageUnscaled(const image: TGdipImage; const point: TPoint);
begin
   DrawImage(image, point.X, point.Y)
end;

procedure TGdipGraphics.DrawImageUnscaled(const image: TGdipImage; const x: Integer; const y: Integer);
begin
   DrawImage(image, x, y)
end;

procedure TGdipGraphics.DrawImageUnscaled(const image: TGdipImage; const rect: TRectangle);
begin
   DrawImage(image, rect.X, rect.Y)
end;

procedure TGdipGraphics.DrawImageUnscaled(const image: TGdipImage; const x: Integer; const y: Integer; const width: Integer; const height: Integer);
begin
   DrawImage(image, x, y)
end;

procedure TGdipGraphics.DrawImageUnscaledAndClipped(const image: TGdipImage; const rect: TRectangle);
begin
   if image = nil then
      raise EArgumentNullException.Create('image');

   var width: Integer := System.Math.Min(rect.Width, image.Width);
   var height: Integer := System.Math.Min(rect.Height, image.Height);
   DrawImage(image, rect, 0, 0, width, height, TGdipGraphicsUnit.Pixel);
end;

procedure TGdipGraphics.DrawImage(const image: TGdipImage; const destPoints: TArray<TPointF>);
begin
   // Affine or perspective blt
   //
   //  destPoints.Length = 3: rect => parallelogram
   //      destPoints[0] <=> top-left corner of the source rectangle
   //      destPoints[1] <=> top-right corner
   //      destPoints[2] <=> bottom-left corner
   //  destPoints.Length = 4: rect => quad
   //      destPoints[3] <=> bottom-right corner
   //
   //  @notes Perspective blt only works for bitmap images.

   if image = nil then
      raise EArgumentNullException.Create('image');

   if destPoints = nil then
      raise EArgumentNullException.Create('destPoints');

   var count: Integer := Length(destPoints);
   if (count <> 3) and (count <> 4) then
      raise EArgumentException.Create('SR.GdiplusDestPointsInvalidLength');

   var status: TGdiplusAPI.TGdipStatusEnum := TGdiplusAPI.GdipDrawImagePoints(NativeGraphics, image.Pointer, @destPoints[0], count);
   IgnoreMetafileErrors(image, status);
   CheckErrorStatus(status);
end;

procedure TGdipGraphics.DrawImage(const image: TGdipImage; const destPoints: TArray<TPoint>);
begin
   if image = nil then
      raise EArgumentNullException.Create('image');

   if destPoints = nil then
      raise EArgumentNullException.Create('destPoints');


   var count: Integer := Length(destPoints);
   if (count <> 3) and (count <> 4) then
      raise EArgumentException.Create('SR.GdiplusDestPointsInvalidLength');

   var status: TGdiplusAPI.TGdipStatusEnum := TGdiplusAPI.GdipDrawImagePointsI(NativeGraphics, image.Pointer, @destPoints[0], count);
   IgnoreMetafileErrors(image, status);
   CheckErrorStatus(status);
end;

procedure TGdipGraphics.DrawImage(const image: TGdipImage; const x: Single; const y: Single; const srcRect: TRectangleF; const srcUnit: TGdipGraphicsUnit);
begin
   if image = nil then
      raise EArgumentNullException.Create('image');

   var status: TGdiplusAPI.TGdipStatusEnum := TGdiplusAPI.GdipDrawImagePointRect(NativeGraphics, image.Pointer, x, y, srcRect.X, srcRect.Y, srcRect.Width, srcRect.Height, TGdiplusAPI.TGdipUnitEnum(srcUnit));
   IgnoreMetafileErrors(image, status);
   CheckErrorStatus(status);
end;

procedure TGdipGraphics.DrawImage(const image: TGdipImage; const x: Integer; const y: Integer; const srcRect: TRectangle; const srcUnit: TGdipGraphicsUnit);
begin
   DrawImage(image, x, y, TRectangleF(srcRect), srcUnit)
end;

procedure TGdipGraphics.DrawImage(const image: TGdipImage; const destRect: TRectangleF; const srcRect: TRectangleF; const srcUnit: TGdipGraphicsUnit);
begin
   if image = nil then
      raise EArgumentNullException.Create('image');

   var status: TGdiplusAPI.TGdipStatusEnum := TGdiplusAPI.GdipDrawImageRectRect(NativeGraphics, image.Pointer, destRect.X, destRect.Y, destRect.Width, destRect.Height, srcRect.X, srcRect.Y, srcRect.Width, srcRect.Height, TGdiplusAPI.TGdipUnitEnum(srcUnit),  nil , nil,  nil);
   IgnoreMetafileErrors(image, status);
   CheckErrorStatus(status);
end;

procedure TGdipGraphics.DrawImage(const image: TGdipImage; const destRect: TRectangle; const srcRect: TRectangle; const srcUnit: TGdipGraphicsUnit);

begin
   DrawImage(image, destRect, srcRect.X, srcRect.Y, srcRect.Width, srcRect.Height, srcUnit)
end;

procedure TGdipGraphics.DrawImage(const image: TGdipImage; const destPoints: TArray<TPointF>; const srcRect: TRectangleF; const srcUnit: TGdipGraphicsUnit);
begin
   if image = nil then
      raise EArgumentNullException.Create('image');
   if destPoints = nil then
      raise EArgumentNullException.Create('destPoints');

   var count: Integer := Length(destPoints);
   if (count <> 3) and (count <> 4) then
      raise EArgumentException.Create('SR.GdiplusDestPointsInvalidLength');

   var status: TGdiplusAPI.TGdipStatusEnum := TGdiplusAPI.GdipDrawImagePointsRect(NativeGraphics, image.Pointer, @destPoints[0], Length(destPoints), srcRect.X, srcRect.Y, srcRect.Width, srcRect.Height, TGdiplusAPI.TGdipUnitEnum(srcUnit),  nil , 0,  nil );
   IgnoreMetafileErrors(image, status);
   CheckErrorStatus(status);
end;

procedure TGdipGraphics.DrawImage(const image: TGdipImage; const destPoints: TArray<TPointF>; const srcRect: TRectangleF; const srcUnit: TGdipGraphicsUnit; const imageAttr: TGdipImageAttributes);
begin
   DrawImage(image, destPoints, srcRect, srcUnit, imageAttr,  nil , 0)
end;

procedure TGdipGraphics.DrawImage(const image: TGdipImage; const destPoints: TArray<TPointF>; const srcRect: TRectangleF; const srcUnit: TGdipGraphicsUnit; const imageAttr: TGdipImageAttributes; callback: TGdipDrawImageAbort);
begin
   DrawImage(image, destPoints, srcRect, srcUnit, imageAttr, callback, 0)
end;

procedure TGdipGraphics.DrawImage(const image: TGdipImage; const destPoints: TArray<TPointF>; const srcRect: TRectangleF; const srcUnit: TGdipGraphicsUnit; const imageAttr: TGdipImageAttributes; callback: TGdipDrawImageAbort; callbackData: Integer);
begin
   if image = nil then
      raise EArgumentNullException.Create('image');
   if destPoints = nil then
      raise EArgumentNullException.Create('destPoints');

   var count: Integer := Length(destPoints);
   if (count <> 3) and (count <> 4) then
      raise EArgumentException.Create('SR.GdiplusDestPointsInvalidLength');

   var status: TGdiplusAPI.TGdipStatusEnum;

   if @callback = nil then
      status := TGdiplusAPI.GdipDrawImagePointsRect(NativeGraphics, image.Pointer, @destPoints[0], Length(destPoints), srcRect.X, srcRect.Y, srcRect.Width, srcRect.Height, TGdiplusAPI.TGdipUnitEnum(srcUnit), imageAttr._nativeImageAttributes, 0, System.Pointer(NativeInt(callbackData)))
   else
   begin
      raise ENotImplemented.Create('Ainda não fiz isso aqui! TODO:');
      //status := TGdiplusAPI.GdipDrawImagePointsRect(NativeGraphics, image.Pointer, @destPoints[0], Length(destPoints), srcRect.X, srcRect.Y, srcRect.Width, srcRect.Height, TGdiplusAPI.TGdipUnitEnum(srcUnit), imageAttr._nativeImageAttributes, 0, TMarshal.GetFunctionPointerForDelegate(callback), Pointer(NativeInt(callbackData)));
   end;

   IgnoreMetafileErrors(image, status);
   CheckErrorStatus(status);
end;

procedure TGdipGraphics.DrawImage(const image: TGdipImage; const destPoints: TArray<TPoint>; const srcRect: TRectangle; const srcUnit: TGdipGraphicsUnit);
begin
   DrawImage(image, destPoints, srcRect, srcUnit,  nil ,  nil , 0)
end;

procedure TGdipGraphics.DrawImage(const image: TGdipImage; const destPoints: TArray<TPoint>; const srcRect: TRectangle; const srcUnit: TGdipGraphicsUnit; const imageAttr: TGdipImageAttributes);
begin
   DrawImage(image, destPoints, srcRect, srcUnit, imageAttr,  nil , 0)
end;

procedure TGdipGraphics.DrawImage(const image: TGdipImage; const destPoints: TArray<TPoint>; const srcRect: TRectangle; const srcUnit: TGdipGraphicsUnit; const imageAttr: TGdipImageAttributes; callback: TGdipDrawImageAbort);
begin
   DrawImage(image, destPoints, srcRect, srcUnit, imageAttr, callback, 0)
end;

procedure TGdipGraphics.DrawImage(const image: TGdipImage; const destPoints: TArray<TPoint>; const srcRect: TRectangle; const srcUnit: TGdipGraphicsUnit; const imageAttr: TGdipImageAttributes; callback: TGdipDrawImageAbort; callbackData: Integer);
begin
   if image = nil then
      raise EArgumentNullException.Create('image');
   if destPoints = nil then
      raise EArgumentNullException.Create('destPoints');

   var count: Integer := Length(destPoints);
   if (count <> 3) and (count <> 4) then
      raise EArgumentException.Create('SR.GdiplusDestPointsInvalidLength');

   var status: TGdiplusAPI.TGdipStatusEnum;

   if @callback = nil then
      status := TGdiplusAPI.GdipDrawImagePointsRectI(NativeGraphics, image.Pointer, @destPoints[0], Length(destPoints), srcRect.X, srcRect.Y, srcRect.Width, srcRect.Height, TGdiplusAPI.TGdipUnitEnum(srcUnit), imageAttr._nativeImageAttributes, 0, System.Pointer(NativeInt(callbackData)))
   else
   begin
      raise ENotImplemented.Create('Ainda não fiz isso aqui! TODO:');
//      status := TGdiplusAPI.GdipDrawImagePointsRectI(NativeGraphics, image.Pointer, @destPoints[0], Length(destPoints), srcRect.X, srcRect.Y, srcRect.Width, srcRect.Height, TGdiplusAPI.TGdipUnitEnum(srcUnit), imageAttr._nativeImageAttributes, 0, TMarshal.GetFunctionPointerForDelegate(callback), System.Pointer(NativeInt(callbackData)));
   end;


   IgnoreMetafileErrors(image, status);
   CheckErrorStatus(status);
end;

procedure TGdipGraphics.DrawImage(const image: TGdipImage; const destRect: TRectangle; const srcX: Single; const srcY: Single; const srcWidth: Single; const srcHeight: Single; const srcUnit: TGdipGraphicsUnit);
begin
   DrawImage(image, destRect, srcX, srcY, srcWidth, srcHeight, srcUnit,  nil )
end;

procedure TGdipGraphics.DrawImage(const image: TGdipImage; const destRect: TRectangle; const srcX: Single; const srcY: Single; const srcWidth: Single; const srcHeight: Single; const srcUnit: TGdipGraphicsUnit; const imageAttrs: TGdipImageAttributes);
begin
   DrawImage(image, destRect, srcX, srcY, srcWidth, srcHeight, srcUnit, imageAttrs,  nil )
end;

procedure TGdipGraphics.DrawImage(const image: TGdipImage; const destRect: TRectangle; const srcX: Single; const srcY: Single; const srcWidth: Single; const srcHeight: Single; const srcUnit: TGdipGraphicsUnit; const imageAttrs: TGdipImageAttributes; const callback: TGdipDrawImageAbort);
begin
   DrawImage(image, destRect, srcX, srcY, srcWidth, srcHeight, srcUnit, imageAttrs, callback, nil);
end;

procedure TGdipGraphics.DrawImage(const image: TGdipImage; const destRect: TRectangle; const srcX: Single; const srcY: Single; const srcWidth: Single; const srcHeight: Single; const srcUnit: TGdipGraphicsUnit; const imageAttrs: TGdipImageAttributes; const callback: TGdipDrawImageAbort; const callbackData: Pointer);
begin
   if image = nil then
      raise EArgumentNullException.Create('image');

   var status: TGdiplusAPI.TGdipStatusEnum;

   status := TGdiplusAPI.GdipDrawImageRectRect(NativeGraphics, image.Pointer(), destRect.X, destRect.Y, destRect.Width, destRect.Height, srcX, srcY, srcWidth, srcHeight, TGdiplusAPI.TGdipUnitEnum(srcUnit), imageAttrs.Pointer(), Callback, callbackData);

   IgnoreMetafileErrors(image, status);
   CheckErrorStatus(status);
end;

procedure TGdipGraphics.DrawImage(const image: TGdipImage; const destRect: TRectangle; const srcX: Integer; const srcY: Integer; const srcWidth: Integer; const srcHeight: Integer; const srcUnit: TGdipGraphicsUnit);
begin
   DrawImage(image, destRect, Single(srcX), srcY, srcWidth, srcHeight, srcUnit,  nil )
end;

procedure TGdipGraphics.DrawImage(const image: TGdipImage; const destRect: TRectangle; const srcX: Integer; const srcY: Integer; const srcWidth: Integer; const srcHeight: Integer; const srcUnit: TGdipGraphicsUnit; const imageAttr: TGdipImageAttributes);
begin
   DrawImage(image, destRect, Single(srcX), srcY, srcWidth, srcHeight, srcUnit, imageAttr,  nil )
end;

procedure TGdipGraphics.DrawImage(const image: TGdipImage; const destRect: TRectangle; const srcX: Integer; const srcY: Integer; const srcWidth: Integer; const srcHeight: Integer; const srcUnit: TGdipGraphicsUnit; const imageAttr: TGdipImageAttributes; callback: TGdipDrawImageAbort);
begin
   DrawImage(image, destRect, Single(srcX), srcY, srcWidth, srcHeight, srcUnit, imageAttr, callback, nil);
end;

procedure TGdipGraphics.DrawImage(const image: TGdipImage; const destRect: TRectangle; const srcX: Integer; const srcY: Integer; const srcWidth: Integer; const srcHeight: Integer; const srcUnit: TGdipGraphicsUnit; const imageAttrs: TGdipImageAttributes; callback: TGdipDrawImageAbort; callbackData: Pointer);
begin
   DrawImage(image, destRect, Single(srcX), srcY, srcWidth, srcHeight, srcUnit, imageAttrs, callback, callbackData)
end;

procedure TGdipGraphics.DrawLine(const pen: TGdipPen; const pt1: TPointF; const pt2: TPointF);
begin
   DrawLine(pen, pt1.X, pt1.Y, pt2.X, pt2.Y)
end;

procedure TGdipGraphics.DrawLines(const pen: TGdipPen; const points: TArray<TPointF>);
begin
   if points = nil then
      raise EArgumentNullException.Create('points');

   DrawLines(pen, TReadOnlySpan<TPointF>(points));
end;

procedure TGdipGraphics.DrawLines(const pen: TGdipPen; const points: TReadOnlySpan<TPointF>);
begin
   if pen = nil then
      raise EArgumentNullException.Create('pen');

   CheckErrorStatus(TGdiplusAPI.GdipDrawLines(NativeGraphics, pen.NativePen, PPointF(points.GetPinnableReference), points.Length));
end;

procedure TGdipGraphics.DrawLine(const pen: TGdipPen; const x1: Integer; const y1: Integer; const x2: Integer; const y2: Integer);
begin
   DrawLine(pen, Single(x1), y1, x2, y2)
end;

procedure TGdipGraphics.DrawLine(const pen: TGdipPen; const pt1: TPoint; const pt2: TPoint);
begin
   DrawLine(pen, Single(pt1.X), pt1.Y, pt2.X, pt2.Y)
end;

procedure TGdipGraphics.DrawLines(const pen: TGdipPen; const points: TArray<TPoint>);
begin
   if pen = nil then
      raise EArgumentNullException.Create('pen');
   if points = nil then
      raise EArgumentNullException.Create('points');

   CheckErrorStatus(TGdiplusAPI.GdipDrawLinesI(NativeGraphics, pen.NativePen, @points[0], Length(points)));
end;

procedure TGdipGraphics.DrawLines(const pen: TGdipPen; const points: TReadOnlySpan<TPoint>);
begin
   if pen = nil then
      raise EArgumentNullException.Create('pen');

   CheckErrorStatus(TGdiplusAPI.GdipDrawLinesI(NativeGraphics, pen.NativePen, PPoint(points.GetPinnableReference), points.Length));
end;

procedure TGdipGraphics.CopyFromScreen(const upperLeftSource: TPoint; const upperLeftDestination: TPoint; const blockRegionSize: TSize);
begin
   CopyFromScreen(upperLeftSource.X, upperLeftSource.Y, upperLeftDestination.X, upperLeftDestination.Y, blockRegionSize)
end;

procedure TGdipGraphics.CopyFromScreen(const sourceX: Integer; const sourceY: Integer; const destinationX: Integer; const destinationY: Integer; const blockRegionSize: TSize);
begin
   CopyFromScreen(sourceX, sourceY, destinationX, destinationY, blockRegionSize, TGdipCopyPixelOperation.SourceCopy)
end;

procedure TGdipGraphics.CopyFromScreen(const upperLeftSource: TPoint; const upperLeftDestination: TPoint; const blockRegionSize: TSize; const copyPixelOperation: TGdipCopyPixelOperation);
begin
   CopyFromScreen(upperLeftSource.X, upperLeftSource.Y, upperLeftDestination.X, upperLeftDestination.Y, blockRegionSize, copyPixelOperation)
end;

procedure TGdipGraphics.EnumerateMetafile(const metafile: TGdipMetafile; const destPoint: TPointF; const callback: TGdipEnumerateMetafileProc);
begin
   EnumerateMetafile(metafile, destPoint, callback, nil);
end;

procedure TGdipGraphics.EnumerateMetafile(const metafile: TGdipMetafile; const destPoint: TPointF; const callback: TGdipEnumerateMetafileProc; const callbackData: Pointer);
begin
   EnumerateMetafile(metafile, destPoint, callback, callbackData,  nil);
end;

procedure TGdipGraphics.EnumerateMetafile(const metafile: TGdipMetafile; const destPoint: TPoint; const callback: TGdipEnumerateMetafileProc);
begin
   EnumerateMetafile(metafile, destPoint, callback, nil);
end;

procedure TGdipGraphics.EnumerateMetafile(const metafile: TGdipMetafile; const destPoint: TPoint; const callback: TGdipEnumerateMetafileProc; const callbackData: Pointer);
begin
   EnumerateMetafile(metafile, destPoint, callback, callbackData,  nil);
end;

procedure TGdipGraphics.EnumerateMetafile(const metafile: TGdipMetafile; const destRect: TRectangleF; const callback: TGdipEnumerateMetafileProc);
begin
   EnumerateMetafile(metafile, destRect, callback, nil);
end;

procedure TGdipGraphics.EnumerateMetafile(const metafile: TGdipMetafile; const destRect: TRectangleF; const callback: TGdipEnumerateMetafileProc; const callbackData: Pointer);
begin
   EnumerateMetafile(metafile, destRect, callback, callbackData, nil);
end;

procedure TGdipGraphics.EnumerateMetafile(const metafile: TGdipMetafile; const destRect: TRectangle; const callback: TGdipEnumerateMetafileProc);
begin
   EnumerateMetafile(metafile, destRect, callback, nil);
end;

procedure TGdipGraphics.EnumerateMetafile(const metafile: TGdipMetafile; const destRect: TRectangle; const callback: TGdipEnumerateMetafileProc; const callbackData: Pointer);
begin
   EnumerateMetafile(metafile, destRect, callback, callbackData, nil);
end;

procedure TGdipGraphics.EnumerateMetafile(const metafile: TGdipMetafile; const destPoints: TArray<TPointF>; const callback: TGdipEnumerateMetafileProc);
begin
   EnumerateMetafile(metafile, destPoints, callback,  nil);
end;

procedure TGdipGraphics.EnumerateMetafile(const metafile: TGdipMetafile; const destPoints: TArray<TPointF>; const callback: TGdipEnumerateMetafileProc; const callbackData: Pointer);
begin
   EnumerateMetafile(metafile, destPoints, callback, nil,  nil)
end;

procedure TGdipGraphics.EnumerateMetafile(const metafile: TGdipMetafile; const destPoints: TArray<TPoint>; const callback: TGdipEnumerateMetafileProc);
begin
   EnumerateMetafile(metafile, destPoints, callback, nil)
end;

procedure TGdipGraphics.EnumerateMetafile(const metafile: TGdipMetafile; const destPoints: TArray<TPoint>; const callback: TGdipEnumerateMetafileProc; const callbackData: Pointer);
begin
   EnumerateMetafile(metafile, destPoints, callback, callbackData,  nil )
end;

procedure TGdipGraphics.EnumerateMetafile(const metafile: TGdipMetafile; const destPoint: TPointF; const srcRect: TRectangleF; const srcUnit: TGdipGraphicsUnit; const callback: TGdipEnumerateMetafileProc);
begin
   EnumerateMetafile(metafile, destPoint, srcRect, srcUnit, callback, nil)
end;

procedure TGdipGraphics.EnumerateMetafile(const metafile: TGdipMetafile; const destPoint: TPointF; const srcRect: TRectangleF; const srcUnit: TGdipGraphicsUnit; const callback: TGdipEnumerateMetafileProc; const callbackData: Pointer);
begin
   EnumerateMetafile(metafile, destPoint, srcRect, srcUnit, callback, callbackData,  nil )
end;

procedure TGdipGraphics.EnumerateMetafile(const metafile: TGdipMetafile; const destPoint: TPoint; const srcRect: TRectangle; const srcUnit: TGdipGraphicsUnit; const callback: TGdipEnumerateMetafileProc);
begin
   EnumerateMetafile(metafile, destPoint, srcRect, srcUnit, callback, nil)
end;

procedure TGdipGraphics.EnumerateMetafile(const metafile: TGdipMetafile; const destPoint: TPoint; const srcRect: TRectangle; const srcUnit: TGdipGraphicsUnit; const callback: TGdipEnumerateMetafileProc; const callbackData: Pointer);
begin
   EnumerateMetafile(metafile, destPoint, srcRect, srcUnit, callback, callbackData,  nil )
end;

procedure TGdipGraphics.EnumerateMetafile(const metafile: TGdipMetafile; const destRect: TRectangleF; const srcRect: TRectangleF; const srcUnit: TGdipGraphicsUnit; const callback: TGdipEnumerateMetafileProc);
begin
   EnumerateMetafile(metafile, destRect, srcRect, srcUnit, callback, nil)
end;

procedure TGdipGraphics.EnumerateMetafile(const metafile: TGdipMetafile; const destRect: TRectangleF; const srcRect: TRectangleF; const srcUnit: TGdipGraphicsUnit; const callback: TGdipEnumerateMetafileProc; const callbackData: Pointer);
begin
   EnumerateMetafile(metafile, destRect, srcRect, srcUnit, callback, callbackData,  nil )
end;

procedure TGdipGraphics.EnumerateMetafile(const metafile: TGdipMetafile; const destRect: TRectangle; const srcRect: TRectangle; const srcUnit: TGdipGraphicsUnit; const callback: TGdipEnumerateMetafileProc);
begin
   EnumerateMetafile(metafile, destRect, srcRect, srcUnit, callback, nil)
end;

procedure TGdipGraphics.EnumerateMetafile(const metafile: TGdipMetafile; const destRect: TRectangle; const srcRect: TRectangle; const srcUnit: TGdipGraphicsUnit; const callback: TGdipEnumerateMetafileProc; const callbackData: Pointer);
begin
   EnumerateMetafile(metafile, destRect, srcRect, srcUnit, callback, callbackData,  nil )
end;

procedure TGdipGraphics.EnumerateMetafile(const metafile: TGdipMetafile; const destPoints: TArray<TPointF>; const srcRect: TRectangleF; const srcUnit: TGdipGraphicsUnit; const callback: TGdipEnumerateMetafileProc);
begin
   EnumerateMetafile(metafile, destPoints, srcRect, srcUnit, callback, nil)
end;

procedure TGdipGraphics.EnumerateMetafile(const metafile: TGdipMetafile; const destPoints: TArray<TPointF>; const srcRect: TRectangleF; const srcUnit: TGdipGraphicsUnit; const callback: TGdipEnumerateMetafileProc; const callbackData: Pointer);
begin
   EnumerateMetafile(metafile, destPoints, srcRect, srcUnit, callback, callbackData,  nil )
end;

procedure TGdipGraphics.EnumerateMetafile(const metafile: TGdipMetafile; const destPoints: TArray<TPoint>; const srcRect: TRectangle; const srcUnit: TGdipGraphicsUnit; const callback: TGdipEnumerateMetafileProc);
begin
   EnumerateMetafile(metafile, destPoints, srcRect, srcUnit, callback, nil)
end;

procedure TGdipGraphics.EnumerateMetafile(const metafile: TGdipMetafile; const destPoints: TArray<TPoint>; const srcRect: TRectangle; const srcUnit: TGdipGraphicsUnit; const callback: TGdipEnumerateMetafileProc; const callbackData: Pointer);
begin
   EnumerateMetafile(metafile, destPoints, srcRect, srcUnit, callback, callbackData,  nil )
end;

procedure TGdipGraphics.TransformPoints(const destSpace: TGdipCoordinateSpace; const srcSpace: TGdipCoordinateSpace; const pts: TArray<TPointF>);
begin
   if pts = nil then
      raise EArgumentNullException.Create('pts');

   CheckStatus(TGdiplusAPI.GdipTransformPoints(NativeGraphics, TGdiplusAPI.TGdipCoordinateSpaceEnum(destSpace), TGdiplusAPI.TGdipCoordinateSpaceEnum(srcSpace), @pts[0], Length(pts)));
end;

procedure TGdipGraphics.TransformPoints(const destSpace: TGdipCoordinateSpace; const srcSpace: TGdipCoordinateSpace; const pts: TArray<TPoint>);
begin
   if pts = nil then
      raise EArgumentNullException.Create('pts');

   CheckStatus(TGdiplusAPI.GdipTransformPointsI(NativeGraphics, TGdiplusAPI.TGdipCoordinateSpaceEnum(destSpace), TGdiplusAPI.TGdipCoordinateSpaceEnum(srcSpace), @pts[0], Length(pts)));
end;

class procedure TGdipGraphics.IgnoreMetafileErrors(const image: TGdipImage; var errorStatus: TGdiplusAPI.TGdipStatusEnum);
begin
   if (errorStatus <> TGdiplusAPI.TGdipStatusEnum.Ok) and (image.RawFormat.Equals(TGdipImageFormat.Emf)) then
      errorStatus := TGdiplusAPI.TGdipStatusEnum.Ok;
end;

function TGdipGraphics.GetRegionIfNotInfinite(): TGdipRegion;
begin
   var regionHandle: TGdiplusAPI.TGdipRegionPtr;
   CheckStatus(TGdiplusAPI.GdipCreateRegion(regionHandle));

   try
      var isInfinite: LongBool;
      TGdiplusAPI.GdipGetClip(NativeGraphics, regionHandle);
      CheckStatus(TGdiplusAPI.GdipIsInfiniteRegion(regionHandle, NativeGraphics, isInfinite));

      if (isInfinite) then
      begin

         Exit(nil);
      end;

      var region: TGdipRegion := TGdipRegion.Create(regionHandle);
      regionHandle := nil;

      Exit(region);
   finally
      if (regionHandle <> nil) then
      begin
         TGdiplusAPI.GdipDeleteRegion(regionHandle);
      end;
   end;
end;

procedure TGdipGraphics.CopyFromScreen(const sourceX: Integer; const sourceY: Integer; const destinationX: Integer; const destinationY: Integer; const blockRegionSize: TSize; const copyPixelOperation: TGdipCopyPixelOperation);
begin
   case (copyPixelOperation) of
      TGdipCopyPixelOperation.Blackness,
      TGdipCopyPixelOperation.NotSourceErase,
      TGdipCopyPixelOperation.NotSourceCopy,
      TGdipCopyPixelOperation.SourceErase,
      TGdipCopyPixelOperation.DestinationInvert,
      TGdipCopyPixelOperation.PatInvert,
      TGdipCopyPixelOperation.SourceInvert,
      TGdipCopyPixelOperation.SourceAnd,
      TGdipCopyPixelOperation.MergePaint,
      TGdipCopyPixelOperation.MergeCopy,
      TGdipCopyPixelOperation.SourceCopy,
      TGdipCopyPixelOperation.SourcePaint,
      TGdipCopyPixelOperation.PatCopy,
      TGdipCopyPixelOperation.PatPaint,
      TGdipCopyPixelOperation.Whiteness,
      TGdipCopyPixelOperation.CaptureBlt,
      TGdipCopyPixelOperation.NoMirrorBitmap:
      begin
      end;
   else
      raise EArgumentException.Create('''copyPixelOperation'', Integer(copyPixelOperation), TypeInfo(TGdipCopyPixelOperation)');
   end;

   var destWidth: Integer := blockRegionSize.Width;
   var destHeight: Integer := blockRegionSize.Height;
   var screenDC := TGdipGetDcScope.ScreenDC;
   if (screenDC = 0) then
   begin
      // ERROR_INVALID_HANDLE - if you pass an empty handle to BitBlt you'll get this error.
      // Checking here to better describe test failures (and avoids taking the TGdipGraphics HDC lock).
      raise EOSError.Create('6');
   end;

   var targetDC: HDC := HDC(GetHdc());

   try
      begin
         var _result: LongBool := PInvokeCore.BitBlt(targetDC, destinationX, destinationY, destWidth, destHeight, screenDC, sourceX, sourceY, ROP_CODE(copyPixelOperation));

         if (not _result) then
         begin
            raise EOSError.Create();
         end;
      end;
   finally
      begin
         if (not (targetDC = 0)) then
         begin
            ReleaseHdc();
         end;
      end;
   end;

end;

function TGdipGraphics.GetNearestColor(const color: TGdipColor): TGdipColor;
begin
   var nearest: UInt32 := UInt32(color.ToArgb());
   CheckStatus(TGdiplusAPI.GdipGetNearestColor(NativeGraphics, @nearest));

   Exit(TGdipColor.FromArgb(Integer(nearest)));
end;

procedure TGdipGraphics.DrawLine(const pen: TGdipPen; const x1: Single; const y1: Single; const x2: Single; const y2: Single);
begin
   if pen = nil then
      raise EArgumentNullException.Create('pen');

   CheckErrorStatus(TGdiplusAPI.GdipDrawLine(NativeGraphics, pen.NativePen, x1, y1, x2, y2));
end;

procedure TGdipGraphics.DrawBeziers(const pen: TGdipPen; const points: TArray<TPointF>);
begin
   if points = nil then
      raise EArgumentNullException.Create('points');

   DrawBeziers(pen, TReadOnlySpan<TPointF>(points));
end;

procedure TGdipGraphics.DrawBeziers(const pen: TGdipPen; const points: TReadOnlySpan<TPointF>);
begin
   if pen = nil then
      raise EArgumentNullException.Create('pen');

   CheckErrorStatus(TGdiplusAPI.GdipDrawBeziers(NativeGraphics, pen.NativePen, PPointF(points.GetPinnableReference), points.Length));
end;

procedure TGdipGraphics.DrawBeziers(const pen: TGdipPen; const points: TArray<TPoint>);
begin
   if points = nil then
      raise EArgumentNullException.Create('points');

   DrawBeziers(pen, TReadOnlySpan<TPoint>(points));
end;

procedure TGdipGraphics.DrawBeziers(const pen: TGdipPen; const points: TReadOnlySpan<TPoint>);
begin
   if pen = nil then
      raise EArgumentNullException.Create('pen');

   CheckErrorStatus(TGdiplusAPI.GdipDrawBeziersI(NativeGraphics, pen.NativePen, PPoint(points.GetPinnableReference), points.Length));
end;

procedure TGdipGraphics.FillPath(const brush: TGdipBrush; const path: TGdipGraphicsPath);
begin
   if brush = nil then
      raise EArgumentNullException.Create('brush');
   if path = nil then
      raise EArgumentNullException.Create('path');

   CheckErrorStatus(TGdiplusAPI.GdipFillPath(NativeGraphics, brush.NativeBrush, path._nativePath));
end;

procedure TGdipGraphics.FillRegion(const brush: TGdipBrush; const region: TGdipRegion);
begin
   if brush = nil then
      raise EArgumentNullException.Create('brush');
   if region = nil then
      raise EArgumentNullException.Create('region');

   CheckErrorStatus(TGdiplusAPI.GdipFillRegion(NativeGraphics, brush.NativeBrush, region.NativeRegion));
end;

procedure TGdipGraphics.DrawIcon(const icon: TGdipIcon; const x: Integer; const y: Integer);
begin
   if icon = nil then
      raise EArgumentNullException.Create('icon');

   if (_backingImage <> nil) then
   begin
      DrawImage(icon.ToBitmap(), x, y);
   end
   else
   begin
      icon.Draw(Self, x, y);
   end;
end;

procedure TGdipGraphics.DrawIcon(const icon: TGdipIcon; const targetRect: TRectangle);
begin
   if icon = nil then
      raise EArgumentNullException.Create('icon');

   if (_backingImage <> nil) then
   begin
      DrawImage(icon.ToBitmap(), targetRect);
   end
   else
   begin
      icon.Draw(Self, targetRect);
   end;
end;

procedure TGdipGraphics.DrawIconUnstretched(const icon: TGdipIcon; const targetRect: TRectangle);
begin
   if icon = nil then
      raise EArgumentNullException.Create('icon');

   if (_backingImage <> nil) then
   begin
      DrawImageUnscaled(icon.ToBitmap(), targetRect);
   end
   else
   begin
      icon.DrawUnstretched(Self, targetRect);
   end;
end;

procedure TGdipGraphics.EnumerateMetafile(const metafile: TGdipMetafile; const destPoint: TPointF; const callback: TGdipEnumerateMetafileProc; const callbackData: Pointer; const imageAttr: TGdipImageAttributes);
begin
   raise ENotImplemented.Create('Ainda não fiz isso aqui! TODO:');
//   var adapter: TGdipEnumerateMetafileDataAdapter := TGdipEnumerateMetafileDataAdapter.Create(callback);
//   TGdiplusAPI.GdipEnumerateMetafileDestPoint(NativeGraphics, metafile.Pointer(), @destPoint, adapter.NativeCallback, Pointer(callbackData), imageAttr.Pointer).ThrowIfFailed();
end;

procedure TGdipGraphics.EnumerateMetafile(const metafile: TGdipMetafile; const destPoint: TPoint; const callback: TGdipEnumerateMetafileProc; const callbackData: Pointer; const imageAttr: TGdipImageAttributes);
begin
   EnumerateMetafile(metafile, TPointF(destPoint), callback, callbackData, imageAttr)
end;

procedure TGdipGraphics.EnumerateMetafile(const metafile: TGdipMetafile; const destRect: TRectangleF; const callback: TGdipEnumerateMetafileProc; const callbackData: Pointer; const imageAttr: TGdipImageAttributes);
begin
   raise ENotImplemented.Create('Ainda não fiz isso aqui! TODO:');
//   var adapter: TEnumerateMetafileDataAdapter := TEnumerateMetafileDataAdapterTEnumerateMetafileDataAdapter.Create(callback);
//   PInvoke.GdipEnumerateMetafileDestRect(NativeGraphics, metafile.Pointer(), PTRectF(@destRect), adapter.NativeCallback, Pointer(callbackData), imageAttr.Pointer()).ThrowIfFailed();
end;

procedure TGdipGraphics.EnumerateMetafile(const metafile: TGdipMetafile; const destRect: TRectangle; const callback: TGdipEnumerateMetafileProc; const callbackData: Pointer; const imageAttr: TGdipImageAttributes);
begin
   EnumerateMetafile(metafile, TRectangleF(destRect), callback, callbackData, imageAttr)
end;

procedure TGdipGraphics.EnumerateMetafile(const metafile: TGdipMetafile; const destPoints: TArray<TPointF>; const callback: TGdipEnumerateMetafileProc; const callbackData: Pointer; const imageAttr: TGdipImageAttributes);
begin
   raise ENotImplemented.Create('Ainda não fiz isso aqui! TODO:');
//   ArgumentNullException.ThrowIfNull(destPoints);
//
//   if (destPoints.Length <> 3) then
//      raise EArgumentException.Create(SR.GdiplusDestPointsInvalidParallelogram);
//   var p: PTPointF := destPoints;
//   begin
//      var adapter: TEnumerateMetafileDataAdapter := TEnumerateMetafileDataAdapterTEnumerateMetafileDataAdapter.Create(callback);
//      PInvoke.GdipEnumerateMetafileDestPoints(NativeGraphics, metafile.Pointer(), PTGdiPlusAPI.TTPointF(p), destPoints.Length, adapter.NativeCallback, Pointer(callbackData), imageAttr.Pointer()).ThrowIfFailed();
//
//   end;
end;

procedure TGdipGraphics.EnumerateMetafile(const metafile: TGdipMetafile; const destPoints: TArray<TPoint>; const callback: TGdipEnumerateMetafileProc; const callbackData: Pointer; const imageAttr: TGdipImageAttributes);
begin
   raise ENotImplemented.Create('Ainda não fiz isso aqui! TODO:');
//   ArgumentNullException.ThrowIfNull(destPoints);
//
//   if (destPoints.Length <> 3) then
//      raise EArgumentException.Create(SR.GdiplusDestPointsInvalidParallelogram);
//   var p: PTPoint := destPoints;begin
//      var adapter: TEnumerateMetafileDataAdapter := TEnumerateMetafileDataAdapterTEnumerateMetafileDataAdapter.Create(callback);
//      PInvoke.GdipEnumerateMetafileDestPointsI(NativeGraphics, metafile.Pointer(), PTGdiPlusAPI.TTPoint(p), destPoints.Length, adapter.NativeCallback, Pointer(callbackData), imageAttr.Pointer()).ThrowIfFailed();
//
//      GC.KeepAlive(imageAttr);
//      GC.KeepAlive(metafile);
//
//   end;
end;

procedure TGdipGraphics.EnumerateMetafile(const metafile: TGdipMetafile; const destPoint: TPointF; const srcRect: TRectangleF; const unit_: TGdipGraphicsUnit; const callback: TGdipEnumerateMetafileProc; const callbackData: Pointer; const imageAttr: TGdipImageAttributes);
begin
   raise ENotImplemented.Create('Ainda não fiz isso aqui! TODO:');
//   var adapter: TEnumerateMetafileDataAdapter := TEnumerateMetafileDataAdapterTEnumerateMetafileDataAdapter.Create(callback);
//   PInvoke.GdipEnumerateMetafileSrcRectDestPoint(NativeGraphics, metafile.Pointer(), PTGdiPlusAPI.TTPointF(@destPoint), PTRectF(@srcRect), TUnit(unit_), adapter.NativeCallback, Pointer(callbackData), imageAttr.Pointer()).ThrowIfFailed();
//
//   GC.KeepAlive(imageAttr);
//   GC.KeepAlive(metafile);
//
end;

procedure TGdipGraphics.EnumerateMetafile(const metafile: TGdipMetafile; const destPoint: TPoint; const srcRect: TRectangle; const unit_: TGdipGraphicsUnit; const callback: TGdipEnumerateMetafileProc; const callbackData: Pointer; const imageAttr: TGdipImageAttributes);
begin
   raise ENotImplemented.Create('Ainda não fiz isso aqui! TODO:');
//   EnumerateMetafile(metafile, TPointF(destPoint), TRectangleF(srcRect), unit, callback, callbackData, imageAttr)
end;

procedure TGdipGraphics.EnumerateMetafile(const metafile: TGdipMetafile; const destRect: TRectangleF; const srcRect: TRectangleF; const unit_: TGdipGraphicsUnit; const callback: TGdipEnumerateMetafileProc; const callbackData: Pointer; const imageAttr: TGdipImageAttributes);
begin
   raise ENotImplemented.Create('Ainda não fiz isso aqui! TODO:');
//   var adapter: TEnumerateMetafileDataAdapter := TEnumerateMetafileDataAdapterTEnumerateMetafileDataAdapter.Create(callback);
//   PInvoke.GdipEnumerateMetafileSrcRectDestRect(NativeGraphics, metafile.Pointer(), PTRectF(@destRect), PTRectF(@srcRect), TUnit(unit_), adapter.NativeCallback, Pointer(callbackData), imageAttr.Pointer()).ThrowIfFailed();
//
//   GC.KeepAlive(imageAttr);
//   GC.KeepAlive(metafile);
//
end;

procedure TGdipGraphics.EnumerateMetafile(const metafile: TGdipMetafile; const destRect: TRectangle; const srcRect: TRectangle; const unit_: TGdipGraphicsUnit; const callback: TGdipEnumerateMetafileProc; const callbackData: Pointer; const imageAttr: TGdipImageAttributes);
begin
   raise ENotImplemented.Create('Ainda não fiz isso aqui! TODO:');
//   EnumerateMetafile(metafile, TRectangleF(destRect), srcRect, unit, callback, callbackData, imageAttr)
end;

procedure TGdipGraphics.EnumerateMetafile(const metafile: TGdipMetafile; const destPoints: TArray<TPointF>; const srcRect: TRectangleF; const unit_: TGdipGraphicsUnit; const callback: TGdipEnumerateMetafileProc; const callbackData: Pointer; const imageAttr: TGdipImageAttributes);
begin
   raise ENotImplemented.Create('Ainda não fiz isso aqui! TODO:');
//   ArgumentNullException.ThrowIfNull(destPoints);
//
//   if (destPoints.Length <> 3) then
//      raise EArgumentException.Create(SR.GdiplusDestPointsInvalidParallelogram);
//   var p: PTPointF := destPoints;begin
//      var adapter: TEnumerateMetafileDataAdapter := TEnumerateMetafileDataAdapterTEnumerateMetafileDataAdapter.Create(callback);
//      PInvoke.GdipEnumerateMetafileSrcRectDestPoints(NativeGraphics, metafile.Pointer(), PTGdiPlusAPI.TTPointF(p), destPoints.Length, PTRectF(@srcRect), TUnit(unit_), adapter.NativeCallback, Pointer(callbackData), imageAttr.Pointer()).ThrowIfFailed();
//
//      GC.KeepAlive(imageAttr);
//      GC.KeepAlive(metafile);
//
//   end;
end;

procedure TGdipGraphics.EnumerateMetafile(const metafile: TGdipMetafile; const destPoints: TArray<TPoint>; const srcRect: TRectangle; const unit_: TGdipGraphicsUnit; const callback: TGdipEnumerateMetafileProc; const callbackData: Pointer; const imageAttr: TGdipImageAttributes);
begin
   raise ENotImplemented.Create('Ainda não fiz isso aqui! TODO:');
//   ArgumentNullException.ThrowIfNull(destPoints);
//
//   if (destPoints.Length <> 3) then
//      raise EArgumentException.Create(SR.GdiplusDestPointsInvalidParallelogram);
//   var p: PTPoint := destPoints;begin
//      var adapter: TEnumerateMetafileDataAdapter := TEnumerateMetafileDataAdapterTEnumerateMetafileDataAdapter.Create(callback);
//      PInvoke.GdipEnumerateMetafileSrcRectDestPointsI(NativeGraphics, metafile.Pointer(), PTGdiPlusAPI.TTPoint(p), destPoints.Length, PTRect(@srcRect), TUnit(unit_), adapter.NativeCallback, Pointer(callbackData), imageAttr.Pointer()).ThrowIfFailed();
//
//      GC.KeepAlive(imageAttr);
//      GC.KeepAlive(metafile);
//
//   end;
end;

function TGdipGraphics.GetContextInfo(): TArray<TObject>;
begin
   var cumulativeTransform: TMatrix3x2;
   var cumulativeClip: TGdipRegion;
   GetContextInfo(cumulativeTransform, True, cumulativeClip);

   if cumulativeClip = nil then
      cumulativeClip := TGdipRegion.Create();

   SetLength(Result, 2);
   Result[0] := cumulativeClip;
   Result[1] := TGdipMatrix.Create(cumulativeTransform);
end;

procedure TGdipGraphics.GetContextInfo(out cumulativeTransform: TMatrix3x2; const calculateClip: Boolean; out cumulativeClip: TGdipRegion);
begin

   if (calculateClip) then
      cumulativeClip := GetRegionIfNotInfinite()
   else
      cumulativeClip := nil;
      // Current context clip.
   cumulativeTransform := TransformElements;                            // Current context transform.
   var currentOffset: TVector2 := Default(TVector2);// Offset of current context.
   var totalOffset: TVector2 := Default(TVector2);// Absolute coordinate offset of top context.

   var context: TGdipGraphicsContext := _previousContext;

   if (not cumulativeTransform.IsIdentity) then
   begin
      currentOffset := cumulativeTransform.Translation;
   end;

   while (context <> nil) do
   begin
      begin
         if (not context.TransformOffset.IsEmpty()) then
         begin
            cumulativeTransform.Translate(context.TransformOffset);
         end;

         if (not currentOffset.IsEmpty()) then
         begin
            if Assigned(cumulativeClip) then
               cumulativeClip.Translate(currentOffset.X, currentOffset.Y);
            totalOffset.X := totalOffset.X + currentOffset.X;
            totalOffset.Y := totalOffset.Y + currentOffset.Y;
         end;

         // Context only stores clips if they are not infinite. Intersecting a clip with an infinite clip is a no-op.
         if (calculateClip) and (context.Clip <> nil) then
         begin
            // Intersecting an infinite clip with another is just a copy of the second clip.
            if (cumulativeClip = nil) then
            begin
               cumulativeClip := context.Clip;
            end
            else
            begin
               cumulativeClip.Intersect(context.Clip);
            end;
         end;

         currentOffset := context.TransformOffset;

         repeat
            context := context.Previous;

            if (context = nil) or (not context.Next.IsCumulative) then
            begin
               Break;
            end;
         until not (context.IsCumulative);
      end;

   end;

   if (not totalOffset.IsEmpty()) then
   begin
      if Assigned(cumulativeClip) then
         cumulativeClip.Translate(-totalOffset.X, -totalOffset.Y);
   end;
end;

function TGdipGraphics.GetHdc(const apply: TGdipApplyGraphicsProperties; const alwaysSaveState: Boolean): TGdiDeviceContextSaveState;
begin
   var applyTransform: Boolean := apply.HasFlag(TGdipApplyGraphicsProperties.TranslateTransform);
   var applyClipping: Boolean := apply.HasFlag(TGdipApplyGraphicsProperties.Clipping);

   var saveState: Integer := 0;
   var hdc: TDeviceContextHandle;

   var clipRegion: TGdipRegion := nil;
   var offset: TPointF := Default(TPointF);
   if (applyClipping) then
   begin
      GetContextInfo(offset, clipRegion);
   end
   else if (applyTransform) then
   begin
      GetContextInfo(offset);
   end;
   var StmtUsingExpForFree := clipRegion;
   try
      begin
         applyTransform := applyTransform and not offset.IsEmpty;
         applyClipping := clipRegion <> nil;

         var graphicsRegion: TGdipRegionScope;

         if applyClipping then
            graphicsRegion := TGdipRegionScope.Create(clipRegion, Self)
         else
            graphicsRegion := default(TGdipRegionScope);

         applyClipping := applyClipping and not (graphicsRegion.Region = 0);

         hdc := TDeviceContextHandle(GetHdc());

         if (alwaysSaveState) or (applyClipping) or (applyTransform) then
         begin
            saveState := PInvokeCore.SaveDC(hdc);
         end;

         if (applyClipping) then
         begin
            // If the TGdipGraphics object was created from a native DC the actual clipping region is the intersection
            // between the original DC clip region and the GDI+ one - for display TGdipGraphics it is the same as
            // TGdipGraphics.VisibleClipBounds.

            var type_: GDI_REGION_TYPE;
            var dcRegion: TGdipRegionScope := TGdipRegionScope.Create(hdc);
            if (not dcRegion.IsNull) then
            begin
               type_ := PInvokeCore.CombineRgn(graphicsRegion, dcRegion, graphicsRegion, RGN_COMBINE_MODE.RGN_AND);
               if (type_ = GDI_REGION_TYPE.RGN_ERROR) then
               begin
                  raise EOSError.Create();
               end;
            end;

            type_ := PInvokeCore.SelectClipRgn(hdc, graphicsRegion);
            if (type_ = GDI_REGION_TYPE.RGN_ERROR) then
            begin
               raise EOSError.Create();
            end;
         end;

         if (applyTransform) then
         begin
            PInvokeCore.OffsetViewportOrgEx(hdc, Trunc(offset.X), Trunc(offset.Y),  nil);
         end;
      end;
   finally
      FreeAndNil(StmtUsingExpForFree);
   end;

   Result := TGdiDeviceContextSaveState.Create(hdc, saveState);
end;

procedure TGdipGraphics.GetContextInfo(out offset: TPointF);
begin
   var cumulativeTransform: TMatrix3x2;
   var clip: TGdipRegion := nil;
   GetContextInfo(cumulativeTransform,  False, clip);
   var translation: TVector2 := cumulativeTransform.Translation;
   offset := TPointF.Create(translation.X, translation.Y);
end;

procedure TGdipGraphics.GetContextInfo(out offset: TPointF; out clip: TGdipRegion);
begin
   var cumulativeTransform: TMatrix3x2;
   GetContextInfo(cumulativeTransform,  True, clip);
   var translation: TVector2 := cumulativeTransform.Translation;
   offset := TPointF.Create(translation.X, translation.Y);
end;

procedure TGdipGraphics.PushContext(context: TGdipGraphicsContext);
begin
   Assert((context <> nil) and (context.State <> 0), 'TGdipGraphicsContext object is null or not valid.');

   if (_previousContext <> nil) then
   begin
      // Push context.
      context.Previous := _previousContext;
      _previousContext.Next := context;
   end;

   _previousContext := context;
end;

procedure TGdipGraphics.PopContext(const currentContextState: UInt32);
begin
   Assert(_previousContext <> nil, 'Trying to restore a context when the stack is empty');
   var context: TGdipGraphicsContext := _previousContext;

   while (context <> nil) do
   begin
      begin
         if (context.State = currentContextState) then
         begin
            _previousContext := context.Previous;

            // This will dispose all context object up the stack.
            context.Free();

            Exit();
         end;

         context := context.Previous;
      end;

   end;

   Assert(False, 'Warning: context state not found!');
end;

function TGdipGraphics.Save(): TGdipGraphicsState;
begin
   var context: TGdipGraphicsContext := TGdipGraphicsContext.Create(Self);
   var state: UInt32;
   var status: TGdiplusAPI.TGdipStatusEnum := TGdiplusAPI.GdipSaveGraphics(NativeGraphics, state);

   if (status <> TGdiplusAPI.TGdipStatusEnum.Ok) then
   begin
      context.Dispose();
      raise TGdip.StatusException(status);
   end;


   context.State := state;
   context.IsCumulative := true;
   PushContext(context);

   Exit(state);
end;

procedure TGdipGraphics.Restore(const gstate: TGdipGraphicsState);
begin
   CheckStatus(TGdiplusAPI.GdipRestoreGraphics(NativeGraphics, gstate));
   PopContext(gstate);
end;

function TGdipGraphics.BeginContainer(const dstrect: TRectangleF; const srcrect: TRectangleF; const unit_: TGdipGraphicsUnit): TGdipGraphicsContainer;
begin
   var context: TGdipGraphicsContext := TGdipGraphicsContext.Create(Self);

   var state: UInt32;
   var status: TGdiplusAPI.TGdipStatusEnum := TGdiplusAPI.GdipBeginContainer(NativeGraphics, @dstrect, @srcrect, TGdiplusAPI.TGdipUnitEnum(unit_), @state);

   if (status <> TGdiplusAPI.TGdipStatusEnum.Ok) then
   begin
      context.Dispose();
      raise TGdip.StatusException(status);
   end;


   context.State := state;
   PushContext(context);

   Result := state;
end;

function TGdipGraphics.BeginContainer(): TGdipGraphicsContainer;
begin
   var context: TGdipGraphicsContext := TGdipGraphicsContext.Create(Self);
   var state: UInt32;
   var status: TGdiplusAPI.TGdipStatusEnum := TGdiplusAPI.GdipBeginContainer2(NativeGraphics, state);

   if (status <> TGdiplusAPI.TGdipStatusEnum.Ok) then
   begin
      context.Dispose();
      raise TGdip.StatusException(status);
   end;


   context.State := state;
   PushContext(context);

   Exit(state);
end;

procedure TGdipGraphics.EndContainer(container: TGdipGraphicsContainer);
begin
   if container <= 0 then
      raise EArgumentNullException.Create('container');

   CheckStatus(TGdiplusAPI.GdipEndContainer(NativeGraphics, container));
   PopContext(container);
end;

function TGdipGraphics.BeginContainer(const dstrect: TRectangle; const srcrect: TRectangle; const unit_: TGdipGraphicsUnit): TGdipGraphicsContainer;
begin
   Result := BeginContainer(TRectangleF(dstrect), TRectangleF(srcrect), unit_)
end;

procedure TGdipGraphics.AddMetafileComment(const data: TArray<Byte>);
begin
   if data = nil then
      raise EArgumentNullException.Create('data');

   var b: PByte := @data[0];
   begin
      CheckStatus(TGdiplusAPI.GdipComment(NativeGraphics, UInt32(Length(data)), b));
   end;
end;

class function TGdipGraphics.GetHalftonePalette(): HPALETTE;
begin
   if (s_halftonePalette = 0) then
   begin

      //   System.TMonitor.Enter(s_syncObject);
         try
            begin
               if (s_halftonePalette = 0) then
               begin
//                  AppDomain.CurrentDomain.DomainUnload := AppDomain.CurrentDomain.DomainUnload + OnDomainUnload;
//                  AppDomain.CurrentDomain.ProcessExit := AppDomain.CurrentDomain.ProcessExit + OnDomainUnload;

                  s_halftonePalette := TGdiplusAPI.GdipCreateHalftonePalette();
               end;
            end;
         finally
        //    TMonitor.Exit(s_syncObject);
         end;

   end;

   Exit(s_halftonePalette);
end;

//class procedure TGdipGraphics.OnDomainUnload(const sender: TObject; const e: TEventArgs);
//begin
//   if not (s_halftonePalette = 0) then
//   begin
//      PInvokeCore.DeleteObject(s_halftonePalette);
//      s_halftonePalette := 0;
//   end;
//end;

procedure TGdipGraphics.CheckErrorStatus(const status: TGdiplusAPI.TGdipStatusEnum);
begin
   if (status = TGdiplusAPI.TGdipStatusEnum.Ok) then
   begin
      Exit();
   end;

   // Generic error from GDI+ can be GenericError or Win32Error.
   if (status = TGdiplusAPI.TGdipStatusEnum.GenericError) or (status = TGdiplusAPI.TGdipStatusEnum.Win32Error) then
   begin
      var error: WIN32_ERROR := GetLastError();
      if (error = WIN32_ERROR.ERROR_ACCESS_DENIED) or (error = WIN32_ERROR.ERROR_PROC_NOT_FOUND) or ((((PInvokeCore.GetSystemMetrics(SYSTEM_METRICS_INDEX.SM_REMOTESESSION) and $00000001) <> 0)) and ((error = 0))) then
      begin
         Exit();
      end;
   end;

   // Legitimate error, throw our status exception.
   raise TGdip.StatusException(status);
end;

procedure TGdipGraphics.DrawCachedBitmap(const cachedBitmap: TGdipCachedBitmap; const x: Integer; const y: Integer);
begin
   if cachedBitmap = nil then
      raise EArgumentNullException.Create('cachedBitmap');

   CheckStatus(TGdiplusAPI.GdipDrawCachedBitmap(NativeGraphics, TGdiplusAPI.TGdipCachedBitmapPtr(cachedBitmap.Handle), x, y));
end;

procedure TGdipGraphics.DrawImage(const image: TGdipImage; const effect: TGdipEffect);
begin
   DrawImage(image, effect, default(TRectangleF), default(TGdipMatrix), TGdipGraphicsUnit.Pixel,  nil )
end;

procedure TGdipGraphics.DrawImage(const image: TGdipImage; const effect: TGdipEffect; const srcRect: TRectangleF; const transform: TGdipMatrix = default(TGdipMatrix); const srcUnit: TGdipGraphicsUnit = TGdipGraphicsUnit.Pixel; const imageAttr: TGdipImageAttributes = default(TGdipImageAttributes));
begin
   TGdiplusAPI.GdipDrawImageFX(NativeGraphics, image.Pointer, TLogicalUtils.IfElse(srcRect.IsEmpty, nil, @srcRect), transform.NativeMatrix, effect.NativeEffect, imageAttr._nativeImageAttributes, TGdiplusAPI.TGdipUnitEnum(srcUnit)).ThrowIfFailed();
end;

procedure TGdipGraphics.CheckStatus(const status: TGdiplusAPI.TGdipStatusEnum);
begin
   status.ThrowIfFailed();
end;

{$ENDREGION 'TGdipGraphics'}

{$REGION 'TGdipCachedBitmap'}

{ TGdipCachedBitmap }

function TGdipCachedBitmap.GetHandle(): NativeInt;
begin
   Result := _handle;
end;

constructor TGdipCachedBitmap.Create(const bitmap: TGdipBitmap; const graphics: TGdipGraphics);
begin
   if bitmap = nil then
      raise EArgumentNullException.Create('bitmap');

   if graphics = nil then
      raise EArgumentNullException.Create('graphics');

   var cachedBitmap: TGdiplusAPI.TGdipCachedBitmapPtr;
   TGdiplusAPI.GdipCreateCachedBitmap(bitmap.Pointer, graphics.Pointer, cachedBitmap);
   _handle := NativeInt(cachedBitmap);
end;

destructor TGdipCachedBitmap.Destroy();
begin
   Dispose(True);
   inherited Destroy();
end;

procedure TGdipCachedBitmap.Dispose(const disposing: Boolean);
begin
   var handle: NativeInt := AtomicExchange(_handle, 0);
   if (handle = 0) then
   begin

      Exit();
   end;

   var status: TGdiplusAPI.TGdipStatusEnum := TGdiplusAPI.GdipDeleteCachedBitmap(TGdiplusAPI.TGdipCachedBitmapPtr(handle));
   if (disposing) then
   begin
      // Don't want to throw on the finalizer thread.
      TGdip.CheckStatus(status);
   end;
end;

procedure TGdipCachedBitmap.Dispose();
begin
   Dispose( True );
end;

{$ENDREGION 'TGdipCachedBitmap'}

{$REGION 'TGdipIcon'}

{ TGdipIcon }

procedure TGdipIcon.AfterConstruction;
begin
   inherited;
{$IFDEF FINALIZATION_WATCH}
   m_allocationSite := TGdipGraphics.GetAllocationStack();
{$ENDIF FINALIZATION_WATCH}

   m_iconSize := TSize.Empty;

   _ownHandle := true;
end;

procedure TGdipIcon.BeforeDestruction;
begin
   inherited;
end;

function TGdipIcon.GetHandle(): HICON;
begin
   if _handle = 0 then
      raise EObjectDisposed.Create(ClassName);

   Result := _handle;
end;

function TGdipIcon.GetHeight(): Integer;
begin
   Result := Size.Height;
end;

function TGdipIcon.GetSize(): TSize;
begin
   if (not m_iconSize.IsEmpty) then
   begin
      Exit(m_iconSize);
   end;

   var info: TIconInfo := Default(TIconInfo);
   GetIconInfo(Self.Handle, info);
   var bitmap: Winapi.Windows.TBitmap := Default(Winapi.Windows.TBitmap);

   if not (info.hbmColor = 0) then
   begin
      Winapi.Windows.GetObject(info.hbmColor, SizeOf(Winapi.Windows.TBitmap), @bitmap);
      Winapi.Windows.DeleteObject(info.hbmColor);
      m_iconSize := TSize.Create(bitmap.bmWidth, bitmap.bmHeight);
   end
   else
   begin
      if not (info.hbmMask = 0) then
      begin
         Winapi.Windows.GetObject(info.hbmMask, SizeOf(Winapi.Windows.TBitmap), @bitmap);
         m_iconSize := TSize.Create(bitmap.bmWidth, bitmap.bmHeight / 2);
      end;
   end;

   if not (info.hbmMask = 0) then
   begin
      Winapi.Windows.DeleteObject(info.hbmMask);
   end;

   Exit(m_iconSize);
end;

function TGdipIcon.GetWidth(): Integer;
begin
   Result := Size.Width;
end;

constructor TGdipIcon.Create(const handle: HICON);
begin
   Create(handle,  False );
end;

constructor TGdipIcon.Create(const handle: HICON; const takeOwnership: Boolean);
begin
   if (handle = 0) then
   begin
      raise EArgumentException.Create('SR.Format(SR.InvalidGDIHandle, nameof(TGdipIcon))');
   end;

   _handle := handle;
   _ownHandle := takeOwnership;
end;

constructor TGdipIcon.Create(const fileName: string);
begin
   Create(fileName, 0, 0);


end;

constructor TGdipIcon.Create(const fileName: string; const size: TSize);
begin
   Create(fileName, size.Width, size.Height);


end;

constructor TGdipIcon.Create(const fileName: string; const width: Integer; const height: Integer);
begin
   Create();


   var f: TFileStream := TFileStream.Create(fileName, fmOpenRead or fmShareDenyWrite);
   try
      Assert(f <> nil, 'File.OpenRead returned null instead of throwing an exception');
      SetLength(_iconData, integer(f.Size));
      f.Read(_iconData, 0, Length(_iconData));
   finally
      if Assigned(f) then
         FreeAndNil(f);
   end;


   Initialize(width, height);

end;

constructor TGdipIcon.Create(const original: TGdipIcon; const size: TSize);
begin
   Create(original, size.Width, size.Height);
end;

constructor TGdipIcon.Create(const original: TGdipIcon; const width: Integer; const height: Integer);
begin
   Create();

   if original = nil then
      raise EArgumentNullException.Create('original');

   _iconData := original._iconData;

   if (_iconData = nil) then
   begin
      m_iconSize := original.Size;
      _handle := PInvokeCore.CopyIcon(original.Handle, m_iconSize.Width, m_iconSize.Height);
   end
   else
   begin


         Initialize(width, height);
   end;

end;

//constructor TGdipIcon.Create(const type_: TRttiType; const resource: string);
//begin
//   if string.IsNullOrWhiteSpace(resource) then
//      raise EArgumentNullException.Create('resource');
//
//   Create();
//
//   var stream: TStream := type.Module.Assembly.GetManifestResourceStream(type, resource)
//            ?? throw new ArgumentException(SR.Format(SR.ResourceNotFound, type, resource));
//
//
//   SetLength(_iconData, (int)stream.Length);
//
//   stream.Read(_iconData, 0, _iconData.Length);
//
//   Initialize(0, 0);
//
//end;

constructor TGdipIcon.Create(const stream: TStream);
begin
   Create(stream, 0, 0);


end;

constructor TGdipIcon.Create(const stream: TStream; const size: TSize);
begin
   Create(stream, size.Width, size.Height);


end;

constructor TGdipIcon.Create(const stream: TStream; const width: Integer; const height: Integer);
begin
   if stream = nil then
      raise EArgumentNullException.Create('stream');

   Create();
   SetLength(_iconData, Int32(stream.Length));

   stream.ReadExactly(_iconData);

   Initialize(width, height);

end;

//constructor TGdipIcon.Create(const info: TSerializationInfo; const context: TStreamingContext);
//begin
//   // Do not rename value names or change types (binary serialization)
//
//   _iconData := TArray<Byte>(info.GetValue("IconData", typeof(byte[])));
//
//   m_iconSize := TSize(info.GetValue("IconSize", typeof(TSize)));
//
//   Initialize(m_iconSize.Width, m_iconSize.Height);
//
//end;

destructor TGdipIcon.Destroy();
begin
   Dispose(True);
   inherited Destroy();
end;

//procedure TGdipIcon.GetObjectData(const si: TSerializationInfo; const context: TStreamingContext);
//begin
//   // Do not rename value names or change types (binary serialization)
//
//
//   if (_iconData <> nil) then
//   begin
//
//
//         si.AddValue('IconData', _iconData, TypeInfo(TArray<Byte>));
//   end
//   else
//   begin
//
//
//
//         var stream: TMemoryStream := TMemoryStreamTMemoryStream.Create();
//
//         Save(stream);
//
//         si.AddValue('IconData', stream.ToArray(), TypeInfo(TArray<Byte>));
//   end;
//
//
//   si.AddValue('IconSize', m_iconSize, TypeInfo(TSize));
//end;

class function TGdipIcon.ExtractAssociatedIcon(filePath: string): TGdipIcon;
begin
   Result := ExtractAssociatedIcon(filePath, 0);
end;

class function TGdipIcon.ExtractAssociatedIcon(filePath: string; const index: Integer): TGdipIcon;
begin
   if string.IsNullOrEmpty(filePath) then
      raise EArgumentNullException.Create('filePath');

   if (string.IsNullOrWhiteSpace(filePath)) then
   begin
      raise EArgumentException.Create('SR.NullOrEmptyPath, nameof(filePath)');
   end;

   filePath := TPath.GetFullPath(filePath);
   if (not TFile.Exists(filePath)) then
   begin
      raise EFileNotFoundException.Create(filePath);
   end;

   // ExtractAssociatedIcon copies the loaded path into the buffer that it is passed.
   // It isn't clear what the exact semantics are for copying back the path, a quick
   // look at the code it might be hard coded to 128 chars for some cases. Leaving the
   // historical MAX_PATH as a minimum to be safe.

   var hIcon: HICON;
   hIcon := PInvokeCore.ExtractAssociatedIcon(0, filePath, Index);

   Result := TLogicalUtils.IfElse(hIcon <> 0, TGdipIcon.Create(hIcon, True), nil);
end;

function TGdipIcon.Clone(): TObject;
begin
   Result := TGdipIcon.Create(Self, Size.Width, Size.Height);
end;

procedure TGdipIcon.DestroyHandle();
begin
   if (_ownHandle) then
   begin
      PInvokeCore.DestroyIcon(_handle);
      _handle := 0;
   end;
end;

procedure TGdipIcon.Dispose();
begin
   Dispose( True );
end;

procedure TGdipIcon.Dispose(const disposing: Boolean);
begin
   if not (_handle = 0) then
   begin
      DestroyHandle();
   end;
end;

procedure TGdipIcon.DrawIcon(const hdc: TDeviceContextHandle; const imageRect: TRectangle; const targetRect: TRectangle; const stretch: Boolean);
begin
   var imageX: Integer := 0;
   var imageY: Integer := 0;
   var imageWidth: Integer;
   var imageHeight: Integer;
   var targetX: Integer := 0;
   var targetY: Integer := 0;
   var targetWidth: Integer;
   var targetHeight: Integer;

   var cursorSize: TSize := Size;

   // Compute the dimensions of the icon if needed.
   if (not imageRect.IsEmpty) then
   begin
      imageX := imageRect.X;
      imageY := imageRect.Y;
      imageWidth := imageRect.Width;
      imageHeight := imageRect.Height;
   end
   else
   begin
      imageWidth := cursorSize.Width;
      imageHeight := cursorSize.Height;
   end;

   if (not targetRect.IsEmpty) then
   begin
      targetX := targetRect.X;
      targetY := targetRect.Y;
      targetWidth := targetRect.Width;
      targetHeight := targetRect.Height;
   end
   else
   begin
      targetWidth := cursorSize.Width;
      targetHeight := cursorSize.Height;
   end;

   var drawWidth: Integer;
   var drawHeight: Integer;

   var clipWidth: Integer;
   var clipHeight: Integer;

   if (stretch) then
   begin
      drawWidth := Trunc(cursorSize.Width * targetWidth / imageWidth);
      drawHeight := Trunc(cursorSize.Height * targetHeight / imageHeight);
      clipWidth := targetWidth;
      clipHeight := targetHeight;
   end
   else
   begin
      drawWidth := cursorSize.Width;
      drawHeight := cursorSize.Height;

      if (targetWidth < imageWidth) then
         clipWidth := targetWidth
      else
         clipWidth := imageWidth;


      if (targetHeight < imageHeight) then
         clipHeight := targetHeight
      else
         clipHeight := imageHeight;
   end;

   // The ROP is SRCCOPY, so we can be simple here and take
   // advantage of clipping regions.  Drawing the cursor
   // is merely a matter of offsetting and clipping.

   var hSaveRgn: HRGN := PInvokeCore.SaveClipRgn(hdc);
   try
      PInvokeCore.IntersectClipRect(hdc, targetX, targetY, targetX + clipWidth, targetY + clipHeight);
      PInvokeCore.DrawIconEx(hdc, targetX - imageX, targetY - imageY, Self.Handle, drawWidth, drawHeight);
   finally
      // We need to delete the region handle after restoring the region as GDI+ uses a copy of the handle.
      PInvokeCore.RestoreClipRgn(hdc, hSaveRgn);
   end;

end;

procedure TGdipIcon.Draw(const graphics: TGdipGraphics; const x: Integer; const y: Integer);
begin
   var size: TSize := Size;
   Draw(graphics, TRectangle.Create(x, y, size.Width, size.Height));
end;

procedure TGdipIcon.Draw(const graphics: TGdipGraphics; const targetRect: TRectangle);
begin
   var copy: TRectangle := targetRect;

   var transform: TGdipMatrix := graphics.Transform;
   var offset: TPointF := transform.Offset;
   copy.X := copy.X + Trunc(offset.X);
   copy.Y := copy.Y + Trunc(offset.Y);

   var hdc: TGdipDeviceContextHdcScope := TGdipDeviceContextHdcScope.Create(graphics, TGdipApplyGraphicsProperties.Clipping);
   DrawIcon(hdc, TRectangle.Empty, copy,  True );

   hdc.Dispose();
   transform.Dispose();
   FreeAndNil(transform);
end;

procedure TGdipIcon.DrawUnstretched(const graphics: TGdipGraphics; const targetRect: TRectangle);
begin
   var copy: TRectangle := targetRect;
   var transform: TGdipMatrix := graphics.Transform;
   var offset: TPointF := transform.Offset;
   copy.X := copy.X + Trunc(offset.X);
   copy.Y := copy.Y + Trunc(offset.Y);

   var hdc: TGdipDeviceContextHdcScope := TGdipDeviceContextHdcScope.Create(graphics, TGdipApplyGraphicsProperties.Clipping);
   DrawIcon(hdc, TRectangle.Empty, copy,  False );

   FreeAndNil(transform);
end;

class function TGdipIcon.FromHandle(const handle: HICON): TGdipIcon;
begin
   if (handle = 0) then
   begin
      raise EArgumentException.Create('handle');
   end;

   Exit(TGdipIcon.Create(HICON(handle)));
end;

procedure TGdipIcon.Initialize(width: Integer; height: Integer);
begin
//   if (_iconData = nil) or not (_handle = 0) then
//      raise EInvalidOperationException.Create('SR.Format(SR.IllegalState, GetType().Name)');
//
//   var reader: TSpanReader<Byte> := TSpanReader<Byte>.Create(_iconData);
//   var dir: ICONDIR;

   raise ENotImplemented.Create('ainda não fiz isso aqui');

//   //if (not reader.TryRead<ICONDIR>(dir)) or (dir.idReserved <> 0) or (dir.idType <> 1) or (dir.idCount = 0) then
//   //begin
//   //   raise EArgumentException.Create('SR.Format(SR.InvalidPictureType, ''picture'', nameof(TGdipIcon))');
//   //end;
//
//   // Get the correct width and height.
//   if (width = 0) then
//   begin
//      width := PInvokeCore.GetSystemMetrics(SYSTEM_METRICS_INDEX.SM_CXICON);
//   end;
//
//   if (height = 0) then
//   begin
//      height := PInvokeCore.GetSystemMetrics(SYSTEM_METRICS_INDEX.SM_CYICON);
//   end;
//
//   if (s_bitDepth = 0) then
//   begin
//      var hdc := TGdipGetDcScope.ScreenDC;
//      s_bitDepth := PInvokeCore.GetDeviceCaps(hdc, GET_DEVICE_CAPS_INDEX.BITSPIXEL);
//      s_bitDepth := s_bitDepth * PInvokeCore.GetDeviceCaps(hdc, GET_DEVICE_CAPS_INDEX.PLANES);
//
//      // If the bit depth is 8, make it 4 because windows does not
//      // choose a 256 color icon if the display is running in 256 color mode
//      // due to palette flicker.
//      if (s_bitDepth = 8) then
//      begin
//         s_bitDepth := 4;
//      end;
//   end;
//
//   var bestWidth: Byte := 0;
//   var bestHeight: Byte := 0;
//
//   var entries: TReadOnlySpan<ICONDIRENTRY>;
//   raise ENotImplemented.Create('Ainda não fiz isso aqui! TODO:');
////   if (not reader.TryRead<ICONDIRENTRY>(dir.idCount, entries)) then
//   begin
//      raise EArgumentException.Create('SR.Format(SR.InvalidPictureType, ''picture'', nameof(TGdipIcon))');
//   end;
//
//   for var entry: ICONDIRENTRY in entries do
//   begin
//      begin
//         var fUpdateBestFit: Boolean := false;
//         var iconBitDepth: UInt32;
//         if (entry.bColorCount <> 0) then
//         begin
//            iconBitDepth := 4;
//            if (entry.bColorCount < $10) then
//            begin
//               iconBitDepth := 1;
//            end;
//         end
//         else
//         begin
//            iconBitDepth := entry.wBitCount;
//         end;
//
//         // If it looks like if nothing is specified at this point then set the bits per pixel to 8.
//         if (iconBitDepth = 0) then
//         begin
//            iconBitDepth := 8;
//         end;
//
//         // Windows rules for specifying an icon:
//         //
//         //  1.  The icon with the closest size match.
//         //  2.  For matching sizes, the image with the closest bit depth.
//         //  3.  If there is no color depth match, the icon with the closest color depth that does not exceed the display.
//         //  4.  If all icon color depth > display, lowest color depth is chosen.
//         //  5.  color depth of > 8bpp are all equal.
//         //  6.  Never choose an 8bpp icon on an 8bpp system.
//
//         if (_bestBytesInRes = 0) then
//         begin
//            fUpdateBestFit := true;
//         end
//         else
//         begin
//            var bestDelta: Integer := System.Abs(bestWidth - width) + System.Abs(bestHeight - height);
//            var thisDelta: Integer := System.Abs(entry.bWidth - width) + System.Abs(entry.bHeight - height);
//
//            if ((thisDelta < bestDelta)) or ((thisDelta = bestDelta) and (((iconBitDepth <= UInt32(s_bitDepth)) and (iconBitDepth > _bestBitDepth)) or ((_bestBitDepth > UInt32(s_bitDepth)) and (iconBitDepth < _bestBitDepth)))) then
//            begin
//               fUpdateBestFit := true;
//            end;
//         end;
//
//         if (fUpdateBestFit) then
//         begin
//            bestWidth := entry.bWidth;
//            bestHeight := entry.bHeight;
//            _bestImageOffset := entry.dwImageOffset;
//            _bestBytesInRes := entry.dwBytesInRes;
//            _bestBitDepth := iconBitDepth;
//         end;
//      end;
//   end;
//
//
//   if (_bestImageOffset > Int32.MaxValue) then
//   begin
//      raise EArgumentException.Create('SR.Format(SR.InvalidPictureType, ''picture'', nameof(TGdipIcon))');
//   end;
//
//   if (_bestBytesInRes > Int32.MaxValue) then
//   begin
//      raise EOSError.Create('Integer(WIN32_ERROR.ERROR_INVALID_PARAMETER)');
//   end;
//
//   var endOffset: Int32;
//
//   try
//      begin
//         endOffset := _bestImageOffset + _bestBytesInRes;
//      end;
//   except on e: EOverflow do
//      begin
//         raise EOSError.Create('Integer(WIN32_ERROR.ERROR_INVALID_PARAMETER)');
//      end;
//   end;
//
//
//   if endOffset > Length(_iconData) then
//   begin
//      raise EArgumentException.Create('SR.Format(SR.InvalidPictureType, ''picture'', nameof(TGdipIcon))');
//   end;
//
//   // Copy the bytes into an aligned buffer if needed.
//   var bestImage: TReadOnlySpan<Byte> := reader.Span.Slice(Integer(_bestImageOffset), Integer(_bestBytesInRes));
////
////   if ((_bestImageOffset mod SizeOf(NativeInt)) <> 0) then
////   begin
////      var alignedBuffer: TBufferScope<Byte> := TBufferScope<Byte>.Create(Integer(_bestBytesInRes));
////      bestImage.CopyTo(alignedBuffer.AsSpan());
////      var b: PByte := alignedBuffer;
////      begin
////         _handle := PInvoke.CreateIconFromResourceEx(b, UInt32(bestImage.Length),  True , $00030000, 0, 0, 0);
////      end;
////   end
////   else
////   begin
////      var b: PByte := bestImage;
////      begin
////         _handle := PInvoke.CreateIconFromResourceEx(b, UInt32(bestImage.Length),  True , $00030000, 0, 0, 0);
////      end;
////   end;
//
//   // See DevDivBugs 17509. Copying bytes into an aligned buffer if needed
//   if ((_bestImageOffset mod SizeOf(NativeInt)) <> 0) then
//   begin
//      // Beginning of icon's content is misaligned
//      var alignedBuffer: TArray<Byte> := bestImage.ToArray();
//      _handle := Winapi.Windows.CreateIconFromResourceEx(@alignedBuffer[0], _bestBytesInRes, true, $00030000, 0, 0, 0);
//   end
//   else
//   begin
//      try
//         //_handle := Winapi.Windows.CreateIconFromResourceEx(checked(pbIconData + _bestImageOffset), bestBytesInRes, true, $00030000, 0, 0, 0);
//         raise ENotImplemented.Create('Error Message');
//      except on e: EOverflow do
//         raise EOSError.Create('SafeNativeMethods.ERROR_INVALID_PARAMETER');
//      end;
//   end;
//
//   if (_handle = 0) then
//   begin
//      raise EOSError.Create();
//   end;
end;

procedure TGdipIcon.CopyBitmapData(const sourceData: TGdipBitmapData; const targetData: TGdipBitmapData);
begin
   var srcPtr: PByte := PByte(sourceData.Scan0);
   var destPtr: PByte := PByte(targetData.Scan0);

   Assert(sourceData.Height = targetData.Height, 'Unexpected height. How did this happen?');
   var height: Integer := System.Math.Min(sourceData.Height, targetData.Height);
   var bytesToCopyEachIter: Int64 := System.Abs(targetData.Stride);

   for var i: Integer := 0 to height - 1 do
   begin
      Move(srcPtr, destPtr, bytesToCopyEachIter);
      srcPtr := srcPtr + sourceData.Stride;
      destPtr := destPtr + targetData.Stride;
   end;
end;

class function TGdipIcon.BitmapHasAlpha(const bmpData: TGdipBitmapData): Boolean;
begin
   var hasAlpha: Boolean := false;

   for var i: Integer := 0 to bmpData.Height - 1 do
   begin
      for var j: Integer := 3 to System.Abs(bmpData.Stride) - 1 do
      begin
         // Stride here is fine since we know we're doing this on the whole image.
         var candidate: PByte := PByte(bmpData.Scan0) + (i * bmpData.Stride) + j;
         if (candidate^ <> 0) then
         begin
            hasAlpha := true;
            Exit(hasAlpha);
         end;
      end;
   end;

   Exit(hasAlpha);
end;

function TGdipIcon.ToBitmap(): TGdipBitmap;
begin
   // DontSupportPngFramesInIcons is true when the application is targeting framework version below 4.6
   // and false when the application is targeting 4.6 and above. Downlevel application can also set the following switch
   // to false in the .config file's runtime section in order to opt-in into the new behavior:
   // <AppContextSwitchOverrides value="Switch.System.Drawing.DontSupportPngFramesInIcons=false" />

   if (HasPngSignature()) {and (not LocalAppContextSwitches.DontSupportPngFramesInIcons)} then
   begin
      Exit(PngFrame());
   end;

   Exit(BmpFrame());
end;

function TGdipIcon.BmpFrame(): TGdipBitmap;
begin
   var bitmap: TGdipBitmap := nil;

   if (_iconData <> nil) and (_bestBitDepth = 32) then
   begin
      // GDI+ doesn't handle 32 bpp icons with alpha properly
      // we load the icon ourself from the byte table
      bitmap := TGdipBitmap.Create(Size.Width, Size.Height, TGdipPixelFormat.Format32bppArgb);

      //Assert((_bestImageOffset >= 0) and ((_bestImageOffset + _bestBytesInRes) <= Length(_iconData)), 'Illegal offset/length for the TGdipIcon data');
      Assert(((_bestImageOffset + _bestBytesInRes) <= UInt32(Length(_iconData))), 'Illegal offset/length for the TGdipIcon data');

      var bmpdata: TGdipBitmapData := bitmap.LockBits(TRectangle.Create(0, 0, Size.Width, Size.Height), TGdipImageLockMode.WriteOnly, TGdipPixelFormat.Format32bppArgb);

      try
         var pixelPtr: PUInt32 := PUInt32(bmpdata.Scan0);
         // jumping the image header
         var newOffset: Integer := Integer((_bestImageOffset + SizeOf(TBITMAPINFOHEADER)));
         // there is no color table that we need to skip since we're 32bpp
         var lineLength: Integer := Size.Width * 4;
         var width: Integer := Size.Width;
         var j: Integer := (Size.Height - 1) * 4;

         while (j >= 0) do
         begin
            TMarshal.Copy(_iconData, newOffset + j * width, pixelPtr, lineLength);
            pixelPtr := pixelPtr + width;
            j := j - 4;
         end;
      finally
         bitmap.UnlockBits(bmpdata);
      end;
   end
   else if (_bestBitDepth = 0) or (_bestBitDepth = 32) then
   begin
            // This may be a 32bpp icon or an icon without any data.
            var info: ICONINFO := Default(ICONINFO);
            PInvokeCore.GetIconInfo(Self.Handle, info);
            var bmp: TBITMAP := Default(TBITMAP);

            try


                  if not (info.hbmColor = 0) then
                  begin


                        PInvokeCore.GetObject(info.hbmColor, SizeOf(TBITMAP), @bmp);


                        if (bmp.bmBitsPixel = 32) then
                        begin



                              var tmpBitmap: TGdipBitmap := nil;


                              var bmpData: TGdipBitmapData := nil;


                              var targetData: TGdipBitmapData := nil;


                              try

                                    tmpBitmap := TGdipImage.FromHbitmap(info.hbmColor);

                                    // In GDI+ the bits are there but the bitmap was created with no alpha channel
                                    // so copy the bits by hand to a new bitmap
                                    // we also need to go around a limitation in the way the ICON is stored (ie if it's another bpp
                                    // but stored in 32bpp all pixels are transparent and not opaque)
                                    // (Here you mostly need to remain calm....)

                                    bmpData := tmpBitmap.LockBits(TRectangle.Create(0, 0, tmpBitmap.Width, tmpBitmap.Height), TGdipImageLockMode.ReadOnly, tmpBitmap.PixelFormat);

                                    // we need do the following if the image has alpha because otherwise the image is fully transparent even though it has data


                                    if (BitmapHasAlpha(bmpData)) then
                                    begin


                                          bitmap := TGdipBitmap.Create(bmpData.Width, bmpData.Height, TGdipPixelFormat.Format32bppArgb);

                                          targetData := bitmap.LockBits(TRectangle.Create(0, 0, bmpData.Width, bmpData.Height), TGdipImageLockMode.WriteOnly, TGdipPixelFormat.Format32bppArgb);


                                          CopyBitmapData(bmpData, targetData);
                                    end;
                              finally


                                    if (tmpBitmap <> nil) and (bmpData <> nil) then
                                    begin


                                          tmpBitmap.UnlockBits(bmpData);
                                    end;



                                    if (bitmap <> nil) and (targetData <> nil) then
                                    begin


                                          bitmap.UnlockBits(targetData);
                                    end;
                              end;



                              tmpBitmap.Dispose();
                        end;
                  end;
            finally


                  if not (info.hbmColor = 0) then
                  begin


                        PInvokeCore.DeleteObject(info.hbmColor);
                  end;



                  if not (info.hbmMask = 0) then
                  begin


                        PInvokeCore.DeleteObject(info.hbmMask);
                  end;
            end;

   end;



   if (bitmap = nil) then
   begin

         // last chance... all the other cases (ie non 32 bpp icons coming from a handle or from the bitmapData)

         // we have to do this rather than just return TGdipBitmap.FromHIcon because
         // the bitmap returned from that, even though it's 32bpp, just paints where the mask allows it
         // seems like another GDI+ weirdness. might be interesting to investigate further. In the meantime
         // this looks like the right thing to do and is not more expansive that what was present before.

         var size: TSize := Size;

         bitmap := TGdipBitmap.Create(size.Width, size.Height);


         var graphics: TGdipGraphics := TGdipGraphics.FromImage(bitmap);
         var StmtUsingExpForFree := graphics;
         try
               try
                     var tmpBitmap := TGdipBitmap.FromHicon(Handle);
                     graphics.DrawImage(tmpBitmap, TRectangle.Create(0, 0, size.Width, size.Height));
               except on e: EArgumentException do
                     // Sometimes FromHicon will crash with no real reason.
                     // The backup plan is to just draw the image like we used to.
                     // NOTE: FromHIcon is also where we have the buffer overrun
                     // if width and height are mismatched.
                     Draw(graphics, TRectangle.Create(0, 0, size.Width, size.Height));
               end;
         finally
            if not IsManagedType(StmtUsingExpForFree) and Assigned(StmtUsingExpForFree) then
               FreeAndNil(StmtUsingExpForFree);
         end;

         // GDI+ fills the surface with a sentinel color for GetDC, but does
         // not correctly clean it up again, so we have to do it.

         var fakeTransparencyColor: TGdipColor := TGdipColor.FromArgb($0d, $0b, $0c);
         bitmap.MakeTransparent(fakeTransparencyColor);
   end;

   Assert(bitmap <> nil, 'TGdipBitmap cannot be null');


   Exit(bitmap);
end;

function TGdipIcon.PngFrame(): TGdipBitmap;
begin

   Assert(_iconData <> nil);


   var stream: TMemoryStream := TMemoryStream.Create();

   stream.Write(_iconData, Integer(_bestImageOffset), Integer(_bestBytesInRes));


   Exit(TGdipBitmap.Create(stream));
end;

function TGdipIcon.HasPngSignature(): Boolean;
begin
   if (not _isBestImagePng) then
   begin
         if (_iconData <> nil) and (UInt32(Length(_iconData)) >= _bestImageOffset + 8) then
         begin

               var iconSignature1: Integer := TMarshal.ReadInt32(_iconData, Integer(_bestImageOffset));
               var iconSignature2: Integer := TMarshal.ReadInt32(_iconData, Integer(_bestImageOffset) + 4);
               _isBestImagePng := (iconSignature1 = PNGSignature1) and (iconSignature2 = PNGSignature2);
         end
         else
         begin
               _isBestImagePng := false;
         end;
   end;

   Exit(_isBestImagePng);
end;

function TGdipIcon.ToString(): string;
begin
   Result := '(Icon)';
end;

class function TGdipIcon.ExtractIcon(const filePath: string; const id: Integer; const size: Integer): TGdipIcon;
begin
   if (size <= 0) or (size > UInt16.MaxValue) then
       raise EArgumentOutOfRangeException.Create('nameof(size)')
   else
      Result := ExtractIcon(filePath, id, size,  False);
end;

class function TGdipIcon.ExtractIcon(const filePath: string; const id: Integer; const smallIcon: Boolean = false): TGdipIcon;
begin
   Result := ExtractIcon(filePath, id, 0, smallIcon);
end;

class function TGdipIcon.ExtractIcon(const filePath: string; const id: Integer; const size: Integer; const smallIcon: Boolean = false): TGdipIcon;
begin
   if string.IsNullOrWhiteSpace(filePath) then
      raise EArgumentNilException.Create('filePath');

   Assert((size >= 0) and (size <= UInt16.MaxValue));

   var _result: HRESULT;
   var hicon: HICON := 0;
   if smallIcon then
      _result := PInvokeCore.SHDefExtractIcon(filePath, id, 0,  0, hicon, UInt32(UInt16(size)) shl 16 or UInt16(size))
   else
      _result := PInvokeCore.SHDefExtractIcon(filePath, id, 0,  hicon, 0, UInt32(UInt16(size)) shl 16 or UInt16(size));

   if (_result = S_FALSE) then
   begin
         // TGdipIcon wasn't found
         Exit(nil);
   end;

   // This only throws if there is an error.
   try
//         Marshal.ThrowExceptionForHR(Integer(_result));
   except on ex: Exception do
         // This API is only documented to return E_FAIL, which surfaces as COMException. Wrap in a "nicer"
         // ArgumentException.

         raise EInvalidOperationException.Create('SR.IconCouldNotBeExtracted, ex');
   end;




   Exit(TGdipIcon.Create(hicon,  True));
end;

{$ENDREGION 'TGdipIcon'}

{$REGION 'TGdipFont'}

{ TGdipFont }

procedure TGdipFont.AfterConstruction;
begin
   inherited;
   _gdiCharSet := Byte(DEFAULT_CHARSET);
end;

function TGdipFont.GetSize(): Single;
begin
   Result := _fontSize;
end;

function TGdipFont.GetStyle(): TGdipFontStyle;
begin
   Result := _fontStyle;
end;

function TGdipFont.GetBold(): Boolean;
begin
   Result := (Style and TGdipFontStyle.Bold) <> 0;
end;

function TGdipFont.GetItalic(): Boolean;
begin
   Result := (Style and TGdipFontStyle.Italic) <> 0;
end;

function TGdipFont.GetStrikeout(): Boolean;
begin
   Result := (Style and TGdipFontStyle.Strikeout) <> 0;
end;

function TGdipFont.GetUnderline(): Boolean;
begin
   Result := (Style and TGdipFontStyle.Underline) <> 0;
end;

function TGdipFont.GetFontFamily(): TGdipFontFamily;
begin
   Result := _fontFamily;
end;

function TGdipFont.GetName(): string;
begin
   Result := FontFamily.Name;
end;

function TGdipFont.GetUnit(): TGdipGraphicsUnit;
begin
   Result := _fontUnit;
end;

function TGdipFont.GetGdiCharSet(): Byte;
begin
   Result := _gdiCharSet;
end;

function TGdipFont.GetGdiVerticalFont(): Boolean;
begin
   Result := _gdiVerticalFont;
end;

function TGdipFont.GetOriginalFontName(): string;
begin
   Result := _originalFontName;
end;

function TGdipFont.GetSystemFontName(): string;
begin
   Result := _systemFontName;
end;

function TGdipFont.GetIsSystemFont(): Boolean;
begin
   Result := not string.IsNullOrEmpty(_systemFontName);
end;

function TGdipFont.GetFontHeight(): Integer;
begin
   Result := Ceil(GetFontHeight());
end;

function TGdipFont.GetNativeFont(): TGdiplusapi.TGdipFontPtr;
begin
   Result := _nativeFont;
end;

function TGdipFont.GetSizeInPoints(): Single;
begin
   if (Unit_ = TGdipGraphicsUnit.Point) then
      Exit(Size);

   var screenDC: TDeviceContextHandle := Winapi.Windows.GetDC(0);
   try
      var graphics: TGdipGraphics := TGdipGraphics.FromHdcInternal(screenDC);
      var pixelsPerPoint: Single := Double(graphics.DpiY / 72.0);
      var lineSpacingInPixels: Single := GetHeight(graphics);

      var emHeightInPixels: Single := lineSpacingInPixels * FontFamily.GetEmHeight(Style) / FontFamily.GetLineSpacing(Style);
      Exit(emHeightInPixels / pixelsPerPoint);
   finally
      Winapi.Windows.ReleaseDC(0, screenDC);
   end;

end;

//constructor TGdipFont.Create(const info: TSerializationInfo; const context: TStreamingContext);
//begin
//
//
//   var name: string := info.GetString("Name");
//
//
//   var style: TGdipFontStyle := TGdipFontStyle(info.GetValue("Style", typeof(FontStyle)));
//
//
//   var unit_: TGdipGraphicsUnit := TGdipGraphicsUnit(info.GetValue("Unit", typeof(GraphicsUnit)));
//
//
//   var size: Single := info.GetSingle('Size');
//
//
//   Initialize(name, size, style, unit, Byte(DEFAULT_CHARSET), IsVerticalName(name));
//
//end;

constructor TGdipFont.Create(const prototype: TGdipFont; const newStyle: TGdipFontStyle);
begin
   // Copy over the originalFontName because it won't get initialized

   _originalFontName := prototype.OriginalFontName;

   Initialize(prototype.FontFamily, prototype.Size, newStyle, prototype.Unit_, Byte(DEFAULT_CHARSET),  False );

end;

constructor TGdipFont.Create(const family: TGdipFontFamily; const emSize: Single; const style: TGdipFontStyle; const unit_: TGdipGraphicsUnit);
begin

   Initialize(family, emSize, style, unit_, Byte(DEFAULT_CHARSET),  False );

end;

constructor TGdipFont.Create(const family: TGdipFontFamily; const emSize: Single; const style: TGdipFontStyle; const unit_: TGdipGraphicsUnit; const gdiCharSet: Byte);
begin

   Initialize(family, emSize, style, unit_, gdiCharSet,  False );

end;

constructor TGdipFont.Create(const family: TGdipFontFamily; const emSize: Single; const style: TGdipFontStyle; const unit_: TGdipGraphicsUnit; const gdiCharSet: Byte; const gdiVerticalFont: Boolean);
begin
   Initialize(family, emSize, style, unit_, gdiCharSet, gdiVerticalFont);
end;

constructor TGdipFont.Create(const familyName: string; const emSize: Single; const style: TGdipFontStyle; const unit_: TGdipGraphicsUnit; const gdiCharSet: Byte);
begin
   Initialize(familyName, emSize, style, unit_, gdiCharSet, IsVerticalName(familyName));
end;

constructor TGdipFont.Create(const familyName: string; const emSize: Single; const style: TGdipFontStyle; const unit_: TGdipGraphicsUnit; const gdiCharSet: Byte; const gdiVerticalFont: Boolean);
begin
   if (Single.IsNaN(emSize)) or (Single.IsInfinity(emSize)) or (emSize <= 0) then
   begin
         raise EArgumentException.Create('SR.Format(SR.InvalidBoundArgument, nameof(emSize), emSize, 0, ''System.Single.MaxValue''), nameof(emSize)');
   end;

   Initialize(familyName, emSize, style, unit_, gdiCharSet, gdiVerticalFont);
end;

constructor TGdipFont.Create(const family: TGdipFontFamily; const emSize: Single; const style: TGdipFontStyle);
begin
   Initialize(family, emSize, style, TGdipGraphicsUnit.Point, Byte(DEFAULT_CHARSET),  False);
end;

constructor TGdipFont.Create(const family: TGdipFontFamily; const emSize: Single; const unit_: TGdipGraphicsUnit);
begin
   Initialize(family, emSize, TGdipFontStyle.Regular, unit_, Byte(DEFAULT_CHARSET), False);
end;

constructor TGdipFont.Create(const family: TGdipFontFamily; const emSize: Single);
begin
   Initialize(family, emSize, TGdipFontStyle.Regular, TGdipGraphicsUnit.Point, Byte(DEFAULT_CHARSET),  False);
end;

constructor TGdipFont.Create(const familyName: string; const emSize: Single; const style: TGdipFontStyle; const unit_: TGdipGraphicsUnit);
begin

   Initialize(familyName, emSize, style, unit_, Byte(DEFAULT_CHARSET), IsVerticalName(familyName));

end;

constructor TGdipFont.Create(const familyName: string; const emSize: Single; const style: TGdipFontStyle);
begin

   Initialize(familyName, emSize, style, TGdipGraphicsUnit.Point, Byte(DEFAULT_CHARSET), IsVerticalName(familyName));

end;

constructor TGdipFont.Create(const familyName: string; const emSize: Single; const unit_: TGdipGraphicsUnit);
begin

   Initialize(familyName, emSize, TGdipFontStyle.Regular, unit_, Byte(DEFAULT_CHARSET), IsVerticalName(familyName));

end;

constructor TGdipFont.Create(const familyName: string; const emSize: Single);
begin

   Initialize(familyName, emSize, TGdipFontStyle.Regular, TGdipGraphicsUnit.Point, Byte(DEFAULT_CHARSET), IsVerticalName(familyName));

end;

constructor TGdipFont.Create(const nativeFont: TGdiplusapi.TGdipFontPtr; const gdiCharSet: Byte; const gdiVerticalFont: Boolean);
begin
   Assert(_nativeFont = nil, 'GDI+ native font already initialized, this will generate a handle leak');
   Assert(nativeFont <> nil, 'nativeFont is null');

   _nativeFont := nativeFont;

   var unit_: TGdiplusAPI.TGdipUnitEnum;
   var size: Single;
   var style: Integer;
   var family: TGdiplusAPI.TGdipFontFamilyPtr;

   TGdiplusAPI.GdipGetFontUnit(_nativeFont, unit_).ThrowIfFailed();
   TGdiplusAPI.GdipGetFontSize(_nativeFont, size).ThrowIfFailed();
   TGdiplusAPI.GdipGetFontStyle(_nativeFont, style).ThrowIfFailed();
   TGdiplusAPI.GdipGetFamily(_nativeFont, family).ThrowIfFailed();
   SetFontFamily(TGdipFontFamily.Create(family));

   Initialize(_fontFamily, size, TGdipFontStyle(style), TGdipGraphicsUnit(unit_), gdiCharSet, gdiVerticalFont);
end;

destructor TGdipFont.Destroy();
begin
   Dispose(True);
   inherited Destroy();
end;

//procedure TGdipFont.GetObjectData(const si: TSerializationInfo; const context: TStreamingContext);
//begin
//
//
//   var name: string := IfThen(string.IsNullOrEmpty(OriginalFontName), Name, OriginalFontName);
//
//   si.AddValue('Name', name);
//
//   si.AddValue('Size', Size);
//
//   si.AddValue('Style', Style);
//
//   si.AddValue('Unit', Unit);
//end;

class function TGdipFont.IsVerticalName(const familyName: string): Boolean;
begin
   Result := (familyName.Length> 0) and (familyName[0] = '@');
end;

procedure TGdipFont.Dispose();
begin

   Dispose( True );


end;

procedure TGdipFont.Dispose(const disposing: Boolean);
begin


   if (_nativeFont <> nil) then
   begin



         try
            try
                  // #if DEBUG -> IfDirectiveTrivia
                  // Status status = !Gdip.Initialized ? Status.Ok : -> DisabledTextTrivia
                  // #endif -> EndIfDirectiveTrivia

                  TGdiplusAPI.GdipDeleteFont(_nativeFont);
            except on ex: Exception do
            end;
         finally

               _nativeFont := nil;
         end;

   end;

   if (_fontFamily <> nil) then
   begin
      _fontFamily.Free();
      _fontFamily := Nil;
   end;

end;

function TGdipFont.GetHeight(const graphics: TGdipGraphics): Single;
begin
   if graphics = nil then
      raise EArgumentNullException.Create('graphics');


   if (graphics.NativeGraphics = nil) then
   begin
         raise EArgumentException.Create('graphics');
   end;



   var height: Single;

   TGdiplusAPI.GdipGetFontHeight(NativeFont, graphics.Pointer, @height).ThrowIfFailed();






   Exit(height);
end;

function TGdipFont.GetHeight(const dpi: Single): Single;
begin
   var height: Single;
   TGdiplusAPI.GdipGetFontHeightGivenDPI(NativeFont, dpi, @height).ThrowIfFailed();
   Exit(height);
end;

function TGdipFont.Equals(obj: TObject): Boolean;
begin
   if (obj = Self) then
   begin
      Exit(true);
   end;

   if not (obj is TGdipFont) then
   begin
      Exit(false);
   end;

   var font := obj as TGdipFont;

   // Note: If this and/or the passed-in font are disposed, this method can still return true since we check for cached properties
   // here.
   // We need to call properties on the passed-in object since it could be a proxy in a remoting scenario and proxies don't
   // have access to private/internal fields.
   Exit((font.FontFamily.Equals(FontFamily)) and (font.GdiVerticalFont = GdiVerticalFont) and (font.GdiCharSet = GdiCharSet) and (font.Style = Style) and (font.Size = Size) and (font.Unit_ = Unit_));
end;

function TGdipFont.ToString(): string;
begin
   Result := '[' + ClassName + ': Name=' + FontFamily.Name + ', Size=' + _fontSize.ToString() + ', Units=' + int32(_fontUnit).ToString() + ', GdiCharSet=' + _gdiCharSet.ToString() + ', GdiVerticalFont=' + _gdiVerticalFont.ToString() + ']';
end;

procedure TGdipFont.SetSystemFontName(const systemFontName: string);
begin
   _systemFontName := systemFontName;
   ;
end;

//procedure TGdipFont.ToLogFont(const logFont: TObject; const graphics: TGdipGraphics);
//begin
//   if logFont = nil then
//      raise EArgumentNullException.Create('logFont');
//
//   var type_: TRttiType := logFont.GetType();
//
//
//   var nativeSize: Integer := SizeOf(TLogFontW);
//
//
//   if (SizeOf(type_) <> nativeSize) then
//   begin
//
//         // If we don't actually have an object that is LOGFONT in size, trying to pass
//         // it to GDI+ is likely to cause an AV.
//
//         raise EArgumentException.Create( nil , nameof(logFont));
//   end;
//
//
//   ToLogFont(
//     //
//     // não implementado pelo ObjectPascalCodeGenerator: DeclarationExpression
//     // Node.Kind: DeclarationExpression
//     // Type: DeclarationExpressionSyntax
//     // Arquivo: T:\Data7AdvDsv\source\Apoio\DotNetCore\9-preview2\System.Drawing.Common\src\System\Drawing\Font.cs
//     // Posição: [10438..10459)
//     // Linha: 280
//     //
//     // ----------- começa aqui o que não é suportado ------------
//   LOGFONT nativeLogFont
//     // ----------- TERMINA AQUI O QUE É SEM SUPORTE - 22-03-2024-1 ------------
//     //
//   , graphics);
//
//   // PtrToStructure requires that the passed in object not be a value type.
//
//
//   if (not type_.IsValueType) then
//   begin
//
//
//         Marshal.PtrToStructure(Pointer.Create(@nativeLogFont), logFont);
//   end
//   else
//   begin
//
//
//
//         var handle: TGCHandle := GCHandle.Alloc(logFont, GCHandleType.Pinned);
//
//         Buffer.MemoryCopy(@nativeLogFont, PByte(handle.AddrOfPinnedObject()), nativeSize, nativeSize);
//
//         handle.Free();
//   end;
//end;

procedure TGdipFont.ToLogFont(out logFont: TLogFontW; const graphics: TGdipGraphics);
begin
   if graphics = nil then
      raise EArgumentNullException.Create('graphics');

   TGdiplusAPI.GdipGetLogFontW(Self.NativeFont, graphics.NativeGraphics, logFont).ThrowIfFailed();

   // Prefix the string with '@' if this is a gdiVerticalFont.
   if (_gdiVerticalFont) then
   begin
         var faceName: string := logFont.lfFaceName;
         faceName := '@' + faceName;

         // Docs require this to be null terminated
         StrPCopy(logFont.lfFaceName, faceName);
   end;

   if (logFont.lfCharSet = 0) then
   begin
         logFont.lfCharSet := _gdiCharSet;
   end;
end;

procedure TGdipFont.CreateNativeFont();
begin
   Assert(_nativeFont = nil, 'nativeFont already initialized, this will generate a handle leak.');
   Assert(_fontFamily <> nil, 'fontFamily not initialized.');

   // Note: GDI+ creates singleton font family objects (from the corresponding font file) and reference count them so
   // if creating the font object from an external FontFamily, this object's FontFamily will share the same native object.
   var font: TGdiplusapi.TGdipFontPtr;

   var status: TGdiplusAPI.TGdipStatusEnum := TGdiplusAPI.GdipCreateFont(_fontFamily.NativeFamily, _fontSize, Integer(_fontStyle), TGdiplusAPI.TGdipUnitEnum(_fontUnit), font);

   _nativeFont := font;

   // Special case this common error message to give more information
   if (status = TGdiplusAPI.TGdipStatusEnum.FontStyleNotFound) then
   begin
      raise EArgumentException.Create('SR.Format(SR.GdiplusFontStyleNotFound, _fontFamily.Name, _fontStyle.ToString())');
   end
   else
   begin

      if (status <> TGdiplusAPI.TGdipStatusEnum.Ok) then
      begin
         raise status.GetException();
      end;
   end;
end;

procedure TGdipFont.Initialize(const familyName: string; const emSize: Single; const style: TGdipFontStyle; const unit_: TGdipGraphicsUnit; const gdiCharSet: Byte; const gdiVerticalFont: Boolean);
begin
   _originalFontName := familyName;

   SetFontFamily(TGdipFontFamily.Create(StripVerticalName(familyName),  True ));

   Initialize(_fontFamily, emSize, style, unit_, gdiCharSet, gdiVerticalFont);
end;

procedure TGdipFont.Initialize(const family: TGdipFontFamily; const emSize: Single; const style: TGdipFontStyle; const unit_: TGdipGraphicsUnit; const gdiCharSet: Byte; const gdiVerticalFont: Boolean);
begin
   if family = nil then
      raise EArgumentNullException.Create('family');

   if (Single.IsNaN(emSize)) or (Single.IsInfinity(emSize)) or (emSize <= 0) then
   begin
      raise EArgumentException.Create('SR.Format(SR.InvalidBoundArgument, nameof(emSize), emSize, 0, ''System.Single.MaxValue''), nameof(emSize)');
   end;

   var status: TGdiplusAPI.TGdipStatusEnum;
   _fontSize := emSize;
   _fontStyle := style;
   _fontUnit := unit_;
   _gdiCharSet := gdiCharSet;
   _gdiVerticalFont := gdiVerticalFont;

   if (_fontFamily = nil) then
   begin
      // GDI+ FontFamily is a singleton object.
      SetFontFamily(TGdipFontFamily.Create(family.NativeFamily));
   end;

   if (_nativeFont = nil) then
   begin
      CreateNativeFont();
   end;

   // Get actual size.
   var size: Single;
   status := TGdiplusAPI.GdipGetFontSize(_nativeFont, size);

   _fontSize := size;
   TGdip.CheckStatus(status);
end;

class function TGdipFont.FromHfont(const hfont: HFONT): TGdipFont;
begin
   var logFont: TLogFontW := Default(TLogFontW);
   Winapi.Windows.GetObjectW(HGDIOBJ(hfont), SizeOf(TLogFontW), @logFont);

   var screenDC: TDeviceContextHandle := Winapi.Windows.GetDC(0);
   try
      Result := TGdipFont.FromLogFont(logFont, screenDC);
   finally
      Winapi.Windows.ReleaseDC(0, screenDC);
   end;
end;

//class function TGdipFont.FromLogFont(const lf: TObject): TGdipFont;
//begin
//   var hdc := GetDcScope.ScreenDC;
//   Exit(FromLogFont(lf, hdc));
//end;

class function TGdipFont.FromLogFont(const logFont: TLogFontW): TGdipFont;
begin
   var screenDC: TDeviceContextHandle := Winapi.Windows.GetDC(0);
   try
      Result := TGdipFont.FromLogFont(logFont, screenDC);
   finally
      Winapi.Windows.ReleaseDC(0, screenDC);
   end;
end;

class function TGdipFont.FromLogFont(const logFont: TLogFontW; const hdc: TDeviceContextHandle): TGdipFont;
begin
   var status: TGdiplusAPI.TGdipStatusEnum;
   var font: TGdiplusapi.TGdipFontPtr;
   var lf: PLogFontW := @logFont;
   status := TGdiplusAPI.GdipCreateFontFromLogfontW(hdc, lf, font);

   // Special case this incredibly common error message to give more information
   if (status = Status.NotTrueTypeFont) then
   begin
      raise EArgumentException.Create('SR.GdiplusNotTrueTypeFont_NoName');
   end
   else if (status <> Status.Ok) then
   begin
      raise status.GetException();
   end;

   // GDI+ returns font = 0 even though the status is Ok.
   if (font = nil) then
   begin
      raise EArgumentException.Create('SR.Format(SR.GdiplusNotTrueTypeFont, logFont.AsString())');
   end;

   Exit(TGdipFont.Create(font, logFont.lfCharSet, logFont.IsGdiVerticalFont));
end;

//class function TGdipFont.FromLogFont(const lf: TObject; const hdc: TDeviceContextHandle): TGdipFont;
//begin
//   ArgumentNullException.ThrowIfNull(lf);
//
//
//
//   if (lf is TLogFontW { var logFont: TLogFontW := lf as TLogFontW; } ) then
//   begin
//
//         // A boxed LOGFONT, just use it to create the font
//
//
//         Exit(FromLogFont(logFont, hdc));
//   end;
//
//
//
//   var type_: TRttiType := lf.GetType();
//
//
//   var nativeSize: Integer := SizeOf(TLogFontW);
//
//
//   if (Marshal.SizeOf(type) <> nativeSize) then
//   begin
//
//         // If we don't actually have an object that is LOGFONT in size, trying to pass
//         // it to GDI+ is likely to cause an AV.
//
//         raise EArgumentException.Create( nil , nameof(lf));
//   end;
//
//   // Now that we know the marshalled size is the same as LOGFONT, copy in the data
//
//   logFont :=
//     //
//     // não implementado pelo ObjectPascalCodeGenerator: DefaultLiteralExpression
//     // Node.Kind: DefaultLiteralExpression
//     // Type: LiteralExpressionSyntax
//     // Arquivo: T:\Data7AdvDsv\source\Apoio\DotNetCore\9-preview2\System.Drawing.Common\src\System\Drawing\Font.cs
//     // Posição: [23196..23203)
//     // Linha: 630
//     //
//     // ----------- começa aqui o que não é suportado ------------
//   default
//     // ----------- TERMINA AQUI O QUE É SEM SUPORTE - 22-03-2024-1 ------------
//     //
//   ;
//
//
//   Marshal.StructureToPtr(lf, Pointer.Create(@logFont),  False );
//
//
//
//   Exit(FromLogFont(logFont, hdc));
//end;

class function TGdipFont.FromHdc(const hdc: TDeviceContextHandle): TGdipFont;
begin
   var font: TGdiplusapi.TGdipFontPtr;

   var status: TGdiplusAPI.TGdipStatusEnum := TGdiplusAPI.GdipCreateFontFromDC(hdc, font);

   // Special case this incredibly common error message to give more information


   if (status = Status.NotTrueTypeFont) then
   begin


         raise EArgumentException.Create('SR.GdiplusNotTrueTypeFont_NoName');
   end
   else
   begin

      if (status <> Status.Ok) then
      begin


            raise TGdip.StatusException(status);
      end;
   end;



   Exit(TGdipFont.Create(font, 0,  False ));
end;

function TGdipFont.Clone(): TObject;
begin
   var font: TGdiplusapi.TGdipFontPtr;
   TGdiplusAPI.GdipCloneFont(_nativeFont, font).ThrowIfFailed();
   Exit(TGdipFont.Create(font, _gdiCharSet, _gdiVerticalFont));
end;

procedure TGdipFont.SetFontFamily(const family: TGdipFontFamily);
begin

   _fontFamily := family;

   // GDI+ creates ref-counted singleton FontFamily objects based on the family name so all managed
   // objects with same family name share the underlying GDI+ native pointer. The unmanaged object is
   // destroyed when its ref-count gets to zero.
   //
   // Make sure _fontFamily is not finalized so the underlying singleton object is kept alive.

end;

class function TGdipFont.StripVerticalName(const familyName: string): string;
begin
   if (familyName.Length > 1) and (familyName[0] = '@') then
   begin
      Exit(familyName.Substring(1));
   end;

   Exit(familyName);
end;

//procedure TGdipFont.ToLogFont(const logFont: TObject);
//begin
//
//
//   var hdc := GetDcScope.ScreenDC;
//
//
//   var graphics: TGdipGraphics := Graphics.FromHdcInternal(hdc);
//
//   ToLogFont(logFont, graphics);
//end;

procedure TGdipFont.ToLogFont(out logFont: TLogFontW);
begin
   var screenDC: TDeviceContextHandle := Winapi.Windows.GetDC(0);
   var graphics: TGdipGraphics := TGdipGraphics.FromHdcInternal(screenDC);
   try
      ToLogFont(logFont, graphics);
   finally
      FreeAndNil(graphics);
      Winapi.Windows.ReleaseDC(0, screenDC);
   end;
end;

function TGdipFont.ToHfont(): HFONT;
begin
   var screenDC: TDeviceContextHandle := Winapi.Windows.GetDC(0);
   var graphics: TGdipGraphics := TGdipGraphics.FromHdcInternal(screenDC);
   try
      var lf: TLogFontW;
      ToLogFont(lf, graphics);

      var handle: HFONT := Winapi.Windows.CreateFontIndirectW(lf);

      if handle = 0 then
         RaiseLastOSError();

      Result := handle;
   finally
      FreeAndNil(graphics);
      Winapi.Windows.ReleaseDC(0, screenDC);
   end;
end;

function TGdipFont.GetHeight(): Single;
begin
   var screenDC: TDeviceContextHandle := Winapi.Windows.GetDC(0);
   var graphics: TGdipGraphics := TGdipGraphics.FromHdcInternal(screenDC);
   try
      Result := GetHeight(graphics);
   finally
      FreeAndNil(graphics);
      Winapi.Windows.ReleaseDC(0, screenDC);
   end;
end;

{$ENDREGION 'TGdipFont'}

{ TGdipBitmap }

class constructor TGdipBitmap.CreateClass();
begin
   s_defaultTransparentColor := TGdipColor.LightGray;
end;

function TGdipBitmap.GetPointer(): TGdiplusAPI.TGdipBitmapPtr;
begin
   Result := TGdiplusAPI.TGdipBitmapPtr((TGdipImage(Self)).Pointer);
end;

constructor TGdipBitmap.Create(const ptr: TGdiplusAPI.TGdipBitmapPtr);
begin
   SetNativeImage(TGdiplusAPI.TGdipImagePtr(ptr));
end;

constructor TGdipBitmap.Create(const filename: string);
begin
   Create(filename,  False );
end;

constructor TGdipBitmap.Create(filename: string; const useIcm: Boolean);
begin
   // GDI+ lerá este arquivo várias vezes. Obtenha o caminho totalmente qualificado
   // portanto, se o diretório padrão do aplicativo for alterado, não receberemos um erro.
   filename := TPath.GetFullPath(filename);

   var bitmap: TGdiplusAPI.TGdipBitmapPtr;
   var fn: PWideChar := PWideChar(UnicodeString(filename));

   var status: TGdiplusAPI.TGdipStatusEnum := IfThen(useIcm, TGdiplusAPI.GdipCreateBitmapFromFileICM(fn, bitmap), TGdiplusAPI.GdipCreateBitmapFromFile(fn, bitmap));

      status.ThrowIfFailed();

   ValidateImage(TGdiplusAPI.TGdipImagePtr(bitmap));
   SetNativeImage(TGdiplusAPI.TGdipImagePtr(bitmap));
   GetAnimatedGifRawData(Self, filename,  nil );
end;

constructor TGdipBitmap.Create(const stream: TStream);
begin
   Create(stream,  False );


end;

constructor TGdipBitmap.Create(const stream: TStream; const useIcm: Boolean);
begin
   if stream = nil then
      raise EArgumentNullException.Create('stream');


   var iStream: IStream := stream.ToIStream( True );
   var bitmap: TGdiplusAPI.TGdipBitmapPtr := nil;

   var status: TGdiplusAPI.TGdipStatusEnum := IfThen(useIcm, TGdiplusAPI.GdipCreateBitmapFromStreamICM(iStream, bitmap), TGdiplusAPI.GdipCreateBitmapFromStream(iStream, bitmap));

   status.ThrowIfFailed();

   ValidateImage(TGdiplusAPI.TGdipImagePtr(bitmap));
   SetNativeImage(TGdiplusAPI.TGdipImagePtr(bitmap));
   GetAnimatedGifRawData(Self,  string.Empty, stream);
end;

constructor TGdipBitmap.Create(const type_: TRttiType; const resource: string);
begin
   Create(GetResourceStream(type_, resource));
end;

constructor TGdipBitmap.Create(const width: Integer; const height: Integer);
begin
   Create(width, height, TGdipPixelFormat.Format32bppArgb);
end;

constructor TGdipBitmap.Create(const width: Integer; const height: Integer; const g: TGdipGraphics);
begin
   if g = nil then
      raise EArgumentNullException.Create('g');

   var bitmap: TGdiplusAPI.TGdipBitmapPtr;

   TGdiplusAPI.GdipCreateBitmapFromGraphics(width, height, g.NativeGraphics, bitmap).ThrowIfFailed();

   SetNativeImage(TGdiplusAPI.TGdipBitmapPtr(bitmap));
end;

constructor TGdipBitmap.Create(const width: Integer; const height: Integer; const stride: Integer; const format: TGdipPixelFormat; const scan0: Pointer);
begin
   var bitmap: TGdiplusAPI.TGdipBitmapPtr;

   TGdiplusAPI.GdipCreateBitmapFromScan0(width, height, stride, Integer(format), PByte(scan0), bitmap).ThrowIfFailed();

   SetNativeImage(TGdiplusAPI.TGdipBitmapPtr(bitmap));
end;

constructor TGdipBitmap.Create(const width: Integer; const height: Integer; const format: TGdipPixelFormat);
begin


   var bitmap: TGdiplusAPI.TGdipBitmapPtr;

   TGdiplusAPI.GdipCreateBitmapFromScan0(width, height, 0, Integer(format),  nil , bitmap).ThrowIfFailed();

   SetNativeImage(TGdiplusAPI.TGdipBitmapPtr(bitmap));

end;

constructor TGdipBitmap.Create(const original: TGdipImage);
begin
   Create(original, original.Width, original.Height);


end;

constructor TGdipBitmap.Create(const original: TGdipImage; const newSize: TSize);
begin
   Create(original, newSize.Width, newSize.Height);


end;

constructor TGdipBitmap.Create(const original: TGdipImage; const width: Integer; const height: Integer);
begin
   if original = nil then
      raise EArgumentNullException.Create('original');

   Create(width, height, TGdipPixelFormat.Format32bppArgb);

   var g: TGdipGraphics := TGdipGraphics.FromImage(Self);

   g.Clear(TGdipColor.Transparent);

   g.DrawImage(original, 0, 0, width, height);

end;

//constructor TGdipBitmap.Create(const info: TSerializationInfo; const context: TStreamingContext);
//begin
//   inherited Create(info, context);
//
//
//end;

class function TGdipBitmap.GetResourceStream(const type_: TRttiType; const resource: string): TStream;
begin
   if type_ = nil then
      raise EArgumentNullException.Create('type_');

   if string.IsNullOrEmpty(resource.Trim()) then
      raise EArgumentNullException.Create('resource');

   raise ENotImplemented.Create('Ainda não fiz isso aqui.' + sLineBreak + 'class function TGdipBitmap.GetResourceStream(const type_: TRttiType; const resource: string): TStream;');

//   Exit(type_.Module.Assembly.GetManifestResourceStream(type, resource)
//            ?? throw new ArgumentException(SR.Format(SR.ResourceNotFound, type, resource)));
end;

class function TGdipBitmap.FromHicon(const hicon: HICON): TGdipBitmap;
begin
   var bitmap: TGdiplusAPI.TGdipBitmapPtr;

   TGdiplusAPI.GdipCreateBitmapFromHICON(hicon, bitmap).ThrowIfFailed();

   Result := TGdipBitmap.Create(bitmap);
end;

class function TGdipBitmap.FromResource(const hinstance: HINST; const bitmapName: string): TGdipBitmap;
begin
   if string.IsNullOrWhiteSpace(bitmapName) then
      raise EArgumentNullException.Create('bitmapName');

   var bitmap: TGdiplusAPI.TGdipBitmapPtr := nil;
   TGdiplusAPI.GdipCreateBitmapFromResource(hinstance, PWideChar(UnicodeString(bitmapName)), bitmap).ThrowIfFailed();

   Result := TGdipBitmap.Create(bitmap);
end;

function TGdipBitmap.GetHbitmap(): HBITMAP;
begin
   Result := GetHbitmap(TGdipColor.LightGray);
end;

function TGdipBitmap.GetHbitmap(const background: TGdipColor): HBITMAP;
begin
   var hbitmap: HBITMAP;

   var status: TGdiplusAPI.TGdipStatusEnum := TGdiplusAPI.GdipCreateHBITMAPFromBitmap(Self.Pointer, hbitmap, UInt32(TGdipColorTranslator.ToWin32(background)));


   if (status = Status.InvalidParameter) and ((Width >= short.MaxValue) or (Height >= short.MaxValue)) then
   begin
         raise EArgumentException.Create('SR.GdiplusInvalidSize');
   end;


   status.ThrowIfFailed();




   Exit(hbitmap);
end;

function TGdipBitmap.GetHicon(): HICON;
begin
   var hicon: Winapi.Windows.HICON;
   TGdiplusAPI.GdipCreateHICONFromBitmap(Self.Pointer, hicon).ThrowIfFailed();
   Exit(hicon);
end;

function TGdipBitmap.Clone(const rect: TRectangleF; const format: TGdipPixelFormat): TGdipBitmap;
begin
   if (rect.Width = 0) or (rect.Height = 0) then
   begin
      raise EArgumentException.Create('SR.Format(SR.GdiplusInvalidRectangle, rect.ToString())');
   end;

   var clone: TGdiplusAPI.TGdipBitmapPtr;

   var status: TGdiplusAPI.TGdipStatusEnum := TGdiplusAPI.GdipCloneBitmapArea(rect.X, rect.Y, rect.Width, rect.Height, Integer(format), Self.Pointer, clone);



   if (status <> Status.Ok) or (clone = nil) then
   begin
         raise TGdip.StatusException(status);
   end;





   Exit(TGdipBitmap.Create(clone));
end;

procedure TGdipBitmap.MakeTransparent();
begin


   var transparent: TGdipColor := s_defaultTransparentColor;


   if (Height > 0) and (Width > 0) then
   begin


         transparent := GetPixel(0, Size.Height - 1);
   end;



   if (transparent.A < 255) then
   begin

         // It's already transparent, and if we proceeded, we will do something
         // unintended like making black transparent


         Exit();
   end;


   MakeTransparent(transparent);
end;

procedure TGdipBitmap.MakeTransparent(const transparentColor: TGdipColor);
begin
   if IsEqualGUID(RawFormat.Guid, TGdipImageFormat.Icon.Guid) then
   begin
      raise EInvalidOperation.Create('SR.CantMakeIconTransparent');
   end;

   var size: TSize := Size;

   // The new bitmap must be in 32bppARGB  format, because that's the only
   // thing that supports alpha.  (And that's what the image is initialized to -- transparent)
   var _result: TGdipBitmap := TGdipBitmap.Create(size.Width, size.Height, TGdipPixelFormat.Format32bppArgb);
   var graphics := TGdipGraphics.FromImage(_result);
   graphics.Clear(TGdipColor.Transparent);


   var rectangle: TRectangle := TRectangle.Create(0, 0, size.Width, size.Height);
   var attributes: TGdipImageAttributes := TGdipImageAttributes.Create();
   try
      attributes.SetColorKey(transparentColor, transparentColor);
      graphics.DrawImage(Self, rectangle, 0, 0, size.Width, size.Height, TGdipGraphicsUnit.Pixel, attributes,  nil , nil);
   finally
      if Assigned(attributes) then
         FreeAndNil(attributes);
   end;

   // Swap nativeImage pointers to make it look like we modified the image in place
   var temp: TGdiplusAPI.TGdipBitmapPtr := Self.Pointer;
   SetNativeImage(TGdiplusAPI.TGdipBitmapPtr(_result.Pointer));
   _result.SetNativeImage(TGdiplusAPI.TGdipBitmapPtr(temp));
end;

function TGdipBitmap.LockBits(const rect: TRectangle; const flags: TGdipImageLockMode; const format: TGdipPixelFormat): TGdipBitmapData;
begin
   Result := LockBits(rect, flags, format, TGdipBitmapData.Create());
end;

function TGdipBitmap.LockBits(const rect: TRectangle; const flags: TGdipImageLockMode; const format: TGdipPixelFormat; const bitmapData: TGdipBitmapData): TGdipBitmapData;
begin
   if bitmapData = nil then
      raise EArgumentNullException.Create('bitmapData');

   var data: System.Pointer := bitmapData.GetPinnableReference();

   Self.LockBits(rect, TGdiPlusAPI.TGdipImageLockModeEnum(flags), TGdiPlusAPI.TGdipPixelFormatEnum(format), TGdiplusAPI.TGdipBitmapDataPtr(data));

   Exit(bitmapData);
end;

procedure TGdipBitmap.LockBits(const rect: TRectangle; const flags: TGdiPlusAPI.TGdipImageLockModeEnum; const format: TGdiPlusAPI.TGdipPixelFormatEnum; data: TGdiplusAPI.TGdipBitmapDataPtr);
begin
  // LockBits always creates a temporary copy of the data.
  TGdiplusAPI.GdipBitmapLockBits(
      Self.Pointer,
      TLogicalUtils.IfElse(rect.IsEmpty, nil, @rect),
      flags,
      format,
      Data).ThrowIfFailed();
end;


procedure TGdipBitmap.UnlockBits(const bitmapdata: TGdipBitmapData);
begin
   if bitmapdata = nil then
      raise EArgumentNullException.Create('bitmapdata');


   var data: System.Pointer :=
   bitmapdata.GetPinnableReference();

   Self.UnlockBits(TGdiplusAPI.TGdipBitmapDataPtr(data));

end;

procedure TGdipBitmap.UnlockBits(data: TGdiplusAPI.TGdipBitmapDataPtr);
begin
   TGdiplusAPI.GdipBitmapUnlockBits(Self.Pointer, Data).ThrowIfFailed();
end;

function TGdipBitmap.GetPixel(const x: Integer; const y: Integer): TGdipColor;
begin
   if (x < 0) or (x >= Width) then
   begin
      raise EArgumentOutOfRangeException.Create('nameof(x), SR.ValidRangeX');
   end;

   if (y < 0) or (y >= Height) then
   begin
      raise EArgumentOutOfRangeException.Create('nameof(y), SR.ValidRangeY');
   end;

   var color: UInt32;

   TGdiplusAPI.GdipBitmapGetPixel(Self.Pointer, x, y, color).ThrowIfFailed();

   Exit(TGdipColor.FromArgb(Integer(color)));
end;

procedure TGdipBitmap.SetPixel(const x: Integer; const y: Integer; const color: TGdipColor);
begin
   if TLogicalUtils.HasFlag(Ord(PixelFormat), Ord(TGdipPixelFormat.Indexed)) then
   begin
      raise EInvalidOperationException.Create('SR.GdiplusCannotSetPixelFromIndexedPixelFormat');
   end;

   if (x < 0) or (x >= Width) then
   begin
      raise EArgumentOutOfRangeException.Create('nameof(x), SR.ValidRangeX');
   end;

   if (y < 0) or (y >= Height) then
   begin
      raise EArgumentOutOfRangeException.Create('nameof(y), SR.ValidRangeY');
   end;

   TGdiplusAPI.GdipBitmapSetPixel(Self.Pointer, x, y, UInt32(color.ToArgb())).ThrowIfFailed();

end;

procedure TGdipBitmap.SetResolution(const xDpi: Single; const yDpi: Single);
begin

   TGdiplusAPI.GdipBitmapSetResolution(Self.Pointer, xDpi, yDpi).ThrowIfFailed();


end;

function TGdipBitmap.Clone(const rect: TRectangle; const format: TGdipPixelFormat): TGdipBitmap;
begin
   if (rect.Width = 0) or (rect.Height = 0) then
   begin
      raise EArgumentException.Create('SR.Format(SR.GdiplusInvalidRectangle, rect.ToString())');
   end;

   var clone: TGdiplusAPI.TGdipBitmapPtr;

   var status: TGdiplusAPI.TGdipStatusEnum := TGdiplusAPI.GdipCloneBitmapAreaI(rect.X, rect.Y, rect.Width, rect.Height, Integer(format), Self.Pointer, clone);

   if (status <> Status.Ok) or (clone = nil) then
   begin
      raise TGdip.StatusException(status);
   end;

   Exit(TGdipBitmap.Create(clone));
end;

procedure TGdipBitmap.ApplyEffect(const effect: TGdipEffect; const area: TRectangle);
begin
   var rect: Winapi.Windows.TRECT := area;
   TGdiplusAPI.GdipBitmapApplyEffect(Self.Pointer, effect.NativeEffect, TLogicalUtils.IfElse(area.IsEmpty, nil, @rect),  False ,  nil ,  nil ).ThrowIfFailed();
end;

procedure TGdipBitmap.ConvertFormat(const format: TGdipPixelFormat; const ditherType: TGdipDitherType; const paletteType: TGdipPaletteType = TGdipPaletteType.Custom; const palette: TGdipColorPalette = nil; const alphaThresholdPercent: Single = Single(0.0));
begin
   if (palette = nil) then
   begin
      TGdiplusAPI.GdipBitmapConvertFormat(Self.Pointer, Integer(format), TGdiPlusAPI.TGdipDitherTypeEnum(ditherType), TGdiPlusAPI.TGdipPaletteTypeEnum(paletteType),  nil , alphaThresholdPercent).ThrowIfFailed();
   end
   else
   begin
      var buffer := palette.ConvertToBuffer();

      TGdiplusAPI.GdipBitmapConvertFormat(Self.Pointer, Integer(format), TGdiPlusAPI.TGdipDitherTypeEnum(ditherType), TGdiPlusAPI.TGdipPaletteTypeEnum(paletteType), TGdiPlusAPI.TGdipColorPalettePtr(buffer), alphaThresholdPercent).ThrowIfFailed();
   end;
end;

function TGdipBitmap.GetHistogram(const Format: TGdipHistogramFormat): TGdipBitmapHistogram;
var
  ChannelCount, EntryCount: Cardinal;
  Channel0, Channel1, Channel2, Channel3: PCardinal;
begin
  case Format of
    TGdipHistogramFormat.ARGB,
    TGdipHistogramFormat.PARGB:
      ChannelCount := 4;
    TGdipHistogramFormat.RGB:
      ChannelCount := 3;
  else
    ChannelCount := 1;
  end;
  EntryCount := 0;
  Channel0 := nil;
  Channel1 := nil;
  Channel2 := nil;
  Channel3 := nil;
  TGdiplusAPI.GdipBitmapGetHistogramSize(TGdiplusAPI.TGdipHistogramFormatEnum(Format), EntryCount).ThrowIfFailed();

  if (EntryCount > 0) then
  begin
    GetMem(Channel0, EntryCount * SizeOf(Cardinal));
    if (ChannelCount > 1) then
    begin
      GetMem(Channel1, EntryCount * SizeOf(Cardinal));
      GetMem(Channel2, EntryCount * SizeOf(Cardinal));
      if (ChannelCount > 3) then
        GetMem(Channel3, EntryCount * SizeOf(Cardinal));
    end;

    try
      TGdiplusAPI.GdipBitmapGetHistogram(Self.Pointer, TGdiplusAPI.TGdipHistogramFormatEnum(Format), EntryCount, Channel0, Channel1, Channel2, Channel3).ThrowIfFailed();
    except
      FreeMem(Channel3);
      FreeMem(Channel2);
      FreeMem(Channel2);
      FreeMem(Channel0);
      Channel0 := nil;
      Channel1 := nil;
      Channel2 := nil;
      Channel3 := nil;
    end;
  end;
  Result := TGdipBitmapHistogram.Create(ChannelCount, EntryCount, Channel0, Channel1, Channel2, Channel3);
end;

procedure TGdipBitmap.ConvertFormat(const format: TGdipPixelFormat);
begin
   var currentFormat: TGdipPixelFormat := PixelFormat;
   var targetSize: Integer := (Integer(format) shr 8) and $ff;
   var sourceSize: Integer := (Integer(currentFormat) shr 8) and $ff;

   if not TLogicalUtils.HasFlag(Ord(format), Ord(TGdipPixelFormat.Indexed)) then
   begin
//         var DitherType: TGdipDitherType;
//         if (targetSize > sourceSize) then
//            DitherType := TGdipDitherType.None
//         else
//            DitherType
         ConvertFormat(format, TLogicalUtils.IfElse<TGdipDitherType>(targetSize > sourceSize, TGdipDitherType.None, TGdipDitherType.Solid));
         Exit();
   end;

   var paletteSize: Integer;
      case (targetSize) of
         1:
            paletteSize := 2;
         4:
            paletteSize := 16;
      else
         paletteSize := 256;
      end;


   var hasAlpha: Boolean := TLogicalUtils.HasFlag<TGdipPixelFormat>(format, TGdipPixelFormat.Alpha);


   if (hasAlpha) then
   begin


         paletteSize := paletteSize + 1;
   end;



   var palette: TGdipColorPalette := TGdipColorPalette.CreateOptimalPalette(paletteSize, hasAlpha, 0, Self);

   ConvertFormat(format, TGdipDitherType.ErrorDiffusion, TGdipPaletteType.Custom, palette, Single(0.25));
end;

{$ENDREGION 'TGdipBitmap'}



{ TGdipEffect }

function TGdipEffect.GetNativeEffect(): TGdiplusAPI.TGdipEffectPtr;
begin
   Result := _nativeEffect;
end;

constructor TGdipEffect.Create(const guid: TGuid);
begin
   var nativeEffect: TGdiplusAPI.TGdipEffectPtr;
   TGdiplusAPI.GdipCreateEffect(guid, nativeEffect).ThrowIfFailed();
   _nativeEffect := nativeEffect;
end;

destructor TGdipEffect.Destroy();
begin
   Dispose(True);
   inherited Destroy();
end;

procedure TGdipEffect.Dispose();
begin
   Dispose( True );
end;

procedure TGdipEffect.SetParameters<T>(var parameters: T);
begin
   TGdiplusAPI.GdipSetEffectParameters(NativeEffect, @parameters, UInt32(SizeOf(T))).ThrowIfFailed();
end;

procedure TGdipEffect.Dispose(const disposing: Boolean);
begin
   if (_nativeEffect <> nil) then
   begin
      TGdiplusAPI.GdipDeleteEffect(_nativeEffect);
      _nativeEffect := nil;
   end;
end;



{ TGdipBitmapData }

class constructor TGdipBitmapData.CreateClass();
begin
end;

class destructor TGdipBitmapData.DestroyClass();
begin
end;

function TGdipBitmapData.GetWidth(): Integer;
begin

   Exit(_width);
end;

procedure TGdipBitmapData.SetWidth(const Value: Integer);
begin
   _width := value;
end;

function TGdipBitmapData.GetHeight(): Integer;
begin

   Exit(_height);
end;

procedure TGdipBitmapData.SetHeight(const Value: Integer);
begin
   _height := value;
end;

function TGdipBitmapData.GetStride(): Integer;
begin

   Exit(_stride);
end;

procedure TGdipBitmapData.SetStride(const Value: Integer);
begin
   _stride := value;
end;

function TGdipBitmapData.GetPixelFormat(): TGdipPixelFormat;
begin

   Exit(_pixelFormat);
end;

procedure TGdipBitmapData.SetPixelFormat(const Value: TGdipPixelFormat);
begin
   case (value) of
      TGdipPixelFormat.DontCare,
      TGdipPixelFormat.Max,
      TGdipPixelFormat.Indexed,
      TGdipPixelFormat.Gdi,
      TGdipPixelFormat.Format16bppRgb555,
      TGdipPixelFormat.Format16bppRgb565,
      TGdipPixelFormat.Format24bppRgb,
      TGdipPixelFormat.Format32bppRgb,
      TGdipPixelFormat.Format1bppIndexed,
      TGdipPixelFormat.Format4bppIndexed,
      TGdipPixelFormat.Format8bppIndexed,
      TGdipPixelFormat.Alpha,
      TGdipPixelFormat.Format16bppArgb1555,
      TGdipPixelFormat.PAlpha,
      TGdipPixelFormat.Format32bppPArgb,
      TGdipPixelFormat.Extended,
      TGdipPixelFormat.Format16bppGrayScale,
      TGdipPixelFormat.Format48bppRgb,
      TGdipPixelFormat.Format64bppPArgb,
      TGdipPixelFormat.Canonical,
      TGdipPixelFormat.Format32bppArgb,
      TGdipPixelFormat.Format64bppArgb:
   else
      raise EInvalidArgument.Create('nameof(value), Integer(value), TypeInfo(TGdipPixelFormat)');
   end;

   _pixelFormat := value;
end;

function TGdipBitmapData.GetScan0(): Pointer;
begin

   Exit(_scan0);
end;

procedure TGdipBitmapData.SetScan0(const Value: Pointer);
begin
   _scan0 := value;
end;

function TGdipBitmapData.GetReserved(): Integer;
begin

   Exit(_reserved);
end;

procedure TGdipBitmapData.SetReserved(const Value: Integer);
begin
   _reserved := value;
end;

function TGdipBitmapData.GetPinnableReference(): PInteger;
begin
   Result := @_width;
end;






{ TGdipMetafile }

class constructor TGdipMetafile.CreateClass();
begin
end;

class destructor TGdipMetafile.DestroyClass();
begin
end;

procedure TGdipMetafile.AfterConstruction;
begin
   inherited;
end;

procedure TGdipMetafile.BeforeDestruction;
begin
   inherited;
end;

constructor TGdipMetafile.Create(const hmetafile: HMETAFILE; const wmfHeader: TGdipWmfPlaceableFileHeader; const deleteWmf: Boolean);
begin
   var header: TGdiPlusAPI.TGdipWmfPlaceableFileHeaderPtr := wmfHeader._header;
   var metafile: TGdiPlusAPI.TGdipMetafilePtr;

   TGdiplusAPI.GdipCreateMetafileFromWmf(hmetafile, deleteWmf, header, metafile).ThrowIfFailed();

   SetNativeImage(TGdiPlusAPI.TGdipImagePtr(metafile));
end;

constructor TGdipMetafile.Create(const henhmetafile: HENHMETAFILE; const deleteEmf: Boolean);
begin
   var metafile: TGdiPlusAPI.TGdipMetafilePtr;

   TGdiplusAPI.GdipCreateMetafileFromEmf(henhmetafile, deleteEmf, metafile).ThrowIfFailed();

   SetNativeImage(TGdiPlusAPI.TGdipImagePtr(metafile));
end;

constructor TGdipMetafile.Create(const filename: string);
begin
   // Chamado para emular o comportamento de exceção relacionado a caminhos de arquivo inválidos.
   TPath.GetFullPath(filename);

   var metafile: TGdiPlusAPI.TGdipMetafilePtr;

   TGdiplusAPI.GdipCreateMetafileFromFile(PWideChar(UnicodeString(filename)), metafile).ThrowIfFailed();

   SetNativeImage(TGdiPlusAPI.TGdipImagePtr(metafile));
end;

constructor TGdipMetafile.Create(const referenceHdc: TDeviceContextHandle; const frameRect: TRectangle);
begin
   Create(referenceHdc, frameRect, TGdipMetafileFrameUnit.GdiCompatible);
end;

constructor TGdipMetafile.Create(const referenceHdc: TDeviceContextHandle; const emfType: TGdipEmfType);
begin
   Create(referenceHdc, emfType,  string.Empty);
end;

constructor TGdipMetafile.Create(const referenceHdc: TDeviceContextHandle; const frameRect: TRectangleF);
begin
   Create(referenceHdc, frameRect, TGdipMetafileFrameUnit.GdiCompatible);
end;

constructor TGdipMetafile.Create(const referenceHdc: TDeviceContextHandle; const frameRect: TRectangleF; const frameUnit: TGdipMetafileFrameUnit);
begin
   Create(referenceHdc, frameRect, frameUnit, TGdipEmfType.EmfPlusDual);
end;

constructor TGdipMetafile.Create(const referenceHdc: TDeviceContextHandle; const frameRect: TRectangleF; const frameUnit: TGdipMetafileFrameUnit; const type_: TGdipEmfType);
begin
   Create(referenceHdc, frameRect, frameUnit, type_,  string.Empty);
end;

constructor TGdipMetafile.Create(const referenceHdc: TDeviceContextHandle; const frameRect: TRectangleF; const frameUnit: TGdipMetafileFrameUnit; const type_: TGdipEmfType; const description: string);
begin
   var rect: TRectangleF := frameRect;
   var metafile: TGdiPlusAPI.TGdipMetafilePtr;

   TGdiplusAPI.GdipRecordMetafile(referenceHdc, TGdiPlusAPI.TGdipEmfTypeEnum(type_), @rect, TGdiPlusAPI.TGdipMetafileFrameUnitEnum(frameUnit), PWideChar(UnicodeString(description)), metafile).ThrowIfFailed();

   SetNativeImage(TGdiPlusAPI.TGdipImagePtr(metafile));
end;

constructor TGdipMetafile.Create(const referenceHdc: TDeviceContextHandle; const frameRect: TRectangle; const frameUnit: TGdipMetafileFrameUnit);
begin
   Create(referenceHdc, frameRect, frameUnit, TGdipEmfType.EmfPlusDual);
end;

constructor TGdipMetafile.Create(const referenceHdc: TDeviceContextHandle; const frameRect: TRectangle; const frameUnit: TGdipMetafileFrameUnit; const type_: TGdipEmfType);
begin
   Create(referenceHdc, frameRect, frameUnit, type_,  string.Empty);
end;

constructor TGdipMetafile.Create(const fileName: string; const referenceHdc: TDeviceContextHandle);
begin
   Create(fileName, referenceHdc, TGdipEmfType.EmfPlusDual,  string.Empty);
end;

constructor TGdipMetafile.Create(const fileName: string; const referenceHdc: TDeviceContextHandle; const type_: TGdipEmfType);
begin
   Create(fileName, referenceHdc, type_,  string.Empty);
end;

constructor TGdipMetafile.Create(const fileName: string; const referenceHdc: TDeviceContextHandle; const frameRect: TRectangleF);
begin
   Create(fileName, referenceHdc, frameRect, TGdipMetafileFrameUnit.GdiCompatible);
end;

constructor TGdipMetafile.Create(const fileName: string; const referenceHdc: TDeviceContextHandle; const frameRect: TRectangleF; const frameUnit: TGdipMetafileFrameUnit);
begin
   Create(fileName, referenceHdc, frameRect, frameUnit, TGdipEmfType.EmfPlusDual);
end;

constructor TGdipMetafile.Create(const fileName: string; const referenceHdc: TDeviceContextHandle; const frameRect: TRectangleF; const frameUnit: TGdipMetafileFrameUnit; const type_: TGdipEmfType);
begin
   Create(fileName, referenceHdc, frameRect, frameUnit, type_,  string.Empty);
end;

constructor TGdipMetafile.Create(const fileName: string; const referenceHdc: TDeviceContextHandle; const frameRect: TRectangleF; const frameUnit: TGdipMetafileFrameUnit; const desc: string);
begin
   Create(fileName, referenceHdc, frameRect, frameUnit, TGdipEmfType.EmfPlusDual, desc);
end;

constructor TGdipMetafile.Create(const fileName: string; const referenceHdc: TDeviceContextHandle; const frameRect: TRectangleF; const frameUnit: TGdipMetafileFrameUnit; const type_: TGdipEmfType; const description: string);
begin
   // Chamado para emular o comportamento de exceção relacionado a caminhos de arquivo inválidos.
   TPath.GetFullPath(fileName);

   if (fileName.Length > MaxPath) then
      raise EPathTooLongException.Create(filename);

   var rect: TRectangleF := frameRect;
   var metafile: TGdiPlusAPI.TGdipMetafilePtr;

   TGdiplusAPI.GdipRecordMetafileFileName(PWideChar(UnicodeString(filename)), referenceHdc, TGdiPlusAPI.TGdipEmfTypeEnum(type_), @rect, TGdiPlusAPI.TGdipMetafileFrameUnitEnum(frameUnit), PWideChar(UnicodeString(description)), metafile).ThrowIfFailed();

   SetNativeImage(TGdiPlusAPI.TGdipImagePtr(metafile));
end;

constructor TGdipMetafile.Create(const fileName: string; const referenceHdc: TDeviceContextHandle; const frameRect: TRectangle);
begin
   Create(fileName, referenceHdc, frameRect, TGdipMetafileFrameUnit.GdiCompatible);
end;

constructor TGdipMetafile.Create(const fileName: string; const referenceHdc: TDeviceContextHandle; const frameRect: TRectangle; const frameUnit: TGdipMetafileFrameUnit);
begin
   Create(fileName, referenceHdc, frameRect, frameUnit, TGdipEmfType.EmfPlusDual);
end;

constructor TGdipMetafile.Create(const fileName: string; const referenceHdc: TDeviceContextHandle; const frameRect: TRectangle; const frameUnit: TGdipMetafileFrameUnit; const type_: TGdipEmfType);
begin
   Create(fileName, referenceHdc, frameRect, frameUnit, type_,  string.Empty);
end;

constructor TGdipMetafile.Create(const fileName: string; const referenceHdc: TDeviceContextHandle; const frameRect: TRectangle; const frameUnit: TGdipMetafileFrameUnit; const description: string);
begin
   Create(fileName, referenceHdc, frameRect, frameUnit, TGdipEmfType.EmfPlusDual, description);
end;

constructor TGdipMetafile.Create(const stream: TStream; const referenceHdc: TDeviceContextHandle);
begin
   Create(stream, referenceHdc, TGdipEmfType.EmfPlusDual, string.Empty);
end;

constructor TGdipMetafile.Create(const stream: TStream; const referenceHdc: TDeviceContextHandle; const type_: TGdipEmfType);
begin
   Create(stream, referenceHdc, type_,  string.Empty);
end;

constructor TGdipMetafile.Create(const stream: TStream; const referenceHdc: TDeviceContextHandle; const frameRect: TRectangleF);
begin
   Create(stream, referenceHdc, frameRect, TGdipMetafileFrameUnit.GdiCompatible);
end;

constructor TGdipMetafile.Create(const stream: TStream; const referenceHdc: TDeviceContextHandle; const frameRect: TRectangleF; const frameUnit: TGdipMetafileFrameUnit);
begin
   Create(stream, referenceHdc, frameRect, frameUnit, TGdipEmfType.EmfPlusDual);
end;

constructor TGdipMetafile.Create(const stream: TStream; const referenceHdc: TDeviceContextHandle; const frameRect: TRectangleF; const frameUnit: TGdipMetafileFrameUnit; const type_: TGdipEmfType);
begin
   Create(stream, referenceHdc, frameRect, frameUnit, type_,  string.Empty);
end;

constructor TGdipMetafile.Create(const stream: TStream; const referenceHdc: TDeviceContextHandle; const frameRect: TRectangle);
begin
   Create(stream, referenceHdc, frameRect, TGdipMetafileFrameUnit.GdiCompatible);
end;

constructor TGdipMetafile.Create(const stream: TStream; const referenceHdc: TDeviceContextHandle; const frameRect: TRectangle; const frameUnit: TGdipMetafileFrameUnit);
begin
   Create(stream, referenceHdc, frameRect, frameUnit, TGdipEmfType.EmfPlusDual);
end;

constructor TGdipMetafile.Create(const stream: TStream; const referenceHdc: TDeviceContextHandle; const frameRect: TRectangle; const frameUnit: TGdipMetafileFrameUnit; const type_: TGdipEmfType);
begin
   Create(stream, referenceHdc, frameRect, frameUnit, type_,  string.Empty);
end;

constructor TGdipMetafile.Create(const hmetafile: HMETAFILE; const wmfHeader: TGdipWmfPlaceableFileHeader);
begin
   Create(hmetafile, wmfHeader,  False );
end;

constructor TGdipMetafile.Create(const stream: TStream);
begin
   if stream = nil then
      raise EArgumentNullException.Create('stream');

   var iStream: IStream := stream.ToIStream(True);
   var metafile: TGdiPlusAPI.TGdipMetafilePtr;

   TGdiplusAPI.GdipCreateMetafileFromStream(iStream, metafile).ThrowIfFailed();

   SetNativeImage(TGdiPlusAPI.TGdipImagePtr(metafile));
end;

constructor TGdipMetafile.Create(const referenceHdc: TDeviceContextHandle; const emfType: TGdipEmfType; const description: string);
begin
   var metafile: TGdiPlusAPI.TGdipMetafilePtr;

   TGdiplusAPI.GdipRecordMetafile(referenceHdc, TGdiPlusAPI.TGdipEmfTypeEnum(emfType),  nil , TGdiPlusAPI.TGdipMetafileFrameUnitEnum.Gdi, PWideChar(UnicodeString(description)), metafile).ThrowIfFailed();

   SetNativeImage(TGdiPlusAPI.TGdipImagePtr(metafile));
end;

constructor TGdipMetafile.Create(const referenceHdc: TDeviceContextHandle; const frameRect: TRectangle; const frameUnit: TGdipMetafileFrameUnit; const type_: TGdipEmfType; const desc: string);
begin
   var metafile: TGdiPlusAPI.TGdipMetafilePtr;
   var rect: TRectangleF := TRectangleF(frameRect);

   TGdiplusAPI.GdipRecordMetafile(referenceHdc, TGdiPlusAPI.TGdipEmfTypeEnum(type_), TLogicalUtils.IfElse(frameRect.IsEmpty, nil, @rect), TGdiPlusAPI.TGdipMetafileFrameUnitEnum(frameUnit), PWideChar(UnicodeString(desc)), metafile).ThrowIfFailed();

   SetNativeImage(TGdiPlusAPI.TGdipImagePtr(metafile));
end;

constructor TGdipMetafile.Create(const fileName: string; const referenceHdc: TDeviceContextHandle; const type_: TGdipEmfType; const description: string);
begin
   // Chamado para emular o comportamento de exceção relacionado a caminhos de arquivo inválidos.
   TPath.GetFullPath(fileName);

   var metafile: TGdiPlusAPI.TGdipMetafilePtr;

   TGdiplusAPI.GdipRecordMetafileFileName(PWideChar(UnicodeString(filename)), referenceHdc, TGdiPlusAPI.TGdipEmfTypeEnum(type_),  nil, TGdiPlusAPI.TGdipMetafileFrameUnitEnum.Gdi, PWideChar(UnicodeString(description)), metafile).ThrowIfFailed();

   SetNativeImage(TGdiPlusAPI.TGdipImagePtr(metafile));
end;

constructor TGdipMetafile.Create(const fileName: string; const referenceHdc: TDeviceContextHandle; const frameRect: TRectangle; const frameUnit: TGdipMetafileFrameUnit; const type_: TGdipEmfType; const description: string);
begin
   // Chamado para emular o comportamento de exceção relacionado a caminhos de arquivo inválidos.
   TPath.GetFullPath(fileName);

   var rect: TRectangleF := TRectangleF(frameRect);
   var metafile: TGdiPlusAPI.TGdipMetafilePtr;
   var f: PWideChar := PWideChar(UnicodeString(fileName));
   var d: PWideChar := PWideChar(UnicodeString(description));

   TGdiplusAPI.GdipRecordMetafileFileName(f, referenceHdc, TGdiPlusAPI.TGdipEmfTypeEnum(type_), TLogicalUtils.IfElse(frameRect.IsEmpty, nil, @rect), TGdiPlusAPI.TGdipMetafileFrameUnitEnum(frameUnit), d, metafile).ThrowIfFailed();

   SetNativeImage(TGdiPlusAPI.TGdipImagePtr(metafile));
end;

constructor TGdipMetafile.Create(const stream: TStream; const referenceHdc: TDeviceContextHandle; const type_: TGdipEmfType; const description: string);
begin
   if stream = nil then
      raise EArgumentNullException.Create('stream');

   var iStream: IStream := stream.ToIStream(True);
   var metafile: TGdiPlusAPI.TGdipMetafilePtr;
   var d: PWideChar := PWideChar(UnicodeString(description));

   TGdiplusAPI.GdipRecordMetafileStream(iStream, referenceHdc, TGdiPlusAPI.TGdipEmfTypeEnum(type_),  nil , TGdiPlusAPI.TGdipMetafileFrameUnitEnum.Gdi, d, metafile).ThrowIfFailed();

   SetNativeImage(TGdiPlusAPI.TGdipImagePtr(metafile));
end;

constructor TGdipMetafile.Create(const stream: TStream; const referenceHdc: TDeviceContextHandle; const frameRect: TRectangleF; const frameUnit: TGdipMetafileFrameUnit; const type_: TGdipEmfType; const description: string);
begin
   if stream = nil then
      raise EArgumentNullException.Create('stream');

   var iStream: IStream := stream.ToIStream(True);
   var metafile: TGdiPlusAPI.TGdipMetafilePtr;
   var d: PWideChar := PWideChar(UnicodeString(description));

   var rect: TRectangleF := frameRect;

   TGdiplusAPI.GdipRecordMetafileStream(iStream, referenceHdc, TGdiPlusAPI.TGdipEmfTypeEnum(type_), @rect, TGdiPlusAPI.TGdipMetafileFrameUnitEnum(frameUnit), d, metafile).ThrowIfFailed();

   SetNativeImage(TGdiPlusAPI.TGdipImagePtr(metafile));
end;

constructor TGdipMetafile.Create(const stream: TStream; const referenceHdc: TDeviceContextHandle; const frameRect: TRectangle; const frameUnit: TGdipMetafileFrameUnit; const type_: TGdipEmfType; const description: string);
begin
   if stream = nil then
      raise EArgumentNullException.Create('stream');

   var iStream: IStream := stream.ToIStream(True);
   var metafile: TGdiPlusAPI.TGdipMetafilePtr;
   var d: PWideChar := PWideChar(UnicodeString(description));
   var rect: TRectangleF := TRectangleF(frameRect);

   TGdiplusAPI.GdipRecordMetafileStream(iStream, referenceHdc, TGdiPlusAPI.TGdipEmfTypeEnum(type_), TLogicalUtils.IfElse(frameRect.IsEmpty, nil, @rect), TGdiPlusAPI.TGdipMetafileFrameUnitEnum(frameUnit), d, metafile).ThrowIfFailed();


   SetNativeImage(TGdiplusAPI.TGdipImagePtr(metafile));

end;

constructor TGdipMetafile.Create(const ptr: Pointer);
begin
   SetNativeImage(TGdiplusAPI.TGdipImagePtr(ptr));
end;

procedure TGdipMetafile.PlayRecord(const recordType: TGdipEmfPlusRecordType; const flags: Integer; const dataSize: Integer; const data: TArray<Byte>);
begin
   // Used in conjunction with Graphics.EnumerateMetafile to play an EMF+
   // The data must be DWORD aligned if it's an EMF or EMF+.  It must be
   // WORD aligned if it's a WMF.

   var d: PByte := @data[0];
   TGdiplusAPI.GdipPlayMetafileRecord(Self.Pointer, TGdiPlusAPI.TGdipEmfPlusRecordTypeEnum(recordType), UInt32(flags), UInt32(dataSize), d).ThrowIfFailed();
end;

class function TGdipMetafile.GetMetafileHeader(const hmetafile: HMETAFILE; const wmfHeader: TGdipWmfPlaceableFileHeader): TGdipMetafileHeader;
begin
   var header: TGdipMetafileHeader := TGdipMetafileHeader.Create();
   var mf: TGdiPlusAPI.TGdipMetafileHeaderPtr := @header._header;
   var wmf: TGdiPlusAPI.TGdipWmfPlaceableFileHeaderPtr := wmfHeader._header;

   TGdiplusAPI.GdipGetMetafileHeaderFromWmf(hmetafile, wmf, mf).ThrowIfFailed();

   Exit(header);
end;

class function TGdipMetafile.GetMetafileHeader(const henhmetafile: HENHMETAFILE): TGdipMetafileHeader;
begin
   var header: TGdipMetafileHeader := TGdipMetafileHeader.Create();
   var mf: TGdiPlusAPI.TGdipMetafileHeaderPtr := @header._header;

   TGdiplusAPI.GdipGetMetafileHeaderFromEmf(henhmetafile, mf).ThrowIfFailed();

   Exit(header);
end;

class function TGdipMetafile.GetMetafileHeader(const fileName: string): TGdipMetafileHeader;
begin
   // Chamado para emular o comportamento de exceção relacionado a caminhos de arquivo inválidos.
   TPath.GetFullPath(fileName);

   var header: TGdipMetafileHeader := TGdipMetafileHeader.Create();

   var fn: PWideChar := PWideChar(UnicodeString(fileName));

   var mf: TGdiPlusAPI.TGdipMetafileHeaderPtr := @header._header;


      TGdiplusAPI.GdipGetMetafileHeaderFromFile(fn, mf).ThrowIfFailed();


      Exit(header);
end;

class function TGdipMetafile.GetMetafileHeader(const stream: TStream): TGdipMetafileHeader;
begin
   if stream = nil then
      raise EArgumentNullException.Create('stream');

   var header: TGdipMetafileHeader := TGdipMetafileHeader.Create();
   var mf: TGdiPlusAPI.TGdipMetafileHeaderPtr := @header._header;



      var iStream := stream.ToIStream( True );

      TGdiplusAPI.GdipGetMetafileHeaderFromStream(iStream, mf).ThrowIfFailed();


      Exit(header);
end;

function TGdipMetafile.GetMetafileHeader(): TGdipMetafileHeader;
begin
   var header: TGdipMetafileHeader := TGdipMetafileHeader.Create();

   var mf: TGdiPlusAPI.TGdipMetafileHeaderPtr := @header._header;

   TGdiplusAPI.GdipGetMetafileHeaderFromMetafile(Self.Pointer, mf).ThrowIfFailed();

   Exit(header);
end;

function TGdipMetafile.GetHenhmetafile(): HENHMETAFILE;
begin
   var hemf: HENHMETAFILE;

   TGdiplusAPI.GdipGetHemfFromMetafile(Self.Pointer, hemf).ThrowIfFailed();

   Exit(hemf);
end;



{ TGdipMetaHeader }

class constructor TGdipMetaHeader.CreateClass();
begin
end;

class destructor TGdipMetaHeader.DestroyClass();
begin
end;

procedure TGdipMetaHeader.AfterConstruction;
begin
   inherited;
end;

procedure TGdipMetaHeader.BeforeDestruction;
begin
   inherited;
end;

function TGdipMetaHeader.GetType(): Int16;
begin
   Result := Int16(_data.mtType);
end;

procedure TGdipMetaHeader.SetType(const Value: Int16);
begin
   _data.mtType := UInt16(value);
end;

function TGdipMetaHeader.GetHeaderSize(): Int16;
begin
   Result := Int16(_data.mtHeaderSize);
end;

procedure TGdipMetaHeader.SetHeaderSize(const Value: Int16);
begin
   _data.mtHeaderSize := UInt16(value);
end;

function TGdipMetaHeader.GetVersion(): Int16;
begin
   Result := Int16(_data.mtVersion);
end;

procedure TGdipMetaHeader.SetVersion(const Value: Int16);
begin
   _data.mtVersion := UInt16(value);
end;

function TGdipMetaHeader.GetSize(): Integer;
begin
   Result := Integer(_data.mtSize);
end;

procedure TGdipMetaHeader.SetSize(const Value: Integer);
begin
   _data.mtSize := UInt32(value);
end;

function TGdipMetaHeader.GetNoObjects(): Int16;
begin
   Result := Int16(_data.mtNoObjects);
end;

procedure TGdipMetaHeader.SetNoObjects(const Value: Int16);
begin
   _data.mtNoObjects := UInt16(value);
end;

function TGdipMetaHeader.GetMaxRecord(): Integer;
begin
   Result := Integer(_data.mtMaxRecord);
end;

procedure TGdipMetaHeader.SetMaxRecord(const Value: Integer);
begin
   _data.mtMaxRecord := UInt32(value);
end;

function TGdipMetaHeader.GetNoParameters(): Int16;
begin
   Result := Int16(_data.mtNoParameters);
end;

procedure TGdipMetaHeader.SetNoParameters(const Value: Int16);
begin
   _data.mtNoParameters := UInt16(value);
end;

constructor TGdipMetaHeader.Create();
begin

end;

constructor TGdipMetaHeader.Create(const header: TMETAHEADER);
begin
   _data := header;
   ;
end;

{ TGdipMetafileHeader }

class constructor TGdipMetafileHeader.CreateClass();
begin
end;

class destructor TGdipMetafileHeader.DestroyClass();
begin
end;

procedure TGdipMetafileHeader.AfterConstruction;
begin
   inherited;
end;

procedure TGdipMetafileHeader.BeforeDestruction;
begin
   inherited;
end;

function TGdipMetafileHeader.GetType(): TGdipMetafileType;
begin
   Result := TGdipMetafileType(_header.Type_);
end;

function TGdipMetafileHeader.GetMetafileSize(): Integer;
begin
   Result := Integer(_header.Size);
end;

function TGdipMetafileHeader.GetVersion(): Integer;
begin
   Result := Integer(_header.Version);
end;

function TGdipMetafileHeader.GetDpiX(): Single;
begin
   Result := _header.DpiX;
end;

function TGdipMetafileHeader.GetDpiY(): Single;
begin
   Result := _header.DpiY;
end;

function TGdipMetafileHeader.GetBounds(): TRectangle;
begin
   Result := TRectangle.Create(_header.X, _header.Y, _header.Width, _header.Height);
end;

function TGdipMetafileHeader.GetWmfHeader(): TGdipMetaHeader;
begin
   if not IsWmf() then
      raise TGdiplusAPI.TGdipStatusEnum.InvalidParameter.GetException();

   Result := TGdipMetaHeader.Create(_header.Header.WmfHeader);
end;

function TGdipMetafileHeader.GetEmfPlusHeaderSize(): Integer;
begin
   Result := _header.EmfPlusHeaderSize;
end;

function TGdipMetafileHeader.GetLogicalDpiX(): Integer;
begin
   Result := _header.LogicalDpiX;
end;

function TGdipMetafileHeader.GetLogicalDpiY(): Integer;
begin
   Result := _header.LogicalDpiY;
end;

constructor TGdipMetafileHeader.Create();
begin

end;

function TGdipMetafileHeader.IsWmf(): Boolean;
begin
   Result := Ord(TGdiPlusAPI.TGdipMetafileTypeEnum.Wmf) or Ord(TGdiPlusAPI.TGdipMetafileTypeEnum.WmfPlaceable) <> 0;
end;

function TGdipMetafileHeader.IsWmfPlaceable(): Boolean;
begin
   Result := _header.Type_ = TGdiPlusAPI.TGdipMetafileTypeEnum.WmfPlaceable;
end;

function TGdipMetafileHeader.IsEmf(): Boolean;
begin
   Result := _header.Type_ = TGdiPlusAPI.TGdipMetafileTypeEnum.Emf;
end;

function TGdipMetafileHeader.IsEmfOrEmfPlus(): Boolean;
begin
   Result := _header.Type_ in [TGdiPlusAPI.TGdipMetafileTypeEnum.Emf, TGdiPlusAPI.TGdipMetafileTypeEnum.EmfPlusOnly, TGdiPlusAPI.TGdipMetafileTypeEnum.EmfPlusDual];
end;

function TGdipMetafileHeader.IsEmfPlus(): Boolean;
begin
   Result := _header.Type_ in [TGdiPlusAPI.TGdipMetafileTypeEnum.EmfPlusOnly, TGdiPlusAPI.TGdipMetafileTypeEnum.EmfPlusDual];
end;

function TGdipMetafileHeader.IsEmfPlusDual(): Boolean;
begin
   Result := _header.Type_ = TGdiPlusAPI.TGdipMetafileTypeEnum.EmfPlusDual;
end;

function TGdipMetafileHeader.IsEmfPlusOnly(): Boolean;
begin
   Result := _header.Type_ = TGdiPlusAPI.TGdipMetafileTypeEnum.EmfPlusOnly;
end;

function TGdipMetafileHeader.IsDisplay(): Boolean;
begin
   Result := IsEmfPlus() and  (TGdipEmfPlusFlags(_header.EmfPlusFlags)).HasFlag(TGdipEmfPlusFlags.Display);
end;


{ TGdipWmfPlaceableFileHeader }

class constructor TGdipWmfPlaceableFileHeader.CreateClass();
begin
end;

class destructor TGdipWmfPlaceableFileHeader.DestroyClass();
begin
end;

procedure TGdipWmfPlaceableFileHeader.AfterConstruction;
begin
   inherited;
end;

procedure TGdipWmfPlaceableFileHeader.BeforeDestruction;
begin
   inherited;
end;

function TGdipWmfPlaceableFileHeader.GetKey(): Integer;
begin
   Result := Integer(_header.Key);
end;

procedure TGdipWmfPlaceableFileHeader.SetKey(const Value: Integer);
begin
   _header.Key := UInt32(value);
end;

function TGdipWmfPlaceableFileHeader.GetHmf(): Int16;
begin
   Result := _header.Hmf;
end;

procedure TGdipWmfPlaceableFileHeader.SetHmf(const Value: Int16);
begin
   _header.Hmf := value;
end;

function TGdipWmfPlaceableFileHeader.GetBboxLeft(): Int16;
begin
   Result := _header.BoundingBox.Left;
end;

procedure TGdipWmfPlaceableFileHeader.SetBboxLeft(const Value: Int16);
begin
   _header.BoundingBox.Left := value;
end;

function TGdipWmfPlaceableFileHeader.GetBboxTop(): Int16;
begin
   Result := _header.BoundingBox.Top;
end;

procedure TGdipWmfPlaceableFileHeader.SetBboxTop(const Value: Int16);
begin
   _header.BoundingBox.Top := value;
end;

function TGdipWmfPlaceableFileHeader.GetBboxRight(): Int16;
begin
   Result := _header.BoundingBox.Right;
end;

procedure TGdipWmfPlaceableFileHeader.SetBboxRight(const Value: Int16);
begin
   _header.BoundingBox.Right := value;
end;

function TGdipWmfPlaceableFileHeader.GetBboxBottom(): Int16;
begin
   Result := _header.BoundingBox.Bottom;
end;

procedure TGdipWmfPlaceableFileHeader.SetBboxBottom(const Value: Int16);
begin
   _header.BoundingBox.Bottom := value;
end;

function TGdipWmfPlaceableFileHeader.GetInch(): Int16;
begin
   Result := _header.Inch;
end;

procedure TGdipWmfPlaceableFileHeader.SetInch(const Value: Int16);
begin
   _header.Inch := value;
end;

function TGdipWmfPlaceableFileHeader.GetReserved(): Integer;
begin
   Result := Integer(_header.Reserved);
end;

procedure TGdipWmfPlaceableFileHeader.SetReserved(const Value: Integer);
begin
   _header.Reserved := UInt32(value);
end;

function TGdipWmfPlaceableFileHeader.GetChecksum(): Int16;
begin
   Result := _header.Checksum;
end;

procedure TGdipWmfPlaceableFileHeader.SetChecksum(const Value: Int16);
begin
   _header.Checksum := value;
end;

constructor TGdipWmfPlaceableFileHeader.Create();
begin
   _header.Key := $9aC6CDD7;
end;




{ TGdipImage }

function TGdipImage.GetPointer(): TGdiplusAPI.TGdipImagePtr;
begin
   Result := _nativeImage;
end;

//function TGdipImage.GetData(): TReadOnlySpan<Byte>;
//begin
//   Result := _animatedGifRawData;
//end;

function TGdipImage.GetTag(): TObject;
begin
   Result := _userData;
end;

procedure TGdipImage.SetTag(const Value: TObject);
begin
   _userData := value;
end;

function TGdipImage.GetPhysicalDimension(): TSizeF;
begin


   var width: Single;


   var height: Single;


   TGdiplusAPI.GdipGetImageDimension(_nativeImage, @width, @height).ThrowIfFailed();




   Exit(TSizeF.Create(width, height));
end;

function TGdipImage.GetSize(): TSize;
begin
   Result := TSize.Create(Width, Height);
end;

function TGdipImage.GetWidth(): Integer;
begin


   var width: UInt32;

   TGdiplusAPI.GdipGetImageWidth(_nativeImage, @width).ThrowIfFailed();




   Exit(Integer(width));
end;

function TGdipImage.GetHeight(): Integer;
begin


   var height: UInt32;

   TGdiplusAPI.GdipGetImageHeight(_nativeImage, @height).ThrowIfFailed();




   Exit(Integer(height));
end;

function TGdipImage.GetHorizontalResolution(): Single;
begin


   var horzRes: Single;

   TGdiplusAPI.GdipGetImageHorizontalResolution(_nativeImage, @horzRes).ThrowIfFailed();




   Exit(horzRes);
end;

function TGdipImage.GetVerticalResolution(): Single;
begin


   var vertRes: Single;

   TGdiplusAPI.GdipGetImageVerticalResolution(_nativeImage, @vertRes).ThrowIfFailed();




   Exit(vertRes);
end;

function TGdipImage.GetFlags(): Integer;
begin


   var flags: UInt32;

   TGdiplusAPI.GdipGetImageFlags(_nativeImage, @flags).ThrowIfFailed();




   Exit(Integer(flags));
end;

function TGdipImage.GetRawFormat(): TGdipImageFormat;
begin
   var guid: TGuid := Default(TGuid);

   TGdiplusAPI.GdipGetImageRawFormat(_nativeImage, @guid).ThrowIfFailed();

   if _imageFormat <> nil then
   begin
      FreeAndNil(_ImageFormat);
   end;

   _ImageFormat := TGdipImageFormat.Create(guid);

   Result := _ImageFormat;
end;

function TGdipImage.GetPixelFormat(): TGdipPixelFormat;
begin
   var format: Integer;

   var status := TGdiplusAPI.GdipGetImagePixelFormat(Pointer, &format);
   if (status = TGdiplusAPI.TGdipStatusEnum.Ok) then
      Result := TGdipPixelFormat(format)
   else
      Result := TGdipPixelFormat.Undefined;
end;

function TGdipImage.GetPropertyIdList(): TGdipPropertyIdList;
begin
   var count: UInt32;

   TGdiplusAPI.GdipGetPropertyCount(_nativeImage, count).ThrowIfFailed();

   if (count = 0) then
   begin
      Exit(nil);
   end;

   var propid: TArray<TPropID>;
   SetLength(propid, count);

   var pPropid: PInteger := @propid[0];
   TGdiplusAPI.GdipGetPropertyIdList(_nativeImage, count, PUInt32(pPropid)).ThrowIfFailed();

   Exit(propid);
end;

function TGdipImage.GetPropertyItems(): TArray<TGdipPropertyItem>;
var
   i: NativeUInt;
begin
   var totalBufferSize: UInt32;
   var numProperties: UInt32;

   TGdiplusAPI.GdipGetPropertySize(_nativeImage, totalBufferSize, numProperties).ThrowIfFailed();

   if (totalBufferSize = 0) or (numProperties = 0) then
   begin
      Exit(nil);
   end;

   var props: TArray<TGdipPropertyItem>;
   SetLength(props, numProperties);

   var propsbuffer: System.Pointer := TMarshal.AllocHGlobal(totalBufferSize);
   try
      TGdiplusAPI.GdipGetAllPropertyItems(_nativeImage, totalBufferSize, numProperties, propsbuffer).ThrowIfFailed();


      var properties: TGdiPlusAPI.TGdipPropertyItemPtr := TGdiPlusAPI.TGdipPropertyItemPtr(propsbuffer);

      for i := 0 to numProperties - 1 do
      begin
         props[i] := TGdipPropertyItem.FromNative(properties);
         Inc(properties);
      end;
   finally
      TMarshal.FreeHGlobal(propsbuffer);
   end;


   Result := props;
end;

function TGdipImage.GetPalette(): TGdipColorPalette;
begin
   // "size" is total byte size:
   // sizeof(ColorPalette) + (pal->Count-1)*sizeof(ARGB)

   var size: Integer;

   TGdiplusAPI.GdipGetImagePaletteSize(_nativeImage, size).ThrowIfFailed();

   var buffer: System.Pointer := TMarshal.AllocHGlobal(size);
   try
      TGdiplusAPI.GdipGetImagePalette(_nativeImage, buffer, size).ThrowIfFailed();
      Result := TGdipColorPalette.ConvertFromBuffer(buffer);
   finally
      TMarshal.FreeHGlobal(buffer);
   end;
end;

procedure TGdipImage.SetPalette(const Value: TGdipColorPalette);
begin
   var memory: System.Pointer := Value.ConvertToBuffer();

   var status := TGdiplusAPI.GdipSetImagePalette(_nativeImage, memory);

   if (memory <> nil) then
      TMarshal.FreeHGlobal(memory);

   status.ThrowIfFailed();
end;

function TGdipImage.GetFrameDimensionsList(): TArray<TGuid>;
begin


   var count: UInt32;

   TGdiplusAPI.GdipImageGetFrameDimensionsCount(_nativeImage, count).ThrowIfFailed();


//   Assert(count >= 0, 'FrameDimensionsList returns bad count');


   if (count <= 0) then
   begin



         Exit(nil);
   end;



   var guids: TArray<TGuid>;
   SetLength(guids, count);

   TGdiplusAPI.GdipImageGetFrameDimensionsList(_nativeImage, @guids[0], count).ThrowIfFailed();





   Exit(guids);
end;

constructor TGdipImage.Create();
begin
   inherited;
end;

constructor TGdipImage.Create(const nativeImage: TGdiPlusAPI.TGdipImagePtr);
begin
   SetNativeImage(nativeImage);
end;

destructor TGdipImage.Destroy();
begin
   Dispose(True);
   inherited Destroy();
end;

class function TGdipImage.FromFile(const filename: string): TGdipImage;
begin
   Result := FromFile(filename,  False );
end;

class function TGdipImage.FromFile(filename: string; const useEmbeddedColorManagement: Boolean): TGdipImage;
begin
   if (not TFile.Exists(filename)) then
   begin
      // Lança uma exceção mais específica para caminhos inválidos que são nulos ou vazios,
      // contêm caracteres inválidos ou são muito longos.
      filename := TPath.GetFullPath(filename);
      raise EFileNotFoundException.Create(filename);
   end;

   // O GDI+ lerá este arquivo várias vezes. Obtenha o caminho totalmente qualificado
   // para que, se nosso aplicativo alterar o diretório padrão, não ocorra um erro
   filename := TPath.GetFullPath(filename);
   var image: TGdiPlusAPI.TGdipImagePtr := nil;
   var fn: PWideChar := PWideChar(UnicodeString(filename));

   if (useEmbeddedColorManagement) then
   begin
      TGdiplusAPI.GdipLoadImageFromFileICM(fn, image).ThrowIfFailed();
   end
   else
   begin
      TGdiplusAPI.GdipLoadImageFromFile(fn, image).ThrowIfFailed();
   end;

   ValidateImage(image);
   var img: TGdipImage := CreateImageObject(image);
   GetAnimatedGifRawData(img, filename,  nil );

   Exit(img);
end;

class function TGdipImage.FromStream(const stream: TStream): TGdipImage;
begin
   Result := FromStream(stream,  False );
end;

class function TGdipImage.FromStream(const stream: TStream; const useEmbeddedColorManagement: Boolean): TGdipImage;
begin
   Result := FromStream(stream, useEmbeddedColorManagement,  True );
end;

class function TGdipImage.FromStream(const stream: TStream; const useEmbeddedColorManagement: Boolean; const validateImageData: Boolean): TGdipImage;
begin
   if stream = nil then
      raise EArgumentNilException.Create('stream');

   var image: TGdiPlusAPI.TGdipImagePtr := TGdipImage.LoadGdipImageFromStream(stream, useEmbeddedColorManagement);

   if (validateImageData) then
   begin
         ValidateImage(image);
   end;

   var img: TGdipImage := CreateImageObject(image);

   GetAnimatedGifRawData(img,  string.Empty, stream);

   Exit(img);
end;

//function TGdipImage.InitializeFromStream(const stream: TStream): TGdiPlusAPI.TGdipImagePtr;
//begin
//
//   var image: TGdiPlusAPI.TGdipImagePtr := LoadGdipImageFromStream(stream,  False);
//   ValidateImage(image);
//   _nativeImage := image;
//
//   var type_: TGdiPlusAPI.TGdipImageTypeEnum := Default(TGdiPlusAPI.TGdipImageTypeEnum);
//   TGdiplusAPI.GdipGetImageType(_nativeImage, type_).ThrowIfFailed();
//   GetAnimatedGifRawData(Self,  string.Empty, stream);
//
//   Result := image;
//end;

class function TGdipImage.LoadGdipImageFromStream(const stream: TStream; const useEmbeddedColorManagement: Boolean): TGdiPlusAPI.TGdipImagePtr;
begin
   var iStreamAdapter: IStream := TComManagedStream.Create(stream) as IStream;

   Exit(LoadGdipImageFromStream(iStreamAdapter, False));
end;

class function TGdipImage.LoadGdipImageFromStream(const stream: IStream; const useEmbeddedColorManagement: Boolean): TGdiPlusAPI.TGdipImagePtr;
begin


   var image: TGdiPlusAPI.TGdipImagePtr;



   if (useEmbeddedColorManagement) then
   begin


         TGdiplusAPI.GdipLoadImageFromStreamICM(stream, image).ThrowIfFailed();
   end
   else
   begin


         TGdiplusAPI.GdipLoadImageFromStream(stream, image).ThrowIfFailed();
   end;



   Exit(image);
end;

procedure TGdipImage.Dispose();
begin
   Dispose( True );
end;

function TGdipImage.Clone(): TObject;
begin


   var cloneImage: TGdiPlusAPI.TGdipImagePtr;

   TGdiplusAPI.GdipCloneImage(_nativeImage, cloneImage).ThrowIfFailed();

   ValidateImage(cloneImage);




   Exit(CreateImageObject(cloneImage));
end;

procedure TGdipImage.Dispose(const disposing: Boolean);
begin
   if _imageFormat <> nil then
   begin
      FreeAndNil(_ImageFormat);
   end;


   if (_nativeImage = nil) then
   begin
      Exit();
   end;

   try
      try
            // #if DEBUG -> IfDirectiveTrivia
            // Status status = !Gdip.Initialized ? Status.Ok : -> DisabledTextTrivia
            // #endif -> EndIfDirectiveTrivia

            TGdiplusAPI.GdipDisposeImage(_nativeImage);
      except on ex: Exception  do
         begin


//            if (ClientUtils.IsSecurityOrCriticalException(ex)) then
//            begin
//
//
//                  raise ;
//            end;


            Assert(False, 'Exception thrown during Dispose: ' + ex.ToString() + '');
         end;
      end;
   finally

         _nativeImage := nil;
   end;

end;

procedure TGdipImage.Save(const filename: string);
begin
   Save(filename, RawFormat);
end;

procedure TGdipImage.Save(const filename: string; const format: TGdipImageFormat);
begin
   if format = nil then
      raise EArgumentNilException.Create('format');

   var encoder: TGuid := format.Encoder;

   if (encoder.IsEmpty) then
   begin
        encoder := TGdipImageCodecInfoHelper.GetEncoderClsid(TGdiplusAPI.ImageFormatPNG);
   end;

   Save(filename, encoder,  nil );
end;

procedure TGdipImage.Save(const filename: string; const encoder: TGdipImageCodecInfo; const encoderParams: TGdipEncoderParameters);
begin
   Save(filename, encoder.Clsid, encoderParams);
end;

procedure TGdipImage.Save(const filename: string; const encoder: TGuid; const encoderParams: TGdipEncoderParameters);
begin
   if string.IsNullOrEmpty(filename.Trim()) then
      raise EArgumentNilException.Create('filename');

   if (encoder.IsEmpty) then
   begin
      raise EArgumentNilException.Create('encoder');
   end;

   ThrowIfDirectoryDoesntExist(filename);

   var nativeParameters: TGdiPlusAPI.TGdipEncoderParametersPtr := nil;

   if (encoderParams <> nil) then
   begin
      _animatedGifRawData := nil;
      nativeParameters := encoderParams.NativeParams;
   end;

   try
      if (_animatedGifRawData <> nil) and ( IsEqualGUID(RawFormat.Encoder, encoder)) then
      begin
         // Special case for animated gifs. We don't have an encoder for them, so we just write the raw data.
         var fs := TFile.OpenWrite(filename);
         fs.Write(_animatedGifRawData, 0, Length(_animatedGifRawData));
         Exit();
      end;

      TGdiplusAPI.GdipSaveImageToFile(_nativeImage, PWideChar(UnicodeString(filename)), @encoder, nativeParameters).ThrowIfFailed();
   finally
      if (nativeParameters <> nil) then
      begin
       //  TMarshal.FreeHGlobal(nativeParameters);
      end;
   end;
end;

procedure TGdipImage.Save(const stream: TStream; const format: TGdipImageFormat);
begin
   if format = nil then
      raise EArgumentNilException.Create('format');

   Self.Save(stream, format.Encoder, format.Guid,  nil );
end;

procedure TGdipImage.Save(const stream: TMemoryStream);
begin
   var format: TGuid := default(TGUID);
   TGdiplusAPI.GdipGetImageRawFormat(Self.Pointer, @format).ThrowIfFailed();

   var encoder: TGuid := TGdipImageCodecInfoHelper.GetEncoderClsid(format);

   // Jpeg loses data, so we don't want to use it to serialize. We'll use PNG instead.
   // If we don't find an Encoder (for things like Icon), we just switch back to PNG.
   if IsEqualGUID(format, TGdiplusAPI.ImageFormatJPEG) or (encoder.IsEmpty) then
   begin
      format := TGdiplusAPI.ImageFormatPNG;
      encoder := TGdipImageCodecInfoHelper.GetEncoderClsid(format);
   end;

   Save(stream, encoder, format, nil);
end;

procedure TGdipImage.Save(const stream: TStream; encoder: TGuid; const format: TGuid; const encoderParameters: TGdiPlusAPI.TGdipEncoderParametersPtr);
begin
   if stream = nil then
      raise EArgumentNilException.Create('stream');

   if encoder.IsEmpty then
   begin
      raise EArgumentNilException.Create('encoder');
   end;

   if IsEqualGUID(format, TGdiPlusAPI.ImageFormatGIF) and (Length(_animatedGifRawData) > 0)  then
   begin
         stream.WriteData(@_animatedGifRawData[0], Length(_animatedGifRawData));
         Exit();
   end;

   var iStream: IStream := TComManagedStream.Create(stream) as IStream;

   TGdiPlusAPI.GdipSaveImageToStream(Self.Pointer, iStream, encoder, encoderParameters).ThrowIfFailed();

end;

procedure TGdipImage.Save(const filename: string; const format: TGdipImageFormat; const encoderParams: TGdipEncoderParameters);
begin
   Save(filename, TGdipImageCodecInfo.FromFormat(format), encoderParams);
end;


procedure TGdipImage.Save(const stream: TStream; const encoder: TGdipImageCodecInfo; const encoderParams: TGdipEncoderParameters);
begin
   if stream = nil then
      raise EArgumentNilException.Create('format');

//   if encoder = nil then
//      raise EArgumentNilException.Create('encoder');

   var nativeParameters: TGdiPlusAPI.TGdipEncoderParametersPtr := nil;

   if (encoderParams <> nil) then
   begin
      _animatedGifRawData := nil;
      nativeParameters := encoderParams.NativeParams;
   end;

   try
         Self.Save(stream, encoder.Clsid, encoder.FormatID, nativeParameters);
   finally
      if (nativeParameters <> nil) then
      begin
//         TMarshal.FreeHGlobal(nativeParameters);
      end;
   end;

end;

procedure TGdipImage.SaveAdd(const encoderParams: TGdipEncoderParameters);
begin
   var nativeParameters: TGdiPlusAPI.TGdipEncoderParametersPtr := nil;

   if (encoderParams <> nil) then
      nativeParameters := encoderParams.NativeParams;

   _animatedGifRawData := nil;

   try

      TGdiplusAPI.GdipSaveAdd(_nativeImage, nativeParameters).ThrowIfFailed();
   finally
      if (nativeParameters <> nil) then
      begin
//         TMarshal.FreeHGlobal(nativeParameters);
      end;
   end;
end;

procedure TGdipImage.SaveAdd(const image: TGdipImage; const encoderParams: TGdipEncoderParameters);
begin
   if image = nil then
      raise EArgumentNilException.Create('image');

  Assert(Assigned(encoderParams));

   _animatedGifRawData := nil;

   try
      TGdiplusAPI.GdipSaveAddImage(_nativeImage, image._nativeImage, encoderParams.NativeParams).ThrowIfFailed();
   finally
//      if (nativeParameters <> nil) then
//      begin
    //     TMarshal.FreeHGlobal(nativeParameters);
//      end;
   end;

end;

class procedure TGdipImage.ThrowIfDirectoryDoesntExist(const filename: string);
begin
   var directoryPart: string := TPath.GetDirectoryName(filename);

   if (not string.IsNullOrEmpty(directoryPart)) and (not TDirectory.Exists(directoryPart)) then
   begin
      raise EDirectoryNotFoundException.Create('SR.Format(SR.TargetDirectoryDoesNotExist, directoryPart, filename)');
   end;
end;

function TGdipImage.GetImageBounds(): TRectangleF;
begin
   var bounds: TRectangleF := Default(TRectangleF);
   var unit_: TGdiplusAPI.TGdipUnitEnum;

   TGdiplusAPI.GdipGetImageBounds(Self.Pointer, bounds, unit_).ThrowIfFailed();
   Result := bounds;
end;


function TGdipImage.GetBounds(var pageUnit: TGdipGraphicsUnit): TRectangleF;
begin
   // The Unit is hard coded to GraphicsUnit.Pixel in GDI+.

   var bounds: TRectangleF := Self.GetImageBounds();
   pageUnit := TGdipGraphicsUnit.Pixel;

   Exit(bounds);
end;

function TGdipImage.GetThumbnailImage(const thumbWidth: Integer; const thumbHeight: Integer; const callback: TGetThumbnailImageAbort; const callbackData: Pointer): TGdipImage;
begin


   var thumbImage: TGdiPlusAPI.TGdipImagePtr;

   // GDI+ had to ignore the callback as System.Drawing didn't define it correctly so it was eventually removed
   // completely in Windows 7. As such, we don't need to pass it to GDI+.

   TGdiplusAPI.GdipGetImageThumbnail(Self.Pointer, UInt32(thumbWidth), UInt32(thumbHeight), thumbImage, 0,  nil ).ThrowIfFailed();





   Exit(CreateImageObject(thumbImage));
end;

class procedure TGdipImage.ValidateImage(const image: TGdiPlusAPI.TGdipImagePtr);
begin
   try
         TGdiplusAPI.GdipImageForceValidation(image).ThrowIfFailed();
    except on E: Exception do
      begin

         TGdiplusAPI.GdipDisposeImage(image);

         raise ;
      end;
   end;

end;

function TGdipImage.GetFrameCount(const dimension: TGdipFrameDimension): Integer;
begin


   var dimensionID: TGuid := dimension.Guid;


   var count: UInt32;

   TGdiplusAPI.GdipImageGetFrameCount(_nativeImage, @dimensionID, count).ThrowIfFailed();




   Exit(Integer(count));
end;

function TGdipImage.GetPropertyItem(const propid: Integer): TGdipPropertyItem;
begin
   var size: UInt32;

   TGdiplusAPI.GdipGetPropertyItemSize(_nativeImage, UInt32(propid), @size).ThrowIfFailed();

   if (size = 0) then
   begin
      Exit(Default(TGdipPropertyItem));
   end;

   var buffer: System.Pointer := TMarshal.AllocHGlobal(Integer(size));
   try
      var b: PByte := buffer;

         var property_: TGdiPlusAPI.TGdipPropertyItemPtr := TGdiPlusAPI.TGdipPropertyItemPtr(b);

         TGdiplusAPI.GdipGetPropertyItem(_nativeImage, UInt32(propid), size, property_).ThrowIfFailed();

         Exit(TGdipPropertyItem.FromNative(property_));
   finally
      TMarshal.FreeHGlobal(buffer);
   end;
end;

function TGdipImage.SelectActiveFrame(const dimension: TGdipFrameDimension; const frameIndex: Integer): Integer;
begin


   var dimensionID: TGuid := dimension.Guid;

   TGdiplusAPI.GdipImageSelectActiveFrame(_nativeImage, @dimensionID, UInt32(frameIndex)).ThrowIfFailed();




   Exit(0);
end;

procedure TGdipImage.SetPropertyItem(const propitem: TGdipPropertyItem);
begin

   var propItemValue: PByte := propitem.Value;

   var native: TGdiPlusAPI.TGdipNativePropertyItem := Default(TGdiPlusAPI.TGdipNativePropertyItem);
   native.id := UInt32(propitem.Id);
   native.length := UInt32(propitem.Length);
   native.type_ := UInt16(propitem.ValueType);
   native.value := propItemValue;

   TGdiplusAPI.GdipSetPropertyItem(_nativeImage, @native).ThrowIfFailed();
end;

procedure TGdipImage.RotateFlip(const rotateFlipType: TGdipRotateFlipType);
begin

   TGdiplusAPI.GdipImageRotateFlip(_nativeImage, TGdiPlusAPI.TGdipRotateFlipTypeEnum(rotateFlipType)).ThrowIfFailed();


end;

procedure TGdipImage.RemovePropertyItem(const propid: Integer);
begin
   TGdiplusAPI.GdipRemovePropertyItem(_nativeImage, UInt32(propid)).ThrowIfFailed();
end;

function TGdipImage.GetEncoderParameterList(const encoder: TGuid): TGdipEncoderParameters;
var
  Size: Cardinal;
  Params: TGdiplusAPI.TGdipEncoderParametersPtr;
begin
  Size := 0;
  Params := nil;
  try
    if (TGdiplusAPI.GdipGetEncoderParameterListSize(_nativeImage, @encoder, Size) = TGdiplusAPI.TGdipStatusEnum.Ok) and (Size > 0) then
    begin
      GetMem(Params, Size);
      TGdiplusAPI.GdipGetEncoderParameterList(_nativeImage, @Encoder, Size, Params).ThrowIfFailed;
    end;

    Result := TGdipEncoderParameters.Create(Params);
  finally
    FreeMem(Params);
  end;
end;

class function TGdipImage.FromHbitmap(const hbitmap: HBITMAP): TGdipBitmap;
begin
   Result := FromHbitmap(hbitmap, 0);
end;

class function TGdipImage.FromHbitmap(const hbitmap: HBITMAP; const hpalette: HPALETTE): TGdipBitmap;
begin
   var bitmap: TGdiPlusAPI.TGdipBitmapPtr;

   TGdiplusAPI.GdipCreateBitmapFromHBITMAP(hbitmap, hpalette, bitmap).ThrowIfFailed();

   Exit(TGdipBitmap.Create(bitmap));
end;

class function TGdipImage.IsExtendedPixelFormat(const pixfmt: TGdipPixelFormat): Boolean;
begin
   Result := Ord(pixfmt) and Ord(TGdipPixelFormat.Extended) <> 0;
end;

class function TGdipImage.IsCanonicalPixelFormat(const pixfmt: TGdipPixelFormat): Boolean;
begin
   // Canonical formats:
   //
   //  PixelFormat32bppARGB
   //  PixelFormat32bppPARGB
   //  PixelFormat64bppARGB
   //  PixelFormat64bppPARGB



   Exit((Ord(pixfmt) and Ord(TGdipPixelFormat.Canonical)) <> 0);
end;

procedure TGdipImage.SetNativeImage(const handle: TGdiPlusAPI.TGdipImagePtr);
begin
   if (handle = nil) then
   begin
      raise EArgumentException.Create('SR.NativeHandle0, nameof(handle)');
   end;


   _nativeImage := handle;
end;

class function TGdipImage.GetPixelFormatSize(const pixfmt: TGdipPixelFormat): Integer;
begin
   Result := (Integer(pixfmt) shr 8) and $FF;
end;

class function TGdipImage.IsAlphaPixelFormat(const pixfmt: TGdipPixelFormat): Boolean;
begin
   Result := (Ord(pixfmt) and Ord(TGdipPixelFormat.Alpha)) <> 0;
end;

class function TGdipImage.CreateImageObject(const nativeImage: TGdiPlusAPI.TGdipImagePtr): TGdipImage;
begin
   var imageType: TGdiPlusAPI.TGdipImageTypeEnum := Default(TGdiPlusAPI.TGdipImageTypeEnum);

   TGdiplusAPI.GdipGetImageType(nativeImage, imageType);

      case (imageType) of
         TGdiPlusAPI.TGdipImageTypeEnum.Bitmap:
            Result := TGdipBitmap.Create(nativeImage);
         TGdiPlusAPI.TGdipImageTypeEnum.Metafile:
            Result := TGdipMetafile.Create(nativeImage);
      else
         raise EArgumentException.Create('SR.InvalidImage');
      end;
end;

class procedure TGdipImage.GetAnimatedGifRawData(const image: TGdipImage; const filename: string; dataStream: TStream);
begin

   if (not image.RawFormat.Equals(TGdipImageFormat.Gif)) then
   begin
      Exit();
   end;

   var animatedGif: Boolean := false;
   var dimensions: UInt32;

   TGdiplusAPI.GdipImageGetFrameDimensionsCount(image._nativeImage, dimensions).ThrowIfFailed();

   if (dimensions <= 0) then
   begin
      Exit();
   end;

   var guids: TArray<TGuid>;
   SetLength(guids, dimensions);
   TGdiplusAPI.GdipImageGetFrameDimensionsList(image._nativeImage, @guids[0], dimensions).ThrowIfFailed();

   var timeGuid: TGuid := TGdipFrameDimension.Time.Guid;

   for var i: Integer := 0 to dimensions - 1 do
   begin
      if IsEqualGUID(timeGuid, guids[i]) then
      begin
         animatedGif := image.GetFrameCount(TGdipFrameDimension.Time) > 1;
         Break;
      end;
   end;

   if (not animatedGif) then
   begin
      Exit();
   end;

   try
         var created: TFileStream := nil;
         var lastPos: Int64 := 0;
         if (dataStream <> nil) then
         begin
               lastPos := dataStream.Position;
               dataStream.Position := 0;
         end;

         try
               if (dataStream = nil) then
               begin
                     if string.IsNullOrEmpty(filename.Trim) then
                        raise EInvalidOperation.Create('filename invalido.');

                     created := TFile.OpenRead(filename);
                     dataStream := created;
               end;

               SetLength(image._animatedGifRawData, dataStream.Size);

               dataStream.Read(image._animatedGifRawData, 0, Integer(dataStream.Size));
         finally
               if (created <> nil) then
               begin
                     created.Free();
               end
               else
               begin
                  dataStream.Position := lastPos;
               end;
         end;

   except on e: Exception do
   end;

end;

{ TGdipImageExtensions }

function TGdipImageExtensions.Pointer(): TGdiplusAPI.TGdipImagePtr;
begin
   if Self = nil then
      Result := nil
   else
      Result := self._nativeImage;
end;

























{ TGdipFrameDimension }

class constructor TGdipFrameDimension.CreateClass();
begin
   s_time := TGdipFrameDimension.Create(TGuid.Create('{6aedbd6d-3fb5-418a-83a6-7f45229dc872}'));
   s_resolution := TGdipFrameDimension.Create(TGuid.Create('{84236f7b-3bd3-428f-8dab-4ea1439ca315}'));
   s_page := TGdipFrameDimension.Create(TGuid.Create('{7462dc86-6180-4c7e-8e3f-ee7333a7a483}'));
end;

class destructor TGdipFrameDimension.DestroyClass();
begin
   FreeAndNil(s_time);
   FreeAndNil(s_resolution);
   FreeAndNil(s_page);
end;

procedure TGdipFrameDimension.AfterConstruction;
begin
   inherited;
end;

procedure TGdipFrameDimension.BeforeDestruction;
begin
   inherited;
end;

function TGdipFrameDimension.GetGuid(): TGuid;
begin

   Exit(_guid);
end;

class function TGdipFrameDimension.GetTime(): TGdipFrameDimension;
begin

   Exit(s_time);
end;

class function TGdipFrameDimension.GetResolution(): TGdipFrameDimension;
begin

   Exit(s_resolution);
end;

class function TGdipFrameDimension.GetPage(): TGdipFrameDimension;
begin

   Exit(s_page);
end;

constructor TGdipFrameDimension.Create(const guid: TGuid);
begin

   _guid := guid;

end;

function TGdipFrameDimension.Equals(o: TObject): Boolean;
begin
   var format: TGdipFrameDimension := o as TGdipFrameDimension;

   if (format = nil) then
   begin
      Exit(false);
   end;

   Exit(IsEqualGUID(_guid, format._guid));
end;

function TGdipFrameDimension.ToString(): string;
begin


   if (Self = s_time) then
   begin

      Exit('Time');
   end;


   if (Self = s_resolution) then
   begin

      Exit('Resolution');
   end;


   if (Self = s_page) then
   begin

      Exit('Page');
   end;


   Exit('[FrameDimension: ' + _guid.ToString() + ']');
end;


{ TGdipEncoderParameters }

constructor TGdipEncoderParameters.Create(const Params: TGdiplusAPI.TGdipEncoderParametersPtr);
var
  Param: TGdiplusAPI.TGdipEncoderParameterPtr;
  I: Integer;
begin
   inherited Create;
   if Assigned(Params) then
   begin
      SetLength(m_params, Params.Count);
      if (Params.Count > 0) then
      begin
         Param := @Params.Parameter[0];
         for I := 0 to Params.Count - 1 do
         begin
            Add(Param.Guid, Param.NumberOfValues, TGdipEncoderParameterValueType(Param.ValueType), Param.Value);
            Inc(Param);
         end;
      end;
   end;
end;

destructor TGdipEncoderParameters.Destroy();
begin
   FreeMem(m_nativeParams);
   FreeMem(m_values);
   inherited Destroy();
end;

procedure TGdipEncoderParameters.Clear();
begin
  m_paramCount := 0;
  m_valueSize := 0;
  m_modified := True;
end;

procedure TGdipEncoderParameters.Add(const ParamType: TGUID; var Value: Int64);
var
  Value32: Int32;
begin
  Value32 := Value;
  Add(ParamType, 1, TGdipEncoderParameterValueType.ValueTypeLong, @Value32);
end;

procedure TGdipEncoderParameters.Add(const ParamType: TGUID;
  const Value: array of Int32);
begin
  Assert(Length(Value) > 0);
  Add(ParamType, Length(Value), TGdipEncoderParameterValueType.ValueTypeLong, @Value[0]);
end;

procedure TGdipEncoderParameters.Add(const ParamType: TGUID; const Value: String);
var
  AnsiValue: AnsiString;
begin
  {$WARNINGS OFF}
  AnsiValue := AnsiString(Value);
  {$WARNINGS ON}
  Assert(Length(AnsiValue) > 0);
  Add(ParamType, Length(AnsiValue) + 1, TGdipEncoderParameterValueType.ValueTypeASCII, @AnsiValue[1]);
end;

procedure TGdipEncoderParameters.Add(const ParamType: TGUID;
  const Value: array of Int64);
var
  Value32: array of Int32;
  I: Integer;
begin
  Assert(Length(Value) > 0);
  SetLength(Value32, Length(Value));
  for I := 0 to Length(Value) - 1 do
    Value32[I] := Value[I];
  Add(ParamType, Length(Value), TGdipEncoderParameterValueType.ValueTypeLong, @Value32[0]);
end;

procedure TGdipEncoderParameters.Add(const ParamType: TGUID; var Value: Int32);
begin
  Add(ParamType, 1, TGdipEncoderParameterValueType.ValueTypeLong, @Value);
end;

procedure TGdipEncoderParameters.Add(const ParamType: TGUID;
  const Value: array of Byte);
begin
  Assert(Length(Value) > 0);
  Add(ParamType, Length(Value), TGdipEncoderParameterValueType.ValueTypeByte, @Value[0]);
end;

procedure TGdipEncoderParameters.Add(const ParamType: TGUID; var Value: Byte);
begin
  Add(ParamType, 1, TGdipEncoderParameterValueType.ValueTypeByte, @Value);
end;

procedure TGdipEncoderParameters.Add(const ParamType: TGUID;
  const Value: array of Int16);
begin
  Assert(Length(Value) > 0);
  Add(ParamType, Length(Value), TGdipEncoderParameterValueType.ValueTypeShort, @Value[0]);
end;

procedure TGdipEncoderParameters.Add(const ParamType: TGUID; var Value: Int16);
begin
  Add(ParamType, 1, TGdipEncoderParameterValueType.ValueTypeShort, @Value);
end;

procedure TGdipEncoderParameters.Add(const ParamType: TGUID;
  const NumberOfValues: Integer; const ValueType: TGdipEncoderParameterValueType;
  const Value: Pointer);
var
  ValueSize: Integer;
  ValuePtr: PByte;
begin
  m_modified := True;
  if (m_ParamCount >= Length(m_Params)) then
    SetLength(m_Params, m_ParamCount + 4);

  case ValueType of
    TGdipEncoderParameterValueType.ValueTypeByte,
    TGdipEncoderParameterValueType.ValueTypeASCII,
    TGdipEncoderParameterValueType.ValueTypeUndefined:
      ValueSize := 1;
    TGdipEncoderParameterValueType.ValueTypeShort:
      ValueSize := 2;
    TGdipEncoderParameterValueType.ValueTypeLong:
      ValueSize := 4;
    TGdipEncoderParameterValueType.ValueTypeRational,
    TGdipEncoderParameterValueType.ValueTypeLongRange:
      ValueSize := 8;
    TGdipEncoderParameterValueType.ValueTypeRationalRange:
      ValueSize := 16;
    TGdipEncoderParameterValueType.ValueTypePointer:
      ValueSize := 1;
  else
    begin
      ValueSize := 1;
    end;
  end;
  ValueSize := ValueSize * NumberOfValues;
  if ((m_ValueSize + ValueSize) > m_ValueAllocated) then
  begin
    m_ValueAllocated := m_ValueSize + ValueSize + 64;
    ReallocMem(m_Values, m_ValueAllocated);
  end;
  ValuePtr := m_Values;
  Inc(ValuePtr, m_ValueSize);
  Inc(m_ValueSize, ValueSize);
  Move(Value^, ValuePtr^, ValueSize);

  m_Params[m_ParamCount].Guid := ParamType;
  m_Params[m_ParamCount].NumberOfValues := NumberOfValues;
  m_Params[m_ParamCount].ValueType := TGdiplusAPI.TGdipNativeEncoderParameterValueType(ValueType);
  m_Params[m_ParamCount].Value := ValuePtr;

  Inc(m_ParamCount);
end;

procedure TGdipEncoderParameters.Add(const ParamType: TGUID; const RangesBegin,
  RangesEnd: array of Int64);
var
  Ranges: array of Int32;
  I: Integer;
begin
  Assert(Length(RangesBegin) > 0);
  Assert(Length(RangesBegin) = Length(RangesEnd));
  SetLength(Ranges, Length(RangesBegin) * 2);
  for I := 0 to Length(RangesBegin) - 1 do
  begin
    Ranges[I * 2 + 0] := RangesBegin[I];
    Ranges[I * 2 + 1] := RangesEnd[I];
  end;
  Add(ParamType, Length(RangesBegin), TGdipEncoderParameterValueType.ValueTypeLongRange, @Ranges[0]);
end;

procedure TGdipEncoderParameters.Add(const ParamType: TGUID; const Numerator1,
  Denominator1, Numerator2, Denominator2: array of Int32);
var
  Values: array of Int32;
  I: Integer;
begin
  Assert(Length(Numerator1) > 0);
  Assert(Length(Numerator1) = Length(Numerator2));
  Assert(Length(Numerator1) = Length(Denominator1));
  Assert(Length(Numerator1) = Length(Denominator2));
  SetLength(Values, Length(Numerator1) * 4);
  for I := 0 to Length(Numerator1) - 1 do
  begin
    Values[I * 4 + 0] := Numerator1[I];
    Values[I * 4 + 1] := Denominator1[I];
    Values[I * 4 + 2] := Numerator2[I];
    Values[I * 4 + 3] := Denominator2[I];
  end;
  Add(ParamType, Length(Numerator1), TGdipEncoderParameterValueType.ValueTypeRationalRange, @Values[0]);
end;

procedure TGdipEncoderParameters.Add(const ParamType: TGUID;
  const Value: array of TGdipEncoderValue);
begin
  Assert(Length(Value) > 0);
  Add(ParamType, Length(Value), TGdipEncoderParameterValueType.ValueTypeLong, @Value[0]);
end;

procedure TGdipEncoderParameters.Add(const ParamType: TGUID;
  const Value: TGdipEncoderValue);
begin
  Add(ParamType, 1, TGdipEncoderParameterValueType.ValueTypeLong, @Value);
end;

constructor TGdipEncoderParameters.Create;
begin
  inherited Create;
end;

procedure TGdipEncoderParameters.Add(const ParamType: TGUID; const Numerator1,
  Denominator1, Numerator2, Denominator2: Int32);
var
  Values: array [0..3] of Int32;
begin
  Values[0] := Numerator1;
  Values[1] := Denominator1;
  Values[2] := Numerator2;
  Values[3] := Denominator2;
  Add(ParamType, 1, TGdipEncoderParameterValueType.ValueTypeRationalRange, @Values[0]);
end;

procedure TGdipEncoderParameters.Add(const ParamType: TGUID; var RangeBegin,
  RangeEnd: Int64);
var
  Values: array [0..1] of Int32;
begin
  Values[0] := RangeBegin;
  Values[1] := RangeEnd;
  Add(ParamType, 1, TGdipEncoderParameterValueType.ValueTypeLongRange, @Values[0]);
end;

procedure TGdipEncoderParameters.Add(const ParamType: TGUID;
  const Value: array of Byte; const Undefined: Boolean);
begin
  Assert(Length(Value) > 0);
  if (Undefined) then
    Add(ParamType, Length(Value), TGdipEncoderParameterValueType.ValueTypeUndefined, @Value[0])
  else
    Add(ParamType, Length(Value), TGdipEncoderParameterValueType.ValueTypeByte, @Value[0]);
end;

procedure TGdipEncoderParameters.Add(const ParamType: TGUID; const Value: Byte;
  const Undefined: Boolean);
begin
  if (Undefined) then
    Add(ParamType, 1, TGdipEncoderParameterValueType.ValueTypeUndefined, @Value)
  else
    Add(ParamType, 1, TGdipEncoderParameterValueType.ValueTypeByte, @Value);
end;

procedure TGdipEncoderParameters.Add(const ParamType: TGUID; const Numerators,
  Denominators: array of Int32);
var
  Values: array of Int32;
  I: Integer;
begin
  Assert(Length(Numerators) > 0);
  Assert(Length(Numerators) = Length(Denominators));
  SetLength(Values, Length(Numerators) * 2);
  for I := 0 to Length(Numerators) - 1 do
  begin
    Values[I * 2 + 0] := Numerators[I];
    Values[I * 2 + 1] := Denominators[I];
  end;
  Add(ParamType, Length(Numerators), TGdipEncoderParameterValueType.ValueTypeRational, @Values[0]);
end;

procedure TGdipEncoderParameters.Add(const ParamType: TGUID; var Numerator,
  Denominator: Int32);
var
  Values: array [0..1] of Int32;
begin
  Values[0] := Numerator;
  Values[1] := Denominator;
  Add(ParamType, 1, TGdipEncoderParameterValueType.ValueTypeRational, @Values[0]);
end;

function TGdipEncoderParameters.GetCount: Integer;
begin
  Result := m_ParamCount;
end;

function TGdipEncoderParameters.GetNativeParams: TGdiplusAPI.TGdipEncoderParametersPtr;
begin
  if (m_NativeParams = nil) or (m_Modified) then
  begin
    ReallocMem(m_NativeParams, 4 + m_ParamCount * SizeOf(TGdiplusAPI.TGdipNativeEncoderParameter));
    m_NativeParams.Count := m_ParamCount;
    if (m_ParamCount > 0) then
      Move(m_Params[0], m_NativeParams.Parameter[0], m_ParamCount * SizeOf(TGdiplusAPI.TGdipNativeEncoderParameter));
    m_Modified := False;
  end;
  Result := m_NativeParams;
end;

function TGdipEncoderParameters.GetParam(const Index: Integer): TGdiplusAPI.TGdipNativeEncoderParameterPtr;
begin
  Result := @m_Params[Index];
end;

{ TGdipEncoderParameter }

class function TGdipEncoderParameter.Add(a: Pointer; b: Integer): Pointer;
begin
   Result := Pointer(IntPtr(a) + IntPtr(b));
end;

//class function TGdipEncoderParameter.Add(a: Integer; b: Pointer): Pointer;
//begin
//   Result := Pointer(IntPtr(a) + IntPtr(b));
//end;

function TGdipEncoderParameter.GetEncoder(): TGdipEncoder;
begin
   Result := TGdipEncoder.Create(_parameterGuid);
end;

procedure TGdipEncoderParameter.SetEncoder(const Value: TGdipEncoder);
begin
   _parameterGuid := value.Guid;
end;

function TGdipEncoderParameter.GetValueType(): TGdipEncoderParameterValueType;
begin
   Result := _parameterValueType;
end;

function TGdipEncoderParameter.GetNumberOfValues(): Integer;
begin
   Result := _numberOfValues;
end;

constructor TGdipEncoderParameter.Create(const encoder: TGdipEncoder; const value: Byte);
begin
   _parameterGuid := encoder.Guid;

   _parameterValueType := TGdipEncoderParameterValueType.ValueTypeByte;
   _numberOfValues := 1;
   _parameterValue :=  TMarshal.AllocHGlobal(SizeOf(Byte));

   PByte(_parameterValue)^ := value;
end;

constructor TGdipEncoderParameter.Create(const encoder: TGdipEncoder; const value: Byte; const undefined: Boolean);
begin

   _parameterGuid := encoder.Guid;



   if (undefined) then
      _parameterValueType := TGdipEncoderParameterValueType.ValueTypeUndefined
   else
      _parameterValueType := TGdipEncoderParameterValueType.ValueTypeByte;


   _numberOfValues := 1;

   _parameterValue := AllocMem(SizeOf(Byte));

   PByte(_parameterValue)^ := value;

end;

constructor TGdipEncoderParameter.Create(const encoder: TGdipEncoder; const value: Int16);
begin
   _parameterGuid := encoder.Guid;
   _parameterValueType := TGdipEncoderParameterValueType.ValueTypeShort;
   _numberOfValues := 1;
   _parameterValue := AllocMem(SizeOf(Int16));
   PInt16(_parameterValue)^ := value;
end;

constructor TGdipEncoderParameter.Create(const encoder: TGdipEncoder; const value: Int64);
begin

   _parameterGuid := encoder.Guid;


   _parameterValueType := TGdipEncoderParameterValueType.ValueTypeLong;

   _numberOfValues := 1;

   _parameterValue := AllocMem(SizeOf(Integer));


   PInteger(_parameterValue)^ := Integer(value);



end;

constructor TGdipEncoderParameter.Create(const encoder: TGdipEncoder; const numerator: Integer; const denominator: Integer);
begin
   _parameterGuid := encoder.Guid;
   _parameterValueType := TGdipEncoderParameterValueType.ValueTypeRational;
   _numberOfValues := 1;
   _parameterValue := AllocMem(2 * SizeOf(Integer));
   raise ENotImplemented.Create('Ainda não fiz isso aqui! TODO:');

   //PInt32(_parameterValue)[0] := numerator;
   //PInt32(_parameterValue)[1] := denominator;
end;

constructor TGdipEncoderParameter.Create(const encoder: TGdipEncoder; const rangebegin: Int64; const rangeend: Int64);
begin
   _parameterGuid := encoder.Guid;
   _parameterValueType := TGdipEncoderParameterValueType.ValueTypeLongRange;
   _numberOfValues := 1;
   _parameterValue := AllocMem(2 * SizeOf(Integer));

         raise ENotImplemented.Create('Ainda não fiz isso aqui! TODO:');

   //PInt32(_parameterValue)[0] := Integer(rangebegin);
   //PInt32(_parameterValue)[1] := Integer(rangeend);
end;

constructor TGdipEncoderParameter.Create(const encoder: TGdipEncoder; const numerator1: Integer; const demoninator1: Integer; const numerator2: Integer; const demoninator2: Integer);
begin
   _parameterGuid := encoder.Guid;
   _parameterValueType := TGdipEncoderParameterValueType.ValueTypeRationalRange;
   _numberOfValues := 1;
   _parameterValue := AllocMem(4 * SizeOf(Integer));

         raise ENotImplemented.Create('Ainda não fiz isso aqui! TODO:');

   //PInt32(_parameterValue)[0] := numerator1;
   //PInt32(_parameterValue)[1] := demoninator1;
   //PInt32(_parameterValue)[2] := numerator2;
   //PInt32(_parameterValue)[3] := demoninator2;
end;

constructor TGdipEncoderParameter.Create(const encoder: TGdipEncoder; const value: string);
begin

   _parameterGuid := encoder.Guid;

   _parameterValueType := TGdipEncoderParameterValueType.ValueTypeAscii;

   _numberOfValues := value.Length;

   _parameterValue := TMarshal.StringToHGlobalAnsi(value);



end;

constructor TGdipEncoderParameter.Create(const encoder: TGdipEncoder; const value: TArray<Byte>);
begin
   _parameterGuid := encoder.Guid;

   _parameterValueType := TGdipEncoderParameterValueType.ValueTypeByte;
   _numberOfValues := Length(value);

   _parameterValue := AllocMem(_numberOfValues);

   TMarshal.Copy(value, 0, _parameterValue, _numberOfValues);
end;

constructor TGdipEncoderParameter.Create(const encoder: TGdipEncoder; const value: TArray<Byte>; const undefined: Boolean);
begin
   _parameterGuid := encoder.Guid;

   if (undefined) then
      _parameterValueType := TGdipEncoderParameterValueType.ValueTypeUndefined
   else
      _parameterValueType := TGdipEncoderParameterValueType.ValueTypeByte;

   _numberOfValues := Length(value);
   _parameterValue := AllocMem(_numberOfValues);

   TMarshal.Copy(value, 0, _parameterValue, _numberOfValues);
end;

constructor TGdipEncoderParameter.Create(const encoder: TGdipEncoder; const value: TArray<Int16>);
begin
   _parameterGuid := encoder.Guid;

   _parameterValueType := TGdipEncoderParameterValueType.ValueTypeShort;
   _numberOfValues := Length(value);
   _parameterValue := AllocMem(checked(_numberOfValues * SizeOf(Int16)));

   TMarshal.Copy(value, 0, _parameterValue, _numberOfValues);
end;

constructor TGdipEncoderParameter.Create(const encoder: TGdipEncoder; const value: TArray<Int64>);
begin
   _parameterGuid := encoder.Guid;

   _parameterValueType := TGdipEncoderParameterValueType.ValueTypeLong;
   _numberOfValues := Length(value);
   _parameterValue := AllocMem(checked(_numberOfValues * SizeOf(Integer)));

   var dest: PInteger := PInteger(_parameterValue);
   var source: PInt64 := @value[0];

   for var i: Int32 := 0 to Length(value) - 1 do
   begin
     dest[i] := Int32(source[i]);
   end;
end;

constructor TGdipEncoderParameter.Create(const encoder: TGdipEncoder; const numerator: TArray<Integer>; const denominator: TArray<Integer>);
begin
   _parameterGuid := encoder.Guid;

   if (Length(numerator) <> Length(denominator)) then
   begin
      raise TGdiplusAPI.TGdipStatusEnum.InvalidParameter.GetException();
   end;

   _parameterValueType := TGdipEncoderParameterValueType.ValueTypeRational;
   _numberOfValues := Length(numerator);
   _parameterValue := AllocMem(checked(_numberOfValues * 2 * SizeOf(Integer)));

   for var i: Int32 := 0 to _numberOfValues -1 do
   begin
            raise ENotImplemented.Create('Ainda não fiz isso aqui! TODO:');

      //PInt32(_parameterValue)[i * 2 + 0] := numerator[i];
      //PInt32(_parameterValue)[i * 2 + 1] := denominator[i];
   end;
end;

constructor TGdipEncoderParameter.Create(const encoder: TGdipEncoder; const rangebegin: TArray<Int64>; const rangeend: TArray<Int64>);
begin
   _parameterGuid := encoder.Guid;

   if Length(rangebegin) <> Length(rangeend) then
   begin
      raise TGdiplusAPI.TGdipStatusEnum.InvalidParameter.GetException();
   end;

   _parameterValueType := TGdipEncoderParameterValueType.ValueTypeLongRange;
   _numberOfValues := Length(rangebegin);
   _parameterValue := AllocMem(checked(_numberOfValues * 2 * SizeOf(Integer)));

   for var i: Int32 := 0 to _numberOfValues -1 do
   begin
            raise ENotImplemented.Create('Ainda não fiz isso aqui! TODO:');

      //PInt32(_parameterValue)[i * 2 + 0] := Integer(rangebegin[i]);
      //PInt32(_parameterValue)[i * 2 + 1] := Integer(rangeend[i]);
   end;
end;

constructor TGdipEncoderParameter.Create(const encoder: TGdipEncoder; const numerator1: TArray<Integer>; const denominator1: TArray<Integer>; const numerator2: TArray<Integer>; const denominator2: TArray<Integer>);
begin
   _parameterGuid := encoder.Guid;

   if (Length(numerator1) <> Length(denominator1)) or (Length(numerator1) <> Length(denominator2)) or (Length(denominator1) <> Length(denominator2)) then
   begin
      raise TGdiplusAPI.TGdipStatusEnum.InvalidParameter.GetException();
   end;

   _parameterValueType := TGdipEncoderParameterValueType.ValueTypeRationalRange;
   _numberOfValues := Length(numerator1);
   _parameterValue := AllocMem(checked(_numberOfValues * 4 * SizeOf(Integer)));

   for var i: Int32 := 0 to _numberOfValues -1 do
   begin
            raise ENotImplemented.Create('Ainda não fiz isso aqui! TODO:');

      //PInt32(_parameterValue)[i * 4 + 0] := numerator1[i];
      //PInt32(_parameterValue)[i * 4 + 1] := denominator1[i];
      //PInt32(_parameterValue)[i * 4 + 2] := numerator2[i];
      //PInt32(_parameterValue)[i * 4 + 3] := denominator2[i];
   end;
end;

constructor TGdipEncoderParameter.Create(const encoder: TGuid; const NumberOfValues: Integer; const Type_: Integer; const Value: Integer);
begin
   var size: Integer;
                            case (TGdipEncoderParameterValueType(Type_)) of
                               TGdipEncoderParameterValueType.ValueTypeByte,
                               TGdipEncoderParameterValueType.ValueTypeAscii:
                                  size := 1;
                               TGdipEncoderParameterValueType.ValueTypeShort:
                                  size := 2;
                               TGdipEncoderParameterValueType.ValueTypeLong:
                                  size := 4;
                               TGdipEncoderParameterValueType.ValueTypeRational,
                               TGdipEncoderParameterValueType.ValueTypeLongRange:
                                  size := 2 * 4;
                               TGdipEncoderParameterValueType.ValueTypeUndefined:
                                  size := 1;
                               TGdipEncoderParameterValueType.ValueTypeRationalRange:
                                  size := 2 * 2 * 4;
                            else
                               raise TGdiplusAPI.TGdipStatusEnum.WrongState.GetException();
                            end;


   var bytes: Integer := checked(size * NumberOfValues);
   _parameterValue := AllocMem(bytes);

   for var i: Int32 := 0 to bytes - 1 do
   begin
      TMarshal.WriteByte(Add(_parameterValue, i), TMarshal.ReadByte(Pointer(Value + i)));
   end;

   _parameterValueType := TGdipEncoderParameterValueType(Type_);
   _numberOfValues := NumberOfValues;
   _parameterGuid := encoder;
end;

constructor TGdipEncoderParameter.Create(const encoder: TGuid; const numberValues: Integer; const valueType: TGdipEncoderParameterValueType; const value: Pointer);
begin
   var ValueSize: Integer;

   case (valueType) of
      TGdipEncoderParameterValueType.ValueTypeByte,
      TGdipEncoderParameterValueType.ValueTypeAscii,
      TGdipEncoderParameterValueType.ValueTypeUndefined:
         ValueSize := 1;
      TGdipEncoderParameterValueType.ValueTypeShort:
         ValueSize := 2;
      TGdipEncoderParameterValueType.ValueTypeLong:
         ValueSize := 4;
      TGdipEncoderParameterValueType.ValueTypeRational,
      TGdipEncoderParameterValueType.ValueTypeLongRange:
         ValueSize := 8;
      TGdipEncoderParameterValueType.ValueTypeRationalRange:
         ValueSize := 16;
      TGdipEncoderParameterValueType.ValueTypePointer:
         ValueSize := 1;
   else
      ValueSize := 1;
   end;

   ValueSize := ValueSize * numberValues;

   _parameterValue := AllocMem(ValueSize);

   for var i: Int32 := 0 to ValueSize - 1 do
   begin
       TMarshal.WriteByte(Add(_parameterValue, i), TMarshal.ReadByte(Pointer(NativeInt(value) + i)));
   end;

   _parameterValueType := valueType;
   _numberOfValues := numberValues;
   _parameterGuid := encoder;
end;

destructor TGdipEncoderParameter.Destroy();
begin
   Dispose(True);
   inherited Destroy();
end;

//function TGdipEncoderParameter.ToNative(): TGdiPlusAPI.TGdipNativeEncoderParameter;
//begin
//   Result := Default(TGdiPlusAPI.TGdipNativeEncoderParameter);
//   Result.Guid := _parameterGuid;
//   Result.ValueType := TGdiPlusAPI.TGdipNativeEncoderParameterValueType(_parameterValueType);
//   Result.NumberOfValues := UInt32(_numberOfValues);
//   Result.Value := Pointer(_parameterValue);
//end;

procedure TGdipEncoderParameter.Dispose();
begin
   Dispose( True );
end;

procedure TGdipEncoderParameter.Dispose(const disposing: Boolean);
begin
   if (_parameterValue <> nil) then
   begin
      FreeMem(_parameterValue);
   end;

   _parameterValue := nil;
end;













{ TGdipEncoder }

class constructor TGdipEncoder.CreateClass();
begin
   Compression := TGdipEncoder.Create(TGUID.Create('{e09d739d-ccd4-44ee-8eba-3fbf8be4fc58}'));
   ColorDepth := TGdipEncoder.Create(TGUID.Create('{66087055-ad66-4c7c-9a18-38a2310b8337}'));
   ScanMethod := TGdipEncoder.Create(TGUID.Create('{3a4e2661-3109-4e56-8536-42c156e7dcfa}'));
   Version := TGdipEncoder.Create(TGUID.Create('{24d18c76-814a-41a4-bf53-1c219cccf797}'));
   RenderMethod := TGdipEncoder.Create(TGUID.Create('{6d42c53a-229a-4825-8bb7-5c99e2b9a8b8}'));
   Quality := TGdipEncoder.Create(TGUID.Create('{1d5be4b5-fa4a-452d-9cdd-5db35105e7eb}'));
   Transformation := TGdipEncoder.Create(TGUID.Create('{8d0eb2d1-a58e-4ea8-aa14-108074b7b6f9}'));
   LuminanceTable := TGdipEncoder.Create(TGUID.Create('{edb33bce-0266-4a77-b904-27216099e717}'));
   ChrominanceTable := TGdipEncoder.Create(TGUID.Create('{f2e455dc-09b3-4316-8260-676ada32481c}'));
   SaveFlag := TGdipEncoder.Create(TGUID.Create('{292266fc-ac40-47bf-8cfc-a85b89a655de}'));
   ColorSpace := TGdipEncoder.Create(TGUID.Create('{ae7a62a0-ee2c-49d8-9d07-1ba8a927596e}'));
   ImageItems := TGdipEncoder.Create(TGUID.Create('{63875e13-1f1d-45ab-9195-a29b6066a650}'));
   SaveAsCMYK := TGdipEncoder.Create(TGUID.Create('{a219bbc9-0a9d-4005-a3ee-3a421b8bb06c}'));
end;

class destructor TGdipEncoder.DestroyClass();
begin
   FreeAndNil(Compression);
   FreeAndNil(ColorDepth);
   FreeAndNil(ScanMethod);
   FreeAndNil(Version);
   FreeAndNil(RenderMethod);
   FreeAndNil(Quality);
   FreeAndNil(Transformation);
   FreeAndNil(LuminanceTable);
   FreeAndNil(ChrominanceTable);
   FreeAndNil(SaveFlag);
   FreeAndNil(ColorSpace);
   FreeAndNil(ImageItems);
   FreeAndNil(SaveAsCMYK);
end;

constructor TGdipEncoder.Create(const guid: TGuid);
begin
   m_guid := guid;
end;

{ TGdipImageCodecInfo }

class function TGdipImageCodecInfo.GetImageDecoders(): TArray<TGdipImageCodecInfo>;
begin
   var imageCodecs: TGdiplusAPI.TGdipImageCodecInfoPtr;
   var numDecoders: UInt32;
   var size: UInt32;

   TGdiplusAPI.GdipGetImageDecodersSize(numDecoders, size).ThrowIfFailed();
    GetMem(imageCodecs, size);
    try
      TGdiplusAPI.GdipGetImageDecoders(numDecoders, size, imageCodecs).ThrowIfFailed();
      Result := FromNative(imageCodecs, numDecoders);
    finally
      FreeMem(imageCodecs);
    end;
end;

class function TGdipImageCodecInfo.GetImageEncoders(): TArray<TGdipImageCodecInfo>;
begin
   var imageCodecs: TGdiplusAPI.TGdipImageCodecInfoPtr;
   var numDecoders: UInt32 := 0;
   var size: UInt32 := 0;

   TGdiplusAPI.GdipGetImageEncodersSize(numDecoders, size).ThrowIfFailed();
   if (numDecoders > 0) then
   begin
      GetMem(imageCodecs, size);
      try
         TGdiplusAPI.GdipGetImageEncoders(numDecoders, size, imageCodecs).ThrowIfFailed();
         Result := FromNative(imageCodecs, numDecoders);
      finally
         FreeMem(imageCodecs);
      end;
   end
   else
      Result := nil;
end;

class function TGdipImageCodecInfo.FromNative(const codecsInfos: TGdiPlusAPI.TGdipImageCodecInfoPtr; const numCodecs: UInt32): TArray<TGdipImageCodecInfo>;
var
   codecs: TArray<TGdipImageCodecInfo>;
   signatureCount: Integer;
   codec: TGdipImageCodecInfo;

   SigMask: TArray<Byte>;
   SignatureMasks: TArray<TArray<Byte>>;

   SigPattern: TArray<Byte>;
   SignaturePatterns: TArray<TArray<Byte>>;

   codecp: TGdiPlusAPI.TGdipImageCodecInfoPtr;
begin
   SetLength(codecs, numCodecs);
   codecp := codecsInfos;

   for var index: Integer := 0 to numCodecs - 1 do
   begin
      signatureCount := Integer(codecp.SigCount);
      SetLength(SignatureMasks, signatureCount);
      SetLength(SignaturePatterns, signatureCount);

      codec := Default(TGdipImageCodecInfo);
      codec.Clsid := codecp^.Clsid;
      codec.FormatID := codecp^.FormatID;
      codec.CodecName := StrPas(codecp^.CodecName);
      codec.DllName := StrPas(codecp^.DllName);
      codec.FormatDescription := StrPas(codecp^.FormatDescription);
      codec.FilenameExtension := StrPas(codecp^.FilenameExtension);
      codec.MimeType := StrPas(codecp^.MimeType);
      codec.Flags := TGdipImageCodecFlags(codecp^.Flags);
      codec.Version := Integer(codecp^.Version);

      for var j: UInt32 := 0 to signatureCount - 1 do
      begin
         SetLength(SigMask, Integer(codecp^.SigSize));
         SetLength(SigPattern, Integer(codecp^.SigSize));

         CopyMemory(SigMask, (codecp^.SigMask + (j * codecp^.SigSize)), codecp^.SigSize);
         CopyMemory(SigPattern, (codecp^.SigPattern + (j * codecp^.SigSize)), codecp^.SigSize);

         SignatureMasks[j] := SigMask;
         SignaturePatterns[j] := SigPattern;
      end;

      codec.SignatureMasks := SignatureMasks;
      codec.SignaturePatterns := SignaturePatterns;
      codecs[index] := codec;
      Inc(codecp);
   end;

   Result := codecs;
end;

class function TGdipImageCodecInfo.FromFormat(const format: TGdipImageFormat): TGdipImageCodecInfo;
begin
   var codecs: TArray<TGdipImageCodecInfo> := TGdipImageCodecInfo.GetImageEncoders();

   for var codec in codecs do
   begin
      if codec.FormatID = format.Guid then
      begin
         Exit(codec);
      end;
   end;

   raise EArgumentException.Create('format');

end;


{ TGdipImageFormat }

class constructor TGdipImageFormat.CreateClass();
var
  I, Count, Size: Cardinal;
  List, Info: TGdiplusAPI.TGdipImageCodecInfoPtr;
begin
   TGdiplusAPI.GdipGetImageEncodersSize(Count, Size).ThrowIfFailed();
   if (Size > 0) then
   begin
      GetMem(List, Size);
      try
         TGdiplusAPI.GdipGetImageEncoders(Count, Size, List).ThrowIfFailed();
         Info := List;

         for I := 0 to Count - 1 do
         begin
            if IsEqualGUID(Info.FormatId, TGdiplusAPI.ImageFormatMemoryBMP) then
               s_memoryBMP := TGdipImageFormat.Create(Info.FormatId, Info.ClsId)
            else if IsEqualGUID(Info.FormatId, TGdiplusAPI.ImageFormatBMP) then
               s_bmp := TGdipImageFormat.Create(Info.FormatId, Info.ClsId)
            else if IsEqualGUID(Info.FormatId, TGdiplusAPI.ImageFormatEMF) then
               s_emf := TGdipImageFormat.Create(Info.FormatId, Info.ClsId)
            else if IsEqualGUID(Info.FormatId, TGdiplusAPI.ImageFormatWMF) then
               s_wmf := TGdipImageFormat.Create(Info.FormatId, Info.ClsId)
            else if IsEqualGUID(Info.FormatId, TGdiplusAPI.ImageFormatJPEG) then
               s_Jpeg := TGdipImageFormat.Create(Info.FormatId, Info.ClsId)
            else if IsEqualGUID(Info.FormatId, TGdiplusAPI.ImageFormatPNG) then
               s_Png := TGdipImageFormat.Create(Info.FormatId, Info.ClsId)
            else if IsEqualGUID(Info.FormatId, TGdiplusAPI.ImageFormatGIF) then
               s_Gif := TGdipImageFormat.Create(Info.FormatId, Info.ClsId)
            else if IsEqualGUID(Info.FormatId, TGdiplusAPI.ImageFormatTIFF) then
               s_Tiff := TGdipImageFormat.Create(Info.FormatId, Info.ClsId)
            else if IsEqualGUID(Info.FormatId, TGdiplusAPI.ImageFormatEXIF) then
               s_exif := TGdipImageFormat.Create(Info.FormatId, Info.ClsId)
            else if IsEqualGUID(Info.FormatId, TGdiplusAPI.ImageFormatIcon) then
               s_icon := TGdipImageFormat.Create(Info.FormatId, Info.ClsId)
            else if IsEqualGUID(Info.FormatId, TGdiplusAPI.ImageFormatHEIF) then
               s_heif := TGdipImageFormat.Create(Info.FormatId, Info.ClsId)
            else if IsEqualGUID(Info.FormatId, TGdiplusAPI.ImageFormatWEBP) then
               s_webp := TGdipImageFormat.Create(Info.FormatId, Info.ClsId);

            Inc(Info);
         end;
      finally
         FreeMem(List);
      end;
   end;

//   Assert(Assigned(s_memoryBMP));
   Assert(Assigned(s_bmp));
//   Assert(Assigned(s_emf));
//   Assert(Assigned(s_wmf));
   Assert(Assigned(s_jpeg));
   Assert(Assigned(s_png));
   Assert(Assigned(s_gif));
   Assert(Assigned(s_tiff));
//   Assert(Assigned(s_exif));
//   Assert(Assigned(s_icon));
   Assert(Assigned(s_heif));
//   Assert(Assigned(s_webp));
end;

class destructor TGdipImageFormat.DestroyClass();
begin
   FreeAndNil(s_memoryBMP);
   FreeAndNil(s_bmp);
   FreeAndNil(s_emf);
   FreeAndNil(s_wmf);
   FreeAndNil(s_jpeg);
   FreeAndNil(s_png);
   FreeAndNil(s_gif);
   FreeAndNil(s_tiff);
   FreeAndNil(s_exif);
   FreeAndNil(s_icon);
   FreeAndNil(s_heif);
   FreeAndNil(s_webp);
end;

function TGdipImageFormat.GetGuid(): TGuid;
begin
   Result := _guid;
end;

class function TGdipImageFormat.GetMemoryBmp(): TGdipImageFormat;
begin
   Result := s_memoryBMP;
end;

class function TGdipImageFormat.GetBmp(): TGdipImageFormat;
begin
   Result := s_bmp;
end;

class function TGdipImageFormat.GetEmf(): TGdipImageFormat;
begin
   Result := s_emf;
end;

class function TGdipImageFormat.GetWmf(): TGdipImageFormat;
begin
   Result := s_wmf;
end;

class function TGdipImageFormat.GetGif(): TGdipImageFormat;
begin
   Result := s_gif;
end;

class function TGdipImageFormat.GetJpeg(): TGdipImageFormat;
begin
   Result := s_jpeg;
end;

class function TGdipImageFormat.GetPng(): TGdipImageFormat;
begin
   Result := s_png;
end;

class function TGdipImageFormat.GetTiff(): TGdipImageFormat;
begin
   Result := s_tiff;
end;

class function TGdipImageFormat.GetExif(): TGdipImageFormat;
begin
   Result := s_exif;
end;

class function TGdipImageFormat.GetIcon(): TGdipImageFormat;
begin
   Result := s_icon;
end;

class function TGdipImageFormat.GetHeif(): TGdipImageFormat;
begin
   Result := s_heif;
end;

class function TGdipImageFormat.GetWebp(): TGdipImageFormat;
begin
   Result := s_webp;
end;

function TGdipImageFormat.GetEncoder(): TGuid;
begin
   Result := TGdipImageCodecInfoHelper.GetEncoderClsid(_guid);
end;

constructor TGdipImageFormat.Create(const guid: TGuid);
begin
   _guid := guid;
end;

constructor TGdipImageFormat.Create(const guid, codecId: TGUID);
begin
   _guid := guid;
   _codecId := codecId;
end;


function TGdipImageFormat.Equals(o: TObject): Boolean;
begin
   Result := (o is TGdipImageFormat) and IsEqualGUID(TGdipImageFormat(o)._guid, _guid);
end;

function TGdipImageFormat.ToString(): string;
begin


   if IsEqualGUID(Guid, TGdiplusAPI.ImageFormatMemoryBMP) then
   begin

      Exit('MemoryBMP');
   end;


   if IsEqualGUID(Guid, TGdiplusAPI.ImageFormatBMP) then
   begin

      Exit('Bmp');
   end;


   if IsEqualGUID(Guid, TGdiplusAPI.ImageFormatEMF) then
   begin

      Exit('Emf');
   end;


   if IsEqualGUID(Guid, TGdiplusAPI.ImageFormatWMF) then
   begin

      Exit('Wmf');
   end;


   if IsEqualGUID(Guid, TGdiplusAPI.ImageFormatGIF) then
   begin

      Exit('Gif');
   end;


   if IsEqualGUID(Guid, TGdiplusAPI.ImageFormatJPEG) then
   begin

      Exit('Jpeg');
   end;


   if IsEqualGUID(Guid, TGdiplusAPI.ImageFormatPNG) then
   begin

      Exit('Png');
   end;


   if IsEqualGUID(Guid, TGdiplusAPI.ImageFormatTIFF) then
   begin

      Exit('Tiff');
   end;


   if IsEqualGUID(Guid, TGdiplusAPI.ImageFormatEXIF) then
   begin

      Exit('Exif');
   end;


   if IsEqualGUID(Guid, TGdiplusAPI.ImageFormatIcon) then
   begin

      Exit('Icon');
   end;


   if IsEqualGUID(Guid, TGdiplusAPI.ImageFormatHEIF) then
   begin

      Exit('Heif');
   end;


   if IsEqualGUID(Guid, TGdiplusAPI.ImageFormatWEBP) then
   begin

      Exit('Webp');
   end;


   Exit('[ImageFormat: ' + _guid.ToString() + ']');
end;



{ TGdipRegionData }

constructor TGdipRegionData.Create(const data: TArray<Byte>);
begin
   m_data := data;
end;


{ TGdipRegion }

function TGdipRegion.GetPointer(): TGdiplusAPI.TGdipRegionPtr;
begin
   Result := NativeRegion;
end;

constructor TGdipRegion.Create();
begin
   var region: TGdiplusAPI.TGdipRegionPtr;

   CheckStatus(TGdiplusAPI.GdipCreateRegion(region));
   SetNativeRegion(region);
end;

constructor TGdipRegion.Create(const rect: TRectangleF);
begin
   var region: TGdiplusAPI.TGdipRegionPtr := nil;

   var rectF: TRectangleF := rect;

   CheckStatus(TGdiplusAPI.GdipCreateRegionRect(&rectF, &region));

   SetNativeRegion(region);

end;

constructor TGdipRegion.Create(const rect: TRectangle);
begin
   Create(TRectangleF(rect));


end;

constructor TGdipRegion.Create(const path: TGdipGraphicsPath);
begin
   if path = nil then
      raise EArgumentNilException.Create('path');

   var region: TGdiplusAPI.TGdipRegionPtr := nil;
   CheckStatus(TGdiplusAPI.GdipCreateRegionPath(path._nativePath, region));
   SetNativeRegion(region);
end;

constructor TGdipRegion.Create(const rgnData: TGdipRegionData);
begin
   if rgnData = nil then
      raise EArgumentNilException.Create('rgnData');

   var region: TGdiplusAPI.TGdipRegionPtr := nil;
   CheckStatus(TGdiplusAPI.GdipCreateRegionRgnData(@rgnData.Data[0], Length(rgnData.Data), region));

   SetNativeRegion(region);
end;

constructor TGdipRegion.Create(const nativeRegion: TGdiplusAPI.TGdipRegionPtr);
begin
   SetNativeRegion(nativeRegion);
end;

destructor TGdipRegion.Destroy();
begin
   Dispose( True );
   inherited Destroy();
end;

class function TGdipRegion.FromHrgn(const hrgn: HRGN): TGdipRegion;
begin
   var region: TGdiplusAPI.TGdipRegionPtr := nil;
   TGdip.CheckStatus(TGdiplusAPI.GdipCreateRegionHrgn(hrgn, region));
   Exit(TGdipRegion.Create(region));
end;

procedure TGdipRegion.SetNativeRegion(const ANativeRegion: TGdiplusAPI.TGdipRegionPtr);
begin
   if (ANativeRegion = nil) then
   begin
      raise EArgumentNilException.Create('nativeRegion');
   end;

   Self.NativeRegion := ANativeRegion;
end;

function TGdipRegion.Clone(): TGdipRegion;
begin
   var region: TGdiplusAPI.TGdipRegionPtr := nil;
   CheckStatus(TGdiplusAPI.GdipCloneRegion(NativeRegion, region));
   Exit(TGdipRegion.Create(region));
end;

procedure TGdipRegion.ReleaseHrgn(const regionHandle: HRGN);
begin
   if (regionHandle = 0) then
   begin
      raise EArgumentNilException.Create('regionHandle');
   end;

   Winapi.Windows.DeleteObject(regionHandle);
end;

procedure TGdipRegion.Dispose();
begin
   Dispose( True );
end;

procedure TGdipRegion.Dispose(const disposing: Boolean);
begin
   if (NativeRegion <> nil) then
   begin
      try
         try
               TGdiplusAPI.GdipDeleteRegion(NativeRegion);
         except on ex: Exception do  // when
         end;
      finally
         NativeRegion := nil;
      end;
   end;
end;

procedure TGdipRegion.MakeInfinite();
begin
   CheckStatus(TGdiplusAPI.GdipSetInfinite(NativeRegion));
end;

procedure TGdipRegion.MakeEmpty();
begin
   CheckStatus(TGdiplusAPI.GdipSetEmpty(NativeRegion));
end;

procedure TGdipRegion.Intersect(const rect: TRectangleF);
begin
   CheckStatus(TGdiplusAPI.GdipCombineRegionRect(NativeRegion, @rect, TGdiPlusAPI.TGdipCombineModeEnum.Intersect));
end;

procedure TGdipRegion.Intersect(const rect: TRectangle);
begin
   Intersect(TRectangleF(rect));
end;

procedure TGdipRegion.Intersect(const path: TGdipGraphicsPath);
begin
   if path = nil then
      raise EArgumentNilException.Create('path');

   CheckStatus(TGdiplusAPI.GdipCombineRegionPath(NativeRegion, path._nativePath, TGdiplusAPI.TGdipCombineModeEnum.Intersect));
end;

procedure TGdipRegion.Intersect(const region: TGdipRegion);
begin
   if region = nil then
      raise EArgumentNilException.Create('region');

   CheckStatus(TGdiplusAPI.GdipCombineRegionRegion(NativeRegion, region.NativeRegion, TGdiplusAPI.TGdipCombineModeEnum.Intersect));
end;

procedure TGdipRegion.Union(const rect: TRectangleF);
begin
   CheckStatus(TGdiplusAPI.GdipCombineRegionRect(NativeRegion, @rect, TGdiPlusAPI.TGdipCombineModeEnum.Union));
end;

procedure TGdipRegion.Union(const rect: TRectangle);
begin
   Union(TRectangleF(rect));
end;

procedure TGdipRegion.Union(const path: TGdipGraphicsPath);
begin
   if path = nil then
      raise EArgumentNilException.Create('path');

   CheckStatus(TGdiplusAPI.GdipCombineRegionPath(NativeRegion, path._nativePath, TGdiplusAPI.TGdipCombineModeEnum.Union));
end;

procedure TGdipRegion.Union(const region: TGdipRegion);
begin
   if region = nil then
      raise EArgumentNilException.Create('region');

   CheckStatus(TGdiplusAPI.GdipCombineRegionRegion(NativeRegion, region.NativeRegion, TGdiplusAPI.TGdipCombineModeEnum.Union));
end;

procedure TGdipRegion.Xor_(const rect: TRectangleF);
begin
   CheckStatus(TGdiplusAPI.GdipCombineRegionRect(NativeRegion, @rect, TGdiPlusAPI.TGdipCombineModeEnum.Xor_));
end;

procedure TGdipRegion.Xor_(const rect: TRectangle);
begin
   Xor_(TRectangleF(rect));
end;

procedure TGdipRegion.Xor_(const path: TGdipGraphicsPath);
begin
   if path = nil then
      raise EArgumentNilException.Create('path');

   CheckStatus(TGdiplusAPI.GdipCombineRegionPath(NativeRegion, path._nativePath, TGdiplusAPI.TGdipCombineModeEnum.Xor_));
end;

procedure TGdipRegion.Xor_(const region: TGdipRegion);
begin
   if region = nil then
      raise EArgumentNilException.Create('region');

   CheckStatus(TGdiplusAPI.GdipCombineRegionRegion(NativeRegion, region.NativeRegion, TGdiplusAPI.TGdipCombineModeEnum.Xor_));
end;

procedure TGdipRegion.Exclude(const rect: TRectangleF);
begin
   CheckStatus(TGdiplusAPI.GdipCombineRegionRect(NativeRegion, @rect, TGdiplusAPI.TGdipCombineModeEnum.Exclude));
end;

procedure TGdipRegion.Exclude(const rect: TRectangle);
begin
   Exclude(TRectangleF(rect));
end;

procedure TGdipRegion.Exclude(const path: TGdipGraphicsPath);
begin
   if path = nil then
      raise EArgumentNilException.Create('path');

   CheckStatus(TGdiplusAPI.GdipCombineRegionPath(NativeRegion, path._nativePath, TGdiplusAPI.TGdipCombineModeEnum.Exclude));
end;

procedure TGdipRegion.Exclude(const region: TGdipRegion);
begin
   if region = nil then
      raise EArgumentNilException.Create('region');

   CheckStatus(TGdiplusAPI.GdipCombineRegionRegion(NativeRegion, region.NativeRegion, TGdiplusAPI.TGdipCombineModeEnum.Exclude));
end;

procedure TGdipRegion.Complement(const rect: TRectangleF);
begin
   CheckStatus(TGdiplusAPI.GdipCombineRegionRect(NativeRegion, @rect, TGdiplusAPI.TGdipCombineModeEnum.Complement));
end;

procedure TGdipRegion.Complement(const rect: TRectangle);
begin
   Complement(TRectangleF(rect));
end;

procedure TGdipRegion.Complement(const path: TGdipGraphicsPath);
begin
   if path = nil then
      raise EArgumentNilException.Create('path');

   CheckStatus(TGdiplusAPI.GdipCombineRegionPath(NativeRegion, path._nativePath, TGdiplusAPI.TGdipCombineModeEnum.Complement));
end;

procedure TGdipRegion.Complement(const region: TGdipRegion);
begin
   if region = nil then
      raise EArgumentNilException.Create('region');

   CheckStatus(TGdiplusAPI.GdipCombineRegionRegion(NativeRegion, region.NativeRegion, TGdiplusAPI.TGdipCombineModeEnum.Complement));
end;

procedure TGdipRegion.Translate(const dx: Single; const dy: Single);
begin
   CheckStatus(TGdiplusAPI.GdipTranslateRegion(NativeRegion, dx, dy));
end;

procedure TGdipRegion.Translate(const dx: Integer; const dy: Integer);
begin
   Translate(Single(dx), dy);
end;

procedure TGdipRegion.Transform(const matrix: TGdipMatrix);
begin
   if matrix = nil then
      raise EArgumentNilException.Create('matrix');

   CheckStatus(TGdiplusAPI.GdipTransformRegion(NativeRegion, matrix.NativeMatrix));
end;

function TGdipRegion.GetBounds(const g: TGdipGraphics): TRectangleF;
begin
   if g = nil then
      raise EArgumentNilException.Create('g');

   var bounds: TRectangleF;

   CheckStatus(TGdiplusAPI.GdipGetRegionBounds(NativeRegion, g.NativeGraphics, bounds));

   Exit(bounds);
end;

function TGdipRegion.GetHrgn(const g: TGdipGraphics): HRGN;
begin
   if g = nil then
      raise EArgumentNilException.Create('g');

   var hrgn: HRGN;
   CheckStatus(TGdiplusAPI.GdipGetRegionHRgn(NativeRegion, g.NativeGraphics, &hrgn));

   Exit(hrgn);
end;

function TGdipRegion.IsEmpty(const g: TGdipGraphics): Boolean;
begin
   if g = nil then
      raise EArgumentNilException.Create('g');

   var isEmpty: LongBool;

   CheckStatus(TGdiplusAPI.GdipIsEmptyRegion(NativeRegion, g.NativeGraphics, isEmpty));

   Exit(isEmpty);
end;

function TGdipRegion.IsInfinite(const g: TGdipGraphics): Boolean;
begin
   if g = nil then
      raise EArgumentNilException.Create('g');

   var isInfinite: LongBool;

   CheckStatus(TGdiplusAPI.GdipIsInfiniteRegion(NativeRegion, g.NativeGraphics, isInfinite));

   Exit(isInfinite);
end;

function TGdipRegion.Equals(const region: TGdipRegion; const g: TGdipGraphics): Boolean;
begin
   if region = nil then
      raise EArgumentNilException.Create('region');

   if g = nil then
      raise EArgumentNilException.Create('g');

   var isEqual: LongBool;

   CheckStatus(TGdiplusAPI.GdipIsEqualRegion(NativeRegion, region.NativeRegion, g.NativeGraphics, isEqual));

   Exit(isEqual);
end;

function TGdipRegion.GetRegionData(): TGdipRegionData;
begin
   var regionSize: UInt32;

   CheckStatus(TGdiplusAPI.GdipGetRegionDataSize(NativeRegion, regionSize));

   if (regionSize = 0) then
   begin
      Exit(nil);
   end;

   var regionData: TArray<Byte>;
   SetLength(regionData, regionSize);

   CheckStatus(TGdiplusAPI.GdipGetRegionData(NativeRegion, @regionData[0], regionSize, regionSize));

   Exit(TGdipRegionData.Create(regionData));
end;

function TGdipRegion.IsVisible(const x: Single; const y: Single): Boolean;
begin
   Result := IsVisible(TPointF.Create(x, y),  nil );
end;

function TGdipRegion.IsVisible(const point: TPointF): Boolean;
begin
   Result := IsVisible(point,  nil );
end;

function TGdipRegion.IsVisible(const x: Single; const y: Single; const g: TGdipGraphics): Boolean;
begin
   Result := IsVisible(TPointF.Create(x, y), g);
end;

function TGdipRegion.IsVisible(const point: TPointF; const g: TGdipGraphics): Boolean;
begin
   var isVisible: LongBool;

   if g = nil then
      CheckStatus(TGdiplusAPI.GdipIsVisibleRegionPoint(NativeRegion, point.X, point.Y, nil, isVisible))
   else
      CheckStatus(TGdiplusAPI.GdipIsVisibleRegionPoint(NativeRegion, point.X, point.Y, g.NativeGraphics, isVisible));

   Exit(isVisible);
end;

function TGdipRegion.IsVisible(const x: Single; const y: Single; const width: Single; const height: Single): Boolean;
begin
   Result := IsVisible(TRectangleF.Create(x, y, width, height),  nil );
end;

function TGdipRegion.IsVisible(const rect: TRectangleF): Boolean;
begin
   Result := IsVisible(rect,  nil );
end;

function TGdipRegion.IsVisible(const x: Single; const y: Single; const width: Single; const height: Single; const g: TGdipGraphics): Boolean;
begin
   Result := IsVisible(TRectangleF.Create(x, y, width, height), g);
end;

function TGdipRegion.IsVisible(const rect: TRectangleF; const g: TGdipGraphics): Boolean;
begin
   var isVisible: LongBool;

   if g = nil then
      CheckStatus(TGdiplusAPI.GdipIsVisibleRegionRect(NativeRegion, rect.X, rect.Y, rect.Width, rect.Height, nil, isVisible))
   else
      CheckStatus(TGdiplusAPI.GdipIsVisibleRegionRect(NativeRegion, rect.X, rect.Y, rect.Width, rect.Height, g.NativeGraphics, isVisible));

   Exit(isVisible);
end;

function TGdipRegion.IsVisible(const x: Integer; const y: Integer; const g: TGdipGraphics): Boolean;
begin
   Result := IsVisible(TPoint.Create(x, y), g);
end;

function TGdipRegion.IsVisible(const point: TPoint): Boolean;
begin
   Result := IsVisible(point,  nil );
end;

function TGdipRegion.IsVisible(const point: TPoint; const g: TGdipGraphics): Boolean;
begin
   Result := IsVisible(TPointF(point), g);
end;

function TGdipRegion.IsVisible(const x: Integer; const y: Integer; const width: Integer; const height: Integer): Boolean;
begin
   Result := IsVisible(TRectangle.Create(x, y, width, height),  nil );
end;

function TGdipRegion.IsVisible(const rect: TRectangle): Boolean;
begin
   Result := IsVisible(rect,  nil );
end;

function TGdipRegion.IsVisible(const x: Integer; const y: Integer; const width: Integer; const height: Integer; const g: TGdipGraphics): Boolean;
begin
   Result := IsVisible(TRectangle.Create(x, y, width, height), g);
end;

function TGdipRegion.IsVisible(const rect: TRectangle; const g: TGdipGraphics): Boolean;
begin
   Result := IsVisible(TRectangleF(rect), g);
end;

function TGdipRegion.GetRegionScans(const matrix: TGdipMatrix): TArray<TRectangleF>;
begin
   if matrix = nil then
      raise EArgumentNilException.Create('matrix');

   var count: UInt32;

   CheckStatus(TGdiplusAPI.GdipGetRegionScansCount(NativeRegion, count, matrix.NativeMatrix));

   if (count = 0) then
   begin
      Result := [];
      Exit();
   end;

   var rectangles: TArray<TRectangleF>;
   SetLength(rectangles, count);

            CheckStatus(TGdiplusAPI.GdipGetRegionScans(
                NativeRegion,
                @rectangles[0],
                count,
                matrix.NativeMatrix));

   Exit(rectangles);
end;

procedure TGdipRegion.CheckStatus(const status: TGdiplusAPI.TGdipStatusEnum);
begin
   TGdip.CheckStatus(status);
end;


{ TGdipGraphicsPath }

function TGdipGraphicsPath.Pointer(): TGdiplusAPI.TGdipPathPtr;
begin
   Result := _nativePath;
end;

function TGdipGraphicsPath.GetFillMode(): TGdipFillMode;
begin
   var fillMode: TGdiPlusAPI.TGdipFillModeEnum;
   TGdiplusAPI.GdipGetPathFillMode(_nativePath, fillMode).ThrowIfFailed();
   Exit(TGdipFillMode(fillMode));
end;

procedure TGdipGraphicsPath.SetFillMode(const Value: TGdipFillMode);
begin
   if (Value < TGdipFillMode.Alternate) or (Value > TGdipFillMode.Winding) then
   begin
      raise EInvalidArgument.Create('nameof(value), Integer(value), TypeInfo(TGdipFillMode)');
   end;

   TGdiplusAPI.GdipSetPathFillMode(_nativePath, TGdiPlusAPI.TGdipFillModeEnum(value)).ThrowIfFailed();
end;

function TGdipGraphicsPath.GetPathData(): TGdipPathData;
begin
   var count: Integer := PointCount;

   var pathData: TGdipPathData := TGdipPathData.Create();
   SetLength(pathData.m_Types, count);
   SetLength(pathData.m_Points, count);

   if (count = 0) then
   begin
      Exit(pathData);
   end;

   var p: PPointF := @pathData.Points[0];
   var t: PByte := @pathData.Types[0];

   var data: TGdiplusAPI.TGdipNativePathData := Default(TGdiplusAPI.TGdipNativePathData);
   data.Count := count;
   data.Points := p;
   data.Types := t;

   TGdiplusAPI.GdipGetPathData(_nativePath, TGdiPlusAPI.TGdipPathDataPtr(@data)).ThrowIfFailed();

   Result := pathData;
end;

function TGdipGraphicsPath.GetPointCount(): Integer;
begin
   var count: Integer;
   TGdiplusAPI.GdipGetPointCount(_nativePath, count).ThrowIfFailed();
   Exit(count);
end;

function TGdipGraphicsPath.GetPathTypes(): TArray<Byte>;
begin
   var count: Integer := PointCount;

   if (count = 0) then
   begin
      Result := [];
      Exit();
   end;



   var types: TArray<Byte>;
   SetLength(types, count);

   GetPathTypes(types);


   Exit(types);
end;

function TGdipGraphicsPath.GetPathPoints(): TArray<TPointF>;
begin
   var count: Integer := PointCount;

   if (count = 0) then
   begin
      Result := [];
      Exit();
   end;

   var points: TArray<TPointF>;
   SetLength(points, count);

   GetPathPoints(points);


   Exit(points);
end;

constructor TGdipGraphicsPath.Create();
begin
   Create(TGdipFillMode.Alternate);
end;

constructor TGdipGraphicsPath.Create(const fillMode: TGdipFillMode);
begin
   var path: TGdiplusAPI.TGdipPathPtr;
   TGdiplusAPI.GdipCreatePath(TGdiPlusAPI.TGdipFillModeEnum(fillMode), path).ThrowIfFailed();
   _nativePath := path;
end;

constructor TGdipGraphicsPath.Create(const pts: TArray<TPointF>; const types: TArray<Byte>);
begin
   Create(pts, types, TGdipFillMode.Alternate);
end;

constructor TGdipGraphicsPath.Create(const pts: TArray<TPointF>; const types: TArray<Byte>; const fillMode: TGdipFillMode);
begin
   if (pts = nil) or (Length(pts) = 0) then
      raise EArgumentNilException.Create('pts');

   if (types = nil) or (Length(types) = 0) then
      raise EArgumentNilException.Create('types');

   if Length(pts) <> Length(types) then
      raise TGdiplusAPI.TGdipStatusEnum.InvalidParameter.GetException();

   var p: PPointF := @pts[0];
   var t: PByte := @types[0];

   var path: TGdiplusAPI.TGdipPathPtr;
   TGdiplusAPI.GdipCreatePath2(p, t, Length(types), TGdiPlusAPI.TGdipFillModeEnum(fillMode), path).ThrowIfFailed();
   _nativePath := path;
end;

constructor TGdipGraphicsPath.Create(const pts: TArray<TPoint>; const types: TArray<Byte>);
begin
   Create(pts, types, TGdipFillMode.Alternate);
end;

constructor TGdipGraphicsPath.Create(const pts: TArray<TPoint>; const types: TArray<Byte>; const fillMode: TGdipFillMode);
begin
   if (pts = nil) or (Length(pts) = 0) then
      raise EArgumentNilException.Create('pts');

   if (types = nil) or (Length(types) = 0) then
      raise EArgumentNilException.Create('types');

   if Length(pts) <> Length(types) then
      raise TGdiplusAPI.TGdipStatusEnum.InvalidParameter.GetException();


   var p: PPoint := @pts[0];
   var t: PByte := @types[0];

   var path: TGdiplusAPI.TGdipPathPtr;
   TGdiplusAPI.GdipCreatePath2I(p, t, Length(types), TGdiPlusAPI.TGdipFillModeEnum(fillMode), path).ThrowIfFailed();
   _nativePath := path;
end;

constructor TGdipGraphicsPath.Create(const nativePath: TGdiplusAPI.TGdipPathPtr);
begin
   if (nativePath = nil) then
   begin
      raise EArgumentNilException.Create('nativePath');
   end;

   _nativePath := nativePath;
end;

destructor TGdipGraphicsPath.Destroy();
begin
   Dispose( True );
   inherited Destroy();
end;

function TGdipGraphicsPath.Clone(): TObject;
begin
   var path: TGdiplusAPI.TGdipPathPtr;
   TGdiplusAPI.GdipClonePath(_nativePath, path).ThrowIfFailed();
   Exit(TGdipGraphicsPath.Create(path));
end;

procedure TGdipGraphicsPath.Dispose();
begin
   Dispose( True );
end;

procedure TGdipGraphicsPath.Dispose(const disposing: Boolean);
begin


   if (_nativePath <> nil) then
   begin



         try
            try
                  // #if DEBUG -> IfDirectiveTrivia
                  // Status status = !Gdip.Initialized ? Status.Ok : -> DisabledTextTrivia
                  // #endif -> EndIfDirectiveTrivia

                  TGdiplusAPI.GdipDeletePath(_nativePath);
            except on ex: Exception do // when
                  Assert(false, 'Exception thrown during Dispose: ' + ex.ToString() + '');
            end;
         finally

               _nativePath := nil;
         end;

   end;
end;

procedure TGdipGraphicsPath.Reset();
begin
   TGdiplusAPI.GdipResetPath(_nativePath).ThrowIfFailed();
end;

procedure TGdipGraphicsPath.StartFigure();
begin
   TGdiplusAPI.GdipStartPathFigure(_nativePath);
end;

procedure TGdipGraphicsPath.CloseFigure();
begin
   TGdiplusAPI.GdipClosePathFigure(_nativePath).ThrowIfFailed();
end;

procedure TGdipGraphicsPath.CloseAllFigures();
begin
   TGdiplusAPI.GdipClosePathFigures(_nativePath).ThrowIfFailed();
end;

procedure TGdipGraphicsPath.SetMarkers();
begin
   TGdiplusAPI.GdipSetPathMarker(_nativePath).ThrowIfFailed();
end;

procedure TGdipGraphicsPath.ClearMarkers();
begin
   TGdiplusAPI.GdipClearPathMarkers(_nativePath).ThrowIfFailed();
end;

procedure TGdipGraphicsPath.Reverse();
begin
   TGdiplusAPI.GdipReversePath(_nativePath).ThrowIfFailed();
end;

function TGdipGraphicsPath.GetLastPoint(): TPointF;
begin
   var point: TPointF;
   TGdiplusAPI.GdipGetPathLastPoint(_nativePath, point);
   Exit(point);
end;

function TGdipGraphicsPath.IsVisible(const x: Single; const y: Single): Boolean;
begin
   Result := IsVisible(TPointF.Create(x, y),  nil );
end;

function TGdipGraphicsPath.IsVisible(const point: TPointF): Boolean;
begin
   Result := IsVisible(point,  nil );
end;

function TGdipGraphicsPath.IsVisible(const x: Single; const y: Single; const graphics: TGdipGraphics): Boolean;
begin
   var isVisible: LongBool;

   if graphics = nil then
      TGdiplusAPI.GdipIsVisiblePathPoint(_nativePath, x, y, nil, isVisible).ThrowIfFailed()
   else
      TGdiplusAPI.GdipIsVisiblePathPoint(_nativePath, x, y, graphics.NativeGraphics, isVisible).ThrowIfFailed();

   Exit(isVisible);
end;

function TGdipGraphicsPath.IsVisible(const pt: TPointF; const graphics: TGdipGraphics): Boolean;
begin
   Result := IsVisible(pt.X, pt.Y, graphics);
end;

function TGdipGraphicsPath.IsVisible(const x: Integer; const y: Integer): Boolean;
begin
   Result := IsVisible(Single(x), y,  nil );
end;

function TGdipGraphicsPath.IsVisible(const point: TPoint): Boolean;
begin
   Result := IsVisible(TPointF(point),  nil );
end;

function TGdipGraphicsPath.IsVisible(const x: Integer; const y: Integer; const graphics: TGdipGraphics): Boolean;
begin
   Result := IsVisible(Single(x), y, graphics);
end;

function TGdipGraphicsPath.IsVisible(const pt: TPoint; const graphics: TGdipGraphics): Boolean;
begin
   Result := IsVisible(TPointF(pt), graphics);
end;

function TGdipGraphicsPath.IsOutlineVisible(const x: Single; const y: Single; const pen: TGdipPen): Boolean;
begin
   Result := IsOutlineVisible(TPointF.Create(x, y), pen,  nil );
end;

function TGdipGraphicsPath.IsOutlineVisible(const point: TPointF; const pen: TGdipPen): Boolean;
begin
   Result := IsOutlineVisible(point, pen,  nil );
end;

function TGdipGraphicsPath.IsOutlineVisible(const x: Single; const y: Single; const pen: TGdipPen; const graphics: TGdipGraphics): Boolean;
begin
   if pen = nil then
      raise EArgumentNilException.Create('pen');

   var isVisible: LongBool;

   if graphics = nil then
      TGdiplusAPI.GdipIsOutlineVisiblePathPoint(_nativePath, x, y, pen.NativePen, nil, isVisible).ThrowIfFailed()
   else
      TGdiplusAPI.GdipIsOutlineVisiblePathPoint(_nativePath, x, y, pen.NativePen, graphics.NativeGraphics, isVisible).ThrowIfFailed();

   Exit(isVisible);
end;

function TGdipGraphicsPath.IsOutlineVisible(const pt: TPointF; const pen: TGdipPen; const graphics: TGdipGraphics): Boolean;
begin
   Result := IsOutlineVisible(pt.X, pt.Y, pen, graphics);
end;

function TGdipGraphicsPath.IsOutlineVisible(const x: Integer; const y: Integer; const pen: TGdipPen): Boolean;
begin
   Result := IsOutlineVisible(TPoint.Create(x, y), pen,  nil );
end;

function TGdipGraphicsPath.IsOutlineVisible(const point: TPoint; const pen: TGdipPen): Boolean;
begin
   Result := IsOutlineVisible(point, pen,  nil );
end;

function TGdipGraphicsPath.IsOutlineVisible(const x: Integer; const y: Integer; const pen: TGdipPen; const graphics: TGdipGraphics): Boolean;
begin
   Result := IsOutlineVisible(Single(x), y, pen, graphics);
end;

function TGdipGraphicsPath.IsOutlineVisible(const pt: TPoint; const pen: TGdipPen; const graphics: TGdipGraphics): Boolean;
begin
   Result := IsOutlineVisible(TPointF(pt), pen, graphics);
end;

procedure TGdipGraphicsPath.AddLine(const pt1: TPointF; const pt2: TPointF);
begin
   AddLine(pt1.X, pt1.Y, pt2.X, pt2.Y);
end;

procedure TGdipGraphicsPath.AddLine(const x1: Single; const y1: Single; const x2: Single; const y2: Single);
begin
   TGdiplusAPI.GdipAddPathLine(_nativePath, x1, y1, x2, y2).ThrowIfFailed();
end;

procedure TGdipGraphicsPath.AddLines({$IFDEF FPC}constref{$ELSE}const [ref]{$ENDIF} points: TArray<TPointF>);
begin
   if (Length(points) = 0) then
   begin
      raise EArgumentException.Create('points');
   end;

   TGdiplusAPI.GdipAddPathLine2(_nativePath, @points[0], Length(points)).ThrowIfFailed();
end;

procedure TGdipGraphicsPath.AddLine(const pt1: TPoint; const pt2: TPoint);
begin
   AddLine(Single(pt1.X), pt1.Y, pt2.X, pt2.Y);
end;

procedure TGdipGraphicsPath.AddLine(const x1: Integer; const y1: Integer; const x2: Integer; const y2: Integer);
begin
   AddLine(Single(x1), y1, x2, y2);
end;

procedure TGdipGraphicsPath.AddLines({$IFDEF FPC}constref{$ELSE}const [ref]{$ENDIF} points: TArray<TPoint>);
begin
   if (Length(points) = 0) then
   begin
         raise EArgumentException.Create('points');
   end;

   TGdiplusAPI.GdipAddPathLine2I(_nativePath, @points[0], Length(points)).ThrowIfFailed();
end;

procedure TGdipGraphicsPath.AddArc(const rect: TRectangleF; const startAngle: Single; const sweepAngle: Single);
begin
   AddArc(rect.X, rect.Y, rect.Width, rect.Height, startAngle, sweepAngle);
end;

procedure TGdipGraphicsPath.AddArc(const x: Single; const y: Single; const width: Single; const height: Single; const startAngle: Single; const sweepAngle: Single);
begin
   TGdiplusAPI.GdipAddPathArc(_nativePath, x, y, width, height, startAngle, sweepAngle).ThrowIfFailed();
end;

procedure TGdipGraphicsPath.AddArc(const rect: TRectangle; const startAngle: Single; const sweepAngle: Single);
begin
   AddArc(rect.X, rect.Y, rect.Width, rect.Height, startAngle, sweepAngle);
end;

procedure TGdipGraphicsPath.AddArc(const x: Integer; const y: Integer; const width: Integer; const height: Integer; const startAngle: Single; const sweepAngle: Single);
begin
   AddArc(Single(x), y, width, height, startAngle, sweepAngle);
end;

procedure TGdipGraphicsPath.AddBezier(const pt1: TPointF; const pt2: TPointF; const pt3: TPointF; const pt4: TPointF);
begin
   AddBezier(pt1.X, pt1.Y, pt2.X, pt2.Y, pt3.X, pt3.Y, pt4.X, pt4.Y);
end;

procedure TGdipGraphicsPath.AddBezier(const x1: Single; const y1: Single; const x2: Single; const y2: Single; const x3: Single; const y3: Single; const x4: Single; const y4: Single);
begin
   TGdiplusAPI.GdipAddPathBezier(_nativePath, x1, y1, x2, y2, x3, y3, x4, y4).ThrowIfFailed();
end;

procedure TGdipGraphicsPath.AddBeziers({$IFDEF FPC}constref{$ELSE}const [ref]{$ENDIF} points: TArray<TPointF>);
begin
   TGdiplusAPI.GdipAddPathBeziers(_nativePath, @points[0], Length(points)).ThrowIfFailed();
end;

procedure TGdipGraphicsPath.AddBezier(const pt1: TPoint; const pt2: TPoint; const pt3: TPoint; const pt4: TPoint);
begin
   AddBezier(Single(pt1.X), pt1.Y, pt2.X, pt2.Y, pt3.X, pt3.Y, pt4.X, pt4.Y);
end;

procedure TGdipGraphicsPath.AddBezier(const x1: Integer; const y1: Integer; const x2: Integer; const y2: Integer; const x3: Integer; const y3: Integer; const x4: Integer; const y4: Integer);
begin
   AddBezier(Single(x1), y1, x2, y2, x3, y3, x4, y4);
end;

procedure TGdipGraphicsPath.AddBeziers({$IFDEF FPC}constref{$ELSE}const [ref]{$ENDIF} points: TArray<TPoint>);
begin

   if (Length(points) = 0) then
   begin
      Exit();
   end;

   TGdiplusAPI.GdipAddPathBeziersI(_nativePath, @points[0], Length(points)).ThrowIfFailed();
end;

procedure TGdipGraphicsPath.AddCurve({$IFDEF FPC}constref{$ELSE}const [ref]{$ENDIF} points: TArray<TPointF>);
begin
   AddCurve(points, Single(0.5));
end;

procedure TGdipGraphicsPath.AddCurve({$IFDEF FPC}constref{$ELSE}const [ref]{$ENDIF} points: TArray<TPointF>; const tension: Single);
begin
   AddCurve(points, tension);
end;

procedure TGdipGraphicsPath.AddCurve({$IFDEF FPC}constref{$ELSE}const [ref]{$ENDIF} points: TArray<TPointF>; const offset: Integer; const numberOfSegments: Integer; const tension: Single);
begin
            TGdiplusAPI.GdipAddPathCurve3(
                _nativePath,
                @points[0],
                Length(points),
                offset,
                numberOfSegments,
                tension).ThrowIfFailed();
end;

procedure TGdipGraphicsPath.AddCurve({$IFDEF FPC}constref{$ELSE}const [ref]{$ENDIF} points: TArray<TPoint>);
begin
   AddCurve(points, Single(0.5));
end;

procedure TGdipGraphicsPath.AddCurve({$IFDEF FPC}constref{$ELSE}const [ref]{$ENDIF} points: TArray<TPoint>; const tension: Single);
begin
            TGdiplusAPI.GdipAddPathCurve2I(
                _nativePath,
                @points[0],
                Length(points),
                tension).ThrowIfFailed();
end;

procedure TGdipGraphicsPath.AddCurve({$IFDEF FPC}constref{$ELSE}const [ref]{$ENDIF} points: TArray<TPoint>; const offset: Integer; const numberOfSegments: Integer; const tension: Single);
begin
            TGdiplusAPI.GdipAddPathCurve3I(
                _nativePath,
                @points[0],
                Length(points),
                offset,
                numberOfSegments,
                tension).ThrowIfFailed();
end;

procedure TGdipGraphicsPath.AddClosedCurve({$IFDEF FPC}constref{$ELSE}const [ref]{$ENDIF} points: TArray<TPointF>);
begin
   AddClosedCurve(points, Single(0.5));
end;

procedure TGdipGraphicsPath.AddClosedCurve({$IFDEF FPC}constref{$ELSE}const [ref]{$ENDIF} points: TArray<TPointF>; const tension: Single);
begin
   TGdiplusAPI.GdipAddPathClosedCurve2(_nativePath, @points[0], Length(points), tension).ThrowIfFailed();
end;

procedure TGdipGraphicsPath.AddClosedCurve({$IFDEF FPC}constref{$ELSE}const [ref]{$ENDIF} points: TArray<TPoint>);
begin
   AddClosedCurve(points, Single(0.5));
end;

procedure TGdipGraphicsPath.AddClosedCurve({$IFDEF FPC}constref{$ELSE}const [ref]{$ENDIF} points: TArray<TPoint>; const tension: Single);
begin
   TGdiplusAPI.GdipAddPathClosedCurve2I(_nativePath, @points[0], Length(points), tension).ThrowIfFailed();
end;

procedure TGdipGraphicsPath.AddRectangle(const rect: TRectangleF);
begin
   TGdiplusAPI.GdipAddPathRectangle(_nativePath, rect.X, rect.Y, rect.Width, rect.Height).ThrowIfFailed();
end;

procedure TGdipGraphicsPath.AddRectangles({$IFDEF FPC}constref{$ELSE}const [ref]{$ENDIF} rects: TArray<TRectangleF>);
begin
   TGdiplusAPI.GdipAddPathRectangles(_nativePath, @rects[0], Length(rects)).ThrowIfFailed();
end;

procedure TGdipGraphicsPath.AddRectangle(const rect: TRectangle);
begin
   AddRectangle(TRectangleF(rect));
end;

procedure TGdipGraphicsPath.AddRectangles({$IFDEF FPC}constref{$ELSE}const [ref]{$ENDIF} rects: TArray<TRectangle>);
begin
   TGdiplusAPI.GdipAddPathRectanglesI(_nativePath, @rects[0], Length(rects)).ThrowIfFailed();
end;

procedure TGdipGraphicsPath.AddRoundedRectangle(const rect: TRectangle; const radius: TSize);
begin
   AddRoundedRectangle(TRectangleF(rect), radius);
end;

procedure TGdipGraphicsPath.AddRoundedRectangle(const rect: TRectangleF; const radius: TSizeF);
begin
   StartFigure();
   AddArc(rect.Right - radius.Width, rect.Top, radius.Width, radius.Height, Single(-90.0), Single(90.0));
   AddArc(rect.Right - radius.Width, rect.Bottom - radius.Height, radius.Width, radius.Height, Single(0.0), Single(90.0));
   AddArc(rect.Left, rect.Bottom - radius.Height, radius.Width, radius.Height, Single(90.0), Single(90.0));
   AddArc(rect.Left, rect.Top, radius.Width, radius.Height, Single(180.0), Single(90.0));
   CloseFigure();
end;

procedure TGdipGraphicsPath.AddEllipse(const rect: TRectangleF);
begin
   AddEllipse(rect.X, rect.Y, rect.Width, rect.Height);
end;

procedure TGdipGraphicsPath.AddEllipse(const x: Single; const y: Single; const width: Single; const height: Single);
begin
   TGdiplusAPI.GdipAddPathEllipse(_nativePath, x, y, width, height).ThrowIfFailed();
end;

procedure TGdipGraphicsPath.AddEllipse(const rect: TRectangle);
begin
   AddEllipse(rect.X, rect.Y, rect.Width, rect.Height);
end;

procedure TGdipGraphicsPath.AddEllipse(const x: Integer; const y: Integer; const width: Integer; const height: Integer);
begin
   AddEllipse(Single(x), y, width, height);
end;

procedure TGdipGraphicsPath.AddPie(const rect: TRectangle; const startAngle: Single; const sweepAngle: Single);
begin
   AddPie(Single(rect.X), rect.Y, rect.Width, rect.Height, startAngle, sweepAngle);
end;

procedure TGdipGraphicsPath.AddPie(const x: Single; const y: Single; const width: Single; const height: Single; const startAngle: Single; const sweepAngle: Single);
begin
   TGdiplusAPI.GdipAddPathPie(_nativePath, x, y, width, height, startAngle, sweepAngle).ThrowIfFailed();
end;

procedure TGdipGraphicsPath.AddPie(const x: Integer; const y: Integer; const width: Integer; const height: Integer; const startAngle: Single; const sweepAngle: Single);
begin
   AddPie(Single(x), y, width, height, startAngle, sweepAngle);
end;

procedure TGdipGraphicsPath.AddPolygon({$IFDEF FPC}constref{$ELSE}const [ref]{$ENDIF} points: TArray<TPointF>);
begin
   TGdiplusAPI.GdipAddPathPolygon(_nativePath, @points[0], Length(points)).ThrowIfFailed();
end;

procedure TGdipGraphicsPath.AddPolygon({$IFDEF FPC}constref{$ELSE}const [ref]{$ENDIF} points: TArray<TPoint>);
begin
   TGdiplusAPI.GdipAddPathPolygonI(_nativePath, @points[0], Length(points)).ThrowIfFailed();
end;

procedure TGdipGraphicsPath.AddPath(const addingPath: TGdipGraphicsPath; const connect: Boolean);
begin
   if addingPath = nil then
      raise EArgumentNilException.Create('addingPath');

   TGdiplusAPI.GdipAddPathPath(_nativePath, addingPath.Pointer(), connect).ThrowIfFailed();
end;

procedure TGdipGraphicsPath.AddString(const s: string; const family: TGdipFontFamily; const style: Integer; const emSize: Single; const origin: TPointF; const format: TGdipStringFormat);
begin
   AddString(s, family, style, emSize, TRectangleF.Create(origin.X, origin.Y, 0, 0), format);
end;

procedure TGdipGraphicsPath.AddString(const s: string; const family: TGdipFontFamily; const style: Integer; const emSize: Single; const origin: TPoint; const format: TGdipStringFormat);
begin
   AddString(s, family, style, emSize, TRectangle.Create(origin.X, origin.Y, 0, 0), format);
end;

procedure TGdipGraphicsPath.AddString(const s: string; const family: TGdipFontFamily; const style: Integer; const emSize: Single; const layoutRect: TRectangleF; const format: TGdipStringFormat);
begin
   if string.IsNullOrEmpty(s) then
      raise EArgumentNilException.Create('s');

   if family = nil then
      raise EArgumentNilException.Create('family');

            TGdiplusAPI.GdipAddPathString(
                _nativePath,
                PWideChar(s),
                s.Length,
                family.NativeFamily,
                style,
                emSize,
                @layoutRect,
                format._nativeFormat);
end;

procedure TGdipGraphicsPath.AddString(const s: string; const family: TGdipFontFamily; const style: Integer; const emSize: Single; const layoutRect: TRectangle; const format: TGdipStringFormat);
begin
   AddString(s, family, style, emSize, TRectangleF(layoutRect), format);
end;

procedure TGdipGraphicsPath.Transform(const matrix: TGdipMatrix);
begin
   if matrix = nil then
      raise EArgumentNilException.Create('matrix');

   TGdiplusAPI.GdipTransformPath(_nativePath, matrix.NativeMatrix).ThrowIfFailed();
end;

function TGdipGraphicsPath.GetBounds(): TRectangleF;
begin
   Result := GetBounds( nil );
end;

function TGdipGraphicsPath.GetBounds(const matrix: TGdipMatrix): TRectangleF;
begin
   Result := GetBounds(matrix,  nil );
end;

function TGdipGraphicsPath.GetBounds(const matrix: TGdipMatrix; const pen: TGdipPen): TRectangleF;
begin
   var bounds: TRectangleF;

   TGdiplusAPI.GdipGetPathWorldBounds(_nativePath, Bounds, matrix.NativeMatrix, pen.NativePen).ThrowIfFailed();

   Exit(bounds);
end;

procedure TGdipGraphicsPath.Flatten();
begin
   Flatten( nil );
end;

procedure TGdipGraphicsPath.Flatten(const matrix: TGdipMatrix);
begin
   Flatten(matrix, Single(0.25));
end;

procedure TGdipGraphicsPath.Flatten(const matrix: TGdipMatrix; const flatness: Single);
begin
   TGdiplusAPI.GdipFlattenPath(_nativePath, matrix.NativeMatrix, flatness).ThrowIfFailed();
end;

procedure TGdipGraphicsPath.Widen(const pen: TGdipPen);
begin
   Widen(pen,  nil , Flatness);
end;

procedure TGdipGraphicsPath.Widen(const pen: TGdipPen; const matrix: TGdipMatrix);
begin
   Widen(pen, matrix, Flatness);
end;

procedure TGdipGraphicsPath.Widen(const pen: TGdipPen; const matrix: TGdipMatrix; const flatness: Single);
begin
   if pen = nil then
      raise EArgumentNilException.Create('pen');

   // GDI+ wrongly returns an out of memory status when there is nothing in the path, so we have to check
   // before calling the widen method and do nothing if we don't have anything in the path.


   if (PointCount = 0) then
   begin
      Exit();
   end;

   TGdiplusAPI.GdipWidenPath(_nativePath, pen.NativePen, matrix.NativeMatrix, flatness).ThrowIfFailed();
end;

procedure TGdipGraphicsPath.Warp({$IFDEF FPC}constref{$ELSE}const [ref]{$ENDIF} destPoints: TArray<TPointF>; const srcRect: TRectangleF; const matrix: TGdipMatrix);
begin
   Warp(destPoints, srcRect, matrix, TGdipWarpMode.Perspective);
end;

procedure TGdipGraphicsPath.Warp({$IFDEF FPC}constref{$ELSE}const [ref]{$ENDIF} destPoints: TArray<TPointF>; const srcRect: TRectangleF; const matrix: TGdipMatrix = nil; const warpMode: TGdipWarpMode = TGdipWarpMode.Perspective; const flatness: Single = Single(0.25));
begin
            TGdiplusAPI.GdipWarpPath(
                _nativePath,
                matrix.NativeMatrix,
                @destPoints[0],
                Length(destPoints),
                srcRect.X, srcRect.Y, srcRect.Width, srcRect.Height,
                TGdiplusAPI.TGdipWarpModeEnum(warpMode),
                flatness).ThrowIfFailed();
end;

function TGdipGraphicsPath.GetPathTypes(var destination: TArray<Byte>): Integer;
begin
   if Length(destination) = 0 then
   begin
      Exit(0);
   end;

   TGdiplusAPI.GdipGetPathTypes(_nativePath, @destination[0], Length(destination)).ThrowIfFailed();
   Result := PointCount;
end;

function TGdipGraphicsPath.GetPathPoints(var destination: TArray<TPointF>): Integer;
begin
   if Length(destination) = 0 then
   begin
      Exit(0);
   end;

   TGdiplusAPI.GdipGetPathPoints(_nativePath, @destination[0], Length(destination)).ThrowIfFailed();
   Result := PointCount;
end;


{$REGION 'TGdipStringFormat'}

{ TGdipStringFormat }

function TGdipStringFormat.GetFormatFlags(): TGdipStringFormatFlags;
begin
   var format: TGdiplusAPI.TGdipStringFormatFlagsEnum;// TGdipStringFormatFlags;
   TGdiplusAPI.GdipGetStringFormatFlags(_nativeFormat, format).ThrowIfFailed();
   Result := TGdipStringFormatFlags(format);
end;

procedure TGdipStringFormat.SetFormatFlags(const Value: TGdipStringFormatFlags);
begin
   TGdiplusAPI.GdipSetStringFormatFlags(_nativeFormat, Integer(value)).ThrowIfFailed();
end;

function TGdipStringFormat.GetAlignment(): TGdipStringAlignment;
begin
   var alignment: TGdiplusAPI.TGdipStringAlignmentEnum;
   TGdiplusAPI.GdipGetStringFormatAlign(_nativeFormat, alignment).ThrowIfFailed();
   Result := TGdipStringAlignment(alignment);
end;

procedure TGdipStringFormat.SetAlignment(const Value: TGdipStringAlignment);
begin
   if (value < TGdipStringAlignment.Near) or (Value > TGdipStringAlignment.Far) then
   begin
      raise EInvalidArgument.Create('nameof(value), Integer(value), TypeInfo(TGdipStringAlignment)');
   end;

   TGdiplusAPI.GdipSetStringFormatAlign(_nativeFormat, TGdiPlusAPI.TGdipStringAlignmentEnum(value)).ThrowIfFailed();
end;

function TGdipStringFormat.GetLineAlignment(): TGdipStringAlignment;
begin
   var alignment: TGdiplusAPI.TGdipStringAlignmentEnum;
   TGdiplusAPI.GdipGetStringFormatLineAlign(_nativeFormat, alignment).ThrowIfFailed();
   Result := TGdipStringAlignment(alignment);
end;

procedure TGdipStringFormat.SetLineAlignment(const Value: TGdipStringAlignment);
begin
   if (Value < TGdipStringAlignment.Near) or (Value > TGdipStringAlignment.Far) then
   begin
      raise EInvalidArgument.Create('nameof(value), value, TypeInfo(TGdipStringAlignment)');
   end;

   TGdiplusAPI.GdipSetStringFormatLineAlign(_nativeFormat, TGdiplusAPI.TGdipStringAlignmentEnum(value)).ThrowIfFailed();
end;

function TGdipStringFormat.GetHotkeyPrefix(): TGdipHotkeyPrefix;
begin
   var hotkeyPrefix: TGdiplusAPI.TGdipHotkeyPrefixEnum;
   TGdiplusAPI.GdipGetStringFormatHotkeyPrefix(_nativeFormat, hotkeyPrefix).ThrowIfFailed();
   Result := TGdipHotkeyPrefix(hotkeyPrefix);
end;

procedure TGdipStringFormat.SetHotkeyPrefix(const Value: TGdipHotkeyPrefix);
begin
   if (Value < TGdipHotkeyPrefix.None) or (Value > TGdipHotkeyPrefix.Hide) then
   begin
      raise EInvalidArgument.Create('nameof(value), Integer(value), TypeInfo(TGdipHotkeyPrefix)');
   end;

   TGdiplusAPI.GdipSetStringFormatHotkeyPrefix(_nativeFormat, TGdiplusAPI.TGdipHotkeyPrefixEnum(value)).ThrowIfFailed();
end;

function TGdipStringFormat.GetTrimming(): TGdipStringTrimming;
begin
   var trimming: TGdiplusAPI.TGdipStringTrimmingEnum;
   TGdiplusAPI.GdipGetStringFormatTrimming(_nativeFormat, TGdiplusAPI.TGdipStringTrimmingEnum(trimming)).ThrowIfFailed();
   Result := TGdipStringTrimming(trimming);
end;

procedure TGdipStringFormat.SetTrimming(const Value: TGdipStringTrimming);
begin
   if (Value < TGdipStringTrimming.None) or (Value > TGdipStringTrimming.EllipsisPath) then
   begin
      raise EInvalidArgument.Create('nameof(value), Integer(value), TypeInfo(TGdipStringTrimming)');
   end;

   TGdiplusAPI.GdipSetStringFormatTrimming(_nativeFormat, TGdiPlusAPI.TGdipStringTrimmingEnum(value)).ThrowIfFailed();
end;

class function TGdipStringFormat.GetGenericDefault(): TGdipStringFormat;
begin
   var format: TGdiplusAPI.TGdipStringFormatPtr;
   TGdiplusAPI.GdipStringFormatGetGenericDefault(format).ThrowIfFailed();
   Result := TGdipStringFormat.Create(format);
end;

class function TGdipStringFormat.GetGenericTypographic(): TGdipStringFormat;
begin
   var format: TGdiplusAPI.TGdipStringFormatPtr;
   TGdiplusAPI.GdipStringFormatGetGenericTypographic(format).ThrowIfFailed();
   Exit(TGdipStringFormat.Create(format));
end;

function TGdipStringFormat.GetDigitSubstitutionMethod(): TGdipStringDigitSubstitute;
begin
   var digitSubstitute: TGdiplusAPI.TGdipStringDigitSubstituteEnum;
   TGdiplusAPI.GdipGetStringFormatDigitSubstitution(_nativeFormat, nil, @digitSubstitute).ThrowIfFailed();
   Result := TGdipStringDigitSubstitute(digitSubstitute);
end;

function TGdipStringFormat.GetDigitSubstitutionLanguage(): Integer;
begin
   var language: UInt16;
   TGdiplusAPI.GdipGetStringFormatDigitSubstitution(_nativeFormat, @language, nil).ThrowIfFailed();
   Exit(language);
end;

constructor TGdipStringFormat.Create(const format: TGdiplusAPI.TGdipStringFormatPtr);
begin
   _nativeFormat := format;
end;

constructor TGdipStringFormat.Create();
begin
   Create(0, 0);


end;

constructor TGdipStringFormat.Create(const options: TGdipStringFormatFlags);
begin
   Create(options, 0);


end;

constructor TGdipStringFormat.Create(const options: TGdipStringFormatFlags; const language: Integer);
begin
   var format: TGdiplusAPI.TGdipStringFormatPtr;
   TGdiplusAPI.GdipCreateStringFormat(Integer(options), UInt16(language), format).ThrowIfFailed();
   _nativeFormat := format;
end;

constructor TGdipStringFormat.Create(const format: TGdipStringFormat);
begin
   if format = nil then
      raise EArgumentNilException.Create('format');

   var newFormat: TGdiplusAPI.TGdipStringFormatPtr;

   TGdiplusAPI.GdipCloneStringFormat(format._nativeFormat, &newFormat).ThrowIfFailed();
   _nativeFormat := newFormat;
end;

destructor TGdipStringFormat.Destroy();
begin
   Dispose(False);
   inherited Destroy();
end;

procedure TGdipStringFormat.Dispose();
begin
   Dispose(True);
end;

procedure TGdipStringFormat.Dispose(const disposing: Boolean);
begin
   if (_nativeFormat <> nil) then
   begin
      try
         try
{$IFDEF DEBUG}
            var status: TGdiplusAPI.TGdipStatusEnum := IfThen(not TGdip.Initialized, TGdiplusAPI.TGdipStatusEnum.Ok, TGdiplusAPI.GdipDeleteStringFormat(_nativeFormat));
            Assert(status = TGdiplusAPI.TGdipStatusEnum.Ok, 'GDI+ returned an error status: ' + status.ToMessageString());
{$ELSE}
            TGdiplusAPI.GdipDeleteStringFormat(_nativeFormat);
{$ENDIF}
         except on ex: Exception do // when (!ClientUtils.IsCriticalException(ex))
            Assert(False, 'Exception thrown during Dispose: ' + ex.ToString() + '');
         end;
      finally
         _nativeFormat := nil;
      end;

   end;
end;

function TGdipStringFormat.Clone(): TObject;
begin
   Result := TGdipStringFormat.Create(Self);
end;

procedure TGdipStringFormat.SetMeasurableCharacterRanges(const ranges: TArray<TGdipCharacterRange>);
begin
   if ranges = nil then
      raise EArgumentNilException.Create('ranges');

   // Passing no count will clear the ranges, but it still requires a valid pointer. Taking the address of an
   // empty array gives a null pointer, so we need to pass a dummy value.
   var stub: TGdiPlusAPI.TGdipCharacterRangePtr := nil;
   var r: System.Pointer := @ranges[0];

   if r = nil then
      r := stub;

   TGdiPlusAPI.GdipSetStringFormatMeasurableCharacterRanges(
                _nativeFormat,
                Length(ranges),
                @r).ThrowIfFailed();
end;

procedure TGdipStringFormat.SetTabStops(const firstTabOffset: Single; const tabStops: TArray<Single>);
begin
   if tabStops = nil then
      raise EArgumentNilException.Create('tabStops');

   if (firstTabOffset < 0) then
   begin
      raise EArgumentException.Create('SR.Format(SR.InvalidArgumentValue, nameof(firstTabOffset), firstTabOffset)');
   end;

   // To clear the tab stops you need to pass a count of 0 with a valid pointer. Taking the address of an
   // empty array gives a null pointer, so we need to pass a dummy value.
   var stub: Single := 0;

   var ts: PSingle := @tabStops[0];
   if ts = nil then
      ts := @stub;

            TGdiplusAPI.GdipSetStringFormatTabStops(
                _nativeFormat,
                firstTabOffset,
                Length(tabStops),
                ts).ThrowIfFailed();
end;

function TGdipStringFormat.GetTabStops(out firstTabOffset: Single): TArray<Single>;
begin
   var count: Integer;

   TGdiplusAPI.GdipGetStringFormatTabStopCount(_nativeFormat, count).ThrowIfFailed();

   if (count = 0) then
   begin
      firstTabOffset := 0;
      Result := [];
   end;

   var tabStops: TArray<Single>;
   SetLength(tabStops, count);

   var ts: PSingle := @tabStops[0];
   TGdiplusAPI.GdipGetStringFormatTabStops(_nativeFormat, count, firstTabOffset, ts).ThrowIfFailed();
   Result := tabStops;
end;

procedure TGdipStringFormat.SetDigitSubstitution(const language: Integer; const substitute: TGdipStringDigitSubstitute);
begin
   TGdiplusAPI.GdipSetStringFormatDigitSubstitution(_nativeFormat, UInt16(language), TGdiPlusAPI.TGdipStringDigitSubstituteEnum(substitute)).ThrowIfFailed();
end;

function TGdipStringFormat.GetMeasurableCharacterRangeCount(): Integer;
begin
   var count: Integer;
   TGdiplusAPI.GdipGetStringFormatMeasurableCharacterRangeCount(_nativeFormat, count).ThrowIfFailed();
   Exit(count);
end;

function TGdipStringFormat.ToString(): string;
begin
   Result := '[StringFormat, FormatFlags=' + IntToStr(FormatFlags) + ']';
end;

{ TGdipStringFormatExtensions }

function TGdipStringFormatExtensions.Pointer(): TGdiplusAPI.TGdipStringFormatPtr;
begin
   if Self = nil then
      Result := nil
   else
      Result := self._nativeFormat;
end;


{$ENDREGION 'TGdipStringFormat'}


{ TGdipInstalledFontCollection }

constructor TGdipInstalledFontCollection.Create();
begin
   inherited Create();

   var fontCollection: TGdiplusAPI.TGdipFontCollectionPtr;

   TGdiplusAPI.GdipNewInstalledFontCollection(fontCollection).ThrowIfFailed();
   _nativeFontCollection := fontCollection;
end;


procedure TGdipInstalledFontCollection.Dispose(const disposing: Boolean);
begin

end;


{ TGdipFontFamily }

class constructor TGdipFontFamily.Create();
begin
end;

procedure TGdipFontFamily.AfterConstruction;
begin
   inherited;
end;

procedure TGdipFontFamily.BeforeDestruction;
begin
   inherited;
end;

function TGdipFontFamily.GetNativeFamily(): TGdiplusAPI.TGdipFontFamilyPtr;
begin
   Result := _nativeFamily;
end;

class function TGdipFontFamily.GetCurrentLanguage(): Integer;
begin
   Result := Winapi.Windows.GetUserDefaultLCID;
end;

function TGdipFontFamily.GetName(): string;
begin
   Result := GetName(CurrentLanguage);
end;

class function TGdipFontFamily.GetFamilies(): TArray<TGdipFontFamily>;
begin
   Result := TGdipInstalledFontCollection.Create().Families;
end;

class function TGdipFontFamily.GetGenericSansSerif(): TGdipFontFamily;
begin
   Result := TGdipFontFamily.Create(GetGdipGenericSansSerif());
end;

class function TGdipFontFamily.GetGenericSerif(): TGdipFontFamily;
begin
   Result := TGdipFontFamily.Create(TGdipGenericFontFamilies.Serif)
end;

class function TGdipFontFamily.GetGenericMonospace(): TGdipFontFamily;
begin
   Result := TGdipFontFamily.Create(TGdipGenericFontFamilies.Monospace);
end;

constructor TGdipFontFamily.Create(const family: TGdiplusAPI.TGdipFontFamilyPtr);
begin
   inherited Create();
   SetNativeFamily(family);
end;

constructor TGdipFontFamily.Create(const name: string; const createDefaultOnFail: Boolean);
begin

   _createDefaultOnFail := createDefaultOnFail;

   CreateFontFamily(name,  nil );

end;

constructor TGdipFontFamily.Create(const name: string);
begin
   CreateFontFamily(name,  nil );
end;

constructor TGdipFontFamily.Create(const name: string; const fontCollection: TGdipFontCollection);
begin
   CreateFontFamily(name, fontCollection);
end;

constructor TGdipFontFamily.Create(const genericFamily: TGdipGenericFontFamilies);
begin
   var nativeFamily: TGdiplusAPI.TGdipFontFamilyPtr;

   case (genericFamily) of
      TGdipGenericFontFamilies.Serif:
      begin
         TGdiplusAPI.GdipGetGenericFontFamilySerif(nativeFamily).ThrowIfFailed();
      end;
      TGdipGenericFontFamilies.SansSerif:
      begin
         TGdiplusAPI.GdipGetGenericFontFamilySansSerif(nativeFamily).ThrowIfFailed();
      end;
      TGdipGenericFontFamilies.Monospace:
      begin
         TGdiplusAPI.GdipGetGenericFontFamilyMonospace(nativeFamily).ThrowIfFailed();
      end;
   else
      TGdiplusAPI.GdipGetGenericFontFamilyMonospace(nativeFamily).ThrowIfFailed();
   end;

   SetNativeFamily(nativeFamily);
end;

destructor TGdipFontFamily.Destroy();
begin
   Dispose(True);
   inherited Destroy();
end;

procedure TGdipFontFamily.SetNativeFamily(const family: TGdiplusAPI.TGdipFontFamilyPtr);
begin
   Assert(_nativeFamily = nil, 'Setting GDI+ native font family when already initialized.');
   _nativeFamily := family;
end;

procedure TGdipFontFamily.CreateFontFamily(const name: string; const fontCollection: TGdipFontCollection);
begin
   var fontFamily: TGdiplusAPI.TGdipFontFamilyPtr;


   var nativeFontCollection: TGdiplusAPI.TGdipFontCollectionPtr;
   if fontCollection = nil then
      nativeFontCollection := nil
   else
      nativeFontCollection := fontCollection._nativeFontCollection;



   var status: TGdiplusAPI.TGdipStatusEnum := TGdiplusAPI.TGdipStatusEnum.Ok;

   status := TGdiplusAPI.GdipCreateFontFamilyFromName(PWideChar(name), nativeFontCollection, fontFamily);

   if (status <> TGdiplusAPI.TGdipStatusEnum.Ok) then
   begin
         if (_createDefaultOnFail) then
         begin
               fontFamily := GetGdipGenericSansSerif();
         end
         else
         begin
               // Special case this incredibly common error message to give more information.
               if (status = Status.FontFamilyNotFound) then
               begin
                     raise EArgumentException.Create('SR.Format(SR.GdiplusFontFamilyNotFound, name)');
               end
               else
               begin

                  if (status = Status.NotTrueTypeFont) then
                  begin
                           raise EArgumentException.Create('SR.Format(SR.GdiplusNotTrueTypeFont, name)');
                  end
                  else
                  begin


                        status.ThrowIfFailed();
                  end;
               end;
         end;
   end;

   SetNativeFamily(fontFamily);
end;

function TGdipFontFamily.ToString(): string;
begin
   Result := '[' + ClassName + ': Name=' + Name + ']';
end;

function TGdipFontFamily.Equals(obj: TObject): Boolean;
begin
   if (obj = Self) then
   begin
      Exit(true);
   end;

   // if obj = null then (obj is FontFamily) = false.
   if not (obj is TGdipFontFamily) then
   begin
      Exit(false);
   end;
   var otherFamily := obj as TGdipFontFamily;

   // We can safely use the ptr to the native GDI+ FontFamily because in windows it is common to
   // all objects of the same family (singleton RO object).
   Exit(otherFamily.NativeFamily = NativeFamily);
end;

procedure TGdipFontFamily.Dispose();
begin
   Dispose( True );
end;

procedure TGdipFontFamily.Dispose(const disposing: Boolean);
begin
   if (_nativeFamily <> nil) then
   begin
      try
         try
{$IFDEF DEBUG}
            var status: TGdiplusAPI.TGdipStatusEnum := IfThen(not TGdip.Initialized, TGdiplusAPI.TGdipStatusEnum.Ok, TGdiplusAPI.GdipDeleteFontFamily(_nativeFamily));
            Assert(status = TGdiplusAPI.TGdipStatusEnum.Ok, 'GDI+ returned an error status: ' + status.ToMessageString());
{$ELSE}
            TGdiplusAPI.GdipDeleteFontFamily(_nativeFamily);
{$ENDIF}
         except on ex: Exception do  //when (!ClientUtils.IsCriticalException(ex))
            Assert(False, 'Exception thrown during Dispose: ' + ex.ToString() + '');
         end;
      finally
         _nativeFamily := nil;
      end;
   end;
end;

function TGdipFontFamily.GetName(const language: LangID = 0): string;
var
  Name: array [0..LF_FACESIZE - 1] of WideChar;
begin

   TGdiplusAPI.GdipGetFamilyName(_nativeFamily, Name, language).ThrowIfFailed();
   Result := name;
end;

class function TGdipFontFamily.GetGdipGenericSansSerif(): TGdiplusAPI.TGdipFontFamilyPtr;
begin
   var nativeFamily: TGdiplusAPI.TGdipFontFamilyPtr;
   TGdiplusAPI.GdipGetGenericFontFamilySansSerif(nativeFamily).ThrowIfFailed();
   Result := nativeFamily;
end;

class function TGdipFontFamily.GetFamilies(const graphics: TGdipGraphics): TArray<TGdipFontFamily>;
begin
   if graphics = nil then
      raise EArgumentNilException.Create('graphics');

   Result := TGdipInstalledFontCollection.Create().Families;
end;

function TGdipFontFamily.IsStyleAvailable(const style: TGdipFontStyle): Boolean;
begin
   var isStyleAvailable: LongBool;
   TGdiplusAPI.GdipIsStyleAvailable(NativeFamily, style, isStyleAvailable).ThrowIfFailed();
   Exit(isStyleAvailable);
end;

function TGdipFontFamily.GetEmHeight(const style: TGdipFontStyle): Integer;
begin
   var emHeight: UInt16;
   TGdiplusAPI.GdipGetEmHeight(NativeFamily, Integer(style), emHeight).ThrowIfFailed();
   Exit(emHeight);
end;

function TGdipFontFamily.GetCellAscent(const style: TGdipFontStyle): Integer;
begin
   var cellAscent: UInt16;
   TGdiplusAPI.GdipGetCellAscent(NativeFamily, Integer(style), cellAscent).ThrowIfFailed();
   Exit(cellAscent);
end;

function TGdipFontFamily.GetCellDescent(const style: TGdipFontStyle): Integer;
begin
   var cellDescent: UInt16;
   TGdiplusAPI.GdipGetCellDescent(NativeFamily, Integer(style), cellDescent).ThrowIfFailed();
   Exit(cellDescent);
end;

function TGdipFontFamily.GetLineSpacing(const style: TGdipFontStyle): Integer;
begin
   var lineSpacing: UInt16;
   TGdiplusAPI.GdipGetLineSpacing(NativeFamily, Integer(style), lineSpacing).ThrowIfFailed();
   Exit(lineSpacing);
end;


{ TGdipFontCollection }

function TGdipFontCollection.GetFamilies(): TArray<TGdipFontFamily>;
begin
   var numFound, ActualCount: Integer;

   TGdiplusAPI.GdipGetFontCollectionFamilyCount(_nativeFontCollection, numFound).ThrowIfFailed();

   if (numFound = 0) then
   begin
         Result := [];
         Exit();
   end;

   var gpFamilies: TArray<TGdiplusAPI.TGdipFontFamilyPtr>;
   SetLength(gpFamilies, numFound);

   TGdiplusAPI.GdipGetFontCollectionFamilyList(_nativeFontCollection, numFound, @gpFamilies[0], ActualCount).ThrowIfFailed();

   Assert(Length(gpFamilies) = ActualCount, 'GDI+ can''t give a straight answer about how many fonts there are');

   var families: TArray<TGdipFontFamily>;
   SetLength(families, ActualCount);

   var nativeClone: TGdiplusAPI.TGdipFontFamilyPtr := nil;

   for var f: Integer := 0 to ActualCount - 1 do
   begin
      TGdiplusAPI.GdipCloneFontFamily(gpFamilies[f], nativeClone).ThrowIfFailed();
      families[f] := TGdipFontFamily.Create(nativeClone);
   end;

   Exit(families);
end;

constructor TGdipFontCollection.Create();
begin
   _nativeFontCollection := nil;
end;

destructor TGdipFontCollection.Destroy();
begin
   Dispose(True);
   inherited Destroy();
end;

procedure TGdipFontCollection.Dispose();
begin
   Dispose( True );
end;

{ TGdipHatchBrush }

function TGdipHatchBrush.GetHatchStyle(): TGdipHatchStyle;
begin
   var hatchStyle: TGdiPlusAPI.TGdipHatchStyleEnum;
   TGdiPlusAPI.GdipGetHatchStyle(TGdiPlusAPI.TGdipHatchPtr(NativeBrush), hatchStyle).ThrowIfFailed();
   Result := TGdipHatchStyle(hatchStyle);
end;

function TGdipHatchBrush.GetForegroundColor(): TGdipColor;
begin
   var foregroundArgb: TARGB;
   TGdiPlusAPI.GdipGetHatchForegroundColor(TGdiPlusAPI.TGdipHatchPtr(NativeBrush), @foregroundArgb).ThrowIfFailed();
   Result := foregroundArgb;
end;

function TGdipHatchBrush.GetBackgroundColor(): TGdipColor;
begin
   var backgroundArgb: TARGB;
   TGdiPlusAPI.GdipGetHatchBackgroundColor(TGdiPlusAPI.TGdipHatchPtr(NativeBrush), @backgroundArgb).ThrowIfFailed();
   Result := backgroundArgb;
end;

constructor TGdipHatchBrush.Create(const hatchstyle: TGdipHatchStyle; const foreColor: TGdipColor);
begin
   Create(hatchstyle, foreColor, TGdipColor.FromArgb(Integer($ff000000)));
end;

constructor TGdipHatchBrush.Create(const hatchstyle: TGdipHatchStyle; const foreColor: TGdipColor; const backColor: TGdipColor);
begin
   if (hatchstyle < TGdipHatchStyle.Min) or (hatchstyle > TGdipHatchStyle.SolidDiamond) then
   begin
         raise EArgumentException.Create('SR.Format(SR.InvalidEnumArgument, nameof(hatchstyle), hatchstyle, nameof(HatchStyle)), nameof(hatchstyle)');
   end;

   var nativeBrush: TGdiPlusAPI.TGdipHatchPtr;
   TGdiPlusAPI.GdipCreateHatchBrush(TGdiPlusAPI.TGdipHatchStyleEnum(hatchstyle), foreColor.ToArgb(), backColor.ToArgb(), nativeBrush).ThrowIfFailed();
   SetNativeBrushInternal(TGdiPlusAPI.TGdipBrushPtr(nativeBrush));
end;

constructor TGdipHatchBrush.Create(const nativeBrush: TGdiplusAPI.TGdipHatchPtr);
begin
   Assert(nativeBrush <> nil, 'Initializing native brush with null.');
   SetNativeBrushInternal(TGdiplusAPI.TGdipBrushPtr(nativeBrush));
end;

function TGdipHatchBrush.Clone(): TObject;
begin
   var clonedBrush: TGdiplusAPI.TGdipBrushPtr;
   TGdiplusAPI.GdipCloneBrush(NativeBrush, clonedBrush).ThrowIfFailed();
   Exit(TGdipHatchBrush.Create(TGdiplusAPI.TGdipHatchPtr(clonedBrush)));
end;



{ TGdipTextureBrush }

class constructor TGdipTextureBrush.Create();
begin
end;

procedure TGdipTextureBrush.AfterConstruction;
begin
   inherited;
end;

procedure TGdipTextureBrush.BeforeDestruction;
begin
   inherited;
end;

function TGdipTextureBrush.GetTransform(): TGdipMatrix;
begin
   var matrix: TGdipMatrix := TGdipMatrix.Create();
   TGdiplusAPI.GdipGetTextureTransform(TGdiplusAPI.TGdipTexturePtr(NativeBrush), matrix.NativeMatrix).ThrowIfFailed();
   Exit(matrix);
end;

procedure TGdipTextureBrush.SetTransform(const Value: TGdipMatrix);
begin
   if Value = nil then
      raise EArgumentNilException.Create('value');

   TGdiplusAPI.GdipSetTextureTransform(TGdiplusAPI.TGdipTexturePtr(NativeBrush), value.NativeMatrix).ThrowIfFailed();
end;

function TGdipTextureBrush.GetWrapMode(): TGdipWrapMode;
begin
   var mode: TGdiplusAPI.TGdipWrapModeEnum;
   TGdiplusAPI.GdipGetTextureWrapMode(TGdiplusAPI.TGdipTexturePtr(NativeBrush), mode).ThrowIfFailed();
   Result := TGdipWrapMode(mode);
end;

procedure TGdipTextureBrush.SetWrapMode(const Value: TGdipWrapMode);
begin
   if (value < TGdipWrapMode.Tile) or (value > TGdipWrapMode.Clamp) then
   begin
      raise EInvalidArgument.Create('nameof(value), Integer(value), TypeInfo(TGdipWrapMode)');
   end;

   TGdiplusAPI.GdipSetTextureWrapMode(TGdiplusAPI.TGdipTexturePtr(NativeBrush), TGdiplusAPI.TGdipWrapModeEnum(value)).ThrowIfFailed();
end;

function TGdipTextureBrush.GetImage(): TGdipImage;
begin
   var image: TGdiplusAPI.TGdipImagePtr;
   TGdiplusAPI.GdipGetTextureImage(TGdiplusAPI.TGdipTexturePtr(NativeBrush), image).ThrowIfFailed();
   Result := TGdipImage.CreateImageObject(image);
end;

constructor TGdipTextureBrush.Create(const bitmap: TGdipImage);
begin
   Create(bitmap, TGdipWrapMode.Tile);
end;

constructor TGdipTextureBrush.Create(const image: TGdipImage; const wrapMode: TGdipWrapMode);
begin
   if image = nil then
      raise EArgumentNilException.Create('image');

   if (wrapMode < TGdipWrapMode.Tile) or (wrapMode > TGdipWrapMode.Clamp) then
   begin
      raise EInvalidArgument.Create('nameof(wrapMode), Integer(wrapMode), TypeInfo(TGdipWrapMode)');
   end;

   var brush: TGdiplusAPI.TGdipTexturePtr;

   TGdiplusAPI.GdipCreateTexture(image.Pointer, TGdiplusAPI.TGdipWrapModeEnum(wrapMode), brush).ThrowIfFailed();
   SetNativeBrushInternal(TGdiplusAPI.TGdipBrushPtr(brush));
end;

constructor TGdipTextureBrush.Create(const image: TGdipImage; const wrapMode: TGdipWrapMode; const dstRect: TRectangleF);
begin
   if image = nil then
      raise EArgumentNilException.Create('image');

   if (wrapMode < TGdipWrapMode.Tile)  or (wrapMode > TGdipWrapMode.Clamp) then
   begin
         raise EInvalidArgument.Create('nameof(wrapMode), Integer(wrapMode), TypeInfo(TGdipWrapMode)');
   end;

   var brush: TGdiplusAPI.TGdipTexturePtr;

   TGdiplusAPI.GdipCreateTexture2(image.Pointer, TGdiplusAPI.TGdipWrapModeEnum(wrapMode), dstRect.X, dstRect.Y, dstRect.Width, dstRect.Height, brush).ThrowIfFailed();
   SetNativeBrushInternal(TGdiplusAPI.TGdipBrushPtr(brush));
end;

constructor TGdipTextureBrush.Create(const image: TGdipImage; const wrapMode: TGdipWrapMode; const dstRect: TRectangle);
begin
   Create(image, wrapMode, TRectangleF(dstRect));
end;

constructor TGdipTextureBrush.Create(const image: TGdipImage; const dstRect: TRectangleF);
begin
   Create(image, dstRect,  nil );
end;

constructor TGdipTextureBrush.Create(const image: TGdipImage; const dstRect: TRectangleF; const imageAttr: TGdipImageAttributes);
begin
   if image = nil then
      raise EArgumentNilException.Create('image');

   var brush: TGdiplusAPI.TGdipTexturePtr;
   var imageAttributesPtr: TGdiplusAPI.TGdipImageAttributesPtr;
   if imageAttr = nil then
      imageAttributesPtr := nil
   else
      imageAttributesPtr := imageAttr._nativeImageAttributes;

   TGdiplusAPI.GdipCreateTextureIA(image.Pointer, imageAttributesPtr, dstRect.X, dstRect.Y, dstRect.Width, dstRect.Height, brush).ThrowIfFailed();

   SetNativeBrushInternal(TGdiplusAPI.TGdipBrushPtr(brush));
end;

constructor TGdipTextureBrush.Create(const image: TGdipImage; const dstRect: TRectangle);
begin
   Create(image, dstRect,  nil );
end;

constructor TGdipTextureBrush.Create(const image: TGdipImage; const dstRect: TRectangle; const imageAttr: TGdipImageAttributes);
begin
   Create(image, TRectangleF(dstRect), imageAttr);
end;

constructor TGdipTextureBrush.Create(const nativeBrush: TGdiplusAPI.TGdipTexturePtr);
begin
   Assert(nativeBrush <> nil, 'Initializing native brush with null.');
   SetNativeBrushInternal(TGdiplusAPI.TGdipBrushPtr(nativeBrush));
end;

function TGdipTextureBrush.Clone(): TObject;
begin
   var cloneBrush: TGdiplusAPI.TGdipBrushPtr;
   TGdiplusAPI.GdipCloneBrush(NativeBrush, cloneBrush).ThrowIfFailed();
   Result := TGdipTextureBrush.Create(TGdiplusAPI.TGdipTexturePtr(cloneBrush));
end;

procedure TGdipTextureBrush.ResetTransform();
begin
   TGdiplusAPI.GdipResetTextureTransform(TGdiplusAPI.TGdipTexturePtr(NativeBrush)).ThrowIfFailed();
end;

procedure TGdipTextureBrush.MultiplyTransform(const matrix: TGdipMatrix);
begin
   MultiplyTransform(matrix, TGdipMatrixOrder.Prepend);
end;

procedure TGdipTextureBrush.MultiplyTransform(const matrix: TGdipMatrix; const order: TGdipMatrixOrder);
begin
   if matrix = nil then
      raise EArgumentNilException.Create('matrix');

   if (matrix.NativeMatrix = nil) then
   begin
      Exit();
   end;

   TGdiplusAPI.GdipMultiplyTextureTransform(TGdiplusAPI.TGdipTexturePtr(NativeBrush), matrix.NativeMatrix, TGdiplusAPI.TGdipMatrixOrderEnum(order)).ThrowIfFailed();
end;

procedure TGdipTextureBrush.TranslateTransform(const dx: Single; const dy: Single);
begin
   TranslateTransform(dx, dy, TGdipMatrixOrder.Prepend);
end;

procedure TGdipTextureBrush.TranslateTransform(const dx: Single; const dy: Single; const order: TGdipMatrixOrder);
begin
   TGdiplusAPI.GdipTranslateTextureTransform(TGdiplusAPI.TGdipTexturePtr(NativeBrush), dx, dy, TGdiplusAPI.TGdipMatrixOrderEnum(order)).ThrowIfFailed();
end;

procedure TGdipTextureBrush.ScaleTransform(const sx: Single; const sy: Single);
begin
   ScaleTransform(sx, sy, TGdipMatrixOrder.Prepend);
end;

procedure TGdipTextureBrush.ScaleTransform(const sx: Single; const sy: Single; const order: TGdipMatrixOrder);
begin
   TGdiplusAPI.GdipScaleTextureTransform(TGdiplusAPI.TGdipTexturePtr(NativeBrush), sx, sy, TGdiplusAPI.TGdipMatrixOrderEnum(order)).ThrowIfFailed();
end;

procedure TGdipTextureBrush.RotateTransform(const angle: Single);
begin
   RotateTransform(angle, TGdipMatrixOrder.Prepend);
end;

procedure TGdipTextureBrush.RotateTransform(const angle: Single; const order: TGdipMatrixOrder);
begin
   TGdiplusAPI.GdipRotateTextureTransform(TGdiplusAPI.TGdipTexturePtr(NativeBrush), angle, TGdiPlusAPI.TGdipMatrixOrderEnum(order)).ThrowIfFailed();
end;




{ TStackBuffer }

{ TGdipImageAttributes }

constructor TGdipImageAttributes.Create();
begin
   var newImageAttributes: TGdiplusAPI.TGdipImageAttributesPtr;
   TGdiplusAPI.GdipCreateImageAttributes(newImageAttributes).ThrowIfFailed();
   SetNativeImageAttributes(newImageAttributes);
end;

constructor TGdipImageAttributes.Create(const newNativeImageAttributes: TGdiplusAPI.TGdipImageAttributesPtr);
begin
   SetNativeImageAttributes(newNativeImageAttributes);
end;

destructor TGdipImageAttributes.Destroy();
begin
   Dispose( True );
   inherited Destroy();
end;

procedure TGdipImageAttributes.SetNativeImageAttributes(const handle: TGdiplusAPI.TGdipImageAttributesPtr);
begin
   if (handle = nil) then
   begin

      raise EArgumentNilException.Create('handle');
   end;


   _nativeImageAttributes := handle;
end;

procedure TGdipImageAttributes.Dispose();
begin
   Dispose( True );
end;

procedure TGdipImageAttributes.Dispose(const disposing: Boolean);
begin
{$IFDEF FINALIZATION_WATCH}
   Assert(not disposing and (_nativeImageAttributes <> nil), '********************** Disposed through finalization: ' + m_allocationSite);
{$ENDIF}


   if (_nativeImageAttributes <> nil) then
   begin
         try
            try
{$IFDEF DEBUG}
                var status: TGdiplusAPI.TGdipStatusEnum := IfThen(not TGdip.Initialized, TGdiplusAPI.TGdipStatusEnum.Ok, TGdiplusAPI.GdipDisposeImageAttributes(_nativeImageAttributes));
                Assert(status = TGdiplusAPI.TGdipStatusEnum.Ok, 'GDI+ returned an error status: ' + status.ToMessageString());
{$ELSE}
                TGdiplusAPI.GdipDisposeImageAttributes(_nativeImageAttributes)
{$ENDIF}

            except on ex: Exception do //   when (!ClientUtils.IsCriticalException(ex))
               Assert(False, 'Exception thrown during Dispose: ' + ex.ToString() + '');
            end;
         finally
               _nativeImageAttributes := nil;
         end;

   end;
end;

function TGdipImageAttributes.Clone(): TGdipImageAttributes;
begin
   var clone: TGdiplusAPI.TGdipImageAttributesPtr;
   TGdiplusAPI.GdipCloneImageAttributes(_nativeImageAttributes, clone).ThrowIfFailed();
   Result := TGdipImageAttributes.Create(clone);
end;

procedure TGdipImageAttributes.SetColorMatrix(const newColorMatrix: TGdipColorMatrix);
begin
   SetColorMatrix(newColorMatrix, TGdipColorMatrixFlag.Default, TGdipColorAdjustType.Default);
end;

procedure TGdipImageAttributes.SetColorMatrix(const newColorMatrix: TGdipColorMatrix; const flags: TGdipColorMatrixFlag);
begin
   SetColorMatrix(newColorMatrix, flags, TGdipColorAdjustType.Default);
end;

procedure TGdipImageAttributes.SetColorMatrix(const newColorMatrix: TGdipColorMatrix; const mode: TGdipColorMatrixFlag; const &type: TGdipColorAdjustType);
begin
   SetColorMatrices(newColorMatrix,  nil , mode, &type);
end;

procedure TGdipImageAttributes.ClearColorMatrix();
begin
   ClearColorMatrix(TGdipColorAdjustType.Default);
end;

procedure TGdipImageAttributes.ClearColorMatrix(const &type: TGdipColorAdjustType);
begin
   TGdiplusAPI.GdipSetImageAttributesColorMatrix(_nativeImageAttributes, TGdiPlusAPI.TGdipColorAdjustTypeEnum(&type),  False ,  nil ,  nil , TGdiplusAPI.TGdipColorMatrixFlagEnum(TGdipColorMatrixFlag.Default)).ThrowIfFailed();
end;

procedure TGdipImageAttributes.SetColorMatrices(const newColorMatrix: TGdipColorMatrix; const grayMatrix: TGdipColorMatrix);
begin
   SetColorMatrices(newColorMatrix, grayMatrix, TGdipColorMatrixFlag.Default, TGdipColorAdjustType.Default);
end;

procedure TGdipImageAttributes.SetColorMatrices(const newColorMatrix: TGdipColorMatrix; const grayMatrix: TGdipColorMatrix; const flags: TGdipColorMatrixFlag);
begin
   SetColorMatrices(newColorMatrix, grayMatrix, flags, TGdipColorAdjustType.Default);
end;

procedure TGdipImageAttributes.SetColorMatrices(const newColorMatrix: TGdipColorMatrix; const grayMatrix: TGdipColorMatrix; const mode: TGdipColorMatrixFlag; const &type: TGdipColorAdjustType);
begin
   if newColorMatrix = nil then
      raise EArgumentNilException.Create('newColorMatrix');

   if (grayMatrix <> nil) then
   begin
      var cm: System.Pointer := newColorMatrix.GetPinnableReference();
      var gm: System.Pointer := grayMatrix.GetPinnableReference();
      TGdiPlusAPI.GdipSetImageAttributesColorMatrix(
                    _nativeImageAttributes,
                    TGdiPlusAPI.TGdipColorAdjustTypeEnum(&type),
                    True,
                    TGdiPlusAPI.TgdipColorMatrixPtr(cm),
                    TGdiPlusAPI.TgdipColorMatrixPtr(gm),
                    TGdiPlusAPI.TGdipColorMatrixFlagEnum(mode)).ThrowIfFailed();
   end
   else
   begin
      var cm: System.Pointer := newColorMatrix.GetPinnableReference();
      TGdiPlusAPI.GdipSetImageAttributesColorMatrix(
                    _nativeImageAttributes,
                    TGdiPlusAPI.TGdipColorAdjustTypeEnum(&type),
                    True,
                    TGdiPlusAPI.TGdipColorMatrixPtr(cm),
                    nil,
                    TGdiPlusAPI.TGdipColorMatrixFlagEnum(mode)).ThrowIfFailed();
   end;
end;

procedure TGdipImageAttributes.SetThreshold(const threshold: Single);
begin
   SetThreshold(threshold, TGdipColorAdjustType.Default);
end;

procedure TGdipImageAttributes.SetThreshold(const threshold: Single; const &type: TGdipColorAdjustType);
begin
   SetThreshold(threshold, &type, True);
end;

procedure TGdipImageAttributes.ClearThreshold();
begin
   ClearThreshold(TGdipColorAdjustType.Default);
end;

procedure TGdipImageAttributes.ClearThreshold(const &type: TGdipColorAdjustType);
begin
   SetThreshold(Single(0.0), &type,  False );
end;

procedure TGdipImageAttributes.SetThreshold(const threshold: Single; const &type: TGdipColorAdjustType; const enableFlag: Boolean);
begin
   TGdiPlusAPI.GdipSetImageAttributesThreshold(_nativeImageAttributes, TGdiPlusAPI.TGdipColorAdjustTypeEnum(&type), enableFlag, threshold).ThrowIfFailed();
end;

procedure TGdipImageAttributes.SetGamma(const gamma: Single);
begin
   SetGamma(gamma, TGdipColorAdjustType.Default);
end;

procedure TGdipImageAttributes.SetGamma(const gamma: Single; const &type: TGdipColorAdjustType);
begin
   SetGamma(gamma, &type,  True);
end;

procedure TGdipImageAttributes.ClearGamma();
begin
   ClearGamma(TGdipColorAdjustType.Default);
end;

procedure TGdipImageAttributes.ClearGamma(const &type: TGdipColorAdjustType);
begin
   SetGamma(Single(0.0), &type,  False );
end;

procedure TGdipImageAttributes.SetGamma(const gamma: Single; const &type: TGdipColorAdjustType; const enableFlag: Boolean);
begin
   TGdiPlusAPI.GdipSetImageAttributesGamma(_nativeImageAttributes, TGdiPlusAPI.TGdipColorAdjustTypeEnum(&type), enableFlag, gamma).ThrowIfFailed();
end;

procedure TGdipImageAttributes.SetNoOp();
begin
   SetNoOp(TGdipColorAdjustType.Default);
end;

procedure TGdipImageAttributes.SetNoOp(const &type: TGdipColorAdjustType);
begin
   SetNoOp(&type,  True );
end;

procedure TGdipImageAttributes.ClearNoOp();
begin
   ClearNoOp(TGdipColorAdjustType.Default);
end;

procedure TGdipImageAttributes.ClearNoOp(const &type: TGdipColorAdjustType);
begin
   SetNoOp(&type,  False );
end;

procedure TGdipImageAttributes.SetNoOp(const &type: TGdipColorAdjustType; const enableFlag: Boolean);
begin
   TGdiPlusAPI.GdipSetImageAttributesNoOp(_nativeImageAttributes, TGdiPlusAPI.TGdipColorAdjustTypeEnum(&type), enableFlag).ThrowIfFailed();
end;

procedure TGdipImageAttributes.SetColorKey(const colorLow: TGdipColor; const colorHigh: TGdipColor);
begin
   SetColorKey(colorLow, colorHigh, TGdipColorAdjustType.Default);
end;

procedure TGdipImageAttributes.SetColorKey(const colorLow: TGdipColor; const colorHigh: TGdipColor; const &type: TGdipColorAdjustType);
begin
   SetColorKey(colorLow, colorHigh, &type,  True );
end;

procedure TGdipImageAttributes.ClearColorKey();
begin
   ClearColorKey(TGdipColorAdjustType.Default);
end;

procedure TGdipImageAttributes.ClearColorKey(const &type: TGdipColorAdjustType);
begin
   SetColorKey(TGdipColor.Empty, TGdipColor.Empty, &type,  False );
end;

procedure TGdipImageAttributes.SetColorKey(const colorLow: TGdipColor; const colorHigh: TGdipColor; const &type: TGdipColorAdjustType; const enableFlag: Boolean);
begin
   TGdiPlusAPI.GdipSetImageAttributesColorKeys(_nativeImageAttributes, TGdiPlusAPI.TGdipColorAdjustTypeEnum(&type), enableFlag, UInt32(colorLow.ToArgb()), UInt32(colorHigh.ToArgb())).ThrowIfFailed();
end;

procedure TGdipImageAttributes.SetOutputChannel(const flags: TGdipColorChannelFlag);
begin
   SetOutputChannel(flags, TGdipColorAdjustType.Default);
end;

procedure TGdipImageAttributes.SetOutputChannel(const flags: TGdipColorChannelFlag; const &type: TGdipColorAdjustType);
begin
   SetOutputChannel(&type, flags,  True );
end;

procedure TGdipImageAttributes.ClearOutputChannel();
begin
   ClearOutputChannel(TGdipColorAdjustType.Default);
end;

procedure TGdipImageAttributes.ClearOutputChannel(const &type: TGdipColorAdjustType);
begin
   SetOutputChannel(&type, TGdipColorChannelFlag.ColorChannelLast,  False );
end;

procedure TGdipImageAttributes.SetOutputChannel(const &type: TGdipColorAdjustType; const flags: TGdipColorChannelFlag; const enableFlag: Boolean);
begin
   TGdiPlusAPI.GdipSetImageAttributesOutputChannel(_nativeImageAttributes, TGdiPlusAPI.TGdipColorAdjustTypeEnum(&type), enableFlag, TGdiPlusAPI.TGdipColorChannelFlagsEnum(flags)).ThrowIfFailed();
end;

procedure TGdipImageAttributes.SetOutputChannelColorProfile(const colorProfileFilename: string);
begin
   SetOutputChannelColorProfile(colorProfileFilename, TGdipColorAdjustType.Default);
end;

procedure TGdipImageAttributes.SetOutputChannelColorProfile(const colorProfileFilename: string; const &type: TGdipColorAdjustType);
begin
   // Called in order to emulate exception behavior from .NET Framework related to invalid file paths.
   TPath.GetFullPath(colorProfileFilename);

   var n: PWideChar := PWideChar(UnicodeString(colorProfileFilename));
   TGdiPlusAPI.GdipSetImageAttributesOutputChannelColorProfile(
       _nativeImageAttributes,
       TGdiPlusAPI.TGdipColorAdjustTypeEnum(&type),
       true,
       n).ThrowIfFailed();
end;

procedure TGdipImageAttributes.ClearOutputChannelColorProfile();
begin
   ClearOutputChannel(TGdipColorAdjustType.Default);
end;

procedure TGdipImageAttributes.ClearOutputChannelColorProfile(const &type: TGdipColorAdjustType);
begin
   TGdiPlusAPI.GdipSetImageAttributesOutputChannel(_nativeImageAttributes, TGdiPlusAPI.TGdipColorAdjustTypeEnum(&type),  False , TGdiPlusAPI.TGdipColorChannelFlagsEnum.ColorChannelFlagsLast).ThrowIfFailed();
end;

procedure TGdipImageAttributes.SetRemapTable(const map: TArray<TGdipColorMap>);
begin
   SetRemapTable(map, TGdipColorAdjustType.Default);
end;

procedure TGdipImageAttributes.SetRemapTable(const map: TArray<TGdipColorMap>; const adjustType: TGdipColorAdjustType);
begin
   if map = nil then
     raise EArgumentNullException.Create('Error Messagemap');

   Assert(Length(Map) > 0);

   var NativeColorMap: TArray<TGdiPlusAPI.TGdipNativeColorMap>;
   SetLength(NativeColorMap, Length(map));
   for var i: Integer := 0 to Length(map) - 1 do
   begin
      NativeColorMap[i].OldColor := map[i].OldColor.ToArgb();
      NativeColorMap[i].NewColor := map[i].NewColor.ToArgb()
   end;


  TGdiPlusAPI.GdipSetImageAttributesRemapTable(_nativeImageAttributes, TGdiPlusAPI.TGdipColorAdjustTypeEnum(AdjustType), True, Length(NativeColorMap), @NativeColorMap[0]).ThrowIfFailed();
end;

//procedure TGdipImageAttributes.SetRemapTable(const map: TReadOnlySpan<TColorMap>);
//begin
//   SetRemapTable(ColorAdjustType.Default, map);
//end;
//
//procedure TGdipImageAttributes.SetRemapTable(const map: TReadOnlySpan<T(Color OldColor, Color NewColor)>);
//begin
//   SetRemapTable(ColorAdjustType.Default, map);
//end;
//
//procedure TGdipImageAttributes.SetRemapTable(const &type: TColorAdjustType; const map: TReadOnlySpan<TColorMap>);
//begin
//   // Color is being generated incorrectly so we can't use TGdiPlusAPI.ColorMap directly.
//   // https://github.com/microsoft/CsWin32/issues/1121
//
//
//
//   var stackBuffer: TStackBuffer := Default(TStackBuffer);
//
//
//   var buffer: TBufferScope<T(ARGB, ARGB)> := TBufferScope<T(ARGB, ARGB)>TBufferScope<T(ARGB, ARGB)>.Create(stackBuffer, map.Length);
//
//
//
//   var i: Integer := 0;
//
//   while (i < map.Length) do
//   begin
//
//
//         buffer[i] :=
//           //
//           // não implementado pelo ObjectPascalCodeGenerator: TupleExpression
//           // Arquivo: T:\Data7AdvDsv\source\Apoio\DotNetCore\9-preview2\System.Drawing.Common\src\System\Drawing\Imaging\ImageAttributes.cs
//           // Posição: [14082..14116)
//           // Linha: 394
//           //
//           // ----------- começa aqui o que não é suportado ------------
//         (map[i].OldColor, map[i].NewColor)
//           // ----------- TERMINA AQUI O QUE É SEM SUPORTE - 2 ------------
//           //
//         ;
//
//      i := i + 1;
//   end;
//
//
//     //
//     // Comando não implementado pelo ObjectPascalCodeGenerator: FixedStatement
//     // Arquivo: T:\Data7AdvDsv\source\Apoio\DotNetCore\9-preview2\System.Drawing.Common\src\System\Drawing\Imaging\ImageAttributes.cs
//     // Posição: [14128..14446)
//     // Linha: 397
//     //
//     // ----------- começa aqui o comando não suportado ------------
//
//        fixed (void* m = buffer)
//        {
//            TGdiplusAPI.GdipSetImageAttributesRemapTable(
//                _nativeImageAttributes,
//                (TGdiPlusAPI.ColorAdjustType)type,
//                enableFlag: true,
//                (uint)map.Length,
//                (TGdiPlusAPI.ColorMap*)m).ThrowIfFailed();
//        }
//
//     // ----------- TERMINA AQUI O COMANDO SEM SUPORTE - 4 ------------
//     //
//
//
//
//end;

//procedure TGdipImageAttributes.SetRemapTable(const &type: TGdipColorAdjustType; const map: TReadOnlySpan<T(Color OldColor, Color NewColor)>);
//begin
//
//
//   var stackBuffer: TStackBuffer := Default(TStackBuffer);
//
//
//   var buffer: TBufferScope<T(ARGB, ARGB)> := TBufferScope<T(ARGB, ARGB)>TBufferScope<T(ARGB, ARGB)>.Create(stackBuffer, map.Length);
//
//
//
//   var i: Integer := 0;
//
//   while (i < map.Length) do
//   begin
//
//
//         buffer[i] :=
//           //
//           // não implementado pelo ObjectPascalCodeGenerator: TupleExpression
//           // Arquivo: T:\Data7AdvDsv\source\Apoio\DotNetCore\9-preview2\System.Drawing.Common\src\System\Drawing\Imaging\ImageAttributes.cs
//           // Posição: [14900..14934)
//           // Linha: 419
//           //
//           // ----------- começa aqui o que não é suportado ------------
//         (map[i].OldColor, map[i].NewColor)
//           // ----------- TERMINA AQUI O QUE É SEM SUPORTE - 2 ------------
//           //
//         ;
//
//      i := i + 1;
//   end;
//
//
//     //
//     // Comando não implementado pelo ObjectPascalCodeGenerator: FixedStatement
//     // Arquivo: T:\Data7AdvDsv\source\Apoio\DotNetCore\9-preview2\System.Drawing.Common\src\System\Drawing\Imaging\ImageAttributes.cs
//     // Posição: [14946..15264)
//     // Linha: 422
//     //
//     // ----------- começa aqui o comando não suportado ------------
//
//        fixed (void* m = buffer)
//        {
//            TGdiplusAPI.GdipSetImageAttributesRemapTable(
//                _nativeImageAttributes,
//                (TGdiPlusAPI.ColorAdjustType)type,
//                enableFlag: true,
//                (uint)map.Length,
//                (TGdiPlusAPI.ColorMap*)m).ThrowIfFailed();
//        }
//
//     // ----------- TERMINA AQUI O COMANDO SEM SUPORTE - 4 ------------
//     //
//
//
//
//end;
//
procedure TGdipImageAttributes.ClearRemapTable();
begin
   ClearRemapTable(TGdipColorAdjustType.Default);
end;

procedure TGdipImageAttributes.ClearRemapTable(const &type: TGdipColorAdjustType);
begin
   TGdiplusAPI.GdipSetImageAttributesRemapTable(_nativeImageAttributes, TGdiplusAPI.TGdipColorAdjustTypeEnum(&type),  False , 0,  nil ).ThrowIfFailed();
end;
//
//procedure TGdipImageAttributes.SetBrushRemapTable(const map: TArray<TColorMap>);
//begin
//   SetRemapTable(map, ColorAdjustType.Brush);
//end;
//
//procedure TGdipImageAttributes.SetBrushRemapTable(const map: TReadOnlySpan<TColorMap>);
//begin
//   SetRemapTable(ColorAdjustType.Brush, map);
//end;
//
//procedure TGdipImageAttributes.SetBrushRemapTable(const map: TReadOnlySpan<T(Color OldColor, Color NewColor)>);
//begin
//   SetRemapTable(ColorAdjustType.Brush, map);
//end;
//
procedure TGdipImageAttributes.ClearBrushRemapTable();
begin
   ClearRemapTable(TGdipColorAdjustType.Brush);
end;

procedure TGdipImageAttributes.SetWrapMode(const mode: TGdipWrapMode);
begin
   SetWrapMode(mode, Default(TGdipColor), False);
end;

procedure TGdipImageAttributes.SetWrapMode(const mode: TGdipWrapMode; const color: TGdipColor);
begin
   SetWrapMode(mode, color,  False );
end;

procedure TGdipImageAttributes.SetWrapMode(const mode: TGdipWrapMode; const color: TGdipColor; const clamp: Boolean);
begin
   TGdiplusAPI.GdipSetImageAttributesWrapMode(_nativeImageAttributes, TGdiplusAPI.TGdipWrapModeEnum(mode), UInt32(color.ToArgb()), clamp).ThrowIfFailed();
end;

//procedure TGdipImageAttributes.GetAdjustedPalette(const palette: TGdipColorPalette; const &type: TGdipColorAdjustType);
//begin
//   var buffer := palette.ConvertToBuffer();
//
//           fixed (void* p = buffer)
//        {
//            TGdiplusAPI.GdipGetImageAttributesAdjustedPalette(
//                _nativeImageAttributes,
//                (TGdiPlusAPI.ColorPalette*)p,
//                (TGdiPlusAPI.ColorAdjustType)type).ThrowIfFailed();
//        }
//
//end;

{ TGdipImageAttributesExtensions }

function TGdipImageAttributesExtensions.Pointer(): TGdiplusAPI.TGdipImageAttributesPtr;
begin
   if Self = nil then
      Result := nil
   else
      Result := self._nativeImageAttributes;
end;










{ TGdipColorPalette }

class function TGdipColorPalette.ConvertFromBuffer(buffer: TGdiPlusAPI.TGdipColorPalettePtr): TGdipColorPalette;
var
//   flags: UINT;
   size: UINT;
   entries: TArray<TGdipColor>;
begin
   // Memory layout is:
   //    UINT Flags
   //    UINT Count
   //    ARGB Entries[size]

//   flags := TMarshal.ReadInt32(buffer);
   size := TMarshal.ReadInt32(Pointer(NativeInt(buffer) + SizeOf(size)));
   SetLength(entries, size);

   for var i: Integer := 0 to size - 1 do
   begin
       var argb: UINT := TMarshal.ReadInt32(Pointer(NativeInt(buffer) + 8 + i * SizeOf(4)));
       entries[i] := TGdipColor.FromArgb(argb);
   end;

   Result := TGdipColorPalette.Create(size, entries);
end;

function TGdipColorPalette.ConvertToBuffer(): Pointer;
begin
   // Memory layout is:
   //    UINT Flags
   //    UINT Count
   //    ARGB Entries[size]

   // use TMarshal.SizeOf()
   var length: Integer := Length(_entries);
   var memory: Pointer := TMarshal.AllocHGlobal(checked(4 * (2 + length)));

   TMarshal.WriteInt32(memory, 0, _flags);
   // use Marshal.SizeOf()
   TMarshal.WriteInt32(Pointer(IntPtr(memory) + 4), 0, length);

   for var i: Integer := 0 to  length - 1 do
   begin
       // use Marshal.SizeOf()
       TMarshal.WriteInt32(Pointer(IntPtr(memory) + 4*(i+2)), 0, entries[i].ToArgb());
   end;

   Result := memory;
end;

function TGdipColorPalette.GetFlags(): Integer;
begin
   Result := _flags;
end;

function TGdipColorPalette.GetEntries(): TArray<TGdipColor>;
begin
   Result := _entries;
end;

//constructor TGdipColorPalette.Create();
//begin
//   SetLength(_entries, 1);
//end;


//constructor TGdipColorPalette.Create(count: Integer);
//begin
//   SetLength(_entries, count);
//end;

destructor TGdipColorPalette.Destroy();
begin
   SetLength(_entries, 0);
   inherited;
end;

constructor TGdipColorPalette.Create(const flags: Integer; const entries: TArray<TGdipColor>);
begin
   _flags := flags;
   _entries := entries;
end;

//constructor TGdipColorPalette.Create(const entries: TArray<TGdipColor>);
//begin
//   Create(0, entries);
//
//
//end;

//constructor TGdipColorPalette.Create(const paletteType: TGdipPaletteType);
//begin
//
//
//   var palette: TGdipColorPalette := InitializePalette(paletteType, 0,  False ,  nil );
//
//   _flags := palette.Flags;
//
//   _entries := palette.Entries;
//
//end;

class function TGdipColorPalette.CreateOptimalPalette(const colorCount: Integer; const useTransparentColor: Boolean; const OptimalColors: Integer; const bitmap: TGdipBitmap): TGdipColorPalette;
begin
   Result := InitializePalette(TGdipPaletteType(TGdiPlusAPI.TGdipPaletteTypeEnum.Optimal), colorCount, useTransparentColor, OptimalColors, bitmap);
end;

class function TGdipColorPalette.CreateOptimalPalette(const colorCount: Integer; const useTransparentColor: Boolean; const bitmap: TGdipBitmap): TGdipColorPalette;
begin
   Result := InitializePalette(TGdipPaletteType(TGdiPlusAPI.TGdipPaletteTypeEnum.Optimal), colorCount, useTransparentColor, 0, bitmap);
end;

//class function TGdipColorPalette.ConvertFromBuffer(const buffer: TReadOnlySpan<UInt32>): TGdipColorPalette;
//begin
//   Result :=
//     //
//     // não implementado pelo ObjectPascalCodeGenerator: ImplicitObjectCreationExpression
//     // Arquivo: T:\Data7AdvDsv\source\Apoio\DotNetCore\9-preview2\System.Drawing.Common\src\System\Drawing\Imaging\ColorPalette.cs
//     // Posição: [2307..2386)
//     // Linha: 74
//     //
//     // ----------- começa aqui o que não é suportado ------------
//           new((int)buffer[0], ARGB.ToColorArray(buffer.Slice(2, (int)buffer[1])))
//     // ----------- TERMINA AQUI O QUE É SEM SUPORTE - 2 ------------
//     //
//   ;
//end;

//function TGdipColorPalette.ConvertToBuffer(): TBufferScope<UInt32>;
//begin
//
//
//   var buffer: TBufferScope<UInt32> := TBufferScope<UInt32>TBufferScope<UInt32>.Create(Entries.Length + 2);
//
//   buffer[0] := UInt32(Flags);
//
//   buffer[1] := UInt32(Entries.Length);
//
//
//
//   var i: Integer := 0;
//
//   while (i < Entries.Length) do
//   begin
//
//
//         buffer[i + 2] := TARGB(Entries[i]);
//
//      i := i + 1;
//   end;
//
//
//
//   Exit(buffer);
//end;

class function TGdipColorPalette.InitializePalette(const paletteType: TGdipPaletteType; const colorCount: Integer; const useTransparentColor: Boolean; bitmap: TGdipBitmap): TGdipColorPalette;
begin
   Result := InitializePalette(paletteType, colorCount, useTransparentColor, 0, bitmap);
end;

class function TGdipColorPalette.InitializePalette(const paletteType: TGdipPaletteType; const colorCount: Integer; const useTransparentColor: Boolean; const OptimalColors: Integer; bitmap: TGdipBitmap): TGdipColorPalette;
var
  NativePalette: TGdiPlusAPI.TGdipColorPalettePtr;
begin
   // Reserve the largest possible buffer for the palette.

   NativePalette := TMarshal.AllocHGlobal(colorCount + SizeOf(TGdiPlusAPI.TGdipNativeColorPalette) * SizeOf(UInt32));
   try
      NativePalette.Flags := [];
      NativePalette.Count := colorCount;

      TGdiplusAPI.GdipInitializePalette(
          NativePalette,
          TGdiPlusAPI.TGdipPaletteTypeEnum(paletteType),
          OptimalColors,
          LongBool(useTransparentColor),
          TLogicalUtils.IfElse(bitmap = nil, nil,  bitmap.Pointer)).ThrowIfFailed();


      Result := ConvertFromBuffer(NativePalette);
   finally
      TMarshal.FreeHGlobal(NativePalette);
   end;
end;

{$REGION 'TGdipColorMatrix'}

{ TGdipColorMatrix }

function TGdipColorMatrix.GetMatrix00(): Single;
begin
   Result := _matrix00;
end;

procedure TGdipColorMatrix.SetMatrix00(const Value: Single);
begin
   _matrix00 := value;
end;

function TGdipColorMatrix.GetMatrix01(): Single;
begin
   Result := _matrix01;
end;

procedure TGdipColorMatrix.SetMatrix01(const Value: Single);
begin
   _matrix01 := value;
end;

function TGdipColorMatrix.GetMatrix02(): Single;
begin
   Result := _matrix02;
end;

procedure TGdipColorMatrix.SetMatrix02(const Value: Single);
begin
   _matrix02 := value;
end;

function TGdipColorMatrix.GetMatrix03(): Single;
begin
   Result := _matrix03;
end;

procedure TGdipColorMatrix.SetMatrix03(const Value: Single);
begin
   _matrix03 := value;
end;

function TGdipColorMatrix.GetMatrix04(): Single;
begin
   Result := _matrix04;
end;

procedure TGdipColorMatrix.SetMatrix04(const Value: Single);
begin
   _matrix04 := value;
end;

function TGdipColorMatrix.GetMatrix10(): Single;
begin
   Result := _matrix10;
end;

procedure TGdipColorMatrix.SetMatrix10(const Value: Single);
begin
   _matrix10 := value;
end;

function TGdipColorMatrix.GetMatrix11(): Single;
begin
   Result := _matrix11;
end;

procedure TGdipColorMatrix.SetMatrix11(const Value: Single);
begin
   _matrix11 := value;
end;

function TGdipColorMatrix.GetMatrix12(): Single;
begin
   Result := _matrix12;
end;

procedure TGdipColorMatrix.SetMatrix12(const Value: Single);
begin
   _matrix12 := value;
end;

function TGdipColorMatrix.GetMatrix13(): Single;
begin
   Result := _matrix13;
end;

procedure TGdipColorMatrix.SetMatrix13(const Value: Single);
begin
   _matrix13 := value;
end;

function TGdipColorMatrix.GetMatrix14(): Single;
begin
   Result := _matrix14;
end;

procedure TGdipColorMatrix.SetMatrix14(const Value: Single);
begin
   _matrix14 := value;
end;

function TGdipColorMatrix.GetMatrix20(): Single;
begin
   Result := _matrix20;
end;

procedure TGdipColorMatrix.SetMatrix20(const Value: Single);
begin
   _matrix20 := value;
end;

function TGdipColorMatrix.GetMatrix21(): Single;
begin
   Result := _matrix21;
end;

procedure TGdipColorMatrix.SetMatrix21(const Value: Single);
begin
   _matrix21 := value;
end;

function TGdipColorMatrix.GetMatrix22(): Single;
begin
   Result := _matrix22;
end;

procedure TGdipColorMatrix.SetMatrix22(const Value: Single);
begin
   _matrix22 := value;
end;

function TGdipColorMatrix.GetMatrix23(): Single;
begin
   Result := _matrix23;
end;

procedure TGdipColorMatrix.SetMatrix23(const Value: Single);
begin
   _matrix23 := value;
end;

function TGdipColorMatrix.GetMatrix24(): Single;
begin
   Result := _matrix24;
end;

procedure TGdipColorMatrix.SetMatrix24(const Value: Single);
begin
   _matrix24 := value;
end;

function TGdipColorMatrix.GetMatrix30(): Single;
begin
   Result := _matrix30;
end;

procedure TGdipColorMatrix.SetMatrix30(const Value: Single);
begin
   _matrix30 := value;
end;

function TGdipColorMatrix.GetMatrix31(): Single;
begin
   Result := _matrix31;
end;

procedure TGdipColorMatrix.SetMatrix31(const Value: Single);
begin
   _matrix31 := value;
end;

function TGdipColorMatrix.GetMatrix32(): Single;
begin
   Result := _matrix32;
end;

procedure TGdipColorMatrix.SetMatrix32(const Value: Single);
begin
   _matrix32 := value;
end;

function TGdipColorMatrix.GetMatrix33(): Single;
begin
   Result := _matrix33;
end;

procedure TGdipColorMatrix.SetMatrix33(const Value: Single);
begin
   _matrix33 := value;
end;

function TGdipColorMatrix.GetMatrix34(): Single;
begin
   Result := _matrix34;
end;

procedure TGdipColorMatrix.SetMatrix34(const Value: Single);
begin
   _matrix34 := value;
end;

function TGdipColorMatrix.GetMatrix40(): Single;
begin
   Result := _matrix40;
end;

procedure TGdipColorMatrix.SetMatrix40(const Value: Single);
begin
   _matrix40 := value;
end;

function TGdipColorMatrix.GetMatrix41(): Single;
begin
   Result := _matrix41;
end;

procedure TGdipColorMatrix.SetMatrix41(const Value: Single);
begin
   _matrix41 := value;
end;

function TGdipColorMatrix.GetMatrix42(): Single;
begin
   Result := _matrix42;
end;

procedure TGdipColorMatrix.SetMatrix42(const Value: Single);
begin
   _matrix42 := value;
end;

function TGdipColorMatrix.GetMatrix43(): Single;
begin
   Result := _matrix43;
end;

procedure TGdipColorMatrix.SetMatrix43(const Value: Single);
begin
   _matrix43 := value;
end;

function TGdipColorMatrix.GetMatrix44(): Single;
begin
   Result := _matrix44;
end;

procedure TGdipColorMatrix.SetMatrix44(const Value: Single);
begin
   _matrix44 := value;
end;

constructor TGdipColorMatrix.Create();
begin
   // Configura a matriz identidade por padrão.
   _matrix00 := Single(1.0);
   // matrix01 = 0.0f;
   // matrix02 = 0.0f;
   // matrix03 = 0.0f;
   // matrix04 = 0.0f;
   // matrix10 = 0.0f;

   _matrix11 := Single(1.0);
   // matrix12 = 0.0f;
   // matrix13 = 0.0f;
   // matrix14 = 0.0f;
   // matrix20 = 0.0f;
   // matrix21 = 0.0f;

   _matrix22 := Single(1.0);
   // matrix23 = 0.0f;
   // matrix24 = 0.0f;
   // matrix30 = 0.0f;
   // matrix31 = 0.0f;
   // matrix32 = 0.0f;

   _matrix33 := Single(1.0);
   // matrix34 = 0.0f;
   // matrix40 = 0.0f;
   // matrix41 = 0.0f;
   // matrix42 = 0.0f;
   // matrix43 = 0.0f;

   _matrix44 := Single(1.0);
end;

constructor TGdipColorMatrix.Create(const newColorMatrix: TArray<TArray<Single>>);
begin

   _matrix00 := newColorMatrix[0][0];

   _matrix01 := newColorMatrix[0][1];

   _matrix02 := newColorMatrix[0][2];

   _matrix03 := newColorMatrix[0][3];

   _matrix04 := newColorMatrix[0][4];

   _matrix10 := newColorMatrix[1][0];

   _matrix11 := newColorMatrix[1][1];

   _matrix12 := newColorMatrix[1][2];

   _matrix13 := newColorMatrix[1][3];

   _matrix14 := newColorMatrix[1][4];

   _matrix20 := newColorMatrix[2][0];

   _matrix21 := newColorMatrix[2][1];

   _matrix22 := newColorMatrix[2][2];

   _matrix23 := newColorMatrix[2][3];

   _matrix24 := newColorMatrix[2][4];

   _matrix30 := newColorMatrix[3][0];

   _matrix31 := newColorMatrix[3][1];

   _matrix32 := newColorMatrix[3][2];

   _matrix33 := newColorMatrix[3][3];

   _matrix34 := newColorMatrix[3][4];

   _matrix40 := newColorMatrix[4][0];

   _matrix41 := newColorMatrix[4][1];

   _matrix42 := newColorMatrix[4][2];

   _matrix43 := newColorMatrix[4][3];

   _matrix44 := newColorMatrix[4][4];

end;

//constructor TGdipColorMatrix.Create(const newColorMatrix: TReadOnlySpan<Single>);
//begin
//
//   ArgumentOutOfRangeException.ThrowIfNotEqual(newColorMatrix.Length, 25, nameof(newColorMatrix));
//
//
//     //
//     // Comando não implementado pelo ObjectPascalCodeGenerator: FixedStatement
//     // Arquivo: T:\Data7AdvDsv\source\Apoio\DotNetCore\9-preview2\System.Drawing.Common\src\System\Drawing\Imaging\ColorMatrix.cs
//     // Posição: [9611..9729)
//     // Linha: 341
//     //
//     // ----------- começa aqui o comando não suportado ------------
//
//        fixed (float* f = &_matrix00)
//        {
//            newColorMatrix.CopyTo(new Span<float>(f, 25));
//        }

//
//     // ----------- TERMINA AQUI O COMANDO SEM SUPORTE - 4 ------------
//     //
//
//end;

function TGdipColorMatrix.GetPinnableReference(): PSingle;
begin
   Result := @_matrix00;
end;
function TGdipColorMatrix.GetItem(const row: Integer; const column: Integer): Single;
begin
   if (row < 0) or (row > 4) then
   begin
      raise EArgumentOutOfRangeException.Create('row');
   end;

   if (column < 0) or (column > 4) then
   begin
      raise EArgumentOutOfRangeException.Create('column');
   end;

   var f: PSingle := @_matrix00;
   Result := f[row * 5 + column];
end;

procedure TGdipColorMatrix.SetItem(const row: Integer; const column: Integer; const Value: Single);
begin


   if (row < 0) or (row > 4) then
   begin
         raise EArgumentOutOfRangeException.Create('row');
   end;



   if (column < 0) or (column > 4) then
   begin
         raise EArgumentOutOfRangeException.Create('column');
   end;

   var f: PSingle := @_matrix00;
   f[row * 5 + column] := value;
end;

{$ENDREGION 'TGdipColorMatrix'}






{ TGdipSolidBrush }

function TGdipSolidBrush.GetColor(): TGdipColor;
begin
   if (_color = TGdipColor.Empty) then
   begin
      var color: TARGB;
      TGdiplusAPI.GdipGetSolidFillColor(TGdiplusAPI.TGdipSolidFillPtr(NativeBrush), @color).ThrowIfFailed();
      _color := color;
   end;

   // GDI+ doesn't understand system colors, so we can't use GdipGetSolidFillColor in the general case.
   Exit(_color);
end;

procedure TGdipSolidBrush.SetColor(const Value: TGdipColor);
begin


   if (_immutable) then
   begin
         raise EArgumentException.Create('SR.Format(SR.CantChangeImmutableObjects, ''Brush'')');
   end;



   if (_color <> value) then
   begin
         var oldColor: TGdipColor := _color;

         InternalSetColor(value);

         // NOTA: Nós nunca removemos pincéis da lista ativa, portanto, se alguém for
         // mudando muito as cores do pincel, isso pode ser um problema.
//         if (value.IsSystemColor) and (not oldColor.IsSystemColor) then
//         begin
//               SystemColorTracker.Add(Self);
//         end;
   end;
end;

constructor TGdipSolidBrush.Create(const color: TGdipColor);
begin
   inherited Create();
   _color := color;

   var nativeBrush: TGdiplusAPI.TGdipSolidFillPtr;
   TGdiplusAPI.GdipCreateSolidFill(TARGB(color), nativeBrush).ThrowIfFailed();
   SetNativeBrushInternal(TGdiplusAPI.TGdipBrushPtr(nativeBrush));

//   if (_color.IsSystemColor) then
//   begin
//      SystemColorTracker.Add(Self);
//   end;

end;

constructor TGdipSolidBrush.Create(const color: TGdipColor; const immutable: Boolean);
begin
   Create(color);
   _immutable := immutable;
end;

constructor TGdipSolidBrush.Create(const nativeBrush: TGdiplusAPI.TGdipSolidFillPtr);
begin
   inherited Create();

   Assert(nativeBrush <> nil, 'Initializing native brush with null.');
   SetNativeBrushInternal(TGdiplusAPI.TGdipBrushPtr(nativeBrush));
end;

function TGdipSolidBrush.Clone(): TObject;
begin
   var clonedBrush: TGdiplusAPI.TGdipBrushPtr;
   TGdiplusAPI.GdipCloneBrush(NativeBrush, clonedBrush).ThrowIfFailed();

   // Clones of immutable brushes are not immutable.
   Exit(TGdipSolidBrush.Create(TGdiplusAPI.TGdipSolidFillPtr(clonedBrush)));
end;

procedure TGdipSolidBrush.Dispose(const disposing: Boolean);
begin
   if (not disposing) then
   begin
         _immutable := false;
   end
   else
   begin

      if (_immutable) then
      begin
            raise EArgumentException.Create('SR.Format(SR.CantChangeImmutableObjects, ''Brush'')');
      end;
   end;

   inherited Dispose(disposing);
end;

procedure TGdipSolidBrush.InternalSetColor(const value: TGdipColor);
begin
   TGdiplusAPI.GdipSetSolidFillColor(TGdiplusAPI.TGdipSolidFillPtr(NativeBrush), TARGB(value)).ThrowIfFailed();
   _color := value;
end;

procedure TGdipSolidBrush.OnSystemColorChanged();
begin
   if (NativeBrush <> nil) then
   begin
      InternalSetColor(_color);
   end;
end;


{$REGION 'TGdipMatrix'}

{ TGdipMatrix }

class constructor TGdipMatrix.Create();
begin
end;

procedure TGdipMatrix.AfterConstruction;
begin
   inherited;
end;

procedure TGdipMatrix.BeforeDestruction;
begin
   inherited;
end;

function TGdipMatrix.GetElements(): TArray<Single>;
begin


   var elements: TArray<Single>;
   SetLength(elements, 6);

   GetElements(elements);


   Exit(elements);
end;

function TGdipMatrix.GetMatrixElements(): TMatrix3x2;
begin
   var matrix: TMatrix3x2 := Default(TMatrix3x2);

   TGdiplusAPI.GdipGetMatrixElements(NativeMatrix, PSingle(@matrix)).ThrowIfFailed();

   Exit(matrix);
end;

procedure TGdipMatrix.SetMatrixElements(const Value: TMatrix3x2);
begin
   TGdiplusAPI.GdipSetMatrixElements(NativeMatrix, value.M11, value.M12, value.M21, value.M22, value.M31, value.M32).ThrowIfFailed();
end;

function TGdipMatrix.GetOffsetX(): Single;
begin
   Result := Offset.X;
end;

function TGdipMatrix.GetOffsetY(): Single;
begin
   Result := Offset.Y;
end;

function TGdipMatrix.GetOffset(): TPointF;
begin

   var elements: TArray<Single>;
   SetLength(elements, 3);

   GetElements(elements);

   raise ENotImplemented.Create('ainda não fiz isso aqui');
//   Exit(TPointF.Create(elements[4], elements[5]));
end;

function TGdipMatrix.GetIsInvertible(): Boolean;
begin
   var invertible: LongBool;
   TGdiplusAPI.GdipIsMatrixInvertible(NativeMatrix,  invertible).ThrowIfFailed();
   Result := invertible;
end;

function TGdipMatrix.GetIsIdentity(): Boolean;
begin
   var identity: LongBool;
   TGdiplusAPI.GdipIsMatrixIdentity(NativeMatrix, identity).ThrowIfFailed();
   Result := identity;
end;

destructor TGdipMatrix.Destroy();
begin
   DisposeInternal();
   inherited Destroy();
end;

constructor TGdipMatrix.Create();
begin
   var matrix: TGdiplusAPI.TGdipMatrixPtr;
   TGdiplusAPI.GdipCreateMatrix(matrix).ThrowIfFailed();
   NativeMatrix := matrix;
end;

constructor TGdipMatrix.Create(const m11: Single; const m12: Single; const m21: Single; const m22: Single; const dx: Single; const dy: Single);
begin
   var matrix: TGdiplusAPI.TGdipMatrixPtr;
   TGdiplusAPI.GdipCreateMatrix2(m11, m12, m21, m22, dx, dy, matrix).ThrowIfFailed();
   NativeMatrix := matrix;
end;

constructor TGdipMatrix.Create(const matrix: TMatrix3x2);
begin
   Create(CreateNativeHandle(matrix));


end;

constructor TGdipMatrix.Create(const nativeMatrix: TGdiplusAPI.TGdipMatrixPtr);
begin
end;

constructor TGdipMatrix.Create(const rect: TRectangleF; const plgpts: TArray<TPointF>);
begin
   if (Length(plgpts) <> 3) then
   begin
      raise TGdiplusAPI.TGdipStatusEnum.InvalidParameter.GetException();
   end;

   var matrix: TGdiplusAPI.TGdipMatrixPtr;
   TGdiplusAPI.GdipCreateMatrix3(@rect, @plgpts[0], matrix).ThrowIfFailed();
   NativeMatrix := matrix;
end;

constructor TGdipMatrix.Create(const rect: TRectangle; const plgpts: TArray<TPoint>);
begin
   if (Length(plgpts) <> 3) then
   begin
      raise TGdiplusAPI.TGdipStatusEnum.InvalidParameter.GetException();
   end;

   var matrix: TGdiplusAPI.TGdipMatrixPtr;
   TGdiplusAPI.GdipCreateMatrix3I(@rect, @plgpts[0], matrix).ThrowIfFailed();
   NativeMatrix := matrix;
end;

class function TGdipMatrix.CreateNativeHandle(const matrix: TMatrix3x2): TGdiPlusAPI.TGdipMatrixPtr;
begin
   var nativeMatrix: TGdiPlusAPI.TGdipMatrixPtr;

   TGdiPlusAPI.GdipCreateMatrix2(matrix.M11, matrix.M12, matrix.M21, matrix.M22, matrix.M31, matrix.M32, nativeMatrix).ThrowIfFailed();



   Exit(nativeMatrix);
end;

procedure TGdipMatrix.Dispose();
begin
   DisposeInternal();
end;

procedure TGdipMatrix.DisposeInternal();
begin
   if (NativeMatrix <> nil) then
   begin
      if (TGdip.Initialized) then
      begin
         TGdiplusAPI.GdipDeleteMatrix(NativeMatrix);
      end;

      NativeMatrix := nil;
   end;
end;

function TGdipMatrix.Clone(): TGdipMatrix;
begin
   var matrix: TGdiplusAPI.TGdipMatrixPtr;
   TGdiplusAPI.GdipCloneMatrix(NativeMatrix, matrix).ThrowIfFailed();
   Result := TGdipMatrix.Create(matrix);
end;

procedure TGdipMatrix.GetElements(var elements: TArray<Single>);
begin
   Assert(Length(elements) >= 6);
   TGdiplusAPI.GdipGetMatrixElements(NativeMatrix, @elements[0]).ThrowIfFailed();
end;

procedure TGdipMatrix.Reset();
begin
   TGdiplusAPI.GdipSetMatrixElements(NativeMatrix, Single(1.0), Single(0.0), Single(0.0), Single(1.0), Single(0.0), Single(0.0)).ThrowIfFailed();
end;

procedure TGdipMatrix.Multiply(const matrix: TGdipMatrix);
begin
   Multiply(matrix, TGdipMatrixOrder.Prepend);
end;

procedure TGdipMatrix.Multiply(const matrix: TGdipMatrix; const order: TGdipMatrixOrder);
begin
   if matrix = nil then
      raise EArgumentNilException.Create('matrix');

   if (matrix.NativeMatrix = NativeMatrix) then
   begin
      raise EInvalidOpException.Create('SR.GdiplusObjectBusy');
   end;

   TGdiplusAPI.GdipMultiplyMatrix(NativeMatrix, matrix.NativeMatrix, TGdiplusAPI.TGdipMatrixOrderEnum(order)).ThrowIfFailed();
end;

procedure TGdipMatrix.Translate(const offsetX: Single; const offsetY: Single);
begin
   Translate(offsetX, offsetY, TGdipMatrixOrder.Prepend);
end;

procedure TGdipMatrix.Translate(const offsetX: Single; const offsetY: Single; const order: TGdipMatrixOrder);
begin
   TGdiplusAPI.GdipTranslateMatrix(NativeMatrix, offsetX, offsetY, TGdiplusAPI.TGdipMatrixOrderEnum(order)).ThrowIfFailed();
end;

procedure TGdipMatrix.Scale(const scaleX: Single; const scaleY: Single);
begin
   Scale(scaleX, scaleY, TGdipMatrixOrder.Prepend);
end;

procedure TGdipMatrix.Scale(const scaleX: Single; const scaleY: Single; const order: TGdipMatrixOrder);
begin
   TGdiplusAPI.GdipScaleMatrix(NativeMatrix, scaleX, scaleY, TGdiplusAPI.TGdipMatrixOrderEnum(order)).ThrowIfFailed();
end;

procedure TGdipMatrix.Rotate(const angle: Single);
begin
   Rotate(angle, TGdipMatrixOrder.Prepend);
end;

procedure TGdipMatrix.Rotate(const angle: Single; const order: TGdipMatrixOrder);
begin
   TGdiplusAPI.GdipRotateMatrix(NativeMatrix, angle, TGdiplusAPI.TGdipMatrixOrderEnum(order)).ThrowIfFailed();
end;

procedure TGdipMatrix.RotateAt(const angle: Single; const point: TPointF);
begin
   RotateAt(angle, point, TGdipMatrixOrder.Prepend);
end;

procedure TGdipMatrix.RotateAt(const angle: Single; const point: TPointF; const order: TGdipMatrixOrder);
begin
   var status: TGdiplusAPI.TGdipStatusEnum;

   if (order = TGdipMatrixOrder.Prepend) then
   begin
      status := TGdiplusAPI.GdipTranslateMatrix(NativeMatrix, point.X, point.Y, TGdiplusAPI.TGdipMatrixOrderEnum(order));
      status := status or TGdiplusAPI.GdipRotateMatrix(NativeMatrix, angle, TGdiplusAPI.TGdipMatrixOrderEnum(order));
      status := status or TGdiplusAPI.GdipTranslateMatrix(NativeMatrix, -point.X, -point.Y, TGdiplusAPI.TGdipMatrixOrderEnum(order));
   end
   else
   begin
      status := TGdiplusAPI.GdipTranslateMatrix(NativeMatrix, -point.X, -point.Y, TGdiplusAPI.TGdipMatrixOrderEnum(order));
      status := status or TGdiplusAPI.GdipRotateMatrix(NativeMatrix, angle, TGdiplusAPI.TGdipMatrixOrderEnum(order));
      status := status or TGdiplusAPI.GdipTranslateMatrix(NativeMatrix, point.X, point.Y, TGdiplusAPI.TGdipMatrixOrderEnum(order));
   end;

   status.ThrowIfFailed();
end;

procedure TGdipMatrix.Shear(const shearX: Single; const shearY: Single);
begin
   TGdiplusAPI.GdipShearMatrix(NativeMatrix, shearX, shearY, TGdiplusAPI.TGdipMatrixOrderEnum.Prepend).ThrowIfFailed();
end;

procedure TGdipMatrix.Shear(const shearX: Single; const shearY: Single; const order: TGdipMatrixOrder);
begin
   TGdiplusAPI.GdipShearMatrix(NativeMatrix, shearX, shearY, TGdiplusAPI.TGdipMatrixOrderEnum(order)).ThrowIfFailed();
end;

procedure TGdipMatrix.Invert();
begin
   TGdiplusAPI.GdipInvertMatrix(NativeMatrix).ThrowIfFailed();
end;

procedure TGdipMatrix.TransformPoints(const pts: TArray<TPointF>);
begin
   if pts = nil then
      raise EArgumentNilException.Create('pts');

   TGdiplusAPI.GdipTransformMatrixPoints(NativeMatrix, @pts[0], Length(pts)).ThrowIfFailed();
end;

procedure TGdipMatrix.TransformPoints(const pts: TArray<TPoint>);
begin
   if pts = nil then
      raise EArgumentNilException.Create('pts');

   TGdiplusAPI.GdipTransformMatrixPointsI(NativeMatrix, @pts[0], Length(pts)).ThrowIfFailed();
end;

procedure TGdipMatrix.TransformVectors(const pts: TArray<TPointF>);
begin
   if pts = nil then
      raise EArgumentNilException.Create('pts');

   TGdiplusAPI.GdipVectorTransformMatrixPoints(NativeMatrix, @pts[0], Length(pts)).ThrowIfFailed();
end;

procedure TGdipMatrix.VectorTransformPoints(const pts: TArray<TPoint>);
begin
   TransformVectors(pts);
end;

procedure TGdipMatrix.TransformVectors(const pts: TArray<TPoint>);
begin
   if pts = nil then
      raise EArgumentNilException.Create('pts');

   TGdiplusAPI.GdipVectorTransformMatrixPointsI(NativeMatrix, @pts[0], Length(pts)).ThrowIfFailed();
end;

function TGdipMatrix.Equals(obj: TObject): Boolean;
begin
   if not (obj is TGdipMatrix) then
   begin
      Exit(false);
   end;

   var matrix2 := obj as TGdipMatrix;
   var equal: LongBool;
   TGdiplusAPI.GdipIsMatrixEqual(NativeMatrix, matrix2.NativeMatrix, equal).ThrowIfFailed();

   Result := equal;
end;

{$ENDREGION 'TGdipMatrix'}




{ TGdipPen }

class constructor TGdipPen.Create();
begin
end;

procedure TGdipPen.AfterConstruction;
begin
   inherited;
end;

procedure TGdipPen.BeforeDestruction;
begin
   inherited;
end;

function TGdipPen.GetNativePen(): TGdiplusAPI.TGdipPenPtr;
begin
   Result := _nativePen;
end;

function TGdipPen.GetWidth(): Single;
begin
   var width: Single;
   TGdiplusAPI.GdipGetPenWidth(NativePen, width).ThrowIfFailed();
   Result := width;
end;

procedure TGdipPen.SetWidth(const Value: Single);
begin
   if (_immutable) then
   begin
      raise EArgumentException.Create('SR.Format(SR.CantChangeImmutableObjects, nameof(TGdipPen))');
   end;

   TGdiplusAPI.GdipSetPenWidth(NativePen, value).ThrowIfFailed();
end;

function TGdipPen.GetStartCap(): TGdipLineCap;
begin
   var startCap: TGdiplusAPI.TGdipLineCapEnum;
   TGdiplusAPI.GdipGetPenStartCap(NativePen, startCap).ThrowIfFailed();
   Result := TGdipLineCap(startCap);
end;

procedure TGdipPen.SetStartCap(const Value: TGdipLineCap);
begin


   case (value) of
      TGdipLineCap.Flat,
      TGdipLineCap.Square,
      TGdipLineCap.Round,
      TGdipLineCap.Triangle,
      TGdipLineCap.NoAnchor,
      TGdipLineCap.SquareAnchor,
      TGdipLineCap.RoundAnchor,
      TGdipLineCap.DiamondAnchor,
      TGdipLineCap.ArrowAnchor,
      TGdipLineCap.AnchorMask,
      TGdipLineCap.Custom:
      begin
      end;
   else
      raise EInvalidArgument.Create('nameof(value), Integer(value), TypeInfo(TGdipLineCap)');
   end;

   if (_immutable) then
   begin
      raise EArgumentException.Create('SR.Format(SR.CantChangeImmutableObjects, nameof(TGdipPen))');
   end;

   TGdiplusAPI.GdipSetPenStartCap(NativePen, TGdiPlusAPI.TGdipLineCapEnum(value)).ThrowIfFailed();
end;

function TGdipPen.GetEndCap(): TGdipLineCap;
begin
   var endCap: TGdiPlusAPI.TGdipLineCapEnum;
   TGdiPlusAPI.GdipGetPenEndCap(NativePen, endCap).ThrowIfFailed();
   Result := TGdipLineCap(endCap);
end;

procedure TGdipPen.SetEndCap(const Value: TGdipLineCap);
begin
   case (value) of
      TGdipLineCap.Flat,
      TGdipLineCap.Square,
      TGdipLineCap.Round,
      TGdipLineCap.Triangle,
      TGdipLineCap.NoAnchor,
      TGdipLineCap.SquareAnchor,
      TGdipLineCap.RoundAnchor,
      TGdipLineCap.DiamondAnchor,
      TGdipLineCap.ArrowAnchor,
      TGdipLineCap.AnchorMask,
      TGdipLineCap.Custom:
      begin
      end;
   else
      raise EInvalidArgument.Create('nameof(value), Integer(value), TypeInfo(TGdipLineCap)');
   end;

   if (_immutable) then
   begin
      raise EArgumentException.Create('SR.Format(SR.CantChangeImmutableObjects, nameof(TGdipPen))');
   end;

   TGdiPlusAPI.GdipSetPenEndCap(NativePen, TGdiPlusAPI.TGdipLineCapEnum(value)).ThrowIfFailed();
end;

function TGdipPen.GetCustomStartCap(): TGdipCustomLineCap;
begin
   var lineCap: TGdiPlusAPI.TGdipCustomLineCapPtr;
   TGdiPlusAPI.GdipGetPenCustomStartCap(NativePen, lineCap).ThrowIfFailed();
   Result := TGdipCustomLineCap.CreateCustomLineCapObject(lineCap);
end;

procedure TGdipPen.SetCustomStartCap(const Value: TGdipCustomLineCap);
begin
   if (_immutable) then
   begin
      raise EArgumentException.Create('SR.Format(SR.CantChangeImmutableObjects, nameof(TGdipPen))');
   end;

   if value = nil then
      TGdiPlusAPI.GdipSetPenCustomStartCap(NativePen, nil).ThrowIfFailed()
   else
      TGdiPlusAPI.GdipSetPenCustomStartCap(NativePen, value._nativeCap).ThrowIfFailed();
end;

function TGdipPen.GetCustomEndCap(): TGdipCustomLineCap;
begin
   var lineCap: TGdiplusAPI.TGdipCustomLineCapPtr;
   TGdiPlusAPI.GdipGetPenCustomEndCap(NativePen, lineCap).ThrowIfFailed();
   Result := TGdipCustomLineCap.CreateCustomLineCapObject(lineCap);
end;

procedure TGdipPen.SetCustomEndCap(const Value: TGdipCustomLineCap);
begin
   if (_immutable) then
   begin
      raise EArgumentException.Create('SR.Format(SR.CantChangeImmutableObjects, nameof(TGdipPen))');
   end;

   if value = nil then
      TGdiPlusAPI.GdipSetPenCustomEndCap(NativePen, nil).ThrowIfFailed()
   else
      TGdiPlusAPI.GdipSetPenCustomEndCap(NativePen, value._nativeCap).ThrowIfFailed();
end;

function TGdipPen.GetDashCap(): TGdipDashCap;
begin
   var dashCap: TGdiPlusAPI.TGdipDashCapEnum;
   TGdiPlusAPI.GdipGetPenDashCap197819(NativePen, dashCap).ThrowIfFailed();
   Result := TGdipDashCap(dashCap);
end;

procedure TGdipPen.SetDashCap(const Value: TGdipDashCap);
begin
   if not (value = TGdipDashCap.Flat) and not (value = TGdipDashCap.Round) and not (value = TGdipDashCap.Triangle) then
   begin
      raise EInvalidArgument.Create('nameof(value), Integer(value), TypeInfo(TGdipDashCap)');
   end;

   if (_immutable) then
   begin
      raise EArgumentException.Create('SR.Format(SR.CantChangeImmutableObjects, nameof(TGdipPen))');
   end;

   TGdiPlusAPI.GdipSetPenDashCap197819(NativePen, TGdiPlusAPI.TGdipDashCapEnum(value)).ThrowIfFailed();
end;

function TGdipPen.GetLineJoin(): TGdipLineJoin;
begin
   var lineJoin: TGdiPlusAPI.TGdipLineJoinEnum;
   TGdiPlusAPI.GdipGetPenLineJoin(NativePen, lineJoin).ThrowIfFailed();
   Result := TGdipLineJoin(lineJoin);
end;

procedure TGdipPen.SetLineJoin(const Value: TGdipLineJoin);
begin
   if (value < TGdipLineJoin.Miter) or (value > TGdipLineJoin.MiterClipped) then
   begin
      raise EInvalidArgument.Create('nameof(value), Integer(value), TypeInfo(TGdipLineJoin)');
   end;

   if (_immutable) then
   begin
      raise EArgumentException.Create('SR.Format(SR.CantChangeImmutableObjects, nameof(TGdipPen))');
   end;

   TGdiPlusAPI.GdipSetPenLineJoin(NativePen, TGdiPlusAPI.TGdipLineJoinEnum(value)).ThrowIfFailed();
end;

function TGdipPen.GetMiterLimit(): Single;
begin
   var miterLimit: Single;
   TGdiPlusAPI.GdipGetPenMiterLimit(NativePen, miterLimit).ThrowIfFailed();
   Result := miterLimit;
end;

procedure TGdipPen.SetMiterLimit(const Value: Single);
begin
   if (_immutable) then
   begin
      raise EArgumentException.Create('SR.Format(SR.CantChangeImmutableObjects, nameof(TGdipPen))');
   end;

   TGdiPlusAPI.GdipSetPenMiterLimit(NativePen, value).ThrowIfFailed();
end;

function TGdipPen.GetAlignment(): TGdipPenAlignment;
begin
   var penMode: TGdiPlusAPI.TGdipPenAlignmentEnum;
   TGdiPlusAPI.GdipGetPenMode(NativePen, penMode).ThrowIfFailed();
   Result := TGdipPenAlignment(penMode);
end;

procedure TGdipPen.SetAlignment(const Value: TGdipPenAlignment);
begin
   if (value < TGdipPenAlignment.Center) or (value > TGdipPenAlignment.Right) then
   begin
      raise EInvalidArgument.Create('nameof(value), Integer(value), TypeInfo(TGdipPenAlignment)');
   end;

   if (_immutable) then
   begin
      raise EArgumentException.Create('SR.Format(SR.CantChangeImmutableObjects, nameof(TGdipPen))');
   end;

   TGdiPlusAPI.GdipSetPenMode(NativePen, TGdiPlusAPI.TGdipPenAlignmentEnum(value)).ThrowIfFailed();
end;

function TGdipPen.GetTransform(): TGdipMatrix;
begin
   var matrix: TGdipMatrix := TGdipMatrix.Create();
   TGdiPlusAPI.GdipGetPenTransform(NativePen, matrix.NativeMatrix).ThrowIfFailed();
   Result := matrix;
end;

procedure TGdipPen.SetTransform(const Value: TGdipMatrix);
begin
   if (_immutable) then
   begin
      raise EArgumentException.Create('SR.Format(SR.CantChangeImmutableObjects, nameof(TGdipPen))');
   end;

   if value = nil then
      raise EArgumentNilException.Create('value');

   TGdiPlusAPI.GdipSetPenTransform(NativePen, value.NativeMatrix).ThrowIfFailed();
end;

function TGdipPen.GetPenType(): TGdipPenType;
begin
   var &type: TGdiPlusAPI.TGdipPenTypeEnum;
   TGdiPlusAPI.GdipGetPenFillType(NativePen, &type).ThrowIfFailed();
   Result := TGdipPenType(&type);
end;

function TGdipPen.GetColor(): TGdipColor;
begin
   if (_color = TGdipColor.Empty) then
   begin
      if (PenType <> TGdipPenType.SolidColor) then
      begin
         raise EArgumentException.Create('SR.GdiplusInvalidParameter');
      end;

      var color: TARGB;
      TGdiPlusAPI.GdipGetPenColor(NativePen, @color).ThrowIfFailed();
      _color := color;
   end;

   // GDI+ doesn't understand system colors, so we can't use GdipGetPenColor in the general case.
   Result := _color;
end;

procedure TGdipPen.SetColor(const Value: TGdipColor);
begin
   if (_immutable) then
   begin
      raise EArgumentException.Create('SR.Format(SR.CantChangeImmutableObjects, nameof(TGdipPen))');
   end;

   if (value <> _color) then
   begin
         var oldColor: TGdipColor := _color;
         _color := value;
         InternalSetColor(value);

         // NOTE: We never remove pens from the active list, so if someone is
         // changing their pen colors a lot, this could be a problem.

//         if (value.IsSystemColor) and (not oldColor.IsSystemColor) then
//         begin
////            SystemColorTracker.Add(Self);
//         end;
   end;
end;

function TGdipPen.GetBrush(): TGdipBrush;
begin
   var brush: TGdipBrush := nil;

   case (PenType) of
      TGdipPenType.SolidColor:
         brush := TGdipSolidBrush.Create(TGdiPlusAPI.TGdipSolidFillPtr(GetNativeBrush()));

      TGdipPenType.HatchFill:
         brush := TGdipHatchBrush.Create(TGdiplusAPI.TGdipHatchPtr(GetNativeBrush()));

      TGdipPenType.TextureFill:
         brush := TGdipTextureBrush.Create(TGdiplusAPI.TGdipTexturePtr(GetNativeBrush()));

      TGdipPenType.PathGradient:
         brush := TGdipPathGradientBrush.Create(TGdiplusAPI.TGdipPathGradientPtr(GetNativeBrush()));

      TGdipPenType.LinearGradient:
         brush := TGdipLinearGradientBrush.Create(TGdiplusAPI.TGdipLineGradientPtr(GetNativeBrush()));
   end;

   Result := brush;
end;

procedure TGdipPen.SetBrush(const Value: TGdipBrush);
begin
   if (_immutable) then
   begin
      raise EArgumentException.Create('SR.Format(SR.CantChangeImmutableObjects, nameof(TGdipPen))');
   end;

   if value = nil then
      raise EArgumentNilException.Create('value');

   TGdiplusAPI.GdipSetPenBrushFill(NativePen, value.NativeBrush).ThrowIfFailed();
end;

function TGdipPen.GetDashStyle(): TGdipDashStyle;
begin
   var dashStyle: TGdiplusAPI.TGdipDashStyleEnum;

   TGdiplusAPI.GdipGetPenDashStyle(NativePen, dashStyle).ThrowIfFailed();

   Result := TGdipDashStyle(dashStyle);
end;

procedure TGdipPen.SetDashStyle(const Value: TGdipDashStyle);
begin


   if (Value < TGdipDashStyle.Solid) or (Value > TGdipDashStyle.Custom) then
   begin
         raise EInvalidArgument.Create('nameof(value), Integer(value), TypeInfo(TGdipDashStyle)');
   end;

   if (_immutable) then
   begin
         raise EArgumentException.Create('SR.Format(SR.CantChangeImmutableObjects, nameof(TGdipPen))');
   end;


   TGdiplusAPI.GdipSetPenDashStyle(NativePen, TGdiPlusAPI.TGdipDashStyleEnum(value)).ThrowIfFailed();

   // If we just set the pen style to Custom without defining the custom dash pattern,
   // make sure that we can return a valid value.

   if (value = TGdipDashStyle.Custom) then
   begin
         EnsureValidDashPattern();
   end;

   if (value <> TGdipDashStyle.Solid) then
   begin
         _dashStyleWasOrIsNotSolid := true;
   end;
end;

function TGdipPen.GetDashOffset(): Single;
begin
   var dashOffset: Single;
   TGdiplusAPI.GdipGetPenDashOffset(NativePen, dashOffset).ThrowIfFailed();
   Result := dashOffset;
end;

procedure TGdipPen.SetDashOffset(const Value: Single);
begin
   if (_immutable) then
   begin
      raise EArgumentException.Create('SR.Format(SR.CantChangeImmutableObjects, nameof(TGdipPen))');
   end;

   TGdiplusAPI.GdipSetPenDashOffset(NativePen, value).ThrowIfFailed();
end;

function TGdipPen.GetDashPattern(): TArray<Single>;
begin
   var count: Integer;
   TGdiplusAPI.GdipGetPenDashCount(NativePen, count).ThrowIfFailed();

   var pattern: TArray<Single>;

   // don't call GdipGetPenDashArray with a 0 count
   if (count > 0) then
   begin
      SetLength(pattern, count);
      TGdiplusAPI.GdipGetPenDashArray(NativePen, @pattern[0], count).ThrowIfFailed();
   end
   else
   begin
      if (DashStyle = TGdipDashStyle.Solid) and (not _dashStyleWasOrIsNotSolid) then
      begin
          // Most likely we're replicating an existing System.Drawing bug here, it doesn't make much sense to
          // ask for a dash pattern when using a solid dash.
          raise EOutOfMemory.Create('Falta de memoria identificada');
      end
      else
      begin
         if (DashStyle = TGdipDashStyle.Solid) then
         begin
            pattern := [];
         end
         else
         begin
            // special case (not handled inside GDI+)
            pattern :=[1.0];
         end;
      end;
   end;


   Result := pattern;
end;

procedure TGdipPen.SetDashPattern(const Value: TArray<Single>);
begin

   if (_immutable) then
   begin
      raise EArgumentException.Create('SR.Format(SR.CantChangeImmutableObjects, nameof(TGdipPen))');
   end;

   if (value = nil) or (Length(value) = 0) then
   begin
      raise EArgumentException.Create('SR.InvalidDashPattern');
   end;

   TGdiplusAPI.GdipSetPenDashArray(NativePen, @value[0], Length(value)).ThrowIfFailed();
end;

function TGdipPen.GetCompoundArray(): TArray<Single>;
begin
   var count: Integer;
   TGdiplusAPI.GdipGetPenCompoundCount(NativePen, count).ThrowIfFailed();

   if (count = 0) then
   begin
      SetLength(Result, 0);
      Exit();
   end;

   var &array: TArray<Single>;
   SetLength(&array, count);

   TGdiplusAPI.GdipGetPenCompoundArray(NativePen, @&array[0], count).ThrowIfFailed();
   Result := &array;
end;

procedure TGdipPen.SetCompoundArray(const Value: TArray<Single>);
begin
   if (_immutable) then
   begin
      raise EArgumentException.Create('SR.Format(SR.CantChangeImmutableObjects, nameof(TGdipPen))');
   end;

   if (value = nil) then
      raise EArgumentException.Create('Value');

   TGdiplusAPI.GdipSetPenCompoundArray(NativePen, @value[0], Length(value)).ThrowIfFailed();
end;

constructor TGdipPen.Create(const nativePen: TGdiplusAPI.TGdipPenPtr);
begin
   SetNativePen(nativePen);
end;

constructor TGdipPen.Create(const color: TGdipColor; const immutable: Boolean);
begin
   Create(color);
   _immutable := immutable;
end;

constructor TGdipPen.Create(const color: TGdipColor);
begin
   Create(color, Single(1.0));
end;

constructor TGdipPen.Create(const color: TGdipColor; const width: Single);
begin
   _color := color;
   var pen: TGdiplusAPI.TGdipPenPtr;
   TGdiplusAPI.GdipCreatePen1(UInt32(color.ToArgb()), width, TGdiplusAPI.TGdipUnitEnum.World, pen).ThrowIfFailed();
   SetNativePen(pen);

//   if (_color.IsSystemColor) then
//   begin
//         SystemColorTracker.Add(Self);
//   end;

end;

constructor TGdipPen.Create(const brush: TGdipBrush);
begin
   Create(brush, Single(1.0));


end;

constructor TGdipPen.Create(const brush: TGdipBrush; const width: Single);
begin
   if brush = nil then
      raise EArgumentNilException.Create('brush');

   var pen: TGdiplusAPI.TGdipPenPtr;
   TGdiplusAPI.GdipCreatePen2(brush.NativeBrush, width, TGdiplusAPI.TGdipUnitEnum.World, pen).ThrowIfFailed();
   SetNativePen(pen);
end;

procedure TGdipPen.SetNativePen(const nativePen: TGdiplusAPI.TGdipPenPtr);
begin
   Assert(nativePen <> nil);
   _nativePen := nativePen;
end;

function TGdipPen.Clone(): TObject;
begin
   var clonedPen: TGdiplusAPI.TGdipPenPtr;
   TGdiplusAPI.GdipClonePen(NativePen, clonedPen).ThrowIfFailed();
   Exit(TGdipPen.Create(clonedPen));
end;

destructor TGdipPen.Destroy();
begin
   Dispose( True );
   inherited Destroy();
end;

procedure TGdipPen.Dispose();
begin
   Dispose( True );
end;

procedure TGdipPen.Dispose(const disposing: Boolean);
begin
   if (not disposing) then
   begin

         // If we are finalizing, then we will be unreachable soon. Finalize calls dispose to
         // release resources, so we must make sure that during finalization we are
         // not immutable.

         _immutable := false;
   end
   else
   begin

      if (_immutable) then
      begin


            raise EArgumentException.Create('SR.Format(SR.CantChangeImmutableObjects, nameof(TGdipPen))');
      end;
   end;



   if (_nativePen <> nil) then
   begin



         try
            try
                  // #if DEBUG -> IfDirectiveTrivia
                  // Status status = !Gdip.Initialized ? Status.Ok : -> DisabledTextTrivia
                  // #endif -> EndIfDirectiveTrivia

                  TGdiplusAPI.GdipDeletePen(NativePen);
            except on ex: Exception do // when (!ClientUtils.IsSecurityOrCriticalException(ex))
            end;
         finally

               _nativePen := nil;
         end;

   end;
end;

procedure TGdipPen.SetLineCap(const startCap: TGdipLineCap; const endCap: TGdipLineCap; const dashCap: TGdipDashCap);
begin
   if (_immutable) then
   begin
      raise EArgumentException.Create('SR.Format(SR.CantChangeImmutableObjects, nameof(TGdipPen))');
   end;

   TGdiplusAPI.GdipSetPenLineCap197819(NativePen, TGdiPlusAPI.TGdipLineCapEnum(startCap), TGdiPlusAPI.TGdipLineCapEnum(endCap), TGdiPlusAPI.TGdipDashCapEnum(dashCap)).ThrowIfFailed();
end;

procedure TGdipPen.ResetTransform();
begin
   TGdiplusAPI.GdipResetPenTransform(NativePen).ThrowIfFailed();
end;

procedure TGdipPen.MultiplyTransform(const matrix: TGdipMatrix);
begin
   MultiplyTransform(matrix, TGdipMatrixOrder.Prepend);
end;

procedure TGdipPen.MultiplyTransform(const matrix: TGdipMatrix; const order: TGdipMatrixOrder);
begin
   if matrix = nil then
      raise EArgumentNilException.Create('matrix');


   if (matrix.NativeMatrix = nil) then
   begin
         // Disposed matrices should result in a no-op.
         Exit();
   end;

   TGdiplusAPI.GdipMultiplyPenTransform(NativePen, matrix.NativeMatrix, TGdiPlusApi.TGdipMatrixOrderEnum(order)).ThrowIfFailed();
end;

procedure TGdipPen.TranslateTransform(const dx: Single; const dy: Single);
begin
   TranslateTransform(dx, dy, TGdipMatrixOrder.Prepend);
end;

procedure TGdipPen.TranslateTransform(const dx: Single; const dy: Single; const order: TGdipMatrixOrder);
begin
   TGdiplusAPI.GdipTranslatePenTransform(NativePen, dx, dy, TGdiPlusAPI.TGdipMatrixOrderEnum(order)).ThrowIfFailed();
end;

procedure TGdipPen.ScaleTransform(const sx: Single; const sy: Single);
begin
   ScaleTransform(sx, sy, TGdipMatrixOrder.Prepend);
end;

procedure TGdipPen.ScaleTransform(const sx: Single; const sy: Single; const order: TGdipMatrixOrder);
begin
   TGdiplusAPI.GdipScalePenTransform(NativePen, sx, sy, TGdiPlusAPI.TGdipMatrixOrderEnum(order)).ThrowIfFailed();
end;

procedure TGdipPen.RotateTransform(const angle: Single);
begin
   RotateTransform(angle, TGdipMatrixOrder.Prepend);
end;

procedure TGdipPen.RotateTransform(const angle: Single; const order: TGdipMatrixOrder);
begin
   TGdiplusAPI.GdipRotatePenTransform(NativePen, angle, TGdiPlusAPI.TGdipMatrixOrderEnum(order)).ThrowIfFailed();
end;

procedure TGdipPen.InternalSetColor(const value: TGdipColor);
begin
   TGdiplusAPI.GdipSetPenColor(NativePen, UInt32(_color.ToArgb())).ThrowIfFailed();
   _color := value;
end;

function TGdipPen.GetNativeBrush(): TGdiPlusAPI.TGdipBrushPtr;
begin
   var nativeBrush: TGdiplusAPI.TGdipBrushPtr;
   TGdiplusAPI.GdipGetPenBrushFill(NativePen, nativeBrush).ThrowIfFailed();
   Result := nativeBrush;
end;

procedure TGdipPen.EnsureValidDashPattern();
begin
   var count: Integer;
   TGdiplusAPI.GdipGetPenDashCount(NativePen, count);

   if (count = 0) then
   begin
         // Set to a solid pattern.
         DashPattern := [1];
   end;
end;

procedure TGdipPen.OnSystemColorChanged();
begin


   if (NativePen <> nil) then
   begin


         InternalSetColor(_color);
   end;
end;


{ TGdipBrush }

function TGdipBrush.GetNativeBrush(): TGdiplusAPI.TGdipBrushPtr;
begin
   Result := _nativeBrush;
end;

procedure TGdipBrush.SetNativeBrush(const brush: Pointer);
begin
   SetNativeBrushInternal(TGdiplusAPI.TGdipBrushPtr(brush));
end;

procedure TGdipBrush.SetNativeBrushInternal(const brush: TGdiplusAPI.TGdipBrushPtr);
begin
   _nativeBrush := brush;
end;

destructor TGdipBrush.Destroy();
begin
   Dispose(True);
   inherited Destroy();
end;


procedure TGdipBrush.Dispose();
begin
   Dispose( True );
end;

procedure TGdipBrush.Dispose(const disposing: Boolean);
begin
   if (_nativeBrush <> nil) then
   begin
      try
         try
            TGdiplusAPI.GdipDeleteBrush(_nativeBrush);
         except on ex: Exception do //  when (!ClientUtils.IsSecurityOrCriticalException(ex))
         end;
      finally
         _nativeBrush := nil;
      end;
   end;
end;


{ TGdipCustomLineCap }

function TGdipCustomLineCap.GetStrokeJoin(): TGdipLineJoin;
begin
   var lineJoin: TGdiplusAPI.TGdipLineJoinEnum;
   TGdiplusAPI.GdipGetCustomLineCapStrokeJoin(_nativeCap, lineJoin).ThrowIfFailed();
   Result := TGdipLineJoin(lineJoin);
end;

procedure TGdipCustomLineCap.SetStrokeJoin(const Value: TGdipLineJoin);
begin
   TGdiplusAPI.GdipSetCustomLineCapStrokeJoin(_nativeCap, TGdiplusAPI.TGdipLineJoinEnum(value)).ThrowIfFailed();
end;

function TGdipCustomLineCap.GetBaseCap(): TGdipLineCap;
begin
   var baseCap: TGdiplusAPI.TGdipLineCapEnum;
   TGdiplusAPI.GdipGetCustomLineCapBaseCap(_nativeCap, baseCap).ThrowIfFailed();
   Result := TGdipLineCap(baseCap);
end;

procedure TGdipCustomLineCap.SetBaseCap(const Value: TGdipLineCap);
begin
   TGdiplusAPI.GdipSetCustomLineCapBaseCap(_nativeCap, TGdiplusAPI.TGdipLineCapEnum(value)).ThrowIfFailed();
end;

function TGdipCustomLineCap.GetBaseInset(): Single;
begin
   var inset: Single;
   TGdiplusAPI.GdipGetCustomLineCapBaseInset(_nativeCap, inset).ThrowIfFailed();
   Result := inset;
end;

procedure TGdipCustomLineCap.SetBaseInset(const Value: Single);
begin
   TGdiplusAPI.GdipSetCustomLineCapBaseInset(_nativeCap, value).ThrowIfFailed();
end;

function TGdipCustomLineCap.GetWidthScale(): Single;
begin
   var widthScale: Single;
   TGdiplusAPI.GdipGetCustomLineCapWidthScale(_nativeCap, widthScale).ThrowIfFailed();
   Result := widthScale;
end;

destructor TGdipCustomLineCap.Destroy();
begin
   Dispose(True);
   inherited Destroy();
end;

procedure TGdipCustomLineCap.SetWidthScale(const Value: Single);
begin
   TGdiplusAPI.GdipSetCustomLineCapWidthScale(_nativeCap, value).ThrowIfFailed();
end;

constructor TGdipCustomLineCap.Create(const fillPath: TGdipGraphicsPath; const strokePath: TGdipGraphicsPath);
begin
   Create(fillPath, strokePath, TGdipLineCap.Flat);
end;

constructor TGdipCustomLineCap.Create(const fillPath: TGdipGraphicsPath; const strokePath: TGdipGraphicsPath; const baseCap: TGdipLineCap);
begin
   Create(fillPath, strokePath, baseCap, 0);
end;

constructor TGdipCustomLineCap.Create(const fillPath: TGdipGraphicsPath; const strokePath: TGdipGraphicsPath; const baseCap: TGdipLineCap; const baseInset: Single);
begin
   var lineCap: TGdiplusAPI.TGdipCustomLineCapPtr;
   TGdiplusAPI.GdipCreateCustomLineCap(fillPath.Pointer(), strokePath.Pointer(), TGdiplusAPI.TGdipLineCapEnum(baseCap), baseInset, lineCap).ThrowIfFailed();
   SetNativeLineCap(lineCap);
end;

constructor TGdipCustomLineCap.Create(const lineCap: TGdiplusAPI.TGdipCustomLineCapPtr);
begin
end;

class function TGdipCustomLineCap.CreateCustomLineCapObject(const cap: TGdiplusAPI.TGdipCustomLineCapPtr): TGdipCustomLineCap;
begin
   var capType: TGdiPlusAPI.TGdipCustomLineCapTypeEnum;
   var status: TGdiPlusAPI.TGdipStatusEnum := TGdiPlusAPI.GdipGetCustomLineCapType(cap, capType);

   if (status <> Status.Ok) then
   begin
      TGdiPlusAPI.GdipDeleteCustomLineCap(cap);
      raise status.GetException();
   end;

   case (capType) of
      TGdiPlusAPI.TGdipCustomLineCapTypeEnum.Default:
      begin
         Exit(TGdipCustomLineCap.Create(cap));
      end;
      TGdiPlusAPI.TGdipCustomLineCapTypeEnum.AdjustableArrow:
      begin
         Exit(TGdipAdjustableArrowCap.Create(cap));
      end;
   end;

   TGdiPlusAPI.GdipDeleteCustomLineCap(cap);

   raise TGdiPlusAPI.TGdipStatusEnum.NotImplemented.GetException();
end;

procedure TGdipCustomLineCap.SetNativeLineCap(const handle: TGdiplusAPI.TGdipCustomLineCapPtr);
begin
   if (handle = nil) then
   begin
      raise EArgumentNilException.Create('handle');
   end;


   _nativeCap := handle;
end;

procedure TGdipCustomLineCap.Dispose();
begin
   Dispose( True );
end;

procedure TGdipCustomLineCap.Dispose(const disposing: Boolean);
begin
   if (_disposed) then
   begin
      Exit();
   end;

   if (_nativeCap <> nil) and (TGdip.Initialized) then
   begin

         var status: TGdiplusAPI.TGdipStatusEnum := TGdiPlusAPI.GdipDeleteCustomLineCap(_nativeCap);

         _nativeCap := nil;

         Assert(status = TGdiplusAPI.TGdipStatusEnum.Ok, 'GDI+ returned an error status: ' + Ord(status).ToString() + '');
   end;


   _disposed := true;
end;

function TGdipCustomLineCap.Clone(): TObject;
begin
   Result := CoreClone();
end;

function TGdipCustomLineCap.CoreClone(): TObject;
begin
   var clonedCap: TGdiplusAPI.TGdipCustomLineCapPtr;
   TGdiplusAPI.GdipCloneCustomLineCap(_nativeCap, clonedCap).ThrowIfFailed();
   Result := CreateCustomLineCapObject(clonedCap);
end;

procedure TGdipCustomLineCap.SetStrokeCaps(const startCap: TGdipLineCap; const endCap: TGdipLineCap);
begin
   TGdiplusAPI.GdipSetCustomLineCapStrokeCaps(_nativeCap, TGdiPlusAPI.TGdipLineCapEnum(startCap), TGdiPlusAPI.TGdipLineCapEnum(endCap)).ThrowIfFailed();
end;

procedure TGdipCustomLineCap.GetStrokeCaps(out startCap: TGdipLineCap; out endCap: TGdipLineCap);
begin
   TGdiplusAPI.GdipGetCustomLineCapStrokeCaps(_nativeCap, TGdiPlusAPI.TGdipLineCapEnum((@startCap)^), TGdiPlusAPI.TGdipLineCapEnum((@endCap)^)).ThrowIfFailed();
end;

{ TGdipAdjustableArrowCap }

function TGdipAdjustableArrowCap.GetNativeArrowCap(): TGdiplusAPI.TGdipAdjustableArrowCapPtr;
begin
   Result := TGdiplusAPI.TGdipAdjustableArrowCapPtr(_nativeCap);
end;

function TGdipAdjustableArrowCap.GetHeight(): Single;
begin
   var height: Single;
   TGdiplusAPI.GdipGetAdjustableArrowCapHeight(NativeArrowCap, height).ThrowIfFailed();
   Result := height;
end;

procedure TGdipAdjustableArrowCap.SetHeight(const Value: Single);
begin
   TGdiplusAPI.GdipSetAdjustableArrowCapHeight(NativeArrowCap, value).ThrowIfFailed();
end;

function TGdipAdjustableArrowCap.GetWidth(): Single;
begin
   var width: Single;
   TGdiplusAPI.GdipGetAdjustableArrowCapWidth(NativeArrowCap, width).ThrowIfFailed();
   Result := width;
end;

procedure TGdipAdjustableArrowCap.SetWidth(const Value: Single);
begin
   TGdiplusAPI.GdipSetAdjustableArrowCapWidth(NativeArrowCap, value).ThrowIfFailed();
end;

function TGdipAdjustableArrowCap.GetMiddleInset(): Single;
begin
   var middleInset: Single;
   TGdiplusAPI.GdipGetAdjustableArrowCapMiddleInset(NativeArrowCap, middleInset).ThrowIfFailed();
   Result := middleInset;
end;

procedure TGdipAdjustableArrowCap.SetMiddleInset(const Value: Single);
begin
   TGdiplusAPI.GdipSetAdjustableArrowCapMiddleInset(NativeArrowCap, value).ThrowIfFailed();
end;

function TGdipAdjustableArrowCap.GetFilled(): Boolean;
begin
   var isFilled: LongBool;
   TGdiplusAPI.GdipGetAdjustableArrowCapFillState(NativeArrowCap, &isFilled).ThrowIfFailed();
   Result := isFilled;
end;

procedure TGdipAdjustableArrowCap.SetFilled(const Value: Boolean);
begin
   TGdiplusAPI.GdipSetAdjustableArrowCapFillState(NativeArrowCap, value).ThrowIfFailed();
end;

constructor TGdipAdjustableArrowCap.Create(const nativeCap: TGdiplusAPI.TGdipCustomLineCapPtr);
begin
   inherited Create(nativeCap);


end;

constructor TGdipAdjustableArrowCap.Create(const width: Single; const height: Single);
begin
   Create(width, height,  True );
end;

constructor TGdipAdjustableArrowCap.Create(const width: Single; const height: Single; const isFilled: Boolean);
begin
   var nativeCap: TGdiplusAPI.TGdipAdjustableArrowCapPtr;
   TGdiplusAPI.GdipCreateAdjustableArrowCap(height, width, isFilled, nativeCap).ThrowIfFailed();
   SetNativeLineCap(TGdiplusAPI.TGdipCustomLineCapPtr(nativeCap));
end;

{$REGION 'TGdipLinearGradientBrush'}

{ TGdipLinearGradientBrush }

function TGdipLinearGradientBrush.GetNativeLineGradient(): TGdiplusAPI.TGdipLineGradientPtr;
begin
   Result := TGdiplusAPI.TGdipLineGradientPtr(NativeBrush);
end;

function TGdipLinearGradientBrush.GetLinearColors(): TArray<TGdipColor>;
begin
   var colors: PUInt32 := StackAlloc(2 * SizeOf(UInt32));
   TGdiplusAPI.GdipGetLineColors(NativeLineGradient, colors).ThrowIfFailed();

   Result := [TGdipColor.FromArgb(Integer(colors[0])), TGdipColor.FromArgb(Integer(colors[1]))];
end;

procedure TGdipLinearGradientBrush.SetLinearColors(const Value: TArray<TGdipColor>);
begin
   TGdiplusAPI.GdipSetLineColors(NativeLineGradient, UInt32(value[0].ToArgb()), UInt32(value[1].ToArgb())).ThrowIfFailed();
end;

function TGdipLinearGradientBrush.GetRectangle(): TRectangleF;
begin
   var rect: TRectangleF;
   TGdiplusAPI.GdipGetLineRect(NativeLineGradient, rect).ThrowIfFailed();
   Exit(rect);
end;

function TGdipLinearGradientBrush.GetGammaCorrection(): Boolean;
begin
   var useGammaCorrection: LongBool;
   TGdiplusAPI.GdipGetLineGammaCorrection(NativeLineGradient, useGammaCorrection).ThrowIfFailed();
   Exit(useGammaCorrection);
end;

procedure TGdipLinearGradientBrush.SetGammaCorrection(const Value: Boolean);
begin
   TGdiplusAPI.GdipSetLineGammaCorrection(NativeLineGradient, value).ThrowIfFailed();
end;

function TGdipLinearGradientBrush.GetBlend(): TGdipBlend;
begin
   // Interpolation colors and blends don't work together very well. Getting the TGdipBlend when InterpolationColors
   // is set puts the TGdipBrush into an unusable state afterwards.
   // Bail out here to avoid that.
   if (_interpolationColorsWasSet) then

      Exit(nil);

   var count: Integer;
   TGdiplusAPI.GdipGetLineBlendCount(NativeLineGradient, count).ThrowIfFailed();

   if (count <= 0) then
   begin

      Exit(nil);
   end;

   var blend: TGdipBlend := TGdipBlend.Create(count);
   var f: PSingle := @blend.Factors[0];
   var p: PSingle := @blend.Positions[0];
   begin
      TGdiplusAPI.GdipGetLineBlend(NativeLineGradient, f, p, count).ThrowIfFailed();
      Exit(blend);
   end;
end;

procedure TGdipLinearGradientBrush.SetBlend(const Value: TGdipBlend);
begin
   if value = nil then
      raise EArgumentNullException.Create('value');
   if value.Factors = nil then
      raise EArgumentNullException.Create('value.Factors');

   if (value.Positions = nil) or (Length(value.Positions) <> Length(value.Factors)) then
      raise EArgumentException.Create('SR.Format(SR.InvalidArgumentValue, ''value.Positions'', value.Positions), nameof(value)');

   var f: PSingle := @value.Factors[0];
   var p: PSingle := @value.Positions[0];
   begin
      // Set blend factors.
      // Set blend factors.
      TGdiplusAPI.GdipSetLineBlend(NativeLineGradient, f, p, Length(value.Factors)).ThrowIfFailed();
   end;
end;

function TGdipLinearGradientBrush.GetInterpolationColors(): TGdipColorBlend;
begin
   var count: Integer;
   TGdiplusAPI.GdipGetLinePresetBlendCount(NativeLineGradient, count).ThrowIfFailed();

   if (count = 0) then
   begin
      Exit(TGdipColorBlend.Create());
   end;

   var colors: TArray<UInt32>;
   SetLength(colors, count);

   var positions: TArray<Single>;
   SetLength(positions, count);

   var blend: TGdipColorBlend := TGdipColorBlend.Create(count);
   var c: PUInt32 := @colors[0];
   var p: PSingle := @positions[0];
   begin
      // Retrieve horizontal blend factors
      // Retrieve horizontal blend factors
      TGdiplusAPI.GdipGetLinePresetBlend(NativeLineGradient, c, p, count).ThrowIfFailed();
   end;


   blend.Positions := positions;
   var blendColors := blend.Colors;
   SetLength(blendColors, count);

    for var i: Integer := 0 to count - 1 do
        blendColors[i] := TGdipColor.FromArgb(colors[i]);

   blend.Colors := blendColors;

   Exit(blend);
end;

procedure TGdipLinearGradientBrush.SetInterpolationColors(const Value: TGdipColorBlend);
begin
   if value = nil then
      raise EArgumentNullException.Create('value');

   _interpolationColorsWasSet := true;
   var count: Integer := Length(value.Colors);

   if (value.Positions = nil) then
      raise EArgumentException.Create('SR.Format(SR.InvalidArgumentValue, ''value.Positions'', value.Positions), nameof(value)');
   if (Length(value.Colors) <> Length(value.Positions)) then
      raise EArgumentException.Create('value');

   var positions: TArray<Single> := value.Positions;

   var argbValues: TArray<UInt32>;
   SetLength(argbValues, count);
   for var i: Integer := 0 to count - 1 do
      argbValues[i] := Value.Colors[i].ToArgb();

   var p: PSingle := @positions[0];
   var a: PUInt32 := @argbValues[0];
   begin
      // Set blend factors
      // Set blend factors
      TGdiplusAPI.GdipSetLinePresetBlend(NativeLineGradient, a, p, count).ThrowIfFailed();
   end;
end;

function TGdipLinearGradientBrush.GetWrapMode(): TGdipWrapMode;
begin
   var mode: TGdiplusAPI.TGdipWrapModeEnum;
   TGdiplusAPI.GdipGetLineWrapMode(NativeLineGradient, mode).ThrowIfFailed();

   Exit(TGdipWrapMode(mode));
end;

procedure TGdipLinearGradientBrush.SetWrapMode(const Value: TGdipWrapMode);
begin
   if (Value < TGdipWrapMode.Tile) or (Value > TGdipWrapMode.Clamp) then
      raise EInvalidEnumArgumentException.Create('value', Integer(value), TypeInfo(TGdipWrapMode));

   TGdiplusAPI.GdipSetLineWrapMode(NativeLineGradient, TGdiplusAPI.TGdipWrapModeEnum(value)).ThrowIfFailed();
end;

function TGdipLinearGradientBrush.GetTransform(): TGdipMatrix;
begin
   var matrix: TGdipMatrix := TGdipMatrix.Create();
   TGdiplusAPI.GdipGetLineTransform(NativeLineGradient, matrix.NativeMatrix).ThrowIfFailed();

   Exit(matrix);
end;

procedure TGdipLinearGradientBrush.SetTransform(const Value: TGdipMatrix);
begin
   if value = nil then
      raise EArgumentNullException.Create('value');

   TGdiplusAPI.GdipSetLineTransform(NativeLineGradient, value.NativeMatrix).ThrowIfFailed();
end;

constructor TGdipLinearGradientBrush.Create(const point1: TPointF; const point2: TPointF; const color1: TGdipColor; const color2: TGdipColor);
begin
   var nativeBrush: TGdiplusAPI.TGdipLineGradientPtr;
   TGdiplusAPI.GdipCreateLineBrush(@point1, @point2, UInt32(color1.ToArgb()), UInt32(color2.ToArgb()), TGdiplusAPI.TGdipWrapModeEnum.Tile, nativeBrush).ThrowIfFailed();
   SetNativeBrushInternal(TGdiplusAPI.TGdipBrushPtr(nativeBrush));
end;

constructor TGdipLinearGradientBrush.Create(const point1: TPoint; const point2: TPoint; const color1: TGdipColor; const color2: TGdipColor);
begin
   Create(TPointF(point1), TPointF(point2), color1, color2);
end;

constructor TGdipLinearGradientBrush.Create(const rect: TRectangleF; const color1: TGdipColor; const color2: TGdipColor; const linearGradientMode: TGdipLinearGradientMode);
begin
   if (linearGradientMode < TGdipLinearGradientMode.Horizontal) or (linearGradientMode > TGdipLinearGradientMode.BackwardDiagonal) then
      raise EInvalidEnumArgumentException.Create('linearGradientMode', Integer(linearGradientMode), TypeInfo(TGdipLinearGradientMode));

   if (rect.Width = 0.0) or (rect.Height = 0.0) then
      raise EArgumentException.Create('SR.Format(SR.GdiplusInvalidRectangle, rect.ToString())');

   var nativeBrush: TGdiplusAPI.TGdipLineGradientPtr;
   TGdiplusAPI.GdipCreateLineBrushFromRect(@rect, TARGB(color1), TARGB(color2), TGdiplusAPI.TGdipLinearGradientModeEnum(linearGradientMode), TGdiplusAPI.TGdipWrapModeEnum.Tile, nativeBrush).ThrowIfFailed();
   SetNativeBrushInternal(TGdiplusAPI.TGdipBrushPtr(nativeBrush));
end;

constructor TGdipLinearGradientBrush.Create(const rect: TRectangle; const color1: TGdipColor; const color2: TGdipColor; const linearGradientMode: TGdipLinearGradientMode);
begin
   Create(TRectangleF(rect), color1, color2, linearGradientMode);
end;

constructor TGdipLinearGradientBrush.Create(const rect: TRectangleF; const color1: TGdipColor; const color2: TGdipColor; const angle: Single);
begin
   Create(rect, color1, color2, angle,  False );

end;

constructor TGdipLinearGradientBrush.Create(const rect: TRectangleF; const color1: TGdipColor; const color2: TGdipColor; const angle: Single; const isAngleScaleable: Boolean);
begin
   if (rect.Width = 0.0) or (rect.Height = 0.0) then
      raise EArgumentException.Create('SR.Format(SR.GdiplusInvalidRectangle, rect.ToString())');

   var nativeBrush: TGdiplusAPI.TGdipLineGradientPtr;
   TGdiplusAPI.GdipCreateLineBrushFromRectWithAngle(@rect, TARGB(color1), TARGB(color2), angle, isAngleScaleable, TGdiplusAPI.TGdipWrapModeEnum.Tile, nativeBrush).ThrowIfFailed();
   SetNativeBrushInternal(TGdiplusAPI.TGdipBrushPtr(nativeBrush));
end;

constructor TGdipLinearGradientBrush.Create(const rect: TRectangle; const color1: TGdipColor; const color2: TGdipColor; const angle: Single);
begin
   Create(rect, color1, color2, angle,  False );
end;

constructor TGdipLinearGradientBrush.Create(const rect: TRectangle; const color1: TGdipColor; const color2: TGdipColor; const angle: Single; const isAngleScaleable: Boolean);
begin
   Create(TRectangleF(rect), color1, color2, angle, isAngleScaleable);
end;

constructor TGdipLinearGradientBrush.Create(const nativeBrush: TGdiplusAPI.TGdipLineGradientPtr);
begin
   Assert(nativeBrush <> nil, 'Initializing native brush with null.');
   SetNativeBrushInternal(TGdiplusAPI.TGdipBrushPtr(nativeBrush));
end;

function TGdipLinearGradientBrush.Clone(): TObject;
begin
   var clonedBrush: TGdiplusAPI.TGdipBrushPtr;
   TGdiplusAPI.GdipCloneBrush(NativeBrush, clonedBrush).ThrowIfFailed();

   Exit(TGdipLinearGradientBrush.Create(TGdiplusAPI.TGdipLineGradientPtr(clonedBrush)));
end;

procedure TGdipLinearGradientBrush.SetSigmaBellShape(const focus: Single);
begin
   SetSigmaBellShape(focus, Single(1.0))
end;

procedure TGdipLinearGradientBrush.SetSigmaBellShape(const focus: Single; const scale: Single);
begin
   TGdiplusAPI.GdipSetLineSigmaBlend(NativeLineGradient, focus, scale).ThrowIfFailed();
end;

procedure TGdipLinearGradientBrush.SetBlendTriangularShape(const focus: Single);
begin
   SetBlendTriangularShape(focus, Single(1.0))
end;

procedure TGdipLinearGradientBrush.SetBlendTriangularShape(const focus: Single; const scale: Single);
begin
   _interpolationColorsWasSet := false;
   TGdiplusAPI.GdipSetLineLinearBlend(NativeLineGradient, focus, scale).ThrowIfFailed();
end;

procedure TGdipLinearGradientBrush.ResetTransform();
begin
   TGdiplusAPI.GdipResetLineTransform(NativeLineGradient).ThrowIfFailed();
end;

procedure TGdipLinearGradientBrush.MultiplyTransform(const matrix: TGdipMatrix);
begin
   MultiplyTransform(matrix, TGdipMatrixOrder.Prepend)
end;

procedure TGdipLinearGradientBrush.MultiplyTransform(const matrix: TGdipMatrix; const order: TGdipMatrixOrder);
begin
   if matrix = nil then
       raise EArgumentNullException.Create('matrix');

   TGdiplusAPI.GdipMultiplyLineTransform(NativeLineGradient, matrix.NativeMatrix, TGdiplusAPI.TGdipMatrixOrderEnum(order)).ThrowIfFailed();
end;

procedure TGdipLinearGradientBrush.TranslateTransform(const dx: Single; const dy: Single);
begin
   TranslateTransform(dx, dy, TGdipMatrixOrder.Prepend)
end;

procedure TGdipLinearGradientBrush.TranslateTransform(const dx: Single; const dy: Single; const order: TGdipMatrixOrder);
begin
   TGdiplusAPI.GdipTranslateLineTransform(NativeLineGradient, dx, dy, TGdiplusAPI.TGdipMatrixOrderEnum(order)).ThrowIfFailed();
end;

procedure TGdipLinearGradientBrush.ScaleTransform(const sx: Single; const sy: Single);
begin
   ScaleTransform(sx, sy, TGdipMatrixOrder.Prepend)
end;

procedure TGdipLinearGradientBrush.ScaleTransform(const sx: Single; const sy: Single; const order: TGdipMatrixOrder);
begin
   TGdiplusAPI.GdipScaleLineTransform(NativeLineGradient, sx, sy, TGdiplusAPI.TGdipMatrixOrderEnum(order)).ThrowIfFailed();
end;

procedure TGdipLinearGradientBrush.RotateTransform(const angle: Single);
begin
   RotateTransform(angle, TGdipMatrixOrder.Prepend)
end;

procedure TGdipLinearGradientBrush.RotateTransform(const angle: Single; const order: TGdipMatrixOrder);
begin
   TGdiplusAPI.GdipRotateLineTransform(NativeLineGradient, angle, TGdiplusAPI.TGdipMatrixOrderEnum(order)).ThrowIfFailed();
end;

{$ENDREGION 'TGdipLinearGradientBrush'}

{$REGION 'TGdipImageCodecInfoHelper'}

{ TGdipImageCodecInfoHelper }

class function TGdipImageCodecInfoHelper.GetEncoders(): TArray<TGdipImageCodecInfoHelperItem>;
begin
   if (s_encoders = nil) or (Length(s_encoders) = 0) then
   begin
      var numEncoders: UInt32 := 0;
      var size: UInt32 := 0;

      TGdiplusAPI.GdipGetImageEncodersSize(numEncoders, size).ThrowIfFailed();
      var memory: TGdiplusAPI.TGdipImageCodecInfoPtr := TMarshal.AllocHGlobal(size);
      try
         TGdiplusAPI.GdipGetImageEncoders(numEncoders, size, memory).ThrowIfFailed();
         SetLength(s_encoders, numEncoders);
         var curcodec: TGdiplusAPI.TGdipImageCodecInfoPtr := memory;
         for var index: Integer := 0 to numEncoders - 1 do
         begin
            s_encoders[index].Format := curcodec^.FormatID;
            s_encoders[index].Encoder := curcodec^.Clsid;
            Inc(curcodec);
         end;
      finally
          TMarshal.FreeHGlobal(memory);
      end;
   end;

   Exit(s_encoders);
end;

class function TGdipImageCodecInfoHelper.GetEncoderClsid(const format: TGuid): TGuid;
begin
   for var item: TGdipImageCodecInfoHelperItem in Encoders do
   begin
      if IsEqualGUID(format, item.Format) then
      begin
         Exit(item.Encoder);
      end;
   end;

   Result := TGuid.Empty;
end;

{$ENDREGION 'TGdipImageCodecInfoHelper'}

{$REGION 'TGdipBitmapHistogram'}

{ TGdipBitmapHistogram }

constructor TGdipBitmapHistogram.Create(const AChannelCount, AEntryCount: Integer; const AChannel0, AChannel1, AChannel2, AChannel3: PCardinal);
begin
  inherited Create;
  m_channelCount := AChannelCount;
  m_entryCount := AEntryCount;
  m_channels[0] := AChannel0;
  m_channels[1] := AChannel1;
  m_channels[2] := AChannel2;
  m_channels[3] := AChannel3;
end;

destructor TGdipBitmapHistogram.Destroy;
begin
  FreeMem(m_channels[3]);
  FreeMem(m_channels[2]);
  FreeMem(m_channels[1]);
  FreeMem(m_channels[0]);
end;

function TGdipBitmapHistogram.GetChannelCount: Integer;
begin
  Result := m_channelCount;
end;

function TGdipBitmapHistogram.GetEntryCount: Integer;
begin
  Result := m_entryCount;
end;

function TGdipBitmapHistogram.GetValue(const ChannelIndex, EntryIndex: Integer): Cardinal;
begin
  Result := m_channels[ChannelIndex, EntryIndex];
end;

function TGdipBitmapHistogram.GetChannel0(const Index: Integer): Cardinal;
begin
  Result := m_channels[0, Index];
end;

function TGdipBitmapHistogram.GetChannel1(const Index: Integer): Cardinal;
begin
  Result := m_channels[1, Index];
end;

function TGdipBitmapHistogram.GetChannel2(const Index: Integer): Cardinal;
begin
  Result := m_channels[2, Index];
end;

function TGdipBitmapHistogram.GetChannel3(const Index: Integer): Cardinal;
begin
  Result := m_channels[3, Index];
end;

function TGdipBitmapHistogram.GetValuePtr(const ChannelIndex: Integer): PCardinal;
begin
  Result := m_channels[ChannelIndex];
end;

function TGdipBitmapHistogram.GetChannel0Ptr: PCardinal;
begin
  Result := m_channels[0];
end;

function TGdipBitmapHistogram.GetChannel1Ptr: PCardinal;
begin
  Result := m_channels[1];
end;

function TGdipBitmapHistogram.GetChannel2Ptr: PCardinal;
begin
  Result := m_channels[2];
end;

function TGdipBitmapHistogram.GetChannel3Ptr: PCardinal;
begin
  Result := m_channels[3];
end;

{$ENDREGION 'TGdipBitmapHistogram'}

end.


