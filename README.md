# 🌟 Surface
##### **WORK IN PROGRESS**
##### **NULL-SAFETY SUPPORT - as of v0.2.0**

![Animated GIF preview of Surface Example app](https://github.com/Zabadam/surface/blob/main/doc/Surface-Example.gif?raw=true)
> Some details in the screenshot above are from an outdated version.

A  shapeable, layered, intrinsincally animated container Widget
offering convenient access to blurring ImageFilters, Material InkResponse, and HapticFeedback.

&nbsp;

## 📚 `SurfaceLayer` Container Division
Offers robust customization for a set app-wide style or on-the-fly changes.
- Support for both `Color`s and `Gradient`s in both 📚 `SurfaceLayer` `BASE` and `MATERIAL` layers.
- Support for three different blur filters and their strengths.
  - The top-most of which can blur any InkResponse that occurs on the middle 📚 `SurfaceLayer`.
- EdgeInsets may be divided amongst different 📚 layers by 🔛 `Surface.padLayer`.

&nbsp;

## 🔘📐 Shape Customization
🔘 `Surface.radius` and 📐 `SurfaceCorners` parameter `Surface.corners` offer shape customization.
The 🔘 `baseRadius` may be specified separately, but is optional and will only impact the 📚 `SurfaceLayer.BASE`.

&nbsp;

## 🔲 `SurfacePeekSpec` for bespoke "peek" effect
`MATERIAL` inset or "border", the size of which is set by parameter 🔲 `SurfacePeekSpec.peek`.
- Give special treatment, generally a thicker appearance, to selected
  side(s) by passing `SurfacePeekSpec.peekAlignment`
  and tuning with `SurfacePeekSpec.peekRatio`.

&nbsp;

## 🔬 `SurfaceFilterSpec` defines 🤹‍♂️ `SurfaceFX` `ImageFilter`s
- In configured 👓 `SurfaceFilterSpec.filteredLayers` `Set`
  - Whose radii (blur strength) are mapped with 📊 `SurfaceFilterSpec.radiusMap`
- A 📚 `SurfaceLayer.BASE` filter may be extended through the `Surface.margin` with `SurfaceFilterSpec.extendBaseFilter`.

&nbsp;

## 👆 `SurfaceTapSpec` Controls Touch Feedback
- If the 🌟 `Surface` is 👆 `SurfaceTapSpec.tappable` then 👆 `SurfaceTapSpec.onTap` `VoidCallback` becomes available.
- Colors may be provided for `InkResponse` customization--though ThemeData defaults are accessed otherwise.
- Finally consider a `HapticFeedback` shortcut `SurfaceTapSpec.providesFeedback`.

&nbsp;

## 🔰 `SurfaceShape` Open to Grow
The class currently only responsible for the 📐 `SurfaceCorners.BEVEL` custom shape by 🔰 `SurfaceShape.biBeveledRectangle`.

&nbsp;

## 🤹‍♂️ Surface `FX` Open to Grow
The class currently only responsible for 💧 `FX.blurry` static method returning `ImageFilter`.

&nbsp;

# 📖 Reference
- 🌟 [`Surface`] - A shapeable, layered, animated container `Widget`
- 🔲 [`PeekSpec`] - An Object with optional parameters to customize a 🌟 `Surface`'s "peek"
- 👆 [`TapSpec`] - An Object with optional parameters to customize a 🌟 `Surface`'s tap behavior
- 🔬 [`FilterSpec`] - An Object with optional parameters to customize a 🌟 `Surface`'s 🤹‍♂️ filters/effects
- 🔰 [`SurfaceShape`] - Handles the "biBevel" shape for 🌟 `Surface`, but could do more
- 🤹‍♂️ [`SurfaceFX`] - `Function typedef` for custom [FilterSpec.effect]s!

### 🏓 [BouncyBall]
A delightfully bouncy and position-mirroring reaction to user input on a piece of [Material].

Turn ink splashes for an [InkWell], [InkResponse] or material [Theme] into 🏓 [BouncyBall]s or 🔮 `Glass` [BouncyBall]s with the built-in [InteractiveInkFeatureFactory]s, or design your own with 🪀 [BouncyBall.mold].

#### 🎊 Just a few extra goodies for fun.
- 🔦 [`WithShading`] `Color` extension
   - ⬛ [`withBlack`] `.withBlack(int subtract)`
   - ⬜ [`withWhite`] `.withWhite(int add)`
- 🤚 [`DragNub`] A small, round "handle" indicator used to visualize impression of draggable material


# 🌇 Roadmap
- This is my first public package and I expect things may still be altered greatly.

- Intrinsic animations of 📐 `Surface.corners` property change.
    - Currently there is a conditional swap in any build method utilizing shapes.
    - Ideally there would be a `Decoration.lerp()` involved.

- Differed radius on 📚 `SurfaceLayer.MATERIAL` vs 📚 `SurfaceLayer.BASE`
    - Smaller inner radius gives a better aesthetic for nested shapes.
    - 🆕 Manual setting of [`Surface.radius`](https://pub.dev/documentation/surface/latest/surface/Surface/radius.html) or [`Surface.baseRadius`](https://pub.dev/documentation/surface/latest/surface/Surface/baseRadius.html) available now.

- Proposed [SurfaceCornerSpec] for [Surface.corners] parameter or expansion of 🔰 [SurfaceShape] class that allows customization of all four corners independently.


# 🌟 [Surface Example](https://github.com/Zabadam/surface/tree/main/example)
See example usage of the 🌟 `Surface` package for Flutter:
- [Surface Example Android source](https://github.com/Zabadam/surface/tree/main/example/lib/main.dart): `/example/lib/main.dart`
- [Animated GIF preview of Surface Example app](https://github.com/Zabadam/surface/blob/main/doc/Surface-Example.gif?raw=true)
- [Surface Example APK](https://github.com/Zabadam/surface/tree/main/example/build/app/outputs/flutter-apk/app-release.apk)

##### [**🔗 SOURCE FOR BACKGROUND**](https://apod.nasa.gov/apod/image/2102/rosette_goldman_2500.jpg "Don Goldman via NASA APOD")
