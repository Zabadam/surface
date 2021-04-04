# Surface Example

![Animated GIF preview of Surface Example app](https://github.com/Zabadam/surface/blob/main/doc/Surface-Example.gif?raw-true)

Example usage of the [Surface](https://github.com/Zabadam/surface) package for Flutter.
- [Surface Example Android source](https://github.com/Zabadam/surface/tree/main/example/lib/main.dart): `/example/lib/main.dart`
- [Surface Example APK](https://github.com/Zabadam/surface/tree/main/example/build/app/outputs/flutter-apk/app-release.apk)

## Usage

The landing view uses several 🌟 [Surface]s right off the bat.
- Background (under image)
- AppBar
- Main window
  - Try tapping and holding inside this container
- Floating Action Buttons
  - Three different FABs show three different 📚 [SurfaceLayer] layouts for 👓 [SurfaceFilterSpec.filteredLayers].

🏓 [CustomInk] is delegated as the InteractiveInkFeatureFactory.

🔦 [WithShading] extension on [Color] offers ⬛ [Color.withBlack] and ⬜ [Color.withWhite].

🌟 Surface uses a few Theme-derived fallbacks if not specified `Color`s.

Tapping the action button in the AppBar will present a Surface as a popup.

Swiping open the main Drawer or tapping the hamburger menu offers a button (that is, of course, a 🌟 Surface) leading to the next demo.
- [SurfacePalette] is a recreation of the Flutter Gallery presentation for Material Colors utilizing 🌟 Surfaces
  - Even the two new parameters offered in Surface [0.1.0+5] are employed for creative measures
    - 🆕 [Surface.baseRadius]
    - 🆕 [SurfaceFilterSpec.extendBaseFilter]


## TODO:

- Intrinsic animations of 📐 [Surface.corners] property change.
    - Currently there is a conditional swap where any Surface build method utilizes the Beveled Shape to a RoundedRect Shape.
    - Ideally, I believe, there would be a `Decoration.lerp()` involved.
    - This "aggravates" the simplicity of Surface to develop, but would provide a better end-user result:
      more accurate and performant animations that are just as easy to use. (Almost effortless? 😉)

- Differed radius on 📚 [SurfaceLayer.MATERIAL] vs 📚 [SurfaceLayer.BASE]
    - Smaller inner radius gives a better aesthetic for nested shapes.
    - 🆕 Manual setting of [Surface.radius] or [Surface.baseRadius] available now.

- Proposed 📐 [SurfaceCornerSpec] for 📐 [Surface.corners] property that allows customization
  of all four corners independently.

[Source for background image](https://apod.nasa.gov/apod/image/2102/rosette_goldman_2500.jpg "Don Goldman via NASA APOD")
