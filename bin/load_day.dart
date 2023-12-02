import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'session.dart';

Uri get adventUrl {
  final DateTime(:year, :day) = DateTime.now();

  return Uri.parse('https://adventofcode.com/$year/day/$day');
}

Duration get timeTillNextDay {
  final now = DateTime.now();
  final next = now.copyWith(
    hour: 0,
    minute: 0,
    second: 0,
    millisecond: 0,
    microsecond: 0,
    day: now.day + 1,
  );
  final duration = next.difference(now);
  return duration;
}

void main() async {
  print('awaiting next day');

  final future = Future.delayed(timeTillNextDay, loadDay);
  late Timer timer;

  void timerCallback() {
    final duration = timeTillNextDay;
    switch (duration) {
      case Duration(inHours: > 2):
        print('${duration.inHours} hour(s) remaining');
        timer = Timer(Duration(hours: 1), timerCallback);

      case Duration(inHours: 1):
        print(
            '${duration.inHours} hour and ${duration.inMinutes} minutes(s) remaining');
        timer = Timer(Duration(minutes: duration.inMinutes), timerCallback);

      case Duration(inMinutes: > 30):
        print('${duration.inMinutes} minutes(s) remaining');
        timer =
            Timer(Duration(minutes: duration.inMinutes - 30), timerCallback);

      case Duration(inMinutes: > 1):
        print('${duration.inMinutes} minutes(s) remaining');
        timer = Timer(Duration(minutes: 1), timerCallback);

      case Duration(inSeconds: > 1):
        print('${duration.inSeconds} second(s) remaining');
        timer = Timer(Duration(seconds: 1), timerCallback);

      case Duration(inMilliseconds: > 1):
        print('${duration.inMilliseconds}ms remaining');
        timer = Timer(Duration(milliseconds: 1), timerCallback);

      default:
    }
  }

  timer = Timer(Duration.zero, timerCallback);

  await future;
  timer.cancel();
}

Future<void> loadDay() async {
  final currentDay = DateTime.now().day;

  final dayDir = Directory('lib/day$currentDay/');

  if (dayDir.existsSync()) {
    print('day $currentDay already exists!');
    return;
  }

  dayDir.createSync();
  final templateFile = File('lib/_template/solution.dart.txt');
  templateFile.copySync('${dayDir.path}solution.dart');

  final inputTxt = File('lib/day$currentDay/input.txt');

  final inputString = await loadInput();
  inputTxt.writeAsStringSync(inputString, flush: true);

  final solutionFile = File('lib/day$currentDay/solution.dart');

  solutionFile.writeAsStringSync(
    "Future<List<String>> readInput() => File('${inputTxt.path}').readAsLines();",
    mode: FileMode.append,
    flush: true,
  );

  print('ready for day $currentDay!');
  print('$adventUrl');
}

Future<String> loadInput() async {
  final client = HttpClient();
  client.userAgent = 'TekExplorer/dart/advent-of-code-input-downloader';

  HttpClientRequest clientRequest =
      await client.getUrl(adventUrl.resolve('input'));

  clientRequest.cookies.add(Cookie('session', session));

  HttpClientResponse clientResponse = await clientRequest.close();

  final lines = await clientResponse.transform(utf8.decoder).first;
  return lines;
}
