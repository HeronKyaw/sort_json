// lib/config_loader.dart
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
  /// Throws an Exception if the file is not found or if the file extension is unsupported.
  Future<dynamic> load() async {
    final file = File(filePath);
    if (!await file.exists()) {
      throw Exception('File not found: $filePath');
    }
    final content = await file.readAsString();
    final extension = filePath.split('.').last.toLowerCase();
    if (extension == 'json') {
      try {
        return jsonDecode(content);
      } catch (e) {
        throw Exception('Error decoding JSON from $filePath: $e');
      }
    } else if (extension == 'yaml' || extension == 'yml') {
      try {
        return loadYaml(content);
      } catch (e) {
        throw Exception('Error decoding YAML from $filePath: $e');
      }
    } else {
      throw Exception('Unsupported file extension: .$extension');
    }
  }
}
