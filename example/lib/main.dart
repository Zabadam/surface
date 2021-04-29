library surface_example;

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

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

        /// Surface `TapSpec.inkHighlightColor` and `inkSplashColor` default to ThemeData.
        splashColor: _COLOR_ACCENT,
        highlightColor: _COLOR_PRIMARY.withOpacity(0.3),
      ),
      home: const Landing(),
    );
  }
}

class SurfaceExampleDrawer extends StatelessWidget {
  const SurfaceExampleDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          buildTile(context,
              onSurface: '🎨\n'
                  'Surface\n'
                  'Palette',
              newView: const SurfacePalette()),
          buildTile(context,
              onSurface: '🏓\n'
                  'Ball\n'
                  'Pit',
              newView: const BallPit()),
        ],
      ),
    );
  }

  Surface buildTile(
    BuildContext context, {
    required Widget newView,
    required String onSurface,
  }) {
    return Surface(
      width: 250.0,
      height: 250.0,
      padding: const EdgeInsets.all(25),
      peek: const Peek(peek: 10),
      shape: const Shape(
        corners: CornerSpec.ROUNDED,
        baseCorners: CornerSpec.SQUARED,
      ),
      baseColor: _COLOR_ACCENT[700],
      color: _COLOR_PRIMARY[900],
      tapSpec: TapSpec(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => newView,
          ),
        ),
      ),
      child: Text(
        onSurface,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 50,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class Landing extends StatefulWidget {
  const Landing({Key? key}) : super(key: key);

  @override
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
      child: Surface(
        shape: const Shape(
          corners: CornerSpec.SQUARED,
        ),
        peek: const Peek(peek: 0),
        color: Theme.of(context).backgroundColor,

        /// Because a Surface is `TapSpec.tappable` by default,
        /// these two `Color` params will customize the appearance of
        /// the long-press InkResponse... which are initialized identically
        /// in main MaterialApp `ThemeData`.
        ///
        /// As these Theme colors are defaulted to by TapSpec,
        /// we will skip initializing them on future TapSpecs.
        ///
        /// Also see main ThemeData where Surface goodies extra
        /// [CustomInk.splashFactory] is established for the ink stylization.
        tapSpec: TapSpec(
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'A nice, basic counter example'.toUpperCase(),
                            style: Theme.of(context).textTheme.overline,
                          ),
                          Text(
                            'Number of + Presses:',
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
          floatingActionButton: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,

            /// 🔘 Surface as Floating Action Button
            children: <Widget>[
              _surfaceAsFAB(
                filteredLayers: const {SurfaceLayer.MATERIAL},
                passedString: 'filteredLayers:\nMATERIAL',
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _surfaceAsFAB(
                    filteredLayers: Filter.BASE, // const {SurfaceLayer.BASE}
                    passedString: 'filteredLayers:\nBASE',
                  ),
                  _surfaceAsFAB(
                    filteredLayers: Filter.BASE_AND_MATERIAL,
                    // filteredLayers: const {
                    //   SurfaceLayer.BASE,
                    //   SurfaceLayer.MATERIAL
                    // },
                    passedString: 'filteredLayers:\nBASE &\nMATERIAL',
                  ),
                ],
              ),
            ],
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
  Surface _surfaceAsAppBar() {
    return Surface(
      duration: _DURATION * 4,
      curve: _CURVE,
      width: _width,
      height: double.infinity,
      shape: const Shape(corners: CornerSpec.SQUARED),

      /// The Timer created during initState() counts down a few seconds,
      /// then flips this gradient for a cool effect.
      gradient: LinearGradient(
        begin: (_flipGradient) ? Alignment.centerRight : Alignment.centerLeft,
        end: (_flipGradient) ? Alignment.centerLeft : Alignment.centerRight,
        colors: [_accent, _primary],
        stops: (_flipGradient) ? [0, 0.25] : [0, 0.75],
      ),

      /// Ensure the border is very thin at edges of screen to not obscure system
      /// navbar, but use `peekAlignment` & `peekRatio` to give the
      /// bottom edge some girth.
      peek: const Peek(
        peek: 1.5,
        peekRatio: 2,
        peekAlignment: Alignment.bottomCenter,
      ),

      /// Easily we've given the system navbar a bright shine at top-left edge
      /// corner with this gradient Alignment and the `baseGradient` parameter.
      baseGradient: LinearGradient(
        begin: const Alignment(-1, -1),
        end: const Alignment(-0.97, 1),
        colors: <Color>[
          _primary.withWhite(100),
          _primary,
          _primary.withBlack(50),
        ],
      ),
    );
  }

  /// ### 🔳 Surface As Window
  Surface _surfaceAsWindow(
    BuildContext context, {
    required Widget child,
  }) {
    return Surface(
      child: child,
      duration: _DURATION,
      curve: _CURVE,
      width: _width * 0.8,
      height: _height * 0.75,
      padding: const EdgeInsets.all(50),
      shape: Shape(
        // childScale: 0.75,
        materialScale: 0.7,
        // corners: (_isExampleBeveled)
        //     ? CornerSpec.BIBEVELED_50_FLIP
        //     : CornerSpec.CIRCLE,
        corners: CornerSpec(
          topLeft: (_isExampleBeveled) ? Corner.BEVEL : Corner.NONE,
          topRight: (_isExampleBeveled) ? Corner.NONE : Corner.ROUND,
          bottomRight: (_isExampleBeveled) ? Corner.SQUARE : Corner.BEVEL,
          bottomLeft: (_isExampleBeveled) ? Corner.ROUND : Corner.SQUARE,
          radius: BorderRadius.all(Radius.circular(35)),
        ),
        // baseCorners: CornerSpec(
        //   topLeft: (_isExampleBeveled) ? Corner.BEVEL : Corner.SQUARE,
        //   topRight: Corner.NONE,
        //   radius: BorderRadius.all(Radius.circular(165)),
        // ),
      ),
      peek: Peek(
        peek: 20,
        peekRatio: (_isExampleBeveled) ? 2.5 : 5,
        peekAlignment:
            (_isExampleBeveled) ? Alignment.bottomRight : Alignment.topCenter,
      ),
      tapSpec: const TapSpec(
        // tappable: false,
        inkSplashColor: Colors.deepPurpleAccent,
      ),
      filter: Filter(
        // filteredLayers: FilterSpec.TRILAYER,
        filteredLayers: Filter.NONE, // Override `radii` below
        baseRadius: 1.0,
        materialRadius: 2.0,
        childRadius: 20.0,

        /// `filteredLayers: FilterSpec.NONE` above so `specRadius` == 0,
        /// but `SurfaceLayer` is still delivered.
        effect: (double specRadius, SurfaceLayer layerForRender) =>

            /// Overrides both the `filteredLayers` AND `radii` above
            // FX.b(specRadius), // when `FilterSpec.NONE` -> `specRadius` == 0
            FX.b(layerForRender == SurfaceLayer.CHILD ? specRadius : 2.5),
      ),
      baseColor: Colors.black38,
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: (_isExampleBeveled)
            ? <Color>[
                _primary.withWhite(50).withOpacity(0.5),
                _primary.withBlack(50).withOpacity(0.5)
              ]
            : <Color>[
                _accent.withWhite(50).withOpacity(0.5),
                _accent.withBlack(50).withOpacity(0.5)
              ],
      ),
    );
  }

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
  Surface _surfaceAsFAB({
    required Set<SurfaceLayer> filteredLayers,
    required String passedString,
  }) {
    return Surface(
      /// `surfaceAsPopup` is an overlaid window, but the FABs would
      /// still be above it if we did not consider `_showExamplePopup` when
      /// sizing/displaying them.
      width: (_showExamplePopup) ? 0 : 175,
      height: (_showExamplePopup) ? 0 : 175,
      padding: const EdgeInsets.all(10),
      // padLayer: SurfaceLayer.MATERIAL,  // Default is [SurfacePadding.PAD_CHILD].
      duration: _DURATION,
      peek: const Peek(
        peek: 30,
        // peekAlignment: Alignment.bottomCenter,
        // peekRatio: 1.25,
      ),

      shape: const Shape(
        corners: CornerSpec.CIRCLE,
        baseBorder: BorderSide(color: Colors.black38, width: 5.0),
        border: BorderSide.none,
      ),

      /// Transparent color allows the blur effect to be seen purely
      /// in these example cases.
      color: Colors.transparent,
      // color: Colors.white12,

      /// Fun Color swap when using the [_stateControlButton]
      baseColor: (_isExampleBeveled)
          ? _accent.withWhite(25).withOpacity(0.25)
          : _primary.withWhite(25).withOpacity(0.25),
      filter: Filter(
        filteredLayers: filteredLayers,
        // Declaring a `radiusMap` is like explicitly declaring the doubles thus:
        // baseRadius: 3.0,
        // materialRadius: 15.0,
        radiusMap: const {
          SurfaceLayer.BASE: 3.0,
          SurfaceLayer.MATERIAL: 15.0,
        },
      ),

      /// Obligatory Counter Example implementation;
      tapSpec: TapSpec(
        // tappable: false, // `true` by default
        providesFeedback: true, // `false` by default
        onTap: _incrementCounter,
      ),

      /// Plus Icon and Label
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Flexible(child: Icon(Icons.add, color: Colors.white)),
          Flexible(
            child: Text(
              passedString,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: Colors.white),
            ),
          )
        ],
      ),
    );
  }

  /// ❗ Surface As Popup
  Surface _surfaceAsPopup() {
    return Surface(
      /// Cover most of the screen
      width: (_showExamplePopup) ? _width - 50 : 0,
      height: (_showExamplePopup) ? _height / 2 : 0,
      padding: const EdgeInsets.all(50),
      shape: Shape(
        // childScale: 1.0,
        // materialScale: 1.0,
        // childScale: 0.5,
        // materialScale: 0.8,
        padLayer: SurfaceLayer.MATERIAL, // Distinguishable layer for Filter
        corners: CornerSpec.beveledWith(
          topLeft: Corner.SQUARE,
          topRight: Corner.ROUND,
          bottomRight: Corner.ROUND,
          radius: BorderRadius.vertical(
            bottom: Radius.elliptical(200, 40),
            top: Radius.elliptical(80, 200),
          ),
        ),
      ),
      duration: _DURATION,
      curve: _CURVE,

      /// Random color from Material primaries
      color: Colors.primaries[Random().nextInt(Colors.accents.length)]
          .withBlack(75)
          .withOpacity(0.4),
      baseColor: Colors.black38, // defaults to `ColorScheme.primaryVariant`

      /// Giving a *thicker* edge when the [_surfaceAsPopup] is hidden `!(_showExamplePopup)`
      /// results in a neat expansion during the entrance animation.
      peek: Peek(
        // peek: 0,
        peek: (_showExamplePopup) ? 25 : 30,
        peekRatio: (_showExamplePopup) ? 4 : 7,
        peekAlignment: Alignment.topLeft,
      ),

      tapSpec: TapSpec(
        /// onTap here will just refresh the build and give a new random color
        onTap: () => setState(() {}),
        providesFeedback: true,
      ),

      // Child and Material filters will occupy same space unless
      // `ShapeSpec(padLayer: SurfaceLayer.MATERIAL)`
      filter: const Filter(
        filteredLayers: Filter.TRILAYER,
        radiusMap: {
          SurfaceLayer.BASE: 3.0,
          SurfaceLayer.MATERIAL: 4.0,
          SurfaceLayer.CHILD: 20.0
        },
      ),

      /// Contents of [_surfaceAsPopup]
      child: Container(
        padding: const EdgeInsets.all(20),
        color: Colors.black12,
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
