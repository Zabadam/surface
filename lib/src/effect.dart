/// ## 🌟 Surface: Effects
/// Specify a 🔬 [SurfaceFilterSpec] with options
/// to render 🤹‍♂️ [SurfaceFX] backdrop [ImageFilter]s
/// - In configured 👓 [SurfaceFilterSpec.filteredLayers] `Set`
/// - Whose radii (🤹‍♂️ [effect] strength) are mapped with 📊 [SurfaceFilterSpec.radiusMap]
///   - A 📚 [SurfaceLayer.BASE] filter may be extended through the
///   [Surface.margin] with [SurfaceFilterSpec.extendBaseFilter]
library surface;

import '../surface.dart';

/// ### ❗ See ***CAUTION*** in [Surface] doc
/// Concerning 👓 [FilterSpec.filteredLayers]
/// and 📊 [FilterSpec.radiusMap] values.
///
/// Default 📊 `radius` passed to 💧 [FX.blurry].
/// # `4.0`
const _BLUR = 4.0;

/// ### 🤹‍♂️ Surface FX
/// [specRadius] will be the radius from 🔬 [FilterSpec]
/// that matches ongoing 📚 [layerForRender].
typedef ImageFilter SurfaceFX(double specRadius, SurfaceLayer layerForRender);

//! ---
/// ### 🤹‍♂️ Surface FX
/// At present, 💧 [blurry] is the only [ImageFilter] available.
class FX {
  /// # 💧 `b()`
  /// [radius] is of type `double?` and may be `null`:
  ///
  /// Returns [ImageFilter.blur], passing `radius ?? _BLUR == 4.0`
  /// as both `ImageFilter.blur(sigmaX)` & `ImageFilter.blur(sigmaY)`.
  static ImageFilter b(double? radius) =>
      ImageFilter.blur(sigmaX: radius ?? _BLUR, sigmaY: radius ?? _BLUR);

  /// #### 💧 Blurry
  /// This [SurfaceFX] simply forwards the [FilterSpec] radius
  /// for the given layer straight to [FX.b].
  static ImageFilter blurry(double specRadius, SurfaceLayer layerForRender) =>
      b(specRadius);
}

//! ---
/// ### 🔬 [FilterSpec]
/// A 🌟 [Surface] may be provided a 🔬 [FilterSpec] to alter
/// filter appearance at all 📚 [SurfaceLayer]s.
class FilterSpec {
  /// A new 🌟 [Surface] defaults 🔬 [Surface.filterSpec] to this [DEFAULT_SPEC],
  /// which differs from a `(new) FilterSpec`.
  /// ```
  /// - filteredLayers: SurfaceFilterSpec.NONE // <SurfaceLayer>{}
  /// - radiusMap: <SurfaceLayer, double>{}
  /// ```
  static const DEFAULT_SPEC = FilterSpec(
    filteredLayers: NONE,
    radiusMap: <SurfaceLayer, double>{},
    effect: FX.blurry,
  );

  /// #### 👓 None
  /// No [effect] 🤹‍♂️ [SurfaceFX] filters.
  static const NONE = <SurfaceLayer>{};

  /// #### 👓 Trilayer
  /// 3x [effect] 🤹‍♂️ [SurfaceFX] filters, one at each layer of build:
  /// - under 📚 [SurfaceLayer.BASE]
  /// - under 📚 [SurfaceLayer.MATERIAL]
  /// - under 📚 [SurfaceLayer.CHILD]
  static const TRILAYER = <SurfaceLayer>{
    SurfaceLayer.BASE,
    SurfaceLayer.MATERIAL,
    SurfaceLayer.CHILD,
  };

  /// #### 👓 Inner Bilayer
  /// 2x [effect] 🤹‍♂️ [SurfaceFX] filters:
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
  /// 2x [effect] 🤹‍♂️ [SurfaceFX] filters:
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
  /// 2x [effect] 🤹‍♂️ [SurfaceFX] filters:
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
  /// 1x [effect] 🤹‍♂️ [SurfaceFX] filter:
  /// - under 📚 [SurfaceLayer.BASE]
  /// And the entire 🌟 [Surface] as a result.
  static const BASE = <SurfaceLayer>{SurfaceLayer.BASE};

  /// #### 👓 Material
  /// 1x [effect] 🤹‍♂️ [SurfaceFX] filter:
  /// - under 📚 [SurfaceLayer.MATERIAL]
  /// After any inset from the 🔲 [PeekSpec.peek].
  static const MATERIAL = <SurfaceLayer>{SurfaceLayer.MATERIAL};

  /// #### 👓 Child
  /// 1x [effect] 🤹‍♂️ [SurfaceFX] filter
  /// - under 📚 [SurfaceLayer.BASE], after any inset from [Surface.padding]
  static const CHILD = <SurfaceLayer>{SurfaceLayer.CHILD};

  /// ### 🔬 [FilterSpec]
  /// A 🌟 [Surface] may be provided a 🔬 [FilterSpec]
  /// to change filter appearance at all 📚 [SurfaceLayer]s.
  /// - `Set<SurfaceLayer>` 👓 [filteredLayers] determines which 📚 Layers have filters
  /// - � [radiusMap] or [baseRadius] && [materialRadius] && [childRadius]
  ///   determine filter strength
  /// - Use [extendBaseFilter] `== true` to have 📚 [SurfaceLayer.BASE]'s
  ///   filter extend to cover the [Surface.margin] insets.
  ///
  /// While a `new` 🌟 [Surface] employs 🔬 [DEFAULT_SPEC],
  /// where 👓 [filteredLayers] is [NONE], a `new` 🔬 [FilterSpec]
  /// defaults 👓 [filteredLayers] to [BASE].
  /// - Default 📊 `radius`/strength is [_BLUR] `== 4.0`.
  /// - Minimum accepted 📊 `radius` for an activated
  /// 📚 Layer is [_BLUR_MINIMUM] `== 0.0003`.
  /// * **❗ See CAUTION in [Surface] doc.**
  const FilterSpec({
    this.filteredLayers = BASE,
    this.radiusMap,
    this.baseRadius,
    this.materialRadius,
    this.childRadius,
    this.extendBaseFilter = false,
    this.effect = FX.blurry,
  });

  /// Provide a `Set{}` to 👓 [filteredLayers] to specify which
  /// 📚 [SurfaceLayer]s will have an [effect] 🤹‍♂️ [SurfaceFX] enabled.
  ///
  /// 📊 `Radii` of the 🤹‍♂️ [effect] are mapped
  /// to each 📚 [SurfaceLayer] by 📊 [radiusMap] or set explicitly
  /// by 📊 [baseRadius], 📊 [materialRadius], or 📊 [childRadius].
  final Set<SurfaceLayer> filteredLayers;

  /// 📊 [radiusMap] `Map`s one or more 📚 [SurfaceLayer]s to a `double`
  /// that determines the 🤹‍♂️ [SurfaceFX] `radius` for that layer's 🤹‍♂️ [effect].
  ///
  /// All three `radii`  to 💧 [_BLUR] `== 0.0003` so that
  /// upper-layered filters are not erased by an ancestor filter having 0 radius.
  ///
  /// - If 👓 [filteredLayers] is set to enable all three
  ///   📚 [SurfaceLayer] filters, initialize all three
  ///   📊 [radiusMap] `double`s `>=` 💧 [_BLUR_MINIMUM] `== 0.
  /// - Similarly, if only two filters are enabled, the lower-Z filter
  ///   (lowest-Z value: [SurfaceLayer.BASE]) must be above zero to not negate
  ///   any value passed to the higher-Z filter (highest-Z value: [SurfaceLayer.CHILD]).
  ///
  /// ### ❗ See ***CAUTION*** in [Surface] doc for more.
  final Map<SurfaceLayer, double>? radiusMap;

  /// Instead of initializing a 📊 [radiusMap], opt to
  /// pass a specific layer's 🤹‍♂️ [effect] radius with this property.
  final double? baseRadius, materialRadius, childRadius;

  /// If [extendBaseFilter] is `true`, the BackdropFilter for 📚 [SurfaceLayer.BASE]
  /// will extend to cover the [Surface.margin] padding.
  final bool extendBaseFilter;

  /// ### 🤹‍♂️ Surface FX
  /// Open for expansion. Default implentation is 💧 [FX.blurry],
  /// itself forwarding to 💧 [FX.b].
  ///
  /// A [SurfaceFX] `Function` where [specRadius] comes from
  /// 🔬 [FilterSpec] according to ongoing 📚 [layerForRender].
  /// - 📚 [SurfaceLayer]s disabled by [FilterSpec.filteredLayers]
  /// will be delivered with `specRadius == 0.0`, regardless of [radiusByLayer].
  final SurfaceFX effect;

  /// Check if � [radiusMap] has a value for this 📚 [layer] and return if so;
  /// if not, then check if this 📚 [layer] was initialized a specific `double`
  /// (such as � [baseRadius]) and return if so;
  /// finally, if all else fails, return const [_BLUR]
  radiusByLayer(SurfaceLayer layer) {
    switch (layer) {
      case SurfaceLayer.BASE:
        return literalRadiusBase;
      case SurfaceLayer.MATERIAL:
        return literalRadiusMaterial;
      case SurfaceLayer.CHILD:
        return literalRadiusChild;
    }
  }

  double get literalRadiusBase =>
      radiusMap?.containsKey(SurfaceLayer.BASE) ?? false
          ? radiusMap![SurfaceLayer.BASE]!
          : (baseRadius != null)
              ? baseRadius!
              : _BLUR;
  double get literalRadiusMaterial =>
      radiusMap?.containsKey(SurfaceLayer.MATERIAL) ?? false
          ? radiusMap![SurfaceLayer.MATERIAL]!
          : (materialRadius != null)
              ? materialRadius!
              : _BLUR;

  double get literalRadiusChild =>
      radiusMap?.containsKey(SurfaceLayer.CHILD) ?? false
          ? radiusMap![SurfaceLayer.CHILD]!
          : (childRadius != null)
              ? childRadius!
              : _BLUR;
}
