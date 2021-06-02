/// Clay/neumorphic implementation
library surface;

import 'package:flutter/painting.dart';
import 'package:flutter/material.dart' show Colors;

import 'package:animated_styled_widget/animated_styled_widget.dart' as morph;

import 'goodies.dart';

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
  List<Color> toColors({
    Color color = Colors.white,
    int depth = 25,
  }) {
    switch (this) {
      case Curvature.flat:
        return [color, color];
      case Curvature.superconcave:
        return [
          color.withBlack((depth * 1.5).round()),
          color.withBlack(depth ~/ 1.5),
          color,
          color.withWhite(depth ~/ 1.5),
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
          color.withWhite(depth ~/ 1.5),
          color,
          color.withBlack(depth ~/ 1.5),
          color.withBlack((depth * 1.5).round()),
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

  /// Returns a value by which interger division may be acceptable;
  /// that is, a relatively small scalar like `1.0` or `2.0` or the
  /// passed `depth` itself as a neutralizing divisor.
  double toDouble({required int depth}) {
    switch (this) {
      case Swell.superemboss:
        // Will actually brighten the color as a negative parameter to
        // `color.withBlack()` in [Neu.linearGradient].
        return depth * -1.0;
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
    Color color = Colors.white,
    Curvature curvature = Curvature.convex,
    Swell swell = Swell.emboss,
    int depth = 25,
    AlignmentGeometry begin = Alignment.topLeft,
    AlignmentGeometry end = Alignment.bottomRight,
  }) =>
      LinearGradient(
        colors: curvature.toColors(
          color: color.withBlack(depth ~/ swell.toDouble(depth: depth)),
          depth: depth,
        ),
        begin: begin,
        end: end,
      );

  static List<BoxShadow> boxShadows({
    Color color = Colors.white,
    Swell swell = Swell.emboss,
    int depth = 25,
    double spread = 7.5,
  }) {
    final isSwollen = swell.asBool;
    final darkOffset = isSwollen ? -spread : spread;
    final lightOffset = isSwollen ? spread : -spread;
    final light = BoxShadow(
      color: color.withWhite(depth),
      offset: Offset(lightOffset, lightOffset),
      blurRadius: spread,
    );
    return [
      BoxShadow(
        color: color,
        blurRadius: spread,
      ),
      if (!isSwollen) light,
      BoxShadow(
        color: color.withBlack(depth),
        offset: Offset(darkOffset, darkOffset),
        blurRadius: spread,
      ),
      if (isSwollen) light,
    ];
  }

  static List<morph.ShapeShadow> shapeShadows({
    Color color = Colors.white,
    Curvature curvature = Curvature.convex,
    Swell swell = Swell.emboss,
    int depth = 25,
    double spread = 7.5,
    bool isGradient = true,
    AlignmentGeometry gradientBegin = Alignment.topLeft,
    AlignmentGeometry gradientEnd = Alignment.bottomRight,
  }) {
    final isSwollen = swell.asBool;
    final gradient = linearGradient(
      color: color,
      curvature: curvature,
      depth: depth,
      swell: swell,
      begin: gradientBegin,
      end: gradientEnd,
    );
    final light = color.withWhite(depth);
    final lights = [light, light];
    final dark = color.withBlack(depth);
    final darks = [dark, dark];
    final shadows = [
      morph.ShapeShadow(
        gradient: isGradient
            ? gradient
            // Create a flat gradient with two of the same color
            : LinearGradient(colors: (isSwollen) ? darks : lights),
        offset: Offset(-spread, -spread),
        blurRadius: spread,
      ),
      morph.ShapeShadow(
        gradient: isGradient
            ? gradient
            // Create a flat gradient with two of the same color
            : LinearGradient(colors: (isSwollen) ? lights : darks),
        offset: Offset(spread, spread),
        blurRadius: spread,
      ),
    ];
    return isSwollen ? shadows.reversed.toList() : shadows;
  }

  static BoxDecoration boxDecoration({
    Color color = Colors.white,
    Curvature curvature = Curvature.convex,
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
          color: color,
          depth: depth,
          spread: spread,
          swell: swell,
        ),
      );

  static ShapeDecoration shapeDecoration({
    Color color = Colors.white,
    Curvature curvature = Curvature.convex,
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
}
