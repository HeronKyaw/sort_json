# sort_json

A Dart CLI tool for sorting JSON files alphabetically while prioritizing specific keys.

## Features

- Sorts JSON keys in ascending order.
- Supports prioritized keys that should appear first.
- Reads prioritized keys from a JSON file specified in `pubspec.yaml`.

## Installation

### 1. Add to Your Dev Dependencies

If using locally, add this to **pubspec.yaml**:

```shell
dart pub add --dev sort_json
```

Or, if published:

```yaml
dev_dependencies:
  sort_json: ^1.0.0
```

### 2. Configure Prioritized Keys

Create a file for prioritized keys in anywhere of your project, and put the prioritized keys in it:

```json
[
  "important_key",
  "alpha"
]
```

Specify the prioritized keys file path in **pubspec.yaml**:

```yaml
sort_json:
  prioritized_keys: config/prioritized_keys.json
```


This ensures `"important_key"` and `"alpha"` appear first in sorted JSON.

## Usage

Run the CLI tool to sort a JSON file:

```sh
dart run sort_json path/to/json_file.json
```

Example:

```sh
dart run sort_json assets/data.json
```

### **Example Input (`data.json`)**:

```json
{
  "zeta": "last",
  "alpha": "first",
  "beta": "middle",
  "important_key": "should be prioritized"
}
```

### **Output (`data.json` after sorting)**:

```json
{
  "important_key": "should be prioritized",
  "alpha": "first",
  "beta": "middle",
  "zeta": "last"
}
```

## Using Programmatically

You can also use `sort_json` in your Dart code:

```dart
import 'dart:io';
import 'dart:convert';
import 'package:sort_json/json_sorter.dart';
import 'package:sort_json/config_loader.dart';

void main() async {
  final filePath = 'example.json';
  final jsonFile = File(filePath);

  final jsonContent = await jsonFile.readAsString();
  final decodedJson = jsonDecode(jsonContent);

  final loader = ConfigLoader('config/prioritized_keys.json');
  final prioritizedKeys = await loader.load() as List<dynamic>;

  final sortedJson = JsonSorter.sortJson(decodedJson, prioritizedKeys.whereType<String>().toList());

  await jsonFile.writeAsString(JsonEncoder.withIndent('  ').convert(sortedJson));
  print('Sorted JSON written to $filePath');
}
```

## License

This package is licensed under the MIT License.