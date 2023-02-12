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

extension Grammar on String {
  //...Fields
  /// returns a list of words contained in a given sentence
  /// string. sames as calling [String.split]
  /// ```
  /// split(RegExp(r'\s'))
  /// ```
  List<String> get words => split(RegExp(r'\s'));

  /// returns a length of words contained in a given sentence
  /// string. sames as calling [List.length] on [String.split]
  /// ```
  /// split(RegExp(r'\s')).length
  /// ```
  int get wordCount => words.length;

  //...Methods
  /// returns [subString] ranging from 0 through [length].
  /// If length is negative, it will be treated as an offset
  /// from [String.length].
  /// ```dart
  /// final string = 'Hello, How are you?';
  /// print(hello.before(5); // 'Hello'
  /// print(hello.before(-5); // 'Hello, How are'
  /// ```
  String charsBefore(int length) => charsBetween(0, length);

  /// returns [subString] ranging from [length] through [end].
  /// If length is negative, it will be treated as an offset
  /// from [String.length].
  /// ```dart
  /// final string = 'Hello, How are you?';
  /// print(hello.after(7); // 'How are you?'
  /// print(hello.after(-4); // 'you?'
  /// ```
  String charsAfter(int length) => charsBetween(length, this.length);

  /// returns the [subString] ranging from [start] to [end]...
  /// If either start or end is negative, it will be treated
  /// as an offset from [String.length].
  /// ```dart
  /// final string = 'Hello, How are you?';
  /// print(hello.charseq(5, -5); // ', How are'
  /// ```
  String charsBetween(int start, int end) {
    if (start < 0) start = length + start;
    if (end < 0) end = length + end;
    final microVal = start;
    start = min(end, start);
    end = max(end, microVal);
    start = start.clamp(0, length);
    end = end.clamp(0, length);
    return substring(start, end);
  }

  /// returns sub words ranging from 0 through [length].
  /// If length is negative, it will be treated as an offset
  /// from [String.length].
  /// ```dart
  /// final string = 'Hello, How are you?';
  /// print(hello.before(1); // 'Hello'
  /// print(hello.before(-1); // 'Hello, How are'
  /// ```
  String wordsBefore(int length) => wordsBetween(0, length);

  /// returns sub words ranging from [length] through [end].
  /// If length is negative, it will be treated as an offset
  /// from [String.length].
  /// ```dart
  /// final string = 'Hello, How are you?';
  /// print(hello.after(1); // 'How are you?'
  /// print(hello.after(-1); // 'you?'
  /// ```
  String wordsAfter(int length) => wordsBetween(length, this.length);

  /// returns the sub words ranging from [start] to [end]...
  /// If either start or end is negative, it will be treated
  /// as an offset from [String.length].
  /// ```dart
  /// final string = 'Hello, How are you?';
  /// print(hello.charseq(1, -1); // ', How are'
  /// ```
  String wordsBetween(int start, int end) {
    if (words.isEmpty) return '';
    if (start < 0) start = words.length + start;
    if (end < 0) end = words.length + end;
    final microVal = start;
    start = min(end, start);
    end = max(end, microVal);
    start = start.clamp(0, words.length);
    end = end.clamp(0, words.length);
    return words.sublist(start, end).join(' ');
  }

  /// Capitalize first letter of each detected sentences ie.
  /// capitalizing all first letter of words after each full
  /// rest punctuation marks.
  /// ```dart
  /// final string = 'john doe is a good boy. let's talk';
  /// print(string.toSentenceCase());
  /// // 'John doe is a good boy. Let's talk'
  /// ```
  String toSentenceCase() {
    String result = this;
    final regX = RegExp(r'[.?!:;] +(\w)');
    for (var match in regX.allMatches(result)) {
      final rep = match.group(1)!.toUpperCase();
      result = result.replaceRange(match.start, match.end, rep);
    }
    return result.replaceRange(0, 1, charsBefore(1).toUpperCase());
  }

  /// remove all duplicate of each characters specified in
  /// [base]. The default value of base is space character
  /// ```dart
  /// final string = 'Joe's doom is good';
  /// print(string.compact('o')); // 'Joe's dom is god'
  /// ```
  String compact([String base = ' ']) {
    String result = this;
    for (var s in base.split('')) {
      result = result.replaceAll('$s$s', s);
    }
    return this;
  }
}
