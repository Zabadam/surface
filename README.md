# 🌟 Surface
#### **WORK IN PROGRESS**
##### **Overhaul ongoing. Documentation & Readme may be out of date.**

A shapeable, layered, intrinsincally animated container widget offering convenient
access to blurring `ImageFilter`s, `Material` `InkResponse`, and `HapticFeedback`.

## + [🏓 `BouncyBall`](https://pub.dev/packages/ball 'pub.dev: ball')
A delightfully bouncy and position-mirroring reaction to user input on a piece of `Material`.

![Animated GIF preview of Surface Example app](https://github.com/Zabadam/surface/blob/main/doc/Surface-Example.gif?raw=true)
> Details in the screenshot above are from an outdated version.

&nbsp;

## 📚 `SurfaceLayer` Division

## 🔰 `Shape`

## 🎨 `Appearance`

## 🔲 `Foundation`

## 👆 `Tactility`

## 🔬 `Filter` & 🤹‍♂️ `SurfaceFX`

&nbsp;

# 📖 Reference
🌟 [`Surface`](https://pub.dev/documentation/surface/latest/surface/Surface-class.html) -
A shapeable, layered, animated container `Widget`

🔰 [`Shape`](https://pub.dev/documentation/surface/latest/surface/Shape-class.html)
- Defined by 📐 [`Corners`](https://pub.dev/documentation/surface/latest/surface/Corners-class.html),
  ➖ [`Stroke`](https://pub.dev/documentation/surface/latest/surface/Stroke-class.html), and
  🔘 [`CornerRadius`](https://pub.dev/documentation/surface/latest/surface/CornerRadius-class.html)
- Generates a morphable `ShapeBorder`

🎨 [`Appearance`](https://pub.dev/documentation/surface/latest/surface/Appearance-class.html) -
An Object with optional parameters to customize a 🌟 `Surface`'s size, color, insets, and more.

🔲 [`Foundation`](https://pub.dev/documentation/surface/latest/surface/Foundation-class.html) -
An Object with optional parameters to customize a 🌟 `Surface`'s "foundation"

👆 [`Tactility`](https://pub.dev/documentation/surface/latest/surface/Tactility-class.html) -
An Object with optional parameters to customize a 🌟 `Surface`'s tactility/touch

🔬 [`Filter`](https://pub.dev/documentation/surface/latest/surface/Filter-class.html) -
An Object with optional parameters to customize a 🌟 `Surface`'s 🤹‍♂️ filters/effects
- 🤹‍♂️ [`SurfaceFX typedef`](https://pub.dev/documentation/surface/latest/surface/SurfaceFX.html) for custom [`FilterSpec.effect`](https://pub.dev/documentation/surface/latest/surface/Filter/effect.html)s!

### [🏓 `BouncyBall`](https://pub.dev/documentation/ball/latest/ball/BouncyBall-class.html)
[package:ball](https://pub.dev/packages/ball)

A delightfully bouncy and position-mirroring reaction to user input on a piece of `Material`.

Turn ink splashes for an `InkWell`, `InkResponse` or material `Theme` into
[🏓 `BouncyBall`s](https://pub.dev/documentation/ball/latest/ball/BouncyBall/splashFactory-constant.html)
or [🔮 "glass" `BouncyBall`](https://pub.dev/documentation/ball/latest/ball/BouncyBall/marbleFactory-constant.html 'BouncyBall.marbleFactory')s
with the built-in [`InteractiveInkFeatureFactory`s](https://api.flutter.dev/flutter/material/InteractiveInkFeatureFactory-class.html 'Flutter API: InteractiveInkFeatureFactory'),
or design your own with custom [`rubber Paint`](https://pub.dev/documentation/ball/latest/ball/BouncyBall/mold.html 'BouncyBall.mold(Paint rubber)')
using [🪀 `BouncyBall.mold`](https://pub.dev/documentation/ball/latest/ball/BouncyBall/mold.html 'BouncyBall.mold').

#### 🎊 Just a few extra goodies for fun.
- 🔦 [`WithShading`] `Color` extension
   - ⬛ [`withBlack`] `.withBlack(int subtract)`
   - ⬜ [`withWhite`] `.withWhite(int add)`
- 🤚 [`DragNub`] A small, round "handle" indicator used to visualize impression of draggable material

&nbsp;

# 🌇 Roadmap

&nbsp;

# 🌟 [Surface Example](https://github.com/Zabadam/surface/tree/main/example)
See example usage of the 🌟 `Surface` package for Flutter:
- [Surface Example Android source](https://github.com/Zabadam/surface/tree/main/example/lib/main.dart): `/example/lib/main.dart`
- [Animated GIF preview of Surface Example app](https://github.com/Zabadam/surface/blob/main/doc/Surface-Example.gif?raw=true)
- [Surface Example APK](https://github.com/Zabadam/surface/tree/main/example/build/app/outputs/flutter-apk/app-release.apk)

&nbsp;

##### [**🔗 SOURCE FOR BACKGROUND**](https://apod.nasa.gov/apod/image/2102/rosette_goldman_2500.jpg "Don Goldman via NASA APOD")

<br />

---

## 🐸 [Zaba.app ― simple packages, simple names.](https://pub.dev/publishers/zaba.app/packages 'Other Flutter packages published by Zaba.app')

<details>
<summary>More by Zaba</summary>

### Widgets to wrap other widgets
- ## 🕹️ [xl](https://pub.dev/packages/xl 'implement accelerometer-fueled interactions with a layering paradigm')
- ## 🌈 [foil](https://pub.dev/packages/foil 'implement accelerometer-reactive gradients in a cinch')
- ## 📜 [curtains](https://pub.dev/packages/curtains 'provide animated shadow decorations for a scrollable to allude to unrevealed content')
---
### Container widget that wraps many functionalities
- ## 🌟 [surface](https://pub.dev/packages/surface 'animated, morphing container with specs for Shape, Appearance, Filter, Tactility')
---
### Non-square `IconToo` + ext. `IconUtils` on `Icon`
- ## 🙋‍♂️ [icon](https://pub.dev/packages/icon 'An extended Icon \"too\" for those that are not actually square, plus shadows support + IconUtils')
---
### Side-kick companions, work great alone & employed above
- ## 🏓 [ball](https://pub.dev/packages/ball 'a bouncy, position-mirroring splash factory that\'s totally customizable')
- ## 👥 [shadows](https://pub.dev/packages/shadows 'convert a double-based \`elevation\` + BoxShadow and List\<BoxShadow\> extensions')
</details>
