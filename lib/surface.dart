/// ## 🌟 Surface Library
/// A shapeable, layered, intrinsincally animated container Widget
/// offering convenient access to blurring ImageFilters, Material InkResponse,
/// and HapticFeedback.
///
/// ### + 🏓 Bouncy Ball
/// A delightfully bouncy and position-mirroring reaction
/// to user input on a piece of [Material].
///
/// Turn ink splashes for an [InkWell], [InkResponse] or material [Theme]
/// into 🏓 [BouncyBall]s or 🔮 `Glass` [BouncyBall]s
/// with the built-in [InteractiveInkFeatureFactory]s,
/// or design your own with 🪀 [BouncyBall.mold].
/// ---
///
/// 📚 [SurfaceLayer] container layering offers robust customization.
/// - Support for both [Color]s and [Gradient]s in both
///   📚 [SurfaceLayer] `BASE` and `MATERIAL` layers.
/// ---
///
/// Use 🔘 [Surface.radius] and 📐 [SurfaceCorners] parameter
/// [Surface.corners] to configure the shape.
/// - The 🔘 [baseRadius] may be specified separately,
///   but is optional and will only impact the 📚 [SurfaceLayer.BASE].
/// ---
///
/// A 🔲 [Peek] may be provided to alter the Surface "peek"
/// (`MATERIAL` inset or "border") with parameter 🔲 [Peek.peek].
/// - Give special treatment, generally a thicker appearance, to selected
///   side(s) by passing 🔲 [Peek.peekAlignment]
///   and tuning with 🔲 [Peek.peekRatio].
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
/// 🔰 [SurfaceShape.biBeveledRectangle] is responsible for the
/// 📐 [SurfaceCorners.BEVEL] custom shape.
/// ---
///
///
/// ### References
/// - 🌟 [Surface] - A shapeable, layered, animated container Widget
/// - 🔰 [Shape]
///   - 📐 [Corner] & 📐 [CornerSpec]
/// - 🔲 [Peek] - An Object with optional parameters to customize a Surface's "peek"
/// - 👆 [TapSpec] - An Object with optional parameters to customize a Surface's tap behavior
/// - 🔬 [Filter] - An Object with optional parameters to customize a 🌟 `Surface`'s 🤹‍♂️ filters/effects
///   - 🤹‍♂️ [SurfaceFX] - `Function typedef` for custom [FilterSpec.effect]s!
///
/// ### 🏓 [BouncyBall]
/// A delightfully bouncy and position-mirroring reaction to user input on a piece of [Material].
///
/// Turn ink splashes for an [InkWell], [InkResponse] or material [Theme]
/// into 🏓 [BouncyBall]s or 🔮 `Glass` [BouncyBall]s
/// with the built-in [InteractiveInkFeatureFactory]s,
/// or design your own with 🪀 [BouncyBall.mold].
///
/// #### 🎊 Just a few extra goodies for fun.
/// - 🔦 [WithShading] `Color` extension
///   - ⬛ [withBlack] `.withBlack(int subtract)`
///   - ⬜ [withWhite] `.withWhite(int add)`
/// - 🤚 [DragNub] A small, round "handle" indicator used to visualize impression of draggable material
library surface;

export 'package:ball/ball.dart';
export 'src/surface.dart';
export 'src/shape.dart';
export 'src/effect.dart';
export 'src/goodies.dart';
