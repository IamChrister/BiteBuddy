import 'dart:io';

/// Handles reading of json files for testing purposes
String fixture(String name) => File('test/fixtures/$name').readAsStringSync();
