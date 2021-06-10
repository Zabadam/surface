/// Copyright 2021 Adam Skelton (Zabadam)
/// Parts of code Copyright 2019 The Flutter team. All rights reserved.
/// Use of that source code is governed by a BSD-style license that can be
/// found in the Flutter LICENSE file.
library surface_example;

import 'package:flutter/material.dart';

import 'package:surface/surface.dart';

const _ITEM_HEIGHT = 180.0;
const _ITEM_PADDING = 10.0;
const _DURATION = Duration(milliseconds: 400);
const _CURVE = Curves.fastOutSlowIn;
const _BACKGROUND =
    'https://apod.nasa.gov/apod/image/2102/rosette_goldman_2500.jpg';

/// Define properties for a [Palette].
class Palette {
  /// Define properties for a [Palette].
  const Palette({
    required this.name,
    required this.primary,
    this.accent,
    this.threshold = 900,
  });

  final String name;
  final MaterialColor primary;
  final MaterialAccentColor? accent;
  // Titles for indices > threshold are white, otherwise black.
  final int threshold;
}

/// Constant List containing all [Palette]s.
const List<Palette> PALETTES = [
  Palette(
    name: 'Red',
    primary: Colors.red,
    accent: Colors.redAccent,
    threshold: 300,
  ),
  Palette(
    name: 'Pink',
    primary: Colors.pink,
    accent: Colors.pinkAccent,
    threshold: 200,
  ),
  Palette(
    name: 'Purple',
    primary: Colors.purple,
    accent: Colors.purpleAccent,
    threshold: 200,
  ),
  Palette(
    name: 'Deep Purple',
    primary: Colors.deepPurple,
    accent: Colors.deepPurpleAccent,
    threshold: 200,
  ),
  Palette(
    name: 'Indigo',
    primary: Colors.indigo,
    accent: Colors.indigoAccent,
    threshold: 200,
  ),
  Palette(
    name: 'Blue',
    primary: Colors.blue,
    accent: Colors.blueAccent,
    threshold: 400,
  ),
  Palette(
    name: 'Light Blue',
    primary: Colors.lightBlue,
    accent: Colors.lightBlueAccent,
    threshold: 500,
  ),
  Palette(
    name: 'Cyan',
    primary: Colors.cyan,
    accent: Colors.cyanAccent,
    threshold: 600,
  ),
  Palette(
    name: 'Teal',
    primary: Colors.teal,
    accent: Colors.tealAccent,
    threshold: 400,
  ),
  Palette(
    name: 'Green',
    primary: Colors.green,
    accent: Colors.greenAccent,
    threshold: 500,
  ),
  Palette(
    name: 'Light Green',
    primary: Colors.lightGreen,
    accent: Colors.lightGreenAccent,
    threshold: 600,
  ),
  Palette(
    name: 'Lime',
    primary: Colors.lime,
    accent: Colors.limeAccent,
    threshold: 800,
  ),
  Palette(
    name: 'Yellow',
    primary: Colors.yellow,
    accent: Colors.yellowAccent,
  ),
  Palette(
    name: 'Amber',
    primary: Colors.amber,
    accent: Colors.amberAccent,
  ),
  Palette(
    name: 'Orange',
    primary: Colors.orange,
    accent: Colors.orangeAccent,
    threshold: 700,
  ),
  Palette(
    name: 'Deep Orange',
    primary: Colors.deepOrange,
    accent: Colors.deepOrangeAccent,
    threshold: 400,
  ),
  Palette(
    name: 'Brown',
    primary: Colors.brown,
    threshold: 200,
  ),
  Palette(
    name: 'Grey',
    primary: Colors.grey,
    threshold: 500,
  ),
  Palette(
    name: 'Blue Grey',
    primary: Colors.blueGrey,
    threshold: 500,
  ),
];

/// Widget [ColorItem] presents this [color] and [index] as a `Row`.
class ColorItem extends StatelessWidget {
  /// Widget [ColorItem] presents this [color] and [index] as a `Row`.
  ///
  /// Represents a single [MaterialColor] shade.
  const ColorItem({
    Key? key,
    required this.index,
    required this.color,
    this.prefix = '',
    required this.brightness,
    required this.tactility,
  }) : super(key: key);

  final int index;
  final Color color;
  final String prefix;
  final Brightness brightness;
  final Tactility tactility;

  String get _colorString =>
      "#${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}";

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      color: brightness == Brightness.dark ? Colors.white : Colors.black,
      fontSize: 200,
      fontWeight: FontWeight.w900,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Stack(
        children: [
          Semantics(
            container: true,
            child: Surface.founded(
              tactility: tactility,
              shape: Shape(
                corners: Corners.roundWith(),
                radius: CornerRadius.all(Circular(Length(75))),
              ),
              appearance: Appearance.primitive(
                filter: const Filter(
                  filteredLayers: {
                    SurfaceLayer.FOUNDATION,
                    SurfaceLayer.MATERIAL
                  },
                  radiusFoundation: 4.0,
                  radiusMaterial: 15.0,
                ),
                height: _ITEM_HEIGHT,
                margin: const EdgeInsets.all(_ITEM_PADDING),
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                color: color.withOpacity(0.75),
              ),
              foundation: Foundation(
                peek: 5,
                exposure: Alignment.centerLeft,
                ratio: 30,
                shape: Shape(
                  corners: Corners.roundWith(),
                  radius: CornerRadius.all(Circular(Length(75))),
                ),
                appearance: Appearance.primitive(color: color.withOpacity(0.3)),
              ),
              duration: _DURATION,
              curve: _CURVE,
              child: Align(
                alignment: Alignment(0, -0.5),
                child: FittedBox(child: Text(_colorString, style: style)),
              ),
            ),
          ),
          Align(
            alignment: Alignment(-0.85, 0),
            child: SizedBox(
              width: 110,
              height: 75,
              child: FittedBox(
                child: Text(
                    '${brightness == Brightness.dark ? '🌑' : '☀'}$prefix$index',
                    style: style),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ListView of [ColorItem] Widgets.
class PaletteTabView extends StatelessWidget {
  /// The available `key`s when tapping into a [MaterialColor].
  static const KEYS_PRIMARIES = <int>[
    50,
    100,
    200,
    300,
    400,
    500,
    600,
    700,
    800,
    900
  ];

  /// The available `key`s when tapping into a [MaterialAccentColor].
  static const KEYS_ACCENTS = <int>[100, 200, 400, 700];

  /// ListView of [ColorItem] Widgets.
  const PaletteTabView({
    Key? key,
    required this.palette,
  }) : super(key: key);

  final Palette palette;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemExtent: _ITEM_HEIGHT,

      /// Add 1 extra `item` for a padding space at the bottom of the List.
      itemCount: 1 +
          KEYS_PRIMARIES.length +
          ((palette.accent != null) ? KEYS_ACCENTS.length : 0),
      itemBuilder: (_, index) {
        final Tactility tactility = Tactility(
          inkHighlightColor: ((palette.accent != null)
                  ? palette.accent![400]
                  : palette.primary)!
              .withOpacity(0.8),
          inkSplashColor: palette.primary[900]!.withBlack(100),
        );

        /// Having an accent MaterialColor, a [ColorItem] still has a primary to display.
        if (index < KEYS_PRIMARIES.length) {
          final primariesIndex = KEYS_PRIMARIES[index];
          return ColorItem(
            index: primariesIndex,
            color: palette.primary[primariesIndex]!,
            brightness: primariesIndex > palette.threshold
                ? Brightness.dark
                : Brightness.light,
            tactility: tactility,
          );
        }

        /// Else with an `index` beyond the length of KEYS_PRIMARIES,
        /// `itemCount` has already checked and appropriately sized this ListView.
        ///
        /// Subtract KEYS_PRIMARIES when considering `index` in terms of the accent colors.
        else if (palette.accent != null &&
            index < KEYS_PRIMARIES.length + KEYS_ACCENTS.length) {
          final accentsIndex = KEYS_ACCENTS[index - KEYS_PRIMARIES.length];
          return ColorItem(
            index: accentsIndex,
            color: palette.accent![accentsIndex]!,
            prefix: 'A',
            brightness: accentsIndex > palette.threshold
                ? Brightness.dark
                : Brightness.light,
            tactility: tactility,
          );
        }

        /// Else
        return Surface.tactile(
          shape: Shape(),
          appearance: Appearance.primitive(
            filter: const Filter(
              filteredLayers: {SurfaceLayer.FOUNDATION},
              radiusFoundation: 10,
            ),
            // width: double.infinity,
            height: _ITEM_HEIGHT - _ITEM_PADDING * 4,
            margin: const EdgeInsets.all(_ITEM_PADDING * 2),
            padding: const EdgeInsets.all(10),
            color: palette.primary[900]!.withOpacity(0.5),
          ),
          tactility: tactility,
          child: Center(
            /// Using a FittedBox, feel free to set a really huge fontSize.
            child: FittedBox(
              child: Text(
                '${palette.name.toUpperCase()}:\n'
                'No Further Shades',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 100,
                  color: palette.primary[300],
                  fontWeight: FontWeight.w900,
                  shadows: [
                    Shadow(
                      color: palette.primary[50]!,
                      offset: Offset(0, -1),
                    ),
                    Shadow(
                      color: palette.primary[900]!.withBlack(25),
                      offset: Offset(0, 5),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// A tabbed view that presents a MaterialColor on each tab,
/// with shades presented with the use of [SurfaceLegacy]s.
class SurfacePalette extends StatefulWidget {
  const SurfacePalette({Key? key}) : super(key: key);
  _SurfacePaletteState createState() => _SurfacePaletteState();
}

class _SurfacePaletteState extends State<SurfacePalette>
    with SingleTickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(
      vsync: this,
      length: PALETTES.length,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Palette get palette {
    return PALETTES[_controller.animation!.value.round()];
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller.animation!.drive(CurveTween(curve: _CURVE)),
      builder: (_, __) {
        return Scaffold(
          backgroundColor: palette.primary[900]!.withBlack(75),
          appBar: AppBar(
            backgroundColor: palette.primary[500],
            toolbarHeight: 160,
            centerTitle: true,
            title: Text(
              'Material Colors Palette:\nSurface Edition',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: palette.threshold > 500 ? Colors.black : Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.w100,
              ),
            ),
            bottom: TabBar(
              labelPadding: const EdgeInsets.fromLTRB(
                15,
                0,
                15,
                5,
              ),
              controller: _controller,
              isScrollable: true,
              physics: const BouncingScrollPhysics(),
              unselectedLabelStyle:
                  TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
              labelStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
              labelColor: palette.threshold > 500 ? Colors.black : Colors.white,
              indicatorWeight: 5.0,
              indicatorColor: palette.threshold > 500
                  ? palette.primary[900]
                  : palette.primary[50],
              tabs: [
                for (final palette in PALETTES)
                  Tab(text: palette.name.toUpperCase()),
              ],
            ),
          ),
          body: Stack(
            children: [
              Image.network(
                _BACKGROUND,
                // This frameBuilder simply fades in the photo when it loads.
                frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                  if (wasSynchronouslyLoaded) return child;
                  return AnimatedOpacity(
                    child: child,
                    opacity: frame ==
                            null // Animated gifs have 1+ frames, static pictures have 1 to load, a failed load or not yet loaded pic has `null`
                        ? 0
                        : 1,
                    duration: _DURATION * 2,
                    curve: _CURVE,
                  );
                },
                // Stretch the photo to the size of the app and have it cover the Surface.
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              ),

              /// GestureDetector will pass strong-enough [ppsQualifies]
              /// horizontal swipes as tab-index animation drives to TabController.
              GestureDetector(
                onHorizontalDragEnd: (details) {
                  final pps = details.velocity.pixelsPerSecond;
                  final ppsQualifies = pps.distanceSquared > 500000;

                  if (ppsQualifies)
                    _controller.animateTo(
                      ((_controller.index + details.primaryVelocity!.sign * -1)
                              .toInt())
                          .clamp(0, PALETTES.length - 1),
                      duration: _DURATION,
                      curve: _CURVE,
                    );
                },
                child: [
                  for (final palette in PALETTES)
                    PaletteTabView(
                      palette: palette,
                    ),
                ][_controller.animation!.value.round()],
              ),
            ],
          ),
        );
      },
    );
  }
}
