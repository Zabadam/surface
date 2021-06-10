/// Neumorphic/Clay implementation
library surface;

import 'package:flutter/painting.dart';

import 'package:animated_styled_widget/animated_styled_widget.dart' as morph;

import 'goodies.dart';

const _default = Color(0xFFE0E0E0);

// ignore: constant_identifier_names
enum _Degree { STANDARD, SUPER }

/// A description of the appearance of "curvature" of `Neu` colors
/// based on the ordering of returned shaded colors.
enum Curvature {
  /// No curvature. The gradient will be just the one color with no shading.
  flat,

  /// Appears to *really* curve inward, toward the back of the surface,
  /// forming a "cave-like" appearance out of the color shading.
  ///
  /// Shading is opposite when comparing shadows to gradient.
  superconcave,

  /// Appears to curve inward, toward the back of the surface,
  /// forming a "cave-like" appearance out of the color shading.
  ///
  /// Shading is opposite when comparing shadows to gradient.
  concave,

  /// Appears to curve outward, toward the viewer, forming a round
  /// "bubble-like" appearance out of the color shading.
  ///
  /// Shading for shadows and gradient match.
  convex,

  /// Appears to *really* curve outward, toward the viewer, forming a round
  /// "bubble-like" appearance out of the color shading.
  ///
  /// Shading for shadows and gradient match.
  superconvex,
}

extension CurvatureUtils on Curvature {
  _Degree get _asDegree {
    switch (this) {
      case Curvature.flat:
        return _Degree.STANDARD;
      case Curvature.superconcave:
        return _Degree.SUPER;
      case Curvature.concave:
        return _Degree.STANDARD;
      case Curvature.convex:
        return _Degree.STANDARD;
      case Curvature.superconvex:
        return _Degree.SUPER;
    }
  }

  List<Color> toColors({
    Color color = _default,
    int depth = 25,
  }) {
    switch (this) {
      case Curvature.flat:
        return [color, color];
      case Curvature.superconcave:
        return [
          color.withBlack((depth * 1.5).round()),
          color,
          color.withWhite((depth * 1.5).round()),
        ];
      case Curvature.concave:
        return [
          color.withBlack(depth),
          color,
          color.withWhite(depth),
        ];
      case Curvature.convex:
        return [
          color.withWhite(depth),
          color,
          color.withBlack(depth),
        ];
      case Curvature.superconvex:
        return [
          color.withWhite((depth * 1.5).round()),
          color,
          color.withBlack((depth * 1.55).round()),
        ];
    }
  }
}

/// A representation of a surface's *boss* or how it "swells".
///
/// Consider Braille or a hammered decorative lump on a metal shield to be an
/// example of [emboss].
///
/// Flip that shield or Braille over 180°, and the inset nature
/// of these lumps is now described as [deboss]ed.
enum Swell {
  /// Represents the appearance of a *large* protuberance or lump.
  ///
  /// Considering the front of a credit card, the raised letters and numbers
  /// are an example of embossment.
  superemboss,

  /// Represents the appearance of a protuberance or lump.
  ///
  /// Considering the front of a credit card, the raised letters and numbers
  /// are an example of embossment.
  emboss,

  /// Inset as opposed to protruding.
  ///
  /// May already appear "pressed" in the context of a interactive surface.
  deboss,

  /// *Very* inset as opposed to protruding.
  ///
  /// May already appear "pressed" in the context of a interactive surface.
  superdeboss,
}

extension SwellUtils on Swell {
  _Degree get _asDegree {
    switch (this) {
      case Swell.superemboss:
        return _Degree.SUPER;
      case Swell.emboss:
        return _Degree.STANDARD;
      case Swell.deboss:
        return _Degree.STANDARD;
      case Swell.superdeboss:
        return _Degree.SUPER;
    }
  }

  /// Whether or not `this` [Swell] would classify as "swollen".
  ///
  /// #### Super/emboss *is* swollen:
  /// - returns `true`
  ///
  /// #### Super/deboss *is not* swollen:
  /// - returns `false`
  bool get asBool {
    switch (this) {
      case Swell.superemboss:
        return true;
      case Swell.emboss:
        return true;
      case Swell.deboss:
        return false;
      case Swell.superdeboss:
        return false;
    }
  }

  /// Returns a value by which multiplication may be acceptable;
  /// that is, a relatively small scalar like `1.0` or `1.5`.
  double get asScalar => (_asDegree == _Degree.SUPER) ? 1.5 : 1.0;

  /// This conversion is useful in the case of [Neu.shapeShadows] where the
  /// offset of appropriately-shaded shadows is not only important, but the
  /// progression of the gradient as well -- considering that
  /// [morph.ShapeShadow] accepts a [Gradient] over a simple color.
  ///
  /// The `considerCurvature` serves to transfer its "super" status.
  ///
  /// - Super/emboss return convex
  ///   - "super" if `considerCurvature` is "super"
  /// - Super/deboss return concave
  ///   - "super" if `considerCurvature` is "super"
  Curvature toCurvature(Curvature considerCurvature) {
    switch (this) {
      case Swell.superemboss:
        // Checks for `considerCurvature` to make an exact match
        // return (considerCurvature == Curvature.superconvex)

        // Checks for `considerCurvature` to make a [_Degree] match
        return (considerCurvature._asDegree == _Degree.SUPER)
            ? Curvature.superconvex
            : Curvature.convex;
      case Swell.emboss:
        // return (considerCurvature == Curvature.superconvex)
        return (considerCurvature._asDegree == _Degree.SUPER)
            ? Curvature.superconvex
            : Curvature.convex;
      case Swell.deboss:
        // return (considerCurvature == Curvature.superconcave)
        return (considerCurvature._asDegree == _Degree.SUPER)
            ? Curvature.superconcave
            : Curvature.concave;
      case Swell.superdeboss:
        // return (considerCurvature == Curvature.superconcave)
        return (considerCurvature._asDegree == _Degree.SUPER)
            ? Curvature.superconcave
            : Curvature.concave;
    }
  }

  /// Returns a value by which interger division may be acceptable;
  /// that is, a relatively small scalar like `1.0` or `2.0` or the
  /// passed `depth` itself as a neutralizing divisor.
  double toShadeDivisor({required int depth}) {
    switch (this) {
      case Swell.superemboss:
        // Will actually brighten the color as a negative parameter to
        // `color.withBlack()` in [Neu.linearGradient].
        return -2.5;
      case Swell.emboss:
        // Will actually result in the resultant color of `color.withBlack()`
        // in [Neu.linearGradient] being shaded by `withBlack(1)`. Close.
        return depth * 1.0;
      case Swell.deboss:
        // Has [Neu.linearGradient] shade its `color.withBlack(depth ~/ 2.0)`
        // so its `depth` is halved:
        return 2.0;
      case Swell.superdeboss:
        // Has [Neu.linearGradient] shade its `color.withBlack(depth)`
        // because its `depth` is divided by 1.0:
        return 1.0;
    }
  }
}

/// - [Neu.linearGradient]
/// - [Neu.boxShadows]
///   - [Neu.shapeShadows]
/// - [Neu.boxDecoration]
/// - [Neu.shapeDecoration]
abstract class Neu {
  static Gradient linearGradient({
    Color color = _default,
    Curvature curvature = Curvature.convex,
    Swell swell = Swell.emboss,
    int depth = 25,
    AlignmentGeometry begin = Alignment.topLeft,
    AlignmentGeometry end = Alignment.bottomRight,
  }) =>
      LinearGradient(
        colors: curvature.toColors(
          color:
              color.withBlack(depth ~/ swell.toShadeDivisor(depth: depth) - 1),
          depth: depth,
        ),
        begin: begin,
        end: end,
      );

  static List<BoxShadow> boxShadows({
    Color color = _default,
    Swell swell = Swell.emboss,
    int depth = 25,
    double spread = 7.5,
    double offsetScalar = 1.0,
    double scale = 1.0,
  }) {
    final blur = spread / swell.asScalar;
    final offset = spread * offsetScalar;

    final isSwollen = swell.asBool;
    final lightOffset = isSwollen ? -offset : offset;
    final light = BoxShadow(
      color: color.withWhite(depth * swell.asScalar.toInt()),
      offset: Offset(lightOffset, lightOffset),
      spreadRadius: (swell.asScalar - 1),
      blurRadius: blur,
    ).scale(scale);

    return [
      // BoxShadow(
      //   color: color,
      //   blurRadius: spread,
      // ),
      if (isSwollen) light,
      BoxShadow(
        color: color.withBlack(depth * swell.asScalar.toInt()),
        offset: Offset(-lightOffset, -lightOffset),
        spreadRadius: (swell.asScalar - 1),
        blurRadius: blur,
      ).scale(scale),
      if (!isSwollen) light,
    ];
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
  static List<morph.ShapeShadow> shapeShadows({
    Color color = _default,
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
    final gradient = linearGradient(
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

  static BoxDecoration boxDecoration({
    Color color = _default,
    Curvature curvature = Curvature.flat,
    Swell swell = Swell.emboss,
    int depth = 25,
    double spread = 7.5,
    BoxShape shape = BoxShape.rectangle,
    BorderRadiusGeometry? borderRadius,
    BoxBorder? border,
    DecorationImage? image,
    BlendMode? blendMode,
    // AlignmentGeometry gradientBegin = Alignment.topLeft,
    // AlignmentGeometry gradientEnd = Alignment.bottomRight,
  }) =>
      BoxDecoration(
        backgroundBlendMode: blendMode,
        image: image,
        shape: shape,
        borderRadius: borderRadius,
        border: border,
        gradient: linearGradient(
          color: color,
          curvature: curvature,
          depth: depth,
          swell: swell,
          // begin: gradientBegin,
          // end: gradientEnd,
        ),
        boxShadow: boxShadows(
          color: color.withBlack(0),
          depth: depth,
          spread: spread,
          swell: swell,
        ),
      );

  static ShapeDecoration shapeDecoration({
    Color color = _default,
    Curvature curvature = Curvature.flat,
    Swell swell = Swell.emboss,
    int depth = 25,
    double spread = 7.5,
    ShapeBorder shape = const RoundedRectangleBorder(),
    DecorationImage? image,
    // AlignmentGeometry gradientBegin = Alignment.topLeft,
    // AlignmentGeometry gradientEnd = Alignment.bottomRight,
  }) =>
      ShapeDecoration(
        image: image,
        shape: shape,
        gradient: linearGradient(
          color: color,
          curvature: curvature,
          swell: swell,
          depth: depth,
          // begin: gradientBegin,
          // end:  gradientEnd,
        ),
        shadows: boxShadows(
          color: color,
          depth: depth,
          spread: spread,
          swell: swell,
        ),
      );

  /// If a [Rect] `rect` is provided, then a gradient shader is generated
  /// for this `TextStyle` instead of only a color. Also then consider the
  /// local `TextDirection` as it will not be obtained by this static method.
  ///
  /// The `baseStyle` defaults to an empty `TextStyle` and is offered as a
  /// convenience parameter. This base style will be returned, copied with
  /// the new color and shadows.
  static TextStyle textStyle({
    TextStyle baseStyle = const TextStyle(),
    Color color = _default,
    Swell swell = Swell.emboss,
    int depth = 25,
    double spread = 5,
    // FOR GRADIENT:
    Curvature curvature = Curvature.flat,
    Rect? rect,
    // TextDirection? textDirection,
  }) {
    final paint = Paint();
    if (rect != null) {
      paint.shader = linearGradient(
        color: color,
        curvature: curvature,
        depth: depth,
        swell: swell,
      ).createShader(rect /* textDirection: textDirection */);
    }
    final style = baseStyle.copyWith(
      color: color.withBlack(depth ~/ swell.toShadeDivisor(depth: depth) - 1),
      shadows: boxShadows(
        color: color,
        depth: depth,
        spread: spread,
        swell: swell,
        offsetScalar: 0.5,
      ),
    );
    return (paint.shader == null) ? style : style.copyWith(foreground: paint);
  }
}

class NeuBoxDecoration extends BoxDecoration {
  const NeuBoxDecoration({
    Color color = _default,
    this.curvature = Curvature.flat,
    this.swell = Swell.emboss,
    this.depth = 25,
    this.spread = 7.5,
    this.scaleFactor = 1.0,
    BoxShape shape = BoxShape.rectangle,
    BorderRadiusGeometry? borderRadius,
    BoxBorder? border,
    DecorationImage? image,
    BlendMode? blendMode,
    // AlignmentGeometry gradientBegin = Alignment.topLeft,
    // AlignmentGeometry gradientEnd = Alignment.bottomRight,
  }) : super(
          backgroundBlendMode: blendMode,
          border: border,
          borderRadius: borderRadius,
          color: color,
          image: image,
          shape: shape,
        );

  final Curvature curvature;
  final Swell swell;
  final int depth;
  final double spread, scaleFactor;

  @override
  List<BoxShadow> get boxShadow => Neu.boxShadows(
        color: color!, // non-nullable param of `NeuBoxDecoration`
        depth: depth,
        spread: spread,
        swell: swell,
        scale: scaleFactor,
      );

  @override
  Gradient get gradient => Neu.linearGradient(
        color: color!,
        curvature: curvature,
        depth: depth,
        swell: swell,
      );
}
