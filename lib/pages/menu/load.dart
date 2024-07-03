import 'package:flutter/material.dart';
import 'package:trivia/logic/file_manager.dart';

class LoadTriviaPage extends StatefulWidget {
  const LoadTriviaPage({super.key});

  @override
  State<LoadTriviaPage> createState() => _LoadTriviaPageState();
}

class _LoadTriviaPageState extends State<LoadTriviaPage> {

  late final String _path;

  @override
  void initState() {
    super.initState();
    _getDir();
  }

  void _getDir() async {
    String dir = await FileManager.getPath();
    setState(() {
      _path = dir;
    });
  }


  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}