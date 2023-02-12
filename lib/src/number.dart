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

import 'dart:math' as math;

import 'grammar.dart';

extension Number<T extends num> on T {
  //...Getter
  /// Whether number is an even number.
  /// ```dart
  /// print(-2.isEven); // true;
  /// print(3.isEven); // false;
  /// ```
  bool get isEven => this % 2 == 0;

  /// Whether number is decimal or whole number.
  /// Irrespective whether or not the number is integer,
  /// float or double. If the number contains decimal,
  /// this value is true.
  /// ```dart
  /// print(-2.isDecimal); // false;
  /// print(2.3.isDecimal); // true;
  /// ```
  bool get isDecimal => '$this'.contains(RegExp(r'\.\d+'));

  /// Reverse psychology of [isNegative]
  /// ```dart
  /// print(-2.isNegative); // true;
  /// print(!2.isNegative); // true;
  /// ```
  bool get isPositive => !isNegative;

  /// the whole part of number.
  /// ```dart
  /// print(-2.integer); // 2;
  /// print(.2.integer); // 0;
  /// ```
  String get integer => RegExp(r'\b\d+\b').stringMatch('$this') ?? '';

  /// the decimal part of number.
  /// ```dart
  /// print(-2.36.fraction); // .36;
  /// print(.200.fraction); // .200;
  /// ```
  String get fraction => RegExp(r'\.\d+').stringMatch('$this') ?? '';

  //...Methods
  /// Returns positive version of number. It's achieved
  /// by finding the square root of the square of number.
  /// In other words: √num²
  /// ```dart
  /// print(-2.prime()); // 2;
  /// ```
  T prime([int seed = 1]) {
    final num = math.sqrt(math.pow(this, 2));
    if (T == int) return (num * seed).round() as T;
    if (T == double) return (num * seed).toDouble() as T;
    return (num * seed) as T;
  }

  /// Return's the maximum number between this number and
  /// [t]. Same as [math.max] between this number and
  /// [t]. In other words, y = x > other? x : other
  /// ```dart
  /// print(2.max(3)); // 3;
  /// ```
  T max(T? t) => t != null ? math.max(this, t) : this;

  /// Return's the minimum number between this number and
  /// [t]. Same as [math.min] between this number and
  /// [t]. In other words, y = x < other? x : other
  /// ```dart
  /// print(2.max(3)); // 2;
  /// ```
  T min(T? t) => t != null ? math.min(this, t) : this;

  /// The digital string representation of number. [zero]
  /// digital rep will be returned if this number is zero.
  /// [digit] is the minimum amount of [integer] required
  /// the digital string. [decimal] is the precise amount
  /// of [fraction] required in the digital string.
  /// if [ordinal] is true, an ordinal number is returned.
  /// Ordinals like 1st, 2nd, 3rd... etc.
  /// ```dart
  /// print(21.0567.toDigitalString(digit: 7, decimal: 10));
  /// // '0000021.0567000000'
  /// ```
  String toDigitalString({
    int zero = 0,
    int? digit,
    int? decimal,
    bool ordinal = false,
  }) {
    final num = this == 0 ? zero : this;

    String integer = num.integer;
    String fraction = num.fraction;

    if (digit != null) {
      while (integer.length < digit) {
        integer = '0$integer';
      }
    }

    if (decimal != null) {
      while (fraction.length < (decimal + 1)) {
        fraction = '$fraction${0}';
      }
    }
    decimal ??= fraction.length;

    if (ordinal) {
      if (integer.endsWith('1')) return '${integer}st';
      if (integer.endsWith('2')) return '${integer}nd';
      if (integer.endsWith('3')) return '${integer}rd';
      return '${integer}th';
    }
    return '$integer${fraction.charsBefore(decimal + 1)}';
  }
}

extension Numbers<T extends num> on Iterable<T> {
  //...Getters
  /// Return's the maximum number from the list
  /// ```dart
  /// print([2, 3].max); // 3;
  /// ```
  T get max {
    T max = first;
    for (T number in this) {
      max = max.max(number);
    }
    return max;
  }

  /// Return's the minimum number from the list
  /// ```dart
  /// print([2, 3].min); // 2;
  /// ```
  T get min {
    T min = first;
    for (T number in this) {
      min = min.min(number);
    }
    return min;
  }
}
