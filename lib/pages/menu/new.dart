import 'package:flutter/material.dart';
import 'package:trivia/logic/file_manager.dart';
import 'package:trivia/pages/editor.dart';

class NewTriviaPage extends StatefulWidget {
  const NewTriviaPage({super.key});

  @override
  State<NewTriviaPage> createState() => _NewTriviaPageState();
}

class _NewTriviaPageState extends State<NewTriviaPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final String _dir;
  String saveLocation = '';
  String newTitle = '';

  @override
  void initState() {
    super.initState();
    _getdir();
  }

  void _getdir() async {
    String newDir = await FileManager.getPath();
    setState(() {
      _dir = newDir;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Trivia'),
      ),
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
                      String tocheck = _convertTitletoSaveId(value);
                      String location = '$_dir$tocheck.json';
                      if(!FileManager.validSave(location)) {
                        return 'Illegal Characters Used';
                      }
                      if(FileManager.saveExists(location)) {
                        return 'File Already Exists.';
                      }
                      saveLocation = location;
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
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => TriviaEditorPage(location: saveLocation, title: newTitle)
                      ),
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