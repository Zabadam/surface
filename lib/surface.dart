/// ## 📦 [Surface] is a shapeable, layered, intrinsincally animated container Widget
/// offering convenient access to blurring ImageFilters, Material InkResponse,
/// and HapticFeedback; plus a number of customization parameters.
///
/// Options to render an [InkResponse], blurry
/// [ImageFilter]s in preconfigured [SurfaceFilter] arrangements, a
/// [HapticFeedback] shortcut, and support for [Color]s and [Gradient]s in
/// container and border.
///
/// Border is configurable by supplying [Surface.corners] and radius, as well
/// as giving special treatment, generally a thicker appearance, to selected
/// side(s) by passing [Surface.borderAlignment] and tuning with [Surface.borderRatio].
///
/// 🔰 [biBeveledShape] is responsible for the [SurfaceCorners.BEVEL] custom shape.
///
/// ### `surface.dart` adds a few items to namespace currently... sorry!
/// - 🖋👆 `CustomInk.splashFactory` - New InteractiveInkFeatureFactory from
///   modified [Material.InkRipple]
/// - 👨‍💻 `fullPrint(String text)` to receive really long Strings in console log
/// - Color extensions ⬛ `.withBlack(int subtract)` and ⬜ `.withWhite(int add)`
/// - 🤚 `DragNub({double width, double height, Color color, double borderWidth})`
/// - 📏 `Transform ScaleAxis(Widget child, {Key key, double dx =1.0, double dy =1.0, Offset origin, AlignmentGeometry alignment})`
library surface;

export 'src/surface.dart';
export 'src/custom_ink.dart';
export 'src/goodies.dart';
