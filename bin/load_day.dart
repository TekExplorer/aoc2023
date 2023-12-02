import 'dart:convert';
import 'dart:io';

import 'session.dart';

Uri get adventUrl {
  final DateTime(:year, :day) = DateTime.now();

  return Uri.parse('https://adventofcode.com/$year/day/$day');
}

void main(List<String> args) async {
  final currentDay = DateTime.now().day;

  final dayDir = Directory('lib/day$currentDay/');

  if (await dayDir.exists()) {
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
