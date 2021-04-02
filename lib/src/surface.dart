/// ## 🌟 [Surface]
/// is a shapeable, layered, intrinsincally animated container Widget
/// offering convenient access to blurring ImageFilters, Material InkResponse,
/// and HapticFeedback; plus a number of customization parameters.
///
/// Options exist to render [Blur.ry] backdrop [ImageFilter]s in
/// preconfigured 👓 [SurfaceFilter] arrangements; an [InkResponse] and
/// [HapticFeedback] shortcut via 👆 [TapSpec]; and support for both
/// [Color]s and [Gradient]s in both [SurfaceLayer.BASE] and [SurfaceLayer.MATERIAL] layers.
///
/// A 🔲 [PeekSpec] may be provided to alter the Surface "border".
/// 📐 [SurfaceCorners] and [Surface.radius] will configure the shape.
///
/// Give special treatment, generally a thicker appearance, to selected
/// side(s) by passing 🔲 [PeekSpec.peekAlignment] and tuning with 🔲 [PeekSpec.peekRatio].
///
/// 🔰 [BiBeveledShape] is responsible for the 📐 [SurfaceCorners.BEVEL] custom shape.
library surface;

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// ---
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

/// ---
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
  /// This is default, and the default radius is [Surface._RADIUS] `== 6.0`.
  ROUND,

  /// ### 📐 Beveled Surface Corners
  /// Only *two* diagonally-oppposite corners will be beveled
  /// by [Surface.radius], while the other two remain square.
  ///
  /// Mirror the shape with `bool` parameter 🔁 [Surface.flipBevels].
  BEVEL
}

/// ---
/// ###  👓 [SurfaceFilter]
/// Defines complex [BackdropFilter] layout  options for entire 🌟 [Surface].
///
/// A blur filter under [SurfaceLayer.CHILD] and under [SurfaceLayer.MATERIAL] will
/// be different rectangles (and thus will not be duplicates of each other) only
/// if 🔛 [Surface.paddingStyle] `!=` 🔛 [SurfacePadding.PAD_CHILD]
/// and [Surface.padding] is passed a non-negligible value.
///
/// It is only then that the [SurfaceLayer.CHILD]
/// is offset from the [SurfaceLayer.MATERIAL] itself.
/// ```dart
/// enum value              Effect
/// -----------------------------------------------------------------
/// NONE                    0 blur filters - none placed in tree
/// TRILAYER                3 blur filters - one at each layer of build
/// INNER_BILAYER           2 blur filters - absent under SurfaceLayer.BASE
/// BASE_AND_CHILD          2 blur filters - absent under SurfaceLayer.MATERIAL
/// BASE_AND_MATERIAL       2 blur filters - absent under SurfaceLayer.CHILD
/// BASE                    1 blur filter  - only under SurfaceLayer.BASE
/// MATERIAL                1 blur filter  - only under SurfaceLayer.MATERIAL
/// CHILD                   1 blur filter  - only under SurfaceLayer.CHILD
/// ```
enum SurfaceFilter {
  /// ### 👓 No [Blur.ry] filters.
  NONE,

  /// ### 👓 3x [Blur.ry] filters, one at each layer of build:
  /// - under 📚 [SurfaceLayer.BASE]
  /// - under 📚 [SurfaceLayer.MATERIAL]
  /// - under 📚 [SurfaceLayer.CHILD]
  TRILAYER,

  /// ### 👓 2x [Blur.ry] filters:
  /// - under 📚 [SurfaceLayer.MATERIAL]
  /// - under 📚 [SurfaceLayer.CHILD]
  ///
  /// Absent under 📚 [SurfaceLayer.BASE], which will receive no blur.
  ///
  /// Furthermore, the blur under the child may appear doubled
  /// unless the child is padded from the Material with
  /// [Surface.paddingStyle] `!=` [SurfacePadding.PAD_CHILD].
  INNER_BILAYER,

  /// ### 👓 2x [Blur.ry] filters:
  /// - under 📚 [SurfaceLayer.BASE]
  /// - under 📚 [SurfaceLayer.CHILD]
  ///
  /// Absent under 📚 [SurfaceLayer.MATERIAL], which will receive no blur.
  ///
  /// Functionality matches 👓 [SurfaceFilter.BASE_AND_MATERIAL]
  /// (provided relevant [Surface.filterRadius] mapping) when
  /// [Surface.paddingStyle] `==` [SurfacePadding.PAD_CHILD] (default behavior).
  BASE_AND_CHILD,

  /// ### 👓 2x [Blur.ry] filters:
  /// - under 📚 [SurfaceLayer.BASE]
  /// - under 📚 [SurfaceLayer.MATERIAL]
  ///
  /// Absent under 📚 [SurfaceLayer.CHILD], which will receive no blur.
  ///
  /// Functionality matches 👓 [SurfaceFilter.BASE_AND_CHILD]
  /// (provided relevant [Surface.filterRadius] mapping) when
  /// [Surface.paddingStyle] `==` [SurfacePadding.PAD_CHILD] (default behavior).
  BASE_AND_MATERIAL,

  /// ### 👓 1x [Blur.ry] filter:
  /// - under 📚 [SurfaceLayer.BASE]
  /// And the entire 🌟 [Surface] as a result.
  BASE,

  /// ### 👓 1x [Blur.ry] filter:
  /// - under 📚 [SurfaceLayer.MATERIAL]
  /// After any inset from the 🔲 [PeekSpec.peek].
  MATERIAL,

  /// ### 👓 1x [Blur.ry] filter
  /// - under 📚 [SurfaceLayer.BASE]
  /// After any padding from [Surface.padding].
  CHILD,
}

/// ---
/// ### 🔛 [SurfacePadding]
/// Defines how passed [Surface.padding] is applied.
/// - `SurfacePadding.PAD_CHILD` gives entire passed padding to the child.
/// - `SurfacePadding.PAD_MATERIAL` applies entire passed padding to
///   a [Padding] that wraps [Surface.child].
/// - `SurfacePadding.SPLIT` gives half the padding to
///   the 📚 [SurfaceLayer.MATERIAL] and other half to 📚 [SurfaceLayer.CHILD].
enum SurfacePadding {
  /// ### 🔛 Pad 📚 [SurfaceLayer.CHILD]
  /// Default. Give entire [Surface.padding] value to the child.
  PAD_CHILD,

  /// ### 🔛 Pad 📚 [SurfaceLayer.MATERIAL]
  /// Apply entire [Surface.padding] value to a [Padding] that surrounds the
  /// inner [ClipPath] where [Surface.child] eventually resides.
  PAD_MATERIAL,

  /// ### 🔛 Split Padding
  /// Give half the [Surface.padding] value to the 📚 [SurfaceLayer.MATERIAL]
  /// and other half to 📚 [SurfaceLayer.CHILD].
  SPLIT,
}

/// ---
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
  }) : assert((peek ?? 0) >= 0,
            '[PeekSpec] > Please provide a non-negative [peek].');

  /// The [peek] is a `double` applied as `padding` to
  /// and insetting 📚 [SurfaceLayer.MATERIAL].
  /// - It may be considered to function like a border for the [Surface.child] content.
  ///   - Note that [Surface] does not currently support actual [Border]s.
  ///   - To give a border to a Surface, provide a Surface as a `child` to a [DecoratedBox] or [Container].
  ///
  /// Having declared a side(s) to receive special treatment by passing [peekAlignment],
  /// [peekRatio] defines the scale by which to multiply this (these) edge inset(s).
  /// - Defaults to thicker [peekRatio] `== 2.0`
  /// - A larger ratio creates a more dramatic effect
  /// - Thinner side(s) possible by passing `0 >` [peekRatio] `> 1`
  ///
  /// (More than one side is affected by a corner-set [Alignment].)
  final double peek, peekRatio;

  /// Determined by [peekAlignment], a side(s) is given special treatment and made
  /// - [peekAlignment] defaults [Alignment.center]
  ///   such that no sides receive special treatment.
  final AlignmentGeometry peekAlignment;
}

/// ---
/// ### 👆 [TapSpec]
/// A 🌟 [Surface] may be provided a 👆 [TapSpec] to define its "tappability"
/// and appearance & behavior therein, if enabled.
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

  /// Not only does [tappable] mean the Surface will provide [onTap] Callback,
  /// it also adds an [InkResponse] to the [Material] before rendering [child].
  ///
  /// [providesFeedback] is a convenience to add a [HapticFeedback.vibrate] `onTap`.
  final bool tappable, providesFeedback;

  /// If [tappable] `== true` the [InkResponse] appearance may be customized.
  ///
  /// Otherwise no InkResponse is rendered with the Surface.
  final Color inkSplashColor, inkHighlightColor;

  /// Disabled by [tappable] `== false`.
  ///
  /// Pass a `function` to peform any time the [InkResponse]
  /// on this 🌟 [Surface] responds to a tap input.
  final VoidCallback onTap;
}

/// ---
/// ### 💧 [Blur.ry] Image Filter
/// Initialized radius is passed as `ImageFilter.blur(sigmaX: radius, sigmaY: radius)`
class Blur {
  /// Passes `double radius` as both `ImageFilter.blur(sigmaX)` & `ImageFilter.blur(sigmaY)`
  /// and returns this [ImageFilter].
  static ry(double radius) {
    return ImageFilter.blur(sigmaX: radius, sigmaY: radius);
  }
}

/// ---
/// ### 🔰 [BiBeveledShape]
/// Returns a [BeveledRectangleBorder] where the passed 🔘 [radius] is applied to
/// two diagonally opposite corners while the other two remain square.
///
/// (See: [Surface._buildBiBeveledShape)
class BiBeveledShape {
  /// ### 🔰 [BiBeveledShape]
  ///
  /// Returns a [BeveledRectangleBorder] where the passed 🔘 [radius] is applied to
  /// two diagonally opposite corners while the other two remain square.
  ///
  /// #### Default is beveled topRight and bottomLeft, but [flip] passed `true` will mirror the result.
  ///
  /// **Pass `true` to [shrinkOneCorner]** to increase the radius on one of the
  /// resultant beveled corners based on `Alignment` pass to [shrinkCornerAlignment].
  ///
  /// This aids when stacking multiple 🔰 [BiBeveledShape] within one another when
  /// offset with padding while a uniform border is desired.
  ///
  /// (See: [Surface._buildBiBeveledShape)
  static BeveledRectangleBorder build({
    bool flip = false,
    double radius = 5,
    bool shrinkOneCorner = false,
    double ratio = 5 / 4,
    AlignmentGeometry shrinkCornerAlignment,
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

/// ---
/// ### 🌟 [Surface]
/// An [AnimatedContainer] Widget and [Material] with a number of parameters for
/// both appearance and behavior; some of which are just convenience shortcuts,
/// such as [providesFeedback], that modify very little code.
///
/// Robustly customizable and, *watch out*, could also be expensive.
///
/// ---
///
/// - ***WARNING*** Only pass 👓 [filterStyle] parameter for which you intend on
/// passing each relevant 💧 [filterRadius] map parameter.
///   - Not only are the blurry [BackdropFilter]s expensive, but the
///   inheritance/ancestory behavior is strange.
///   - If all three filters are active via 👓 [SurfaceFilter.MULTILAYER], passing
///   `filterRadius: {SurfaceLayer.BASE: 0, ...}` eliminates the remaining
///   children filters, regardless of their passed `double` 💧 [filterRadius] mapping.
///   - This behavior can be worked-around by setting any parent filter value
///   (`BASE > MATERIAL > CHILD`) to just above 0, specifically `> (_MINIMUM_BLUR == 0.0003)`,
///   but in this case a different 👓 [filterStyle] value should be used anyway
///   that only employs the one or two appropriate filter(s).
class Surface extends StatelessWidget {
  /// ## 🏃‍♂️ Default Duration: `milliseconds: 500`
  static const _DURATION = Duration(milliseconds: 500);

  /// ## 🔘 Default Corner Radius: `6.0`
  static const _RADIUS = 6.0;

  /// See ***WARNING*** in [Surface] doc about 👓 [filterStyle] and 💧 [filterRadius] values.
  /// ## Default 👓 [filterRadius] passed to 💧 [Blur.ry]
  /// # 4.0
  static const _BLUR = 4.0;

  /// See ***WARNING*** in [Surface] doc about 👓 [filterStyle] and 💧 [filterRadius] values.
  /// ## Minimum 👓 [filterRadius] passed to 💧 [Blur.ry]
  /// # 0.0003
  static const _BLUR_MINIMUM = 0.0003;

  /// ### 🌟 [Surface]
  /// An [AnimatedContainer] Widget and [Material] with a number of parameters for
  /// both appearance and behavior; some of which are just convenience shortcuts,
  /// such as [providesFeedback], that modify very little code.
  ///
  /// Property 🔲 [PeekSpec.peekAlignment] has hard-coded recognition of all nine [Alignment]
  /// geometries and will determine which side(s) receive a special border treatment
  /// according to property 🔲 [PeekSpec.peekRatio].
  /// - defaults at `peekRatio: 2` which makes the 🔲 [PeekSpec.peekAlignment] sides twice as thick, but
  /// - these borders made be made *thinner* than the others by passing `0 > peekRatio > 1`.
  ///
  /// Considering:
  /// 1. 📐 [SurfaceCorners] property [corners];
  /// 2. properties [tappable], [onTap], [providesFeedback] & 👆 [TapSpec.inkHighlightColor], 👆 [TapSpec.inkSplashColor];
  /// 3. 👓 [SurfaceFilter] passed as 👓 [filterStyle] and related `double`s [_blurBase],
  ///    [filterMaterialBlur] & [filterChildBlur];
  /// 4. and the [duration] & [curve] properties for intrinsic property-change animations;
  ///
  /// A 🌟 [Surface] is robustly customizable and, *watch out*, could also be expensive.
  ///
  /// - **If 🌆 [gradient] or 🌆 [baseGradient] is initialized,**
  /// then resepctive 🎨 [color] or 🎨 [baseColor] parameter is ignored.
  ///
  /// > If not initialized, then default as follows:
  /// >   - 🎨 **[color]** - `Theme.of(context).colorScheme.surface.withOpacity(0.3)`
  /// >   - 🎨 **[baseColor]** - `Theme.of(context).colorScheme.primaryVariant.withOpacity(0.3)`
  ///
  /// - **If [corners] is passed 📐 [SurfaceCorners.SQUARE]** then 🔘 [radius] is ignored.
  /// - **If [corners] is passed 📐 [SurfaceCorners.BEVEL]** then `bool` 🔁 [flipBevels]
  ///   can mirror the cut corners horizontally. Ignored otherwise.
  ///
  /// - **Passing 🔲 [PeekSpec.peekRatio] a value of `1`** will negate any
  ///   passed value to `peekAlignment`.
  /// - Similarly, **passing `peekRatio` in the range `0..1`**
  ///   will actually make the 🔲 [PeekSpec.peekAlignment] aligned side(s)
  ///   *thinner* than the others.
  ///
  /// - By default **👆 [TapSpec.tappable] is true and 👆 [TapSpec.providesFeedback] is false**.
  ///   The former includes an [InkResponse] that calls 👆 [TapSpec.onTap] and the latter
  ///   enables [HapticFeedback].
  ///
  /// ---
  ///
  /// - ***WARNING*** Only pass 👓 [filterStyle] parameter for which you intend on
  /// passing each relevant 💧 [filterRadius] map parameter.
  ///   - Not only are the blurry [BackdropFilter]s expensive, but the
  ///   inheritance/ancestory behavior is strange.
  ///   - If all three filters are active via 👓 [SurfaceFilter.MULTILAYER], passing
  ///   `filterRadius: {SurfaceLayer.BASE: 0, ...}` eliminates the remaining
  ///   children filters, regardless of their passed `double` 💧 [filterRadius] mapping.
  ///   - This behavior can be worked-around by setting any parent filter value
  ///   (`BASE > MATERIAL > CHILD`) to just above 0, specifically `> (_MINIMUM_BLUR == 0.0003)`,
  ///   but in this case a different 👓 [filterStyle] value should be used anyway
  ///   that only employs the one or two appropriate filter(s).
  ///
  /// ------
  /// ------
  ///
  /// ### Simple Examples:
  /// ```dart
  /// // Surface with a border that's thicker on bottom & right, with rounded corners
  /// Surface(
  ///   radius: 10,
  ///   peekSpec: PeekSpec(
  ///     peekAlignment: Alignment.bottomRight,
  ///     peekRatio: 20,
  ///   ),
  /// )
  ///
  /// // Surface with a gradient border that's thicker on top and left, with two beveled corners
  /// Surface(
  ///   corners: SurfaceCorners.BEVEL,
  ///   flipBevels: true,
  ///   borderGradient: LinearGradient(...),
  ///   peekSpec: PeekSpec(peekAlignment: Alignment.topLeft),
  /// )
  /// ```
  const Surface({
    this.width,
    this.height,
    this.margin = const EdgeInsets.all(0),
    this.padding = const EdgeInsets.all(0),
    this.color,
    this.baseColor,
    this.gradient,
    this.baseGradient,
    this.duration = _DURATION,
    this.curve = Curves.easeIn,
    this.disableBase = false,
    this.corners = SurfaceCorners.ROUND,
    this.radius,
    this.peekSpec = const PeekSpec(),
    this.tapSpec = const TapSpec(),
    this.filterStyle = SurfaceFilter.NONE,
    this.filterRadius = const <SurfaceLayer, double>{},
    this.paddingStyle = SurfacePadding.PAD_CHILD,
    this.flipBevels = false,
    this.child,
    Key key,
  })  : assert((radius ?? 0) >= 0,
            '[Surface] > Please provide a non-negative [radius].'),
        super(key: key);

  /// The [width] and [height] follow rules of [AnimatedContainer],
  /// but apply to either the 📚 [SurfaceLayer.BASE] or,
  /// if `disableBase: true`, the 📚 [SurfaceLayer.MATERIAL] directly.
  final double width, height;

  /// If [disableBase] `== true` the [margin] is properly handled by
  /// 📚 [SurfaceLayer.MATERIAL] but otherwise applies to 📚 [SurfaceLayer.BASE] and
  /// the Surface as a whole, ignored by 📚 [SurfaceLayer.MATERIAL].
  ///
  /// [padding] is always ignored by the 📚 [SurfaceLayer.BASE],
  /// because its `padding` is determined by [peek].
  ///
  /// See 🔛 [paddingStyle], however, for options on how to distribute the [padding]
  /// between (default) [SurfacePadding.PAD_CHILD] or perhaps [SurfacePadding.PAD_MATERIAL].
  final EdgeInsets margin, padding;

  /// If 🌆 [gradient] or 🌆 [baseGradient] is initialized,
  /// then resepctive `Color` parameter is ignored.
  ///
  /// If not initialized, then default as follows:
  /// - [color] - `Theme.of(context).colorScheme.surface.withOpacity(0.3)`
  /// - [baseColor] - `Theme.of(context).colorScheme.primaryVariant.withOpacity(0.3)`
  final Color color, baseColor;

  /// If [color] or [baseColor] is initialized, then initializing the
  /// respective `Gradient` parameter overrides the `Color` pass.
  final Gradient gradient, baseGradient;

  /// The Duration that the internal [AnimatedContainer]s use for
  /// intrinsic property-change animations.
  final Duration duration;

  /// The Curve that the internal [AnimatedContainer]s use for
  /// intrinsic property-change animations.
  final Curve curve;

  /// The 📚 [SurfaceLayer.BASE] will not be rendered if `true`.
  ///
  /// [margin] is passed to 📚 [SurfaceLayer.MATERIAL] in this case, and all parameters
  /// modifying `base` appearance are ignored.
  final bool disableBase;

  /// See 📐 [SurfaceCorners] for a small list of availabe shapes.
  /// Default is 📐 [SurfaceCorners.ROUND], but 📐 [SurfaceCorners.BEVEL] is fun.
  final SurfaceCorners corners;

  /// The 🔘 [radius] impacts the roundedness of default
  /// 📐 [SurfaceCorners.ROUND] or set-in of 📐 [SurfaceCorners.BEVEL].
  ///
  /// If not provided, [Surface._RADIUS] `== 6.0`
  final double radius;

  /// Surface 🔲 [PeekSpec.peek] is applied as `padding` to and insets 📚 [SurfaceLayer.MATERIAL].
  /// - It may be considered to function like a border for the [child] content.
  ///   - Note that 🌟 [Surface] does not currently support actual [Border]s.
  ///   - To give a border to a Surface, provide a Surface as a `child` to a [DecoratedBox] or [Container].
  ///
  /// According to 🔲 [PeekSpec.peekAlignment], a side(s)
  /// is given special treatment and made:
  /// - thicker (default `peekRatio == 2.0`) or
  /// - thinner (`0 > peekRatio > 1`)
  ///
  /// Defaults [Alignment.center] such that no sides receive special treatment.
  final PeekSpec peekSpec;

  /// Not only does 👆 [TapSpec.tappable] provide [Surface.onTap] Callback,
  /// it also adds an [InkResponse] to the [Material] before rendering [child].
  ///
  /// 👆 [TapSpec.providesFeedback] is a convenience parameter
  /// to add a [HapticFeedback.vibrate] `onTap`.
  final TapSpec tapSpec;

  /// See 👓 [SurfaceFilter] for a breakdown on the layering of up to three blur filters.
  /// Radii of blur filters handled independently by [_blurBase],
  /// [_blurMaterial], and [_blurChild], supplied in asending z-axis order.
  final SurfaceFilter filterStyle;

  /// `filterBlur` parameters default to [_BLUR_MINIMUM] `== 0.0000001` so that
  /// upper-layered filters are not erased by an ancestor filter having 0 radius.
  ///
  /// - If 👓 [filterStyle] is set to enable all three filters, by 👓 [SurfaceFilter.TRILAYER],
  ///   set all three `filterBlur` params `>= 0.01`.
  /// - Similarly, if only two filters are enabled by, say 👓 [SurfaceFilter.BASE_AND_CHILD],
  ///   the lower filter ([_blurBase] in this case) must be above zero to
  ///   not negate any value passed to the higher filter ([_blurChild] in this case).
  final Map<SurfaceLayer, double> filterRadius;

  /// Select 🔛 [paddingStyle] as [Surface.padding] value may be
  /// (default) passed entirely to the [child], but
  /// optionally may be given to a [_clipper] within 📚 [SurfaceLayer.MATERIAL]
  /// before rendering [child], or split evenly between the two.
  ///
  /// The effect with [SurfacePadding.PAD_MATERIAL] can be neat as it adds
  /// a third customizable layer to a Surface when employed with
  /// 👓 [filterStyle] `!=` 👓 [SurfaceFilter.BASE_AND_MATERIAL].
  final SurfacePadding paddingStyle;

  /// Only if [corners] `==` 📐 [SurfaceCorners.BEVEL] will 🔁 [flipBevels] then
  /// mirror the two beveled corners horizontally across x-axis; ignored otherwise.
  ///
  /// See 🔰 [BiBeveledShape] which ultimately provides the
  /// [BeveledRectangleBorder] used throughout Surface.
  final bool flipBevels;

  /// The 👶 [child] Widget to render inside as the Surface content
  /// after considering all layout parameters.
  final Widget child;

  /// 💧 [filterRadius] Map value `getter`
  double get _blurBase =>
      (filterRadius != null) ? filterRadius[SurfaceLayer.BASE] ?? _BLUR : _BLUR;

  /// 💧 [filterRadius] Map value `getter`
  double get _blurMaterial => (filterRadius != null)
      ? filterRadius[SurfaceLayer.MATERIAL] ?? _BLUR
      : _BLUR;

  /// 💧 [filterRadius] Map value `getter`
  double get _blurChild => (filterRadius != null)
      ? filterRadius[SurfaceLayer.CHILD] ?? _BLUR
      : _BLUR;

  /// ---
  /// ## 👷‍♂️🌟 Build [Surface]
  @override
  Widget build(BuildContext context) {
    /// See ***WARNING*** in [Surface] doc about
    /// 👓 [filterStyle] and [filterRadius] values.
    assert(
        ((filterStyle == SurfaceFilter.TRILAYER)
                ? (_blurBase >= _BLUR_MINIMUM && _blurMaterial >= _BLUR_MINIMUM)
                : true) ||
            ((filterStyle == SurfaceFilter.INNER_BILAYER)
                ? (_blurMaterial >= _BLUR_MINIMUM)
                : true) ||
            ((filterStyle == SurfaceFilter.BASE_AND_CHILD)
                ? (_blurBase >= _BLUR_MINIMUM)
                : true) ||
            ((filterStyle == SurfaceFilter.BASE_AND_MATERIAL)
                ? (_blurBase >= _BLUR_MINIMUM)
                : true),
        '[Surface] > Upper-layered filters will be negated if ancestor filters are enabled that have radius < 0.0003.\n'
        'Increase blur radius of lower layer(s) or pass a different [filterStyle].');

    /// 🔢 Establish the thickness of each base side "peek" or "border-side"
    /// (`padding` property for 📚 [SurfaceLayer.BASE])
    /// based on [peek] and considering [peekAlignment] & [peekRatio]
    final double left = (peekSpec.peekAlignment == Alignment.topLeft ||
            peekSpec.peekAlignment == Alignment.centerLeft ||
            peekSpec.peekAlignment == Alignment.bottomLeft)
        ? peekSpec.peek * peekSpec.peekRatio
        : peekSpec.peek;
    final double top = (peekSpec.peekAlignment == Alignment.topLeft ||
            peekSpec.peekAlignment == Alignment.topCenter ||
            peekSpec.peekAlignment == Alignment.topRight)
        ? peekSpec.peek * peekSpec.peekRatio
        : peekSpec.peek;
    final double right = (peekSpec.peekAlignment == Alignment.topRight ||
            peekSpec.peekAlignment == Alignment.centerRight ||
            peekSpec.peekAlignment == Alignment.bottomRight)
        ? peekSpec.peek * peekSpec.peekRatio
        : peekSpec.peek;
    final double bottom = (peekSpec.peekAlignment == Alignment.bottomLeft ||
            peekSpec.peekAlignment == Alignment.bottomCenter ||
            peekSpec.peekAlignment == Alignment.bottomRight)
        ? peekSpec.peek * peekSpec.peekRatio
        : peekSpec.peek;

    final _fallbackColor =
        Theme.of(context).colorScheme.surface.withOpacity(0.3);

    final _fallbackColorBase =
        Theme.of(context).colorScheme.primaryVariant.withOpacity(0.2);

    /// ---
    /// ### 🌟🧅 `innerMaterial` = 📚 [SurfaceLayer.MATERIAL]
    /// May contain [_buildInkResponse] but always eventually
    /// holds [Surface.child], as the InkResponse would [_buildChild] as well.
    ///
    /// Supplied [width], [height], and [margin] in the case where
    /// 📚 [SurfaceLayer.BASE] is not built, `disableBase == true`.
    Widget innerMaterial = AnimatedContainer(
      /// [width] and [height] may be `null` anyway
      width: (disableBase) ? width : null,
      height: (disableBase) ? height : null,
      margin: (disableBase) ? margin : const EdgeInsets.all(0),
      duration: duration,
      curve: curve,

      /// Build shape and color for 📚 [SurfaceLayer.MATERIAL]
      decoration: _buildDecoration(
        SurfaceLayer.MATERIAL,
        isGradient: gradient != null,
        fallbacks: {
          SurfaceLayer.BASE: _fallbackColorBase,
          SurfaceLayer.MATERIAL: _fallbackColor
        },
      ),

      /// Material will be canvas for [child] and respond to touches
      child: Material(
        color: const Color(0x00FFFFFF), // transparent
        child: (tapSpec.tappable) ? _buildInkResponse(context) : _buildChild(),
      ),
    );

    /// ---
    /// 🌟🐚 ### `baseContainer` = 📚 [SurfaceLayer.BASE]
    Widget baseContainer = AnimatedContainer(
      /// [width] and [height] may be `null` anyway
      width: width,
      height: height,
      margin: margin,
      duration: duration,
      curve: curve,

      /// 🔲 This padding is effectively the "border" of the Surface.
      // Values generated at start of build() using 🔲 [PeekSpec].
      padding: EdgeInsets.fromLTRB(left, top, right, bottom),

      /// Build shape and color for 📚 [SurfaceLayer.BASE]
      decoration: _buildDecoration(
        SurfaceLayer.BASE,
        isGradient: baseGradient != null,
        fallbacks: {
          SurfaceLayer.BASE: _fallbackColorBase,
          SurfaceLayer.MATERIAL: _fallbackColor
        },
      ),

      /// 🌟🧅 `innerMaterial` as descendent of 🌟🐚 `baseContainer`
      child: _filterOrChild(
        layer: SurfaceLayer.MATERIAL,
        child: innerMaterial,
      ),
    );

    /// ### 📤🌟 Return [Surface]
    if (disableBase)
      return _filterOrChild(layer: SurfaceLayer.MATERIAL, child: innerMaterial);
    else
      return _filterOrChild(layer: SurfaceLayer.BASE, child: baseContainer);
  }

  /// ---
  /// ## 👷‍♂️: 👆 [_buildInkResponse]
  /// If 👆 [TapSpec.tappable] is `true` then Surface parameter [child]
  /// is passed into this [InkResponse] with customizable
  /// 👆 [TapSpec.inkHighlightColor] and 👆 [TapSpec.inkSplashColor].
  InkResponse _buildInkResponse(BuildContext context) {
    return InkResponse(
      /// 👶 [child]
      child: _buildChild(),

      /// Consult 👆 [TapSpec]
      highlightColor:
          tapSpec.inkHighlightColor ?? Theme.of(context).highlightColor,
      splashColor: tapSpec.inkSplashColor ?? Theme.of(context).splashColor,
      onTap: () {
        if (tapSpec.providesFeedback) HapticFeedback.vibrate();
        tapSpec.onTap?.call();
      },

      containedInkWell: true,
      canRequestFocus: true,
      highlightShape: BoxShape.rectangle,
      customBorder: (corners == SurfaceCorners.BEVEL)
          ? _buildBiBeveledShape(isBorder: false)
          : RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  (corners == SurfaceCorners.SQUARE) ? 0 : radius ?? _RADIUS),
            ),
    );
  }

  /// ---
  /// ## 👷‍♂️: 👶 [_buildChild] with passed [child]
  /// A [ClipPath] from [_clipper] is used to ensure child renders properly
  /// at inner corners.
  /// Property 🔛 [paddingStyle] determines how [padding] is distributed.
  AnimatedPadding _buildChild() {
    /// [clipper] padding
    return AnimatedPadding(
      duration: duration,
      padding: (paddingStyle == SurfacePadding.PAD_CHILD)
          ? const EdgeInsets.all(0)
          : (paddingStyle == SurfacePadding.SPLIT)
              ? padding / 2

              /// SurfacePadding.PAD_SURFACE
              : padding,

      /// [clipper] containing [child]
      child: _clipper(
        layer: SurfaceLayer.CHILD,
        content: AnimatedContainer(
          duration: duration,
          curve: curve,
          padding: (paddingStyle == SurfacePadding.PAD_CHILD)
              ? padding
              : (paddingStyle == SurfacePadding.SPLIT)
                  ? padding / 2

                  /// SurfacePadding.PAD_SURFACE
                  : const EdgeInsets.all(0),

          /// 👶 [child]
          child: _filterOrChild(
            layer: SurfaceLayer.CHILD,
            child: child ?? Container(width: 0, height: 0),
          ),
        ),
      ),
    );
  }

  /// ---
  /// ## 👷‍♂️: 🌈 [_buildDecoration]
  /// Employs [_buildGradientDecoration] or [_buildColorDecoration] considering
  /// whether [Surface.gradient] is initialized.
  Decoration _buildDecoration(
    SurfaceLayer layer, {
    @required isGradient,
    @required fallbacks,
  }) {
    return (isGradient)
        ? _buildGradientDecoration(layer)
        : _buildColorDecoration(layer, fallbacks);
  }

  /// ---
  /// ## 👷‍♂️: 🌈🌆 Build [gradient] Decoration
  /// - Returns a [ShapeDecoration] if [corners] `==` 📐 [SurfaceCorners.BEVEL]
  /// - Returns a [BoxDecoration] for 📐 [SurfaceCorners.SQUARE] or 📐 [SurfaceCorners.ROUND]
  ///
  /// In both cases, the [Decoration] is initialized with
  /// an appropriate `Gradient` and considers passed 📚 [SurfaceLayer] for render.
  Decoration _buildGradientDecoration(SurfaceLayer layer) {
    if (corners == SurfaceCorners.BEVEL) {
      return ShapeDecoration(
        gradient: (layer == SurfaceLayer.BASE) ? baseGradient : gradient,
        shape: (layer == SurfaceLayer.BASE)
            ? _buildBiBeveledShape(isBorder: true)
            : _buildBiBeveledShape(isBorder: false),
      );
    } else {
      return BoxDecoration(
        gradient: (layer == SurfaceLayer.BASE) ? baseGradient : gradient,
        borderRadius: BorderRadius.all(
          Radius.circular(
            corners == SurfaceCorners.SQUARE ? 0 : radius ?? _RADIUS,
          ),
        ),
      );
    }
  }

  /// ---
  /// ## 👷‍♂️: 🌈🎨 Build [color] Decoration
  /// - Returns a [ShapeDecoration] if [corners] `==` 📐 [SurfaceCorners.BEVEL]
  /// - Returns a [BoxDecoration] for 📐 [SurfaceCorners.SQUARE] or 📐 [SurfaceCorners.ROUND]
  ///
  /// In both cases, the [Decoration] is initialized with
  /// an appropriate `Color` and considers passed 📚 [SurfaceLayer] for render.
  Decoration _buildColorDecoration(
    SurfaceLayer layer,
    Map<SurfaceLayer, Color> fallbacks,
  ) {
    if (corners == SurfaceCorners.BEVEL)
      return ShapeDecoration(
        color: (layer == SurfaceLayer.BASE)
            ? baseColor ?? fallbacks[SurfaceLayer.BASE]
            : color ?? fallbacks[SurfaceLayer.MATERIAL],
        shape: (layer == SurfaceLayer.BASE)
            ? _buildBiBeveledShape(isBorder: true)
            : _buildBiBeveledShape(isBorder: false),
      );
    else
      return BoxDecoration(
        color: (layer == SurfaceLayer.BASE)
            ? baseColor ?? fallbacks[SurfaceLayer.BASE]
            : color ?? fallbacks[SurfaceLayer.MATERIAL],
        borderRadius: BorderRadius.all(
          Radius.circular(
            corners == SurfaceCorners.SQUARE ? 0 : radius ?? _RADIUS,
          ),
        ),
      );
  }

  /// ---
  /// 👷‍♂️: 🔰 [_buildBiBeveledShape]
  /// Customized 🔰 [BiBeveledShape] so the 📚 [SurfaceLayer.MATERIAL]
  /// may have a deeper-cut beveled corner if
  /// the property [peekAlignment] is passed and corner-set.
  ///
  /// Certainly repass 🔁 [flipBevels].
  BeveledRectangleBorder _buildBiBeveledShape({@required bool isBorder}) {
    return BiBeveledShape.build(
      // radius: (radius ?? _DEFAULT_RADIUS) * (40 - borderThickness - 2.3 * borderThickness) / 40,
      radius: radius ?? _RADIUS,
      flip: flipBevels ?? false,

      /// A corner may indeed not be shrunken after all
      /// if [PeekSpec.peekAlignment] is not corner-set.
      ///
      /// (See: [_determineShrinkCornerAlignment] final `else` returns `Alignment.center`
      /// which 🔰 [BiBeveledShape] knows to ignore when shrinking a corner.)
      shrinkOneCorner: !isBorder,
      shrinkCornerAlignment: _determineShrinkCornerAlignment(),
    );
  }

  /// ---
  /// ## 🔧: 🔪 Shortcut [_clipper] for a [ClipPath]
  /// Since several mostly-identical ClipPaths are employed,
  /// this method will speed things up.
  ClipPath _clipper({
    @required SurfaceLayer layer,
    @required Widget content,
  }) {
    return ClipPath(
      child: content,
      clipper: ShapeBorderClipper(
        shape: (corners == SurfaceCorners.BEVEL)
            ?

            /// 📐 [SurfaceCorners.BEVEL] may need a slightly different shape for
            /// the 📚 [SurfaceLayer.MATERIAL] vs. the 📚 [SurfaceLayer.BASE].
            (layer == SurfaceLayer.BASE)
                ? _buildBiBeveledShape(isBorder: true)
                : _buildBiBeveledShape(isBorder: false)

            /// A 📐 [SurfaceCorners.ROUND] or SQUARE Surface uses the same shape
            /// regardless of 📚 [SurfaceLayer]. TODO: Altered inner radius for roundedRects
            : RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  (corners == SurfaceCorners.SQUARE) ? 0 : radius ?? _RADIUS,
                ),
              ),
      ),
    );
  }

  /// ---
  /// ## 🔧: 👓💧 | 👶 Shortcut [_filterOrChild]
  /// Returns [_clipper]-ed [ImageFilter] via [Blur.ry] *OR* [child] --
  /// appropriate for the currently rendering 📚 [SurfaceLayer], considering both
  /// the parameter 👓 [filterStyle] and the relevant `double`(s) mapped in [filterRadius].
  ///
  /// If an [ImageFilter] is not needed, this method simply returns the child.
  _filterOrChild({
    @required SurfaceLayer layer,
    @required Widget child,
  }) {
    if (filterStyle == SurfaceFilter.NONE) return child;

    switch (layer) {
      case SurfaceLayer.BASE:

        /// Consider the 👓 [filterStyle] options that would exlude rendering
        /// for this 📚 [SurfaceLayer].
        return (_blurBase > 0 &&
                filterStyle != SurfaceFilter.INNER_BILAYER &&
                filterStyle != SurfaceFilter.MATERIAL &&
                filterStyle != SurfaceFilter.CHILD)

            /// If passes, return the 👶 child clipped and nested on a filter.
            ? _clipper(
                layer: SurfaceLayer.BASE,
                content:
                    BackdropFilter(filter: Blur.ry(_blurBase), child: child),
              )

            /// Otherwise return 👶 child, as it says on the tin.
            : child;
      case SurfaceLayer.MATERIAL:
        return (_blurMaterial > 0 &&
                filterStyle != SurfaceFilter.BASE_AND_CHILD &&
                filterStyle != SurfaceFilter.BASE &&
                filterStyle != SurfaceFilter.CHILD)
            ? _clipper(
                layer: SurfaceLayer.CHILD,
                content: BackdropFilter(
                    filter: Blur.ry(_blurMaterial), child: child),
              )
            : child;
      case SurfaceLayer.CHILD:
        return (_blurChild > 0 &&
                filterStyle != SurfaceFilter.BASE_AND_MATERIAL &&
                filterStyle != SurfaceFilter.BASE &&
                filterStyle != SurfaceFilter.MATERIAL)

            /// Where this case is returned, a 🔪 [_clipper] is already present.
            ? BackdropFilter(filter: Blur.ry(_blurChild), child: child)
            : child;
    }

    assert(false, 'Filter code has been altered. Revise [_filterOrChild].');
    return child;
  }

  /// ---
  /// ## 🔰: 🧮 TODO: WIP [_determineShrinkCornerAlignment]
  /// Shrink the corner diagonally-opposite the corner from where [peekAlignment]
  /// results in thicker border.
  ///
  /// Unless 🔁 [flipBevels] `== true` then, taking this finding, shrink now the
  /// horizontally-opposite corner.
  ///
  /// Only impacts a 🌟 [Surface] that has a corner-set 🔲 [PeekSpec.peekAlignment].
  /// (i.e. `peekAlignment = Alignment.bottomCenter` will shrink no corners)
  Alignment _determineShrinkCornerAlignment() {
    return (peekSpec.peekAlignment == Alignment.topRight)
        ? (flipBevels)
            ? Alignment.bottomRight
            : Alignment.bottomLeft
        : (peekSpec.peekAlignment == Alignment.bottomRight)
            ? (flipBevels)
                ? Alignment.topRight
                : Alignment.topLeft
            : (peekSpec.peekAlignment == Alignment.bottomLeft)
                ? (flipBevels)
                    ? Alignment.topLeft
                    : Alignment.topRight
                : (peekSpec.peekAlignment == Alignment.topLeft)
                    ? (flipBevels)
                        ? Alignment.bottomLeft
                        : Alignment.bottomRight

                    /// Final else returns `Alignment.center` which 🔰 [BiBeveledShape]
                    /// knows to ignore when shrinking a corner.
                    : Alignment.center;
  }
}
