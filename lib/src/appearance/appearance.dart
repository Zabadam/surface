/// ## 🌟 Surface Library:
/// ### 🎨 `Appearance`
library surface;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'package:animated_styled_widget/animated_styled_widget.dart' as morph;

import '../models/filter.dart';
import '../models/layer.dart';
import '../shape/shape.dart';
import 'layout.dart';

export '../models/filter.dart';
export 'clay.dart';
export 'glass.dart';
export 'layout.dart';

/// ### 🎨 [Appearance]
/// A collection of stylization parameters under one roof.
class Appearance with Diagnosticable {
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
  /// {@endtemplate}
  const Appearance({
    this.layout = const Layout(),
    this.filter = Filter.none,
    this.visible,
    this.opacity,
    this.foregroundDecoration,
    this.decoration,
    this.shadows,
    this.insetShadows,
    this.shaderGradient,
    this.mouseCursor,
  });

  /// Unavailable as `const` [Appearance]. \
  /// Direct access to some of the more buried properties,
  /// like `color` and `width`.
  ///
  /// Provide `width` and `height` with mere `double`s in place of `Length`s
  /// and these will populate a [Layout] automatically.
  ///
  /// `BoxDecoration` [Appearance.decoration] filled with provided `Color`,
  /// `Gradient`, or `DecorationImage`.
  Appearance.primitive({
    this.filter = Filter.none,
    this.visible,
    this.opacity,
    this.foregroundDecoration,
    this.shadows,
    this.insetShadows,
    this.shaderGradient,
    this.mouseCursor,
    Alignment? alignment,
    double? width,
    double? height,
    EdgeInsets? margin,
    EdgeInsets? padding,
    Color? color,
    Gradient? gradient,
    DecorationImage? image,
  })  : layout = Layout.primitive(
          alignment: alignment,
          width: width,
          height: height,
          margin: margin,
          padding: padding,
        ),
        decoration =
            BoxDecoration(color: color, gradient: gradient, image: image);

  /// Unavailable as `const` [Appearance]. \
  /// Direct access to some of the more buried properties, like `color`,
  /// and a reduction of less-used properties.
  ///
  /// `BoxDecoration` [Appearance.decoration] filled with provided `Color`,
  /// `Gradient`, or `DecorationImage`.
  ///
  /// Compared to [Appearance.primitive], this constructor accepts a full-fat
  /// [Layout], further reducing parameters.
  Appearance.primitiveWithLayout({
    this.layout = const Layout(),
    this.filter = Filter.none,
    this.visible,
    this.opacity,
    this.foregroundDecoration,
    this.shadows,
    this.insetShadows,
    this.shaderGradient,
    this.mouseCursor,
    Color? color,
    Gradient? gradient,
    DecorationImage? image,
  }) : decoration =
            BoxDecoration(color: color, gradient: gradient, image: image);

  /// A collection of 🔄 layout and sizing properties under one roof.
  final Layout layout;

  /// A 🔬 [Filter] provides options to customize `ImageFilter`
  /// appearance at all 📚 [SurfaceLayer]s.
  final Filter filter;

  /// Widget renders invisible only when this value is `false`.
  final bool? visible;

  /// If specified, this `double` between `0..1` corresponds to how
  /// "see-through" this `Appearance` is; `0` is invisible and `1` is opaque.
  final double? opacity;

  /// A `BoxDecoration` to apply as a background for this `Appearance`.
  final BoxDecoration? decoration;

  /// A `BoxDecoration` to apply as a foreground for this `Appearance`.
  final BoxDecoration? foregroundDecoration;

  /// A `List<ShapeShadow>` to apply behind this `Appearance`.
  final List<morph.ShapeShadow>? shadows;

  /// A `List<ShapeShadow>` to apply in front of this `Appearance`.
  final List<morph.ShapeShadow>? insetShadows;

  /// See [Gradient].
  final Gradient? shaderGradient;

  /// See [SystemMouseCursor].
  final SystemMouseCursor? mouseCursor;

  /// 📋 Return a copy of this 🎨 `Appearance` with optional parameters
  /// replacing those of `this`.
  Appearance copyWith({
    Layout? layout,
    Filter? filter,
    bool? visible,
    double? opacity,
    BoxDecoration? foregroundDecoration,
    BoxDecoration? decoration,
    List<morph.ShapeShadow>? shadows,
    List<morph.ShapeShadow>? insetShadows,
    Gradient? shaderGradient,
    SystemMouseCursor? mouseCursor,
  }) =>
      Appearance(
        layout: layout ?? this.layout,
        filter: filter ?? this.filter,
        visible: visible ?? this.visible,
        opacity: opacity ?? this.opacity,
        foregroundDecoration: foregroundDecoration ?? this.foregroundDecoration,
        decoration: decoration ?? this.decoration,
        shadows: shadows ?? this.shadows,
        insetShadows: insetShadows ?? this.insetShadows,
        shaderGradient: shaderGradient ?? this.shaderGradient,
        mouseCursor: mouseCursor ?? this.mouseCursor,
      );

  /// Convert this [Appearance] to a [morph.Style]
  /// given a [SurfaceLayer], [Shape], and [Filter].
  morph.Style asStyle({
    required SurfaceLayer layer,
    required Shape shape,
    EdgeInsets? peekInsets,
  }) {
    // print('Current Layer: $layer | radius: ${filter.radiusByLayer(layer)}');
    final isFiltered = filter.filteredLayers.contains(layer) &&
        filter.radiusByLayer(layer) > 0;
    final isBlurry = filter.filteredLayers.contains(SurfaceLayer.CHILD) &&
        filter.radiusByLayer(SurfaceLayer.CHILD) > 0;

    if (layer == SurfaceLayer.CHILD) {
      return morph.Style(
        shapeBorder: shape.copyWith(stroke: Stroke.none).toMorphable,
        imageFilter: isBlurry
            ? filter.effect(
                filter.radiusByLayer(SurfaceLayer.CHILD), SurfaceLayer.CHILD)
            : null,
      );
    }

    return morph.Style(
      shapeBorder: shape.toMorphable,
      backdropFilter:
          isFiltered ? filter.effect(filter.radiusByLayer(layer), layer) : null,
      visible: visible,
      opacity: opacity,
      alignment: layout.alignment,
      width: layout.width,
      height: layout.height,
      margin: layout.margin,
      padding:
          (layout.padding ?? EdgeInsets.zero) + (peekInsets ?? EdgeInsets.zero),
      foregroundDecoration: foregroundDecoration,
      backgroundDecoration: decoration,
      shadows: shadows,
      insetShadows: insetShadows,
      transform: layout.transform,
      transformAlignment: layout.transformAlignment,
      childAlignment: layout.childAlignment,
      textStyle: layout.textStyle,
      textAlign: layout.textAlign,
      shaderGradient: shaderGradient,
      mouseCursor: mouseCursor,
    );
  }

  /// TODO: Add the rest of the properties if [morph.Style] does not.
  @override
  void debugFillProperties(properties) {
    super.debugFillProperties(properties);
    properties
          ..add(DiagnosticsProperty<Layout>('layout', layout))
          ..add(DiagnosticsProperty<Filter>('filter', filter))
        //
        ;
  }
}
