import 'dart:convert';
import 'dart:io';

import 'package:sort_json/utils/json_sorter.dart';
import 'package:sort_json/utils/config_loader.dart';

void main() async {
  // Example: Load some JSON from a file.
  final jsonFilePath = 'sample.json';
  final jsonFile = File(jsonFilePath);
  final jsonContent = await jsonFile.readAsString();
  final decodedJson = jsonDecode(jsonContent);

  // Load prioritized keys from your configuration file.
  final loader = ConfigLoader('config/prioritized_keys.json');
  final prioritizedKeys = await loader.load() as List<dynamic>;

  // Ensure keys are strings.
  final prioritized = prioritizedKeys.whereType<String>().toList();

  // Sort the JSON using the JsonSorter.
  final sortedJson = JsonSorter.sortJson(decodedJson, prioritized: prioritized);

  // Print or use the sorted JSON.
  print(JsonEncoder.withIndent('  ').convert(sortedJson));
}
