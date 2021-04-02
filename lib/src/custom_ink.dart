/// ## 👆 A delightfully bouncy and position-mirroring reaction to user input on a piece of [Material].
/// To specify this type of ink splash for an
/// [InkWell], [InkResponse] or material [Theme]:
/// ```
/// InteractiveInkFeatureFactory customInk = CustomInk.splashFactory;
/// ```
library surface;

// Modified to custom_ink.dart by Adam Skelton (Zabadam) 2021.
// Original ink_ripple.dart:
// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;
import 'package:flutter/material.dart';

const Duration _kUnconfirmedRippleDuration = Duration(milliseconds: 600);
const Duration _kFadeInDuration = Duration(milliseconds: 125);
const Duration _kRadiusGrowthDuration = Duration(milliseconds: 500);
const Duration _kFadeOutDuration = Duration(milliseconds: 150);
const Duration _kCancelDuration = Duration(milliseconds: 75);

/// ? The fade out begins 225ms after the _fadeOutController starts. See confirm().
const double _kFadeOutIntervalStart = 225.0 / 500.0;

RectCallback _getClipCallback(
    RenderBox referenceBox, bool containedInkWell, RectCallback rectCallback) {
  if (rectCallback != null) {
    assert(containedInkWell);
    return rectCallback;
  }
  if (containedInkWell) return () => Offset.zero & referenceBox.size;
  return null;
}

double _getTargetRadius(RenderBox referenceBox, bool containedInkWell,
    RectCallback rectCallback, Offset position) {
  final Size size =
      rectCallback != null ? rectCallback().size : referenceBox.size;
  final double d1 = size.bottomRight(Offset.zero).distance;
  final double d2 =
      (size.topRight(Offset.zero) - size.bottomLeft(Offset.zero)).distance;
  return math.max(d1, d2) / 2;
}

class _CustomInkFactory extends InteractiveInkFeatureFactory {
  const _CustomInkFactory();

  @override
  InteractiveInkFeature create({
    @required MaterialInkController controller,
    @required RenderBox referenceBox,
    @required Offset position,
    @required Color color,
    @required TextDirection textDirection,
    bool containedInkWell = false,
    RectCallback rectCallback,
    BorderRadius borderRadius,
    ShapeBorder customBorder,
    double radius,
    VoidCallback onRemoved,
  }) {
    return CustomInk(
      controller: controller,
      referenceBox: referenceBox,
      position: position,
      color: color,
      containedInkWell: containedInkWell,
      rectCallback: rectCallback,
      borderRadius: borderRadius,
      customBorder: customBorder,
      radius: radius,
      onRemoved: onRemoved,
      textDirection: textDirection,
    );
  }
}

/// 👆 A delightfully bouncy and position-mirroring reaction to user input
/// on a piece of [Material].
///
/// A circular ink feature whose origin immediately moves from input touch point
/// to an X- and Y-mirrored point opposite the touch point; and whose radius
/// expands from 0% of the final radius to twice that of the radius.
/// The splash origin bounce-animates to the target mirror point of its
/// [referenceBox] as it grows in radius and fades-in.
///
/// This object is rarely created directly. Instead of creating a [CustomInk],
/// consider using an [InkResponse] or [InkWell] widget, which uses
/// gestures (such as tap and long-press) to trigger ink splashes. This class
/// is used when the [Theme]'s [ThemeData.splashFactory] is [CustomInk.splashFactory].
///
/// See also:
///
///  * [InkRipple], which is a built-in ink splash feature that expands less
///    aggressively than the custom ink.
///  * [InkSplash], which is a built-in ink splash feature that expands less
///    aggressively than the ripple.
///  * [InkResponse], which uses gestures to trigger ink highlights and ink
///    splashes in the parent [Material].
///  * [InkWell], which is a rectangular [InkResponse] (the most common type of
///    ink response).
///  * [Material], which is the widget on which the ink splash is painted.
///  * [InkHighlight], which is an ink feature that emphasizes a part of a
///    [Material].
class CustomInk extends InteractiveInkFeature {
  /// Begin a ripple, centered at [position] relative to [referenceBox].
  ///
  /// The [controller] argument is typically obtained via
  /// `Material.of(context)`.
  ///
  /// If [containedInkWell] is true, then the ripple will be sized to fit
  /// the well rectangle, then clipped to it when drawn. The well
  /// rectangle is the box returned by [rectCallback], if provided, or
  /// otherwise is the bounds of the [referenceBox].
  ///
  /// If [containedInkWell] is false, then [rectCallback] should be null.
  /// The ink ripple is clipped only to the edges of the [Material].
  /// This is the default.
  ///
  /// When the ripple is removed, [onRemoved] will be called.
  CustomInk({
    @required MaterialInkController controller,
    @required RenderBox referenceBox,
    @required Offset position,
    @required Color color,
    @required TextDirection textDirection,
    bool containedInkWell = false,
    RectCallback rectCallback,
    BorderRadius borderRadius,
    ShapeBorder customBorder,
    double radius,
    VoidCallback onRemoved,
  })  : assert(color != null),
        assert(position != null),
        assert(textDirection != null),
        _position = position,
        _borderRadius = borderRadius ?? BorderRadius.zero,
        _customBorder = customBorder,
        _textDirection = textDirection,
        _targetRadius = radius ??
            _getTargetRadius(
                referenceBox, containedInkWell, rectCallback, position),
        _clipCallback =
            _getClipCallback(referenceBox, containedInkWell, rectCallback),
        super(
            controller: controller,
            referenceBox: referenceBox,
            color: color,
            onRemoved: onRemoved) {
    assert(_borderRadius != null);

    /// Immediately begin fading-in the initial splash.
    _fadeInController =
        AnimationController(duration: _kFadeInDuration, vsync: controller.vsync)
          ..addListener(controller.markNeedsPaint)
          ..forward();
    _fadeIn = _fadeInController.drive(IntTween(
      begin: 0,
      end: color.alpha,
    ));

    /// Controls the splash radius and its center. Starts upon confirm.
    _radiusController = AnimationController(
        duration: _kUnconfirmedRippleDuration, vsync: controller.vsync)
      ..addListener(controller.markNeedsPaint)
      ..forward();

    /// Initial splash diameter is 0% of the target diameter,
    /// final diameter is twice as large as the target diameter.
    _radius = _radiusController.drive(Tween<double>(
      // begin: _targetRadius * 0.05,
      begin: 0,
      end: _targetRadius * 2,
    ).chain(_radiusCurveTween));

    /// Controls the splash radius and its center. Starts upon confirm however its
    /// Interval delays changes until the radius expansion has completed.
    _fadeOutController = AnimationController(
        duration: _kFadeOutDuration, vsync: controller.vsync)
      ..addListener(controller.markNeedsPaint)
      ..addStatusListener(_handleAlphaStatusChanged);
    _fadeOut = _fadeOutController.drive(
      IntTween(
        begin: color.alpha,
        end: 0,
      ).chain(_fadeOutIntervalTween),
    );

    controller.addInkFeature(this);
  }

  final Offset _position;
  final BorderRadius _borderRadius;
  final ShapeBorder _customBorder;
  final double _targetRadius;
  final RectCallback _clipCallback;
  final TextDirection _textDirection;

  Animation<double> _radius;
  AnimationController _radiusController;

  Animation<int> _fadeIn;
  AnimationController _fadeInController;

  Animation<int> _fadeOut;
  AnimationController _fadeOutController;

  /// Used to specify this type of ink splash for an [InkWell], [InkResponse]
  /// or material [Theme].
  static const InteractiveInkFeatureFactory splashFactory = _CustomInkFactory();

  static final Animatable<double> _radiusCurveTween =
      CurveTween(curve: Curves.easeInQuint);

  static final Animatable<double> _fadeOutIntervalTween =
      CurveTween(curve: const Interval(_kFadeOutIntervalStart, 1));

  @override
  void confirm() {
    _radiusController
      ..duration = _kRadiusGrowthDuration
      ..forward();

    /// This confirm may have been preceded by a cancel.
    _fadeInController.forward();
    _fadeOutController.animateTo(1.0, duration: _kFadeOutDuration);
  }

  @override
  void cancel() {
    _fadeInController.stop();

    /// Watch out: setting _fadeOutController's value to 1.0 will
    /// trigger a call to _handleAlphaStatusChanged() which will
    /// dispose _fadeOutController.
    final double fadeOutValue = 1.0 - _fadeInController.value;
    _fadeOutController.value = fadeOutValue;
    if (fadeOutValue < 1.0)
      _fadeOutController.animateTo(1.0, duration: _kCancelDuration);
  }

  void _handleAlphaStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed) dispose();
  }

  @override
  void dispose() {
    _radiusController.dispose();
    _fadeInController.dispose();
    _fadeOutController.dispose();
    super.dispose();
  }

  @override
  void paintFeature(Canvas canvas, Matrix4 transform) {
    final int alpha =
        _fadeInController.isAnimating ? _fadeIn.value : _fadeOut.value;
    final Paint paint = Paint()..color = color.withAlpha(alpha);

    /// Mirror splash around [referenceBox.size.center] from [_position]
    final double dx =
        -(_position.dx.toDouble() - referenceBox.size.center(Offset.zero).dx);
    final double dy = 0.75 *
        -(_position.dy.toDouble() - referenceBox.size.center(Offset.zero).dy);

    final Offset mirrorTouch = Offset.lerp(
      _position,
      referenceBox.size.center(
        Offset(dx, dy),
      ),
      Curves.elasticOut.transform(_radiusController.value),
    );

    paintInkCircle(
      canvas: canvas,
      transform: transform,
      paint: paint,
      center: mirrorTouch,
      textDirection: _textDirection,
      radius: _radius.value,
      customBorder: _customBorder,
      borderRadius: _borderRadius,
      clipCallback: _clipCallback,
    );
  }
}
