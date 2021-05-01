# 🌟 Surface
#### **WORK IN PROGRESS**
##### **Overhaul ongoing. Documentation & Readme may be out of date.**

A  shapeable, layered, intrinsincally animated container widget offering convenient
access to blurring `ImageFilter`s, `Material` `InkResponse`, and `HapticFeedback`.

## + [🏓 `BouncyBall`](https://pub.dev/packages/ball 'pub.dev: ball')
A delightfully bouncy and position-mirroring reaction to user input on a piece of `Material`.

![Animated GIF preview of Surface Example app](https://github.com/Zabadam/surface/blob/main/doc/Surface-Example.gif?raw=true)
> Details in the screenshot above are from an outdated version.

&nbsp;

## 📚 `SurfaceLayer` Container Division
Offers robust customization for a set app-wide style or on-the-fly changes.
- Support for `Color`s and `Gradient`s in both 📚 [`SurfaceLayer`](https://pub.dev/documentation/surface/latest/surface/SurfaceLayer-class.html)s `BASE` and `MATERIAL` layers.
- Support for three different [filters](https://pub.dev/documentation/surface/latest/surface/Filter-class.html) and their strengths.
  - The top-most of which will affect any `InkResponse` that occurs on the middle 📚 `SurfaceLayer`
- Insets may be divided amongst different 📚 `Layer`s by 🔛 [`Shape.padLayer`](https://pub.dev/documentation/surface/latest/surface/Shape/padLayer.html).

&nbsp;

## 🔰 `Shape` Customized `SurfaceShape`s
  - 🆕 Manual [`Shape`](https://pub.dev/documentation/surface/latest/surface/Shape-class.html)ing is here! Work in progress.
  - Defined by 📐 [`CornerSpec`](https://pub.dev/documentation/surface/latest/surface/CornerSpec-class.html) and generates a [`SurfaceShape`](https://pub.dev/documentation/surface/latest/surface/SurfaceShape-class.html).
  - Optionally, provide a ➖ [`border`](https://pub.dev/documentation/surface/latest/surface/Shape/border.html) or 📏 [`scaling`](https://pub.dev/documentation/surface/latest/surface/Shape/shapeScaleChild.html).

&nbsp;

## 🔲 `Peek`
📚 `MATERIAL` inset or "border", the size of which is set by parameter 🔲 [`Peek.peek`](https://pub.dev/documentation/surface/latest/surface/Peek/peek.html).
- Give special treatment, generally a thicker appearance, to selected
  side(s) by passing [`Peek.alignment`](https://pub.dev/documentation/surface/latest/surface/Peek/alignment.html)
  and tuning with [`Peek.ratio`](https://pub.dev/documentation/surface/latest/surface/Peek/ratio.html).

&nbsp;

## 👆 `TapSpec`
If the 🌟 `Surface` is [`TapSpec.tappable`](https://pub.dev/documentation/surface/latest/surface/TapSpec/tappable.html) then:
- 👆 `TapSpec.onTap` callback becomes available.
- Colors may be provided for `InkResponse` customization--though `ThemeData` defaults are accessed otherwise.
- Consider a `HapticFeedback` shortcut 👆 `TapSpec.providesFeedback`.
- Enjoy the [🏓 `BouncyBall` `splashFactory`](https://pub.dev/packages/ball), pick [your own](https://pub.dev/documentation/surface/latest/surface/TapSpec/splashFactory.html), or have 🌟 `Surface` [default to your `Theme`'s](https://pub.dev/documentation/surface/latest/surface/TapSpec/useThemeSplashFactory.html).

&nbsp;

## 🔬 `Filter` defines 🤹‍♂️ `SurfaceFX` `ImageFilter`s
- In configured [👓 `Filter.filteredLayers`](https://pub.dev/documentation/surface/latest/surface/Filter/filteredLayers.html) `Set`
  - Whose radii (strength) are mapped with [📊 `Filter.radiusMap`](https://pub.dev/documentation/surface/latest/surface/Filter/radiusMap.html)
- A 📚 `SurfaceLayer.BASE` filter may be extended through the [`Surface.margin`](https://pub.dev/documentation/surface/latest/surface/Surface/margin.html) with [`Filter.extendBaseFilter`](https://pub.dev/documentation/surface/latest/surface/Filter/extendBaseFilter.html).
- 🤹‍♂️ [`SurfaceFX typedef`](https://pub.dev/documentation/surface/latest/surface/SurfaceFX.html) for passing along your own [`FilterSpec.effect`](https://pub.dev/documentation/surface/latest/surface/Filter/effect.html)s based on 📚 `SurfaceLayer` and the current `Layer`'s `radius`.
  - Default effect is a nice [gaussian blur](https://pub.dev/documentation/surface/latest/surface/FX/b.html) (though a `new 🌟 Surface` has no active effects).


&nbsp;

## 🤹‍♂️ `FX` Open to Grow
Currently only responsible for [💧 `FX.blurry`](https://pub.dev/documentation/surface/latest/surface/FX/blurry.html), the default `ImageFilter` for [🔬 `Filter`](https://pub.dev/documentation/surface/latest/surface/Filter-class.html).

&nbsp;

# 📖 Reference
[🌟 `Surface`](https://pub.dev/documentation/surface/latest/surface/Surface-class.html) - A shapeable, layered, animated container `Widget`

[🔰 `Shape`](https://pub.dev/documentation/surface/latest/surface/Shape-class.html)
- Defined by [📐 `CornerSpec`](https://pub.dev/documentation/surface/latest/surface/CornerSpec-class.html) and generates a [`SurfaceShape`](https://pub.dev/documentation/surface/latest/surface/SurfaceShape-class.html)

[🔲 `Peek`](https://pub.dev/documentation/surface/latest/surface/Peek-class.html) - An Object with optional parameters to customize a 🌟 `Surface`'s "peek"

[👆 `TapSpec`](https://pub.dev/documentation/surface/latest/surface/TapSpec-class.html) - An Object with optional parameters to customize a 🌟 `Surface`'s tap behavior

[🔬 `Filter`](https://pub.dev/documentation/surface/latest/surface/Filter-class.html) - An Object with optional parameters to customize a 🌟 `Surface`'s 🤹‍♂️ filters/effects
-  [`🤹‍♂️ SurfaceFX typedef`](https://pub.dev/documentation/surface/latest/surface/SurfaceFX.html) for custom [`FilterSpec.effect`](https://pub.dev/documentation/surface/latest/surface/Filter/effect.html)s!

### [🏓 `BouncyBall`](https://pub.dev/documentation/ball/latest/ball/BouncyBall-class.html)
A delightfully bouncy and position-mirroring reaction to user input on a piece of `Material`.

Turn ink splashes for an `InkWell`, `InkResponse` or material `Theme` into [🏓 `BouncyBall`s](https://pub.dev/documentation/ball/latest/ball/BouncyBall/splashFactory-constant.html) or [🔮 "glass" `BouncyBall`](https://pub.dev/documentation/ball/latest/ball/BouncyBall/marbleFactory-constant.html 'BouncyBall.marbleFactory')s with the built-in [`InteractiveInkFeatureFactory`s](https://api.flutter.dev/flutter/material/InteractiveInkFeatureFactory-class.html 'Flutter API: InteractiveInkFeatureFactory'), or design your own with custom [`rubber Paint`](https://pub.dev/documentation/ball/latest/ball/BouncyBall/mold.html 'BouncyBall.mold(Paint rubber)') using [🪀 `BouncyBall.mold`](https://pub.dev/documentation/ball/latest/ball/BouncyBall/mold.html 'BouncyBall.mold').

#### 🎊 Just a few extra goodies for fun.
- 🔦 [`WithShading`] `Color` extension
   - ⬛ [`withBlack`] `.withBlack(int subtract)`
   - ⬜ [`withWhite`] `.withWhite(int add)`
- 🤚 [`DragNub`] A small, round "handle" indicator used to visualize impression of draggable material

&nbsp;

# 🌇 Roadmap
This is my first public package and I expect things may still be altered greatly.
- Speaking of which, an overhaul is currently ongoing as of **[0.4.0]**.  I am *still* new to Dart and improving my programming. Feel absolutely free to suggest improvements or make PRs.
- Since releasing `Surface`, I have found many more advanced and powerful packages. Still `Surface` progress marches onward as I plan to continue development as I learn.
- For example, I have already earned experience in deprecating features and "bad pushes"!

🔳 Animations of 📐 `Surface.shape` change.

✅ ~~Differed radius on 📚 `SurfaceLayer.MATERIAL` vs 📚 `SurfaceLayer.BASE`~~
  - ~~Smaller inner radius gives a better aesthetic for nested shapes.~~
  - ~~🆕 Manual setting of [`Surface.radius`](https://pub.dev/documentation/surface/latest/surface/Surface/radius.html) or [`Surface.baseRadius`](https://pub.dev/documentation/surface/latest/surface/Surface/baseRadius.html) available now.~~
  - 🆕 Manual [`Shape`](https://pub.dev/documentation/surface/latest/surface/Shape-class.html)ing is here! Work in progress.

✅ ~~Proposed [SurfaceCornerSpec] for [Surface.corners] parameter or expansion of 🔰 [SurfaceShape] class that allows customization of all four corners independently.~~
  - 🆕 Manual [`Shape`](https://pub.dev/documentation/surface/latest/surface/Shape-class.html)ing is here! Work in progress.

&nbsp;

# 🌟 [Surface Example](https://github.com/Zabadam/surface/tree/main/example)
See example usage of the 🌟 `Surface` package for Flutter:
- [Surface Example Android source](https://github.com/Zabadam/surface/tree/main/example/lib/main.dart): `/example/lib/main.dart`
- [Animated GIF preview of Surface Example app](https://github.com/Zabadam/surface/blob/main/doc/Surface-Example.gif?raw=true)
- [Surface Example APK](https://github.com/Zabadam/surface/tree/main/example/build/app/outputs/flutter-apk/app-release.apk)

&nbsp;

##### [**🔗 SOURCE FOR BACKGROUND**](https://apod.nasa.gov/apod/image/2102/rosette_goldman_2500.jpg "Don Goldman via NASA APOD")
