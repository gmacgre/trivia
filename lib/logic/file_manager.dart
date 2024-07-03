import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:trivia/model/trivia.dart';

class FileManager {
  static Future<String> getPath() async {
    Directory newDir = await getApplicationDocumentsDirectory();
    newDir = Directory.fromUri(Uri.directory('${newDir.path}\\triviaApp', windows: true));
    if(!newDir.existsSync()) {
      newDir.create(recursive: true);
    }
    return newDir.path;
  }

  


  static bool saveExists(String location) {
    File file = File(location);
    return file.existsSync();
  }

  static Trivia readFile(String location) {
    File file = File(location);
    String json = file.readAsStringSync();
    var map = jsonDecode(json) as Map<String, dynamic>;
    return Trivia.fromJson(map);
  }

  static void writeFile(Trivia t, String location) {
    String toWrite = jsonEncode(t);
    File file = File(location);
    file.writeAsStringSync(toWrite);
  }

  static bool validSave(String location) {
    // TODO: Ensure valid file saving
    return true;
  }
  
}