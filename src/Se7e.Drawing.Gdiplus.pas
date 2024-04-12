// Marcelo Melo
// 17/03/2024

unit Se7e.Drawing.Gdiplus;

{$SCOPEDENUMS ON}
{$ZEROBASEDSTRINGS ON}
{$ALIGN 8}
{$MINENUMSIZE 4}

{$IFDEF FPC}
  {$MODE DELPHI}
{$ENDIF}

interface

uses
   SysUtils,
   Classes,
   Types,
   Windows,
   Se7e.Windows.Win32.Graphics.GdiplusAPI;

type

   { TGdip }


   TGdip = class sealed (* static *) (* partial *)
      strict private class var s_initToken: NativeUInt;

      strict private class constructor Create();
      strict private class function GetInitialized(): Boolean; static;

      /// <summary>
      /// Returns true if GDI+ has been started, but not shut down
      /// </summary>
      public class property Initialized: Boolean read GetInitialized;
      strict private class function Init(): NativeUInt; static;

      // Used to ensure static constructor has run.
      public class procedure CheckStatus(const status: TGdiplusAPI.TGdipStatusEnum); static;
      public class function StatusException(const status: TGdiplusAPI.TGdipStatusEnum): Exception; static;
   end;

implementation

{ TGdip }

class constructor TGdip.Create();
begin
   s_initToken := Init();
end;

class function TGdip.GetInitialized(): Boolean;
begin
   Result := s_initToken <> 0;
end;

class function TGdip.Init(): NativeUInt;
begin
   Assert(s_initToken = 0, 'GdiplusInitialization: Initialize should not be called more than once in the same domain!');

   // GDI+ ref counts multiple calls to Startup in the same process, so calls from multiple
   // domains are ok, just make sure to pair each w/GdiplusShutdown

   var token: NativeUInt;
   var startup: TGdiplusAPI.TGdiplusStartupInputEx := TGdiplusAPI.TGdiplusStartupInputEx.GetDefault();
   var startupOutput: TGdiplusAPI.TGdiplusStartupOutput := Default(TGdiplusAPI.TGdiplusStartupOutput);
   var status: TGdiplusAPI.TGdipStatusEnum := TGdiPlusAPI.GdiplusStartup(token, TGdiplusAPI.PGdiplusStartupInput(@startup), startupOutput);
   CheckStatus(status);
   Exit(token);
end;

class procedure TGdip.CheckStatus(const status: TGdiplusAPI.TGdipStatusEnum);
begin
   status.ThrowIfFailed();
end;

class function TGdip.StatusException(const status: TGdiplusAPI.TGdipStatusEnum): Exception;
begin
   Result := status.GetException();
end;

procedure InitializeGdiPlus();
begin
   // Ensure GDI+ is initialized with the module.
   var initialized: Boolean := TGdip.Initialized;
   Assert(initialized);
end;

initialization
   InitializeGdiPlus();

end.

