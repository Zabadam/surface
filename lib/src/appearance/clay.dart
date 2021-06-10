/// ## 🌟 Surface Library:
/// ### 🤏 `Clay`
library surface;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:animated_styled_widget/animated_styled_widget.dart' as morph;

import '../neu.dart';
import 'appearance.dart';
import 'layout.dart';

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
  List<morph.ShapeShadow> get shadows => Neu.shapeShadows(
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
              defaultValue: null))
        //
        ;
  }
}
