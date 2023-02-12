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

import 'grammar.dart';

extension ID<T> on Symbol {
  //...Statics
  static int _iDLock = 0;

  //...Methods
  /// Create a new unique symbol. The created symbol starts
  /// with 'sID_' acronym for 'static ID'. Can also come in
  /// handy during runtime based serializations. Get string
  /// version co the created Symbol via [ID.name]
  /// ```dart
  /// print(ID.create()); // sID_356
  /// ```
  static Symbol create() {
    _iDLock++; // lock ID static...
    return Symbol('sID_$_iDLock');
  }

  /// Corresponding  symbol for  String  representation of
  /// [value]. Same as calling [Symbol] constructor on the
  /// string representation of [value]
  /// ```dart
  /// var value = Symbol('book');
  /// print(symbolize(value)); // Symbol('book')
  /// value = 'book';
  /// print(symbolize(value)); // Symbol('book')
  /// value = 1;
  /// print(symbolize(value)); // Symbol('1')
  /// value = #book;
  /// print(symbolize(value)); // Symbol('book')
  /// ```
  static Symbol symbolize(value) {
    if (value is Symbol) return value;
    String str = value.toString().compact(' _.');
    return Symbol(str.replaceAll(' ', '_'));
  }

  //...UTILITY
  /// The name that identify with with this symbol. Returns
  /// a string that matches the text that appears after [#]
  /// in a literal symbol.
  /// ```dart
  /// var symbol = #book_of_IDs;
  /// print(symbol.name); // 'book_of_IDs'
  /// symbol = Symbol('book of IDs);
  /// print(symbol.name); // 'book_of_IDs'
  /// ```
  String get name => toString().charsBetween(8, -2);

  /// Thread is calculated based on how dots can easily get
  /// affect the naming of a symbol. Thread is the array of
  /// sub  symbol that we  can get after splitting via dots
  /// ```dart
  /// print(#lol.omg); // [Symbol('lol'), Symbol('omg')]
  /// ```
  Iterable<Symbol> get thread => name.split('.').map(symbolize);

  /// Add [symbol] to [thread].
  /// ```dart
  /// print(#rey + #manuel); //#rey.manuel
  /// final symbol = Symbol('rey');
  /// print(symbol + symbol); // #rey.rey
  /// ```
  Symbol operator +(Symbol sym) => [this, sym].combine;

  /// Add Symbol from [string] to [thread]
  /// ```dart
  /// print(#rey & 'manuel'); //#rey.manuel
  /// final symbol = Symbol('rey');
  /// print(symbol & symbol.name); // #rey.rey
  /// ```
  Symbol operator &(String str) => this + symbolize(str);

  /// get sub symbol at [index]. If thread is empty or if
  /// [index] is greater than  [thread]  length, invoking
  /// this operator will throw a State error
  /// ```dart
  /// print(#rey.manuel.xi[1]); // #manuel
  /// print(#rey.manuel.xi[3]); // [StateError(...)]
  /// ```
  Symbol operator [](int index) => thread.toList()[index];

  /// Add [symbol] to [thread]
  /// ```dart
  /// print((#rey).to(#manuel)); //#rey.manuel
  /// final symbol = Symbol('rey');
  /// print(symbol.to(symbol)); // #rey.rey
  /// ```
  Symbol to(Symbol symbol) => [this, symbol].combine;

  /// Add Symbol from [string] to [thread]
  /// ```dart
  /// print((#rey).and('manuel')); //#rey.manuel
  /// final symbol = Symbol('rey');
  /// print(symbol.and(symbol.name)); // #rey.rey
  /// ```
  Symbol and(String string) => this + symbolize(string);

  /// Returns true if [name] starts with [symbol] name. See
  /// [String.startsWith];   Whether symbol's [name] starts
  /// with a match of given [symbol]'s name.
  /// ```dart
  /// const symbol = Symbol('RCore is open source');
  /// print(symbol.startsWith(#RCo)); // true
  /// ```
  bool startsWith(Symbol symbol) => name.startsWith(symbol.name);

  /// Returns true if [name] ends with [symbol] name. Check
  /// out [String.startsWith]; Whether this symbol's [name]
  /// ends with a match of given [symbol]'s name.
  /// ```dart
  /// const symbol = Symbol('RCore is open source');
  /// print(symbol.endsWith(#rce)); // true
  /// ```
  bool endsWith(Symbol symbol) => name.endsWith(symbol.name);

  /// Returns true if [name] contains [symbol] name. Check
  /// out [String.startsWith]; Whether this symbol's [name]
  /// contains a match of given [symbol]'s name.
  /// ```dart
  /// const symbol = Symbol('RCore is open source');
  /// print(symbol.contains(#is)); // true
  /// ```
  bool contains(Symbol symbol) => name.contains(symbol.name);

  /// Grammatical representation of this Symbol The returned
  /// string will have  it's underscores replaced with space
  /// character.
  /// ```dart
  /// print(#hello_world._rey); // Hello world. Rey
  /// ```
  String toLethalString() {
    final lit = name.replaceAll('_', ' ');
    return lit.trim().toSentenceCase();
  }
}

extension IDs on Iterable<Symbol> {
  /// Same as calling [ID.+] on each [Symbol] in iterable but of
  /// course, a more effective way of doing it. Calling this will
  /// reverse the effect of calling thread on a Symbol. Check out
  /// [ID.combine]. They pretty much do the same thing.
  /// ```dart
  /// print([#lol, #omg].combine); // #lol.omg
  /// ```
  Symbol get combine => Symbol(map((e) => e.name).join('.'));
}
