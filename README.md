# 'Surface' Flutter Package
### Null-Safety Support - as of v0.2.0+6

![Animated GIF preview of Surface Example app](https://github.com/Zabadam/surface/blob/main/doc/Surface-Example.gif?raw=true)
> (Some details in the screenshot above are from an outdated version.)


## 🌟 [Surface](https://github.com/Zabadam/surface)
is  shapeable, layered, intrinsincally animated container Widget
offering convenient access to blurring ImageFilters, Material InkResponse, and HapticFeedback.


## 📚 [SurfaceLayer] Container Division
Offers robust customization for a set app-wide style or on-the-fly changes.
- Support for both [Color]s and [Gradient]s in both 📚 [SurfaceLayer] `BASE` and `MATERIAL` layers.
- Support for three different blur filters and their strengths.
  - The top-most of which can blur any InkResponse that occurs on the middle 📚 [SurfaceLayer].
- EdgeInsets may be divided amongst different 📚 layers by 🔛 [Surface.padLayer].


## 🔘📐 Shape Customization
🔘 [Surface.radius] and 📐 [SurfaceCorners] parameter [Surface.corners] offer shape customization.
The 🔘 [baseRadius] may be specified separately, but is optional and will only impact the 📚 [SurfaceLayer.BASE].


## 🔲 [SurfacePeekSpec] for bespoke "peek" effect
`MATERIAL` inset or "border", the size of which is set by parameter 🔲 [SurfacePeekSpec.peek].
- Give special treatment, generally a thicker appearance, to selected
  side(s) by passing 🔲 [SurfacePeekSpec.peekAlignment]
  and tuning with 🔲 [SurfacePeekSpec.peekRatio].


## 🔬 [SurfaceFilterSpec] defines 💧 [Blur.ry] backdrop [ImageFilter]s
- In configured 👓 [SurfaceFilterSpec.filteredLayers] `Set`
  - Whose radii (blur strength) are mapped with 💧 [SurfaceFilterSpec.radiusMap]
- A 📚 [SurfaceLayer.BASE] filter may be extended through the [Surface.margin] with [SurfaceFilterSpec.extendBaseFilter]


## 👆 [SurfaceTapSpec] Controls Touch Feedback
- If the 🌟 [Surface] is 👆 [SurfaceTapSpec.tappable] then 👆 [SurfaceTapSpec.onTap] `VoidCallback` becomes available.
- Colors may be provided for [InkResponse] customization--though ThemeData defaults are accessed otherwise.
- Finally consider a [HapticFeedback] shortcut [SurfaceTapSpec.providesFeedback].


## 🔰 [SurfaceShape] Open to Grow
The class currently only responsible for the 📐 [SurfaceCorners.BEVEL] custom shape by 🔰 [SurfaceShape.biBeveledRectangle].


### References
- 🌟 [Surface] - A shapeable, layered, animated container Widget
- 🔲 [SurfacePeekSpec] - An Object with optional parameters to customize a 🌟 Surface's "peek"
- 👆 [SurfaceTapSpec] - An Object with optional parameters to customize a 🌟 Surface's tap behavior
- 🔬 [SurfaceFilterSpec] - An Object with optional parameters to customize a 🌟 Surface's blurring filters
#### 🎊 Just a few extra goodies for fun.
- 🏓 [CustomInk] - A delightfully bouncy and position-mirroring reaction to user input on a piece of [Material]
- 🔦 [WithShading] `Color` extension
   - ⬛ [withBlack] `.withBlack(int subtract)`
   - ⬜ [withWhite] `.withWhite(int add)`
- 🤚 [DragNub] A small, round "handle" indicator used to visualize impression of draggable material


## TODO:
- Work in progress transfer from an
  [Android application](https://play.google.com/store/apps/details?id=com.zaba.bug_bash 'Bug Bash in the Play Store')
  on which I am primarily focused.
  - Standard approaches and a bit of bespoke shape-crafting; more options should be available down the line.
  - The package currently includes a couple goodies that I use in my project.
    I would like to incorporate these extra features more tightly with Surface.
    - Color extensions `Color.withBlack(int subtract)` and `Color.withWhite(int add)` may be handy at least.
    - A modified `SplashFactory` called [`CustomInk`](https://github.com/Zabadam/surface/tree/main/lib/src/custom_ink.dart)
      is present in goodies.dart as well.
  - This is my first public package and I expect things may still be altered greatly.

- Intrinsic animations of [Surface.corners] property change.
    - Currently there is a conditional swap where any Surface build method utilizes the Beveled Shape to a RoundedRect Shape.
    - Ideally, I believe, there would be a `Decoration.lerp()` involved.
    - This "aggravates" the simplicity of [Surface] to develop, but would provide a better end-user result:
      more accurate and performant animations that are just as easy to use. (Almost effortless? 😉)

- Differed radius on [SurfaceLayer.MATERIAL] vs [SurfaceLayer.BASE]
    - Smaller inner radius gives a better aesthetic for nested shapes.
    - 🆕 Manual setting of [Surface.radius] or [Surface.baseRadius] available now.

- Proposed [SurfaceCornerSpec] for [Surface.corners] property that allows customization
  of all four corners independently.


# [Surface Example](https://github.com/Zabadam/surface/tree/main/example)

See some example usage of the Surface package for Flutter included here.
- [Surface Example Android source](https://github.com/Zabadam/surface/tree/main/example/lib/main.dart): `/example/lib/main.dart`
- [Animated GIF preview of Surface Example app](https://github.com/Zabadam/surface/blob/main/doc/Surface-Example.gif?raw=true)
- [Surface Example APK](https://github.com/Zabadam/surface/tree/main/example/build/app/outputs/flutter-apk/app-release.apk)
