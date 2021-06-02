/// ## 🌟 Surface Library:
/// ### 📚 `SurfaceLayer`
library surface;
// ignore_for_file: constant_identifier_names

/// {@template layer}
/// ### 📚 [SurfaceLayer]
/// Defines the three layers for rendering a 🌟 `Surface`.
/// - [SurfaceLayer.FOUNDATION], [SurfaceLayer.MATERIAL], [SurfaceLayer.CHILD]
/// {@endtemplate}
enum SurfaceLayer {
  /// ### 📚 Foundation Surface Layer
  /// Lowest layer of a 🌟 `Surface`; only present on a
  /// `Surface.founded`.
  FOUNDATION,

  /// ### 📚 Material Surface Layer
  /// The primary layer of a 🌟 `Surface`. It is here the `Material` is laid,
  /// background decorations are applied, and potentially where the
  /// `Tactility` resides.
  MATERIAL,

  /// ### 📚 Child Surface Layer
  /// The uppermost layer of a 🌟 `Surface`;
  /// ultimately to where the `Surface.child` is sent.
  CHILD
}

/// For obtaining a `Set<SurfaceLayer>` from a single entry.
extension LayerGrouping on SurfaceLayer {
  /// Wrap this `SurfaceLayer` in a `Set` with one entry.
  Set<SurfaceLayer> get toSet => <SurfaceLayer>{this};

  //`Set` Override: #### 👓 Trilayer
  /// - 📚 [SurfaceLayer.FOUNDATION], 📚 [SurfaceLayer.MATERIAL],
  /// 📚 [SurfaceLayer.CHILD]
  Set<SurfaceLayer> get asTrilayer => const <SurfaceLayer>{
        SurfaceLayer.FOUNDATION,
        SurfaceLayer.MATERIAL,
        SurfaceLayer.CHILD,
      };

  /// ###`Set` Override: 👓 Inner Bilayer
  /// - 📚 [SurfaceLayer.MATERIAL], 📚 [SurfaceLayer.CHILD]
  Set<SurfaceLayer> get asInnerBilayer => const <SurfaceLayer>{
        SurfaceLayer.MATERIAL,
        SurfaceLayer.CHILD,
      };

  /// #### `Set` Override: Base & Child
  /// - 📚 [SurfaceLayer.FOUNDATION], 📚 [SurfaceLayer.CHILD]
  Set<SurfaceLayer> get asBaseAndChild => const <SurfaceLayer>{
        SurfaceLayer.FOUNDATION,
        SurfaceLayer.CHILD,
      };

  /// #### `Set` Override: Base & Material
  /// - 📚 [SurfaceLayer.FOUNDATION], 📚 [SurfaceLayer.MATERIAL]
  Set<SurfaceLayer> get asBaseAndMaterial => const <SurfaceLayer>{
        SurfaceLayer.FOUNDATION,
        SurfaceLayer.MATERIAL,
      };
}
