import 'dart:io';
import 'dart:convert';
import 'package:trivia/model/trivia.dart';

class FileManager {
  static readFile(String location) {
    File file = File(location);
    String json = file.readAsStringSync();
    var map = jsonDecode(json) as Map<String, dynamic>;
    return Trivia.fromJson(map);
  }

  static writeFile(Trivia t, String location) {
    String toWrite = jsonEncode(t);
    File file = File(location);
    file.writeAsStringSync(toWrite);
  }
  
}