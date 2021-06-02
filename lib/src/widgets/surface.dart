/// ## 🌟 `Surface`
/// A shapeable, layered, intrinsincally animated container Widget
/// offering convenient access to blurring `ImageFilter`s,
/// `Material` `InkResponse`, and `HapticFeedback`.
library surface;

import 'package:flutter/foundation.dart'
    show DiagnosticPropertiesBuilder, DiagnosticsProperty;
import 'package:flutter/rendering.dart'
    show PointerEnterEventListener, PointerExitEventListener;
import 'package:flutter/services.dart' show HapticFeedback;
import 'package:flutter/material.dart';

import 'package:ball/ball.dart';
import 'package:animated_styled_widget/animated_styled_widget.dart' as morph;

import '../appearance/appearance.dart';
import '../appearance/clay.dart';
import '../appearance/glass.dart';
import '../models/filter.dart';
import '../models/surface_layer.dart';
import '../models/tactility.dart';
import '../shape/foundation.dart';
import '../shape/shape.dart';
import '../wrappers.dart';

/// ### 🌟 `Surface`
/// #### Extended [`AnimatedStyledContainer`](https://pub.dev.packages/animated_styled_container) with Bespoke Layout
class Surface extends morph.AnimatedStyledContainer {
  /// ### 🌟 Founded `Surface`
  /// Create a bi-layered `Surface` for content. Customizable and responsive.
  ///
  /// Provide a 🔰 [Shape], 🎨 [Appearance], 🧱 [Foundation], 👆 [Tactility],
  /// and 🔬 [Filter], all defaultable, as well as a [duration] & [curve]
  /// for intrinsic animated state changes.
  ///
  /// Implements 📚 [SurfaceLayer.FOUNDATION], customizable with 🧱 [foundation]
  /// and certain parameters of 🔬 [filter].
  ///
  /// Many features available with [`AnimatedStyledContainer`](https://pub.dev.packages/animated_styled_container)
  /// have been pared back for 🌟 `Surface`, but an [animationID] and [onEnd]
  /// are still available, as well as mouse-listening callbacks.
  ///
  /// ### 🎨 Appearance
  /// A collection of stylization parameters under one roof.
  ///
  /// Consider these diagrams from the core `animated_styled_widget` package.
  ///
  /// See also:
  /// - `Foundation`, which applies `Foundation.peek` as extra `EdgeInsets`
  /// between the two containers and has distinct `shape` and `style` paramters.
  /// - [Filter], which controls the `ImageFiltered`s & `BackdropFilter`s
  ///   - [Filter.radiusFoundation] corresponds to "BackdropFilter" in
  ///   the diagram below
  ///   - [Filter.radiusChild] corresponds to "ImageFilter" in the diagram below
  ///   - [Filter.radiusMaterial] applies to the background `decoration` &
  ///   as `Backdrop`, but is padded by `Foundation.peek` in a `Surface.founded`
  /// - `Tactility`, for interaction-related parameters, colors
  ///
  /// ![](https://i.imgur.com/3oG6C57.png)
  /// ![](https://i.imgur.com/j8ioaX8.png)
  /// ##### Diagrams from [pub.dev: animated_styled_widget](https://pub.dev/packages/animated_styled_widget)
  /// Named to avoid `Type` clashing with `Style`.
  Surface.founded({
    Key? key,
    this.shape = const Shape(),
    this.appearance = const Appearance(),
    this.foundation = const Foundation(),
    this.tactility = const Tactility(),
    this.filter = const Filter(),
    Widget? child,
    Duration duration = const Duration(milliseconds: 400),
    Curve curve = Curves.ease,
    // String? animationID,
    VoidCallback? onEnd,
  }) : super(
          key: key,
          id: null, // '$animationID:foundation',
          style: (foundation.appearance ?? const Appearance()).asStyle(
            layer: SurfaceLayer.FOUNDATION,
            shape: foundation.shape ?? shape,
            filter: filter,
            peekInsets: EdgeInsets.fromLTRB(
              foundation.peekLeft + (appearance.margin?.left ?? 0),
              foundation.peekTop + (appearance.margin?.top ?? 0),
              foundation.peekRight + (appearance.margin?.right ?? 0),
              foundation.peekBottom + (appearance.margin?.bottom ?? 0),
            ),
          ),
          duration: duration,
          curve: curve,
          child: morph.AnimatedStyledContainer(
            id: null, // animationID,
            duration: duration,
            curve: curve,
            onEnd: onEnd,
            onMouseEnter: tactility.onMouseEnter,
            onMouseExit: tactility.onMouseExit,
            style: appearance
                .asStyle(
                  layer: SurfaceLayer.MATERIAL,
                  shape: shape,
                  filter: filter,
                )
                .copyWith(
                  padding: EdgeInsets.zero,
                ),
            child: Material(
              animationDuration: duration,
              color: Colors.transparent,
              // shape: shape.toMorphable,
              // TODO Look into `focus`, accessibility, nav
              child: InkResponse(
                canRequestFocus: tactility.tappable,
                // customBorder: shape.toMorphable,
                containedInkWell: true,
                highlightShape: BoxShape.rectangle,
                highlightColor: tactility.tappable
                    ? tactility.inkHighlightColor
                    : Colors.transparent,
                splashColor: tactility.tappable
                    ? tactility.inkSplashColor
                    : Colors.transparent,
                splashFactory: tactility.useThemeSplashFactory
                    ? null
                    : tactility.splashFactory ?? BouncyBall.splashFactory,
                onTap: tactility.tappable
                    ? () {
                        if (tactility.vibrates) HapticFeedback.vibrate();
                        tactility.onTap?.call();
                      }
                    : null,
                child: Padding(
                  padding: appearance.padding ?? EdgeInsets.zero,
                  child: child ?? const SizedBox(),
                ),
              ),
            ),
          ),
        );

  /// ### 🌟 Tactile [Surface]
  /// Create a `Surface` for content that is responsive to interaction.
  ///
  /// Provide a 🔰 [Shape], 🎨 [Appearance], 👆 [Tactility], and 🔬 [Filter],
  /// all defaultable, as well as a [duration] & [curve] for intrinsic
  /// animated state changes.
  ///
  /// Ignores any references to 📚 [SurfaceLayer.FOUNDATION].
  ///
  /// Many features available with [`AnimatedStyledContainer`](https://pub.dev.packages/animated_styled_container)
  /// have been pared back for 🌟 `Surface`, but an [animationID] and [onEnd]
  /// are still available, as well as mouse-listening callbacks.
  ///
  /// ### 🎨 Appearance
  /// A collection of stylization parameters under one roof.
  ///
  /// Consider these diagrams from the core `animated_styled_widget` package.
  ///
  /// See also:
  /// - `Foundation`, which applies `Foundation.peek` as extra `EdgeInsets`
  /// between the two containers and has distinct `shape` and `style` paramters.
  /// - [Filter], which controls the `ImageFiltered`s & `BackdropFilter`s
  ///   - [Filter.radiusFoundation] corresponds to "BackdropFilter" in
  ///   the diagram below
  ///   - [Filter.radiusChild] corresponds to "ImageFilter" in the diagram below
  ///   - [Filter.radiusMaterial] applies to the background `decoration` &
  ///   as `Backdrop`, but is padded by `Foundation.peek` in a `Surface.founded`
  /// - `Tactility`, for interaction-related parameters, colors
  ///
  /// ![](https://i.imgur.com/3oG6C57.png)
  /// ![](https://i.imgur.com/j8ioaX8.png)
  /// ##### Diagrams from [pub.dev: animated_styled_widget](https://pub.dev/packages/animated_styled_widget)
  /// Named to avoid `Type` clashing with `Style`.
  Surface.tactile({
    Key? key,
    this.shape = const Shape(),
    this.appearance = const Appearance(),
    this.tactility = const Tactility(),
    this.filter = const Filter(),
    Widget? child,
    Duration duration = const Duration(milliseconds: 400),
    Curve curve = Curves.ease,
    // String? animationID,
    VoidCallback? onEnd,
  })  : foundation = Foundation.none,
        super(
          key: key,
          id: null, // animationID,
          duration: duration,
          curve: curve,
          onEnd: onEnd,
          onMouseEnter: tactility.onMouseEnter,
          onMouseExit: tactility.onMouseExit,
          style: appearance
              .asStyle(
                layer: SurfaceLayer.MATERIAL,
                shape: shape,
                filter: filter,
              )
              .copyWith(padding: EdgeInsets.zero),
          child: Material(
            animationDuration: duration,
            color: Colors.transparent,
            // shape: shape.toMorphable,
            // TODO Look into `focus`, accessibility, nav
            child: InkResponse(
              canRequestFocus: tactility.tappable,
              // customBorder: shape.toMorphable,
              containedInkWell: true,
              highlightShape: BoxShape.rectangle,
              highlightColor: tactility.tappable
                  ? tactility.inkHighlightColor
                  : Colors.transparent,
              splashColor: tactility.tappable
                  ? tactility.inkSplashColor
                  : Colors.transparent,
              splashFactory: tactility.useThemeSplashFactory
                  ? null
                  : tactility.splashFactory ?? BouncyBall.splashFactory,
              onTap: tactility.tappable
                  ? () {
                      if (tactility.vibrates) HapticFeedback.vibrate();
                      tactility.onTap?.call();
                    }
                  : null,
              child: Padding(
                padding: appearance.padding ?? EdgeInsets.zero,
                child: child ?? const SizedBox(width: 0, height: 0),
              ),
            ),
          ),
        );

  /// ### 🌟 [Surface]
  /// Create a simple `Surface` for content.
  ///
  /// Provide a 🔰 [Shape], 🎨 [Appearance], and 🔬 [Filter],
  /// all defaultable, as well as a [duration] & [curve] for intrinsic
  /// animated state changes.
  ///
  /// Ignores any references to 📚 [SurfaceLayer.FOUNDATION].
  ///
  /// Many features available with [`AnimatedStyledContainer`](https://pub.dev.packages/animated_styled_container)
  /// have been pared back for 🌟 `Surface`, but an [animationID] and [onEnd]
  /// are still available, as well as mouse-listening callbacks.
  ///
  /// ### 🎨 Appearance
  /// A collection of stylization parameters under one roof.
  ///
  /// Consider these diagrams from the core `animated_styled_widget` package.
  ///
  /// See also:
  /// - `Foundation`, which applies `Foundation.peek` as extra `EdgeInsets`
  /// between the two containers and has distinct `shape` and `style` paramters.
  /// - [Filter], which controls the `ImageFiltered`s & `BackdropFilter`s
  ///   - [Filter.radiusFoundation] corresponds to "BackdropFilter" in
  ///   the diagram below
  ///   - [Filter.radiusChild] corresponds to "ImageFilter" in the diagram below
  ///   - [Filter.radiusMaterial] applies to the background `decoration` &
  ///   as `Backdrop`, but is padded by `Foundation.peek` in a `Surface.founded`
  /// - `Tactility`, for interaction-related parameters, colors
  ///
  /// ![](https://i.imgur.com/3oG6C57.png)
  /// ![](https://i.imgur.com/j8ioaX8.png)
  /// ##### Diagrams from [pub.dev: animated_styled_widget](https://pub.dev/packages/animated_styled_widget)
  /// Named to avoid `Type` clashing with `Style`.
  Surface({
    Key? key,
    this.shape = const Shape(),
    this.appearance = const Appearance(),
    this.filter = const Filter(),
    Widget? child,
    Duration duration = const Duration(milliseconds: 400),
    Curve curve = Curves.ease,
    // String? animationID,
    PointerEnterEventListener? onMouseEnter,
    PointerExitEventListener? onMouseExit,
    VoidCallback? onEnd,
  })  : foundation = Foundation.none,
        tactility = Tactility.none,
        super(
          key: key,
          id: null, // animationID,
          duration: duration,
          curve: curve,
          onEnd: onEnd,
          onMouseEnter: onMouseEnter,
          onMouseExit: onMouseExit,

          style: appearance.asStyle(
            layer: SurfaceLayer.MATERIAL,
            shape: shape,
            filter: filter,
          ),
          child: child ?? const SizedBox(width: 0, height: 0),
        );

  /// ### 🌟 [Surface.primitive]
  /// Create a primitive `Surface` for content. \
  /// Many desirable parameters have been shifted directly to the fore
  /// while less-used options disappear.
  ///
  /// There are defaults for [duration] & [curve] for intrinsic
  /// animated state changes, `400ms` and [Curves.ease] respectively.
  ///
  /// Pointer-based enter and exit 🐭 `onMouse` params accept `Function`s.
  ///
  /// ### 🎨 Appearance
  /// For a primitive `Surface` is handled directly in the parameters list. \
  /// Consider [color], the `double`-based constraints for [width] & [height],
  /// preservation of [margin] & [padding] for convenience, and the reduction
  /// of [Filter] down to [blurChild] & [blurMaterial] to maintain versatility.
  Surface.primitive({
    Key? key,
    this.shape = const Shape(),
    Color? color,
    Gradient? gradient,
    double? width,
    double? height,
    EdgeInsets? margin,
    EdgeInsets? padding,
    double? blurChild,
    double? blurMaterial,
    Widget? child,
    Duration duration = const Duration(milliseconds: 400),
    Curve curve = Curves.ease,
    PointerEnterEventListener? onMouseEnter,
    PointerExitEventListener? onMouseExit,
  })  : appearance = const Appearance(),
        foundation = Foundation.none,
        tactility = Tactility.none,
        filter = Filter(
          radiusChild: blurChild ?? 0,
          radiusMaterial: blurMaterial ?? 0,
        ),
        super(
          key: key,
          duration: duration,
          curve: curve,
          onMouseEnter: onMouseEnter,
          onMouseExit: onMouseExit,
          style: Appearance(
            width: width?.asPX,
            height: height?.asPX,
            margin: margin,
            padding: padding,
            decoration: BoxDecoration(color: color, gradient: gradient),
          ).asStyle(
            layer: SurfaceLayer.MATERIAL,
            shape: shape,
            filter: Filter(
              radiusChild: blurChild ?? 0,
              radiusMaterial: blurMaterial ?? 0,
            ),
          ),
          child: child ?? const SizedBox(width: 0, height: 0),
        );

  Surface.clay({
    Key? key,
    this.shape = const Shape(),
    Clay appearance = const Clay(),
    this.tactility = const Tactility(),
    this.filter = const Filter(),
    Widget? child,
    Duration duration = const Duration(milliseconds: 400),
    Curve curve = Curves.ease,
    // String? animationID,
    VoidCallback? onEnd,
    // ignore: prefer_initializing_formals
  })  : appearance = appearance,
        foundation = Foundation.none,
        super(
          key: key,
          id: null, // animationID,
          duration: duration,
          curve: curve,
          onEnd: onEnd,
          onMouseEnter: tactility.onMouseEnter,
          onMouseExit: tactility.onMouseExit,
          style: appearance
              .asStyle(
                layer: SurfaceLayer.MATERIAL,
                shape: shape,
                filter: filter,
              )
              .copyWith(padding: EdgeInsets.zero),
          child: Material(
            animationDuration: duration,
            color: Colors.transparent,
            // shape: shape.toMorphable,
            // TODO Look into `focus`, accessibility, nav
            child: InkResponse(
              canRequestFocus: tactility.tappable,
              // customBorder: shape.toMorphable,
              containedInkWell: true,
              highlightShape: BoxShape.rectangle,
              highlightColor: tactility.tappable
                  ? tactility.inkHighlightColor
                  : Colors.transparent,
              splashColor: tactility.tappable
                  ? tactility.inkSplashColor
                  : Colors.transparent,
              splashFactory: tactility.useThemeSplashFactory
                  ? null
                  : tactility.splashFactory ?? BouncyBall.splashFactory,
              onTap: tactility.tappable
                  ? () {
                      if (tactility.vibrates) HapticFeedback.vibrate();
                      tactility.onTap?.call();
                    }
                  : null,
              child: Padding(
                padding: appearance.padding ?? EdgeInsets.zero,
                child: child ?? const SizedBox(width: 0, height: 0),
              ),
            ),
          ),
        );

  /// Describe a rectangle-based `Shape` by declaring up to four `Corner`s
  /// and a [CornerRadius].
  /// Optionally provide a [Stroke].
  ///
  /// - 📐 Use [Shape.corners] to customize all four `Corner`s in a [Shape]
  /// - ➖ [Shape.border] from [Stroke]
  /// - 🔘 `CornerRadius` as [Shape.radius]
  final Shape shape;

  /// An `Appearance` object serves to dictate size, layout, and style.
  ///
  /// Variants to [Appearance] include [Clay] and [Glass].
  final Appearance appearance;

  /// 👆 [Tactility.tappable] provides `onTap` functionality and [InkResponse].
  /// Ink splash `Color`s may be customized.
  ///
  /// ❓ [Tactility.vibrates] is a convenience parameter
  /// to add a [HapticFeedback.vibrate] `onTap`.
  ///
  /// ---
  /// 🌟 `Surface` comes bundled with [🏓 `package:ball`](https://pub.dev/packages/ball 'pub.dev: ball').
  ///
  /// Disable the default [BouncyBall.splashFactory] with
  /// [Tactility.useThemeSplashFactory] or select an
  /// [InteractiveInkFeatureFactory] specific to this 🌟 `Surface`
  /// with [Tactility.splashFactory].
  final Tactility tactility;

  /// A 🔬 [Filter] provides options to customize `ImageFilter`
  /// appearance at all 📚 [SurfaceLayer]s.
  /// - `Set<SurfaceLayer>` 👓 [Filter.filteredLayers] ultimately determines
  /// which 📚 Layers have filters enabled.
  final Filter filter;

  /// Consider 🧱 `Foundation` to be a description of how the 📚 `FOUNDATION`
  /// is exposed behind the 📚 `MATERIAL`, or as insets
  /// to 📚 [SurfaceLayer.MATERIAL] as part of a `Surface.founded`.
  ///
  /// ---
  /// Selected by this [Foundation.exposure] declared [Alignment],
  /// chosen side(s) of padded space between 📚 `FOUNDATION` and 📚 `MATERIAL`
  /// are given special treatment:
  /// - made thicker when [Foundation.ratio] `>= 1.0` (default `ratio == 2.0`)
  /// - or made thinner if `0 >` [Foundation.ratio] `> 1.0`
  /// when compared to the standard 🔲 `peek` inset
  /// that the other padded sides receive.
  ///
  /// `exposure` defaults [Alignment.center] such that no side(s) receive(s)
  /// special treatment *regardless* of 🔲 `peek` / `ratio`.
  final Foundation foundation;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<Shape>('shape', shape))
      ..add(DiagnosticsProperty<morph.Style>('style', style))
      ..add(DiagnosticsProperty<Tactility>('tactility', tactility))
      ..add(DiagnosticsProperty<Filter>('filter', filter))
      ..add(DiagnosticsProperty<Foundation>('foundation', foundation))
      ..add(DiagnosticsProperty<Duration>('duration', duration));
  }
}
