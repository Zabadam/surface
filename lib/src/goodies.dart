/// ## 🎊 Surface: Goodies
/// Just for fun.
///
/// ### References
/// - 🔦 [WithShading] `Color` extension
///   - ⬛ [withBlack] `.withBlack(int subtract)`
///   - ⬜ [withWhite] `.withWhite(int add)`
/// - 🤚 [DragNub] A small, round "handle" indicator used to visualize impression of draggable material
library surface;

import '../surface.dart';

/// ---
/// ### 🔦 [WithShading] extends [Color]
///
/// #### ⬛ [withBlack]
///      Color.withBlack(int subtract)
///
/// #### ⬜ [withWhite]
///      Color.withWhite(int add)
extension WithShading on Color {
  /// #### ⬜ With White
  ///
  /// ```
  /// Color.withWhite(int add)
  /// // Brightens Color's RGB values by `add` (result <= 255)
  /// ```
  Color withWhite(int add) => Color.fromARGB(
        this.alpha,
        (this.red + add).clamp(0, 255),
        (this.green + add).clamp(0, 255),
        (this.blue + add).clamp(0, 255),
      );

  /// #### ⬛ With Black
  ///
  /// ```
  /// Color.withBlack(int subtract)
  /// // Darkens Color's RGB values by `subtract` (result >= 0)
  /// ```
  Color withBlack(int subtract) => Color.fromARGB(
        this.alpha,
        (this.red - subtract).clamp(0, 255),
        (this.green - subtract).clamp(0, 255),
        (this.blue - subtract).clamp(0, 255),
      );
}

/// ---
/// ### ✋ Drag Nub
/// A small, round "handle" indicator used to visualize
/// the impression of a moving sheet or draggable material.
///
/// ```
/// DragNub({double width, double height, Color color, double borderWidth})
/// ```
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
                  color: Colors.white24, blurRadius: 4, offset: Offset(-2, -2)),
              BoxShadow(
                  color: Colors.white10, blurRadius: 4, offset: Offset(2, 2)),
            ],
          ),
        ),
      ),
    );
  }
}
