unit uDemoPrintGdiPlusOutput;

interface

uses
   Se7e.Drawing,
   Se7e.Drawing.Gdiplus.Types,
   uDemo;

type
  TDemoPrintGdiPlusOutput = class(TDemo)
  strict protected
    procedure Run; override;
  public
    class function Outputs: TDemoOutputs; override;
  end;

implementation

uses
  Printers;

{ TDemoPrintGdiPlusOutput }

{$REGION}
/// Com alguns pequenos ajustes em seu código, você pode enviar ao Microsoft Windows
/// Saída GDI+ para uma impressora em vez de para uma tela. Para desenhar em uma impressora,
/// obtém um identificador de contexto de dispositivo para a impressora e passa esse identificador para um
/// Construtor <A>TGdipGraphics</A>. Coloque seus comandos de desenho GDI+ entre
/// chamadas para <A>StartDoc</A> e <A>EndDoc</A>.
///
/// Uma maneira de obter um identificador de contexto de dispositivo para uma impressora é exibir um print
/// caixa de diálogo e permite que o usuário escolha uma impressora.
///
/// O exemplo a seguir desenha uma linha, um retângulo e uma elipse no
/// impressora selecionada na caixa de diálogo de impressão. Clique no botão "Imprimir" acima
/// para executar o exemplo.

procedure TDemoPrintGdiPlusOutput.Run;
var
  PrinterGraphics: TGdipGraphics;
  Pen: TGdipPen;
begin
  Printer.BeginDoc;
  PrinterGraphics := TGdipGraphics.FromHdc(Printer.Handle);
  Pen := TGdipPen.Create(TGdipColor.Black);
  PrinterGraphics.DrawRectangle(Pen, 200, 500, 200, 150);
  PrinterGraphics.DrawEllipse(Pen, 200, 500, 200, 150);
  PrinterGraphics.DrawLine(Pen, 200, 500, 400, 650);
  Printer.EndDoc;

  Pen.Free();
  PrinterGraphics.Free();
end;

/// No código anterior, os três comandos de desenho GDI+ estão entre as chamadas
/// para os métodos <A>Printer.BeginDoc</A> e <A>Printer.EndDoc</A>. Todos
/// comandos gráficos entre <A>BeginDoc</A> e <A>EndDoc</A> são roteados para um
/// metarquivo temporário. Após a chamada para <A>EndDoc</A>, o driver da impressora
/// converte os dados no metarquivo para o formato exigido pelo específico
/// impressora sendo usada.
///
/// <B>Nota</B> Se o spool não estiver habilitado para a impressora que está sendo usada, o
/// a saída gráfica não é roteada para um metarquivo. Em vez disso, gráficos individuais
/// os comandos são processados pelo driver da impressora e depois enviados para a impressora.
{$ENDREGION}

class function TDemoPrintGdiPlusOutput.Outputs: TDemoOutputs;
begin
  Result := [doPrint];
end;

initialization
  RegisterDemo('Impressão\Enviando saída GDI+ para uma impressora', TDemoPrintGdiPlusOutput);

end.
