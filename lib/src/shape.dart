/// ## 🌟 Surface Library: Shape
library surface;

import '../surface.dart';
import 'dart:ui';
import 'dart:math';
import 'package:flutter/foundation.dart';

/// ## 🔘 Default Corner Radius: `10.0`
const _RADIUS = BorderRadius.all(Radius.circular(10.0));

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
/// ### 📐 [Corner]
/// Simple corner appearance options for a [CornerSpec]'s four [Corner] fields.
/// - [Corner.SQUARE], [Corner.ROUND], or [Corner.BEVEL]
enum Corner {
  /// ### 📐 [NONE]
  /// No `Corner` is a circle, or the quarter-circle that would make this corner.
  /// No 🔘 [CornerSpec.radius] considered.
  NONE,

  /// ### 📐 [SQUARE]
  /// A squared `Corner` is that of a standard rectangle.
  /// No 🔘 [CornerSpec.radius] considered.
  SQUARE,

  /// ### 📐 [ROUND]
  /// A rounded `Corner` is a quarter-circle that
  /// "softens" / curves the corners by 🔘 [CornerSpec.radius].
  ROUND,

  /// ### 📐 [BEVEL]
  /// A beveled `Corner` is a straight line that
  /// "cuts" the corners by 🔘 [CornerSpec.radius].
  BEVEL,
}

//! ---
/// ### 📐 [CornerSpec]
/// Define the [Corner] appearance options for each
/// of the four corners in a [Shape] and their 🔘 [radius].
///
/// A `const` constructor `CornerSpec()` requires all parameters,
/// though [radius] will default.
///
/// **`const` `CornerSpec`s with pre-set configurations available:**
/// - [SQUARED], [ROUNDED], [BEVELED]
///
/// **`CornerSpec` named constructors with pre-filled [Corner]s:**
/// - [CornerSpec.squaredWith]
/// - [CornerSpec.roundedWith]
/// - [CornerSpec.beveledWith]
class CornerSpec with Diagnosticable {
  /// ### 📐 [CIRCLE]
  /// All four corners of the [Shape] are [Corner.NONE];
  /// 🔘 [Shape.radius] is ignored.
  static const CIRCLE = CornerSpec.noneWith();

  /// ### 📐 [SQUARED]
  /// All four corners of the [Shape] are [Corner.SQUARE]ed;
  /// 🔘 [Shape.radius] is ignored.
  static const SQUARED = CornerSpec.squaredWith();

  /// ### 📐 [ROUNDED]
  /// All four corners will be [Corner.ROUND]ed default 🔘 [_RADIUS] `== 10.0`.
  static const ROUNDED = CornerSpec();

  /// ### 📐 [ROUNDED_50]
  /// All four corners will be [Corner.ROUND]ed with 🔘 [radius] `== 50.0`.
  static const ROUNDED_50 =
      CornerSpec(radius: BorderRadius.all(Radius.circular(50.0)));

  /// ### 📐 [BEVELED]
  /// All corners will be [Corner.BEVEL]ed by default 🔘 [_RADIUS] `== 10.0`.
  static const BEVELED = CornerSpec.beveledWith();

  /// ### 📐 [BEVELED_50]
  /// All four corners will be [Corner.BEVEL]ed with 🔘 [radius] `== 50.0`.
  static const BEVELED_50 =
      CornerSpec.beveledWith(radius: BorderRadius.all(Radius.circular(50.0)));

  /// ### 📐 [BIBEVELED_50]
  /// All four corners will be [Corner.BEVEL]ed with 🔘 [radius] `== 50.0`.
  static const BIBEVELED_50 = CornerSpec.beveledWith(
      topLeft: Corner.SQUARE,
      bottomRight: Corner.SQUARE,
      radius: BorderRadius.all(Radius.circular(50.0)));

  /// ### 📐 [BIBEVELED_50_FLIP]
  /// All four corners will be [Corner.BEVEL]ed with 🔘 [radius] `== 50.0`.
  static const BIBEVELED_50_FLIP = CornerSpec.beveledWith(
      topRight: Corner.SQUARE,
      bottomLeft: Corner.SQUARE,
      radius: BorderRadius.all(Radius.circular(50.0)));

  /// ### 📐 [CornerSpec] - (Rounded With)
  /// A `CornerSpec` that accepts any [Corner] for each field,
  /// but defaults them all to [Corner.ROUND].
  ///
  /// [CornerSpec.ROUNDED] is a `const` `CornerSpec` available
  /// with all four corners initialized to [Corner.ROUND].
  /// - Also see: [CornerSpec.ROUNDED_50]
  ///
  /// See [CornerSpec.squaredWith] & [CornerSpec.beveledWith]
  /// for `const` constructors that default their fields differently.
  const CornerSpec({
    this.topLeft = Corner.ROUND,
    this.topRight = Corner.ROUND,
    this.bottomRight = Corner.ROUND,
    this.bottomLeft = Corner.ROUND,
    this.radius = _RADIUS,
  });

  /// ### 📐 [CornerSpec] - None With
  /// A `CornerSpec` that accepts any [Corner] for each field,
  /// but defaults them all to [Corner.NONE].
  ///
  /// [CornerSpec.CIRCLE] is a `const` `CornerSpec` available
  /// with all four corners initialized to [Corner.NONE].
  const CornerSpec.noneWith({
    this.topLeft = Corner.NONE,
    this.topRight = Corner.NONE,
    this.bottomRight = Corner.NONE,
    this.bottomLeft = Corner.NONE,
    this.radius = _RADIUS,
  });

  /// ### 📐 [CornerSpec] - Squared With
  /// A `CornerSpec` that accepts any [Corner] for each field,
  /// but defaults them all to [Corner.SQUARE].
  ///
  /// [CornerSpec.SQUARED] is a `const` `CornerSpec` available
  /// with all four corners initialized to [Corner.SQUARE].
  const CornerSpec.squaredWith({
    this.topLeft = Corner.SQUARE,
    this.topRight = Corner.SQUARE,
    this.bottomRight = Corner.SQUARE,
    this.bottomLeft = Corner.SQUARE,
    this.radius = _RADIUS,
  });

  /// ### 📐 [CornerSpec] - Beveled With
  /// A `CornerSpec` that accepts any [Corner] for each field,
  /// but defaults them all to [Corner.BEVEL].
  ///
  /// [CornerSpec.BEVELED] is a `const` `CornerSpec` available
  /// with all four corners initialized to [Corner.BEVEL]. Also see:
  /// - [CornerSpec.BEVELED_50]
  /// - [CornerSpec.BIBEVELED_50]
  /// - [CornerSpec.BIBEVELED_50_FLIP]
  const CornerSpec.beveledWith({
    this.topLeft = Corner.BEVEL,
    this.topRight = Corner.BEVEL,
    this.bottomRight = Corner.BEVEL,
    this.bottomLeft = Corner.BEVEL,
    this.radius = _RADIUS,
  });

  /// ### 📐 [Corner]
  /// Define which `Corner` shape to use for this corner,
  /// configured by [BorderRadiusGeometry] 🔘 [radius].
  /// - [Corner.SQUARE]
  /// - [Corner.ROUND]
  /// - [Corner.BEVEL]
  final Corner topLeft, topRight, bottomRight, bottomLeft;

  /// The 🔘 [radius] impacts the roundedness of default
  /// 📐 [Corner.ROUND] or bevel-depth of 📐 [Corner.BEVEL] corners.
  ///
  /// If not provided, [radius] `==` [Surface._RADIUS] `== 10.0`.
  final BorderRadiusGeometry radius;

  /// Return the `Set<Corner>` of this [CornerSpec]'s potential [Corner]s.
  ///
  /// Quickly determine if this `ShapeSpec` has any `Corner`s of a specific type.
  Set<Corner> get asSet => {topLeft, topRight, bottomRight, bottomLeft};

  /// 📋 Returns a copy of this `CornerSpec` with the given properties.
  CornerSpec copyWith({
    Corner? topLeft,
    Corner? topRight,
    Corner? bottomRight,
    Corner? bottomLeft,
    BorderRadiusGeometry? radius,
  }) =>
      CornerSpec(
        topLeft: topLeft ?? this.topLeft,
        topRight: topRight ?? this.topRight,
        bottomRight: bottomRight ?? this.bottomRight,
        bottomLeft: bottomLeft ?? this.bottomLeft,
        radius: radius ?? this.radius,
      );

  /// Linearly interpolate between two [CornerSpec] objects.
  ///
  /// If either is `null`, defaults to [CornerSpec.ROUNDED].
  /// (If both are `null`, this returns `null`.)
  ///
  /// The `radius` is acquired by [BorderRadiusGeometry.lerp].
  ///
  /// For now, the four [CornerSpec] corners swap values from `a` to `b`
  /// according to an arbitrary keyframe along `t`.
  ///
  /// - TL: `t < 0.5` returned [Corners] are from `a`, otherwise from `b`
  /// - TR: `t < 0.65` returned [Corners] are from `a`, otherwise from `b`
  /// - BR: `t < 0.8` returned [Corners] are from `a`, otherwise from `b`
  /// - BL: `t < 0.95` returned [Corners] are from `a`, otherwise from `b`
  ///
  /// TODO: Find help.
  static CornerSpec? lerp(CornerSpec? a, CornerSpec? b, double t) {
    if (a == null && b == null) return null;
    a ??= CornerSpec.ROUNDED;
    b ??= CornerSpec.ROUNDED;
    return CornerSpec(
      topLeft: t < 0.5 ? a.topLeft : b.topLeft,
      topRight: t < 0.65 ? a.topRight : b.topRight,
      bottomRight: t < 0.8 ? a.bottomRight : b.bottomRight,
      bottomLeft: t < 0.95 ? a.bottomLeft : b.bottomLeft,
      radius: BorderRadiusGeometry.lerp(a.radius, b.radius, t)!,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<Corner>('topLeft', topLeft));
    properties.add(EnumProperty<Corner>('topRight', topRight));
    properties.add(EnumProperty<Corner>('bottomRight', bottomRight));
    properties.add(EnumProperty<Corner>('bottomLeft', bottomLeft));
    properties.add(DiagnosticsProperty<BorderRadiusGeometry>('radius', radius));
  }
}

//! ---
/// ### 🔲 [Peek]
/// [Surface] may be provided a 🔲 [Peek] to define several attributes about
/// the shared space at the adjacent edge of 📚 [SurfaceLayer.BASE] and 📚 [SurfaceLayer.MATERIAL].
class Peek with Diagnosticable {
  /// ### 🔲 [Peek]
  /// A 🌟 [Surface] may be provided a 🔲 [Peek] to define several attributes about
  /// the shared space at the adjacent edge of 📚 [SurfaceLayer.BASE] and 📚 [SurfaceLayer.MATERIAL].
  /// - It may be considered to function like a border for the [Surface.child] content.
  ///   - Note that [Surface] does not currently support actual [Border]s.
  ///   - To give a border to a Surface, provide a Surface as a `child` to a [DecoratedBox] or [Container].
  const Peek({
    this.peek = 3.0,
    this.peekRatio = 2.0,
    this.peekAlignment = Alignment.center,
  }) : assert(peek >= 0, '[Peek] > Provide a non-negative `peek`.');

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

  /// 📋 Returns a copy of this `Peek` with the given properties.
  Peek copyWith({
    double? peek,
    double? peekRatio,
    AlignmentGeometry? peekAlignment,
  }) =>
      Peek(
        peek: peek ?? this.peek,
        peekRatio: peekRatio ?? this.peekRatio,
        peekAlignment: peekAlignment ?? this.peekAlignment,
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('peek', peek));
    properties.add(DoubleProperty('peekRatio', peekRatio));
    properties.add(
        DiagnosticsProperty<AlignmentGeometry>('peekAlignment', peekAlignment));
  }
}

//! ---
/// ### 👆 [TapSpec]
/// A 🌟 [Surface] may be provided a 👆 [TapSpec] to define
/// its "tappability" and appearance & behavior therein, if enabled.
class TapSpec with Diagnosticable {
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

  /// 📋 Returns a copy of this `TapSpec` with the given properties.
  TapSpec copyWith({
    bool? tappable,
    bool? providesFeedback,
    Color? inkSplashColor,
    Color? inkHighlightColor,
    VoidCallback? onTap,
  }) =>
      TapSpec(
        tappable: tappable ?? this.tappable,
        providesFeedback: providesFeedback ?? this.providesFeedback,
        inkHighlightColor: inkHighlightColor ?? this.inkHighlightColor,
        inkSplashColor: inkSplashColor ?? this.inkSplashColor,
        onTap: onTap ?? this.onTap,
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(FlagProperty('tappable',
        value: tappable, ifFalse: '!tappable', ifTrue: 'tappable'));
    properties.add(FlagProperty('providesFeedback',
        value: providesFeedback, ifTrue: 'providesFeedback'));
    properties.add(ColorProperty('splashColor', inkSplashColor));
    properties.add(ColorProperty('highlightColor', inkHighlightColor));
  }
}

//! ---
/// ### 🔰 [Shape]
/// 📐 [CornerSpec]
/// - Use [corners] to customize all four corners in a [Shape] and their 🔘 [radius].
/// - **`const` `CornerSpec`s with pre-set configurations available:**
/// [CornerSpec.SQUARED], [CornerSpec.ROUNDED], [CornerSpec.BEVELED]
///
/// [border]
/// - Add a [BorderSide] decoration to the edges of this [Shape].
///
/// 🔛 [padLayer]
/// - Specify a 📚 [SurfaceLayer] to receive [Surface.padding] value.
class Shape with Diagnosticable {
  const Shape({
    this.corners = CornerSpec.ROUNDED,
    this.baseCorners,
    this.border,
    this.baseBorder,
    this.padLayer = SurfaceLayer.CHILD,
    this.childScale = 1.0,
    this.materialScale = 1.0,
    this.flipBevels = false,
  });

  /// ### 📐 [CornerSpec]
  /// Define the [Corner] appearance options for each
  /// of the four corners in a [Shape] and their 🔘 [radius].
  ///
  /// The 📐 [baseCorners] may be specified separately from [corners],
  /// but is optional and will only impact the 📚 [SurfaceLayer.BASE].
  ///
  /// **`const` `CornerSpec`s with pre-set configurations available:**
  /// - [SQUARED], [ROUNDED], [BEVELED]
  ///
  /// **`CornerSpec` named constructors with pre-filled [Corner]s:**
  /// - [CornerSpec.squaredWith]
  /// - [CornerSpec.roundedWith]
  /// - [CornerSpec.beveledWith]
  final CornerSpec corners;

  /// ### 📐 [CornerSpec]
  /// The 📐 [baseCorners] may be specified separately from [corners],
  /// but is optional and will only impact the 📚 [SurfaceLayer.BASE].
  final CornerSpec? baseCorners;

  /// Define a [BorderSide] decoration for the edges of this [Shape].
  ///
  /// The [baseBorder] may be specified separately from [border],
  /// but is optional and will only impact the 📚 [SurfaceLayer.BASE].
  final BorderSide? border;

  /// The [baseBorder] may be specified separately from [border],
  /// but is optional and will only impact the 📚 [SurfaceLayer.BASE].
  final BorderSide? baseBorder;

  /// Specify a 📚 [SurfaceLayer] as 🔛 [padLayer]
  /// to receive [Surface.padding] value.
  ///
  /// By default, passed entirely to 📚 [SurfaceLayer.CHILD], but
  /// optionally may be given to a 🔪 [_clip] within 📚 [SurfaceLayer.MATERIAL]
  /// before rendering 👶 [child].
  ///
  /// The effect with 🔛 [padLayer] `=` 📚 [SurfaceLayer.MATERIAL] can be neat
  /// with non-negligible [Surface.padding] as it adds a third customizable
  /// 📚 Layer to a 🌟 Surface.
  /// - Consider 👓 [Filter.filteredLayers] `=` 👓 [Filter.TRILAYER].
  ///
  /// ### ❗ Special Case
  /// Specifying 📚 [SurfaceLayer.BASE] is a special case in which
  /// [Surface.padding] is then *split* between 📚 `MATERIAL` and 📚 `CHILD` layers.
  final SurfaceLayer padLayer;

  /// Declare a `double` [childScale] (defaults `1.0`) that a 🌟 [Surface]
  /// will utilize when rendering its 👶 `child` 📚 [SurfaceLayer].
  ///
  /// Because the [Surface.child] is smaller than the 📚 [SurfaceLayer.MATERIAL]
  /// if there is `padding` involved by [padLayer] `== SurfaceLayer.MATERIAL`,
  /// and considering [Shape] has no `child` configuration:
  /// the 📚 `MATERIAL` shape may require "scaling" for use as the 📚 `CHILD` shape.
  ///
  /// With default [padLayer] or without [Surface.padding], the default `1.0`
  /// should be desirable. Otherwise, easily scale the [Shape]
  /// for 📚 [SurfaceLayer.CHILD] with this value.
  ///
  /// If a smaller, inset version of 📚 `MATERIAL` `Shape` -- ***after***
  /// scaling with any [materialScale] -- is considered `1.0`,
  /// a value between `0.5 -> 1.0` may be desirable with non-negligible `padding`
  /// for the resultant `Shape` will have a *smaller*
  /// border/corner radius than the 📚 `MATERIAL`.
  final double childScale;

  /// Declare a `double` [materialScale] (defaults `1.0`) that a 🌟 [Surface]
  /// will utilize when rendering the [Shape] for 📚 [SurfaceLayer.MATERIAL].
  ///
  /// Because the 📚 `MATERIAL` is smaller than the 📚 `BASE`
  /// if there is 🔲 [Peek.peek] involved, the 📚 `MATERIAL` `Shape` may require
  /// "scaling" to have corners that aesthetically fit within the 📚 `BASE` `Shape`
  /// -- that is unless [baseCorners.radius] is set manually
  /// from [corners.radius] for desired aesthetics, then default `1.0` is desired.
  ///
  /// Without specifying [baseCorners], easily scale the [Shape] for
  /// 📚 [SurfaceLayer.MATERIAL] with this value.
  ///
  /// If a smaller, inset version of 📚 `BASE` `Shape` is considered `1.0`,
  /// a value between `0.5 -> 1.0` may be desirable with non-negligible 🔲 `peek`
  /// for the resultant `Shape` will have a *smaller*
  /// border/corner radius than the 📚 `BASE`.
  final double materialScale;

  /// Only if [corners] `==` 📐 [CornerSpec.BEVELED] will 🔁 [flipBevels] then
  /// mirror the two beveled corners horizontally across x-axis; ignored otherwise.
  ///
  /// See 🔰 [Shape] which ultimately provides the
  /// [BeveledRectangleBorder] used throughout Surface.
  @Deprecated(_DEPRECATED)
  final bool flipBevels;

  /// Returns nullable [baseCorners] if initialized, else required [corners].
  CornerSpec get baseCornersOr => baseCorners ?? corners;

  /// Returns nullable [baseBorder] if initialized, else nullable [border].
  BorderSide? get baseBorderOr => baseBorder ?? border;

  /// 📋 Returns a copy of this `Shape` with the given properties.
  Shape copyWith({
    CornerSpec? corners,
    CornerSpec? baseCorners,
    BorderSide? border,
    BorderSide? baseBorder,
    SurfaceLayer? padLayer,
    double? childScale,
    double? materialScale,
    bool? flipBevels,
  }) =>
      Shape(
        corners: corners ?? this.corners,
        baseCorners: corners ?? this.baseCorners,
        border: border ?? this.border,
        baseBorder: baseBorder ?? this.baseBorder,
        padLayer: padLayer ?? this.padLayer,
        childScale: childScale ?? this.childScale,
        materialScale: materialScale ?? this.materialScale,
        flipBevels: flipBevels ?? this.flipBevels,
      );

  /// ### 🔰 [Shape.biBeveledRectangle]
  ///
  /// Returns a [BeveledRectangleBorder] where the passed 🔘 [radius] is applied to
  /// two diagonally opposite corners while the other two remain square.
  ///
  /// #### Default is beveled topRight and bottomLeft, but [flip] passed `true` will mirror the result.
  ///
  /// **Pass `true` to [shrinkOneCorner]** to increase the radius on one of the
  /// resultant beveled corners based on `Alignment` pass to [shrinkCornerAlignment].
  ///
  /// This aids when stacking multiple 🔰 [Shape] within one another when
  /// offset with padding while a uniform border is desired.
  ///
  /// (See: [Surface._buildBiBeveledShape)
  @Deprecated(_DEPRECATED)
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

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<CornerSpec>('corners', corners));
    properties.add(DiagnosticsProperty<CornerSpec>('baseCorners', baseCorners));
    properties.add(EnumProperty<SurfaceLayer>('padLayer', padLayer));
    properties.add(DiagnosticsProperty<BorderSide>('border', border));
    properties.add(DiagnosticsProperty<BorderSide>('baseBorder', baseBorder));
  }
}

/// TODO WIP
class SurfaceShape extends OutlinedBorder with Diagnosticable {
  const SurfaceShape({
    required this.cornerSpec,
    required this.borderRadius,
    BorderSide border = BorderSide.none,
  }) : super(side: border);

  final CornerSpec cornerSpec;
  final BorderRadiusGeometry borderRadius;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(side.width);

  @override
  ShapeBorder scale(double t) => copyWith(
        borderRadius: borderRadius * t,
        side: side.scale(t),
      );

  /// 📋 Returns a copy of this `SurfaceShape` with the given properties.
  @override
  SurfaceShape copyWith({
    BorderRadiusGeometry? borderRadius,
    BorderSide? side,
  }) =>
      SurfaceShape(
        cornerSpec: this.cornerSpec,
        borderRadius: borderRadius ?? this.borderRadius,
        border: side ?? this.side,
      );

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) => _getPath(
      borderRadius.resolve(textDirection).toRRect(rect).deflate(side.width),
      borderRadius.resolve(textDirection));

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) => _getPath(
      borderRadius.resolve(textDirection).toRRect(rect),
      borderRadius.resolve(textDirection));

  /// TODO WIP
  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    if (a is SurfaceShape) {
      return SurfaceShape(
        cornerSpec: CornerSpec.lerp(a.cornerSpec, cornerSpec, t)!, // hmm
        borderRadius:
            BorderRadiusGeometry.lerp(a.borderRadius, borderRadius, t)!,
        border: BorderSide.lerp(a.side, side, t),
      );
    }
    return super.lerpFrom(a, t);
  }

  /// TODO WIP
  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) {
    if (b is SurfaceShape) {
      return SurfaceShape(
        cornerSpec: CornerSpec.lerp(cornerSpec, b.cornerSpec, t)!, // hmm
        borderRadius:
            BorderRadiusGeometry.lerp(borderRadius, b.borderRadius, t)!,
        border: BorderSide.lerp(side, b.side, t),
      );
    }
    return super.lerpTo(b, t);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    if (rect.isEmpty) return;
    switch (side.style) {
      case BorderStyle.none:
        break;
      case BorderStyle.solid:
        final Path path = getOuterPath(rect, textDirection: textDirection)
          ..addPath(
            getInnerPath(rect, textDirection: textDirection),
            Offset.zero,
          );
        canvas.drawPath(path, side.toPaint());
        break;
    }
  }

  Path _getPath(RRect rrect, BorderRadius radius) {
    final bool tlIsSquare = cornerSpec.topLeft == Corner.SQUARE;
    final bool trIsSquare = cornerSpec.topRight == Corner.SQUARE;
    final bool brIsSquare = cornerSpec.bottomRight == Corner.SQUARE;
    final bool blIsSquare = cornerSpec.bottomLeft == Corner.SQUARE;

    final Offset centerLeft = Offset(rrect.left, rrect.center.dy);
    final Offset centerRight = Offset(rrect.right, rrect.center.dy);
    final Offset centerTop = Offset(rrect.center.dx, rrect.top);
    final Offset centerBottom = Offset(rrect.center.dx, rrect.bottom);

    final double tlRadiusX = max(0.0, rrect.tlRadiusX);
    final double tlRadiusY = max(0.0, rrect.tlRadiusY);
    final double trRadiusX = max(0.0, rrect.trRadiusX);
    final double trRadiusY = max(0.0, rrect.trRadiusY);
    final double blRadiusX = max(0.0, rrect.blRadiusX);
    final double blRadiusY = max(0.0, rrect.blRadiusY);
    final double brRadiusX = max(0.0, rrect.brRadiusX);
    final double brRadiusY = max(0.0, rrect.brRadiusY);

    // ?: Safe coords for corners.
    // May have a literal corner Offset inserted between any pair if [Corner.SQUARE].
    // Beveled will `first` lineTo `last`. Round will `first` arcTo `last`.
    final List<Offset> topLeftCoords = <Offset>[
      Offset(rrect.left, min(centerLeft.dy, rrect.top + tlRadiusY)),
      if (tlIsSquare) Offset(rrect.left, rrect.top),
      Offset(min(centerTop.dx, rrect.left + tlRadiusX), rrect.top),
    ];
    final List<Offset> topRightCoords = <Offset>[
      Offset(max(centerTop.dx, rrect.right - trRadiusX), rrect.top),
      if (trIsSquare) Offset(rrect.right, rrect.top),
      Offset(rrect.right, min(centerRight.dy, rrect.top + trRadiusY)),
    ];
    final List<Offset> bottomRightCoords = <Offset>[
      Offset(rrect.right, max(centerRight.dy, rrect.bottom - brRadiusY)),
      if (brIsSquare) Offset(rrect.right, rrect.bottom),
      Offset(max(centerBottom.dx, rrect.right - brRadiusX), rrect.bottom),
    ];
    final List<Offset> bottomLeftCoords = <Offset>[
      Offset(min(centerBottom.dx, rrect.left + blRadiusX), rrect.bottom),
      if (blIsSquare) Offset(rrect.left, rrect.bottom),
      Offset(rrect.left, max(centerLeft.dy, rrect.bottom - blRadiusY)),
    ];

    // ?: (no round Corners) => generate Polygon
    if (!cornerSpec.asSet.contains(Corner.ROUND) &&
        !cornerSpec.asSet.contains(Corner.NONE))
      return Path()
        ..addPolygon(
          topLeftCoords + topRightCoords + bottomRightCoords + bottomLeftCoords,
          false,
        );

    // !(no round Corners) => generate by driving Path
    var output = Path()..moveTo(centerLeft.dx, centerLeft.dy);

    if (cornerSpec.topLeft == Corner.NONE) {
      output.arcTo(rrect.outerRect, 1.0 * pi, 0.5 * pi, false);
    } else {
      output.lineTo(topLeftCoords.first.dx, topLeftCoords.first.dy);
      if (cornerSpec.topLeft == Corner.ROUND)
        output.arcToPoint(topLeftCoords.last, radius: radius.topLeft);
      else {
        if (tlIsSquare) output.lineTo(topLeftCoords[1].dx, topLeftCoords[1].dy);
        output.lineTo(topLeftCoords.last.dx, topLeftCoords.last.dy);
        output.lineTo(centerTop.dx, centerTop.dy);
      }
    }

    if (cornerSpec.topRight == Corner.NONE) {
      output.arcTo(rrect.outerRect, 1.5 * pi, 0.5 * pi, false);
    } else {
      output.lineTo(topRightCoords.first.dx, topRightCoords.first.dy);
      if (cornerSpec.topRight == Corner.ROUND)
        output.arcToPoint(topRightCoords.last, radius: radius.topRight);
      else {
        if (trIsSquare)
          output.lineTo(topRightCoords[1].dx, topRightCoords[1].dy);
        output.lineTo(topRightCoords.last.dx, topRightCoords.last.dy);
        output.lineTo(centerRight.dx, centerRight.dy);
      }
    }

    if (cornerSpec.bottomRight == Corner.NONE) {
      output.arcTo(rrect.outerRect, 0.0 * pi, 0.5 * pi, false);
    } else {
      output.lineTo(bottomRightCoords.first.dx, bottomRightCoords.first.dy);
      if (cornerSpec.bottomRight == Corner.ROUND)
        output.arcToPoint(bottomRightCoords.last, radius: radius.bottomRight);
      else {
        if (brIsSquare)
          output.lineTo(bottomRightCoords[1].dx, bottomRightCoords[1].dy);
        output.lineTo(bottomRightCoords.last.dx, bottomRightCoords.last.dy);
        output.lineTo(centerBottom.dx, centerBottom.dy);
      }
    }

    if (cornerSpec.bottomLeft == Corner.NONE) {
      output.arcTo(rrect.outerRect, 0.5 * pi, 0.5 * pi, false);
    } else {
      output.lineTo(bottomLeftCoords.first.dx, bottomLeftCoords.first.dy);
      if (cornerSpec.bottomLeft == Corner.ROUND)
        output.arcToPoint(bottomLeftCoords.last, radius: radius.bottomLeft);
      else {
        if (blIsSquare)
          output.lineTo(bottomLeftCoords[1].dx, bottomLeftCoords[1].dy);
        output.lineTo(bottomLeftCoords.last.dx, bottomLeftCoords.last.dy);
      }
    }
    output.close();

    return output;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<CornerSpec>('cornerSpec', cornerSpec));
    properties
        .add(DiagnosticsProperty<BorderRadiusGeometry>('radius', borderRadius));
  }
}

const _DEPRECATED = 'Manual shaping now available! See [CornerSpec.BIBEVEL_50]';
