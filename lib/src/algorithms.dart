part of collection;

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

void _mergeSortBy<E, K>(
  List<E> elements,
  K Function(E element) keyOf,
  int Function(K a, K b) compare, {
  int start = 0,
  int? end,
}) {
  //...
  end = RangeError.checkValidRange(
    start,
    end,
    elements.length,
  );
  var length = end - start;
  if (length < 2) return;
  if (length < 32) {
    _movingInsertionSort(
      elements,
      keyOf,
      compare,
      start,
      end,
      elements,
      start,
    );
    return;
  }
  var middle = start + (length >> 1);
  var firstLength = middle - start;
  var secondLength = end - middle;
  var scratchSpace = List<E>.filled(
    secondLength,
    elements[start],
  );
  _mergeSort(
    elements,
    keyOf,
    compare,
    middle,
    end,
    scratchSpace,
    0,
  );
  var firstTarget = end - firstLength;
  _mergeSort(
    elements,
    keyOf,
    compare,
    start,
    middle,
    elements,
    firstTarget,
  );
  _merge(
    keyOf,
    compare,
    elements,
    firstTarget,
    end,
    scratchSpace,
    0,
    secondLength,
    elements,
    start,
  );
}

void _movingInsertionSort<E, K>(
  List<E> list,
  K Function(E element) keyOf,
  int Function(K, K) compare,
  int start,
  int end,
  List<E> target,
  int targetOffset,
) {
  //...
  var length = end - start;
  if (length == 0) return;
  target[targetOffset] = list[start];
  for (var i = 1; i < length; i++) {
    var element = list[start + i];
    var elementKey = keyOf(element);
    var min = targetOffset;
    var max = targetOffset + i;
    while (min < max) {
      var mid = min + ((max - min) >> 1);
      if (compare(elementKey, keyOf(target[mid])) < 0) {
        max = mid;
      } else {
        min = mid + 1;
      }
    }
    target.setRange(
      min + 1,
      targetOffset + i + 1,
      target,
      min,
    );
    target[min] = element;
  }
}

void _mergeSort<E, K>(
  List<E> elements,
  K Function(E element) keyOf,
  int Function(K, K) compare,
  int start,
  int end,
  List<E> target,
  int targetOffset,
) {
  //...
  var length = end - start;
  if (length < 32) {
    _movingInsertionSort<E, K>(
      elements,
      keyOf,
      compare,
      start,
      end,
      target,
      targetOffset,
    );
    return;
  }
  var middle = start + (length >> 1);
  var firstLength = middle - start;
  var secondLength = end - middle;
  var targetMiddle = targetOffset + firstLength;
  _mergeSort(
    elements,
    keyOf,
    compare,
    middle,
    end,
    target,
    targetMiddle,
  );
  _mergeSort(
    elements,
    keyOf,
    compare,
    start,
    middle,
    elements,
    middle,
  );
  _merge(
    keyOf,
    compare,
    elements,
    middle,
    middle + firstLength,
    target,
    targetMiddle,
    targetMiddle + secondLength,
    target,
    targetOffset,
  );
}

void _merge<E, K>(
  K Function(E element) keyOf,
  int Function(K, K) compare,
  List<E> firstList,
  int firstStart,
  int firstEnd,
  List<E> secondList,
  int secondStart,
  int secondEnd,
  List<E> target,
  int targetOffset,
) {
  //...
  assert(firstStart < firstEnd);
  assert(secondStart < secondEnd);
  var cursor1 = firstStart;
  var cursor2 = secondStart;
  var firstElement = firstList[cursor1++];
  var firstKey = keyOf(firstElement);
  var secondElement = secondList[cursor2++];
  var secondKey = keyOf(secondElement);
  while (true) {
    if (compare(firstKey, secondKey) <= 0) {
      target[targetOffset++] = firstElement;
      if (cursor1 == firstEnd) break;
      firstElement = firstList[cursor1++];
      firstKey = keyOf(firstElement);
    } else {
      target[targetOffset++] = secondElement;
      if (cursor2 != secondEnd) {
        secondElement = secondList[cursor2++];
        secondKey = keyOf(secondElement);
        continue;
      }
      target[targetOffset++] = firstElement;
      target.setRange(
        targetOffset,
        targetOffset + (firstEnd - cursor1),
        firstList,
        cursor1,
      );
      return;
    }
  }
  target[targetOffset++] = secondElement;
  target.setRange(
    targetOffset,
    targetOffset + (secondEnd - cursor2),
    secondList,
    cursor2,
  );
}
