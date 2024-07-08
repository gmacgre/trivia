import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:trivia/model/trivia.dart';

class FileManager {
  static const JsonEncoder _encoder = JsonEncoder.withIndent('    ');
  static Directory? _directory;

  static Future<String> getPath() async {
    if(_directory == null) {
      Directory newDir = await getApplicationDocumentsDirectory();
      newDir = Directory.fromUri(Uri.directory('${newDir.path}\\triviaApp', windows: true));
      if(!newDir.existsSync()) {
        newDir.create(recursive: true);
      }
      _directory = newDir;
    }
    
    return _directory!.path;
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

  static void writeFile(Trivia t, String location) async {
    String toWrite = _encoder.convert(t);
    File file = File(location);
    file.writeAsStringSync(toWrite);
  }

  static bool validSave(String location) {
    // TODO: Ensure valid file saving
    return true;
  }

  static Future<List<String>> readDir(String location) async {
    Directory dir = Directory(location);
    return await dir.list()
      .where((event) => event.path.endsWith('.json'))
      .map((event) => event.path)
      .toList();
  }

  static Future<List<String>> getTitles(List<String> files) async {
    List<String> toReturn = [];
    File file;
    Trivia trivia;
    for(String loc in files) {
      file = File(loc);
      if(!await file.exists()) {
        continue;
      }
      String json = await file.readAsString();
      // deserialize the file to just get the title
      try {
        trivia = Trivia.fromJson(jsonDecode(json) as Map<String, dynamic>);
      } 
      catch (e) {
        // Just ignore and move on
        continue;
      }
      toReturn.add(trivia.title);
    }
    return toReturn;
  }

  static String encode(Trivia t) {
    return jsonEncode(t);
  }

  static Trivia decode(String trivia) {
    return Trivia.fromJson(jsonDecode(trivia) as Map<String, dynamic>);
  }
  
}