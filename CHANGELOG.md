# 🌟 Surface
## **[0.5.0]** - 01 MAR 21
- In lieu of reinventing the wheel on shaping, I'm looking to make
  flavored usage of [`AnimatedStyledWidget`](https://pub.dev/packages/animated_styled_widget).

## Legacy
### **[0.4.3]** - 30 APR 21
- Beginning doc/readme cleanup for new `Shape`ing and naming schemes
- Investigating performance degradation.
- 🆕 props for 👆 `TapSpec`
  - ❓ `useThemeSplashFactory`
  - Custom `splashFactory`
    - `Surface` falls back to 🏓 `BouncyBall`
- Renamed 🔲 `Peek.peekAlignment` -> `Peek.alignment` & `Peek.peekRatio` -> `Peek.ratio`
- Renamed 🔬 `Filter.baseRadius`, et al. -> `Filter.radiusBase`, et al. & made all forms of `radius` input _private with public getters
- A `radius`, or `Corner` `BorderRadius`, may be specified in `Shape` as well as individual `CornerSpec`
  - `CornerSpec.radius` will win if available

### **[0.4.2]** - 30 APR 21
- Fixing `null` checks, especially by `lerp`s.

### **[0.4.1]** - 29 APR 21
- Imports correction.

### **[0.4.0]** - 29 APR 21
- Overhaul in progress. Developing...
- ✅ Newly added:
  - Manual (or pre-configured) custom [`Shape`](https://pub.dev/documentation/surface/latest/surface/Shape-class.html)ing
    - Easy `Shape` scaling and differed `Shape` by 📚 `SurfaceLayer`
    - Customize `Shape` by configuring four `Corner`s and `radius`
  - `BorderSide` support, by 📚 `SurfaceLayer`
  - 📋 `copyWith` methods
  - Renamed classes: `FilterSpec` -> `Filter`, `PeekSpec` -> `Peek`
  - & more
- 🔳 Todo:
  - Improve transitioning/animating/lerping
  - & more

### **[0.3.0]** - 25 APR 21
- Divided package into several bite-size `src` files
- Reverted names of `Spec` classes to drop preceding `'Surface'`
- `CustomInk` -> `BouncyBall`, forked as [🏓 `package:ball`](https://pub.dev/packages/ball), with LOTS of 🆕 features!
  - New `const splashFactory`s: 🏓 `BouncyBall.splashFactory2`, `3,` & `4` with different bounce animations
  - 🔮 `BouncyBall.marbleFactory` which uses different `Paint` and one of the new curves
  - `InteractiveInkFeatureFactory` designer method, 🪀 `BouncyBall.mold(Paint rubber)`
- `Blur.ry` -> 💧 `FX.blurry` and becomes default for 🆕 `FilterSpec.effect` parameter
  - 🤹‍♂️ `FX` class linked to 🤹‍♂️ `SurfaceFX typedef`
  - 💧 `FX.blurry` is the default 🤹‍♂️ `SurfaceFX Function` that ignores the current 📚 `SurfaceLayer layerForRender` and opts to handle only the 📊 `specRadius` which comes from 🔬 `FilterSpec` according to 📚 `layerForRender`
    - Passes 📊 `specRadius` to 💧 `FX.b` (the true old `Blur.ry`)
- Core of 🌟 `Surface` cleaned up, with with is hopefully now ***zero*** changes to Widget tree depth by altering parameters like removing filters & disabling ink response and handling `Clip`s differently
  -  Still need to work on 🔰 `SurfaceShape` and `Decoration lerp`ing

### **[0.2.0]** & **[0.2.0+7]** - 12 APR 21
- Migrated package to sound null safety.
- Cleaned up internal `Filter` code a bit while adding relevant `constants`
  - One `DEFAULT_SPEC` is used by a `new` 🌟 `Surface`
  - And several more that are `const` options for 👓 `filteredLayers`:
    - `Set<SurfaceLayer>` that resemble old `enum SurfaceFilter`
- 🔰 `BiBeveledShape.build` becomes 🔰 [`SurfaceShape.biBeveledRectangle`](https://pub.dev/documentation/surface/latest/surface/SurfaceShape/biBeveledRectangle.html) for growth potential
- Removed `fullPrint` and `scaleAxis`.

### **[0.1.0]** - 04 APR 21
- Added [`Surface.baseRadius`](https://pub.dev/documentation/surface/latest/surface/Surface/baseRadius.html).
  - 🔘 [`baseRadius`](https://pub.dev/documentation/surface/latest/surface/Surface/baseRadius.html) may be specified separately from 🔘 [`radius`](https://pub.dev/documentation/surface/latest/surface/Surface/radius.html), but is optional and will only impact the 📚 `SurfaceLayer.BASE`.
  - If not provided, uses 🔘 [`Surface.radius`](https://pub.dev/documentation/surface/latest/surface/Surface/radius.html), which itself defaults to 🔘 `Surface._RADIUS == 3.0`.
- Added `Filter.extendBaseFilter` boolean which will apply the 📚 `BASE` blurry filter to the `Surface.margin`.

## **[0.0.5]** - 02 APR 21
- Further modification to initialization parameters for Surface constructor.
- Filter strength and the `SurfaceLayer`s on which they are enabled are now set and mapped with a bespoke `Filter` Object.
  - Enable blurry filters by passing the desired `SurfaceLayer`s into `Filter.filteredLayers` as a `Set`.
  - Strength radii can be initialized formally or with a `Map<SurfaceLayer, double>` called `Filter.radiusMap`.
  - `SurfaceFilter` enum removed, as it redundantly represented the idea of `SurfaceLayer`s in a `Set`

### **[0.0.4]** - 01 APR 21
- Reduction in initialization parameters for Surface constructor. This is achieved:
  - in one instance by joining three similar values in a Map (`filterRadius`)
  - by introducing `Peek` and `TapSpec` classes to encapsulate other related parameters
- Renamed `SurfaceLayer.BASE` from BORDER.
  - Changed or removed any references to "border"
  - Now refer to "base inset" or `peek`.
    - Consider the old `Surface.borderRatio` is the new `Peek.ratio`.
- Altered default `Color` handling.
  - `InkResponse` splashes and highlights now defer to `Theme`.
  - Without passing a `Surface.color`, deafult to `ColorScheme.surface`
  - Without passing a `Surface.baseColor`, deafult to `ColorScheme.primaryVariant`
- Organized documentation. Added iconography through emoji.

### **[0.0.3]** - 23 FEB 21
- Improving layout and comments for pub.dev listing
- Touchup on [example application](https://github.com/Zabadam/surface/tree/main/example)

### **[0.0.2]** - 22 FEB 21
- Prepared for pub.dev
    - Updated comments and documentation; fixed M⬇; ran `dartdoc`.
    - Cleaned and linked READMEs; added hyperlinks to Surface Example.
- Removed Color and Duration constants from goodies.
- Goodie `scaleAxis` simplified

### **[0.0.1]** - 22 FEB 21
- Work in progress transfer from an [Android application](https://play.google.com/store/apps/details?id=com.zaba.bug_bash 'Bug Bash in the Play Store') on which I am primarily focused.
