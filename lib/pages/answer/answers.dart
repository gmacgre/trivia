import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trivia/logic/file_manager.dart';
import 'package:trivia/model/player.dart';
import 'package:trivia/model/trivia.dart';

class AnswersPage extends StatefulWidget {
  final String trivia;
  const AnswersPage({
    super.key,
    required this.trivia
  });

  @override
  State<AnswersPage> createState() => _AnswersPageState();
}

class _AnswersPageState extends State<AnswersPage> {
  Trivia _trivia = Trivia(title: 'DebugTitle', sections: []);
  int _currentSection = -1;
  final List<Player> _players = [];
  
  final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
    shape: const CircleBorder(),
    backgroundColor: Colors.blue, // <-- Button color
    foregroundColor: Colors.white, // <-- Splash color
  );
  
  


  @override
  void initState() {
    _trivia = FileManager.decode(widget.trivia);
    super.initState();
  }

  // Builds a Player Adder and Section Selector, and any subchild if needed.
  @override
  Widget build(BuildContext context) {

    // Player Adder
    List<Widget> base = [];
    base.addAll(_players.asMap().entries.map((e) {
      TextEditingController nameController = TextEditingController(
        text: e.value.name
      );
      TextEditingController scoreController = TextEditingController(
        text: '${e.value.score}'
      );
      return Expanded(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: nameController,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _players[e.key].name = nameController.text;
                    });
                    DesktopMultiWindow.invokeMethod(0, 'setName', {
                      'name': nameController.text,
                      'index': e.key
                    });
                  },
                  style: buttonStyle,
                  child: const Icon(Icons.check)
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    controller: scoreController,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _players[e.key].score = int.parse(scoreController.text);
                    });
                    _updateScore(e.key, int.parse(scoreController.text));
                  },
                  style: buttonStyle,
                  child: const Icon(Icons.check)
                )
              ],
            ),
          ],
        ),
      );
    }));

    base.add(
      ElevatedButton(
        onPressed: () {
          setState(() {
            _players.add(Player(score: 0, name: 'New'));  
          });
          DesktopMultiWindow.invokeMethod(0, 'newPlayer', {
            'name': 'New',
            'score': 0
          });
        }, 
        style: buttonStyle,
        child: const Icon(Icons.add)
      )
    );

    
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            IconButton(
              onPressed: () {
                DesktopMultiWindow.invokeMethod(0, 'pop');
              },
              icon: const Icon(Icons.flag)
            )
          ],
        ),
      )
    );
  }

  _updateScore(int idx, int newScore) {
    
  }
}
