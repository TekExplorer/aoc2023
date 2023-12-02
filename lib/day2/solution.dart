// ignore_for_file: unused_import

import 'dart:io';

import 'package:collection/collection.dart';

Future<List<String>> readInput() => File('lib/day2/input.txt').readAsLines();
void main(List<String> args) {
  // solveA();
  solveB();
}

Future<void> solveA() async {
  //
  final lines = await readInput();
  final games = lines.map((e) => (e.gameId, e.pulls));

  final redLimits = 12;
  final greenLimits = 13;
  final blueLimits = 14;

  final possibleGames = games.where((game) {
    final (_, pulls) = game;
    for (final pull in pulls) {
      if (pull.blue > blueLimits) return false;
      if (pull.green > greenLimits) return false;
      if (pull.red > redLimits) return false;
    }
    return true;
  });
  final possibleIds = possibleGames.map((e) => e.$1);
  print(possibleIds.sum);
}

// min possible cubes // get max cubes
Future<void> solveB() async {
  //
  final lines = await readInput();
  final games = lines.map((e) => (e.gameId, e.pulls));

  final powers = games.map((game) {
    final (_, pulls) = game;
    int maxBlue = 0;
    int maxGreen = 0;
    int maxRed = 0;

    for (final pull in pulls) {
      if (pull.red > maxRed) maxRed = pull.red;
      if (pull.green > maxGreen) maxGreen = pull.green;
      if (pull.blue > maxBlue) maxBlue = pull.blue;
    }
    // power
    return maxBlue * maxGreen * maxRed;
  });

  print(powers.sum);
}

typedef Pull = ({int blue, int green, int red});

extension on String {
  int get gameId {
    final gameId = RegExp(r'Game (\d+):').firstMatch(this)!.group(1)!;
    return int.parse(gameId);
  }

  List<Pull> get pulls {
    final listStr = split(':').last.trim();
    final segments = listStr.split('; ');
    return segments.map(parseSegment).toList();
  }

  // 1 blue, 8 green etc
  Pull parseSegment(String segment) {
    final parts = segment.split(',').map((e) => e.trim());
    int red = 0;
    int green = 0;
    int blue = 0;
    for (final part in parts) {
      final innerParts = part.split(' ');
      assert(innerParts.length == 2);
      final n = int.parse(innerParts.first);
      final t = innerParts.last;
      switch (t) {
        case 'red':
          red = n;
        case 'blue':
          blue = n;
        case 'green':
          green = n;
        default:
          throw StateError('something went wrong in parse segment');
      }
    }
    return (blue: blue, green: green, red: red);
  }
}
