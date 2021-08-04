/// ## 🌟 Surface Library:
/// ### 🤏 `Clay`
library surface;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:neu/neu.dart';
import 'package:spectrum/spectrum.dart';
import 'package:animated_styled_widget/animated_styled_widget.dart' as morph;

// import '../neu.dart';
import 'appearance.dart';
import 'layout.dart';

const lightWhite = Color(0xFFE0E0E0);

class Clay extends Appearance with Diagnosticable {
  const Clay({
    this.curvature = Curvature.flat,
    this.swell = Swell.emboss,
    this.depth = 15,
    this.spread = 7.5,
    this.isSmooth = true,
    this.color = Colors.white,
    this.image,
    this.blendMode,
    Layout layout = const Layout(),
    bool? visible,
    double? opacity,
    BoxDecoration? foregroundDecoration,
    List<morph.ShapeShadow>? insetShadows,
    SystemMouseCursor? mouseCursor,
  }) : super(
          layout: layout,
          visible: visible,
          opacity: opacity,
          foregroundDecoration: foregroundDecoration,
          // decoration: const NeuBoxDecoration(...),
          insetShadows: insetShadows,
          shaderGradient: null, // shaderGradient,
          mouseCursor: mouseCursor,
        );

  @override
  BoxDecoration get decoration => Neu.boxDecoration(
        color: color,
        curvature: curvature,
        depth: depth,
        // `BoxDecoration.shadows` ([BoxShadow]s) ignored by [Appearance].
        // See `Appearance.shadows` ([ShapeShadow]s).
        // spread: spread,
        swell: swell,
        image: image,
        blendMode: blendMode,
      );

  @override
  // List<morph.ShapeShadow> get shadows => Neu.shapeShadows(
  List<morph.ShapeShadow> get shadows => neuShapeShadows(
        color: color,
        curvature: curvature,
        depth: depth,
        spread: spread,
        swell: swell,
        isGradient: isSmooth,
      );

  final Curvature curvature;
  final Swell swell;
  final int depth;
  final double spread;
  final bool isSmooth;
  final Color color;
  final DecorationImage? image;
  final BlendMode? blendMode;

  /// 📋 Return a copy of this 🤏 `Clay` with optional parameters
  /// replacing those of `this`.
  Clay copyClayWith({
    Curvature? curvature,
    Swell? swell,
    int? depth,
    double? spread,
    Color? color,
    DecorationImage? image,
    BlendMode? blendMode,
    Layout? layout,
    bool? visible,
    double? opacity,
    BoxDecoration? foregroundDecoration,
    List<morph.ShapeShadow>? insetShadows,
    SystemMouseCursor? mouseCursor,
  }) =>
      Clay(
        curvature: curvature ?? this.curvature,
        swell: swell ?? this.swell,
        depth: depth ?? this.depth,
        spread: spread ?? this.spread,
        color: color ?? this.color,
        image: image ?? this.image,
        blendMode: blendMode ?? this.blendMode,
        layout: layout ?? this.layout,
        visible: visible ?? this.visible,
        opacity: opacity ?? this.opacity,
        foregroundDecoration: foregroundDecoration ?? this.foregroundDecoration,
        insetShadows: insetShadows ?? this.insetShadows,
        mouseCursor: mouseCursor ?? this.mouseCursor,
      );

  @override
  void debugFillProperties(properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ColorProperty('color', color, defaultValue: null))
      ..add(DiagnosticsProperty<Curvature>('curvature', curvature,
          defaultValue: null))
      ..add(DiagnosticsProperty<Swell>('swell', swell, defaultValue: null))
      ..add(IntProperty('depth', depth, defaultValue: null))
      ..add(DoubleProperty('spread', spread, defaultValue: null))
      ..add(DiagnosticsProperty<DecorationImage>('image', image,
          defaultValue: null))
      ..add(DiagnosticsProperty<BlendMode>('blendMode', blendMode,
          defaultValue: null));
  }
}

/// [morph.ShapeShadow]s support [Gradient]s as the paint \
/// vs a standard [BoxShadow]'s tolerance of only `Color`s.
///
/// ![side-by-side comparison: isGradient & matching Swell; then isGradient: false & reversed Swells](https://i.imgur.com/PiFRZ6x.png 'side-by-side comparison: isGradient & matching Swell; then isGradient: false & reversed Swells')
///
/// ### Inset Shadows
/// If this method is used to generate `ShapeShadow`s for inset shadows,
/// such as `Appearance.insetShadows`, bear in mind the offset perspective
/// for the color shading ordering will be flipped--unless using a gradient
/// by `isGradient` set `true` (default).
///
/// This gradient-based `List<ShapeShadow>` used as inset shadows would
/// resemble an equivalent set of shadows used as standard background
/// `ShapeShadow`s.
///
/// A non-gradient return from this method (`isGradient` set `false`)
/// designed as inset shadows would need its [Swell] `swell` reversed to
/// opposite the expected behavior when used as background shadows to mimic
/// those background shadows.
///
/// ![isGradient == false, requires Swell reversal to achieve same effect with background and inset ShapeShadows](https://i.imgur.com/n2M9JNf.png 'isGradient == false, requires Swell reversal to achieve same effect with background and inset ShapeShadows')
///
/// ```dart
/// final appearance = Appearance(
///   // 🅰 The shadows from `Appearance` come not from this `decoration`
///   // (though it does provide a `List<BoxShadow>`) ...
///   decoration: Neu.boxDecoration(
///     color: Colors.red[900]!,
///     depth: 25,
///     // 🅰 (and so we may skip this spread parameter in this case)
///     // spread: 15,
///     swell: Swell.emboss,
///   ),
///   // 🅰 ...but from this separate field instead. As a major plus, these
///   // `ShapeShadow`s can be painted as a gradient instead of just a color!
///   shadows: Neu.shapeShadows(
///     isGradient: false, // default is true
///     color: Colors.red[900]!,
///     depth: 20,
///     spread: 12,
///     swell: Swell.emboss, // 🅱 Embossed shadows ...
///   ),
///   insetShadows: Neu.shapeShadows(
///     // 🅱 but because these ShapeShadows are not Gradients:
///     isGradient: false,
///     color: Colors.red[900]!,
///     depth: 20,
///     spread: 12,
///     // 🅱 ... the inset shadows need a Swell reversal to achieve the
///     // same visual effect as the background shadows.
///     swell: Swell.deboss,
///   ),
/// );
/// ```
///
/// ![isGradient == true, same Swell achieves same effect for background or inset ShapeShadows](https://i.imgur.com/gyXvxju.png 'isGradient == true, same Swell achieves same effect for background or inset ShapeShadows')
///
/// ```dart
/// final appearance = Appearance(
///   decoration: Neu.boxDecoration(
///     color: Colors.red[900]!,
///     depth: 25,
///   ),
///   shadows: Neu.shapeShadows(
///     color: Colors.red[900]!,
///     depth: 30,
///     spread: 12,
///   ),
///   insetShadows: Neu.shapeShadows(
///     color: Colors.red[900]!,
///     depth: 35,
///     spread: 8,
///     // `swell` can be the same for inset shadows when using a gradient
///     // to achieve the same effect on the inside and out.
///   ),
/// );
/// ```
List<morph.ShapeShadow> neuShapeShadows({
  Color color = lightWhite,
  Swell swell = Swell.emboss,
  int depth = 25,
  double spread = 7.5,
  double scale = 1.0,
  double offsetScalar = 1.0,
  // FOR GRADIENT:
  bool isGradient = true,
  Curvature curvature = Curvature.flat,
  AlignmentGeometry gradientBegin = Alignment.topLeft,
  AlignmentGeometry gradientEnd = Alignment.bottomRight,
}) {
  final blur = spread / swell.asScalar;
  final offset = spread * swell.asScalar * offsetScalar;

  final isSwollen = swell.asBool;
  final gradient = Neu.linearGradient(
    color: color,
    curvature: swell.toCurvature(curvature),
    depth: depth,
    swell: swell,
    begin: gradientBegin,
    end: gradientEnd,
  );
  final light = color.withWhite(depth);
  final lights = [light, light];
  final dark = color.withBlack(depth);
  final darks = [dark, dark];
  final shadows = List.generate(
        isGradient ? 3 : 1,
        (index) => morph.ShapeShadow(
          gradient: isGradient
              ? gradient
              // Create a flat gradient with two of the same color
              : LinearGradient(colors: (isSwollen) ? lights : darks),
          offset: index == 0
              ? Offset(-offset, -offset)
              : Offset(-offset / index * 2, -offset / index * 2),
          spreadRadius: (swell.asScalar - 1) - (isGradient ? spread : 0),
          blurRadius: isGradient ? blur * 2 : blur,
        ).scale(scale),
      ) +
      List.generate(
        isGradient ? 3 : 1,
        (index) => morph.ShapeShadow(
          gradient: isGradient
              ? gradient
              // Create a flat gradient with two of the same color
              : LinearGradient(colors: (isSwollen) ? darks : lights),
          offset: index == 0
              ? Offset(offset, offset)
              : Offset(offset / index * 2, offset / index * 2),
          spreadRadius: (swell.asScalar - 1) - (isGradient ? spread : 0),
          blurRadius: isGradient ? blur * 2 : blur,
        ).scale(scale),
      );
  return !isSwollen
      ? shadows.reversed.toList() // order shadow stack
      : shadows;
}
