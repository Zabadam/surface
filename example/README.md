# Surface Example

Example usage of the [Surface](https://github.com/Zabadam/surface) package for Flutter. See Example Android app: `/example/lib/main.dart`.

## TODO:

- Intrinsic animations of [Surface.corners] property change.
    - Currently there is a conditional swap where any Surface build method utilizes the Beveled Shape to a RoundedRect Shape.
    - Ideally, I believe, there would be a `Decoration.lerp()` involved.
    - This "aggravates" the simplicity of [Surface] to develop, but would provide a better end-user result: more accurate and performant animations that are just as easy to use. (Almost effortless? 😉)

- Differed radius on [innerSurface] when using [SurfaceCorners.ROUND] vs [borderContainer]
    - Smaller inner radius gives a better aesthetic for nested rounded rectangles