# 'Surface' Flutter Package

![Animated GIF preview of Surface Example app](https://github.com/Zabadam/surface/blob/main/doc/Surface-Example.gif?raw=true)

🌟 [Surface](https://github.com/Zabadam/surface) is  shapeable, layered, intrinsincally animated container Widget offering convenient access to blurring ImageFilters, Material InkResponse, and HapticFeedback.

📚 [SurfaceLayer] container layering offers robust customization.
  - Support for both [Color]s and [Gradient]s
    in both 📚 [SurfaceLayer] `BASE` and `MATERIAL` layers.

Use 🔘 [Surface.radius] and 📐 [SurfaceCorners] parameter [Surface.corners]
to configure the shape.

A 👆 [SurfaceTapSpec] offers [InkResponse] customization and [HapticFeedback] shortcut.

A 🔲 [SurfacePeekSpec] may be provided to alter the Surface "peek" (`MATERIAL` inset or "border") with parameter 🔲 [SurfacePeekSpec.peek].
  - Give special treatment, generally a thicker appearance, to selected
    side(s) by passing 🔲 [PeekSpec.peekAlignment] and tuning with 🔲 [SurfacePeekSpec.peekRatio].

Specify a 🔬 [SurfaceFilterSpec] with options to render 💧 [Blur.ry] backdrop [ImageFilter]s in a configured 👓 [SurfaceFilterSpec.filteredLayers] `Set` and whose strength is mapped with 💧 [SurfaceFilterSpec.radiusMap].

🔰 [BiBeveledShape] is responsible for the 📐 [SurfaceCorners.BEVEL] custom shape.

### References
- 🌟 [Surface] - A shapeable, layered, animated container Widget
- 🔲 [SurfacePeekSpec] - An Object with optional parameters to customize a Surface's "peek"
- 👆 [SurfaceTapSpec] - An Object with optional parameters to customize a Surface's tap behavior
- 🔬 [SurfaceFilterSpec] - An Object with optional parameters to customize a Surface's blurring filters
- 🏓 [CustomInk] - A delightfully bouncy and position-mirroring reaction to user input on a piece of [Material].
- 🔦 [WithShading] `Color` extension
   - ⬛ [withBlack] `.withBlack(int subtract)`
   - ⬜ [withWhite] `.withWhite(int add)`
- 🤚 [DragNub] A small, round "handle" indicator used to visualize impression of draggable material
- 👨‍💻 [fullPrint] - To receive really long `String`s in console log
- 📏 [scaleAxis] - For a [Transform.scale]-like return that accepts independent `dx` and `dy` scaling

## TODO:

- Work in progress transfer from an [Android application](https://play.google.com/store/apps/details?id=com.zaba.bug_bash 'Bug Bash in the Play Store') on which I am primarily focused.
  - Standard approaches and a bit of bespoke shape-crafting; more options should be available down the line.
  - The package currently includes a couple goodies that I use in my project. I would like to incorporate these extra features more tightly with Surface.
    - Color extensions `Color.withBlack(int subtract)` and `Color.withWhite(int add)` may be handy at least.
    - A modified `SplashFactory` called [`CustomInk`](https://github.com/Zabadam/surface/tree/main/lib/src/custom_ink.dart) is present in goodies.dart as well.
  - This is my first public package and I expect things may still be altered greatly.

- Intrinsic animations of [Surface.corners] property change.
    - Currently there is a conditional swap where any Surface build method utilizes the Beveled Shape to a RoundedRect Shape.
    - Ideally, I believe, there would be a `Decoration.lerp()` involved.
    - This "aggravates" the simplicity of [Surface] to develop, but would provide a better end-user result: more accurate and performant animations that are just as easy to use. (Almost effortless? 😉)

- Differed radius on [SurfaceLayer.MATERIAL] vs [SurfaceLayer.BASE]
    - Smaller inner radius gives a better aesthetic for nested shapes

# [Surface Example](https://github.com/Zabadam/surface/tree/main/example)

See some example usage of the Surface package for Flutter included here.
- [Surface Example Android source](https://github.com/Zabadam/surface/tree/main/example/lib/main.dart): `/example/lib/main.dart`
- [Animated GIF preview of Surface Example app](https://github.com/Zabadam/surface/blob/main/doc/Surface-Example.gif?raw=true)
- [Surface Example APK](https://github.com/Zabadam/surface/tree/main/example/build/app/outputs/flutter-apk/app-release.apk)
