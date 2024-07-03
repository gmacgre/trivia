import 'package:flutter/material.dart';
import 'package:trivia/logic/file_manager.dart';
import 'package:trivia/pages/editor.dart';

class LoadTriviaPage extends StatefulWidget {
  const LoadTriviaPage({super.key});

  @override
  State<LoadTriviaPage> createState() => _LoadTriviaPageState();
}

class _LoadTriviaPageState extends State<LoadTriviaPage> {

  String _path = '';
  List<String> _titles = const [];
  List<String> _paths = const [];
  int selected = -1;

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
    List<String> paths = await FileManager.readDir(_path);

    List<String> titles = await FileManager.getTitles(paths);
    setState(() {
      _titles = titles;
      _paths = paths;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Load Trivia'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => Center(
          child: Column(
            children: [
              const Expanded(
                flex: 1,
                child: SizedBox(),
              ),
              Expanded(
                flex: 7,
                child: Container(
                  decoration: BoxDecoration(border: Border.all(width: 5.0, color: Theme.of(context).dividerColor)),
                  width: constraints.maxWidth * 0.6,
                  child: ListView(
                    children: _titles.asMap().entries.map((title) => ListTile(
                      title: Text(title.value),
                      selected: title.key == selected,
                      onTap: () {
                        setState(() {
                          selected = title.key;
                        });
                      },
                    )).toList(),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: SizedBox(
                    height: constraints.maxHeight * 0.05,
                    child: ElevatedButton(
                      onPressed: (selected == -1) ? null : () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => TriviaEditorPage(location: _paths[selected], title: _titles[selected])
                          ),
                        );
                      },
                      child: const Text('Load'),
                    ),
                  ),
                ),
              ),
              const Expanded(
                flex: 1,
                child: SizedBox(),
              ),
            ],
          )
        ),
      ),
    );
  }
}