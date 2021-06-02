/// ## 🌟 Surface Library:
/// ### 👆 `Tactility`
library surface;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart'
    show PointerEnterEventListener, PointerExitEventListener;

/// {@macro tactility}
class Tactility with Diagnosticable {
  /// {@template tactility}
  /// ### 👆 [Tactility]
  /// Not only does 👆 [tappable] provide `onTap` Callback functionality,
  /// it also adds [InkResponse] to the [Material] with a 🌟 `Surface`.
  ///
  /// ❓ [vibrates] is a convenience parameter
  /// to add a `HapticFeedback.vibrate` when tapped.
  ///
  /// Ink splash and highlight `Color`s may also be customized by
  /// [inkHighlightColor] and [inkSplashColor].
  ///
  /// ---
  /// 🌟 `Surface` comes bundled with [🏓 `ball`](https://pub.dev/packages/ball 'pub.dev: ball').
  ///
  /// Disable the default `BouncyBall.splashFactory` with
  /// ❓ [useThemeSplashFactory] or pass a specific
  /// [InteractiveInkFeatureFactory] with [splashFactory].
  ///
  /// ---
  /// Pass a `Function` to perform any time a pointer hovers or leaves
  /// the 🌟 `Surface` for which this 👆 `Tactility` describes via
  /// 🐭 [onMouseEnter] and 🐭 [onMouseExit].
  /// {@endtemplate}
  const Tactility({
    this.tappable = true,
    this.vibrates = false,
    this.inkSplashColor,
    this.inkHighlightColor,
    this.splashFactory,
    this.useThemeSplashFactory = false,
    this.onTap,
    this.onMouseEnter,
    this.onMouseExit,
  });

  /// A constant that describes a 🌟 `Surface` with no 👆 `Tactility`.
  static const none = Tactility(tappable: false);

  /// Not only does [tappable] mean the Surface will provide
  /// 👆 [onTap] Callback, it also enables `Color` parameters
  /// [inkHighlightColor] & [inkSplashColor].
  ///
  /// [vibrates] is a convenience to add a `HapticFeedback.vibrate()` `onTap`.
  final bool tappable, vibrates;

  /// If [tappable] is `true`, the [InkResponse] colors may be customized.
  final Color? inkSplashColor, inkHighlightColor;

  /// 🌟 `Surface` comes bundled with [🏓 `ball`](https://pub.dev/packages/ball 'pub.dev: ball'),
  ///
  /// Determine an [InteractiveInkFeatureFactory] specific to
  /// this 👆 `Tactility` with `splashFactory`.
  ///
  /// To bypass the default `BouncyBall.splashFactory` initialize
  /// [useThemeSplashFactory] to `true`.
  final InteractiveInkFeatureFactory? splashFactory;

  /// 🌟 `Surface` comes bundled with [🏓 `ball`](https://pub.dev/packages/ball 'pub.dev: ball'),
  ///
  /// Disable the default `BouncyBall.splashFactory` with this `bool`
  /// or pass a specific [InteractiveInkFeatureFactory] with [splashFactory].
  ///
  /// Default is `false`.
  final bool useThemeSplashFactory;

  /// Disabled when [tappable] is `false`.
  ///
  /// Pass a `Function` to perform any time the [InkResponse] is tapped
  /// on the 🌟 `Surface` for which this 👆 `Tactility` describes.
  final VoidCallback? onTap;

  /// Pass a `Function` to perform any time a pointer hovers
  /// over the 🌟 `Surface` for which this 👆 `Tactility` describes.
  final PointerEnterEventListener? onMouseEnter;

  /// Pass a `Function` to perform any time a pointer leaves after hovering
  /// over the 🌟 `Surface` for which this 👆 `Tactility` describes.
  final PointerExitEventListener? onMouseExit;

  /// 📋 Returns a copy of this `Tactility` with the given properties.
  Tactility copyWith({
    bool? tappable,
    bool? vibrates,
    Color? inkSplashColor,
    Color? inkHighlightColor,
    InteractiveInkFeatureFactory? splashFactory,
    bool? useThemeSplashFactory,
    VoidCallback? onTap,
  }) =>
      Tactility(
        tappable: tappable ?? this.tappable,
        vibrates: vibrates ?? this.vibrates,
        inkHighlightColor: inkHighlightColor ?? this.inkHighlightColor,
        inkSplashColor: inkSplashColor ?? this.inkSplashColor,
        splashFactory: splashFactory ?? this.splashFactory,
        useThemeSplashFactory:
            useThemeSplashFactory ?? this.useThemeSplashFactory,
        onTap: onTap ?? this.onTap,
      );

  /// If both are `null`, returns `null`.
  ///
  /// If either is `null`, replaced with `Tactility()`.
  static Tactility? lerp(Tactility? a, Tactility? b, double t) {
    if (a == null && b == null) return null;
    a ??= const Tactility();
    b ??= const Tactility();
    return Tactility(
      tappable: t < 0.5 ? a.tappable : b.tappable,
      vibrates: t < 0.5 ? a.vibrates : b.vibrates,
      inkHighlightColor:
          Color.lerp(a.inkHighlightColor, b.inkHighlightColor, t),
      inkSplashColor: Color.lerp(a.inkSplashColor, b.inkSplashColor, t),
      splashFactory: t < 0.5 ? a.splashFactory : b.splashFactory,
      useThemeSplashFactory:
          t < 0.5 ? a.useThemeSplashFactory : b.useThemeSplashFactory,
      onTap: t < 0.5 ? a.onTap : b.onTap,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(FlagProperty('tappable',
          value: tappable, ifFalse: '!tappable', ifTrue: 'tappable'))
      ..add(FlagProperty('providesFeedback',
          value: vibrates, ifTrue: 'providesFeedback'))
      ..add(ColorProperty('splashColor', inkSplashColor))
      ..add(ColorProperty('highlightColor', inkHighlightColor));
  }
}
