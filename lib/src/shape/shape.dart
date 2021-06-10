/// ## 🌟 Surface Library:
/// ### 🔰 `Shape`
library surface;

import 'package:flutter/foundation.dart'
    show Diagnosticable, DiagnosticPropertiesBuilder, DiagnosticsProperty;

import 'package:animated_styled_widget/animated_styled_widget.dart' as morph;

import '../wrappers.dart';
import 'corner.dart';

export '../wrappers.dart';
export 'corner.dart';
export 'foundation.dart';

//! ---
/// ### 🔰 [Shape]
/// Describe a rectangle-based `Shape` by declaring up to four `Corner`s
/// and an encompassing [CornerRadius].
/// Optionally provide a [Stroke].
/// ---
/// Wrapper for morphable_shape's [`RectangleShapeBorder`](https://github.com/KevinVan720/morphable_shape/blob/main/lib/src/shape_borders/rectangle.dart)
/// where `Corner`, `Corners`, and `CornerRadius` translate to a `ShapeBorder`.
class Shape with Diagnosticable {
  /// Describe a rectangle-based `Shape` by declaring up to four `Corner`s
  /// (defaults to [Corner.SQUARE]) and an encompassing [CornerRadius].
  /// Optionally provide a [Stroke].
  ///
  /// - 📐 `Corners` `Shape` description
  ///   - Use [corners] to customize all four [Corner]s in a [Shape].
  /// ---
  /// - ➖ [stroke] from [Stroke]
  ///   - Add a [Stroke] decoration to the edges of this [Shape].
  /// ---
  /// - 🔘 `CornerRadius` [radius]
  const Shape({
    this.corners = const Corners.roundWith(),
    this.stroke = Stroke.none,
    this.radius = CornerRadius.none,
  });

  /// Define the [Corner] appearance options for each
  /// of the four corners in a [Shape].
  final Corners corners;

  /// Define a [Stroke] decoration for the edges of this [Shape].
  final Stroke stroke;

  /// The 🔘 [radius] impacts the roundedness of default
  /// 📐 [Corner.ROUND] or bevel-depth of 📐 [Corner.BEVEL] corners.
  final CornerRadius radius;

  /// 📋 Returns a copy of this `Shape` with the given properties.
  Shape copyWith({
    Corners? corners,
    Stroke? stroke,
    CornerRadius? radius,
  }) =>
      Shape(
        corners: corners ?? this.corners,
        stroke: stroke ?? this.stroke,
        radius: radius ?? this.radius,
      );

  /// Convert this `Shape` into a [`RectangleShapeBorder`](https://github.com/KevinVan720/morphable_shape/blob/main/lib/src/shape_borders/rectangle.dart).
  morph.RectangleShapeBorder get toMorphable {
    final _topLeft = corners.topLeft == Corner.SQUARE
        ? morph.DynamicRadius.zero
        : corners.topLeft == Corner.NONE
            ? morph.DynamicRadius.circular(100.asPercent)
            : radius.topLeft;
    final _topRight = corners.topRight == Corner.SQUARE
        ? morph.DynamicRadius.zero
        : corners.topRight == Corner.NONE
            ? morph.DynamicRadius.circular(100.asPercent)
            : radius.topRight;
    final _bottomRight = corners.bottomRight == Corner.SQUARE
        ? morph.DynamicRadius.zero
        : corners.bottomRight == Corner.NONE
            ? morph.DynamicRadius.circular(100.asPercent)
            : radius.bottomRight;
    final _bottomLeft = corners.bottomLeft == Corner.SQUARE
        ? morph.DynamicRadius.zero
        : corners.bottomLeft == Corner.NONE
            ? morph.DynamicRadius.circular(100.asPercent)
            : radius.bottomLeft;

    return morph.RectangleShapeBorder(
      cornerStyles: morph.RectangleCornerStyles.only(
        topLeft: corners.topLeft.toMorphable,
        topRight: corners.topRight.toMorphable,
        bottomRight: corners.bottomRight.toMorphable,
        bottomLeft: corners.bottomLeft.toMorphable,
      ),
      border: stroke,
      borderRadius: (radius).copyWith(
        topLeft: _topLeft,
        topRight: _topRight,
        bottomRight: _bottomRight,
        bottomLeft: _bottomLeft,
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<Corners>('corners', corners))
      ..add(DiagnosticsProperty<Stroke>('stroke', stroke))
      ..add(DiagnosticsProperty<CornerRadius>('radius', radius));
  }
}
