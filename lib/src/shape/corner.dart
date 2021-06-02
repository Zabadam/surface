/// ## 🌟 Surface Library:
/// ### 🔰 Shape > 📐 `Corner`
library surface;
// ignore_for_file: constant_identifier_names

import 'package:flutter/foundation.dart'
    show Diagnosticable, DiagnosticPropertiesBuilder, EnumProperty;

import 'package:animated_styled_widget/animated_styled_widget.dart' as morph
    hide IntToLengthExtension, DoubleToLengthExtension;

//! ---
/// ### 📐 [Corner]
/// {@template layer}
/// Primitive `Corner` appearance options for a [Corner] in a [Corners],
/// describing the geometry of a `Shape`.
/// {@endtemplate}
enum Corner {
  /// ### 📐 [NONE]
  /// No `Corner` is a circle/oval, or the quarter-circle
  /// that would make this corner. This `Corner` will "eat" more
  /// of the `Shape` than the other `Corner`s will.
  ///
  /// No 🔘 `Shape.radius` considered.
  NONE,

  /// ### 📐 [SQUARE]
  /// A squared `Corner` is that of a standard rectangle.
  /// No 🔘 `Shape.radius` considered.
  ///
  /// [CUTOUT] `Corner`s are similar but inverted, eating into the shape,
  /// and they do respect 🔘 `radius`.
  SQUARE,

  /// ### 📐 [CUTOUT]
  /// Cutout the corners with a rectangle sized
  /// by 🔘 `Shape.radius`.
  ///
  /// Just as [CONCAVE] inverts [ROUND], so does [CUTOUT] invert [SQUARE].
  CUTOUT,

  /// ### 📐 [ROUND]
  /// A rounded `Corner` is circle-like and
  /// "softens" / curves the corners by 🔘 `Shape.radius`.
  ///
  /// [CONCAVE] `Corner`s are similar but inverted, eating into the shape.
  ROUND,

  /// ### 📐 [CONCAVE]
  /// A concave `Corner` is circle-like, just as [Corner.ROUND], but eats
  /// into the shape by 🔘 `Shape.radius`.
  ///
  /// Just as [CUTOUT] inverts [SQUARE], so does [CONCAVE] invert [ROUND].
  CONCAVE,

  /// ### 📐 [BEVEL]
  /// A beveled `Corner` is a straight line that
  /// "cuts" the corners by 🔘 `Shape.radius`.
  BEVEL,
}

/// {@macro corner_ext}
extension CornerToCornerStyle on Corner {
  /// {@template corner_ext}
  /// Wrapper for morphable_shape's [`CornerStyle`](https://github.com/KevinVan720/morphable_shape/blob/main/lib/src/ui_data_classes/corner_style.dart)
  /// where the additional [Corner.NONE] and [Corner.SQUARE]
  /// are detected by `Shape.toMorphable`.
  /// {@endtemplate}
  morph.CornerStyle get toMorphable => (this == Corner.NONE)
      ? morph.CornerStyle.rounded
      : (this == Corner.SQUARE)
          ? morph.CornerStyle.rounded
          : (this == Corner.CUTOUT)
              ? morph.CornerStyle.cutout
              : (this == Corner.ROUND)
                  ? morph.CornerStyle.rounded
                  : (this == Corner.CONCAVE)
                      ? morph.CornerStyle.concave
                      : /*(this == Corner.BEVEL)?*/ morph.CornerStyle.straight;
}

//! ---
/// ### 📐 [Corners]
/// {@template corners}
/// The geometric description of a `Shape`.
///
/// Define the [Corner] appearance options for each
/// of the four corners in a `Shape`.
/// {@endtemplate}
class Corners with Diagnosticable {
  /// A `Corners` that accepts any [Corner] for each field,
  /// but defaults them all to [Corner.SQUARE].
  ///
  /// `const` constructors with different defaults for convenience:
  /// - [Corners.noneWith],
  /// - [Corners.roundWith], [Corners.concaveWith]
  /// - [Corners], [Corners.cutoutWith],
  /// - [Corners.bevelWith],
  const Corners({
    this.topLeft = Corner.SQUARE,
    this.topRight = Corner.SQUARE,
    this.bottomRight = Corner.SQUARE,
    this.bottomLeft = Corner.SQUARE,
  });

  /// A `Corners` that accepts any [Corner] for each field,
  /// but defaults them all to [Corner.NONE].
  const Corners.noneWith({
    this.topLeft = Corner.NONE,
    this.topRight = Corner.NONE,
    this.bottomRight = Corner.NONE,
    this.bottomLeft = Corner.NONE,
  });

  /// A `Corners` that accepts any [Corner] for each field,
  /// but defaults them all to [Corner.ROUND].
  const Corners.roundWith({
    this.topLeft = Corner.ROUND,
    this.topRight = Corner.ROUND,
    this.bottomRight = Corner.ROUND,
    this.bottomLeft = Corner.ROUND,
  });

  /// A `Corners` that accepts any [Corner] for each field,
  /// but defaults them all to [Corner.CONCAVE].
  const Corners.concaveWith({
    this.topLeft = Corner.CONCAVE,
    this.topRight = Corner.CONCAVE,
    this.bottomRight = Corner.CONCAVE,
    this.bottomLeft = Corner.CONCAVE,
  });

  /// A `Corners` that accepts any [Corner] for each field,
  /// but defaults them all to [Corner.CUTOUT].
  const Corners.cutoutWith({
    this.topLeft = Corner.CUTOUT,
    this.topRight = Corner.CUTOUT,
    this.bottomRight = Corner.CUTOUT,
    this.bottomLeft = Corner.CUTOUT,
  });

  /// A `Corners` that accepts any [Corner] for each field,
  /// but defaults them all to [Corner.BEVEL].
  const Corners.bevelWith({
    this.topLeft = Corner.BEVEL,
    this.topRight = Corner.BEVEL,
    this.bottomRight = Corner.BEVEL,
    this.bottomLeft = Corner.BEVEL,
  });

  /// ```
  ///  Corners.bevelWith(topRight: Corner.SQUARE, bottomLeft: Corner.SQUARE)
  /// ```
  static const BIBEVEL =
      Corners.bevelWith(topRight: Corner.SQUARE, bottomLeft: Corner.SQUARE);

  /// ```
  ///  Corners.bevelWith(topLeft: Corner.SQUARE, bottomRight: Corner.SQUARE)
  /// ```
  static const BIBEVEL_FLIP =
      Corners.bevelWith(topLeft: Corner.SQUARE, bottomRight: Corner.SQUARE);

  /// ```
  ///  Corners.bevelWith(topRight: Corner.ROUND, bottomLeft: Corner.ROUND)
  /// ```
  static const BIBEVEL_ROUND =
      Corners.bevelWith(topRight: Corner.ROUND, bottomLeft: Corner.ROUND);

  /// ```
  ///  Corners.bevelWith(topLeft: Corner.ROUND, bottomRight: Corner.ROUND)
  /// ```
  static const BIBEVEL_FLIP_ROUND =
      Corners.bevelWith(topLeft: Corner.ROUND, bottomRight: Corner.ROUND);

  /// ```
  ///  Corners.bevelWith(bottomRight: Corner.SQUARE, bottomLeft: Corner.SQUARE)
  /// ```
  static const BIBEVEL_TOP =
      Corners.bevelWith(bottomRight: Corner.SQUARE, bottomLeft: Corner.SQUARE);

  /// ```
  ///  Corners.bevelWith(topLeft: Corner.SQUARE, topRight: Corner.SQUARE)
  /// ```
  static const BIBEVEL_BOTTOM =
      Corners.bevelWith(topRight: Corner.SQUARE, topLeft: Corner.SQUARE);

  /// ### 📐 [Corner]
  /// Define which `Corner` shape to use for this corner.
  ///
  /// Configure 🔘 `CornerRadius` with `Shape.radius`
  ///
  /// - [Corner.NONE]
  /// - [Corner.ROUND]
  /// - [Corner.CONCAVE]
  /// - [Corner.SQUARE]
  /// - [Corner.CUTOUT]
  /// - [Corner.BEVEL]
  final Corner topLeft, topRight, bottomRight, bottomLeft;

  /// 📋 Returns a copy of this `Corners` with the given properties.
  Corners copyWith({
    Corner? topLeft,
    Corner? topRight,
    Corner? bottomRight,
    Corner? bottomLeft,
  }) =>
      Corners(
        topLeft: topLeft ?? this.topLeft,
        topRight: topRight ?? this.topRight,
        bottomRight: bottomRight ?? this.bottomRight,
        bottomLeft: bottomLeft ?? this.bottomLeft,
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(EnumProperty<Corner>('topLeft', topLeft))
      ..add(EnumProperty<Corner>('topRight', topRight))
      ..add(EnumProperty<Corner>('bottomRight', bottomRight))
      ..add(EnumProperty<Corner>('bottomLeft', bottomLeft));
  }
}
