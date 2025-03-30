import 'dart:io';
import 'dart:convert';

import 'package:sort_json/sort_json.dart';
import 'package:test/test.dart';

void main() {
  group('ConfigLoader.load', () {
    test('Loads prioritized keys from a file', () async {
      final tempFile = File('test_prioritized_keys.json');
      await tempFile.writeAsString(jsonEncode(["important_key", "alpha"]));

      final loader = ConfigLoader('test_prioritized_keys.json');
      final result = await loader.load();

      expect(result, equals(["important_key", "alpha"]));

      await tempFile.delete();
    });

    test('Handles non-existent file gracefully', () async {
      final loader = ConfigLoader('non_existent.json');
      final result = await loader.load();

      expect(result, equals([])); // Expect an empty list instead of an exception.
    });

    test('Handles invalid JSON format gracefully', () async {
      final tempFile = File('invalid.json');
      await tempFile.writeAsString("invalid json");

      final loader = ConfigLoader('invalid.json');
      final result = await loader.load();

      expect(result, equals([])); // Expect an empty list instead of throwing an exception.

      await tempFile.delete();
    });
  });
}
