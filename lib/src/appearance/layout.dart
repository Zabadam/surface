/// ## 🌟 Surface Library:
/// ### 🔄 `Layout`
library surface;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

import 'package:animated_styled_widget/animated_styled_widget.dart' as morph;

import '../wrappers.dart';

/// A collection of layout and sizing properties under one roof.
class Layout with Diagnosticable {
  /// A collection of layout and sizing properties under one roof.
  const Layout({
    this.alignment,
    this.width,
    this.height,
    this.margin,
    this.padding,
    this.transform,
    this.transformAlignment,
    this.childAlignment,
    this.textStyle,
    this.textAlign,
  });

  /// Unavailable as `const` [Layout]. \
  /// Reduced number of available parameters.
  ///
  /// Provide `width` and `height` with mere `double`s in place of `Length`s.
  Layout.primitive({
    this.alignment,
    double? width,
    double? height,
    this.margin,
    this.padding,
    this.childAlignment,
    this.textStyle,
    this.textAlign,
  })  : transform = null,
        transformAlignment = null,
        width = width?.asPX,
        height = height?.asPX;

  /// Provide an `Alignment` for this `Layout` as a whole within its parent.
  final Alignment? alignment;

  /// Contrain a `width` for this `Layout`.
  final morph.Dimension? width;

  /// Contrain a `height` for this `Layout`.
  final morph.Dimension? height;

  /// Define `EdgeInsets` for the outside of this `Layout`.
  final EdgeInsets? margin;

  /// Define `EdgeInsets` for the inside of this `Layout`.
  final EdgeInsets? padding;

  /// See [morph.SmoothMatrix4]. Aligned by [transformAlignment].
  final morph.SmoothMatrix4? transform;

  /// Provide an `Alignment` for the provided [transform].
  final Alignment? transformAlignment;

  /// Alignment within the `Surface` laid out by this `Layout`.
  final Alignment? childAlignment;

  /// A shared `TextStyle` that can intrinsically animate.
  final morph.DynamicTextStyle? textStyle;

  /// A shared `TextAlign`.
  final TextAlign? textAlign;

  /// 📋 Return a copy of this 🔄 `Layout` with optional parameters
  /// replacing those of `this`.
  Layout copyWith({
    Alignment? alignment,
    morph.Dimension? width,
    morph.Dimension? height,
    EdgeInsets? margin,
    EdgeInsets? padding,
    morph.SmoothMatrix4? transform,
    Alignment? transformAlignment,
    Alignment? childAlignment,
    morph.DynamicTextStyle? textStyle,
    TextAlign? textAlign,
  }) =>
      Layout(
        alignment: alignment ?? this.alignment,
        width: width ?? this.width,
        height: height ?? this.height,
        margin: margin ?? this.margin,
        padding: padding ?? this.padding,
        transform: transform ?? this.transform,
        transformAlignment: transformAlignment ?? this.transformAlignment,
        childAlignment: childAlignment ?? this.childAlignment,
        textStyle: textStyle ?? this.textStyle,
        textAlign: textAlign ?? this.textAlign,
      );

  // @override
  // void debugFillProperties(properties) {
  //   super.debugFillProperties(properties);
  // ignore: lines_longer_than_80_chars
  //   properties..add(DiagnosticsProperty<Alignment>('alignment', alignment, ifNull: null));
  // }
}
