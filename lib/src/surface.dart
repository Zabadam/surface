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
/// Use 🔘 [Surface.radius] and 📐 [CornerSpec] parameter
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
/// ### References
/// - 🌟 [Surface] - A shapeable, layered, animated container Widget
/// - 🔰 [Shape]
///   - 📐 [Corner] & 📐 [CornerSpec]
/// - 🔲 [Peek] - An Object with optional parameters to customize a Surface's "peek"
/// - 👆 [TapSpec] - An Object with optional parameters to customize a Surface's tap behavior
/// - 🔬 [Filter] - An Object with optional parameters to customize a 🌟 `Surface`'s 🤹‍♂️ filters/effects
///   - 🤹‍♂️ [SurfaceFX] - `Function typedef` for custom [Filter.effect]s!
///
/// ### 🏓 [BouncyBall] bundled with `package:ball`
/// A delightfully bouncy and position-mirroring reaction to user input on a piece of [Material].
///
/// Turn ink splashes for an [InkWell], [InkResponse] or material [Theme]
/// into 🏓 [BouncyBall]s or 🔮 `Glass` [BouncyBall]s
/// with the built-in [InteractiveInkFeatureFactory]s,
/// or design your own with 🪀 [BouncyBall.mold].
library surface;

import '../surface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show HapticFeedback;
import 'package:flutter/material.dart';

/// ### ❗ See ***CAUTION*** in [Surface] doc
/// Concerning 👓 [Filter.filteredLayers]
/// and 📊 [Filter.radiusMap] values.
///
/// Default 📊 `radius` passed to 💧 [FX.blurry].
/// # `4.0`
const _BLUR_MINIMUM = 0.0003;

/// Will be overridden when a 🌟 `Surface` is built.
var _fallbacks = <dynamic, Color>{
  SurfaceLayer.BASE: Colors.black.withOpacity(0.75),
  SurfaceLayer.MATERIAL: Colors.white.withOpacity(0.5),
  'HIGHLIGHT': Colors.white.withOpacity(0.5),
  'SPLASH': Colors.white,
};

//! ---
/// ### 🌟 [Surface]
/// A shapeable, layered, intrinsincally animated container Widget
/// offering convenient access to blurring ImageFilters, Material InkResponse,
/// and HapticFeedback.
///
/// Robustly customizable and, *watch out*, could also be expensive.
///
/// ---
///
/// ### ❗ ***CAUTION***
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
class Surface extends StatelessWidget {
  //! ---
  /// ### 🌟 [Surface]
  /// A shapeable, layered, intrinsincally animated container Widget
  /// offering convenient access to blurring ImageFilters, Material InkResponse,
  /// and HapticFeedback.
  ///
  /// Property 🔲 [Peek.peekAlignment] has hard-coded recognition
  /// of all nine [Alignment] geometries and will determine which side(s)
  /// receive a special border treatment according to
  /// property 🔲 [Peek.peekRatio].
  /// - defaults at `peekRatio: 2` which makes the 🔲 [Peek.peekAlignment] sides twice as thick, but
  /// - these borders made be made *thinner* than the others by passing `0 > peekRatio > 1`.
  ///
  /// Considering:
  /// 1. 📐 [CornerSpec] property [corners] and global 🔘 [radius];
  /// 2. 👆 [TapSpec] parameters `tappable`, `onTap`, `providesFeedback` & `inkHighlightColor`, `inkSplashColor`;
  /// 3. 🔛 [padLayer] initialized 📚 [SurfaceLayer.MATERIAL] for three effective container layers
  /// 4. 👓 [SurfaceFilter] passed as 👓 [filterStyle] and `Map<SurfaceLayer, double>` 📊 [radiusMap]
  /// 5. [duration] & [curve] properties for intrinsic property-change animations;
  ///
  /// A 🌟 [Surface] is robustly customizable and, *watch out*, could also be expensive.
  ///
  /// - **If 🌆 [gradient] or 🌆 [baseGradient] is initialized,**
  /// then respective 🎨 [color] or 🎨 [baseColor] parameter is ignored.
  ///
  /// > If not initialized, then default as follows:
  /// >   - 🎨 **[color]** - `Theme.of(context).colorScheme.surface.withOpacity(0.3)`
  /// >   - 🎨 **[baseColor]** - `Theme.of(context).colorScheme.primaryVariant.withOpacity(0.3)`
  ///
  /// - **If [corners] is passed 📐 [CornerSpec.SQUARED]** then 🔘 [radius] is ignored.
  /// - **If [corners] is passed 📐 [CornerSpec.BEVELED]** then `bool` 🔁 [flipBevels]
  ///   can mirror the cut corners horizontally. Ignored otherwise.
  ///
  /// - **Passing 🔲 [Peek.peekRatio] a value of `1`**
  ///   will negate any passed value to `peekAlignment`.
  /// - Similarly, **passing `peekRatio` in the range `0..1`**
  ///   will actually make the 🔲 [Peek.peekAlignment]
  ///   aligned side(s) *thinner* than the others.
  ///
  /// - By default **👆 [TapSpec.tappable] is true and
  ///   👆 [TapSpec.providesFeedback] is false**.
  ///   - The former includes an [InkResponse] that calls
  ///   👆 [TapSpec.onTap] and the latter enables [HapticFeedback].
  ///
  /// ---
  ///
  /// ### ❗ ***CAUTION***
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
  ///
  /// ------
  /// ------
  ///
  /// ### Simple Example
  /// ```dart
  /// // Surface with a border that's thicker on bottom & right, with rounded corners
  /// final surface = Surface(
  ///   radius: 10,
  ///   peek: const Peek(
  ///     peekAlignment: Alignment.bottomRight,
  ///     peekRatio: 20,
  ///   ),
  /// );
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
    this.shape = const Shape(),
    this.peek = const Peek(),
    this.tapSpec = const TapSpec(),
    this.filter = Filter.DEFAULT,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.easeIn,
    this.child,
    this.clipBehavior = Clip.hardEdge,
    Key? key,
  }) : super(key: key);

  /// The [width] and [height] follow rules of [AnimatedContainer],
  /// applying directly to the 📚 [SurfaceLayer.BASE].
  final double? width, height;

  /// [margin] applies to 📚 [SurfaceLayer.BASE] and the 🌟 Surface as a whole.
  /// - Consider [Filter.extendBaseFilter] which, if `true`,
  ///   has the BackdropFilter for 📚 [SurfaceLayer.BASE] extend to
  ///   cover the [Surface.margin] insets.
  ///
  /// [padding] is always ignored by the 📚 [SurfaceLayer.BASE],
  /// because its `padding` is determined by [Peek.peek].
  ///
  /// See 🔛 [Shape.padLayer], however, for options on how to distribute
  /// the [padding] between (default) [SurfaceLayer.CHILD] or [SurfaceLayer.MATERIAL].
  /// - Special case where `padLayer == SurfaceLayer.BASE` *splits* the padding
  ///   between 📚 `MATERIAL` and 📚 `CHILD` [SurfaceLayer]s.
  final EdgeInsets margin, padding;

  /// If 🎨 [color] or 🎨 [baseColor] is initialized, then initializing the
  /// respective `Gradient` parameter overrides the `Color` pass.
  ///
  /// If not initialized, then default as follows:
  /// - [color] - `Theme.of(context).colorScheme.surface.withOpacity(0.3)`
  /// - [baseColor] - `Theme.of(context).colorScheme.primaryVariant.withOpacity(0.3)`
  final Color? color, baseColor;

  /// If 🌆 [gradient] or 🌆 [baseGradient] is initialized,
  /// then respective `Color` parameter is ignored.
  final Gradient? gradient, baseGradient;

  /// ## WIP
  final Shape shape;

  /// Surface 🔲 [Peek.peek] is applied as insets to 📚 [SurfaceLayer.MATERIAL].
  /// - It may be considered to function like a border for the [child] content.
  ///   - Note that 🌟 [Surface] does not currently support actual [Border]s.
  ///   - To give a border to a 🌟 `Surface`,
  ///   provide one as a `child` to a [DecoratedBox] or [Container].
  ///
  /// According to 🔲 [Peek.peekAlignment], a side(s)
  /// is given special treatment and made:
  /// - thicker (default `peekRatio == 2.0`) or
  /// - thinner (`0 > peekRatio > 1`)
  ///
  /// Defaults [Alignment.center] such that no sides receive special treatment.
  final Peek peek;

  /// Not only does 👆 [TapSpec.tappable] provide `onTap` Callback,
  /// it also adds an [InkResponse] to the [Material] before rendering [child].
  ///
  /// 👆 [TapSpec.providesFeedback] is a convenience parameter
  /// to add a [HapticFeedback.vibrate] `onTap`.
  final TapSpec tapSpec;

  /// Provided a 🔬 [Filter] to alter
  /// filter appearance at all 📚 [SurfaceLayer]s.
  /// - `Set<SurfaceLayer>` 👓 [Filter.filteredLayers]
  ///   determines which 📚 Layers have filters
  /// - 📊 [Filter.radiusMap] determines filter strength
  ///   - Or [Filter.baseRadius] && `materialRadius` && `childRadius`
  /// - Use [Filter.extendBaseFilter] `== true` to have
  ///   📚 [SurfaceLayer.BASE]'s filter extend to cover
  ///   the [Surface.margin] insets.
  ///
  /// While a `new` 🌟 [Surface] employs 🔬 [Filter.DEFAULT],
  /// where [Filter.filteredLayers] is [Filter.NONE],
  /// a `new` 🔬 [Filter] defaults
  /// 👓 [Filter.filteredLayers] to [BASE].
  /// - Default blur radius/strength is [_BLUR] `== 4.0`.
  /// - Minimum accepted radius for an activated
  /// 📚 Layer is [_BLUR_MINIMUM] `== 0.0003`.
  /// * **❗ See CAUTION in [Surface] doc.**
  final Filter filter;

  /// The Duration that the internal [AnimatedContainer]s use for
  /// intrinsic property-change animations.
  final Duration duration;

  /// The Curve that the internal [AnimatedContainer]s use for
  /// intrinsic property-change animations.
  final Curve curve;

  /// The 👶 [child] Widget to render inside as the Surface content
  /// after considering all layout parameters.
  final Widget? child;

  /// Defaults to standard [Clip.hardEdge]. Must *not* be [Clip.none].
  final Clip clipBehavior;

  //! ---
  /// ## 👷‍♂️🌟 Build [Surface]
  @override
  Widget build(BuildContext context) {
    assert(
        ((filter.filteredLayers == Filter.TRILAYER)
                ? (filter.literalRadiusBase >= _BLUR_MINIMUM &&
                    filter.literalRadiusMaterial >= _BLUR_MINIMUM)
                : true) ||
            ((filter.filteredLayers == Filter.INNER_BILAYER)
                ? (filter.literalRadiusMaterial >= _BLUR_MINIMUM)
                : true) ||
            ((filter.filteredLayers == Filter.BASE_AND_CHILD)
                ? (filter.literalRadiusBase >= _BLUR_MINIMUM)
                : true) ||
            ((filter.filteredLayers == Filter.BASE_AND_MATERIAL)
                ? (filter.literalRadiusBase >= _BLUR_MINIMUM)
                : true),
        '[Surface] > Upper-layered filters will be negated if ancestor filters are enabled that have radius < 0.0003.\n'
        'Increase blur radius of lower layer(s) or pass a different [Filter.filteredLayers].');

    _fallbacks[SurfaceLayer.BASE] =
        Theme.of(context).colorScheme.primary.withBlack(100).withOpacity(0.75);
    _fallbacks[SurfaceLayer.MATERIAL] =
        Theme.of(context).colorScheme.surface.withOpacity(0.5);
    _fallbacks['HIGHLIGHT'] = Theme.of(context).highlightColor;
    _fallbacks['SPLASH'] = Theme.of(context).splashColor;

    final shapeBase = SurfaceShape(
      cornerSpec: shape.baseCornersOr,
      borderRadius: shape.baseCorners?.radius ?? shape.corners.radius * 1,
      border: shape.baseBorderOr ?? BorderSide.none,
    );
    final shapeMaterial = SurfaceShape(
      cornerSpec: shape.corners,
      borderRadius: shape.corners.radius,
      border: shape.border ?? BorderSide.none,
    ).scale(shape.materialScale);

    // ! ---
    // * 🌟🧅 [innerMaterial] == 📚 [SurfaceLayer.MATERIAL]
    // Material will be canvas for [child] and respond to touches.
    Widget innerMaterial = AnimatedContainer(
      duration: duration,
      curve: curve,
      decoration: _decorate(SurfaceLayer.MATERIAL, shapeMaterial),
      child: Material(
        color: Colors.transparent,
        child: _wrapChildWithInk(shapeMaterial),
      ),
    );

    // ! ---
    // * 🌟🐚 [baseContainer] == 📚 [SurfaceLayer.BASE]
    Widget baseContainer = AnimatedContainer(
      width: width,
      height: height,
      duration: duration,
      curve: curve,
      decoration: _decorate(SurfaceLayer.BASE, shapeBase),
      margin: filter.extendBaseFilter ? margin : const EdgeInsets.all(0),

      // 🔲 This "peek" is effectively the "border" of the Surface.
      // Values generated at start of build() using 🔲 Peek.
      padding: EdgeInsets.fromLTRB(
        peek.peekLeft,
        peek.peekTop,
        peek.peekRight,
        peek.peekBottom,
      ),

      /// 🌟🧅 `innerMaterial` as descendent of 🌟🐚 `baseContainer`
      child: _filter(
        SurfaceLayer.MATERIAL,
        shapeMaterial,
        child: innerMaterial,
      ),
    );

    // ! ---
    // * 📤🌟 Return [Surface]
    return AnimatedPadding(
      duration: duration,
      curve: curve,
      padding: (filter.extendBaseFilter) ? const EdgeInsets.all(0) : margin,
      child: _filter(SurfaceLayer.BASE, shapeBase, child: baseContainer),
    );
  }

  //! ---
  /// ## 👆 [_wrapChildWithInk]
  IgnorePointer _wrapChildWithInk(ShapeBorder? materialShape) {
    return IgnorePointer(
      ignoring: !tapSpec.tappable,
      child: InkResponse(
        canRequestFocus: true, // TODO Look into `focus`, accessibility, nav
        containedInkWell: true,
        customBorder: materialShape,
        highlightShape: BoxShape.rectangle,
        highlightColor: tapSpec.inkHighlightColor ?? _fallbacks['HIGHLIGHT'],
        splashColor: tapSpec.inkSplashColor ?? _fallbacks['SPLASH'],
        child: _buildChild(materialShape),
        onTap: () {
          if (tapSpec.providesFeedback) HapticFeedback.vibrate();
          tapSpec.onTap?.call();
        },
      ),
    );
  }

  /// ! ---
  /// ## 👷‍♂️: 👶 [_buildChild] with passed [child]
  /// Property 🔛 [padLayer] determines how [padding] is distributed.
  /// - Special case where `padLayer == SurfaceLayer.BASE` *splits* the padding
  ///   between 📚 `MATERIAL` and 📚 `CHILD` [SurfaceLayer]s.
  AnimatedPadding _buildChild(ShapeBorder? shapeMaterial) {
    /// Outer Padding applies to [_filter] (maybe).
    return AnimatedPadding(
      duration: duration,
      curve: curve,
      padding: (shape.padLayer == SurfaceLayer.MATERIAL)
          ? padding
          : (shape.padLayer == SurfaceLayer.BASE)
              ? padding / 2
              // padLayer == SurfaceLayer.CHILD, default
              : const EdgeInsets.all(0),
      child: _filter(
        SurfaceLayer.CHILD,
        shapeMaterial!.scale(shape.childScale / 2),
        // Inner Padding applies to [child] (maybe).
        child: AnimatedPadding(
          duration: duration,
          curve: curve,
          padding: (shape.padLayer == SurfaceLayer.CHILD) // default
              ? padding
              : (shape.padLayer == SurfaceLayer.BASE)
                  ? padding / 2
                  // padLayer == SurfaceLayer.SURFACE
                  : const EdgeInsets.all(0),
          child: child ?? const SizedBox(width: 0, height: 0), // 👶 [child]
        ),
      ),
    );
  }

  // ! ---
  /// ## 🌈 Decorate
  /// Returns [ShapeDecoration] given a [SurfaceLayer] and [SurfaceShape].
  Decoration _decorate(SurfaceLayer layer, ShapeBorder? shape) {
    final isGradient = (layer == SurfaceLayer.BASE)
        ? (baseGradient != null)
        : (gradient != null);

    final _color = (layer == SurfaceLayer.BASE)
        ? baseColor ?? _fallbacks[SurfaceLayer.BASE]
        : color ?? _fallbacks[SurfaceLayer.MATERIAL];

    return ShapeDecoration(
      shape: shape!,
      gradient: (isGradient)
          ? (layer == SurfaceLayer.BASE)
              ? baseGradient
              : gradient
          : LinearGradient(colors: [_color!, _color]),
    );
  }

  // ! ---
  /// ## 🤹‍♂️
  /// Returns [_clip]-ed [ImageFilter] with [Filter.effect].
  Widget _filter(SurfaceLayer layer, ShapeBorder? shape,
          {required Widget child}) =>
      _clip(
        shape,
        child: BackdropFilter(
          filter: filter.effect(
            (filter.filteredLayers.contains(layer))
                ? filter.radiusByLayer(layer)
                : 0.0,
            layer,
          ),
          child: child,
        ),
      );

  // ! ---
  /// ## ✂️
  Widget _clip(ShapeBorder? shape, {required Widget child}) => ClipPath.shape(
        clipBehavior: clipBehavior,
        shape: shape!,
        child: child,
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('width', width));
    properties.add(DoubleProperty('height', height));
    properties.add(ColorProperty('color', color));
    properties.add(ColorProperty('baseColor', baseColor));
    properties.add(DiagnosticsProperty<Gradient>('gradient', gradient));
    properties.add(DiagnosticsProperty<Gradient>('baseGradient', baseGradient));
    properties.add(DiagnosticsProperty<Shape>('shapeSpec', shape));
    properties.add(DiagnosticsProperty<Peek>('peek', peek));
    properties.add(DiagnosticsProperty<TapSpec>('tapSpec', tapSpec));
    properties.add(DiagnosticsProperty<Filter>('filterSpec', filter));
  }
}
