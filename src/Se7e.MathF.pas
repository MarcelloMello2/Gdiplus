// Marcelo Melo
// 01/04/2024

unit Se7e.MathF;

{$SCOPEDENUMS ON}
{$ZEROBASEDSTRINGS ON}
{$POINTERMATH ON}
{$ALIGN 8}
{$MINENUMSIZE 4}

interface

uses
   SysUtils,
   Classes,
   Math;

type

    /// <summary>
    /// Provides constants and static methods for trigonometric, logarithmic, and other common mathematical functions.
    /// </summary>
   TMathF = class sealed (*static*)
      public const PI = Single(3.14159265);
      public class function IEEERemainder(const x: Single; const y: Single): Single; static;
   end;

implementation

{ TMathF }

class function TMathF.IEEERemainder(const x: Single; const y: Single): Single;
begin
   if (Single.IsNan(x)) then
   begin
       Exit(x); // IEEE 754-2008: NaN payload must be preserved
   end;

   if (Single.IsNaN(y)) then
   begin
       Exit(y); // IEEE 754-2008: NaN payload must be preserved
   end;

   var regularMod: Single := Math.FMod(x,  y);

   if (Single.IsNaN(regularMod)) then
   begin
       Exit(Single.NaN);
   end;

   if (regularMod = 0) and (x < 0) then
   begin
       Exit(-0);
   end;

   var alternativeResult: Single := (regularMod - (Abs(y) * Sign(x)));

   if (Abs(alternativeResult) = Abs(regularMod)) then
   begin
       var divisionResult: Single := x / y;
       var roundedResult: Single := Round(divisionResult);

       if (Abs(roundedResult) > Abs(divisionResult)) then
       begin
           Exit(alternativeResult);
       end
       else
       begin
           Exit(regularMod);
       end;
   end;

   if (Abs(alternativeResult) < Abs(regularMod)) then
   begin
       Exit(alternativeResult);
   end
   else
   begin
       Exit(regularMod);
   end;
end;

end.
