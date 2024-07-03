import 'package:flutter/material.dart';
import 'package:trivia/logic/file_manager.dart';

class LoadTriviaPage extends StatefulWidget {
  const LoadTriviaPage({super.key});

  @override
  State<LoadTriviaPage> createState() => _LoadTriviaPageState();
}

class _LoadTriviaPageState extends State<LoadTriviaPage> {

  late final String _path;
  late final List<String> _titles;

  @override
  void initState() {
    super.initState();
    _getPath();
  }

  void _getPath() async {
    String path = await FileManager.getPath();
    setState(() {
      _path = path;
    });

    _loadFiles();
  }

  void _loadFiles() async {
    List<String> titles = await FileManager.readDir(_path);
    debugPrint(titles.toString());
    setState(() {
      _titles = titles;
    });
  }


  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}