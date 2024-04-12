unit uDemoInstalledFonts;

interface

uses
   Se7e.Drawing,
   Se7e.Drawing.Gdiplus.Types,
   uDemo;

type
  TDemoInstalledFonts = class(TDemo)
  strict protected
    procedure Run; override;
  public
    class function Outputs: TDemoOutputs; override;
  end;

implementation

{ TDemoInstalledFonts }

class function TDemoInstalledFonts.Outputs: TDemoOutputs;
begin
  Result := [doText];
end;

{$REGION}
/// A interface <A>TGdipInstalledFontCollection</A> herda do
/// <A>IFontCollection</A> interface base abstrata. Você pode usar um
/// Objeto <A>TGdipInstalledFontCollection</A> para enumerar as fontes instaladas
/// o computador. A propriedade <A>Families</A> de um </A>TGdipInstalledFontCollection</A>
/// objeto retorna um array de objetos <A>TGdipFontFamily</A>.
///
/// O exemplo a seguir lista os nomes de todas as famílias de fontes instaladas no
/// o computador. O código recupera os nomes das famílias de fontes usando o método
/// Propriedade <A>FamilyName</A> de cada objeto <A>TGdipFontFamily</A> no array.

procedure TDemoInstalledFonts.Run;
var
  Collection: TGdipInstalledFontCollection;
  FontFamily: TGdipFontFamily;
begin
  Collection := TGdipInstalledFontCollection.Create();
  for FontFamily in Collection.Families do
  begin
    TextOutput.Add(FontFamily.FamilyName);
    FontFamily.Free();
  end;

  Collection.Free();
end;
{$ENDREGION}

initialization
  RegisterDemo('Usando texto e fontes\Enumerando fontes instaladas', TDemoInstalledFonts);

end.
