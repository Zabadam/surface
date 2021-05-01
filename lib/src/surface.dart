/// ## 🌟 Surface
/// A shapeable, layered, intrinsincally animated container Widget
/// offering convenient access to blurring `ImageFilter`s,
/// `Material` `InkResponse`, and `HapticFeedback`.
library surface;

import 'package:flutter/services.dart' show HapticFeedback;
import 'package:flutter/foundation.dart'
    show DiagnosticPropertiesBuilder, DiagnosticsProperty, DoubleProperty, Key;
import 'package:flutter/material.dart';

import 'package:ball/ball.dart';
import 'shape.dart';
import 'effect.dart';
import 'goodies.dart';

/// ### ❗ See ***Consideration*** in library `surface.dart`
/// Regarding 👓 [Filter.filteredLayers] and 📊 [Filter.radiusMap] values.
///
/// Default 📊 `radius` passed to 💧 [FX.blurry]
/// is `4.0` & minimum is `0.0003`.
const _BLUR_MINIMUM = 0.0003;

/// Color fallbacks. Will be overridden when a 🌟 `Surface` is built.
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
/// ### ❗ See ***Consideration*** in library `surface.dart`
/// Regarding 👓 [Filter.filteredLayers] and 📊 [Filter.radiusMap] values.
class Surface extends StatelessWidget {
  //! ---
  /// ### 🌟 [Surface]
  /// A shapeable, layered, intrinsincally animated container Widget
  /// offering convenient access to blurring ImageFilters, Material InkResponse,
  /// and HapticFeedback.
  ///
  /// Property 🔲 [Peek.alignment] has hard-coded recognition
  /// of all nine [Alignment] geometries and will determine which side(s)
  /// receive a special border treatment according to
  /// property 🔲 [Peek.ratio].
  /// - defaults at `ratio: 2` which makes the 🔲 [Peek.alignment] sides twice as thick, but
  /// - these borders made be made *thinner* than the others by passing `0 > ratio > 1`.
  ///
  /// Considering:
  /// 1. 🔰 [Shape] by 📐 [CornerSpec]
  /// 2. 👆 [TapSpec]
  /// 3. 🔛 [padLayer] initialized 📚 [SurfaceLayer.MATERIAL] for three effective container layers
  /// 4. 👓 [Filter] passed as 👓 [filterStyle] and `Map<SurfaceLayer, double>` 📊 [radiusMap]
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
  /// - **Passing 🔲 [Peek.ratio] a value of `1`**
  ///   will negate any passed value to `alignment`.
  /// - Similarly, **passing `ratio` in the range `0..1`**
  ///   will actually make the 🔲 [Peek.alignment]
  ///   aligned side(s) *thinner* than the others.
  ///
  /// - By default **👆 [TapSpec.tappable] is true and
  ///   👆 [TapSpec.providesFeedback] is false**.
  ///   - The former includes an [InkResponse] that calls
  ///   👆 [TapSpec.onTap] and the latter enables [HapticFeedback].
  ///
  /// ---
  ///
  /// ### ❗ See ***Consideration*** in library `surface.dart`
  /// Regarding 👓 [Filter.filteredLayers] and 📊 [Filter.radiusMap] values.
  ///
  /// ------
  ///
  /// ### ❓ Example
  /// ```dart
  /// // Surface with a BASE that exposed more on bottom & right, (child set upper-left)
  /// // with rounded corners and Theme fallback colors; is tappable with InkResponse
  /// // (also Theme colors) but no vibration & `BouncyBall` splashFactory
  /// final surface = Surface(
  ///   peek: const Peek(
  ///     alignment: Alignment.bottomRight,
  ///     ratio: 20,
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
    this.peek = Peek.DEFAULT,
    this.tapSpec = const TapSpec(),
    this.filter = Filter.DEFAULT,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.easeIn,
    this.child,
    this.clipBehavior = Clip.hardEdge,
    Key? key,
  }) : super(key: key);

  /// The [width] and [height] for this 🌟 `Surface`, following the rules
  /// of [AnimatedContainer] & applying directly to the 📚 [SurfaceLayer.BASE].
  final double? width, height;

  /// [margin] applies to 📚 [SurfaceLayer.BASE] and the 🌟 `Surface` as a whole.
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

  /// The 🎨 `Color` to use for this 🌟 `Surface`.
  ///
  /// If [color] or [baseColor] is initialized, then initializing the
  /// respective `Gradient` parameter overrides the `Color` pass.
  ///
  /// If not initialized, then default as follows:
  /// - [color] - `Theme.of(context).colorScheme.surface.withOpacity(0.3)`
  /// - [baseColor] - `Theme.of(context).colorScheme.primaryVariant.withOpacity(0.3)`
  final Color? color, baseColor;

  /// The 🌆 `Gradient` to use for this 🌟 `Surface`.
  ///
  /// If [gradient] or [baseGradient] is initialized,
  /// then respective `Color` parameter is ignored.
  final Gradient? gradient, baseGradient;

  /// 📐 [CornerSpec] `Shape` description
  /// - Use [corners] to customize all four corners
  /// in a [Shape] and their 🔘 [radius].
  /// - Specify [baseCorners] separately if desired.
  /// - **`const` `CornerSpec`s with pre-set configurations available:**
  ///   - [CornerSpec.CIRCLE], [CornerSpec.SQUARED], [CornerSpec.ROUNDED], [CornerSpec.BEVELED]
  ///
  /// ➖ `BorderSide` [border]s
  /// - Add a [BorderSide] decoration to the edges of this [Shape].
  /// - Specify [baseBorder] separately if desired.
  ///
  /// 🔘 `Corner` `BorderRadius` [radius]
  /// - Defers to any [Shape.corners] or [Shape.baseCorners]
  /// supplied 🔘 [CornerSpec.radius], if available.
  ///
  /// 🔛 `SurfaceLayer` [padLayer]
  /// - Specify a 📚 [SurfaceLayer] to receive [Surface.padding] value.
  /// - Default is 📚 `SurfaceLayer.CHILD`
  ///
  /// 📏 `Shape` scaling
  /// - See `double`s [shapeScaleChild], [shapeScaleMaterial], [shapeScaleBase]
  final Shape shape;

  /// Consider `Peek` to be a description of how the 📚 `BASE`
  /// is exposed behind the 📚 `MATERIAL`.
  ///
  /// 🔲 [Peek.peek] is applied as insets to 📚 [SurfaceLayer.MATERIAL].
  ///
  /// It may be thought to function like a border for the [child] content, but
  /// - Note: to give this 🌟 `Surface` a true [BorderSide], see 🔰 [Shape.border].
  ///
  /// ---
  /// Selected by 🔲 [Peek.alignment], a side(s) is given special treatment:
  /// - thicker (default [Peek.ratio] `== 2.0`) or
  /// - thinner (`0 >` [Peek.ratio] `> 1.0`)
  ///
  /// Defaults [Alignment.center] such that no side(s) receive(s)
  /// special treatment regardless of 🔲 [Peek.peek] / [Peek.ratio].
  final Peek peek;

  /// Not only does 👆 [TapSpec.tappable] provide `onTap` Callback functionality,
  /// it also adds [InkResponse] to the [Material] underneath [child].
  ///
  /// 👆 [TapSpec.providesFeedback] is a convenience parameter
  /// to add a [HapticFeedback.vibrate] `onTap`.
  ///
  /// Ink splash `Color`s may be customized with a 👆 [TapSpec].
  ///
  /// ---
  /// 🌟 `Surface` comes bundled with [🏓 `package:ball`](https://pub.dev/packages/ball 'pub.dev: ball').
  ///
  /// Disable the default [BouncyBall.splashFactory] with
  /// 👆 [TapSpec.useThemeSplashFactory] or select an [InteractiveInkFeatureFactory]
  /// specific to this 🌟 `Surface` with 👆 [TapSpec.splashFactory].
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

  // ! ---
  /// ## ✂️ Clip
  Widget _clip(ShapeBorder? shape, {required Widget child}) => ClipPath.shape(
        clipBehavior: clipBehavior,
        shape: shape!,
        child: child,
      );

  // ! ---
  /// ## 🤹‍♂️ Filter
  /// Returns [_clip]-ed [ImageFilter] with [Filter.effect].
  Widget _filter(SurfaceLayer layer, ShapeBorder? shape,
          {required Widget child}) =>
      _clip(
        shape,
        child: BackdropFilter(
          filter: filter.effect(
            (filter.filteredLayers.contains(layer))
                ? filter.radiusByLayer(layer)
                : 0.0, // Ignore all radius values if 📚 layer is not enabled
            layer,
          ),
          child: child,
        ),
      );

  // ! ---
  /// ## 🌈 Decorate
  /// Returns [ShapeDecoration] given a [SurfaceLayer] and [SurfaceShape].
  Decoration _decorate(SurfaceLayer layer, ShapeBorder shape) {
    final isGradient = (layer == SurfaceLayer.BASE)
        ? (baseGradient != null)
        : (gradient != null);

    // _fallbacks starts with colors every time.
    final Color _color = (layer == SurfaceLayer.BASE)
        ? baseColor ?? _fallbacks[SurfaceLayer.BASE]!
        : color ?? _fallbacks[SurfaceLayer.MATERIAL]!;

    return ShapeDecoration(
      shape: shape,
      gradient: (isGradient)
          ? (layer == SurfaceLayer.BASE)
              ? baseGradient
              : gradient
          : LinearGradient(colors: [_color, _color]),
    );
  }

  // ! ---
  /// ## 👶 Build Child
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
        shapeMaterial!.scale(shape.shapeScaleChild),
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
          child: child ?? const SizedBox(width: 0, height: 0),
        ),
      ),
    );
  }

  //! ---
  /// ## 👆 Wrap Child
  /// Clearly the [SurfaceLayer.CHILD], `_wrapChild` takes no 📚 `Layer`.
  InkResponse _wrapChild(
    ShapeBorder? materialShape, {
    required InteractiveInkFeatureFactory splashFactory,
  }) {
    return InkResponse(
      canRequestFocus:
          tapSpec.tappable, // TODO Look into `focus`, accessibility, nav
      containedInkWell: true,
      customBorder: materialShape,
      highlightShape: BoxShape.rectangle,
      highlightColor: tapSpec.tappable
          ? tapSpec.inkHighlightColor ?? _fallbacks['HIGHLIGHT']
          : Colors.transparent,
      splashColor: tapSpec.tappable
          ? tapSpec.inkSplashColor ?? _fallbacks['SPLASH']
          : Colors.transparent,
      splashFactory: splashFactory,
      child: _buildChild(materialShape),
      onTap: (tapSpec.tappable)
          ? () {
              if (tapSpec.providesFeedback) HapticFeedback.vibrate();
              tapSpec.onTap?.call();
            }
          : null,
    );
  }

  //! ---
  /// ## 👷‍♂️🌟 Build [Surface]
  @override
  Widget build(BuildContext context) {
    assert(
        ((filter.filteredLayers == Filter.TRILAYER)
                ? (filter.renderedRadiusBase >= _BLUR_MINIMUM &&
                    filter.renderedRadiusMaterial >= _BLUR_MINIMUM)
                : true) ||
            ((filter.filteredLayers == Filter.INNER_BILAYER)
                ? (filter.renderedRadiusMaterial >= _BLUR_MINIMUM)
                : true) ||
            ((filter.filteredLayers == Filter.BASE_AND_CHILD)
                ? (filter.renderedRadiusBase >= _BLUR_MINIMUM)
                : true) ||
            ((filter.filteredLayers == Filter.BASE_AND_MATERIAL)
                ? (filter.renderedRadiusBase >= _BLUR_MINIMUM)
                : true),
        '[Surface] > Upper-layered filters will be negated if ancestor filters are enabled that have radius < 0.0003.\n'
        'Increase blur radius of lower layer(s) or pass a different [Filter.filteredLayers].');

    _fallbacks[SurfaceLayer.BASE] =
        Theme.of(context).colorScheme.primary.withBlack(100).withOpacity(0.75);
    _fallbacks[SurfaceLayer.MATERIAL] =
        Theme.of(context).colorScheme.surface.withOpacity(0.5);
    _fallbacks['HIGHLIGHT'] = Theme.of(context).highlightColor;
    _fallbacks['SPLASH'] = Theme.of(context).splashColor;

    final InteractiveInkFeatureFactory _splashFactory =
        tapSpec.useThemeSplashFactory
            ? Theme.of(context).splashFactory
            : tapSpec.splashFactory ?? BouncyBall.splashFactory;

    final SurfaceShape shapeBase = SurfaceShape(
      cornerSpec: shape.baseCornersOr,
      borderRadius: shape.radius,
      border: shape.baseBorderOr ?? BorderSide.none,
    ).scale(shape.shapeScaleBase);

    final SurfaceShape shapeMaterial = SurfaceShape(
      cornerSpec: shape.corners,
      borderRadius: shape.radius,
      border: shape.border ?? BorderSide.none,
    ).scale(shape.shapeScaleMaterial);

    // ! ---
    // * 🌟🧅 [innerMaterial] == 📚 [SurfaceLayer.MATERIAL]
    // Material will be canvas for [child] and respond to touches.
    final AnimatedContainer innerMaterial = AnimatedContainer(
      duration: duration,
      curve: curve,
      decoration: _decorate(SurfaceLayer.MATERIAL, shapeMaterial),
      child: Material(
        color: Colors.transparent,
        child: _wrapChild(shapeMaterial, splashFactory: _splashFactory),
      ),
    );

    // ! ---
    // * 🌟🐚 [baseContainer] == 📚 [SurfaceLayer.BASE]
    final AnimatedContainer baseContainer = AnimatedContainer(
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
