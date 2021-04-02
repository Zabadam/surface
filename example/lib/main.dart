import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

import 'package:surface/surface.dart';

const _COLOR_PRIMARY = Colors.red;
const _COLOR_ACCENT = Colors.blue;
const _DURATION = Duration(milliseconds: 450);
const _CURVE = Curves.easeInOutCirc;

void main() {
  runApp(SurfaceExample());
}

class SurfaceExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.from(
        colorScheme: ColorScheme.fromSwatch(
          /// `ColorScheme.primaryVariant` is fallback for `Surface.baseColor`.
          primarySwatch: _COLOR_PRIMARY,
          brightness: Brightness.light,
          accentColor: _COLOR_ACCENT,

          /// Color extension `Color.withBlack(int subtract)`
          /// added as an extra goodie from Surface package.
          backgroundColor: _COLOR_PRIMARY.withBlack(150),
        ).copyWith(
          /// `ColorScheme.surface` is fallback for `Surface.color`.
          surface: _COLOR_PRIMARY.withBlack(100).withOpacity(0.3),
        ),
      ).copyWith(
        /// CustomInk is another goodie included with the Surface package.
        splashFactory: CustomInk.splashFactory,

        /// Surface `SurfaceTapSpec.inkHighlightColor` and `inkSplashColor` default to ThemeData.
        splashColor: _COLOR_ACCENT,
        highlightColor: _COLOR_PRIMARY.withOpacity(0.3),
      ),
      home: Landing(),
    );
  }
}

class Landing extends StatefulWidget {
  Landing({Key key}) : super(key: key);

  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  double _width, _height;
  Color _primary, _accent;
  int _counter = 0;
  bool _isExampleBeveled = true;
  bool _showExamplePopup = false, _flipGradient = false;
  Timer appBarGradientTimer;

  /// Because this is a sample app...
  void _incrementCounter() => setState(() => _counter++);

  /// Override the initState and seet a Timer
  @override
  void initState() {
    super.initState();

    /// Showing the intrinsic animations of [Surface] by changing the LinearGradient
    /// in [surfaceAsAppBar] after a few seconds, around the time the [buildBackground]
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
    /// [_LandingState.buildBackground] loads the background graphic.
    return WillPopScope(
      onWillPop: () async {
        if (_showExamplePopup) {
          setState(() => _showExamplePopup = false);
          return false;
        }

        return true;
      },
      child: Surface(
        corners: SurfaceCorners.SQUARE,
        disableBase: true,
        color: Theme.of(context).backgroundColor,

        /// Because a Surface is `SurfaceTapSpec.tappable` by default,
        /// these two `Color` params will customize the appearance of
        /// the long-press InkResponse... which are initialized indentically
        /// in main MaterialApp `ThemeData`.
        ///
        /// As these Theme colors are defaulted to by SurfaceTapSpec,
        /// we will skip initializing them on future Surface SurfaceTapSpecs.
        ///
        /// Also see main ThemeData where Surface goodies extra
        /// [CustomInk.splashFactory] is established for the ink stylization.
        tapSpec: SurfaceTapSpec(
          inkSplashColor: _accent,
          inkHighlightColor: _primary.withOpacity(0.5),
        ),

        /// Application Scaffold
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text('Surface Example'),

            /// ➖ Surface as AppBar
            flexibleSpace: _surfaceAsAppBar(),

            /// This button in the AppBar will toggle the bool that displays
            /// [surfaceAsPopup] found later in this Stack
            /// (and above [surfaceAsWindow] in Z-Axis).
            actions: [
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
                        children: [
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
            children: [
              _surfaceAsFAB(
                filteredLayers: {SurfaceLayer.MATERIAL},
                passedString: 'filteredLayers:\nMATERIAL',
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _surfaceAsFAB(
                    filteredLayers: {SurfaceLayer.BASE},
                    passedString: 'filteredLayers:\nBASE',
                  ),
                  _surfaceAsFAB(
                    filteredLayers: {SurfaceLayer.BASE, SurfaceLayer.MATERIAL},
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
      'https://apod.nasa.gov/apod/image/2102/rosette_goldman_2500.jpg',

      /// This frameBuilder simply fades in the photo when it loads.
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) return child;
        return AnimatedOpacity(
          child: child,
          opacity: frame == null ? 0 : 1,
          duration: _DURATION * 2,
          curve: _CURVE,
        );
      },

      /// Stretch the photo to the size of the app and have it cover the Surface.
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
      corners: SurfaceCorners.SQUARE,
      // color: _primary,

      /// The Timer created during initState() counts down a few seconds,
      /// then flips this gradient for a cool effect.
      gradient: LinearGradient(
        begin: (_flipGradient) ? Alignment.centerRight : Alignment.centerLeft,
        end: (_flipGradient) ? Alignment.centerLeft : Alignment.centerRight,
        colors: [_accent, _primary],
        stops: (_flipGradient) ? [0, 0.25] : [0, 0.75],
      ),

      /// Ensure the border is very thin at edges of screen to not obscure system
      /// navbar, but use [borderAlignment] & [borderRatio] to give the
      /// bottom edge some girth.
      peekSpec: SurfacePeekSpec(
        peekAlignment: Alignment.bottomCenter,
        peek: 1.5,
        peekRatio: 3.5,
      ),

      /// Easily we've given the system navbar a bright shine at top-left edge
      /// corner with this gradient Alignment and the [borderGradient] parameter.
      baseGradient: LinearGradient(
        begin: Alignment(-1, -1),
        end: Alignment(-0.97, 1),
        colors: [
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
    @required Widget child,
  }) {
    return Surface(
      child: child,
      width: _width * 0.8,
      height: _height * 0.75,
      padding: const EdgeInsets.all(15),

      corners:
          (_isExampleBeveled) ? SurfaceCorners.BEVEL : SurfaceCorners.ROUND,
      flipBevels: (_isExampleBeveled) ? true : null,
      radius: 50,
      peekSpec: SurfacePeekSpec(
        peek: 20,
        peekRatio: (_isExampleBeveled) ? 2.5 : 5,
        peekAlignment:
            (_isExampleBeveled) ? Alignment.bottomRight : Alignment.topCenter,
      ),

      duration: _DURATION,
      curve: _CURVE,
      filterSpec: SurfaceFilterSpec(
        // default blur radius of 4.0
        filteredLayers: {SurfaceLayer.MATERIAL},
      ),

      baseColor: Colors.black38,
      // This [color] pass is overridden by [gradient].
      color: ((_isExampleBeveled) ? _primary : _accent).withOpacity(0.3),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: (_isExampleBeveled)
            ? [
                _primary.withWhite(50).withOpacity(0.5),
                _primary.withBlack(50).withOpacity(0.5)
              ]
            : [
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
    @required Set<SurfaceLayer> filteredLayers,
    @required String passedString,
  }) {
    return Surface(

        /// `bool _showExamplePopup` is an overlaid window, but the FABs would
        /// still above it if we did not consider `_showExamplePopup` when
        /// sizing/displaying them.
        width: (_showExamplePopup) ? 0 : 175,
        height: (_showExamplePopup) ? 0 : 175,
        // padLayer: SurfaceLayer.MATERIAL,  // Default is [SurfacePadding.PAD_CHILD].
        padding: const EdgeInsets.all(10),
        duration: _DURATION,
        peekSpec: SurfacePeekSpec(peek: 30),

        /// Default [Surface.corners] is [SurfaceCorners.ROUND]
        radius: 100,

        /// Transparent color allows the blur effect to be seen purely
        /// in these example cases.
        color: Colors.transparent,
        // color: Colors.white12,

        /// Fun Color swap when using the [_stateControlButton]
        baseColor: (_isExampleBeveled)
            ? _accent.withWhite(25).withOpacity(0.25)
            : _primary.withWhite(25).withOpacity(0.25),
        filterSpec: SurfaceFilterSpec(
          filteredLayers: filteredLayers,
          radiusMap: {SurfaceLayer.BASE: 3.0, SurfaceLayer.MATERIAL: 15.0},
          // Declaring a radiusMap is like explicitly declaring the doubles here:
          // baseRadius: 3.0,
          // materialRadius: 15.0,
        ),

        /// Obligatory Counter Example implementation;
        tapSpec: SurfaceTapSpec(
          // tappable: false, // `true` by default
          providesFeedback: true, // `false` by default
          onTap: _incrementCounter,
        ),

        /// Plus Icon and Label required [passedString]
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,

            /// If the [surfaceAsPopup] is present on screen, hide the FABs
            /// children (as well as sizing the FABs down to 0) to prevent overflow.
            children: [
              Flexible(child: Icon(Icons.add, color: Colors.white)),
              Flexible(
                child: Text(
                  passedString,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              )
            ]));
  }

  /// ❗ Surface As Popup
  Surface _surfaceAsPopup() {
    return Surface(
      /// Cover most of the screen
      width: (_showExamplePopup) ? _width - 50 : 0,
      height: (_showExamplePopup) ? _height / 2 : 0,
      padding: const EdgeInsets.all(75),
      padLayer: SurfaceLayer.MATERIAL,
      duration: _DURATION,
      curve: _CURVE,

      /// Random color from Material primaries
      color: Colors.primaries[Random().nextInt(Colors.accents.length)]
          .withBlack(75)
          .withOpacity(0.2),
      // baseColor: Colors.black26, // defaults to `ColorScheme.primaryVariant`

      /// Giving a *thicker* edge when the [surfaceAsPopup] is hidden `!(_showExamplePopup)`
      /// results in a neat expansion during the entrance animation.
      peekSpec: SurfacePeekSpec(
        peek: (_showExamplePopup) ? 25 : 30,
        peekRatio: (_showExamplePopup) ? 4 : 7,
        peekAlignment: Alignment.topLeft,
      ),

      tapSpec: SurfaceTapSpec(
        /// onTap here will just refresh the build and give a new random color
        onTap: () => setState(() {}),
        providesFeedback: true,
      ),

      filterSpec: SurfaceFilterSpec(
        filteredLayers: {
          SurfaceLayer.BASE,
          SurfaceLayer.MATERIAL,
          SurfaceLayer.CHILD,
        },
        radiusMap: {
          SurfaceLayer.BASE: 3.0,
          SurfaceLayer.MATERIAL: 4.0,
          SurfaceLayer.CHILD: 20.0
        },
      ),

      /// Contents of [_surfaceAsPopup]
      child: Container(
        color: Colors.black12,
        alignment: Alignment.center,
        child: FittedBox(
          child: Text(
            'p o p u p',
            style: TextStyle(color: Colors.white, fontSize: 40),
          ),
        ),
      ),
    );
  }
}
