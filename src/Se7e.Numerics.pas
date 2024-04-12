// Marcelo Melo
// 01/04/2024

unit Se7e.Numerics;

{$SCOPEDENUMS ON}
{$ZEROBASEDSTRINGS ON}
{$POINTERMATH ON}
{$ALIGN 8}
{$MINENUMSIZE 4}

{$IFDEF FPC}
    {$MODE DELPHI}
{$ENDIF}

//{$MODESWITCH ALLOWINLINE}
//{$MODESWITCH AUTODEREF}

//{$MODESWITCH ADVANCEDRECORDS}
//{$MODESWITCH TYPEHELPERS}

interface

uses
   SysUtils,
   Classes,
   Math,
   Se7e.MathF,
   Se7e.Span;

type

{$REGION 'TMatrix3x2'}

   PMatrix3x2 = ^TMatrix3x2;

   { TMatrix3x2 }

   /// <summary>Represents a 3x2 matrix.</summary>
   /// <remarks><format type="text/markdown"><![CDATA[
   /// [!INCLUDE[vectors-are-rows-paragraph](~/includes/system-numerics-vectors-are-rows.md)]
   /// ]]></format></remarks>
   TMatrix3x2 = record(*IEquatable<TMatrix3x2>*) (* partial *)
       // In an ideal world, we'd have 3x Vector2 fields. However, Matrix3x2 was shipped with
      // 6x public float fields and as such we cannot change the "backing" fields without it being
      // a breaking change. Likewise, we cannot switch to using something like ExplicitLayout
      // without it pessimizing other parts of the JIT and still preventing things like field promotion.
      //
      // This nested Impl struct works around this problem by relying on the JIT treating same sizeof
      // value type bitcasts as a no-op. Effectively the entire implementation is here in this type
      // and the public facing Matrix3x2 just defers to it with simple reinterpret casts inserted
      // at the relevant points.

      /// <summary>The first element of the first row.</summary>
      public M11: Single;

      /// <summary>The second element of the first row.</summary>
      public M12: Single;

      /// <summary>The first element of the second row.</summary>
      public M21: Single;

      /// <summary>The second element of the second row.</summary>
      public M22: Single;

      /// <summary>The first element of the third row.</summary>
      public M31: Single;

      /// <summary>The second element of the third row.</summary>
      public M32: Single;
      strict private class function GetIdentity(): TMatrix3x2; static; inline;

      /// <summary>Gets the multiplicative identity matrix.</summary>
      /// <value>The multiplicative identify matrix.</value>
      public class property Identity: TMatrix3x2 read GetIdentity;
      strict private function GetIsIdentity(): Boolean; inline;

      /// <summary>Gets a value that indicates whether the current matrix is the identity matrix.</summary>
      /// <value><see langword="true" /> if the current matrix is the identity matrix; otherwise, <see langword="false" />.</value>
      public property IsIdentity: Boolean read GetIsIdentity;

      /// <summary>Creates a 3x2 matrix from the specified components.</summary>
      /// <param name="m11">The value to assign to the first element in the first row.</param>
      /// <param name="m12">The value to assign to the second element in the first row.</param>
      /// <param name="m21">The value to assign to the first element in the second row.</param>
      /// <param name="m22">The value to assign to the second element in the second row.</param>
      /// <param name="m31">The value to assign to the first element in the third row.</param>
      /// <param name="m32">The value to assign to the second element in the third row.</param>
      public constructor Create(const m11: Single; const m12: Single; const m21: Single; const m22: Single; const m31: Single; const m32: Single);

      /// <summary>Adds each element in one matrix with its corresponding element in a second matrix.</summary>
      /// <param name="value1">The first matrix.</param>
      /// <param name="value2">The second matrix.</param>
      /// <returns>The matrix that contains the summed values of <paramref name="value1" /> and <paramref name="value2" />.</returns>
      public class function Add(const value1: TMatrix3x2; const value2: TMatrix3x2): TMatrix3x2; static; inline;

      /// <summary>Creates a rotation matrix using the given rotation in radians.</summary>
      /// <param name="radians">The amount of rotation, in radians.</param>
      /// <returns>The rotation matrix.</returns>
      public class function CreateRotation(const radians: Single): TMatrix3x2; overload; static;

      /// <summary>Creates a scaling matrix from the specified X and Y components.</summary>
      /// <param name="xScale">The value to scale by on the X axis.</param>
      /// <param name="yScale">The value to scale by on the Y axis.</param>
      /// <returns>The scaling matrix.</returns>
      public class function CreateScale(const xScale: Single; const yScale: Single): TMatrix3x2; overload; static;

      /// <summary>Creates a scaling matrix that scales uniformly with the given scale.</summary>
      /// <param name="scale">The uniform scale to use.</param>
      /// <returns>The scaling matrix.</returns>
      public class function CreateScale(const scale: Single): TMatrix3x2; overload; static;

      /// <summary>Creates a skew matrix from the specified angles in radians.</summary>
      /// <param name="radiansX">The X angle, in radians.</param>
      /// <param name="radiansY">The Y angle, in radians.</param>
      /// <returns>The skew matrix.</returns>
      public class function CreateSkew(const radiansX: Single; const radiansY: Single): TMatrix3x2; overload; static;

      /// <summary>Creates a translation matrix from the specified X and Y components.</summary>
      /// <param name="xPosition">The X position.</param>
      /// <param name="yPosition">The Y position.</param>
      /// <returns>The translation matrix.</returns>
      public class function CreateTranslation(const xPosition: Single; const yPosition: Single): TMatrix3x2; overload; static;

      /// <summary>Tries to invert the specified matrix. The return value indicates whether the operation succeeded.</summary>
      /// <param name="matrix">The matrix to invert.</param>
      /// <param name="result">When this method returns, contains the inverted matrix if the operation succeeded.</param>
      /// <returns><see langword="true" /> if <paramref name="matrix" /> was converted successfully; otherwise,  <see langword="false" />.</returns>
      public class function Invert(const matrix: TMatrix3x2; out _result: TMatrix3x2): Boolean; static;

      /// <summary>Performs a linear interpolation from one matrix to a second matrix based on a value that specifies the weighting of the second matrix.</summary>
      /// <param name="matrix1">The first matrix.</param>
      /// <param name="matrix2">The second matrix.</param>
      /// <param name="amount">The relative weighting of <paramref name="matrix2" />.</param>
      /// <returns>The interpolated matrix.</returns>
      public class function Lerp(const matrix1: TMatrix3x2; const matrix2: TMatrix3x2; const amount: Single): TMatrix3x2; static; inline;

      /// <summary>Multiplies two matrices together to compute the product.</summary>
      /// <param name="value1">The first matrix.</param>
      /// <param name="value2">The second matrix.</param>
      /// <returns>The product matrix.</returns>
      public class function Multiply(const value1: TMatrix3x2; const value2: TMatrix3x2): TMatrix3x2; overload; static; inline;

      /// <summary>Multiplies a matrix by a float to compute the product.</summary>
      /// <param name="value1">The matrix to scale.</param>
      /// <param name="value2">The scaling value to use.</param>
      /// <returns>The scaled matrix.</returns>
      public class function Multiply(const value1: TMatrix3x2; const value2: Single): TMatrix3x2; overload; static; inline;

      /// <summary>Negates the specified matrix by multiplying all its values by -1.</summary>
      /// <param name="value">The matrix to negate.</param>
      /// <returns>The negated matrix.</returns>
      public class function Negate(const value: TMatrix3x2): TMatrix3x2; static; inline;

      /// <summary>Subtracts each element in a second matrix from its corresponding element in a first matrix.</summary>
      /// <param name="value1">The first matrix.</param>
      /// <param name="value2">The second matrix.</param>
      /// <returns>The matrix containing the values that result from subtracting each element in <paramref name="value2" /> from its corresponding element in <paramref name="value1" />.</returns>
      public class function Subtract(const value1: TMatrix3x2; const value2: TMatrix3x2): TMatrix3x2; static; inline;

      /// <summary>Returns a value that indicates whether this instance and another 3x2 matrix are equal.</summary>
      /// <param name="other">The other matrix.</param>
      /// <returns><see langword="true" /> if the two matrices are equal; otherwise, <see langword="false" />.</returns>
      /// <remarks>Two matrices are equal if all their corresponding elements are equal.</remarks>
      public function Equals(const other: TMatrix3x2): Boolean; overload; inline;

      /// <summary>Calculates the determinant for this matrix.</summary>
      /// <returns>The determinant.</returns>
      /// <remarks>The determinant is calculated by expanding the matrix with a third column whose values are (0,0,1).</remarks>
      public function GetDeterminant(): Single; inline;

      /// <summary>Returns a string that represents this matrix.</summary>
      /// <returns>The string representation of this matrix.</returns>
      /// <remarks>The numeric values in the returned string are formatted by using the conventions of the current culture. For example, for the en-US culture, the returned string might appear as <c>{ {M11:1.1 M12:1.2} {M21:2.1 M22:2.2} {M31:3.1 M32:3.2} }</c>.</remarks>
      public function ToString(): string;

      strict private function GetItem(const row: Integer; const column: Integer): Single; inline;
      strict private procedure SetItem(const row: Integer; const column: Integer; const Value: Single); inline;

      /// <summary>Gets or sets the element at the specified indices.</summary>
      /// <param name="row">The index of the row containing the element to get or set.</param>
      /// <param name="column">The index of the column containing the element to get or set.</param>
      /// <returns>The element at [<paramref name="row" />][<paramref name="column" />].</returns>
      /// <exception cref="ArgumentOutOfRangeException">
      /// <paramref name="row" /> was less than zero or greater than the number of rows.
      /// -or-
      /// <paramref name="column" /> was less than zero or greater than the number of columns.
      /// </exception>
      public property Items[const row: Integer; const column: Integer]: Single read GetItem write SetItem; default;

      /// <summary>Adds each element in one matrix with its corresponding element in a second matrix.</summary>
      /// <param name="value1">The first matrix.</param>
      /// <param name="value2">The second matrix.</param>
      /// <returns>The matrix that contains the summed values.</returns>
      /// <remarks>The <see cref="op_Addition" /> method defines the operation of the addition operator for <see cref="Matrix3x2" /> objects.</remarks>
      class operator Add(const value1: TMatrix3x2; const value2: TMatrix3x2): TMatrix3x2; inline;

      /// <summary>Returns a value that indicates whether the specified matrices are equal.</summary>
      /// <param name="value1">The first matrix to compare.</param>
      /// <param name="value2">The second matrix to compare.</param>
      /// <returns><see langword="true" /> if <paramref name="value1" /> and <paramref name="value2" /> are equal; otherwise, <see langword="false" />.</returns>
      /// <remarks>Two matrices are equal if all their corresponding elements are equal.</remarks>
      class operator Equal(const value1: TMatrix3x2; const value2: TMatrix3x2): Boolean; inline;

      /// <summary>Returns a value that indicates whether the specified matrices are not equal.</summary>
      /// <param name="value1">The first matrix to compare.</param>
      /// <param name="value2">The second matrix to compare.</param>
      /// <returns><see langword="true" /> if <paramref name="value1" /> and <paramref name="value2" /> are not equal; otherwise, <see langword="false" />.</returns>
      class operator NotEqual(const value1: TMatrix3x2; const value2: TMatrix3x2): Boolean; inline;

      /// <summary>Multiplies two matrices together to compute the product.</summary>
      /// <param name="value1">The first matrix.</param>
      /// <param name="value2">The second matrix.</param>
      /// <returns>The product matrix.</returns>
      /// <remarks>The <see cref="Matrix3x2.op_Multiply" /> method defines the operation of the multiplication operator for <see cref="Matrix3x2" /> objects.</remarks>
      class operator Multiply(const value1: TMatrix3x2; const value2: TMatrix3x2): TMatrix3x2;

      /// <summary>Multiplies a matrix by a float to compute the product.</summary>
      /// <param name="value1">The matrix to scale.</param>
      /// <param name="value2">The scaling value to use.</param>
      /// <returns>The scaled matrix.</returns>
      /// <remarks>The <see cref="Matrix3x2.op_Multiply" /> method defines the operation of the multiplication operator for <see cref="Matrix3x2" /> objects.</remarks>
      class operator Multiply(const value1: TMatrix3x2; const value2: Single): TMatrix3x2; inline;

      /// <summary>Subtracts each element in a second matrix from its corresponding element in a first matrix.</summary>
      /// <param name="value1">The first matrix.</param>
      /// <param name="value2">The second matrix.</param>
      /// <returns>The matrix containing the values that result from subtracting each element in <paramref name="value2" /> from its corresponding element in <paramref name="value1" />.</returns>
      /// <remarks>The <see cref="Subtract" /> method defines the operation of the subtraction operator for <see cref="Matrix3x2" /> objects.</remarks>
      class operator Subtract(const value1: TMatrix3x2; const value2: TMatrix3x2): TMatrix3x2; inline;

      /// <summary>Negates the specified matrix by multiplying all its values by -1.</summary>
      /// <param name="value">The matrix to negate.</param>
      /// <returns>The negated matrix.</returns>
      /// <altmember cref="Negate(Matrix3x2)"/>
      class operator Negative(const value: TMatrix3x2): TMatrix3x2; inline;
   end;

{$ENDREGION 'TMatrix3x2'}

{$REGION 'TMatrix4x4'}

   { TMatrix4x4 }

   /// <summary>Represents a 4x4 matrix.</summary>
   /// <remarks><format type="text/markdown"><![CDATA[
   /// [!INCLUDE[vectors-are-rows-paragraph](~/includes/system-numerics-vectors-are-rows.md)]
   /// ]]></format></remarks>
   TMatrix4x4 = record(*IEquatable<TMatrix4x4>*) (* partial *)
       // In an ideal world, we'd have 4x Vector4 fields. However, Matrix4x4 was shipped with
      // 16x public float fields and as such we cannot change the "backing" fields without it being
      // a breaking change. Likewise, we cannot switch to using something like ExplicitLayout
      // without it pessimizing other parts of the JIT and still preventing things like field promotion.
      //
      // This nested Impl struct works around this problem by relying on the JIT treating same sizeof
      // value type bitcasts as a no-op. Effectively the entire implementation is here in this type
      // and the public facing Matrix4x4 just defers to it with simple reinterpret casts inserted
      // at the relevant points.

      /// <summary>The first element of the first row.</summary>
      public M11: Single;

      /// <summary>The second element of the first row.</summary>
      public M12: Single;

      /// <summary>The third element of the first row.</summary>
      public M13: Single;

      /// <summary>The fourth element of the first row.</summary>
      public M14: Single;

      /// <summary>The first element of the second row.</summary>
      public M21: Single;

      /// <summary>The second element of the second row.</summary>
      public M22: Single;

      /// <summary>The third element of the second row.</summary>
      public M23: Single;

      /// <summary>The fourth element of the second row.</summary>
      public M24: Single;

      /// <summary>The first element of the third row.</summary>
      public M31: Single;

      /// <summary>The second element of the third row.</summary>
      public M32: Single;

      /// <summary>The third element of the third row.</summary>
      public M33: Single;

      /// <summary>The fourth element of the third row.</summary>
      public M34: Single;

      /// <summary>The first element of the fourth row.</summary>
      public M41: Single;

      /// <summary>The second element of the fourth row.</summary>
      public M42: Single;

      /// <summary>The third element of the fourth row.</summary>
      public M43: Single;

      /// <summary>The fourth element of the fourth row.</summary>
      public M44: Single;
      strict private class function GetIdentity(): TMatrix4x4; static; inline;

      /// <summary>Gets the multiplicative identity matrix.</summary>
      /// <value>Gets the multiplicative identity matrix.</value>
      public class property Identity: TMatrix4x4 read GetIdentity;
      strict private function GetIsIdentity(): Boolean; inline;

      /// <summary>Indicates whether the current matrix is the identity matrix.</summary>
      /// <value><see langword="true" /> if the current matrix is the identity matrix; otherwise, <see langword="false" />.</value>
      public property IsIdentity: Boolean read GetIsIdentity;

      /// <summary>Creates a 4x4 matrix from the specified components.</summary>
      /// <param name="m11">The value to assign to the first element in the first row.</param>
      /// <param name="m12">The value to assign to the second element in the first row.</param>
      /// <param name="m13">The value to assign to the third element in the first row.</param>
      /// <param name="m14">The value to assign to the fourth element in the first row.</param>
      /// <param name="m21">The value to assign to the first element in the second row.</param>
      /// <param name="m22">The value to assign to the second element in the second row.</param>
      /// <param name="m23">The value to assign to the third element in the second row.</param>
      /// <param name="m24">The value to assign to the third element in the second row.</param>
      /// <param name="m31">The value to assign to the first element in the third row.</param>
      /// <param name="m32">The value to assign to the second element in the third row.</param>
      /// <param name="m33">The value to assign to the third element in the third row.</param>
      /// <param name="m34">The value to assign to the fourth element in the third row.</param>
      /// <param name="m41">The value to assign to the first element in the fourth row.</param>
      /// <param name="m42">The value to assign to the second element in the fourth row.</param>
      /// <param name="m43">The value to assign to the third element in the fourth row.</param>
      /// <param name="m44">The value to assign to the fourth element in the fourth row.</param>
      public constructor Create(const m11: Single; const m12: Single; const m13: Single; const m14: Single; const m21: Single; const m22: Single; const m23: Single; const m24: Single; const m31: Single; const m32: Single; const m33: Single; const m34: Single; const m41: Single; const m42: Single; const m43: Single; const m44: Single); overload;

      /// <summary>Creates a <see cref="Matrix4x4" /> object from a specified <see cref="Matrix3x2" /> object.</summary>
      /// <param name="value">A 3x2 matrix.</param>
      /// <remarks>This constructor creates a 4x4 matrix whose <see cref="M13" />, <see cref="M14" />, <see cref="M23" />, <see cref="M24" />, <see cref="M31" />, <see cref="M32" />, <see cref="M34" />, and <see cref="M43" /> components are zero, and whose <see cref="M33" /> and <see cref="M44" /> components are one.</remarks>
      public constructor Create(const value: TMatrix3x2); overload;

      /// <summary>Adds each element in one matrix with its corresponding element in a second matrix.</summary>
      /// <param name="value1">The first matrix.</param>
      /// <param name="value2">The second matrix.</param>
      /// <returns>The matrix that contains the summed values of <paramref name="value1" /> and <paramref name="value2" />.</returns>
      public class function Add(const value1: TMatrix4x4; const value2: TMatrix4x4): TMatrix4x4; static; inline;

      /// <summary>Creates a rotation matrix from the specified yaw, pitch, and roll.</summary>
      /// <param name="yaw">The angle of rotation, in radians, around the Y axis.</param>
      /// <param name="pitch">The angle of rotation, in radians, around the X axis.</param>
      /// <param name="roll">The angle of rotation, in radians, around the Z axis.</param>
      /// <returns>The rotation matrix.</returns>
      public class function CreateFromYawPitchRoll(const yaw: Single; const pitch: Single; const roll: Single): TMatrix4x4; static;

      /// <summary>Creates a right-handed orthographic perspective matrix from the given view volume dimensions.</summary>
      /// <param name="width">The width of the view volume.</param>
      /// <param name="height">The height of the view volume.</param>
      /// <param name="zNearPlane">The minimum Z-value of the view volume.</param>
      /// <param name="zFarPlane">The maximum Z-value of the view volume.</param>
      /// <returns>The right-handed orthographic projection matrix.</returns>
      public class function CreateOrthographic(const width: Single; const height: Single; const zNearPlane: Single; const zFarPlane: Single): TMatrix4x4; static;

      /// <summary>Creates a left-handed orthographic perspective matrix from the given view volume dimensions.</summary>
      /// <param name="width">The width of the view volume.</param>
      /// <param name="height">The height of the view volume.</param>
      /// <param name="zNearPlane">The minimum Z-value of the view volume.</param>
      /// <param name="zFarPlane">The maximum Z-value of the view volume.</param>
      /// <returns>The left-handed orthographic projection matrix.</returns>
      public class function CreateOrthographicLeftHanded(const width: Single; const height: Single; const zNearPlane: Single; const zFarPlane: Single): TMatrix4x4; static;

      /// <summary>Creates a right-handed customized orthographic projection matrix.</summary>
      /// <param name="left">The minimum X-value of the view volume.</param>
      /// <param name="right">The maximum X-value of the view volume.</param>
      /// <param name="bottom">The minimum Y-value of the view volume.</param>
      /// <param name="top">The maximum Y-value of the view volume.</param>
      /// <param name="zNearPlane">The minimum Z-value of the view volume.</param>
      /// <param name="zFarPlane">The maximum Z-value of the view volume.</param>
      /// <returns>The right-handed orthographic projection matrix.</returns>
      public class function CreateOrthographicOffCenter(const left: Single; const right: Single; const bottom: Single; const top: Single; const zNearPlane: Single; const zFarPlane: Single): TMatrix4x4; static;

      /// <summary>Creates a left-handed customized orthographic projection matrix.</summary>
      /// <param name="left">The minimum X-value of the view volume.</param>
      /// <param name="right">The maximum X-value of the view volume.</param>
      /// <param name="bottom">The minimum Y-value of the view volume.</param>
      /// <param name="top">The maximum Y-value of the view volume.</param>
      /// <param name="zNearPlane">The minimum Z-value of the view volume.</param>
      /// <param name="zFarPlane">The maximum Z-value of the view volume.</param>
      /// <returns>The left-handed orthographic projection matrix.</returns>
      public class function CreateOrthographicOffCenterLeftHanded(const left: Single; const right: Single; const bottom: Single; const top: Single; const zNearPlane: Single; const zFarPlane: Single): TMatrix4x4; static;

      /// <summary>Creates a right-handed perspective projection matrix from the given view volume dimensions.</summary>
      /// <param name="width">The width of the view volume at the near view plane.</param>
      /// <param name="height">The height of the view volume at the near view plane.</param>
      /// <param name="nearPlaneDistance">The distance to the near view plane.</param>
      /// <param name="farPlaneDistance">The distance to the far view plane.</param>
      /// <returns>The right-handed perspective projection matrix.</returns>
      /// <exception cref="ArgumentOutOfRangeException"><paramref name="nearPlaneDistance" /> is less than or equal to zero.
      /// -or-
      /// <paramref name="farPlaneDistance" /> is less than or equal to zero.
      /// -or-
      /// <paramref name="nearPlaneDistance" /> is greater than or equal to <paramref name="farPlaneDistance" />.</exception>
      public class function CreatePerspective(const width: Single; const height: Single; const nearPlaneDistance: Single; const farPlaneDistance: Single): TMatrix4x4; static;

      /// <summary>Creates a left-handed perspective projection matrix from the given view volume dimensions.</summary>
      /// <param name="width">The width of the view volume at the near view plane.</param>
      /// <param name="height">The height of the view volume at the near view plane.</param>
      /// <param name="nearPlaneDistance">The distance to the near view plane.</param>
      /// <param name="farPlaneDistance">The distance to the far view plane.</param>
      /// <returns>The left-handed perspective projection matrix.</returns>
      /// <exception cref="ArgumentOutOfRangeException"><paramref name="nearPlaneDistance" /> is less than or equal to zero.
      /// -or-
      /// <paramref name="farPlaneDistance" /> is less than or equal to zero.
      /// -or-
      /// <paramref name="nearPlaneDistance" /> is greater than or equal to <paramref name="farPlaneDistance" />.</exception>
      public class function CreatePerspectiveLeftHanded(const width: Single; const height: Single; const nearPlaneDistance: Single; const farPlaneDistance: Single): TMatrix4x4; static;

      /// <summary>Creates a right-handed perspective projection matrix based on a field of view, aspect ratio, and near and far view plane distances.</summary>
      /// <param name="fieldOfView">The field of view in the y direction, in radians.</param>
      /// <param name="aspectRatio">The aspect ratio, defined as view space width divided by height.</param>
      /// <param name="nearPlaneDistance">The distance to the near view plane.</param>
      /// <param name="farPlaneDistance">The distance to the far view plane.</param>
      /// <returns>The right-handed perspective projection matrix.</returns>
      /// <exception cref="ArgumentOutOfRangeException"><paramref name="fieldOfView" /> is less than or equal to zero.
      /// -or-
      /// <paramref name="fieldOfView" /> is greater than or equal to <see cref="Math.PI" />.
      /// <paramref name="nearPlaneDistance" /> is less than or equal to zero.
      /// -or-
      /// <paramref name="farPlaneDistance" /> is less than or equal to zero.
      /// -or-
      /// <paramref name="nearPlaneDistance" /> is greater than or equal to <paramref name="farPlaneDistance" />.</exception>
      public class function CreatePerspectiveFieldOfView(const fieldOfView: Single; const aspectRatio: Single; const nearPlaneDistance: Single; const farPlaneDistance: Single): TMatrix4x4; static;

      /// <summary>Creates a left-handed perspective projection matrix based on a field of view, aspect ratio, and near and far view plane distances.</summary>
      /// <param name="fieldOfView">The field of view in the y direction, in radians.</param>
      /// <param name="aspectRatio">The aspect ratio, defined as view space width divided by height.</param>
      /// <param name="nearPlaneDistance">The distance to the near view plane.</param>
      /// <param name="farPlaneDistance">The distance to the far view plane.</param>
      /// <returns>The left-handed perspective projection matrix.</returns>
      /// <exception cref="ArgumentOutOfRangeException"><paramref name="fieldOfView" /> is less than or equal to zero.
      /// -or-
      /// <paramref name="fieldOfView" /> is greater than or equal to <see cref="Math.PI" />.
      /// <paramref name="nearPlaneDistance" /> is less than or equal to zero.
      /// -or-
      /// <paramref name="farPlaneDistance" /> is less than or equal to zero.
      /// -or-
      /// <paramref name="nearPlaneDistance" /> is greater than or equal to <paramref name="farPlaneDistance" />.</exception>
      public class function CreatePerspectiveFieldOfViewLeftHanded(const fieldOfView: Single; const aspectRatio: Single; const nearPlaneDistance: Single; const farPlaneDistance: Single): TMatrix4x4; static;

      /// <summary>Creates a right-handed customized perspective projection matrix.</summary>
      /// <param name="left">The minimum x-value of the view volume at the near view plane.</param>
      /// <param name="right">The maximum x-value of the view volume at the near view plane.</param>
      /// <param name="bottom">The minimum y-value of the view volume at the near view plane.</param>
      /// <param name="top">The maximum y-value of the view volume at the near view plane.</param>
      /// <param name="nearPlaneDistance">The distance to the near view plane.</param>
      /// <param name="farPlaneDistance">The distance to the far view plane.</param>
      /// <returns>The right-handed perspective projection matrix.</returns>
      /// <exception cref="ArgumentOutOfRangeException"><paramref name="nearPlaneDistance" /> is less than or equal to zero.
      /// -or-
      /// <paramref name="farPlaneDistance" /> is less than or equal to zero.
      /// -or-
      /// <paramref name="nearPlaneDistance" /> is greater than or equal to <paramref name="farPlaneDistance" />.</exception>
      public class function CreatePerspectiveOffCenter(const left: Single; const right: Single; const bottom: Single; const top: Single; const nearPlaneDistance: Single; const farPlaneDistance: Single): TMatrix4x4; static;

      /// <summary>Creates a left-handed customized perspective projection matrix.</summary>
      /// <param name="left">The minimum x-value of the view volume at the near view plane.</param>
      /// <param name="right">The maximum x-value of the view volume at the near view plane.</param>
      /// <param name="bottom">The minimum y-value of the view volume at the near view plane.</param>
      /// <param name="top">The maximum y-value of the view volume at the near view plane.</param>
      /// <param name="nearPlaneDistance">The distance to the near view plane.</param>
      /// <param name="farPlaneDistance">The distance to the far view plane.</param>
      /// <returns>The left-handed perspective projection matrix.</returns>
      /// <exception cref="ArgumentOutOfRangeException"><paramref name="nearPlaneDistance" /> is less than or equal to zero.
      /// -or-
      /// <paramref name="farPlaneDistance" /> is less than or equal to zero.
      /// -or-
      /// <paramref name="nearPlaneDistance" /> is greater than or equal to <paramref name="farPlaneDistance" />.</exception>
      public class function CreatePerspectiveOffCenterLeftHanded(const left: Single; const right: Single; const bottom: Single; const top: Single; const nearPlaneDistance: Single; const farPlaneDistance: Single): TMatrix4x4; static;

      /// <summary>Creates a matrix for rotating points around the X axis.</summary>
      /// <param name="radians">The amount, in radians, by which to rotate around the X axis.</param>
      /// <returns>The rotation matrix.</returns>
      public class function CreateRotationX(const radians: Single): TMatrix4x4; overload; static;

      /// <summary>Creates a matrix for rotating points around the Y axis.</summary>
      /// <param name="radians">The amount, in radians, by which to rotate around the Y-axis.</param>
      /// <returns>The rotation matrix.</returns>
      public class function CreateRotationY(const radians: Single): TMatrix4x4; overload; static;

      /// <summary>Creates a matrix for rotating points around the Z axis.</summary>
      /// <param name="radians">The amount, in radians, by which to rotate around the Z-axis.</param>
      /// <returns>The rotation matrix.</returns>
      public class function CreateRotationZ(const radians: Single): TMatrix4x4; overload; static;

      /// <summary>Creates a scaling matrix from the specified X, Y, and Z components.</summary>
      /// <param name="xScale">The value to scale by on the X axis.</param>
      /// <param name="yScale">The value to scale by on the Y axis.</param>
      /// <param name="zScale">The value to scale by on the Z axis.</param>
      /// <returns>The scaling matrix.</returns>
      public class function CreateScale(const xScale: Single; const yScale: Single; const zScale: Single): TMatrix4x4; overload; static;

      /// <summary>Creates a uniform scaling matrix that scale equally on each axis.</summary>
      /// <param name="scale">The uniform scaling factor.</param>
      /// <returns>The scaling matrix.</returns>
      public class function CreateScale(const scale: Single): TMatrix4x4; overload; static;

      /// <summary>Creates a translation matrix from the specified X, Y, and Z components.</summary>
      /// <param name="xPosition">The amount to translate on the X axis.</param>
      /// <param name="yPosition">The amount to translate on the Y axis.</param>
      /// <param name="zPosition">The amount to translate on the Z axis.</param>
      /// <returns>The translation matrix.</returns>
      public class function CreateTranslation(const xPosition: Single; const yPosition: Single; const zPosition: Single): TMatrix4x4; overload; static;

      /// <summary>Creates a right-handed viewport matrix from the specified parameters.</summary>
      /// <param name="x">X coordinate of the viewport upper left corner.</param>
      /// <param name="y">Y coordinate of the viewport upper left corner.</param>
      /// <param name="width">Viewport width.</param>
      /// <param name="height">Viewport height.</param>
      /// <param name="minDepth">Viewport minimum depth.</param>
      /// <param name="maxDepth">Viewport maximum depth.</param>
      /// <returns>The right-handed viewport matrix.</returns>
      /// <remarks>
      /// Viewport matrix
      ///    width / 2           0                 0           0
      ///        0          -height / 2            0           0
      ///        0               0        minDepth - maxDepth  0
      ///  x + width / 2  y + height / 2        minDepth       1
      /// </remarks>
      public class function CreateViewport(const x: Single; const y: Single; const width: Single; const height: Single; const minDepth: Single; const maxDepth: Single): TMatrix4x4; static;

      /// <summary>Creates a left-handed viewport matrix from the specified parameters.</summary>
      /// <param name="x">X coordinate of the viewport upper left corner.</param>
      /// <param name="y">Y coordinate of the viewport upper left corner.</param>
      /// <param name="width">Viewport width.</param>
      /// <param name="height">Viewport height.</param>
      /// <param name="minDepth">Viewport minimum depth.</param>
      /// <param name="maxDepth">Viewport maximum depth.</param>
      /// <returns>The left-handed viewport matrix.</returns>
      /// <remarks>
      /// Viewport matrix
      ///    width / 2           0                 0           0
      ///        0          -height / 2            0           0
      ///        0               0        maxDepth - minDepth  0
      ///  x + width / 2  y + height / 2        minDepth       1
      /// </remarks>
      public class function CreateViewportLeftHanded(const x: Single; const y: Single; const width: Single; const height: Single; const minDepth: Single; const maxDepth: Single): TMatrix4x4; static;

      /// <summary>Tries to invert the specified matrix. The return value indicates whether the operation succeeded.</summary>
      /// <param name="matrix">The matrix to invert.</param>
      /// <param name="result">When this method returns, contains the inverted matrix if the operation succeeded.</param>
      /// <returns><see langword="true" /> if <paramref name="matrix" /> was converted successfully; otherwise,  <see langword="false" />.</returns>
      public class function Invert(const matrix: TMatrix4x4; out _result: TMatrix4x4): Boolean; static;

      /// <summary>Performs a linear interpolation from one matrix to a second matrix based on a value that specifies the weighting of the second matrix.</summary>
      /// <param name="matrix1">The first matrix.</param>
      /// <param name="matrix2">The second matrix.</param>
      /// <param name="amount">The relative weighting of <paramref name="matrix2" />.</param>
      /// <returns>The interpolated matrix.</returns>
      public class function Lerp(const matrix1: TMatrix4x4; const matrix2: TMatrix4x4; const amount: Single): TMatrix4x4; static; inline;

      /// <summary>Multiplies two matrices together to compute the product.</summary>
      /// <param name="value1">The first matrix.</param>
      /// <param name="value2">The second matrix.</param>
      /// <returns>The product matrix.</returns>
      public class function Multiply(const value1: TMatrix4x4; const value2: TMatrix4x4): TMatrix4x4; overload; static;

      /// <summary>Multiplies a matrix by a float to compute the product.</summary>
      /// <param name="value1">The matrix to scale.</param>
      /// <param name="value2">The scaling value to use.</param>
      /// <returns>The scaled matrix.</returns>
      public class function Multiply(const value1: TMatrix4x4; const value2: Single): TMatrix4x4; overload; static; inline;

      /// <summary>Negates the specified matrix by multiplying all its values by -1.</summary>
      /// <param name="value">The matrix to negate.</param>
      /// <returns>The negated matrix.</returns>
      public class function Negate(const value: TMatrix4x4): TMatrix4x4; static; inline;

      /// <summary>Subtracts each element in a second matrix from its corresponding element in a first matrix.</summary>
      /// <param name="value1">The first matrix.</param>
      /// <param name="value2">The second matrix.</param>
      /// <returns>The matrix containing the values that result from subtracting each element in <paramref name="value2" /> from its corresponding element in <paramref name="value1" />.</returns>
      public class function Subtract(const value1: TMatrix4x4; const value2: TMatrix4x4): TMatrix4x4; static; inline;

      /// <summary>Transposes the rows and columns of a matrix.</summary>
      /// <param name="matrix">The matrix to transpose.</param>
      /// <returns>The transposed matrix.</returns>
      public class function Transpose(const matrix: TMatrix4x4): TMatrix4x4; static;

      /// <summary>Returns a value that indicates whether this instance and another 4x4 matrix are equal.</summary>
      /// <param name="other">The other matrix.</param>
      /// <returns><see langword="true" /> if the two matrices are equal; otherwise, <see langword="false" />.</returns>
      public function Equals(const other: TMatrix4x4): Boolean; overload; inline;

      /// <summary>Calculates the determinant of the current 4x4 matrix.</summary>
      /// <returns>The determinant.</returns>
      public function GetDeterminant(): Single;

      /// <summary>Returns a string that represents this matrix.</summary>
      /// <returns>The string representation of this matrix.</returns>
      /// <remarks>The numeric values in the returned string are formatted by using the conventions of the current culture. For example, for the en-US culture, the returned string might appear as <c>{ {M11:1.1 M12:1.2 M13:1.3 M14:1.4} {M21:2.1 M22:2.2 M23:2.3 M24:2.4} {M31:3.1 M32:3.2 M33:3.3 M34:3.4} {M41:4.1 M42:4.2 M43:4.3 M44:4.4} }</c>.</remarks>
      public function ToString(): string;

      strict private function GetItem(const row: Integer; const column: Integer): Single; inline;
      strict private procedure SetItem(const row: Integer; const column: Integer; const Value: Single); inline;

      /// <summary>Gets or sets the element at the specified indices.</summary>
      /// <param name="row">The index of the row containing the element to get or set.</param>
      /// <param name="column">The index of the column containing the element to get or set.</param>
      /// <returns>The element at [<paramref name="row" />][<paramref name="column" />].</returns>
      /// <exception cref="ArgumentOutOfRangeException">
      /// <paramref name="row" /> was less than zero or greater than the number of rows.
      /// -or-
      /// <paramref name="column" /> was less than zero or greater than the number of columns.
      /// </exception>
      public property Items[const row: Integer; const column: Integer]: Single read GetItem write SetItem; default;

      /// <summary>Adds each element in one matrix with its corresponding element in a second matrix.</summary>
      /// <param name="value1">The first matrix.</param>
      /// <param name="value2">The second matrix.</param>
      /// <returns>The matrix that contains the summed values.</returns>
      /// <remarks>The <see cref="op_Addition" /> method defines the operation of the addition operator for <see cref="Matrix4x4" /> objects.</remarks>
      class operator Add(const value1: TMatrix4x4; const value2: TMatrix4x4): TMatrix4x4; inline;

      /// <summary>Returns a value that indicates whether the specified matrices are equal.</summary>
      /// <param name="value1">The first matrix to compare.</param>
      /// <param name="value2">The second matrix to care</param>
      /// <returns><see langword="true" /> if <paramref name="value1" /> and <paramref name="value2" /> are equal; otherwise, <see langword="false" />.</returns>
      /// <remarks>Two matrices are equal if all their corresponding elements are equal.</remarks>
      class operator Equal(const value1: TMatrix4x4; const value2: TMatrix4x4): Boolean; inline;

      /// <summary>Returns a value that indicates whether the specified matrices are not equal.</summary>
      /// <param name="value1">The first matrix to compare.</param>
      /// <param name="value2">The second matrix to compare.</param>
      /// <returns><see langword="true" /> if <paramref name="value1" /> and <paramref name="value2" /> are not equal; otherwise, <see langword="false" />.</returns>
      class operator NotEqual(const value1: TMatrix4x4; const value2: TMatrix4x4): Boolean; inline;

      /// <summary>Multiplies two matrices together to compute the product.</summary>
      /// <param name="value1">The first matrix.</param>
      /// <param name="value2">The second matrix.</param>
      /// <returns>The product matrix.</returns>
      /// <remarks>The <see cref="Matrix4x4.op_Multiply" /> method defines the operation of the multiplication operator for <see cref="Matrix4x4" /> objects.</remarks>
      class operator Multiply(const value1: TMatrix4x4; const value2: TMatrix4x4): TMatrix4x4;

      /// <summary>Multiplies a matrix by a float to compute the product.</summary>
      /// <param name="value1">The matrix to scale.</param>
      /// <param name="value2">The scaling value to use.</param>
      /// <returns>The scaled matrix.</returns>
      /// <remarks>The <see cref="Matrix4x4.op_Multiply" /> method defines the operation of the multiplication operator for <see cref="Matrix4x4" /> objects.</remarks>
      class operator Multiply(const value1: TMatrix4x4; const value2: Single): TMatrix4x4; inline;

      /// <summary>Subtracts each element in a second matrix from its corresponding element in a first matrix.</summary>
      /// <param name="value1">The first matrix.</param>
      /// <param name="value2">The second matrix.</param>
      /// <returns>The matrix containing the values that result from subtracting each element in <paramref name="value2" /> from its corresponding element in <paramref name="value1" />.</returns>
      /// <remarks>The <see cref="op_Subtraction" /> method defines the operation of the subtraction operator for <see cref="Matrix4x4" /> objects.</remarks>
      class operator Subtract(const value1: TMatrix4x4; const value2: TMatrix4x4): TMatrix4x4; inline;

      /// <summary>Negates the specified matrix by multiplying all its values by -1.</summary>
      /// <param name="value">The matrix to negate.</param>
      /// <returns>The negated matrix.</returns>
      class operator Negative(const value: TMatrix4x4): TMatrix4x4; inline;
   end;
   PMatrix4x4 = ^TMatrix4x4;

{$ENDREGION 'TMatrix4x4'}

{$REGION 'TQuaternion'}

   { TQuaternion }

   /// <summary>Represents a vector that is used to encode three-dimensional physical rotations.</summary>
   /// <remarks>The <see cref="Quaternion" /> structure is used to efficiently rotate an object about the (x,y,z) vector by the angle theta, where:
   /// <c>w = cos(theta/2)</c></remarks>
   TQuaternion = record(*IEquatable<TQuaternion>*)
       strict private const SlerpEpsilon: Single = Single(1e-6);

      /// <summary>The X value of the vector component of the quaternion.</summary>
      public X: Single;

      /// <summary>The Y value of the vector component of the quaternion.</summary>
      public Y: Single;

      /// <summary>The Z value of the vector component of the quaternion.</summary>
      public Z: Single;

      /// <summary>The rotation component of the quaternion.</summary>
      public W: Single;

      public const Count: Integer = 4;
      strict private class function GetZero(): TQuaternion; static;

      /// <summary>Gets a quaternion that represents a zero.</summary>
      /// <value>A quaternion whose values are <c>(0, 0, 0, 0)</c>.</value>
      public class property Zero: TQuaternion read GetZero;
      strict private class function GetIdentity(): TQuaternion; static;

      /// <summary>Gets a quaternion that represents no rotation.</summary>
      /// <value>A quaternion whose values are <c>(0, 0, 0, 1)</c>.</value>
      public class property Identity: TQuaternion read GetIdentity;
      strict private function GetIsIdentity(): Boolean;

      /// <summary>Gets a value that indicates whether the current instance is the identity quaternion.</summary>
      /// <value><see langword="true" /> if the current instance is the identity quaternion; otherwise, <see langword="false" />.</value>
      /// <altmember cref="Identity"/>
      public property IsIdentity: Boolean read GetIsIdentity;

      /// <summary>Constructs a quaternion from the specified components.</summary>
      /// <param name="x">The value to assign to the X component of the quaternion.</param>
      /// <param name="y">The value to assign to the Y component of the quaternion.</param>
      /// <param name="z">The value to assign to the Z component of the quaternion.</param>
      /// <param name="w">The value to assign to the W component of the quaternion.</param>
      public constructor Create(const x: Single; const y: Single; const z: Single; const w: Single); overload;

      /// <summary>Adds each element in one quaternion with its corresponding element in a second quaternion.</summary>
      /// <param name="value1">The first quaternion.</param>
      /// <param name="value2">The second quaternion.</param>
      /// <returns>The quaternion that contains the summed values of <paramref name="value1" /> and <paramref name="value2" />.</returns>
      public class function Add(const value1: TQuaternion; const value2: TQuaternion): TQuaternion; static; inline;

      /// <summary>Concatenates two quaternions.</summary>
      /// <param name="value1">The first quaternion rotation in the series.</param>
      /// <param name="value2">The second quaternion rotation in the series.</param>
      /// <returns>A new quaternion representing the concatenation of the <paramref name="value1" /> rotation followed by the <paramref name="value2" /> rotation.</returns>
      public class function Concatenate(const value1: TQuaternion; const value2: TQuaternion): TQuaternion; static;

      /// <summary>Returns the conjugate of a specified quaternion.</summary>
      /// <param name="value">The quaternion.</param>
      /// <returns>A new quaternion that is the conjugate of <see langword="value" />.</returns>
      public class function Conjugate(const value: TQuaternion): TQuaternion; static; inline;

      /// <summary>Creates a quaternion from the specified rotation matrix.</summary>
      /// <param name="matrix">The rotation matrix.</param>
      /// <returns>The newly created quaternion.</returns>
      public class function CreateFromRotationMatrix(const matrix: TMatrix4x4): TQuaternion; static;

      /// <summary>Creates a new quaternion from the given yaw, pitch, and roll.</summary>
      /// <param name="yaw">The yaw angle, in radians, around the Y axis.</param>
      /// <param name="pitch">The pitch angle, in radians, around the X axis.</param>
      /// <param name="roll">The roll angle, in radians, around the Z axis.</param>
      /// <returns>The resulting quaternion.</returns>
      public class function CreateFromYawPitchRoll(const yaw: Single; const pitch: Single; const roll: Single): TQuaternion; static;

      /// <summary>Divides one quaternion by a second quaternion.</summary>
      /// <param name="value1">The dividend.</param>
      /// <param name="value2">The divisor.</param>
      /// <returns>The quaternion that results from dividing <paramref name="value1" /> by <paramref name="value2" />.</returns>
      public class function Divide(const value1: TQuaternion; const value2: TQuaternion): TQuaternion; overload; static; inline;

      /// <summary>Divides the specified quaternion by a specified scalar value.</summary>
      /// <param name="left">The quaternion.</param>
      /// <param name="divisor">The scalar value.</param>
      /// <returns>The quaternion that results from the division.</returns>
      public class function Divide(const left: TQuaternion; const divisor: Single): TQuaternion; overload; static; inline;

      /// <summary>Calculates the dot product of two quaternions.</summary>
      /// <param name="quaternion1">The first quaternion.</param>
      /// <param name="quaternion2">The second quaternion.</param>
      /// <returns>The dot product.</returns>
      public class function Dot(const quaternion1: TQuaternion; const quaternion2: TQuaternion): Single; static; inline;

      /// <summary>Returns the inverse of a quaternion.</summary>
      /// <param name="value">The quaternion.</param>
      /// <returns>The inverted quaternion.</returns>
      public class function Inverse(const value: TQuaternion): TQuaternion; static; inline;

      /// <summary>Performs a linear interpolation between two quaternions based on a value that specifies the weighting of the second quaternion.</summary>
      /// <param name="quaternion1">The first quaternion.</param>
      /// <param name="quaternion2">The second quaternion.</param>
      /// <param name="amount">The relative weight of <paramref name="quaternion2" /> in the interpolation.</param>
      /// <returns>The interpolated quaternion.</returns>
      public class function Lerp(const quaternion1: TQuaternion; const quaternion2: TQuaternion; const amount: Single): TQuaternion; static;

      /// <summary>Returns the quaternion that results from multiplying two quaternions together.</summary>
      /// <param name="value1">The first quaternion.</param>
      /// <param name="value2">The second quaternion.</param>
      /// <returns>The product quaternion.</returns>
      public class function Multiply(const value1: TQuaternion; const value2: TQuaternion): TQuaternion; overload; static; inline;

      /// <summary>Returns the quaternion that results from scaling all the components of a specified quaternion by a scalar factor.</summary>
      /// <param name="value1">The source quaternion.</param>
      /// <param name="value2">The scalar value.</param>
      /// <returns>The scaled quaternion.</returns>
      public class function Multiply(const value1: TQuaternion; const value2: Single): TQuaternion; overload; static; inline;

      /// <summary>Reverses the sign of each component of the quaternion.</summary>
      /// <param name="value">The quaternion to negate.</param>
      /// <returns>The negated quaternion.</returns>
      public class function Negate(const value: TQuaternion): TQuaternion; static; inline;

      /// <summary>Divides each component of a specified <see cref="Quaternion" /> by its length.</summary>
      /// <param name="value">The quaternion to normalize.</param>
      /// <returns>The normalized quaternion.</returns>
      public class function Normalize(const value: TQuaternion): TQuaternion; static; inline;

      /// <summary>Interpolates between two quaternions, using spherical linear interpolation.</summary>
      /// <param name="quaternion1">The first quaternion.</param>
      /// <param name="quaternion2">The second quaternion.</param>
      /// <param name="amount">The relative weight of the second quaternion in the interpolation.</param>
      /// <returns>The interpolated quaternion.</returns>
      public class function Slerp(const quaternion1: TQuaternion; const quaternion2: TQuaternion; const amount: Single): TQuaternion; static;

      /// <summary>Subtracts each element in a second quaternion from its corresponding element in a first quaternion.</summary>
      /// <param name="value1">The first quaternion.</param>
      /// <param name="value2">The second quaternion.</param>
      /// <returns>The quaternion containing the values that result from subtracting each element in <paramref name="value2" /> from its corresponding element in <paramref name="value1" />.</returns>
      public class function Subtract(const value1: TQuaternion; const value2: TQuaternion): TQuaternion; static; inline;

      /// <summary>Returns a value that indicates whether this instance and another quaternion are equal.</summary>
      /// <param name="other">The other quaternion.</param>
      /// <returns><see langword="true" /> if the two quaternions are equal; otherwise, <see langword="false" />.</returns>
      /// <remarks>Two quaternions are equal if each of their corresponding components is equal.</remarks>
      public function Equals(const other: TQuaternion): Boolean; overload; inline;

      /// <summary>Calculates the length of the quaternion.</summary>
      /// <returns>The computed length of the quaternion.</returns>
      public function Length(): Single; inline;

      /// <summary>Calculates the squared length of the quaternion.</summary>
      /// <returns>The length squared of the quaternion.</returns>
      public function LengthSquared(): Single; inline;

      /// <summary>Returns a string that represents this quaternion.</summary>
      /// <returns>The string representation of this quaternion.</returns>
      /// <remarks>The numeric values in the returned string are formatted by using the conventions of the current culture. For example, for the en-US culture, the returned string might appear as <c>{X:1.1 Y:2.2 Z:3.3 W:4.4}</c>.</remarks>
      public function ToString(): string;
      strict private function GetItem(const index: Integer): Single; inline;
      strict private procedure SetItem(const index: Integer; const Value: Single); inline;

      /// <summary>Gets or sets the element at the specified index.</summary>
      /// <param name="index">The index of the element to get or set.</param>
      /// <returns>The element at <paramref name="index" />.</returns>
      /// <exception cref="ArgumentOutOfRangeException"><paramref name="index" /> was less than zero or greater than the number of elements.</exception>
      public property Items[const index: Integer]: Single read GetItem write SetItem; default;

      /// <summary>Adds each element in one quaternion with its corresponding element in a second quaternion.</summary>
      /// <param name="value1">The first quaternion.</param>
      /// <param name="value2">The second quaternion.</param>
      /// <returns>The quaternion that contains the summed values of <paramref name="value1" /> and <paramref name="value2" />.</returns>
      /// <remarks>The <see cref="op_Addition" /> method defines the operation of the addition operator for <see cref="Quaternion" /> objects.</remarks>
      class operator Add(const value1: TQuaternion; const value2: TQuaternion): TQuaternion; inline;

      /// <summary>Divides one quaternion by a second quaternion.</summary>
      /// <param name="value1">The dividend.</param>
      /// <param name="value2">The divisor.</param>
      /// <returns>The quaternion that results from dividing <paramref name="value1" /> by <paramref name="value2" />.</returns>
      /// <remarks>The <see cref="op_Division" /> method defines the division operation for <see cref="Quaternion" /> objects.</remarks>
      class operator Divide(const value1: TQuaternion; const value2: TQuaternion): TQuaternion;

      /// <summary>Returns a value that indicates whether two quaternions are equal.</summary>
      /// <param name="value1">The first quaternion to compare.</param>
      /// <param name="value2">The second quaternion to compare.</param>
      /// <returns><see langword="true" /> if the two quaternions are equal; otherwise, <see langword="false" />.</returns>
      /// <remarks>Two quaternions are equal if each of their corresponding components is equal.
      /// The <see cref="op_Equality" /> method defines the operation of the equality operator for <see cref="Quaternion" /> objects.</remarks>
      class operator Equal(const value1: TQuaternion; const value2: TQuaternion): Boolean; inline;

      /// <summary>Returns a value that indicates whether two quaternions are not equal.</summary>
      /// <param name="value1">The first quaternion to compare.</param>
      /// <param name="value2">The second quaternion to compare.</param>
      /// <returns><see langword="true" /> if <paramref name="value1" /> and <paramref name="value2" /> are not equal; otherwise, <see langword="false" />.</returns>
      class operator NotEqual(const value1: TQuaternion; const value2: TQuaternion): Boolean; inline;

      /// <summary>Returns the quaternion that results from multiplying two quaternions together.</summary>
      /// <param name="value1">The first quaternion.</param>
      /// <param name="value2">The second quaternion.</param>
      /// <returns>The product quaternion.</returns>
      /// <remarks>The <see cref="Quaternion.op_Multiply" /> method defines the operation of the multiplication operator for <see cref="Quaternion" /> objects.</remarks>
      class operator Multiply(const value1: TQuaternion; const value2: TQuaternion): TQuaternion;

      /// <summary>Returns the quaternion that results from scaling all the components of a specified quaternion by a scalar factor.</summary>
      /// <param name="value1">The source quaternion.</param>
      /// <param name="value2">The scalar value.</param>
      /// <returns>The scaled quaternion.</returns>
      /// <remarks>The <see cref="Quaternion.op_Multiply" /> method defines the operation of the multiplication operator for <see cref="Quaternion" /> objects.</remarks>
      class operator Multiply(const value1: TQuaternion; const value2: Single): TQuaternion; inline;

      /// <summary>Subtracts each element in a second quaternion from its corresponding element in a first quaternion.</summary>
      /// <param name="value1">The first quaternion.</param>
      /// <param name="value2">The second quaternion.</param>
      /// <returns>The quaternion containing the values that result from subtracting each element in <paramref name="value2" /> from its corresponding element in <paramref name="value1" />.</returns>
      /// <remarks>The <see cref="op_Subtraction" /> method defines the operation of the subtraction operator for <see cref="Quaternion" /> objects.</remarks>
      class operator Subtract(const value1: TQuaternion; const value2: TQuaternion): TQuaternion; inline;

      /// <summary>Reverses the sign of each component of the quaternion.</summary>
      /// <param name="value">The quaternion to negate.</param>
      /// <returns>The negated quaternion.</returns>
      /// <remarks>The <see cref="op_UnaryNegation" /> method defines the operation of the unary negation operator for <see cref="Quaternion" /> objects.</remarks>
      class operator Negative(const value: TQuaternion): TQuaternion; inline;
   end;

{$ENDREGION 'TQuaternion'}

{$REGION 'TVector2'}

	/// <summary>
   ///    Representa um vetor com dois valores de ponto flutuante de precisão simples.
   /// </summary>
   /// <remarks>
   ///    <para>
   ///       A estrutura Vector2 fornece suporte para aceleração de hardware.
   ///    </para>
   ///    <para>
   ///       Para transformações de matriz, as instâncias <see cref="Se7e.Numerics.TVector2"/>, <see cref="Se7e.Numerics.TVector3"/> e <see cref="Se7e.Numerics.TVector4"/>
   ///       são representadas como linhas: um vetor v é transformado por uma matriz M com multiplicação vM.
   ///    </para>
   /// </remarks>
   TVector2 = record
      strict private function GetElement(Index: Integer): Single;
      strict private procedure WithElement(Index: Integer; const Value: Single);
      strict private const Count = 2;

		/// <summary>Cria um novo objeto <see cref="T:System.Numerics.Vector2" /> cujos dois elementos têm o mesmo valor.</summary>
		/// <param name="value">O valor a ser atribuído aos dois elementos.</param>
      public constructor Create(value: Single); overload;

		/// <summary>Cria um vetor cujos elementos têm os valores especificados.</summary>
		/// <param name="x">O valor a ser atribuído ao campo <see cref="F:System.Numerics.Vector2.X" />.</param>
		/// <param name="y">O valor a ser atribuído ao campo <see cref="F:System.Numerics.Vector2.Y" />.</param>
      public constructor Create(x, y: Single); overload;

      /// <summary>Constructs a vector from the given <see cref="ReadOnlySpan{Single}" />. The span must contain at least 2 elements.</summary>
      /// <param name="values">The span of elements to assign to the vector.</param>
      public constructor Create(const Values: array of Single); overload;

		/// <summary>Retorna um vetor cujos dois elementos são iguais a zero.</summary>
		/// <returns>Um vetor cujos dois elementos são iguais a zero (ou seja, retorna o vetor <c>(0, 0)</c>.</returns>
      public class function Zero: TVector2; static;

		/// <summary>Obtém um vetor cujos dois elementos são iguais a um.</summary>
		/// <returns>Um vetor cujos dois elementos são iguais a um (ou seja, retorna o vetor <c>(1, 1)</c>.</returns>
      public class function One: TVector2; static;

		/// <summary>Obtém o vetor (1,0).</summary>
		/// <returns>O vetor <c>(1, 0)</c>.</returns>
      public class function UnitX: TVector2; static;

      /// <summary>Gets the vector (0,1).</summary>
      /// <value>The vector <c>(0,1)</c>.</value>
      public class function UnitY: TVector2; static;

      /// <summary>Gets or sets the element at the specified index.</summary>
      /// <param name="index">The index of the element to get or set.</param>
      /// <returns>The the element at <paramref name="index" />.</returns>
      /// <exception cref="ArgumentOutOfRangeException"><paramref name="index" /> was less than zero or greater than the number of elements.</exception>
      public property Items[Index: Integer]: Single read GetElement write WithElement; default;

      /// <summary>Adds two vectors together.</summary>
      /// <param name="left">The first vector to add.</param>
      /// <param name="right">The second vector to add.</param>
      /// <returns>The summed vector.</returns>
      /// <remarks>The <see cref="op_Addition" /> method defines the addition operation for <see cref="Vector2" /> objects.</remarks>
      public class operator Add(const left, right: TVector2): TVector2;

      /// <summary>Divides the specified vector by a specified scalar value.</summary>
      /// <param name="value1">The vector.</param>
      /// <param name="value2">The scalar value.</param>
      /// <returns>The result of the division.</returns>
      /// <remarks>The <see cref="Vector2.op_Division" /> method defines the division operation for <see cref="Vector2" /> objects.</remarks>
      public class operator Divide(const left, right: TVector2): TVector2;

      /// <summary>Divides the first vector by the second.</summary>
      /// <param name="left">The first vector.</param>
      /// <param name="right">The second vector.</param>
      /// <returns>The vector that results from dividing <paramref name="left" /> by <paramref name="right" />.</returns>
      /// <remarks>The <see cref="Vector2.op_Division" /> method defines the division operation for <see cref="Vector2" /> objects.</remarks>
      public class operator Divide(const left: TVector2; const right: Single): TVector2;

      /// <summary>Returns a value that indicates whether each pair of elements in two specified vectors is equal.</summary>
      /// <param name="left">The first vector to compare.</param>
      /// <param name="right">The second vector to compare.</param>
      /// <returns><see langword="true" /> if <paramref name="left" /> and <paramref name="right" /> are equal; otherwise, <see langword="false" />.</returns>
      /// <remarks>Two <see cref="Vector2" /> objects are equal if each value in <paramref name="left" /> is equal to the corresponding value in <paramref name="right" />.</remarks>
      public class operator Equal(const left, right: TVector2): Boolean;

      /// <summary>Returns a value that indicates whether two specified vectors are not equal.</summary>
      /// <param name="left">The first vector to compare.</param>
      /// <param name="right">The second vector to compare.</param>
      /// <returns><see langword="true" /> if <paramref name="left" /> and <paramref name="right" /> are not equal; otherwise, <see langword="false" />.</returns>
      public class operator NotEqual(const left, right: TVector2): Boolean;

      /// <summary>Returns a new vector whose values are the product of each pair of elements in two specified vectors.</summary>
      /// <param name="left">The first vector.</param>
      /// <param name="right">The second vector.</param>
      /// <returns>The element-wise product vector.</returns>
      /// <remarks>The <see cref="Vector2.op_Multiply" /> method defines the multiplication operation for <see cref="Vector2" /> objects.</remarks>
      public class operator Multiply(const left, right: TVector2): TVector2;

      /// <summary>Multiplies the specified vector by the specified scalar value.</summary>
      /// <param name="left">The vector.</param>
      /// <param name="right">The scalar value.</param>
      /// <returns>The scaled vector.</returns>
      /// <remarks>The <see cref="Vector2.op_Multiply" /> method defines the multiplication operation for <see cref="Vector2" /> objects.</remarks>
      public class operator Multiply(const left: TVector2; const right: Single): TVector2;

      /// <summary>Multiplies the scalar value by the specified vector.</summary>
      /// <param name="left">The vector.</param>
      /// <param name="right">The scalar value.</param>
      /// <returns>The scaled vector.</returns>
      /// <remarks>The <see cref="Vector2.op_Multiply" /> method defines the multiplication operation for <see cref="Vector2" /> objects.</remarks>
      public class operator Multiply(const left: Single; const right: TVector2): TVector2;

      /// <summary>Subtracts the second vector from the first.</summary>
      /// <param name="left">The first vector.</param>
      /// <param name="right">The second vector.</param>
      /// <returns>The vector that results from subtracting <paramref name="right" /> from <paramref name="left" />.</returns>
      /// <remarks>The <see cref="op_Subtraction" /> method defines the subtraction operation for <see cref="Vector2" /> objects.</remarks>
      public class operator Subtract(const left, right: TVector2): TVector2;

      /// <summary>Negates the specified vector.</summary>
      /// <param name="value">The vector to negate.</param>
      /// <returns>The negated vector.</returns>
      /// <remarks>The <see cref="op_UnaryNegation" /> method defines the unary negation operation for <see cref="Vector2" /> objects.</remarks>
      public class operator Negative(const value: TVector2): TVector2;

      /// <summary>Returns a vector whose elements are the absolute values of each of the specified vector's elements.</summary>
      /// <param name="value">A vector.</param>
      /// <returns>The absolute value vector.</returns>
      public class function Abs(const value: TVector2): TVector2; static;

      /// <summary>Adds two vectors together.</summary>
      /// <param name="left">The first vector to add.</param>
      /// <param name="right">The second vector to add.</param>
      /// <returns>The summed vector.</returns>
      public class function Add(const left: TVector2; const right: TVector2): TVector2; static;

      /// <summary>Restricts a vector between a minimum and a maximum value.</summary>
      /// <param name="value1">The vector to restrict.</param>
      /// <param name="min">The minimum value.</param>
      /// <param name="max">The maximum value.</param>
      /// <returns>The restricted vector.</returns>
      public class function Clamp(const value1, Min, Max: TVector2): TVector2; static;

      /// <summary>Computes the Euclidean distance between the two given points.</summary>
      /// <param name="value1">The first point.</param>
      /// <param name="value2">The second point.</param>
      /// <returns>The distance.</returns>
      public class function Distance(const value1, value2: TVector2): Single; static;

      /// <summary>Returns the Euclidean distance squared between two specified points.</summary>
      /// <param name="value1">The first point.</param>
      /// <param name="value2">The second point.</param>
      /// <returns>The distance squared.</returns>
      public class function DistanceSquared(const Value1, Value2: TVector2): Single; static;

      /// <summary>Divides the first vector by the second.</summary>
      /// <param name="left">The first vector.</param>
      /// <param name="right">The second vector.</param>
      /// <returns>The vector resulting from the division.</returns>
      public class function Divide(const Left, Right: TVector2): TVector2; overload; static;

      /// <summary>Divides the specified vector by a specified scalar value.</summary>
      /// <param name="left">The vector.</param>
      /// <param name="divisor">The scalar value.</param>
      /// <returns>The vector that results from the division.</returns>
      public class function Divide(const Left: TVector2; const Divisor: Single): TVector2; overload; static;

      /// <summary>Returns the dot product of two vectors.</summary>
      /// <param name="value1">The first vector.</param>
      /// <param name="value2">The second vector.</param>
      /// <returns>The dot product.</returns>
      public class function Dot(const Value1, Value2: TVector2): Single; static;

      /// <summary>Performs a linear interpolation between two vectors based on the given weighting.</summary>
      /// <param name="value1">The first vector.</param>
      /// <param name="value2">The second vector.</param>
      /// <param name="amount">A value between 0 and 1 that indicates the weight of <paramref name="value2" />.</param>
      /// <returns>The interpolated vector.</returns>
      /// <remarks><format type="text/markdown"><![CDATA[
      /// The behavior of this method changed in .NET 5.0. For more information, see [Behavior change for Vector2.Lerp and Vector4.Lerp](/dotnet/core/compatibility/3.1-5.0#behavior-change-for-vector2lerp-and-vector4lerp).
      /// ]]></format></remarks>
      public class function Lerp(const Value1, Value2: TVector2; const Amount: Single): TVector2; static;

      /// <summary>Returns a vector whose elements are the maximum of each of the pairs of elements in two specified vectors.</summary>
      /// <param name="value1">The first vector.</param>
      /// <param name="value2">The second vector.</param>
      /// <returns>The maximized vector.</returns>
      public class function Max(const Value1, Value2: TVector2): TVector2; static;

      /// <summary>Returns a vector whose elements are the minimum of each of the pairs of elements in two specified vectors.</summary>
      /// <param name="value1">The first vector.</param>
      /// <param name="value2">The second vector.</param>
      /// <returns>The minimized vector.</returns>
      public class function Min(const Value1, Value2: TVector2): TVector2; static;

      /// <summary>Returns a new vector whose values are the product of each pair of elements in two specified vectors.</summary>
      /// <param name="left">The first vector.</param>
      /// <param name="right">The second vector.</param>
      /// <returns>The element-wise product vector.</returns>
      public class function Multiply(const Left, Right: TVector2): TVector2; overload; static;

      /// <summary>Multiplies a vector by a specified scalar.</summary>
      /// <param name="left">The vector to multiply.</param>
      /// <param name="right">The scalar value.</param>
      /// <returns>The scaled vector.</returns>
      public class function Multiply(const Left: TVector2; const Right: Single): TVector2; overload; static;

      /// <summary>Multiplies a scalar value by a specified vector.</summary>
      /// <param name="left">The scaled value.</param>
      /// <param name="right">The vector.</param>
      /// <returns>The scaled vector.</returns>
      public class function Multiply(const Left: Single; const Right: TVector2): TVector2; overload; static;

      /// <summary>Negates a specified vector.</summary>
      /// <param name="value">The vector to negate.</param>
      /// <returns>The negated vector.</returns>
      public class function Negate(const value: TVector2): TVector2; static;

      /// <summary>Returns a vector with the same direction as the specified vector, but with a length of one.</summary>
      /// <param name="value">The vector to normalize.</param>
      /// <returns>The normalized vector.</returns>
      public class function Normalize(const Value: TVector2): TVector2; static;

      /// <summary>Returns the reflection of a vector off a surface that has the specified normal.</summary>
      /// <param name="vector">The source vector.</param>
      /// <param name="normal">The normal of the surface being reflected off.</param>
      /// <returns>The reflected vector.</returns>
      public class function Reflect(const Vector, Normal: TVector2): TVector2; static;

      /// <summary>Returns a vector whose elements are the square root of each of a specified vector's elements.</summary>
      /// <param name="value">A vector.</param>
      /// <returns>The square root vector.</returns>
      public class function SquareRoot(const Value: TVector2): TVector2; static;

      /// <summary>Subtracts the second vector from the first.</summary>
      /// <param name="left">The first vector.</param>
      /// <param name="right">The second vector.</param>
      /// <returns>The difference vector.</returns>
      public class function Subtract(const Left, Right: TVector2): TVector2; static;

      /// <summary>Transforms a vector by a specified 3x2 matrix.</summary>
      /// <param name="position">The vector to transform.</param>
      /// <param name="matrix">The transformation matrix.</param>
      /// <returns>The transformed vector.</returns>
      public class function Transform(const Position: TVector2; const Matrix: TMatrix3x2): TVector2; overload; static;

      /// <summary>Transforms a vector by the specified Quaternion rotation value.</summary>
      /// <param name="value">The vector to rotate.</param>
      /// <param name="rotation">The rotation to apply.</param>
      /// <returns>The transformed vector.</returns>
      public class function Transform(const Value: TVector2; const Rotation: TQuaternion): TVector2; overload; static;

      /// <summary>Transforms a vector normal by the given 3x2 matrix.</summary>
      /// <param name="normal">The source vector.</param>
      /// <param name="matrix">The matrix.</param>
      /// <returns>The transformed vector.</returns>
      public class function TransformNormal(const normal: TVector2; const matrix: TMatrix3x2): TVector2; overload; static;

      /// <summary>Copies the elements of the vector to a specified array.</summary>
      /// <param name="array">The destination array.</param>
      /// <remarks><paramref name="array" /> must have at least two elements. The method copies the vector's elements starting at index 0.</remarks>
      /// <exception cref="NullReferenceException"><paramref name="array" /> is <see langword="null" />.</exception>
      /// <exception cref="ArgumentException">The number of elements in the current instance is greater than in the array.</exception>
      /// <exception cref="RankException"><paramref name="array" /> is multidimensional.</exception>
      public procedure CopyTo(var Arr: array of Single); overload;

      /// <summary>Copies the elements of the vector to a specified array starting at a specified index position.</summary>
      /// <param name="array">The destination array.</param>
      /// <param name="index">The index at which to copy the first element of the vector.</param>
      /// <remarks><paramref name="array" /> must have a sufficient number of elements to accommodate the two vector elements. In other words, elements <paramref name="index" /> and <paramref name="index" /> + 1 must already exist in <paramref name="array" />.</remarks>
      /// <exception cref="NullReferenceException"><paramref name="array" /> is <see langword="null" />.</exception>
      /// <exception cref="ArgumentException">The number of elements in the current instance is greater than in the array.</exception>
      /// <exception cref="ArgumentOutOfRangeException"><paramref name="index" /> is less than zero.
      /// -or-
      /// <paramref name="index" /> is greater than or equal to the array length.</exception>
      /// <exception cref="RankException"><paramref name="array" /> is multidimensional.</exception>
      public procedure CopyTo(var Arr: array of Single; Index: Integer); overload;

      /// <summary>Attempts to copy the vector to the given <see cref="Span{Single}" />. The length of the destination span must be at least 2.</summary>
      /// <param name="destination">The destination span which the values are copied into.</param>
      /// <returns><see langword="true" /> if the source vector was successfully copied to <paramref name="destination" />. <see langword="false" /> if <paramref name="destination" /> is not large enough to hold the source vector.</returns>
      public function TryCopyTo(var Arr: array of Single): Boolean; overload;

      /// <summary>Returns a value that indicates whether this instance and another vector are equal.</summary>
      /// <param name="other">The other vector.</param>
      /// <returns><see langword="true" /> if the two vectors are equal; otherwise, <see langword="false" />.</returns>
      /// <remarks>Two vectors are equal if their <see cref="X" /> and <see cref="Y" /> elements are equal.</remarks>
      public function Equals(const Other: TVector2): Boolean;

      /// <summary>Returns the length of the vector.</summary>
      /// <returns>The vector's length.</returns>
      /// <altmember cref="LengthSquared"/>
      public function Length: Single;

      /// <summary>Returns the length of the vector squared.</summary>
      /// <returns>The vector's length squared.</returns>
      /// <remarks>This operation offers better performance than a call to the <see cref="Length" /> method.</remarks>
      /// <altmember cref="Length"/>
      public function LengthSquared: Single;

      /// <summary>Returns the string representation of the current instance using default formatting.</summary>
      /// <returns>The string representation of the current instance.</returns>
      /// <remarks>This method returns a string in which each element of the vector is formatted using the "G" (general) format string and the formatting conventions of the current thread culture. The "&lt;" and "&gt;" characters are used to begin and end the string, and the current culture's <see cref="NumberFormatInfo.NumberGroupSeparator" /> property followed by a space is used to separate each element.</remarks>
      public function ToString: string; overload;

      /// <summary>Returns the string representation of the current instance using the specified format string to format individual elements.</summary>
      /// <param name="format">A standard or custom numeric format string that defines the format of individual elements.</param>
      /// <returns>The string representation of the current instance.</returns>
      /// <remarks>This method returns a string in which each element of the vector is formatted using <paramref name="format" /> and the current culture's formatting conventions. The "&lt;" and "&gt;" characters are used to begin and end the string, and the current culture's <see cref="NumberFormatInfo.NumberGroupSeparator" /> property followed by a space is used to separate each element.</remarks>
      /// <related type="Article" href="/dotnet/standard/base-types/standard-numeric-format-strings">Standard Numeric Format Strings</related>
      /// <related type="Article" href="/dotnet/standard/base-types/custom-numeric-format-strings">Custom Numeric Format Strings</related>
      public function ToString(const AFormat: string): string; overload;

      public function IsEmpty(): Boolean;

		/// <summary>O componente X do vetor.</summary>
      public X: Single;

		/// <summary>O componente Y do vetor.</summary>
      public Y: Single;
   end;
   PVector2 = ^TVector2;

{$ENDREGION 'TVector2'}

{$REGION 'TVector3'}

   { TVector3 }

   /// <summary>Represents a vector with three  single-precision floating-point values.</summary>
   /// <remarks><format type="text/markdown"><![CDATA[
   /// The <xref:System.Numerics.Vector3> structure provides support for hardware acceleration.
   /// [!INCLUDE[vectors-are-rows-paragraph](~/includes/system-numerics-vectors-are-rows.md)]
   /// ]]></format></remarks>
   TVector3 = record(*IEquatable<TVector3>, IFormattable*) (* partial *)

      /// <summary>The X component of the vector.</summary>
      public X: Single;

      /// <summary>The Y component of the vector.</summary>
      public Y: Single;

      /// <summary>The Z component of the vector.</summary>
      public Z: Single;

      public const Count: Integer = 3;
      strict private class function GetZero(): TVector3; static;

      /// <summary>Gets a vector whose 3 elements are equal to zero.</summary>
      /// <value>A vector whose three elements are equal to zero (that is, it returns the vector <c>(0,0,0)</c>.</value>
      public class property Zero: TVector3 read GetZero;

      strict private class function GetOne(): TVector3; static;

      /// <summary>Gets a vector whose 3 elements are equal to one.</summary>
      /// <value>A vector whose three elements are equal to one (that is, it returns the vector <c>(1,1,1)</c>.</value>
      public class property One: TVector3 read GetOne;
      strict private class function GetUnitX(): TVector3; static;

      /// <summary>Gets the vector (1,0,0).</summary>
      /// <value>The vector <c>(1,0,0)</c>.</value>
      public class property UnitX: TVector3 read GetUnitX;

      strict private class function GetUnitY(): TVector3; static;

      /// <summary>Gets the vector (0,1,0).</summary>
      /// <value>The vector <c>(0,1,0)</c>.</value>
      public class property UnitY: TVector3 read GetUnitY;

      strict private class function GetUnitZ(): TVector3; static;

      /// <summary>Gets the vector (0,0,1).</summary>
      /// <value>The vector <c>(0,0,1)</c>.</value>
      public class property UnitZ: TVector3 read GetUnitZ;

      /// <summary>Creates a new <see cref="Vector3" /> object whose three elements have the same value.</summary>
      /// <param name="value">The value to assign to all three elements.</param>
      public constructor Create(const value: Single); overload;

      /// <summary>Creates a   new <see cref="Vector3" /> object from the specified <see cref="Vector2" /> object and the specified value.</summary>
      /// <param name="value">The vector with two elements.</param>
      /// <param name="z">The additional value to assign to the <see cref="Z" /> field.</param>
      public constructor Create(const value: TVector2; const z: Single); overload;

      /// <summary>Creates a vector whose elements have the specified values.</summary>
      /// <param name="x">The value to assign to the <see cref="X" /> field.</param>
      /// <param name="y">The value to assign to the <see cref="Y" /> field.</param>
      /// <param name="z">The value to assign to the <see cref="Z" /> field.</param>
      public constructor Create(const x: Single; const y: Single; const z: Single); overload;

      /// <summary>Constructs a vector from the given <see cref="ReadOnlySpan{Single}" />. The span must contain at least 3 elements.</summary>
      /// <param name="values">The span of elements to assign to the vector.</param>
      public constructor Create(const values: TReadOnlySpan<Single>); overload;

      /// <summary>Returns a vector whose elements are the absolute values of each of the specified vector's elements.</summary>
      /// <param name="value">A vector.</param>
      /// <returns>The absolute value vector.</returns>
      public class function Abs(const value: TVector3): TVector3; static; inline;

      /// <summary>Adds two vectors together.</summary>
      /// <param name="left">The first vector to add.</param>
      /// <param name="right">The second vector to add.</param>
      /// <returns>The summed vector.</returns>
      public class function Add(const left: TVector3; const right: TVector3): TVector3; static; inline;

      /// <summary>Restricts a vector between a minimum and a maximum value.</summary>
      /// <param name="value1">The vector to restrict.</param>
      /// <param name="min">The minimum value.</param>
      /// <param name="max">The maximum value.</param>
      /// <returns>The restricted vector.</returns>
      public class function Clamp(const value1: TVector3; const min: TVector3; const max: TVector3): TVector3; static; inline;

      /// <summary>Computes the cross product of two vectors.</summary>
      /// <param name="vector1">The first vector.</param>
      /// <param name="vector2">The second vector.</param>
      /// <returns>The cross product.</returns>
      public class function Cross(const vector1: TVector3; const vector2: TVector3): TVector3; static; inline;

      /// <summary>Computes the Euclidean distance between the two given points.</summary>
      /// <param name="value1">The first point.</param>
      /// <param name="value2">The second point.</param>
      /// <returns>The distance.</returns>
      public class function Distance(const value1: TVector3; const value2: TVector3): Single; static; inline;

      /// <summary>Returns the Euclidean distance squared between two specified points.</summary>
      /// <param name="value1">The first point.</param>
      /// <param name="value2">The second point.</param>
      /// <returns>The distance squared.</returns>
      public class function DistanceSquared(const value1: TVector3; const value2: TVector3): Single; static; inline;

      /// <summary>Divides the first vector by the second.</summary>
      /// <param name="left">The first vector.</param>
      /// <param name="right">The second vector.</param>
      /// <returns>The vector resulting from the division.</returns>
      public class function Divide(const left: TVector3; const right: TVector3): TVector3; overload; static; inline;

      /// <summary>Divides the specified vector by a specified scalar value.</summary>
      /// <param name="left">The vector.</param>
      /// <param name="divisor">The scalar value.</param>
      /// <returns>The vector that results from the division.</returns>
      public class function Divide(const left: TVector3; const divisor: Single): TVector3; overload; static; inline;

      /// <summary>Returns the dot product of two vectors.</summary>
      /// <param name="vector1">The first vector.</param>
      /// <param name="vector2">The second vector.</param>
      /// <returns>The dot product.</returns>
      public class function Dot(const vector1: TVector3; const vector2: TVector3): Single; static; inline;

      /// <summary>Performs a linear interpolation between two vectors based on the given weighting.</summary>
      /// <param name="value1">The first vector.</param>
      /// <param name="value2">The second vector.</param>
      /// <param name="amount">A value between 0 and 1 that indicates the weight of <paramref name="value2" />.</param>
      /// <returns>The interpolated vector.</returns>
      public class function Lerp(const value1: TVector3; const value2: TVector3; const amount: Single): TVector3; static; inline;

      /// <summary>Returns a vector whose elements are the maximum of each of the pairs of elements in two specified vectors.</summary>
      /// <param name="value1">The first vector.</param>
      /// <param name="value2">The second vector.</param>
      /// <returns>The maximized vector.</returns>
      public class function Max(const value1: TVector3; const value2: TVector3): TVector3; static; inline;

      /// <summary>Returns a vector whose elements are the minimum of each of the pairs of elements in two specified vectors.</summary>
      /// <param name="value1">The first vector.</param>
      /// <param name="value2">The second vector.</param>
      /// <returns>The minimized vector.</returns>
      public class function Min(const value1: TVector3; const value2: TVector3): TVector3; static; inline;

      /// <summary>Returns a new vector whose values are the product of each pair of elements in two specified vectors.</summary>
      /// <param name="left">The first vector.</param>
      /// <param name="right">The second vector.</param>
      /// <returns>The element-wise product vector.</returns>
      public class function Multiply(const left: TVector3; const right: TVector3): TVector3; overload; static; inline;

      /// <summary>Multiplies a vector by a specified scalar.</summary>
      /// <param name="left">The vector to multiply.</param>
      /// <param name="right">The scalar value.</param>
      /// <returns>The scaled vector.</returns>
      public class function Multiply(const left: TVector3; const right: Single): TVector3; overload; static; inline;

      /// <summary>Multiplies a scalar value by a specified vector.</summary>
      /// <param name="left">The scaled value.</param>
      /// <param name="right">The vector.</param>
      /// <returns>The scaled vector.</returns>
      public class function Multiply(const left: Single; const right: TVector3): TVector3; overload; static; inline;

      /// <summary>Negates a specified vector.</summary>
      /// <param name="value">The vector to negate.</param>
      /// <returns>The negated vector.</returns>
      public class function Negate(const value: TVector3): TVector3; static; inline;

      /// <summary>Returns a vector with the same direction as the specified vector, but with a length of one.</summary>
      /// <param name="value">The vector to normalize.</param>
      /// <returns>The normalized vector.</returns>
      public class function Normalize(const value: TVector3): TVector3; static; inline;

      /// <summary>Returns the reflection of a vector off a surface that has the specified normal.</summary>
      /// <param name="vector">The source vector.</param>
      /// <param name="normal">The normal of the surface being reflected off.</param>
      /// <returns>The reflected vector.</returns>
      public class function Reflect(const vector: TVector3; const normal: TVector3): TVector3; static; inline;

      /// <summary>Returns a vector whose elements are the square root of each of a specified vector's elements.</summary>
      /// <param name="value">A vector.</param>
      /// <returns>The square root vector.</returns>
      public class function SquareRoot(const value: TVector3): TVector3; static; inline;

      /// <summary>Subtracts the second vector from the first.</summary>
      /// <param name="left">The first vector.</param>
      /// <param name="right">The second vector.</param>
      /// <returns>The difference vector.</returns>
      public class function Subtract(const left: TVector3; const right: TVector3): TVector3; static; inline;

      /// <summary>Transforms a vector by a specified 4x4 matrix.</summary>
      /// <param name="position">The vector to transform.</param>
      /// <param name="matrix">The transformation matrix.</param>
      /// <returns>The transformed vector.</returns>
      public class function Transform(const position: TVector3; const matrix: TMatrix4x4): TVector3; overload; static; inline;

      /// <summary>Transforms a vector by the specified Quaternion rotation value.</summary>
      /// <param name="value">The vector to rotate.</param>
      /// <param name="rotation">The rotation to apply.</param>
      /// <returns>The transformed vector.</returns>
      public class function Transform(const value: TVector3; const rotation: TQuaternion): TVector3; overload; static; inline;

      /// <summary>Transforms a vector normal by the given 4x4 matrix.</summary>
      /// <param name="normal">The source vector.</param>
      /// <param name="matrix">The matrix.</param>
      /// <returns>The transformed vector.</returns>
      public class function TransformNormal(const normal: TVector3; const matrix: TMatrix4x4): TVector3; overload; static; inline;


      /// <summary>Copies the elements of the vector to a specified array.</summary>
      /// <param name="array">The destination array.</param>
      /// <remarks><paramref name="array" /> must have at least three elements. The method copies the vector's elements starting at index 0.</remarks>
      /// <exception cref="NullReferenceException"><paramref name="array" /> is <see langword="null" />.</exception>
      /// <exception cref="ArgumentException">The number of elements in the current instance is greater than in the array.</exception>
      /// <exception cref="RankException"><paramref name="array" /> is multidimensional.</exception>
      public procedure CopyTo(var array_: TArray<Single>); overload; inline;

      /// <summary>Copies the elements of the vector to a specified array starting at a specified index position.</summary>
      /// <param name="array">The destination array.</param>
      /// <param name="index">The index at which to copy the first element of the vector.</param>
      /// <remarks><paramref name="array" /> must have a sufficient number of elements to accommodate the three vector elements. In other words, elements <paramref name="index" />, <paramref name="index" /> + 1, and <paramref name="index" /> + 2 must already exist in <paramref name="array" />.</remarks>
      /// <exception cref="NullReferenceException"><paramref name="array" /> is <see langword="null" />.</exception>
      /// <exception cref="ArgumentException">The number of elements in the current instance is greater than in the array.</exception>
      /// <exception cref="ArgumentOutOfRangeException"><paramref name="index" /> is less than zero.
      /// -or-
      /// <paramref name="index" /> is greater than or equal to the array length.</exception>
      /// <exception cref="RankException"><paramref name="array" /> is multidimensional.</exception>
      public procedure CopyTo(var array_: TArray<Single>; const index: Integer); overload; inline;

      /// <summary>Copies the vector to the given <see cref="Span{T}" />. The length of the destination span must be at least 3.</summary>
      /// <param name="destination">The destination span which the values are copied into.</param>
      /// <exception cref="ArgumentException">If number of elements in source vector is greater than those available in destination span.</exception>
      public procedure CopyTo(var destination: TSpan<Single>); overload; inline;

      /// <summary>Attempts to copy the vector to the given <see cref="Span{Single}" />. The length of the destination span must be at least 3.</summary>
      /// <param name="destination">The destination span which the values are copied into.</param>
      /// <returns><see langword="true" /> if the source vector was successfully copied to <paramref name="destination" />. <see langword="false" /> if <paramref name="destination" /> is not large enough to hold the source vector.</returns>
      public function TryCopyTo(var destination: TSpan<Single>): Boolean; inline;

      /// <summary>Returns a value that indicates whether this instance and another vector are equal.</summary>
      /// <param name="other">The other vector.</param>
      /// <returns><see langword="true" /> if the two vectors are equal; otherwise, <see langword="false" />.</returns>
      /// <remarks>Two vectors are equal if their <see cref="X" />, <see cref="Y" />, and <see cref="Z" /> elements are equal.</remarks>
      public function Equals(const other: TVector3): Boolean; overload; inline;

      /// <summary>Returns the length of this vector object.</summary>
      /// <returns>The vector's length.</returns>
      /// <altmember cref="LengthSquared"/>
      public function Length(): Single; inline;

      /// <summary>Returns the length of the vector squared.</summary>
      /// <returns>The vector's length squared.</returns>
      /// <remarks>This operation offers better performance than a call to the <see cref="Length" /> method.</remarks>
      /// <altmember cref="Length"/>
      public function LengthSquared(): Single; inline;

      /// <summary>Returns the string representation of the current instance using default formatting.</summary>
      /// <returns>The string representation of the current instance.</returns>
      /// <remarks>This method returns a string in which each element of the vector is formatted using the "G" (general) format string and the formatting conventions of the current thread culture. The "&lt;" and "&gt;" characters are used to begin and end the string, and the current culture's <see cref="NumberFormatInfo.NumberGroupSeparator" /> property followed by a space is used to separate each element.</remarks>
      public function ToString(): string; overload;

      /// <summary>Returns the string representation of the current instance using the specified format string to format individual elements.</summary>
      /// <param name="format">A standard or custom numeric format string that defines the format of individual elements.</param>
      /// <returns>The string representation of the current instance.</returns>
      /// <remarks>This method returns a string in which each element of the vector is formatted using <paramref name="format" /> and the current culture's formatting conventions. The "&lt;" and "&gt;" characters are used to begin and end the string, and the current culture's <see cref="NumberFormatInfo.NumberGroupSeparator" /> property followed by a space is used to separate each element.</remarks>
      /// <related type="Article" href="/dotnet/standard/base-types/standard-numeric-format-strings">Standard Numeric Format Strings</related>
      /// <related type="Article" href="/dotnet/standard/base-types/custom-numeric-format-strings">Custom Numeric Format Strings</related>
      public function ToString(const format: string): string; overload;

      /// <summary>Returns the string representation of the current instance using the specified format string to format individual elements and the specified format provider to define culture-specific formatting.</summary>
      /// <param name="format">A standard or custom numeric format string that defines the format of individual elements.</param>
      /// <param name="formatProvider">A format provider that supplies culture-specific formatting information.</param>
      /// <returns>The string representation of the current instance.</returns>
      /// <remarks>This method returns a string in which each element of the vector is formatted using <paramref name="format" /> and <paramref name="formatProvider" />. The "&lt;" and "&gt;" characters are used to begin and end the string, and the format provider's <see cref="NumberFormatInfo.NumberGroupSeparator" /> property followed by a space is used to separate each element.</remarks>
      /// <related type="Article" href="/dotnet/standard/base-types/standard-numeric-format-strings">Standard Numeric Format Strings</related>
      /// <related type="Article" href="/dotnet/standard/base-types/custom-numeric-format-strings">Custom Numeric Format Strings</related>
      public function ToString(const format: string; const formatProvider: TFormatSettings): string; overload;

      strict private function GetItem(const index: Integer ): Single; inline;
      strict private procedure SetItem(const index: Integer; const Value: Single); inline;

      /// <summary>Gets or sets the element at the specified index.</summary>
      /// <param name="index">The index of the element to get or set.</param>
      /// <returns>The the element at <paramref name="index" />.</returns>
      /// <exception cref="ArgumentOutOfRangeException"><paramref name="index" /> was less than zero or greater than the number of elements.</exception>
      public property Items[const index: Integer]: Single read GetItem write SetItem; default;

      /// <summary>Adds two vectors together.</summary>
      /// <param name="left">The first vector to add.</param>
      /// <param name="right">The second vector to add.</param>
      /// <returns>The summed vector.</returns>
      /// <remarks>The <see cref="op_Addition" /> method defines the addition operation for <see cref="Vector3" /> objects.</remarks>
      class operator Add(const left: TVector3; const right: TVector3): TVector3; inline;

      /// <summary>Divides the first vector by the second.</summary>
      /// <param name="left">The first vector.</param>
      /// <param name="right">The second vector.</param>
      /// <returns>The vector that results from dividing <paramref name="left" /> by <paramref name="right" />.</returns>
      /// <remarks>The <see cref="Vector3.op_Division" /> method defines the division operation for <see cref="Vector3" /> objects.</remarks>
      class operator Divide(const left: TVector3; const right: TVector3): TVector3; inline;

      /// <summary>Divides the specified vector by a specified scalar value.</summary>
      /// <param name="value1">The vector.</param>
      /// <param name="value2">The scalar value.</param>
      /// <returns>The result of the division.</returns>
      /// <remarks>The <see cref="Vector3.op_Division" /> method defines the division operation for <see cref="Vector3" /> objects.</remarks>
      class operator Divide(const value1: TVector3; const value2: Single): TVector3; inline;

      /// <summary>Returns a value that indicates whether each pair of elements in two specified vectors is equal.</summary>
      /// <param name="left">The first vector to compare.</param>
      /// <param name="right">The second vector to compare.</param>
      /// <returns><see langword="true" /> if <paramref name="left" /> and <paramref name="right" /> are equal; otherwise, <see langword="false" />.</returns>
      /// <remarks>Two <see cref="Vector3" /> objects are equal if each element in <paramref name="left" /> is equal to the corresponding element in <paramref name="right" />.</remarks>
      class operator Equal(const left: TVector3; const right: TVector3): Boolean; inline;

      /// <summary>Returns a value that indicates whether two specified vectors are not equal.</summary>
      /// <param name="left">The first vector to compare.</param>
      /// <param name="right">The second vector to compare.</param>
      /// <returns><see langword="true" /> if <paramref name="left" /> and <paramref name="right" /> are not equal; otherwise, <see langword="false" />.</returns>
      class operator NotEqual(const left: TVector3; const right: TVector3): Boolean; inline;

      /// <summary>Returns a new vector whose values are the product of each pair of elements in two specified vectors.</summary>
      /// <param name="left">The first vector.</param>
      /// <param name="right">The second vector.</param>
      /// <returns>The element-wise product vector.</returns>
      /// <remarks>The <see cref="Vector3.op_Multiply" /> method defines the multiplication operation for <see cref="Vector3" /> objects.</remarks>
      class operator Multiply(const left: TVector3; const right: TVector3): TVector3; inline;

      /// <summary>Multiplies the specified vector by the specified scalar value.</summary>
      /// <param name="left">The vector.</param>
      /// <param name="right">The scalar value.</param>
      /// <returns>The scaled vector.</returns>
      /// <remarks>The <see cref="Vector3.op_Multiply" /> method defines the multiplication operation for <see cref="Vector3" /> objects.</remarks>
      class operator Multiply(const left: TVector3; const right: Single): TVector3; inline;

      /// <summary>Multiplies the scalar value by the specified vector.</summary>
      /// <param name="left">The vector.</param>
      /// <param name="right">The scalar value.</param>
      /// <returns>The scaled vector.</returns>
      /// <remarks>The <see cref="Vector3.op_Multiply" /> method defines the multiplication operation for <see cref="Vector3" /> objects.</remarks>
      class operator Multiply(const left: Single; const right: TVector3): TVector3; inline;

      /// <summary>Subtracts the second vector from the first.</summary>
      /// <param name="left">The first vector.</param>
      /// <param name="right">The second vector.</param>
      /// <returns>The vector that results from subtracting <paramref name="right" /> from <paramref name="left" />.</returns>
      /// <remarks>The <see cref="op_Subtraction" /> method defines the subtraction operation for <see cref="Vector3" /> objects.</remarks>
      class operator Subtract(const left: TVector3; const right: TVector3): TVector3; inline;

      /// <summary>Negates the specified vector.</summary>
      /// <param name="value">The vector to negate.</param>
      /// <returns>The negated vector.</returns>
      /// <remarks>The <see cref="op_UnaryNegation" /> method defines the unary negation operation for <see cref="Vector3" /> objects.</remarks>
      class operator Negative(const value: TVector3): TVector3; inline;
   end;
   PVector3 = ^TVector3;
   PPVector3 = ^PVector3;

{$ENDREGION 'TVector3'}

{$REGION 'TVector4'}

   { TVector4 }


   /// <summary>Represents a vector with four single-precision floating-point values.</summary>
   /// <remarks><format type="text/markdown"><![CDATA[
   /// The <xref:System.Numerics.Vector4> structure provides support for hardware acceleration.
   /// [!INCLUDE[vectors-are-rows-paragraph](~/includes/system-numerics-vectors-are-rows.md)]
   /// ]]></format></remarks>

   TVector4 = record(*IEquatable<TVector4>, IFormattable*) (* partial *)

      /// <summary>The X component of the vector.</summary>
      public X: Single;


      /// <summary>The Y component of the vector.</summary>
      public Y: Single;


      /// <summary>The Z component of the vector.</summary>
      public Z: Single;


      /// <summary>The W component of the vector.</summary>
      public W: Single;

      public const Count: Integer = 4;
      strict private class function GetZero(): TVector4; static;


      /// <summary>Gets a vector whose 4 elements are equal to zero.</summary>
      /// <value>A vector whose four elements are equal to zero (that is, it returns the vector <c>(0,0,0,0)</c>.</value>
      public class property Zero: TVector4 read GetZero;
      strict private class function GetOne(): TVector4; static;


      /// <summary>Gets a vector whose 4 elements are equal to one.</summary>
      /// <value>Returns <see cref="Vector4" />.</value>
      /// <remarks>A vector whose four elements are equal to one (that is, it returns the vector <c>(1,1,1,1)</c>.</remarks>
      public class property One: TVector4 read GetOne;
      strict private class function GetUnitX(): TVector4; static;


      /// <summary>Gets the vector (1,0,0,0).</summary>
      /// <value>The vector <c>(1,0,0,0)</c>.</value>
      public class property UnitX: TVector4 read GetUnitX;
      strict private class function GetUnitY(): TVector4; static;


      /// <summary>Gets the vector (0,1,0,0).</summary>
      /// <value>The vector <c>(0,1,0,0)</c>.</value>
      public class property UnitY: TVector4 read GetUnitY;
      strict private class function GetUnitZ(): TVector4; static;


      /// <summary>Gets the vector (0,0,1,0).</summary>
      /// <value>The vector <c>(0,0,1,0)</c>.</value>
      public class property UnitZ: TVector4 read GetUnitZ;
      strict private class function GetUnitW(): TVector4; static;


      /// <summary>Gets the vector (0,0,0,1).</summary>
      /// <value>The vector <c>(0,0,0,1)</c>.</value>
      public class property UnitW: TVector4 read GetUnitW;


      /// <summary>Creates a new <see cref="Vector4" /> object whose four elements have the same value.</summary>
      /// <param name="value">The value to assign to all four elements.</param>
      public constructor Create(const value: Single); overload;

      /// <summary>Creates a   new <see cref="Vector4" /> object from the specified <see cref="Vector2" /> object and a Z and a W component.</summary>
      /// <param name="value">The vector to use for the X and Y components.</param>
      /// <param name="z">The Z component.</param>
      /// <param name="w">The W component.</param>
      public constructor Create(const value: TVector2; const z: Single; const w: Single); overload;

      /// <summary>Constructs a new <see cref="Vector4" /> object from the specified <see cref="Vector3" /> object and a W component.</summary>
      /// <param name="value">The vector to use for the X, Y, and Z components.</param>
      /// <param name="w">The W component.</param>
      public constructor Create(const value: TVector3; const w: Single); overload;

      /// <summary>Creates a vector whose elements have the specified values.</summary>
      /// <param name="x">The value to assign to the <see cref="X" /> field.</param>
      /// <param name="y">The value to assign to the <see cref="Y" /> field.</param>
      /// <param name="z">The value to assign to the <see cref="Z" /> field.</param>
      /// <param name="w">The value to assign to the <see cref="W" /> field.</param>
      public constructor Create(const x: Single; const y: Single; const z: Single; const w: Single); overload;

      /// <summary>Constructs a vector from the given <see cref="ReadOnlySpan{Single}" />. The span must contain at least 4 elements.</summary>
      /// <param name="values">The span of elements to assign to the vector.</param>
      public constructor Create(const values: TReadOnlySpan<Single>); overload;

      /// <summary>Returns a vector whose elements are the absolute values of each of the specified vector's elements.</summary>
      /// <param name="value">A vector.</param>
      /// <returns>The absolute value vector.</returns>
      public class function Abs(const value: TVector4): TVector4; static; inline;

      /// <summary>Adds two vectors together.</summary>
      /// <param name="left">The first vector to add.</param>
      /// <param name="right">The second vector to add.</param>
      /// <returns>The summed vector.</returns>
      public class function Add(const left: TVector4; const right: TVector4): TVector4; static; inline;

      /// <summary>Restricts a vector between a minimum and a maximum value.</summary>
      /// <param name="value1">The vector to restrict.</param>
      /// <param name="min">The minimum value.</param>
      /// <param name="max">The maximum value.</param>
      /// <returns>The restricted vector.</returns>
      public class function Clamp(const value1: TVector4; const min: TVector4; const max: TVector4): TVector4; static; inline;

      /// <summary>Computes the Euclidean distance between the two given points.</summary>
      /// <param name="value1">The first point.</param>
      /// <param name="value2">The second point.</param>
      /// <returns>The distance.</returns>
      public class function Distance(const value1: TVector4; const value2: TVector4): Single; static; inline;

      /// <summary>Returns the Euclidean distance squared between two specified points.</summary>
      /// <param name="value1">The first point.</param>
      /// <param name="value2">The second point.</param>
      /// <returns>The distance squared.</returns>
      public class function DistanceSquared(const value1: TVector4; const value2: TVector4): Single; static; inline;

      /// <summary>Divides the first vector by the second.</summary>
      /// <param name="left">The first vector.</param>
      /// <param name="right">The second vector.</param>
      /// <returns>The vector resulting from the division.</returns>
      public class function Divide(const left: TVector4; const right: TVector4): TVector4; overload; static; inline;

      /// <summary>Divides the specified vector by a specified scalar value.</summary>
      /// <param name="left">The vector.</param>
      /// <param name="divisor">The scalar value.</param>
      /// <returns>The vector that results from the division.</returns>
      public class function Divide(const left: TVector4; const divisor: Single): TVector4; overload; static; inline;

      /// <summary>Returns the dot product of two vectors.</summary>
      /// <param name="vector1">The first vector.</param>
      /// <param name="vector2">The second vector.</param>
      /// <returns>The dot product.</returns>
      public class function Dot(const vector1: TVector4; const vector2: TVector4): Single; static; inline;

      /// <summary>Performs a linear interpolation between two vectors based on the given weighting.</summary>
      /// <param name="value1">The first vector.</param>
      /// <param name="value2">The second vector.</param>
      /// <param name="amount">A value between 0 and 1 that indicates the weight of <paramref name="value2" />.</param>
      /// <returns>The interpolated vector.</returns>
      /// <remarks><format type="text/markdown"><![CDATA[
      /// The behavior of this method changed in .NET 5.0. For more information, see [Behavior change for Vector2.Lerp and Vector4.Lerp](/dotnet/core/compatibility/3.1-5.0#behavior-change-for-vector2lerp-and-vector4lerp).
      /// ]]></format></remarks>
      public class function Lerp(const value1: TVector4; const value2: TVector4; const amount: Single): TVector4; static; inline;

      /// <summary>Returns a vector whose elements are the maximum of each of the pairs of elements in two specified vectors.</summary>
      /// <param name="value1">The first vector.</param>
      /// <param name="value2">The second vector.</param>
      /// <returns>The maximized vector.</returns>
      public class function Max(const value1: TVector4; const value2: TVector4): TVector4; static; inline;

      /// <summary>Returns a vector whose elements are the minimum of each of the pairs of elements in two specified vectors.</summary>
      /// <param name="value1">The first vector.</param>
      /// <param name="value2">The second vector.</param>
      /// <returns>The minimized vector.</returns>
      public class function Min(const value1: TVector4; const value2: TVector4): TVector4; static; inline;

      /// <summary>Returns a new vector whose values are the product of each pair of elements in two specified vectors.</summary>
      /// <param name="left">The first vector.</param>
      /// <param name="right">The second vector.</param>
      /// <returns>The element-wise product vector.</returns>
      public class function Multiply(const left: TVector4; const right: TVector4): TVector4; overload; static; inline;

      /// <summary>Multiplies a vector by a specified scalar.</summary>
      /// <param name="left">The vector to multiply.</param>
      /// <param name="right">The scalar value.</param>
      /// <returns>The scaled vector.</returns>
      public class function Multiply(const left: TVector4; const right: Single): TVector4; overload; static; inline;

      /// <summary>Multiplies a scalar value by a specified vector.</summary>
      /// <param name="left">The scaled value.</param>
      /// <param name="right">The vector.</param>
      /// <returns>The scaled vector.</returns>
      public class function Multiply(const left: Single; const right: TVector4): TVector4; overload; static; inline;

      /// <summary>Negates a specified vector.</summary>
      /// <param name="value">The vector to negate.</param>
      /// <returns>The negated vector.</returns>
      public class function Negate(const value: TVector4): TVector4; static; inline;

      /// <summary>Returns a vector with the same direction as the specified vector, but with a length of one.</summary>
      /// <param name="vector">The vector to normalize.</param>
      /// <returns>The normalized vector.</returns>
      public class function Normalize(const vector: TVector4): TVector4; static; inline;

      /// <summary>Returns a vector whose elements are the square root of each of a specified vector's elements.</summary>
      /// <param name="value">A vector.</param>
      /// <returns>The square root vector.</returns>
      public class function SquareRoot(const value: TVector4): TVector4; static; inline;

      /// <summary>Subtracts the second vector from the first.</summary>
      /// <param name="left">The first vector.</param>
      /// <param name="right">The second vector.</param>
      /// <returns>The difference vector.</returns>
      public class function Subtract(const left: TVector4; const right: TVector4): TVector4; static; inline;

      /// <summary>Transforms a two-dimensional vector by a specified 4x4 matrix.</summary>
      /// <param name="position">The vector to transform.</param>
      /// <param name="matrix">The transformation matrix.</param>
      /// <returns>The transformed vector.</returns>
      public class function Transform(const position: TVector2; const matrix: TMatrix4x4): TVector4; overload; static; //inline;

      /// <summary>Transforms a two-dimensional vector by the specified Quaternion rotation value.</summary>
      /// <param name="value">The vector to rotate.</param>
      /// <param name="rotation">The rotation to apply.</param>
      /// <returns>The transformed vector.</returns>
      public class function Transform(const value: TVector2; const rotation: TQuaternion): TVector4; overload; static; inline;

      /// <summary>Transforms a three-dimensional vector by a specified 4x4 matrix.</summary>
      /// <param name="position">The vector to transform.</param>
      /// <param name="matrix">The transformation matrix.</param>
      /// <returns>The transformed vector.</returns>
      public class function Transform(const position: TVector3; const matrix: TMatrix4x4): TVector4; overload; static; inline;

      /// <summary>Transforms a three-dimensional vector by the specified Quaternion rotation value.</summary>
      /// <param name="value">The vector to rotate.</param>
      /// <param name="rotation">The rotation to apply.</param>
      /// <returns>The transformed vector.</returns>
      public class function Transform(const value: TVector3; const rotation: TQuaternion): TVector4; overload; static; inline;

      /// <summary>Transforms a four-dimensional vector by a specified 4x4 matrix.</summary>
      /// <param name="vector">The vector to transform.</param>
      /// <param name="matrix">The transformation matrix.</param>
      /// <returns>The transformed vector.</returns>
      public class function Transform(const vector: TVector4; const matrix: TMatrix4x4): TVector4; overload; static; inline;

      /// <summary>Transforms a four-dimensional vector by the specified Quaternion rotation value.</summary>
      /// <param name="value">The vector to rotate.</param>
      /// <param name="rotation">The rotation to apply.</param>
      /// <returns>The transformed vector.</returns>
      public class function Transform(const value: TVector4; const rotation: TQuaternion): TVector4; overload; static; inline;

      /// <summary>Copies the elements of the vector to a specified array.</summary>
      /// <param name="array">The destination array.</param>
      /// <remarks><paramref name="array" /> must have at least four elements. The method copies the vector's elements starting at index 0.</remarks>
      /// <exception cref="NullReferenceException"><paramref name="array" /> is <see langword="null" />.</exception>
      /// <exception cref="ArgumentException">The number of elements in the current instance is greater than in the array.</exception>
      /// <exception cref="RankException"><paramref name="array" /> is multidimensional.</exception>
      public procedure CopyTo(const array_: TArray<Single>); overload; inline;

      /// <summary>Copies the elements of the vector to a specified array starting at a specified index position.</summary>
      /// <param name="array">The destination array.</param>
      /// <param name="index">The index at which to copy the first element of the vector.</param>
      /// <remarks><paramref name="array" /> must have a sufficient number of elements to accommodate the four vector elements. In other words, elements <paramref name="index" /> through <paramref name="index" /> + 3 must already exist in <paramref name="array" />.</remarks>
      /// <exception cref="NullReferenceException"><paramref name="array" /> is <see langword="null" />.</exception>
      /// <exception cref="ArgumentException">The number of elements in the current instance is greater than in the array.</exception>
      /// <exception cref="ArgumentOutOfRangeException"><paramref name="index" /> is less than zero.
      /// -or-
      /// <paramref name="index" /> is greater than or equal to the array length.</exception>
      /// <exception cref="RankException"><paramref name="array" /> is multidimensional.</exception>
      public procedure CopyTo(const array_: TArray<Single>; const index: Integer); overload; inline;

      /// <summary>Copies the vector to the given <see cref="Span{T}" />. The length of the destination span must be at least 4.</summary>
      /// <param name="destination">The destination span which the values are copied into.</param>
      /// <exception cref="ArgumentException">If number of elements in source vector is greater than those available in destination span.</exception>
      public procedure CopyTo(const destination: TSpan<Single>); overload; inline;

      /// <summary>Attempts to copy the vector to the given <see cref="Span{Single}" />. The length of the destination span must be at least 4.</summary>
      /// <param name="destination">The destination span which the values are copied into.</param>
      /// <returns><see langword="true" /> if the source vector was successfully copied to <paramref name="destination" />. <see langword="false" /> if <paramref name="destination" /> is not large enough to hold the source vector.</returns>
      public function TryCopyTo(const destination: TSpan<Single>): Boolean; inline;

      /// <summary>Returns a value that indicates whether this instance and another vector are equal.</summary>
      /// <param name="other">The other vector.</param>
      /// <returns><see langword="true" /> if the two vectors are equal; otherwise, <see langword="false" />.</returns>
      /// <remarks>Two vectors are equal if their <see cref="X" />, <see cref="Y" />, <see cref="Z" />, and <see cref="W" /> elements are equal.</remarks>
      public function Equals(const other: TVector4): Boolean; overload; inline;

      /// <summary>Returns the length of this vector object.</summary>
      /// <returns>The vector's length.</returns>
      /// <altmember cref="LengthSquared"/>
      public function Length(): Single; inline;

      /// <summary>Returns the length of the vector squared.</summary>
      /// <returns>The vector's length squared.</returns>
      /// <remarks>This operation offers better performance than a call to the <see cref="Length" /> method.</remarks>
      /// <altmember cref="Length"/>
      public function LengthSquared(): Single; inline;

      /// <summary>Returns the string representation of the current instance using default formatting.</summary>
      /// <returns>The string representation of the current instance.</returns>
      /// <remarks>This method returns a string in which each element of the vector is formatted using the "G" (general) format string and the formatting conventions of the current thread culture. The "&lt;" and "&gt;" characters are used to begin and end the string, and the current culture's <see cref="NumberFormatInfo.NumberGroupSeparator" /> property followed by a space is used to separate each element.</remarks>
      public function ToString(): string; overload;

      /// <summary>Returns the string representation of the current instance using the specified format string to format individual elements.</summary>
      /// <param name="format">A standard or custom numeric format string that defines the format of individual elements.</param>
      /// <returns>The string representation of the current instance.</returns>
      /// <remarks>This method returns a string in which each element of the vector is formatted using <paramref name="format" /> and the current culture's formatting conventions. The "&lt;" and "&gt;" characters are used to begin and end the string, and the current culture's <see cref="NumberFormatInfo.NumberGroupSeparator" /> property followed by a space is used to separate each element.</remarks>
      /// <related type="Article" href="/dotnet/standard/base-types/standard-numeric-format-strings">Standard Numeric Format Strings</related>
      /// <related type="Article" href="/dotnet/standard/base-types/custom-numeric-format-strings">Custom Numeric Format Strings</related>
      public function ToString(const format: string): string; overload;

      /// <summary>Returns the string representation of the current instance using the specified format string to format individual elements and the specified format provider to define culture-specific formatting.</summary>
      /// <param name="format">A standard or custom numeric format string that defines the format of individual elements.</param>
      /// <param name="formatProvider">A format provider that supplies culture-specific formatting information.</param>
      /// <returns>The string representation of the current instance.</returns>
      /// <remarks>This method returns a string in which each element of the vector is formatted using <paramref name="format" /> and <paramref name="formatProvider" />. The "&lt;" and "&gt;" characters are used to begin and end the string, and the format provider's <see cref="NumberFormatInfo.NumberGroupSeparator" /> property followed by a space is used to separate each element.</remarks>
      /// <related type="Article" href="/dotnet/standard/base-types/standard-numeric-format-strings">Standard Numeric Format Strings</related>
      /// <related type="Article" href="/dotnet/standard/base-types/custom-numeric-format-strings">Custom Numeric Format Strings</related>
      public function ToString(const format: string; const formatProvider: TFormatSettings): string; overload;

      strict private function GetItem(const index: Integer): Single; inline;
      strict private procedure SetItem(const index: Integer; const Value: Single); inline;

      /// <summary>Gets or sets the element at the specified index.</summary>
      /// <param name="index">The index of the element to get or set.</param>
      /// <returns>The the element at <paramref name="index" />.</returns>
      /// <exception cref="ArgumentOutOfRangeException"><paramref name="index" /> was less than zero or greater than the number of elements.</exception>
      public property Items[const index: Integer]: Single read GetItem write SetItem; default;

      /// <summary>Adds two vectors together.</summary>
      /// <param name="left">The first vector to add.</param>
      /// <param name="right">The second vector to add.</param>
      /// <returns>The summed vector.</returns>
      /// <remarks>The <see cref="op_Addition" /> method defines the addition operation for <see cref="Vector4" /> objects.</remarks>

      class operator Add(const left: TVector4; const right: TVector4): TVector4; inline;

      /// <summary>Divides the first vector by the second.</summary>
      /// <param name="left">The first vector.</param>
      /// <param name="right">The second vector.</param>
      /// <returns>The vector that results from dividing <paramref name="left" /> by <paramref name="right" />.</returns>
      /// <remarks>The <see cref="Vector4.op_Division" /> method defines the division operation for <see cref="Vector4" /> objects.</remarks>
      class operator Divide(const left: TVector4; const right: TVector4): TVector4; inline;

      /// <summary>Divides the specified vector by a specified scalar value.</summary>
      /// <param name="value1">The vector.</param>
      /// <param name="value2">The scalar value.</param>
      /// <returns>The result of the division.</returns>
      /// <remarks>The <see cref="Vector4.op_Division" /> method defines the division operation for <see cref="Vector4" /> objects.</remarks>

      class operator Divide(const value1: TVector4; const value2: Single): TVector4; inline;

      /// <summary>Returns a value that indicates whether each pair of elements in two specified vectors is equal.</summary>
      /// <param name="left">The first vector to compare.</param>
      /// <param name="right">The second vector to compare.</param>
      /// <returns><see langword="true" /> if <paramref name="left" /> and <paramref name="right" /> are equal; otherwise, <see langword="false" />.</returns>
      /// <remarks>Two <see cref="Vector4" /> objects are equal if each element in <paramref name="left" /> is equal to the corresponding element in <paramref name="right" />.</remarks>
      class operator Equal(const left: TVector4; const right: TVector4): Boolean; inline;

      /// <summary>Returns a value that indicates whether two specified vectors are not equal.</summary>
      /// <param name="left">The first vector to compare.</param>
      /// <param name="right">The second vector to compare.</param>
      /// <returns><see langword="true" /> if <paramref name="left" /> and <paramref name="right" /> are not equal; otherwise, <see langword="false" />.</returns>

      class operator NotEqual(const left: TVector4; const right: TVector4): Boolean; inline;
      /// <summary>Returns a new vector whose values are the product of each pair of elements in two specified vectors.</summary>
      /// <param name="left">The first vector.</param>
      /// <param name="right">The second vector.</param>
      /// <returns>The element-wise product vector.</returns>
      /// <remarks>The <see cref="Vector4.op_Multiply" /> method defines the multiplication operation for <see cref="Vector4" /> objects.</remarks>

      class operator Multiply(const left: TVector4; const right: TVector4): TVector4; inline;

      /// <summary>Multiplies the specified vector by the specified scalar value.</summary>
      /// <param name="left">The vector.</param>
      /// <param name="right">The scalar value.</param>
      /// <returns>The scaled vector.</returns>
      /// <remarks>The <see cref="Vector4.op_Multiply" /> method defines the multiplication operation for <see cref="Vector4" /> objects.</remarks>
      class operator Multiply(const left: TVector4; const right: Single): TVector4; inline;

      /// <summary>Multiplies the scalar value by the specified vector.</summary>
      /// <param name="left">The vector.</param>
      /// <param name="right">The scalar value.</param>
      /// <returns>The scaled vector.</returns>
      /// <remarks>The <see cref="Vector4.op_Multiply" /> method defines the multiplication operation for <see cref="Vector4" /> objects.</remarks>
      class operator Multiply(const left: Single; const right: TVector4): TVector4; inline;

      /// <summary>Subtracts the second vector from the first.</summary>
      /// <param name="left">The first vector.</param>
      /// <param name="right">The second vector.</param>
      /// <returns>The vector that results from subtracting <paramref name="right" /> from <paramref name="left" />.</returns>
      /// <remarks>The <see cref="op_Subtraction" /> method defines the subtraction operation for <see cref="Vector4" /> objects.</remarks>
      class operator Subtract(const left: TVector4; const right: TVector4): TVector4; inline;

      /// <summary>Negates the specified vector.</summary>
      /// <param name="value">The vector to negate.</param>
      /// <returns>The negated vector.</returns>
      /// <remarks>The <see cref="op_UnaryNegation" /> method defines the unary negation operation for <see cref="Vector4" /> objects.</remarks>
      class operator Negative(const value: TVector4): TVector4; inline;
   end;
   PVector4 = ^TVector4;

{$ENDREGION 'TVector4'}

{$REGION 'TPlane'}

   { TPlane }


   /// <summary>Represents a plane in three-dimensional space.</summary>
   /// <remarks><format type="text/markdown"><![CDATA[
   /// [!INCLUDE[vectors-are-rows-paragraph](~/includes/system-numerics-vectors-are-rows.md)]
   /// ]]></format></remarks>
   TPlane = record(*IEquatable<TPlane>*)
       strict private const NormalizeEpsilon: Single = Single(1.192092896e-07);

      /// <summary>The normal vector of the plane.</summary>
      public Normal: TVector3;

      /// <summary>The distance of the plane along its normal from the origin.</summary>
      public D: Single;

      /// <summary>Creates a <see cref="Plane" /> object from the X, Y, and Z components of its normal, and its distance from the origin on that normal.</summary>
      /// <param name="x">The X component of the normal.</param>
      /// <param name="y">The Y component of the normal.</param>
      /// <param name="z">The Z component of the normal.</param>
      /// <param name="d">The distance of the plane along its normal from the origin.</param>
      public constructor Create(const x: Single; const y: Single; const z: Single; const d: Single); overload;

      /// <summary>Creates a <see cref="Plane" /> object from a specified normal and the distance along the normal from the origin.</summary>
      /// <param name="normal">The plane's normal vector.</param>
      /// <param name="d">The plane's distance from the origin along its normal vector.</param>
      public constructor Create(const normal: TVector3; const d: Single); overload;

      /// <summary>Creates a <see cref="Plane" /> object from a specified four-dimensional vector.</summary>
      /// <param name="value">A vector whose first three elements describe the normal vector, and whose <see cref="Vector4.W" /> defines the distance along that normal from the origin.</param>
      public constructor Create(const value: TVector4); overload;

      /// <summary>Creates a <see cref="Plane" /> object that contains three specified points.</summary>
      /// <param name="point1">The first point defining the plane.</param>
      /// <param name="point2">The second point defining the plane.</param>
      /// <param name="point3">The third point defining the plane.</param>
      /// <returns>The plane containing the three points.</returns>

      public class function CreateFromVertices(const point1: TVector3; const point2: TVector3; const point3: TVector3): TPlane; static; inline;

      /// <summary>Calculates the dot product of a plane and a 4-dimensional vector.</summary>
      /// <param name="plane">The plane.</param>
      /// <param name="value">The four-dimensional vector.</param>
      /// <returns>The dot product.</returns>
      public class function Dot(const plane: TPlane; const value: TVector4): Single; static; inline;

      /// <summary>Returns the dot product of a specified three-dimensional vector and the normal vector of this plane plus the distance (<see cref="D" />) value of the plane.</summary>
      /// <param name="plane">The plane.</param>
      /// <param name="value">The 3-dimensional vector.</param>
      /// <returns>The dot product.</returns>
      public class function DotCoordinate(const plane: TPlane; const value: TVector3): Single; static; inline;

      /// <summary>Returns the dot product of a specified three-dimensional vector and the <see cref="Normal" /> vector of this plane.</summary>
      /// <param name="plane">The plane.</param>
      /// <param name="value">The three-dimensional vector.</param>
      /// <returns>The dot product.</returns>
      public class function DotNormal(const plane: TPlane; const value: TVector3): Single; static; inline;

      /// <summary>Creates a new <see cref="Plane" /> object whose normal vector is the source plane's normal vector normalized.</summary>
      /// <param name="value">The source plane.</param>
      /// <returns>The normalized plane.</returns>
      public class function Normalize(const value: TPlane): TPlane; static; inline;

      /// <summary>Transforms a normalized plane by a 4x4 matrix.</summary>
      /// <param name="plane">The normalized plane to transform.</param>
      /// <param name="matrix">The transformation matrix to apply to <paramref name="plane" />.</param>
      /// <returns>The transformed plane.</returns>
      /// <remarks><paramref name="plane" /> must already be normalized so that its <see cref="Normal" /> vector is of unit length before this method is called.</remarks>

      public class function Transform(const plane: TPlane; const matrix: TMatrix4x4): TPlane; overload; static; inline;

      /// <summary>Transforms a normalized plane by a Quaternion rotation.</summary>
      /// <param name="plane">The normalized plane to transform.</param>
      /// <param name="rotation">The Quaternion rotation to apply to the plane.</param>
      /// <returns>A new plane that results from applying the Quaternion rotation.</returns>
      /// <remarks><paramref name="plane" /> must already be normalized so that its <see cref="Normal" /> vector is of unit length before this method is called.</remarks>
      public class function Transform(const plane: TPlane; const rotation: TQuaternion): TPlane; overload; static; inline;

      /// <summary>Returns a value that indicates whether this instance and another plane object are equal.</summary>
      /// <param name="other">The other plane.</param>
      /// <returns><see langword="true" /> if the two planes are equal; otherwise, <see langword="false" />.</returns>
      /// <remarks>Two <see cref="Plane" /> objects are equal if their <see cref="Normal" /> and <see cref="D" /> fields are equal.</remarks>
      public function Equals(const other: TPlane): Boolean; overload; inline;

      /// <summary>Returns the string representation of this plane object.</summary>
      /// <returns>A string that represents this <see cref="Plane" /> object.</returns>
      /// <remarks>The string representation of a <see cref="Plane" /> object use the formatting conventions of the current culture to format the numeric values in the returned string. For example, a <see cref="Plane" /> object whose string representation is formatted by using the conventions of the en-US culture might appear as <c>{Normal:&lt;1.1, 2.2, 3.3&gt; D:4.4}</c>.</remarks>
      public function ToString(): string;

      /// <summary>Returns a value that indicates whether two planes are equal.</summary>
      /// <param name="value1">The first plane to compare.</param>
      /// <param name="value2">The second plane to compare.</param>
      /// <returns><see langword="true" /> if <paramref name="value1" /> and <paramref name="value2" /> are equal; otherwise, <see langword="false" />.</returns>
      /// <remarks>Two <see cref="Plane" /> objects are equal if their <see cref="Normal" /> and <see cref="D" /> fields are equal.
      /// The <see cref="op_Equality" /> method defines the operation of the equality operator for <see cref="Plane" /> objects.</remarks>
      class operator Equal(const value1: TPlane; const value2: TPlane): Boolean; inline;

      /// <summary>Returns a value that indicates whether two planes are not equal.</summary>
      /// <param name="value1">The first plane to compare.</param>
      /// <param name="value2">The second plane to compare.</param>
      /// <returns><see langword="true" /> if <paramref name="value1" /> and <paramref name="value2" /> are not equal; otherwise, <see langword="false" />.</returns>
      /// <remarks>The <see cref="op_Inequality" /> method defines the operation of the inequality operator for <see cref="Plane" /> objects.</remarks>
      class operator NotEqual(const value1: TPlane; const value2: TPlane): Boolean; inline;
   end;

{$ENDREGION 'TPlane'}

{$REGION 'TMatrix3x2Helper'}

   { TMatrix3x2Helper }

   TMatrix3x2Helper = record helper for TMatrix3x2
      strict private function GetTranslation(): TVector2; inline;
      strict private procedure SetTranslation(const Value: TVector2); inline;

      /// <summary>Gets or sets the translation component of this matrix.</summary>
      /// <value>The translation component of the current instance.</value>
      public property Translation: TVector2 read GetTranslation write SetTranslation;

      /// <summary>Creates a rotation matrix using the specified rotation in radians and a center point.</summary>
      /// <param name="radians">The amount of rotation, in radians.</param>
      /// <param name="centerPoint">The center point.</param>
      /// <returns>The rotation matrix.</returns>
      public class function CreateRotation(const radians: Single; const centerPoint: TVector2): TMatrix3x2; overload; static;

      /// <summary>Creates a scaling matrix from the specified vector scale.</summary>
      /// <param name="scales">The scale to use.</param>
      /// <returns>The scaling matrix.</returns>
      public class function CreateScale(const scales: TVector2): TMatrix3x2; overload; static;

      /// <summary>Creates a scaling matrix that is offset by a given center point.</summary>
      /// <param name="xScale">The value to scale by on the X axis.</param>
      /// <param name="yScale">The value to scale by on the Y axis.</param>
      /// <param name="centerPoint">The center point.</param>
      /// <returns>The scaling matrix.</returns>
      public class function CreateScale(const xScale: Single; const yScale: Single; const centerPoint: TVector2): TMatrix3x2; overload; static;

      /// <summary>Creates a scaling matrix from the specified vector scale with an offset from the specified center point.</summary>
      /// <param name="scales">The scale to use.</param>
      /// <param name="centerPoint">The center offset.</param>
      /// <returns>The scaling matrix.</returns>
      public class function CreateScale(const scales: TVector2; const centerPoint: TVector2): TMatrix3x2; overload; static;

      /// <summary>Creates a scaling matrix that scales uniformly with the specified scale with an offset from the specified center.</summary>
      /// <param name="scale">The uniform scale to use.</param>
      /// <param name="centerPoint">The center offset.</param>
      /// <returns>The scaling matrix.</returns>
      public class function CreateScale(const scale: Single; const centerPoint: TVector2): TMatrix3x2; overload; static;

      /// <summary>Creates a skew matrix from the specified angles in radians and a center point.</summary>
      /// <param name="radiansX">The X angle, in radians.</param>
      /// <param name="radiansY">The Y angle, in radians.</param>
      /// <param name="centerPoint">The center point.</param>
      /// <returns>The skew matrix.</returns>
      public class function CreateSkew(const radiansX: Single; const radiansY: Single; const centerPoint: TVector2): TMatrix3x2; overload; static;

      /// <summary>Creates a translation matrix from the specified 2-dimensional vector.</summary>
      /// <param name="position">The translation position.</param>
      /// <returns>The translation matrix.</returns>
      public class function CreateTranslation(const position: TVector2): TMatrix3x2; overload; static;

      public procedure Translate(const offset: TVector2);

      public type

            { TImpl }

            PImpl = ^TImpl;
            TImpl = record(*IEquatable<TImpl>*)

               strict private const RotationEpsilon: Single = 0.001 * TMathF.PI / 180;

               public X: TVector2;
               public Y: TVector2;
               public Z: TVector2;
               strict private class function GetIdentity(): TImpl; static; inline;

               public class property Identity: TImpl read GetIdentity;
               strict private function GetIsIdentity(): Boolean; inline;

               public property IsIdentity: Boolean read GetIsIdentity;
               strict private function GetTranslation(): TVector2; inline;
               strict private procedure SetTranslation(const Value: TVector2); inline;

               public property Translation: TVector2 read GetTranslation write SetTranslation;

               public function AsM3x2(): PMatrix3x2; inline;


               public procedure Init(const m11: Single; const m12: Single; const m21: Single; const m22: Single; const m31: Single; const m32: Single); inline;


               public class function CreateRotation(radians: Single): TImpl; overload; static; inline;


               public class function CreateRotation(radians: Single; const centerPoint: TVector2): TImpl; overload; static; inline;


               public class function CreateScale(const scales: TVector2): TImpl; overload; static; inline;


               public class function CreateScale(const scaleX: Single; const scaleY: Single): TImpl; overload; static; inline;


               public class function CreateScale(const scaleX: Single; const scaleY: Single; const centerPoint: TVector2): TImpl; overload; static; inline;


               public class function CreateScale(const scales: TVector2; const centerPoint: TVector2): TImpl; overload; static; inline;


               public class function CreateScale(const scale: Single): TImpl; overload; static; inline;


               public class function CreateScale(const scale: Single; const centerPoint: TVector2): TImpl; overload; static; inline;


               public class function CreateSkew(const radiansX: Single; const radiansY: Single): TImpl; overload; static; inline;


               public class function CreateSkew(const radiansX: Single; const radiansY: Single; const centerPoint: TVector2): TImpl; overload; static; inline;


               public class function CreateTranslation(const position: TVector2): TImpl; overload; static; inline;


               public class function CreateTranslation(const positionX: Single; const positionY: Single): TImpl; overload; static; inline;


               public class function Invert(const matrix: TImpl; out _result: TImpl): Boolean; static; inline;


               public class function Lerp(const left: TImpl; const right: TImpl; const amount: Single): TImpl; static; inline;


               public function GetDeterminant(): Single; inline;


               public function Equals(const other: TImpl): Boolean; overload;
               strict private function GetItem(const row: Integer; const column: Integer): Single; inline;
               strict private procedure SetItem(const row: Integer; const column: Integer; const Value: Single); inline;

               public property Items[const row: Integer; const column: Integer]: Single read GetItem write SetItem; default;


               class operator Add(const left: TImpl; const right: TImpl): TImpl; inline;


               class operator Equal(const left: TImpl; const right: TImpl): Boolean; inline;


               class operator NotEqual(const left: TImpl; const right: TImpl): Boolean; inline;


               class operator Multiply(const left: TImpl; const right: TImpl): TImpl; inline;


               class operator Multiply(const left: TImpl; const right: Single): TImpl; inline;


               class operator Subtract(const left: TImpl; const right: TImpl): TImpl; inline;


               class operator Negative(const value: TImpl): TImpl; inline;
            end;

      // See Matrix3x2.cs for an explanation of why this file/type exists
      //
      // Note that we use some particular patterns below, such as defining a result
      // and assigning the fields directly rather than using the object initializer
      // syntax. We do this because it saves roughly 8-bytes of IL per method which
      // in turn helps improve inlining chances.

      public const RowCount: UInt32 = 3;
      public const ColumnCount: UInt32 = 2;

      public function AsImpl(): TImpl; inline;
      public function AsROImpl(): PImpl; inline;
   end;

{$ENDREGION 'TMatrix3x2Helper'}

{$REGION 'TMatrix4x4Helper'}

   { TMatrix4x4Helper }

   TMatrix4x4Helper = record helper for TMatrix4x4

      strict private function GetTranslation(): TVector3; inline;
      strict private procedure SetTranslation(const Value: TVector3); inline;


      /// <summary>Gets or sets the translation component of this matrix.</summary>
      /// <value>The translation component of the current instance.</value>
      public property Translation: TVector3 read GetTranslation write SetTranslation;

      /// <summary>Creates a spherical billboard that rotates around a specified object position.</summary>
      /// <param name="objectPosition">The position of the object that the billboard will rotate around.</param>
      /// <param name="cameraPosition">The position of the camera.</param>
      /// <param name="cameraUpVector">The up vector of the camera.</param>
      /// <param name="cameraForwardVector">The forward vector of the camera.</param>
      /// <returns>The created billboard.</returns>
      public class function CreateBillboard(const objectPosition: TVector3; const cameraPosition: TVector3; const cameraUpVector: TVector3; const cameraForwardVector: TVector3): TMatrix4x4; static;



      /// <summary>Creates a cylindrical billboard that rotates around a specified axis.</summary>
      /// <param name="objectPosition">The position of the object that the billboard will rotate around.</param>
      /// <param name="cameraPosition">The position of the camera.</param>
      /// <param name="rotateAxis">The axis to rotate the billboard around.</param>
      /// <param name="cameraForwardVector">The forward vector of the camera.</param>
      /// <param name="objectForwardVector">The forward vector of the object.</param>
      /// <returns>The billboard matrix.</returns>
      public class function CreateConstrainedBillboard(const objectPosition: TVector3; const cameraPosition: TVector3; const rotateAxis: TVector3; const cameraForwardVector: TVector3; const objectForwardVector: TVector3): TMatrix4x4; static;



      /// <summary>Creates a matrix that rotates around an arbitrary vector.</summary>
      /// <param name="axis">The axis to rotate around.</param>
      /// <param name="angle">The angle to rotate around <paramref name="axis" />, in radians.</param>
      /// <returns>The rotation matrix.</returns>
      public class function CreateFromAxisAngle(const axis: TVector3; const angle: Single): TMatrix4x4; static;

      /// <summary>Creates a rotation matrix from the specified Quaternion rotation value.</summary>
      /// <param name="quaternion">The source Quaternion.</param>
      /// <returns>The rotation matrix.</returns>
      public class function CreateFromQuaternion(const quaternion: TQuaternion): TMatrix4x4; static;

      /// <summary>Creates a right-handed view matrix.</summary>
      /// <param name="cameraPosition">The position of the camera.</param>
      /// <param name="cameraTarget">The target towards which the camera is pointing.</param>
      /// <param name="cameraUpVector">The direction that is "up" from the camera's point of view.</param>
      /// <returns>The right-handed view matrix.</returns>
      public class function CreateLookAt(const cameraPosition: TVector3; const cameraTarget: TVector3; const cameraUpVector: TVector3): TMatrix4x4; static;


      /// <summary>Creates a left-handed view matrix.</summary>
      /// <param name="cameraPosition">The position of the camera.</param>
      /// <param name="cameraTarget">The target towards which the camera is pointing.</param>
      /// <param name="cameraUpVector">The direction that is "up" from the camera's point of view.</param>
      /// <returns>The left-handed view matrix.</returns>
      public class function CreateLookAtLeftHanded(const cameraPosition: TVector3; const cameraTarget: TVector3; const cameraUpVector: TVector3): TMatrix4x4; static;


      /// <summary>Creates a right-handed view matrix.</summary>
      /// <param name="cameraPosition">The position of the camera.</param>
      /// <param name="cameraDirection">The direction in which the camera is pointing.</param>
      /// <param name="cameraUpVector">The direction that is "up" from the camera's point of view.</param>
      /// <returns>The right-handed view matrix.</returns>
      public class function CreateLookTo(const cameraPosition: TVector3; const cameraDirection: TVector3; const cameraUpVector: TVector3): TMatrix4x4; static;

      /// <summary>Creates a left-handed view matrix.</summary>
      /// <param name="cameraPosition">The position of the camera.</param>
      /// <param name="cameraDirection">The direction in which the camera is pointing.</param>
      /// <param name="cameraUpVector">The direction that is "up" from the camera's point of view.</param>
      /// <returns>The left-handed view matrix.</returns>
      public class function CreateLookToLeftHanded(const cameraPosition: TVector3; const cameraDirection: TVector3; const cameraUpVector: TVector3): TMatrix4x4; static;

      /// <summary>Creates a matrix that reflects the coordinate system about a specified plane.</summary>
      /// <param name="value">The plane about which to create a reflection.</param>
      /// <returns>A new matrix expressing the reflection.</returns>
      public class function CreateReflection(const value: TPlane): TMatrix4x4; static;

      /// <summary>Creates a matrix for rotating points around the X axis from a center point.</summary>
      /// <param name="radians">The amount, in radians, by which to rotate around the X axis.</param>
      /// <param name="centerPoint">The center point.</param>
      /// <returns>The rotation matrix.</returns>
      public class function CreateRotationX(const radians: Single; const centerPoint: TVector3): TMatrix4x4; overload; static;

      /// <summary>The amount, in radians, by which to rotate around the Y axis from a center point.</summary>
      /// <param name="radians">The amount, in radians, by which to rotate around the Y-axis.</param>
      /// <param name="centerPoint">The center point.</param>
      /// <returns>The rotation matrix.</returns>
      public class function CreateRotationY(const radians: Single; const centerPoint: TVector3): TMatrix4x4; overload; static;

      /// <summary>Creates a matrix for rotating points around the Z axis from a center point.</summary>
      /// <param name="radians">The amount, in radians, by which to rotate around the Z-axis.</param>
      /// <param name="centerPoint">The center point.</param>
      /// <returns>The rotation matrix.</returns>
      public class function CreateRotationZ(const radians: Single; const centerPoint: TVector3): TMatrix4x4; overload; static;

      /// <summary>Creates a scaling matrix that is offset by a given center point.</summary>
      /// <param name="xScale">The value to scale by on the X axis.</param>
      /// <param name="yScale">The value to scale by on the Y axis.</param>
      /// <param name="zScale">The value to scale by on the Z axis.</param>
      /// <param name="centerPoint">The center point.</param>
      /// <returns>The scaling matrix.</returns>
      public class function CreateScale(const xScale: Single; const yScale: Single; const zScale: Single; const centerPoint: TVector3): TMatrix4x4; overload; static;



      /// <summary>Creates a scaling matrix from the specified vector scale.</summary>
      /// <param name="scales">The scale to use.</param>
      /// <returns>The scaling matrix.</returns>
      public class function CreateScale(const scales: TVector3): TMatrix4x4; overload; static;



      /// <summary>Creates a scaling matrix with a center point.</summary>
      /// <param name="scales">The vector that contains the amount to scale on each axis.</param>
      /// <param name="centerPoint">The center point.</param>
      /// <returns>The scaling matrix.</returns>
      public class function CreateScale(const scales: TVector3; const centerPoint: TVector3): TMatrix4x4; overload; static;

      /// <summary>Creates a uniform scaling matrix that scales equally on each axis with a center point.</summary>
      /// <param name="scale">The uniform scaling factor.</param>
      /// <param name="centerPoint">The center point.</param>
      /// <returns>The scaling matrix.</returns>
      public class function CreateScale(const scale: Single; const centerPoint: TVector3): TMatrix4x4; overload; static;



      /// <summary>Creates a matrix that flattens geometry into a specified plane as if casting a shadow from a specified light source.</summary>
      /// <param name="lightDirection">The direction from which the light that will cast the shadow is coming.</param>
      /// <param name="plane">The plane onto which the new matrix should flatten geometry so as to cast a shadow.</param>
      /// <returns>A new matrix that can be used to flatten geometry onto the specified plane from the specified direction.</returns>
      public class function CreateShadow(const lightDirection: TVector3; const plane: TPlane): TMatrix4x4; static;



      /// <summary>Creates a translation matrix from the specified 3-dimensional vector.</summary>
      /// <param name="position">The amount to translate in each axis.</param>
      /// <returns>The translation matrix.</returns>
      public class function CreateTranslation(const position: TVector3): TMatrix4x4; overload; static;

      /// <summary>Creates a world matrix with the specified parameters.</summary>
      /// <param name="position">The position of the object.</param>
      /// <param name="forward">The forward direction of the object.</param>
      /// <param name="up">The upward direction of the object. Its value is usually <c>[0, 1, 0]</c>.</param>
      /// <returns>The world matrix.</returns>
      /// <remarks><paramref name="position" /> is used in translation operations.</remarks>
      public class function CreateWorld(const position: TVector3; const forward: TVector3; const up: TVector3): TMatrix4x4; static;



      /// <summary>Attempts to extract the scale, translation, and rotation components from the given scale, rotation, or translation matrix. The return value indicates whether the operation succeeded.</summary>
      /// <param name="matrix">The source matrix.</param>
      /// <param name="scale">When this method returns, contains the scaling component of the transformation matrix if the operation succeeded.</param>
      /// <param name="rotation">When this method returns, contains the rotation component of the transformation matrix if the operation succeeded.</param>
      /// <param name="translation">When the method returns, contains the translation component of the transformation matrix if the operation succeeded.</param>
      /// <returns><see langword="true" /> if <paramref name="matrix" /> was decomposed successfully; otherwise,  <see langword="false" />.</returns>
      public class function Decompose(const matrix: TMatrix4x4; out scale: TVector3; out rotation: TQuaternion; out translation: TVector3): Boolean; static;

      /// <summary>Transforms the specified matrix by applying the specified Quaternion rotation.</summary>
      /// <param name="value">The matrix to transform.</param>
      /// <param name="rotation">The rotation t apply.</param>
      /// <returns>The transformed matrix.</returns>
      public class function Transform(const value: TMatrix4x4; const rotation: TQuaternion): TMatrix4x4; static;

      {$REGION 'TImpl'}

      { TImpl }

      public type

            PImpl = ^TImpl;
            TImpl = record(*IEquatable<TImpl>*)

               {$REGION 'TCanonicalBasis'}
               strict private type

                     { TCanonicalBasis }

                     TCanonicalBasis = record
                        public Row0: TVector3;
                        public Row1: TVector3;
                        public Row2: TVector3;
                     end;
               {$ENDREGION 'TCanonicalBasis'}

               {$REGION 'TVectorBasis'}
               private type

                     { TVectorBasis }

                     TVectorBasis = record
                        public Element0: PVector3;
                        public Element1: PVector3;
                        public Element2: PVector3;
                     end;
               {$ENDREGION 'TVectorBasis'}

               strict private const BillboardEpsilon: Single = Single(1e-4);
               strict private const BillboardMinAngle: Single = 1.0 - (0.1 * (TMathF.PI / 180.0));
               strict private const DecomposeEpsilon: Single = Single(0.0001);

               public X: TVector4;
               public Y: TVector4;
               public Z: TVector4;
               public W: TVector4;
               strict private class function GetIdentity(): TImpl; static; inline;

               public class property Identity: TImpl read GetIdentity;
               strict private function GetIsIdentity(): Boolean; inline;
               public property IsIdentity: Boolean read GetIsIdentity;

               strict private function GetTranslation(): TVector3; inline;
               strict private procedure SetTranslation(const Value: TVector3); inline;
               public property Translation: TVector3 read GetTranslation write SetTranslation;

               public function AsM4x4(): PMatrix4x4; inline;
               public procedure Init(const m11: Single; const m12: Single; const m13: Single; const m14: Single; const m21: Single; const m22: Single; const m23: Single; const m24: Single; const m31: Single; const m32: Single; const m33: Single; const m34: Single; const m41: Single; const m42: Single; const m43: Single; const m44: Single); overload; inline;
//               public procedure Init(const value: TMatrix3x2.TImpl); overload;
               public class function CreateBillboard(const objectPosition: TVector3; const cameraPosition: TVector3; const cameraUpVector: TVector3; const cameraForwardVector: TVector3): TImpl; static; inline;
               public class function CreateConstrainedBillboard(const objectPosition: TVector3; const cameraPosition: TVector3; const rotateAxis: TVector3; const cameraForwardVector: TVector3; const objectForwardVector: TVector3): TImpl; static; inline;
               public class function CreateFromAxisAngle(const axis: TVector3; const angle: Single): TImpl; static; inline;
               public class function CreateFromQuaternion(const quaternion: TQuaternion): TImpl; static; inline;
               public class function CreateFromYawPitchRoll(const yaw: Single; const pitch: Single; const roll: Single): TImpl; static; inline;
               public class function CreateLookTo(const cameraPosition: TVector3; const cameraDirection: TVector3; const cameraUpVector: TVector3): TImpl; static; inline;
               public class function CreateLookToLeftHanded(const cameraPosition: TVector3; const cameraDirection: TVector3; const cameraUpVector: TVector3): TImpl; static; inline;
               public class function CreateOrthographic(const width: Single; const height: Single; const zNearPlane: Single; const zFarPlane: Single): TImpl; static; inline;
               public class function CreateOrthographicLeftHanded(const width: Single; const height: Single; const zNearPlane: Single; const zFarPlane: Single): TImpl; static; inline;
               public class function CreateOrthographicOffCenter(const left: Single; const right: Single; const bottom: Single; const top: Single; const zNearPlane: Single; const zFarPlane: Single): TImpl; static; inline;
               public class function CreateOrthographicOffCenterLeftHanded(const left: Single; const right: Single; const bottom: Single; const top: Single; const zNearPlane: Single; const zFarPlane: Single): TImpl; static; inline;
               public class function CreatePerspective(const width: Single; const height: Single; const nearPlaneDistance: Single; const farPlaneDistance: Single): TImpl; static; inline;
               public class function CreatePerspectiveLeftHanded(const width: Single; const height: Single; const nearPlaneDistance: Single; const farPlaneDistance: Single): TImpl; static; inline;
               public class function CreatePerspectiveFieldOfView(const fieldOfView: Single; const aspectRatio: Single; const nearPlaneDistance: Single; const farPlaneDistance: Single): TImpl; static; inline;
               public class function CreatePerspectiveFieldOfViewLeftHanded(const fieldOfView: Single; const aspectRatio: Single; const nearPlaneDistance: Single; const farPlaneDistance: Single): TImpl; static; inline;
               public class function CreatePerspectiveOffCenter(const left: Single; const right: Single; const bottom: Single; const top: Single; const nearPlaneDistance: Single; const farPlaneDistance: Single): TImpl; static; inline;
               public class function CreatePerspectiveOffCenterLeftHanded(const left: Single; const right: Single; const bottom: Single; const top: Single; const nearPlaneDistance: Single; const farPlaneDistance: Single): TImpl; static; inline;
               public class function CreateReflection(const value: TPlane): TImpl; static; inline;
               public class function CreateRotationX(const radians: Single): TImpl; overload; static; inline;
               public class function CreateRotationX(const radians: Single; const centerPoint: TVector3): TImpl; overload; static; inline;
               public class function CreateRotationY(const radians: Single): TImpl; overload; static; inline;
               public class function CreateRotationY(const radians: Single; const centerPoint: TVector3): TImpl; overload; static; inline;
               public class function CreateRotationZ(const radians: Single): TImpl; overload; static; inline;
               public class function CreateRotationZ(const radians: Single; const centerPoint: TVector3): TImpl; overload; static; inline;
               public class function CreateScale(const scaleX: Single; const scaleY: Single; const scaleZ: Single): TImpl; overload; static; inline;
               public class function CreateScale(const scaleX: Single; const scaleY: Single; const scaleZ: Single; const centerPoint: TVector3): TImpl; overload; static; inline;
               public class function CreateScale(const scales: TVector3): TImpl; overload; static; inline;
               public class function CreateScale(const scales: TVector3; const centerPoint: TVector3): TImpl; overload; static; inline;
               public class function CreateScale(const scale: Single): TImpl; overload; static; inline;
               public class function CreateScale(const scale: Single; const centerPoint: TVector3): TImpl; overload; static; inline;
               public class function CreateShadow(const lightDirection: TVector3; const plane: TPlane): TImpl; static; inline;
               public class function CreateTranslation(const position: TVector3): TImpl; overload; static; inline;
               public class function CreateTranslation(const positionX: Single; const positionY: Single; const positionZ: Single): TImpl; overload; static; inline;
               public class function CreateViewport(const x: Single; const y: Single; const width: Single; const height: Single; const minDepth: Single; const maxDepth: Single): TImpl; static; inline;
               public class function CreateViewportLeftHanded(const x: Single; const y: Single; const width: Single; const height: Single; const minDepth: Single; const maxDepth: Single): TImpl; static; inline;
               public class function CreateWorld(const position: TVector3; const forward: TVector3; const up: TVector3): TImpl; static; inline;
               public class function Decompose(const matrix: TImpl; out scale: TVector3; out rotation: TQuaternion; out translation: TVector3): Boolean; static; inline;
               public class function Invert(const matrix: TImpl; out _result: TImpl): Boolean; static; //inline;
               public class function Lerp(const left: TImpl; const right: TImpl; const amount: Single): TImpl; static; inline;
               public class function Transform(const value: TImpl; const rotation: TQuaternion): TImpl; static; inline;
               public class function Transpose(const matrix: TImpl): TImpl; static; inline;
               public function Equals(const other: TImpl): Boolean; overload; inline;
               public function GetDeterminant(): Single; inline;

               strict private function GetItem(const row: Integer; const column: Integer): Single; inline;
               strict private procedure SetItem(const row: Integer; const column: Integer; const Value: Single); inline;
               public property Items[const row: Integer; const column: Integer]: Single read GetItem write SetItem; default;

               class operator Add(const left: TImpl; const right: TImpl): TImpl; inline;
               class operator Equal(const left: TImpl; const right: TImpl): Boolean; inline;
               class operator NotEqual(const left: TImpl; const right: TImpl): Boolean; inline;
               class operator Multiply(const left: TImpl; const right: TImpl): TImpl; inline;
               class operator Multiply(const left: TImpl; const right: Single): TImpl; inline;
               class operator Subtract(const left: TImpl; const right: TImpl): TImpl; inline;
               class operator Negative(const value: TImpl): TImpl; inline;
            end;

      {$ENDREGION 'TImpl'}

      // See Matrix4x4.cs for an explanation of why this file/type exists
      //
      // Note that we use some particular patterns below, such as defining a result
      // and assigning the fields directly rather than using the object initializer
      // syntax. We do this because it saves roughly 8-bytes of IL per method which
      // in turn helps improve inlining chances.

      // TODO: Vector3 is "inefficient" and we'd be better off taking Vector4 or Vector128<T>

      public const RowCount: UInt32 = 4;
      public const ColumnCount: UInt32 = 4;

      public function AsImpl(): TImpl; inline;
      public function AsROImpl(): PImpl; inline;
   end;

{$ENDREGION 'TMatrix4x4Helper'}

{$REGION 'TQuaternionHelper'}

   { TQuaternionHelper }

   TQuaternionHelper = record helper for TQuaternion
      /// <summary>Creates a quaternion from the specified vector and rotation parts.</summary>
      /// <param name="vectorPart">The vector part of the quaternion.</param>
      /// <param name="scalarPart">The rotation part of the quaternion.</param>
      public constructor Create(const vectorPart: TVector3; const scalarPart: Single); overload;

      /// <summary>Creates a quaternion from a unit vector and an angle to rotate around the vector.</summary>
      /// <param name="axis">The unit vector to rotate around.</param>
      /// <param name="angle">The angle, in radians, to rotate around the vector.</param>
      /// <returns>The newly created quaternion.</returns>
      /// <remarks><paramref name="axis" /> vector must be normalized before calling this method or the resulting <see cref="Quaternion" /> will be incorrect.</remarks>
      public class function CreateFromAxisAngle(const axis: TVector3; const angle: Single): TQuaternion; static;

      /// <summary>Returns a new quaternion whose values are the product of each pair of elements in specified quaternion and vector.</summary>
      /// <param name="value1">The quaternion.</param>
      /// <param name="value2">The vector.</param>
      /// <returns>The element-wise product vector.</returns>
      public class function Multiply(const value1: TQuaternion; const value2: TVector4): TQuaternion; overload; static; inline;

      /// <summary>Gets the element at the specified index.</summary>
      /// <param name="quaternion">The quaternion to get the element from.</param>
      /// <param name="index">The index of the element to get.</param>
      /// <returns>The value of the element at <paramref name="index" />.</returns>
      /// <exception cref="ArgumentOutOfRangeException"><paramref name="index" /> was less than zero or greater than the number of elements.</exception>
      protected function GetElement(const index: Integer): Single; inline;


      /// <summary>Creates a new <see cref="Quaternion" /> with the element at the specified index set to the specified value and the remaining elements set to the same value as that in the given quaternion.</summary>
      /// <param name="quaternion">The quaternion to get the remaining elements from.</param>
      /// <param name="index">The index of the element to set.</param>
      /// <param name="value">The value to set the element to.</param>
      /// <returns>A <see cref="Quaternion" /> with the value of the element at <paramref name="index" /> set to <paramref name="value" /> and the remaining elements set to the same value as that in <paramref name="quaternion" />.</returns>
      /// <exception cref="ArgumentOutOfRangeException"><paramref name="index" /> was less than zero or greater than the number of elements.</exception>
      protected function WithElement(const index: Integer; const value: Single): TQuaternion; inline;

      strict private function GetElementUnsafe(const index: Integer): Single; inline;

      strict private procedure SetElementUnsafe(const index: Integer; const value: Single); inline;
   end;

{$ENDREGION 'TQuaternionHelper'}

{$REGION 'TVector2Helper'}

   { TVector2Helper }

   TVector2Helper = record helper for TVector2
      /// <summary>Transforms a vector by a specified 4x4 matrix.</summary>
      /// <param name="position">The vector to transform.</param>
      /// <param name="matrix">The transformation matrix.</param>
      /// <returns>The transformed vector.</returns>
      public class function Transform(const Position: TVector2; const Matrix: TMatrix4x4): TVector2; overload; static;

      /// <summary>Transforms a vector normal by the given 4x4 matrix.</summary>
      /// <param name="normal">The source vector.</param>
      /// <param name="matrix">The matrix.</param>
      /// <returns>The transformed vector.</returns>
      public class function TransformNormal(const Normal: TVector2; const Matrix: TMatrix4x4): TVector2; overload; static;

//TODO:      private class function TransformNormal(const normal: TVector2; const matrix: TMatrix4x4Helper.TImpl): TVector2; static; overload;

//TODO:      private class function Transform(position: TVector2; matrix: TMatrix3x2.TImpl): TVector2; overload; static;
//TODO:      private class function TransformNormal(const normal: TVector2; const matrix: TMatrix3x2.TImpl): TVector2; overload;
   end;

{$ENDREGION 'TVector2Helper'}

{$REGION 'TVector3Helper'}

   { TVector3Helper }

   TVector3Helper = record helper for TVector3
//      private class function TransformNormal(const normal: TVector3; const matrix: TMatrix4x4.TImpl): TVector3; overload; static; inline;

      /// <summary>Gets the element at the specified index.</summary>
      /// <param name="vector">The vector to get the element from.</param>
      /// <param name="index">The index of the element to get.</param>
      /// <returns>The value of the element at <paramref name="index" />.</returns>
      /// <exception cref="ArgumentOutOfRangeException"><paramref name="index" /> was less than zero or greater than the number of elements.</exception>
      protected function GetElement(const index: Integer): Single; inline;

      /// <summary>Creates a new <see cref="Vector3" /> with the element at the specified index set to the specified value and the remaining elements set to the same value as that in the given vector.</summary>
      /// <param name="vector">The vector to get the remaining elements from.</param>
      /// <param name="index">The index of the element to set.</param>
      /// <param name="value">The value to set the element to.</param>
      /// <returns>A <see cref="Vector3" /> with the value of the element at <paramref name="index" /> set to <paramref name="value" /> and the remaining elements set to the same value as that in <paramref name="vector" />.</returns>
      /// <exception cref="ArgumentOutOfRangeException"><paramref name="index" /> was less than zero or greater than the number of elements.</exception>
      protected function WithElement(const index: Integer; const value: Single): TVector3;

      strict private function GetElementUnsafe(const index: Integer): Single; inline;
      strict private procedure SetElementUnsafe(const index: Integer; const value: Single); inline;
   end;

{$ENDREGION 'TVector3Helper'}

{$REGION 'TVector4Helper'}

   { TVector4Helper }

   TVector4Helper = record helper for TVector4
      /// <summary>Gets the element at the specified index.</summary>
      /// <param name="vector">The vector to get the element from.</param>
      /// <param name="index">The index of the element to get.</param>
      /// <returns>The value of the element at <paramref name="index" />.</returns>
      /// <exception cref="ArgumentOutOfRangeException"><paramref name="index" /> was less than zero or greater than the number of elements.</exception>
      protected function GetElement(const index: Integer): Single; inline;

      /// <summary>Creates a new <see cref="Vector4" /> with the element at the specified index set to the specified value and the remaining elements set to the same value as that in the given vector.</summary>
      /// <param name="vector">The vector to get the remaining elements from.</param>
      /// <param name="index">The index of the element to set.</param>
      /// <param name="value">The value to set the element to.</param>
      /// <returns>A <see cref="Vector4" /> with the value of the element at <paramref name="index" /> set to <paramref name="value" /> and the remaining elements set to the same value as that in <paramref name="vector" />.</returns>
      /// <exception cref="ArgumentOutOfRangeException"><paramref name="index" /> was less than zero or greater than the number of elements.</exception>
      protected function WithElement(const index: Integer; const value: Single): TVector4;

      strict private function GetElementUnsafe(const index: Integer): Single; inline;
      strict private procedure SetElementUnsafe(const index: Integer; const value: Single); inline;
//      private class function Transform(const position: TVector2; const matrix: TMatrix4x4.TImpl): TVector4; overload; static; inline;
      //private class function Transform(const position: TVector3; const matrix: TMatrix4x4.TImpl): TVector4; overload; static; inline;
      //private class function Transform(const vector: TVector4; const matrix: TMatrix4x4.TImpl): TVector4; overload; static; inline;
   end;

{$ENDREGION 'TVector4Helper'}

implementation

{$REGION 'TMatrix3x2'}

{ TMatrix3x2 }

class function TMatrix3x2.GetIdentity(): TMatrix3x2;
begin
   Result := TMatrix3x2.TImpl.Identity.AsM3x2()^;
end;

function TMatrix3x2.GetIsIdentity(): Boolean;
begin
   Result := Self.AsROImpl()^.IsIdentity
end;

constructor TMatrix3x2.Create(const m11: Single; const m12: Single; const m21: Single; const m22: Single; const m31: Single; const m32: Single);
begin
   Self.AsImpl().Init(m11, m12, m21, m22, m31, m32);
end;

class function TMatrix3x2.Add(const value1: TMatrix3x2; const value2: TMatrix3x2): TMatrix3x2;
begin
   Result := (value1.AsImpl() + value2.AsImpl()).AsM3x2()^
end;

class function TMatrix3x2.CreateRotation(const radians: Single): TMatrix3x2;
begin
   Result := TMatrix3x2.TImpl.CreateRotation(radians).AsM3x2()^
end;

class function TMatrix3x2.CreateScale(const xScale: Single; const yScale: Single): TMatrix3x2;
begin
   Result := TMatrix3x2.TImpl.CreateScale(xScale, yScale).AsM3x2()^;
end;

class function TMatrix3x2.CreateScale(const scale: Single): TMatrix3x2;
begin
   Result := TMatrix3x2.TImpl.CreateScale(scale).AsM3x2()^;
end;

class function TMatrix3x2.CreateSkew(const radiansX: Single; const radiansY: Single): TMatrix3x2;
begin
   Result := TMatrix3x2.TImpl.CreateSkew(radiansX, radiansY).AsM3x2()^;
end;

class function TMatrix3x2.CreateTranslation(const xPosition: Single; const yPosition: Single): TMatrix3x2;
begin
   Result := TMatrix3x2.TImpl.CreateTranslation(xPosition, yPosition).AsM3x2()^;
end;

class function TMatrix3x2.Invert(const matrix: TMatrix3x2; out _result: TMatrix3x2): Boolean;
var
  return: TMatrix3x2Helper.TImpl;
begin
   return := _result.AsImpl();
   Result := TMatrix3x2.TImpl.Invert(matrix.AsImpl(), return);
   _result := TMatrix3x2((@return)^);
end;

class function TMatrix3x2.Lerp(const matrix1: TMatrix3x2; const matrix2: TMatrix3x2; const amount: Single): TMatrix3x2;
begin
   Result := TMatrix3x2.TImpl.Lerp(matrix1.AsImpl(), matrix2.AsImpl(), amount).AsM3x2()^;
end;

class function TMatrix3x2.Multiply(const value1: TMatrix3x2; const value2: TMatrix3x2): TMatrix3x2;
begin
   Result := (value1.AsImpl() * value2.AsImpl()).AsM3x2()^;
end;

class function TMatrix3x2.Multiply(const value1: TMatrix3x2; const value2: Single): TMatrix3x2;
begin
   Result := (value1.AsImpl() * value2).AsM3x2()^;
end;

class function TMatrix3x2.Negate(const value: TMatrix3x2): TMatrix3x2;
begin
   Result := (-value.AsImpl()).AsM3x2()^;
end;

class function TMatrix3x2.Subtract(const value1: TMatrix3x2; const value2: TMatrix3x2): TMatrix3x2;
begin
   Result := (value1.AsImpl() - value2.AsImpl()).AsM3x2()^;
end;

function TMatrix3x2.Equals(const other: TMatrix3x2): Boolean;
begin
   Result := Self.AsROImpl()^.Equals(other.AsImpl())
end;

function TMatrix3x2.GetDeterminant(): Single;

begin
   Result := Self.AsROImpl()^.GetDeterminant()
end;

function TMatrix3x2.ToString(): string;

begin
   Result := '{ {M11:' + M11.ToString() + ' M12:' + M12.ToString() + '} {M21:' + M21.ToString() + ' M22:' + M22.ToString() + '} {M31:' + M31.ToString() + ' M32:' + M32.ToString() + '} }'
end;
function TMatrix3x2.GetItem(const row: Integer; const column: Integer): Single;
begin
   Result := Self.AsROImpl()^[row, column];
end;

procedure TMatrix3x2.SetItem(const row: Integer; const column: Integer; const Value: Single);
begin
   Self.AsImpl()[row, column] := value;end;

class operator TMatrix3x2.Add(const value1: TMatrix3x2; const value2: TMatrix3x2): TMatrix3x2;
begin
   Result := (value1.AsImpl() + value2.AsImpl()).AsM3x2()^;
end;

class operator TMatrix3x2.Equal(const value1: TMatrix3x2; const value2: TMatrix3x2): Boolean;
begin
   Result := value1.AsImpl() = value2.AsImpl();
end;

class operator TMatrix3x2.NotEqual(const value1: TMatrix3x2; const value2: TMatrix3x2): Boolean;
begin
   Result := value1.AsImpl() <> value2.AsImpl();
end;

class operator TMatrix3x2.Multiply(const value1: TMatrix3x2; const value2: TMatrix3x2): TMatrix3x2;
begin
   Result := (value1.AsImpl() * value2.AsImpl()).AsM3x2()^;
end;

class operator TMatrix3x2.Multiply(const value1: TMatrix3x2; const value2: Single): TMatrix3x2;
begin
   Result := (value1.AsImpl() * value2).AsM3x2()^;
end;

class operator TMatrix3x2.Subtract(const value1: TMatrix3x2; const value2: TMatrix3x2): TMatrix3x2;
begin
   Result := (value1.AsImpl() - value2.AsImpl()).AsM3x2()^;
end;

class operator TMatrix3x2.Negative(const value: TMatrix3x2): TMatrix3x2;
begin
   Result := (-value.AsImpl()).AsM3x2()^;
end;

{$ENDREGION 'TMatrix3x2'}

{$REGION 'TMatrix4x4'}

{ TMatrix4x4 }

class function TMatrix4x4.GetIdentity(): TMatrix4x4;
begin
   Result := TMatrix4x4.TImpl.Identity.AsM4x4()^;
end;

function TMatrix4x4.GetIsIdentity(): Boolean;
begin
   Result := Self.AsROImpl()^.IsIdentity;
end;

constructor TMatrix4x4.Create(const m11: Single; const m12: Single; const m13: Single; const m14: Single; const m21: Single; const m22: Single; const m23: Single; const m24: Single; const m31: Single; const m32: Single; const m33: Single; const m34: Single; const m41: Single; const m42: Single; const m43: Single; const m44: Single);
begin
   Self.AsImpl().Init(m11, m12, m13, m14, m21, m22, m23, m24, m31, m32, m33, m34, m41, m42, m43, m44);
end;

constructor TMatrix4x4.Create(const value: TMatrix3x2);
begin
raise ENotImplemented.Create('ainda não fiz isso aqui');

//Self.AsImpl().Init(value);
end;

class function TMatrix4x4.Add(const value1: TMatrix4x4; const value2: TMatrix4x4): TMatrix4x4;
begin
   Result := (value1.AsImpl() + value2.AsImpl()).AsM4x4()^;
end;

class function TMatrix4x4.CreateFromYawPitchRoll(const yaw: Single; const pitch: Single; const roll: Single): TMatrix4x4;
begin
   Result := TMatrix4x4.TImpl.CreateFromYawPitchRoll(yaw, pitch, roll).AsM4x4()^;
end;

class function TMatrix4x4.CreateOrthographic(const width: Single; const height: Single; const zNearPlane: Single; const zFarPlane: Single): TMatrix4x4;
begin
   Result := TMatrix4x4.TImpl.CreateOrthographic(width, height, zNearPlane, zFarPlane).AsM4x4()^;
end;

class function TMatrix4x4.CreateOrthographicLeftHanded(const width: Single; const height: Single; const zNearPlane: Single; const zFarPlane: Single): TMatrix4x4;
begin
   Result := TMatrix4x4.TImpl.CreateOrthographicLeftHanded(width, height, zNearPlane, zFarPlane).AsM4x4()^;
end;

class function TMatrix4x4.CreateOrthographicOffCenter(const left: Single; const right: Single; const bottom: Single; const top: Single; const zNearPlane: Single; const zFarPlane: Single): TMatrix4x4;
begin
   Result := TMatrix4x4.TImpl.CreateOrthographicOffCenter(left, right, bottom, top, zNearPlane, zFarPlane).AsM4x4()^;
end;

class function TMatrix4x4.CreateOrthographicOffCenterLeftHanded(const left: Single; const right: Single; const bottom: Single; const top: Single; const zNearPlane: Single; const zFarPlane: Single): TMatrix4x4;
begin
   Result := TMatrix4x4.TImpl.CreateOrthographicOffCenterLeftHanded(left, right, bottom, top, zNearPlane, zFarPlane).AsM4x4()^;
end;

class function TMatrix4x4.CreatePerspective(const width: Single; const height: Single; const nearPlaneDistance: Single; const farPlaneDistance: Single): TMatrix4x4;
begin
   Result := TMatrix4x4.TImpl.CreatePerspective(width, height, nearPlaneDistance, farPlaneDistance).AsM4x4()^;
end;

class function TMatrix4x4.CreatePerspectiveLeftHanded(const width: Single; const height: Single; const nearPlaneDistance: Single; const farPlaneDistance: Single): TMatrix4x4;
begin
   Result := TMatrix4x4.TImpl.CreatePerspectiveLeftHanded(width, height, nearPlaneDistance, farPlaneDistance).AsM4x4()^;
end;

class function TMatrix4x4.CreatePerspectiveFieldOfView(const fieldOfView: Single; const aspectRatio: Single; const nearPlaneDistance: Single; const farPlaneDistance: Single): TMatrix4x4;
begin
   Result := TMatrix4x4.TImpl.CreatePerspectiveFieldOfView(fieldOfView, aspectRatio, nearPlaneDistance, farPlaneDistance).AsM4x4()^;
end;

class function TMatrix4x4.CreatePerspectiveFieldOfViewLeftHanded(const fieldOfView: Single; const aspectRatio: Single; const nearPlaneDistance: Single; const farPlaneDistance: Single): TMatrix4x4;
begin
   Result := TMatrix4x4.TImpl.CreatePerspectiveFieldOfViewLeftHanded(fieldOfView, aspectRatio, nearPlaneDistance, farPlaneDistance).AsM4x4()^;
end;

class function TMatrix4x4.CreatePerspectiveOffCenter(const left: Single; const right: Single; const bottom: Single; const top: Single; const nearPlaneDistance: Single; const farPlaneDistance: Single): TMatrix4x4;
begin
   Result := TMatrix4x4.TImpl.CreatePerspectiveOffCenter(left, right, bottom, top, nearPlaneDistance, farPlaneDistance).AsM4x4()^;
end;

class function TMatrix4x4.CreatePerspectiveOffCenterLeftHanded(const left: Single; const right: Single; const bottom: Single; const top: Single; const nearPlaneDistance: Single; const farPlaneDistance: Single): TMatrix4x4;
begin
   Result := TMatrix4x4.TImpl.CreatePerspectiveOffCenterLeftHanded(left, right, bottom, top, nearPlaneDistance, farPlaneDistance).AsM4x4()^;
end;

class function TMatrix4x4.CreateRotationX(const radians: Single): TMatrix4x4;
begin
   Result := TMatrix4x4.TImpl.CreateRotationX(radians).AsM4x4()^;
end;

class function TMatrix4x4.CreateRotationY(const radians: Single): TMatrix4x4;
begin
   Result := TMatrix4x4.TImpl.CreateRotationY(radians).AsM4x4()^;
end;

class function TMatrix4x4.CreateRotationZ(const radians: Single): TMatrix4x4;
begin
   Result := TMatrix4x4.TImpl.CreateRotationZ(radians).AsM4x4()^;
end;

class function TMatrix4x4.CreateScale(const xScale: Single; const yScale: Single; const zScale: Single): TMatrix4x4;
begin
   Result := TMatrix4x4.TImpl.CreateScale(xScale, yScale, zScale).AsM4x4()^;
end;

class function TMatrix4x4.CreateScale(const scale: Single): TMatrix4x4;
begin
   Result := TMatrix4x4.TImpl.CreateScale(scale).AsM4x4()^;
end;

class function TMatrix4x4.CreateTranslation(const xPosition: Single; const yPosition: Single; const zPosition: Single): TMatrix4x4;
begin
   Result := TMatrix4x4.TImpl.CreateTranslation(xPosition, yPosition, zPosition).AsM4x4()^;
end;

class function TMatrix4x4.CreateViewport(const x: Single; const y: Single; const width: Single; const height: Single; const minDepth: Single; const maxDepth: Single): TMatrix4x4;
begin
   Result := TMatrix4x4.TImpl.CreateViewport(x, y, width, height, minDepth, maxDepth).AsM4x4()^;
end;

class function TMatrix4x4.CreateViewportLeftHanded(const x: Single; const y: Single; const width: Single; const height: Single; const minDepth: Single; const maxDepth: Single): TMatrix4x4;
begin
   Result := TMatrix4x4.TImpl.CreateViewportLeftHanded(x, y, width, height, minDepth, maxDepth).AsM4x4()^;
end;

class function TMatrix4x4.Invert(const matrix: TMatrix4x4; out _result: TMatrix4x4): Boolean;
var
  return: TMatrix4x4Helper.TImpl;
begin
   return := _result.AsImpl();
   Result := TMatrix4x4.TImpl.Invert(matrix.AsImpl(), return);
   _result := TMatrix4x4((@return)^);
end;

class function TMatrix4x4.Lerp(const matrix1: TMatrix4x4; const matrix2: TMatrix4x4; const amount: Single): TMatrix4x4;
begin
   Result := TMatrix4x4.TImpl.Lerp(matrix1.AsImpl(), matrix2.AsImpl(), amount).AsM4x4()^;
end;

class function TMatrix4x4.Multiply(const value1: TMatrix4x4; const value2: TMatrix4x4): TMatrix4x4;
begin
   Result := (value1.AsImpl() * value2.AsImpl()).AsM4x4()^;
end;

class function TMatrix4x4.Multiply(const value1: TMatrix4x4; const value2: Single): TMatrix4x4;
begin
   Result := (value1.AsImpl() * value2).AsM4x4()^;
end;

class function TMatrix4x4.Negate(const value: TMatrix4x4): TMatrix4x4;
begin
   Result := (-value.AsImpl()).AsM4x4()^;
end;

class function TMatrix4x4.Subtract(const value1: TMatrix4x4; const value2: TMatrix4x4): TMatrix4x4;
begin
   Result := (value1.AsImpl() - value2.AsImpl()).AsM4x4()^;
end;

class function TMatrix4x4.Transpose(const matrix: TMatrix4x4): TMatrix4x4;
begin
   Result := TMatrix4x4.TImpl.Transpose(matrix.AsImpl()).AsM4x4()^;
end;

function TMatrix4x4.Equals(const other: TMatrix4x4): Boolean;

begin
   Result := Self.AsROImpl()^.Equals(other.AsImpl())
end;

function TMatrix4x4.GetDeterminant(): Single;

begin
   Result := Self.AsROImpl()^.GetDeterminant()
end;

function TMatrix4x4.ToString(): string;
begin
   Result := '{ {M11:' + M11.ToString() + ' M12:' + M12.ToString() + ' M13:' + M13.ToString() + ' M14:' + M14.ToString() + '} {M21:' + M21.ToString() + ' M22:' + M22.ToString() + ' M23:' + M23.ToString() + ' M24:' + M24.ToString() + '} {M31:' + M31.ToString() + ' M32:' + M32.ToString() + ' M33:' + M33.ToString() + ' M34:' + M34.ToString() + '} {M41:' + M41.ToString() + ' M42:' + M42.ToString() + ' M43:' + M43.ToString() + ' M44:' + M44.ToString() + '} }'
end;
function TMatrix4x4.GetItem(const row: Integer; const column: Integer): Single;
begin
   Result := Self.AsROImpl()^[row, column];
end;

procedure TMatrix4x4.SetItem(const row: Integer; const column: Integer; const Value: Single);
begin
   Self.AsImpl()[row, column] := value;
end;

class operator TMatrix4x4.Add(const value1: TMatrix4x4; const value2: TMatrix4x4): TMatrix4x4;
begin
   Result := (value1.AsImpl() + value2.AsImpl()).AsM4x4()^;
end;

class operator TMatrix4x4.Equal(const value1: TMatrix4x4; const value2: TMatrix4x4): Boolean;
begin
   Result := value1.AsImpl() = value2.AsImpl();
end;

class operator TMatrix4x4.NotEqual(const value1: TMatrix4x4; const value2: TMatrix4x4): Boolean;
begin
   Result := value1.AsImpl() <> value2.AsImpl();
end;

class operator TMatrix4x4.Multiply(const value1: TMatrix4x4; const value2: TMatrix4x4): TMatrix4x4;
begin
   Result := (value1.AsImpl() * value2.AsImpl()).AsM4x4()^;
end;

class operator TMatrix4x4.Multiply(const value1: TMatrix4x4; const value2: Single): TMatrix4x4;
begin
   Result := (value1.AsImpl() * value2).AsM4x4()^;
end;

class operator TMatrix4x4.Subtract(const value1: TMatrix4x4; const value2: TMatrix4x4): TMatrix4x4;
begin
   Result := (value1.AsImpl() - value2.AsImpl()).AsM4x4()^;
end;

class operator TMatrix4x4.Negative(const value: TMatrix4x4): TMatrix4x4;
begin
   Result := (-value.AsImpl()).AsM4x4()^;
end;

{$ENDREGION 'TMatrix4x4'}

{$REGION 'TVector2'}

{ TVector2 }

constructor TVector2.Create(Value: Single);
begin
   Create(Value, Value);
end;

constructor TVector2.Create(X, Y: Single);
begin
   Self.X := X;
   Self.Y := Y;
end;

constructor TVector2.Create(const Values: array of Single);
begin
   if System.Length(Values) < 2 then
      raise EArgumentOutOfRangeException.Create('Array must contain at least 2 elements.');

   Self.X := Values[0];
   Self.Y := Values[1];
end;

function TVector2.GetElement(Index: Integer): Single;
begin
   case Index of
      0:
         Result := Self.X;
      1:
         Result := Self.Y;
   else
      raise EArgumentOutOfRangeException.Create('Index out of range');
   end;
end;

procedure TVector2.WithElement(Index: Integer; const Value: Single);
begin
   case Index of
      0:
         Self.X := Value;
      1:
         Self.Y := Value;
   else
      raise EArgumentOutOfRangeException.Create('Index out of range');
   end;
end;

class operator TVector2.Divide(const left, right: TVector2): TVector2;
begin
   Result := TVector2.Create(left.X / right.X, left.Y / right.Y);
end;

class operator TVector2.Divide(const left: TVector2; const right: Single): TVector2;
begin
   Result := TVector2.Create(left.X / right, left.Y / right);
end;

class operator TVector2.NotEqual(const left, right: TVector2): Boolean;
begin
   Result := not(left = right);
end;

class operator TVector2.Multiply(const left, right: TVector2): TVector2;
begin
   Result := TVector2.Create(left.X * right.X, left.Y * right.Y);
end;

class operator TVector2.Multiply(const left: TVector2; const right: Single): TVector2;
begin
   Result := left * TVector2.Create(right);
end;

class operator TVector2.Multiply(const left: Single; const right: TVector2): TVector2;
begin
   Result := right * left;
end;

class operator TVector2.Subtract(const left, right: TVector2): TVector2;
begin
   Result := TVector2.Create(left.X - right.X, left.Y - right.Y);
end;

class operator TVector2.Negative(const Value: TVector2): TVector2;
begin
   Result := Zero - Value;
end;

class function TVector2.Zero: TVector2;
begin
   Result := Default (TVector2);
end;

class function TVector2.One: TVector2;
begin
   Result := TVector2.Create(1.0);
end;

class function TVector2.UnitX: TVector2;
begin
   Result := TVector2.Create(1.0, 0.0);
end;

class function TVector2.UnitY: TVector2;
begin
   Result := TVector2.Create(0.0, 1.0);
end;

class function TVector2.Abs(const Value: TVector2): TVector2;
begin
   Result := TVector2.Create(System.Abs(Value.X), System.Abs(Value.Y));
end;

class function TVector2.Add(const left: TVector2; const right: TVector2): TVector2;
begin
   Result := left + right;
end;

class operator TVector2.Add(const left, right: TVector2): TVector2;
begin
   Result := TVector2.Create(left.X + right.X, left.Y + right.Y);
end;

class function TVector2.Clamp(const value1, Min, Max: TVector2): TVector2;
begin
   // We must follow HLSL behavior in the case user specified min value is bigger than max value.
   Result := TVector2.Min(TVector2.Max(value1, Min), Max);
end;

class function TVector2.Distance(const value1, value2: TVector2): Single;
begin
   var DistanceSquared: Single := DistanceSquared(value1, value2);
   Result                      := System.Sqrt(DistanceSquared);
end;

class function TVector2.DistanceSquared(const value1, value2: TVector2): Single;
begin
   var difference: TVector2 := value1 - value2;
   Result                   := TVector2.Dot(difference, difference);
end;

class function TVector2.Divide(const left, right: TVector2): TVector2;
begin
   Result := left / right;
end;

class function TVector2.Divide(const left: TVector2; const Divisor: Single): TVector2;
begin
   Result := left / Divisor;
end;

class function TVector2.Dot(const value1, value2: TVector2): Single;
begin
   Result := (value1.X * value2.X) + (value1.Y * value2.Y);
end;

class function TVector2.Lerp(const value1, value2: TVector2; const Amount: Single): TVector2;
begin
   Result := (value1 * (1.0 - Amount)) + (value2 * Amount);
end;

class function TVector2.Max(const value1, value2: TVector2): TVector2;
begin
   Result := TVector2.Create(Math.Max(value1.X, value2.X), Math.Max(value1.Y, value2.Y));
end;

class function TVector2.Min(const value1, value2: TVector2): TVector2;
begin
   Result := TVector2.Create(Math.Min(value1.X, value2.X), Math.Min(value1.Y, value2.Y));
end;

class function TVector2.Multiply(const left, right: TVector2): TVector2;
begin
   Result := left * right;
end;

class function TVector2.Multiply(const left: TVector2; const right: Single): TVector2;
begin
   Result := left * right;
end;

class function TVector2.Multiply(const left: Single; const right: TVector2): TVector2;
begin
   Result := left * right;
end;

class function TVector2.Negate(const Value: TVector2): TVector2;
begin
   Result := -Value;
end;

class function TVector2.Normalize(const Value: TVector2): TVector2;
begin
   Result := Value / Value.Length();
end;

class function TVector2.Reflect(const Vector, Normal: TVector2): TVector2;
begin
   var Dot: Single := TVector2.Dot(Vector, Normal);
   Result          := Vector - (2.0 * (Dot * Normal));
end;

class function TVector2.SquareRoot(const Value: TVector2): TVector2;
begin
   Result := TVector2.Create(System.Sqrt(Value.X), System.Sqrt(Value.Y));
end;

class function TVector2.Subtract(const left, right: TVector2): TVector2;
begin
   Result := left - right;
end;

class function TVector2.Transform(const Position: TVector2; const Matrix: TMatrix3x2): TVector2;
begin
    raise ENotImplemented.Create('ainda não fiz isso aqui');
  //Result := Transform(position, matrix.AsImpl());
end;

//class function TVector2.Transform(const Position: TVector2; const Matrix: TMatrix4x4): TVector2;
//begin
////   Result.X := Position.X * Matrix.M11 + Position.Y * Matrix.M21 + Matrix.M41;
////   Result.Y := Position.X * Matrix.M12 + Position.Y * Matrix.M22 + Matrix.M42;
//   Result := TVector4.Transform(position, matrix.AsImpl()).AsVector128().AsVector2();
//end;

class function TVector2.TransformNormal(const normal: TVector2; const matrix: TMatrix3x2): TVector2;
begin
raise ENotImplemented.Create('ainda não fiz isso aqui');
//   Result := TransformNormal(normal, matrix.AsImpl());
end;

class function TVector2.Transform(const Value: TVector2; const Rotation: TQuaternion): TVector2;
begin
   var x2: Single := Rotation.X + Rotation.X;
   var y2: Single := Rotation.Y + Rotation.Y;
   var z2: Single := Rotation.Z + Rotation.Z;

   var wz2: Single := Rotation.W * z2;
   var xx2: Single := Rotation.X * x2;
   var xy2: Single := Rotation.X * y2;
   var yy2: Single := Rotation.Y * y2;
   var zz2: Single := Rotation.Z * z2;

   Result := TVector2.Create(Value.X * (1.0 - yy2 - zz2) + Value.Y * (xy2 - wz2), Value.X * (xy2 + wz2) + Value.Y * (1.0 - xx2 - zz2));
end;

//class function TVector2.TransformNormal(const Normal: TVector2; const Matrix: TMatrix4x4): TVector2;
//begin
////   // Considera apenas as componentes rotacionais e de escala da matriz para a transformação
////   Result.X := Normal.X * Matrix.M11 + Normal.Y * Matrix.M21;
////   Result.Y := Normal.X * Matrix.M12 + Normal.Y * Matrix.M22;
////   // Ignora componentes Z e W para manter a normal como um vetor 2D
//   Result := TransformNormal(normal, matrix.AsImpl());
//end;

procedure TVector2.CopyTo(var Arr: array of Single);
begin
   if System.Length(Arr) < Count then
      raise EArgumentException.Create('The destination array is too short.');

   Arr[0] := X;
   Arr[1] := Y;
end;

procedure TVector2.CopyTo(var Arr: array of Single; Index: Integer);
begin
   if System.Length(Arr) < Index + 2 then
      raise EArgumentException.Create('The destination array is too short.');

   Arr[Index]     := X;
   Arr[Index + 1] := Y;
end;

function TVector2.TryCopyTo(var Arr: array of Single): Boolean;
begin
   if (System.Length(Arr) < Count) then
      Exit(False);

   Arr[0] := X;
   Arr[1] := Y;
   Result := True;
end;

function TVector2.Equals(const Other: TVector2): Boolean;
begin
   // Usa SameValue para considerar a precisão de ponto flutuante e NaN.
   Result := SameValue(X, Other.X) and SameValue(Y, Other.Y);
end;

class operator TVector2.Equal(const left, right: TVector2): Boolean;
begin
   Result := (left.X = right.X) and (left.Y = right.Y);
end;

function TVector2.Length: Single;
begin
   var LengthSquared: Single := LengthSquared();
   Result                    := System.Sqrt(LengthSquared);
end;

function TVector2.LengthSquared: Single;
begin
   Result := TVector2.Dot(Self, Self);
end;

function TVector2.ToString: string;
begin
   Result := Format('<%g, %g>', [X, Y]);
end;

function TVector2.ToString(const AFormat: string): string;
begin
   Result := Format('<%' + AFormat + ', %' + AFormat + '>', [X, Y]);
end;

function TVector2.IsEmpty(): Boolean;
begin
   Result := (Self.X = 0) and (Self.Y = 0);
end;

{$ENDREGION 'TVector2'}

{$REGION 'TVector3'}

{ TVector3 }

class function TVector3.GetZero(): TVector3;
begin
   Result := Default(TVector3);
end;

class function TVector3.GetOne(): TVector3;
begin
   Result := TVector3.Create(Single(1.0));
end;

class function TVector3.GetUnitX(): TVector3;
begin
   Result := TVector3.Create(Single(1.0), Single(0.0), Single(0.0));
end;

class function TVector3.GetUnitY(): TVector3;
begin
   Result := TVector3.Create(Single(0.0), Single(1.0), Single(0.0));
end;

class function TVector3.GetUnitZ(): TVector3;
begin
   Result := TVector3.Create(Single(0.0), Single(0.0), Single(1.0));
end;

constructor TVector3.Create(const value: Single);
begin
   Create(value, value, value);

end;

constructor TVector3.Create(const value: TVector2; const z: Single);
begin
   Create(value.X, value.Y, z);

end;

constructor TVector3.Create(const x: Single; const y: Single; const z: Single);
begin
   Self.X := x;
   Self.Y := y;
   Self.Z := z;
end;

constructor TVector3.Create(const values: TReadOnlySpan<Single>);
begin
   if (values.Length < 3) then
   begin
      raise EArgumentOutOfRangeException.Create('values');
   end;

   Self.X := values[0];
   Self.Y := values[1];
   Self.Z := values[2];
end;

class function TVector3.Abs(const value: TVector3): TVector3;
begin
   Exit(TVector3.Create(System.Abs(value.X), System.Abs(value.Y), System.Abs(value.Z)));
end;

class function TVector3.Add(const left: TVector3; const right: TVector3): TVector3;
begin

   Exit(left + right);
end;

class function TVector3.Clamp(const value1: TVector3; const min: TVector3; const max: TVector3): TVector3;
begin
   Exit(TVector3.Min(TVector3.Max(value1, min), max));
end;

class function TVector3.Cross(const vector1: TVector3; const vector2: TVector3): TVector3;
begin

   Exit(TVector3.Create((vector1.Y * vector2.Z) - (vector1.Z * vector2.Y), (vector1.Z * vector2.X) - (vector1.X * vector2.Z), (vector1.X * vector2.Y) - (vector1.Y * vector2.X)));
end;

class function TVector3.Distance(const value1: TVector3; const value2: TVector3): Single;
begin
   var distanceSquared: Single := DistanceSquared(value1, value2);

   Exit(System.Sqrt(distanceSquared));
end;

class function TVector3.DistanceSquared(const value1: TVector3; const value2: TVector3): Single;
begin
   var difference: TVector3 := value1 - value2;

   Exit(Dot(difference, difference));
end;

class function TVector3.Divide(const left: TVector3; const right: TVector3): TVector3;
begin

   Exit(left / right);
end;

class function TVector3.Divide(const left: TVector3; const divisor: Single): TVector3;
begin

   Exit(left / divisor);
end;

class function TVector3.Dot(const vector1: TVector3; const vector2: TVector3): Single;
begin

   Exit((vector1.X * vector2.X) + (vector1.Y * vector2.Y) + (vector1.Z * vector2.Z));
end;

class function TVector3.Lerp(const value1: TVector3; const value2: TVector3; const amount: Single): TVector3;
begin

   Exit((value1 * (Single(1.0) - amount)) + (value2 * amount));
end;

class function TVector3.Max(const value1: TVector3; const value2: TVector3): TVector3;
begin

   Exit(TVector3.Create(IfThen((value1.X > value2.X), value1.X, value2.X), IfThen((value1.Y > value2.Y), value1.Y, value2.Y), IfThen((value1.Z > value2.Z), value1.Z, value2.Z)));
end;

class function TVector3.Min(const value1: TVector3; const value2: TVector3): TVector3;
begin

   Exit(TVector3.Create(IfThen((value1.X < value2.X), value1.X, value2.X), IfThen((value1.Y < value2.Y), value1.Y, value2.Y), IfThen((value1.Z < value2.Z), value1.Z, value2.Z)));
end;

class function TVector3.Multiply(const left: TVector3; const right: TVector3): TVector3;
begin

   Exit(left * right);
end;

class function TVector3.Multiply(const left: TVector3; const right: Single): TVector3;
begin

   Exit(left * right);
end;

class function TVector3.Multiply(const left: Single; const right: TVector3): TVector3;
begin

   Exit(left * right);
end;

class function TVector3.Negate(const value: TVector3): TVector3;
begin

   Exit(-value);
end;

class function TVector3.Normalize(const value: TVector3): TVector3;
begin

   Exit(value / value.Length());
end;

class function TVector3.Reflect(const vector: TVector3; const normal: TVector3): TVector3;
begin
   var dot: Single := Dot(vector, normal);

   Exit(vector - (Single(2.0) * (dot * normal)));
end;

class function TVector3.SquareRoot(const value: TVector3): TVector3;
begin
   Exit(TVector3.Create(System.Sqrt(value.X), System.Sqrt(value.Y), System.Sqrt(value.Z)));
end;

class function TVector3.Subtract(const left: TVector3; const right: TVector3): TVector3;
begin
   Exit(left - right);
end;

class function TVector3.Transform(const position: TVector3; const matrix: TMatrix4x4): TVector3;
begin
   raise ENotImplemented.Create('Error Message');
//   Result := TVector4.Transform(position, matrix.AsImpl()).AsVector128().AsVector3();
end;

class function TVector3.Transform(const value: TVector3; const rotation: TQuaternion): TVector3;
begin
   var x2: Single := rotation.X + rotation.X;
   var y2: Single := rotation.Y + rotation.Y;
   var z2: Single := rotation.Z + rotation.Z;

   var wx2: Single := rotation.W * x2;
   var wy2: Single := rotation.W * y2;
   var wz2: Single := rotation.W * z2;
   var xx2: Single := rotation.X * x2;
   var xy2: Single := rotation.X * y2;
   var xz2: Single := rotation.X * z2;
   var yy2: Single := rotation.Y * y2;
   var yz2: Single := rotation.Y * z2;
   var zz2: Single := rotation.Z * z2;

   Exit(TVector3.Create(value.X * (Single(1.0) - yy2 - zz2) + value.Y * (xy2 - wz2) + value.Z * (xz2 + wy2), value.X * (xy2 + wz2) + value.Y * (Single(1.0) - xx2 - zz2) + value.Z * (yz2 - wx2), value.X * (xz2 - wy2) + value.Y * (yz2 + wx2) + value.Z * (Single(1.0) - xx2 - yy2)));
end;

class function TVector3.TransformNormal(const normal: TVector3; const matrix: TMatrix4x4): TVector3;
begin
raise ENotImplemented.Create('ainda não fiz isso aqui');

//   Exit(TransformNormal(normal, matrix.AsImpl()));
end;

procedure TVector3.CopyTo(var array_: TArray<Single>);
begin
   // We explicitly don't check for `null` because historically this has thrown `NullReferenceException` for perf reasons

   if (System.Length(array_) < Count) then
      raise EArgumentException.Create('O destino é muito curto.');

   array_[0] := Self.X;
   array_[1] := Self.Y;
   array_[2] := Self.Z;
end;

procedure TVector3.CopyTo(var array_: TArray<Single>; const index: Integer);
begin
   // We explicitly don't check for `null` because historically this has thrown `NullReferenceException` for perf reasons

   if UInt32(index) >= UInt32(System.Length(array_)) then
      raise EArgumentOutOfRangeException.Create('O índice estava fora do intervalo. Deve ser não negativo e menor ou igual ao tamanho da coleção.');

   if (System.Length(array_) - index) < Count then
      raise EArgumentException.Create('O destino é muito curto.');

   array_[index + 0] := Self.X;
   array_[index + 1] := Self.Y;
   array_[index + 2] := Self.Z;
end;

procedure TVector3.CopyTo(var destination: TSpan<Single>);
begin
   if (destination.Length < Count) then
      raise EArgumentException.Create('O destino é muito curto.');

   Move(Self, destination.GetReference()^, SizeOf(Self));
end;

function TVector3.TryCopyTo(var destination: TSpan<Single>): Boolean;
begin
   if (destination.Length < Count) then
      Exit(false);

   Move(Self, destination.GetReference()^, SizeOf(Self));

   Result := true;
end;

function TVector3.Equals(const other: TVector3): Boolean;
begin
   // This function needs to account for floating-point equality around NaN
   // and so must behave equivalently to the underlying float/double.Equals

//   if (Vector128.IsHardwareAccelerated) then
//   begin
//
//      Exit(Self.AsVector128().Equals(other.AsVector128()));
//   end;

   Result := (self.X = other.X) and (self.Y = other.Y) and (self.Z = other.Z);
end;

function TVector3.Length(): Single;
begin
   var lengthSquared: Single := LengthSquared();

   Exit(System.Sqrt(lengthSquared));
end;

function TVector3.LengthSquared(): Single;
begin

   Exit(Dot(Self, Self));
end;

function TVector3.ToString(): string;
begin

   Exit(ToString('G', FormatSettings));
end;

function TVector3.ToString(const format: string): string;
begin

   Exit(ToString(format, FormatSettings));
end;

function TVector3.ToString(const format: string; const formatProvider: TFormatSettings): string;
begin
   var separator: string := formatProvider.ThousandSeparator;

   Result := '<' + FormatFloat(format, X, formatProvider) + '' + separator + ' ' + FormatFloat(format, Y, formatProvider) + '' + separator + ' ' + FormatFloat(format, Z, formatProvider) + '>';
end;

function TVector3.GetItem(const index: Integer): Single;
begin
   Result := Self.GetElement(index);
end;

procedure TVector3.SetItem(const index: Integer; const Value: Single);
begin
   Self := Self.WithElement(index, value);
end;

class operator TVector3.Add(const left: TVector3; const right: TVector3): TVector3;
begin
   Exit(TVector3.Create(left.X + right.X, left.Y + right.Y, left.Z + right.Z));
end;

class operator TVector3.Divide(const left: TVector3; const right: TVector3): TVector3;
begin
   Exit(TVector3.Create(left.X / right.X, left.Y / right.Y, left.Z / right.Z));
end;

class operator TVector3.Divide(const value1: TVector3; const value2: Single): TVector3;
begin
   Exit(value1 / TVector3.Create(value2));
end;

class operator TVector3.Equal(const left: TVector3; const right: TVector3): Boolean;
begin
   Exit(((left.X = right.X)) and ((left.Y = right.Y)) and ((left.Z = right.Z)));
end;

class operator TVector3.NotEqual(const left: TVector3; const right: TVector3): Boolean;
begin
   Exit(not (left = right));
end;

class operator TVector3.Multiply(const left: TVector3; const right: TVector3): TVector3;
begin
begin

   Exit(TVector3.Create(left.X * right.X, left.Y * right.Y, left.Z * right.Z));
end;
end;

class operator TVector3.Multiply(const left: TVector3; const right: Single): TVector3;
begin
begin

   Exit(left * TVector3.Create(right));
end;
end;

class operator TVector3.Multiply(const left: Single; const right: TVector3): TVector3;
begin
begin

   Exit(right * left);
end;
end;

class operator TVector3.Subtract(const left: TVector3; const right: TVector3): TVector3;
begin
begin

   Exit(TVector3.Create(left.X - right.X, left.Y - right.Y, left.Z - right.Z));
end;
end;

class operator TVector3.Negative(const value: TVector3): TVector3;
begin
begin

   Exit(Zero - value);
end;
end;

{$ENDREGION 'TVector3'}

{$REGION 'TVector2Helper'}

 { TVector2Helper }

class function TVector2Helper.Transform(const position: TVector2; const matrix: TMatrix4x4): TVector2;
begin
   raise ENotImplemented.Create('Error Message');
//   Exit(TVector4.Transform(position, matrix.AsImpl()).AsVector128().AsVector2());
end;

class function TVector2Helper.TransformNormal(const normal: TVector2; const matrix: TMatrix4x4): TVector2;
begin
raise ENotImplemented.Create('ainda não fiz isso aqui');

//Exit(TransformNormal(normal, matrix.AsImpl()));
end;

//class function TVector2Helper.TransformNormal(const normal: TVector2; const matrix: TMatrix4x4.TImpl): TVector2;
//begin
//   raise ENotImplemented.Create('Error Message');
//
////   var _result: TVector4 := matrix.X * normal.X;
////   _result := _result + matrix.Y * normal.Y;
////   Exit(_result.AsVector128().AsVector2());
//end;

//class function TVector2Helper.Transform(position: TVector2; matrix: TMatrix3x2.TImpl): TVector2;
//begin
//   var return: TVector2 := matrix.X * position.X;
//
//   return := return + matrix.Y * position.Y;
//   return := return + matrix.Z;
//
//   Result := return;
//end;

//class function TVector2Helper.TransformNormal(const normal: TVector2; const matrix: TMatrix3x2.TImpl): TVector2;
//begin
//   var return: TVector2 := matrix.X * normal.X;
//
//   result := return + matrix.Y * normal.Y;
//
//   Result := return;
//end;

{$ENDREGION 'TVector2Helper'}

{$REGION 'TVector3Helper'}

//class function TVector3Helper.TransformNormal(const normal: TVector3; const matrix: TMatrix4x4.TImpl): TVector3;
//begin
//   raise ENotImplemented.Create('Error Message');
////   var _result: TVector4 := matrix.X * normal.X;
////   _result := _result + matrix.Y * normal.Y;
////   _result := _result + matrix.Z * normal.Z;
////   Exit(_result.AsVector128().AsVector3());
//end;

function TVector3Helper.GetElement(const index: Integer): Single;
begin
   if (UInt32((index)) >= UInt32((TVector3.Count))) then
   begin
      raise EArgumentOutOfRangeException.Create('index');
   end;

   Exit(Self.GetElementUnsafe(index));
end;

function TVector3Helper.WithElement(const index: Integer; const value: Single): TVector3;
begin
   if (UInt32((index)) >= UInt32((TVector3.Count))) then
   begin
      raise EArgumentOutOfRangeException.Create('index');
   end;

   var _result: TVector3 := Self;
   _result.SetElementUnsafe(index, value);

   Exit(_result);
end;

function TVector3Helper.GetElementUnsafe(const index: Integer): Single;
begin
   Assert((index >= 0) and (index < TVector3.Count));
   var address: PSingle := @Self.X;
   inc(address, index);
   Exit(address^);
end;

procedure TVector3Helper.SetElementUnsafe(const index: Integer; const value: Single);
begin
   Assert((index >= 0) and (index < TVector3.Count));
   var address: PSingle := @Self.X;
   inc(address, index);
   address^ := value;
end;

{$ENDREGION 'TVector3Helper'}


{$REGION 'TQuaternionHelper'}

constructor TQuaternionHelper.Create(const vectorPart: TVector3; const scalarPart: Single);
begin
   Self.X := vectorPart.X;
   Self.Y := vectorPart.Y;
   Self.Z := vectorPart.Z;
   Self.W := scalarPart;
end;

class function TQuaternionHelper.CreateFromAxisAngle(const axis: TVector3; const angle: Single): TQuaternion;
begin
   var ans: TQuaternion;

   var halfAngle: Single := angle * Single(0.5);
   var s: Single := System.Sin(halfAngle);
   var c: Single := System.Cos(halfAngle);


   ans.X := axis.X * s;
   ans.Y := axis.Y * s;
   ans.Z := axis.Z * s;
   ans.W := c;

   Exit(ans);
end;

class function TQuaternionHelper.Multiply(const value1: TQuaternion; const value2: TVector4): TQuaternion;
begin
   Exit(TQuaternion.Create(value1.X * value2.X, value1.Y * value2.Y, value1.Z * value2.Z, value1.W * value2.W));
end;

function TQuaternionHelper.GetElement(const index: Integer): Single;
begin
   if (UInt32((index)) >= UInt32((Self.Count))) then
   begin
      raise EArgumentOutOfRangeException.Create('index');
   end;

   Exit(Self.GetElementUnsafe(index));
end;

function TQuaternionHelper.WithElement(const index: Integer; const value: Single): TQuaternion;
begin
   if (UInt32((index)) >= UInt32((Self.Count))) then
   begin
      raise EArgumentOutOfRangeException.Create('index');
   end;

   var _result: TQuaternion := Self;
   _result.SetElementUnsafe(index, value);

   Exit(_result);
end;

function TQuaternionHelper.GetElementUnsafe(const index: Integer): Single;
begin
   Assert((index >= 0) and (index < Self.Count));
   var address: PSingle := @Self.X;
   Inc(address, index);
   Exit(address^);
end;

procedure TQuaternionHelper.SetElementUnsafe(const index: Integer; const value: Single);
begin
   Assert((index >= 0) and (index < Self.Count));
   var address: PSingle := @Self.X;
   Inc(address, index);
   address^ := value;
end;

{$ENDREGION 'TQuaternionHelper'}

{$REGION 'TVector4Helper'}

function TVector4Helper.GetElement(const index: Integer): Single;
begin
   if (UInt32((index)) >= UInt32((TVector4.Count))) then
   begin
      raise EArgumentOutOfRangeException.Create('index');
   end;

   Exit(Self.GetElementUnsafe(index));
end;

function TVector4Helper.WithElement(const index: Integer; const value: Single): TVector4;
begin
   if (UInt32((index)) >= UInt32((TVector4.Count))) then
   begin
      raise EArgumentOutOfRangeException.Create('index');
   end;

   var _result: TVector4 := Self;
   _result.SetElementUnsafe(index, value);

   Exit(_result);
end;

function TVector4Helper.GetElementUnsafe(const index: Integer): Single;
begin
   Assert((index >= 0) and (index < TVector4.Count));
   var address: PSingle := @Self.X;
   inc(address, index);
   Exit(address^);
end;

procedure TVector4Helper.SetElementUnsafe(const index: Integer; const value: Single);
begin
   Assert((index >= 0) and (index < TVector4.Count));
   var address: PSingle := @Self.X;
   inc(address, index);
   address^ := Value;
end;

//class function TVector4Helper.Transform(const position: TVector2; const matrix: TMatrix4x4.TImpl): TVector4;
//begin
//   var _result: TVector4 := matrix.X * position.X;
//
//   _result := _result + matrix.Y * position.Y;
//   _result := _result + matrix.W;
//
//   Exit(_result);
//end;

//class function TVector4Helper.Transform(const position: TVector3; const matrix: TMatrix4x4.TImpl): TVector4;
//begin
//   var _result: TVector4 := matrix.X * position.X;
//
//   _result := _result + matrix.Y * position.Y;
//   _result := _result + matrix.Z * position.Z;
//   _result := _result + matrix.W;
//
//   Exit(_result);
//end;

//class function TVector4Helper.Transform(const vector: TVector4; const matrix: TMatrix4x4.TImpl): TVector4;
//begin
//   var _result: TVector4 := matrix.X * vector.X;
//
//   _result := _result + matrix.Y * vector.Y;
//   _result := _result + matrix.Z * vector.Z;
//   _result := _result + matrix.W * vector.W;
//
//   Exit(_result);
//end;


{$ENDREGION 'TVector4Helper'}


{$REGION 'TVector4'}

{ TVector4 }

class function TVector4.GetZero(): TVector4;
begin
   Result := default(TVector4);
end;

class function TVector4.GetOne(): TVector4;
begin
   Result := TVector4.Create(Single(1.0));
end;

class function TVector4.GetUnitX(): TVector4;
begin
   Result := TVector4.Create(Single(1.0), Single(0.0), Single(0.0), Single(0.0));
end;

class function TVector4.GetUnitY(): TVector4;
begin
   Result := TVector4.Create(Single(0.0), Single(1.0), Single(0.0), Single(0.0));
end;

class function TVector4.GetUnitZ(): TVector4;
begin
   Result := TVector4.Create(Single(0.0), Single(0.0), Single(1.0), Single(0.0));
end;

class function TVector4.GetUnitW(): TVector4;
begin
   Result := TVector4.Create(Single(0.0), Single(0.0), Single(0.0), Single(1.0));
end;

constructor TVector4.Create(const value: Single);
begin
   Create(value, value, value, value);

end;

constructor TVector4.Create(const value: TVector2; const z: Single; const w: Single);
begin
   Create(value.X, value.Y, z, w);

end;

constructor TVector4.Create(const value: TVector3; const w: Single);
begin
   Create(value.X, value.Y, value.Z, w);
end;

constructor TVector4.Create(const x: Single; const y: Single; const z: Single; const w: Single);
begin
   Self.X := x;
   Self.Y := y;
   Self.Z := z;
   Self.W := w;
end;

constructor TVector4.Create(const values: TReadOnlySpan<Single>);
begin
   if (values.Length < 4) then
      raise EArgumentOutOfRangeException.Create('values');

   Self.X := values[0];
   Self.Y := values[1];
   Self.Z := values[2];
   Self.W := values[3];
end;

class function TVector4.Abs(const value: TVector4): TVector4;
begin
   Result := TVector4.Create(System.Abs(value.X), System.Abs(value.Y), System.Abs(value.Z), System.Abs(value.W));
end;

class function TVector4.Add(const left: TVector4; const right: TVector4): TVector4;
begin
   Result := left + right;
end;

class function TVector4.Clamp(const value1: TVector4; const min: TVector4; const max: TVector4): TVector4;
begin
   Result := TVector4.Min(TVector4.Max(value1, min), max);
end;

class function TVector4.Distance(const value1: TVector4; const value2: TVector4): Single;
begin
   var distanceSquared: Single := DistanceSquared(value1, value2);
   Result := System.Sqrt(distanceSquared);
end;

class function TVector4.DistanceSquared(const value1: TVector4; const value2: TVector4): Single;
begin
   var difference: TVector4 := value1 - value2;

   Exit(Dot(difference, difference));
end;

class function TVector4.Divide(const left: TVector4; const right: TVector4): TVector4;
begin

   Exit(left / right);
end;

class function TVector4.Divide(const left: TVector4; const divisor: Single): TVector4;
begin

   Exit(left / divisor);
end;

class function TVector4.Dot(const vector1: TVector4; const vector2: TVector4): Single;
begin

   Exit((vector1.X * vector2.X) + (vector1.Y * vector2.Y) + (vector1.Z * vector2.Z) + (vector1.W * vector2.W));
end;

class function TVector4.Lerp(const value1: TVector4; const value2: TVector4; const amount: Single): TVector4;
begin

   Exit((value1 * (Single(1.0) - amount)) + (value2 * amount));
end;

class function TVector4.Max(const value1: TVector4; const value2: TVector4): TVector4;
begin

   Exit(TVector4.Create(IfThen((value1.X > value2.X), value1.X, value2.X), IfThen((value1.Y > value2.Y), value1.Y, value2.Y), IfThen((value1.Z > value2.Z), value1.Z, value2.Z), IfThen((value1.W > value2.W), value1.W, value2.W)));
end;

class function TVector4.Min(const value1: TVector4; const value2: TVector4): TVector4;
begin

   Exit(TVector4.Create(IfThen((value1.X < value2.X), value1.X, value2.X), IfThen((value1.Y < value2.Y), value1.Y, value2.Y), IfThen((value1.Z < value2.Z), value1.Z, value2.Z), IfThen((value1.W < value2.W), value1.W, value2.W)));
end;

class function TVector4.Multiply(const left: TVector4; const right: TVector4): TVector4;
begin

   Exit(left * right);
end;

class function TVector4.Multiply(const left: TVector4; const right: Single): TVector4;
begin

   Exit(left * right);
end;

class function TVector4.Multiply(const left: Single; const right: TVector4): TVector4;
begin

   Exit(left * right);
end;

class function TVector4.Negate(const value: TVector4): TVector4;
begin

   Exit(-value);
end;

class function TVector4.Normalize(const vector: TVector4): TVector4;
begin

   Exit(vector / vector.Length());
end;

class function TVector4.SquareRoot(const value: TVector4): TVector4;
begin
   Result := TVector4.Create(System.Sqrt(value.X), System.Sqrt(value.Y), System.Sqrt(value.Z), System.Sqrt(value.W));
end;

class function TVector4.Subtract(const left: TVector4; const right: TVector4): TVector4;
begin
   Result := left - right;
end;

class function TVector4.Transform(const position: TVector2; const matrix: TMatrix4x4): TVector4;
begin
raise ENotImplemented.Create('ainda não fiz isso aqui');
//   Result := Transform(position, matrix.AsImpl());
end;

class function TVector4.Transform(const value: TVector2; const rotation: TQuaternion): TVector4;
begin
   var x2: Single := rotation.X + rotation.X;
   var y2: Single := rotation.Y + rotation.Y;
   var z2: Single := rotation.Z + rotation.Z;

   var wx2: Single := rotation.W * x2;
   var wy2: Single := rotation.W * y2;
   var wz2: Single := rotation.W * z2;
   var xx2: Single := rotation.X * x2;
   var xy2: Single := rotation.X * y2;
   var xz2: Single := rotation.X * z2;
   var yy2: Single := rotation.Y * y2;
   var yz2: Single := rotation.Y * z2;
   var zz2: Single := rotation.Z * z2;

   Exit(TVector4.Create(value.X * (Single(1.0) - yy2 - zz2) + value.Y * (xy2 - wz2), value.X * (xy2 + wz2) + value.Y * (Single(1.0) - xx2 - zz2), value.X * (xz2 - wy2) + value.Y * (yz2 + wx2), Single(1.0)));
end;

class function TVector4.Transform(const position: TVector3; const matrix: TMatrix4x4): TVector4;
begin
raise ENotImplemented.Create('ainda não fiz isso aqui');
//   Result := Transform(position, matrix.AsImpl());
end;

class function TVector4.Transform(const value: TVector3; const rotation: TQuaternion): TVector4;
begin
   var x2: Single := rotation.X + rotation.X;
   var y2: Single := rotation.Y + rotation.Y;
   var z2: Single := rotation.Z + rotation.Z;

   var wx2: Single := rotation.W * x2;
   var wy2: Single := rotation.W * y2;
   var wz2: Single := rotation.W * z2;
   var xx2: Single := rotation.X * x2;
   var xy2: Single := rotation.X * y2;
   var xz2: Single := rotation.X * z2;
   var yy2: Single := rotation.Y * y2;
   var yz2: Single := rotation.Y * z2;
   var zz2: Single := rotation.Z * z2;

   Exit(TVector4.Create(value.X * (Single(1.0) - yy2 - zz2) + value.Y * (xy2 - wz2) + value.Z * (xz2 + wy2), value.X * (xy2 + wz2) + value.Y * (Single(1.0) - xx2 - zz2) + value.Z * (yz2 - wx2), value.X * (xz2 - wy2) + value.Y * (yz2 + wx2) + value.Z * (Single(1.0) - xx2 - yy2), Single(1.0)));
end;

class function TVector4.Transform(const vector: TVector4; const matrix: TMatrix4x4): TVector4;
begin

raise ENotImplemented.Create('ainda não fiz isso aqui');
//   Result := Transform(vector, matrix.AsImpl())
end;

class function TVector4.Transform(const value: TVector4; const rotation: TQuaternion): TVector4;
begin
   var x2: Single := rotation.X + rotation.X;
   var y2: Single := rotation.Y + rotation.Y;
   var z2: Single := rotation.Z + rotation.Z;

   var wx2: Single := rotation.W * x2;
   var wy2: Single := rotation.W * y2;
   var wz2: Single := rotation.W * z2;
   var xx2: Single := rotation.X * x2;
   var xy2: Single := rotation.X * y2;
   var xz2: Single := rotation.X * z2;
   var yy2: Single := rotation.Y * y2;
   var yz2: Single := rotation.Y * z2;
   var zz2: Single := rotation.Z * z2;

   Exit(TVector4.Create(value.X * (Single(1.0) - yy2 - zz2) + value.Y * (xy2 - wz2) + value.Z * (xz2 + wy2), value.X * (xy2 + wz2) + value.Y * (Single(1.0) - xx2 - zz2) + value.Z * (yz2 - wx2), value.X * (xz2 - wy2) + value.Y * (yz2 + wx2) + value.Z * (Single(1.0) - xx2 - yy2), value.W));
end;

procedure TVector4.CopyTo(const array_: TArray<Single>);
begin
   // We explicitly don't check for `null` because historically this has thrown `NullReferenceException` for perf reasons

   if (System.Length(array_) < Count) then
      raise EArgumentException.Create('O destino é muito curto.');

   array_[0] := Self.X;
   array_[1] := Self.Y;
   array_[2] := Self.Z;
   array_[4] := Self.W;
end;

procedure TVector4.CopyTo(const array_: TArray<Single>; const index: Integer);
begin
   // We explicitly don't check for `null` because historically this has thrown `NullReferenceException` for perf reasons

   if UInt32(index) >= UInt32(System.Length(array_)) then
      raise EArgumentOutOfRangeException.Create('O índice estava fora do intervalo. Deve ser não negativo e menor ou igual ao tamanho da coleção.');

   if (System.Length(array_) - index) < Count then
      raise EArgumentException.Create('O destino é muito curto.');

   array_[index + 0] := Self.X;
   array_[index + 1] := Self.Y;
   array_[index + 2] := Self.Z;
   array_[index + 3] := Self.W;
end;

procedure TVector4.CopyTo(const destination: TSpan<Single>);
begin
   if (destination.Length < Count) then
      raise EArgumentException.Create('O destino é muito curto.');

   Move(Self, destination.GetReference()^, SizeOf(Self));
end;

function TVector4.TryCopyTo(const destination: TSpan<Single>): Boolean;
begin
   if (destination.Length < Count) then
      Exit(false);

   Move(Self, destination.GetReference()^, SizeOf(Self));

   Result := true;
end;

function TVector4.Equals(const other: TVector4): Boolean;
begin
   // This function needs to account for floating-point equality around NaN
   // and so must behave equivalently to the underlying float/double.Equals

//   if (Vector128.IsHardwareAccelerated) then
//   begin
//
//      Exit(Self.AsVector128().Equals(other.AsVector128()));
//   end;

   Result := (self.X = other.X) and (self.Y = other.Y) and (self.Z = other.Z) and (self.W = other.W);
end;

function TVector4.Length(): Single;
begin
   var lengthSquared: Single := LengthSquared();

   Exit(System.Sqrt(lengthSquared));
end;

function TVector4.LengthSquared(): Single;
begin

   Exit(Dot(Self, Self));
end;

function TVector4.ToString(): string;
begin
   Exit(ToString('G', FormatSettings));
end;

function TVector4.ToString(const format: string): string;
begin
   Exit(ToString(format, FormatSettings));
end;

function TVector4.ToString(const format: string; const formatProvider: TFormatSettings): string;
begin
   var separator: string := formatProvider.ThousandSeparator;

   Result := '<' + FormatFloat(format, X, formatProvider) + separator + ' ' + FormatFloat(format, Y, formatProvider) + separator + ' ' + FormatFloat(format, Z, formatProvider) + separator + ' ' + FormatFloat(format, W, formatProvider) + '>';
end;
function TVector4.GetItem(const index: Integer): Single;
begin
   Result := Self.GetElement(index);
end;

procedure TVector4.SetItem(const index: Integer; const Value: Single);
begin
   Self := Self.WithElement(index, value);end;

class operator TVector4.Add(const left: TVector4; const right: TVector4): TVector4;
begin
begin

   Exit(TVector4.Create(left.X + right.X, left.Y + right.Y, left.Z + right.Z, left.W + right.W));
end;
end;

class operator TVector4.Divide(const left: TVector4; const right: TVector4): TVector4;
begin
   Exit(TVector4.Create(left.X / right.X, left.Y / right.Y, left.Z / right.Z, left.W / right.W));
end;

class operator TVector4.Divide(const value1: TVector4; const value2: Single): TVector4;
begin
   Exit(value1 / TVector4.Create(value2));
end;

class operator TVector4.Equal(const left: TVector4; const right: TVector4): Boolean;
begin
   Result := (left.X = right.X) and (left.Y = right.Y) and (left.Z = right.Z) and (left.W = right.W);
end;

class operator TVector4.NotEqual(const left: TVector4; const right: TVector4): Boolean;
begin
   Exit(not (left = right));
end;

class operator TVector4.Multiply(const left: TVector4; const right: TVector4): TVector4;
begin
   Exit(TVector4.Create(left.X * right.X, left.Y * right.Y, left.Z * right.Z, left.W * right.W));
end;

class operator TVector4.Multiply(const left: TVector4; const right: Single): TVector4;
begin
   Exit(left * TVector4.Create(right));
end;

class operator TVector4.Multiply(const left: Single; const right: TVector4): TVector4;
begin
   Exit(right * left);
end;

class operator TVector4.Subtract(const left: TVector4; const right: TVector4): TVector4;
begin
   Exit(TVector4.Create(left.X - right.X, left.Y - right.Y, left.Z - right.Z, left.W - right.W));
end;

class operator TVector4.Negative(const value: TVector4): TVector4;
begin
   Exit(Zero - value);
end;

{$ENDREGION 'TVector4'}

{$REGION 'TPlane'}

{ TPlane }

constructor TPlane.Create(const x: Single; const y: Single; const z: Single; const d: Single);
begin
   Self.Normal := TVector3.Create(x, y, z);
   Self.D := d;
end;

constructor TPlane.Create(const normal: TVector3; const d: Single);
begin
   Self.Normal := normal;
   Self.D := d;
end;

constructor TPlane.Create(const value: TVector4);
begin
   Self.Normal := TVector3.Create(value.X, value.Y, value.Z);
   Self.D := value.W;
end;

class function TPlane.CreateFromVertices(const point1: TVector3; const point2: TVector3; const point3: TVector3): TPlane;
begin
//   if (Vector128.IsHardwareAccelerated) then
//   begin
//      var a: TVector3 := point2 - point1;
//      var b: TVector3 := point3 - point1;
//
//      // N = Cross(a, b)
//      var n: TVector3 := Vector3.Cross(a, b);
//      var normal: TVector3 := Vector3.Normalize(n);
//
//      // D = - Dot(N, point1)
//      var d: Single := -Vector3.Dot(normal, point1);
//
//      Exit(TPlane.Create(normal, d));
//   end
//   else
   begin
      var ax: Single := point2.X - point1.X;
      var ay: Single := point2.Y - point1.Y;
      var az: Single := point2.Z - point1.Z;

      var bx: Single := point3.X - point1.X;
      var by: Single := point3.Y - point1.Y;
      var bz: Single := point3.Z - point1.Z;

      // N=Cross(a,b)
      var nx: Single := ay * bz - az * by;
      var ny: Single := az * bx - ax * bz;
      var nz: Single := ax * by - ay * bx;

      // Normalize(N)
      var ls: Single := nx * nx + ny * ny + nz * nz;
      var invNorm: Single := Single(1.0) / System.Sqrt(ls);

      var normal: TVector3 := TVector3.Create(nx * invNorm, ny * invNorm, nz * invNorm);

      Exit(TPlane.Create(normal, -(normal.X * point1.X + normal.Y * point1.Y + normal.Z * point1.Z)));
   end;
end;

class function TPlane.Dot(const plane: TPlane; const value: TVector4): Single;
begin

   Exit((plane.Normal.X * value.X) + (plane.Normal.Y * value.Y) + (plane.Normal.Z * value.Z) + (plane.D * value.W));
end;

class function TPlane.DotCoordinate(const plane: TPlane; const value: TVector3): Single;
begin
//   if (Vector128.IsHardwareAccelerated) then
//   begin
//
//      Exit(Vector3.Dot(plane.Normal, value) + plane.D);
//   end
//   else
   begin
      Exit(plane.Normal.X * value.X + plane.Normal.Y * value.Y + plane.Normal.Z * value.Z + plane.D);
   end;
end;

class function TPlane.DotNormal(const plane: TPlane; const value: TVector3): Single;
begin
//   if (Vector128.IsHardwareAccelerated) then
//   begin
//
//      Exit(Vector3.Dot(plane.Normal, value));
//   end
//   else
   begin

      Exit(plane.Normal.X * value.X + plane.Normal.Y * value.Y + plane.Normal.Z * value.Z);
   end;
end;

class function TPlane.Normalize(const value: TPlane): TPlane;
begin
//   if (Vector128.IsHardwareAccelerated) then
//   begin
//      var normalLengthSquared: Single := value.Normal.LengthSquared();
//      if (MathF.Abs(normalLengthSquared - Single(1.0)) < NormalizeEpsilon) then
//      begin
//
//         Exit(value);
//      end;
//      var normalLength: Single := MathF.Sqrt(normalLengthSquared);
//
//      Exit(TPlane.Create(value.Normal / normalLength, value.D / normalLength));
//   end
//   else
   begin
      var f: Single := value.Normal.X * value.Normal.X + value.Normal.Y * value.Normal.Y + value.Normal.Z * value.Normal.Z;

      if (System.Abs(f - Single(1.0)) < NormalizeEpsilon) then
      begin

         Exit(value);
      end;

      var fInv: Single := Single(1.0) / System.Sqrt(f);

      Exit(TPlane.Create(value.Normal.X * fInv, value.Normal.Y * fInv, value.Normal.Z * fInv, value.D * fInv));
   end;
end;

class function TPlane.Transform(const plane: TPlane; const matrix: TMatrix4x4): TPlane;
begin
   var m: TMatrix4x4;
   TMatrix4x4.Invert(matrix, m);

   var x: Single := plane.Normal.X;
   var y: Single := plane.Normal.Y;
   var z: Single := plane.Normal.Z;
   var w: Single := plane.D;

   Exit(TPlane.Create(x * m.M11 + y * m.M12 + z * m.M13 + w * m.M14, x * m.M21 + y * m.M22 + z * m.M23 + w * m.M24, x * m.M31 + y * m.M32 + z * m.M33 + w * m.M34, x * m.M41 + y * m.M42 + z * m.M43 + w * m.M44));
end;

class function TPlane.Transform(const plane: TPlane; const rotation: TQuaternion): TPlane;
begin
   // Compute rotation matrix.
   var x2: Single := rotation.X + rotation.X;
   var y2: Single := rotation.Y + rotation.Y;
   var z2: Single := rotation.Z + rotation.Z;

   var wx2: Single := rotation.W * x2;
   var wy2: Single := rotation.W * y2;
   var wz2: Single := rotation.W * z2;
   var xx2: Single := rotation.X * x2;
   var xy2: Single := rotation.X * y2;
   var xz2: Single := rotation.X * z2;
   var yy2: Single := rotation.Y * y2;
   var yz2: Single := rotation.Y * z2;
   var zz2: Single := rotation.Z * z2;

   var m11: Single := Single(1.0) - yy2 - zz2;
   var m21: Single := xy2 - wz2;
   var m31: Single := xz2 + wy2;

   var m12: Single := xy2 + wz2;
   var m22: Single := Single(1.0) - xx2 - zz2;
   var m32: Single := yz2 - wx2;

   var m13: Single := xz2 - wy2;
   var m23: Single := yz2 + wx2;
   var m33: Single := Single(1.0) - xx2 - yy2;

   var x: Single := plane.Normal.X;

   var y: Single := plane.Normal.Y;

   var z: Single := plane.Normal.Z;

   Exit(TPlane.Create(x * m11 + y * m21 + z * m31, x * m12 + y * m22 + z * m32, x * m13 + y * m23 + z * m33, plane.D));
end;

function TPlane.Equals(const other: TPlane): Boolean;
begin
   // This function needs to account for floating-point equality around NaN
   // and so must behave equivalently to the underlying float/double.Equals

//   if (Vector128.IsHardwareAccelerated) then
//   begin
//
//      Exit(Self.AsVector128().Equals(other.AsVector128()));
//   end;

   Result := self.Normal.Equals(other.Normal) and (self.D = other.D);
end;

function TPlane.ToString(): string;
begin
   Result := '{Normal:' + Normal.ToString() + ' D:' + D.ToString() + '}'
end;

class operator TPlane.Equal(const value1: TPlane; const value2: TPlane): Boolean;
begin
   Result := (value1.Normal = value2.Normal) and (value1.D = value2.D);
end;

class operator TPlane.NotEqual(const value1: TPlane; const value2: TPlane): Boolean;
begin
   Exit(not (value1 = value2));
end;

{$ENDREGION 'TPlane'}

{$REGION 'TMatrix3x2Helper'}

function TMatrix3x2Helper.GetTranslation(): TVector2;
begin
   Result := AsROImpl().Translation;
end;

procedure TMatrix3x2Helper.SetTranslation(const Value: TVector2);
begin
   AsImpl().Translation := value;
end;

class function TMatrix3x2Helper.CreateRotation(const radians: Single; const centerPoint: TVector2): TMatrix3x2;
begin
   Result := TImpl.CreateRotation(radians, centerPoint).AsM3x2()^;
end;

class function TMatrix3x2Helper.CreateScale(const scales: TVector2): TMatrix3x2;
begin
   Result := TImpl.CreateScale(scales).AsM3x2()^;
end;

class function TMatrix3x2Helper.CreateScale(const xScale: Single; const yScale: Single; const centerPoint: TVector2): TMatrix3x2;
begin
   Result := TImpl.CreateScale(xScale, yScale, centerPoint).AsM3x2()^;
end;

class function TMatrix3x2Helper.CreateScale(const scales: TVector2; const centerPoint: TVector2): TMatrix3x2;
begin
   Result := TImpl.CreateScale(scales, centerPoint).AsM3x2()^;
end;

class function TMatrix3x2Helper.CreateScale(const scale: Single; const centerPoint: TVector2): TMatrix3x2;
begin
   Result := TImpl.CreateScale(scale, centerPoint).AsM3x2()^;
end;

class function TMatrix3x2Helper.CreateSkew(const radiansX: Single; const radiansY: Single; const centerPoint: TVector2): TMatrix3x2;
begin
   Result := TImpl.CreateSkew(radiansX, radiansY, centerPoint).AsM3x2()^;
end;

class function TMatrix3x2Helper.CreateTranslation(const position: TVector2): TMatrix3x2;
begin
   Result := TImpl.CreateTranslation(position).AsM3x2()^;
end;

procedure TMatrix3x2Helper.Translate(const offset: TVector2);
begin
   // Replicating what Matrix.Translate(float offsetX, float offsetY) does.
   Self.M31 := Self.M31 + (offset.X * Self.M11) + (offset.Y * Self.M21);
   Self.M32 := Self.M32 + (offset.X * Self.M12) + (offset.Y * Self.M22);
end;

{$REGION 'TMatrix3x2Helper.TImpl'}

{ TImpl }

class function TMatrix3x2Helper.TImpl.GetIdentity(): TImpl;
begin
   var _result: TImpl;

   _result.X := TVector2.UnitX;
   _result.Y := TVector2.UnitY;
   _result.Z := TVector2.Zero;

   Exit(_result);
end;

function TMatrix3x2Helper.TImpl.GetIsIdentity(): Boolean;
begin
   Exit((X = TVector2.UnitX) and (Y = TVector2.UnitY) and (Z = TVector2.Zero));
end;

function TMatrix3x2Helper.TImpl.GetTranslation(): TVector2;
begin
   Exit(Z);
end;

procedure TMatrix3x2Helper.TImpl.SetTranslation(const Value: TVector2);
begin
   Z := value;
end;

function TMatrix3x2Helper.TImpl.AsM3x2(): PMatrix3x2;
begin
   Result := PMatrix3x2(@Self);
end;

procedure TMatrix3x2Helper.TImpl.Init(const m11: Single; const m12: Single; const m21: Single; const m22: Single; const m31: Single; const m32: Single);
begin
   X := TVector2.Create(m11, m12);
   Y := TVector2.Create(m21, m22);
   Z := TVector2.Create(m31, m32);
end;

class function TMatrix3x2Helper.TImpl.CreateRotation(radians: Single): TImpl;
begin
   radians := TMathF.IEEERemainder(radians, TMathF.PI * 2);

   var c: Single;
   var s: Single;

   if (radians > -RotationEpsilon) and (radians < RotationEpsilon) then
   begin
      // Exact case for zero rotation.
      c := 1;
      s := 0;
   end
   else if (radians > TMathF.PI / 2 - RotationEpsilon) and (radians < TMathF.PI / 2 + RotationEpsilon) then
   begin
      // Exact case for 90 degree rotation.
      c := 0;
      s := 1;
   end
   else if (radians < -TMathF.PI + RotationEpsilon) or (radians > TMathF.PI - RotationEpsilon) then
   begin
      // Exact case for 180 degree rotation.
      c := -1;
      s := 0;
   end
   else if (radians > -TMathF.PI / 2 - RotationEpsilon) and (radians < -TMathF.PI / 2 + RotationEpsilon) then
   begin
      // Exact case for 270 degree rotation.
      c := 0;
      s := -1;
   end
   else
   begin
      // Arbitrary rotation.
      c := System.Cos(radians);
      s := System.Sin(radians);
   end;

   // [  c  s ]
   // [ -s  c ]
   // [  0  0 ]

   var _result: TImpl;


   _result.X := TVector2.Create(c, s);
   _result.Y := TVector2.Create(-s, c);
   _result.Z := TVector2.Zero;

   Exit(_result);
end;

class function TMatrix3x2Helper.TImpl.CreateRotation(radians: Single; const centerPoint: TVector2): TImpl;
begin
   radians := TMathF.IEEERemainder(radians, TMathF.PI * 2);

   var c: Single;

   var s: Single;

   if (radians > -RotationEpsilon) and (radians < RotationEpsilon) then
   begin
      // Exact case for zero rotation.
      c := 1;
      s := 0;
   end
   else if (radians > TMathF.PI / 2 - RotationEpsilon) and (radians < TMathF.PI / 2 + RotationEpsilon) then
   begin
      // Exact case for 90 degree rotation.
      c := 0;
      s := 1;
   end
   else if (radians < -TMathF.PI + RotationEpsilon) or (radians > TMathF.PI - RotationEpsilon) then
   begin
      // Exact case for 180 degree rotation.
      c := -1;
      s := 0;
   end
   else if (radians > -TMathF.PI / 2 - RotationEpsilon) and (radians < -TMathF.PI / 2 + RotationEpsilon) then
   begin
      // Exact case for 270 degree rotation.
      c := 0;
      s := -1;
   end
   else
   begin
      // Arbitrary rotation.
      c := System.Cos(radians);
      s := System.Sin(radians);
   end;

   var x: Single := centerPoint.X * (1 - c) + centerPoint.Y * s;
   var y: Single := centerPoint.Y * (1 - c) - centerPoint.X * s;

   // [  c  s ]
   // [ -s  c ]
   // [  x  y ]

   var _result: TImpl;


   _result.X := TVector2.Create(c, s);
   _result.Y := TVector2.Create(-s, c);
   _result.Z := TVector2.Create(x, y);

   Exit(_result);
end;

class function TMatrix3x2Helper.TImpl.CreateScale(const scales: TVector2): TImpl;
begin
   var _result: TImpl;


   _result.X := TVector2.Create(scales.X, 0);
   _result.Y := TVector2.Create(0, scales.Y);
   _result.Z := TVector2.Zero;

   Exit(_result);
end;

class function TMatrix3x2Helper.TImpl.CreateScale(const scaleX: Single; const scaleY: Single): TImpl;
begin
   var _result: TImpl;


   _result.X := TVector2.Create(scaleX, 0);
   _result.Y := TVector2.Create(0, scaleY);
   _result.Z := TVector2.Zero;

   Exit(_result);
end;

class function TMatrix3x2Helper.TImpl.CreateScale(const scaleX: Single; const scaleY: Single; const centerPoint: TVector2): TImpl;
begin
   var _result: TImpl;


   _result.X := TVector2.Create(scaleX, 0);
   _result.Y := TVector2.Create(0, scaleY);
   _result.Z := centerPoint * (TVector2.One - TVector2.Create(scaleX, scaleY));

   Exit(_result);
end;

class function TMatrix3x2Helper.TImpl.CreateScale(const scales: TVector2; const centerPoint: TVector2): TImpl;
begin
   var _result: TImpl;


   _result.X := TVector2.Create(scales.X, 0);
   _result.Y := TVector2.Create(0, scales.Y);
   _result.Z := centerPoint * (TVector2.One - scales);

   Exit(_result);
end;

class function TMatrix3x2Helper.TImpl.CreateScale(const scale: Single): TImpl;
begin
   var _result: TImpl;


   _result.X := TVector2.Create(scale, 0);
   _result.Y := TVector2.Create(0, scale);
   _result.Z := TVector2.Zero;

   Exit(_result);
end;

class function TMatrix3x2Helper.TImpl.CreateScale(const scale: Single; const centerPoint: TVector2): TImpl;
begin
   var _result: TImpl;


   _result.X := TVector2.Create(scale, 0);
   _result.Y := TVector2.Create(0, scale);
   _result.Z := centerPoint * (TVector2.One - TVector2.Create(scale));

   Exit(_result);
end;

class function TMatrix3x2Helper.TImpl.CreateSkew(const radiansX: Single; const radiansY: Single): TImpl;
begin
   var _result: TImpl;


   _result.X := TVector2.Create(1, Math.Tan(radiansY));
   _result.Y := TVector2.Create(Math.Tan(radiansX), 1);
   _result.Z := TVector2.Zero;

   Exit(_result);
end;

class function TMatrix3x2Helper.TImpl.CreateSkew(const radiansX: Single; const radiansY: Single; const centerPoint: TVector2): TImpl;
begin
   var xTan: Single := Math.Tan(radiansX);
   var yTan: Single := Math.Tan(radiansY);

   var tx: Single := -centerPoint.Y * xTan;
   var ty: Single := -centerPoint.X * yTan;

   var _result: TImpl;


   _result.X := TVector2.Create(1, yTan);
   _result.Y := TVector2.Create(xTan, 1);
   _result.Z := TVector2.Create(tx, ty);

   Exit(_result);
end;

class function TMatrix3x2Helper.TImpl.CreateTranslation(const position: TVector2): TImpl;
begin
   var _result: TImpl;


   _result.X := TVector2.UnitX;
   _result.Y := TVector2.UnitY;
   _result.Z := position;

   Exit(_result);
end;

class function TMatrix3x2Helper.TImpl.CreateTranslation(const positionX: Single; const positionY: Single): TImpl;
begin
   var _result: TImpl;


   _result.X := TVector2.UnitX;
   _result.Y := TVector2.UnitY;
   _result.Z := TVector2.Create(positionX, positionY);

   Exit(_result);
end;

class function TMatrix3x2Helper.TImpl.Invert(const matrix: TImpl; out _result: TImpl): Boolean;
begin
   var det: Single := (matrix.X.X * matrix.Y.Y) - (matrix.Y.X * matrix.X.Y);

   if (System.Abs(det) < Single.Epsilon) then
   begin
      var vNaN: TVector2 := TVector2.Create(Single.NaN);


      _result.X := vNaN;
      _result.Y := vNaN;
      _result.Z := vNaN;

      Exit(false);
   end;

   var invDet: Single := Single(1.0) / det;


   _result.X := TVector2.Create(+matrix.Y.Y * invDet, -matrix.X.Y * invDet);
   _result.Y := TVector2.Create(-matrix.Y.X * invDet, +matrix.X.X * invDet);
   _result.Z := TVector2.Create((matrix.Y.X * matrix.Z.Y - matrix.Z.X * matrix.Y.Y) * invDet, (matrix.Z.X * matrix.X.Y - matrix.X.X * matrix.Z.Y) * invDet);

   Exit(true);
end;

class function TMatrix3x2Helper.TImpl.Lerp(const left: TImpl; const right: TImpl; const amount: Single): TImpl;
begin
   var _result: TImpl;


   _result.X := TVector2.Lerp(left.X, right.X, amount);
   _result.Y := TVector2.Lerp(left.Y, right.Y, amount);
   _result.Z := TVector2.Lerp(left.Z, right.Z, amount);

   Exit(_result);
end;

function TMatrix3x2Helper.TImpl.Equals(const other: TImpl): Boolean;
begin
   Exit(X.Equals(other.X) and Y.Equals(other.Y) and Z.Equals(other.Z));
end;

function TMatrix3x2Helper.TImpl.GetDeterminant(): Single;
begin
   Exit((X.X * Y.Y) - (Y.X * X.Y));
end;

function TMatrix3x2Helper.TImpl.GetItem(const row: Integer; const column: Integer): Single;
begin
   if (UInt32(row) >= RowCount) then
      raise EArgumentOutOfRangeException.Create('');
   raise ENotImplemented.Create('ainda não fiz isso aqui');

//   Result := PVector2(@Self.X)^[row][column];
end;

procedure TMatrix3x2Helper.TImpl.SetItem(const row: Integer; const column: Integer; const Value: Single);
begin
   if (UInt32(row) >= RowCount) then
      raise EArgumentOutOfRangeException.Create('');
   raise ENotImplemented.Create('ainda não fiz isso aqui');

//   PVector2(@Self.X)[row][column] := value;
end;

class operator TMatrix3x2Helper.TImpl.Add(const left: TImpl; const right: TImpl): TImpl;
begin
begin
   var _result: TImpl;


   _result.X := left.X + right.X;
   _result.Y := left.Y + right.Y;
   _result.Z := left.Z + right.Z;

   Exit(_result);
end;
end;

class operator TMatrix3x2Helper.TImpl.Equal(const left: TImpl; const right: TImpl): Boolean;
begin
   Exit(((left.X = right.X)) and ((left.Y = right.Y)) and ((left.Z = right.Z)));
end;

class operator TMatrix3x2Helper.TImpl.NotEqual(const left: TImpl; const right: TImpl): Boolean;
begin
begin

   Exit(((left.X <> right.X)) or ((left.Y <> right.Y)) or ((left.Z <> right.Z)));
end;
end;

class operator TMatrix3x2Helper.TImpl.Multiply(const left: TImpl; const right: TImpl): TImpl;
begin
begin
   var _result: TImpl;


   _result.X := TVector2.Create(left.X.X * right.X.X + left.X.Y * right.Y.X, left.X.X * right.X.Y + left.X.Y * right.Y.Y);
   _result.Y := TVector2.Create(left.Y.X * right.X.X + left.Y.Y * right.Y.X, left.Y.X * right.X.Y + left.Y.Y * right.Y.Y);
   _result.Z := TVector2.Create(left.Z.X * right.X.X + left.Z.Y * right.Y.X + right.Z.X, left.Z.X * right.X.Y + left.Z.Y * right.Y.Y + right.Z.Y);

   Exit(_result);
end;
end;

class operator TMatrix3x2Helper.TImpl.Multiply(const left: TImpl; const right: Single): TImpl;
begin
begin
   var _result: TImpl;


   _result.X := left.X * right;
   _result.Y := left.Y * right;
   _result.Z := left.Z * right;

   Exit(_result);
end;
end;

class operator TMatrix3x2Helper.TImpl.Subtract(const left: TImpl; const right: TImpl): TImpl;
begin
begin
   var _result: TImpl;


   _result.X := left.X - right.X;
   _result.Y := left.Y - right.Y;
   _result.Z := left.Z - right.Z;

   Exit(_result);
end;
end;

class operator TMatrix3x2Helper.TImpl.Negative(const value: TImpl): TImpl;
begin
   var _result: TImpl;

   _result.X := -value.X;
   _result.Y := -value.Y;
   _result.Z := -value.Z;

   Exit(_result);
end;

{$ENDREGION 'TMatrix3x2Helper.TImpl'}

function TMatrix3x2Helper.AsImpl(): TImpl;
begin
   Result := TImpl(Self);
end;

function TMatrix3x2Helper.AsROImpl(): PImpl;
begin
   Result := PImpl(@Self);
end;

{$ENDREGION 'TMatrix3x2Helper'}

{$REGION 'TMatrix4x4Helper'}

function TMatrix4x4Helper.GetTranslation(): TVector3;
begin
   Result := AsROImpl().Translation;
end;

procedure TMatrix4x4Helper.SetTranslation(const Value: TVector3);
begin
   AsImpl().Translation := value;
end;

class function TMatrix4x4Helper.CreateBillboard(const objectPosition: TVector3; const cameraPosition: TVector3; const cameraUpVector: TVector3; const cameraForwardVector: TVector3): TMatrix4x4;
begin
   Result := TImpl.CreateBillboard(objectPosition, cameraPosition, cameraUpVector, cameraForwardVector).AsM4x4()^;
end;

class function TMatrix4x4Helper.CreateConstrainedBillboard(const objectPosition: TVector3; const cameraPosition: TVector3; const rotateAxis: TVector3; const cameraForwardVector: TVector3; const objectForwardVector: TVector3): TMatrix4x4;
begin
   Result := TImpl.CreateConstrainedBillboard(objectPosition, cameraPosition, rotateAxis, cameraForwardVector, objectForwardVector).AsM4x4()^;
end;

class function TMatrix4x4Helper.CreateFromAxisAngle(const axis: TVector3; const angle: Single): TMatrix4x4;
begin
   Result := TImpl.CreateFromAxisAngle(axis, angle).AsM4x4()^;
end;

class function TMatrix4x4Helper.CreateFromQuaternion(const quaternion: TQuaternion): TMatrix4x4;
begin
   Result := TImpl.CreateFromQuaternion(quaternion).AsM4x4()^;
end;

class function TMatrix4x4Helper.CreateLookAt(const cameraPosition: TVector3; const cameraTarget: TVector3; const cameraUpVector: TVector3): TMatrix4x4;
begin
   var cameraDirection: TVector3 := cameraTarget - cameraPosition;

   Exit(TImpl.CreateLookTo(cameraPosition, cameraDirection, cameraUpVector).AsM4x4()^);
end;

class function TMatrix4x4Helper.CreateLookAtLeftHanded(const cameraPosition: TVector3; const cameraTarget: TVector3; const cameraUpVector: TVector3): TMatrix4x4;
begin
   var cameraDirection: TVector3 := cameraTarget - cameraPosition;

   Exit(TImpl.CreateLookToLeftHanded(cameraPosition, cameraDirection, cameraUpVector).AsM4x4()^);
end;

class function TMatrix4x4Helper.CreateLookTo(const cameraPosition: TVector3; const cameraDirection: TVector3; const cameraUpVector: TVector3): TMatrix4x4;
begin
   Result := TImpl.CreateLookTo(cameraPosition, cameraDirection, cameraUpVector).AsM4x4()^;
end;

class function TMatrix4x4Helper.CreateLookToLeftHanded(const cameraPosition: TVector3; const cameraDirection: TVector3; const cameraUpVector: TVector3): TMatrix4x4;
begin
   Exit(TImpl.CreateLookToLeftHanded(cameraPosition, cameraDirection, cameraUpVector).AsM4x4()^);
end;

class function TMatrix4x4Helper.CreateReflection(const value: TPlane): TMatrix4x4;
begin
   Result := TImpl.CreateReflection(value).AsM4x4()^;
end;

class function TMatrix4x4Helper.CreateRotationX(const radians: Single; const centerPoint: TVector3): TMatrix4x4;
begin
   Result := TImpl.CreateRotationX(radians, centerPoint).AsM4x4()^;
end;

class function TMatrix4x4Helper.CreateRotationY(const radians: Single; const centerPoint: TVector3): TMatrix4x4;
begin
   Result := TImpl.CreateRotationY(radians, centerPoint).AsM4x4()^;
end;

class function TMatrix4x4Helper.CreateRotationZ(const radians: Single; const centerPoint: TVector3): TMatrix4x4;
begin
   Result := TImpl.CreateRotationZ(radians, centerPoint).AsM4x4()^;
end;

class function TMatrix4x4Helper.CreateScale(const xScale: Single; const yScale: Single; const zScale: Single; const centerPoint: TVector3): TMatrix4x4;
begin
   Result := TImpl.CreateScale(xScale, yScale, zScale, centerPoint).AsM4x4()^;
end;

class function TMatrix4x4Helper.CreateScale(const scales: TVector3): TMatrix4x4;
begin
   Result := TImpl.CreateScale(scales).AsM4x4()^;
end;

class function TMatrix4x4Helper.CreateScale(const scales: TVector3; const centerPoint: TVector3): TMatrix4x4;
begin
   Result := TImpl.CreateScale(scales, centerPoint).AsM4x4()^;
end;

class function TMatrix4x4Helper.CreateScale(const scale: Single; const centerPoint: TVector3): TMatrix4x4;
begin
   Result := TImpl.CreateScale(scale, centerPoint).AsM4x4()^;
end;

class function TMatrix4x4Helper.CreateShadow(const lightDirection: TVector3; const plane: TPlane): TMatrix4x4;
begin
   Result := TImpl.CreateShadow(lightDirection, plane).AsM4x4()^;
end;

class function TMatrix4x4Helper.CreateTranslation(const position: TVector3): TMatrix4x4;
begin
   Result := TImpl.CreateTranslation(position).AsM4x4()^;
end;

class function TMatrix4x4Helper.CreateWorld(const position: TVector3; const forward: TVector3; const up: TVector3): TMatrix4x4;
begin
   Result := TImpl.CreateWorld(position, forward, up).AsM4x4()^;
end;

class function TMatrix4x4Helper.Decompose(const matrix: TMatrix4x4; out scale: TVector3; out rotation: TQuaternion; out translation: TVector3): Boolean;
begin
   Result := TImpl.Decompose(matrix.AsImpl(), scale, rotation, translation);
end;

class function TMatrix4x4Helper.Transform(const value: TMatrix4x4; const rotation: TQuaternion): TMatrix4x4;
begin
   Result := TImpl.Transform(value.AsImpl(), rotation).AsM4x4()^;
end;

{$REGION 'TMatrix4x4Helper.TImpl'}

{ TImpl }

class function TMatrix4x4Helper.TImpl.GetIdentity(): TImpl;
begin
begin
   var _result: TImpl;


   _result.X := TVector4.UnitX;
   _result.Y := TVector4.UnitY;
   _result.Z := TVector4.UnitZ;
   _result.W := TVector4.UnitW;

   Exit(_result);
end;
end;

function TMatrix4x4Helper.TImpl.GetIsIdentity(): Boolean;
begin
begin

   Exit(((X = TVector4.UnitX)) and ((Y = TVector4.UnitY)) and ((Z = TVector4.UnitZ)) and ((W = TVector4.UnitW)));
end;
end;

function TMatrix4x4Helper.TImpl.GetTranslation(): TVector3;
begin
   Result := TVector3.Create(W.X, W.Y, W.Z);
end;

procedure TMatrix4x4Helper.TImpl.SetTranslation(const Value: TVector3);
begin
begin
   W := TVector4.Create(value, W.W);
end;
end;

function TMatrix4x4Helper.TImpl.AsM4x4(): PMatrix4x4;
begin
   Result := PMatrix4x4(@Self);
end;

procedure TMatrix4x4Helper.TImpl.Init(const m11: Single; const m12: Single; const m13: Single; const m14: Single; const m21: Single; const m22: Single; const m23: Single; const m24: Single; const m31: Single; const m32: Single; const m33: Single; const m34: Single; const m41: Single; const m42: Single; const m43: Single; const m44: Single);
begin
   X := TVector4.Create(m11, m12, m13, m14);
   Y := TVector4.Create(m21, m22, m23, m24);
   Z := TVector4.Create(m31, m32, m33, m34);
   W := TVector4.Create(m41, m42, m43, m44);
end;

//procedure TMatrix4x4Helper.TImpl.Init(const value: TMatrix3x2.TImpl);
//begin
//   X := TVector4.Create(value.X, 0, 0);
//   Y := TVector4.Create(value.Y, 0, 0);
//   Z := TVector4.UnitZ;
//   W := TVector4.Create(value.Z, 0, 1);
//end;

class function TMatrix4x4Helper.TImpl.CreateBillboard(const objectPosition: TVector3; const cameraPosition: TVector3; const cameraUpVector: TVector3; const cameraForwardVector: TVector3): TImpl;
begin
   var axisZ: TVector3 := objectPosition - cameraPosition;
   var norm: Single := axisZ.LengthSquared();

   if (norm < BillboardEpsilon) then
   begin
      axisZ := -cameraForwardVector;
   end
   else
   begin
      axisZ := TVector3.Multiply(axisZ, Single(1.0) / System.Sqrt(norm));
   end;

   var axisX: TVector3 := TVector3.Normalize(TVector3.Cross(cameraUpVector, axisZ));
   var axisY: TVector3 := TVector3.Cross(axisZ, axisX);

   var _result: TImpl;

   _result.X := TVector4.Create(axisX, 0);
   _result.Y := TVector4.Create(axisY, 0);
   _result.Z := TVector4.Create(axisZ, 0);
   _result.W := TVector4.Create(objectPosition, 1);

   Exit(_result);
end;

class function TMatrix4x4Helper.TImpl.CreateConstrainedBillboard(const objectPosition: TVector3; const cameraPosition: TVector3; const rotateAxis: TVector3; const cameraForwardVector: TVector3; const objectForwardVector: TVector3): TImpl;
begin
   // Treat the case when object and camera positions are too close.
   var faceDir: TVector3 := objectPosition - cameraPosition;
   var norm: Single := faceDir.LengthSquared();

   if (norm < BillboardEpsilon) then
   begin
      faceDir := -cameraForwardVector;
   end
   else
   begin
      faceDir := TVector3.Multiply(faceDir, (Single(1.0) / System.Sqrt(norm)));
   end;

   var axisY: TVector3 := rotateAxis;

   // Treat the case when angle between faceDir and rotateAxis is too close to 0.
   var dot: Single := TVector3.Dot(axisY, faceDir);

   if (System.Abs(dot) > BillboardMinAngle) then
   begin
      faceDir := objectForwardVector;

      // Make sure passed values are useful for compute.
      dot := TVector3.Dot(axisY, faceDir);

      if (System.Abs(dot) > BillboardMinAngle) then
      begin

         if ((System.Abs(axisY.Z) > BillboardMinAngle)) then
            faceDir := TVector3.UnitX
         else
            faceDir := TVector3.Create(0, 0, -1);

      end;
   end;

   var axisX: TVector3 := TVector3.Normalize(TVector3.Cross(axisY, faceDir));
   var axisZ: TVector3 := TVector3.Normalize(TVector3.Cross(axisX, axisY));

   var _result: TImpl;


   _result.X := TVector4.Create(axisX, 0);
   _result.Y := TVector4.Create(axisY, 0);
   _result.Z := TVector4.Create(axisZ, 0);
   _result.W := TVector4.Create(objectPosition, 1);

   Exit(_result);
end;

class function TMatrix4x4Helper.TImpl.CreateFromAxisAngle(const axis: TVector3; const angle: Single): TImpl;
begin
   // a: angle
   // x, y, z: unit vector for axis.
   //
   // Rotation matrix M can compute by using below equation.
   //
   //        T               T
   //  M = uu + (cos a)( I-uu ) + (sin a)S
   //
   // Where:
   //
   //  u = ( x, y, z )
   //
   //      [  0 -z  y ]
   //  S = [  z  0 -x ]
   //      [ -y  x  0 ]
   //
   //      [ 1 0 0 ]
   //  I = [ 0 1 0 ]
   //      [ 0 0 1 ]
   //
   //
   //     [  xx+cosa*(1-xx)   yx-cosa*yx-sina*z zx-cosa*xz+sina*y ]
   // M = [ xy-cosa*yx+sina*z    yy+cosa(1-yy)  yz-cosa*yz-sina*x ]
   //     [ zx-cosa*zx-sina*y zy-cosa*zy+sina*x   zz+cosa*(1-zz)  ]
   //

   var x: Single := axis.X;
   var y: Single := axis.Y;
   var z: Single := axis.Z;

   var sa: Single := System.Sin(angle);
   var ca: Single := System.Cos(angle);

   var xx: Single := x * x;
   var yy: Single := y * y;
   var zz: Single := z * z;

   var xy: Single := x * y;
   var xz: Single := x * z;
   var yz: Single := y * z;

   var _result: TImpl;
   _result.X := TVector4.Create(xx + ca * (Single(1.0) - xx), xy - ca * xy + sa * z, xz - ca * xz - sa * y, 0);
   _result.Y := TVector4.Create(xy - ca * xy - sa * z, yy + ca * (Single(1.0) - yy), yz - ca * yz + sa * x, 0);
   _result.Z := TVector4.Create(xz - ca * xz + sa * y, yz - ca * yz - sa * x, zz + ca * (Single(1.0) - zz), 0);
   _result.W := TVector4.UnitW;
   Exit(_result);
end;

class function TMatrix4x4Helper.TImpl.CreateFromQuaternion(const quaternion: TQuaternion): TImpl;
begin
   var xx: Single := quaternion.X * quaternion.X;
   var yy: Single := quaternion.Y * quaternion.Y;
   var zz: Single := quaternion.Z * quaternion.Z;

   var xy: Single := quaternion.X * quaternion.Y;
   var wz: Single := quaternion.Z * quaternion.W;
   var xz: Single := quaternion.Z * quaternion.X;
   var wy: Single := quaternion.Y * quaternion.W;
   var yz: Single := quaternion.Y * quaternion.Z;
   var wx: Single := quaternion.X * quaternion.W;

   var _result: TImpl;
   _result.X := TVector4.Create(Single(1.0) - Single(2.0) * (yy + zz), Single(2.0) * (xy + wz), Single(2.0) * (xz - wy), 0);
   _result.Y := TVector4.Create(Single(2.0) * (xy - wz), Single(1.0) - Single(2.0) * (zz + xx), Single(2.0) * (yz + wx), 0);
   _result.Z := TVector4.Create(Single(2.0) * (xz + wy), Single(2.0) * (yz - wx), Single(1.0) - Single(2.0) * (yy + xx), 0);
   _result.W := TVector4.UnitW;
   Exit(_result);
end;

class function TMatrix4x4Helper.TImpl.CreateFromYawPitchRoll(const yaw: Single; const pitch: Single; const roll: Single): TImpl;
begin
   var q: TQuaternion := TQuaternion.CreateFromYawPitchRoll(yaw, pitch, roll);

   Exit(CreateFromQuaternion(q));
end;

class function TMatrix4x4Helper.TImpl.CreateLookTo(const cameraPosition: TVector3; const cameraDirection: TVector3; const cameraUpVector: TVector3): TImpl;
begin
   var axisZ: TVector3 := TVector3.Normalize(-cameraDirection);
   var axisX: TVector3 := TVector3.Normalize(TVector3.Cross(cameraUpVector, axisZ));
   var axisY: TVector3 := TVector3.Cross(axisZ, axisX);
   var negativeCameraPosition: TVector3 := -cameraPosition;

   var _result: TImpl;
   _result.X := TVector4.Create(axisX.X, axisY.X, axisZ.X, 0);
   _result.Y := TVector4.Create(axisX.Y, axisY.Y, axisZ.Y, 0);
   _result.Z := TVector4.Create(axisX.Z, axisY.Z, axisZ.Z, 0);
   _result.W := TVector4.Create(TVector3.Dot(axisX, negativeCameraPosition), TVector3.Dot(axisY, negativeCameraPosition), TVector3.Dot(axisZ, negativeCameraPosition), 1);
   Exit(_result);
end;

class function TMatrix4x4Helper.TImpl.CreateLookToLeftHanded(const cameraPosition: TVector3; const cameraDirection: TVector3; const cameraUpVector: TVector3): TImpl;
begin
   var axisZ: TVector3 := TVector3.Normalize(cameraDirection);
   var axisX: TVector3 := TVector3.Normalize(TVector3.Cross(cameraUpVector, axisZ));
   var axisY: TVector3 := TVector3.Cross(axisZ, axisX);
   var negativeCameraPosition: TVector3 := -cameraPosition;

   var _result: TImpl;
   _result.X := TVector4.Create(axisX.X, axisY.X, axisZ.X, 0);
   _result.Y := TVector4.Create(axisX.Y, axisY.Y, axisZ.Y, 0);
   _result.Z := TVector4.Create(axisX.Z, axisY.Z, axisZ.Z, 0);
   _result.W := TVector4.Create(TVector3.Dot(axisX, negativeCameraPosition), TVector3.Dot(axisY, negativeCameraPosition), TVector3.Dot(axisZ, negativeCameraPosition), 1);
   Exit(_result);
end;

class function TMatrix4x4Helper.TImpl.CreateOrthographic(const width: Single; const height: Single; const zNearPlane: Single; const zFarPlane: Single): TImpl;
begin
   var range: Single := Single(1.0) / (zNearPlane - zFarPlane);

   var _result: TImpl;
   _result.X := TVector4.Create(Single(2.0) / width, 0, 0, 0);
   _result.Y := TVector4.Create(0, Single(2.0) / height, 0, 0);
   _result.Z := TVector4.Create(0, 0, range, 0);
   _result.W := TVector4.Create(0, 0, range * zNearPlane, 1);
   Exit(_result);
end;

class function TMatrix4x4Helper.TImpl.CreateOrthographicLeftHanded(const width: Single; const height: Single; const zNearPlane: Single; const zFarPlane: Single): TImpl;
begin
   var range: Single := Single(1.0) / (zFarPlane - zNearPlane);

   var _result: TImpl;
   _result.X := TVector4.Create(Single(2.0) / width, 0, 0, 0);
   _result.Y := TVector4.Create(0, Single(2.0) / height, 0, 0);
   _result.Z := TVector4.Create(0, 0, range, 0);
   _result.W := TVector4.Create(0, 0, -range * zNearPlane, 1);
   Exit(_result);
end;

class function TMatrix4x4Helper.TImpl.CreateOrthographicOffCenter(const left: Single; const right: Single; const bottom: Single; const top: Single; const zNearPlane: Single; const zFarPlane: Single): TImpl;
begin
   var reciprocalWidth: Single := Single(1.0) / (right - left);
   var reciprocalHeight: Single := Single(1.0) / (top - bottom);
   var range: Single := Single(1.0) / (zNearPlane - zFarPlane);

   var _result: TImpl;
   _result.X := TVector4.Create(reciprocalWidth + reciprocalWidth, 0, 0, 0);
   _result.Y := TVector4.Create(0, reciprocalHeight + reciprocalHeight, 0, 0);
   _result.Z := TVector4.Create(0, 0, range, 0);
   _result.W := TVector4.Create(-(left + right) * reciprocalWidth, -(top + bottom) * reciprocalHeight, range * zNearPlane, 1);
   Exit(_result);
end;

class function TMatrix4x4Helper.TImpl.CreateOrthographicOffCenterLeftHanded(const left: Single; const right: Single; const bottom: Single; const top: Single; const zNearPlane: Single; const zFarPlane: Single): TImpl;
begin
   var reciprocalWidth: Single := Single(1.0) / (right - left);
   var reciprocalHeight: Single := Single(1.0) / (top - bottom);
   var range: Single := Single(1.0) / (zFarPlane - zNearPlane);

   var _result: TImpl;
   _result.X := TVector4.Create(reciprocalWidth + reciprocalWidth, 0, 0, 0);
   _result.Y := TVector4.Create(0, reciprocalHeight + reciprocalHeight, 0, 0);
   _result.Z := TVector4.Create(0, 0, range, 0);
   _result.W := TVector4.Create(-(left + right) * reciprocalWidth, -(top + bottom) * reciprocalHeight, -range * zNearPlane, 1);
   Exit(_result);
end;

class function TMatrix4x4Helper.TImpl.CreatePerspective(const width: Single; const height: Single; const nearPlaneDistance: Single; const farPlaneDistance: Single): TImpl;
begin
   if (nearPlaneDistance  <= 0) then raise EArgumentOutOfRangeException.CreateFmt('%s (''%d'') deve ser maior que ''%d''.', ['nearPlaneDistance', nearPlaneDistance, 0.0]);
   if (farPlaneDistance  <= 0) then raise EArgumentOutOfRangeException.CreateFmt('%s (''%d'') deve ser maior que ''%d''.', ['farPlaneDistance', farPlaneDistance, 0.0]);
   if (nearPlaneDistance  >= farPlaneDistance) then raise EArgumentOutOfRangeException.CreateFmt('%s (''%d'') deve ser menor que ''%d''.', ['nearPlaneDistance', nearPlaneDistance, farPlaneDistance]);

   var dblNearPlaneDistance: Single := nearPlaneDistance + nearPlaneDistance;
   var range: Single := IfThen(Single.IsPositiveInfinity(farPlaneDistance), Single(-1.0), farPlaneDistance / (nearPlaneDistance - farPlaneDistance));

   var _result: TImpl;
   _result.X := TVector4.Create(dblNearPlaneDistance / width, 0, 0, 0);
   _result.Y := TVector4.Create(0, dblNearPlaneDistance / height, 0, 0);
   _result.Z := TVector4.Create(0, 0, range, Single(-1.0));
   _result.W := TVector4.Create(0, 0, range * nearPlaneDistance, 0);
   Exit(_result);
end;

class function TMatrix4x4Helper.TImpl.CreatePerspectiveLeftHanded(const width: Single; const height: Single; const nearPlaneDistance: Single; const farPlaneDistance: Single): TImpl;
begin
   if (nearPlaneDistance  <= 0) then raise EArgumentOutOfRangeException.CreateFmt('%s (''%d'') deve ser maior que ''%d''.', ['nearPlaneDistance', nearPlaneDistance, 0.0]);
   if (farPlaneDistance  <= 0) then raise EArgumentOutOfRangeException.CreateFmt('%s (''%d'') deve ser maior que ''%d''.', ['farPlaneDistance', farPlaneDistance, 0.0]);
   if (nearPlaneDistance  >= farPlaneDistance) then raise EArgumentOutOfRangeException.CreateFmt('%s (''%d'') deve ser menor que ''%d''.', ['nearPlaneDistance', nearPlaneDistance, farPlaneDistance]);

   var dblNearPlaneDistance: Single := nearPlaneDistance + nearPlaneDistance;
   var range: Single := IfThen(Single.IsPositiveInfinity(farPlaneDistance), Single(1.0), farPlaneDistance / (farPlaneDistance - nearPlaneDistance));

   var _result: TImpl;
   _result.X := TVector4.Create(dblNearPlaneDistance / width, 0, 0, 0);
   _result.Y := TVector4.Create(0, dblNearPlaneDistance / height, 0, 0);
   _result.Z := TVector4.Create(0, 0, range, Single(1.0));
   _result.W := TVector4.Create(0, 0, -range * nearPlaneDistance, 0);
   Exit(_result);
end;

class function TMatrix4x4Helper.TImpl.CreatePerspectiveFieldOfView(const fieldOfView: Single; const aspectRatio: Single; const nearPlaneDistance: Single; const farPlaneDistance: Single): TImpl;
begin
   if (fieldOfView  <= 0) then raise EArgumentOutOfRangeException.CreateFmt('%s (''%d'') deve ser maior que ''%d''.', ['fieldOfView', fieldOfView, 0.0]);
   if (fieldOfView >= TMathF.PI) then raise EArgumentOutOfRangeException.CreateFmt('%s (''%d'') deve ser menor que ''%d''.', ['fieldOfView', fieldOfView, TMathF.PI]);
   if (nearPlaneDistance  <= 0) then raise EArgumentOutOfRangeException.CreateFmt('%s (''%d'') deve ser maior que ''%d''.', ['nearPlaneDistance', nearPlaneDistance, 0.0]);
   if (farPlaneDistance  <= 0) then raise EArgumentOutOfRangeException.CreateFmt('%s (''%d'') deve ser maior que ''%d''.', ['farPlaneDistance', farPlaneDistance, 0.0]);
   if (nearPlaneDistance  >= farPlaneDistance) then raise EArgumentOutOfRangeException.CreateFmt('%s (''%d'') deve ser menor que ''%d''.', ['nearPlaneDistance', nearPlaneDistance, farPlaneDistance]);

   var height: Single := Single(1.0) / Math.Tan(fieldOfView * Single(0.5));
   var width: Single := height / aspectRatio;
   var range: Single := IfThen(Single.IsPositiveInfinity(farPlaneDistance), Single(-1.0), farPlaneDistance / (nearPlaneDistance - farPlaneDistance));

   var _result: TImpl;


   _result.X := TVector4.Create(width, 0, 0, 0);
   _result.Y := TVector4.Create(0, height, 0, 0);
   _result.Z := TVector4.Create(0, 0, range, Single(-1.0));
   _result.W := TVector4.Create(0, 0, range * nearPlaneDistance, 0);

   Exit(_result);
end;

class function TMatrix4x4Helper.TImpl.CreatePerspectiveFieldOfViewLeftHanded(const fieldOfView: Single; const aspectRatio: Single; const nearPlaneDistance: Single; const farPlaneDistance: Single): TImpl;
begin
   if (fieldOfView  <= 0) then raise EArgumentOutOfRangeException.CreateFmt('%s (''%d'') deve ser maior que ''%d''.', ['fieldOfView', fieldOfView, 0.0]);
   if (fieldOfView >= TMathF.PI) then raise EArgumentOutOfRangeException.CreateFmt('%s (''%d'') deve ser menor que ''%d''.', ['fieldOfView', fieldOfView, TMathF.PI]);
   if (nearPlaneDistance  <= 0) then raise EArgumentOutOfRangeException.CreateFmt('%s (''%d'') deve ser maior que ''%d''.', ['nearPlaneDistance', nearPlaneDistance, 0.0]);
   if (farPlaneDistance  <= 0) then raise EArgumentOutOfRangeException.CreateFmt('%s (''%d'') deve ser maior que ''%d''.', ['farPlaneDistance', farPlaneDistance, 0.0]);
   if (nearPlaneDistance  >= farPlaneDistance) then raise EArgumentOutOfRangeException.CreateFmt('%s (''%d'') deve ser menor que ''%d''.', ['nearPlaneDistance', nearPlaneDistance, farPlaneDistance]);

   var height: Single := Single(1.0) / Math.Tan(fieldOfView * Single(0.5));
   var width: Single := height / aspectRatio;
   var range: Single := IfThen(Single.IsPositiveInfinity(farPlaneDistance), Single(1.0), farPlaneDistance / (farPlaneDistance - nearPlaneDistance));

   var _result: TImpl;
   _result.X := TVector4.Create(width, 0, 0, 0);
   _result.Y := TVector4.Create(0, height, 0, 0);
   _result.Z := TVector4.Create(0, 0, range, Single(1.0));
   _result.W := TVector4.Create(0, 0, -range * nearPlaneDistance, 0);
   Exit(_result);
end;

class function TMatrix4x4Helper.TImpl.CreatePerspectiveOffCenter(const left: Single; const right: Single; const bottom: Single; const top: Single; const nearPlaneDistance: Single; const farPlaneDistance: Single): TImpl;
begin
   if (nearPlaneDistance  <= 0) then raise EArgumentOutOfRangeException.CreateFmt('%s (''%d'') deve ser maior que ''%d''.', ['nearPlaneDistance', nearPlaneDistance, 0.0]);
   if (farPlaneDistance  <= 0) then raise EArgumentOutOfRangeException.CreateFmt('%s (''%d'') deve ser maior que ''%d''.', ['farPlaneDistance', farPlaneDistance, 0.0]);
   if (nearPlaneDistance  >= farPlaneDistance) then raise EArgumentOutOfRangeException.CreateFmt('%s (''%d'') deve ser menor que ''%d''.', ['nearPlaneDistance', nearPlaneDistance, farPlaneDistance]);

   var dblNearPlaneDistance: Single := nearPlaneDistance + nearPlaneDistance;
   var reciprocalWidth: Single := Single(1.0) / (right - left);
   var reciprocalHeight: Single := Single(1.0) / (top - bottom);
   var range: Single := IfThen(Single.IsPositiveInfinity(farPlaneDistance), Single(-1.0), farPlaneDistance / (nearPlaneDistance - farPlaneDistance));

   var _result: TImpl;
   _result.X := TVector4.Create(dblNearPlaneDistance * reciprocalWidth, 0, 0, 0);
   _result.Y := TVector4.Create(0, dblNearPlaneDistance * reciprocalHeight, 0, 0);
   _result.Z := TVector4.Create((left + right) * reciprocalWidth, (top + bottom) * reciprocalHeight, range, Single(-1.0));
   _result.W := TVector4.Create(0, 0, range * nearPlaneDistance, 0);
   Exit(_result);
end;

class function TMatrix4x4Helper.TImpl.CreatePerspectiveOffCenterLeftHanded(const left: Single; const right: Single; const bottom: Single; const top: Single; const nearPlaneDistance: Single; const farPlaneDistance: Single): TImpl;
begin
   if (nearPlaneDistance  <= 0) then raise EArgumentOutOfRangeException.CreateFmt('%s (''%d'') deve ser maior que ''%d''.', ['nearPlaneDistance', nearPlaneDistance, 0.0]);
   if (farPlaneDistance  <= 0) then raise EArgumentOutOfRangeException.CreateFmt('%s (''%d'') deve ser maior que ''%d''.', ['farPlaneDistance', farPlaneDistance, 0.0]);
   if (nearPlaneDistance  >= farPlaneDistance) then raise EArgumentOutOfRangeException.CreateFmt('%s (''%d'') deve ser menor que ''%d''.', ['nearPlaneDistance', nearPlaneDistance, farPlaneDistance]);

   var dblNearPlaneDistance: Single := nearPlaneDistance + nearPlaneDistance;
   var reciprocalWidth: Single := Single(1.0) / (right - left);
   var reciprocalHeight: Single := Single(1.0) / (top - bottom);
   var range: Single := IfThen(Single.IsPositiveInfinity(farPlaneDistance), Single(1.0), farPlaneDistance / (farPlaneDistance - nearPlaneDistance));

   var _result: TImpl;
   _result.X := TVector4.Create(dblNearPlaneDistance * reciprocalWidth, 0, 0, 0);
   _result.Y := TVector4.Create(0, dblNearPlaneDistance * reciprocalHeight, 0, 0);
   _result.Z := TVector4.Create(-(left + right) * reciprocalWidth, -(top + bottom) * reciprocalHeight, range, Single(1.0));
   _result.W := TVector4.Create(0, 0, -range * nearPlaneDistance, 0);
   Exit(_result);
end;

class function TMatrix4x4Helper.TImpl.CreateReflection(const value: TPlane): TImpl;
begin
   var p: TPlane := TPlane.Normalize(value);
   var f: TVector3 := p.Normal * Single(-2.0);

   var _result: TImpl;
   _result.X := TVector4.Create(f * p.Normal.X, 0) + TVector4.UnitX;
   _result.Y := TVector4.Create(f * p.Normal.Y, 0) + TVector4.UnitY;
   _result.Z := TVector4.Create(f * p.Normal.Z, 0) + TVector4.UnitZ;
   _result.W := TVector4.Create(f * p.D, 1);
   Exit(_result);
end;

class function TMatrix4x4Helper.TImpl.CreateRotationX(const radians: Single): TImpl;
begin
   var c: Single := System.Cos(radians);
   var s: Single := System.Sin(radians);

   // [  1  0  0  0 ]
   // [  0  c  s  0 ]
   // [  0 -s  c  0 ]
   // [  0  0  0  1 ]

   var _result: TImpl;
   _result.X := TVector4.UnitX;
   _result.Y := TVector4.Create(0, c, s, 0);
   _result.Z := TVector4.Create(0, -s, c, 0);
   _result.W := TVector4.UnitW;
   Exit(_result);
end;

class function TMatrix4x4Helper.TImpl.CreateRotationX(const radians: Single; const centerPoint: TVector3): TImpl;
begin
   var c: Single := System.Cos(radians);
   var s: Single := System.Sin(radians);

   var y: Single := centerPoint.Y * (1 - c) + centerPoint.Z * s;
   var z: Single := centerPoint.Z * (1 - c) - centerPoint.Y * s;

   // [  1  0  0  0 ]
   // [  0  c  s  0 ]
   // [  0 -s  c  0 ]
   // [  0  y  z  1 ]

   var _result: TImpl;
   _result.X := TVector4.UnitX;
   _result.Y := TVector4.Create(0, c, s, 0);
   _result.Z := TVector4.Create(0, -s, c, 0);
   _result.W := TVector4.Create(0, y, z, 1);
   Exit(_result);
end;

class function TMatrix4x4Helper.TImpl.CreateRotationY(const radians: Single): TImpl;
begin
   var c: Single := System.Cos(radians);
   var s: Single := System.Sin(radians);

   // [  c  0 -s  0 ]
   // [  0  1  0  0 ]
   // [  s  0  c  0 ]
   // [  0  0  0  1 ]

   var _result: TImpl;
   _result.X := TVector4.Create(c, 0, -s, 0);
   _result.Y := TVector4.UnitY;
   _result.Z := TVector4.Create(s, 0, c, 0);
   _result.W := TVector4.UnitW;
   Exit(_result);
end;

class function TMatrix4x4Helper.TImpl.CreateRotationY(const radians: Single; const centerPoint: TVector3): TImpl;
begin
   var c: Single := System.Cos(radians);
   var s: Single := System.Sin(radians);

   var x: Single := centerPoint.X * (1 - c) - centerPoint.Z * s;
   var z: Single := centerPoint.Z * (1 - c) + centerPoint.X * s;

   // [  c  0 -s  0 ]
   // [  0  1  0  0 ]
   // [  s  0  c  0 ]
   // [  x  0  z  1 ]

   var _result: TImpl;
   _result.X := TVector4.Create(c, 0, -s, 0);
   _result.Y := TVector4.UnitY;
   _result.Z := TVector4.Create(s, 0, c, 0);
   _result.W := TVector4.Create(x, 0, z, 1);
   Exit(_result);
end;

class function TMatrix4x4Helper.TImpl.CreateRotationZ(const radians: Single): TImpl;
begin

   var c: Single := System.Cos(radians);
   var s: Single := System.Sin(radians);

   // [  c  s  0  0 ]
   // [ -s  c  0  0 ]
   // [  0  0  1  0 ]
   // [  0  0  0  1 ]

   var _result: TImpl;
   _result.X := TVector4.Create(c, s, 0, 0);
   _result.Y := TVector4.Create(-s, c, 0, 0);
   _result.Z := TVector4.UnitZ;
   _result.W := TVector4.UnitW;
   Exit(_result);
end;

class function TMatrix4x4Helper.TImpl.CreateRotationZ(const radians: Single; const centerPoint: TVector3): TImpl;
begin
   var c: Single := System.Cos(radians);
   var s: Single := System.Sin(radians);

   var x: Single := centerPoint.X * (1 - c) + centerPoint.Y * s;
   var y: Single := centerPoint.Y * (1 - c) - centerPoint.X * s;

   // [  c  s  0  0 ]
   // [ -s  c  0  0 ]
   // [  0  0  1  0 ]
   // [  x  y  0  1 ]

   var _result: TImpl;
   _result.X := TVector4.Create(c, s, 0, 0);
   _result.Y := TVector4.Create(-s, c, 0, 0);
   _result.Z := TVector4.UnitZ;
   _result.W := TVector4.Create(x, y, 0, 1);
   Exit(_result);
end;

class function TMatrix4x4Helper.TImpl.CreateScale(const scaleX: Single; const scaleY: Single; const scaleZ: Single): TImpl;
begin
   var _result: TImpl;
   _result.X := TVector4.Create(scaleX, 0, 0, 0);
   _result.Y := TVector4.Create(0, scaleY, 0, 0);
   _result.Z := TVector4.Create(0, 0, scaleZ, 0);
   _result.W := TVector4.UnitW;
   Exit(_result);
end;

class function TMatrix4x4Helper.TImpl.CreateScale(const scaleX: Single; const scaleY: Single; const scaleZ: Single; const centerPoint: TVector3): TImpl;
begin
   var _result: TImpl;
   _result.X := TVector4.Create(scaleX, 0, 0, 0);
   _result.Y := TVector4.Create(0, scaleY, 0, 0);
   _result.Z := TVector4.Create(0, 0, scaleZ, 0);
   _result.W := TVector4.Create(centerPoint * (TVector3.One - TVector3.Create(scaleX, scaleY, scaleZ)), 1);
   Exit(_result);
end;

class function TMatrix4x4Helper.TImpl.CreateScale(const scales: TVector3): TImpl;
begin
   var _result: TImpl;


   _result.X := TVector4.Create(scales.X, 0, 0, 0);
   _result.Y := TVector4.Create(0, scales.Y, 0, 0);
   _result.Z := TVector4.Create(0, 0, scales.Z, 0);
   _result.W := TVector4.UnitW;

   Exit(_result);
end;

class function TMatrix4x4Helper.TImpl.CreateScale(const scales: TVector3; const centerPoint: TVector3): TImpl;
begin
   var _result: TImpl;


   _result.X := TVector4.Create(scales.X, 0, 0, 0);
   _result.Y := TVector4.Create(0, scales.Y, 0, 0);
   _result.Z := TVector4.Create(0, 0, scales.Z, 0);
   _result.W := TVector4.Create(centerPoint * (TVector3.One - scales), 1);

   Exit(_result);
end;

class function TMatrix4x4Helper.TImpl.CreateScale(const scale: Single): TImpl;
begin
   var _result: TImpl;


   _result.X := TVector4.Create(scale, 0, 0, 0);
   _result.Y := TVector4.Create(0, scale, 0, 0);
   _result.Z := TVector4.Create(0, 0, scale, 0);
   _result.W := TVector4.UnitW;

   Exit(_result);
end;

class function TMatrix4x4Helper.TImpl.CreateScale(const scale: Single; const centerPoint: TVector3): TImpl;
begin
   var _result: TImpl;


   _result.X := TVector4.Create(scale, 0, 0, 0);
   _result.Y := TVector4.Create(0, scale, 0, 0);
   _result.Z := TVector4.Create(0, 0, scale, 0);
   _result.W := TVector4.Create(centerPoint * (TVector3.One - TVector3.Create(scale)), 1);

   Exit(_result);
end;

class function TMatrix4x4Helper.TImpl.CreateShadow(const lightDirection: TVector3; const plane: TPlane): TImpl;
begin
   var p: TPlane := Plane.Normalize(plane);
   var dot: Single := TVector3.Dot(lightDirection, p.Normal);

   var normal: TVector3 := -p.Normal;

   var _result: TImpl;


   _result.X := TVector4.Create(lightDirection * normal.X, 0) + TVector4.Create(dot, 0, 0, 0);
   _result.Y := TVector4.Create(lightDirection * normal.Y, 0) + TVector4.Create(0, dot, 0, 0);
   _result.Z := TVector4.Create(lightDirection * normal.Z, 0) + TVector4.Create(0, 0, dot, 0);
   _result.W := TVector4.Create(lightDirection * -p.D, dot);

   Exit(_result);
end;

class function TMatrix4x4Helper.TImpl.CreateTranslation(const position: TVector3): TImpl;
begin
   var _result: TImpl;


   _result.X := TVector4.UnitX;
   _result.Y := TVector4.UnitY;
   _result.Z := TVector4.UnitZ;
   _result.W := TVector4.Create(position, 1);

   Exit(_result);
end;

class function TMatrix4x4Helper.TImpl.CreateTranslation(const positionX: Single; const positionY: Single; const positionZ: Single): TImpl;
begin
   var _result: TImpl;


   _result.X := TVector4.UnitX;
   _result.Y := TVector4.UnitY;
   _result.Z := TVector4.UnitZ;
   _result.W := TVector4.Create(positionX, positionY, positionZ, 1);

   Exit(_result);
end;

class function TMatrix4x4Helper.TImpl.CreateViewport(const x: Single; const y: Single; const width: Single; const height: Single; const minDepth: Single; const maxDepth: Single): TImpl;
begin
   var _result: TImpl;

   // 4x SIMD fields to get a lot better codegen

   // 4x SIMD fields to get a lot better codegen
   _result.W := TVector4.Create(width, height, Single(0), Single(0));
   _result.W := _result.W * TVector4.Create(Single(0.5), Single(0.5), Single(0), Single(0));


   _result.X := TVector4.Create(result.W.X, Single(0), Single(0), Single(0));
   _result.Y := TVector4.Create(Single(0), -_result.W.Y, Single(0), Single(0));
   _result.Z := TVector4.Create(Single(0), Single(0), minDepth - maxDepth, Single(0));
   _result.W := _result.W + TVector4.Create(x, y, minDepth, Single(1));

   Exit(_result);
end;

class function TMatrix4x4Helper.TImpl.CreateViewportLeftHanded(const x: Single; const y: Single; const width: Single; const height: Single; const minDepth: Single; const maxDepth: Single): TImpl;
begin
   var _result: TImpl;

   // 4x SIMD fields to get a lot better codegen

   // 4x SIMD fields to get a lot better codegen
   _result.W := TVector4.Create(width, height, Single(0), Single(0));
   _result.W := _result.W * TVector4.Create(Single(0.5), Single(0.5), Single(0), Single(0));


   _result.X := TVector4.Create(result.W.X, Single(0), Single(0), Single(0));
   _result.Y := TVector4.Create(Single(0), -_result.W.Y, Single(0), Single(0));
   _result.Z := TVector4.Create(Single(0), Single(0), maxDepth - minDepth, Single(0));
   _result.W := _result.W + TVector4.Create(x, y, minDepth, Single(1));

   Exit(_result);
end;

class function TMatrix4x4Helper.TImpl.CreateWorld(const position: TVector3; const forward: TVector3; const up: TVector3): TImpl;
begin
   var axisZ: TVector3 := TVector3.Normalize(-forward);
   var axisX: TVector3 := TVector3.Normalize(TVector3.Cross(up, axisZ));
   var axisY: TVector3 := TVector3.Cross(axisZ, axisX);

   var _result: TImpl;


   _result.X := TVector4.Create(axisX, 0);
   _result.Y := TVector4.Create(axisY, 0);
   _result.Z := TVector4.Create(axisZ, 0);
   _result.W := TVector4.Create(position, 1);

   Exit(_result);
end;

class function TMatrix4x4Helper.TImpl.Decompose(const matrix: TImpl; out scale: TVector3; out rotation: TQuaternion; out translation: TVector3): Boolean;
begin
raise ENotImplemented.Create('ainda não fiz isso aqui');

//   var _result: Boolean := true;
//   var scaleBase: PVector3 := @scale;
//   begin
//      var pfScales: PSingle := PSingle(scaleBase);
//      var det: Single;
//
//      var vectorBasis: TVectorBasis;
//      var pVectorBasis: PPVector3 := PPVector3(@vectorBasis);
//
//      var matTemp: TImpl := Identity;
//      var canonicalBasis: TCanonicalBasis := Default(TCanonicalBasis);
//      var pCanonicalBasis: PVector3 := @canonicalBasis.Row0;
//
//
//      canonicalBasis.Row0 := TVector3.Create(Single(1.0), Single(0.0), Single(0.0));
//      canonicalBasis.Row1 := TVector3.Create(Single(0.0), Single(1.0), Single(0.0));
//      canonicalBasis.Row2 := TVector3.Create(Single(0.0), Single(0.0), Single(1.0));
//
//      translation := TVector3.Create(matrix.W.X, matrix.W.Y, matrix.W.Z);
//
//      pVectorBasis^[0] := PVector3(@matTemp.X);
//      pVectorBasis^[1] := PVector3(@matTemp.Y);
//      pVectorBasis^[2] := PVector3(@matTemp.Z);
//
//      pVectorBasis[0]^ := TVector3.Create(matrix.X.X, matrix.X.Y, matrix.X.Z);
//      pVectorBasis[1]^ := TVector3.Create(matrix.Y.X, matrix.Y.Y, matrix.Y.Z);
//      pVectorBasis[2]^ := TVector3.Create(matrix.Z.X, matrix.Z.Y, matrix.Z.Z);
//
//
//      scale.X := pVectorBasis[0]^.Length();
//      scale.Y := pVectorBasis[1]^.Length();
//      scale.Z := pVectorBasis[2]^.Length();
//
//      var a: UInt32;
//
//      var b: UInt32;
//
//      var c: UInt32;
//
//{$REGION 'Ranking'}
//      var x: Single := pfScales[0];
//      var y: Single := pfScales[1];
//      var z: Single := pfScales[2];
//
//      if (x < y) then
//      begin
//         if (y < z) then
//         begin
//            a := 2;
//            b := 1;
//            c := 0;
//         end
//         else
//         begin
//            a := 1;
//
//            if (x < z) then
//            begin
//               b := 2;
//               c := 0;
//            end
//            else
//            begin
//               b := 0;
//               c := 2;
//            end;
//         end;
//      end
//      else
//      begin
//         if (x < z) then
//         begin
//            a := 2;
//            b := 0;
//            c := 1;
//         end
//         else
//         begin
//            a := 0;
//
//            if (y < z) then
//            begin
//               b := 2;
//               c := 1;
//            end
//            else
//            begin
//               b := 1;
//               c := 2;
//            end;
//         end;
//      end;
//{$ENDREGION}
//
//      if (pfScales[a] < DecomposeEpsilon) then
//      begin
//         pVectorBasis[a]^ := pCanonicalBasis[a];
//      end;
//
//      pVectorBasis[a]^ := TVector3.Normalize(pVectorBasis[a]^);
//
//      if (pfScales[b] < DecomposeEpsilon) then
//      begin
//         var cc: UInt32;
//         var fAbsX: Single;
//         var fAbsY: Single;
//         var fAbsZ: Single;
//
//         fAbsX := System.Abs(pVectorBasis[a]^.X);
//         fAbsY := System.Abs(pVectorBasis[a]^.Y);
//         fAbsZ := System.Abs(pVectorBasis[a]^.Z);
//
//{$REGION 'Ranking'}
//         if (fAbsX < fAbsY) then
//         begin
//            if (fAbsY < fAbsZ) then
//            begin
//               cc := 0;
//            end
//            else
//            begin
//               if (fAbsX < fAbsZ) then
//               begin
//                  cc := 0;
//               end
//               else
//               begin
//                  cc := 2;
//               end;
//            end;
//         end
//         else
//         begin
//            if (fAbsX < fAbsZ) then
//            begin
//               cc := 1;
//            end
//            else
//            begin
//               if (fAbsY < fAbsZ) then
//               begin
//                  cc := 1;
//               end
//               else
//               begin
//                  cc := 2;
//               end;
//            end;
//         end;
//{$ENDREGION}
//
//         pVectorBasis[b]^ := TVector3.Cross(pVectorBasis[a]^, (pCanonicalBasis + cc)^);
//      end;
//
//      pVectorBasis[b]^ := TVector3.Normalize(pVectorBasis[b]^);
//
//      if (pfScales[c] < DecomposeEpsilon) then
//      begin
//         pVectorBasis[c]^ := TVector3.Cross(pVectorBasis[a]^, pVectorBasis[b]^);
//      end;
//
//      pVectorBasis[c]^ := TVector3.Normalize(pVectorBasis[c]^);
//
//      det := matTemp.GetDeterminant();
//
//      // use Kramer's rule to check for handedness of coordinate system
//      if (det < Single(0.0)) then
//      begin
//         // switch coordinate system by negating the scale and inverting the basis vector on the x-axis
//         pfScales[a] := pfScales[a];
//         pVectorBasis[a]^ := -(pVectorBasis[a]^);
//
//         det := -det;
//      end;
//
//      det := det - Single(1.0);
//      det := det * det;
//
//      if ((DecomposeEpsilon < det)) then
//      begin
//         // Non-SRT matrix encountered
//         rotation := TQuaternion.Identity;
//         _result := false;
//      end
//      else
//      begin
//         // generate the quaternion from the matrix
//         rotation := TQuaternion.CreateFromRotationMatrix(TMatrix4x4((@matTemp)^));
//      end;
//   end;
//
//   Exit(_result);
end;

class function TMatrix4x4Helper.TImpl.Invert(const matrix: TImpl; out _result: TImpl): Boolean;


      function SoftwareFallback(const matrix: TImpl; out _result: TImpl): Boolean;
      begin
         //                                       -1
         // If you have matrix M, inverse Matrix M   can compute
         //
         //     -1       1
         //    M   = --------- A
         //            det(M)
         //
         // A is adjugate (adjoint) of M, where,
         //
         //      T
         // A = C
         //
         // C is Cofactor matrix of M, where,
         //           i + j
         // C   = (-1)      * det(M  )
         //  ij                    ij
         //
         //     [ a b c d ]
         // M = [ e f g h ]
         //     [ i j k l ]
         //     [ m n o p ]
         //
         // First Row
         //           2  f g h
         // C   = (-1)   j k l  = + ( f ( kp - lo ) - g ( jp - ln ) + h ( jo - kn ) )
         //  11          n o p
         //
         //           3  e g h
         // C   = (-1)   i k l  = - ( e ( kp - lo ) - g ( ip - lm ) + h ( io - km ) )
         //  12          m o p
         //
         //           4  e f h
         // C   = (-1)   i j l  = + ( e ( jp - ln ) - f ( ip - lm ) + h ( in - jm ) )
         //  13          m n p
         //
         //           5  e f g
         // C   = (-1)   i j k  = - ( e ( jo - kn ) - f ( io - km ) + g ( in - jm ) )
         //  14          m n o
         //
         // Second Row
         //           3  b c d
         // C   = (-1)   j k l  = - ( b ( kp - lo ) - c ( jp - ln ) + d ( jo - kn ) )
         //  21          n o p
         //
         //           4  a c d
         // C   = (-1)   i k l  = + ( a ( kp - lo ) - c ( ip - lm ) + d ( io - km ) )
         //  22          m o p
         //
         //           5  a b d
         // C   = (-1)   i j l  = - ( a ( jp - ln ) - b ( ip - lm ) + d ( in - jm ) )
         //  23          m n p
         //
         //           6  a b c
         // C   = (-1)   i j k  = + ( a ( jo - kn ) - b ( io - km ) + c ( in - jm ) )
         //  24          m n o
         //
         // Third Row
         //           4  b c d
         // C   = (-1)   f g h  = + ( b ( gp - ho ) - c ( fp - hn ) + d ( fo - gn ) )
         //  31          n o p
         //
         //           5  a c d
         // C   = (-1)   e g h  = - ( a ( gp - ho ) - c ( ep - hm ) + d ( eo - gm ) )
         //  32          m o p
         //
         //           6  a b d
         // C   = (-1)   e f h  = + ( a ( fp - hn ) - b ( ep - hm ) + d ( en - fm ) )
         //  33          m n p
         //
         //           7  a b c
         // C   = (-1)   e f g  = - ( a ( fo - gn ) - b ( eo - gm ) + c ( en - fm ) )
         //  34          m n o
         //
         // Fourth Row
         //           5  b c d
         // C   = (-1)   f g h  = - ( b ( gl - hk ) - c ( fl - hj ) + d ( fk - gj ) )
         //  41          j k l
         //
         //           6  a c d
         // C   = (-1)   e g h  = + ( a ( gl - hk ) - c ( el - hi ) + d ( ek - gi ) )
         //  42          i k l
         //
         //           7  a b d
         // C   = (-1)   e f h  = - ( a ( fl - hj ) - b ( el - hi ) + d ( ej - fi ) )
         //  43          i j l
         //
         //           8  a b c
         // C   = (-1)   e f g  = + ( a ( fk - gj ) - b ( ek - gi ) + c ( ej - fi ) )
         //  44          i j k
         //
         // Cost of operation
         // 53 adds, 104 muls, and 1 div.

         var a: Single := matrix.X.X;
         //                                       -1
         // If you have matrix M, inverse Matrix M   can compute
         //
         //     -1       1
         //    M   = --------- A
         //            det(M)
         //
         // A is adjugate (adjoint) of M, where,
         //
         //      T
         // A = C
         //
         // C is Cofactor matrix of M, where,
         //           i + j
         // C   = (-1)      * det(M  )
         //  ij                    ij
         //
         //     [ a b c d ]
         // M = [ e f g h ]
         //     [ i j k l ]
         //     [ m n o p ]
         //
         // First Row
         //           2  f g h
         // C   = (-1)   j k l  = + ( f ( kp - lo ) - g ( jp - ln ) + h ( jo - kn ) )
         //  11          n o p
         //
         //           3  e g h
         // C   = (-1)   i k l  = - ( e ( kp - lo ) - g ( ip - lm ) + h ( io - km ) )
         //  12          m o p
         //
         //           4  e f h
         // C   = (-1)   i j l  = + ( e ( jp - ln ) - f ( ip - lm ) + h ( in - jm ) )
         //  13          m n p
         //
         //           5  e f g
         // C   = (-1)   i j k  = - ( e ( jo - kn ) - f ( io - km ) + g ( in - jm ) )
         //  14          m n o
         //
         // Second Row
         //           3  b c d
         // C   = (-1)   j k l  = - ( b ( kp - lo ) - c ( jp - ln ) + d ( jo - kn ) )
         //  21          n o p
         //
         //           4  a c d
         // C   = (-1)   i k l  = + ( a ( kp - lo ) - c ( ip - lm ) + d ( io - km ) )
         //  22          m o p
         //
         //           5  a b d
         // C   = (-1)   i j l  = - ( a ( jp - ln ) - b ( ip - lm ) + d ( in - jm ) )
         //  23          m n p
         //
         //           6  a b c
         // C   = (-1)   i j k  = + ( a ( jo - kn ) - b ( io - km ) + c ( in - jm ) )
         //  24          m n o
         //
         // Third Row
         //           4  b c d
         // C   = (-1)   f g h  = + ( b ( gp - ho ) - c ( fp - hn ) + d ( fo - gn ) )
         //  31          n o p
         //
         //           5  a c d
         // C   = (-1)   e g h  = - ( a ( gp - ho ) - c ( ep - hm ) + d ( eo - gm ) )
         //  32          m o p
         //
         //           6  a b d
         // C   = (-1)   e f h  = + ( a ( fp - hn ) - b ( ep - hm ) + d ( en - fm ) )
         //  33          m n p
         //
         //           7  a b c
         // C   = (-1)   e f g  = - ( a ( fo - gn ) - b ( eo - gm ) + c ( en - fm ) )
         //  34          m n o
         //
         // Fourth Row
         //           5  b c d
         // C   = (-1)   f g h  = - ( b ( gl - hk ) - c ( fl - hj ) + d ( fk - gj ) )
         //  41          j k l
         //
         //           6  a c d
         // C   = (-1)   e g h  = + ( a ( gl - hk ) - c ( el - hi ) + d ( ek - gi ) )
         //  42          i k l
         //
         //           7  a b d
         // C   = (-1)   e f h  = - ( a ( fl - hj ) - b ( el - hi ) + d ( ej - fi ) )
         //  43          i j l
         //
         //           8  a b c
         // C   = (-1)   e f g  = + ( a ( fk - gj ) - b ( ek - gi ) + c ( ej - fi ) )
         //  44          i j k
         //
         // Cost of operation
         // 53 adds, 104 muls, and 1 div.

         var b: Single := matrix.X.Y;
         //                                       -1
         // If you have matrix M, inverse Matrix M   can compute
         //
         //     -1       1
         //    M   = --------- A
         //            det(M)
         //
         // A is adjugate (adjoint) of M, where,
         //
         //      T
         // A = C
         //
         // C is Cofactor matrix of M, where,
         //           i + j
         // C   = (-1)      * det(M  )
         //  ij                    ij
         //
         //     [ a b c d ]
         // M = [ e f g h ]
         //     [ i j k l ]
         //     [ m n o p ]
         //
         // First Row
         //           2  f g h
         // C   = (-1)   j k l  = + ( f ( kp - lo ) - g ( jp - ln ) + h ( jo - kn ) )
         //  11          n o p
         //
         //           3  e g h
         // C   = (-1)   i k l  = - ( e ( kp - lo ) - g ( ip - lm ) + h ( io - km ) )
         //  12          m o p
         //
         //           4  e f h
         // C   = (-1)   i j l  = + ( e ( jp - ln ) - f ( ip - lm ) + h ( in - jm ) )
         //  13          m n p
         //
         //           5  e f g
         // C   = (-1)   i j k  = - ( e ( jo - kn ) - f ( io - km ) + g ( in - jm ) )
         //  14          m n o
         //
         // Second Row
         //           3  b c d
         // C   = (-1)   j k l  = - ( b ( kp - lo ) - c ( jp - ln ) + d ( jo - kn ) )
         //  21          n o p
         //
         //           4  a c d
         // C   = (-1)   i k l  = + ( a ( kp - lo ) - c ( ip - lm ) + d ( io - km ) )
         //  22          m o p
         //
         //           5  a b d
         // C   = (-1)   i j l  = - ( a ( jp - ln ) - b ( ip - lm ) + d ( in - jm ) )
         //  23          m n p
         //
         //           6  a b c
         // C   = (-1)   i j k  = + ( a ( jo - kn ) - b ( io - km ) + c ( in - jm ) )
         //  24          m n o
         //
         // Third Row
         //           4  b c d
         // C   = (-1)   f g h  = + ( b ( gp - ho ) - c ( fp - hn ) + d ( fo - gn ) )
         //  31          n o p
         //
         //           5  a c d
         // C   = (-1)   e g h  = - ( a ( gp - ho ) - c ( ep - hm ) + d ( eo - gm ) )
         //  32          m o p
         //
         //           6  a b d
         // C   = (-1)   e f h  = + ( a ( fp - hn ) - b ( ep - hm ) + d ( en - fm ) )
         //  33          m n p
         //
         //           7  a b c
         // C   = (-1)   e f g  = - ( a ( fo - gn ) - b ( eo - gm ) + c ( en - fm ) )
         //  34          m n o
         //
         // Fourth Row
         //           5  b c d
         // C   = (-1)   f g h  = - ( b ( gl - hk ) - c ( fl - hj ) + d ( fk - gj ) )
         //  41          j k l
         //
         //           6  a c d
         // C   = (-1)   e g h  = + ( a ( gl - hk ) - c ( el - hi ) + d ( ek - gi ) )
         //  42          i k l
         //
         //           7  a b d
         // C   = (-1)   e f h  = - ( a ( fl - hj ) - b ( el - hi ) + d ( ej - fi ) )
         //  43          i j l
         //
         //           8  a b c
         // C   = (-1)   e f g  = + ( a ( fk - gj ) - b ( ek - gi ) + c ( ej - fi ) )
         //  44          i j k
         //
         // Cost of operation
         // 53 adds, 104 muls, and 1 div.

         var c: Single := matrix.X.Z;
         //                                       -1
         // If you have matrix M, inverse Matrix M   can compute
         //
         //     -1       1
         //    M   = --------- A
         //            det(M)
         //
         // A is adjugate (adjoint) of M, where,
         //
         //      T
         // A = C
         //
         // C is Cofactor matrix of M, where,
         //           i + j
         // C   = (-1)      * det(M  )
         //  ij                    ij
         //
         //     [ a b c d ]
         // M = [ e f g h ]
         //     [ i j k l ]
         //     [ m n o p ]
         //
         // First Row
         //           2  f g h
         // C   = (-1)   j k l  = + ( f ( kp - lo ) - g ( jp - ln ) + h ( jo - kn ) )
         //  11          n o p
         //
         //           3  e g h
         // C   = (-1)   i k l  = - ( e ( kp - lo ) - g ( ip - lm ) + h ( io - km ) )
         //  12          m o p
         //
         //           4  e f h
         // C   = (-1)   i j l  = + ( e ( jp - ln ) - f ( ip - lm ) + h ( in - jm ) )
         //  13          m n p
         //
         //           5  e f g
         // C   = (-1)   i j k  = - ( e ( jo - kn ) - f ( io - km ) + g ( in - jm ) )
         //  14          m n o
         //
         // Second Row
         //           3  b c d
         // C   = (-1)   j k l  = - ( b ( kp - lo ) - c ( jp - ln ) + d ( jo - kn ) )
         //  21          n o p
         //
         //           4  a c d
         // C   = (-1)   i k l  = + ( a ( kp - lo ) - c ( ip - lm ) + d ( io - km ) )
         //  22          m o p
         //
         //           5  a b d
         // C   = (-1)   i j l  = - ( a ( jp - ln ) - b ( ip - lm ) + d ( in - jm ) )
         //  23          m n p
         //
         //           6  a b c
         // C   = (-1)   i j k  = + ( a ( jo - kn ) - b ( io - km ) + c ( in - jm ) )
         //  24          m n o
         //
         // Third Row
         //           4  b c d
         // C   = (-1)   f g h  = + ( b ( gp - ho ) - c ( fp - hn ) + d ( fo - gn ) )
         //  31          n o p
         //
         //           5  a c d
         // C   = (-1)   e g h  = - ( a ( gp - ho ) - c ( ep - hm ) + d ( eo - gm ) )
         //  32          m o p
         //
         //           6  a b d
         // C   = (-1)   e f h  = + ( a ( fp - hn ) - b ( ep - hm ) + d ( en - fm ) )
         //  33          m n p
         //
         //           7  a b c
         // C   = (-1)   e f g  = - ( a ( fo - gn ) - b ( eo - gm ) + c ( en - fm ) )
         //  34          m n o
         //
         // Fourth Row
         //           5  b c d
         // C   = (-1)   f g h  = - ( b ( gl - hk ) - c ( fl - hj ) + d ( fk - gj ) )
         //  41          j k l
         //
         //           6  a c d
         // C   = (-1)   e g h  = + ( a ( gl - hk ) - c ( el - hi ) + d ( ek - gi ) )
         //  42          i k l
         //
         //           7  a b d
         // C   = (-1)   e f h  = - ( a ( fl - hj ) - b ( el - hi ) + d ( ej - fi ) )
         //  43          i j l
         //
         //           8  a b c
         // C   = (-1)   e f g  = + ( a ( fk - gj ) - b ( ek - gi ) + c ( ej - fi ) )
         //  44          i j k
         //
         // Cost of operation
         // 53 adds, 104 muls, and 1 div.

         var d: Single := matrix.X.W;
         var e: Single := matrix.Y.X;
         var f: Single := matrix.Y.Y;
         var g: Single := matrix.Y.Z;
         var h: Single := matrix.Y.W;
         var i: Single := matrix.Z.X;
         var j: Single := matrix.Z.Y;
         var k: Single := matrix.Z.Z;
         var l: Single := matrix.Z.W;
         var m: Single := matrix.W.X;
         var n: Single := matrix.W.Y;
         var o: Single := matrix.W.Z;
         var p: Single := matrix.W.W;

         var kp_lo: Single := k * p - l * o;
         var jp_ln: Single := j * p - l * n;
         var jo_kn: Single := j * o - k * n;
         var ip_lm: Single := i * p - l * m;
         var io_km: Single := i * o - k * m;
         var in_jm: Single := i * n - j * m;

         var a11: Single := +(f * kp_lo - g * jp_ln + h * jo_kn);
         var a12: Single := -(e * kp_lo - g * ip_lm + h * io_km);
         var a13: Single := +(e * jp_ln - f * ip_lm + h * in_jm);
         var a14: Single := -(e * jo_kn - f * io_km + g * in_jm);

         var det: Single := a * a11 + b * a12 + c * a13 + d * a14;

         if (System.Abs(det) < Single.Epsilon) then
         begin
            var vNaN: TVector4 := TVector4.Create(Single.NaN);
            _result.X := vNaN;
            _result.Y := vNaN;
            _result.Z := vNaN;
            _result.W := vNaN;
            Exit(false);
         end;

         var invDet: Single := Single(1.0) / det;

         _result.X.X := a11 * invDet;
         _result.Y.X := a12 * invDet;
         _result.Z.X := a13 * invDet;
         _result.W.X := a14 * invDet;

         _result.X.Y := -(b * kp_lo - c * jp_ln + d * jo_kn) * invDet;
         _result.Y.Y := +(a * kp_lo - c * ip_lm + d * io_km) * invDet;
         _result.Z.Y := -(a * jp_ln - b * ip_lm + d * in_jm) * invDet;
         _result.W.Y := +(a * jo_kn - b * io_km + c * in_jm) * invDet;

         var gp_ho: Single := g * p - h * o;
         var fp_hn: Single := f * p - h * n;
         var fo_gn: Single := f * o - g * n;
         var ep_hm: Single := e * p - h * m;
         var eo_gm: Single := e * o - g * m;
         var en_fm: Single := e * n - f * m;



         _result.X.Z := +(b * gp_ho - c * fp_hn + d * fo_gn) * invDet;
         _result.Y.Z := -(a * gp_ho - c * ep_hm + d * eo_gm) * invDet;
         _result.Z.Z := +(a * fp_hn - b * ep_hm + d * en_fm) * invDet;
         _result.W.Z := -(a * fo_gn - b * eo_gm + c * en_fm) * invDet;

         var gl_hk: Single := g * l - h * k;
         var fl_hj: Single := f * l - h * j;
         var fk_gj: Single := f * k - g * j;
         var el_hi: Single := e * l - h * i;
         var ek_gi: Single := e * k - g * i;
         var ej_fi: Single := e * j - f * i;



         _result.X.W := -(b * gl_hk - c * fl_hj + d * fk_gj) * invDet;
         _result.Y.W := +(a * gl_hk - c * el_hi + d * ek_gi) * invDet;
         _result.Z.W := -(a * fl_hj - b * el_hi + d * ej_fi) * invDet;
         _result.W.W := +(a * fk_gj - b * ek_gi + c * ej_fi) * invDet;

         Exit(true);
      end;


begin
   // This implementation is based on the DirectX Math Library XMMatrixInverse method
   // https://github.com/microsoft/DirectXMath/blob/master/Inc/DirectXMathMatrix.inl

//   if (Sse.IsSupported) then
//   begin
//      Exit(SseImpl(matrix, result));
//   end;

   Exit(SoftwareFallback(matrix, _result));
end;

class function TMatrix4x4Helper.TImpl.Lerp(const left: TImpl; const right: TImpl; const amount: Single): TImpl;
begin
   var _result: TImpl;


   _result.X := TVector4.Lerp(left.X, right.X, amount);
   _result.Y := TVector4.Lerp(left.Y, right.Y, amount);
   _result.Z := TVector4.Lerp(left.Z, right.Z, amount);
   _result.W := TVector4.Lerp(left.W, right.W, amount);

   Exit(_result);
end;

class function TMatrix4x4Helper.TImpl.Transform(const value: TImpl; const rotation: TQuaternion): TImpl;
begin
   // Compute rotation matrix.
   var x2: Single := rotation.X + rotation.X;
   var y2: Single := rotation.Y + rotation.Y;
   var z2: Single := rotation.Z + rotation.Z;

   var wx2: Single := rotation.W * x2;
   var wy2: Single := rotation.W * y2;
   var wz2: Single := rotation.W * z2;

   var xx2: Single := rotation.X * x2;
   var xy2: Single := rotation.X * y2;
   var xz2: Single := rotation.X * z2;

   var yy2: Single := rotation.Y * y2;
   var yz2: Single := rotation.Y * z2;
   var zz2: Single := rotation.Z * z2;

   var q11: Single := Single(1.0) - yy2 - zz2;
   var q21: Single := xy2 - wz2;
   var q31: Single := xz2 + wy2;

   var q12: Single := xy2 + wz2;
   var q22: Single := Single(1.0) - xx2 - zz2;
   var q32: Single := yz2 - wx2;

   var q13: Single := xz2 - wy2;
   var q23: Single := yz2 + wx2;
   var q33: Single := Single(1.0) - xx2 - yy2;

   var _result: TImpl;


   _result.X := TVector4.Create(value.X.X * q11 + value.X.Y * q21 + value.X.Z * q31, value.X.X * q12 + value.X.Y * q22 + value.X.Z * q32, value.X.X * q13 + value.X.Y * q23 + value.X.Z * q33, value.X.W);
   _result.Y := TVector4.Create(value.Y.X * q11 + value.Y.Y * q21 + value.Y.Z * q31, value.Y.X * q12 + value.Y.Y * q22 + value.Y.Z * q32, value.Y.X * q13 + value.Y.Y * q23 + value.Y.Z * q33, value.Y.W);
   _result.Z := TVector4.Create(value.Z.X * q11 + value.Z.Y * q21 + value.Z.Z * q31, value.Z.X * q12 + value.Z.Y * q22 + value.Z.Z * q32, value.Z.X * q13 + value.Z.Y * q23 + value.Z.Z * q33, value.Z.W);
   _result.W := TVector4.Create(value.W.X * q11 + value.W.Y * q21 + value.W.Z * q31, value.W.X * q12 + value.W.Y * q22 + value.W.Z * q32, value.W.X * q13 + value.W.Y * q23 + value.W.Z * q33, value.W.W);

   Exit(_result);
end;

class function TMatrix4x4Helper.TImpl.Transpose(const matrix: TImpl): TImpl;
begin
   // This implementation is based on the DirectX Math Library XMMatrixTranspose method
   // https://github.com/microsoft/DirectXMath/blob/master/Inc/DirectXMathMatrix.inl

   var _result: TImpl;

//   if (AdvSimd.Arm64.IsSupported) then
//   begin
//      var x: TVector128<Single> := matrix.X.AsVector128();
//      var y: TVector128<Single> := matrix.Y.AsVector128();
//      var z: TVector128<Single> := matrix.Z.AsVector128();
//      var w: TVector128<Single> := matrix.W.AsVector128();
//
//      var lowerXZ: TVector128<Single> := AdvSimd.Arm64.ZipLow(x, z);// x[0], z[0], x[1], z[1]
//      var lowerYW: TVector128<Single> := AdvSimd.Arm64.ZipLow(y, w);// y[0], w[0], y[1], w[1]
//      var upperXZ: TVector128<Single> := AdvSimd.Arm64.ZipHigh(x, z);// x[2], z[2], x[3], z[3]
//      var upperYW: TVector128<Single> := AdvSimd.Arm64.ZipHigh(y, w);// y[2], w[2], y[3], z[3]
//
//
//      _result.X := AdvSimd.Arm64.ZipLow(lowerXZ, lowerYW).AsVector4();  // x[0], y[0], z[0], w[0]
//      _result.Y := AdvSimd.Arm64.ZipHigh(lowerXZ, lowerYW).AsVector4(); // x[1], y[1], z[1], w[1]
//      _result.Z := AdvSimd.Arm64.ZipLow(upperXZ, upperYW).AsVector4();  // x[2], y[2], z[2], w[2]
//      _result.W := AdvSimd.Arm64.ZipHigh(upperXZ, upperYW).AsVector4(); // x[3], y[3], z[3], w[3]
//   end
//   else if (Sse.IsSupported) then
//   begin
//      var x: TVector128<Single> := matrix.X.AsVector128();
//      var y: TVector128<Single> := matrix.Y.AsVector128();
//      var z: TVector128<Single> := matrix.Z.AsVector128();
//      var w: TVector128<Single> := matrix.W.AsVector128();
//
//      var lowerXZ: TVector128<Single> := Sse.UnpackLow(x, z);// x[0], z[0], x[1], z[1]
//      var lowerYW: TVector128<Single> := Sse.UnpackLow(y, w);// y[0], w[0], y[1], w[1]
//      var upperXZ: TVector128<Single> := Sse.UnpackHigh(x, z);// x[2], z[2], x[3], z[3]
//      var upperYW: TVector128<Single> := Sse.UnpackHigh(y, w);// y[2], w[2], y[3], z[3]
//
//
//      _result.X := Sse.UnpackLow(lowerXZ, lowerYW).AsVector4();         // x[0], y[0], z[0], w[0]
//      _result.Y := Sse.UnpackHigh(lowerXZ, lowerYW).AsVector4();        // x[1], y[1], z[1], w[1]
//      _result.Z := Sse.UnpackLow(upperXZ, upperYW).AsVector4();         // x[2], y[2], z[2], w[2]
//      _result.W := Sse.UnpackHigh(upperXZ, upperYW).AsVector4();        // x[3], y[3], z[3], w[3]
//   end
//   else
   begin
      _result.X := TVector4.Create(matrix.X.X, matrix.Y.X, matrix.Z.X, matrix.W.X);
      _result.Y := TVector4.Create(matrix.X.Y, matrix.Y.Y, matrix.Z.Y, matrix.W.Y);
      _result.Z := TVector4.Create(matrix.X.Z, matrix.Y.Z, matrix.Z.Z, matrix.W.Z);
      _result.W := TVector4.Create(matrix.X.W, matrix.Y.W, matrix.Z.W, matrix.W.W);
   end;

   Exit(_result);
end;

function TMatrix4x4Helper.TImpl.Equals(const other: TImpl): Boolean;
begin
   Exit((X.Equals(other.X)) and (Y.Equals(other.Y)) and (Z.Equals(other.Z)) and (W.Equals(other.W)));
end;

function TMatrix4x4Helper.TImpl.GetDeterminant(): Single;
begin
   //  a b c d       f g h       e g h       e f h       e f g
   //  e f g h  = a  j k l  - b  i k l  + c  i j l  - d  i j k
   //  i j k l       n o p       m o p       m n p       m n o
   //  m n o p
   //
   //    f g h
   // a  j k l  = a ( f ( kp - lo ) - g ( jp - ln ) + h ( jo - kn ) )
   //    n o p
   //
   //    e g h
   // b  i k l  = b ( e ( kp - lo ) - g ( ip - lm ) + h ( io - km ) )
   //    m o p
   //
   //    e f h
   // c  i j l  = c ( e ( jp - ln ) - f ( ip - lm ) + h ( in - jm ) )
   //    m n p
   //
   //    e f g
   // d  i j k  = d ( e ( jo - kn ) - f ( io - km ) + g ( in - jm ) )
   //    m n o
   //
   // Cost of operation
   // 17 adds and 28 muls.
   //
   // add: 6 + 8 + 3 = 17
   // mul: 12 + 16 = 28

   var a: Single := X.X;
   //  a b c d       f g h       e g h       e f h       e f g
   //  e f g h  = a  j k l  - b  i k l  + c  i j l  - d  i j k
   //  i j k l       n o p       m o p       m n p       m n o
   //  m n o p
   //
   //    f g h
   // a  j k l  = a ( f ( kp - lo ) - g ( jp - ln ) + h ( jo - kn ) )
   //    n o p
   //
   //    e g h
   // b  i k l  = b ( e ( kp - lo ) - g ( ip - lm ) + h ( io - km ) )
   //    m o p
   //
   //    e f h
   // c  i j l  = c ( e ( jp - ln ) - f ( ip - lm ) + h ( in - jm ) )
   //    m n p
   //
   //    e f g
   // d  i j k  = d ( e ( jo - kn ) - f ( io - km ) + g ( in - jm ) )
   //    m n o
   //
   // Cost of operation
   // 17 adds and 28 muls.
   //
   // add: 6 + 8 + 3 = 17
   // mul: 12 + 16 = 28

   var b: Single := X.Y;
   //  a b c d       f g h       e g h       e f h       e f g
   //  e f g h  = a  j k l  - b  i k l  + c  i j l  - d  i j k
   //  i j k l       n o p       m o p       m n p       m n o
   //  m n o p
   //
   //    f g h
   // a  j k l  = a ( f ( kp - lo ) - g ( jp - ln ) + h ( jo - kn ) )
   //    n o p
   //
   //    e g h
   // b  i k l  = b ( e ( kp - lo ) - g ( ip - lm ) + h ( io - km ) )
   //    m o p
   //
   //    e f h
   // c  i j l  = c ( e ( jp - ln ) - f ( ip - lm ) + h ( in - jm ) )
   //    m n p
   //
   //    e f g
   // d  i j k  = d ( e ( jo - kn ) - f ( io - km ) + g ( in - jm ) )
   //    m n o
   //
   // Cost of operation
   // 17 adds and 28 muls.
   //
   // add: 6 + 8 + 3 = 17
   // mul: 12 + 16 = 28

   var c: Single := X.Z;
   //  a b c d       f g h       e g h       e f h       e f g
   //  e f g h  = a  j k l  - b  i k l  + c  i j l  - d  i j k
   //  i j k l       n o p       m o p       m n p       m n o
   //  m n o p
   //
   //    f g h
   // a  j k l  = a ( f ( kp - lo ) - g ( jp - ln ) + h ( jo - kn ) )
   //    n o p
   //
   //    e g h
   // b  i k l  = b ( e ( kp - lo ) - g ( ip - lm ) + h ( io - km ) )
   //    m o p
   //
   //    e f h
   // c  i j l  = c ( e ( jp - ln ) - f ( ip - lm ) + h ( in - jm ) )
   //    m n p
   //
   //    e f g
   // d  i j k  = d ( e ( jo - kn ) - f ( io - km ) + g ( in - jm ) )
   //    m n o
   //
   // Cost of operation
   // 17 adds and 28 muls.
   //
   // add: 6 + 8 + 3 = 17
   // mul: 12 + 16 = 28

   var d: Single := X.W;
   var e: Single := Y.X;
   var f: Single := Y.Y;
   var g: Single := Y.Z;
   var h: Single := Y.W;
   var i: Single := Z.X;
   var j: Single := Z.Y;
   var k: Single := Z.Z;
   var l: Single := Z.W;
   var m: Single := W.X;
   var n: Single := W.Y;
   var o: Single := W.Z;
   var p: Single := W.W;

   var kp_lo: Single := k * p - l * o;
   var jp_ln: Single := j * p - l * n;
   var jo_kn: Single := j * o - k * n;
   var ip_lm: Single := i * p - l * m;
   var io_km: Single := i * o - k * m;
   var in_jm: Single := i * n - j * m;

   Exit(a * (f * kp_lo - g * jp_ln + h * jo_kn) - b * (e * kp_lo - g * ip_lm + h * io_km) + c * (e * jp_ln - f * ip_lm + h * in_jm) - d * (e * jo_kn - f * io_km + g * in_jm));
end;

function TMatrix4x4Helper.TImpl.GetItem(const row: Integer; const column: Integer): Single;
begin
raise ENotImplemented.Create('ainda não fiz isso aqui');
   if (UInt32(row) >= RowCount) then
   begin
      raise EArgumentOutOfRangeException.Create('');
   end;


//   Result := PVector4(@Self.X)[row][column];
end;

procedure TMatrix4x4Helper.TImpl.SetItem(const row: Integer; const column: Integer; const Value: Single);
begin
raise ENotImplemented.Create('ainda não fiz isso aqui');
   if (UInt32(row) >= RowCount) then
   begin
      raise EArgumentOutOfRangeException.Create('');
   end;

//   PVector4(@Self.X)[row][column] := value;
end;

class operator TMatrix4x4Helper.TImpl.Add(const left: TImpl; const right: TImpl): TImpl;
begin
   var _result: TImpl;
   _result.X := left.X + right.X;
   _result.Y := left.Y + right.Y;
   _result.Z := left.Z + right.Z;
   _result.W := left.W + right.W;
   Exit(_result);
end;

class operator TMatrix4x4Helper.TImpl.Equal(const left: TImpl; const right: TImpl): Boolean;
begin
   Exit(((left.X = right.X)) and ((left.Y = right.Y)) and ((left.Z = right.Z)) and ((left.W = right.W)));
end;

class operator TMatrix4x4Helper.TImpl.NotEqual(const left: TImpl; const right: TImpl): Boolean;
begin
   Exit(((left.X <> right.X)) or ((left.Y <> right.Y)) or ((left.Z <> right.Z)) or ((left.W <> right.W)));
end;

class operator TMatrix4x4Helper.TImpl.Multiply(const left: TImpl; const right: TImpl): TImpl;
begin
begin
   var _result: TImpl;

   // result.X = Transform(left.X, in right);

   // result.X = Transform(left.X, in right);
   _result.X := right.X * left.X.X;
   _result.X := _result.X + right.Y * left.X.Y;
   _result.X := _result.X + right.Z * left.X.Z;
   _result.X := _result.X + right.W * left.X.W;

   // result.Y = Transform(left.Y, in right);

   // result.Y = Transform(left.Y, in right);
   _result.Y := right.X * left.Y.X;
   _result.Y := _result.Y + right.Y * left.Y.Y;
   _result.Y := _result.Y + right.Z * left.Y.Z;
   _result.Y := _result.Y + right.W * left.Y.W;

   // result.Z = Transform(left.Z, in right);

   // result.Z = Transform(left.Z, in right);
   _result.Z := right.X * left.Z.X;
   _result.Z := _result.Z + right.Y * left.Z.Y;
   _result.Z := _result.Z + right.Z * left.Z.Z;
   _result.Z := _result.Z + right.W * left.Z.W;

   // result.W = Transform(left.W, in right);

   // result.W = Transform(left.W, in right);
   _result.W := right.X * left.W.X;
   _result.W := _result.W + right.Y * left.W.Y;
   _result.W := _result.W + right.Z * left.W.Z;
   _result.W := _result.W + right.W * left.W.W;

   Exit(_result);
end;
end;

class operator TMatrix4x4Helper.TImpl.Multiply(const left: TImpl; const right: Single): TImpl;
begin
begin
   var _result: TImpl;


   _result.X := left.X * right;
   _result.Y := left.Y * right;
   _result.Z := left.Z * right;
   _result.W := left.W * right;

   Exit(_result);
end;
end;

class operator TMatrix4x4Helper.TImpl.Subtract(const left: TImpl; const right: TImpl): TImpl;
begin
begin
   var _result: TImpl;


   _result.X := left.X - right.X;
   _result.Y := left.Y - right.Y;
   _result.Z := left.Z - right.Z;
   _result.W := left.W - right.W;

   Exit(_result);
end;
end;

class operator TMatrix4x4Helper.TImpl.Negative(const value: TImpl): TImpl;
begin
begin
   var _result: TImpl;


   _result.X := -value.X;
   _result.Y := -value.Y;
   _result.Z := -value.Z;
   _result.W := -value.W;

   Exit(_result);
end;
end;

{$ENDREGION 'TMatrix4x4Helper.TImpl'}

{ TMatrix4x4Helper }

function TMatrix4x4Helper.AsImpl(): TImpl;
begin
   Result := TImpl(Self);
end;

function TMatrix4x4Helper.AsROImpl(): PImpl;
begin
   Result := PImpl(@Self);
end;

{$ENDREGION 'TMatrix4x4Helper'}

{$REGION 'TQuaternion'}

{ TQuaternion }

class function TQuaternion.GetZero(): TQuaternion;
begin
   Result := default(TQuaternion);
end;

class function TQuaternion.GetIdentity(): TQuaternion;
begin
   Result := TQuaternion.Create(Single(0.0), Single(0.0), Single(0.0), Single(1.0));
end;

function TQuaternion.GetIsIdentity(): Boolean;
begin
   Result := Self = Identity;
end;

constructor TQuaternion.Create(const x: Single; const y: Single; const z: Single; const w: Single);
begin
   Self.X := x;
   Self.Y := y;
   Self.Z := z;
   Self.W := w;
end;

class function TQuaternion.Add(const value1: TQuaternion; const value2: TQuaternion): TQuaternion;
begin
   Exit(value1 + value2);
end;

class function TQuaternion.Concatenate(const value1: TQuaternion; const value2: TQuaternion): TQuaternion;
begin
   var ans: TQuaternion;

   // Concatenate rotation is actually q2 * q1 instead of q1 * q2.
   // So that's why value2 goes q1 and value1 goes q2.
   var q1x: Single := value2.X;
   var q1y: Single := value2.Y;
   var q1z: Single := value2.Z;
   var q1w: Single := value2.W;

   var q2x: Single := value1.X;
   var q2y: Single := value1.Y;
   var q2z: Single := value1.Z;
   var q2w: Single := value1.W;

   // cross(av, bv)
   var cx: Single := q1y * q2z - q1z * q2y;
   var cy: Single := q1z * q2x - q1x * q2z;
   var cz: Single := q1x * q2y - q1y * q2x;

   var dot: Single := q1x * q2x + q1y * q2y + q1z * q2z;


   ans.X := q1x * q2w + q2x * q1w + cx;
   ans.Y := q1y * q2w + q2y * q1w + cy;
   ans.Z := q1z * q2w + q2z * q1w + cz;
   ans.W := q1w * q2w - dot;

   Exit(ans);
end;

class function TQuaternion.Conjugate(const value: TQuaternion): TQuaternion;
begin

   Exit(Multiply(value, TVector4.Create(Single(-1.0), Single(-1.0), Single(-1.0), Single(1.0))));
end;

class function TQuaternion.CreateFromRotationMatrix(const matrix: TMatrix4x4): TQuaternion;
begin
   var trace: Single := matrix.M11 + matrix.M22 + matrix.M33;

   var q: TQuaternion := Default(TQuaternion);

   if (trace > Single(0.0)) then
   begin
      var s: Single := System.Sqrt(trace + Single(1.0));
      q.W := s * Single(0.5);
      s := Single(0.5) / s;
      q.X := (matrix.M23 - matrix.M32) * s;
      q.Y := (matrix.M31 - matrix.M13) * s;
      q.Z := (matrix.M12 - matrix.M21) * s;
   end
   else
   begin
      if (matrix.M11 >= matrix.M22) and (matrix.M11 >= matrix.M33) then
      begin
         var s: Single := System.Sqrt(Single(1.0) + matrix.M11 - matrix.M22 - matrix.M33);
         var invS: Single := Single(0.5) / s;
         q.X := Single(0.5) * s;
         q.Y := (matrix.M12 + matrix.M21) * invS;
         q.Z := (matrix.M13 + matrix.M31) * invS;
         q.W := (matrix.M23 - matrix.M32) * invS;
      end
      else if (matrix.M22 > matrix.M33) then
      begin
         var s: Single := System.Sqrt(Single(1.0) + matrix.M22 - matrix.M11 - matrix.M33);
         var invS: Single := Single(0.5) / s;
         q.X := (matrix.M21 + matrix.M12) * invS;
         q.Y := Single(0.5) * s;
         q.Z := (matrix.M32 + matrix.M23) * invS;
         q.W := (matrix.M31 - matrix.M13) * invS;
      end
      else
      begin
         var s: Single := System.Sqrt(Single(1.0) + matrix.M33 - matrix.M11 - matrix.M22);
         var invS: Single := Single(0.5) / s;
         q.X := (matrix.M31 + matrix.M13) * invS;
         q.Y := (matrix.M32 + matrix.M23) * invS;
         q.Z := Single(0.5) * s;
         q.W := (matrix.M12 - matrix.M21) * invS;
      end;
   end;

   Exit(q);
end;

class function TQuaternion.CreateFromYawPitchRoll(const yaw: Single; const pitch: Single; const roll: Single): TQuaternion;
begin
   //  Roll first, about axis the object is facing, then
   //  pitch upward, then yaw to face into the new heading
   var sr: Single;
   //  Roll first, about axis the object is facing, then
   //  pitch upward, then yaw to face into the new heading
   var cr: Single;
   //  Roll first, about axis the object is facing, then
   //  pitch upward, then yaw to face into the new heading
   var sp: Single;
   //  Roll first, about axis the object is facing, then
   //  pitch upward, then yaw to face into the new heading
   var cp: Single;
   //  Roll first, about axis the object is facing, then
   //  pitch upward, then yaw to face into the new heading
   var sy: Single;
   //  Roll first, about axis the object is facing, then
   //  pitch upward, then yaw to face into the new heading
   var cy: Single;

   var halfRoll: Single := roll * Single(0.5);
   sr := System.Sin(halfRoll);
   cr := System.Cos(halfRoll);

   var halfPitch: Single := pitch * Single(0.5);
   sp := System.Sin(halfPitch);
   cp := System.Cos(halfPitch);

   var halfYaw: Single := yaw * Single(0.5);
   sy := System.Sin(halfYaw);
   cy := System.Cos(halfYaw);

   var _result: TQuaternion;


   _result.X := cy * sp * cr + sy * cp * sr;
   _result.Y := sy * cp * cr - cy * sp * sr;
   _result.Z := cy * cp * sr - sy * sp * cr;
   _result.W := cy * cp * cr + sy * sp * sr;

   Exit(_result);
end;

class function TQuaternion.Divide(const value1: TQuaternion; const value2: TQuaternion): TQuaternion;
begin

   Exit(value1 / value2);
end;

class function TQuaternion.Divide(const left: TQuaternion; const divisor: Single): TQuaternion;
begin

   Exit(TQuaternion.Create(left.X / divisor, left.Y / divisor, left.Z / divisor, left.W / divisor));
end;

class function TQuaternion.Dot(const quaternion1: TQuaternion; const quaternion2: TQuaternion): Single;
begin

   Exit((quaternion1.X * quaternion2.X) + (quaternion1.Y * quaternion2.Y) + (quaternion1.Z * quaternion2.Z) + (quaternion1.W * quaternion2.W));
end;

class function TQuaternion.Inverse(const value: TQuaternion): TQuaternion;
begin

   Exit(Divide(Conjugate(value), value.LengthSquared()));
end;

class function TQuaternion.Lerp(const quaternion1: TQuaternion; const quaternion2: TQuaternion; const amount: Single): TQuaternion;
begin
   var t: Single := amount;
   var t1: Single := Single(1.0) - t;

   var r: TQuaternion := Default(TQuaternion);

   var dot: Single := quaternion1.X * quaternion2.X + quaternion1.Y * quaternion2.Y + quaternion1.Z * quaternion2.Z + quaternion1.W * quaternion2.W;

   if (dot >= Single(0.0)) then
   begin
      r.X := t1 * quaternion1.X + t * quaternion2.X;
      r.Y := t1 * quaternion1.Y + t * quaternion2.Y;
      r.Z := t1 * quaternion1.Z + t * quaternion2.Z;
      r.W := t1 * quaternion1.W + t * quaternion2.W;
   end
   else
   begin
      r.X := t1 * quaternion1.X - t * quaternion2.X;
      r.Y := t1 * quaternion1.Y - t * quaternion2.Y;
      r.Z := t1 * quaternion1.Z - t * quaternion2.Z;
      r.W := t1 * quaternion1.W - t * quaternion2.W;
   end;

   // Normalize it.
   var ls: Single := r.X * r.X + r.Y * r.Y + r.Z * r.Z + r.W * r.W;
   var invNorm: Single := Single(1.0) / System.Sqrt(ls);


   r.X :=
   r.X * invNorm;
   r.Y := r.Y * invNorm;
   r.Z := r.Z * invNorm;
   r.W := r.W * invNorm;

   Exit(r);
end;

class function TQuaternion.Multiply(const value1: TQuaternion; const value2: TQuaternion): TQuaternion;
begin

   Exit(value1 * value2);
end;

class function TQuaternion.Multiply(const value1: TQuaternion; const value2: Single): TQuaternion;
begin

   Exit(value1 * value2);
end;

class function TQuaternion.Negate(const value: TQuaternion): TQuaternion;
begin

   Exit(-value);
end;

class function TQuaternion.Normalize(const value: TQuaternion): TQuaternion;
begin

   Exit(Divide(value, value.Length()));
end;

class function TQuaternion.Slerp(const quaternion1: TQuaternion; const quaternion2: TQuaternion; const amount: Single): TQuaternion;
begin
   var t: Single := amount;

   var cosOmega: Single := quaternion1.X * quaternion2.X + quaternion1.Y * quaternion2.Y + quaternion1.Z * quaternion2.Z + quaternion1.W * quaternion2.W;

   var flip: Boolean := false;

   if (cosOmega < Single(0.0)) then
   begin
      flip := true;
      cosOmega := -cosOmega;
   end;

   var s1: Single;

   var s2: Single;

   if (cosOmega > (Single(1.0) - SlerpEpsilon)) then
   begin
      // Too close, do straight linear interpolation.
      s1 := Single(1.0) - t;

      if ((flip)) then
         s2 := -t
      else
         s2 := t;

   end
   else
   begin
      var omega: Single := Math.ArcCos(cosOmega);
      var invSinOmega: Single := 1 / System.Sin(omega);

      s1 := System.Sin((Single(1.0) - t) * omega) * invSinOmega;

      if ((flip)) then
         s2 := -System.Sin(t * omega) * invSinOmega
      else
         s2 := System.Sin(t * omega) * invSinOmega;

   end;

   var ans: TQuaternion;


   ans.X := s1 * quaternion1.X + s2 * quaternion2.X;
   ans.Y := s1 * quaternion1.Y + s2 * quaternion2.Y;
   ans.Z := s1 * quaternion1.Z + s2 * quaternion2.Z;
   ans.W := s1 * quaternion1.W + s2 * quaternion2.W;

   Exit(ans);
end;

class function TQuaternion.Subtract(const value1: TQuaternion; const value2: TQuaternion): TQuaternion;
begin

   Exit(value1 - value2);
end;

function TQuaternion.Equals(const other: TQuaternion): Boolean;
begin
   // This function needs to account for floating-point equality around NaN
   // and so must behave equivalently to the underlying float/double.Equals

//   if (Vector128.IsHardwareAccelerated) then
//   begin
//
//      Exit(Self.AsVector128().Equals(other.AsVector128()));
//   end;

   Exit((self.X = other.X) and (self.Y = other.Y) and (self.Z = other.Z) and (self.W = other.W));
end;

function TQuaternion.Length(): Single;
begin
   var lengthSquared: Single := LengthSquared();

   Exit(System.Sqrt(lengthSquared));
end;

function TQuaternion.LengthSquared(): Single;
begin

   Exit(Dot(Self, Self));
end;

function TQuaternion.ToString(): string;
begin
   Result := '{X:' + X.ToString() + ' Y:' + Y.ToString() + ' Z:' + Z.ToString() + ' W:' + W.ToString() + '}'
end;
function TQuaternion.GetItem(const index: Integer): Single;
begin
   Result := Self.GetElement(index);
end;

procedure TQuaternion.SetItem(const index: Integer; const Value: Single);
begin
   Self := Self.WithElement(index, value);end;

class operator TQuaternion.Add(const value1: TQuaternion; const value2: TQuaternion): TQuaternion;
begin
begin

   Exit(TQuaternion.Create(value1.X + value2.X, value1.Y + value2.Y, value1.Z + value2.Z, value1.W + value2.W));
end;
end;

class operator TQuaternion.Divide(const value1: TQuaternion; const value2: TQuaternion): TQuaternion;
begin
begin
   var ans: TQuaternion;

   var q1x: Single := value1.X;
   var q1y: Single := value1.Y;
   var q1z: Single := value1.Z;
   var q1w: Single := value1.W;

   //-------------------------------------
   // Inverse part.
   var ls: Single := value2.X * value2.X + value2.Y * value2.Y + value2.Z * value2.Z + value2.W * value2.W;
   var invNorm: Single := Single(1.0) / ls;

   var q2x: Single := -value2.X * invNorm;
   var q2y: Single := -value2.Y * invNorm;
   var q2z: Single := -value2.Z * invNorm;
   var q2w: Single := value2.W * invNorm;

   //-------------------------------------
   // Multiply part.

   // cross(av, bv)
   var cx: Single := q1y * q2z - q1z * q2y;
   var cy: Single := q1z * q2x - q1x * q2z;
   var cz: Single := q1x * q2y - q1y * q2x;

   var dot: Single := q1x * q2x + q1y * q2y + q1z * q2z;


   ans.X := q1x * q2w + q2x * q1w + cx;
   ans.Y := q1y * q2w + q2y * q1w + cy;
   ans.Z := q1z * q2w + q2z * q1w + cz;
   ans.W := q1w * q2w - dot;

   Exit(ans);
end;
end;

class operator TQuaternion.Equal(const value1: TQuaternion; const value2: TQuaternion): Boolean;
begin
begin

   Exit(((value1.X = value2.X)) and ((value1.Y = value2.Y)) and ((value1.Z = value2.Z)) and ((value1.W = value2.W)));
end;
end;

class operator TQuaternion.NotEqual(const value1: TQuaternion; const value2: TQuaternion): Boolean;
begin
begin

   Exit(not (value1 = value2));
end;
end;

class operator TQuaternion.Multiply(const value1: TQuaternion; const value2: TQuaternion): TQuaternion;
begin
begin
//   if (Vector128.IsHardwareAccelerated) then
//   begin
//      var left := value1.AsVector128();
//      var right := value2.AsVector128();
//
//      var _result := right * left.GetElementUnsafe(3);
//      _result := _result + (Vector128.Shuffle(right, Vector128.Create(3, 2, 1, 0)) * left.GetElementUnsafe(0)) * Vector128.Create(Single(+1.0), Single(-1.0), Single(+1.0), Single(-1.0));
//      _result := _result + (Vector128.Shuffle(right, Vector128.Create(2, 3, 0, 1)) * left.GetElementUnsafe(1)) * Vector128.Create(Single(+1.0), Single(+1.0), Single(-1.0), Single(-1.0));
//      _result := _result + (Vector128.Shuffle(right, Vector128.Create(1, 0, 3, 2)) * left.GetElementUnsafe(2)) * Vector128.Create(Single(-1.0), Single(+1.0), Single(+1.0), Single(-1.0));
//
//      Exit(Unsafe.BitCast<TVector128<Single>, TQuaternion>(result));
//   end
//   else
   begin
      var ans: TQuaternion;

      var q1x: Single := value1.X;
      var q1y: Single := value1.Y;
      var q1z: Single := value1.Z;
      var q1w: Single := value1.W;

      var q2x: Single := value2.X;
      var q2y: Single := value2.Y;
      var q2z: Single := value2.Z;
      var q2w: Single := value2.W;

      // cross(av, bv)
      var cx: Single := q1y * q2z - q1z * q2y;
      var cy: Single := q1z * q2x - q1x * q2z;
      var cz: Single := q1x * q2y - q1y * q2x;

      var dot: Single := q1x * q2x + q1y * q2y + q1z * q2z;


      ans.X := q1x * q2w + q2x * q1w + cx;
      ans.Y := q1y * q2w + q2y * q1w + cy;
      ans.Z := q1z * q2w + q2z * q1w + cz;
      ans.W := q1w * q2w - dot;

      Exit(ans);
   end;
end;
end;

class operator TQuaternion.Multiply(const value1: TQuaternion; const value2: Single): TQuaternion;
begin
begin

   Exit(TQuaternion.Create(value1.X * value2, value1.Y * value2, value1.Z * value2, value1.W * value2));
end;
end;

class operator TQuaternion.Subtract(const value1: TQuaternion; const value2: TQuaternion): TQuaternion;
begin
begin

   Exit(TQuaternion.Create(value1.X - value2.X, value1.Y - value2.Y, value1.Z - value2.Z, value1.W - value2.W));
end;
end;

class operator TQuaternion.Negative(const value: TQuaternion): TQuaternion;
begin
begin

   Exit(Zero - value);
end;
end;

{$ENDREGION 'TQuaternion'}

end.
