/// ## Just a few extra things for fun.
///
/// ### `goodies.dart` adds a few items to namespace currently... sorry!
/// - `fullPrint(String text)` to receive really long Strings in console log
/// - A few `Duration` constants
/// - Color constant `TRANSPARENT`
/// - Color extensions `.withBlack(int subtract)` and `.withWhite(int add)`
/// - `Transform ScaleAxis(Widget child, {Key key, double dx =1.0, double dy =1.0, Offset origin, AlignmentGeometry alignment})`
library surface;

import 'package:flutter/material.dart';

/// -----
/// # EXTRA GOODIES

/// ------
/// CONSTANTS
///
/// ---
/// # 👻 Transparent Color
const TRANSPARENT = const Color(0x00FFFFFF);

/// ------
/// ## ⏰ DURATIONS
/// ---
/// # ⚡ Lightning Duration: 200ms
const LIGHTNING = const Duration(milliseconds: 200);

/// # 🐱‍🏍 Speedy Duration: 300ms
const SPEEDY = const Duration(milliseconds: 300);

/// # 🏃‍♀️ Quick Duration: 400ms
const QUICK = const Duration(milliseconds: 400);

/// # 💫 Standard Duration: 500ms
const STANDARD = const Duration(milliseconds: 500);

/// # 💨 Long Duration: 700ms
const SLOW = const Duration(milliseconds: 700);

/// ------
/// ## 🔧 "EXTENSIONS"
///
/// ---
/// ### Full Print
/// Gives larger debug print output
void fullPrint(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}

/// ### 🔧👓 [Color] Extension [WithShading]
/// #### ⬛ `Color.withBlack(int subtract)` darkens [Color]'s RGB values by [subtract] (result >= 0)
/// #### ⬜ `Color.withWhite(int add)` brightens [Color]'s RGB values by [add] (result <= 255)
extension WithShading on Color {
  /// WithWhite(int add) increments this.RGB values by [add] up to max:255
  Color withWhite(int add) {
    int red = this.red;
    int green = this.green;
    int blue = this.blue;

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

  // WithBlack(int subtract) decrements this.RGB values by `subtract` down to min:0
  Color withBlack(int subtract) {
    int red = this.red;
    int green = this.green;
    int blue = this.blue;

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

/// ### 🔧📏 Scale Axis:
/// A [Transform.scale]-like return that accepts independent horizontal [dx] and vertical [dy]
/// scale doubles and manually plugs these in a [Matrix4] for a returned [Transform].
///
///     ScaleAxis(dx: 0.5, dy: 0.25, child: anotherWidget)
/// returns a horizontally-half-scaled, vertically-quarter-scaled [anotherWidget].
class ScaleAxis extends StatelessWidget {
  final double dx, dy;
  final Offset origin;
  final AlignmentGeometry alignment;
  final Widget child;

  ScaleAxis(
    this.child, {
    Key key,
    this.dx = 1.0,
    this.dy = 1.0,
    this.origin = const Offset(0, 0),
    this.alignment = Alignment.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Matrix4 scale = Matrix4.diagonal3Values(dx, dy, 1.0);

    return Transform(key: key, transform: scale, child: child);
  }
}

/// ---
/// ### ✋ [DragNub] is a small, round "handle" indicator used to visualize
/// the impression of a moving sheet or draggable material.
class DragNub extends StatelessWidget {
  const DragNub({
    this.width,
    this.height,
    this.color,
    this.borderWidth,
  });

  final double width, height, borderWidth;
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
