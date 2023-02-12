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

extension Comparison<T> on Comparator<T> {
  //...Getters
  /// The inverse ordering of this comparator.
  Comparator<T> get inverse {
    //...
    return (T a, T b) => this(b, a);
  }

  /// Makes a comparator on [R] values using
  /// this comparator. Compares [R] values by
  /// comparing their [keyOf] value using this
  /// comparator.
  Comparator<R> compareBy<R>(T Function(R) keyOf) {
    //...
    return (R a, R b) => this(keyOf(a), keyOf(b));
  }

  /// Combine comparators sequentially.
  /// Creates a comparator which orders elements
  /// the same way as this comparator, except that
  /// when two elements are considered equal, the
  /// [tieBreaker] comparator is used instead.
  Comparator<T> then(Comparator<T> tieBreaker) {
    //...
    return (T a, T b) {
      var result = this(a, b);
      if (result == 0) result = tieBreaker(a, b);
      return result;
    };
  }
}
