### WIP
# Surface Example

![Animated GIF preview of Surface Example app](https://github.com/Zabadam/surface/blob/main/doc/Surface-Example.gif?raw-true)

Example usage of the [Surface](https://github.com/Zabadam/surface) package for Flutter.
- [Surface Example Android source](https://github.com/Zabadam/surface/tree/main/example/lib/main.dart): `/example/lib/main.dart`
- [Surface Example APK](https://github.com/Zabadam/surface/tree/main/example/build/app/outputs/flutter-apk/app-release.apk)

## TODO:

- Intrinsic animations of `Surface.corners` property change.
    - Currently there is a conditional swap where any Surface build method utilizes the Beveled Shape to a RoundedRect Shape.
    - Ideally, I believe, there would be a `Decoration.lerp()` involved.
    - This "aggravates" the simplicity of `Surface` to develop, but would provide a better end-user result: more accurate and performant animations that are just as easy to use. (Almost effortless? 😉)

- Differed radius on `innerSurface` when using `SurfaceCorners.ROUND` vs `borderContainer`
    - Differed inner radius gives a better aesthetic for nested rounded rectangles

[Source for background image](https://apod.nasa.gov/apod/image/2102/rosette_goldman_2500.jpg "Don Goldman via NASA APOD")
