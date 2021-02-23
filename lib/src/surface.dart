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
library surface;

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// ### 📇 [SurfaceLayer]
/// Defines the three layers for rendering a [Surface].
enum SurfaceLayer {
  /// Lowest layer of a [Surface]. This bottom [AnimatedContainer] may be
  /// skipped by passing `true` to [Surface.disableBorder]. Color/gradient
  /// determined by [Surface.borderColor] or [Surface.borderGradient].
  BORDER,

  /// The primary layer of a [Surface]. It is here [Surface.color] or gradient
  /// is painted, the [Material] is laid, and potentially where the
  /// [InkResponse] will reside.
  MATERIAL,

  /// The uppermost layer of a [Surface]; or rather, what is directly
  /// underneath where ultimately the [Surface.child] is sent.
  CHILD
}

/// ### 📐 [SurfaceCorners]
/// Defines very simple corner appearance options for entire [Surface].
enum SurfaceCorners {
  /// All four corners of the rectangle are square; [Surface.radius] will be ignored.
  SQUARE,

  /// All four corners will be rounded.
  /// This is default, and the default value is [Surface._DEFAULT_RADIUS].
  ROUND,

  /// Only *two* diagonally-oppposite corners will be beveled by [radius],
  /// while the other two remain square. Mirror the shape with bool parameter
  /// [flipBevels].
  BEVEL
}

/// ### 👓 [SurfaceFilter]
/// Defines complex [BackdropFilter] layout  options for entire [Surface].
///
/// A blur filter under [Surface.child] and under [Surface.innerMaterial] will
/// be a different rectangle (and thus will not be duplicates of each other) only
/// if [Surface.paddingStyle] `!=` [SurfacePadding.PAD_CHILD] and [Surface.padding]
/// is passed a non-negligible value.
///
/// It is only then that the child is offset from the [Surface.innerMaterial] itself.
/// ```dart
/// enum value              Effect
/// -----------------------------------------------------------------
/// NONE                    0 blur filters
/// TRILAYER                3 blur filters - one at each layer of build.
/// INNER_BILAYER           2 blur filters - absent under [Surface.borderContainer]
/// SURFACE_AND_CHILD       2 blur filters - absent under [Surface.innerMaterial]
/// SURFACE_AND_MATERIAL    2 blur filters - absent under [Surface.child]
/// SURFACE                 1 blur filter  - only under [Surface.borderContainer]
/// MATERIAL                1 blur filter  - only under [Surface.innerMaterial]
/// CHILD                   1 blur filter  - only under [Surface.child]
/// ```
enum SurfaceFilter {
  /// No filters.
  NONE,

  /// 3x blur filters, one at each layer of build:
  /// - under [Surface.borderContainer]
  /// - under [Surface.innerMaterial]
  /// - under [Surface.child]
  TRILAYER,

  /// 2x blur filters; absent under [Surface.borderContainer]. The [Surface]
  /// border will have no blur; and the blur under the child may appear doubled
  /// unless the child is padded from the inner Material with [Surface.paddingStyle]
  /// `==` [SurfacePadding.PAD_SURFACE]
  INNER_BILAYER,

  /// 2x blur filters; absent under [Surface.innerMaterial]. Functions like
  /// [SurfaceFilter.SURFACE_AND_MATERIAL] if the child is not padded
  /// from the inner Material.
  SURFACE_AND_CHILD,

  /// 2x blur filters; absent under [Surface.child]. Functions like
  /// [SurfaceFilter.SURFACE_AND_CHILD] if the child is not padded
  /// from the inner Material.
  SURFACE_AND_MATERIAL,

  /// 1x blur filter; under [Surface.borderContainer] and the
  /// entire [Surface] as a result.
  SURFACE,

  /// 1x blur filter; only under [Surface.innerMaterial] after any inset from
  /// the [borderContainer]'s [borderThickness].
  MATERIAL,

  /// 1x blur filter; only under [Surface.child] after any padding
  /// from [Surface.innerMaterial].
  CHILD
}

/// ### 🔲 [SurfacePadding]
/// Defines how passed [Surface.padding] is applied.
/// - `SurfacePadding.PAD_CHILD` gives entire passed padding value to the child
/// - `SurfacePadding.PAD_SURFACE` applies entire passed padding value to a [Padding] that surrounds the inner [ClipPath] where [Surface.child] eventually resides
/// - `SurfacePadding.SPLIT` gives half the padding value to the [Surface.innerMaterial] and other half to [Surface.child]
enum SurfacePadding {
  /// Give entire padding value to the child
  PAD_CHILD,

  /// Apply entire padding value to a [Padding] that surrounds the inner [ClipPath] where [Surface.child] eventually resides
  PAD_SURFACE,

  /// Give half the padding value to the [Surface.innerMaterial] and other half to [Surface.child]
  SPLIT
}

/// ### 🔬 [blurry] Image Filter
/// double [radius] is passed as [sigmaX] and [sigmaY] to `ImageFilter.blur()`
ImageFilter blurry(double radius) {
  return ImageFilter.blur(sigmaX: radius, sigmaY: radius);
}

/// ### 🔰 [biBeveledShape]
///
/// Returns a [BeveledRectangleBorder] where the passed [radius] is applied to
/// two diagonally opposite corners while the other two remain square.
///
/// #### Default is beveled topRight and bottomLeft, but [flip] passed `true` will mirror the result.
///
/// **Pass `true` to [shrinkOneCorner]** to increase the radius on one of the
/// resultant beveled corners based on `Alignment` pass to [shrinkCornerAlignment].
///
/// This aids when stacking multiple [biBeveledShape] within one another when
/// offset with padding while a uniform border is desired.
///
/// (See: [Surface._buildBiBeveledShape)
///
BeveledRectangleBorder biBeveledShape({
  bool flip = false,
  double radius = 5,
  bool shrinkOneCorner = false,
  double ratio = 5 / 4,
  AlignmentGeometry shrinkCornerAlignment,
}) {
  flip ??= false;
  shrinkOneCorner ??= false;

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

  // print('FLIP: $flip, shrinking? $shrinkOneCorner  |  tr: $tr, br: $br, bl: $bl, tl: $tl');

  return BeveledRectangleBorder(
      borderRadius: BorderRadius.only(
    topRight: Radius.circular(tr),
    bottomRight: Radius.circular(br),
    bottomLeft: Radius.circular(bl),
    topLeft: Radius.circular(tl),
  ));
}

/// ### 📦 [Surface]
///
/// An [AnimatedContainer] Widget and [Material] with a number of parameters for
/// both appearance and behavior; some of which are just convenience shortcuts,
/// such as [providesFeedback], that modify very little code.
///
/// Property [borderAlignment] has hard-coded recognition of all nine [Alignment]
/// geometries and will determine which side(s) receive a special border treatment
/// according to property [borderRatio]; defaults at `borderRatio: 2` which makes
/// the [borderAlignment] sides twice as thick, but these borders made be made
/// *thinner* than the others by passing `0 > borderRatio > 1`.
///
/// Considering:
/// 1. [SurfaceCorners] property [corners];
/// 2. properties [tappable], [onTap], [providesFeedback] & [inkHighlightColor], [inkSplashColor];
/// 3. [SurfaceFilter] passed as [filterStyle] and related `double`s [filterSurfaceBlur],
///    [filterMaterialBlur] & [filterChildBlur];
/// 4. and the [duration] property for intrinsic property-change animations;
///
/// A [Surface] is robustly customizable and, *watch out*, could also be expensive.
///
/// - **If [gradient] is passed a value** then [color] is ignored.
///   Same applies to [borderGradient].
///
/// - **If [corners] is passed [SurfaceCorners.SQUARE]** then [radius] is ignored.
/// - **If [corners] is passed [SurfaceCorners.BEVEL]** then `bool` [flipBevels]
///   can mirror the cut corners horizontally. Ignored otherwise.
///
/// - **Passing [borderRatio] a value of `1`** will negate any passed value to [borderAlignment].
/// - Similarly, **passing [borderRatio] in the range `0..1`** will actually make
///   the [borderAlignment] aligned border(s) *thinner* than the others.
///
/// - By default **[tappable] is true and [providesFeedback] is false**.
///   The former includes an [InkResponse] that calls [onTap] and the latter
///   enables [HapticFeedback].
///
/// ---
///
/// - ***WARNING*** Only pass [filterStyle] parameter for which you intend on
///   passing each relevant `filterBlur` parameter.
///     - Not only are the blurry [BackdropFilter]s expensive, but the
///       inheritance/ancestory behavior is strange.
///     - If all three filters are active via [SurfaceFilter.MULTILAYER], passing
///       `filterBorderBlur: 0` eliminates the remaining children filters,
///       regardless of their passed blur value.
///     - This behavior can be worked-around by setting any parent filter value
///       (`BORDER > MATERIAL > CHILD`) to just above 0, specifically `> (`[_MINIMUM_BLUR]` == 0.0003)`,
///       but in this case a different [filterStyle] value should be used anyway
///       that only employs the one or two appropriate filter(s).
///
/// ------
/// ------
///
/// Simple Examples:
/// ```dart
/// // white [Surface] with a black border that's thicker on bottom & right, with rounded corners
/// Surface(borderAlignment: Alignment.bottomRight, borderRadius: 10)
/// // red [Surface] with symmetrical thick, black border and square corners (borderRadius is ignored)
/// Surface(borderThickness: 6, corners: SurfaceCorners.SQUARE, color: Colors.red, borderRadius: 5)
/// // white [Surface] with a gradient border that's thicker on top and left, with two beveled corners
/// Surface(borderAlignment: Alignment.topLeft, corners: SurfaceCorners.BEVEL, flipBevels: true, borderGradient: LinearGradient(...))
/// ```
class Surface extends StatelessWidget {
  /// ## 🏃‍♂️ Default Duration: 500ms
  static const _DEFAULT_DURATION = Duration(milliseconds: 500);

  /// ## ⬜ Default Color: White ~17%
  ///     Color(0x44FFFFFF)
  static const _DEFAULT_COLOR = Color(0x44FFFFFF);

  /// ## ⬛ Default Border Color: Black ~26%
  ///     Color(0x66000000)
  static const _DEFAULT_COLOR_BORDER = Color(0x66000000);

  /// ## 🔘 Default Corner Radius: 6.0
  static const _DEFAULT_RADIUS = 6.0;

  /// See ***WARNING*** above about [filterStyle] and [filterSurfaceBlur] value.
  /// ## Default Blur: 4.0
  /// Radius passed to ImageFilter.blur() as `sigmaX` and `sigmaY`.
  static const _DEFAULT_BLUR = 4.0;

  /// See ***WARNING*** above about [filterStyle] and [filterSurfaceBlur] value.
  /// ## Default Blur for Child: 0.0003
  /// Radius passed to ImageFilter.blur() as `sigmaX` and `sigmaY`.
  static const _MINIMUM_BLUR = 0.0003;

  const Surface({
    this.width,
    this.height,
    this.color = _DEFAULT_COLOR,
    this.disableBorder = false,
    this.tappable = true,
    this.corners = SurfaceCorners.ROUND,
    this.radius,
    this.borderThickness = 3.0,
    this.borderColor = _DEFAULT_COLOR_BORDER,
    this.borderAlignment,
    this.borderRatio = 2.0,
    this.gradient,
    this.borderGradient,
    this.inkSplashColor,
    this.inkHighlightColor,
    this.filterStyle = SurfaceFilter.NONE,
    this.duration = _DEFAULT_DURATION,
    this.curve = Curves.easeIn,
    this.providesFeedback = false,
    this.margin = const EdgeInsets.all(0),
    this.padding = const EdgeInsets.all(0),
    this.paddingStyle = SurfacePadding.PAD_CHILD,
    this.flipBevels = false,
    this.filterSurfaceBlur = _DEFAULT_BLUR,
    this.filterMaterialBlur = _DEFAULT_BLUR,
    this.filterChildBlur = _DEFAULT_BLUR,
    this.onTap,
    this.child,
  })  : assert((radius ?? 0) >= 0,
            '[Surface] > Please provide a non-negative [borderRadius].'),
        assert((borderThickness ?? 0) >= 0,
            '[Surface] > Please provide a non-negative [borderThickness].'),

        /// See ***WARNING*** above about [filterStyle] and [filterBorderBlur] value.
        assert(
            ((filterStyle == SurfaceFilter.TRILAYER)
                    ? (filterSurfaceBlur >= _MINIMUM_BLUR &&
                        filterMaterialBlur >= _MINIMUM_BLUR)
                    : true) ||
                ((filterStyle == SurfaceFilter.INNER_BILAYER)
                    ? (filterMaterialBlur >= _MINIMUM_BLUR)
                    : true) ||
                ((filterStyle == SurfaceFilter.SURFACE_AND_CHILD)
                    ? (filterSurfaceBlur >= _MINIMUM_BLUR)
                    : true) ||
                ((filterStyle == SurfaceFilter.SURFACE_AND_MATERIAL)
                    ? (filterSurfaceBlur >= _MINIMUM_BLUR)
                    : true),
            '[Surface] > Upper-layered filters will be negated if ancestor filters are enabled that have radius < 0.0003. Increase blur radius of lower layer(s) or pass a different [filterStyle].');

  /// The [width] and [height] follow rules of [AnimatedContainer], but apply
  /// to either the [Surface.borderContainer] or, if `disableBorers: true`, the [Surface.innerSurface] directly.
  ///
  /// [radius] impacts the roundedness of default [SurfaceCorners.ROUND] or
  /// set-in of [SurfaceCorners.BEVEL]. If not provided, [Surface._DEFAULT_RADIUS] `== 6.0`
  final double width, height, radius;

  /// If passed [gradient] or [borderGradient], the `Color` parameters are ignored.
  final Color color, borderColor;

  /// The [borderContainer] will not be rendered if `true`.
  ///
  /// [margin] is passed to [innerContainer] in this case, and all parameters
  /// modifying `border` appearance are ignored.
  final bool disableBorder;

  /// Not only does [tappable] mean the [Surface] will provide [onTap], it also
  /// adds an [InkResponse] to the [Material] before rendering [child].
  ///
  /// [providesFeedback] is a convenience to add a [HapticFeedback.vibrate] `onTap`.
  final bool tappable, providesFeedback;

  /// See [SurfaceCorners] for a small list of availabe [Surface] shapes.
  /// Default is [SurfaceCorners.ROUND], but [SurfaceCorners.BEVEL] is fun.
  final SurfaceCorners corners;

  /// [borderThickness] is applied as `padding` to [innerContainer] insetting the [innerSurface].
  ///
  /// According to [borderAlignment], a side(s) with special treatment is made
  /// thicker (default `borderRatio: 2`) or thinner (if `0 > borderRatio > 1`).
  final double borderThickness, borderRatio;

  /// Using an [Alignment], determine a side or sides to receive a special treatment.
  final AlignmentGeometry borderAlignment;

  /// If gradients are passed, then `Color` parameters are ignored.
  final Gradient gradient, borderGradient;

  /// If [tappable] `== true` the [InkResponse] appearance may be customized.
  /// Otherwise no [InkResponse] is rendered with the [Surface].
  final Color inkSplashColor, inkHighlightColor;

  /// See [SurfaceFilter] for a breakdown on the layering of up to three blur filters.
  /// Radii of blur filters handled independently by [filterSurfaceBlur],
  /// [filterMaterialBlur], and [filterChildBlur], supplied in asending z-axis order.
  final SurfaceFilter filterStyle;

  /// The [Duration] that the internal [AnimatedContainer]s use for
  /// intrinsic property-change animations.
  final Duration duration;

  /// The animation [Curve] to employ when this [Surface] is intrinsically animated.
  final Curve curve;

  /// If [disableBorder] `== true` the [Surface] margin is properly handled by
  /// [innerSurface]; but otherwise [margin] applies to [borderContainer] and
  /// the [Surface] as a whole, ignored by [innerSurface].
  ///
  /// [padding] is always ignored by the [borderContainer] as its `padding`
  /// determines the [borderThickness] for a [Surface].
  ///
  /// However, see [paddingStyle] for options on how to distribute the passed
  /// [padding] between (default) [SurfacePadding.PAD_CHILD] or perhaps
  /// [SurfacePadding.PAD_SURFACE].
  final EdgeInsets margin, padding;

  /// The [padding] value may be (default) passed entirely to the [child], but
  /// optionally may be given to a [_clipper] within [innerSurface] before
  /// rendering [child], or split evenly between the two.
  ///
  /// The effect with [SurfacePadding.PAD_SURFACE] can be quite neat as it adds
  /// a third customizable layer to a [Surface] when employed with
  /// [filterStyle] `!=` [SurfaceFilter.SURFACE_AND_MATERIAL].
  final SurfacePadding paddingStyle;

  /// Only if [corners] `==` [SurfaceCorners.BEVEL] will this parameter then
  /// flip the two beveled corners horizontally across x-axis.
  ///
  /// See [biBeveledShape] which ultimately provides the [BeveledRectangleBorder]
  /// used throughout Surface.
  final bool flipBevels;

  /// `filterBlur` parameters default to [_MINIMUM_BLUR] `== 0.0000001` so that
  /// upper-layered filters are not erased by an ancestor filter having 0 radius.
  ///
  /// - If [filterStyle] is set to enable all three filters, by [SurfaceFilter.TRILAYER],
  ///   set all three `filterBlur` params `>= 0.01`.
  /// - Similarly, if only two filters are enabled by, say [SurfaceFilter.SURFACE_AND_CHILD],
  ///   the lower filter ([filterSurfaceBlur] in this case) must be above zero to
  ///   not negate any value passed to the higher filter ([filterChildBlur] in this case).
  final double filterSurfaceBlur, filterMaterialBlur, filterChildBlur;

  /// Disabled by [tappable] `== false`. Pass a `function` to peform any time
  /// the [InkResponse] on this [Surface] responds to a tap input.
  final VoidCallback onTap;

  /// The Widget to render inside considering all layout parameters.
  final Widget child;

  /// 👷‍♂️ Build [Surface]
  @override
  Widget build(BuildContext context) {
    if (corners == SurfaceCorners.SQUARE) if (radius != null)
      print(
          '[$context] > [borderRadius] passed non-null value while [corners] also set to SurfaceCorners.SQUARE. \n[borderRadius] will be ignored.');
    if (corners != SurfaceCorners.BEVEL && (flipBevels ?? false))
      print(
          '[$context] > Parameter [flipBevels] will be ignored because [corners] not set to [SurfaceCorners.BEVEL].');
    if (gradient != null && color != _DEFAULT_COLOR)
      print(
          '[$context] > Both [gradient] and [color] have been passed, so [color] will be ignored.');
    if (borderGradient != null && borderColor != _DEFAULT_COLOR_BORDER)
      print(
          '[$context] > Both [borderGadient] and [borderColor] have been passed, so [borderColor] will be ignored.');

    /// 🔢 Establish the thickness of each border-side (padding property for [borderContainer])
    /// based on [borderThickness] and considering [borderAlignment] & [borderRatio]
    final double left = (borderAlignment == Alignment.topLeft ||
            borderAlignment == Alignment.centerLeft ||
            borderAlignment == Alignment.bottomLeft)
        ? borderThickness * borderRatio
        : borderThickness;
    final double top = (borderAlignment == Alignment.topLeft ||
            borderAlignment == Alignment.topCenter ||
            borderAlignment == Alignment.topRight)
        ? borderThickness * borderRatio
        : borderThickness;
    final double right = (borderAlignment == Alignment.topRight ||
            borderAlignment == Alignment.centerRight ||
            borderAlignment == Alignment.bottomRight)
        ? borderThickness * borderRatio
        : borderThickness;
    final double bottom = (borderAlignment == Alignment.bottomLeft ||
            borderAlignment == Alignment.bottomCenter ||
            borderAlignment == Alignment.bottomRight)
        ? borderThickness * borderRatio
        : borderThickness;

    /// 🧅 [innerMaterial] may contain [buildInkResponse] but always eventually
    /// holds [child], as the InkResponse will soon [buildChild] as well.
    ///
    /// Supply [width], [height], and [margin] in the case where
    /// [borderContainer] is not built ([disableBorder] `== true`).
    Widget innerMaterial = AnimatedContainer(
      /// [width] and [height] may be `null` anyway
      width: (disableBorder) ? width : null,
      height: (disableBorder) ? height : null,
      margin: (disableBorder) ? margin : const EdgeInsets.all(0),
      duration: duration,
      curve: curve,

      /// Build shape and color for [innerMaterial]
      decoration: _buildDecoration(
        layer: SurfaceLayer.MATERIAL,
        isGradient: (gradient != null),
      ),

      /// Material will be canvas for [child] and respond to touches
      child: Material(
        color: const Color(0x00FFFFFF),
        child: (tappable) ? _buildInkResponse() : _buildChild(),
      ),
    );

    /// 🐚 [borderContainer] contains [innerMaterial] & represents [Surface] border
    Widget borderContainer = AnimatedContainer(
      /// [width] and [height] may be `null` anyway
      width: width,
      height: height,
      margin: margin,
      duration: duration,
      curve: curve,

      /// 🔲 This padding is effectively the border of the [Surface]
      padding: (borderAlignment == null || borderAlignment == Alignment.center)
          ? EdgeInsets.all(borderThickness)

          /// Generated at start of build() using [borderThickness].
          : EdgeInsets.fromLTRB(left, top, right, bottom),

      /// Build shape and color for [borderContainer]
      decoration: _buildDecoration(
        layer: SurfaceLayer.BORDER,
        isGradient: (borderGradient != null),
      ),

      /// 🧅 [innerMaterial] as descendent of 🐚 [borderContainer]
      child: _filterOrChild(
        layer: SurfaceLayer.MATERIAL,
        child: innerMaterial,
      ),
    );

    /// ### 📤 Return [Surface]
    if (disableBorder)
      return _filterOrChild(layer: SurfaceLayer.MATERIAL, child: innerMaterial);
    else
      return _filterOrChild(layer: SurfaceLayer.BORDER, child: borderContainer);
  }

  /// 👷‍♂️👆 [_buildInkResponse]
  /// If [tappable] is `true` then Surface parameter [child] is passed into
  /// this [InkResponse] with customizable [inkHighlightColor] and [inkSplashColor].
  InkResponse _buildInkResponse() {
    return InkResponse(
      containedInkWell: true,
      canRequestFocus: true,
      highlightShape: BoxShape.rectangle,
      highlightColor: inkHighlightColor,
      splashColor: inkSplashColor,
      customBorder: (corners == SurfaceCorners.BEVEL)
          ? _buildBiBeveledShape(isBorder: false)
          : RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  (corners == SurfaceCorners.SQUARE)
                      ? 0
                      : radius ?? _DEFAULT_RADIUS),
            ),

      onTap: () {
        if (providesFeedback) HapticFeedback.vibrate();
        onTap?.call();
      },

      /// 👶 [child]
      child: _buildChild(),
    );
  }

  /// 👶 [_buildChild] with passed [child].
  /// A [ClipPath] from [_clipper] is used to ensure child renders properly
  /// at inner corners.
  /// Property [paddingStyle] determines how [padding] is distributed.
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

  /// 👷‍♂️🏗 [_buildDecoration] returns Shape or [BoxDecoration] considering whether
  /// to pass [color] vs. [gradient]
  Decoration _buildDecoration({
    @required SurfaceLayer layer,
    @required bool isGradient,
  }) {
    return (isGradient)
        ? _buildGradientDecoration(layer)
        : _buildColorDecoration(layer);
  }

  /// 👷‍♂️🔰 [_buildBiBeveledShape]
  /// Customized [biBeveledShape] so the [innerMaterial] may have a deeper-cut
  /// beveled corner if the property [borderAlignment] is passed and corner-set.
  BeveledRectangleBorder _buildBiBeveledShape({@required bool isBorder}) {
    return biBeveledShape(
        // radius: (radius ?? _DEFAULT_RADIUS) * (40 - borderThickness - 2.3 * borderThickness) / 40,
        radius: radius ?? _DEFAULT_RADIUS,
        flip: flipBevels ?? false,

        /// A corner may indeed not be shrunken after all if [borderAlignment] is not corner-set.
        ///
        /// (See: [determineShrinkCornerAlignment] final else returns `Alignment.center`
        /// which [biBeveledShape] knows to ignore when shrinking a corner.)
        shrinkOneCorner: !isBorder,
        shrinkCornerAlignment: _determineShrinkCornerAlignment());
  }

  /// 🔧🔪 Shortcut [_clipper] since a [ClipPath] is employed similarly
  /// in more than one context.
  ClipPath _clipper({@required SurfaceLayer layer, @required Widget content}) {
    return ClipPath(
      child: content,
      clipper: ShapeBorderClipper(
        shape: (corners == SurfaceCorners.BEVEL)
            ?

            /// [SurfaceCorners.BEVEL] may need a slightly different shape for
            /// the [innerSurface] vs. the [borderContainer].
            (layer == SurfaceLayer.BORDER)
                ? _buildBiBeveledShape(isBorder: true)
                : _buildBiBeveledShape(isBorder: false)

            /// A [SurfaceCorners.ROUND] or SQUARE Surface uses the same shape
            /// regardless of [SurfaceLayer]. TODO: Altered inner radius for roundedRects
            : RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    (corners == SurfaceCorners.SQUARE)
                        ? 0
                        : radius ?? _DEFAULT_RADIUS),
              ),
      ),
    );
  }

  /// 🔧🔬 Shortcut [_filterOrChild] which considers the currently rendering
  /// [SurfaceLayer] and the parameter [filterStyle].
  ///
  /// If an [ImageFilter] is not needed, this method just returns the passed child.
  _filterOrChild({
    @required SurfaceLayer layer,
    @required Widget child,
  }) {
    if (filterStyle == SurfaceFilter.NONE) return child;

    switch (layer) {
      case SurfaceLayer.BORDER:

        /// Consider the [filterStyle] options that would exlude rendering
        /// for this [SurfaceLayer].
        return (filterSurfaceBlur > 0 &&
                filterStyle != SurfaceFilter.INNER_BILAYER &&
                filterStyle != SurfaceFilter.MATERIAL &&
                filterStyle != SurfaceFilter.CHILD)

            /// If passes, return the child clipped and nested on a filter.
            ? _clipper(
                layer: SurfaceLayer.BORDER,
                content: BackdropFilter(
                    filter: blurry(filterSurfaceBlur), child: child),
              )

            /// Otherwise return child, as it says on the tin.
            : child;
      case SurfaceLayer.MATERIAL:
        return (filterMaterialBlur > 0 &&
                filterStyle != SurfaceFilter.SURFACE_AND_CHILD &&
                filterStyle != SurfaceFilter.SURFACE &&
                filterStyle != SurfaceFilter.CHILD)
            ? _clipper(
                layer: SurfaceLayer.CHILD,
                content: BackdropFilter(
                    filter: blurry(filterMaterialBlur), child: child),
              )
            : child;
      case SurfaceLayer.CHILD:
        return (filterChildBlur > 0 &&
                filterStyle != SurfaceFilter.SURFACE_AND_MATERIAL &&
                filterStyle != SurfaceFilter.SURFACE &&
                filterStyle != SurfaceFilter.MATERIAL)

            /// Where this case is returned, a [clipper] is already present.
            ? BackdropFilter(filter: blurry(filterChildBlur), child: child)
            : child;
    }

    assert(false,
        'Filter code has been altered. Affected return value of [filterOrChild].');
    return child;
  }

  /// 👷‍♂️🌆 Build [gradient] Decorations
  Decoration _buildGradientDecoration(SurfaceLayer layer) {
    if (corners == SurfaceCorners.BEVEL) {
      return ShapeDecoration(
          gradient: (layer == SurfaceLayer.BORDER) ? borderGradient : gradient,
          shape: (layer == SurfaceLayer.BORDER)
              ? _buildBiBeveledShape(isBorder: true)
              : _buildBiBeveledShape(isBorder: false));
    } else {
      return BoxDecoration(
          gradient: (layer == SurfaceLayer.BORDER) ? borderGradient : gradient,
          borderRadius: BorderRadius.all(Radius.circular(
              (corners == SurfaceCorners.SQUARE)
                  ? 0
                  : radius ?? _DEFAULT_RADIUS)));
    }
  }

  /// 👷‍♂️🎨 Build [color] Decorations
  Decoration _buildColorDecoration(SurfaceLayer layer) {
    if (corners == SurfaceCorners.BEVEL)
      return ShapeDecoration(
          color: (layer == SurfaceLayer.BORDER) ? borderColor : color,
          shape: (layer == SurfaceLayer.BORDER)
              ? _buildBiBeveledShape(isBorder: true)
              : _buildBiBeveledShape(isBorder: false));
    else
      return BoxDecoration(
          color: (layer == SurfaceLayer.BORDER) ? borderColor : color,
          borderRadius: BorderRadius.all(Radius.circular(
              (corners == SurfaceCorners.SQUARE)
                  ? 0
                  : radius ?? _DEFAULT_RADIUS)));
  }

  /// 🧮 [_determineShrinkCornerAlignment]
  /// Shrink the corner diagonally-opposite the corner from where [borderAlignment]
  /// results in thicker border.
  ///
  /// Unless (flipBevels) then, taking this finding, shrink now the
  /// horizontally-opposite corner.
  ///
  /// Only impacts a [Surface] that has a corner-set [borderAlignment].
  /// (i.e. [borderAlignment] = `Alignment.bottomCenter` will shrink no corners)
  Alignment _determineShrinkCornerAlignment() {
    // return Alignment.center;
    return (borderAlignment == Alignment.topRight)
        ? (flipBevels)
            ? Alignment.bottomRight
            : Alignment.bottomLeft
        : (borderAlignment == Alignment.bottomRight)
            ? (flipBevels)
                ? Alignment.topRight
                : Alignment.topLeft
            : (borderAlignment == Alignment.bottomLeft)
                ? (flipBevels)
                    ? Alignment.topLeft
                    : Alignment.topRight
                : (borderAlignment == Alignment.topLeft
                    ? (flipBevels)
                        ? Alignment.bottomLeft
                        : Alignment.bottomRight

                    /// Final else returns `Alignment.center` which [biBeveledShape]
                    /// knows to ignore when shrinking a corner.
                    : Alignment.center);
  }
}
