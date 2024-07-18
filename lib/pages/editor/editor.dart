import 'package:flutter/material.dart';
import 'package:trivia/logic/file_manager.dart';
import 'package:trivia/model/section/jeopardy_section.dart';
import 'package:trivia/model/section/section.dart';
import 'package:trivia/model/trivia.dart';
import 'package:trivia/pages/editor/section_editor.dart';
import 'package:trivia/pages/presenter/presenter.dart';

class TriviaEditorPage extends StatefulWidget {
  const TriviaEditorPage({
    super.key,
    required this.location,
    this.title = ''
  });

  final String location;
  final String title;

  @override
  State<TriviaEditorPage> createState() => _TriviaEditorPageState();
}

class _TriviaEditorPageState extends State<TriviaEditorPage> {

  late Trivia trivia;
  int selected = -1;

  @override
  void initState() {
    super.initState();
    _readLocation();
  }

  void _readLocation() {
    trivia = Trivia(title: widget.title, sections: []);
    if(FileManager.saveExists(widget.location)) {
      trivia = FileManager.readFile(widget.location);
    }
    else {
      FileManager.writeFile(trivia, widget.location);
    }
    setState(() {
      trivia = trivia;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> sections = trivia.sections.asMap().entries.map((e) => ListTile(
      title: Text(e.value.title),
      selected: selected == e.key,
      onTap: () {
        setState(() {
          selected = e.key;
        });
      },
    )).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(trivia.title),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Select a Section to Edit',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(border: Border.all(color: Theme.of(context).disabledColor, width: 5.0)),
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: ListView(
                    children: sections,
                  ),
                ),
              )
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width * 0.6,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          trivia.sections.add(JeopardySection(categories: [], title: 'New Jeopardy'));
                        });
                      }, 
                      child: const Text('Add New Section')
                    ),
                    ElevatedButton(
                      onPressed: (selected == -1) ? null : () async {
                        Section? newData = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SectionEditor(section: trivia.sections[selected]),
                          )
                        );
                        setState(() {
                          trivia.sections[selected] = (newData != null) ? newData : trivia.sections[selected];
                          selected = -1;
                        });
                      }, 
                      child: const Text('Edit')
                    ),
                    ElevatedButton(
                      onPressed: (selected == -1) ? null : () {
                        setState(() {
                          trivia.sections.removeAt(selected);
                          selected = -1;
                        });
                      }, 
                      child: const Text('Delete')
                    ),
                  ],
                )
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width * 0.5,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    FilledButton(
                      onPressed: () {
                        FileManager.writeFile(trivia, widget.location);
                      }, 
                      child: const Text('Save')
                    ),
                    FilledButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => PresenterPage(trivia: trivia)
                          )
                        );
                      }, 
                      child: const Text('Present')
                    ),
                  ],
                )
              ),
            ),
          ],
        )
      )
    );
  }
}