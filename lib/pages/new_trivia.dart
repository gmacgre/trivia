import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:trivia/pages/editor.dart';

class NewTriviaPage extends StatefulWidget {
  const NewTriviaPage({super.key});

  @override
  State<NewTriviaPage> createState() => _NewTriviaPageState();
}

class _NewTriviaPageState extends State<NewTriviaPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final Directory dir;
  String saveLocation = '';
  String newTitle = '';

  @override
  void initState() {
    super.initState();
    _getdir();
  }

  void _getdir() async {
    Directory newDir = await getApplicationDocumentsDirectory();
    newDir = Directory.fromUri(Uri.directory('${newDir.path}\\triviaApp', windows: true));
    if(!newDir.existsSync()) {
      newDir.create(recursive: true);
    }
    setState(() {
      dir = newDir;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Enter Trivia Title',
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title.';
                      }
                      // TODO: Ensure valid file saving
                      String tocheck = _convertTitletoSaveId(value);
                      File f = File('${dir.path}$tocheck.json');
                      if(f.existsSync()) {
                        debugPrint('File Exists!!');
                        return 'File Already Exists.';
                      }
                      saveLocation = f.path;
                      newTitle = value;
                      return null;
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }
                    // Make a new Object to Write and Save
                    // Launch a new TriviaEditPage Object with the basic parameters
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => TriviaEditorPage(location: saveLocation, title: newTitle)),
                    );
                  },
                  child: const Text('Save'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  String _convertTitletoSaveId(String input) {
    input = input.toLowerCase();
    input.replaceAll(RegExp(' +'), '_');
    return input;
  }
}