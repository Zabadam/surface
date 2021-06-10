/// ## 🌟 Surface Library:
/// ### 🔰 `Shape` > 🔲 `Foundation`
library surface;

import 'dart:ui' as ui;

import 'package:flutter/foundation.dart'
    show
        Diagnosticable,
        DiagnosticPropertiesBuilder,
        DiagnosticsProperty,
        DoubleProperty;
import 'package:flutter/rendering.dart';

import '../appearance/appearance.dart';
import '../wrappers.dart';
import 'shape.dart';

//! ---
/// ### 🧱 [Foundation]
/// {@macro foundation}
class Foundation with Diagnosticable {
  /// {@template foundation}
  /// Consider 🧱 `Foundation` to be a description of how the 📚 `FOUNDATION`
  /// is exposed behind the 📚 `MATERIAL`, or as insets
  /// to 📚 `SurfaceLayer.MATERIAL` as part of a `Surface.founded`.
  ///
  /// ---
  /// Selected by this [exposure] declared [Alignment], chosen side(s) of
  /// padded space between 📚 `FOUNDATION` and 📚 `MATERIAL`
  /// are given special treatment:
  /// - made thicker when [ratio] `>= 1.0` (default `ratio == 2.0`)
  /// - or made thinner if `0 >` [ratio] `> 1.0`
  /// when compared to the standard 🔲 `peek` inset
  /// the other padded sides receive.
  ///
  /// `exposure` defaults [Alignment.center] such that no side(s) receive(s)
  /// special treatment *regardless* of [peek] / [ratio].
  /// {@endtemplate}
  const Foundation({
    this.shape,
    this.appearance,
    this.peek = 0.0,
    this.ratio = 1.0,
    this.exposure = Alignment.center,
  }) : assert(peek >= 0, '[Peek] > Provide a non-negative `peek`.');

  /// No 🔲 `peek` results in 📚 `FOUNDATION` being encompassed
  /// by 📚 `MATERIAL`.
  static const none =
      Foundation(peek: 0.0, ratio: 1.0, exposure: Alignment.center);

  ///     Peek(peek: 3.0, ratio: 2.0, alignment: Alignment.center);
  // ignore: constant_identifier_names
  static const DEFAULT =
      Foundation(peek: 3.0, ratio: 2.0, exposure: Alignment.center);

  /// A separate [Shape] for this `Foundation` as part of a `Surface.founded`.
  final Shape? shape;

  /// A separate [Appearance] for this `Foundation`
  /// as part of a `Surface.founded`.
  final Appearance? appearance;

  /// 🔲 [Foundation.peek] is applied as insets to 📚 `SurfaceLayer.MATERIAL`
  /// as part of a `Surface.founded`.
  ///
  /// It may be thought to function like a padding for the `child` content.
  ///
  /// To give this 🌟 `Surface` a `BorderSide` or [Stroke],
  /// see 🔰 [Shape.stroke].
  ///
  /// Having declared a side(s)✝ to receive special treatment by 🔀 [exposure],
  /// a 📏 [ratio] defines the scale by which to multiply this (these) inset(s):
  /// - Defaults to thicker `ratio == 2.0`
  /// - A larger `ratio` creates a more dramatic effect
  /// - Thinner side(s) possible by passing `0 > ratio > 1`
  ///
  /// ✝ More than one side is affected by a corner-set `Alignment`,
  /// such as [Alignment.bottomRight].
  final double peek, ratio;

  /// Selected by this `exposure` [Alignment], chosen side(s) of padded space
  /// between 📚 `FOUNDATION` and 📚 `MATERIAL` are given special treatment:
  /// - made thicker when [ratio] `>= 1.0` (default `ratio == 2.0`)
  /// - or made thinner if `0 >` [ratio] `> 1.0`
  ///
  /// `exposure` defaults [Alignment.center] such that no side(s) receive(s)
  /// special treatment *regardless* of [peek] / [ratio].
  final Alignment exposure;

  /// Establish the thickness/inset of each foundation inside "peek"
  /// (`padding` property for 📚 `SurfaceLayer.MATERIAL`)
  /// based on [peek] and considering [exposure] & [ratio].
  double get peekLeft => (exposure == Alignment.topLeft ||
          exposure == Alignment.centerLeft ||
          exposure == Alignment.bottomLeft)
      ? peek * ratio
      : peek;

  /// Establish the thickness/inset of each foundation inside "peek"
  /// (`padding` property for 📚 `SurfaceLayer.MATERIAL`)
  /// based on [peek] and considering [exposure] & [ratio].
  double get peekTop => (exposure == Alignment.topLeft ||
          exposure == Alignment.topCenter ||
          exposure == Alignment.topRight)
      ? peek * ratio
      : peek;

  /// Establish the thickness/inset of each foundation inside "peek"
  /// (`padding` property for 📚 `SurfaceLayer.MATERIAL`)
  /// based on [peek] and considering [exposure] & [ratio].
  double get peekRight => (exposure == Alignment.topRight ||
          exposure == Alignment.centerRight ||
          exposure == Alignment.bottomRight)
      ? peek * ratio
      : peek;

  /// Establish the thickness/inset of each foundation inside "peek"
  /// (`padding` property for 📚 `SurfaceLayer.MATERIAL`)
  /// based on [peek] and considering [exposure] & [ratio].
  double get peekBottom => (exposure == Alignment.bottomLeft ||
          exposure == Alignment.bottomCenter ||
          exposure == Alignment.bottomRight)
      ? peek * ratio
      : peek;

  /// Returns `EdgeInsets` where `left` is [peekLeft], `top` is [peekRight],
  /// etc.
  EdgeInsets get insets =>
      EdgeInsets.fromLTRB(peekLeft, peekTop, peekRight, peekBottom);

  /// 📋 Returns a copy of this `Peek` with the given properties.
  Foundation copyWith({
    Shape? shape,
    Appearance? appearance,
    double? peek,
    double? ratio,
    Alignment? exposure,
  }) =>
      Foundation(
        shape: shape ?? this.shape,
        appearance: appearance ?? this.appearance,
        peek: peek ?? this.peek,
        ratio: ratio ?? this.ratio,
        exposure: exposure ?? this.exposure,
      );

  /// If both are `null`, returns `null`.
  ///
  /// If either is `null`, replaced with [Foundation.none].
  static Foundation? lerp(Foundation? a, Foundation? b, double t) {
    if (a == null && b == null) return null;
    a ??= Foundation.none;
    b ??= Foundation.none;
    return Foundation(
      shape: t < 0.5 ? a.shape : b.shape,
      appearance: t < 0.5 ? a.appearance : b.appearance,
      peek: ui.lerpDouble(a.peek, b.peek, t)!,
      ratio: ui.lerpDouble(a.ratio, b.ratio, t)!,
      exposure: Alignment.lerp(a.exposure, b.exposure, t)!,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<Shape>('shape', shape))
      ..add(DiagnosticsProperty<Appearance>('style', appearance))
      ..add(DoubleProperty('peek', peek))
      ..add(DoubleProperty('ratio', ratio))
      ..add(DiagnosticsProperty<AlignmentGeometry>('exposure', exposure));
  }
}
