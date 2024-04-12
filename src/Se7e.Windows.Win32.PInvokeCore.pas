// Marcelo Melo
// 24/03/2024

unit Se7e.Windows.Win32.PInvokeCore;


{$SCOPEDENUMS ON}
{$ZEROBASEDSTRINGS ON}
{$ALIGN 8}
{$MINENUMSIZE 4}
{$WARN SYMBOL_PLATFORM OFF}

{$IFDEF FPC}
  {$MODE DELPHI}
{$ENDIF}

interface

uses
   SysUtils,
   StrUtils,
   Classes,
   Types,
   //UITypes,
   //System.IOUtils,
   Windows,
   ShlObj,
   ShellAPI;

type

   { ICONDIRENTRY }

   /// <summary>
   ///   Para cada ICONDIRENTRY, o arquivo contém uma imagem de ícone.
   ///   O membro dwBytesInRes indica o tamanho dos dados da imagem.
   ///   Esses dados de imagem podem ser encontrados em bytes dwImageOffset desde o início do arquivo.
   ///
   ///   https://devblogs.microsoft.com/oldnewthing/20101018-00/?p=12513
   ///   https://devblogs.microsoft.com/oldnewthing/20120720-00/?p=7083
   /// </summary>
   ICONDIRENTRY = packed record
      // Width and height são 1 - 255 ou 0 para 256

      /// <summary>
      ///    Largura, em pixels, da imagem. São 1-255 ou 0 para 256
      /// </summary>
      bWidth: Byte;

      /// <summary>
      ///    Altura, em pixels, da imagem. São 1-255 ou 0 para 256
      /// </summary>
      bHeight: Byte;

      /// <summary>
      ///   Número de cores na imagem (0 se >=8bpp)
      /// </summary>
      bColorCount: Byte;

      /// <summary>
      ///   Reservado (deve ser 0)
      /// </summary>
      bReserved: Byte;

      /// <summary>
      ///   Planos coloridos
      /// </summary>
      wPlanes: UInt16;

      /// <summary>
      ///   Bits por pixel
      /// </summary>
      wBitCount: UInt16;

      /// <summary>
      ///   Quantos bytes neste recurso?
      /// </summary>
      dwBytesInRes: UInt32;

      /// <summary>
      ///   Onde no arquivo está esta imagem?
      /// </summary>
      dwImageOffset: UInt32;
   end;


   { ICONDIR }

   /// <summary>
   ///   Um arquivo Icon, que geralmente possui a extensão ICO, contém um recurso de ícone.
   ///   Dado que um recurso de ícone pode conter múltiplas imagens,
   ///   não é surpresa que o arquivo comece com um diretório de ícone.
   /// </summary>
   ICONDIR = packed record

      /// <summary>
      /// Reservado (deve ser 0)
      /// </summary>
      idReserved: UInt16;

      /// <summary>
      /// Tipo de recurso (1 para ícones)
      /// </summary>
      idType: UInt16;

      /// <summary>
      ///   O membro idCount indica quantas imagens estão presentes no recurso de ícone.
      ///   O tamanho da matriz idEntries é determinado por idCount .
      ///   Existe uma ICONDIRENTRY para cada imagem de ícone no arquivo,
      ///   fornecendo detalhes sobre sua localização no arquivo, tamanho e profundidade de cor.
      /// </summary>
      idCount: UInt16;

      /// <summary>
      ///   Primeira entrada (array de qualquer tamanho)
      ///   Uma entrada para cada imagem (idCount of 'em)
      /// </summary>
      idEntries: array[0..0] of ICONDIRENTRY;
   end;

   { IMAGE_FLAGS }

	IMAGE_FLAGS = type UInt32;
   IMAGE_FLAGS_HELPER = record helper for IMAGE_FLAGS
	   const LR_CREATEDIBSECTION = $00002000;
		const LR_DEFAULTCOLOR = $00000000;
		const LR_DEFAULTSIZE = $00000040;
		const LR_LOADFROMFILE = $00000010;
		const LR_LOADMAP3DCOLORS = $00001000;
		const LR_LOADTRANSPARENT = $00000020;
		const LR_MONOCHROME = $00000001;
		const LR_SHARED = $00008000;
		const LR_VGACOLOR = $00000080;
		const LR_COPYDELETEORG = $00000008;
		const LR_COPYFROMRESOURCE = $00004000;
		const LR_COPYRETURNORG = $00000004;
   end;

   { GDI_IMAGE_TYPE }

	GDI_IMAGE_TYPE = type UInt32;
	GDI_IMAGE_TYPE_HELPER = record helper for GDI_IMAGE_TYPE
	   const IMAGE_BITMAP = $0;
		const IMAGE_CURSOR = $2;
		const IMAGE_ICON = $1;
   end;

   { GDI_REGION_TYPE }

   GDI_REGION_TYPE = (
      RGN_ERROR = 0,
      NULLREGION = 1,
      SIMPLEREGION = 2,
      COMPLEXREGION = 3
   );

   { RGN_COMBINE_MODE }

	RGN_COMBINE_MODE = (
			RGN_INVALID = 0,
			RGN_AND = 1,
			RGN_OR = 2,
			RGN_XOR = 3,
			RGN_DIFF = 4,
			RGN_COPY = 5,
			RGN_MIN = 1,
			RGN_MAX = 5
   );


   { DI_FLAGS }

   DI_FLAGS = type UInt32;
	DI_FLAGS_HELPER = record helper for DI_FLAGS
	   const DI_MASK = $00000001;
		const DI_IMAGE = $00000002;
		const DI_NORMAL = $00000003;
		const DI_COMPAT = $00000004;
		const DI_DEFAULTSIZE = $00000008;
		const DI_NOMIRROR = $00000010;
	end;

   { OBJ_TYPE }

	OBJ_TYPE = (
         OBJ_INVALID = 0,
			OBJ_PEN = 1,
			OBJ_BRUSH = 2,
			OBJ_DC = 3,
			OBJ_METADC = 4,
			OBJ_PAL = 5,
			OBJ_FONT = 6,
			OBJ_BITMAP = 7,
			OBJ_REGION = 8,
			OBJ_METAFILE = 9,
			OBJ_MEMDC = 10,
			OBJ_EXTPEN = 11,
			OBJ_ENHMETADC = 12,
			OBJ_ENHMETAFILE = 13,
			OBJ_COLORSPACE = 14
   );

   { OBJ_TYPE_HELPER }

   OBJ_TYPE_HELPER = record helper for OBJ_TYPE
      public function ToString(): string;
   end;

   { GET_DCX_FLAGS }

   GET_DCX_FLAGS = type UInt32;
   GET_DCX_FLAGS_HELPER = record helper for GET_DCX_FLAGS
      const DCX_WINDOW = $00000001;
      const DCX_CACHE = $00000002;
      const DCX_PARENTCLIP = $00000020;
      const DCX_CLIPSIBLINGS = $00000010;
      const DCX_CLIPCHILDREN = $00000008;
      const DCX_NORESETATTRS = $00000004;
      const DCX_LOCKWINDOWUPDATE = $00000400;
      const DCX_EXCLUDERGN = $00000040;
      const DCX_INTERSECTRGN = $00000080;
      const DCX_INTERSECTUPDATE = $00000200;
      const DCX_VALIDATE = $00200000;
	end;

   { GET_DEVICE_CAPS_INDEX }

   /// <summary>
   ///    Informações do dispositivo especificado.
   /// </summary>
   GET_DEVICE_CAPS_INDEX = (

      /// <summary>
      ///   A versão do driver do dispositivo.
      /// </summary>
      DRIVERVERSION = 0,

      /// <summary>
      ///   Tecnologia do dispositivo. Pode ser qualquer um dos valores a seguir:
      ///
      ///   DT_PLOTTER	Plotador de vetor
      ///   DT_RASDISPLAY	Exibição de varredura
      ///   DT_RASPRINTER	Impressora raster
      ///   DT_RASCAMERA	Câmera de varredura
      ///   DT_CHARSTREAM	Fluxo de caracteres
      ///   DT_METAFILE	Metarquivo
      ///   DT_DISPFILE	Exibir arquivo
      ///
      ///   Se o parâmetro hdc for um identificador para o DC de um meta-arquivo
      ///   aprimorado, a tecnologia do dispositivo será a do dispositivo referenciado,
      ///   conforme especificado para a função <b>CreateEnhMetaFile<b>. Para determinar se
      ///   é um DC de meta-arquivo aprimorado, use a função <b>GetObjectType</b>.
      /// </summary>
      TECHNOLOGY = 2,

      /// <summary>
      ///   Largura, em milímetros, da tela física.
      /// </summary>
      HORZSIZE = 4,

      /// <summary>
      ///   Altura, em milímetros, da tela física.
      /// </summary>
      VERTSIZE = 6,

      /// <summary>
      ///   Largura, em pixels, da tela; ou para impressoras, a largura, em pixels, da área imprimível da página.
      /// </summary>
      HORZRES = 8,

      /// <summary>
      ///   Altura, em linhas de varredura, da tela; ou para impressoras, a altura, em pixels, da área imprimível da página.
      /// </summary>
      VERTRES = 10,

      /// <summary>
      ///   Número de bits de cor adjacentes para cada pixel.
      /// </summary>
      BITSPIXEL = 12,

      /// <summary>
      ///   Número de planos de cores.
      /// </summary>
      PLANES = 14,

      /// <summary>
      ///   Número de pincéis específicos do dispositivo.
      /// </summary>
      NUMBRUSHES = 16,

      /// <summary>
      ///   Número de canetas específicas do dispositivo.
      /// </summary>
      NUMPENS = 18,

      /// <summary>
      ///
      /// </summary>
      NUMMARKERS = 20,

      /// <summary>
      ///   Número de fontes específicas do dispositivo.
      /// </summary>
      NUMFONTS = 22,

      /// <summary>
      ///   Número de entradas na tabela de cores do dispositivo, se o dispositivo tiver
      ///   uma profundidade de cor de no máximo 8 bits por pixel. Para dispositivos com
      ///   maiores profundidades de cor, -1 é retornado.
      /// </summary>
      NUMCOLORS = 24,

      /// <summary>
      ///   Reservado
      /// </summary>
      PDEVICESIZE = 26,

      /// <summary>
      ///   Valor que indica os recursos de curva do dispositivo, conforme mostrado na tabela a seguir.
      ///
      ///   CC_NONE	O dispositivo não dá suporte a curvas.
      ///   CC_CHORD	O dispositivo pode desenhar arcos de acordes.
      ///   CC_CIRCLES	O dispositivo pode desenhar círculos.
      ///   CC_ELLIPSES	O dispositivo pode desenhar reticências.
      ///   CC_INTERIORS	O dispositivo pode desenhar interiores.
      ///   CC_PIE	O dispositivo pode desenhar cunhas de pizza.
      ///   CC_ROUNDRECT	O dispositivo pode desenhar retângulos arredondados.
      ///   CC_STYLED	O dispositivo pode desenhar bordas estilizadas.
      ///   CC_WIDE	O dispositivo pode desenhar bordas largas.
      ///   CC_WIDESTYLED	O dispositivo pode desenhar bordas largas e estilizadas.
      /// </summary>
      CURVECAPS = 28,

      /// <summary>
      ///   Valor que indica os recursos de linha do dispositivo, conforme mostrado na tabela a seguir:
      ///
      ///   LC_NONE	O dispositivo não dá suporte a linhas.
      ///   LC_INTERIORS	O dispositivo pode desenhar interiores.
      ///   LC_MARKER	O dispositivo pode desenhar um marcador.
      ///   LC_POLYLINE	O dispositivo pode desenhar uma polilinha.
      ///   LC_POLYMARKER	O dispositivo pode desenhar vários marcadores.
      ///   LC_STYLED	O dispositivo pode desenhar linhas estilizadas.
      ///   LC_WIDE	O dispositivo pode desenhar linhas largas.
      ///   LC_WIDESTYLED	O dispositivo pode desenhar linhas largas e estilizadas.
      /// </summary>
      LINECAPS = 30,

      /// <summary>
      ///   Valor que indica os recursos de polígono do dispositivo, conforme mostrado na tabela a seguir.
      ///
      ///   PC_NONE	O dispositivo não dá suporte a polígonos.
      ///   PC_INTERIORS	O dispositivo pode desenhar interiores.
      ///   PC_POLYGON	O dispositivo pode desenhar polígonos de preenchimento alternativo.
      ///   PC_RECTANGLE	O dispositivo pode desenhar retângulos.
      ///   PC_SCANLINE	O dispositivo pode desenhar uma única linha de verificação.
      ///   PC_STYLED	O dispositivo pode desenhar bordas estilizadas.
      ///   PC_WIDE	O dispositivo pode desenhar bordas largas.
      ///   PC_WIDESTYLED	O dispositivo pode desenhar bordas largas e estilizadas.
      ///   PC_WINDPOLYGON	O dispositivo pode desenhar polígonos de preenchimento sinuoso.
      /// </summary>
      POLYGONALCAPS = 32,

      /// <summary>
      ///   Valor que indica os recursos de texto do dispositivo, conforme mostrado na tabela a seguir.
      ///
      ///   TC_OP_CHARACTER	O dispositivo é capaz de precisão de saída de caractere.
      ///   TC_OP_STROKE	O dispositivo é capaz de obter precisão de saída de traço.
      ///   TC_CP_STROKE	O dispositivo é capaz de obter precisão de recorte de traço.
      ///   TC_CR_90	O dispositivo é capaz de rotação de caracteres de 90 graus.
      ///   TC_CR_ANY	O dispositivo é capaz de qualquer rotação de caracteres.
      ///   TC_SF_X_YINDEP	O dispositivo pode ser dimensionado independentemente nas direções x e y.
      ///   TC_SA_DOUBLE	O dispositivo é capaz de dobrar o caractere para dimensionamento.
      ///   TC_SA_INTEGER	O dispositivo usa múltiplos inteiros apenas para dimensionamento de caracteres.
      ///   TC_SA_CONTIN	O dispositivo usa múltiplos para dimensionamento exato de caracteres.
      ///   TC_EA_DOUBLE	O dispositivo pode desenhar caracteres de peso duplo.
      ///   TC_IA_ABLE	O dispositivo pode itálico.
      ///   TC_UA_ABLE	O dispositivo pode sublinhar.
      ///   TC_SO_ABLE	O dispositivo pode desenhar strikeouts.
      ///   TC_RA_ABLE	O dispositivo pode desenhar fontes de varredura.
      ///   TC_VA_ABLE	O dispositivo pode desenhar fontes de vetor.
      ///   TC_RESERVED	Reservados; deve ser zero.
      ///   TC_SCROLLBLT	O dispositivo não pode rolar usando uma
      ///                  transferência de bloco de bits. Observe que esse
      ///                  significado pode ser o oposto do que você espera.
      /// </summary>
      TEXTCAPS = 34,

      /// <summary>
      ///   Sinalizador que indica os recursos de recorte do dispositivo. Se o dispositivo puder recortar para um retângulo, ele será 1. Caso contrário, é 0.
      /// </summary>
      CLIPCAPS = 36,

      /// <summary>
      ///   Valor que indica os recursos de varredura do dispositivo, conforme mostrado na tabela a seguir
      ///
      ///   RC_BANDING	Requer suporte para faixas.
      ///   RC_BITBLT	Capaz de transferir bitmaps.
      ///   RC_BITMAP64	Capaz de dar suporte a bitmaps maiores que 64 KB.
      ///   RC_DI_BITMAP	Capaz de dar suporte às funções SetDIBits e GetDIBits .
      ///   RC_DIBTODEV	Capaz de dar suporte à função SetDIBitsToDevice .
      ///   RC_FLOODFILL	Capaz de executar preenchimentos de inundação.
      ///   RC_PALETTE	Especifica um dispositivo baseado em paleta.
      ///   RC_SCALING	Capaz de dimensionar.
      ///   RC_STRETCHBLT	Capaz de executar a função StretchBlt .
      ///   RC_STRETCHDIB	Capaz de executar a função StretchDIBits .
      /// </summary>
      RASTERCAPS = 38,

      /// <summary>
      ///   Largura relativa de um pixel de dispositivo usado para desenho de linha.
      /// </summary>
      ASPECTX = 40,

      /// <summary>
      ///   Altura relativa de um pixel de dispositivo usado para desenho de linha.
      /// </summary>
      ASPECTY = 42,

      /// <summary>
      ///   Largura diagonal do pixel do dispositivo usado para desenho de linha.
      /// </summary>
      ASPECTXY = 44,

      /// <summary>
      ///   Número de pixels por polegada lógica ao longo da largura da tela. Em um
      ///   sistema com vários monitores de exibição, esse valor é o mesmo para todos os monitores.
      /// </summary>
      LOGPIXELSX = 88,

      /// <summary>
      ///   Número de pixels por polegada lógica ao longo da altura da tela. Em um
      ///   sistema com vários monitores de exibição, esse valor é o mesmo para todos os monitores.
      /// </summary>
      LOGPIXELSY = 90,

      /// <summary>
      ///   Número de entradas na paleta do sistema. Esse índice só será válido se o driver
      ///   de dispositivo definir o RC_PALETTE bit no índice RASTERCAPS e estiver
      ///   disponível somente se o driver for compatível com o Windows de 16 bits.
      /// </summary>
      SIZEPALETTE = 104,

      /// <summary>
      ///   Número de entradas reservadas na paleta do sistema. Esse índice só será válido
      ///   se o driver de dispositivo definir o RC_PALETTE bit no índice RASTERCAPS e
      ///   estiver disponível somente se o driver for compatível com o Windows de 16 bits.
      /// </summary>
      NUMRESERVED = 106,

      /// <summary>
      ///   Resolução real de cores do dispositivo, em bits por pixel. Esse índice só será
      ///   válido se o driver de dispositivo definir o RC_PALETTE bit no índice RASTERCAPS
      ///   e estiver disponível somente se o driver for compatível com o Windows de 16 bits.
      /// </summary>
      COLORRES = 108,

      /// <summary>
      ///   Para dispositivos de impressão: a largura da página física, em unidades de
      ///   dispositivo. Por exemplo, uma impressora definida para imprimir a 600 dpi em
      ///   papel de 8,5-x11 polegadas tem um valor de largura física de 5100 unidades de
      ///   dispositivo. Observe que a página física é quase sempre maior que a área
      ///   imprimível da página e nunca menor.
      /// </summary>
      PHYSICALWIDTH = 110,

      /// <summary>
      ///   Para dispositivos de impressão: a altura da página física, em unidades de
      ///   dispositivo. Por exemplo, uma impressora definida para imprimir a 600 dpi em
      ///   papel de 8,5 por 11 polegadas tem um valor de altura física de 6.600 unidades
      ///   de dispositivo. Observe que a página física é quase sempre maior que a área
      ///   imprimível da página e nunca menor.
      /// </summary>
      PHYSICALHEIGHT = 111,

      /// <summary>
      ///   Para imprimir dispositivos: a distância da borda esquerda da página física até a
      ///   borda esquerda da área imprimível, em unidades de dispositivo. Por exemplo,
      ///   uma impressora definida para imprimir a 600 dpi em papel de 8,5 por 11
      ///   polegadas, que não pode imprimir no papel de 0,25 polegadas mais à
      ///   esquerda, tem um deslocamento físico horizontal de 150 unidades de dispositivo.
      /// </summary>
      PHYSICALOFFSETX = 112,

      /// <summary>
      ///   Para imprimir dispositivos: a distância da borda superior da página física até a
      ///   borda superior da área imprimível, em unidades de dispositivo. Por exemplo,
      ///   uma impressora definida para imprimir a 600 dpi em papel de 8,5 por 11
      ///   polegadas, que não pode imprimir no máximo 0,5 polegada de papel, tem um
      ///   deslocamento físico vertical de 300 unidades de dispositivo.
      /// </summary>
      PHYSICALOFFSETY = 113,

      /// <summary>
      ///   Fator de dimensionamento para o eixo x da impressora.
      /// </summary>
      SCALINGFACTORX = 114,

      /// <summary>
      ///   Fator de dimensionamento para o eixo y da impressora.
      /// </summary>
      SCALINGFACTORY = 115,

      /// <summary>
      ///   Para dispositivos de exibição: a taxa de atualização vertical atual do dispositivo,
      ///   em ciclos por segundo (Hz).
      ///   Um valor de taxa de atualização vertical de 0 ou 1 representa a taxa de
      ///   atualização padrão do hardware de exibição. Normalmente, essa taxa padrão é
      ///   definida por opções em um cartão de exibição ou placa-mãe do computador
      ///   ou por um programa de configuração que não usa funções de exibição, como
      ///   ChangeDisplaySettings.
      /// </summary>
      VREFRESH = 116,

      /// <summary>
      ///
      /// </summary>
      DESKTOPVERTRES = 117,

      /// <summary>
      ///
      /// </summary>
      DESKTOPHORZRES = 118,

      /// <summary>
      ///   Alinhamento de desenho horizontal preferencial, expresso como um múltiplo
      ///   de pixels. Para obter o melhor desempenho de desenho, as janelas devem ser
      ///   alinhadas horizontalmente a um múltiplo desse valor. Um valor zero indica que
      ///   o dispositivo está acelerado e qualquer alinhamento pode ser usado.
      /// </summary>
      BLTALIGNMENT = 119,

      /// <summary>
      ///   Valor que indica os recursos de sombreamento e mesclagem do dispositivo. Consulte Comentários para obter mais comentários.
      ///
      ///   SB_CONST_ALPHA	Manipula o membro SourceConstantAlpha da estrutura BLENDFUNCTION , que é referenciada pelo parâmetro blendFunction da função AlphaBlend .
      ///   SB_GRAD_RECT	Capaz de fazer retângulos GradientFill .
      ///   SB_GRAD_TRI	Capaz de fazer triângulos GradientFill .
      ///   SB_NONE	O dispositivo não dá suporte a nenhum desses recursos.
      ///   SB_PIXEL_ALPHA	Capaz de lidar com alfa por pixel em AlphaBlend.
      ///   SB_PREMULT_ALPHA	Capaz de lidar com alfa pré-multiplicado em AlphaBlend.
      /// </summary>
      SHADEBLENDCAPS = 120,

      /// <summary>
      ///   Valor que indica os recursos de gerenciamento de cores do dispositivo.
      ///
      ///   CM_CMYK_COLOR	O dispositivo pode aceitar o perfil de cor DO ICC de
      ///                  espaço de cor CMYK.
      ///   CM_DEVICE_ICM	O dispositivo pode executar o ICM no driver do
      ///                  dispositivo ou no próprio dispositivo.
      ///   CM_GAMMA_RAMP	O dispositivo dá suporte a GetDeviceGammaRamp e
      ///                  SetDeviceGammaRamp
      ///   CM_NONE	O dispositivo não dá suporte ao ICM.
      /// </summary>
      COLORMGMTCAPS = 121
   );

   { SYSTEM_METRICS_INDEX }

   /// <summary>
   /// A métrica do sistema ou a definição de configuração a ser recuperada. Esse parâmetro pode usar um dos valores a seguir.
   /// Observe que todos os valores SM_CX* são larguras e todos os valores SM_CY* são alturas.
   /// Observe também que todas as configurações projetadas para retornar dados boolianos representam <b>TRUE</b> como qualquer valor diferente de zero e <b>FALSE</b> como um valor zero.
   /// </summary>
   SYSTEM_METRICS_INDEX = (

         /// <summary>
         /// A configuração SM_ARRANGE especifica como o sistema organiza janelas minimizadas e consiste em uma posição inicial e uma direção. A posição inicial pode ser um dos valores a seguir:
         ///
         /// ARW_BOTTOMLEFT	Comece no canto inferior esquerdo da tela. A posição padrão.
         /// ARW_BOTTOMRIGHT	Comece no canto inferior direito da tela. Equivalente a ARW_STARTRIGHT.
         /// ARW_TOPLEFT	Comece no canto superior esquerdo da tela. Equivalente a ARW_STARTTOP.
         /// ARW_TOPRIGHT	Comece no canto superior direito da tela. Equivalente a ARW_STARTTOP or SRW_STARTRIGHT.
         /// </summary>
         /// <remarks>
         /// A direção na qual organizar janelas minimizadas pode ser um dos valores a seguir:
         ///
         /// ARW_DOWN	Organize verticalmente, de cima para baixo.
         /// ARW_HIDE	Ocultar janelas minimizadas movendo-as para fora da área visível da tela.
         /// ARW_LEFT	Organize horizontalmente, da esquerda para a direita.
         /// ARW_RIGHT	Organize horizontalmente, da direita para a esquerda.
         /// ARW_UP	Organize verticalmente, de baixo para cima.
         /// </remarks>
			SM_ARRANGE = 56,

         /// <summary>
         ///   O valor que especifica como o sistema é iniciado:
         ///   0 Inicialização normal
         ///   1 Inicialização com falha
         ///   2 Fail-safe com inicialização de rede
         ///   Uma inicialização à prova de falhas (também chamada de SafeBoot, Modo de Segurança ou Inicialização Limpa) ignora os arquivos de inicialização do usuário.
         /// </summary>
			SM_CLEANBOOT = 67,

         /// <summary>
         /// O número de monitores de exibição em uma área de trabalho. Para obter mais informações, consulte a seção Comentários neste tópico.
         /// </summary>
         /// <remarks>
         /// GetSystemMetrics(SM_CMONITORS) conta apenas monitores de exibição visíveis.
         /// Isso é diferente de EnumDisplayMonitors, que enumera monitores de exibição visíveis e pseudo-monitores invisíveis associados a drivers de espelhamento.
         /// Um pseudo-monitor invisível é associado a um pseudo-dispositivo usado para espelho desenho de aplicativo para comunicação remota ou outras finalidades.
         /// </remarks>
			SM_CMONITORS = 80,

         /// <summary>
         /// O número de botões em um mouse ou zero se nenhum mouse estiver instalado.
         /// </summary>
			SM_CMOUSEBUTTONS = 43,

         /// <summary>
         /// Reflete o estado do laptop ou modo slate, 0 para Modo Slate e diferente de zero caso contrário.
         /// Quando essa métrica do sistema é alterada, o sistema envia uma mensagem de difusão por meio de <b>WM_SETTINGCHANGE</b> com "ConvertibleSlateMode" no <b>LPARAM</b>.
         /// Observe que essa métrica do sistema não se aplica a computadores desktop. Nesse caso, use GetAutoRotationState.
         /// </summary>
			SM_CONVERTIBLESLATEMODE = 8195,

         /// <summary>
         ///   A largura de uma borda de janela, em pixels. Isso é equivalente ao valor SM_CXEDGE para janelas com a aparência 3D.
         /// </summary>
			SM_CXBORDER = 5,

         /// <summary>
         ///   A largura nominal de um cursor, em pixels.
         /// </summary>
			SM_CXCURSOR = 13,

         /// <summary>
         ///   Esse valor é o mesmo que SM_CXFIXEDFRAME.
         /// </summary>
			SM_CXDLGFRAME = 7,

         /// <summary>
         /// A largura do retângulo ao redor do local de um primeiro clique em uma
         /// sequência de clique duplo, em pixels. O segundo clique deve ocorrer dentro do
         /// retângulo definido por <b>SM_CXDOUBLECLK</b> e <b>SM_CYDOUBLECLK</b> para que o
         /// sistema considere os dois cliques em um clique duplo. Os dois cliques também
         /// devem ocorrer dentro de um tempo especificado.
         /// Para definir a largura do retângulo de clique duplo, chame <b>SystemParametersInfo</b> com <b>SPI_SETDOUBLECLKWIDTH</b>.
         /// </summary>
			SM_CXDOUBLECLK = 36,

         /// <summary>
         ///   O número de pixels em ambos os lados de um ponto de mouse para baixo que
         ///   o ponteiro do mouse pode mover antes do início de uma operação de arrastar.
         ///   Isso permite que o usuário clique e solte o botão do mouse facilmente sem
         //    iniciar acidentalmente uma operação de arrastar. Se esse valor for negativo, ele
         ///   será subtraído da esquerda do ponto para baixo do mouse e adicionado à
         ///   direita dele.
         /// </summary>
			SM_CXDRAG = 68,

         /// <summary>
         ///   A largura de uma borda 3D, em pixels. Essa métrica é a contraparte 3D do
         ///   <b>SM_CXBORDER</b>.
         /// </summary>
			SM_CXEDGE = 45,

         /// <summary>
         ///   A espessura do quadro ao redor do perímetro de uma janela que tem um
         ///   legenda, mas não é considerável, em pixels. <b>SM_CXFIXEDFRAME</b> é a altura
         ///   da borda horizontal e <b>SM_CYFIXEDFRAME</b> é a largura da borda vertical.
         ///   Esse valor é o mesmo que <b>SM_CXDLGFRAME</b>.
         /// </summary>
			SM_CXFIXEDFRAME = 7,

         /// <summary>
         ///   A largura das bordas esquerda e direita do retângulo de foco que o
         ///   <b>DrawFocusRect</b> desenha. Esse valor está em pixels.
         ///
         ///   Windows 2000: Não há suporte para esse valor.
         /// </summary>
			SM_CXFOCUSBORDER = 83,

         /// <summary>
         ///   Esse valor é o mesmo que SM_CXSIZEFRAME.
         /// </summary>
			SM_CXFRAME = 32,

         /// <summary>
         ///   A largura da área do cliente para uma janela de tela inteira no monitor de
         ///   exibição primário, em pixels. Para obter as coordenadas da parte da tela que
         ///   não é obscurecida pela barra de tarefas do sistema ou pelas barras de
         ///   ferramentas da área de trabalho do aplicativo, chame a função
         ///   <b>SystemParametersInfo</b> com o valor <b>SPI_GETWORKAREA</b>.
         /// </summary>
			SM_CXFULLSCREEN = 16,

         /// <summary>
         ///   A largura do bitmap de seta em uma barra de rolagem horizontal, em pixels.
         /// </summary>
			SM_CXHSCROLL = 21,

         /// <summary>
         ///   A largura da caixa de polegar em uma barra de rolagem horizontal, em pixels.
         /// </summary>
			SM_CXHTHUMB = 10,

         /// <summary>
         ///   A largura grande do sistema de um ícone, em pixels. A função LoadIcon pode
         ///   carregar somente ícones com as dimensões que <b>SM_CXICON</b> e <b>SM_CYICON</b>
         ///   especifica. Consulte Tamanhos de ícone para obter mais informações.
         /// </summary>
			SM_CXICON = 11,

         /// <summary>
         ///   A largura de uma célula de grade para itens na exibição de ícone grande, em
         ///   pixels. Cada item se encaixa em um retângulo de tamanho
         ///   <b>SM_CXICONSPACING</b> por <b>SM_CYICONSPACING</b> quando organizado. Esse valor
         ///   é sempre maior ou igual a <b>SM_CXICON</b>.
         /// </summary>
			SM_CXICONSPACING = 38,

         /// <summary>
         ///   A largura padrão, em pixels, de uma janela de nível superior maximizada no
         ///   monitor de exibição primário.
         /// </summary>
			SM_CXMAXIMIZED = 61,

         /// <summary>
         ///   A largura máxima padrão de uma janela que tem um legenda e bordas de
         ///   dimensionamento, em pixels. Essa métrica refere-se a toda a área de trabalho.
         ///   O usuário não pode arrastar o quadro da janela para um tamanho maior que
         ///   essas dimensões. Uma janela pode substituir esse valor processando a
         ///   mensagem <b>WM_GETMINMAXINFO</b>.
         /// </summary>
			SM_CXMAXTRACK = 59,

         /// <summary>
         ///   A largura do menu padrão marcar-mark bitmap, em pixels.
         /// </summary>
			SM_CXMENUCHECK = 71,

         /// <summary>
         ///   A largura dos botões da barra de menus, como o botão de fechamento da janela filho que é usado na interface de vários documentos, em pixels.
         /// </summary>
			SM_CXMENUSIZE = 54,

         /// <summary>
         ///   A largura mínima de uma janela, em pixels.
         /// </summary>
			SM_CXMIN = 28,

         /// <summary>
         ///   A largura de uma janela minimizada, em pixels.
         /// </summary>
			SM_CXMINIMIZED = 57,

         /// <summary>
         ///   A largura de uma célula de grade para uma janela minimizada, em pixels. Cada
         ///   janela minimizada se encaixa em um retângulo desse tamanho quando
         ///   organizada. Esse valor é sempre maior ou igual a <b>SM_CXMINIMIZED</b>.
         /// </summary>
			SM_CXMINSPACING = 47,

         /// <summary>
         ///   A largura mínima de acompanhamento de uma janela, em pixels. O usuário não
         ///   pode arrastar o quadro da janela para um tamanho menor que essas
         ///   dimensões. Uma janela pode substituir esse valor processando a mensagem
         ///   <b>WM_GETMINMAXINFO</b>.
         /// </summary>
			SM_CXMINTRACK = 34,

         /// <summary>
         ///   A quantidade de preenchimento de borda para janelas legendadas, em pixels.
         ///
         ///   Windows XP/2000: Não há suporte para esse valor.
         /// </summary>
			SM_CXPADDEDBORDER = 92,

         /// <summary>
         ///   A largura da tela do monitor de exibição primário, em pixels. Esse é o mesmo valor obtido
         ///   chamando GetDeviceCaps da seguinte maneira: <b>GetDeviceCaps( hdcPrimaryMonitor, HORZRES)</b>.
         /// </summary>
			SM_CXSCREEN = 0,

         /// <summary>
         ///   A largura de um botão em uma janela legenda ou barra de título, em pixels.
         /// </summary>
			SM_CXSIZE = 30,

         /// <summary>
         ///   A espessura da borda de dimensionamento ao redor do perímetro de uma
         ///   janela que pode ser redimensionada, em pixels. <b>SM_CXSIZEFRAME</b> é a largura
         ///   da borda horizontal e <b>SM_CYSIZEFRAME</b> é a altura da borda vertical.
         ///   Esse valor é o mesmo que <b>SM_CXFRAME</b>.
         /// </summary>
			SM_CXSIZEFRAME = 32,

         /// <summary>
         ///   A largura pequena do sistema de um ícone, em pixels. Ícones pequenos
         ///   normalmente aparecem em legendas de janela e no modo de exibição de
         ///   ícone pequeno. Consulte <b>Tamanhos de ícone</b> para obter mais informações.
         /// </summary>
			SM_CXSMICON = 49,

         /// <summary>
         ///   A largura de botões pequenos legenda, em pixels.
         /// </summary>
			SM_CXSMSIZE = 52,

         /// <summary>
         ///   A largura <b>da tela virtual</b>, em pixels. A tela virtual é o retângulo delimitador de
         ///   todos os monitores de exibição. A métrica <b>SM_XVIRTUALSCREEN<b> são as
         ///   coordenadas para o lado esquerdo da tela virtual.
         /// </summary>
			SM_CXVIRTUALSCREEN = 78,

         /// <summary>
         ///   A largura de uma barra de rolagem vertical, em pixels.
         /// </summary>
			SM_CXVSCROLL = 2,

         /// <summary>
         ///   A altura de uma borda de janela, em pixels. Isso é equivalente ao
         ///   valor <b>SM_CYEDGE</b> para janelas com a aparência 3D.
         /// </summary>
			SM_CYBORDER = 6,

         /// <summary>
         ///   A altura de uma área legenda, em pixels.
         /// </summary>
			SM_CYCAPTION = 4,

         /// <summary>
         ///   A altura nominal de um cursor, em pixels.
         /// </summary>
			SM_CYCURSOR = 14,

         /// <summary>
         ///   Esse valor é o mesmo que SM_CYFIXEDFRAME.
         /// </summary>
			SM_CYDLGFRAME = 8,

         /// <summary>
         ///   A altura do retângulo ao redor da localização de um primeiro clique em uma
         ///   sequência de clique duplo, em pixels. O segundo clique deve ocorrer dentro do
         ///   retângulo definido por <b>SM_CXDOUBLECLK</b> e <b>SM_CYDOUBLECLK</b> para que o
         ///   sistema considere os dois cliques em um clique duplo. Os dois cliques também
         ///   devem ocorrer dentro de um tempo especificado.
         ///   Para definir a altura do retângulo de clique duplo, chame <b>SystemParametersInfo</b> com
         ///   <b>SPI_SETDOUBLECLKHEIGHT</b>.
         /// </summary>
			SM_CYDOUBLECLK = 37,

         /// <summary>
         ///   O número de pixels acima e abaixo de um ponto de mouse para baixo que o
         ///   ponteiro do mouse pode mover antes que uma operação de arrastar comece.
         ///   Isso permite que o usuário clique e solte o botão do mouse facilmente sem
         ///   iniciar involuntariamente uma operação de arrastar. Se esse valor for negativo,
         ///   ele será subtraído acima do ponto de mouse para baixo e adicionado abaixo dele.
         /// </summary>
			SM_CYDRAG = 69,

         /// <summary>
         ///   A altura de uma borda 3D, em pixels. Este é o equivalente 3D de <b>SM_CYBORDER</b>.
         /// </summary>
			SM_CYEDGE = 46,

         /// <summary>
         ///   A espessura do quadro ao redor do perímetro de uma janela que tem um
         ///   legenda mas não é considerável, em pixels. SM_CXFIXEDFRAME é a altura da
         ///   borda horizontal e SM_CYFIXEDFRAME é a largura da borda vertical.
         ///   Esse valor é o mesmo que SM_CYDLGFRAME.
         /// </summary>
			SM_CYFIXEDFRAME = 8,

         /// <summary>
         ///   A altura das bordas superior e inferior do retângulo de foco desenhado por
         ///   <b>DrawFocusRect</b>. Esse valor está em pixels.
         ///
         ///   Windows 2000: Não há suporte para esse valor.
         /// </summary>
			SM_CYFOCUSBORDER = 84,

         /// <summary>
         ///   Esse valor é o mesmo que SM_CYSIZEFRAME.
         /// </summary>
			SM_CYFRAME = 33,

         /// <summary>
         ///   A altura da área do cliente para uma janela de tela inteira no monitor de
         ///   exibição primário, em pixels. Para obter as coordenadas da parte da tela não
         ///   obscurecidas pela barra de tarefas do sistema ou pelas barras de ferramentas
         ///   da área de trabalho do aplicativo, chame a função SystemParametersInfo com o
         ///   valor <b>SPI_GETWORKAREA</b>.
         /// </summary>
			SM_CYFULLSCREEN = 17,

         /// <summary>
         ///   A altura de uma barra de rolagem horizontal, em pixels.
         /// </summary>
			SM_CYHSCROLL = 3,

         /// <summary>
         ///   A altura grande do sistema de um ícone, em pixels. A função LoadIcon pode
         ///   carregar apenas ícones com as dimensões que <b>SM_CXICON</b> e <b>SM_CYICON</b>
         ///   especifica. Consulte Tamanhos de ícone para obter mais informações.
         /// </summary>
			SM_CYICON = 12,

         /// <summary>
         ///   A altura de uma célula de grade para itens na exibição de ícone grande, em
         ///   pixels. Cada item se encaixa em um retângulo de tamanho
         ///   <b>SM_CXICONSPACING</b> <b>SM_CYICONSPACING</b> quando organizado. Esse valor é
         ///   sempre maior ou igual a <b>SM_CYICON</b>.
         /// </summary>
			SM_CYICONSPACING = 39,

         /// <summary>
         ///   Para versões de conjunto de caracteres de bytes duplos do sistema, essa é a
         ///   altura da janela Kanji na parte inferior da tela, em pixels.
         /// </summary>
			SM_CYKANJIWINDOW = 18,

         /// <summary>
         ///   A altura padrão, em pixels, de uma janela de nível superior maximizada no
         ///   monitor de exibição primário.
         /// </summary>
			SM_CYMAXIMIZED = 62,

         /// <summary>
         ///   A altura máxima padrão de uma janela que tem uma legenda e bordas de
         ///   dimensionamento, em pixels. Essa métrica refere-se a toda a área de trabalho.
         ///   O usuário não pode arrastar o quadro da janela para um tamanho maior que
         ///   essas dimensões. Uma janela pode substituir esse valor processando a
         ///   mensagem <b>WM_GETMINMAXINFO</b>.
         /// </summary>
			SM_CYMAXTRACK = 60,

         /// <summary>
         ///   A altura de uma barra de menus de linha única, em pixels.
         /// </summary>
			SM_CYMENU = 15,

         /// <summary>
         ///   A altura do menu padrão marcar-mark bitmap, em pixels.
         /// </summary>
			SM_CYMENUCHECK = 72,

         /// <summary>
         ///   A altura dos botões da barra de menus, como o botão de fechamento da janela
         ///   filho que é usado na interface de vários documentos, em pixels.
         /// </summary>
			SM_CYMENUSIZE = 55,

         /// <summary>
         ///   A altura mínima de uma janela, em pixels.
         /// </summary>
			SM_CYMIN = 29,

         /// <summary>
         ///   A altura de uma janela minimizada, em pixels.
         /// </summary>
			SM_CYMINIMIZED = 58,

         /// <summary>
         ///   A altura de uma célula de grade para uma janela minimizada, em pixels. Cada
         ///   janela minimizada se encaixa em um retângulo desse tamanho quando
         ///   organizada. Esse valor é sempre maior ou igual a <b>SM_CYMINIMIZED</b>.
         /// </summary>
			SM_CYMINSPACING = 48,

         /// <summary>
         ///   A altura mínima de acompanhamento de uma janela, em pixels. O usuário não
         ///   pode arrastar o quadro da janela para um tamanho menor que essas
         ///   dimensões. Uma janela pode substituir esse valor processando a mensagem
         ///   <b>WM_GETMINMAXINFO</b>.
         /// </summary>
			SM_CYMINTRACK = 35,

         /// <summary>
         ///   A altura da tela do monitor de exibição primário, em pixels. Esse é o mesmo valor obtido
         ///   chamando GetDeviceCaps da seguinte maneira: <b>GetDeviceCaps( hdcPrimaryMonitor, VERTRES)</b>.
         /// </summary>
			SM_CYSCREEN = 1,

         /// <summary>
         ///   A altura de um botão em uma janela legenda ou barra de título, em pixels.
         /// </summary>
			SM_CYSIZE = 31,

         /// <summary>
         ///   A espessura da borda de dimensionamento ao redor do perímetro de uma
         ///   janela que pode ser redimensionada, em pixels. <b>SM_CXSIZEFRAME</b> é a largura
         ///   da borda horizontal e <b>SM_CYSIZEFRAME</b> é a altura da borda vertical.
         ///   Esse valor é o mesmo que <b>SM_CYFRAME</b>.
         /// </summary>
			SM_CYSIZEFRAME = 33,

         /// <summary>
         ///   A altura de um pequeno legenda, em pixels.
         /// </summary>
			SM_CYSMCAPTION = 51,

         /// <summary>
         ///   A altura pequena do sistema de um ícone, em pixels. Ícones pequenos normalmente aparecem em legendas de janela e no modo de exibição de ícone pequeno. Consulte Tamanhos de ícone para obter mais informações.
         /// </summary>
			SM_CYSMICON = 50,

         /// <summary>
         ///   A altura de botões pequenos legenda, em pixels.
         /// </summary>
			SM_CYSMSIZE = 53,

         /// <summary>
         ///   A altura da tela virtual, em pixels. A tela virtual é o retângulo delimitador de todos os monitores de exibição. A métrica SM_YVIRTUALSCREEN são as coordenadas para a parte superior da tela virtual.
         /// </summary>
			SM_CYVIRTUALSCREEN = 79,

         /// <summary>
         ///   A altura do bitmap de seta em uma barra de rolagem vertical, em pixels.
         /// </summary>
			SM_CYVSCROLL = 20,

         /// <summary>
         ///   A altura da caixa de polegar em uma barra de rolagem vertical, em pixels.
         /// </summary>
			SM_CYVTHUMB = 9,

         /// <summary>
         ///   Diferente de zero se User32.dll der suporte a DBCS; caso contrário, 0.
         /// </summary>
			SM_DBCSENABLED = 42,

         /// <summary>
         ///   Diferente de zero se a versão de depuração do User.exe estiver instalada; caso contrário, 0.
         /// </summary>
			SM_DEBUG = 22,

         /// <summary>
         ///   Diferente de zero se o sistema operacional atual for o Windows 7 ou o Windows Server 2008 R2 e o serviço de Entrada do Tablet PC for iniciado; caso contrário, 0.
         ///   O valor retornado é uma máscara de bits que especifica o tipo de entrada do digitalizador compatível com o dispositivo.
         ///   Para obter mais informações, consulte Comentários.
         ///
         ///   Windows Server 2008, Windows Vista e Windows XP/2000: Não há suporte para esse valor.
         /// </summary>
			SM_DIGITIZER = 94,

         /// <summary>
         ///   Diferente de zero se o Gerenciador de Métodos de Entrada/Método de Entrada Editor recursos estiverem habilitados; caso contrário, 0.
         //    SM_IMMENABLED indica se o sistema está pronto para usar um IME baseado em Unicode em um aplicativo Unicode.
         ///   Para garantir que um IME dependente de idioma funcione, marcar SM_DBCSENABLED e a página de código ANSI do sistema.
         ///   Caso contrário, a conversão ANSI para Unicode pode não ser executada corretamente ou alguns componentes,
         ///   como fontes ou configurações do Registro, podem não estar presentes.
         /// </summary>
			SM_IMMENABLED = 82,

         /// <summary>
         ///   Diferente de zero se houver digitalizadores no sistema; caso contrário, 0.
         ///   SM_MAXIMUMTOUCHES retorna o máximo agregado do número máximo de contatos com suporte de cada digitalizador no sistema.
         ///   Se o sistema tiver apenas digitalizadores de toque único, o valor retornado será 1.
         ///   Se o sistema tiver digitalizadores de vários toques, o valor retornado será o número de contatos simultâneos que o hardware pode fornecer.
         ///
         ///   Windows Server 2008, Windows Vista e Windows XP/2000: Não há suporte para esse valor.
         /// </summary>
			SM_MAXIMUMTOUCHES = 95,

         /// <summary>
         ///   Diferente de zero se o sistema operacional atual for o Windows XP, Media Center Edition, 0 se não for.
         /// </summary>
			SM_MEDIACENTER = 87,

         /// <summary>
         ///   Diferente de zero se os menus suspensos estiverem alinhados à direita com o item da barra de menus correspondente; 0 se os menus estiverem alinhados à esquerda.
         /// </summary>
			SM_MENUDROPALIGNMENT = 40,

         /// <summary>
         ///   Diferente de zero se o sistema estiver habilitado para idiomas hebraicos e árabes, 0 se não estiver.
         /// </summary>
			SM_MIDEASTENABLED = 74,

         /// <summary>
         ///   Diferente de zero se um mouse estiver instalado; caso contrário, 0.
         //    Esse valor raramente é zero, devido ao suporte para ratos virtuais e porque alguns sistemas detectam a presença da porta em vez da presença de um mouse.
         /// </summary>
			SM_MOUSEPRESENT = 19,

         /// <summary>
         ///   Diferente de zero se um mouse com uma roda de rolagem horizontal estiver instalado; caso contrário, 0.
         /// </summary>
			SM_MOUSEHORIZONTALWHEELPRESENT = 91,

         /// <summary>
         ///   Diferente de zero se um mouse com uma roda de rolagem vertical estiver instalado; caso contrário, 0.
         /// </summary>
			SM_MOUSEWHEELPRESENT = 75,

         /// <summary>
         ///   O bit menos significativo será definido se uma rede estiver presente; caso contrário, ele será limpo. Os outros bits são reservados para uso futuro.
         /// </summary>
			SM_NETWORK = 63,

         /// <summary>
         ///   Diferente de zero se as extensões de computação do Microsoft Windows para Caneta estiverem instaladas; caso contrário, zero.
         /// </summary>
			SM_PENWINDOWS = 41,

         /// <summary>
         ///   Essa métrica do sistema é usada em um ambiente de Serviços de Terminal para
         ///   determinar se a sessão atual do Terminal Server está sendo controlada
         ///   remotamente. Seu valor será diferente de zero se a sessão atual for controlada
         ///   remotamente; caso contrário, 0.
         ///   Você pode usar ferramentas de gerenciamento de serviços de terminal, como o
         ///   Gerenciador de Serviços de Terminal (tsadmin.msc) e shadow.exe para controlar
         ///   uma sessão remota. Quando uma sessão está sendo controlada remotamente,
         ///   outro usuário pode exibir o conteúdo dessa sessão e potencialmente interagir
         ///   com ela.
         /// </summary>
			SM_REMOTECONTROL = 8193,

         /// <summary>
         ///   Essa métrica do sistema é usada em um ambiente de Serviços de Terminal. Se o
         ///   processo de chamada estiver associado a uma sessão de cliente dos Serviços de
         ///   Terminal, o valor retornado será diferente de zero. Se o processo de chamada
         ///   estiver associado à sessão de console dos Serviços de Terminal, o valor
         ///   retornado será 0. Windows Server 2003 e Windows XP: A sessão do console
         ///   não é necessariamente o console físico.
         ///   Para obter mais informações, consulte <b>WTSGetActiveConsoleSessionId</b>.
         /// </summary>
			SM_REMOTESESSION = 4096,

         /// <summary>
         ///   Diferente de zero se todos os monitores de exibição tiverem o mesmo formato
         ///   de cor, caso contrário, 0. Duas telas podem ter a mesma profundidade de bit,
         ///   mas formatos de cor diferentes. Por exemplo, os pixels vermelho, verde e azul
         ///   podem ser codificados com números diferentes de bits ou esses bits podem
         ///   estar localizados em locais diferentes em um valor de cor de pixel.
         /// </summary>
			SM_SAMEDISPLAYFORMAT = 81,

         /// <summary>
         ///   Essa métrica do sistema deve ser ignorada; ele sempre retorna 0.
         /// </summary>
			SM_SECURE = 44,

         /// <summary>
         ///   O número de build se o sistema for Windows Server 2003 R2; caso contrário, 0.
         /// </summary>
			SM_SERVERR2 = 89,

         /// <summary>
         ///   Diferente de zero se o usuário exigir que um aplicativo apresente informações
         ///   visualmente em situações em que, de outra forma, ele apresentaria as
         ///   informações apenas de forma audível; caso contrário, 0.
         /// </summary>
			SM_SHOWSOUNDS = 70,

         /// <summary>
         ///   Diferente de zero se a sessão atual estiver sendo fechada; caso contrário, 0.
         ///   Windows 2000: Não há suporte para esse valor.
         /// </summary>
			SM_SHUTTINGDOWN = 8192,

         /// <summary>
         ///   Diferente de zero se o computador tiver um processador de baixo nível (lento);
         ///   caso contrário, 0.
         /// </summary>
			SM_SLOWMACHINE = 73,

         /// <summary>
         ///   Diferente de zero se o sistema operacional atual for Windows 7 Starter Edition,
         ///   Windows Vista Starter ou Windows XP Starter Edition; caso contrário, 0.
         /// </summary>
			SM_STARTER = 88,

         /// <summary>
         ///   Diferente de zero se os significados dos botões esquerdo e direito do mouse
         ///   forem trocados; caso contrário, 0.
         /// </summary>
			SM_SWAPBUTTON = 23,

         /// <summary>
         ///   Reflete o estado do modo de encaixe, 0 para Modo Desencaixado e diferente
         ///   de zero caso contrário. Quando essa métrica do sistema é alterada, o sistema
         ///   envia uma mensagem de difusão por meio de <b>WM_SETTINGCHANGE<b> com
         ///   "SystemDockMode" no LPARAM.
         /// </summary>
			SM_SYSTEMDOCKED = 8196,

         /// <summary>
         ///   Diferente de zero se o sistema operacional atual for o Windows XP Tablet PC
         ///   edition ou se o sistema operacional atual for Windows Vista ou Windows 7 e o
         ///   serviço tablet PC Input for iniciado; caso contrário, 0. A configuração
         ///   <b>SM_DIGITIZER</b> indica o tipo de entrada do digitalizador compatível com um
         ///   dispositivo que executa o Windows 7 ou o Windows Server 2008 R2. Para obter
         ///   mais informações, consulte Comentários.
         /// </summary>
			SM_TABLETPC = 86,

         /// <summary>
         ///   As coordenadas para o lado esquerdo da tela virtual. A tela virtual é o retângulo
         ///   delimitador de todos os monitores de vídeo. A métrica <b>SM_CXVIRTUALSCREEN</b>
         ///   é a largura da tela virtual.
         /// </summary>
			SM_XVIRTUALSCREEN = 76,

         /// <summary>
         ///   As coordenadas para a parte superior da tela virtual. A tela virtual é o retângulo
         ///   delimitador de todos os monitores de vídeo. A métrica <b>SM_CYVIRTUALSCREEN<b>
         ///   é a altura da tela virtual.
         /// </summary>
			SM_YVIRTUALSCREEN = 77
		);

   { ROP_CODE }

   ROP_CODE = type UInt32;
   ROP_CODE_HELPER = record helper for ROP_CODE
      const BLACKNESS = $00000042;
      const NOTSRCERASE = $001100A6;
      const NOTSRCCOPY = $00330008;
      const SRCERASE = $00440328;
      const DSTINVERT = $00550009;
      const PATINVERT = $005A0049;
      const SRCINVERT = $00660046;
      const SRCAND = $008800C6;
      const MERGEPAINT = $00BB0226;
      const MERGECOPY = $00C000CA;
      const SRCCOPY = $00CC0020;
      const SRCPAINT = $00EE0086;
      const PATCOPY = $00F00021;
      const PATPAINT = $00FB0A09;
      const WHITENESS = $00FF0062;
      const CAPTUREBLT = $40000000;
      const NOMIRRORBITMAP = $80000000;
   end;

   { WIN32_ERROR }

   WIN32_ERROR = type UInt32;

   WIN32_ERROR_HELPER = record helper for WIN32_ERROR
      public const NO_ERROR = UInt32(0);
      public const ERROR_EXPECTED_SECTION_NAME = UInt32(3758096384);
      public const ERROR_BAD_SECTION_NAME_LINE = UInt32(3758096385);
      public const ERROR_SECTION_NAME_TOO_LONG = UInt32(3758096386);
      public const ERROR_GENERAL_SYNTAX = UInt32(3758096387);
      public const ERROR_WRONG_INF_STYLE = UInt32(3758096640);
      public const ERROR_SECTION_NOT_FOUND = UInt32(3758096641);
      public const ERROR_LINE_NOT_FOUND = UInt32(3758096642);
      public const ERROR_NO_BACKUP = UInt32(3758096643);
      public const ERROR_NO_ASSOCIATED_CLASS = UInt32(3758096896);
      public const ERROR_CLASS_MISMATCH = UInt32(3758096897);
      public const ERROR_DUPLICATE_FOUND = UInt32(3758096898);
      public const ERROR_NO_DRIVER_SELECTED = UInt32(3758096899);
      public const ERROR_KEY_DOES_NOT_EXIST = UInt32(3758096900);
      public const ERROR_INVALID_DEVINST_NAME = UInt32(3758096901);
      public const ERROR_INVALID_CLASS = UInt32(3758096902);
      public const ERROR_DEVINST_ALREADY_EXISTS = UInt32(3758096903);
      public const ERROR_DEVINFO_NOT_REGISTERED = UInt32(3758096904);
      public const ERROR_INVALID_REG_PROPERTY = UInt32(3758096905);
      public const ERROR_NO_INF = UInt32(3758096906);
      public const ERROR_NO_SUCH_DEVINST = UInt32(3758096907);
      public const ERROR_CANT_LOAD_CLASS_ICON = UInt32(3758096908);
      public const ERROR_INVALID_CLASS_INSTALLER = UInt32(3758096909);
      public const ERROR_DI_DO_DEFAULT = UInt32(3758096910);
      public const ERROR_DI_NOFILECOPY = UInt32(3758096911);
      public const ERROR_INVALID_HWPROFILE = UInt32(3758096912);
      public const ERROR_NO_DEVICE_SELECTED = UInt32(3758096913);
      public const ERROR_DEVINFO_LIST_LOCKED = UInt32(3758096914);
      public const ERROR_DEVINFO_DATA_LOCKED = UInt32(3758096915);
      public const ERROR_DI_BAD_PATH = UInt32(3758096916);
      public const ERROR_NO_CLASSINSTALL_PARAMS = UInt32(3758096917);
      public const ERROR_FILEQUEUE_LOCKED = UInt32(3758096918);
      public const ERROR_BAD_SERVICE_INSTALLSECT = UInt32(3758096919);
      public const ERROR_NO_CLASS_DRIVER_LIST = UInt32(3758096920);
      public const ERROR_NO_ASSOCIATED_SERVICE = UInt32(3758096921);
      public const ERROR_NO_DEFAULT_DEVICE_INTERFACE = UInt32(3758096922);
      public const ERROR_DEVICE_INTERFACE_ACTIVE = UInt32(3758096923);
      public const ERROR_DEVICE_INTERFACE_REMOVED = UInt32(3758096924);
      public const ERROR_BAD_INTERFACE_INSTALLSECT = UInt32(3758096925);
      public const ERROR_NO_SUCH_INTERFACE_CLASS = UInt32(3758096926);
      public const ERROR_INVALID_REFERENCE_STRING = UInt32(3758096927);
      public const ERROR_INVALID_MACHINENAME = UInt32(3758096928);
      public const ERROR_REMOTE_COMM_FAILURE = UInt32(3758096929);
      public const ERROR_MACHINE_UNAVAILABLE = UInt32(3758096930);
      public const ERROR_NO_CONFIGMGR_SERVICES = UInt32(3758096931);
      public const ERROR_INVALID_PROPPAGE_PROVIDER = UInt32(3758096932);
      public const ERROR_NO_SUCH_DEVICE_INTERFACE = UInt32(3758096933);
      public const ERROR_DI_POSTPROCESSING_REQUIRED = UInt32(3758096934);
      public const ERROR_INVALID_COINSTALLER = UInt32(3758096935);
      public const ERROR_NO_COMPAT_DRIVERS = UInt32(3758096936);
      public const ERROR_NO_DEVICE_ICON = UInt32(3758096937);
      public const ERROR_INVALID_INF_LOGCONFIG = UInt32(3758096938);
      public const ERROR_DI_DONT_INSTALL = UInt32(3758096939);
      public const ERROR_INVALID_FILTER_DRIVER = UInt32(3758096940);
      public const ERROR_NON_WINDOWS_NT_DRIVER = UInt32(3758096941);
      public const ERROR_NON_WINDOWS_DRIVER = UInt32(3758096942);
      public const ERROR_NO_CATALOG_FOR_OEM_INF = UInt32(3758096943);
      public const ERROR_DEVINSTALL_QUEUE_NONNATIVE = UInt32(3758096944);
      public const ERROR_NOT_DISABLEABLE = UInt32(3758096945);
      public const ERROR_CANT_REMOVE_DEVINST = UInt32(3758096946);
      public const ERROR_INVALID_TARGET = UInt32(3758096947);
      public const ERROR_DRIVER_NONNATIVE = UInt32(3758096948);
      public const ERROR_IN_WOW64 = UInt32(3758096949);
      public const ERROR_SET_SYSTEM_RESTORE_POINT = UInt32(3758096950);
      public const ERROR_SCE_DISABLED = UInt32(3758096952);
      public const ERROR_UNKNOWN_EXCEPTION = UInt32(3758096953);
      public const ERROR_PNP_REGISTRY_ERROR = UInt32(3758096954);
      public const ERROR_REMOTE_REQUEST_UNSUPPORTED = UInt32(3758096955);
      public const ERROR_NOT_AN_INSTALLED_OEM_INF = UInt32(3758096956);
      public const ERROR_INF_IN_USE_BY_DEVICES = UInt32(3758096957);
      public const ERROR_DI_FUNCTION_OBSOLETE = UInt32(3758096958);
      public const ERROR_NO_AUTHENTICODE_CATALOG = UInt32(3758096959);
      public const ERROR_AUTHENTICODE_DISALLOWED = UInt32(3758096960);
      public const ERROR_AUTHENTICODE_TRUSTED_PUBLISHER = UInt32(3758096961);
      public const ERROR_AUTHENTICODE_TRUST_NOT_ESTABLISHED = UInt32(3758096962);
      public const ERROR_AUTHENTICODE_PUBLISHER_NOT_TRUSTED = UInt32(3758096963);
      public const ERROR_SIGNATURE_OSATTRIBUTE_MISMATCH = UInt32(3758096964);
      public const ERROR_ONLY_VALIDATE_VIA_AUTHENTICODE = UInt32(3758096965);
      public const ERROR_DEVICE_INSTALLER_NOT_READY = UInt32(3758096966);
      public const ERROR_DRIVER_STORE_ADD_FAILED = UInt32(3758096967);
      public const ERROR_DEVICE_INSTALL_BLOCKED = UInt32(3758096968);
      public const ERROR_DRIVER_INSTALL_BLOCKED = UInt32(3758096969);
      public const ERROR_WRONG_INF_TYPE = UInt32(3758096970);
      public const ERROR_FILE_HASH_NOT_IN_CATALOG = UInt32(3758096971);
      public const ERROR_DRIVER_STORE_DELETE_FAILED = UInt32(3758096972);
      public const ERROR_UNRECOVERABLE_STACK_OVERFLOW = UInt32(3758097152);
      public const ERROR_NO_DEFAULT_INTERFACE_DEVICE = UInt32(3758096922);
      public const ERROR_INTERFACE_DEVICE_ACTIVE = UInt32(3758096923);
      public const ERROR_INTERFACE_DEVICE_REMOVED = UInt32(3758096924);
      public const ERROR_NO_SUCH_INTERFACE_DEVICE = UInt32(3758096933);
      public const ERROR_NOT_INSTALLED = UInt32(3758100480);
      public const ERROR_SUCCESS = UInt32(0);
      public const ERROR_INVALID_FUNCTION = UInt32(1);
      public const ERROR_FILE_NOT_FOUND = UInt32(2);
      public const ERROR_PATH_NOT_FOUND = UInt32(3);
      public const ERROR_TOO_MANY_OPEN_FILES = UInt32(4);
      public const ERROR_ACCESS_DENIED = UInt32(5);
      public const ERROR_INVALID_HANDLE = UInt32(6);
      public const ERROR_ARENA_TRASHED = UInt32(7);
      public const ERROR_NOT_ENOUGH_MEMORY = UInt32(8);
      public const ERROR_INVALID_BLOCK = UInt32(9);
      public const ERROR_BAD_ENVIRONMENT = UInt32(10);
      public const ERROR_BAD_FORMAT = UInt32(11);
      public const ERROR_INVALID_ACCESS = UInt32(12);
      public const ERROR_INVALID_DATA = UInt32(13);
      public const ERROR_OUTOFMEMORY = UInt32(14);
      public const ERROR_INVALID_DRIVE = UInt32(15);
      public const ERROR_CURRENT_DIRECTORY = UInt32(16);
      public const ERROR_NOT_SAME_DEVICE = UInt32(17);
      public const ERROR_NO_MORE_FILES = UInt32(18);
      public const ERROR_WRITE_PROTECT = UInt32(19);
      public const ERROR_BAD_UNIT = UInt32(20);
      public const ERROR_NOT_READY = UInt32(21);
      public const ERROR_BAD_COMMAND = UInt32(22);
      public const ERROR_CRC = UInt32(23);
      public const ERROR_BAD_LENGTH = UInt32(24);
      public const ERROR_SEEK = UInt32(25);
      public const ERROR_NOT_DOS_DISK = UInt32(26);
      public const ERROR_SECTOR_NOT_FOUND = UInt32(27);
      public const ERROR_OUT_OF_PAPER = UInt32(28);
      public const ERROR_WRITE_FAULT = UInt32(29);
      public const ERROR_READ_FAULT = UInt32(30);
      public const ERROR_GEN_FAILURE = UInt32(31);
      public const ERROR_SHARING_VIOLATION = UInt32(32);
      public const ERROR_LOCK_VIOLATION = UInt32(33);
      public const ERROR_WRONG_DISK = UInt32(34);
      public const ERROR_SHARING_BUFFER_EXCEEDED = UInt32(36);
      public const ERROR_HANDLE_EOF = UInt32(38);
      public const ERROR_HANDLE_DISK_FULL = UInt32(39);
      public const ERROR_NOT_SUPPORTED = UInt32(50);
      public const ERROR_REM_NOT_LIST = UInt32(51);
      public const ERROR_DUP_NAME = UInt32(52);
      public const ERROR_BAD_NETPATH = UInt32(53);
      public const ERROR_NETWORK_BUSY = UInt32(54);
      public const ERROR_DEV_NOT_EXIST = UInt32(55);
      public const ERROR_TOO_MANY_CMDS = UInt32(56);
      public const ERROR_ADAP_HDW_ERR = UInt32(57);
      public const ERROR_BAD_NET_RESP = UInt32(58);
      public const ERROR_UNEXP_NET_ERR = UInt32(59);
      public const ERROR_BAD_REM_ADAP = UInt32(60);
      public const ERROR_PRINTQ_FULL = UInt32(61);
      public const ERROR_NO_SPOOL_SPACE = UInt32(62);
      public const ERROR_PRINT_CANCELLED = UInt32(63);
      public const ERROR_NETNAME_DELETED = UInt32(64);
      public const ERROR_NETWORK_ACCESS_DENIED = UInt32(65);
      public const ERROR_BAD_DEV_TYPE = UInt32(66);
      public const ERROR_BAD_NET_NAME = UInt32(67);
      public const ERROR_TOO_MANY_NAMES = UInt32(68);
      public const ERROR_TOO_MANY_SESS = UInt32(69);
      public const ERROR_SHARING_PAUSED = UInt32(70);
      public const ERROR_REQ_NOT_ACCEP = UInt32(71);
      public const ERROR_REDIR_PAUSED = UInt32(72);
      public const ERROR_FILE_EXISTS = UInt32(80);
      public const ERROR_CANNOT_MAKE = UInt32(82);
      public const ERROR_FAIL_I24 = UInt32(83);
      public const ERROR_OUT_OF_STRUCTURES = UInt32(84);
      public const ERROR_ALREADY_ASSIGNED = UInt32(85);
      public const ERROR_INVALID_PASSWORD = UInt32(86);
      public const ERROR_INVALID_PARAMETER = UInt32(87);
      public const ERROR_NET_WRITE_FAULT = UInt32(88);
      public const ERROR_NO_PROC_SLOTS = UInt32(89);
      public const ERROR_TOO_MANY_SEMAPHORES = UInt32(100);
      public const ERROR_EXCL_SEM_ALREADY_OWNED = UInt32(101);
      public const ERROR_SEM_IS_SET = UInt32(102);
      public const ERROR_TOO_MANY_SEM_REQUESTS = UInt32(103);
      public const ERROR_INVALID_AT_INTERRUPT_TIME = UInt32(104);
      public const ERROR_SEM_OWNER_DIED = UInt32(105);
      public const ERROR_SEM_USER_LIMIT = UInt32(106);
      public const ERROR_DISK_CHANGE = UInt32(107);
      public const ERROR_DRIVE_LOCKED = UInt32(108);
      public const ERROR_BROKEN_PIPE = UInt32(109);
      public const ERROR_OPEN_FAILED = UInt32(110);
      public const ERROR_BUFFER_OVERFLOW = UInt32(111);
      public const ERROR_DISK_FULL = UInt32(112);
      public const ERROR_NO_MORE_SEARCH_HANDLES = UInt32(113);
      public const ERROR_INVALID_TARGET_HANDLE = UInt32(114);
      public const ERROR_INVALID_CATEGORY = UInt32(117);
      public const ERROR_INVALID_VERIFY_SWITCH = UInt32(118);
      public const ERROR_BAD_DRIVER_LEVEL = UInt32(119);
      public const ERROR_CALL_NOT_IMPLEMENTED = UInt32(120);
      public const ERROR_SEM_TIMEOUT = UInt32(121);
      public const ERROR_INSUFFICIENT_BUFFER = UInt32(122);
      public const ERROR_INVALID_NAME = UInt32(123);
      public const ERROR_INVALID_LEVEL = UInt32(124);
      public const ERROR_NO_VOLUME_LABEL = UInt32(125);
      public const ERROR_MOD_NOT_FOUND = UInt32(126);
      public const ERROR_PROC_NOT_FOUND = UInt32(127);
      public const ERROR_WAIT_NO_CHILDREN = UInt32(128);
      public const ERROR_CHILD_NOT_COMPLETE = UInt32(129);
      public const ERROR_DIRECT_ACCESS_HANDLE = UInt32(130);
      public const ERROR_NEGATIVE_SEEK = UInt32(131);
      public const ERROR_SEEK_ON_DEVICE = UInt32(132);
      public const ERROR_IS_JOIN_TARGET = UInt32(133);
      public const ERROR_IS_JOINED = UInt32(134);
      public const ERROR_IS_SUBSTED = UInt32(135);
      public const ERROR_NOT_JOINED = UInt32(136);
      public const ERROR_NOT_SUBSTED = UInt32(137);
      public const ERROR_JOIN_TO_JOIN = UInt32(138);
      public const ERROR_SUBST_TO_SUBST = UInt32(139);
      public const ERROR_JOIN_TO_SUBST = UInt32(140);
      public const ERROR_SUBST_TO_JOIN = UInt32(141);
      public const ERROR_BUSY_DRIVE = UInt32(142);
      public const ERROR_SAME_DRIVE = UInt32(143);
      public const ERROR_DIR_NOT_ROOT = UInt32(144);
      public const ERROR_DIR_NOT_EMPTY = UInt32(145);
      public const ERROR_IS_SUBST_PATH = UInt32(146);
      public const ERROR_IS_JOIN_PATH = UInt32(147);
      public const ERROR_PATH_BUSY = UInt32(148);
      public const ERROR_IS_SUBST_TARGET = UInt32(149);
      public const ERROR_SYSTEM_TRACE = UInt32(150);
      public const ERROR_INVALID_EVENT_COUNT = UInt32(151);
      public const ERROR_TOO_MANY_MUXWAITERS = UInt32(152);
      public const ERROR_INVALID_LIST_FORMAT = UInt32(153);
      public const ERROR_LABEL_TOO_LONG = UInt32(154);
      public const ERROR_TOO_MANY_TCBS = UInt32(155);
      public const ERROR_SIGNAL_REFUSED = UInt32(156);
      public const ERROR_DISCARDED = UInt32(157);
      public const ERROR_NOT_LOCKED = UInt32(158);
      public const ERROR_BAD_THREADID_ADDR = UInt32(159);
      public const ERROR_BAD_ARGUMENTS = UInt32(160);
      public const ERROR_BAD_PATHNAME = UInt32(161);
      public const ERROR_SIGNAL_PENDING = UInt32(162);
      public const ERROR_MAX_THRDS_REACHED = UInt32(164);
      public const ERROR_LOCK_FAILED = UInt32(167);
      public const ERROR_BUSY = UInt32(170);
      public const ERROR_DEVICE_SUPPORT_IN_PROGRESS = UInt32(171);
      public const ERROR_CANCEL_VIOLATION = UInt32(173);
      public const ERROR_ATOMIC_LOCKS_NOT_SUPPORTED = UInt32(174);
      public const ERROR_INVALID_SEGMENT_NUMBER = UInt32(180);
      public const ERROR_INVALID_ORDINAL = UInt32(182);
      public const ERROR_ALREADY_EXISTS = UInt32(183);
      public const ERROR_INVALID_FLAG_NUMBER = UInt32(186);
      public const ERROR_SEM_NOT_FOUND = UInt32(187);
      public const ERROR_INVALID_STARTING_CODESEG = UInt32(188);
      public const ERROR_INVALID_STACKSEG = UInt32(189);
      public const ERROR_INVALID_MODULETYPE = UInt32(190);
      public const ERROR_INVALID_EXE_SIGNATURE = UInt32(191);
      public const ERROR_EXE_MARKED_INVALID = UInt32(192);
      public const ERROR_BAD_EXE_FORMAT = UInt32(193);
      public const ERROR_ITERATED_DATA_EXCEEDS_64k = UInt32(194);
      public const ERROR_INVALID_MINALLOCSIZE = UInt32(195);
      public const ERROR_DYNLINK_FROM_INVALID_RING = UInt32(196);
      public const ERROR_IOPL_NOT_ENABLED = UInt32(197);
      public const ERROR_INVALID_SEGDPL = UInt32(198);
      public const ERROR_AUTODATASEG_EXCEEDS_64k = UInt32(199);
      public const ERROR_RING2SEG_MUST_BE_MOVABLE = UInt32(200);
      public const ERROR_RELOC_CHAIN_XEEDS_SEGLIM = UInt32(201);
      public const ERROR_INFLOOP_IN_RELOC_CHAIN = UInt32(202);
      public const ERROR_ENVVAR_NOT_FOUND = UInt32(203);
      public const ERROR_NO_SIGNAL_SENT = UInt32(205);
      public const ERROR_FILENAME_EXCED_RANGE = UInt32(206);
      public const ERROR_RING2_STACK_IN_USE = UInt32(207);
      public const ERROR_META_EXPANSION_TOO_LONG = UInt32(208);
      public const ERROR_INVALID_SIGNAL_NUMBER = UInt32(209);
      public const ERROR_THREAD_1_INACTIVE = UInt32(210);
      public const ERROR_LOCKED = UInt32(212);
      public const ERROR_TOO_MANY_MODULES = UInt32(214);
      public const ERROR_NESTING_NOT_ALLOWED = UInt32(215);
      public const ERROR_EXE_MACHINE_TYPE_MISMATCH = UInt32(216);
      public const ERROR_EXE_CANNOT_MODIFY_SIGNED_BINARY = UInt32(217);
      public const ERROR_EXE_CANNOT_MODIFY_STRONG_SIGNED_BINARY = UInt32(218);
      public const ERROR_FILE_CHECKED_OUT = UInt32(220);
      public const ERROR_CHECKOUT_REQUIRED = UInt32(221);
      public const ERROR_BAD_FILE_TYPE = UInt32(222);
      public const ERROR_FILE_TOO_LARGE = UInt32(223);
      public const ERROR_FORMS_AUTH_REQUIRED = UInt32(224);
      public const ERROR_VIRUS_INFECTED = UInt32(225);
      public const ERROR_VIRUS_DELETED = UInt32(226);
      public const ERROR_PIPE_LOCAL = UInt32(229);
      public const ERROR_BAD_PIPE = UInt32(230);
      public const ERROR_PIPE_BUSY = UInt32(231);
      public const ERROR_NO_DATA = UInt32(232);
      public const ERROR_PIPE_NOT_CONNECTED = UInt32(233);
      public const ERROR_MORE_DATA = UInt32(234);
      public const ERROR_NO_WORK_DONE = UInt32(235);
      public const ERROR_VC_DISCONNECTED = UInt32(240);
      public const ERROR_INVALID_EA_NAME = UInt32(254);
      public const ERROR_EA_LIST_INCONSISTENT = UInt32(255);
      public const ERROR_NO_MORE_ITEMS = UInt32(259);
      public const ERROR_CANNOT_COPY = UInt32(266);
      public const ERROR_DIRECTORY = UInt32(267);
      public const ERROR_EAS_DIDNT_FIT = UInt32(275);
      public const ERROR_EA_FILE_CORRUPT = UInt32(276);
      public const ERROR_EA_TABLE_FULL = UInt32(277);
      public const ERROR_INVALID_EA_HANDLE = UInt32(278);
      public const ERROR_EAS_NOT_SUPPORTED = UInt32(282);
      public const ERROR_NOT_OWNER = UInt32(288);
      public const ERROR_TOO_MANY_POSTS = UInt32(298);
      public const ERROR_PARTIAL_COPY = UInt32(299);
      public const ERROR_OPLOCK_NOT_GRANTED = UInt32(300);
      public const ERROR_INVALID_OPLOCK_PROTOCOL = UInt32(301);
      public const ERROR_DISK_TOO_FRAGMENTED = UInt32(302);
      public const ERROR_DELETE_PENDING = UInt32(303);
      public const ERROR_INCOMPATIBLE_WITH_GLOBAL_SHORT_NAME_REGISTRY_SETTING = UInt32(304);
      public const ERROR_SHORT_NAMES_NOT_ENABLED_ON_VOLUME = UInt32(305);
      public const ERROR_SECURITY_STREAM_IS_INCONSISTENT = UInt32(306);
      public const ERROR_INVALID_LOCK_RANGE = UInt32(307);
      public const ERROR_IMAGE_SUBSYSTEM_NOT_PRESENT = UInt32(308);
      public const ERROR_NOTIFICATION_GUID_ALREADY_DEFINED = UInt32(309);
      public const ERROR_INVALID_EXCEPTION_HANDLER = UInt32(310);
      public const ERROR_DUPLICATE_PRIVILEGES = UInt32(311);
      public const ERROR_NO_RANGES_PROCESSED = UInt32(312);
      public const ERROR_NOT_ALLOWED_ON_SYSTEM_FILE = UInt32(313);
      public const ERROR_DISK_RESOURCES_EXHAUSTED = UInt32(314);
      public const ERROR_INVALID_TOKEN = UInt32(315);
      public const ERROR_DEVICE_FEATURE_NOT_SUPPORTED = UInt32(316);
      public const ERROR_MR_MID_NOT_FOUND = UInt32(317);
      public const ERROR_SCOPE_NOT_FOUND = UInt32(318);
      public const ERROR_UNDEFINED_SCOPE = UInt32(319);
      public const ERROR_INVALID_CAP = UInt32(320);
      public const ERROR_DEVICE_UNREACHABLE = UInt32(321);
      public const ERROR_DEVICE_NO_RESOURCES = UInt32(322);
      public const ERROR_DATA_CHECKSUM_ERROR = UInt32(323);
      public const ERROR_INTERMIXED_KERNEL_EA_OPERATION = UInt32(324);
      public const ERROR_FILE_LEVEL_TRIM_NOT_SUPPORTED = UInt32(326);
      public const ERROR_OFFSET_ALIGNMENT_VIOLATION = UInt32(327);
      public const ERROR_INVALID_FIELD_IN_PARAMETER_LIST = UInt32(328);
      public const ERROR_OPERATION_IN_PROGRESS = UInt32(329);
      public const ERROR_BAD_DEVICE_PATH = UInt32(330);
      public const ERROR_TOO_MANY_DESCRIPTORS = UInt32(331);
      public const ERROR_SCRUB_DATA_DISABLED = UInt32(332);
      public const ERROR_NOT_REDUNDANT_STORAGE = UInt32(333);
      public const ERROR_RESIDENT_FILE_NOT_SUPPORTED = UInt32(334);
      public const ERROR_COMPRESSED_FILE_NOT_SUPPORTED = UInt32(335);
      public const ERROR_DIRECTORY_NOT_SUPPORTED = UInt32(336);
      public const ERROR_NOT_READ_FROM_COPY = UInt32(337);
      public const ERROR_FT_WRITE_FAILURE = UInt32(338);
      public const ERROR_FT_DI_SCAN_REQUIRED = UInt32(339);
      public const ERROR_INVALID_KERNEL_INFO_VERSION = UInt32(340);
      public const ERROR_INVALID_PEP_INFO_VERSION = UInt32(341);
      public const ERROR_OBJECT_NOT_EXTERNALLY_BACKED = UInt32(342);
      public const ERROR_EXTERNAL_BACKING_PROVIDER_UNKNOWN = UInt32(343);
      public const ERROR_COMPRESSION_NOT_BENEFICIAL = UInt32(344);
      public const ERROR_STORAGE_TOPOLOGY_ID_MISMATCH = UInt32(345);
      public const ERROR_BLOCKED_BY_PARENTAL_CONTROLS = UInt32(346);
      public const ERROR_BLOCK_TOO_MANY_REFERENCES = UInt32(347);
      public const ERROR_MARKED_TO_DISALLOW_WRITES = UInt32(348);
      public const ERROR_ENCLAVE_FAILURE = UInt32(349);
      public const ERROR_FAIL_NOACTION_REBOOT = UInt32(350);
      public const ERROR_FAIL_SHUTDOWN = UInt32(351);
      public const ERROR_FAIL_RESTART = UInt32(352);
      public const ERROR_MAX_SESSIONS_REACHED = UInt32(353);
      public const ERROR_NETWORK_ACCESS_DENIED_EDP = UInt32(354);
      public const ERROR_DEVICE_HINT_NAME_BUFFER_TOO_SMALL = UInt32(355);
      public const ERROR_EDP_POLICY_DENIES_OPERATION = UInt32(356);
      public const ERROR_EDP_DPL_POLICY_CANT_BE_SATISFIED = UInt32(357);
      public const ERROR_CLOUD_FILE_SYNC_ROOT_METADATA_CORRUPT = UInt32(358);
      public const ERROR_DEVICE_IN_MAINTENANCE = UInt32(359);
      public const ERROR_NOT_SUPPORTED_ON_DAX = UInt32(360);
      public const ERROR_DAX_MAPPING_EXISTS = UInt32(361);
      public const ERROR_CLOUD_FILE_PROVIDER_NOT_RUNNING = UInt32(362);
      public const ERROR_CLOUD_FILE_METADATA_CORRUPT = UInt32(363);
      public const ERROR_CLOUD_FILE_METADATA_TOO_LARGE = UInt32(364);
      public const ERROR_CLOUD_FILE_PROPERTY_BLOB_TOO_LARGE = UInt32(365);
      public const ERROR_CLOUD_FILE_PROPERTY_BLOB_CHECKSUM_MISMATCH = UInt32(366);
      public const ERROR_CHILD_PROCESS_BLOCKED = UInt32(367);
      public const ERROR_STORAGE_LOST_DATA_PERSISTENCE = UInt32(368);
      public const ERROR_FILE_SYSTEM_VIRTUALIZATION_UNAVAILABLE = UInt32(369);
      public const ERROR_FILE_SYSTEM_VIRTUALIZATION_METADATA_CORRUPT = UInt32(370);
      public const ERROR_FILE_SYSTEM_VIRTUALIZATION_BUSY = UInt32(371);
      public const ERROR_FILE_SYSTEM_VIRTUALIZATION_PROVIDER_UNKNOWN = UInt32(372);
      public const ERROR_GDI_HANDLE_LEAK = UInt32(373);
      public const ERROR_CLOUD_FILE_TOO_MANY_PROPERTY_BLOBS = UInt32(374);
      public const ERROR_CLOUD_FILE_PROPERTY_VERSION_NOT_SUPPORTED = UInt32(375);
      public const ERROR_NOT_A_CLOUD_FILE = UInt32(376);
      public const ERROR_CLOUD_FILE_NOT_IN_SYNC = UInt32(377);
      public const ERROR_CLOUD_FILE_ALREADY_CONNECTED = UInt32(378);
      public const ERROR_CLOUD_FILE_NOT_SUPPORTED = UInt32(379);
      public const ERROR_CLOUD_FILE_INVALID_REQUEST = UInt32(380);
      public const ERROR_CLOUD_FILE_READ_ONLY_VOLUME = UInt32(381);
      public const ERROR_CLOUD_FILE_CONNECTED_PROVIDER_ONLY = UInt32(382);
      public const ERROR_CLOUD_FILE_VALIDATION_FAILED = UInt32(383);
      public const ERROR_SMB1_NOT_AVAILABLE = UInt32(384);
      public const ERROR_FILE_SYSTEM_VIRTUALIZATION_INVALID_OPERATION = UInt32(385);
      public const ERROR_CLOUD_FILE_AUTHENTICATION_FAILED = UInt32(386);
      public const ERROR_CLOUD_FILE_INSUFFICIENT_RESOURCES = UInt32(387);
      public const ERROR_CLOUD_FILE_NETWORK_UNAVAILABLE = UInt32(388);
      public const ERROR_CLOUD_FILE_UNSUCCESSFUL = UInt32(389);
      public const ERROR_CLOUD_FILE_NOT_UNDER_SYNC_ROOT = UInt32(390);
      public const ERROR_CLOUD_FILE_IN_USE = UInt32(391);
      public const ERROR_CLOUD_FILE_PINNED = UInt32(392);
      public const ERROR_CLOUD_FILE_REQUEST_ABORTED = UInt32(393);
      public const ERROR_CLOUD_FILE_PROPERTY_CORRUPT = UInt32(394);
      public const ERROR_CLOUD_FILE_ACCESS_DENIED = UInt32(395);
      public const ERROR_CLOUD_FILE_INCOMPATIBLE_HARDLINKS = UInt32(396);
      public const ERROR_CLOUD_FILE_PROPERTY_LOCK_CONFLICT = UInt32(397);
      public const ERROR_CLOUD_FILE_REQUEST_CANCELED = UInt32(398);
      public const ERROR_EXTERNAL_SYSKEY_NOT_SUPPORTED = UInt32(399);
      public const ERROR_THREAD_MODE_ALREADY_BACKGROUND = UInt32(400);
      public const ERROR_THREAD_MODE_NOT_BACKGROUND = UInt32(401);
      public const ERROR_PROCESS_MODE_ALREADY_BACKGROUND = UInt32(402);
      public const ERROR_PROCESS_MODE_NOT_BACKGROUND = UInt32(403);
      public const ERROR_CLOUD_FILE_PROVIDER_TERMINATED = UInt32(404);
      public const ERROR_NOT_A_CLOUD_SYNC_ROOT = UInt32(405);
      public const ERROR_FILE_PROTECTED_UNDER_DPL = UInt32(406);
      public const ERROR_VOLUME_NOT_CLUSTER_ALIGNED = UInt32(407);
      public const ERROR_NO_PHYSICALLY_ALIGNED_FREE_SPACE_FOUND = UInt32(408);
      public const ERROR_APPX_FILE_NOT_ENCRYPTED = UInt32(409);
      public const ERROR_RWRAW_ENCRYPTED_FILE_NOT_ENCRYPTED = UInt32(410);
      public const ERROR_RWRAW_ENCRYPTED_INVALID_EDATAINFO_FILEOFFSET = UInt32(411);
      public const ERROR_RWRAW_ENCRYPTED_INVALID_EDATAINFO_FILERANGE = UInt32(412);
      public const ERROR_RWRAW_ENCRYPTED_INVALID_EDATAINFO_PARAMETER = UInt32(413);
      public const ERROR_LINUX_SUBSYSTEM_NOT_PRESENT = UInt32(414);
      public const ERROR_FT_READ_FAILURE = UInt32(415);
      public const ERROR_STORAGE_RESERVE_ID_INVALID = UInt32(416);
      public const ERROR_STORAGE_RESERVE_DOES_NOT_EXIST = UInt32(417);
      public const ERROR_STORAGE_RESERVE_ALREADY_EXISTS = UInt32(418);
      public const ERROR_STORAGE_RESERVE_NOT_EMPTY = UInt32(419);
      public const ERROR_NOT_A_DAX_VOLUME = UInt32(420);
      public const ERROR_NOT_DAX_MAPPABLE = UInt32(421);
      public const ERROR_TIME_SENSITIVE_THREAD = UInt32(422);
      public const ERROR_DPL_NOT_SUPPORTED_FOR_USER = UInt32(423);
      public const ERROR_CASE_DIFFERING_NAMES_IN_DIR = UInt32(424);
      public const ERROR_FILE_NOT_SUPPORTED = UInt32(425);
      public const ERROR_CLOUD_FILE_REQUEST_TIMEOUT = UInt32(426);
      public const ERROR_NO_TASK_QUEUE = UInt32(427);
      public const ERROR_SRC_SRV_DLL_LOAD_FAILED = UInt32(428);
      public const ERROR_NOT_SUPPORTED_WITH_BTT = UInt32(429);
      public const ERROR_ENCRYPTION_DISABLED = UInt32(430);
      public const ERROR_ENCRYPTING_METADATA_DISALLOWED = UInt32(431);
      public const ERROR_CANT_CLEAR_ENCRYPTION_FLAG = UInt32(432);
      public const ERROR_NO_SUCH_DEVICE = UInt32(433);
      public const ERROR_CLOUD_FILE_DEHYDRATION_DISALLOWED = UInt32(434);
      public const ERROR_FILE_SNAP_IN_PROGRESS = UInt32(435);
      public const ERROR_FILE_SNAP_USER_SECTION_NOT_SUPPORTED = UInt32(436);
      public const ERROR_FILE_SNAP_MODIFY_NOT_SUPPORTED = UInt32(437);
      public const ERROR_FILE_SNAP_IO_NOT_COORDINATED = UInt32(438);
      public const ERROR_FILE_SNAP_UNEXPECTED_ERROR = UInt32(439);
      public const ERROR_FILE_SNAP_INVALID_PARAMETER = UInt32(440);
      public const ERROR_UNSATISFIED_DEPENDENCIES = UInt32(441);
      public const ERROR_CASE_SENSITIVE_PATH = UInt32(442);
      public const ERROR_UNEXPECTED_NTCACHEMANAGER_ERROR = UInt32(443);
      public const ERROR_LINUX_SUBSYSTEM_UPDATE_REQUIRED = UInt32(444);
      public const ERROR_DLP_POLICY_WARNS_AGAINST_OPERATION = UInt32(445);
      public const ERROR_DLP_POLICY_DENIES_OPERATION = UInt32(446);
      public const ERROR_SECURITY_DENIES_OPERATION = UInt32(447);
      public const ERROR_UNTRUSTED_MOUNT_POINT = UInt32(448);
      public const ERROR_DLP_POLICY_SILENTLY_FAIL = UInt32(449);
      public const ERROR_CAPAUTHZ_NOT_DEVUNLOCKED = UInt32(450);
      public const ERROR_CAPAUTHZ_CHANGE_TYPE = UInt32(451);
      public const ERROR_CAPAUTHZ_NOT_PROVISIONED = UInt32(452);
      public const ERROR_CAPAUTHZ_NOT_AUTHORIZED = UInt32(453);
      public const ERROR_CAPAUTHZ_NO_POLICY = UInt32(454);
      public const ERROR_CAPAUTHZ_DB_CORRUPTED = UInt32(455);
      public const ERROR_CAPAUTHZ_SCCD_INVALID_CATALOG = UInt32(456);
      public const ERROR_CAPAUTHZ_SCCD_NO_AUTH_ENTITY = UInt32(457);
      public const ERROR_CAPAUTHZ_SCCD_PARSE_ERROR = UInt32(458);
      public const ERROR_CAPAUTHZ_SCCD_DEV_MODE_REQUIRED = UInt32(459);
      public const ERROR_CAPAUTHZ_SCCD_NO_CAPABILITY_MATCH = UInt32(460);
      public const ERROR_CIMFS_IMAGE_CORRUPT = UInt32(470);
      public const ERROR_CIMFS_IMAGE_VERSION_NOT_SUPPORTED = UInt32(471);
      public const ERROR_STORAGE_STACK_ACCESS_DENIED = UInt32(472);
      public const ERROR_INSUFFICIENT_VIRTUAL_ADDR_RESOURCES = UInt32(473);
      public const ERROR_INDEX_OUT_OF_BOUNDS = UInt32(474);
      public const ERROR_CLOUD_FILE_US_MESSAGE_TIMEOUT = UInt32(475);
      public const ERROR_PNP_QUERY_REMOVE_DEVICE_TIMEOUT = UInt32(480);
      public const ERROR_PNP_QUERY_REMOVE_RELATED_DEVICE_TIMEOUT = UInt32(481);
      public const ERROR_PNP_QUERY_REMOVE_UNRELATED_DEVICE_TIMEOUT = UInt32(482);
      public const ERROR_DEVICE_HARDWARE_ERROR = UInt32(483);
      public const ERROR_INVALID_ADDRESS = UInt32(487);
      public const ERROR_HAS_SYSTEM_CRITICAL_FILES = UInt32(488);
      public const ERROR_ENCRYPTED_FILE_NOT_SUPPORTED = UInt32(489);
      public const ERROR_SPARSE_FILE_NOT_SUPPORTED = UInt32(490);
      public const ERROR_PAGEFILE_NOT_SUPPORTED = UInt32(491);
      public const ERROR_VOLUME_NOT_SUPPORTED = UInt32(492);
      public const ERROR_NOT_SUPPORTED_WITH_BYPASSIO = UInt32(493);
      public const ERROR_NO_BYPASSIO_DRIVER_SUPPORT = UInt32(494);
      public const ERROR_NOT_SUPPORTED_WITH_ENCRYPTION = UInt32(495);
      public const ERROR_NOT_SUPPORTED_WITH_COMPRESSION = UInt32(496);
      public const ERROR_NOT_SUPPORTED_WITH_REPLICATION = UInt32(497);
      public const ERROR_NOT_SUPPORTED_WITH_DEDUPLICATION = UInt32(498);
      public const ERROR_NOT_SUPPORTED_WITH_AUDITING = UInt32(499);
      public const ERROR_USER_PROFILE_LOAD = UInt32(500);
      public const ERROR_SESSION_KEY_TOO_SHORT = UInt32(501);
      public const ERROR_ACCESS_DENIED_APPDATA = UInt32(502);
      public const ERROR_NOT_SUPPORTED_WITH_MONITORING = UInt32(503);
      public const ERROR_NOT_SUPPORTED_WITH_SNAPSHOT = UInt32(504);
      public const ERROR_NOT_SUPPORTED_WITH_VIRTUALIZATION = UInt32(505);
      public const ERROR_BYPASSIO_FLT_NOT_SUPPORTED = UInt32(506);
      public const ERROR_DEVICE_RESET_REQUIRED = UInt32(507);
      public const ERROR_VOLUME_WRITE_ACCESS_DENIED = UInt32(508);
      public const ERROR_NOT_SUPPORTED_WITH_CACHED_HANDLE = UInt32(509);
      public const ERROR_FS_METADATA_INCONSISTENT = UInt32(510);
      public const ERROR_BLOCK_WEAK_REFERENCE_INVALID = UInt32(511);
      public const ERROR_BLOCK_SOURCE_WEAK_REFERENCE_INVALID = UInt32(512);
      public const ERROR_BLOCK_TARGET_WEAK_REFERENCE_INVALID = UInt32(513);
      public const ERROR_BLOCK_SHARED = UInt32(514);
      public const ERROR_ARITHMETIC_OVERFLOW = UInt32(534);
      public const ERROR_PIPE_CONNECTED = UInt32(535);
      public const ERROR_PIPE_LISTENING = UInt32(536);
      public const ERROR_VERIFIER_STOP = UInt32(537);
      public const ERROR_ABIOS_ERROR = UInt32(538);
      public const ERROR_WX86_WARNING = UInt32(539);
      public const ERROR_WX86_ERROR = UInt32(540);
      public const ERROR_TIMER_NOT_CANCELED = UInt32(541);
      public const ERROR_UNWIND = UInt32(542);
      public const ERROR_BAD_STACK = UInt32(543);
      public const ERROR_INVALID_UNWIND_TARGET = UInt32(544);
      public const ERROR_INVALID_PORT_ATTRIBUTES = UInt32(545);
      public const ERROR_PORT_MESSAGE_TOO_LONG = UInt32(546);
      public const ERROR_INVALID_QUOTA_LOWER = UInt32(547);
      public const ERROR_DEVICE_ALREADY_ATTACHED = UInt32(548);
      public const ERROR_INSTRUCTION_MISALIGNMENT = UInt32(549);
      public const ERROR_PROFILING_NOT_STARTED = UInt32(550);
      public const ERROR_PROFILING_NOT_STOPPED = UInt32(551);
      public const ERROR_COULD_NOT_INTERPRET = UInt32(552);
      public const ERROR_PROFILING_AT_LIMIT = UInt32(553);
      public const ERROR_CANT_WAIT = UInt32(554);
      public const ERROR_CANT_TERMINATE_SELF = UInt32(555);
      public const ERROR_UNEXPECTED_MM_CREATE_ERR = UInt32(556);
      public const ERROR_UNEXPECTED_MM_MAP_ERROR = UInt32(557);
      public const ERROR_UNEXPECTED_MM_EXTEND_ERR = UInt32(558);
      public const ERROR_BAD_FUNCTION_TABLE = UInt32(559);
      public const ERROR_NO_GUID_TRANSLATION = UInt32(560);
      public const ERROR_INVALID_LDT_SIZE = UInt32(561);
      public const ERROR_INVALID_LDT_OFFSET = UInt32(563);
      public const ERROR_INVALID_LDT_DESCRIPTOR = UInt32(564);
      public const ERROR_TOO_MANY_THREADS = UInt32(565);
      public const ERROR_THREAD_NOT_IN_PROCESS = UInt32(566);
      public const ERROR_PAGEFILE_QUOTA_EXCEEDED = UInt32(567);
      public const ERROR_LOGON_SERVER_CONFLICT = UInt32(568);
      public const ERROR_SYNCHRONIZATION_REQUIRED = UInt32(569);
      public const ERROR_NET_OPEN_FAILED = UInt32(570);
      public const ERROR_IO_PRIVILEGE_FAILED = UInt32(571);
      public const ERROR_CONTROL_C_EXIT = UInt32(572);
      public const ERROR_MISSING_SYSTEMFILE = UInt32(573);
      public const ERROR_UNHANDLED_EXCEPTION = UInt32(574);
      public const ERROR_APP_INIT_FAILURE = UInt32(575);
      public const ERROR_PAGEFILE_CREATE_FAILED = UInt32(576);
      public const ERROR_INVALID_IMAGE_HASH = UInt32(577);
      public const ERROR_NO_PAGEFILE = UInt32(578);
      public const ERROR_ILLEGAL_FLOAT_CONTEXT = UInt32(579);
      public const ERROR_NO_EVENT_PAIR = UInt32(580);
      public const ERROR_DOMAIN_CTRLR_CONFIG_ERROR = UInt32(581);
      public const ERROR_ILLEGAL_CHARACTER = UInt32(582);
      public const ERROR_UNDEFINED_CHARACTER = UInt32(583);
      public const ERROR_FLOPPY_VOLUME = UInt32(584);
      public const ERROR_BIOS_FAILED_TO_CONNECT_INTERRUPT = UInt32(585);
      public const ERROR_BACKUP_CONTROLLER = UInt32(586);
      public const ERROR_MUTANT_LIMIT_EXCEEDED = UInt32(587);
      public const ERROR_FS_DRIVER_REQUIRED = UInt32(588);
      public const ERROR_CANNOT_LOAD_REGISTRY_FILE = UInt32(589);
      public const ERROR_DEBUG_ATTACH_FAILED = UInt32(590);
      public const ERROR_SYSTEM_PROCESS_TERMINATED = UInt32(591);
      public const ERROR_DATA_NOT_ACCEPTED = UInt32(592);
      public const ERROR_VDM_HARD_ERROR = UInt32(593);
      public const ERROR_DRIVER_CANCEL_TIMEOUT = UInt32(594);
      public const ERROR_REPLY_MESSAGE_MISMATCH = UInt32(595);
      public const ERROR_LOST_WRITEBEHIND_DATA = UInt32(596);
      public const ERROR_CLIENT_SERVER_PARAMETERS_INVALID = UInt32(597);
      public const ERROR_NOT_TINY_STREAM = UInt32(598);
      public const ERROR_STACK_OVERFLOW_READ = UInt32(599);
      public const ERROR_CONVERT_TO_LARGE = UInt32(600);
      public const ERROR_FOUND_OUT_OF_SCOPE = UInt32(601);
      public const ERROR_ALLOCATE_BUCKET = UInt32(602);
      public const ERROR_MARSHALL_OVERFLOW = UInt32(603);
      public const ERROR_INVALID_VARIANT = UInt32(604);
      public const ERROR_BAD_COMPRESSION_BUFFER = UInt32(605);
      public const ERROR_AUDIT_FAILED = UInt32(606);
      public const ERROR_TIMER_RESOLUTION_NOT_SET = UInt32(607);
      public const ERROR_INSUFFICIENT_LOGON_INFO = UInt32(608);
      public const ERROR_BAD_DLL_ENTRYPOINT = UInt32(609);
      public const ERROR_BAD_SERVICE_ENTRYPOINT = UInt32(610);
      public const ERROR_IP_ADDRESS_CONFLICT1 = UInt32(611);
      public const ERROR_IP_ADDRESS_CONFLICT2 = UInt32(612);
      public const ERROR_REGISTRY_QUOTA_LIMIT = UInt32(613);
      public const ERROR_NO_CALLBACK_ACTIVE = UInt32(614);
      public const ERROR_PWD_TOO_SHORT = UInt32(615);
      public const ERROR_PWD_TOO_RECENT = UInt32(616);
      public const ERROR_PWD_HISTORY_CONFLICT = UInt32(617);
      public const ERROR_UNSUPPORTED_COMPRESSION = UInt32(618);
      public const ERROR_INVALID_HW_PROFILE = UInt32(619);
      public const ERROR_INVALID_PLUGPLAY_DEVICE_PATH = UInt32(620);
      public const ERROR_QUOTA_LIST_INCONSISTENT = UInt32(621);
      public const ERROR_EVALUATION_EXPIRATION = UInt32(622);
      public const ERROR_ILLEGAL_DLL_RELOCATION = UInt32(623);
      public const ERROR_DLL_INIT_FAILED_LOGOFF = UInt32(624);
      public const ERROR_VALIDATE_CONTINUE = UInt32(625);
      public const ERROR_NO_MORE_MATCHES = UInt32(626);
      public const ERROR_RANGE_LIST_CONFLICT = UInt32(627);
      public const ERROR_SERVER_SID_MISMATCH = UInt32(628);
      public const ERROR_CANT_ENABLE_DENY_ONLY = UInt32(629);
      public const ERROR_FLOAT_MULTIPLE_FAULTS = UInt32(630);
      public const ERROR_FLOAT_MULTIPLE_TRAPS = UInt32(631);
      public const ERROR_NOINTERFACE = UInt32(632);
      public const ERROR_DRIVER_FAILED_SLEEP = UInt32(633);
      public const ERROR_CORRUPT_SYSTEM_FILE = UInt32(634);
      public const ERROR_COMMITMENT_MINIMUM = UInt32(635);
      public const ERROR_PNP_RESTART_ENUMERATION = UInt32(636);
      public const ERROR_SYSTEM_IMAGE_BAD_SIGNATURE = UInt32(637);
      public const ERROR_PNP_REBOOT_REQUIRED = UInt32(638);
      public const ERROR_INSUFFICIENT_POWER = UInt32(639);
      public const ERROR_MULTIPLE_FAULT_VIOLATION = UInt32(640);
      public const ERROR_SYSTEM_SHUTDOWN = UInt32(641);
      public const ERROR_PORT_NOT_SET = UInt32(642);
      public const ERROR_DS_VERSION_CHECK_FAILURE = UInt32(643);
      public const ERROR_RANGE_NOT_FOUND = UInt32(644);
      public const ERROR_NOT_SAFE_MODE_DRIVER = UInt32(646);
      public const ERROR_FAILED_DRIVER_ENTRY = UInt32(647);
      public const ERROR_DEVICE_ENUMERATION_ERROR = UInt32(648);
      public const ERROR_MOUNT_POINT_NOT_RESOLVED = UInt32(649);
      public const ERROR_INVALID_DEVICE_OBJECT_PARAMETER = UInt32(650);
      public const ERROR_MCA_OCCURED = UInt32(651);
      public const ERROR_DRIVER_DATABASE_ERROR = UInt32(652);
      public const ERROR_SYSTEM_HIVE_TOO_LARGE = UInt32(653);
      public const ERROR_DRIVER_FAILED_PRIOR_UNLOAD = UInt32(654);
      public const ERROR_VOLSNAP_PREPARE_HIBERNATE = UInt32(655);
      public const ERROR_HIBERNATION_FAILURE = UInt32(656);
      public const ERROR_PWD_TOO_LONG = UInt32(657);
      public const ERROR_FILE_SYSTEM_LIMITATION = UInt32(665);
      public const ERROR_ASSERTION_FAILURE = UInt32(668);
      public const ERROR_ACPI_ERROR = UInt32(669);
      public const ERROR_WOW_ASSERTION = UInt32(670);
      public const ERROR_PNP_BAD_MPS_TABLE = UInt32(671);
      public const ERROR_PNP_TRANSLATION_FAILED = UInt32(672);
      public const ERROR_PNP_IRQ_TRANSLATION_FAILED = UInt32(673);
      public const ERROR_PNP_INVALID_ID = UInt32(674);
      public const ERROR_WAKE_SYSTEM_DEBUGGER = UInt32(675);
      public const ERROR_HANDLES_CLOSED = UInt32(676);
      public const ERROR_EXTRANEOUS_INFORMATION = UInt32(677);
      public const ERROR_RXACT_COMMIT_NECESSARY = UInt32(678);
      public const ERROR_MEDIA_CHECK = UInt32(679);
      public const ERROR_GUID_SUBSTITUTION_MADE = UInt32(680);
      public const ERROR_STOPPED_ON_SYMLINK = UInt32(681);
      public const ERROR_LONGJUMP = UInt32(682);
      public const ERROR_PLUGPLAY_QUERY_VETOED = UInt32(683);
      public const ERROR_UNWIND_CONSOLIDATE = UInt32(684);
      public const ERROR_REGISTRY_HIVE_RECOVERED = UInt32(685);
      public const ERROR_DLL_MIGHT_BE_INSECURE = UInt32(686);
      public const ERROR_DLL_MIGHT_BE_INCOMPATIBLE = UInt32(687);
      public const ERROR_DBG_EXCEPTION_NOT_HANDLED = UInt32(688);
      public const ERROR_DBG_REPLY_LATER = UInt32(689);
      public const ERROR_DBG_UNABLE_TO_PROVIDE_HANDLE = UInt32(690);
      public const ERROR_DBG_TERMINATE_THREAD = UInt32(691);
      public const ERROR_DBG_TERMINATE_PROCESS = UInt32(692);
      public const ERROR_DBG_CONTROL_C = UInt32(693);
      public const ERROR_DBG_PRINTEXCEPTION_C = UInt32(694);
      public const ERROR_DBG_RIPEXCEPTION = UInt32(695);
      public const ERROR_DBG_CONTROL_BREAK = UInt32(696);
      public const ERROR_DBG_COMMAND_EXCEPTION = UInt32(697);
      public const ERROR_OBJECT_NAME_EXISTS = UInt32(698);
      public const ERROR_THREAD_WAS_SUSPENDED = UInt32(699);
      public const ERROR_IMAGE_NOT_AT_BASE = UInt32(700);
      public const ERROR_RXACT_STATE_CREATED = UInt32(701);
      public const ERROR_SEGMENT_NOTIFICATION = UInt32(702);
      public const ERROR_BAD_CURRENT_DIRECTORY = UInt32(703);
      public const ERROR_FT_READ_RECOVERY_FROM_BACKUP = UInt32(704);
      public const ERROR_FT_WRITE_RECOVERY = UInt32(705);
      public const ERROR_IMAGE_MACHINE_TYPE_MISMATCH = UInt32(706);
      public const ERROR_RECEIVE_PARTIAL = UInt32(707);
      public const ERROR_RECEIVE_EXPEDITED = UInt32(708);
      public const ERROR_RECEIVE_PARTIAL_EXPEDITED = UInt32(709);
      public const ERROR_EVENT_DONE = UInt32(710);
      public const ERROR_EVENT_PENDING = UInt32(711);
      public const ERROR_CHECKING_FILE_SYSTEM = UInt32(712);
      public const ERROR_FATAL_APP_EXIT = UInt32(713);
      public const ERROR_PREDEFINED_HANDLE = UInt32(714);
      public const ERROR_WAS_UNLOCKED = UInt32(715);
      public const ERROR_SERVICE_NOTIFICATION = UInt32(716);
      public const ERROR_WAS_LOCKED = UInt32(717);
      public const ERROR_LOG_HARD_ERROR = UInt32(718);
      public const ERROR_ALREADY_WIN32 = UInt32(719);
      public const ERROR_IMAGE_MACHINE_TYPE_MISMATCH_EXE = UInt32(720);
      public const ERROR_NO_YIELD_PERFORMED = UInt32(721);
      public const ERROR_TIMER_RESUME_IGNORED = UInt32(722);
      public const ERROR_ARBITRATION_UNHANDLED = UInt32(723);
      public const ERROR_CARDBUS_NOT_SUPPORTED = UInt32(724);
      public const ERROR_MP_PROCESSOR_MISMATCH = UInt32(725);
      public const ERROR_HIBERNATED = UInt32(726);
      public const ERROR_RESUME_HIBERNATION = UInt32(727);
      public const ERROR_FIRMWARE_UPDATED = UInt32(728);
      public const ERROR_DRIVERS_LEAKING_LOCKED_PAGES = UInt32(729);
      public const ERROR_WAKE_SYSTEM = UInt32(730);
      public const ERROR_WAIT_1 = UInt32(731);
      public const ERROR_WAIT_2 = UInt32(732);
      public const ERROR_WAIT_3 = UInt32(733);
      public const ERROR_WAIT_63 = UInt32(734);
      public const ERROR_ABANDONED_WAIT_0 = UInt32(735);
      public const ERROR_ABANDONED_WAIT_63 = UInt32(736);
      public const ERROR_USER_APC = UInt32(737);
      public const ERROR_KERNEL_APC = UInt32(738);
      public const ERROR_ALERTED = UInt32(739);
      public const ERROR_ELEVATION_REQUIRED = UInt32(740);
      public const ERROR_REPARSE = UInt32(741);
      public const ERROR_OPLOCK_BREAK_IN_PROGRESS = UInt32(742);
      public const ERROR_VOLUME_MOUNTED = UInt32(743);
      public const ERROR_RXACT_COMMITTED = UInt32(744);
      public const ERROR_NOTIFY_CLEANUP = UInt32(745);
      public const ERROR_PRIMARY_TRANSPORT_CONNECT_FAILED = UInt32(746);
      public const ERROR_PAGE_FAULT_TRANSITION = UInt32(747);
      public const ERROR_PAGE_FAULT_DEMAND_ZERO = UInt32(748);
      public const ERROR_PAGE_FAULT_COPY_ON_WRITE = UInt32(749);
      public const ERROR_PAGE_FAULT_GUARD_PAGE = UInt32(750);
      public const ERROR_PAGE_FAULT_PAGING_FILE = UInt32(751);
      public const ERROR_CACHE_PAGE_LOCKED = UInt32(752);
      public const ERROR_CRASH_DUMP = UInt32(753);
      public const ERROR_BUFFER_ALL_ZEROS = UInt32(754);
      public const ERROR_REPARSE_OBJECT = UInt32(755);
      public const ERROR_RESOURCE_REQUIREMENTS_CHANGED = UInt32(756);
      public const ERROR_TRANSLATION_COMPLETE = UInt32(757);
      public const ERROR_NOTHING_TO_TERMINATE = UInt32(758);
      public const ERROR_PROCESS_NOT_IN_JOB = UInt32(759);
      public const ERROR_PROCESS_IN_JOB = UInt32(760);
      public const ERROR_VOLSNAP_HIBERNATE_READY = UInt32(761);
      public const ERROR_FSFILTER_OP_COMPLETED_SUCCESSFULLY = UInt32(762);
      public const ERROR_INTERRUPT_VECTOR_ALREADY_CONNECTED = UInt32(763);
      public const ERROR_INTERRUPT_STILL_CONNECTED = UInt32(764);
      public const ERROR_WAIT_FOR_OPLOCK = UInt32(765);
      public const ERROR_DBG_EXCEPTION_HANDLED = UInt32(766);
      public const ERROR_DBG_CONTINUE = UInt32(767);
      public const ERROR_CALLBACK_POP_STACK = UInt32(768);
      public const ERROR_COMPRESSION_DISABLED = UInt32(769);
      public const ERROR_CANTFETCHBACKWARDS = UInt32(770);
      public const ERROR_CANTSCROLLBACKWARDS = UInt32(771);
      public const ERROR_ROWSNOTRELEASED = UInt32(772);
      public const ERROR_BAD_ACCESSOR_FLAGS = UInt32(773);
      public const ERROR_ERRORS_ENCOUNTERED = UInt32(774);
      public const ERROR_NOT_CAPABLE = UInt32(775);
      public const ERROR_REQUEST_OUT_OF_SEQUENCE = UInt32(776);
      public const ERROR_VERSION_PARSE_ERROR = UInt32(777);
      public const ERROR_BADSTARTPOSITION = UInt32(778);
      public const ERROR_MEMORY_HARDWARE = UInt32(779);
      public const ERROR_DISK_REPAIR_DISABLED = UInt32(780);
      public const ERROR_INSUFFICIENT_RESOURCE_FOR_SPECIFIED_SHARED_SECTION_SIZE = UInt32(781);
      public const ERROR_SYSTEM_POWERSTATE_TRANSITION = UInt32(782);
      public const ERROR_SYSTEM_POWERSTATE_COMPLEX_TRANSITION = UInt32(783);
      public const ERROR_MCA_EXCEPTION = UInt32(784);
      public const ERROR_ACCESS_AUDIT_BY_POLICY = UInt32(785);
      public const ERROR_ACCESS_DISABLED_NO_SAFER_UI_BY_POLICY = UInt32(786);
      public const ERROR_ABANDON_HIBERFILE = UInt32(787);
      public const ERROR_LOST_WRITEBEHIND_DATA_NETWORK_DISCONNECTED = UInt32(788);
      public const ERROR_LOST_WRITEBEHIND_DATA_NETWORK_SERVER_ERROR = UInt32(789);
      public const ERROR_LOST_WRITEBEHIND_DATA_LOCAL_DISK_ERROR = UInt32(790);
      public const ERROR_BAD_MCFG_TABLE = UInt32(791);
      public const ERROR_DISK_REPAIR_REDIRECTED = UInt32(792);
      public const ERROR_DISK_REPAIR_UNSUCCESSFUL = UInt32(793);
      public const ERROR_CORRUPT_LOG_OVERFULL = UInt32(794);
      public const ERROR_CORRUPT_LOG_CORRUPTED = UInt32(795);
      public const ERROR_CORRUPT_LOG_UNAVAILABLE = UInt32(796);
      public const ERROR_CORRUPT_LOG_DELETED_FULL = UInt32(797);
      public const ERROR_CORRUPT_LOG_CLEARED = UInt32(798);
      public const ERROR_ORPHAN_NAME_EXHAUSTED = UInt32(799);
      public const ERROR_OPLOCK_SWITCHED_TO_NEW_HANDLE = UInt32(800);
      public const ERROR_CANNOT_GRANT_REQUESTED_OPLOCK = UInt32(801);
      public const ERROR_CANNOT_BREAK_OPLOCK = UInt32(802);
      public const ERROR_OPLOCK_HANDLE_CLOSED = UInt32(803);
      public const ERROR_NO_ACE_CONDITION = UInt32(804);
      public const ERROR_INVALID_ACE_CONDITION = UInt32(805);
      public const ERROR_FILE_HANDLE_REVOKED = UInt32(806);
      public const ERROR_IMAGE_AT_DIFFERENT_BASE = UInt32(807);
      public const ERROR_ENCRYPTED_IO_NOT_POSSIBLE = UInt32(808);
      public const ERROR_FILE_METADATA_OPTIMIZATION_IN_PROGRESS = UInt32(809);
      public const ERROR_QUOTA_ACTIVITY = UInt32(810);
      public const ERROR_HANDLE_REVOKED = UInt32(811);
      public const ERROR_CALLBACK_INVOKE_INLINE = UInt32(812);
      public const ERROR_CPU_SET_INVALID = UInt32(813);
      public const ERROR_ENCLAVE_NOT_TERMINATED = UInt32(814);
      public const ERROR_ENCLAVE_VIOLATION = UInt32(815);
      public const ERROR_SERVER_TRANSPORT_CONFLICT = UInt32(816);
      public const ERROR_CERTIFICATE_VALIDATION_PREFERENCE_CONFLICT = UInt32(817);
      public const ERROR_FT_READ_FROM_COPY_FAILURE = UInt32(818);
      public const ERROR_SECTION_DIRECT_MAP_ONLY = UInt32(819);
      public const ERROR_EA_ACCESS_DENIED = UInt32(994);
      public const ERROR_OPERATION_ABORTED = UInt32(995);
      public const ERROR_IO_INCOMPLETE = UInt32(996);
      public const ERROR_IO_PENDING = UInt32(997);
      public const ERROR_NOACCESS = UInt32(998);
      public const ERROR_SWAPERROR = UInt32(999);
      public const ERROR_STACK_OVERFLOW = UInt32(1001);
      public const ERROR_INVALID_MESSAGE = UInt32(1002);
      public const ERROR_CAN_NOT_COMPLETE = UInt32(1003);
      public const ERROR_INVALID_FLAGS = UInt32(1004);
      public const ERROR_UNRECOGNIZED_VOLUME = UInt32(1005);
      public const ERROR_FILE_INVALID = UInt32(1006);
      public const ERROR_FULLSCREEN_MODE = UInt32(1007);
      public const ERROR_NO_TOKEN = UInt32(1008);
      public const ERROR_BADDB = UInt32(1009);
      public const ERROR_BADKEY = UInt32(1010);
      public const ERROR_CANTOPEN = UInt32(1011);
      public const ERROR_CANTREAD = UInt32(1012);
      public const ERROR_CANTWRITE = UInt32(1013);
      public const ERROR_REGISTRY_RECOVERED = UInt32(1014);
      public const ERROR_REGISTRY_CORRUPT = UInt32(1015);
      public const ERROR_REGISTRY_IO_FAILED = UInt32(1016);
      public const ERROR_NOT_REGISTRY_FILE = UInt32(1017);
      public const ERROR_KEY_DELETED = UInt32(1018);
      public const ERROR_NO_LOG_SPACE = UInt32(1019);
      public const ERROR_KEY_HAS_CHILDREN = UInt32(1020);
      public const ERROR_CHILD_MUST_BE_VOLATILE = UInt32(1021);
      public const ERROR_NOTIFY_ENUM_DIR = UInt32(1022);
      public const ERROR_DEPENDENT_SERVICES_RUNNING = UInt32(1051);
      public const ERROR_INVALID_SERVICE_CONTROL = UInt32(1052);
      public const ERROR_SERVICE_REQUEST_TIMEOUT = UInt32(1053);
      public const ERROR_SERVICE_NO_THREAD = UInt32(1054);
      public const ERROR_SERVICE_DATABASE_LOCKED = UInt32(1055);
      public const ERROR_SERVICE_ALREADY_RUNNING = UInt32(1056);
      public const ERROR_INVALID_SERVICE_ACCOUNT = UInt32(1057);
      public const ERROR_SERVICE_DISABLED = UInt32(1058);
      public const ERROR_CIRCULAR_DEPENDENCY = UInt32(1059);
      public const ERROR_SERVICE_DOES_NOT_EXIST = UInt32(1060);
      public const ERROR_SERVICE_CANNOT_ACCEPT_CTRL = UInt32(1061);
      public const ERROR_SERVICE_NOT_ACTIVE = UInt32(1062);
      public const ERROR_FAILED_SERVICE_CONTROLLER_CONNECT = UInt32(1063);
      public const ERROR_EXCEPTION_IN_SERVICE = UInt32(1064);
      public const ERROR_DATABASE_DOES_NOT_EXIST = UInt32(1065);
      public const ERROR_SERVICE_SPECIFIC_ERROR = UInt32(1066);
      public const ERROR_PROCESS_ABORTED = UInt32(1067);
      public const ERROR_SERVICE_DEPENDENCY_FAIL = UInt32(1068);
      public const ERROR_SERVICE_LOGON_FAILED = UInt32(1069);
      public const ERROR_SERVICE_START_HANG = UInt32(1070);
      public const ERROR_INVALID_SERVICE_LOCK = UInt32(1071);
      public const ERROR_SERVICE_MARKED_FOR_DELETE = UInt32(1072);
      public const ERROR_SERVICE_EXISTS = UInt32(1073);
      public const ERROR_ALREADY_RUNNING_LKG = UInt32(1074);
      public const ERROR_SERVICE_DEPENDENCY_DELETED = UInt32(1075);
      public const ERROR_BOOT_ALREADY_ACCEPTED = UInt32(1076);
      public const ERROR_SERVICE_NEVER_STARTED = UInt32(1077);
      public const ERROR_DUPLICATE_SERVICE_NAME = UInt32(1078);
      public const ERROR_DIFFERENT_SERVICE_ACCOUNT = UInt32(1079);
      public const ERROR_CANNOT_DETECT_DRIVER_FAILURE = UInt32(1080);
      public const ERROR_CANNOT_DETECT_PROCESS_ABORT = UInt32(1081);
      public const ERROR_NO_RECOVERY_PROGRAM = UInt32(1082);
      public const ERROR_SERVICE_NOT_IN_EXE = UInt32(1083);
      public const ERROR_NOT_SAFEBOOT_SERVICE = UInt32(1084);
      public const ERROR_END_OF_MEDIA = UInt32(1100);
      public const ERROR_FILEMARK_DETECTED = UInt32(1101);
      public const ERROR_BEGINNING_OF_MEDIA = UInt32(1102);
      public const ERROR_SETMARK_DETECTED = UInt32(1103);
      public const ERROR_NO_DATA_DETECTED = UInt32(1104);
      public const ERROR_PARTITION_FAILURE = UInt32(1105);
      public const ERROR_INVALID_BLOCK_LENGTH = UInt32(1106);
      public const ERROR_DEVICE_NOT_PARTITIONED = UInt32(1107);
      public const ERROR_UNABLE_TO_LOCK_MEDIA = UInt32(1108);
      public const ERROR_UNABLE_TO_UNLOAD_MEDIA = UInt32(1109);
      public const ERROR_MEDIA_CHANGED = UInt32(1110);
      public const ERROR_BUS_RESET = UInt32(1111);
      public const ERROR_NO_MEDIA_IN_DRIVE = UInt32(1112);
      public const ERROR_NO_UNICODE_TRANSLATION = UInt32(1113);
      public const ERROR_DLL_INIT_FAILED = UInt32(1114);
      public const ERROR_SHUTDOWN_IN_PROGRESS = UInt32(1115);
      public const ERROR_NO_SHUTDOWN_IN_PROGRESS = UInt32(1116);
      public const ERROR_IO_DEVICE = UInt32(1117);
      public const ERROR_SERIAL_NO_DEVICE = UInt32(1118);
      public const ERROR_IRQ_BUSY = UInt32(1119);
      public const ERROR_MORE_WRITES = UInt32(1120);
      public const ERROR_COUNTER_TIMEOUT = UInt32(1121);
      public const ERROR_FLOPPY_ID_MARK_NOT_FOUND = UInt32(1122);
      public const ERROR_FLOPPY_WRONG_CYLINDER = UInt32(1123);
      public const ERROR_FLOPPY_UNKNOWN_ERROR = UInt32(1124);
      public const ERROR_FLOPPY_BAD_REGISTERS = UInt32(1125);
      public const ERROR_DISK_RECALIBRATE_FAILED = UInt32(1126);
      public const ERROR_DISK_OPERATION_FAILED = UInt32(1127);
      public const ERROR_DISK_RESET_FAILED = UInt32(1128);
      public const ERROR_EOM_OVERFLOW = UInt32(1129);
      public const ERROR_NOT_ENOUGH_SERVER_MEMORY = UInt32(1130);
      public const ERROR_POSSIBLE_DEADLOCK = UInt32(1131);
      public const ERROR_MAPPED_ALIGNMENT = UInt32(1132);
      public const ERROR_SET_POWER_STATE_VETOED = UInt32(1140);
      public const ERROR_SET_POWER_STATE_FAILED = UInt32(1141);
      public const ERROR_TOO_MANY_LINKS = UInt32(1142);
      public const ERROR_OLD_WIN_VERSION = UInt32(1150);
      public const ERROR_APP_WRONG_OS = UInt32(1151);
      public const ERROR_SINGLE_INSTANCE_APP = UInt32(1152);
      public const ERROR_RMODE_APP = UInt32(1153);
      public const ERROR_INVALID_DLL = UInt32(1154);
      public const ERROR_NO_ASSOCIATION = UInt32(1155);
      public const ERROR_DDE_FAIL = UInt32(1156);
      public const ERROR_DLL_NOT_FOUND = UInt32(1157);
      public const ERROR_NO_MORE_USER_HANDLES = UInt32(1158);
      public const ERROR_MESSAGE_SYNC_ONLY = UInt32(1159);
      public const ERROR_SOURCE_ELEMENT_EMPTY = UInt32(1160);
      public const ERROR_DESTINATION_ELEMENT_FULL = UInt32(1161);
      public const ERROR_ILLEGAL_ELEMENT_ADDRESS = UInt32(1162);
      public const ERROR_MAGAZINE_NOT_PRESENT = UInt32(1163);
      public const ERROR_DEVICE_REINITIALIZATION_NEEDED = UInt32(1164);
      public const ERROR_DEVICE_REQUIRES_CLEANING = UInt32(1165);
      public const ERROR_DEVICE_DOOR_OPEN = UInt32(1166);
      public const ERROR_DEVICE_NOT_CONNECTED = UInt32(1167);
      public const ERROR_NOT_FOUND = UInt32(1168);
      public const ERROR_NO_MATCH = UInt32(1169);
      public const ERROR_SET_NOT_FOUND = UInt32(1170);
      public const ERROR_POINT_NOT_FOUND = UInt32(1171);
      public const ERROR_NO_TRACKING_SERVICE = UInt32(1172);
      public const ERROR_NO_VOLUME_ID = UInt32(1173);
      public const ERROR_UNABLE_TO_REMOVE_REPLACED = UInt32(1175);
      public const ERROR_UNABLE_TO_MOVE_REPLACEMENT = UInt32(1176);
      public const ERROR_UNABLE_TO_MOVE_REPLACEMENT_2 = UInt32(1177);
      public const ERROR_JOURNAL_DELETE_IN_PROGRESS = UInt32(1178);
      public const ERROR_JOURNAL_NOT_ACTIVE = UInt32(1179);
      public const ERROR_POTENTIAL_FILE_FOUND = UInt32(1180);
      public const ERROR_JOURNAL_ENTRY_DELETED = UInt32(1181);
      public const ERROR_PARTITION_TERMINATING = UInt32(1184);
      public const ERROR_SHUTDOWN_IS_SCHEDULED = UInt32(1190);
      public const ERROR_SHUTDOWN_USERS_LOGGED_ON = UInt32(1191);
      public const ERROR_SHUTDOWN_DISKS_NOT_IN_MAINTENANCE_MODE = UInt32(1192);
      public const ERROR_BAD_DEVICE = UInt32(1200);
      public const ERROR_CONNECTION_UNAVAIL = UInt32(1201);
      public const ERROR_DEVICE_ALREADY_REMEMBERED = UInt32(1202);
      public const ERROR_NO_NET_OR_BAD_PATH = UInt32(1203);
      public const ERROR_BAD_PROVIDER = UInt32(1204);
      public const ERROR_CANNOT_OPEN_PROFILE = UInt32(1205);
      public const ERROR_BAD_PROFILE = UInt32(1206);
      public const ERROR_NOT_CONTAINER = UInt32(1207);
      public const ERROR_EXTENDED_ERROR = UInt32(1208);
      public const ERROR_INVALID_GROUPNAME = UInt32(1209);
      public const ERROR_INVALID_COMPUTERNAME = UInt32(1210);
      public const ERROR_INVALID_EVENTNAME = UInt32(1211);
      public const ERROR_INVALID_DOMAINNAME = UInt32(1212);
      public const ERROR_INVALID_SERVICENAME = UInt32(1213);
      public const ERROR_INVALID_NETNAME = UInt32(1214);
      public const ERROR_INVALID_SHARENAME = UInt32(1215);
      public const ERROR_INVALID_PASSWORDNAME = UInt32(1216);
      public const ERROR_INVALID_MESSAGENAME = UInt32(1217);
      public const ERROR_INVALID_MESSAGEDEST = UInt32(1218);
      public const ERROR_SESSION_CREDENTIAL_CONFLICT = UInt32(1219);
      public const ERROR_REMOTE_SESSION_LIMIT_EXCEEDED = UInt32(1220);
      public const ERROR_DUP_DOMAINNAME = UInt32(1221);
      public const ERROR_NO_NETWORK = UInt32(1222);
      public const ERROR_CANCELLED = UInt32(1223);
      public const ERROR_USER_MAPPED_FILE = UInt32(1224);
      public const ERROR_CONNECTION_REFUSED = UInt32(1225);
      public const ERROR_GRACEFUL_DISCONNECT = UInt32(1226);
      public const ERROR_ADDRESS_ALREADY_ASSOCIATED = UInt32(1227);
      public const ERROR_ADDRESS_NOT_ASSOCIATED = UInt32(1228);
      public const ERROR_CONNECTION_INVALID = UInt32(1229);
      public const ERROR_CONNECTION_ACTIVE = UInt32(1230);
      public const ERROR_NETWORK_UNREACHABLE = UInt32(1231);
      public const ERROR_HOST_UNREACHABLE = UInt32(1232);
      public const ERROR_PROTOCOL_UNREACHABLE = UInt32(1233);
      public const ERROR_PORT_UNREACHABLE = UInt32(1234);
      public const ERROR_REQUEST_ABORTED = UInt32(1235);
      public const ERROR_CONNECTION_ABORTED = UInt32(1236);
      public const ERROR_RETRY = UInt32(1237);
      public const ERROR_CONNECTION_COUNT_LIMIT = UInt32(1238);
      public const ERROR_LOGIN_TIME_RESTRICTION = UInt32(1239);
      public const ERROR_LOGIN_WKSTA_RESTRICTION = UInt32(1240);
      public const ERROR_INCORRECT_ADDRESS = UInt32(1241);
      public const ERROR_ALREADY_REGISTERED = UInt32(1242);
      public const ERROR_SERVICE_NOT_FOUND = UInt32(1243);
      public const ERROR_NOT_AUTHENTICATED = UInt32(1244);
      public const ERROR_NOT_LOGGED_ON = UInt32(1245);
      public const ERROR_CONTINUE = UInt32(1246);
      public const ERROR_ALREADY_INITIALIZED = UInt32(1247);
      public const ERROR_NO_MORE_DEVICES = UInt32(1248);
      public const ERROR_NO_SUCH_SITE = UInt32(1249);
      public const ERROR_DOMAIN_CONTROLLER_EXISTS = UInt32(1250);
      public const ERROR_ONLY_IF_CONNECTED = UInt32(1251);
      public const ERROR_OVERRIDE_NOCHANGES = UInt32(1252);
      public const ERROR_BAD_USER_PROFILE = UInt32(1253);
      public const ERROR_NOT_SUPPORTED_ON_SBS = UInt32(1254);
      public const ERROR_SERVER_SHUTDOWN_IN_PROGRESS = UInt32(1255);
      public const ERROR_HOST_DOWN = UInt32(1256);
      public const ERROR_NON_ACCOUNT_SID = UInt32(1257);
      public const ERROR_NON_DOMAIN_SID = UInt32(1258);
      public const ERROR_APPHELP_BLOCK = UInt32(1259);
      public const ERROR_ACCESS_DISABLED_BY_POLICY = UInt32(1260);
      public const ERROR_REG_NAT_CONSUMPTION = UInt32(1261);
      public const ERROR_CSCSHARE_OFFLINE = UInt32(1262);
      public const ERROR_PKINIT_FAILURE = UInt32(1263);
      public const ERROR_SMARTCARD_SUBSYSTEM_FAILURE = UInt32(1264);
      public const ERROR_DOWNGRADE_DETECTED = UInt32(1265);
      public const ERROR_MACHINE_LOCKED = UInt32(1271);
      public const ERROR_SMB_GUEST_LOGON_BLOCKED = UInt32(1272);
      public const ERROR_CALLBACK_SUPPLIED_INVALID_DATA = UInt32(1273);
      public const ERROR_SYNC_FOREGROUND_REFRESH_REQUIRED = UInt32(1274);
      public const ERROR_DRIVER_BLOCKED = UInt32(1275);
      public const ERROR_INVALID_IMPORT_OF_NON_DLL = UInt32(1276);
      public const ERROR_ACCESS_DISABLED_WEBBLADE = UInt32(1277);
      public const ERROR_ACCESS_DISABLED_WEBBLADE_TAMPER = UInt32(1278);
      public const ERROR_RECOVERY_FAILURE = UInt32(1279);
      public const ERROR_ALREADY_FIBER = UInt32(1280);
      public const ERROR_ALREADY_THREAD = UInt32(1281);
      public const ERROR_STACK_BUFFER_OVERRUN = UInt32(1282);
      public const ERROR_PARAMETER_QUOTA_EXCEEDED = UInt32(1283);
      public const ERROR_DEBUGGER_INACTIVE = UInt32(1284);
      public const ERROR_DELAY_LOAD_FAILED = UInt32(1285);
      public const ERROR_VDM_DISALLOWED = UInt32(1286);
      public const ERROR_UNIDENTIFIED_ERROR = UInt32(1287);
      public const ERROR_INVALID_CRUNTIME_PARAMETER = UInt32(1288);
      public const ERROR_BEYOND_VDL = UInt32(1289);
      public const ERROR_INCOMPATIBLE_SERVICE_SID_TYPE = UInt32(1290);
      public const ERROR_DRIVER_PROCESS_TERMINATED = UInt32(1291);
      public const ERROR_IMPLEMENTATION_LIMIT = UInt32(1292);
      public const ERROR_PROCESS_IS_PROTECTED = UInt32(1293);
      public const ERROR_SERVICE_NOTIFY_CLIENT_LAGGING = UInt32(1294);
      public const ERROR_DISK_QUOTA_EXCEEDED = UInt32(1295);
      public const ERROR_CONTENT_BLOCKED = UInt32(1296);
      public const ERROR_INCOMPATIBLE_SERVICE_PRIVILEGE = UInt32(1297);
      public const ERROR_APP_HANG = UInt32(1298);
      public const ERROR_INVALID_LABEL = UInt32(1299);
      public const ERROR_NOT_ALL_ASSIGNED = UInt32(1300);
      public const ERROR_SOME_NOT_MAPPED = UInt32(1301);
      public const ERROR_NO_QUOTAS_FOR_ACCOUNT = UInt32(1302);
      public const ERROR_LOCAL_USER_SESSION_KEY = UInt32(1303);
      public const ERROR_NULL_LM_PASSWORD = UInt32(1304);
      public const ERROR_UNKNOWN_REVISION = UInt32(1305);
      public const ERROR_REVISION_MISMATCH = UInt32(1306);
      public const ERROR_INVALID_OWNER = UInt32(1307);
      public const ERROR_INVALID_PRIMARY_GROUP = UInt32(1308);
      public const ERROR_NO_IMPERSONATION_TOKEN = UInt32(1309);
      public const ERROR_CANT_DISABLE_MANDATORY = UInt32(1310);
      public const ERROR_NO_LOGON_SERVERS = UInt32(1311);
      public const ERROR_NO_SUCH_LOGON_SESSION = UInt32(1312);
      public const ERROR_NO_SUCH_PRIVILEGE = UInt32(1313);
      public const ERROR_PRIVILEGE_NOT_HELD = UInt32(1314);
      public const ERROR_INVALID_ACCOUNT_NAME = UInt32(1315);
      public const ERROR_USER_EXISTS = UInt32(1316);
      public const ERROR_NO_SUCH_USER = UInt32(1317);
      public const ERROR_GROUP_EXISTS = UInt32(1318);
      public const ERROR_NO_SUCH_GROUP = UInt32(1319);
      public const ERROR_MEMBER_IN_GROUP = UInt32(1320);
      public const ERROR_MEMBER_NOT_IN_GROUP = UInt32(1321);
      public const ERROR_LAST_ADMIN = UInt32(1322);
      public const ERROR_WRONG_PASSWORD = UInt32(1323);
      public const ERROR_ILL_FORMED_PASSWORD = UInt32(1324);
      public const ERROR_PASSWORD_RESTRICTION = UInt32(1325);
      public const ERROR_LOGON_FAILURE = UInt32(1326);
      public const ERROR_ACCOUNT_RESTRICTION = UInt32(1327);
      public const ERROR_INVALID_LOGON_HOURS = UInt32(1328);
      public const ERROR_INVALID_WORKSTATION = UInt32(1329);
      public const ERROR_PASSWORD_EXPIRED = UInt32(1330);
      public const ERROR_ACCOUNT_DISABLED = UInt32(1331);
      public const ERROR_NONE_MAPPED = UInt32(1332);
      public const ERROR_TOO_MANY_LUIDS_REQUESTED = UInt32(1333);
      public const ERROR_LUIDS_EXHAUSTED = UInt32(1334);
      public const ERROR_INVALID_SUB_AUTHORITY = UInt32(1335);
      public const ERROR_INVALID_ACL = UInt32(1336);
      public const ERROR_INVALID_SID = UInt32(1337);
      public const ERROR_INVALID_SECURITY_DESCR = UInt32(1338);
      public const ERROR_BAD_INHERITANCE_ACL = UInt32(1340);
      public const ERROR_SERVER_DISABLED = UInt32(1341);
      public const ERROR_SERVER_NOT_DISABLED = UInt32(1342);
      public const ERROR_INVALID_ID_AUTHORITY = UInt32(1343);
      public const ERROR_ALLOTTED_SPACE_EXCEEDED = UInt32(1344);
      public const ERROR_INVALID_GROUP_ATTRIBUTES = UInt32(1345);
      public const ERROR_BAD_IMPERSONATION_LEVEL = UInt32(1346);
      public const ERROR_CANT_OPEN_ANONYMOUS = UInt32(1347);
      public const ERROR_BAD_VALIDATION_CLASS = UInt32(1348);
      public const ERROR_BAD_TOKEN_TYPE = UInt32(1349);
      public const ERROR_NO_SECURITY_ON_OBJECT = UInt32(1350);
      public const ERROR_CANT_ACCESS_DOMAIN_INFO = UInt32(1351);
      public const ERROR_INVALID_SERVER_STATE = UInt32(1352);
      public const ERROR_INVALID_DOMAIN_STATE = UInt32(1353);
      public const ERROR_INVALID_DOMAIN_ROLE = UInt32(1354);
      public const ERROR_NO_SUCH_DOMAIN = UInt32(1355);
      public const ERROR_DOMAIN_EXISTS = UInt32(1356);
      public const ERROR_DOMAIN_LIMIT_EXCEEDED = UInt32(1357);
      public const ERROR_INTERNAL_DB_CORRUPTION = UInt32(1358);
      public const ERROR_INTERNAL_ERROR = UInt32(1359);
      public const ERROR_GENERIC_NOT_MAPPED = UInt32(1360);
      public const ERROR_BAD_DESCRIPTOR_FORMAT = UInt32(1361);
      public const ERROR_NOT_LOGON_PROCESS = UInt32(1362);
      public const ERROR_LOGON_SESSION_EXISTS = UInt32(1363);
      public const ERROR_NO_SUCH_PACKAGE = UInt32(1364);
      public const ERROR_BAD_LOGON_SESSION_STATE = UInt32(1365);
      public const ERROR_LOGON_SESSION_COLLISION = UInt32(1366);
      public const ERROR_INVALID_LOGON_TYPE = UInt32(1367);
      public const ERROR_CANNOT_IMPERSONATE = UInt32(1368);
      public const ERROR_RXACT_INVALID_STATE = UInt32(1369);
      public const ERROR_RXACT_COMMIT_FAILURE = UInt32(1370);
      public const ERROR_SPECIAL_ACCOUNT = UInt32(1371);
      public const ERROR_SPECIAL_GROUP = UInt32(1372);
      public const ERROR_SPECIAL_USER = UInt32(1373);
      public const ERROR_MEMBERS_PRIMARY_GROUP = UInt32(1374);
      public const ERROR_TOKEN_ALREADY_IN_USE = UInt32(1375);
      public const ERROR_NO_SUCH_ALIAS = UInt32(1376);
      public const ERROR_MEMBER_NOT_IN_ALIAS = UInt32(1377);
      public const ERROR_MEMBER_IN_ALIAS = UInt32(1378);
      public const ERROR_ALIAS_EXISTS = UInt32(1379);
      public const ERROR_LOGON_NOT_GRANTED = UInt32(1380);
      public const ERROR_TOO_MANY_SECRETS = UInt32(1381);
      public const ERROR_SECRET_TOO_LONG = UInt32(1382);
      public const ERROR_INTERNAL_DB_ERROR = UInt32(1383);
      public const ERROR_TOO_MANY_CONTEXT_IDS = UInt32(1384);
      public const ERROR_LOGON_TYPE_NOT_GRANTED = UInt32(1385);
      public const ERROR_NT_CROSS_ENCRYPTION_REQUIRED = UInt32(1386);
      public const ERROR_NO_SUCH_MEMBER = UInt32(1387);
      public const ERROR_INVALID_MEMBER = UInt32(1388);
      public const ERROR_TOO_MANY_SIDS = UInt32(1389);
      public const ERROR_LM_CROSS_ENCRYPTION_REQUIRED = UInt32(1390);
      public const ERROR_NO_INHERITANCE = UInt32(1391);
      public const ERROR_FILE_CORRUPT = UInt32(1392);
      public const ERROR_DISK_CORRUPT = UInt32(1393);
      public const ERROR_NO_USER_SESSION_KEY = UInt32(1394);
      public const ERROR_LICENSE_QUOTA_EXCEEDED = UInt32(1395);
      public const ERROR_WRONG_TARGET_NAME = UInt32(1396);
      public const ERROR_MUTUAL_AUTH_FAILED = UInt32(1397);
      public const ERROR_TIME_SKEW = UInt32(1398);
      public const ERROR_CURRENT_DOMAIN_NOT_ALLOWED = UInt32(1399);
      public const ERROR_INVALID_WINDOW_HANDLE = UInt32(1400);
      public const ERROR_INVALID_MENU_HANDLE = UInt32(1401);
      public const ERROR_INVALID_CURSOR_HANDLE = UInt32(1402);
      public const ERROR_INVALID_ACCEL_HANDLE = UInt32(1403);
      public const ERROR_INVALID_HOOK_HANDLE = UInt32(1404);
      public const ERROR_INVALID_DWP_HANDLE = UInt32(1405);
      public const ERROR_TLW_WITH_WSCHILD = UInt32(1406);
      public const ERROR_CANNOT_FIND_WND_CLASS = UInt32(1407);
      public const ERROR_WINDOW_OF_OTHER_THREAD = UInt32(1408);
      public const ERROR_HOTKEY_ALREADY_REGISTERED = UInt32(1409);
      public const ERROR_CLASS_ALREADY_EXISTS = UInt32(1410);
      public const ERROR_CLASS_DOES_NOT_EXIST = UInt32(1411);
      public const ERROR_CLASS_HAS_WINDOWS = UInt32(1412);
      public const ERROR_INVALID_INDEX = UInt32(1413);
      public const ERROR_INVALID_ICON_HANDLE = UInt32(1414);
      public const ERROR_PRIVATE_DIALOG_INDEX = UInt32(1415);
      public const ERROR_LISTBOX_ID_NOT_FOUND = UInt32(1416);
      public const ERROR_NO_WILDCARD_CHARACTERS = UInt32(1417);
      public const ERROR_CLIPBOARD_NOT_OPEN = UInt32(1418);
      public const ERROR_HOTKEY_NOT_REGISTERED = UInt32(1419);
      public const ERROR_WINDOW_NOT_DIALOG = UInt32(1420);
      public const ERROR_CONTROL_ID_NOT_FOUND = UInt32(1421);
      public const ERROR_INVALID_COMBOBOX_MESSAGE = UInt32(1422);
      public const ERROR_WINDOW_NOT_COMBOBOX = UInt32(1423);
      public const ERROR_INVALID_EDIT_HEIGHT = UInt32(1424);
      public const ERROR_DC_NOT_FOUND = UInt32(1425);
      public const ERROR_INVALID_HOOK_FILTER = UInt32(1426);
      public const ERROR_INVALID_FILTER_PROC = UInt32(1427);
      public const ERROR_HOOK_NEEDS_HMOD = UInt32(1428);
      public const ERROR_GLOBAL_ONLY_HOOK = UInt32(1429);
      public const ERROR_JOURNAL_HOOK_SET = UInt32(1430);
      public const ERROR_HOOK_NOT_INSTALLED = UInt32(1431);
      public const ERROR_INVALID_LB_MESSAGE = UInt32(1432);
      public const ERROR_SETCOUNT_ON_BAD_LB = UInt32(1433);
      public const ERROR_LB_WITHOUT_TABSTOPS = UInt32(1434);
      public const ERROR_DESTROY_OBJECT_OF_OTHER_THREAD = UInt32(1435);
      public const ERROR_CHILD_WINDOW_MENU = UInt32(1436);
      public const ERROR_NO_SYSTEM_MENU = UInt32(1437);
      public const ERROR_INVALID_MSGBOX_STYLE = UInt32(1438);
      public const ERROR_INVALID_SPI_VALUE = UInt32(1439);
      public const ERROR_SCREEN_ALREADY_LOCKED = UInt32(1440);
      public const ERROR_HWNDS_HAVE_DIFF_PARENT = UInt32(1441);
      public const ERROR_NOT_CHILD_WINDOW = UInt32(1442);
      public const ERROR_INVALID_GW_COMMAND = UInt32(1443);
      public const ERROR_INVALID_THREAD_ID = UInt32(1444);
      public const ERROR_NON_MDICHILD_WINDOW = UInt32(1445);
      public const ERROR_POPUP_ALREADY_ACTIVE = UInt32(1446);
      public const ERROR_NO_SCROLLBARS = UInt32(1447);
      public const ERROR_INVALID_SCROLLBAR_RANGE = UInt32(1448);
      public const ERROR_INVALID_SHOWWIN_COMMAND = UInt32(1449);
      public const ERROR_NO_SYSTEM_RESOURCES = UInt32(1450);
      public const ERROR_NONPAGED_SYSTEM_RESOURCES = UInt32(1451);
      public const ERROR_PAGED_SYSTEM_RESOURCES = UInt32(1452);
      public const ERROR_WORKING_SET_QUOTA = UInt32(1453);
      public const ERROR_PAGEFILE_QUOTA = UInt32(1454);
      public const ERROR_COMMITMENT_LIMIT = UInt32(1455);
      public const ERROR_MENU_ITEM_NOT_FOUND = UInt32(1456);
      public const ERROR_INVALID_KEYBOARD_HANDLE = UInt32(1457);
      public const ERROR_HOOK_TYPE_NOT_ALLOWED = UInt32(1458);
      public const ERROR_REQUIRES_INTERACTIVE_WINDOWSTATION = UInt32(1459);
      public const ERROR_TIMEOUT = UInt32(1460);
      public const ERROR_INVALID_MONITOR_HANDLE = UInt32(1461);
      public const ERROR_INCORRECT_SIZE = UInt32(1462);
      public const ERROR_SYMLINK_CLASS_DISABLED = UInt32(1463);
      public const ERROR_SYMLINK_NOT_SUPPORTED = UInt32(1464);
      public const ERROR_XML_PARSE_ERROR = UInt32(1465);
      public const ERROR_XMLDSIG_ERROR = UInt32(1466);
      public const ERROR_RESTART_APPLICATION = UInt32(1467);
      public const ERROR_WRONG_COMPARTMENT = UInt32(1468);
      public const ERROR_AUTHIP_FAILURE = UInt32(1469);
      public const ERROR_NO_NVRAM_RESOURCES = UInt32(1470);
      public const ERROR_NOT_GUI_PROCESS = UInt32(1471);
      public const ERROR_EVENTLOG_FILE_CORRUPT = UInt32(1500);
      public const ERROR_EVENTLOG_CANT_START = UInt32(1501);
      public const ERROR_LOG_FILE_FULL = UInt32(1502);
      public const ERROR_EVENTLOG_FILE_CHANGED = UInt32(1503);
      public const ERROR_CONTAINER_ASSIGNED = UInt32(1504);
      public const ERROR_JOB_NO_CONTAINER = UInt32(1505);
      public const ERROR_INVALID_TASK_NAME = UInt32(1550);
      public const ERROR_INVALID_TASK_INDEX = UInt32(1551);
      public const ERROR_THREAD_ALREADY_IN_TASK = UInt32(1552);
      public const ERROR_INSTALL_SERVICE_FAILURE = UInt32(1601);
      public const ERROR_INSTALL_USEREXIT = UInt32(1602);
      public const ERROR_INSTALL_FAILURE = UInt32(1603);
      public const ERROR_INSTALL_SUSPEND = UInt32(1604);
      public const ERROR_UNKNOWN_PRODUCT = UInt32(1605);
      public const ERROR_UNKNOWN_FEATURE = UInt32(1606);
      public const ERROR_UNKNOWN_COMPONENT = UInt32(1607);
      public const ERROR_UNKNOWN_PROPERTY = UInt32(1608);
      public const ERROR_INVALID_HANDLE_STATE = UInt32(1609);
      public const ERROR_BAD_CONFIGURATION = UInt32(1610);
      public const ERROR_INDEX_ABSENT = UInt32(1611);
      public const ERROR_INSTALL_SOURCE_ABSENT = UInt32(1612);
      public const ERROR_INSTALL_PACKAGE_VERSION = UInt32(1613);
      public const ERROR_PRODUCT_UNINSTALLED = UInt32(1614);
      public const ERROR_BAD_QUERY_SYNTAX = UInt32(1615);
      public const ERROR_INVALID_FIELD = UInt32(1616);
      public const ERROR_DEVICE_REMOVED = UInt32(1617);
      public const ERROR_INSTALL_ALREADY_RUNNING = UInt32(1618);
      public const ERROR_INSTALL_PACKAGE_OPEN_FAILED = UInt32(1619);
      public const ERROR_INSTALL_PACKAGE_INVALID = UInt32(1620);
      public const ERROR_INSTALL_UI_FAILURE = UInt32(1621);
      public const ERROR_INSTALL_LOG_FAILURE = UInt32(1622);
      public const ERROR_INSTALL_LANGUAGE_UNSUPPORTED = UInt32(1623);
      public const ERROR_INSTALL_TRANSFORM_FAILURE = UInt32(1624);
      public const ERROR_INSTALL_PACKAGE_REJECTED = UInt32(1625);
      public const ERROR_FUNCTION_NOT_CALLED = UInt32(1626);
      public const ERROR_FUNCTION_FAILED = UInt32(1627);
      public const ERROR_INVALID_TABLE = UInt32(1628);
      public const ERROR_DATATYPE_MISMATCH = UInt32(1629);
      public const ERROR_UNSUPPORTED_TYPE = UInt32(1630);
      public const ERROR_CREATE_FAILED = UInt32(1631);
      public const ERROR_INSTALL_TEMP_UNWRITABLE = UInt32(1632);
      public const ERROR_INSTALL_PLATFORM_UNSUPPORTED = UInt32(1633);
      public const ERROR_INSTALL_NOTUSED = UInt32(1634);
      public const ERROR_PATCH_PACKAGE_OPEN_FAILED = UInt32(1635);
      public const ERROR_PATCH_PACKAGE_INVALID = UInt32(1636);
      public const ERROR_PATCH_PACKAGE_UNSUPPORTED = UInt32(1637);
      public const ERROR_PRODUCT_VERSION = UInt32(1638);
      public const ERROR_INVALID_COMMAND_LINE = UInt32(1639);
      public const ERROR_INSTALL_REMOTE_DISALLOWED = UInt32(1640);
      public const ERROR_SUCCESS_REBOOT_INITIATED = UInt32(1641);
      public const ERROR_PATCH_TARGET_NOT_FOUND = UInt32(1642);
      public const ERROR_PATCH_PACKAGE_REJECTED = UInt32(1643);
      public const ERROR_INSTALL_TRANSFORM_REJECTED = UInt32(1644);
      public const ERROR_INSTALL_REMOTE_PROHIBITED = UInt32(1645);
      public const ERROR_PATCH_REMOVAL_UNSUPPORTED = UInt32(1646);
      public const ERROR_UNKNOWN_PATCH = UInt32(1647);
      public const ERROR_PATCH_NO_SEQUENCE = UInt32(1648);
      public const ERROR_PATCH_REMOVAL_DISALLOWED = UInt32(1649);
      public const ERROR_INVALID_PATCH_XML = UInt32(1650);
      public const ERROR_PATCH_MANAGED_ADVERTISED_PRODUCT = UInt32(1651);
      public const ERROR_INSTALL_SERVICE_SAFEBOOT = UInt32(1652);
      public const ERROR_FAIL_FAST_EXCEPTION = UInt32(1653);
      public const ERROR_INSTALL_REJECTED = UInt32(1654);
      public const ERROR_DYNAMIC_CODE_BLOCKED = UInt32(1655);
      public const ERROR_NOT_SAME_OBJECT = UInt32(1656);
      public const ERROR_STRICT_CFG_VIOLATION = UInt32(1657);
      public const ERROR_SET_CONTEXT_DENIED = UInt32(1660);
      public const ERROR_CROSS_PARTITION_VIOLATION = UInt32(1661);
      public const ERROR_RETURN_ADDRESS_HIJACK_ATTEMPT = UInt32(1662);
      public const ERROR_INVALID_USER_BUFFER = UInt32(1784);
      public const ERROR_UNRECOGNIZED_MEDIA = UInt32(1785);
      public const ERROR_NO_TRUST_LSA_SECRET = UInt32(1786);
      public const ERROR_NO_TRUST_SAM_ACCOUNT = UInt32(1787);
      public const ERROR_TRUSTED_DOMAIN_FAILURE = UInt32(1788);
      public const ERROR_TRUSTED_RELATIONSHIP_FAILURE = UInt32(1789);
      public const ERROR_TRUST_FAILURE = UInt32(1790);
      public const ERROR_NETLOGON_NOT_STARTED = UInt32(1792);
      public const ERROR_ACCOUNT_EXPIRED = UInt32(1793);
      public const ERROR_REDIRECTOR_HAS_OPEN_HANDLES = UInt32(1794);
      public const ERROR_PRINTER_DRIVER_ALREADY_INSTALLED = UInt32(1795);
      public const ERROR_UNKNOWN_PORT = UInt32(1796);
      public const ERROR_UNKNOWN_PRINTER_DRIVER = UInt32(1797);
      public const ERROR_UNKNOWN_PRINTPROCESSOR = UInt32(1798);
      public const ERROR_INVALID_SEPARATOR_FILE = UInt32(1799);
      public const ERROR_INVALID_PRIORITY = UInt32(1800);
      public const ERROR_INVALID_PRINTER_NAME = UInt32(1801);
      public const ERROR_PRINTER_ALREADY_EXISTS = UInt32(1802);
      public const ERROR_INVALID_PRINTER_COMMAND = UInt32(1803);
      public const ERROR_INVALID_DATATYPE = UInt32(1804);
      public const ERROR_INVALID_ENVIRONMENT = UInt32(1805);
      public const ERROR_NOLOGON_INTERDOMAIN_TRUST_ACCOUNT = UInt32(1807);
      public const ERROR_NOLOGON_WORKSTATION_TRUST_ACCOUNT = UInt32(1808);
      public const ERROR_NOLOGON_SERVER_TRUST_ACCOUNT = UInt32(1809);
      public const ERROR_DOMAIN_TRUST_INCONSISTENT = UInt32(1810);
      public const ERROR_SERVER_HAS_OPEN_HANDLES = UInt32(1811);
      public const ERROR_RESOURCE_DATA_NOT_FOUND = UInt32(1812);
      public const ERROR_RESOURCE_TYPE_NOT_FOUND = UInt32(1813);
      public const ERROR_RESOURCE_NAME_NOT_FOUND = UInt32(1814);
      public const ERROR_RESOURCE_LANG_NOT_FOUND = UInt32(1815);
      public const ERROR_NOT_ENOUGH_QUOTA = UInt32(1816);
      public const ERROR_INVALID_TIME = UInt32(1901);
      public const ERROR_INVALID_FORM_NAME = UInt32(1902);
      public const ERROR_INVALID_FORM_SIZE = UInt32(1903);
      public const ERROR_ALREADY_WAITING = UInt32(1904);
      public const ERROR_PRINTER_DELETED = UInt32(1905);
      public const ERROR_INVALID_PRINTER_STATE = UInt32(1906);
      public const ERROR_PASSWORD_MUST_CHANGE = UInt32(1907);
      public const ERROR_DOMAIN_CONTROLLER_NOT_FOUND = UInt32(1908);
      public const ERROR_ACCOUNT_LOCKED_OUT = UInt32(1909);
      public const ERROR_NO_SITENAME = UInt32(1919);
      public const ERROR_CANT_ACCESS_FILE = UInt32(1920);
      public const ERROR_CANT_RESOLVE_FILENAME = UInt32(1921);
      public const ERROR_KM_DRIVER_BLOCKED = UInt32(1930);
      public const ERROR_CONTEXT_EXPIRED = UInt32(1931);
      public const ERROR_PER_USER_TRUST_QUOTA_EXCEEDED = UInt32(1932);
      public const ERROR_ALL_USER_TRUST_QUOTA_EXCEEDED = UInt32(1933);
      public const ERROR_USER_DELETE_TRUST_QUOTA_EXCEEDED = UInt32(1934);
      public const ERROR_AUTHENTICATION_FIREWALL_FAILED = UInt32(1935);
      public const ERROR_REMOTE_PRINT_CONNECTIONS_BLOCKED = UInt32(1936);
      public const ERROR_NTLM_BLOCKED = UInt32(1937);
      public const ERROR_PASSWORD_CHANGE_REQUIRED = UInt32(1938);
      public const ERROR_LOST_MODE_LOGON_RESTRICTION = UInt32(1939);
      public const ERROR_INVALID_PIXEL_FORMAT = UInt32(2000);
      public const ERROR_BAD_DRIVER = UInt32(2001);
      public const ERROR_INVALID_WINDOW_STYLE = UInt32(2002);
      public const ERROR_METAFILE_NOT_SUPPORTED = UInt32(2003);
      public const ERROR_TRANSFORM_NOT_SUPPORTED = UInt32(2004);
      public const ERROR_CLIPPING_NOT_SUPPORTED = UInt32(2005);
      public const ERROR_INVALID_CMM = UInt32(2010);
      public const ERROR_INVALID_PROFILE = UInt32(2011);
      public const ERROR_TAG_NOT_FOUND = UInt32(2012);
      public const ERROR_TAG_NOT_PRESENT = UInt32(2013);
      public const ERROR_DUPLICATE_TAG = UInt32(2014);
      public const ERROR_PROFILE_NOT_ASSOCIATED_WITH_DEVICE = UInt32(2015);
      public const ERROR_PROFILE_NOT_FOUND = UInt32(2016);
      public const ERROR_INVALID_COLORSPACE = UInt32(2017);
      public const ERROR_ICM_NOT_ENABLED = UInt32(2018);
      public const ERROR_DELETING_ICM_XFORM = UInt32(2019);
      public const ERROR_INVALID_TRANSFORM = UInt32(2020);
      public const ERROR_COLORSPACE_MISMATCH = UInt32(2021);
      public const ERROR_INVALID_COLORINDEX = UInt32(2022);
      public const ERROR_PROFILE_DOES_NOT_MATCH_DEVICE = UInt32(2023);
      public const ERROR_CONNECTED_OTHER_PASSWORD = UInt32(2108);
      public const ERROR_CONNECTED_OTHER_PASSWORD_DEFAULT = UInt32(2109);
      public const ERROR_BAD_USERNAME = UInt32(2202);
      public const ERROR_NOT_CONNECTED = UInt32(2250);
      public const ERROR_OPEN_FILES = UInt32(2401);
      public const ERROR_ACTIVE_CONNECTIONS = UInt32(2402);
      public const ERROR_DEVICE_IN_USE = UInt32(2404);
      public const ERROR_UNKNOWN_PRINT_MONITOR = UInt32(3000);
      public const ERROR_PRINTER_DRIVER_IN_USE = UInt32(3001);
      public const ERROR_SPOOL_FILE_NOT_FOUND = UInt32(3002);
      public const ERROR_SPL_NO_STARTDOC = UInt32(3003);
      public const ERROR_SPL_NO_ADDJOB = UInt32(3004);
      public const ERROR_PRINT_PROCESSOR_ALREADY_INSTALLED = UInt32(3005);
      public const ERROR_PRINT_MONITOR_ALREADY_INSTALLED = UInt32(3006);
      public const ERROR_INVALID_PRINT_MONITOR = UInt32(3007);
      public const ERROR_PRINT_MONITOR_IN_USE = UInt32(3008);
      public const ERROR_PRINTER_HAS_JOBS_QUEUED = UInt32(3009);
      public const ERROR_SUCCESS_REBOOT_REQUIRED = UInt32(3010);
      public const ERROR_SUCCESS_RESTART_REQUIRED = UInt32(3011);
      public const ERROR_PRINTER_NOT_FOUND = UInt32(3012);
      public const ERROR_PRINTER_DRIVER_WARNED = UInt32(3013);
      public const ERROR_PRINTER_DRIVER_BLOCKED = UInt32(3014);
      public const ERROR_PRINTER_DRIVER_PACKAGE_IN_USE = UInt32(3015);
      public const ERROR_CORE_DRIVER_PACKAGE_NOT_FOUND = UInt32(3016);
      public const ERROR_FAIL_REBOOT_REQUIRED = UInt32(3017);
      public const ERROR_FAIL_REBOOT_INITIATED = UInt32(3018);
      public const ERROR_PRINTER_DRIVER_DOWNLOAD_NEEDED = UInt32(3019);
      public const ERROR_PRINT_JOB_RESTART_REQUIRED = UInt32(3020);
      public const ERROR_INVALID_PRINTER_DRIVER_MANIFEST = UInt32(3021);
      public const ERROR_PRINTER_NOT_SHAREABLE = UInt32(3022);
      public const ERROR_SERVER_SERVICE_CALL_REQUIRES_SMB1 = UInt32(3023);
      public const ERROR_NETWORK_AUTHENTICATION_PROMPT_CANCELED = UInt32(3024);
      public const ERROR_REQUEST_PAUSED = UInt32(3050);
      public const ERROR_APPEXEC_CONDITION_NOT_SATISFIED = UInt32(3060);
      public const ERROR_APPEXEC_HANDLE_INVALIDATED = UInt32(3061);
      public const ERROR_APPEXEC_INVALID_HOST_GENERATION = UInt32(3062);
      public const ERROR_APPEXEC_UNEXPECTED_PROCESS_REGISTRATION = UInt32(3063);
      public const ERROR_APPEXEC_INVALID_HOST_STATE = UInt32(3064);
      public const ERROR_APPEXEC_NO_DONOR = UInt32(3065);
      public const ERROR_APPEXEC_HOST_ID_MISMATCH = UInt32(3066);
      public const ERROR_APPEXEC_UNKNOWN_USER = UInt32(3067);
      public const ERROR_APPEXEC_APP_COMPAT_BLOCK = UInt32(3068);
      public const ERROR_APPEXEC_CALLER_WAIT_TIMEOUT = UInt32(3069);
      public const ERROR_APPEXEC_CALLER_WAIT_TIMEOUT_TERMINATION = UInt32(3070);
      public const ERROR_APPEXEC_CALLER_WAIT_TIMEOUT_LICENSING = UInt32(3071);
      public const ERROR_APPEXEC_CALLER_WAIT_TIMEOUT_RESOURCES = UInt32(3072);
      public const ERROR_VRF_VOLATILE_CFG_AND_IO_ENABLED = UInt32(3080);
      public const ERROR_VRF_VOLATILE_NOT_STOPPABLE = UInt32(3081);
      public const ERROR_VRF_VOLATILE_SAFE_MODE = UInt32(3082);
      public const ERROR_VRF_VOLATILE_NOT_RUNNABLE_SYSTEM = UInt32(3083);
      public const ERROR_VRF_VOLATILE_NOT_SUPPORTED_RULECLASS = UInt32(3084);
      public const ERROR_VRF_VOLATILE_PROTECTED_DRIVER = UInt32(3085);
      public const ERROR_VRF_VOLATILE_NMI_REGISTERED = UInt32(3086);
      public const ERROR_VRF_VOLATILE_SETTINGS_CONFLICT = UInt32(3087);
      public const ERROR_DIF_IOCALLBACK_NOT_REPLACED = UInt32(3190);
      public const ERROR_DIF_LIVEDUMP_LIMIT_EXCEEDED = UInt32(3191);
      public const ERROR_DIF_VOLATILE_SECTION_NOT_LOCKED = UInt32(3192);
      public const ERROR_DIF_VOLATILE_DRIVER_HOTPATCHED = UInt32(3193);
      public const ERROR_DIF_VOLATILE_INVALID_INFO = UInt32(3194);
      public const ERROR_DIF_VOLATILE_DRIVER_IS_NOT_RUNNING = UInt32(3195);
      public const ERROR_DIF_VOLATILE_PLUGIN_IS_NOT_RUNNING = UInt32(3196);
      public const ERROR_DIF_VOLATILE_PLUGIN_CHANGE_NOT_ALLOWED = UInt32(3197);
      public const ERROR_DIF_VOLATILE_NOT_ALLOWED = UInt32(3198);
      public const ERROR_DIF_BINDING_API_NOT_FOUND = UInt32(3199);
      public const ERROR_IO_REISSUE_AS_CACHED = UInt32(3950);
      public const ERROR_WINS_INTERNAL = UInt32(4000);
      public const ERROR_CAN_NOT_DEL_LOCAL_WINS = UInt32(4001);
      public const ERROR_STATIC_INIT = UInt32(4002);
      public const ERROR_INC_BACKUP = UInt32(4003);
      public const ERROR_FULL_BACKUP = UInt32(4004);
      public const ERROR_REC_NON_EXISTENT = UInt32(4005);
      public const ERROR_RPL_NOT_ALLOWED = UInt32(4006);
      public const ERROR_DHCP_ADDRESS_CONFLICT = UInt32(4100);
      public const ERROR_WMI_GUID_NOT_FOUND = UInt32(4200);
      public const ERROR_WMI_INSTANCE_NOT_FOUND = UInt32(4201);
      public const ERROR_WMI_ITEMID_NOT_FOUND = UInt32(4202);
      public const ERROR_WMI_TRY_AGAIN = UInt32(4203);
      public const ERROR_WMI_DP_NOT_FOUND = UInt32(4204);
      public const ERROR_WMI_UNRESOLVED_INSTANCE_REF = UInt32(4205);
      public const ERROR_WMI_ALREADY_ENABLED = UInt32(4206);
      public const ERROR_WMI_GUID_DISCONNECTED = UInt32(4207);
      public const ERROR_WMI_SERVER_UNAVAILABLE = UInt32(4208);
      public const ERROR_WMI_DP_FAILED = UInt32(4209);
      public const ERROR_WMI_INVALID_MOF = UInt32(4210);
      public const ERROR_WMI_INVALID_REGINFO = UInt32(4211);
      public const ERROR_WMI_ALREADY_DISABLED = UInt32(4212);
      public const ERROR_WMI_READ_ONLY = UInt32(4213);
      public const ERROR_WMI_SET_FAILURE = UInt32(4214);
      public const ERROR_NOT_APPCONTAINER = UInt32(4250);
      public const ERROR_APPCONTAINER_REQUIRED = UInt32(4251);
      public const ERROR_NOT_SUPPORTED_IN_APPCONTAINER = UInt32(4252);
      public const ERROR_INVALID_PACKAGE_SID_LENGTH = UInt32(4253);
      public const ERROR_INVALID_MEDIA = UInt32(4300);
      public const ERROR_INVALID_LIBRARY = UInt32(4301);
      public const ERROR_INVALID_MEDIA_POOL = UInt32(4302);
      public const ERROR_DRIVE_MEDIA_MISMATCH = UInt32(4303);
      public const ERROR_MEDIA_OFFLINE = UInt32(4304);
      public const ERROR_LIBRARY_OFFLINE = UInt32(4305);
      public const ERROR_EMPTY = UInt32(4306);
      public const ERROR_NOT_EMPTY = UInt32(4307);
      public const ERROR_MEDIA_UNAVAILABLE = UInt32(4308);
      public const ERROR_RESOURCE_DISABLED = UInt32(4309);
      public const ERROR_INVALID_CLEANER = UInt32(4310);
      public const ERROR_UNABLE_TO_CLEAN = UInt32(4311);
      public const ERROR_OBJECT_NOT_FOUND = UInt32(4312);
      public const ERROR_DATABASE_FAILURE = UInt32(4313);
      public const ERROR_DATABASE_FULL = UInt32(4314);
      public const ERROR_MEDIA_INCOMPATIBLE = UInt32(4315);
      public const ERROR_RESOURCE_NOT_PRESENT = UInt32(4316);
      public const ERROR_INVALID_OPERATION = UInt32(4317);
      public const ERROR_MEDIA_NOT_AVAILABLE = UInt32(4318);
      public const ERROR_DEVICE_NOT_AVAILABLE = UInt32(4319);
      public const ERROR_REQUEST_REFUSED = UInt32(4320);
      public const ERROR_INVALID_DRIVE_OBJECT = UInt32(4321);
      public const ERROR_LIBRARY_FULL = UInt32(4322);
      public const ERROR_MEDIUM_NOT_ACCESSIBLE = UInt32(4323);
      public const ERROR_UNABLE_TO_LOAD_MEDIUM = UInt32(4324);
      public const ERROR_UNABLE_TO_INVENTORY_DRIVE = UInt32(4325);
      public const ERROR_UNABLE_TO_INVENTORY_SLOT = UInt32(4326);
      public const ERROR_UNABLE_TO_INVENTORY_TRANSPORT = UInt32(4327);
      public const ERROR_TRANSPORT_FULL = UInt32(4328);
      public const ERROR_CONTROLLING_IEPORT = UInt32(4329);
      public const ERROR_UNABLE_TO_EJECT_MOUNTED_MEDIA = UInt32(4330);
      public const ERROR_CLEANER_SLOT_SET = UInt32(4331);
      public const ERROR_CLEANER_SLOT_NOT_SET = UInt32(4332);
      public const ERROR_CLEANER_CARTRIDGE_SPENT = UInt32(4333);
      public const ERROR_UNEXPECTED_OMID = UInt32(4334);
      public const ERROR_CANT_DELETE_LAST_ITEM = UInt32(4335);
      public const ERROR_MESSAGE_EXCEEDS_MAX_SIZE = UInt32(4336);
      public const ERROR_VOLUME_CONTAINS_SYS_FILES = UInt32(4337);
      public const ERROR_INDIGENOUS_TYPE = UInt32(4338);
      public const ERROR_NO_SUPPORTING_DRIVES = UInt32(4339);
      public const ERROR_CLEANER_CARTRIDGE_INSTALLED = UInt32(4340);
      public const ERROR_IEPORT_FULL = UInt32(4341);
      public const ERROR_FILE_OFFLINE = UInt32(4350);
      public const ERROR_REMOTE_STORAGE_NOT_ACTIVE = UInt32(4351);
      public const ERROR_REMOTE_STORAGE_MEDIA_ERROR = UInt32(4352);
      public const ERROR_NOT_A_REPARSE_POINT = UInt32(4390);
      public const ERROR_REPARSE_ATTRIBUTE_CONFLICT = UInt32(4391);
      public const ERROR_INVALID_REPARSE_DATA = UInt32(4392);
      public const ERROR_REPARSE_TAG_INVALID = UInt32(4393);
      public const ERROR_REPARSE_TAG_MISMATCH = UInt32(4394);
      public const ERROR_REPARSE_POINT_ENCOUNTERED = UInt32(4395);
      public const ERROR_APP_DATA_NOT_FOUND = UInt32(4400);
      public const ERROR_APP_DATA_EXPIRED = UInt32(4401);
      public const ERROR_APP_DATA_CORRUPT = UInt32(4402);
      public const ERROR_APP_DATA_LIMIT_EXCEEDED = UInt32(4403);
      public const ERROR_APP_DATA_REBOOT_REQUIRED = UInt32(4404);
      public const ERROR_SECUREBOOT_ROLLBACK_DETECTED = UInt32(4420);
      public const ERROR_SECUREBOOT_POLICY_VIOLATION = UInt32(4421);
      public const ERROR_SECUREBOOT_INVALID_POLICY = UInt32(4422);
      public const ERROR_SECUREBOOT_POLICY_PUBLISHER_NOT_FOUND = UInt32(4423);
      public const ERROR_SECUREBOOT_POLICY_NOT_SIGNED = UInt32(4424);
      public const ERROR_SECUREBOOT_NOT_ENABLED = UInt32(4425);
      public const ERROR_SECUREBOOT_FILE_REPLACED = UInt32(4426);
      public const ERROR_SECUREBOOT_POLICY_NOT_AUTHORIZED = UInt32(4427);
      public const ERROR_SECUREBOOT_POLICY_UNKNOWN = UInt32(4428);
      public const ERROR_SECUREBOOT_POLICY_MISSING_ANTIROLLBACKVERSION = UInt32(4429);
      public const ERROR_SECUREBOOT_PLATFORM_ID_MISMATCH = UInt32(4430);
      public const ERROR_SECUREBOOT_POLICY_ROLLBACK_DETECTED = UInt32(4431);
      public const ERROR_SECUREBOOT_POLICY_UPGRADE_MISMATCH = UInt32(4432);
      public const ERROR_SECUREBOOT_REQUIRED_POLICY_FILE_MISSING = UInt32(4433);
      public const ERROR_SECUREBOOT_NOT_BASE_POLICY = UInt32(4434);
      public const ERROR_SECUREBOOT_NOT_SUPPLEMENTAL_POLICY = UInt32(4435);
      public const ERROR_OFFLOAD_READ_FLT_NOT_SUPPORTED = UInt32(4440);
      public const ERROR_OFFLOAD_WRITE_FLT_NOT_SUPPORTED = UInt32(4441);
      public const ERROR_OFFLOAD_READ_FILE_NOT_SUPPORTED = UInt32(4442);
      public const ERROR_OFFLOAD_WRITE_FILE_NOT_SUPPORTED = UInt32(4443);
      public const ERROR_ALREADY_HAS_STREAM_ID = UInt32(4444);
      public const ERROR_SMR_GARBAGE_COLLECTION_REQUIRED = UInt32(4445);
      public const ERROR_WOF_WIM_HEADER_CORRUPT = UInt32(4446);
      public const ERROR_WOF_WIM_RESOURCE_TABLE_CORRUPT = UInt32(4447);
      public const ERROR_WOF_FILE_RESOURCE_TABLE_CORRUPT = UInt32(4448);
      public const ERROR_OBJECT_IS_IMMUTABLE = UInt32(4449);
      public const ERROR_VOLUME_NOT_SIS_ENABLED = UInt32(4500);
      public const ERROR_SYSTEM_INTEGRITY_ROLLBACK_DETECTED = UInt32(4550);
      public const ERROR_SYSTEM_INTEGRITY_POLICY_VIOLATION = UInt32(4551);
      public const ERROR_SYSTEM_INTEGRITY_INVALID_POLICY = UInt32(4552);
      public const ERROR_SYSTEM_INTEGRITY_POLICY_NOT_SIGNED = UInt32(4553);
      public const ERROR_SYSTEM_INTEGRITY_TOO_MANY_POLICIES = UInt32(4554);
      public const ERROR_SYSTEM_INTEGRITY_SUPPLEMENTAL_POLICY_NOT_AUTHORIZED = UInt32(4555);
      public const ERROR_SYSTEM_INTEGRITY_REPUTATION_MALICIOUS = UInt32(4556);
      public const ERROR_SYSTEM_INTEGRITY_REPUTATION_PUA = UInt32(4557);
      public const ERROR_SYSTEM_INTEGRITY_REPUTATION_DANGEROUS_EXT = UInt32(4558);
      public const ERROR_SYSTEM_INTEGRITY_REPUTATION_OFFLINE = UInt32(4559);
      public const ERROR_VSM_NOT_INITIALIZED = UInt32(4560);
      public const ERROR_VSM_DMA_PROTECTION_NOT_IN_USE = UInt32(4561);
      public const ERROR_PLATFORM_MANIFEST_NOT_AUTHORIZED = UInt32(4570);
      public const ERROR_PLATFORM_MANIFEST_INVALID = UInt32(4571);
      public const ERROR_PLATFORM_MANIFEST_FILE_NOT_AUTHORIZED = UInt32(4572);
      public const ERROR_PLATFORM_MANIFEST_CATALOG_NOT_AUTHORIZED = UInt32(4573);
      public const ERROR_PLATFORM_MANIFEST_BINARY_ID_NOT_FOUND = UInt32(4574);
      public const ERROR_PLATFORM_MANIFEST_NOT_ACTIVE = UInt32(4575);
      public const ERROR_PLATFORM_MANIFEST_NOT_SIGNED = UInt32(4576);
      public const ERROR_SYSTEM_INTEGRITY_REPUTATION_UNFRIENDLY_FILE = UInt32(4580);
      public const ERROR_SYSTEM_INTEGRITY_REPUTATION_UNATTAINABLE = UInt32(4581);
      public const ERROR_DEPENDENT_RESOURCE_EXISTS = UInt32(5001);
      public const ERROR_DEPENDENCY_NOT_FOUND = UInt32(5002);
      public const ERROR_DEPENDENCY_ALREADY_EXISTS = UInt32(5003);
      public const ERROR_RESOURCE_NOT_ONLINE = UInt32(5004);
      public const ERROR_HOST_NODE_NOT_AVAILABLE = UInt32(5005);
      public const ERROR_RESOURCE_NOT_AVAILABLE = UInt32(5006);
      public const ERROR_RESOURCE_NOT_FOUND = UInt32(5007);
      public const ERROR_SHUTDOWN_CLUSTER = UInt32(5008);
      public const ERROR_CANT_EVICT_ACTIVE_NODE = UInt32(5009);
      public const ERROR_OBJECT_ALREADY_EXISTS = UInt32(5010);
      public const ERROR_OBJECT_IN_LIST = UInt32(5011);
      public const ERROR_GROUP_NOT_AVAILABLE = UInt32(5012);
      public const ERROR_GROUP_NOT_FOUND = UInt32(5013);
      public const ERROR_GROUP_NOT_ONLINE = UInt32(5014);
      public const ERROR_HOST_NODE_NOT_RESOURCE_OWNER = UInt32(5015);
      public const ERROR_HOST_NODE_NOT_GROUP_OWNER = UInt32(5016);
      public const ERROR_RESMON_CREATE_FAILED = UInt32(5017);
      public const ERROR_RESMON_ONLINE_FAILED = UInt32(5018);
      public const ERROR_RESOURCE_ONLINE = UInt32(5019);
      public const ERROR_QUORUM_RESOURCE = UInt32(5020);
      public const ERROR_NOT_QUORUM_CAPABLE = UInt32(5021);
      public const ERROR_CLUSTER_SHUTTING_DOWN = UInt32(5022);
      public const ERROR_INVALID_STATE = UInt32(5023);
      public const ERROR_RESOURCE_PROPERTIES_STORED = UInt32(5024);
      public const ERROR_NOT_QUORUM_CLASS = UInt32(5025);
      public const ERROR_CORE_RESOURCE = UInt32(5026);
      public const ERROR_QUORUM_RESOURCE_ONLINE_FAILED = UInt32(5027);
      public const ERROR_QUORUMLOG_OPEN_FAILED = UInt32(5028);
      public const ERROR_CLUSTERLOG_CORRUPT = UInt32(5029);
      public const ERROR_CLUSTERLOG_RECORD_EXCEEDS_MAXSIZE = UInt32(5030);
      public const ERROR_CLUSTERLOG_EXCEEDS_MAXSIZE = UInt32(5031);
      public const ERROR_CLUSTERLOG_CHKPOINT_NOT_FOUND = UInt32(5032);
      public const ERROR_CLUSTERLOG_NOT_ENOUGH_SPACE = UInt32(5033);
      public const ERROR_QUORUM_OWNER_ALIVE = UInt32(5034);
      public const ERROR_NETWORK_NOT_AVAILABLE = UInt32(5035);
      public const ERROR_NODE_NOT_AVAILABLE = UInt32(5036);
      public const ERROR_ALL_NODES_NOT_AVAILABLE = UInt32(5037);
      public const ERROR_RESOURCE_FAILED = UInt32(5038);
      public const ERROR_CLUSTER_INVALID_NODE = UInt32(5039);
      public const ERROR_CLUSTER_NODE_EXISTS = UInt32(5040);
      public const ERROR_CLUSTER_JOIN_IN_PROGRESS = UInt32(5041);
      public const ERROR_CLUSTER_NODE_NOT_FOUND = UInt32(5042);
      public const ERROR_CLUSTER_LOCAL_NODE_NOT_FOUND = UInt32(5043);
      public const ERROR_CLUSTER_NETWORK_EXISTS = UInt32(5044);
      public const ERROR_CLUSTER_NETWORK_NOT_FOUND = UInt32(5045);
      public const ERROR_CLUSTER_NETINTERFACE_EXISTS = UInt32(5046);
      public const ERROR_CLUSTER_NETINTERFACE_NOT_FOUND = UInt32(5047);
      public const ERROR_CLUSTER_INVALID_REQUEST = UInt32(5048);
      public const ERROR_CLUSTER_INVALID_NETWORK_PROVIDER = UInt32(5049);
      public const ERROR_CLUSTER_NODE_DOWN = UInt32(5050);
      public const ERROR_CLUSTER_NODE_UNREACHABLE = UInt32(5051);
      public const ERROR_CLUSTER_NODE_NOT_MEMBER = UInt32(5052);
      public const ERROR_CLUSTER_JOIN_NOT_IN_PROGRESS = UInt32(5053);
      public const ERROR_CLUSTER_INVALID_NETWORK = UInt32(5054);
      public const ERROR_CLUSTER_NODE_UP = UInt32(5056);
      public const ERROR_CLUSTER_IPADDR_IN_USE = UInt32(5057);
      public const ERROR_CLUSTER_NODE_NOT_PAUSED = UInt32(5058);
      public const ERROR_CLUSTER_NO_SECURITY_CONTEXT = UInt32(5059);
      public const ERROR_CLUSTER_NETWORK_NOT_INTERNAL = UInt32(5060);
      public const ERROR_CLUSTER_NODE_ALREADY_UP = UInt32(5061);
      public const ERROR_CLUSTER_NODE_ALREADY_DOWN = UInt32(5062);
      public const ERROR_CLUSTER_NETWORK_ALREADY_ONLINE = UInt32(5063);
      public const ERROR_CLUSTER_NETWORK_ALREADY_OFFLINE = UInt32(5064);
      public const ERROR_CLUSTER_NODE_ALREADY_MEMBER = UInt32(5065);
      public const ERROR_CLUSTER_LAST_INTERNAL_NETWORK = UInt32(5066);
      public const ERROR_CLUSTER_NETWORK_HAS_DEPENDENTS = UInt32(5067);
      public const ERROR_INVALID_OPERATION_ON_QUORUM = UInt32(5068);
      public const ERROR_DEPENDENCY_NOT_ALLOWED = UInt32(5069);
      public const ERROR_CLUSTER_NODE_PAUSED = UInt32(5070);
      public const ERROR_NODE_CANT_HOST_RESOURCE = UInt32(5071);
      public const ERROR_CLUSTER_NODE_NOT_READY = UInt32(5072);
      public const ERROR_CLUSTER_NODE_SHUTTING_DOWN = UInt32(5073);
      public const ERROR_CLUSTER_JOIN_ABORTED = UInt32(5074);
      public const ERROR_CLUSTER_INCOMPATIBLE_VERSIONS = UInt32(5075);
      public const ERROR_CLUSTER_MAXNUM_OF_RESOURCES_EXCEEDED = UInt32(5076);
      public const ERROR_CLUSTER_SYSTEM_CONFIG_CHANGED = UInt32(5077);
      public const ERROR_CLUSTER_RESOURCE_TYPE_NOT_FOUND = UInt32(5078);
      public const ERROR_CLUSTER_RESTYPE_NOT_SUPPORTED = UInt32(5079);
      public const ERROR_CLUSTER_RESNAME_NOT_FOUND = UInt32(5080);
      public const ERROR_CLUSTER_NO_RPC_PACKAGES_REGISTERED = UInt32(5081);
      public const ERROR_CLUSTER_OWNER_NOT_IN_PREFLIST = UInt32(5082);
      public const ERROR_CLUSTER_DATABASE_SEQMISMATCH = UInt32(5083);
      public const ERROR_RESMON_INVALID_STATE = UInt32(5084);
      public const ERROR_CLUSTER_GUM_NOT_LOCKER = UInt32(5085);
      public const ERROR_QUORUM_DISK_NOT_FOUND = UInt32(5086);
      public const ERROR_DATABASE_BACKUP_CORRUPT = UInt32(5087);
      public const ERROR_CLUSTER_NODE_ALREADY_HAS_DFS_ROOT = UInt32(5088);
      public const ERROR_RESOURCE_PROPERTY_UNCHANGEABLE = UInt32(5089);
      public const ERROR_NO_ADMIN_ACCESS_POINT = UInt32(5090);
      public const ERROR_CLUSTER_MEMBERSHIP_INVALID_STATE = UInt32(5890);
      public const ERROR_CLUSTER_QUORUMLOG_NOT_FOUND = UInt32(5891);
      public const ERROR_CLUSTER_MEMBERSHIP_HALT = UInt32(5892);
      public const ERROR_CLUSTER_INSTANCE_ID_MISMATCH = UInt32(5893);
      public const ERROR_CLUSTER_NETWORK_NOT_FOUND_FOR_IP = UInt32(5894);
      public const ERROR_CLUSTER_PROPERTY_DATA_TYPE_MISMATCH = UInt32(5895);
      public const ERROR_CLUSTER_EVICT_WITHOUT_CLEANUP = UInt32(5896);
      public const ERROR_CLUSTER_PARAMETER_MISMATCH = UInt32(5897);
      public const ERROR_NODE_CANNOT_BE_CLUSTERED = UInt32(5898);
      public const ERROR_CLUSTER_WRONG_OS_VERSION = UInt32(5899);
      public const ERROR_CLUSTER_CANT_CREATE_DUP_CLUSTER_NAME = UInt32(5900);
      public const ERROR_CLUSCFG_ALREADY_COMMITTED = UInt32(5901);
      public const ERROR_CLUSCFG_ROLLBACK_FAILED = UInt32(5902);
      public const ERROR_CLUSCFG_SYSTEM_DISK_DRIVE_LETTER_CONFLICT = UInt32(5903);
      public const ERROR_CLUSTER_OLD_VERSION = UInt32(5904);
      public const ERROR_CLUSTER_MISMATCHED_COMPUTER_ACCT_NAME = UInt32(5905);
      public const ERROR_CLUSTER_NO_NET_ADAPTERS = UInt32(5906);
      public const ERROR_CLUSTER_POISONED = UInt32(5907);
      public const ERROR_CLUSTER_GROUP_MOVING = UInt32(5908);
      public const ERROR_CLUSTER_RESOURCE_TYPE_BUSY = UInt32(5909);
      public const ERROR_RESOURCE_CALL_TIMED_OUT = UInt32(5910);
      public const ERROR_INVALID_CLUSTER_IPV6_ADDRESS = UInt32(5911);
      public const ERROR_CLUSTER_INTERNAL_INVALID_FUNCTION = UInt32(5912);
      public const ERROR_CLUSTER_PARAMETER_OUT_OF_BOUNDS = UInt32(5913);
      public const ERROR_CLUSTER_PARTIAL_SEND = UInt32(5914);
      public const ERROR_CLUSTER_REGISTRY_INVALID_FUNCTION = UInt32(5915);
      public const ERROR_CLUSTER_INVALID_STRING_TERMINATION = UInt32(5916);
      public const ERROR_CLUSTER_INVALID_STRING_FORMAT = UInt32(5917);
      public const ERROR_CLUSTER_DATABASE_TRANSACTION_IN_PROGRESS = UInt32(5918);
      public const ERROR_CLUSTER_DATABASE_TRANSACTION_NOT_IN_PROGRESS = UInt32(5919);
      public const ERROR_CLUSTER_NULL_DATA = UInt32(5920);
      public const ERROR_CLUSTER_PARTIAL_READ = UInt32(5921);
      public const ERROR_CLUSTER_PARTIAL_WRITE = UInt32(5922);
      public const ERROR_CLUSTER_CANT_DESERIALIZE_DATA = UInt32(5923);
      public const ERROR_DEPENDENT_RESOURCE_PROPERTY_CONFLICT = UInt32(5924);
      public const ERROR_CLUSTER_NO_QUORUM = UInt32(5925);
      public const ERROR_CLUSTER_INVALID_IPV6_NETWORK = UInt32(5926);
      public const ERROR_CLUSTER_INVALID_IPV6_TUNNEL_NETWORK = UInt32(5927);
      public const ERROR_QUORUM_NOT_ALLOWED_IN_THIS_GROUP = UInt32(5928);
      public const ERROR_DEPENDENCY_TREE_TOO_COMPLEX = UInt32(5929);
      public const ERROR_EXCEPTION_IN_RESOURCE_CALL = UInt32(5930);
      public const ERROR_CLUSTER_RHS_FAILED_INITIALIZATION = UInt32(5931);
      public const ERROR_CLUSTER_NOT_INSTALLED = UInt32(5932);
      public const ERROR_CLUSTER_RESOURCES_MUST_BE_ONLINE_ON_THE_SAME_NODE = UInt32(5933);
      public const ERROR_CLUSTER_MAX_NODES_IN_CLUSTER = UInt32(5934);
      public const ERROR_CLUSTER_TOO_MANY_NODES = UInt32(5935);
      public const ERROR_CLUSTER_OBJECT_ALREADY_USED = UInt32(5936);
      public const ERROR_NONCORE_GROUPS_FOUND = UInt32(5937);
      public const ERROR_FILE_SHARE_RESOURCE_CONFLICT = UInt32(5938);
      public const ERROR_CLUSTER_EVICT_INVALID_REQUEST = UInt32(5939);
      public const ERROR_CLUSTER_SINGLETON_RESOURCE = UInt32(5940);
      public const ERROR_CLUSTER_GROUP_SINGLETON_RESOURCE = UInt32(5941);
      public const ERROR_CLUSTER_RESOURCE_PROVIDER_FAILED = UInt32(5942);
      public const ERROR_CLUSTER_RESOURCE_CONFIGURATION_ERROR = UInt32(5943);
      public const ERROR_CLUSTER_GROUP_BUSY = UInt32(5944);
      public const ERROR_CLUSTER_NOT_SHARED_VOLUME = UInt32(5945);
      public const ERROR_CLUSTER_INVALID_SECURITY_DESCRIPTOR = UInt32(5946);
      public const ERROR_CLUSTER_SHARED_VOLUMES_IN_USE = UInt32(5947);
      public const ERROR_CLUSTER_USE_SHARED_VOLUMES_API = UInt32(5948);
      public const ERROR_CLUSTER_BACKUP_IN_PROGRESS = UInt32(5949);
      public const ERROR_NON_CSV_PATH = UInt32(5950);
      public const ERROR_CSV_VOLUME_NOT_LOCAL = UInt32(5951);
      public const ERROR_CLUSTER_WATCHDOG_TERMINATING = UInt32(5952);
      public const ERROR_CLUSTER_RESOURCE_VETOED_MOVE_INCOMPATIBLE_NODES = UInt32(5953);
      public const ERROR_CLUSTER_INVALID_NODE_WEIGHT = UInt32(5954);
      public const ERROR_CLUSTER_RESOURCE_VETOED_CALL = UInt32(5955);
      public const ERROR_RESMON_SYSTEM_RESOURCES_LACKING = UInt32(5956);
      public const ERROR_CLUSTER_RESOURCE_VETOED_MOVE_NOT_ENOUGH_RESOURCES_ON_DESTINATION = UInt32(5957);
      public const ERROR_CLUSTER_RESOURCE_VETOED_MOVE_NOT_ENOUGH_RESOURCES_ON_SOURCE = UInt32(5958);
      public const ERROR_CLUSTER_GROUP_QUEUED = UInt32(5959);
      public const ERROR_CLUSTER_RESOURCE_LOCKED_STATUS = UInt32(5960);
      public const ERROR_CLUSTER_SHARED_VOLUME_FAILOVER_NOT_ALLOWED = UInt32(5961);
      public const ERROR_CLUSTER_NODE_DRAIN_IN_PROGRESS = UInt32(5962);
      public const ERROR_CLUSTER_DISK_NOT_CONNECTED = UInt32(5963);
      public const ERROR_DISK_NOT_CSV_CAPABLE = UInt32(5964);
      public const ERROR_RESOURCE_NOT_IN_AVAILABLE_STORAGE = UInt32(5965);
      public const ERROR_CLUSTER_SHARED_VOLUME_REDIRECTED = UInt32(5966);
      public const ERROR_CLUSTER_SHARED_VOLUME_NOT_REDIRECTED = UInt32(5967);
      public const ERROR_CLUSTER_CANNOT_RETURN_PROPERTIES = UInt32(5968);
      public const ERROR_CLUSTER_RESOURCE_CONTAINS_UNSUPPORTED_DIFF_AREA_FOR_SHARED_VOLUMES = UInt32(5969);
      public const ERROR_CLUSTER_RESOURCE_IS_IN_MAINTENANCE_MODE = UInt32(5970);
      public const ERROR_CLUSTER_AFFINITY_CONFLICT = UInt32(5971);
      public const ERROR_CLUSTER_RESOURCE_IS_REPLICA_VIRTUAL_MACHINE = UInt32(5972);
      public const ERROR_CLUSTER_UPGRADE_INCOMPATIBLE_VERSIONS = UInt32(5973);
      public const ERROR_CLUSTER_UPGRADE_FIX_QUORUM_NOT_SUPPORTED = UInt32(5974);
      public const ERROR_CLUSTER_UPGRADE_RESTART_REQUIRED = UInt32(5975);
      public const ERROR_CLUSTER_UPGRADE_IN_PROGRESS = UInt32(5976);
      public const ERROR_CLUSTER_UPGRADE_INCOMPLETE = UInt32(5977);
      public const ERROR_CLUSTER_NODE_IN_GRACE_PERIOD = UInt32(5978);
      public const ERROR_CLUSTER_CSV_IO_PAUSE_TIMEOUT = UInt32(5979);
      public const ERROR_NODE_NOT_ACTIVE_CLUSTER_MEMBER = UInt32(5980);
      public const ERROR_CLUSTER_RESOURCE_NOT_MONITORED = UInt32(5981);
      public const ERROR_CLUSTER_RESOURCE_DOES_NOT_SUPPORT_UNMONITORED = UInt32(5982);
      public const ERROR_CLUSTER_RESOURCE_IS_REPLICATED = UInt32(5983);
      public const ERROR_CLUSTER_NODE_ISOLATED = UInt32(5984);
      public const ERROR_CLUSTER_NODE_QUARANTINED = UInt32(5985);
      public const ERROR_CLUSTER_DATABASE_UPDATE_CONDITION_FAILED = UInt32(5986);
      public const ERROR_CLUSTER_SPACE_DEGRADED = UInt32(5987);
      public const ERROR_CLUSTER_TOKEN_DELEGATION_NOT_SUPPORTED = UInt32(5988);
      public const ERROR_CLUSTER_CSV_INVALID_HANDLE = UInt32(5989);
      public const ERROR_CLUSTER_CSV_SUPPORTED_ONLY_ON_COORDINATOR = UInt32(5990);
      public const ERROR_GROUPSET_NOT_AVAILABLE = UInt32(5991);
      public const ERROR_GROUPSET_NOT_FOUND = UInt32(5992);
      public const ERROR_GROUPSET_CANT_PROVIDE = UInt32(5993);
      public const ERROR_CLUSTER_FAULT_DOMAIN_PARENT_NOT_FOUND = UInt32(5994);
      public const ERROR_CLUSTER_FAULT_DOMAIN_INVALID_HIERARCHY = UInt32(5995);
      public const ERROR_CLUSTER_FAULT_DOMAIN_FAILED_S2D_VALIDATION = UInt32(5996);
      public const ERROR_CLUSTER_FAULT_DOMAIN_S2D_CONNECTIVITY_LOSS = UInt32(5997);
      public const ERROR_CLUSTER_INVALID_INFRASTRUCTURE_FILESERVER_NAME = UInt32(5998);
      public const ERROR_CLUSTERSET_MANAGEMENT_CLUSTER_UNREACHABLE = UInt32(5999);
      public const ERROR_ENCRYPTION_FAILED = UInt32(6000);
      public const ERROR_DECRYPTION_FAILED = UInt32(6001);
      public const ERROR_FILE_ENCRYPTED = UInt32(6002);
      public const ERROR_NO_RECOVERY_POLICY = UInt32(6003);
      public const ERROR_NO_EFS = UInt32(6004);
      public const ERROR_WRONG_EFS = UInt32(6005);
      public const ERROR_NO_USER_KEYS = UInt32(6006);
      public const ERROR_FILE_NOT_ENCRYPTED = UInt32(6007);
      public const ERROR_NOT_EXPORT_FORMAT = UInt32(6008);
      public const ERROR_FILE_READ_ONLY = UInt32(6009);
      public const ERROR_DIR_EFS_DISALLOWED = UInt32(6010);
      public const ERROR_EFS_SERVER_NOT_TRUSTED = UInt32(6011);
      public const ERROR_BAD_RECOVERY_POLICY = UInt32(6012);
      public const ERROR_EFS_ALG_BLOB_TOO_BIG = UInt32(6013);
      public const ERROR_VOLUME_NOT_SUPPORT_EFS = UInt32(6014);
      public const ERROR_EFS_DISABLED = UInt32(6015);
      public const ERROR_EFS_VERSION_NOT_SUPPORT = UInt32(6016);
      public const ERROR_CS_ENCRYPTION_INVALID_SERVER_RESPONSE = UInt32(6017);
      public const ERROR_CS_ENCRYPTION_UNSUPPORTED_SERVER = UInt32(6018);
      public const ERROR_CS_ENCRYPTION_EXISTING_ENCRYPTED_FILE = UInt32(6019);
      public const ERROR_CS_ENCRYPTION_NEW_ENCRYPTED_FILE = UInt32(6020);
      public const ERROR_CS_ENCRYPTION_FILE_NOT_CSE = UInt32(6021);
      public const ERROR_ENCRYPTION_POLICY_DENIES_OPERATION = UInt32(6022);
      public const ERROR_WIP_ENCRYPTION_FAILED = UInt32(6023);
      public const ERROR_NO_BROWSER_SERVERS_FOUND = UInt32(6118);
      public const ERROR_CLUSTER_OBJECT_IS_CLUSTER_SET_VM = UInt32(6250);
      public const ERROR_LOG_SECTOR_INVALID = UInt32(6600);
      public const ERROR_LOG_SECTOR_PARITY_INVALID = UInt32(6601);
      public const ERROR_LOG_SECTOR_REMAPPED = UInt32(6602);
      public const ERROR_LOG_BLOCK_INCOMPLETE = UInt32(6603);
      public const ERROR_LOG_INVALID_RANGE = UInt32(6604);
      public const ERROR_LOG_BLOCKS_EXHAUSTED = UInt32(6605);
      public const ERROR_LOG_READ_CONTEXT_INVALID = UInt32(6606);
      public const ERROR_LOG_RESTART_INVALID = UInt32(6607);
      public const ERROR_LOG_BLOCK_VERSION = UInt32(6608);
      public const ERROR_LOG_BLOCK_INVALID = UInt32(6609);
      public const ERROR_LOG_READ_MODE_INVALID = UInt32(6610);
      public const ERROR_LOG_NO_RESTART = UInt32(6611);
      public const ERROR_LOG_METADATA_CORRUPT = UInt32(6612);
      public const ERROR_LOG_METADATA_INVALID = UInt32(6613);
      public const ERROR_LOG_METADATA_INCONSISTENT = UInt32(6614);
      public const ERROR_LOG_RESERVATION_INVALID = UInt32(6615);
      public const ERROR_LOG_CANT_DELETE = UInt32(6616);
      public const ERROR_LOG_CONTAINER_LIMIT_EXCEEDED = UInt32(6617);
      public const ERROR_LOG_START_OF_LOG = UInt32(6618);
      public const ERROR_LOG_POLICY_ALREADY_INSTALLED = UInt32(6619);
      public const ERROR_LOG_POLICY_NOT_INSTALLED = UInt32(6620);
      public const ERROR_LOG_POLICY_INVALID = UInt32(6621);
      public const ERROR_LOG_POLICY_CONFLICT = UInt32(6622);
      public const ERROR_LOG_PINNED_ARCHIVE_TAIL = UInt32(6623);
      public const ERROR_LOG_RECORD_NONEXISTENT = UInt32(6624);
      public const ERROR_LOG_RECORDS_RESERVED_INVALID = UInt32(6625);
      public const ERROR_LOG_SPACE_RESERVED_INVALID = UInt32(6626);
      public const ERROR_LOG_TAIL_INVALID = UInt32(6627);
      public const ERROR_LOG_FULL = UInt32(6628);
      public const ERROR_COULD_NOT_RESIZE_LOG = UInt32(6629);
      public const ERROR_LOG_MULTIPLEXED = UInt32(6630);
      public const ERROR_LOG_DEDICATED = UInt32(6631);
      public const ERROR_LOG_ARCHIVE_NOT_IN_PROGRESS = UInt32(6632);
      public const ERROR_LOG_ARCHIVE_IN_PROGRESS = UInt32(6633);
      public const ERROR_LOG_EPHEMERAL = UInt32(6634);
      public const ERROR_LOG_NOT_ENOUGH_CONTAINERS = UInt32(6635);
      public const ERROR_LOG_CLIENT_ALREADY_REGISTERED = UInt32(6636);
      public const ERROR_LOG_CLIENT_NOT_REGISTERED = UInt32(6637);
      public const ERROR_LOG_FULL_HANDLER_IN_PROGRESS = UInt32(6638);
      public const ERROR_LOG_CONTAINER_READ_FAILED = UInt32(6639);
      public const ERROR_LOG_CONTAINER_WRITE_FAILED = UInt32(6640);
      public const ERROR_LOG_CONTAINER_OPEN_FAILED = UInt32(6641);
      public const ERROR_LOG_CONTAINER_STATE_INVALID = UInt32(6642);
      public const ERROR_LOG_STATE_INVALID = UInt32(6643);
      public const ERROR_LOG_PINNED = UInt32(6644);
      public const ERROR_LOG_METADATA_FLUSH_FAILED = UInt32(6645);
      public const ERROR_LOG_INCONSISTENT_SECURITY = UInt32(6646);
      public const ERROR_LOG_APPENDED_FLUSH_FAILED = UInt32(6647);
      public const ERROR_LOG_PINNED_RESERVATION = UInt32(6648);
      public const ERROR_INVALID_TRANSACTION = UInt32(6700);
      public const ERROR_TRANSACTION_NOT_ACTIVE = UInt32(6701);
      public const ERROR_TRANSACTION_REQUEST_NOT_VALID = UInt32(6702);
      public const ERROR_TRANSACTION_NOT_REQUESTED = UInt32(6703);
      public const ERROR_TRANSACTION_ALREADY_ABORTED = UInt32(6704);
      public const ERROR_TRANSACTION_ALREADY_COMMITTED = UInt32(6705);
      public const ERROR_TM_INITIALIZATION_FAILED = UInt32(6706);
      public const ERROR_RESOURCEMANAGER_READ_ONLY = UInt32(6707);
      public const ERROR_TRANSACTION_NOT_JOINED = UInt32(6708);
      public const ERROR_TRANSACTION_SUPERIOR_EXISTS = UInt32(6709);
      public const ERROR_CRM_PROTOCOL_ALREADY_EXISTS = UInt32(6710);
      public const ERROR_TRANSACTION_PROPAGATION_FAILED = UInt32(6711);
      public const ERROR_CRM_PROTOCOL_NOT_FOUND = UInt32(6712);
      public const ERROR_TRANSACTION_INVALID_MARSHALL_BUFFER = UInt32(6713);
      public const ERROR_CURRENT_TRANSACTION_NOT_VALID = UInt32(6714);
      public const ERROR_TRANSACTION_NOT_FOUND = UInt32(6715);
      public const ERROR_RESOURCEMANAGER_NOT_FOUND = UInt32(6716);
      public const ERROR_ENLISTMENT_NOT_FOUND = UInt32(6717);
      public const ERROR_TRANSACTIONMANAGER_NOT_FOUND = UInt32(6718);
      public const ERROR_TRANSACTIONMANAGER_NOT_ONLINE = UInt32(6719);
      public const ERROR_TRANSACTIONMANAGER_RECOVERY_NAME_COLLISION = UInt32(6720);
      public const ERROR_TRANSACTION_NOT_ROOT = UInt32(6721);
      public const ERROR_TRANSACTION_OBJECT_EXPIRED = UInt32(6722);
      public const ERROR_TRANSACTION_RESPONSE_NOT_ENLISTED = UInt32(6723);
      public const ERROR_TRANSACTION_RECORD_TOO_LONG = UInt32(6724);
      public const ERROR_IMPLICIT_TRANSACTION_NOT_SUPPORTED = UInt32(6725);
      public const ERROR_TRANSACTION_INTEGRITY_VIOLATED = UInt32(6726);
      public const ERROR_TRANSACTIONMANAGER_IDENTITY_MISMATCH = UInt32(6727);
      public const ERROR_RM_CANNOT_BE_FROZEN_FOR_SNAPSHOT = UInt32(6728);
      public const ERROR_TRANSACTION_MUST_WRITETHROUGH = UInt32(6729);
      public const ERROR_TRANSACTION_NO_SUPERIOR = UInt32(6730);
      public const ERROR_HEURISTIC_DAMAGE_POSSIBLE = UInt32(6731);
      public const ERROR_TRANSACTIONAL_CONFLICT = UInt32(6800);
      public const ERROR_RM_NOT_ACTIVE = UInt32(6801);
      public const ERROR_RM_METADATA_CORRUPT = UInt32(6802);
      public const ERROR_DIRECTORY_NOT_RM = UInt32(6803);
      public const ERROR_TRANSACTIONS_UNSUPPORTED_REMOTE = UInt32(6805);
      public const ERROR_LOG_RESIZE_INVALID_SIZE = UInt32(6806);
      public const ERROR_OBJECT_NO_LONGER_EXISTS = UInt32(6807);
      public const ERROR_STREAM_MINIVERSION_NOT_FOUND = UInt32(6808);
      public const ERROR_STREAM_MINIVERSION_NOT_VALID = UInt32(6809);
      public const ERROR_MINIVERSION_INACCESSIBLE_FROM_SPECIFIED_TRANSACTION = UInt32(6810);
      public const ERROR_CANT_OPEN_MINIVERSION_WITH_MODIFY_INTENT = UInt32(6811);
      public const ERROR_CANT_CREATE_MORE_STREAM_MINIVERSIONS = UInt32(6812);
      public const ERROR_REMOTE_FILE_VERSION_MISMATCH = UInt32(6814);
      public const ERROR_HANDLE_NO_LONGER_VALID = UInt32(6815);
      public const ERROR_NO_TXF_METADATA = UInt32(6816);
      public const ERROR_LOG_CORRUPTION_DETECTED = UInt32(6817);
      public const ERROR_CANT_RECOVER_WITH_HANDLE_OPEN = UInt32(6818);
      public const ERROR_RM_DISCONNECTED = UInt32(6819);
      public const ERROR_ENLISTMENT_NOT_SUPERIOR = UInt32(6820);
      public const ERROR_RECOVERY_NOT_NEEDED = UInt32(6821);
      public const ERROR_RM_ALREADY_STARTED = UInt32(6822);
      public const ERROR_FILE_IDENTITY_NOT_PERSISTENT = UInt32(6823);
      public const ERROR_CANT_BREAK_TRANSACTIONAL_DEPENDENCY = UInt32(6824);
      public const ERROR_CANT_CROSS_RM_BOUNDARY = UInt32(6825);
      public const ERROR_TXF_DIR_NOT_EMPTY = UInt32(6826);
      public const ERROR_INDOUBT_TRANSACTIONS_EXIST = UInt32(6827);
      public const ERROR_TM_VOLATILE = UInt32(6828);
      public const ERROR_ROLLBACK_TIMER_EXPIRED = UInt32(6829);
      public const ERROR_TXF_ATTRIBUTE_CORRUPT = UInt32(6830);
      public const ERROR_EFS_NOT_ALLOWED_IN_TRANSACTION = UInt32(6831);
      public const ERROR_TRANSACTIONAL_OPEN_NOT_ALLOWED = UInt32(6832);
      public const ERROR_LOG_GROWTH_FAILED = UInt32(6833);
      public const ERROR_TRANSACTED_MAPPING_UNSUPPORTED_REMOTE = UInt32(6834);
      public const ERROR_TXF_METADATA_ALREADY_PRESENT = UInt32(6835);
      public const ERROR_TRANSACTION_SCOPE_CALLBACKS_NOT_SET = UInt32(6836);
      public const ERROR_TRANSACTION_REQUIRED_PROMOTION = UInt32(6837);
      public const ERROR_CANNOT_EXECUTE_FILE_IN_TRANSACTION = UInt32(6838);
      public const ERROR_TRANSACTIONS_NOT_FROZEN = UInt32(6839);
      public const ERROR_TRANSACTION_FREEZE_IN_PROGRESS = UInt32(6840);
      public const ERROR_NOT_SNAPSHOT_VOLUME = UInt32(6841);
      public const ERROR_NO_SAVEPOINT_WITH_OPEN_FILES = UInt32(6842);
      public const ERROR_DATA_LOST_REPAIR = UInt32(6843);
      public const ERROR_SPARSE_NOT_ALLOWED_IN_TRANSACTION = UInt32(6844);
      public const ERROR_TM_IDENTITY_MISMATCH = UInt32(6845);
      public const ERROR_FLOATED_SECTION = UInt32(6846);
      public const ERROR_CANNOT_ACCEPT_TRANSACTED_WORK = UInt32(6847);
      public const ERROR_CANNOT_ABORT_TRANSACTIONS = UInt32(6848);
      public const ERROR_BAD_CLUSTERS = UInt32(6849);
      public const ERROR_COMPRESSION_NOT_ALLOWED_IN_TRANSACTION = UInt32(6850);
      public const ERROR_VOLUME_DIRTY = UInt32(6851);
      public const ERROR_NO_LINK_TRACKING_IN_TRANSACTION = UInt32(6852);
      public const ERROR_OPERATION_NOT_SUPPORTED_IN_TRANSACTION = UInt32(6853);
      public const ERROR_EXPIRED_HANDLE = UInt32(6854);
      public const ERROR_TRANSACTION_NOT_ENLISTED = UInt32(6855);
      public const ERROR_CTX_WINSTATION_NAME_INVALID = UInt32(7001);
      public const ERROR_CTX_INVALID_PD = UInt32(7002);
      public const ERROR_CTX_PD_NOT_FOUND = UInt32(7003);
      public const ERROR_CTX_WD_NOT_FOUND = UInt32(7004);
      public const ERROR_CTX_CANNOT_MAKE_EVENTLOG_ENTRY = UInt32(7005);
      public const ERROR_CTX_SERVICE_NAME_COLLISION = UInt32(7006);
      public const ERROR_CTX_CLOSE_PENDING = UInt32(7007);
      public const ERROR_CTX_NO_OUTBUF = UInt32(7008);
      public const ERROR_CTX_MODEM_INF_NOT_FOUND = UInt32(7009);
      public const ERROR_CTX_INVALID_MODEMNAME = UInt32(7010);
      public const ERROR_CTX_MODEM_RESPONSE_ERROR = UInt32(7011);
      public const ERROR_CTX_MODEM_RESPONSE_TIMEOUT = UInt32(7012);
      public const ERROR_CTX_MODEM_RESPONSE_NO_CARRIER = UInt32(7013);
      public const ERROR_CTX_MODEM_RESPONSE_NO_DIALTONE = UInt32(7014);
      public const ERROR_CTX_MODEM_RESPONSE_BUSY = UInt32(7015);
      public const ERROR_CTX_MODEM_RESPONSE_VOICE = UInt32(7016);
      public const ERROR_CTX_TD_ERROR = UInt32(7017);
      public const ERROR_CTX_WINSTATION_NOT_FOUND = UInt32(7022);
      public const ERROR_CTX_WINSTATION_ALREADY_EXISTS = UInt32(7023);
      public const ERROR_CTX_WINSTATION_BUSY = UInt32(7024);
      public const ERROR_CTX_BAD_VIDEO_MODE = UInt32(7025);
      public const ERROR_CTX_GRAPHICS_INVALID = UInt32(7035);
      public const ERROR_CTX_LOGON_DISABLED = UInt32(7037);
      public const ERROR_CTX_NOT_CONSOLE = UInt32(7038);
      public const ERROR_CTX_CLIENT_QUERY_TIMEOUT = UInt32(7040);
      public const ERROR_CTX_CONSOLE_DISCONNECT = UInt32(7041);
      public const ERROR_CTX_CONSOLE_CONNECT = UInt32(7042);
      public const ERROR_CTX_SHADOW_DENIED = UInt32(7044);
      public const ERROR_CTX_WINSTATION_ACCESS_DENIED = UInt32(7045);
      public const ERROR_CTX_INVALID_WD = UInt32(7049);
      public const ERROR_CTX_SHADOW_INVALID = UInt32(7050);
      public const ERROR_CTX_SHADOW_DISABLED = UInt32(7051);
      public const ERROR_CTX_CLIENT_LICENSE_IN_USE = UInt32(7052);
      public const ERROR_CTX_CLIENT_LICENSE_NOT_SET = UInt32(7053);
      public const ERROR_CTX_LICENSE_NOT_AVAILABLE = UInt32(7054);
      public const ERROR_CTX_LICENSE_CLIENT_INVALID = UInt32(7055);
      public const ERROR_CTX_LICENSE_EXPIRED = UInt32(7056);
      public const ERROR_CTX_SHADOW_NOT_RUNNING = UInt32(7057);
      public const ERROR_CTX_SHADOW_ENDED_BY_MODE_CHANGE = UInt32(7058);
      public const ERROR_ACTIVATION_COUNT_EXCEEDED = UInt32(7059);
      public const ERROR_CTX_WINSTATIONS_DISABLED = UInt32(7060);
      public const ERROR_CTX_ENCRYPTION_LEVEL_REQUIRED = UInt32(7061);
      public const ERROR_CTX_SESSION_IN_USE = UInt32(7062);
      public const ERROR_CTX_NO_FORCE_LOGOFF = UInt32(7063);
      public const ERROR_CTX_ACCOUNT_RESTRICTION = UInt32(7064);
      public const ERROR_RDP_PROTOCOL_ERROR = UInt32(7065);
      public const ERROR_CTX_CDM_CONNECT = UInt32(7066);
      public const ERROR_CTX_CDM_DISCONNECT = UInt32(7067);
      public const ERROR_CTX_SECURITY_LAYER_ERROR = UInt32(7068);
      public const ERROR_TS_INCOMPATIBLE_SESSIONS = UInt32(7069);
      public const ERROR_TS_VIDEO_SUBSYSTEM_ERROR = UInt32(7070);
      public const ERROR_DS_NOT_INSTALLED = UInt32(8200);
      public const ERROR_DS_MEMBERSHIP_EVALUATED_LOCALLY = UInt32(8201);
      public const ERROR_DS_NO_ATTRIBUTE_OR_VALUE = UInt32(8202);
      public const ERROR_DS_INVALID_ATTRIBUTE_SYNTAX = UInt32(8203);
      public const ERROR_DS_ATTRIBUTE_TYPE_UNDEFINED = UInt32(8204);
      public const ERROR_DS_ATTRIBUTE_OR_VALUE_EXISTS = UInt32(8205);
      public const ERROR_DS_BUSY = UInt32(8206);
      public const ERROR_DS_UNAVAILABLE = UInt32(8207);
      public const ERROR_DS_NO_RIDS_ALLOCATED = UInt32(8208);
      public const ERROR_DS_NO_MORE_RIDS = UInt32(8209);
      public const ERROR_DS_INCORRECT_ROLE_OWNER = UInt32(8210);
      public const ERROR_DS_RIDMGR_INIT_ERROR = UInt32(8211);
      public const ERROR_DS_OBJ_CLASS_VIOLATION = UInt32(8212);
      public const ERROR_DS_CANT_ON_NON_LEAF = UInt32(8213);
      public const ERROR_DS_CANT_ON_RDN = UInt32(8214);
      public const ERROR_DS_CANT_MOD_OBJ_CLASS = UInt32(8215);
      public const ERROR_DS_CROSS_DOM_MOVE_ERROR = UInt32(8216);
      public const ERROR_DS_GC_NOT_AVAILABLE = UInt32(8217);
      public const ERROR_SHARED_POLICY = UInt32(8218);
      public const ERROR_POLICY_OBJECT_NOT_FOUND = UInt32(8219);
      public const ERROR_POLICY_ONLY_IN_DS = UInt32(8220);
      public const ERROR_PROMOTION_ACTIVE = UInt32(8221);
      public const ERROR_NO_PROMOTION_ACTIVE = UInt32(8222);
      public const ERROR_DS_OPERATIONS_ERROR = UInt32(8224);
      public const ERROR_DS_PROTOCOL_ERROR = UInt32(8225);
      public const ERROR_DS_TIMELIMIT_EXCEEDED = UInt32(8226);
      public const ERROR_DS_SIZELIMIT_EXCEEDED = UInt32(8227);
      public const ERROR_DS_ADMIN_LIMIT_EXCEEDED = UInt32(8228);
      public const ERROR_DS_COMPARE_FALSE = UInt32(8229);
      public const ERROR_DS_COMPARE_TRUE = UInt32(8230);
      public const ERROR_DS_AUTH_METHOD_NOT_SUPPORTED = UInt32(8231);
      public const ERROR_DS_STRONG_AUTH_REQUIRED = UInt32(8232);
      public const ERROR_DS_INAPPROPRIATE_AUTH = UInt32(8233);
      public const ERROR_DS_AUTH_UNKNOWN = UInt32(8234);
      public const ERROR_DS_REFERRAL = UInt32(8235);
      public const ERROR_DS_UNAVAILABLE_CRIT_EXTENSION = UInt32(8236);
      public const ERROR_DS_CONFIDENTIALITY_REQUIRED = UInt32(8237);
      public const ERROR_DS_INAPPROPRIATE_MATCHING = UInt32(8238);
      public const ERROR_DS_CONSTRAINT_VIOLATION = UInt32(8239);
      public const ERROR_DS_NO_SUCH_OBJECT = UInt32(8240);
      public const ERROR_DS_ALIAS_PROBLEM = UInt32(8241);
      public const ERROR_DS_INVALID_DN_SYNTAX = UInt32(8242);
      public const ERROR_DS_IS_LEAF = UInt32(8243);
      public const ERROR_DS_ALIAS_DEREF_PROBLEM = UInt32(8244);
      public const ERROR_DS_UNWILLING_TO_PERFORM = UInt32(8245);
      public const ERROR_DS_LOOP_DETECT = UInt32(8246);
      public const ERROR_DS_NAMING_VIOLATION = UInt32(8247);
      public const ERROR_DS_OBJECT_RESULTS_TOO_LARGE = UInt32(8248);
      public const ERROR_DS_AFFECTS_MULTIPLE_DSAS = UInt32(8249);
      public const ERROR_DS_SERVER_DOWN = UInt32(8250);
      public const ERROR_DS_LOCAL_ERROR = UInt32(8251);
      public const ERROR_DS_ENCODING_ERROR = UInt32(8252);
      public const ERROR_DS_DECODING_ERROR = UInt32(8253);
      public const ERROR_DS_FILTER_UNKNOWN = UInt32(8254);
      public const ERROR_DS_PARAM_ERROR = UInt32(8255);
      public const ERROR_DS_NOT_SUPPORTED = UInt32(8256);
      public const ERROR_DS_NO_RESULTS_RETURNED = UInt32(8257);
      public const ERROR_DS_CONTROL_NOT_FOUND = UInt32(8258);
      public const ERROR_DS_CLIENT_LOOP = UInt32(8259);
      public const ERROR_DS_REFERRAL_LIMIT_EXCEEDED = UInt32(8260);
      public const ERROR_DS_SORT_CONTROL_MISSING = UInt32(8261);
      public const ERROR_DS_OFFSET_RANGE_ERROR = UInt32(8262);
      public const ERROR_DS_RIDMGR_DISABLED = UInt32(8263);
      public const ERROR_DS_ROOT_MUST_BE_NC = UInt32(8301);
      public const ERROR_DS_ADD_REPLICA_INHIBITED = UInt32(8302);
      public const ERROR_DS_ATT_NOT_DEF_IN_SCHEMA = UInt32(8303);
      public const ERROR_DS_MAX_OBJ_SIZE_EXCEEDED = UInt32(8304);
      public const ERROR_DS_OBJ_STRING_NAME_EXISTS = UInt32(8305);
      public const ERROR_DS_NO_RDN_DEFINED_IN_SCHEMA = UInt32(8306);
      public const ERROR_DS_RDN_DOESNT_MATCH_SCHEMA = UInt32(8307);
      public const ERROR_DS_NO_REQUESTED_ATTS_FOUND = UInt32(8308);
      public const ERROR_DS_USER_BUFFER_TO_SMALL = UInt32(8309);
      public const ERROR_DS_ATT_IS_NOT_ON_OBJ = UInt32(8310);
      public const ERROR_DS_ILLEGAL_MOD_OPERATION = UInt32(8311);
      public const ERROR_DS_OBJ_TOO_LARGE = UInt32(8312);
      public const ERROR_DS_BAD_INSTANCE_TYPE = UInt32(8313);
      public const ERROR_DS_MASTERDSA_REQUIRED = UInt32(8314);
      public const ERROR_DS_OBJECT_CLASS_REQUIRED = UInt32(8315);
      public const ERROR_DS_MISSING_REQUIRED_ATT = UInt32(8316);
      public const ERROR_DS_ATT_NOT_DEF_FOR_CLASS = UInt32(8317);
      public const ERROR_DS_ATT_ALREADY_EXISTS = UInt32(8318);
      public const ERROR_DS_CANT_ADD_ATT_VALUES = UInt32(8320);
      public const ERROR_DS_SINGLE_VALUE_CONSTRAINT = UInt32(8321);
      public const ERROR_DS_RANGE_CONSTRAINT = UInt32(8322);
      public const ERROR_DS_ATT_VAL_ALREADY_EXISTS = UInt32(8323);
      public const ERROR_DS_CANT_REM_MISSING_ATT = UInt32(8324);
      public const ERROR_DS_CANT_REM_MISSING_ATT_VAL = UInt32(8325);
      public const ERROR_DS_ROOT_CANT_BE_SUBREF = UInt32(8326);
      public const ERROR_DS_NO_CHAINING = UInt32(8327);
      public const ERROR_DS_NO_CHAINED_EVAL = UInt32(8328);
      public const ERROR_DS_NO_PARENT_OBJECT = UInt32(8329);
      public const ERROR_DS_PARENT_IS_AN_ALIAS = UInt32(8330);
      public const ERROR_DS_CANT_MIX_MASTER_AND_REPS = UInt32(8331);
      public const ERROR_DS_CHILDREN_EXIST = UInt32(8332);
      public const ERROR_DS_OBJ_NOT_FOUND = UInt32(8333);
      public const ERROR_DS_ALIASED_OBJ_MISSING = UInt32(8334);
      public const ERROR_DS_BAD_NAME_SYNTAX = UInt32(8335);
      public const ERROR_DS_ALIAS_POINTS_TO_ALIAS = UInt32(8336);
      public const ERROR_DS_CANT_DEREF_ALIAS = UInt32(8337);
      public const ERROR_DS_OUT_OF_SCOPE = UInt32(8338);
      public const ERROR_DS_OBJECT_BEING_REMOVED = UInt32(8339);
      public const ERROR_DS_CANT_DELETE_DSA_OBJ = UInt32(8340);
      public const ERROR_DS_GENERIC_ERROR = UInt32(8341);
      public const ERROR_DS_DSA_MUST_BE_INT_MASTER = UInt32(8342);
      public const ERROR_DS_CLASS_NOT_DSA = UInt32(8343);
      public const ERROR_DS_INSUFF_ACCESS_RIGHTS = UInt32(8344);
      public const ERROR_DS_ILLEGAL_SUPERIOR = UInt32(8345);
      public const ERROR_DS_ATTRIBUTE_OWNED_BY_SAM = UInt32(8346);
      public const ERROR_DS_NAME_TOO_MANY_PARTS = UInt32(8347);
      public const ERROR_DS_NAME_TOO_LONG = UInt32(8348);
      public const ERROR_DS_NAME_VALUE_TOO_LONG = UInt32(8349);
      public const ERROR_DS_NAME_UNPARSEABLE = UInt32(8350);
      public const ERROR_DS_NAME_TYPE_UNKNOWN = UInt32(8351);
      public const ERROR_DS_NOT_AN_OBJECT = UInt32(8352);
      public const ERROR_DS_SEC_DESC_TOO_SHORT = UInt32(8353);
      public const ERROR_DS_SEC_DESC_INVALID = UInt32(8354);
      public const ERROR_DS_NO_DELETED_NAME = UInt32(8355);
      public const ERROR_DS_SUBREF_MUST_HAVE_PARENT = UInt32(8356);
      public const ERROR_DS_NCNAME_MUST_BE_NC = UInt32(8357);
      public const ERROR_DS_CANT_ADD_SYSTEM_ONLY = UInt32(8358);
      public const ERROR_DS_CLASS_MUST_BE_CONCRETE = UInt32(8359);
      public const ERROR_DS_INVALID_DMD = UInt32(8360);
      public const ERROR_DS_OBJ_GUID_EXISTS = UInt32(8361);
      public const ERROR_DS_NOT_ON_BACKLINK = UInt32(8362);
      public const ERROR_DS_NO_CROSSREF_FOR_NC = UInt32(8363);
      public const ERROR_DS_SHUTTING_DOWN = UInt32(8364);
      public const ERROR_DS_UNKNOWN_OPERATION = UInt32(8365);
      public const ERROR_DS_INVALID_ROLE_OWNER = UInt32(8366);
      public const ERROR_DS_COULDNT_CONTACT_FSMO = UInt32(8367);
      public const ERROR_DS_CROSS_NC_DN_RENAME = UInt32(8368);
      public const ERROR_DS_CANT_MOD_SYSTEM_ONLY = UInt32(8369);
      public const ERROR_DS_REPLICATOR_ONLY = UInt32(8370);
      public const ERROR_DS_OBJ_CLASS_NOT_DEFINED = UInt32(8371);
      public const ERROR_DS_OBJ_CLASS_NOT_SUBCLASS = UInt32(8372);
      public const ERROR_DS_NAME_REFERENCE_INVALID = UInt32(8373);
      public const ERROR_DS_CROSS_REF_EXISTS = UInt32(8374);
      public const ERROR_DS_CANT_DEL_MASTER_CROSSREF = UInt32(8375);
      public const ERROR_DS_SUBTREE_NOTIFY_NOT_NC_HEAD = UInt32(8376);
      public const ERROR_DS_NOTIFY_FILTER_TOO_COMPLEX = UInt32(8377);
      public const ERROR_DS_DUP_RDN = UInt32(8378);
      public const ERROR_DS_DUP_OID = UInt32(8379);
      public const ERROR_DS_DUP_MAPI_ID = UInt32(8380);
      public const ERROR_DS_DUP_SCHEMA_ID_GUID = UInt32(8381);
      public const ERROR_DS_DUP_LDAP_DISPLAY_NAME = UInt32(8382);
      public const ERROR_DS_SEMANTIC_ATT_TEST = UInt32(8383);
      public const ERROR_DS_SYNTAX_MISMATCH = UInt32(8384);
      public const ERROR_DS_EXISTS_IN_MUST_HAVE = UInt32(8385);
      public const ERROR_DS_EXISTS_IN_MAY_HAVE = UInt32(8386);
      public const ERROR_DS_NONEXISTENT_MAY_HAVE = UInt32(8387);
      public const ERROR_DS_NONEXISTENT_MUST_HAVE = UInt32(8388);
      public const ERROR_DS_AUX_CLS_TEST_FAIL = UInt32(8389);
      public const ERROR_DS_NONEXISTENT_POSS_SUP = UInt32(8390);
      public const ERROR_DS_SUB_CLS_TEST_FAIL = UInt32(8391);
      public const ERROR_DS_BAD_RDN_ATT_ID_SYNTAX = UInt32(8392);
      public const ERROR_DS_EXISTS_IN_AUX_CLS = UInt32(8393);
      public const ERROR_DS_EXISTS_IN_SUB_CLS = UInt32(8394);
      public const ERROR_DS_EXISTS_IN_POSS_SUP = UInt32(8395);
      public const ERROR_DS_RECALCSCHEMA_FAILED = UInt32(8396);
      public const ERROR_DS_TREE_DELETE_NOT_FINISHED = UInt32(8397);
      public const ERROR_DS_CANT_DELETE = UInt32(8398);
      public const ERROR_DS_ATT_SCHEMA_REQ_ID = UInt32(8399);
      public const ERROR_DS_BAD_ATT_SCHEMA_SYNTAX = UInt32(8400);
      public const ERROR_DS_CANT_CACHE_ATT = UInt32(8401);
      public const ERROR_DS_CANT_CACHE_CLASS = UInt32(8402);
      public const ERROR_DS_CANT_REMOVE_ATT_CACHE = UInt32(8403);
      public const ERROR_DS_CANT_REMOVE_CLASS_CACHE = UInt32(8404);
      public const ERROR_DS_CANT_RETRIEVE_DN = UInt32(8405);
      public const ERROR_DS_MISSING_SUPREF = UInt32(8406);
      public const ERROR_DS_CANT_RETRIEVE_INSTANCE = UInt32(8407);
      public const ERROR_DS_CODE_INCONSISTENCY = UInt32(8408);
      public const ERROR_DS_DATABASE_ERROR = UInt32(8409);
      public const ERROR_DS_GOVERNSID_MISSING = UInt32(8410);
      public const ERROR_DS_MISSING_EXPECTED_ATT = UInt32(8411);
      public const ERROR_DS_NCNAME_MISSING_CR_REF = UInt32(8412);
      public const ERROR_DS_SECURITY_CHECKING_ERROR = UInt32(8413);
      public const ERROR_DS_SCHEMA_NOT_LOADED = UInt32(8414);
      public const ERROR_DS_SCHEMA_ALLOC_FAILED = UInt32(8415);
      public const ERROR_DS_ATT_SCHEMA_REQ_SYNTAX = UInt32(8416);
      public const ERROR_DS_GCVERIFY_ERROR = UInt32(8417);
      public const ERROR_DS_DRA_SCHEMA_MISMATCH = UInt32(8418);
      public const ERROR_DS_CANT_FIND_DSA_OBJ = UInt32(8419);
      public const ERROR_DS_CANT_FIND_EXPECTED_NC = UInt32(8420);
      public const ERROR_DS_CANT_FIND_NC_IN_CACHE = UInt32(8421);
      public const ERROR_DS_CANT_RETRIEVE_CHILD = UInt32(8422);
      public const ERROR_DS_SECURITY_ILLEGAL_MODIFY = UInt32(8423);
      public const ERROR_DS_CANT_REPLACE_HIDDEN_REC = UInt32(8424);
      public const ERROR_DS_BAD_HIERARCHY_FILE = UInt32(8425);
      public const ERROR_DS_BUILD_HIERARCHY_TABLE_FAILED = UInt32(8426);
      public const ERROR_DS_CONFIG_PARAM_MISSING = UInt32(8427);
      public const ERROR_DS_COUNTING_AB_INDICES_FAILED = UInt32(8428);
      public const ERROR_DS_HIERARCHY_TABLE_MALLOC_FAILED = UInt32(8429);
      public const ERROR_DS_INTERNAL_FAILURE = UInt32(8430);
      public const ERROR_DS_UNKNOWN_ERROR = UInt32(8431);
      public const ERROR_DS_ROOT_REQUIRES_CLASS_TOP = UInt32(8432);
      public const ERROR_DS_REFUSING_FSMO_ROLES = UInt32(8433);
      public const ERROR_DS_MISSING_FSMO_SETTINGS = UInt32(8434);
      public const ERROR_DS_UNABLE_TO_SURRENDER_ROLES = UInt32(8435);
      public const ERROR_DS_DRA_GENERIC = UInt32(8436);
      public const ERROR_DS_DRA_INVALID_PARAMETER = UInt32(8437);
      public const ERROR_DS_DRA_BUSY = UInt32(8438);
      public const ERROR_DS_DRA_BAD_DN = UInt32(8439);
      public const ERROR_DS_DRA_BAD_NC = UInt32(8440);
      public const ERROR_DS_DRA_DN_EXISTS = UInt32(8441);
      public const ERROR_DS_DRA_INTERNAL_ERROR = UInt32(8442);
      public const ERROR_DS_DRA_INCONSISTENT_DIT = UInt32(8443);
      public const ERROR_DS_DRA_CONNECTION_FAILED = UInt32(8444);
      public const ERROR_DS_DRA_BAD_INSTANCE_TYPE = UInt32(8445);
      public const ERROR_DS_DRA_OUT_OF_MEM = UInt32(8446);
      public const ERROR_DS_DRA_MAIL_PROBLEM = UInt32(8447);
      public const ERROR_DS_DRA_REF_ALREADY_EXISTS = UInt32(8448);
      public const ERROR_DS_DRA_REF_NOT_FOUND = UInt32(8449);
      public const ERROR_DS_DRA_OBJ_IS_REP_SOURCE = UInt32(8450);
      public const ERROR_DS_DRA_DB_ERROR = UInt32(8451);
      public const ERROR_DS_DRA_NO_REPLICA = UInt32(8452);
      public const ERROR_DS_DRA_ACCESS_DENIED = UInt32(8453);
      public const ERROR_DS_DRA_NOT_SUPPORTED = UInt32(8454);
      public const ERROR_DS_DRA_RPC_CANCELLED = UInt32(8455);
      public const ERROR_DS_DRA_SOURCE_DISABLED = UInt32(8456);
      public const ERROR_DS_DRA_SINK_DISABLED = UInt32(8457);
      public const ERROR_DS_DRA_NAME_COLLISION = UInt32(8458);
      public const ERROR_DS_DRA_SOURCE_REINSTALLED = UInt32(8459);
      public const ERROR_DS_DRA_MISSING_PARENT = UInt32(8460);
      public const ERROR_DS_DRA_PREEMPTED = UInt32(8461);
      public const ERROR_DS_DRA_ABANDON_SYNC = UInt32(8462);
      public const ERROR_DS_DRA_SHUTDOWN = UInt32(8463);
      public const ERROR_DS_DRA_INCOMPATIBLE_PARTIAL_SET = UInt32(8464);
      public const ERROR_DS_DRA_SOURCE_IS_PARTIAL_REPLICA = UInt32(8465);
      public const ERROR_DS_DRA_EXTN_CONNECTION_FAILED = UInt32(8466);
      public const ERROR_DS_INSTALL_SCHEMA_MISMATCH = UInt32(8467);
      public const ERROR_DS_DUP_LINK_ID = UInt32(8468);
      public const ERROR_DS_NAME_ERROR_RESOLVING = UInt32(8469);
      public const ERROR_DS_NAME_ERROR_NOT_FOUND = UInt32(8470);
      public const ERROR_DS_NAME_ERROR_NOT_UNIQUE = UInt32(8471);
      public const ERROR_DS_NAME_ERROR_NO_MAPPING = UInt32(8472);
      public const ERROR_DS_NAME_ERROR_DOMAIN_ONLY = UInt32(8473);
      public const ERROR_DS_NAME_ERROR_NO_SYNTACTICAL_MAPPING = UInt32(8474);
      public const ERROR_DS_CONSTRUCTED_ATT_MOD = UInt32(8475);
      public const ERROR_DS_WRONG_OM_OBJ_CLASS = UInt32(8476);
      public const ERROR_DS_DRA_REPL_PENDING = UInt32(8477);
      public const ERROR_DS_DS_REQUIRED = UInt32(8478);
      public const ERROR_DS_INVALID_LDAP_DISPLAY_NAME = UInt32(8479);
      public const ERROR_DS_NON_BASE_SEARCH = UInt32(8480);
      public const ERROR_DS_CANT_RETRIEVE_ATTS = UInt32(8481);
      public const ERROR_DS_BACKLINK_WITHOUT_LINK = UInt32(8482);
      public const ERROR_DS_EPOCH_MISMATCH = UInt32(8483);
      public const ERROR_DS_SRC_NAME_MISMATCH = UInt32(8484);
      public const ERROR_DS_SRC_AND_DST_NC_IDENTICAL = UInt32(8485);
      public const ERROR_DS_DST_NC_MISMATCH = UInt32(8486);
      public const ERROR_DS_NOT_AUTHORITIVE_FOR_DST_NC = UInt32(8487);
      public const ERROR_DS_SRC_GUID_MISMATCH = UInt32(8488);
      public const ERROR_DS_CANT_MOVE_DELETED_OBJECT = UInt32(8489);
      public const ERROR_DS_PDC_OPERATION_IN_PROGRESS = UInt32(8490);
      public const ERROR_DS_CROSS_DOMAIN_CLEANUP_REQD = UInt32(8491);
      public const ERROR_DS_ILLEGAL_XDOM_MOVE_OPERATION = UInt32(8492);
      public const ERROR_DS_CANT_WITH_ACCT_GROUP_MEMBERSHPS = UInt32(8493);
      public const ERROR_DS_NC_MUST_HAVE_NC_PARENT = UInt32(8494);
      public const ERROR_DS_CR_IMPOSSIBLE_TO_VALIDATE = UInt32(8495);
      public const ERROR_DS_DST_DOMAIN_NOT_NATIVE = UInt32(8496);
      public const ERROR_DS_MISSING_INFRASTRUCTURE_CONTAINER = UInt32(8497);
      public const ERROR_DS_CANT_MOVE_ACCOUNT_GROUP = UInt32(8498);
      public const ERROR_DS_CANT_MOVE_RESOURCE_GROUP = UInt32(8499);
      public const ERROR_DS_INVALID_SEARCH_FLAG = UInt32(8500);
      public const ERROR_DS_NO_TREE_DELETE_ABOVE_NC = UInt32(8501);
      public const ERROR_DS_COULDNT_LOCK_TREE_FOR_DELETE = UInt32(8502);
      public const ERROR_DS_COULDNT_IDENTIFY_OBJECTS_FOR_TREE_DELETE = UInt32(8503);
      public const ERROR_DS_SAM_INIT_FAILURE = UInt32(8504);
      public const ERROR_DS_SENSITIVE_GROUP_VIOLATION = UInt32(8505);
      public const ERROR_DS_CANT_MOD_PRIMARYGROUPID = UInt32(8506);
      public const ERROR_DS_ILLEGAL_BASE_SCHEMA_MOD = UInt32(8507);
      public const ERROR_DS_NONSAFE_SCHEMA_CHANGE = UInt32(8508);
      public const ERROR_DS_SCHEMA_UPDATE_DISALLOWED = UInt32(8509);
      public const ERROR_DS_CANT_CREATE_UNDER_SCHEMA = UInt32(8510);
      public const ERROR_DS_INSTALL_NO_SRC_SCH_VERSION = UInt32(8511);
      public const ERROR_DS_INSTALL_NO_SCH_VERSION_IN_INIFILE = UInt32(8512);
      public const ERROR_DS_INVALID_GROUP_TYPE = UInt32(8513);
      public const ERROR_DS_NO_NEST_GLOBALGROUP_IN_MIXEDDOMAIN = UInt32(8514);
      public const ERROR_DS_NO_NEST_LOCALGROUP_IN_MIXEDDOMAIN = UInt32(8515);
      public const ERROR_DS_GLOBAL_CANT_HAVE_LOCAL_MEMBER = UInt32(8516);
      public const ERROR_DS_GLOBAL_CANT_HAVE_UNIVERSAL_MEMBER = UInt32(8517);
      public const ERROR_DS_UNIVERSAL_CANT_HAVE_LOCAL_MEMBER = UInt32(8518);
      public const ERROR_DS_GLOBAL_CANT_HAVE_CROSSDOMAIN_MEMBER = UInt32(8519);
      public const ERROR_DS_LOCAL_CANT_HAVE_CROSSDOMAIN_LOCAL_MEMBER = UInt32(8520);
      public const ERROR_DS_HAVE_PRIMARY_MEMBERS = UInt32(8521);
      public const ERROR_DS_STRING_SD_CONVERSION_FAILED = UInt32(8522);
      public const ERROR_DS_NAMING_MASTER_GC = UInt32(8523);
      public const ERROR_DS_DNS_LOOKUP_FAILURE = UInt32(8524);
      public const ERROR_DS_COULDNT_UPDATE_SPNS = UInt32(8525);
      public const ERROR_DS_CANT_RETRIEVE_SD = UInt32(8526);
      public const ERROR_DS_KEY_NOT_UNIQUE = UInt32(8527);
      public const ERROR_DS_WRONG_LINKED_ATT_SYNTAX = UInt32(8528);
      public const ERROR_DS_SAM_NEED_BOOTKEY_PASSWORD = UInt32(8529);
      public const ERROR_DS_SAM_NEED_BOOTKEY_FLOPPY = UInt32(8530);
      public const ERROR_DS_CANT_START = UInt32(8531);
      public const ERROR_DS_INIT_FAILURE = UInt32(8532);
      public const ERROR_DS_NO_PKT_PRIVACY_ON_CONNECTION = UInt32(8533);
      public const ERROR_DS_SOURCE_DOMAIN_IN_FOREST = UInt32(8534);
      public const ERROR_DS_DESTINATION_DOMAIN_NOT_IN_FOREST = UInt32(8535);
      public const ERROR_DS_DESTINATION_AUDITING_NOT_ENABLED = UInt32(8536);
      public const ERROR_DS_CANT_FIND_DC_FOR_SRC_DOMAIN = UInt32(8537);
      public const ERROR_DS_SRC_OBJ_NOT_GROUP_OR_USER = UInt32(8538);
      public const ERROR_DS_SRC_SID_EXISTS_IN_FOREST = UInt32(8539);
      public const ERROR_DS_SRC_AND_DST_OBJECT_CLASS_MISMATCH = UInt32(8540);
      public const ERROR_SAM_INIT_FAILURE = UInt32(8541);
      public const ERROR_DS_DRA_SCHEMA_INFO_SHIP = UInt32(8542);
      public const ERROR_DS_DRA_SCHEMA_CONFLICT = UInt32(8543);
      public const ERROR_DS_DRA_EARLIER_SCHEMA_CONFLICT = UInt32(8544);
      public const ERROR_DS_DRA_OBJ_NC_MISMATCH = UInt32(8545);
      public const ERROR_DS_NC_STILL_HAS_DSAS = UInt32(8546);
      public const ERROR_DS_GC_REQUIRED = UInt32(8547);
      public const ERROR_DS_LOCAL_MEMBER_OF_LOCAL_ONLY = UInt32(8548);
      public const ERROR_DS_NO_FPO_IN_UNIVERSAL_GROUPS = UInt32(8549);
      public const ERROR_DS_CANT_ADD_TO_GC = UInt32(8550);
      public const ERROR_DS_NO_CHECKPOINT_WITH_PDC = UInt32(8551);
      public const ERROR_DS_SOURCE_AUDITING_NOT_ENABLED = UInt32(8552);
      public const ERROR_DS_CANT_CREATE_IN_NONDOMAIN_NC = UInt32(8553);
      public const ERROR_DS_INVALID_NAME_FOR_SPN = UInt32(8554);
      public const ERROR_DS_FILTER_USES_CONTRUCTED_ATTRS = UInt32(8555);
      public const ERROR_DS_UNICODEPWD_NOT_IN_QUOTES = UInt32(8556);
      public const ERROR_DS_MACHINE_ACCOUNT_QUOTA_EXCEEDED = UInt32(8557);
      public const ERROR_DS_MUST_BE_RUN_ON_DST_DC = UInt32(8558);
      public const ERROR_DS_SRC_DC_MUST_BE_SP4_OR_GREATER = UInt32(8559);
      public const ERROR_DS_CANT_TREE_DELETE_CRITICAL_OBJ = UInt32(8560);
      public const ERROR_DS_INIT_FAILURE_CONSOLE = UInt32(8561);
      public const ERROR_DS_SAM_INIT_FAILURE_CONSOLE = UInt32(8562);
      public const ERROR_DS_FOREST_VERSION_TOO_HIGH = UInt32(8563);
      public const ERROR_DS_DOMAIN_VERSION_TOO_HIGH = UInt32(8564);
      public const ERROR_DS_FOREST_VERSION_TOO_LOW = UInt32(8565);
      public const ERROR_DS_DOMAIN_VERSION_TOO_LOW = UInt32(8566);
      public const ERROR_DS_INCOMPATIBLE_VERSION = UInt32(8567);
      public const ERROR_DS_LOW_DSA_VERSION = UInt32(8568);
      public const ERROR_DS_NO_BEHAVIOR_VERSION_IN_MIXEDDOMAIN = UInt32(8569);
      public const ERROR_DS_NOT_SUPPORTED_SORT_ORDER = UInt32(8570);
      public const ERROR_DS_NAME_NOT_UNIQUE = UInt32(8571);
      public const ERROR_DS_MACHINE_ACCOUNT_CREATED_PRENT4 = UInt32(8572);
      public const ERROR_DS_OUT_OF_VERSION_STORE = UInt32(8573);
      public const ERROR_DS_INCOMPATIBLE_CONTROLS_USED = UInt32(8574);
      public const ERROR_DS_NO_REF_DOMAIN = UInt32(8575);
      public const ERROR_DS_RESERVED_LINK_ID = UInt32(8576);
      public const ERROR_DS_LINK_ID_NOT_AVAILABLE = UInt32(8577);
      public const ERROR_DS_AG_CANT_HAVE_UNIVERSAL_MEMBER = UInt32(8578);
      public const ERROR_DS_MODIFYDN_DISALLOWED_BY_INSTANCE_TYPE = UInt32(8579);
      public const ERROR_DS_NO_OBJECT_MOVE_IN_SCHEMA_NC = UInt32(8580);
      public const ERROR_DS_MODIFYDN_DISALLOWED_BY_FLAG = UInt32(8581);
      public const ERROR_DS_MODIFYDN_WRONG_GRANDPARENT = UInt32(8582);
      public const ERROR_DS_NAME_ERROR_TRUST_REFERRAL = UInt32(8583);
      public const ERROR_NOT_SUPPORTED_ON_STANDARD_SERVER = UInt32(8584);
      public const ERROR_DS_CANT_ACCESS_REMOTE_PART_OF_AD = UInt32(8585);
      public const ERROR_DS_CR_IMPOSSIBLE_TO_VALIDATE_V2 = UInt32(8586);
      public const ERROR_DS_THREAD_LIMIT_EXCEEDED = UInt32(8587);
      public const ERROR_DS_NOT_CLOSEST = UInt32(8588);
      public const ERROR_DS_CANT_DERIVE_SPN_WITHOUT_SERVER_REF = UInt32(8589);
      public const ERROR_DS_SINGLE_USER_MODE_FAILED = UInt32(8590);
      public const ERROR_DS_NTDSCRIPT_SYNTAX_ERROR = UInt32(8591);
      public const ERROR_DS_NTDSCRIPT_PROCESS_ERROR = UInt32(8592);
      public const ERROR_DS_DIFFERENT_REPL_EPOCHS = UInt32(8593);
      public const ERROR_DS_DRS_EXTENSIONS_CHANGED = UInt32(8594);
      public const ERROR_DS_REPLICA_SET_CHANGE_NOT_ALLOWED_ON_DISABLED_CR = UInt32(8595);
      public const ERROR_DS_NO_MSDS_INTID = UInt32(8596);
      public const ERROR_DS_DUP_MSDS_INTID = UInt32(8597);
      public const ERROR_DS_EXISTS_IN_RDNATTID = UInt32(8598);
      public const ERROR_DS_AUTHORIZATION_FAILED = UInt32(8599);
      public const ERROR_DS_INVALID_SCRIPT = UInt32(8600);
      public const ERROR_DS_REMOTE_CROSSREF_OP_FAILED = UInt32(8601);
      public const ERROR_DS_CROSS_REF_BUSY = UInt32(8602);
      public const ERROR_DS_CANT_DERIVE_SPN_FOR_DELETED_DOMAIN = UInt32(8603);
      public const ERROR_DS_CANT_DEMOTE_WITH_WRITEABLE_NC = UInt32(8604);
      public const ERROR_DS_DUPLICATE_ID_FOUND = UInt32(8605);
      public const ERROR_DS_INSUFFICIENT_ATTR_TO_CREATE_OBJECT = UInt32(8606);
      public const ERROR_DS_GROUP_CONVERSION_ERROR = UInt32(8607);
      public const ERROR_DS_CANT_MOVE_APP_BASIC_GROUP = UInt32(8608);
      public const ERROR_DS_CANT_MOVE_APP_QUERY_GROUP = UInt32(8609);
      public const ERROR_DS_ROLE_NOT_VERIFIED = UInt32(8610);
      public const ERROR_DS_WKO_CONTAINER_CANNOT_BE_SPECIAL = UInt32(8611);
      public const ERROR_DS_DOMAIN_RENAME_IN_PROGRESS = UInt32(8612);
      public const ERROR_DS_EXISTING_AD_CHILD_NC = UInt32(8613);
      public const ERROR_DS_REPL_LIFETIME_EXCEEDED = UInt32(8614);
      public const ERROR_DS_DISALLOWED_IN_SYSTEM_CONTAINER = UInt32(8615);
      public const ERROR_DS_LDAP_SEND_QUEUE_FULL = UInt32(8616);
      public const ERROR_DS_DRA_OUT_SCHEDULE_WINDOW = UInt32(8617);
      public const ERROR_DS_POLICY_NOT_KNOWN = UInt32(8618);
      public const ERROR_NO_SITE_SETTINGS_OBJECT = UInt32(8619);
      public const ERROR_NO_SECRETS = UInt32(8620);
      public const ERROR_NO_WRITABLE_DC_FOUND = UInt32(8621);
      public const ERROR_DS_NO_SERVER_OBJECT = UInt32(8622);
      public const ERROR_DS_NO_NTDSA_OBJECT = UInt32(8623);
      public const ERROR_DS_NON_ASQ_SEARCH = UInt32(8624);
      public const ERROR_DS_AUDIT_FAILURE = UInt32(8625);
      public const ERROR_DS_INVALID_SEARCH_FLAG_SUBTREE = UInt32(8626);
      public const ERROR_DS_INVALID_SEARCH_FLAG_TUPLE = UInt32(8627);
      public const ERROR_DS_HIERARCHY_TABLE_TOO_DEEP = UInt32(8628);
      public const ERROR_DS_DRA_CORRUPT_UTD_VECTOR = UInt32(8629);
      public const ERROR_DS_DRA_SECRETS_DENIED = UInt32(8630);
      public const ERROR_DS_RESERVED_MAPI_ID = UInt32(8631);
      public const ERROR_DS_MAPI_ID_NOT_AVAILABLE = UInt32(8632);
      public const ERROR_DS_DRA_MISSING_KRBTGT_SECRET = UInt32(8633);
      public const ERROR_DS_DOMAIN_NAME_EXISTS_IN_FOREST = UInt32(8634);
      public const ERROR_DS_FLAT_NAME_EXISTS_IN_FOREST = UInt32(8635);
      public const ERROR_INVALID_USER_PRINCIPAL_NAME = UInt32(8636);
      public const ERROR_DS_OID_MAPPED_GROUP_CANT_HAVE_MEMBERS = UInt32(8637);
      public const ERROR_DS_OID_NOT_FOUND = UInt32(8638);
      public const ERROR_DS_DRA_RECYCLED_TARGET = UInt32(8639);
      public const ERROR_DS_DISALLOWED_NC_REDIRECT = UInt32(8640);
      public const ERROR_DS_HIGH_ADLDS_FFL = UInt32(8641);
      public const ERROR_DS_HIGH_DSA_VERSION = UInt32(8642);
      public const ERROR_DS_LOW_ADLDS_FFL = UInt32(8643);
      public const ERROR_DOMAIN_SID_SAME_AS_LOCAL_WORKSTATION = UInt32(8644);
      public const ERROR_DS_UNDELETE_SAM_VALIDATION_FAILED = UInt32(8645);
      public const ERROR_INCORRECT_ACCOUNT_TYPE = UInt32(8646);
      public const ERROR_DS_SPN_VALUE_NOT_UNIQUE_IN_FOREST = UInt32(8647);
      public const ERROR_DS_UPN_VALUE_NOT_UNIQUE_IN_FOREST = UInt32(8648);
      public const ERROR_DS_MISSING_FOREST_TRUST = UInt32(8649);
      public const ERROR_DS_VALUE_KEY_NOT_UNIQUE = UInt32(8650);
      public const ERROR_WEAK_WHFBKEY_BLOCKED = UInt32(8651);
      public const ERROR_DS_PER_ATTRIBUTE_AUTHZ_FAILED_DURING_ADD = UInt32(8652);
      public const ERROR_LOCAL_POLICY_MODIFICATION_NOT_SUPPORTED = UInt32(8653);
      public const DNS_ERROR_RESPONSE_CODES_BASE = UInt32(9000);
      public const DNS_ERROR_RCODE_NO_ERROR = UInt32(0);
      public const DNS_ERROR_MASK = UInt32(9000);
      public const DNS_ERROR_RCODE_FORMAT_ERROR = UInt32(9001);
      public const DNS_ERROR_RCODE_SERVER_FAILURE = UInt32(9002);
      public const DNS_ERROR_RCODE_NAME_ERROR = UInt32(9003);
      public const DNS_ERROR_RCODE_NOT_IMPLEMENTED = UInt32(9004);
      public const DNS_ERROR_RCODE_REFUSED = UInt32(9005);
      public const DNS_ERROR_RCODE_YXDOMAIN = UInt32(9006);
      public const DNS_ERROR_RCODE_YXRRSET = UInt32(9007);
      public const DNS_ERROR_RCODE_NXRRSET = UInt32(9008);
      public const DNS_ERROR_RCODE_NOTAUTH = UInt32(9009);
      public const DNS_ERROR_RCODE_NOTZONE = UInt32(9010);
      public const DNS_ERROR_RCODE_BADSIG = UInt32(9016);
      public const DNS_ERROR_RCODE_BADKEY = UInt32(9017);
      public const DNS_ERROR_RCODE_BADTIME = UInt32(9018);
      public const DNS_ERROR_RCODE_LAST = UInt32(9018);
      public const DNS_ERROR_DNSSEC_BASE = UInt32(9100);
      public const DNS_ERROR_KEYMASTER_REQUIRED = UInt32(9101);
      public const DNS_ERROR_NOT_ALLOWED_ON_SIGNED_ZONE = UInt32(9102);
      public const DNS_ERROR_NSEC3_INCOMPATIBLE_WITH_RSA_SHA1 = UInt32(9103);
      public const DNS_ERROR_NOT_ENOUGH_SIGNING_KEY_DESCRIPTORS = UInt32(9104);
      public const DNS_ERROR_UNSUPPORTED_ALGORITHM = UInt32(9105);
      public const DNS_ERROR_INVALID_KEY_SIZE = UInt32(9106);
      public const DNS_ERROR_SIGNING_KEY_NOT_ACCESSIBLE = UInt32(9107);
      public const DNS_ERROR_KSP_DOES_NOT_SUPPORT_PROTECTION = UInt32(9108);
      public const DNS_ERROR_UNEXPECTED_DATA_PROTECTION_ERROR = UInt32(9109);
      public const DNS_ERROR_UNEXPECTED_CNG_ERROR = UInt32(9110);
      public const DNS_ERROR_UNKNOWN_SIGNING_PARAMETER_VERSION = UInt32(9111);
      public const DNS_ERROR_KSP_NOT_ACCESSIBLE = UInt32(9112);
      public const DNS_ERROR_TOO_MANY_SKDS = UInt32(9113);
      public const DNS_ERROR_INVALID_ROLLOVER_PERIOD = UInt32(9114);
      public const DNS_ERROR_INVALID_INITIAL_ROLLOVER_OFFSET = UInt32(9115);
      public const DNS_ERROR_ROLLOVER_IN_PROGRESS = UInt32(9116);
      public const DNS_ERROR_STANDBY_KEY_NOT_PRESENT = UInt32(9117);
      public const DNS_ERROR_NOT_ALLOWED_ON_ZSK = UInt32(9118);
      public const DNS_ERROR_NOT_ALLOWED_ON_ACTIVE_SKD = UInt32(9119);
      public const DNS_ERROR_ROLLOVER_ALREADY_QUEUED = UInt32(9120);
      public const DNS_ERROR_NOT_ALLOWED_ON_UNSIGNED_ZONE = UInt32(9121);
      public const DNS_ERROR_BAD_KEYMASTER = UInt32(9122);
      public const DNS_ERROR_INVALID_SIGNATURE_VALIDITY_PERIOD = UInt32(9123);
      public const DNS_ERROR_INVALID_NSEC3_ITERATION_COUNT = UInt32(9124);
      public const DNS_ERROR_DNSSEC_IS_DISABLED = UInt32(9125);
      public const DNS_ERROR_INVALID_XML = UInt32(9126);
      public const DNS_ERROR_NO_VALID_TRUST_ANCHORS = UInt32(9127);
      public const DNS_ERROR_ROLLOVER_NOT_POKEABLE = UInt32(9128);
      public const DNS_ERROR_NSEC3_NAME_COLLISION = UInt32(9129);
      public const DNS_ERROR_NSEC_INCOMPATIBLE_WITH_NSEC3_RSA_SHA1 = UInt32(9130);
      public const DNS_ERROR_PACKET_FMT_BASE = UInt32(9500);
      public const DNS_ERROR_BAD_PACKET = UInt32(9502);
      public const DNS_ERROR_NO_PACKET = UInt32(9503);
      public const DNS_ERROR_RCODE = UInt32(9504);
      public const DNS_ERROR_UNSECURE_PACKET = UInt32(9505);
      public const DNS_ERROR_NO_MEMORY = UInt32(14);
      public const DNS_ERROR_INVALID_NAME = UInt32(123);
      public const DNS_ERROR_INVALID_DATA = UInt32(13);
      public const DNS_ERROR_GENERAL_API_BASE = UInt32(9550);
      public const DNS_ERROR_INVALID_TYPE = UInt32(9551);
      public const DNS_ERROR_INVALID_IP_ADDRESS = UInt32(9552);
      public const DNS_ERROR_INVALID_PROPERTY = UInt32(9553);
      public const DNS_ERROR_TRY_AGAIN_LATER = UInt32(9554);
      public const DNS_ERROR_NOT_UNIQUE = UInt32(9555);
      public const DNS_ERROR_NON_RFC_NAME = UInt32(9556);
      public const DNS_ERROR_INVALID_NAME_CHAR = UInt32(9560);
      public const DNS_ERROR_NUMERIC_NAME = UInt32(9561);
      public const DNS_ERROR_NOT_ALLOWED_ON_ROOT_SERVER = UInt32(9562);
      public const DNS_ERROR_NOT_ALLOWED_UNDER_DELEGATION = UInt32(9563);
      public const DNS_ERROR_CANNOT_FIND_ROOT_HINTS = UInt32(9564);
      public const DNS_ERROR_INCONSISTENT_ROOT_HINTS = UInt32(9565);
      public const DNS_ERROR_DWORD_VALUE_TOO_SMALL = UInt32(9566);
      public const DNS_ERROR_DWORD_VALUE_TOO_LARGE = UInt32(9567);
      public const DNS_ERROR_BACKGROUND_LOADING = UInt32(9568);
      public const DNS_ERROR_NOT_ALLOWED_ON_RODC = UInt32(9569);
      public const DNS_ERROR_NOT_ALLOWED_UNDER_DNAME = UInt32(9570);
      public const DNS_ERROR_DELEGATION_REQUIRED = UInt32(9571);
      public const DNS_ERROR_INVALID_POLICY_TABLE = UInt32(9572);
      public const DNS_ERROR_ADDRESS_REQUIRED = UInt32(9573);
      public const DNS_ERROR_ZONE_BASE = UInt32(9600);
      public const DNS_ERROR_ZONE_DOES_NOT_EXIST = UInt32(9601);
      public const DNS_ERROR_NO_ZONE_INFO = UInt32(9602);
      public const DNS_ERROR_INVALID_ZONE_OPERATION = UInt32(9603);
      public const DNS_ERROR_ZONE_CONFIGURATION_ERROR = UInt32(9604);
      public const DNS_ERROR_ZONE_HAS_NO_SOA_RECORD = UInt32(9605);
      public const DNS_ERROR_ZONE_HAS_NO_NS_RECORDS = UInt32(9606);
      public const DNS_ERROR_ZONE_LOCKED = UInt32(9607);
      public const DNS_ERROR_ZONE_CREATION_FAILED = UInt32(9608);
      public const DNS_ERROR_ZONE_ALREADY_EXISTS = UInt32(9609);
      public const DNS_ERROR_AUTOZONE_ALREADY_EXISTS = UInt32(9610);
      public const DNS_ERROR_INVALID_ZONE_TYPE = UInt32(9611);
      public const DNS_ERROR_SECONDARY_REQUIRES_MASTER_IP = UInt32(9612);
      public const DNS_ERROR_ZONE_NOT_SECONDARY = UInt32(9613);
      public const DNS_ERROR_NEED_SECONDARY_ADDRESSES = UInt32(9614);
      public const DNS_ERROR_WINS_INIT_FAILED = UInt32(9615);
      public const DNS_ERROR_NEED_WINS_SERVERS = UInt32(9616);
      public const DNS_ERROR_NBSTAT_INIT_FAILED = UInt32(9617);
      public const DNS_ERROR_SOA_DELETE_INVALID = UInt32(9618);
      public const DNS_ERROR_FORWARDER_ALREADY_EXISTS = UInt32(9619);
      public const DNS_ERROR_ZONE_REQUIRES_MASTER_IP = UInt32(9620);
      public const DNS_ERROR_ZONE_IS_SHUTDOWN = UInt32(9621);
      public const DNS_ERROR_ZONE_LOCKED_FOR_SIGNING = UInt32(9622);
      public const DNS_ERROR_DATAFILE_BASE = UInt32(9650);
      public const DNS_ERROR_PRIMARY_REQUIRES_DATAFILE = UInt32(9651);
      public const DNS_ERROR_INVALID_DATAFILE_NAME = UInt32(9652);
      public const DNS_ERROR_DATAFILE_OPEN_FAILURE = UInt32(9653);
      public const DNS_ERROR_FILE_WRITEBACK_FAILED = UInt32(9654);
      public const DNS_ERROR_DATAFILE_PARSING = UInt32(9655);
      public const DNS_ERROR_DATABASE_BASE = UInt32(9700);
      public const DNS_ERROR_RECORD_DOES_NOT_EXIST = UInt32(9701);
      public const DNS_ERROR_RECORD_FORMAT = UInt32(9702);
      public const DNS_ERROR_NODE_CREATION_FAILED = UInt32(9703);
      public const DNS_ERROR_UNKNOWN_RECORD_TYPE = UInt32(9704);
      public const DNS_ERROR_RECORD_TIMED_OUT = UInt32(9705);
      public const DNS_ERROR_NAME_NOT_IN_ZONE = UInt32(9706);
      public const DNS_ERROR_CNAME_LOOP = UInt32(9707);
      public const DNS_ERROR_NODE_IS_CNAME = UInt32(9708);
      public const DNS_ERROR_CNAME_COLLISION = UInt32(9709);
      public const DNS_ERROR_RECORD_ONLY_AT_ZONE_ROOT = UInt32(9710);
      public const DNS_ERROR_RECORD_ALREADY_EXISTS = UInt32(9711);
      public const DNS_ERROR_SECONDARY_DATA = UInt32(9712);
      public const DNS_ERROR_NO_CREATE_CACHE_DATA = UInt32(9713);
      public const DNS_ERROR_NAME_DOES_NOT_EXIST = UInt32(9714);
      public const DNS_ERROR_DS_UNAVAILABLE = UInt32(9717);
      public const DNS_ERROR_DS_ZONE_ALREADY_EXISTS = UInt32(9718);
      public const DNS_ERROR_NO_BOOTFILE_IF_DS_ZONE = UInt32(9719);
      public const DNS_ERROR_NODE_IS_DNAME = UInt32(9720);
      public const DNS_ERROR_DNAME_COLLISION = UInt32(9721);
      public const DNS_ERROR_ALIAS_LOOP = UInt32(9722);
      public const DNS_ERROR_OPERATION_BASE = UInt32(9750);
      public const DNS_ERROR_AXFR = UInt32(9752);
      public const DNS_ERROR_SECURE_BASE = UInt32(9800);
      public const DNS_ERROR_SETUP_BASE = UInt32(9850);
      public const DNS_ERROR_NO_TCPIP = UInt32(9851);
      public const DNS_ERROR_NO_DNS_SERVERS = UInt32(9852);
      public const DNS_ERROR_DP_BASE = UInt32(9900);
      public const DNS_ERROR_DP_DOES_NOT_EXIST = UInt32(9901);
      public const DNS_ERROR_DP_ALREADY_EXISTS = UInt32(9902);
      public const DNS_ERROR_DP_NOT_ENLISTED = UInt32(9903);
      public const DNS_ERROR_DP_ALREADY_ENLISTED = UInt32(9904);
      public const DNS_ERROR_DP_NOT_AVAILABLE = UInt32(9905);
      public const DNS_ERROR_DP_FSMO_ERROR = UInt32(9906);
      public const DNS_ERROR_RRL_NOT_ENABLED = UInt32(9911);
      public const DNS_ERROR_RRL_INVALID_WINDOW_SIZE = UInt32(9912);
      public const DNS_ERROR_RRL_INVALID_IPV4_PREFIX = UInt32(9913);
      public const DNS_ERROR_RRL_INVALID_IPV6_PREFIX = UInt32(9914);
      public const DNS_ERROR_RRL_INVALID_TC_RATE = UInt32(9915);
      public const DNS_ERROR_RRL_INVALID_LEAK_RATE = UInt32(9916);
      public const DNS_ERROR_RRL_LEAK_RATE_LESSTHAN_TC_RATE = UInt32(9917);
      public const DNS_ERROR_VIRTUALIZATION_INSTANCE_ALREADY_EXISTS = UInt32(9921);
      public const DNS_ERROR_VIRTUALIZATION_INSTANCE_DOES_NOT_EXIST = UInt32(9922);
      public const DNS_ERROR_VIRTUALIZATION_TREE_LOCKED = UInt32(9923);
      public const DNS_ERROR_INVAILD_VIRTUALIZATION_INSTANCE_NAME = UInt32(9924);
      public const DNS_ERROR_DEFAULT_VIRTUALIZATION_INSTANCE = UInt32(9925);
      public const DNS_ERROR_ZONESCOPE_ALREADY_EXISTS = UInt32(9951);
      public const DNS_ERROR_ZONESCOPE_DOES_NOT_EXIST = UInt32(9952);
      public const DNS_ERROR_DEFAULT_ZONESCOPE = UInt32(9953);
      public const DNS_ERROR_INVALID_ZONESCOPE_NAME = UInt32(9954);
      public const DNS_ERROR_NOT_ALLOWED_WITH_ZONESCOPES = UInt32(9955);
      public const DNS_ERROR_LOAD_ZONESCOPE_FAILED = UInt32(9956);
      public const DNS_ERROR_ZONESCOPE_FILE_WRITEBACK_FAILED = UInt32(9957);
      public const DNS_ERROR_INVALID_SCOPE_NAME = UInt32(9958);
      public const DNS_ERROR_SCOPE_DOES_NOT_EXIST = UInt32(9959);
      public const DNS_ERROR_DEFAULT_SCOPE = UInt32(9960);
      public const DNS_ERROR_INVALID_SCOPE_OPERATION = UInt32(9961);
      public const DNS_ERROR_SCOPE_LOCKED = UInt32(9962);
      public const DNS_ERROR_SCOPE_ALREADY_EXISTS = UInt32(9963);
      public const DNS_ERROR_POLICY_ALREADY_EXISTS = UInt32(9971);
      public const DNS_ERROR_POLICY_DOES_NOT_EXIST = UInt32(9972);
      public const DNS_ERROR_POLICY_INVALID_CRITERIA = UInt32(9973);
      public const DNS_ERROR_POLICY_INVALID_SETTINGS = UInt32(9974);
      public const DNS_ERROR_CLIENT_SUBNET_IS_ACCESSED = UInt32(9975);
      public const DNS_ERROR_CLIENT_SUBNET_DOES_NOT_EXIST = UInt32(9976);
      public const DNS_ERROR_CLIENT_SUBNET_ALREADY_EXISTS = UInt32(9977);
      public const DNS_ERROR_SUBNET_DOES_NOT_EXIST = UInt32(9978);
      public const DNS_ERROR_SUBNET_ALREADY_EXISTS = UInt32(9979);
      public const DNS_ERROR_POLICY_LOCKED = UInt32(9980);
      public const DNS_ERROR_POLICY_INVALID_WEIGHT = UInt32(9981);
      public const DNS_ERROR_POLICY_INVALID_NAME = UInt32(9982);
      public const DNS_ERROR_POLICY_MISSING_CRITERIA = UInt32(9983);
      public const DNS_ERROR_INVALID_CLIENT_SUBNET_NAME = UInt32(9984);
      public const DNS_ERROR_POLICY_PROCESSING_ORDER_INVALID = UInt32(9985);
      public const DNS_ERROR_POLICY_SCOPE_MISSING = UInt32(9986);
      public const DNS_ERROR_POLICY_SCOPE_NOT_ALLOWED = UInt32(9987);
      public const DNS_ERROR_SERVERSCOPE_IS_REFERENCED = UInt32(9988);
      public const DNS_ERROR_ZONESCOPE_IS_REFERENCED = UInt32(9989);
      public const DNS_ERROR_POLICY_INVALID_CRITERIA_CLIENT_SUBNET = UInt32(9990);
      public const DNS_ERROR_POLICY_INVALID_CRITERIA_TRANSPORT_PROTOCOL = UInt32(9991);
      public const DNS_ERROR_POLICY_INVALID_CRITERIA_NETWORK_PROTOCOL = UInt32(9992);
      public const DNS_ERROR_POLICY_INVALID_CRITERIA_INTERFACE = UInt32(9993);
      public const DNS_ERROR_POLICY_INVALID_CRITERIA_FQDN = UInt32(9994);
      public const DNS_ERROR_POLICY_INVALID_CRITERIA_QUERY_TYPE = UInt32(9995);
      public const DNS_ERROR_POLICY_INVALID_CRITERIA_TIME_OF_DAY = UInt32(9996);
      public const ERROR_IPSEC_QM_POLICY_EXISTS = UInt32(13000);
      public const ERROR_IPSEC_QM_POLICY_NOT_FOUND = UInt32(13001);
      public const ERROR_IPSEC_QM_POLICY_IN_USE = UInt32(13002);
      public const ERROR_IPSEC_MM_POLICY_EXISTS = UInt32(13003);
      public const ERROR_IPSEC_MM_POLICY_NOT_FOUND = UInt32(13004);
      public const ERROR_IPSEC_MM_POLICY_IN_USE = UInt32(13005);
      public const ERROR_IPSEC_MM_FILTER_EXISTS = UInt32(13006);
      public const ERROR_IPSEC_MM_FILTER_NOT_FOUND = UInt32(13007);
      public const ERROR_IPSEC_TRANSPORT_FILTER_EXISTS = UInt32(13008);
      public const ERROR_IPSEC_TRANSPORT_FILTER_NOT_FOUND = UInt32(13009);
      public const ERROR_IPSEC_MM_AUTH_EXISTS = UInt32(13010);
      public const ERROR_IPSEC_MM_AUTH_NOT_FOUND = UInt32(13011);
      public const ERROR_IPSEC_MM_AUTH_IN_USE = UInt32(13012);
      public const ERROR_IPSEC_DEFAULT_MM_POLICY_NOT_FOUND = UInt32(13013);
      public const ERROR_IPSEC_DEFAULT_MM_AUTH_NOT_FOUND = UInt32(13014);
      public const ERROR_IPSEC_DEFAULT_QM_POLICY_NOT_FOUND = UInt32(13015);
      public const ERROR_IPSEC_TUNNEL_FILTER_EXISTS = UInt32(13016);
      public const ERROR_IPSEC_TUNNEL_FILTER_NOT_FOUND = UInt32(13017);
      public const ERROR_IPSEC_MM_FILTER_PENDING_DELETION = UInt32(13018);
      public const ERROR_IPSEC_TRANSPORT_FILTER_PENDING_DELETION = UInt32(13019);
      public const ERROR_IPSEC_TUNNEL_FILTER_PENDING_DELETION = UInt32(13020);
      public const ERROR_IPSEC_MM_POLICY_PENDING_DELETION = UInt32(13021);
      public const ERROR_IPSEC_MM_AUTH_PENDING_DELETION = UInt32(13022);
      public const ERROR_IPSEC_QM_POLICY_PENDING_DELETION = UInt32(13023);
      public const ERROR_IPSEC_IKE_NEG_STATUS_BEGIN = UInt32(13800);
      public const ERROR_IPSEC_IKE_AUTH_FAIL = UInt32(13801);
      public const ERROR_IPSEC_IKE_ATTRIB_FAIL = UInt32(13802);
      public const ERROR_IPSEC_IKE_NEGOTIATION_PENDING = UInt32(13803);
      public const ERROR_IPSEC_IKE_GENERAL_PROCESSING_ERROR = UInt32(13804);
      public const ERROR_IPSEC_IKE_TIMED_OUT = UInt32(13805);
      public const ERROR_IPSEC_IKE_NO_CERT = UInt32(13806);
      public const ERROR_IPSEC_IKE_SA_DELETED = UInt32(13807);
      public const ERROR_IPSEC_IKE_SA_REAPED = UInt32(13808);
      public const ERROR_IPSEC_IKE_MM_ACQUIRE_DROP = UInt32(13809);
      public const ERROR_IPSEC_IKE_QM_ACQUIRE_DROP = UInt32(13810);
      public const ERROR_IPSEC_IKE_QUEUE_DROP_MM = UInt32(13811);
      public const ERROR_IPSEC_IKE_QUEUE_DROP_NO_MM = UInt32(13812);
      public const ERROR_IPSEC_IKE_DROP_NO_RESPONSE = UInt32(13813);
      public const ERROR_IPSEC_IKE_MM_DELAY_DROP = UInt32(13814);
      public const ERROR_IPSEC_IKE_QM_DELAY_DROP = UInt32(13815);
      public const ERROR_IPSEC_IKE_ERROR = UInt32(13816);
      public const ERROR_IPSEC_IKE_CRL_FAILED = UInt32(13817);
      public const ERROR_IPSEC_IKE_INVALID_KEY_USAGE = UInt32(13818);
      public const ERROR_IPSEC_IKE_INVALID_CERT_TYPE = UInt32(13819);
      public const ERROR_IPSEC_IKE_NO_PRIVATE_KEY = UInt32(13820);
      public const ERROR_IPSEC_IKE_SIMULTANEOUS_REKEY = UInt32(13821);
      public const ERROR_IPSEC_IKE_DH_FAIL = UInt32(13822);
      public const ERROR_IPSEC_IKE_CRITICAL_PAYLOAD_NOT_RECOGNIZED = UInt32(13823);
      public const ERROR_IPSEC_IKE_INVALID_HEADER = UInt32(13824);
      public const ERROR_IPSEC_IKE_NO_POLICY = UInt32(13825);
      public const ERROR_IPSEC_IKE_INVALID_SIGNATURE = UInt32(13826);
      public const ERROR_IPSEC_IKE_KERBEROS_ERROR = UInt32(13827);
      public const ERROR_IPSEC_IKE_NO_PUBLIC_KEY = UInt32(13828);
      public const ERROR_IPSEC_IKE_PROCESS_ERR = UInt32(13829);
      public const ERROR_IPSEC_IKE_PROCESS_ERR_SA = UInt32(13830);
      public const ERROR_IPSEC_IKE_PROCESS_ERR_PROP = UInt32(13831);
      public const ERROR_IPSEC_IKE_PROCESS_ERR_TRANS = UInt32(13832);
      public const ERROR_IPSEC_IKE_PROCESS_ERR_KE = UInt32(13833);
      public const ERROR_IPSEC_IKE_PROCESS_ERR_ID = UInt32(13834);
      public const ERROR_IPSEC_IKE_PROCESS_ERR_CERT = UInt32(13835);
      public const ERROR_IPSEC_IKE_PROCESS_ERR_CERT_REQ = UInt32(13836);
      public const ERROR_IPSEC_IKE_PROCESS_ERR_HASH = UInt32(13837);
      public const ERROR_IPSEC_IKE_PROCESS_ERR_SIG = UInt32(13838);
      public const ERROR_IPSEC_IKE_PROCESS_ERR_NONCE = UInt32(13839);
      public const ERROR_IPSEC_IKE_PROCESS_ERR_NOTIFY = UInt32(13840);
      public const ERROR_IPSEC_IKE_PROCESS_ERR_DELETE = UInt32(13841);
      public const ERROR_IPSEC_IKE_PROCESS_ERR_VENDOR = UInt32(13842);
      public const ERROR_IPSEC_IKE_INVALID_PAYLOAD = UInt32(13843);
      public const ERROR_IPSEC_IKE_LOAD_SOFT_SA = UInt32(13844);
      public const ERROR_IPSEC_IKE_SOFT_SA_TORN_DOWN = UInt32(13845);
      public const ERROR_IPSEC_IKE_INVALID_COOKIE = UInt32(13846);
      public const ERROR_IPSEC_IKE_NO_PEER_CERT = UInt32(13847);
      public const ERROR_IPSEC_IKE_PEER_CRL_FAILED = UInt32(13848);
      public const ERROR_IPSEC_IKE_POLICY_CHANGE = UInt32(13849);
      public const ERROR_IPSEC_IKE_NO_MM_POLICY = UInt32(13850);
      public const ERROR_IPSEC_IKE_NOTCBPRIV = UInt32(13851);
      public const ERROR_IPSEC_IKE_SECLOADFAIL = UInt32(13852);
      public const ERROR_IPSEC_IKE_FAILSSPINIT = UInt32(13853);
      public const ERROR_IPSEC_IKE_FAILQUERYSSP = UInt32(13854);
      public const ERROR_IPSEC_IKE_SRVACQFAIL = UInt32(13855);
      public const ERROR_IPSEC_IKE_SRVQUERYCRED = UInt32(13856);
      public const ERROR_IPSEC_IKE_GETSPIFAIL = UInt32(13857);
      public const ERROR_IPSEC_IKE_INVALID_FILTER = UInt32(13858);
      public const ERROR_IPSEC_IKE_OUT_OF_MEMORY = UInt32(13859);
      public const ERROR_IPSEC_IKE_ADD_UPDATE_KEY_FAILED = UInt32(13860);
      public const ERROR_IPSEC_IKE_INVALID_POLICY = UInt32(13861);
      public const ERROR_IPSEC_IKE_UNKNOWN_DOI = UInt32(13862);
      public const ERROR_IPSEC_IKE_INVALID_SITUATION = UInt32(13863);
      public const ERROR_IPSEC_IKE_DH_FAILURE = UInt32(13864);
      public const ERROR_IPSEC_IKE_INVALID_GROUP = UInt32(13865);
      public const ERROR_IPSEC_IKE_ENCRYPT = UInt32(13866);
      public const ERROR_IPSEC_IKE_DECRYPT = UInt32(13867);
      public const ERROR_IPSEC_IKE_POLICY_MATCH = UInt32(13868);
      public const ERROR_IPSEC_IKE_UNSUPPORTED_ID = UInt32(13869);
      public const ERROR_IPSEC_IKE_INVALID_HASH = UInt32(13870);
      public const ERROR_IPSEC_IKE_INVALID_HASH_ALG = UInt32(13871);
      public const ERROR_IPSEC_IKE_INVALID_HASH_SIZE = UInt32(13872);
      public const ERROR_IPSEC_IKE_INVALID_ENCRYPT_ALG = UInt32(13873);
      public const ERROR_IPSEC_IKE_INVALID_AUTH_ALG = UInt32(13874);
      public const ERROR_IPSEC_IKE_INVALID_SIG = UInt32(13875);
      public const ERROR_IPSEC_IKE_LOAD_FAILED = UInt32(13876);
      public const ERROR_IPSEC_IKE_RPC_DELETE = UInt32(13877);
      public const ERROR_IPSEC_IKE_BENIGN_REINIT = UInt32(13878);
      public const ERROR_IPSEC_IKE_INVALID_RESPONDER_LIFETIME_NOTIFY = UInt32(13879);
      public const ERROR_IPSEC_IKE_INVALID_MAJOR_VERSION = UInt32(13880);
      public const ERROR_IPSEC_IKE_INVALID_CERT_KEYLEN = UInt32(13881);
      public const ERROR_IPSEC_IKE_MM_LIMIT = UInt32(13882);
      public const ERROR_IPSEC_IKE_NEGOTIATION_DISABLED = UInt32(13883);
      public const ERROR_IPSEC_IKE_QM_LIMIT = UInt32(13884);
      public const ERROR_IPSEC_IKE_MM_EXPIRED = UInt32(13885);
      public const ERROR_IPSEC_IKE_PEER_MM_ASSUMED_INVALID = UInt32(13886);
      public const ERROR_IPSEC_IKE_CERT_CHAIN_POLICY_MISMATCH = UInt32(13887);
      public const ERROR_IPSEC_IKE_UNEXPECTED_MESSAGE_ID = UInt32(13888);
      public const ERROR_IPSEC_IKE_INVALID_AUTH_PAYLOAD = UInt32(13889);
      public const ERROR_IPSEC_IKE_DOS_COOKIE_SENT = UInt32(13890);
      public const ERROR_IPSEC_IKE_SHUTTING_DOWN = UInt32(13891);
      public const ERROR_IPSEC_IKE_CGA_AUTH_FAILED = UInt32(13892);
      public const ERROR_IPSEC_IKE_PROCESS_ERR_NATOA = UInt32(13893);
      public const ERROR_IPSEC_IKE_INVALID_MM_FOR_QM = UInt32(13894);
      public const ERROR_IPSEC_IKE_QM_EXPIRED = UInt32(13895);
      public const ERROR_IPSEC_IKE_TOO_MANY_FILTERS = UInt32(13896);
      public const ERROR_IPSEC_IKE_NEG_STATUS_END = UInt32(13897);
      public const ERROR_IPSEC_IKE_KILL_DUMMY_NAP_TUNNEL = UInt32(13898);
      public const ERROR_IPSEC_IKE_INNER_IP_ASSIGNMENT_FAILURE = UInt32(13899);
      public const ERROR_IPSEC_IKE_REQUIRE_CP_PAYLOAD_MISSING = UInt32(13900);
      public const ERROR_IPSEC_KEY_MODULE_IMPERSONATION_NEGOTIATION_PENDING = UInt32(13901);
      public const ERROR_IPSEC_IKE_COEXISTENCE_SUPPRESS = UInt32(13902);
      public const ERROR_IPSEC_IKE_RATELIMIT_DROP = UInt32(13903);
      public const ERROR_IPSEC_IKE_PEER_DOESNT_SUPPORT_MOBIKE = UInt32(13904);
      public const ERROR_IPSEC_IKE_AUTHORIZATION_FAILURE = UInt32(13905);
      public const ERROR_IPSEC_IKE_STRONG_CRED_AUTHORIZATION_FAILURE = UInt32(13906);
      public const ERROR_IPSEC_IKE_AUTHORIZATION_FAILURE_WITH_OPTIONAL_RETRY = UInt32(13907);
      public const ERROR_IPSEC_IKE_STRONG_CRED_AUTHORIZATION_AND_CERTMAP_FAILURE = UInt32(13908);
      public const ERROR_IPSEC_IKE_NEG_STATUS_EXTENDED_END = UInt32(13909);
      public const ERROR_IPSEC_BAD_SPI = UInt32(13910);
      public const ERROR_IPSEC_SA_LIFETIME_EXPIRED = UInt32(13911);
      public const ERROR_IPSEC_WRONG_SA = UInt32(13912);
      public const ERROR_IPSEC_REPLAY_CHECK_FAILED = UInt32(13913);
      public const ERROR_IPSEC_INVALID_PACKET = UInt32(13914);
      public const ERROR_IPSEC_INTEGRITY_CHECK_FAILED = UInt32(13915);
      public const ERROR_IPSEC_CLEAR_TEXT_DROP = UInt32(13916);
      public const ERROR_IPSEC_AUTH_FIREWALL_DROP = UInt32(13917);
      public const ERROR_IPSEC_THROTTLE_DROP = UInt32(13918);
      public const ERROR_IPSEC_DOSP_BLOCK = UInt32(13925);
      public const ERROR_IPSEC_DOSP_RECEIVED_MULTICAST = UInt32(13926);
      public const ERROR_IPSEC_DOSP_INVALID_PACKET = UInt32(13927);
      public const ERROR_IPSEC_DOSP_STATE_LOOKUP_FAILED = UInt32(13928);
      public const ERROR_IPSEC_DOSP_MAX_ENTRIES = UInt32(13929);
      public const ERROR_IPSEC_DOSP_KEYMOD_NOT_ALLOWED = UInt32(13930);
      public const ERROR_IPSEC_DOSP_NOT_INSTALLED = UInt32(13931);
      public const ERROR_IPSEC_DOSP_MAX_PER_IP_RATELIMIT_QUEUES = UInt32(13932);
      public const ERROR_SXS_SECTION_NOT_FOUND = UInt32(14000);
      public const ERROR_SXS_CANT_GEN_ACTCTX = UInt32(14001);
      public const ERROR_SXS_INVALID_ACTCTXDATA_FORMAT = UInt32(14002);
      public const ERROR_SXS_ASSEMBLY_NOT_FOUND = UInt32(14003);
      public const ERROR_SXS_MANIFEST_FORMAT_ERROR = UInt32(14004);
      public const ERROR_SXS_MANIFEST_PARSE_ERROR = UInt32(14005);
      public const ERROR_SXS_ACTIVATION_CONTEXT_DISABLED = UInt32(14006);
      public const ERROR_SXS_KEY_NOT_FOUND = UInt32(14007);
      public const ERROR_SXS_VERSION_CONFLICT = UInt32(14008);
      public const ERROR_SXS_WRONG_SECTION_TYPE = UInt32(14009);
      public const ERROR_SXS_THREAD_QUERIES_DISABLED = UInt32(14010);
      public const ERROR_SXS_PROCESS_DEFAULT_ALREADY_SET = UInt32(14011);
      public const ERROR_SXS_UNKNOWN_ENCODING_GROUP = UInt32(14012);
      public const ERROR_SXS_UNKNOWN_ENCODING = UInt32(14013);
      public const ERROR_SXS_INVALID_XML_NAMESPACE_URI = UInt32(14014);
      public const ERROR_SXS_ROOT_MANIFEST_DEPENDENCY_NOT_INSTALLED = UInt32(14015);
      public const ERROR_SXS_LEAF_MANIFEST_DEPENDENCY_NOT_INSTALLED = UInt32(14016);
      public const ERROR_SXS_INVALID_ASSEMBLY_IDENTITY_ATTRIBUTE = UInt32(14017);
      public const ERROR_SXS_MANIFEST_MISSING_REQUIRED_DEFAULT_NAMESPACE = UInt32(14018);
      public const ERROR_SXS_MANIFEST_INVALID_REQUIRED_DEFAULT_NAMESPACE = UInt32(14019);
      public const ERROR_SXS_PRIVATE_MANIFEST_CROSS_PATH_WITH_REPARSE_POINT = UInt32(14020);
      public const ERROR_SXS_DUPLICATE_DLL_NAME = UInt32(14021);
      public const ERROR_SXS_DUPLICATE_WINDOWCLASS_NAME = UInt32(14022);
      public const ERROR_SXS_DUPLICATE_CLSID = UInt32(14023);
      public const ERROR_SXS_DUPLICATE_IID = UInt32(14024);
      public const ERROR_SXS_DUPLICATE_TLBID = UInt32(14025);
      public const ERROR_SXS_DUPLICATE_PROGID = UInt32(14026);
      public const ERROR_SXS_DUPLICATE_ASSEMBLY_NAME = UInt32(14027);
      public const ERROR_SXS_FILE_HASH_MISMATCH = UInt32(14028);
      public const ERROR_SXS_POLICY_PARSE_ERROR = UInt32(14029);
      public const ERROR_SXS_XML_E_MISSINGQUOTE = UInt32(14030);
      public const ERROR_SXS_XML_E_COMMENTSYNTAX = UInt32(14031);
      public const ERROR_SXS_XML_E_BADSTARTNAMECHAR = UInt32(14032);
      public const ERROR_SXS_XML_E_BADNAMECHAR = UInt32(14033);
      public const ERROR_SXS_XML_E_BADCHARINSTRING = UInt32(14034);
      public const ERROR_SXS_XML_E_XMLDECLSYNTAX = UInt32(14035);
      public const ERROR_SXS_XML_E_BADCHARDATA = UInt32(14036);
      public const ERROR_SXS_XML_E_MISSINGWHITESPACE = UInt32(14037);
      public const ERROR_SXS_XML_E_EXPECTINGTAGEND = UInt32(14038);
      public const ERROR_SXS_XML_E_MISSINGSEMICOLON = UInt32(14039);
      public const ERROR_SXS_XML_E_UNBALANCEDPAREN = UInt32(14040);
      public const ERROR_SXS_XML_E_INTERNALERROR = UInt32(14041);
      public const ERROR_SXS_XML_E_UNEXPECTED_WHITESPACE = UInt32(14042);
      public const ERROR_SXS_XML_E_INCOMPLETE_ENCODING = UInt32(14043);
      public const ERROR_SXS_XML_E_MISSING_PAREN = UInt32(14044);
      public const ERROR_SXS_XML_E_EXPECTINGCLOSEQUOTE = UInt32(14045);
      public const ERROR_SXS_XML_E_MULTIPLE_COLONS = UInt32(14046);
      public const ERROR_SXS_XML_E_INVALID_DECIMAL = UInt32(14047);
      public const ERROR_SXS_XML_E_INVALID_HEXIDECIMAL = UInt32(14048);
      public const ERROR_SXS_XML_E_INVALID_UNICODE = UInt32(14049);
      public const ERROR_SXS_XML_E_WHITESPACEORQUESTIONMARK = UInt32(14050);
      public const ERROR_SXS_XML_E_UNEXPECTEDENDTAG = UInt32(14051);
      public const ERROR_SXS_XML_E_UNCLOSEDTAG = UInt32(14052);
      public const ERROR_SXS_XML_E_DUPLICATEATTRIBUTE = UInt32(14053);
      public const ERROR_SXS_XML_E_MULTIPLEROOTS = UInt32(14054);
      public const ERROR_SXS_XML_E_INVALIDATROOTLEVEL = UInt32(14055);
      public const ERROR_SXS_XML_E_BADXMLDECL = UInt32(14056);
      public const ERROR_SXS_XML_E_MISSINGROOT = UInt32(14057);
      public const ERROR_SXS_XML_E_UNEXPECTEDEOF = UInt32(14058);
      public const ERROR_SXS_XML_E_BADPEREFINSUBSET = UInt32(14059);
      public const ERROR_SXS_XML_E_UNCLOSEDSTARTTAG = UInt32(14060);
      public const ERROR_SXS_XML_E_UNCLOSEDENDTAG = UInt32(14061);
      public const ERROR_SXS_XML_E_UNCLOSEDSTRING = UInt32(14062);
      public const ERROR_SXS_XML_E_UNCLOSEDCOMMENT = UInt32(14063);
      public const ERROR_SXS_XML_E_UNCLOSEDDECL = UInt32(14064);
      public const ERROR_SXS_XML_E_UNCLOSEDCDATA = UInt32(14065);
      public const ERROR_SXS_XML_E_RESERVEDNAMESPACE = UInt32(14066);
      public const ERROR_SXS_XML_E_INVALIDENCODING = UInt32(14067);
      public const ERROR_SXS_XML_E_INVALIDSWITCH = UInt32(14068);
      public const ERROR_SXS_XML_E_BADXMLCASE = UInt32(14069);
      public const ERROR_SXS_XML_E_INVALID_STANDALONE = UInt32(14070);
      public const ERROR_SXS_XML_E_UNEXPECTED_STANDALONE = UInt32(14071);
      public const ERROR_SXS_XML_E_INVALID_VERSION = UInt32(14072);
      public const ERROR_SXS_XML_E_MISSINGEQUALS = UInt32(14073);
      public const ERROR_SXS_PROTECTION_RECOVERY_FAILED = UInt32(14074);
      public const ERROR_SXS_PROTECTION_PUBLIC_KEY_TOO_SHORT = UInt32(14075);
      public const ERROR_SXS_PROTECTION_CATALOG_NOT_VALID = UInt32(14076);
      public const ERROR_SXS_UNTRANSLATABLE_HRESULT = UInt32(14077);
      public const ERROR_SXS_PROTECTION_CATALOG_FILE_MISSING = UInt32(14078);
      public const ERROR_SXS_MISSING_ASSEMBLY_IDENTITY_ATTRIBUTE = UInt32(14079);
      public const ERROR_SXS_INVALID_ASSEMBLY_IDENTITY_ATTRIBUTE_NAME = UInt32(14080);
      public const ERROR_SXS_ASSEMBLY_MISSING = UInt32(14081);
      public const ERROR_SXS_CORRUPT_ACTIVATION_STACK = UInt32(14082);
      public const ERROR_SXS_CORRUPTION = UInt32(14083);
      public const ERROR_SXS_EARLY_DEACTIVATION = UInt32(14084);
      public const ERROR_SXS_INVALID_DEACTIVATION = UInt32(14085);
      public const ERROR_SXS_MULTIPLE_DEACTIVATION = UInt32(14086);
      public const ERROR_SXS_PROCESS_TERMINATION_REQUESTED = UInt32(14087);
      public const ERROR_SXS_RELEASE_ACTIVATION_CONTEXT = UInt32(14088);
      public const ERROR_SXS_SYSTEM_DEFAULT_ACTIVATION_CONTEXT_EMPTY = UInt32(14089);
      public const ERROR_SXS_INVALID_IDENTITY_ATTRIBUTE_VALUE = UInt32(14090);
      public const ERROR_SXS_INVALID_IDENTITY_ATTRIBUTE_NAME = UInt32(14091);
      public const ERROR_SXS_IDENTITY_DUPLICATE_ATTRIBUTE = UInt32(14092);
      public const ERROR_SXS_IDENTITY_PARSE_ERROR = UInt32(14093);
      public const ERROR_MALFORMED_SUBSTITUTION_STRING = UInt32(14094);
      public const ERROR_SXS_INCORRECT_PUBLIC_KEY_TOKEN = UInt32(14095);
      public const ERROR_UNMAPPED_SUBSTITUTION_STRING = UInt32(14096);
      public const ERROR_SXS_ASSEMBLY_NOT_LOCKED = UInt32(14097);
      public const ERROR_SXS_COMPONENT_STORE_CORRUPT = UInt32(14098);
      public const ERROR_ADVANCED_INSTALLER_FAILED = UInt32(14099);
      public const ERROR_XML_ENCODING_MISMATCH = UInt32(14100);
      public const ERROR_SXS_MANIFEST_IDENTITY_SAME_BUT_CONTENTS_DIFFERENT = UInt32(14101);
      public const ERROR_SXS_IDENTITIES_DIFFERENT = UInt32(14102);
      public const ERROR_SXS_ASSEMBLY_IS_NOT_A_DEPLOYMENT = UInt32(14103);
      public const ERROR_SXS_FILE_NOT_PART_OF_ASSEMBLY = UInt32(14104);
      public const ERROR_SXS_MANIFEST_TOO_BIG = UInt32(14105);
      public const ERROR_SXS_SETTING_NOT_REGISTERED = UInt32(14106);
      public const ERROR_SXS_TRANSACTION_CLOSURE_INCOMPLETE = UInt32(14107);
      public const ERROR_SMI_PRIMITIVE_INSTALLER_FAILED = UInt32(14108);
      public const ERROR_GENERIC_COMMAND_FAILED = UInt32(14109);
      public const ERROR_SXS_FILE_HASH_MISSING = UInt32(14110);
      public const ERROR_SXS_DUPLICATE_ACTIVATABLE_CLASS = UInt32(14111);
      public const ERROR_EVT_INVALID_CHANNEL_PATH = UInt32(15000);
      public const ERROR_EVT_INVALID_QUERY = UInt32(15001);
      public const ERROR_EVT_PUBLISHER_METADATA_NOT_FOUND = UInt32(15002);
      public const ERROR_EVT_EVENT_TEMPLATE_NOT_FOUND = UInt32(15003);
      public const ERROR_EVT_INVALID_PUBLISHER_NAME = UInt32(15004);
      public const ERROR_EVT_INVALID_EVENT_DATA = UInt32(15005);
      public const ERROR_EVT_CHANNEL_NOT_FOUND = UInt32(15007);
      public const ERROR_EVT_MALFORMED_XML_TEXT = UInt32(15008);
      public const ERROR_EVT_SUBSCRIPTION_TO_DIRECT_CHANNEL = UInt32(15009);
      public const ERROR_EVT_CONFIGURATION_ERROR = UInt32(15010);
      public const ERROR_EVT_QUERY_RESULT_STALE = UInt32(15011);
      public const ERROR_EVT_QUERY_RESULT_INVALID_POSITION = UInt32(15012);
      public const ERROR_EVT_NON_VALIDATING_MSXML = UInt32(15013);
      public const ERROR_EVT_FILTER_ALREADYSCOPED = UInt32(15014);
      public const ERROR_EVT_FILTER_NOTELTSET = UInt32(15015);
      public const ERROR_EVT_FILTER_INVARG = UInt32(15016);
      public const ERROR_EVT_FILTER_INVTEST = UInt32(15017);
      public const ERROR_EVT_FILTER_INVTYPE = UInt32(15018);
      public const ERROR_EVT_FILTER_PARSEERR = UInt32(15019);
      public const ERROR_EVT_FILTER_UNSUPPORTEDOP = UInt32(15020);
      public const ERROR_EVT_FILTER_UNEXPECTEDTOKEN = UInt32(15021);
      public const ERROR_EVT_INVALID_OPERATION_OVER_ENABLED_DIRECT_CHANNEL = UInt32(15022);
      public const ERROR_EVT_INVALID_CHANNEL_PROPERTY_VALUE = UInt32(15023);
      public const ERROR_EVT_INVALID_PUBLISHER_PROPERTY_VALUE = UInt32(15024);
      public const ERROR_EVT_CHANNEL_CANNOT_ACTIVATE = UInt32(15025);
      public const ERROR_EVT_FILTER_TOO_COMPLEX = UInt32(15026);
      public const ERROR_EVT_MESSAGE_NOT_FOUND = UInt32(15027);
      public const ERROR_EVT_MESSAGE_ID_NOT_FOUND = UInt32(15028);
      public const ERROR_EVT_UNRESOLVED_VALUE_INSERT = UInt32(15029);
      public const ERROR_EVT_UNRESOLVED_PARAMETER_INSERT = UInt32(15030);
      public const ERROR_EVT_MAX_INSERTS_REACHED = UInt32(15031);
      public const ERROR_EVT_EVENT_DEFINITION_NOT_FOUND = UInt32(15032);
      public const ERROR_EVT_MESSAGE_LOCALE_NOT_FOUND = UInt32(15033);
      public const ERROR_EVT_VERSION_TOO_OLD = UInt32(15034);
      public const ERROR_EVT_VERSION_TOO_NEW = UInt32(15035);
      public const ERROR_EVT_CANNOT_OPEN_CHANNEL_OF_QUERY = UInt32(15036);
      public const ERROR_EVT_PUBLISHER_DISABLED = UInt32(15037);
      public const ERROR_EVT_FILTER_OUT_OF_RANGE = UInt32(15038);
      public const ERROR_EC_SUBSCRIPTION_CANNOT_ACTIVATE = UInt32(15080);
      public const ERROR_EC_LOG_DISABLED = UInt32(15081);
      public const ERROR_EC_CIRCULAR_FORWARDING = UInt32(15082);
      public const ERROR_EC_CREDSTORE_FULL = UInt32(15083);
      public const ERROR_EC_CRED_NOT_FOUND = UInt32(15084);
      public const ERROR_EC_NO_ACTIVE_CHANNEL = UInt32(15085);
      public const ERROR_MUI_FILE_NOT_FOUND = UInt32(15100);
      public const ERROR_MUI_INVALID_FILE = UInt32(15101);
      public const ERROR_MUI_INVALID_RC_CONFIG = UInt32(15102);
      public const ERROR_MUI_INVALID_LOCALE_NAME = UInt32(15103);
      public const ERROR_MUI_INVALID_ULTIMATEFALLBACK_NAME = UInt32(15104);
      public const ERROR_MUI_FILE_NOT_LOADED = UInt32(15105);
      public const ERROR_RESOURCE_ENUM_USER_STOP = UInt32(15106);
      public const ERROR_MUI_INTLSETTINGS_UILANG_NOT_INSTALLED = UInt32(15107);
      public const ERROR_MUI_INTLSETTINGS_INVALID_LOCALE_NAME = UInt32(15108);
      public const ERROR_MRM_RUNTIME_NO_DEFAULT_OR_NEUTRAL_RESOURCE = UInt32(15110);
      public const ERROR_MRM_INVALID_PRICONFIG = UInt32(15111);
      public const ERROR_MRM_INVALID_FILE_TYPE = UInt32(15112);
      public const ERROR_MRM_UNKNOWN_QUALIFIER = UInt32(15113);
      public const ERROR_MRM_INVALID_QUALIFIER_VALUE = UInt32(15114);
      public const ERROR_MRM_NO_CANDIDATE = UInt32(15115);
      public const ERROR_MRM_NO_MATCH_OR_DEFAULT_CANDIDATE = UInt32(15116);
      public const ERROR_MRM_RESOURCE_TYPE_MISMATCH = UInt32(15117);
      public const ERROR_MRM_DUPLICATE_MAP_NAME = UInt32(15118);
      public const ERROR_MRM_DUPLICATE_ENTRY = UInt32(15119);
      public const ERROR_MRM_INVALID_RESOURCE_IDENTIFIER = UInt32(15120);
      public const ERROR_MRM_FILEPATH_TOO_LONG = UInt32(15121);
      public const ERROR_MRM_UNSUPPORTED_DIRECTORY_TYPE = UInt32(15122);
      public const ERROR_MRM_INVALID_PRI_FILE = UInt32(15126);
      public const ERROR_MRM_NAMED_RESOURCE_NOT_FOUND = UInt32(15127);
      public const ERROR_MRM_MAP_NOT_FOUND = UInt32(15135);
      public const ERROR_MRM_UNSUPPORTED_PROFILE_TYPE = UInt32(15136);
      public const ERROR_MRM_INVALID_QUALIFIER_OPERATOR = UInt32(15137);
      public const ERROR_MRM_INDETERMINATE_QUALIFIER_VALUE = UInt32(15138);
      public const ERROR_MRM_AUTOMERGE_ENABLED = UInt32(15139);
      public const ERROR_MRM_TOO_MANY_RESOURCES = UInt32(15140);
      public const ERROR_MRM_UNSUPPORTED_FILE_TYPE_FOR_MERGE = UInt32(15141);
      public const ERROR_MRM_UNSUPPORTED_FILE_TYPE_FOR_LOAD_UNLOAD_PRI_FILE = UInt32(15142);
      public const ERROR_MRM_NO_CURRENT_VIEW_ON_THREAD = UInt32(15143);
      public const ERROR_DIFFERENT_PROFILE_RESOURCE_MANAGER_EXIST = UInt32(15144);
      public const ERROR_OPERATION_NOT_ALLOWED_FROM_SYSTEM_COMPONENT = UInt32(15145);
      public const ERROR_MRM_DIRECT_REF_TO_NON_DEFAULT_RESOURCE = UInt32(15146);
      public const ERROR_MRM_GENERATION_COUNT_MISMATCH = UInt32(15147);
      public const ERROR_PRI_MERGE_VERSION_MISMATCH = UInt32(15148);
      public const ERROR_PRI_MERGE_MISSING_SCHEMA = UInt32(15149);
      public const ERROR_PRI_MERGE_LOAD_FILE_FAILED = UInt32(15150);
      public const ERROR_PRI_MERGE_ADD_FILE_FAILED = UInt32(15151);
      public const ERROR_PRI_MERGE_WRITE_FILE_FAILED = UInt32(15152);
      public const ERROR_PRI_MERGE_MULTIPLE_PACKAGE_FAMILIES_NOT_ALLOWED = UInt32(15153);
      public const ERROR_PRI_MERGE_MULTIPLE_MAIN_PACKAGES_NOT_ALLOWED = UInt32(15154);
      public const ERROR_PRI_MERGE_BUNDLE_PACKAGES_NOT_ALLOWED = UInt32(15155);
      public const ERROR_PRI_MERGE_MAIN_PACKAGE_REQUIRED = UInt32(15156);
      public const ERROR_PRI_MERGE_RESOURCE_PACKAGE_REQUIRED = UInt32(15157);
      public const ERROR_PRI_MERGE_INVALID_FILE_NAME = UInt32(15158);
      public const ERROR_MRM_PACKAGE_NOT_FOUND = UInt32(15159);
      public const ERROR_MRM_MISSING_DEFAULT_LANGUAGE = UInt32(15160);
      public const ERROR_MRM_SCOPE_ITEM_CONFLICT = UInt32(15161);
      public const ERROR_MCA_INVALID_CAPABILITIES_STRING = UInt32(15200);
      public const ERROR_MCA_INVALID_VCP_VERSION = UInt32(15201);
      public const ERROR_MCA_MONITOR_VIOLATES_MCCS_SPECIFICATION = UInt32(15202);
      public const ERROR_MCA_MCCS_VERSION_MISMATCH = UInt32(15203);
      public const ERROR_MCA_UNSUPPORTED_MCCS_VERSION = UInt32(15204);
      public const ERROR_MCA_INTERNAL_ERROR = UInt32(15205);
      public const ERROR_MCA_INVALID_TECHNOLOGY_TYPE_RETURNED = UInt32(15206);
      public const ERROR_MCA_UNSUPPORTED_COLOR_TEMPERATURE = UInt32(15207);
      public const ERROR_AMBIGUOUS_SYSTEM_DEVICE = UInt32(15250);
      public const ERROR_SYSTEM_DEVICE_NOT_FOUND = UInt32(15299);
      public const ERROR_HASH_NOT_SUPPORTED = UInt32(15300);
      public const ERROR_HASH_NOT_PRESENT = UInt32(15301);
      public const ERROR_SECONDARY_IC_PROVIDER_NOT_REGISTERED = UInt32(15321);
      public const ERROR_GPIO_CLIENT_INFORMATION_INVALID = UInt32(15322);
      public const ERROR_GPIO_VERSION_NOT_SUPPORTED = UInt32(15323);
      public const ERROR_GPIO_INVALID_REGISTRATION_PACKET = UInt32(15324);
      public const ERROR_GPIO_OPERATION_DENIED = UInt32(15325);
      public const ERROR_GPIO_INCOMPATIBLE_CONNECT_MODE = UInt32(15326);
      public const ERROR_GPIO_INTERRUPT_ALREADY_UNMASKED = UInt32(15327);
      public const ERROR_CANNOT_SWITCH_RUNLEVEL = UInt32(15400);
      public const ERROR_INVALID_RUNLEVEL_SETTING = UInt32(15401);
      public const ERROR_RUNLEVEL_SWITCH_TIMEOUT = UInt32(15402);
      public const ERROR_RUNLEVEL_SWITCH_AGENT_TIMEOUT = UInt32(15403);
      public const ERROR_RUNLEVEL_SWITCH_IN_PROGRESS = UInt32(15404);
      public const ERROR_SERVICES_FAILED_AUTOSTART = UInt32(15405);
      public const ERROR_COM_TASK_STOP_PENDING = UInt32(15501);
      public const ERROR_INSTALL_OPEN_PACKAGE_FAILED = UInt32(15600);
      public const ERROR_INSTALL_PACKAGE_NOT_FOUND = UInt32(15601);
      public const ERROR_INSTALL_INVALID_PACKAGE = UInt32(15602);
      public const ERROR_INSTALL_RESOLVE_DEPENDENCY_FAILED = UInt32(15603);
      public const ERROR_INSTALL_OUT_OF_DISK_SPACE = UInt32(15604);
      public const ERROR_INSTALL_NETWORK_FAILURE = UInt32(15605);
      public const ERROR_INSTALL_REGISTRATION_FAILURE = UInt32(15606);
      public const ERROR_INSTALL_DEREGISTRATION_FAILURE = UInt32(15607);
      public const ERROR_INSTALL_CANCEL = UInt32(15608);
      public const ERROR_INSTALL_FAILED = UInt32(15609);
      public const ERROR_REMOVE_FAILED = UInt32(15610);
      public const ERROR_PACKAGE_ALREADY_EXISTS = UInt32(15611);
      public const ERROR_NEEDS_REMEDIATION = UInt32(15612);
      public const ERROR_INSTALL_PREREQUISITE_FAILED = UInt32(15613);
      public const ERROR_PACKAGE_REPOSITORY_CORRUPTED = UInt32(15614);
      public const ERROR_INSTALL_POLICY_FAILURE = UInt32(15615);
      public const ERROR_PACKAGE_UPDATING = UInt32(15616);
      public const ERROR_DEPLOYMENT_BLOCKED_BY_POLICY = UInt32(15617);
      public const ERROR_PACKAGES_IN_USE = UInt32(15618);
      public const ERROR_RECOVERY_FILE_CORRUPT = UInt32(15619);
      public const ERROR_INVALID_STAGED_SIGNATURE = UInt32(15620);
      public const ERROR_DELETING_EXISTING_APPLICATIONDATA_STORE_FAILED = UInt32(15621);
      public const ERROR_INSTALL_PACKAGE_DOWNGRADE = UInt32(15622);
      public const ERROR_SYSTEM_NEEDS_REMEDIATION = UInt32(15623);
      public const ERROR_APPX_INTEGRITY_FAILURE_CLR_NGEN = UInt32(15624);
      public const ERROR_RESILIENCY_FILE_CORRUPT = UInt32(15625);
      public const ERROR_INSTALL_FIREWALL_SERVICE_NOT_RUNNING = UInt32(15626);
      public const ERROR_PACKAGE_MOVE_FAILED = UInt32(15627);
      public const ERROR_INSTALL_VOLUME_NOT_EMPTY = UInt32(15628);
      public const ERROR_INSTALL_VOLUME_OFFLINE = UInt32(15629);
      public const ERROR_INSTALL_VOLUME_CORRUPT = UInt32(15630);
      public const ERROR_NEEDS_REGISTRATION = UInt32(15631);
      public const ERROR_INSTALL_WRONG_PROCESSOR_ARCHITECTURE = UInt32(15632);
      public const ERROR_DEV_SIDELOAD_LIMIT_EXCEEDED = UInt32(15633);
      public const ERROR_INSTALL_OPTIONAL_PACKAGE_REQUIRES_MAIN_PACKAGE = UInt32(15634);
      public const ERROR_PACKAGE_NOT_SUPPORTED_ON_FILESYSTEM = UInt32(15635);
      public const ERROR_PACKAGE_MOVE_BLOCKED_BY_STREAMING = UInt32(15636);
      public const ERROR_INSTALL_OPTIONAL_PACKAGE_APPLICATIONID_NOT_UNIQUE = UInt32(15637);
      public const ERROR_PACKAGE_STAGING_ONHOLD = UInt32(15638);
      public const ERROR_INSTALL_INVALID_RELATED_SET_UPDATE = UInt32(15639);
      public const ERROR_INSTALL_OPTIONAL_PACKAGE_REQUIRES_MAIN_PACKAGE_FULLTRUST_CAPABILITY = UInt32(15640);
      public const ERROR_DEPLOYMENT_BLOCKED_BY_USER_LOG_OFF = UInt32(15641);
      public const ERROR_PROVISION_OPTIONAL_PACKAGE_REQUIRES_MAIN_PACKAGE_PROVISIONED = UInt32(15642);
      public const ERROR_PACKAGES_REPUTATION_CHECK_FAILED = UInt32(15643);
      public const ERROR_PACKAGES_REPUTATION_CHECK_TIMEDOUT = UInt32(15644);
      public const ERROR_DEPLOYMENT_OPTION_NOT_SUPPORTED = UInt32(15645);
      public const ERROR_APPINSTALLER_ACTIVATION_BLOCKED = UInt32(15646);
      public const ERROR_REGISTRATION_FROM_REMOTE_DRIVE_NOT_SUPPORTED = UInt32(15647);
      public const ERROR_APPX_RAW_DATA_WRITE_FAILED = UInt32(15648);
      public const ERROR_DEPLOYMENT_BLOCKED_BY_VOLUME_POLICY_PACKAGE = UInt32(15649);
      public const ERROR_DEPLOYMENT_BLOCKED_BY_VOLUME_POLICY_MACHINE = UInt32(15650);
      public const ERROR_DEPLOYMENT_BLOCKED_BY_PROFILE_POLICY = UInt32(15651);
      public const ERROR_DEPLOYMENT_FAILED_CONFLICTING_MUTABLE_PACKAGE_DIRECTORY = UInt32(15652);
      public const ERROR_SINGLETON_RESOURCE_INSTALLED_IN_ACTIVE_USER = UInt32(15653);
      public const ERROR_DIFFERENT_VERSION_OF_PACKAGED_SERVICE_INSTALLED = UInt32(15654);
      public const ERROR_SERVICE_EXISTS_AS_NON_PACKAGED_SERVICE = UInt32(15655);
      public const ERROR_PACKAGED_SERVICE_REQUIRES_ADMIN_PRIVILEGES = UInt32(15656);
      public const ERROR_REDIRECTION_TO_DEFAULT_ACCOUNT_NOT_ALLOWED = UInt32(15657);
      public const ERROR_PACKAGE_LACKS_CAPABILITY_TO_DEPLOY_ON_HOST = UInt32(15658);
      public const ERROR_UNSIGNED_PACKAGE_INVALID_CONTENT = UInt32(15659);
      public const ERROR_UNSIGNED_PACKAGE_INVALID_PUBLISHER_NAMESPACE = UInt32(15660);
      public const ERROR_SIGNED_PACKAGE_INVALID_PUBLISHER_NAMESPACE = UInt32(15661);
      public const ERROR_PACKAGE_EXTERNAL_LOCATION_NOT_ALLOWED = UInt32(15662);
      public const ERROR_INSTALL_FULLTRUST_HOSTRUNTIME_REQUIRES_MAIN_PACKAGE_FULLTRUST_CAPABILITY = UInt32(15663);
      public const ERROR_PACKAGE_LACKS_CAPABILITY_FOR_MANDATORY_STARTUPTASKS = UInt32(15664);
      public const ERROR_INSTALL_RESOLVE_HOSTRUNTIME_DEPENDENCY_FAILED = UInt32(15665);
      public const ERROR_MACHINE_SCOPE_NOT_ALLOWED = UInt32(15666);
      public const ERROR_CLASSIC_COMPAT_MODE_NOT_ALLOWED = UInt32(15667);
      public const ERROR_STAGEFROMUPDATEAGENT_PACKAGE_NOT_APPLICABLE = UInt32(15668);
      public const ERROR_PACKAGE_NOT_REGISTERED_FOR_USER = UInt32(15669);
      public const ERROR_PACKAGE_NAME_MISMATCH = UInt32(15670);
      public const ERROR_APPINSTALLER_URI_IN_USE = UInt32(15671);
      public const ERROR_APPINSTALLER_IS_MANAGED_BY_SYSTEM = UInt32(15672);
      public const APPMODEL_ERROR_NO_PACKAGE = UInt32(15700);
      public const APPMODEL_ERROR_PACKAGE_RUNTIME_CORRUPT = UInt32(15701);
      public const APPMODEL_ERROR_PACKAGE_IDENTITY_CORRUPT = UInt32(15702);
      public const APPMODEL_ERROR_NO_APPLICATION = UInt32(15703);
      public const APPMODEL_ERROR_DYNAMIC_PROPERTY_READ_FAILED = UInt32(15704);
      public const APPMODEL_ERROR_DYNAMIC_PROPERTY_INVALID = UInt32(15705);
      public const APPMODEL_ERROR_PACKAGE_NOT_AVAILABLE = UInt32(15706);
      public const APPMODEL_ERROR_NO_MUTABLE_DIRECTORY = UInt32(15707);
      public const ERROR_STATE_LOAD_STORE_FAILED = UInt32(15800);
      public const ERROR_STATE_GET_VERSION_FAILED = UInt32(15801);
      public const ERROR_STATE_SET_VERSION_FAILED = UInt32(15802);
      public const ERROR_STATE_STRUCTURED_RESET_FAILED = UInt32(15803);
      public const ERROR_STATE_OPEN_CONTAINER_FAILED = UInt32(15804);
      public const ERROR_STATE_CREATE_CONTAINER_FAILED = UInt32(15805);
      public const ERROR_STATE_DELETE_CONTAINER_FAILED = UInt32(15806);
      public const ERROR_STATE_READ_SETTING_FAILED = UInt32(15807);
      public const ERROR_STATE_WRITE_SETTING_FAILED = UInt32(15808);
      public const ERROR_STATE_DELETE_SETTING_FAILED = UInt32(15809);
      public const ERROR_STATE_QUERY_SETTING_FAILED = UInt32(15810);
      public const ERROR_STATE_READ_COMPOSITE_SETTING_FAILED = UInt32(15811);
      public const ERROR_STATE_WRITE_COMPOSITE_SETTING_FAILED = UInt32(15812);
      public const ERROR_STATE_ENUMERATE_CONTAINER_FAILED = UInt32(15813);
      public const ERROR_STATE_ENUMERATE_SETTINGS_FAILED = UInt32(15814);
      public const ERROR_STATE_COMPOSITE_SETTING_VALUE_SIZE_LIMIT_EXCEEDED = UInt32(15815);
      public const ERROR_STATE_SETTING_VALUE_SIZE_LIMIT_EXCEEDED = UInt32(15816);
      public const ERROR_STATE_SETTING_NAME_SIZE_LIMIT_EXCEEDED = UInt32(15817);
      public const ERROR_STATE_CONTAINER_NAME_SIZE_LIMIT_EXCEEDED = UInt32(15818);
      public const ERROR_API_UNAVAILABLE = UInt32(15841);
      public const ERROR_NDIS_INTERFACE_CLOSING = UInt32(2150891522);
      public const ERROR_NDIS_BAD_VERSION = UInt32(2150891524);
      public const ERROR_NDIS_BAD_CHARACTERISTICS = UInt32(2150891525);
      public const ERROR_NDIS_ADAPTER_NOT_FOUND = UInt32(2150891526);
      public const ERROR_NDIS_OPEN_FAILED = UInt32(2150891527);
      public const ERROR_NDIS_DEVICE_FAILED = UInt32(2150891528);
      public const ERROR_NDIS_MULTICAST_FULL = UInt32(2150891529);
      public const ERROR_NDIS_MULTICAST_EXISTS = UInt32(2150891530);
      public const ERROR_NDIS_MULTICAST_NOT_FOUND = UInt32(2150891531);
      public const ERROR_NDIS_REQUEST_ABORTED = UInt32(2150891532);
      public const ERROR_NDIS_RESET_IN_PROGRESS = UInt32(2150891533);
      public const ERROR_NDIS_NOT_SUPPORTED = UInt32(2150891707);
      public const ERROR_NDIS_INVALID_PACKET = UInt32(2150891535);
      public const ERROR_NDIS_ADAPTER_NOT_READY = UInt32(2150891537);
      public const ERROR_NDIS_INVALID_LENGTH = UInt32(2150891540);
      public const ERROR_NDIS_INVALID_DATA = UInt32(2150891541);
      public const ERROR_NDIS_BUFFER_TOO_SHORT = UInt32(2150891542);
      public const ERROR_NDIS_INVALID_OID = UInt32(2150891543);
      public const ERROR_NDIS_ADAPTER_REMOVED = UInt32(2150891544);
      public const ERROR_NDIS_UNSUPPORTED_MEDIA = UInt32(2150891545);
      public const ERROR_NDIS_GROUP_ADDRESS_IN_USE = UInt32(2150891546);
      public const ERROR_NDIS_FILE_NOT_FOUND = UInt32(2150891547);
      public const ERROR_NDIS_ERROR_READING_FILE = UInt32(2150891548);
      public const ERROR_NDIS_ALREADY_MAPPED = UInt32(2150891549);
      public const ERROR_NDIS_RESOURCE_CONFLICT = UInt32(2150891550);
      public const ERROR_NDIS_MEDIA_DISCONNECTED = UInt32(2150891551);
      public const ERROR_NDIS_INVALID_ADDRESS = UInt32(2150891554);
      public const ERROR_NDIS_INVALID_DEVICE_REQUEST = UInt32(2150891536);
      public const ERROR_NDIS_PAUSED = UInt32(2150891562);
      public const ERROR_NDIS_INTERFACE_NOT_FOUND = UInt32(2150891563);
      public const ERROR_NDIS_UNSUPPORTED_REVISION = UInt32(2150891564);
      public const ERROR_NDIS_INVALID_PORT = UInt32(2150891565);
      public const ERROR_NDIS_INVALID_PORT_STATE = UInt32(2150891566);
      public const ERROR_NDIS_LOW_POWER_STATE = UInt32(2150891567);
      public const ERROR_NDIS_REINIT_REQUIRED = UInt32(2150891568);
      public const ERROR_NDIS_NO_QUEUES = UInt32(2150891569);
      public const ERROR_NDIS_DOT11_AUTO_CONFIG_ENABLED = UInt32(2150899712);
      public const ERROR_NDIS_DOT11_MEDIA_IN_USE = UInt32(2150899713);
      public const ERROR_NDIS_DOT11_POWER_STATE_INVALID = UInt32(2150899714);
      public const ERROR_NDIS_PM_WOL_PATTERN_LIST_FULL = UInt32(2150899715);
      public const ERROR_NDIS_PM_PROTOCOL_OFFLOAD_LIST_FULL = UInt32(2150899716);
      public const ERROR_NDIS_DOT11_AP_CHANNEL_CURRENTLY_NOT_AVAILABLE = UInt32(2150899717);
      public const ERROR_NDIS_DOT11_AP_BAND_CURRENTLY_NOT_AVAILABLE = UInt32(2150899718);
      public const ERROR_NDIS_DOT11_AP_CHANNEL_NOT_ALLOWED = UInt32(2150899719);
      public const ERROR_NDIS_DOT11_AP_BAND_NOT_ALLOWED = UInt32(2150899720);
      public const ERROR_NDIS_INDICATION_REQUIRED = UInt32(3407873);
      public const ERROR_NDIS_OFFLOAD_POLICY = UInt32(3224637455);
      public const ERROR_NDIS_OFFLOAD_CONNECTION_REJECTED = UInt32(3224637458);
      public const ERROR_NDIS_OFFLOAD_PATH_REJECTED = UInt32(3224637459);
      public const ERROR_HV_INVALID_HYPERCALL_CODE = UInt32(3224698882);
      public const ERROR_HV_INVALID_HYPERCALL_INPUT = UInt32(3224698883);
      public const ERROR_HV_INVALID_ALIGNMENT = UInt32(3224698884);
      public const ERROR_HV_INVALID_PARAMETER = UInt32(3224698885);
      public const ERROR_HV_ACCESS_DENIED = UInt32(3224698886);
      public const ERROR_HV_INVALID_PARTITION_STATE = UInt32(3224698887);
      public const ERROR_HV_OPERATION_DENIED = UInt32(3224698888);
      public const ERROR_HV_UNKNOWN_PROPERTY = UInt32(3224698889);
      public const ERROR_HV_PROPERTY_VALUE_OUT_OF_RANGE = UInt32(3224698890);
      public const ERROR_HV_INSUFFICIENT_MEMORY = UInt32(3224698891);
      public const ERROR_HV_PARTITION_TOO_DEEP = UInt32(3224698892);
      public const ERROR_HV_INVALID_PARTITION_ID = UInt32(3224698893);
      public const ERROR_HV_INVALID_VP_INDEX = UInt32(3224698894);
      public const ERROR_HV_INVALID_PORT_ID = UInt32(3224698897);
      public const ERROR_HV_INVALID_CONNECTION_ID = UInt32(3224698898);
      public const ERROR_HV_INSUFFICIENT_BUFFERS = UInt32(3224698899);
      public const ERROR_HV_NOT_ACKNOWLEDGED = UInt32(3224698900);
      public const ERROR_HV_INVALID_VP_STATE = UInt32(3224698901);
      public const ERROR_HV_ACKNOWLEDGED = UInt32(3224698902);
      public const ERROR_HV_INVALID_SAVE_RESTORE_STATE = UInt32(3224698903);
      public const ERROR_HV_INVALID_SYNIC_STATE = UInt32(3224698904);
      public const ERROR_HV_OBJECT_IN_USE = UInt32(3224698905);
      public const ERROR_HV_INVALID_PROXIMITY_DOMAIN_INFO = UInt32(3224698906);
      public const ERROR_HV_NO_DATA = UInt32(3224698907);
      public const ERROR_HV_INACTIVE = UInt32(3224698908);
      public const ERROR_HV_NO_RESOURCES = UInt32(3224698909);
      public const ERROR_HV_FEATURE_UNAVAILABLE = UInt32(3224698910);
      public const ERROR_HV_INSUFFICIENT_BUFFER = UInt32(3224698931);
      public const ERROR_HV_INSUFFICIENT_DEVICE_DOMAINS = UInt32(3224698936);
      public const ERROR_HV_CPUID_FEATURE_VALIDATION = UInt32(3224698940);
      public const ERROR_HV_CPUID_XSAVE_FEATURE_VALIDATION = UInt32(3224698941);
      public const ERROR_HV_PROCESSOR_STARTUP_TIMEOUT = UInt32(3224698942);
      public const ERROR_HV_SMX_ENABLED = UInt32(3224698943);
      public const ERROR_HV_INVALID_LP_INDEX = UInt32(3224698945);
      public const ERROR_HV_INVALID_REGISTER_VALUE = UInt32(3224698960);
      public const ERROR_HV_INVALID_VTL_STATE = UInt32(3224698961);
      public const ERROR_HV_NX_NOT_DETECTED = UInt32(3224698965);
      public const ERROR_HV_INVALID_DEVICE_ID = UInt32(3224698967);
      public const ERROR_HV_INVALID_DEVICE_STATE = UInt32(3224698968);
      public const ERROR_HV_PENDING_PAGE_REQUESTS = UInt32(3473497);
      public const ERROR_HV_PAGE_REQUEST_INVALID = UInt32(3224698976);
      public const ERROR_HV_INVALID_CPU_GROUP_ID = UInt32(3224698991);
      public const ERROR_HV_INVALID_CPU_GROUP_STATE = UInt32(3224698992);
      public const ERROR_HV_OPERATION_FAILED = UInt32(3224698993);
      public const ERROR_HV_NOT_ALLOWED_WITH_NESTED_VIRT_ACTIVE = UInt32(3224698994);
      public const ERROR_HV_INSUFFICIENT_ROOT_MEMORY = UInt32(3224698995);
      public const ERROR_HV_EVENT_BUFFER_ALREADY_FREED = UInt32(3224698996);
      public const ERROR_HV_INSUFFICIENT_CONTIGUOUS_MEMORY = UInt32(3224698997);
      public const ERROR_HV_DEVICE_NOT_IN_DOMAIN = UInt32(3224698998);
      public const ERROR_HV_NESTED_VM_EXIT = UInt32(3224698999);
      public const ERROR_HV_MSR_ACCESS_FAILED = UInt32(3224699008);
      public const ERROR_HV_INSUFFICIENT_MEMORY_MIRRORING = UInt32(3224699009);
      public const ERROR_HV_INSUFFICIENT_CONTIGUOUS_MEMORY_MIRRORING = UInt32(3224699010);
      public const ERROR_HV_INSUFFICIENT_CONTIGUOUS_ROOT_MEMORY = UInt32(3224699011);
      public const ERROR_HV_INSUFFICIENT_ROOT_MEMORY_MIRRORING = UInt32(3224699012);
      public const ERROR_HV_INSUFFICIENT_CONTIGUOUS_ROOT_MEMORY_MIRRORING = UInt32(3224699013);
      public const ERROR_HV_NOT_PRESENT = UInt32(3224702976);
      public const ERROR_VID_DUPLICATE_HANDLER = UInt32(3224829953);
      public const ERROR_VID_TOO_MANY_HANDLERS = UInt32(3224829954);
      public const ERROR_VID_QUEUE_FULL = UInt32(3224829955);
      public const ERROR_VID_HANDLER_NOT_PRESENT = UInt32(3224829956);
      public const ERROR_VID_INVALID_OBJECT_NAME = UInt32(3224829957);
      public const ERROR_VID_PARTITION_NAME_TOO_LONG = UInt32(3224829958);
      public const ERROR_VID_MESSAGE_QUEUE_NAME_TOO_LONG = UInt32(3224829959);
      public const ERROR_VID_PARTITION_ALREADY_EXISTS = UInt32(3224829960);
      public const ERROR_VID_PARTITION_DOES_NOT_EXIST = UInt32(3224829961);
      public const ERROR_VID_PARTITION_NAME_NOT_FOUND = UInt32(3224829962);
      public const ERROR_VID_MESSAGE_QUEUE_ALREADY_EXISTS = UInt32(3224829963);
      public const ERROR_VID_EXCEEDED_MBP_ENTRY_MAP_LIMIT = UInt32(3224829964);
      public const ERROR_VID_MB_STILL_REFERENCED = UInt32(3224829965);
      public const ERROR_VID_CHILD_GPA_PAGE_SET_CORRUPTED = UInt32(3224829966);
      public const ERROR_VID_INVALID_NUMA_SETTINGS = UInt32(3224829967);
      public const ERROR_VID_INVALID_NUMA_NODE_INDEX = UInt32(3224829968);
      public const ERROR_VID_NOTIFICATION_QUEUE_ALREADY_ASSOCIATED = UInt32(3224829969);
      public const ERROR_VID_INVALID_MEMORY_BLOCK_HANDLE = UInt32(3224829970);
      public const ERROR_VID_PAGE_RANGE_OVERFLOW = UInt32(3224829971);
      public const ERROR_VID_INVALID_MESSAGE_QUEUE_HANDLE = UInt32(3224829972);
      public const ERROR_VID_INVALID_GPA_RANGE_HANDLE = UInt32(3224829973);
      public const ERROR_VID_NO_MEMORY_BLOCK_NOTIFICATION_QUEUE = UInt32(3224829974);
      public const ERROR_VID_MEMORY_BLOCK_LOCK_COUNT_EXCEEDED = UInt32(3224829975);
      public const ERROR_VID_INVALID_PPM_HANDLE = UInt32(3224829976);
      public const ERROR_VID_MBPS_ARE_LOCKED = UInt32(3224829977);
      public const ERROR_VID_MESSAGE_QUEUE_CLOSED = UInt32(3224829978);
      public const ERROR_VID_VIRTUAL_PROCESSOR_LIMIT_EXCEEDED = UInt32(3224829979);
      public const ERROR_VID_STOP_PENDING = UInt32(3224829980);
      public const ERROR_VID_INVALID_PROCESSOR_STATE = UInt32(3224829981);
      public const ERROR_VID_EXCEEDED_KM_CONTEXT_COUNT_LIMIT = UInt32(3224829982);
      public const ERROR_VID_KM_INTERFACE_ALREADY_INITIALIZED = UInt32(3224829983);
      public const ERROR_VID_MB_PROPERTY_ALREADY_SET_RESET = UInt32(3224829984);
      public const ERROR_VID_MMIO_RANGE_DESTROYED = UInt32(3224829985);
      public const ERROR_VID_INVALID_CHILD_GPA_PAGE_SET = UInt32(3224829986);
      public const ERROR_VID_RESERVE_PAGE_SET_IS_BEING_USED = UInt32(3224829987);
      public const ERROR_VID_RESERVE_PAGE_SET_TOO_SMALL = UInt32(3224829988);
      public const ERROR_VID_MBP_ALREADY_LOCKED_USING_RESERVED_PAGE = UInt32(3224829989);
      public const ERROR_VID_MBP_COUNT_EXCEEDED_LIMIT = UInt32(3224829990);
      public const ERROR_VID_SAVED_STATE_CORRUPT = UInt32(3224829991);
      public const ERROR_VID_SAVED_STATE_UNRECOGNIZED_ITEM = UInt32(3224829992);
      public const ERROR_VID_SAVED_STATE_INCOMPATIBLE = UInt32(3224829993);
      public const ERROR_VID_VTL_ACCESS_DENIED = UInt32(3224829994);
      public const ERROR_VID_INSUFFICIENT_RESOURCES_RESERVE = UInt32(3224829995);
      public const ERROR_VID_INSUFFICIENT_RESOURCES_PHYSICAL_BUFFER = UInt32(3224829996);
      public const ERROR_VID_INSUFFICIENT_RESOURCES_HV_DEPOSIT = UInt32(3224829997);
      public const ERROR_VID_MEMORY_TYPE_NOT_SUPPORTED = UInt32(3224829998);
      public const ERROR_VID_INSUFFICIENT_RESOURCES_WITHDRAW = UInt32(3224829999);
      public const ERROR_VID_PROCESS_ALREADY_SET = UInt32(3224830000);
      public const ERROR_VMCOMPUTE_TERMINATED_DURING_START = UInt32(3224830208);
      public const ERROR_VMCOMPUTE_IMAGE_MISMATCH = UInt32(3224830209);
      public const ERROR_VMCOMPUTE_HYPERV_NOT_INSTALLED = UInt32(3224830210);
      public const ERROR_VMCOMPUTE_OPERATION_PENDING = UInt32(3224830211);
      public const ERROR_VMCOMPUTE_TOO_MANY_NOTIFICATIONS = UInt32(3224830212);
      public const ERROR_VMCOMPUTE_INVALID_STATE = UInt32(3224830213);
      public const ERROR_VMCOMPUTE_UNEXPECTED_EXIT = UInt32(3224830214);
      public const ERROR_VMCOMPUTE_TERMINATED = UInt32(3224830215);
      public const ERROR_VMCOMPUTE_CONNECT_FAILED = UInt32(3224830216);
      public const ERROR_VMCOMPUTE_TIMEOUT = UInt32(3224830217);
      public const ERROR_VMCOMPUTE_CONNECTION_CLOSED = UInt32(3224830218);
      public const ERROR_VMCOMPUTE_UNKNOWN_MESSAGE = UInt32(3224830219);
      public const ERROR_VMCOMPUTE_UNSUPPORTED_PROTOCOL_VERSION = UInt32(3224830220);
      public const ERROR_VMCOMPUTE_INVALID_JSON = UInt32(3224830221);
      public const ERROR_VMCOMPUTE_SYSTEM_NOT_FOUND = UInt32(3224830222);
      public const ERROR_VMCOMPUTE_SYSTEM_ALREADY_EXISTS = UInt32(3224830223);
      public const ERROR_VMCOMPUTE_SYSTEM_ALREADY_STOPPED = UInt32(3224830224);
      public const ERROR_VMCOMPUTE_PROTOCOL_ERROR = UInt32(3224830225);
      public const ERROR_VMCOMPUTE_INVALID_LAYER = UInt32(3224830226);
      public const ERROR_VMCOMPUTE_WINDOWS_INSIDER_REQUIRED = UInt32(3224830227);
      public const ERROR_VNET_VIRTUAL_SWITCH_NAME_NOT_FOUND = UInt32(3224830464);
      public const ERROR_VID_REMOTE_NODE_PARENT_GPA_PAGES_USED = UInt32(2151088129);
      public const ERROR_VSMB_SAVED_STATE_FILE_NOT_FOUND = UInt32(3224830976);
      public const ERROR_VSMB_SAVED_STATE_CORRUPT = UInt32(3224830977);
      public const ERROR_VOLMGR_INCOMPLETE_REGENERATION = UInt32(2151153665);
      public const ERROR_VOLMGR_INCOMPLETE_DISK_MIGRATION = UInt32(2151153666);
      public const ERROR_VOLMGR_DATABASE_FULL = UInt32(3224895489);
      public const ERROR_VOLMGR_DISK_CONFIGURATION_CORRUPTED = UInt32(3224895490);
      public const ERROR_VOLMGR_DISK_CONFIGURATION_NOT_IN_SYNC = UInt32(3224895491);
      public const ERROR_VOLMGR_PACK_CONFIG_UPDATE_FAILED = UInt32(3224895492);
      public const ERROR_VOLMGR_DISK_CONTAINS_NON_SIMPLE_VOLUME = UInt32(3224895493);
      public const ERROR_VOLMGR_DISK_DUPLICATE = UInt32(3224895494);
      public const ERROR_VOLMGR_DISK_DYNAMIC = UInt32(3224895495);
      public const ERROR_VOLMGR_DISK_ID_INVALID = UInt32(3224895496);
      public const ERROR_VOLMGR_DISK_INVALID = UInt32(3224895497);
      public const ERROR_VOLMGR_DISK_LAST_VOTER = UInt32(3224895498);
      public const ERROR_VOLMGR_DISK_LAYOUT_INVALID = UInt32(3224895499);
      public const ERROR_VOLMGR_DISK_LAYOUT_NON_BASIC_BETWEEN_BASIC_PARTITIONS = UInt32(3224895500);
      public const ERROR_VOLMGR_DISK_LAYOUT_NOT_CYLINDER_ALIGNED = UInt32(3224895501);
      public const ERROR_VOLMGR_DISK_LAYOUT_PARTITIONS_TOO_SMALL = UInt32(3224895502);
      public const ERROR_VOLMGR_DISK_LAYOUT_PRIMARY_BETWEEN_LOGICAL_PARTITIONS = UInt32(3224895503);
      public const ERROR_VOLMGR_DISK_LAYOUT_TOO_MANY_PARTITIONS = UInt32(3224895504);
      public const ERROR_VOLMGR_DISK_MISSING = UInt32(3224895505);
      public const ERROR_VOLMGR_DISK_NOT_EMPTY = UInt32(3224895506);
      public const ERROR_VOLMGR_DISK_NOT_ENOUGH_SPACE = UInt32(3224895507);
      public const ERROR_VOLMGR_DISK_REVECTORING_FAILED = UInt32(3224895508);
      public const ERROR_VOLMGR_DISK_SECTOR_SIZE_INVALID = UInt32(3224895509);
      public const ERROR_VOLMGR_DISK_SET_NOT_CONTAINED = UInt32(3224895510);
      public const ERROR_VOLMGR_DISK_USED_BY_MULTIPLE_MEMBERS = UInt32(3224895511);
      public const ERROR_VOLMGR_DISK_USED_BY_MULTIPLE_PLEXES = UInt32(3224895512);
      public const ERROR_VOLMGR_DYNAMIC_DISK_NOT_SUPPORTED = UInt32(3224895513);
      public const ERROR_VOLMGR_EXTENT_ALREADY_USED = UInt32(3224895514);
      public const ERROR_VOLMGR_EXTENT_NOT_CONTIGUOUS = UInt32(3224895515);
      public const ERROR_VOLMGR_EXTENT_NOT_IN_PUBLIC_REGION = UInt32(3224895516);
      public const ERROR_VOLMGR_EXTENT_NOT_SECTOR_ALIGNED = UInt32(3224895517);
      public const ERROR_VOLMGR_EXTENT_OVERLAPS_EBR_PARTITION = UInt32(3224895518);
      public const ERROR_VOLMGR_EXTENT_VOLUME_LENGTHS_DO_NOT_MATCH = UInt32(3224895519);
      public const ERROR_VOLMGR_FAULT_TOLERANT_NOT_SUPPORTED = UInt32(3224895520);
      public const ERROR_VOLMGR_INTERLEAVE_LENGTH_INVALID = UInt32(3224895521);
      public const ERROR_VOLMGR_MAXIMUM_REGISTERED_USERS = UInt32(3224895522);
      public const ERROR_VOLMGR_MEMBER_IN_SYNC = UInt32(3224895523);
      public const ERROR_VOLMGR_MEMBER_INDEX_DUPLICATE = UInt32(3224895524);
      public const ERROR_VOLMGR_MEMBER_INDEX_INVALID = UInt32(3224895525);
      public const ERROR_VOLMGR_MEMBER_MISSING = UInt32(3224895526);
      public const ERROR_VOLMGR_MEMBER_NOT_DETACHED = UInt32(3224895527);
      public const ERROR_VOLMGR_MEMBER_REGENERATING = UInt32(3224895528);
      public const ERROR_VOLMGR_ALL_DISKS_FAILED = UInt32(3224895529);
      public const ERROR_VOLMGR_NO_REGISTERED_USERS = UInt32(3224895530);
      public const ERROR_VOLMGR_NO_SUCH_USER = UInt32(3224895531);
      public const ERROR_VOLMGR_NOTIFICATION_RESET = UInt32(3224895532);
      public const ERROR_VOLMGR_NUMBER_OF_MEMBERS_INVALID = UInt32(3224895533);
      public const ERROR_VOLMGR_NUMBER_OF_PLEXES_INVALID = UInt32(3224895534);
      public const ERROR_VOLMGR_PACK_DUPLICATE = UInt32(3224895535);
      public const ERROR_VOLMGR_PACK_ID_INVALID = UInt32(3224895536);
      public const ERROR_VOLMGR_PACK_INVALID = UInt32(3224895537);
      public const ERROR_VOLMGR_PACK_NAME_INVALID = UInt32(3224895538);
      public const ERROR_VOLMGR_PACK_OFFLINE = UInt32(3224895539);
      public const ERROR_VOLMGR_PACK_HAS_QUORUM = UInt32(3224895540);
      public const ERROR_VOLMGR_PACK_WITHOUT_QUORUM = UInt32(3224895541);
      public const ERROR_VOLMGR_PARTITION_STYLE_INVALID = UInt32(3224895542);
      public const ERROR_VOLMGR_PARTITION_UPDATE_FAILED = UInt32(3224895543);
      public const ERROR_VOLMGR_PLEX_IN_SYNC = UInt32(3224895544);
      public const ERROR_VOLMGR_PLEX_INDEX_DUPLICATE = UInt32(3224895545);
      public const ERROR_VOLMGR_PLEX_INDEX_INVALID = UInt32(3224895546);
      public const ERROR_VOLMGR_PLEX_LAST_ACTIVE = UInt32(3224895547);
      public const ERROR_VOLMGR_PLEX_MISSING = UInt32(3224895548);
      public const ERROR_VOLMGR_PLEX_REGENERATING = UInt32(3224895549);
      public const ERROR_VOLMGR_PLEX_TYPE_INVALID = UInt32(3224895550);
      public const ERROR_VOLMGR_PLEX_NOT_RAID5 = UInt32(3224895551);
      public const ERROR_VOLMGR_PLEX_NOT_SIMPLE = UInt32(3224895552);
      public const ERROR_VOLMGR_STRUCTURE_SIZE_INVALID = UInt32(3224895553);
      public const ERROR_VOLMGR_TOO_MANY_NOTIFICATION_REQUESTS = UInt32(3224895554);
      public const ERROR_VOLMGR_TRANSACTION_IN_PROGRESS = UInt32(3224895555);
      public const ERROR_VOLMGR_UNEXPECTED_DISK_LAYOUT_CHANGE = UInt32(3224895556);
      public const ERROR_VOLMGR_VOLUME_CONTAINS_MISSING_DISK = UInt32(3224895557);
      public const ERROR_VOLMGR_VOLUME_ID_INVALID = UInt32(3224895558);
      public const ERROR_VOLMGR_VOLUME_LENGTH_INVALID = UInt32(3224895559);
      public const ERROR_VOLMGR_VOLUME_LENGTH_NOT_SECTOR_SIZE_MULTIPLE = UInt32(3224895560);
      public const ERROR_VOLMGR_VOLUME_NOT_MIRRORED = UInt32(3224895561);
      public const ERROR_VOLMGR_VOLUME_NOT_RETAINED = UInt32(3224895562);
      public const ERROR_VOLMGR_VOLUME_OFFLINE = UInt32(3224895563);
      public const ERROR_VOLMGR_VOLUME_RETAINED = UInt32(3224895564);
      public const ERROR_VOLMGR_NUMBER_OF_EXTENTS_INVALID = UInt32(3224895565);
      public const ERROR_VOLMGR_DIFFERENT_SECTOR_SIZE = UInt32(3224895566);
      public const ERROR_VOLMGR_BAD_BOOT_DISK = UInt32(3224895567);
      public const ERROR_VOLMGR_PACK_CONFIG_OFFLINE = UInt32(3224895568);
      public const ERROR_VOLMGR_PACK_CONFIG_ONLINE = UInt32(3224895569);
      public const ERROR_VOLMGR_NOT_PRIMARY_PACK = UInt32(3224895570);
      public const ERROR_VOLMGR_PACK_LOG_UPDATE_FAILED = UInt32(3224895571);
      public const ERROR_VOLMGR_NUMBER_OF_DISKS_IN_PLEX_INVALID = UInt32(3224895572);
      public const ERROR_VOLMGR_NUMBER_OF_DISKS_IN_MEMBER_INVALID = UInt32(3224895573);
      public const ERROR_VOLMGR_VOLUME_MIRRORED = UInt32(3224895574);
      public const ERROR_VOLMGR_PLEX_NOT_SIMPLE_SPANNED = UInt32(3224895575);
      public const ERROR_VOLMGR_NO_VALID_LOG_COPIES = UInt32(3224895576);
      public const ERROR_VOLMGR_PRIMARY_PACK_PRESENT = UInt32(3224895577);
      public const ERROR_VOLMGR_NUMBER_OF_DISKS_INVALID = UInt32(3224895578);
      public const ERROR_VOLMGR_MIRROR_NOT_SUPPORTED = UInt32(3224895579);
      public const ERROR_VOLMGR_RAID5_NOT_SUPPORTED = UInt32(3224895580);
      public const ERROR_BCD_NOT_ALL_ENTRIES_IMPORTED = UInt32(2151219201);
      public const ERROR_BCD_TOO_MANY_ELEMENTS = UInt32(3224961026);
      public const ERROR_BCD_NOT_ALL_ENTRIES_SYNCHRONIZED = UInt32(2151219203);
      public const ERROR_VHD_DRIVE_FOOTER_MISSING = UInt32(3225026561);
      public const ERROR_VHD_DRIVE_FOOTER_CHECKSUM_MISMATCH = UInt32(3225026562);
      public const ERROR_VHD_DRIVE_FOOTER_CORRUPT = UInt32(3225026563);
      public const ERROR_VHD_FORMAT_UNKNOWN = UInt32(3225026564);
      public const ERROR_VHD_FORMAT_UNSUPPORTED_VERSION = UInt32(3225026565);
      public const ERROR_VHD_SPARSE_HEADER_CHECKSUM_MISMATCH = UInt32(3225026566);
      public const ERROR_VHD_SPARSE_HEADER_UNSUPPORTED_VERSION = UInt32(3225026567);
      public const ERROR_VHD_SPARSE_HEADER_CORRUPT = UInt32(3225026568);
      public const ERROR_VHD_BLOCK_ALLOCATION_FAILURE = UInt32(3225026569);
      public const ERROR_VHD_BLOCK_ALLOCATION_TABLE_CORRUPT = UInt32(3225026570);
      public const ERROR_VHD_INVALID_BLOCK_SIZE = UInt32(3225026571);
      public const ERROR_VHD_BITMAP_MISMATCH = UInt32(3225026572);
      public const ERROR_VHD_PARENT_VHD_NOT_FOUND = UInt32(3225026573);
      public const ERROR_VHD_CHILD_PARENT_ID_MISMATCH = UInt32(3225026574);
      public const ERROR_VHD_CHILD_PARENT_TIMESTAMP_MISMATCH = UInt32(3225026575);
      public const ERROR_VHD_METADATA_READ_FAILURE = UInt32(3225026576);
      public const ERROR_VHD_METADATA_WRITE_FAILURE = UInt32(3225026577);
      public const ERROR_VHD_INVALID_SIZE = UInt32(3225026578);
      public const ERROR_VHD_INVALID_FILE_SIZE = UInt32(3225026579);
      public const ERROR_VIRTDISK_PROVIDER_NOT_FOUND = UInt32(3225026580);
      public const ERROR_VIRTDISK_NOT_VIRTUAL_DISK = UInt32(3225026581);
      public const ERROR_VHD_PARENT_VHD_ACCESS_DENIED = UInt32(3225026582);
      public const ERROR_VHD_CHILD_PARENT_SIZE_MISMATCH = UInt32(3225026583);
      public const ERROR_VHD_DIFFERENCING_CHAIN_CYCLE_DETECTED = UInt32(3225026584);
      public const ERROR_VHD_DIFFERENCING_CHAIN_ERROR_IN_PARENT = UInt32(3225026585);
      public const ERROR_VIRTUAL_DISK_LIMITATION = UInt32(3225026586);
      public const ERROR_VHD_INVALID_TYPE = UInt32(3225026587);
      public const ERROR_VHD_INVALID_STATE = UInt32(3225026588);
      public const ERROR_VIRTDISK_UNSUPPORTED_DISK_SECTOR_SIZE = UInt32(3225026589);
      public const ERROR_VIRTDISK_DISK_ALREADY_OWNED = UInt32(3225026590);
      public const ERROR_VIRTDISK_DISK_ONLINE_AND_WRITABLE = UInt32(3225026591);
      public const ERROR_CTLOG_TRACKING_NOT_INITIALIZED = UInt32(3225026592);
      public const ERROR_CTLOG_LOGFILE_SIZE_EXCEEDED_MAXSIZE = UInt32(3225026593);
      public const ERROR_CTLOG_VHD_CHANGED_OFFLINE = UInt32(3225026594);
      public const ERROR_CTLOG_INVALID_TRACKING_STATE = UInt32(3225026595);
      public const ERROR_CTLOG_INCONSISTENT_TRACKING_FILE = UInt32(3225026596);
      public const ERROR_VHD_RESIZE_WOULD_TRUNCATE_DATA = UInt32(3225026597);
      public const ERROR_VHD_COULD_NOT_COMPUTE_MINIMUM_VIRTUAL_SIZE = UInt32(3225026598);
      public const ERROR_VHD_ALREADY_AT_OR_BELOW_MINIMUM_VIRTUAL_SIZE = UInt32(3225026599);
      public const ERROR_VHD_METADATA_FULL = UInt32(3225026600);
      public const ERROR_VHD_INVALID_CHANGE_TRACKING_ID = UInt32(3225026601);
      public const ERROR_VHD_CHANGE_TRACKING_DISABLED = UInt32(3225026602);
      public const ERROR_VHD_MISSING_CHANGE_TRACKING_INFORMATION = UInt32(3225026608);
      public const ERROR_QUERY_STORAGE_ERROR = UInt32(2151284737);
   end;

   { PInvokeCore }

   PInvokeCore = class sealed (*static*)

      /// <summary>
      ///   { Win32Check é usado para verificar o valor de retorno de uma função da API Win32 }
      ///   { que retorna um BOOL para indicar sucesso. Se a função da API Win32 }
      ///   { retornar Falso (indicando falha), Win32Check chama RaiseLastOSError }
      ///   { para gerar uma exceção. Se a função da API Win32 retornar Verdadeiro, }
      ///   { Win32Check retorna Verdadeiro. }
      /// </summary>
      strict private class function Win32Check(RetVal: Boolean): Boolean; overload; static;

      /// <summary>
      ///   { Win32Check é usado para verificar o valor de retorno de uma função da API Win32 }
      ///   { que retorna um BOOL para indicar sucesso. Se a função da API Win32 }
      ///   { retornar Falso (indicando falha), Win32Check chama RaiseLastOSError }
      ///   { para gerar uma exceção. Se a função da API Win32 retornar Verdadeiro, }
      ///   { Win32Check retorna Verdadeiro. }
      /// </summary>
      strict private class function Win32Check(RetVal: NativeInt): NativeInt; overload; static;

      /// <summary>
      ///   { Win32Check é usado para verificar o valor de retorno de uma função da API Win32 }
      ///   { que retorna um BOOL para indicar sucesso. Se a função da API Win32 }
      ///   { retornar Falso (indicando falha), Win32Check chama RaiseLastOSError }
      ///   { para gerar uma exceção. Se a função da API Win32 retornar Verdadeiro, }
      ///   { Win32Check retorna Verdadeiro. }
      /// </summary>
      strict private class function Win32Check(RetVal: NativeUInt): NativeUInt; overload; static;

      /// <summary>Cria uma nova imagem (ícone, cursor ou bitmap) e copia os atributos da imagem especificada para a nova. Se necessário, a função estica os bits para se ajustarem ao tamanho desejado da nova imagem.</summary>
      /// <param name="h">
      /// <para>Tipo: <b>HANDLE</b> Um identificador para a imagem a ser copiada.</para>
      /// <para><see href="https://learn.microsoft.com/windows/win32/api/winuser/nf-winuser-copyimage#parameters">Leia mais em docs.microsoft.com</see>.</para>
      /// </param>
      /// <param name="type">Tipo: <b>UINT</b></param>
      /// <param name="cx">
      /// <para>Tipo: <b>int</b> A largura desejada, em pixels, da imagem. Se isto for zero, então a imagem retornada terá a mesma largura que a original <i>hImage</i>.</para>
      /// <para><see href="https://learn.microsoft.com/windows/win32/api/winuser/nf-winuser-copyimage#parameters">Leia mais em docs.microsoft.com</see>.</para>
      /// </param>
      /// <param name="cy">
      /// <para>Tipo: <b>int</b> A altura desejada, em pixels, da imagem. Se isto for zero, então a imagem retornada terá a mesma altura que a original <i>hImage</i>.</para>
      /// <para><see href="https://learn.microsoft.com/windows/win32/api/winuser/nf-winuser-copyimage#parameters">Leia mais em docs.microsoft.com</see>.</para>
      /// </param>
      /// <param name="flags">Tipo: <b>UINT</b></param>
      /// <returns>
      /// <para>Tipo: <b>HANDLE</b> Se a função for bem-sucedida, o valor de retorno é o identificador para a imagem recém-criada. Se a função falhar, o valor de retorno é <b>NULL</b>. Para obter informações de erro estendidas, chame <a href="https://docs.microsoft.com/windows/desktop/api/errhandlingapi/nf-errhandlingapi-getlasterror">GetLastError</a>.</para>
      /// </returns>
      /// <remarks>
      /// <para>Quando você terminar de usar o recurso, pode liberar a memória associada chamando uma das funções na tabela seguinte. </para>
      /// <para>Este documento foi truncado.</para>
      /// <para><see href="https://learn.microsoft.com/windows/win32/api/winuser/nf-winuser-copyimage#">Leia mais em docs.microsoft.com</see>.</para>
      /// </remarks>
      strict private class function CopyImage(h: THandle; type_: GDI_IMAGE_TYPE; cx: Integer; cy: Integer; flags: IMAGE_FLAGS): THandle; overload; static;

      /// <inheritdoc cref="CopyImage(HANDLE, GDI_IMAGE_TYPE, int, int, IMAGE_FLAGS)"/>
      public class function CopyIcon(hImage: HICON; cx: Integer; cy: Integer; flags: IMAGE_FLAGS = Default(IMAGE_FLAGS)): HICON; overload; static;

      /// <summary>Obtém um identificador para um ícone armazenado como recurso em um arquivo ou um ícone armazenado no arquivo executável associado ao arquivo. (Unicode)</summary>
      /// <param name="hInst">
      /// <para>Tipo: <b>HINSTANCE</b> Um identificador para a instância da aplicação que está chamando.</para>
      /// <para><see href="https://learn.microsoft.com/windows/win32/api/shellapi/nf-shellapi-extractassociatediconw#parameters">Leia mais em docs.microsoft.com</see>.</para>
      /// </param>
      /// <param name="pszIconPath">
      /// <para>Tipo: <b>LPTSTR</b> Ponteiro para uma string que, na entrada, especifica o caminho completo e o nome do arquivo que contém o ícone. A função extrai o identificador do ícone desse arquivo, ou de um arquivo executável associado a esse arquivo.</para>
      /// <para>Quando esta função retorna, se o identificador do ícone foi obtido de um arquivo executável (seja um arquivo executável apontado por <i>lpIconPath</i> ou um arquivo executável associado), a função armazena o caminho completo e o nome do arquivo executável no buffer apontado por este parâmetro.</para>
      /// <para><see href="https://learn.microsoft.com/windows/win32/api/shellapi/nf-shellapi-extractassociatediconw#parameters">Leia mais em docs.microsoft.com</see>.</para>
      /// </param>
      /// <param name="piIcon">
      /// <para>Tipo: <b>LPWORD</b> Ponteiro para um valor <b>WORD</b> que, na entrada, especifica o índice do ícone cujo identificador será obtido.</para>
      /// <para>Quando a função retorna, se o identificador do ícone foi obtido de um arquivo executável (seja um arquivo executável apontado por <i>lpIconPath</i> ou um arquivo executável associado), este valor aponta para o índice do ícone nesse arquivo.</para>
      /// <para><see href="https://learn.microsoft.com/windows/win32/api/shellapi/nf-shellapi-extractassociatediconw#parameters">Leia mais em docs.microsoft.com</see>.</para>
      /// </param>
      /// <returns>
      /// <para>Tipo: <b>HICON</b> Se a função for bem-sucedida, o valor de retorno é um identificador de ícone. Se o ícone é extraído de um arquivo executável associado, a função armazena o caminho completo e o nome do arquivo executável na string apontada por <i>lpIconPath</i>, e armazena o identificador do ícone no <b>WORD</b> apontado por <i>lpiIcon</i>.</para>
      /// <para>Se a função falhar, o valor de retorno é <b>NULL</b>.</para>
      /// </returns>
      /// <remarks>
      /// <para>Quando não for mais necessário, o chamador é responsável por liberar o identificador de ícone retornado por <b>ExtractAssociatedIcon</b> chamando a função <a href="https://docs.microsoft.com/windows/desktop/api/winuser/nf-winuser-destroyicon">DestroyIcon</a>. A função <b>ExtractAssociatedIcon</b> primeiro procura pelo ícone indexado no arquivo especificado por <i>lpIconPath</i>. Se a função não puder obter o identificador do ícone desse arquivo, e o arquivo tiver um arquivo executável associado, ela procura nesse arquivo executável por um ícone. Associações com arquivos executáveis são baseadas em extensões de nome de arquivo e são armazenadas na parte do usuário do registro.</para>
      /// <para>> [!NOTE] > O cabeçalho shellapi.h define ExtractAssociatedIcon como um alias que automaticamente seleciona a versão ANSI ou Unicode desta função baseado na definição da constante de preprocessador UNICODE. Misturar o uso do alias neutro em relação à codificação com código que não é neutro em relação à codificação pode levar a discrepâncias que resultam em erros de compilação ou execução. Para mais informações, veja [Convenções para Protótipos de Função](/windows/win32/intl/conventions-for-function-prototypes).</para>
      /// <para><see href="https://learn.microsoft.com/windows/win32/api/shellapi/nf-shellapi-extractassociatediconw#">Leia mais em docs.microsoft.com</see>.</para>
      /// </remarks>
      public class function ExtractAssociatedIcon(AInstance: HINST; AIconPath: string; AIconIndex: Int32): HICON; static;


      /// <summary>Destroi um ícone e libera qualquer memória que o ícone ocupava.</summary>
      /// <param name="hIcon">
      /// <para>Tipo: <b>HICON</b> Um identificador para o ícone a ser destruído. O ícone não deve estar em uso.</para>
      /// <para><see href="https://learn.microsoft.com/windows/win32/api/winuser/nf-winuser-destroyicon#parameters">Leia mais em docs.microsoft.com</see>.</para>
      /// </param>
      /// <returns>
      /// <para>Tipo: <b>BOOL</b> Se a função for bem-sucedida, o valor de retorno é diferente de zero. Se a função falhar, o valor de retorno é zero. Para obter informações de erro estendidas, chame <a href="https://docs.microsoft.com/windows/desktop/api/errhandlingapi/nf-errhandlingapi-getlasterror">GetLastError</a>.</para>
      /// </returns>
      /// <remarks>
      /// <para>É necessário chamar <b>DestroyIcon</b> apenas para ícones e cursores criados com as seguintes funções: <a href="https://docs.microsoft.com/windows/desktop/api/winuser/nf-winuser-createiconfromresourceex">CreateIconFromResourceEx</a> (se chamado sem a bandeira <b>LR_SHARED</b>), <a href="https://docs.microsoft.com/windows/desktop/api/winuser/nf-winuser-createiconindirect">CreateIconIndirect</a>, e <a href="https://docs.microsoft.com/windows/desktop/api/winuser/nf-winuser-copyicon">CopyIcon</a>. Não use esta função para destruir um ícone compartilhado. Um ícone compartilhado é válido enquanto o módulo do qual foi carregado permanecer na memória.
      /// As seguintes funções obtêm um ícone compartilhado. </para>
      /// <para>Este documento foi truncado.</para>
      /// <para><see href="https://learn.microsoft.com/windows/win32/api/winuser/nf-winuser-destroyicon#">Leia mais em docs.microsoft.com</see>.</para>
      /// </remarks>
      public class function DestroyIcon(hIcon: HICON): Boolean; static;

      /// <summary>A função CreateRectRgn cria uma região retangular.</summary>
      /// <param name="x1">Especifica a coordenada x do canto superior esquerdo da região em unidades lógicas.</param>
      /// <param name="y1">Especifica a coordenada y do canto superior esquerdo da região em unidades lógicas.</param>
      /// <param name="x2">Especifica a coordenada x do canto inferior direito da região em unidades lógicas.</param>
      /// <param name="y2">Especifica a coordenada y do canto inferior direito da região em unidades lógicas.</param>
      /// <returns>
      /// <para>Se a função for bem-sucedida, o valor de retorno é o identificador para a região. Se a função falhar, o valor de retorno é <b>NULL</b>.</para>
      /// </returns>
      /// <remarks>
      /// <para>Quando você não precisar mais do objeto <b>HRGN</b>, chame a função <a href="https://docs.microsoft.com/windows/desktop/api/wingdi/nf-wingdi-deleteobject">DeleteObject</a> para deletá-lo.
      /// As coordenadas da região são representadas como inteiros assinados de 27 bits. As regiões criadas pelos métodos Create&lt;forma&gt;Rgn (como <b>CreateRectRgn</b> e <a href="https://docs.microsoft.com/windows/desktop/api/wingdi/nf-wingdi-createpolygonrgn">CreatePolygonRgn</a>) incluem apenas o interior da forma; o contorno da forma é excluído da região.
      /// Isso significa que qualquer ponto em uma linha entre dois vértices sequenciais não está incluído na região. Se você chamasse <a href="https://docs.microsoft.com/windows/desktop/api/wingdi/nf-wingdi-ptinregion">PtInRegion</a> para tal ponto, ele retornaria zero como resultado.</para>
      /// <para><see href="https://learn.microsoft.com/windows/win32/api/wingdi/nf-wingdi-createrectrgn#">Leia mais em docs.microsoft.com</see>.</para>
      /// </remarks>
      public class function CreateRectRgn(x1, y1, x2, y2: Integer): HRGN; static;

      /// <summary>A função GetClipRgn recupera um identificador que identifica a região de recorte definida pela aplicação atual para o contexto de dispositivo especificado.</summary>
      /// <param name="hdc">Um identificador para o contexto do dispositivo.</param>
      /// <param name="hrgn">Um identificador para uma região existente antes da função ser chamada. Após a função retornar, este parâmetro é um identificador para uma cópia da região de recorte atual.</param>
      /// <returns>Se a função for bem-sucedida e não houver uma região de recorte para o contexto de dispositivo dado, o valor de retorno é zero. Se a função for bem-sucedida e houver uma região de recorte para o contexto de dispositivo dado, o valor de retorno é 1. Se ocorrer um erro, o valor de retorno é -1.</returns>
      /// <remarks>
      /// <para>Uma região de recorte definida pela aplicação é uma região de recorte identificada pela função <a href="https://docs.microsoft.com/windows/desktop/api/wingdi/nf-wingdi-selectcliprgn">SelectClipRgn</a>. Não é uma região de recorte criada quando a aplicação chama a função <a href="https://docs.microsoft.com/windows/desktop/api/winuser/nf-winuser-beginpaint">BeginPaint</a>. Se a função for bem-sucedida, o parâmetro <i>hrgn</i> é um identificador para uma cópia da região de recorte atual. Mudanças subsequentes nesta cópia não afetarão a região de recorte atual.</para>
      /// <para><see href="https://learn.microsoft.com/windows/win32/api/wingdi/nf-wingdi-getcliprgn#">Leia mais em docs.microsoft.com</see>.</para>
      /// </remarks>
      public class function GetClipRgn(hdc: HDC; hrgn: HRGN): Integer; static;

      /// <summary>
      /// Cria uma cópia da região de recorte através de <see cref="GetClipRgn(HDC, HRGN)"/> para o dado contexto do dispositivo.
      /// </summary>
      /// <param name="hdc">Identificador para um contexto de dispositivo do qual a região de recorte será copiada.</param>
      public class function SaveClipRgn(hDC: HDC): HRGN; static;

      /// <summary>A função IntersectClipRect cria uma nova região de recorte a partir da interseção da região de recorte atual e o retângulo especificado.</summary>
      /// <param name="hdc">Um identificador para o contexto do dispositivo.</param>
      /// <param name="left">A coordenada x, em unidades lógicas, do canto superior esquerdo do retângulo.</param>
      /// <param name="top">A coordenada y, em unidades lógicas, do canto superior esquerdo do retângulo.</param>
      /// <param name="right">A coordenada x, em unidades lógicas, do canto inferior direito do retângulo.</param>
      /// <param name="bottom">A coordenada y, em unidades lógicas, do canto inferior direito do retângulo.</param>
      /// <returns>
      /// <para>O valor de retorno especifica o tipo da nova região de recorte e pode ser um dos seguintes valores. </para>
      /// <para>Este documento foi truncado.</para>
      /// </returns>
      /// <remarks>
      /// <para>As bordas inferiores e mais à direita do retângulo dado são excluídas da região de recorte. Se uma região de recorte não existe previamente, o sistema pode aplicar uma região de recorte padrão ao HDC especificado. Uma região de recorte é então criada a partir da interseção dessa região de recorte padrão e o retângulo especificado nos parâmetros da função.</para>
      /// <para><see href="https://learn.microsoft.com/windows/win32/api/wingdi/nf-wingdi-intersectcliprect#">Leia mais em docs.microsoft.com</see>.</para>
      /// </remarks>
      public class function IntersectClipRect(hdc: HDC; left, top, right, bottom: Integer): GDI_REGION_TYPE; static;

      /// <summary>Desenha um ícone ou cursor no contexto de dispositivo especificado, realizando as operações raster especificadas, e esticando ou comprimindo o ícone ou cursor conforme especificado.</summary>
      /// <param name="hdc">
      /// <para>Tipo: <b>HDC</b> Um handle para o contexto de dispositivo no qual o ícone ou cursor será desenhado.</para>
      /// <para><see href="https://learn.microsoft.com/windows/win32/api/winuser/nf-winuser-drawiconex#parameters">Leia mais em docs.microsoft.com</see>.</para>
      /// </param>
      /// <param name="xLeft">
      /// <para>Tipo: <b>int</b> A coordenada lógica x do canto superior esquerdo do ícone ou cursor.</para>
      /// <para><see href="https://learn.microsoft.com/windows/win32/api/winuser/nf-winuser-drawiconex#parameters">Leia mais em docs.microsoft.com</see>.</para>
      /// </param>
      /// <param name="yTop">
      /// <para>Tipo: <b>int</b> A coordenada lógica y do canto superior esquerdo do ícone ou cursor.</para>
      /// <para><see href="https://learn.microsoft.com/windows/win32/api/winuser/nf-winuser-drawiconex#parameters">Leia mais em docs.microsoft.com</see>.</para>
      /// </param>
      /// <param name="hIcon">
      /// <para>Tipo: <b>HICON</b> Um handle para o ícone ou cursor a ser desenhado. Este parâmetro pode identificar um cursor animado.</para>
      /// <para><see href="https://learn.microsoft.com/windows/win32/api/winuser/nf-winuser-drawiconex#parameters">Leia mais em docs.microsoft.com</see>.</para>
      /// </param>
      /// <param name="cxWidth">
      /// <para>Tipo: <b>int</b> A largura lógica do ícone ou cursor. Se este parâmetro for zero e o parâmetro <i>diFlags</i> for <b>DI_DEFAULTSIZE</b>, a função usa o valor da métrica do sistema <b>SM_CXICON</b> para definir a largura. Se este parâmetro for zero e <b>DI_DEFAULTSIZE</b> não for usado, a função usa a largura real do recurso.</para>
      /// <para><see href="https://learn.microsoft.com/windows/win32/api/winuser/nf-winuser-drawiconex#parameters">Leia mais em docs.microsoft.com</see>.</para>
      /// </param>
      /// <param name="cyWidth">
      /// <para>Tipo: <b>int</b> A altura lógica do ícone ou cursor. Se este parâmetro for zero e o parâmetro <i>diFlags</i> for <b>DI_DEFAULTSIZE</b>, a função usa o valor da métrica do sistema <b>SM_CYICON</b> para definir a altura. Se este parâmetro for zero e <b>DI_DEFAULTSIZE</b> não for usado, a função usa a altura real do recurso.</para>
      /// <para><see href="https://learn.microsoft.com/windows/win32/api/winuser/nf-winuser-drawiconex#parameters">Leia mais em docs.microsoft.com</see>.</para>
      /// </param>
      /// <param name="istepIfAniCur">
      /// <para>Tipo: <b>UINT</b> O índice do quadro a ser desenhado, se <i>hIcon</i> identificar um cursor animado. Este parâmetro é ignorado se <i>hIcon</i> não identificar um cursor animado.</para>
      /// <para><see href="https://learn.microsoft.com/windows/win32/api/winuser/nf-winuser-drawiconex#parameters">Leia mais em docs.microsoft.com</see>.</para>
      /// </param>
      /// <param name="hbrFlickerFreeDraw">
      /// <para>Tipo: <b>HBRUSH</b> Um handle para um pincel que o sistema usa para desenho sem cintilação. Se <i>hbrFlickerFreeDraw</i> for um handle de pincel válido, o sistema cria um bitmap fora da tela usando o pincel especificado para a cor de fundo, desenha o ícone ou cursor no bitmap e, em seguida, copia o bitmap para o contexto de dispositivo identificado por <i>hdc</i>. Se <i>hbrFlickerFreeDraw</i> for <b>NULL</b>, o sistema desenha o ícone ou cursor diretamente no contexto de dispositivo.</para>
      /// <para><see href="https://learn.microsoft.com/windows/win32/api/winuser/nf-winuser-drawiconex#parameters">Leia mais em docs.microsoft.com</see>.</para>
      /// </param>
      /// <param name="diFlags">Tipo: <b>UINT</b></param>
      /// <returns>
      /// <para>Tipo: <b>BOOL</b> Se a função for bem-sucedida, o valor de retorno é diferente de zero. Se a função falhar, o valor de retorno é zero. Para obter informações de erro estendidas, chame <a href="https://docs.microsoft.com/windows/desktop/api/errhandlingapi/nf-errhandlingapi-getlasterror">GetLastError</a>.</para>
      /// </returns>
      public class function DrawIconEx(hdc: HDC; xLeft, yTop: Integer; hIcon: HICON; cxWidth, cyWidth: Integer; istepIfAniCur: UInt32; hbrFlickerFreeDraw: HBRUSH; diFlags: DI_FLAGS = DI_FLAGS.DI_NORMAL): Boolean; overload; static;

      /// <summary>Desenha um ícone ou cursor no contexto de dispositivo especificado, realizando as operações raster especificadas, e esticando ou comprimindo o ícone ou cursor conforme especificado.</summary>
      /// <param name="hdc">
      /// <para>Tipo: <b>HDC</b> Um handle para o contexto de dispositivo no qual o ícone ou cursor será desenhado.</para>
      /// <para><see href="https://learn.microsoft.com/windows/win32/api/winuser/nf-winuser-drawiconex#parameters">Leia mais em docs.microsoft.com</see>.</para>
      /// </param>
      /// <param name="xLeft">
      /// <para>Tipo: <b>int</b> A coordenada lógica x do canto superior esquerdo do ícone ou cursor.</para>
      /// <para><see href="https://learn.microsoft.com/windows/win32/api/winuser/nf-winuser-drawiconex#parameters">Leia mais em docs.microsoft.com</see>.</para>
      /// </param>
      /// <param name="yTop">
      /// <para>Tipo: <b>int</b> A coordenada lógica y do canto superior esquerdo do ícone ou cursor.</para>
      /// <para><see href="https://learn.microsoft.com/windows/win32/api/winuser/nf-winuser-drawiconex#parameters">Leia mais em docs.microsoft.com</see>.</para>
      /// </param>
      /// <param name="hIcon">
      /// <para>Tipo: <b>HICON</b> Um handle para o ícone ou cursor a ser desenhado. Este parâmetro pode identificar um cursor animado.</para>
      /// <para><see href="https://learn.microsoft.com/windows/win32/api/winuser/nf-winuser-drawiconex#parameters">Leia mais em docs.microsoft.com</see>.</para>
      /// </param>
      /// <param name="cxWidth">
      /// <para>Tipo: <b>int</b> A largura lógica do ícone ou cursor. Se este parâmetro for zero e o parâmetro <i>diFlags</i> for <b>DI_DEFAULTSIZE</b>, a função usa o valor da métrica do sistema <b>SM_CXICON</b> para definir a largura. Se este parâmetro for zero e <b>DI_DEFAULTSIZE</b> não for usado, a função usa a largura real do recurso.</para>
      /// <para><see href="https://learn.microsoft.com/windows/win32/api/winuser/nf-winuser-drawiconex#parameters">Leia mais em docs.microsoft.com</see>.</para>
      /// </param>
      /// <param name="cyWidth">
      /// <para>Tipo: <b>int</b> A altura lógica do ícone ou cursor. Se este parâmetro for zero e o parâmetro <i>diFlags</i> for <b>DI_DEFAULTSIZE</b>, a função usa o valor da métrica do sistema <b>SM_CYICON</b> para definir a largura. Se este parâmetro for zero e <b>DI_DEFAULTSIZE</b> não for usado, a função usa a altura real do recurso.</para>
      /// <para><see href="https://learn.microsoft.com/windows/win32/api/winuser/nf-winuser-drawiconex#parameters">Leia mais em docs.microsoft.com</see>.</para>
      /// </param>
      /// <param name="diFlags">Tipo: <b>UINT</b></param>
      /// <returns>
      /// <para>Tipo: <b>BOOL</b> Se a função for bem-sucedida, o valor de retorno é diferente de zero. Se a função falhar, o valor de retorno é zero. Para obter informações de erro estendidas, chame <a href="https://docs.microsoft.com/windows/desktop/api/errhandlingapi/nf-errhandlingapi-getlasterror">GetLastError</a>.</para>
      /// </returns>
      /// <remarks>
      /// <para>A função <b>DrawIconEx</b> coloca o canto superior esquerdo do ícone na localização especificada pelos parâmetros <i>xLeft</i> e <i>yTop</i>.
      /// A localização está sujeita ao modo de mapeamento atual do contexto de dispositivo. Se apenas um dos flags <b>DI_IMAGE</b> e <b>DI_MASK</b> estiver definido, então o bitmap correspondente é desenhado com o código de operação raster <b>SRCCOPY</b> <a href="https://docs.microsoft.com/windows/win32/api/wingdi/nf-wingdi-bitblt">. Se ambos os flags <b>DI_IMAGE</b> e <b>DI_MASK</b> estiverem definidos:
      /// * Se o ícone ou cursor for um ícone ou cursor de 32 bits com mesclagem alfa, então a imagem é desenhada com a função de mesclagem <b>AC_SRC_OVER</b> <a href="https://docs.microsoft.com/windows/win32/api/wingdi/ns-wingdi-blendfunction"> e a máscara é ignorada. * Para todos os outros ícones ou cursores, a máscara é desenhada com o código de operação raster <b>SRCAND</b> <a href="https://docs.microsoft.com/windows/win32/api/wingdi/nf-wingdi-bitblt">, e a imagem é desenhada com o código de operação raster <b>SRCINVERT</b> <a href="https://docs.microsoft.com/windows/win32/api/wingdi/nf-wingdi-bitblt">. Para duplicar <c>DrawIcon (hDC, X, Y, hIcon)</c>, chame <b>DrawIconEx</b> da seguinte forma:</para>
      /// <para>Este documento foi truncado.</para>
      /// <para><see href="https://learn.microsoft.com/windows/win32/api/winuser/nf-winuser-drawiconex#">Leia mais em docs.microsoft.com</see>.</para>
      /// </remarks>
      public class function DrawIconEx(hdc: HDC; xLeft, yTop: Integer; hIcon: HICON; cxWidth, cyWidth: Integer; diFlags: DI_FLAGS = DI_FLAGS.DI_NORMAL): Boolean; overload; static;

      /// <summary>A função SelectClipRgn seleciona uma região como a região de recorte atual para o contexto de dispositivo especificado.</summary>
      /// <param name="hdc">Um handle para o contexto de dispositivo.</param>
      /// <param name="hrgn">Um handle para a região a ser selecionada.</param>
      /// <returns>
      /// <para>O valor de retorno especifica a complexidade da região e pode ser um dos seguintes valores. </para>
      /// <para>Este documento foi truncado.</para>
      /// </returns>
      /// <remarks>
      /// <para>Apenas uma cópia da região selecionada é usada. A própria região pode ser selecionada para qualquer número de outros contextos de dispositivo ou pode ser deletada. A função <b>SelectClipRgn</b> assume que as coordenadas para uma região são especificadas em unidades do dispositivo. Para remover a região de recorte de um contexto de dispositivo, especifique um handle de região <b>NULL</b>.</para>
      /// <para><see href="https://learn.microsoft.com/windows/win32/api/wingdi/nf-wingdi-selectcliprgn#">Leia mais em docs.microsoft.com</see>.</para>
      /// </remarks>
      public class function SelectClipRgn(hdc: HDC; hrgn: HRGN): GDI_REGION_TYPE; static;

      /// <summary>A função DeleteObject exclui uma caneta, pincel, fonte, bitmap, região ou paleta lógica, liberando todos os recursos do sistema associados ao objeto. Após o objeto ser excluído, o handle especificado não é mais válido.</summary>
      /// <param name="ho">Um handle para uma caneta, pincel, fonte, bitmap, região ou paleta lógica.</param>
      /// <returns>
      /// <para>Se a função for bem-sucedida, o valor de retorno é diferente de zero. Se o handle especificado não for válido ou estiver atualmente selecionado em um DC, o valor de retorno é zero.</para>
      /// </returns>
      /// <remarks>
      /// <para>Não exclua um objeto de desenho (caneta ou pincel) enquanto ele ainda estiver selecionado em um DC. Quando um pincel de padrão é excluído, o bitmap associado ao pincel não é excluído. O bitmap deve ser excluído independentemente.</para>
      /// <para><see href="https://learn.microsoft.com/windows/win32/api/wingdi/nf-wingdi-deleteobject#">Leia mais em docs.microsoft.com</see>.</para>
      /// </remarks>
      public class function DeleteObject(ho: HGDIOBJ): BOOL; static;

      public class procedure RestoreClipRgn(hdc: HDC; hRgn: HRGN); static;

      /// <summary>A função SaveDC salva o estado atual do contexto de dispositivo (DC) especificado, copiando dados que descrevem objetos selecionados e modos gráficos (como o bitmap, pincel, paleta, fonte, caneta, região, modo de desenho e modo de mapeamento) para uma pilha de contexto.</summary>
      /// <param name="hdc">Um handle para o DC cujo estado será salvo.</param>
      /// <returns>
      /// <para>Se a função for bem-sucedida, o valor de retorno identifica o estado salvo. Se a função falhar, o valor de retorno é zero.</para>
      /// </returns>
      /// <remarks>
      /// <para>A função <b>SaveDC</b> pode ser usada várias vezes para salvar qualquer número de instâncias do estado do DC. Um estado salvo pode ser restaurado usando a função <a href="https://docs.microsoft.com/windows/desktop/api/wingdi/nf-wingdi-restoredc">RestoreDC</a>.</para>
      /// <para><see href="https://learn.microsoft.com/windows/win32/api/wingdi/nf-wingdi-savedc#">Leia mais em docs.microsoft.com</see>.</para>
      /// </remarks>
      public class function SaveDC(const hdc: HDC): Int32; static;

      /// <summary>A função RestoreDC restaura um contexto de dispositivo (DC) para o estado especificado. O DC é restaurado desempilhando informações de estado de uma pilha criada por chamadas anteriores à função SaveDC.</summary>
      /// <param name="hdc">Um handle para o DC.</param>
      /// <param name="nSavedDC">O estado salvo a ser restaurado. Se este parâmetro for positivo, <i>nSavedDC</i> representa uma instância específica do estado a ser restaurado. Se este parâmetro for negativo, <i>nSavedDC</i> representa uma instância relativa ao estado atual. Por exemplo, -1 restaura o estado mais recentemente salvo.</param>
      /// <returns>
      /// <para>Se a função for bem-sucedida, o valor de retorno é diferente de zero. Se a função falhar, o valor de retorno é zero.</para>
      /// </returns>
      /// <remarks>Cada DC mantém uma pilha de estados salvos. A função <a href="https://docs.microsoft.com/windows/desktop/api/wingdi/nf-wingdi-savedc">SaveDC</a> empurra o estado atual do DC para sua pilha de estados salvos. Esse estado só pode ser restaurado para o mesmo DC do qual foi criado. Depois que um estado é restaurado, o estado salvo é destruído e não pode ser reutilizado. Além disso, quaisquer estados salvos após o estado restaurado ter sido criado também são destruídos e não podem ser usados. Em outras palavras, a função <b>RestoreDC</b> desempilha o estado restaurado (e quaisquer estados subsequentes) da pilha de informações de estado.</remarks>
      public class function RestoreDC(const hdc: HDC; const nSavedDC: Integer): Boolean; static;

      /// <summary>O GetObjectType recupera o tipo do objeto especificado.</summary>
      /// <param name="h">Um handle para o objeto gráfico.</param>
      /// <returns>
      /// <para>Se a função for bem-sucedida, o valor de retorno identifica o objeto. Este valor pode ser um dos seguintes. </para>
      /// <para>Este doc foi truncado.</para>
      /// </returns>
      public class function GetObjectType(const h: HGDIOBJ): OBJ_TYPE; static;

		/// <summary>Recupera a métrica do sistema especificada ou a configuração do sistema.</summary>
		/// <param name="nIndex">
      /// <para>Tipo: <b>SYSTEM_METRICS_INDEX</b></para>
      /// </param>
		/// <returns>
		/// <para>Tipo: <b>Integer</b> Se a função for bem-sucedida, o valor de retorno é a métrica do sistema ou a configuração solicitada. Se a função falhar, o valor de retorno é 0. <a href="https://docs.microsoft.com/windows/desktop/api/errhandlingapi/nf-errhandlingapi-getlasterror">GetLastError</a> não fornece informações de erro estendidas.</para>
		/// </returns>
      public class function GetSystemMetrics(const nIndex: SYSTEM_METRICS_INDEX): Integer; static;

      /// <summary>A função GetDC recupera um identificador para um contexto de dispositivo (DC) para a área do cliente de uma janela especificada ou para a tela inteira.</summary>
      /// <param name="hWnd">Um identificador para a janela cujo DC deve ser recuperado. Se esse valor for <b>NULL</b>, <b>GetDC</b> recupera o DC para a tela inteira.</param>
      /// <returns>
      /// <para>Se a função for bem-sucedida, o valor de retorno é um identificador para o DC da área do cliente da janela especificada. Se a função falhar, o valor de retorno é <b>NULL</b>.</para>
      /// </returns>
      /// <remarks>
      /// <para>A função <b>GetDC</b> recupera um DC comum, de classe ou privado dependendo do estilo de classe da janela especificada.
      /// Para DCs de classe e privados, <b>GetDC</b> deixa os atributos previamente atribuídos inalterados.
      /// No entanto, para DCs comuns, <b>GetDC</b> atribui atributos padrão ao DC cada vez que ele é recuperado.
      /// Por exemplo, a fonte padrão é System, que é uma fonte bitmap. Por causa disso, o identificador para um DC comum retornado por <b>GetDC</b> não informa qual fonte, cor ou pincel foi usado quando a janela foi desenhada.
      /// Para determinar a fonte, chame <a href="https://docs.microsoft.com/windows/desktop/api/wingdi/nf-wingdi-gettextfacea">GetTextFace</a>.
      /// Observe que o identificador para o DC só pode ser usado por um único thread de cada vez.
      /// Após pintar com um DC comum, a função <a href="https://docs.microsoft.com/windows/desktop/api/winuser/nf-winuser-releasedc">ReleaseDC</a> deve ser chamada para liberar o DC. DCs de classe e privados não precisam ser liberados.
      /// <b>ReleaseDC</b> deve ser chamado pelo mesmo thread que chamou <b>GetDC</b>. O número de DCs é limitado apenas pela memória disponível.
      /// </para>
      /// <para><see href="https://learn.microsoft.com/windows/win32/api/winuser/nf-winuser-getdc#">Leia mais em docs.microsoft.com</see>.</para>
      /// </remarks>
      public class function GetDC(hWnd: THandle): HDC; static;

		/// <summary>
      ///   A função GetDCEx recupera um identificador para um contexto de dispositivo (DC) para a área do cliente de uma janela especificada ou para a tela inteira.
      /// </summary>
		/// <param name="hWnd">Um identificador para a janela cujo DC deve ser recuperado. Se esse valor for <b>NULL</b>, <b>GetDCEx</b> recupera o DC para a tela inteira.</param>
		/// <param name="hrgnClip">Uma região de recorte que pode ser combinada com a região visível do DC. Se o valor de <i>flags</i> for DCX_INTERSECTRGN ou DCX_EXCLUDERGN, então o sistema operacional assume a propriedade da região e a deletará automaticamente quando não for mais necessária. Neste caso, a aplicação não deve usar ou deletar a região após uma chamada bem-sucedida a <b>GetDCEx</b>.</param>
		/// <param name="flags"></param>
		/// <returns>
		/// <para>Se a função for bem-sucedida, o valor de retorno é o identificador para o DC da janela especificada. Se a função falhar, o valor de retorno é <b>NULL</b>. Um valor inválido para o parâmetro <i>hWnd</i> fará com que a função falhe.</para>
		/// </returns>
		/// <remarks>
		/// <para>A menos que o DC de exibição pertença a uma classe de janela, a função <a href="https://docs.microsoft.com/windows/desktop/api/winuser/nf-winuser-releasedc">ReleaseDC</a> deve ser chamada para liberar o DC após a pintura. Além disso, <b>ReleaseDC</b> deve ser chamada pelo mesmo thread que chamou <b>GetDCEx</b>. O número de DCs é limitado apenas pela memória disponível. A função retorna um identificador para um DC que pertence à classe da janela se CS_CLASSDC, CS_OWNDC ou CS_PARENTDC foram especificados como um estilo na estrutura <a href="https://docs.microsoft.com/windows/desktop/api/winuser/ns-winuser-wndclassa">WNDCLASS</a> quando a classe foi registrada.</para>
		/// <para><see href="https://learn.microsoft.com/windows/win32/api/winuser/nf-winuser-getdcex#">Leia mais em docs.microsoft.com</see>.</para>
		/// </remarks>
      public class function GetDCEx(hWnd: THandle; hrgnClip: HRGN; flags: GET_DCX_FLAGS): HDC; static;

		/// <summary>
      ///   A função ReleaseDC libera um contexto de dispositivo (DC), liberando-o para uso por outras aplicações.
      ///   O efeito da função ReleaseDC depende do tipo de DC. Ela libera apenas DCs comuns e de janela.
      ///   Não tem efeito sobre DCs de classe ou privados.
      /// </summary>
		/// <param name="hWnd">Um identificador para a janela cujo DC deve ser liberado.</param>
		/// <param name="hDC">Um identificador para o DC a ser liberado.</param>
		/// <returns>
		/// <para>O valor de retorno indica se o DC foi liberado. Se o DC foi liberado, o valor de retorno é 1. Se o DC não foi liberado, o valor de retorno é zero.</para>
		/// </returns>
		/// <remarks>
		/// <para>A aplicação deve chamar a função <b>ReleaseDC</b> para cada chamada à função <a href="https://docs.microsoft.com/windows/desktop/api/winuser/nf-winuser-getwindowdc">GetWindowDC</a> e para cada chamada à função <a href="https://docs.microsoft.com/windows/desktop/api/winuser/nf-winuser-getdc">GetDC</a> que recupera um DC comum. Uma aplicação não pode usar a função <b>ReleaseDC</b> para liberar um DC que foi criado chamando a função <a href="https://docs.microsoft.com/windows/desktop/api/wingdi/nf-wingdi-createdca">CreateDC</a>; em vez disso, ela deve usar a função <a href="https://docs.microsoft.com/windows/desktop/api/wingdi/nf-wingdi-deletedc">DeleteDC</a>. <b>ReleaseDC</b> deve ser chamada pelo mesmo thread que chamou <a href="https://docs.microsoft.com/windows/desktop/api/winuser/nf-winuser-getdc">GetDC</a>.</para>
		/// <para><see href="https://learn.microsoft.com/windows/win32/api/winuser/nf-winuser-releasedc#">Leia mais em docs.microsoft.com</see>.</para>
		/// </remarks>
		public class function ReleaseDC(hWnd: THandle; hDC: HDC): Integer; static;

		/// <summary>The GetDeviceCaps function retrieves device-specific information for the specified device.</summary>
		/// <param name="hdc">A handle to the DC.</param>
		/// <param name="index"></param>
		/// <returns>
		/// <para>The return value specifies the value of the desired item. When <i>nIndex</i> is BITSPIXEL and the device has 15bpp or 16bpp, the return value is 16.</para>
		/// </returns>
		/// <remarks>
		/// <para>When <i>nIndex</i> is SHADEBLENDCAPS: </para>
		/// <para>This doc was truncated.</para>
		/// <para><see href="https://learn.microsoft.com/windows/win32/api/wingdi/nf-wingdi-getdevicecaps#">Read more on docs.microsoft.com</see>.</para>
		/// </remarks>
		public class function GetDeviceCaps(hdc: HDC; index: GET_DEVICE_CAPS_INDEX): Integer; static;

		/// <summary>Recupera informações sobre o ícone ou cursor especificado.</summary>
		/// <param name="hIcon"><para>Tipo: <b>HICON</b></para></param>
		/// <param name="piconinfo">
		/// <para>Tipo: <b>PICONINFO</b> Um ponteiro para uma estrutura <a href="https://docs.microsoft.com/windows/desktop/api/winuser/ns-winuser-iconinfo">ICONINFO</a>. A função preenche os membros da estrutura.</para>
		/// </param>
		/// <returns>
		/// <para>Tipo: <b>BOOL</b> Se a função for bem-sucedida, o valor de retorno é diferente de zero e a função preenche os membros da estrutura <a href="https://docs.microsoft.com/windows/desktop/api/winuser/ns-winuser-iconinfo">ICONINFO</a> especificada. Se a função falhar, o valor de retorno é zero. Para obter informações de erro estendidas, chame <a href="https://docs.microsoft.com/windows/desktop/api/errhandlingapi/nf-errhandlingapi-getlasterror">GetLastError</a>.</para>
		/// </returns>
		/// <remarks>
		/// <para><b>GetIconInfo</b> cria bitmaps para os membros <b>hbmMask</b> e <b>hbmColor</b> de <a href="https://docs.microsoft.com/windows/desktop/api/winuser/ns-winuser-iconinfo">ICONINFO</a>. O aplicativo que chama deve gerenciar esses bitmaps e deletá-los quando não forem mais necessários. <h3><a id="DPI_Virtualization"></a><a id="dpi_virtualization"></a><a id="DPI_VIRTUALIZATION"></a>Virtualização DPI</h3> Esta API não participa da virtualização DPI. O resultado retornado não é afetado pelo DPI do thread que chama.</para>
		/// </remarks>
		public class function GetIconInfo(hIcon: HICON; out piconinfo: ICONINFO): Boolean; static;

		/// <summary>A função GetObjectW (Unicode) (wingdi.h) recupera informações para o objeto gráfico especificado.</summary>
		/// <returns>
		/// <para>Se a função for bem-sucedida, e <i>lpvObject</i> for um ponteiro válido, o valor de retorno é o número de bytes armazenados no buffer. Se a função for bem-sucedida, e <i>lpvObject</i> for <b>NULL</b>, o valor de retorno é o número de bytes necessários para conter as informações que a função armazenaria no buffer. Se a função falhar, o valor de retorno é zero.</para>
		/// </returns>
		/// <remarks>
		/// <para>
      /// O buffer apontado pelo parâmetro <i>lpvObject</i> deve ser suficientemente grande para receber as informações sobre o objeto gráfico.
      /// Dependendo do objeto gráfico, a função utiliza uma estrutura <a href="https://docs.microsoft.com/windows/desktop/api/wingdi/ns-wingdi-bitmap">BITMAP</a>,
      /// <a href="https://docs.microsoft.com/windows/desktop/api/wingdi/ns-wingdi-dibsection">DIBSECTION</a>,
      /// <a href="https://docs.microsoft.com/windows/desktop/api/wingdi/ns-wingdi-extlogpen">EXTLOGPEN</a>,
      /// <a href="https://docs.microsoft.com/windows/desktop/api/wingdi/ns-wingdi-logbrush">LOGBRUSH</a>,
      /// <a href="https://docs.microsoft.com/windows/desktop/api/wingdi/ns-wingdi-logfonta">LOGFONT</a>, ou estrutura <a href="https://docs.microsoft.com/windows/desktop/api/wingdi/ns-wingdi-logpen">LOGPEN</a>,
      /// ou uma contagem de entradas de tabela (para uma paleta lógica).
      /// Se <i>hgdiobj</i> for um identificador para um bitmap criado chamando <a href="https://docs.microsoft.com/windows/desktop/api/wingdi/nf-wingdi-createdibsection">CreateDIBSection</a>, e o buffer especificado for grande o suficiente, a função <b>GetObject</b> retorna uma estrutura <a href="https://docs.microsoft.com/windows/desktop/api/wingdi/ns-wingdi-dibsection">DIBSECTION</a>.
      /// Além disso, o membro <b>bmBits</b> da estrutura <a href="https://docs.microsoft.com/windows/desktop/api/wingdi/ns-wingdi-bitmap">BITMAP</a> contida dentro da <b>DIBSECTION</b> conterá um ponteiro para os valores dos bits do bitmap.
      /// Se <i>hgdiobj</i> for um identificador para um bitmap criado por quaisquer outros meios, <b>GetObject</b> retorna apenas as informações de largura, altura e formato de cor do bitmap.
      /// Você pode obter os valores dos bits do bitmap chamando a função <a href="https://docs.microsoft.com/windows/desktop/api/wingdi/nf-wingdi-getdibits">GetDIBits</a> ou <a href="https://docs.microsoft.com/windows/desktop/api/wingdi/nf-wingdi-getbitmapbits">GetBitmapBits</a>.
      /// Se <i>hgdiobj</i> for um identificador para uma paleta lógica, <b>GetObject</b> recupera um inteiro de 2 bytes que especifica o número de entradas na paleta.
      /// A função não recupera a estrutura <a href="https://docs.microsoft.com/windows/desktop/api/wingdi/ns-wingdi-logpalette">LOGPALETTE</a> que define a paleta.
      /// Para recuperar informações sobre as entradas da paleta, uma aplicação pode chamar a função <a href="https://docs.microsoft.com/windows/desktop/api/wingdi/nf-wingdi-getpaletteentries">GetPaletteEntries</a>.
      /// Se <i>hgdiobj</i> for um identificador para uma fonte, o <a href="https://docs.microsoft.com/windows/desktop/api/wingdi/ns-wingdi-logfonta">LOGFONT</a> que é retornado é o <b>LOGFONT</b> usado para criar a fonte.
      /// Se o Windows teve que fazer alguma interpolação da fonte porque o <b>LOGFONT</b> preciso não poderia ser representado, a interpolação não será refletida no <b>LOGFONT</b>.
      /// Por exemplo, se você pedir uma versão vertical de uma fonte que não suporta pintura vertical, o <b>LOGFONT</b> indica que a fonte é vertical, mas o Windows a pintará horizontalmente.
		/// </para>
		/// <para><see href="https://learn.microsoft.com/windows/win32/api/wingdi/nf-wingdi-getobjectw#">Read more on docs.microsoft.com</see>.</para>
		public class function GetObject(h: HGDIOBJ; c: Integer; pv: Pointer): Integer; static;

		/// <summary>Fornece um manipulador padrão para extrair um ícone de um arquivo. (Unicode)</summary>
		/// <param name="pszIconFile">
		/// <para>Tipo: <b>LPCTSTR</b> Um ponteiro para um buffer terminado em nulo que contém o caminho e o nome do arquivo do qual o ícone é extraído.</para>
		/// <para><see href="https://learn.microsoft.com/windows/win32/api/shlobj_core/nf-shlobj_core-shdefextracticonw#parameters">Leia mais em docs.microsoft.com</see>.</para>
		/// </param>
		/// <param name="iIndex">
		/// <para>Tipo: <b>int</b> A localização do ícone dentro do arquivo nomeado em <i>pszIconFile</i>. Se for um número positivo, refere-se à posição baseada em zero do ícone no arquivo. Por exemplo, 0 refere-se ao 1º ícone no arquivo de recurso e 2 refere-se ao 3º. Se for um número negativo, refere-se ao ID de recurso do ícone.</para>
		/// <para><see href="https://learn.microsoft.com/windows/win32/api/shlobj_core/nf-shlobj_core-shdefextracticonw#parameters">Leia mais em docs.microsoft.com</see>.</para>
		/// </param>
		/// <param name="uFlags">
		/// <para>Tipo: <b>UINT</b> Uma bandeira que controla a extração do ícone.</para>
		/// <para><see href="https://learn.microsoft.com/windows/win32/api/shlobj_core/nf-shlobj_core-shdefextracticonw#parameters">Leia mais em docs.microsoft.com</see>.</para>
		/// </param>
		/// <param name="phiconLarge">
		/// <para>Tipo: <b>HICON*</b> Um ponteiro para um HICON que, quando esta função retorna com sucesso, recebe o identificador da versão grande do ícone especificado no <a href="https://docs.microsoft.com/previous-versions/windows/desktop/legacy/ms632659(v=vs.85)">LOWORD</a> de <i>nIconSize</i>. Este valor pode ser <b>NULL</b>.</para>
		/// <para><see href="https://learn.microsoft.com/windows/win32/api/shlobj_core/nf-shlobj_core-shdefextracticonw#parameters">Leia mais em docs.microsoft.com</see>.</para>
		/// </param>
		/// <param name="phiconSmall">
		/// <para>Tipo: <b>HICON*</b> Um ponteiro para um HICON que, quando esta função retorna com sucesso, recebe o identificador da versão pequena do ícone especificado no <a href="https://docs.microsoft.com/previous-versions/windows/desktop/legacy/ms632657(v=vs.85)">HIWORD</a> de <i>nIconSize</i>.</para>
		/// <para><see href="https://learn.microsoft.com/windows/win32/api/shlobj_core/nf-shlobj_core-shdefextracticonw#parameters">Leia mais em docs.microsoft.com</see>.</para>
		/// </param>
		/// <param name="nIconSize">
		/// <para>Tipo: <b>UINT</b> Um valor que contém o tamanho do ícone grande em seu <a href="https://docs.microsoft.com/previous-versions/windows/desktop/legacy/ms632659(v=vs.85)">LOWORD</a> e o tamanho do ícone pequeno em seu <a href="https://docs.microsoft.com/previous-versions/windows/desktop/legacy/ms632657(v=vs.85)">HIWORD</a>. O tamanho é medido em pixels. Passe 0 para especificar tamanhos grandes e pequenos padrão.</para>
		/// <para><see href="https://learn.microsoft.com/windows/win32/api/shlobj_core/nf-shlobj_core-shdefextracticonw#parameters">Leia mais em docs.microsoft.com</see>.</para>
		/// </param>
		/// <returns>
		/// <para>Tipo: <b>HRESULT</b> Esta função pode retornar um destes valores. </para>
		/// <para>Este documento foi truncado.</para>
		/// </returns>
		/// <remarks>
		/// <para>É responsabilidade do chamador liberar os recursos do ícone criados através desta função quando eles não forem mais necessários. Isso pode ser feito por meio da função <a href="https://docs.microsoft.com/windows/desktop/api/winuser/nf-winuser-destroyicon">DestroyIcon</a>.</para>
		/// <para>> [!NOTA] > O cabeçalho shlobj_core.h define SHDefExtractIcon como um alias que automaticamente seleciona a versão ANSI ou Unicode desta função baseada na definição da constante de pré-processamento UNICODE. A mistura do uso do alias neutro em codificação com código que não é neutro em codificação pode levar a incompatibilidades que resultam em erros de compilação ou de execução. Para mais informações, veja [Convenções para Protótipos de Funções](/windows/win32/intl/conventions-for-function-prototypes).</para>
		/// <para><see href="https://learn.microsoft.com/windows/win32/api/shlobj_core/nf-shlobj_core-shdefextracticonw#">Read more on docs.microsoft.com</see>.</para>
		/// </remarks>
		public class function SHDefExtractIcon(const pszIconFile: string; iIndex: Integer; uFlags: UInt32; phiconLarge: HICON; phiconSmall: HICON; nIconSize: UInt32): HRESULT; static;

      /// <summary>
      /// A função BitBlt realiza uma transferência de bloco de bits dos dados de cor correspondentes a um retângulo de pixels do contexto de dispositivo de origem especificado para um contexto de dispositivo de destino.
      /// </summary>
      /// <param name="hdc">Um identificador para o contexto de dispositivo de destino.</param>
      /// <param name="x">A coordenada x, em unidades lógicas, do canto superior esquerdo do retângulo de destino.</param>
      /// <param name="y">A coordenada y, em unidades lógicas, do canto superior esquerdo do retângulo de destino.</param>
      /// <param name="cx">A largura, em unidades lógicas, dos retângulos de origem e destino.</param>
      /// <param name="cy">A altura, em unidades lógicas, dos retângulos de origem e de destino.</param>
      /// <param name="hdcSrc">Um identificador para o contexto de dispositivo de origem.</param>
      /// <param name="x1">A coordenada x, em unidades lógicas, do canto superior esquerdo do retângulo de origem.</param>
      /// <param name="y1">A coordenada y, em unidades lógicas, do canto superior esquerdo do retângulo de origem.</param>
      /// <param name="rop">
      /// <para>Um código de operação raster. Estes códigos definem como os dados de cor para o retângulo de origem devem ser combinados com os dados de cor para o retângulo de destino para alcançar a cor final. A seguinte lista mostra alguns códigos comuns de operação raster.</para>
      /// <para>Este doc foi truncado.</para>
      /// <para><see href="https://learn.microsoft.com/windows/win32/api/wingdi/nf-wingdi-bitblt#parameters">Leia mais em docs.microsoft.com</see>.</para>
      /// </param>
      /// <returns>
      /// <para>Se a função for bem-sucedida, o valor de retorno é diferente de zero. Se a função falhar, o valor de retorno é zero. Para obter informações de erro estendidas, chame <a href="https://docs.microsoft.com/windows/desktop/api/errhandlingapi/nf-errhandlingapi-getlasterror">GetLastError</a>.</para>
      /// </returns>
      /// <remarks>
      /// <para>
      ///   <b>BitBlt</b> realiza clipping apenas no DC de destino. Se uma transformação de rotação ou cisalhamento estiver em efeito no contexto de dispositivo de origem, <b>BitBlt</b> retorna um erro.
      ///   Se outras transformações existirem no contexto de dispositivo de origem (e uma transformação correspondente não estiver em efeito no contexto de dispositivo de destino), o retângulo no contexto de dispositivo de destino é esticado, comprimido ou rotacionado, conforme necessário.
      ///   Se os formatos de cor dos contextos de dispositivo de origem e destino não coincidirem, a função <b>BitBlt</b> converte o formato de cor de origem para corresponder ao formato de destino.
      ///   Quando um meta-arquivo aprimorado está sendo gravado, ocorre um erro se o contexto de dispositivo de origem identificar um contexto de dispositivo de meta-arquivo aprimorado.
      ///   Nem todos os dispositivos suportam a função <b>BitBlt</b>.
      ///   Para mais informações, veja a entrada de capacidade raster RC_BITBLT na função <a href="https://docs.microsoft.com/windows/desktop/api/wingdi/nf-wingdi-getdevicecaps">GetDeviceCaps</a> assim como as seguintes funções: <a href="https://docs.microsoft.com/windows/desktop/api/wingdi/nf-wingdi-maskblt">MaskBlt</a>, <a href="https://docs.microsoft.com/windows/desktop/api/wingdi/nf-wingdi-plgblt">PlgBlt</a>, e <a href="https://docs.microsoft.com/windows/desktop/api/wingdi/nf-wingdi-stretchblt">StretchBlt</a>. <b>BitBlt</b> retorna um erro se os contextos de dispositivo de origem e destino representarem dispositivos diferentes.
      ///   Para transferir dados entre DCs para diferentes dispositivos, converta o bitmap de memória para um DIB chamando <a href="https://docs.microsoft.com/windows/desktop/api/wingdi/nf-wingdi-getdibits">GetDIBits</a>.
      ///   Para exibir o DIB no segundo dispositivo, chame <a href="https://docs.microsoft.com/windows/desktop/api/wingdi/nf-wingdi-setdibits">SetDIBits</a> ou <a href="https://docs.microsoft.com/windows/desktop/api/wingdi/nf-wingdi-stretchdibits">StretchDIBits</a>.
      ///   <b>ICM:</b> Nenhum gerenciamento de cor é realizado quando ocorrem blits.
      /// </para>
      /// </remarks>
		public class function BitBlt(const hdc: HDC; const x, y, cx, cy: Integer; const hdcSrc: HDC; const x1, y1: Integer; const rop: ROP_CODE): Boolean; static;

      /// <summary>A função CombineRgn combina duas regiões e armazena o resultado em uma terceira região. As duas regiões são combinadas de acordo com o modo especificado.</summary>
      /// <param name="hrgnDst">Um identificador para uma nova região com dimensões definidas pela combinação de outras duas regiões. (Essa região deve existir antes de chamar o método <b>CombineRgn</b>.)</param>
      /// <param name="hrgnSrc1">Um identificador para a primeira das duas regiões a serem combinadas.</param>
      /// <param name="hrgnSrc2">Um identificador para a segunda das duas regiões a serem combinadas.</param>
      /// <param name="iMode"></param>
      /// <returns>
      /// <para>O valor de retorno especifica o tipo da região resultante. Pode ser um dos seguintes valores. </para>
      /// <para>Esta documentação foi truncada.</para>
      /// </returns>
      /// <remarks>As três regiões não precisam ser distintas. Por exemplo, o parâmetro <i>hrgnSrc1</i> pode ser igual ao parâmetro <i>hrgnDest</i>.</remarks>
		public class function CombineRgn(const hrgnDst: HRGN; const hrgnSrc1: HRGN; const hrgnSrc2: HRGN; const iMode: RGN_COMBINE_MODE): GDI_REGION_TYPE; static;

      /// <summary>A função OffsetViewportOrgEx modifica a origem da janela de visualização para um contexto de dispositivo usando os deslocamentos horizontais e verticais especificados.</summary>
      /// <param name="hdc">Um identificador para o contexto de dispositivo.</param>
      /// <param name="x">O deslocamento horizontal, em unidades de dispositivo.</param>
      /// <param name="y">O deslocamento vertical, em unidades de dispositivo.</param>
      /// <param name="lppt">Um ponteiro para uma estrutura <a href="https://docs.microsoft.com/windows/win32/api/windef/ns-windef-point">POINT</a>. A origem da janela de visualização anterior, em unidades de dispositivo, é colocada nesta estrutura. Se <i>lpPoint</i> for <b>NULL</b>, a origem da janela de visualização anterior não é retornada.</param>
      /// <returns>
      /// <para>Se a função tiver êxito, o valor de retorno é diferente de zero. Se a função falhar, o valor de retorno é zero.</para>
      /// </returns>
      /// <remarks>A nova origem é a soma da origem atual e os deslocamentos horizontal e vertical.</remarks>
		public class function OffsetViewportOrgEx(const hdc: HDC; x, y: Integer; lppt: PPoint): Boolean; static;
   end;


implementation

uses
   TypInfo;

{ OBJ_TYPE_HELPER }

function OBJ_TYPE_HELPER.ToString(): string;
begin
   Result := TypInfo.GetEnumName(TypeInfo(OBJ_TYPE), Ord(Self));
end;


{ PInvokeCore }

class function PInvokeCore.Win32Check(RetVal: NativeInt): NativeInt;
begin
   PInvokeCore.Win32Check(RetVal <> 0);
   Result := RetVal;
end;

class function PInvokeCore.Win32Check(RetVal: NativeUInt): NativeUInt;
begin
   PInvokeCore.Win32Check(RetVal <> 0);
   Result := RetVal;
end;

class function PInvokeCore.Win32Check(RetVal: Boolean): Boolean;
begin
  Result := SysUtils.Win32Check(RetVal);
end;

class function PInvokeCore.CopyIcon(hImage: HICON; cx, cy: Integer; flags: IMAGE_FLAGS): HICON;
begin
   Result := CopyImage(hImage, GDI_IMAGE_TYPE.IMAGE_ICON, cx, cy, flags);
   Win32Check(Result);
end;

class function PInvokeCore.CopyImage(h: THandle; type_: GDI_IMAGE_TYPE; cx, cy: Integer; flags: IMAGE_FLAGS): THandle;
begin
   Result := Windows.CopyImage(h, type_, cx, cy, flags);
   Win32Check(Result);
end;

class function PInvokeCore.ExtractAssociatedIcon(AInstance: HINST; AIconPath: string; AIconIndex: Int32): HICON;
var
   Path: LPWSTR;
   Index: UInt16;
begin
   Path := PWideChar(WideString(AIconPath));
   Index := UInt16(AIconIndex);
{$IFDEF FPC}
   Result := ShellAPI.ExtractAssociatedIcon(AInstance, Path, @Index);
{$ELSE}
   Result := ShellAPI.ExtractAssociatedIcon(AInstance, Path, Index);
{$ENDIF}

   Win32Check(Result);
end;

class function PInvokeCore.DestroyIcon(hIcon: HICON): Boolean;
begin
   Result := Windows.DestroyIcon(hIcon) = True;
   Win32Check(Result);
end;

class function PInvokeCore.CreateRectRgn(x1, y1, x2, y2: Integer): HRGN;
begin
   Result := Windows.CreateRectRgn(x1, y1, x2, y2);
   Win32Check(Result);
end;

class function PInvokeCore.GetClipRgn(hdc: HDC; hrgn: HRGN): Integer;
begin
   Result := Windows.GetClipRgn(hdc, hrgn);
   Win32Check(Result);
end;

class function PInvokeCore.SaveClipRgn(hDC: HDC): HRGN;
begin
   var hTempRgn: HRGN := PInvokeCore.CreateRectRgn(0, 0, 0, 0);
   var hSaveRgn: HRGN := 0;
   try
       var ret: Integer := PInvokeCore.GetClipRgn(hDC, hTempRgn);
       if (ret > 0) then
       begin
           hSaveRgn := hTempRgn;
           hTempRgn := 0;
       end;
   finally
      if (hTempRgn <> 0) then
         DeleteObject(hTempRgn);
   end;

   Result := hSaveRgn;
   Win32Check(Result);
end;

class function PInvokeCore.IntersectClipRect(hdc: HDC; left, top, right, bottom: Integer): GDI_REGION_TYPE;
begin
   Result := GDI_REGION_TYPE(Windows.IntersectClipRect(hdc, left, top, right, bottom));
   Win32Check(Result <> GDI_REGION_TYPE.RGN_ERROR);
end;

class function PInvokeCore.DrawIconEx(hdc: HDC; xLeft, yTop: Integer; hIcon: HICON; cxWidth, cyWidth: Integer; istepIfAniCur: UInt32; hbrFlickerFreeDraw: HBRUSH; diFlags: DI_FLAGS = DI_FLAGS.DI_NORMAL): Boolean;
begin
   Result := Windows.DrawIconEx(hdc, xLeft, yTop, hIcon, cxWidth, cyWidth, istepIfAniCur, hbrFlickerFreeDraw, diFlags) = True;
   Win32Check(Result);
end;

class function PInvokeCore.DrawIconEx(hdc: HDC; xLeft, yTop: Integer; hIcon: HICON; cxWidth, cyWidth: Integer; diFlags: DI_FLAGS = DI_FLAGS.DI_NORMAL): Boolean;
begin
   Result := Windows.DrawIconEx(hdc, xLeft, yTop, hIcon, cxWidth, cyWidth, 0, 0, diFlags) = True;
   Win32Check(Result);
end;

class function PInvokeCore.SelectClipRgn(hdc: HDC; hrgn: HRGN): GDI_REGION_TYPE;
begin
   Result := GDI_REGION_TYPE(Windows.SelectClipRgn(hdc, hrgn));
   Win32Check(Result <> GDI_REGION_TYPE.RGN_ERROR);
end;

class function PInvokeCore.DeleteObject(ho: HGDIOBJ): BOOL;
begin
   Result := Windows.DeleteObject(ho);
   Win32Check(Result);
end;

class procedure PInvokeCore.RestoreClipRgn(hdc: HDC; hRgn: HRGN);
begin
   try
       PInvokeCore.SelectClipRgn(hDC, hRgn);
   finally
      if (hRgn <> 0) then
         PInvokeCore.DeleteObject(hRgn);
   end;
end;

class function PInvokeCore.SaveDC(const hdc: HDC): Int32;
begin
   Result := Win32Check(Windows.SaveDC(hdc));
end;

class function PInvokeCore.RestoreDC(const hdc: HDC; const nSavedDC: Integer): Boolean;
begin
   Result := Win32Check(Windows.RestoreDC(hdc, nSavedDC)) = True;
end;

class function PInvokeCore.GetObjectType(const h: HGDIOBJ): OBJ_TYPE;
begin
   Result := OBJ_TYPE(Win32Check(Windows.GetObjectType(h)));
end;

class function PInvokeCore.GetSystemMetrics(const nIndex: SYSTEM_METRICS_INDEX): Integer;
begin
   Result := Win32Check(Windows.GetSystemMetrics(Ord(nIndex)));
end;

class function PInvokeCore.GetDC(hWnd: THandle): HDC;
begin
   Result := Win32Check(Windows.GetDC(hWnd));
end;

class function PInvokeCore.GetDCEx(hWnd: THandle; hrgnClip: HRGN; flags: GET_DCX_FLAGS): HDC;
begin
   Result := Win32Check(Windows.GetDCEx(hWnd, hrgnClip, flags));
end;

class function PInvokeCore.ReleaseDC(hWnd: THandle; hDC: HDC): Integer;
begin
   Result := Win32Check(Windows.ReleaseDC(hWnd, hDC));
end;

class function PInvokeCore.GetDeviceCaps(hdc: HDC; index: GET_DEVICE_CAPS_INDEX): Integer;
begin
   Result := Win32Check(Windows.GetDeviceCaps(hDC, Ord(index)));
end;

class function PInvokeCore.GetIconInfo(hIcon: HICON; out piconinfo: ICONINFO): Boolean;
begin
   Result := Win32Check(Windows.GetIconInfo(hIcon, piconinfo) = True);
end;

class function PInvokeCore.GetObject(h: HGDIOBJ; c: Integer; pv: Pointer): Integer;
begin
   Result := Win32Check(Windows.GetObject(h, c, pv));
end;

class function PInvokeCore.SHDefExtractIcon(const pszIconFile: string; iIndex: Integer; uFlags: UInt32; phiconLarge: HICON; phiconSmall: HICON; nIconSize: UInt32): HRESULT;
begin
{$IFDEF FPC}
   Result := Win32Check(ShlObj.SHDefExtractIcon(PChar(pszIconFile), iIndex, uFlags, @phiconLarge, @phiconSmall, nIconSize));
{$ELSE}
   Result := Win32Check(ShlObj.SHDefExtractIcon(PChar(pszIconFile), iIndex, uFlags, phiconLarge, phiconSmall, nIconSize));
{$ENDIF}

end;

class function PInvokeCore.BitBlt(const hdc: HDC; const x, y, cx, cy: Integer; const hdcSrc: HDC; const x1, y1: Integer; const rop: ROP_CODE): Boolean;
begin
   Result := Win32Check(Windows.BitBlt(hdc, x, y, cx, cy, hdcSrc, x1, y1, rop) = True);
end;

class function PInvokeCore.CombineRgn(const hrgnDst: HRGN; const hrgnSrc1: HRGN; const hrgnSrc2: HRGN; const iMode: RGN_COMBINE_MODE): GDI_REGION_TYPE;
begin
   Result := GDI_REGION_TYPE(Windows.CombineRgn(hrgnDst, hrgnSrc1, hrgnSrc2, Ord(iMode)));
   Win32Check(Result <> GDI_REGION_TYPE.RGN_ERROR);
end;

class function PInvokeCore.OffsetViewportOrgEx(const hdc: HDC; x, y: Integer; lppt: PPoint): Boolean;
begin
   Result := Win32Check(Windows.OffsetViewportOrgEx(hdc, x, y, lppt) = True);
end;

end.
