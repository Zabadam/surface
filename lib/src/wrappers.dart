/// ## 🌟 Surface Library:
/// ### Wrappers and Extensions
library surface;

import 'package:flutter/rendering.dart';

import 'package:animated_styled_widget/animated_styled_widget.dart' as morph;

import 'shape/shape.dart';

/// {@template corner_radius}
/// Provide `radius`, either [Circular] or [Elliptical],
/// that will apply to respective `Corner`s in a `Corners`.
/// {@endtemplate}
///
/// Wrapper for [morph.DynamicBorderRadius].
class CornerRadius extends morph.DynamicBorderRadius {
  /// Provide one `radius`, either a [Circular] or an [Elliptical],
  /// that will apply to all `Corner`s in a `Corners`.
  const CornerRadius.all(morph.DynamicRadius radius) : super.all(radius);

  /// Provide individual `radii`, either [Circular] or [Elliptical],
  /// that will apply to the respective `Corner` in a `Corners`.
  const CornerRadius.only({
    morph.DynamicRadius topLeft =
        const morph.DynamicRadius.circular(morph.Length(0)),
    morph.DynamicRadius topRight =
        const morph.DynamicRadius.circular(morph.Length(0)),
    morph.DynamicRadius bottomRight =
        const morph.DynamicRadius.circular(morph.Length(0)),
    morph.DynamicRadius bottomLeft =
        const morph.DynamicRadius.circular(morph.Length(0)),
  }) : super.only(
          topLeft: topLeft,
          topRight: topRight,
          bottomRight: bottomRight,
          bottomLeft: bottomLeft,
        );

  /// A rectangle with no `CornerRadius`.
  static const none = CornerRadius.all(Circular(morph.Length(0)));

  /// 📋 Return a copy of this `CornerRadius` with optional parameters
  /// replacing those of `this`.
  @override
  CornerRadius copyWith({
    morph.DynamicRadius? topLeft,
    morph.DynamicRadius? topRight,
    morph.DynamicRadius? bottomRight,
    morph.DynamicRadius? bottomLeft,
  }) =>
      CornerRadius.only(
        topLeft: topLeft ?? this.topLeft,
        topRight: topRight ?? this.topRight,
        bottomRight: bottomRight ?? this.bottomRight,
        bottomLeft: bottomLeft ?? this.bottomLeft,
      );
}

/// {@macro circular}
///
/// Wrapper for `DynamicRadius.circular`.
class Circular extends morph.DynamicRadius {
  /// {@template circular}
  /// The [radius] is used for both sides of the corresponding `Corner`.
  ///
  /// A `Circular` radius does not necessarily correspond to a "circle".
  ///
  /// The reference is to the symmetry of the radius itself,
  /// in comparison to [Elliptical].
  /// {@endtemplate}
  const Circular(morph.Length radius) : super.circular(radius);

  /// Without a radius, the result is a rectangular `Corner`.
  static const zero = morph.DynamicRadius.zero;
}

/// {@macro elliptical}
///
/// Wrapper for `DynamicRadius.elliptical`.
class Elliptical extends morph.DynamicRadius {
  /// {@template elliptical}
  /// The `Length`s [x] and [y] represent the two sides
  /// of the corresponding `Corner`.
  ///
  /// An `Elliptical` radius does not necessarily correspond to an "ellipse".
  /// Furthermore, if `x` and `y` are equal,
  /// this [Elliptical] is equivalent to a [Circular].
  ///
  /// The reference is to the asymmetry of the radius itself,
  /// in comparison to [Circular].
  /// {@endtemplate}
  const Elliptical(morph.Dimension x, morph.Dimension y)
      : super.elliptical(x, y);

  /// Without a radius, the result is a rectangular `Corner`.
  static const zero = morph.DynamicRadius.zero;

  /// 📋 Return a copy of this `Elliptical` with optional parameters
  /// replacing those of `this`.
  @override
  Elliptical copyWith({morph.Dimension? x, morph.Dimension? y}) =>
      Elliptical(x ?? this.x, y ?? this.y);
}

/// {@macro stroke}
///
/// Wrapper for [`DynamicBorderSide`](https://github.com/KevinVan720/morphable_shape/blob/main/lib/src/ui_data_classes/dynamic_border_side.dart)
class Stroke extends morph.DynamicBorderSide {
  /// {@template stroke}
  /// Various fields for a `Stroke` make up the sizing and appearance
  /// options for a [Shape]'s border edge.
  ///
  /// For [begin], [end], and [shift], use either a `Length` object or
  /// a `double` or `int` method for conversion, such as:
  /// - `720.asPX` or `0.5.asPerLongest`
  ///
  /// See [DoubleToLength].
  /// {@endtemplate}
  const Stroke({
    Color color = const Color(0xFF000000),
    double width = 1.0,
    BorderStyle style = BorderStyle.solid,
    Gradient? gradient,
    morph.Dimension? begin,
    morph.Dimension? end,
    morph.Dimension? shift,
    StrokeJoin strokeJoin = StrokeJoin.miter,
    StrokeCap strokeCap = StrokeCap.butt,
  }) : super(
          color: color,
          width: width,
          style: style,
          gradient: gradient,
          begin: begin,
          end: end,
          shift: shift,
          strokeJoin: strokeJoin,
          strokeCap: strokeCap,
        );

  /// No `Stroke` (boorder edge) at all; the default.
  static const none = Stroke(width: 0.0, style: BorderStyle.none);

  /// 📋 Return a copy of this `Stroke` with optional parameters
  /// replacing those of `this`.
  @override
  Stroke copyWith({
    Color? color,
    double? width,
    BorderStyle? style,
    Gradient? gradient,
    morph.Dimension? begin,
    morph.Dimension? end,
    morph.Dimension? shift,
    StrokeJoin? strokeJoin,
    StrokeCap? strokeCap,
  }) =>
      Stroke(
        color: color ?? this.color,
        width: width ?? this.width,
        style: style ?? this.style,
        gradient: gradient ?? this.gradient,
        begin: begin ?? this.begin,
        end: end ?? this.end,
        shift: shift ?? this.shift,
        strokeJoin: strokeJoin ?? this.strokeJoin,
        strokeCap: strokeCap ?? this.strokeCap,
      );
}

/// a la package:dimension \
/// I simply perfer these names, plus dartdoc.
extension DoubleToLength on double {
  /// Convert this `double` to a `Length` with default
  /// `LengthUnit.px` or specified `unit`.
  morph.Length toLength({morph.LengthUnit? unit}) =>
      (unit != null) ? morph.Length(this, unit: unit) : morph.Length(this);

  /// `Length` as *logical* pixels--the standard throughout Flutter.
  ///
  /// For a dynamic value, consider using this method on a `double`
  /// that is refreshed from device rotations/orientation changes.
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   final _width = MediaQuery.of(context).size.width;
  ///   final _style = Style(width: _width.asPX);
  ///   return Surface(style: _style);
  /// }
  /// ```
  morph.Length get asPX => morph.Length(this);

  /// `Length` as a percentage of the `parent` size.
  morph.Length get asPercent =>
      morph.Length(this, unit: morph.LengthUnit.percent);

  /// **"vw"** - `Length` as a percentage of the screen width.
  ///
  /// *Note:* this value is calculated at build time,
  /// not considering device rotations/orientation changes.
  morph.Length get asPerWidth => morph.Length(this, unit: morph.LengthUnit.vw);

  /// **"vh"** - `Length` as a percentage of the screen height.
  ///
  /// *Note:* this value is calculated at build time,
  /// not considering device rotations/orientation changes.
  morph.Length get asPerHeight => morph.Length(this, unit: morph.LengthUnit.vh);

  /// **"vmin"** - `Length` as a percentage of the shortest screen side.
  /// *Note:* this value is independent of rotation/orientation.
  morph.Length get asPerShortest =>
      morph.Length(this, unit: morph.LengthUnit.vmin);

  /// **"vmax"** - `Length` as a percentage of the longest screen side.
  /// *Note:* this value is independent of rotation/orientation.
  morph.Length get asPerLongest =>
      morph.Length(this, unit: morph.LengthUnit.vmax);
}

/// a la package:dimension \
/// I simply perfer these names, plus dartdoc.
extension IntToLength on int {
  /// Convert this `int` to a `Length` with default
  /// `LengthUnit.px` or specified `unit`.
  morph.Length toLength({morph.LengthUnit? unit}) => (unit != null)
      ? morph.Length(toDouble(), unit: unit)
      : morph.Length(toDouble());

  /// `Length` as *logical* pixels--the standard throughout Flutter.
  ///
  /// For a dynamic value, consider using this method on a `double`
  /// that is refreshed from device rotations/orientation changes.
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   final _width = MediaQuery.of(context).size.width;
  ///   final _style = Style(width: _width.asPX);
  ///   return Surface(style: _style);
  /// }
  /// ```
  morph.Length get asPX => morph.Length(toDouble());

  /// `Length` as a percentage of the `parent` size.
  morph.Length get asPercent =>
      morph.Length(toDouble(), unit: morph.LengthUnit.percent);

  /// **"vw"** - `Length` as a percentage of the screen width.
  ///
  /// *Note:* this value is calculated at build time,
  /// not considering device rotations/orientation changes.
  morph.Length get asPerWidth =>
      morph.Length(toDouble(), unit: morph.LengthUnit.vw);

  /// **"vh"** - `Length` as a percentage of the screen height.
  ///
  /// *Note:* this value is calculated at build time,
  /// not considering device rotations/orientation changes.
  morph.Length get asPerHeight =>
      morph.Length(toDouble(), unit: morph.LengthUnit.vh);

  /// **"vmin"** - `Length` as a percentage of the shortest screen side.
  /// *Note:* this value is independent of rotation/orientation.
  morph.Length get asPerShortest =>
      morph.Length(toDouble(), unit: morph.LengthUnit.vmin);

  /// **"vmax"** - `Length` as a percentage of the longest screen side.
  /// *Note:* this value is independent of rotation/orientation.
  morph.Length get asPerLongest =>
      morph.Length(toDouble(), unit: morph.LengthUnit.vmax);
}
