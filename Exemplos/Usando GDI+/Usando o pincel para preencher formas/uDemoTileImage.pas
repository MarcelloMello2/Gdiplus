unit uDemoTileImage;

interface

uses
   Se7e.Drawing,
   Se7e.Drawing.Gdiplus.Types,
   uDemo;

type
  TDemoTileImage = class(TDemo)
  strict private
    procedure Tile;
    procedure FlipHorizontally;
    procedure FlipVertically;
    procedure FlipXY;
  strict protected
    procedure Run; override;
  end;

implementation

{$REGION}
/// Assim como os azulejos podem ser colocados um ao lado do outro para cobrir um piso, imagens retangulares
/// podem ser colocadas uma ao lado da outra para preencher (em mosaico) uma forma. Para preencher o
/// interior de uma forma com mosaico, use um pincel de textura. Quando você constrói um
/// objeto <A>TGdipTextureBrush</A>, um dos argumentos que você passa para o
/// construtor é um objeto <A>TGdipImage</A>. Quando você usa o pincel de textura para
/// pintar o interior de uma forma, a forma é preenchida com cópias repetidas dessa imagem.
///
/// A propriedade de modo de envolvimento do objeto <A>TGdipTextureBrush</A> determina como a
/// imagem é orientada à medida que é repetida em uma grade retangular. Você pode fazer com que todos
/// os ladrilhos na grade tenham a mesma orientação, ou você pode fazer a imagem
/// virar de uma posição na grade para a próxima. A virada pode ser horizontal,
/// vertical ou ambas. Os exemplos a seguir demonstram a aplicação de mosaico com diferentes
/// tipos de virada.
///
/// <H>Preenchendo com uma Imagem em Mosaico</H>
/// Este exemplo usa uma imagem de 75×75 para preencher um retângulo de 200×200:

procedure TDemoTileImage.Tile;
var
  Image: TGdipImage;
  Brush: TGdipTextureBrush;
  BlackPen: TGdipPen;
begin
  Image := TGdipImage.FromFile('..\..\imagens\HouseAndTree.gif');
  Brush := TGdipTextureBrush.Create(Image);
  BlackPen := TGdipPen.Create(TGdipColor.FromArgb(255, 0, 0, 0));

  Graphics.FillRectangle(Brush, TRectangle.Create(0, 0, 200, 200));
  Graphics.DrawRectangle(BlackPen, TRectangle.Create(0, 0, 200, 200));

  BlackPen.Free();
  Brush.Free();
  Image.Free();
end;

/// Imagem no canto superior esquerdo: observe que todos os ladrilhos têm a mesma orientação; não há
/// virada.
///
/// <H>Virando uma Imagem Horizontalmente Enquanto Preenche com Mosaico</H>
/// Este exemplo usa uma imagem de 75×75 para preencher um retângulo de 200×200. O modo de envolvimento
/// é configurado para virar a imagem horizontalmente.

procedure TDemoTileImage.FlipHorizontally;
var
  Image: TGdipImage;
  Brush: TGdipTextureBrush;
  BlackPen: TGdipPen;
begin
  Image := TGdipImage.FromFile('..\..\imagens\HouseAndTree.gif');
  Brush := TGdipTextureBrush.Create(Image);
  BlackPen := TGdipPen.Create(TGdipColor.FromArgb(255, 0, 0, 0));

  Brush.WrapMode := TGdipWrapMode.TileFlipX;
  Graphics.FillRectangle(Brush, TRectangle.Create(300, 0, 200, 200));
  Graphics.DrawRectangle(BlackPen, TRectangle.Create(300, 0, 200, 200));

  BlackPen.Free();
  Brush.Free();
  Image.Free();
end;

/// A imagem no canto superior direito mostra como o retângulo é preenchido com a imagem em mosaico. Note
/// que à medida que você se move de um ladrilho para o próximo em uma determinada linha, a imagem é
/// virada horizontalmente.
///
/// <H>Virando uma Imagem Verticalmente Enquanto Preenche com Mosaico</H>
/// Este exemplo usa uma imagem de 75×75 para preencher um retângulo de 200×200. O modo de envolvimento
/// é configurado para virar a imagem verticalmente.

procedure TDemoTileImage.FlipVertically;
var
  Image: TGdipImage;
  Brush: TGdipTextureBrush;
  BlackPen: TGdipPen;
begin
  Image := TGdipImage.FromFile('..\..\imagens\HouseAndTree.gif');
  Brush := TGdipTextureBrush.Create(Image);
  BlackPen := TGdipPen.Create(TGdipColor.FromArgb(255, 0, 0, 0));

  Brush.WrapMode := TGdipWrapMode.TileFlipY;
  Graphics.FillRectangle(Brush, TRectangle.Create(0, 300, 200, 200));
  Graphics.DrawRectangle(BlackPen, TRectangle.Create(0, 300, 200, 200));

  BlackPen.Free();
  Brush.Free();
  Image.Free();
end;

/// A ilustração no canto inferior esquerdo mostra como o retângulo é preenchido com a imagem em mosaico. Note
/// que à medida que você se move de um ladrilho para o próximo em uma dada coluna,
/// a imagem é virada verticalmente.
///
/// <H>Virando uma Imagem Horizontal e Verticalmente Enquanto Preenche com Mosaico</H>
/// Este exemplo usa uma imagem de 75×75 para preencher um retângulo de 200×200 com mosaico. O modo de envolvimento
/// é configurado para virar a imagem tanto horizontal quanto verticalmente.

procedure TDemoTileImage.FlipXY;
var
  Image: TGdipImage;
  Brush: TGdipTextureBrush;
  BlackPen: TGdipPen;
begin
  Image := TGdipImage.FromFile('..\..\imagens\HouseAndTree.gif');
  Brush := TGdipTextureBrush.Create(Image);
  BlackPen := TGdipPen.Create(TGdipColor.FromArgb(255, 0, 0, 0));

  Brush.WrapMode := TGdipWrapMode.TileFlipXY;
  Graphics.FillRectangle(Brush, TRectangle.Create(300, 300, 200, 200));
  Graphics.DrawRectangle(BlackPen, TRectangle.Create(300, 300, 200, 200));

  BlackPen.Free();
  Brush.Free();
  Image.Free();
end;

/// A ilustração no canto inferior direito mostra como o retângulo é preenchido com a imagem em mosaico.
/// Observe que à medida que você se move de um ladrilho para o próximo em uma determinada linha, a imagem é
/// virada horizontalmente, e à medida que você se move de um ladrilho para o próximo em uma determinada
/// coluna, a imagem é virada verticalmente.
{$ENDREGION}

procedure TDemoTileImage.Run;
begin
  Tile();
  FlipHorizontally();
  FlipVertically();
  FlipXY();
end;

initialization
  RegisterDemo('Usando o pincel para preencher formas\Preenchendo uma Forma com uma imagem em mosaico', TDemoTileImage);

end.
