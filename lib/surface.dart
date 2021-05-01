/// ## 🌟 Surface Library
/// A shapeable, layered, intrinsincally animated container Widget
/// offering convenient access to blurring `ImageFilter`s,
/// `Material` `InkResponse`, and `HapticFeedback`.
///
/// ### + [🏓 `BouncyBall`](https://pub.dev/packages/ball 'pub.dev: ball')
/// A delightfully bouncy and position-mirroring reaction
/// to user input on a piece of [Material].
/// ---
///
/// ### References
/// - 🌟 [Surface] - A shapeable, layered, animated container widget
/// - 🔰 [SurfaceShape] from [Shape]
///   - Defined by 📐 [CornerSpec]
/// - 🔲 [Peek] - Parameter object to customize 📚 `BASE` "peek"
/// - 👆 [TapSpec] - Parameter object to customize tap appearance & behavior
/// - 🔬 [Filter] - Parameter object to customize 🤹‍♂️ filters/effects!
///   - 🤹‍♂️ [SurfaceFX] `Function typedef`
/// ---
///
/// 📚 [SurfaceLayer] container layering offers robust customization.
/// - Support for both `Color`s and `Gradient`s in both
///   📚 [SurfaceLayer] `BASE` and `MATERIAL` layers.
/// - Support for three different [Filter.effect]s and their strengths.
/// ---
///
/// 🔰 [Shape] customized `SurfaceShape`s
/// - 📐 [CornerSpec] `Shape` description
///   - Use [corners] to customize all four corners
///   in a [Shape] and their 🔘 [radius].
///   - Specify [baseCorners] separately if desired.
///   - **`const` `CornerSpec`s with pre-set configurations available:**
///     - [CornerSpec.CIRCLE], [CornerSpec.SQUARED], [CornerSpec.ROUNDED], [CornerSpec.BEVELED]
///
/// - ➖ `BorderSide` [border]s
///   - Add a [BorderSide] decoration to the edges of this [Shape].
///   - Specify [baseBorder] separately if desired.
///
/// - 🔘 `Corner` `BorderRadius` [radius]
///   - Defers to any [Shape.corners] or [Shape.baseCorners]
///   supplied 🔘 [CornerSpec.radius], if available.
///
/// - 🔛 `SurfaceLayer` [padLayer]
///   - Specify a 📚 [SurfaceLayer] to receive [Surface.padding] value.
///   - Default is 📚 `SurfaceLayer.CHILD`
///
/// - 📏 `Shape` scaling
///   - See `double`s [shapeScaleChild], [shapeScaleMaterial], [shapeScaleBase]
/// ---
///
/// A 🔲 [Peek] may be provided to alter the Surface "peek"
/// (`MATERIAL` inset or "border") with parameter 🔲 [Peek.peek].
/// - Give special treatment, generally a thicker appearance, to selected
///   side(s) by passing 🔲 [Peek.alignment]
///   and tuning with 🔲 [Peek.ratio].
/// - Note:  for true [BorderSide]s, see 🔰 [Shape.border].
/// ---
///
/// Specify a 🔬 [Filter] with options
/// to render 🤹‍♂️ [SurfaceFX] backdrop [ImageFilter]s
/// - In configured 👓 [Filter.filteredLayers] `Set`
/// - Whose radii (🤹‍♂️ [effect] strength) are mapped with 📊 [Filter.radiusMap]
///   - A 📚 [SurfaceLayer.BASE] filter may be extended through the
///   [Surface.margin] with [Filter.extendBaseFilter]
/// ---
///
/// A 👆 [TapSpec] offers [TapSpec.onTap] `VoidCallback`,
/// [InkResponse] customization, and a [HapticFeedback] shortcut.
/// ---
///
/// ### References, continued
/// #### 🏓 [BouncyBall]
/// A delightfully bouncy and position-mirroring reaction to user input on a piece of [Material].
///
/// Turn ink splashes for an [InkWell], [InkResponse] or material [Theme]
/// into 🏓 [BouncyBall]s or 🔮 `Glass` [BouncyBall]s
/// with the built-in [InteractiveInkFeatureFactory]s,
/// or design your own with 🪀 [BouncyBall.mold].
///
/// #### 🎊 Extra Goodies
/// - 🔦 [Shading] `Color` extension
///   - ⬛ [withBlack] `.withBlack(int subtract)`
///   - ⬜ [withWhite] `.withWhite(int add)`
/// - 🤚 [DragNub] A small, round "handle" indicator used to visualize impression of draggable material
///
/// ---
///
/// ### ❗ ***Consideration***
/// With default 🤹‍♂️ [SurfaceFX] 💧 [Fx.blurry], only provide
/// 👓 [Filter.filteredLayers] value for which you intend on
/// passing each relevant 💧 [Filter.radiusMap] map parameter.
///   - Not only are the blurry [BackdropFilter]s expensive, but the
///   inheritance/ancestry behavior is strange.
///   - If all three filters are active via 👓 [Filter.filteredLayers], passing
///   📊 `baseRadius: 0` eliminates the remaining children filters,
///   regardless of their passed 📊 `radius`.
///     - This behavior can be worked-around by setting any parent 📚 `Layer`'s
///     `radius` to just above `0`, specifically `radius > (_MINIMUM_BLUR == 0.0003)`
///     - `📚 BASE > 📚 MATERIAL > 📚 CHILD`
///     - But in this case a different 👓 [FilterSpec.filteredLayers] `Set`
///     should be passed anyway that only activates the correct 📚 `Layer`(s).
library surface;

// For links here in doc.
import 'src/surface.dart';
import 'src/shape.dart';
import 'src/effect.dart';
import 'src/goodies.dart';

export 'package:ball/ball.dart';

export 'src/surface.dart';
export 'src/shape.dart';
export 'src/effect.dart';
export 'src/goodies.dart';
