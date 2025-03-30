import 'dart:convert';
import 'dart:io';
import 'package:yaml/yaml.dart';

/// A utility class to load and decode configuration files.
/// This class auto-detects whether the file is JSON or YAML based on its extension.
class ConfigLoader {
  final String filePath;

  ConfigLoader(this.filePath);

  /// Loads and decodes the configuration file.
  /// - For files ending with .json, it decodes the content as JSON.
  /// - For files ending with .yaml or .yml, it decodes the content as YAML.
  /// Returns `null` if the file is not found or if the file extension is unsupported.
  Future<dynamic> load() async {
    final file = File(filePath);
    if (!await file.exists()) {
      print('Warning: File not found: $filePath');
      return []; // Return an empty list instead of throwing an exception.
    }

    final content = await file.readAsString();
    final extension = filePath.split('.').last.toLowerCase();

    try {
      if (extension == 'json') {
        return jsonDecode(content);
      } else if (extension == 'yaml' || extension == 'yml') {
        return loadYaml(content);
      } else {
        print('Warning: Unsupported file extension: .$extension');
        return []; // Return empty list for unsupported file types.
      }
    } catch (e) {
      print('Error decoding file $filePath: $e');
      return []; // Return empty list on JSON/YAML parse errors.
    }
  }
}
