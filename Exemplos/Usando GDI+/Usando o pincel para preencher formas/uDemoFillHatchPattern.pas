unit uDemoFillHatchPattern;

interface

uses
   Se7e.Drawing,
   Se7e.Drawing.Gdiplus.Types,
   uDemo;

type
  TDemoFillHatchPattern = class(TDemo)
  strict protected
    procedure Run; override;
  end;

implementation

{$REGION}
/// Um padrão de hachura é feito de duas cores: uma para o fundo e outra para
/// as linhas que formam o padrão sobre o fundo. Para preencher uma forma fechada
/// com um padrão de hachura, use um objeto <A>TGdipHatchBrush</A>. O exemplo a seguir
/// demonstra como preencher uma elipse com um padrão de hachura:

procedure TDemoFillHatchPattern.Run;
var
  Brush: TGdipHatchBrush;
begin
  Brush := TGdipHatchBrush.Create(TGdipHatchStyle.Horizontal, TGdipColor.FromArgb(255, 255, 0, 0), TGdipColor.FromArgb(255, 128, 255, 255));
  Graphics.FillEllipse(Brush, 0, 0, 100, 60);
  Brush.Free();
end;

/// O construtor <A>TGdipHatchBrush</A> recebe três argumentos: o estilo da hachura,
/// a cor da linha da hachura e a cor do fundo. O argumento do estilo da hachura
/// pode ser qualquer elemento da enumeração <A>TGdipHatchStyle</A>.
/// Há mais de cinquenta elementos na enumeração <A>TGdipHatchStyle</A>; alguns
/// desses elementos são mostrados na seguinte lista:
///
///  - <B>HatchStyleHorizontal</B>
///  - <B>HatchStyleVertical</B>
///  - <B>HatchStyleForwardDiagonal</B>
///  - <B>HatchStyleBackwardDiagonal</B>
///  - <B>HatchStyleCross</B>
///  - <B>HatchStyleDiagonalCross</B>
{$ENDREGION}

initialization
  RegisterDemo('Usando o pincel para preencher formas\Preenchendo uma forma com um padrão de hachura', TDemoFillHatchPattern);

end.
