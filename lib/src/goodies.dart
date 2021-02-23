/// ## 🎊 Just a few extra goodies for fun.
///
/// ### `goodies.dart` adds a few items to namespace currently... sorry!
/// - 👨‍💻 `fullPrint(String text)` to receive really long Strings in console log
/// - Color extensions ⬛ `.withBlack(int subtract)` and ⬜ `.withWhite(int add)`
/// - 🤚 `DragNub({double width, double height, Color color, double borderWidth})`
/// - 📏 `Transform ScaleAxis(Widget child, {Key key, double dx =1.0, double dy =1.0, Offset origin, AlignmentGeometry alignment})`
library surface;

import 'package:flutter/material.dart';

/// ### 👨‍💻 Full Print
/// Gives larger debug print output
///
///     void fullPrint(String text)
void fullPrint(String text) {
  /// 800 is the size of each chunk
  final pattern = RegExp('.{1,800}');
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}

/// ### ⬛⬜ [Color] Extension [WithShading]
/// #### ⬛ `Color.withBlack(int subtract)` darkens [Color]'s RGB values by [subtract] (result >= 0)
/// #### ⬜ `Color.withWhite(int add)` brightens [Color]'s RGB values by [add] (result <= 255)
extension WithShading on Color {
  /// ⬜
  ///
  ///     Color.withWhite(int add)
  /// brightens [Color]'s RGB values by [add] (result <= 255)
  Color withWhite(int add) {
    int red = this.red ?? 0;
    int green = this.green ?? 0;
    int blue = this.blue ?? 0;

    if (red + add > 255)
      red = 255;
    else
      red += add;
    if (green + add > 255)
      green = 255;
    else
      green += add;
    if (blue + add > 255)
      blue = 255;
    else
      blue += add;

    return this.withRed(red).withGreen(green).withBlue(blue);
  }

  /// ⬛
  ///
  ///     Color.withBlack(int subtract)
  /// darkens [Color]'s RGB values by [subtract] (result >= 0)
  Color withBlack(int subtract) {
    int red = this.red ?? 0;
    int green = this.green ?? 0;
    int blue = this.blue ?? 0;

    if (red - subtract < 0)
      red = 0;
    else
      red -= subtract;
    if (green - subtract < 0)
      green = 0;
    else
      green -= subtract;
    if (blue - subtract < 0)
      blue = 0;
    else
      blue -= subtract;

    return this.withRed(red).withGreen(green).withBlue(blue);
  }
}

/// ### ✋ [DragNub] is a small, round "handle" indicator
/// used to visualize the impression of a moving sheet or draggable material.
///
///     Widget DragNub({double width, double height, Color color, double borderWidth})
class DragNub extends StatelessWidget {
  const DragNub({
    this.width,
    this.height,
    this.color,
    this.borderWidth,
  });

  final double width, height;
  final double borderWidth;
  final Color color;

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
            boxShadow: [
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

/// ### 📏 Scale Axis:
/// A [Transform.scale]-like return that accepts independent horizontal [dx] and vertical [dy]
/// scale doubles and manually plugs these in a [Matrix4] for a returned [Transform].
///
///     scaleAxis(dx: 0.5, dy: 0.25, child: anotherWidget)
/// returns a horizontally-half-scaled, vertically-quarter-scaled [anotherWidget].
Transform scaleAxis(
    {double dx = 1.0,
    double dy = 1.0,
    Offset origin = const Offset(0, 0),
    AlignmentGeometry alignment = Alignment.center,
    Widget child}) {
  return Transform(
      transform: Matrix4.diagonal3Values(dx, dy, 1.0),
      child: child ?? Container(width: 0, height: 0));
}
