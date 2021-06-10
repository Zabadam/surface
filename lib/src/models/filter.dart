/// ## 🌟 Surface Library:
/// ### 🤹‍♂️ `Filter`
/// - 🤹‍♂️ [SurfaceFX] `typedef`
/// - 🤹‍♂️ [FX] `ImageFilter`s
/// - 🔬 [Filter] specification
library surface;

import 'dart:ui' show ImageFilter;

import 'layer.dart';

/// ### 🤹‍♂️ Surface FX
/// `specRadius` will be the radius from 🔬 [Filter]
/// that matches ongoing 📚 `layerForRender`.
typedef SurfaceFX = ImageFilter Function(
    double specRadius, SurfaceLayer layerForRender);

//! ---
/// ### 🤹‍♂️ Surface FX
/// At present, 💧 [blurry] is the only [ImageFilter] available.
class FX {
  /// # 💧 `b()`
  /// [radius] is of type `double?` and  is required but may be `null`.
  ///
  /// Returns [ImageFilter.blur], passing `radius ?? 0.0`
  /// as both `ImageFilter.blur(sigmaX)` & `ImageFilter.blur(sigmaY)`.
  static ImageFilter b(double? radius) =>
      ImageFilter.blur(sigmaX: radius ?? 0, sigmaY: radius ?? 0);

  /// #### 💧 Blurry
  /// This [SurfaceFX] simply forwards the [Filter] radius
  /// for the given layer straight to [FX.b].
  static ImageFilter blurry(double specRadius, SurfaceLayer layerForRender) =>
      b(specRadius);
}

//! ---
/// ### 🔬 [Filter]
/// A  🔬 [Filter] changes filter appearance at all 📚 [SurfaceLayer]s.
/// - `Set<SurfaceLayer>` 👓 [filteredLayers] ultimately determines
/// which 📚 Layers have filters enabled.
class Filter {
  /// A  🔬 [Filter]
  /// to change filter appearance at all 📚 [SurfaceLayer]s.
  /// - `Set<SurfaceLayer>` 👓 [filteredLayers] ultimately determines
  /// which 📚 Layers have filters enabled.
  const Filter({
    this.filteredLayers = const {
      SurfaceLayer.FOUNDATION,
      SurfaceLayer.MATERIAL,
      SurfaceLayer.CHILD
    },
    this.radiusFoundation,
    this.radiusMaterial,
    this.radiusChild,
    this.effect = FX.blurry,
  });

  /// All 📚 layers disabled and radii set to `0.0`.
  static const none = Filter(
    effect: FX.blurry,
    filteredLayers: <SurfaceLayer>{},
    radiusFoundation: 0.0,
    radiusMaterial: 0.0,
    radiusChild: 0.0,
  );

  /// 📚 `CHILD` Layer blurred, radius: `10.0`
  static const blurChild = Filter(
    effect: FX.blurry,
    filteredLayers: {SurfaceLayer.CHILD},
    radiusChild: 10.0,
  );

  /// 📚 `FOUNDATION` Layer blurred, radius: `3.0`
  static const blurFoundation = Filter(
    effect: FX.blurry,
    filteredLayers: {SurfaceLayer.FOUNDATION},
    radiusFoundation: 3.0,
  );

  /// 📚 `MATERIAL` Layer blurred, radius: `3.0`
  static const blurMaterial = Filter(
    effect: FX.blurry,
    filteredLayers: {SurfaceLayer.MATERIAL},
    radiusMaterial: 3.0,
  );

  /// 📚 `FOUNDATION` Layer blurred, radius: `10.0`
  static const blurFoundation10 = Filter(
    effect: FX.blurry,
    filteredLayers: {SurfaceLayer.FOUNDATION},
    radiusFoundation: 10.0,
  );

  /// 📚 `MATERIAL` Layer blurred, radius: `10.0`
  static const blurMaterial10 = Filter(
    effect: FX.blurry,
    filteredLayers: {SurfaceLayer.MATERIAL},
    radiusMaterial: 10.0,
  );

  /// ### 🤹‍♂️ Surface FX
  /// Open for expansion. Default implentation is 💧 [FX.blurry],
  /// itself forwarding to 💧 [FX.b].
  ///
  /// A [SurfaceFX] `Function` where `specRadius` comes from
  /// 🔬 [Filter] according to ongoing 📚 `layerForRender`.
  /// - 📚 [SurfaceLayer]s disabled by [Filter.filteredLayers]
  /// will be delivered with `specRadius == 0.0`, regardless of [radiusByLayer].
  final SurfaceFX effect;

  /// Provide a `Set{}` to 👓 [filteredLayers] to specify which
  /// 📚 [SurfaceLayer]s will have an [effect] 🤹‍♂️ [SurfaceFX] enabled.
  final Set<SurfaceLayer> filteredLayers;

  /// A 📚 `Layer` that is not within [filteredLayers] will render no filter.
  final double? radiusFoundation, radiusMaterial, radiusChild;

  /// Returns a `Map<SurfaceLayer, double>` via [radiusByLayer],
  /// which returns the corresponding `renderedRadius_` field
  /// by 📚 [SurfaceLayer] `switch`.
  ///
  /// A 📚 `Layer` that is not within [filteredLayers] will render no filter.
  Map<SurfaceLayer, double> get radiusMap => <SurfaceLayer, double>{
        for (var layer in SurfaceLayer.values) layer: radiusByLayer(layer)
      };

  /// Returns the corresponding `radius` field by 📚 [SurfaceLayer] `switch`.
  ///
  /// A 📚 `Layer` that is not within [filteredLayers] will render no filter.
  double radiusByLayer(SurfaceLayer layer) {
    switch (layer) {
      case SurfaceLayer.FOUNDATION:
        return radiusFoundation ?? 0.0;
      case SurfaceLayer.MATERIAL:
        return radiusMaterial ?? 0.0;
      case SurfaceLayer.CHILD:
        return radiusChild ?? 0.0;
    }
  }
}
