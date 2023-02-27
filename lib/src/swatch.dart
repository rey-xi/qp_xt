/*
 * Copyright (C) 2022 Rey Core Tools
 *
 *        - Balogun Emmanuel (aka) Rey Manuel
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
 * either express or implied. See the License for the specific
 * language governing permissions and limitations under the
 * License.
 */

import 'dart:math';

import 'package:flutter/material.dart';

import 'number.dart';

extension Swatch<T extends Color> on T {
  //...Getters
  /// Checks if the given [color] is dark. This is done by
  /// checking if the luminance of color is less than 0.5
  /// or not.
  bool get isDark {
    //...
    return computeLuminance() < .5 && alpha > 122.5;
  }

  /// Checks if the given [color] is light. This is done by
  /// checking if the luminance of color is greater than 0.5
  /// or not.
  bool get isLight {
    //...
    return computeLuminance() > .5 || alpha < 122.5;
  }

  //...Methods
  /// compare color values with [other] color values. use
  /// [percentDiff] to range their differences against 1
  double distanceTo(Color other, [double total = 510.0]) {
    //...
    final a = (other.alpha - alpha).prime(1);
    final r = (other.red - red).prime(1);
    final g = (other.green - green).prime(1);
    final b = (other.blue - blue).prime(1);
    return sqrt(a ^ 2 + r ^ 2 + g ^ 2 + b ^ 2) / 510.0 * total;
  }

  /// Returns a brighter or dimmed version of the color using
  /// the given [factor]. The resultant color is brighter if
  /// factor is positive else the color is deemed
  Color addBrightness(double factor) {
    //...
    final h = HSLColor.fromColor(this);
    final v = h.lightness + factor * 1.0;
    return h.withLightness(v.clamp(0.0, 1.0)).toColor();
  }

  /// Returns a contrast version of the color using the given
  /// [factor]. The resultant color will be more saturated if
  /// factor is positive else the color is less saturated
  Color addSaturation(double factor) {
    //...
    final h = HSLColor.fromColor(this);
    final v = h.saturation + factor * 1.0;
    return h.withSaturation(v.clamp(0.0, 1.0)).toColor();
  }

  /// Returns a contrast version of the color using the given
  /// [factor]. The resultant color will be more saturated if
  /// factor is positive else the color is less saturated
  Color addHue(double factor) {
    //...
    final h = HSLColor.fromColor(this);
    final v = h.hue + factor * 1.0;
    return h.withHue(v.clamp(0.0, 1.0)).toColor();
  }

  /// Returns a brighter or dimmed version of the color using
  /// the given [factor]. The resultant color is brighter if
  /// factor is positive else the color is deemed
  Color withBrightness(double factor) {
    //...
    final h = HSLColor.fromColor(this);
    final v = factor.clamp(0.0, 1.0);
    return h.withLightness(v).toColor();
  }

  /// Returns a contrast version of the color using the given
  /// [factor]. The resultant color will be more saturated if
  /// factor is positive else the color is less saturated
  Color withSaturation(double factor) {
    //...
    final h = HSLColor.fromColor(this);
    final v = factor.clamp(0.0, 1.0);
    return h.withSaturation(v).toColor();
  }

  /// Returns a contrast version of the color using the given
  /// [factor]. The resultant color will be more saturated if
  /// factor is positive else the color is less saturated
  Color withHue(double factor) {
    //...
    final h = HSLColor.fromColor(this);
    final v = factor.clamp(0.0, 1.0);
    return h.withHue(v).toColor();
  }

  /// Returns an inverted version of color. In case of red,
  /// it will return cyan or green depending on the type of
  /// red. Note: the resultant is less effective to [fore]
  Color invert() {
    //...
    final r = 255 - red;
    final g = 255 - green;
    final b = 255 - blue;
    return Color.fromARGB((opacity * 255).round(), r, g, b);
  }
}
