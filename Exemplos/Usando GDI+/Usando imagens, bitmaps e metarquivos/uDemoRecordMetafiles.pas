unit uDemoRecordMetafiles;

interface

uses
   Types,
   Windows,
   Se7e.Drawing,
   Se7e.Drawing.Gdiplus.Types,
   uDemo;

type
  TDemoRecordMetafiles = class(TDemo)
  strict protected
    procedure Run; override;
  end;

implementation

uses
  SysUtils;

{$REGION}
/// A interface <A>TGdipMetafile</A>, que herda do <A>TGdipImage</A>
/// interface, permite gravar uma sequência de comandos de desenho. O gravado
/// os comandos podem ser armazenados na memória, salvos em um arquivo ou salvos em um fluxo.
/// Metarquivos podem conter gráficos vetoriais, imagens raster e texto.
///
/// O exemplo a seguir cria um objeto <A>TGdipMetafile</A>. O código usa o
/// Objeto <A>TGdipMetafile</A> para gravar uma sequência de comandos gráficos e depois
/// salva os comandos gravados em um arquivo chamado SampleMetafileRecording.emf.
/// Observe que o construtor <A>TGdipMetafile</A> recebe um identificador de contexto de dispositivo,
/// e o construtor <A>TGdipGraphics</A> recebe o objeto <A>TGdipMetafile</A>.
/// A gravação para (e os comandos gravados são salvos no arquivo) quando
/// o objeto <A>TGdipGraphics</A> sai do escopo. A última linha de exibição do código
/// o metarquivo passando o objeto <A>TGdipMetafile</A> para o <A>DrawImage</A>
/// método do objeto <A>TGdipGraphics</A>. Observe que o código usa o mesmo
/// Objeto <A>TGdipMetafile</A> para gravar e exibir (reproduzir) o metarquivo.

procedure TDemoRecordMetafiles.Run;
var
  DC: HDC;
  Metafile: TGdipMetafile;
  MetaGraphics: TGdipGraphics;
  GreenPen: TGdipPen;
  SolidBrush: TGdipSolidBrush;
  FontFamily: TGdipFontFamily;
  Font: TGdipFont;
begin
  DC := GetDC(0);
  try
    DeleteFile('SampleMetafileRecording.emf');
    Metafile := TGdipMetafile.Create('SampleMetafileRecording.emf', DC);
    MetaGraphics := TGdipGraphics.FromImage(Metafile);
    GreenPen := TGdipPen.Create(TGdipColor.FromArgb(255, 0, 255, 0));
    SolidBrush := TGdipSolidBrush.Create(TGdipColor.FromArgb(255, 0, 0, 255));

    // Adicione um retângulo e uma elipse ao metarquivo.
    MetaGraphics.DrawRectangle(GreenPen, TRectangle.Create(50, 10, 25, 75));
    MetaGraphics.DrawEllipse(GreenPen, TRectangle.Create(100, 10, 25, 75));

    // Adicione uma elipse (desenhada com antialiasing) ao metarquivo.
    MetaGraphics.SmoothingMode := TGdipSmoothingMode.HighQuality;
    MetaGraphics.DrawEllipse(GreenPen, TRectangle.Create(150, 10, 25, 75));

    // Adicione algum texto (desenhado com antialiasing) ao metarquivo.
    FontFamily := TGdipFontFamily.Create('Arial');
    Font := TGdipFont.Create(FontFamily, 24, TGdipFontStyle.Regular, TGdipGraphicsUnit.Pixel);

    MetaGraphics.TextRenderingHint := TGdipTextRenderingHint.AntiAlias;
    MetaGraphics.RotateTransform(30);
    MetaGraphics.DrawString('Texto Suave', Font, SolidBrush, TPointF.Create(50, 50));

    Font.Free();
    FontFamily.Free();
    SolidBrush.Free();
    GreenPen.Free();
    MetaGraphics.Free(); // Fim da gravação do metarquivo.

    // Reproduza o metarquivo.
    Graphics.DrawImage(Metafile, 200, 100);
    Metafile.Free();
  finally
    ReleaseDC(0, DC);
  end;
end;

/// <B>Nota</B> Para gravar um metarquivo, você deve construir um <A>TGdipGraphics</A>
/// objeto baseado em um objeto <A>TGdipMetafile</A>. A gravação do metarquivo
/// termina quando o objeto <A>TGdipGraphics</A> é excluído ou sai do escopo.
///
/// Um metarquivo contém seu próprio estado gráfico, que é definido pelo
/// Objeto <A>TGdipGraphics</A> usado para registrar o metarquivo. Quaisquer propriedades do
/// Objeto <A>TGdipGraphics</A> (região do clipe, transformação do mundo, modo de suavização,
/// e similares) que você definiu durante a gravação do metarquivo serão armazenados em
/// o metarquivo. Ao exibir o metarquivo, o desenho será feito
/// de acordo com essas propriedades armazenadas.
{$ENDREGION}

initialization
  RegisterDemo('Usando imagens, bitmaps e metarquivos\Gravando Metarquivos', TDemoRecordMetafiles);

end.
