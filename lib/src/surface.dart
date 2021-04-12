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
/// A 🔲 [SurfacePeekSpec] may be provided to alter the Surface "peek"
/// (`MATERIAL` inset or "border") with parameter 🔲 [SurfacePeekSpec.peek].
/// - Give special treatment, generally a thicker appearance, to selected
///   side(s) by passing 🔲 [SurfacePeekSpec.peekAlignment]
///   and tuning with 🔲 [SurfacePeekSpec.peekRatio].
/// ---
///
/// Specify a 🔬 [SurfaceFilterSpec] with options
/// to render 💧 [Blur.ry] backdrop [ImageFilter]s
/// - In configured 👓 [SurfaceFilterSpec.filteredLayers] `Set`
/// - Whose radii (blur strength) are mapped with 💧 [SurfaceFilterSpec.radiusMap]
///   - A 📚 [SurfaceLayer.BASE] filter may be extended through the
///   [Surface.margin] with [SurfaceFilterSpec.extendBaseFilter]
/// ---
///
/// A 👆 [SurfaceTapSpec] offers [SurfaceTapSpec.onTap] `VoidCallback`,
/// [InkResponse] customization, and a [HapticFeedback] shortcut.
/// ---
///
/// 🔰 [SurfaceShape.biBeveledRectangle] is responsible for the
/// 📐 [SurfaceCorners.BEVEL] custom shape.
/// ---
///
/// ### References
/// - 🌟 [Surface] - A shapeable, layered, animated container Widget
/// - 🔲 [SurfacePeekSpec] - An Object with optional parameters to customize a Surface's "peek"
/// - 👆 [SurfaceTapSpec] - An Object with optional parameters to customize a Surface's tap behavior
/// - 🔬 [SurfaceFilterSpec] - An Object with optional parameters to customize a Surface's blurring filters
///
/// - Consider 🏓 [CustomInk] - A delightfully bouncy and position-mirroring reaction to user input on a piece of [Material].
library surface;

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// ### ❗ See ***CAUTION*** in [Surface] doc
/// Concerning 👓 [SurfaceFilterSpec.filteredLayers] and 💧 [SurfaceFilterSpec.radiusMap] values.
///
/// Default 👓 [radiusMap] passed to 💧 [Blur.ry]
/// # 4.0
const _BLUR = 4.0;

/// ### ❗ See ***CAUTION*** in [Surface] doc
/// Concerning 👓 [SurfaceFilterSpec.filteredLayers] and 💧 [SurfaceFilterSpec.radiusMap] values.
///
/// Minimum 👓 [radiusMap] passed to 💧 [Blur.ry]
/// # 0.0003
const _BLUR_MINIMUM = 0.0003;

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
  /// This is default, and the default radius is 🔘 [Surface._RADIUS] `== 3.0`.
  ROUND,

  /// ### 📐 Beveled Surface Corners
  /// Only *two* diagonally-opposite corners will be beveled
  /// by 🔘 [Surface.radius], while the other two remain square.
  ///
  /// Mirror the shape with `bool` parameter 🔁 [Surface.flipBevels].
  BEVEL
}

/// ---
/// ### 🔲 [SurfacePeekSpec]
/// [Surface] may be provided a 🔲 [SurfacePeekSpec] to define several attributes about
/// the shared space at the adjacent edge of 📚 [SurfaceLayer.BASE] and 📚 [SurfaceLayer.MATERIAL].
class SurfacePeekSpec {
  /// ### 🔲 [SurfacePeekSpec]
  /// A 🌟 [Surface] may be provided a 🔲 [SurfacePeekSpec] to define several attributes about
  /// the shared space at the adjacent edge of 📚 [SurfaceLayer.BASE] and 📚 [SurfaceLayer.MATERIAL].
  /// - It may be considered to function like a border for the [Surface.child] content.
  ///   - Note that [Surface] does not currently support actual [Border]s.
  ///   - To give a border to a Surface, provide a Surface as a `child` to a [DecoratedBox] or [Container].
  const SurfacePeekSpec({
    this.peek = 3.0,
    this.peekRatio = 2.0,
    this.peekAlignment = Alignment.center,
  }) : assert(peek >= 0,
            '[SurfacePeekSpec] > Please provide a non-negative [peek].');

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
  double get _peekLeft => (peekAlignment == Alignment.topLeft ||
          peekAlignment == Alignment.centerLeft ||
          peekAlignment == Alignment.bottomLeft)
      ? peek * peekRatio
      : peek;
  double get _peekTop => (peekAlignment == Alignment.topLeft ||
          peekAlignment == Alignment.topCenter ||
          peekAlignment == Alignment.topRight)
      ? peek * peekRatio
      : peek;
  double get _peekRight => (peekAlignment == Alignment.topRight ||
          peekAlignment == Alignment.centerRight ||
          peekAlignment == Alignment.bottomRight)
      ? peek * peekRatio
      : peek;
  double get _peekBottom => (peekAlignment == Alignment.bottomLeft ||
          peekAlignment == Alignment.bottomCenter ||
          peekAlignment == Alignment.bottomRight)
      ? peek * peekRatio
      : peek;
}

/// ---
/// ### 🔬 [SurfaceFilterSpec]
/// A 🌟 [Surface] may be provided a 🔬 [SurfaceFilterSpec] to alter
/// filter appearance at all 📚 [SurfaceLayer]s.
class SurfaceFilterSpec {
  /// A new 🌟 [Surface] defaults 🔬 [Surface.filterSpec] to this [DEFAULT_SPEC].
  /// ```
  /// - filteredLayers: SurfaceFilterSpec.NONE // <SurfaceLayer>{}
  /// - radiusMap: <SurfaceLayer, double>{}
  /// ```
  static const DEFAULT_SPEC = SurfaceFilterSpec(
    filteredLayers: NONE,
    radiusMap: <SurfaceLayer, double>{},
  );

  /// #### 👓 None
  /// No 💧 [Blur.ry] filters.
  static const NONE = <SurfaceLayer>{};

  /// #### 👓 Trilayer
  /// 3x 💧 [Blur.ry] filters, one at each layer of build:
  /// - under 📚 [SurfaceLayer.BASE]
  /// - under 📚 [SurfaceLayer.MATERIAL]
  /// - under 📚 [SurfaceLayer.CHILD]
  static const TRILAYER = <SurfaceLayer>{
    SurfaceLayer.BASE,
    SurfaceLayer.MATERIAL,
    SurfaceLayer.CHILD,
  };

  /// #### 👓 Inner Bilayer
  /// 2x 💧 [Blur.ry] filters:
  /// - under 📚 [SurfaceLayer.MATERIAL]
  /// - under 📚 [SurfaceLayer.CHILD]
  ///
  /// Absent under 📚 [SurfaceLayer.BASE], which will receive no blur.
  ///
  /// Furthermore, the blur under the 📚 Child may appear doubled
  /// unless the 🔛 [Surface.padLayer] `!=` 📚 [SurfaceLayer.CHILD] and
  /// [Surface.padding] is non-negligible.
  static const INNER_BILAYER = <SurfaceLayer>{
    SurfaceLayer.MATERIAL,
    SurfaceLayer.CHILD,
  };

  /// #### 👓 Base & Child
  /// 2x 💧 [Blur.ry] filters:
  /// - under 📚 [SurfaceLayer.BASE]
  /// - under 📚 [SurfaceLayer.CHILD]
  ///
  /// Absent under 📚 [SurfaceLayer.MATERIAL], which will receive no blur.
  ///
  /// Functionality may match 👓 [BASE_AND_MATERIAL] when
  /// 🔛 [Surface.padLayer] `==` 📚 [SurfaceLayer.CHILD] (default behavior).
  static const BASE_AND_CHILD = <SurfaceLayer>{
    SurfaceLayer.BASE,
    SurfaceLayer.CHILD,
  };

  /// #### 👓 Base & Material
  /// 2x 💧 [Blur.ry] filters:
  /// - under 📚 [SurfaceLayer.BASE]
  /// - under 📚 [SurfaceLayer.MATERIAL]
  ///
  /// Absent under 📚 [SurfaceLayer.CHILD], which will receive no blur.
  ///
  /// Functionality may match 👓 [BASE_AND_CHILD] when
  /// 🔛 [Surface.padLayer] `==` 📚 [SurfaceLayer.CHILD] (default behavior).
  static const BASE_AND_MATERIAL = <SurfaceLayer>{
    SurfaceLayer.BASE,
    SurfaceLayer.MATERIAL,
  };

  /// #### 👓 Base
  /// 1x 💧 [Blur.ry] filter:
  /// - under 📚 [SurfaceLayer.BASE]
  /// And the entire 🌟 [Surface] as a result.
  static const BASE = <SurfaceLayer>{SurfaceLayer.BASE};

  /// #### 👓 Material
  /// 1x 💧 [Blur.ry] filter:
  /// - under 📚 [SurfaceLayer.MATERIAL]
  /// After any inset from the 🔲 [SurfacePeekSpec.peek].
  static const MATERIAL = <SurfaceLayer>{SurfaceLayer.MATERIAL};

  /// #### 👓 Child
  /// 1x 💧 [Blur.ry] filter
  /// - under 📚 [SurfaceLayer.BASE], after any inset from [Surface.padding]
  static const CHILD = <SurfaceLayer>{SurfaceLayer.CHILD};

  /// ### 🔬 [SurfaceFilterSpec]
  /// A 🌟 [Surface] may be provided a 🔬 [SurfaceFilterSpec]
  /// to change filter appearance at all 📚 [SurfaceLayer]s.
  /// - `Set<SurfaceLayer>` 👓 [filteredLayers] determines which 📚 Layers have filters
  /// - 💧 [radiusMap] or [baseRadius] && [materialRadius] && [childRadius]
  ///   determine filter strength
  /// - Use [extendBaseFilter] `== true` to have 📚 [SurfaceLayer.BASE]'s
  ///   filter extend to cover the [Surface.margin] insets.
  ///
  /// While a `new` 🌟 [Surface] employs 🔬 [DEFAULT_SPEC],
  /// where [filteredLayers] is [NONE], a `new` 🔬 [SurfaceFilterSpec]
  /// defaults 👓 [filteredLayers] to [BASE].
  /// - Default blur radius/strength is [_BLUR] `== 4.0`.
  /// - Minimum accepted radius for an activated
  /// 📚 Layer is [_BLUR_MINIMUM] `== 0.0003`.
  /// * **❗ See CAUTION in [Surface] doc.**
  const SurfaceFilterSpec({
    this.filteredLayers = BASE,
    this.radiusMap,
    this.baseRadius,
    this.materialRadius,
    this.childRadius,
    this.extendBaseFilter = false,
  });

  /// Provide a `Set{}` to 👓 [filteredLayers] to specify which
  /// 📚 [SurfaceLayer]s will have a [BackdropFilter] enabled.
  ///
  /// Strength of the [Blur.ry] effect is mapped
  /// to each 📚 [SurfaceLayer] by 💧 [radiusMap].
  final Set<SurfaceLayer> filteredLayers;

  /// 💧 [radiusMap] `Map`s one or more 📚 [SurfaceLayer]s to a `double`
  /// that determines the 💧 [Blur.ry] `radius` for that layer's [BackdropFilter].
  ///
  /// All three fields default to [_BLUR_MINIMUM] `== 0.0003` so that
  /// upper-layered filters are not erased by an ancestor filter having 0 radius.
  ///
  /// - If 👓 [filteredLayers] is set to enable all three
  ///   📚 [SurfaceLayer] filters, initialize all three
  ///   💧 [radiusMap] doubles `>= 0.01`.
  /// - Similarly, if only two filters are enabled, the lower-Z filter
  ///   (lowest-Z value: [SurfaceLayer.BASE]) must be above zero to not negate
  ///   any value passed to the higher-Z filter (highest-Z value: [SurfaceLayer.CHILD]).
  ///
  /// ### ❗ See ***CAUTION*** in [Surface] doc for more.
  final Map<SurfaceLayer, double>? radiusMap;

  /// Instead of initializing a 💧 [radiusMap], opt to
  /// pass a specific layer's 💧 [Blur.ry] radius with this property.
  final double? baseRadius, materialRadius, childRadius;

  /// If [extendBaseFilter] is `true`, the BackdropFilter for 📚 [SurfaceLayer.BASE]
  /// will extend to cover the [Surface.margin] padding.
  final bool extendBaseFilter;

  /// Check if 💧 [radiusMap] has a value for this 📚 [layer] and return if so;
  /// if not, then check if this 📚 [layer] was initialized a specific `double`
  /// (such as 💧 [baseRadius]) and return if so;
  /// finally, if all else fails, return const [_BLUR]
  _filterRadiusByLayer(SurfaceLayer layer) {
    switch (layer) {
      case SurfaceLayer.BASE:
        return _baseRadius;
      case SurfaceLayer.MATERIAL:
        return _materialRadius;
      case SurfaceLayer.CHILD:
        return _childRadius;
    }
  }

  double get _baseRadius => radiusMap?.containsKey(SurfaceLayer.BASE) ?? false
      ? radiusMap![SurfaceLayer.BASE]!
      : (baseRadius != null)
          ? baseRadius!
          : _BLUR;
  double get _materialRadius =>
      radiusMap?.containsKey(SurfaceLayer.MATERIAL) ?? false
          ? radiusMap![SurfaceLayer.MATERIAL]!
          : (materialRadius != null)
              ? materialRadius!
              : _BLUR;

  double get _childRadius => radiusMap?.containsKey(SurfaceLayer.CHILD) ?? false
      ? radiusMap![SurfaceLayer.CHILD]!
      : (childRadius != null)
          ? childRadius!
          : _BLUR;
}

/// ---
/// ### 👆 [SurfaceTapSpec]
/// A 🌟 [Surface] may be provided a 👆 [SurfaceTapSpec] to define
/// its "tappability" and appearance & behavior therein, if enabled.
class SurfaceTapSpec {
  /// ### 👆 [SurfaceTapSpec]
  /// Not only does [tappable] provide [Surface.onTap] Callback,
  /// it also adds an [InkResponse] to the [Material] before rendering [child].
  ///
  /// [providesFeedback] is a convenience parameter
  /// to add a [HapticFeedback.vibrate] `onTap`.
  ///
  /// If [tappable] `== true` the [InkResponse] appearance may be customized.
  /// Otherwise no InkResponse is rendered with the Surface.
  const SurfaceTapSpec({
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

/// ---
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
/// Only pass 👓 [SurfaceFilterSpec.filteredLayers] parameter for which you intend on
/// passing each relevant 💧 [SurfaceFilterSpec.radiusMap] map parameter.
///   - Not only are the blurry [BackdropFilter]s expensive, but the
///   inheritance/ancestry behavior is strange.
///   - If all three filters are active via 👓 [SurfaceFilterSpec.filteredLayers], passing
///   `baseRadius: 0` eliminates the remaining children filters,
///   regardless of their passed `radius`.
///   - This behavior can be worked-around by setting any parent filter value
///   (`BASE > MATERIAL > CHILD`) to just above 0, specifically `> (_MINIMUM_BLUR == 0.0003)`,
///   but in this case a different 👓 [SurfaceFilterSpec.filteredLayers] `Set`
///   should be passed anyway that only employs the one or two appropriate filter(s).
class Surface extends StatelessWidget {
  /// ## 🏃‍♂️ Default Duration: `milliseconds: 500`
  static const _DURATION = Duration(milliseconds: 500);

  /// ## 🔘 Default Corner Radius: `3.0`
  static const _RADIUS = 3.0;

  /// ### 🌟 [Surface]
  /// A shapeable, layered, intrinsincally animated container Widget
  /// offering convenient access to blurring ImageFilters, Material InkResponse,
  /// and HapticFeedback.
  ///
  /// Property 🔲 [SurfacePeekSpec.peekAlignment] has hard-coded recognition
  /// of all nine [Alignment] geometries and will determine which side(s)
  /// receive a special border treatment according to
  /// property 🔲 [SurfacePeekSpec.peekRatio].
  /// - defaults at `peekRatio: 2` which makes the 🔲 [SurfacePeekSpec.peekAlignment] sides twice as thick, but
  /// - these borders made be made *thinner* than the others by passing `0 > peekRatio > 1`.
  ///
  /// Considering:
  /// 1. 📐 [SurfaceCorners] property [corners] and global 🔘 [radius];
  /// 2. 👆 [SurfaceTapSpec] parameters `tappable`, `onTap`, `providesFeedback` & `inkHighlightColor`, `inkSplashColor`;
  /// 3. 🔛 [padLayer] initialized 📚 [SurfaceLayer.MATERIAL] for three effective container layers
  /// 4. 👓 [SurfaceFilter] passed as 👓 [filterStyle] and `Map<SurfaceLayer, double>` 💧 [radiusMap]
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
  /// - **If [corners] is passed 📐 [SurfaceCorners.BEVEL]** then `bool` 🔁 [flipBevels]
  ///   can mirror the cut corners horizontally. Ignored otherwise.
  ///
  /// - **Passing 🔲 [SurfacePeekSpec.peekRatio] a value of `1`**
  ///   will negate any passed value to `peekAlignment`.
  /// - Similarly, **passing `peekRatio` in the range `0..1`**
  ///   will actually make the 🔲 [SurfacePeekSpec.peekAlignment]
  ///   aligned side(s) *thinner* than the others.
  ///
  /// - By default **👆 [SurfaceTapSpec.tappable] is true and
  ///   👆 [SurfaceTapSpec.providesFeedback] is false**.
  ///   - The former includes an [InkResponse] that calls
  ///   👆 [SurfaceTapSpec.onTap] and the latter enables [HapticFeedback].
  ///
  /// ---
  ///
  /// ### ❗ ***CAUTION***
  /// Only pass 👓 [SurfaceFilterSpec.filteredLayers] parameter for which you intend on
  /// passing each relevant 💧 [SurfaceFilterSpec.radiusMap] map parameter.
  ///   - Not only are the blurry [BackdropFilter]s expensive, but the
  ///   inheritance/ancestry behavior is strange.
  ///   - If all three filters are active via 👓 [SurfaceFilterSpec.filteredLayers], passing
  ///   `baseRadius: 0` eliminates the remaining children filters,
  ///   regardless of their passed `radius`.
  ///   - This behavior can be worked-around by setting any parent filter value
  ///   (`BASE > MATERIAL > CHILD`) to just above 0, specifically `> (_MINIMUM_BLUR == 0.0003)`,
  ///   but in this case a different 👓 [SurfaceFilterSpec.filteredLayers] `Set`
  ///   should be passed anyway that only employs the one or two appropriate filter(s).
  ///
  /// ------
  /// ------
  ///
  /// ### Simple Examples:
  /// ```dart
  /// // Surface with a border that's thicker on bottom & right, with rounded corners
  /// Surface(
  ///   radius: 10,
  ///   peekSpec: SurfacePeekSpec(
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
  ///   peekSpec: SurfacePeekSpec(peekAlignment: Alignment.topLeft),
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
    this.baseRadius,
    this.peekSpec = const SurfacePeekSpec(),
    this.tapSpec = const SurfaceTapSpec(),
    this.filterSpec = SurfaceFilterSpec.DEFAULT_SPEC,
    this.padLayer = SurfaceLayer.CHILD,
    this.flipBevels = false,
    this.child,
    Key? key,
  })  : assert((radius ?? 0) >= 0,
            '[Surface] > Please provide a non-negative [radius].'),
        super(key: key);

  /// The [width] and [height] follow rules of [AnimatedContainer],
  /// but apply to either the 📚 [SurfaceLayer.BASE] or,
  /// if `disableBase: true`, the 📚 [SurfaceLayer.MATERIAL] directly.
  final double? width, height;

  /// If [disableBase] `== true` the [margin] is properly handled by
  /// 📚 [SurfaceLayer.MATERIAL] but otherwise applies to 📚 [SurfaceLayer.BASE] and
  /// the Surface as a whole, ignored by 📚 [SurfaceLayer.MATERIAL].
  ///
  /// [padding] is always ignored by the 📚 [SurfaceLayer.BASE],
  /// because its `padding` is determined by [peek].
  ///
  /// See 🔛 [padLayer], however, for options on how to distribute the [padding]
  /// between (default) [SurfaceLayer.CHILD] or perhaps [SurfaceLayer.MATERIAL].
  /// Property 🔛 [padLayer] determines how [padding] is distributed.
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

  /// The 📚 [SurfaceLayer.BASE] will not be rendered if `true`.
  ///
  /// [margin] is passed to 📚 [SurfaceLayer.MATERIAL] in this case, and all parameters
  /// modifying `base` appearance are ignored.
  final bool disableBase;

  /// See 📐 [SurfaceCorners] for a small list of availabe shapes.
  /// Default is 📐 [SurfaceCorners.ROUND], but 📐 [SurfaceCorners.BEVEL] is fun.
  final SurfaceCorners corners;

  /// The 🔘 [radius] impacts the roundedness of default
  /// 📐 [SurfaceCorners.ROUND] or bevel-depth of 📐 [SurfaceCorners.BEVEL].
  ///
  /// If not provided, [radius] `=` [Surface._RADIUS] `== 3.0`.
  ///
  /// The 🔘 [baseRadius] may be specified separately,
  /// but is optional and will only impact the 📚 [SurfaceLayer.BASE].
  final double? radius, baseRadius;

  /// Surface 🔲 [SurfacePeekSpec.peek] is applied as `padding` to and insets 📚 [SurfaceLayer.MATERIAL].
  /// - It may be considered to function like a border for the [child] content.
  ///   - Note that 🌟 [Surface] does not currently support actual [Border]s.
  ///   - To give a border to a Surface, provide a Surface as a `child` to a [DecoratedBox] or [Container].
  ///
  /// According to 🔲 [SurfacePeekSpec.peekAlignment], a side(s)
  /// is given special treatment and made:
  /// - thicker (default `peekRatio == 2.0`) or
  /// - thinner (`0 > peekRatio > 1`)
  ///
  /// Defaults [Alignment.center] such that no sides receive special treatment.
  final SurfacePeekSpec peekSpec;

  /// Not only does 👆 [SurfaceTapSpec.tappable] provide `onTap` Callback,
  /// it also adds an [InkResponse] to the [Material] before rendering [child].
  ///
  /// 👆 [SurfaceTapSpec.providesFeedback] is a convenience parameter
  /// to add a [HapticFeedback.vibrate] `onTap`.
  final SurfaceTapSpec tapSpec;

  /// Provided a 🔬 [SurfaceFilterSpec] to alter
  /// filter appearance at all 📚 [SurfaceLayer]s.
  /// - `Set<SurfaceLayer>` 👓 [SurfaceFilterSpec.filteredLayers]
  ///   determines which 📚 Layers have filters
  /// - 💧 [SurfaceFilterSpec.radiusMap] determines filter strength
  ///   - Or [SurfaceFilterSpec.baseRadius] && `materialRadius` && `childRadius`
  /// - Use [SurfaceFilterSpec.extendBaseFilter] `== true` to have
  ///   📚 [SurfaceLayer.BASE]'s filter extend to cover
  ///   the [Surface.margin] insets.
  ///
  /// While a `new` 🌟 [Surface] employs 🔬 [SurfaceFilterSpec.DEFAULT_SPEC],
  /// where [SurfaceFilterSpec.filteredLayers] is [SurfaceFilterSpec.NONE],
  /// a `new` 🔬 [SurfaceFilterSpec] defaults
  /// 👓 [SurfaceFilterSpec.filteredLayers] to [BASE].
  /// - Default blur radius/strength is [_BLUR] `== 4.0`.
  /// - Minimum accepted radius for an activated
  /// 📚 Layer is [_BLUR_MINIMUM] `== 0.0003`.
  /// * **❗ See CAUTION in [Surface] doc.**
  final SurfaceFilterSpec filterSpec;

  /// Specify a 📚 [SurfaceLayer] as 🔛 [padLayer]
  /// to receive [Surface.padding] value.
  ///
  /// By default, passed entirely to 📚 [SurfaceLayer.CHILD], but
  /// optionally may be given to a 🔪 [_clipper] within 📚 [SurfaceLayer.MATERIAL]
  /// before rendering 👶 [child].
  ///
  /// The effect with 🔛 [padLayer] `=` 📚 [SurfaceLayer.MATERIAL] can be neat
  /// with non-negligible [Surface.padding] as it adds a third customizable
  /// 📚 Layer to a 🌟 Surface.
  /// - Consider 👓 [SurfaceFilterSpec.filteredLayers] `=` 👓 [SurfaceFilterSpec.TRILAYER].
  ///
  /// ### ❗ Special Case
  /// Specifying 📚 [SurfaceLayer.BASE] is a special case in which
  /// [Surface.padding] is then *split* between 📚 `MATERIAL` and 📚 `CHILD` layers.
  final SurfaceLayer padLayer;

  /// Only if [corners] `==` 📐 [SurfaceCorners.BEVEL] will 🔁 [flipBevels] then
  /// mirror the two beveled corners horizontally across x-axis; ignored otherwise.
  ///
  /// See 🔰 [SurfaceShape] which ultimately provides the
  /// [BeveledRectangleBorder] used throughout Surface.
  final bool flipBevels;

  /// The 👶 [child] Widget to render inside as the Surface content
  /// after considering all layout parameters.
  final Widget? child;

  double _getRadius([SurfaceLayer? layer]) {
    return (layer == SurfaceLayer.BASE)
        ? (baseRadius ?? radius ?? _RADIUS)
        : (radius ?? _RADIUS);
  }

  /// ---
  /// ## 👷‍♂️🌟 Build [Surface]
  @override
  Widget build(BuildContext context) {
    /// ❗ See *CAUTION* in Surface doc for more information on
    /// 👓 [filterStyle] and [SurfaceFilterSpec.filterRadius] values.
    assert(
        ((filterSpec.filteredLayers == SurfaceFilterSpec.TRILAYER)
                ? (filterSpec._baseRadius >= _BLUR_MINIMUM &&
                    filterSpec._materialRadius >= _BLUR_MINIMUM)
                : true) ||
            ((filterSpec.filteredLayers == SurfaceFilterSpec.INNER_BILAYER)
                ? (filterSpec._materialRadius >= _BLUR_MINIMUM)
                : true) ||
            ((filterSpec.filteredLayers == SurfaceFilterSpec.BASE_AND_CHILD)
                ? (filterSpec._baseRadius >= _BLUR_MINIMUM)
                : true) ||
            ((filterSpec.filteredLayers == SurfaceFilterSpec.BASE_AND_MATERIAL)
                ? (filterSpec._baseRadius >= _BLUR_MINIMUM)
                : true),
        '[Surface] > Upper-layered filters will be negated if ancestor filters are enabled that have radius < 0.0003.\n'
        'Increase blur radius of lower layer(s) or pass a different [SurfaceFilterSpec.filteredLayers].');

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

      /// Material will be canvas for [child] and respond to touches.
      child: Material(
        color: const Color(0x00FFFFFF), // transparent
        child: (tapSpec.tappable) ? _buildInkResponse(context) : _buildChild(),
      ),
    );

    /// ---
    /// 🌟🐚 ### `baseContainer` = 📚 [SurfaceLayer.BASE]
    Widget baseContainer = AnimatedContainer(
      // May be `null` anyway
      width: width,
      height: height,
      margin: filterSpec.extendBaseFilter ? margin : const EdgeInsets.all(0),
      duration: duration,
      curve: curve,

      /// 🔲 This padding is effectively the "border" of the Surface.
      // Values generated at start of build() using 🔲 [SurfacePeekSpec].
      padding: EdgeInsets.fromLTRB(
        peekSpec._peekLeft,
        peekSpec._peekTop,
        peekSpec._peekRight,
        peekSpec._peekBottom,
      ),

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
      return Padding(
        padding: (disableBase || filterSpec.extendBaseFilter)
            ? const EdgeInsets.all(0)
            : margin,
        child: _filterOrChild(layer: SurfaceLayer.BASE, child: baseContainer),
      );
  }

  /// ---
  /// ## 👷‍♂️: 👆 [_buildInkResponse]
  /// If 👆 [SurfaceTapSpec.tappable] is `true` then Surface parameter [child]
  /// is passed into this [InkResponse] with customizable
  /// 👆 [SurfaceTapSpec.inkHighlightColor] and 👆 [SurfaceTapSpec.inkSplashColor].
  InkResponse _buildInkResponse(BuildContext context) {
    return InkResponse(
      /// 👶 [child]
      child: _buildChild(),

      /// Consult 👆 [SurfaceTapSpec]
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
          ? _buildBiBeveledShape(layer: SurfaceLayer.BASE)
          : RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  (corners == SurfaceCorners.SQUARE) ? 0 : _getRadius()),
            ),
    );
  }

  /// ---
  /// ## 👷‍♂️: 👶 [_buildChild] with passed [child]
  /// A [ClipPath] from [_clipper] is used to ensure child renders properly
  /// at inner corners.
  ///
  /// Property 🔛 [padLayer] determines how [padding] is distributed.
  /// - Special case where `padLayer == SurfaceLayer.BASE` *splits* the padding
  ///   between 📚 `MATERIAL` and 📚 `CHILD` [SurfaceLayer]s.
  AnimatedPadding _buildChild() {
    /// [clipper] padding
    return AnimatedPadding(
      duration: duration,
      padding: (padLayer == SurfaceLayer.MATERIAL)
          ? padding
          : (padLayer == SurfaceLayer.BASE)
              ? padding / 2

              /// padLayer == SurfaceLayer.CHILD
              : const EdgeInsets.all(0),

      /// [clipper] containing [child]
      child: _clipper(
        layer: SurfaceLayer.CHILD,
        content: AnimatedContainer(
          duration: duration,
          curve: curve,
          padding: (padLayer == SurfaceLayer.CHILD)
              ? padding
              : (padLayer == SurfaceLayer.BASE)
                  ? padding / 2

                  /// padLayer == SurfaceLayer.SURFACE
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
    required bool isGradient,
    required Map<SurfaceLayer, Color> fallbacks,
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
          shape: _buildBiBeveledShape(layer: layer));
    } else {
      return BoxDecoration(
        gradient: (layer == SurfaceLayer.BASE) ? baseGradient : gradient,
        borderRadius: BorderRadius.all(
          Radius.circular(
            corners == SurfaceCorners.SQUARE ? 0 : _getRadius(layer),
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
          shape: _buildBiBeveledShape(layer: SurfaceLayer.BASE));
    else
      return BoxDecoration(
        color: (layer == SurfaceLayer.BASE)
            ? baseColor ?? fallbacks[SurfaceLayer.BASE]
            : color ?? fallbacks[SurfaceLayer.MATERIAL],
        borderRadius: BorderRadius.all(
          Radius.circular(
            corners == SurfaceCorners.SQUARE ? 0 : _getRadius(layer),
          ),
        ),
      );
  }

  /// ---
  /// 👷‍♂️: 🔰 [_buildBiBeveledShape]
  /// Customized 🔰 [SurfaceShape] so the 📚 [SurfaceLayer.MATERIAL]
  /// may have a deeper-cut beveled corner if
  /// the property [peekAlignment] is passed and corner-set.
  ///
  /// Certainly repass 🔁 [flipBevels].
  BeveledRectangleBorder _buildBiBeveledShape({required SurfaceLayer layer}) {
    /// BiBeveledShape could provide more functionality in the future.
    return SurfaceShape.biBeveledRectangle(
      // radius: (radius) * (40 - peekSpec.peek - 2.3 * peekSpec.peek) / 40,
      radius: _getRadius(layer),
      flip: flipBevels,

      /// A corner may indeed not be shrunken after all
      /// if [SurfacePeekSpec.peekAlignment] is not corner-set.
      ///
      /// (See: [_determineShrinkCornerAlignment] final `else`
      /// returns `Alignment.center` which 🔰 [BiBeveledShape] knows
      /// to ignore when shrinking a corner.)
      shrinkOneCorner: layer != SurfaceLayer.BASE,
      shrinkCornerAlignment: _determineShrinkCornerAlignment(),
    );
  }

  /// ---
  /// ## 🔧: 🔪 Shortcut [_clipper] for a [ClipPath]
  /// Since several mostly-identical ClipPaths are employed,
  /// this method will speed things up.
  ///
  /// TODO: Altered inner radius
  ClipPath _clipper({
    required SurfaceLayer layer,
    required Widget content,
  }) {
    return ClipPath(
      child: content,
      clipper: ShapeBorderClipper(
        shape: (corners == SurfaceCorners.BEVEL)
            ?

            /// 📐 [SurfaceCorners.BEVEL] may need a slightly different shape for
            /// the 📚 [SurfaceLayer.MATERIAL] vs. the 📚 [SurfaceLayer.BASE].
            _buildBiBeveledShape(layer: layer)

            /// A 📐 [SurfaceCorners.ROUND] or SQUARE Surface uses the same shape
            /// regardless of 📚 [SurfaceLayer].
            : RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  (corners == SurfaceCorners.SQUARE) ? 0 : _getRadius(layer),
                ),
              ),
      ),
    );
  }

  /// ---
  /// ## 🔧: 💧 | 👶 Shortcut [_filterOrChild]
  /// Returns [_clipper]-ed [ImageFilter] via [Blur.ry] *OR* [child] --
  /// appropriate for the currently rendering 📚 [SurfaceLayer], considering both
  /// the parameter 👓 [SurfaceFilterSpec.filteredLayers] and the relevant
  /// 💧 [SurfaceFilterSpec._filterRadiusByLayer].
  ///
  /// If an [ImageFilter] is not needed, this method simply returns the child.
  _filterOrChild({
    required SurfaceLayer layer,
    required Widget child,
  }) {
    /// No filters.
    if (filterSpec.filteredLayers.isEmpty) return child;

    if (layer == SurfaceLayer.CHILD)

      /// Consider the 🔬 [SurfaceFilterSpec] 💧 [radiusMap] entry being `0`
      /// and 👓 [filteredLayers] options that would
      /// enable rendering BackdropFilter for this 📚 [SurfaceLayer].
      return (filterSpec._filterRadiusByLayer(layer) > 0 &&
              filterSpec.filteredLayers.contains(layer))

          /// Where this case is returned, a 🔪 [_clipper] is already present.
          ? BackdropFilter(
              filter: Blur.ry(filterSpec._filterRadiusByLayer(layer)),
              child: child,
            )
          : child;
    else
      return (filterSpec._filterRadiusByLayer(layer) > 0 &&
              filterSpec.filteredLayers.contains(layer))

          /// If passes, return the 👶 [child] clipped and nested on a filter.
          ? _clipper(
              layer: layer,
              content: BackdropFilter(
                filter: Blur.ry(filterSpec._filterRadiusByLayer(layer)),
                child: child,
              ),
            )

          /// Otherwise return 👶 [child], as it says on the tin.
          : child;
  }

  /// ---
  /// ## 🔰: 🧮 TODO: WIP [_determineShrinkCornerAlignment]
  /// Shrink the corner diagonally-opposite the corner from where [peekAlignment]
  /// results in thicker border.
  ///
  /// Unless 🔁 [flipBevels] `== true` then, taking this finding, shrink now the
  /// horizontally-opposite corner.
  ///
  /// Only impacts a 🌟 [Surface] that has a corner-set 🔲 [SurfacePeekSpec.peekAlignment].
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
