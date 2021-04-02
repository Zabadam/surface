### WIP
# 'Surface' Flutter Package

![Animated GIF preview of Surface Example app](https://github.com/Zabadam/surface/blob/main/doc/Surface-Example.gif?raw=true)

[Surface](https://github.com/Zabadam/surface) is a shapeable, layered, intrinsincally animated container Widget offering convenient access to blurring ImageFilters, Material InkResponse, and HapticFeedback.

- Work in progress transfer from an [Android application](https://play.google.com/store/apps/details?id=com.zaba.bug_bash 'Bug Bash in the Play Store') on which I am primarily focused.
- Standard approaches and a bit of bespoke shape-crafting; more options should be available down the line.
- The package currently includes a couple goodies that I use in my project. I would like to incorporate these extra features more tightly with Surface.
    - Color extensions `Color.withBlack(int subtract)` and `Color.withWhite(int add)` may be handy at least.
    - A modified `SplashFactory` called [`CustomInk`](https://github.com/Zabadam/surface/tree/main/lib/src/custom_ink.dart) is present in goodies.dart as well.
- This is my first public package and I expect things may still be altered greatly.

## TODO:

- Intrinsic animations of [Surface.corners] property change.
    - Currently there is a conditional swap where any Surface build method utilizes the Beveled Shape to a RoundedRect Shape.
    - Ideally, I believe, there would be a `Decoration.lerp()` involved.
    - This "aggravates" the simplicity of [Surface] to develop, but would provide a better end-user result: more accurate and performant animations that are just as easy to use. (Almost effortless? 😉)

- Differed radius on [innerSurface] when using [SurfaceCorners.ROUND] vs [borderContainer]
    - Smaller inner radius gives a better aesthetic for nested rounded rectangles

### WIP
# [Surface Example](https://github.com/Zabadam/surface/tree/main/example)

See some example usage of the Surface package for Flutter included here.
- [Surface Example Android source](https://github.com/Zabadam/surface/tree/main/example/lib/main.dart): `/example/lib/main.dart`
- [Surface Example APK](https://github.com/Zabadam/surface/tree/main/example/build/app/outputs/flutter-apk/app-release.apk)
