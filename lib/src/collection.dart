library collection;

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
import 'dart:ui';

import 'swatch.dart';

part 'collection/algorithms.dart';

/// ## ArrayList
/// A more Advance means of working with all forms
/// of Iterables It treat's iterables as though they
/// have infinite number of elements. All elements
/// are null by default.
/// ```dart
/// print(['key', 'value'].at(2)); // null
/// ```
///
extension Collection<T> on Iterable<T> {
  //...Getters
  /// Returns first element in the iterable if the
  /// iterable is not empty else returns `null`
  T? get firstOrNull {
    var iterator = this.iterator;
    if (iterator.moveNext()) {
      return iterator.current;
    }
    return null;
  }

  /// Returns last element in the iterable if the
  /// iterable is not empty else returns `null`
  T? get lastOrNull {
    if (isEmpty) return null;
    return last;
  }

  /// The single element of the iterable, or `null`.
  /// The value is `null` if the iterable is empty or
  /// it contains more than one element.
  T? get singleOrNull {
    var iterator = this.iterator;
    if (iterator.moveNext()) {
      var result = iterator.current;
      if (!iterator.moveNext()) {
        return result;
      }
    }
    return null;
  }

  //...Operators
  /// Returns a new list with duplicates of this
  /// list in [operand] times. Basically, to optimize
  /// development speed was the goal
  /// ```dart
  /// print([1, 2, 3] * 3);
  /// // [1, 2, 3, 1, 2, 3, 1, 2, 3]
  /// ```
  List<T> operator *(int operand) {
    //...
    final List<T> list = [];
    while (operand > 0) {
      list.addAll(this);
      operand--;
    }
    return list;
  }

  //...Methods
  /// The [index]th element, or `null` if there
  /// is no such element.
  ///
  /// Returns the element at position [index] of
  /// this iterable, just like [elementAt], if
  /// this iterable has such an element. If this
  /// iterable does not have enough elements to
  /// have one with the given [index], the `null`
  /// value is returned, unlike [elementAt] which
  /// throws instead.
  ///
  /// The [index] must not be negative.
  T? elementAtOrNull(int index) => skip(index).firstOrNull;

  /// Spread elements of list out using [item].
  /// ```dart
  /// print([1, 2, 3].spread(0)); //1, 0, 2, 0, 3
  /// ```
  List<R> spread<R>(R item) {
    //...
    if (isEmpty) return [];
    final result = <R>[first as R];
    for (T element in skip(1)) {
      result.addAll([item, element as R]);
    }
    return result;
  }

  /// Selects [count] elements at random from this
  /// iterable.
  ///
  /// The returned list contains [count] different
  /// elements of the iterable. If the iterable
  /// contains fewer that [count] elements, the
  /// result will contain all of them, but will be
  /// shorter than [count]. If the same value occurs
  /// more than once in the iterable,  it can also
  /// occur more than once in the chosen elements.
  ///
  /// Each element of the iterable has the same
  /// chance of being chosen.  The chosen elements
  /// are not in any specific order.
  List<T> sample(int count, [Random? random]) {
    RangeError.checkNotNegative(count, 'count');
    var iterator = this.iterator;
    var chosen = <T>[];
    for (var i = 0; i < count; i++) {
      if (iterator.moveNext()) {
        chosen.add(iterator.current);
      } else {
        return chosen;
      }
    }
    var index = count;
    random ??= Random();
    while (iterator.moveNext()) {
      index++;
      var position = random.nextInt(index);
      if (position < count) {
        chosen[position] = iterator.current;
      }
    }
    return chosen;
  }

  /// The element in iterable that do not satisfy
  /// [test]. Direct opposite of [where].
  /// ```dart
  /// print([1, 2, 3].where((x) => x == 0));
  /// ```
  Iterable<T> whereNot(bool Function(T element) test) {
    return where((element) => !test(element));
  }

  /// Creates a sorted list of the elements of
  /// the iterable. The elements are ordered by
  /// the [compare] [Comparator].
  /// ```dart
  /// print([1, 2, 3].sorted((a, b) => a - b));
  /// ```
  List<T> sort(Comparator<T> compare) {
    return [...this]..sort(compare);
  }

  /// Creates a sorted list of the elements of
  /// the iterable.
  ///
  /// The elements are ordered by the natural
  /// ordering of the  property [keyOf] of the
  /// element.
  List<T> sortBy<K extends Comparable<K>>(
    K Function(T element) keyOf, [
    Comparator<K>? compare,
  ]) {
    //...
    compare ??= (a, b) {
      return (a.compareTo(b));
    };
    var elements = [...this];
    _mergeSortBy<T, K>(
      elements,
      keyOf,
      compare,
    );
    return elements;
  }

  /// Whether the elements are sorted by the
  /// [compare] ordering.
  ///
  /// Compares pairs of elements using `compare`
  /// to check that the elements of this iterable
  /// to check that earlier elements always compare
  /// smaller than or equal to later elements.
  ///
  /// Note: An single-element or empty iterable is
  /// trivially in sorted order.
  /// ```dart
  /// print([1, 2, 3].isSorted((a, b) => a - b));
  /// ```
  bool isSorted(Comparator<T> compare) {
    var iterator = this.iterator;
    if (!iterator.moveNext()) return true;
    var previousElement = iterator.current;
    while (iterator.moveNext()) {
      var element = iterator.current;
      if (compare(previousElement, element) > 0) return false;
      previousElement = element;
    }
    return true;
  }

  /// Whether the elements are sorted by their
  /// [keyOf] property.
  ///
  /// Applies [keyOf] to each element in iterable
  /// iteration order, then checks whether the
  /// results are in non-decreasing [Comparable]
  /// order.
  /// ```dart
  /// print([1, 2, 3].isSortedBy(keyOF);
  /// ```
  bool isSortedBy<K extends Comparable<K>>(
    K Function(T element) keyOf, [
    Comparator<K>? compare,
  ]) {
    compare ??= (a, b) {
      return (a.compareTo(b));
    };
    var iterator = this.iterator;
    if (!iterator.moveNext()) return true;
    var previousKey = keyOf(iterator.current);
    while (iterator.moveNext()) {
      var key = keyOf(iterator.current);
      if (compare(previousKey, key) > 0) return false;
      previousKey = key;
    }
    return true;
  }

  /// Spread elements of list out using [item].
  /// ```dart
  /// print([1, 2, 3].spread(0)); //1, 0, 2, 0, 3
  /// ```
  Iterable<R> mapIndexed<R>(
    R Function(T value, int index) mapping,
  ) sync* {
    //...
    var index = 0;
    for (var element in this) {
      yield mapping(element, index++);
    }
  }

  /// Takes an action for each element as long
  /// as desired. Calls [action] for each element.
  /// Stops iteration if [action] returns `false`.
  void forEachWhile(
    bool Function(T element) action,
  ) {
    for (var element in this) {
      if (!action(element)) break;
    }
  }

  /// Takes an action for each element.  Calls
  /// [action] for each element along with the
  /// index in the iteration order.
  void forEachIndexed(
    Function(int index, T element) action,
  ) {
    var index = 0;
    for (var element in this) {
      if (action(index++, element) != null) break;
    }
  }

  /// The elements whose value and index satisfies
  /// [test].
  Iterable<T> whereIndexed(
    bool Function(int index, T element) test,
  ) sync* {
    var index = 0;
    for (var element in this) {
      if (test(index++, element)) yield element;
    }
  }

  /// The elements whose value and index do not
  /// satisfy [test].
  Iterable<T> whereNotIndexed(
    bool Function(int index, T element) test,
  ) sync* {
    var index = 0;
    for (var element in this) {
      if (!test(index++, element)) yield element;
    }
  }

  /// Expands each element and index to a number
  /// of elements in a new iterable.
  Iterable<R> expandIndexed<R>(
    Iterable<R> Function(int index, T element) expand,
  ) sync* {
    var index = 0;
    for (var element in this) {
      yield* expand(index++, element);
    }
  }

  /// Combine the elements with each other and the
  /// current index.
  ///
  /// Calls [combine] for each element except the
  /// first. The call passes the index of the current
  /// element, the result of the previous call, or
  /// the first element for the first call, and the
  /// current element.
  ///
  /// Returns the result of the last call, or
  /// the first element if there is only one
  /// element. There must be at least one element.
  T reduceIndexed(
    T Function(int index, T previous, T element) combine,
  ) {
    var iterator = this.iterator;
    if (!iterator.moveNext()) {
      throw StateError('no elements');
    }
    var index = 1;
    var result = iterator.current;
    while (iterator.moveNext()) {
      result = combine(index++, result, iterator.current);
    }
    return result;
  }

  /// Combine the elements with a value and the
  /// current index. Calls [combine] for each element
  /// with the current index, the result
  /// of the previous call, or [initialValue] for
  /// the first element, and the current element.
  ///
  /// Returns the result of the last call to [combine],
  /// or [initialValue] if there are no elements.
  R foldIndexed<R>(
    R initialValue,
    R Function(int index, R previous, T element) combine,
  ) {
    var result = initialValue;
    var index = 0;
    for (var element in this) {
      result = combine(index++, result, element);
    }
    return result;
  }

  T firstWhereType<R>() {
    for (var element in this) {
      if (element is R) return element;
    }
    final err = 'no $R element found';
    return throw StateError(err);
  }

  T lastWhereType<R>() {
    T? result;
    for (var element in this) {
      if (element is R) return result = element;
    }
    final err = 'no $R element found';
    return result ?? (throw StateError(err));
  }

  /// The first element satisfying [test] and is
  /// also of type [R]. Returns `null` if there
  /// are none.
  R? firstWhereOrNull<R extends T>([
    bool Function(R element)? test,
  ]) {
    test ??= (x) => true;
    for (var element in this) {
      if (element is R && test(element)) {
        return element;
      }
    }
    return null;
  }

  /// The last element satisfying [test] and is
  /// also of type [R]. Returns `null` if there
  /// are none.
  R? lastWhereOrNull<R extends T>([
    bool Function(R element)? test,
  ]) {
    R? result;
    test ??= (x) => true;
    for (var element in this) {
      if (element is R && test(element)) {
        result = element;
      }
    }
    return result;
  }

  /// The single element satisfying [test].
  ///
  /// Returns `null` if there are either no elements
  /// or more than one element satisfying [test].
  ///
  /// **Notice**: This behavior differs from
  /// [Iterable.singleWhere] which always throws
  /// if there are more than one match, and only
  /// calls the `orElse` function on zero matches.
  R? singleWhereOrNull<R extends T>([
    bool Function(R element)? test,
  ]) {
    R? result;
    var found = false;
    test ??= (x) => true;
    for (var element in this) {
      if (element is R && test(element)) {
        if (!found) {
          result = element;
          found = true;
        } else {
          return null;
        }
      }
    }
    return result;
  }

  /// The first element whose value and index
  /// satisfies [test]. Returns `null` if there
  /// are no element and index satisfying [test].
  R? firstWhereIndexedOrNull<R extends T>([
    bool Function(int index, R element)? test,
  ]) {
    var index = 0;
    test ??= (i, x) => true;
    for (var element in this) {
      if (element is R && test(index++, element)) {
        return element;
      }
    }
    return null;
  }

  /// The last element whose index and value
  /// satisfies [test]. Returns `null` if no
  /// element and index satisfies [test].
  R? lastWhereIndexedOrNull<R extends T>([
    bool Function(int index, R element)? test,
  ]) {
    R? result;
    var index = 0;
    test ??= (i, x) => true;
    for (var element in this) {
      if (element is R && test(index++, element)) {
        result = element;
      }
    }
    return result;
  }

  /// The single element satisfying [test]. Returns
  /// `null` if there are either none or more than
  /// one element and index satisfying [test].
  R? singleWhereIndexedOrNull<R extends T>([
    bool Function(int index, R element)? test,
  ]) {
    R? result;
    var found = false;
    test ??= (i, x) => true;
    var index = 0;
    for (var element in this) {
      if (element is R && test(index++, element)) {
        if (!found) {
          result = element;
          found = true;
        } else {
          return null;
        }
      }
    }
    return result;
  }

  /// Groups elements by [keyOf] then folds the
  /// elements in each group.
  ///
  /// A key is found for each element using [keyOf].
  /// Then the elements with the same key are all
  /// folded using [combine]. The first call to
  /// [combine] for a particular key receives `null`
  /// as the previous value, the remaining ones
  /// receive the result of the previous call.
  ///
  /// Can be used to _group_ elements into arbitrary
  /// collections. For example [groupSetsBy] could be
  /// written as:
  ///
  /// ```dart
  /// iterable.groupFoldBy(
  ///    keyOf,
  ///    (Set<T>? previous, T element) {
  ///      (previous ?? <T>{})..add(element));
  ///   },
  /// );
  /// ````
  Map<K, G> groupFoldBy<K, G>(
    K Function(T element) keyOf,
    G Function(G? previous, T element) combine,
  ) {
    var result = <K, G>{};
    for (var element in this) {
      var key = keyOf(element);
      result[key] = combine(result[key], element);
    }
    return result;
  }

  /// Groups elements into sets by [keyOf].
  Map<K, Set<T>> groupSetsBy<K>(
    K Function(T element) keyOf,
  ) {
    var result = <K, Set<T>>{};
    for (var element in this) {
      final map = result[keyOf(element)] ??= <T>{};
      map.add(element);
    }
    return result;
  }

  /// Groups elements into lists by [keyOf].
  Map<K, List<T>> groupListsBy<K>(
    K Function(T element) keyOf,
  ) {
    var result = <K, List<T>>{};
    for (var element in this) {
      (result[keyOf(element)] ??= []).add(element);
    }
    return result;
  }

  /// Splits the elements into chunks before
  /// some elements.
  ///
  /// Each element except the first is checked
  /// using [test] for whether it should be the
  /// first element in a new chunk. If so, the
  /// elements since the previous chunk-starting
  /// element are emitted as a list.
  /// Any remaining elements are emitted at the
  /// end.
  ///
  /// Example:
  /// ```dart
  /// var parts = [1, 0, 2, 1, 5, 7, 6, 8, 9];
  /// var iterParts = parts.splitBefore(isPrime);
  /// print(parts); // (
  ///                    [1, 0],
  ///                    [2, 1],
  ///                    [5],
  ///                    [7, 6, 8, 9]
  ///                 )
  /// ```
  Iterable<List<T>> splitBefore(
    bool Function(T element) test,
  ) {
    return splitBeforeIndexed(
      (_, element) => test(element),
    );
  }

  /// Splits the elements into chunks after some
  /// elements. Each element is checked using [test]
  /// for whether it should end a chunk. If so, the
  /// elements following the previous chunk-ending
  /// element, including the element that satisfied
  /// [test], are emitted as a list.
  ///
  /// Any remaining elements are emitted at the end,
  /// whether the last element should be split after
  /// or not.
  ///
  /// Example:
  /// ```dart
  /// var parts = [1, 0, 2, 1, 5, 7, 6, 8, 9];
  /// var iterParts = parts.splitAfter(isPrime);
  /// print(parts); // (
  ///                     [1, 0, 2],
  ///                     [1, 5],
  ///                     [7],
  ///                     [6, 8, 9]
  ///                  )
  /// ```
  Iterable<List<T>> splitAfter(
    bool Function(T element) test,
  ) {
    return splitAfterIndexed(
      (_, element) => test(element),
    );
  }

  /// Splits the elements into chunks between some
  /// elements. Each pair of adjacent elements are
  /// checked using [test] for whether a chunk should
  /// end between them. If so, the elements since the
  /// previous chunk-splitting elements are emitted
  /// as a list. Any remaining elements are emitted
  /// at the end.
  ///
  /// Example:
  /// ```dart
  /// var parts = [1, 0, 2, 1, 5, 7, 6, 8, 9];
  /// var iterParts = parts.splitBetween(isPrime);
  /// print(parts); // (
  ///                     [1],
  ///                     [0, 2],
  ///                     [1, 5, 7],
  ///                     [6, 8, 9],
  ///                  )
  /// ```
  Iterable<List<T>> splitBetween(
    bool Function(T first, T second) test,
  ) {
    return splitBetweenIndexed(
      (_, first, second) => test(first, second),
    );
  }

  /// Splits the elements into chunks before some
  /// elements and indices. Each element and index
  /// except the first is checked using [test] for
  /// whether it should start a new chunk. If so,
  /// the elements since the previous chunk-starting
  /// element are emitted as a list. Any remaining
  /// elements are emitted at the end.
  ///
  /// Example:
  /// ```dart
  /// var parts = [1, 0, 2, 1, 5, 7, 6, 8, 9];
  /// var iterParts = parts.splitBeforeIndexed(isPrime);
  /// print(parts); // (
  ///                     [1],
  ///                     [0, 2],
  ///                     [1, 5, 7],
  ///                     [6, 8, 9]
  ///                  )
  /// ```
  Iterable<List<T>> splitBeforeIndexed(
    bool Function(int index, T element) test,
  ) sync* {
    var iterator = this.iterator;
    if (!iterator.moveNext()) {
      return;
    }
    var index = 1;
    var chunk = [iterator.current];
    while (iterator.moveNext()) {
      var element = iterator.current;
      if (test(index++, element)) {
        yield chunk;
        chunk = [];
      }
      chunk.add(element);
    }
    yield chunk;
  }

  /// Splits the elements into chunks after some
  /// elements and indices. Each element and index
  /// is checked using [test] for whether it should
  /// end the current chunk. If so, the elements
  /// since the previous chunk-ending element,
  /// including the element that satisfied [test],
  /// are emitted as a list.
  ///
  /// Any remaining elements are emitted at the end,
  /// whether the last element should be split after
  /// or not.
  ///
  /// Example:
  /// ```dart
  /// var parts = [1, 0, 2, 1, 5, 7, 6, 8, 9];
  /// var iterParts = parts.splitAfterIndexed(isPrime);
  /// print(parts); // (
  ///                     [1, 0],
  ///                     [2, 1],
  ///                     [5, 7, 6],
  ///                     [8, 9],
  ///                  )
  /// ```
  Iterable<List<T>> splitAfterIndexed(
    bool Function(int index, T element) test,
  ) sync* {
    var index = 0;
    List<T>? chunk;
    for (var element in this) {
      (chunk ??= []).add(element);
      if (test(index++, element)) {
        yield chunk;
        chunk = null;
      }
    }
    if (chunk != null) yield chunk;
  }

  /// Splits the elements into chunks between some
  /// elements and indices. Each pair of adjacent
  /// elements and the index of the latter are
  /// checked using [test] for whether a chunk
  /// should end  between them. If so, the elements
  /// since the previous chunk-splitting elements
  /// are emitted as a list. Any remaining elements
  /// are emitted at the end.
  ///
  /// Example:
  /// ```dart
  /// var parts = [1, 0, 2, 1, 5, 7, 6, 8, 9]
  ///    .splitBetweenIndexed((i, v1, v2) => v1 > v2);
  /// print(parts); // (
  ///                     [1],
  ///                     [0, 2],
  ///                     [1, 5, 7],
  ///                     [6, 8, 9]
  ///                  )
  /// ```
  Iterable<List<T>> splitBetweenIndexed(
    bool Function(int index, T first, T second) test,
  ) sync* {
    var iterator = this.iterator;
    if (!iterator.moveNext()) return;
    var previous = iterator.current;
    var chunk = <T>[previous];
    var index = 1;
    while (iterator.moveNext()) {
      var element = iterator.current;
      if (test(index++, previous, element)) {
        yield chunk;
        chunk = [];
      }
      chunk.add(element);
      previous = element;
    }
    yield chunk;
  }

  /// Whether no element satisfies [test].
  ///
  /// Returns true if no element satisfies [test],
  /// and false if at least one does.
  ///
  /// Equivalent to `iterable.every((x) => !test(x))`
  /// or `!iterable.any(test)`.
  bool none(bool Function(T) test) {
    for (var element in this) {
      if (test(element)) return false;
    }
    return true;
  }

  /// Contiguous slices of `this` with the given
  /// [length]. Each slice is [length] elements
  /// long, except for the last one which may be
  /// shorter if `this` contains too few elements.
  /// Each slice begins after the last one ends.
  /// The [length] must be greater than zero.
  ///
  /// For example, `{1, 2, 3, 4, 5}.slices(2)`
  ///      returns `([1, 2], [3, 4], [5])`.
  Iterable<List<T>> slices(int length) sync* {
    if (length < 1) {
      throw RangeError.range(
        length,
        1,
        null,
        'length',
      );
    }

    var iterator = this.iterator;
    while (iterator.moveNext()) {
      var slice = [iterator.current];
      for (var i = 1; i < length && iterator.moveNext(); i++) {
        slice.add(iterator.current);
      }
      yield slice;
    }
  }

  /// The non-`null` elements of this `Iterable`.
  /// Returns an iterable which emits all the non-
  /// `null` elements  of this iterable, in their
  /// original iteration order. For an `Iterable<X?>`,
  /// this method is equivalent to `.whereType<X>()`.
  Iterable<T> whereNotNull() sync* {
    for (var element in this) {
      if (element != null) yield element;
    }
  }
}

extension NumberCollection on Iterable<num> {
  //...Getters
  /// A minimal element of the iterable. If any
  /// element is [NaN](double.nan), the result
  /// is NaN. The iterable must not be empty.
  num get min => minOrNull ?? (throw StateError('No element'));

  /// A maximal element of the iterable. If any
  /// element is [NaN](double.nan), the result
  /// is NaN. The iterable must not be empty.
  num get max => maxOrNull ?? (throw StateError('No element'));

  /// A minimal element of the iterable, or `null`
  /// it the iterable is empty. If any element is
  /// [NaN](double.nan), the result is NaN.
  num? get minOrNull {
    var iterator = this.iterator;
    if (iterator.moveNext()) {
      var value = iterator.current;
      if (value.isNaN) {
        return value;
      }
      while (iterator.moveNext()) {
        var newValue = iterator.current;
        if (newValue.isNaN) {
          return newValue;
        }
        if (newValue < value) {
          value = newValue;
        }
      }
      return value;
    }
    return null;
  }

  /// A maximal element of the iterable, or `null`
  /// if the iterable is empty. If any element is
  /// [NaN](double.nan), the result is NaN.
  num? get maxOrNull {
    var iterator = this.iterator;
    if (iterator.moveNext()) {
      var value = iterator.current;
      if (value.isNaN) {
        return value;
      }
      while (iterator.moveNext()) {
        var newValue = iterator.current;
        if (newValue.isNaN) {
          return newValue;
        }
        if (newValue > value) {
          value = newValue;
        }
      }
      return value;
    }
    return null;
  }

  /// The sum of the elements. The sum is zero
  /// if the iterable is empty.
  num get sum {
    num result = 0;
    for (var value in this) {
      result += value;
    }
    return result;
  }

  /// The arithmetic mean of the elements of a
  /// non-empty iterable. The arithmetic mean is
  /// the sum of the elements divided by the
  /// number of elements.
  ///
  /// The iterable must not be empty.
  double get average {
    var result = 0.0;
    var count = 0;
    for (var value in this) {
      count += 1;
      result += (value - result) / count;
    }
    if (count == 0) throw StateError('No elements');
    return result;
  }
}

extension IntegerCollection on Iterable<int> {
  //...Getters
  /// A minimal element of the iterable, or
  /// `null` it the iterable is empty.
  int? get minOrNull {
    var iterator = this.iterator;
    if (iterator.moveNext()) {
      var value = iterator.current;
      while (iterator.moveNext()) {
        var newValue = iterator.current;
        if (newValue < value) {
          value = newValue;
        }
      }
      return value;
    }
    return null;
  }

  /// A minimal element of the iterable. The
  /// iterable must not be empty.
  int get min => minOrNull ?? (throw StateError('No element'));

  /// A maximal element of the iterable, or
  /// `null` if the iterable is empty.
  int? get maxOrNull {
    var iterator = this.iterator;
    if (iterator.moveNext()) {
      var value = iterator.current;
      while (iterator.moveNext()) {
        var newValue = iterator.current;
        if (newValue > value) {
          value = newValue;
        }
      }
      return value;
    }
    return null;
  }

  /// A maximal element of the iterable. The
  /// iterable must not be empty.
  int get max => maxOrNull ?? (throw StateError('No element'));

  /// The sum of the elements. The sum is zero
  /// if the iterable is empty.
  int get sum {
    var result = 0;
    for (var value in this) {
      result += value;
    }
    return result;
  }

  /// The arithmetic mean of the elements of
  /// a non-empty iterable. The arithmetic mean
  /// is the sum of the elements
  /// divided by the number of elements.
  /// This method is specialized for integers,
  /// and may give a different result than
  /// [IterableNumberExtension.average]
  /// for the same values, because the the number
  /// algorithm converts all numbers to doubles.
  /// The iterable must not be empty.
  double get average {
    var average = 0;
    var remainder = 0;
    var count = 0;
    for (var value in this) {
      // Invariant: Sum of values so far = average * count + remainder.
      // (Unless overflow has occurred).
      count += 1;
      var delta = value - average + remainder;
      average += delta ~/ count;
      remainder = delta.remainder(count);
    }
    if (count == 0) throw StateError('No elements');
    return average + remainder / count;
  }
}

extension DoubleCollection on Iterable<double> {
  /// A minimal element of the iterable, or `null`
  /// it the iterable is empty. If any element is
  /// [NaN](double.nan), the result is NaN.
  double? get minOrNull {
    var iterator = this.iterator;
    if (iterator.moveNext()) {
      var value = iterator.current;
      if (value.isNaN) {
        return value;
      }
      while (iterator.moveNext()) {
        var newValue = iterator.current;
        if (newValue.isNaN) {
          return newValue;
        }
        if (newValue < value) {
          value = newValue;
        }
      }
      return value;
    }
    return null;
  }

  /// A minimal element of the iterable. If any
  /// element is [NaN](double.nan), the result
  /// is NaN. The iterable must not be empty.
  double get min => minOrNull ?? (throw StateError('No element'));

  /// A maximal element of the iterable, or
  /// `null` if the iterable is empty. If any
  /// element is [NaN](double.nan), the result
  /// is NaN.
  double? get maxOrNull {
    var iterator = this.iterator;
    if (iterator.moveNext()) {
      var value = iterator.current;
      if (value.isNaN) {
        return value;
      }
      while (iterator.moveNext()) {
        var newValue = iterator.current;
        if (newValue.isNaN) {
          return newValue;
        }
        if (newValue > value) {
          value = newValue;
        }
      }
      return value;
    }
    return null;
  }

  /// A maximal element of the iterable. If any
  /// element is [NaN](double.nan), the result
  /// is NaN. The iterable must not be empty.
  double get max => maxOrNull ?? (throw StateError('No element'));

  /// The sum of the elements. The sum is zero
  /// if the iterable is empty.
  double get sum {
    var result = 0.0;
    for (var value in this) {
      result += value;
    }
    return result;
  }
}

extension GarbageCollection<T> on Iterable<T?> {
  /// A shortcut getter that helps us to recover an
  /// iterable of non null values of type [T]. See
  /// [Iterable.whereType]
  /// ```dart
  /// print([1, 2, 3, null, 8 null].abs;
  /// // {1, 2, 3, 8}
  /// ```
  Iterable<T> get abs => whereType<T>();
}

extension IterableCollection<T> on Iterable<Iterable<T>> {
  //...Getters
  /// The sequential elements of each iterable
  /// in this iterable. Iterates the elements of
  /// this iterable. For each one, which is
  /// itself  an iterable, all the elements of
  /// that are emitted on the returned iterable,
  /// before moving on to the next element.
  Iterable<T> get flattened sync* {
    for (var elements in this) {
      yield* elements;
    }
  }
}

extension SwatchCollection<T extends Color> on Iterable<T> {
  //...Methods
  /// compare color values of each color in this color list
  /// with [other] color values and return the color with the
  /// smallest difference based on [precision]
  T closestTo(Color other, [double precision = 510.0]) {
    //...
    final differences = map((e) => e.distanceTo(other, precision));
    final minIndex = differences.toList().indexOf(differences.min);
    return elementAt(minIndex);
  }

  /// compare color values of each color in this color list
  /// with [other] color values and return the color with the
  /// largest difference based on [precision]
  T farthestFrom(Color other, [double precision = 510.0]) {
    //...
    final differences = map((e) => e.distanceTo(other, precision));
    final maxIndex = differences.toList().indexOf(differences.max);
    return elementAt(maxIndex);
  }
}

extension ComparableCollection<T extends Comparable<T>> on Iterable<T> {
  //...Getters
  /// A minimal element of the iterable. The
  /// iterable  must not be empty.
  T get min => minOrNull ?? (throw StateError('No element'));

  /// A maximal element of the iterable. The
  /// iterable must not be empty.
  T get max => maxOrNull ?? (throw StateError('No element'));

  /// A minimal element of the iterable, or
  /// `null` it the iterable is empty.
  T? get minOrNull {
    var iterator = this.iterator;
    if (iterator.moveNext()) {
      var value = iterator.current;
      while (iterator.moveNext()) {
        var newValue = iterator.current;
        if (value.compareTo(newValue) > 0) {
          value = newValue;
        }
      }
      return value;
    }
    return null;
  }

  /// A maximal element of the iterable, or
  /// `null` if the iterable is empty.
  T? get maxOrNull {
    var iterator = this.iterator;
    if (iterator.moveNext()) {
      var value = iterator.current;
      while (iterator.moveNext()) {
        var newValue = iterator.current;
        if (value.compareTo(newValue) < 0) {
          value = newValue;
        }
      }
      return value;
    }
    return null;
  }

  /// Creates a sorted list of the elements
  /// of the iterable. If the [compare] function
  /// is not supplied, the sorting uses the natural
  /// [Comparable] ordering of the elements.
  List<T> sorted([Comparator<T>? compare]) {
    return [...this]..sort(compare);
  }

  /// Whether the elements are sorted, the [compare]
  /// ordering. If [compare] is omitted, it defaults
  /// to comparing the elements using their natural
  /// [Comparable] ordering.
  bool isSorted([Comparator<T>? compare]) {
    //...
    if (compare != null) {
      return Collection(this).isSorted(compare);
    }
    var iterator = this.iterator;
    if (!iterator.moveNext()) return true;
    var previousElement = iterator.current;
    while (iterator.moveNext()) {
      var element = iterator.current;
      if (previousElement.compareTo(element) > 0) return false;
      previousElement = element;
    }
    return true;
  }

  /// Same as calling [List.asMap] after getting
  /// a formal List representation of this
  /// [Iterable] via [Iterable.toList].
  /// ```dart
  /// print([1, 2, 3].toMap());
  /// // {0 : 1, 1 : 2, 2 : 3}
  /// ```
  Map<int, T> toMap() => toList().asMap();
}
