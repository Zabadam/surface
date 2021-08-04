/// - ✋ [DragNub] `Widget`
library surface;

import 'package:flutter/material.dart';

/// A small, round "handle" indicator used to visualize the impression of a
/// moving sheet or draggable material.
@Deprecated('Outdated. May be upgraded or removed. '
    'Feel free to copy this widget as a replacement')
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
