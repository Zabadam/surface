/// ## 🌟 Surface Library:
/// ### 🎊 Goodies
/// - ⬛⬜ [Shading] `extension on Color`
/// - ✋ [DragNub] `Widget`
library surface;

import 'package:flutter/material.dart';

extension _Clamp on int {
  /// ❓ Leaving off `this.` breaks dart formatting for this entire file!!
  // ignore: unnecessary_this
  int get clamp255 => this.clamp(0, 255);
}

/// ---
/// 🔦 `WithShading` extends `Color`
/// - ⬛ [withBlack]: Subtract a single value from all RGB channels
/// - ⬜ [withWhite]: Add a single value to all RGB channels
/// - ➕ [add]: Add one `Color` to another
/// - ➕ [and]: Add, including alphas
/// - ➖ [subtract]: Subtract one `Color` from another
/// - ➖ [xor]: Subtract, including alphas
/// - [average]: Average all channels of two `Color`s
/// - [or]: Randomization by `Color` or `List<Color>`
extension Shading on Color {
  /// The value `add` is added to each RGB channel of `this`
  /// and clamped to be `255` or less. The [alpha] is maintained.
  Color withWhite(int add) => Color.fromARGB(
        alpha,
        (red + add).clamp255,
        (green + add).clamp255,
        (blue + add).clamp255,
      );

  /// The value `subtract` is subtracted from each RGB channel of `this`
  /// and clamped to be non-negative. The [alpha] is maintained.
  Color withBlack(int subtract) => Color.fromARGB(
        alpha,
        (red - subtract).clamp255,
        (green - subtract).clamp255,
        (blue - subtract).clamp255,
      );

  /// Add the `red`, `green`, and `blue` channels of `other` with
  /// those of `this Color`. The resultant [alpha] is maintained from `this`,
  /// unless a `strength` would be specified which is used instead.
  ///
  /// Exposure `method` for [+] `operator`.
  Color add(Color other, {double? strength}) {
    assert(
      (strength ?? 0) >= 0 && (strength ?? 0) <= 1.0,
      'Provide a `strength` between 0..1',
    );
    return withOpacity(strength ?? opacity) + other;
  }

  /// Consider [add] except the resultant [alpha]
  /// is the sum of both `Color`s' `alpha`.
  ///
  /// Exposure `method` for [&] `operator`.
  Color and(Color other) => this & other;

  /// Subtract the `red`, `green`, and `blue` channels of `other` from
  /// those of `this Color`. The resultant [alpha] is maintained from `this`,
  /// unless a `strength` would be specified which is used instead.
  ///
  /// Consider [xor], where the `alpha` channel is
  /// the difference of each `Color`s' `alpha`.
  ///
  /// Exposure `method` for [-] `operator`.
  Color subtract(Color other, {double? strength}) {
    assert(
      (strength ?? 0) >= 0 && (strength ?? 0) <= 1.0,
      'Provide a `strength` between 0..1',
    );
    return withOpacity(strength ?? opacity) - other;
  }

  /// Consider [subtract] except the resultant [alpha]
  /// is the difference of both `Color`s' `alpha`.
  ///
  /// Exposure `method` for [^] `operator`.
  Color xor(Color other) => this ^ other;

  /// Average the `alpha`, `red`, `green`, and `blue` channels
  /// of a `Color` with another `other`.
  ///
  /// Exposure `method` for [~/] `operator`.
  Color average(Color other) => this ~/ other;

  /// Exposure `method` for [|] `operator`: random `Color` access.
  ///
  /// If `others is Color`, the return value is `this` or `others`.
  ///
  /// If `others is List<Color>`, the return value is `this` or one of the
  /// entries from `others`.
  Color or(dynamic others) => this | others;

  /// Add the `red`, `green`, and `blue` channels
  /// of `other` with those of `this Color`.
  ///
  /// The resultant [alpha] is maintained from `this`.
  ///
  /// To *also add* the `alpha` from each `Color`, see [&].
  Color operator +(Color other) => Color.fromARGB(
        alpha,
        (red + other.red).clamp255,
        (green + other.green).clamp255,
        (blue + other.blue).clamp255,
      );

  /// Add the `alpha`, `red`, `green`, and `blue` channels
  /// of `other` with those of `this Color`.
  ///
  /// To maintain [alpha] from `this`, see [+].
  Color operator &(Color other) => Color.fromARGB(
        (alpha + other.alpha).clamp255,
        (red + other.red).clamp255,
        (green + other.green).clamp255,
        (blue + other.blue).clamp255,
      );

  /// Subtract the `red`, `green`, and `blue` channels
  /// of `other` from those of `this Color`.
  ///
  /// The resultant [alpha] is maintained from `this`.
  ///
  /// To *also subtract* the `alpha` from each `Color`, see [^].
  Color operator -(Color other) => Color.fromARGB(
        alpha,
        (red - other.red).clamp255,
        (green - other.green).clamp255,
        (blue - other.blue).clamp255,
      );

  /// Subtract the `alpha`, `red`, `green`, and `blue` channels
  /// of `other` from those of `this Color`.
  ///
  /// To maintain [alpha] from `this`, see [-].
  Color operator ^(Color other) => Color.fromARGB(
        (alpha - other.alpha).clamp255,
        (red - other.red).clamp255,
        (green - other.green).clamp255,
        (blue - other.blue).clamp255,
      );

  /// Average the `alpha`, `red`, `green`, and `blue` channels
  /// of a `Color` with another `other`.
  Color operator ~/(Color other) => Color.fromARGB(
        ((alpha + other.alpha) ~/ 2).clamp255,
        ((red + other.red) ~/ 2).clamp255,
        ((green + other.green) ~/ 2).clamp255,
        ((blue + other.blue) ~/ 2).clamp255,
      );

  /// Random `Color` access.
  ///
  /// If `others is Color`, the return value is `this` or `others`.
  ///
  /// If `others is List<Color>`, the return value is `this` or one of the
  /// entries from `others`.
  Color operator |(dynamic others) => (others is Color)
      ? (List.from([others, this])..shuffle()).first
      : (others is List<Color>)
          ? (List.from(others + [this])..shuffle()).first
          : this;
}

/// A small, round "handle" indicator used to visualize
/// the impression of a moving sheet or draggable material.
class DragNub extends StatelessWidget {
  /// A small, round "handle" indicator used to visualize
  /// the impression of a moving sheet or draggable material.
  ///
  /// Default [width] is `60.0`, default [height] is `6.0`, \
  /// default [borderWidth] is `1.0` and default [color] is [Colors.black].
  const DragNub({
    this.width = 60.0,
    this.height = 6.0,
    this.color = Colors.black,
    this.borderWidth = 1.0,
    Key? key,
  }) : super(key: key);

  /// Constrain dimensions of this `DragNub` in logical pixels.
  final double width, height;

  /// The thickness of the black border for this `DragNub`.
  ///
  /// Half this value is used for a thinner white border as well.
  final double borderWidth;

  /// Will have its `alpha` channel cut in half for use
  /// as this `DragNub`'s central color.
  ///
  /// Border is always black.
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white38, width: borderWidth / 2),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: color.withOpacity(0.5),
            border: Border.all(color: Colors.black54, width: borderWidth),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            boxShadow: const [
              BoxShadow(
                color: Colors.white24,
                blurRadius: 4,
                offset: Offset(-2, -2),
              ),
              BoxShadow(
                color: Colors.white10,
                blurRadius: 4,
                offset: Offset(2, 2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
