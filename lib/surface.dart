/// ## 🌟 Surface Library
/// A shapeable, layered, intrinsincally animated container Widget
/// offering convenient access to blurring `ImageFilter`s,
/// `Material` `InkResponse`, and `HapticFeedback`.
///
/// ### + [🏓 `BouncyBall`](https://pub.dev/packages/ball 'pub.dev: ball')
/// A delightfully bouncy and position-mirroring reaction
/// to user input on a piece of `Material`.
///
/// ---
/// ### References
/// - 🌟 [Surface] - A shapeable, layered, animated container widget
/// - 🔰 [Shape]
///   - Defined by 📐 [Corners], ➖ [Stroke], and 🔘 [CornerRadius]
/// - 🎨 [Appearance]
/// - 🔲 [Foundation] - Parameter object to customize 📚 `BASE` "peek"
/// - 👆 [Tactility] - Parameter object to customize tap appearance & behavior
/// - 🔬 [Filter] - Parameter object to customize 🤹‍♂️ filters/effects!
///   - 🤹‍♂️ [SurfaceFX] `Function typedef`
///
/// ---
/// 📚 [SurfaceLayer] container layering
///
/// ---
/// 👆 [Tactility] offers [Tactility.onTap] `VoidCallback`, `InkResponse`
/// customization, and a `HapticFeedback` [Tactility.vibrates] shortcut.
///
/// ---
/// A 🔲 [Foundation] may be provided to alter the Surface "peek"
/// (`MATERIAL` inset or "border") with parameter 🔲 [Foundation.peek].
/// - Give special treatment, generally a thicker appearance, to selected
///   side(s) by passing 🔲 [Foundation.exposure]
///   and tuning with 🔲 [Foundation.ratio].
/// - Note:  for true `BorderSide`s, see 🔰 [Shape.border].
///
/// ---
/// Specify a 🔬 [Filter] with options
/// to render 🤹‍♂️ [SurfaceFX] backdrop `ImageFilter`s
/// - In configured 👓 [Filter.filteredLayers] `Set`
/// - Whose radii (🤹‍♂️ `effect` strength) are mapped with
/// 📊 [Filter.radiusMap]
///
/// ---
/// ### References, continued
/// #### 🏓 [BouncyBall]
/// A delightfully bouncy and position-mirroring reaction to user input
/// on a piece of `Material`.
///
/// Turn ink splashes for an `InkWell`, `InkResponse` or material `Theme`
/// into 🏓 [BouncyBall]s or 🔮 `Glass` [BouncyBall]s
/// with the built-in `InteractiveInkFeatureFactory`s,
/// or design your own with 🪀 [BouncyBall.mold].
///
/// #### 🎊 Extra Goodies
/// - 🔦 [Shading] `Color` extension
///   - ⬛ `.withBlack(int subtract)`
///   - ⬜ `.withWhite(int add)`
/// - 🤚 [DragNub], a small, round "handle" indicator used to visualize
/// the impression of a draggable surface.
library surface;

// For links here in doc.
import 'package:ball/ball.dart';
import 'src/goodies.dart';
import 'src/models/filter.dart';
import 'src/models/surface_layer.dart';
import 'src/models/tactility.dart';
import 'src/shape/corner.dart';
import 'src/shape/foundation.dart';
import 'src/shape/shape.dart';
import 'src/widgets/surface.dart';
import 'src/wrappers.dart';

// Dependencies export
export 'package:animated_styled_widget/animated_styled_widget.dart'
    show Length, ShapeShadow;

export 'src/appearance/appearance.dart';
export 'src/goodies.dart';
export 'src/models/filter.dart';
export 'src/models/surface_layer.dart';
export 'src/models/tactility.dart';
export 'src/neu.dart';
export 'src/shape/corner.dart';
export 'src/shape/foundation.dart';
export 'src/shape/shape.dart';
export 'src/widgets/surface.dart';
export 'src/widgets/surface_xl.dart';
export 'src/wrappers.dart';
