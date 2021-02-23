import 'package:flutter/material.dart';
import 'package:surface/surface.dart';
import 'dart:math';
import 'dart:async';

const _PRIMARY_SWATCH = Colors.red;
const _ACCENT_COLOR = Colors.blue;
const _DURATION = Duration(milliseconds: 300);
const _CURVE = Curves.fastOutSlowIn;

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
          primarySwatch: _PRIMARY_SWATCH,
          brightness: Brightness.light,
          accentColor: _ACCENT_COLOR,

          /// Color extension `Color.withBlack(int subtract)` added as an
          /// extra goodie from Surface package.
          backgroundColor: _PRIMARY_SWATCH.withBlack(150),
        ),

        /// [CustomInk] is another goodie included with the Surface package
      ).copyWith(splashFactory: CustomInk.splashFactory),
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
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  /// Override the initState and seet a Timer
  @override
  void initState() {
    super.initState();

    /// Showing the intrinsic animations of [Surface] by changing the LinearGradient
    /// in [surfaceAsAppBar] after a few seconds, around the time the [buildBackground]
    /// image loads in.
    appBarGradientTimer = Timer(Duration(milliseconds: 2600),
        () => setState(() => _flipGradient = true));
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
    return Surface(
      corners: SurfaceCorners.SQUARE,
      disableBorder: true,
      color: Theme.of(context).backgroundColor,

      /// Because a [Surface] is [tappable] by default, these two Color params
      /// will customize the appearance of the long-press InkResponse.
      ///
      /// See [ThemeData] in [MaterialApp] where [CustomInk.splashFactory] i
      /// provided for the stylization.
      inkSplashColor: _accent,
      inkHighlightColor: _primary.withOpacity(0.5),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
            title: Text('Surface Example'),

            /// ➖ Surface as AppBar
            flexibleSpace: surfaceAsAppBar(),

            /// This button in the AppBar will toggle the bool that displays
            /// [surfaceAsPopup] found later in this Stack
            /// (and above [surfaceAsWindow] in Z-Axis).
            actions: [
              IconButton(
                icon: Icon(Icons.note_add_outlined),
                onPressed: () =>
                    setState(() => _showExamplePopup = !_showExamplePopup),
              )
            ]),

        /// Scaffold Body
        body: Stack(children: [
          /// 🌆 Background Graphic
          buildBackground(),

          /// 🔳 Surface as Window
          Stack(children: [
            Positioned(
              top: _height * 0.075,
              left: _width / 10,
              child: surfaceAsWindow(context,
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
                      ])),
            ),

            /// ✂ State-control button swaps a few colors in the app and toggles
            /// the [corners] property of [surfaceAsWindow] between ROUND and BEVEL.
            stateControlButton(isShadow: true),
            stateControlButton(),
          ]),

          /// ❗ Surface as Popup
          Center(child: surfaceAsPopup()),
        ]),

        /// FAB
        floatingActionButton: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,

            /// 🔘 Surface as Floating Action Button
            children: [
              surfaceAsFAB(
                passedFilterStyle: SurfaceFilter.MATERIAL,
                passedString: 'SurfaceFilter.\nMATERIAL',
              ),
              Row(mainAxisSize: MainAxisSize.min, children: [
                surfaceAsFAB(
                  passedFilterStyle: SurfaceFilter.SURFACE,
                  passedString: 'SurfaceFilter.\nSURFACE',
                ),
                surfaceAsFAB(
                  passedFilterStyle: SurfaceFilter.SURFACE_AND_MATERIAL,
                  passedString: 'SurfaceFilter.\nSURFACE_\nAND_MATERIAL',
                ),
              ]),
            ]),
      ),
    );
  }

  /// 🌆
  Image buildBackground() {
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

  /// ➖
  Surface surfaceAsAppBar() {
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
      borderAlignment: Alignment.bottomCenter,
      borderThickness: 1.5,
      borderRatio: 3.5,

      /// Easily we've given the system navbar a bright shine at top-left edge
      /// corner with this gradient Alignment and the [borderGradient] parameter.
      borderGradient: LinearGradient(
        begin: Alignment(-1, -1),
        end: Alignment(-0.97, 1),
        colors: [
          _primary.withWhite(100),
          _primary,
          _primary.withBlack(50),
        ],
      ),
      inkSplashColor: _accent,
      inkHighlightColor: _primary.withOpacity(0.5),
    );
  }

  /// 🔳
  Surface surfaceAsWindow(
    BuildContext context, {
    @required Widget child,
  }) {
    return Surface(
      width: _width * 0.8,
      height: _height * 0.75,
      padding: const EdgeInsets.all(15),
      duration: _DURATION,
      curve: _CURVE,
      filterStyle: SurfaceFilter.MATERIAL,
      corners:
          (_isExampleBeveled) ? SurfaceCorners.BEVEL : SurfaceCorners.ROUND,
      flipBevels: (_isExampleBeveled) ? true : null,

      /// This [color] pass would make a print in console and be replaced
      /// by [gradient] underneath.
      // color: _primary,
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: (_isExampleBeveled)
            ? [_primary.withWhite(50), _primary.withBlack(50)]
            : [
                _accent.withWhite(50).withOpacity(0.5),
                _accent.withBlack(50).withOpacity(0.5)
              ],
      ),
      borderColor: Colors.black54,
      radius: 50,
      borderAlignment:
          (_isExampleBeveled) ? Alignment.bottomRight : Alignment.topCenter,
      borderThickness: 20,
      borderRatio: (_isExampleBeveled) ? 2.5 : 5,
      inkSplashColor: _accent,
      inkHighlightColor: _primary.withOpacity(0.5),
      child: child,
    );
  }

  /// ✂
  Widget stateControlButton({bool isShadow = false}) {
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

  /// 🔘
  Surface surfaceAsFAB({
    @required SurfaceFilter passedFilterStyle,
    @required String passedString,
  }) {
    return Surface(
        duration: _DURATION,

        /// Default [Surface.corners] is [SurfaceCorners.ROUND]
        radius: 100,
        borderThickness: 30,
        // paddingStyle: SurfacePadding.PAD_SURFACE,  // Default is [SurfacePadding.PAD_CHILD].
        padding: const EdgeInsets.all(10),

        /// Transparent color allows the blur effect to be seen purely
        /// in these example cases.
        color: Colors.transparent,
        // color: Colors.white12,

        /// `bool _showExamplePopup` is an overlaid window, but the FABs would
        /// still above it if we did not consider `_showExamplePopup` when
        /// sizing/displaying them.
        width: (_showExamplePopup) ? 0 : 175,
        height: (_showExamplePopup) ? 0 : 175,

        /// Fun Colow swap when using the [stateControlButton]
        borderColor: (_isExampleBeveled)
            ? _accent.withWhite(25).withOpacity(0.25)
            : _primary.withWhite(25).withOpacity(0.25),

        /// 🔬 [SurfaceFilter.SURFACE_AND_MATERIAL] results in two layers of
        /// blur filtering, while the the other two options here
        /// result in only one layer of blur.
        filterStyle: passedFilterStyle,
        // filterStyle: SurfaceFilter.SURFACE_AND_MATERIAL,
        // filterStyle: SurfaceFilter.SURFACE,
        // filterStyle: SurfaceFilter.MATERIAL,
        filterSurfaceBlur: 3,
        filterMaterialBlur: 15,

        /// Obligatory Counter Example implementation;
        /// By default, a [Surface] is tappable with an [InkResponse], but
        /// [providesFeedback] vibration is disabled by default.
        onTap: _incrementCounter,
        providesFeedback: true, // `false` by default
        // tappable: false, // `true` by default

        /// Plus Icon and Label required [passedString]
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,

            /// If the [surfaceAsPopup] is present on screen, hide the FABs
            /// children (as well as sizing the FABs down to 0) to prevent overflow.
            children: (_showExamplePopup)
                ? []
                : [
                    Icon(Icons.add, color: Colors.white),
                    Text(
                      passedString,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    )
                  ]));
  }

  /// ❗
  Surface surfaceAsPopup() {
    return Surface(
      /// Cover most of the screen
      width: (_showExamplePopup) ? _width - 50 : 0,
      height: (_showExamplePopup) ? _height / 2 : 0,

      /// Random color from Material accents
      color: Colors.accents[Random().nextInt(Colors.accents.length)]
          .withWhite(50)
          .withOpacity(0.4),

      /// Giving a *thicker* border when the [surfaceAsPopup] is hidden
      /// !(_showExamplePopup) results in a neat expansion during the appearance animation.
      borderThickness: (_showExamplePopup) ? 20 : 30,
      borderRatio: (_showExamplePopup) ? 3 : 7,
      borderAlignment: Alignment.topCenter,
      borderColor: (_showExamplePopup) ? Colors.black26 : Colors.transparent,

      /// These would be fine-tuned for the appearance you are looking to achieve.
      duration: _DURATION,
      curve: _CURVE,
      providesFeedback: true,
      filterStyle: SurfaceFilter.TRILAYER,
      filterSurfaceBlur: 3,
      filterMaterialBlur: 5,
      filterChildBlur: 50,
      padding: const EdgeInsets.all(75),
      paddingStyle: SurfacePadding.PAD_SURFACE,

      /// onTap here will just refresh the build and give a new random color
      onTap: () => setState(() {}),

      /// Contents of [surfaceAsPopup]
      child: Container(
        color: Colors.transparent,
        alignment: Alignment.center,
        child: Text('p o p u p',
            style: TextStyle(color: Colors.white, fontSize: 40)),
      ),
    );
  }
}
