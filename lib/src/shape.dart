/// ## 🌟 Surface: Shape
/// 📚 [SurfaceLayer] container layering offers robust customization.
/// - Support for both [Color]s and [Gradient]s in both
///   📚 [SurfaceLayer] `BASE` and `MATERIAL` layers.
///
/// Use 📐 [SurfaceCorners] parameter
/// [Surface.corners] to configure the shape.
///
/// ---
///
/// A 🔲 [PeekSpec] may be provided to alter the Surface "peek"
/// (`MATERIAL` inset or "border") with parameter 🔲 [PeekSpec.peek].
/// - Give special treatment, generally a thicker appearance, to selected
///   side(s) by passing 🔲 [PeekSpec.peekAlignment]
///   and tuning with 🔲 [PeekSpec.peekRatio].
///
/// ---
///
/// A 👆 [TapSpec] offers [TapSpec.onTap] `VoidCallback`,
/// [InkResponse] customization, and a [HapticFeedback] shortcut.
///
/// ---
///
/// 🔰 [SurfaceShape.biBeveledRectangle] is responsible for the
/// 📐 [SurfaceCorners.BIBEVEL] custom shape.
library surface;

import '../surface.dart';

//! ---
/// ### 📚 [SurfaceLayer]
/// Defines the three layers for rendering a 🌟 [Surface].
enum SurfaceLayer {
  /// ### 📚 Base Surface Layer
  /// Lowest layer of a 🌟 [Surface]. This bottom [AnimatedContainer] may be
  /// skipped by passing `true` to [Surface.disableBase].
  ///
  /// Color/gradient determined by 🎨 [Surface.baseColor] or 🌆 [Surface.baseGradient].
  BASE,

  /// ### 📚 Material Surface Layer
  /// The primary layer of a 🌟 [Surface]. It is here 🎨 [Surface.color] or
  /// 🌆 [Surface.gradient] is painted, the [Material] is laid,
  /// and potentially where the [InkResponse] will reside.
  MATERIAL,

  /// ### 📚 Child Surface Layer
  /// The uppermost layer of a 🌟 [Surface]; or rather, what is directly
  /// underneath where ultimately the [Surface.child] is sent.
  CHILD
}

//! ---
/// ###  📐 [SurfaceCorners]
/// Defines simple corner appearance options for entire 🌟 [Surface].
enum SurfaceCorners {
  /// ### 📐 Square Surface Corners
  /// All four corners of the rectangle are square; [Surface.radius] will be ignored.
  ///
  /// Equivalent to maintaining default 📐 [SurfaceCorners.ROUND] for [Surface.corners]
  /// initialization and passing [Surface.radius] `== 0`.
  SQUARE,

  /// ### 📐 Round Surface Corners
  /// All four corners will be rounded.
  /// This is default, and the default radius is 🔘 [Surface._RADIUS] `== 3.0`.
  ROUND,

  /// ### 📐 Beveled Surface Corners
  /// Only *two* diagonally-opposite corners will be beveled
  /// by 🔘 [Surface.radius], while the other two remain square.
  ///
  /// Mirror the shape with `bool` parameter 🔁 [Surface.flipBevels].
  BIBEVEL
}

//! ---
/// ### 🔲 [PeekSpec]
/// [Surface] may be provided a 🔲 [PeekSpec] to define several attributes about
/// the shared space at the adjacent edge of 📚 [SurfaceLayer.BASE] and 📚 [SurfaceLayer.MATERIAL].
class PeekSpec {
  /// ### 🔲 [PeekSpec]
  /// A 🌟 [Surface] may be provided a 🔲 [PeekSpec] to define several attributes about
  /// the shared space at the adjacent edge of 📚 [SurfaceLayer.BASE] and 📚 [SurfaceLayer.MATERIAL].
  /// - It may be considered to function like a border for the [Surface.child] content.
  ///   - Note that [Surface] does not currently support actual [Border]s.
  ///   - To give a border to a Surface, provide a Surface as a `child` to a [DecoratedBox] or [Container].
  const PeekSpec({
    this.peek = 3.0,
    this.peekRatio = 2.0,
    this.peekAlignment = Alignment.center,
  }) : assert(peek >= 0, '[PeekSpec] > Provide a non-negative [peek].');

  /// The 🔲 [peek] is a `double` applied as `padding` to
  /// and insetting 📚 [SurfaceLayer.MATERIAL].
  /// - It may be considered to function like a border for the [Surface.child] content.
  ///   - Note that [Surface] does not currently support actual [Border]s.
  ///   - To give a border to a Surface, provide a Surface as a `child` to a [DecoratedBox] or [Container].
  ///
  /// Having declared a side(s) to receive special treatment by passing 🔀 [peekAlignment],
  /// a 📏 [peekRatio] defines the scale by which to multiply this (these) edge inset(s).
  /// - Defaults to thicker `peekRatio == 2.0`
  /// - A larger `peekRatio` creates a more dramatic effect
  /// - Thinner side(s) possible by passing `0 > peekRatio > 1`
  ///
  /// (More than one side is affected by a corner-set `Alignment`,
  /// such as [Alignment.bottomRight].)
  final double peek, peekRatio;

  /// Determined by [peekAlignment], a side(s) is given special treatment and made
  /// - [peekAlignment] defaults [Alignment.center]
  ///   such that no sides receive special treatment.
  final AlignmentGeometry peekAlignment;

  // 🔢 Establish the thickness of each base side "peek" or "border-side"
  // (`padding` property for 📚 [SurfaceLayer.BASE])
  // based on [peek] and considering [peekAlignment] & [peekRatio]
  double get peekLeft => (peekAlignment == Alignment.topLeft ||
          peekAlignment == Alignment.centerLeft ||
          peekAlignment == Alignment.bottomLeft)
      ? peek * peekRatio
      : peek;
  double get peekTop => (peekAlignment == Alignment.topLeft ||
          peekAlignment == Alignment.topCenter ||
          peekAlignment == Alignment.topRight)
      ? peek * peekRatio
      : peek;
  double get peekRight => (peekAlignment == Alignment.topRight ||
          peekAlignment == Alignment.centerRight ||
          peekAlignment == Alignment.bottomRight)
      ? peek * peekRatio
      : peek;
  double get peekBottom => (peekAlignment == Alignment.bottomLeft ||
          peekAlignment == Alignment.bottomCenter ||
          peekAlignment == Alignment.bottomRight)
      ? peek * peekRatio
      : peek;
}

//! ---
/// ### 👆 [TapSpec]
/// A 🌟 [Surface] may be provided a 👆 [TapSpec] to define
/// its "tappability" and appearance & behavior therein, if enabled.
class TapSpec {
  /// ### 👆 [TapSpec]
  /// Not only does [tappable] provide [Surface.onTap] Callback,
  /// it also adds an [InkResponse] to the [Material] before rendering [child].
  ///
  /// [providesFeedback] is a convenience parameter
  /// to add a [HapticFeedback.vibrate] `onTap`.
  ///
  /// If [tappable] `== true` the [InkResponse] appearance may be customized.
  /// Otherwise no InkResponse is rendered with the Surface.
  const TapSpec({
    this.tappable = true,
    this.providesFeedback = false,
    this.inkSplashColor,
    this.inkHighlightColor,
    this.onTap,
  });

  /// Not only does [tappable] mean the Surface will provide 👆 [onTap] Callback,
  /// it also enables `Color` parameters [inkHighlightColor] & [inkSplashColor].
  ///
  /// [providesFeedback] is a convenience to add a [HapticFeedback.vibrate] `onTap`.
  final bool tappable, providesFeedback;

  /// If [tappable] `== true` the [InkResponse] appearance may be customized.
  final Color? inkSplashColor, inkHighlightColor;

  /// Disabled by [tappable] `== false`.
  ///
  /// Pass a [Function] to perform any time the [InkResponse]
  /// on this 🌟 [Surface] responds to a tap input.
  final VoidCallback? onTap;
}

//! ---
/// ### 🔰 [SurfaceShape]
/// Offers [biBeveledRectangle] which returns a [BeveledRectangleBorder]
/// where the passed 🔘 [radius] is applied to two diagonally opposite corners
/// while the other two remain square.
///
/// See usage: [Surface._buildBiBeveledShape]
class SurfaceShape {
  /// ### 🔰 [SurfaceShape.biBeveledRectangle]
  ///
  /// Returns a [BeveledRectangleBorder] where the passed 🔘 [radius] is applied to
  /// two diagonally opposite corners while the other two remain square.
  ///
  /// #### Default is beveled topRight and bottomLeft, but [flip] passed `true` will mirror the result.
  ///
  /// **Pass `true` to [shrinkOneCorner]** to increase the radius on one of the
  /// resultant beveled corners based on `Alignment` pass to [shrinkCornerAlignment].
  ///
  /// This aids when stacking multiple 🔰 [SurfaceShape] within one another when
  /// offset with padding while a uniform border is desired.
  ///
  /// (See: [Surface._buildBiBeveledShape)
  static BeveledRectangleBorder biBeveledRectangle({
    bool flip = false,
    double radius = 5,
    bool shrinkOneCorner = false,
    double ratio = 5 / 4,
    AlignmentGeometry? shrinkCornerAlignment,
  }) {
    double tr = (flip) ? 0.0 : radius;
    double bl = (flip) ? 0.0 : radius;
    double tl = (flip) ? radius : 0.0;
    double br = (flip) ? radius : 0.0;

    if (shrinkOneCorner) {
      if ((shrinkCornerAlignment ?? Alignment.center) != Alignment.center) {
        if (shrinkCornerAlignment == Alignment.topRight)
          tr *= ratio;
        else if (shrinkCornerAlignment == Alignment.bottomRight)
          br *= ratio;
        else if (shrinkCornerAlignment == Alignment.bottomLeft)
          bl *= ratio;
        else if (shrinkCornerAlignment == Alignment.topLeft) tl *= ratio;
      }
    }

    return BeveledRectangleBorder(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(tr),
        bottomRight: Radius.circular(br),
        bottomLeft: Radius.circular(bl),
        topLeft: Radius.circular(tl),
      ),
    );
  }
}
