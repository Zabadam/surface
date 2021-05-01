/// ## 🌟 Surface Library: Effect
/// - 🤹‍♂️ [SurfaceFX] `typedef`
/// - 🤹‍♂️ [FX] `ImageFilter`s
/// - 🔬 [Filter] specification
library surface;

import 'dart:ui' show ImageFilter;

import 'shape.dart';

/// ### ❗ See ***Consideration*** in library `surface.dart` doc
/// Regarding 👓 [Filter.filteredLayers] and 📊 [Filter.radiusMap] values.
///
/// Default 📊 `radius` passed to 💧 [FX.blurry]
/// is `4.0` & minimum is `0.0003`.
const _BLUR = 4.0;

/// ### 🤹‍♂️ Surface FX
/// `specRadius` will be the radius from 🔬 [Filter]
/// that matches ongoing 📚 `layerForRender`.
typedef ImageFilter SurfaceFX(double specRadius, SurfaceLayer layerForRender);

//! ---
/// ### 🤹‍♂️ Surface FX
/// At present, 💧 [blurry] is the only [ImageFilter] available.
class FX {
  /// # 💧 `b()`
  /// [radius] is of type `double?` and  is required but may be `null`.
  ///
  /// Returns [ImageFilter.blur], passing `radius ?? _BLUR == 4.0`
  /// as both `ImageFilter.blur(sigmaX)` & `ImageFilter.blur(sigmaY)`.
  static ImageFilter b(double? radius) =>
      ImageFilter.blur(sigmaX: radius ?? _BLUR, sigmaY: radius ?? _BLUR);

  /// #### 💧 Blurry
  /// This [SurfaceFX] simply forwards the [Filter] radius
  /// for the given layer straight to [FX.b].
  static ImageFilter blurry(double specRadius, SurfaceLayer layerForRender) =>
      b(specRadius);
}

//! ---
/// ### 🔬 [Filter]
/// A 🌟 [Surface] may be provided a 🔬 [Filter]
/// to change filter appearance at all 📚 [SurfaceLayer]s.
/// - `Set<SurfaceLayer>` 👓 [filteredLayers] ultimately determines
/// which 📚 Layers have filters enabled
/// - Use [extendBaseFilter] `== true` to have 📚 [SurfaceLayer.BASE]'s
///   filter extend to cover the [Surface.margin] insets.
///
/// While a `new` 🌟 [Surface] employs 🔬 [DEFAULT],
/// where 👓 [filteredLayers] is [NONE], a `new` 🔬 [Filter]
/// defaults 👓 [filteredLayers] to [BASE] and `_baseRadius` to `4.0`.
///
/// ### ❗ See ***Consideration*** in library `surface.dart` doc
/// Regarding 👓 [Filter.filteredLayers] and 📊 [Filter.radiusMap] values.
///
/// Default 📊 `radius` passed to 💧 [FX.blurry]
/// is [_BLUR] `== 4.0` & minimum is `0.0003`.
class Filter {
  /// A new 🌟 [Surface] defaults 🔬 [Surface.filter] to this [DEFAULT],
  /// which differs from a `(new) FilterSpec`.
  static const DEFAULT = Filter(
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
  ///
  /// The blur under the 📚 `CHILD` may appear doubled
  /// unless the 🔛 [Surface.padLayer] `!=` 📚 [SurfaceLayer.CHILD] and
  /// [Surface.padding] is non-negligible.
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
  /// Furthermore, the blur under the 📚 `CHILD` may appear doubled
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
  /// After any inset from the 🔲 [Peek.peek].
  static const MATERIAL = <SurfaceLayer>{SurfaceLayer.MATERIAL};

  /// #### 👓 Child
  /// 1x [effect] 🤹‍♂️ [SurfaceFX] filter
  /// - under 📚 [SurfaceLayer.BASE], after any inset from [Surface.padding]
  static const CHILD = <SurfaceLayer>{SurfaceLayer.CHILD};

  /// A 🌟 [Surface] may be provided a 🔬 [Filter]
  /// to change filter appearance at all 📚 [SurfaceLayer]s.
  /// - `Set<SurfaceLayer>` 👓 [filteredLayers] ultimately determines
  /// which 📚 Layers have filters enabled
  /// - 📊 [_radiusMap] or [_radiusBase] && [_radiusMaterial] && [_radiusChild]
  ///   determine filter strength during creation
  /// - Use [extendBaseFilter] `== true` to have 📚 [SurfaceLayer.BASE]'s
  ///   filter extend to cover the [Surface.margin] insets.
  ///
  /// While a `new` 🌟 [Surface] employs 🔬 [DEFAULT],
  /// where 👓 [filteredLayers] is [NONE], a `new` 🔬 [Filter]
  /// defaults 👓 [filteredLayers] to [BASE] and `_baseRadius` to `4.0`.
  ///
  /// ### ❗ See ***Consideration*** in library `surface.dart` doc
  /// Regarding 👓 [Filter.filteredLayers] and 📊 [Filter.radiusMap] values.
  ///
  /// Default 📊 `radius` passed to 💧 [FX.blurry]
  /// is [_BLUR] `== 4.0` & minimum is `0.0003`.
  const Filter({
    this.effect = FX.blurry,
    this.filteredLayers = BASE,
    Map<SurfaceLayer, double>? radiusMap,
    double? radiusBase,
    double? radiusMaterial,
    double? radiusChild,
    this.extendBaseFilter = false,
  })  : _radiusMap = radiusMap,
        _radiusBase = radiusBase,
        _radiusMaterial = radiusMaterial,
        _radiusChild = radiusChild;

  /// ### 🤹‍♂️ Surface FX
  /// Open for expansion. Default implentation is 💧 [FX.blurry],
  /// itself forwarding to 💧 [FX.b].
  ///
  /// A [SurfaceFX] `Function` where [specRadius] comes from
  /// 🔬 [Filter] according to ongoing 📚 [layerForRender].
  /// - 📚 [SurfaceLayer]s disabled by [Filter.filteredLayers]
  /// will be delivered with `specRadius == 0.0`, regardless of [radiusByLayer].
  final SurfaceFX effect;

  /// Provide a `Set{}` to 👓 [filteredLayers] to specify which
  /// 📚 [SurfaceLayer]s will have an [effect] 🤹‍♂️ [SurfaceFX] enabled.
  ///
  /// 📊 `Radii` of the 🤹‍♂️ [effect] are mapped
  /// to each 📚 [SurfaceLayer] by 📊 [radiusMap], but a 📚 `Layer`
  /// that is not within this `Set` will render no filter.
  final Set<SurfaceLayer> filteredLayers;

  /// 📊 [_radiusMap] `Map`s one or more 📚 [SurfaceLayer]s to a `double`
  /// that determines the 🤹‍♂️ [SurfaceFX] `radius` for that layer's 🤹‍♂️ [effect].
  ///
  /// A 📚 `Layer` that is not within [filteredLayers] will render no filter.
  ///
  /// - If 👓 [filteredLayers] is set to enable all three
  ///   📚 [SurfaceLayer] filters, initialize all `radii >= 💧 _BLUR_MINIMUM == 0.0003`
  /// - Similarly, if only two filters are enabled, the lower-Z filter
  ///   (lowest-Z value: [SurfaceLayer.BASE]) must be above zero to not negate
  ///   any value passed to the higher-Z filter (highest-Z value: [SurfaceLayer.CHILD]).
  ///
  /// ### ❗ See ***Consideration*** in library `surface.dart` doc
  final Map<SurfaceLayer, double>? _radiusMap;

  /// Instead of initializing a 📊 [_radiusMap], opt to
  /// pass a specific layer's 🤹‍♂️ [effect] radius with this property.
  ///
  /// A 📚 `Layer` that is not within [filteredLayers] will render no filter.
  final double? _radiusBase, _radiusMaterial, _radiusChild;

  /// If [extendBaseFilter] is `true`, the BackdropFilter for 📚 [SurfaceLayer.BASE]
  /// will extend to cover the [Surface.margin] padding.
  final bool extendBaseFilter;

  /// Returns a `Map<SurfaceLayer, double>` via [radiusByLayer], and so
  /// will always have an entry for every 📚 `Layer`, even if it is the
  /// default [_BLUR] `== 4.0`.
  ///
  /// [radiusByLayer] returns the corresponding `renderedRadius_` field
  /// by 📚 [SurfaceLayer] `switch`.
  ///
  /// A 📚 `Layer` that is not within [filteredLayers] will render no filter.
  Map<SurfaceLayer, double> get radiusMap => <SurfaceLayer, double>{
        for (var layer in SurfaceLayer.values) layer: radiusByLayer(layer)
      };

  /// Returns the corresponding `renderedRadius_` field
  /// by 📚 [SurfaceLayer] `switch`.
  ///
  /// A 📚 `Layer` that is not within [filteredLayers] will render no filter.
  double radiusByLayer(SurfaceLayer layer) {
    switch (layer) {
      case SurfaceLayer.BASE:
        return renderedRadiusBase;
      case SurfaceLayer.MATERIAL:
        return renderedRadiusMaterial;
      case SurfaceLayer.CHILD:
        return renderedRadiusChild;
    }
  }

  /// Checks if `double` 📊 [_radiusBase] was initialized and returns if so.
  ///
  /// Otherwise, checks if 📊 [_radiusMap] was assigned a value
  /// for this 📚 [layer] and returns if so.
  ///
  /// If all else fails, returns [_BLUR] `== 4.0`.
  ///
  /// A 📚 `Layer` that is not within [filteredLayers] will render no filter.
  double get renderedRadiusBase =>
      _radiusMap?.containsKey(SurfaceLayer.BASE) ?? false
          ? _radiusMap![SurfaceLayer.BASE]!
          : (_radiusBase != null)
              ? _radiusBase!
              : _BLUR;

  /// Checks if `double` 📊 [_radiusMaterial] was initialized and returns if so.
  ///
  /// Otherwise, checks if 📊 [_radiusMap] was assigned a value
  /// for this 📚 [layer] and returns if so.
  ///
  /// If all else fails, returns [_BLUR] `== 4.0`.
  ///
  /// A 📚 `Layer` that is not within [filteredLayers] will render no filter.
  double get renderedRadiusMaterial =>
      _radiusMap?.containsKey(SurfaceLayer.MATERIAL) ?? false
          ? _radiusMap![SurfaceLayer.MATERIAL]!
          : (_radiusMaterial != null)
              ? _radiusMaterial!
              : _BLUR;

  /// Checks if `double` 📊 [_radiusChild] was initialized and returns if so.
  ///
  /// Otherwise, checks if 📊 [_radiusMap] was assigned a value
  /// for this 📚 [layer] and returns if so.
  ///
  /// If all else fails, returns [_BLUR] `== 4.0`.
  ///
  /// A 📚 `Layer` that is not within [filteredLayers] will render no filter.
  double get renderedRadiusChild =>
      _radiusMap?.containsKey(SurfaceLayer.CHILD) ?? false
          ? _radiusMap![SurfaceLayer.CHILD]!
          : (_radiusChild != null)
              ? _radiusChild!
              : _BLUR;
}
