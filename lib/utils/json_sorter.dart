// lib/json_sorter.dart

/// A utility class that provides methods for sorting JSON data.
class JsonSorter {
  /// Compares two keys [a] and [b] based on the [prioritized] list.
  ///
  /// If both keys are in [prioritized], their order in the list is used.
  /// If only one is prioritized, that key is considered "smaller".
  /// Otherwise, the keys are compared alphabetically.
  static int keyComparator(String a, String b, List<String> prioritized) {
    final aIndex = prioritized.indexOf(a);
    final bIndex = prioritized.indexOf(b);

    if (aIndex != -1 && bIndex != -1) {
      return aIndex.compareTo(bIndex);
    }
    if (aIndex != -1) return -1;
    if (bIndex != -1) return 1;

    return a.compareTo(b);
  }

  /// Recursively sorts a JSON structure (which can be a [Map] or [List])
  /// according to the prioritized keys.
  ///
  /// If the input is a [Map], the keys are sorted using [keyComparator].
  /// If it is a [List], each element is recursively processed.
  /// For other data types, the value is returned unchanged.
  static dynamic sortJson(dynamic input,
      {List<String> prioritized = const []}) {
    if (input is Map) {
      final sortedMap = Map.fromEntries(
        input.entries.toList()
          ..sort((a, b) => keyComparator(a.key, b.key, prioritized)),
      );

      // Recursively sort nested objects.
      sortedMap.forEach((key, value) {
        sortedMap[key] = sortJson(value, prioritized: prioritized);
      });
      return sortedMap;
    } else if (input is List) {
      return input
          .map((element) => sortJson(element, prioritized: prioritized))
          .toList();
    } else {
      return input;
    }
  }
}
