// Marcelo Melo
// 25/03/2024

unit Se7e.Windows.Win32.Graphics.Gdi;

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
   Math,
   StrUtils,
   Classes,
   Windows,
   Types,
   Se7e.ReadOnly,
   Se7e.Windows.Win32.PInvokeCore,
   Se7e.Drawing.Gdiplus.Types,
   Se7e.Drawing.Gdiplus.Utils,
   Se7e.Windows.Win32.Graphics.GdiplusAPI,
   Se7e.Drawing.Rectangle;

type

{$REGION 'TGdipDeviceContextHdcScope'}

   { TGdipDeviceContextHdcScope }

   /// <summary>
   ///  <para>
   ///   Helper to scope getting a <see cref="HDC"/> from a <see cref="IDeviceContext"/> object. Releases
   ///   the <see cref="HDC"/> when disposed, unlocking the parent <see cref="IDeviceContext"/> object.
   ///  </para>
   ///  <para>
   ///   Also saves and restores the state of the HDC.
   ///  </para>
   /// </summary>
   /// <remarks>
   ///  <para>
   ///   Use in a <see langword="using" /> statement. If you must pass this around, always pass by+
   ///   <see langword="ref" /> to avoid duplicating the handle and risking a double release.
   ///  </para>
   /// </remarks>
   TGdipDeviceContextHdcScope = record // readonly ref struct

      strict private m_savedHdcState: ReadOnly<Integer>;
      strict private m_deviceContext: IGdipHdcContext;
      strict private m_hdc: TDeviceContextHandle;

      public property DeviceContext: IGdipHdcContext read m_DeviceContext;
      public property HDC: TDeviceContextHandle read m_hdc;


      /// <summary>
      ///  Gets the <see cref="HDC"/> from the given <paramref name="deviceContext"/>.
      /// </summary>
      /// <remarks>
      ///  <para>
      ///   When a <see cref="TGdipGraphics"/> object is created from a <see cref="HDC"/> the clipping region and
      ///   the viewport origin are applied (<see cref="PInvokeCore.GetViewportExtEx(HDC, SIZE*)"/>). The clipping
      ///   region isn't reflected in <see cref="TGdipGraphics.Clip"/>, which is combined with the HDC HRegion.
      ///  </para>
      ///  <para>
      ///   The TGdipGraphics object saves and restores DC state when performing operations that would modify the DC to
      ///   maintain the DC in its original or returned state after <see cref="TGdipGraphics.ReleaseHdc()"/>.
      ///  </para>
      /// </remarks>
      /// <param name="applyGraphicsState">
      ///  Applies the origin transform and clipping region of the <paramref name="deviceContext"/> if it is an
      ///  object of type <see cref="TGdipGraphics"/>. Otherwise this is a no-op.
      /// </param>
      /// <param name="saveHdcState">
      ///  When true, saves and restores the <see cref="HDC"/> state.
      /// </param>
      public constructor Create(const deviceContext: IGdipHdcContext; const applyGraphicsState: Boolean = true; const saveHdcState: Boolean = false); overload;


      /// <summary>
      ///  Prefer to use <see cref="TGdipDeviceContextHdcScope(IDeviceContext, bool, bool)"/>.
      /// </summary>
      /// <remarks>
      ///  <para>
      ///   Ideally we'd not bifurcate what properties we apply unless we're absolutely sure we only want one.
      ///  </para>
      /// </remarks>
      public constructor Create(const deviceContext: IGdipHdcContext; const applyGraphicsState: TGdipApplyGraphicsProperties; const saveHdcState: Boolean = false); overload;

      strict private procedure ValidateHDC();

      public procedure Dispose();

      class operator implicit(const scope: TGdipDeviceContextHdcScope): TDeviceContextHandle;
      class operator implicit(const scope: TGdipDeviceContextHdcScope): NativeInt;
      class operator explicit(const scope: TGdipDeviceContextHdcScope): WPARAM;

      class operator Initialize({$IFDEF FPC}var{$ELSE}out{$ENDIF} Dest: TGdipDeviceContextHdcScope);
      class operator Finalize(var Dest: TGdipDeviceContextHdcScope);
{$IFDEF FPC}
      class operator Copy(constref Src: TGdipDeviceContextHdcScope; var Dest: TGdipDeviceContextHdcScope);
{$ELSE}
      class operator Assign(var Dest: TGdipDeviceContextHdcScope; const [ref] Src: TGdipDeviceContextHdcScope);
{$ENDIF}
   end;

{$ENDREGION 'TGdipDeviceContextHdcScope'}

{$REGION 'TGdipGetDcScope'}

   { TGdipGetDcScope }

   /// <summary>
   ///  Auxiliar para definir o escopo de vida de um <see cref="HDC"/> obtido através de <see cref="PInvokeCore.GetDC(HWND)"/> e
   ///  <see cref="PInvokeCore.GetDCEx(HWND, HRGN, GET_DCX_FLAGS)"/>. Libera o <see cref="HDC"/> (se houver)
   ///  quando descartado.
   /// </summary>
   /// <remarks>
   ///  <para>
   ///   Use em uma declaração <see langword="using" />. Se você precisar passar isso adiante, sempre passe por <see langword="ref" />
   ///   para evitar duplicar o identificador e arriscar uma liberação dupla.
   ///  </para>
   /// </remarks>
   TGdipGetDcScope = record

      strict private m_hdc: TDeviceContextHandle;
      strict private m_hwnd: THandle;

      public property HDC: TDeviceContextHandle read m_hdc;
      public property HWND: THandle read m_hwnd;
      strict private class function GetScreenDC(): TGdipGetDcScope; static;


      /// <summary>
      ///  Cria um escopo de DC para o monitor principal (não para toda a área de trabalho).
      /// </summary>
      /// <remarks>
      ///   <para>
      ///    <see cref="PInvoke.CreateDCW(PCWSTR, PCWSTR, PCWSTR, Windows.Win32.Graphics.Gdi.DEVMODEW*)" /> é a
      ///    API para obter o DC para toda a área de trabalho.
      ///   </para>
      /// </remarks>
      public class property ScreenDC: TGdipGetDcScope read GetScreenDC;
      strict private function GetIsNull(): Boolean;

      public property IsNull: Boolean read GetIsNull;

      public constructor Create(const hwnd: THandle); overload;


      /// <summary>
      ///  Cria um <see cref="HDC"/> usando <see cref="PInvokeCore.GetDCEx(HWND, HRGN, GET_DCX_FLAGS)"/>.
      /// </summary>
      /// <remarks>
      ///  <para>
      ///   GetWindowDC chama GetDCEx(hwnd, null, DCX_WINDOW | DCX_USESTYLE).
      ///  </para>
      ///  <para>
      ///   GetDC chama GetDCEx(hwnd, null, DCX_USESTYLE) quando recebe um identificador. (Quando recebe null possui lógica adicional,
      ///   e não pode ser substituído diretamente por GetDCEx.
      ///  </para>
      /// </remarks>
      public constructor Create(const hwnd: THandle; const hrgnClip: HRGN; const flags: GET_DCX_FLAGS); overload;

      public procedure Dispose();

      public class operator implicit(const scope: TGdipGetDcScope): NativeInt;
      public class operator implicit(const scope: TGdipGetDcScope): TDeviceContextHandle;
      public class operator Equal(const ALeft: TGdipGetDcScope; const ARight: NativeUInt): Boolean; overload;


      public class operator Initialize({$IFDEF FPC}var{$ELSE}out{$ENDIF} Dest: TGdipGetDcScope);
      public class operator Finalize(var Dest: TGdipGetDcScope);

{$IFDEF FPC}
      public class operator Copy(constref Src: TGdipGetDcScope; var Dest: TGdipGetDcScope);
{$ELSE}
      public class operator Assign(var Dest: TGdipGetDcScope; const [ref] Src: TGdipGetDcScope);
{$ENDIF}
   end;

{$ENDREGION 'TGdipGetDcScope'}

{$REGION 'TGdipRegionScope'}

   { TGdipRegionScope }

   /// <summary>
   ///  Helper to scope creating regions. Deletes the region when disposed.
   /// </summary>
   /// <remarks>
   ///  <para>
   ///   Use in a <see langword="using" /> statement. If you must pass this around, always pass
   ///   by <see langword="ref" /> to avoid duplicating the handle and risking a double deletion.
   ///  </para>
   /// </remarks>
   TGdipRegionScope = record
      strict private m_region: HRGN;
      public property Region: HRGN read m_region write m_region;
      strict private function GetIsNull(): Boolean;


      /// <summary>
      ///  Returns true if this represents a null HRGN.
      /// </summary>
      public property IsNull: Boolean read GetIsNull;


      /// <summary>
      ///  Creates a region with the given rectangle via <see cref="CreateRectRgn(int, int, int, int)"/>.
      /// </summary>
      public constructor Create(const rectangle: TRectangle); overload;


      /// <summary>
      ///  Creates a region with the given rectangle via <see cref="CreateRectRgn(int, int, int, int)"/>.
      /// </summary>
      public constructor Create(const x1: Integer; const y1: Integer; const x2: Integer; const y2: Integer); overload;


      /// <summary>
      ///  Creates a clipping region copy via <see cref="GetClipRgn(HDC, HRGN)"/> for the given device context.
      /// </summary>
      /// <param name="hdc">Handle to a device context to copy the clipping region from.</param>
      public constructor Create(const hdc: HDC); overload;


      /// <summary>
      ///  Creates a native region from a GDI+ <see cref="GpRegion"/>.
      /// </summary>
      public constructor Create(const region: IPointer<TGdiplusAPI.TGdipRegionPtr>; const graphics: IPointer<TGdiplusAPI.TGdipGraphicsPtr>); overload;

      public constructor Create(const region: IPointer<TGdiplusAPI.TGdipRegionPtr>; const hwnd: HWND); overload;

      strict private procedure InitializeFromGdiPlus(const region: TGdiplusAPI.TGdipRegionPtr; const graphics: TGdiplusAPI.TGdipGraphicsPtr);


      /// <summary>
      ///  Clears the handle. Use this to hand over ownership to another entity.
      /// </summary>
      public procedure RelinquishOwnership();

      public procedure Dispose();

      class operator implicit(const regionScope: TGdipRegionScope): HRGN;
   end;

{$ENDREGION 'TGdipRegionScope'}


implementation

{$REGION 'TGdipDeviceContextHdcScope'}

{ TGdipDeviceContextHdcScope }

constructor TGdipDeviceContextHdcScope.Create(const deviceContext: IGdipHdcContext; const applyGraphicsState: Boolean = true; const saveHdcState: Boolean = false);
begin
   Create(deviceContext, IfThen(applyGraphicsState, TGdipApplyGraphicsProperties.All, TGdipApplyGraphicsProperties.None), saveHdcState);

end;

constructor TGdipDeviceContextHdcScope.Create(const deviceContext: IGdipHdcContext; const applyGraphicsState: TGdipApplyGraphicsProperties; const saveHdcState: Boolean = false);
begin
   if (deviceContext = nil) then
   begin
      // As we're throwing in the constructor, `this` will never be passed back and as such .Dispose()
      // can't be called. We don't have anything to release at this point so there is no point in having
      // the finalizer run.
{$IFDEF DEBUG}
      //DisposalTracking.SuppressFinalize(this);
{$ENDIF}
      raise EArgumentNilException.Create('deviceContext');
   end;

   m_deviceContext := deviceContext;
   m_savedHdcState := 0;

   m_hdc := default(TDeviceContextHandle);

   var provider: IGdipGraphicsHdcProvider := deviceContext as IGdipGraphicsHdcProvider;
   var graphics: IGdipGraphics := deviceContext as IGdipGraphics;

   // There are three states of IDeviceContext that come into this class:
   //
   //  1. One that also implements IGdipGraphicsHdcProvider
   //  2. One that is directly on TGdipGraphics
   //  3. All other IDeviceContext instances
   //
   // In the third case there is no TGdipGraphics to apply Properties from. In the second case we must query
   // the TGdipGraphics object itself for Properties (transform and clip). In the first case the
   // IGdipGraphicsHdcProvider will let us know if we have an "unclean" TGdipGraphics object that we need to apply
   // Properties from.
   //
   // PaintEventArgs implements IGdipGraphicsHdcProvider and uses it to let us know that either (1) a TGdipGraphics
   // object hasn't been created yet, OR (2) the TGdipGraphics object has never been given a transform or clip.

   var needToApplyProperties: Boolean := applyGraphicsState <> TGdipApplyGraphicsProperties.None;
   if (graphics = nil) and (provider = nil) then
   begin
      // We have an IDeviceContext (case 3 above), we can't apply properties because there is no
      // TGdipGraphics object available.
      needToApplyProperties := false;
   end
   else if (provider <> nil) and (provider.IsGraphicsStateClean) then
   begin
      // We have IGdipGraphicsHdcProvider and it is telling us we have no properties to apply (case 1 above)
      needToApplyProperties := false;
   end;

   if (provider <> nil) then
   begin
      // We have a provider, grab the underlying HDC if possible unless we know we've created and
      // modified a TGdipGraphics object around it.

      if (needToApplyProperties) then
         m_hdc := default(TDeviceContextHandle)
      else
         m_hdc := provider.GetHdc();


      if (m_hdc = 0) then
      begin
         graphics := provider.GetGraphics( True );
         if (graphics = nil) then
         begin
            raise EInvalidOperationException.Create();
         end;

         m_deviceContext := graphics;
      end;
   end;

   if (not needToApplyProperties) or (graphics = nil) then
   begin

      if (m_hdc = 0) then
         m_hdc := DeviceContext.GetHdc()
      else
         m_hdc := HDC;

      ValidateHDC();

      if (saveHdcState) then
         m_savedHdcState := PInvokeCore.SaveDC(HDC)
      else
         m_savedHdcState := 0;


      Exit();
   end;


   graphics.GetHdc(applyGraphicsState, saveHdcState);

   // Temos um objeto TGdipGraphics (passado diretamente ou fornecido a nós por IGdipGraphicsHdcProvider)
   // que precisa de propriedades aplicadas.
   var DeviceContextSaveState: TGdiDeviceContextSaveState := graphics.GetHdc(applyGraphicsState, saveHdcState);
   m_hdc := DeviceContextSaveState.HDC;
   m_savedHdcState := DeviceContextSaveState.SaveState;
end;

procedure TGdipDeviceContextHdcScope.ValidateHDC();
begin
   if (HDC = 0) then
   begin
      // We don't want the disposal tracking to fire as it will take down unrelated tests.
{$IFDEF DEBUG}
//      DisposalTracking.SuppressFinalize(this);
{$ENDIF}
      raise EInvalidOperationException.Create('Null HDC');
   end;

   var type_: OBJ_TYPE := OBJ_TYPE(PInvokeCore.GetObjectType(HDC));
   case (type_) of
      OBJ_TYPE.OBJ_DC,
      OBJ_TYPE.OBJ_MEMDC,
      OBJ_TYPE.OBJ_METADC,
      OBJ_TYPE.OBJ_ENHMETADC:
      begin
      end;
   else
      begin
{$IFDEF DEBUG}
//         DisposalTracking.SuppressFinalize(this);
{$ENDIF}
         raise EInvalidOperationException.Create('Invalid handle (' +  type_.ToString() + ')');
      end;
   end;
end;

procedure TGdipDeviceContextHdcScope.Dispose();
begin
   if (m_savedHdcState <> 0) then
   begin
      PInvokeCore.RestoreDC(HDC, m_savedHdcState);
   end;

   // Observe que o TGdipGraphics rastreia o HDC que ele transmite, então não precisamos transmiti-lo de volta
   if not Supports(DeviceContext, IGdipGraphicsHdcProvider) then
   begin
      if Assigned(DeviceContext) then
         DeviceContext.ReleaseHdc();
   end;

{$IFDEF DEBUG}
//   DisposalTracking.SuppressFinalize(this);
{$ENDIF}
end;

class operator TGdipDeviceContextHdcScope.implicit(const scope: TGdipDeviceContextHdcScope): TDeviceContextHandle;
begin
   Result := scope.HDC;
end;

class operator TGdipDeviceContextHdcScope.implicit(const scope: TGdipDeviceContextHdcScope): NativeInt;
begin
   Result := scope.HDC;
end;

class operator TGdipDeviceContextHdcScope.explicit(const scope: TGdipDeviceContextHdcScope): WPARAM;
begin
   Result := WPARAM(scope.HDC);
end;

class operator TGdipDeviceContextHdcScope.Initialize({$IFDEF FPC}var{$ELSE}out{$ENDIF} Dest: TGdipDeviceContextHdcScope);
begin
   Dest.m_savedHdcState := 0;
   Dest.m_deviceContext := nil;
   Dest.m_hdc := 0;
end;

class operator TGdipDeviceContextHdcScope.Finalize(var Dest: TGdipDeviceContextHdcScope);
begin
   Dest.Dispose();
   Dest.m_savedHdcState := 0;
   Dest.m_deviceContext := nil;
   Dest.m_hdc := 0;
end;

{$IFDEF FPC}
class operator TGdipDeviceContextHdcScope.Copy(constref Src: TGdipDeviceContextHdcScope; var Dest: TGdipDeviceContextHdcScope);
{$ELSE}
class operator TGdipDeviceContextHdcScope.Assign(var Dest: TGdipDeviceContextHdcScope; const [ref] Src: TGdipDeviceContextHdcScope);
{$ENDIF}
begin
   raise EInvalidOperationException.Create('class operator TGdipDeviceContextHdcScope.Assign(var Dest: TGdipDeviceContextHdcScope; const [ref] Src: TGdipDeviceContextHdcScope);');
end;

{$ENDREGION 'TGdipDeviceContextHdcScope'}

{$REGION 'TGdipGetDcScope'}

{ TGdipGetDcScope }

class function TGdipGetDcScope.GetScreenDC(): TGdipGetDcScope;
begin
   Result := TGdipGetDcScope.Create(0);
end;

function TGdipGetDcScope.GetIsNull(): Boolean;
begin
   Result := m_hdc = 0;
end;

constructor TGdipGetDcScope.Create(const hwnd: THandle);
begin
   m_hwnd := hwnd;
   m_hdc := PInvokeCore.GetDC(hwnd);
end;

constructor TGdipGetDcScope.Create(const hwnd: THandle; const hrgnClip: HRGN; const flags: GET_DCX_FLAGS);
begin
   m_hwnd := hwnd;
   m_hdc := PInvokeCore.GetDCEx(hwnd, hrgnClip, flags);
end;

procedure TGdipGetDcScope.Dispose();
begin
   if not (m_hdc = 0) then
   begin
      PInvokeCore.ReleaseDC(HWND, HDC);
      m_hdc := 0;
      m_hwnd := 0;
   end;
end;

class operator TGdipGetDcScope.implicit(const scope: TGdipGetDcScope): NativeInt;
begin
   Result := scope.HDC;
end;

class operator TGdipGetDcScope.implicit(const scope: TGdipGetDcScope): TDeviceContextHandle;
begin
   Result := scope.HDC;
end;

class operator TGdipGetDcScope.Equal(const ALeft: TGdipGetDcScope; const ARight: NativeUInt): Boolean;
begin
   Result := ALeft.m_hdc = ARight;
end;

class operator TGdipGetDcScope.Initialize({$IFDEF FPC}var{$ELSE}out{$ENDIF} Dest: TGdipGetDcScope);
begin
   Dest.m_hdc := 0;
   Dest.m_hwnd := 0;
end;

class operator TGdipGetDcScope.Finalize(var Dest: TGdipGetDcScope);
begin
   Dest.Dispose();
end;

{$IFDEF FPC}
class operator TGdipGetDcScope.Copy(constref Src: TGdipGetDcScope; var Dest: TGdipGetDcScope);
{$ELSE}
class operator TGdipGetDcScope.Assign(var Dest: TGdipGetDcScope; const [ref] Src: TGdipGetDcScope);
{$ENDIF}
begin
   raise EInvalidOperationException.Create('class operator TGdipGetDcScope.Assign(var Dest: TGdipGetDcScope; const [ref] Src: TGdipGetDcScope);');
end;

{$ENDREGION 'TGdipGetDcScope'}

{$REGION 'TGdipRegionScope'}

{ TGdipRegionScope }

function TGdipRegionScope.GetIsNull(): Boolean;
begin
   Result := Region = 0;
end;

constructor TGdipRegionScope.Create(const rectangle: TRectangle);
begin
   Region := PInvokeCore.CreateRectRgn(rectangle.X, rectangle.Y, rectangle.Right, rectangle.Bottom);;
end;

constructor TGdipRegionScope.Create(const x1: Integer; const y1: Integer; const x2: Integer; const y2: Integer);
begin
   Region := PInvokeCore.CreateRectRgn(x1, y1, x2, y2);;
end;

constructor TGdipRegionScope.Create(const hdc: HDC);
begin
   var region: HRGN := PInvokeCore.CreateRectRgn(0, 0, 0, 0);
   var _result: Integer := PInvokeCore.GetClipRgn(hdc, region);
   Assert(_result <> -1, 'GetClipRgn failed');

   if (_result = 1) then
   begin
      m_region := region;
   end
   else
   begin
      // No region, delete our temporary region
      PInvokeCore.DeleteObject(region);
      m_region := 0;
   end;
end;

constructor TGdipRegionScope.Create(const region: IPointer<TGdiplusAPI.TGdipRegionPtr>; const graphics: IPointer<TGdiplusAPI.TGdipGraphicsPtr>);
begin
   InitializeFromGdiPlus(region.Pointer, graphics.Pointer);
end;

constructor TGdipRegionScope.Create(const region: IPointer<TGdiplusAPI.TGdipRegionPtr>; const hwnd: HWND);
begin
   var graphics: TGdiplusAPI.TGdipGraphicsPtr := nil;
   TGdiplusAPI.GdipCreateFromHWND(hwnd, graphics).ThrowIfFailed();
   InitializeFromGdiPlus(region.Pointer, graphics);
end;

procedure TGdipRegionScope.InitializeFromGdiPlus(const region: TGdiplusAPI.TGdipRegionPtr; const graphics: TGdiplusAPI.TGdipGraphicsPtr);
begin
   var isInfinite: LongBool;
   TGdiplusAPI.GdipIsInfiniteRegion(region, graphics, isInfinite).ThrowIfFailed();

   if (isInfinite) then
   begin
      // An infinite region would cover the entire device region which is the same as
      // not having a clipping region. Observe that this is not the same as having an
      // empty region, which when clipping to it has the effect of excluding the entire
      // device region.
      //
      // To remove the clip region from a dc the SelectClipRgn() function needs to be
      // called with a null region ptr - that's why we use the empty constructor here.
      // GDI+ will return IntPtr.Zero for TGdipRegion.GetHrgn(TGdipGraphics) when the region is
      // Infinite.

      Self.Region := 0;

      Exit();
   end;

   var hrgn: HRGN;
   TGdiplusAPI.GdipGetRegionHRgn(region, graphics, hrgn).ThrowIfFailed();
   Self.Region := hrgn;
end;

procedure TGdipRegionScope.RelinquishOwnership();
begin
   Region := 0;
end;

procedure TGdipRegionScope.Dispose();
begin
   if (not IsNull) then
   begin
      PInvokeCore.DeleteObject(Region);
   end;
end;

class operator TGdipRegionScope.implicit(const regionScope: TGdipRegionScope): HRGN;
begin
   Result := regionScope.Region;
end;

{$ENDREGION 'TGdipRegionScope'}

end.
