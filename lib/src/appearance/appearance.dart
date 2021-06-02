/// ## 🌟 Surface Library:
/// ### 🎨 `Appearance`
library surface;

import 'package:flutter/rendering.dart';

import 'package:animated_styled_widget/animated_styled_widget.dart' as morph;

import '../models/filter.dart';
import '../models/surface_layer.dart';
import '../shape/shape.dart';
import '../wrappers.dart';

/// ### 🎨 [Appearance]
/// A collection of stylization parameters under one roof;
/// named to avoid `Type` clashing.
///
/// Wrapper for animated_styled_widget's [`Style`](https://github.com/KevinVan720/animated_styled_widget/blob/main/lib/src/style.dart)
/// where `Shape` and `Filter` are handled separately.
class Appearance {
  /// {@template appearance}
  /// A collection of 🎨 appearance stylization parameters under one roof.
  ///
  /// Consider these diagrams, but know that a `Surface.founded`
  /// is actually *two* `AnimatedStyledContainers` with bespoke customization.
  ///
  /// See also:
  /// - `Foundation`, which applies `Foundation.peek` as extra `EdgeInsets`
  /// between the two containers and has distinct `shape` and `style` paramters.
  /// - [Filter], which controls the `ImageFiltered`s & `BackdropFilter`s
  ///   - [Filter.radiusFoundation] corresponds to "BackdropFilter" in
  ///   the diagram below
  ///   - [Filter.radiusChild] corresponds to "ImageFilter" in the diagram below
  ///   - [Filter.radiusMaterial] applies to the background [decoration] &
  ///   as `Backdrop`
  /// - `Tactility`, for interaction-related parameters, colors
  ///
  /// ![](https://i.imgur.com/3oG6C57.png)
  /// ![](https://i.imgur.com/j8ioaX8.png)
  /// ##### Diagrams from [pub.dev: animated_styled_widget](https://pub.dev/packages/animated_styled_widget)
  /// Named to avoid `Type` clashing with `Style`.
  /// {@endtemplate}
  const Appearance({
    this.visible,
    this.opacity,
    this.alignment,
    this.width,
    this.height,
    this.margin,
    this.padding,
    this.foregroundDecoration,
    this.decoration,
    this.shadows,
    this.foregroundShadows,
    this.transform,
    this.transformAlignment,
    this.childAlignment,
    this.textStyle,
    this.textAlign,
    this.shaderGradient,
    this.mouseCursor,
  });

  /// Unavailable as `const` [Appearance].
  /// Reduced number of available parameters.
  ///
  /// Provide `width` and `height` with mere `double`s in place of `Length`s.
  ///
  /// `BoxDecoration` [Appearance.decoration] filled with provided `Color`,
  /// `Gradient`, or `DecorationImage`.
  ///
  /// This `decoration` instead is used as [Appearance.foregroundDecoration].
  Appearance.primitive({
    this.visible,
    this.opacity,
    this.alignment,
    double? width,
    double? height,
    this.margin,
    this.padding,
    Color? color,
    Gradient? gradient,
    DecorationImage? image,
    this.foregroundDecoration,
    this.shadows,
    this.foregroundShadows,
    this.shaderGradient,
    this.mouseCursor,
  })  : transform = null,
        transformAlignment = null,
        childAlignment = null,
        textStyle = null,
        textAlign = null,
        width = width?.asPX,
        height = height?.asPX,
        decoration =
            BoxDecoration(color: color, gradient: gradient, image: image);

  /// Widget renders invisible only when this value is `false`.
  final bool? visible;

  /// If specified, this `double` between `0..1` corresponds to how
  /// "see-through" this `Appearance` is; `0` is invisible and `1` is opaque.
  final double? opacity;

  /// Provide an `Alignment` for this `Appearance` as a whole.
  final Alignment? alignment;

  /// Contrain a `width` for this `Appearance`.
  final morph.Dimension? width;

  /// Contrain a `height` for this `Appearance`.
  final morph.Dimension? height;

  /// Define `EdgeInsets` for the outside of this `Appearance`.
  ///
  /// See `Foundation.peek`.
  final EdgeInsets? margin;

  /// Define `EdgeInsets` for the inside of this `Appearance`.
  ///
  /// See `Foundation.peek`.
  final EdgeInsets? padding;

  /// A `BoxDecoration` to apply as a background for this `Appearance`.
  final BoxDecoration? decoration;

  /// A `BoxDecoration` to apply as a foreground for this `Appearance`.
  final BoxDecoration? foregroundDecoration;

  /// A `List<ShapeShadow>` to apply behind this `Appearance`.
  final List<morph.ShapeShadow>? shadows;

  /// A `List<ShapeShadow>` to apply in front of this `Appearance`.
  final List<morph.ShapeShadow>? foregroundShadows;

  /// See [morph.SmoothMatrix4]. Aligned by [transformAlignment].
  final morph.SmoothMatrix4? transform;

  /// Provide an `Alignment` for the provided [transform].
  final Alignment? transformAlignment;

  /// Text related.
  final Alignment? childAlignment;

  /// Text related.
  final morph.DynamicTextStyle? textStyle;

  /// Text related.
  final TextAlign? textAlign;

  /// See [Gradient].
  final Gradient? shaderGradient;

  /// See [SystemMouseCursor].
  final SystemMouseCursor? mouseCursor;

  /// 📋 Return a copy of this `Styl` with optional parameters
  /// replacing those of `this`.
  Appearance copyWith({
    bool? visible,
    double? opacity,
    Alignment? alignment,
    morph.Dimension? width,
    morph.Dimension? height,
    EdgeInsets? margin,
    EdgeInsets? padding,
    BoxDecoration? foregroundDecoration,
    BoxDecoration? decoration,
    List<morph.ShapeShadow>? shadows,
    List<morph.ShapeShadow>? foregroundShadows,
    morph.SmoothMatrix4? transform,
    Alignment? transformAlignment,
    Alignment? childAlignment,
    morph.DynamicTextStyle? textStyle,
    TextAlign? textAlign,
    Gradient? shaderGradient,
    SystemMouseCursor? mouseCursor,
  }) =>
      Appearance(
        visible: visible ?? this.visible,
        opacity: opacity ?? this.opacity,
        alignment: alignment ?? this.alignment,
        width: width ?? this.width,
        height: height ?? this.height,
        margin: margin ?? this.margin,
        padding: padding ?? this.padding,
        foregroundDecoration: foregroundDecoration ?? this.foregroundDecoration,
        decoration: decoration ?? this.decoration,
        shadows: shadows ?? this.shadows,
        foregroundShadows: foregroundShadows ?? this.foregroundShadows,
        transform: transform ?? this.transform,
        transformAlignment: transformAlignment ?? this.transformAlignment,
        childAlignment: childAlignment ?? this.childAlignment,
        textStyle: textStyle ?? this.textStyle,
        textAlign: textAlign ?? this.textAlign,
        shaderGradient: shaderGradient ?? this.shaderGradient,
        mouseCursor: mouseCursor ?? this.mouseCursor,
      );

  /// Convert this [Appearance] to a [morph.Style]
  /// given a [SurfaceLayer], [Shape], and [Filter].
  morph.Style asStyle({
    required SurfaceLayer layer,
    required Shape shape,
    required Filter filter,
    EdgeInsets? peekInsets,
  }) =>
      morph.Style(
        shapeBorder: shape.toMorphable,
        backdropFilter: (filter.radiusByLayer(layer) > 0)
            ? filter.effect(filter.radiusByLayer(layer), layer)
            : null,
        imageFilter: (layer != SurfaceLayer.FOUNDATION &&
                filter.radiusByLayer(SurfaceLayer.CHILD) > 0)
            ? filter.effect(
                filter.radiusByLayer(SurfaceLayer.CHILD), SurfaceLayer.CHILD)
            : null,
        visible: visible,
        opacity: opacity,
        alignment: alignment,
        width: width,
        height: height,
        margin: margin,
        padding: (padding ?? EdgeInsets.zero) + (peekInsets ?? EdgeInsets.zero),
        foregroundDecoration: foregroundDecoration,
        backgroundDecoration: decoration,
        shadows: shadows,
        insetShadows: foregroundShadows,
        transform: transform,
        transformAlignment: transformAlignment,
        childAlignment: childAlignment,
        textStyle: textStyle,
        textAlign: textAlign,
        shaderGradient: shaderGradient,
        mouseCursor: mouseCursor,
      );
}
