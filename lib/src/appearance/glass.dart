/// ## 🌟 Surface Library:
/// ### 🔍 `Glass`
library surface;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:animated_styled_widget/animated_styled_widget.dart' as morph;

import '../models/filter.dart';
import 'appearance.dart';
import 'layout.dart';

export 'frost.dart';

class Glass extends Appearance with Diagnosticable {
  const Glass({
    this.blur = 10.0,
    this.selfBlurring = false,
    this.selfBlur = 0.0,
    this.color = const Color(0x33FFFFFF),
    this.gradient,
    this.image,
    this.blendMode,
    Layout layout = const Layout(),
    bool? visible,
    double? opacity,
    BoxDecoration? foregroundDecoration,
    List<morph.ShapeShadow>? shadows,
    List<morph.ShapeShadow>? insetShadows,
    Gradient? shaderGradient,
    SystemMouseCursor? mouseCursor,
  }) : super(
          layout: layout,
          visible: visible,
          opacity: opacity,
          foregroundDecoration: foregroundDecoration,
          shadows: shadows,
          insetShadows: insetShadows,
          shaderGradient: shaderGradient,
          mouseCursor: mouseCursor,
        );

  @override
  Filter get filter => Filter(
        effect: FX.blurry,
        radiusFoundation: blur,
        radiusMaterial: blur,
        radiusChild: selfBlurring ? selfBlur : 0,
      );

  @override
  BoxDecoration get decoration => BoxDecoration(
        color: color,
        gradient: gradient,
        image: image,
        backgroundBlendMode: blendMode,
      );

  final double blur;
  final bool selfBlurring;
  final double selfBlur;
  final Color color;
  final Gradient? gradient;
  final DecorationImage? image;
  final BlendMode? blendMode;

  /// 📋 Return a copy of this 🔍 `Glass` with optional parameters
  /// replacing those of `this`.
  Glass copyGlassWith({
    double? blur,
    bool? selfBlurring,
    double? selfBlur,
    Color? color,
    Gradient? gradient,
    DecorationImage? image,
    BlendMode? blendMode,
    Layout? layout,
    bool? visible,
    double? opacity,
    BoxDecoration? foregroundDecoration,
    List<morph.ShapeShadow>? insetShadows,
    SystemMouseCursor? mouseCursor,
  }) =>
      Glass(
        blur: blur ?? this.blur,
        selfBlur: selfBlur ?? this.selfBlur,
        selfBlurring: selfBlurring ?? this.selfBlurring,
        color: color ?? this.color,
        gradient: gradient ?? this.gradient,
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
          ..add(FlagProperty('selfBlurring',
              value: selfBlurring, ifTrue: '🧊 Self Blurring'))
          ..add(DoubleProperty('blur', blur, defaultValue: null))
          ..add(DoubleProperty('selfBlur', selfBlur, defaultValue: null))
          ..add(ColorProperty('color', color, defaultValue: null))
          ..add(DiagnosticsProperty<Gradient>('gradient', gradient,
              defaultValue: null))
          ..add(DiagnosticsProperty<DecorationImage>('image', image,
              defaultValue: null))
          ..add(DiagnosticsProperty<BlendMode>('blendMode', blendMode,
              defaultValue: null))
        //
        ;
  }
}
