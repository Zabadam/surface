/// ## 🎊 Surface Library: Goodies
/// - ⬛⬜ [Shading] `extension on Color`
/// - ✋ [DragNub] `Widget`
library surface;

import 'package:flutter/material.dart';

extension _Clamp on int {
  int get _clamp => this.clamp(0, 255);
}

/// ---
/// 🔦 `WithShading` extends `Color`
/// - ⬛ [withBlack]
/// - ⬜ [withWhite]
extension Shading on Color {
  /// #### ⬜ With White
  ///
  /// ```
  /// Color.withWhite(int add)
  /// // Brightens Color's RGB values by `add` (result <= 255)
  /// ```
  Color withWhite(int add) => Color.fromARGB(
        alpha,
        (red + add)._clamp,
        (green + add)._clamp,
        (blue + add)._clamp,
      );

  /// #### ⬛ With Black
  ///
  /// ```
  /// Color.withBlack(int subtract)
  /// // Darkens Color's RGB values by `subtract` (result >= 0)
  /// ```
  Color withBlack(int subtract) => Color.fromARGB(
        alpha,
        (red - subtract)._clamp,
        (green - subtract)._clamp,
        (blue - subtract)._clamp,
      );

  /// Average the `alpha`, `red`, `green`, and `blue` channels
  /// of a `Color` with another `other`.
  Color operator +(Color other) => Color.fromARGB(
      ((alpha + other.alpha) ~/ 2)._clamp,
      ((red + red) ~/ 2)._clamp,
      ((green + other.green) ~/ 2)._clamp,
      ((blue + other.blue) ~/ 2)._clamp);
}

/// ---
/// ### ✋ Drag Nub
/// A small, round "handle" indicator used to visualize
/// the impression of a moving sheet or draggable material.
class DragNub extends StatelessWidget {
  /// ### ✋ Drag Nub
  /// Aa small, round "handle" indicator used to visualize
  /// the impression of a moving sheet or draggable material.
  const DragNub({
    this.width,
    this.height,
    this.color,
    this.borderWidth,
    Key? key,
  }) : super(key: key);

  final double? width, height;
  final double? borderWidth;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white38, width: borderWidth ?? 0.5),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Container(
          width: width ?? 60,
          height: height ?? 6,
          decoration: BoxDecoration(
            color: (color ?? Colors.black).withOpacity(0.5),
            border: Border.all(color: Colors.black54, width: borderWidth ?? 1),
            borderRadius: BorderRadius.all(Radius.circular(10)),
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
