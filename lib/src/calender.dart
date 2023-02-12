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
import 'number.dart';

extension Calender on DateTime {
  //...Statics
  static const daysOfTheWeek = [
    'days',
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday',
    'saturday',
    'sunday',
  ];

  static const monthsOfTheYear = [
    'months',
    'january',
    'february',
    'march',
    'april',
    'may',
    'june',
    'july',
    'august',
    'september',
    'october',
    'november',
    'december',
  ];

  //...Getters
  /// ```dart
  /// // 22/7/2022.
  /// ```
  String get standardDate => format('%d/%M/%Yr');

  /// ```dart
  /// // 22/07/2022.
  /// ```
  String get advancedDate => format('%dd/%MM/%Yr');

  /// ```dart
  /// // Tuesday, 22nd of July 2022.
  /// ```
  String get literalDate => format('%Day, %dth of %Month %yr');

  /// ```dart
  /// // Tue, Jul 22, 2022.
  /// ```
  String get shorthandDate => format('%Day.., %Month.. %d, %yr');

  //...Methods
  /// Easily get a formatting of datetime using according to [markdown].
  /// Markdowns according to this context starts with % then supported
  /// key alphabets or words that are case sensitive. Each mark down is
  /// replaced by it's corresponding detail. Below are the few supported
  /// markdowns.
  /// - h or hh : hour in 12 hours
  /// - H or HH : hour in 24 hours
  /// - m or mm : minutes
  /// - d or dd or D or DD or Dd : day
  /// - dth or Dth or : day as in 1st or 23rd
  /// - day or Day or DAY : day of the week
  /// - M or MM : month
  /// - month or Month or MONTH : month of the year
  /// - y or Y or Year : year
  /// ```dart
  /// final date = DateTime.now();
  /// print(date.format(%Day, %dth of %Month %y.));
  /// // Tuesday, 22nd of July 2022.
  /// ```
  /// Still in development...
  String format(String markdown) {
    // hour.
    markdown = markdown.replaceAll(
        RegExp(r'%h+th\b'), (hour % 12).toDigitalString(zero: 12, ordinal: true));
    markdown =
        markdown.replaceAll(RegExp(r'%hh\b'), (hour % 12).toDigitalString(digit: 2, zero: 12));
    markdown = markdown.replaceAll(RegExp(r'%h\b'), (hour % 12).toDigitalString(zero: 12));
    markdown =
        markdown.replaceAll(RegExp(r'%H+th\b'), hour.toDigitalString(zero: 24, ordinal: true));
    markdown = markdown.replaceAll(RegExp(r'%HH\b'), hour.toDigitalString(digit: 2));
    markdown = markdown.replaceAll(RegExp(r'%H\b'), hour.toDigitalString(zero: 24));

    // minute.
    markdown = markdown.replaceAll(RegExp(r'%m+th\b'), minute.toDigitalString(ordinal: true));
    markdown = markdown.replaceAll(RegExp(r'%mm\b'), minute.toDigitalString(digit: 2));
    markdown = markdown.replaceAll(RegExp(r'%m\b'), minute.toDigitalString());

    // day.
    markdown = markdown.replaceAll(RegExp(r'%[Dd]+th\b'), day.toDigitalString(ordinal: true));
    markdown = markdown.replaceAll(RegExp(r'%[Dd][Dd]\b'), day.toDigitalString(digit: 2));
    markdown = markdown.replaceAll(RegExp(r'%[Dd]\b'), day.toDigitalString(digit: 1));

    // week.
    markdown = markdown.replaceAll(RegExp(r'%day\.\.?'), daysOfTheWeek[weekday].substring(0, 3));
    markdown = markdown.replaceAll(
        RegExp(r'%DAY\.\.?'), daysOfTheWeek[weekday].toUpperCase().substring(0, 3));
    markdown = markdown.replaceAll(
        RegExp(r'%Day\.\.?'), daysOfTheWeek[weekday].toSentenceCase().substring(0, 3));
    markdown = markdown.replaceAll(RegExp(r'%day\b'), daysOfTheWeek[weekday]);
    markdown = markdown.replaceAll(RegExp(r'%DAY\b'), daysOfTheWeek[weekday].toUpperCase());
    markdown = markdown.replaceAll(RegExp(r'%Day\b'), daysOfTheWeek[weekday].toSentenceCase());

    // month.
    markdown = markdown.replaceAll(RegExp(r'\b(%M+th)\b'), month.toDigitalString(ordinal: true));
    markdown = markdown.replaceAll(RegExp(r'\b(%MM)\b'), month.toDigitalString(digit: 2));
    markdown = markdown.replaceAll(RegExp(r'\b(%M)\b'), month.toDigitalString());

    markdown = markdown.replaceAll(RegExp(r'%month\.\.'), monthsOfTheYear[month].substring(0, 3));
    markdown = markdown.replaceAll(
        RegExp(r'%MONTH\.\.'), monthsOfTheYear[month].toUpperCase().substring(0, 3));
    markdown = markdown.replaceAll(
        RegExp(r'%Month\.\.'), monthsOfTheYear[month].toSentenceCase().substring(0, 3));
    markdown = markdown.replaceAll(RegExp(r'%month\b'), monthsOfTheYear[month]);
    markdown = markdown.replaceAll(RegExp(r'%MONTH\b'), monthsOfTheYear[month].toUpperCase());
    markdown = markdown.replaceAll(RegExp(r'%Month\b'), monthsOfTheYear[month].toSentenceCase());

    // year.
    markdown = markdown.replaceAll(RegExp(r'%(YEAR|[Yy]ear)\b'), year.toDigitalString(digit: 4));
    markdown = markdown.replaceAll(
        RegExp(r'%[Yy][Yy]?\b'), year.toDigitalString(digit: 2).replaceAll(RegExp(r'\b20'), ''));
    markdown = markdown.replaceAll(RegExp(r'%([Yy]r|[Yy]{3,5})\b'), year.toDigitalString(digit: 4));

    // am/pm.
    markdown = markdown.replaceAll(RegExp(r'%a\b'), hour >= 12 ? 'pm' : 'am');
    markdown = markdown.replaceAll(RegExp(r'%A\b'), hour >= 12 ? 'PM' : 'AM');

    // time zone.
    markdown = markdown.replaceAll(RegExp(r'%z\b'), timeZoneName.toSentenceCase());
    markdown = markdown.replaceAll(RegExp(r'%Z\b'), timeZoneName.toUpperCase());

    // milliseconds.
    markdown = markdown.replaceAll(RegExp(r'%ms\b'), '$millisecondsSinceEpoch'.toSentenceCase());
    markdown = markdown.replaceAll(RegExp(r'%ms\b'), '$millisecondsSinceEpoch'.toUpperCase());

    return markdown;
  }
}
