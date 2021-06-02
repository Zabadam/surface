/// WORK IN PROGRESS
library surface_example;

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

// import 'package:animated_styled_widget/animated_styled_widget.dart' as Morph;
import 'package:surface/surface.dart';
import 'package:ball/ball.dart';
import 'surface_palette.dart';
import 'ball_pit.dart';

const _COLOR_PRIMARY = Colors.red;
const _COLOR_ACCENT = Colors.blue;
const _DURATION = Duration(milliseconds: 450);
const _CURVE = Curves.easeInOutCirc;
const _BACKGROUND =
    'https://apod.nasa.gov/apod/image/2102/rosette_goldman_2500.jpg';

void main() => runApp(SurfaceExample());

class SurfaceExample extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      // debugShowCheckedModeBanner: false,
      title: 'Surface Example',
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.from(
        colorScheme: ColorScheme.fromSwatch(
          /// `ColorScheme.primary.withBlack(100)` is fallback for `Surface.baseColor`.
          primarySwatch: _COLOR_PRIMARY,
          brightness: Brightness.light,
          accentColor: _COLOR_ACCENT,

          /// Color extension `Color.withBlack(int subtract)`
          /// added as an extra goodie from Surface package.
          backgroundColor: _COLOR_PRIMARY.withBlack(150),
        ).copyWith(
          /// `ColorScheme.surface` is fallback for `Surface.color`.
          surface: _COLOR_ACCENT.withWhite(50).withOpacity(0.3),
        ),
      ).copyWith(
        /// 🏓 [BouncyBall] is another goodie included with the 🌟 [Surface] package.
        splashFactory: BouncyBall.splashFactory,
        // splashFactory: BouncyBall.splashFactory2,
        // splashFactory: BouncyBall.splashFactory3,
        // splashFactory: BouncyBall.splashFactory4,
        // splashFactory: BouncyBall.marbleFactory,
        // splashFactory: moldedBouncyBalls,

        /// Surface `TapSpecLegacy.inkHighlightColor` and `inkSplashColor` default to ThemeData.
        splashColor: _COLOR_ACCENT,
        highlightColor: _COLOR_PRIMARY.withOpacity(0.3),
      ),
      home: const Landing(),
    );
  }
}

class SurfaceExampleDrawer extends StatefulWidget {
  const SurfaceExampleDrawer({Key? key}) : super(key: key);

  @override
  _SurfaceExampleDrawerState createState() => _SurfaceExampleDrawerState();
}

class _SurfaceExampleDrawerState extends State<SurfaceExampleDrawer> {
  Curvature concavityPalette = Curvature.convex,
      concavityBallPit = Curvature.convex;

  Curvature togglePalette() => concavityPalette == Curvature.concave
      ? concavityPalette = Curvature.convex
      : concavityPalette = Curvature.concave;
  Curvature toggleBallPit() => concavityBallPit == Curvature.concave
      ? concavityBallPit = Curvature.convex
      : concavityBallPit = Curvature.concave;

  @override
  Widget build(BuildContext context) => Container(
        color: _COLOR_PRIMARY[900]!,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTapDown: (details) => setState(() => togglePalette()),
                    onTapCancel: () => setState(() => togglePalette()),
                    child: buildSurfaceTile(
                      context,
                      concavity: concavityPalette,
                      onSurface: '🎨\n'
                          'Surface\n'
                          'Palette',
                      newView: const SurfacePalette(),
                    ),
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTapDown: (details) => setState(() => toggleBallPit()),
                    onTapCancel: () => setState(() => toggleBallPit()),
                    child: buildSurfaceTile(
                      context,
                      concavity: concavityBallPit,
                      onSurface: '🏓\n'
                          'Ball\n'
                          'Pit',
                      newView: const BallPit(),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTapDown: (details) => setState(() => togglePalette()),
                    onTapCancel: () => setState(() => togglePalette()),
                    child: buildAnimatedContainer(
                      concavity: concavityPalette,
                      child: buildAnimatedContainer(
                        concavity: concavityBallPit,
                        child: buildAnimatedContainerTile(
                          context,
                          concavity: concavityPalette,
                          onSurface: '🎨\n'
                              'Surface\n'
                              'Palette',
                          newView: const SurfacePalette(),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTapDown: (details) => setState(() => toggleBallPit()),
                    onTapCancel: () => setState(() => toggleBallPit()),
                    child: buildAnimatedContainer(
                      concavity: concavityBallPit,
                      child: buildAnimatedContainer(
                        concavity: concavityPalette,
                        child: buildAnimatedContainerTile(
                          context,
                          concavity: concavityBallPit,
                          onSurface: '🏓\n'
                              'Ball\n'
                              'Pit',
                          newView: const BallPit(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget buildSurfaceTile(
    BuildContext context, {
    required Curvature concavity,
    required Widget newView,
    required String onSurface,
    VoidCallback? onTap,
  }) =>
      Surface.tactile(
        shape: Shape(
          corners: Corners.roundWith(),
          radius: CornerRadius.all(Circular(25.0.asPX)),
        ),
        appearance: Appearance(
          width: 200.0.asPX,
          height: 200.0.asPX,
          padding: const EdgeInsets.all(25),
          // The shadows from `Appearance` come not from this `decoration`
          // (though it does provide a `List<BoxShadow>`) ...
          decoration: Neu.boxDecoration(
            curvature: concavity,
            color: _COLOR_PRIMARY[900]!,
            depth: 25,
            spread: 10,
            // isEmbossed: true,
          ),
          // ...but from this separate field instead. As a major plus, these
          // `ShapeShadow`s can be painted as a gradient instead of just a color!
          shadows: Neu.shapeShadows(
            curvature: concavity,
            color: _COLOR_PRIMARY[900]!,
            depth: 25,
            spread: 10,
            // isEmbossed: true,
          ),
        ),
        tactility: Tactility(
          inkHighlightColor: Colors.transparent,
          inkSplashColor: Colors.transparent,
          onTap: () {
            onTap?.call();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => newView,
              ),
            );
          },
        ),
        child: Text(
          onSurface,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

  Widget buildAnimatedContainerTile(
    BuildContext context, {
    required Curvature concavity,
    required Widget newView,
    required String onSurface,
    VoidCallback? onTap,
  }) =>
      AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
        width: 200.0,
        height: 200.0,
        padding: const EdgeInsets.all(25),
        // Declare borderRadius within decoration:
        decoration: Neu.boxDecoration(
          color: _COLOR_PRIMARY[900]!,
          curvature: concavity,
          depth: 25,
          spread: 10,
          // isEmbossed: true,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          onSurface,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

  Widget buildAnimatedContainer({
    required Curvature concavity,
    required Widget child,
  }) =>
      AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
        width: 200.0,
        height: 200.0,
        padding: const EdgeInsets.all(25),
        // Declare borderRadius within decoration:
        decoration: Neu.boxDecoration(
          curvature: concavity,
          color: _COLOR_PRIMARY[900]!,
          depth: 25,
          spread: 10,
          // isEmbossed: true,
          borderRadius: BorderRadius.circular(25),
        ),
        child: child,
      );
}

class Landing extends StatefulWidget {
  const Landing({Key? key}) : super(key: key);
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  int _counter = 0;
  late double _width, _height;
  late Color _primary, _accent;
  bool _isExampleBeveled = true,
      _showExamplePopup = false,
      _flipGradient = false;
  late Timer appBarGradientTimer;

  /// Because this is a sample app...
  void _incrementCounter() => setState(() => _counter++);

  /// Override the initState and set a Timer
  @override
  void initState() {
    super.initState();

    /// Showing the intrinsic animations of [Surface] by changing the LinearGradient
    /// in [_surfaceAsAppBar] after a few seconds, around the time the [_buildBackground]
    /// image loads in.
    appBarGradientTimer = Timer(
      Duration(milliseconds: 2600),
      () => setState(() => _flipGradient = true),
    );
  }

  @override
  Widget build(BuildContext context) {
    /// Store display resolution each time this [_LandingState] is built.
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;

    /// And give ourselves some shorter name for access to [Theme] colors.
    _primary = Theme.of(context).primaryColor;
    _accent = Theme.of(context).accentColor;

    /// This base Surface's color is only visually present beneath and before
    /// [_buildBackground] loads the background graphic.
    return WillPopScope(
      onWillPop: () async {
        if (_showExamplePopup) {
          setState(() => _showExamplePopup = false);
          return false;
        }

        return true;
      },
      child: Surface.tactile(
        // morph: morph,
        shape: const Shape(
          corners: Corners(),
        ),
        appearance: Appearance.primitive(
          color: Theme.of(context).backgroundColor,
        ),

        /// Because a Surface is `TapSpecLegacy.tappable` by default,
        /// these two `Color` params will customize the appearance of
        /// the long-press InkResponse... which are initialized identically
        /// in main MaterialApp `ThemeData`.
        ///
        /// As these Theme colors are defaulted to by TapSpecs,
        /// we will skip initializing them on future TapSpecs.
        tactility: Tactility(
          inkSplashColor: _accent,
          inkHighlightColor: _primary.withOpacity(0.5),
        ),

        /// Application Scaffold
        child: Scaffold(
          backgroundColor: Colors.transparent,
          drawer: const SurfaceExampleDrawer(),
          appBar: AppBar(
            title: const Text('Surface Example'),

            /// ➖ Surface as AppBar
            flexibleSpace: _surfaceAsAppBar(),

            /// This button in the AppBar will toggle the bool that displays
            /// [_surfaceAsPopup] found later in this Stack
            /// (and above [_surfaceAsWindow] in Z-Axis).
            actions: <Widget>[
              IconButton(
                icon: Icon((_showExamplePopup)
                    ? Icons.close
                    : Icons.note_add_outlined),
                onPressed: () =>
                    setState(() => _showExamplePopup = !_showExamplePopup),
              )
            ],
          ),

          /// Scaffold Body
          body: Stack(
            children: [
              /// 🌆 Background Image
              _buildBackground(),

              /// 🔳 Surface as Window
              Stack(
                children: [
                  Positioned(
                    top: _height * 0.075,
                    left: _width / 10,
                    child: _surfaceAsWindow(
                      context,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'A nice, basic counter example'.toUpperCase(),
                            style: Theme.of(context).textTheme.overline,
                          ),
                          Text(
                            'Number of + Presses:',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headline4,
                          ),
                          Text(
                            '$_counter',
                            style: Theme.of(context).textTheme.headline1,
                          )
                        ],
                      ),
                    ),
                  ),

                  /// ✂ State-control button swaps a few colors in the app and toggles
                  /// the [corners] property of [surfaceAsWindow] between ROUND and BEVEL.
                  _stateControlButton(isShadow: true),
                  _stateControlButton(),
                ],
              ),

              /// ❗ Surface as Popup
              /// Visually not present unless [_showExamplePopup] == true.
              Center(
                child: _surfaceAsPopup(),
              ),
            ],
          ),

          /// FAB
          floatingActionButton: SizedBox(
            width: 375,
            height: 375,
            child: Stack(
              /// 🔘 Surface as Floating Action Button
              children: <Widget>[
                Align(
                  alignment: Alignment(1, -1),
                  child: _surfaceAsFAB(
                    filteredLayers: const {SurfaceLayer.FOUNDATION},
                    passedString: 'filteredLayers:\nFOUNDATION',
                  ),
                ),
                Align(
                  alignment: Alignment(-1, 1),
                  child: _surfaceAsFAB(
                    filteredLayers: const {SurfaceLayer.MATERIAL},
                    passedString: 'filteredLayers:\nMATERIAL',
                  ),
                ),
                Align(
                  alignment: Alignment(1, 1),
                  child: _surfaceAsFAB(
                    filteredLayers: const {SurfaceLayer.CHILD},
                    passedString: 'filteredLayers:\nCHILD',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 🌆 Background Image
  Image _buildBackground() {
    return Image.network(
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
      width: _width,
      height: _height,
    );
  }

  /// ### ➖ Surface As AppBar
  Widget _surfaceAsAppBar() {
    return Surface.founded(
      duration: _DURATION * 4,
      curve: _CURVE,
      shape: Shape(
          corners: Corners.bevelWith(
              topLeft: Corner.SQUARE, topRight: Corner.SQUARE),
          radius: CornerRadius.all(Circular(Length(15)))),
      appearance: Appearance(
        width: _width.asPX,
        height: 100.asPX,
        decoration: BoxDecoration(
          /// The Timer created during initState() counts down a few seconds,
          /// then flips this gradient for a cool effect.
          gradient: LinearGradient(
            begin:
                (_flipGradient) ? Alignment.centerRight : Alignment.centerLeft,
            end: (_flipGradient) ? Alignment.centerLeft : Alignment.centerRight,
            colors: [_accent, _primary],
            stops: (_flipGradient) ? [0, 0.25] : [0, 0.75],
          ),
        ),
      ),

      /// Ensure the border is very thin at edges of screen to not obscure system
      /// navbar, but use `alignment` & `ratio` to give the
      /// bottom edge some girth.
      foundation:
          const Foundation(peek: 2, ratio: 12, exposure: Alignment.topCenter)
              .copyWith(
        appearance: Appearance(
          decoration: BoxDecoration(
            /// Easily we've given the system navbar a bright shine at top-left edge
            /// corner with this gradient Alignment and the `baseGradient` parameter.
            gradient: LinearGradient(
              begin: const Alignment(-1, -1),
              end: const Alignment(-0.97, 1),
              colors: <Color>[
                _primary.withWhite(100),
                _primary,
                _primary.withBlack(50),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ### 🔳 Surface As Window
  Widget _surfaceAsWindow(
    BuildContext context, {
    required Widget child,
  }) =>
      Surface.founded(
        shape: Shape(
          corners: Corners(
            topLeft: (_isExampleBeveled) ? Corner.NONE : Corner.SQUARE,
            bottomLeft: Corner.SQUARE,
          ),
          radius: CornerRadius.all(Circular(Length(50))),
        ),

        filter: Filter(
          radiusFoundation: 5.0,
          // radiusMaterial: 5.0,
          // radiusChild: 20.0,
        ),

        tactility: const Tactility(vibrates: true),

        foundation: Foundation(
          peek: 25,
          ratio: 5,
          exposure: Alignment.bottomRight,
          shape: Shape(corners: Corners(bottomLeft: Corner.CUTOUT)),
          appearance: Appearance(
            width: (0.8 * _width).asPX,
            height: (0.75 * _height).asPX,
            shadows: [
              ShapeShadow(
                blurRadius: 10,
                spreadRadius: 4,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: (_isExampleBeveled)
                      ? <Color>[
                          _primary.withOpacity(0.75),
                          _accent.withOpacity(0.75),
                        ]
                      : <Color>[
                          _accent.withBlack(50).withOpacity(0.75),
                          _primary.withBlack(50).withOpacity(0.75),
                        ],
                ),
              )
            ],
            decoration: BoxDecoration(
              // image: DecorationImage(
              //   image: NetworkImage(
              //       'https://getwallpapers.com/wallpaper/full/a/1/f/615763.jpg'),
              //   fit: BoxFit.cover,
              // ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: (_isExampleBeveled)
                    ? <Color>[
                        _primary.withWhite(50).withOpacity(0),
                        _primary.withBlack(50).withOpacity(0)
                      ]
                    : <Color>[
                        _accent.withWhite(50).withOpacity(0),
                        _accent.withBlack(50).withOpacity(0)
                      ],
              ),
            ),
          ),
        ),

        appearance: Appearance(
          width: (0.6 * _width).asPX,
          height: (0.65 * _height).asPX,
          shadows: [
            ShapeShadow(
              blurRadius: 10,
              spreadRadius: 4,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: (_isExampleBeveled)
                    ? <Color>[
                        _accent.withBlack(50).withOpacity(0.75),
                        _primary.withBlack(50).withOpacity(0.75),
                      ]
                    : <Color>[
                        _primary.withOpacity(0.75),
                        _accent.withOpacity(0.75),
                      ],
              ),
            )
          ],
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.15),
            image: DecorationImage(
              image: NetworkImage(
                  'https://getwallpapers.com/wallpaper/full/a/1/f/615763.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),

        child: child,
        duration: _DURATION,
        curve: _CURVE,
        // width: _width * 0.8,
        // height: _height * 0.75,
        // padding: const EdgeInsets.all(50),
        // shape: Shape(
        //   // childScale: 0.75,
        //   shapeScaleMaterial: 0.7,
        //   // corners: (_isExampleBeveled)
        //   //     ? CornerSpec.BIBEVELED_50_FLIP
        //   //     : CornerSpec.CIRCLE,
        //   corners: CornerSpec(
        //     topLeft: (_isExampleBeveled) ? Corner.BEVEL : Corner.NONE,
        //     topRight: (_isExampleBeveled) ? Corner.NONE : Corner.ROUND,
        //     bottomRight: (_isExampleBeveled) ? Corner.SQUARE : Corner.BEVEL,
        //     bottomLeft: (_isExampleBeveled) ? Corner.ROUND : Corner.SQUARE,
        //     radius: BorderRadius.all(Radius.circular(35)),
        //   ),
        //   // baseCorners: CornerSpec(
        //   //   topLeft: (_isExampleBeveled) ? Corner.BEVEL : Corner.SQUARE,
        //   //   topRight: Corner.NONE,
        //   //   radius: BorderRadius.all(Radius.circular(165)),
        //   // ),
        // ),
        // peek: PeekLegacy(
        //   peek: 20,
        //   ratio: (_isExampleBeveled) ? 2.5 : 5,
        //   alignment:
        //       (_isExampleBeveled) ? Alignment.bottomRight : Alignment.topCenter,
        // ),
        // TapSpecLegacy: const TapSpecLegacy(
        //   // tappable: false,
        //   inkSplashColor: Colors.deepPurpleAccent,
        // ),
        // filter: Filter(
        //   // filteredLayers: FilterSpec.TRILAYER,
        //   filteredLayers: Filter.NONE, // Overrides `radii` below
        //   radiusBase: 1.0,
        //   radiusMaterial: 2.0,
        //   // radiusChild: 20.0,

        //   /// `filteredLayers: FilterSpec.NONE` above so `specRadius` == 0,
        //   /// but `SurfaceLayer` is still delivered.
        //   effect: (double specRadius, SurfaceLayer layerForRender) =>

        //       /// Overrides both the `filteredLayers` AND `radii` above
        //       // FX.b(specRadius), // but when `FilterSpec.NONE` -> `specRadius` == 0, so
        //       FX.b(layerForRender == SurfaceLayer.CHILD ? specRadius : 2.5),
        // ),
        // baseColor: Colors.black38,
      );

  /// ### ✂ State Control Button
  Widget _stateControlButton({bool isShadow = false}) {
    double top = (_isExampleBeveled) ? _height * 0.1 : (_height * 0.1) / 2;
    double left = (_isExampleBeveled) ? _width / 7 : (_width / 7) / 3;
    Color color = (_isExampleBeveled) ? _accent : _primary;

    return AnimatedPositioned(
      duration: _DURATION * 4,
      curve: Curves.elasticOut,
      top: (isShadow) ? top + 1 : top,
      left: (isShadow) ? left + 1 : left,

      /// This button will control state for our main central [surfaceAsWindow].
      ///
      /// `bool _isExampleBeveled` is utilized throughout this build to control appearance.
      child: IconButton(
        icon: Icon(
          (_isExampleBeveled) ? Icons.add_box_rounded : Icons.cut_sharp,
        ),
        color: (isShadow) ? color.withBlack(75) : color,
        iconSize: 50,
        onPressed: () => setState(() => _isExampleBeveled = !_isExampleBeveled),
      ),
    );
  }

  /// 🔘 Surface As FAB
  Widget _surfaceAsFAB({
    required Set<SurfaceLayer> filteredLayers,
    required String passedString,
  }) {
    return SizedBox(
      width: (_showExamplePopup) ? 0 : 175,
      height: (_showExamplePopup) ? 0 : 175,
      child: SurfaceXL(
        // isPane: true,
        depth: 40.0, // default
        duration: _DURATION * 2,
        shape: const Shape(
          corners: Corners.noneWith(),
          border: Stroke(color: Colors.white38, width: 10.0),
        ),
        appearance: Appearance(
          /// `surfaceAsPopup` is an overlaid window, but the FABs would
          /// still be above it if we did not consider `_showExamplePopup` when
          /// sizing/displaying them.
          width: (_showExamplePopup) ? 0.asPX : 175.asPX,
          height: (_showExamplePopup) ? 0.asPX : 175.asPX,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            /// Fun Color swap when using the [_stateControlButton]
            color: (_isExampleBeveled)
                ? _accent.withWhite(25).withOpacity(0.25)
                : _primary.withWhite(25).withOpacity(0.25),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Surface.founded(
            duration: _DURATION,
            appearance: Appearance(
              width: (_showExamplePopup) ? 0.asPX : 155.asPX,
              height: (_showExamplePopup) ? 0.asPX : 155.asPX,
              decoration: BoxDecoration(
                /// Transparent color allows the blur effect to be seen purely
                /// in these example cases.
                color: Colors.transparent,
                image: DecorationImage(
                  image: NetworkImage(
                    'https://sleepyti.me/wp-content/uploads/2019/09/home-logo-sleepy-time.png',
                  ),
                  alignment: Alignment.bottomCenter,
                ),
                // color: Colors.white12,
              ),
            ),

            shape: Shape(
              corners: Corners.noneWith(),
              border: Stroke(color: Colors.black12, width: 4.0),
            ),

            filter: Filter(
              filteredLayers: filteredLayers,
              radiusFoundation: 7.0,
              radiusMaterial: 2.0,
              radiusChild: 1.0,
            ),

            /// Obligatory Counter Example implementation;
            tactility: Tactility(
              // tappable: false, // `true` by default
              vibrates: true, // `false` by default
              onTap: _incrementCounter,
            ),

            /// Plus Icon and Label
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Flexible(
                    child: Icon(Icons.add, color: Colors.white, size: 35)),
                Flexible(
                  child: Text(
                    passedString + '\n\n\n',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12, color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ❗ Surface As Popup
  Surface _surfaceAsPopup() {
    return Surface(
      duration: _DURATION,
      curve: _CURVE,
      shape: Shape(
        corners: Corners.bevelWith(
          topLeft: Corner.SQUARE,
          topRight: Corner.ROUND,
        ),
        radius: CornerRadius.only(
          bottomLeft: Elliptical(150.asPX, 120.asPX),
          topRight: Circular(150.asPX),
        ),
      ),
      appearance: Appearance(
        /// Cover most of the screen
        width: (_showExamplePopup) ? (_width - 50).asPX : 0.asPX,
        height: (_showExamplePopup) ? (_height / 2).asPX : 0.asPX,
        padding: const EdgeInsets.all(50),

        /// Random color from Material primaries
        decoration: BoxDecoration(
            color: Colors.primaries[Random().nextInt(Colors.accents.length)]
                .withBlack(75)
                .withOpacity(0.4)),
      ),

      // Child and Material filters will occupy same space unless
      // `ShapeSpec(padLayer: SurfaceLayer.MATERIAL)`
      filter: const Filter(radiusMaterial: 4.0),

      /// Contents of [_surfaceAsPopup]
      child: Container(
        padding: const EdgeInsets.all(20),
        // color: Colors.black12,
        alignment: Alignment.center,
        child: const FittedBox(
          /// Using a FittedBox, feel free to use a huge fontSize.
          child: Text(
            'p o p u p',
            style: TextStyle(color: Colors.white, fontSize: 100),
          ),
        ),
      ),
    );
  }
}
