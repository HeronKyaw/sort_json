// bin/sort_json.dart

import 'dart:io';
import 'package:sort_json/utils/config_loader.dart';
import 'dart:convert';
import 'package:sort_json/utils/json_sorter.dart';

Future<void> main(List<String> arguments) async {
  if (arguments.isEmpty) {
    stderr.writeln('Usage: sort_json <path/to/json_file>');
    exit(1);
  }

  final jsonFilePath = arguments[0];
  final jsonFile = File(jsonFilePath);
  if (!await jsonFile.exists()) {
    stderr.writeln('Error: $jsonFilePath does not exist.');
    exit(1);
  }

  // Load prioritized keys
  final prioritizedKeys = await loadPrioritizedKeys();
  if (prioritizedKeys.isNotEmpty) {
    stdout.writeln('Prioritized keys loaded from configuration.');
  } else {
    stdout.writeln('No prioritized keys found. Sorting alphabetically.');
  }

  // Read, decode, and sort the JSON file using JsonSorter.
  try {
    final jsonContent = await jsonFile.readAsString();
    final decodedJson = jsonDecode(jsonContent);
    final sortedJson =
        JsonSorter.sortJson(decodedJson, prioritized: prioritizedKeys);

    // Format the sorted JSON with indentation.
    final encoder = JsonEncoder.withIndent('  ');
    final sortedContent = encoder.convert(sortedJson);

    // Write the sorted JSON back to the input file.
    await jsonFile.writeAsString(sortedContent);
    stdout.writeln('File "$jsonFilePath" has been updated with sorted JSON.');
  } catch (e) {
    stderr.writeln('Error processing JSON file: $e');
    exit(1);
  }
}

/// Reads the prioritized keys file path from pubspec.yaml using the unified [ConfigLoader].
/// If no configuration is found, it defaults to "prioritized_keys.json".
Future<String> getPrioritizedKeysFilePath() async {
  final configLoader = ConfigLoader('pubspec.yaml');
  try {
    final config = await configLoader.load();
    if (config is Map && config.containsKey('sort_json')) {
      final sortJsonConfig = config['sort_json'];
      if (sortJsonConfig is Map &&
          sortJsonConfig.containsKey('prioritized_keys')) {
        final filePath = sortJsonConfig['prioritized_keys'];
        if (filePath is String && filePath.isNotEmpty) {
          return filePath;
        }
      }
    }
  } catch (e) {
    stderr.writeln('Error reading pubspec.yaml: $e');
  }
  return 'prioritized_keys.json';
}

/// Loads the prioritized keys from the file determined by [getPrioritizedKeysFilePath]
/// using the unified configuration loader.
Future<List<String>> loadPrioritizedKeys() async {
  final filePath = await getPrioritizedKeysFilePath();
  final configLoader = ConfigLoader(filePath);
  try {
    final data = await configLoader.load();
    if (data is List) {
      return data.whereType<String>().toList();
    }
  } catch (e) {
    stderr.writeln('Error reading $filePath: $e');
  }
  return [];
}
