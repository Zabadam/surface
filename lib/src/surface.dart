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
/// A 🔲 [PeekSpec] may be provided to alter the Surface "peek"
/// (`MATERIAL` inset or "border") with parameter 🔲 [PeekSpec.peek].
/// - Give special treatment, generally a thicker appearance, to selected
///   side(s) by passing 🔲 [PeekSpec.peekAlignment]
///   and tuning with 🔲 [PeekSpec.peekRatio].
/// ---
///
/// Specify a 🔬 [SurfaceFilterSpec] with options
/// to render 🤹‍♂️ [SurfaceFX] backdrop [ImageFilter]s
/// - In configured 👓 [SurfaceFilterSpec.filteredLayers] `Set`
/// - Whose radii (🤹‍♂️ [effect] strength) are mapped with 📊 [SurfaceFilterSpec.radiusMap]
///   - A 📚 [SurfaceLayer.BASE] filter may be extended through the
///   [Surface.margin] with [SurfaceFilterSpec.extendBaseFilter]
/// ---
///
/// A 👆 [TapSpec] offers [TapSpec.onTap] `VoidCallback`,
/// [InkResponse] customization, and a [HapticFeedback] shortcut.
/// ---
///
/// 🔰 [SurfaceShape.biBeveledRectangle] is responsible for the
/// 📐 [SurfaceCorners.BIBEVEL] custom shape.
/// ---
///
/// ### References
/// - 🌟 [Surface] - A shapeable, layered, animated container Widget
/// - 🔲 [PeekSpec] - An Object with optional parameters to customize a Surface's "peek"
/// - 👆 [TapSpec] - An Object with optional parameters to customize a Surface's tap behavior
/// - 🔬 [FilterSpec] - An Object with optional parameters to customize a 🌟 `Surface`'s 🤹‍♂️ filters/effects
/// - 🔰 [SurfaceShape] - Handles the "biBevel" shape for 🌟 `Surface`, but could do more
/// - 🤹‍♂️ [SurfaceFX] - `Function typedef` for custom [FilterSpec.effect]s!
///
/// ### 🏓 [BouncyBall]
/// A delightfully bouncy and position-mirroring reaction to user input on a piece of [Material].
///
/// Turn ink splashes for an [InkWell], [InkResponse] or material [Theme]
/// into 🏓 [BouncyBall]s or 🔮 `Glass` [BouncyBall]s
/// with the built-in [InteractiveInkFeatureFactory]s,
/// or design your own with 🪀 [BouncyBall.mold].
library surface;

import '../surface.dart';

/// ### ❗ See ***CAUTION*** in [Surface] doc
/// Concerning 👓 [FilterSpec.filteredLayers]
/// and 📊 [FilterSpec.radiusMap] values.
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
/// 👓 [FilterSpec.filteredLayers] value for which you intend on
/// passing each relevant 💧 [FilterSpec.radiusMap] map parameter.
///   - Not only are the blurry [BackdropFilter]s expensive, but the
///   inheritance/ancestry behavior is strange.
///   - If all three filters are active via 👓 [FilterSpec.filteredLayers], passing
///   📊 `baseRadius: 0` eliminates the remaining children filters,
///   regardless of their passed 📊 `radius`.
///     - This behavior can be worked-around by setting any parent 📚 `Layer`'s
///     `radius` to just above `0`, specifically `radius > (_MINIMUM_BLUR == 0.0003)`
///     - `📚 BASE > 📚 MATERIAL > 📚 CHILD`
///     - But in this case a different 👓 [FilterSpec.filteredLayers] `Set`
///     should be passed anyway that only activates the correct 📚 `Layer`(s).
class Surface extends StatelessWidget {
  /// ## 🔘 Default Corner Radius: `3.0`
  static const _RADIUS = 3.0;

  //! ---
  /// ### 🌟 [Surface]
  /// A shapeable, layered, intrinsincally animated container Widget
  /// offering convenient access to blurring ImageFilters, Material InkResponse,
  /// and HapticFeedback.
  ///
  /// Property 🔲 [PeekSpec.peekAlignment] has hard-coded recognition
  /// of all nine [Alignment] geometries and will determine which side(s)
  /// receive a special border treatment according to
  /// property 🔲 [PeekSpec.peekRatio].
  /// - defaults at `peekRatio: 2` which makes the 🔲 [PeekSpec.peekAlignment] sides twice as thick, but
  /// - these borders made be made *thinner* than the others by passing `0 > peekRatio > 1`.
  ///
  /// Considering:
  /// 1. 📐 [SurfaceCorners] property [corners] and global 🔘 [radius];
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
  /// - **If [corners] is passed 📐 [SurfaceCorners.SQUARE]** then 🔘 [radius] is ignored.
  /// - **If [corners] is passed 📐 [SurfaceCorners.BIBEVEL]** then `bool` 🔁 [flipBevels]
  ///   can mirror the cut corners horizontally. Ignored otherwise.
  ///
  /// - **Passing 🔲 [PeekSpec.peekRatio] a value of `1`**
  ///   will negate any passed value to `peekAlignment`.
  /// - Similarly, **passing `peekRatio` in the range `0..1`**
  ///   will actually make the 🔲 [PeekSpec.peekAlignment]
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
  /// 👓 [FilterSpec.filteredLayers] value for which you intend on
  /// passing each relevant 💧 [FilterSpec.radiusMap] map parameter.
  ///   - Not only are the blurry [BackdropFilter]s expensive, but the
  ///   inheritance/ancestry behavior is strange.
  ///   - If all three filters are active via 👓 [FilterSpec.filteredLayers], passing
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
  ///   peekSpec: SurfacePeekSpec(
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
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.easeIn,
    this.corners = SurfaceCorners.ROUND,
    this.radius,
    this.baseRadius,
    this.peekSpec = const PeekSpec(),
    this.tapSpec = const TapSpec(),
    this.filterSpec = FilterSpec.DEFAULT_SPEC,
    this.padLayer = SurfaceLayer.CHILD,
    this.flipBevels = false,
    this.child,
    this.clipBehavior = Clip.hardEdge,
    Key? key,
  })  : assert((radius ?? 0) >= 0,
            '[Surface] > Please provide a non-negative [radius].'),
        super(key: key);

  /// The [width] and [height] follow rules of [AnimatedContainer],
  /// but apply to either the 📚 [SurfaceLayer.BASE] or,
  /// if `disableBase: true`, the 📚 [SurfaceLayer.MATERIAL] directly.
  final double? width, height;

  /// [margin] applies to 📚 [SurfaceLayer.BASE] and the 🌟 Surface as a whole.
  /// - Consider [FilterSpec.extendBaseFilter] which, if `true`,
  ///   has the BackdropFilter for 📚 [SurfaceLayer.BASE] extend to
  ///   cover the [Surface.margin] insets.
  ///
  /// [padding] is always ignored by the 📚 [SurfaceLayer.BASE],
  /// because its `padding` is determined by [peek].
  ///
  /// See 🔛 [padLayer], however, for options on how to distribute the [padding]
  /// between (default) [SurfaceLayer.CHILD] or perhaps [SurfaceLayer.MATERIAL].
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

  /// The Duration that the internal [AnimatedContainer]s use for
  /// intrinsic property-change animations.
  final Duration duration;

  /// The Curve that the internal [AnimatedContainer]s use for
  /// intrinsic property-change animations.
  final Curve curve;

  /// See 📐 [SurfaceCorners] for a small list of availabe shapes.
  /// Default is 📐 [SurfaceCorners.ROUND], but 📐 [SurfaceCorners.BIBEVEL] is fun.
  final SurfaceCorners corners;

  /// The 🔘 [radius] impacts the roundedness of default
  /// 📐 [SurfaceCorners.ROUND] or bevel-depth of 📐 [SurfaceCorners.BIBEVEL].
  ///
  /// If not provided, [radius] `=` [Surface._RADIUS] `== 3.0`.
  ///
  /// The 🔘 [baseRadius] may be specified separately,
  /// but is optional and will only impact the 📚 [SurfaceLayer.BASE].
  final double? radius, baseRadius;

  /// Surface 🔲 [PeekSpec.peek] is applied as insets to 📚 [SurfaceLayer.MATERIAL].
  /// - It may be considered to function like a border for the [child] content.
  ///   - Note that 🌟 [Surface] does not currently support actual [Border]s.
  ///   - To give a border to a 🌟 `Surface`,
  ///   provide one as a `child` to a [DecoratedBox] or [Container].
  ///
  /// According to 🔲 [PeekSpec.peekAlignment], a side(s)
  /// is given special treatment and made:
  /// - thicker (default `peekRatio == 2.0`) or
  /// - thinner (`0 > peekRatio > 1`)
  ///
  /// Defaults [Alignment.center] such that no sides receive special treatment.
  final PeekSpec peekSpec;

  /// Not only does 👆 [TapSpec.tappable] provide `onTap` Callback,
  /// it also adds an [InkResponse] to the [Material] before rendering [child].
  ///
  /// 👆 [TapSpec.providesFeedback] is a convenience parameter
  /// to add a [HapticFeedback.vibrate] `onTap`.
  final TapSpec tapSpec;

  /// Provided a 🔬 [FilterSpec] to alter
  /// filter appearance at all 📚 [SurfaceLayer]s.
  /// - `Set<SurfaceLayer>` 👓 [FilterSpec.filteredLayers]
  ///   determines which 📚 Layers have filters
  /// - 📊 [FilterSpec.radiusMap] determines filter strength
  ///   - Or [FilterSpec.baseRadius] && `materialRadius` && `childRadius`
  /// - Use [FilterSpec.extendBaseFilter] `== true` to have
  ///   📚 [SurfaceLayer.BASE]'s filter extend to cover
  ///   the [Surface.margin] insets.
  ///
  /// While a `new` 🌟 [Surface] employs 🔬 [FilterSpec.DEFAULT_SPEC],
  /// where [FilterSpec.filteredLayers] is [FilterSpec.NONE],
  /// a `new` 🔬 [FilterSpec] defaults
  /// 👓 [FilterSpec.filteredLayers] to [BASE].
  /// - Default blur radius/strength is [_BLUR] `== 4.0`.
  /// - Minimum accepted radius for an activated
  /// 📚 Layer is [_BLUR_MINIMUM] `== 0.0003`.
  /// * **❗ See CAUTION in [Surface] doc.**
  final FilterSpec filterSpec;

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
  /// - Consider 👓 [FilterSpec.filteredLayers] `=` 👓 [FilterSpec.TRILAYER].
  ///
  /// ### ❗ Special Case
  /// Specifying 📚 [SurfaceLayer.BASE] is a special case in which
  /// [Surface.padding] is then *split* between 📚 `MATERIAL` and 📚 `CHILD` layers.
  final SurfaceLayer padLayer;

  /// Only if [corners] `==` 📐 [SurfaceCorners.BIBEVEL] will 🔁 [flipBevels] then
  /// mirror the two beveled corners horizontally across x-axis; ignored otherwise.
  ///
  /// See 🔰 [SurfaceShape] which ultimately provides the
  /// [BeveledRectangleBorder] used throughout Surface.
  final bool flipBevels;

  /// The 👶 [child] Widget to render inside as the Surface content
  /// after considering all layout parameters.
  final Widget? child;

  /// Defaults to standard [Clip.hardEdge]. Must *not* be [Clip.none].
  final Clip clipBehavior;

  double _radiusByLayer([SurfaceLayer? layer]) {
    return (layer == SurfaceLayer.BASE)
        ? (baseRadius ?? radius ?? _RADIUS)
        : (radius ?? _RADIUS);
  }

  RoundedRectangleBorder _rRect(double radius) => RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(radius)));

  //! ---
  /// ## 👷‍♂️🌟 Build [Surface]
  @override
  Widget build(BuildContext context) {
    /// ❗ See *CAUTION* in Surface doc for more information on
    /// 👓 [filterStyle] and [SurfaceFilterSpec.filterRadius] values.
    assert(
        ((filterSpec.filteredLayers == FilterSpec.TRILAYER)
                ? (filterSpec.literalRadiusBase >= _BLUR_MINIMUM &&
                    filterSpec.literalRadiusMaterial >= _BLUR_MINIMUM)
                : true) ||
            ((filterSpec.filteredLayers == FilterSpec.INNER_BILAYER)
                ? (filterSpec.literalRadiusMaterial >= _BLUR_MINIMUM)
                : true) ||
            ((filterSpec.filteredLayers == FilterSpec.BASE_AND_CHILD)
                ? (filterSpec.literalRadiusBase >= _BLUR_MINIMUM)
                : true) ||
            ((filterSpec.filteredLayers == FilterSpec.BASE_AND_MATERIAL)
                ? (filterSpec.literalRadiusBase >= _BLUR_MINIMUM)
                : true),
        '[Surface] > Upper-layered filters will be negated if ancestor filters are enabled that have radius < 0.0003.\n'
        'Increase blur radius of lower layer(s) or pass a different [SurfaceFilterSpec.filteredLayers].');

    _fallbacks[SurfaceLayer.BASE] =
        Theme.of(context).colorScheme.primary.withBlack(100).withOpacity(0.75);
    _fallbacks[SurfaceLayer.MATERIAL] =
        Theme.of(context).colorScheme.surface.withOpacity(0.5);
    _fallbacks['HIGHLIGHT'] = Theme.of(context).highlightColor;
    _fallbacks['SPLASH'] = Theme.of(context).splashColor;

    // ! ---
    // * 🌟🧅 [innerMaterial] ==
    // * 📚 [SurfaceLayer.MATERIAL]
    Widget innerMaterial = AnimatedContainer(
      duration: duration,
      curve: curve,

      /// Build shape and color for 📚 [SurfaceLayer.MATERIAL]
      decoration: _decorate(SurfaceLayer.MATERIAL),

      /// Material will be canvas for [child] and respond to touches.
      child: Material(
        color: Colors.transparent,
        child: _buildInkResponse(),
      ),
    );

    // ! ---
    // * 🌟🐚 [baseContainer] ==
    // * 📚 [SurfaceLayer.BASE]
    Widget baseContainer = AnimatedContainer(
      // May be `null` anyway
      width: width,
      height: height,
      margin: filterSpec.extendBaseFilter ? margin : const EdgeInsets.all(0),
      duration: duration,
      curve: curve,

      /// 🔲 This "peek" is effectively the "border" of the Surface.
      // Values generated at start of build() using 🔲 [SurfacePeekSpec].
      padding: EdgeInsets.fromLTRB(
        peekSpec.peekLeft,
        peekSpec.peekTop,
        peekSpec.peekRight,
        peekSpec.peekBottom,
      ),

      /// Build shape and color for 📚 [SurfaceLayer.BASE]
      decoration: _decorate(SurfaceLayer.BASE),

      /// 🌟🧅 `innerMaterial` as descendent of 🌟🐚 `baseContainer`
      child: _filter(
        layer: SurfaceLayer.MATERIAL,
        child: innerMaterial,
      ),
    );

    // ! ---
    // * 📤🌟 Return [Surface]
    return AnimatedPadding(
      duration: duration,
      curve: curve,
      padding: (filterSpec.extendBaseFilter) ? const EdgeInsets.all(0) : margin,
      child: _filter(layer: SurfaceLayer.BASE, child: baseContainer),
    );
  }

  //! ---
  /// ## 👷‍♂️: 👆 [_buildInkResponse]
  Widget _buildInkResponse() {
    return IgnorePointer(
      ignoring: !tapSpec.tappable,
      child: InkResponse(
        /// Consult 👆 [SurfaceTapSpec]
        highlightColor: tapSpec.inkHighlightColor ?? _fallbacks['HIGHLIGHT'],
        splashColor: tapSpec.inkSplashColor ?? _fallbacks['SPLASH'],
        onTap: () {
          if (tapSpec.providesFeedback) HapticFeedback.vibrate();
          tapSpec.onTap?.call();
        },
        containedInkWell: true,
        canRequestFocus: true,
        highlightShape: BoxShape.rectangle,
        customBorder: (corners == SurfaceCorners.BIBEVEL)
            ? _buildBiBeveledShape(layer: SurfaceLayer.BASE)
            : RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    (corners == SurfaceCorners.SQUARE) ? 0 : _radiusByLayer()),
              ),

        /// 👶 [child]
        child: _buildChild(),
      ),
    );
  }

  /// ! ---
  /// ## 👷‍♂️: 👶 [_buildChild] with passed [child]
  /// Property 🔛 [padLayer] determines how [padding] is distributed.
  /// - Special case where `padLayer == SurfaceLayer.BASE` *splits* the padding
  ///   between 📚 `MATERIAL` and 📚 `CHILD` [SurfaceLayer]s.
  AnimatedPadding _buildChild() {
    /// [clipper] padding
    return AnimatedPadding(
      duration: duration,
      curve: curve,
      padding: (padLayer == SurfaceLayer.MATERIAL)
          ? padding
          : (padLayer == SurfaceLayer.BASE)
              ? padding / 2
              // padLayer == SurfaceLayer.CHILD
              : const EdgeInsets.all(0),
      child: AnimatedPadding(
        duration: duration,
        curve: curve,
        padding: (padLayer == SurfaceLayer.CHILD)
            ? padding
            : (padLayer == SurfaceLayer.BASE)
                ? padding / 2
                // padLayer == SurfaceLayer.SURFACE
                : const EdgeInsets.all(0),

        /// 👶 [child]
        child: _filter(
          layer: SurfaceLayer.CHILD,
          child: child ?? const SizedBox(width: 0, height: 0),
        ),
      ),
    );
  }

  /// ! ---
  /// ## 👷‍♂️: 🌈 [_decorate]
  Decoration _decorate(SurfaceLayer layer) {
    final isGradient = (layer == SurfaceLayer.BASE)
        ? (baseGradient != null)
        : (gradient != null);

    final _color = (layer == SurfaceLayer.BASE)
        ? isGradient
            ? null
            : baseColor ?? _fallbacks[SurfaceLayer.BASE]
        : isGradient
            ? null
            : color ?? _fallbacks[SurfaceLayer.MATERIAL];

    return Decoration.lerp(
      ShapeDecoration(
        gradient: (isGradient)
            ? (layer == SurfaceLayer.BASE)
                ? baseGradient
                : gradient
            : LinearGradient(colors: [_color!, _color]),
        shape: _buildBiBeveledShape(layer: layer),
      ),
      BoxDecoration(
        gradient: (isGradient)
            ? (layer == SurfaceLayer.BASE)
                ? baseGradient
                : gradient
            : LinearGradient(colors: [_color!, _color]),
        borderRadius: BorderRadius.all(
          Radius.circular(
            corners == SurfaceCorners.SQUARE ? 0 : _radiusByLayer(layer),
          ),
        ),
      ),
      (corners == SurfaceCorners.BIBEVEL) ? 0 : 1,
    )!;
  }

  /// ! ---
  /// 👷‍♂️: 🔰 [_buildBiBeveledShape]
  /// Customized 🔰 [SurfaceShape] so the 📚 [SurfaceLayer.MATERIAL]
  /// may have a deeper-cut beveled corner if
  /// the property [peekAlignment] is passed and corner-set.
  ///
  /// Certainly repass 🔁 [flipBevels].
  BeveledRectangleBorder _buildBiBeveledShape({required SurfaceLayer layer}) =>
      SurfaceShape.biBeveledRectangle(
        /// [SurfaceShape] could provide more functionality in the future.
        // radius: (radius) * (40 - peekSpec.peek - 2.3 * peekSpec.peek) / 40,
        radius: _radiusByLayer(layer),
        flip: flipBevels,

        /// A corner may indeed not be shrunken after all
        /// if [SurfacePeekSpec.peekAlignment] is not corner-set.
        ///
        /// (See: [_determineShrinkCornerAlignment] final `else`
        /// returns `Alignment.center` which 🔰 [BiBeveledShape] knows
        /// to ignore when shrinking a corner.)
        shrinkOneCorner: layer != SurfaceLayer.BASE,
        shrinkCornerAlignment: _shrinkCorner(),
      );

  /// ! ---
  /// ## 🔧: 🤹‍♂️ Shortcut [_filter]
  /// Returns [_clip]-ed [ImageFilter] with [TapSpec.effect]
  _filter({
    required SurfaceLayer layer,
    required Widget child,
  }) =>
      _clip(
        layer: layer,
        child: BackdropFilter(
          filter: filterSpec.effect(
            (filterSpec.filteredLayers.contains(layer))
                ? filterSpec.radiusByLayer(layer)
                : 0.0,
            layer,
          ),
          child: child,
        ),
      );

  /// ! ---
  /// ## 🔧: 🔪 Shortcut [_clip] for a [ClipPath]
  Widget _clip({
    required SurfaceLayer layer,
    required Widget child,
  }) =>
      ClipPath.shape(
        clipBehavior: clipBehavior,
        shape: (corners == SurfaceCorners.SQUARE ||
                _radiusByLayer(layer) == 0 ||
                filterSpec.radiusByLayer(layer) == 0)
            ? _rRect(0)
            : (corners == SurfaceCorners.BIBEVEL)
                ? _buildBiBeveledShape(layer: layer)
                : _rRect(
                    _radiusByLayer(layer),
                  ),
        child: child,
      );

  /// ! ---
  /// ## 🔰: 🧮 TODO: [_shrinkCorner]
  /// Shrink the corner diagonally-opposite the corner from where [peekAlignment]
  /// results in thicker border.
  ///
  /// Unless 🔁 [flipBevels] `== true` then, taking this finding, shrink now the
  /// horizontally-opposite corner.
  ///
  /// Only impacts a 🌟 [Surface] that has a corner-set 🔲 [PeekSpec.peekAlignment].
  /// (i.e. `peekAlignment = Alignment.bottomCenter` will shrink no corners)
  Alignment _shrinkCorner() => (peekSpec.peekAlignment == Alignment.topRight)
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
