import 'dart:io';

import 'package:collection/collection.dart';

Future<void> main() async {
  //
  final lines = await readInput();

  final values = lines.map((line) => line.calibrationValue).toList();

  for (final (i, str) in lines.indexed) {
    print('${values[i]}\t$str');
  }

  print(values.sum);
}

extension on String {
  int get calibrationValue {
    final matches = digitRegex.allMatches(this);

    final first = matches.first.group(1)!.toInt();
    final last = matches.last.group(1)!.toInt();

    return int.parse('$first$last');
  }

  int toInt() {
    int? maybeInt = int.tryParse(this);
    maybeInt ??= Expressions.intOfName(this);
    if (maybeInt.isNegative) throw StateError('not found!');
    return maybeInt;
  }
}

// final digitRegex = RegExp(r'(\d)');
final digitRegex = RegExp('(?=(${Expressions.expressions.join('|')}))');

enum Expressions {
  digit(r'\d'),
  one,
  two,
  three,
  four,
  five,
  six,
  seven,
  eight,
  nine,
  ;

  final String? _exp;
  String get exp => _exp ?? name;
  const Expressions([this._exp]);

  static List<String> get expressions => values.map((e) => e.exp).toList();

  static int intOfName(String name) => values.indexWhere((e) => e.name == name);
}

Future<List<String>> readInput() => File('lib/day1/input.txt').readAsLines();
