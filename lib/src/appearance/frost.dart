/// ## 🌟 Surface Library:
/// ### 🧊 `Frost`
library surface;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';

import 'package:img/img.dart';

const _this = 'surface';
const _dir = 'res/frost/';
const _p = '.png';
const _g = '.gif';

/// Map from [Tex] to [ExactAssetImage] for
/// [`package:surface`](https://pub.dev/packages/surface).
///
/// These textures and their corresponding images represent different styles of
/// frosted glass. Used with `texture` property for a [Frost] within `Glass`.
const kFrostTextures = <Tex, ExactAssetImage>{
  Tex.chisled: ExactAssetImage('${_dir}chisel$_p', package: _this),
  Tex.crystal: ExactAssetImage('${_dir}crystal$_p', package: _this),
  Tex.crystalGlitter: ExactAssetImage('${_dir}gif/crystal$_g', package: _this),
  Tex.crystalGlitterFast:
      ExactAssetImage('${_dir}gif/crystal_fast$_g', package: _this),
  Tex.crystalGlitterMirror:
      ExactAssetImage('${_dir}gif/crystal_mirror$_g', package: _this),
  Tex.dented: ExactAssetImage('${_dir}dent$_p', package: _this),
  Tex.frosted: ExactAssetImage('${_dir}frost$_p', package: _this),
  Tex.marbled: ExactAssetImage('${_dir}marble$_p', package: _this),
  Tex.noise: ExactAssetImage('${_dir}noise/noise$_p', package: _this),
  Tex.noiseSuperlight:
      ExactAssetImage('${_dir}noise/superlight$_p', package: _this),
  Tex.noiseLight: ExactAssetImage('${_dir}noise/light$_p', package: _this),
  Tex.noiseHeavy: ExactAssetImage('${_dir}noise/heavy$_p', package: _this),
  Tex.steam: ExactAssetImage('${_dir}steam$_p', package: _this),
  Tex.wet: ExactAssetImage('${_dir}wet$_p', package: _this),
  Tex.wetRain: ExactAssetImage('${_dir}gif/wet$_g', package: _this),
  Tex.wetRainAlt: ExactAssetImage('${_dir}gif/wet_alt$_g', package: _this),
  Tex.wetRainTile: ExactAssetImage('${_dir}gif/wet_tile$_g', package: _this),
};

/// These textures represent different styles of frosted glass.
/// Used as the `texture` property for a [Frost] within `Glass`.
enum Tex {
  /// Some outdoor patio sets have a glass table with this stylized,
  /// hammered look.
  chisled,

  /// Someone left this on the ground after they unwrapped their chewing gum.
  crystal,

  /// Animated variant of [crystal], non-kaleidoscopic.
  crystalGlitter,

  /// Animated variant of [crystal], non-kaleidoscopic.
  /// Faster than [crystalGlitter].
  crystalGlitterFast,

  /// Animated variant of [crystal], non-kaleidoscopic. Animation mirrors.
  crystalGlitterMirror,

  /// Similar to [chiseled]:  Some outdoor patio sets have a glass table
  /// with this stylized, hammered look.
  dented,

  /// Mild pixelated distortion throughout mimics the effect of frosted glass.
  frosted,

  /// For `Glass` that's a little more like stone...
  marbled,

  /// Standard black and white noise. Tiles great. Classic look.
  noise,

  /// Super light black and white noise. Tiles great. Classic look. \
  /// Semi-transparent texture.
  noiseSuperlight,

  /// Light black and white noise. Tiles great. Classic look. \
  /// Semi-transparent texture.
  noiseLight,

  /// Heavy black and white noise. Tiles great. Classic look.
  noiseHeavy,

  /// Looks like a steamy glass shower door.
  steam,

  /// Looks like it was raining.
  wet,

  /// Animated variant of [wet].
  wetRain,

  /// Animated variant of [wet] with a different tempo.
  wetRainAlt,

  /// Animated variant of [wet] and a tiling variant of [wetRain].
  wetRainTile,
}

/// Add some flair to `Glass` with a `Frost` texture description.
///
/// This object provides a texture to be overlaid on the background of
/// a likely semi-transparent and `Filter`ed (blurring) container.
///
/// Use these properties to further customize a `Glass`'s appearance.
class Frost with Diagnosticable {
  /// Add some flair to `Glass` with a `Frost` description.
  ///
  /// This object describes a texture to be overlaid on the background of
  /// a likely semi-transparent and `Filter`ed (blurring) container.
  ///
  /// Use these properties to further customize a `Glass`'s appearance.
  const Frost({
    this.isFrosted = true,
    this.texture = Tex.noise,
    this.opacity = 0.1,
    this.repeat = Repeat.repeat,
    this.blendMode = BlendMode.multiply,
    this.strength = 0.25,
    this.mirrorOffset = Offset.zero,
    this.customTexture,
  });

  /// Enable or disable this `Frost` texture. Default is `true`.
  final bool isFrosted;

  /// These textures and corresponding images represent different styles of
  /// frosted glass. Default is [Tex.noise].
  final Tex texture;

  /// The opacity of this texture over the background.
  ///
  /// Default is `0.1`. Must range `0..1`.
  final double opacity;

  final Repeat repeat;

  /// This property describes how this `Frost`'s [texture] or [customTexture]
  /// blends with the `Glass`'s color.
  ///
  /// The strength of the color for this blend is provided as [strength]
  /// whereas the overall transparency of this `Frost` is defined as [opacity].
  ///
  /// Default is [BlendMode.multiply].
  final BlendMode blendMode;

  /// This value corresponds to how opaque the interaction between the `Glass`'s
  /// color and this `Frost`'s texture is, considering the provided [blendMode].
  ///
  /// Default is `0.25`. Must range `0..1`.
  final double strength;

  final Offset mirrorOffset;

  /// Instead of any of the [Tex] pre-defined [texture]s, opt to provide a
  /// `String` that is a path to a custom image for this `Frost`'s texture.
  final String? customTexture;

  /// 📋 Return a copy of this 🧊 `Frost` with optional parameters
  /// replacing those of `this`.
  Frost copyWith({
    bool? isFrosted,
    Tex? texture,
    double? opacity,
    BlendMode? blendMode,
    double? strength,
    String? customTexture,
  }) =>
      Frost(
        isFrosted: isFrosted ?? this.isFrosted,
        texture: texture ?? this.texture,
        opacity: opacity ?? this.opacity,
        blendMode: blendMode ?? this.blendMode,
        strength: strength ?? this.strength,
        customTexture: customTexture ?? this.customTexture,
      );

  @override
  void debugFillProperties(properties) {
    super.debugFillProperties(properties);
    properties
          ..add(
              FlagProperty('isFrosted', value: isFrosted, ifTrue: '🧊 Frosted'))
          ..add(
              DiagnosticsProperty<Tex>('texture', texture, defaultValue: null))
          ..add(DoubleProperty('opacity', opacity, defaultValue: null))
          ..add(DiagnosticsProperty<BlendMode>('blendMode', blendMode,
              defaultValue: null))
          ..add(DoubleProperty('strength', strength, defaultValue: null))
          ..add(StringProperty('customTexture', customTexture,
              defaultValue: null))
        //
        ;
  }
}
