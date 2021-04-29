# 🌟 Surface Example
## [0.3.0] - 25 APR 21
#### Surface [0.3.0]
* Built a simple page to demonstrate new 🏓 `BouncyBall` features: `BallPit`, found in `Drawer`
* Include reference to new 🤹‍♂️ `SurfaceFX` features in main demo @L396

## [0.2.1] - 12 APR 21
#### Surface [0.2.0+6]
* Example migrate to sound null safety.

## [0.2.0] - 04 APR 21
#### Surface [0.1.0+5]
* Added a second route: to `SurfacePalette` which is a recreation of the Flutter Gallery
  MaterialColor presentation that utilizes 🌟 `Surface`s instead of Containers.
  * Make reference to new `Filter.extendBaseFilter` & `Surface.baseRadius` parameters
* Cleaned up comments that referred to old parameters.
* Incorporated more `const`

## [0.1.1] - 02 APR 21
* Updated Example to support new Surface parameters.

## [0.1.0] - 01 APR 21
* Updated Example to support new Surface parameters.
* Updated ThemeData to provide for new Surface fallbacks.
* Altered AppBar action IconButton to display `Icons.close` while the example popup is being displayed.
  * Also added WillPop to have Android Back ensure `bool _showExamplePopup == false` before exiting the application with Back.
* `_surfaceAsFAB` now has `Flexbile` children.

## [0.0.2] - 23 FEB 21
* Added a state boolean and Timer in initState to give `surfaceAsAppBar` a gradient flip effect, showing off intrinsic animation
* Added an onTap: () => setState((){}) to `surfaceAsPopup` for quick demonstration of random color animation
* Added some more comments
* Gave clearer names to the example state-controlling booleans
