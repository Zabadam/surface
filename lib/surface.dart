/// ## 🌟 Surface
/// is a shapeable, layered, intrinsincally animated container Widget
/// offering convenient access to blurring ImageFilters, Material InkResponse,
/// and HapticFeedback.
///
/// Options exist to render BackdropFilter in preconfigured
/// 👓 `SurfaceFilter` arrangements; an InkResponse and
/// HapticFeedback shortcut via 👆 [TapSpec]; and support for both
/// `Color`s and `Gradient`s in both `SurfaceLayer.BASE` and `SurfaceLayer.MATERIAL` layers.
///
/// A 🔲 `PeekSpec` may be provided to alter the Surface "border".
/// 📐 `SurfaceCorners` parameter `corner` and `double radius` will
/// configure the shape.
///
/// Give special treatment, generally a thicker appearance, to selected
/// side(s) by passing 🔲 `PeekSpec.peekAlignment` and tuning with 🔲 `PeekSpec.peekRatio`.
///
/// 🔰 `BiBeveledShape` is responsible for the
/// 📐 `SurfaceCorners.BEVEL` custom shape.
///
/// ### `surface.dart` adds a few items to namespace currently... sorry!
/// - 👆 `CustomInk.splashFactory` - New InteractiveInkFeatureFactory from
///   modified [Material.InkRipple]
/// - 👨‍💻 `fullPrint(String text)` to receive really long Strings in console log
/// - Color extensions ⬛ `.withBlack(int subtract)` and ⬜ `.withWhite(int add)`
/// - 🤚 `DragNub({double width, double height, Color color, double borderWidth})`
/// - 📏 `Transform ScaleAxis(Widget child, {Key key, double dx =1.0, double dy =1.0, Offset origin, AlignmentGeometry alignment})`
library surface;

export 'src/surface.dart';
export 'src/custom_ink.dart';
export 'src/goodies.dart';
