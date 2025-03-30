
import 'package:sort_json/sort_json.dart';
import 'package:test/test.dart';

void main() {
  group('JsonSorter.sortJson', () {
    test('Sorts JSON keys alphabetically', () {
      final inputJson = {
        "zeta": "last",
        "alpha": "first",
        "beta": "middle"
      };

      final expectedOutput = {
        "alpha": "first",
        "beta": "middle",
        "zeta": "last"
      };

      expect(JsonSorter.sortJson(inputJson, prioritized: []), equals(expectedOutput));
    });

    test('Sorts JSON with prioritized keys first', () {
      final inputJson = {
        "zeta": "last",
        "alpha": "first",
        "beta": "middle",
        "important_key": "should be prioritized"
      };

      final prioritizedKeys = ["important_key", "alpha"];

      final expectedOutput = {
        "important_key": "should be prioritized",
        "alpha": "first",
        "beta": "middle",
        "zeta": "last"
      };

      expect(JsonSorter.sortJson(inputJson, prioritized: prioritizedKeys), equals(expectedOutput));
    });

    test('Handles empty JSON input', () {
      final inputJson = {};

      expect(JsonSorter.sortJson(inputJson, prioritized: []), equals({}));
    });

    test('Handles missing prioritized keys gracefully', () {
      final inputJson = {
        "zeta": "last",
        "alpha": "first",
        "beta": "middle"
      };

      final prioritizedKeys = ["non_existent_key", "alpha"];

      final expectedOutput = {
        "alpha": "first",
        "beta": "middle",
        "zeta": "last"
      };

      expect(JsonSorter.sortJson(inputJson, prioritized: prioritizedKeys), equals(expectedOutput));
    });

    test('Handles deeply nested JSON objects', () {
      final inputJson = {
        "zeta": "last",
        "alpha": {
          "x": 1,
          "a": 2
        },
        "beta": "middle"
      };

      final expectedOutput = {
        "alpha": {
          "a": 2,
          "x": 1
        },
        "beta": "middle",
        "zeta": "last"
      };

      expect(JsonSorter.sortJson(inputJson, prioritized: []), equals(expectedOutput));
    });
  });
}
