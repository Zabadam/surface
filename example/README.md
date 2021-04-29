# 🌟 Surface Example

![Animated GIF preview of Surface Example app](https://github.com/Zabadam/surface/blob/main/doc/Surface-Example.gif?raw=true)
> Some details in the screenshot above are from an outdated version.

Example usage of [🌟 `Surface`](https://github.com/Zabadam/surface) package for Flutter:
- [🌟 `Surface` Example Android source](https://github.com/Zabadam/surface/tree/main/example/lib/main.dart): `/example/lib/main.dart`
- [🌟 `Surface` Example APK](https://github.com/Zabadam/surface/tree/main/example/build/app/outputs/flutter-apk/app-release.apk)

# 🧫 Usage in Example
The landing view uses several 🌟 `Surface`s right off the bat.
- Background (under image)
- `AppBar`
- Main window
  - Try tapping and holding inside this container
- Floating Action Buttons
  - Three different `FAB`s show three different 📚 `SurfaceLayer` layouts for 👓 `Filter.filteredLayers`.

🏓 `BouncyBall` is delegated as the `InteractiveInkFeatureFactory` or `splashFactory`
  - Check out the `BallPit` demo from teh drawer for more!

🔦 `WithShading` extension on `Color` offers ⬛ `Color.withBlack` and ⬜ `Color.withWhite`.

🌟 `Surface` uses a few Theme-derived fallbacks if not specified `Color`s.

Tapping the action button in the `AppBar` will present a 🌟 `Surface` as a popup.

Swiping open the main `Drawer` or tapping the hamburger menu offers a button (that is, of course, a 🌟 `Surface`) leading to the next demo.
- `SurfacePalette` is a recreation of the Flutter Gallery presentation for Material Colors utilizing 🌟 `Surfaces`
  - Even the two new parameters offered in **🌟 `Surface` [0.1.0+5]** are employed for creative measures
    - 🆕 `Surface.baseRadius`
    - 🆕 `Filter.extendBaseFilter`


# 🌇 Roadmap
- This is my first public package and I expect things may still be altered greatly.

- Intrinsic animations of 📐 `Surface.corners` property change.
    - Currently there is a conditional swap in any build method utilizing shapes.
    - Ideally there would be a `Decoration.lerp()` involved.

- Differed radius on 📚 `SurfaceLayer.MATERIAL` vs 📚 `SurfaceLayer.BASE`
    - Smaller inner radius gives a better aesthetic for nested shapes.
    - 🆕 Manual setting of [`Surface.radius`](https://pub.dev/documentation/surface/latest/surface/Surface/radius.html) or [`Surface.baseRadius`](https://pub.dev/documentation/surface/latest/surface/Surface/baseRadius.html) available now.

- Proposed [SurfaceCornerSpec] for [Surface.corners] parameter or expansion of 🔰 [SurfaceShape] class that allows customization of all four corners independently.

##### [**🔗 SOURCE FOR BACKGROUND**](https://apod.nasa.gov/apod/image/2102/rosette_goldman_2500.jpg "Don Goldman via NASA APOD")
