/// ## 🌟 Surface
/// A shapeable, layered, intrinsincally animated container Widget
/// offering convenient access to blurring ImageFilters, Material InkResponse,
/// and HapticFeedback.
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
/// A 🔲 [SurfacePeekSpec] may be provided to alter the Surface "peek"
/// (`MATERIAL` inset or "border") with parameter 🔲 [SurfacePeekSpec.peek].
/// - Give special treatment, generally a thicker appearance, to selected
///   side(s) by passing 🔲 [SurfacePeekSpec.peekAlignment]
///   and tuning with 🔲 [SurfacePeekSpec.peekRatio].
/// ---
///
/// Specify a 🔬 [SurfaceFilterSpec] with options
/// to render 💧 [Blur.ry] backdrop [ImageFilter]s
/// - In configured 👓 [SurfaceFilterSpec.filteredLayers] `Set`
/// - Whose radii (blur strength) are mapped with 💧 [SurfaceFilterSpec.radiusMap]
///   - A 📚 [SurfaceLayer.BASE] filter may be extended through the
///   [Surface.margin] with [SurfaceFilterSpec.extendBaseFilter]
/// ---
///
/// A 👆 [SurfaceTapSpec] offers [SurfaceTapSpec.onTap] `VoidCallback`,
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
/// - 🔲 [SurfacePeekSpec] - An Object with optional parameters to customize a Surface's "peek"
/// - 👆 [SurfaceTapSpec] - An Object with optional parameters to customize a Surface's tap behavior
/// - 🔬 [SurfaceFilterSpec] - An Object with optional parameters to customize a Surface's blurring filters
/// #### 🎊 Just a few extra goodies for fun.
/// - 🏓 [CustomInk] - A delightfully bouncy and position-mirroring reaction to user input on a piece of [Material].
/// - 🔦 [WithShading] `Color` extension
///   - ⬛ [withBlack] `.withBlack(int subtract)`
///   - ⬜ [withWhite] `.withWhite(int add)`
/// - 🤚 [DragNub] A small, round "handle" indicator used to visualize impression of draggable material
library surface;

export 'src/surface.dart';
export 'src/custom_ink.dart';
export 'src/goodies.dart';
