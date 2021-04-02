/// ## 🌟 Surface
/// A shapeable, layered, intrinsincally animated container Widget
/// offering convenient access to blurring ImageFilters, Material InkResponse,
/// and HapticFeedback.
///
/// 📚 [SurfaceLayer] container layering offers robust customization.
/// - Support for both [Color]s and [Gradient]s
///   in both 📚 [SurfaceLayer] `BASE` and `MATERIAL` layers.
///
/// Use 🔘 [Surface.radius] and 📐 [SurfaceCorners] parameter [Surface.corners]
/// to configure the shape.
///
/// A 👆 [SurfaceTapSpec] offers [InkResponse] customization and [HapticFeedback] shortcut.
///
/// A 🔲 [SurfacePeekSpec] may be provided to alter the Surface "peek"
/// (`MATERIAL` inset or "border") with parameter 🔲 [SurfacePeekSpec.peek].
/// - Give special treatment, generally a thicker appearance, to selected
///   side(s) by passing 🔲 [SurfacePeekSpec.peekAlignment] and tuning with 🔲 [SurfacePeekSpec.peekRatio].
///
/// Specify a 🔬 [SurfaceFilterSpec] with options to render 💧 [Blur.ry]
/// backdrop [ImageFilter]s in a configured 👓 [SurfaceFilterSpec.filteredLayers] `Set`
/// and whose strength is mapped with 💧 [SurfaceFilterSpec.radiusMap].
///
/// 🔰 [BiBeveledShape] is responsible for the
/// 📐 [SurfaceCorners.BEVEL] custom shape.
///
/// ### References
/// - 🌟 [Surface] - A shapeable, layered, animated container Widget
/// - 🔲 [SurfacePeekSpec] - An Object with optional parameters to customize a Surface's "peek"
/// - 👆 [SurfaceTapSpec] - An Object with optional parameters to customize a Surface's tap behavior
/// - 🔬 [SurfaceFilterSpec] - An Object with optional parameters to customize a Surface's blurring filters
/// - 🏓 [CustomInk] - A delightfully bouncy and position-mirroring reaction to user input on a piece of [Material].
/// - 🔦 [WithShading] `Color` extension
///   - ⬛ [withBlack] `.withBlack(int subtract)`
///   - ⬜ [withWhite] `.withWhite(int add)`
/// - 🤚 [DragNub] A small, round "handle" indicator used to visualize impression of draggable material
/// - 👨‍💻 [fullPrint] - To receive really long `String`s in console log
/// - 📏 [scaleAxis] - For a [Transform.scale]-like return that accepts independent `dx` and `dy` scaling
library surface;

export 'src/surface.dart';
export 'src/custom_ink.dart';
export 'src/goodies.dart';
