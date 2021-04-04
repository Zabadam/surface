## [0.1.0+5] - 04 APR 21

* Added [Surface.baseRadius].
  * 🔘 [baseRadius] may be specified separately from [radius], but is optional and will only impact the 📚 [SurfaceLayer.BASE].
  * If not provided, uses [Surface.radius], which itself defaults to [Surface._RADIUS] `== 3.0`.
* Added [SurfaceFilterSpec.extendBaseFilter] boolean which will apply the 📚 `BASE` blurry filter to the [Surface.margin].

## [0.0.5+4] - 02 APR 21

* Further modification to initialization parameters for Surface constructor.
* Filter strength and the [SurfaceLayer]s on which they are enabled are now set and mapped with a bespoke [SurfaceFilterSpec] Object.
  * Enable blurry filters by passing the desired [SurfaceLayer]s into [SurfaceFilterSpec.filteredLayers] as a `Set`.
  * Strength radii can be initialized formally or with a `Map<SurfaceLayer, double>` called [SurfaceFilterSpec.radiusMap].
  * [SurfaceFilter] enum removed, as it redundantly represented the idea of [SurfaceLayer]s in a `Set`

## [0.0.4+3] - 01 APR 21

* Reduction in initialization parameters for Surface constructor. This is achieved:
  * in one instance by joining three similar values in a Map (`filterRadius`)
  * by introducing [SurfacePeekSpec] and [SurfaceTapSpec] classes to encapsulate other related parameters
* Renamed `SurfaceLayer.BASE` from BORDER.
  * Changed or removed any references to "border"
  * Now refer to "base inset" or `peek`.
    * Consider the old `Surface.borderRatio` is the new `SurfacePeekSpec.peekRatio`.
* Altered default `Color` handling.
  * `InkResponse` splashes and highlights now defer to `Theme`.
  * Without passing a `Surface.color`, deafult to `ColorScheme.surface`
  * Without passing a `Surface.baseColor`, deafult to `ColorScheme.primaryVariant`
* Organized documentation. Added iconography through emoji.

## [0.0.3+2] - 23 FEB 21

* Improving layout and comments for pub.dev listing
* Touchup on [example application](https://github.com/Zabadam/surface/tree/main/example)

## [0.0.2+1] - 22 FEB 21

* Prepared for pub.dev
    * Updated comments and documentation; fixed M⬇; ran `dartdoc`.
    * Cleaned and linked READMEs; added hyperlinks to Surface Example.
* Removed Color and Duration constants from goodies.
* Goodie `scaleAxis` simplified

## [0.0.1+0] - 22 FEB 21

* Work in progress transfer from an [Android application](https://play.google.com/store/apps/details?id=com.zaba.bug_bash 'Bug Bash in the Play Store') on which I am primarily focused.
