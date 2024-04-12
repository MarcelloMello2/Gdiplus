unit uDemo;

interface

uses
  Classes,
  SysUtils,
  Se7e.Drawing.Gdiplus.Graphics;

type
  TDemoOutput = (doGraphic, doText, doPrint);
  TDemoOutputs = set of TDemoOutput;

  {$TYPEINFO ON} { Para fazer TDemo.UnitName funcionar }
  TDemo = class abstract
  strict private
    FGraphics: TGdipGraphics;
    FTextOutput: TStrings;
  strict protected
    procedure Run; virtual; abstract;

    property Graphics: TGdipGraphics read FGraphics;
    property TextOutput: TStrings read FTextOutput;
  public
    constructor Create; virtual;
    class function Outputs: TDemoOutputs; virtual;
    procedure Execute(const ATargetGraphics: TGdipGraphics; const ATextOutput: TStrings);
  end;
  {$TYPEINFO OFF}
  TDemoClass = class of TDemo;

procedure RegisterDemo(const Path: String; const DemoClass: TDemoClass);
function RegisteredDemos: TStringList;

implementation

var
  GlobalRegisteredDemos: TStringList = nil;

procedure RegisterDemo(const Path: String; const DemoClass: TDemoClass);
begin
  GlobalRegisteredDemos.AddObject(Path, Pointer(DemoClass));
end;

function RegisteredDemos: TStringList;
begin
  Result := GlobalRegisteredDemos;
end;

{ TDemo }

constructor TDemo.Create;
begin
  inherited Create;
end;

procedure TDemo.Execute(const ATargetGraphics: TGdipGraphics; const ATextOutput: TStrings);
begin
  FGraphics := ATargetGraphics;
  FGraphics.ResetTransform;
  FTextOutput := ATextOutput;
  if Assigned(FTextOutput) then
    FTextOutput.BeginUpdate;
  try
    Run;
  finally
    if Assigned(FTextOutput) then
      FTextOutput.EndUpdate;
  end;
end;

class function TDemo.Outputs: TDemoOutputs;
begin
  Result := [doGraphic];
end;

initialization
  GlobalRegisteredDemos := TStringList.Create;

finalization
  FreeAndNil(GlobalRegisteredDemos);

end.
