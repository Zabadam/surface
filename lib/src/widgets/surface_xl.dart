/// ##  `SurfaceXL`
/// Marriage of `Surface` and `AutoXL`
library surface;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:xl/xl.dart';

import '../appearance/appearance.dart';
import '../models/filter.dart';
import '../models/layer.dart';
import '../models/tactility.dart';
import '../shape/foundation.dart';
import '../shape/shape.dart';
import '../wrappers.dart';
import 'surface.dart';

/// This `Surface` is equipped to render an inter/reactive container
/// that utilizes the bundled [`package:XL`](https://pub.dev/packages/xl).
///
/// An [XL] parallax stack is capable of laying out and transforming layers
/// of `Widget`s based on pointer (touch/mouse) or sensors (accelerometer/gyro)
/// or both. This `SurfaceXL` creates a simplified "depth"-controlled
/// stack called an [AutoXL].
///
/// Employ a `SurfaceXL` like a standard 🌟 `Surface` where the result will
/// include an automatic and dynamic `XL` parallax stack.
class SurfaceXL extends StatelessWidget {
  /// This `Surface` is equipped to render an inter/reactive container
  /// that utilizes the bundled [`package:XL`](https://pub.dev/packages/xl).
  ///
  /// An [XL] parallax stack is capable of laying out and transforming layers
  /// of `Widget`s based on pointer (touch/mouse) or sensors (accelerometer/gyro)
  /// or both. This `SurfaceXL` creates a simplified "depth"-controlled
  /// stack called an [AutoXL].
  ///
  /// Employ a `SurfaceXL.founded` like a 🌟 `Surface.founded` where
  /// the result will include an automatic and dynamic `XL` parallax stack
  /// comprised of both the [Foundation] `Surface` and a primary
  /// `Surface.tactile`, followed by the [child] `Widget`.
  const SurfaceXL.founded({
    Key? key,
    this.depth = 20.0,
    this.isPane = false,
    this.shape = const Shape(),
    this.appearance = const Appearance(),
    this.tactility = const Tactility(),
    this.foundation = const Foundation(),
    this.child,
    this.duration = const Duration(milliseconds: 400),
    this.curve = Curves.ease,
    this.onMouseEnter,
    this.onMouseExit,
    this.onEnd,
  }) : super(key: key);

  /// This `Surface` is equipped to render an inter/reactive container
  /// that utilizes the bundled [`package:XL`](https://pub.dev/packages/xl).
  ///
  /// An [XL] parallax stack is capable of laying out and transforming layers of
  /// `Widget`s based on pointer (touch/mouse) or sensors (accelerometer/gyro)
  /// or both. This `SurfaceXL` creates a simplified "depth"-controlled
  /// stack called an [AutoXL].
  ///
  /// Employ a `SurfaceXL` like a standard 🌟 `Surface` where the result will
  /// include an automatic and dynamic `XL` parallax stack
  /// with the described `Surface` followed by the [child].
  const SurfaceXL({
    Key? key,
    this.depth = 20.0,
    this.isPane = false,
    this.shape = const Shape(),
    this.appearance = const Appearance(),
    this.tactility = const Tactility(),
    this.child,
    this.duration = const Duration(milliseconds: 400),
    this.curve = Curves.ease,
    this.onMouseEnter,
    this.onMouseExit,
    this.onEnd,
  })  : foundation = null,
        super(key: key);

  /// This `Surface` is equipped to render an inter/reactive container
  /// that utilizes the bundled [`package:XL`](https://pub.dev/packages/xl).
  ///
  /// An [XL] parallax stack is capable of laying out and transforming layers of
  /// `Widget`s based on pointer (touch/mouse) or sensors (accelerometer/gyro)
  /// or both. This `SurfaceXL` creates a simplified "depth"-controlled
  /// stack called an [AutoXL].
  ///
  /// Employ a `SurfaceXL.primitive` like a 🌟 `Surface.primitive`
  /// where the result will include an automatic and dynamic `XL` parallax stack
  /// with the described `Surface` followed by the [child].
  SurfaceXL.primitive({
    Key? key,
    this.depth = 20.0,
    this.isPane = false,
    this.shape = const Shape(),
    Color? color,
    Gradient? gradient,
    double? width,
    double? height,
    EdgeInsets? margin,
    EdgeInsets? padding,
    double? blurFoundation,
    double? blurMaterial,
    double? blurChild,
    this.child,
    this.duration = const Duration(milliseconds: 400),
    this.curve = Curves.ease,
    this.onMouseEnter,
    this.onMouseExit,
  })  : onEnd = null,
        foundation = null,
        tactility = Tactility.none,
        appearance = Appearance(
          layout: Layout.primitive(
            width: width,
            height: height,
            margin: margin,
            padding: padding,
          ),
          filter: Filter(
            radiusChild: blurChild ?? 0,
            radiusMaterial: blurMaterial ?? 0,
            radiusFoundation: blurFoundation ?? 0,
          ),
          decoration: BoxDecoration(color: color, gradient: gradient),
        ),
        super(key: key);

  /// A value that corresponds to how much more parallax-reactive
  /// each progressive layer of this widget is compared to the previous.
  ///
  /// Default value is `20.0`.
  final double depth;

  /// If this value is made `true` instead of the default `false`,
  /// the generated [AutoXL] will not employ the provided [depth] as its
  /// `depthFactor`, but instead render an [AutoXL.pane].
  ///
  /// These "panes" do not translate, but do rotate based on interaction
  /// consider pointer (touch or mouse) location.
  final bool isPane;

  /// Describe a rectangle-based `Shape` by declaring up to four `Corner`s
  /// and a [CornerRadius].
  /// Optionally provide a [Stroke].
  ///
  /// - 📐 `Corners` `Shape` description
  ///   - Use `corners` to customize all four `Corner`s in a [Shape].
  /// ---
  /// - ➖ [Shape.stroke] from [Stroke]
  ///   - Add a [Stroke] decoration to the edges of this [Shape].
  /// ---
  /// - 🔘 `CornerRadius` as [Shape.radius]
  final Shape shape;

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
  ///   - [Filter.radiusMaterial] applies to the background `decoration` &
  ///   as `Backdrop`
  /// - `Tactility`, for interaction-related parameters, colors
  ///
  /// ![](https://i.imgur.com/3oG6C57.png)
  /// ![](https://i.imgur.com/j8ioaX8.png)
  /// ##### Diagrams from [pub.dev: animated_styled_widget](https://pub.dev/packages/animated_styled_widget)
  /// Named to avoid `Type` clashing with `Style`.
  final Appearance appearance;

  /// 👆 [Tactility.tappable] provides `onTap` functionality and `InkResponse`.
  /// Ink splash `Color`s may be customized.
  ///
  /// ❓ [Tactility.vibrates] is a convenience parameter
  /// to add a `HapticFeedback.vibrate` on tap.
  /// ---
  /// 🌟 `Surface` comes bundled with [🏓 `package:ball`](https://pub.dev/packages/ball 'pub.dev: ball').
  ///
  /// Disable the default `BouncyBall.splashFactory` with
  /// [Tactility.useThemeSplashFactory] or select an
  /// `InteractiveInkFeatureFactory` specific to this 🌟 `Surface`
  /// with [Tactility.splashFactory].
  final Tactility tactility;

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
  final Foundation? foundation;

  /// The child for this `SurfaceXL` will be presented
  /// as the top-most `XL` layer.
  final Widget? child;

  /// `Duration` for intrinsic animation of property changes
  /// to this `SurfaceXL`.
  final Duration duration;

  /// `Curve` for intrinsic animation of property changes to this `SurfaceXL`.
  final Curve curve;

  /// Provide a `Function` to perform when a pointer enters this widget.
  final PointerEnterEventListener? onMouseEnter;

  /// Provide a `Function` to perform when a pointer exits this widget.
  final PointerExitEventListener? onMouseExit;

  /// Provide a `Function` to perform when this widget ends animating.
  final VoidCallback? onEnd;

  @override
  Widget build(BuildContext context) {
    final foundationSurface = Surface(
      shape: foundation?.shape ?? shape,
      appearance: (foundation?.appearance ?? appearance).copyWith(
        // Convert Foundation reference to Material reference
        // when compositing this layer's filter.
        filter: Filter(
          filteredLayers:
              appearance.filter.filteredLayers.contains(SurfaceLayer.FOUNDATION)
                  ? {SurfaceLayer.MATERIAL}
                  : const <SurfaceLayer>{},
          radiusMaterial: appearance.filter.radiusFoundation,
        ),
      ),
      duration: duration,
      curve: curve,
    );

    final surface = Surface.tactile(
      shape: shape,
      appearance: appearance.copyWith(
        filter: appearance.filter,
        layout: appearance.layout.copyWith(
          margin: EdgeInsets.fromLTRB(
            appearance.layout.margin?.left ?? 0 + (foundation?.peekLeft ?? 0),
            appearance.layout.margin?.top ?? 0 + (foundation?.peekTop ?? 0),
            appearance.layout.margin?.right ?? 0 + (foundation?.peekRight ?? 0),
            appearance.layout.margin?.bottom ??
                0 + (foundation?.peekBottom ?? 0),
          ),
        ),
      ),
      tactility: tactility,
      duration: duration,
      curve: curve,
      // child: child, // Will be its own layer in the AutoXL stack
    );

    return (isPane)
        ? AutoXL.pane(
            depth: (foundation != null) ? 3 : 2,
            layers: [
              if (foundation != null) foundationSurface,
              surface,
              child ?? const SizedBox(),
            ],
          )
        : AutoXL(
            depth: (foundation != null) ? 3 : 2,
            depthFactor: depth,
            layers: [
              if (foundation != null) foundationSurface,
              surface,
              child ?? const SizedBox(),
            ],
          );
  }
}
